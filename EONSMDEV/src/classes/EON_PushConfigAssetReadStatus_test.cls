/**
    Description : This test class is for the following class : EON_PushConfgAssetReadStatus_frm_M_Is_WS
**/
/*
    Created By : Tashika Gupta
    Created Date : 23/03/2016
    Service Request : SR_EON_Mobile_006
    Change History : CH01 # SR_EON_Mobile_036 # 12/05/2016 # Dharmendra P # Added new method & code to increase coverage.
*/
@isTest
private class EON_PushConfigAssetReadStatus_test{

    /**
        PushConfgAssetReadStatus_to_Isis_Pass() - postitive Unit test for the method PushConfgAssetReadStatus_to_Isis
    **/
    static testMethod void PushConfgAssetReadStatus_to_Isis_Pass(){
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement header = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement();
    header.orgId='12345';
    header.requestId='Test';
    header.requestDateTime=system.now();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register1 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
    Register1.RegisterId='1234';
    Register1.RegisterRead=123;
    Register1.TPR='test';
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst Reg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst();
    Reg.Register=  new list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead Electric = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead();
    Electric.SSC = 'test';
    Electric.Registers = Reg;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead Gas = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
    Gas.GasRegisterRead=123;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage msg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus request = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus();
    request.header=header;
    request.StatusMessage='Pass';
    request.StatusValue='True';
    request.ElectricMeterRead=electric;
    request.GasMeterRead=null;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus(request);
    System.assert(response != null);
    test.stopTest();
    }
    /**
        PushConfgAssetReadStatus_to_Isis_Pass1() - postitive Unit test for the method Electric meter read.
    **/
    static testMethod void PushConfgAssetReadStatus_to_Isis_Pass1(){
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement header = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement();
    header.orgId='12345';
    header.requestId='Test';
    header.requestDateTime=system.now();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register1 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
    Register1.RegisterId='1234';
    Register1.RegisterRead=123;
    Register1.TPR='test';
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register2 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
    Register2.RegisterRead=123;
    Register2.TPR='test';
    list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>RegisterList =new list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>();
    RegisterList.add(Register1);
    RegisterList.add(Register2);
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst Reg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst();
    Reg.Register= RegisterList;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead Electric = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead();
    Electric.SSC = 'test';
    Electric.Registers = Reg;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead Gas = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
    Gas.GasRegisterRead=123;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage msg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus request = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus();
    request.header=header;
    request.StatusMessage='Pass';
    request.StatusValue='True';
    request.ElectricMeterRead=Electric;
    request.GasMeterRead=Gas;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus(request);
    System.assert(response != null);
    test.stopTest();
    }
    /**
        PushConfgAssetReadStatus_to_Isis_Pass1() - postitive Unit test for the method Gas meter read.
    **/
    static testMethod void PushConfgAssetReadStatus_to_Isis_Pass2(){
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement header = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement();
    header.orgId='12345';
    header.requestId='Test';
    header.requestDateTime=system.now();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register1 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
    Register1.RegisterId='1234';
    Register1.RegisterRead=123;
    Register1.TPR='test';
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register2 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
    Register2.RegisterRead=123;
    Register2.TPR='test';
    list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>RegisterList =new list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>();
    RegisterList.add(Register1);
    RegisterList.add(Register2);
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst Reg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst();
    Reg.Register= RegisterList;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead Electric = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead();
    Electric.SSC = 'test';
    Electric.Registers = Reg;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead Gas = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage msg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus request = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus();
    request.header=header;
    request.StatusMessage='Pass';
    request.StatusValue='True';
    request.ElectricMeterRead=null;
    request.GasMeterRead=Gas;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus(request);
    System.assert(response != null);
    test.stopTest();
}
/**
        PushConfgAssetReadStatus_to_Isis_Error() - test for error electric and gas read are blank.
    **/
    static testMethod void PushConfgAssetReadStatus_to_Isis_Error(){
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement header = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement();
    header.orgId='12345';
    header.requestId='Test';
    header.requestDateTime=system.now();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register1 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
    Register1.RegisterId='1234';
    Register1.RegisterRead=123;
    Register1.TPR='test';
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register2 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
    Register2.RegisterRead=123;
    Register2.TPR='test';
    list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>RegisterList =new list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>();
    RegisterList.add(Register1);
    RegisterList.add(Register2);
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst Reg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst();
    Reg.Register= RegisterList;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead Electric = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead Gas = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage msg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus request = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus();
    request.header=header;
    request.StatusMessage='Pass';
    request.StatusValue='True';
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus(request);
    System.assert(response != null);
    test.stopTest();
}

    /**
        PushConfgAssetReadStatus_to_Isis_Fail() - negative Unit test for the method PushConfgAssetReadStatus_to_Isis
    **/
    static testMethod void PushConfgAssetReadStatus_to_Isis_Fail(){
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement header = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement();
    header.orgId='';
    header.requestId='';
    header.requestDateTime=null;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register1 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
    Register1.RegisterId='';
    Register1.RegisterRead=null;
    Register1.TPR='test';
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst Reg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst();
    Reg.Register= null;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead Electric = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead();
    Electric.SSC = '';
    Electric.Registers = null;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead Gas = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
    Gas.GasRegisterRead=null;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage msg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage();
    msg.MessageType='test';
    msg.MessageId=123;
    msg.MessageText='Test';
    test.startTest();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus request = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus();
    request.header=header;
    request.StatusMessage='';
    request.StatusValue='True';
    request.ElectricMeterRead=Electric;
    request.GasMeterRead=Gas;
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus(request);
    System.assert(response != null);
    test.stopTest();
    }
    
    /**
        requestNotFoundTest-  Test request not found error.
    **/
    static testMethod void requestNotFoundTest(){
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus request ;
    test.startTest();
    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus(request);
    System.assert(response != null);
    test.stopTest();
    } 
    
    //CH01.start
    /**
        PushConfgAssetReadStatus_to_Isis_Pass3() - postitive Unit test for the method PushConfgAssetReadStatus_to_Isis
    **/
    static testMethod void PushConfgAssetReadStatus_to_Isis_Pass3(){
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
    	
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement header = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement();
	    header.orgId='12345';
	    header.requestId=lstTrack[0].Name;
	    header.requestDateTime=system.now();
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register1 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
	    Register1.RegisterId='1234';
	    Register1.RegisterRead=123;
	    Register1.TPR='test';
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register regs = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
	    regs.RegisterId = 'test RegId';
	    regs.RegisterRead = 0;
	    regs.TPR = 'test TPR';
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst Reg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst();
	    Reg.Register=  new list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>{regs};
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead Electric = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead();
	    Electric.SSC = 'test';
	    Electric.Registers = Reg;
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead Gas = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
	    Gas.GasRegisterRead=123;
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage msg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage();
	    msg.MessageType='test';
	    msg.MessageId=123;
	    msg.MessageText='Test';
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead gasRead = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
	    gasRead.GasRegisterRead = 100;
	    
	    Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
	    test.startTest();
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus request = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus();
	    request.header=header;
	    request.StatusMessage='Pass';
	    request.StatusValue='True';
	    request.ElectricMeterRead=electric;
	    request.GasMeterRead=gasRead;
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus(request);
	    System.assert(response != null);
	    test.stopTest();
    }
    
    /**
        PushConfgAssetReadStatus_to_Isis_Pass4() - postitive Unit test for the method PushConfgAssetReadStatus_to_Isis
    **/
    static testMethod void PushConfgAssetReadStatus_to_Isis_Pass4(){
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
    	
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement header = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement();
	    header.orgId='12345';
	    header.requestId=lstTrack[0].Name;
	    header.requestDateTime=system.now();
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register1 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
	    Register1.RegisterId='1234';
	    Register1.RegisterRead=123;
	    Register1.TPR='test';
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register regs = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
	    regs.RegisterId = 'test RegId';
	    regs.RegisterRead = 0;
	    regs.TPR = 'test TPR';
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst Reg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst();
	    Reg.Register=  new list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>{regs};
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead Electric = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead();
	    Electric.SSC = 'test';
	    Electric.Registers = Reg;
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead Gas = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
	    Gas.GasRegisterRead=123;
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage msg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage();
	    msg.MessageType='test';
	    msg.MessageId=123;
	    msg.MessageText='Test';
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead gasRead = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
	    gasRead.GasRegisterRead = 100;
	    
	    //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
	    test.startTest();
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus request = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus();
	    request.header=header;
	    request.StatusMessage='Pass';
	    request.StatusValue='True';
	    request.ElectricMeterRead=electric;
	    request.GasMeterRead=gasRead;
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus(request);
	    System.assert(response != null);
	    test.stopTest();
    }
    
    /**
        PushConfgAssetReadStatus_to_Isis_Fail1-  cover exception.
    **/
    static testMethod void PushConfgAssetReadStatus_to_Isis_Fail1(){
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
    	
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement header = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.HeaderElement();
	    header.orgId='12345';
	    header.requestId=lstTrack[0].Name;
	    header.requestDateTime=system.now();
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register Register1 = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
	    Register1.RegisterId='1234';
	    Register1.RegisterRead=123;
	    Register1.TPR='test';
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register regs = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register();
	    regs.RegisterId = 'test RegId';
	    regs.RegisterRead = 0;
	    regs.TPR = 'test TPR';
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst Reg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.Reglst();
	    Reg.Register=  new list<EON_PushConfgAssetReadStatus_frm_M_Is_WS.Register>{regs};
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead Electric = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.ElectricMeterRead();
	    Electric.SSC = 'test';
	    //Electric.Registers = Reg;
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead Gas = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
	    Gas.GasRegisterRead=123;
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage msg = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.errMessage();
	    msg.MessageType='test';
	    msg.MessageId=123;
	    msg.MessageText='Test';
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead gasRead = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.GasMeterRead();
	    gasRead.GasRegisterRead = 100;
	    
	    //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
	    test.startTest();
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus request = new EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus();
	    request.header=header;
	    request.StatusMessage='Pass';
	    request.StatusValue='True';
	    request.ElectricMeterRead=electric;
	    request.GasMeterRead=gasRead;
	    EON_PushConfgAssetReadStatus_frm_M_Is_WS.Isis_Response_Acknowledgement_To_MIDOS response = EON_PushConfgAssetReadStatus_frm_M_Is_WS.PushConfgAssetReadStatus(request);
	    System.assert(response != null);
	    test.stopTest();
    } 
}