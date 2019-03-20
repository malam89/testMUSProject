/**
    Description : This test class covers the code coverage for below class
        1. EON_JUMBO_Update_GasJob_In_Isis_WS
**/
/*
    Created By : Praveen G
    Created Date : 14-March-2016
    Service Request : SR_EON_Jumbo_005
    Change History :
*/

@isTest
private class EON_JUMBO_Update_GasJob_In_Isis_WS_Test {
    
    /**
        unitTest1() - Unit Test 1    
    **/
    static testmethod void unitTest1(){
        EON_JUMBO_Update_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Update_GasJob_In_Isis_WS.updateGasJonInIsis(null);
        System.assert(response.success  == 'FAIL');    
    }
    
    /**
        unitTest2() - Unit Test 2    
    **/    
    static testmethod void unitTest2(){
        EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest();
        EON_JUMBO_Update_GasJob_In_Isis_WS controller = new EON_JUMBO_Update_GasJob_In_Isis_WS();
        EON_JUMBO_Update_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Update_GasJob_In_Isis_WS.updateGasJonInIsis(request);
                            
        System.assert(response.success  == 'FAIL');         
    }
 /**
        unitTest5() - Unit Test 5    
    **/    
    static testmethod void unitTest5(){
    
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'Test12345';
        app.Sent_to_Oracle__c=true;
        insert app; 
        EON_Appointment__c appointment = [select id, Name from EON_Appointment__c where id =:app.id];        
                
        EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest();
        request.MPRN = 'Test12345';
        request.JUMBOId = '12345jfjfjf jdjdjdjdjd jdjdjdjdjd jdjdjdjdjd jjddjdjdjd jdjdjdjdjd jdjdjdjdjd jdjdjdjdj jdjdjdjdjd jdjdjdjdjd';
        request.JUMBOId +='12345jfjfjf jdjdjdjdjd jdjdjdjdjd jdjdjdjdjd jjddjdjdjd jdjdjdjdjd jdjdjdjdjd jdjdjdjdj jdjdjdjdjd jdjdjdjdjd djdjdjdjd';        
        
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'Test Type';        
        EON_JUMBO_Update_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Update_GasJob_In_Isis_WS.updateGasJonInIsis(request);
                            
        System.assert(response.success  == 'FAIL');                            
    }               

 static testMethod void creategasJobInIsis() {  
        
        EON_JUMBO_Update_GasJob_In_Isis_WS  controller = new EON_JUMBO_Update_GasJob_In_Isis_WS();
        try{
        
        EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest  request1 = new EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest();
        request1.MPRN = '1234';
        request1.earliestStartDate = System.today();
        request1.JUMBOJobType = 'test Type';
        request1.RequestDate = System.today();
        Test.setMock(WebServiceMock.class, new EON_JUMBO_GasUpdate_WebServiceMockImpl());     
        system.debug('************Mocktest***********');
        EON_JUMBO_Update_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse  response1 = EON_JUMBO_Update_GasJob_In_Isis_WS.updateGasJonInIsis(request1);
        //System.assert(response1.success == 'PASS');  
        }
        catch(Exception e){system.debug(e);}
        //EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response2 = EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(null);
        //System.assert(response2.success == 'FAIL');              
        
    }
     /**
        unitTest3() - Unit Test 3    
    **/    
    static testmethod void unitTest3(){
       
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        //app.Job_Code__c=Eon_job.id;
        app.Sent_to_Oracle__c=true;
        insert app; 
         
       
                
        EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest();
        request.MPRN = 'Test1234';
        request.JUMBOId = '12345'; 
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'Test Type';
       
        system.debug('*******WebServiceMock******'+WebServiceMock.class);
        //app.MPRN__c = 'TEST1234';
        //app.Sent_to_Oracle__c=true;
        //insert app; 
        //EON_Appointment__c appointment = [select id, Name from EON_Appointment__c where id =:app.id];   
        //system.debug('************appointment*******'+appointment);
        Test.startTest();
        system.debug('*********Before Calling MOCK*************'+WebServiceMock.class);
        Test.setMock(WebServiceMock.class, new EON_JUMBO_GasUpdate_WebServiceMockImpl());
        system.debug('*********After Calling MOCK*************'+WebServiceMock.class);
        EON_JUMBO_Update_GasJob_In_Isis_WS controller = new EON_JUMBO_Update_GasJob_In_Isis_WS();
        EON_JUMBO_Update_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Update_GasJob_In_Isis_WS.updateGasJonInIsis(request);
         system.debug('***response.success***'+response.success);                   
        //System.assert(response.success  == 'PASS');   
     Test.stopTest();                        
    }
    
    
 /**
        unitTest4() - Unit Test 4    
    **/    
    static testmethod void unitTest4(){
    
        EON_Job__c Eon_job = EON_CreateTestRecords.createEONJob();
        Eon_job.name='RTREFDGBG';
        Eon_job.Jumbo_Job_Code__c='SDFSFDSFDS';
        insert Eon_job;
            
    
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Job_Code__c=Eon_job.id;
        app.Sent_to_Oracle__c=true;
        insert app; 
        
         EON_Job__c job_Eon = [select Jumbo_Job_Code__c,id from EON_Job__c where  id=:app.Job_Code__c]; 
        
        EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest();
        request.MPRN = 'Test12345';
        request.JUMBOId = '12345';
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'Test Type';                
        EON_JUMBO_Update_GasJob_In_Isis_WS controller = new EON_JUMBO_Update_GasJob_In_Isis_WS();
        EON_JUMBO_Update_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Update_GasJob_In_Isis_WS.updateGasJonInIsis(request);
                            
        System.assert(response.success  == 'FAIL');                            
    }
     /**
        unitTest6() - Unit Test 6    
    **/    
    static testmethod void unitTest6(){
        //Test.setMock(WebServiceMock.class, new EON_JUMBO_GasUpdate_WebServiceMockImpl());
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Sent_to_Oracle__c=true;
        insert app; 
        EON_Appointment__c appointment = [select id, Name from EON_Appointment__c where id =:app.id];        
                
        EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest request = new EON_JUMBO_Update_GasJob_In_Isis_WS.GasWorkRequest();
        request.MPRN = 'Test1234';
        request.JUMBOId = '12345'; 
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'Test Type';
        request.requestDate = System.today(); 
       
        EON_JUMBO_Update_GasJob_In_Isis_WS controller = new EON_JUMBO_Update_GasJob_In_Isis_WS();
        EON_JUMBO_Update_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = 
                            EON_JUMBO_Update_GasJob_In_Isis_WS.updateGasJonInIsis(request);
                            
       // System.assert(response.success  == 'PASS');                            
    }   
}