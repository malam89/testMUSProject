/**
Description : This test class is for the following classes
              EON_Campaign_File_Process
**/
/*
    Created By  : Mahadev Joshilkar
    Created On  : 11/07/2016
    Service Req : SR_EON_PC_067
    Change History 
*/
@isTest
global class EON_Validate_Fuel_From_Jumbo_Test implements WebServiceMock{
    public static string methodType='';
    /**
        setup(): Method to setup test data for the class
    **/
    @testSetup static void setup(){ 
        
        EON_Campaign__c campaign = EON_CreateTestRecords.createEONCampaign();
        campaign.Campaign_Type__c = 'SME';
        insert campaign;
        String finalStr='MPRN,MPAN,Cust ID,Premise SFID,Cust SFID,Campaign Letter,Smart ,Re-Cert,Opt in / Opt out preference'+'\r\n';
        finalStr+='1111'+','+'2221'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        finalStr+='1112'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        finalStr+=''+','+'2222'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        Attachment attach = new Attachment();
        attach.ParentId = campaign.ID;
        attach.Name = 'test.csv';
        attach.ContentType = 'application/vnd.ms-excel';
        attach.Body = Blob.valueOf(finalStr);
        insert attach;
    }
    /**
        validMopMam(): This is success scenario with valid response for J20 and J21 from Jumbo where we are MOP or MAM- PASS
    **/
    static testmethod void validMopMam(){
        EON_Campaign__c campaign = [Select ID from EON_Campaign__c where Campaign_Type__c = 'SME' limit 1];
        Attachment attach = [Select ID, Name, ParentID from Attachment where ParentID=:campaign.Id limit 1];
        map<String, list<String>> mapMPAN = new map<String, list<String>>();
        list<String> allMPAN = new list<String>();
        list<String> FuelAll = new list<String>();
        allMPAN.add('1111');
        allMPAN.add('2222');
        mapMPAN.put('E', allMPAN);
        list<String> allMPRN = new list<String>();
        allMPRN.add('3333');
        allMPRN.add('4444');
        mapMPAN.put('G', allMPRN);
        FuelAll.addAll(allMPAN);
        FuelAll.addAll(allMPRN);
        list<EON_Campaign_Csv__c> fileData = new list<EON_Campaign_Csv__c>();
        fileData.add(new EON_Campaign_Csv__c(Name='1', MPAN__c='2221', MPRN__c='1111',Campaign_Letter__c='No Campaign Flag'));
        fileData.add(new EON_Campaign_Csv__c(Name='2', MPAN__c='2222', MPRN__c='4444',Campaign_Letter__c='No Campaign Flag'));
        insert fileData;
        
        List<EON_Campaign_Csv__c> csvdata;
        EON_Customer__c customer1 = EON_CreateTestRecords.createEONCustomer();
        customer1.Name = '9988776655';
        customer1.Smart_Interest__c = 'N';
        customer1.Customer_group_type__c = 'RES';
        customer1.Customer_Name__c = 'False-RES-N'; //Campaign Flag, Customer_group_type__c, Smart Integerest
        insert customer1;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Customer__c = customer1.ID;
        insert eSite;
        EON_Fuel__c eFuelDF = EON_CreateTestRecords.createEONFuel();
        eFuelDF.Premise__c = eSite.ID;
        eFuelDF.MPRN__c = '1111';
        eFuelDF.MPAN__c = '2221';
        insert eFuelDF;
        EON_Fuel__c eFuelGas = EON_CreateTestRecords.createEONFuel();
        eFuelGas.Premise__c = eSite.ID;
        eFuelGas.MPRN__c = '4444';
        eFuelGas.Fuel_type__c = 'G';
        insert eFuelGas;
        
        EON_Fuel__c eFuelElec = EON_CreateTestRecords.createEONFuel();
        eFuelElec.Premise__c = eSite.ID;
        eFuelElec.MPAN__c = '2222';
        insert eFuelElec;
        
        Map<String, EON_Fuel__c> MapFuelMpan= new Map<String, EON_Fuel__c>();
        MapFuelMpan.put(eFuelDF.MPAN__c,eFuelDF);
        MapFuelMpan.put(eFuelGas.MPAN__c,eFuelGas);
        MapFuelMpan.put(eFuelElec.MPAN__c,eFuelElec);
        Map<String, EON_Fuel__c> MapFuelMprn= new Map<String, EON_Fuel__c>();
        MapFuelMprn.put(eFuelDF.MPRN__c,eFuelDF);
        MapFuelMprn.put(eFuelGas.MPRN__c,eFuelGas);
        MapFuelMprn.put(eFuelElec.MPRN__c,eFuelElec);
        
        EON_Validate_Fuel_From_Jumbo validateFuel = new EON_Validate_Fuel_From_Jumbo();
        validateFuel.FuelAll = FuelAll;
        validateFuel.csvdata = fileData;
        validateFuel.attach = attach;
        validateFuel.MpanValues=allMPAN;
        validateFuel.MprnValues=allMPRN;  
        validateFuel.MapFuelMpan=MapFuelMpan;
        validateFuel.MapFuelMprn=MapFuelMprn;
        
        Test.setMock(WebServiceMock.class, new EON_Validate_Fuel_From_Jumbo_Test());
        EON_Validate_Fuel_From_Jumbo_Test.methodType ='WeAreMOPorMAM';
        
        test.startTest();
        ID batchprocessid = Database.executeBatch(validateFuel);
        test.stopTest();
    }
    /**
        invalidMopMam(): This is success scenario with valid response for J20 and J21 from Jumbo where we are not MOP or MAM- PASS
    **/
    static testmethod void invalidMopMam(){
        EON_Campaign__c campaign = [Select ID from EON_Campaign__c where Campaign_Type__c = 'SME' limit 1];
        Attachment attach = [Select ID, Name, ParentID from Attachment where ParentID=:campaign.Id limit 1];
        map<String, list<String>> mapMPAN = new map<String, list<String>>();
        list<String> allMPAN = new list<String>();
        list<String> FuelAll = new list<String>();
        allMPAN.add('1111');
        allMPAN.add('2222');
        mapMPAN.put('E', allMPAN);
        list<String> allMPRN = new list<String>();
        allMPRN.add('3333');
        allMPRN.add('4444');
        mapMPAN.put('G', allMPRN);
        FuelAll.addAll(allMPAN);
        FuelAll.addAll(allMPRN);
        list<EON_Campaign_Csv__c> fileData = new list<EON_Campaign_Csv__c>();
        fileData.add(new EON_Campaign_Csv__c(Name='1', MPAN__c='2221', MPRN__c='1111',Campaign_Letter__c='No Campaign Flag'));
        fileData.add(new EON_Campaign_Csv__c(Name='2', MPAN__c='2222', MPRN__c='4444',Campaign_Letter__c='No Campaign Flag'));
        insert fileData;
        
        EON_Customer__c customer1 = EON_CreateTestRecords.createEONCustomer();
        customer1.Name = '9988776655';
        customer1.Smart_Interest__c = 'N';
        customer1.Customer_group_type__c = 'RES';
        customer1.Customer_Name__c = 'False-RES-N'; //Campaign Flag, Customer_group_type__c, Smart Integerest
        insert customer1;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Customer__c = customer1.ID;
        insert eSite;
        EON_Fuel__c eFuelDF = EON_CreateTestRecords.createEONFuel();
        eFuelDF.Premise__c = eSite.ID;
        eFuelDF.MPRN__c = '1111';
        eFuelDF.MPAN__c = '2221';
        insert eFuelDF;
        EON_Fuel__c eFuelGas = EON_CreateTestRecords.createEONFuel();
        eFuelGas.Premise__c = eSite.ID;
        eFuelGas.MPRN__c = '4444';
        eFuelGas.Fuel_type__c = 'G';
        insert eFuelGas;
        
        EON_Fuel__c eFuelElec = EON_CreateTestRecords.createEONFuel();
        eFuelElec.Premise__c = eSite.ID;
        eFuelElec.MPAN__c = '2222';
        insert eFuelElec;
        
        Map<String, EON_Fuel__c> MapFuelMpan= new Map<String, EON_Fuel__c>();
        MapFuelMpan.put(eFuelDF.MPAN__c,eFuelDF);
        MapFuelMpan.put(eFuelGas.MPAN__c,eFuelGas);
        MapFuelMpan.put(eFuelElec.MPAN__c,eFuelElec);
        Map<String, EON_Fuel__c> MapFuelMprn= new Map<String, EON_Fuel__c>();
        MapFuelMprn.put(eFuelDF.MPRN__c,eFuelDF);
        MapFuelMprn.put(eFuelGas.MPRN__c,eFuelGas);
        MapFuelMprn.put(eFuelElec.MPRN__c,eFuelElec);
        
        EON_Validate_Fuel_From_Jumbo validateFuel = new EON_Validate_Fuel_From_Jumbo();
        validateFuel.FuelAll = FuelAll;
        validateFuel.csvdata = fileData;
        validateFuel.attach = attach;
        validateFuel.MpanValues=allMPAN;
        validateFuel.MprnValues=allMPRN; 
        validateFuel.MapFuelMpan=MapFuelMpan;
        validateFuel.MapFuelMprn=MapFuelMprn;
        
        Test.setMock(WebServiceMock.class, new EON_Validate_Fuel_From_Jumbo_Test());
        EON_Validate_Fuel_From_Jumbo_Test.methodType ='WeAreNotMOPorMAM';
        
        Test.setMock(WebServiceMock.class, new EON_Validate_Fuel_From_Jumbo_Test());
        EON_Validate_Fuel_From_Jumbo_Test.methodType ='WeAreNotMOPorMAM1';
        
        test.startTest();
        ID batchprocessid = Database.executeBatch(validateFuel);
        test.stopTest();
    }
    /**
        errorMopMam(): This is failure scenario with null in response for J20 and J21 from Jumbo.
    **/
    static testmethod void errorMopMam(){
        EON_Customer__c customer1 = EON_CreateTestRecords.createEONCustomer();
        customer1.Name = '9988776655';
        customer1.Smart_Interest__c = 'N';
        customer1.Customer_group_type__c = 'RES';
        customer1.Customer_Name__c = 'False-RES-N'; //Campaign Flag, Customer_group_type__c, Smart Integerest
        insert customer1;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Customer__c = customer1.ID;
        insert eSite;
        
        EON_Fuel__c eFuelDF = EON_CreateTestRecords.createEONFuel();
        eFuelDF.Premise__c = eSite.ID;
        eFuelDF.MPRN__c = '1111';
        eFuelDF.MPAN__c = '2221';
        insert eFuelDF;
        
        EON_Fuel__c eFuelGas = EON_CreateTestRecords.createEONFuel();
        eFuelGas.Premise__c = eSite.ID;
        eFuelGas.MPRN__c = '4444';
        eFuelGas.Fuel_type__c = 'G';
        insert eFuelGas;
        
        EON_Fuel__c eFuelElec = EON_CreateTestRecords.createEONFuel();
        eFuelElec.Premise__c = eSite.ID;
        eFuelElec.MPAN__c = '2222';
        insert eFuelElec;
        
        EON_Campaign__c campaign = [Select ID from EON_Campaign__c where Campaign_Type__c = 'SME' limit 1];
        Attachment attach = [Select ID, Name, ParentID from Attachment where ParentID=:campaign.Id limit 1];
        map<String, list<String>> mapMPAN = new map<String, list<String>>();
        list<String> allMPAN = new list<String>();
        list<String> FuelAll = new list<String>();
        allMPAN.add('2221');
        allMPAN.add('2222');
        mapMPAN.put('E', allMPAN);
        list<String> allMPRN = new list<String>();
        allMPRN.add('1111');
        allMPRN.add('4444');
        mapMPAN.put('G', allMPRN);
        FuelAll.addAll(allMPAN);
        FuelAll.addAll(allMPRN);
        list<EON_Campaign_Csv__c> fileData = new list<EON_Campaign_Csv__c>();
        fileData.add(new EON_Campaign_Csv__c(Name='1', MPAN__c='2221', MPRN__c='1111',Campaign_Letter__c='No Campaign Flag'));
        fileData.add(new EON_Campaign_Csv__c(Name='2', MPAN__c='2222', MPRN__c='4444',Campaign_Letter__c='No Campaign Flag'));
        insert fileData;       
        
        
        Map<String, EON_Fuel__c> MapFuelMpan= new Map<String, EON_Fuel__c>();
        MapFuelMpan.put(eFuelDF.MPAN__c,eFuelDF);
        MapFuelMpan.put(eFuelGas.MPAN__c,eFuelGas);
        MapFuelMpan.put(eFuelElec.MPAN__c,eFuelElec);
        Map<String, EON_Fuel__c> MapFuelMprn= new Map<String, EON_Fuel__c>();
        MapFuelMprn.put(eFuelDF.MPRN__c,eFuelDF);
        MapFuelMprn.put(eFuelGas.MPRN__c,eFuelGas);
        MapFuelMprn.put(eFuelElec.MPRN__c,eFuelElec);
        
        EON_Validate_Fuel_From_Jumbo validateFuel = new EON_Validate_Fuel_From_Jumbo();
        validateFuel.FuelAll = FuelAll;
        validateFuel.csvdata = fileData;
        validateFuel.attach = attach;
        validateFuel.MpanValues=allMPAN;
        validateFuel.MprnValues=allMPRN; 
        validateFuel.MapFuelMpan=MapFuelMpan;
        validateFuel.MapFuelMprn=MapFuelMprn;
        
        Test.setMock(WebServiceMock.class, new EON_Validate_Fuel_From_Jumbo_Test());
        EON_Validate_Fuel_From_Jumbo_Test.methodType ='nullMOPMAM';
        
        test.startTest();
        ID batchprocessid = Database.executeBatch(validateFuel);
        test.stopTest();
    }
    /**
        doInvoke() - Mock Responses for Jumbo web services
    **/
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType){
        system.debug('####Request: '+request);
        if(methodType =='WeAreMOPorMAM'){
            if(request instanceof EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty(); 
                eapObj.EffectiveFromDate ='2015-04-23';
                eapObj.EffectiveToDate='2016-08-23';
                eapObj.MarketParticipantId='EMEB';
                EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[]{eapObj};
                EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
                aepObj.ElecAppointedParty = aEobj;
                EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
                //empObj.MPAN = 'mpan123';
                empObj.MPAN = '1111';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
                obj.RequestElectricitySupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
            if(request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
                gasAObj.EffectiveFromDate ='2015-04-23';
                gasAObj.EffectiveToDate='2016-08-23';
                gasAObj.AbbreviatedName='MORR';
                EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[]{gasAObj};
                EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                aepObj.GasAppointedParty = gasAppobj;
                EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                //empObj.MPRN = 'mprn123';
                empObj.MPRN = '3333';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
            
                if(methodType =='WeAreMOPorMAM1'){
            if(request instanceof EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty(); 
                eapObj.EffectiveFromDate ='2015-04-23';
                eapObj.EffectiveToDate='2016-08-23';
                eapObj.MarketParticipantId='';
                EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[]{eapObj};
                EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
                aepObj.ElecAppointedParty = aEobj;
                EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
                //empObj.MPAN = 'mpan123';
                empObj.MPAN = '1111';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
                obj.RequestElectricitySupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
            if(request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
                gasAObj.EffectiveFromDate ='2015-04-23';
                gasAObj.EffectiveToDate='2016-08-23';
                gasAObj.AbbreviatedName='MORR';
                EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[]{gasAObj};
                EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                aepObj.GasAppointedParty = gasAppobj;
                EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                //empObj.MPRN = 'mprn123';
                empObj.MPRN = '3333';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
        }
        if(methodType =='WeAreNotMOPorMAM'){
            if(request instanceof EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty(); 
                eapObj.EffectiveFromDate ='2015-04-23';
                eapObj.EffectiveToDate='2016-08-23';
                eapObj.MarketParticipantId='CCCC';
                EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[]{eapObj};
                EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
                aepObj.ElecAppointedParty = aEobj;
                EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
                //empObj.MPAN = 'mpan123';
                empObj.MPAN = '1111';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
                obj.RequestElectricitySupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
            if(request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
                gasAObj.EffectiveFromDate ='2015-04-23';
                gasAObj.EffectiveToDate='2016-08-23';
                gasAObj.AbbreviatedName='DDDD';
                EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[]{gasAObj};
                EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                aepObj.GasAppointedParty = gasAppobj;
                EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                //empObj.MPRN = 'mprn123';
                empObj.MPRN = '3333';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
        }
        if(methodType =='nullMOPMAM'){
            if(request instanceof EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty(); 
                eapObj.EffectiveFromDate ='2015-04-23';
                eapObj.EffectiveToDate='2016-08-23';
                eapObj.MarketParticipantId='EMEB';
                EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[]{eapObj};
                EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
                aepObj.ElecAppointedParty = aEobj;
                EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
                //empObj.MPAN = 'mpan123';
                empObj.MPAN = '1111';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
                obj.RequestElectricitySupplierAppointmentsResult = respJumbo;
                response.put('response_x', null);
            }
            if(request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
                gasAObj.EffectiveFromDate ='2015-04-23';
                gasAObj.EffectiveToDate='2016-08-23';
                gasAObj.AbbreviatedName='MORR';
                EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[]{gasAObj};
                EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                aepObj.GasAppointedParty = gasAppobj;
                EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                //empObj.MPRN = 'mprn123';
                empObj.MPRN = '3333';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', null);
            }
        }
    }
}
}