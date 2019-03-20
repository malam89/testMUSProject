/**
    Description: This class used to generate a WSDL for just testing the connectivity. This WSDL will be consumed by MDS System
    Test Class :  
**/
/*
    Created By : Tashika G
    Created Date : 10/08/2018
    Service Request : SR_OptiMUS_EON_270
    Change History 
*/
   global with sharing class EON_MDS_TestConnectivity_OptiMUS_WS {
   
   /**
     Description : Request Parameter
    **/
    global with sharing class ConnectionRequest {
        Webservice String RequestMessage; 
    }
    /**
     Description : Response
    **/
    global with sharing class ConnectionResponse{
         Webservice String Success;
         Webservice String Message;
   }
    /**
    checkMDSConnectivity(ConnectionRequest contRequest) - This method is used to create an record in Isis.
    **/
   webservice static ConnectionResponse checkMDSConnectivity(ConnectionRequest contRequest){
       ConnectionResponse response = new ConnectionResponse ();
       MDS_Data_Tracker__c mTracker = new MDS_Data_Tracker__c();
       try{
       mTracker.Direction__c = EON_Utility.DIRECTION_IN;
       mTracker.Status__c = EON_Utility.RESULT_PASS;  
       mTracker.Command__c = 'GetStatus';
        
            if(!EON_Utility.validateRequired(contRequest)){
               mTracker.Request_Data__c=string.valueOf(contRequest);
               }  
                response.Success = 'PASS';
       response.Message = 'Response is recieved successfully';
               mTracker.Response_Data__c = string.valueOf(response)+'\n'+(!EON_Utility.validateRequired(mTracker.Response_Data__c)?mTracker.Response_Data__c:''); 
            insert mTracker;
      
           }
  
       catch(Exception ex){
            system.debug('***************Error***************');
            mTracker.Status__c = EON_Utility.RESULT_FAIL;
            mTracker.Response_Data__c = ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber();
             insert mTracker;
        }
      
          return response;
         }
         
      
   }