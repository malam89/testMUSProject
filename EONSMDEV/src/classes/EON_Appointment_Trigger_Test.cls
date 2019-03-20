/**
Description : This test class is for the following below classes/triggers
              EON_Appointment_Trigger_Helper
              EON_Appointment_Trigger 
              EON_Appment_CancelReason_Trigger_Helper 
              EON_Appointment_Cancel_Reason_Trigger
**/
/* 
Created By    : Sivasankar K
Created On    : 17/02/2016
Service Req   : SR_EON_AB_002
Change History
CH01 # SR_Isis_EON_007 # 09/03/2016 # Mahadev J # Updated field API Parking_Type_Code_c to Parking_Type__c.
CH02 # SR_Isis_EON_009 # 10/03/2016 # Purvi # autopopulate Contract field.
CH03 # SR_EON_AB_029 # 31/03/2016 # Tashika Gupta # Increased coverage of class EON_Appointment_Trigger_Helper.
CH04 # SR_EON_AB_063 # 19/05/2016 # Aruna Manjari # Increased coverage of class EON_Appointment_Trigger_Helper.
CH05 # SR_EON_Scheduling_033 # 23-May-2016 # Praveen G # Added new field Abort_Reason__c
CH06 # SR_EON_Jumbo_042 # 22/07/2016 # Mehboob Alam # Added a new test method for Close Elec/Gas Job.
CH07 # NA # 26/10/2016 # Mahadev J # Imrpved test coeverage
CH08 # SR_EON_Jumbo_070 # Mahadev J # Code coverage to cover logic of calling J.12/J.16 for aborted Job
CH09 # SR_EON_Jumbo_075 # Mahadev J # Code coverage improved
CH10 # SR_EON_Jumbo_106 # Mahadev J # Code coverage improved
CH10 # SR_OptiMUS_EON_138 # Praveen G # Code coverage improved
CH11 # SR_OptiMUS_EON_297 # Tabish Almas # Code coverage improved
*/
@isTest
public class EON_Appointment_Trigger_Test{
    /**
    eonCreateAppTestDataUpdateAppointmentStatus(): this method will create the test data for entair test class
    **/
    @testSetup static void eonCreateAppTestDataUpdateAppointmentStatus(){
        
        
        //Create Eon Appointment Abort Reason
        EON_Appointment_Abort_reason__c objAbort = EON_CreateTestRecords.createEONAppAbortReason();
        insert objAbort;
        
        //Create Eon Appointment Cancel Reason
        EON_Appointment_Cancel_Reason__c objCancel = EON_CreateTestRecords.createEONAppCancelReason();
        insert objCancel;
        
        //Create Eon Appointment Cancel Reason
        EON_Appointment_Cancel_Reason__c objCancel1 = EON_CreateTestRecords.createEONAppCancelReason();
        objCancel1.Reason_Key__c = 'Cancelled';
        insert objCancel1;
        
        //Create Eon Electric Meter Location
        EON_Electric_Meter_Location__c objLocation = EON_CreateTestRecords.createEONEleMeterLocation();
        insert objLocation;
        
        //Create Eon Electric Meter Location
        EON_Gas_Meter_Mechanism__c objMechanism = EON_CreateTestRecords.createEONGasMeterMechanism();
        insert objMechanism;
        
        //Create Eon Job
        EON_Job__c objJOb = EON_CreateTestRecords.createEONJob();
        insert objJOb;
        
        //Create Eon Parking
        EON_Parking__c objParking = EON_CreateTestRecords.createEONParking();
        insert objParking;
        
        //Create Eon Technician
        EON_Technician__c objTechnician = EON_CreateTestRecords.createEONTechnician();
        insert objTechnician;
        
        List<EON_Appointment__c> lstEonApp = new List<EON_Appointment__c>();
        
        for ( integer i=0; i < 11 ; i++ ) {
            //create more records for EON Appointment for testing the Status
            EON_Appointment__c appt= EON_CreateTestRecords.createEONAppointment();
            appt.E_Location_Code__c = objLocation.ID;
            Appt.G_Location_Code__c = objMechanism.ID;
            Appt.Job_Code__c = objJOb.ID;
            Appt.Parking_Type__c = objParking.ID; //CH01.Change
            
            lstEonApp.add(appt);
        }
        lstEonApp[0].Complete_DateTime__c = Date.today();
        lstEonApp[0].Requested_SSC__c = '1122'; //CH07.New
        lstEonApp[1].Requested_SSC__c = '2233'; //CH07.New
        lstEonApp[1].Cancel_Reason__c = objCancel.id;
        lstEonApp[1].Deferral_Notes__c = 'For making the status as DEFERRAL';
        lstEonApp[1].Cancellation_DateTime__c = DateTime.now();//CH03
        lstEonApp[2].Cancellation_DateTime__c = DateTime.now();//CH03
        lstEonApp[2].Cancel_Reason__c = objCancel.id;
        lstEonApp[3].Cancel_Reason__c = objCancel1.id;
        lstEonApp[3].Cancellation_DateTime__c = DateTime.now();//CH03
        lstEonApp[4].Complete_DateTime__c = Date.today();
        lstEonApp[4].Abort_Reason__c = objAbort.id;
        lstEONApp[4].Abort_Datetime__c = System.today(); // CH05
        lstEonApp[5].Suspended_DateTime__c = DateTime.now();
        lstEonApp[6].Onsite_DateTime__c = DateTime.now();
        lstEonApp[7].En_Route_DateTime__c = DateTime.now();
        lstEonApp[8].Technician__c = objTechnician.id;
        lstEonApp[9].Confirmed_Appointment_DateTime__c = DateTime.now();
        insert lstEonApp;
        
        //CH07.Start
        list<EON_SSC__c> listEonSSC = new list<EON_SSC__c>();
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = '1122';
        listEonSSC.add(eSSC);
        EON_SSC__c eSSC1 = new EON_SSC__c();
        eSSC1.Name = '2233';
        listEonSSC.add(eSSC1);
        insert listEonSSC;
        
        list<EON_SSC_Register__c> eSSCRegister = new list<EON_SSC_Register__c>();
        EON_SSC_Register__c reg = new EON_SSC_Register__c();
        reg.Name = 'test';
        reg.SSC__c = eSSC.ID;
        eSSCRegister.add(reg);
        EON_SSC_Register__c reg1 = new EON_SSC_Register__c();
        reg1.Name = 'test';
        reg1.SSC__c = eSSC1.ID;
        eSSCRegister.add(reg1);
        EON_SSC_Register__c reg2 = new EON_SSC_Register__c();
        reg2.Name = 'test1';
        reg2.SSC__c = eSSC1.ID;
        eSSCRegister.add(reg2);
        insert eSSCRegister;
        //CH07.End
    }
    
    /**
    UpdateAppointmentStatus(): this method will update and check the status of appointment Status, this will cover the code for EON_Appointment_Trigger_Helper and EON_Appointment_Trigger
    **/
    @isTest static void UpdateAppointmentStatus() {
        
        Test.startTest();
        List<EON_Appointment__c> lstEonApp = new List<EON_Appointment__c>([SELECT ID,Status__c,h_Cancel_Reason_Key__c,Complete_DateTime__c,Cancel_Reason__c,Deferral_Notes__c,Suspended_DateTime__c,Onsite_DateTime__c,En_Route_DateTime__c,Technician__c,Confirmed_Appointment_DateTime__c FROM EON_Appointment__c]);
        //calling the method for calcualting the Appointment Status.
        EON_Appointment_Trigger_Helper.updateEONAppointmentStatus(lstEonApp);
            
        EON_Appointment__c eonAppComp = [SELECT ID,Status__c FROM EON_Appointment__c WHERE ID =:lstEonApp[0].id];
        EON_Appointment__c eonAppSch = [SELECT ID,Status__c FROM EON_Appointment__c WHERE ID =:lstEonApp[9].id];
        
        
        System.assertEquals('COMPLETED',eonAppComp.Status__c);
        System.assertEquals('AwaitingIndustryData',eonAppSch.Status__c);//CH04 System.assertEquals('AWAITING INDUSTRY DATA',eonAppSch.Status__c);
        System.assertNOTEquals('RESERVATION',eonAppSch.Status__c);
        
        List<EON_Appointment_Cancel_Reason__c> CancelledLst = new List<EON_Appointment_Cancel_Reason__c>([SELECT id,Reason_key__c FROM EON_Appointment_Cancel_Reason__c WHERE Reason_key__c = 'Cancelled']);
        
        if ( CancelledLst != null && CancelledLst.size() > 0 ){
            CancelledLst[0].Reason_key__c = 'Rescheduled';
            try{
                update CancelledLst;
            }Catch(Exception Ex){}
        }
        
        Test.stopTest();
    }
    
    /**CH03.Start
    UpdateAppointmentStatusException(): this method will cover the code for exception part for EON_Appointment_Trigger_Helper 
    **/
    @isTest static void UpdateAppointmentStatusException() {
        Test.startTest();
        
        String err = '';
        try{
         List<EON_Appointment__c> lstEonApp ; 
         EON_Appointment_Trigger_Helper.updateEONAppointmentStatus(lstEonApp);
        }Catch(Exception ex){
            err = ex.getMessage();
            system.debug('^^^^^error message ^^^^^^^^:'+err);
        }
        
        //System.assertEquals(true,err.containsIgnoreCase('Attempt to de-reference'));
        
        Test.stopTest();
    }
    //CH03.End   
    
    /**
    UpdateCancelReasonsRecords(): this method will update and check the status of appointment Status, this will cover the code for EON_Appment_CancelReason_Trigger_Helperand EON_Appointment_Cancel_Reason_Trigger
    **/
    @isTest static void UpdateCancelReasonsRecords() {
        
        Test.startTest();
        
        List<EON_Appointment_Cancel_Reason__c> newObjCancel = new List<EON_Appointment_Cancel_Reason__c>();
        String err = '';
        for (EON_Appointment_Cancel_Reason__c cancelRe : [SELECT id,Reason_key__c FROM EON_Appointment_Cancel_Reason__c] ) {
            cancelRe.Reason_key__c = 'Test123';
            newObjCancel.add(cancelRe);
        }
        try{
            update newObjCancel;
        }Catch(Exception ex) {
            err = ex.getMessage();
        }
        System.assertEquals(true,err.containsIgnoreCase('Attempt to de-reference'));
        Test.stopTest();
    }
    
    /**
    UpdateAppointmentStatusCancelException(): this method will cover the code for exception part.
    **/
    @isTest static void UpdateAppointmentStatusCancelException() {
        
        Test.startTest();
        
        String err = '';
        try{
            Map<Id,EON_Appointment_Cancel_Reason__c> mapNew;
            Map<Id,EON_Appointment_Cancel_Reason__c> mapOld;   
        
            EON_Appment_CancelReason_Trigger_Helper.updateEonAppointments(mapNew,mapOld);
        }Catch(Exception ex){
            err = ex.getMessage();
        }
        
        System.assertEquals(true,err.containsIgnoreCase('Attempt to de-reference'));
        
        Test.stopTest();
    }
    
    /**
    autopopulateContractNumber(): this method will autopopulate Contract field.
    **/ 
    //CH02 START
    @isTest static void autopopulateContractNumber() {
    
        Test.startTest();
        
        Contract_Number__c con = EON_CreateTestRecords.createContractNumber();
        insert con;
        
        EON_Appointment__c appt= EON_CreateTestRecords.createEONAppointment();
        appt.Appointment_Date__c = date.newInstance(2016,02,10);
        insert appt;
        
        EON_Appointment__c queryCNo = [select Contract__c from EON_Appointment__c where id =: appt.id];
        System.assertEquals(queryCNo.Contract__c,con.id);        
        
        try{
            EON_Appointment_Trigger_Helper.autopopulateContract(null);
        }
        catch(Exception ex){}
                
        Test.stopTest();
        
    } //CH02 END
    
    
    /**
    closeElecGasjobJumbo(): This Test Method populating information for Close Elec/Gas Job.
    **/ 
    //CH06 START
    @isTest static void closeElecGasjobJumbo(){
        Test.startTest();
        EON_Appointment__c appt= EON_CreateTestRecords.createEONAppointment();
        appt.Appointment_Date__c = date.newInstance(2016,02,10);
        appt.MPAN__c = '454545';
        insert appt;
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch; //CH11.End
        appt.Complete_DateTime__c = date.today();
        Update appt;
        Test.stopTest();
    } //CH06 END
    
    /**
        closeElecGas - This method will cover postive test for aborted job closure at Jumbo //CH08
    **/
    @isTest static void closeElecGas(){
        EON_Appointment__c appt= EON_CreateTestRecords.createEONAppointment();
        appt.Appointment_Date__c = date.newInstance(2016,02,10);
        appt.MPAN__c = '454545';
        appt.MPAN__c = '545454';
        insert appt;
        EON_Job_Results__c jobRes = new EON_Job_Results__c();
        jobRes.Able_to_obtain_E_Meter_reading__c = 'Yes';
        jobRes.Able_to_obtain_G_Meter_reading__c = 'Yes';
        jobRes.Job_reference__c = appt.ID;
        insert jobRes;
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch; //CH11.End
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
        EON_Jumbo_ElecGasData_Test.functionType ='validateMOP';
        appt.Abort_Datetime__c = System.now();
        update appt;
        Test.stopTest();
    }
    
    /**
        closeElecGas_01 - This method will cover postive test for aborted job closure at Jumbo //CH09
    **/
    @isTest static void closeElecGas_01(){
        Eon_Appointment_Reason__c apptRes = new Eon_Appointment_Reason__c();
        apptRes.name = 'new Connections';
        insert apptRes;
        EON_Appointment__c appt= EON_CreateTestRecords.createEONAppointment();
        appt.Appointment_Date__c = date.newInstance(2016,02,10);
        appt.MPAN__c = '454545';
        appt.MPAN__c = '545454';
        appt.Appointment_reason_code__c = apptRes.id;
        insert appt;
        EON_Job_Results__c jobRes = new EON_Job_Results__c();
        jobRes.Able_to_obtain_E_Meter_reading__c = 'Yes';
        jobRes.Able_to_obtain_G_Meter_reading__c = 'Yes';
        jobRes.Job_reference__c = appt.ID;
        insert jobRes;
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch; //CH11.End
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
        EON_Jumbo_ElecGasData_Test.functionType ='validateMOP';
        appt.Abort_Datetime__c = System.now();
        update appt;
        Test.stopTest();
    }
    
    /**
        updateApptForEmeterLink(): This will cover positive scenario
    **/
    @isTest static void updateApptForEmeterLink(){
        Eon_Appointment_Reason__c apptRes = new Eon_Appointment_Reason__c();
        apptRes.name = 'new Connections';
        insert apptRes;
        
        EON_Appointment__c appt= EON_CreateTestRecords.createEONAppointment();
        appt.Appointment_Date__c = date.newInstance(2016,02,10);
        appt.MPAN__c = '454545';
        appt.MPAN__c = '545454';
        appt.Appointment_reason_code__c = apptRes.id;
        insert appt;
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch; //CH11.End

        list<EON_Appointment_Meter__c> listMeter = new list<EON_Appointment_Meter__c>();
        
        EON_Appointment_Meter__c apptMeter = new EON_Appointment_Meter__c();
        apptMeter.EON_Appointment__c = appt.ID;
        apptMeter.Name = '12334';
        apptMeter.E_Meter_Make__c = 'test';
        apptMeter.E_Meter_Model__c = 'test';
        apptMeter.E_Meter_Reg_1_No_of_dials_digits__c = 1;
        apptMeter.E_Meter_Reg_2_No_of_dials_digits__c = 2;
        apptMeter.E_Meter_Reg_3_No_of_dials_digits__c = 3;
        apptMeter.E_Meter_Reg_4_No_of_dials_digits__c = 4;
        apptMeter.E_Meter_Reg_5_No_of_dials_digits__c = 5;
        apptMeter.E_Meter_Reg_6_No_of_dials_digits__c = 6;
        apptMeter.E_Meter_Register_1_ID__c = '12';
        listMeter.add(apptMeter);
        
        EON_Appointment_Meter__c apptMeter1 = new EON_Appointment_Meter__c();
        apptMeter1.EON_Appointment__c = appt.ID;
        apptMeter1.Name = '123345';
        apptMeter1.E_Meter_Make__c = 'test';
        apptMeter1.E_Meter_Model__c = 'test';
        apptMeter1.E_Meter_Reg_1_No_of_dials_digits__c = 1;
        apptMeter1.E_Meter_Reg_2_No_of_dials_digits__c = 2;
        apptMeter1.E_Meter_Reg_3_No_of_dials_digits__c = 3;
        apptMeter1.E_Meter_Reg_4_No_of_dials_digits__c = 4;
        apptMeter1.E_Meter_Reg_5_No_of_dials_digits__c = 5;
        apptMeter1.E_Meter_Reg_6_No_of_dials_digits__c = 6;
        apptMeter1.E_Meter_Register_1_ID__c = '12';
        listMeter.add(apptMeter1);
        insert listMeter;
        
        test.startTest();
        list<EON_Appointment_Meter__c> searchMeter = [Select ID from EON_Appointment_Meter__c where name='12334'];
        appt.E_Meter_Serial_Link__c = searchMeter[0].ID;
        update appt;
        test.stopTest();
    }
    
    //CH10 - Praveen Start
    /**
        unitTest1() - unitTest
    **/
    public testmethod static void unitTest1(){
        EON_Job__c objJOb = EON_CreateTestRecords.createEONJob();
        objJOb.name = 'OOAEINSTALLBIND';
        insert objJOb;
            
        EON_Appointment__c appt= EON_CreateTestRecords.createEONAppointment();
        appt.Booking_System_Name__c = 'MUS';
        appt.Job_Code__c = objJOb.id;
        insert appt;
        
        EON_Appointment_Meter__c meter = new EON_Appointment_Meter__c();
        meter.EON_Appointment__c = appt.id;
        insert meter;
        
        appt.E_Meter_Serial_Link__c = meter.id;
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch; //CH11.End
        
        List<EON_Appointment__c> lstApp = new List<EON_Appointment__c>();
        lstApp.add(appt);
        EON_Appointment_Trigger_Helper.UpdateAppointment(lstApp);
        
        appt.Booking_System_Name__c = 'ICE';
        appt.Comms_Hub_Variant__c = null;
        appt.Coverage_Availability__c = null;
        appt.Connectivity_Likelihood__c = null;
        update appt;
    }  
    //CH10 - Praveen End
}