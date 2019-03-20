/**
Description : This test class is for the below classes
              EON_Voice_Update_Customer_WS
              EON_Voice_Update_Customer_WS_Helper
**/
/*
    Created By  : Mahadev Joshilkar
    Created On  : 16/03/2016
    Service Req : SR_EON_PC_008
    Change History 
    CH01 # SR_EON_PC_053 # 17/05/2016# Shivram Survase # Changed field name from 'ContactMethod' to 'ContactMediaID' and commented out non-usable code.   
    CH02 # SR_EON_PC_055 # 19/05/2016 # Tashika Gupta # Added field representative in Eon contact media as Converted to MD relation as part of SR.
    CH03 # SR_EON_PC_057 # 19/05/2016 # Pedda Reddeiah R # Added EON Site Id this two objects EON Opt in / Opt Out Preference,EON Site Vulnerability (Look up to Master details). 
    CH04 # SR_EON_PC_058 # 24/05/2016 # Mahadev J # Back up original copy and written new test class as Webservice is changed for request, response paramter inclusing logic to process request.
    CH05 # SR_EON_Jumbo_030 # 09/06/2016 # Mehbobo Alam # Added  'Vulnerability Source' field value.
    CH06 # SR_EON_PC_069 # 13/06/2016 # Mahadev J # Addtional validations for objects EON Service Contact Consent, EON Site and EON Opt In/Opt Out Preference.
    CH07 # SR_EON_PC_076 # 24/06/2016 # Mahadev J # WSDL structure changed with new specifications.
    CH08 # SR_EON_PC_080 # 25/06/2016 # Mahadev J # Updated test coverage.
    CH09 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Deleted reference of field Vulnerability_Source__c
*/

@isTest

public class EON_Voice_Update_Customer_WS_Test{
    /**
        setup(): Method to setup test data for the class
    **/
    @testSetup static void setup(){
        //Create EON Error Records
        list<EON_Error_Code__c> allError = new list<EON_Error_Code__c>();
        EON_Error_Code__c error = EON_CreateTestRecords.createEONErrorCode();
        error.name='001';
        error.Error_Name__c = 'UnknownError';
        error.Type__c = 'Error';
        error.Description__c = 'Test - UnknownError';
        allError.add(error);
        EON_Error_Code__c errorNew = EON_CreateTestRecords.createEONErrorCode();
        errorNew.name='002';
        errorNew.Error_Name__c = 'DmlException';
        errorNew.Type__c = 'Error';
        errorNew.Description__c = 'Test - DmlException';
        allError.add(errorNew);
        EON_Error_Code__c errorCustom = EON_CreateTestRecords.createEONErrorCode();
        errorCustom.name='003';
        errorCustom.Error_Name__c = 'CustomError';
        errorCustom.Type__c = 'Error';
        errorCustom.Description__c = 'Test - CustomError';
        allError.add(errorCustom);
        EON_Error_Code__c errorUnknown = EON_CreateTestRecords.createEONErrorCode();
        errorUnknown.name='100';
        errorUnknown.Error_Name__c = 'UnknownError';
        errorUnknown.Type__c = 'Error';
        errorUnknown.Description__c = 'Test - UnknownError';
        allError.add(errorUnknown);        
        insert allError;
        
        //Create EON County
        EON_County__c eonCounty = EON_CreateTestRecords.createEONCounty();
        eonCounty.COUNTY_ID__c = 11;
        insert eonCounty;
        
        //Create EON Country
        EON_Country__c eonCountry = EON_CreateTestRecords.createEonCountry();
        eonCountry.COUNTRY_ID__c = 11;
        insert eonCountry;
        
        //Create EON PAYG Deferral Reason
        EON_PAYG_Deferral_Reason__c paygInt = EON_CreateTestRecords.createEONPaygDeferralReason();
        paygInt.Name = 'Test PAYG';
        insert paygInt;
        
        //Create EON Contact Method
        list<EON_Contact_Method__c> lstContactMethod = new list<EON_Contact_Method__c>();
        EON_Contact_Method__c contactMethod4 = EON_CreateTestRecords.createContactMethod();
        contactMethod4.name = 'Test';
        contactMethod4.Media_Type__c = 4;
        lstContactMethod.add(contactMethod4);
        
        EON_Contact_Method__c contactMethod21 = EON_CreateTestRecords.createContactMethod();
        contactMethod21.name = 'Test1';
        contactMethod21.Media_Type__c = 12; //21to12
        lstContactMethod.add(contactMethod21);
        
        EON_Contact_Method__c contactMethod1 = EON_CreateTestRecords.createContactMethod();
        contactMethod1.name = 'Test2';
        contactMethod1.Media_Type__c = 1;
        lstContactMethod.add(contactMethod1);
        insert lstContactMethod;
        
        //Create EON Fulfillment
        EON_Fulfillment__c fulfilment = EON_CreateTestRecords.createEonFulfilment();
        fulfilment.name='Test';
        insert fulfilment;
        
        //Create EON Role Type Representative
        EON_ROLE_TYPE_REPRESENTATIVE__c roleTypeRepresentative = EON_CreateTestRecords.createEonRoleTypeRepresntative();
        roleTypeRepresentative.Name = '123';
        roleTypeRepresentative.Role_Type__c = 123;
        insert roleTypeRepresentative;
        
        //Create EON Contact Outcome
        list<EON_Contact_Outcome__c> allContactOutcome = new list<EON_Contact_Outcome__c>();
        EON_Contact_Outcome__c conOutcome = EON_CreateTestRecords.createContactOutcome();
        conOutcome.name = 'TestConOut';
        conOutcome.code__c = 1;
        allContactOutcome.add(conOutcome);
        
        EON_Contact_Outcome__c conOutcomeOther = EON_CreateTestRecords.createContactOutcome();
        conOutcomeOther.name = 'Other';
        conOutcomeOther.code__c = 2;
        allContactOutcome.add(conOutcomeOther);
        insert allContactOutcome;
        
        //Create EON Vulnerability
        EON_Vulnerability_Code__c eonVulnerabilityCode = EON_CreateTestRecords.createVulnerabilityCode();
        eonVulnerabilityCode.name = 'TestVC';
        eonVulnerabilityCode.Vulnerability_Code__c = 98;
        insert eonVulnerabilityCode;
        
        //Create EON Overrideable Eligibility Flag
        EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c eonOverrideableEligivbilityFlag = EON_CreateTestRecords.createOverrideableEligivbilityFlag();
        eonOverrideableEligivbilityFlag.name = 'TestOEF';
        eonOverrideableEligivbilityFlag.Opt_Out_ID__c = 98;
        insert eonOverrideableEligivbilityFlag;
        
        //Create EON Opt Out Reason
        list<EON_Opt_Out_Reason__c> allEONOptOutReason = new list<EON_Opt_Out_Reason__c>();
        EON_Opt_Out_Reason__c eonOptOutReason = EON_CreateTestRecords.createEONOpOutReason();
        eonOptOutReason.Reason_Code__c = 10;
        allEONOptOutReason.add(eonOptOutReason);
        EON_Opt_Out_Reason__c eonOptOutReasonNew = EON_CreateTestRecords.createEONOpOutReason();
        eonOptOutReasonNew.Reason_Code__c = 11;
        allEONOptOutReason.add(eonOptOutReasonNew);
        insert allEONOptOutReason;
        
        //Create EON Customer
        list<EON_Customer__c> allCustomer = new list<EON_Customer__c>();
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        customer.Name = '9999999999';
        allCustomer.add(customer);
        
        EON_Customer__c customerNew = EON_CreateTestRecords.createEONCustomer();
        customerNew.Name = '7777777777';
        allCustomer.add(customerNew);
        
        EON_Customer__c customerD = EON_CreateTestRecords.createEONCustomer();
        customerD.Name = '8888888888';
        customerD.Eon_Customer_Change_Type__c = 'D';
        allCustomer.add(customerD);       
        insert allCustomer;
        
        //Create EON Contact Representative
        list<EON_Contact_representative__c> allContactRep = new list<EON_Contact_representative__c>();
        EON_Contact_representative__c representative = EON_CreateTestRecords.createEonContactRepresentative();
        representative.Name = '1223';
        representative.Customer__c = customer.ID;
        allContactRep.add(representative);
        
        EON_Contact_representative__c representativeD = EON_CreateTestRecords.createEonContactRepresentative();
        representativeD.Name = '1224';
        representativeD.Eon_Contact_Representative_Change_Type__c = 'D';
        representativeD.Customer__c = customerD.ID;
        allContactRep.add(representativeD);
        insert allContactRep;
        
        //Create EON Contact Media
        EON_Contact_Media__c contactMedia = EON_CreateTestRecords.createEonContactMedia();
        contactMedia.Name = '1234';
        contactMedia.Customer__c = customer.ID;
        contactMedia.Representative__c = representative.ID;
        insert contactMedia;
        
        EON_Contact_Media__c contactMediaNew = EON_CreateTestRecords.createEonContactMedia();
        contactMediaNew.Name = '2345';
        contactMediaNew.Customer__c = customer.ID;
        contactMediaNew.Representative__c = representative.ID;
        insert contactMediaNew;
        
        //Create EON Service Contact Consent
        EON_Service_Contact_Consent__c serviceContactConsent = EON_CreateTestRecords.createEonServiceContactConsent();
        serviceContactConsent.Customer__c = customer.ID;
        insert serviceContactConsent;
        
        //Create EON Site
        list<EON_Site__c> allSite = new list<EON_Site__c>();
        EON_Site__c eonSite = EON_CreateTestRecords.cereateEONSite();
        eonSite.name = '0987654321';
        eonSite.Customer__c = customer.ID;
        eonSite.Address_Type__c = 'C';
        allSite.add(eonSite);

        EON_Site__c eonSite1 = EON_CreateTestRecords.cereateEONSite();
        eonSite1.name = '0987654324';
        eonSite1.Customer__c = customer.ID;
        eonSite1.Address_Type__c = 'C';
        allSite.add(eonSite1);
        
        EON_Site__c eonSiteD = new EON_Site__c();//EON_CreateTestRecords.cereateEONSite();
        eonSiteD.name = '0987654322';
        eonSiteD.Customer__c = customerD.ID;
        eonSiteD.EON_Site_Change_Type__c = 'D';
        eonSiteD.Address_Type__c = 'C';
        allSite.add(eonSiteD);
        
        EON_Site__c eonSiteTypeS = new EON_Site__c();//EON_CreateTestRecords.cereateEONSite();
        eonSiteTypeS.name = '0987654323';
        eonSiteTypeS.Customer__c = customer.ID;
        eonSiteTypeS.Address_Type__c = 'S';        
        allSite.add(eonSiteTypeS); 
        
        EON_Site__c eonSiteTypeSite = new EON_Site__c();//EON_CreateTestRecords.cereateEONSite();
        eonSiteTypeSite.name = '0987654325';
        eonSiteTypeSite.Customer__c = customer.ID;
        eonSiteTypeSite.Address_Type__c = 'S';        
        allSite.add(eonSiteTypeSite);    
        insert allSite;
        
        //Create EON Site Vulnerability
        list<EON_Site_Vulnerability__c> allSiteVulnerability = new list<EON_Site_Vulnerability__c>();
        EON_Site_Vulnerability__c siteVulnerability = EON_CreateTestRecords.createEonSiteVulnerability();
        siteVulnerability.Premise__c = eonSite1.ID;
        siteVulnerability.Customer__c = customer.ID;
        siteVulnerability.Vulnerability_code__c = eonVulnerabilityCode.ID;
        siteVulnerability.Vulnerability_Type__c = 'C';
        allSiteVulnerability.add(siteVulnerability);
        
        EON_Site_Vulnerability__c siteVulnerabilityDel = EON_CreateTestRecords.createEonSiteVulnerability();
        siteVulnerabilityDel.Premise__c = eonSite1.ID;
        siteVulnerabilityDel.Customer__c = customerD.ID;
        siteVulnerabilityDel.EON_Site_Vulnerability_Change_Type__c = 'D';
        siteVulnerabilityDel.Vulnerability_code__c = eonVulnerabilityCode.ID;
        siteVulnerabilityDel.Vulnerability_Type__c = 'C';
        allSiteVulnerability.add(siteVulnerabilityDel);
        insert allSiteVulnerability;
        
        //Create EON Opt In Opt Out Preference
        list<EON_Opt_in_Opt_Out_Preference__c> createOptInOptOutPref = new list<EON_Opt_in_Opt_Out_Preference__c>();
        EON_Site__c searchSite = [Select ID from EON_Site__c where Name=:'0987654321' limit 1];
        EON_Opt_in_Opt_Out_Preference__c eonOptInOptOutPref = EON_CreateTestRecords.createEonOptInOptOutPreference();
        eonOptInOptOutPref.Premise__c = searchSite.ID;
        createOptInOptOutPref.add(eonOptInOptOutPref); 
        
        for(integer i=0; i<7; i++){
            EON_Opt_in_Opt_Out_Preference__c rec = new EON_Opt_in_Opt_Out_Preference__c();
            rec.Premise__c = eonSiteTypeSite.ID;
            rec.Customer__c = customer.ID;
            createOptInOptOutPref.add(rec);
        }
        EON_Opt_in_Opt_Out_Preference__c rec = new EON_Opt_in_Opt_Out_Preference__c();
        rec.Premise__c = eonSiteTypeS.ID;
        rec.Customer__c = customer.ID;
        createOptInOptOutPref.add(rec);
        insert createOptInOptOutPref;
        
        //Create EON Eligibility Override
        list<EON_Eligibility_Override__c> allOverride = new list<EON_Eligibility_Override__c>();
        EON_Eligibility_Override__c eOverride = new EON_Eligibility_Override__c();
        eOverride.Customer__c = customer.ID;
        eOverride.Eligibility_Change_Type__c = 'U';
        eOverride.Eligibility_Code__c = eonOverrideableEligivbilityFlag.ID;
        eOverride.Premise__c = searchSite.ID;
        allOverride.add(eOverride);
        
        EON_Eligibility_Override__c eOverrideD = new EON_Eligibility_Override__c();
        eOverrideD.Customer__c = customer.ID;
        eOverrideD.Eligibility_Change_Type__c = 'D';
        eOverrideD.Eligibility_Code__c = eonOverrideableEligivbilityFlag.ID;
        eOverrideD.Premise__c = searchSite.ID;
        allOverride.add(eOverrideD);
        insert allOverride;
    }
    
    /**
        validateUpdateEONCustomer(): This method will cover EON Customer with failure scenario - FAIL
    **/
    static testmethod void validateUpdateEONCustomer(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerNew = [Select ID from EON_Customer__c where name='7777777777' limit 1];
        EON_Voice_Update_Customer_WS.EONCustomer cust = new EON_Voice_Update_Customer_WS.EONCustomer();
        cust.Customer_ID = '9955667744';
        cust.Customer_SFID = customer.ID;
        cust.CustomerPAYGInterest = '66';
        cust.SmartInterest = 'C';
        list<EON_Voice_Update_Customer_WS.EONCustomer> allCust = new list<EON_Voice_Update_Customer_WS.EONCustomer>();
        allCust.add(cust);
        EON_Voice_Update_Customer_WS.EONCustomers request = new EON_Voice_Update_Customer_WS.EONCustomers();
        request.EONCustomer = allCust;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //ReferenceID is blank
        cust.ReferenceID = '';
        response = EON_Voice_Update_Customer_WS.UpdateEONCustomer(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Smart Interest
        cust.ReferenceID = '001';
        response = EON_Voice_Update_Customer_WS.UpdateEONCustomer(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Customer PAYG Interest
        cust.SmartInterest = 'Y';
        response = EON_Voice_Update_Customer_WS.UpdateEONCustomer(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Muliple Customer update with duplicate ReferenceID
        EON_Voice_Update_Customer_WS.EONCustomer custNew = new EON_Voice_Update_Customer_WS.EONCustomer();
        custNew.Customer_ID = '7777777777';
        custNew.Customer_SFID = customerNew.ID;
        custNew.CustomerPAYGInterest = '66';
        custNew.ReferenceID = '001';
        custNew.SmartInterest = 'Y';
        allCust.add(custNew);    
        response = EON_Voice_Update_Customer_WS.UpdateEONCustomer(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Cover exception
        custNew.ReferenceID = '002';
        custNew.Customer_SFID = 'abc';
        response = EON_Voice_Update_Customer_WS.UpdateEONCustomer(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        updateEONCustomer(): This method will cover success scenario while updating EON Customer - PASS
    **/
    static testmethod void updateEONCustomer(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONCustomer cust = new EON_Voice_Update_Customer_WS.EONCustomer();
        cust.Customer_ID = '9955667744';
        cust.Customer_SFID = customer.ID;
        cust.CustomerPAYGInterest = 'Test PAYG';
        cust.ReferenceID = '001';
        cust.SmartInterest = 'Y';
        list<EON_Voice_Update_Customer_WS.EONCustomer> allCust = new list<EON_Voice_Update_Customer_WS.EONCustomer>();
        allCust.add(cust);
        EON_Voice_Update_Customer_WS.EONCustomers request = new EON_Voice_Update_Customer_WS.EONCustomers();
        request.EONCustomer = allCust;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Covers exception while update
        cust.Customer_ID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.UpdateEONCustomer(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        
        //Success scenario
        cust.Customer_ID = '9955667744';
        response = EON_Voice_Update_Customer_WS.UpdateEONCustomer(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        
        //Cover Exception
        EON_Utility.genException = true;
        response = EON_Voice_Update_Customer_WS.UpdateEONCustomer(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    
    /**
        validateCreateEONCustomerContactOutcome(): This method will cover EON Customer Contact Outcome with failure scenario - FAIL
    **/
    static testmethod void validateCreateEONCustomerContactOutcome(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContactOutcome CustomerContactOutcome = new EON_Voice_Update_Customer_WS.EONCustomerContactOutcome();
        list<EON_Voice_Update_Customer_WS.EONCustomerContactOutcome> allCustomerContactOutcome = new list<EON_Voice_Update_Customer_WS.EONCustomerContactOutcome>();
        allCustomerContactOutcome.add(CustomerContactOutcome);
        EON_Voice_Update_Customer_WS.EONCustomerContactOutcomes request = new EON_Voice_Update_Customer_WS.EONCustomerContactOutcomes();
        request.Customer_SFID = 'a0K4E000000MsMV';
        request.EONCustomerContactOutcome = allCustomerContactOutcome;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Blank ReferenceID
        CustomerContactOutcome.ReferenceID = '';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Customer SFID
        CustomerContactOutcome.ReferenceID = '001';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Customer Salesoforce ID, coveres exception
        request.Customer_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Contact Method
        request.Customer_SFID = customer.ID;
        CustomerContactOutcome.ReferenceID = '001';
        CustomerContactOutcome.AttemptedContactMethodCode = '99';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Contact Outcome Code
        CustomerContactOutcome.AttemptedContactMethodCode = '4';
        CustomerContactOutcome.ContactOutcomeCode = '55';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Fulfillment Code
        CustomerContactOutcome.ContactOutcomeCode = '1';
        CustomerContactOutcome.FulfilmentCode = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record with duplicate ReferenceID
        CustomerContactOutcome.FulfilmentCode = 'Test';
        EON_Voice_Update_Customer_WS.EONCustomerContactOutcome CustomerContactOutcome2 = new EON_Voice_Update_Customer_WS.EONCustomerContactOutcome();
        CustomerContactOutcome2.ReferenceID = '001';
        allCustomerContactOutcome.add(CustomerContactOutcome2);
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record with one having incorrect Contact Method
        CustomerContactOutcome2.ReferenceID = '002';
        CustomerContactOutcome2.AttemptedContactMethodCode = '40';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record with one having incorrect Contact Outcome Code
        CustomerContactOutcome2.AttemptedContactMethodCode = '12'; //21to12
        CustomerContactOutcome2.ContactOutcomeCode = '55';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record with one having incorrect Fulfillment Code
        CustomerContactOutcome2.ContactOutcomeCode = '1';
        CustomerContactOutcome2.FulfilmentCode = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateCreateEONCustomerContactOutcome_Exception(): This method will cover exception- FAIL
    **/
    static testmethod void validateCreateEONCustomerContactOutcome_Exception(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContactOutcome CustomerContactOutcome = new EON_Voice_Update_Customer_WS.EONCustomerContactOutcome();
        CustomerContactOutcome.ReferenceID = '001';
        CustomerContactOutcome.AttemptedContactMethodCode = '4';
        CustomerContactOutcome.ContactOutcomeCode = '1';
        CustomerContactOutcome.FulfilmentCode = 'Test';
        CustomerContactOutcome.DateOfContact = system.Date.today();
        CustomerContactOutcome.ContactOutcome_SFID = 'test';
        list<EON_Voice_Update_Customer_WS.EONCustomerContactOutcome> allCustomerContactOutcome = new list<EON_Voice_Update_Customer_WS.EONCustomerContactOutcome>();
        allCustomerContactOutcome.add(CustomerContactOutcome);
        
        EON_Voice_Update_Customer_WS.EONCustomerContactOutcomes request = new EON_Voice_Update_Customer_WS.EONCustomerContactOutcomes();
        request.Customer_SFID = customer.ID;
        request.EONCustomerContactOutcome = allCustomerContactOutcome;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        EON_Utility.genException = true;
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        createEONCustomerContactOutcome(): This method will cover success scenario while updating EON Customer Contact Outcome - PASS
    **/
    static testmethod void createEONCustomerContactOutcome(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContactOutcome CustomerContactOutcome = new EON_Voice_Update_Customer_WS.EONCustomerContactOutcome();
        CustomerContactOutcome.ReferenceID = '001';
        CustomerContactOutcome.AttemptedContactMethodCode = '4';
        CustomerContactOutcome.ContactOutcomeCode = '1';
        CustomerContactOutcome.FulfilmentCode = 'Test';
        CustomerContactOutcome.DateOfContact = system.Date.today();
        CustomerContactOutcome.ContactOutcome_SFID = 'test';
        list<EON_Voice_Update_Customer_WS.EONCustomerContactOutcome> allCustomerContactOutcome = new list<EON_Voice_Update_Customer_WS.EONCustomerContactOutcome>();
        allCustomerContactOutcome.add(CustomerContactOutcome);
        
        EON_Voice_Update_Customer_WS.EONCustomerContactOutcomes request = new EON_Voice_Update_Customer_WS.EONCustomerContactOutcomes();
        request.Customer_SFID = customer.ID;
        request.EONCustomerContactOutcome = allCustomerContactOutcome;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Success Scenario
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        //Success Scenario
        CustomerContactOutcome.ContactOutcomeCode = '2';
        CustomerContactOutcome.ContactOutcomeDescription = 'test';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        //Covers exception 
        CustomerContactOutcome.ContactOutcomeCode = '2';
        CustomerContactOutcome.ContactOutcomeDescription = 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest';
        response = EON_Voice_Update_Customer_WS.CreateEONContactOutcome(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    
    /**
        validateCreateEONContactRepresentative(): This method will validate request to create EON Contact Representative - FAIL
                                                  This will create EON Contact Representative - PASS
    **/
    static testmethod void validateCreateEONContactRepresentative(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative = new EON_Voice_Update_Customer_WS.EONContactRepresentative();
        list<EON_Voice_Update_Customer_WS.EONContactRepresentative> allContactRepresentative = new list<EON_Voice_Update_Customer_WS.EONContactRepresentative>();
        allContactRepresentative.add(contactRepresentative);
        EON_Voice_Update_Customer_WS.EONContactRepresentatives request = new EON_Voice_Update_Customer_WS.EONContactRepresentatives();
        request.EONContactRepresentative = allContactRepresentative;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Blank ReferenceID
        contactRepresentative.ReferenceID = '';
        response = EON_Voice_Update_Customer_WS.CreateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Customer Salesforce ID - Covers exception
        contactRepresentative.ReferenceID = '001';
        request.Customer_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid EON Customer
        request.Customer_SFID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Role Type
        request.Customer_SFID = customer.ID;
        contactRepresentative.RoleType = '22';
        response = EON_Voice_Update_Customer_WS.CreateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record - with duplicate ReferenceID
        contactRepresentative.RoleType = '123';
        contactRepresentative.ContactName = 'Test';
        contactRepresentative.RepresentativeID = '1112233';
        EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepNew = new EON_Voice_Update_Customer_WS.EONContactRepresentative();
        contactRepNew.ReferenceID = '001';
        allContactRepresentative.add(contactRepNew);
        response = EON_Voice_Update_Customer_WS.CreateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record - with one incorrect Role Type
        contactRepNew.ReferenceID = '002';
        contactRepNew.RoleType = '12';
        response = EON_Voice_Update_Customer_WS.CreateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record - Success scenario
        contactRepNew.RoleType = '123';
        contactRepNew.ContactName = 'Test';
        contactRepNew.RepresentativeID = '223344';
        response = EON_Voice_Update_Customer_WS.CreateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        //Multiple Record - Failure scenario - Exception while updating
        contactRepNew.ContactName = 'TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest';
        response = EON_Voice_Update_Customer_WS.CreateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest(); 
    }
    /**
        validateCreateEONContactRepresentative_Exception(): This method will cover exception - Failure  
    **/
    static testmethod void validateCreateEONContactRepresentative_Exception(){
        EON_Utility.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative = new EON_Voice_Update_Customer_WS.EONContactRepresentative();
        list<EON_Voice_Update_Customer_WS.EONContactRepresentative> allContactRepresentative = new list<EON_Voice_Update_Customer_WS.EONContactRepresentative>();
        allContactRepresentative.add(contactRepresentative);
        EON_Voice_Update_Customer_WS.EONContactRepresentatives request = new EON_Voice_Update_Customer_WS.EONContactRepresentatives();
        request.EONContactRepresentative = allContactRepresentative;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        contactRepresentative.ReferenceID = '001';
        contactRepresentative.ContactName = '2345';
        contactRepresentative.RepresentativeID = '12344';
        request.Customer_SFID = customer.ID;
        contactRepresentative.RoleType = '123';
        response = EON_Voice_Update_Customer_WS.CreateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateDeleteEONContactRepresentative(): This method will validate request to delete EON Contact Representative  - Failure  
    **/
    static testmethod void validateDeleteEONContactRepresentative(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_representative__c contactRep = [Select ID from EON_Contact_representative__c where Customer__c =: customer.ID and Eon_Contact_Representative_Change_Type__c !='D' limit 1];
        EON_Contact_representative__c contactRepD = [Select ID from EON_Contact_representative__c where Eon_Contact_Representative_Change_Type__c ='D' limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = 'incorrect';
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Incorrect Salesforce ID - Covers exception
        response = EON_Voice_Update_Customer_WS.DeleteEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Salesforce ID
        contact.SalesforceID = customer.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record deletion with one having invalid Salesforce ID
        contact.SalesforceID = contactRep.ID;
        EON_Voice_Update_Customer_WS.EONCustomerContact contactD = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contactD.ReferenceID = '002';
        contactD.SalesforceID = customer.ID;
        allContact.add(contactD);
        response = EON_Voice_Update_Customer_WS.DeleteEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateDeleteEONContactRepresentative_Exception(): This method will covers exception  - Failure  
    **/
    static testmethod void validateDeleteEONContactRepresentative_Exception(){
        EON_Voice_Update_Customer_WS_Helper.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_representative__c contactRep = [Select ID from EON_Contact_representative__c where Customer__c =: customer.ID and Eon_Contact_Representative_Change_Type__c !='D' limit 1];
        
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = contactRep.ID;
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        response = EON_Voice_Update_Customer_WS.DeleteEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        deleteEONContactRepresentative(): This method will delete the record EON Contact Representative - Pass
    **/
    static testmethod void deleteEONContactRepresentative(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_representative__c contactRep = [Select ID from EON_Contact_representative__c where Customer__c =: customer.ID and Eon_Contact_Representative_Change_Type__c !='D' limit 1];
        
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = contactRep.ID;
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Generate Exception while update
        EON_Utility.genException = true;
        response = EON_Voice_Update_Customer_WS.DeleteEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success Scenario
        EON_Contact_representative__c repNew = [Select ID from EON_Contact_representative__c where Name='1223'];
        repNew.Eon_Contact_Representative_Change_Type__c = 'I';
        update repNew;
        contact.SalesforceID = repNew.ID;
        EON_Utility.genException = false;
        response = EON_Voice_Update_Customer_WS.DeleteEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    /**
        validateUpdateEONContactRepresentative(): This will validate update request for EON Contact Representative scenario - FAIL
    **/
    static testmethod void validateUpdateEONContactRepresentative(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        EON_Contact_representative__c contactRep = [Select ID from EON_Contact_representative__c where Customer__c =: customer.ID and Eon_Contact_Representative_Change_Type__c !='D' limit 1];
        EON_Contact_representative__c contactRepD = [Select ID from EON_Contact_representative__c where Eon_Contact_Representative_Change_Type__c ='D' limit 1];
        EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative = new EON_Voice_Update_Customer_WS.EONContactRepresentative();
        list<EON_Voice_Update_Customer_WS.EONContactRepresentative> allContactRepresentative = new list<EON_Voice_Update_Customer_WS.EONContactRepresentative>();
        allContactRepresentative.add(contactRepresentative);
        EON_Voice_Update_Customer_WS.EONContactRepresentatives request = new EON_Voice_Update_Customer_WS.EONContactRepresentatives();
        request.EONContactRepresentative = allContactRepresentative;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Incorrect Salesforce ID - covers exception
        contactRepresentative.ReferenceID = '001';
        request.Customer_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Salesforce ID
        request.Customer_SFID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //No EON Contact Rep ID exist
        request.Customer_SFID = customer.ID;
        contactRepresentative.ContactRepresentative_SFID = '';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid EON Contact Rep ID
        contactRepresentative.ContactRepresentative_SFID = contactRepD.ID;
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Role Type
        contactRepresentative.ContactRepresentative_SFID = contactRep.ID;
        contactRepresentative.RoleType = '110';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record update with one incorrect EON Contact Rep ID
        contactRepresentative.RoleType = '123';
        EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentativeNew = new EON_Voice_Update_Customer_WS.EONContactRepresentative();
        contactRepresentativeNew.ReferenceID = '002';
        contactRepresentativeNew.ContactRepresentative_SFID = contactRepD.ID;
        allContactRepresentative.add(contactRepresentativeNew);
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record update with one incorrect Role Type
        contactRepresentativeNew.ContactRepresentative_SFID = contactRep.ID;
        contactRepresentativeNew.RoleType = '111';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateUpdateEONContactRepresentative_Exception(): This method will cover exception - Fail
    **/
    static testmethod void validateUpdateEONContactRepresentative_Exception(){
        EON_Utility.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_representative__c contactRep = [Select ID from EON_Contact_representative__c where Customer__c =: customer.ID and Eon_Contact_Representative_Change_Type__c !='D' limit 1];
        
        EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative = new EON_Voice_Update_Customer_WS.EONContactRepresentative();
        list<EON_Voice_Update_Customer_WS.EONContactRepresentative> allContactRepresentative = new list<EON_Voice_Update_Customer_WS.EONContactRepresentative>();
        allContactRepresentative.add(contactRepresentative);
        
        EON_Voice_Update_Customer_WS.EONContactRepresentatives request = new EON_Voice_Update_Customer_WS.EONContactRepresentatives();
        request.Customer_SFID = customer.Id;
        request.EONContactRepresentative = allContactRepresentative;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        contactRepresentative.ReferenceID = '001';
        contactRepresentative.ContactRepresentative_SFID = contactRep.ID;
        contactRepresentative.ContactName = 'test';
        contactRepresentative.RepresentativeID = '66774455';
        contactRepresentative.RoleType = '123';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);   
        test.stopTest();
    }
    /**
        updateEONContactRepresentative(): This method will cover success scenario for update of EOn Contact Representative - PASS
    **/
    static testmethod void updateEONContactRepresentative(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_representative__c contactRep = [Select ID from EON_Contact_representative__c where Customer__c =: customer.ID and Eon_Contact_Representative_Change_Type__c !='D' limit 1];
        
        EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative = new EON_Voice_Update_Customer_WS.EONContactRepresentative();
        list<EON_Voice_Update_Customer_WS.EONContactRepresentative> allContactRepresentative = new list<EON_Voice_Update_Customer_WS.EONContactRepresentative>();
        allContactRepresentative.add(contactRepresentative);
        
        EON_Voice_Update_Customer_WS.EONContactRepresentatives request = new EON_Voice_Update_Customer_WS.EONContactRepresentatives();
        request.Customer_SFID = customer.Id;
        request.EONContactRepresentative = allContactRepresentative;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        contactRepresentative.ReferenceID = '001';
        contactRepresentative.ContactRepresentative_SFID = contactRep.ID;
        contactRepresentative.ContactName = 'test';
        contactRepresentative.RepresentativeID = '66774455';
        contactRepresentative.RoleType = '123';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);    
        //Cover exception while update
        contactRepresentative.RepresentativeID = 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactRepresentative(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);  
        test.stopTest();
    }
    
    /**
        validateCreateEONSiteVulnerability(): This method will cover creation of EON ELigibility Override with failure scenario - FAIL
    **/
    static testmethod void validateCreateEONSiteVulnerability(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        EON_Voice_Update_Customer_WS.EONSiteVulnerability SiteVulnerability = new EON_Voice_Update_Customer_WS.EONSiteVulnerability();
        list<EON_Voice_Update_Customer_WS.EONSiteVulnerability> allSiteVulnerability = new list<EON_Voice_Update_Customer_WS.EONSiteVulnerability>();
        allSiteVulnerability.add(SiteVulnerability);
        EON_Voice_Update_Customer_WS.EONSiteVulnerabilities request = new EON_Voice_Update_Customer_WS.EONSiteVulnerabilities();
        request.EONSiteVulnerability = allSiteVulnerability;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Blank ReferenceID
        SiteVulnerability.ReferenceID = '';
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Customer Salesforce ID - Covers exception
        SiteVulnerability.ReferenceID = '001';
        request.Customer_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid EOn Customer
        request.Customer_SFID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //No Vulnerability Code exist
        request.Customer_SFID = customer.ID;
        SiteVulnerability.VulnerabilityCode = '00';
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //No EON Site exist
        request.Customer_SFID = customer.ID;
        SiteVulnerability.VulnerabilityCode = '';
        SiteVulnerability.PremiseID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record update with duplicate ReferenceID
        SiteVulnerability.VulnerabilityCode = '98';
        SiteVulnerability.PremiseID = '0987654321';
        EON_Voice_Update_Customer_WS.EONSiteVulnerability SiteVulnerabilityNew = new EON_Voice_Update_Customer_WS.EONSiteVulnerability();
        SiteVulnerabilityNew.ReferenceID = '001';
        allSiteVulnerability.add(SiteVulnerabilityNew);
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record update - One record has in correct Vulnerability Code
        SiteVulnerabilityNew.ReferenceID = '002';
        SiteVulnerabilityNew.VulnerabilityCode = '00';
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record update - One record has in correct Premise ID
        SiteVulnerabilityNew.VulnerabilityCode = '98';
        SiteVulnerabilityNew.PremiseID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //CH08.New
        //Multiple record update - With multiple records with Address Type = S
        EON_Site__c sID = [Select Name, Address_type__c from EON_Site__c where Name='0987654325'];
        sID.Name = '0987654323';
        update sID;
        SiteVulnerability.PremiseID = '0987654323';
        SiteVulnerabilityNew.PremiseID = '0987654325';
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Delete operation with incorrect Site Vulnerability ID
        EON_Site_Vulnerability__c deleteSiteVul = [Select ID from EON_Site_Vulnerability__c where customer__c =:customerD.ID];
        EON_Site_Vulnerability__c siteVul = [Select ID from EON_Site_Vulnerability__c where customer__c =:customer.ID];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        contact.ReferenceID = '001';
        contact.SalesforceID = 'Incorrect';
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts deleteRequest = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        deleteRequest.EONCustomerContact = allContact;
        response = EON_Voice_Update_Customer_WS.DeleteEONSiteVulnerability(deleteRequest);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Site Vulnerability ID
        contact.SalesforceID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONSiteVulnerability(deleteRequest);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        contact.SalesforceID = deleteSiteVul.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONSiteVulnerability(deleteRequest);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Mutiple Delete operation - with one does not exist
        contact.SalesforceID = siteVul.ID;
        EON_Voice_Update_Customer_WS.EONCustomerContact contactNew = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contactNew.ReferenceID = '002';
        contactNew.SalesforceID = deleteSiteVul.ID;
        allContact.add(contactNew);
        response = EON_Voice_Update_Customer_WS.DeleteEONSiteVulnerability(deleteRequest);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateCreateEONSiteVulnerability_exception(): This method will cover exception - FAIL
    **/
    static testmethod void validateCreateEONSiteVulnerability_exception(){
        EON_Utility.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONSiteVulnerability SiteVulnerability = new EON_Voice_Update_Customer_WS.EONSiteVulnerability();
        list<EON_Voice_Update_Customer_WS.EONSiteVulnerability> allSiteVulnerability = new list<EON_Voice_Update_Customer_WS.EONSiteVulnerability>();
        allSiteVulnerability.add(SiteVulnerability);
        EON_Voice_Update_Customer_WS.EONSiteVulnerabilities request = new EON_Voice_Update_Customer_WS.EONSiteVulnerabilities();
        request.EONSiteVulnerability = allSiteVulnerability;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        request.Customer_SFID = customer.ID;
        SiteVulnerability.ReferenceID = '001';
        SiteVulnerability.VulnerabilityCode = '98';
        SiteVulnerability.Premise_SFID = 'test';
        SiteVulnerability.VulnerabilityTypeID = 'C';
        SiteVulnerability.PremiseID = '0987654323';
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateDeleteEONSiteVulnerability_exception(): This method will cover exception - FAIL
    **/
    static testmethod void validateDeleteEONSiteVulnerability_exception(){
        EON_Voice_Update_Customer_WS_Helper.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Site_Vulnerability__c siteVul = [Select ID, EON_Site_Vulnerability_Change_Type__c from EON_Site_Vulnerability__c where customer__c =:customer.ID limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        contact.ReferenceID = '001';
        contact.SalesforceID = siteVul.ID;
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts deleteRequest = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        deleteRequest.EONCustomerContact = allContact;
        
        test.startTest();
        response = EON_Voice_Update_Customer_WS.DeleteEONSiteVulnerability(deleteRequest);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        createDeleteEONSiteVulnerability(): This function will verify success scenario for 
        a. CreateEONSiteVulnerability
        b. DeleteEONSiteVulnerability
    **/
    static testmethod void createDeleteEONSiteVulnerability(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONSiteVulnerability SiteVulnerability = new EON_Voice_Update_Customer_WS.EONSiteVulnerability();
        list<EON_Voice_Update_Customer_WS.EONSiteVulnerability> allSiteVulnerability = new list<EON_Voice_Update_Customer_WS.EONSiteVulnerability>();
        allSiteVulnerability.add(SiteVulnerability);
        EON_Voice_Update_Customer_WS.EONSiteVulnerabilities request = new EON_Voice_Update_Customer_WS.EONSiteVulnerabilities();
        request.EONSiteVulnerability = allSiteVulnerability;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Verify Create
        request.Customer_SFID = customer.ID;
        SiteVulnerability.ReferenceID = '001';
        SiteVulnerability.PremiseID = '0987654321';
        SiteVulnerability.VulnerabilityCode = '98';
        SiteVulnerability.Premise_SFID = 'test';
        SiteVulnerability.VulnerabilityTypeID = 'C';
        //Cover exception
        EON_Utility.genException = true;
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        EON_Voice_Update_Customer_WS.Messages msg = response.Messages;
        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
        allMsg.addAll(msg.Message);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success Scenario
        EON_Utility.genException = false;
        SiteVulnerability.PremiseID = '0987654323';
        response = EON_Voice_Update_Customer_WS.CreateEONSiteVulnerability(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        //Verify Deletion
        EON_Site_Vulnerability__c siteVul = [Select ID, EON_Site_Vulnerability_Change_Type__c from EON_Site_Vulnerability__c where customer__c =:customer.ID limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        contact.ReferenceID = '001';
        contact.SalesforceID = siteVul.ID;
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts deleteRequest = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        deleteRequest.EONCustomerContact = allContact;
        //Covers exception
        EON_Utility.genException = true;
        response = EON_Voice_Update_Customer_WS.DeleteEONSiteVulnerability(deleteRequest);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success Scenario
        EON_Utility.genException = null;
        siteVul.EON_Site_Vulnerability_Change_Type__c = 'I';
        update siteVul;
        response = EON_Voice_Update_Customer_WS.DeleteEONSiteVulnerability(deleteRequest);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    
    /**
        validateCreateOptInOptOutPreference(): This methoid will validate creation request for EOn Opt In Opt Out Preference
    **/
    static testmethod void validateCreateOptInOptOutPreference(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        EON_Site__c eSiteS = [Select ID from EON_Site__c where name='0987654322'];
        EON_Voice_Update_Customer_WS.EONOptInOptOutPreference optInOptOutPreference = new EON_Voice_Update_Customer_WS.EONOptInOptOutPreference();
        list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference> allOptInOptOutPreference = new list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference>();
        allOptInOptOutPreference.add(optInOptOutPreference);
        EON_Voice_Update_Customer_WS.EONOptInOptOutPreferences request = new EON_Voice_Update_Customer_WS.EONOptInOptOutPreferences();
        request.EONOptInOptOutPreference = allOptInOptOutPreference;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Blank ReferenceID
        optInOptOutPreference.ReferenceID = '';
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Customer Salesforce ID - Covers exception
        optInOptOutPreference.ReferenceID = '001';
        request.Customer_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Customer ID
        request.Customer_SFID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid PremiseID does not exist
        request.Customer_SFID = customer.ID;
        optInOptOutPreference.PremiseID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Opt Out Reason Code
        optInOptOutPreference.PremiseID = '0987654323';
        optInOptOutPreference.OptOutReasonCode = '01';
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid OptInOptOutPreference
        optInOptOutPreference.OptOutReasonCode = '10';
        optInOptOutPreference.OptInOptOutPreference = 'C';
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record creation with duplicate ReferenceID
        optInOptOutPreference.OptInOptOutPreference = 'Y';
        EON_Voice_Update_Customer_WS.EONOptInOptOutPreference optInOptOutPreferenceNew = new EON_Voice_Update_Customer_WS.EONOptInOptOutPreference();
        optInOptOutPreferenceNew.ReferenceID = '001';
        allOptInOptOutPreference.add(optInOptOutPreferenceNew);
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record creation with one record with incorrect PremiseID
        optInOptOutPreferenceNew.ReferenceID = '002';
        optInOptOutPreferenceNew.PremiseID = '0987654322';
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record creation with one record with incorrect Opt Out Reason Code
        optInOptOutPreferenceNew.PremiseID = '0987654323';
        optInOptOutPreferenceNew.OptOutReasonCode = '01';
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Record creation with one reocrd having more than six Opt In Opt Out Preference
        optInOptOutPreferenceNew.OptOutReasonCode = '10';
        optInOptOutPreferenceNew.PremiseID = '0987654325';
        optInOptOutPreference.PremiseID = '0987654323';
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateCreateOptInOptOutPreference_Exception(): This methoid will cover exception
    **/
    static testmethod void validateCreateOptInOptOutPreference_Exception(){
        EON_Voice_Update_Customer_WS_Helper.genException = true;
        EON_Error_Code__c success = EON_CreateTestRecords.createEONErrorCode();
        success.name='000';
        success.Error_Name__c = 'Success';
        success.Description__c = 'Success';
        insert success;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONOptInOptOutPreference optInOptOutPreference = new EON_Voice_Update_Customer_WS.EONOptInOptOutPreference();
        optInOptOutPreference.ReferenceID = '001';
        optInOptOutPreference.PremiseID = '0987654323';
        optInOptOutPreference.OptOutReasonCode = '10';
        optInOptOutPreference.OptInOptOutPreference = 'Y';
        list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference> allOptInOptOutPreference = new list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference>();
        allOptInOptOutPreference.add(optInOptOutPreference);
        
        EON_Voice_Update_Customer_WS.EONOptInOptOutPreferences request = new EON_Voice_Update_Customer_WS.EONOptInOptOutPreferences();
        request.EONOptInOptOutPreference = allOptInOptOutPreference;
        request.Customer_SFID = customer.ID;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateDeleteOptInOptOutPreference(): This methoid will validate delete request for EOn Opt In Opt Out Preference
    **/
    static testmethod void validateDeleteOptInOptOutPreference(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Site__c eSite = [Select ID from EON_Site__c where name='0987654321' limit 1];
        EON_Site__c eSiteNew = [Select ID from EON_Site__c where name='0987654323' limit 1];
        EON_Opt_in_Opt_Out_Preference__c eOptInOptOutPrefNew = [Select ID from EON_Opt_in_Opt_Out_Preference__c where Premise__c=:eSiteNew.ID limit 1];
        EON_Opt_in_Opt_Out_Preference__c eOptInOptOutPref = [Select ID from EON_Opt_in_Opt_Out_Preference__c where Premise__c =:eSite.ID limit 1];
        eOptInOptOutPref.EON_Opt_In_Opt_Out_Pref_Change_Type__c = 'D';
        update eOptInOptOutPref;
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = 'incorrect';
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Incorrect Salesforce ID - Covers exception
        response = EON_Voice_Update_Customer_WS.DeleteEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Salesforce ID
        contact.SalesforceID = eOptInOptOutPref.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple deletion with one incorrect record
        EON_Voice_Update_Customer_WS.EONCustomerContact contactNew = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contactNew.ReferenceID = '002';
        contactNew.SalesforceID = eOptInOptOutPrefNew.ID;
        allContact.add(contactNew);
        response = EON_Voice_Update_Customer_WS.DeleteEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        
        test.stopTest();
    }
    /**
        validateDeleteOptInOptOutPreference_Exception(): This methoid will covers exception
    **/
    static testmethod void validateDeleteOptInOptOutPreference_Exception(){
        EON_Voice_Update_Customer_WS_Helper.genException = true;
        EON_Site__c eSite = [Select ID from EON_Site__c where name='0987654321' limit 1];
        EON_Opt_in_Opt_Out_Preference__c eOptInOptOutPref = [Select ID from EON_Opt_in_Opt_Out_Preference__c where Premise__c =:eSite.ID limit 1];
        
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = eOptInOptOutPref.ID;
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        response = EON_Voice_Update_Customer_WS.DeleteEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        createEONOptInOptOutPreference(): This function will cover creation of EON Opt In Opt Out Preference record success scenarion - PASS
    **/
    static testmethod void createEONOptInOptOutPreference(){
        EON_Error_Code__c success = EON_CreateTestRecords.createEONErrorCode();
        success.name='000';
        success.Error_Name__c = 'Success';
        success.Description__c = 'Success';
        insert success;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONOptInOptOutPreference optInOptOutPreference = new EON_Voice_Update_Customer_WS.EONOptInOptOutPreference();
        optInOptOutPreference.ReferenceID = '001';
        optInOptOutPreference.PremiseID = '0987654323';
        optInOptOutPreference.OptOutReasonCode = '10';
        optInOptOutPreference.OptInOptOutPreference = 'Y';
        list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference> allOptInOptOutPreference = new list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference>();
        allOptInOptOutPreference.add(optInOptOutPreference);
        
        EON_Voice_Update_Customer_WS.EONOptInOptOutPreferences request = new EON_Voice_Update_Customer_WS.EONOptInOptOutPreferences();
        request.EONOptInOptOutPreference = allOptInOptOutPreference;
        request.Customer_SFID = customer.ID;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Covers exception
        EON_Utility.genException = true;
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success Scenario
        EON_Utility.genException = false;
        optInOptOutPreference.OptInOptOutPreference = 'N';
        response = EON_Voice_Update_Customer_WS.CreateEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    /**
        deleteEONOptInOptOutPreference(): This function will cover deletion of EON Opt In Opt Out Preference record success scenarion - PASS
    **/
    static testmethod void deleteEONOptInOptOutPreference(){
        EON_Site__c eSite = [Select ID from EON_Site__c where name='0987654321' limit 1];
        EON_Opt_in_Opt_Out_Preference__c eOptInOptOutPref = [Select ID from EON_Opt_in_Opt_Out_Preference__c where Premise__c =:eSite.ID limit 1];
        
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = eOptInOptOutPref.ID;
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Covers exception
        EON_Utility.genException = true;
        response = EON_Voice_Update_Customer_WS.DeleteEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success Scenario
        EON_Utility.genException = false;
        eOptInOptOutPref.EON_Opt_In_Opt_Out_Pref_Change_Type__c = 'I';
        update eOptInOptOutPref;
        response = EON_Voice_Update_Customer_WS.DeleteEONOptInOptOutPreference(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    
    /**
        validateCreateEONContactMedia(): This method will validate request to create EON Contact Media with scenario - FAIL/PASS    
        Cover method CreateEONContactMedium() for PASS and FAIL
    **/
    static testmethod void validateCreateEONContactMedia(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        EON_Contact_representative__c rep = [Select ID from EON_Contact_representative__c where customer__c =: customer.ID];
        EON_Voice_Update_Customer_WS.EONContactMedium cMedium = new EON_Voice_Update_Customer_WS.EONContactMedium();
        list<EON_Voice_Update_Customer_WS.EONContactMedium> allContactMedium = new list<EON_Voice_Update_Customer_WS.EONContactMedium>();
        allContactMedium.add(cMedium);
        EON_Voice_Update_Customer_WS.EONContactMedia request = new EON_Voice_Update_Customer_WS.EONContactMedia();
        request.EONContactMedium = allContactMedium;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Incorrect ReferenceID
        cMedium.ReferenceID = '';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Customer - covers exception
        cMedium.ReferenceID = '001';
        request.Customer_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid customer
        request.Customer_SFID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect InPreferredContactMethod
        request.Customer_SFID = customer.ID;
        cMedium.IsPreferredContactMethod = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect PhoneCode
        cMedium.IsPreferredContactMethod = 'y';
        cMedium.PhoneCode = 'incorerct';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect PhoneNumber
        cMedium.PhoneCode = '22';
        cMedium.PhoneNumber = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Contact Method Type
        cMedium.PhoneNumber = '556633';
        cMedium.ContactMethodType = '88';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Contact Rep
        cMedium.ContactMethodType = '4';
        cMedium.Representative_SFID = customer.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record creation - one with no ReferenceID
        cMedium.Representative_SFID = rep.ID;
        EON_Voice_Update_Customer_WS.EONContactMedium cMediumNew = new EON_Voice_Update_Customer_WS.EONContactMedium();
        allContactMedium.add(cMediumNew);
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record creation - one with incorrect Contact Method Type
        cMediumNew.ReferenceID = '002';
        cMediumNew.ContactMethodType = '88';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record creation - one with incorrect Contact Rep
        cMediumNew.ContactMethodType = '12'; //21to12
        cMediumNew.Representative_SFID = customer.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record creation with error while creation - covers exception
        cMediumNew.Representative_SFID = rep.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Valid request with incorrect email format - covers exception
        cMedium.ContactMediaID = '1234544';
        cMediumNew.ContactMediaID = '566333';
        cMedium.Email = 'incorrect';
        cMedium.PhoneExtension = '1122';
        cMedium.Representative = 'test';
        cMediumNew.Email = 'a@b.com';
        cMediumNew.PhoneExtension = '1122';
        cMediumNew.Representative = 'test';
        cMediumNew.PhoneCode = '33';
        cMediumNew.PhoneNumber = '6633';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success scenario
        cMedium.Email = 'a@b.com';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    /**
        validateCreateEONContactMedia_Exception(): This method will cover exception  - Failure  
    **/
    static testmethod void validateCreateEONContactMedia_Exception(){
        EON_Utility.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_representative__c rep = [Select ID from EON_Contact_representative__c where customer__c =: customer.ID];
        EON_Voice_Update_Customer_WS.EONContactMedium cMedium = new EON_Voice_Update_Customer_WS.EONContactMedium();
        list<EON_Voice_Update_Customer_WS.EONContactMedium> allContactMedium = new list<EON_Voice_Update_Customer_WS.EONContactMedium>();
        allContactMedium.add(cMedium);
        EON_Voice_Update_Customer_WS.EONContactMedia request = new EON_Voice_Update_Customer_WS.EONContactMedia();
        request.EONContactMedium = allContactMedium;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        cMedium.ReferenceID = '001';
        request.Customer_SFID = customer.ID;
        cMedium.IsPreferredContactMethod = 'y';
        cMedium.PhoneCode = '22';
        cMedium.PhoneNumber = '556633';
        cMedium.ContactMethodType = '4';
        cMedium.Representative_SFID = rep.ID;
        cMedium.Email = 'a@a.com';
        cMedium.ContactMediaID = '122334';
        response = EON_Voice_Update_Customer_WS.CreateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateUpdateEONContactMedia(): This method will validate request to update EON Contact Media with scenario - FAIL/PASS
        UpdateEONContactMedium() - This method covered for all pass and failure scenario
    **/
    static testmethod void validateUpdateEONContactMedia(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        EON_Contact_Media__c conMedia = [Select ID from EON_Contact_Media__c where name='1234'];
        EON_Contact_Media__c conMediaNew = [Select ID from EON_Contact_Media__c where name='2345'];
        
        EON_Voice_Update_Customer_WS.EONContactMedium cMedium = new EON_Voice_Update_Customer_WS.EONContactMedium();
        list<EON_Voice_Update_Customer_WS.EONContactMedium> allContactMedium = new list<EON_Voice_Update_Customer_WS.EONContactMedium>();
        allContactMedium.add(cMedium);
        EON_Voice_Update_Customer_WS.EONContactMedia request = new EON_Voice_Update_Customer_WS.EONContactMedia();
        request.EONContactMedium = allContactMedium;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Incorrect Customer ID - covers exception
        cMedium.ReferenceID = '001';
        request.Customer_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Customer ID
        request.Customer_SFID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Blank Contact Media ID
        request.Customer_SFID = customer.ID;
        cMedium.ContactMedia_SFID = '';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Contact Media ID
        cMedium.ContactMedia_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Contact Media ID
        cMedium.ContactMedia_SFID = customer.ID;
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect InPreferredContactMethod
        cMedium.ContactMedia_SFID = conMedia.ID;
        cMedium.IsPreferredContactMethod = 'incorrect'; 
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect PhoneCode
        cMedium.IsPreferredContactMethod = 'y';
        cMedium.PhoneCode = 'incorerct';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect PhoneNumber
        cMedium.PhoneCode = '22';
        cMedium.PhoneNumber = 'incorrect';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Contact Method Type
        cMedium.PhoneNumber = '556633';
        cMedium.ContactMethodType = '88';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple update - one with incorrect Contact Media ID
        cMedium.ContactMethodType = '4';
        cMedium.Email = 'a@a.com';
        EON_Voice_Update_Customer_WS.EONContactMedium cMediumNew = new EON_Voice_Update_Customer_WS.EONContactMedium();
        cMediumNew.ReferenceID = '002';
        cMediumNew.ContactMedia_SFID = customer.ID;
        allContactMedium.add(cMediumNew);
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple update - one with incorrect Contact Method Type
        cMediumNew.ContactMedia_SFID = conMediaNew.ID;
        cMediumNew.ContactMethodType = '88';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect email format - covers exception
        cMedium.Email = 'incorrect';
        cMediumNew.ContactMethodType = '12';
        cMediumNew.PhoneCode = '22';
        cMediumNew.PhoneExtension = '1213';
        cMediumNew.PhoneNumber = '44556';
        cMediumNew.ContactMediaID = '5566';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success scenario
        cMedium.Email = 'a@a.com';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    /**
        validateUpdateEONContactMedia_Exception(): This method will cover exception  - Fail
    **/
    static testmethod void validateUpdateEONContactMedia_Exception(){
        EON_Utility.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_Media__c conMedia = [Select ID from EON_Contact_Media__c where name='1234'];
        EON_Contact_representative__c rep = [Select ID from EON_Contact_representative__c where customer__c =: customer.ID];
        EON_Voice_Update_Customer_WS.EONContactMedium cMedium = new EON_Voice_Update_Customer_WS.EONContactMedium();
        list<EON_Voice_Update_Customer_WS.EONContactMedium> allContactMedium = new list<EON_Voice_Update_Customer_WS.EONContactMedium>();
        allContactMedium.add(cMedium);
        EON_Voice_Update_Customer_WS.EONContactMedia request = new EON_Voice_Update_Customer_WS.EONContactMedia();
        request.EONContactMedium = allContactMedium;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        cMedium.ReferenceID = '001';
        cMedium.ContactMedia_SFID = conMedia.ID;
        request.Customer_SFID = customer.ID;
        cMedium.IsPreferredContactMethod = 'y';
        cMedium.PhoneCode = '22';
        cMedium.PhoneNumber = '556633';
        cMedium.ContactMethodType = '4';
        cMedium.Representative_SFID = rep.ID;
        cMedium.Email = 'a@a.com';
        cMedium.ContactMediaID = '122334';
        response = EON_Voice_Update_Customer_WS.UpdateEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateDeleteEONContactMedia(): This method will validate request to delete EON Contact Media with scenario - FAIL/PASS
        DeleteEONContactMedium() - This method covered for all pass and failure scenario
    **/
    static testmethod void validateDeleteEONContactMedia(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_Media__c conMedia = [Select ID from EON_Contact_Media__c where name='1234'];
        EON_Contact_Media__c conMediaNew = [Select ID from EON_Contact_Media__c where name='2345'];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();

        test.startTest();
        //Incorrect SalesforceID - covers exception
        contact.SalesforceID = 'Invalid';
        response = EON_Voice_Update_Customer_WS.DeleteEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid SalesforceID
        contact.SalesforceID = customer.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple deletion - one with incorrect Salesforce ID
        contact.SalesforceID = conMedia.ID;
        EON_Voice_Update_Customer_WS.EONCustomerContact contactNew = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contactNew.ReferenceID = '002';
        contactNew.SalesforceID = customer.ID;
        allContact.add(contactNew);
        response = EON_Voice_Update_Customer_WS.DeleteEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //DML Exception while update
        EON_Utility.genException = true;
        contactNew.SalesforceID = conMediaNew.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success scenario 
        EON_Utility.genException = false;
        contactNew.SalesforceID = conMediaNew.ID;
        conMediaNew.EON_Contact_media_Change_Type__c = 'I';
        update conMediaNew;
        conMedia.EON_Contact_media_Change_Type__c = 'I';
        update conMedia;
        response = EON_Voice_Update_Customer_WS.DeleteEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    /**
        validateDeleteEONContactMedia_Exception(): This method will cover exception  - Fail
    **/
    static testmethod void validateDeleteEONContactMedia_Exception(){
        EON_Voice_Update_Customer_WS_Helper.genException = true;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_Media__c conMedia = [Select ID, EON_Contact_media_Change_Type__c from EON_Contact_Media__c where name='1234'];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = conMedia.ID;
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        conMedia.EON_Contact_media_Change_Type__c = 'I';
        update conMedia;
        
        test.startTest();
        response = EON_Voice_Update_Customer_WS.DeleteEONContactMedium(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateCretaeEONServiceContactConsent(): This will validate to create EON Service Contact Consent records with Scenario - FAIL and PASS
        CreateEONServiceContactConsent()
    **/
    static testmethod void validateCreateEONServiceContactConsent(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerNew = [Select ID from EON_Customer__c where name='7777777777' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        
        EON_Voice_Update_Customer_WS.EONServiceContactConsent serviceContactConsent = new EON_Voice_Update_Customer_WS.EONServiceContactConsent();
        list<EON_Voice_Update_Customer_WS.EONServiceContactConsent> allServiceContactConsent = new list<EON_Voice_Update_Customer_WS.EONServiceContactConsent>();
        allServiceContactConsent.add(serviceContactConsent);
        EON_Voice_Update_Customer_WS.EONServiceContactConsents request = new EON_Voice_Update_Customer_WS.EONServiceContactConsents();
        request.EONServiceContactConsent = allServiceContactConsent;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Blank ReferenceID
        serviceContactConsent.ReferenceID = '';
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect customer ID - covers exception
        serviceContactConsent.ReferenceID = '001';
        request.Customer_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid customer ID
        request.Customer_SFID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Phone Code
        request.Customer_SFID = customer.ID;
        serviceContactConsent.PhoneCode = 'test';
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Phone Number
        serviceContactConsent.PhoneCode = '44';
        serviceContactConsent.PhoneNumber = 'test';
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Contact Method Type  
        request.Customer_SFID = customer.ID;
        serviceContactConsent.PhoneNumber = '1122';
        serviceContactConsent.ContactMethodType = '02';
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Contact Media ID 
        serviceContactConsent.ContactMethodType = '4';
        serviceContactConsent.ContactMediaID_SFID = customer.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record insert with one having no ReferenceID
        EON_Contact_Media__c conMedia = [Select ID from EON_Contact_Media__c where Name='1234' limit 1];
        serviceContactConsent.ContactMediaID_SFID = conMedia.ID;
        EON_Voice_Update_Customer_WS.EONServiceContactConsent serviceContactConsentNew = new EON_Voice_Update_Customer_WS.EONServiceContactConsent();
        serviceContactConsentNew.ReferenceID = '';
        allServiceContactConsent.add(serviceContactConsentNew);
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        ///Multiple record insert - More than two Service Contact Consent for EON Customer
        serviceContactConsentNew.ReferenceID = '002';
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        ///Multiple record insert - One having incorrect Contact Method Type
        request.Customer_SFID = customerNew.ID;
        serviceContactConsentNew.ContactMethodType = '02';
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        ///Multiple record insert - One having incorrect Contact Media
        serviceContactConsentNew.ContactMethodType = '12'; //21to12
        serviceContactConsentNew.ContactMediaID_SFID = customer.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record insert - One having incorrect Contact Media
        EON_Contact_Media__c conMediaNew = [Select ID, EON_Contact_media_Change_Type__c from EON_Contact_Media__c where Name='2345' limit 1];
        conMediaNew.EON_Contact_media_Change_Type__c = 'D';
        update conMediaNew;
        serviceContactConsentNew.ContactMediaID_SFID = conMediaNew.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Cover Exception while creating record
        conMediaNew.EON_Contact_media_Change_Type__c = '';
        update conMediaNew;
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success Scenario
        serviceContactConsentNew.PhoneCode = '11';
        serviceContactConsentNew.PhoneNumber = '12344';
        serviceContactConsentNew.PhoneExtension = '1234';
        serviceContactConsent.Email = 'a@b.com';
        serviceContactConsent.PhoneCode = '';
        serviceContactConsent.PhoneNumber = '';
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    /**
        validateCreateEONServiceContactConsent_Exception(): This will cover exception
    **/
    static testmethod void validateCreateEONServiceContactConsent_Exception(){
        EON_Utility.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Contact_Media__c conMedia = [Select ID from EON_Contact_Media__c where Name='1234' limit 1];
        EON_Voice_Update_Customer_WS.EONServiceContactConsent serviceContactConsent = new EON_Voice_Update_Customer_WS.EONServiceContactConsent();
        list<EON_Voice_Update_Customer_WS.EONServiceContactConsent> allServiceContactConsent = new list<EON_Voice_Update_Customer_WS.EONServiceContactConsent>();
        allServiceContactConsent.add(serviceContactConsent);
        EON_Voice_Update_Customer_WS.EONServiceContactConsents request = new EON_Voice_Update_Customer_WS.EONServiceContactConsents();
        request.EONServiceContactConsent = allServiceContactConsent;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        request.Customer_SFID = customer.ID;
        serviceContactConsent.ContactMediaID_SFID = conMedia.ID;
        serviceContactConsent.ContactMethodType = '4';
        serviceContactConsent.ReferenceID = '001';
        serviceContactConsent.Email = 'a@b.com';
        serviceContactConsent.PhoneCode = '';
        serviceContactConsent.PhoneNumber = '';
        response = EON_Voice_Update_Customer_WS.CreateEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateDeleteEONServiceContactConsent(): This method will validate request to delete records at EON Service Contact Consent
    **/
    static testmethod void validateDeleteEONServiceContactConsent(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Service_Contact_Consent__c serviceContactConsent = [Select ID from EON_Service_Contact_Consent__c where Customer__c =: customer.ID limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = 'Invalid';
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Invalid Salesforce ID - Covers exception
        response = EON_Voice_Update_Customer_WS.DeleteEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Salesforce ID does not exist
        contact.SalesforceID = customer.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple Deletion - with one incorrect ID
        contact.SalesforceID = serviceContactConsent.ID;
        EON_Voice_Update_Customer_WS.EONCustomerContact contactNew = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contactNew.ReferenceID = '002';
        contactNew.SalesforceID = customer.ID;
        allContact.add(contactNew);
        response = EON_Voice_Update_Customer_WS.DeleteEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateDeleteEONServiceContactConsent_Exception(): This method will covers exception
    **/
    static testmethod void validateDeleteEONServiceContactConsent_Exception(){
        EON_Voice_Update_Customer_WS_Helper.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Service_Contact_Consent__c serviceContactConsent = [Select ID from EON_Service_Contact_Consent__c where Customer__c =: customer.ID limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = serviceContactConsent.ID;
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        response = EON_Voice_Update_Customer_WS.DeleteEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        deleteEONServiceContactConsent(): This will delete EON Service Contact Consent successfully - PASS
    **/
    static testmethod void deleteEONServiceContactConsent(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Service_Contact_Consent__c serviceContactConsent = [Select ID from EON_Service_Contact_Consent__c where Customer__c =: customer.ID limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = serviceContactConsent.ID;
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Covers exception
        EON_Utility.genException = true;
        response = EON_Voice_Update_Customer_WS.DeleteEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success Scenario
        EON_Utility.genException = false;
        serviceContactConsent.EON_Service_Contact_Consent_Change_Type__c = 'I';
        update serviceContactConsent;
        response = EON_Voice_Update_Customer_WS.DeleteEONServiceContactConsent(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    
    /**
        validateCreateEONEligibilityOverride(): This method will cover creation of EON ELigibility Override with failure scenario - FAIL
    **/
    static testmethod void validateCreateEONEligibilityOverride(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        EON_Voice_Update_Customer_WS.EONEligibilityOverride eOverride = new EON_Voice_Update_Customer_WS.EONEligibilityOverride();
        list<EON_Voice_Update_Customer_WS.EONEligibilityOverride> allOverride = new list<EON_Voice_Update_Customer_WS.EONEligibilityOverride>();
        allOverride.add(eOverride);
        EON_Voice_Update_Customer_WS.EONEligibilityOverrides request = new EON_Voice_Update_Customer_WS.EONEligibilityOverrides();
        request.EONEligibilityOverride = allOverride;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Blank ReferenceID
        eOverride.ReferenceID = '';
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Customer Salesforce ID - Covers exception
        eOverride.ReferenceID = '001';
        request.Customer_SFID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Invalid Customer Salesforce ID
        request.Customer_SFID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect EON Site
        request.Customer_SFID = customer.ID;
        eOverride.PremiseID = 'incorrect';
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Eligibility Code
        eOverride.PremiseID = '0987654323';
        eOverride.EligibilityCode = '87';
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Equipment Type - Cover exception
        eOverride.EligibilityCode = '98';
        eOverride.EquipmentType = 'k';
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record update with duplicate ReferenceID
        eOverride.EquipmentType = 'E';
        EON_Voice_Update_Customer_WS.EONEligibilityOverride eOverrideNew = new EON_Voice_Update_Customer_WS.EONEligibilityOverride();
        eOverride.ReferenceID = '001';
        allOverride.add(eOverrideNew);
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record update with non existing PremiseID
        eOverrideNew.ReferenceID = '002';
        eOverrideNew.PremiseID = '0987654388';
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record updates at EON Eligibility Override with one record having incorrect PremiseID
        eOverrideNew.PremiseID = '0987654300';
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record updates at EON Eligibility Override with one record having incorrect Eligibility Code
        eOverrideNew.PremiseID = '0987654325';
        eOverrideNew.EligibilityCode = '78';
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateCreateEONEligibilityOverride_Exception(): This method will cover exception - FAIL
    **/
    static testmethod void validateCreateEONEligibilityOverride_Exception(){
        EON_Utility.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONEligibilityOverride createEligibilityOverride = new EON_Voice_Update_Customer_WS.EONEligibilityOverride();
        createEligibilityOverride.ReferenceID = '001';
        createEligibilityOverride.Premise_SFID = 'test';
        createEligibilityOverride.PremiseID = '0987654323';
        createEligibilityOverride.EligibilityCode = '98';
        createEligibilityOverride.EquipmentType = 'E';
        list<EON_Voice_Update_Customer_WS.EONEligibilityOverride> allOverride = new list<EON_Voice_Update_Customer_WS.EONEligibilityOverride>();
        allOverride.add(createEligibilityOverride);
        EON_Voice_Update_Customer_WS.EONEligibilityOverrides request = new EON_Voice_Update_Customer_WS.EONEligibilityOverrides();
        request.EONEligibilityOverride = allOverride;
        request.Customer_SFID = customer.ID;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        EON_Voice_Update_Customer_WS.Messages msgs = response.Messages;
        list<EON_Voice_Update_Customer_WS.Message> allMsg = msgs.Message;
        EON_Voice_Update_Customer_WS.Message m = allMsg[0];
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        createEONEligibilityOverride(): This method will cover creation of EON ELigibility Override with success scenario - PASS
    **/
    static testmethod void createEONEligibilityOverride(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONEligibilityOverride createEligibilityOverride = new EON_Voice_Update_Customer_WS.EONEligibilityOverride();
        createEligibilityOverride.ReferenceID = '001';
        createEligibilityOverride.Premise_SFID = 'test';
        createEligibilityOverride.PremiseID = '0987654323';
        createEligibilityOverride.EligibilityCode = '98';
        createEligibilityOverride.EquipmentType = 'E';
        list<EON_Voice_Update_Customer_WS.EONEligibilityOverride> allOverride = new list<EON_Voice_Update_Customer_WS.EONEligibilityOverride>();
        allOverride.add(createEligibilityOverride);
        EON_Voice_Update_Customer_WS.EONEligibilityOverrides request = new EON_Voice_Update_Customer_WS.EONEligibilityOverrides();
        request.EONEligibilityOverride = allOverride;
        request.Customer_SFID = customer.ID;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        response = EON_Voice_Update_Customer_WS.CreateEONEligibilityOverride(request);
        EON_Voice_Update_Customer_WS.Messages msgs = response.Messages;
        list<EON_Voice_Update_Customer_WS.Message> allMsg = msgs.Message;
        EON_Voice_Update_Customer_WS.Message m = allMsg[0];
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    /**
        validateDeleteEONEligibilityOverride(): This method will cover deletion of EON ELigibility Override with success and failure scenario - PASS/FAIL
    **/
    static testmethod void validateDeleteEONEligibilityOverride(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        contact.SalesforceID = 'Invalid';
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Invalid Salesforce ID - Covers exception
        response = EON_Voice_Update_Customer_WS.DeleteEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Salesforce ID
        EON_Eligibility_Override__c eOverride = [Select ID, Eligibility_Change_Type__c from EON_Eligibility_Override__c where Eligibility_Change_Type__c='D' limit 1];
        contact.SalesforceID = eOverride.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record deletion with one invalid record ID
        EON_Eligibility_Override__c eOverrideU = [Select ID, Eligibility_Change_Type__c from EON_Eligibility_Override__c where Eligibility_Change_Type__c='U' limit 1];
        contact.SalesforceID = eOverrideU.ID;
        EON_Voice_Update_Customer_WS.EONCustomerContact contactNew = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contactNew.ReferenceID = '002';
        contactNew.SalesforceID = customer.ID;
        allContact.add(contactNew);    
        response = EON_Voice_Update_Customer_WS.DeleteEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record deletion with one incorrect record ID
        EON_Eligibility_Override__c eDelete = [Select ID, Eligibility_Change_Type__c from EON_Eligibility_Override__c where Eligibility_Change_Type__c = 'D' limit 1];
        contactNew.SalesforceID = eDelete.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Covers exception
        EON_Utility.genException = true;
        allContact.clear();
        allContact.add(contact);
        response = EON_Voice_Update_Customer_WS.DeleteEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Success Scenario
        EON_Utility.genException = false;
        eOverrideU.Eligibility_Change_Type__c = 'I';
        update eOverrideU;
        response = EON_Voice_Update_Customer_WS.DeleteEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
    /**
		validateDeleteEONEligibilityOverride_Exception(): This method will covers exception
    **/
    static testmethod void validateDeleteEONEligibilityOverride_Exception(){
        EON_Voice_Update_Customer_WS_Helper.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONCustomerContact contact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
        contact.ReferenceID = '001';
        
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> allContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        allContact.add(contact);
        EON_Voice_Update_Customer_WS.EONCustomerContacts request = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
        request.EONCustomerContact = allContact;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        EON_Eligibility_Override__c eOverrideU = [Select ID, Eligibility_Change_Type__c from EON_Eligibility_Override__c where Eligibility_Change_Type__c='U' limit 1];
        contact.SalesforceID = eOverrideU.ID;
        response = EON_Voice_Update_Customer_WS.DeleteEONEligibilityOverride(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        validateUpdateEONSite(): This method will cover update to EON Site with failure scenario - FAIL
    **/
    static testmethod void validateUpdateEONSite(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Customer__c customerD = [Select ID from EON_Customer__c where Eon_Customer_Change_Type__c = 'D' limit 1];
        EON_County__c county = [Select ID, County_ID__c from EON_County__c where County_ID__c=11 limit 1];
        EON_Country__c country = [Select ID, Country_ID__c from EON_Country__c where Country_ID__c=11 limit 1];
        
        EON_Site__c ste = [Select ID, Address_Type__c, Customer__c from EON_Site__c where Name='0987654321' limit 1];
        EON_Site__c steD = [Select ID, Customer__c from EON_Site__c where Name='0987654322' limit 1];
        
        EON_Voice_Update_Customer_WS.EONSite st = new EON_Voice_Update_Customer_WS.EONSite();
        list<EON_Voice_Update_Customer_WS.EONSite> allSite = new list<EON_Voice_Update_Customer_WS.EONSite>();
        allSite.add(st);
        EON_Voice_Update_Customer_WS.EONSites request = new EON_Voice_Update_Customer_WS.EONSites();
        request.Customer_SFID = 'incorrect';
        request.EONSite = allSite;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();
        //Blank requestID
        st.ReferenceID = '';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Customer ID - Cover exception
        st.ReferenceID = '001';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Incorrect Customer ID 
        request.Customer_SFID = customerD.ID;
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Site does not exist with customer
        request.Customer_SFID = customer.ID;
        st.PremiseID = '0987654322';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Site with type S
        st.PremiseID = '0987654323';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status); 
        //County does not exist
        st.PremiseID = '0987654321';
        st.CountyId = '9';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status); 
        //Country does not exist
        st.CountyId = '11';
        st.CountryId = '9';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status); 
        //Cover exception
        st.CountryId = '11';
        st.postcode = '123456781';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status); 
        //Multiple record update with duplicate ReferenceID
        EON_Voice_Update_Customer_WS.EONSite stNew = new EON_Voice_Update_Customer_WS.EONSite();
        stNew.PremiseID = '0987654321';
        stNew.ReferenceID = '001';
        allSite.add(stNew);
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record updates at EON Site
        st.postcode = '56743';
        stNew.ReferenceID = '002';
        stNew.PremiseID = '222334';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record updates at EON Site - Incorrect County ID at one record 
        stNew.PremiseID = '0987654321';
        stNew.CountyId = '9';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //Multiple record updates at EON Site - Incorrect Country ID at one record 
        stNew.CountyId = '11';
        stNew.CountryId = '9';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //CH08.New.Start
        //Multiple record update at EON Site -Multiple records with Address Type - C
        EON_Site__c eonSiteDuplicate = EON_CreateTestRecords.cereateEONSite();
        eonSiteDuplicate.name = '0987654321';
        eonSiteDuplicate.Customer__c = customer.ID;
        eonSiteDuplicate.Address_Type__c = 'C';
        insert eonSiteDuplicate;
        
        stNew.CountryId = '11';
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        //CH08.New.End
        test.stopTest();
    }
    /**
        validateUpdateEONSite_Exception(): This method will cover exception - FAIL
    **/
    static testmethod void validateUpdateEONSite_Exception(){
        EON_Utility.genException = true;
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONSite st = new EON_Voice_Update_Customer_WS.EONSite();
        st.ReferenceID = '001';
        st.Premise_SFID = 'test';
        st.PremiseID = '0987654321';
        st.Building_Number = 'test';
        st.SubBuildingName = 'test';
        st.BuildingName = 'test';
        st.Town = 'test';
        st.DependantLocality = 'test';
        st.DoubleDependantLocality = 'test';
        st.Thorofare = 'test';
        st.DependantThorofare = 'test';
        st.CountyId ='11';
        st.CountryId = '11';
        st.Postcode = 'test';
        st.AddressType = 'C';
        list<EON_Voice_Update_Customer_WS.EONSite> allSite = new list<EON_Voice_Update_Customer_WS.EONSite>();
        allSite.add(st);
        EON_Voice_Update_Customer_WS.EONSites request = new EON_Voice_Update_Customer_WS.EONSites();
        request.Customer_SFID = customer.ID;
        request.EONSite = allSite;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();     
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_FAIL, response.Status);
        test.stopTest();
    }
    /**
        updateEONSite(): This method will cover success scenario while updating EON Site - PASS
    **/
    static testmethod void updateEONSite(){
        EON_Customer__c customer = [Select ID from EON_Customer__c where name='9999999999' limit 1];
        EON_Voice_Update_Customer_WS.EONSite st = new EON_Voice_Update_Customer_WS.EONSite();
        st.ReferenceID = '001';
        st.Premise_SFID = 'test';
        st.PremiseID = '0987654321';
        st.Building_Number = 'test';
        st.SubBuildingName = 'test';
        st.BuildingName = 'test';
        st.Town = 'test';
        st.DependantLocality = 'test';
        st.DoubleDependantLocality = 'test';
        st.Thorofare = 'test';
        st.DependantThorofare = 'test';
        st.CountyId ='11';
        st.CountryId = '11';
        st.Postcode = 'test';
        st.AddressType = 'C';
        list<EON_Voice_Update_Customer_WS.EONSite> allSite = new list<EON_Voice_Update_Customer_WS.EONSite>();
        allSite.add(st);
        EON_Voice_Update_Customer_WS.EONSites request = new EON_Voice_Update_Customer_WS.EONSites();
        request.Customer_SFID = customer.ID;
        request.EONSite = allSite;
        EON_Voice_Update_Customer_WS.EONCustomerContactResults response = new EON_Voice_Update_Customer_WS.EONCustomerContactResults();
        
        test.startTest();     
        response = EON_Voice_Update_Customer_WS.UpdateEONSite(request);
        system.assertEquals(EON_Utility.RESULT_PASS, response.Status);
        test.stopTest();
    }
}