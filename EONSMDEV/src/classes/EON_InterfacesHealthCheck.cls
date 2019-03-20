/**
    Description : This class is the controller Conatain method to check EON webservice running status for below Interfaces
                  1. EON
                  2. MIDOS
                  3. OFSC 
                  4. JUMBO               
                  
    VF Page     : None
    Test Class  : EON_Monitoring_Controller_Test

**/
/*
    Created By  : Mehboob Alam
    Created On  : 09/10/2017
    Service Req : SR_OptiMUS_EON_149
    Change History
	CH01 # SR_EON_297 # 11/02/2019 # Tabish Almas # Added new method MDSServiceStatus to get Service Status for MDS Interface.
*/
Public class EON_InterfacesHealthCheck{
	
	
	 /**
      MIDOSServiceStatus() - This Method is used to get Service Status for MIDOS Interface.
     **/
     public static MIDOS_Data_Tracker__c MIDOSServiceStatus(){
        MIDOS_Data_Tracker__c mTracker = new MIDOS_Data_Tracker__c(Direction__c = 'OUT',Command__c = 'Get Service Status');
        try{
            //Canonicalized Body
            String CBody = '<s:Body xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" u:Id="_1"><ProvideServiceStatus xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request><b:Header xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:OrgId>'+system.label.EON_Sanbox_Name+'</b:OrgId><b:RequestDateTime>'+system.now().format('yyyy-MM-dd\'T\'HH:mm:ss')+'</b:RequestDateTime><b:RequestId>MDT-000000383</b:RequestId></b:Header></request></ProvideServiceStatus></s:Body>';
            
            //SOAP Action specific to individual operations:
            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/ProvideServiceStatus';
            
            string strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,CBody);            
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setHeader('Content-Type','text/xml;charset=utf-8');
            req.setHeader('SOAPAction',action.trim());
            req.setEndpoint(System.Label.EON_MIDOS_Endpoint);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(strResponseXML);
            mTracker.Request_Data__c = Eon_Utility.validateStringLength(string.valueOf(req.getbody().substringBetween('<s:Body xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" u:Id="_1">','</s:Body>')));
            mTracker.Transaction_ID__c = mTracker.Name;
            try{
                res = http.send(req);
                mTracker.Response_Data__c = EON_Utility.validateStringLength(string.valueof(res.getBody()));
                if(mTracker.Response_Data__c!=null && mTracker.Response_Data__c.contains('Status>0</')){mTracker.Status__c = EON_Utility.RESULT_PASS;}
                   else{
                      mTracker.Status__c = EON_Utility.RESULT_FAIL;  
                } 
                 return mTracker;
                }
	            catch(exception ex){ mTracker.Response_Data__c = ex.getmessage(); mTracker.Status__c = EON_Utility.RESULT_FAIL; return mTracker; }
	        }
	        catch(exception ex){ mTracker.Status__c ='FAIL'; mTracker.Response_Data__c = ex.getMessage(); return mTracker;}
    }
    
     
	     /**
	      JUMBOServiceStatus() - This Method is used to get Service Status for JUMBO Interface.
	     **/
	     public static JUMBO_Data_Tracker__c JUMBOServiceStatus(){
	        EON_Jumbo_ReqElectricityMOP.MOPValidationResponse mopCheck = EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP('12345678');
	        return  EON_Jumbo_ReqElectricityMOP.cTrack;
	    }
    
    	//CH01.Start
    	/**
	      MDSServiceStatus() - This Method is used to get Service Status for MDS Interface.
	     **/
	     public static MDS_Data_Tracker__c MDSServiceStatus(){
	        EON_MDS_ReqElectricityMOP.MOPValidationResponse mopCheck = EON_MDS_ReqElectricityMOP.ValidateMPANMOP('2000013379733');
	        return  EON_MDS_ReqElectricityMOP.cTrack;
	    }
    	//CH01.End
	
         /**
        EONServiceStatus() - This Method is used to get Service Status of EON Interface.
        **/
        public static EON_Data_Tracker__c EONServiceStatus(){
        EON_Data_Tracker__c eonTracker = new EON_Data_Tracker__c(Direction__c = 'OUT',Command__c = 'Get Service Status');        
        
        //WSDL Part
        try{
            //Create request
            EON_GET_Job_Service_Schema_WS.ServiceStatusRequestDto requestData = new EON_GET_Job_Service_Schema_WS.ServiceStatusRequestDto();
            requestData.OrgId = system.label.EON_Sanbox_Name;
            requestData.RequestDateTime = datetime.now();
            requestData.RequestId = 'EDT-000000589';
            
            eonTracker.Request_Data__c = Eon_Utility.validateStringLength(string.valueOf(requestData));
            eonTracker.Transaction_ID__c = 'EDT-000000589';
            
            //Web service callout
            try{
                EON_GET_Job_Service_from_EON_WS.CustomBinding_IJobService request = new EON_GET_Job_Service_from_EON_WS.CustomBinding_IJobService();
                EON_GET_Job_Service_Schema_WS.ServiceStatusResponseDto response = request.ProvideServiceStatus(requestData);
                eonTracker.Response_Data__c = EON_Utility.validateStringLength(string.valueof(response));
                eonTracker.Status__c = EON_Utility.RESULT_PASS;
                return eonTracker;
            }
            catch(exception ex){ eonTracker.Response_Data__c = ex.getmessage(); eonTracker.Status__c = EON_Utility.RESULT_FAIL; return eonTracker;}
            
         }
            catch(exception ex){ eonTracker.Status__c ='FAIL'; eonTracker.Response_Data__c = ex.getMessage(); return eonTracker;}
     }
     
     
        /**
        EONServiceStatus() - This Method is used to get Service Status of OFSC Interface.
        **/
        public static Oracle_Data_Tracker__c OFSCServiceStatus(){
            
            Oracle_Data_Tracker__c ofscTracker = new Oracle_Data_Tracker__c(Direction__c = 'OUT',Command__c = 'Get Service Status');
            try{    
                EON_OFSC_Resource_Management_WS.AuthNodeElement authNodeElement = new EON_OFSC_Resource_Management_WS.AuthNodeElement();
                //Create Authentication node with parameters
                authNodeElement.company = System.Label.EON_OFSC_Company; 
                authNodeElement.login = System.Label.EON_OFSC_Login;
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeDateTime(Datetime.now());
                
                //Cope with the formatter returning .123Z as the time zone offset for GMT
                if (gen.getAsString().length() == 27)authNodeElement.now = gen.getAsString().substring(1,26);
                  else
                    authNodeElement.now = gen.getAsString().substring(1,20) + '+00:00';
                    
                authNodeElement.auth_string = EON_Utility.md5(authNodeElement.now + EON_Utility.md5(System.Label.EON_OFSC_Password)); 
                
                ofscTracker.Request_Data__c  = string.valueOf(authNodeElement);
                EON_OFSC_Resource_Management_WS.ResourceManagementPort  request= new EON_OFSC_Resource_Management_WS.ResourceManagementPort(); 
                EON_OFSC_Resource_Management_WS.GetUserResponseElement response= request.get_user(authNodeElement,'soap');
                
                ofscTracker.Response_Data__c = string.ValueOf(response);
                ofscTracker.Status__c = EON_Utility.RESULT_PASS;
                return ofscTracker;
            } 
             catch(exception ex){ofscTracker.Status__c ='FAIL';ofscTracker.Response_Data__c = ex.getMessage();return ofscTracker;}
        }
}