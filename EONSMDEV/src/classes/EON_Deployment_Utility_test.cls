/**
Description : This test class is for the following below classes/triggers
              EON_Deployment_Utility    
**/

/*
    Created By  : Mahadev Joshilkar
    Created On  : 02/09/2016
    Service Req: SR_EON_Jumbo_055
    Change History
    	CH01 #  # 28/09/2016 # Mahadev J # Coverage improvement
*/
@isTest
public class EON_Deployment_Utility_test{
    public static boolean genException;
    public testmethod static void Send_Activity_Success() { 
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Gas_Meter_Location__c objGasMtrLoc = new EON_Gas_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objGasMtrLoc;
        EON_Gas_Meter_Mechanism__c objGasMetMech = new EON_Gas_Meter_Mechanism__c(Name='test', code__c='CC', OFS_Enumeration__c=12);
        insert objGasMetMech;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        //insert ssc;
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
        EON_SSC__c  sscSM1= EON_CreateTestRecords.createEON_SSCSmart();
        sscSM1.Name = '031';
        sscSM1.Type__c = 'Smart';
        insert sscSM1;
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='031',
                                                //Requested_SSC__c=ssc.id,
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MS1', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
												E_Check_Meter_Location__c = objEleMtrLoc.ID, G_Check_Meter_Location__c = objGasMtrLoc.ID,
                                                G_Meter_Location__c = objGasMtrLoc.ID, G_Meter_Mechanism__c = objGasMetMech.ID,
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        //Test 1 - Success without OFSC Response Code Record
        EON_Deployment_Utility.sendActivityToOFSC(objAppointment, 'CREATE', objTracker.Id, '', '', '', '', objCont);
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('### lstApp[0].Sent_to_Oracle__c: '+lstApp[0].Sent_to_Oracle__c);
        
        //Test 1 - Success with OFSC Response Code Record
        list<EON_OFSC_Response_Code__c> ofsc_res = new list<EON_OFSC_Response_Code__c>(); //CH01
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        EON_OFSC_Response_Code__c objRC2 = new EON_OFSC_Response_Code__c(Name='10', Error_Warning_Success__c='error', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        ofsc_res.add(objRC1); //CH01
        ofsc_res.add(objRC2); //CH01
        insert ofsc_res;  //CH01
        EON_Deployment_Utility.sendActivityToOFSC(objAppointment, 'CREATE', objTracker.Id, '', '', '', '', objCont);
        
		
        //Test 2 - Error in response
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
        EON_Deployment_Utility.sendActivityToOFSC(objAppointment, 'CREATE', objTracker.Id, '', '', '', '', objCont);
        test.StopTest();
    }
    
    public testmethod static void Send_Activity_Failure() { 
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
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
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='031',
                                                //Requested_SSC__c=ssc.id,
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MS1', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='10', Error_Warning_Success__c='error', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
        test.StartTest();
        EON_Deployment_Utility.sendActivityToOFSC(objAppointment, 'CREATE', objTracker.Id, '', '', '', '', objCont);
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('### lstApp[0].Sent_to_Oracle__c: '+lstApp[0].Sent_to_Oracle__c);
        //system.assertEquals(true,lstApp[0].Sent_to_Oracle__c);
    }
    
    public testmethod static void Send_Activity_Failure1() { 
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
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
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='031',
                                                //Requested_SSC__c=ssc.id,
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MS1', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='9', Error_Warning_Success__c='error', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
        test.StartTest();
        EON_Deployment_Utility.sendActivityToOFSC(objAppointment, 'CREATE', objTracker.Id, '', '', '', '', objCont);
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('### lstApp[0].Sent_to_Oracle__c: '+lstApp[0].Sent_to_Oracle__c);
        //system.assertEquals(true,lstApp[0].Sent_to_Oracle__c);
    }
    
    public testmethod static void Send_Activity_Success1() { 
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
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
        EON_SSC__c  ssc1= EON_CreateTestRecords.createEON_SSC();
        ssc1.name = '031';
        insert ssc1;
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='MUS', Requested_SSC__c='031', Specific_Time_flag__c = true,
                                                //Requested_SSC__c=ssc.id, 
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MCL', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag = true;
        EON_Deployment_Utility.sendActivityToOFSC(objAppointment, 'CREATE', objTracker.Id, '', String.valueOf(date.today()), '', 'MUS', objCont);
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('### lstApp[0].Sent_to_Oracle__c: '+lstApp[0].Sent_to_Oracle__c);
        //system.assertEquals(true,lstApp[0].Sent_to_Oracle__c);
    }
    
    public testmethod static void Send_Activity_Success2() { 
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        EON_SSC__c  sscSM= EON_CreateTestRecords.createEON_SSCSmart();
        sscSM.Name = '032';
        insert sscSM;
        list<EON_SSC_Register__c> lstRegs = new list<EON_SSC_Register__c>();
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend1', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend2', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend3', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend4', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend5', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        lstRegs.add(new EON_SSC_Register__c(name='Evening Weekend6', Register_ID__c='EW', TPR__c='00071',SSC__c=sscSM.id));
        insert lstRegs;
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='MUS', Requested_SSC__c='031', Specific_Time_flag__c = true,
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MCL', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='02:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag = true;
        EON_Deployment_Utility.sendActivityToOFSC(objAppointment, 'CREATE', objTracker.Id, '', String.valueOf(date.today()), '', 'MUS', objCont);
        test.StopTest();
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('### lstApp[0].Sent_to_Oracle__c: '+lstApp[0].Sent_to_Oracle__c);
        //system.assertEquals(true,lstApp[0].Sent_to_Oracle__c);
    }
    
    //Covers exception 
    public testmethod static void Send_Activity_Exception() { 
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        insert objSArea;
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
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
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='MUS', Requested_SSC__c='031', Specific_Time_flag__c = true,
                                                //Requested_SSC__c=ssc.id, 
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MCL', 
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='1');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;

        test.StartTest();
        genException = true;
        EON_Deployment_Utility.sendActivityToOFSC(objAppointment, 'CREATE', objTracker.Id, 'incorrect', String.valueOf(date.today()), '', 'MUS', objCont);
        
        EON_Deployment_Utility deployUtility = new EON_Deployment_Utility();
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        deployUtility.AllApptID = lstApp[0].Name;
        deployUtility.ProcessAppointment();
        
        test.StopTest();
        list<EON_Appointment__c> lstApp1 = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        system.debug('### lstApp[0].Sent_to_Oracle__c: '+lstApp1[0].Sent_to_Oracle__c);
        //system.assertEquals(true,lstApp[0].Sent_to_Oracle__c);
    }
    
    public testmethod static void ExecutebatchJob_Maintenance(){
        EON_Region__c region = new EON_Region__c();
        region.name = 'London';
        region.GSP_ID__c = 12;
        insert region;
        
        list<EON_Sub_Area__c> allSubArea = new list<EON_Sub_Area__c>();
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Region_Name__c = region.ID, Maintenance__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        allSubArea.add(objSArea);
        insert allSubArea;
        
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
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
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='031', Customer_Preferred_Contact_Method__c = 'E',
                                                //Requested_SSC__c=ssc.id,
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MS1', Contact_Email__c='a@b.com',
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required', MPRN__c='987654321',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Planned_Number_of_Registers__c = '1', Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='E');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        EON_Parking__c park = new EON_Parking__c();
        park.Name = 'On Street Parking';
        insert park;
        
        Eon_Appointment_Reason__c appReason = new Eon_Appointment_Reason__c();
        appReason.name = 'Customer Request';
        insert appReason;
        
        EON_Contact_Type__c conType = new EON_Contact_Type__c();
        conType.Code__c = 'A';
        insert conType;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        //Test 1 - Success without OFSC Response Code Record
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        EON_Deployment_Utility deployUtility = new EON_Deployment_Utility();
        deployUtility.AllApptID = lstApp[0].Name;
        deployUtility.ProcessAppointment();
        //Test 2- Null In Appointment ID
        deployUtility.AllApptID = '';
        deployUtility.ProcessAppointment();
		test.stopTest();
    }
    public testmethod static void ExecutebatchJob_ECO(){
        EON_Region__c region = new EON_Region__c();
        region.name = 'London';
        region.GSP_ID__c = 12;
        insert region;
        
        list<EON_Sub_Area__c> allSubArea = new list<EON_Sub_Area__c>();
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Region_Name__c = region.ID, ECO__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        allSubArea.add(objSArea);
        insert allSubArea;
        
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='ECO', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
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
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='031', Customer_Preferred_Contact_Method__c = 'E',
                                                //Requested_SSC__c=ssc.id,
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MS1', Contact_Email__c='a@b.com',
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required', MPRN__c='987654321',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Planned_Number_of_Registers__c = '2', Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='E');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        EON_Parking__c park = new EON_Parking__c();
        park.Name = 'On Street Parking';
        insert park;
        
        Eon_Appointment_Reason__c appReason = new Eon_Appointment_Reason__c();
        appReason.name = 'Customer Request';
        insert appReason;
        
        EON_Contact_Type__c conType = new EON_Contact_Type__c();
        conType.Code__c = 'A';
        insert conType;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        //Test 1 - Success without OFSC Response Code Record
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        EON_Deployment_Utility deployUtility = new EON_Deployment_Utility();
        deployUtility.AllApptID = lstApp[0].Name;
        deployUtility.ProcessAppointment();
        
        deployUtility.AllApptID = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,aa,bb,cc,dd,ee';
        deployUtility.ProcessAppointment();
		test.stopTest();
    }
    public testmethod static void ExecutebatchJob_Smart(){
        EON_Region__c region = new EON_Region__c();
        region.name = 'London';
        region.GSP_ID__c = 12;
        insert region;
        
        list<EON_Sub_Area__c> allSubArea = new list<EON_Sub_Area__c>();
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Region_Name__c = region.ID, Smart__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        allSubArea.add(objSArea);
        insert allSubArea;
        
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Smart', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
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
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='031', Customer_Preferred_Contact_Method__c = 'E',
                                                //Requested_SSC__c=ssc.id,
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MS1', Contact_Email__c='a@b.com',
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required', MPRN__c='987654321',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='E');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        EON_Parking__c park = new EON_Parking__c();
        park.Name = 'On Street Parking';
        insert park;
        
        Eon_Appointment_Reason__c appReason = new Eon_Appointment_Reason__c();
        appReason.name = 'Customer Request';
        insert appReason;
        
        EON_Contact_Type__c conType = new EON_Contact_Type__c();
        conType.Code__c = 'A';
        insert conType;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        //Test 1 - Success without OFSC Response Code Record
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        EON_Deployment_Utility deployUtility = new EON_Deployment_Utility();
        deployUtility.AllApptID = lstApp[0].Name;
        deployUtility.ProcessAppointment();
        
		test.stopTest();
    }
    public testmethod static void ExecutebatchJob_New_Connections(){
        EON_Region__c region = new EON_Region__c();
        region.name = 'London';
        region.GSP_ID__c = 12;
        insert region;
        
        list<EON_Sub_Area__c> allSubArea = new list<EON_Sub_Area__c>();
        EON_Sub_Area__c objSArea = new EON_Sub_Area__c(Name='test Sub Area', Region_Name__c = region.ID, New_Connections__c=true, Oracle_Bucket_ID__c='LON_SouthEast1');
        allSubArea.add(objSArea);
        insert allSubArea;
        
        EON_Post_Code__c objPC = new EON_Post_Code__c(Name='E20 1', Sub_Area_Name__c=objSArea.Id);
        insert objPC;
        EON_Parking__c objParking = new EON_Parking__c(Name='test Parking', Parking_Code__c='1');
        insert objParking;
        EON_Electric_Meter_Location__c objEleMtrLoc = new EON_Electric_Meter_Location__c(Name='Bathroom', Code__c='5');
        insert objEleMtrLoc;
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='New Connections', Duration__c=10);
        insert objJob;
        EON_Customer__c objCust = new EON_Customer__c(Name='123456789', Customer_Name__c='test Cust Name', Customer_group_type__c='RES');
        insert objCust;
        EON_Site__c objSite = new EON_Site__c(Name='1234567890',Customer__c=objCust.Id);
        insert objSite;
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN');//CH01
        insert objFuel;
        EON_Electric_Meter_Type__c objEleType = new EON_Electric_Meter_Type__c(Name='1', OFS_Enumeration__c=1);
        insert objEleType;   
        EON_Electric_Meter_Register__c objEleReg = new EON_Electric_Meter_Register__c(Name='test reg 1', OFS_Enumeration__c=1);
        insert objEleReg;
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
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
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='test', Requested_SSC__c='031', Customer_Preferred_Contact_Method__c = 'E',
                                                //Requested_SSC__c=ssc.id,
                                                EON_Appointment_ID__c='61', Planned_E_Meter_Type__c = 'MS1', Contact_Email__c='a@b.com',
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='2nd Technician Required', MPRN__c='987654321',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', Metering_Point_Address_Line_2__c='1',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON',
                                                Number_of_Phases__c='1Ph', Primary_Priority_Service_Phone_Number_1__c='123456789',/*CH05*/
                                                Metering_Point_Postcode__c='E20 1FH', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id);
        insert objAppointment;
        
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul1;
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id);
        insert objVul2;
    
    	EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
    	insert objConType;
    
    	EON_Media_Type__c objMedType = new EON_Media_Type__c(Name='A', Code__c='E');
    	insert objMedType;
        
    	EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        
        EON_Data_Tracker__c objTracker = new EON_Data_Tracker__c();
        insert objTracker;
        
        EON_Parking__c park = new EON_Parking__c();
        park.Name = 'On Street Parking';
        insert park;
        
        Eon_Appointment_Reason__c appReason = new Eon_Appointment_Reason__c();
        appReason.name = 'Customer Request';
        insert appReason;
        
        EON_Contact_Type__c conType = new EON_Contact_Type__c();
        conType.Code__c = 'A';
        insert conType;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        //Test 1 - Success without OFSC Response Code Record
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Sent_to_Oracle__c from EON_Appointment__c where id =: objAppointment.Id]);
        EON_Deployment_Utility deployUtility = new EON_Deployment_Utility();
        deployUtility.AllApptID = lstApp[0].Name;
        deployUtility.ProcessAppointment();
        
		test.stopTest();
    }
}