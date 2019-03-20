/**
    Description : This class is used to receive the request from OFSC and process based on the subject.
        This class should have given permission to site - EON_OFSC
    TestClass : EON_OFSC_Receiving_Service_Test    
**/

/*
    Created Date : 08-April-2016
    Created By : Praveen G
    Service Request : SR_EON_Scheduling_017 / 018 / 019 / 20 / 21 / 27
                      SR_EON_Mobile_010 / 011 / 015 / 016
    Change History : CH01 # SR_EON_Mobile_019 # Dharmendra Pahadiya # 12/05/2016 # Added logic to send Credit Meter Reading to MIDOS
                     CH02 # SR_EON_Mobile_020  # 16/05/2016 # Shruti Moghe # added logic for SubmitPrePayBalance 
                     CH03 # SR_EON_Mobile_022 # Dharmendra Pahadiya # 20/05/2016 # Added logic to send Credit Meter Reading to MIDOS
                     CH04 # SR_EON_Mobile_021 # 24/05/2016 # Shruti Moghe # added logic for ValidateSMSAsset
                     CH05 # SR_OptiMUS_EON_177 # 25/01/2018 # Praveen G # Added new method for UnConfigureSMSAsset
                     CH06 # SR_OptiMUS_EON_192 # 25/01/2018 # Praveen G # Added fix for quiuing issue  
                     CH07 # SR_OptiMUS_EON_225 # 15/02/2018 # Praveen G # Added fix for quiuing issue
                     CH08 # SR_OptiMUS_EON_242 # 26/04/2018 # Shruti Moghe # updated the success Message for ValidateSMSAsset request
                     
*/
@RestResource(urlMapping = '/outboundEON/*')
global with sharing class EON_OFSC_Receiving_Service{

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
        if(System.Label.Is_Future == 'TRUE')
            receiveDataFromOFSC_Future(RestContext.request, RestContext.response);
        else
            receiveDataFromOFSC_Direct(RestContext.request, RestContext.response);      
    }
    
    /**
        processRequestData(RestRequest req, Id trackerID) - This method is used to process the OFSC request.
    **/
    //CH01.old //public static message_response processRequestData(Map<String, String> mapRequest, id orackeDataTrackerID){
    public static message_response processRequestData(Map<String, String> mapRequest, id orackeDataTrackerID, string req){ //CH01.New
        
        //For Status message updates      
        if(subject.equalsIgnoreCase('ASSIGN APPOINTMENT'))
           return EON_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, orackeDataTrackerID);
        else if(subject.equalsIgnoreCase('Start Appointment'))
            return EON_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest, orackeDataTrackerID);
        else if(subject.equalsIgnoreCase('Suspend Appointment'))
            return EON_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest, orackeDataTrackerID);
        else if(subject.equalsIgnoreCase('NotDone Appointment'))
            return EON_OFSC_Receiving_Helper.processSubjectAsNotDoneAppointment(mapRequest, orackeDataTrackerID);
        else if(subject.equalsIgnoreCase('Complete Appointment'))
            return EON_OFSC_Receiving_Helper.processSubjectAsCompleteAppointment(mapRequest, orackeDataTrackerID);
        else if(subject.equalsIgnoreCase('Cancel Appointment')){ //SR_EON_Scheduling_027
            EON_OFSC_Receiving_Helper.processSubjectAsCancelAppointment(mapRequest, orackeDataTrackerID); //SR_EON_Scheduling_033
            return new message_response('', 'sent', 'Successfully received request for Cancel Appointment'); // No Action take in Isis.            
        }   
        //For Commissioning
        else if(subject.equalsIgnoreCase('SubmitCreditMeterReading')){
                String appStatus=EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitCreditMeterReading', orackeDataTrackerID, req);//CH01
                if(appStatus=='found') return new message_response('', 'sent', 'Successfully received request for SubmitCreditMeterReading');
                else return new message_response('', 'failed', 'Appointment is not present in OptiMUS, Please contact your System Administrator');
        } 
        //for SubmitPrePayBalance
        else if(subject.equalsIgnoreCase('SubmitPrePayBalance')){
                String appStatus=EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitPrePayBalance', orackeDataTrackerID, req);//CH02
                if(appStatus=='found') return new message_response('', 'sent', 'Successfully received request for SubmitPrePayBalance');
                else return new message_response('', 'failed', 'Appointment is not present in OptiMUS, Please contact your System Administrator');              
        } 
        //for ValidateSMSAsset
        else if(subject.equalsIgnoreCase('ValidateSMSAsset')){ 
                String appStatus=EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ValidateSMSAsset', orackeDataTrackerID, req);//CH04
                if(appStatus=='found') return new message_response('', 'sent', 'Successfully received request for ValidateSMSAsset'); 
                else return new message_response('', 'failed', 'Appointment is not present in OptiMUS, Please contact your System Administrator');
        }
        else if(subject.equalsIgnoreCase('ConfigureSMSAsset')){ 
                String appStatus=EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ConfigureSMSAsset', orackeDataTrackerID, req);//CH03
                if(appStatus=='found') return new message_response('', 'sent', 'Successfully received request for ConfigureSMSAsset');
                else return new message_response('', 'failed', 'Appointment is not present in OptiMUS, Please contact your System Administrator');
        }       
        else    
            return new message_response('', 'failed', 'No subject found in request. Cannot process this request in Optimus');
    }    
    
    /**
        getSubjectFromRequest(RestRequest req) - This method is used to extract the subject value and body value from request.
    **/
    public Static Map<String, String> getSubjectANDValuesFromRequest(RestRequest req){
        Dom.Document domRequest=new Dom.Document();
        domRequest.load(req.requestBody.toString().unescapeXml().replace('&', '&amp;'));
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
                //mapTagValue.put(mbody.getAttributeValue(mbody.getAttributeKeyAt(0), mbody.getAttributeKeyNsAt(0)), mbody.getText()); 
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
        Description - Inner class to manage response to send to OFSC from EON ISIS.
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
    
    /**
        receiveDataFromOFSC_Future(RestRequest req, RestResponse res) - 
                        This is the main method executed, when OFSC sends requests for job statuses.    
    **/    
    public Static void receiveDataFromOFSC_Future(RestRequest pReq, RestResponse pRes){
        //These are the request and response elements which are handled internally by usning RestContext class.
        RestRequest req = pReq;
        RestResponse res = pRes; 
        Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c();  
        
        try{
            //Create Oracle data tracker record and attach the request XML 
            oracleTracker.Request_Data__c = Eon_Utility.validateStringLength(req.requestBody.toString().unescapeXml());
            oracleTracker.Direction__c = Eon_Utility.DIRECTION_IN;
            insert oracleTracker;        
            
            EON_Utility.createAttachment(oracleTracker.id, req.requestBody.toString(), oracleTracker.id+'.xml');
            
            Map<String, String> mapPropKeyValue = getSubjectANDValuesFromRequest(req);                                             
            //process the request
            //CH01.old // Message_Response response = processRequestData(mapPropKeyValue, oracleTracker.id);
            Message_Response response = processRequestData(mapPropKeyValue, oracleTracker.id, req.requestBody.toString()); //CH01.new
            response.message_id = messageID;
             
            res.statusCode=200;
            res.responseBody = Blob.valueOf(createSoapResponse(response)); 
            oracleTracker.Response_Data__c = res.responseBody.toString();  
            oracleTracker.Status__c = response.status=='sent'?EON_Utility.RESULT_PASS:EON_Utility.RESULT_FAIL; 
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
        receiveDataFromOFSC_Direct(RestRequest req, RestResponse res) - 
                        This is the main method executed, when OFSC sends requests for job statuses.    
    **/    
    public Static void receiveDataFromOFSC_Direct(RestRequest pReq, RestResponse pRes){
        //These are the request and response elements which are handled internally by usning RestContext class.
        RestRequest req = pReq;
        RestResponse res = pRes; 
        Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c();
            
            String req1 = pReq.requestBody.toString();
            Dom.Document docx = new Dom.Document();
            docx.load(req1);
            dom.XmlNode xroot = docx.getrootelement() ;
            
            
            Dom.Document domRequest=new Dom.Document();
            domRequest.load(req1.unescapeXml().replace('&', '&amp;'));            
            Dom.XmlNode envelope=domRequest.getRootElement();
            
            req1 = req1.unescapeXml();          
        
        try{
            
            //CH06.Start
            Map<String, String> mapPropKeyValue = getSubjectANDValuesFromRequest(req);
            boolean isTrue = true;
            String MIDOSID = null;
            String apptId= null;
            Message_Response response;
            if(subject == 'ConfigureSMSAsset' || subject =='ValidateSMSAsset'
                || subject =='UnConfigureSMSAsset'){
                isTrue = false;    
                if(subject.equalsIgnoreCase('ConfigureSMSAsset')){
                    apptId=   EOn_utility.isAppointmentFoundForCommissioning(pReq.requestBody.toString(),subject);

                    MIDOSID = EON_OFSC_to_MIDOS_Commissioning_Send.sendConfigAsset1(req1); 
                    if(MIDOSID != null) 
                        response = new message_response('', 'sent', 'Successfully received request for ConfigureSMSAsset');
                    else 
                        response = new message_response('', 'failed', 'Exception Occured, Please contact your System Administrator');                    
                }
                else if(subject.equalsIgnoreCase('ValidateSMSAsset')){
                    apptId= EOn_utility.isAppointmentFoundForCommissioning(pReq.requestBody.toString(), subject);

                    MIDOSID = EON_OFSC_to_MIDOS_Commissioning_Send.sendValidateSMSAsset1(req1);
                    if(MIDOSID != null) 
                        response = new message_response('', 'sent', 'Successfully received request for ValidateSMSAsset');//CH08 Old value = Successfully received request for ConfigureSMSAsset
                    else 
                        response = new message_response('', 'failed', 'Exception Occured, Please contact your System Administrator');                                    
                } 
                //CH05.Start
                else if(subject.equalsIgnoreCase('UnConfigureSMSAsset')){
                    apptId= EOn_utility.isAppointmentFoundForCommissioning(pReq.requestBody.toString(), subject);

                    MIDOSID = EON_OFSC_to_MIDOS_Commissioning_Send.sendUnConfigSMSAsset(req1);
                    if(MIDOSID != null) 
                        response = new message_response('', 'sent', 'Successfully received request for UnConfigureSMSAsset');
                    else 
                        response = new message_response('', 'failed', 'Exception Occured, Please contact your System Administrator');                                    
                }                
                //CH05.End               
            }
            //CH06.End
            
            
            //CH07.Start
            MIDOS_Data_Tracker__c MIDOSTRACKER1 = null;
            MIDOS_Data_Tracker__c MIDOSTRACKER2 = null;
            
            boolean isAppointmentUpdate = false;
            if(subject == 'SubmitCreditMeterReading' || subject =='SubmitPrePayBalance'){
                isTrue = false;
                if(subject == 'SubmitCreditMeterReading'){
                    apptId=   EOn_utility.isAppointmentFoundForCommissioning(pReq.requestBody.toString(),subject);
                    dom.XmlNode[] Header = envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElement('CreditMeterReading', toaNS).getChildElements();
                    
                    if(Header!=null){
                        dom.XmlNode[] CreditMeterReading= envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElement('CreditMeterReading', toaNS).getChildElements();
                        boolean mpan =false;
                        for(dom.XmlNode cnode: CreditMeterReading){ //To call the method to send data to MIDOS for multiple no of meters
                            if(cnode.getName().containsIgnoreCase('Header'))continue;
                            else if(cnode.getChildren()!=null){
                                for(Dom.XmlNode node : cnode.getChildElements()){
                                    if(subject.equalsIgnoreCase('SubmitCreditMeterReading')){
                                        if(node.getName().containsIgnoreCase('MPAN') && node.getText()!='' && node.getText()!=null){
                                            MIDOSTRACKER1 = EON_OFSC_to_MIDOS_Commissioning_Send.sendCreditMeter1(req1, 1);                                            
                                            Mpan=true;
                                            if(MIDOSTRACKER1 != null) 
                                                response = new message_response('', 'sent', 'Successfully received request for SubmitCreditMeterReading');
                                            else 
                                                response = new message_response('', 'failed', 'Exception Occured, Please contact your System Administrator');                    
                                                                    
                                            
                                            if(MIDOSTRACKER1 != null)
                                                isAppointmentUpdate = true;  
                                        }
                                        
                                    if(node.getName().containsIgnoreCase('MPRN') && node.getText()!='' && node.getText()!=null){
                                        if(Mpan){ //Create new MIDOS Data Tracker record for the more than one request to be sent to MIDOS.
                                            MIDOSTRACKER2 = EON_OFSC_to_MIDOS_Commissioning_Send.sendCreditMeter1(req1, 2);
                                            if(MIDOSTRACKER2 != null)
                                                isAppointmentUpdate = true;
                                                
                                                if(MIDOSTRACKER2 != null) 
                                                    response = new message_response('', 'sent', 'Successfully received request for SubmitCreditMeterReading');
                                                else 
                                                    response = new message_response('', 'failed', 'Exception Occured, Please contact your System Administrator');                    
                                                                            
                                                                                        
                                        }                                        
                                        
                                    }                                          
                                                                                
                                    }
                                }
                            }

                        }
                        
                    }
                } else if(subject == 'SubmitPrePayBalance'){
                    apptId=   EOn_utility.isAppointmentFoundForCommissioning(pReq.requestBody.toString(),subject);
                    dom.XmlNode[] Header = envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElement('PrePayMeterBalance', toaNS).getChildElements();
                    
                    if(Header!=null){
                        dom.XmlNode[] CreditMeterReading= envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElement('PrePayMeterBalance', toaNS).getChildElements();
                        boolean mpan =false;
                        for(dom.XmlNode cnode: CreditMeterReading){ //To call the method to send data to MIDOS for multiple no of meters
                            
                            System.debug('**** CNODE OUTSIDE '+ cnode);
                            if(cnode.getName().containsIgnoreCase('Header'))continue;
                            else if(cnode.getChildren()!=null){
                                for(Dom.XmlNode node : cnode.getChildElements()){
                                    System.debug('**** CNODE INSIDE '+ cnode);
                                    
                                    if(subject.equalsIgnoreCase('SubmitPrePayBalance')){
                                        if(node.getName().containsIgnoreCase('MPAN') && node.getText()!='' && node.getText()!=null){
                                            MIDOSTRACKER1 = EON_OFSC_to_MIDOS_Commissioning_Send.sendPrePayBalance1(req1, 1);                                            
                                            Mpan=true;
                                            if(MIDOSTRACKER1 != null)
                                                isAppointmentUpdate = true;
                                                
                                            if(MIDOSTRACKER1 != null) 
                                                response = new message_response('', 'sent', 'Successfully received request for SubmitPrePayBalance');
                                            else 
                                                response = new message_response('', 'failed', 'Exception Occured, Please contact your System Administrator');                    
                                                
                                                  
                                        }
                                        
                                    if(node.getName().containsIgnoreCase('MPRN') && node.getText()!='' && node.getText()!=null){
                                        if(Mpan){ //Create new MIDOS Data Tracker record for the more than one request to be sent to MIDOS.
                                            MIDOSTRACKER2 = EON_OFSC_to_MIDOS_Commissioning_Send.sendPrePayBalance1(req1, 2);
                                            if(MIDOSTRACKER2 != null)
                                                isAppointmentUpdate = true; 
                                                
                                            if(MIDOSTRACKER2 != null) 
                                                response = new message_response('', 'sent', 'Successfully received request for SubmitPrePayBalance');
                                            else 
                                                response = new message_response('', 'failed', 'Exception Occured, Please contact your System Administrator');                    
                                                
                                                                                       
                                        }                                        
                                        
                                    }                                          
                                                                                
                                    }
                                }
                            }

                        }
                        
                    }
                }
                
                
            }
            //CH07.End
        
            //Create Oracle data tracker record and attach the request XML 
            oracleTracker.Request_Data__c = Eon_Utility.validateStringLength(req.requestBody.toString().unescapeXml());
            oracleTracker.Direction__c = Eon_Utility.DIRECTION_IN;
            if(apptId!=null) oracleTracker.EON_Appointment__c=apptId;
            insert oracleTracker; 
            
            //CH06.Start
            System.debug('****MIDOSID '+ MIDOSID);
            if(MIDOSID != null){
                MIDOS_Data_Tracker__c midosTracker = New MIDOS_Data_Tracker__c(id=MIDOSID);
                midosTracker.Oracle_Data_Tracker__c = oracleTracker.id;
                upsert midosTracker;
            }                       
            
            //CH07.Start
            System.debug('****MIDOSTRACKER1 '+ MIDOSTRACKER1);
            if(MIDOSTRACKER1 != null){
                MIDOSTRACKER1.Oracle_Data_Tracker__c = oracleTracker.id;
                upsert MIDOSTRACKER1;
                
            }
            System.debug('****MIDOSTRACKER2 '+ MIDOSTRACKER2);
            if(MIDOSTRACKER2 != null){
                MIDOSTRACKER2.Oracle_Data_Tracker__c = oracleTracker.id;
                upsert MIDOSTRACKER2;
            } 
            if(isAppointmentUpdate){
                EON_OFSC_to_MIDOS_Commissioning_Helper.updateAppointmentRec(apptId);
            }           
            //CH07.End
            
            //CH06.Start       
            
            EON_Utility.createAttachment(oracleTracker.id, req.requestBody.toString(), oracleTracker.id+'.xml');
            
            //Map<String, String> mapPropKeyValue = getSubjectANDValuesFromRequest(req);                                             
            //process the request
            //CH01.old // Message_Response response = processRequestData(mapPropKeyValue, oracleTracker.id);
            
            if(isTrue)
                response = processRequestData(mapPropKeyValue, oracleTracker.id, req.requestBody.toString()); //CH01.new
            
            response.message_id = messageID;
             
            res.statusCode=200;
            res.responseBody = Blob.valueOf(createSoapResponse(response)); 
            oracleTracker.Response_Data__c = res.responseBody.toString();  
            oracleTracker.Status__c = response.status=='sent'?EON_Utility.RESULT_PASS:EON_Utility.RESULT_FAIL; 
            oracleTracker.Command__c = subject;           
        }catch(Exception ex){
            res.statusCode=500;
            res.addHeader('Content-Type','text/xml');
            res.responseBody=Blob.valueOf(createSoapFault('soapenv:Client',ex.getMessage()+':'+ex.getStackTraceString()));
            oracleTracker.Response_Data__c =  res.responseBody.toString() + '';                
            System.debug('******Error ' + ex.getStackTraceString() + '\n' + ex.getMessage());
        }
        
        //if(oracleTracker.id != null)
            upsert oracleTracker;           
    }                              
}