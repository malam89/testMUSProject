/**
    Description : This class be used to generate WSDL to share with VOICE. They will use this class to permform DML at below list of objects
                    EON Customer - Update
                    EON Contact Outcomes - Create
                    EON Contact Media - Create, Update, Delete
                    EON Contact Representative - Create, Update, Delete
                    EON Opt In Opt Out Preference - Create, Delete 
                    EON Service Contact Consent - Create, Delete
                    EON Site Vulnerability - Create, Delete 
                    EON Eligibility Override - Create, Delete
                    EON Site - Update
                  
    VF Page     : NA
    Test Class  : EON_Voice_Update_Customer_WS_Test 

**/
/*
    Created By  : Mahadev Joshilkar
    Created On  : 11/03/2016
    Service Req : SR_EON_PC_008
    Change History : 
    CH01 # Kondal # 21-03-2016 # SR_EON_PC_011 # Updated the name Representative Role Types to EON ROLE TYPES (REPRESENTATIVE)
    CH02 # 28-03-2016 # Kondal # SR_EON_PC_019 # Changed label name from EON Op-Out Reason to EON Opt-Out Reason
    CH03 # 28-03-2016 # Purvi # SR_EON_PC_016 # Changed API name of some objects.
    CH04 # 04-04-2016 # Mahadev # SR_EON_PC_022 # Renamed or deleted Fields at EON Site
    CH05 # 05/04/2016 # Mahadev # SR_EON_PC_024 # Changed business logic to based upon field 'Change Type' at every object.
                                                  Object 'EON Complaint & EON Complaint Contact will not be updated.
    CH06 # 04-04-2016 # Vinod # SR_EON_PC_030 # Renamed as EON Customer Contact Outcome
                                                Changed the Is preferred contact method? from checkbox to picklist 
    CH07 # 16/05/2016 # Shivram Survase # SR_EON_PC_053 # Removed 'ContactMedia' field from class as 'Contact Media' field is Deleted at 'EON Contact Media' object 
                                                         and Changed field from 'ContactMethod' to 'ContactMediaID' in the class as Renamed Name field from 'Contact Method' to 'Contact Media ID' at 'EON Contact Media' object .
    CH08 # 19/05/2016 # Tashika Gupta # SR_EON_PC_055 #  Changed the logic as per SR Requirement.
    CH09 # 23/05/2016 # Mahadev J # SR_EON_PC_058 # Major change in request and response structure and validation in WSDL processing logic.
    CH10 # 13/06/2016 # Mahadev J # SR_EON_PC_069 # Addtional validations for objects EON Service Contact Consent, EON Site and EON Opt In/Opt Out Preference. 
    CH11 # 24/06/2016 # Mahadev J # SR_EON_PC_076 # WSDL structure changed with new specifications.
*/
    
global with sharing class EON_Voice_Update_Customer_WS
{
    global with sharing class EONCustomer{
        Webservice String ReferenceID;
        Webservice String Customer_SFID;
        Webservice String Customer_ID;
        Webservice String CustomerPAYGInterest;         
        Webservice String SmartInterest;
    }
    /**
        Description : Request Parameter: List Of EON Customer
    **/
    global with sharing class EONCustomers{
        Webservice EONCustomer[] EONCustomer;
    }
    
    global with sharing class EONCustomerContactOutcome{
        Webservice String ReferenceID;
        Webservice String ContactOutcome_SFID;
        Webservice String AttemptedContactMethodCode;               
        WebService String ContactOutcomeCode;                       
        Webservice Date DateOfContact;
        Webservice String FulfilmentCode;                           
        Webservice String ContactOutcomeDescription;                
    }
    /**
        Description: Request Paramter: List of EOn Contact Outcome
    **/
    global with sharing class EONCustomerContactOutcomes{
        Webservice String Customer_SFID;
        Webservice EONCustomerContactOutcome[] EONCustomerContactOutcome;
    }
    
    global with sharing class EONContactMedium{
        Webservice String ReferenceID;
        Webservice String ContactMedia_SFID; 
        Webservice String ContactMediaID;     
        Webservice String ContactMethodType;         
        Webservice String Email;
        WebService String IsPreferredContactMethod;   
        Webservice String PhoneCode;
        Webservice String PhoneExtension;
        Webservice String PhoneNumber;
        Webservice String Representative_SFID;
        Webservice String Representative; 
    }
    /**
        Description: Request Paramter: List of EON Contact Medium
    **/
    global with sharing class EONContactMedia{
        Webservice String Customer_SFID;
        Webservice EONContactMedium[] EONContactMedium;           
    }
    
    global with sharing class EONContactRepresentative{
        Webservice String ReferenceID;
        Webservice String ContactRepresentative_SFID;
        WebService String ContactName;
        WebService String RepresentativeID;
        WebService String RoleType;
    }
    /**
        Description: Request Paramter: List of EON Contact Representative
    **/
    global with sharing class EONContactRepresentatives{
        Webservice String Customer_SFID;
        Webservice EONContactRepresentative[] EONContactRepresentative;       
    }
    
    global with sharing class EONOptInOptOutPreference{
        Webservice String ReferenceID;
        Webservice String EONOptInOptOutPreference_SFID;
        Webservice String OptInOptOutPreference;       
        Webservice String OptOutReasonCode;             
        Webservice String PremiseID;                    
        Webservice String Premise_SFID;
    }
    /**
        Description: Request Paramter: List of EON Opt In Opt Out Preference
    **/
    global with sharing class EONOptInOptOutPreferences{
        Webservice String Customer_SFID;
        Webservice EONOptInOptOutPreference[] EONOptInOptOutPreference;       
    }
    
    global with sharing class EONServiceContactConsent{
        Webservice String ReferenceID;
        Webservice String EONServiceContactConsent_SFID;
        Webservice String ContactMethodType;            
        Webservice String ContactMediaID;                   
        Webservice String ContactMediaID_SFID;          
        Webservice String Email;
        Webservice String PhoneCode;
        Webservice String PhoneExtension;
        Webservice String PhoneNumber;
    }
    /**
        Description: Request Paramter: List of EON Service Contact Consent
    **/
    global with sharing class EONServiceContactConsents{
        Webservice String Customer_SFID;
        Webservice EONServiceContactConsent[] EONServiceContactConsent;       
    }
    
    global with sharing class EONSiteVulnerability{
        Webservice String ReferenceID;
        Webservice String Vulnerability_SFID;
        Webservice String VulnerabilityCode;   
        Webservice String VulnerabilityTypeID; 
        Webservice String Premise_SFID;
        Webservice String PremiseID;            
    }
    /**
        Description: Request Paramter: List of EON Site Vulnerability
    **/
    global with sharing class EONSiteVulnerabilities{
        Webservice String Customer_SFID;
        Webservice EONSiteVulnerability[] EONSiteVulnerability;       
    }
    
    global with sharing class EONEligibilityOverride{
        Webservice String ReferenceID;
        Webservice String EONEligibilityOverride_SFID;
        Webservice String Premise_SFID;
        Webservice String PremiseID;
        Webservice String EligibilityCode;
        Webservice String EquipmentType;
    }
    /**
        Description: Request Paramter: List of EON Eligibility Override
    **/
    global with sharing class EONEligibilityOverrides{
        Webservice String Customer_SFID;
        Webservice EONEligibilityOverride[] EONEligibilityOverride;       
    }
    
    global with sharing class EONSite{
        Webservice String ReferenceID;
        Webservice string Premise_SFID;
        Webservice String PremiseID;
        Webservice String Building_Number;
        Webservice String SubBuildingName;
        Webservice String BuildingName;
        Webservice String Town;
        Webservice String DependantLocality;
        Webservice String DoubleDependantLocality;
        Webservice String Thorofare;
        Webservice String DependantThorofare;
        Webservice String CountyId;
        Webservice String CountryId;
        Webservice String Postcode;
        Webservice String AddressType;
    }
    /**
        Description: Request Paramter: List of EON Site
    **/
    global with sharing class EONSites{
        Webservice String Customer_SFID;
        Webservice EONSite[] EONSite;       
    }
    
    global with sharing class EONCustomerContact{
        Webservice String ReferenceID;
        Webservice String SalesforceID;
    }
    /**
        Description : Response Paramter
    **/
    global with sharing class EONCustomerContacts{
        Webservice EONCustomerContact[] EONCustomerContact;
    }
    
    global with sharing class Message{
        Webservice String Code;             
        Webservice String Message;
    }
    /**
        Description : Response Parameter
    **/
    global with sharing class Messages{
        Webservice Message[] Message;
    }
    /**
        Description : Main Response Parameter
    **/
    global with sharing class EONCustomerContactResults{
        Webservice EONCustomerContacts EONCustomerContacts;
        Webservice String VoiceDataTrackerID;
        Webservice Messages Messages;
        Webservice String Status;
    }
    /**
        Description : UPDATE - EON Customer
    **/
    webservice static EONCustomerContactResults UpdateEONCustomer(EONCustomers EONCustomers){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        
        list<String> allCustomerSFID = new list<String>();
        list<String> allCustomerPAYGInterestName = new list<String>();
        
        EONCustomerContactResults response = new EONCustomerContactResults();
        list<EON_Voice_Update_Customer_WS.EONCustomer> allCustomer = new list<EON_Voice_Update_Customer_WS.EONCustomer>();
        if(EON_Utility.validateRequired(EONCustomers) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            allCustomer = EONCustomers.EONCustomer;
            if(EON_Utility.validateRequired(allCustomer) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateCustomer(allCustomer, EON_Utility.Op_VOICE_Update);
                if(validate){
                    list<EON_Customer__c> updateCustomer = EON_Voice_Update_Customer_WS_Helper.updateCustomer;
                    try{
                        if(!updateCustomer.isEmpty())
                            update updateCustomer;
                        EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                        allEonCustomerContacts.EONCustomerContact = EON_Voice_Update_Customer_WS_Helper.updateEONCustomerContacts;
                        response.EONCustomerContacts = allEonCustomerContacts;
                        response.Status = EON_Utility.RESULT_PASS;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONCustomers, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        if(EON_Utility.genException == true) //Generate Exception
                            ID testID = ID.valueOf('incorrect');
                        update tracker;
                    }
                    catch(System.DmlException ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                            EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                        	msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                        }
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONCustomers, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                    catch(Exception ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONCustomers, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONCustomers, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Create - EON Contact Outcomes
    **/
    webservice static EONCustomerContactResults CreateEONContactOutcome(EONCustomerContactOutcomes EONCustomerContactOutcomes){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        
        if(EON_Utility.validateRequired(EONCustomerContactOutcomes) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            list<EON_Voice_Update_Customer_WS.EONCustomerContactOutcome> CustomerContactOutcomes = EONCustomerContactOutcomes.EONCustomerContactOutcome;
            if(EON_Utility.validateRequired(CustomerContactOutcomes) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateCustomerContactOutcome(CustomerContactOutcomes, EONCustomerContactOutcomes.Customer_SFID, EON_Utility.Op_VOICE_Create);
                if(validate){
                    map<String, EON_Customer_Contact_Outcome__c> createCustomerContactOutcome = EON_Voice_Update_Customer_WS_Helper.createCustomerContactOutcome;
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(createCustomerContactOutcome.keySet());
                        if(!createCustomerContactOutcome.isEmpty()){
                            list<EON_Customer_Contact_Outcome__c> dmlCreateCustomerContactOutcome = createCustomerContactOutcome.values();
                            insert dmlCreateCustomerContactOutcome;
                            integer i = 0;
                            for(EON_Customer_Contact_Outcome__c ContactOutcome: dmlCreateCustomerContactOutcome){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = ContactOutcome.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONCustomerContactOutcomes, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            if(!EON_Utility.validateRequired(EONCustomerContactOutcomes.Customer_SFID))
                            	tracker.EON_Customer__c =EONCustomerContactOutcomes.Customer_SFID; 
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                             if(EON_Utility.genException) //Generate Exception
                                ID test = ID.valueof('incorrect');
                        }
                    }
                    catch(System.DmlException ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                            EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                        	msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                        }
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONCustomerContactOutcomes, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                    catch(Exception ex){

                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONCustomerContactOutcomes, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONCustomerContactOutcomes, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Create - EON Contact Media
    **/
    webservice static EONCustomerContactResults CreateEONContactMedium(EONContactMedia EONContactMedia){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONContactMedia) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            list<EON_Voice_Update_Customer_WS.EONContactMedium> contactMedium = EONContactMedia.EONContactMedium;
            if(EON_Utility.validateRequired(contactMedium) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateContactMedia(contactMedium, EONContactMedia.Customer_SFID, EON_Utility.Op_VOICE_Create);
                if(validate){
                    map<String, EON_Contact_media__c> createContactMedium = EON_Voice_Update_Customer_WS_Helper.createEONContactMedia;
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(createContactMedium.keySet());
                        if(!createContactMedium.isEmpty()){
                            list<EON_Contact_media__c> dmlCreateContactMedia = createContactMedium.values();
                            insert dmlCreateContactMedia;
                            integer i = 0;
                            for(EON_Contact_media__c conMedia: dmlCreateContactMedia){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = conMedia.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            if(EON_Utility.genException) //Generate Exception
                                ID test = ID.valueof('incorrect');
                        }
                    }
                    catch(System.DmlException ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                            EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                        	msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                        }
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                    catch(Exception ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Update - EON Contact Media
    **/
    webservice static EONCustomerContactResults UpdateEONContactMedium(EONContactMedia EONContactMedia){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONContactMedia) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            list<EON_Voice_Update_Customer_WS.EONContactMedium> contactMedia = new list<EON_Voice_Update_Customer_WS.EONContactMedium>();
            contactMedia = EONContactMedia.EONContactMedium;
            if(EON_Utility.validateRequired(contactMedia) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateContactMedia(contactMedia, EONContactMedia.Customer_SFID, EON_Utility.Op_VOICE_Update);
                if(validate){
                    map<String, EON_Contact_media__c> updateContactMedia = new map<String, EON_Contact_media__c>();
                    updateContactMedia = EON_Voice_Update_Customer_WS_Helper.updateEONContactMedia; 
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(updateContactMedia.keySet());
                        if(!updateContactMedia.isEmpty()){
                            list<EON_Contact_media__c> dmlUpdateContactMedia = updateContactMedia.values();
                            update dmlUpdateContactMedia;
                            integer i = 0;
                            for(EON_Contact_media__c conMed: dmlUpdateContactMedia){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = conMed.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            if(EON_Utility.genException) //Generate Exception
                                ID test = ID.valueof('incorrect');
                        }
                    }
                    catch(System.DmlException ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                            EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                        	msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                        }
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                    catch(Exception ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Delete - EON Contact Media
    **/
    webservice static EONCustomerContactResults DeleteEONContactMedium(EONCustomerContacts EONContactMedia){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONContactMedia) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            if(EON_Voice_Update_Customer_WS_Helper.genException == null)
                EON_Voice_Update_Customer_WS_Helper.genException = false;
            list<EON_Voice_Update_Customer_WS.EONCustomerContact> allCustomerContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
            allCustomerContact = EONContactMedia.EONCustomerContact;
            list<EON_Voice_Update_Customer_WS.EONContactMedium> allContactMedia = new list<EON_Voice_Update_Customer_WS.EONContactMedium>();
            if(EON_Utility.validateRequired(allCustomerContact) != true){
                for(EON_Voice_Update_Customer_WS.EONCustomerContact contact: allCustomerContact){
                    EON_Voice_Update_Customer_WS.EONContactMedium contactMedium = new EON_Voice_Update_Customer_WS.EONContactMedium();
                    contactMedium.ReferenceID = contact.ReferenceID;
                    contactMedium.ContactMedia_SFID = contact.SalesforceID;
                    allContactMedia.add(contactMedium);
                }
                if(EON_Utility.validateRequired(allContactMedia) != true){
                    boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateContactMedia(allContactMedia, '', EON_Utility.Op_VOICE_Delete);
                    if(validate){
                        map<String, EON_Contact_media__c> deleteContactMedia = EON_Voice_Update_Customer_WS_Helper.updateEONContactMedia;                        
                        try{
                            if(!deleteContactMedia.isEmpty()){
                                list<String> allRefID = new list<String>(); 
                                allRefID.addAll(deleteContactMedia.keySet());
                                list<EON_Contact_media__c> dmlContactMedia = deleteContactMedia.values();
                                update dmlContactMedia;
                                integer i = 0;
                                for(EON_Contact_media__c ContactMedia: dmlContactMedia){
                                    EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                    custContact.ReferenceID = allRefID[i];
                                    custContact.SalesforceID = ContactMedia.Id;
                                    customerContacts.add(custContact);
                                    i++;
                                }
                                EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                                allEonCustomerContacts.EONCustomerContact = customerContacts;
                                
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                                allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                                response.EONCustomerContacts = allEonCustomerContacts;
                                response.Status = EON_Utility.RESULT_PASS;
                                response.Messages = allMessages;
                                Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                                response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                                tracker.Response_Data__c = String.valueOf(response);
                                if(EON_Utility.genException) //Generate Exception
                                    tracker.Command__c = 'TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest';
                                update tracker;
                                if(EON_Voice_Update_Customer_WS_Helper.genException) //Generate exception
                                	ID test = ID.valueof('incorrect');
                            }
                        }
                        catch(System.DmlException ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                            for(Integer i=0; i<ex.getNumDml(); i++){
                                EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                                msg.code = eCode.Name;
                                msg.Message = ex.getDmlMessage(i);
                                allMsg.add(msg);
                            }
                            allMessages.Message = allMsg;
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                    	}
                        catch(Exception ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                    }
                    else{
                        EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                        Msgs.add(eMsg);
                        allMessages.Message = Msgs;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactMedia, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                    }
                }
            }
        }
        return response;
    }
    /**
        Description : Create - EON Contact Representative
    **/
    webservice static EONCustomerContactResults CreateEONContactRepresentative(EONContactRepresentatives EONContactRepresentatives){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONContactRepresentatives) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            list<EON_Voice_Update_Customer_WS.EONContactRepresentative> contactRepresentative = EONContactRepresentatives.EONContactRepresentative;
            if(EON_Utility.validateRequired(contactRepresentative) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateContactRepresentative(contactRepresentative, EONContactRepresentatives.Customer_SFID, EON_Utility.Op_VOICE_Create);
                if(validate){
                    map<String, EON_Contact_representative__c> createContactRepresentative = EON_Voice_Update_Customer_WS_Helper.createEONContactRepresentative;
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(createContactRepresentative.keySet());
                        if(!createContactRepresentative.isEmpty()){
                            list<EON_Contact_representative__c> dmlCreateContactRepresentative = createContactRepresentative.values();
                            insert dmlCreateContactRepresentative;
                            integer i = 0;
                            for(EON_Contact_representative__c conRep: dmlCreateContactRepresentative){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = conRep.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            if(EON_Utility.genException)  //Generate exception
                                ID test = ID.valueof('incorrect');
                        }
                    }
                    catch(System.DmlException ex){
                    	EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                        	EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                            msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                      	}
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                   	}
                    catch(Exception ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Update - EON Contact Representative
    **/
    webservice static EONCustomerContactResults UpdateEONContactRepresentative(EONContactRepresentatives EONContactRepresentatives){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONContactRepresentatives) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            list<EON_Voice_Update_Customer_WS.EONContactRepresentative> contactRepresentative = new list<EON_Voice_Update_Customer_WS.EONContactRepresentative>();
            contactRepresentative = EONContactRepresentatives.EONContactRepresentative;
            if(EON_Utility.validateRequired(contactRepresentative) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateContactRepresentative(contactRepresentative, EONContactRepresentatives.Customer_SFID, EON_Utility.Op_VOICE_Update);
                if(validate){
                    map<String, EON_Contact_representative__c> updateContactRepresentative = EON_Voice_Update_Customer_WS_Helper.updateEONContactRepresentative;
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(updateContactRepresentative.keySet());
                        if(!updateContactRepresentative.isEmpty()){
                            list<EON_Contact_representative__c> dmlUpdateContactRepresentative = updateContactRepresentative.values();
                            update dmlUpdateContactRepresentative;
                            integer i = 0;
                            for(EON_Contact_representative__c conRep: dmlUpdateContactRepresentative){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = conRep.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            if(EON_Utility.genException)  //Generate exception
                                ID test = ID.valueof('incorrect');
                        }
                    }
                    catch(System.DmlException ex){
                    	EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                        	EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                            msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                      	}
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                   	}
                    catch(Exception ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Delete - EON Contact Representative
    **/
    webservice static EONCustomerContactResults DeleteEONContactRepresentative(EONCustomerContacts EONContactRepresentatives){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONContactRepresentatives) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            if(EON_Voice_Update_Customer_WS_Helper.genException == null)
                EON_Voice_Update_Customer_WS_Helper.genException = false;
            list<EON_Voice_Update_Customer_WS.EONCustomerContact> allCustomerContact = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
            allCustomerContact = EONContactRepresentatives.EONCustomerContact;
            list<EON_Voice_Update_Customer_WS.EONContactRepresentative> allContactRepresentative = new list<EON_Voice_Update_Customer_WS.EONContactRepresentative>();
            if(EON_Utility.validateRequired(allCustomerContact) != true){
                for(EON_Voice_Update_Customer_WS.EONCustomerContact contact: allCustomerContact){
                    EON_Voice_Update_Customer_WS.EONContactRepresentative contactRepresentative = new EON_Voice_Update_Customer_WS.EONContactRepresentative();
                    contactRepresentative.ReferenceID = contact.ReferenceID;
                    contactRepresentative.ContactRepresentative_SFID = contact.SalesforceID;
                    allContactRepresentative.add(contactRepresentative);
                }
                if(EON_Utility.validateRequired(allContactRepresentative) != true){
                    boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateContactRepresentative(allContactRepresentative, '', EON_Utility.Op_VOICE_Delete);
                    if(validate){
                        map<String, EON_Contact_representative__c> deleteContactRepresentative = EON_Voice_Update_Customer_WS_Helper.updateEONContactRepresentative;                        
                        try{
                            if(!deleteContactRepresentative.isEmpty()){
                                list<String> allRefID = new list<String>(); 
                                allRefID.addAll(deleteContactRepresentative.keySet());
                                list<EON_Contact_representative__c> dmlContactRepresentative = deleteContactRepresentative.values();
                                update dmlContactRepresentative;
                                integer i = 0;
                                for(EON_Contact_representative__c ContactRepresentative: dmlContactRepresentative){
                                    EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                    custContact.ReferenceID = allRefID[i];
                                    custContact.SalesforceID = ContactRepresentative.Id;
                                    customerContacts.add(custContact);
                                    i++;
                                }
                                EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                                allEonCustomerContacts.EONCustomerContact = customerContacts;
                                
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                                allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                                response.EONCustomerContacts = allEonCustomerContacts;
                                response.Status = EON_Utility.RESULT_PASS;
                                response.Messages = allMessages;
                                Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                                response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                                tracker.Response_Data__c = String.valueOf(response);
                                if(EON_Utility.genException) //Generate Exception
                                    tracker.Command__c = 'TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest';
                                update tracker;
                                if(EON_Voice_Update_Customer_WS_Helper.genException) //Generate Exception
                                    ID test = ID.valueOf('incorrect');
                            }
                        }
                        catch(System.DmlException ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                            for(Integer i=0; i<ex.getNumDml(); i++){
                                EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                                msg.code = eCode.Name;
                                msg.Message = ex.getDmlMessage(i);
                                allMsg.add(msg);
                            }
                            allMessages.Message = allMsg;
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                        catch(Exception ex){
                            String Error = ex.getMessage()+' at Line #'+ex.getLineNumber();
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, Error, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                    }
                    else{
                        EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                        Msgs.add(eMsg);
                        allMessages.Message = Msgs;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONContactRepresentatives, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                    }
                }
            }
        }
        return response;
    }
    /**
        Description : Create - EON Opt in / Opt Out Preference
    **/
    webservice static EONCustomerContactResults CreateEONOptInOptOutPreference(EONOptInOptOutPreferences EONOptInOptOutPreferences){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONOptInOptOutPreferences) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            if(EON_Voice_Update_Customer_WS_Helper.genException == null)
                EON_Voice_Update_Customer_WS_Helper.genException = false;
            list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference> OptInOptOutPreferences = EONOptInOptOutPreferences.EONOptInOptOutPreference;
            if(EON_Utility.validateRequired(OptInOptOutPreferences) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateOptInOptOutPreference(OptInOptOutPreferences, EONOptInOptOutPreferences.Customer_SFID, EON_Utility.Op_VOICE_Create);
                if(validate){
                    map<String, EON_Opt_in_Opt_Out_Preference__c> createOptInOptOutPreference = EON_Voice_Update_Customer_WS_Helper.createEONOptInOptOutPreference;
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(createOptInOptOutPreference.keySet());
                        if(!createOptInOptOutPreference.isEmpty()){
                            list<EON_Opt_in_Opt_Out_Preference__c> dmlCreateOptInOptOutPreference = createOptInOptOutPreference.values();
                            insert dmlCreateOptInOptOutPreference;
                            integer i = 0;
                            for(EON_Opt_in_Opt_Out_Preference__c OptInOptOutPreference: dmlCreateOptInOptOutPreference){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = OptInOptOutPreference.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONOptInOptOutPreferences, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            if(EON_Utility.genException)  //Generate Exception
                            	tracker.Command__c = 'TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest';
                            update tracker;
                            if(EON_Voice_Update_Customer_WS_Helper.genException) //Generate Exception
                                ID test = ID.valueOf('incorrect');
                        }
                    }
                    catch(System.DmlException ex){
                    	EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                        	EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                            msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                      	}
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONOptInOptOutPreferences, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                 	}
                    catch(Exception ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONOptInOptOutPreferences, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONOptInOptOutPreferences, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Delete - EON Opt in / Opt Out Preference
    **/
    webservice static EONCustomerContactResults DeleteEONOptInOptOutPreference(EONCustomerContacts EONOptInOptOutPreferences){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONOptInOptOutPreferences) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            if(EON_Voice_Update_Customer_WS_Helper.genException == null)
                EON_Voice_Update_Customer_WS_Helper.genException = false;
            list<EON_Voice_Update_Customer_WS.EONCustomerContact> allCustomerContact = EONOptInOptOutPreferences.EONCustomerContact;
            list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference> allOptInOptOutPreference = new list<EON_Voice_Update_Customer_WS.EONOptInOptOutPreference>();
            if(EON_Utility.validateRequired(allCustomerContact) != true){
                for(EON_Voice_Update_Customer_WS.EONCustomerContact contact: allCustomerContact){
                    EON_Voice_Update_Customer_WS.EONOptInOptOutPreference optInOptOutPreference = new EON_Voice_Update_Customer_WS.EONOptInOptOutPreference();
                    optInOptOutPreference.ReferenceID = contact.ReferenceID;
                    optInOptOutPreference.EONOptInOptOutPreference_SFID = contact.SalesforceID;
                    allOptInOptOutPreference.add(optInOptOutPreference);
                }
                if(EON_Utility.validateRequired(allOptInOptOutPreference) != true){
                    boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateOptInOptOutPreference(allOptInOptOutPreference, '', EON_Utility.Op_VOICE_Delete);
                    if(validate){
                        map<String, EON_Opt_in_Opt_Out_Preference__c> deleteOptInOptOutPreference = EON_Voice_Update_Customer_WS_Helper.deleteEONOptInOptOutPreference;                        
                        try{
                            if(!deleteOptInOptOutPreference.isEmpty()){
                                list<String> allRefID = new list<String>(); 
                                allRefID.addAll(deleteOptInOptOutPreference.keySet());
                                list<EON_Opt_in_Opt_Out_Preference__c> dmlOptInOptOutPreference = deleteOptInOptOutPreference.values();
                                update dmlOptInOptOutPreference;
                                integer i = 0;
                                for(EON_Opt_in_Opt_Out_Preference__c OptInOptOutPreference: dmlOptInOptOutPreference){
                                    EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                    custContact.ReferenceID = allRefID[i];
                                    custContact.SalesforceID = OptInOptOutPreference.Id;
                                    customerContacts.add(custContact);
                                    i++;
                                }
                                EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                                allEonCustomerContacts.EONCustomerContact = customerContacts;
                                
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                                allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                                response.EONCustomerContacts = allEonCustomerContacts;
                                response.Status = EON_Utility.RESULT_PASS;
                                response.Messages = allMessages;
                                Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONOptInOptOutPreferences, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                                response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                                tracker.Response_Data__c = String.valueOf(response);
                                if(EON_Utility.genException) //Generate Exception
                                    tracker.Command__c = 'TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest';
                                update tracker;
                                if(EON_Voice_Update_Customer_WS_Helper.genException) //Generate Exception
                					ID test = ID.valueOf('incorrect');
                            }
                        }
                        catch(System.DmlException ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                            for(Integer i=0; i<ex.getNumDml(); i++){
                                EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                                msg.code = eCode.Name;
                                msg.Message = ex.getDmlMessage(i);
                                allMsg.add(msg);
                            }
                            allMessages.Message = allMsg;
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONOptInOptOutPreferences, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                        catch(Exception ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONOptInOptOutPreferences, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                    }
                    else{
                        EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                        Msgs.add(eMsg);
                        allMessages.Message = Msgs;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONOptInOptOutPreferences, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                    }
                }
            }
        }
        return response;
    }
    /**
        Description : Create - EON Service Contact Consent
    **/
    webservice static EONCustomerContactResults CreateEONServiceContactConsent(EONServiceContactConsents EONServiceContactConsents){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONServiceContactConsents) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            list<EON_Voice_Update_Customer_WS.EONServiceContactConsent> serviceContactConsents = EONServiceContactConsents.EONServiceContactConsent;
            if(EON_Utility.validateRequired(serviceContactConsents) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateServiceContactConsent(serviceContactConsents, EONServiceContactConsents.Customer_SFID, EON_Utility.Op_VOICE_Create);
                if(validate){
                    map<String, EON_Service_Contact_Consent__c> CreateServiceContactConsent = EON_Voice_Update_Customer_WS_Helper.createEONServiceContactConsent;
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(CreateServiceContactConsent.keySet());
                        if(!CreateServiceContactConsent.isEmpty()){
                            list<EON_Service_Contact_Consent__c> dmlCreateServiceContactConsent = CreateServiceContactConsent.values();
                            insert dmlCreateServiceContactConsent;
                            integer i = 0;
                            for(EON_Service_Contact_Consent__c ServiceContactConsent: dmlCreateServiceContactConsent){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = ServiceContactConsent.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONServiceContactConsents, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            if(EON_Utility.genException) //Generate Exception
                                ID test = ID.valueOf('incorrect');
                        }
                    }
                    catch(System.DmlException ex){
                    	EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                            EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                            msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                        }
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONServiceContactConsents, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                   	}
                    catch(Exception ex){

                        String Error = ex.getMessage()+' at Line #'+ex.getLineNumber();
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONServiceContactConsents, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONServiceContactConsents, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Delete - EON Service Contact Consent
    **/
    webservice static EONCustomerContactResults DeleteEONServiceContactConsent(EONCustomerContacts EONServiceContactConsents){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONServiceContactConsents) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            if(EON_Voice_Update_Customer_WS_Helper.genException == null)
                EON_Voice_Update_Customer_WS_Helper.genException = false;
            list<EON_Voice_Update_Customer_WS.EONCustomerContact> allCustomerContact = EONServiceContactConsents.EONCustomerContact;
            list<EON_Voice_Update_Customer_WS.EONServiceContactConsent> allServiceContactConsents = new list<EON_Voice_Update_Customer_WS.EONServiceContactConsent>();
            if(EON_Utility.validateRequired(allCustomerContact) != true){
                for(EON_Voice_Update_Customer_WS.EONCustomerContact contact: allCustomerContact){
                    EON_Voice_Update_Customer_WS.EONServiceContactConsent serviceContactConsents = new EON_Voice_Update_Customer_WS.EONServiceContactConsent();
                    serviceContactConsents.ReferenceID = contact.ReferenceID;
                    serviceContactConsents.EONServiceContactConsent_SFID = contact.SalesforceID;
                    allServiceContactConsents.add(serviceContactConsents);
                }
                if(EON_Utility.validateRequired(allServiceContactConsents) != true){
                    boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateServiceContactConsent(allServiceContactConsents, '', EON_Utility.Op_VOICE_Delete);
                    if(validate){
                        map<String, EON_Service_Contact_Consent__c> deleteServiceContactConsent = new map<String, EON_Service_Contact_Consent__c>();
                        deleteServiceContactConsent = EON_Voice_Update_Customer_WS_Helper.deleteEONServiceContactConsent;
                        try{
                            if(!deleteServiceContactConsent.isEmpty()){
                                list<String> allRefID = new list<String>(); 
                                allRefID.addAll(deleteServiceContactConsent.keySet());
                                list<EON_Service_Contact_Consent__c> dmlDeleteServiceContactConsent = deleteServiceContactConsent.values();
                                update dmlDeleteServiceContactConsent;
                                integer i = 0;
                                for(EON_Service_Contact_Consent__c ServiceContactConsent: dmlDeleteServiceContactConsent){
                                    EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                    custContact.ReferenceID = allRefID[i];
                                    custContact.SalesforceID = ServiceContactConsent.Id;
                                    customerContacts.add(custContact);
                                    i++;
                                }
                                EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                                allEonCustomerContacts.EONCustomerContact = customerContacts;
                                
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                                allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                                response.EONCustomerContacts = allEonCustomerContacts;
                                response.Status = EON_Utility.RESULT_PASS;
                                response.Messages = allMessages;
                                Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONServiceContactConsents, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                                response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                                tracker.Response_Data__c = String.valueOf(response);
                                if(EON_Utility.genException)  //Generate Exception
                                    tracker.Command__c = 'TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest';
                                update tracker; 
                                if(EON_Voice_Update_Customer_WS_Helper.genException)  //Generate Exception
                                    ID test = ID.valueOf('incorrect');
                            }
                        }
                        catch(System.DmlException ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                            for(Integer i=0; i<ex.getNumDml(); i++){
                                EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                                msg.code = eCode.Name;
                                msg.Message = ex.getDmlMessage(i);
                                allMsg.add(msg);
                            }
                            allMessages.Message = allMsg;
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONServiceContactConsents, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                        catch(Exception ex){

                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONServiceContactConsents, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                    }
                    else{
                        EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                        Msgs.add(eMsg);
                        allMessages.Message = Msgs;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONServiceContactConsents, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                    }
                }
            }
        }
        return response;
    }
    /**
        Description : Create - EON Site Vulnerability
    **/
    webservice static EONCustomerContactResults CreateEONSiteVulnerability(EONSiteVulnerabilities EONSiteVulnerabilities){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONSiteVulnerabilities) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            list<EON_Voice_Update_Customer_WS.EONSiteVulnerability> SiteVulnerabilities = EONSiteVulnerabilities.EONSiteVulnerability;
            if(EON_Utility.validateRequired(SiteVulnerabilities) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateSiteVulnerability(SiteVulnerabilities, EONSiteVulnerabilities.Customer_SFID, EON_Utility.Op_VOICE_Create);
                if(validate){
                    map<String, EON_Site_Vulnerability__c> CreateSiteVulnerability = EON_Voice_Update_Customer_WS_Helper.createEONSiteVulnerability;
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(CreateSiteVulnerability.keySet());
                        if(!CreateSiteVulnerability.isEmpty()){
                            list<EON_Site_Vulnerability__c> dmlCreateSiteVulnerability = CreateSiteVulnerability.values();
                            insert dmlCreateSiteVulnerability;
                            integer i = 0;
                            for(EON_Site_Vulnerability__c SiteVulnerability: dmlCreateSiteVulnerability){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = SiteVulnerability.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSiteVulnerabilities, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            if(EON_Utility.genException) //Generate exception
                            	ID test = ID.valueOf('Test');
                        }
                    }
                    catch(System.DmlException ex){
                    	EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                        	EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                            msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                       	}
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSiteVulnerabilities, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                  	}
                    catch(Exception ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSiteVulnerabilities, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSiteVulnerabilities, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Delete - EON Site Vulnerability
    **/
    webservice static EONCustomerContactResults DeleteEONSiteVulnerability(EONCustomerContacts EONSiteVulnerabilities){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONSiteVulnerabilities) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            if(EON_Voice_Update_Customer_WS_Helper.genException == null)
                EON_Voice_Update_Customer_WS_Helper.genException = false;
            list<EON_Voice_Update_Customer_WS.EONCustomerContact> allCustomerContact = EONSiteVulnerabilities.EONCustomerContact;
            list<EON_Voice_Update_Customer_WS.EONSiteVulnerability> allSiteVulnerability = new list<EON_Voice_Update_Customer_WS.EONSiteVulnerability>();
            if(EON_Utility.validateRequired(allCustomerContact) != true){
                for(EON_Voice_Update_Customer_WS.EONCustomerContact contact: allCustomerContact){
                    EON_Voice_Update_Customer_WS.EONSiteVulnerability siteVulnerability = new EON_Voice_Update_Customer_WS.EONSiteVulnerability();
                    siteVulnerability.ReferenceID = contact.ReferenceID;
                    siteVulnerability.Vulnerability_SFID = contact.SalesforceID;
                    allSiteVulnerability.add(siteVulnerability);
                }
                if(EON_Utility.validateRequired(allSiteVulnerability) != true){
                    boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateSiteVulnerability(allSiteVulnerability, '', EON_Utility.Op_VOICE_Delete);
                    if(validate){
                        map<String, EON_Site_Vulnerability__c> deleteSiteVulnerability = EON_Voice_Update_Customer_WS_Helper.deleteEONSiteVulnerability;
                        try{
                            if(!deleteSiteVulnerability.isEmpty()){
                                list<String> allRefID = new list<String>(); 
                                allRefID.addAll(deleteSiteVulnerability.keySet());
                                list<EON_Site_Vulnerability__c> dmlDeleteSiteVulnerability = deleteSiteVulnerability.values();
                                update dmlDeleteSiteVulnerability;
                                integer i = 0;
                                for(EON_Site_Vulnerability__c SiteVulnerability: dmlDeleteSiteVulnerability){
                                    EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                    custContact.ReferenceID = allRefID[i];
                                    custContact.SalesforceID = SiteVulnerability.Id;
                                    customerContacts.add(custContact);
                                    i++;
                                }
                                EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                                allEonCustomerContacts.EONCustomerContact = customerContacts;
                                
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                                allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                                response.EONCustomerContacts = allEonCustomerContacts;
                                response.Status = EON_Utility.RESULT_PASS;
                                response.Messages = allMessages;
                                Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSiteVulnerabilities, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                                response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                                tracker.Response_Data__c = String.valueOf(response);
                                if(EON_Utility.genException) //Generate Exception 
                                    tracker.Command__c = 'TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest';
                                update tracker;
                                if(EON_Voice_Update_Customer_WS_Helper.genException) //Generate Exception 
                                    ID test = ID.valueof('incorrect');
                            }
                        }
                        catch(System.DmlException ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                            for(Integer i=0; i<ex.getNumDml(); i++){
                                EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                                msg.code = eCode.Name;
                                msg.Message = ex.getDmlMessage(i);
                                allMsg.add(msg);
                            }
                            allMessages.Message = allMsg;
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSiteVulnerabilities, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                        catch(Exception ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSiteVulnerabilities, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                    }
                    else{
                        EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                        Msgs.add(eMsg);
                        allMessages.Message = Msgs;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSiteVulnerabilities, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                    }
                }
            }
        }
        return response;
    }
    /**
        Description : Create - EON Eligibility Override
    **/
    webservice static EONCustomerContactResults CreateEONEligibilityOverride(EONEligibilityOverrides EONEligibilityOverrides){
         EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONEligibilityOverrides) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            list<EON_Voice_Update_Customer_WS.EONEligibilityOverride> EligibilityOverrides = EONEligibilityOverrides.EONEligibilityOverride;
            if(EON_Utility.validateRequired(EligibilityOverrides) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateEligibilityOverride(EligibilityOverrides, EONEligibilityOverrides.Customer_SFID, EON_Utility.Op_VOICE_Create);
                if(validate){
                    map<String, EON_Eligibility_Override__c> CreateEligibilityOverride = EON_Voice_Update_Customer_WS_Helper.createEligibilityOverride;
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(CreateEligibilityOverride.keySet());
                        if(!CreateEligibilityOverride.isEmpty()){
                            list<EON_Eligibility_Override__c> dmlCreateEligibilityOverride = CreateEligibilityOverride.values();
                            insert dmlCreateEligibilityOverride;
                            integer i = 0;
                            for(EON_Eligibility_Override__c EligibilityOverride: dmlCreateEligibilityOverride){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = EligibilityOverride.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONEligibilityOverrides, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            if(EON_Utility.genException == true) //Generate Exception
                                ID test = ID.valueof('incorrect');
                        }
                    }
                    catch(System.DmlException ex){
                    	EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                        	EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                            msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                      	}
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONEligibilityOverrides, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                  	}
                    catch(Exception ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONEligibilityOverrides, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONEligibilityOverrides, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
    /**
        Description : Delete - EON Eligibility Override
    **/
    webservice static EONCustomerContactResults DeleteEONEligibilityOverride(EONCustomerContacts EONEligibilityOverrides){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONEligibilityOverrides) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            if(EON_Voice_Update_Customer_WS_Helper.genException == null)
                EON_Voice_Update_Customer_WS_Helper.genException = false;
            list<EON_Voice_Update_Customer_WS.EONCustomerContact> allCustomerContact = EONEligibilityOverrides.EONCustomerContact;
            list<EON_Voice_Update_Customer_WS.EONEligibilityOverride> allEligibilityOverride = new list<EON_Voice_Update_Customer_WS.EONEligibilityOverride>();
            if(EON_Utility.validateRequired(allCustomerContact) != true){
                for(EON_Voice_Update_Customer_WS.EONCustomerContact contact: allCustomerContact){
                    EON_Voice_Update_Customer_WS.EONEligibilityOverride eOverride = new EON_Voice_Update_Customer_WS.EONEligibilityOverride();
                    eOverride.ReferenceID = contact.ReferenceID;
                    eOverride.EONEligibilityOverride_SFID = contact.SalesforceID;
                    allEligibilityOverride.add(eOverride);
                }
                if(EON_Utility.validateRequired(allEligibilityOverride) != true){
                    boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateEligibilityOverride(allEligibilityOverride, '', EON_Utility.Op_VOICE_Delete);
                    if(validate){
                        map<String, EON_Eligibility_Override__c> deleteEligibilityOverride = EON_Voice_Update_Customer_WS_Helper.deleteEligibilityOverride;
                        try{
                            if(!deleteEligibilityOverride.isEmpty()){
                                list<String> allRefID = new list<String>(); 
                                allRefID.addAll(deleteEligibilityOverride.keySet());
                                
                                list<EON_Eligibility_Override__c> dmlDeleteEligibilityOverride = deleteEligibilityOverride.values();
                                update dmlDeleteEligibilityOverride;
                                integer i = 0;
                                for(EON_Eligibility_Override__c EligibilityOverride: dmlDeleteEligibilityOverride){
                                    EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                    custContact.ReferenceID = allRefID[i];
                                    custContact.SalesforceID = EligibilityOverride.Id;
                                    customerContacts.add(custContact);
                                    i++;
                                }
                                EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                                allEonCustomerContacts.EONCustomerContact = customerContacts;
                                
                                EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                                allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                                response.EONCustomerContacts = allEonCustomerContacts;
                                response.Status = EON_Utility.RESULT_PASS;
                                response.Messages = allMessages;
                                Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONEligibilityOverrides, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                                response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                                tracker.Response_Data__c = String.valueOf(response);
                                if(EON_Utility.genException)
                                    tracker.Command__c = 'TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest';
                                update tracker;
                                if(EON_Voice_Update_Customer_WS_Helper.genException)
                                    ID test = ID.valueOf('incorrect');
                            }
                        }
                        catch(System.DmlException ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                            for(Integer i=0; i<ex.getNumDml(); i++){
                                EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                                msg.code = eCode.Name;
                                msg.Message = ex.getDmlMessage(i);
                                allMsg.add(msg);
                            }
                            allMessages.Message = allMsg;
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONEligibilityOverrides, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                        catch(Exception ex){
                            EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.Status = EON_Utility.RESULT_FAIL;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONEligibilityOverrides, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            return response;
                        }
                    }
                    else{
                        EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                        Msgs.add(eMsg);
                        allMessages.Message = Msgs;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONEligibilityOverrides, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                    }
                }
            }
        }
        return response;
    }
    /**
        Description : Update - EON Site
    **/
    webservice static EONCustomerContactResults UpdateEONSite(EONSites EONSites){
        EON_Utility eonUtility = new EON_Utility();
        list<Message> Msgs = new list<Message>();
        Messages allMessages = new Messages();
        list<EON_Voice_Update_Customer_WS.EONCustomerContact> customerContacts = new list<EON_Voice_Update_Customer_WS.EONCustomerContact>();
        EONCustomerContactResults response = new EONCustomerContactResults();
        if(EON_Utility.validateRequired(EONSites) != true){
            if(EON_Utility.genException == null)
                EON_Utility.genException = false;
            list<EON_Voice_Update_Customer_WS.EONSite> sites = EONSites.EONSite;
            if(EON_Utility.validateRequired(sites) != true){
                boolean validate = EON_Voice_Update_Customer_WS_Helper.ValidateSite(sites, EONSites.Customer_SFID, EON_Utility.Op_VOICE_Update);
                if(validate){
                    map<String, EON_Site__c> updateSite = EON_Voice_Update_Customer_WS_Helper.updateSite;
                    try{
                        list<String> allRefID = new list<String>(); 
                        allRefID.addAll(updateSite.keySet());
                        if(!updateSite.isEmpty()){
                            list<EON_Site__c> dmlUpdateSite = updateSite.values();
                            update dmlUpdateSite;
                            integer i = 0;
                            for(EON_Site__c s: dmlUpdateSite){
                                EON_Voice_Update_Customer_WS.EONCustomerContact custContact = new EON_Voice_Update_Customer_WS.EONCustomerContact();
                                custContact.ReferenceID = allRefID[i];
                                custContact.SalesforceID = s.Id;
                                customerContacts.add(custContact);
                                i++;
                            }
                            EON_Voice_Update_Customer_WS.EONCustomerContacts allEonCustomerContacts = new EON_Voice_Update_Customer_WS.EONCustomerContacts();
                            allEonCustomerContacts.EONCustomerContact = customerContacts;
                            
                            EON_Error_Code__c eCode = eonUtility.getErrorCode('Success');
                            allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                            response.EONCustomerContacts = allEonCustomerContacts;
                            response.Status = EON_Utility.RESULT_PASS;
                            response.Messages = allMessages;
                            Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSites, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                            response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                            tracker.Response_Data__c = String.valueOf(response);
                            update tracker;
                            if(EON_Utility.genException == true) //Generate Exception
                                ID test = ID.valueOf('incorrect');
                        }
                    }
                    catch(System.DmlException ex){
                    	EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        list<EON_Voice_Update_Customer_WS.Message> allMsg = new list<EON_Voice_Update_Customer_WS.Message>();
                        for(Integer i=0; i<ex.getNumDml(); i++){
                        	EON_Voice_Update_Customer_WS.Message msg = new EON_Voice_Update_Customer_WS.Message();
                            msg.code = eCode.Name;
                            msg.Message = ex.getDmlMessage(i);
                            allMsg.add(msg);
                       	}
                        allMessages.Message = allMsg;
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSites, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                 	}
                    catch(Exception ex){
                        EON_Error_Code__c eCode = eonUtility.getErrorCode(ex);
                        allMessages.Message = EON_Voice_Update_Customer_WS_Helper.getAllMessages(eCode);
                        response.Status = EON_Utility.RESULT_FAIL;
                        response.Messages = allMessages;
                        Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSites, response, response.Status, ex.getMessage()+'\n\n'+ex.getStackTraceString(), eCode);
                        response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                        tracker.Response_Data__c = String.valueOf(response);
                        update tracker;
                        return response;
                    }
                }
                else{
                    EON_Voice_Update_Customer_WS.Message eMsg = EON_Voice_Update_Customer_WS_Helper.message;
                    Msgs.add(eMsg);
                    allMessages.Message = Msgs;
                    response.Status = EON_Utility.RESULT_FAIL;
                    response.Messages = allMessages;
                    EON_Error_Code__c eCode = eonUtility.getErrorCode(eMsg.Code);
                    Voice_Data_Tracker__c tracker = EON_Voice_Update_Customer_WS_Helper.updateVoiceDataTracker(EONSites, response, response.Status, EON_Voice_Update_Customer_WS_Helper.errorMessage, eCode);
                    response.VoiceDataTrackerID = [Select Name from Voice_Data_Tracker__c where ID=:tracker.ID].Name;
                    tracker.Response_Data__c = String.valueOf(response);
                    update tracker;
                }
            }
        }
        return response;
    }
}