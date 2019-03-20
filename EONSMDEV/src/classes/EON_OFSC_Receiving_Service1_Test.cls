/**
    Description : The test class is used to cover following classes/triggers:
                  1)EON_OFSC_Receiving_Service
**/

/*
    Created By : Shruti Moghe
    Created Date : 14-Mar-2016
    Service Request :SR_EON_Mobile_008
    Change History:
    CH01 # SR_EON_Mobile_010 # Dharmendra Pahadiya # 01/04/2016 # Added new method to increase coverage.
    CH02 # SR_EON_Mobile_011 # Puneet Mehta # 06/04/2016 # Added changes for new subject / command.
    CH03 # SR_EON_Mobile_015 # Purvi # 07/04/2016 # Added changes for new subject / command.
    CH04 # SR_EON_Mobile_016 # Purvi # 08/04/2016 # Added changes for new subject / command.
    
*/

@isTest(SeeAllData=false)
private class EON_OFSC_Receiving_Service1_Test{
    
    /**
        ReceiveData_PASS():- Postitive Unit test for the method ReceiveData()
    **/
    static testMethod void ReceiveData_PASS(){
        Test.startTest();
        //Instantiating the Rest Context 
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        system.debug(System.Label.EON_OFSC_Receiving_Service);
        req.requestURI = System.Label.EON_OFSC_Receiving_Service;//Request URL changes in Production and NSB, EONSM - https://eonsm-workmobile.cs87.force.com/fromOFSCtoIsis/services/apexrest/outboundEON 
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('<?xml version=\'1.0\' encoding=\'UTF-8\' ?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2015-05-01T13:37:01+00:00</now><company>musmrs.dev</company><login>app_user</login><auth_string>d15652443da8d6e9a0f8fc4e82810490</auth_string></user><messages><message><app_host>ed1dev07.etadirect.com</app_host><app_port>12201</app_port><app_url>/outbound/</app_url><company_name>mus</company_name><message_id></message_id><address></address><send_to>2015-05-01 14:35:53</send_to><trigger>add</trigger><fault_attempt>0</fault_attempt><sent_attempt>0</sent_attempt><subject>Activity Assigned</subject><body></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>');
        RestContext.request = req;
        RestContext.response = res;
        EON_OFSC_Receiving_Service1.ReceiveData();//Call the Method of the Class
        Test.stopTest();
        List<Oracle_Data_Tracker__c> dataTrackerList = new List<Oracle_Data_Tracker__c>();
        dataTrackerList = [select id,Status__c from Oracle_Data_Tracker__c LIMIT 1];
        system.debug(dataTrackerList);
        System.assertEquals(dataTrackerList[0].Status__c,'PASS');
    }
    /**
        ReceiveData_FAIL() :- Negative Unit test for the method ReceiveData()
    **/
    static testMethod void ReceiveData_FAIL(){
        Test.startTest();
        //Instantiating the Rest Context 
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        system.debug(System.Label.EON_OFSC_Receiving_Service);
        req.requestURI = System.Label.EON_OFSC_Receiving_Service;//Request URL changes in Production and NSB  EONSM - https://eonsm-workmobile.cs87.force.com/fromOFSCtoIsis/services/apexrest/outboundEON 
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('version=\'1.0\' encoding=\'UTF-8\' ?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2015-05-01T13:37:01+00:00</now><company>musmrs.dev</company><login>app_user</login><auth_string>d15652443da8d6e9a0f8fc4e82810490</auth_string></user><messages><message><app_host>ed1dev07.etadirect.com</app_host><app_port>12201</app_port><app_url>/outbound/</app_url><company_name>mus</company_name><message_id></message_id><address></address><send_to>2015-05-01 14:35:53</send_to><trigger>add</trigger><fault_attempt>0</fault_attempt><sent_attempt>0</sent_attempt><subject>Activity Assigned</subject><body></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>');
        RestContext.request = req;
        RestContext.response = res;
        EON_OFSC_Receiving_Service1.ReceiveData();//Call the Method of the Class
        Test.stopTest();
        List<Oracle_Data_Tracker__c> dataTrackerList = new List<Oracle_Data_Tracker__c>();
        dataTrackerList = [select id,Status__c from Oracle_Data_Tracker__c LIMIT 1];
        system.debug(dataTrackerList);
        System.assertEquals(dataTrackerList[0].Status__c,'FAIL');  
    }

    /**
        ReceiveData_CreditMeterReading():- Unit test for subject CreditMeterReading
    **/
    static testMethod void ReceiveData_CreditMeterReading(){
        Test.startTest();
        //Instantiating the Rest Context 
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        system.debug(System.Label.EON_OFSC_Receiving_Service);
        req.requestURI = System.Label.EON_OFSC_Receiving_Service;//Request URL changes in Production and NSB  EONSM - https://eonsm-workmobile.cs87.force.com/fromOFSCtoIsis/services/apexrest/outboundEON 
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:toatech:agent"><soapenv:Header /><soapenv:Body><urn:send_message><urn:user><urn:now>2016-04-01T15:50:23+00:00</urn:now><urn:login>user_name</urn:login><urn:company>company_name</urn:company><urn:auth_string>67c5900a04abc54132a52da8a2320be2</urn:auth_string></urn:user><urn:messages><urn:message><urn:app_host>service.example.com</urn:app_host><urn:app_port>443</urn:app_port><urn:app_url>/soap/</urn:app_url><urn:message_id>2006</urn:message_id><urn:address>someone@examplemail.com</urn:address><urn:send_to>2016-04-01 01:59:00</urn:send_to><urn:subject /><urn:body><CreditMeterReading><Header><OrgId>MorrisonID_001</OrgId><RequestId>MUSEON_000008</RequestId><RequestDateTime>2016-04-01 15:47(TBD)</RequestDateTime></Header><MeterData><MPAN>6464</MPAN><SerialNumber>1743561267345</SerialNumber><Registers><Register><RegisterId>18348</RegisterId><RegisterRead /></Register><Register><RegisterId>2894</RegisterId><RegisterRead /></Register><Register><RegisterId>2895</RegisterId><RegisterRead /></Register><Register><RegisterId>2896</RegisterId><RegisterRead /></Register><Register><RegisterId>2897</RegisterId><RegisterRead /></Register><Register><RegisterId>2898</RegisterId><RegisterRead /></Register></Registers></MeterData><MeterData><MPRN>698</MPRN><SerialNumber>2354123545</SerialNumber><Registers><Register><RegisterId>2899</RegisterId><RegisterRead /></Register></Registers></MeterData></CreditMeterReading></urn:body></urn:message></urn:messages></urn:send_message></soapenv:Body></soapenv:Envelope>');
        RestContext.request = req;
        RestContext.response = res;
        EON_OFSC_Receiving_Service1.ReceiveData();//Call the Method of the Class
        Test.stopTest();
        List<Oracle_Data_Tracker__c> dataTrackerList = new List<Oracle_Data_Tracker__c>();
        dataTrackerList = [select id,Status__c from Oracle_Data_Tracker__c LIMIT 1];
        system.debug(dataTrackerList);
        System.assertEquals(dataTrackerList[0].Status__c,'PASS');
    }
    //CH02.START
    /**
        ReceiveData_PrePayMeterBalance():- Unit test for subject CreditMeterReading
    **/
    static testMethod void ReceiveData_PrePayMeterBalance(){
        Test.startTest();
        //Instantiating the Rest Context 
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        system.debug(System.Label.EON_OFSC_Receiving_Service);
        req.requestURI = System.Label.EON_OFSC_Receiving_Service;//Request URL changes in Production and NSB  EONSM - https://eonsm-workmobile.cs87.force.com/fromOFSCtoIsis/services/apexrest/outboundEON 
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:toatech:agent"><soapenv:Header></soapenv:Header><soapenv:Body><urn:send_message><urn:user><urn:now>2016-04-01T15:50:23+00:00</urn:now><urn:login>user_name</urn:login><urn:company>company_name</urn:company><urn:auth_string>67c5900a04abc54132a52da8a2320be2</urn:auth_string></urn:user><urn:messages><urn:message><urn:app_host>service.example.com</urn:app_host><urn:app_port>443</urn:app_port><urn:app_url>/soap/</urn:app_url><urn:message_id>2006</urn:message_id><urn:address>someone@examplemail.com</urn:address><urn:send_to>2016-04-01 01:59:00</urn:send_to><urn:subject></urn:subject><urn:body><PrePayMeterBalance><Header><OrgId>MorrisonID_001</OrgId><RequestId>MUSEON_000008</RequestId><RequestDateTime>2016-01-18 15:47(TBD)</RequestDateTime></Header><BalanceData><DeviceType>ELECMETER</DeviceType><MPAN>6464</MPAN><SerialNumber>1743561267345</SerialNumber><CurrentBalance></CurrentBalance><TotalDebt></TotalDebt></BalanceData><BalanceData><DeviceType>GASMETER</DeviceType><MPRN>698</MPRN><SerialNumber>2354123545</SerialNumber><CurrentBalance></CurrentBalance><TotalDebt></TotalDebt></BalanceData></PrePayMeterBalance></urn:body></urn:message></urn:messages></urn:send_message></soapenv:Body></soapenv:Envelope>');
        RestContext.request = req;
        RestContext.response = res;
        EON_OFSC_Receiving_Service1.ReceiveData();//Call the Method of the Class
        Test.stopTest();
        List<Oracle_Data_Tracker__c> dataTrackerList = new List<Oracle_Data_Tracker__c>();
        dataTrackerList = [select id,Status__c from Oracle_Data_Tracker__c LIMIT 1];
        system.debug(dataTrackerList);
        System.assertEquals(dataTrackerList[0].Status__c,'PASS');
    }
    //CH02.END
    
    //CH03.START
    /**
        ReceiveData_SMSAssetValidation():- Unit test for subject CreditMeterReading
    **/
    static testMethod void ReceiveData_SMSAssetValidation(){
        Test.startTest();
        //Instantiating the Rest Context 
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        system.debug(System.Label.EON_OFSC_Receiving_Service);
        req.requestURI = System.Label.EON_OFSC_Receiving_Service;//Request URL changes in Production and NSB  EONSM - https://eonsm-workmobile.cs87.force.com/fromOFSCtoIsis/services/apexrest/outboundEON 
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:toatech:agent"><soapenv:Header></soapenv:Header><soapenv:Body><urn:send_message><urn:user><urn:now>2016-04-01T15:50:23+00:00</urn:now><urn:login>user_name</urn:login><urn:company>company_name</urn:company><urn:auth_string>67c5900a04abc54132a52da8a2320be2</urn:auth_string></urn:user><urn:messages><urn:message><urn:app_host>service.example.com</urn:app_host><urn:app_port>443</urn:app_port><urn:app_url>/soap/</urn:app_url><urn:message_id>2006</urn:message_id><urn:address>someone@examplemail.com</urn:address><urn:send_to>2016-04-01 01:59:00</urn:send_to><urn:subject></urn:subject><urn:body><SMSAssetValidation><Header><OrgId>MorrisonID_001</OrgId><RequestId>MUSEON_000008</RequestId><RequestDateTime>2016-01-18 15:47(TBD)</RequestDateTime></Header><BalanceData><DeviceType>ELECMETER</DeviceType><MPAN>6464</MPAN><SerialNumber>1743561267345</SerialNumber><CurrentBalance></CurrentBalance><TotalDebt></TotalDebt></BalanceData><BalanceData><DeviceType>GASMETER</DeviceType><MPRN>698</MPRN><SerialNumber>2354123545</SerialNumber><CurrentBalance></CurrentBalance><TotalDebt></TotalDebt></BalanceData></SMSAssetValidation></urn:body></urn:message></urn:messages></urn:send_message></soapenv:Body></soapenv:Envelope>');
        RestContext.request = req;
        RestContext.response = res;
        EON_OFSC_Receiving_Service1.ReceiveData();//Call the Method of the Class
        Test.stopTest();
        List<Oracle_Data_Tracker__c> dataTrackerList = new List<Oracle_Data_Tracker__c>();
        dataTrackerList = [select id,Status__c from Oracle_Data_Tracker__c LIMIT 1];
        system.debug(dataTrackerList);
        System.assertEquals(dataTrackerList[0].Status__c,'PASS');
    }
    //CH03.END
    
    //CH04.START
    /**
        ReceiveData_SMSAssetConfiguration():- Unit test for subject CreditMeterReading
    **/
    static testMethod void ReceiveData_SMSAssetConfiguration(){
        Test.startTest();
        //Instantiating the Rest Context 
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        system.debug(System.Label.EON_OFSC_Receiving_Service);
        req.requestURI = System.Label.EON_OFSC_Receiving_Service;//Request URL changes in Production and NSB  EONSM - https://eonsm-workmobile.cs87.force.com/fromOFSCtoIsis/services/apexrest/outboundEON 
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:toatech:agent"><soapenv:Header></soapenv:Header><soapenv:Body><urn:send_message><urn:user><urn:now>2016-04-01T15:50:23+00:00</urn:now><urn:login>user_name</urn:login><urn:company>company_name</urn:company><urn:auth_string>67c5900a04abc54132a52da8a2320be2</urn:auth_string></urn:user><urn:messages><urn:message><urn:app_host>service.example.com</urn:app_host><urn:app_port>443</urn:app_port><urn:app_url>/soap/</urn:app_url><urn:message_id>2006</urn:message_id><urn:address>someone@examplemail.com</urn:address><urn:send_to>2016-04-01 01:59:00</urn:send_to><urn:subject></urn:subject><urn:body><SMSAssetConfiguration><Header><OrgId>MorrisonID_001</OrgId><RequestId>MUSEON_000008</RequestId><RequestDateTime>2016-01-18 15:47(TBD)</RequestDateTime></Header><BalanceData><DeviceType>ELECMETER</DeviceType><MPAN>6464</MPAN><SerialNumber>1743561267345</SerialNumber><CurrentBalance></CurrentBalance><TotalDebt></TotalDebt></BalanceData><BalanceData><DeviceType>GASMETER</DeviceType><MPRN>698</MPRN><SerialNumber>2354123545</SerialNumber><CurrentBalance></CurrentBalance><TotalDebt></TotalDebt></BalanceData></SMSAssetConfiguration></urn:body></urn:message></urn:messages></urn:send_message></soapenv:Body></soapenv:Envelope>');
        RestContext.request = req;
        RestContext.response = res;
        EON_OFSC_Receiving_Service1.ReceiveData();//Call the Method of the Class
        Test.stopTest();
        List<Oracle_Data_Tracker__c> dataTrackerList = new List<Oracle_Data_Tracker__c>();
        dataTrackerList = [select id,Status__c from Oracle_Data_Tracker__c LIMIT 1];
        system.debug(dataTrackerList);
        System.assertEquals(dataTrackerList[0].Status__c,'PASS');
    }
    //CH04.END
}