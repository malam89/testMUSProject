/**
Description : This schedular class used to run batch apex class(WM_GetPhotosNightlyBatchJob) to download  photos 
This scheduler will run in every 10 min  

VF Page     : None       
Test Class  : EON_JUMBO_Schedulable_ValidatingMPAN_Test
Schedule Job Name : EON_JUMBO_Schedulable_ValidatingMPAN                                               
**/
/*
Created By  : Mehboob Alam
Created On  : 20/04/2016
Service Req : SR_EON_Jumbo_025
Change History
CH01 # SR_EON_AB_130 # 22/09/2016 # Sivasankar K # Amending the test class to increase the code coverage.
*/
@isTest
global class EON_JUMBO_Schedulable_ValidatingMock implements WebServiceMock {
    
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType){   
        String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
        errObj.Message = Msg;
        EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty(); 
        //CH01.Start
        if (EON_JUMBO_Schedulable_Validating_Test.changeResponse !=''){
            Date dt = Date.today();
            eapObj.EffectiveFromDate = dt.year()+''+((dt.month() < 9 )? '0'+dt.month() : ''+dt.month())+ ((dt.addDays(-1).day() < 9 )? '0'+dt.addDays(-1).day() : ''+dt.addDays(-1).day());
            eapObj.EffectiveToDate=dt.addDays(10).year()+''+((dt.addDays(10).month() < 9 )? '0'+dt.addDays(10).month() : ''+dt.addDays(10).month())+ ((dt.addDays(10).addDays(-1).day() < 9 )? '0'+dt.addDays(10).addDays(-1).day() : ''+dt.addDays(10).addDays(-1).day());
        } else {
            eapObj.EffectiveFromDate ='20150423';
            eapObj.EffectiveToDate='20150823';
        }
        //CH01.End
        eapObj.MarketParticipantId='EMEB';
        EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj;
        //CH01.Start
        if (EON_JUMBO_Schedulable_Validating_Test.changeResponse == 'No Supplier' )
            aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[]{};
        else 
            aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[]{eapObj};
                    
        //CH01.END    
                    
    EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
        aepObj.ElecAppointedParty = aEobj;
        EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
        empObj.MPAN = 'mpan123';
        empObj.SupplierAppointments = aepObj;
        EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
        respJumbo.Success = true;
        respJumbo.MeterPoint=empObj;
        respJumbo.Errors = errObj;
        EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
        obj.RequestElectricitySupplierAppointmentsResult = respJumbo;
        //response.put('response_x', obj);
        
        // Send success response
        EON_OFSC_Inbound_WS.ReportMessageElement message = new EON_OFSC_Inbound_WS.ReportMessageElement();
        message.result = 'success';
        message.code = '0';
        message.description = 'Appointment id = 126';
        EON_OFSC_Inbound_WS.ReportMessageElement[] messages = new EON_OFSC_Inbound_WS.ReportMessageElement[]{message};
            EON_OFSC_Inbound_WS.ReportElement reports = new EON_OFSC_Inbound_WS.ReportElement();
        reports.message = messages;
        EON_OFSC_Inbound_WS.AppointmentResponseElement appointment = new EON_OFSC_Inbound_WS.AppointmentResponseElement();
        appointment.appt_number = 'test';
        appointment.name = 'test';
        appointment.aid = 126;
        appointment.report = reports;
        EON_OFSC_Inbound_WS.CommandResponseElement command = new EON_OFSC_Inbound_WS.CommandResponseElement();
        command.appointment = appointment;
        EON_OFSC_Inbound_WS.CommandResponseElement[] commandarray = new EON_OFSC_Inbound_WS.CommandResponseElement[]{command};
            EON_OFSC_Inbound_WS.CommandsResponseArray commands = new EON_OFSC_Inbound_WS.CommandsResponseArray();
        commands.command = commandarray;
        EON_OFSC_Inbound_WS.DataResponseElement data = new EON_OFSC_Inbound_WS.DataResponseElement();
        data.commands = commands;
        EON_OFSC_Inbound_WS.InboundInterfaceResponseElement res = new EON_OFSC_Inbound_WS.InboundInterfaceResponseElement();
        res.user_x = new EON_OFSC_Inbound_WS.UserElement();
        res.head = new EON_OFSC_Inbound_WS.HeadResponseElement();
        res.data = data;
        //Elec data 
         EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
          eCode.Code = 'Code';
          eCode.Dispensation = 'Dispensation';
          eCode.IssueNumber = '007';
    
          EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
          elecCon.Name = 'Name';
          elecCon.Telephone = '12345678';
          elecCon.PreferredContactMethod = 'PreferredContactMethod';
          elecCon.Email = 'test@email.com';
          elecCon.Fax = '4004';      
          
          EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
          elecApp.EffectiveFromDate = '2015-04-23';
          elecApp.EffectiveToDate = '2016-08-23';
          elecApp.MarketParticipantId = '007';
          
          EON_JUMBO_Work_Management_WS.ElecAddress elecAdd = new EON_JUMBO_Work_Management_WS.ElecAddress();
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
          
          EON_JUMBO_Work_Management_WS.TimePatternRegime timePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime();
          timePatt.Code = '007';
          timePatt.RegisterMappingCoefficient= '4';
             
          EON_JUMBO_Work_Management_WS.TimePatternRegime timePatt1 = new EON_JUMBO_Work_Management_WS.TimePatternRegime();
          timePatt1.Code = '007';
          timePatt1.RegisterMappingCoefficient= '4';
          
          EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[]{timePatt,timePatt1}; 
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
          
          EON_JUMBO_Work_Management_WS.ElecRegister eReg1 = new EON_JUMBO_Work_Management_WS.ElecRegister();
          eReg1.Id = '1234';
          eReg1.TimePatternRegimes = arrTimePatt ;    
          
          EON_JUMBO_Work_Management_WS.ElecRegister eReg2 = new EON_JUMBO_Work_Management_WS.ElecRegister();
          eReg2.Id = '1234';
          eReg2.TimePatternRegimes = arrTimePatt ;  
          
          EON_JUMBO_Work_Management_WS.ElecRegister eReg3 = new EON_JUMBO_Work_Management_WS.ElecRegister();
          eReg3.Id = '1234';
          eReg3.TimePatternRegimes = arrTimePatt ;  
          
          EON_JUMBO_Work_Management_WS.ElecRegister eReg4 = new EON_JUMBO_Work_Management_WS.ElecRegister();
          eReg4.Id = '1234';
          eReg4.TimePatternRegimes = arrTimePatt ;  
          
          EON_JUMBO_Work_Management_WS.ElecRegister eReg5 = new EON_JUMBO_Work_Management_WS.ElecRegister();
          eReg5.Id = '1234';
          eReg5.TimePatternRegimes = arrTimePatt ; 
          
          EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[]{eReg,eReg1,eReg2,eReg3,eReg4,eReg5};
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
          eMeter.Type_x = 'S1';
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
          spNeed.category = '1'; //CH02.New
          spNeed.AdditionalInformation = 'Test';   //CH02.New
          EON_JUMBO_Work_Management_WS.SpecialNeed[] objSpNeed = new EON_JUMBO_Work_Management_WS.SpecialNeed[]{spNeed};
          EON_JUMBO_Work_Management_WS.ArrayOfSpecialNeed arrSpNeed = new EON_JUMBO_Work_Management_WS.ArrayOfSpecialNeed();
          arrSpNeed.SpecialNeed = objSpNeed ;      
    
          EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
          elecSup.EnergisationStatus = 'EnergisationStatus';
          elecSup.Phases = '3';
          elecSup.Voltage = '1400';
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
          eCust.MPAN = '123456987';
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
          resp.Errors = errObj;
          resp.Success = true;
          resp.Customer = eCust;
    
          EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element eleobj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();    
          eleobj.RequestElectricityMeterPointDataResult = resp;
        
        
        System.debug('stub = '+stub);
        System.debug('request = '+request);
        System.debug('response = '+response);
        System.debug('endpoint = '+endpoint);
        System.debug('soapAction = '+soapAction);
        System.debug('requestName = '+requestName);
        System.debug('responseNS = '+responseNS);
        System.debug('responseName = '+responseName);
        System.debug('responseType = '+responseType);
        
        if(request instanceOf EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element) {
            System.debug('Response for mop');
            response.put( 'response_x', obj);
        }else if ( request instanceOf EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element ){
            System.debug('Response for eletricity data');
            response.put( 'response_x', eleobj);
        }
        else if(request instanceOf EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element){
            String[] Msg1 = new String[]{'Message1','Message2','Message3'};
          EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
          err.Message = Msg1;
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
          gasAdd.Thoroughfare='Thoroughfare';
      
          EON_JUMBO_Work_Management_WS.GasRegister gRegi = new EON_JUMBO_Work_Management_WS.GasRegister();
          gRegi.MultiplicationFactor = '3';
          gRegi.NumberOfDigits = '2';
          gRegi.Type_x = 'UNCOR';
         
          EON_JUMBO_Work_Management_WS.GasRegister[] objGasReg = new EON_JUMBO_Work_Management_WS.GasRegister[]{gRegi};          
          EON_JUMBO_Work_Management_WS.ArrayOfGasRegister arrGReg = new EON_JUMBO_Work_Management_WS.ArrayOfGasRegister(); 
          arrGReg.GasRegister = objGasReg;
            
          EON_JUMBO_Work_Management_WS.GasMeter gMet = new EON_JUMBO_Work_Management_WS.GasMeter();
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
      
          EON_JUMBO_Work_Management_WS.GasMeter[] objGasMet = new EON_JUMBO_Work_Management_WS.GasMeter[]{gMet};          
          EON_JUMBO_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter(); 
          arrGMeter.GasMeter = objGasMet;      
    
           EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
           gasAObj.EffectiveFromDate ='2015-04-23';
           gasAObj.EffectiveToDate='2016-08-23';
           gasAObj.AbbreviatedName='MORR';
           
           EON_JUMBO_Work_Management_WS.Converter conver = new EON_JUMBO_Work_Management_WS.Converter();
           conver.SerialNumber = '007';
           conver.Model = 'Model';
           conver.AssetClass = 'AssetClass';
           conver.Manufacturer='Manufacturer';
           conver.Location = 'Location';
    
           EON_JUMBO_Work_Management_WS.Converter[] objConver = new EON_JUMBO_Work_Management_WS.Converter[]{conver};
           EON_JUMBO_Work_Management_WS.ArrayOfConverter arrConver = new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
           arrConver.Converter = objConver;
    
           EON_JUMBO_Work_Management_WS.ContactMechanism contMec = new EON_JUMBO_Work_Management_WS.ContactMechanism();
           contMec.Code = 'VISIT'; 
           contMec.Value = '007';       
           
           EON_JUMBO_Work_Management_WS.ContactMechanism[] objContMec = new EON_JUMBO_Work_Management_WS.ContactMechanism[]{contMec};
           EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism arrContMec = new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
           arrContMec.ContactMechanism = objContMec;
       
           EON_JUMBO_Work_Management_WS.Contact cont = new EON_JUMBO_Work_Management_WS.Contact();
           cont.TypeCode = 'UNCON';
           cont.Initials = 'Initials';
           cont.Surname = 'Surname';
           cont.Title = 'Title';
           cont.ContactMechanism = arrContMec;
           
           EON_JUMBO_Work_Management_WS.Contact[] objCont = new EON_JUMBO_Work_Management_WS.Contact[]{cont};
           EON_JUMBO_Work_Management_WS.ArrayOfContact arrCont = new EON_JUMBO_Work_Management_WS.ArrayOfContact();
           arrCont.Contact = objCont;
                 
           EON_JUMBO_Work_Management_WS.gasCustomer gCust = new EON_JUMBO_Work_Management_WS.gasCustomer();
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
       
           	EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp1 = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
           	resp1.Errors = err;
           	resp1.Success = true;
           	resp1.Customer = gCust;
       
      		EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj1 = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();    
			obj1.RequestgasMeterPointDataResult = resp1;
      		response.put('response_x', obj1);
        }
        else if (request instanceOf EON_OFSC_Inbound_WS.InboundInterfaceResponseElement){
            System.debug('Response for Cancel Appointment');
            response.put( 'response_x', res);
        }
    }      
}