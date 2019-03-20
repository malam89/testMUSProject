/**
    Description : This test class is for the following below classes/triggers
    EON_Appointment_Asynchronous_Helper
    EON_Appointment_MDS_Asynchronous_Helper           
**/

/*
    Created By  : Tabish Almas
    Created On  : 08/02/2019
    Service Req : SR_OptiMUS_EON_297
    Change History :
*/

@isTest
public with sharing class EON_Appointment_Asynchronous_Test {
	static testMethod void testMethod1(){
        EON_Appointment_Cancel_Reason__c reason = new EON_Appointment_Cancel_Reason__c(name ='test name',Reason_key__c = 'x123');
    	insert reason;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Cancel_Reason__c = reason.id;
        appt.Cancellation_DateTime__c = System.now();
        Insert appt;
        
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(appt);
        
        Test.startTest();
        EON_Appointment_Asynchronous_Helper helper1 = new EON_Appointment_Asynchronous_Helper(sc);
        Test.stopTest();
    }
    static testMethod void testMethod2(){
        EON_Appointment_Cancel_Reason__c reason = new EON_Appointment_Cancel_Reason__c(name ='test name',Reason_key__c = 'x123');
    	insert reason;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Cancel_Reason__c = reason.id;
        appt.Cancellation_DateTime__c = System.now();
        Insert appt;
        
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(appt);
        
        Test.startTest();
        EON_Appointment_MDS_Asynchronous_Helper helper2 = new EON_Appointment_MDS_Asynchronous_Helper(sc);
        Test.stopTest();
    }
    
    static testMethod void testMethod3(){
        EON_Appointment_Cancel_Reason__c reason = new EON_Appointment_Cancel_Reason__c(name ='test name',Reason_key__c = 'x123');
    	insert reason;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Cancel_Reason__c = reason.id;
        appt.Cancellation_DateTime__c = System.now();
        Insert appt;
        
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = true,
                                                                                  MDS_Status__c = false,
                                                                                  MDS_Close_Command_Only__c = true);
        insert mdsSwitch;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(appt);
        
        Test.startTest();
        EON_Appointment_Asynchronous_Helper helper1 = new EON_Appointment_Asynchronous_Helper(sc);
        Test.stopTest();
    }
    static testMethod void testMethod4(){
        EON_Appointment_Cancel_Reason__c reason = new EON_Appointment_Cancel_Reason__c(name ='test name',Reason_key__c = 'x123');
    	insert reason;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Cancel_Reason__c = reason.id;
        appt.Cancellation_DateTime__c = System.now();
        Insert appt;
        
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = true,
                                                                                  MDS_Status__c = false,
                                                                                  MDS_Close_Command_Only__c = true);
        insert mdsSwitch;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(appt);
        
        Test.startTest();
        EON_Appointment_MDS_Asynchronous_Helper helper2 = new EON_Appointment_MDS_Asynchronous_Helper(sc);
        Test.stopTest();
    }
}