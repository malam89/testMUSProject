/**
    Description : This class is created to generate a .csv file on click of 'BCM' button on “NGS Technician” record.                               
    Test Class  : NGS_Technician_BCM_Generate_CSV_Test
**/
/*
    Created By  : Shruti Moghe
    Created On  : 07/03/2017
    Service Req : SR_OptiMUS_NG_022
    Change History
    CH01 #SR_OptiMUS_NG_031 #14/03/2017 #Puneet Mehta #Changed the to address to logged in user
*/
global class  NGS_Technician_BCM_Generate_CSV{
    webservice static String Generate_CSV(String RecodID){
     
        try{
            List<NGS_Technician__c> ListTechinician = new List<NGS_Technician__c>([select id, Name,First_Name__c,Last_Name__c,Gender__c,Mobile_Number__c,Start_Location__c from NGS_Technician__c where id=:RecodID]);
            String finalStr = '';
            finalStr='<EMPLOYEE_ID>'+','+'<FIRST_NAME>'+','+'<LAST_NAME>'+','+'<GENDER>'+','+'<START_LOCATION>'+','+'<MOBILE_NUMBER>'+','+'<SERVICE_PROVIDER>'+'\n';                             
            for(NGS_Technician__c objTechinician : ListTechinician){                                                                            
                finalStr+=objTechinician.Name+','+objTechinician.First_Name__c+','+objTechinician.Last_Name__c+','+objTechinician.Gender__c+','+objTechinician.Start_Location__c+','+objTechinician.Mobile_Number__c+','+'SP02'+'\n';
            }   
            Blob csvBlob = Blob.valueOf(finalStr);
            string csvname = 'S0.csv';                           
            List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { UserInfo.getUserEmail() });//CH01.NEW
            mail.setSubject('S0 – Resource Created SP02. (BCM)');
            String body='Please see attached .csv file that contains a recently created Technician in OptiMUS.'+'<br/>';
            mail.setHtmlBody(body);                      
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();                       
            csvAttc.setContentType('text/csv; charset=UTF-8');
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc}); 
            emaillist.add(mail);
            if(emaillist!= null && emaillist.size() > 0)
            Messaging.sendEmail(emaillist);
            return 'The S0.csv has been sent successfully.';    
        }   
        catch(Exception e){
            return 'Error Occured during processing of CSV file, Please contact the system Administrator';
        }
    }
}