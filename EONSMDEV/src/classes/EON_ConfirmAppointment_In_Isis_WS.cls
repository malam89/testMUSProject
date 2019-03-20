/**
    Description : This class will be used for generating WSDL, so that EON can use this WSDL to Confirm ConfirmBooking in Isis.
                                    
    Test Class  : EON_ConfirmAppointment_In_Isis_test

**/
/*
    Created By  : Akshay Bairagi
    Created On  : 15/03/2016
    Service Req : SR_EON_AB_017,SR_EON_AB_031
    Change History
    CH01 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH02 # SR_EON_Mobile_043 # 07/06/2016 # Dharmendra P # Updated logic for getting EON Appointment record
    CH03 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH04 # SR_EON_Jumbo_030 # 09/06/2016 # Mehbobo Alam # Added a filter condition in query to check 'Vulnerability Source'.
    CH05 # SR_EON_AB_071 # 16/06/2016 # Dharmendra P # removed mapping for PAYG fields
    CH06 # SR_EON_AB_072 # 16/06/2016 # Shruti Moghe # Updated logic for WSDL as per the SR
    CH07 # SR_EON_AB_076 # 21/06/2016 # Shruti Moghe # Updated logic for Data Capture Consents (Only mandatory for SMART jobs)
    CH08 # SR_EON_AB_108 # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text 
    CH09 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Deleted reference of field Vulnerability_Source__c
    CH10 # SR_EON_AB_129 # 02/09/2016 # Aruna Manjari # Added the error messages for fields(ContactTypeCode ,MediaTypeCode,LocationCode ,CommTypeCode ,DeliveryMethod ,ParkingTypeCode ,VulnerabilityDetailCode ,VulnerabilityTypeID) not present
    CH11 # SR_EON_AB_140 #08/09/2016 #Praveen G # Made EON Appointment Comms optional.
    CH12 # SR_EON_AB_143 # 13-09-2016 # Mahadev J # Populating 'EON Appointment' reference at 'EON Data Tracker'
    CH13 # SR_EON_AB_166 # 14-10-2016 # Mahadev J # Update request will be rejecterd if appointment not created at Oracle.
    CH14 # SR_EON_AB_139 # 20/10/2016 # Aruna Manjari # Added the logic to make combination of vulnerabilitydetailcode and vulnerability type id as unique at updating appointment
    CH15 # SR_OptiMUS_EON_119 / SR_OptiMUS_EON_153 # 11/09/2017 # Praveen G # Added new fields and related logic. 
    CH16 # SR_EON_AB_220 # 01/11/2017 # Praveen G # Amended the person name contract number validation. 
    CH17 # SR_OptiMUS_EON_148 # SR_OptiMUS_EON_148 # 30/10/2017 # Mehboob Alam # Added a Note If ‘Current Phase’ is (>) 'greater than' ‘Number of Phases’.
    CH18 # SR_OptiMUS_EON_226 # 27/02/2017 # Praveen G # updated the validations for 3 fields.
 */
global with sharing class EON_ConfirmAppointment_In_Isis_WS {
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class HeaderElement {  
        Webservice String OrgId ;
        Webservice String RequestId ;
        Webservice datetime RequestDateTime ;
    }
    /**
        Description : Request Parameter 2
    
    global with sharing class NoteElement {  
        //Webservice list<String> Note;//Ch06.old
        Webservice String Note;//CH06.new
    } 
    **/ 
    /**
        Description : Request Parameter 2
    **/
    global with sharing class KeyCollectionElement {  
        Webservice String PersonName;
        Webservice String ContactNumber ;
        Webservice String BuildingNumber ;
        Webservice String BuildingName ;
        Webservice String SubBuildingName ;
        Webservice String DependentLocality ;
        Webservice String DependentThorofare ;
        Webservice String DoubleDependentLocality ;
        Webservice String Thorofare ;
        Webservice String Town ;
        Webservice String PostCode ;
        Webservice String County ;
        Webservice String Country ;
        
    }   
    /**
        Description : Request Parameter 3
    **/
    global with sharing class AppointmentDetailElement {  
        Webservice String ExternalAppointmentID;
        Webservice String EONAppointmentID ;
        Webservice String AccessPhrase ;
        Webservice String CallerName ;
        Webservice String RequestedSSC ;
        Webservice KeyCollectionElement KeyCollection;
        Webservice String Note;
        //Webservice NoteElement Notes ;
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class ContactElement {  
        Webservice String ContactTypeCode;
        Webservice String ContactName;
        Webservice String MediaTypeCode;
        Webservice String MediaDetail;
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class Contactlst {  
        Webservice list<ContactElement> Contact; 
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class MeterLocationElement {  
        Webservice String LocationCode; 
        Webservice String FuelTypeCode;
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class MeterLocationlst {  
        Webservice list<MeterLocationElement> MeterLocation; 
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class CommunicationTypeElement {  
        Webservice String CommTypeCode;
        Webservice String DeliveryMethod;       
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class CommunicationTypelst {  
        Webservice list<CommunicationTypeElement> CommunicationType; 
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class ParkingDetailElement {  
        Webservice String ParkingTypeCode; 
    }
    /**
        Description : Request Parameter 10
    
    global with sharing class ParkingDetailLst {  
        Webservice list<ParkingDetailElement> Parking; 
    }
    **/
    /**
        Description : Request Parameter 10
    **/
    global with sharing class DataCaptureConsentsElement {  
        Webservice String ElecHHDataOpted; 
        Webservice String ElecDailyDataOpted; 
        Webservice String GasHHDataOpted; 
        Webservice String GasDailyDataOpted; 
    }
    /**
        Description : Request Parameter 10
    **/
    /*
    CH06.old.start
    global with sharing class PAYGAlertPreferencesElement {  
        Webservice String EONSetDisconnectOpted; 
        Webservice String CustomerLowBalanceAlertOpted; 
        Webservice Integer LowBalanceAlertValue; 
        Webservice String TopUpCodeNotifyFailureOpted; 
        Webservice String PaymentReminderOpted;
        Webservice String PaymentReminderFrequency;
        Webservice String PaymentReminderDayOfTheWeek;
        Webservice String PaymentReminderDateOfTheMonth;
    }
    CH06.old.End
    */
    /**
        Description : Request Parameter 10
    **/
    global with sharing class VulnerabilityElement {  
        Webservice String VulnerabilityDetailCode; 
        Webservice Integer VulnerabilityTypeId; 
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class VulnerabilitiesLst {  
        Webservice list<VulnerabilityElement> Vulnerability; 
    }
    
    //CH15.Start
    /**
        Description : Request Parameter 
    **/
    global with sharing class WANCoverageElement {  
        Webservice String CSPRegion;
        Webservice String CoverageAvailability;
        Webservice String CommsHubVariant;
        Webservice String ConnectivityLikelihood;
        Webservice String AuxiliaryEquipmentrequired ;
        Webservice String AdditionalInformation;   
    }
    //CH15.End
        
    /**
        Description : Request Parameter 10
    **/
    global with sharing class ConfirmAppointment{  
        Webservice HeaderElement Header;
        Webservice AppointmentDetailElement AppointmentDetails ;
        Webservice Contactlst Contacts;
        Webservice MeterLocationlst MeterLocations;
        Webservice CommunicationTypelst CommunicationTypes;
        Webservice ParkingDetailElement Parking;//ParkingDetailLst ParkingDetails;
        Webservice DataCaptureConsentsElement DataCaptureConsents;
        //Webservice PAYGAlertPreferencesElement PAYGAlertPreferences;//CH06.old
        Webservice VulnerabilitiesLst Vulnerabilities;
        Webservice WANCoverageElement WANCoverageDetails ;//CH15
    }  
    /**
        Description : Response 1
    **/
    global with sharing class errMessage {
        Webservice String MessageType ;
        Webservice integer MessageId ;
        Webservice String MessageText ;
    }
    /**
        Description : Response 2
    **/
    global with sharing class errMessageLst {
        Webservice list<errMessage> Message;
    }
    /**
        Description : Response 3
    **/
    global with sharing class Isis_Response_Acknowledgement_To_EON{
        Webservice HeaderElement Header ;
        Webservice Datetime ConfirmBookingDate ;
        Webservice String ExternalAppointmentID ;
        Webservice String EONAppointmentID ;
        Webservice errMessageLst Messages ;
    } 
    public static String validateStringLen(String value, integer len){        
        if(value!= null && value.length() > len)
            value = value.subString(0, len);
        return value;          
    }
    /**
        Isis_Response_Acknowledgement_To_EON ConfirmAppointment (ConfirmAppointment  ConfirmBooking) - 
                This method is used to get create ConfirmBooking from Isis.
    **/
    webservice static Isis_Response_Acknowledgement_To_EON ConfirmAppointment(ConfirmAppointment ConfirmBooking){ 
        Isis_Response_Acknowledgement_To_EON response = new Isis_Response_Acknowledgement_To_EON();
        errMessageLst errorlst = new errMessageLst();
        EON_Data_Tracker__c eonTracker = new EON_Data_Tracker__c();
        Oracle_Data_Tracker__c oracTracker = new Oracle_Data_Tracker__c();
        eonTracker.Direction__c = 'IN'; 
        eonTracker.Command__c = 'ConfirmAppointment';
        list<errMessage> msgLst = new list<errMessage>();
        string Error = '';
        try{
            if(ConfirmBooking != null){
                eonTracker.Request_Data__c = EON_Utility.validateStringLength(ConfirmBooking + '');                                                                                             
                eonTracker.Transaction_ID__c = ConfirmBooking.header.requestId; 
                if(EON_Utility.validateRequired(ConfirmBooking.header.orgId) == true){
                    Error = 'OrgId cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.header.requestId) == true){
                    Error = Error + 'RequestId cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.header.RequestDateTime) == true){
                    Error = Error + 'RequestDateTime cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.EONAppointmentID) == true){
                    Error = Error + 'EONAppointmentID cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.ExternalAppointmentID) == true){
                    Error = Error + 'ExternalAppointmentID cannot be blank\n';
                }
                /*
                if(EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.RequestedSSC) == true){
                    Error = Error + 'RequestedSSC cannot be blank\n';
                }*///CH06.old
                if(EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection) != true){ //CH16
                    if(EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.PersonName) == true)
                            // && EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.ContactNumber) != true){//CH06
                        Error = Error + 'PersonName cannot be blank\n';
                    
                    if(EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.ContactNumber) == true) //CH16
                    // && EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.PersonName) != true){//CH06
                        Error = Error + 'ContactNumber cannot be blank\n';
                    
                }
                
                
                //CH15.Start
                if(System.Label.EON_Confirm_WSDL_Mandatory == 'TRUE'){  
                    if(ConfirmBooking.WANCoverageDetails != null){ 
                        //CSP Region                   
                        if(EON_Utility.validateRequired(ConfirmBooking.WANCoverageDetails.CSPRegion) == true){
                            //CH18 Added the below IF
                            if(!EON_Utility.validateRequired(ConfirmBooking.WANCoverageDetails.CoverageAvailability) && 
                                ConfirmBooking.WANCoverageDetails.CoverageAvailability == 'Y')                        
                                Error = Error + 'REJECTED No CSP REGION\n';
                        }else{
                            EON_Standing_Data__c[] lstStandingDataCSPRegion = 
                                        [select id from EON_Standing_Data__c 
                                            where Code_ID__c =: ConfirmBooking.WANCoverageDetails.CSPRegion
                                            AND DataGroup__r.Name = 'CSP_REGION']; 
                            if(lstStandingDataCSPRegion.isEmpty())
                                Error = Error + 'REJECTED INVALID CSP REGION\n';                       
                        }
                        //COVERAGE AVAILABILITY    
                        if(EON_Utility.validateRequired(ConfirmBooking.WANCoverageDetails.CoverageAvailability) == true)
                            Error = Error + 'REJECTED No COVERAGE AVAILABILITY\n';
                        else if(ConfirmBooking.WANCoverageDetails.CoverageAvailability != 'Y' &&
                                ConfirmBooking.WANCoverageDetails.CoverageAvailability != 'N')                            
                            Error = Error + 'REJECTED INVALID COVERAGE AVAILABILITY\n';                       
                        
                        //COMMS HUB VARIANT                            
                        if(EON_Utility.validateRequired(ConfirmBooking.WANCoverageDetails.CommsHubVariant) == true){
                            //CH18 Added the below IF
                            if(!EON_Utility.validateRequired(ConfirmBooking.WANCoverageDetails.CoverageAvailability) && 
                                ConfirmBooking.WANCoverageDetails.CoverageAvailability == 'Y')
                            Error = Error + 'REJECTED No COMMS HUB VARIANT\n'; 
                        }else{
                            EON_Standing_Data__c[] lstStandingDataCommsHubV = 
                                        [select id from EON_Standing_Data__c 
                                            where Code_ID__c =: ConfirmBooking.WANCoverageDetails.CommsHubVariant
                                            AND DataGroup__r.Name = 'COMMS_HUB_VARIANT']; 
                            if(lstStandingDataCommsHubV.isEmpty())
                                Error = Error + 'REJECTED INVALID COMMS HUB VARIANT\n';                       
                        } 
                        
                        //CONNECTIVITY LIKELIHOOD                       
                        if(EON_Utility.validateRequired(ConfirmBooking.WANCoverageDetails.ConnectivityLikelihood) == true){
                            //CH18 Added the below IF
                            if(!EON_Utility.validateRequired(ConfirmBooking.WANCoverageDetails.CoverageAvailability) && 
                                ConfirmBooking.WANCoverageDetails.CoverageAvailability == 'Y')
                            Error = Error + 'REJECTED No CONNECTIVITY LIKELIHOOD\n';                                                           
                        }else{
                            EON_Standing_Data__c[] lstStandingDataConnectLikHood = 
                                        [select id from EON_Standing_Data__c 
                                         where Code_ID__c =: ConfirmBooking.WANCoverageDetails.ConnectivityLikelihood
                                         AND DataGroup__r.Name = 'CONNECTIVITY_LIKELIHOOD']; 
                            if(lstStandingDataConnectLikHood.isEmpty())
                                Error = Error + 'REJECTED INVALID CONNECTIVITY LIKELIHOOD\n';                       
                        }                    
                    }else{
                        Error = Error + 'REJECTED WANCoverageDetails cannot be blank\n';     
                    }                    
                }
                
                //CH15.End 
                                
                /*
                //CH07.start.old
                if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.ElecHHDataOpted) == true){
                    Error = Error + 'ElecHHDataOpted cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.ElecDailyDataOpted) == true){
                    Error = Error + 'ElecDailyDataOpted cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.GasHHDataOpted) == true){
                    Error = Error + 'GasHHDataOpted cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.GasDailyDataOpted) == true){
                    Error = Error + 'GasDailyDataOpted cannot be blank\n';
                }//CH07.end.old
                */
                //CH06.old.start
                /*
                if(EON_Utility.validateRequired(ConfirmBooking.PAYGAlertPreferences.EONSetDisconnectOpted) == true){
                    Error = Error + 'EONSetDisconnectOpted cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.PAYGAlertPreferences.CustomerLowBalanceAlertOpted) == true){
                    Error = Error + 'CustomerLowBalanceAlertOpted cannot be blank\n';
                }
                else{
                    if((ConfirmBooking.PAYGAlertPreferences.CustomerLowBalanceAlertOpted.trim().equalsIgnoreCase('Y')) && (EON_Utility.validateRequired(ConfirmBooking.PAYGAlertPreferences.LowBalanceAlertValue) == true)){
                        Error = Error + 'LowBalanceAlertValue can\'t be Blank if CustomerLowBalanceAlertOpted is populated\n';
                    }
                }
                if(EON_Utility.validateRequired(ConfirmBooking.PAYGAlertPreferences.TopUpCodeNotifyFailureOpted) == true){
                    Error = Error + 'TopUpCodeNotifyFailureOpted cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.PAYGAlertPreferences.PaymentReminderOpted) == true){
                    Error = Error + 'PaymentReminderOpted cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfirmBooking.PAYGAlertPreferences.PaymentReminderFrequency) == true){
                    Error = Error + 'PaymentReminderFrequency cannot be blank\n';
                }
                else{
                    if((ConfirmBooking.PAYGAlertPreferences.PaymentReminderFrequency.trim().equalsIgnoreCase('W')) && (EON_Utility.validateRequired(ConfirmBooking.PAYGAlertPreferences.PaymentReminderDayOfTheWeek) == true)){
                        Error = Error + 'PaymentReminderDayOfTheWeek can\'t be Blank, If PaymentReminderFrequency is W.\n';
                    }
                    if((ConfirmBooking.PAYGAlertPreferences.PaymentReminderFrequency.trim().equalsIgnoreCase('M')) && (EON_Utility.validateRequired(ConfirmBooking.PAYGAlertPreferences.PaymentReminderDateOfTheMonth) == true)){
                        Error = Error + 'PaymentReminderDateOfTheMonth can\'t be Blank, If PaymentReminderFrequency is M.\n';
                    }
                }*/
                 //CH06.old.end
                if(EON_Utility.validateRequired(ConfirmBooking.Contacts.Contact) != true){
                    for(ContactElement CE :ConfirmBooking.Contacts.Contact){
                        if(EON_Utility.validateRequired(CE.ContactTypeCode) == true){
                            Error = Error + 'ContactTypeCode cannot be blank\n';
                            Break;
                        }
                        if(EON_Utility.validateRequired(CE.ContactName) == true){
                            Error = Error + 'ContactName cannot be blank\n';
                            Break;
                        }
                        if(EON_Utility.validateRequired(CE.MediaTypeCode) == true){
                            Error = Error + 'MediaTypeCode cannot be blank\n';
                            Break;
                        }
                        if(EON_Utility.validateRequired(CE.MediaDetail) == true){
                            Error = Error + 'MediaDetail cannot be blank\n';
                            Break;
                        }                       
                    }
                }
                if(EON_Utility.validateRequired(ConfirmBooking.MeterLocations.MeterLocation) != true){
                    for(MeterLocationElement MLE : ConfirmBooking.MeterLocations.MeterLocation){
                        if(EON_Utility.validateRequired(MLE.LocationCode)== true) {
                            Error = Error + 'LocationCode cannot be blank\n';
                            Break;
                        }
                        if(EON_Utility.validateRequired(MLE.FuelTypeCode) == true){
                            Error = Error + 'FuelTypeCode cannot be blank\n';
                            Break;
                        }                       
                    }
                }
                if(ConfirmBooking.CommunicationTypes != null && 
                        EON_Utility.validateRequired(ConfirmBooking.CommunicationTypes.CommunicationType) != true){
                    for(CommunicationTypeElement CTE : ConfirmBooking.CommunicationTypes.CommunicationType){
                        if(EON_Utility.validateRequired(CTE.CommTypeCode)== true) {
                            Error = Error + 'CommTypeCode cannot be blank\n';
                            Break;
                        }
                        if(EON_Utility.validateRequired(CTE.DeliveryMethod) == true){
                            Error = Error + 'DeliveryMethod cannot be blank\n';
                            Break;
                        }                       
                    }
                }
                if(EON_Utility.validateRequired(ConfirmBooking.Parking) != true){
                    if(EON_Utility.validateRequired(ConfirmBooking.Parking.ParkingTypeCode)== true) {
                        Error = Error + 'ParkingTypeCode cannot be blank\n';
                    }   
                }
                if(EON_Utility.validateRequired(ConfirmBooking.Vulnerabilities) != true)//CH06
                if(EON_Utility.validateRequired(ConfirmBooking.Vulnerabilities.Vulnerability) != true){
                    for(VulnerabilityElement VE : ConfirmBooking.Vulnerabilities.Vulnerability){
                        if(EON_Utility.validateRequired(VE.VulnerabilityDetailCode)== true) {
                            Error = Error + 'VulnerabilityDetailCode cannot be blank\n';
                            Break;
                        }
                        if(EON_Utility.validateRequired(VE.VulnerabilityTypeId) == true){
                            Error = Error + 'VulnerabilityTypeId cannot be blank\n';
                            Break;
                        }                       
                    }
                }
                if(Error == ''){
                    //Main Processing
                    string MusAppID = ConfirmBooking.AppointmentDetails.ExternalAppointmentID.trim();
                    //CH02.old
                    /*list<EON_Appointment__c> Appt = [Select id, Name, h_Job_Type__c, Time_Slot__c, MPAN__c,
                                   Customer_Name__c,Metering_Point_Postcode__c,Post_Code__c,Job_Code__c,
                                   EON_Appointment_ID__c, Access_Pass_Phrase__c, Assisted_Work_Reason_Code__c, Additional_Information__c, MPRN__c,   
                                   E_Meter_Serial_Number__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, 
                                   E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c,E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c,  
                                   Certification_Date__c, G_Meter_Serial_Number__c, Gas_Regulator_Serial_Number__c, G_Meter_Make__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c, 
                                   G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c,Requested_SSC__c,Requested_SSC__r.name,
                                   Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, 
                                   Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c, Key_Contact_Number__c, Job_code__r.Name, 
                                   Job_code__r.h_Job_Attribute_Duration__c, Job_code__r.Duration__c, 
                                   Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c, Fuel_ID__r.MPAN__c, Duration__c, SubArea__c, Sent_to_Oracle__c,  
                                   Start_Time__c, End_Time__c, Caller_Name__c, Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c,  Oracle_Postcode_Sector__c, Appointment_Date__c,
                                   Fuel_ID__r.MPRN__c, h_OFSC_Metering_Pressure__c, h_OFSC_Number_of_Phases__c, h_OFSC_Planned_E_Meter_Type__c, h_OFSC_Planned_G_Meter_Type__c,  
                                   h_OFSC_Planned_Meter_Registers__c, h_OFSC_Planned_Meter_Mode__c, h_OFSC_Gas_bind_performed_flag__c, h_OFSC_Install_SED_flag__c,
                                   h_OFSC_E_Check_Meter_Installed__c, h_OFSC_G_Check_Meter_Installed__c, h_OFSC_Assisted_Work_Reason_Code__c, E_Meter_Type__r.OFS_Enumeration__c, 
                                   G_Meter_Type__r.OFS_Enumeration__c, Parking_Type__r.OFS_Enumeration__c, E_Meter_Register_1_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_2_Name__r.OFS_Enumeration__c, E_Meter_Register_3_Name__r.OFS_Enumeration__c, E_Meter_Register_4_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_5_Name__r.OFS_Enumeration__c, E_Meter_Register_6_Name__r.OFS_Enumeration__c, Appointment_reason_code__r.OFS_Enumeration__c, 
                                   G_Meter_Location__r.OFS_Enumeration__c, E_Meter_Location__r.OFS_Enumeration__c,
                                   Sent_to_Oracle_Update__c, Job_code__r.SME_Duration__c from EON_Appointment__c where name =:MusAppID AND Sent_to_Oracle__c = true limit 1];//CH01
                    //If valid MUS appointID is found than process the update request from EON */
                    EON_Appointment__c appointment;
                    //string getAppResponse = EON_OFSC_Update_Appointment.getAppointment(MusAppID);//CH02 //CH013.Old
                    string getAppResponse = EON_OFSC_Update_Appointment.getAppointmentForEON(MusAppID);//CH13.New
                    system.debug('@@@ getAppResponse: '+getAppResponse);
                    //CH02.old //if(Appt != null && Appt.size()>0){
                    if(getAppResponse =='OOA System is background processing this appointment. Please try again.')  //CH13.New
                        Error = Error + 'OOA System is background processing this appointment. Please try again.'; //CH13.New
                    else if(getAppResponse =='Appointment Exists.'){ //CH02
                        appointment =  EON_OFSC_Update_Appointment.objAppt1; //CH02
                        eonTracker.Appointment__c = appointment.ID; //CH12.Update 
                        system.debug('----'+appointment);
                        //CH02.old //if(((Appt[0].Post_Code__c != '' && Appt[0].Post_Code__c != null) || (Appt[0].Metering_Point_Postcode__c != '' && Appt[0].Metering_Point_Postcode__c != null)) && (Appt[0].Job_Code__c != null) && (Appt[0].Oracle_Address__c != '' && Appt[0].Oracle_Address__c != null)){
                        if(((appointment.Post_Code__c != '' && appointment.Post_Code__c != null) || (appointment.Metering_Point_Postcode__c != '' && appointment.Metering_Point_Postcode__c != null)) && (appointment.Job_Code__c != null) && (appointment.Oracle_Address__c != '' && appointment.Oracle_Address__c != null)){
                            //Variable declaration:
                            Integer OFS_Enumeration;
                            list<Eon_Appointment_Notes__c> aapNotesLst;
                            list<EON_Appointment_Contact__c> contactLstInst = new list<EON_Appointment_Contact__c>();
                            list<EON_Appointment_Comms__c> commLst = new list<EON_Appointment_Comms__c>();
                            list<EON_Appointment_Vulnerability__c> apptVulLst = new list<EON_Appointment_Vulnerability__c>();
                            //
                            //CH02.old //appointment = new EON_Appointment__c(id=Appt[0].id);//
                            //CH02.old //appointment = Appt[0];
                            appointment.Access_Pass_Phrase__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.AccessPhrase)?'':validateStringLen(ConfirmBooking.AppointmentDetails.AccessPhrase.trim(),100);
                            
                            appointment.Caller_Name__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.CallerName)?'':validateStringLen(ConfirmBooking.AppointmentDetails.CallerName.trim(),50);
                            //CH06.old.start
                            //appointment.Requested_SSC__c = validateStringLen(ConfirmBooking.AppointmentDetails.RequestedSSC.trim(),4);//CH01.old
                            //CH06.old.start
                            //CH03.old.start
                            /*
                            //CH01.Start
                            List<EON_SSC__c> lstSSC=new List<EON_SSC__c>();
                            lstSSC=[select id, name from EON_SSC__c where name=:ConfirmBooking.AppointmentDetails.RequestedSSC];
                            System.debug('lstSSC'+lstSSC);
                            if(lstSSC!=null && lstSSC.Size()>0)
                            //appointment.Requested_SSC__c =lstSSC[0].id;//CH01.end
                            */
                            //CH03.old//CH06.old.end
                            //CH06.start
                            List<EON_Job__c> lstJob= new List<EON_Job__c>();
                            lstJob=[select id,Name,Job_Type__c, SSC_Required__c from EON_Job__c where id=:appointment.Job_Code__c];
                            if(lstJob!=null && lstJob.size()>0){
                                if(EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.RequestedSSC) && lstJob[0].SSC_Required__c){
                                    Error = Error +'Rejected - SSC expected and not provided\n';  
                                }
                                else if(!lstJob[0].SSC_Required__c && EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.RequestedSSC))
                                appointment.Requested_SSC__c=appointment.Current_SSC__c;
                                else if((lstJob[0].SSC_Required__c || lstJob[0].SSC_Required__c==false) && !EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.RequestedSSC))
                                appointment.Requested_SSC__c = validateStringLen(ConfirmBooking.AppointmentDetails.RequestedSSC.trim(),4);
                                //CH07.start
                                if(lstJob[0].Job_Type__c!=null && lstJob[0].Job_Type__c.equalsIgnorecase('SMART')){                                  
                                        if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.ElecHHDataOpted) == true){
                                            Error = Error + 'ElecHHDataOpted cannot be blank\n';
                                        }
                                        if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.ElecDailyDataOpted) == true){
                                            Error = Error + 'ElecDailyDataOpted cannot be blank\n';
                                        }
                                        if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.GasHHDataOpted) == true){
                                            Error = Error + 'GasHHDataOpted cannot be blank\n';
                                        }
                                        if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.GasDailyDataOpted) == true){
                                            Error = Error + 'GasDailyDataOpted cannot be blank\n';
                                        }                                    
                                }
                                //CH07.end
                            }
                            //CH06.end
                            system.debug('----'+EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection));
                            if(EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection) != true){
                                appointment.Key_Person_Name__c =EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.PersonName)?'': validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.PersonName.trim(),50);//CH06
                                
                                //appointment.Key_Contact_Number__c =EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.ContactNumber)?null: Double.valueof(validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.ContactNumber.trim(),18));//CH06//CH08.old
                                appointment.Key_Contact_Number__c =EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.ContactNumber)?'': validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.ContactNumber.trim(),18);//CH06//CH08.new
                                
                                appointment.Key_Building_Number__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.BuildingNumber)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.BuildingNumber.trim(),64); 
                                
                                appointment.Key_Sub_Building_Name__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.SubBuildingName)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.SubBuildingName.trim(),64);
                                
                                appointment.Key_Building_Name__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.BuildingName)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.BuildingName.trim(),64);
                                
                                appointment.Key_Town__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.Town)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.Town.trim(),64);
                                
                                appointment.Key_Dependant_Locality__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.DependentLocality)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.DependentLocality.trim(),64);
                                
                                appointment.Key_Double_Dependant_Locality__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.DoubleDependentLocality)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.DoubleDependentLocality.trim(),64);
                                
                                appointment.Key_Thorofare__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.Thorofare)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.Thorofare.trim(),64);
                                
                                appointment.Key_Dependant_Thorofare__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.DependentThorofare)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.DependentThorofare.trim(),64);
                                
                                appointment.Key_County__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.County)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.County.trim(),35);
                                
                                appointment.Key_Post_Code__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.PostCode)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.PostCode.trim(),8);
                                
                                appointment.Key_Country__c = EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.KeyCollection.Country)?'':validateStringLen(ConfirmBooking.AppointmentDetails.KeyCollection.Country.trim(),20);
                            }
                            //Key Collection Required:
                            if(EON_Utility.validateRequired(appointment.Key_Person_Name__c) && EON_Utility.validateRequired(appointment.Key_Contact_Number__c) && EON_Utility.validateRequired(appointment.Key_Building_Number__c) && EON_Utility.validateRequired(appointment.Key_Sub_Building_Name__c) && EON_Utility.validateRequired(appointment.Key_Building_Name__c) && EON_Utility.validateRequired(appointment.Key_Town__c) && EON_Utility.validateRequired(appointment.Key_Dependant_Locality__c) && EON_Utility.validateRequired(appointment.Key_Double_Dependant_Locality__c) && EON_Utility.validateRequired(appointment.Key_Thorofare__c) && EON_Utility.validateRequired(appointment.Key_Dependant_Thorofare__c) && EON_Utility.validateRequired(appointment.Key_County__c) && EON_Utility.validateRequired(appointment.Key_Post_Code__c) && EON_Utility.validateRequired(appointment.Key_Country__c)){}
                            else{
                                if((appointment.Key_Person_Name__c +string.valueof(appointment.Key_Contact_Number__c) + appointment.Key_Building_Number__c + appointment.Key_Sub_Building_Name__c + appointment.Key_Building_Name__c + appointment.Key_Town__c + appointment.Key_Dependant_Locality__c + appointment.Key_Double_Dependant_Locality__c + appointment.Key_Thorofare__c + appointment.Key_Dependant_Thorofare__c + appointment.Key_County__c + appointment.Key_Post_Code__c  + appointment.Key_Country__c) != ''){//CH08
                                    appointment.Key_Collection_Required__c = true;
                                }
                            }
                            if(EON_Utility.validateRequired(ConfirmBooking.AppointmentDetails.Note) != true){
                                /*Eon_Appointment_Notes__c apptNotes;
                                aapNotesLst = new list<Eon_Appointment_Notes__c>();
                                for(String NE : ConfirmBooking.AppointmentDetails.Notes.Note){
                                    if(EON_Utility.validateRequired(NE) != true){
                                        apptNotes = new Eon_Appointment_Notes__c(MUSAppointmentID__c = appointment.id ,Notes__c = NE);
                                        aapNotesLst.add(apptNotes);
                                    }
                                }*///CH06.old
                                
                                appointment.Notes__c=EON_Utility.validateRequired(appointment.Notes__c)?ConfirmBooking.AppointmentDetails.Note.trim():appointment.Notes__c+','+ConfirmBooking.AppointmentDetails.Note.trim();//CH06
                                
                                //CH17.Start
                                if(!EON_Utility.validateRequired(appointment.Current_Phase__c) && !EON_Utility.validateRequired(appointment.h_OFSC_Number_of_Phases__c)){
                                   if(appointment.Current_Phase__c=='3Ph' && appointment.h_OFSC_Number_of_Phases__c=='1'){
                                        string addNote = 'Appt involves change of phase at property from 3 to 1. Will require 3Ph technician';
                                           appointment.Notes__c = EON_Utility.validateRequired(appointment.Notes__c)?addNote:appointment.Notes__c+','+addNote;
                                    }
                                }
                                //CH17.End
                                
                            }
                            //Appointment Contact
                            set<string> ConTypeSet = new set<string>();
                            set<string> MediaDetailSet = new set<string>();
                            for(ContactElement CE :ConfirmBooking.Contacts.Contact){
                                if(CE.ContactTypeCode != null && CE.ContactTypeCode != '')
                                    ConTypeSet.add(CE.ContactTypeCode);
                                if(CE.MediaTypeCode != null && CE.MediaTypeCode != '')
                                    MediaDetailSet.add(CE.MediaTypeCode); 
                            }
                            list<EON_Contact_Type__c> conType;
                            if(ConTypeSet != null && ConTypeSet.size()>0){
                               conType = [select id,name,Code__c from EON_Contact_Type__c where Code__c =: ConTypeSet];
                               if( conType.size()<1) //CH10
                                Error= Error + '\n REJECTED - ContactTypeCode has unsupported standing data \n';//CH10
                                
                               }
                            map<string,EON_Contact_Type__c> mapConType; 
                            if(conType != null && conType.size()>0){
                                mapConType = new map<string,EON_Contact_Type__c>();
                                for(EON_Contact_Type__c ECT : conType){
                                    mapConType.put(ECT.Code__c,ECT);    
                                }
                            }
                            list<EON_Media_Type__c> medType;
                            if(MediaDetailSet != null && MediaDetailSet.size()>0){
                                medType = [select id,name,Code__c from EON_Media_Type__c where Code__c =:MediaDetailSet];
                                if(medType.size()<1 ) //CH10  
                                Error = Error + 'REJECTED - MediaTypeCode has unsupported standing data \n';//CH10    
                            
                            }
                            map<string,EON_Media_Type__c> mapMediaType; 
                            if(medType != null && medType.size()>0){
                                mapMediaType = new map<string,EON_Media_Type__c>();
                                for(EON_Media_Type__c EMT : medType){
                                    mapMediaType.put(EMT.Code__c,EMT);  
                                }
                            }   
                            for(ContactElement CE :ConfirmBooking.Contacts.Contact){
                                String ContFullName,MediaDetail,MediaType,ContactTypeCode;
                                MediaType = CE.MediaTypeCode;
                                ContactTypeCode = CE.ContactTypeCode;
                                EON_Appointment_Contact__c contact;
                                //implement through map not correct:
                                contact = new EON_Appointment_Contact__c(Contact_Full_Name__c = CE.ContactName,EON_Appointment_ID__c = appointment.id,Media_Detail__c = CE.MediaDetail); 
                                if(mapConType != null && mapConType.containsKey(ContactTypeCode)){
                                    contact.Contact_Type__c = mapConType.get(ContactTypeCode).id;
                                }
                                if(mapMediaType != null && mapMediaType.containsKey(MediaType)){
                                    contact.Media_Type__c = mapMediaType.get(MediaType).id;
                                }
                                contactLstInst.add(contact);
                            }
                            //Meter location:
                            set<string> E_LocSet = new set<string>();
                            set<string> G_LocSet = new set<string>();//CH10
                            for(MeterLocationElement MLE : ConfirmBooking.MeterLocations.MeterLocation){
                                 if(MLE.FuelTypeCode=='E') E_LocSet.add(MLE.LocationCode);
                                 if(MLE.FuelTypeCode=='G') G_LocSet.add(MLE.LocationCode);//CH10
                            }
                            map<string,EON_Electric_Meter_Location__c> mapELoc = new map<string,EON_Electric_Meter_Location__c>();
                            map<string,EON_Gas_Meter_Location__c> mapGLoc = new map<string,EON_Gas_Meter_Location__c>();
                            list<EON_Electric_Meter_Location__c> EMLlst = new list<EON_Electric_Meter_Location__c>();
                            list<EON_Gas_Meter_Location__c> EGLlst = new list<EON_Gas_Meter_Location__c>();
                            if(E_LocSet != null && E_LocSet.size()>0){
                                EMLlst = [select id,name,Code__c from EON_Electric_Meter_Location__c where Code__c =: E_LocSet];
                            }
                            if(G_LocSet != null && G_LocSet.size()>0){
                                EGLlst = [select id,name,Code__c from EON_Gas_Meter_Location__c where Code__c =: G_LocSet];
                            }
                            if(EMLlst != null && EMLlst.size()>0){
                                for(EON_Electric_Meter_Location__c EML : EMLlst){
                                    mapELoc.put(EML.Code__c,EML);
                                }
                            }
                            if(EGLlst != null && EGLlst.size()>0){
                                for(EON_Gas_Meter_Location__c EGL : EGLlst){
                                    mapGLoc.put(EGL.Code__c,EGL);
                                }
                            }
                            for(MeterLocationElement MLE : ConfirmBooking.MeterLocations.MeterLocation){
                                if(MLE.FuelTypeCode == 'E'){
                                    if(mapELoc != null && mapELoc.containsKey(MLE.LocationCode)){
                                        appointment.E_Meter_Location__c = mapELoc.get(MLE.LocationCode).id;
                                    }
                                     if(EMLlst.size()<1) //CH10
                                     Error = Error + 'REJECTED - ElectricMeterLocationCode has unsupported standing data \n';//CH10
                                }   
                                if(MLE.FuelTypeCode == 'G'){
                                    if(mapGLoc != null && mapGLoc.containsKey(MLE.LocationCode)){
                                        appointment.G_Meter_Location__c = mapGLoc.get(MLE.LocationCode).id;
                                    }   
                                    
                                     if(EGLlst.size()<1) //CH10
                                        Error = Error + 'REJECTED - GasMeterLocationCode has unsupported standing data \n';//CH10
                                }
                            }
                            //EON Appointment Comms
                            //EON Appointment Comms are optional now. CH11
                            if(ConfirmBooking.CommunicationTypes != null && ConfirmBooking.CommunicationTypes.CommunicationType != null){
                                set<string> EDMset = new set<string>();
                                for(CommunicationTypeElement CTE : ConfirmBooking.CommunicationTypes.CommunicationType){
                                    EDMset.add(CTE.DeliveryMethod);
                                }
                                list<Eon_Delivery_Method__c> EDMlst = new list<Eon_Delivery_Method__c>();
                                Map<string,Eon_Delivery_Method__c> mapEDM = new Map<string,Eon_Delivery_Method__c>();
                                if(EDMset != null && EDMset.size()>0){
                                    EDMlst = [select id,name,Code__c from Eon_Delivery_Method__c where Code__c =:EDMset];
                                    if(EDMlst != null && EDMlst.size()>0){
                                        for(Eon_Delivery_Method__c EDM : EDMlst){
                                            mapEDM.put(EDM.Code__c, EDM);
                                        }
                                    }
                                    else{
                                    if(EDMlst.size()<1)//CH10
                                    Error= Error + 'REJECTED - DeliveryMethod has unsupported standing data \n';//CH10
                                    }
                                }
                            for(CommunicationTypeElement CTE : ConfirmBooking.CommunicationTypes.CommunicationType){
                                
                                if(CTE.CommTypeCode=='R' ||CTE.CommTypeCode=='C' || CTE.CommTypeCode=='I' ) //CH10
                                {
                                EON_Appointment_Comms__c apptComm = new EON_Appointment_Comms__c(Comm_Type_Code__c = CTE.CommTypeCode,EON_Appointment_ID__c = appointment.id);
                                
                                //if(apptComm.Comm_Type_Code__c == null) //CH10
                                //Error= Error + 'REJECTED - CommTypeCode has unsupported standing data \n';//CH10
                                
                                if(mapEDM != null && mapEDM.containsKey(CTE.DeliveryMethod))
                                apptComm.Delivery_Method_Desc__c = mapEDM.get(CTE.DeliveryMethod).id;
                                commLst.add(apptComm);
                                }
                             
                                else
                                Error = Error +  'REJECTED - CommTypeCode has unsupported standing data \n';//CH10
                                }
                          }//CH11
                            
                            list<EON_Parking__c> par = [select id,name,Parking_Code__c,OFS_Enumeration__c from EON_Parking__c where Parking_Code__c =: ConfirmBooking.Parking.ParkingTypeCode limit 1]; //as only one is expected to be received
                            if(par != null && par.size()>0){
                                appointment.Parking_Type__c = par[0].id;
                                OFS_Enumeration = integer.valueof(par[0].OFS_Enumeration__c);
                            } 
                            
                            else{
                             if(par.size()<1)//CH10
                                Error= Error + 'REJECTED - ParkingTypeCode has unsupported standing data \n';//CH10
                                
                                } 
                            //EON Appointment Vulnerabilities:
                            set<String> existingVul = new set<String>();
                            set<String> existingValInReq = new set<String>();
                            list<VulnerabilityElement> processVulElement = new list<VulnerabilityElement>();
                            set<Integer> vulSet = new set<Integer>();
                            list<EON_Vulnerability_Code__c> EVClst = new list<EON_Vulnerability_Code__c>();
                            list<EON_Appointment_Vulnerability__c> EAVlist = new list<EON_Appointment_Vulnerability__c>();
                            Map<Integer,EON_Vulnerability_Code__c> mapEVC = new Map<Integer,EON_Vulnerability_Code__c>();
                            
                            //get all existing values
                            for(EON_Appointment_Vulnerability__c apv: appointment.EON_Appointment_Vulnerabilities__r){
                                String addToSet = !EON_Utility.validateRequired(apv.VulnerabilityDetailCode__c) ? String.valueOf(apv.VulnerabilityDetailCode__c) : '';
                                addToSet = addToSet + (!EON_Utility.validateRequired(apv.VulnerabilityTypeID__c) ? (apv.VulnerabilityTypeID__c == 'Customer level'?'1':(apv.VulnerabilityTypeID__c == 'Household level'?'2':'')) : '');
                                if(!EON_Utility.validateRequired(addToSet))
                                    existingVul.add(addToSet);
                            }
                            //get all unique from request
                            if(EON_Utility.validateRequired(ConfirmBooking.Vulnerabilities)!=true){
                                if(EON_Utility.validateRequired(ConfirmBooking.Vulnerabilities.Vulnerability) != true){
                                    for(VulnerabilityElement VE : ConfirmBooking.Vulnerabilities.Vulnerability){
                                        String addToSet = !EON_Utility.validateRequired(VE.VulnerabilityDetailCode) ? VE.VulnerabilityDetailCode : '';
                                        addToSet = addToSet + (!EON_Utility.validateRequired(VE.VulnerabilityTypeId) ? String.valueOf(VE.VulnerabilityTypeId) : '');
                                        if(!EON_Utility.validateRequired(addToSet)){
                                            if(existingVul.contains(addToSet) == false && existingValInReq.contains(addToSet) == false){
                                                existingValInReq.add(addToSet);
                                                vulSet.add(Integer.valueof(VE.VulnerabilityDetailCode));
                                                processVulElement.add(VE);
                                            }
                                        }
                                    }
                                }
                            }
                            if(vulSet != null && vulSet.size()>0){
                                EVClst = [select id,name,Vulnerability_Code__c from EON_Vulnerability_Code__c where Vulnerability_Code__c =:vulSet]; //CH04 CH09.New
                                if(EVClst.size() != vulSet.size())//CH10
                                         Error = Error + 'REJECTED - VulnerabilityDetailCode has unsupported standing data \n';//CH10 
                                else if(EVClst != null && EVClst.size()>0){
                                    for(EON_Vulnerability_Code__c EVC : EVClst){
                                        mapEVC.put(Integer.valueof(EVC.Vulnerability_Code__c),EVC);
                                    }
                                }
                            }
                            system.debug('####Error### '+Error);
                            if(Error == ''){
                                for(VulnerabilityElement VE : processVulElement){
                                    EON_Appointment_Vulnerability__c appVul = new EON_Appointment_Vulnerability__c();
                                    appVul.EON_Appointment_ID__c = appointment.id;
                                    appVul.VulnerabilityTypeID__c = (VE.VulnerabilityTypeId == 1 ?'Customer level':(VE.VulnerabilityTypeId == 2?'Household level':''));
                                    if(appVul.VulnerabilityTypeID__c=='' || appVul.VulnerabilityTypeID__c==null)
                                        Error = Error +'REJECTED - VulnerabilityTypeID has unsupported standing data \n'; 
                                    appVul.VulnerabilityDetailCode__c = Integer.valueof(VE.VulnerabilityDetailCode);
                                    appVul.Description__c = mapEVC.get(Integer.valueof(VE.VulnerabilityDetailCode)).id;
                                    if(Error == '')
                                        apptVulLst.add(appVul);
                                }
                            }
                            //yet to be decided
                            //Fix for ConfirmBooking.DataCaptureConsents as optonal
                            if(ConfirmBooking.DataCaptureConsents != null){
                                if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.ElecHHDataOpted)!=true)
                                    appointment.Elec_HH_Data_Opted__c = (ConfirmBooking.DataCaptureConsents.ElecHHDataOpted.trim().equalsIgnoreCase('Y')?true:false);
                                if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.ElecDailyDataOpted)!=true)   
                                    appointment.Elec_Daily_Data_Opted__c = (ConfirmBooking.DataCaptureConsents.ElecDailyDataOpted.trim().equalsIgnoreCase('Y')?true:false);
                                if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.GasHHDataOpted)!=true)
                                    appointment.Gas_HH_Data_Opted__c = (ConfirmBooking.DataCaptureConsents.GasHHDataOpted.trim().equalsIgnoreCase('Y')?true:false);
                                if(EON_Utility.validateRequired(ConfirmBooking.DataCaptureConsents.GasDailyDataOpted)!=true)
                                    appointment.Gas_Daily_Data_Opted__c = (ConfirmBooking.DataCaptureConsents.GasDailyDataOpted.trim().equalsIgnoreCase('Y')?true:false);
                            }
                            /* CH05
                            appointment.EONSetDisconnectOptIn__c = (ConfirmBooking.PAYGAlertPreferences.EONSetDisconnectOpted.trim().equalsIgnoreCase('Y')?true:false); 
                            appointment.CustomerLowBalanceAlertOpted__c = (ConfirmBooking.PAYGAlertPreferences.CustomerLowBalanceAlertOpted.trim().equalsIgnoreCase('Y')?true:false);
                            appointment.TopUpCodeNotifyFailureOpted__c = (ConfirmBooking.PAYGAlertPreferences.TopUpCodeNotifyFailureOpted.trim().equalsIgnoreCase('Y')?true:false); 
                            appointment.PaymentReminderOpted__c = (ConfirmBooking.PAYGAlertPreferences.PaymentReminderOpted.trim().equalsIgnoreCase('Y')?true:false); 
                            //
                            appointment.LowBalanceAlertValue__c = ConfirmBooking.PAYGAlertPreferences.LowBalanceAlertValue;
                            appointment.PaymentReminderFrequency__c = ConfirmBooking.PAYGAlertPreferences.PaymentReminderFrequency.trim();
                            appointment.PaymentReminderDayOfTheWeek__c = ConfirmBooking.PAYGAlertPreferences.PaymentReminderDayOfTheWeek.trim();
                            appointment.PaymentReminderDayOfTheMonth__c  = validateStringLen(ConfirmBooking.PAYGAlertPreferences.PaymentReminderDateOfTheMonth.trim(),10);
                            *///CH06.old
                            //Calling OFSC
                            string bookingSystem = 'EON';
                            
                            //CH15.Start
                            if(ConfirmBooking.WANCoverageDetails != null){
                                appointment.CSP_Region__c = ConfirmBooking.WANCoverageDetails.CSPRegion;
                                appointment.Coverage_Availability__c = 
                                                            ConfirmBooking.WANCoverageDetails.CoverageAvailability;
                                appointment.Comms_Hub_Variant__c = ConfirmBooking.WANCoverageDetails.CommsHubVariant;
                                appointment.Connectivity_Likelihood__c = 
                                                            ConfirmBooking.WANCoverageDetails.ConnectivityLikelihood;
                                appointment.Auxiliary_Equipment_required__c = 
                                                            ConfirmBooking.WANCoverageDetails.AuxiliaryEquipmentrequired;
                                appointment.WAN_Additional_Information__c = 
                                                            ConfirmBooking.WANCoverageDetails.AdditionalInformation;
                            }
                            //CH15.end                            
                            
                            system.debug('------------->>'+ appointment.Confirmed_Appointment_DateTime__c );
                            system.debug('-------------Error>>'+ Error );
                            if(appointment.Confirmed_Appointment_DateTime__c == null){
                                if(Error == ''){
                                    system.debug('-------------Error1>>'+ Error );
                                    Error = EON_OFSC_Update_Appointment.sendActivityToOFSC(appointment,contactLstInst,apptVulLst,bookingSystem);
                                    oracTracker = EON_OFSC_Update_Appointment.requestOut;
                                    system.debug('-------------Error2>>'+ Error );
                                    system.debug('-------------oracTracker>>'+ oracTracker);
                                }   
                                if(Error == 'Job sent to OFSC successfully'){
                                    Error = '';
                                    //Savepoint sp = Database.setSavepoint();
                                    //try{
                                        appointment = EON_OFSC_Update_Appointment.objAppt;
                                        appointment.Confirmed_Appointment_DateTime__c = system.now();
                                        Update appointment;
                                        if(contactLstInst != null && contactLstInst.size()>0)
                                            insert contactLstInst;
                                       /* if(aapNotesLst != null && aapNotesLst.size()>0)
                                            insert aapNotesLst; */ //CH06.old
                                        if(commLst != null && commLst.size()>0)
                                            insert commLst; 
                                        if(apptVulLst != null && apptVulLst.size()>0)
                                            insert apptVulLst;
                                    //}catch(DMLException e){
                                    //    Database.rollback(sp);
                                    //    Error = Error + e.getMessage() + '\n';
                                    //}
                                    //insert all list now;
                                }
                            }
                        } 
                        else{
                            system.debug('---->>>Rejected');
                            Error = 'Appointment can\'t be updated,Required field missing: Post Code or Metering Point Postcode or Job Code or Oracle Address\n';
                        }
                        //
                    }else{
                       Error = Error + 'REJECTED AppointmentID does not match active appointments';
                    }
                    //Success Scenario:
                    if(Error == ''){
                        response.header = ConfirmBooking.header;
                        response.header.orgId = system.label.EON_Sanbox_Name;//UserInfo.getOrganizationId();
                        response.ConfirmBookingDate = appointment.Appointment_Date__c ;
                        response.ExternalAppointmentID  = ConfirmBooking.AppointmentDetails.ExternalAppointmentID.trim() ;
                        response.EONAppointmentID  = ConfirmBooking.AppointmentDetails.EONAppointmentID.trim() ;
                        eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                        eonTracker.Status__c = EON_Utility.RESULT_PASS;
                        errMessage msg = new errMessage();
                        msg.MessageType = 'Information';
                        msg.MessageId = 0;
                        msg.MessageText = 'Request processed Successfully.';
                        msgLst.add(msg);
                        errorlst.Message = msgLst;
                        response.Messages = errorlst;
                    }                   
                }
                if(Error != ''){
                    errMessage msg = new errMessage();
                    msg.MessageType = 'Exception';
                    msg.MessageId = 1;
                    msg.MessageText = Error;//'Appointment can\'t be updated, Please contact your administrator.';
                    msgLst.add(msg);
                    errorlst.Message = msgLst;
                    response.Messages = errorlst;
                    response.header = ConfirmBooking.header;
                    response.header.orgId = system.label.EON_Sanbox_Name;
                    eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                    eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                    eonTracker.Error__c = Error;
                }
            } 
            else{
                Error = 'Request Not Found';
                errMessage msg = new errMessage();
                msg.MessageType = 'Exception';
                msg.MessageId = 1;
                msg.MessageText = 'Appointment can\'t be updated, Please contact your administrator.';
                msgLst.add(msg);
                errorlst.Message = msgLst;
                response.Messages = errorlst;
                eonTracker.Request_Data__c = 'Blank Request';
                eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                eonTracker.Error__c = Error;
            }
        }catch(Exception ex){
            Error = ex.getmessage();
            System.debug('**** Exception Occured '+ex.getmessage()+'----' + ex.getStackTraceString());
            errMessage msg = new errMessage();
            msg.MessageType = 'Exception';
            msg.MessageId = 1;
            msg.MessageText = 'Appointment can\'t be updated, Please contact your administrator.';
            msgLst.add(msg);
            errorlst.Message = msgLst;
            response.Messages = errorlst;
            response.header = ConfirmBooking.header;
            response.header.orgId = system.label.EON_Sanbox_Name;
            eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
            eonTracker.Status__c = EON_Utility.RESULT_FAIL;
            eonTracker.Error__c = Error;
        }    
        Insert eonTracker;
        if(oracTracker != null && oracTracker.id != null){
            oracTracker.EON_Data_Tracker__c = eonTracker.id;
            update oracTracker;
        }
        EON_Utility.createAttachment(eonTracker.id, eonTracker.Request_Data__c, eonTracker.id);
        system.debug('---got here--');
        return response; 
    }   
}