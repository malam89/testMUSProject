/**
Description : This test class is for the following below classes/triggers
              EON_Jumbo_Gas_Close_Outbound_Job;    
              
**/

/*
    Created By  : Mehboob Alam
    Created On  : 10/06/2016
    Service Req : SR_EON_Jumbo_042
    Change History
    CH01 # SR_EON_Jumbo_050 # 02/08/2016 # Mahadev J # Covering code by test class improvement
    CH02 # SR_EON_Jumbo_053 # 04/08/2016 # Mahadev J # Covering code by test class improvement
    CH03 # SR_EON_JUMBO_070 # 02/11/2016 # Mahadev J # Amended the logic to send 'ABORTED' job to Jumbo via J.16 interface
*/

@isTest
global class EON_Jumbo_Gas_Close_Outbound_Job_Test implements WebServiceMock {
     public static boolean successFlag=true;
    public static string opName = '';
    public static string abbName = '';
    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
                if(opName == 'closeGasJob'){
                    if(request instanceOf EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetails_element){
                        EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element response_x = new EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element();
                        response.put('response_x', response_x);
                    }
                    else{
                        String[] Msg = new String[]{'Message1','Message2','Message3'};    
                        EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                        err.Message = Msg;
                        EON_JUMBO_Work_Management_WS.JumboTechnicalResponse resp = new EON_JUMBO_Work_Management_WS.JumboTechnicalResponse();
                        resp.Errors = err;
                        if(successFlag)
                           resp.Success=true;
                            else
                              resp.Success=false;
                        EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element obj = new EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element();
                        obj.CloseJumboGasJobResult=resp;
                        response.put('response_x', obj);
                    }
                }
                if(opName == 'closeGasJobViaTrigger'){
                    if(request instanceOf EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetails_element){
                        EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element response_x = new EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element();
                        response.put('response_x', response_x);
                    }
                    else if(request instanceOf EON_JUMBO_Work_Management_WS.CloseJumboGasJob_element){
                        String[] Msg = new String[]{'Message1','Message2','Message3'};    
                        EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                        err.Message = Msg;
                        EON_JUMBO_Work_Management_WS.JumboTechnicalResponse resp = new EON_JUMBO_Work_Management_WS.JumboTechnicalResponse();
                        resp.Errors = err;
                        if(successFlag)
                           resp.Success=true;
                            else
                              resp.Success=false;
                        EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element obj = new EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element();
                        obj.CloseJumboGasJobResult=resp;
                        response.put('response_x', obj);
                    }
                    else if(request instanceOf EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element){
                        String[] Msg = new String[]{'Message1','Message2','Message3'};
                        EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                        errObj.Message = Msg;
                        EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
                        gasAObj.EffectiveFromDate ='2015-04-23';
                        gasAObj.EffectiveToDate='2016-08-23';
                        gasAObj.AbbreviatedName= abbName; //'SGL';
                        EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[]{gasAObj};
                        EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                        aepObj.GasAppointedParty = gasAppobj;
                        EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                        empObj.MPRN = 'mprn123';
                        empObj.SupplierAppointments = aepObj;
                        EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                        respJumbo.Success = true;
                        respJumbo.MeterPoint=empObj;
                        respJumbo.Errors = errObj;
                        EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                        obj.RequestGasSupplierAppointmentsResult = respJumbo;
                        response.put('response_x', obj);
                    }
                }
            }              
    
    /*static testMethod void closeGasJobJUMBO_Test1() {
        //CH02.Start
        list<EON_Gas_Meter_Mechanism__c> allGasMechanism = new list<EON_Gas_Meter_Mechanism__c>();
        EON_Gas_Meter_Mechanism__c gMechanism = EON_CreateTestRecords.createEONGasMeterMechanism();
        gMechanism.Name = 'MS1';
        gMechanism.Code__c = 'MS';
        allGasMechanism.add(gMechanism);
        EON_Gas_Meter_Mechanism__c gMechanism1 = new EON_Gas_Meter_Mechanism__c();
        gMechanism1.Name = 'PP';
        gMechanism1.Code__c = 'PP';
        allGasMechanism.add(gMechanism1);
        insert allGasMechanism;
        EON_Job__c job = new EON_Job__c(name='OOAREPOSELEC', Jumbo_job_code__c = 'test', description__c = 'test');
        insert job;
        //CH02.End
        EON_Jumbo_Gas_Close_Outbound_Job.IndCodeMeterType('MS1'); //CH02.Change
        EON_Jumbo_Gas_Close_Outbound_Job.IndCodeMeterType('New');
        EON_Jumbo_Gas_Close_Outbound_Job.MapLocationCode('New');
        EON_Jumbo_Gas_Close_Outbound_Job.IndCodeNewMeterType('New');
        Test.setMock(WebServiceMock.class, new EON_Jumbo_Gas_Close_Outbound_Job_Test());
        EON_Jumbo_Gas_Close_Outbound_Job_Test.opName = 'closeGasJob';
        
        EON_Technician__c tech = new EON_Technician__c();
        tech.Start_Date__c = System.Date.today();
        insert tech;

        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.Technician__c = tech.ID;
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.h_Metering_Pressure__c='1';
        app.Gas_Market_Participant_ID__c='Test';
        app.Job_Code__c = job.ID;
        app.Complete_DateTime__c = System.now();
        insert app;
        
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Job_Reference__c =app.id;
        appJobRes.Time_On_Site__c = DateTime.now();
        appJobRes.Time_Closed__c = DateTime.now();
        appJobRes.Site_Left_Energised__c='Yes';
        appJobRes.Gas_Supply_Capped__c ='Yes';
        appJobRes.G_Meter_Location__c ='Hall'; //Attic //CH01
        appJobRes.G_Meter_Version__c ='Old';
        appJobRes.New_G_Meter_Version__c= 'New';
        appJobRes.G_Meter_Manufacturer__c = 'PRI Ltd';
        appJobRes.New_G_Meter_Manufacturer__c = 'PRI Ltd';
        appJobRes.Removed_G_Meter_Location__c= 'Attic';
        appJobRes.New_G_Meter_Location__c= 'Outside'; //Attic //CH01
        appJobRes.G_Meter_Removed__c= 'Yes';
        appJobRes.Abort_Comments__c= 'AbortComments';
        appJobRes.Job_Status__c= 'JobStatus';
        appJobRes.Abort_Reason__c= 'Pre Visit Customer Refusal';
        appJobRes.Work_Summary__c='CommunalCupboard';
        appJobRes.G_Meter_Serial_Number__c='G123';
        appJobRes.Removed_G_Meter_Serial_Number__c ='G456';
        appJobRes.New_G_Meter_Serial_Number__c='G789'; 
        //CH01.New
        appJobRes.G_Meter_Number_of_Digits__c = '3';
        appJobRes.G_Meter_Register_Read__c = '12334';
        appJobRes.Opening_G_Meter_Reading__c = '11223';
        appJobRes.New_G_Meter_Number_of_Digits__c = '2';
        appJobRes.G_Meter_Type__c = 'MS1';
        appJobRes.New_G_Meter_Type__c = 'PP';
        //CH01.New
        appJobRes.h_G_Meter_Manufacturer__c = 'PP';
        appJobRes.h_New_G_Meter_Manufacturer__c = 'PP';
        insert appJobRes;
        //Calling close Gas job method
        EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(app.id, false);
        appJobRes.G_Meter_Removed__c = 'No';
        update appJobRes;
        EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(app.id, false);
    }
    
     static testMethod void closeGasJobJUMBO_Test_Fail(){
        
        successFlag=false;
        Test.setMock(WebServiceMock.class, new EON_Jumbo_Gas_Close_Outbound_Job_Test());
         EON_Jumbo_Gas_Close_Outbound_Job_Test.opName = 'closeGasJob';
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        insert app; 
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Job_Reference__c =app.id;
        appJobRes.G_Meter_Removed__c='Yes';
        insert appJobRes;
        
        //Calling close Gas job method method
        EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(app.id, false);
    }*/
    
     /**
     closeElecJobJUMBO_Test_Fail() - Negative test for EON_Jumbo_Elec_Close_Outbound_Job
     **/
    static testMethod void closeGasJobJUMBO_Test_Fail2(){
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        insert app; 
        //Calling close Gas job method method
        EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(app.id, false);
    }
    
    /**
        closeGasJobJUMBO_CallMAM() - This is positive case with MAM call via J.16 //CH03
    **/
    static testmethod void closeGasJobJUMBO_CallMAM(){
        EON_Jumbo_Abort_Reason_Code__c code = new EON_Jumbo_Abort_Reason_Code__c();
        code.name = 'test';
        code.Gas_Abort_Reason__c = '3';
        insert code;
        string resCode = EON_Jumbo_Gas_Close_Outbound_Job.AbortReasonCode('test');
        system.assertEquals('3', resCode);
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.status__c='Aborted';
        insert app; 
        Test.setMock(WebServiceMock.class, new EON_Jumbo_Gas_Close_Outbound_Job_Test());
        EON_Jumbo_Gas_Close_Outbound_Job_Test.opName = 'closeGasJobViaTrigger';
        EON_Jumbo_Gas_Close_Outbound_Job_Test.abbName = 'test';
        test.startTest();
        EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(app.id, true);
        test.stopTest();
    }
    /**
        closeGasJobJUMBO_Test2 - Positive test
    **/
    static testMethod void closeGasJobJUMBO_Test2() {
        Test.setMock(WebServiceMock.class, new EON_Jumbo_Gas_Close_Outbound_Job_Test());
        EON_Jumbo_Gas_Close_Outbound_Job_Test.opName = 'closeGasJob';
        
        EON_Job__c job = new EON_Job__c(name = 'OOAREPOSELEC', Description__c='test', Jumbo_Job_Code__c='11');
        insert job;
        
        EON_Gas_Meter_Mechanism__c gMech = new EON_Gas_Meter_Mechanism__c(Name='test', Code__c='c');
        insert gMech;
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.h_Metering_Pressure__c='1';
        app.Gas_Market_Participant_ID__c='Test';
        app.Job_Code__c = job.ID;
        app.Abort_Datetime__c = system.now();
        insert app;
        
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Job_Reference__c =app.id;
        appJobRes.Time_On_Site__c = DateTime.now();
        appJobRes.Time_Closed__c = DateTime.now();
        appJobRes.G_Meter_Location__c ='Hall'; 
        appJobRes.New_G_Meter_Location__c= 'Outside'; 
        appJobRes.Abort_Reason__c = 'Pre Visit Customer Refusal';
        appJobRes.Site_Left_Energised__c = 'T'; 
        appJobRes.Gas_Supply_Capped__c = 'T'; 
        appJobRes.Work_Summary__c = 'T'; 
        appJobRes.G_Meter_Serial_Number__c = 'T'; 
        appJobRes.New_G_Meter_Serial_Number__c = 'T'; 
        appJobRes.G_Meter_Type__c = 'test'; 
        appJobRes.New_G_Meter_Type__c = 'MCL';
        appJobRes.G_Meter_Version__c = 'T';
        appJobRes.New_G_Meter_Version__c = 'T';
        appJobRes.h_G_Meter_Manufacturer__c = 'T';
        appJobRes.h_New_G_Meter_Manufacturer__c = 'T';
        appJobRes.G_Meter_Register_Read__c = 'T';
        appJobRes.G_Meter_Number_of_Digits__c = 'T';
        appJobRes.Opening_G_Meter_Reading__c = 'T';
        appJobRes.New_G_Meter_Number_of_Digits__c = 'T';
        appJobRes.G_Meter_Installed__c='Yes';
        appJobRes.Original_G_Meter_refitted__c='Yes';
        appJobRes.h_Abort_Reason__c='true';
        insert appJobRes;
        
        //Calling close Gas job method
        
        //New Change Praveen Start
         EON_Jumbo_Gas_Close_Outbound_Job.validateMPRNAtJUMBO(app);
        //New Change Praveen End
        
        EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(app.id, false);
    }
}