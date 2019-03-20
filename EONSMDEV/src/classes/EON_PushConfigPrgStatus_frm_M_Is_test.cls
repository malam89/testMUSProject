/**
    Description : This test class is for the following class : EON_pushConfigProgressStatus_frm_M_Is_WS
**/
/*
    Created By : Tashika Gupta
    Created Date : 23/03/2016
    Service Request : SR_EON_Mobile_006
*/
@isTest
private class EON_PushConfigPrgStatus_frm_M_Is_test{

    /**
        PushConfigProgressStatus_to_Isis_Pass1() - postitive Unit test for the method PushConfigProgressStatus_to_Isis
    **/
    static testMethod void PushConfigProgressStatus_to_Isis_Pass1(){
    //Create EON Job
    EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
    insert objJob;
        
    //Create EON Appointment
    EON_Appointment__c objAppointment = new EON_Appointment__c(Duration__c = 10, Job_Code__c=objJob.Id, MPAN__c='123456789',Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', 
                            Metering_Point_Address_Line_2__c='1', Metering_Point_Postcode__c='E20 1FH',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON');
    insert objAppointment;
    
    //Create EON OFSC Response Code
    EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
    insert objRC1; 
    //Create MIDOS Tracker
    MIDOS_Data_Tracker__c objTrack = new MIDOS_Data_Tracker__c(Appointment_Number__c=objAppointment.Id,Direction__c='OUT');// Request going to MIDOS Tracker record
    insert objTrack;
      
    list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where id =: objTrack.Id]);
    EON_pushConfigProgressStatus_frm_M_Is_WS.HeaderElement header = new EON_pushConfigProgressStatus_frm_M_Is_WS.HeaderElement();
    header.orgId='12345';
    header.requestId=lstTrack[0].Name;//CH01
    header.requestDateTime=system.now();
    EON_pushConfigProgressStatus_frm_M_Is_WS.errMessage msg = new EON_pushConfigProgressStatus_frm_M_Is_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
    EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus request = new EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus();
    request.header=header;
    request.ErrorMessage='Test';
    request.StatusMessage='Pass';
    request.StatusValue='True';
    request.AssetType='Test';
    EON_pushConfigProgressStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus(request);
    System.assert(response != null);
    test.stopTest();
    }
    
    /**
        PushConfigProgressStatus_to_Isis_Pass2() - positive Unit test for the method PushConfigProgressStatus_to_Isis
    **/
    static testMethod void PushConfigProgressStatus_to_Isis_Pass2(){
    //Create EON Job
    EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10);
    insert objJob;
        
    //Create EON Appointment
    EON_Appointment__c objAppointment = new EON_Appointment__c(Duration__c = 10, Job_Code__c=objJob.Id, MPAN__c='123456789',Metering_Point_Address_Line_1__c='1ST/ 2ND FLOOR', 
                            Metering_Point_Address_Line_2__c='1', Metering_Point_Postcode__c='E20 1FH',
                                                Metering_Point_Address_Line_3__c='TITIAN HEIGHTS 12', Metering_Point_Address_Line_5__c='SCARLET CLOSE',
                                                Metering_Point_Address_Line_8__c='LONDON');
    insert objAppointment;
    
    //Create EON OFSC Response Code
    EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
    insert objRC1; 
    //Create MIDOS Tracker
    MIDOS_Data_Tracker__c objTrack = new MIDOS_Data_Tracker__c(Direction__c='OUT',Command__c = 'PushConfigProgressStatus');// Request going to MIDOS Tracker record
    insert objTrack;
      
    //list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where id =: objTrack.Id]);
    EON_pushConfigProgressStatus_frm_M_Is_WS.HeaderElement header = new EON_pushConfigProgressStatus_frm_M_Is_WS.HeaderElement();
    header.orgId='1231234';
    header.requestId='test';
    header.requestDateTime=system.now();
    EON_pushConfigProgressStatus_frm_M_Is_WS.errMessage msg = new EON_pushConfigProgressStatus_frm_M_Is_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus request = new EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus();
    request.header=header;
    request.ErrorMessage='Test';
    request.StatusMessage='';
    request.StatusValue='True';
    request.AssetType='';
    EON_pushConfigProgressStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus(request);
    System.assert(response != null);
    test.stopTest();
    }
    /**
        PushConfigProgressStatus_to_Isis_Pass3() - positive Unit test for the method PushConfigProgressStatus_to_Isis
    **/
    static testMethod void PushConfigProgressStatus_to_Isis_Pass3(){
    
    EON_pushConfigProgressStatus_frm_M_Is_WS.HeaderElement header = new EON_pushConfigProgressStatus_frm_M_Is_WS.HeaderElement();
    header.orgId='';
    header.requestId='';
    header.requestDateTime=null;
    EON_pushConfigProgressStatus_frm_M_Is_WS.errMessage msg = new EON_pushConfigProgressStatus_frm_M_Is_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus request = new EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus();
    request.header=header;
    request.ErrorMessage='Test';
    request.StatusMessage='';
    request.StatusValue='True';
    request.AssetType='';
    EON_pushConfigProgressStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus(request);
    System.assert(response != null);
    test.stopTest();
    }
    /**
        PushConfigProgressStatus_to_Isis_Fail() - negative Unit test for the method PushConfigProgressStatus_to_Isis
    **/
    static testMethod void PushConfigProgressStatus_to_Isis_Fail1(){
    EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus request = new EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus();
    test.startTest();
    Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
    EON_pushConfigProgressStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus(request);
    response.header.orgId = UserInfo.getOrganizationId();
    System.assert(response != null);
    test.stopTest();
    }
    /**
        PushValidationStatus_to_Isis_Pass1() - postitive Unit test for the method PushValidationStatus_to_Isis
    **/
    static testMethod void PushConfigProgressStatus_to_Isis_Fail(){
      EON_pushConfigProgressStatus_frm_M_Is_WS.HeaderElement header = new EON_pushConfigProgressStatus_frm_M_Is_WS.HeaderElement();
      header.orgId='12345';
      //CH01.old //header.requestId='Test';
      header.requestId='test';
      header.requestDateTime=system.now();
      EON_pushConfigProgressStatus_frm_M_Is_WS.errMessage msg= new EON_pushConfigProgressStatus_frm_M_Is_WS.errMessage(); 
      msg.MessageType='test';
      msg.MessageId=123;
      msg.MessageText='Test';
      Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
      test.startTest();
      EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus request = new EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus();
      request.header=header;
      request.AssetType='Test';
      request.StatusMessage='Pass';
      request.StatusValue='True';
      EON_pushConfigProgressStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus(request);
      System.assert(response != null);
      test.stopTest();
    }
    /**
        requestNotFoundTest-  Test request not found error.
    **/
    static testMethod void requestNotFoundTest(){
    EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus request ;
    test.startTest();
    EON_pushConfigProgressStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_pushConfigProgressStatus_frm_M_Is_WS.PushConfigProgressStatus(request);
    System.assert(response != null);
    test.stopTest();
    } 
}