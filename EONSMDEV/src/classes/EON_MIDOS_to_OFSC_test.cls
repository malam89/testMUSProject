/**
Description : This test class is for the following below class
              EON_MIDOS_to_OFSC           
**/
/*
    Created By  : Dharmendra Pahadiya
    Created On  : 30/04/2016
    Service Req : SR_EON_Mobile_023
    Change History
*/
@isTest
public with sharing class EON_MIDOS_to_OFSC_test {
        
    /**
        myUnitTest1() - myUnitTest1 Success test case for subject == 'SMSAssetValidationStatus'
    **/
    public static testmethod void myUnitTest1(){
        //Create test data
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
        
        //Create Header element
        EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
        objHeader.OrgId = 'test';
        objHeader.RequestId = objAppointment.Id;
        objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
        
        //Create Electric Meter Read 
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle.RegisterId = 'test';
        objRegEle.RegisterRead = 10;
        objRegEle.TPR = 'test';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle};
        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
        objEleRead.SSC = 'test';
        objEleRead.Registers = objRegArr;
        
        //Create Gas Meter Read
        EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
        objGasRead.GasRegisterRead = 10;
        
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        objWrap.Subject = 'PushValidationStatus';
        objWrap.Header = objHeader;
        objWrap.EleMeterRead = objEleRead;
        objWrap.GasMeterRead = objGasRead;
        objWrap.AssetType = 'ELECMETER';
        objWrap.StatusMessage = 'Electric Meter validation passed';
        objWrap.StatusValue = '0';
        objWrap.ErrorMessage = '';
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    /**
        myUnitTest2() - myUnitTest2 Success test case for subject == 'ConfigureSMSOverallStatus'
    **/
    public static testmethod void myUnitTest2(){
        //Create test data
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
        
        //Create Header element
        EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
        objHeader.OrgId = 'test';
        objHeader.RequestId = objAppointment.Id;
        objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
        
        //Create Electric Meter Read 
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle.RegisterId = 'test';
        objRegEle.RegisterRead = 10;
        objRegEle.TPR = 'test';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle};
        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
        objEleRead.SSC = 'test';
        objEleRead.Registers = objRegArr;
        
        //Create Gas Meter Read
        EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
        objGasRead.GasRegisterRead = 10;
        
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        objWrap.Subject = 'PushConfigStatus';
        objWrap.Header = objHeader;
        objWrap.EleMeterRead = objEleRead;
        objWrap.GasMeterRead = objGasRead;
        objWrap.AssetType = '';
        objWrap.StatusMessage = 'SMS Configuration completed successfully';
        objWrap.StatusValue = '0';
        objWrap.ErrorMessage = '';
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    /**
        myUnitTest3() - myUnitTest3 Success test case for subject == 'PushConfgAssetReadStatus' - Electric Meter Read
    **/
    public static testmethod void myUnitTest3(){
        //Create test data
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
        
        //Create Header element
        EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
        objHeader.OrgId = 'test';
        objHeader.RequestId = objAppointment.Id;
        objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
        
        //Create Electric Meter Read 
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle.RegisterId = '01';
        objRegEle.RegisterRead = 0;
        objRegEle.TPR = '00001';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle2 = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle2.RegisterId = '02';
        objRegEle2.RegisterRead = 0;
        objRegEle2.TPR = '00002';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle3 = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle3.RegisterId = '03';
        objRegEle3.RegisterRead = 0;
        objRegEle3.TPR = '00003';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle, objRegEle2, objRegEle3};
        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
        objEleRead.SSC = '0394';
        objEleRead.Registers = objRegArr;
        
        //Create Gas Meter Read
        EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
        objGasRead.GasRegisterRead = 10;
        
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        objWrap.Subject = 'PushConfgAssetReadStatus';
        objWrap.Header = objHeader;
        objWrap.EleMeterRead = objEleRead;
        objWrap.GasMeterRead = objGasRead;
        objWrap.AssetType = '';
        objWrap.StatusMessage = 'The electric meter read has succeeded';
        objWrap.StatusValue = '0';
        objWrap.ErrorMessage = '';
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    /**
        myUnitTest4() - myUnitTest4 Success test case for subject == 'PushConfgAssetReadStatus' - Gas Meter Read
    **/
    public static testmethod void myUnitTest4(){
        //Create test data
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
        
        //Create Header element
        EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
        objHeader.OrgId = 'test';
        objHeader.RequestId = objAppointment.Id;
        objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
        
        //Create Electric Meter Read 
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle.RegisterId = '';
        objRegEle.RegisterRead = null;
        objRegEle.TPR = '';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle};
        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
        objEleRead.SSC = '';
        objEleRead.Registers = objRegArr;
        
        //Create Gas Meter Read
        EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
        objGasRead.GasRegisterRead = 2;
        
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        objWrap.Subject = 'PushConfgAssetReadStatus';
        objWrap.Header = objHeader;
        objWrap.EleMeterRead = objEleRead;
        objWrap.GasMeterRead = objGasRead;
        objWrap.AssetType = '';
        objWrap.StatusMessage = 'The gas meter read has succeeded';
        objWrap.StatusValue = '0';
        objWrap.ErrorMessage = '';
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    /**
        myUnitTest5() - myUnitTest5 Success test case for subject == 'PushConfigProgressStatus'' - GasMeter
    **/
    public static testmethod void myUnitTest5(){
        //Create test data
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
        
        //Create Header element
        EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
        objHeader.OrgId = 'test';
        objHeader.RequestId = objAppointment.Id;
        objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
        
        //Create Electric Meter Read 
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle.RegisterId = 'test';
        objRegEle.RegisterRead = 10;
        objRegEle.TPR = 'test';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle};
        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
        objEleRead.SSC = 'test';
        objEleRead.Registers = objRegArr;
        
        //Create Gas Meter Read
        EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
        objGasRead.GasRegisterRead = 10;
        
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        objWrap.Subject = 'PushConfigProgressStatus';
        objWrap.Header = objHeader;
        objWrap.EleMeterRead = objEleRead;
        objWrap.GasMeterRead = objGasRead;
        objWrap.AssetType = 'GASMETER';
        objWrap.StatusMessage = 'Electric Meter validation passed';
        objWrap.StatusValue = '0';
        objWrap.ErrorMessage = '';
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    /**
        myUnitTest6() - myUnitTest6 Success test case for subject == 'PushConfigProgressStatus'' - HUB
    **/
    public static testmethod void myUnitTest6(){
        //Create test data
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
        
        //Create Header element
        EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
        objHeader.OrgId = 'test';
        objHeader.RequestId = objAppointment.Id;
        objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
        
        //Create Electric Meter Read 
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle.RegisterId = 'test';
        objRegEle.RegisterRead = 10;
        objRegEle.TPR = 'test';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle};
        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
        objEleRead.SSC = 'test';
        objEleRead.Registers = objRegArr;
        
        //Create Gas Meter Read
        EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
        objGasRead.GasRegisterRead = 10;
        
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        objWrap.Subject = 'PushConfigProgressStatus';
        objWrap.Header = objHeader;
        objWrap.EleMeterRead = objEleRead;
        objWrap.GasMeterRead = objGasRead;
        objWrap.AssetType = 'HUB';
        objWrap.StatusMessage = 'Electric Meter validation passed';
        objWrap.StatusValue = '0';
        objWrap.ErrorMessage = '';
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    /**
        myUnitTest7() - myUnitTest7 Success test case for subject == 'PushConfigProgressStatus'' - IHD
    **/
    public static testmethod void myUnitTest7(){
        //Create test data
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
        
        //Create Header element
        EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
        objHeader.OrgId = 'test';
        objHeader.RequestId = objAppointment.Id;
        objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
        
        //Create Electric Meter Read 
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle.RegisterId = 'test';
        objRegEle.RegisterRead = 10;
        objRegEle.TPR = 'test';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle};
        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
        objEleRead.SSC = 'test';
        objEleRead.Registers = objRegArr;
        
        //Create Gas Meter Read
        EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
        objGasRead.GasRegisterRead = 10;
        
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        objWrap.Subject = 'PushConfigProgressStatus';
        objWrap.Header = objHeader;
        objWrap.EleMeterRead = objEleRead;
        objWrap.GasMeterRead = objGasRead;
        objWrap.AssetType = 'IHD';
        objWrap.StatusMessage = 'Electric Meter validation passed';
        objWrap.StatusValue = '0';
        objWrap.ErrorMessage = '';
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    /**
        myUnitTest8() - myUnitTest8 Failure web service test case
    **/
    public static testmethod void myUnitTest8(){
        //Create test data
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
        
        //Create Header element
        EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
        objHeader.OrgId = 'test';
        objHeader.RequestId = objAppointment.Id;
        objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
        
        //Create Electric Meter Read 
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle.RegisterId = 'test';
        objRegEle.RegisterRead = 10;
        objRegEle.TPR = 'test';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle};
        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
        objEleRead.SSC = 'test';
        objEleRead.Registers = objRegArr;
        
        //Create Gas Meter Read
        EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
        objGasRead.GasRegisterRead = 10;
        
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        objWrap.Subject = 'PushConfigProgressStatus';
        objWrap.Header = objHeader;
        objWrap.EleMeterRead = objEleRead;
        objWrap.GasMeterRead = objGasRead;
        objWrap.AssetType = 'IHD';
        objWrap.StatusMessage = 'Electric Meter validation passed';
        objWrap.StatusValue = '0';
        objWrap.ErrorMessage = '';
        
        //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    /**
        myUnitTest9() - myUnitTest9 Failure response from  web service test case
    **/
    public static testmethod void myUnitTest9(){
        //Create test data
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
        
        //Create Header element
        EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
        objHeader.OrgId = 'test';
        objHeader.RequestId = objAppointment.Id;
        objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
        
        //Create Electric Meter Read 
        EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
        objRegEle.RegisterId = 'test';
        objRegEle.RegisterRead = 10;
        objRegEle.TPR = 'test';
        EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle};
        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
        objEleRead.SSC = 'test';
        objEleRead.Registers = objRegArr;
        
        //Create Gas Meter Read
        EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
        objGasRead.GasRegisterRead = 10;
        
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        objWrap.Subject = 'PushConfigProgressStatus';
        objWrap.Header = objHeader;
        objWrap.EleMeterRead = objEleRead;
        objWrap.GasMeterRead = objGasRead;
        objWrap.AssetType = 'IHD';
        objWrap.StatusMessage = 'Electric Meter validation passed';
        objWrap.StatusValue = '0';
        objWrap.ErrorMessage = '';
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    /**
        myUnitTest10() - myUnitTest10 Failure test case
    **/
    public static testmethod void myUnitTest10(){
        //Create test data
        //Create Wrapper object
        EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
        
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
                
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest();
        EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        Test.stopTest();        
    }
    
    
    
     /**
        myUnitTest11() - myUnitTest11 myUnitTest7 Success test case for subject == 'MIDOS Failure Update'' - IHD
    **/
  public static testmethod void myUnitTest11(){
    //Create test data
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
        
    //Create Header element
    EON_MIDOS_To_Isis_Wrapper.HeaderElement objHeader = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
    objHeader.OrgId = 'test';
    objHeader.RequestId = objAppointment.Id;
    objHeader.RequestDateTime = datetime.now(); //2016-01-18 15:47
    
    //Create Electric Meter Read 
    EON_MIDOS_To_Isis_Wrapper.RegisterElement objRegEle = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
    objRegEle.RegisterId = 'test';
    objRegEle.RegisterRead = 10;
    objRegEle.TPR = 'test';
    EON_MIDOS_To_Isis_Wrapper.RegisterElement[] objRegArr = new EON_MIDOS_To_Isis_Wrapper.RegisterElement[]{objRegEle};
    EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element objEleRead = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
    objEleRead.SSC = 'test';
    objEleRead.Registers = objRegArr;
    
    //Create Gas Meter Read
    EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element objGasRead = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
    objGasRead.GasRegisterRead = 10;
    
    //Create Wrapper object
    EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
    objWrap.Subject = 'MIDOS Failure Update';
    objWrap.Header = objHeader;
    objWrap.EleMeterRead = objEleRead;
    objWrap.GasMeterRead = objGasRead;
    objWrap.AssetType = 'IHD';
    objWrap.StatusMessage = 'Electric Meter validation passed';
    objWrap.StatusValue = '0';
    objWrap.ErrorMessage = '';
    
    Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
    Test.startTest();
    EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
    Test.stopTest();    
  }
    
    
    
    
}