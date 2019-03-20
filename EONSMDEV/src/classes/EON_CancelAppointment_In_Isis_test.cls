/**
    Description : This test class is for the following class : EON_CancelAppointment_In_Isis_WS
**/
/*
    Created By : Nitin Bangar
    Created Date : 01/04/2016
    Service Request : SR_EON_AB_017
	Change History:
		CH01 # SR_EON_AB_166 # 19-10-2016 # Mahadev J # Improved test coverage
*/
@istest
private class EON_CancelAppointment_In_Isis_test{
    /**
        CancelAppointment_to_Isis_Pass3() - postitive Unit test for the method CancelAppointment
    **/
    static testmethod void CancelAppointment_to_Isis_Pass3(){
    EON_Appointment_Cancel_Reason__c reason = new EON_Appointment_Cancel_Reason__c(name ='test name',Reason_key__c = 'x123');
    insert reason;
    EON_Appointment__c appt = new EON_Appointment__c();
    appt.Cancel_Reason__c = reason.id;
    appt.Cancellation_DateTime__c = System.now();
    Insert appt;
    Test.startTest();
    
    EON_Appointment__c app = [select id,name from EON_Appointment__c where id =: appt.id];
    EON_CancelAppointment_In_Isis_WS.HeaderElement header = new EON_CancelAppointment_In_Isis_WS.HeaderElement();
    header.orgId = '12345';
    header.requestId = 'Test';
    header.requestDateTime = System.now();
    
    EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement();
    appointDetail.ExternalAppointmentID = app.name;
    appointDetail.EONAppointmentID = '12345';
    appointDetail.CancelReasonCode = 'x123';
    appointDetail.CancellationDateTime = System.now();
    
    EON_CancelAppointment_In_Isis_WS.CancelBooking cancelBook = new EON_CancelAppointment_In_Isis_WS.CancelBooking();
    cancelBook.Header = header;
    cancelBook.AppointmentDetails = appointDetail;
    
    EON_CancelAppointment_In_Isis_WS.errMessage msg = new EON_CancelAppointment_In_Isis_WS.errMessage();
    msg.MessageType = 'Test';
    msg.MessageId = 123;
    msg.MessageText = 'Test';
    //
    Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
    EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(app.id);
    //
    EON_CancelAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CancelAppointment_In_Isis_WS.CancelAppointment(cancelBook);
    
    System.assert(response != null);
    Test.stopTest();
    }

    /**
        CancelAppointment_to_Isis_Pass2() - postitive Unit test for the method CancelAppointment
    **/
    static testmethod void CancelAppointment_to_Isis_Pass2(){
    Test.startTest();
    EON_CancelAppointment_In_Isis_WS.HeaderElement header = new EON_CancelAppointment_In_Isis_WS.HeaderElement();
    header.orgId = '';
    header.requestId = '';
    header.requestDateTime = null;
    
    EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement();
    appointDetail.ExternalAppointmentID = '';
    appointDetail.EONAppointmentID = null;
    appointDetail.CancelReasonCode = '';
    appointDetail.CancellationDateTime = null;
    
    EON_CancelAppointment_In_Isis_WS.CancelBooking cancelBook = new EON_CancelAppointment_In_Isis_WS.CancelBooking();
    cancelBook.Header = header;
    cancelBook.AppointmentDetails = appointDetail;
    
    EON_CancelAppointment_In_Isis_WS.errMessage msg = new EON_CancelAppointment_In_Isis_WS.errMessage();
    msg.MessageType = 'Test';
    msg.MessageId = 123;
    msg.MessageText = 'Test';
    
    EON_CancelAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CancelAppointment_In_Isis_WS.CancelAppointment(cancelBook);
    System.assert(response != null);
    Test.stopTest();
    }
    
	/*
    	CancelAppointment_To_Isis_Pass4() - Positive test //CH01
  	*/
    static testmethod void CancelAppointment_to_Isis_Pass4(){
        EON_OFSC_Response_Code__c ofscResp = new EON_OFSC_Response_Code__c();
        ofscResp.Name = '0';
        ofscResp.API__c = 'Inbound';
        insert ofscResp;
        
        EON_Appointment_Cancel_Reason__c reason = new EON_Appointment_Cancel_Reason__c(name ='test name',Reason_key__c = 'x123');
        insert reason;
      
        EON_Appointment__c appt = new EON_Appointment__c();
        insert appt;
        
        EON_Appointment__c app = [select ID, Name, Sent_to_Oracle__c from EON_Appointment__c where id =: appt.id];
        app.Sent_to_Oracle__c = true;
        update app;
        
        EON_Data_tracker__c eTracker = new EON_Data_tracker__c();
        eTracker.Appointment__c = appt.ID;
        insert eTracker;

        EON_CancelAppointment_In_Isis_WS.HeaderElement header = new EON_CancelAppointment_In_Isis_WS.HeaderElement();
        header.orgId = '12345';
        header.requestId = 'Test';
        header.requestDateTime = System.now();
    
        EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = app.name;
        appointDetail.EONAppointmentID = '12345;'+eTracker.ID;
        appointDetail.CancelReasonCode = 'x123';
        appointDetail.CancellationDateTime = System.now();
    
        EON_CancelAppointment_In_Isis_WS.CancelBooking cancelBook = new EON_CancelAppointment_In_Isis_WS.CancelBooking();
        cancelBook.Header = header;
        cancelBook.AppointmentDetails = appointDetail;        

        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_CancelAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CancelAppointment_In_Isis_WS.CancelAppointment(cancelBook);
        System.assert(response != null);
        Test.stopTest();
    }
    
    /*
    	CancelAppointment_To_Isis_Pass5() - Positive test with error in response from Oracle //CH01
  	*/
    static testmethod void CancelAppointment_to_Isis_Pass5(){
        EON_OFSC_Response_Code__c ofscResp = new EON_OFSC_Response_Code__c();
        ofscResp.Name = '1';
        ofscResp.API__c = 'Inbound';
        insert ofscResp;
        
        EON_Appointment_Cancel_Reason__c reason = new EON_Appointment_Cancel_Reason__c(name ='test name',Reason_key__c = 'x123');
        insert reason;
      
        EON_Appointment__c appt = new EON_Appointment__c();
        insert appt;
        
        EON_Appointment__c app = [select ID, Name, Sent_to_Oracle__c from EON_Appointment__c where id =: appt.id];
        app.Sent_to_Oracle__c = true;
        update app;
        
        EON_Data_tracker__c eTracker = new EON_Data_tracker__c();
        eTracker.Appointment__c = appt.ID;
        insert eTracker;

        EON_CancelAppointment_In_Isis_WS.HeaderElement header = new EON_CancelAppointment_In_Isis_WS.HeaderElement();
        header.orgId = '12345';
        header.requestId = 'Test';
        header.requestDateTime = System.now();
    
        EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement();
        appointDetail.ExternalAppointmentID = app.name;
        appointDetail.EONAppointmentID = '12345;'+eTracker.ID;
        appointDetail.CancelReasonCode = 'x123';
        appointDetail.CancellationDateTime = System.now();
    
        EON_CancelAppointment_In_Isis_WS.CancelBooking cancelBook = new EON_CancelAppointment_In_Isis_WS.CancelBooking();
        cancelBook.Header = header;
        cancelBook.AppointmentDetails = appointDetail;        

        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_CancelAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CancelAppointment_In_Isis_WS.CancelAppointment(cancelBook);
        System.assert(response != null);
        Test.stopTest();
    }
    
     /**
        CancelAppointment_to_Isis_Fail1() - Negative Unit test for the method CancelAppointment, When Error = 'Request Not Found'
    **/
    static testMethod void CancelAppointment_to_Isis_Fail1() {          
        test.startTest();
        EON_CancelAppointment_In_Isis_WS.CancelBooking cancelBook ;
        EON_CancelAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CancelAppointment_In_Isis_WS.CancelAppointment(cancelBook);
        System.assert(response != null);                                     
        test.stopTest();
    }
     /**
        CancelAppointment_to_Isis_Fail2() - Negative Unit test for the method CancelAppointment.
    **/
    static testMethod void CancelAppointment_to_Isis_Fail2() {          
        test.startTest();
        EON_CancelAppointment_In_Isis_WS.HeaderElement header = new EON_CancelAppointment_In_Isis_WS.HeaderElement();
        header.orgId = '12345';
        header.requestId = 'Test';
        header.requestDateTime = System.now();
        EON_CancelAppointment_In_Isis_WS.CancelBooking cancelBook = new EON_CancelAppointment_In_Isis_WS.CancelBooking();
        cancelBook.Header = header;
        EON_CancelAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CancelAppointment_In_Isis_WS.CancelAppointment(cancelBook);
        System.assert(response != null);                                     
        test.stopTest();
    }
}