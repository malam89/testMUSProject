/**
    Description     : This controller is used to get Service Status of EON.
    VF Page         : NA
    Test Class      : EON_ServiceStatus_test     
**/
/*
    Created By      : Dharmendra Pahadiya
    Created Date    : 12/07/2016
    Service Request : SR_EON_AB_081 & SR_Isis_EON_021
    Change History  : 
    CH01 # SR_OptiMUS_EON_022 # Akshay B # 03/08/2016 # Added code for sending SOAP messsage required by EON through a http request.
*/
global class EON_ServiceStatus {
    
    /*
        getEONServiceStatus(string TrackerId) - This Method is used to get Service Status of EON.
    */
    webservice static void getEONServiceStatus(string TrackerId){
        system.debug('in method call');
        list<EON_Data_Tracker__c> lstTracker = [select id, name, Request_Data__c, Response_Data__c, Status__c from EON_Data_Tracker__c where id =: TrackerId];
        
        //WSDL Part
        try{
            //Create request
            EON_GET_Job_Service_Schema_WS.ServiceStatusRequestDto requestData = new EON_GET_Job_Service_Schema_WS.ServiceStatusRequestDto();
            requestData.OrgId = system.label.EON_Sanbox_Name;
            requestData.RequestDateTime = datetime.now();
            requestData.RequestId = lstTracker[0].Name;
            
            lstTracker[0].Request_Data__c = Eon_Utility.validateStringLength(string.valueOf(requestData));
            lstTracker[0].Transaction_ID__c = lstTracker[0].Name;
            
            //Web service callout
            try{
                EON_GET_Job_Service_from_EON_WS.CustomBinding_IJobService request = new EON_GET_Job_Service_from_EON_WS.CustomBinding_IJobService();
                EON_GET_Job_Service_Schema_WS.ServiceStatusResponseDto response = request.ProvideServiceStatus(requestData);
                lstTracker[0].Response_Data__c = EON_Utility.validateStringLength(string.valueof(response));
                lstTracker[0].Status__c = EON_Utility.RESULT_PASS;
            }
            catch(exception ex){
                system.debug('#### web service exception: '+ex.getmessage()+'\n'+ex.getStackTraceString());
                lstTracker[0].Response_Data__c = ex.getmessage();
                lstTracker[0].Status__c = EON_Utility.RESULT_FAIL;
            }
            
            update lstTracker[0];
        }catch(exception ex){system.debug('@@@ exception: '+ex.getMessage());lstTracker[0].Status__c ='FAIL';lstTracker[0].Response_Data__c = ex.getMessage(); update lstTracker[0];}
    }
    
    /*
        getMIDOSServiceStatus(string TrackerId) - This Method is used to get Service Status of MIDOS(Commissioning).
    */
    webservice static void getMIDOSServiceStatus(string TrackerId){
        system.debug('in method call');
        list<MIDOS_Data_Tracker__c> lstTracker = [select id, name, Request_Data__c, Response_Data__c, Status__c from MIDOS_Data_Tracker__c where id =: TrackerId];
        //WSDL Part
        try{
            //CH01.Start
            //Canonicalized Body
            String CBody = '<s:Body xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" u:Id="_1"><ProvideServiceStatus xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request><b:Header xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:OrgId>'+system.label.EON_Sanbox_Name+'</b:OrgId><b:RequestDateTime>'+system.now().format('yyyy-MM-dd\'T\'HH:mm:ss')+'</b:RequestDateTime><b:RequestId>'+lstTracker[0].Name+'</b:RequestId></b:Header></request></ProvideServiceStatus></s:Body>';
            
            //SOAP Action specific to individual operations:
            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/ProvideServiceStatus';
            
            string strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,CBody);
            
            system.debug('@@ Request in xml format :->'+strResponseXML );
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setHeader('Content-Type','text/xml;charset=utf-8');
            req.setHeader('SOAPAction',action.trim());
            req.setEndpoint(System.Label.EON_MIDOS_Endpoint);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(strResponseXML);
            lstTracker[0].Request_Data__c = Eon_Utility.validateStringLength(string.valueOf(req.getbody().substringBetween('<s:Body xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" u:Id="_1">','</s:Body>')));
            lstTracker[0].Transaction_ID__c = lstTracker[0].Name;
            try{
                res = http.send(req);
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
                system.debug('---------->>'+res.getBody());
                lstTracker[0].Response_Data__c = EON_Utility.validateStringLength(string.valueof(res.getBody()));
                if(lstTracker[0].Response_Data__c!=null && lstTracker[0].Response_Data__c.contains('Status>0</')){lstTracker[0].Status__c = EON_Utility.RESULT_PASS;}
                else{
                      lstTracker[0].Status__c = EON_Utility.RESULT_FAIL;  
                } 
             
            }
            catch(exception ex){
                System.debug('Callout error: '+ ex);
                System.debug(res.toString());
                system.debug('#### web service exception: '+ex.getmessage()+'\n'+ex.getStackTraceString());
                lstTracker[0].Response_Data__c = ex.getmessage();
                lstTracker[0].Status__c = EON_Utility.RESULT_FAIL;
            }
            //CH01.End 
            update lstTracker[0];
            EON_Utility.createAttachment(lstTracker[0].id,req.getbody(),lstTracker[0].name);//
        }catch(exception ex){system.debug('@@@ exception: '+ex.getMessage());lstTracker[0].Status__c ='FAIL';lstTracker[0].Response_Data__c = ex.getMessage(); update lstTracker[0];}
    }
}