/**
    Description : This class is used for utility methods for Voice Webservice - EON_Voice_Update_Customer_WS
    VF Page     : NA
    Test Class  : EON_Voice_Update_Customer_WS_Test
**/

/*
    Created By  : Mahadev Joshilkar
    Created On  : 11/03/2016
    Service Req : SR_EON_PC_058
    Change History : 
    CH01 # SR_EON_Jumbo_030 # 09/06/2016 # Mehbobo Alam # Added a filter condition in query to check 'Vulnerability Source'.
    CH02 # SR_EON_PC_069 # 13/06/2016 # Mahadev J # Addtional validations for objects EON Service Contact Consent, EON Site and EON Opt In/Opt Out Preference. 
    CH03 # SR_EON_PC_076 # 24/06/2016 # Mahadev J # WSDL structure changed with new specifications. This class will be under development at Dev hence retired all method of this class
    CH04 # SR_EON_PC_080 # 25/07/2016 # Mahadev J # Additional validations
    CH05 # INCUK0005358243 # 11/04/2017 # Praveen G # Added change type 'I' for the contact representative when created.
    CH06 # SR_EON_PC_113 # 17/05/2017 # Praveen G #Validation on Site Vulnerability
*/
public class EON_Voice_Update_Customer_WS_Helper{
    public static boolean genException;
    public static string errorMessage;
    public static EON_Voice_Update_Customer_WS.Message message;
    public static list<EON_Voice_Update_Customer_WS.EONCustomerContact> updateEONCustomerContacts;
    
    public static list<EON_Customer__c> updateCustomer;
    public static map<String, EON_Customer_Contact_Outcome__c> createCustomerContactOutcome;
    
    public static map<String, EON_Contact_media__c> createEONContactMedia;
    public static map<String, EON_Contact_media__c> updateEONContactMedia;  //Used for Update and Delete
    
    public static map<String, EON_Contact_representative__c> createEONContactRepresentative;
    public static map<String, EON_Contact_representative__c> updateEONContactRepresentative; //Used for Update and Delete
    
    public static map<String, EON_Service_Contact_Consent__c> createEONServiceContactConsent;
    public static map<String, EON_Service_Contact_Consent__c> deleteEONServiceContactConsent;
     
    public static map<String, EON_Opt_in_Opt_Out_Preference__c> createEONOptInOptOutPreference;
    public static map<String, EON_Opt_in_Opt_Out_Preference__c> deleteEONOptInOptOutPreference;
    
    public static map<String, EON_Site_Vulnerability__c> createEONSiteVulnerability;
    public static map<String, EON_Site_Vulnerability__c> deleteEONSiteVulnerability;
    
    public static map<String, EON_Eligibility_Override__c> createEligibilityOverride;
    public static map<String, EON_Eligibility_Override__c> deleteEligibilityOverride;
    public static map<String, EON_Site__c> updateSite;
    /**
        ValidateCustomer() : This will validate request to update EON Customer records.
    **/
    public static boolean ValidateCustomer(list<EON_Voice_Update_Customer_WS.EONCustomer> Customers, String DMLFlag){
        EON_Utility eonUtility = new EON_Utility();
        list<id> allCustomerID = new list<id>();
        set<String> allPaygInterestName = new set<String>();
        map<String, ID> mapPaygIntrest = new map<String, ID>();
        updateCustomer = new list<EON_Customer__c>();
        EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
        EON_Voice_Update_Customer_WS.EONCustomerContact customerContact;
        updateEONCustomerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        //Check unique ReferenceID
        if(EON_Utility.validateRequired(Customers) != true){
            set<String> allReferenceID = new set<String>();
            for(EON_Voice_Update_Customer_WS.EONCustomer customer:Customers){
                if(EON_Utility.validateRequired(customer.ReferenceID) != true)
                    allReferenceID.add(customer.ReferenceID);
            }
            if(!allReferenceID.isEmpty()){
                if(allReferenceID.size() != Customers.size()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    message.Message = 'ReferenceID should be unique';
                    return false;
                }
            }
            else{
                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = 'ReferenceID should not be blank.';
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Update)){
            try{
                for(EON_Voice_Update_Customer_WS.EONCustomer customer:Customers){
                    Id customerID = ID.valueOf(customer.Customer_SFID);
                    allCustomerID.add(customerID);
                    if(EON_Utility.validateRequired(customer.CustomerPAYGInterest) != true)
                        allPaygInterestName.add(customer.CustomerPAYGInterest);
                    if(EON_Utility.validateRequired(customer.SmartInterest) != true){
                        String SmartInt = customer.SmartInterest;
                        if(!(SmartInt.equalsIgnoreCase('Y') || SmartInt.equalsIgnoreCase('N'))){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'SmartInterest should be Y or N';
                            return false;
                        }
                    }
                }
                list<EON_Customer__c> allCustomer = new list<EON_Customer__c>();
                allCustomer = [Select ID, Name, Smart_Interest__c, Customer_PAYG_Interest__c from EON_Customer__c where ID=:allCustomerID];
                list<EON_PAYG_Deferral_Reason__c> allPaygInterest = new list<EON_PAYG_Deferral_Reason__c>();
                allPaygInterest = [Select ID, Name from EON_PAYG_Deferral_Reason__c where Name=:allPaygInterestName];
                if(allPaygInterest != null){
                    if(allPaygInterest.size() != allPaygInterestName.size()){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                        message = new EON_Voice_Update_Customer_WS.Message();
                        message.code = eCode.Name;
                        message.Message = 'Invalid PAYG Interest';
                        return false;
                    }
                    else{
                        for(EON_PAYG_Deferral_Reason__c reason:allPaygInterest){
                            mapPaygIntrest.put(reason.Name, reason.Id);
                        }
                    }
                }
                for(EON_Customer__c cust:allCustomer){
                    String custID = cust.ID;
                    custID = custID.substring(0, 15);
                    for(EON_Voice_Update_Customer_WS.EONCustomer reqCustomer:Customers){
                        String reqCustID = reqCustomer.Customer_SFID;
                        reqCustID = reqCustID.substring(0,15);
                        if(custID == reqCustID){
                            customerContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                            customerContact.ReferenceID = reqCustomer.ReferenceID;
                            customerContact.SalesforceID = cust.ID;
                            updateEONCustomerContacts.add(customerContact);
                            
                            String SmartInt = reqCustomer.SmartInterest;
                            cust.Name = reqCustomer.Customer_ID;
                            cust.Smart_Interest__c = SmartInt.capitalize();
                            ID interestID = mapPaygIntrest.get(reqCustomer.CustomerPAYGInterest);
                            cust.Customer_PAYG_Interest__c = interestID;
                            cust.Eon_Customer_Change_Type__c = 'U';
                            updateCustomer.add(cust);
                        }
                    }
                }
            }
            catch(exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        return true;
    }
    /**
        ValidateCustomerContact() : This will validate request to update EON Customer Contact Outcome records.
    **/
    public static boolean ValidateCustomerContactOutcome(list<EON_Voice_Update_Customer_WS.EONCustomerContactOutcome> CustomerOutcomes, String Customer_SFID, String DMLFlag){
        EON_Utility eonUtility = new EON_Utility();
        list<EON_Customer__c> customer = new list<EON_Customer__c>();
        set<decimal> allContactMethodID = new set<decimal>();
        map<String, ID> mapContactMethod = new map<String, ID>();
        set<decimal> allContactOutcomeID = new set<decimal>();   //CH04
        map<String, ID> mapContactOutcome = new map<String, ID>();
        set<String> allFulfillmentID = new set<String>();
        map<String, ID> mapFulfillment = new map<String, ID>();
        //Check unique ReferenceID
        if(EON_Utility.validateRequired(CustomerOutcomes) != true){
            set<String> allReferenceID = new set<String>();
            for(EON_Voice_Update_Customer_WS.EONCustomerContactOutcome CustomerOutcome:CustomerOutcomes){
                if(EON_Utility.validateRequired(CustomerOutcome.ReferenceID) != true){
                    allReferenceID.add(CustomerOutcome.ReferenceID);
                }
            }
            if(!allReferenceID.isEmpty()){
                if(allReferenceID.size() != CustomerOutcomes.size()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    message.Message = 'ReferenceID should be unique';
                    return false;
                }
            }
            else{
                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = 'ReferenceID should not be blank.';
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Create)){
            createCustomerContactOutcome = new map<String, EON_Customer_Contact_Outcome__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    for(EON_Voice_Update_Customer_WS.EONCustomerContactOutcome CustomerOutcome: CustomerOutcomes){
                        if(EON_Utility.validateRequired(CustomerOutcome.AttemptedContactMethodCode) != true)
                            allContactMethodID.add(Decimal.valueOf(CustomerOutcome.AttemptedContactMethodCode));
                        if(EON_Utility.validateRequired(CustomerOutcome.ContactOutcomeCode) != true)
                            allContactOutcomeID.add(Decimal.valueOf(CustomerOutcome.ContactOutcomeCode)); //CH04
                        if(EON_Utility.validateRequired(CustomerOutcome.FulfilmentCode) != true)
                            allFulfillmentID.add(CustomerOutcome.FulfilmentCode);
                    }
                    if(allContactMethodID.size()>0){
                        list<EON_Contact_Method__c> allContactMethod = [Select ID, Media_Type__c from EON_Contact_Method__c where Media_Type__c=:allContactMethodID];
                        if(allContactMethod.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Contact Method does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                            if(allContactMethod.size() != allContactMethodID.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON Contact Method does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(Decimal mediaType: allContactMethodID){
                                    for(EON_Contact_Method__c conMethod: allContactMethod){
                                        if(mediaType == conMethod.Media_Type__c)
                                            mapContactMethod.put(string.valueOf(mediaType), conMethod.ID);
                                    }
                                }
                            }
                        }
                    }
                    if(allContactOutcomeID.size()>0){
                        list<EON_Contact_Outcome__c> allContactOutcome = new list<EON_Contact_Outcome__c>();
                        allContactOutcome = [Select ID, Name, Code__c from EON_Contact_Outcome__c where Code__c=:allContactOutcomeID]; //CH04
                        if(allContactOutcome.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Contact Outcome does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                            if(allContactOutcome.size() != allContactOutcomeID.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON Contact Outcome does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(decimal outcome: allContactOutcomeID){
                                    for(EON_Contact_Outcome__c conOutcome: allContactOutcome){
                                        if(outcome == conOutcome.Code__c)
                                            mapContactOutcome.put(string.valueOf(outcome), conOutcome.ID);
                                    }
                                }
                            }
                        }
                    }
                    if(allFulfillmentID.size()>0){
                        list<EON_Fulfillment__c> allFulfillment = [Select ID, Name from EON_Fulfillment__c where name=:allFulfillmentID];
                        if(allFulfillment.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Fulfillment does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                            if(allFulfillment.size() != allFulfillmentID.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON Fulfillment does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(String fulfill: allFulfillmentID){
                                    for(EON_Fulfillment__c conFulfill: allFulfillment){
                                        if(fulfill == conFulfill.Name)
                                            mapFulfillment.put(fulfill, conFulfill.ID);
                                    }
                                }
                            }
                        }
                    }
                    for(EON_Voice_Update_Customer_WS.EONCustomerContactOutcome CustomerOutcome: CustomerOutcomes){
                        EON_Customer_Contact_Outcome__c createCustConOut = new EON_Customer_Contact_Outcome__c();
                        if(EON_Utility.validateRequired(CustomerOutcome.AttemptedContactMethodCode) != true)
                            createCustConOut.Attempted_Contact_Method_Code__c = mapContactMethod.get(CustomerOutcome.AttemptedContactMethodCode);
                        if(EON_Utility.validateRequired(CustomerOutcome.ContactOutcomeCode) != true)
                            createCustConOut.Contact_Outcome_Code__c = mapContactOutcome.get(CustomerOutcome.ContactOutcomeCode);
                        if(EON_Utility.validateRequired(CustomerOutcome.ContactOutcomeDescription) != true)
                            createCustConOut.Contact_Outcome_Description__c = CustomerOutcome.ContactOutcomeDescription;
                        createCustConOut.Customer__c = Customer_SFID;
                        if(EON_Utility.validateRequired(CustomerOutcome.DateOfContact) != true)
                            createCustConOut.Date_of_Contact__c = CustomerOutcome.DateOfContact;
                        createCustConOut.EON_Contact_Outcome_Change_Type__c = 'I';
                        if(EON_Utility.validateRequired(CustomerOutcome.FulfilmentCode) != true)
                            createCustConOut.Fulfilment_Code__c = mapFulfillment.get(CustomerOutcome.FulfilmentCode);
                        createCustomerContactOutcome.put(CustomerOutcome.ReferenceID, createCustConOut);
                    }
                }
            }
            Catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        return true;
    }
    /**
        ValidateContactMedia() : This will validate request to create/update/delete EON Site records.
    **/
    public static boolean ValidateContactMedia(list<EON_Voice_Update_Customer_WS.EONContactMedium> ContactMedia, String Customer_SFID, String DMLFlag){
        EON_Utility eonUtility = new EON_Utility();
        list<EON_Customer__c> customer = new list<EON_Customer__c>();
        set<decimal> allContactMethodType = new set<decimal>();
        map<decimal, ID> mapContactMethodType = new map<decimal, ID>();
        set<ID> allContactRepresentative = new set<ID>();
        map<ID, EON_Contact_representative__c> mapContactRepresentative = new map<ID, EON_Contact_representative__c>();
        set<ID> allContactMediaID = new set<ID>();
        map<ID, EON_Contact_media__c> mapContactMedia = new map<ID, EON_Contact_media__c>();
        //Check unique ReferenceID
        if(EON_Utility.validateRequired(ContactMedia) != true){
            set<String> allReferenceID = new set<String>();
            for(EON_Voice_Update_Customer_WS.EONContactMedium cMedia:ContactMedia){
                if(EON_Utility.validateRequired(cMedia.ReferenceID) != true)
                    allReferenceID.add(cMedia.ReferenceID);
            }
            if(!allReferenceID.isEmpty()){
                if(allReferenceID.size() != ContactMedia.size()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    message.Message = 'ReferenceID should be unique';
                    return false;
                }
            }
            else{
                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = 'ReferenceID should not be blank.';
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Create)){
            createEONContactMedia = new map<String, EON_Contact_media__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    //Collect data to search and validate request
                    for(EON_Voice_Update_Customer_WS.EONContactMedium cMedia:ContactMedia){
                        if(EON_Utility.validateRequired(cMedia.ContactMethodType) != true)
                            allContactMethodType.add(decimal.valueOf(cMedia.ContactMethodType));
                        if(EON_Utility.validateRequired(cMedia.Representative_SFID) != true){
                            ID repID = ID.valueof(cMedia.Representative_SFID);
                            allContactRepresentative.add(repID);
                        }
                        if(EON_Utility.validateRequired(cMedia.IsPreferredContactMethod) != true){
                            string isPrefMethod = cMedia.IsPreferredContactMethod;
                            if(!isPrefMethod.equalsIgnoreCase('Y') && !isPrefMethod.equalsIgnoreCase('N')){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'Is Preferred Contact Method should be Y or N';
                                return false;
                            }
                        }
                        if(EON_Utility.validateRequired(cMedia.PhoneCode) != true){
                            string pCode = cMedia.PhoneCode;
                            if(!pCode.isNumeric()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'Phone code should be numeric';
                                return false;
                            }
                        }
                        if(EON_Utility.validateRequired(cMedia.PhoneNumber) != true){
                            string pNumber = cMedia.PhoneNumber;
                            if(!pNumber.isNumeric()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'Phone number should be numeric';
                                return false;
                            }
                        }
                    }
                    //Validate Contact Method
                    if(!allContactMethodType.isEmpty()){
                        list<EON_Contact_Method__c> searchEONContactMethodType = new list<EON_Contact_Method__c>();
                        searchEONContactMethodType = [Select ID, Media_Type__c from EON_Contact_Method__c where Media_Type__c=:allContactMethodType];
                        if(!searchEONContactMethodType.isEmpty()){
                            if(allContactMethodType.size() != searchEONContactMethodType.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'One or more Contact Method Type does not exist';
                                return false;
                            }
                            else{
                                for(EON_Contact_Method__c methodType:searchEONContactMethodType){
                                    mapContactMethodType.put(methodType.Media_Type__c, methodType.Id);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'Contact Method Type does not exist';
                            return false;
                        }
                    }
                    //Validate Contact Representative
                    if(!allContactRepresentative.isEmpty()){
                        list<EON_Contact_representative__c> searchEONContactRepresentative = new list<EON_Contact_representative__c>();
                        searchEONContactRepresentative = [Select ID from EON_Contact_representative__c where ID=:allContactRepresentative and Eon_Contact_Representative_Change_Type__c!='D'];
                        if(!searchEONContactRepresentative.isEmpty()){
                            if(allContactRepresentative.size() != searchEONContactRepresentative.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'One or more representative does not exist';
                                return false;
                            }
                            else{
                                for(ID repID: allContactRepresentative){
                                    String rID = String.valueOf(repID);  
                                    rID = rID.substring(0,15);
                                    for(EON_Contact_representative__c mRep: searchEONContactRepresentative){
                                        String mRepID = mRep.ID;
                                        mRepID = mRepID.substring(0, 15);
                                        if(mRepID == rID)
                                            mapContactRepresentative.put(repID, mRep);
                                    }
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'Representative does not exist';
                            return false;
                        }
                    }
                    //Process request
                    for(EON_Voice_Update_Customer_WS.EONContactMedium cMedia:ContactMedia){
                        EON_Contact_media__c recContactMedia = new EON_Contact_media__c();
                        recContactMedia.EON_Contact_media_Change_Type__c = 'I';
                        if(EON_Utility.validateRequired(Customer_SFID) != true)
                            recContactMedia.Customer__c = Customer_SFID;
                        if(EON_Utility.validateRequired(cMedia.ContactMediaID) != true)
                            recContactMedia.Name = cMedia.ContactMediaID;
                        if(EON_Utility.validateRequired(cMedia.ContactMethodType) != true)
                            recContactMedia.Contact_method_type__c = mapContactMethodType.get(decimal.valueOf(cMedia.ContactMethodType));
                        if(EON_Utility.validateRequired(cMedia.Email) != true)
                            recContactMedia.Email__c = cMedia.Email;
                        if(EON_Utility.validateRequired(cMedia.IsPreferredContactMethod) != true){
                            string isPrefMethod = cMedia.IsPreferredContactMethod;
                            recContactMedia.Is_preferred_contact_method__c = isPrefMethod.capitalize();
                        }
                        if(EON_Utility.validateRequired(cMedia.PhoneCode) != true)
                            recContactMedia.Phone_Code__c = cMedia.PhoneCode;
                        if(EON_Utility.validateRequired(cMedia.PhoneNumber) != true)
                            recContactMedia.Phone_Number__c = cMedia.PhoneNumber;
                        if(EON_Utility.validateRequired(cMedia.PhoneExtension) != true)
                            recContactMedia.Phone_Extension__c = cMedia.PhoneExtension;
                        if(EON_Utility.validateRequired(cMedia.Representative_SFID) != true){
                            ID rID = ID.valueof(cMedia.Representative_SFID);
                            EON_Contact_representative__c rep = mapContactRepresentative.get(rID);
                            recContactMedia.Representative__c = rep.ID;
                        }
                        createEONContactMedia.put(cMedia.ReferenceID , recContactMedia);
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Update)){
            updateEONContactMedia = new map<String, EON_Contact_media__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    //Collect data to search and validate request
                    for(EON_Voice_Update_Customer_WS.EONContactMedium cMedia:ContactMedia){
                        if(EON_Utility.validateRequired(cMedia.ContactMedia_SFID) != true){
                            ID cMediaID = ID.valueof(cMedia.ContactMedia_SFID);
                            allContactMediaID.add(cMediaID);
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'ContactMedia_SFID cannot be null or blank';
                            return false;
                        }
                        if(EON_Utility.validateRequired(cMedia.ContactMethodType) != true)
                            allContactMethodType.add(decimal.valueOf(cMedia.ContactMethodType));
                        if(EON_Utility.validateRequired(cMedia.IsPreferredContactMethod) != true){
                            string isPrefMethod = cMedia.IsPreferredContactMethod;
                            if(!isPrefMethod.equalsIgnoreCase('Y') && !isPrefMethod.equalsIgnoreCase('N')){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'Is Preferred Contact Method should be Y or N';
                                return false;
                            }
                        }
                        if(EON_Utility.validateRequired(cMedia.PhoneCode) != true){
                            string pCode = cMedia.PhoneCode;
                            if(!pCode.isNumeric()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'Phone code should be numeric';
                                return false;
                            }
                        }
                        if(EON_Utility.validateRequired(cMedia.PhoneNumber) != true){
                            string pNumber = cMedia.PhoneNumber;
                            if(!pNumber.isNumeric()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'Phone number should be numeric';
                                return false;
                            }
                        }
                    }
                    //Validate Contact Media Records
                    if(!allContactMediaID.isEmpty()){
                        list<EON_Contact_Media__c> searchContactMdia = new list<EON_Contact_Media__c>();
                        searchContactMdia = [Select ID, Name, Contact_method_type__c, Email__c, EON_Contact_media_Change_Type__c, Is_preferred_contact_method__c, Phone_Code__c, Phone_Extension__c, Phone_Number__c from EON_Contact_Media__c where ID=:allContactMediaID and EON_Contact_media_Change_Type__c != 'D'];
                        if(!searchContactMdia.isEmpty()){
                            if(searchContactMdia.size() != allContactMediaID.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'One or more Contact Media does not exist.';
                                return false;
                            }
                            else
                                mapContactMedia.putAll(searchContactMdia);
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'Contact Media either does not exist or already deleted';
                            return false;
                        }
                    }
                    //Validate Contact Method
                    if(!allContactMethodType.isEmpty()){
                        list<EON_Contact_Method__c> searchEONContactMethodType = new list<EON_Contact_Method__c>();
                        searchEONContactMethodType = [Select ID, Media_Type__c from EON_Contact_Method__c where Media_Type__c=:allContactMethodType];
                        if(!searchEONContactMethodType.isEmpty()){
                            if(allContactMethodType.size() != searchEONContactMethodType.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'One or more Contact Method Type does not exist';
                                return false;
                            }
                            else{
                                for(EON_Contact_Method__c methodType:searchEONContactMethodType){
                                    mapContactMethodType.put(methodType.Media_Type__c, methodType.Id);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'Contact Method Type does not exist';
                            return false;
                        }
                    }
                    //Process request
                    for(EON_Voice_Update_Customer_WS.EONContactMedium cMedia:ContactMedia){
                        EON_Contact_media__c recContactMedia = new EON_Contact_media__c();
                        if(EON_Utility.validateRequired(cMedia.ContactMedia_SFID) != true){
                            ID cMediaID = ID.valueof(cMedia.ContactMedia_SFID);
                            recContactMedia = mapContactMedia.get(cMediaID);
                        }
                        recContactMedia.EON_Contact_media_Change_Type__c = 'U';
                        if(EON_Utility.validateRequired(cMedia.ContactMediaID) != true)
                            recContactMedia.Name = cMedia.ContactMediaID;
                        if(EON_Utility.validateRequired(cMedia.ContactMethodType) != true)
                            recContactMedia.Contact_method_type__c = mapContactMethodType.get(decimal.valueOf(cMedia.ContactMethodType));
                        if(EON_Utility.validateRequired(cMedia.Email) != true)
                            recContactMedia.Email__c = cMedia.Email;
                        if(EON_Utility.validateRequired(cMedia.IsPreferredContactMethod) != true){
                            string isPrefMethod = cMedia.IsPreferredContactMethod;
                            recContactMedia.Is_preferred_contact_method__c = isPrefMethod.capitalize();
                        }
                        if(EON_Utility.validateRequired(cMedia.PhoneCode) != true)
                            recContactMedia.Phone_Code__c = cMedia.PhoneCode;
                        if(EON_Utility.validateRequired(cMedia.PhoneNumber) != true)
                            recContactMedia.Phone_Number__c = cMedia.PhoneNumber;
                        if(EON_Utility.validateRequired(cMedia.PhoneExtension) != true)
                            recContactMedia.Phone_Extension__c = cMedia.PhoneExtension;
                        updateEONContactMedia.put(cMedia.ReferenceID , recContactMedia);
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Delete)){
            updateEONContactMedia = new map<String, EON_Contact_media__c>();
            try{
                for(EON_Voice_Update_Customer_WS.EONContactMedium contactMedium: ContactMedia){
                    if(EON_Utility.validateRequired(contactMedium.ContactMedia_SFID) != true){
                        ID eID = ID.valueof(contactMedium.ContactMedia_SFID);
                        allContactMediaID.add(eID);
                    }
                }
                if(!allContactMediaID.isEmpty()){
                    list<EON_Contact_media__c> searchContactMedia = new list<EON_Contact_media__c>();
                    searchContactMedia = [Select ID, EON_Contact_media_Change_Type__c from EON_Contact_media__c where ID=:allContactMediaID and EON_Contact_media_Change_Type__c !='D'];
                    if(!searchContactMedia.isEmpty()){
                        if(searchContactMedia.size() == allContactMediaID.size()){
                            map<ID, EON_Contact_media__c> mapConMedia = new map<ID, EON_Contact_media__c>();
                            mapConMedia.putAll(searchContactMedia);
                            for(EON_Voice_Update_Customer_WS.EONContactMedium contactMed:ContactMedia){
                                if(allContactMediaID.contains(contactMed.ContactMedia_SFID)){
                                    EON_Contact_media__c recContactMedia = mapConMedia.get(contactMed.ContactMedia_SFID);
                                    recContactMedia.EON_Contact_media_Change_Type__c = 'D';
                                    updateEONContactMedia.put(contactMed.ReferenceID, recContactMedia);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Contact Media does not exist';
                            message.Message = errorMessage;
                            return false;
                            }
                    }
                    else{
                        EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                        message = new EON_Voice_Update_Customer_WS.Message();
                        message.code = eCode.Name;
                        errorMessage = 'EON Contact Media either does not exist or already deleted';
                        message.Message = errorMessage;
                        return false;
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        return true;
    }
    
    /**
        ValidateContactRepresentative() : This will validate request to create/update/delete EON Contact Representative.
    **/
    public static boolean ValidateContactRepresentative(list<EON_Voice_Update_Customer_WS.EONContactRepresentative> ContactRepresentatives, String Customer_SFID, String DMLFlag){
        EON_Utility eonUtility = new EON_Utility();
        list<EON_Customer__c> customer = new list<EON_Customer__c>();
        set<decimal> allRoleType = new set<decimal>(); 
        map<decimal, ID> mapRoleType = new map<decimal, ID>();
        set<ID> allContactRep = new set<ID>();
        //Check unique ReferenceID
        if(EON_Utility.validateRequired(ContactRepresentatives) != true){
            set<String> allReferenceID = new set<String>();
            for(EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative:ContactRepresentatives){
                if(EON_Utility.validateRequired(contactRepresentative.ReferenceID) != true)
                    allReferenceID.add(contactRepresentative.ReferenceID);
            }
            if(!allReferenceID.isEmpty()){
                if(allReferenceID.size() != ContactRepresentatives.size()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    message.Message = 'ReferenceID should be unique';
                    return false;
                }
            }
            else{
                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = 'ReferenceID should not be blank.';
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Create)){
            createEONContactRepresentative = new map<String, EON_Contact_representative__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    for(EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative:ContactRepresentatives){
                        if(EON_Utility.validateRequired(contactRepresentative.RoleType) != true)
                            allRoleType.add(decimal.valueOf(contactRepresentative.RoleType));
                    }
                    if(!allRoleType.isEmpty()){
                        list<EON_ROLE_TYPE_REPRESENTATIVE__c> searchEONRoleTypePresentation = new list<EON_ROLE_TYPE_REPRESENTATIVE__c>();
                        searchEONRoleTypePresentation = [Select ID, Role_Type__c from EON_ROLE_TYPE_REPRESENTATIVE__c where Role_Type__c=:allRoleType];
                        if(!searchEONRoleTypePresentation.isEmpty()){
                            if(allRoleType.size() != searchEONRoleTypePresentation.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'One or more Role Type does not exist';
                                return false;
                            }
                            else{
                                for(EON_ROLE_TYPE_REPRESENTATIVE__c roleType:searchEONRoleTypePresentation){
                                    mapRoleType.put(roleType.Role_Type__c, roleType.Id);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'Role Type does not exist';
                            return false;
                        }
                    }
                    for(EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative:ContactRepresentatives){
                        EON_Contact_representative__c contactRep = new EON_Contact_representative__c();
                        contactRep.Customer__c = Customer_SFID;
                        //CH05.Start
                        contactRep.Eon_Contact_Representative_Change_Type__c = 'I';
                        //CH05.End
                        if(EON_Utility.validateRequired(contactRepresentative.RepresentativeID) != true)
                            contactRep.Name = contactRepresentative.RepresentativeID;
                        if(EON_Utility.validateRequired(contactRepresentative.ContactName) != true)
                            contactRep.Contact_Name__c = contactRepresentative.ContactName;
                        if(EON_Utility.validateRequired(contactRepresentative.RoleType) != true){
                            decimal rType = decimal.valueOf(contactRepresentative.RoleType);
                            contactRep.Role_Type__c = mapRoleType.get(rType);
                        }
                        if(EON_Utility.validateRequired(contactRepresentative.ReferenceID) != true)
                            createEONContactRepresentative.put(contactRepresentative.ReferenceID, contactRep);
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Update)){
            updateEONContactRepresentative = new map<String, EON_Contact_representative__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    for(EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative:ContactRepresentatives){
                        if(EON_Utility.validateRequired(contactRepresentative.RoleType) != true)
                            allRoleType.add(decimal.valueOf(contactRepresentative.RoleType));
                        if(EON_Utility.validateRequired(contactRepresentative.ContactRepresentative_SFID) != true){
                            ID eID = ID.valueof(contactRepresentative.ContactRepresentative_SFID);
                            allContactRep.add(eID);
                        }
                    }
                    if(!allRoleType.isEmpty()){
                        list<EON_ROLE_TYPE_REPRESENTATIVE__c> searchEONRoleTypePresentation = new list<EON_ROLE_TYPE_REPRESENTATIVE__c>();
                        searchEONRoleTypePresentation = [Select ID, Role_Type__c from EON_ROLE_TYPE_REPRESENTATIVE__c where Role_Type__c=:allRoleType];
                        if(!searchEONRoleTypePresentation.isEmpty()){
                            if(allRoleType.size() != searchEONRoleTypePresentation.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'One or more Role Type does not exist';
                                return false;
                            }
                            else{
                                for(EON_ROLE_TYPE_REPRESENTATIVE__c roleType:searchEONRoleTypePresentation){
                                    mapRoleType.put(roleType.Role_Type__c, roleType.Id);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'Role Type does not exist';
                            return false;
                        }
                    }
                    if(!allContactRep.isEmpty()){
                        list<EON_Contact_representative__c> searchContactRepresentative = new list<EON_Contact_representative__c>();
                        searchContactRepresentative = [Select ID, Name, Eon_Contact_Representative_Change_Type__c, Role_Type__c, Contact_Name__c from EON_Contact_representative__c where ID=:allContactRep and Eon_Contact_Representative_Change_Type__c !='D'];
                        if(!searchContactRepresentative.isEmpty()){
                            if(searchContactRepresentative.size() == allContactRep.size()){
                                map<ID, EON_Contact_representative__c> mapConRep = new map<ID, EON_Contact_representative__c>();
                                mapConRep.putAll(searchContactRepresentative);
                                for(EON_Voice_Update_Customer_WS.EONContactRepresentative contactRep:ContactRepresentatives){
                                    if(allContactRep.contains(contactRep.ContactRepresentative_SFID)){
                                        EON_Contact_representative__c recContactRepresentative = mapConRep.get(contactRep.ContactRepresentative_SFID);
                                        recContactRepresentative.Name = contactRep.RepresentativeID;
                                        recContactRepresentative.Contact_Name__c = contactRep.ContactName;
                                        recContactRepresentative.Role_Type__c = mapRoleType.get(decimal.valueOf(contactRep.RoleType));
                                        recContactRepresentative.Eon_Contact_Representative_Change_Type__c = 'U';
                                        updateEONContactRepresentative.put(contactRep.ReferenceID, recContactRepresentative);
                                    }
                                }
                            }
                            else{
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON Contact Representative does not exist';
                                message.Message = errorMessage;
                                return false;
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Contact Representative either does not exist or already deleted';
                            message.Message = errorMessage;
                            return false;
                        }
                    }
                    else{
                        EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                        message = new EON_Voice_Update_Customer_WS.Message();
                        message.code = eCode.Name;
                        message.Message = 'ContactRepresentative SFID is required';
                        return false;
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Delete)){
            updateEONContactRepresentative = new map<String, EON_Contact_representative__c>();
            try{
                for(EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative: ContactRepresentatives){
                    if(EON_Utility.validateRequired(contactRepresentative.ContactRepresentative_SFID) != true){
                        ID eID = ID.valueof(contactRepresentative.ContactRepresentative_SFID);
                        allContactRep.add(eID);
                    }
                }
                if(!allContactRep.isEmpty()){
                    list<EON_Contact_representative__c> searchContactRepresentative = new list<EON_Contact_representative__c>();
                    searchContactRepresentative = [Select ID, Name, Eon_Contact_Representative_Change_Type__c, Role_Type__c, Contact_Name__c from EON_Contact_representative__c where ID=:allContactRep and Eon_Contact_Representative_Change_Type__c !='D'];
                    if(!searchContactRepresentative.isEmpty()){
                        if(searchContactRepresentative.size() == allContactRep.size()){
                            map<ID, EON_Contact_representative__c> mapConRep = new map<ID, EON_Contact_representative__c>();
                            mapConRep.putAll(searchContactRepresentative);
                            for(EON_Voice_Update_Customer_WS.EONContactRepresentative contactRep:ContactRepresentatives){
                                if(allContactRep.contains(contactRep.ContactRepresentative_SFID)){
                                    EON_Contact_representative__c recContactRepresentative = mapConRep.get(contactRep.ContactRepresentative_SFID);
                                    recContactRepresentative.Eon_Contact_Representative_Change_Type__c = 'D';
                                    updateEONContactRepresentative.put(contactRep.ReferenceID, recContactRepresentative);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Contact Representative does not exist';
                            message.Message = errorMessage;
                            return false;
                            }
                    }
                    else{
                        EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                        message = new EON_Voice_Update_Customer_WS.Message();
                        message.code = eCode.Name;
                        errorMessage = 'EON Contact Representative either does not exist or already deleted';
                        message.Message = errorMessage;
                        return false;
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        return true;
    }
    
    /**
        ValidateOptInOptOutPreference() : This will validate request to create/delete EON Opt/In Opt/Out Preference.
    **/
    public static boolean ValidateOptInOptOutPreference(list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference> OptInOptOutPreferences, String Customer_SFID, String DMLFlag){
        EON_Utility eonUtility = new EON_Utility();
        list<EON_Customer__c> customer = new list<EON_Customer__c>();
        set<string> allPremiseID = new set<string>();
        map<string, ID> mapPremiseID = new map<string, ID>();
        map<String, Integer> mapSiteOptInOptOutPreference = new map<String, Integer>();
        set<decimal> allOptOutReasonCode = new set<decimal>();
        map<decimal, ID> mapOptOutReasonCode = new map<decimal, ID>();
        set<ID> allOptInOptOutPreference = new set<ID>();
        //Check unique ReferenceID
        if(EON_Utility.validateRequired(OptInOptOutPreferences) != true){
            set<String> allReferenceID = new set<String>();
            for(EON_Voice_Update_Customer_WS.EONOptInOptOutPreference OptInOptOutPreference:OptInOptOutPreferences){
                if(EON_Utility.validateRequired(OptInOptOutPreference.ReferenceID) != true)
                    allReferenceID.add(OptInOptOutPreference.ReferenceID);
            }
            if(!allReferenceID.isEmpty()){
                if(allReferenceID.size() != OptInOptOutPreferences.size()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    message.Message = 'ReferenceID should be unique';
                    return false;
                }
            }
            else{
                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = 'ReferenceID should not be blank.';
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Create)){
            createEONOptInOptOutPreference = new map<String, EON_Opt_in_Opt_Out_Preference__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    for(EON_Voice_Update_Customer_WS.EONOptInOptOutPreference OptInOptOutPreference:OptInOptOutPreferences){
                        if(EON_Utility.validateRequired(OptInOptOutPreference.PremiseID) != true){
                            if(mapSiteOptInOptOutPreference.containsKey(OptInOptOutPreference.PremiseID)){
                                integer i = mapSiteOptInOptOutPreference.get(OptInOptOutPreference.PremiseID);
                                i++;
                            }
                            else{
                                allPremiseID.add(OptInOptOutPreference.PremiseID);
                                mapSiteOptInOptOutPreference.put(OptInOptOutPreference.PremiseID, 1);
                            }
                        }
                        if(EON_Utility.validateRequired(OptInOptOutPreference.OptOutReasonCode) != true)
                            allOptOutReasonCode.add(decimal.valueOf(OptInOptOutPreference.OptOutReasonCode));
                        if(EON_Utility.validateRequired(OptInOptOutPreference.OptInOptOutPreference) != true){
                            String Pref = OptInOptOutPreference.OptInOptOutPreference;
                            if(!(Pref.equalsIgnoreCase('Y') || Pref.equalsIgnoreCase('N'))){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'OptInOptOutPreference should be Y or N';
                                return false;
                            }
                        }
                    }
                    if(!allPremiseID.isEmpty()){
                        list<EON_Site__c> searchEONSite = new list<EON_Site__c>();
                        searchEONSite = [Select ID, Name, (Select ID from EON_Opt_in_Opt_Out_Preferences__r) from EON_Site__c where Name=:allPremiseID and Address_Type__c='S'];
                        if(!searchEONSite.isEmpty()){
                            if(allPremiseID.size() != searchEONSite.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'One or more Premise ID does not exist';
                                return false;
                            }
                            else{
                                for(EON_Site__c eSite:searchEONSite){
                                    if(EON_Utility.validateRequired(eSite.EON_Opt_in_Opt_Out_Preferences__r) != true){
                                        for(list<EON_Opt_in_Opt_Out_Preference__c> allPref:eSite.EON_Opt_in_Opt_Out_Preferences__r){
                                            if(mapSiteOptInOptOutPreference.containsKey(eSite.Name)){
                                                integer recordCount = mapSiteOptInOptOutPreference.get(eSite.Name);
                                                recordCount += allPref.size();
                                                if(recordCount>6){
                                                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                                    message = new EON_Voice_Update_Customer_WS.Message();
                                                    message.code = eCode.Name;
                                                    message.Message = 'Cannot create more than 6 Opt in Opt Out Preferences for PremiseID '+eSite.Name;
                                                    return false;
                                                }
                                            }
                                        }
                                    }
                                    mapPremiseID.put(eSite.Name, eSite.Id);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'Premise ID does not exist';
                            return false;
                        }
                    }
                    if(!allOptOutReasonCode.isEmpty()){
                        list<EON_Opt_Out_Reason__c> searchOptOutReasonCode = new list<EON_Opt_Out_Reason__c>();
                        searchOptOutReasonCode = [Select ID, Reason_Code__c from EON_Opt_Out_Reason__c where Reason_Code__c =:allOptOutReasonCode];
                        if(!searchOptOutReasonCode.isEmpty()){
                            if(searchOptOutReasonCode.size() == allOptOutReasonCode.size()){
                                for(EON_Opt_Out_Reason__c optOutReason:searchOptOutReasonCode){
                                    mapOptOutReasonCode.put(optOutReason.Reason_Code__c, optOutReason.ID);
                                }
                            }
                            else{
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                message.Message = 'One or more Opt Out Reason Code does not exist';
                                return false;
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            message.Message = 'Opt Out Reason Code does not exist';
                            return false;
                        }
                    }
                    for(EON_Voice_Update_Customer_WS.EONOptInOptOutPreference OptInOptOutPreference:OptInOptOutPreferences){
                        EON_Opt_in_Opt_Out_Preference__c createOptInOptOutPreference = new EON_Opt_in_Opt_Out_Preference__c();
                        createOptInOptOutPreference.EON_Opt_In_Opt_Out_Pref_Change_Type__c = 'I';
                        createOptInOptOutPreference.Customer__c = Customer_SFID;
                        if(EON_Utility.validateRequired(OptInOptOutPreference.PremiseID) != true)
                            createOptInOptOutPreference.Premise__c = mapPremiseID.get(OptInOptOutPreference.PremiseID);
                        if(EON_Utility.validateRequired(OptInOptOutPreference.OptOutReasonCode) != true)
                            createOptInOptOutPreference.Opt_Out_Reason_Code__c = mapOptOutReasonCode.get(decimal.valueOf(OptInOptOutPreference.OptOutReasonCode));
                        if(EON_Utility.validateRequired(OptInOptOutPreference.OptInOptOutPreference) != true){
                            String Pref = OptInOptOutPreference.OptInOptOutPreference;
                            if(Pref.equalsIgnoreCase('Y'))
                                createOptInOptOutPreference.Opt_In_Opt_Out_Preference__c = true;
                            else if(Pref.equalsIgnoreCase('N'))
                                createOptInOptOutPreference.Opt_In_Opt_Out_Preference__c = false;
                        }
                        createEONOptInOptOutPreference.put(OptInOptOutPreference.ReferenceID, createOptInOptOutPreference);
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Delete)){
            deleteEONOptInOptOutPreference = new map<String, EON_Opt_in_Opt_Out_Preference__c>();
            try{
                for(EON_Voice_Update_Customer_WS.EONOptInOptOutPreference optInOptOutPreference: OptInOptOutPreferences){
                    if(EON_Utility.validateRequired(optInOptOutPreference.EONOptInOptOutPreference_SFID) != true){
                        ID eID = ID.valueof(optInOptOutPreference.EONOptInOptOutPreference_SFID);
                        allOptInOptOutPreference.add(eID);
                    }
                }
                    if(!allOptInOptOutPreference.isEmpty()){
                        list<EON_Opt_in_Opt_Out_Preference__c> searchOptInOptOutPreference = new list<EON_Opt_in_Opt_Out_Preference__c>();
                        searchOptInOptOutPreference = [Select ID, EON_Opt_In_Opt_Out_Pref_Change_Type__c, Opt_In_Opt_Out_Preference__c, Opt_Out_Reason_Code__c, Premise__c from EON_Opt_in_Opt_Out_Preference__c where ID=:allOptInOptOutPreference and EON_Opt_In_Opt_Out_Pref_Change_Type__c !='D'];
                        if(!searchOptInOptOutPreference.isEmpty()){
                            if(allOptInOptOutPreference.size() == searchOptInOptOutPreference.size()){
                                map<ID, EON_Opt_in_Opt_Out_Preference__c> mapOOP = new map<ID, EON_Opt_in_Opt_Out_Preference__c>();
                                mapOOP.putAll(searchOptInOptOutPreference);
                                for(EON_Voice_Update_Customer_WS.EONOptInOptOutPreference optInOptOutPreference:OptInOptOutPreferences){
                                    if(allOptInOptOutPreference.contains(optInOptOutPreference.EONOptInOptOutPreference_SFID)){
                                        EON_Opt_in_Opt_Out_Preference__c recoptInOptOutPreference = mapOOP.get(optInOptOutPreference.EONOptInOptOutPreference_SFID);
                                        recoptInOptOutPreference.EON_Opt_In_Opt_Out_Pref_Change_Type__c = 'D';
                                        deleteEONOptInOptOutPreference.put(optInOptOutPreference.ReferenceID, recoptInOptOutPreference);
                                    }
                                }
                            }
                            else{
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON Opt In Opt Out Preference does not exist';
                                message.Message = errorMessage;
                                return false;
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Opt In Opt Out Preference either does not exist or already deleted';
                            message.Message = errorMessage;
                            return false;
                        }
                    }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        return true;
    }
    
    /**
        ValidateServiceContactConsent() : This will validate request to create/delete EON Service Contact Consent.
    **/
    public static boolean ValidateServiceContactConsent(list<EON_Voice_Update_Customer_WS.EONServiceContactConsent> ServiceContactConsents, String Customer_SFID, String DMLFlag){
        EON_Utility eonUtility = new EON_Utility();
        list<EON_Customer__c> customer = new list<EON_Customer__c>();
        set<decimal> allContactMethodType = new set<decimal>();
        map<decimal, ID> mapContactMethodType = new map<decimal, ID>();
        set<ID> allContactMediaID = new set<ID>();
        map<ID, EON_Contact_Media__c> mapContactMedia = new map<ID, EON_Contact_Media__c>();
        set<ID> allServiceContactConsentID = new set<ID>();
        //Check unique ReferenceID
        if(EON_Utility.validateRequired(ServiceContactConsents) != true){
            set<String> allReferenceID = new set<String>();
            for(EON_Voice_Update_Customer_WS.EONServiceContactConsent ServiceContactConsent:ServiceContactConsents){
                if(EON_Utility.validateRequired(ServiceContactConsent.ReferenceID) != true)
                    allReferenceID.add(ServiceContactConsent.ReferenceID);
            }
            if(!allReferenceID.isEmpty()){
                if(allReferenceID.size() != ServiceContactConsents.size()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    message.Message = 'ReferenceID should be unique';
                    return false;
                }
            }
            else{
                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = 'ReferenceID should not be blank.';
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Create)){
            createEONServiceContactConsent = new map<String, EON_Service_Contact_Consent__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID, (Select ID from EON_Service_Contact_Consents__r where EON_Service_Contact_Consent_Change_Type__c != 'D') from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    //Cannot create more than two Service Contact Conscent
                    for(EON_Customer__c cust: customer){
                        for(list<EON_Service_Contact_Consent__c> existingRec: cust.EON_Service_Contact_Consents__r){
                            if(EON_Utility.validateRequired(existingRec) != true){
                                integer i = existingRec.size() + ServiceContactConsents.size();
                                if(i > 2){
                                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                    message = new EON_Voice_Update_Customer_WS.Message();
                                    message.code = eCode.Name;
                                    message.Message = 'Cannot create more than two service contact conscents for Customer_SFID '+Customer_SFID;
                                    return false;
                                }
                            }
                        }
                    }
                    //Collect all information to search
                    for(EON_Voice_Update_Customer_WS.EONServiceContactConsent consent: ServiceContactConsents){
                        if(EON_Utility.validateRequired(consent.ContactMethodType) != true)
                           allContactMethodType.add(decimal.valueOf(consent.ContactMethodType)); 
                        if(EON_Utility.validateRequired(consent.ContactMediaID_SFID) != true){
                            ID contactMediaID = id.valueof(consent.ContactMediaID_SFID);
                            allContactMediaID.add(contactMediaID);
                        } 
                        if(EON_Utility.validateRequired(consent.PhoneCode) != true){
                            String pCode = consent.PhoneCode;
                            if(!pCode.isNumeric()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                 message = new EON_Voice_Update_Customer_WS.Message();
                                 message.code = eCode.Name;
                                 errorMessage = 'Phone code must be numeric.';
                                 message.Message = errorMessage;
                                 return false;
                            }
                        }
                        if(EON_Utility.validateRequired(consent.PhoneNumber) != true){
                            String pNumber = consent.PhoneNumber;
                            if(!pNumber.isNumeric()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                 message = new EON_Voice_Update_Customer_WS.Message();
                                 message.code = eCode.Name;
                                 errorMessage = 'Phone number must be numeric.';
                                 message.Message = errorMessage;
                                 return false;
                            }
                        }
                    }
                    //Validate Method Type
                    if(!allContactMethodType.isEmpty()){
                        list<EON_Contact_Method__c> searchContactMethod = new list<EON_Contact_Method__c>();
                        searchContactMethod = [Select ID, Name, Media_Type__c from EON_Contact_Method__c where Media_Type__c =: allContactMethodType];
                        if(searchContactMethod.isEmpty()){
                             EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                             message = new EON_Voice_Update_Customer_WS.Message();
                             message.code = eCode.Name;
                             errorMessage = 'EON Contact Method Type does not exist.';
                             message.Message = errorMessage;
                             return false;
                        }
                        else{
                            if(searchContactMethod.size() != allContactMethodType.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'One or more EON Contact Method Type does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(decimal mType: allContactMethodType){
                                    for(EON_Contact_Method__c method: searchContactMethod){
                                        if(mType == method.Media_Type__c)
                                            mapContactMethodType.put(mType, method.ID);
                                    }
                                }
                            }
                        }
                    }
                    //Validate Contact Media ID
                    if(!allContactMediaID.isEmpty()){
                        list<EON_Contact_media__c> searchContactMedia = new list<EON_Contact_media__c>();
                        searchContactMedia = [Select ID, Name from EON_Contact_media__c where ID =: allContactMediaID and EON_Contact_media_Change_Type__c!='D'];
                        if(searchContactMedia.isEmpty()){
                             EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                             message = new EON_Voice_Update_Customer_WS.Message();
                             message.code = eCode.Name;
                             errorMessage = 'EON Contact Media does not exist.';
                             message.Message = errorMessage;
                             return false;
                        }
                        else{
                            if(searchContactMedia.size() != allContactMediaID.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'One or more EON Contact Media does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(ID mediaID: allContactMediaID){
                                    String mID = String.valueOf(mediaID);  
                                    mID = mID.substring(0,15);
                                    for(EON_Contact_media__c media: searchContactMedia){
                                        String mRecID = media.ID;
                                        mRecID = mRecID.substring(0, 15);
                                        if(mRecID == mID)
                                            mapContactMedia.put(mediaID, media);
                                    }
                                }
                            }
                        }
                    }
                    //Process request
                    for(EON_Voice_Update_Customer_WS.EONServiceContactConsent consent: ServiceContactConsents){
                        EON_Service_Contact_Consent__c createServiceConsent = new EON_Service_Contact_Consent__c();
                        createServiceConsent.Customer__c = Customer_SFID;
                        createServiceConsent.EON_Service_Contact_Consent_Change_Type__c = 'I';
                        if(EON_Utility.validateRequired(consent.ContactMethodType) != true){
                            decimal mType = decimal.valueOf(consent.ContactMethodType);
                            createServiceConsent.Contact_Method_Type__c = mapContactMethodType.get(mType);
                        }
                        if(EON_Utility.validateRequired(consent.ContactMediaID_SFID) != true){
                            EON_Contact_media__c media = mapContactMedia.get(ID.valueof(consent.ContactMediaID_SFID));
                            createServiceConsent.Customer_Media__c = media.ID;
                        }
                        if(EON_Utility.validateRequired(consent.Email) != true)
                            createServiceConsent.Email__c = consent.Email;
                        if(EON_Utility.validateRequired(consent.PhoneCode) != true)
                            createServiceConsent.Phone_Code__c = consent.PhoneCode;
                        if(EON_Utility.validateRequired(consent.PhoneExtension) != true)
                            createServiceConsent.Phone_Extension__c = consent.PhoneExtension;
                        if(EON_Utility.validateRequired(consent.PhoneNumber) != true)
                            createServiceConsent.Phone_Number__c = consent.PhoneNumber;
                        if(EON_Utility.validateRequired(consent.ReferenceID) != true)
                            createEONServiceContactConsent.put(consent.ReferenceID, createServiceConsent);
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Delete)){
            deleteEONServiceContactConsent = new map<String, EON_Service_Contact_Consent__c>();
            try{
                for(EON_Voice_Update_Customer_WS.EONServiceContactConsent serviceContactConsent: ServiceContactConsents){
                    if(EON_Utility.validateRequired(serviceContactConsent.EONServiceContactConsent_SFID) != true){
                        ID eID = ID.valueof(serviceContactConsent.EONServiceContactConsent_SFID);
                        allServiceContactConsentID.add(eID);
                    }
                }
                if(!allServiceContactConsentID.isEmpty()){
                    list<EON_Service_Contact_Consent__c> searchServiceContactConsent = [Select ID, EON_Service_Contact_Consent_Change_Type__c from EON_Service_Contact_Consent__c where ID=:allServiceContactConsentID and EON_Service_Contact_Consent_Change_Type__c != 'D'];           
                    if(!searchServiceContactConsent.isEmpty()){
                        if(searchServiceContactConsent.size() == allServiceContactConsentID.size()){
                            map<ID, EON_Service_Contact_Consent__c> mapScc = new map<ID, EON_Service_Contact_Consent__c>();
                            mapScc.putAll(searchServiceContactConsent);
                            for(EON_Voice_Update_Customer_WS.EONServiceContactConsent serviceContactConsent:ServiceContactConsents){
                                ID recID = ID.valueOf(serviceContactConsent.EONServiceContactConsent_SFID);
                                if(allServiceContactConsentID.contains(recID)){
                                    EON_Service_Contact_Consent__c recEonServiceContactConsent = mapScc.get(recID);
                                    recEonServiceContactConsent.EON_Service_Contact_Consent_Change_Type__c = 'D';
                                    deleteEONServiceContactConsent.put(serviceContactConsent.ReferenceID, recEonServiceContactConsent);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Service Contact Consent does not exist';
                            message.Message = errorMessage;
                            return false;
                        }
                    }
                    else{
                        EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                        message = new EON_Voice_Update_Customer_WS.Message();
                        message.code = eCode.Name;
                        errorMessage = 'EON Service Contact Consent either does not exist or already deleted';
                        message.Message = errorMessage;
                        return false;
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        return true;
    }
    
    /**
        ValidateSiteVulnerability() : This will validate request to create/delete EON Service Contact Consent.
    **/
    public static boolean ValidateSiteVulnerability(list<EON_Voice_Update_Customer_WS.EONSiteVulnerability> EONSiteVulnerabilities, String Customer_SFID, String DMLFlag){
        EON_Utility eonUtility = new EON_Utility();
        list<EON_Customer__c> customer = new list<EON_Customer__c>();
        set<decimal> allVulnerabilityCode = new set<decimal>();
        map<decimal, ID> mapVulnerabilityCode = new map<decimal, ID>();
        set<string> allPremiseID = new set<string>();
        map<string, ID> mapPremiseID = new map<string, ID>();
        set<ID> allSiteVulnerability = new set<ID>();
        //Check unique ReferenceID
        if(EON_Utility.validateRequired(EONSiteVulnerabilities) != true){
            set<String> allReferenceID = new set<String>();
            for(EON_Voice_Update_Customer_WS.EONSiteVulnerability SiteVulnerability:EONSiteVulnerabilities){
                if(EON_Utility.validateRequired(SiteVulnerability.ReferenceID) != true)
                    allReferenceID.add(SiteVulnerability.ReferenceID);
            }
            if(!allReferenceID.isEmpty()){
                if(allReferenceID.size() != EONSiteVulnerabilities.size()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    message.Message = 'ReferenceID should be unique';
                    return false;
                }
            }
            else{
                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = 'ReferenceID should not be blank.';
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Create)){
            createEONSiteVulnerability = new map<String, EON_Site_Vulnerability__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    for(EON_Voice_Update_Customer_WS.EONSiteVulnerability siteVulnerability: EONSiteVulnerabilities){
                        if(EON_Utility.validateRequired(siteVulnerability.VulnerabilityCode) != true)
                            allVulnerabilityCode.add(decimal.valueOf(siteVulnerability.VulnerabilityCode));
                        if(EON_Utility.validateRequired(siteVulnerability.PremiseID) != true)
                            allPremiseID.add(siteVulnerability.PremiseID);
                    }
                    if(allVulnerabilityCode.size()>0){
                        list<EON_Vulnerability_Code__c> searchEONVulnerabilityCode = new list<EON_Vulnerability_Code__c>();
                        searchEONVulnerabilityCode = [Select ID, Vulnerability_Code__c from EON_Vulnerability_Code__c where Vulnerability_Code__c=:allVulnerabilityCode];
                        if(searchEONVulnerabilityCode.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Vulnerability Code does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                            if(searchEONVulnerabilityCode.size() != allVulnerabilityCode.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON Vulnerability Code does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(decimal vCode: allVulnerabilityCode){
                                    for(EON_Vulnerability_Code__c code: searchEONVulnerabilityCode){
                                        if(vCode == code.Vulnerability_Code__c)
                                            mapVulnerabilityCode.put(vCode, code.ID);
                                    }
                                }
                            }
                        }
                    }
                    if(allPremiseID.size()>0){
                        list<EON_Site__c> searchEONSite = [Select ID, Name, address_type__c from EON_Site__c where name=:allPremiseID];
                        if(searchEONSite.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'Premise ID does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                        for(String premiseID: allPremiseID){
                              for(EON_Site__c sID: searchEONSite){
                                  if(sID.Address_Type__c == 'S'){
                                      if(mapPremiseID.containsKey(premiseID)){
                                          EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                            message = new EON_Voice_Update_Customer_WS.Message();
                                            message.code = eCode.Name;
                                            errorMessage = 'Multiple EON sites found with Address Type = S';
                                            message.Message = errorMessage;
                                            return false;
                                    }
                                        else{
                                          if(premiseID == sID.Name)
                                              mapPremiseID.put(premiseID, sID.ID);
                                       }
                                   }
                                }
                            }
                      }
                    }
                    
                    //CH06.Start
                    for(EON_Voice_Update_Customer_WS.EONSiteVulnerability siteVulnerability: EONSiteVulnerabilities){
                        if(EON_Utility.validateRequired(siteVulnerability.VulnerabilityCode) != true && 
                            EON_Utility.validateRequired(siteVulnerability.VulnerabilityTypeID) != true){ 
                            EON_Site_Vulnerability__c[] lstSiteVul = 
                                        [select id from EON_Site_Vulnerability__c 
                                        where Premise__c =:mapPremiseID.get(siteVulnerability.PremiseID)
                                        and Vulnerability_code__c =: mapVulnerabilityCode.get(decimal.valueOf(siteVulnerability.VulnerabilityCode))
                                        and Vulnerability_Type__c =: siteVulnerability.VulnerabilityTypeID];
                                        
                            if(!lstSiteVul.isEmpty()){
                                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                    message = new EON_Voice_Update_Customer_WS.Message();
                                    message.code = eCode.Name;
                                    errorMessage = 'Site Vulnerability already exists for the premise SFID '+ mapPremiseID.get(siteVulnerability.PremiseID);
                                    message.Message = errorMessage;
                                    return false;                            
                            }
                        }                                    
                        
                    }                    
                    //CH06.End
                    
                    for(EON_Voice_Update_Customer_WS.EONSiteVulnerability siteVulnerability: EONSiteVulnerabilities){
                        EON_Site_Vulnerability__c createSiteVulnerability = new EON_Site_Vulnerability__c();
                        createSiteVulnerability.Customer__c = Customer_SFID;
                        createSiteVulnerability.EON_Site_Vulnerability_Change_Type__c = 'I';
                        if(EON_Utility.validateRequired(siteVulnerability.PremiseID) != true)
                            createSiteVulnerability.Premise__c = mapPremiseID.get(siteVulnerability.PremiseID);
                        if(EON_Utility.validateRequired(siteVulnerability.VulnerabilityCode) != true)
                            createSiteVulnerability.Vulnerability_code__c = mapVulnerabilityCode.get(decimal.valueOf(siteVulnerability.VulnerabilityCode));
                        if(EON_Utility.validateRequired(siteVulnerability.VulnerabilityTypeID) != true)
                            createSiteVulnerability.Vulnerability_Type__c = siteVulnerability.VulnerabilityTypeID;
                        createEONSiteVulnerability.put(siteVulnerability.ReferenceID, createSiteVulnerability);
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Delete)){
            deleteEONSiteVulnerability = new map<String, EON_Site_Vulnerability__c>();
            try{
                for(EON_Voice_Update_Customer_WS.EONSiteVulnerability siteVulnerability: EONSiteVulnerabilities){
                    if(EON_Utility.validateRequired(siteVulnerability.Vulnerability_SFID) != true){
                        ID eID = ID.valueof(siteVulnerability.Vulnerability_SFID);
                        allSiteVulnerability.add(eID);
                    }
                }
                if(!allSiteVulnerability.isEmpty()){
                    list<EON_Site_Vulnerability__c> searchSiteVulerability = [Select ID, EON_Site_Vulnerability_Change_Type__c from EON_Site_Vulnerability__c where ID=:allSiteVulnerability and EON_Site_Vulnerability_Change_Type__c != 'D'];           
                    if(!searchSiteVulerability.isEmpty()){
                        if(searchSiteVulerability.size() == allSiteVulnerability.size()){
                            map<ID, EON_Site_Vulnerability__c> mapSV = new map<ID, EON_Site_Vulnerability__c>();
                            mapSV.putAll(searchSiteVulerability);
                            for(EON_Voice_Update_Customer_WS.EONSiteVulnerability siteVulnerability:EONSiteVulnerabilities){
                                if(allSiteVulnerability.contains(siteVulnerability.Vulnerability_SFID)){
                                    EON_Site_Vulnerability__c recEonSiteVulnerability = mapSV.get(siteVulnerability.Vulnerability_SFID);
                                    recEonSiteVulnerability.EON_Site_Vulnerability_Change_Type__c = 'D';
                                    deleteEONSiteVulnerability.put(siteVulnerability.ReferenceID, recEonSiteVulnerability);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Site Vulerability does not exist';
                            message.Message = errorMessage;
                            return false;
                        }
                    }
                    else{
                        EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                        message = new EON_Voice_Update_Customer_WS.Message();
                        message.code = eCode.Name;
                        errorMessage = 'EON Site Vulerability either does not exist or already deleted';
                        message.Message = errorMessage;
                        return false;
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        return true;
    }
    
    /**
        ValidateEligibilityOverride() : This will validate request to create/delete EON Eligibility Override.
    **/
    public static boolean ValidateEligibilityOverride(list<EON_Voice_Update_Customer_WS.EONEligibilityOverride> EligibilityOverrides, String Customer_SFID, String DMLFlag){
        EON_Utility eonUtility = new EON_Utility();
        list<EON_Customer__c> customer = new list<EON_Customer__c>();
        set<String> allPremiseID = new set<String>();
        map<String, ID> mapPremiseID = new map<String, ID>();
        set<Decimal> allEligibilityCode = new set<Decimal>();
        map<Decimal, ID> mapEligibilityCode = new map<Decimal, ID>();
        set<ID> allEligibilityOverride = new set<ID>();
        //Check unique ReferenceID
        if(EON_Utility.validateRequired(EligibilityOverrides) != true){
            set<String> allReferenceID = new set<String>();
            for(EON_Voice_Update_Customer_WS.EONEligibilityOverride EligibilityOverride:EligibilityOverrides){
                if(EON_Utility.validateRequired(EligibilityOverride.ReferenceID) != true)
                    allReferenceID.add(EligibilityOverride.ReferenceID);
            }
            if(!allReferenceID.isEmpty()){
                if(allReferenceID.size() != EligibilityOverrides.size()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    message.Message = 'ReferenceID should be unique';
                    return false;
                }
            }
            else{
                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = 'ReferenceID should not be blank.';
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Create)){
            createEligibilityOverride = new map<String, EON_Eligibility_Override__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    for(EON_Voice_Update_Customer_WS.EONEligibilityOverride EligibilityOverride: EligibilityOverrides){
                        if(EON_Utility.validateRequired(EligibilityOverride.PremiseID) != true)
                            allPremiseID.add(EligibilityOverride.PremiseID);
                        if(EON_Utility.validateRequired(EligibilityOverride.EligibilityCode) != true)
                            allEligibilityCode.add(decimal.valueOf(EligibilityOverride.EligibilityCode));
                    }
                    if(allPremiseID.size()>0){
                        list<EON_Site__c> searchEONSite = [Select ID, Name from EON_Site__c where Name=:allPremiseID and address_type__c='S'];
                        if(searchEONSite.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Site does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                            if(searchEONSite.size() != allPremiseID.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON Site does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(String premiseID: allPremiseID){
                                    for(EON_Site__c eSite: searchEONSite){
                                        if(premiseID == eSite.Name)
                                            mapPremiseID.put(premiseID, eSite.ID);
                                    }
                                }
                            }
                        }
                    }
                    if(allEligibilityCode.size()>0){
                        list<EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c> searchEONOverrideableEligibility = [Select ID, Name, Opt_Out_ID__c from EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c where Opt_Out_ID__c=:allEligibilityCode];
                        if(searchEONOverrideableEligibility.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Overrideable Eligibility does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                            if(searchEONOverrideableEligibility.size() != allEligibilityCode.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON Overrideable Eligibility does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(Decimal eligibilityCode: allEligibilityCode){
                                    for(EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c eOverrideableEligibility: searchEONOverrideableEligibility){
                                        if(eligibilityCode == eOverrideableEligibility.Opt_Out_ID__c)
                                            mapEligibilityCode.put(eligibilityCode, eOverrideableEligibility.ID);
                                    }
                                }
                            }
                        }
                    }
                    for(EON_Voice_Update_Customer_WS.EONEligibilityOverride EligibilityOverride: EligibilityOverrides){
                        EON_Eligibility_Override__c createEligibilityOver = new EON_Eligibility_Override__c();
                        createEligibilityOver.Customer__c = Customer_SFID;
                        createEligibilityOver.Eligibility_Change_Type__c = 'I';
                        if(EON_Utility.validateRequired(EligibilityOverride.EligibilityCode) != true)
                            createEligibilityOver.Eligibility_Code__c = mapEligibilityCode.get(Decimal.valueOf(EligibilityOverride.EligibilityCode));
                        if(EON_Utility.validateRequired(EligibilityOverride.EquipmentType) != true)
                            createEligibilityOver.Equipment_Type__c = EligibilityOverride.EquipmentType;
                        if(EON_Utility.validateRequired(EligibilityOverride.PremiseID) != true)
                            createEligibilityOver.Premise__c = mapPremiseID.get(EligibilityOverride.PremiseID);
                        createEligibilityOverride.put(EligibilityOverride.ReferenceID, createEligibilityOver);
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Delete)){
            deleteEligibilityOverride = new map<String, EON_Eligibility_Override__c>();
            try{
                for(EON_Voice_Update_Customer_WS.EONEligibilityOverride eOverride:EligibilityOverrides){
                    if(EON_Utility.validateRequired(eOverride.EONEligibilityOverride_SFID) != true){
                        ID eID = ID.valueof(eOverride.EONEligibilityOverride_SFID);
                        allEligibilityOverride.add(eID);
                    }
                }
                if(!allEligibilityOverride.isEmpty()){
                    list<EON_Eligibility_Override__c> searchEligibilityOverride = [Select ID from EON_Eligibility_Override__c where ID=:allEligibilityOverride and Eligibility_Change_Type__c != 'D'];
                    if(!searchEligibilityOverride.isEmpty()){
                        if(searchEligibilityOverride.size() == allEligibilityOverride.size()){
                            map<ID, EON_Eligibility_Override__c> mapEO = new map<ID, EON_Eligibility_Override__c>();//();
                            mapEO.putAll(searchEligibilityOverride);
                            for(EON_Voice_Update_Customer_WS.EONEligibilityOverride eOverride:EligibilityOverrides){
                                if(allEligibilityOverride.contains(eOverride.EONEligibilityOverride_SFID)){
                                    EON_Eligibility_Override__c recEonEligibilityOverride = mapEO.get(eOverride.EONEligibilityOverride_SFID);
                                    recEonEligibilityOverride.Eligibility_Change_Type__c = 'D';
                                    deleteEligibilityOverride.put(eOverride.ReferenceID, recEonEligibilityOverride);
                                }
                            }
                        }
                        else{
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Eligibility Override does not exist';
                            message.Message = errorMessage;
                            return false;
                        }
                    }
                    else{
                        EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                        message = new EON_Voice_Update_Customer_WS.Message();
                        message.code = eCode.Name;
                        errorMessage = 'EON Eligibility Override either does not exist or already deleted';
                        message.Message = errorMessage;
                        return false;
                    }
                }
            }
            catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        return true;
    }
    
    /**
        ValidateSite() : This will validate request to update EON Site records.
    **/
    public static boolean ValidateSite(list<EON_Voice_Update_Customer_WS.EONSite> Sites, String Customer_SFID, String DMLFlag){
        EON_Utility eonUtility = new EON_Utility();
        list<EON_Customer__c> customer = new list<EON_Customer__c>();
        set<String> allPremiseID = new set<String>();
        map<ID, EON_Site__c> mapSite;
        map<String, EON_Site__c> searchSite = new map<String, EON_Site__c>();
        set<Decimal> allCountyID = new set<Decimal>();
        map<Decimal, ID> mapCounty = new map<Decimal, ID>();
        set<Decimal> allCountryID = new set<Decimal>();
        map<Decimal, ID> mapCountry = new map<Decimal, ID>(); 
        //Check unique ReferenceID
        if(EON_Utility.validateRequired(Sites) != true){
            set<String> allReferenceID = new set<String>();
            for(EON_Voice_Update_Customer_WS.EONSite EONSite:Sites){
                if(EON_Utility.validateRequired(EONSite.ReferenceID) != true)
                    allReferenceID.add(EONSite.ReferenceID);
            }
            if(!allReferenceID.isEmpty()){
                if(allReferenceID.size() != Sites.size()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    message.Message = 'ReferenceID should be unique';
                    return false;
                }
            }
            else{
                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = 'ReferenceID should not be blank.';
                return false;
            }
        }
        if(DMLFlag.equalsIgnoreCase(EON_Utility.Op_VOICE_Update)){
            updateSite = new map<String, EON_Site__c>();
            try{
                //Validate Customer SFID
                ID customerID = id.valueof(Customer_SFID);
                customer = [Select ID from EON_Customer__c where ID=:customerID and Eon_Customer_Change_Type__c != 'D'];
                if(customer.isEmpty()){
                    EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                    message = new EON_Voice_Update_Customer_WS.Message();
                    message.code = eCode.Name;
                    errorMessage = 'No Customer exist';
                    message.Message = errorMessage;
                    return false;
                }
                else{
                    for(EON_Voice_Update_Customer_WS.EONSite site:Sites){
                        if(EON_Utility.validateRequired(site.PremiseID) != true)
                            allPremiseID.add(site.PremiseID);
                        if(EON_Utility.validateRequired(site.CountyId) != true)
                            allCountyID.add(Decimal.valueOf(site.CountyId));
                        if(EON_Utility.validateRequired(site.CountryId) != true)
                            allCountryID.add(Decimal.valueOf(site.CountryId));
                    }
                    if(allPremiseID.size()>0){
                        mapSite = new map<ID, EON_Site__c>([Select ID, Name, Address_Type__c, Building_Name__c,Building_Number__c, Sub_Building_Name__c, Town__c, Dependant_Locality__c, Double_Dependant_Locality__c, Thorofare__c, Dependant_Thorofare__c, County__c, Country__c, Parent_Premise_ID__c from EON_Site__c where Name=:allPremiseID and Customer__c=:customerID and Address_Type__c = 'C']);                  
                        if(mapSite.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Site does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                            if(mapSite.size() != allPremiseID.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'One or more EON Site exist with PremiseID.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(EON_Site__c eSite:mapSite.values()){
                                  searchSite.put(eSite.Name, eSite);
                                }
                            }
                        }
                    }
                    if(allCountyID.size()>0){
                        list<EON_County__c> allCounty = [Select ID, County_ID__C from EON_County__c where County_ID__C=:allCountyID];
                        if(allCounty.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON County does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                            if(allCounty.size() != allCountyID.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON County does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(Decimal CountyID: allCountyID){
                                    for(EON_County__c county: allCounty){
                                        if(CountyID == county.County_ID__C)
                                            mapCounty.put(CountyID, county.ID);
                                    }
                                }
                            }
                        }
                    }
                    if(allCountryID.size()>0){
                        list<EON_Country__c> allCountry = [Select ID, Country_ID__C from EON_Country__c where Country_ID__C=:allCountryID];
                        if(allCountry.isEmpty()){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                            message = new EON_Voice_Update_Customer_WS.Message();
                            message.code = eCode.Name;
                            errorMessage = 'EON Country does not exist.';
                            message.Message = errorMessage;
                            return false;
                        }
                        else{
                            if(allCountry.size() != allCountryID.size()){
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('CustomError');
                                message = new EON_Voice_Update_Customer_WS.Message();
                                message.code = eCode.Name;
                                errorMessage = 'EON Country does not exist.';
                                message.Message = errorMessage;
                                return false;
                            }
                            else{
                                for(Decimal CountryID: allCountryID){
                                    for(EON_Country__c country: allCountry){
                                        if(CountryID == country.Country_ID__C)
                                            mapCountry.put(CountryID, country.ID);
                                    }
                                }
                            }
                        }
                    }
                    for(EON_Voice_Update_Customer_WS.EONSite s:Sites){
                        EON_Site__c updateEONSite = searchSite.get(s.PremiseID);
                        if(EON_Utility.validateRequired(s.AddressType) != true){
                            String addressType = s.AddressType;
                            updateEONSite.Address_Type__c = addressType.capitalize();
                        }
                        if(EON_Utility.validateRequired(s.BuildingName) != true)                       
                            updateEONSite.Building_Name__c = s.BuildingName;
                        if(EON_Utility.validateRequired(s.Building_Number) != true)
                            updateEONSite.Building_Number__c = s.Building_Number;
                        if(EON_Utility.validateRequired(s.CountryId) != true)
                            updateEONSite.Country__c = mapCountry.get(decimal.valueOf(s.CountryId));
                        if(EON_Utility.validateRequired(s.CountyId) != true)
                            updateEONSite.County__c = mapCounty.get(decimal.valueOf(s.CountyId));
                        if(EON_Utility.validateRequired(s.DependantLocality) != true)
                            updateEONSite.Dependant_Locality__c = s.DependantLocality;
                        if(EON_Utility.validateRequired(s.DoubleDependantLocality) != true)
                            updateEONSite.Double_Dependant_Locality__c = s.DoubleDependantLocality;
                        if(EON_Utility.validateRequired(s.DependantThorofare) != true)
                            updateEONSite.Dependant_Thorofare__c = s.DependantThorofare;
                        if(EON_Utility.validateRequired(s.DoubleDependantLocality) != true)
                            updateEONSite.Double_Dependant_Locality__c = s.DoubleDependantLocality;
                        updateEONSite.EON_Site_Change_Type__c = 'U';
                        if(EON_Utility.validateRequired(s.Postcode) != true)
                            updateEONSite.Postcode__c = s.Postcode;
                        if(EON_Utility.validateRequired(s.SubBuildingName) != true)
                            updateEONSite.Sub_Building_Name__c = s.SubBuildingName;
                        if(EON_Utility.validateRequired(s.Thorofare) != true)
                            updateEONSite.Thorofare__c = s.Thorofare;
                        if(EON_Utility.validateRequired(s.Town) != true)
                            updateEONSite.Town__c = s.Town;
                        updateSite.put(s.ReferenceID, updateEONSite);
                    }
                }
            }
            Catch(Exception ex){
                EON_Voice_Update_Customer_WS_Helper.errorMessage = ex.getMessage()+'\n'+ex.getStackTraceString();
                EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                message = new EON_Voice_Update_Customer_WS.Message();
                message.code = eCode.Name;
                message.Message = eCode.Description__c;
                return false;
            }
        }
        return true;
    }
    
    /**
        getAllMessages() : This is generic method to form messages to return using EON Error Code
    **/
    public static list<EON_Voice_Update_Customer_WS.Message> getAllMessages(EON_Error_Code__c code){
        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
        EON_Error_Code__c msgCode = code;
        EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
        msg.code = msgCode.Name;
        msg.Message = msgCode.Description__c;
        allMsg.add(msg);
        return allMsg;
    }
    /**
        updateVoiceDataTracker() : This is generic method to create Voice Data Tracker
    **/
    Public static Voice_Data_Tracker__c updateVoiceDataTracker(Object Request, object Response, String Status, String Error, EON_Error_Code__c ErrorCode){
        Voice_Data_Tracker__c tracker = new Voice_Data_Tracker__c();
        tracker.Command__c = EON_Utility.CMD_VOICE_CustomerContact;
        tracker.Direction__c = EON_Utility.DIRECTION_IN;
        tracker.Request_Data__c = String.valueOf(Request);
        tracker.Response_Data__c = String.valueOf(Response);
        tracker.Status__c = Status;
        tracker.Error__c = Error;
        if(ErrorCode != null)
            tracker.EON_Error_Code__c = ErrorCode.ID;
        insert tracker;
        return tracker;
    }
}