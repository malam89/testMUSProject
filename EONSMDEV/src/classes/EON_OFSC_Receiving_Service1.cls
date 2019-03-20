/**
    Description : OFSC Receiving Service class that will receive the request from OFSC and process the same in object.
    Test Class: EON_OFSC_Receiving_Service_Test
**/

/*
    Created By : Shruti Moghe
    Created Date : 11-Mar-2016
    Service Request :SR_EON_Mobile_008
    Change History:
    CH01 # SR_EON_Mobile_010 # Dharmendra Pahadiya # 01/04/2016 # Update response, populated field values based on the xml.
    CH02 # SR_EON_Mobile_011 # Puneet Mehta # 06/04/2016 # Updated subject.
    CH03 # SR_EON_Mobile_015 # Purvi # 07/04/2016 # Updated subject.    
    CH04 # SR_EON_Mobile_016 # Purvi # 08/04/2016 # Updated subject.    
    
*/

/*
   The urlMapping acts as an accessible endpoint and adds to the full URL used to call this web-service from an external point
*/
@RestResource(urlMapping = '/outboundEON1/*')
global with sharing class EON_OFSC_Receiving_Service1 {
    public static Oracle_Data_Tracker__c dataTracker;
    public static Map < String, String > tagText = new Map < String, String > ();
    public static String subject = ''; //CH01
    /**
        ReceiveData() - HttpPost method is used to capture a HttpPost request has been sent to our rest apex class.
                        Used to retrieve data coming in the request body and performing corresponding actions.
                        This method receives the incoming request and processes it.
    **/
    @HttpPost
    global static void ReceiveData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String response = '';
        String messageId = ''; //CH01
        response = processData(req);
        res.statusCode = 200;
        res.addHeader('Content-Type', 'text/xml; charset=utf-8'); 
        //CH01.start 
        if (tagText != null && tagText.size() > 0 && tagText.containsKey('message_id')) {
            messageId = tagText.get('message_id');
        }
        //CH01.end
        String responseXML = '';
        responseXML = createSoapResponse(response, messageId);//CH01 - Added messageId
        if(response=='Request has been processed')
            dataTracker = new Oracle_Data_Tracker__c(Command__c=(subject!=''?subject:'OFSC_Isis')/*'OFSC_Isis'*/,Transaction_ID__c =messageId,Direction__c='IN',Request_Data__c=req.requestBody.toString().unescapeXml(),Response_Data__c=responseXML,Status__c='PASS');
        else
            dataTracker = new Oracle_Data_Tracker__c(Command__c='OFSC_Isis',Direction__c='IN',Request_Data__c=req.requestBody.toString().unescapeXml(),Response_Data__c=responseXML,Status__c='FAIL');
        insert dataTracker;
        EON_Utility.createAttachment(dataTracker.id,req.requestBody.toString().unescapeXml(),'Request');
        res.responseBody = Blob.valueOf(responseXML);
    }
    /**
        createSoapResponse(String response) - This method sends the response back to OFSC
    **/
    public static string createSoapResponse(String response, String messageId) {//CH01 - Added messageId
        String responseXML = '';
        //CH01.old //responseXML = '<?xml version="1.0" encoding="UTF-8" ?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:si="http://soapinterop.org/xsd" xmlns:ns1="http://toatech.com/toa-soap/1.0/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:send_message_response><message_response><message_id></message_id><status>sent</status><description>' + response + '</description></message_response></ns1:send_message_response></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        responseXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:toatech:agent"><soapenv:Header /><soapenv:Body><urn:send_message_response><urn:message_response><urn:message_id>'+messageId+'</urn:message_id><urn:status>sent</urn:status><urn:description>'+response+'</urn:description></urn:message_response></urn:send_message_response></soapenv:Body></soapenv:Envelope>'; //CH01.New
        return responseXML;
    }
    /**
        processData(RestRequest req) - This method processes the request received.
    **/
    public static String processData(RestRequest req) {
        String attName = '';
        String CurrentTagValue = '';
        DOM.Document doc = new DOM.Document();
        String response = '';
        try {
            doc.load(req.requestBody.toString().unescapeXml()); 
            parseXMLTags(doc.getRootElement()); //CH01
            response = 'Request has been processed';
            return response;
        }catch (Exception e) {
            response += '  Error: ' + e.getMessage();
            return response;
        }
    }

    //CH01
    public static void parseXMLTags(DOM.XmlNode node) {
        if (node.getNodeType() == DOM.XmlNodeType.ELEMENT) {
            String currentTag = node.getName();
            system.debug('==>> ' + currentTag);
            //Fetching the values by using the getText().trim() method
            tagText.put(currentTag, node.getText().trim());
            system.debug('==>> ' + currentTag + ' = ' + tagText.get(currentTag));
            for (DOM.XmlNode nextTag: node.getChildElements()) {
                if(nextTag.getName() == 'CreditMeterReading')
                    subject = 'CreditMeterReading';
                if(nextTag.getName() == 'PrePayMeterBalance')//CH02
                    subject = 'PrePayMeterBalance';//CH02
                if(nextTag.getName() == 'SMSAssetValidation')//CH03
                    subject = 'SMSAssetValidation';//CH03
                if(nextTag.getName() == 'SMSAssetConfiguration')//CH04
                    subject = 'SMSAssetConfiguration';//CH04
                parseXMLTags(nextTag);
            }//Recursive call
        }
    }
}