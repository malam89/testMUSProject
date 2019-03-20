/**
    Description : this class do the coverage of the below
                1. EON_Failed_Asset_Trigger
                2. EON_Failed_Asset_Trigger_Helper

**/
/*
    Created By : Praveen G
    Created Date : 05/01/2018
    Service Request : SR_OptiMUS_EON_190
    Change History : 
    CH01 # SR_OptiMUS_EON_224 # 23/03/2018 # Abhilash #  code covergae for sendmail method in helper class
*/

@isTest
public class EON_Failed_Asset_Trigger_Test{
    
    /**
        unitTest() - unitTest
    **/
    public static testmethod void unitTest(){
        
        /**
        EON_Stock_Profile__c profile = new EON_Stock_Profile__c();
        profile.name = 'Test_Profile';
        insert profile;
        **/
        
        EON_Job_Results__c jobResult = EON_CreateTestRecords.createEon_Job_Results();
        EON_Technician__c technician = new EON_Technician__c(id=jobResult.Technician__c);
        //technician.stock_Profile__c = profile.id;
        update technician;
        
        jobResult.time_on_site__c = System.now();
        insert jobResult;
        
         List<EON_Technician__c> TechList= EON_CreateTestRecords.createEonTechnicianList();        
        insert TechList;    
              
        
        EON_Stock__c[] stock  = EON_CreateTestRecords.createEonStockList();
        stock[0].Serial_Number__c = '125987'; 
        stock[0].Technician_Name__c =TechList[0].id; 
        //ch01 starts
        stock[0].Status__c='Test';
        //ch01 ends
        insert stock[0]; 
        
        EON_Failed_Asset__c failedAsset = new EON_Failed_Asset__c();
        failedAsset.EON_Job_Results__c = jobResult.id;
        failedAsset.Failed_Asset_Type__c = 'Smart Electric Meter';
        failedAsset.Failure_Reason__c = 'Already Associated to Another MPAN/MPRN';
        failedAsset.Failed_Asset_Serial_Number__c = '125987';
        insert failedAsset;
        
        System.assert('SEUSED' == 
                [select h_Failure_Code__c from EON_Failed_Asset__c where id =:failedAsset.id].h_Failure_Code__c);
        
        failedAsset.EON_Job_Results__c = jobResult.id;
        failedAsset.Failed_Asset_Type__c = '';
        update failedAsset;
        
        System.assert(null == 
                [select h_Failure_Code__c from EON_Failed_Asset__c where id =:failedAsset.id].h_Failure_Code__c);
                
        //ch01 starts
        EON_Failed_Asset_Trigger_Helper.sendmail(failedAsset,'Test');
        //ch01 ends
    }
}