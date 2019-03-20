/**
    Description : This test class covers the code coverage for below class
        1. EON_JUMBO_Close_ElecJob_In_Isis_WS
**/
/*
    Created By : Praveen G
    Created Date : 21-March-2016
    Service Request : SR_EON_Jumbo_015
*/

@isTest
private class EON_JUMBO_Close_ElecJob_In_Isis_WS_Test {

    /**
     closeElectricityJobInIsis_1 - Fail Unit test for method closeElectricityJobInIsis   
    **/    
    static testmethod void closeElectricityJobInIsis_1(){
        EON_JUMBO_Close_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = EON_JUMBO_Close_ElecJob_In_Isis_WS.closeElectricityJobInIsis(null);
        System.assert(response.success  == 'FAIL');
    }
    
    
    /**
    closeElectricityJobInIsis_2 - Fail Unit test for method closeElectricityJobInIsis     
    **/     
    static testmethod void closeElectricityJobInIsis_2(){
        EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest();
        EON_JUMBO_Close_ElecJob_In_Isis_WS controller = new EON_JUMBO_Close_ElecJob_In_Isis_WS();
        EON_JUMBO_Close_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = EON_JUMBO_Close_ElecJob_In_Isis_WS.closeElectricityJobInIsis(request);                  
        System.assert(response.success  == 'FAIL');                            
    } 
    
    
    /**
    closeElectricityJobInIsis_3 - Fail Unit test for method closeElectricityJobInIsis    
    **/    
    static testmethod void closeElectricityJobInIsis_3(){
    
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        insert app; 
        EON_Appointment__c appointment = [select id, Name from EON_Appointment__c where id =:app.id];        
                
        EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = 'Test1234';
        request.JUMBOId = '12345'; 
        request.VisitStartDate = System.today();
        request.VisitStartTime = '101200';
        request.VisitEndDate = System.today();
        request.VisitEndTime = '121200';
        EON_JUMBO_Close_ElecJob_In_Isis_WS controller = new EON_JUMBO_Close_ElecJob_In_Isis_WS();
        EON_JUMBO_Close_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Close_ElecJob_In_Isis_WS.closeElectricityJobInIsis(request);
                            
        System.assert(response.success  == 'PASS');                            
    } 
    
    
    /**
    closeElectricityJobInIsis_4 - Fail Unit test for method closeElectricityJobInIsis     
    **/    
    static testmethod void closeElectricityJobInIsis_4(){
    
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345'; 
        insert app;       
                
        EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = 'Test12345';
        request.JUMBOId = '12345'; 
        request.VisitStartDate = System.today();
        request.VisitStartTime = '101200';               
        EON_JUMBO_Close_ElecJob_In_Isis_WS controller = new EON_JUMBO_Close_ElecJob_In_Isis_WS();
        EON_JUMBO_Close_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Close_ElecJob_In_Isis_WS.closeElectricityJobInIsis(request);
                            
        System.assert(response.success  == 'FAIL');                            
    } 
    
    
    /**
    closeElectricityJobInIsis_5 - Fail Unit test for method closeElectricityJobInIsis       
    **/    
    static testmethod void closeElectricityJobInIsis_5(){
    
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'Test12345';
        app.JUMBO_ID__c = '12345'; 
        insert app;   
                
        EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = 'Test12345';
        request.JUMBOId = '12345';   
        
        request.VisitStartDate = System.today();
        request.VisitStartTime = '99:124544545454545454555555554545';
        request.VisitEndDate = System.today();
        request.VisitEndTime = '99:12234';         
        
        EON_JUMBO_Close_ElecJob_In_Isis_WS controller = new EON_JUMBO_Close_ElecJob_In_Isis_WS();
        EON_JUMBO_Close_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Close_ElecJob_In_Isis_WS.closeElectricityJobInIsis(request);
                            
        System.assert(response.success  == 'FAIL');                            
    }    
        
     
     /**
     closeElectricityJobInIsis_6 - Fail Unit test for method closeElectricityJobInIsis       
    **/    
    static testmethod void closeElectricityJobInIsis_6(){
    
        insert EON_CreateTestRecords.createEONAppCancelReason();
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Complete_DateTime__c = date.today();
        insert app; 
        EON_Appointment__c appointment = [select id, Name from EON_Appointment__c where id =:app.id];        
                
        EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Close_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = 'Test1234';
        request.JUMBOId = '12345'; 
        request.VisitStartDate = System.today();
        request.VisitStartTime = '101200';
        request.VisitEndDate = System.today();
        request.VisitEndTime = '121200';
        EON_JUMBO_Close_ElecJob_In_Isis_WS controller = new EON_JUMBO_Close_ElecJob_In_Isis_WS();
        EON_JUMBO_Close_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = 
                            EON_JUMBO_Close_ElecJob_In_Isis_WS.closeElectricityJobInIsis(request);
                            
        System.assert(response.success  == 'FAIL');                            
    }            
}