/**
Description : This test class is for the following below classes/triggers
              EON_GetAllJobs
**/

/*
    Created By  : Dharmendra Pahadiya
    Created On  : 13/04/2016
    Service Req : SR_EON_AB_038
    Change History : 
*/
@isTest
private class EON_GetAllJobs_test {

    static testMethod void myUnitTest1() {
        //Create EON Job
        EON_Job__c objJob1 = new EON_Job__c(name='test name1', Description__c='test value');
        insert objJob1;
        EON_Job__c objJob2 = new EON_Job__c(name='OOASMARTELECEXCH', Description__c='test value2');
        insert objJob2;
        
        //Create EON Job Attribute
        EON_Job_Attribute__c objJA1 = new EON_Job_Attribute__c(name='Meter Mode', Value__c='CR', Eon_Job__c=objJob1.Id);
        insert objJA1;
        EON_Job_Attribute__c objJA2 = new EON_Job_Attribute__c(name='test JA2', Value__c='test value2', Eon_Job__c=objJob2.Id);
        insert objJA2;
        EON_Job_Attribute__c objJA3 = new EON_Job_Attribute__c(name='test JA3', Value__c='test value3', Eon_Job__c=objJob2.Id);
        insert objJA3;
        
        //Create EON Data Tracker Record
        EON_Data_Tracker__c objTrcker = new EON_Data_Tracker__c(Direction__c='OUT', Command__c='Get All Jobs');
        insert objTrcker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_GET_Job_Service_from_EON_WSMockImpl());
        test.startTest();
        EON_GetAllJobs.getAllJobs(objTrcker.Id);
        test.stopTest();
        try{
        EON_GetAllJobs.getAllJobs('test');
        }catch(Exception e){}
        
    }
    static testMethod void myUnitTest2() {
        //Create EON Job
        EON_Job__c objJob1 = new EON_Job__c(name='test name1', Description__c='test value');
        insert objJob1;
        EON_Job__c objJob2 = new EON_Job__c(name='OOASMARTELECEXCH', Description__c='test value2');
        insert objJob2;
        
        //Create EON Job Attribute
        EON_Job_Attribute__c objJA1 = new EON_Job_Attribute__c(name='test JA1', Value__c='test value1', Eon_Job__c=objJob1.Id);
        insert objJA1;
        EON_Job_Attribute__c objJA2 = new EON_Job_Attribute__c(name='test JA2', Value__c='test value2', Eon_Job__c=objJob2.Id);
        insert objJA2;
        
        //Create EON Data Tracker Record
        EON_Data_Tracker__c objTrcker = new EON_Data_Tracker__c(Direction__c='OUT', Command__c='Get All Jobs');
        insert objTrcker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_GET_Job_Service_from_EON_WSMockImpl());
        test.startTest();      
        EON_Utility.genException=true;
        try{EON_GetAllJobs.getAllJobs(objTrcker.Id);}catch(Exception e){}
         test.stopTest();
        
    }
   
    //Catch block test
    static testMethod void myUnitTest3() {
        //Create EON Data Tracker Record
        EON_Data_Tracker__c objTrcker = new EON_Data_Tracker__c(Direction__c='OUT', Command__c='Get All Jobs');
        insert objTrcker;
        
        test.startTest();
        EON_GetAllJobs.getAllJobs(objTrcker.Id);
        test.stopTest();
        
    }
    
    static testMethod void myUnitTest4() {
        //Create EON Job
        EON_Job__c objJob1 = new EON_Job__c(name='test name1', Description__c='test value');
        insert objJob1;
        
        //Create EON Job Attribute
        EON_Job_Attribute__c objJA1 = new EON_Job_Attribute__c(name='test JA1', Value__c='test value1', Eon_Job__c=objJob1.Id);
        insert objJA1;
        
        //Create EON Data Tracker Record
        EON_Data_Tracker__c objTrcker = new EON_Data_Tracker__c(Direction__c='OUT', Command__c='Get All Jobs');
        insert objTrcker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_GET_Job_Service_Fail_EON_WSMockImpl());
        test.startTest();
        EON_GetAllJobs.getAllJobs(objTrcker.Id);
        test.stopTest();
        
    }
    
    static testMethod void myUnitTest5() {
        //Create EON Job
        EON_Job__c objJob1 = new EON_Job__c(name='test value', Description__c='test value');
        insert objJob1;
        EON_Job__c objJob2 = new EON_Job__c(name='OOASMARTELECEXCH', Description__c='test value2');
        insert objJob2;
        
        //Create EON Job Attribute
        EON_Job_Attribute__c objJA1 = new EON_Job_Attribute__c(name='test JA1', Value__c='test value1', Eon_Job__c=objJob1.Id);
        insert objJA1;
        EON_Job_Attribute__c objJA2 = new EON_Job_Attribute__c(name='test JA2', Value__c='test value2', Eon_Job__c=objJob2.Id);
        insert objJA2;
        
        //Create EON Data Tracker Record
        EON_Data_Tracker__c objTrcker = new EON_Data_Tracker__c(Direction__c='OUT', Command__c='Get All Jobs');
        insert objTrcker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_GET_Job_Service_from_EON_WSMockImpl());
        test.startTest();
        EON_GetAllJobs.getAllJobs(objTrcker.Id);
        test.stopTest();
        EON_Utility.genException = true;
        
    }
    
    
    
}