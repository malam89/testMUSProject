/**
    Description : This test class covers the code coverage for below class
        1. EON_UpdateAppointment_In_Isis_WS
**/
/*
    Created By : Nitin Bangar
    Created Date : 31-March-2016
    Service Request : SR_EON_AB_025
    CH01# SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH02 # SR_EON_Jumbo_030 # 09/06/2016 # Mehboob Alam # Added  'Vulnerability Source' field value.
    CH03 # SR_EON_AB_072 # 15/06/2016 # Shruti Moghe # Updated code as per SR enhancement
    CH04 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Deleted reference of field Vulnerability_Source__c
    CH05 # SR_EON_AB_139 # 15-09-2016 # Mahadev J # Update criteria for creating of updating EON Appointment Comms, EON Appointment Vulnerability & EON Appointment Contacts
    CH06 # SR_EON_AB_166 # 17/09/2016 # Mahadev J # An update from should be rejected with error if appointment not sent to Oracle
    CH07 # SR_OptiMUS_EON_112  # 12/09/2016 # Praveen G # Test for new fields added.
*/

@isTest
private class EON_UpdateAppointment_In_Isis_test{
    /**
        UpdateAppointment_to_Isis_Pass() - postitive Unit test for the method UpdateAppointment ParkingTypeCode
    **/
    static testmethod void UpdateAppointment_to_Isis_Succ(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false);
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one',Post_Code__c = 'SG1 2ST');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
         //CH01.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='test';
        ssc.type__c='classic';
        insert ssc;
        //CH01.end
        system.debug('---'+appt);
        EON_Appointment__c app = [select id,MPAN__c,Post_Code__c,Job_Code__c,Sent_to_Oracle__c,Oracle_Address__c ,name from EON_Appointment__c where id =: appt.id AND Sent_to_Oracle__c = true ];
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();  
        /*
        list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');*/ 
        /*
        List<EON_UpdateAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_UpdateAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/ //CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();        
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = 'MUS-12881';
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC =ssc.name;   
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';
        
        /*EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = 'A1'; 
        paygElem.CustomerLowBalanceAlertOpted = 'B1';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = 'C1';
        paygElem.PaymentReminderOpted = 'D1';
        paygElem.PaymentReminderFrequency = 'E1';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*/ //CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;        
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    /**
        UpdateAppointment_to_Isis_Pass() - postitive Unit test for the method UpdateAppointment ParkingTypeCode
    **/
    static testmethod void UpdateAppointment_to_Isis_Pass(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =true);
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one',Post_Code__c = 'SG1 2ST');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        //CH01.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='test';
        ssc.type__c='classic';
        insert ssc;
        //CH01.end
        EON_Appointment__c app = [select id,MPAN__c,Post_Code__c,Job_Code__c ,Oracle_Address__c,Sent_to_Oracle__c ,name from EON_Appointment__c where id =: appt.id AND Sent_to_Oracle__c = true];
        
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
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
         /*
        list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');*/ 
        
        /*
        List<EON_UpdateAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_UpdateAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/ //CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();        
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        //apptDetailElem.RequestedSSC =ssc.name;//CH01
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';
        
        /*EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = 'A1'; 
        paygElem.CustomerLowBalanceAlertOpted = 'B1';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = 'C1';
        paygElem.PaymentReminderOpted = 'D1';
        paygElem.PaymentReminderFrequency = 'E1';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*/ //CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;     
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;//CH03.old
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Pass_A() - postitive Unit test for the method UpdateAppointment 
    **/
    static testmethod void UpdateAppointment_to_Isis_Pass_A(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false, Job_Type__c='SMART');
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one',Post_Code__c = 'SG1 2ST');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,MPAN__c,Post_Code__c,Job_Code__c ,Oracle_Address__c,Sent_to_Oracle__c ,name from EON_Appointment__c where id =: appt.id AND Sent_to_Oracle__c = true];
        EON_Vulnerability_Code__c code = new EON_Vulnerability_Code__c(Vulnerability_Code__c=1);
        insert code;
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c =4);
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
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();      
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement(); 
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC ='01335';
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = '';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'R';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';   
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;      
        updAppt.DataCaptureConsents = dataCapElem;       
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Fail_A() - Failure Unit test for the method UpdateAppointment 
    **/
    static testmethod void UpdateAppointment_to_Isis_Fail_A(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false, Job_Type__c='SMART');
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one',Post_Code__c = 'SG1 2ST');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,MPAN__c,Post_Code__c,Job_Code__c ,Oracle_Address__c,Sent_to_Oracle__c ,name from EON_Appointment__c where id =: appt.id AND Sent_to_Oracle__c = true];
        EON_Vulnerability_Code__c code = new EON_Vulnerability_Code__c(Vulnerability_Code__c=11);
        insert code;
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c =4);
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
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '11' ;
        vul.VulnerabilityTypeId = 11;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();      
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement(); 
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC ='01335';
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = '';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'R';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';   
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;      
        updAppt.DataCaptureConsents = dataCapElem;       
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }

    /**
        UpdateAppointment_to_Isis_Fail_A1() - Failure Unit test for the method UpdateAppointment 
    **/
    static testmethod void UpdateAppointment_to_Isis_Fail_A1(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false, Job_Type__c='SMART');
        Insert jobcode;
        //EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one',Post_Code__c = 'SG1 2ST');
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one',Post_Code__c = '');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,MPAN__c,Post_Code__c,Job_Code__c ,Oracle_Address__c,Sent_to_Oracle__c ,name from EON_Appointment__c where id =: appt.id AND Sent_to_Oracle__c = true];
        EON_Vulnerability_Code__c code = new EON_Vulnerability_Code__c(Vulnerability_Code__c=1);
        insert code;
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c =4);
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
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();      
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement(); 
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC ='01335';
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = '';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'R';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';   
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;      
        updAppt.DataCaptureConsents = dataCapElem;       
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Pass1() - postitive Unit test for the method UpdateAppointment ParkingTypeCode
    **/
    static testmethod void UpdateAppointment_to_Isis_Pass1(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false);
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Post_Code__c ='Sg11qs',Metering_Point_Address_Line_2__c = 'Address line one');
        Insert appt;
        //CH01.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='0133';
        ssc.type__c='classic';
        insert ssc;
        //CH01.end
        system.debug('----'+appt.Oracle_Address__c);
        appt.Sent_to_Oracle__c = true;
        update appt;
        system.debug('----'+appt.Oracle_Address__c);
        EON_Appointment__c app = [select id,MPAN__c,Post_Code__c,Job_Code__c ,Metering_Point_Address_Line_2__c,Oracle_Address__c,Sent_to_Oracle__c ,name from EON_Appointment__c where id =: appt.id AND Sent_to_Oracle__c = true];
        system.debug('----'+app.Oracle_Address__c);
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 1);
        insert aVul;
        
        //EON_Vulnerability_Code__c vc = new EON_Vulnerability_Code__c(Vulnerability_Code__c = 3,Vulnerability_Source__c='EON'); //CH02 CH04.Old
        EON_Vulnerability_Code__c vc = new EON_Vulnerability_Code__c(Vulnerability_Code__c = 3); //CH02 CH04.New
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
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '3' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
         /*
        list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');*/ 
        /*
        List<EON_UpdateAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_UpdateAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/ //CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();        
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        //apptDetailElem.RequestedSSC = ssc.name;//CH01
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';
        
        /*EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = 'A1'; 
        paygElem.CustomerLowBalanceAlertOpted = 'B1';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = 'C1';
        paygElem.PaymentReminderOpted = 'D1';
        paygElem.PaymentReminderFrequency = 'E1';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*///CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;       
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;//CH03.old
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }  
    
    /**
        UpdateAppointment_to_Isis_Pass2() - postitive Unit test for the method UpdateAppointment
    **/

    static testmethod void UpdateAppointment_to_Isis_Pass2(){
        test.startTest();
         //CH01.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='0133';
        ssc.type__c='classic';
        insert ssc;
        //CH01.end
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
         /*
        list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');*/ 
        /*
        List<EON_UpdateAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_UpdateAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/ //CH03.old

            
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();        
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = '';
        apptDetailElem.EONAppointmentID = null;
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC =ssc.name;//CH01
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = '';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'CD321';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'LOC5445';         
        mtrLocElem.FuelTypeCode = '';  

        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = '';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = ''; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = ''; 
        dataCapElem.ElecDailyDataOpted = '';
        dataCapElem.GasHHDataOpted = '';
        dataCapElem.GasDailyDataOpted = '';
        /*
        EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = ''; 
        paygElem.CustomerLowBalanceAlertOpted = '';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = '';
        paygElem.PaymentReminderOpted = '';
        paygElem.PaymentReminderFrequency = '';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*///CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vulElem = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();    
        vulElem.VulnerabilityDetailCode = 'test112'; 
        vulElem.VulnerabilityTypeId = null; 
        
        List<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> lstvulElem = new List<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        lstvulElem.add(vulElem);
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vulLst = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();    
        vulLst.Vulnerability = lstvulElem;         
        
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;         
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;//CH03.old
        updAppt.Vulnerabilities = vulLst;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Pass3() - postitive Unit test for the method UpdateAppointment
    **/
    
    static testmethod void UpdateAppointment_to_Isis_Pass3(){
        test.startTest();
         //CH01.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='0133';
        ssc.type__c='classic';
        insert ssc;
        //CH01.end
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
          /*
        list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');*/ 
        /*
        List<EON_UpdateAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_UpdateAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/ //CH03.old

        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();        
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = '';
        apptDetailElem.EONAppointmentID = null;
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC =ssc.name; //CH01  
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'ec1231';              
        conElem.ContactName = '';
        conElem.MediaTypeCode = 'CD321';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = '';         
        mtrLocElem.FuelTypeCode = 'F1';  

        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = '';
        commTypeElem.DeliveryMethod = 'D12';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = ''; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = ''; 
        dataCapElem.ElecDailyDataOpted = '';
        dataCapElem.GasHHDataOpted = '';
        dataCapElem.GasDailyDataOpted = '';
        /*
        EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = ''; 
        paygElem.CustomerLowBalanceAlertOpted = '';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = '';
        paygElem.PaymentReminderOpted = '';
        paygElem.PaymentReminderFrequency = '';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        paygElem.PaymentReminderDateOfTheMonth = 'G1';*///CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vulElem = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();    
        vulElem.VulnerabilityDetailCode = ''; 
        vulElem.VulnerabilityTypeId = 3214456; 
        
        List<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> lstvulElem = new List<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        lstvulElem.add(vulElem);
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vulLst = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();    
        vulLst.Vulnerability = lstvulElem;         
        
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;         
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;//CH03.old
        updAppt.Vulnerabilities = vulLst;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Pass4() - postitive Unit test for the method UpdateAppointment
    **/
    
    static testmethod void UpdateAppointment_to_Isis_Pass4(){
        test.startTest();
        //CH01.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='0133';
        ssc.type__c='classic';
        insert ssc;
        //CH01.end
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
          /*
        list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');*/ 
        /*
        List<EON_UpdateAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_UpdateAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/ //CH03.old

        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();        
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = '';
        apptDetailElem.EONAppointmentID = null;
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC =ssc.name;  //CH01 
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'ec1231';              
        conElem.ContactName = 'Name1';
        conElem.MediaTypeCode = '';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = '';         
        mtrLocElem.FuelTypeCode = 'F1';  

        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = '';
        commTypeElem.DeliveryMethod = 'D12';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = ''; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = ''; 
        dataCapElem.ElecDailyDataOpted = '';
        dataCapElem.GasHHDataOpted = '';
        dataCapElem.GasDailyDataOpted = '';
        /*
        EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = ''; 
        paygElem.CustomerLowBalanceAlertOpted = '';
        paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = '';
        paygElem.PaymentReminderOpted = '';
        paygElem.PaymentReminderFrequency = 'M';
        paygElem.PaymentReminderDayOfTheWeek = 'F1';
        //paygElem.PaymentReminderDateOfTheMonth = 'G1';*///CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vulElem = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();    
        vulElem.VulnerabilityDetailCode = ''; 
        vulElem.VulnerabilityTypeId = 3214456; 
        
        List<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> lstvulElem = new List<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        lstvulElem.add(vulElem);
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vulLst = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();    
        vulLst.Vulnerability = lstvulElem;         
        
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;    
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;
        updAppt.Vulnerabilities = vulLst;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Pass5() - postitive Unit test for the method UpdateAppointment
    **/
    
    static testmethod void UpdateAppointment_to_Isis_Pass5(){
        test.startTest();
         //CH01.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='0133';
        ssc.type__c='classic';
        insert ssc;
        //CH01.end
        
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
          /*
        list<string> strLst = new list<string>();
        strLst.add('Notes attached one');  
        strLst.add('Notes attached two');*/ 
        /*
        List<EON_UpdateAppointment_In_Isis_WS.NoteElement> lstNoteElem = new List<EON_UpdateAppointment_In_Isis_WS.NoteElement>();
        lstNoteElem.add(noteElem);*/ //CH03.old

        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();        
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = '';
        apptDetailElem.EONAppointmentID = null;
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC =ssc.name; //CH01  
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'ec1231';              
        conElem.ContactName = 'Name1';
        conElem.MediaTypeCode = 'M121';
        conElem.MediaDetail = '';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = '';         
        mtrLocElem.FuelTypeCode = 'F1';  

        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = '';
        commTypeElem.DeliveryMethod = 'D12';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = ''; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = ''; 
        dataCapElem.ElecDailyDataOpted = '';
        dataCapElem.GasHHDataOpted = '';
        dataCapElem.GasDailyDataOpted = '';
        /*
        EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement paygElem = new EON_UpdateAppointment_In_Isis_WS.PAYGAlertPreferencesElement();    
        paygElem.EONSetDisconnectOpted = ''; 
        paygElem.CustomerLowBalanceAlertOpted = 'Y';
        //paygElem.LowBalanceAlertValue = 32144;
        paygElem.TopUpCodeNotifyFailureOpted = '';
        paygElem.PaymentReminderOpted = '';
        paygElem.PaymentReminderFrequency = 'W';
        //paygElem.PaymentReminderDayOfTheWeek = 'F1';
        //paygElem.PaymentReminderDateOfTheMonth = 'G1';*///CH03.old
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vulElem = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();    
        vulElem.VulnerabilityDetailCode = ''; 
        vulElem.VulnerabilityTypeId = 3214456; 
        
        List<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> lstvulElem = new List<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        lstvulElem.add(vulElem);
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vulLst = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();    
        vulLst.Vulnerability = lstvulElem;         
        
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;    
        updAppt.DataCaptureConsents = dataCapElem;
        //updAppt.PAYGAlertPreferences = paygElem;//CH03.old
        updAppt.Vulnerabilities = vulLst;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /**
        UpdateAppointment_to_Isis_Fail1() - Negative Unit test for the method UpdateAppointment covering Catch block.    
    **/
    static testMethod void UpdateAppointment_to_Isis_Fail1() {          
        test.startTest();
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
        updAppt.Header = header;
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt);
        System.assert(response != null);                                     
        test.stopTest();
    }  
    
    /**
        UpdateAppointment_to_Isis_Fail2() - Negative Unit test for the method UpdateAppointment, When Error = 'Request Not Found'
    **/
    static testMethod void UpdateAppointment_to_Isis_Fail2() {          
        test.startTest();
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt;
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt);
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    static testmethod void UpdateAppointment_to_Isis_Pass6(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false);
        Insert jobcode;
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Post_Code__c ='Sg11qs',Metering_Point_Address_Line_2__c = 'Address line one');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        EON_Appointment__c app = [select id,MPAN__c,Post_Code__c,Job_Code__c ,Metering_Point_Address_Line_2__c,Oracle_Address__c,Sent_to_Oracle__c ,name from EON_Appointment__c where id =: appt.id AND Sent_to_Oracle__c = true];
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 1);
        insert aVul;
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); // mock request
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '3' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();        
        keyCollElem.PersonName = '';
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';      
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;         
        updAppt.DataCaptureConsents = dataCapElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        keyCollElem.PersonName = 'test';
        keyCollElem.ContactNumber = '';
        apptDetailElem.KeyCollection = keyCollElem;
        updAppt.AppointmentDetails = apptDetailElem;
        response=EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        
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
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '1' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        EON_UpdateAppointment_In_Isis_WS controller = new EON_UpdateAppointment_In_Isis_WS();
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();      
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement(); 
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.RequestedSSC ='01335';
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = '';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();            
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;      
        updAppt.DataCaptureConsents = dataCapElem;       
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    //CH05.New.Start
    /**
        UpdateAppointment_WithContacts_Pass() - This is positive test to cover update of existing Appointment Contacts
    **/
    static testmethod void UpdateAppointment_WithContacts_Pass(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false);
        Insert jobcode;
        
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one',Post_Code__c = 'SG1 2ST');
        //appt.Confirmed_Appointment_DateTime__c = System.now(); //Praveen Added 
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        
        EON_Contact_Type__c contype = new EON_Contact_Type__c();
        contype.name = 'test';
        contype.Code__c = 'T';
        insert contype;
        EON_Media_Type__c medType = new EON_Media_Type__c();
        medType.name = 'test';
        medType.Code__c = 'T';
        insert medType;
        EON_Appointment_Contact__c appContact = new EON_Appointment_Contact__c();
        appContact.Contact_Type__c = contype.ID;
        appContact.Media_Type__c = medType.ID;
        appContact.Media_Detail__c = '123455';
        appContact.Contact_Full_Name__c = 'test';
        appContact.EON_Appointment_ID__c = appt.ID; 
        insert appContact;
        
        Eon_Delivery_Method__c deliveryMethod = new Eon_Delivery_Method__c();
        deliveryMethod.Name = 'test';
        deliveryMethod.Code__c = 'E';
        insert deliveryMethod;
        
        EON_Appointment_Comms__c appComms = new EON_Appointment_Comms__c();
        appComms.Delivery_Method_Desc__c = deliveryMethod.ID;
        appComms.Comm_Type_Code__c = 'R';
        appComms.EON_Appointment_ID__c = appt.ID;
        insert appComms;
        
        EON_Parking__c parking = new EON_Parking__c();
        parking.Name = 'test';
        parking.Parking_Code__c = 'C';
        insert parking;
        
        EON_Electric_Meter_Location__c eMeterLoc = new EON_Electric_Meter_Location__c();
        eMeterLoc.Code__c = 'F';
        eMeterLoc.name = 'test';
        insert eMeterLoc;
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.OrgId = 'test';
        header.RequestId = 'test';
        header.RequestDateTime = System.now();
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollect = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();
        keyCollect.PersonName = 'test';
        keyCollect.ContactNumber = '345566';
        keyCollect.BuildingNumber = '223';
        keyCollect.BuildingName = 'test';
        keyCollect.SubBuildingName = 'test';
        keyCollect.DependentLocality = 'test';
        keyCollect.DependentThorofare = 'test';
        keyCollect.DoubleDependentLocality = 'test';
        keyCollect.Thorofare = 'test';
        keyCollect.Town = 'test';
        keyCollect.PostCode = 'test';
        keyCollect.County = 'test';
        keyCollect.Country = 'test';
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement appDetail = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();
        appDetail.ExternalAppointmentID = [Select name from EON_Appointment__c where ID=:appt.ID].name;
        appDetail.EONAppointmentID = 'test';
        appDetail.AccessPhrase = 'test';
        appDetail.CallerName = 'test';
        appDetail.RequestedSSC = 'test';
        appDetail.KeyCollection = keyCollect;
        appDetail.Note = 'test';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement contactEle = new EON_UpdateAppointment_In_Isis_WS.ContactElement();
        contactEle.ContactTypeCode = 'T';
        contactEle.ContactName = 'test';
        contactEle.MediaTypeCode = 'T';
        contactEle.MediaDetail = '67889345';
        list<EON_UpdateAppointment_In_Isis_WS.ContactElement> listContactEle = new list<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        listContactEle.add(contactEle);
        EON_UpdateAppointment_In_Isis_WS.Contactlst allContact = new EON_UpdateAppointment_In_Isis_WS.Contactlst();
        allContact.Contact = listContactEle;
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement meterLocEle = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        meterLocEle.LocationCode = 'F';
        meterLocEle.FuelTypeCode = 'E';
        list<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> listMeterLocEle = new list<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        listMeterLocEle.add(meterLocEle);
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst allmeterLocEle = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        allmeterLocEle.MeterLocation = listMeterLocEle;
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeEle = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeEle.CommTypeCode = 'R';
        commTypeEle.DeliveryMethod = 'E';
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeEle1 = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeEle1.CommTypeCode = 'I';
        commTypeEle1.DeliveryMethod = 'E';
        list<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> listCommTypeEle = new list<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        listCommTypeEle.add(commTypeEle);
        listCommTypeEle.add(commTypeEle1);
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst allCommTypeEle = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();
        allCommTypeEle.CommunicationType = listCommTypeEle;
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkEle = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();
        parkEle.ParkingTypeCode = 'C';
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCaptureEle = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();
        dataCaptureEle.ElecHHDataOpted = 'Y';
        dataCaptureEle.ElecDailyDataOpted = 'Y';
        dataCaptureEle.GasHHDataOpted = 'N';
        dataCaptureEle.GasDailyDataOpted = 'N';
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
                              
        //Praveen End CH07
        
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updateAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updateAppt.Header = header;
        updateAppt.AppointmentDetails = appDetail;
        updateAppt.Contacts = allContact;
        updateAppt.MeterLocations = allmeterLocEle;
        updateAppt.CommunicationTypes = allCommTypeEle;
        updateAppt.Parking = parkEle;
        updateAppt.DataCaptureConsents = dataCaptureEle;
        updateAppt.Vulnerabilities = null;
        updateAppt.WANCoverageDetails = wanData;
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updateAppt); 
        system.assertEquals('Request processed Successfully.', response.Messages.Message[0].MessageText);
        test.stopTest();
    }
    
    /**
        UpdateAppointment_WithContacts_Fail() - This is negative test to cover all returning errors.
    **/
    static testmethod void UpdateAppointment_WithContacts_Fail(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false);
        Insert jobcode;
        
        EON_Appointment__c appt = new EON_Appointment__c(MPAN__c = '1234',Sent_to_Oracle__c = true,Job_Code__c = jobcode.id,Metering_Point_Address_Line_2__c = 'Address line one',Post_Code__c = 'SG1 2ST');
        Insert appt;
        appt.Sent_to_Oracle__c = true;
        update appt;
        
        EON_Contact_Type__c contype = new EON_Contact_Type__c();
        contype.name = 'test';
        contype.Code__c = 'T';
        insert contype;
        EON_Media_Type__c medType = new EON_Media_Type__c();
        medType.name = 'test';
        medType.Code__c = 'T';
        insert medType;
        EON_Appointment_Contact__c appContact = new EON_Appointment_Contact__c();
        appContact.Contact_Type__c = contype.ID;
        appContact.Media_Type__c = medType.ID;
        appContact.Media_Detail__c = '123455';
        appContact.Contact_Full_Name__c = 'test';
        appContact.EON_Appointment_ID__c = appt.ID; 
        insert appContact;
        
        Eon_Delivery_Method__c deliveryMethod = new Eon_Delivery_Method__c();
        deliveryMethod.Name = 'test';
        deliveryMethod.Code__c = 'E';
        insert deliveryMethod;
        
        EON_Appointment_Comms__c appComms = new EON_Appointment_Comms__c();
        appComms.Delivery_Method_Desc__c = deliveryMethod.ID;
        appComms.Comm_Type_Code__c = 'R';
        appComms.EON_Appointment_ID__c = appt.ID;
        insert appComms;
        
        EON_Parking__c parking = new EON_Parking__c();
        parking.Name = 'test';
        parking.Parking_Code__c = 'C';
        insert parking;
        
        EON_Electric_Meter_Location__c eMeterLoc = new EON_Electric_Meter_Location__c();
        eMeterLoc.Code__c = 'F';
        eMeterLoc.name = 'test';
        insert eMeterLoc;
        
        EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c();
        vulCode.name = 'test';
        vulCode.Vulnerability_Code__c = 22;
        insert vulCode;
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.OrgId = 'test';
        header.RequestId = 'test';
        header.RequestDateTime = System.now();
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollect = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();
        keyCollect.PersonName = 'test';
        keyCollect.ContactNumber = '345566';
        keyCollect.BuildingNumber = '223';
        keyCollect.BuildingName = 'test';
        keyCollect.SubBuildingName = 'test';
        keyCollect.DependentLocality = 'test';
        keyCollect.DependentThorofare = 'test';
        keyCollect.DoubleDependentLocality = 'test';
        keyCollect.Thorofare = 'test';
        keyCollect.Town = 'test';
        keyCollect.PostCode = 'test';
        keyCollect.County = 'test';
        keyCollect.Country = 'test';
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement appDetail = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();
        appDetail.ExternalAppointmentID = [Select name from EON_Appointment__c where ID=:appt.ID].name;
        appDetail.EONAppointmentID = 'test';
        appDetail.AccessPhrase = 'test';
        appDetail.CallerName = 'test';
        appDetail.RequestedSSC = 'test';
        appDetail.KeyCollection = keyCollect;
        appDetail.Note = 'test';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement contactEle = new EON_UpdateAppointment_In_Isis_WS.ContactElement();
        contactEle.ContactTypeCode = 'T';
        contactEle.ContactName = 'test';
        contactEle.MediaTypeCode = 'T';
        contactEle.MediaDetail = '67889345';
        list<EON_UpdateAppointment_In_Isis_WS.ContactElement> listContactEle = new list<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        listContactEle.add(contactEle);
        EON_UpdateAppointment_In_Isis_WS.Contactlst allContact = new EON_UpdateAppointment_In_Isis_WS.Contactlst();
        allContact.Contact = listContactEle;
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement meterLocEle = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        meterLocEle.LocationCode = 'F';
        meterLocEle.FuelTypeCode = 'E';
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement meterLocEle1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        meterLocEle1.LocationCode = 'F';
        meterLocEle1.FuelTypeCode = 'G';
        list<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> listMeterLocEle = new list<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        listMeterLocEle.add(meterLocEle);
        listMeterLocEle.add(meterLocEle1);
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst allmeterLocEle = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        allmeterLocEle.MeterLocation = listMeterLocEle;
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeEle = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeEle.CommTypeCode = 'R';
        commTypeEle.DeliveryMethod = 'E';
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeEle1 = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeEle1.CommTypeCode = 'I';
        commTypeEle1.DeliveryMethod = 'E';
        list<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> listCommTypeEle = new list<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        listCommTypeEle.add(commTypeEle);
        listCommTypeEle.add(commTypeEle1);
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst allCommTypeEle = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();
        allCommTypeEle.CommunicationType = listCommTypeEle;
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkEle = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();
        parkEle.ParkingTypeCode = 'C';
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCaptureEle = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();
        dataCaptureEle.ElecHHDataOpted = 'Y';
        dataCaptureEle.ElecDailyDataOpted = 'Y';
        dataCaptureEle.GasHHDataOpted = 'N';
        dataCaptureEle.GasDailyDataOpted = 'N';
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vulEle = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vulEle.VulnerabilityDetailCode = '22';
        vulEle.VulnerabilityTypeId = 22;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> listValEle = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        listValEle.add(vulEle);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst allCalEle = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        allCalEle.Vulnerability = listValEle;
        
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updateAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updateAppt.Header = header;
        updateAppt.AppointmentDetails = appDetail;
        updateAppt.Contacts = allContact;
        updateAppt.MeterLocations = allmeterLocEle;
        updateAppt.CommunicationTypes = allCommTypeEle;
        updateAppt.Parking = parkEle;
        updateAppt.DataCaptureConsents = dataCaptureEle;
        updateAppt.Vulnerabilities = allCalEle;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updateAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        //InCorrect ContactTypeCode, MediaTypeCode, DeliveryMethod, ParkingTypeCode, LocationCode
        contactEle.ContactTypeCode = 'D';  //T
        contactEle.MediaTypeCode = 'D';    //T
        commTypeEle.DeliveryMethod = 'Z'; //E
        commTypeEle1.DeliveryMethod = 'Z'; //E
        parkEle.ParkingTypeCode = 'Z';  //C
        meterLocEle.LocationCode = 'Z'; //'F';
        meterLocEle1.LocationCode = 'Z'; //'F';
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updateAppt); 
        test.stopTest();
    }
    //CH05.New.End
    //CH06.New.Start
    /*
    UpdateAppointmentNotAtOracle(): This method will verify error message to EON when appointment not processed at Oracle
  */
    static testmethod void UpdateAppointmentNotAtOracle(){
        EON_Job__c  jobcode = new EON_Job__c(Name = 'OOASMARTELECINST',Description__c = 'Install Smart Duel Fuel',SSC_Required__c =false);
        Insert jobcode;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        //appt.Confirmed_Appointment_DateTime__c = System.now(); //Praveen Added
        Insert appt;
        
        EON_Appointment__c app = [select id,MPAN__c,Post_Code__c,Job_Code__c ,Metering_Point_Address_Line_2__c,Oracle_Address__c,Sent_to_Oracle__c ,name from EON_Appointment__c where id =: appt.id];
        EON_Appointment_Vulnerability__c aVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = app.id,VulnerabilityDetailCode__c = 1);
        insert aVul;
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); 
        
        EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement vul = new EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement();
        vul.VulnerabilityDetailCode = '3' ;
        vul.VulnerabilityTypeId = 1;
        list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement> vullst1 = new list<EON_UpdateAppointment_In_Isis_WS.VulnerabilityElement>();
        vullst1.add(vul);
        EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst vul12 = new EON_UpdateAppointment_In_Isis_WS.VulnerabilitiesLst();
        vul12.Vulnerability = vullst1;
        
        EON_UpdateAppointment_In_Isis_WS.HeaderElement header = new EON_UpdateAppointment_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
        
        EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement keyCollElem = new EON_UpdateAppointment_In_Isis_WS.KeyCollectionElement();        
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
        
        EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement apptDetailElem = new EON_UpdateAppointment_In_Isis_WS.AppointmentDetailElement();    
        apptDetailElem.ExternalAppointmentID = app.Name;
        apptDetailElem.EONAppointmentID = '231654';
        apptDetailElem.AccessPhrase = 'access granted'; 
        apptDetailElem.CallerName = 'Tester';       
        apptDetailElem.KeyCollection = keyCollElem;     
        apptDetailElem.Note = 'Testing';
        
        EON_UpdateAppointment_In_Isis_WS.ContactElement conElem = new EON_UpdateAppointment_In_Isis_WS.ContactElement();    
        conElem.ContactTypeCode = 'A';              
        conElem.ContactName = 'New Test';
        conElem.MediaTypeCode = 'B';
        conElem.MediaDetail = 'News';
        
        List<EON_UpdateAppointment_In_Isis_WS.ContactElement> lstConElem = new List<EON_UpdateAppointment_In_Isis_WS.ContactElement>();
        lstConElem.add(conElem);
        
        EON_UpdateAppointment_In_Isis_WS.Contactlst conLst = new EON_UpdateAppointment_In_Isis_WS.Contactlst();    
        conLst.Contact = lstConElem;         
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem.LocationCode = 'AB';         
        mtrLocElem.FuelTypeCode = 'E';  
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationElement  mtrLocElem1 = new EON_UpdateAppointment_In_Isis_WS.MeterLocationElement();
        mtrLocElem1.LocationCode = 'CD';         
        mtrLocElem1.FuelTypeCode = 'G';
        
        List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement> lstmtrLocElem = new List<EON_UpdateAppointment_In_Isis_WS.MeterLocationElement>();
        lstmtrLocElem.add(mtrLocElem);  
        lstmtrLocElem.add(mtrLocElem1);
        
        EON_UpdateAppointment_In_Isis_WS.MeterLocationlst mtrLocLst = new EON_UpdateAppointment_In_Isis_WS.MeterLocationlst();
        mtrLocLst.MeterLocation = lstmtrLocElem;        
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement commTypeElem = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement();
        commTypeElem.CommTypeCode = 'C123';
        commTypeElem.DeliveryMethod = 'M';
        
        List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement> lstcommTypeElem = new List<EON_UpdateAppointment_In_Isis_WS.CommunicationTypeElement>();
        lstcommTypeElem.add(commTypeElem);
        
        EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst commTypLst = new EON_UpdateAppointment_In_Isis_WS.CommunicationTypelst();    
        commTypLst.CommunicationType = lstcommTypeElem; 
        
        EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement parkElem = new EON_UpdateAppointment_In_Isis_WS.ParkingDetailElement();    
        parkElem.ParkingTypeCode = 'P'; 
        
        EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement dataCapElem = new EON_UpdateAppointment_In_Isis_WS.DataCaptureConsentsElement();    
        dataCapElem.ElecHHDataOpted = 'A121'; 
        dataCapElem.ElecDailyDataOpted = 'B121';
        dataCapElem.GasHHDataOpted = 'C121';
        dataCapElem.GasDailyDataOpted = 'D121';      
        EON_UpdateAppointment_In_Isis_WS.UpdateAppointment updAppt = new EON_UpdateAppointment_In_Isis_WS.UpdateAppointment();
        updAppt.Header = header;
        updAppt.AppointmentDetails = apptDetailElem;
        updAppt.Contacts = conLst;
        updAppt.MeterLocations = mtrLocLst;
        updAppt.CommunicationTypes = commTypLst;
        updAppt.Parking = parkElem;         
        updAppt.DataCaptureConsents = dataCapElem;
        updAppt.Vulnerabilities = vul12;
        
        //Praveen Start CH07
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
                
        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement wanData = new 
                        EON_UpdateAppointment_In_Isis_WS.WANCoverageElement();
        wanData.CSPRegion = 'SOUTH'; 
        wanData.CoverageAvailability = 'Y';
        wanData.ConnectivityLikelihood = 'HIGH';
        wanData.CommsHubVariant = 'CELLULAR';
        wanData.AuxiliaryEquipmentrequired = 'TEST';
        wanData.AdditionalInformation = 'TEST_UPDATE'; 
        updAppt.WANCoverageDetails = wanData;                      
        //Praveen End CH07        
        
        EON_UpdateAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        /*keyCollElem.PersonName = 'test';
        keyCollElem.ContactNumber = '';
        apptDetailElem.KeyCollection = keyCollElem;
        updAppt.AppointmentDetails = apptDetailElem;*/
        response=EON_UpdateAppointment_In_Isis_WS.UpdateAppointment(updAppt); 
        String msgText = response.Messages.Message[0].MessageText;
        System.assertEquals(true, msgText.contains('OOA System is background processing this appointment. Please try again.'));
        test.stopTest();
    }
    //CH06.New.End
}