/**
    Description   : This class is used to insert / update Technician information to OFSC.
**/
/*
    Created By    : Puneet Mehta
    Created On    : 07/03/2017
    Service Req   : SR_OptiMUS_NG_019
    Test class    : 
*/
global with sharing class NGS_OFSC_Technician_Handler{

    public class ResourceDetail{
        public String parentResourceId ='';
        public String resourceType ='';
        public String name ='';
        public String phone ='';
        public String language ='';
        public String timeZone ='';
        public String status ='';
        public String resourceId ='';
        public String XR_Employee_ID ='';
    }

    public class UserDetail{
        public String mainResourceId = '';
        public String password ='';
        public String name ='';
        public String[] resources = new String[]{};
        public String language ='';
        public String timeZone ='';
        public String login ='';
        public String userType ='';
    }

    /**
        sendTechnicianToOFSC() - This method is used to send Technician information to OFSC.
    **/
    webservice static String sendTechnicianToOFSC(String technicianID, Boolean isUpdate){
        List<NGS_Oracle_Data_Tracker__c> oracleTrackers = new List<NGS_Oracle_Data_Tracker__c>();
        String result = '';
        String jsonBody = '';
        String endpointURL = '';
        String httpMethod = '';
        String contentTypeString = 'application/json';
        Boolean isPatch = false;
        Boolean userFlag = false;
        isPatch = isUpdate;
        
        NGS_Technician__c techObj = populateTechnician(technicianID);
        jsonBody = populateResourceDetail(techObj, isUpdate);
        String headerString = '';
        headerString = getHeaderValue();
        httpMethod = 'PUT';
        contentTypeString = '';
        endpointURL = 'https://api.etadirect.com/rest/ofscCore/v1/resources/' + technicianID;
        if(test.isrunningtest()){endpointURL = 'https://api.etadirect.com/rest/ofscCore/v1/resources/';}
        List<String> responseString = new List<String>();
        NGS_Oracle_Data_Tracker__c ngsOdataResObj = new NGS_Oracle_Data_Tracker__c(Request_Data__c = jsonBody,NGS_Technician__c = technicianID, 
                                                                                   Direction__c = 'Out', Command__c = isUpdate ? 'Update Resource' : 'Create Resource');
        responseString = calloutToOFSC(endpointURL, headerString, httpMethod, contentTypeString, jsonBody, isPatch);
        if(responseString != null && responseString.size() > 0){
            ngsOdataResObj.Response_Data__c = responseString[0];
            ngsOdataResObj.Status__c = 'Pass';
            oracleTrackers.add(ngsOdataResObj);
            if(responseString.size() > 1 && responseString[1] == 'RESOURCE INSERTED / UPDATED'){
                if(!techObj.h_oracle_user_created__c && techObj.Active__c){
                    endpointURL = 'https://api.etadirect.com/rest/ofscCore/v1/users/User' + technicianID;
                    if(test.isrunningtest()){endpointURL = 'https://api.etadirect.com/rest/ofscCore/v1/users/User';}
                    jsonBody = populateUserDetail(techObj);
                    NGS_Oracle_Data_Tracker__c ngsOdataUserObj = new NGS_Oracle_Data_Tracker__c(Request_Data__c = jsonBody,NGS_Technician__c = technicianID, 
                                                                                                Direction__c = 'Out', Command__c = 'Create User');
                    responseString = calloutToOFSC(endpointURL, headerString, httpMethod, contentTypeString, jsonBody, false);
                    ngsOdataUserObj.Response_Data__c = responseString[0];
                    ngsOdataUserObj.Status__c = 'Pass';
                    if(responseString.size() > 1 && responseString[1] == 'USER CREATED')
                        userFlag = true;
                    else
                        ngsOdataUserObj.Status__c = 'Fail';
                    oracleTrackers.add(ngsOdataUserObj);
                }
            }
            else{
                ngsOdataResObj.Status__c = 'Fail';
            }
        }
        if(oracleTrackers != null && oracleTrackers.size() > 0)
            insert oracleTrackers;
        update new NGS_Technician__c(id = technicianID, Sent_to_Oracle__c = system.now(), h_oracle_user_created__c = techObj.h_oracle_user_created__c ? true : userFlag);
        return result;
    }
    /**
        populateTechnician() - This method is used to fetch field values of NGS Technician record
    **/
    public static NGS_Technician__c populateTechnician(String technicianID){
        NGS_Technician__c techObj = [select id,Technician_Name__c, Name, First_Name__c, Active__c, Gender__c, Last_Name__c,
                                     Leaving_Date__c, Mobile_Number__c, Start_Date__c, Start_Location__c, h_oracle_user_created__c, Oracle_Bucket_ID__c  
                                     from NGS_Technician__c 
                                     where id =: technicianID];
        return  techObj;
    }
    /**
        populateResourceDetail() - This method return json String
    **/
    public static String populateResourceDetail(NGS_Technician__c techObj, Boolean isUpdate){
        String jsonBody = '';
        resourceDetail resourceObj = new resourceDetail();
        resourceObj.parentResourceId = techObj.Active__c ? techObj.Oracle_Bucket_ID__c : 'DEACTIVATED';
        resourceObj.resourceType = 'TECHNICIAN';
        resourceObj.name = techObj.Technician_Name__c;
        resourceObj.phone = techObj.Mobile_Number__c;
        resourceObj.language = 'en';
        resourceObj.timeZone = '(UTC+00:00) London - Greenwich Mean Time (GMT)';
        resourceObj.status = techObj.Active__c ? 'active' : 'inactive';
        resourceObj.resourceId = techObj.id;
        resourceObj.XR_Employee_ID = techObj.Name;
        jsonBody = json.serialize(resourceObj);
        return jsonBody;                           
    }
    /**
        populateUserDetail() - This method return json String
    **/
    public static String populateUserDetail(NGS_Technician__c techObj){
        String jsonBody = '';
        UserDetail userObj = new UserDetail();
        userObj.mainResourceId = techObj.id;
        userObj.userType = 'TECHNICIAN';
        userObj.name = techObj.Technician_Name__c;
        userObj.resources = new String[]{techObj.id}; 
        userObj.language = 'en';
        userObj.timeZone = '(UTC+00:00) London - Greenwich Mean Time (GMT)';
        userObj.login = 'User' + techObj.id;
        userObj.password = 'Password' + techObj.id;
        jsonBody = json.serialize(userObj);
        
        return jsonBody;                           
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
    public static List<String> calloutToOFSC(String endpointURL, String headerString, String httpMethod, String contentTypeString, String jsonBody, Boolean isPatch){
        List<String> responseString = new List<String>();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        Blob headerValue = Blob.valueOf(headerString);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        if(isPatch)
            req.setHeader('X-HTTP-Method-Override','PATCH');
        req.setHeader('Content-Type', contentTypeString);
        req.setMethod(httpMethod);
        req.setBody(jsonBody);
        HttpResponse res = h.send(req);
        responseString.add(res.getBody());
        JSONParser parser = JSON.createParser(res.getBody());
        if(res.getStatus() == 'Created' && res.getStatusCode() == 201){
            while(parser.nextToken() != null){  
                if(parser.getText() == 'resourceId'){
                    parser.nextValue();
                    responseString.add('RESOURCE INSERTED / UPDATED');
                }
            }
        }
        else if(res.getStatus() == 'OK' && res.getStatusCode() == 200){
            while(parser.nextToken() != null){
                if(parser.getText() == 'resourceId'){
                    parser.nextValue();
                    responseString.add('RESOURCE INSERTED / UPDATED');
                }
                if(parser.getText() == 'mainResourceId'){
                    parser.nextValue();
                    responseString.add('USER CREATED');
                }
            }
        }
        else if(res.getStatus() == 'Bad Request' && res.getStatusCode()== 400){
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