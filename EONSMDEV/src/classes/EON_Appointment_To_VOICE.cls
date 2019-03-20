/**
    Description : 

    Test Class  : 
**/
/* 
Created By  : 
Created On  : 
Service Req : 
*/

@RestResource(urlMapping='/EONAppointmentToVoice/*')
global with sharing class EON_Appointment_To_VOICE {
     public static RestResponse res;
     private static String soapNS = 'https://eonsmdev-morrisonus.cs83.force.com/apptovoice/services/v1/rest/EONAppointmentToVoice/';
     @Httppost
     global static void doGet() {
        system.debug('I am at doGet');
            RestRequest req = RestContext.request;
            System.debug('########TAB req: '+req);
            RestResponse res = RestContext.response;
            String AppointmentId= req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            system.debug('AppointmentId'+AppointmentId);
            //EON_Appointment_Voice_process.sendInfoToVOICE_EmailService(AppointmentId);
            //string test='hai';
            // res.responseBody = Blob.valueOf(createSoapFault('soapenv:Client','Received sucessfully.','formName','wmFormId'));
            //string test=createSoapFault('123456','HaiZensar','WMNane','1234567899');
            
            // res.statusCode = 200;
             //res.addHeader('Content-Type','application/json');
             //res.responseBody = Blob.valueOf('{"Message" : "Success"}');
             res.responseBody = Blob.valueOf(createSoapFault('soapenv:Client','Received sucessfully.','formName','wmFormId'));
            
            
          //return null;
       }
        
      /**
        createSoapFault(String code, String message) - This method generates a response element to be sent back.
    **/
    private static string createSoapFault(String code, String message, String WMFormName, String formId)
    {   /*
          Dom.Document domResponse = new Dom.Document();
          Dom.XmlNode env = domResponse.createRootElement('Envelope', 'soapNS', 'soapenv');
          Dom.XmlNode fault = env.addChildElement('Body', 'soapNS', null).addChildElement('Fault', 'soapNS', null).addChildElement('ReceiveDataResponse', 'soapNS', null);
          fault.addChildElement('faultcode', null, null).addTextNode(((code != null)?code:''));
          fault.addChildElement('WMFormName', null, null).addTextNode(((WMFormName != null)?'WMFormName':''));
          fault.addChildElement('Id', null, null).addTextNode(((formId != null)?formId:''));
          fault.addChildElement('OrganizationName', null, null).addTextNode('OrganizationName');
          fault.addChildElement('faultstring', null, null).addTextNode(((message != null)?message:''));
          return domResponse.toXmlString();
          */
          
           Dom.Document domResponse = new Dom.Document();
          Dom.XmlNode env = domResponse.createRootElement('Envelope', soapNS, 'soapenv');
          Dom.XmlNode fault = env.addChildElement('Body', soapNS, null).addChildElement('Fault', soapNS, null).addChildElement('ReceiveDataResponse', soapNS, null);
          fault.addChildElement('faultcode', null, null).addTextNode(((code != null)?code:''));
          fault.addChildElement('WMFormName', null, null).addTextNode(((WMFormName != null)?WMFormName:''));
          fault.addChildElement('Id', null, null).addTextNode(((formId != null)?formId:''));
          fault.addChildElement('OrganizationName', null, null).addTextNode('OrganizationName');
          fault.addChildElement('faultstring', null, null).addTextNode(((message != null)?message:''));
          return domResponse.toXmlString();
    }
}