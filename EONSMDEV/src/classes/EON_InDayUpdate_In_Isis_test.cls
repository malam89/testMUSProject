/**
    Description : This test class is for the following class : EON_InDayUpdate_In_Isis_WS
**/
/*
    Created By : Nitin Bangar
    Created Date : 02/04/2016
    Service Request : SR_EON_AB_017
*/
@istest
private class EON_InDayUpdate_In_Isis_test{
    /**
        AppointmentInDayUpdates_to_Isis_Pass1() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass1(){
        Test.startTest();
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = '12345';
        header.requestId = 'Test';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = 'Test';
        appointDetail.CustomerID = '1234';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
        System.assert(response != null);
        Test.stopTest();
    }
    
    /**
        AppointmentInDayUpdates_to_Isis_Pass2() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass2(){
    Test.startTest();
    EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
    header.orgId = '';
    header.requestId = '';
    header.requestDateTime = null;
    
    EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
    appointDetail.ExternalAppointmentID = '';
    appointDetail.CustomerID = '1234';
    appointDetail.AppointmentDate = system.today();
    
    EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
    request.Header = header;
    request.AppointmentDetails = appointDetail;
    
    EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
    System.assert(response != null);
    Test.stopTest();
    }
    
    /**
        AppointmentInDayUpdates_to_Isis_Pass3() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass3(){
        
        
        
        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        insert eRegion;
        
        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        eSubArea.name='subarea';
        insert eSubArea;
       
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c = 'Test',EON_Appointment_ID__c='trest',Appointment_Date__c=Date.today(),End_Time__c='23:55',Technician__c=eTech.id, start_Time__c='23:59', Time_Slot__c='1212121212113',  SubArea__c= eSubArea.id );
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
          
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
      
      /**
        AppointmentInDayUpdates_to_Isis_Pass4() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass4(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = '';
        //header.requestId = 'X123';
       // header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        //appointDetail.ExternalAppointmentID = queryAppoint.Name;
        //appointDetail.CustomerID = '';
       // appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
     
        
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
    
      /**
        AppointmentInDayUpdates_to_Isis_Pass5() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass5(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55', Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response1';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
    
    
      /**
        AppointmentInDayUpdates_to_Isis_Pass6() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass6(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response2';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
    
    
     /**
        AppointmentInDayUpdates_to_Isis_Pass7() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass7(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113',Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response3';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
       /**
        AppointmentInDayUpdates_to_Isis_Pass8() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass8(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response4';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
    
    
     /**
        AppointmentInDayUpdates_to_Isis_Pass9() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass9(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response5';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
        /**
        AppointmentInDayUpdates_to_Isis_Pass112() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass112(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response6';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
      
        /**
        AppointmentInDayUpdates_to_Isis_Pass11() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass11(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response7';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
    
    
     /**
        AppointmentInDayUpdates_to_Isis_Pass12() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass12(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response8';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
    
    
    
     /**
        AppointmentInDayUpdates_to_Isis_Pass13() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass13(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response8';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
    
    
      /**
        AppointmentInDayUpdates_to_Isis_Pass14() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass14(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response7';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
      
      
      /**
        AppointmentInDayUpdates_to_Isis_Pass15() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass15(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response8';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
      
      
       /**
        AppointmentInDayUpdates_to_Isis_Pass16() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass16(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response9';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
      
        /**
        AppointmentInDayUpdates_to_Isis_Pass17() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass17(){
        
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59',Time_Slot__c='1212121212113', Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response10';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
      
    /**
        AppointmentInDayUpdates_to_Isis_Fail1() - Negative Unit test for the method CancelAppointment, When Error = 'Request Not Found'
    **/
    static testMethod void AppointmentInDayUpdates_to_Isis_Fail1() {          
        test.startTest();
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request ;
        EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
        System.assert(response != null);                                     
        test.stopTest();
    }
    /**
        AppointmentInDayUpdates_to_Isis_Fail2() - Negative Unit test for the method AppointmentInDayUpdates.
    **/
    static testMethod void AppointmentInDayUpdates_to_Isis_Fail2() {          
        test.startTest();
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = '';
        header.requestDateTime = null;
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
        System.assert(response != null);                                     
        test.stopTest();
    }
    
     /**
        AppointmentInDayUpdates_to_Isis_Pass31() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass31(){
        
        
        
        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        insert eRegion;
        
        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        eSubArea.name='subarea';
        insert eSubArea;
       
       
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c = 'Test',EON_Appointment_ID__c='trest',Appointment_Date__c=Date.today(),End_Time__c='23:55',start_Time__c='23:59', Time_Slot__c='1212121212113',  SubArea__c= eSubArea.id );
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
          
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
       /**
        AppointmentInDayUpdates_to_Isis_Pass33() - postitive Unit test for the method AppointmentInDayUpdates
    **/
    static testmethod void AppointmentInDayUpdates_to_Isis_Pass33(){
        
        
        
        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        insert eRegion;
        
        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        eSubArea.name='subarea';
        insert eSubArea;
       
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c = 'Test',EON_Appointment_ID__c='trest',Appointment_Date__c=Date.today(),Technician__c=eTech.id, Time_Slot__c='1212121212113',  SubArea__c= eSubArea.id ,End_Time__c=' ',start_Time__c=' ' );
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
        System.debug('#########'+queryAppoint.Name);
        
        System.debug('appt is===>'+eAppoint.name);
        
        EON_InDayUpdate_In_Isis_WS.HeaderElement header = new EON_InDayUpdate_In_Isis_WS.HeaderElement();
        header.orgId = 'MORR';
        header.requestId = 'X123';
        header.requestDateTime = System.now();
        
        EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_InDayUpdate_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = queryAppoint.Name;
        appointDetail.CustomerID = '';
        appointDetail.AppointmentDate = system.today();
        
        EON_InDayUpdate_In_Isis_WS.InDayUpdate request = new EON_InDayUpdate_In_Isis_WS.InDayUpdate();
        request.Header = header;
        request.AppointmentDetails = appointDetail;
        
        EON_OFSC_Response_Code__c ofscRespCode = new EON_OFSC_Response_Code__c();
        ofscRespCode.Name = '0';
        ofscRespCode.Error_Warning_Success__c = 'Success';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;
        
        
         
        EON_Utility.validateRequired('test');
        
          
       
        Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
            EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
            EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
            EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
            String[] prop;
            EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
            system.assertEquals(0, res.result_code);
            EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
            //System.assert(response != null);
           Test.stopTest();
            
            
         
      }
      
}