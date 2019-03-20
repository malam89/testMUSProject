/**
    Description : This test class is used to cover the below classes.
            1. EON_Eligibility_Override_Create_Ctrl
            2. EON_Site_Vul_Handler
**/
/*
    Created By : Praveen G
    Created Date : 30/10/2017
    Service Request : SR_OptiMUS_EON_136
*/
@isTest
public class EON_Eligibility_Overd_Create_Ctrl_Test{

    /**
        unitTest1() - unittest1
    **/
    public static testmethod void unitTet1(){
        EON_Region__c region = new EON_Region__c(GSP_ID__c =12);        
        insert region;
        EON_Shutdown_Days__c days = new EON_Shutdown_Days__c(Name='Bank holiday',Holiday_Date__c=System.today());
        insert days;
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite =  new EON_Site__c(Customer__c=eCust.ID, Name = '1234567890',
                            Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',
                            Address_Type__c = 'S',Country__c = null ,County__c = null,
                            Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',
                            Double_Dependant_Locality__c = 'Stevenage',Sub_Building_Name__c = 'Stevenage',
                            Thorofare__c = 'Stevenage',Town__c = 'Stevenage');
        insert eSite;   
        
        EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c flag = new EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c();
        flag.Name = 'TEST';
        insert flag;        
        
        EON_Eligibility_Override__c siteVul = new EON_Eligibility_Override__c();
        siteVul.Premise__c = eSite.id; 
        siteVul.Eligibility_Code__c = flag.id;      
        
        ApexPages.currentPage().getParameters().put('siteID', eSite.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(siteVul);
        
        EON_Eligibility_Override_Create_Ctrl ctrl = new EON_Eligibility_Override_Create_Ctrl(sc);
        ctrl.getEligibilityFlags();
        ctrl.gotoSite();
        ctrl.saveRec();      
        
        ctrl.selectedFlag = flag.id;
        ctrl.saveRec();
        
        ctrl.selectedFlag = flag.id;
        System.assert(ctrl.saveRec() == null);        
        
        EON_Eligibility_Override__c siteVul1 = new EON_Eligibility_Override__c();
        siteVul1.Premise__c = eSite.id; 
        siteVul1.Eligibility_Code__c = flag.id;
        siteVul1.Customer__c= eCust.id;
        insert siteVul1;  
        
        ctrl.selectedFlag = flag.id;
        ctrl.saveRec();              
        

    }
    
    /**
        unitTest2() - unittest2
    **/
    public static testmethod void unitTet2(){
        EON_Site_Vul_Handler.UpdateSiteVulnerabilityAsDelete(null);
        
        EON_Region__c region = new EON_Region__c(GSP_ID__c =12);        
        insert region;
        EON_Shutdown_Days__c days = new EON_Shutdown_Days__c(Name='Bank holiday',Holiday_Date__c=System.today());
        insert days;
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite =  new EON_Site__c(Customer__c=eCust.ID, Name = '1234567890',
                            Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',
                            Address_Type__c = 'S',Country__c = null ,County__c = null,
                            Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',
                            Double_Dependant_Locality__c = 'Stevenage',Sub_Building_Name__c = 'Stevenage',
                            Thorofare__c = 'Stevenage',Town__c = 'Stevenage');
        insert eSite;   
        
        EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c flag = new EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c();
        flag.Name = 'TEST';
        insert flag;         
        
        EON_Eligibility_Override__c siteeligOverride = new EON_Eligibility_Override__c();
        siteeligOverride.Premise__c = eSite.id; 
        siteeligOverride.Eligibility_Code__c = flag.id;
        siteeligOverride.Customer__c= eCust.id;
        insert siteeligOverride;
        
        System.assert(EON_Site_Vul_Handler.UpdateSiteEligibilityOverrideAsDelete(siteeligOverride.id) == 'SUCCESS');
                
        
    }    

}