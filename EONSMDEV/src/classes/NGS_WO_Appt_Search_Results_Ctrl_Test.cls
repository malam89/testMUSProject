/**
    Description : This test class is used to cover the below classes
            NGS_WO_Appointment_Search_Results_Ctrl
**/
/*
    Created By : Puneet Mehta
    Created Date : 06/02/2017
    Service Request : SR_OptiMUS_NG_012
*/
@isTest
public class NGS_WO_Appt_Search_Results_Ctrl_Test{

    /**
        unitTest1() - unitTest1 - Success test case
    **/
    testmethod static void unitTest1(){
        NGS_Work_Order_Appointment__c app = new NGS_Work_Order_Appointment__c(City__c = 'MyCity', Country__c = 'Country', Appointment_Start_Time__c = system.now(), Appointment_Finish_Time__c = system.now(), Message_Date__c = system.today() ,Duration__c = '11:44',Name = 'WO-XXXX', Address_Line_1__c = 'Add1', Post_Code__c = 'SG1 2ST');
        insert app;
        System.currentPageReference().getParameters().put('woNumber', 'WO-XXXX');
        System.currentPageReference().getParameters().put('address1', 'Add1');
        System.currentPageReference().getParameters().put('postCode', 'SG1 2ST');
        NGS_WO_Appointment_Search_Results_Ctrl controller = new NGS_WO_Appointment_Search_Results_Ctrl();
        PageReference pg = controller.displayRecord();
        System.assert(pg != null);
        controller.next();
        controller.previous();
    }

    /**
        unitTest2() - unitTest2 - Failure test case
    **/
    testmethod static void unitTest2(){
        NGS_WO_Appointment_Search_Results_Ctrl controller = new NGS_WO_Appointment_Search_Results_Ctrl();
        PageReference pg = controller.displayRecord();
        System.assert(pg == null);
        controller.previous();
    }
}