/**
    Description : This class Used to send Mock response for http calls to EON JUMBO. 
    Test Class  : 
**/

/*
    Created By   : Purvi
    Created Date : 22/04/2016
    SR           : SR_EON_Jumbo_020
    Change history: 
    CH01 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Mapping for JUMBO Vulnerability Code with EON Vulnerability Code
    CH02 # SR_EON_JUMBO_098 # 16/01/2017 # Mahadev Joshilkar #  Improved logic to create - EON Appointment Contacts
*/
@isTest
global class EON_JUMBO_WebServiceMockImpl implements WebServiceMock {
   public static string functiontype='';
    public static string PreferredContactMethod = 'L';  //CH02.New
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
      try{
      
     
      String[] Msg = new String[]{'Message1','Message2','Message3'};              
      
      EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
      err.Message = Msg;
      
      EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
      eCode.Code = 'Code';
      eCode.Dispensation = 'Dispensation';
      eCode.IssueNumber = '007';

      EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
      elecCon.Name = 'Name';
      elecCon.Telephone = '12345678';
      elecCon.PreferredContactMethod = PreferredContactMethod; //'L'; //CH02.Update
      elecCon.Email = 'test@email.com';
      elecCon.Fax = '4004';      
      
      EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
      elecApp.EffectiveFromDate = '2015-04-23';
      elecApp.EffectiveToDate = '2016-08-23';
      elecApp.MarketParticipantId = '007';
      EON_JUMBO_Work_Management_WS.ElecAddress elecAdd = new EON_JUMBO_Work_Management_WS.ElecAddress();
      if(functiontype==''){
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
      }
     
      EON_JUMBO_Work_Management_WS.GasAddress gasAdd = new EON_JUMBO_Work_Management_WS.GasAddress ();
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
      
      EON_JUMBO_Work_Management_WS.TimePatternRegime timePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime();
      timePatt.Code = '007';
      timePatt.RegisterMappingCoefficient= '4';
      
      EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[]{timePatt}; 
      EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
      arrTimePatt.TimePatternRegime = objTimePatt ;
      
      EON_JUMBO_Work_Management_WS.MeterMemoryLocationType mmT = new EON_JUMBO_Work_Management_WS.MeterMemoryLocationType();
      mmT.Type_x = 'Type_x';
      
      
      EON_JUMBO_Work_Management_WS.MeterMemoryLocationType[] objMMT = new EON_JUMBO_Work_Management_WS.MeterMemoryLocationType[]{mmT};
      EON_JUMBO_Work_Management_WS.ArrayOfMeterMemoryLocationType arrMMT = new EON_JUMBO_Work_Management_WS.ArrayOfMeterMemoryLocationType();
      arrMMT.MeterMemoryLocationType = objMMT;

      EON_JUMBO_Work_Management_WS.ElecRegister eReg = new EON_JUMBO_Work_Management_WS.ElecRegister();
      eReg.AssociatedMeterId = '007';
      eReg.AssociatedRegisterId = '007';
      eReg.ChannelNumber = '1';     
      eReg.Description = 'Description';
      eReg.Id = '12';
      eReg.MeasurementQuantityId = '50';
      eReg.MeterMemoryLocation = '200';
      eReg.MeterMemoryLocationTypes = arrMMT;
      eReg.Multiplier ='3';
      eReg.NumberOfDigits = '2';
      eReg.PulseMultiplier = '3';
      eReg.TimestampMeterMemoryLocation = '5';
      eReg.Type_x = 'Type_x';
      eReg.TimePatternRegimes = arrTimePatt ;     
      
      EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[]{eReg};
      EON_JUMBO_Work_Management_WS.ArrayOfElecRegister arrEReg = new EON_JUMBO_Work_Management_WS.ArrayOfElecRegister();
      arrEReg.ElecRegister = objEReg;
      
      
      EON_JUMBO_Work_Management_WS.ElecMeter eMeter = new EON_JUMBO_Work_Management_WS.ElecMeter();
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
      eMeter.Type_x = 'Type_x';
    
      eMeter.VTRatio = '7';
      eMeter.AssetProviderId= '2';
      eMeter.InstallationDate = '2015-04-23';
      eMeter.RemovalDate = '2016-04-23';
      eMeter.Registers = arrEReg ;
      
      EON_JUMBO_Work_Management_WS.ElecMeter[] objEMeter = new EON_JUMBO_Work_Management_WS.ElecMeter[]{eMeter};
      EON_JUMBO_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
      arrayEM.ElecMeter = objEMeter;
      
      EON_JUMBO_Work_Management_WS.DataEffectiveFrom dataEff  = new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
      dataEff.Id = '1234';
      dataEff.EffectiveFromDate = '2015-04-23';  

      EON_JUMBO_Work_Management_WS.OutstationPasswords oStatPwd = new EON_JUMBO_Work_Management_WS.OutstationPasswords();
      oStatPwd.Level1 = 'Level1';
      oStatPwd.Level2 = 'Level2';
      oStatPwd.Level3 = 'Level3';

      EON_JUMBO_Work_Management_WS.OutstationUsernames oStatUser = new EON_JUMBO_Work_Management_WS.OutstationUsernames ();
      oStatUser.Level1 = 'Level1';
      oStatUser.Level2 = 'Level2';
      oStatUser.Level3 = 'Level3';
      
      EON_JUMBO_Work_Management_WS.CommsBase cBase = new EON_JUMBO_Work_Management_WS.CommsBase();
      cBase.Address = 'Address';
      cBase.BaudRate = '2';
      cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
      cBase.Method = 'Method';
      cBase.Provider = 'Provider';   
      
      EON_JUMBO_Work_Management_WS.CommsBase[] objCBase = new EON_JUMBO_Work_Management_WS.CommsBase[]{cBase};
      EON_JUMBO_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
      arrCBase.CommsBase = objCBase ;
      
      EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice outCode= new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
      outCode.Code = '12345';
      outCode.Dispensation ='Dispensation';
      
      EON_JUMBO_Work_Management_WS.Outstation outStat = new EON_JUMBO_Work_Management_WS.Outstation();
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
      
      EON_JUMBO_Work_Management_WS.Outstation[] objOutStat = new EON_JUMBO_Work_Management_WS.Outstation[]{outStat};
      EON_JUMBO_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
      arrOutStat.Outstation = objOutStat;
      
      EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
      priorService.AlternateName = 'AlternateName';      
      priorService.AlternateTelephone1 = '988445632';
      priorService.AlternateTelephone2 = '123456987';
      priorService.Name ='Name';
      priorService.Telephone3 = '123456778';
      priorService.Address = elecAdd;
      priorService.Telephone1= '988445632';
      priorService.Telephone2= '988445632';
      priorService.Telephone3= '988445632';      
      
      EON_JUMBO_Work_Management_WS.SpecialNeed spNeed = new EON_JUMBO_Work_Management_WS.SpecialNeed();
      spNeed.category = '1'; //CH01.New
      spNeed.AdditionalInformation = 'test'; //CH01.New
      EON_JUMBO_Work_Management_WS.SpecialNeed[] objSpNeed = new EON_JUMBO_Work_Management_WS.SpecialNeed[]{spNeed};
      EON_JUMBO_Work_Management_WS.ArrayOfSpecialNeed arrSpNeed = new EON_JUMBO_Work_Management_WS.ArrayOfSpecialNeed();
      arrSpNeed.SpecialNeed = objSpNeed ;      

      EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
      elecSup.EnergisationStatus = 'EnergisationStatus';
      elecSup.Phases = '3';
      elecSup.Voltage = '100';
      elecSup.Capacity = '200'; 
      
      EON_JUMBO_Work_Management_WS.ElecCustomer eCust = new EON_JUMBO_Work_Management_WS.ElecCustomer();
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
      
      EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
     
      resp.Errors = err;
      if(functiontype!='Error')
      resp.Success = true;
      if(functiontype=='Error')
      resp.Success = false;
      resp.Customer = eCust;
        
      EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();    
      obj.RequestElectricityMeterPointDataResult = resp;
      response.put('response_x', obj);
      
      EON_JUMBO_Work_Management_WS.ArrayOfCareDetail arrCdetail = new EON_JUMBO_Work_Management_WS.ArrayOfCareDetail();
      EON_JUMBO_Work_Management_WS.ArrayOfCloseElecOutstation arrClose = new EON_JUMBO_Work_Management_WS.ArrayOfCloseElecOutstation();
      EON_JUMBO_Work_Management_WS.ArrayOfComms arrCom = new EON_JUMBO_Work_Management_WS.ArrayOfComms();
      EON_JUMBO_Work_Management_WS.ArrayOfContact arrCon = new EON_JUMBO_Work_Management_WS.ArrayOfContact();
      EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism arrCMech = new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
      EON_JUMBO_Work_Management_WS.ArrayOfConverter arrConv = new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
      EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty arrParty = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
      EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty arrGas = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
      EON_JUMBO_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter();
      EON_JUMBO_Work_Management_WS.ArrayOfGasRegister arrGReg = new EON_JUMBO_Work_Management_WS.ArrayOfGasRegister();
      EON_JUMBO_Work_Management_WS.CancelElecWork cElec = new EON_JUMBO_Work_Management_WS.CancelElecWork();
      EON_JUMBO_Work_Management_WS.CancelElecWorkRequest cElecWork = new EON_JUMBO_Work_Management_WS.CancelElecWorkRequest();
      EON_JUMBO_Work_Management_WS.CancelGasWork cGasWork = new EON_JUMBO_Work_Management_WS.CancelGasWork();
      EON_JUMBO_Work_Management_WS.CancelGasWorkRequest cGasReq = new EON_JUMBO_Work_Management_WS.CancelGasWorkRequest();
      EON_JUMBO_Work_Management_WS.CancelJumboElectricityJob_element cElem = new EON_JUMBO_Work_Management_WS.CancelJumboElectricityJob_element();
      EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element cElecElem = new EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element();
      EON_JUMBO_Work_Management_WS.CancelJumboGasJob_element cGasElem = new EON_JUMBO_Work_Management_WS.CancelJumboGasJob_element();
      EON_JUMBO_Work_Management_WS.CancelJumboGasJobResponse_element cGasresp = new EON_JUMBO_Work_Management_WS.CancelJumboGasJobResponse_element();
      EON_JUMBO_Work_Management_WS.CareDetail cDet = new EON_JUMBO_Work_Management_WS.CareDetail();
      EON_JUMBO_Work_Management_WS.CloseElecOutstation cOut = new EON_JUMBO_Work_Management_WS.CloseElecOutstation();
      EON_JUMBO_Work_Management_WS.CloseElecWork cElecWor = new EON_JUMBO_Work_Management_WS.CloseElecWork();
      EON_JUMBO_Work_Management_WS.CloseElecWorkRequest cReq = new EON_JUMBO_Work_Management_WS.CloseElecWorkRequest();
      EON_JUMBO_Work_Management_WS.CloseGasWork cGasWor = new EON_JUMBO_Work_Management_WS.CloseGasWork();
      EON_JUMBO_Work_Management_WS.CloseGasWorkRequest cGReq = new EON_JUMBO_Work_Management_WS.CloseGasWorkRequest();
      EON_JUMBO_Work_Management_WS.CloseJumboElectricityJob_element cERe = new EON_JUMBO_Work_Management_WS.CloseJumboElectricityJob_element();
      EON_JUMBO_Work_Management_WS.CloseJumboElectricityJobResponse_element cEleResp = new EON_JUMBO_Work_Management_WS.CloseJumboElectricityJobResponse_element();
      EON_JUMBO_Work_Management_WS.CloseJumboGasJob_element cGEleme = new EON_JUMBO_Work_Management_WS.CloseJumboGasJob_element();
      EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element cJGas = new EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element();
      EON_JUMBO_Work_Management_WS.Comms co = new EON_JUMBO_Work_Management_WS.Comms();
      EON_JUMBO_Work_Management_WS.Contact cont = new EON_JUMBO_Work_Management_WS.Contact();
      EON_JUMBO_Work_Management_WS.ContactMechanism conMech = new EON_JUMBO_Work_Management_WS.ContactMechanism();
      EON_JUMBO_Work_Management_WS.Converter conv = new EON_JUMBO_Work_Management_WS.Converter();
      EON_JUMBO_Work_Management_WS.Coordinates coo = new EON_JUMBO_Work_Management_WS.Coordinates();
      EON_JUMBO_Work_Management_WS.CreateElecWork creaEle = new EON_JUMBO_Work_Management_WS.CreateElecWork();
      EON_JUMBO_Work_Management_WS.CreateElecWorkRequest cElewo = new EON_JUMBO_Work_Management_WS.CreateElecWorkRequest();
      EON_JUMBO_Work_Management_WS.CreateGasWork creaGas = new EON_JUMBO_Work_Management_WS.CreateGasWork();
      EON_JUMBO_Work_Management_WS.CreateGasWorkRequest cGasWReq = new EON_JUMBO_Work_Management_WS.CreateGasWorkRequest();
      EON_JUMBO_Work_Management_WS.CreateJumboElectricityJob_element jumElec = new EON_JUMBO_Work_Management_WS.CreateJumboElectricityJob_element();
      EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element jumResElec = new EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element();
      EON_JUMBO_Work_Management_WS.CreateJumboGasJob_element jumGas = new EON_JUMBO_Work_Management_WS.CreateJumboGasJob_element();
      EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element jumGasresp = new EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element();
      EON_JUMBO_Work_Management_WS.CreateWorkBase cWorBas = new EON_JUMBO_Work_Management_WS.CreateWorkBase();
      EON_JUMBO_Work_Management_WS.ElecMeterBase eMet = new EON_JUMBO_Work_Management_WS.ElecMeterBase();
      EON_JUMBO_Work_Management_WS.ElecMeterPoint eMetPt = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
      EON_JUMBO_Work_Management_WS.ElecRegisterBase eRegBas = new EON_JUMBO_Work_Management_WS.ElecRegisterBase();
      EON_JUMBO_Work_Management_WS.ElecRegisterReading eRegread = new EON_JUMBO_Work_Management_WS.ElecRegisterReading();
      EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest eSupp = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest();
      EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse eSuppResp = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
      EON_JUMBO_Work_Management_WS.GasAddress gAdd = new EON_JUMBO_Work_Management_WS.GasAddress();
      EON_JUMBO_Work_Management_WS.GasAppointedParty gParty = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
      EON_JUMBO_Work_Management_WS.GasCustomer gCust = new EON_JUMBO_Work_Management_WS.GasCustomer();
      EON_JUMBO_Work_Management_WS.GasMeter gMet = new EON_JUMBO_Work_Management_WS.GasMeter();
      EON_JUMBO_Work_Management_WS.GasMeterPoint gMetPt = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
      EON_JUMBO_Work_Management_WS.GasMeterPointDataRequest gMetData = new EON_JUMBO_Work_Management_WS.GasMeterPointDataRequest();
      EON_JUMBO_Work_Management_WS.GasMeterPointDataResponse gMetresp = new EON_JUMBO_Work_Management_WS.GasMeterPointDataResponse();
      EON_JUMBO_Work_Management_WS.GasRegister gRegi = new EON_JUMBO_Work_Management_WS.GasRegister();
      EON_JUMBO_Work_Management_WS.GasSupplierDetailsRequest gSupp = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsRequest();
      EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse gSuppresp = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
      EON_JUMBO_Work_Management_WS.GasTransaction gTra = new EON_JUMBO_Work_Management_WS.GasTransaction();
      EON_JUMBO_Work_Management_WS.JumboTechnicalResponse jumTech = new EON_JUMBO_Work_Management_WS.JumboTechnicalResponse();
      EON_JUMBO_Work_Management_WS.OutstationBase outBas = new EON_JUMBO_Work_Management_WS.OutstationBase();
      EON_JUMBO_Work_Management_WS.RequestBase reqBas = new EON_JUMBO_Work_Management_WS.RequestBase();
      EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element reqApp = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element();
      EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element elecElem = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
      EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element reqGasData = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element();
      EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element gasRespDat = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();
      EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element gasSupp = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element();
      EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element gasElemSupp = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
      EON_JUMBO_Work_Management_WS.ResponseBase repBas = new EON_JUMBO_Work_Management_WS.ResponseBase();
      EON_JUMBO_Work_Management_WS.SiteVisit sVisi = new EON_JUMBO_Work_Management_WS.SiteVisit();
      EON_JUMBO_Work_Management_WS.WithEffectiveDatesBase withEff = new EON_JUMBO_Work_Management_WS.WithEffectiveDatesBase();
      
      }
     catch(Exception ex){
             System.debug('*** Exception Occured : ' + ex.getMessage());
             system.debug('$$$$'+ex.getLineNumber());
         }                
      }
}