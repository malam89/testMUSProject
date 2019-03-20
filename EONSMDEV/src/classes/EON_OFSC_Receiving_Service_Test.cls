/**
    Description : This test class covers the class
                EON_OFSC_Receiving_Service
                For each subject there will be one test method.
**/
/*
    Created By : Praveen G
    Created Date : 20-April-2016
    Service Request : SR_EON_Scheduling_017 / 18 / 19 / 20 / 21 / 27
    
    Change History : 
        CH01 # SR_OptiMUS_EON_192 # Praveen G # 30/01/2018 # Added new test methods
*/
@isTest
public with sharing class EON_OFSC_Receiving_Service_Test{
    
    /**
        unitTest1() - unitTest1 Success test case
    **/
    static testmethod void unitTest1(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>ASSIGN APPOINTMENT</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        System.assert(System.RestContext.response.statuscode == 200);
    }
    
    /**
        unitTest2() - unitTest2 Failure test case
    **/
    static testmethod void unitTest2(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>ASSIGN APPOINTMENT</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></message></body></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        //EON_OFSC_Receiving_Service.receiveDataFromOFSC();    
        //System.assert(System.RestContext.response.statuscode == 500);      
    } 
    
    /**
        unitTest3() - unitTest3 Success test case
    **/
    static testmethod void unitTest3(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>START APPOINTMENT</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        System.assert(System.RestContext.response.statuscode == 200);        
    }     
    
    /**
        unitTest4() - unitTest4 Success test case
    **/
    static testmethod void unitTest4(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>SUSPEND APPOINTMENT</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        System.assert(System.RestContext.response.statuscode == 200);        
    } 
    
    /**
        unitTest5() - unitTest5 Success test case
    **/
    static testmethod void unitTest5(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>NotDone Appointment</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        System.assert(System.RestContext.response.statuscode == 200);                
    }  
    
    /**
        unitTest6() - unitTest6 Success test case
    **/
    static testmethod void unitTest6(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>COMPLETE APPOINTMENT</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();   
        System.assert(System.RestContext.response.statuscode == 200);               
    }
    
    /**
        unitTest7() - unitTest7 Success test case
    **/
    static testmethod void unitTest7(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>CANCEL APPOINTMENT</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        System.assert(System.RestContext.response.statuscode == 200);                
    }  
    
    /**
        unitTest8() - unitTest8 Success test case
    **/
    static testmethod void unitTest8(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject></subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        System.assert(System.RestContext.response.statuscode == 200);                
    }   
    
    /**
        unitTest9() - unitTest9 Success test case
    **/
    static testmethod void unitTest9(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>SubmitCreditMeterReading</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        //System.assert(System.RestContext.response.statuscode == 200);                
    } 
     
    /**
        unitTest10() - unitTest10 Success test case
    **/
    static testmethod void unitTest10(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>SubmitPrePayBalance</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        //System.assert(System.RestContext.response.statuscode == 200);                
    }
    
    /**
        unitTest11() - unitTest11 Success test case
    **/
    static testmethod void unitTest11(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>ValidateSMSAsset</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        //System.assert(System.RestContext.response.statuscode == 200);                
    } 
    
    /**
        unitTest12() - unitTest12 Success test case
    **/
    static testmethod void unitTest12(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>ConfigureSMSAsset</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC();  
        //System.assert(System.RestContext.response.statuscode == 200);                
    } 
    
    //CH01.Start
    
    /**
        unitTest12() - unitTest12 Success test case
    **/
    static testmethod void unitTest13(){
        String requestBody = '';
        
        requestBody += '<?xml version="1.0" encoding="UTF-8"?>';
        requestBody += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent">';
        requestBody += '<SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent">';        
        requestBody += '<user><now>2012-02-20T10:13:22+00:00</now><company></company><login>app_user</login><auth_string>xxxxx</auth_string></user>';
        requestBody += '<messages><message><app_host>xxxx</app_host><app_port>xxxx</app_port><app_url>/outbound/</app_url><message_id>5002</message_id><company_id>2</company_id>';
        requestBody += '<address>external_system</address><send_to>2012-02-20 20:00:00</send_to><replyto>notify@etadirect.com</replyto><subject>ConfigureSMSAsset</subject>';
        requestBody += '<body><appointment_number>MUS - 0000001</appointment_number></body></message></messages>';
        requestBody += '</ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);
        EON_OFSC_Receiving_Service.receiveDataFromOFSC_Future(System.RestContext.request, 
                                                              System.RestContext.response); 
                                                              
        EON_OFSC_Receiving_Service.receiveDataFromOFSC_Future(null, 
                                                              System.RestContext.response);                                                                
         
    }
    
    /**
        unitTest14() - unitTest10 Success test case
    **/
    static testmethod void unitTest14(){
        String requestBody = '';
        EON_Appointment__c objApp = new EON_Appointment__c();
        insert objApp;
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);        
        
        requestBody ='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitPrepayBalance</subject><body><PrePayMeterBalance><Header><OrgId /><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><BalanceData><DeviceType>ELECMETER</DeviceType><MPAN>12345678</MPAN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>12</CurrentBalance><TotalDebt>11</TotalDebt></BalanceData><BalanceData><DeviceType>GASMETER</DeviceType><MPRN>12345678</MPRN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>13</CurrentBalance><TotalDebt>55</TotalDebt></BalanceData></PrePayMeterBalance></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';

        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC_Direct(System.RestContext.request, System.RestContext.response);  
    } 
    
    /**
        unitTest15() - unitTest9 Success test case
    **/
    static testmethod void unitTest15(){
        String requestBody = '';
        
        EON_Appointment__c objApp = new EON_Appointment__c();
        insert objApp;
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);        
        
        requestBody = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitCreditMeterReading</subject><body><CreditMeterReading><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-06-06 15:49</RequestDateTime></Header><MeterData><MPAN>1100007264332</MPAN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData><MeterData><MPRN>2200007264332</MPRN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData></CreditMeterReading></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';

        
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(requestBody);  
        EON_OFSC_Receiving_Service.receiveDataFromOFSC_Direct(System.RestContext.request, System.RestContext.response);  
    }       
    //CH01.End                                 
}