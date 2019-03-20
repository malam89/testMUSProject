/**
Description : This test class is for the following below classes:
              EON_OFSC_Create_Appointment    
**/

/*
    Created By  : Mahadev J
    Created On  : 15/11/2016
    Service Req: SR_EON_AB_188
    Change History
*/


@isTest
public class EON_OFSC_Create_Appointment_Test {
    public static boolean genException;
    /**
        Positive_Create() - Postitive Unit test for Create Activity
    **/ 
    static testmethod void Positive_Create(){
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = 'test'; 
        eSSC.Type__c = 'Smart';
        insert eSSC;
        
        EON_SSC_Register__c eRegister = new EON_SSC_Register__c();
        eRegister.Name = 'test';
        eRegister.Register_ID__c = 'test';
        eRegister.TPR__c = 'test';
        eRegister.SSC__c = eSSC.ID;
        insert eRegister;
        
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'test';
        insert customer;
        
        EON_Site__c eSite = new EON_Site__c();
        eSite.Customer__c = customer.ID;
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c eFuel = new EON_Fuel__c();
        eFuel.Premise__c = eSite.ID;
        eFuel.MPAN__c = 'test';
        eFuel.MPRN__c = 'test'; 
        insert eFuel;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Job__c eJob = new EON_Job__c();
        eJob.Job_Type__c = 'Smart';
        eJob.Description__c = 'test';
        insert eJob;
        
        EON_Vulnerability_Code__c eVul = new EON_Vulnerability_Code__c();
        eVul.name = 'test';
        insert eVul;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c();
        eOFSCResCode.name = '0';
        eOFSCResCode.API__c = 'Inbound';
        eOFSCResCode.Error_Warning_Success__c = 'warning';
        insert eOFSCResCode;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Requested_SSC__c = 'test';
        appt.Fuel_ID__c = eFuel.ID;
        appt.Job_Code__c = eJob.ID;
        appt.Key_Collection_Required__c = true;
        appt.Appointment_Date__c = System.Date.today();
        appt.Start_Time__c = '12:00';
        appt.End_Time__c = '10:00';
        appt.Current_Phase__c = '3Ph';
        appt.Specific_Time_flag__c = true;
        
        EON_Appointment_Vulnerability__c appVal = new EON_Appointment_Vulnerability__c();
        appVal.Description__c = eVul.ID;
        list<EON_Appointment_Vulnerability__c> allAppVal = new list<EON_Appointment_Vulnerability__c>();
        allAppVal.add(appVal);
        
        EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
        appCon.Contact_Full_Name__c = 'test';
        list<EON_Appointment_Contact__c> allAppCon = new list<EON_Appointment_Contact__c>();
        allAppCon.add(appCon);

        EON_OFSC_Create_Appointment_Wrapper appWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt, allAppVal, allAppCon);
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        String result = EON_OFSC_Create_Appointment.sendActivityToOFSC(appWrapper, 'CREATE', null, null, null, null, 'mus');
        test.stopTest();
        system.assertEquals('Job sent to OFSC successfully', result);
    }  
    
    /**
        Positive_CreateWithNoRespCode() - Postitive Unit test for Create Activity with no Response Code configred at OptiMUS
    **/ 
    static testmethod void Positive_CreateWithNoRespCode(){
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = 'test'; 
        eSSC.Type__c = 'Smart';
        insert eSSC;
        
        EON_SSC_Register__c eRegister = new EON_SSC_Register__c();
        eRegister.Name = 'test';
        eRegister.Register_ID__c = 'test';
        eRegister.TPR__c = 'test';
        eRegister.SSC__c = eSSC.ID;
        insert eRegister;
        
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'test';
        insert customer;
        
        EON_Site__c eSite = new EON_Site__c();
        eSite.Customer__c = customer.ID;
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c eFuel = new EON_Fuel__c();
        eFuel.Premise__c = eSite.ID;
        eFuel.MPAN__c = 'test';
        eFuel.MPRN__c = 'test'; 
        insert eFuel;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Job__c eJob = new EON_Job__c();
        eJob.Job_Type__c = 'Smart';
        eJob.Description__c = 'test';
        insert eJob;
        
        EON_Vulnerability_Code__c eVul = new EON_Vulnerability_Code__c();
        eVul.name = 'test';
        insert eVul;
        
        /*EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c();
        eOFSCResCode.name = '0';
        eOFSCResCode.API__c = 'Inbound';
        eOFSCResCode.Error_Warning_Success__c = 'warning';
        insert eOFSCResCode;*/
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Requested_SSC__c = 'test';
        appt.Fuel_ID__c = eFuel.ID;
        appt.Job_Code__c = eJob.ID;
        appt.Key_Collection_Required__c = true;
        appt.Appointment_Date__c = System.Date.today();
        appt.Start_Time__c = '12:00';
        appt.End_Time__c = '10:00';
        appt.Current_Phase__c = '3Ph';
        appt.Specific_Time_flag__c = true;
        appt.G_Meter_Make__c = 'AGS';
        
        EON_Appointment_Vulnerability__c appVal = new EON_Appointment_Vulnerability__c();
        appVal.Description__c = eVul.ID;
        list<EON_Appointment_Vulnerability__c> allAppVal = new list<EON_Appointment_Vulnerability__c>();
        allAppVal.add(appVal);
        
        EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
        appCon.Contact_Full_Name__c = 'test';
        list<EON_Appointment_Contact__c> allAppCon = new list<EON_Appointment_Contact__c>();
        allAppCon.add(appCon);

        EON_OFSC_Create_Appointment_Wrapper appWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt, allAppVal, allAppCon);
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        String result = EON_OFSC_Create_Appointment.sendActivityToOFSC(appWrapper, 'CREATE', null, null, null, null, 'mus');
        test.stopTest();
        system.assertEquals('Job sent to OFSC successfully', result);
    } 
    
    /**
        Positive_UpdateEle() - Postitive Unit test for Update Activity - MPAN
    **/ 
    static testmethod void Positive_UpdateEle(){
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = 'test'; 
        eSSC.Type__c = 'Smart';
        insert eSSC;
        
        EON_SSC_Register__c eRegister = new EON_SSC_Register__c();
        eRegister.Name = 'test';
        eRegister.Register_ID__c = 'test';
        eRegister.TPR__c = 'test';
        eRegister.SSC__c = eSSC.ID;
        insert eRegister;
        
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'res';
        insert customer;
        
        EON_Site__c eSite = new EON_Site__c();
        eSite.Customer__c = customer.ID;
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c eFuel = new EON_Fuel__c();
        eFuel.Premise__c = eSite.ID;
        eFuel.MPAN__c = 'test';
        eFuel.MPRN__c = 'test'; 
        insert eFuel;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Job__c eJob = new EON_Job__c();
        eJob.Job_Type__c = 'Smart';
        eJob.Description__c = 'test';
        insert eJob;
        
        EON_Vulnerability_Code__c eVul = new EON_Vulnerability_Code__c();
        eVul.name = 'test';
        insert eVul;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c();
        eOFSCResCode.name = '0';
        eOFSCResCode.API__c = 'Inbound';
        eOFSCResCode.Error_Warning_Success__c = 'warning';
        insert eOFSCResCode;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Requested_SSC__c = 'test';
        appt.Fuel_ID__c = eFuel.ID;
        appt.Job_Code__c = eJob.ID;
        appt.Key_Collection_Required__c = true;
        appt.Appointment_Date__c = System.Date.today();
        appt.Start_Time__c = '12:00';
        appt.End_Time__c = '10:00';
        appt.Current_Phase__c = '3Ph';
        appt.Specific_Time_flag__c = true;
        appt.MPAN__c = 'test';
        
        EON_Appointment_Vulnerability__c appVal = new EON_Appointment_Vulnerability__c();
        appVal.Description__c = eVul.ID;
        list<EON_Appointment_Vulnerability__c> allAppVal = new list<EON_Appointment_Vulnerability__c>();
        allAppVal.add(appVal);
        
        EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
        appCon.Contact_Full_Name__c = 'test';
        list<EON_Appointment_Contact__c> allAppCon = new list<EON_Appointment_Contact__c>();
        allAppCon.add(appCon);

        EON_OFSC_Create_Appointment_Wrapper appWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt, allAppVal, allAppCon);
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        //Test 1
        String result = EON_OFSC_Create_Appointment.sendActivityToOFSC(appWrapper, 'Update', null, null, null, null, 'mus');
        
        test.stopTest();
        system.assertEquals('Job sent to OFSC successfully', result);
    }
    
    /**
        Positive_UpdateGas() - Postitive Unit test for Update Activity - MPRN
    **/ 
    static testmethod void Positive_UpdateGas(){
        list<EON_SSC__c> allSSC = new list<EON_SSC__c>();
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = 'test'; 
        eSSC.Type__c = 'Smart';
        allSSC.add(eSSC);
        
        EON_SSC__c eSSC1 = new EON_SSC__c();
        eSSC1.Name = 'test'; 
        eSSC1.Type__c = 'Classic';
        allSSC.add(eSSC1);
        insert allSSC;
        
        EON_SSC_Register__c eRegister = new EON_SSC_Register__c();
        eRegister.Name = 'test';
        eRegister.Register_ID__c = 'test';
        eRegister.TPR__c = 'test';
        eRegister.SSC__c = eSSC.ID;
        insert eRegister;
        
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'res';
        insert customer;
        
        EON_Site__c eSite = new EON_Site__c();
        eSite.Customer__c = customer.ID;
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c eFuel = new EON_Fuel__c();
        eFuel.Premise__c = eSite.ID;
        eFuel.MPAN__c = 'test';
        eFuel.MPRN__c = 'test'; 
        insert eFuel;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Job__c eJob = new EON_Job__c();
        eJob.Job_Type__c = 'Smart';
        eJob.Description__c = 'test';
        insert eJob;
        
        EON_Vulnerability_Code__c eVul = new EON_Vulnerability_Code__c();
        eVul.name = 'test';
        insert eVul;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c();
        eOFSCResCode.name = '0';
        eOFSCResCode.API__c = 'Inbound';
        eOFSCResCode.Error_Warning_Success__c = 'warning';
        insert eOFSCResCode;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Requested_SSC__c = 'test';
        //appt.Fuel_ID__c = eFuel.ID;
        //appt.Job_Code__c = eJob.ID;
        appt.Key_Collection_Required__c = true;
        appt.Appointment_Date__c = System.Date.today();
        appt.Start_Time__c = '12:00';
        appt.End_Time__c = '10:00';
        //appt.Current_Phase__c = '3Ph';
        appt.Specific_Time_flag__c = true;
        appt.MPRN__c = 'test';
        
        EON_Appointment_Vulnerability__c appVal = new EON_Appointment_Vulnerability__c();
        appVal.Description__c = eVul.ID;
        list<EON_Appointment_Vulnerability__c> allAppVal = new list<EON_Appointment_Vulnerability__c>();
        allAppVal.add(appVal);
        
        EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
        appCon.Contact_Full_Name__c = 'test';
        list<EON_Appointment_Contact__c> allAppCon = new list<EON_Appointment_Contact__c>();
        allAppCon.add(appCon);

        EON_OFSC_Create_Appointment_Wrapper appWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt, allAppVal, allAppCon);
        EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag = true;
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        //Test 1
        String result = EON_OFSC_Create_Appointment.sendActivityToOFSC(appWrapper, 'Update', null, null, String.valueOf(System.Date.today()), null, 'MUS');
        
        test.stopTest();
        system.assertEquals('Job sent to OFSC successfully', result);
    }
    
    /**
        Positive_UpdateGasWithSSC() - Postitive Unit test for Update Activity - MPRN
    **/ 
    static testmethod void Positive_UpdateGasWithSSC(){
        list<EON_SSC__c> allSSC = new list<EON_SSC__c>();
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = 'test'; 
        eSSC.Type__c = 'Smart';
        allSSC.add(eSSC);
        
        EON_SSC__c eSSC1 = new EON_SSC__c();
        eSSC1.Name = 'test'; 
        eSSC1.Type__c = 'Classic';
        allSSC.add(eSSC1);
        insert allSSC;
        
        EON_SSC_Register__c eRegister = new EON_SSC_Register__c();
        eRegister.Name = 'test';
        eRegister.Register_ID__c = 'test';
        eRegister.TPR__c = 'test';
        eRegister.SSC__c = eSSC.ID;
        insert eRegister;
        
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'res';
        insert customer;
        
        EON_Site__c eSite = new EON_Site__c();
        eSite.Customer__c = customer.ID;
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c eFuel = new EON_Fuel__c();
        eFuel.Premise__c = eSite.ID;
        eFuel.MPAN__c = 'test';
        eFuel.MPRN__c = 'test'; 
        insert eFuel;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Job__c eJob = new EON_Job__c();
        eJob.Job_Type__c = 'Smart';
        eJob.Description__c = 'test';
        insert eJob;
        
        EON_Vulnerability_Code__c eVul = new EON_Vulnerability_Code__c();
        eVul.name = 'test';
        insert eVul;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c();
        eOFSCResCode.name = '0';
        eOFSCResCode.API__c = 'Inbound';
        eOFSCResCode.Error_Warning_Success__c = 'warning';
        insert eOFSCResCode;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Requested_SSC__c = 'test';
        appt.Fuel_ID__c = eFuel.ID;
        //appt.Job_Code__c = eJob.ID;
        appt.Key_Collection_Required__c = true;
        appt.Appointment_Date__c = System.Date.today();
        appt.Start_Time__c = '12:00';
        appt.End_Time__c = '10:00';
        //appt.Current_Phase__c = '3Ph';
        appt.Specific_Time_flag__c = true;
        appt.MPRN__c = 'test';
        appt.Planned_E_Meter_Type__c = 'MS1';
        
        EON_Appointment_Vulnerability__c appVal = new EON_Appointment_Vulnerability__c();
        appVal.Description__c = eVul.ID;
        list<EON_Appointment_Vulnerability__c> allAppVal = new list<EON_Appointment_Vulnerability__c>();
        allAppVal.add(appVal);
        
        EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
        appCon.Contact_Full_Name__c = 'test';
        list<EON_Appointment_Contact__c> allAppCon = new list<EON_Appointment_Contact__c>();
        allAppCon.add(appCon);

        EON_OFSC_Create_Appointment_Wrapper appWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt, allAppVal, allAppCon);
        EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag = true;
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        //Test 1
        String result = EON_OFSC_Create_Appointment.sendActivityToOFSC(appWrapper, 'Update', null, null, String.valueOf(System.Date.today()), null, 'MUS');
        
        test.stopTest();
        system.assertEquals('Job sent to OFSC successfully', result);
    }
    
    /**
        Positive_CreateWithError() - Postitive Unit test for Create Activity with error from Oracle - Error response code
    **/ 
    static testmethod void Positive_CreateWithError(){
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = 'test'; 
        eSSC.Type__c = 'Smart';
        insert eSSC;
        
        EON_SSC_Register__c eRegister = new EON_SSC_Register__c();
        eRegister.Name = 'test';
        eRegister.Register_ID__c = 'test';
        eRegister.TPR__c = 'test';
        eRegister.SSC__c = eSSC.ID;
        insert eRegister;
        
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'test';
        insert customer;
        
        EON_Site__c eSite = new EON_Site__c();
        eSite.Customer__c = customer.ID;
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c eFuel = new EON_Fuel__c();
        eFuel.Premise__c = eSite.ID;
        eFuel.MPAN__c = 'test';
        eFuel.MPRN__c = 'test'; 
        insert eFuel;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Job__c eJob = new EON_Job__c();
        eJob.Job_Type__c = 'Smart';
        eJob.Description__c = 'test';
        insert eJob;
        
        EON_Vulnerability_Code__c eVul = new EON_Vulnerability_Code__c();
        eVul.name = 'test';
        insert eVul;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c();
        eOFSCResCode.name = '1';
        eOFSCResCode.API__c = 'Inbound';
        eOFSCResCode.Error_Warning_Success__c = 'error';
        insert eOFSCResCode;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Requested_SSC__c = 'test';
        appt.Fuel_ID__c = eFuel.ID;
        appt.Job_Code__c = eJob.ID;
        appt.Key_Collection_Required__c = true;
        appt.Appointment_Date__c = System.Date.today();
        appt.Start_Time__c = '12:00';
        appt.End_Time__c = '10:00';
        appt.Current_Phase__c = '3Ph';
        appt.Specific_Time_flag__c = true;
        
        EON_Appointment_Vulnerability__c appVal = new EON_Appointment_Vulnerability__c();
        appVal.Description__c = eVul.ID;
        list<EON_Appointment_Vulnerability__c> allAppVal = new list<EON_Appointment_Vulnerability__c>();
        allAppVal.add(appVal);
        
        EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
        appCon.Contact_Full_Name__c = 'test';
        list<EON_Appointment_Contact__c> allAppCon = new list<EON_Appointment_Contact__c>();
        allAppCon.add(appCon);

        EON_OFSC_Create_Appointment_Wrapper appWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt, allAppVal, allAppCon);
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        EON_OFSC_Appointment_ServicesMock.methodName = 'errorResponse';
        String result = EON_OFSC_Create_Appointment.sendActivityToOFSC(appWrapper, 'CREATE', null, null, null, null, 'mus');
        test.stopTest();
        system.assertEquals('No Response Code found or error found in the Response', result);
    }  
    
    /**
        Positive_CreateWithNoErrorCode() - Postitive Unit test for Create Activity with error from Oracle - With no error response code OptiMUS
    **/ 
    static testmethod void Positive_CreateWithNoErrorCode(){
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = 'test'; 
        eSSC.Type__c = 'Smart';
        insert eSSC;
        
        EON_SSC_Register__c eRegister = new EON_SSC_Register__c();
        eRegister.Name = 'test';
        eRegister.Register_ID__c = 'test';
        eRegister.TPR__c = 'test';
        eRegister.SSC__c = eSSC.ID;
        insert eRegister;
        
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'test';
        insert customer;
        
        EON_Site__c eSite = new EON_Site__c();
        eSite.Customer__c = customer.ID;
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c eFuel = new EON_Fuel__c();
        eFuel.Premise__c = eSite.ID;
        eFuel.MPAN__c = 'test';
        eFuel.MPRN__c = 'test'; 
        insert eFuel;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Job__c eJob = new EON_Job__c();
        eJob.Job_Type__c = 'Smart';
        eJob.Description__c = 'test';
        insert eJob;
        
        EON_Vulnerability_Code__c eVul = new EON_Vulnerability_Code__c();
        eVul.name = 'test';
        insert eVul;
        
        /*EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c();
        eOFSCResCode.name = '1';
        eOFSCResCode.API__c = 'Inbound';
        eOFSCResCode.Error_Warning_Success__c = 'error';
        insert eOFSCResCode;*/
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Requested_SSC__c = 'test';
        appt.Fuel_ID__c = eFuel.ID;
        appt.Job_Code__c = eJob.ID;
        appt.Key_Collection_Required__c = true;
        appt.Appointment_Date__c = System.Date.today();
        appt.Start_Time__c = '12:00';
        appt.End_Time__c = '10:00';
        appt.Current_Phase__c = '3Ph';
        appt.Specific_Time_flag__c = true;
        
        EON_Appointment_Vulnerability__c appVal = new EON_Appointment_Vulnerability__c();
        appVal.Description__c = eVul.ID;
        list<EON_Appointment_Vulnerability__c> allAppVal = new list<EON_Appointment_Vulnerability__c>();
        allAppVal.add(appVal);
        
        EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
        appCon.Contact_Full_Name__c = 'test';
        list<EON_Appointment_Contact__c> allAppCon = new list<EON_Appointment_Contact__c>();
        allAppCon.add(appCon);

        EON_OFSC_Create_Appointment_Wrapper appWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt, allAppVal, allAppCon);
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        EON_OFSC_Appointment_ServicesMock.methodName = 'errorResponse';
        String result = EON_OFSC_Create_Appointment.sendActivityToOFSC(appWrapper, 'CREATE', null, null, null, null, 'mus');
        test.stopTest();
        system.assertEquals('No Response Code found or error found in the Response', result);
    }
    
    /**
        Positive_HandleException() - Postitive Unit test to handle exception
    **/ 
    static testmethod void Positive_HandleException(){
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Requested_SSC__c = 'test';
        appt.Key_Collection_Required__c = true;
        appt.Appointment_Date__c = System.Date.today();
        appt.Start_Time__c = '12:00';
        appt.End_Time__c = '10:00';
        appt.Current_Phase__c = '3Ph';
        appt.Specific_Time_flag__c = true;
        appt.MPRN__c = 'test';
        EON_OFSC_Create_Appointment_Wrapper appWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt, null, null); 
        
        test.startTest();
        EON_OFSC_Create_Appointment_Test.genException = true;
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        //Test 1
        String result = EON_OFSC_Create_Appointment.sendActivityToOFSC(appWrapper, 'Update', null, null, String.valueOf(System.Date.today()), null, 'MUS');
        
        test.stopTest();
        String expectedRes = 'Exception occurred Please see Error :';
        system.assertEquals(expectedRes.contains('Exception occurred Please see Error :'), result.contains('Exception occurred Please see Error :'));
        //system.assertEquals('Job sent to OFSC successfully', result);
    }
}