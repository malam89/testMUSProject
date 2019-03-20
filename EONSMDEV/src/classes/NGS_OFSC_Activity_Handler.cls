/**
    Description   : This class is used to insert / update Technician information to OFSC.
    Test class    : NGS_S4_WO_Appointment_Progress_WS_test
**/
/*
    Created By    : Puneet Mehta
    Created On    : 15/03/2017
    Service Req   : SR_OptiMUS_NG_026
*/
global with sharing class NGS_OFSC_Activity_Handler{
     public static NGS_Oracle_Data_Tracker__c oracleTracker;
    
     public class AppointmentDetail{
        public String activityId = '';
    }
    public class Parameters{
        public String identifyActivityBy = '';
        public String ifInFinalStatusThen = '';
    }
    public class ActivitiesUpdate{
        Parameters updateParameters;
        List<AppointmentDetail> activities = new List<AppointmentDetail>();
    }
    
    public List<String> manageActivity(String subject, String resourceIdStr, String activityIdStr){
        String result = '';
        String jsonBody = '{"time": "' + utility.getNewdatetimeAdd(system.now()) + '"}';
        String endpointURL = SYstem.label.NGS_OFSC_URL + '/ofscCore/v1/';
        String httpMethod = 'POST';
        String contentTypeString = 'application/json';
        List<String> responseString = new List<String>();
        oracleTracker = new NGS_Oracle_Data_Tracker__c(NGS_Technician__c = resourceIdStr,Direction__c = 'Out');
        if(subject == 'activate'){
            endpointURL = endpointURL + 'resources/'+resourceIdStr+'/routes/'+system.today()+'/custom-actions/activate';
            if(endpointURL.contains(' 00:00:00'))
               endpointURL =  endpointURL.replace(' 00:00:00', '');
            oracleTracker.Command__c = 'Activate Resource';
        }
        else if(subject == 'started'){
            endpointURL = endpointURL + 'activities/'+activityIdStr+'/custom-actions/start';
            oracleTracker.Command__c = 'Start Activity';
        }
        else if(subject == 'completed'){
            endpointURL = endpointURL + 'activities/'+activityIdStr+'/custom-actions/complete';
            oracleTracker.Command__c = 'Complete activity';
        }
        else if(subject == 'cancelled'){
            endpointURL = endpointURL + 'activities/'+activityIdStr+'/custom-actions/cancel';
            AppointmentDetail appointmentDetailObj = new AppointmentDetail();
            appointmentDetailObj.activityId = activityIdStr;
            List<AppointmentDetail> activitiesLst = new List<AppointmentDetail>();
            activitiesLst.add(appointmentDetailObj);
            
            ActivitiesUpdate activityUpdate = new ActivitiesUpdate();
            Parameters paramInst = new Parameters();
            paramInst.identifyActivityBy = 'apptNumber';
            paramInst.ifInFinalStatusThen = 'doNothing';

            activityUpdate.updateParameters = paramInst;
            activityUpdate.activities = activitiesLst;

            jsonBody = json.serialize(activityUpdate);
            oracleTracker.Command__c = 'Cancel activity';
        }
        oracleTracker.Request_Data__c = jsonBody;
        responseString = calloutToOFSC(endpointURL, httpMethod, jsonBody, contentTypeString, subject);
        return responseString;
    }
    
    /**
        getHeaderValue() - This method return 
    **/
    public static String getHeaderValue(){
        String headerString = '';
        headerString = System.Label.NGS_OFSC_API_USER + '@' + System.Label.NGS_OFSC_COMPANY + ':' + System.Label.NGS_OFSC_API_PASSWORD;
        return headerString;                           
    }
    /**
        calloutToOFSC() - This method return 
    **/
    public static List<String> calloutToOFSC(String endpointURL, String httpMethod, String jsonBody, String contentTypeString, String subject){
        String headerString = '';
        headerString = getHeaderValue();
        List<String> responseString = new List<String>();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        Blob headerValue = Blob.valueOf(headerString);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', contentTypeString);
        req.setMethod(httpMethod);
        req.setTimeout(120000);
        req.setBody(jsonBody);
        HttpResponse res = h.send(req);
        responseString.add(res.getBody());
        JSONParser parser = JSON.createParser(res.getBody());
        if(res.getStatus() == 'No Content' && res.getStatusCode() == 204 && subject == 'activate'){
            responseString.add('SUCCESS');
        }
        else if(res.getStatus() == 'OK' && res.getStatusCode() == 200){
            while(parser.nextToken() != null){
                if(parser.getText() == 'activityId'){
                    parser.nextValue();
                    responseString.add('SUCCESS');
                }
            }
        }
        else if((res.getStatus() == 'Bad Request' && res.getStatusCode()== 400) || (res.getStatus() == 'Conflict' && res.getStatusCode()== 409)){
            while(parser.nextToken() != null){
                if(parser.getText() == 'detail'){
                    parser.nextValue();
                    responseString.add(parser.getText());
                }
            }
        }
        else{
            
            responseString.add(res.getStatus());
        }
        return responseString;
    }
}