/**
    Description: This class used to generate WSDL. It provides status of OFSC to EON MIDOS.
    Test Class : EON_GetServiceStatus_WS_Test
**/
/*
    Created By : Dharmendra Pahadiya
    Created Date : 31-05-2016
    Service Request : SR_EON_AB_050
    Change History : 
*/
global with sharing class EON_GetMIDOSServiceStatus_WS{
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class HeaderElement{  
        Webservice String OrgId ;
        Webservice String RequestId ;
        Webservice datetime RequestDateTime ;
    }
    /**
        Description : Request Parameter
    **/
    global with sharing class ServiceStatusRequest{
        webservice HeaderElement Header;
    }
    /**
        Description : Response_element
    **/
    global with sharing class Response_element{
        webservice String OrgId;
        webservice Datetime AuditDate;
        webservice String ErrorMessage;
        webservice String AcknowledgementId;
        webservice Integer Status;
    }
    /**
        Description : Response
    **/
    global with sharing class ServiceStatusResponse{
        webservice Response_element Header;
    }

    /**
        MeterInstallationServiceStatus(ServiceStatusRequest Request) -
        This method is used to send Oracle status informaton to EON.
    **/
    webservice static ServiceStatusResponse ServiceStatus(ServiceStatusRequest Request){
        ServiceStatusResponse response = new ServiceStatusResponse();
        EON_Data_Tracker__c eonTracker = new EON_Data_Tracker__c();
        eonTracker.Direction__c = EON_Utility.DIRECTION_IN;//'IN';
        eonTracker.Command__c = 'Provide Service Status MIDOS';
        eonTracker.Request_Data__c = '';
        Response_element res = new Response_element();
        response.Header = res;
        response.Header.OrgId = system.label.EON_Sanbox_Name;//UserInfo.getOrganizationId();
        response.Header.AuditDate = EON_Utility.getNewdatetime(System.now());
        try{
            if(Request != null){//check if the request received from EON is not blank
                eonTracker.Request_Data__c = EON_Utility.validateStringLength(Request + '\n');
                if(Request.Header == null){
                	eonTracker.Status__c = EON_Utility.RESULT_FAIL;//'FAIL';
                    response.Header.ErrorMessage = 'Header is missing.';
                    response.Header.Status = 1;
                }
                else if(EON_Utility.validateRequired(Request.Header.orgId) || EON_Utility.validateRequired(Request.Header.requestId)
                         || EON_Utility.validateRequired(Request.Header.requestDateTime)){ //Check mandatory nodes are sent or not
                    eonTracker.Status__c = EON_Utility.RESULT_FAIL;//'FAIL';
                    response.Header.ErrorMessage = 'Mandatory fields are missing: orgId or requestId or requestDateTime';
                    response.Header.Status = 1;
                }
                else{
                	//Get OFSC Status 
                	string ofscStatus = EON_Service_Status_Jumbo_OFSC.getOFSCServiceStatus();
                	string errorMsg = (ofscStatus=='PASS'?'Oracle OK':'Oracle Fail');
                	
                	eonTracker.Transaction_ID__c = Request.Header.requestId;
                	response.Header.errorMessage = errorMsg;//serviceStatusList[0].Message__c;
                	if(EON_Utility.genException!=null && EON_Utility.genException) // to cover the exception part from test class
                		eonTracker.Transaction_ID__c = 'Test request IdTest request IdTest request IdTest request IdTest request IdTest request IdTest request Id';
                	response.Header.Status = (ofscStatus=='PASS'?0:1);
                	eonTracker.Status__c = EON_Utility.RESULT_PASS;//'PASS';
                }
            }
            else{//when the request received is blank
                eonTracker.Status__c = EON_Utility.RESULT_FAIL;//'FAIL';
                response.Header.errorMessage = 'Request is Blank.';
                response.Header.Status = 1;
            }
            insert eonTracker;
            EON_Utility.createAttachment(eonTracker.id, eonTracker.Request_Data__c, eonTracker.id);
            
            list<EON_Data_Tracker__c> lstTrack = new list<EON_Data_Tracker__c>([select id,name, Response_Data__c from EON_Data_Tracker__c where id =: eonTracker.id]);
            response.Header.AcknowledgementId = lstTrack[0].Name;
            lstTrack[0].Response_Data__c = EON_Utility.validateStringLength(response + '');
            update lstTrack[0];
            
            return response;
        }catch(Exception ex){
        	eonTracker.Request_Data__c=Request.toString();
        	response.Header.errorMessage = 'Error occurred while processing request. Please contact your administrator.';
        	if(EON_Utility.genException!=null && EON_Utility.genException) eonTracker.Transaction_ID__c = '';
            response.Header.Status = 1; 
        	eonTracker.Status__c = EON_Utility.RESULT_FAIL;//'FAIL'; 
        	eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
        	eonTracker.Error__c = ex.getMessage()+'\n'+ ex.getStackTraceString();
        	upsert eonTracker; 
        	return response;
        }
    }
}