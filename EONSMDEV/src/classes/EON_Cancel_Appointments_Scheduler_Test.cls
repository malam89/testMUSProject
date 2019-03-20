/**
    Description : This test class is for the following class : EON_CancelAppointment_In_Isis_WS
**/
/*
    Created By : Praveen Garikipati
    Created Date : 29/03/2017
    Service Request : SR_EON_AB_214

*/
@istest
private class EON_Cancel_Appointments_Scheduler_Test{


    static testmethod void unitTest(){
        EON_Appointment_Cancel_Reason__c reason = new EON_Appointment_Cancel_Reason__c(name ='test name',Reason_key__c = 'x123');
        insert reason;
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Confirmed_Appointment_DateTime__c = null;
        appt.Booking_System_Name__c = 'ICE';
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
        
        String CRON_EXP = '0 00 8-23 * * ?';
        String jobId = System.schedule(System.now()+'cancelSchedule',
                            CRON_EXP, 
                            new EON_Cancel_Appointments_Scheduler());    
        
        System.assert(response != null);
        Test.stopTest();
    }
    
    static testmethod void unitTest1(){
        EON_Appointment_Cancel_Reason__c reason = new EON_Appointment_Cancel_Reason__c(name ='test name',Reason_key__c = 'x123');
        insert reason;
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Confirmed_Appointment_DateTime__c = null;
        appt.Booking_System_Name__c = 'ICE';
        Insert appt;
        Test.startTest();
               
        String CRON_EXP = '0 00 8-23 * * ?';
        String jobId = System.schedule(System.now()+'cancelSchedule',
                            CRON_EXP, 
                            new EON_Cancel_Appointments_Scheduler());    
        
        Test.stopTest();
    }    
}