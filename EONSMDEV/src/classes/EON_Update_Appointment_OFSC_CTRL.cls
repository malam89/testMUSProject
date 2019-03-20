/**
    Description:  This class will be called from the record IMP-004, to process the appointment records 
                    from the attachments (CSV).
    Test Class : EON_Update_Appointment_OFSC_CTRL_test                    
**/

/*
    Created by : Praveen G
    Created Date : 13/09/2017
    Service Request : SR_OptiMUS_EON_098
*/

public with sharing class EON_Update_Appointment_OFSC_CTRL{
    
    //Instance Variables
    public String message{get;set;}
    
    public void processCSVFileAppointments(){
        //get the latest attachment record for IMP-004
        Attachment[] lstAttchment = [select id, Name, body from Attachment 
                                where 
                                parentID =:System.currentPageReference().getParameters().get('recId')
                                Order By CreatedDate DESC limit 1];
        
        //Basic validation for file type 
        if(lstAttchment.isEmpty() || lstAttchment[0].name.containsignorecase('processed')){
            message = 'No Attachments found to process. Please check.';
            return;                                    
        }else if(!lstAttchment[0].name.contains('csv')){
            message = 'No CSV file Attachments found to process. Please check.';
            return;        
        }else{
            //here is the logic to process the CSV attachment.
            try{
                String contentFile = lstAttchment[0].body.toString(); 
                String[] fileLines = contentFile.split('\n');  
                List<ID> lstAppointmentID = New List<ID>();
                for(String fileLine : fileLines){
                    if(fileLine.trim() != '')
                        lstAppointmentID.add(fileLIne.trim());
                }  
                               
                if(!lstAppointmentID.isEmpty()){
                    //Prepare SOQL for batch process
                    String query = prepareSOQL(lstAppointmentID);
                    
                    //Start the batch process
                    EON_Update_Appointment_OFSC_Batch batch = new 
                                EON_Update_Appointment_OFSC_Batch(query, lstAttchment[0].id);
                    Database.executebatch(batch , 1); 
                    message =  'Batch process started. Please check the results';           
                }else
                    message = 'No records found to process in CSV file. Please check.';
                
            }catch(Exception ex){
                System.debug('****** Exception Occured ' + ex.getMessage());
                message = ex.getMessage();
            }
        }
    }
    
    /**
        prepareSOQL(List<String> lstAppID) - Prepare SOQL query to get the appointment records.
    **/
    public String prepareSOQL(List<String> lstAppID){        
        String query = 'select id from EON_Appointment__c where id in (';
        for(String appID : lstAppID){
            query += '\'' + appID + '\',';
        }
        query = query.removeEND(',');        
        query += ')';
        
        return query;            
    }
}