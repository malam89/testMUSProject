/**
    Description : This test class covers the code coverage for below class EON_MDS_Send_Async_Response 
**/
/*
    Created By : Tabish Almas
    Created Date : 13-02-2019
    Service Request : SR_EON_303
    Change History : 

*/

@isTest
private class EON_MDS_Send_Async_Response_WS_Test {

    /**
    createAsynReqRespFAIL() - Negative Unit test for the method createAsynReqRespFAIL
    **/
    static testMethod void createAsynReqRespFAIL(){        
 
       //Scenario-1
       EON_MDS_Send_Async_Response_WS.AsyncResponse respo = EON_MDS_Send_Async_Response_WS.retResponseToJumbo(null);
       System.assert(respo.success == 'FAIL'); 
       
       //Scenario-2
       EON_MDS_Send_Async_Response_WS.AsyncRequest request = new EON_MDS_Send_Async_Response_WS.AsyncRequest();
       EON_MDS_Send_Async_Response_WS.AsyncResponse respo1 = EON_MDS_Send_Async_Response_WS.retResponseToJumbo(request);
       System.assert(respo1.success == 'FAIL'); 
     }
     
     
    /**
    createAsynReqResp_Fail1() - Negative Unit test for the method createAsynReqResp_Fail1
    **/
    static testMethod void createAsynReqResp_Fail1(){  
       MDS_Data_Tracker__c jt= new MDS_Data_Tracker__c(Transaction_ID__c='test');  
       insert jt; 
       EON_MDS_Send_Async_Response_WS.AsyncRequest request1 = new EON_MDS_Send_Async_Response_WS.AsyncRequest();
       request1.UniqueID = 'testID';
       EON_MDS_Send_Async_Response_WS.AsyncResponse respo2 = EON_MDS_Send_Async_Response_WS.retResponseToJumbo(request1);
       System.assert(respo2.success == 'FAIL');     
     }  
     
     
    /**
    createAsynReqResp_Fail1() - Negative Unit test for the method createAsynReqResp_Fail1
    **/
    static testMethod void createAsynReqResp_Fail2(){  
       EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
       insert app; 
       MDS_Data_Tracker__c jt= new MDS_Data_Tracker__c(Transaction_ID__c='testID',EON_Appointment__c=app.id,Command__c='CloseElecJobInMDS');  
       insert jt; 
       EON_MDS_Send_Async_Response_WS.AsyncRequest request1 = new EON_MDS_Send_Async_Response_WS.AsyncRequest();
       request1.UniqueID = 'testID';
       request1.JumboId = '4545454545454545454545454';
       EON_MDS_Send_Async_Response_WS.AsyncResponse respo2 = EON_MDS_Send_Async_Response_WS.retResponseToJumbo(request1);
       System.assert(respo2.success == 'FAIL');     
     }   
      

    /**
    createAsynReqRespPass() - Positive Unit test for the method createAsynReqRespPass
    **/
    static testMethod void createAsynReqRespPass(){  
       EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
       insert app; 
       MDS_Data_Tracker__c jt= new MDS_Data_Tracker__c(Transaction_ID__c='testID',EON_Appointment__c=app.id,Command__c='CloseElecJobInMDS');  
       insert jt; 
       EON_MDS_Send_Async_Response_WS.AsyncRequest request = new EON_MDS_Send_Async_Response_WS.AsyncRequest();
       request.Success= false;
       request.UniqueID = 'testID';
       EON_MDS_Send_Async_Response_WS.AsyncResponse respo = EON_MDS_Send_Async_Response_WS.retResponseToJumbo(request);
       System.assert(respo.success == 'PASS');     
     }
    
    
    /**
    createAsynReqRespPass1() - Positive Unit test for the method createAsynReqRespPass
    **/
    static testMethod void createAsynReqRespPass1(){  
       EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
       insert app; 
       MDS_Data_Tracker__c jt= new MDS_Data_Tracker__c(Transaction_ID__c='testID',EON_Appointment__c=app.id,Command__c='CloseElecJobInMDS');  
       insert jt; 
       EON_MDS_Send_Async_Response_WS.AsyncRequest request = new EON_MDS_Send_Async_Response_WS.AsyncRequest();
       request.Success= true ;
       request.UniqueID = 'testID';
       EON_MDS_Send_Async_Response_WS.AsyncResponse respo = EON_MDS_Send_Async_Response_WS.retResponseToJumbo(request);
       System.assert(respo.success == 'PASS');     
     }  
     
     
          
    /**
    createAsynReqResp_Fail3() - Negative Unit test for the method createAsynReqResp_Fail3
    **/
    static testMethod void createAsynReqResp_Fail3(){  
       EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
       insert app; 
       MDS_Data_Tracker__c jt= new MDS_Data_Tracker__c(Transaction_ID__c='testID',EON_Appointment__c=app.id,Command__c='CloseGasJobInMDS');  
       insert jt; 
       EON_MDS_Send_Async_Response_WS.AsyncRequest request1 = new EON_MDS_Send_Async_Response_WS.AsyncRequest();
       request1.Success= false;
       request1.UniqueID = 'testID';
       request1.JumboId = '4545454545454545454545454';
       EON_MDS_Send_Async_Response_WS.AsyncResponse respo2 = EON_MDS_Send_Async_Response_WS.retResponseToJumbo(request1);
       System.assert(respo2.success == 'PASS');     
     }   
     
     
         /**
    createAsynReqRespPass() - Positive Unit test for the method createAsynReqRespPass
    **/
    static testMethod void createAsynReqRespPass2(){  
       EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
       insert app; 
       MDS_Data_Tracker__c jt= new MDS_Data_Tracker__c(Transaction_ID__c='testID',EON_Appointment__c=app.id,Command__c='CloseGasJobInMDS');  
       insert jt; 
       EON_MDS_Send_Async_Response_WS.AsyncRequest request = new EON_MDS_Send_Async_Response_WS.AsyncRequest();
       request.Success= true;
       request.UniqueID = 'testID';
       EON_MDS_Send_Async_Response_WS.AsyncResponse respo = EON_MDS_Send_Async_Response_WS.retResponseToJumbo(request);
       System.assert(respo.success == 'PASS');     
     }
                     
}