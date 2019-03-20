/**
    Description : This test class covers the code coverage for below class
        1. EON_JUMBO_Create_GasJob_In_Isis_WS
**/
/*
    Created By : Praveen G
    Created Date : 16-March-2016
    Service Request : SR_EON_Jumbo_010
    Change History :
    CH01 # SR_EON_Jumbo_046 # 25/07/2016 # Mahadev Joshilkar # Update code coverage
  CH02 # SR_EON_Jumbo_062 # 03/09/2016 # Mahadev Joshilkar # Update code coverage
*/

@isTest
global class EON_JUMBO_Create_GasJob_In_Isis_WS_Test  implements WebServiceMock{
  public static boolean errFlag = false; //CH02
  public static string methodType = ''; //CH02
  public static string methodMPRNType = ''; //CH02
    /**
      createGasJobInIsis_1() - Fail Unit test for method createGasJobInIsis
    **/ 
    static testMethod void createGasJobInIsis_1() {  
        //Scenario-1
        EON_JUMBO_Create_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response = EON_JUMBO_Create_GasJob_In_Isis_WS.createGasJobInIsis(null);
        System.assert(response.success == 'FAIL');     
        
        //Scenario-2
        EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest  request = new EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest();
        EON_JUMBO_Create_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response1 = EON_JUMBO_Create_GasJob_In_Isis_WS.createGasJobInIsis(request); 
        System.assert(response1.success == 'FAIL'); 
        
        EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest  request1 = new EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest();
        request1.MPRN = '1234';
        request1.JUMBOID = '1234';
        request1.LatestStartTime = '10:10';
        request1.earliestStartDate = System.today();
        request1.JUMBOJobType = 'test Type';  
        EON_JUMBO_Create_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response2 = EON_JUMBO_Create_GasJob_In_Isis_WS.createGasJobInIsis(request1); 
        System.assert(response2.success == 'FAIL');        
  }
    
  /**
      createGasJobInIsis_2() - Fail Unit test for method createGasJobInIsis
     **/
     static testMethod void createGasJobInIsis_2(){  
      errFlag = true;
        EON_Job__c job = new EON_Job__c(Name =  'test Type', Jumbo_Job_Code__c ='test Type', Description__c = 'Description');
        insert job;
            
        EON_Gas_Meter_Location__c gasLoc = new EON_Gas_Meter_Location__c();
        gasLoc.name = 'Location';
        insert gasLoc;
           
        EON_Gas_Meter_Mechanism__c metMObj = new EON_Gas_Meter_Mechanism__c();
        metMObj.name= 'Mechanism';
        insert metMObj;
           
        EON_Gas_Meter_Type__c eMetTyp = new EON_Gas_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;
    
        system.Test.StartTest();
        Test.setMock(WebServiceMock.class, new EON_JUMBO_Gas_WebServiceMockImpl());
        EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest  request1 = new EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest();
        request1.MPRN = '1234';
        request1.JUMBOID = '1234';
        request1.LatestStartTime = '10:10';
        request1.earliestStartDate = System.today();
        request1.JUMBOJobType = 'test Type';  
        EON_JUMBO_Create_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response2 = EON_JUMBO_Create_GasJob_In_Isis_WS.createGasJobInIsis(request1); 
        System.assert(response2.success == 'FAIL');   
        system.Test.StopTest();   
  }
    
    /**
      createGasJobInIsis_3() - Fail Unit test for method createGasJobInIsis
     **/
    static testMethod void createGasJobInIsis_3(){  
      errFlag = false;
        EON_Job__c job = new EON_Job__c(Name =  'test Type', Jumbo_Job_Code__c ='test Type', Description__c = 'Description');
        insert job;
            
        EON_Gas_Meter_Location__c gasLoc = new EON_Gas_Meter_Location__c();
        gasLoc.name = 'Location';
        insert gasLoc;
            
        EON_Gas_Meter_Mechanism__c metMObj = new EON_Gas_Meter_Mechanism__c();
        metMObj.name= 'Mechanism';
        insert metMObj;
            
        EON_Gas_Meter_Type__c eMetTyp = new EON_Gas_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;
    
        system.Test.StartTest();
      Test.setMock(WebServiceMock.class, new EON_JUMBO_Gas_WebServiceMockImpl());
        EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest  request1 = new EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest();
        request1.MPRN = '1234';
        request1.JUMBOID = '1234';
        request1.LatestStartTime = '10:10:10';
        request1.earliestStartDate = System.today();
        request1.JUMBOJobType = 'test Type';  
        EON_JUMBO_Create_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response2 = EON_JUMBO_Create_GasJob_In_Isis_WS.createGasJobInIsis(request1);
        System.assert(response2.success == 'FAIL');    
        system.Test.StopTest();   
    }    
    
    /**
      createGasJobInIsis_4() - Fail Unit test for method createGasJobInIsis
     **/
    static testMethod void createGasJobInIsis_4(){  
      EON_Job__c job = new EON_Job__c(Name =  'test Type', Jumbo_Job_Code__c ='test Type', Description__c = 'Description');
        insert job;
          
        EON_Gas_Meter_Location__c gasLoc = new EON_Gas_Meter_Location__c();
        gasLoc.name = 'Location';
        insert gasLoc;
            
        EON_Gas_Meter_Mechanism__c metMObj = new EON_Gas_Meter_Mechanism__c();
        metMObj.name= 'Mechanism';
        insert metMObj;
            
        EON_Gas_Meter_Type__c eMetTyp = new EON_Gas_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;
    
        system.Test.StartTest();
        Test.setMock(WebServiceMock.class, new EON_JUMBO_Create_GasJob_In_Isis_WS_Test());
        EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest  request1 = new EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest();
        request1.MPRN = '1234';
        request1.JUMBOID = '1234';
        request1.LatestStartTime = '10:10';
        request1.earliestStartDate = System.today();
        request1.JUMBOJobType = 'test Type';  
        EON_JUMBO_Create_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response2 = EON_JUMBO_Create_GasJob_In_Isis_WS.createGasJobInIsis(request1);
        System.assert(response2.success == 'FAIL');    
        system.Test.StopTest();   
    }
    

  /**
      createGasJobInIsis_5() - Pass Unit test for method createGasJobInIsis
  **/
    static testMethod void createGasJobInIsis_5(){  
      errFlag = false;
      EON_Job__c job = new EON_Job__c(Name =  'test Type', h_Appointment_Reason_Code__c = 'test code', Jumbo_Job_Code__c ='test Type', Description__c = 'Description'); //CH01
        insert job;
            
        Eon_Appointment_Reason__c appReasonCode = new Eon_Appointment_Reason__c(Name = 'test code'); //Ch01.New
        insert appReasonCode;             //CH01.New
            
        EON_Gas_Meter_Type__c gasMObj = new EON_Gas_Meter_Type__c();
        gasMObj.Name = 'Type_x';
        gasMObj.Industry_Code__c= 'P';
        insert gasMObj;   
     
        EON_Gas_Meter_Mechanism__c metMObj = new EON_Gas_Meter_Mechanism__c();
        metMObj.name= 'Mechanism';
        metMObj.Code__c= 'GM';
        insert metMObj;
        
        EON_Gas_Meter_Location__c gasLoc = new EON_Gas_Meter_Location__c();
        gasLoc.name = 'Location';
        gasLoc.Code__c= 'AT';
        insert gasLoc;
            
        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
        insert parType;
    
        system.Test.StartTest();
        Test.setMock(WebServiceMock.class, new EON_JUMBO_Gas_WebServiceMockImpl());
        EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest  request1 = new EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest();
        request1.MPRN = '1234';
        request1.JUMBOID = '1234';
        request1.RequestTime ='111010';
        request1.EarliestStartTime ='121010' ;
        request1.LatestStartTime = '101010';
        request1.earliestStartDate = System.today();
        request1.JUMBOJobType = 'test Type';  
        EON_JUMBO_Create_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response2 = EON_JUMBO_Create_GasJob_In_Isis_WS.createGasJobInIsis(request1);   
        System.assert(response2.success == 'PASS'); 
        system.Test.StopTest();   
    }
    
    /**
      createGasJobInIsis_6() - Fail Unit test for method createGasJobInIsis for CH02
  **/
    static testMethod void createGasJobInIsis_6(){  
      errFlag = false;
      EON_Job__c job = new EON_Job__c(Name =  'test Type', h_Appointment_Reason_Code__c = 'test code', Jumbo_Job_Code__c ='test Type', Description__c = 'Description'); //CH01
        insert job;
            
        Eon_Appointment_Reason__c appReasonCode = new Eon_Appointment_Reason__c(Name = 'test code'); //Ch01.New
        insert appReasonCode;             //CH01.New
            
        EON_Gas_Meter_Type__c gasMObj = new EON_Gas_Meter_Type__c();
        gasMObj.Name = 'Type_x';
        gasMObj.Industry_Code__c= 'P';
        insert gasMObj;   
     
        EON_Gas_Meter_Mechanism__c metMObj = new EON_Gas_Meter_Mechanism__c();
        metMObj.name= 'Mechanism';
        metMObj.Code__c= 'GM';
        insert metMObj;
        
        EON_Gas_Meter_Location__c gasLoc = new EON_Gas_Meter_Location__c();
        gasLoc.name = 'Location';
        gasLoc.Code__c= 'AT';
        insert gasLoc;
            
        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
        insert parType;
    
        system.Test.StartTest();
        //EON_JUMBO_Gas_WebServiceMockImpl.methodType = 'errorResponse';
        //Test.setMock(WebServiceMock.class, new EON_JUMBO_Gas_WebServiceMockImpl());
        EON_JUMBO_Create_GasJob_In_Isis_WS_Test.methodType = 'SuccessMOP';
        Test.setMock(WebServiceMock.class, new EON_JUMBO_Create_GasJob_In_Isis_WS_Test());
        EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest  request1 = new EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest();
        request1.MPRN = '1234';
        request1.JUMBOID = '1234';
        request1.RequestTime ='111010';
        request1.EarliestStartTime ='121010' ;
        request1.LatestStartTime = '101010';
        request1.earliestStartDate =  System.today() - 700 ;//System.today();
        request1.JUMBOJobType = 'test Type';  
        EON_JUMBO_Create_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response2 = EON_JUMBO_Create_GasJob_In_Isis_WS.createGasJobInIsis(request1);   
        system.debug('####Method6: '+response2.Message);
        //System.assert(response2.success == 'FAIL'); 
        system.Test.StopTest();   
    }
    /**
      createGasJobInIsis_7() - Fail Unit test for method createGasJobInIsis for CH02
  **/
    static testMethod void createGasJobInIsis_7(){  
      errFlag = false;
      EON_Job__c job = new EON_Job__c(Name =  'test Type', h_Appointment_Reason_Code__c = 'test code', Jumbo_Job_Code__c ='test Type', Description__c = 'Description'); //CH01
        insert job;
            
        Eon_Appointment_Reason__c appReasonCode = new Eon_Appointment_Reason__c(Name = 'test code'); //Ch01.New
        insert appReasonCode;             //CH01.New
            
        EON_Gas_Meter_Type__c gasMObj = new EON_Gas_Meter_Type__c();
        gasMObj.Name = 'Type_x';
        gasMObj.Industry_Code__c= 'P';
        insert gasMObj;   
     
        EON_Gas_Meter_Mechanism__c metMObj = new EON_Gas_Meter_Mechanism__c();
        metMObj.name= 'Mechanism';
        metMObj.Code__c= 'GM';
        insert metMObj;
        
        EON_Gas_Meter_Location__c gasLoc = new EON_Gas_Meter_Location__c();
        gasLoc.name = 'Location';
        gasLoc.Code__c= 'AT';
        insert gasLoc;
            
        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
        insert parType;
    
        system.Test.StartTest();
        //EON_JUMBO_Gas_WebServiceMockImpl.methodType = 'errorResponse';
        //Test.setMock(WebServiceMock.class, new EON_JUMBO_Gas_WebServiceMockImpl());
        EON_JUMBO_Create_GasJob_In_Isis_WS_Test.methodType = 'SuccessMOP';
        EON_JUMBO_Create_GasJob_In_Isis_WS_Test.methodMPRNType = 'FailedMPRN';
        Test.setMock(WebServiceMock.class, new EON_JUMBO_Create_GasJob_In_Isis_WS_Test());
        EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest  request1 = new EON_JUMBO_Create_GasJob_In_Isis_WS.GasWorkRequest();
        request1.MPRN = '1234';
        request1.JUMBOID = '1234';
        request1.RequestTime ='111010';
        request1.EarliestStartTime ='121010' ;
        request1.LatestStartTime = '101010';
        request1.earliestStartDate =  System.today() - 700 ;//System.today();
        request1.JUMBOJobType = 'test Type';  
        EON_JUMBO_Create_GasJob_In_Isis_WS.JumboToIsisGasWorkResponse response2 = EON_JUMBO_Create_GasJob_In_Isis_WS.createGasJobInIsis(request1);   
        system.debug('####Method6: '+response2.Message);
        //System.assert(response2.success == 'FAIL'); 
        system.Test.StopTest();   
    }
    
    
  global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType){
      system.debug('### exe: '+request); 
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
        err.Message = Msg;  
        EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
        resp.Errors = err;
        resp.Success = false;
        EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();    
        obj.RequestgasMeterPointDataResult = resp;
        //response.put('response_x', obj); //CH02.Old
        //CH02.New.Start
        if(methodType == 'SuccessMOP') //CH02.New
            resp.Success = true;       //CH02.New
      	if(methodMPRNType == 'FailedMPRN') //CH02.New
            resp.Success = false;       //CH02.New
        if(request instanceof EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element)
          response.put('response_x', obj);
        if(request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element){
          String[] Msg1 = new String[]{'Message1','Message2','Message3'};
          EON_JUMBO_Work_Management_WS.ErrorList errObj1 = new EON_JUMBO_Work_Management_WS.ErrorList();
          errObj1.Message = Msg1;
          EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
          gasAObj.EffectiveFromDate ='20150423';
          gasAObj.EffectiveToDate='20160823';
          gasAObj.AbbreviatedName='SGL';
          EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[]{gasAObj};
          EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
          aepObj.GasAppointedParty = gasAppobj;
          EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
          empObj.MPRN = 'mprn123';
          empObj.SupplierAppointments = aepObj;
          EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
          respJumbo.Success = true;
          if(methodMPRNType == 'FailedMPRN') //CH02.New
          	 respJumbo.Success = false;      //CH02.New
          respJumbo.MeterPoint=empObj;
          respJumbo.Errors = errObj1;
          EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj1 = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
          obj1.RequestGasSupplierAppointmentsResult = respJumbo;
          response.put('response_x', obj1);
    }
        if(request instanceof  EON_OFSC_Inbound_WS.InboundInterfaceElement){
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
             response.put('response_x', res);
    }
         //CH02.New.End
  }
}