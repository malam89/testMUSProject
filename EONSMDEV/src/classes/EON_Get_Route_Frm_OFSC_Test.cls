/**
    Description : This class is used for test coverage for the below classes
    1.EON_Get_Route_Frm_OFSC    
**/
/*
    Created By : Mahadev J
    Created Date : 24-Oct-2016 
    Service Request : 
*/
@isTest
global class EON_Get_Route_Frm_OFSC_Test implements WebServiceMock{
    public static String methodName;
    public static String ResponseCodeName;
    public static boolean genException;
    public static boolean genLongString = false;
	/**
        PositiveTest() - This is to verify positive response
    **/
    testmethod static void PositiveTest(){
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
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
		Test.setMock(WebServiceMock.class, new EON_Get_Route_Frm_OFSC_Test());
        EON_Get_Route_Frm_OFSC_Test.methodName = 'activity_response';
        EON_Get_Route_Frm_OFSC_Test.ResponseCodeName = '0';
        EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
        EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
        String[] prop;
        EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
        system.assertEquals(0, res.result_code);
        EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
        Test.stopTest();
    }
    /**
        PositiveTest() - This is to verify positive response with too long text in Oracle response
    **/
    testmethod static void PositiveTestWithTooLongText(){
        EON_Get_Route_Frm_OFSC_Test.genLongString = true;
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
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
		Test.setMock(WebServiceMock.class, new EON_Get_Route_Frm_OFSC_Test());
        EON_Get_Route_Frm_OFSC_Test.methodName = 'activity_response';
        EON_Get_Route_Frm_OFSC_Test.ResponseCodeName = '0';
        EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
        EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
        String[] prop;
        EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
        system.assertEquals(0, res.result_code);
        EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
        Test.stopTest();
    }
    
    /**
        PositiveTest1() - This is to verify positive response
    **/
    testmethod static void PositiveTest1(){
        EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
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
        ofscRespCode.Name = '1';
        ofscRespCode.Error_Warning_Success__c = 'Error';
        ofscRespCode.API__c = 'Activity';
        insert ofscRespCode;
        
        EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
        actLst.total =12123;

        Test.startTest();
		Test.setMock(WebServiceMock.class, new EON_Get_Route_Frm_OFSC_Test());
        EON_Get_Route_Frm_OFSC_Test.methodName = 'activity_response';
        EON_Get_Route_Frm_OFSC_Test.ResponseCodeName = '1';
        EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
        EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
        String[] prop;
        EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
        system.assertEquals(1, res.result_code);
        EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
        Test.stopTest();
    }

    /**
		CoverException() : This method will cover exception
	**/
    testmethod static void CoverException(){
        EON_Get_Route_Frm_OFSC_Test.genException = true;
		EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
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
		Test.setMock(WebServiceMock.class, new EON_Get_Route_Frm_OFSC_Test());
        EON_Get_Route_Frm_OFSC_Test.methodName = 'activity_response';
        EON_Get_Route_Frm_OFSC_Test.ResponseCodeName = '0';
        EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
        EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
        String[] prop;
        EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
        system.assertEquals(0, res.result_code);
        EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
        Test.stopTest();        
    }
    /**
		CoverExceptionWithTooLongError() : This method will cover exception with too long message in error
	**/
    testmethod static void CoverExceptionWithTooLongError(){
        EON_Get_Route_Frm_OFSC_Test.genException = true;
        EON_Get_Route_Frm_OFSC_Test.genLongString = true;
		EON_Technician__c eTech = new EON_Technician__c(Name='MORR',ByBox_Locker_ID__c='12345678',Start_Date__c=Date.today(),Mobile__c='9826012345',Email__c='test@MUS.com',Training_Start_Date__c= system.today());
        insert eTech;
        EON_Appointment__c eAppoint = new EON_Appointment__c(Booking_System_Name__c='Test',EON_Appointment_ID__c='Test',Appointment_Date__c=Date.today(),End_Time__c='23:55',Technician__c=eTech.id);
        insert eAppoint;
        EON_Appointment__c queryAppoint = [Select Id ,Name from EON_Appointment__c where ID =: eAppoint.id Limit 1];
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
		Test.setMock(WebServiceMock.class, new EON_Get_Route_Frm_OFSC_Test());
        EON_Get_Route_Frm_OFSC_Test.methodName = 'activity_response';
        EON_Get_Route_Frm_OFSC_Test.ResponseCodeName = '0';
        EON_OFSC_Activity_WS.User_X usr = EON_OFSC_Helper.getUserElementForActivity();
        EON_OFSC_Activity_WS.activity_binding request1 = new EON_OFSC_Activity_WS.activity_binding();
        String[] prop;
        EON_OFSC_Activity_WS.activity_response res = request1.get_route(usr,'Date','RecId',prop, 0, 0);
        system.assertEquals(0, res.result_code);
        EON_InDayUpdate_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_InDayUpdate_In_Isis_WS.AppointmentInDayUpdates(request);
        Test.stopTest();        
    }
    global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,String soapAction,String requestName, String responseNS,String responseName,String responseType){
		if(methodName == 'activity_response'){   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = 'start_time';
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = 'end_time';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='1';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '1';
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'position_in_route';
            property11.value = '2';
            
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8);
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist ; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist ; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            //resp.result_code = 0;
            resp.result_code = Integer.valueOf(ResponseCodeName);
            resp.error_msg = 'test';
            if(genLongString == null)
                genLongString = false;
            if(genLongString)
                resp.error_msg = EON_Utility.getLongText();
            response.put('response_x', resp);
        }	        
    }
}