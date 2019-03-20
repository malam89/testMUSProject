/**
    Description : This test class covers the code coverage for below class
                1. EON_JUMBO_Cancel_ElecJob_In_Isis_WS
                
**/
/*
    Created By  : Praveen G
    Created On  : 08/03/2016
    Service Req : SR_EON_Jumbo_004
    Change History
*/

@isTest
private class EON_JUMBO_Cancel_ElecJob_In_Isis_WS_Test  {

    /**
        unitTest1() - Unit Test 1    
    **/    
    static testmethod void unitTest1(){
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Cancel_ElecJob_In_Isis_WS.cancelElectricityJobInIsis(null);
        System.assert(response.success  == 'FAIL');
    }
    
    /**
       unitTest2() - Unit Test 2    
    **/     
    static testmethod void unitTest2(){
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest();
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS controller = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS();
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Cancel_ElecJob_In_Isis_WS.cancelElectricityJobInIsis(request);
                            
        System.assert(response.success  == 'FAIL');                            
    }  
    
    
     /**
        unitTest3() - Unit Test 3   
    **/    
    static testmethod void unitTest3(){
    	EON_Utility.genException = true;
      insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        insert app; 

        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = 'Test1234';
        request.JUMBOId = '12345';      
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS controller = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS();
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Cancel_ElecJob_In_Isis_WS.cancelElectricityJobInIsis(request);
        System.assert(response.success  == 'FAIL');                        
    }
    
    
        /**
          unitTest4() - Unit Test 4  
       **/    
      static testmethod void unitTest4(){
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        insert app; 

        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = 'Test1234';
        request.JUMBOId = '12345';      
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS controller = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS();
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Cancel_ElecJob_In_Isis_WS.cancelElectricityJobInIsis(request);
        System.assert(response.success  == 'PASS');                               
    }
    
    
    
        /**
          unitTest5() - Unit Test 5  
       **/   
       static testmethod void unitTest5(){
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        insert app; 

        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = 'Test12342334';
        request.JUMBOId = '12345';      
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS controller = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS();
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Cancel_ElecJob_In_Isis_WS.cancelElectricityJobInIsis(request);
        System.assert(response.success  == 'FAIL');                        
    }
    
    
      /**
        unitTest6() - Unit Test 6  
      **/
     static testmethod void unitTest6(){
      insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Sent_to_Oracle__c=true;
        insert app; 
        app.Sent_to_Oracle__c=true;
        update app;      
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = 'Test1234';
        request.JUMBOId = '12345';     
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS controller = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS();

        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='1', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Cancel_ElecJob_In_Isis_WS.cancelElectricityJobInIsis(request);
        Test.stopTest();   
        System.assert(response.success  == 'FAIL');                      
                                
    }
    
    /**
        unitTest7() - Unit Test 7    
    **/    
    static testmethod void unitTest7(){
      insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Sent_to_Oracle__c=true;
        insert app; 
        app.Sent_to_Oracle__c=true;
        update app;      
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = 'Test1234';
        request.JUMBOId = '12345';     
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS controller = new EON_JUMBO_Cancel_ElecJob_In_Isis_WS();

        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        EON_JUMBO_Cancel_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Cancel_ElecJob_In_Isis_WS.cancelElectricityJobInIsis(request);
        Test.stopTest();   
        System.assert(response.success  == 'PASS');                      
         
    }
                
}