/**
    Description :   S2 – Work Order Appointment Import Routine (Business Continuity Management)
**/
/*
    Created By  : Shruti Moghe
    Created On  : 29/03/2017
    Service Req : SR_OptiMUS_NG_024
    Change History :
    CH01 #SR_OptiMUS_NG_046 #24/05/2017 #Shruti Moghe #Added condition for cancelled appointment reprocessing
    CH02 : 16/06/2017 # SR_OptiMUS_NG_051 # Shruti Moghe # Added condition for rejected appointment logic
    CH04 # RE: NGS Import Fail #Shruti Moghe # incident FIx 
*/
    
global class NGS_S2_WO_Appointment_Import{
    public static List <String> header_row = new List <String>();
    public static List <List<String>> fileValues = new List <List<String>>();// This field holds the entair file rows after reading the file 
    public static integer CountCreated= 0;
    public static integer CountUpdated= 0;
    public static integer CountFailed= 0;
    webservice static String ReadandparseCSV(String ParentRecodID){
        List<NGS_Import__c> lstNGSImport = new List<NGS_Import__c>();
        Map<String, NGS_Note__c> mapNotes = new Map<String, NGS_Note__c>();
        List<NGS_Note__c> LstNotes = new List<NGS_Note__c>();
        lstNGSImport = [Select id, name, Last_Import_Result__c,Last_Import_Routine_Run_Time__c from NGS_Import__c where id=:ParentRecodID];
        List<Attachment> attach = new List<Attachment>();
        attach=[Select id,Name,Body,contentType,parentid from Attachment where ParentId =:ParentRecodID and (NOT name like '%_Processed%') LIMIT 1];
        if(attach==null || !(attach.size()>0)) return 'Please attach a new file to Import the data';
        List<NGS_Import_CSV__c> csvdataList = new List<NGS_Import_CSV__c>();
        List<NGS_Work_Order_Appointment__c> ApptList = new List<NGS_Work_Order_Appointment__c>();
        Map<String, NGS_Job_Code__c> jobMap = new Map<String,NGS_Job_Code__c>();
        Map<String,NGS_Task__c> NGSTaskMap = new Map<String,NGS_Task__c>();
        List<NGS_Task__c> TaskListToInsert= new List<NGS_Task__c>();
        Set<String> Jobcodes = new Set<String>();
        Set<String> PostCodeSet = new Set<String>();
        Set<ID> ApptIDsTodelete = new Set<ID>();
        Map<String,NGS_Work_Order_Appointment__c> ApptMap = new Map<String,NGS_Work_Order_Appointment__c>();
        List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
        mail.setBCCAddresses(new String[] { 'shruti.moghe@morrisonus.com'});
        for(NGS_Work_Order_Appointment__c appt : [select id, name,Rejected__c,Status__c,Employee_ID__c,Cancelled__c from NGS_Work_Order_Appointment__c]) ApptMap.put(appt.name, appt);
        String error ='';
        try{
            if(attach!=null && attach.size()>0){            
                Blob fileBody = attach[0].Body;                        
               // fileValues = EON_CsvReader.CampaignCSV( EncodingUtil.base64decode(fileBody));
                //fileValues = EON_CsvReader.CampaignCSV(fileBody.toString());
               fileValues =EON_CsvReader.CampaignCSV(  blobToString( fileBody,'ISO-8859-1'));
                
                system.debug('fileValues Size = '+fileValues.size());
                attach[0].name = String.valueof(system.today().format())+'_Processed.csv';
                update attach[0];
                if(fileValues!=null && fileValues.size() > 0 && fileValues.get(0)!=null && fileValues.get(0).get(0) != '' ){ 
                    header_row = fileValues[0];//first row of the file contains the Header names                                                        
                    integer rowNumber = 0, rCount = 0;   
                    String allMPAN = '', allMPRN = '';
                    for(list <String> row: fileValues){                            
                        system.debug('**Row '+row);                 
                        if (rCount == 0){                    
                            rCount++;
                            continue;                   
                        }  
                        else {
                                NGS_Import_CSV__c csv = new NGS_Import_CSV__c();
                                csv.name=Row[0];
                                csv.Addr_Line_1__c=Row[12];
                                csv.Addr_Line_2__c=Row[13];
                                csv.Appointment_Type__c=Row[6];
                                csv.Appt_Finish_Date__c=Row[5];
                                csv.Appt_Start_Time__c=Row[4];
                                csv.Change_Type__c=Row[1];
                                csv.City__c=Row[14];
                                csv.Country__c=Row[17];
                                csv.County__c=Row[15];
                                csv.Duration__c=Row[10];
                                csv.Job_Description__c=Row[3];
                                csv.Latitude__c=Row[18];
                                csv.Longitude__c=Row[19];
                                csv.Message_Date__c=Row[7];
                                csv.Mpan__c=Row[8];
                                csv.Mprn__c=Row[9];
                                csv.Note_Text__c=Row[21];
                                csv.Note_Type__c=Row[20];
                                csv.Post_Code__c=Row[16];
                                if(csv.Post_Code__c != null &&  csv.Post_Code__c != '' &&  csv.Post_Code__c.contains(' ')){
                                    String postCodeStr = '';
                                    postCodeStr =  csv.Post_Code__c.substringBefore(' ') + ' ' +  csv.Post_Code__c.substringAfter(' ').substring(0,1);
                                    PostCodeSet.add(postCodeStr);
                                }
                                csv.Service_Provider_Id__c=Row[11];
                                csv.Std_Job_Id__c=Row[2];
                                Jobcodes.add(csv.Std_Job_Id__c);
                                csv.Work_Order_Number__c=Row[0];
                                csvdataList.add(csv);
                            }
                        rCount++;
                    }
                }
                    List<NGS_Postcode__c> ngsPostCodesList = new List<NGS_Postcode__c>();
                    ngsPostCodesList=[select id, name, Sub_Region__c, Sub_Region__r.Region__c, Sub_Region__r.Oracle_Bucket_ID__c, Sub_Region__r.Default__c,Sub_Region__r.ECO__c,Sub_Region__r.Maintenance__c,Sub_Region__r.New_Connections__c,Sub_Region__r.Smart__c from NGS_Postcode__c where name IN:PostCodeSet];
                    Map<String, List<NGS_Postcode__c>> PostcodeMap = new Map<String, List<NGS_Postcode__c>>();
                    for(NGS_Postcode__c code : ngsPostCodesList){
                        String postCodeStr = '';
                        postCodeStr =  code.name.substringBefore(' ') + ' ' +  code.name.substringAfter(' ').substring(0,1);
                        if(!PostcodeMap.containsKey(postCodeStr))
                        PostcodeMap.put(postCodeStr,new List<NGS_Postcode__c>());
                        PostcodeMap.get(postCodeStr).add(code);
                    }
                    List<NGS_Job_Code__c> joblist = new List<NGS_Job_Code__c>([select id, name,Job_Description__c,Bucket_Type__c from NGS_Job_Code__c where name in:Jobcodes]);
                    for(NGS_Job_Code__c Job : joblist){
                        jobMap.put(Job.name, Job);
                    }                   
                    for(NGS_Import_CSV__c csv : csvdataList){
                        NGS_Work_Order_Appointment__c appt = new NGS_Work_Order_Appointment__c();
                        if(ApptMap.containsKey(csv.Work_Order_Number__c) && csv.Change_Type__c=='UPDATE'){
                            appt.id= ApptMap.get(csv.Work_Order_Number__c).id;
                            ApptIDsTodelete.add(appt.id);
                        }
                        if(ApptMap.containskey(csv.Work_Order_Number__c) && csv.Change_Type__c!='UPDATE' && (ApptMap.get(csv.Work_Order_Number__c)!=null && ApptMap.get(csv.Work_Order_Number__c).Cancelled__c==null)){
                            csv.Status__c='Appointments Unsuccessful';
                            CountFailed = CountFailed+1;
                        }
                        else if(!ApptMap.containskey(csv.Work_Order_Number__c) && csv.Change_Type__c=='UPDATE'){
                            csv.Status__c='Appointments Unsuccessful';
                            CountFailed = CountFailed+1;
                        }
                        else{
                            //CH01.start
                            if(ApptMap.containskey(csv.Work_Order_Number__c) && csv.Change_Type__c=='NEW'){
                                appt.Cancelled__c=null;
                                appt.id= ApptMap.get(csv.Work_Order_Number__c).id;
                                appt.Employee_ID__c=null;
                                appt.Cancelled__c=null;
                                appt.Cancellation_Notes__c=null;
                                appt.Assignment_sent_to_IFS__c=null;
                                appt.h_IFS_Duration__c='';
                            }
                            //CH01.end
                            appt.name = csv.Work_Order_Number__c;
                            appt.Address_Line_1__c= csv.Addr_Line_1__c;
                            appt.Address_Line_2__c=csv.Addr_Line_2__c;
                           /* appt.Appointment_Finish_Time__c=DateTime.Parse(csv.Appt_Finish_Date__c);
                            appt.Appointment_Start_Time__c=DateTime.Parse(csv.Appt_Start_Time__c);*/ //CH04. commented 
                            //CH04 ,new.start
                            appt.Appointment_Finish_Time__c=sValidateDateTime(csv.Appt_Finish_Date__c);
                            appt.Appointment_Start_Time__c=sValidateDateTime(csv.Appt_Start_Time__c);
                            //CH04 ,new.end
                            DateTime apptDate =sValidateDateTime(csv.Appt_Start_Time__c);
                            appt.Appointment_Date__c = Date.valueof(apptDate );
                            appt.Appointment_Type__c=csv.Appointment_Type__c;
                            appt.City__c=csv.City__c;
                            appt.Country__c=csv.Country__c;
                            appt.County__c=csv.County__c;
                            /*  //CH02.start
                            if(ApptMap.get(csv.Work_Order_Number__c).Status__c=='Rejected' && ApptMap.get(csv.Work_Order_Number__c).Rejected__c!=null){
                                appt.Rejected__c=null;
                                appt.Employee_ID__c=null;
                            }
                            //CH02.end*/
                            if(csv.Duration__c!=null){
                                appt.Duration__c = csv.Duration__c.replace('.',':');
                                String Duration = (appt.Duration__c.substringBefore(':').length()==1 ? ('0'+ appt.Duration__c.substringBefore(':')): appt.Duration__c) + ':' +(appt.Duration__c.substringAfter(':').length()==1 ? ('0'+ appt.Duration__c.substringAfter(':')): appt.Duration__c);
                                appt.Duration__c = Duration.substringBefore(':') +':' + String.valueof(((Decimal.valueof(appt.Duration__c.substringAfter(':'))*60)/100).round());
                            }
                            appt.Latitude__c=csv.Latitude__c!=null && csv.Latitude__c!='' ? Decimal.valueof(csv.Latitude__c) :null;
                            appt.Longitude__c=csv.Longitude__c!=null && csv.Longitude__c!='' ? Decimal.valueof(csv.Longitude__c) : null;
                            appt.MPAN__c=csv.Mpan__c;
                            appt.MPRN__c=csv.Mprn__c;
                            appt.Message_Date__c=system.now();
                            NGS_Note__c note = new NGS_Note__c();
                            Note.Note__c = csv.Note_Text__c;
                            Note.Note_Type__c =csv.Note_Type__c;
                            mapNotes.put(appt.name,Note);
                            if(csv.Post_Code__c != null &&  csv.Post_Code__c != '' &&  csv.Post_Code__c.contains(' ')){
                                appt.Post_Code__c =  csv.Post_Code__c;
                                String postCodeStr = '';
                                postCodeStr =  csv.Post_Code__c.substringBefore(' ') + ' ' +  csv.Post_Code__c.substringAfter(' ').substring(0,1);
                                if(PostcodeMap != null && PostcodeMap.containsKey(postCodeStr)){
                                    if(PostcodeMap.get(postCodeStr).size() == 1){
                                        appt.Region__c = PostcodeMap.get(postCodeStr)[0].Sub_Region__r.Region__c;
                                        appt.Sub_Region__c = PostcodeMap.get(postCodeStr)[0].Sub_Region__c;
                                        
                                    }
                                    else
                                    {
                                        if(jobMap.get(csv.Std_Job_Id__c)!=null){
                                            Boolean isDefault,isECO,isMaintenance,isNewConnections,isSmart ;
                                            isDefault=isECO=isMaintenance=isNewConnections=isSmart =false;
                                            if(jobMap.get(csv.Std_Job_Id__c).Bucket_Type__c == 'Maintenance'){
                                                    isMaintenance = true;
                                            }
                                            else if(jobMap.get(csv.Std_Job_Id__c).Bucket_Type__c == 'ECO'){
                                                isECO = true;
                                            }
                                            else if(jobMap.get(csv.Std_Job_Id__c).Bucket_Type__c == 'Smart'){
                                                isSmart = true;
                                            }
                                            else if(jobMap.get(csv.Std_Job_Id__c).Bucket_Type__c == 'New Connections'){
                                                isNewConnections = true;
                                            }
                                            else if(jobMap.get(csv.Std_Job_Id__c).Bucket_Type__c == 'Default'){
                                                isDefault = true;
                                            }
                                            for(NGS_Postcode__c ngsPCobj : PostcodeMap.get(postCodeStr)){
                                                if(ngsPCobj.Sub_Region__r.Default__c && isDefault){
                                                    appt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    appt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__c!=null && ngsPCobj.Sub_Region__r.ECO__c && isECO){
                                                    appt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    appt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__c!=null && ngsPCobj.Sub_Region__r.Maintenance__c && isMaintenance){
                                                    appt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    appt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__c!=null && ngsPCobj.Sub_Region__r.New_Connections__c && isNewConnections){
                                                    appt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    appt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__c!=null && ngsPCobj.Sub_Region__r.Smart__c && isSmart){
                                                    appt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    appt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                    if(jobMap!=null && jobMap.containsKey(csv.Std_Job_Id__c)){
                                        NGS_Task__c task = new NGS_Task__c();
                                        task.Job_ID__c = jobMap.get(csv.Std_Job_Id__c).id;
                                        NGSTaskMap.put(appt.name,task);
                                        ApptList.add(appt);
                                        CountCreated = CountCreated+1;
                                    }
                                    else{
                                        csv.Status__c='Appointments Unsuccessful';
                                        CountFailed = CountFailed+1;
                                    }                                
                                }
                                else{
                                    Csv.status__c = 'Post Code outside the area.';
                                    CountFailed = CountFailed+1;

                                }
                            }
                            else{
                                Csv.status__c= 'Post Code missing or Invalid';
                                CountFailed = CountFailed+1;

                           }
                        }
                       System.debug('Error--->'+csv.Status__c);
                    }                               
                if(ApptList!=null && ApptList.size()>0) upsert ApptList;
                List<NGS_Task__c> tasklistToDelete = new List<NGS_Task__c>([select id from NGS_Task__c where Work_Order_Number__c IN:ApptIDsTodelete]);
                delete tasklistToDelete;
                List<NGS_Note__c> NotelistToDelete = new List<NGS_Note__c>([select id from NGS_Note__c where Work_Order_Number__c IN:ApptIDsTodelete]);
                delete NotelistToDelete;
                Map<String,String> apptMapFInal = new Map<String,String>();
                for(NGS_Work_Order_Appointment__c apptobj : ApptList){
                    apptMapFInal.put(apptobj.name,apptobj.id);
                }
                for(NGS_Import_CSV__c  appt :  csvdataList){
                    NGS_Task__c task = NGSTaskMap.get(appt.Work_Order_Number__c);
                    if(task!=null) task.Work_Order_Number__c = apptMapFInal.get(appt.Work_Order_Number__c);
                    if(task!=null)TaskListToInsert.add(task);
                    NGS_Note__c Note = mapNotes.get(appt.Work_Order_Number__c);
                    if(Note!=null) Note.Work_Order_Number__c = apptMapFInal.get(appt.Work_Order_Number__c);
                }
                if(TaskListToInsert!=null && TaskListToInsert.size()>0) insert TaskListToInsert;
                if(LstNotes!=null && LstNotes.size()>0) Insert LstNotes;  
                mail.setSubject('S2 – Work Order Appointments'+String.valueof(system.today().format()).left(10) +' SP02. (BCM)');           
                String body= CountCreated +' Appointments Successfully Created'+'<br/>';
                body= body +CountFailed + ' Appointments Unsuccessful'+'<br/>';
                body= body +CountUpdated+ ' Appointments Updated'+'<br/>';
                mail.setHtmlBody(body);                      
                emaillist.add(mail);
                if(emaillist!= null && emaillist.size() > 0)
                Messaging.sendEmail(emaillist);
                if(lstNGSImport!=null && lstNGSImport.size()>0){
                    lstNGSImport[0].Last_Import_Result__c='PASS';
                    lstNGSImport[0].Last_Import_Routine_Run_Time__c=System.now();
                    //lstNGSImport[0].h_Error_from_Last_import__c='';
                    Update lstNGSImport[0];
                }
                return 'Work Order created/Updated successfully.';
            }
            else
                return 'File does not contain Data to process'; 
            
        }catch(Exception e){
            System.debug('Error Occured---->'+e.getMessage() +'--->'+e.getLineNumber());
            mail.setSubject('S2 – Work Order Appointments'+String.valueof(system.today().format()).left(10) +' SP02. (BCM) **FAILURE**');           
            String body= 'The NGS Import Routine has failed, please log a call with the IT service desk.'+'<br/>';
            mail.setHtmlBody(body);                      
            emaillist.add(mail);
            if(emaillist!= null && emaillist.size() > 0)
            Messaging.sendEmail(emaillist);
            if(lstNGSImport!=null && lstNGSImport.size()>0){
                lstNGSImport[0].Last_Import_Result__c='FAIL';
                lstNGSImport[0].Last_Import_Routine_Run_Time__c=System.now();
                //lstNGSImport[0].h_Error_from_Last_import__c='Error Occured---->'+e.getMessage() +'--->'+e.getLineNumber(); 
                Update lstNGSImport[0];
            }
            return 'Error Occured, Please contact your system administrator';
        }
    }
    /**
sValidateDateTime(string dateTimeValue)
This method is used to returns datetime value in YYYY-MM-DD HH:MM:SS format or return null when datetime value not in valid format.
**/
    public static DateTime sValidateDateTime(string dateTimeValue) {
        string converted ='';
        try {
            if (dateTimeValue.length() == 16) 
            {
                string d = dateTimeValue.substring(0, 2);
                string m = dateTimeValue.substring(3, 5);
                string Y = dateTimeValue.substring(6, 10);
                string h = dateTimeValue.substring(11, 13);
                string min = dateTimeValue.substring(14, 16);
                converted = y + '-' + m + '-' + d + ' ' + h + ':' + min + ':00';
            }
            if (converted == null || converted == '') 
                return null;
            else 
                return datetime.valueof(converted);
        } catch (Exception Ex) {
            return null;
        }
    }
 /**
         This function convers the input CSV file in BLOB format into a string
        @param input    Blob data representing correct string in @inCharset encoding
        @param inCharset    encoding of the Blob data (for example 'ISO 8859-1')
     */
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }         

    
}