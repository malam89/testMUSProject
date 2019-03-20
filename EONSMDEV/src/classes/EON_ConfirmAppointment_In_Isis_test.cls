/**
    Description : This test class covers the code coverage for below class
        1. EON_ConfirmAppointment_In_Isis_WS 
**/
/*
    Created By : Nitin Bangar
    Created Date : 31-March-2016
    Service Request : SR_EON_AB_025
    CH01 # SR_EON_Jumbo_030 # 09/06/2016 # Mehbobo Alam # Added  'Vulnerability Source' field value.
    CH02 # SR_EON_AB_072 # 16/06/2016 # Shruti Moghe # Updated logic for WSDL as per the SR
    CH03 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Deleted reference of field Vulnerability_Source__c
    CH04 # SR_EON_AB_166 # 17/09/2016 # Mahadev J # An update from should be rejected with error if appointment not sent to Oracle
    CH05 # SR_OptiMUS_EON_112  # 12/09/2016 # Praveen G # Test for new fields added.
*/

@isTest
global class EON_ConfirmAppointment_In_Isis_test implements WebServiceMock{
    public static string methodName = '';
    /**
        UpdateAppointment_to_Isis_Pass() - postitive Unit test for the method ConfirmAppointment ParkingTypeCode
    **/
    static testmethod void UpdateAppointment_to_Isis_Succ(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false);
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__C = '1234',Post_Code__c = 'sg1 2st',Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,mpan__C,Post_Code__c,Job_Code__c ,Oracle_Address__c ,name from EON_Appointment__c where id =: appt.id];
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
        /*list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');  */
        //CH02   
        /*
        List<EON_ConfirmAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_ConfirmAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/
        
        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = 'Mark';
        keyCollElem.ContactNumber = '9826012345';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = 'MUS-12881';
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = 'Location Loc';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';
        /*
        EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = 'A1'; 
        paygElem.CustomerLowBalanceAlertOpted = 'B1';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = 'C1';
        paygElem.PaymentReminderOpted = 'D1';
        paygElem.PaymentReminderFrequency = 'E1';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*/ //CH02.old
        
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;        
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        
        
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    /**
        UpdateAppointment_to_Isis_Pass() - postitive Unit test for the method ConfirmAppointment ParkingTypeCode
    **/
    static testmethod void UpdateAppointment_to_Isis_Pass(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =true);
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__C = '1234',Post_Code__c = 'sg1 2st',Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,mpan__c,Post_Code__c,Job_Code__c ,Oracle_Address__c ,name from EON_Appointment__c where id =: appt.id];
        
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 1);
        insert aVul;
        
        EON_Appointment_Vulnerability__c vul123 = [select VulnerabilityDetailCode__c,EON_Appointment_ID__c from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c =: app.id AND VulnerabilityDetailCode__c =: 1];
        
        EON_Contact_Type__c EC = new EON_Contact_Type__c(Name = 'test1' , Code__c = 'A');
        insert EC;
        EON_Media_Type__c MT = new EON_Media_Type__c(Name = 'test1' , Code__c = 'B');
        insert MT;
        
        EON_Electric_Meter_Location__c EML = new EON_Electric_Meter_Location__c(Name = 'test12',Code__c = 'AB');
        insert EML;
        EON_Gas_Meter_Location__c EGML = new EON_Gas_Meter_Location__c(Name = 'test12',Code__c = 'CD');
        insert EGML;
        
        Eon_Delivery_Method__c  EDM = new Eon_Delivery_Method__c(Name = 'test12',Code__c = 'M');
        insert EDM;
        
        EON_Parking__c park = new EON_Parking__c(Name = 'test park', Parking_Code__c = 'P',OFS_Enumeration__c = 1);
        insert park;
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
         /*list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');  */
        //CH02   
       /*
        List<EON_ConfirmAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_ConfirmAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/
        
        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = 'Mark';
        keyCollElem.ContactNumber = '9826012345';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '01336';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';
        /*
        EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = 'A1'; 
        paygElem.CustomerLowBalanceAlertOpted = 'B1';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = 'C1';
        paygElem.PaymentReminderOpted = 'D1';
        paygElem.PaymentReminderFrequency = 'E1';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*/ //CH02.old
        
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;        
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        
        
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    /**
        UpdateAppointment_to_Isis_Pass1() - postitive Unit test for the method ConfirmAppointment ParkingTypeCode
    **/
    static testmethod void UpdateAppointment_to_Isis_Pass1(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false, Job_Type__c='SMART' );
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__C = '1234',Job_Code__c = jobcode.id,Post_Code__c ='Sg11qs',Metering_Point_Address_Line_2__c = 'Address line one');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,mpan__c,Post_Code__c,Job_Code__c ,Oracle_Address__c ,name from EON_Appointment__c where id =: appt.id];
        
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 1);
        insert aVul;
        
        //EON_Vulnerability_Code__c vc = new EON_Vulnerability_Code__c(Vulnerability_Code__c = 3, Vulnerability_Source__c='EON'); //CH01 CH03.Old
        EON_Vulnerability_Code__c vc = new EON_Vulnerability_Code__c(Vulnerability_Code__c = 3); //CH01 CH03.New
        insert vc;
        
        EON_Contact_Type__c EC = new EON_Contact_Type__c(Name = 'test1' , Code__c = 'A');
        insert EC;
        EON_Media_Type__c MT = new EON_Media_Type__c(Name = 'test1' , Code__c = 'B');
        insert MT;
        
        EON_Electric_Meter_Location__c EML = new EON_Electric_Meter_Location__c(Name = 'test12',Code__c = 'AB');
        insert EML;
        EON_Gas_Meter_Location__c EGML = new EON_Gas_Meter_Location__c(Name = 'test12',Code__c = 'CD');
        insert EGML;
        
        Eon_Delivery_Method__c  EDM = new Eon_Delivery_Method__c(Name = 'test12',Code__c = 'M');
        insert EDM;
        
        EON_Parking__c park = new EON_Parking__c(Name = 'test park', Parking_Code__c = 'P',OFS_Enumeration__c = 1);
        insert park;
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '3' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
        /*list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');  */
        //CH02   
        
        /*
        List<EON_ConfirmAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_ConfirmAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/
        
        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = 'Mark';
        keyCollElem.ContactNumber = '9826012345';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';
        /*
        EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = 'A1'; 
        paygElem.CustomerLowBalanceAlertOpted = 'B1';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = 'C1';
        paygElem.PaymentReminderOpted = 'D1';
        paygElem.PaymentReminderFrequency = 'E1';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*/ //CH02.old
        
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;      
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        
        
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }  
    
    /**
        UpdateAppointment_to_Isis_Pass2() - postitive Unit test for the method ConfirmAppointment
    **/

    static testmethod void UpdateAppointment_to_Isis_Pass2(){
        test.startTest();
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
         /*list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');  */
        //CH02   
        /*
        List<EON_ConfirmAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_ConfirmAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/

            
        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = '';
        keyCollElem.ContactNumber = 'test';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = '';
        apptDetailElem.EONAppointmentID = null;
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = '';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'CD321';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'LOC5445';         
        mtrLocElem.FuelTypeCode = '';  

        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = '';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = ''; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = ''; 
        dataCapElem.ElecDailyDataOpted = '';
        dataCapElem.GasHHDataOpted = '';
        dataCapElem.GasDailyDataOpted = '';
        /*
        EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = ''; 
        paygElem.CustomerLowBalanceAlertOpted = '';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = '';
        paygElem.PaymentReminderOpted = '';
        paygElem.PaymentReminderFrequency = '';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*/ //CH02.old
        
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vulElem = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();    
        vulElem.VulnerabilityDetailCode = 'test112'; 
        vulElem.VulnerabilityTypeId = null; 
        
        List<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> lstvulElem = new List<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        lstvulElem.add(vulElem);
        
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vulLst = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();    
        vulLst.Vulnerability = lstvulElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;        
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vulLst;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        
        
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Pass3() - postitive Unit test for the method ConfirmAppointment
    **/
    
    static testmethod void UpdateAppointment_to_Isis_Pass3(){
        test.startTest();
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
         /*list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');  */
        //CH02   
        
        /*
        List<EON_ConfirmAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_ConfirmAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/

        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = '';
        keyCollElem.ContactNumber = '';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = '';
        apptDetailElem.EONAppointmentID = null;
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'ec1231';              
        conElem.ContactName = '';
        conElem.MediaTypeCode = 'CD321';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = '';         
        mtrLocElem.FuelTypeCode = 'F1';  

        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = '';
        commTypeElem.DeliveryMethod = 'D12';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = ''; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = ''; 
        dataCapElem.ElecDailyDataOpted = '';
        dataCapElem.GasHHDataOpted = '';
        dataCapElem.GasDailyDataOpted = '';
        /*
        EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = ''; 
        paygElem.CustomerLowBalanceAlertOpted = '';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = '';
        paygElem.PaymentReminderOpted = '';
        paygElem.PaymentReminderFrequency = '';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*/ //CH02.old
        
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vulElem = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();    
        vulElem.VulnerabilityDetailCode = ''; 
        vulElem.VulnerabilityTypeId = 3214456; 
        
        List<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> lstvulElem = new List<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        lstvulElem.add(vulElem);
        
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vulLst = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();    
        vulLst.Vulnerability = lstvulElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;        
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vulLst;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        
        
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Pass4() - postitive Unit test for the method ConfirmAppointment
    **/
    
    static testmethod void UpdateAppointment_to_Isis_Pass4(){
        test.startTest();
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
         /*list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');  */
        //CH02   
        /*
        List<EON_ConfirmAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_ConfirmAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/

        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = '';
        keyCollElem.ContactNumber = '';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = '';
        apptDetailElem.EONAppointmentID = null;
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'ec1231';              
        conElem.ContactName = 'Name1';
        conElem.MediaTypeCode = '';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = '';         
        mtrLocElem.FuelTypeCode = 'F1';  

        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = '';
        commTypeElem.DeliveryMethod = 'D12';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = ''; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = ''; 
        dataCapElem.ElecDailyDataOpted = '';
        dataCapElem.GasHHDataOpted = '';
        dataCapElem.GasDailyDataOpted = '';
        /*
        EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = ''; 
        paygElem.CustomerLowBalanceAlertOpted = '';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = '';
        paygElem.PaymentReminderOpted = '';
        paygElem.PaymentReminderFrequency = 'M';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        //paygElem.PaymentReminderDateOfTheMonth = 'G1';*/ //CH02.old
        
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vulElem = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();    
        vulElem.VulnerabilityDetailCode = ''; 
        vulElem.VulnerabilityTypeId = 3214456; 
        
        List<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> lstvulElem = new List<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        lstvulElem.add(vulElem);
        
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vulLst = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();    
        vulLst.Vulnerability = lstvulElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;       
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vulLst;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        
        
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Pass5() - postitive Unit test for the method ConfirmAppointment
    **/
    
    static testmethod void UpdateAppointment_to_Isis_Pass5(){
        test.startTest();
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
        /*list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');  */
        //CH02   
        /*
        List<EON_ConfirmAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_ConfirmAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/

        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = '';
        keyCollElem.ContactNumber = '';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = '';
        apptDetailElem.EONAppointmentID = null;
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'ec1231';              
        conElem.ContactName = 'Name1';
        conElem.MediaTypeCode = 'M121';
        conElem.MediaDetail = '';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = '';         
        mtrLocElem.FuelTypeCode = 'F1';  

        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = '';
        commTypeElem.DeliveryMethod = 'D12';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = ''; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = ''; 
        dataCapElem.ElecDailyDataOpted = '';
        dataCapElem.GasHHDataOpted = '';
        dataCapElem.GasDailyDataOpted = '';
        /*
        EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_ConfirmAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = ''; 
        paygElem.CustomerLowBalanceAlertOpted = 'Y';
        //paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = '';
        paygElem.PaymentReminderOpted = '';
        paygElem.PaymentReminderFrequency = 'W';
        //paygElem.PaymentReminderDayOfTheWeek = 'F1';
        //paygElem.PaymentReminderDateOfTheMonth = 'G1';*/ //CH02.old
        
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vulElem = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();    
        vulElem.VulnerabilityDetailCode = ''; 
        vulElem.VulnerabilityTypeId = 3214456; 
        
        List<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> lstvulElem = new List<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        lstvulElem.add(vulElem);
        
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vulLst = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();    
        vulLst.Vulnerability = lstvulElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;       
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vulLst;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        
        
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Fail1() - Negative Unit test for the method ConfirmAppointment covering Catch block.    
    **/
    static testMethod void UpdateAppointment_to_Isis_Fail1() {          
        test.startTest();
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
        updAppt.Header = header;
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt);
        System.assert(response != null);                                     
        test.stopTest();
    }  
    
    /**
        UpdateAppointment_to_Isis_Fail2() - Negative Unit test for the method ConfirmAppointment, When Error = 'Request Not Found'
    **/
    static testMethod void UpdateAppointment_to_Isis_Fail2() {          
        test.startTest();
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt;
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt);
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    static testmethod void UpdateAppointment_to_Isis_Pass_A(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =true,Job_Type__c='SMART');
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__C = '1234',Post_Code__c = 'sg1 2st',Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,mpan__c,Post_Code__c,Job_Code__c ,Oracle_Address__c ,name from EON_Appointment__c where id =: appt.id];
        
        EON_Vulnerability_Code__c code = new EON_Vulnerability_Code__c(Vulnerability_Code__c=1);
        insert code;
        
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 4);
        insert aVul;
        
        EON_Appointment_Vulnerability__c vul123 = [select VulnerabilityDetailCode__c,EON_Appointment_ID__c from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c =: app.id AND VulnerabilityDetailCode__c =: 4];
        
        EON_Contact_Type__c EC = new EON_Contact_Type__c(Name = 'test1' , Code__c = 'A');
        insert EC;
        EON_Media_Type__c MT = new EON_Media_Type__c(Name = 'test1' , Code__c = 'B');
        insert MT;
        
        EON_Electric_Meter_Location__c EML = new EON_Electric_Meter_Location__c(Name = 'test12',Code__c = 'AB');
        insert EML;
        EON_Gas_Meter_Location__c EGML = new EON_Gas_Meter_Location__c(Name = 'test12',Code__c = 'CD');
        insert EGML;
        
        Eon_Delivery_Method__c  EDM = new Eon_Delivery_Method__c(Name = 'test12',Code__c = 'M');
        insert EDM;
        
        EON_Parking__c park = new EON_Parking__c(Name = 'test park', Parking_Code__c = 'P',OFS_Enumeration__c = 1);
        insert park;
        
        test.startTest();
        //EON_ConfirmAppointment_In_Isis_test.methodName = '';
        Test.setMock(WebServiceMock.class, new EON_ConfirmAppointment_In_Isis_test()); // mock request
        //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();   
        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = 'Mark';
        keyCollElem.ContactNumber = '132556';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '0131';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'R';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement(); 
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';     
      
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;       
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        

        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        keyCollElem.PersonName = 'test';
        keyCollElem.ContactNumber = '';
        updAppt.AppointmentDetails = apptDetailElem;
        response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Fail_A(): This method is used for failure scenario - RequestedSSC is required.
    **/
    static testmethod void UpdateAppointment_to_Isis_Fail_A(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =true,Job_Type__c='SMART');
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__C = '1234',Post_Code__c = 'sg1 2st',Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,mpan__c,Post_Code__c,Job_Code__c ,Oracle_Address__c ,name from EON_Appointment__c where id =: appt.id];
        
        EON_Vulnerability_Code__c code = new EON_Vulnerability_Code__c(Vulnerability_Code__c=1);
        insert code;
        
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 4);
        insert aVul;
        
        EON_Appointment_Vulnerability__c vul123 = [select VulnerabilityDetailCode__c,EON_Appointment_ID__c from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c =: app.id AND VulnerabilityDetailCode__c =: 4];
        
        EON_Contact_Type__c EC = new EON_Contact_Type__c(Name = 'test1' , Code__c = 'A');
        insert EC;
        EON_Media_Type__c MT = new EON_Media_Type__c(Name = 'test1' , Code__c = 'B');
        insert MT;
        
        EON_Electric_Meter_Location__c EML = new EON_Electric_Meter_Location__c(Name = 'test12',Code__c = 'AB');
        insert EML;
        EON_Gas_Meter_Location__c EGML = new EON_Gas_Meter_Location__c(Name = 'test12',Code__c = 'CD');
        insert EGML;
        
        Eon_Delivery_Method__c  EDM = new Eon_Delivery_Method__c(Name = 'test12',Code__c = 'M');
        insert EDM;
        
        EON_Parking__c park = new EON_Parking__c(Name = 'test park', Parking_Code__c = 'P',OFS_Enumeration__c = 1);
        insert park;
        
        test.startTest();
        //EON_ConfirmAppointment_In_Isis_test.methodName = '';
        Test.setMock(WebServiceMock.class, new EON_ConfirmAppointment_In_Isis_test()); // mock request
        //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();   
        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = 'Mark';
        keyCollElem.ContactNumber = '132556';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        //apptDetailElem.RequestedSSC = '0131';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'R';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement(); 
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';     
      
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;       
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        

        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        keyCollElem.PersonName = 'test';
        keyCollElem.ContactNumber = '';
        updAppt.AppointmentDetails = apptDetailElem;
        response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Fail_A1(): This method is used for failure scenario - Appointment can\'t be updated,Required field missing: 
        Post Code or Metering Point Postcode or Job Code or Oracle Address
    **/
    static testmethod void UpdateAppointment_to_Isis_Fail_A1(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =true,Job_Type__c='SMART');
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__C = '1234',/*Post_Code__c = 'sg1 2st',*/Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,mpan__c,Post_Code__c,Job_Code__c ,Oracle_Address__c ,name from EON_Appointment__c where id =: appt.id];
        
        EON_Vulnerability_Code__c code = new EON_Vulnerability_Code__c(Vulnerability_Code__c=1);
        insert code;
        
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 4);
        insert aVul;
        
        EON_Appointment_Vulnerability__c vul123 = [select VulnerabilityDetailCode__c,EON_Appointment_ID__c from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c =: app.id AND VulnerabilityDetailCode__c =: 4];
        
        EON_Contact_Type__c EC = new EON_Contact_Type__c(Name = 'test1' , Code__c = 'A');
        insert EC;
        EON_Media_Type__c MT = new EON_Media_Type__c(Name = 'test1' , Code__c = 'B');
        insert MT;
        
        EON_Electric_Meter_Location__c EML = new EON_Electric_Meter_Location__c(Name = 'test12',Code__c = 'AB');
        insert EML;
        EON_Gas_Meter_Location__c EGML = new EON_Gas_Meter_Location__c(Name = 'test12',Code__c = 'CD');
        insert EGML;
        
        Eon_Delivery_Method__c  EDM = new Eon_Delivery_Method__c(Name = 'test12',Code__c = 'M');
        insert EDM;
        
        EON_Parking__c park = new EON_Parking__c(Name = 'test park', Parking_Code__c = 'P',OFS_Enumeration__c = 1);
        insert park;
        
        test.startTest();
        //EON_ConfirmAppointment_In_Isis_test.methodName = '';
        Test.setMock(WebServiceMock.class, new EON_ConfirmAppointment_In_Isis_test()); // mock request
        //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();   
        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = 'Mark';
        keyCollElem.ContactNumber = '132556';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '0131';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'R';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement(); 
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';     
      
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;       
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        

        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        keyCollElem.PersonName = 'test';
        keyCollElem.ContactNumber = '';
        updAppt.AppointmentDetails = apptDetailElem;
        response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Fail_A2(): REJECTED - VulnerabilityTypeID has unsupported standing data
    **/
    static testmethod void UpdateAppointment_to_Isis_Fail_A2(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =true,Job_Type__c='SMART');
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__C = '1234',Post_Code__c = 'sg1 2st',Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,mpan__c,Post_Code__c,Job_Code__c ,Oracle_Address__c ,name from EON_Appointment__c where id =: appt.id];
        
        EON_Vulnerability_Code__c code = new EON_Vulnerability_Code__c(Vulnerability_Code__c=11);
        insert code;
        
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 4);
        insert aVul;
        
        EON_Appointment_Vulnerability__c vul123 = [select VulnerabilityDetailCode__c,EON_Appointment_ID__c from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c =: app.id AND VulnerabilityDetailCode__c =: 4];
        
        EON_Contact_Type__c EC = new EON_Contact_Type__c(Name = 'test1' , Code__c = 'A');
        insert EC;
        EON_Media_Type__c MT = new EON_Media_Type__c(Name = 'test1' , Code__c = 'B');
        insert MT;
        
        EON_Electric_Meter_Location__c EML = new EON_Electric_Meter_Location__c(Name = 'test12',Code__c = 'AB');
        insert EML;
        EON_Gas_Meter_Location__c EGML = new EON_Gas_Meter_Location__c(Name = 'test12',Code__c = 'CD');
        insert EGML;
        
        Eon_Delivery_Method__c  EDM = new Eon_Delivery_Method__c(Name = 'test12',Code__c = 'M');
        insert EDM;
        
        EON_Parking__c park = new EON_Parking__c(Name = 'test park', Parking_Code__c = 'P',OFS_Enumeration__c = 1);
        insert park;
        
        test.startTest();
        //EON_ConfirmAppointment_In_Isis_test.methodName = '';
        Test.setMock(WebServiceMock.class, new EON_ConfirmAppointment_In_Isis_test()); // mock request
        //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '11' ;
        vul.VulnerabilityTypeId = 11;
        list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();   
        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = 'Mark';
        keyCollElem.ContactNumber = '132556';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '0131';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'R';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement(); 
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';     
      
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;       
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05        

        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        keyCollElem.PersonName = 'test';
        keyCollElem.ContactNumber = '';
        updAppt.AppointmentDetails = apptDetailElem;
        response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
     /**
        UpdateAppointment_to_Isis_Pass_B() - postitive Unit test for the method UpdateAppointment 
    **/
    static testmethod void UpdateAppointment_to_Isis_Pass_B(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false, Job_Type__c='SMART');
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one',Post_Code__c = 'SG1 2ST');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,MPAN__c,Post_Code__c,Job_Code__c ,Oracle_Address__c,Sent_to_Oracle__c ,name from EON_Appointment__c where id =: appt.id AND Sent_to_Oracle__c = true];
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_ConfirmAppointment_In_Isis_WS controller = new EON_ConfirmAppointment_In_Isis_WS();
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();      
        
        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement(); 
        keyCollElem.PersonName = 'Mark';    
        keyCollElem.ContactNumber = '9826012345';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC ='01335';
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = '';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE';                       
        //Praveen End CH05        
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement();            
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;      
        updAppt.DataCaptureConsents = dataCapElem;       
        updAppt.Vulnerabilities = vul12;
        
        updAppt.WANCoverageDetails = wanData; //Praveen Added CH05
        
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    //CH04.New.Start
    /*
        ConfirmAppointmentNotAtOracle(): This method will verify error message to EON when appointment not processed at Oracle
    */
    static testmethod void ConfirmAppointmentNotAtOracle(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =true,Job_Type__c='SMART');
        Insert jobcode;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        Insert appt;

        EON_Appointment__c app = [select id,mpan__c,Post_Code__c,Job_Code__c ,Oracle_Address__c ,name from EON_Appointment__c where id =: appt.id];
        
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 1);
        insert aVul;
        
        EON_Appointment_Vulnerability__c vul123 = [select VulnerabilityDetailCode__c,EON_Appointment_ID__c from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c =: app.id AND VulnerabilityDetailCode__c =: 1];
        
        EON_Contact_Type__c EC = new EON_Contact_Type__c(Name = 'test1' , Code__c = 'A');
        insert EC;
        
        EON_Media_Type__c MT = new EON_Media_Type__c(Name = 'test1' , Code__c = 'B');
        insert MT;
        
        EON_Electric_Meter_Location__c EML = new EON_Electric_Meter_Location__c(Name = 'test12',Code__c = 'AB');
        insert EML;
        
        EON_Gas_Meter_Location__c EGML = new EON_Gas_Meter_Location__c(Name = 'test12',Code__c = 'CD');
        insert EGML;
        
        Eon_Delivery_Method__c  EDM = new Eon_Delivery_Method__c(Name = 'test12',Code__c = 'M');
        insert EDM;
        
        EON_Parking__c park = new EON_Parking__c(Name = 'test park', Parking_Code__c = 'P',OFS_Enumeration__c = 1);
        insert park;
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_ConfirmAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_ConfirmAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        
        EON_ConfirmAppointment_In_Isis_WS.HeaderElement header = new EON_ConfirmAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();   

        EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_ConfirmAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = 'Mark';
        keyCollElem.ContactNumber = '132556';
        keyCollElem.BuildingNumber = '12';
        keyCollElem.BuildingName = 'Royal Park Avenue';
        keyCollElem.SubBuildingName = 'Sb1';
        keyCollElem.DependentLocality = 'Rock Street';
        keyCollElem.DependentThorofare = 'none';
        keyCollElem.DoubleDependentLocality = 'none';
        keyCollElem.Thorofare = 'none';
        keyCollElem.Town = 'Yorkshire';
        keyCollElem.PostCode = '321456';
        keyCollElem.County = 'UK';
        keyCollElem.Country = 'Peakshore';      
        
        EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_ConfirmAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC = '';   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_ConfirmAppointment_In_Isis_WS.ContactElement conElem = new EON_ConfirmAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_ConfirmAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_ConfirmAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_ConfirmAppointment_In_Isis_WS.Contactlst conLst = new EON_ConfirmAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_ConfirmAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_ConfirmAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_ConfirmAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_ConfirmAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_ConfirmAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_ConfirmAppointment_In_Isis_WS.DataCaptureConsentsElement();    
      
        EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment updAppt = new EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;       
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH05
        EON_Standing_Data_Group__c group1 = new EON_Standing_Data_Group__c();
        group1.Name = 'CSP_REGION';
        insert group1;
        EON_Standing_Data__c data1 = new EON_Standing_Data__c();
        data1.code_id__c= 'SOUTH';
        data1.DataGroup__c = group1.id;
        insert data1;
        
        EON_Standing_Data_Group__c group2 = new EON_Standing_Data_Group__c();
        group2.Name = 'COMMS_HUB_VARIANT';
        insert group2;
        EON_Standing_Data__c data2 = new EON_Standing_Data__c();
        data2.code_id__c= 'CELLULAR';
        data2.DataGroup__c = group2.id;
        insert data2;
                
        EON_Standing_Data_Group__c group3 = new EON_Standing_Data_Group__c();
        group3.Name = 'CONNECTIVITY_LIKELIHOOD';
        insert group3;
        EON_Standing_Data__c data3 = new EON_Standing_Data__c();
        data3.code_id__c= 'HIGH';
        data3.DataGroup__c = group3.id;
        insert data3; 
                
        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_ConfirmAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH05         
        
        EON_ConfirmAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        keyCollElem.PersonName = 'test';
        //keyCollElem.ContactNumber = '';
        updAppt.AppointmentDetails = apptDetailElem;
        response = EON_ConfirmAppointment_In_Isis_WS.ConfirmAppointment(updAppt); 
        String msgText = response.Messages.Message[0].MessageText;
        System.assertEquals(true, msgText.contains('OOA System is background processing this appointment. Please try again.'));             
        //System.assertEquals('Test', msgText );             
        test.stopTest();
    }
    //CH04.New.End
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
           String responseName,String responseType) {
            // Send success response
            EON_OFSC_Inbound_WS.ReportMessageElement message = new EON_OFSC_Inbound_WS.ReportMessageElement();
            message.result = 'success';
            message.code = '0';
            message.description = 'Appointment id = 126';
            EON_OFSC_Inbound_WS.ReportMessageElement[] messages = new EON_OFSC_Inbound_WS.ReportMessageElement[]{message};
            EON_OFSC_Inbound_WS.ReportElement reports = new EON_OFSC_Inbound_WS.ReportElement();
            reports.message = messages;
            EON_OFSC_Inbound_WS.AppointmentResponseElement appointment = new EON_OFSC_Inbound_WS.AppointmentResponseElement();
            appointment.appt_number = 'test';
            appointment.name = 'test';
            appointment.aid = 126;
            appointment.report = reports;
            EON_OFSC_Inbound_WS.CommandResponseElement command = new EON_OFSC_Inbound_WS.CommandResponseElement();
            command.appointment = appointment;
            EON_OFSC_Inbound_WS.CommandResponseElement[] commandarray = new EON_OFSC_Inbound_WS.CommandResponseElement[]{command};
            EON_OFSC_Inbound_WS.CommandsResponseArray commands = new EON_OFSC_Inbound_WS.CommandsResponseArray();
            commands.command = commandarray;
            EON_OFSC_Inbound_WS.DataResponseElement data = new EON_OFSC_Inbound_WS.DataResponseElement();
            data.commands = commands;
            EON_OFSC_Inbound_WS.InboundInterfaceResponseElement res = new EON_OFSC_Inbound_WS.InboundInterfaceResponseElement();
            res.user_x = new EON_OFSC_Inbound_WS.UserElement();
            res.head = new EON_OFSC_Inbound_WS.HeadResponseElement();
            res.data = data;
            if(request instanceOf EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetails_element) {
                Map<String, EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element> response_map_x = 
                          new Map<String, EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element>();
                EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element response_x = 
                      new EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element();
                response_x.UpdateAppointmentDetailsResult = 'Fail';        
                response.put('response_x', response_x);                                    
            }
            else{
                if(methodName == 'errorResponse'){
                    //message.result = 'fail';
                    message.result = 'error';
                    message.code = '1';
                    response.put('response_x', res);
                }
                else
                    response.put('response_x', res);                   
            }
   }
}