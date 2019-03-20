/**
    Description : This test class is for the below classes.
    			  EON_GetServiceStatus_WS
    			  EON_GetMIDOSServiceStatus_WS
**/
/*
    Created By : Tashika Gupta
    Created Date : 27/04/2016
    Service Request : SR_Isis_EON_005
    Change History : CH01 # SR_EON_AB_050 # 02/06/2016 # Dharmendra Pahadiya # Increased code coverage and added methods for EON_GetMIDOSServiceStatus_WS. 
*/
@isTest
private class EON_GetServiceStatus_WS_Test {
    /**
        successStatusRecordTest() - Test when successful request is received and the status in Isis is SUCCESS.
    **/
    static testMethod void successStatusRecordTest() {
        EON_GetServiceStatus_WS.HeaderElement header = new EON_GetServiceStatus_WS.HeaderElement();
        header.orgId = system.label.EON_Sanbox_Name;
        header.requestId = 'Test';
        header.requestDateTime = system.now();
        EON_GetServiceStatus_WS.ServiceStatusRequest request = new EON_GetServiceStatus_WS.ServiceStatusRequest();
        request.Header = header;

        test.startTest();
        EON_GetServiceStatus_WS.ServiceStatusResponse response = EON_GetServiceStatus_WS.ServiceStatus(request);
        test.stopTest();
        System.assert(response != null);
        System.assertEquals(0, response.header.Status);
    }

    /**
        mandatoryFieldsTest() - Test when mandatory fields are not sent along with the request received.
    **/
    static testMethod void mandatoryFieldsTest() {
        EON_GetServiceStatus_WS.HeaderElement header = new EON_GetServiceStatus_WS.HeaderElement();
        header.orgId = '12345';
        EON_GetServiceStatus_WS.ServiceStatusRequest request = new EON_GetServiceStatus_WS.ServiceStatusRequest();
        request.Header = header;

        test.startTest();
        EON_GetServiceStatus_WS.ServiceStatusResponse response = EON_GetServiceStatus_WS.ServiceStatus(request);
        test.stopTest();
        System.assert(response != null);
        System.assertEquals('Mandatory fields are missing: orgId or requestId or requestDateTime', response.header.ErrorMessage);
    }

    /**
        failureStatusRecordTest() - Test when successful request is received and the status in Isis is FAILURE.
    **/

    static testMethod void failureStatusRecordTest() {
        EON_GetServiceStatus_WS.HeaderElement header = new EON_GetServiceStatus_WS.HeaderElement();
        header.orgId = '12345';
        header.requestId = 'Test';
        header.requestDateTime = system.now();
        EON_GetServiceStatus_WS.ServiceStatusRequest request = new EON_GetServiceStatus_WS.ServiceStatusRequest();
        request.Header = header;

        test.startTest();
        EON_GetServiceStatus_WS.ServiceStatusResponse response = EON_GetServiceStatus_WS.ServiceStatus(request);
        test.stopTest();
        System.assert(response != null);
        System.assertEquals('JUMBO Fail and Oracle Fail', response.header.ErrorMessage);
    }

    /**
        noRequestTest() - Test when no request is received.
    **/
    static testMethod void noRequestTest() {
        EON_GetServiceStatus_WS.ServiceStatusRequest request;
        test.startTest();
        EON_GetServiceStatus_WS.ServiceStatusResponse response = EON_GetServiceStatus_WS.ServiceStatus(request);

        test.stopTest();
        System.assert(response != null);
        System.assertEquals('Request is Blank.', response.header.ErrorMessage);
    }
    
    /**
        noRequestTest() - Test when no header is received in request.
    **/
    static testMethod void noHeaderRequestTest() {
        EON_GetServiceStatus_WS.ServiceStatusRequest request = new EON_GetServiceStatus_WS.ServiceStatusRequest();
        test.startTest();
        EON_GetServiceStatus_WS.ServiceStatusResponse response = EON_GetServiceStatus_WS.ServiceStatus(request);
        test.stopTest();
        System.assert(response != null);
        System.assertEquals('Header is missing.', response.header.ErrorMessage);
    }
    
    //CH01.start
    /**
        exceptoinTest() - To cover the exception part.
    **/
    static testMethod void exceptoinTest() {
        EON_GetServiceStatus_WS.HeaderElement header = new EON_GetServiceStatus_WS.HeaderElement();
        header.orgId = '12345';
        header.requestId = 'Test request Id';
        header.requestDateTime = system.now();
        EON_GetServiceStatus_WS.ServiceStatusRequest request = new EON_GetServiceStatus_WS.ServiceStatusRequest();
        request.Header = header;
        EON_Utility.genException = true;
        
        test.startTest();
        EON_GetServiceStatus_WS.ServiceStatusResponse response = EON_GetServiceStatus_WS.ServiceStatus(request);
        test.stopTest();
        
        System.assertEquals(1, response.Header.Status);
    }
    
    /**
        GetMIDOSServiceStatus_success_test() - Test when successful request is received for GetMIDOSServiceStatus.
    **/
    static testMethod void GetMIDOSServiceStatus_success_test() {
        EON_GetMIDOSServiceStatus_WS.HeaderElement header = new EON_GetMIDOSServiceStatus_WS.HeaderElement();
        header.orgId = system.label.EON_Sanbox_Name;
        header.requestId = 'Test';
        header.requestDateTime = system.now();
        EON_GetMIDOSServiceStatus_WS.ServiceStatusRequest request = new EON_GetMIDOSServiceStatus_WS.ServiceStatusRequest();
        request.Header = header;

        // This causes a fake response to be generated
        //EON_Jumbo_ElecGasData_Test.functionType = 'validateMOP';
        //Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
        Test.setMock(WebServiceMock.class, new EON_OFSC_GetCapacity_WS_ServicesMock());
        test.startTest();
        EON_GetMIDOSServiceStatus_WS.ServiceStatusResponse response = EON_GetMIDOSServiceStatus_WS.ServiceStatus(request);
        system.debug('resp: '+response);
        test.stopTest();
        System.assert(response != null);
        System.assertEquals(0, response.header.Status);
    }
    
    /**
        GetMIDOSServiceStatus_noRequest_Test() - Test when no request is received for GetMIDOSServiceStatus.
    **/
    static testMethod void GetMIDOSServiceStatus_noRequest_Test() {
        EON_GetMIDOSServiceStatus_WS.ServiceStatusRequest request;
        test.startTest();
        EON_GetMIDOSServiceStatus_WS.ServiceStatusResponse response = EON_GetMIDOSServiceStatus_WS.ServiceStatus(request);

        test.stopTest();
        System.assert(response != null);
        System.assertEquals('Request is Blank.', response.header.ErrorMessage);
    }
	
	/**
        mandatoryFieldsTest() - Test when mandatory fields are not sent along with the request received.
    **/
    static testMethod void GetMIDOSServiceStatus_mandatoryFields_Test() {
        EON_GetMIDOSServiceStatus_WS.HeaderElement header = new EON_GetMIDOSServiceStatus_WS.HeaderElement();
        header.orgId = '12345';
        EON_GetMIDOSServiceStatus_WS.ServiceStatusRequest request = new EON_GetMIDOSServiceStatus_WS.ServiceStatusRequest();
        request.Header = header;

        test.startTest();
        EON_GetMIDOSServiceStatus_WS.ServiceStatusResponse response = EON_GetMIDOSServiceStatus_WS.ServiceStatus(request);
        test.stopTest();
        System.assert(response != null);
        System.assertEquals('Mandatory fields are missing: orgId or requestId or requestDateTime',response.header.ErrorMessage);
    }
    
    /**
        noRequestTest() - Test when no header is received in request.
    **/
    static testMethod void GetMIDOSServiceStatus_noHeaderRequest_Test() {
        EON_GetMIDOSServiceStatus_WS.ServiceStatusRequest request = new EON_GetMIDOSServiceStatus_WS.ServiceStatusRequest();
        test.startTest();
        EON_GetMIDOSServiceStatus_WS.ServiceStatusResponse response = EON_GetMIDOSServiceStatus_WS.ServiceStatus(request);
        test.stopTest();
        System.assertEquals('Header is missing.', response.header.ErrorMessage);
    }
    
    /**
        GetMIDOSServiceStatus_exception_Test() - To cover the exception part of EON_GetMIDOSServiceStatus_WS.
    **/
    static testMethod void GetMIDOSServiceStatus_exception_Test() {
        EON_GetMIDOSServiceStatus_WS.HeaderElement header = new EON_GetMIDOSServiceStatus_WS.HeaderElement();
        header.orgId = '12345';
        header.requestId = 'Test request IdTest request IdTest request IdTest request IdTest request IdTest request IdTest request Id';
        header.requestDateTime = system.now();
        EON_GetMIDOSServiceStatus_WS.ServiceStatusRequest request = new EON_GetMIDOSServiceStatus_WS.ServiceStatusRequest();
        request.Header = header;
        EON_Utility.genException = true;
        
        test.startTest();
        EON_GetMIDOSServiceStatus_WS.ServiceStatusResponse response = EON_GetMIDOSServiceStatus_WS.ServiceStatus(request);
        test.stopTest();
        
        System.assertEquals(1, response.Header.Status);
    }
    //CH01.stop
}