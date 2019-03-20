/**
    Description : This test class is for the following class : EON_PushUnConfigStatus_frm_MIDOS_Isis_WS
**/
/*
    Created By : Praveen G
    Created Date : 29/01/2018
    Service Request : SR_OptiMUS_EON_178
*/
@isTest
private class EON_PushUnConfigStatus_frm_MIDOS_test{


    /**
        PushUnConfigStatus_to_Isis_Pass1() - postitive Unit test for the method PushValidationStatus_to_Isis
    **/
    static testMethod void PushUnConfigStatus_to_Isis_Pass1(){
    
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
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.HeaderElement header = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.HeaderElement();
    header.orgId='12345';
    header.requestId=lstTrack[0].Name;//CH01
    header.requestDateTime=system.now();
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.errMessage msg = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus request = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus();
    request.header=header;
    request.ErrorMessage='Test';
    request.StatusMessage='Pass';
    request.StatusValue='True';
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus(request);
    System.assert(response != null);
    test.stopTest();
    }
    
    /**
        PushUnConfigStatus_to_Isis_Pass2() - positive Unit test for the method PushValidationStatus_to_Isis
    **/
    static testMethod void PushUnConfigStatus_to_Isis_Pass2(){
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
    MIDOS_Data_Tracker__c objTrack = new MIDOS_Data_Tracker__c(Direction__c='OUT');// Request going to MIDOS Tracker record
    insert objTrack;
      
    //list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>([select id, name from MIDOS_Data_Tracker__c where id =: objTrack.Id]);
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.HeaderElement header = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.HeaderElement();
    header.orgId='2342';
    header.requestId='test';
    header.requestDateTime=system.now();
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.errMessage msg = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus request = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus();
    request.header=header;
    request.ErrorMessage='Test';
    request.StatusMessage='test';
    request.StatusValue='0';
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus(request);
    System.assert(response != null);
    test.stopTest();
    }
    /**
        PushUnConfigStatus_to_Isis_Pass3() - positive Unit test for the method PushValidationStatus_to_Isis
    **/
    static testMethod void PushUnConfigStatus_to_Isis_Pass3(){
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.HeaderElement header = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.HeaderElement();
    header.orgId='';
    header.requestId='';
    header.requestDateTime=null;
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.errMessage msg = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus request = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus();
    request.header=header;
    request.ErrorMessage='Test';
    request.StatusMessage='';
    request.StatusValue='';
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus(request);
    System.assert(response != null);
    test.stopTest();
    }
    /**
        PushUnConfigStatus_to_Isis_Fail() - negative Unit test for the method PushValidationStatus_to_Isis
    **/
    static testMethod void PushUnConfigStatus_to_Isis_Fail(){
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.HeaderElement header;        
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus request = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus();
    //request.Header = header;
    test.startTest();
    try{
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus(request);
    System.assert(response != null);
    }catch(exception e){}
    test.stopTest();
    } 
    
    /**
        requestNotFoundTest-  Test request not found error.
    **/
    static testMethod void requestNotFoundTest(){
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus request ;
    test.startTest();
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus(request);
    System.assert(response != null);
    test.stopTest();
    } 
    
    /**
        PushUnConfigStatus_to_Isis_Pass4() - postitive Unit test for the method PushValidationStatus_to_Isis
    **/
    static testMethod void PushUnConfigStatus_to_Isis_Pass4(){
    
    try{
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
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.HeaderElement header = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.HeaderElement();
    header.orgId='12345';
    header.requestId='Test';//CH01
    header.requestDateTime=system.now();
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.errMessage msg = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus request = new EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus();
    request.header=header;
    request.ErrorMessage='Test';
    //request.StatusMessage='Pass';
    
    request.StatusMessage= 'The SMS has been UnConfigured successfully';
    
    request.StatusValue='True';
    EON_Utility.genException=true;
    EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushUnConfigStatus_frm_MIDOS_Isis_WS.PushUnConfigStatus(request);
    System.assert(response != null);
    test.stopTest();
    }catch(Exception ed){
    }
    }
}