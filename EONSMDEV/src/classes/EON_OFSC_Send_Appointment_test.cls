/**
Description : This test class is for the following below classes/triggers
              EON_OFSC_Send_Appointment
              EON_OFSC_Inbound_WS
              EON_OFSC_Send_Appointment_Scheduler
**/

/*
    Created By  : Dharmendra Pahadiya
    Created On  : 08/04/2016
    Service Req : SR_EON_Scheduling_006
    Change History : 
    CH01 # SR_EON_PC_047 # 18/05/2016 # Krishna Y # Deleted reference for Customer lookup on EON Fuel.
    CH02 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH03 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH04 # SR_EON_Mobile_049 # 29/06/2016 # Dharmendra Pahadiya # Added code coverage
    CH05 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
    CH06 # SR_EON_AB_108 # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text 
*/
@isTest
public with sharing class EON_OFSC_Send_Appointment_test {
    public static boolean genexception =false;
    //Send_Activity_test1 - Electric job
    public testmethod static void Send_Activity_test1() { 
        //Create EON Sub Area
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
         
        //Create EON Post Code
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        
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
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        
        //Create EON Electric Meter Type
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        
        //Create EON Electric Meter Register
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //CH04.start
        EON_SSC__c  sscSM= EON_CreateTestRecords.createEON_SSCSmart();
        insert sscSM;
        list<EON_SSC_Register__c> lstRegs = new list<EON_SSC_Register__c>();
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend1', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend2', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend3', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend4', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend5', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend6', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        insert lstRegs;
        //CH04.end      
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='mus', Requested_SSC__c='031',//CH02.old,
                                                //Requested_SSC__c=ssc.id,//CH03.old 
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MS1', //CH04
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON', Specific_Time_flag__c= true,
                                                Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    //Create EON Contact Type 
    EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    insert objConType;
    
    //Create EON Media Type
    EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
    insert objMedType;
        
    //Create EON Appointment Contact
    EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
    //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'CREATE', objTracker.Id, '', '', '', '');
    EON_OFSC_Send_Appointment_test.genexception=true;
    EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'CREATE', objTracker.Id, '', '', '', 'MUS');

        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('### lstApp[0].Sent_to_Oracle__c: '+lstApp[0].Sent_to_Oracle__c);
        system.assertEquals(true,lstApp[0].Sent_to_Oracle__c);
    }
    
    //Send_Activity_test2 - Update Electric job - SME customer group type 
    public testmethod static void Send_Activity_test2() {
        //Create EON Sub Area
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
         
        //Create EON Post Code
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        
        //Create EON Parking
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        
        //Create EON Electric Meter location
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', SME_Duration__c=10);
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='SME');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Site
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        
        //Create EON Electric Meter Type
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        
        //Create EON Electric Meter Register
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        ssc.name = '031';
        insert ssc;
        
        EON_SSC__c  ssc1= EON_CreateTestRecords.createEON_SSCSmart();
        insert ssc1;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='031',//CH02.old,
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MCL', //CH04
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',Specific_Time_flag__c= true,
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    //Create EON Contact Type 
    EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    insert objConType;
    
    //Create EON Media Type
    EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
    insert objMedType;
        
    //Create EON Appointment Contact
    EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
    //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
    EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag=true;
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '', '', 'MUS');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle_Update__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('### lstApp[0].Sent_to_Oracle__c: '+lstApp[0].Sent_to_Oracle_Update__c);
        system.assertEquals(true,lstApp[0].Sent_to_Oracle_Update__c);
    }
    
    //Send_Activity_test3 - Gas job
    public testmethod static void Send_Activity_test3() {
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance');
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
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
        
        //CH02.start
        //EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        //insert ssc;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        ssc.name = '031';
        insert ssc;
        
        EON_SSC__c  ssc1= EON_CreateTestRecords.createEON_SSCSmart();
        insert ssc1;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61', Requested_SSC__c='031',//CH02.old, 
                                                //Requested_SSC__c=ssc.id,//CH03.old 
                                                EON_Appointment_ID__c='61',  Planned_E_Meter_Type__c = 'MS1', Current_Phase__c = '3Ph',
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPRN__c='987654321', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Number_of_Phases__c='1Ph',/*CH05*/
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', Certification_Date__c=date.today(), G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Building_Name__c='test building name', Building_Number__c='test build number', Sub_Building_Name__c='test sub build name',
                                                Thorofare__c='test thorofare', Dependent_Thorofare__c='test dep thorofare', Dependant_Locality__c='test dep loc', Double_dependant_Locality__c='test doub dep loc',
                                                Person_Name__c='test per name', Contact_Number__c=123654789, Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
        
        //Create EON Contact Type 
    EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    insert objConType;
    
    //Create EON Media Type
    EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
    insert objMedType;
        
    //Create EON Appointment Contact
    EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
                
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'CREATE', objTracker.Id, '', '', '', '');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.assertEquals(true,lstApp[0].Sent_to_Oracle__c);
    }
    
    //Send_Activity_test4 - failure
    public testmethod static void Send_Activity_test4() {
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance');
        insert objJob;
        
        //Create EON Electric Meter Type
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;
        
        //Create EON Electric Meter Register
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        
        //Create EON Gas Meter Type
        EON_Gas_Meter_Type__c objGasType = new EON_Gas_Meter_Type__c(Name='test gas type', OFS_Enumeration__c=1);
        insert objGasType;
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61',Requested_SSC__c='61',//CH02.old, 
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPRN__c='test mpan ele', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Building_Name__c='test building name', Building_Number__c='test build number', Sub_Building_Name__c='test sub build name',
                                                Thorofare__c='test thorofare', Dependent_Thorofare__c='test dep thorofare', Dependant_Locality__c='test dep loc', Double_dependant_Locality__c='test doub dep loc',
                                                Metering_Point_Postcode__c='SG1 2ST', Person_Name__c='test per name', Contact_Number__c=123654789);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
                
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'CREATE', objTracker.Id, '', '', '', '');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.assertEquals(false,lstApp[0].Sent_to_Oracle__c);
    }
    
    //Send_Activity_test5 - failure
    public testmethod static void Send_Activity_test5() {
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance');
        insert objJob;
        
        //Create EON Electric Meter Type
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;
        
        //Create EON Electric Meter Register
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        
        //Create EON Gas Meter Type
        EON_Gas_Meter_Type__c objGasType = new EON_Gas_Meter_Type__c(Name='test gas type', OFS_Enumeration__c=1);
        insert objGasType;
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61',Requested_SSC__c='61',//CH02.old,
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPRN__c='test mpan ele', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH06 
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Building_Name__c='test building name', Building_Number__c='test build number', Sub_Building_Name__c='test sub build name',
                                                Thorofare__c='test thorofare', Dependent_Thorofare__c='test dep thorofare', Dependant_Locality__c='test dep loc', Double_dependant_Locality__c='test doub dep loc',
                                                Metering_Point_Postcode__c='SG1 2ST', Person_Name__c='test per name', Contact_Number__c=123654789);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
                
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='1', Error_Warning_Success__c='error', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '', '', '');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle_Update__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.assertEquals(false,lstApp[0].Sent_to_Oracle_Update__c);
    }
    
    //Send_Activity_test6 - failure response
    public testmethod static void Send_Activity_test6() {
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance');
        insert objJob;
        
        //Create EON Electric Meter Type
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;
        
        //Create EON Electric Meter Register
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        
        //Create EON Gas Meter Type
        EON_Gas_Meter_Type__c objGasType = new EON_Gas_Meter_Type__c(Name='test gas type', OFS_Enumeration__c=1);
        insert objGasType;
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61',Requested_SSC__c='61',//CH02.old, 
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPRN__c='test mpan ele', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Building_Name__c='test building name', Building_Number__c='test build number', Sub_Building_Name__c='test sub build name',
                                                Thorofare__c='test thorofare', Dependent_Thorofare__c='test dep thorofare', Dependant_Locality__c='test dep loc', Double_dependant_Locality__c='test doub dep loc',
                                                Metering_Point_Postcode__c='SG1 2ST', Person_Name__c='test per name', Contact_Number__c=123654789,Sent_to_Oracle__c=true);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
                
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='1', Error_Warning_Success__c='error', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '', '', '');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle_Update__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.assertEquals(false,lstApp[0].Sent_to_Oracle_Update__c);
    }
    
    //Send_Activity_test7 - Update Electric job
    public testmethod static void Send_Activity_test7() {
        //Create EON Sub Area
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
        
        //Create EON Post Code
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        
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
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
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
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='61',//CH02.old, 
                                                //Requested_SSC__c=ssc.id,//CH03.old 
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
        
        //Create EON Appointment Attribute
        EON_Appointment_Attribute__c objAtt1 = new EON_Appointment_Attribute__c(Job_Attribute__c='Electric Meter Type', Value__c='1', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt1;
        EON_Appointment_Attribute__c objAtt2 = new EON_Appointment_Attribute__c(Job_Attribute__c='Gas Meter Type', Value__c='2', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt2;
        EON_Appointment_Attribute__c objAtt3 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Registers', Value__c='3', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt3;
        EON_Appointment_Attribute__c objAtt4 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Mode', Value__c='4', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt4;
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '', '', 'MUS');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle_Update__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.assertEquals(true,lstApp[0].Sent_to_Oracle_Update__c);
    }
    
    //Send_Activity_test8 - Update Gas job - SME customer group type
    public testmethod static void Send_Activity_test8() {
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance');
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='SME');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
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
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61',Requested_SSC__c='61',//CH02.old,
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPRN__c='987654321', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Number_of_Phases__c='1Ph',/*CH05*/
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', Certification_Date__c=date.today(), G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Building_Name__c='test building name', Building_Number__c='test build number', Sub_Building_Name__c='test sub build name',
                                                Thorofare__c='test thorofare', Dependent_Thorofare__c='test dep thorofare', Dependant_Locality__c='test dep loc', Double_dependant_Locality__c='test doub dep loc',
                                                Person_Name__c='test per name', Contact_Number__c=123654789, Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
        
        //Create EON Appointment Attribute
        EON_Appointment_Attribute__c objAtt1 = new EON_Appointment_Attribute__c(Job_Attribute__c='Electric Meter Type', Value__c='1', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt1;
        EON_Appointment_Attribute__c objAtt2 = new EON_Appointment_Attribute__c(Job_Attribute__c='Gas Meter Type', Value__c='2', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt2;
        EON_Appointment_Attribute__c objAtt3 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Registers', Value__c='3', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt3;
        EON_Appointment_Attribute__c objAtt4 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Mode', Value__c='4', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt4;
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '2016-04-21', '12:00 - 14:00', 'MUS');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle_Update__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.assertEquals(true,lstApp[0].Sent_to_Oracle_Update__c);
    }
    
    //Send_Activity_test9 - Update Gas job RES customer group type
    public testmethod static void Send_Activity_test9() {
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance');
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
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
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61', Requested_SSC__c='61',//CH02.old, 
                                                //Requested_SSC__c= ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPRN__c='987654321', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Number_of_Phases__c='1Ph',/*CH05*/
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', Certification_Date__c=date.today(), G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Building_Name__c='test building name', Building_Number__c='test build number', Sub_Building_Name__c='test sub build name',
                                                Thorofare__c='test thorofare', Dependent_Thorofare__c='test dep thorofare', Dependant_Locality__c='test dep loc', Double_dependant_Locality__c='test doub dep loc',
                                                Person_Name__c='test per name', Contact_Number__c=123654789, Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
        
        //Create EON Appointment Attribute
        EON_Appointment_Attribute__c objAtt1 = new EON_Appointment_Attribute__c(Job_Attribute__c='Electric Meter Type', Value__c='1', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt1;
        EON_Appointment_Attribute__c objAtt2 = new EON_Appointment_Attribute__c(Job_Attribute__c='Gas Meter Type', Value__c='2', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt2;
        EON_Appointment_Attribute__c objAtt3 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Registers', Value__c='3', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt3;
        EON_Appointment_Attribute__c objAtt4 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Mode', Value__c='4', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt4;
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '2016-04-21', '12:00 - 14:00', 'MUS');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle_Update__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.assertEquals(true,lstApp[0].Sent_to_Oracle_Update__c);
    }
    
    //Send_Activity_test10 - Update Gas job RES customer group type
    public testmethod static void Send_Activity_test10() {
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance');
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
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
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61', Requested_SSC__c='61',//CH02.old, 
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='test', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPRN__c='987654321', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Number_of_Phases__c='1Ph',/*CH05*/
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', Certification_Date__c=date.today(), G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Building_Name__c='test building name', Building_Number__c='test build number', Sub_Building_Name__c='test sub build name',
                                                Thorofare__c='test thorofare', Dependent_Thorofare__c='test dep thorofare', Dependant_Locality__c='test dep loc', Double_dependant_Locality__c='test doub dep loc',
                                                Person_Name__c='test per name', Contact_Number__c=123654789, Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
        
        //Create EON Appointment Attribute
        EON_Appointment_Attribute__c objAtt1 = new EON_Appointment_Attribute__c(Job_Attribute__c='Electric Meter Type', Value__c='1', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt1;
        EON_Appointment_Attribute__c objAtt2 = new EON_Appointment_Attribute__c(Job_Attribute__c='Gas Meter Type', Value__c='2', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt2;
        EON_Appointment_Attribute__c objAtt3 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Registers', Value__c='3', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt3;
        EON_Appointment_Attribute__c objAtt4 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Mode', Value__c='4', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt4;
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '2016-04-21', '12:00 - 14:00', 'MUS');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle_Update__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('@@@ lstApp[0].Sent_to_Oracle_Update__c: '+lstApp[0].Sent_to_Oracle_Update__c);
        system.assertEquals(true,lstApp[0].Sent_to_Oracle_Update__c);
    }
    
    //Send_Activity_test11 - Update Gas job Fail response
    public testmethod static void Send_Activity_test11() {
        //Create EON Sub Area
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
        
        //Create EON Post Code
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        
        //Create EON Parking
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        
        //Create EON Electric Meter location
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance');
        insert objJob;
        
        //Create EON Electric Meter Type
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;
        
        //Create EON Electric Meter Register
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        
        //Create EON Gas Meter Type
        EON_Gas_Meter_Type__c objGasType = new EON_Gas_Meter_Type__c(Name='test gas type', OFS_Enumeration__c=1);
        insert objGasType;
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='61',//CH02.old,
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare');
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
                
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='10', Error_Warning_Success__c='error', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '', '', '');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle_Update__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.assertEquals(false,lstApp[0].Sent_to_Oracle_Update__c);
    }
    
    //Send_Activity_test13 - Just for covering the WS class
    public testmethod static void Send_Activity_test13() {
        
        EON_OFSC_Inbound_WS.EraseLinksElement eraseLink = new EON_OFSC_Inbound_WS.EraseLinksElement();
        eraseLink.link_type = new list<string>();
        
        EON_OFSC_Inbound_WS.RequiredInventoryElement reqInvEle = new EON_OFSC_Inbound_WS.RequiredInventoryElement();
        reqInvEle.type_x = '';
        reqInvEle.model = '';
        reqInvEle.quantity = '';
        EON_OFSC_Inbound_WS.RequiredInventoryElement[] reqInvEles = new EON_OFSC_Inbound_WS.RequiredInventoryElement[]{reqInvEle};
        EON_OFSC_Inbound_WS.RequiredInventoriesArray reqInvArray = new EON_OFSC_Inbound_WS.RequiredInventoriesArray();
        reqInvArray.required_inventory = reqInvEles;
        
        EON_OFSC_Inbound_WS.ProviderPreferenceElement provPrefEle = new EON_OFSC_Inbound_WS.ProviderPreferenceElement();
        provPrefEle.external_id = '';
        provPrefEle.type_x = '';
        EON_OFSC_Inbound_WS.ProviderPreferenceElement[] provPrefEles = new EON_OFSC_Inbound_WS.ProviderPreferenceElement[]{provPrefEle};
        EON_OFSC_Inbound_WS.ProviderPreferencesArray provPrefArray = new EON_OFSC_Inbound_WS.ProviderPreferencesArray();
        provPrefArray.preference = provPrefEles;
        
        EON_OFSC_Inbound_WS.LinkElement linkEle = new EON_OFSC_Inbound_WS.LinkElement();
        linkEle.appt_number = '';
        linkEle.customer_number = '';
        linkEle.name = '';
        linkEle.link_type = '';
        linkEle.min_interval = '';
        linkEle.max_interval = '';
        EON_OFSC_Inbound_WS.LinkElement[] linkEles = new EON_OFSC_Inbound_WS.LinkElement[]{linkEle};
        
        EON_OFSC_Inbound_WS.AddLinkElement addLinkEle = new EON_OFSC_Inbound_WS.AddLinkElement();
        addLinkEle.appt_number = '';
        addLinkEle.customer_number = '';
        addLinkEle.name = '';
        EON_OFSC_Inbound_WS.AddLinkElement[] addLinkEles = new EON_OFSC_Inbound_WS.AddLinkElement[]{addLinkEle};
        
        EON_OFSC_Inbound_WS.FileElement fileEle = new EON_OFSC_Inbound_WS.FileElement();
        fileEle.property_label = '';
        fileEle.filename = '';
        fileEle.mime_type = '';
        fileEle.encoding = '';
        fileEle.contents = '';
        
        EON_OFSC_Inbound_WS.FileElement[] fileEles = new EON_OFSC_Inbound_WS.FileElement[]{fileEle};
        EON_OFSC_Inbound_WS.FilesArray filesArray = new EON_OFSC_Inbound_WS.FilesArray();
        filesArray.file = fileEles;
        
        EON_OFSC_Inbound_WS.PropertyElement propEle = new EON_OFSC_Inbound_WS.PropertyElement();
        propEle.label = '';
        propEle.value = '';
        EON_OFSC_Inbound_WS.PropertyElement[] propEles = new EON_OFSC_Inbound_WS.PropertyElement[]{propEle};
        EON_OFSC_Inbound_WS.PropertiesArray propArray = new EON_OFSC_Inbound_WS.PropertiesArray();
        propArray.property = propEles;
        
        EON_OFSC_Inbound_WS.ReportMessageElement repMsgEle = new EON_OFSC_Inbound_WS.ReportMessageElement();
        repMsgEle.result = '';
        repMsgEle.type_x = '';
        repMsgEle.code = '';
        repMsgEle.description = '';
        EON_OFSC_Inbound_WS.ReportMessageElement[] repMsgEles = new EON_OFSC_Inbound_WS.ReportMessageElement[]{repMsgEle};
        EON_OFSC_Inbound_WS.ReportElement repEle = new EON_OFSC_Inbound_WS.ReportElement();
        repEle.message = repMsgEles;
        
        EON_OFSC_Inbound_WS.InventoryResponseElement invResEle = new EON_OFSC_Inbound_WS.InventoryResponseElement();
        invResEle.properties = propArray;
        invResEle.report = repEle;
        invResEle.userdata = '';
        invResEle.invid = 0;
        EON_OFSC_Inbound_WS.InventoryResponseElement[] invResEles = new EON_OFSC_Inbound_WS.InventoryResponseElement[]{invResEle};
        EON_OFSC_Inbound_WS.InventoriesResponseArray invResArray = new EON_OFSC_Inbound_WS.InventoriesResponseArray();
        invResArray.inventory = invResEles;
                
        EON_OFSC_Inbound_WS.InventoryElement InvEle = new EON_OFSC_Inbound_WS.InventoryElement();
        InvEle.properties = propArray;
        InvEle.files = filesArray;
        EON_OFSC_Inbound_WS.InventoryElement[] InvEles = new EON_OFSC_Inbound_WS.InventoryElement[]{InvEle};
        EON_OFSC_Inbound_WS.InventoriesArray InvArray = new EON_OFSC_Inbound_WS.InventoriesArray();
        InvArray.inventory = InvEles;
        
        EON_OFSC_Inbound_WS.LinksArray linkArray = new EON_OFSC_Inbound_WS.LinksArray();
        linkArray.erase_links = eraseLink;
        linkArray.link_start_together = addLinkEles;
        linkArray.link_start_after = addLinkEles;
        linkArray.link = linkEles;
        
        EON_OFSC_Inbound_WS.AppointmentElement appEle = new EON_OFSC_Inbound_WS.AppointmentElement();
        appEle.appt_number = '';
        appEle.team_id = '';
        appEle.customer_number = '';
        appEle.worktype = '';
        appEle.worktype_label = '';
        appEle.service_window_start = '';
        appEle.service_window_end = '';
        appEle.sla_window_start = '';
        appEle.sla_window_end = '';
        appEle.time_of_booking = '';
        appEle.time_slot = '';
        appEle.duration = '';
        appEle.name = '';
        appEle.message_methods = '';
        appEle.phone = '';
        appEle.email = '';
        appEle.cell = '';
        appEle.address = '';
        appEle.city = '';
        appEle.state = '';
        appEle.zip = '';
        appEle.language = '';
        appEle.reminder_time = '';
        appEle.time_zone = '';
        appEle.coordx = '';
        appEle.coordy = '';
        appEle.points = '';
        appEle.properties = propArray;
        appEle.inventories = InvArray;
        appEle.links = linkArray;
        appEle.files = filesArray;
        appEle.provider_preferences = provPrefArray;
        appEle.required_inventories = reqInvArray;
        appEle.action_if_completed = '';
        appEle.userdata = '';
        
        EON_OFSC_Inbound_WS.ProviderElement provEle = new EON_OFSC_Inbound_WS.ProviderElement();
        provEle.external_id = '';
        provEle.fallback_external_id = '';
        provEle.appointment = appEle;
        provEle.inventories = InvArray;
        EON_OFSC_Inbound_WS.ProviderElement[] provEles = new EON_OFSC_Inbound_WS.ProviderElement[]{provEle};
        EON_OFSC_Inbound_WS.ProvidersArray provArray = new EON_OFSC_Inbound_WS.ProvidersArray();
        provArray.provider = provEles;
        
        EON_OFSC_Inbound_WS.AppointmentResponseElement appResEle = new EON_OFSC_Inbound_WS.AppointmentResponseElement();
        appResEle.appt_number = '';
        appResEle.customer_number = '';
        appResEle.name = '';
        appResEle.aid = 0;
        appResEle.inventories = invResArray;
        appResEle.report = repEle;
        
        
        EON_OFSC_Inbound_WS.ProviderResponseElement provResEle = new EON_OFSC_Inbound_WS.ProviderResponseElement();
        provResEle.external_id = '';
        provResEle.appointment = appResEle;
        provResEle.inventories = invResArray;
        provResEle.report = repEle;
        provResEle.userdata = '';
        EON_OFSC_Inbound_WS.ProviderResponseElement[] provResEles = new EON_OFSC_Inbound_WS.ProviderResponseElement[]{provResEle};
        EON_OFSC_Inbound_WS.ProvidersResponseArray provResArray = new EON_OFSC_Inbound_WS.ProvidersResponseArray();
        provResArray.provider = provResEles;
    }
    
    //Send_Activity_Scheduler_test1 - for EON_OFSC_Send_Appointment_Scheduler 
    public testmethod static void Send_Activity_Scheduler_test1() {
        
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
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
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61', Requested_SSC__c='61',//CH02.old, 
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741', //CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
        
        //Create EON Appointment Attribute
        EON_Appointment_Attribute__c objAtt1 = new EON_Appointment_Attribute__c(Job_Attribute__c='Electric Meter Type', Value__c='1', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt1;
        EON_Appointment_Attribute__c objAtt2 = new EON_Appointment_Attribute__c(Job_Attribute__c='Gas Meter Type', Value__c='2', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt2;
        EON_Appointment_Attribute__c objAtt3 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Registers', Value__c='3', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt3;
        EON_Appointment_Attribute__c objAtt4 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Mode', Value__c='4', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt4;
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        //Create Oracle Data Tracker
        Oracle_Data_Tracker__c objOracleTrac = new Oracle_Data_Tracker__c(EON_Data_Tracker__c = objTracker.Id, Command__c = 'Create Activity',
                                          Status__c = 'FAIL', EON_Appointment__c=objAppointment.Id);
        insert objOracleTrac;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        test.StartTest();
        // Schedule the test job
      String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new EON_OFSC_Send_Appointment_Scheduler());
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
      // Verify the expressions are the same
      System.assertEquals(CRON_EXP,ct.CronExpression);
      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);
      // Verify the next time the job will run
      System.assertEquals('2022-03-15 00:00:00',String.valueOf(ct.NextFireTime));
      test.StopTest();
    }
    
    //Send_Activity_Scheduler_test2 - To cover exception
    public testmethod static void Send_Activity_Scheduler_test2() {
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance');
        insert objJob;
        
        //Create EON Electric Meter Type
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;
        
        //Create EON Electric Meter Register
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        
        //Create EON Gas Meter Type
        EON_Gas_Meter_Type__c objGasType = new EON_Gas_Meter_Type__c(Name='test gas type', OFS_Enumeration__c=1);
        insert objGasType;
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='61',//CH02.old,
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741', //CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare');
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
                
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='10', Error_Warning_Success__c='error', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '', '', '');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle_Update__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('$$$ final lstApp[0].Sent_to_Oracle_Update__c: '+lstApp[0].Sent_to_Oracle_Update__c);
        system.assertEquals(true,lstApp[0].Sent_to_Oracle_Update__c);
    }
    
    //Send_Activity_test15 - for EON_OFSC_Send_Appointment_Scheduler - failure 
    public testmethod static void Send_Activity_test15() {
        
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
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        
        //Create EON Customer
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        
        //Create EON Site
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
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
        
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61', Requested_SSC__c='61',//CH02.old, 
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741', //CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
        
        //Create EON Appointment Attribute
        EON_Appointment_Attribute__c objAtt1 = new EON_Appointment_Attribute__c(Job_Attribute__c='Electric Meter Type', Value__c='1', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt1;
        EON_Appointment_Attribute__c objAtt2 = new EON_Appointment_Attribute__c(Job_Attribute__c='Gas Meter Type', Value__c='2', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt2;
        EON_Appointment_Attribute__c objAtt3 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Registers', Value__c='3', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt3;
        EON_Appointment_Attribute__c objAtt4 = new EON_Appointment_Attribute__c(Job_Attribute__c='Meter Mode', Value__c='4', EON_Appointment_ID__c=objAppointment.Id);
        insert objAtt4;
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        //Create Oracle Data Tracker
        Oracle_Data_Tracker__c objOracleTrac = new Oracle_Data_Tracker__c(EON_Data_Tracker__c = objTracker.Id,
                                          Status__c = 'FAIL', EON_Appointment__c=objAppointment.Id);
        insert objOracleTrac;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        test.StartTest();
        // Schedule the test job
      String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,new EON_OFSC_Send_Appointment_Scheduler());
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
      // Verify the expressions are the same
      System.assertEquals(CRON_EXP,ct.CronExpression);
      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);
      // Verify the next time the job will run
      System.assertEquals('2022-03-15 00:00:00',String.valueOf(ct.NextFireTime));
      test.StopTest();
    }
    
    //Send_Activity_test16 - cover the catch for Tracker insert failure
    public testmethod static void Send_Activity_test16() { 
        //Create EON Sub Area
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
         
        //Create EON Post Code
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        
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
        
        //Create EON Fuel
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        
        //Create EON Electric Meter Type
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        
        //Create EON Electric Meter Register
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH02.end
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c=ssc.name,//CH02.old, 
                                                //Requested_SSC__c=ssc.id,//CH03.old
                                                EON_Appointment_ID__c='61', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph',/*CH05*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH06
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
        //Create EON Contact Type 
        EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
        insert objConType;
        
        //Create EON Media Type
        EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
        insert objMedType;
            
        //Create EON Appointment Contact
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
            
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        //Create EON Data Tracker
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        EON_Utility.CMD_OFSC_UpdateActivity = 'Create Activity OFSC failure to cover the exception block while inserting the Tracker record.';
        test.StartTest();
        EON_OFSC_Send_Appointment.sendActivityToOFSC(objAppointment.Id, 'UPDATE', objTracker.Id, '', '', '', '');
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('### lstApp[0].Sent_to_Oracle__c: '+lstApp[0].Sent_to_Oracle__c);
        system.assertEquals(false,lstApp[0].Sent_to_Oracle__c);
    }
}