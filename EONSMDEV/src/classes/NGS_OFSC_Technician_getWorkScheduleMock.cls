@isTest
global class NGS_OFSC_Technician_getWorkScheduleMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('Success');
    return res;
  }
}