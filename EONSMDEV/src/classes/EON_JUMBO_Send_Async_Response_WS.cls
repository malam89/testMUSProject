/**
    Description: This class used to generate a WSDL to generate Asynchronous Business Responses to the JUMBO system. 
    Vf Page: None
    Test Class :  EON_JUMBO_Send_Async_Response_WS_Test
**/
/*
    Created By : Purvi 
    Created Date : 27-April-2016
    Service Request : SR_EON_Jumbo_019
    Change History : 
    CH01 #SR_EON_Jumbo_078 #18/11/2016 # Praveen G# Updating appointment record with dates in success case.
    CH02 #SR_OptiMUS_EON_297 #11/02/2019 # Tabish Almas # Call CloseJobInMDS only when BusinessReponseJumbo is SUCCESS.
*/
global with sharing class EON_JUMBO_Send_Async_Response_WS{
    /**
        Description : Request
    **/
    global with sharing class AsyncRequest{
        Webservice Boolean Success;
        Webservice String Message;
        Webservice String UniqueID;
        Webservice String JumboId;
    } 
    /**
        Description : Response
    **/          
    global with sharing class AsyncResponse{
        Webservice String Success;
        Webservice String Message;
        Webservice String ExternalJobReference;
    }
    /**
        retResponseToJumbo(AsyncRequest aRequest) - 
            This method is use to prepare response in Isis
    **/
    webservice static AsyncResponse retResponseToJumbo(AsyncRequest aRequest){
         AsyncResponse response = new AsyncResponse();
         JUMBO_Data_Tracker__c pTracker = new JUMBO_Data_Tracker__c();
         List<JUMBO_Data_Tracker__c> tracker = new List<JUMBO_Data_Tracker__c>();
         //tracker information
         pTracker.Direction__c = EON_Utility.DIRECTION_IN;
         pTracker.Status__c = EON_Utility.RESULT_PASS;       
         String result = '';
         try{
            if(!EON_Utility.validateRequired(aRequest)){
               pTracker.Request_Data__c=string.valueOf(aRequest);
               if(EON_Utility.validateRequired(aRequest.JumboId))
                   pTracker.h_Jumbo_Id__c = aRequest.JumboId;
               //Validation for mandatory fields
               if(EON_Utility.validateRequired(aRequest.UniqueID))
                  result =result + 'Mandatory field UniqueID is missing.\n';   
                   
                if(EON_Utility.validateRequired(result)){
                   tracker = [select id,EON_Appointment__c,EON_Appointment__r.Name,Command__c from JUMBO_Data_Tracker__c where Transaction_ID__c=:aRequest.UniqueID]; 
                    if(!tracker.isEmpty()){
                          if(!EON_Utility.validateRequired(tracker[0].EON_Appointment__c)){
                                EON_Appointment__c app = [select id,Name from EON_appointment__c where id =:tracker[0].EON_Appointment__c];
                                     //Close Elec Job Request
                                     if(tracker[0].Command__c==JUMBO_Utility.CMD_Close_ElecJUMBO){
                                         pTracker.Command__c = JUMBO_Utility.CMD_Async_Close_ElecJUMBO; 
                                          if(aRequest.Success) {
                                             update new EON_Appointment__c(id =app.id, Close_Electricity_Job__c='Success',
                                                                             Elec_Deprogramming_Time__c = System.now()); // CH01
                                             EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.Id, true);    //CH02
                                          }
                                               else
                                                 update new EON_Appointment__c(id =app.id, Close_Electricity_Job__c='Fail');
                                         response.success = EON_Utility.RESULT_PASS;
                                         response.externalJobReference = app.Name;
                                         pTracker.EON_Appointment__c = app.id;
                                       }
                                       
                                      //Close Gas Job Request
                                      if(tracker[0].Command__c==JUMBO_Utility.CMD_Close_GasJUMBO){
                                         pTracker.Command__c = JUMBO_Utility.CMD_Async_Close_GasJUMBO; 
                                          if(aRequest.Success) {
                                             update new EON_Appointment__c(id =app.id, Close_Gas_Job__c='Success',
                                                                             Gas_Deprogramming_Time__c = System.now()); // CH01
                                             EON_MDS_Gas_Close_Outbound_Job.closeGasJobMDS(app.Id, true);    //CH02
                                          }
                                               else
                                                 update new EON_Appointment__c(id =app.id, Close_Gas_Job__c='Fail');
                                         response.success = EON_Utility.RESULT_PASS;
                                         response.externalJobReference = app.Name;
                                         pTracker.EON_Appointment__c = app.id;
                                       }
                               }
                        }
                         else 
                           result = 'No Appointment found with the UniqueID :'+aRequest.UniqueID; 
                 }                    
              }
              else
                 result = 'No Request found (Request is null)';          
          }
          catch(Exception ex){
            result = 'An Unknown error has occurred while processing this request. Please contact to System Administrator';
            pTracker.Status__c = EON_Utility.RESULT_FAIL;
            pTracker.Response_Data__c = ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber();
         }   
          
          finally{ 
            //This is error message block
            if(!EON_Utility.validateRequired(result)){
                 response.success = EON_Utility.RESULT_FAIL;
                 response.message = result;   
            }   
            pTracker.Response_Data__c = string.valueOf(response)+'\n'+(!EON_Utility.validateRequired(pTracker.Response_Data__c)?pTracker.Response_Data__c:''); 
            insert pTracker;
         }
        return response;
    }       
}