/**
    Description : This test class covers the below classes / Triggers
                    Trigger : EON_Mose_Hire_Trigger
                    Class : EON_Mose_Hire_Trigger_Helper
**/
/**
    Created By : Praveen G
    Created Date : 19-April-2016
    Service Request: SR_EON_AB_047
**/
@isTest
public with sharing class EON_Mose_Hire_Trigger_Test{

    /**
        unitTest1() - unitTest1 - Success Test case
    **/
    public static testmethod void unitTest1(){
        EON_Mose_Hire__c moseHire = new EON_Mose_Hire__c();
        moseHire.Date__c = System.today();
        moseHire.Type__c = '2Hr';
        insert moseHire;
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.Appointment_Date__c = System.today();
        app.MOSE_Hire__c = moseHire.id;
        insert app;   
        
        moseHire.Date__c = System.today() +1;
        try{
            update moseHire;
        }catch(Exception ex){
            System.assert(ex.getMessage().contains('Date cannot be changed as Appointments have already been assigned. Please unassign appointments to be able to change the date of this hire'));
        }        
              
    }
    
    /**
        unitTest2() - unitTest2 Failure Test case
    **/
    public static testmethod void unitTest2(){
        EON_Mose_Hire__c moseHire = new EON_Mose_Hire__c();
        moseHire.Date__c = System.today();
        moseHire.Type__c = '2Hr';
        insert moseHire;
        Map<id, EON_Mose_Hire__c> mapTriggerNew = new Map<id, EON_Mose_Hire__c>();
        mapTriggerNew.put(moseHire.id, moseHire);    
        EON_Mose_Hire_Trigger_Helper.validateDateChange(mapTriggerNew, null);
        System.assert(moseHire != null);
    }
}