/**
    Description : This class is used to receive the request from OFSC and process based on the subject.
                  This class should have given permission to site - NGS_OFSC
    TestClass : NGS_OFSC_Receiving_Service_Test    
**/

/*
    Created By : Shruti Moghe
    Created Date : 23/03/2017
    Service Request : SR_OptiMUS_NG_013
    Change History : 
*/

@RestResource(urlMapping = '/outboundNGS/*')
global with sharing class NGS_OFSC_Receiving_Service{

    private static String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static String toaNS = 'urn:toatech:agent';
    private static String subject = '';
    private static Dom.XmlNode[] messageBody;
    private static string messageID = '';
    
    /**
        receiveDataFromOFSC() - This is the main method executed, when OFSC sends 
                        requests for job statuses.    
    **/
    @HttpPost
    global static void receiveDataFromOFSC(){
        //These are the request and response elements which are handled internally by usning RestContext class.
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response; 
        NGS_Oracle_Data_Tracker__c oracleTracker = new NGS_Oracle_Data_Tracker__c();  
        
        try{
            //Create Oracle data tracker record and attach the request XML 
            oracleTracker.Request_Data__c = Utility.validateStringLength(req.requestBody.toString().unescapeXml());
            oracleTracker.Direction__c = Utility.DIRECTION_IN;
            insert oracleTracker;        
            
            Utility.createAttachment(oracleTracker.id, req.requestBody.toString(), oracleTracker.id+'.xml');
            
            Map<String, String> mapPropKeyValue = getSubjectANDValuesFromRequest(req);                                             
            //process the request
            Message_Response response = processRequestData(mapPropKeyValue, oracleTracker.id, req.requestBody.toString()); //CH01.new
            response.message_id = messageID;
             
            res.statusCode=200;
            res.responseBody = Blob.valueOf(createSoapResponse(response)); 
            oracleTracker.Response_Data__c = res.responseBody.toString();  
            oracleTracker.Status__c = response.status=='sent'?Utility.RESULT_PASS:Utility.RESULT_FAIL; 
            oracleTracker.Command__c = subject;           
        }catch(Exception ex){
            res.statusCode=500;
            res.addHeader('Content-Type','text/xml');
            res.responseBody=Blob.valueOf(createSoapFault('soapenv:Client',ex.getMessage()+':'+ex.getStackTraceString()));
            oracleTracker.Response_Data__c =  res.responseBody.toString() + '';                
            System.debug('******Error ' + ex.getStackTraceString() + '\n' + ex.getMessage());
        }
        
        if(oracleTracker.id != null)
            update oracleTracker;   
    }
    
    /**
        processRequestData(RestRequest req, Id trackerID) - This method is used to process the OFSC request.
    **/
    public static message_response processRequestData(Map<String, String> mapRequest, id orackeDataTrackerID, string req){ //CH01.New
        
        //For Status message updates      
        if(subject.equalsIgnoreCase('ASSIGN APPOINTMENT'))
           return NGS_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, orackeDataTrackerID);
        /*else if(subject.equalsIgnoreCase('Start Appointment'))
            return NGS_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest, orackeDataTrackerID);
        else if(subject.equalsIgnoreCase('Suspend Appointment'))
            return NGS_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest, orackeDataTrackerID);
        else if(subject.equalsIgnoreCase('NotDone Appointment'))
            return NGS_OFSC_Receiving_Helper.processSubjectAsNotDoneAppointment(mapRequest, orackeDataTrackerID);
        else if(subject.equalsIgnoreCase('Complete Appointment'))
            return NGS_OFSC_Receiving_Helper.processSubjectAsCompleteAppointment(mapRequest, orackeDataTrackerID);
        else if(subject.equalsIgnoreCase('Cancel Appointment')){ //SR_NGS_Scheduling_027
            NGS_OFSC_Receiving_Helper.processSubjectAsCancelAppointment(mapRequest, orackeDataTrackerID); 
            return new message_response('', 'sent', 'Successfully received request for Cancel Appointment'); // No Action take in Isis.      
        }   
          */         
        else    
            return new message_response('', 'failed', 'No subject found in request. Cannot process this request in Optimus');
    }    
    
    /**
        getSubjectFromRequest(RestRequest req) - This method is used to extract the subject value and body value from request.
    **/
    public Static Map<String, String> getSubjectANDValuesFromRequest(RestRequest req){
    /*String xmlData = req.toString();
            xmlData= xmlData.replace('&lt;','<');
            xmlData = xmlData.replace('&gt;','>');
            xmlData = xmlData.replace('&quot;','"'); 
            xmlData = xmlData.replace('&amp;','&');                       
            xmlData = xmlData.replace('&apos;','\'');*/
        Dom.Document domRequest=new Dom.Document();
        domRequest.load(req.requestBody.toString().unescapeXml().replace('&', '&amp;'));
        //domRequest.load(xmlData.unescapeXml());
        Dom.XmlNode envelope=domRequest.getRootElement();
        
        Dom.XmlNode body=getNode(envelope,'Body',soapNS);envelope=null;
        Dom.XmlNode send_msg=getNode(body,'send_message',toaNS);body=null; 
        
        //get the child elements for <messages> tag
        Dom.XmlNode[] messages = getNode(send_msg,'messages',toaNS).getChildElements();
        
        //Map to store attribute value as key and tag value as value for tags inside <body>
        Map<String, String> mapTagValue = new Map<String, String>();        
        
        for(Dom.XmlNode message :messages){
            if(message.getName() != 'message')continue;

            messageID = getNode(message,'message_id',toaNS).getText();            
            subject = getNode(message,'subject',toaNS).getText();
            
            //get the child elements for <body>
            messageBody = getNode(message,'body',toaNS).getChildElements(); 
            
            for(Dom.XmlNode mbody : messageBody){
                system.debug('@@@ node name: '+mbody.getName() +' node value: '+ mbody.getText());   
                mapTagValue.put(mbody.getName(), mbody.getText().unescapeXml());//replace('&amp;', '&'));                                    
            }
        }
        return mapTagValue;           
    }
    
    /**
        getNode( Dom.XmlNode parent,String name, String ns) - This method is used to get the child elemets in the XML based on Parenet tag.    
    **/
    private static Dom.XmlNode getNode( Dom.XmlNode parent,String name, String ns){
        Dom.XmlNode node=parent.getChildElement(name,ns);  
        return node;
    } 
        
    /**
        createSoapFault(String code, String message) - This method is used to frame the http response to OFSC.
    **/
    private static string createSoapFault(String code, String message){
        Dom.Document domResponse = new Dom.Document();
        Dom.XmlNode env = domResponse.createRootElement( 'Envelope', soapNS, 'soapenv');
        Dom.XmlNode fault = env.addChildElement( 'Body', soapNS, null ).addChildElement( 'Fault', soapNS, null );
        fault.addChildElement( 'faultcode', null, null ).addTextNode(code);
        fault.addChildElement( 'faultstring', null, null ).addTextNode(message);
        
        return domResponse.toXmlString();
    }
    
    /**
        createSoapResponse(message_response response) - This method is used to frame the response message.
                                                         to send to OFSC.
    **/
    private static string createSoapResponse(message_response response){
        Dom.Document domResponse = new Dom.Document();
        Dom.XmlNode env = domResponse.createRootElement( 'Envelope', soapNS, 'soapenv' );
        Dom.XmlNode smr = env.addChildElement( 'Body', soapNS, null ).addChildElement( 'send_message_response', toaNS, 'ns1' );

        Dom.XmlNode msg_resp=smr.addChildElement( 'message_response', null, null );
        
        msg_resp.addChildElement( 'message_id', null, null ).addTextNode(response.message_id);
        msg_resp.addChildElement( 'status', null, null ).addTextNode(response.status);
        msg_resp.addChildElement( 'description', null, null ).addTextNode(response.description);
        //msg_resp.addChildElement( 'stop_further_attempts', null, null ).addTextNode('1');
        
        return domResponse.toXmlString();
    }
    
    /**
        Description - Inner class to manage response to send to OFSC from NGS ISIS.
    **/
    global class Message_Response{
    
        global string message_id;
        global string status;
        global string description;
        
        /**
            message_response_t(string message_id,string status,string description) - 
                Default parameterized constructor.    
        **/
        global message_response(string message_id,string status,string description){
            this.message_id=message_id;this.status=status;this.description=description;
        }
    }                         
}