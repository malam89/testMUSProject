/**
Description : This test class is for the following below classes/triggers
              EON_Complaint_View_Controller
              
**/

/*
    Created By  : Mehboob Alam
    Created On  : 02/10/2017
    Service Req : SR_OptiMUS_EON_107
    Covering Components : EON_Complaint_View_Controller
    Change History
*/
@isTest
private class EON_Complaint_View_Controller_Test {

    static testMethod void myUnitTest() {
        
         EON_Complaint__c eonCOmplaint =  new EON_Complaint__c();
         eonCOmplaint.Complainant_Name__c='Aalm';
         eonCOmplaint.Customer_Name__c='Aalm';
         eonCOmplaint.Preferred_Contact_Method__c ='TelePhone';
         eonCOmplaint.TelePhone__c ='07466993698';
         eonCOmplaint.Complaint_Received_By__c ='Voice';
         eonCOmplaint.Complaint_Type__c ='Colleague Appearance';
         eonCOmplaint.Complaint_status__c = 'Raised';
         eonCOmplaint.Complaint_Category_Level_1__c = 'Other';
         eonCOmplaint.Complaint_Description__c = 'test';
         eonCOmplaint.MPAN__c ='12345';
         insert eonCOmplaint;
         
         EON_Complaint__c eonCOmplaint1 =  new EON_Complaint__c();
         eonCOmplaint1.Complainant_Name__c='Aalm';
         eonCOmplaint1.Customer_Name__c='Aalm';
         eonCOmplaint1.Preferred_Contact_Method__c ='TelePhone';
         eonCOmplaint1.TelePhone__c ='07466993698';
         eonCOmplaint1.Complaint_Received_By__c ='Voice';
         eonCOmplaint1.Complaint_Type__c ='Colleague Appearance';
         eonCOmplaint1.Complaint_status__c = 'Raised';
         eonCOmplaint1.Complaint_Category_Level_1__c = 'Other';
         eonCOmplaint1.Complaint_Description__c = 'test';
         eonCOmplaint1.MPAN__c ='12345';
         insert eonCOmplaint1;
         
         ApexPages.StandardController stdController = new ApexPages.StandardController(eonCOmplaint);
         stdController.getRecord();
         EON_Complaint_View_Controller controller = new EON_Complaint_View_Controller(stdController);
    }
}