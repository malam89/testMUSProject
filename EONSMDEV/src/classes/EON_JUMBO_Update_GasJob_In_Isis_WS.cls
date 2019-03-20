/**
    Description: Details of existing gas job are updated in JUMBO and the corresponding appointment is updated in Isis.
                 An Eon Appointment record will be updated here.
    Test Class :  EON_JUMBO_Update_GasJob_In_Isis_WS_Test               
**/
/*
    Created By : Praveen G
    Created Date : 14-March-2016
    Service Request : SR_EON_Jumbo_005
*/
global with sharing class EON_JUMBO_Update_GasJob_In_Isis_WS {

    /**
        Description : Request Parameter
    **/
    global with sharing class GasWorkRequest{    
        Webservice String MPRN;
        Webservice Date RequestDate;
        Webservice String RequestTime;
        Webservice Date EarliestStartDate;
        Webservice String EarliestStartTime;
        Webservice Date LatestStartDate;
        Webservice String LatestStartTime;
        Webservice String JUMBOJobType;  
        Webservice String JUMBOID;
        Webservice String OriginalJUMBOID;
        webservice String ExternalJobReference;      
    }   
    
    /**
        Description : Response
    **/
    global with sharing class JumboToIsisGasWorkResponse{
        Webservice String Success;
        Webservice String Message;
        Webservice String ExternalJobReference;
    }
    
    /**
        updateGasJonInIsis(GasWorkRequest gasWorkRequest) - 
                This method is used to update an Appointment record in Isis.
    **/
    webservice static JumboToIsisGasWorkResponse updateGasJonInIsis(GasWorkRequest gasWorkRequest){
    
         JumboToIsisGasWorkResponse response = new JumboToIsisGasWorkResponse();
         JUMBO_Data_Tracker__c tracker = new JUMBO_Data_Tracker__c(); 
         
         //tracker information
         tracker.Direction__c = EON_Utility.DIRECTION_IN;
         tracker.Command__c = EON_Utility.CMD_JUMBO_GASUPDATE;
         tracker.Status__c = EON_Utility.RESULT_PASS;         
         tracker.Request_Data__c = '' + gasWorkRequest;
         String result = '';  
         
         try{
             if(gasWorkRequest != null){
                 //Validation for mandatory fields
                 if(EON_Utility.validateRequired(gasWorkRequest.MPRN) || EON_Utility.validateRequired(gasWorkRequest.earliestStartDate)
                     || EON_Utility.validateRequired(gasWorkRequest.JUMBOJobType) || EON_Utility.validateRequired(gasWorkRequest.JUMBOID)){
                     result = 'Mandatory fields are missing MPRN, earliestStartDate, JUMBOJobType or JUMBOID';                                                 
                 }else{
                    //logic to update the EON Appointment record for update appointment timings. 
                    EON_Appointment__c[] lstAppointment = [select id, Name, Request_Date__c, Request_Time__c, Appointment_Date__c,
                                                             Start_Time__c, End_Appointment_Date__c, End_Time__c, Job_Type__c,
                                                             JUMBO_ID__c, Original_JUMBO_ID__c, MPRN__c   
                                                        from EON_Appointment__c where MPRN__c =: gasWorkRequest.MPRN]; 
                                                                                         
                    if(!lstAppointment.isEmpty()){
                        if(gasWorkRequest.requestDate != null)
                            lstAppointment[0].Request_Date__c = gasWorkRequest.requestDate;
                        else
                            lstAppointment[0].Request_Date__c = System.today();    
                        lstAppointment[0].Request_Time__c = gasWorkRequest.requestTime;
                        lstAppointment[0].Appointment_Date__c = gasWorkRequest.earliestStartDate;
                        lstAppointment[0].Start_Time__c = gasWorkRequest.earliestStartTime;
                        lstAppointment[0].End_Appointment_Date__c = gasWorkRequest.latestStartDate;
                        lstAppointment[0].End_Time__c = gasWorkRequest.latestStartTime;   
                        lstAppointment[0].Job_Type__c = gasWorkRequest.JUMBOJobType;
                        lstAppointment[0].JUMBO_ID__c = gasWorkRequest.JUMBOID;
                        lstAppointment[0].Original_JUMBO_ID__c = gasWorkRequest.originalJUMBOID;
                        
                        update lstAppointment[0];
                           
                        //update the response
                        tracker.EON_Appointment__c = lstAppointment[0].id;
                        response.success = EON_Utility.RESULT_PASS; 
                        response.message = 'Appointment Job updated sucessfully : '+ lstAppointment[0].MPRN__c;
                        response.externalJobReference = lstAppointment[0].Name;                                         
                    }else{
                        result = 'No Appointment job found with the MPRN :'+ gasWorkRequest.MPRN;
                    } 
                 }           
             }else{
                     result = 'No Request found (Request is null)';
             }
         }catch(Exception ex){
             System.debug('*** Exception Occured : ' + ex.getMessage());
             result = ex.getMessage();         
         }
         
         //This is error message block
         if(!EON_Utility.validateRequired(result)){
             response.success = EON_Utility.RESULT_FAIL;
             response.message = result;
             tracker.Status__c = EON_Utility.RESULT_FAIL;             
         }
         
         tracker.Response_Data__c = '' + response;
         insert tracker;                                        
             
        return response;
    }     
    
}