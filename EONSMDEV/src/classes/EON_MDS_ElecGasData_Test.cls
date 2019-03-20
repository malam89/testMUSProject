/**
Description : This test class is for the following below classes/triggers
              EON_MDS_ReqGasMAM
              EON_MDS_ReqElecMeterPointData
              EON_MDS_ReqElectricityMOP
              EON_MDS_ReqGasMeterPointData             
**/

/*
    Created By  : Tabish Almas
    Created On  : 05/02/2019
    Service Req : SR_EON_297
    Change History :
*/

@isTest
global class EON_MDS_ElecGasData_Test implements WebServiceMock {
    public static EON_Appointment__c appt  = new EON_Appointment__c();
    public static string functionType='';
    public static string MPAN = '12345';
    public static string MPRN = '12345';

   testmethod static void MPANInddata(){
     
     EON_Electric_Meter_Type__c eleMObj = new EON_Electric_Meter_Type__c();
     eleMObj.Name = 'S1';
     insert eleMObj;
     
     EON_Electric_Meter_Location__c LocObj = new EON_Electric_Meter_Location__c();
     LocObj.Code__c = 'loc';
     insert LocObj;
     
     //CH02.Start
     EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c();
     vulCode.JUMBO_Vulnerability_Code__c = 1;
     insert vulCode;
     //CH02.End
     EON_Jumbo_E_G_Meter_Types_Mappings__c meterTypeMapping = new EON_Jumbo_E_G_Meter_Types_Mappings__c();
     meterTypeMapping.Name = 'S1';
     meterTypeMapping.Meter_Type__c = 'E';
     meterTypeMapping.Planned_Meter_Type__c = 'test';
     insert meterTypeMapping;
     
     //EON_MDS_ReqElecMeterPointData.PlannedMtrType(null);
     EON_MDS_ReqElecMeterPointData.nPhases(null);
     
     Test.setMock(WebServiceMock.class, new EON_MDS_ElecGasData_Test());

     Test.startTest();    
     //Scenario-1
     EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData('',appt,'','');
     
     //Scenario-2
     functionType ='MPANInddata';
     EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(MPAN,appt,'','');
     
     //Scenario-3
     functionType ='MPANInddata_fail1';
     EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(MPAN,appt,'','');
     
     //Scenario-4
     functionType ='MPANInddata_fail2';
     EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(MPAN,appt,'','');
     Test.stopTest();         
   }
    
    
   testmethod static void validateMOP(){
     EON_MDS_ReqElectricityMOP.supplierDesc('test');
     Test.setMock(WebServiceMock.class, new EON_MDS_ElecGasData_Test());
     //Scenario-1
     EON_MDS_ReqElectricityMOP.ValidateMPANMOP('');
     
     //Scenario-2
     functionType ='validateMOP';
     appt.Appointment_Date__c = date.today();
     EON_MDS_ReqElectricityMOP.ValidateMPANMOP(MPAN);
 
     //Scenario-3
     functionType ='validateMOP_fail1';
     EON_MDS_ReqElectricityMOP.ValidateMPANMOP(MPAN);
     
     //Scenario-4
     functionType ='validateMOP_fail2';
     EON_MDS_ReqElectricityMOP.ValidateMPANMOP(MPAN);
     
     //Scenario-5
     functionType ='validateMOP_fail3';
     EON_MDS_ReqElectricityMOP.ValidateMPANMOP(MPAN);
     
   }
    
    
   testmethod static void validateMAM(){ 
     EON_MDS_ReqGasMAM.supplierDesc('test');
     Test.setMock(WebServiceMock.class, new EON_MDS_ElecGasData_Test());
     
     //Scenario-1
     EON_MDS_ReqGasMAM.ValidateMPRNMAM('');
     
     //Scenario-2
     functionType ='validateMAM';
     appt.Appointment_Date__c = date.today();
     EON_MDS_ReqGasMAM.ValidateMPRNMAM(MPRN); 
     
     //Scenario-3
     functionType ='validateMAM_fail1';
     EON_MDS_ReqGasMAM.ValidateMPRNMAM(MPRN); 
         
     //Scenario-4
     functionType ='validateMAM_fail2';
     EON_MDS_ReqGasMAM.ValidateMPRNMAM(MPRN);
     
     //Scenario-5
     functionType ='validateMAM_fail3';
     EON_MDS_ReqGasMAM.ValidateMPRNMAM(MPRN); 
   }
    
    
   testmethod static void MPRNInddata(){  
     
     EON_Gas_Meter_Type__c gasMObj = new EON_Gas_Meter_Type__c();
     gasMObj.Name = 'Type_x';
     gasMObj.Industry_Code__c= 'P';
     insert gasMObj;   
     
     EON_Gas_Meter_Mechanism__c metMObj = new EON_Gas_Meter_Mechanism__c();
     metMObj.name= 'Mechanism';
     metMObj.Code__c= 'CR';
     
     insert metMObj;

     EON_Gas_Meter_Location__c gasLoc = new EON_Gas_Meter_Location__c();
     gasLoc.name = 'Location';
     gasLoc.Code__c= 'AT';
     insert gasLoc;
     
     EON_Jumbo_E_G_Meter_Types_Mappings__c meterTypeMapping = new EON_Jumbo_E_G_Meter_Types_Mappings__c();
     meterTypeMapping.Name = 'CR';
     meterTypeMapping.Meter_Type__c = 'G';
     meterTypeMapping.Planned_Meter_Type__c = 'test';
     insert meterTypeMapping;
     
     EON_MDS_ReqGasMeterPointData.displayConMech('VIS');
     EON_MDS_ReqGasMeterPointData.registerTypeCode('VIS');
     EON_MDS_ReqGasMeterPointData.personTypeCode('VIS');
     //EON_MDS_ReqGasMeterPointData.PlannedMtrType(null);
     EON_MDS_ReqGasMeterPointData.GMeteringPressure('1');
     Test.setMock(WebServiceMock.class, new EON_MDS_ElecGasData_Test());
     //Scenario-1
     Test.startTest();
     EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData('',appt,'','');
     
     //Scenario-2
     functionType ='MPRNInddata'; 
     EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(MPRN,appt,'','');
     
     //Scenario-3
     functionType ='MPRNInddata_fail1';
     EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(MPRN,appt,'','');
     
      //Scenario-4
     functionType ='MPRNInddata_fail2';
     EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(MPRN,appt,'','');
     Test.stopTest();     
   }
   
   global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType){
     if(functionType =='validateMOP'){   
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
        errObj.Message = Msg;
        EON_MDS_Work_Management_WS.ElecAppointedParty eapObj = new EON_MDS_Work_Management_WS.ElecAppointedParty(); 
        //eapObj.EffectiveFromDate ='2015-04-23';  //CH04.Old
        //eapObj.EffectiveToDate='2016-08-23';  //CH04.Old
        eapObj.EffectiveFromDate ='20150423'; //CH04.New
        //eapObj.EffectiveToDate='20160823';    //CH04.New
        eapObj.EffectiveToDate= system.today().year() + '' + system.today().month() + '' + system.today().day();    //CH04.New
        eapObj.MarketParticipantId='EMEB';
        EON_MDS_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_MDS_Work_Management_WS.ElecAppointedParty[]{eapObj};
        EON_MDS_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_MDS_Work_Management_WS.ArrayOfElecAppointedParty();
        aepObj.ElecAppointedParty = aEobj;
        EON_MDS_Work_Management_WS.ElecMeterPoint empObj = new EON_MDS_Work_Management_WS.ElecMeterPoint();
        empObj.MPAN = 'mpan123';
        empObj.SupplierAppointments = aepObj;
        EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse();
        respMDS.Success = true;
        respMDS.MeterPoint=empObj;
        respMDS.Errors = errObj;
        EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
        obj.RequestElectricitySupplierAppointmentsResult = respMDS;
        response.put('response_x', obj);
     }
     
     
     if(functionType =='validateMOP_fail1'){   
        EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse();
        respMDS.Success = true;
        response.put('response_x', respMDS);
     }
     
          
     if(functionType =='validateMOP_fail2'){   
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
        errObj.Message = Msg;
        EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse();
        respMDS.Success = false;
        respMDS.Errors = errObj;
        EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
        obj.RequestElectricitySupplierAppointmentsResult = respMDS;
        response.put('response_x', obj);
     }
     
     
      if(functionType =='validateMOP_fail3'){   
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
        errObj.Message = Msg;
        EON_MDS_Work_Management_WS.ElecAppointedParty eapObj = new EON_MDS_Work_Management_WS.ElecAppointedParty(); 
        eapObj.EffectiveFromDate ='2015-04-23';
        eapObj.EffectiveToDate='2016-08-23';
        eapObj.MarketParticipantId='MOR';
        EON_MDS_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_MDS_Work_Management_WS.ElecAppointedParty[]{eapObj};
        EON_MDS_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_MDS_Work_Management_WS.ArrayOfElecAppointedParty();
        aepObj.ElecAppointedParty = aEobj;
        EON_MDS_Work_Management_WS.ElecMeterPoint empObj = new EON_MDS_Work_Management_WS.ElecMeterPoint();
        empObj.MPAN = 'mpan123';
        empObj.SupplierAppointments = aepObj;
        EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse();
        respMDS.Success = true;
        respMDS.MeterPoint=empObj;
        respMDS.Errors = errObj;
        EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
        obj.RequestElectricitySupplierAppointmentsResult = respMDS;
        response.put('response_x', obj);
     }
     
     
      if(functionType =='validateMAM'){   
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
        errObj.Message = Msg;
        EON_MDS_Work_Management_WS.GasAppointedParty gasAObj = new EON_MDS_Work_Management_WS.GasAppointedParty(); 
        gasAObj.EffectiveFromDate ='2015-04-23';
        gasAObj.EffectiveToDate='2016-08-23';
        gasAObj.AbbreviatedName='SGL';
        EON_MDS_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_MDS_Work_Management_WS.GasAppointedParty[]{gasAObj};
        EON_MDS_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_MDS_Work_Management_WS.ArrayOfGasAppointedParty();
        aepObj.GasAppointedParty = gasAppobj;
        EON_MDS_Work_Management_WS.GasMeterPoint empObj = new EON_MDS_Work_Management_WS.GasMeterPoint();
        empObj.MPRN = 'mprn123';
        empObj.SupplierAppointments = aepObj;
        EON_MDS_Work_Management_WS.GasSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.GasSupplierDetailsResponse();
        respMDS.Success = true;
        respMDS.MeterPoint=empObj;
        respMDS.Errors = errObj;
        EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
        obj.RequestGasSupplierAppointmentsResult = respMDS;
        response.put('response_x', obj);
     }
     
     if(functionType =='validateMAM_fail1'){   
        EON_MDS_Work_Management_WS.GasSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.GasSupplierDetailsResponse();
        respMDS.Success = true;
        response.put('response_x', respMDS);
     }
     
          
     if(functionType =='validateMAM_fail2'){  
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
        errObj.Message = Msg; 
        EON_MDS_Work_Management_WS.GasSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.GasSupplierDetailsResponse();
        respMDS.Success = false;
        respMDS.Errors = errObj;
        EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
        obj.RequestGasSupplierAppointmentsResult = respMDS;
        response.put('response_x', obj);
     }
     
     
      if(functionType =='validateMAM_fail3'){   
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
        errObj.Message = Msg;
        EON_MDS_Work_Management_WS.GasAppointedParty gasAObj = new EON_MDS_Work_Management_WS.GasAppointedParty(); 
        gasAObj.EffectiveFromDate ='2015-04-23';
        gasAObj.EffectiveToDate='2016-08-23';
        gasAObj.AbbreviatedName='MOR';
        EON_MDS_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_MDS_Work_Management_WS.GasAppointedParty[]{gasAObj};
        EON_MDS_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_MDS_Work_Management_WS.ArrayOfGasAppointedParty();
        aepObj.GasAppointedParty = gasAppobj;
        EON_MDS_Work_Management_WS.GasMeterPoint empObj = new EON_MDS_Work_Management_WS.GasMeterPoint();
        empObj.MPRN = 'mprn123';
        empObj.SupplierAppointments = aepObj;
        EON_MDS_Work_Management_WS.GasSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.GasSupplierDetailsResponse();
        respMDS.Success = true;
        respMDS.MeterPoint=empObj;
        respMDS.Errors = errObj;
        EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
        obj.RequestGasSupplierAppointmentsResult = respMDS;
        response.put('response_x', obj);
     }
     
     
     if(functionType =='MPANInddata'){
      
      String[] Msg = new String[]{'Message1','Message2','Message3'};
      EON_MDS_Work_Management_WS.ErrorList err = new EON_MDS_Work_Management_WS.ErrorList();
      err.Message = Msg;
      
      EON_MDS_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_MDS_Work_Management_WS.ElecMeterCodeOfPractice();
      eCode.Code = 'Code';
      eCode.Dispensation = 'Dispensation';
      eCode.IssueNumber = '007';

      EON_MDS_Work_Management_WS.ElecContact elecCon = new EON_MDS_Work_Management_WS.ElecContact();
      elecCon.Name = 'Name';
      elecCon.Telephone = '12345678';
      elecCon.PreferredContactMethod = 'PreferredContactMethod';
      elecCon.Email = 'test@email.com';
      elecCon.Fax = '4004';      
      
      EON_MDS_Work_Management_WS.ElecAppointedParty elecApp = new EON_MDS_Work_Management_WS.ElecAppointedParty();
      elecApp.EffectiveFromDate = '2015-04-23';
      elecApp.EffectiveToDate = '2016-08-23';
      elecApp.MarketParticipantId = '007';
      
      EON_MDS_Work_Management_WS.ElecAddress elecAdd = new EON_MDS_Work_Management_WS.ElecAddress();
      elecAdd.PostCode = '007';
      elecAdd.Line1 = 'Line1';
      elecAdd.Line2 = 'Line2';
      elecAdd.Line3 = 'Line3';
      elecAdd.Line4 = 'Line4';
      elecAdd.Line5 = 'Line5';
      elecAdd.Line6 = 'Line6';
      elecAdd.Line7 = 'Line7';
      elecAdd.Line8 = 'Line8';
      elecAdd.Line9 = 'Line9';  
      
      EON_MDS_Work_Management_WS.TimePatternRegime timePatt = new EON_MDS_Work_Management_WS.TimePatternRegime();
      timePatt.Code = '007';
      timePatt.RegisterMappingCoefficient= '4';
         
      //CH03.Start
      EON_MDS_Work_Management_WS.TimePatternRegime timePatt1 = new EON_MDS_Work_Management_WS.TimePatternRegime();
      timePatt1.Code = '007';
      timePatt1.RegisterMappingCoefficient= '4';
      //CH03.End
      
      EON_MDS_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_MDS_Work_Management_WS.TimePatternRegime[]{timePatt,timePatt1}; 
      EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
      arrTimePatt.TimePatternRegime = objTimePatt ;

      EON_MDS_Work_Management_WS.MeterMemoryLocationType mmT = new EON_MDS_Work_Management_WS.MeterMemoryLocationType();
      mmT.Type_x = 'Type_x';
      
      EON_MDS_Work_Management_WS.MeterMemoryLocationType[] objMMT = new EON_MDS_Work_Management_WS.MeterMemoryLocationType[]{mmT};
      EON_MDS_Work_Management_WS.ArrayOfMeterMemoryLocationType arrMMT = new EON_MDS_Work_Management_WS.ArrayOfMeterMemoryLocationType();
      arrMMT.MeterMemoryLocationType = objMMT;
      
      EON_MDS_Work_Management_WS.ElecRegister eReg = new EON_MDS_Work_Management_WS.ElecRegister();
      eReg.AssociatedMeterId = '007';
      eReg.AssociatedRegisterId = '007';
      eReg.ChannelNumber = '1';     
      eReg.Description = 'Description';
      eReg.Id = '1234';
      eReg.MeasurementQuantityId = '50';
      eReg.MeterMemoryLocation = '200';
      eReg.MeterMemoryLocationTypes = arrMMT;
      eReg.Multiplier ='3';
      eReg.NumberOfDigits = '2';
      eReg.PulseMultiplier = '3';
      eReg.TimestampMeterMemoryLocation = '5';
      eReg.Type_x = 'Type_x';
      eReg.TimePatternRegimes = arrTimePatt ;   
      
      EON_MDS_Work_Management_WS.ElecRegister eReg1 = new EON_MDS_Work_Management_WS.ElecRegister();
      eReg1.Id = '1234';
      eReg1.TimePatternRegimes = arrTimePatt ;    
      
      EON_MDS_Work_Management_WS.ElecRegister eReg2 = new EON_MDS_Work_Management_WS.ElecRegister();
      eReg2.Id = '1234';
      eReg2.TimePatternRegimes = arrTimePatt ;  
      
      EON_MDS_Work_Management_WS.ElecRegister eReg3 = new EON_MDS_Work_Management_WS.ElecRegister();
      eReg3.Id = '1234';
      eReg3.TimePatternRegimes = arrTimePatt ;  
      
      EON_MDS_Work_Management_WS.ElecRegister eReg4 = new EON_MDS_Work_Management_WS.ElecRegister();
      eReg4.Id = '1234';
      eReg4.TimePatternRegimes = arrTimePatt ;  
      
      EON_MDS_Work_Management_WS.ElecRegister eReg5 = new EON_MDS_Work_Management_WS.ElecRegister();
      eReg5.Id = '1234';
      eReg5.TimePatternRegimes = arrTimePatt ; 
      
      EON_MDS_Work_Management_WS.ElecRegister[] objEReg = new EON_MDS_Work_Management_WS.ElecRegister[]{eReg,eReg1,eReg2,eReg3,eReg4,eReg5};
      EON_MDS_Work_Management_WS.ArrayOfElecRegister arrEReg = new EON_MDS_Work_Management_WS.ArrayOfElecRegister();
      arrEReg.ElecRegister = objEReg;
      
      
      EON_MDS_Work_Management_WS.ElecMeter eMeter = new EON_MDS_Work_Management_WS.ElecMeter();
      eMeter.CTRatio = '20';
      eMeter.CertificationDate = '2015-04-23';
      eMeter.CertificationExpiryDate = '2017-08-23';
      eMeter.CodeOfPractice = eCode;
      eMeter.CurrentRating = '2';
      eMeter.Location = 'Loc';
      eMeter.MainOrCheck = 'MainOrCheck';
      eMeter.ManufacturerAndModel = 'ManufacturerAndModel';
      eMeter.RetrievalMethod = 'RetrievalMethod';
      eMeter.RetrievalMethodEffectiveDate = '2015-04-23';
      eMeter.SerialNumber = '007';
      eMeter.TimingDeviceSerialNumber = '789';
      eMeter.Type_x = 'S1';
      eMeter.VTRatio = '7';
      eMeter.AssetProviderId= '2';
      eMeter.InstallationDate = '2015-04-23';
      eMeter.RemovalDate = '2016-04-23';      
      eMeter.Registers = arrEReg ;
      
      EON_MDS_Work_Management_WS.ElecMeter[] objEMeter = new EON_MDS_Work_Management_WS.ElecMeter[]{eMeter};
      EON_MDS_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_MDS_Work_Management_WS.ArrayOfElecMeter();
      arrayEM.ElecMeter = objEMeter;
      
      EON_MDS_Work_Management_WS.DataEffectiveFrom dataEff  = new EON_MDS_Work_Management_WS.DataEffectiveFrom();
      dataEff.Id = '1234';
      dataEff.EffectiveFromDate = '2015-04-23';  

      EON_MDS_Work_Management_WS.OutstationPasswords oStatPwd = new EON_MDS_Work_Management_WS.OutstationPasswords();
      oStatPwd.Level1 = 'Level1';
      oStatPwd.Level2 = 'Level2';
      oStatPwd.Level3 = 'Level3';

      EON_MDS_Work_Management_WS.OutstationUsernames oStatUser = new EON_MDS_Work_Management_WS.OutstationUsernames ();
      oStatUser.Level1 = 'Level1';
      oStatUser.Level2 = 'Level2';
      oStatUser.Level3 = 'Level3';
      
      EON_MDS_Work_Management_WS.CommsBase cBase = new EON_MDS_Work_Management_WS.CommsBase();
      cBase.Address = 'Address';
      cBase.BaudRate = '2';
      cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
      cBase.Method = 'Method';
      cBase.Provider = 'Provider';   
      
      EON_MDS_Work_Management_WS.CommsBase[] objCBase = new EON_MDS_Work_Management_WS.CommsBase[]{cBase};
      EON_MDS_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_MDS_Work_Management_WS.ArrayOfCommsBase();
      arrCBase.CommsBase = objCBase ;
      
      EON_MDS_Work_Management_WS.OutstationCodeOfPractice outCode= new EON_MDS_Work_Management_WS.OutstationCodeOfPractice();
      outCode.Code = '12345';
      outCode.Dispensation ='Dispensation';
      
      EON_MDS_Work_Management_WS.Outstation outStat = new EON_MDS_Work_Management_WS.Outstation();
      outStat.CodeOfPractice = outCode;
      outStat.EncryptionKey = 'EncryptionKey';
      outStat.Id = '007';
      outStat.Multiplier = '3';
      outStat.NumberOfChannels = '2';
      outStat.NumberOfDigits = '5';
      outStat.Passwords = oStatPwd;
      outStat.Pin = '45698';
      outStat.Type_x = 'Type_x';
      outStat.Usernames = oStatUser;
      outStat.Comms = arrCBase;
      
      EON_MDS_Work_Management_WS.Outstation[] objOutStat = new EON_MDS_Work_Management_WS.Outstation[]{outStat};
      EON_MDS_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_MDS_Work_Management_WS.ArrayOfOutstation();
      arrOutStat.Outstation = objOutStat;
      
      EON_MDS_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_MDS_Work_Management_WS.PriorityServiceContactInfo();
      priorService.AlternateName = 'AlternateName';      
      priorService.AlternateTelephone1 = '988445632';
      priorService.AlternateTelephone2 = '123456987';
      priorService.Name ='Name';
      priorService.Telephone3 = '123456778';
      priorService.Address = elecAdd;
      priorService.Telephone1= '988445632';
      priorService.Telephone2= '988445632';
      priorService.Telephone3= '988445632';      
      
      EON_MDS_Work_Management_WS.SpecialNeed spNeed = new EON_MDS_Work_Management_WS.SpecialNeed();
      spNeed.category = '1'; //CH02.New
      spNeed.AdditionalInformation = 'Test';   //CH02.New
      EON_MDS_Work_Management_WS.SpecialNeed[] objSpNeed = new EON_MDS_Work_Management_WS.SpecialNeed[]{spNeed};
      EON_MDS_Work_Management_WS.ArrayOfSpecialNeed arrSpNeed = new EON_MDS_Work_Management_WS.ArrayOfSpecialNeed();
      arrSpNeed.SpecialNeed = objSpNeed ;      

      EON_MDS_Work_Management_WS.ElecSupply elecSup = new EON_MDS_Work_Management_WS.ElecSupply();
      elecSup.EnergisationStatus = 'EnergisationStatus';
      elecSup.Phases = '3';
      elecSup.Voltage = '1400';
      elecSup.Capacity = '200'; 
      
      EON_MDS_Work_Management_WS.ElecCustomer eCust = new EON_MDS_Work_Management_WS.ElecCustomer();
      eCust.AdditionalInformation = 'test';
      eCust.ContractReference = 'test';
      eCust.StdSettlementConfig = dataEff;
      eCust.Supply = elecSup;
      eCust.MeterPointAddress = elecAdd;
      eCust.CustomerName = 'CustomerName';
      eCust.CustomerContact = elecCon;
      eCust.SpecialAccess ='SpecialAccess';
      eCust.CustomerPassword = 'CustomerPassword';
      eCust.MeterPointAddress = elecAdd ;
      eCust.PriorityServiceContactInfo = priorService;
      eCust.CodeOfPractice= eCode;
      eCust.CustomerPasswordEffectivefromDate = '2015-04-23';   
      eCust.DataCollector = elecApp;
      eCust.GridSupplyPointsGroupId = '007';
      eCust.MPAN = '007';
      eCust.MaximumPowerRequirement = '200';
      eCust.MailingAddress = elecAdd;
      eCust.MeasurementClassId = '007';
      eCust.MeterOperator = elecApp;
      eCust.Meters = arrayEM;
      eCust.NonSettlementFunction = dataEff;
      eCust.Outstations = arrOutStat;
      eCust.PriorityServiceContactInfo = priorService;
      eCust.RegistrationEffectiveFromDate = '2015-04-23';
      eCust.RemoteDisableEnableCapability='test Remote';
      eCust.ServiceLevelReference='test ServiceLevel';
      eCust.ServiceLocation ='test ServiceLocation';
      eCust.ServiceReference='test ServiceReference';
      eCust.SpecialAccess='test SpecialAccess';
      eCust.SpecialNeeds = arrSpNeed;
      
      EON_MDS_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_MDS_Work_Management_WS.ElecMeterPointDataResponse();
      resp.Errors = err;
      resp.Success = true;
      resp.Customer = eCust;

      EON_MDS_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_MDS_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();    
      obj.RequestElectricityMeterPointDataResult = resp;
      response.put('response_x', obj);
     }
     
    if(functionType =='MPANInddata_fail1'){   
        EON_MDS_Work_Management_WS.ElecMeterPointDataResponse respMDS = new EON_MDS_Work_Management_WS.ElecMeterPointDataResponse();
        respMDS.Success = true;
        response.put('response_x', respMDS);
     }
     
   if(functionType =='MPANInddata_fail2'){ 
    String[] Msg = new String[]{'Message1','Message2','Message3'};
      EON_MDS_Work_Management_WS.ErrorList err = new EON_MDS_Work_Management_WS.ErrorList();
      err.Message = Msg;  
      EON_MDS_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_MDS_Work_Management_WS.ElecMeterPointDataResponse();
      resp.Errors = err;
      resp.Success = false;

      EON_MDS_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_MDS_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();    
      obj.RequestElectricityMeterPointDataResult = resp;
      response.put('response_x', obj);
     }
     
     
     if(functionType =='MPRNInddata'){
      String[] Msg = new String[]{'Message1','Message2','Message3'};
      EON_MDS_Work_Management_WS.ErrorList err = new EON_MDS_Work_Management_WS.ErrorList();
      err.Message = Msg;
      EON_MDS_Work_Management_WS.GasAddress gasAdd = new EON_MDS_Work_Management_WS.GasAddress ();
      gasAdd.AddressText='AddressText';
      gasAdd.Building='AddressText';
      gasAdd.DependentLocality='AddressText';
      gasAdd.County='County';
      gasAdd.DependentThoroughfare='DependentThoroughfare';
      gasAdd.DoubleDependentLocality='DoubleDependentLocality';
      gasAdd.PostCode='PostCode';
      gasAdd.PostTown='PostTown';
      gasAdd.PostTown='PostTown';
      gasAdd.SubBuilding='SubBuilding';
      gasAdd.UPRN='UPRN';
      gasAdd.Thoroughfare='Thoroughfare';
      
      EON_MDS_Work_Management_WS.GasRegister gRegi = new EON_MDS_Work_Management_WS.GasRegister();
      gRegi.MultiplicationFactor = '3';
      gRegi.NumberOfDigits = '2';
      gRegi.Type_x = 'UNCOR';
     
      EON_MDS_Work_Management_WS.GasRegister[] objGasReg = new EON_MDS_Work_Management_WS.GasRegister[]{gRegi};          
      EON_MDS_Work_Management_WS.ArrayOfGasRegister arrGReg = new EON_MDS_Work_Management_WS.ArrayOfGasRegister(); 
      arrGReg.GasRegister = objGasReg;
            
      EON_MDS_Work_Management_WS.GasMeter gMet = new EON_MDS_Work_Management_WS.GasMeter();
      gMet.CollarStatus = 'CollarStatus';
      gMet.Location = 'AT';
      gMet.LocationNotes = 'LocationNotes';      
      gMet.Manufacturer = 'Manufacturer';
      gMet.MeasuringCapacity = 'MeasuringCapacity';
      gMet.Mechanism = 'CR';
      gMet.Model = 'Model';
      gMet.PaymentMethod='PaymentMethod';
      gMet.PulseValue = '789';
      gMet.SerialNumber='1245';
      gMet.Status='Status';
      gMet.Type_x='P';
      gMet.Usage='Usage';
      gMet.YearOfManufacture = '2015';
      gMet.Registers = arrGReg;     
      
      EON_MDS_Work_Management_WS.GasMeter[] objGasMet = new EON_MDS_Work_Management_WS.GasMeter[]{gMet};          
      EON_MDS_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_MDS_Work_Management_WS.ArrayOfGasMeter(); 
      arrGMeter.GasMeter = objGasMet;      

       EON_MDS_Work_Management_WS.GasAppointedParty gasAObj = new EON_MDS_Work_Management_WS.GasAppointedParty(); 
       gasAObj.EffectiveFromDate ='2015-04-23';
       gasAObj.EffectiveToDate='2016-08-23';
       gasAObj.AbbreviatedName='MORR';
       
       EON_MDS_Work_Management_WS.Converter conver = new EON_MDS_Work_Management_WS.Converter();
       conver.SerialNumber = '007';
       conver.Model = 'Model';
       conver.AssetClass = 'AssetClass';
       conver.Manufacturer='Manufacturer';
       conver.Location = 'Location';

       EON_MDS_Work_Management_WS.Converter[] objConver = new EON_MDS_Work_Management_WS.Converter[]{conver};
       EON_MDS_Work_Management_WS.ArrayOfConverter arrConver = new EON_MDS_Work_Management_WS.ArrayOfConverter();
       arrConver.Converter = objConver;

       EON_MDS_Work_Management_WS.ContactMechanism contMec = new EON_MDS_Work_Management_WS.ContactMechanism();
       contMec.Code = 'VISIT'; 
       contMec.Value = '007';       
       
       EON_MDS_Work_Management_WS.ContactMechanism[] objContMec = new EON_MDS_Work_Management_WS.ContactMechanism[]{contMec};
       EON_MDS_Work_Management_WS.ArrayOfContactMechanism arrContMec = new EON_MDS_Work_Management_WS.ArrayOfContactMechanism();
       arrContMec.ContactMechanism = objContMec;
       
       EON_MDS_Work_Management_WS.Contact cont = new EON_MDS_Work_Management_WS.Contact();
       cont.TypeCode = 'UNCON';
       cont.Initials = 'Initials';
       cont.Surname = 'Surname';
       cont.Title = 'Title';
       cont.ContactMechanism = arrContMec;
       
       EON_MDS_Work_Management_WS.Contact[] objCont = new EON_MDS_Work_Management_WS.Contact[]{cont};
       EON_MDS_Work_Management_WS.ArrayOfContact arrCont = new EON_MDS_Work_Management_WS.ArrayOfContact();
       arrCont.Contact = objCont;
                 
       EON_MDS_Work_Management_WS.gasCustomer gCust = new EON_MDS_Work_Management_WS.gasCustomer();
       gCust.AccessInstructions = 'AccessInstructions';
       gCust.AccessPassword = 'AccessPassword';
       gCust.ConversionFactor= 'ConversionFactor';
       gCust.LastInspectionDate= 'LastInspectionDate';
       gCust.Location= 'Location';
       gCust.LocationNotes= 'LocationNotes';
       gCust.MPRN= 'MPRN';
       gCust.MeterLink= 'MeterLink';
       gCust.MeterPointStatus= 'MeterPointStatus';
       gCust.MeteringPressure= '0.075';
       gCust.Address=gasAdd;
       gCust.Meters = arrGMeter;
       gCust.Supplier = gasAObj;
       gCust.Converters = arrConver;
       gCust.Contacts = arrCont;
       
       EON_MDS_Work_Management_WS.gasMeterPointDataResponse resp = new EON_MDS_Work_Management_WS.gasMeterPointDataResponse();
       resp.Errors = err;
       resp.Success = true;
       resp.Customer = gCust;
       
      EON_MDS_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_MDS_Work_Management_WS.RequestGasMeterPointDataResponse_element();    
      obj.RequestgasMeterPointDataResult = resp;
      response.put('response_x', obj);
     }
     
    if(functionType =='MPRNInddata_fail1'){   
        EON_MDS_Work_Management_WS.GasMeterPointDataResponse  respMDS = new EON_MDS_Work_Management_WS.GasMeterPointDataResponse();
        respMDS.Success = false;
        response.put('response_x', respMDS);
     }
     
    if(functionType =='MPRNInddata_fail2'){ 
       String[] Msg = new String[]{'Message1','Message2','Message3'};
       EON_MDS_Work_Management_WS.ErrorList err = new EON_MDS_Work_Management_WS.ErrorList();
       err.Message = Msg;  
       EON_MDS_Work_Management_WS.gasMeterPointDataResponse resp = new EON_MDS_Work_Management_WS.gasMeterPointDataResponse();
       resp.Errors = err;
       resp.Success = false;
       EON_MDS_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_MDS_Work_Management_WS.RequestGasMeterPointDataResponse_element();    
       obj.RequestgasMeterPointDataResult = resp;
       response.put('response_x', obj);
     }
      if(functionType =='validateMOPWithEffDates'){   
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
        errObj.Message = Msg;
        EON_MDS_Work_Management_WS.ElecAppointedParty eapObj = new EON_MDS_Work_Management_WS.ElecAppointedParty(); 
        Date dt = Date.today();
        eapObj.EffectiveFromDate = dt.year()+''+((dt.month() < 9 )? '0'+dt.month() : ''+dt.month())+ ((dt.addDays(-1).day() < 9 )? '0'+dt.addDays(-1).day() : ''+dt.addDays(-1).day());
        eapObj.EffectiveToDate=dt.addDays(10).year()+''+((dt.addDays(10).month() < 9 )? '0'+dt.addDays(10).month() : ''+dt.addDays(10).month())+ ((dt.addDays(10).addDays(-1).day() < 9 )? '0'+dt.addDays(10).addDays(-1).day() : ''+dt.addDays(10).addDays(-1).day());
        eapObj.MarketParticipantId='EMEB';
        EON_MDS_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_MDS_Work_Management_WS.ElecAppointedParty[]{eapObj};
        EON_MDS_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_MDS_Work_Management_WS.ArrayOfElecAppointedParty();
        aepObj.ElecAppointedParty = aEobj;
        EON_MDS_Work_Management_WS.ElecMeterPoint empObj = new EON_MDS_Work_Management_WS.ElecMeterPoint();
        empObj.MPAN = 'mpan123';
        empObj.SupplierAppointments = aepObj;
        EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse();
        respMDS.Success = true;
        respMDS.MeterPoint=empObj;
        respMDS.Errors = errObj;
        EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
        obj.RequestElectricitySupplierAppointmentsResult = respMDS;
        response.put('response_x', obj);
     }
     if(functionType =='validateMAMWithEffDates'){   
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
        errObj.Message = Msg;
        EON_MDS_Work_Management_WS.GasAppointedParty gasAObj = new EON_MDS_Work_Management_WS.GasAppointedParty(); 
        Date dt = Date.today();
        gasAObj.EffectiveFromDate = dt.year()+''+((dt.month() < 9 )? '0'+dt.month() : ''+dt.month())+ ((dt.addDays(-1).day() < 9 )? '0'+dt.addDays(-1).day() : ''+dt.addDays(-1).day());
        gasAObj.EffectiveToDate=dt.addDays(10).year()+''+((dt.addDays(10).month() < 9 )? '0'+dt.addDays(10).month() : ''+dt.addDays(10).month())+ ((dt.addDays(10).addDays(-1).day() < 9 )? '0'+dt.addDays(10).addDays(-1).day() : ''+dt.addDays(10).addDays(-1).day());
        gasAObj.AbbreviatedName='SGL';
        EON_MDS_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_MDS_Work_Management_WS.GasAppointedParty[]{gasAObj};
        EON_MDS_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_MDS_Work_Management_WS.ArrayOfGasAppointedParty();
        aepObj.GasAppointedParty = gasAppobj;
        EON_MDS_Work_Management_WS.GasMeterPoint empObj = new EON_MDS_Work_Management_WS.GasMeterPoint();
        empObj.MPRN = 'mprn123';
        empObj.SupplierAppointments = aepObj;
        EON_MDS_Work_Management_WS.GasSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.GasSupplierDetailsResponse();
        respMDS.Success = true;
        respMDS.MeterPoint=empObj;
        respMDS.Errors = errObj;
        EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_MDS_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
        obj.RequestGasSupplierAppointmentsResult = respMDS;
        response.put('response_x', obj);
     }
   }
}