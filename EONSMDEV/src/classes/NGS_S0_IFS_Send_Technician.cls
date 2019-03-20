/**
    Description : This class is used to send Technician information to NG IFS system.
    Test Class  : 
**/
/*
    Created By  : Puneet Mehta
    Created On  : 22/03/2017
    Service Req : SR_OptiMUS_NG_006
    Change History
*/
global with sharing class NGS_S0_IFS_Send_Technician{

    /**
        sendTechnicianToIfs(String technicianId)
    **/
    webservice static string sendTechnicianToIfs(String technicianId){
        String resultMsg = '';
        IFS_Data_Tracker__c ifsDataTrackerObj = new IFS_Data_Tracker__c();
        ifsDataTrackerObj.Direction__c = 'OUT';
        ifsDataTrackerObj.Command__c = 'S0 SEND TECHNICIAN';
        ifsDataTrackerObj.Request_Data__c = '';
        List<NGS_Technician__c> techLst = new List<NGS_Technician__c>();
        Id techID = Id.valueOf(technicianId);
        ifsDataTrackerObj.NGS_Technician__c = techID;
        techLst = [select id,Name,First_Name__c,Gender__c,Last_Name__c,Start_Location__c,Mobile_Number__c from NGS_Technician__c where id =:techID limit 1];
        if(techLst != null && techLst.size() > 0){
            NGS_S0_typesHrResource_IFS_WS hrResourceType = new NGS_S0_typesHrResource_IFS_WS();
            NGS_S0_typesHrResource_IFS_WS.resources ngsHrSp1In = new NGS_S0_typesHrResource_IFS_WS.resources();
            NGS_S0_typesHrResource_IFS_WS.resource[] resourcesArray = new NGS_S0_typesHrResource_IFS_WS.resource[]{};
            NGS_S0_typesHrResource_IFS_WS.resource resourceInst = new NGS_S0_typesHrResource_IFS_WS.resource();
            resourceInst.employeeId = techLst[0].Name;
            resourceInst.firstName = techLst[0].First_Name__c;
            resourceInst.lastName = techLst[0].Last_Name__c;
            resourceInst.gender = techLst[0].Gender__c;
            resourceInst.startLocation = techLst[0].Start_Location__c;
            resourceInst.mobileNumber = techLst[0].Mobile_Number__c;
            resourceInst.serviceProvider = 'SP02';
            resourcesArray.add(resourceInst);
            ngsHrSp1In.resourcesConn = resourcesArray;
            ifsDataTrackerObj.Request_Data__c = string.valueOf(ngsHrSp1In);
            NGS_S0_typesHrResource_IFS_WS.resources response = null;
            NGS_S0_ReceiveHrResource_IFS_WS.CReceiveResourcePort obj = new NGS_S0_ReceiveHrResource_IFS_WS.CReceiveResourcePort();
            obj.inputHttpHeaders_x = new Map<String, String>();
            Blob headerValue = Blob.valueOf(System.Label.NGS_IFS_USER + ':' + System.Label.NGS_IFS_PASSWORD);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            obj.inputHttpHeaders_x.put('Authorization', authorizationHeader);
            try{
                response = obj.receiveResource(ngsHrSp1In);
                ifsDataTrackerObj.Response_Data__c = String.valueOf(response);
                ifsDataTrackerObj.Status__c = 'Pass';
                update new NGS_Technician__c(id=techLst[0].id, Sent_to_IFS__c = true);

                resultMsg = 'Technician sent to IFS successfully!';
            }
            catch(Exception ex){ifsDataTrackerObj.Status__c = 'Fail'; ifsDataTrackerObj.Error__c = ex.getMessage()+'\n'+ ex.getStackTraceString(); ifsDataTrackerObj.Response_Data__c = ex.getMessage(); resultMsg = 'Error sending Technician to NG. Please refer IFS Data Tracker record.';}
            finally{
                insert ifsDataTrackerObj;
                return resultMsg;
            }
            return resultMsg;
        }
        return resultMsg;
    }
}