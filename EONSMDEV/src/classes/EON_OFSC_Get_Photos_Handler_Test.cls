/**
    Description : This class is used for test coverage for the below classes
    1.EON_OFSC_Get_Photos_Handler    
    Note:   This test class has set up SeeAllData = True due to below known issues 
            https://success.salesforce.com/issues_view?id=a1p300000008XHBAA2
            As per this issue, any DML as part for test record creation causing to 
            workflow rule exection will fail the test record with below error:
            System.CalloutException: "You have uncommitted work pending. Please commit or rollback before calling out"
            Make sure to have SeeAllData = true with appropriate records in EON Appointment and related EON Job Results and EON Faulty Assets

**/
/*
    Created By : Mahadev J
    Created Date : 18-April-2016 
    Service Request : SR_EON_Mobile_009
    
*/
@isTest(SeeAllData = true)
global class EON_OFSC_Get_Photos_Handler_Test implements WebServiceMock
{
    public static String methodName;
    static testmethod void getPhotosFromOFSC(){
    	EON_Appointment__c app = [Select ID,Complete_DateTime__c from EON_Appointment__c where ID='a0A4E000000ZpUk'];
    	list<id> lstID = new list<id>();
    	lstID.add(app.ID);
		Test.setMock(WebServiceMock.class, new EON_OFSC_Get_Photos_Handler_Test());
    	EON_OFSC_Get_Photos_Handler_Test.methodName = 'GetPhotos';
    	
        Test.Starttest();
    	EON_OFSC_Get_Photos_Handler.getPhotosFromOFSC(lstID);
    	Test.Stoptest();
    }  
    
    /**
        getLargeResponseFromOFSC() - This test method will coverge positive response while downloading photos with large response like response length execeeding 131070.
    **/
    static testmethod void getLargeResponseFromOFSC(){
        EON_Appointment__c app = [Select ID,Complete_DateTime__c from EON_Appointment__c where ID='a0A4E000000ZpUk'];
        app.Complete_DateTime__c = System.Datetime.now();
        update app;
        list<id> lstID = new list<id>();
        lstID.add(app.ID);
        Test.setMock(WebServiceMock.class, new EON_OFSC_Get_Photos_Handler_Test());
        EON_OFSC_Get_Photos_Handler_Test.methodName = 'GetLargeResponse';
        
        Test.Starttest();
        EON_OFSC_Get_Photos_Handler.getPhotosFromOFSC(lstID);
        Test.Stoptest();
    }

    /**
        getPhotosFromOFSCwithFailedResponse() - This test method will coverge negative response while downloading photos and cover exceptions.
    **/
    static testmethod void getPhotosFromOFSCwithFailedResponse(){
        EON_Appointment__c app = [Select ID,Complete_DateTime__c from EON_Appointment__c where ID='a0A4E000000ZpUk'];
        app.Complete_DateTime__c = System.Datetime.now();
        update app;
        list<id> lstID = new list<id>();
        lstID.add(app.ID);
        Test.setMock(WebServiceMock.class, new EON_OFSC_Get_Photos_Handler_Test());
        EON_OFSC_Get_Photos_Handler_Test.methodName = 'GetPhotosWihError';
        
        Test.Starttest();
        EON_OFSC_Get_Photos_Handler.getPhotosFromOFSC(lstID);
        Test.Stoptest();
    }
    
    /**
        getPhotosFromOFSCwithRightFailedCode() - This test method will coverge negative response while downloading photos with right error code.
    **/
    static testmethod void getPhotosFromOFSCwithRightFailedCode(){
        EON_Appointment__c app = [Select ID,Complete_DateTime__c from EON_Appointment__c where ID='a0A4E000000ZpUk'];
        app.Complete_DateTime__c = System.Datetime.now();
        update app;
        list<id> lstID = new list<id>();
        lstID.add(app.ID);
        Test.setMock(WebServiceMock.class, new EON_OFSC_Get_Photos_Handler_Test());
        EON_OFSC_Get_Photos_Handler_Test.methodName = 'GetPhotosWihRightErrorCode';
        
        Test.Starttest();
        EON_OFSC_Get_Photos_Handler.getPhotosFromOFSC(lstID);
        Test.Stoptest();
    }
    
    /**
        getPhotosFromOFSCwithNullResponse() - This test method will coverge negative response while downloading photos with NULL response.
    **/
    static testmethod void getPhotosFromOFSCwithNullResponse(){
        EON_Appointment__c app = [Select ID,Complete_DateTime__c from EON_Appointment__c where ID='a0A4E000000ZpUk'];
        app.Complete_DateTime__c = System.Datetime.now();
        update app;
        list<id> lstID = new list<id>();
        lstID.add(app.ID);
        Test.setMock(WebServiceMock.class, new EON_OFSC_Get_Photos_Handler_Test());
        EON_OFSC_Get_Photos_Handler_Test.methodName = 'GetPhotosWihNullResponse';
        
        Test.Starttest();
        EON_OFSC_Get_Photos_Handler.getPhotosFromOFSC(lstID);
        Test.Stoptest();
    }
    
    /**
        doInvoke() - This method is generate mock response to web service callout to download photos.
    **/
    global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType){
        if(methodName =='GetPhotos'){
            EON_OFSC_Activity_WS.get_file_response_element resp = new EON_OFSC_Activity_WS.get_file_response_element();
            resp.result_code = 0;
            resp.error_msg = 'test';
            resp.file_name = 'test';
            resp.file_data = 'test';
            resp.file_mime_type = 'test';
            response.put('response_x', resp);
        }
        if(methodName =='GetPhotosWihError'){
            EON_OFSC_Activity_WS.get_file_response_element resp = new EON_OFSC_Activity_WS.get_file_response_element();
            resp.result_code = 10;
            resp.error_msg = 'test';
            resp.file_name = 'test';
            resp.file_data = 'test';
            resp.file_mime_type = 'test';
            response.put('response_x', resp);
        }
        if(methodName =='GetPhotosWihRightErrorCode'){
            EON_OFSC_Activity_WS.get_file_response_element resp = new EON_OFSC_Activity_WS.get_file_response_element();
            resp.result_code = 11;
            resp.error_msg = 'test';
            resp.file_name = 'test';
            resp.file_data = 'test';
            resp.file_mime_type = 'test';
            response.put('response_x', resp);
        }
        if(methodName =='GetLargeResponse'){
            String str = '';
            for(Integer i = 0; i<57; i++){
                str+='TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestT2304estTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest';
            }
            EON_OFSC_Activity_WS.get_file_response_element resp = new EON_OFSC_Activity_WS.get_file_response_element();
            resp.result_code = 0;
            resp.error_msg = 'test';
            resp.file_name = 'test';
            resp.file_data = str;
            resp.file_mime_type = 'test';
            response.put('response_x', resp);
        }
        if(methodName =='GetPhotosWihNullResponse'){
            EON_OFSC_Activity_WS.get_file_response_element resp = new EON_OFSC_Activity_WS.get_file_response_element();
            resp.result_code = 0;
            resp.error_msg = 'test';
            resp.file_name = 'test';
            resp.file_data = 'test';
            resp.file_mime_type = 'test';
            response.put('response_x', null);
        }
    }
}