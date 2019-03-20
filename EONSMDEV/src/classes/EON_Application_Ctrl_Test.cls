/**
    Description : This class is used for test coverage for the below classes
    1.EON_Application_Ctrl    
**/
/*
    Created By : Praveen G
    Created Date : 19-March-2016 
    Service Request : SR_Isis_EON_010
*/
@isTest
private class EON_Application_Ctrl_Test {
    
    /**
        unitTest1() - unitTest1 Success test case.
    **/
    static testmethod void unitTest(){
        Contract_Number__c contract = EON_CreateTestRecords.createContractNumber();
        contract.Contract_Client_Short_Name__c = 'EON';
        insert contract;
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Appointment_Date__c = System.today();
        app.Contract__c = contract.id;
        insert app; 
        
        EON_Rate__c rate = new EON_Rate__c();
        rate.Name = 'AAAA-333';
        rate.Description__c = 'test Descriptoin';
        insert rate;
        
        EON_Appointment_Value__c appValue =  EON_CreateTestRecords.createEonAppointmentvalue();
        appValue.EON_Appointment__c =  app.id;
        appValue.Rate__c = rate.id;
        insert appValue;
        
        EON_Appointment_Value__c appValue1 =  EON_CreateTestRecords.createEonAppointmentvalue();
        appValue1.EON_Appointment__c =  app.id;
        appValue1.Rate__c = rate.id;
        insert appValue1; 
        
        EON_Application__c app1 = new EON_Application__c();
        app1.Date_To__c = System.today();
        app1.Date_From__c = System.today();
        
        EON_Application_Ctrl controller = new EON_Application_Ctrl();        
        controller.application = app1;
        controller.selectedContract = contract.id;
        
        controller.getContracts();
        controller.calculateValue();
        controller.createApplication();
        
        System.assert([select Application__c from EON_Appointment_Value__c where id=:appValue1.id].Application__c != null);
               
    }
    
    /**
        unitTest2() - unitTest2 Failure Test case
    **/
    static testmethod void unitTest2(){
        EON_Application__c app1 = new EON_Application__c();
        app1.Date_To__c = System.today() - 1;
        app1.Date_From__c = System.today();
        
        EON_Application_Ctrl controller = new EON_Application_Ctrl();        
        controller.application = app1;    
        controller.calculateValue(); 
        
        System.assert( controller.countAppointment == 0);  
        
    }
    
    /**
        unitTest3() - unitTest3 Failure Test case
    **/
    static testmethod void unitTest3(){        
        EON_Application_Ctrl controller = new EON_Application_Ctrl(); 
        controller.lstAppointmentValueID = null;          
        controller.createApplication();        
        System.assert( controller.countAppointment == 0);    
    }  
    
    /**
        unitTest4() - unitTest4 Failure Test case
    **/
    static testmethod void unitTest4(){
        EON_Application__c app1 = new EON_Application__c();
        app1.Date_To__c = System.today() ;
        app1.Date_From__c = System.today();
        
        EON_Application_Ctrl controller = new EON_Application_Ctrl();        
        controller.application = app1;    
        controller.calculateValue(); 
        System.assert( controller.countAppointment == 0);    
    }  
    
    /**
        unitTest5() - unitTest5 - Failure Test case
    **/
    static testmethod void unitTest5(){
        EON_Application__c app1 = new EON_Application__c();
        app1.Date_To__c = System.today() ;
        app1.Date_From__c = System.today();
        
        EON_Application_Ctrl controller = new EON_Application_Ctrl(); 
        controller.application = null;          
        controller.calculateValue(); 
        System.assert( controller.countAppointment == 0);    
    }  
    
    /**
        unitTest6() - unitTest6 - Failure Test case for bulk data
    **/
    static testmethod void unitTest6(){
    
        Contract_Number__c contract = EON_CreateTestRecords.createContractNumber();
        contract.Contract_Client_Short_Name__c = 'EON';
        insert contract;
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Appointment_Date__c = System.today();
        app.Contract__c = contract.id;
        insert app; 
        
        EON_Rate__c rate = new EON_Rate__c();
        rate.Name = 'AAAA-333';
        rate.Description__c = 'test Descriptoin';
        insert rate;
        
        List<EON_Appointment_Value__c> lstAppointmentValues1 = new List<EON_Appointment_Value__c>();
        for(integer i=0;i<5000;i++){
            EON_Appointment_Value__c appValue =  EON_CreateTestRecords.createEonAppointmentvalue();
            appValue.EON_Appointment__c =  app.id;
            appValue.Rate__c = rate.id;
            lstAppointmentValues1.add(appValue);            
        }
        insert lstAppointmentValues1;
        
        Test.startTest();
        List<EON_Appointment_Value__c> lstAppointmentValues2 = new List<EON_Appointment_Value__c>();
        for(integer i=0;i<5030;i++){
            EON_Appointment_Value__c appValue =  EON_CreateTestRecords.createEonAppointmentvalue();
            appValue.EON_Appointment__c =  app.id;
            appValue.Rate__c = rate.id;
            lstAppointmentValues2.add(appValue);            
        }
        insert lstAppointmentValues2;        
        Test.stopTest();
                
        EON_Application__c app1 = new EON_Application__c();
        app1.Date_To__c = System.today();
        app1.Date_From__c = System.today();
        
        EON_Application_Ctrl controller = new EON_Application_Ctrl();        
        controller.application = app1;
        controller.selectedContract = contract.id;  
        controller.calculateValue();  
        
        System.assert(controller.totalAppointmentValue >= 10000);
    }          
}