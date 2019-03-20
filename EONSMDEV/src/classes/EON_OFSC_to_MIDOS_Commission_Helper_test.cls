/**
Description : This test class is for below classes.
        EON_OFSC_to_MIDOS_Commissioning_Helper
        EON_OFSC_to_MIDOS_Commissioning_Send
**/

/*
    Created By  : Dharmendra Pahadiya
    Created On  : 17/05/2016
    Service Req : SR_EON_Mobile_019
    Change History
    CH01 # SR_EON_Mobile_020  # 18/05/2016 # Shruti Moghe # added methods to cover logic for SubmitPrePayBalance
    CH02 # SR_EON_Mobile_022  # 20/05/2016 # Dharmendra Pahadiya # added methods to cover logic for ConfigureSMSAsset
    CH03 # SR_EON_Mobile_021  # 24/05/2016 # Shruti Moghe # added methods to cover logic for ValidateSMSAsset
    CH04 # SR_OptiMUS_EON_081 # 03/07/2017 # Praveen G # Added new method.
    CH05 # SR_OptiMUS_EON_192 # 30/01/2018 # Praveen G # Added new methods.
    CH06 # SR_OptiMUS_EON_225 # 23/02/2018 # Praveen G # Added new methods.
*/
@isTest
global with sharing class EON_OFSC_to_MIDOS_Commission_Helper_test implements HttpCalloutMock  {

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('Test');
        res.setStatusCode(200);
        return res;
    }
  public static string subject;
  
  /*
    SendtoMIDOS_CreditMeterBalance_test1() - To test success response for SubmitCreditMeterReading
  */
  static testmethod void SendtoMIDOS_CreditMeterBalance_test1(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitCreditMeterReading');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'SubmitCreditMeterReading';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitCreditMeterReading</subject><body><CreditMeterReading><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-06-06 15:49</RequestDateTime></Header><MeterData><MPAN>1100007264332</MPAN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData><MeterData><MPRN>2200007264332</MPRN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData></CreditMeterReading></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitCreditMeterReading', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(2,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_CreditMeterBalance_test1() - To test failure web service response for SubmitCreditMeterReading
  */
  static testmethod void SendtoMIDOS_CreditMeterBalance_test2(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitCreditMeterReading');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'SubmitCreditMeterReading';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitCreditMeterReading</subject><body><CreditMeterReading><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-06-06 15:49</RequestDateTime></Header><MeterData><MPAN>1100007264332</MPAN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData><MeterData><MPRN>2200007264332</MPRN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData></CreditMeterReading></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
    //test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitCreditMeterReading', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
   // system.assertEquals(2,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_CreditMeterBalance_test3() - To cover exception part
  */
  static testmethod void SendtoMIDOS_CreditMeterBalance_test3(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitCreditMeterReading');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'SubmitCreditMeterReading';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitCreditMeterReading</subject><body><CreditMeterRead><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-06-06 15:49</RequestDateTime></Header><MeterData><MPAN>1100007264332</MPAN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData><MeterData><MPRN>2200007264332</MPRN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData></CreditMeterRead></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitCreditMeterReading', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
   // system.assertEquals(0,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_CreditMeterBalance_test4() - To test success response for SubmitCreditMeterReading
  */
  static testmethod void SendtoMIDOS_CreditMeterBalance_test4(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitCreditMeterReading');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'SubmitCreditMeterReading';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitCreditMeterReading</subject><body><CreditMeterReading><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-06-06 15:49</RequestDateTime></Header><MeterData><MPAN>1100007264332</MPAN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData><MeterData><MPRN>2200007264332</MPRN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData></CreditMeterReading></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitCreditMeterReading', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name, Status__c from MIDOS_Data_Tracker__c limit 1]);
    //system.debug('$$$ final lstMidos[0].Status__c: '+lstMidos[0].Status__c);
   // system.assertEquals(EON_Utility.RESULT_PASS,lstMidos[0].Status__c);
  }
  
  /*
    SendtoMIDOS_CreditMeterBalance_test5() - To cover exception part
  */
  static testmethod void SendtoMIDOS_CreditMeterBalance_test5(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitCreditMeterReading');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'SubmitCreditMeterReading';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitCreditMeterReading</subject><body><CreditMeterReading><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-06-06 15:49</RequestDateTime></Header><MeterData><MPAN>1100007264332</MPAN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData><MeterData><MPRN>2200007264332</MPRN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData></CreditMeterReading></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    EON_Utility.genException = true;
    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitCreditMeterReading', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
   // system.assertEquals(2,lstMidos.size());
  }
  
  //CH01.start
  /*
    SendtoMIDOS_PrepayMeterBalance_test() - To test success response for SubmitPrepayMeterBalance
  */
  static testmethod void SendtoMIDOS_PrepayMeterBalance_test(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitPrePayBalance');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'SubmitPrePayBalance';
    //Request XML
    string req ='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitPrepayBalance</subject><body><PrePayMeterBalance><Header><OrgId /><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><BalanceData><DeviceType>ELECMETER</DeviceType><MPAN>12345678</MPAN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>12</CurrentBalance><TotalDebt>11</TotalDebt></BalanceData><BalanceData><DeviceType>GASMETER</DeviceType><MPRN>12345678</MPRN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>13</CurrentBalance><TotalDebt>55</TotalDebt></BalanceData></PrePayMeterBalance></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitPrePayBalance', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(2,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_PrepayMeterBalance_test1() - To cover exception part for SubmitPrePayBalance
  */
  static testmethod void SendtoMIDOS_PrepayMeterBalance_test1(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitPrePayBalance');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'SubmitPrePayBalance';
    //Request XML
    string req ='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitPrepayBalance</subject><body><PrePayMeterBalance><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><BalanceData><DeviceType>ELECMETER</DeviceType><MPAN>12345678</MPAN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>12</CurrentBalance><TotalDebt>11</TotalDebt></BalanceData><BalanceData><DeviceType>GASMETER</DeviceType><MPRN>12345678</MPRN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>13</CurrentBalance><TotalDebt>55</TotalDebt></BalanceData></PrePayMeterBalance></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
    //test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitPrePayBalance', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(2,lstMidos.size());
  }
  /*
    SendtoMIDOS_PrepayMeterBalance_test2() - To cover exception part for SubmitPrePayBalance
  */
  static testmethod void SendtoMIDOS_PrepayMeterBalance_test2(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitPrePayBalance');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'SubmitPrePayBalance';
    //Request XML
    string req ='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitPrepayBalance</subject><body><PrePayMeterBalance><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><BalanceData><DeviceType>ELECMETER</DeviceType><MPAN>12345678</MPAN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>12</CurrentBalance><TotalDebt>11</TotalDebt></BalanceData><BalanceData><DeviceType>GASMETER</DeviceType><MPRN>12345678</MPRN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>13</CurrentBalance><TotalDebt>55</TotalDebt></BalanceData></PrePayMeterBalance></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
 
    
    //test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitPrePayBalance', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(2,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_PrepayMeterBalance_test3() - To cover exception part for SubmitPrePayBalance
  */
  static testmethod void SendtoMIDOS_PrepayMeterBalance_test3(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitPrePayBalance');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'SubmitPrePayBalance';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2011-11-23T15:50:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><address>someone@examplemail.com</address><send_to>2011-11-24 01:59:00</send_to><subject>SubmitPrePayBalance</subject><body><PrePayMeterBalance><Header><RequestId>'+lstApp[0].Id+'</RequestId></Header><BalanceData><DeviceType>ELECMETER</DeviceType><MPAN>1100007264358</MPAN><SerialNumber>I00456789</SerialNumber><CurrentBalance>5.00</CurrentBalance><TotalDebt>150.00</TotalDebt></BalanceData><BalanceData><DeviceType>GASMETER</DeviceType><MPRN>1100007264358</MPRN><SerialNumber>I00456789</SerialNumber><CurrentBalance>6.00</CurrentBalance><TotalDebt>160.00</TotalDebt></BalanceData></PrePayMeterBalance></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitPrePayBalance', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name, Status__c from MIDOS_Data_Tracker__c limit 1]);
   // system.assertEquals(EON_Utility.RESULT_FAIL,lstMidos[0].Status__c);
  }
    //CH01.end
    
  //CH02.start
  /*
    SendtoMIDOS_SMSAssetConfiguration_test1() - To test success response for ConfigureSMSAsset
  */
  static testmethod void SendtoMIDOS_SMSAssetConfiguration_test1(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ConfigureSMSAsset');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ConfigureSMSAsset';
    //Request XML
    //string req = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>ConfigureSMSAsset</subject><body><SMSAssetConfiguration><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>a0A4E0000008JJrUAM</RequestId><RequestDateTime>2016-05-18 09:47</RequestDateTime></Header><Hub><AssetSubType /><AssetType /><SerialNumber>070122267</SerialNumber></Hub><ElectricMeter><AssetSubType /><AssetType /><SerialNumber>I00R000073</SerialNumber><MPAN>1100005911580</MPAN><SSC>0393</SSC><Registers><Register><RegisterId>01</RegisterId><TPR>00001</TPR></Register><Register><RegisterId>02</RegisterId><TPR>00002</TPR></Register><Register><RegisterId>03</RegisterId><TPR>00003</TPR></Register><Register><RegisterId>04</RegisterId><TPR>00004</TPR></Register><Register><RegisterId>05</RegisterId><TPR>00005</TPR></Register><Register><RegisterId>06</RegisterId><TPR>00006</TPR></Register></Registers></ElectricMeter><GasMeter><AssetSubType /><AssetType /><SerialNumber>A4K00009817030</SerialNumber><MPRN>9101878010</MPRN></GasMeter><IHD><AssetSubType /><AssetType /><SerialNumber>AA29817030</SerialNumber></IHD></SMSAssetConfiguration></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    String req='<?xml version="1.0" encoding="UTF-8"?> <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <SOAP-ENV:Body> <ns1:send_message xmlns="urn:toatech:agent"> <user> <now>2016-06-08T09:50:55+00:00</now> <company>'+ System.Label.EON_OFSC_Company +'</company> <login>app_user</login> <auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string> </user> <messages> <message> <app_host>app102.eta.test.ed5.etadirect.com</app_host> <app_port>11141</app_port> <app_url>/outbound/</app_url> <message_id>1240</message_id> <address /> <send_to>2016-06-08 10:49:47</send_to> <subject>ConfigureSMSAsset</subject> <body> <SMSAssetConfiguration> <Header> <OrgId>13254</OrgId> <RequestId>'+lstApp[0].Id+'</RequestId> <RequestDateTime>2016-05-18 09:47</RequestDateTime> </Header> <Hub> <AssetSubType>HUB</AssetSubType> <AssetType>HUB</AssetType> <SerialNumber>070122267</SerialNumber> </Hub> <ElectricMeter> <AssetSubType>ElectricMeter</AssetSubType> <AssetType>ElectricMeter</AssetType> <SerialNumber>I00R000073</SerialNumber> <MPAN>1100005911580</MPAN> <SSC>0393</SSC> <Registers> <Register> <RegisterId>01</RegisterId> <TPR>00001</TPR> </Register> <Register> <RegisterId>02</RegisterId> <TPR>00002</TPR> </Register> <Register> <RegisterId>03</RegisterId> <TPR>00003</TPR> </Register> <Register> <RegisterId>04</RegisterId> <TPR>00004</TPR> </Register> <Register> <RegisterId>05</RegisterId> <TPR>00005</TPR> </Register> <Register> <RegisterId>06</RegisterId> <TPR>00006</TPR> </Register> </Registers> </ElectricMeter> <GasMeter> <AssetSubType>GasMeter</AssetSubType> <AssetType>GasMeter</AssetType> <SerialNumber>A4K00009817030</SerialNumber> <MPRN>9101878010</MPRN> </GasMeter> <IHD> <AssetSubType>IHD</AssetSubType> <AssetType>IHD</AssetType> <SerialNumber>AA29817030</SerialNumber> </IHD> </SMSAssetConfiguration> </body> </message> </messages> </ns1:send_message> </SOAP-ENV:Body> </SOAP-ENV:Envelope> ';
    
    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ConfigureSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(1,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_SMSAssetConfiguration_test2() - To test failure response for ConfigureSMSAsset
  */
  static testmethod void SendtoMIDOS_SMSAssetConfiguration_test2(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ConfigureSMSAsset');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ConfigureSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-05-18T09:47:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><subject>ConfigureSMSAsset</subject><address>someone@examplemail.com</address><send_to>2016-05-18 09:47:00</send_to><body><SMSAssetConfiguration><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-05-18 09:47</RequestDateTime></Header><Hub><SerialNumber>070122267</SerialNumber></Hub><ElectricMeter><SerialNumber>I00R000073</SerialNumber><MPAN>1100005911580</MPAN><SSC>0393</SSC><Registers><Register><RegisterId>01</RegisterId><TPR>00001</TPR></Register><Register><RegisterId>02</RegisterId><TPR>00002</TPR></Register><Register><RegisterId>03</RegisterId><TPR>00003</TPR></Register><Register><RegisterId>04</RegisterId><TPR>00004</TPR></Register><Register><RegisterId>05</RegisterId><TPR>00005</TPR></Register><Register><RegisterId>06</RegisterId><TPR>00006</TPR></Register></Registers></ElectricMeter><GasMeter><SerialNumber>A4K00009817030</SerialNumber><MPRN>9101878010</MPRN></GasMeter><IHD><SerialNumber>AA29817030</SerialNumber></IHD></SMSAssetConfiguration></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    
    //test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ConfigureSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(1,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_SMSAssetConfiguration_test3() - To cover the exception part of SMSAssetConfiguration method
  */
  static testmethod void SendtoMIDOS_SMSAssetConfiguration_test3(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ConfigureSMSAsset');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ConfigureSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-05-18T09:47:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><subject>ConfigureSMSAsset</subject><address>someone@examplemail.com</address><send_to>2016-05-18 09:47:00</send_to><body><SMSAssetConfiguration><Header><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>test</RequestDateTime></Header><Hub><SerialNumber>070122267</SerialNumber></Hub><ElectricMeter><SerialNumber>I00R000073</SerialNumber><MPAN>1100005911580</MPAN><SSC>0393</SSC><Registers><Register><RegisterId>01</RegisterId><TPR>00001</TPR></Register><Register><RegisterId>02</RegisterId><TPR>00002</TPR></Register><Register><RegisterId>03</RegisterId><TPR>00003</TPR></Register><Register><RegisterId>04</RegisterId><TPR>00004</TPR></Register><Register><RegisterId>05</RegisterId><TPR>00005</TPR></Register><Register><RegisterId>06</RegisterId><TPR>00006</TPR></Register></Registers></ElectricMeter><GasMeter><SerialNumber>A4K00009817030</SerialNumber><MPRN>9101878010</MPRN></GasMeter><IHD><SerialNumber>AA29817030</SerialNumber></IHD></SMSAssetConfiguration></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';

    
    //test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ConfigureSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name, Status__c from MIDOS_Data_Tracker__c limit 1]);
    //system.assertEquals(EON_Utility.RESULT_FAIL,lstMidos[0].Status__c);
  }
  
  /*
    SendtoMIDOS_SMSAssetConfiguration_test4() - To cover exception
  */
  static testmethod void SendtoMIDOS_SMSAssetConfiguration_test4(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ConfigureSMSAsset');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ConfigureSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <SOAP-ENV:Body> <ns1:send_message xmlns="urn:toatech:agent"> <user> <now>2016-06-08T09:50:55+00:00</now> <company>'+ System.Label.EON_OFSC_Company +'</company> <login>app_user</login> <auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string> </user> <messages> <message> <app_host>app102.eta.test.ed5.etadirect.com</app_host> <app_port>11141</app_port> <app_url>/outbound/</app_url> <message_id>1240</message_id> <address></address> <send_to>2016-06-08 10:49:47</send_to> <subject>ConfigureSMSAsset</subject> <body> <SMSAssetConfiguration> <Header> <OrgId>'+lstApp[0].name+'</OrgId> <RequestId>'+lstApp[0].Id+'</RequestId> <RequestDateTime>2016-05-18 09:47</RequestDateTime> </Header> <Hub> <SerialNumber>070122267</SerialNumber> </Hub> <ElectricMeter> <SerialNumber>I00R000073</SerialNumber> <MPAN>1100005911580</MPAN> <SSC>0393</SSC> <Registers> <Register> <RegisterId>01</RegisterId> <TPR>00001</TPR> </Register> <Register> <RegisterId>02</RegisterId> <TPR>00002</TPR> </Register> <Register> <RegisterId>03</RegisterId> <TPR>00003</TPR> </Register> <Register> <RegisterId>04</RegisterId> <TPR>00004</TPR> </Register> <Register> <RegisterId>05</RegisterId> <TPR>00005</TPR> </Register> <Register> <RegisterId>06</RegisterId> <TPR>00006</TPR> </Register> </Registers> </ElectricMeter> <GasMeter> <SerialNumber>A4K00009817030</SerialNumber> <MPRN>9101878010</MPRN> </GasMeter> <IHD> <SerialNumber>AA29817030</SerialNumber> </IHD> </SMSAssetConfiguration> </body> </message> </messages> </ns1:send_message> </SOAP-ENV:Body> </SOAP-ENV:Envelope>';
    
    EON_Utility.genException = true;
    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ConfigureSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(1,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_test1() - To cover the exception part of convertStringToDatetime() method
  */
  static testmethod void SendtoMIDOS_test1(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ConfigureSMSAsset');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ConfigureSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-05-18T09:47:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><subject>ConfigureSMSAsset</subject><address>someone@examplemail.com</address><send_to>2016-05-18 09:47:00</send_to><body><SMSAssetConfiguration><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>test</RequestDateTime></Header><Hub><SerialNumber>070122267</SerialNumber><AssetSubType>HUB</AssetSubType> <AssetType>HUB</AssetType></Hub><ElectricMeter><AssetSubType>ElectricMeter</AssetSubType> <AssetType>ElectricMeter</AssetType><SerialNumber>I00R000073</SerialNumber><MPAN>1100005911580</MPAN><SSC>0393</SSC><Registers><Register><RegisterId>01</RegisterId><TPR>00001</TPR></Register><Register><RegisterId>02</RegisterId><TPR>00002</TPR></Register><Register><RegisterId>03</RegisterId><TPR>00003</TPR></Register><Register><RegisterId>04</RegisterId><TPR>00004</TPR></Register><Register><RegisterId>05</RegisterId><TPR>00005</TPR></Register><Register><RegisterId>06</RegisterId><TPR>00006</TPR></Register></Registers></ElectricMeter><GasMeter><AssetSubType>GasMeter</AssetSubType> <AssetType>GasMeter</AssetType><SerialNumber>A4K00009817030</SerialNumber><MPRN>9101878010</MPRN></GasMeter><IHD><SerialNumber>AA29817030</SerialNumber><AssetSubType>IHD</AssetSubType> <AssetType>IHD</AssetType></IHD></SMSAssetConfiguration></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
 
    
    //test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ConfigureSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(1,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_test2() - To cover the exception part of 
  */
  static testmethod void SendtoMIDOS_test2(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ConfigureSMSAsset');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ConfigureSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-05-18T09:47:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><subject>ConfigureSMSAsset</subject><address>someone@examplemail.com</address><send_to>2016-05-18 09:47:00</send_to><body /></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
    
    //test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ConfigureSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name, Status__c from MIDOS_Data_Tracker__c limit 1]);
    system.assertEquals(EON_Utility.RESULT_FAIL,lstMidos[0].Status__c);
  }
  
  /*
    SendtoMIDOS_test3() - To cover the EON_MIDOS_Send_Data_Schema_WS & EON_MIDOS_Send_Data_WS classes - for ProvideServiceStatus method
  */
  static testmethod void SendtoMIDOS_test3(){
    EON_MIDOS_Send_Data_Schema_WS.ServiceStatusRequestDto request_data = new EON_MIDOS_Send_Data_Schema_WS.ServiceStatusRequestDto();
    EON_MIDOS_Send_Data_Schema_WS.ServiceStatusResponseDto response = new EON_MIDOS_Send_Data_Schema_WS.ServiceStatusResponseDto();
    
    EON_OFSC_to_MIDOS_Commission_Helper_test.subject = 'ServiceStatus';
    test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_MIDOS_Send_Data_WS.CustomBinding_IOutOfAreaInstallationInboundService request = new EON_MIDOS_Send_Data_WS.CustomBinding_IOutOfAreaInstallationInboundService();
    response = request.ProvideServiceStatus(request_data);
    test.stopTest();
    
    system.assertEquals(0,response.Header.Status);
  }
  
  /*
    SendtoMIDOS_test4() - To cover the EON_MIDOS_Send_Data_Schema_WS & EON_MIDOS_Send_Data_WS classes
  */
  static testmethod void SendtoMIDOS_test4(){
    EON_MIDOS_Send_Data_Schema_WS.AssetDto asset_ele = new EON_MIDOS_Send_Data_Schema_WS.AssetDto();
    asset_ele.SerialNumber = '11111';
    asset_ele.AssetType = 'test';
    EON_MIDOS_Send_Data_Schema_WS.AssetDto[] arr_asset = new EON_MIDOS_Send_Data_Schema_WS.AssetDto[]{asset_ele};
    EON_MIDOS_Send_Data_Schema_WS.ArrayOfAssetDto arrAsset = new EON_MIDOS_Send_Data_Schema_WS.ArrayOfAssetDto();
    arrAsset.AssetDto = arr_asset;
    EON_MIDOS_Send_Data_Schema_WS.SmsAssetDto smsAsset = new EON_MIDOS_Send_Data_Schema_WS.SmsAssetDto();
    smsAsset.Assets = arrAsset;
    
    EON_MIDOS_Send_Data_Schema_WS.GenericFault genfault = new EON_MIDOS_Send_Data_Schema_WS.GenericFault();
    EON_MIDOS_Send_Data_Schema_WS.ResponseBaseDto resBase = new EON_MIDOS_Send_Data_Schema_WS.ResponseBaseDto();
    
    EON_MIDOS_Send_Data_Schema_WS.ValidateSmsAssetReponseDto valSmsAssetRes = new EON_MIDOS_Send_Data_Schema_WS.ValidateSmsAssetReponseDto();
  }
  
  /*
    SendtoMIDOS_ValidateSmsAsset_test1() - To test success response for ValidateSmsAsset
  */
  static testmethod void SendtoMIDOS_ValidateSmsAsset_test1(){
    EON_MIDOS_Send_Data_Schema_WS.AssetDto asset_ele = new EON_MIDOS_Send_Data_Schema_WS.AssetDto();
    asset_ele.SerialNumber = '11111';
    asset_ele.AssetType = 'test';
    EON_MIDOS_Send_Data_Schema_WS.AssetDto[] arr_asset = new EON_MIDOS_Send_Data_Schema_WS.AssetDto[]{asset_ele};
    EON_MIDOS_Send_Data_Schema_WS.ArrayOfAssetDto arrAsset = new EON_MIDOS_Send_Data_Schema_WS.ArrayOfAssetDto();
    arrAsset.AssetDto = arr_asset;
    EON_MIDOS_Send_Data_Schema_WS.MessageHeader mesHeader = new EON_MIDOS_Send_Data_Schema_WS.MessageHeader();
    EON_MIDOS_Send_Data_Schema_WS.SmsAssetDto req_data = new EON_MIDOS_Send_Data_Schema_WS.SmsAssetDto();
    req_data.Assets = arrAsset;
    req_data.Header = mesHeader;
    EON_MIDOS_Send_Data_WS.CustomBinding_IOutOfAreaInstallationInboundService request = new EON_MIDOS_Send_Data_WS.CustomBinding_IOutOfAreaInstallationInboundService();
    
    EON_OFSC_to_MIDOS_Commission_Helper_test.subject = 'ValidateSMSAsset';
    test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_MIDOS_Send_Data_Schema_WS.ValidateSmsAssetReponseDto response = request.ValidateSmsAsset(req_data);
    test.stopTest();
  }
  //CH02.end
  
  
  //CH03.start
  /*
    SendtoMIDOS_ValidateSMSAsset_test() - To test success response for ValidateSMSAsset
  */
  static testmethod void SendtoMIDOS_ValidateSMSAsset_test(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitPrePayBalance');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ValidateSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2011-11-23T15:50:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><address>someone@examplemail.com</address><send_to>2011-11-24 01:59:00</send_to><subject>ValidateSMSAsset</subject><body><SMSAssetValidation><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><Assets><Asset><AssetType>ELECMETER</AssetType><SerialNumber>201220131001</SerialNumber></Asset><Asset><AssetType>GASMETER</AssetType><SerialNumber>0801201404</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>201220131003</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>070120142</SerialNumber></Asset></Assets></SMSAssetValidation></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
   
    
    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ValidateSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(1,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_ValidateSMSAsset_test1() - To cover exception part for ValidateSMSAsset
  */
  static testmethod void SendtoMIDOS_ValidateSMSAsset_test11(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ValidateSMSAsset');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ValidateSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2011-11-23T15:50:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><address>someone@examplemail.com</address><send_to>2011-11-24 01:59:00</send_to><subject>ValidateSMSAsset</subject><body><SMSAssetValidation><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><Assets><Asset><AssetSubType /><AssetType>ELECMETER</AssetType><SerialNumber>201220131001</SerialNumber></Asset><Asset><AssetSubType /><AssetType>GASMETER</AssetType><SerialNumber>0801201404</SerialNumber></Asset><Asset><AssetSubType /><AssetType>HUB</AssetType><SerialNumber>201220131003</SerialNumber></Asset><Asset><AssetSubType /><AssetType>HUB</AssetType><SerialNumber>070120142</SerialNumber></Asset></Assets></SMSAssetValidation></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
    
    //test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ValidateSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(1,lstMidos.size());
  }
  /*
    SendtoMIDOS_ValidateSMSAsset_test3() - To cover exception part for ValidateSMSAsset
  */
  static testmethod void SendtoMIDOS_ValidateSMSAsset_test3(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ValidateSMSAsset');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ValidateSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <SOAP-ENV:Body> <ns1:send_message xmlns="urn:toatech:agent"> <user> <now>2016-06-08T09:50:55+00:00</now> <company>'+ System.Label.EON_OFSC_Company +'</company> <login>app_user</login> <auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string> </user> <messages> <message> <app_host>app102.eta.test.ed5.etadirect.com</app_host> <app_port>11141</app_port> <app_url>/outbound/</app_url> <message_id>1240</message_id> <address></address> <send_to>2016-06-08 10:49:47</send_to> <subject>ValidateSMSAsset</subject> <body> <SMSAssetValidation> <Header> <OrgId>'+lstApp[0].name+'</OrgId> <RequestId>'+lstApp[0].Id+'</RequestId> <RequestDateTime>2016-06-06 15:47</RequestDateTime> </Header> <Assets> <Asset> <AssetType>ELECMETER</AssetType> <SerialNumber>201220131001</SerialNumber> </Asset> <Asset> <AssetType>GASMETER</AssetType> <SerialNumber>0801201404</SerialNumber> </Asset> <Asset> <AssetType>HUB</AssetType> <SerialNumber>201220131003</SerialNumber> </Asset> <Asset> <AssetType>HUB</AssetType> <SerialNumber>070120142</SerialNumber> </Asset> </Assets> </SMSAssetValidation> </body> </message> </messages> </ns1:send_message> </SOAP-ENV:Body> </SOAP-ENV:Envelope>';
    
    //test.setMock(WebServiceMock.class, new EON_OFSC_to_MIDOS_Commissioning_Mock());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ValidateSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name, Status__c from MIDOS_Data_Tracker__c limit 1]);
    //system.assertEquals(EON_Utility.RESULT_FAIL,lstMidos[0].Status__c);
  }

   /*
    SendtoMIDOS_ValidateSMSAsset_test4() - To test exception response for ValidateSMSAsset
  */
  static testmethod void SendtoMIDOS_ValidateSMSAsset_test4(){
    //Create test data   
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ValidateSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2011-11-23T15:50:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><address>someone@examplemail.com</address><send_to>2011-11-24 01:59:00</send_to><subject>ValidateSMSAsset</subject><body><SMSAssetValidation><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><Assets><Asset><AssetType>ELECMETER</AssetType><SerialNumber>201220131001</SerialNumber></Asset><Asset><AssetType>GASMETER</AssetType><SerialNumber>0801201404</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>201220131003</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>070120142</SerialNumber></Asset></Assets></SMSAssetValidation></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
   
    test.startTest();
    try{
     Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ValidateSMSAsset');
    insert oracleTracker;
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ValidateSMSAsset',oracleTracker.id, req);
    }
    catch(Exception e){}
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(1,lstMidos.size());
  }
  
  /*
    SendtoMIDOS_ValidateSMSAsset_test5() - To cover exception part of ValidateSMSAsset
  */
  static testmethod void SendtoMIDOS_ValidateSMSAsset_test5(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitPrePayBalance');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ValidateSMSAsset';
    //Request XML
    string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2011-11-23T15:50:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><address>someone@examplemail.com</address><send_to>2011-11-24 01:59:00</send_to><subject>ValidateSMSAsset</subject><body><SMSAssetValidation><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><Assets><Asset><AssetType>ELECMETER</AssetType><SerialNumber>201220131001</SerialNumber></Asset><Asset><AssetType>GASMETER</AssetType><SerialNumber>0801201404</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>201220131003</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>070120142</SerialNumber></Asset></Assets></SMSAssetValidation></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
    
    EON_Utility.genException = true;
    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('ValidateSMSAsset', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(1,lstMidos.size());
  }
  
  static testmethod void EON_OFSC_to_MIDOS_Commission_Helper_Fail(){
    //Create test data
    Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitPrePayBalance');
    insert oracleTracker;
    
    EON_Appointment__c objApp = new EON_Appointment__c();
    insert objApp;
    
    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
    
    subject = 'ValidateSMSAsset';
    //Request XML
    string req = 'SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2011-11-23T15:50:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><address>someone@examplemail.com</address><send_to>2011-11-24 01:59:00</send_to><subject>SubmitPrePayBalance</subject><body><SMSAssetValidation><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><Assets><Asset><AssetType>ELECMETER</AssetType><SerialNumber>201220131001</SerialNumber></Asset><Asset><AssetType>GASMETER</AssetType><SerialNumber>0801201404</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>201220131003</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>070120142</SerialNumber></Asset></Assets></SMSAssetValidation></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
    EON_Utility.genException = true;
    Test.setMock(HttpCalloutMock.class, new EON_OFSC_to_MIDOS_Commission_Helper_test());
    test.startTest();
    EON_OFSC_to_MIDOS_Commissioning_Helper.SendtoMIDOS('SubmitPrePayBalance', oracleTracker.Id, req);
    test.stopTest();
    
    list<MIDOS_Data_Tracker__c> lstMidos = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where Appointment_Number__c =: lstApp[0].Id]);
    //system.assertEquals(1,lstMidos.size());
  }
  
  
    //CH03.end
    
    //CH04.Start
    static testmethod void unitTest4(){
        EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response = new 
                                        EON_OFSC_Inbound_WS.InboundInterfaceResponseElement();
                                        
        EON_OFSC_Inbound_WS.DataResponseElement dataElement = new EON_OFSC_Inbound_WS.DataResponseElement();
        EON_OFSC_Inbound_WS.CommandsResponseArray commands = new EON_OFSC_Inbound_WS.CommandsResponseArray();  
        List<EON_OFSC_Inbound_WS.CommandResponseElement> command = new 
                                        List<EON_OFSC_Inbound_WS.CommandResponseElement>();
                                        
        EON_OFSC_Inbound_WS.CommandResponseElement comman = new EON_OFSC_Inbound_WS.CommandResponseElement();                                        
                                        
        EON_OFSC_Inbound_WS.AppointmentResponseElement appointment = new 
                                EON_OFSC_Inbound_WS.AppointmentResponseElement();  
        EON_OFSC_Inbound_WS.ReportElement report = new EON_OFSC_Inbound_WS.ReportElement();
        
        List<EON_OFSC_Inbound_WS.ReportMessageElement> message = new 
                                List<EON_OFSC_Inbound_WS.ReportMessageElement>();
                                
        EON_OFSC_Inbound_WS.ReportMessageElement messag = new EON_OFSC_Inbound_WS.ReportMessageElement();
        EON_OFSC_Inbound_WS.ReportMessageElement messag1 = new EON_OFSC_Inbound_WS.ReportMessageElement();
        messag1.code = '1';
        messag.code = '0';
        messag1.result = 'error';
        message.add(messag); 
        message.add(messag1);
        
        report.message = message; 
        appointment.report = report;
        comman.appointment = appointment;
        command.add(comman);
        commands.command = command;
        dataElement.commands = commands;
        response.data = dataElement;
        
        EON_OFSC_Response_Code__c responsecode = new EON_OFSC_Response_Code__c();
        responsecode.Name = '0';
        responsecode.API__c = 'Inbound';
        responsecode.Error_Warning_Success__c = 'error';
        insert responsecode;
        
        EON_OFSC_Response_Code__c responsecode1 = new EON_OFSC_Response_Code__c();
        responsecode1.Name = '1';
        responsecode1.API__c = 'Inbound';
        responsecode1.Error_Warning_Success__c = 'error';
        insert responsecode1;        
        
        Oracle_Data_Tracker__c ODT = new Oracle_Data_Tracker__c ();
        EON_Send_PAYG_Sent_OFSC_Handler.processResponse(response, ODT);
        EON_Send_PAYG_Sent_OFSC_Handler.convertDateToOFSCFormat(System.today());
        
        //PRaveen
        EON_Send_MTRSNO_OFSC_Handler.processResponse(response, ODT);
        EON_Send_MTRSNO_OFSC_Handler.convertDateToOFSCFormat(System.today()); 
        EON_Appointment__c objApp = new EON_Appointment__c();
        insert objApp;
        objApp.E_Meter_Serial_Number__c = '1342';
        update objApp;               
                                      
    }
    //CH04.End
    
    //CH05.Start
    static testmethod void unitTestsendConfigAsset1(){
    
        //Create test data
        Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ConfigureSMSAsset');
        insert oracleTracker;
        
        EON_Appointment__c objApp = new EON_Appointment__c();
        insert objApp;
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
        
        subject = 'ConfigureSMSAsset';
        //Request XML
        string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <SOAP-ENV:Body> <ns1:send_message xmlns="urn:toatech:agent"> <user> <now>2016-06-08T09:50:55+00:00</now> <company>'+ System.Label.EON_OFSC_Company +'</company> <login>app_user</login> <auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string> </user> <messages> <message> <app_host>app102.eta.test.ed5.etadirect.com</app_host> <app_port>11141</app_port> <app_url>/outbound/</app_url> <message_id>1240</message_id> <address></address> <send_to>2016-06-08 10:49:47</send_to> <subject>ConfigureSMSAsset</subject> <body> <SMSAssetConfiguration> <Header> <OrgId>'+lstApp[0].name+'</OrgId> <RequestId>'+lstApp[0].Id+'</RequestId> <RequestDateTime>2016-05-18 09:47</RequestDateTime> </Header> <Hub> <SerialNumber>070122267</SerialNumber> </Hub> <ElectricMeter> <SerialNumber>I00R000073</SerialNumber> <MPAN>1100005911580</MPAN> <SSC>0393</SSC> <Registers> <Register> <RegisterId>01</RegisterId> <TPR>00001</TPR> </Register> <Register> <RegisterId>02</RegisterId> <TPR>00002</TPR> </Register> <Register> <RegisterId>03</RegisterId> <TPR>00003</TPR> </Register> <Register> <RegisterId>04</RegisterId> <TPR>00004</TPR> </Register> <Register> <RegisterId>05</RegisterId> <TPR>00005</TPR> </Register> <Register> <RegisterId>06</RegisterId> <TPR>00006</TPR> </Register> </Registers> </ElectricMeter> <GasMeter> <SerialNumber>A4K00009817030</SerialNumber> <MPRN>9101878010</MPRN> </GasMeter> <IHD> <SerialNumber>AA29817030</SerialNumber> </IHD> </SMSAssetConfiguration> </body> </message> </messages> </ns1:send_message> </SOAP-ENV:Body> </SOAP-ENV:Envelope>';
        
        
        EON_OFSC_to_MIDOS_Commissioning_Send.sendConfigAsset1(req);
    }
    
    static testmethod void unitTestsendValidateSMSAsset1(){
    
        //Create test data
        Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ConfigureSMSAsset');
        insert oracleTracker;
        
        EON_Appointment__c objApp = new EON_Appointment__c();
        insert objApp;
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
        
        subject = 'ValidateSMSAsset';
        //Request XML
        string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2011-11-23T15:50:23+00:00</now><login>user_name</login><company>company_name</company><auth_string>67c5900a04abc54132a52da8a2320be2</auth_string></user><messages><message><app_host>service.example.com</app_host><app_port>443</app_port><app_url>/soap/</app_url><message_id>2006</message_id><address>someone@examplemail.com</address><send_to>2011-11-24 01:59:00</send_to><subject>ValidateSMSAsset</subject><body><SMSAssetValidation><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><Assets><Asset><AssetType>ELECMETER</AssetType><SerialNumber>201220131001</SerialNumber></Asset><Asset><AssetType>GASMETER</AssetType><SerialNumber>0801201404</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>201220131003</SerialNumber></Asset><Asset><AssetType>HUB</AssetType><SerialNumber>070120142</SerialNumber></Asset></Assets></SMSAssetValidation></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        
        EON_OFSC_to_MIDOS_Commissioning_Send.sendValidateSMSAsset1(req);
    } 
    
    static testmethod void unitTestsendUnConfigSMSAsset(){
    
        //Create test data
        Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'ConfigureSMSAsset');
        insert oracleTracker;
        
        EON_Appointment__c objApp = new EON_Appointment__c();
        insert objApp;
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
        
        subject = 'UnConfigSMSAsset';
        //Request XML
        string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <SOAP-ENV:Body> <ns1:send_message xmlns="urn:toatech:agent"> <user> <now>2016-06-08T09:50:55+00:00</now> <company>'+ System.Label.EON_OFSC_Company +'</company> <login>app_user</login> <auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string> </user> <messages> <message> <app_host>app102.eta.test.ed5.etadirect.com</app_host> <app_port>11141</app_port> <app_url>/outbound/</app_url> <message_id>1240</message_id> <address></address> <send_to>2016-06-08 10:49:47</send_to> <subject>ConfigureSMSAsset</subject> <body> <SMSAssetConfiguration> <Header> <OrgId>'+lstApp[0].name+'</OrgId> <RequestId>'+lstApp[0].Id+'</RequestId> <RequestDateTime>2016-05-18 09:47</RequestDateTime> </Header> <Hub> <SerialNumber>070122267</SerialNumber> </Hub> <ElectricMeter> <SerialNumber>I00R000073</SerialNumber> <MPAN>1100005911580</MPAN> <SSC>0393</SSC> <Registers> <Register> <RegisterId>01</RegisterId> <TPR>00001</TPR> </Register> <Register> <RegisterId>02</RegisterId> <TPR>00002</TPR> </Register> <Register> <RegisterId>03</RegisterId> <TPR>00003</TPR> </Register> <Register> <RegisterId>04</RegisterId> <TPR>00004</TPR> </Register> <Register> <RegisterId>05</RegisterId> <TPR>00005</TPR> </Register> <Register> <RegisterId>06</RegisterId> <TPR>00006</TPR> </Register> </Registers> </ElectricMeter> <GasMeter> <SerialNumber>A4K00009817030</SerialNumber> <MPRN>9101878010</MPRN> </GasMeter> <IHD> <SerialNumber>AA29817030</SerialNumber> </IHD> </SMSAssetConfiguration> </body> </message> </messages> </ns1:send_message> </SOAP-ENV:Body> </SOAP-ENV:Envelope>';
        
        
        EON_OFSC_to_MIDOS_Commissioning_Send.sendUnConfigSMSAsset(req);
    }       
    //CH05.End
    
    //CH06.Start
    /*
        SendtoMIDOS_PrepayMeterBalance_Direct() - To test success response for SubmitPrepayMeterBalance
    */
    static testmethod void SendtoMIDOS_PrepayMeterBalance_Direct(){
        //Create test data
        Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitPrePayBalance');
        insert oracleTracker;
        
        EON_Appointment__c objApp = new EON_Appointment__c();
        insert objApp;
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
        
        subject = 'SubmitPrePayBalance';
        //Request XML
        string req ='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitPrepayBalance</subject><body><PrePayMeterBalance><Header><OrgId /><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-01-18 15:47</RequestDateTime></Header><BalanceData><DeviceType>ELECMETER</DeviceType><MPAN>12345678</MPAN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>12</CurrentBalance><TotalDebt>11</TotalDebt></BalanceData><BalanceData><DeviceType>GASMETER</DeviceType><MPRN>12345678</MPRN><SerialNumber>86GH97559</SerialNumber><CurrentBalance>13</CurrentBalance><TotalDebt>55</TotalDebt></BalanceData></PrePayMeterBalance></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        EON_OFSC_to_MIDOS_Commissioning_Send.sendPrePayBalance1(req, 1);

  }   
  
    /*
        SendtoMIDOS_CreditMeterBalance_Direct() - To test success response for SubmitCreditMeterReading
    */
    static testmethod void SendtoMIDOS_CreditMeterBalance_Direct(){
        //Create test data
        Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c(Direction__c = Eon_Utility.DIRECTION_IN, Command__c = 'SubmitCreditMeterReading');
        insert oracleTracker;
        
        EON_Appointment__c objApp = new EON_Appointment__c();
        insert objApp;
        
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where id =: objApp.Id]);
        
        subject = 'SubmitCreditMeterReading';
        //Request XML
        string req = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:toatech:agent" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Body><ns1:send_message xmlns="urn:toatech:agent"><user><now>2016-06-08T09:50:55+00:00</now><company>'+ System.Label.EON_OFSC_Company +'</company><login>app_user</login><auth_string>1f5671c65a2af9d9809674d1c22a5260</auth_string></user><messages><message><app_host>app102.eta.test.ed5.etadirect.com</app_host><app_port>11141</app_port><app_url>/outbound/</app_url><message_id>1240</message_id><address /><send_to>2016-06-08 10:49:47</send_to><subject>SubmitCreditMeterReading</subject><body><CreditMeterReading><Header><OrgId>'+lstApp[0].name+'</OrgId><RequestId>'+lstApp[0].Id+'</RequestId><RequestDateTime>2016-06-06 15:49</RequestDateTime></Header><MeterData><MPAN>1100007264332</MPAN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData><MeterData><MPRN>2200007264332</MPRN><SerialNumber>201220131001</SerialNumber><Registers><Register><RegisterId>01</RegisterId><RegisterRead>74765</RegisterRead></Register></Registers></MeterData></CreditMeterReading></body></message></messages></ns1:send_message></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        EON_OFSC_to_MIDOS_Commissioning_Send.sendCreditMeter1(req, 1);
    
    }   
    //CH06.End
    
}