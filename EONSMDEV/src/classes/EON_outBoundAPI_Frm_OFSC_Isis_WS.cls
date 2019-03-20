/**
    Description : This class will be used for generating WSDL, so that OFSC can use this push statuses updates related to cancellation of activity using send_message operation to Isis.
                  
    Test Class  : EON_outboundAPI_frm_OFSC_Isis_WS_test

**/
/*
    Created By  : Akshay Bairagi
    Created On  : 01/04/2016 
    Service Req : SR_EON_Scheduling_008
    Change History
*/
global with sharing class EON_outBoundAPI_Frm_OFSC_Isis_WS {
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class user_t{  
        Webservice String now ;
        Webservice String company ;
        Webservice String login ;
        Webservice String auth_string;
    }  

    /**
        Description : Request Parameter 2
    **/
    global with sharing class message_t {  
        Webservice String app_host;
        Webservice long app_port ;
        Webservice String app_url ;
        Webservice long message_id ;
        Webservice long company_id;
        Webservice String address;
        Webservice String send_to;
        Webservice String subject;
        Webservice String body;
    }  
    /**
        Description : Request Parameter 3
    **/
    global with sharing class messageslist {  
        Webservice list<message_t> message;
    }  
    /**
        Description : Request Parameter 3
    **/
    global with sharing class send_message {  
        Webservice user_t user;     
        Webservice messageslist messages;
    }
    /**
        Description : Response 1
    **/
    global with sharing class message_response_t {
        Webservice long message_id ;
        Webservice string status ;
        Webservice String description ;
        Webservice String data ;
        Webservice String external_id ;
        Webservice String duration ;
        Webservice String sent ;        
    }
    /**
        Description : Response 3
    **/
    global with sharing class Isis_Response_To_OFSC{
        Webservice message_response_t message_response;
    }   
    /**
        Isis_Response_Acknowledgement_To_MIDOS OutBound_API(send_message) - 
                
    **/
    webservice static Isis_Response_To_OFSC OutBound_API(send_message send_message){ 
        
        Isis_Response_To_OFSC response = new Isis_Response_To_OFSC();
        Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c();
        message_response_t res = new message_response_t();
        oracleTracker.Direction__c = 'IN'; 
        oracleTracker.Command__c = 'Outbound_Sendmessage';
        string Error = '';
        try{
            if(send_message != null){
                oracleTracker.Request_Data__c = EON_Utility.validateStringLength(send_message + '');
                oracleTracker.Transaction_ID__c = 'Dummy Transaction ID'; 
                res.message_id = 123124;
                res.status = 'Dummy Status';
                res.description = 'Dummy description';
                response.message_response = res;
                oracleTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                oracleTracker.Status__c = EON_Utility.RESULT_PASS;     
            } 
            else{
                Error = 'Request Not Found';
                oracleTracker.Request_Data__c = 'Blank Request';
                oracleTracker.Response_Data__c = Error;
                oracleTracker.Status__c = EON_Utility.RESULT_FAIL; 
            }
        }catch(Exception ex){
            Error = ex.getmessage();
            oracleTracker.Request_Data__c = EON_Utility.validateStringLength(send_message + '');
            oracleTracker.Response_Data__c = Error;
            oracleTracker.Status__c = EON_Utility.RESULT_FAIL; 
            System.debug('**** Exception Occured '+ex.getmessage()+'----' + ex.getStackTraceString());
        }    
        insert oracleTracker;
        EON_Utility.createAttachment(oracleTracker.id, oracleTracker.Request_Data__c, oracleTracker.id);
        system.debug('---got here--');
        
        return response; 
        
    }                                                                   
}