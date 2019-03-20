/*
      Created By    : venkat Pattapu
      class         :NGS_OFSC_Technician_Handler
      testclass     :NGS_OFSC_Technician_Handler_test
      
*/

@isTest                       
global class Ngs_Ofsc_Technician_Mock3 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"type": "http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.4.10","title" : "Conflict","status": "400","detail": "Trying to add activity to inactive resource"}');
        //res.setBody('{ "mainResourceId": "a1i3E00000014VBQAY", "mainResourceInternalId": 50, "resourceInternalIds": [ 50 ], "name": "Technician LastName", "status": "active", "login": "Usera1i3E00000014VBQAY", "passwordTemporary": false, "selfAssignment": false, "language": "en", "dateFormat": "dd/mm/yy", "longDateFormat": "weekday day month year", "timeFormat": "24-hour", "timeZoneDiff": 0, "timeZone": "(UTC+00:00) London - Greenwich Mean Time (GMT)", "createdTime": "2017-03-14 15:01:23", "lastUpdatedTime": "2017-03-14 15:01:23", "lastPasswordChangeTime": "2017-03-14 15:01:23", "userType": "TECHNICIAN", "resources": [ "a1i3E00000014VBQAY" ], "collaborationGroups": { "links": [ { "rel": "canonical", "href": "https://api.etadirect.com/rest/ofscCore/v1/users/Usera1i3E00000014VBQAY/collaborationGroups" } ] }, "links": [ { "rel": "canonical", "href": "https://api.etadirect.com/rest/ofscCore/v1/users/Usera1i3E00000014VBQAY" }, { "rel": "describedby", "href": "https://api.etadirect.com/rest/ofscCore/v1/metadata-catalog/users#definitions/user" } ] }');
        res.setStatusCode(201);
        res.setStatus('Created');
        
        res.setStatusCode(201);
        return res;
   
   }
     public static HttpResponse getInfoFromExternalService() {
       
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.etadirect.com/rest/ofscCore/v1/users/User');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
      


}