/**
Description : This test class is for the following below classes/triggers
              EON_OFSC_Inbound_WS
              EON_OFSC_Update_Appointment
**/

/*
    Created By  : Dharmendra Pahadiya
    Created On  : 27/04/2016
    Service Req : SR_EON_Scheduling_007
    Change History : 
    CH01 # SR_EON_PC_047 # 19/5/2016 # Krishna Y # Deleted reference for Customer lookup on EON Fuel.
    CH02 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH03 # SR_EON_Mobile_043 # 07/06/2016 # Dharmendra P # Added/Updated mapping.
    CH04 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c,Planned_Number_of_Registers__c   
    CH05 # SR_EON_Mobile_043 # 07/06/2016 # Dharmendra P # Updated logic to fetch the record.
    CH06 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
    CH07 # SR_EON_AB_108 # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text
	CH08 # # 29/11/2016 # Mahadev # Rearrange test plan
*/
@isTest
public with sharing class EON_OFSC_Update_Appointment_test {
    
    /*
		Send_Activity_test1(): Success scenario
	*/
    public testmethod static void Send_Activity_test1() { 
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
        
        //Create EON Fuel CH01
        EON_Fuel__c objFuel = new EON_Fuel__c(Premise__c=objSite.Id, MPAN__c='123456789', MPRN__c='987654321', Electric_meter_serial_number__c='test Ele Meter SN'); //CH01
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
        EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='A');
        insert objConType;
        
        //Create EON Media Type
        EON_Media_Type__c objMedType1 = new EON_Media_Type__c(Name='A', Code__c='1');
        insert objMedType1;
        EON_Media_Type__c objMedType2 = new EON_Media_Type__c(Name='E', Code__c='E');
        insert objMedType2;
        
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        
        EON_SSC_Register__c sscReg = new EON_SSC_Register__c(SSC__c= ssc.Id);
        insert sscReg;
        
        //Create EON Appointment
        EON_Appointment__c objAppointment = new EON_Appointment__c(Booking_System_Name__c='61', Requested_SSC__c='031',//CH02
                                                EON_Appointment_ID__c='61', Current_SSC__c = '031', Current_Phase__c = '3Ph',
                                                Parking_Type__c = objParking.Id, Appointment_Date__c=date.today(), Time_Slot__c='12:00 - 14:00',
                                                Start_Time__c='12:00', End_Time__c='14:00', Access_Pass_Phrase__c='test access pass',
                                                Assisted_Work_Reason_Code__c='test assist wor',
                                                Job_Code__c=objJob.Id, MPAN__c='123456789', Additional_Information__c='test add info', Customer_Name__c='test cust name',
                                                Contact_Name__c='test cont name', Metering_Point_Address_Line_1__c='test MP add1', Metering_Point_Address_Line_2__c='test MP add2',
                                                Metering_Point_Address_Line_3__c='test MP add3', Metering_Point_Address_Line_4__c='test MP add4', Metering_Point_Address_Line_5__c='test MP add5',
                                                Metering_Point_Address_Line_6__c='test MP add6', Metering_Point_Address_Line_7__c='test MP add7', Metering_Point_Address_Line_8__c='test MP add8',
                                                Metering_Point_Address_Line_9__c='test MP add9', Number_of_Phases__c='1Ph',/*CH06*/ Primary_Priority_Service_Phone_Number_1__c='123456789',
                                                Post_Town__c='test town', Post_Code__c='SG1 2ST', E_Meter_Serial_Number__c='test emeter SN', E_Meter_Make__c='test met make',
                                                E_Meter_Model__c='test met mod', E_Meter_Location__c=objEleMtrLoc.Id, E_Meter_Type__c=objEleType.Id, Certification_Date__c=date.today(),
                                                E_Meter_Register_1_ID__c='r1', E_Meter_Register_1_Name__c=objEleReg.Id, E_Meter_Register_2_ID__c='r2', 
                                                E_Meter_Register_2_Name__c=objEleReg.Id, E_Meter_Register_3_ID__c='r3', E_Meter_Register_3_Name__c=objEleReg.Id, 
                                                E_Meter_Register_4_ID__c='r4', E_Meter_Register_4_Name__c=objEleReg.Id, E_Meter_Register_5_ID__c='r5', E_Meter_Register_5_Name__c=objEleReg.Id,
                                                E_Meter_Register_6_ID__c='r6', E_Meter_Register_6_Name__c=objEleReg.Id, E_Check_Meter_Installed__c='Yes', G_Meter_Serial_Number__c='test g Meter SN',
                                                G_Meter_Make__c='test g meter make', G_Meter_Model__c='test g meter model', G_Meter_Type__c=objGasType.Id, Gas_Regulator_Serial_Number__c='test Gas Reg SN',
                                                G_Check_Meter_Installed__c='Yes', G_Check_Meter_Serial_Number__c='test g check met SN', Expected_Comms_Hub_Serial_Number__c='test exp comm hub SN',
                                                Expected_IHD_Serial_Number__c='test exp IHD SN', Key_Collection_Required__c=true, Key_Building_Name__c='test key bul name', Key_Building_Number__c='1',
                                                Key_Contact_Number__c='852369741',//CH07
                                                Key_Dependant_Thorofare__c='test key dependent thorofare', Key_Person_Name__c='test key per name', Key_Sub_Building_Name__c='test key sub bul name',
                                                Key_Town__c='test key town', Key_County__c='test key county', Key_Dependant_Locality__c='test key dep loc', Key_Post_Code__c='SG1 2ST',
                                                Key_Thorofare__c='test key thorofare', Fuel_ID__c=objFuel.Id, Metering_Point_Postcode__c='SG1 2ST', Sent_to_Oracle__c = true);
        insert objAppointment;
        
        //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1);
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2);
        insert objVulCode2;
        
        //Create EON Appointment Vulnerability
        list<EON_Appointment_Vulnerability__c> allVul = new list<EON_Appointment_Vulnerability__c>();
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=objAppointment.Id, VulnerabilityDetailCode__c = 1);
        allVul.add(objVul1);
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=objAppointment.Id, VulnerabilityDetailCode__c = 2);
        allVul.add(objVul2);
        insert allVul;
        
        //Create EON Appointment Contact
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=objAppointment.Id);
        insert objCont;
        
        //Create EON OFSC Response Code
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id,name from EON_Appointment__c where id =:objAppointment.Id]); //CH05
        list<EON_Appointment_Vulnerability__c> lstVul = [select id, name, h_Vulnerability_Desc__c, Description__c from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c=:objAppointment.Id];
        list<EON_Appointment_Contact__c> lstCon = new list<EON_Appointment_Contact__c>();
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name1',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med1',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name2',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med2',Media_Type__c=objMedType2.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name3',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med3',Media_Type__c=objMedType1.Id));
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();
        string res = EON_OFSC_Update_Appointment.getAppointment(lstApp[0].Name);
        EON_Appointment__c objApp = EON_OFSC_Update_Appointment.objAppt1;
        EON_OFSC_Update_Appointment.sendActivityToOFSC(objApp, lstCon, lstVul, '');
        test.StopTest();
        
        list<Oracle_Data_Tracker__c> lstTrac = new list<Oracle_Data_Tracker__c>([select id, name, Status__c from Oracle_Data_Tracker__c where EON_Appointment__c =: objAppointment.Id]);
        system.assertEquals('PASS',lstTrac[0].Status__c);
    }
    
}