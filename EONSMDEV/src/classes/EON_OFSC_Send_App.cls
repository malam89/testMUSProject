/**
    Created it for testing to get rid of the future call.
**/

/*
    Created By : Praveen G
    Created Date : 03-11-2016
    
    
*/

/*
   The urlMapping acts as an accessible endpoint and adds to the full URL used to call this web-service from an external point
*/
@RestResource(urlMapping = '/outboundEON2/')
global with sharing class EON_OFSC_Send_App {

    private static String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static String toaNS = 'urn:toatech:agent';

    @HttpPost
    global static void ReceiveData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        
        res.statusCode=200;
        
        
        Oracle_Data_Tracker__c ODT = new Oracle_Data_Tracker__c();
        insert ODT;
        
        
        String RESSSS = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">';
                RESSSS += '<soapenv:Body>';
        RESSSS += '<notificationsResponse xmlns="http://soap.sforce.com/2005/09/outbound">';
      RESSSS += '<Ack>true</Ack>';
        RESSSS += '</notificationsResponse>';
      RESSSS += '</soapenv:Body>';
    RESSSS += '</soapenv:Envelope>';
        
        
        Message_Response response = new message_response('1234', 'sent', 'Appointment updated with no technician');
        res.responseBody = Blob.valueOf(RESSSS);
        
        String appid = req.requestBody.toString();
        
        System.debug('********** test' );
        
        //EON_Utility.callOFSCAppointment('', 'CREATE', '', '', string.valueof(System.today()), '12:00-13:00', 'EON');
        System.debug('***** inside outboundEON2');
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
}