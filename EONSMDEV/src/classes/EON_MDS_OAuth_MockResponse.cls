@isTest
global class EON_MDS_OAuth_MockResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6ImE2ZjE5MGY1ZDhmYzQ0Njg4ZjFiNDNiNzNkMGM5MjYwIiwidHlwIjoiSldUIn0.eyJuYmYiOjE1NTA0ODgzODksImV4cCI6MTU1MDU3NDc4OSwiaXNzIjoiaHR0cDovL2lkNHRlc3RhLms4c3QubG9jYWwiLCJhdWQiOlsiaHR0cDovL2lkNHRlc3RhLms4c3QubG9jYWwvcmVzb3VyY2VzIiwiTXVzTW9wR2F0ZXdheUFjY2Vzc0FwaSJdLCJjbGllbnRfaWQiOiJNdXNNb3BHYXRld2F5QWNjZXNzIiwic2NvcGUiOlsiTXVzTW9wR2F0ZXdheUFjY2Vzc0FwaVNjb3BlIl19.xuhRecC8QYWnxyU1uzsqcAzzi7b_6gm7HPt09FU0OCv1cE1G0H1FNTpv7wnjYxdXLs-SySGLMql1uqpoCrh_RrToOMoh2IoAwozBKrzL_wBGpvxDC_mGwCzCR6gawittoXQg_qZ8ztVggS58-OMiiSRFSWUgEbhCrMurcGXkRvNTZw4GT_Dp_shGGEGj_SNp-2wE46cUg-Cb6fElEoAnBRymnrj1xbdCM71lRE6SHDod5dsodwAmdw8KsnBg-ujxFXdmyMvoGmAZoMeLhI3XeiuTBcHTglc-ewcHOZ-wGEkIsGD4rAHp8Ft9he-ljULAPewSCDMey-9njEQYWVP2Mw","expires_in":86400,"token_type":"Bearer"}');
        res.setStatus('OK');
        res.setStatusCode(200);
        return res;
    }
}