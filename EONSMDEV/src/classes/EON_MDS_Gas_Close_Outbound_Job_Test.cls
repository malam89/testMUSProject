/**
Description : This test class is for the following below classes/triggers
			  EON_MDS_Gas_Close_Outbound_Job;    

**/

/*
    Created By  : Tabish Almas
    Created On  : 07/02/2019
    Service Req : SR_EON_297
    Change History

*/

@isTest
global class EON_MDS_Gas_Close_Outbound_Job_Test implements WebServiceMock {
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
                        EON_MDS_Work_Management_WS.ErrorList err = new EON_MDS_Work_Management_WS.ErrorList();
                    err.Message = Msg;
                    EON_MDS_Work_Management_WS.JumboTechnicalResponse resp = new EON_MDS_Work_Management_WS.JumboTechnicalResponse();
                    resp.Errors = err;
                    if(successFlag)
                        resp.Success=true;
                    else
                        resp.Success=false;
                    EON_MDS_Work_Management_WS.CloseJumboGasJobResponse_element obj = new EON_MDS_Work_Management_WS.CloseJumboGasJobResponse_element();
                    obj.CloseJumboGasJobResult=resp;
                    response.put('response_x', obj);
                }
            }
            if(opName == 'closeGasJobViaTrigger'){
                if(request instanceOf EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetails_element){
                    EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element response_x = new EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element();
                    response.put('response_x', response_x);
                }
                else if(request instanceOf EON_MDS_Work_Management_WS.CloseJumboGasJob_element){
                    String[] Msg = new String[]{'Message1','Message2','Message3'};    
                        EON_MDS_Work_Management_WS.ErrorList err = new EON_MDS_Work_Management_WS.ErrorList();
                    err.Message = Msg;
                    EON_MDS_Work_Management_WS.JumboTechnicalResponse resp = new EON_MDS_Work_Management_WS.JumboTechnicalResponse();
                    resp.Errors = err;
                    if(successFlag)
                        resp.Success=true;
                    else
                        resp.Success=false;
                    EON_MDS_Work_Management_WS.CloseJumboGasJobResponse_element obj = new EON_MDS_Work_Management_WS.CloseJumboGasJobResponse_element();
                    obj.CloseJumboGasJobResult=resp;
                    response.put('response_x', obj);
                }
                else if(request instanceOf EON_MDS_Work_Management_WS.RequestGasSupplierAppointments_element){
                    String[] Msg = new String[]{'Message1','Message2','Message3'};
                        EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
                    errObj.Message = Msg;
                    EON_MDS_Work_Management_WS.GasAppointedParty gasAObj = new EON_MDS_Work_Management_WS.GasAppointedParty(); 
                    gasAObj.EffectiveFromDate ='2015-04-23';
                    gasAObj.EffectiveToDate='2016-08-23';
                    gasAObj.AbbreviatedName= abbName; //'SGL';
                    EON_MDS_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_MDS_Work_Management_WS.GasAppointedParty[]{gasAObj};
                        EON_MDS_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_MDS_Work_Management_WS.ArrayOfGasAppointedParty();
                    aepObj.GasAppointedParty = gasAppobj;
                    EON_MDS_Work_Management_WS.GasMeterPoint empObj = new EON_MDS_Work_Management_WS.GasMeterPoint();
                    empObj.MPRN = 'mprn123';
                    empObj.SupplierAppointments = aepObj;
                    EON_MDS_Work_Management_WS.GasSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.GasSupplierDetailsResponse();
                    respMDS.Success = true;
                    respMDS.MeterPoint=empObj;
                    respMDS.Errors = errObj;
                    EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                    obj.RequestGasSupplierAppointmentsResult = respMDS;
                    response.put('response_x', obj);
                }
            }
        }              
    
    
    /**
    closeGasJobMDS_Test_Fail2() - Negative test for EON_MDS_Elec_Close_Outbound_Job
    **/
    static testMethod void closeGasJobMDS_Test_Fail2(){
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        insert app; 
        //Calling close Gas job method method
        EON_MDS_Gas_Close_Outbound_Job.closeGasJobMDS(app.id, false);
    }
    
    /**
    closeGasJobMDS_CallMAM() - This is positive case with MAM call via J.16 //CH03
    **/
    static testmethod void closeGasJobMDS_CallMAM(){
        EON_Jumbo_Abort_Reason_Code__c code = new EON_Jumbo_Abort_Reason_Code__c();
        code.name = 'test';
        code.Gas_Abort_Reason__c = '3';
        insert code;
        string resCode = EON_MDS_Gas_Close_Outbound_Job.AbortReasonCode('test');
        system.assertEquals('3', resCode);
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.status__c='Aborted';
        insert app; 
        Test.setMock(WebServiceMock.class, new EON_MDS_Gas_Close_Outbound_Job_Test());
        EON_MDS_Gas_Close_Outbound_Job_Test.opName = 'closeGasJobViaTrigger';
        EON_MDS_Gas_Close_Outbound_Job_Test.abbName = 'test';
        test.startTest();
        EON_MDS_Gas_Close_Outbound_Job.closeGasJobMDS(app.id, true);
        test.stopTest();
    }
    /**
    closeGasJobMDS_Test2 - Positive test
    **/
    static testMethod void closeGasJobMDS_Test2() {
        Test.setMock(WebServiceMock.class, new EON_MDS_Gas_Close_Outbound_Job_Test());
        EON_MDS_Gas_Close_Outbound_Job_Test.opName = 'closeGasJob';
        
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
        EON_MDS_Gas_Close_Outbound_Job.validateMPRNAtMDS(app);
        //New Change Praveen End
        
        EON_MDS_Gas_Close_Outbound_Job.closeGasJobMDS(app.id, false);
    }
}