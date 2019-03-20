/**
    Description : This test class covers the code coverage for below class
        1. EON_JUMBO_Close_GasJob_In_Isis_WS 
**/
/*
    Created By : Purvi Khandelwal
    Created Date : 22-March-2016
    Service Request : SR_EON_Jumbo_016
*/

@isTest
private class EON_JUMBO_Close_GasJob_In_Isis_WS_Test{

    /**
    closeGasJobInIsis_1() - Fail Unit test for method closeGasJobInIsis
    **/    
    static testmethod void closeGasJobInIsis_1(){
        EON_JUMBO_Close_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Close_GasJob_In_Isis_WS.closeGasJobInIsis(null);
        System.assert(response.success  == 'FAIL');
    }
    
    
    /**
    closeGasJobInIsis_2() - Fail Unit test for method closeGasJobInIsis  
    **/     
    static testmethod void closeGasJobInIsis_2(){
        EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest();
        EON_JUMBO_Close_GasJob_In_Isis_WS controller = new EON_JUMBO_Close_GasJob_In_Isis_WS();
        EON_JUMBO_Close_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Close_GasJob_In_Isis_WS.closeGasJobInIsis(request);             
        System.assert(response.success  == 'FAIL');                            
    } 
    
    
    /**
    closeGasJobInIsis_3() - Fail Unit test for method closeGasJobInIsis    
    **/    
    static testmethod void closeGasJobInIsis_3(){
    
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        insert app;     
                
        EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest();
        request.MPRN = 'Test1234';
        request.JUMBOId = '12345'; 
        request.VisitStartDate = System.today();
        request.VisitStartTime = '101200';
        request.VisitEndDate = System.today();
        request.VisitEndTime = '121200';  
        EON_JUMBO_Close_GasJob_In_Isis_WS controller = new EON_JUMBO_Close_GasJob_In_Isis_WS();
        EON_JUMBO_Close_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Close_GasJob_In_Isis_WS.closeGasJobInIsis(request);
                            
        System.assert(response.success  == 'PASS');                            
    } 
    
    
    /**
    closeGasJobInIsis_4() - Fail Unit test for method closeGasJobInIsis   
    **/    
    static testmethod void closeGasJobInIsis_4(){
    
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        insert app;     
                
        EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest();
        request.MPRN = 'Test12345';
        request.JUMBOId = '12345'; 
        request.VisitStartDate = System.today();
        request.VisitStartTime = '10:12';           
        EON_JUMBO_Close_GasJob_In_Isis_WS controller = new EON_JUMBO_Close_GasJob_In_Isis_WS();
        EON_JUMBO_Close_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Close_GasJob_In_Isis_WS.closeGasJobInIsis(request);
                            
        System.assert(response.success  == 'FAIL');                            
    } 
    
    /**
     closeGasJobInIsis_5() - Fail Unit test for method closeGasJobInIsis     
    **/    
    static testmethod void closeGasJobInIsis_5(){
    
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'Test12345';
        app.JUMBO_ID__c = '12345'; 
        insert app;      
                
        EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest();
        request.MPRN = 'Test12345';
        request.JUMBOId = '12345';         
        
        request.VisitStartDate = System.today();
        request.VisitStartTime = '99:124544545454545454555555554545';
        request.VisitEndDate = System.today();
        request.VisitEndTime = '12:12';         
        
        EON_JUMBO_Close_GasJob_In_Isis_WS controller = new EON_JUMBO_Close_GasJob_In_Isis_WS();
        EON_JUMBO_Close_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Close_GasJob_In_Isis_WS.closeGasJobInIsis(request);
                            
        System.assert(response.success  == 'FAIL');                            
    }   
    
     /**
       closeGasJobInIsis_6() - Fail Unit test for method closeGasJobInIsis     
    **/    
    static testmethod void closeGasJobInIsis_6(){
    
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Complete_DateTime__c = date.today();
        insert app;     
                
        EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Close_GasJob_In_Isis_WS.GasWorkRequest();
        request.MPRN = 'Test1234';
        request.JUMBOId = '12345'; 
        request.VisitStartDate = System.today();
        request.VisitStartTime = '10:12';
        request.VisitEndDate = System.today();
        request.VisitEndTime = '12:12';  
        EON_JUMBO_Close_GasJob_In_Isis_WS controller = new EON_JUMBO_Close_GasJob_In_Isis_WS();
        EON_JUMBO_Close_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Close_GasJob_In_Isis_WS.closeGasJobInIsis(request);
                            
        System.assert(response.success  == 'FAIL');                            
    }             
}