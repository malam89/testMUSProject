/**
    Description : This class is created to generate a .csv file on click of 'Resource Calendar (BCM)' Clink from Sidebar                        
    Test Class  : NGS_Resource_Calendar_BCM_CSV_Test
**/
/*
    Created By  : Shruti Moghe
    Created On  : 16/03/2017
    Service Req : SR_OptiMUS_NG_028
    Change History
        CH01 #SR_OptiMUS_NG_023#23/03/2017 #Tashika Gupta #Updated the field True/False with Isworking 
        CH02 #SR_OptiMUS_NG_038#10/04/2017 #Shruti Moghe # Updated the date time format of start and finish time

*/
global class  NGS_Resource_Calendar_BCM_CSV{
    webservice static String Generate_CSV(){
     
       try{
            List<NGS_Technician_Shifts__c> ListShifts = new List<NGS_Technician_Shifts__c>([select id,Name,Employee_ID__c,Employee_ID__r.name,Shift_Date__c, Shift_End__c,Shift_Start__c,IsWorking__c from NGS_Technician_Shifts__c]);//CH01
            String finalStr = '';
            finalStr='<EMPLOYEE_ID>'+','+'<SHIFT_DATE>'+','+'<SHIFT_START_TIME>'+','+'<SHIFT_FINISH_TIME>'+','+'True / False'+','+'<SERVICE_PROVIDER>'+'\n';
            if(ListShifts!=null && ListShifts.size()>0){
                for(NGS_Technician_Shifts__c objShift : ListShifts){ 
                    String isworking= objShift.IsWorking__c==true ? 'TRUE' : 'FALSE';//CH01
                    //CH02.start
                    Datetime starttime1;
                    Datetime finishtime1;
                    if(objShift.Shift_Start__c!=null){
                    String[] StartTIme=objShift.Shift_Start__c.split(':');
                    starttime1  = DateTime.newInstance(objShift.Shift_Date__c, Time.newInstance(Integer.valueof(StartTIme[0]), Integer.valueof(StartTIme[1]), 0, 0));
                    }
                    if(objShift.Shift_End__c!=null){
                        String[] FinishTime=objShift.Shift_End__c.split(':'); 
                        finishtime1 =DateTime.newInstance(objShift.Shift_Date__c,Time.newInstance(Integer.valueof(FinishTIme[0]), Integer.valueof(FinishTIme[1]), 0, 0));
                    }
                    //CH02.end
                   finalStr+=objShift.Employee_ID__r.name+','+(objShift.Shift_Date__c!=null ? String.valueof(objShift.Shift_Date__c).left(10) :'')+','+(starttime1!=null?String.valueof(starttime1):'')+','+(FinishTime1!=null? String.valueof(FinishTime1):'')+','+isworking+','+'SP02'+'\n';//CH01 //CH02
                }    
                Blob csvBlob = Blob.valueOf(finalStr);
                string csvname = 'S1.csv';                           
                List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String sendTo = '';          
                mail.setToAddresses(new String[] { UserInfo.getUserEmail() });
                 mail.setBCCAddresses(new String[] { 'shruti.moghe@morrisonus.com'});
                mail.setSubject('S1 – Resource Availability '+String.valueof(system.today().format()).left(10)+' SP02. (BCM)');
                String body='Please see attached .csv file that MUS Technicians shifts to show availability for appointment booking. (BCM)'+'<br/>';
                mail.setHtmlBody(body);                      
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();                       
                csvAttc.setContentType('text/csv; charset=UTF-8');
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc}); 
                emaillist.add(mail);
                if(emaillist!= null && emaillist.size() > 0)
                Messaging.sendEmail(emaillist);
                return 'The S1.csv has been sent successfully.';   
            }
            else  return 'No Shift Records avaliable, Please contact your system Administrator';
        }   
        catch(Exception e){
            return 'Error Occured during processing of CSV file, Please contact the system Administrator';
        }
    }
}