/**
    Description : This test class is used to cover the below classes
            EON_Appointment_Search_Results_Ctrl
**/
/*
    Created by : Praveen G
    Created Date : 11-April-2016
    Service Request : SR_Isis_EON_015
*/
@isTest
public class EON_Appointment_Search_Results_Ctrl_Test{

    /**
        unitTest1() - unitTest1 - Success test case
    **/
    testmethod static void unitTest1(){
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.Customer_Name__c = 'test Cust';
        app.MPAN__c = '12345';
        app.MPRN__c = '12356';
        insert app;
        EON_Appointment__c appointment = [select name from EON_Appointment__c where id =: app.id];
        
        System.currentPageReference().getParameters().put('appointmentID', appointment.Name);
        System.currentPageReference().getParameters().put('customerName', app.Customer_Name__c);
        System.currentPageReference().getParameters().put('mpan', app.MPAN__c);
        System.currentPageReference().getParameters().put('mprn', app.MPRN__c);
        
        EON_Appointment_Search_Results_Ctrl controller = new EON_Appointment_Search_Results_Ctrl();
        PageReference pg = controller.displayRecord();
        
        System.assert(pg != null);
    }
    
    /**
        unitTest2() - unitTest2 - Failure test case
    **/
    testmethod static void unitTest2(){
    
        EON_Appointment_Search_Results_Ctrl controller = new EON_Appointment_Search_Results_Ctrl();
        PageReference pg = controller.displayRecord();
        
        System.assert(pg == null);    
    }    
}