/**
Description : This test class will provide mock response for callouts in below classes
              1.EON_Appointment_SMS_Sender_Scheduler
              2.EON_Appointment_SMS_Sender_Helper
              
**/
/*
    Created By  : Aruna Manjari
    Created On  : 28/04/2016
    Service Req : 
    Change History
*/
@isTest
global class EON_Appointment_SMS_Scheduler_MockRes implements HttpCalloutMock {
   
   
     // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        String resp = '<?xml version="1.0" encoding="utf-8"?><SendExtendedMessage_Response xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="https://www.emsoap.net"><result>SUCCESS</result><Delivery_Item><PendingRef>142113150</PendingRef><Status>DELIVERED</Status></Delivery_Item><Message_Status><MessageStatus><MessageID>142113150</MessageID> <Mobile>919158433601</Mobile><result>SUBMITTED</result></MessageStatus></Message_Status></SendExtendedMessage_Response>';
        HttpResponse res = new HttpResponse();        
        res.setBody(resp);
        res.setStatus('OK');
        res.setStatusCode(200);
        return res;
    }
}