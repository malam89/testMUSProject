/**
    Description : This class is test class for 
**/
/*
    Created By  : Puneet Mehta
    Created On  : 22/03/2017
    Service Req : SR_OptiMUS_NG_006
    Change History
*/
public class NGS_OFSC_MultiReqMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;

    public NGS_OFSC_MultiReqMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        return mock.respond(req);
    }

    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}