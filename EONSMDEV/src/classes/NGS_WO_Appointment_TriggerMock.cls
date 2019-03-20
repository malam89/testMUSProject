/*
      Created By    : venkat Pattapu
      class         :NGS_WO_Appointment_TriggerHandler
      testclass     :
      
*/

@isTest                       
global class NGS_WO_Appointment_TriggerMock implements HttpCalloutMock {
    global static boolean booleancheck = false;
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
       // res.setBody('{"type": "http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4.10","title" : "Conflict","status": "400","detail": "Trying to add activity to inactive resource"}');
       if(booleancheck==false)
        res.setBody('{"updateParameters":{"ifInFinalStatusThen":"doNothing","identifyActivityBy":"apptNumber"},"activities":[{"XA_Note_Type":"","XA_Note":"","XA_NG_Work_Order_Number":"4035505","XA_Address_Line_2":"TEMPLE HILL SQUARE","timeZone":"(UTC+00:00) London - Greenwich Mean Time (GMT)","timeofBooking":"2017-04-20T16:46:21.000Z","streetAddress":"32","date":"2017-04-27","serviceWindowStart":"08:00:00","serviceWindowEnd":"12:00:00","resourceId":"SB_004","postalCode":"SG1 2ST","language":"en","duration":75,"city":"KENT","apptNumber":"a1j3E000000UwduQAC","activityType":"EXCRE_DSP02"}]}');
        else res.setBody('');
        res.setStatus('OK'); 
        res.setStatusCode(201);
      
        return res;
   
   }
  /*  public static HttpResponse getInfoFromExternalService() {
       
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.etadirect.com/rest/ofscCore/v1/users/User');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }*/
      

}