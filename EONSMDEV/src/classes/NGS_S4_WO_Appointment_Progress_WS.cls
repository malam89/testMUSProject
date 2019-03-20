/**
    Description  : This class used to generate WSDL. It is used for S4 webservice to receive request from IFS.
    Test Class   : NGS_S4_WO_Appointment_Progress_WS_Test
**/
/*
    Created By : Puneet Mehta
    Created Date : 04/04/2017
    Service Request : SR_OptiMUS_NG_032
    Change History:
    CH01 # 03/05/2017 #Shruti Moghe #Added condition to bypass update Activity call to OFSC
    CH02 # 26/05/2017 #SR_OptiMUS_NG_045 #Puneet Mehta #Logic for reprocessing
*/
global with sharing class NGS_S4_WO_Appointment_Progress_WS{
    public static Map<String,String> xmlDataMap = new Map<String,String>();//CH02
    /**
        Description : Request Parameter
    **/
    global with sharing class WORK_ORDER_PROGRESS{
        webservice String   WORK_ORDER_NUMBER;
        webservice String   STATUS;
        webservice datetime STATUS_DATE;
        webservice datetime MESSAGE_DATE;
        webservice String   EXECUTION_TIME;
        webservice String   OUTCOME_CODE;
        webservice String   OUTCOME_DESCRIPTION;
        webservice String   EMPLOYEE_ID;
        webservice String   NOTES;
        webservice String   LATITUDE;
        webservice String   LONGITUDE;
        webservice String   LOCATION_DATE;
        webservice String   SERVICE_PROVIDER;
    }
    /**
        Description : Response
    **/
    global with sharing class S4_WO_Appointment_ProgressResponse {
        webservice String result;
    }

    /**
        S4_webservice_WORK_ORDER_PROGRESS() :        Receives the request from IFS and process it in OptiMUS
        @return S4_WO_Appointment_ProgressResponse   Returns response back to IFS.
    **/
    webservice static S4_WO_Appointment_ProgressResponse S4_webservice_WORK_ORDER_PROGRESS(WORK_ORDER_PROGRESS Request){
        S4_WO_Appointment_ProgressResponse response = new S4_WO_Appointment_ProgressResponse ();
        IFS_Data_Tracker__c ifsDataTrackerObj = new IFS_Data_Tracker__c();
        ifsDataTrackerObj.Direction__c = 'IN';
        ifsDataTrackerObj.Command__c = 'S4 WO PROGRESS';
        ifsDataTrackerObj.Request_Data__c = '';
        Boolean oraclePass = true;
        List<NGS_Oracle_Data_Tracker__c> oDataTrackers = new List<NGS_Oracle_Data_Tracker__c>();
        String xmlData = '';// for storing the xml Data.//CH02
        try{
            if(Request != null){//check if the request received from IFS is not blank
                xmlData = generateXMLData(Request);//CH02
                ifsDataTrackerObj.Request_Data__c = EON_Utility.validateStringLength(Request + '\n');
                if(Request.STATUS != 'CANCELLED' && (Request.EMPLOYEE_ID == null || Request.EMPLOYEE_ID == '')){
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'EMPLOYEE_ID is missing.';
                }
                else if(Request.STATUS != 'CANCELLED' && (Request.EXECUTION_TIME == null || Request.EXECUTION_TIME == '' || !Request.EXECUTION_TIME.contains('.'))){
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'EXECUTION_TIME is missing or invalid';
                }
                else if(Request.MESSAGE_DATE == null){
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'MESSAGE_DATE is missing.';
                }
                else if(EON_Utility.validateRequired(Request.SERVICE_PROVIDER)){ //Check mandatory nodes are sent or not
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'Mandatory field is missing: SERVICE_PROVIDER';
                }
                else if(Request.SERVICE_PROVIDER != 'SP02'){ 
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'Expected Service Provider is SP02';
                }
                else if(Request.STATUS == null || Request.STATUS == ''){
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'STATUS is missing.';
                }
                else if(Request.STATUS != 'ONROUTE' && Request.STATUS != 'STARTED' 
                        && Request.STATUS != 'WORKDONE' && Request.STATUS != 'COMPLETED' && Request.STATUS != 'CANCELLED'){
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'Expected STATUS : ONROUTE/STARTED/WORKDONE/COMPLETED/CANCELLED';
                }
                else if(Request.STATUS == 'COMPLETED' && (Request.OUTCOME_CODE == null || Request.OUTCOME_CODE == '' || Request.OUTCOME_DESCRIPTION == null || Request.OUTCOME_DESCRIPTION == '')){
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'When <STATUS> = "COMPLETED" then <OUTCOME_CODE> & <OUTCOME_DESCRIPTION> are mandatory';
                }
                else if(Request.STATUS_DATE == null){
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'STATUS_DATE is missing.';
                }
                else if(Request.WORK_ORDER_NUMBER == null || Request.WORK_ORDER_NUMBER == ''){
                    ifsDataTrackerObj.Status__c = 'Fail';
                    response.result = 'WORK_ORDER_NUMBER is missing';
                }
                else{
                    String vWoApptStr = '';
                    String vTechStr = '';
                    vWoApptStr = Request.WORK_ORDER_NUMBER;
                    vTechStr = Request.EMPLOYEE_ID;
                    List<NGS_Work_Order_Appointment__c> woApptLst = new List<NGS_Work_Order_Appointment__c>();
                    if(Request.STATUS != 'CANCELLED')
                        woApptLst = [select id, Name, Oracle_Activity_ID__c, Employee_ID__c, Employee_ID__r.name from NGS_Work_Order_Appointment__c where name = :vWoApptStr and Employee_ID__r.name = :vTechStr];
                    else
                        woApptLst = [select id, Name, Oracle_Activity_ID__c, Employee_ID__c, Employee_ID__r.name from NGS_Work_Order_Appointment__c where name = :vWoApptStr];
                    if(woApptLst != null & woApptLst.size() > 0){
                        NGS_Work_Order_Appointment__c ngsWOappt = new NGS_Work_Order_Appointment__c(id = woApptLst[0].id);
                        ifsDataTrackerObj.NGS_Work_Order_Appointment__c = woApptLst[0].id;
                        String result = '';
                        List<String> responseString = new List<String>();
                        NGS_OFSC_Activity_Handler activityHandlInst = new NGS_OFSC_Activity_Handler();
                        responseString = activityHandlInst.manageActivity('activate',woApptLst[0].Employee_ID__c,woApptLst[0].Oracle_Activity_ID__c);
                        NGS_Oracle_Data_Tracker__c ngsOracleDataTrckr = NGS_OFSC_Activity_Handler.oracleTracker;
                        ngsOracleDataTrckr.Works_Order__c = woApptLst[0].id;
                        ngsOracleDataTrckr.NGS_Technician__c = woApptLst[0].Employee_ID__c;
                        if(responseString != null && responseString.size() == 2){
                            ngsOracleDataTrckr.Response_Data__c = responseString[0];
                            if(responseString[1] == 'SUCCESS')
                                ngsOracleDataTrckr.Status__c = 'Pass';
                            else
                                ngsOracleDataTrckr.Status__c = 'Fail';
                        }
                        oDataTrackers.add(ngsOracleDataTrckr);
                        if(Request.STATUS == 'ONROUTE'){
                            ngsWOappt.Technician_On_Route__c = Utility.getNewdatetime(Request.STATUS_DATE);
                        }
                        else if(Request.STATUS == 'STARTED'){
                            ngsWOappt.Work_Order_Started__c = Utility.getNewdatetime(Request.STATUS_DATE);
                            responseString = activityHandlInst.manageActivity('started',woApptLst[0].Employee_ID__c,woApptLst[0].Oracle_Activity_ID__c);
                        }
                        else if(Request.STATUS == 'WORKDONE'){
                            ngsWOappt.Work_Order_Ops_Complete__c = Utility.getNewdatetime(Request.STATUS_DATE);
                            responseString = activityHandlInst.manageActivity('completed',woApptLst[0].Employee_ID__c,woApptLst[0].Oracle_Activity_ID__c);
                        }
                        else if(Request.STATUS == 'COMPLETED'){
                            ngsWOappt.Work_Order_Complete__c = Utility.getNewdatetime(Request.STATUS_DATE);
                        }
                        else if(Request.STATUS == 'CANCELLED'){
                            ngsWOappt.Cancelled__c = Utility.getNewdatetime(Request.STATUS_DATE);
                            responseString = activityHandlInst.manageActivity('cancelled',woApptLst[0].Employee_ID__c,woApptLst[0].Oracle_Activity_ID__c);
                        }
                        if(Request.STATUS != 'ONROUTE' && Request.STATUS != 'COMPLETED'){
                            NGS_Oracle_Data_Tracker__c ngsOracleDataTrckr1 = NGS_OFSC_Activity_Handler.oracleTracker;
                            ngsOracleDataTrckr1.Works_Order__c = woApptLst[0].id;
                            ngsOracleDataTrckr1.NGS_Technician__c = woApptLst[0].Employee_ID__c;
                            if(responseString != null && responseString.size() == 2){
                                ngsOracleDataTrckr1.Response_Data__c = responseString[0];
                                if(responseString[1] == 'SUCCESS'){
                                    ngsOracleDataTrckr1.Status__c = 'Pass';
                                    oraclePass = true;
                                }
                                else{
                                    ngsOracleDataTrckr1.Status__c = 'Fail';
                                    ifsDataTrackerObj.Status__c = 'Fail';
                                    response.result = responseString[1];
                                    oraclePass = false;
                                }
                            }
                            oDataTrackers.add(ngsOracleDataTrckr1);
                        }
                        insert oDataTrackers;
                        if(oraclePass){
                            NGS_Work_Order_Progress__c woProgressInst = new NGS_Work_Order_Progress__c(NGS_Work_Order_Number__c = woApptLst[0].id);
                            woProgressInst.Status__c = Request.STATUS;
                            woProgressInst.Status_Date__c = Utility.getNewdatetime(Request.STATUS_DATE);
                            woProgressInst.Message_Date__c = Utility.getNewdatetime(Request.MESSAGE_DATE);
                            if(Request.EXECUTION_TIME != null && Request.EXECUTION_TIME != '' && Request.EXECUTION_TIME.contains('.')){
                                string hh = '';
                                string mm ='';
                                String duration = '';
                                duration = Request.EXECUTION_TIME;
                                hh = duration.subStringBefore('.');
                                mm = (duration.substringafter('.'));
                                mm = string.valueof(math.mod(integer.valueof(hh),60));
                                hh = string.valueof(integer.valueof(hh)/60);
                                if(hh.length() == 1)
                                    hh = '0' + hh;
                                if(mm.length() == 1)
                                    mm = '0'  + mm;
                                duration = hh + ':' + mm;
                                woProgressInst.Execution_Time__c = duration;
                            }
                            woProgressInst.Outcome_Code__c = Request.OUTCOME_CODE;
                            woProgressInst.Outcome_Description__c = Request.OUTCOME_DESCRIPTION;
                            woProgressInst.Employee_ID__c = woApptLst[0].Employee_ID__c;
                            woProgressInst.Notes__c = Request.NOTES;
                            if(Request.LATITUDE != null && Request.LATITUDE != '')
                                woProgressInst.Latitude__c = Decimal.valueof(Request.LATITUDE);
                            if(Request.LONGITUDE != null && Request.LONGITUDE != '')
                                woProgressInst.Longitude__c = Decimal.valueof(Request.LONGITUDE);
                            if(Request.LOCATION_DATE != null && Request.LOCATION_DATE != ''){
                                woProgressInst.Location_Date__c = Utility.getNewdatetime((DateTime) JSON.deserialize('"'+ Request.LOCATION_DATE +'"', DateTime.class));
                            }
                            insert woProgressInst;
                            Utility.ByPassOFSCUpdate =false;//CH01
                            update ngsWOappt;
                            ifsDataTrackerObj.Status__c = 'Pass';
                            response.result = 'Success';
                        }
                    }
                    else{
                        ifsDataTrackerObj.Status__c = 'Fail';
                        response.result = 'Work Order does not exist';
                    }
                }
            }
            else{//when the request received is blank
                ifsDataTrackerObj.Status__c = 'Fail';
                response.result = 'Request is Blank.';
            }
            ifsDataTrackerObj.Response_Data__c = EON_Utility.validateStringLength(response + '');
            insert ifsDataTrackerObj;
            //EON_Utility.createAttachment(ifsDataTrackerObj.id, ifsDataTrackerObj.Request_Data__c, ifsDataTrackerObj.id);//CH02.OLD
            insert new Attachment(Name='S4.xml',body=Blob.valueOf(xmlData),parentId=ifsDataTrackerObj.Id);//CH02
            return response;}catch(DmlException ex){ifsDataTrackerObj.Request_Data__c = Request.toString(); response.result = ex.getDMLMessage(0); ifsDataTrackerObj.Status__c = 'Fail'; ifsDataTrackerObj.Response_Data__c = EON_Utility.validateStringLength(response + ''); ifsDataTrackerObj.Error__c = ex.getMessage()+'\n'+ ex.getStackTraceString(); upsert ifsDataTrackerObj; return response;}
        catch(Exception ex){
            ifsDataTrackerObj.Request_Data__c = Request.toString();
            response.result = 'Error occurred while processing request.'; 
            ifsDataTrackerObj.Status__c = 'Fail'; 
            ifsDataTrackerObj.Response_Data__c = EON_Utility.validateStringLength(response + '');
            ifsDataTrackerObj.Error__c = ex.getMessage()+'\n'+ ex.getStackTraceString();
            upsert ifsDataTrackerObj;
            return response;
        }
    }
    //CH02.START
    private static String generateXMLData(WORK_ORDER_PROGRESS Request){
        String strXMLData = '';
        try{
            strXMLData = '<?xml version="1.0"?>';
            strXMLData = strXMLData + '<WORK_ORDER_PROGRESS>';
            strXMLData = strXMLData + '<WORK_ORDER_NUMBER>' + Request.WORK_ORDER_NUMBER + '</WORK_ORDER_NUMBER>';
            strXMLData = strXMLData + '<STATUS>' + Request.STATUS + '</STATUS>';
            strXMLData = strXMLData + '<STATUS_DATE>' + Request.STATUS_DATE + '</STATUS_DATE>';
            strXMLData = strXMLData + '<MESSAGE_DATE>' + Request.MESSAGE_DATE + '</MESSAGE_DATE>';
            strXMLData = strXMLData + '<EXECUTION_TIME>' + Request.EXECUTION_TIME + '</EXECUTION_TIME>';
            strXMLData = strXMLData + '<OUTCOME_CODE>' + Request.OUTCOME_CODE + '</OUTCOME_CODE>';
            strXMLData = strXMLData + '<OUTCOME_DESCRIPTION>' + Request.OUTCOME_DESCRIPTION + '</OUTCOME_DESCRIPTION>';
            strXMLData = strXMLData + '<EMPLOYEE_ID>' + Request.EMPLOYEE_ID + '</EMPLOYEE_ID>';
            strXMLData = strXMLData + '<NOTES>' + Request.NOTES + '</NOTES>';
            strXMLData = strXMLData + '<LATITUDE>' + Request.LATITUDE + '</LATITUDE>';
            strXMLData = strXMLData + '<LONGITUDE>' + Request.LONGITUDE + '</LONGITUDE>';
            strXMLData = strXMLData + '<LOCATION_DATE>' + Request.LOCATION_DATE + '</LOCATION_DATE>';
            strXMLData = strXMLData + '<SERVICE_PROVIDER>' + Request.SERVICE_PROVIDER + '</SERVICE_PROVIDER>';
            strXMLData = strXMLData + '</WORK_ORDER_PROGRESS>';
            return strXMLData;
        }
        catch(Exception ex) {
            return 'Error Message = ' + ex.getMessage();
        }
    }
    /**
        reprocessRecords(String trackerId)
    **/
    webservice static string reprocessRecords(String trackerId){
        String response = '';
        List<Attachment> attachedXML = [select id, parentid, body from attachment where parentid =: trackerId and name = 'S4.xml' limit 1];
        if(attachedXML != null && attachedXML.size() > 0){
            String xmlData = attachedXML.get(0).Body.toString();
            xmlData = xmlData.replace('&lt;','<');
            xmlData = xmlData.replace('&gt;','>');
            xmlData = xmlData.replace('&quot;','"');
            xmlData = xmlData.replace('&apos;','\'');
            xmlData = xmlData.replace('&amp;','&');
            xmlData = xmlData.replace('&','&amp;');
            DOM.Document doc = new DOM.Document();
            doc.load(xmlData);
            parseXMLTags(doc.getRootElement());
            NGS_S4_WO_Appointment_Progress_WS.WORK_ORDER_PROGRESS woProgress = new NGS_S4_WO_Appointment_Progress_WS.WORK_ORDER_PROGRESS();
            woProgress.WORK_ORDER_NUMBER = xmlDataMap.containsKey('WORK_ORDER_NUMBER') ? xmlDataMap.get('WORK_ORDER_NUMBER') : null;
            woProgress.STATUS = xmlDataMap.containsKey('STATUS') ? xmlDataMap.get('STATUS') : null;
            woProgress.STATUS_DATE = xmlDataMap.containsKey('STATUS_DATE') && xmlDataMap.get('STATUS_DATE') != null ? Utility.getNewdatetimeAdd(Datetime.valueof(xmlDataMap.get('STATUS_DATE'))): null;
            woProgress.MESSAGE_DATE = xmlDataMap.containsKey('MESSAGE_DATE') && xmlDataMap.get('MESSAGE_DATE') != null ? Utility.getNewdatetimeAdd(Datetime.valueof(xmlDataMap.get('MESSAGE_DATE'))): null;
            woProgress.EXECUTION_TIME = xmlDataMap.containsKey('EXECUTION_TIME') ? xmlDataMap.get('EXECUTION_TIME'): null;
            woProgress.OUTCOME_CODE = xmlDataMap.containsKey('OUTCOME_CODE') ? xmlDataMap.get('OUTCOME_CODE'): null;
            woProgress.OUTCOME_DESCRIPTION = xmlDataMap.containsKey('OUTCOME_DESCRIPTION') ? xmlDataMap.get('OUTCOME_DESCRIPTION'): null;
            woProgress.EMPLOYEE_ID = xmlDataMap.containsKey('EMPLOYEE_ID') ? xmlDataMap.get('EMPLOYEE_ID'): null;
            woProgress.NOTES = xmlDataMap.containsKey('NOTES') ? xmlDataMap.get('NOTES'): null;
            woProgress.LATITUDE = xmlDataMap.containsKey('WORK_ORDER_NUMBER') ? xmlDataMap.get('LATITUDE'): null;
            woProgress.LONGITUDE = xmlDataMap.containsKey('WORK_ORDER_NUMBER') ? xmlDataMap.get('LONGITUDE'): null;
            woProgress.SERVICE_PROVIDER = xmlDataMap.containsKey('WORK_ORDER_NUMBER') ? xmlDataMap.get('SERVICE_PROVIDER'): null;
            woProgress.LOCATION_DATE = xmlDataMap.containsKey('WORK_ORDER_NUMBER') ? xmlDataMap.get('LOCATION_DATE'): null;
            NGS_S4_WO_Appointment_Progress_WS.S4_webservice_WORK_ORDER_PROGRESS(woProgress);
            update new IFS_Data_Tracker__c(id = trackerId, Reprocessed__c = system.now());
            response = 'Reprocessed';
        }
        else{response = 'No XML found to reprocess';}
        return response;
    }
    
    /**
        parseXMLTags(DOM.XMLNode node) - This method parses the XML and loads the data into a map.
    **/
    public static void parseXMLTags(DOM.XMLNode node)
    {
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT){
            xmlDataMap.put(node.getName(),node.getText().trim());
            for(Dom.XMLNode child: node.getChildElements())
                parseXMLTags(child);
        }
    }
    //CH02.END
}