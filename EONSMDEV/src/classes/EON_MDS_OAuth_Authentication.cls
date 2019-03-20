/**
    Description : This class is used to generate accessToken for MDS.
    VF Page     : None
    Test Class  : EON_MDS_OAuth_Authentication_Test

**/
/*
    Created By  : Tabish Almas
    Created On  : 18/02/2019
    Service Req : SR_OptiMUS_EON_297
    Change History
*/
public with sharing class EON_MDS_OAuth_Authentication{

    public static MDS_Data_Tracker__c mTrack;
    public static string accessToken = '';
    public static AuthDetail genAccessToken() {
        AuthDetail response = new AuthDetail();
        mTrack = new MDS_Data_Tracker__c();
        mTrack.Direction__c = EON_Utility.DIRECTION_OUT;
        mTrack.Command__c = EON_Utility.CMD_MDS_GenerateToken;
        try{
            Http httpContainer = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint(system.label.EON_MDS_OAuth_EndPoint);
            httpReq.setMethod('POST');
            String loginXML = 'grant_type='+system.label.EON_MDS_Session_GrantType+'&client_id='+system.label.EON_MDS_Session_ClientId+'&client_secret='+system.label.EON_MDS_Session_ClientSecret+'&scope='+system.label.EON_MDS_Session_Scope;
            system.debug('-------------' + loginXML);
            httpReq.setBody(loginXML);
            mTrack.Request_Data__c=string.valueOf(httpReq+'\n'+loginXML); //populating request data
            
            //Sending HTTP Request
            HttpResponse httpResp = httpContainer.send(httpReq);
            system.debug('-------------' + httpResp);
            mTrack.Response_Data__c=string.ValueOf(httpResp.getBody()); //populating response data
            if(httpResp.getStatus() =='OK' && httpResp.getStatusCode()==200){
                JSONParser parser = JSON.createParser(httpResp.getBody());
                while (parser.nextToken() != null){
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')){
                        parser.nextToken();
                        response.accessToken = parser.getText();
                        mTrack.Status__c=EON_Utility.RESULT_PASS;
                    }
                }
            }
            else{
                response.accessToken = 'TokenNotFound';
                response.Error = string.ValueOf(httpResp.getBody()); //populating response data
                mTrack.Response_Data__c=string.ValueOf(httpResp.getBody()); //populating response data
                mTrack.Status__c=EON_Utility.RESULT_FAIL;
                //insert mTrack;
            }
        }
        catch(Exception ex){
            response.accessToken = 'TokenNotFound';
            response.Error = ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber()+'\n';
            mTrack.Response_Data__c=ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber()+'\n'+mTrack.Response_Data__c;
            mTrack.Status__c=EON_Utility.RESULT_FAIL;
            //insert mTrack;
        }
        return response;
    }
    
    // class to Sent back the response
    public class AuthDetail{
        public string accessToken = ''; //Contain Market Participent ID
        public string  Error = '';  //contains the Error Body 
    }
    
}