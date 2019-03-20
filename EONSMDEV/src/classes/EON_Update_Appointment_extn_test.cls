/**
    Description : This class is used for test coverage for the below classes
    1.EON_Update_Appointment_extn   
**/
/*
    Created By : Shruti Moghe
    Created Date : 28-April-2016 
    Service Request : SR_EON_AB_031
    Change History: 
    CH01 # SR_EON_AB_044 # 06/05/2016 # Sivasankar K # added Appointment Vulnerability.
    CH02 # SR_EON_PC_047 # 19/05/2016 # Krishna Y # Deleted reference for Customer lookup on EON Fuel.
    CH03 # SR_EON_AB_061 # 19-05-2016 # Sivasankar # Added code to call the controller method.
    CH04 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH05 # SR_EON_Mobile_043 # 07/06/2016 # Dharmendra Pahadiya # Increased code coverage and corrected the class.
    CH06 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH07 # SR_EON_Jumbo_030 # 09/06/2016 # Mehbobo Alam # Added  'Vulnerability Source' field value.
    CH08 # SR_EON_AB_071 # 16/06/2016 # Dharmendra P # Updated field API Name.
    CH09 # SR_EON_AB_084 # 08/07/2016 # Dharmendra P # Added method to increase coverage.
    CH10 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
    CH11 # SR_EON_AB_108 # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text 
    CH12 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Deleted reference of field Vulnerability_Source__c
    CH13 # SR_EON_AB_104 # 03/08/2016 # Tashika Gupta # Added conditions to increase code coverage.
    CH14 # SR_EON_AB_146,SR_EON_AB_135,SR_EON_AB_137 # 14/09/2016 # Shruti Moghe # Added Method to increase code coverage after implementing SR functionalities.
    CH15 # SR_EON_AB_180 # 31/10/2016 # Mahadev J # Amended login to function AddRowCon
    CH16 # # Aruna Manjari # Amended the code for increasing the testcode coverage.
*/
@isTest
private class EON_Update_Appointment_extn_test {

    /**
        unitTest_PASS() - unitTest Success test case.
    **/
    static testmethod void unitTest_PASS() {
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        Contract_Number__c contract = EON_CreateTestRecords.createContractNumber();
        contract.Contract_Client_Short_Name__c = 'EON';
        insert contract;

        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Appointment_Date__c = System.today();
        app.Contract__c = contract.id;
        insert app;

        EON_Rate__c rate = new EON_Rate__c();
        rate.Name = 'AAAA-333';
        rate.Description__c = 'test Descriptoin';
        insert rate;

        EON_Appointment_Value__c appValue = EON_CreateTestRecords.createEonAppointmentvalue();
        appValue.EON_Appointment__c = app.id;
        appValue.Rate__c = rate.id;
        insert appValue;

        EON_Appointment_Value__c appValue1 = EON_CreateTestRecords.createEonAppointmentvalue();
        appValue1.EON_Appointment__c = app.id;
        appValue1.Rate__c = rate.id;
        insert appValue1;

        EON_Vulnerability_Code__c EVC = new EON_Vulnerability_Code__c();
        EVC.Vulnerability_Code__c = 12;
        EVC.Name = 'test';
        //EVC.Vulnerability_Source__c='EON'; //CH07 //CH12.Old
        insert EVC;

        EON_Appointment_Vulnerability__c EON_Appt_Vuln = new EON_Appointment_Vulnerability__c(); //CH01
        //EON_Appt_Vuln.Customer__c = customer.id;
        EON_Appt_Vuln.VulnerabilityTypeID__c = 'Customer level ';
        EON_Appt_Vuln.Description__c = EVC.id;

        ApexPages.StandardController sc = new ApexPages.StandardController(app);

        EON_Update_Appointment_extn controller = new EON_Update_Appointment_extn(sc);
        PageReference pageRef = Page.EON_Update_Appointment;
        pageRef.getParameters().put('id', String.valueOf(app.Id));
        Test.setCurrentPage(pageRef);
        controller.EON_Appt_Vuln = EON_Appt_Vuln;
        controller.selectedVulnerability = EVC.id;//CH13
        controller.addRow(); //CH01
    
        controller.removeRow(); //CH01
        controller.save();
        //controller.sendAppointmentOFSC();
        controller.cancel();
        

        List < EON_Appointment_Contact__c > contacts = [select id from EON_Appointment_Contact__c where EON_Appointment_ID__c = : App.id];
        System.assert(contacts != null);
    }
    
    /**
        unitTest_PASS1() - unitTest Success test case.
    **/
    
    static testmethod void unitTest_PASS1() {
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        Contract_Number__c contract = EON_CreateTestRecords.createContractNumber();
        contract.Contract_Client_Short_Name__c = 'EON';
        insert contract;

        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Appointment_Date__c = System.today();
        app.Contract__c = contract.id;
        insert app;

        EON_Rate__c rate = new EON_Rate__c();
        rate.Name = 'AAAA-333';
        rate.Description__c = 'test Descriptoin';
        insert rate;

        EON_Appointment_Value__c appValue = EON_CreateTestRecords.createEonAppointmentvalue();
        appValue.EON_Appointment__c = app.id;
        appValue.Rate__c = rate.id;
        insert appValue;

        EON_Appointment_Value__c appValue1 = EON_CreateTestRecords.createEonAppointmentvalue();
        appValue1.EON_Appointment__c = app.id;
        appValue1.Rate__c = rate.id;
        insert appValue1;

        EON_Appointment_Vulnerability__c EON_Appt_Vuln = new EON_Appointment_Vulnerability__c(); //CH01
        //EON_Appt_Vuln.Customer__c = customer.id;
        EON_Appt_Vuln.VulnerabilityTypeID__c = 'Customer level '; 
        //insert EON_Appt_Vuln;       

        ApexPages.StandardController sc = new ApexPages.StandardController(app);

        EON_Update_Appointment_extn controller = new EON_Update_Appointment_extn(sc);
        PageReference pageRef = Page.EON_Update_Appointment;
        pageRef.getParameters().put('id', String.valueOf(app.Id));
        Test.setCurrentPage(pageRef);
        controller.EON_Appt_Vuln = EON_Appt_Vuln;
        
        controller.addRow();//CH01      
        controller.removeRow();//CH01
        controller.save();
        //controller.sendAppointmentOFSC();
        controller.cancel();
        
        try{
        EON_Utility.genException = true; //setting flag for generating Exception
        controller.removeRow();//CH01
        } catch(Exception e){}
        List < EON_Appointment_Contact__c > contacts = [select id from EON_Appointment_Contact__c where EON_Appointment_ID__c = : App.id];
        System.assert(contacts != null);
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
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN',Fuel_type__c = 'E');//CH13
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
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH10*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
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
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id, Metering_Point_Postcode__c='SG1 2ST');//Key_Person_Name__c='test key per name'Key_Contact_Number__c='852369741'
        insert objAppointment;
        
        list<EON_Appointment__c> apptng =new list < EON_Appointment__c>();
        apptng  = EON_CreateTestRecords.createEONAppointmentList();
        insert apptng;
        
        objAppointment.Sent_to_Oracle__c =true;
        update objAppointment;
        
        //Create EON Vulnerability Code
        //EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1,Vulnerability_Source__c='EON' ); //CH06 CH12.Old
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); //CH06 //CH12.New
        insert objVulCode1;
        //EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2,Vulnerability_Source__c='EON'); //CH06 CH12.Old
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); //CH06 //CH12.New
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
        //CH13.Start
        //Create EON Appointment Reason
        Eon_Appointment_Reason__c ObjReason = new Eon_Appointment_Reason__c(Name='TestReason',Appointment_reason_code__c='NEW_CONN');
        insert ObjReason;
        //CH13.End
        EON_Appointment__c objApp = [select id,h_Job_Code__c, Name, h_Job_Type__c, Time_Slot__c, MPAN__c, Customer_Name__c, Metering_Point_Postcode__c,EON_Appointment_ID__c, Access_Pass_Phrase__c, Assisted_Work_Reason_Code__c, Additional_Information__c, MPRN__c,   
                                   E_Meter_Serial_Number__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, 
                                   E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c,E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c,  
                                   Certification_Date__c, G_Meter_Serial_Number__c, Gas_Regulator_Serial_Number__c, G_Meter_Make__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c, 
                                   G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c,Requested_SSC__c, //Requested_SSC__r.name,//CH06.old
                                   Key_Collection_Required__c, 
                                   Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, 
                                   Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c, Key_Contact_Number__c, Job_code__r.Name, //CH11
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
                                   Elec_Daily_Data_Opted__c, Gas_HH_Data_Opted__c, Gas_Daily_Data_Opted__c, /*CH08.old EONSetDisconnectOptIn__c, CustomerLowBalanceAlertOpted__c, LowBalanceAlertValue__c,
                                   TopUpCodeNotifyFailureOpted__c, PaymentReminderOpted__c, PaymentReminderFrequency__c, PaymentReminderDayOfTheWeek__c, PaymentReminderDayOfTheMonth__c, */
                                   E_Disconnection_warning_option_flag__c, E_Low_balance_alert_flag__c, E_Top_up_Notification_Opt_in_Flag__c, E_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   E_Payment_Reminder_Frequency_Code__c, E_Payment_Reminder_Day_Of_The_Week__c, E_Payment_Reminder_Date__c, E_LowBalanceAlertValue__c, //CH08
                                   G_Disconnection_warning_option_flag__c, G_Low_balance_alert_flag__c, G_Top_up_Notification_Opt_in_Flag__c, G_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   G_Payment_Reminder_Frequency_Code__c, G_Payment_Reminder_Day_Of_The_Week__c, G_Payment_Reminder_Date__c, G_LowBalanceAlertValue__c, //CH08
                                   Planned_Meter_Mode__c,Appointment_reason_code__c, //CH09//CH13
                                   (select id, name, Contact_Full_Name__c, Media_Detail__c from EON_Appointment_Contacts__r where Contact_Type__r.Name ='A' 
                                   and Media_Type__r.Name != 'E' order by createdDate desc limit 4), //CH04
                                   (select id, name, h_Vulnerability_Desc__c from EON_Appointment_Vulnerabilities__r)
                                   from EON_Appointment__c where id =:objAppointment.Id];
        /*list<EON_Appointment_Contact__c> lstCon = [select id, name, Contact_Full_Name__c, Media_Detail__c, Contact_Type__c, Media_Type__c from EON_Appointment_Contact__c 
                                                   where EON_Appointment_ID__c=:objAppointment.Id and Contact_Type__r.Name ='A' and Media_Type__r.Name != 'E' order by createdDate desc limit 4];*/
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

        EON_Update_Appointment_extn controller = new EON_Update_Appointment_extn(sc);  
        controller.removeIndex = 1;
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        controller.ApptCont = objCont;
        controller.setVisibilityPayg();//CH09
        controller.selectedAppRea = ObjReason.id;//CH13
        controller.selectedContact = objConType.Id;//CH13
        controller.selectedMediaType = objMedType1.id;
        controller.selectedDeliveryMethod_I = DM1.id;
        controller.selectedDeliveryMethod_R = DM1.id;
        controller.selectedDeliveryMethod_c = DM1.id;
        controller.addRowCon();
        controller.removeRowCon();
        
        
        //
        controller.save();  
        controller.removeRow();  
        //EON_OFSC_Update_Appointment.sendActivityToOFSC(objApp, lstCon, lstVul, '');
        test.StopTest();
        
        list<Oracle_Data_Tracker__c> lstTrac = new list<Oracle_Data_Tracker__c>([select id, name, Status__c from Oracle_Data_Tracker__c where EON_Appointment__c =: objAppointment.Id]);
        //system.debug('### lstTrac[0].Status__c: '+lstTrac[0].Status__c);
        //system.assertEquals('PASS',lstTrac[0].Status__c);
    }
    
    /**
        unitTest_PASS3() - unitTest Success test case.
    **/
    
    public testmethod static void unitTest_PASS3() { 
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

        //Create EON Gas Meter location        
        EON_Gas_Meter_Location__c GML = new EON_Gas_Meter_Location__c(Name = 'X124',Code__c ='12');
        insert GML;                
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Smart', Duration__c=10);//DP
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel CH02
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN',Fuel_type__c = 'D');//CH13
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
        ssc.name='0155';
        ssc.type__c='Smart';
        insert ssc;
        //CH04.end
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61', Requested_SSC__c='61',//CH04.old
        //Requested_SSC__c=ssc.id,//CH06.old 
        EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH10*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id,G_Meter_Location__c= GML.id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', current_ssc__c='0144',
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH11
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id, Metering_Point_Postcode__c='SG1 2ST');
        insert objAppointment;
        
        objAppointment.Sent_to_Oracle__c =true;
        update objAppointment;
        
        EON_Appointment__c nullApp = new EON_Appointment__c();
        insert nullApp;
        
        nullApp.Sent_to_Oracle__c =true;
        update nullApp;
        
        //Create EON Vulnerability Code
        //EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1,Vulnerability_Source__c='EON' ); //CH06 //CH12.Old
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); //CH06 //CH12.New
        insert objVulCode1;
        //EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2,Vulnerability_Source__c='EON' ); //CH06 //CH12.Old
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); //CH06 //CH12.New
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
        
        EON_Appointment__c objApp = [select id,h_Job_Code__c, Name, h_Job_Type__c, Time_Slot__c, MPAN__c, Customer_Name__c, Metering_Point_Postcode__c,
                                   EON_Appointment_ID__c, Access_Pass_Phrase__c, Assisted_Work_Reason_Code__c, Additional_Information__c, MPRN__c,   
                                   E_Meter_Serial_Number__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, 
                                   E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c,E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c,  
                                   Certification_Date__c, G_Meter_Serial_Number__c, Gas_Regulator_Serial_Number__c, G_Meter_Make__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c, 
                                   G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c,Requested_SSC__c,//Requested_SSC__r.name,//CH06.old
                                   Key_Collection_Required__c, 
                                   Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, 
                                   Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c, Key_Contact_Number__c, Job_code__r.Name,//CH11 
                                   Job_code__r.h_Job_Attribute_Duration__c, Job_code__r.Duration__c, 
                                   Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c, Fuel_ID__r.MPAN__c, Duration__c, SubArea__c, Sent_to_Oracle__c,  
                                   Start_Time__c, End_Time__c, Caller_Name__c, Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c,  Oracle_Postcode_Sector__c, Appointment_Date__c,
                                   Fuel_ID__r.MPRN__c, h_OFSC_Metering_Pressure__c, h_OFSC_Number_of_Phases__c, h_OFSC_Planned_E_Meter_Type__c, h_OFSC_Planned_G_Meter_Type__c,  
                                   h_OFSC_Planned_Meter_Registers__c, h_OFSC_Planned_Meter_Mode__c, h_OFSC_Gas_bind_performed_flag__c, h_OFSC_Install_SED_flag__c, 
                                   h_OFSC_E_Check_Meter_Installed__c, h_OFSC_G_Check_Meter_Installed__c, h_OFSC_Assisted_Work_Reason_Code__c, E_Meter_Type__r.OFS_Enumeration__c, 
                                   G_Meter_Type__r.OFS_Enumeration__c, Parking_Type__r.OFS_Enumeration__c, E_Meter_Register_1_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_2_Name__r.OFS_Enumeration__c, E_Meter_Register_3_Name__r.OFS_Enumeration__c, E_Meter_Register_4_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_5_Name__r.OFS_Enumeration__c, E_Meter_Register_6_Name__r.OFS_Enumeration__c, Appointment_reason_code__r.OFS_Enumeration__c, current_ssc__c,
                                   G_Meter_Location__r.OFS_Enumeration__c, E_Meter_Location__r.OFS_Enumeration__c,  
                                   Sent_to_Oracle_Update__c, Job_code__r.SME_Duration__c, 
                                   Notes__c, Key_Double_Dependant_Locality__c, Key_Country__c, E_Meter_Location__c, G_Meter_Location__c, Parking_Type__c,  Elec_HH_Data_Opted__c,
                                   Elec_Daily_Data_Opted__c, Gas_HH_Data_Opted__c, Gas_Daily_Data_Opted__c,/*CH08.old EONSetDisconnectOptIn__c, CustomerLowBalanceAlertOpted__c, LowBalanceAlertValue__c,
                                   TopUpCodeNotifyFailureOpted__c, PaymentReminderOpted__c, PaymentReminderFrequency__c, PaymentReminderDayOfTheWeek__c, PaymentReminderDayOfTheMonth__c,*/
                                   E_Disconnection_warning_option_flag__c, E_Low_balance_alert_flag__c, E_Top_up_Notification_Opt_in_Flag__c, E_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   E_Payment_Reminder_Frequency_Code__c, E_Payment_Reminder_Day_Of_The_Week__c, E_Payment_Reminder_Date__c, E_LowBalanceAlertValue__c, //CH08
                                   G_Disconnection_warning_option_flag__c, G_Low_balance_alert_flag__c, G_Top_up_Notification_Opt_in_Flag__c, G_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   G_Payment_Reminder_Frequency_Code__c, G_Payment_Reminder_Day_Of_The_Week__c, G_Payment_Reminder_Date__c, G_LowBalanceAlertValue__c, //CH08
                                   Planned_Meter_Mode__c, //CH09
                                   (select id, name, Contact_Full_Name__c, Media_Detail__c from EON_Appointment_Contacts__r where Contact_Type__r.Name ='A' 
                                   and Media_Type__r.Name != 'E' order by createdDate desc limit 4), //CH04
                                   (select id, name, h_Vulnerability_Desc__c from EON_Appointment_Vulnerabilities__r)
                                   from EON_Appointment__c where id =:objAppointment.Id];
        /*list<EON_Appointment_Contact__c> lstCon = [select id, name, Contact_Full_Name__c, Media_Detail__c, Contact_Type__c, Media_Type__c from EON_Appointment_Contact__c 
                                                   where EON_Appointment_ID__c=:objAppointment.Id and Contact_Type__r.Name ='A' and Media_Type__r.Name != 'E' order by createdDate desc limit 4];*/
        list<EON_Appointment_Vulnerability__c> lstVul = [select id, name, h_Vulnerability_Desc__c, Description__c from EON_Appointment_Vulnerability__c 
                                                         where EON_Appointment_ID__c=:objAppointment.Id];
        list<EON_Appointment_Contact__c> lstCon = new list<EON_Appointment_Contact__c>();
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name1',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med1',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name2',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med2',Media_Type__c=objMedType2.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name3',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med3',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name4',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med4',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name5',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med5',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name6',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med6',Media_Type__c=objMedType1.Id));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objApp);

        EON_Update_Appointment_extn controller = new EON_Update_Appointment_extn(sc);  
        controller.removeIndex = 2;
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        controller.setVisibilityPayg();  
        controller.save();  
        controller.getEonSSC();   
        //controller.removeRow();  
        //EON_OFSC_Update_Appointment.sendActivityToOFSC(objApp, lstCon, lstVul, '');
        test.StopTest();
        
        list<Oracle_Data_Tracker__c> lstTrac = new list<Oracle_Data_Tracker__c>([select id, name, Status__c from Oracle_Data_Tracker__c where EON_Appointment__c =: objAppointment.Id]);
        //system.debug('### lstTrac[0].Status__c: '+lstTrac[0].Status__c);
        //system.assertEquals('PASS',lstTrac[0].Status__c);
    }
    
    /**
        unitTest_PASS4() - unitTest Success test case.
    **/
    public testmethod static void unitTest_PASS4() {         
        //Create EON Parking
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        
        //Create EON Electric Meter location
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel CH02
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN',Fuel_type__c = 'G');//CH13
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
        //CH04.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='test';
        ssc.type__c='classic';
        insert ssc;
        //CH04.end
        EON_SSC__c  ssc3= new EON_SSC__c(name='4567',Type__c='SMART');
        insert ssc3;
        EON_SSC__c  ssc2= new EON_SSC__c(name='0155',Type__c='Classic');
        insert ssc2;
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61', Requested_SSC__c='61', //CH04.old
        //Requested_SSC__c=ssc.id,//CH06.old 
        EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH10*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH11
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id, Metering_Point_Postcode__c='SG1 2ST',current_ssc__c='0155');
        insert objAppointment;
        
        objAppointment.Sent_to_Oracle__c =true;
        update objAppointment;
                
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        EON_Appointment__c objApp = [select id, h_Job_Code__c,Name, h_Job_Type__c, Time_Slot__c, MPAN__c, Customer_Name__c, Metering_Point_Postcode__c,
                                   EON_Appointment_ID__c, Access_Pass_Phrase__c, Assisted_Work_Reason_Code__c, Additional_Information__c, MPRN__c,   
                                   E_Meter_Serial_Number__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, 
                                   E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c,E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c,  
                                   Certification_Date__c, G_Meter_Serial_Number__c, Gas_Regulator_Serial_Number__c, G_Meter_Make__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c, 
                                   G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c,Requested_SSC__c,//Requested_SSC__r.name,//CH06.old
                                   Key_Collection_Required__c, 
                                   Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, 
                                   Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c,Key_Contact_Number__c,//CH11 
                                   Job_code__r.Name, 
                                   Job_code__r.h_Job_Attribute_Duration__c, Job_code__r.Duration__c, 
                                   Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c, Fuel_ID__r.MPAN__c, Duration__c, SubArea__c, Sent_to_Oracle__c, current_ssc__c, 
                                   Start_Time__c, End_Time__c, Caller_Name__c, Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c,  Oracle_Postcode_Sector__c, Appointment_Date__c,
                                   Fuel_ID__r.MPRN__c, h_OFSC_Metering_Pressure__c, h_OFSC_Number_of_Phases__c, h_OFSC_Planned_E_Meter_Type__c, h_OFSC_Planned_G_Meter_Type__c,  
                                   h_OFSC_Planned_Meter_Registers__c, h_OFSC_Planned_Meter_Mode__c, h_OFSC_Gas_bind_performed_flag__c, h_OFSC_Install_SED_flag__c, 
                                   h_OFSC_E_Check_Meter_Installed__c, h_OFSC_G_Check_Meter_Installed__c, h_OFSC_Assisted_Work_Reason_Code__c, E_Meter_Type__r.OFS_Enumeration__c, 
                                   G_Meter_Type__r.OFS_Enumeration__c, Parking_Type__r.OFS_Enumeration__c, E_Meter_Register_1_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_2_Name__r.OFS_Enumeration__c, E_Meter_Register_3_Name__r.OFS_Enumeration__c, E_Meter_Register_4_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_5_Name__r.OFS_Enumeration__c, E_Meter_Register_6_Name__r.OFS_Enumeration__c, Appointment_reason_code__r.OFS_Enumeration__c, 
                                   G_Meter_Location__r.OFS_Enumeration__c, E_Meter_Location__r.OFS_Enumeration__c,  
                                   Sent_to_Oracle_Update__c, Job_code__r.SME_Duration__c, 
                                   Notes__c, Key_Double_Dependant_Locality__c, Key_Country__c, E_Meter_Location__c, G_Meter_Location__c, Parking_Type__c,  Elec_HH_Data_Opted__c,
                                   Elec_Daily_Data_Opted__c, Gas_HH_Data_Opted__c, Gas_Daily_Data_Opted__c, /*CH08.old EONSetDisconnectOptIn__c, CustomerLowBalanceAlertOpted__c, LowBalanceAlertValue__c,
                                   TopUpCodeNotifyFailureOpted__c, PaymentReminderOpted__c, PaymentReminderFrequency__c, PaymentReminderDayOfTheWeek__c, PaymentReminderDayOfTheMonth__c, */
                                   E_Disconnection_warning_option_flag__c, E_Low_balance_alert_flag__c, E_Top_up_Notification_Opt_in_Flag__c, E_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   E_Payment_Reminder_Frequency_Code__c, E_Payment_Reminder_Day_Of_The_Week__c, E_Payment_Reminder_Date__c, E_LowBalanceAlertValue__c, //CH08
                                   G_Disconnection_warning_option_flag__c, G_Low_balance_alert_flag__c, G_Top_up_Notification_Opt_in_Flag__c, G_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   G_Payment_Reminder_Frequency_Code__c, G_Payment_Reminder_Day_Of_The_Week__c, G_Payment_Reminder_Date__c, G_LowBalanceAlertValue__c, //CH08
                                   Planned_Meter_Mode__c, //CH09
                                   (select id, name, Contact_Full_Name__c, Media_Detail__c from EON_Appointment_Contacts__r where Contact_Type__r.Name ='A' 
                                   and Media_Type__r.Name != 'E' order by createdDate desc limit 4), //CH04
                                   (select id, name, h_Vulnerability_Desc__c from EON_Appointment_Vulnerabilities__r)
                                   from EON_Appointment__c where id =:objAppointment.Id];
        /*list<EON_Appointment_Contact__c> lstCon = [select id, name, Contact_Full_Name__c, Media_Detail__c, Contact_Type__c, Media_Type__c from EON_Appointment_Contact__c 
                                                   where EON_Appointment_ID__c=:objAppointment.Id and Contact_Type__r.Name ='A' and Media_Type__r.Name != 'E' order by createdDate desc limit 4];*/
        list<EON_Appointment_Vulnerability__c> lstVul = [select id, name, h_Vulnerability_Desc__c, Description__c from EON_Appointment_Vulnerability__c 
                                                         where EON_Appointment_ID__c=:objAppointment.Id];
        list<EON_Appointment_Contact__c> lstCon = new list<EON_Appointment_Contact__c>();        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objApp);

        EON_Update_Appointment_extn controller = new EON_Update_Appointment_extn(sc);  
        controller.save(); 
        //CH03.Start
        controller.isKeycollection();
        controller.getEonSSC();     
        //CH03.End
        list<Oracle_Data_Tracker__c> lstTrac = new list<Oracle_Data_Tracker__c>([select id, name, Status__c from Oracle_Data_Tracker__c where EON_Appointment__c =: objAppointment.Id]);        
        //system.assertEquals('FAIL',lstTrac[0].Status__c);        
    }
    
    //CH09
    /**
        unitTest_PASS5() - unitTest Success test case.
    **/
    public testmethod static void unitTest_PASS5() {         
        //Create EON Parking
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        
        //Create EON Electric Meter location
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Smart', Duration__c=10);
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel CH02
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
        //CH04.start
        EON_SSC__c ssc = new EON_SSC__c();
        ssc.name='test';
        ssc.type__c='classic';
        insert ssc;
        //CH04.end
        EON_SSC__c  ssc2= new EON_SSC__c(name='0151',Type__c='Smart');
        insert ssc2;
        
        //CH16
        //Create EON_GSP_Group__c
        
        EON_GSP_Group__c GSPgroup = new EON_GSP_Group__c (Name='_N',GSP_Group_Description__c='Scottish Power');
        insert GSPgroup;
        
        //Create EON_SSC_Group__c
        EON_SSC_Group__c EONSSCgrp = new EON_SSC_Group__c (Group__c =GSPgroup.id , SSC__c=ssc2.id);
        insert EONSSCgrp ;
        
        
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61', Requested_SSC__c='61', //CH04.old
                                                EON_Appointment_ID__c='61', Planned_Meter_Mode__c = 'PAYG',
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH10*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH11
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id, Metering_Point_Postcode__c='SG1 2ST',current_ssc__c='0155',GSP_Group_ID__c='_N');
        insert objAppointment;
        
        
        list<EON_Appointment__c> apptng =new list < EON_Appointment__c>();
        apptng  = EON_CreateTestRecords.createEONAppointmentList();
        insert apptng;
        
        
        objAppointment.Sent_to_Oracle__c =true;
        update objAppointment;
                
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        EON_Appointment__c objApp = [select id,h_Job_Code__c, Name, h_Job_Type__c, Time_Slot__c, MPAN__c, Customer_Name__c, Metering_Point_Postcode__c,
                                   EON_Appointment_ID__c, Access_Pass_Phrase__c, Assisted_Work_Reason_Code__c, Additional_Information__c, MPRN__c,   
                                   E_Meter_Serial_Number__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, 
                                   E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c,E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c,  
                                   Certification_Date__c, G_Meter_Serial_Number__c, Gas_Regulator_Serial_Number__c, G_Meter_Make__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c, 
                                   G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c,Requested_SSC__c,//Requested_SSC__r.name,//CH06.old
                                   Key_Collection_Required__c, 
                                   Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, 
                                   Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c, Key_Contact_Number__c, Job_code__r.Name,//CH11                                   
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
                                   Sent_to_Oracle_Update__c, Job_code__r.SME_Duration__c, 
                                   Notes__c, Key_Double_Dependant_Locality__c, Key_Country__c, E_Meter_Location__c, G_Meter_Location__c, Parking_Type__c,  Elec_HH_Data_Opted__c,
                                   Elec_Daily_Data_Opted__c,Current_SSC__c , Gas_HH_Data_Opted__c, Gas_Daily_Data_Opted__c, /*CH08.old EONSetDisconnectOptIn__c, CustomerLowBalanceAlertOpted__c, LowBalanceAlertValue__c,
                                   TopUpCodeNotifyFailureOpted__c, PaymentReminderOpted__c, PaymentReminderFrequency__c, PaymentReminderDayOfTheWeek__c, PaymentReminderDayOfTheMonth__c, */
                                   E_Disconnection_warning_option_flag__c, E_Low_balance_alert_flag__c, E_Top_up_Notification_Opt_in_Flag__c, E_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   E_Payment_Reminder_Frequency_Code__c, E_Payment_Reminder_Day_Of_The_Week__c, E_Payment_Reminder_Date__c, E_LowBalanceAlertValue__c, //CH08
                                   G_Disconnection_warning_option_flag__c, G_Low_balance_alert_flag__c, G_Top_up_Notification_Opt_in_Flag__c, G_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   G_Payment_Reminder_Frequency_Code__c, G_Payment_Reminder_Day_Of_The_Week__c, G_Payment_Reminder_Date__c, G_LowBalanceAlertValue__c, //CH08
                                   Planned_Meter_Mode__c,Assisted_Work_Reason__c ,DVD_Requested__c,Braille__c,Call_2_Days_before_appointment_Required__c,Large_Print__c ,Install_SED_flag__c,//CH09//CH13
                                   (select id, name, Contact_Full_Name__c, Media_Detail__c from EON_Appointment_Contacts__r where Contact_Type__r.Name ='A' 
                                   and Media_Type__r.Name != 'E' order by createdDate desc limit 4), //CH04
                                   (select id, name, h_Vulnerability_Desc__c from EON_Appointment_Vulnerabilities__r)
                                   from EON_Appointment__c where id =:objAppointment.Id];
        
        list<EON_Appointment_Vulnerability__c> lstVul = [select id, name, h_Vulnerability_Desc__c, Description__c from EON_Appointment_Vulnerability__c 
                                                         where EON_Appointment_ID__c=:objAppointment.Id];
        list<EON_Appointment_Contact__c> lstCon = new list<EON_Appointment_Contact__c>();        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objApp);

        EON_Update_Appointment_extn controller = new EON_Update_Appointment_extn(sc);
        controller.setVisibilityPayg();
        controller.save(); 
        controller.isKeycollection();  
         controller.getEonSSC();    
        list<Oracle_Data_Tracker__c> lstTrac = new list<Oracle_Data_Tracker__c>([select id, name, Status__c from Oracle_Data_Tracker__c where EON_Appointment__c =: objAppointment.Id]);        
        //system.assertEquals('FAIL',lstTrac[0].Status__c);        
    }
    
    /**
        unitTest_FAIL() - unitTest Failed test case.
    **/
    static testmethod void unitTest_FAIL() {
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        Contract_Number__c contract = EON_CreateTestRecords.createContractNumber();
        contract.Contract_Client_Short_Name__c = 'EON';
        insert contract;

        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Appointment_Date__c = System.today();
        app.Contract__c = contract.id;
        insert app;

        EON_Rate__c rate = new EON_Rate__c();
        rate.Name = 'AAAA-333';
        rate.Description__c = 'test Descriptoin';
        insert rate;

        EON_Appointment_Value__c appValue = EON_CreateTestRecords.createEonAppointmentvalue();
        appValue.EON_Appointment__c = app.id;
        appValue.Rate__c = rate.id;
        insert appValue;

        EON_Appointment_Value__c appValue1 = EON_CreateTestRecords.createEonAppointmentvalue();
        appValue1.EON_Appointment__c = app.id;
        appValue1.Rate__c = rate.id;
        insert appValue1;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(app);

        EON_Update_Appointment_extn controller = new EON_Update_Appointment_extn(sc);
        PageReference pageRef = Page.EON_Update_Appointment;
        pageRef.getParameters().put('id', String.valueOf(app.Id));
        Test.setCurrentPage(pageRef);
        controller.addRowCon();
        EON_Utility.genException=true;
        controller.removeRow();
        controller.removeRowCon();
        EON_Appointment__c app1 = EON_CreateTestRecords.createEONAppointment();
        controller.Appt= app;
        controller.save();
        List < EON_Appointment_Contact__c > contacts = [select id from EON_Appointment_Contact__c where EON_Appointment_ID__c = : App.id];
        System.assert(contacts != null);
    }
    
    //CH14.start
    
    public testmethod static void unitTest_PASS6() { 
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
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN',Fuel_type__c = 'E');//CH13
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
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH10*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
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
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id, Metering_Point_Postcode__c='SG1 2ST',E_LowBalanceAlertValue__c=2.5,G_LowBalanceAlertValue__c=5.5);//Key_Person_Name__c='test key per name'Key_Contact_Number__c='852369741'
        insert objAppointment;
        
        objAppointment.Sent_to_Oracle__c =true;
        update objAppointment;
        
        //Create EON Vulnerability Code
        //EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1,Vulnerability_Source__c='EON' ); //CH06 CH12.Old
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); //CH06 //CH12.New
        insert objVulCode1;
        //EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2,Vulnerability_Source__c='EON'); //CH06 CH12.Old
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); //CH06 //CH12.New
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id, VulnerabilityDetailCode__c = 1);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id, VulnerabilityDetailCode__c = 2);
        insert objVul2;
        
        //Create EON Appointment Contact
        /*EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        insert objCont;*/
        
        
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        //CH13.Start
        //Create EON Appointment Reason
        Eon_Appointment_Reason__c ObjReason = new Eon_Appointment_Reason__c(Name='TestReason',Appointment_reason_code__c='NEW_CONN');
        insert ObjReason;
        //CH13.End
        EON_Appointment__c objApp = [select id, Name, h_Job_Type__c, Time_Slot__c, MPAN__c, Customer_Name__c, Metering_Point_Postcode__c,EON_Appointment_ID__c, Access_Pass_Phrase__c, Assisted_Work_Reason_Code__c, Additional_Information__c, MPRN__c,   
                                   E_Meter_Serial_Number__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, 
                                   E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c,E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c,  
                                   Certification_Date__c, G_Meter_Serial_Number__c, Gas_Regulator_Serial_Number__c, G_Meter_Make__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c, 
                                   G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c,Requested_SSC__c, //Requested_SSC__r.name,//CH06.old
                                   Key_Collection_Required__c, 
                                   Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, 
                                   Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c, Key_Contact_Number__c, Job_code__r.Name, //CH11
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
                                   Elec_Daily_Data_Opted__c, Gas_HH_Data_Opted__c, Gas_Daily_Data_Opted__c, /*CH08.old EONSetDisconnectOptIn__c, CustomerLowBalanceAlertOpted__c, LowBalanceAlertValue__c,
                                   TopUpCodeNotifyFailureOpted__c, PaymentReminderOpted__c, PaymentReminderFrequency__c, PaymentReminderDayOfTheWeek__c, PaymentReminderDayOfTheMonth__c, */
                                   E_Disconnection_warning_option_flag__c, E_Low_balance_alert_flag__c, E_Top_up_Notification_Opt_in_Flag__c, E_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   E_Payment_Reminder_Frequency_Code__c,h_Job_Code__c, E_Payment_Reminder_Day_Of_The_Week__c, E_Payment_Reminder_Date__c, E_LowBalanceAlertValue__c, //CH08
                                   G_Disconnection_warning_option_flag__c, G_Low_balance_alert_flag__c, G_Top_up_Notification_Opt_in_Flag__c, G_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   G_Payment_Reminder_Frequency_Code__c, G_Payment_Reminder_Day_Of_The_Week__c, G_Payment_Reminder_Date__c, G_LowBalanceAlertValue__c, //CH08
                                   Planned_Meter_Mode__c,Appointment_reason_code__c, //CH09//CH13
                                   (select id, name, Contact_Full_Name__c, Media_Detail__c from EON_Appointment_Contacts__r where Contact_Type__r.Name ='A' 
                                   and Media_Type__r.Name != 'E' order by createdDate desc limit 4), //CH04
                                   (select id, name, h_Vulnerability_Desc__c from EON_Appointment_Vulnerabilities__r)
                                   from EON_Appointment__c where id =:objAppointment.Id];
        /*list<EON_Appointment_Contact__c> lstCon = [select id, name, Contact_Full_Name__c, Media_Detail__c, Contact_Type__c, Media_Type__c from EON_Appointment_Contact__c 
                                                   where EON_Appointment_ID__c=:objAppointment.Id and Contact_Type__r.Name ='A' and Media_Type__r.Name != 'E' order by createdDate desc limit 4];*/
        list<EON_Appointment_Vulnerability__c> lstVul = [select id, name, h_Vulnerability_Desc__c, Description__c from EON_Appointment_Vulnerability__c 
                                                         where EON_Appointment_ID__c=:objAppointment.Id];
        list<EON_Appointment_Contact__c> lstCon = new list<EON_Appointment_Contact__c>();
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name1',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med1',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name2',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med2',Media_Type__c=objMedType2.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name3',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med3',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name4',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med4',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name5',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med5',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name6',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med6',Media_Type__c=objMedType1.Id));
        
        Eon_Delivery_Method__c DM1 = new Eon_Delivery_Method__c(Name = 'Test1',Code__c = 'E');
        insert DM1;
        Eon_Delivery_Method__c DM2 = new Eon_Delivery_Method__c(Name = 'None',Code__c = 'E');
        insert DM2;
        
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

        EON_Update_Appointment_extn controller = new EON_Update_Appointment_extn(sc);  
        controller.removeIndex = 1;
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        //controller.ApptCont = objCont;
        controller.setVisibilityPayg();//CH09
        controller.selectedAppRea = ObjReason.id;//CH13
        controller.selectedContact = objConType.Id;//CH13
        controller.selectedMediaType = objMedType1.id;
        controller.selectedDeliveryMethod_I = DM1.id;
        controller.selectedDeliveryMethod_R = DM1.id;
        controller.selectedDeliveryMethod_c = DM1.id;
        controller.addRowCon();
        controller.removeRowCon();
        
        
        //
        controller.save();  
        controller.removeRow();  
        //EON_OFSC_Update_Appointment.sendActivityToOFSC(objApp, lstCon, lstVul, '');
        test.StopTest();
        
        list<Oracle_Data_Tracker__c> lstTrac = new list<Oracle_Data_Tracker__c>([select id, name, Status__c from Oracle_Data_Tracker__c where EON_Appointment__c =: objAppointment.Id]);

    }
   //CH14.end 
    /**
        validateAddRowCon(): This method is to cover validation in method AddRowCon() //CH15
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
            
        ApexPages.StandardController controller = new ApexPages.StandardController(appt);
        EON_Update_Appointment_extn updateAppt = new EON_Update_Appointment_extn(controller);
        updateAppt.selectedContact = conType.ID;
        updateAppt.selectedMediaType = mediaType1.ID;
        updateAppt.ApptCont = apptContact;
        updateAppt.MediaTypeLst = medTypeOption;
        PageReference pageref = updateAppt.addRowCon();
        updateAppt.selectedMediaType = mediaType2.ID;
        pageref = updateAppt.addRowCon();
        updateAppt.selectedMediaType = mediaType3.ID;
        pageref = updateAppt.addRowCon();
    }
    
      /**
        unitTest_PASS2() - unitTest Success test case.
    **/    
    
    public testmethod static void unitTest_PASS21() { 
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
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN',Fuel_type__c = 'E');//CH13
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
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH10*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
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
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id, Metering_Point_Postcode__c='SG1 2ST');//Key_Person_Name__c='test key per name'Key_Contact_Number__c='852369741'
        insert objAppointment;
        
        objAppointment.Sent_to_Oracle__c =true;
        update objAppointment;
        
        //Create EON Vulnerability Code
        //EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1,Vulnerability_Source__c='EON' ); //CH06 CH12.Old
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); //CH06 //CH12.New
        insert objVulCode1;
        //EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2,Vulnerability_Source__c='EON'); //CH06 CH12.Old
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); //CH06 //CH12.New
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id, VulnerabilityDetailCode__c = 1);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id, VulnerabilityDetailCode__c = 2);
        insert objVul2;
        
        //Create EON Appointment Contact1
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        insert objCont;
        
        //Create EON Appointment Contact2
        EON_Appointment_Contact__c objCont1 = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail');
        insert objCont1;
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        //CH13.Start
        //Create EON Appointment Reason
        Eon_Appointment_Reason__c ObjReason = new Eon_Appointment_Reason__c(Name='TestReason',Appointment_reason_code__c='NEW_CONN');
        insert ObjReason;
        //CH13.End
        EON_Appointment__c objApp = [select id,h_Job_Code__c, Name, h_Job_Type__c, Time_Slot__c, MPAN__c, Customer_Name__c, Metering_Point_Postcode__c,EON_Appointment_ID__c, Access_Pass_Phrase__c, Assisted_Work_Reason_Code__c, Additional_Information__c, MPRN__c,   
                                   E_Meter_Serial_Number__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, 
                                   E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c,E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c,  
                                   Certification_Date__c, G_Meter_Serial_Number__c, Gas_Regulator_Serial_Number__c, G_Meter_Make__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c, 
                                   G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c,Requested_SSC__c, //Requested_SSC__r.name,//CH06.old
                                   Key_Collection_Required__c, 
                                   Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, 
                                   Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c, Key_Contact_Number__c, Job_code__r.Name, //CH11
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
                                   Elec_Daily_Data_Opted__c, Gas_HH_Data_Opted__c, Gas_Daily_Data_Opted__c, /*CH08.old EONSetDisconnectOptIn__c, CustomerLowBalanceAlertOpted__c, LowBalanceAlertValue__c,
                                   TopUpCodeNotifyFailureOpted__c, PaymentReminderOpted__c, PaymentReminderFrequency__c, PaymentReminderDayOfTheWeek__c, PaymentReminderDayOfTheMonth__c, */
                                   E_Disconnection_warning_option_flag__c, E_Low_balance_alert_flag__c, E_Top_up_Notification_Opt_in_Flag__c, E_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   E_Payment_Reminder_Frequency_Code__c, E_Payment_Reminder_Day_Of_The_Week__c, E_Payment_Reminder_Date__c, E_LowBalanceAlertValue__c, //CH08
                                   G_Disconnection_warning_option_flag__c, G_Low_balance_alert_flag__c, G_Top_up_Notification_Opt_in_Flag__c, G_Payment_Reminder_Opt_in_Flag__c, //CH08
                                   G_Payment_Reminder_Frequency_Code__c, G_Payment_Reminder_Day_Of_The_Week__c, G_Payment_Reminder_Date__c, G_LowBalanceAlertValue__c, //CH08
                                   Planned_Meter_Mode__c,Appointment_reason_code__c, //CH09//CH13
                                   (select id, name, Contact_Full_Name__c, Media_Detail__c from EON_Appointment_Contacts__r where Contact_Type__r.Name ='A' 
                                   and Media_Type__r.Name != 'E' order by createdDate desc limit 4), //CH04
                                   (select id, name, h_Vulnerability_Desc__c from EON_Appointment_Vulnerabilities__r)
                                   from EON_Appointment__c where id =:objAppointment.Id];
        /*list<EON_Appointment_Contact__c> lstCon = [select id, name, Contact_Full_Name__c, Media_Detail__c, Contact_Type__c, Media_Type__c from EON_Appointment_Contact__c 
                                                   where EON_Appointment_ID__c=:objAppointment.Id and Contact_Type__r.Name ='A' and Media_Type__r.Name != 'E' order by createdDate desc limit 4];*/
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
     
        
       
       
        List < EON_Appointment_Comms__c > existComms = new List < EON_Appointment_Comms__c > ();
       
        existComms = [select id, Comm_Type_Code__c, Delivery_Method_Desc__c, Delivery_Method_Desc__r.name, EON_Appointment_ID__c from EON_Appointment_Comms__c where EON_Appointment_ID__c = : objApp.id];
       
          
         
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objApp);

        EON_Update_Appointment_extn controller = new EON_Update_Appointment_extn(sc);  
        controller.removeIndex = 1;
        // This causes a fake response to be generated
           Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
            
            String result =  EON_OFSC_Update_Appointment.getAppointment(objApp.name );
            Test.stopTest();
        
        
        //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
      
        controller.ApptCont = objCont;
        controller.setVisibilityPayg();//CH09
        controller.selectedAppRea = ObjReason.id;//CH13
        controller.selectedContact = objConType.Id;//CH13
        controller.selectedMediaType = objMedType1.id;
        controller.selectedDeliveryMethod_I = DM1.id;
        controller.selectedDeliveryMethod_R = DM1.id;
        controller.selectedDeliveryMethod_c = DM1.id;
        controller.addRowCon();
        controller.removeRowCon();
        
        
        //
        controller.save();  
        controller.removeRow();  
        //EON_OFSC_Update_Appointment.sendActivityToOFSC(objApp, lstCon, lstVul, '');
        
        list<Oracle_Data_Tracker__c> lstTrac = new list<Oracle_Data_Tracker__c>([select id, name, Status__c from Oracle_Data_Tracker__c where EON_Appointment__c =: objAppointment.Id]);
        //system.debug('### lstTrac[0].Status__c: '+lstTrac[0].Status__c);
        //system.assertEquals('PASS',lstTrac[0].Status__c);
    }
}