/**
    Description   : This class is used to insert / update Technician information to OFSC.
    Test class    : NGS_S2_WO_Appointment_WS_test, NGS_S4_WO_Appointment_Progress_WS_test
**/
/*
    Created By    : Puneet Mehta
    Created On    : 15/03/2017
    Service Req   : SR_OptiMUS_NG_026
    Change History
    CH01 #SR_OptiMUS_NG_040 #26/04/2017 #Puneet Mehta #Change mapping for streetAddress
    CH02 #SR_OptiMUS_NG_044 #08/05/2017 #Shruti Moghe #Added condition to populate the Service Window based on condition
    CH03 #SR_OptiMUS_NG_050 #15/06/2017 #Puneet Mehta #Reopen related changes
*/
global with sharing class NGS_OFSC_WO_Appointment_Handler{
    public static List<NGS_Oracle_Data_Tracker__c> oracleTrackers = new List<NGS_Oracle_Data_Tracker__c>();
    //CH03
    public class setPositionInRoutes{
        public String position = 'last';
        public Integer activityId;
    }

    public class ActivitiesUpdate1{
        setPositionInRoutes setPositionInRoute;
    }
    //CH03
    public class AppointmentDetail{
        public String resourceId = '';
        public Date strDate = null;
        public String activityType = '';
        public String apptNumber = '';
        public Integer duration = 0;
        public String language = '';
        public String timeZone = '';
        public String postalCode = '';
        public String city = '';
        public String serviceWindowEnd = '';
        public String serviceWindowStart = '';
        public String streetAddress = '';
        public Datetime timeofBooking = null;
        public String XA_NG_Work_Order_Number = '';
        public String XA_Address_Line_2 = '';
        public String XA_Note_Type = '';
        public String XA_Note = '';
        public Integer XA_Assignment_Locked=0;
    }
    public class Parameters{
        public String identifyActivityBy = '';
        public String ifInFinalStatusThen = '';
    }
    public class ActivitiesUpdate{
        Parameters updateParameters;
        List<AppointmentDetail> activities = new List<AppointmentDetail>();
    }
    /**
        sendActivityToOFSC() - This method is used to send WO Appointment / Activity information to OFSC.
    **/
    webservice static String sendActivityToOFSC(String woApptID, Boolean isUpdate, Boolean isReopen){//CH03
        String result = '';
        String jsonBody = '';
        String endpointURL = '';
        String httpMethod = '';
        String contentTypeString = 'application/json';

        NGS_Work_Order_Appointment__c appointmentObj = populateAppointment(woApptID);
        if(isReopen){
            jsonBody = populateReopenAppt(appointmentObj);
            endpointURL = System.Label.NGS_OFSC_URL + '/ofscCore/v1/activities/'+appointmentObj.Oracle_Activity_ID__c+'/custom-actions/reopen';
        }//CH03
        else{
            NGS_Note__c noteObj = populateNote(woApptID);
            NGS_Task__c taskObj = populateTask(woApptID);
            jsonBody = populateAppointmentDetail(appointmentObj, noteObj, taskObj, isUpdate);
            endpointURL = System.Label.NGS_OFSC_URL + '/ofscCore/v1/activities/custom-actions/bulkUpdate';
        }
        String headerString = '';
        headerString = getHeaderValue();
        httpMethod = 'POST';
        contentTypeString = 'application/json';
        List<String> responseString = new List<String>();
        NGS_Oracle_Data_Tracker__c ngsOdataActivityObj = new NGS_Oracle_Data_Tracker__c(Request_Data__c = jsonBody,Works_Order__c = woApptID, 
                                                                                        Direction__c = 'Out', Command__c = isUpdate ? 'Update Activity' : 'Create Activity');
        if(isReopen)
            ngsOdataActivityObj.Command__c = 'Reopen activity';//CH03
        responseString = calloutToOFSC(endpointURL, headerString, httpMethod, contentTypeString, jsonBody, isReopen);
        ngsOdataActivityObj.Status__c = 'Fail';
        if(responseString != null && responseString.size() > 0){
            ngsOdataActivityObj.Response_Data__c = responseString[0];
            if(responseString.size() > 1 && (responseString[1] == 'SUCCESS')){
                ngsOdataActivityObj.Status__c = 'Pass';
                result = responseString[1];
            }
            else{
                ngsOdataActivityObj.Status__c = 'Fail';
            }
        }
        
        oracleTrackers.add(ngsOdataActivityObj);
        SYSTEM.DEBUG('PUNEET----' + oracleTrackers);
        if(result == 'SUCCESS'){
            Utility.ByPassOFSCUpdate = false;//To resolve Update activity issue
            if(isReopen){
                SYSTEM.DEBUG('PUNEET---- 2');
                sendActivityUpdateToOFSC(woApptID);//CH04
            }
            SYSTEM.DEBUG('PUNEET---- 3');
            update new NGS_Work_Order_Appointment__c(id = woApptID, Oracle_Activity_ID__c = responseString[2]);
        }
        SYSTEM.DEBUG('PUNEET----' + oracleTrackers);
        if(test.isrunningtest()) Upsert oracleTrackers;   
        else insert oracleTrackers;       
        return result;
    }
    /**
        sendActivityUpdateToOFSC() - This method is used to send WO Appointment / Activity information to OFSC.
    **/
    webservice static void sendActivityUpdateToOFSC(String woApptID){//CH04
        String result = '';
        String jsonBody = '';
        String endpointURL = '';
        String httpMethod = '';
        String contentTypeString = 'application/json';

        NGS_Work_Order_Appointment__c appointmentObj = populateAppointment(woApptID);
        NGS_Note__c noteObj = populateNote(woApptID);
        NGS_Task__c taskObj = populateTask(woApptID);
        jsonBody = populateAppointmentDetail(appointmentObj, noteObj, taskObj, true);
        endpointURL = System.Label.NGS_OFSC_URL + '/ofscCore/v1/activities/custom-actions/bulkUpdate';
        String headerString = '';
        headerString = getHeaderValue();
        httpMethod = 'POST';
        contentTypeString = 'application/json';
        List<String> responseString = new List<String>();
        NGS_Oracle_Data_Tracker__c ngsOdataActivityObj = new NGS_Oracle_Data_Tracker__c(Request_Data__c = jsonBody,Works_Order__c = woApptID, 
                                                                                        Direction__c = 'Out', Command__c = 'Update Activity');
        responseString = calloutToOFSC(endpointURL, headerString, httpMethod, contentTypeString, jsonBody, false);
        ngsOdataActivityObj.Status__c = 'Fail';
        if(responseString != null && responseString.size() > 0){
            ngsOdataActivityObj.Response_Data__c = responseString[0];
            if(responseString.size() > 1 && (responseString[1] == 'SUCCESS')){
                ngsOdataActivityObj.Status__c = 'Pass';
                result = responseString[1];
            }
            else{
                ngsOdataActivityObj.Status__c = 'Fail';
            }
        }
        oracleTrackers.add(ngsOdataActivityObj);
        SYSTEM.DEBUG('PUNEET----' + oracleTrackers);
    }
    /**
        populateTask() - This method is used to fetch field values of NGS Task record
    **/
    public static NGS_Task__c populateTask(String woApptID){
        List<NGS_Task__c> taskObjLst = [select id,Job_Description__c, Job_ID__c, Job_ID__r.Priority__c, Work_Order_Number__c, Job_ID__r.name 
                                               from NGS_Task__c 
                                               where Work_Order_Number__c =: woApptID order by Job_ID__r.name];
        NGS_Task__c taskObj = null;
        if(taskObjLst != null && taskObjLst.size() > 0){
            if(taskObjLst.size() == 1){
                taskObj = taskObjLst[0];
                return taskObj;
            }
            for(NGS_Task__c ngsTask : taskObjLst){
                if(ngsTask.Job_ID__r.Priority__c){
                    taskObj = ngsTask; 
                    break;
                }
            }
            if(taskObj == null)
                taskObj = taskObjLst[0];
        }
        return taskObj;
    }
    /**
        populateNote() - This method is used to fetch field values of NGS Note record
    **/
    public static NGS_Note__c populateNote(String woApptID){
        NGS_Note__c noteObj = null;
        List<NGS_Note__c> noteLst = [select id,Note__c, Note_Type__c, Work_Order_Number__c 
                                     from NGS_Note__c 
                                     where Work_Order_Number__c =: woApptID limit 1];
        if(noteLst != null && noteLst.size() > 0)
            noteObj = noteLst[0];
        return noteObj;
    }
    /**
        populateAppointment() - This method is used to fetch field values of NGS Work Order Appointment record
    **/
    public static NGS_Work_Order_Appointment__c populateAppointment(String woApptID){
        NGS_Work_Order_Appointment__c appointmentObj = [select id,Duration__c, Employee_ID__c, Appointment_Start_Time__c, Name, Post_Code__c, City__c, Appointment_Finish_Time__c,Assignment_sent_to_IFS__c,
                                     Address_Line_1__c, Address_Line_2__c, Message_Date__c, Oracle_Bucket_ID__c, Oracle_Activity_ID__c 
                                     from NGS_Work_Order_Appointment__c 
                                     where id =: woApptID];//CH02
        return  appointmentObj;
    }
    //CH03
    /**
        populateReopenAppt() - This method return json String
    **/
    public static String populateReopenAppt(NGS_Work_Order_Appointment__c appointmentObj){
        String jsonBody = '';
        ActivitiesUpdate1 activityUpdate = new ActivitiesUpdate1();
        setPositionInRoutes setPositionInRouteObj = new setPositionInRoutes();
        setPositionInRouteObj.position = 'last';
        setPositionInRouteObj.activityId = Integer.valueOf(appointmentObj.Oracle_Activity_ID__c);
        activityUpdate.setPositionInRoute = setPositionInRouteObj;
        jsonBody = json.serialize(activityUpdate);
        return jsonBody;
    }
    //CH03
    /**
        populateAppointmentDetail() - This method return json String
    **/
    public static String populateAppointmentDetail(NGS_Work_Order_Appointment__c appointmentObj, NGS_Note__c noteObj, NGS_Task__c taskObj, Boolean isUpdate){
        String jsonBody = '';
        AppointmentDetail appointmentDetailObj = new AppointmentDetail();
        if(appointmentObj.Employee_ID__c == null)
            appointmentDetailObj.resourceId = appointmentObj.Oracle_Bucket_ID__c;
        else
            appointmentDetailObj.resourceId = appointmentObj.Employee_ID__c;
        appointmentDetailObj.strDate = date.newinstance(appointmentObj.Appointment_Start_Time__c.year(), appointmentObj.Appointment_Start_Time__c.month(), appointmentObj.Appointment_Start_Time__c.day());
        if(taskObj != null)
            appointmentDetailObj.activityType = taskObj.Job_ID__r.name;       
        appointmentDetailObj.apptNumber = appointmentObj.id;
        if(appointmentObj.Duration__c != null && appointmentObj.Duration__c != '' && appointmentObj.Duration__c.contains(':')){
            Integer hrPart = 0;
            Integer minPart = 0;
            hrPart = Integer.valueOf(appointmentObj.Duration__c.subStringBefore(':')) * 60;
            minPart = Integer.valueOf(appointmentObj.Duration__c.subStringAfter(':'));
            appointmentDetailObj.duration = hrPart + minPart;
        }
        appointmentDetailObj.language = 'en';
        appointmentDetailObj.timeZone = '(UTC+00:00) London - Greenwich Mean Time (GMT)';
        appointmentDetailObj.postalCode = appointmentObj.Post_Code__c;
        appointmentDetailObj.city = appointmentObj.City__c;
        if(appointmentObj.Assignment_sent_to_IFS__c==null && NGS_S3_Send_WO_Assignment_to_IFS.assigned==false){//CH02.start
            appointmentDetailObj.serviceWindowEnd = appointmentObj.Appointment_Finish_Time__c.format('HH:mm:ss');
            appointmentDetailObj.serviceWindowStart = appointmentObj.Appointment_Start_Time__c.format('HH:mm:ss');
        }//CH02.end 
        //CH01.START
        if(appointmentObj.Address_Line_2__c != null && appointmentObj.Address_Line_2__c != '')
            appointmentDetailObj.streetAddress = appointmentObj.Address_Line_1__c + ' ' + appointmentObj.Address_Line_2__c;
        else
            appointmentDetailObj.streetAddress = appointmentObj.Address_Line_1__c;
        //CH01.END
        appointmentDetailObj.timeofBooking = appointmentObj.Message_Date__c;
        appointmentDetailObj.XA_NG_Work_Order_Number = appointmentObj.name;
        appointmentDetailObj.XA_Address_Line_2 = '';
        appointmentDetailObj.XA_Assignment_Locked =appointmentObj.Assignment_sent_to_IFS__c==null ? 0 : 1 ;//CH02
        if(NGS_S3_Send_WO_Assignment_to_IFS.assigned) appointmentDetailObj.XA_Assignment_Locked = 1;
        if(noteObj != null){
            appointmentDetailObj.XA_Note = noteObj.Note__c;
            appointmentDetailObj.XA_Note_Type = noteObj.Note_Type__c;
        }
        List<AppointmentDetail> activitiesLst = new List<AppointmentDetail>();
        activitiesLst.add(appointmentDetailObj);

        ActivitiesUpdate activityUpdate = new ActivitiesUpdate();
        Parameters paramInst = new Parameters();
        paramInst.identifyActivityBy = 'apptNumber';
        paramInst.ifInFinalStatusThen = 'doNothing';

        activityUpdate.updateParameters = paramInst;
        activityUpdate.activities = activitiesLst;

        jsonBody = json.serialize(activityUpdate);
        jsonBody = jsonBody.replace('strDate','date');
        if(NGS_S3_Send_WO_Assignment_to_IFS.assigned)//CH02
        jsonBody = jsonBody.replace(',"serviceWindowStart":"","serviceWindowEnd":""','');//CH02
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
    public static List<String> calloutToOFSC(String endpointURL, String headerString, String httpMethod, String contentTypeString, String jsonBody, Boolean isReopen){//CH03
        List<String> responseString = new List<String>();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        Blob headerValue = Blob.valueOf(headerString);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Content-Length', String.valueOf(jsonBody.length()));
        req.setMethod(httpMethod);
        req.setTimeout(120000);
        req.setBody(jsonBody);
        HttpResponse res = h.send(req);
        responseString.add(res.getBody());
        JSONParser parser = JSON.createParser(res.getBody());
        if(res.getStatus() == 'OK' && res.getStatusCode() == 200){
            while(parser.nextToken() != null){
                if(parser.getText() == 'errors'){
                    parser.nextValue();
                    responseString.add(parser.getText());
                    return responseString;
                }
                if(parser.getText() == 'activityId'){
                    parser.nextValue();
                    responseString.add('SUCCESS');
                    responseString.add(parser.getText());
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