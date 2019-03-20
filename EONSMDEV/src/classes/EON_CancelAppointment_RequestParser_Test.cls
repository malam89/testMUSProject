/**
    Description : This test class covers the code coverage for below class
        1. EON_CancelAppointment_RequestParser
**/
/*
    Created By : Mahadev J
    Created Date : 17-Oct-2016
    Service Request : SR_EON_AB_166
    Change History :  
*/

@isTest
private class EON_CancelAppointment_RequestParser_Test {
    static testMethod void SuccessTest(){
        EON_Appointment__c appt = new EON_Appointment__c();
        insert appt;
        
    	EON_CancelAppointment_In_Isis_WS.HeaderElement header = new EON_CancelAppointment_In_Isis_WS.HeaderElement();
        header.orgId = '12345';
        header.requestId = 'Test';
        header.requestDateTime = System.now();
    
    	EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement appointDetail = new EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement();
    	appointDetail.ExternalAppointmentID = 'Test';
    	appointDetail.EONAppointmentID = '12345';
    	appointDetail.CancelReasonCode = 'cancel reasoon code test';
    	appointDetail.CancellationDateTime = System.now();
    
    	EON_CancelAppointment_In_Isis_WS.CancelBooking cancelBook = new EON_CancelAppointment_In_Isis_WS.CancelBooking();
    	cancelBook.Header = header;
    	cancelBook.AppointmentDetails = appointDetail; 
        
        EON_Data_Tracker__c eTracker = new EON_Data_Tracker__c();
        eTracker.Pending_Cancellation_at_Oracle__c = true;
        eTracker.h_JSON_Request_Data__c = JSON.serialize(cancelBook);
        eTracker.Appointment__c = appt.ID;
        insert eTracker;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.startTest();
        EON_CancelAppointment_RequestParser.processCancelRequest(appt.ID);
        test.stopTest();
    }
}