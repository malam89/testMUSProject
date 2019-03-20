/**
    Description : This test class covers the code coverage for below class
        1. EON_JUMBO_Create_ElecJob_In_Isis_WS
**/
/*
    Created By : Praveen G
    Created Date : 02-March-2016
    Service Request : SR_EON_Jumbo_002
  	Change History :
    CH01 # SR_EON_Jumbo_046 # 25/07/2016 # Mahadev Joshilkar # Update code coverage
	CH02 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Mapping for JUMBO Vulnerability Code with EON Vulnerability Code
	CH03 # SR_EON_JUMBO_061 # 26/08/2016 # Mahadev Joshilkar # Additional Parameter in WSDL - Requested SSC
	CH04 # SR_EON_Jumbo_062 # 03/09/2016 # Mahadev Joshilkar # Update code coverage
	CH05 # SR_EON_JUMBO_098 # 16/01/2017 # Mahadev Joshilkar #  Improved logic to create - EON Appointment Contacts
*/

@isTest
global class EON_JUMBO_Create_ElecJob_In_Isis_WS_Test implements WebServiceMock {
    
    /**
    	createElectricityJobInIsis_1() - Fail Unit test for method createElectricityJobInIsis
    **/ 
    static testMethod void createElectricityJobInIsis_1(){  
        EON_JUMBO_Create_ElecJob_In_Isis_WS controller = new EON_JUMBO_Create_ElecJob_In_Isis_WS();
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest request1 = new EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest();
        request1.MPAN = '1234';
        request1.JUMBOID = '1234';
        request1.earliestStartDate = System.today();
        request1.JUMBOJobType = 'test Type';
        request1.RequestTime='123456789012345678901234567890';
        EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response1 = EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request1);
        System.assert(response1.success == 'FAIL');             
    } 
    
    /**
    	createElectricityJobInIsis_2() - Fail Unit test for the method createElectricityJobInIsis
    **/   
    static testMethod void createElectricityJobInIsis_2(){  
        EON_JUMBO_Create_ElecJob_In_Isis_WS controller = new EON_JUMBO_Create_ElecJob_In_Isis_WS();
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest();             
        EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request);
        System.assert(response.success == 'FAIL');       
    }
    
    /**
    	createElectricityJobInIsis_3() - Fail Unit test for the method createElectricityJobInIsis
    **/    
    static testMethod void createElectricityJobInIsis_3() {  
        Test.startTest();
        EON_JUMBO_Create_ElecJob_In_Isis_WS controller = new EON_JUMBO_Create_ElecJob_In_Isis_WS();      
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest request;
        EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response = EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request);
        
        EON_Job__c job = new EON_Job__c();
        job.Name =  'test Type';
        job.Description__c = 'Description';
        insert job;
        
        EON_Electric_Meter_Location__c eMeterLo = new EON_Electric_Meter_Location__c();
        eMeterLo.Code__c = 'Loc';
        eMeterLo.name = 'NameOfLoc';
        insert eMeterLo;
        
        EON_Electric_Meter_Type__c eMetTyp = new EON_Electric_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;

        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
      insert parType;
       
        EON_JUMBO_WebServiceMockImpl.functiontype='Error';
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_JUMBO_WebServiceMockImpl.functiontype='Error';
        try{      
          request = new EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest();
          request.MPAN = '1234';
          request.JUMBOID = '1234';
          request.earliestStartDate = System.today();
          request.JUMBOJobType = 'test Type';         
          EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response1 =  EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request);
          System.assert(response1.success == 'FAIL');
        }
        catch(Exception e){system.debug(e);}
        Test.stopTest();        
      
    }    
	
    /**
    	createElectricityJobInIsis_4() - Pass Unit test for the method createElectricityJobInIsis
    **/ 
    static testMethod void createElectricityJobInIsis_4() {  
    	EON_JUMBO_Create_ElecJob_In_Isis_WS.mediaType('N');
    	
        EON_Job__c job = new EON_Job__c();
        job.Name =  'test Type';
        job.Description__c = 'Description';
        job.Jumbo_Job_Code__c ='test Type';
        job.h_Appointment_Reason_Code__c = 'test code'; //Ch01.New
        insert job;
        
        Eon_Appointment_Reason__c appReasonCode = new Eon_Appointment_Reason__c(Name = 'test code'); //CH01.New
        insert appReasonCode; //CH01.New
		
		EON_Contact_Type__c cType = new EON_Contact_Type__c(Name='New', Code__c='A');
        Insert cType;
        
        EON_Media_Type__c mType = new EON_Media_Type__c(code__c='L',Name='Media');
        Insert mType;
        EON_Media_Type__c mType1 = new EON_Media_Type__c(code__c='T',Name='Media');
        Insert mType1;
        
        EON_Electric_Meter_Location__c eMeterLo = new EON_Electric_Meter_Location__c();
        eMeterLo.Code__c = 'Loc';
        eMeterLo.name = 'NameOfLoc';
        insert eMeterLo;
        
        EON_Electric_Meter_Type__c eMetTyp = new EON_Electric_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;
        
        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
        insert parType;
        
        //CH02.Start
         EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c();
         vulCode.JUMBO_Vulnerability_Code__c = 1;
         insert vulCode;
         //CH02.End
          
        Test.StartTest();
        EON_JUMBO_Create_ElecJob_In_Isis_WS controller = new EON_JUMBO_Create_ElecJob_In_Isis_WS();
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = '1234';
        request.JUMBOID = '1234';
        request.RequestTime ='111010';
        request.EarliestStartTime ='121010' ;
        request.LatestStartTime = '101010';
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'test Type';        
        EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response =  EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request);
        System.assert(response.success == 'PASS');
        Test.StopTest();
    } 
	
   	/**
    	createElectricityJobInIsis_5() - Fail Unit test for the method createElectricityJobInIsis
    **/ 
    static testMethod void createElectricityJobInIsis_5() {  

        EON_Job__c job = new EON_Job__c();
        job.Name =  'test Type';
        job.Description__c = 'Description';
        job.Jumbo_Job_Code__c ='test Type';
        insert job;
        
        EON_Electric_Meter_Location__c eMeterLo = new EON_Electric_Meter_Location__c();
        eMeterLo.Code__c = 'Loc';
        eMeterLo.name = 'NameOfLoc';
        insert eMeterLo;
        
        EON_Electric_Meter_Type__c eMetTyp = new EON_Electric_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;
        
        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
        insert parType;
      
        Test.StartTest();
        EON_JUMBO_Create_ElecJob_In_Isis_WS controller = new EON_JUMBO_Create_ElecJob_In_Isis_WS();
        EON_JUMBO_WebServiceMockImpl.functiontype='Testing';
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl()); 
        EON_JUMBO_WebServiceMockImpl.functiontype='Testing';    
        try{        
          EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest();
          request.MPAN = '1234';
          request.JUMBOID = '1234';
          request.LatestStartTime = '10:10:10';
          request.earliestStartDate = System.today();
          request.JUMBOJobType = 'test Type';           
          EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response =  EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request);
          System.assert(response.success == 'FAIL');
        }
        catch(Exception e){system.debug(e);}

        Test.StopTest();
    }
	
	/**
    	createElectricityJobInIsis_6() - Fail Unit test for the method createElectricityJobInIsis
    **/ 
    static testMethod void createElectricityJobInIsis_6() {  

        EON_Job__c job = new EON_Job__c();
        job.Name =  'test Type';
        job.Description__c = 'Description';
        job.Jumbo_Job_Code__c ='test Type';
        insert job;
        
        EON_Electric_Meter_Location__c eMeterLo = new EON_Electric_Meter_Location__c();
        eMeterLo.Code__c = 'Loc';
        eMeterLo.name = 'NameOfLoc';
        insert eMeterLo;
        
        EON_Electric_Meter_Type__c eMetTyp = new EON_Electric_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;

        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
      insert parType;

        Test.StartTest();
        EON_JUMBO_Create_ElecJob_In_Isis_WS controller = new EON_JUMBO_Create_ElecJob_In_Isis_WS();
        try{            
          EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest();
          request.MPAN = '1234';
          request.JUMBOID = '1234';
          request.LatestStartTime = '10:10:10';
          request.earliestStartDate = System.today();
          request.JUMBOJobType = 'test Type';
          request.RequestTime='123456789012345678901234567890sdgsdgnsognmsdoingo';
          request.earliestStartTime='safg4647747575747gjnsindgsg';      
          EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response =  EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request);
        }
        catch(Exception e){system.debug(e);}
        Test.StopTest();
    } 
    
    /**
    	createElectricityJobInIsis_7() - Positive Unit test for the method createElectricityJobInIsis
    **/
    static testMethod void createElectricityJobInIsis_7(){  
        EON_Job__c job = new EON_Job__c();
        job.Name =  'test Type';
        job.Description__c = 'Description';
        job.Jumbo_Job_Code__c ='test Type';
        insert job;
        
        EON_Electric_Meter_Location__c eMeterLo = new EON_Electric_Meter_Location__c();
        eMeterLo.Code__c = 'Loc';
        eMeterLo.name = 'NameOfLoc';
        insert eMeterLo;
        
        EON_Electric_Meter_Type__c eMetTyp = new EON_Electric_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;
        
        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
      insert parType;

        Test.StartTest();
        EON_JUMBO_Create_ElecJob_In_Isis_WS controller = new EON_JUMBO_Create_ElecJob_In_Isis_WS();
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());   
        EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = '1234';
        request.JUMBOID = '12344548548574854857485485748574857487487487487487487487487487487487487487487';
        request.LatestStartTime = '10:10';
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'test Type';        
        request.RequestedSSC = 'Test'; //CH03.New
        EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response =  EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request);
        System.assert(response.success == 'FAIL');
        Test.StopTest();
    }   
    
    /*
		createElectricityJobInIsis_8() - This will cover chnage #CH04
	*/
    static testmethod void createElectricityJobInIsis_8(){
        EON_Job__c job = new EON_Job__c();
        job.Name =  'test Type';
        job.Description__c = 'Description';
        job.Jumbo_Job_Code__c ='test Type';
        job.h_Appointment_Reason_Code__c = 'test code'; //Ch01.New
        insert job;
        
        Eon_Appointment_Reason__c appReasonCode = new Eon_Appointment_Reason__c(Name = 'test code'); //CH01.New
        insert appReasonCode; //CH01.New
		
		EON_Contact_Type__c cType = new EON_Contact_Type__c(Name='New', Code__c='A');
        Insert cType;
        
        EON_Media_Type__c mType = new EON_Media_Type__c(code__c='L',Name='Media');
        Insert mType;
        EON_Media_Type__c mType1 = new EON_Media_Type__c(code__c='T',Name='Media');
        Insert mType1;
        
        EON_Electric_Meter_Location__c eMeterLo = new EON_Electric_Meter_Location__c();
        eMeterLo.Code__c = 'Loc';
        eMeterLo.name = 'NameOfLoc';
        insert eMeterLo;
        
        EON_Electric_Meter_Type__c eMetTyp = new EON_Electric_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;
        
        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
        insert parType;
        
        EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c();
        vulCode.JUMBO_Vulnerability_Code__c = 1;
        insert vulCode;
          
        Test.StartTest();
        EON_JUMBO_Create_ElecJob_In_Isis_WS controller = new EON_JUMBO_Create_ElecJob_In_Isis_WS();
        EON_Jumbo_ElecGasData_Test.functionType = 'validateMOP';
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
        EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = '1234';
        request.JUMBOID = '1234';
        request.RequestTime ='111010';
        request.EarliestStartTime ='121010' ;
        request.LatestStartTime = '101010';
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'test Type';        
        EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response =  EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request);
        System.assert(response.success == 'FAIL');
        Test.StopTest();
    }
    
    /**
    	createElectricityJobInIsis_9() - Pass Unit test for the method createElectricityJobInIsis //CH05
    **/ 
    static testMethod void createElectricityJobInIsis_9() {  
        EON_JUMBO_WebServiceMockImpl.PreferredContactMethod = '';
    	EON_JUMBO_Create_ElecJob_In_Isis_WS.mediaType('N');
    	
        EON_Job__c job = new EON_Job__c();
        job.Name =  'test Type';
        job.Description__c = 'Description';
        job.Jumbo_Job_Code__c ='test Type';
        job.h_Appointment_Reason_Code__c = 'test code'; 
        insert job;
        
        Eon_Appointment_Reason__c appReasonCode = new Eon_Appointment_Reason__c(Name = 'test code'); 
        insert appReasonCode; 
		
		EON_Contact_Type__c cType = new EON_Contact_Type__c(Name='New', Code__c='A');
        Insert cType;
        
        EON_Media_Type__c mType = new EON_Media_Type__c(code__c='L',Name='Telephone');
        Insert mType;
        EON_Media_Type__c mType1 = new EON_Media_Type__c(code__c='T',Name='Media');
        Insert mType1;
        
        EON_Electric_Meter_Location__c eMeterLo = new EON_Electric_Meter_Location__c();
        eMeterLo.Code__c = 'Loc';
        eMeterLo.name = 'NameOfLoc';
        insert eMeterLo;
        
        EON_Electric_Meter_Type__c eMetTyp = new EON_Electric_Meter_Type__c();
        eMetTyp.name  = 'Type_x';
        insert eMetTyp;
        
        EON_Parking__c parType = new EON_Parking__c(Parking_Code__c='O');
        insert parType;
        
         EON_Vulnerability_Code__c vulCode = new EON_Vulnerability_Code__c();
         vulCode.JUMBO_Vulnerability_Code__c = 1;
         insert vulCode;
          
        Test.StartTest();
        EON_JUMBO_Create_ElecJob_In_Isis_WS controller = new EON_JUMBO_Create_ElecJob_In_Isis_WS();
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest request = new EON_JUMBO_Create_ElecJob_In_Isis_WS.ElecWorkRequest();
        request.MPAN = '1234';
        request.JUMBOID = '1234';
        request.RequestTime ='111010';
        request.EarliestStartTime ='121010' ;
        request.LatestStartTime = '101010';
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'test Type';        
        EON_JUMBO_Create_ElecJob_In_Isis_WS.JumboToIsisElecWorkResponse response =  EON_JUMBO_Create_ElecJob_In_Isis_WS.createElectricityJobInIsis(request);
        System.assert(response.success == 'PASS');
        Test.StopTest();
    } 
    
    /**
    	mediaDetails_Test() - Positive Unit test for the method mediaDetails
    **/ 
    static testMethod void mediaDetails_Test(){  
     EON_appointment__c eApp = new EON_appointment__c(Customer_Preferred_Contact_Method__c='A');
     insert eApp;
     EON_JUMBO_Create_ElecJob_In_Isis_WS.mediaDetails(eApp);
     eApp.Customer_Preferred_Contact_Method__c='H';
     update eApp;
     EON_JUMBO_Create_ElecJob_In_Isis_WS.mediaDetails(eApp);
     eApp.Customer_Preferred_Contact_Method__c='E';
     update eApp;
     EON_JUMBO_Create_ElecJob_In_Isis_WS.mediaDetails(eApp);
    }
	
	global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType){
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
      elecCon.PreferredContactMethod = 'L';
      elecCon.Email = 'test@email.com';
      elecCon.Fax = '4004';      
      
      EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
      elecApp.EffectiveFromDate = '2015-04-23';
      elecApp.EffectiveToDate = '2016-08-23';
      elecApp.MarketParticipantId = '007';
      EON_JUMBO_Work_Management_WS.ElecAddress elecAdd = new EON_JUMBO_Work_Management_WS.ElecAddress();
      //if(functiontype==''){
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
      //}
     
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
      //if(functiontype!='Error')
      resp.Success = true;
      //if(functiontype=='Error')
      //resp.Success = false;
      resp.Customer = eCust;
        
      EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();    
      obj.RequestElectricityMeterPointDataResult = resp;
		if(request instanceof EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element)
      		response.put('response_x', obj);
      	else if(request instanceof EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element){
        	String[] Msg1 = new String[]{'Message1','Message2','Message3'};
        	EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
        	errObj.Message = Msg1;
        	EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty(); 
        	eapObj.EffectiveFromDate ='20150423';
        	eapObj.EffectiveToDate='20160823';
        	eapObj.MarketParticipantId='EMEB';
        	EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[]{eapObj};
        	EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
        	aepObj.ElecAppointedParty = aEobj;
        	EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
        	empObj.MPAN = 'mpan123';
        	empObj.SupplierAppointments = aepObj;
        	EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo1 = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
        	respJumbo1.Success = true;
        	respJumbo1.MeterPoint=empObj;
        	respJumbo1.Errors = errObj;
        	EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj1 = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
        	obj1.RequestElectricitySupplierAppointmentsResult = respJumbo1;
        	response.put('response_x', obj1);        
        }
      }
     catch(Exception ex){
             System.debug('*** Exception Occured : ' + ex.getMessage());
             system.debug('$$$$'+ex.getLineNumber());
         }
    }
}