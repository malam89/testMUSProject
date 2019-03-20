/**
    Description : This test class covers the code coverage for below class
                    1. EON_Create_Appointment_Request_ctrl
    **/
    /* 
    Created By    : Nitin Bangar
    Created On    : 03/05/2016
    Service Req   : SR_EON_AB_033
    Change History
    CH01 # SR_EON_PC_047 # 19/05/2016 # Krishna Y # Deleted reference for Customer lookup on EON Fuel.
    CH02 # SR_EON_AB_064 # 27/05/2016 # Nitin # Amended logic as per Changes in the SR.Added Test methods.
    CH03 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH04 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH05 #27/06/2016 #Shruti Moghe # updated to increase code coverage
    CH06 #18/11/2016 # Shivram Survase # Increased code coverage.
    */

    @isTest
    global class EON_Create_Appointment_Request_ctrl_Test implements WebServiceMock  {
          public static String funtype='';
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
          If(funtype=='1'){
          String[] Msg = new String[]{'Message1','Message2','Message3'};
          EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
          err.Message = Msg;
          
          
          boolean setPlannedEmetertype = false;
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
          resp.Success = true;
          resp.Customer = eCust;

          EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();    
          obj.RequestElectricityMeterPointDataResult = resp;
          response.put('response_x', obj);
          Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());
          funtype='0';
          }
          if(funtype=='0'){
          String[] Msg1 = new String[]{'Message1','Message2','Message3'};
            EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
            errObj.Message = Msg1;
            EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
            gasAObj.EffectiveFromDate ='2015-04-23';
            gasAObj.EffectiveToDate='2016-08-23';
            gasAObj.AbbreviatedName='MORR';
            EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[]{gasAObj};
            EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
            aepObj.GasAppointedParty = gasAppobj;
            EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
            empObj.MPRN = 'mprn123';
            empObj.SupplierAppointments = aepObj;
            EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
            respJumbo.Success = true;
            respJumbo.MeterPoint=empObj;
            respJumbo.Errors = errObj;
            EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj1 = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
            obj1.RequestGasSupplierAppointmentsResult = respJumbo;
            response.put('response_x', obj1);
            }
         }
         catch(Exception ex){
                 System.debug('*** Exception Occured : ' + ex.getMessage());
                 system.debug('$$$$'+ex.getLineNumber());
             }                
         }
         
         
        /**
        validateAppointmentBookingRequestPass1() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestPass1() {                   
            
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id; //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;      
            
            
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'Smart';
            lstEjob.add(job);
            insert lstEjob;       
       
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
            insert appt;         
            
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;  
            
            EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c(Name='TestIt',Vulnerability_Code__c=32);
            insert vulCode;
            
            EON_Appointment_Comms__c appointComm1 = new EON_Appointment_Comms__c(Comm_Type_Code__c='R',EON_Appointment_ID__c=appt.id);
            insert appointComm1;
            
            EON_Appointment_Contact__c  cont = new EON_Appointment_Contact__c(Contact_Full_Name__c='test',EON_Appointment_ID__c=appt.id);
            insert cont;
            
            List<EON_Appointment_Vulnerability__c> lstapptVul = new List<EON_Appointment_Vulnerability__c>();
            
            EON_Appointment_Vulnerability__c apptVul = new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = appt.id);
            lstapptVul.add(apptVul);  
            insert lstapptVul;     
                   
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();        
            String stFID = eFuel.id;
            crtAppt.selectedFuelID = stFID;        
            crtAppt.selFuelRecord = null;
            crtAppt.selJobRecord = lstEjob;
            crtAppt.newAppointment = appt;        
            crtAppt.eonApptVulnerability = apptVul;
            crtAppt.eonApptVulnerabilities = lstapptVul;        
            crtAppt.removeIndex = 0;
            crtAppt.ApptComms =appointComm1;
            crtAppt.ApptCont=cont;
            test.StartTest(); 
            Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test()); 
            crtAppt.appt = appt;
            crtAppt.setVisibilityPayg();//CH06
            crtAppt.save();  
            crtAppt.validateAppointmentBookingRequest();   
            crtAppt.isKeycollection(); //CH02
            crtAppt.selectedVulnerability = String.valueOf(vulCode.id);
            crtAppt.addRow();
            crtAppt.RemoveRow();
            appt.Planned_Meter_Mode__c='';
            crtAppt.newAppointment = appt;
            try{crtAppt.save();}catch(Exception e){}    
            System.assertEquals(job.MPRN_Reqd__c, True);        
            test.StopTest();   
        }
        
        /**
        validateAppointmentBookingRequestPass1F() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        static testmethod void validateAppointmentBookingRequestPass1F() {                   
            
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;  
            
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'Maintenance';
            lstEjob.add(job);
            insert lstEjob;    
       
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
            insert appt;                 
            
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthWest');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;  
            
            EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c(Name='TestIt',Vulnerability_Code__c=32);
            insert vulCode;
            System.debug('1');
            List<EON_Appointment_Vulnerability__c> lstapptVul = new List<EON_Appointment_Vulnerability__c>();
            
            EON_Appointment_Vulnerability__c apptVul = new EON_Appointment_Vulnerability__c(Description__c = vulCode.id,EON_Appointment_ID__c = appt.id);
            //insert apptVul;        
            System.debug('2');
            lstapptVul.add(apptVul);  
            insert lstapptVul;    
            
            EON_Site_Vulnerability__c siteVul = new EON_Site_Vulnerability__c(Customer__c = eCust.id,Premise__c = eSite.id,Vulnerability_code__c=vulCode.id,Vulnerability_Type__c='C');
            insert siteVul;
            System.debug('3');    
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();           
            System.debug('4');      
            String selFID = eFuel.id;
            crtAppt.selectedFuelID = selFID;        
            crtAppt.selFuelRecord = eFuel;
            crtAppt.selJobRecord = lstEjob;
            crtAppt.newAppointment = appt;        
            crtAppt.eonApptVulnerability = apptVul;  
            //crtAppt.eonApptVulnerabilities = lstapptVul;   
            //crtAppt.removeIndex = 0;
            test.StartTest();         
            System.debug('5');
            Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());        
            System.debug('6');
            crtAppt.validateAppointmentBookingRequest();   
            System.debug('7');
            //crtAppt.addRow();       
            crtAppt.appt = appt;
            crtAppt.save();  
            System.debug('I am next');         
            
           // crtAppt.RemoveRow();     
            System.assertEquals(job.MPRN_Reqd__c, True);        
            test.StopTest();   
        }
        
        /**
        validateAppointmentBookingRequestPass1D() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestPass1D() {                   
                    
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;  
                  
            String selFID = eFuel.id;
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();
            crtAppt.selectedFuelID = selFID;
            
            crtAppt.selFuelRecord = null;
           
            crtAppt.selJobRecord = null;         
           
            test.StartTest(); 
            Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());
            crtAppt.save();  
            crtAppt.validateAppointmentBookingRequest();   
            //crtAppt.addRow();
            crtAppt.RemoveRow();     
            //System.assertEquals(job.MPRN_Reqd__c, True);        
            test.StopTest();   
        }
        
        /**
        validateAppointmentBookingRequestPass1A() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestPass1A() {                   
                    
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;  
               
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'Maintenance';
            lstEjob.add(job);
            insert lstEjob;               
       
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
            insert appt; 
      
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area1',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthWest1');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;  
            
            EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c(Name='TestIt',Vulnerability_Code__c=32);
            insert vulCode;
            
            EON_Site_Vulnerability__c siteVul = new EON_Site_Vulnerability__c(Customer__c = eCust.id,Premise__c = eSite.id,Vulnerability_code__c=vulCode.id,Vulnerability_Type__c='C');
            insert siteVul;
            Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');
            insert Reason;
            
            List<EON_Appointment_Vulnerability__c> lstapptVul = new List<EON_Appointment_Vulnerability__c>();
            
            EON_Appointment_Vulnerability__c apptVul = new EON_Appointment_Vulnerability__c(Description__c = vulCode.id,EON_Appointment_ID__c = appt.id);
            lstapptVul.add(apptVul);  
            insert lstapptVul;

            System.currentPageReference().getParameters().put('fuelID',eFuel.id); 
            System.currentPageReference().getParameters().put('appReason',reason.name);  
            //CH02.Start
            ApexPages.StandardController sc = new ApexPages.StandardController(appt);
            EON_Create_Appointment_Request_ctrl stAppt = new EON_Create_Appointment_Request_ctrl(sc);
            stAppt.selFuelRecord = eFuel;   
            //CH02.End
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();        
            crtAppt.eonApptVulnerabilities = lstapptVul;   
            crtAppt.removeIndex = 0;
            test.StartTest(); 
            
            Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test()); 
            crtAppt.appReason = reason.name;
            crtAppt.eonApptVulnerability = apptVul;  
            crtAppt.eonApptVulnerabilities = lstapptVul;
            crtAppt.selectedVulnerability = String.valueOf(vulCode.id);
            crtAppt.addRow();
            crtAppt.Appt =appt;
            crtAppt.save();
            crtAppt.validateAppointmentBookingRequest();
            Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
            crtAppt.newAppointment = appt;    
            crtAppt.createApptIndus();
            List<System.SelectOption> Sel=crtAppt.appReasonLst; 
            //crtAppt.RemoveRow();     
            System.assertEquals(job.MPRN_Reqd__c, True);        
            test.StopTest();   
        }
        static testMethod void validateAppointmentBookingRequestPass1A_1() {                   
                    
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;  
               
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'Maintenance';
            lstEjob.add(job);
            insert lstEjob; 
        
        
       
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id,E_LowBalanceAlertValue__c=106,G_LowBalanceAlertValue__c=2);
            insert appt; 
        
        Eon_Delivery_Method__c DM = new Eon_Delivery_Method__c(Name = 'None',Code__c = 'E');
        insert DM;
        Eon_Delivery_Method__c DM1 = new Eon_Delivery_Method__c(Name = 'X123',Code__c = 'G');
        insert DM1;
        EON_Media_Type__c objMedType1 = new EON_Media_Type__c(Name='A', Code__c='1');
        insert objMedType1;
        EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
            insert objConType;
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=appt.Id);
        insert objCont;
                    
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area1',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthWest1');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;  
            
            EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c(Name='TestIt',Vulnerability_Code__c=32);
            insert vulCode;
            
            EON_Site_Vulnerability__c siteVul = new EON_Site_Vulnerability__c(Customer__c = eCust.id,Premise__c = eSite.id,Vulnerability_code__c=vulCode.id,Vulnerability_Type__c='C');
            insert siteVul;
            
            List<EON_Appointment_Vulnerability__c> lstapptVul = new List<EON_Appointment_Vulnerability__c>();
            
            EON_Appointment_Vulnerability__c apptVul = new EON_Appointment_Vulnerability__c(Description__c = vulCode.id,EON_Appointment_ID__c = appt.id);
            lstapptVul.add(apptVul);  
            insert lstapptVul;

            System.currentPageReference().getParameters().put('fuelID',eFuel.id);                
            //CH02.Start
            ApexPages.StandardController sc = new ApexPages.StandardController(appt);
            EON_Create_Appointment_Request_ctrl stAppt = new EON_Create_Appointment_Request_ctrl(sc);
            stAppt.selFuelRecord = eFuel;   
            //CH02.End
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();        
            crtAppt.eonApptVulnerabilities = lstapptVul;   
            crtAppt.removeIndex = 0;
            test.StartTest(); 
            
            Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());          
            crtAppt.eonApptVulnerability = apptVul;  
            crtAppt.eonApptVulnerabilities = lstapptVul;
            crtAppt.selectedVulnerability = String.valueOf(vulCode.id);
        
            crtAppt.addRow();
            crtAppt.Appt =appt;
            crtAppt.save();
            crtAppt.appReason='New Connections';
            crtAppt.validateAppointmentBookingRequest();
        crtAppt.newAppointment= appt;       
            crtAppt.appointmentID=appt.id;          
            crtAppt.validateAppointmentBookingRequest(); 
    crtAppt.ApptCont = objCont;
        crtAppt.selectedContact=objConType.Id;
        crtAppt.selectedMediaType=objMedType1.id;
            //crtAppt.addRowCon();
        crtAppt.removeRowCon();
            //crtAppt.RemoveRow();     
            System.assertEquals(job.MPRN_Reqd__c, True);        
            test.StopTest();   
        }
        
        /**
        validateAppointmentBookingRequestPass1C() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestPass1C() {                           
            
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;  
                   
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            //job.Job_Type__c = 'Maintenance';
            lstEjob.add(job);
            insert lstEjob;    
       
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
            insert appt;    
            
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 3);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area2',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;  
            
            EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c(Name='TestIt',Vulnerability_Code__c=32);
            insert vulCode;
            
            List<EON_Appointment_Vulnerability__c> lstapptVul = new List<EON_Appointment_Vulnerability__c>();
            
            EON_Appointment_Vulnerability__c apptVul = new EON_Appointment_Vulnerability__c(Description__c = vulCode.id,EON_Appointment_ID__c = appt.id);
            lstapptVul.add(apptVul);  
            insert lstapptVul;   
            Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Maintenance');//CH09
            insert Reason;
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();
            String selFID = eFuel.id;
            crtAppt.selectedFuelID = selFID;        
            crtAppt.selFuelRecord = null;
            crtAppt.selJobRecord = lstEjob;
            crtAppt.newAppointment = appt;
            crtAppt.eonApptVulnerability = apptVul;  
            crtAppt.removeIndex = 0;
            test.StartTest(); 
            Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());  
            crtAppt.appt = appt;
            crtAppt.save();  
            crtAppt.validateAppointmentBookingRequest();   
            crtAppt.eonApptVulnerabilities = lstapptVul; 
            crtAppt.selectedVulnerability = String.valueOf(vulCode.id);          
            crtAppt.addRow();
            crtAppt.RemoveRow();     
            System.assertEquals(job.MPRN_Reqd__c, True);        
            test.StopTest();   
        }
        
        /**
        validateAppointmentBookingRequestPass1B() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestPass1B() {                   
            test.StartTest();      
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();       
            //List<EON_Appointment_Vulnerability__c> apptVul = crtAppt.eonApptVulnerabilities;
            //apptVul = null;
            crtAppt.removeIndex = -1;
            crtAppt.removeRow();        
            //System.assertEquals(job.MPRN_Reqd__c, True);        
            test.StopTest();   
        }
        
        /**
        validateAppointmentBookingRequestPass1E() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestPass1E() {                   
            test.StartTest();      
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();       
            
            crtAppt.jobAttParam = null;                
            //System.assertEquals(job.MPRN_Reqd__c, True);        
            test.StopTest();   
        }
        
        /**
        validateAppointmentBookingRequestPass2() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestPass2() {           
            test.StartTest();               
            
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPRN__c = '123';
            eFuel.MPAN__c = '121'; 
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;
            System.currentPageReference().getParameters().put('fuelID',eFuel.id);     
            //String selFID = crtAppt.selectedFuelID;
            //crtAppt.selectedFuelID = eFuel.id;
            
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'ECO';
            lstEjob.add(job);
            insert lstEjob;        
                    

            
            List<EON_Job_Attribute__c> jbAttr = new List<EON_Job_Attribute__c>();
            
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            
            //CH03.start        
            EON_SSC__c  ssc2= new EON_SSC__c(name='0155',Type__c='Smart');
            insert ssc2;
             //CH03.end
            
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',current_ssc__c='0133',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
            insert appt; 
            

            
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area3',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast2');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;            
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();                
            crtAppt.selJobRecord = lstEjob; 
            boolean flag= EON_Create_Appointment_Request_ctrl.CustPaygFlag; //CH05
            crtAppt.jobAttParam = jbAttr; 
            appt.current_ssc__c='0133';     
            crtAppt.newAppointment = appt;
            crtAppt.getEonSSC();
            EON_SSC__c  ssc= new EON_SSC__c(name='0133',Type__c='Smart');
            insert ssc;
            EON_SSC__c  ssc1= new EON_SSC__c(name='0133',Type__c='Classic');
            insert ssc1;
             crtAppt.newAppointment = appt;
            crtAppt.getEonSSC();    
            crtAppt.validateAppointmentBookingRequest();
            
            
            //crtAppt.addRow();      
            System.assertEquals(job.MPRN_Reqd__c, True);        
            test.StopTest();   
        }   
        
        /**
        validateAppointmentBookingRequestPass3() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestPass3() {           
            test.StartTest();         
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();   
            String selFID = crtAppt.selectedFuelID;        
            String orcID = crtAppt.oracleBucketID;
            Boolean isRej = crtAppt.isRejected;
            Boolean canP = crtAppt.canProceed;
            List<EON_Job__c> ejob = crtAppt.selJobRecord;     
            List<JUMBO_Data_Tracker__c> LstJtrack = crtAppt.lstJumboTracker;
            
            crtAppt.save();
            crtAppt.validateAppointmentBookingRequest();        
            System.assertEquals(canP, False);        
            test.StopTest();   
        } 
        
        /**
        validateAppointmentBookingRequestPass4() - Positive test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestPass4() {                   
            test.StartTest(); 
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl(); 
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPRN__c = '123';
            eFuel.MPAN__c = '121'; 
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'G';
            insert eFuel;
            
           Eon_Delivery_Method__c DM1 = new Eon_Delivery_Method__c(Name = 'test_DM',Code__c = 'E');
           insert DM1;
           Eon_Delivery_Method__c DM2 = new Eon_Delivery_Method__c(Name = 'test_DM2',Code__c = 'G');
           insert DM2;
           

            //String selFID = crtAppt.selectedFuelID;
            //crtAppt.selectedFuelID = eFuel.id;
            
            crtAppt.selFuelRecord = null;
            
            List<EON_Job__c> job = new List<EON_job__c>();               
            crtAppt.selJobRecord = job;
            
            crtAppt.validateAppointmentBookingRequest();              
            System.assertEquals(eFuel.Fuel_Type__c, 'G');        
            test.StopTest();   
        }

        static testMethod void validateAppointmentBookingRequestPass_4() {                   
            test.StartTest(); 
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl(); 
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPRN__c = '123';
            eFuel.MPAN__c = '121'; 
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c ='D';//Changing DF to D as requested in SR_EON_PC_068

            insert eFuel;
            
            //String selFID = crtAppt.selectedFuelID;
            //crtAppt.selectedFuelID = eFuel.id;
            
            crtAppt.selFuelRecord = eFuel;
            
            List<EON_Job__c> job = new List<EON_job__c>();               
            crtAppt.selJobRecord = null;
            
            crtAppt.validateAppointmentBookingRequest();                
            System.assertEquals(eFuel.Fuel_Type__c, 'D');//Changing DF to D as requested in SR_EON_PC_068        
            test.StopTest();   
        }   
        
        /**
        validateAppointmentBookingRequestFAIL1() - Negative test coverage for method validateAppointmentBookingRequest().
        **/
        
        static testMethod void validateAppointmentBookingRequestFAIL1() {                   
            test.StartTest(); 
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();
            
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id; //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;        
            String selFID = eFuel.id;
            crtAppt.selectedFuelID = selFID;
            
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'Maintenance';
            lstEjob.add(job);
            insert lstEjob;        
           
            crtAppt.selJobRecord = lstEjob;
       
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
            insert appt; 
            
            crtAppt.newAppointment = appt;
            
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area4',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast2');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;    
             
            crtAppt.validateAppointmentBookingRequest(); 
            crtAppt.selJobRecord.clear();
            
            try{
                crtAppt.validateAppointmentBookingRequest();
            }Catch(Exception ex){}
                   
            System.assertEquals(job.MPRN_Reqd__c, True);
            test.StopTest();   
        } 

        /**
        setupTestData() - this method will create the test data for covering the code coverage
        **/
        @testSetup
        static void setupTestData() {                   
            
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            eCust.Customer_Name__c = 'Eon_Test';
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 2';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;        
                    
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'Maintenance';
            lstEjob.add(job);
            insert lstEjob;   
            
            Eon_Appointment_Reason__c eonApptReason = new Eon_Appointment_Reason__c(Name = 'Customer Request');
            insert eonApptReason;
            EON_Job_Appointment_Reason__c eonJobApptReason = new EON_Job_Appointment_Reason__c(Job__c = lstEjob[0].id, Appointment_Reason__c = eonApptReason.id);
            insert eonJobApptReason;
            
              
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
            insert appt; 
                    
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area5',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast3');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 2',Sub_Area_Name__c = subArea.id);
            insert pstCode; 
        }   
        
        /**
        validateAppointmentBookingRequestcoverage() - This method will try to cover the EON_Jumbo_ReqGasMAM.MAMValidationResponse
        **/
        static testMethod void validateAppointmentBookingRequestcoverage() {
            Test.startTest();
            //Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());
             Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
            EON_Jumbo_ElecGasData_Test.functionType ='MPANInddata';     
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();
            EON_Fuel__c fuel = [SELECT ID,Fuel_type__c,MPAN__c,MPRN__c,Gas_manufacturer_code_A0060__c,Gas_measuring_capacity_A0112__c,Gas_Meter_Mechanism__c,Gas_meter_serial_number__c,Gas_meter_type_A0025__c,Gas_model_A0083__c,Gas_number_of_dials_or_digits_A0121__c,Gas_payment_method_A0163__c,Gas_supplier_code__c,Premise__r.Building_Name__c,Premise__r.Dependant_Locality__c,Premise__r.Dependant_Thorofare__c,Premise__r.Double_Dependant_Locality__c,Premise__r.Sub_Building_Name__c,Premise__r.Thorofare__c,Premise__r.Town__c,Premise__r.Customer__c,Premise__r.Customer__r.Customer_Name__c,Premise__c,Premise__r.Postcode__c FROM EON_Fuel__c WHERE Fuel_Type__c = 'E'];
            crtAppt.selFuelRecord = fuel;
            List<EON_Job__c> lstJobs = new List<EON_Job__c>([SELECT ID,Name,Duration__c,h_Job_Attribute_Duration__c,Job_Type__c,Inactive__c,MAM_Reqd__c,MOP_Reqd__c,MPAN_Reqd__c,MPRN_Reqd__c FROM EON_Job__c]);
            
            crtAppt.selJobRecord = lstJobs;
            crtAppt.validateAppointmentBookingRequest();
            Test.stopTest();
        }
        
        static testMethod void validateAppointmentBookingRequestcoverage11() {
            Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());        
            Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test()); 
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();
            EON_Fuel__c fuel = [SELECT ID,Fuel_type__c,MPAN__c,MPRN__c,Gas_manufacturer_code_A0060__c,Gas_measuring_capacity_A0112__c,Gas_Meter_Mechanism__c,Gas_meter_serial_number__c,Gas_meter_type_A0025__c,Gas_model_A0083__c,Gas_number_of_dials_or_digits_A0121__c,Gas_payment_method_A0163__c,Gas_supplier_code__c,Premise__r.Building_Name__c,Premise__r.Dependant_Locality__c,Premise__r.Dependant_Thorofare__c,Premise__r.Double_Dependant_Locality__c,Premise__r.Sub_Building_Name__c,Premise__r.Thorofare__c,Premise__r.Town__c,Premise__r.Customer__c,Premise__r.Customer__r.Customer_Name__c,Premise__c,Premise__r.Postcode__c FROM EON_Fuel__c WHERE Fuel_Type__c = 'E'];
            crtAppt.selFuelRecord = fuel;
            List<EON_Job__c> lstJobs = new List<EON_Job__c>([SELECT ID,Name,Duration__c,h_Job_Attribute_Duration__c,Job_Type__c,Inactive__c,MAM_Reqd__c,MOP_Reqd__c,MPAN_Reqd__c,MPRN_Reqd__c FROM EON_Job__c]);
            
            crtAppt.selJobRecord = lstJobs;
            crtAppt.validateAppointmentBookingRequest();
            Test.stopTest();
        }
        /**
        EON_Job_Attribute_Test() - This method will cover the Job attributes and EON Job code error.
        **/
        static testMethod void EON_Job_Attribute_Test() {
            Test.startTest();
            Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();
            EON_Fuel__c fuel = [SELECT ID,Fuel_type__c,MPAN__c,MPRN__c,Gas_manufacturer_code_A0060__c,Gas_measuring_capacity_A0112__c,Gas_Meter_Mechanism__c,Gas_meter_serial_number__c,Gas_meter_type_A0025__c,Gas_model_A0083__c,Gas_number_of_dials_or_digits_A0121__c,Gas_payment_method_A0163__c,Gas_supplier_code__c,Premise__r.Building_Name__c,Premise__r.Dependant_Locality__c,Premise__r.Dependant_Thorofare__c,Premise__r.Double_Dependant_Locality__c,Premise__r.Sub_Building_Name__c,Premise__r.Thorofare__c,Premise__r.Town__c,Premise__r.Customer__c,Premise__r.Customer__r.Customer_Name__c,Premise__c,Premise__r.Postcode__c FROM EON_Fuel__c WHERE Fuel_Type__c = 'E'];
            crtAppt.selFuelRecord = fuel;
            List<EON_Job__c> lstJobs = new List<EON_Job__c>([SELECT ID,Name,Duration__c,h_Job_Attribute_Duration__c,Job_Type__c,Inactive__c,MAM_Reqd__c,MOP_Reqd__c,MPAN_Reqd__c,MPRN_Reqd__c FROM EON_Job__c]);
            
            crtAppt.selJobRecord = null;
            crtAppt.validateAppointmentBookingRequest();
            System.debug('crtAppt.jobAttParam = '+crtAppt.jobAttParam);
            Test.stopTest();
        }
        static testMethod void AllFailConditions_Test() {
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();
            crtAppt.ApptCont = new EON_Appointment_Contact__c();
            crtAppt.addRowCon();
            
        }
        static testMethod void CreateApptIndusPass() {                   
                    
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;  
               
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'Maintenance';
            lstEjob.add(job);
            insert lstEjob;               
       
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
            insert appt; 
      
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area1',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthWest1');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;  
            
            EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c(Name='TestIt',Vulnerability_Code__c=32);
            insert vulCode;
            
            EON_Site_Vulnerability__c siteVul = new EON_Site_Vulnerability__c(Customer__c = eCust.id,Premise__c = eSite.id,Vulnerability_code__c=vulCode.id,Vulnerability_Type__c='C');
            insert siteVul;
            Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');
            insert Reason;
            
            List<EON_Appointment_Vulnerability__c> lstapptVul = new List<EON_Appointment_Vulnerability__c>();
            
            EON_Appointment_Vulnerability__c apptVul = new EON_Appointment_Vulnerability__c(Description__c = vulCode.id,EON_Appointment_ID__c = appt.id);
            lstapptVul.add(apptVul);  
            insert lstapptVul;

            System.currentPageReference().getParameters().put('fuelID',eFuel.id); 
            System.currentPageReference().getParameters().put('appReason',reason.name);  
            //CH02.Start
            ApexPages.StandardController sc = new ApexPages.StandardController(appt);
            EON_Create_Appointment_Request_ctrl stAppt = new EON_Create_Appointment_Request_ctrl(sc);
            stAppt.selFuelRecord = eFuel;   
            //CH02.End
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();        
            crtAppt.eonApptVulnerabilities = lstapptVul;   
            crtAppt.removeIndex = 0;
            test.StartTest();           
            crtAppt.appReason = reason.name;
            crtAppt.eonApptVulnerability = apptVul;  
            crtAppt.eonApptVulnerabilities = lstapptVul;
            crtAppt.selectedVulnerability = String.valueOf(vulCode.id);
            crtAppt.addRow();
            crtAppt.Appt =appt;
            crtAppt.save();
            Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
            Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); 
            crtAppt.newAppointment = appt;   
            crtAppt.createApptIndus();
            List<System.SelectOption> Sel=crtAppt.appReasonLst; 
            //crtAppt.RemoveRow();     
            System.assertEquals(job.MPRN_Reqd__c, True);  
            ApexPages.CurrentPage().getParameters().put('appointmentID',appt.Id);   
            EON_Create_Appointment_Request_ctrl stAppt2 = new EON_Create_Appointment_Request_ctrl(sc);   
            test.StopTest();   
        }    
         static testMethod void CreateApptIndusPass1() {                   
                    
            EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
            insert eCust;
            EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
            eSite.Postcode__c = 'SE10 1';
            insert eSite;
            EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
            eFuel.MPAN__c = '12'; 
            eFuel.MPRN__c = '123';        
            eFuel.Premise__c = eSite.id;
            //eFuel.Customer__c = eCust.id;  //CH01
            eFuel.Fuel_Type__c = 'E';
            insert eFuel;  
               
            List<EON_job__c> lstEjob = new List<EON_job__c>();
            EON_Job__c job = EON_CreateTestRecords.createEONJob();
            job.Name = 'OOASMARTELECEXCH';
            job.MPRN_Reqd__c = true;
            job.MPAN_Reqd__c = true;
            job.Job_Type__c = 'Maintenance';
            lstEjob.add(job);
            insert lstEjob;               
       
            EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
            insert jobAtt;        
            //CH03.start
            EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
            insert ssc;
             //CH03.end
            EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '0133',Planned_E_Meter_Type__c='--None--',//CH03.old
            //Requested_SSC__c=ssc.id,//CH04.old
            Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
            insert appt; 
      
            EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
            insert region;
            
            EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area1',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthWest1');
            insert subArea;
            
            EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
            insert pstCode;  
            
            EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c(Name='TestIt',Vulnerability_Code__c=32);
            insert vulCode;
            
            EON_Site_Vulnerability__c siteVul = new EON_Site_Vulnerability__c(Customer__c = eCust.id,Premise__c = eSite.id,Vulnerability_code__c=vulCode.id,Vulnerability_Type__c='C');
            insert siteVul;
            Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');
            insert Reason;
            
            List<EON_Appointment_Vulnerability__c> lstapptVul = new List<EON_Appointment_Vulnerability__c>();
            
            EON_Appointment_Vulnerability__c apptVul = new EON_Appointment_Vulnerability__c(Description__c = vulCode.id,EON_Appointment_ID__c = appt.id);
            lstapptVul.add(apptVul);  
            insert lstapptVul;

            System.currentPageReference().getParameters().put('fuelID',eFuel.id); 
            System.currentPageReference().getParameters().put('appReason',reason.name);  
            //CH02.Start
            ApexPages.StandardController sc = new ApexPages.StandardController(appt);
            EON_Create_Appointment_Request_ctrl stAppt = new EON_Create_Appointment_Request_ctrl(sc);
            stAppt.selFuelRecord = eFuel;   
            //CH02.End
            EON_Create_Appointment_Request_ctrl crtAppt = new EON_Create_Appointment_Request_ctrl();        
            crtAppt.eonApptVulnerabilities = lstapptVul;   
            crtAppt.removeIndex = 0;
            test.StartTest();           
            crtAppt.appReason = reason.name;
            crtAppt.eonApptVulnerability = apptVul;  
            crtAppt.eonApptVulnerabilities = lstapptVul;
            crtAppt.selectedVulnerability = String.valueOf(vulCode.id);
            crtAppt.addRow();
            crtAppt.Appt =appt;
            crtAppt.save();
            boolean setPlannedEmetertype = false;
            
           
            
          
            
            Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl()); 
            crtAppt.newAppointment = appt;   
            crtAppt.createApptIndus();
            List<System.SelectOption> Sel=crtAppt.appReasonLst; 
            //crtAppt.RemoveRow();     
            System.assertEquals(job.MPRN_Reqd__c, True);  
            ApexPages.CurrentPage().getParameters().put('appointmentID',appt.Id);   
            EON_Create_Appointment_Request_ctrl stAppt2 = new EON_Create_Appointment_Request_ctrl(sc);   
            test.StopTest();   
        }        
        
    
  
    
    }