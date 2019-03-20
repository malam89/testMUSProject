/**
Description : This test class covers the code coverage for below class
                1. EON_Create_Appointment_Request_ctrl
**/
/* 
Created By    : Sivasankar K
Created On    : 17/05/2016
Service Req   : SR_EON_AB_033
Change History:
CH01 # SR_EON_PC_047 # 18/05/2016 # Krishna Yalavarthi # Deleted reference for Customer lookup on EON Fuel.
CH02 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
CH03 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
CH04 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
CH05 # SR_EON_AB_108 # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text 
CH06 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Deleted reference of field Vulnerability_Source__c
CH07 # SR_EON_AB_180 # 31/10/2016 # Mahadev J # Amended login to function AddRowCon
CH08 #18/11/2016 # Shivram Survase # Increased code coverage.
*/
@isTest
global class EON_Create_Appointment_Request_ctrlTest  {

    /**
    setupTestData() - this method will create the test data for covering the code coverage
    **/
    @testSetup
    static void setupTestData() {                   
        
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        eCust.Customer_Name__c = 'Eon_Test';
        insert eCust;
        EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
        eSite.Postcode__c = 'SE10 2';
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPAN__c = '12'; 
        eFuel.MPRN__c = '123';        
        eFuel.Premise__c = eSite.id;
        //eFuel.Customer__c = eCust.id; //CH01
        eFuel.Fuel_Type__c = 'E';
        insert eFuel;        
                
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH02.old//CH03
        Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = null);
        insert appt; 
                
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area5',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast3');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 2',Sub_Area_Name__c = subArea.id);
        insert pstCode; 
        
    }   
    
    /**
    EON_Job_Attribute_Test() - This method will cover the Job attributes and EON Job code error.
    **/
    static testMethod void EON_Job_Attribute_Test() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());
        EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();
        EON_Fuel__c fuel = [SELECT ID,Fuel_type__c,MPAN__c,MPRN__c,Gas_manufacturer_code_A0060__c,Gas_measuring_capacity_A0112__c,Gas_Meter_Mechanism__c,Gas_meter_serial_number__c,Gas_meter_type_A0025__c,Gas_model_A0083__c,Gas_number_of_dials_or_digits_A0121__c,Gas_payment_method_A0163__c,Gas_supplier_code__c,Premise__r.Building_Name__c,Premise__r.Dependant_Locality__c,Premise__r.Dependant_Thorofare__c,Premise__r.Double_Dependant_Locality__c,Premise__r.Sub_Building_Name__c,Premise__r.Thorofare__c,Premise__r.Town__c,Premise__r.Customer__c,Premise__r.Customer__r.Customer_Name__c,Premise__c,Premise__r.Postcode__c FROM EON_Fuel__c WHERE Fuel_Type__c = 'E'];
        crtAppt.selFuelRecord = fuel;
        List<EON_Job__c> lstJobs = new List<EON_Job__c>([SELECT ID,Name,Duration__c,h_Job_Attribute_Duration__c,Job_Type__c,Inactive__c,MAM_Reqd__c,MOP_Reqd__c,MPAN_Reqd__c,MPRN_Reqd__c FROM EON_Job__c]);
        
        crtAppt.selJobRecord = null;
        crtAppt.validateAppointmentBookingRequest();
        //CH08.Start
        EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c(Name='TestIt',Vulnerability_Code__c=32);
        insert vulCode;
        EON_Vulnerability_Code__c vulCode2 = new EON_Vulnerability_Code__c(Name='TestIt2',Vulnerability_Code__c=32);
       // insert vulCode2;
        Map < string, EON_Vulnerability_Code__c > eVulMap = new Map < string, EON_Vulnerability_Code__c >();
        eVulMap.put('Test',vulCode);
        eVulMap.put('Test2',vulCode2);
        Set < string > vulDetails= new Set < string > ();
        vulDetails.add('Test');
        crtAppt.eVulCodeMap=eVulMap;
        crtAppt.vulDetailCodeSet=vulDetails;
        crtAppt.validateAppointmentBookingRequest();
        Test.stopTest();
        //CH08.End
    }
    /**
        unitTest_PASS2() - unitTest Success test case.
    **/    
    
    public testmethod static void unitTest_PASS2() { 
        //Create EON Sub Area
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
         
        //Create EON Post Code
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='SG1 2', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        
        //Create EON Parking
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        
        //Create EON Electric Meter location
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        
        //
        Eon_Delivery_Method__c DM = new Eon_Delivery_Method__c(Name = 'X123',Code__c = 'E');
        insert DM;
        
        EON_Gas_Meter_Location__c GML = new EON_Gas_Meter_Location__c(Name = 'X124',Code__c ='12');
        insert GML;
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10); //CH09 - Added job type
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');
        insert objFuel;
        
        //Create EON Electric Meter Type
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;
        
        //Create EON Electric Meter Register
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        
        //Create EON Gas Meter Type
        EON_Gas_Meter_Type__c objGasType = new EON_Gas_Meter_Type__c(Name='test gas type', OFS_Enumeration__c=1);
        insert objGasType;
        
        //Create EON Contact Type 
        EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
        insert objConType;
        
        //Create EON Media Type
        EON_Media_Type__c objMedType1 = new EON_Media_Type__c(Name='A', Code__c='1');
        insert objMedType1;
        EON_Media_Type__c objMedType2 = new EON_Media_Type__c(Name='E', Code__c='E');
        insert objMedType2;
        //CH04.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='test';
        ssc.type__c='classic';
        insert ssc;
        //CH04.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61',Requested_SSC__c='61', //CH04.old
        //Requested_SSC__c=ssc.id,//CH06.old 
        EON_Appointment_ID__c='61',Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH04*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id, Metering_Point_Postcode__c='SG1 2ST');//Key_Person_Name__c='test key per name'Key_Contact_Number__c=852369741
        insert objAppointment;
        
        objAppointment.Sent_to_Oracle__c =true;
        update objAppointment;
        
        //Create EON Vulnerability Code
        //EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1,Vulnerability_Source__c='EON' ); //CH06.Old
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); //CH06.New
        insert objVulCode1;
        //EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2,Vulnerability_Source__c='EON'); //CH06.Old
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); //CH06.New
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id, VulnerabilityDetailCode__c = 1);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id, VulnerabilityDetailCode__c = 2);
        insert objVul2;
        
        //Create EON Appointment Contact
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        insert objCont;
        
        
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        EON_Appointment__c objApp = [select id, Name, h_Job_Type__c, Time_Slot__c, MPAN__c, Customer_Name__c, Metering_Point_Postcode__c,EON_Appointment_ID__c, Access_Pass_Phrase__c, Assisted_Work_Reason_Code__c, Additional_Information__c, MPRN__c,   
                                   E_Meter_Serial_Number__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, 
                                   E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c,E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c,  
                                   Certification_Date__c, G_Meter_Serial_Number__c, Gas_Regulator_Serial_Number__c, G_Meter_Make__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c, 
                                   G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c,Requested_SSC__c, //Requested_SSC__r.name,//CH06.old
                                   Key_Collection_Required__c, 
                                   Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, 
                                   Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c, Key_Contact_Number__c,//CH05
                                   Job_code__r.Name, 
                                   Job_code__r.h_Job_Attribute_Duration__c, Job_code__r.Duration__c, 
                                   Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c, Fuel_ID__r.MPAN__c, Duration__c, SubArea__c, Sent_to_Oracle__c,  
                                   Start_Time__c, End_Time__c, Caller_Name__c, Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c,  Oracle_Postcode_Sector__c, Appointment_Date__c,//CH04
                                   Fuel_ID__r.MPRN__c, h_OFSC_Metering_Pressure__c, h_OFSC_Number_of_Phases__c, h_OFSC_Planned_E_Meter_Type__c, h_OFSC_Planned_G_Meter_Type__c,  
                                   h_OFSC_Planned_Meter_Registers__c, h_OFSC_Planned_Meter_Mode__c, h_OFSC_Gas_bind_performed_flag__c, h_OFSC_Install_SED_flag__c, 
                                   h_OFSC_E_Check_Meter_Installed__c, h_OFSC_G_Check_Meter_Installed__c, h_OFSC_Assisted_Work_Reason_Code__c, E_Meter_Type__r.OFS_Enumeration__c, 
                                   G_Meter_Type__r.OFS_Enumeration__c, Parking_Type__r.OFS_Enumeration__c, E_Meter_Register_1_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_2_Name__r.OFS_Enumeration__c, E_Meter_Register_3_Name__r.OFS_Enumeration__c, E_Meter_Register_4_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_5_Name__r.OFS_Enumeration__c, E_Meter_Register_6_Name__r.OFS_Enumeration__c, Appointment_reason_code__r.OFS_Enumeration__c, 
                                   G_Meter_Location__r.OFS_Enumeration__c, E_Meter_Location__r.OFS_Enumeration__c, Sent_to_Oracle_Update__c, Job_code__r.SME_Duration__c,   
                                   Notes__c, Key_Double_Dependant_Locality__c, Key_Country__c, E_Meter_Location__c, G_Meter_Location__c, Parking_Type__c,  Elec_HH_Data_Opted__c,
                                   Elec_Daily_Data_Opted__c, Gas_HH_Data_Opted__c, Gas_Daily_Data_Opted__c, 
                                   E_Disconnection_warning_option_flag__c, E_Low_balance_alert_flag__c, E_Top_up_Notification_Opt_in_Flag__c, E_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   E_Payment_Reminder_Frequency_Code__c, E_Payment_Reminder_Day_Of_The_Week__c, E_Payment_Reminder_Date__c, E_LowBalanceAlertValue__c, //CH08
                                   G_Disconnection_warning_option_flag__c, G_Low_balance_alert_flag__c, G_Top_up_Notification_Opt_in_Flag__c, G_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   G_Payment_Reminder_Frequency_Code__c, G_Payment_Reminder_Day_Of_The_Week__c, G_Payment_Reminder_Date__c, G_LowBalanceAlertValue__c, //CH08
                                   Planned_Meter_Mode__c,Install_SED_flag__c,DVD_Requested__c,Braille__c,Call_2_Days_before_appointment_Required__c, //CH09
                                   (select id, name, Contact_Full_Name__c, Media_Detail__c from EON_Appointment_Contacts__r where Contact_Type__r.Name ='A' 
                                   and Media_Type__r.Name != 'E' order by createdDate desc limit 4), //CH04
                                   (select id, name, h_Vulnerability_Desc__c from EON_Appointment_Vulnerabilities__r)
                                   from EON_Appointment__c where id =:objAppointment.Id];
        
        list<EON_Appointment_Vulnerability__c> lstVul = [select id, name, h_Vulnerability_Desc__c, Description__c from EON_Appointment_Vulnerability__c 
                                                         where EON_Appointment_ID__c=:objAppointment.Id];
        list<EON_Appointment_Contact__c> lstCon = new list<EON_Appointment_Contact__c>();
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name1',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med1',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name2',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med2',Media_Type__c=objMedType2.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name3',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med3',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name4',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med4',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name5',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med5',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name6',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med6',Media_Type__c=objMedType1.Id));
        
        Eon_Delivery_Method__c DM1 = new Eon_Delivery_Method__c(Name = 'test_DM',Code__c = 'E');
        insert DM1;
        
        EON_Appointment_Comms__c comm1 = new EON_Appointment_Comms__c(); 
        comm1.EON_Appointment_ID__c = objAppointment.id;
        comm1.Comm_Type_Code__c = 'I';
        comm1.Delivery_Method_Desc__c = DM1.id;
        
        EON_Appointment_Comms__c comm2 = new EON_Appointment_Comms__c(); 
        comm2.EON_Appointment_ID__c = objAppointment.id;
        comm2.Comm_Type_Code__c = 'R';
        comm2.Delivery_Method_Desc__c = DM1.id;
        
        EON_Appointment_Comms__c comm3 = new EON_Appointment_Comms__c(); 
        comm3.EON_Appointment_ID__c = objAppointment.id;
        comm3.Comm_Type_Code__c = 'C';
        comm3.Delivery_Method_Desc__c = DM1.id;
        list<EON_Appointment_Comms__c> AClist = new list<EON_Appointment_Comms__c>();
        AClist.add(comm1);
        AClist.add(comm2);
        AClist.add(comm3);
        
        insert ACList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objApp);

        EON_Create_Appointment_Request_ctrl controller = new EON_Create_Appointment_Request_ctrl(sc);  
        controller.removeIndex = 1;
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        
        Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());
        
        controller.selectedMediaType = objMedType1.id;
        controller.selectedDeliveryMethod_I = DM1.id;
        controller.selectedDeliveryMethod_R = DM1.id;
        controller.selectedDeliveryMethod_c = DM1.id;
        controller.ApptCont = objCont;
        controller.setVisibilityPayg();//CH09
        controller.addRowCon();
        controller.removeRowCon();
        
        
        //
        controller.save();  
        controller.removeRow();  
        //EON_OFSC_Update_Appointment.sendActivityToOFSC(objApp, lstCon, lstVul, '');
        test.StopTest();
        
        //list<Oracle_Data_Tracker__c> lstTrac = new list<Oracle_Data_Tracker__c>([select id, name, Status__c from Oracle_Data_Tracker__c where EON_Appointment__c =: objAppointment.Id]);
        //system.debug('### lstTrac[0].Status__c: '+lstTrac[0].Status__c);
        //system.assertEquals('PASS',lstTrac[0].Status__c);
    }
    
    /**
        validateAddRowCon(): This method is to cover validation in method AddRowCon()
    **/
    static testmethod void validateAddRowCon(){
        EON_Contact_Type__c conType = new EON_Contact_Type__c();
        conType.name = 'test1';
        insert conType;
            
        list<EON_Media_Type__c> allMediaType = new list<EON_Media_Type__c>();
        EON_Media_Type__c mediaType1 = new EON_Media_Type__c();
        mediaType1.Name = 'Telephone';
        allMediaType.add(mediaType1);
        EON_Media_Type__c mediaType2 = new EON_Media_Type__c();
        mediaType2.Name = 'Email';
        allMediaType.add(mediaType2);
        EON_Media_Type__c mediaType3 = new EON_Media_Type__c();
        mediaType3.Name = 'Mobile';
        allMediaType.add(mediaType3);
        insert allMediaType;
            
        EON_Appointment__c appt = new EON_Appointment__c();
        insert appt;
            
        EON_Appointment_Contact__c apptContact = new EON_Appointment_Contact__c();
        apptContact.EON_Appointment_ID__c = appt.ID;
        apptContact.Contact_Full_Name__c = 'test';
        apptContact.Media_Detail__c = 'Test';
        apptContact.Media_Type__c = mediaType1.ID;
        insert apptContact;
            
        list<SelectOption> medTypeOption = new list<SelectOption>();
        medTypeOption.add(new SelectOption(mediaType1.ID, 'Telephone'));
        medTypeOption.add(new SelectOption(mediaType2.ID, 'Email'));
        medTypeOption.add(new SelectOption(mediaType3.ID, 'Mobile'));
            
        EON_Create_Appointment_Request_ctrl createAppt = new EON_Create_Appointment_Request_ctrl();
        createAppt.selectedContact = conType.ID;
        createAppt.selectedMediaType = mediaType1.ID;
        createAppt.ApptCont = apptContact;
        createAppt.MediaTypeLst = medTypeOption;
        PageReference pageref = createAppt.addRowCon();
        createAppt.selectedMediaType = mediaType2.ID;
        pageref = createAppt.addRowCon();
        createAppt.selectedMediaType = mediaType3.ID;
        pageref = createAppt.addRowCon();
        //CH08.Start
        EON_Appointment__c appt2 = new EON_Appointment__c(MPAN__c='14');
        insert appt2;
        appt.MPAN__c='12';
        appt.Requested_SSC__c=null;
        update appt;
        createAppt.newAppointment=appt2;
        createAppt.appt=appt;
        createAppt.save();
        appt.Requested_SSC__c='1223';
        appt.Key_Collection_Required__c=true;
        appt.Key_Contact_Number__c='Test';
        appt.E_LowBalanceAlertValue__c=224;
        appt.G_LowBalanceAlertValue__c=225;
        update appt;
        createAppt.appt=appt;
        createAppt.save();
        appt.Requested_SSC__c=null;
        update appt;
        createAppt.newAppointment=appt2;
        createAppt.appt=appt;
        createAppt.save();
        List < SelectOption > lstSelect = new List < SelectOption >();
        createAppt.MediaTypeLst = lstSelect ;
        PageReference pageref2 = createAppt.addRowCon();
        //CH08.End
    }
    //CH08.Start
    /**
        validateAppointmentRequestPass() - Positive test coverage for method validateAppointmentBookingRequest().
    **/
        
    static testMethod void validateAppointmentRequestPass() {                   
            
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            eFuel.Fuel_Type__c = 'E';
            insert eFuel; 
                 
            Eon_Delivery_Method__c DM1 = new Eon_Delivery_Method__c(Name = 'test_DM',Code__c = 'E');
            insert DM1;
            EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
            insert objEleMtrLoc;
            EON_Gas_Meter_Location__c GML = new EON_Gas_Meter_Location__c(Name = 'X124',Code__c ='12');
            insert GML;
            EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
            insert objParking;
            Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');
            insert Reason;
            EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(Name='MCL3PH',Elec_Meter_Type__c='E',Elec_Phase__c='PH',Work_Skill__c='MCL3PH');
            insert capacity;
            
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'Smart';
            lstEjob.add(job);
            insert lstEjob;       
       
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',Planned_E_Meter_Type__c='MCL',
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1',Job_Code__c = job.id,Planned_Meter_Mode__c='CR',Fuel_ID__c=eFuel.Id,Current_Phase__c='3Ph');
            insert appt;         
            
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;  
            
            EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c(Name='TestIt',Vulnerability_Code__c=32);
            insert vulCode;
            
            EON_Appointment_Comms__c appointComm1 = new EON_Appointment_Comms__c(Comm_Type_Code__c='R',EON_Appointment_ID__c=appt.Id);
            insert appointComm1;
            
            List<EON_Appointment_Contact__c> lstAppt = new List<EON_Appointment_Contact__c>();
            EON_Appointment_Contact__c  cont = new EON_Appointment_Contact__c(Contact_Full_Name__c='test');
            lstAppt.add(cont);
            insert lstAppt;
            
            
            List<EON_Appointment_Vulnerability__c> lstapptVul = new List<EON_Appointment_Vulnerability__c>();
            
            EON_Appointment_Vulnerability__c apptVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = appt.id);
            lstapptVul.add(apptVul);  
            insert lstapptVul;     
                   
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();        
            String stFID = eFuel.id;
            crtAppt.selectedFuelID = stFID;        
            crtAppt.selFuelRecord = null;
            crtAppt.selJobRecord = lstEjob;
            crtAppt.newAppointment = appt;        
            crtAppt.eonApptVulnerability = apptVul;
            crtAppt.eonApptVulnerabilities = lstapptVul;        
            crtAppt.removeIndex = 0;
            crtAppt.ApptComms =appointComm1;
            crtAppt.ApptCont=cont;
            test.StartTest(); 
            Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test()); 
            crtAppt.appt = appt;
            crtAppt.setVisibilityPayg();
            crtAppt.selectedDeliveryMethod_c=DM1.Id;
            crtAppt.selectedDeliveryMethod_I=DM1.Id;
            crtAppt.selectedDeliveryMethod_R=DM1.Id;
            crtAppt.selectedEMetLoc=objEleMtrLoc.Id;
            crtAppt.selectedGMetLoc=GML.Id;
            crtAppt.selectedParking=objParking.Id;
            crtAppt.selectedAppRea=Reason.Id;
            crtAppt.lstApptContact=lstAppt;
            crtAppt.appReason='Test';
            crtAppt.save();
            appt.MPAN__c='12';
            update appt;
            crtAppt.newAppointment = appt;
            crtAppt.appt=appt;
            crtAppt.save();
            
            test.StopTest();   
       }
       //CH08.End
}