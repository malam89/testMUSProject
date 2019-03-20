/**
Description : This test class is for the following below classes/triggers
              	Apex Trigger - EON_Complaint_Trigger
				Apex Class - EON_Complaint_Trigger_Helper
**/
/* 
Created By    : Mahadev J
Created On    : 28/04/2016
Service Req   : SR_EON_PC_015
Change History
*/
@isTest
public class EON_Complaint_Trigger_Helper_Test 
{
    public static boolean genException;
	/**
    	eonInsertWithNormal(): Pass - This method will check email on insert at EON Complain with Normal severity
    **/
     @isTest static void eonInsertWithNormal()
     {
         EON_Complaint__c eonCOmplaint = EON_CreateTestRecords.createEonComplaint();
         eonCOmplaint.Complaint_status__c = 'Raised';
         eonCOmplaint.Complaint_Category_Level_1__c = 'Other';
         insert eonCOmplaint;
         
         //eonCOmplaint.Complaint_Category_Level_1__c = 'High priority';
         //update eonCOmplaint;
     }
    /**
    	eonInsertWithHighest(): Pass - This method will check email on insert at EON Complain with Highest severity
    **/
     @isTest static void eonInsertWithHighest()
     {
         EON_Complaint__c eonCOmplaint = EON_CreateTestRecords.createEonComplaint();
         eonCOmplaint.Complaint_status__c = 'Raised';
         eonCOmplaint.Complaint_Category_Level_1__c = 'High priority';
         insert eonCOmplaint;
         
         //eonCOmplaint.Complaint_Category_Level_1__c = 'High priority';
         //update eonCOmplaint;
     }
    
    /**
    	eonUpdateWithNormal(): Pass - This method will check email on update at EON Complain with Normal severity
    **/
     @isTest static void eonUpdateWithNormal()
     {
         EON_Complaint__c eonCOmplaint = EON_CreateTestRecords.createEonComplaint();
         eonCOmplaint.Complaint_status__c = 'Raised';
         //eonCOmplaint.Complaint_Category_Level_1__c = 'High priority';
         insert eonCOmplaint;
         
         eonCOmplaint.Complaint_Category_Level_1__c = 'Other';
         update eonCOmplaint;
     }
    /**
    	eonUpdateWithHighest(): Pass - This method will check email on update at EON Complain with Highest severity
    **/
     @isTest static void eonUpdateWithHighest()
     {
         EON_Complaint__c eonCOmplaint = EON_CreateTestRecords.createEonComplaint();
         eonCOmplaint.Complaint_status__c = 'Raised';
         //eonCOmplaint.Complaint_Category_Level_1__c = 'High priority';
         insert eonCOmplaint;
         
         EON_Complaint_Trigger_Helper_Test.genException = null;
         eonCOmplaint.Complaint_Category_Level_1__c = 'High priority';
         update eonCOmplaint;
     }
    
    /**
    	eonInsertException(): Pass - This wull generate exception
    **/
     @isTest static void eonInsertException(){
         EON_Complaint_Trigger_Helper_Test.genException = true;
         EON_Complaint__c eonCOmplaint = EON_CreateTestRecords.createEonComplaint();
         eonCOmplaint.Complaint_status__c = 'Raised';
         eonCOmplaint.Complaint_Category_Level_1__c = 'Other';
         insert eonCOmplaint;
     }
    /**
    	eonInsertException(): Pass - This wull generate exception
    **/
     @isTest static void eonUpdateException(){
         EON_Complaint__c eonCOmplaint = EON_CreateTestRecords.createEonComplaint();
         eonCOmplaint.Complaint_status__c = 'Raised';
         insert eonCOmplaint;
         
         EON_Complaint_Trigger_Helper_Test.genException = true;
         eonCOmplaint.Complaint_Category_Level_1__c = 'Other';
         update eonCOmplaint;
     }
}