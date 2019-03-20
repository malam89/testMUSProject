/**
    Description : This class used to generate WSDL. It is used for S2 webservice to receive request from IFS.
    Test Class  : NGS_S2_WO_Appointment_WS_test
**/
/*
    Created By : Puneet Mehta
    Created Date : 09/02/2017
    Service Request : SR_OptiMUS_NG_010
    Change History:
    CH01 : 17/05/2017 # SR_OptiMUS_NG_046 # Puneet Mehta # Changed hte process for when CHANGE_TYPE = NEW and Cancelled is NOT null
    CH02 : 16/06/2017 # SR_OptiMUS_NG_051 # Shruti Moghe # Added condition for rejected appointment logic
    CH03 : 26/09/2017 # SR_OptiMUS_NG_054 # Puneet Mehta # Added condition for incrmenting Rescheduled
*/
global with sharing class NGS_S2_WO_Appointment_WS{
    
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class JobsElement{  
        webservice JobElement[] Job;
    }
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class JobElement{  
        webservice String WORK_ORDER_NUMBER;
        webservice String JOB_ID;
        webservice String JOB_DESCRIPTION;
    }
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class NotesElement{  
        webservice NoteElement[] Note;
    }
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class NoteElement{  
        webservice String WORK_ORDER_NUMBER;
        webservice String NOTE_TYPE;
        webservice String NOTE_TEXT;
    }
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class LocationsElement{  
        webservice LocationElement Location;
    }
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class LocationElement{
        webservice String  WORK_ORDER_NUMBER;
        webservice String  ADDR_LINE_1;
        webservice String  ADDR_LINE_2;
        webservice String  CITY;
        webservice String  COUNTY;
        webservice String  POST_CODE;
        webservice String  COUNTRY;
        webservice Decimal LATITUDE;
        webservice Decimal LONGITUDE;
    }
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class ActivitiesElement{  
        webservice ActivityElement Activity;
    }
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class ActivityElement{  
        webservice String   WORK_ORDER_NUMBER;
        webservice String   CHANGE_TYPE;
        webservice datetime APPT_START_TIME;
        webservice datetime APPT_FINISH_TIME;
        webservice String   APPOINTMENT_TYPE;
        webservice datetime MESSAGE_DATE;
        webservice String   MPAN;
        webservice String   MPRN;
        webservice String   DURATION;
        webservice String   SERVICE_PROVIDER;
    }
    /**
        Description : Request Parameter
    **/
    global with sharing class WORK_ORDER_APPOINTMENT{
        webservice ActivitiesElement Activities;
        webservice LocationsElement  Locations;
        webservice NotesElement      Notes;
        webservice JobsElement       Jobs;
    }
    /**
        Description : Response
    **/
    global with sharing class S2_WORK_ORDER_APPOINTMENTResponse {
        webservice String result;
    }

    /**
        S2_webservice_WOR_ORDER_APPOINTMENT_Binder_S2_WORK_ORDER_APPOINTMENT() : Receives the request from IFS and process it in OptiMUS
        @return S2_WORK_ORDER_APPOINTMENTResponse   Returns response back to IFS.
    **/
    webservice static S2_WORK_ORDER_APPOINTMENTResponse S2_webservice_WOR_ORDER_APPOINTMENT_Binder_S2_WORK_ORDER_APPOINTMENT(WORK_ORDER_APPOINTMENT Request){
        S2_WORK_ORDER_APPOINTMENTResponse response = new S2_WORK_ORDER_APPOINTMENTResponse ();
        IFS_Data_Tracker__c ifsDataTrackerObj = new IFS_Data_Tracker__c();
        ifsDataTrackerObj.Direction__c = 'IN';
        ifsDataTrackerObj.Command__c = 'S2 SEND WO APPOINTMENT';
        ifsDataTrackerObj.Request_Data__c = '';
        List<NGS_Task__c> ngsTaskLst      = new List <NGS_Task__c>();
        List<NGS_Postcode__c> ngsPostCode = new List <NGS_Postcode__c>();
        List <NGS_Note__c> ngsNoteLst     = new List <NGS_Note__c>();
        Map<id,NGS_Job_Code__c> ngsJobCodeMap = new Map<id,NGS_Job_Code__c>();
        Map<String,NGS_Job_Code__c> ngsJobStringCodeMap = new Map<String,NGS_Job_Code__c>();
        response.result = '';
        Boolean isMaintenance    = false;
        Boolean isECO            = false;
        Boolean isSmart          = false;
        Boolean isNewConnections = false;
        Boolean isDefault        = false;
        Boolean isRejectedMpan   = false;//CH03
        try{
            if(Request != null){//check if the request received from IFS is not blank
                ifsDataTrackerObj.Request_Data__c = EON_Utility.validateStringLength(Request + '\n');
                if(Request.Activities == null){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Activities is missing.';}
                else if(Request.Activities.Activity == null){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Activity is missing.';}
                else if(Request.Activities.Activity.WORK_ORDER_NUMBER == null || Request.Activities.Activity.WORK_ORDER_NUMBER == ''){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'WORK_ORDER_NUMBER is missing in Activity';}
                else if(Request.Locations == null){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Locations is missing.';}
                else if(Request.Locations.Location == null){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Location is missing.';}
                else if(Request.Locations.Location.WORK_ORDER_NUMBER == null  || Request.Locations.Location.WORK_ORDER_NUMBER == ''){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'WORK_ORDER_NUMBER is missing in Location';}
                else if(Request.Locations.Location.WORK_ORDER_NUMBER != Request.Activities.Activity.WORK_ORDER_NUMBER){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'WORK_ORDER_NUMBER should be same';}
                else if(Request.Locations.Location.POST_CODE == null  || Request.Locations.Location.POST_CODE == ''){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'POST_CODE is missing in Location';}
                else if(EON_Utility.validateRequired(Request.Activities.Activity.CHANGE_TYPE)){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Mandatory fields are missing: CHANGE_TYPE';}
                else if(EON_Utility.validateRequired(Request.Activities.Activity.SERVICE_PROVIDER)){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Mandatory fields are missing: SERVICE_PROVIDER';}
                else if(Request.Activities.Activity.SERVICE_PROVIDER != 'SP02'){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Expected Service Provider is SP02';}
                else{
                    if(Request.Activities.Activity.CHANGE_TYPE.toUpperCase() != 'NEW' && Request.Activities.Activity.CHANGE_TYPE.toUpperCase() != 'UPDATE'){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Expected CHANGE_TYPE is NEW or UPDATE';}
                    else if(Request.Activities.Activity.CHANGE_TYPE.toUpperCase() == 'NEW'){
                        String vWOoApptNumber  = '';
                        vWOoApptNumber = Request.Activities.Activity.WORK_ORDER_NUMBER.trim();
                        List<NGS_Work_Order_Appointment__c> woApptLst = [select id, Name,Cancelled__c,Rescheduled__c,Rejected__c,MPAN__c from NGS_Work_Order_Appointment__c where name = :vWOoApptNumber];
                        if(woApptLst != null & woApptLst.size() > 0 && woApptLst[0].Cancelled__c==null){ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Work Order Already Exists';}//CH01
                        else{//CH01
                            NGS_Work_Order_Appointment__c ngsWOappt = new NGS_Work_Order_Appointment__c(name = Request.Activities.Activity.WORK_ORDER_NUMBER);
                            if(woApptLst != null & woApptLst.size() > 0){
                                ngsWOappt.id= woApptLst[0].id;
                                ngsWOappt.Employee_ID__c=null;
                                ngsWOappt.Cancelled__c=null;
                                //ngsWOappt.MUS_Rejection_Notes__c=null;//CH03
                                ngsWOappt.Assignment_sent_to_IFS__c=null;
                                ngsWOappt.h_IFS_Duration__c='';
                                if(woApptLst[0].Rejected__c != null && woApptLst[0].MPAN__c == Request.Activities.Activity.MPAN){isRejectedMpan = true;}//CH03
                            }
                            //ngsWOappt.Appointment_Start_Time__c = Utility.getNewdatetime(Request.Activities.Activity.APPT_START_TIME);
                            ngsWOappt.Appointment_Finish_Time__c = Utility.getNewdatetime(Request.Activities.Activity.APPT_FINISH_TIME);
                             ngsWOappt.Appointment_Start_Time__c = Utility.getNewdatetime(Request.Activities.Activity.APPT_START_TIME);
                           System.debug('DateIssue---'+ngsWOappt.Appointment_Start_Time__c);
                           //ngsWOappt.Appointment_Date__c = Date.valueof(Request.Activities.Activity.APPT_START_TIME);//CH03
                            ngsWOappt.Appointment_Type__c = Request.Activities.Activity.APPOINTMENT_TYPE;
                            ngsWOappt.Message_Date__c = Utility.getNewdatetime(Request.Activities.Activity.MESSAGE_DATE);
                            ngsWOappt.MPAN__c = Request.Activities.Activity.MPAN;
                            ngsWOappt.MPRN__c = Request.Activities.Activity.MPRN;
                            if(Request.Activities.Activity.DURATION != null && Request.Activities.Activity.DURATION != ''){
                                if(Request.Activities.Activity.DURATION.contains('.')){
                                    string hh = '';
                                    string mm ='';
                                    String duration = '';
                                    duration = Request.Activities.Activity.DURATION;
                                    hh = duration.subStringBefore('.');
                                    mm = ('.' + duration.substringafter('.'));
                                    mm = string.valueof(math.round(decimal.valueof(mm)*60));
                                    if(hh.length() == 1)
                                        hh = '0' + hh;
                                    if(mm.length() == 1)
                                        mm = '0'  + mm;
                                    duration = hh + ':' + mm;
                                    ngsWOappt.Duration__c = duration;
                                }
                                else
                                    ngsWOappt.Duration__c = Request.Activities.Activity.DURATION + ':00';
                            }
                            ngsWOappt.Address_Line_1__c = Request.Locations.Location.ADDR_LINE_1;
                            ngsWOappt.Address_Line_2__c = Request.Locations.Location.ADDR_LINE_2;
                            ngsWOappt.City__c = Request.Locations.Location.CITY;
                            ngsWOappt.Country__c = Request.Locations.Location.COUNTRY;
                            ngsWOappt.County__c = Request.Locations.Location.COUNTY;
                            ngsWOappt.Latitude__c = Request.Locations.Location.LATITUDE;
                            ngsWOappt.Longitude__c = Request.Locations.Location.LONGITUDE;
                            if(Request.Locations.Location.POST_CODE != null && Request.Locations.Location.POST_CODE != '' && Request.Locations.Location.POST_CODE.contains(' ')){
                                ngsWOappt.Post_Code__c = Request.Locations.Location.POST_CODE;
                                String postCodeStr = '';
                                postCodeStr = Request.Locations.Location.POST_CODE.substringBefore(' ') + ' ' + Request.Locations.Location.POST_CODE.substringAfter(' ').substring(0,1);
                                ngsPostCode = [select id, name, Sub_Region__c, Sub_Region__r.Region__c, Sub_Region__r.Oracle_Bucket_ID__c, Sub_Region__r.Default__c,Sub_Region__r.ECO__c,Sub_Region__r.Maintenance__c,Sub_Region__r.New_Connections__c,Sub_Region__r.Smart__c from NGS_Postcode__c where name = :postCodeStr];
                                if(ngsPostCode != null && ngsPostCode.size() > 0){
                                    if(ngsPostCode.size() == 1){
                                        ngsWOappt.Region__c = ngsPostCode[0].Sub_Region__r.Region__c;
                                        ngsWOappt.Sub_Region__c = ngsPostCode[0].Sub_Region__c;
                                    }
                                }
                                else{response.result = 'Post Code outside the area.'; ifsDataTrackerObj.Status__c = 'Fail';}
                            }
                            else{
                                response.result = 'Post Code missing or Invalid';
                                ifsDataTrackerObj.Status__c = 'Fail';
                            }
                            if(Request.Jobs != null && Request.Jobs.Job != null && response.result == ''){
                                List < NGS_S2_WO_Appointment_WS.JobElement > jobList = new List < NGS_S2_WO_Appointment_WS.JobElement > ();
                                jobList = Request.Jobs.Job;
                                Set<String> strSet = new Set<String>();
                                Set<String> jobNameSet = new Set<String>();
                                for(NGS_S2_WO_Appointment_WS.JobElement jobInst : jobList){
                                    if(jobInst.WORK_ORDER_NUMBER == null || jobInst.WORK_ORDER_NUMBER == ''){response.result = 'WORK_ORDER_NUMBER is missing in Job'; ifsDataTrackerObj.Status__c = 'Fail'; break;}
                                    if(jobInst.WORK_ORDER_NUMBER != Request.Activities.Activity.WORK_ORDER_NUMBER){response.result = 'WORK_ORDER_NUMBER should be same'; ifsDataTrackerObj.Status__c = 'Fail'; break;}
                                    if(jobInst.JOB_ID != null && jobInst.JOB_ID != ''){
                                        strSet.add(jobInst.JOB_ID);
                                    }
                                    else{response.result = 'JOB ID is missing'; ifsDataTrackerObj.Status__c = 'Fail'; break;}
                                }
                                if(strSet != null && strSet.size() > 0 && response.result == ''){
                                    ngsJobCodeMap = new Map<id,NGS_Job_Code__c>([select id, name, Bucket_Type__c from NGS_Job_Code__c where name in :strSet]);
                                    if(ngsJobCodeMap == null || ngsJobCodeMap.size() == 0){response.result = 'JOB ID does not match any SP records'; ifsDataTrackerObj.Status__c = 'Fail';}
                                    else{
                                        for(NGS_Job_Code__c ngsJobCodeInst : ngsJobCodeMap.values()){
                                            jobNameSet.add(ngsJobCodeInst.name);
                                            ngsJobStringCodeMap.put(ngsJobCodeInst.name,ngsJobCodeInst);
                                            if(isRejectedMpan && ngsJobCodeInst.name == 'EXCRE_DSP02'){ngsWOappt.Rescheduled__c = ngsWOappt.Rescheduled__c + 1;}//CH03
                                        }
                                        if(!strSet.equals(jobNameSet)){response.result = 'JOB ID does not match any SP records'; ifsDataTrackerObj.Status__c = 'Fail';}
                                        if(response.result == ''){
                                            for(NGS_S2_WO_Appointment_WS.JobElement jobInst : jobList){
                                                NGS_Task__c ngsTaskObj = new NGS_Task__c(Job_ID__c = ngsJobStringCodeMap.get(jobInst.JOB_ID).id);
                                                ngsTaskLst.add(ngsTaskObj);
                                                if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'Maintenance'){
                                                    isMaintenance = true;
                                                }
                                                else if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'ECO'){
                                                    isECO = true;
                                                }
                                                else if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'Smart'){
                                                    isSmart = true;
                                                }
                                                else if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'New Connections'){
                                                    isNewConnections = true;
                                                }
                                                else if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'Default'){
                                                    isDefault = true;
                                                }
                                            }
                                            for(NGS_Postcode__c ngsPCobj : ngsPostCode){
                                                if(ngsPCobj.Sub_Region__r.Default__c && isDefault){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__r.ECO__c && isECO){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__r.Maintenance__c && isMaintenance){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__r.New_Connections__c && isNewConnections){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__r.Smart__c && isSmart){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if(response.result == ''){
                                if(Request.Notes != null && Request.Notes.Note != null){
                                    List < NGS_S2_WO_Appointment_WS.NoteElement > notesList = new List < NGS_S2_WO_Appointment_WS.NoteElement > ();
                                    notesList = Request.Notes.Note;
                                    for(NGS_S2_WO_Appointment_WS.NoteElement noteInst: notesList){
                                        if(noteInst.WORK_ORDER_NUMBER != Request.Activities.Activity.WORK_ORDER_NUMBER){response.result = 'WORK_ORDER_NUMBER should be same'; ifsDataTrackerObj.Status__c = 'Fail'; break;}
                                        if(noteInst.NOTE_TEXT != null && noteInst.NOTE_TEXT != ''){
                                            NGS_Note__c ngsNoteObj = new NGS_Note__c(Note__c = noteInst.NOTE_TEXT, Note_Type__c = noteInst.NOTE_TYPE);
                                            ngsNoteLst.add(ngsNoteObj);
                                        }
                                    }
                                }
                                if(response.result == ''){
                                    //CH01.start
                                    if(woApptLst != null & woApptLst.size() > 0){
                                        update ngsWOappt;
                                        List< NGS_Note__c > toBeDeletedNgsNote = new List< NGS_Note__c > ();
                                        toBeDeletedNgsNote = [SELECT ID, Work_Order_Number__c FROM NGS_Note__c WHERE Work_Order_Number__c =:woApptLst[0].id];
                                        if(toBeDeletedNgsNote != null && toBeDeletedNgsNote.size() > 0){
                                            delete toBeDeletedNgsNote;
                                        }
                                        List< NGS_Task__c > toBeDeletedNgsTaskLst = new List< NGS_Task__c > ();
                                        toBeDeletedNgsTaskLst = [SELECT ID, Work_Order_Number__c FROM NGS_Task__c WHERE Work_Order_Number__c =:woApptLst[0].id];
                                        if(toBeDeletedNgsTaskLst != null && toBeDeletedNgsTaskLst.size() > 0){
                                            delete toBeDeletedNgsTaskLst;
                                        }
                                    }//CH01.end
                                    else
                                        insert ngsWOappt;
                                    ifsDataTrackerObj.NGS_Work_Order_Appointment__c = ngsWOappt.id;
                                    if(ngsNoteLst != null && ngsNoteLst.size() > 0){                                        
                                        for(NGS_Note__c ngsNoteObj : ngsNoteLst)
                                            ngsNoteObj.Work_Order_Number__c = ngsWOappt.id;
                                        insert ngsNoteLst;
                                    }
                                    if(ngsTaskLst != null && ngsTaskLst.size() > 0){
                                        for(NGS_Task__c ngsTaskObj : ngsTaskLst)
                                            ngsTaskObj.Work_Order_Number__c = ngsWOappt.id;
                                        insert ngsTaskLst;
                                    }
                                    response.result = 'Success : Work Order Inserted';
                                    ifsDataTrackerObj.Status__c = 'PASS';
                                }
                            }
                        }
                    }
                    else if(Request.Activities.Activity.CHANGE_TYPE.toUpperCase() == 'UPDATE'){
                        String vWOoApptNumber  = '';
                        vWOoApptNumber = Request.Activities.Activity.WORK_ORDER_NUMBER.trim();
                        List<NGS_Work_Order_Appointment__c> woApptLst = [select id, Name,Rejected__c,Status__c,Employee_ID__c,Rescheduled__c from NGS_Work_Order_Appointment__c where name = :vWOoApptNumber];
                        if(woApptLst != null & woApptLst.size() > 0){
                            NGS_Work_Order_Appointment__c ngsWOappt = new NGS_Work_Order_Appointment__c(id = woApptLst[0].id);
                            ifsDataTrackerObj.NGS_Work_Order_Appointment__c = woApptLst[0].id;
                            ngsWOappt.Appointment_Start_Time__c = Utility.getNewdatetime(Request.Activities.Activity.APPT_START_TIME);
                            ngsWOappt.Appointment_Finish_Time__c = Utility.getNewdatetime(Request.Activities.Activity.APPT_FINISH_TIME);
                            ngsWOappt.Appointment_Type__c = Request.Activities.Activity.APPOINTMENT_TYPE;
                            ngsWOappt.Message_Date__c = Utility.getNewdatetime(Request.Activities.Activity.MESSAGE_DATE);
                            ngsWOappt.MPAN__c = Request.Activities.Activity.MPAN;
                            ngsWOappt.MPRN__c = Request.Activities.Activity.MPRN;
                            //CH02.start
                            if(woApptLst[0].Status__c!=null && woApptLst[0].Status__c!='' && woApptLst[0].Status__c=='Rejected' && woApptLst[0].Rejected__c!=null){
                                ngsWOappt.Rejected__c=null;
                                ngsWOappt.Employee_ID__c=null;
                            }
                            //CH02.end
                            if(Request.Activities.Activity.DURATION != null && Request.Activities.Activity.DURATION != ''){
                                if(Request.Activities.Activity.DURATION.contains('.')){
                                    string hh = '';
                                    string mm ='';
                                    String duration = '';
                                    duration = Request.Activities.Activity.DURATION;
                                    hh = duration.subStringBefore('.');
                                    mm = ('.' + duration.substringafter('.'));
                                    mm = string.valueof(math.round(decimal.valueof(mm)*60));
                                    if(hh.length() == 1)
                                        hh = '0' + hh;
                                    if(mm.length() == 1)
                                        mm = '0'  + mm;
                                    duration = hh + ':' + mm;
                                    ngsWOappt.Duration__c = duration;
                                }else
                                    ngsWOappt.Duration__c = Request.Activities.Activity.DURATION + ':00';
                            }
                            ngsWOappt.Address_Line_1__c = Request.Locations.Location.ADDR_LINE_1;
                            ngsWOappt.Address_Line_2__c = Request.Locations.Location.ADDR_LINE_2;
                            ngsWOappt.City__c = Request.Locations.Location.CITY;
                            ngsWOappt.Country__c = Request.Locations.Location.COUNTRY;
                            ngsWOappt.County__c = Request.Locations.Location.COUNTY;
                            ngsWOappt.Latitude__c = Request.Locations.Location.LATITUDE;
                            ngsWOappt.Longitude__c = Request.Locations.Location.LONGITUDE;
                            if(Request.Locations.Location.POST_CODE != null && Request.Locations.Location.POST_CODE != '' && Request.Locations.Location.POST_CODE.contains(' ')){
                                ngsWOappt.Post_Code__c = Request.Locations.Location.POST_CODE;
                                String postCodeStr = '';
                                postCodeStr = Request.Locations.Location.POST_CODE.substringBefore(' ') + ' ' + Request.Locations.Location.POST_CODE.substringAfter(' ').substring(0,1);
                                ngsPostCode = [select id, name, Sub_Region__c, Sub_Region__r.Region__c, Sub_Region__r.Oracle_Bucket_ID__c, Sub_Region__r.Default__c,Sub_Region__r.ECO__c,Sub_Region__r.Maintenance__c,Sub_Region__r.New_Connections__c,Sub_Region__r.Smart__c from NGS_Postcode__c where name = :postCodeStr];
                                if(ngsPostCode != null && ngsPostCode.size() > 0){
                                    if(ngsPostCode.size() == 1){
                                        ngsWOappt.Region__c = ngsPostCode[0].Sub_Region__r.Region__c;
                                        ngsWOappt.Sub_Region__c = ngsPostCode[0].Sub_Region__c;
                                    }
                                }
                                else{response.result = 'Post Code outside the area.'; ifsDataTrackerObj.Status__c = 'Fail';}
                            }
                            if(Request.Jobs != null && Request.Jobs.Job != null){
                                List < NGS_S2_WO_Appointment_WS.JobElement > jobList = new List < NGS_S2_WO_Appointment_WS.JobElement > ();
                                jobList = Request.Jobs.Job;
                                Set<String> strSet = new Set<String>();
                                Set<String> jobNameSet = new Set<String>();
                                for(NGS_S2_WO_Appointment_WS.JobElement jobInst : jobList){
                                    if(jobInst.WORK_ORDER_NUMBER == null || jobInst.WORK_ORDER_NUMBER == ''){response.result = 'WORK_ORDER_NUMBER is missing in Job'; ifsDataTrackerObj.Status__c = 'Fail'; break;}
                                    if(jobInst.WORK_ORDER_NUMBER != Request.Activities.Activity.WORK_ORDER_NUMBER){response.result = 'WORK_ORDER_NUMBER should be same';ifsDataTrackerObj.Status__c = 'Fail'; break;}
                                    if(jobInst.JOB_ID != null && jobInst.JOB_ID != ''){
                                        strSet.add(jobInst.JOB_ID);
                                    }
                                    else{response.result = 'JOB ID is missing'; ifsDataTrackerObj.Status__c = 'Fail'; break;}
                                }
                                if(strSet != null && strSet.size() > 0 && response.result == ''){
                                    ngsJobCodeMap = new Map<id,NGS_Job_Code__c>([select id, name,Bucket_Type__c from NGS_Job_Code__c where name in :strSet]);
                                    if(ngsJobCodeMap == null || ngsJobCodeMap.size() == 0){response.result = 'JOB ID does not match any SP records'; ifsDataTrackerObj.Status__c = 'Fail';}
                                    else{
                                        for(NGS_Job_Code__c ngsJobCodeInst : ngsJobCodeMap.values()){
                                            jobNameSet.add(ngsJobCodeInst.name);
                                            ngsJobStringCodeMap.put(ngsJobCodeInst.name,ngsJobCodeInst);
                                        }
                                        if(!strSet.equals(jobNameSet)){response.result = 'JOB ID does not match any SP records'; ifsDataTrackerObj.Status__c = 'Fail';}
                                        if(response.result == ''){
                                            for(NGS_S2_WO_Appointment_WS.JobElement jobInst : jobList){
                                                NGS_Task__c ngsTaskObj = new NGS_Task__c(Job_ID__c = ngsJobStringCodeMap.get(jobInst.JOB_ID).id);
                                                ngsTaskLst.add(ngsTaskObj);
                                                if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'Maintenance'){
                                                    isMaintenance = true;
                                                }
                                                else if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'ECO'){
                                                    isECO = true;
                                                }
                                                else if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'Smart'){
                                                    isSmart = true;
                                                }
                                                else if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'New Connections'){
                                                    isNewConnections = true;
                                                }
                                                else if(ngsJobStringCodeMap.get(jobInst.JOB_ID).Bucket_Type__c == 'Default'){
                                                    isDefault = true;
                                                }
                                            }
                                            for(NGS_Postcode__c ngsPCobj : ngsPostCode){
                                                if(ngsPCobj.Sub_Region__r.Default__c && isDefault){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__r.ECO__c && isECO){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__r.Maintenance__c && isMaintenance){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__r.New_Connections__c && isNewConnections){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                                else if(ngsPCobj.Sub_Region__r.Smart__c && isSmart){
                                                    ngsWOappt.Region__c = ngsPCobj.Sub_Region__r.Region__c;
                                                    ngsWOappt.Sub_Region__c = ngsPCobj.Sub_Region__c;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if(response.result == ''){
                                if(Request.Notes != null && Request.Notes.Note != null){
                                    List < NGS_S2_WO_Appointment_WS.NoteElement > notesList = new list < NGS_S2_WO_Appointment_WS.NoteElement > ();
                                    notesList = Request.Notes.Note;
                                    for(NGS_S2_WO_Appointment_WS.NoteElement noteInst: notesList){
                                        if(noteInst.WORK_ORDER_NUMBER != Request.Activities.Activity.WORK_ORDER_NUMBER){response.result = 'WORK_ORDER_NUMBER should be same'; ifsDataTrackerObj.Status__c = 'Fail'; break;}
                                        if(noteInst.NOTE_TEXT != null && noteInst.NOTE_TEXT != ''){
                                            NGS_Note__c ngsNoteObj = new NGS_Note__c(Note__c = noteInst.NOTE_TEXT, Note_Type__c = noteInst.NOTE_TYPE,  Work_Order_Number__c = ngsWOappt.id);
                                            ngsNoteLst.add(ngsNoteObj);
                                        }
                                    }
                                }
                                if(response.result == ''){
                                    update ngsWOappt;
                                    
                                    if(ngsNoteLst != null && ngsNoteLst.size() > 0){
                                        List< NGS_Note__c > toBeDeletedNgsNote = new List< NGS_Note__c > ();
                                        toBeDeletedNgsNote = [SELECT ID, Work_Order_Number__c FROM NGS_Note__c WHERE Work_Order_Number__c =:ngsWOappt.id];
                                        if(toBeDeletedNgsNote != null && toBeDeletedNgsNote.size() > 0){
                                            delete toBeDeletedNgsNote;
                                        }
                                        insert ngsNoteLst;
                                    }
                                    if(ngsTaskLst != null && ngsTaskLst.size() > 0){
                                        for(NGS_Task__c ngsTaskObj : ngsTaskLst){
                                            ngsTaskObj.Work_Order_Number__c = ngsWOappt.id;
                                        }
                                        List< NGS_Task__c > toBeDeletedNgsTaskLst = new List< NGS_Task__c > ();
                                        toBeDeletedNgsTaskLst = [SELECT ID, Work_Order_Number__c FROM NGS_Task__c WHERE Work_Order_Number__c =:ngsWOappt.id];
                                        if(toBeDeletedNgsTaskLst != null && toBeDeletedNgsTaskLst.size() > 0){
                                            delete toBeDeletedNgsTaskLst;
                                        }
                                        insert ngsTaskLst;
                                    }
                                    response.result = 'Success : Work Order Updated';
                                    ifsDataTrackerObj.Status__c = 'PASS';
                                }
                            }
                        }
                        else{ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Work Order does not exist';}
                    }
                }
            }
            else{ifsDataTrackerObj.Status__c = 'Fail'; response.result = 'Request is Blank.';}//when the request received is blank
            ifsDataTrackerObj.Response_Data__c = EON_Utility.validateStringLength(response + '');
            insert ifsDataTrackerObj;
            EON_Utility.createAttachment(ifsDataTrackerObj.id, ifsDataTrackerObj.Request_Data__c, ifsDataTrackerObj.id);
            return response;
        }catch(DmlException ex){ifsDataTrackerObj.Request_Data__c = Request.toString(); response.result = ex.getDMLMessage(0); ifsDataTrackerObj.Status__c = 'Fail'; ifsDataTrackerObj.Response_Data__c = EON_Utility.validateStringLength(response + ''); ifsDataTrackerObj.Error__c = ex.getMessage()+'\n'+ ex.getStackTraceString(); upsert ifsDataTrackerObj; return response;}
        catch(Exception ex){ifsDataTrackerObj.Request_Data__c = Request.toString(); response.result = 'Error occurred while processing request.'; ifsDataTrackerObj.Status__c = 'Fail'; ifsDataTrackerObj.Response_Data__c = EON_Utility.validateStringLength(response + ''); ifsDataTrackerObj.Error__c = ex.getMessage()+'\n'+ ex.getStackTraceString(); upsert ifsDataTrackerObj; return response;}
    }
}