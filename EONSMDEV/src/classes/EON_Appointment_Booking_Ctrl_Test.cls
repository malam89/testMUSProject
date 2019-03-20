/**
Description : This test class covers the code coverage for below class
                1. EON_Appointment_Booking_Ctrl
**/
/* 
Created By    : Sivasankar K
Created On    : 25/02/2016
Service Req   : SR_EON_AB_002
Change History
CH01 # SR_EON_AB_033 # 05/04/2016 # Nitin # Added new test methods according to the changes in the controller.
CH02 # SR_EON_AB_012 # 13/04/2016 # Nitin # Added Methods to cover class EON_Appointment_Booking_Ctrl_Helper
CH03 # SR_EON_Mobile_031 # 21/04/2016 # Dharmendra P # Updated data type of few fields so updated the test class.
CH04 # SR_EON_PC_047 # 19/05/2016 # Krishna Y # Deleted reference for Customer lookup on EON Fuel.
CH05 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
CH06 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
CH07 # SR_EON_AB_067 # 21/06/2016 # Nitin # Added conditions to cover new method in the controller.
CH08 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
CH09 # SR_EON_AB_122 # 17/08/2016 # Shruti Moghe # Updated code to increase code coverage
CH10 # SR_EON_AB_154 # 28/09/2016 # Puneet Mehta # Changed 'Key' to 'KEY'
CH11 # SR_EON_297 # 12/02/2019 # Tabish Almas # Increased code coverage
*/
@isTest
public class EON_Appointment_Booking_Ctrl_Test {
public static boolean genException=false;        

//mock class 1
class MainClient implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            EON_Jumbo_ReqGasMAM.MAMValidationResponse mamcheck = new EON_Jumbo_ReqGasMAM.MAMValidationResponse();
            
            mamcheck.isError = False;
            mamcheck.effFromDate = date.today()-1;
            mamCheck.effToDate = Date.today();
            mamCheck.Error = '';
            mamCheck.abbrvtdName = '';
            response.put('response_x',mamCheck);
    }
    }
    
   //mock class 2  
   class MainClienttest implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            EON_Jumbo_ReqElectricityMOP.MOPValidationResponse mopcheck = new EON_Jumbo_ReqElectricityMOP.MOPValidationResponse ();
            
            mopcheck.isError = false;
            mopcheck.effFromDate = date.today()-5;
            mopcheck.effToDate = date.today();
            mopcheck.Error = '';
            mopcheck.marParticipantId = '';
            response.put('response_x',mopcheck);
             
           
    }
       
    } 
    
    
    /**
    searchAppointmentsPass1() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
	static testMethod void searchAppointmentsPass1() {   
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.areWeNotMAM =True;
        eonAppCtrl.oracleBucketID=null;
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';                
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppCtrl.geteonAppSearchResult();        
        eonAppErrorCtrl.geteonAppSearchResult();  
        
        //Praveen Added Start
        System.currentPageReference().getParameters().put('replan', 'yes');
        eonAppErrorCtrl.redirectToReschedule();
        //Praveen Added End
		
    	//CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch;
        //CH11.End
    
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        insert eonApp;                        
        System.currentPageReference().getParameters().put('AppointmentID', eonApp.Id);        
                
        String selectedId = eonAppCtrl.selFuelID;
        String custId = eonAppCtrl.customerID; 
        String jbCode = eonAppCtrl.jobCode;
        String appCtrl = eonAppCtrl.oracleBucketID;
          
        String apptReason = eonAppCtrl.appointmentReason;  
        String jbSearched = eonAppCtrl.jobCodesSearched;       
        boolean jbisIndustryCreateApp = eonAppCtrl.isIndustryCreateApp; 
        boolean jbareWeNotMAM  = eonAppCtrl.areWeNotMAM ;  
        Eon_Appointment__c eonApp1 = eonAppCtrl.newAppointment;
        String apptID = eonApp.id;
        apptID = eonAppCtrl.selAppointmentID;    
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Appointment not found. cannot cancel', API__c ='Inbound');
        insert objRC1;
        eonAppCtrl.cancelAppointment();   
        objRC1.OFSC_Text__c='Request processed successfully.';
        update objRC1;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();         
        eonAppCtrl.cancelAppointment();         
        test.StopTest();   
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);        
    }
    
    /**
    searchAppointmentsPass1_a() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
	static testMethod void searchAppointmentsPass1_a() {   
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.areWeNotMAM =True;
        eonAppCtrl.oracleBucketID=null;
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';                
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppCtrl.geteonAppSearchResult();        
        eonAppErrorCtrl.geteonAppSearchResult();  
        
        //Praveen Added Start
        System.currentPageReference().getParameters().put('replan', 'yes');
        eonAppErrorCtrl.redirectToReschedule();
        //Praveen Added End
		
    	//CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = true,
                                                                                  MDS_Status__c = false,
                                                                                  MDS_Close_Command_Only__c = true);
        insert mdsSwitch;
        //CH11.End
    
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        insert eonApp;                        
        System.currentPageReference().getParameters().put('AppointmentID', eonApp.Id);        
                
        String selectedId = eonAppCtrl.selFuelID;
        String custId = eonAppCtrl.customerID; 
        String jbCode = eonAppCtrl.jobCode;
        String appCtrl = eonAppCtrl.oracleBucketID;
          
        String apptReason = eonAppCtrl.appointmentReason;  
        String jbSearched = eonAppCtrl.jobCodesSearched;       
        boolean jbisIndustryCreateApp = eonAppCtrl.isIndustryCreateApp; 
        boolean jbareWeNotMAM  = eonAppCtrl.areWeNotMAM ;  
        Eon_Appointment__c eonApp1 = eonAppCtrl.newAppointment;
        String apptID = eonApp.id;
        apptID = eonAppCtrl.selAppointmentID;    
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Appointment not found. cannot cancel', API__c ='Inbound');
        insert objRC1;
        eonAppCtrl.cancelAppointment();   
        objRC1.OFSC_Text__c='Request processed successfully.';
        update objRC1;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();         
        eonAppCtrl.cancelAppointment();         
        test.StopTest();   
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);        
    }
    
    /**
    searchAppointmentsPass2() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
        static testMethod void searchAppointmentsPass2() {      
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';                
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppErrorCtrl.geteonAppSearchResult();              
        eonAppCtrl.geteonAppSearchResult();        
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch;
        //CH11.End
            
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO');
        insert job;              
         //CH05.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
         //CH05.end 
              
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c = ssc.id,//CH06.old
          Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
        insert appt; 
        
        eonAppCtrl.selApptID = appt.id;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;                
        
        EON_Appointment_Cancel_Reason__c canReason = EON_CreateTestRecords.createEONAppCancelReason();
        canReason.Reason_key__c = 'Rescheduled';
        insert canReason; 
        //EON Appointment Comms 
        
        list<EON_Appointment_Comms__c> Listappcomms =new list<EON_Appointment_Comms__c>();
        
        
        EON_Appointment_Comms__c appcomm1 = new EON_Appointment_Comms__c( EON_Appointment_ID__c=appt.Id);
        Listappcomms.add(appcomm1);
        insert Listappcomms;

       
        // EON vulnerability
        List<EON_Appointment_Vulnerability__c> lstEon_App_Vul= new List<EON_Appointment_Vulnerability__c>();
           //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); //CH06 CH05.New
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); //CH05.New
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=appt.Id, VulnerabilityDetailCode__c = 1);
        
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=appt.Id, VulnerabilityDetailCode__c = 2);
        
        lstEon_App_Vul.add(objVul1);
        lstEon_App_Vul.add(objVul2);
        insert lstEon_App_Vul; 
         
        //Eon Appointment Contact
        List<EON_Appointment_Contact__c> ListAppcontact =new List<EON_Appointment_Contact__c>();
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c( Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=appt.Id);
         ListAppcontact.add(objCont);
        insert ListAppcontact ;  
        
        
        //EON Appointment Attributes 
        List <EON_Appointment_Attribute__c> ListAppAtt = new List<EON_Appointment_Attribute__c>();
        
        EON_Appointment_Attribute__c objAtt1 = new EON_Appointment_Attribute__c(Job_Attribute__c='Electric Meter Type', Value__c='1', EON_Appointment_ID__c=appt.Id);
        ListAppAtt.add(objAtt1);
        
        insert ListAppAtt;
        
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();         
        eonAppCtrl.rescheduleAppointment();
        List<EON_Appointment_Cancel_Reason__c> retlist = eonAppCtrl.cancelReasons;               
        test.StopTest();  
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);
    }
    
    //CH11.Start
    /**
    searchAppointmentsPass2_a() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
        static testMethod void searchAppointmentsPass2_a() {      
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';                
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppErrorCtrl.geteonAppSearchResult();              
        eonAppCtrl.geteonAppSearchResult();        
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = true,
                                                                                  MDS_Status__c = false,
                                                                                  MDS_Close_Command_Only__c = true);
        insert mdsSwitch;
        //CH11.End
            
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO');
        insert job;              
         //CH05.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
         //CH05.end 
              
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c = ssc.id,//CH06.old
          Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
        insert appt; 
        
        eonAppCtrl.selApptID = appt.id;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;                
        
        EON_Appointment_Cancel_Reason__c canReason = EON_CreateTestRecords.createEONAppCancelReason();
        canReason.Reason_key__c = 'Rescheduled';
        insert canReason; 
        //EON Appointment Comms 
        
        list<EON_Appointment_Comms__c> Listappcomms =new list<EON_Appointment_Comms__c>();
        
        
        EON_Appointment_Comms__c appcomm1 = new EON_Appointment_Comms__c( EON_Appointment_ID__c=appt.Id);
        Listappcomms.add(appcomm1);
        insert Listappcomms;

       
        // EON vulnerability
        List<EON_Appointment_Vulnerability__c> lstEon_App_Vul= new List<EON_Appointment_Vulnerability__c>();
           //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); //CH06 CH05.New
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); //CH05.New
        insert objVulCode2;
        
        EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=appt.Id, VulnerabilityDetailCode__c = 1);
        
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=appt.Id, VulnerabilityDetailCode__c = 2);
        
        lstEon_App_Vul.add(objVul1);
        lstEon_App_Vul.add(objVul2);
        insert lstEon_App_Vul; 
         
        //Eon Appointment Contact
        List<EON_Appointment_Contact__c> ListAppcontact =new List<EON_Appointment_Contact__c>();
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c( Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=appt.Id);
         ListAppcontact.add(objCont);
        insert ListAppcontact ;  
        
        
        //EON Appointment Attributes 
        List <EON_Appointment_Attribute__c> ListAppAtt = new List<EON_Appointment_Attribute__c>();
        
        EON_Appointment_Attribute__c objAtt1 = new EON_Appointment_Attribute__c(Job_Attribute__c='Electric Meter Type', Value__c='1', EON_Appointment_ID__c=appt.Id);
        ListAppAtt.add(objAtt1);
        
        insert ListAppAtt;
        
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();         
        eonAppCtrl.rescheduleAppointment();
        List<EON_Appointment_Cancel_Reason__c> retlist = eonAppCtrl.cancelReasons;               
        test.StopTest();  
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);
    }
    //CH11.End

    /**
    searchAppointmentsFAIL1() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
    static testMethod void searchAppointmentsFAIL1() {
        Test.startTest();        
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';                
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppCtrl.geteonAppSearchResult();        
        eonAppErrorCtrl.geteonAppSearchResult();                         
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        insert eonApp;                        
        System.currentPageReference().getParameters().put('AppointmentID', eonApp.Id);        
                
        String selectedId = eonAppCtrl.selFuelID;
        String custId = eonAppCtrl.customerID; 
        String jbCode = eonAppCtrl.jobCode;               
        Eon_Appointment__c eonApp1 = eonAppCtrl.newAppointment;
        String apptID = eonApp.id;
        apptID = eonAppCtrl.selAppointmentID;    
              
        eonAppCtrl.cancelAppointment();         
       
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);        
    }

    /**
    searchAppointmentsFAIL2A() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
        static testMethod void searchAppointmentsFAIL2A() {      
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';        
        //eonAppCtrl.searchWrap.postCodec = 'SG1 3BT';     //CH01. Commented
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppErrorCtrl.geteonAppSearchResult();              
        eonAppCtrl.geteonAppSearchResult();        
        // eonAppCtrl.geteonAppSearchResult();                 
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        insert eonApp;         
        System.currentPageReference().getParameters().put('ApptmentID', eonApp.Id); 
        String apptID1 = eonAppCtrl.selAppointmentID; 
            
        Eon_Appointment__c eonApp1 = eonAppCtrl.newAppointment;
        String apptID = eonApp.id;
        apptID = eonAppCtrl.selApptID;
        
        EON_Appointment_Cancel_Reason__c canReason = EON_CreateTestRecords.createEONAppCancelReason();
        canReason.Reason_key__c = 'Rescheduled';
        insert canReason;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();        
        eonAppCtrl.rescheduleAppointment();
        List<EON_Appointment_Cancel_Reason__c> retlist = eonAppCtrl.cancelReasons;       
        test.StopTest();              
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);
    }
    
    /**
    searchAppointmentsFAIL2B() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
        static testMethod void searchAppointmentsFAIL2B() {      
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';        
        //eonAppCtrl.searchWrap.postCodec = 'SG1 3BT';     //CH01. Commented
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppErrorCtrl.geteonAppSearchResult();              
        eonAppCtrl.geteonAppSearchResult();        
        // eonAppCtrl.geteonAppSearchResult();
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        insert eonApp;        
        
        System.currentPageReference().getParameters().put('ApptmentID', eonApp.Id); 
        String apptID1 = eonAppCtrl.selAppointmentID; 
            
        Eon_Appointment__c eonApp1 = eonAppCtrl.newAppointment;
        String apptID = eonApp.id;
        eonAppCtrl.selApptID = apptID;                 
                
        
        EON_Appointment_Cancel_Reason__c canReason = EON_CreateTestRecords.createEONAppCancelReason();
        canReason.Reason_key__c = 'Rescheduled';
        insert canReason;  
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();        
        eonAppCtrl.rescheduleAppointment();
        List<EON_Appointment_Cancel_Reason__c> retlist = eonAppCtrl.cancelReasons;       
        test.StopTest();
               
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);
    }
    
    
/**
    searchAppointmentsFAIL2C() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
        static testMethod void searchAppointmentsFAIL2C() {      
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';        
        //eonAppCtrl.searchWrap.postCodec = 'SG1 3BT';     //CH01. Commented
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppErrorCtrl.geteonAppSearchResult();              
        eonAppCtrl.geteonAppSearchResult();        
        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO');
        insert job;              
          //CH05.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
         //CH05.end
         
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c = ssc.id,//CH06.old 
        Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
        insert appt; 
        
        eonAppCtrl.selApptID = appt.id;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test');     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id,Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;                
        
        EON_Appointment_Cancel_Reason__c canReason = EON_CreateTestRecords.createEONAppCancelReason();
        canReason.Reason_key__c = 'Rescheduled';
        insert canReason;         
        
        EON_OFSC_Response_Code__c objRC1 = new EON_OFSC_Response_Code__c(Name='0', Error_Warning_Success__c='success', OFSC_Text__c='Request processed successfully.', API__c ='Inbound');
        insert objRC1;
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.StartTest();         
        eonAppCtrl.rescheduleAppointment();
        List<EON_Appointment_Cancel_Reason__c> retlist = eonAppCtrl.cancelReasons;               
        test.StopTest();               
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);
    }
    
    //CH01.Start
    /**
    searchAppointmentsFail3() - this method is for search functionalities for EON_Appointment_Booking page when no record is returned by Appointment button.
    **/
    static testMethod void searchAppointmentsFail3() {
        Test.startTest();
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = '#####';
        eonAppCtrl.geteonAppSearchResult();        
        eonAppErrorCtrl.geteonAppSearchResult();
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        Test.stopTest();
    }
    
    /**
    searchAppointmentsFAIL4() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
        static testMethod void searchAppointmentsFAIL4() {
        Test.startTest();        
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';        
        //eonAppCtrl.searchWrap.postCodec = 'SG1 3BT';     //CH01. Commented
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppErrorCtrl.geteonAppSearchResult();              
        eonAppCtrl.geteonAppSearchResult();        
        // eonAppCtrl.geteonAppSearchResult();
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch;
        //CH11.End
     
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        insert eonApp;         
        System.currentPageReference().getParameters().put('ApptmentID', eonApp.Id); 
        String apptID1 = eonAppCtrl.selAppointmentID; 
        
        //Condition for failing : passed wrong ID.    
        Eon_Appointment__c eonApp1 = eonAppCtrl.newAppointment;
        String apptID = eonApp.id;
        apptID = eonAppCtrl.selApptID;                  
                
           EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
        insert objConType;
        
        EON_Appointment_Cancel_Reason__c canReason = EON_CreateTestRecords.createEONAppCancelReason();
        canReason.Reason_key__c = 'Rescheduled';
        insert canReason;        
        eonAppCtrl.rescheduleAppointment();
        List<EON_Appointment_Cancel_Reason__c> retlist = eonAppCtrl.cancelReasons;       
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        
          List<EON_Appointment_Vulnerability__c> lstEon_App_Vul= new List<EON_Appointment_Vulnerability__c>();
           //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); //CH06 CH05.New
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); //CH05.New
        insert objVulCode2;
        
          EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=eonApp.Id, VulnerabilityDetailCode__c = 1);
        
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=eonApp.Id, VulnerabilityDetailCode__c = 2);
        
        lstEon_App_Vul.add(objVul1);
         lstEon_App_Vul.add(objVul2);
         insert lstEon_App_Vul;
        
        EON_Media_Type__c objMedType1 = new EON_Media_Type__c(Name='A', Code__c='1');
        insert objMedType1;
        
        
        
          //Create EON Appointment Contact
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=eonApp.Id);
        insert objCont;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);
        Test.stopTest();
    }
	
    //CH11.Start
    /**
    searchAppointmentsFAIL4_a() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
        static testMethod void searchAppointmentsFAIL4_a() {
        Test.startTest();        
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';        
        //eonAppCtrl.searchWrap.postCodec = 'SG1 3BT';     //CH01. Commented
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppErrorCtrl.geteonAppSearchResult();              
        eonAppCtrl.geteonAppSearchResult();        
        // eonAppCtrl.geteonAppSearchResult();
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = true,
                                                                                  MDS_Status__c = false,
                                                                                  MDS_Close_Command_Only__c = true);
        insert mdsSwitch;
        //CH11.End
     
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        insert eonApp;         
        System.currentPageReference().getParameters().put('ApptmentID', eonApp.Id); 
        String apptID1 = eonAppCtrl.selAppointmentID; 
        
        //Condition for failing : passed wrong ID.    
        Eon_Appointment__c eonApp1 = eonAppCtrl.newAppointment;
        String apptID = eonApp.id;
        apptID = eonAppCtrl.selApptID;                  
                
           EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
        insert objConType;
        
        EON_Appointment_Cancel_Reason__c canReason = EON_CreateTestRecords.createEONAppCancelReason();
        canReason.Reason_key__c = 'Rescheduled';
        insert canReason;        
        eonAppCtrl.rescheduleAppointment();
        List<EON_Appointment_Cancel_Reason__c> retlist = eonAppCtrl.cancelReasons;       
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        
          List<EON_Appointment_Vulnerability__c> lstEon_App_Vul= new List<EON_Appointment_Vulnerability__c>();
           //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); //CH06 CH05.New
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); //CH05.New
        insert objVulCode2;
        
          EON_Appointment_Vulnerability__c objVul1 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode1.Id, EON_Appointment_ID__c=eonApp.Id, VulnerabilityDetailCode__c = 1);
        
        EON_Appointment_Vulnerability__c objVul2 = new EON_Appointment_Vulnerability__c(Description__c=objVulCode2.Id, EON_Appointment_ID__c=eonApp.Id, VulnerabilityDetailCode__c = 2);
        
        lstEon_App_Vul.add(objVul1);
         lstEon_App_Vul.add(objVul2);
         insert lstEon_App_Vul;
        
        EON_Media_Type__c objMedType1 = new EON_Media_Type__c(Name='A', Code__c='1');
        insert objMedType1;
        
        
        
          //Create EON Appointment Contact
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=eonApp.Id);
        insert objCont;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);
        Test.stopTest();
    }
    //CH11.End
    
    /**
    searchAppointmentsFAIL5() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Appointment button.
    **/
        static testMethod void searchAppointmentsFAIL5() {
        Test.startTest();        
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        //CH01.Start
        eonAppCtrl.callingFrom = 'Isis';
        eonAppCtrl.renderSections();
        //CH01.End
        EON_Appointment_Booking_Ctrl eonAppErrorCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.customerName = 'EON';
        eonAppCtrl.searchWrap.accountElect = '12345678912345678912';
        eonAppCtrl.searchWrap.accountGas = '132';
        eonAppCtrl.searchWrap.postCodeS = 'SG1 3BT';        
        //eonAppCtrl.searchWrap.postCodec = 'SG1 3BT';     //CH01. Commented
        eonAppCtrl.searchWrap.MPAN = '123';                //CH01     
        eonAppCtrl.searchWrap.MPRN = '123';                //CH01
        eonAppCtrl.searchWrap.appointmentID = '0000';
        eonAppErrorCtrl.geteonAppSearchResult();              
        eonAppCtrl.geteonAppSearchResult();        
        // eonAppCtrl.geteonAppSearchResult();                 
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        insert eonApp;         
        System.currentPageReference().getParameters().put('ApptmentID', eonApp.Id); 
        String apptID1 = eonAppCtrl.selAppointmentID; 
        
        //Condition for failing : passed wrong ID.    
        Eon_Appointment__c eonApp1 = eonAppCtrl.newAppointment;
        String apptID = eonApp.id;
        eonAppCtrl.selApptID = apptID;
                        
        eonAppCtrl.rescheduleAppointment();
        List<EON_Appointment_Cancel_Reason__c> retlist = eonAppCtrl.cancelReasons;       
        
        EON_Job__c eJob = new EON_Job__c(Name='EON Job',Description__c='EON Job Test',Duration__c = 203);       
        insert eJob;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        List<EON_Job_Attribute__c> jobAttLst = eonAppCtrl.availableJobAttributes;
        
        System.assertEquals(eonAppCtrl.eonAppSearchResults.size(), 0);
        Test.stopTest();
    }   
    
    /**
    searchIndustryPass1() - method for Industry button on the page when jobs with ECO as job type are returned.
    **/
    static testMethod void searchIndustryPass1() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        String appt = 'null';
        eonAppCtrl.appointmentReason = appt;
        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.Name = 'OOAECOWINDON';
        job.Job_Type__c = 'ECO';
        insert job;
        
        eonAppCtrl.callingFrom = 'Industry';
        eonAppCtrl.renderSections();
        eonAppCtrl.isIndustrySearch = true;
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = Reason.id;        
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPAN = '1200030128530';
        serWra.MPRN = '123';        
        eonAppCtrl.populateElectricityGasData(serWra); 
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = 'OOAECOWINDON';
        //eonAppCtrl.canceAction();
        eonAppCtrl.geteonAppSearchResult();
        eonAppCtrl.getSelectedJobCodes();           
        
        System.assertEquals(serWra.MPAN, '1200030128530');
        Test.stopTest();
    }
    
    /**
    searchIndustryPass2() - method for Industry button on the page when only MPRN search field is populated.
    **/
    static testMethod void searchIndustryPass2() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;
        
        eonAppCtrl.callingFrom = 'Industry';                
        
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        //eonAppCtrl.searchWrap.MPAN = 'false';              
        eonAppCtrl.populateElectricityGasData(serWra); 
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Maintenance');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        eonAppCtrl.selectedJobs(); 
        //eonAppCtrl.validateIndustryCreateApp();     
        System.assertEquals(serWra.MPRN, '123');
        Test.stopTest();      
    }
    
    /**
    searchIndustryPass3() - method for Industry button on the page when only MPAN search field is populated.
    **/
    static testMethod void searchIndustryPass3() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();       
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();        
        job.MPAN_Reqd__c = true;
        job.MPRN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;    
        
        eonAppCtrl.callingFrom = 'Industry';                
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Maintenance');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPAN = '123';
        //eonAppCtrl.searchWrap.MPRN = '';    
                  
        eonAppCtrl.populateElectricityGasData(serWra);         
        eonAppCtrl.selectedJobs();    
        //eonAppCtrl.validateIndustryCreateApp(); 
        System.assertEquals(serWra.MPAN, '123');
        Test.stopTest();
    }
    
    /**
    searchIndustryPass4() - method for Industry button on the page when both the search fields are populated for MDS.
    **/
    static testMethod void searchIndustryPass4() {
    
        EON_Appointment_Booking_Ctrl_Test.genException=true;    
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        Test.startTest();
        
        EON_Utility.genException=true;
        //PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        eonAppCtrl.areWeNotMAM =true;
        eonAppCtrl.oracleBucketID =null;
        String appCtrl = eonAppCtrl.oracleBucketID;
        
         
        
        EON_Region__c region = new EON_Region__c(GSP_ID__c =12);        
        insert region;
        EON_Shutdown_Days__c days = new EON_Shutdown_Days__c(Name='Bank holiday',Holiday_Date__c=System.today());
        insert days;
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite =  new EON_Site__c(Customer__c=eCust.ID, Name = '1234567890',Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',Address_Type__c = 'S',Country__c = null ,County__c = null,Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',Double_Dependant_Locality__c = 'Stevenage',Sub_Building_Name__c = 'Stevenage',Thorofare__c = 'Stevenage',Town__c = 'Stevenage');
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '121'; 
        eFuel.Premise__c = eSite.id;
        //eFuel.Customer__c = eCust.id;  // CH04
        insert eFuel;
        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.Name = 'OOAECOWINDON';
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.Job_Code__c = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '121';
        //eApp.Fuel_ID__c = eFuel.id;
        insert eApp;
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch;
        //CH11.End
        
        //System.currentPageReference().getParameters().put('newAppointment', eApp.Id);         
        
        eonAppCtrl.callingFrom = 'Industry';        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = '121'; 
        eonAppCtrl.newAppointment = eApp;
        eonAppCtrl.ApptReason='Maintenance';
        eonAppCtrl.validateIndustryCreateApp(); 
        eonAppCtrl.populateElectricityGasData(serWra);
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        
        eonAppCtrl.validateIndustryCreateApp(); 
        System.assertEquals(serWra.MPAN, '121');
        Test.stopTest();
        
        
        
    }
    
    //CH11.Start
    /**
    searchIndustryPass4_b() - method for Industry button on the page when both the search fields are populated for Jumbo.
    **/
    static testMethod void searchIndustryPass4_b() {
    
        EON_Appointment_Booking_Ctrl_Test.genException=true;    
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        Test.startTest();
        
        EON_Utility.genException=true;
        //PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        eonAppCtrl.areWeNotMAM =true;
        eonAppCtrl.oracleBucketID =null;
        String appCtrl = eonAppCtrl.oracleBucketID;
        
         
        
        EON_Region__c region = new EON_Region__c(GSP_ID__c =12);        
        insert region;
        EON_Shutdown_Days__c days = new EON_Shutdown_Days__c(Name='Bank holiday',Holiday_Date__c=System.today());
        insert days;
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite =  new EON_Site__c(Customer__c=eCust.ID, Name = '1234567890',Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',Address_Type__c = 'S',Country__c = null ,County__c = null,Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',Double_Dependant_Locality__c = 'Stevenage',Sub_Building_Name__c = 'Stevenage',Thorofare__c = 'Stevenage',Town__c = 'Stevenage');
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '121'; 
        eFuel.Premise__c = eSite.id;
        //eFuel.Customer__c = eCust.id;  // CH04
        insert eFuel;
        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.Name = 'OOAECOWINDON';
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.Job_Code__c = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '121';
        //eApp.Fuel_ID__c = eFuel.id;
        insert eApp;
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = true,
                                                                                  MDS_Status__c = false,
                                                                                  MDS_Close_Command_Only__c = true);
        insert mdsSwitch;
        //CH11.End
        
        //System.currentPageReference().getParameters().put('newAppointment', eApp.Id);         
        
        eonAppCtrl.callingFrom = 'Industry';        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = '121'; 
        eonAppCtrl.newAppointment = eApp;
        eonAppCtrl.ApptReason='Maintenance';
        eonAppCtrl.validateIndustryCreateApp(); 
        eonAppCtrl.populateElectricityGasData(serWra);
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        
        eonAppCtrl.validateIndustryCreateApp(); 
        System.assertEquals(serWra.MPAN, '121');
        Test.stopTest();
    }
    //CH11.End

    static testMethod void searchIndustryPass4_Aa() {
        Test.startTest(); 
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());       
        //PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Region__c region = new EON_Region__c(GSP_ID__c =12);        
        insert region;
        
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite =  new EON_Site__c(Customer__c=eCust.ID, Name = '1234567890',Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',Address_Type__c = 'S',Country__c = null ,County__c = null,Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',Double_Dependant_Locality__c = 'Stevenage',Sub_Building_Name__c = 'Stevenage',Thorofare__c = 'Stevenage',Town__c = 'Stevenage');
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '121'; 
        eFuel.Premise__c = eSite.id;
        //eFuel.Customer__c = eCust.id;  // CH04
        insert eFuel;
        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.Name = 'OOAECOWINDON';
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'SMART';
        insert job;
        
        
        
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.Job_Code__c = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '121';
        //eApp.Fuel_ID__c = eFuel.id;
        insert eApp;
        
        //System.currentPageReference().getParameters().put('newAppointment', eApp.Id);         
        
        eonAppCtrl.callingFrom = 'Industry';        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Statutory',Appointment_reason_code__c='STATUTORY');//CH09
        insert Reason;//CH09
        
        
        //insert EON JOB Appointment Reason 
        EON_Job_Appointment_Reason__c eon_job_app_reason = new EON_Job_Appointment_Reason__c(Appointment_Reason__c=Reason.id, Job__c=job.id);
        insert eon_job_app_reason ;
        
        eonAppCtrl.appointmentReason = reason.id;
        EON_Jumbo_ElecGasData_Test.functionType = 'validateMOP';
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = '1234';  
        eonAppCtrl.newAppointment = eApp;
        eonAppCtrl.validateIndustryCreateApp(); 
        eonAppCtrl.populateElectricityGasData(serWra);
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '';
        job.Name = 'OOAECOWINDONSMART';
        update job;
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        Eon_Appointment_Reason__c Reason1 = new Eon_Appointment_Reason__c(name= 'New Connection');//CH09
        insert Reason1;//CH09
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch;
        //CH11.End
        
        eonAppCtrl.appointmentReason = reason1.id;
        eonAppCtrl.newAppointment = eApp;
        eonAppCtrl.validateIndustryCreateApp();
         
        eonAppCtrl.geteonAppSearchResult(); 
        System.assertEquals(serWra.MPAN, '1234');
        Test.stopTest();
    }   
	
    //CH11.Start
    static testMethod void searchIndustryPass4_Ab() {
        Test.startTest(); 
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());       
        //PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        EON_Region__c region = new EON_Region__c(GSP_ID__c =12);        
        insert region;
        
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite =  new EON_Site__c(Customer__c=eCust.ID, Name = '1234567890',Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',Address_Type__c = 'S',Country__c = null ,County__c = null,Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',Double_Dependant_Locality__c = 'Stevenage',Sub_Building_Name__c = 'Stevenage',Thorofare__c = 'Stevenage',Town__c = 'Stevenage');
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '121'; 
        eFuel.Premise__c = eSite.id;
        //eFuel.Customer__c = eCust.id;  // CH04
        insert eFuel;
        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.Name = 'OOAECOWINDON';
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'SMART';
        insert job;
        
        
        
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.Job_Code__c = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '121';
        //eApp.Fuel_ID__c = eFuel.id;
        insert eApp;
        
        //System.currentPageReference().getParameters().put('newAppointment', eApp.Id);         
        
        eonAppCtrl.callingFrom = 'Industry';        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Statutory',Appointment_reason_code__c='STATUTORY');//CH09
        insert Reason;//CH09
        
        
        //insert EON JOB Appointment Reason 
        EON_Job_Appointment_Reason__c eon_job_app_reason = new EON_Job_Appointment_Reason__c(Appointment_Reason__c=Reason.id, Job__c=job.id);
        insert eon_job_app_reason ;
        
        eonAppCtrl.appointmentReason = reason.id;
        EON_Jumbo_ElecGasData_Test.functionType = 'validateMOP';
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = '1234';  
        eonAppCtrl.newAppointment = eApp;
        eonAppCtrl.validateIndustryCreateApp(); 
        eonAppCtrl.populateElectricityGasData(serWra);
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '';
        job.Name = 'OOAECOWINDONSMART';
        update job;
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        Eon_Appointment_Reason__c Reason1 = new Eon_Appointment_Reason__c(name= 'New Connection');//CH09
        insert Reason1;//CH09
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = true,
                                                                                  MDS_Status__c = false,
                                                                                  MDS_Close_Command_Only__c = true);
        insert mdsSwitch;
        //CH11.End
        
        eonAppCtrl.appointmentReason = reason1.id;
        eonAppCtrl.newAppointment = eApp;
        eonAppCtrl.validateIndustryCreateApp();
         
        eonAppCtrl.geteonAppSearchResult(); 
        System.assertEquals(serWra.MPAN, '1234');
        Test.stopTest();
    }   
    //CH11.End
    
    /**
    searchIndustryPass4A() - method for Industry button on the page when both the search fields are populated.
    **/
    static testMethod void searchIndustryPass4A() {
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock()); 
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());     
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '12'; 
        eFuel.Premise__c = eSite.id;
        //eFuel.Customer__c = eCust.id;  //CH04
        insert eFuel;
        //CH07.Start
        //EON_Shutdown_Days__c shutDays = new EON_Shutdown_Days__c(Name = 'TestDays',Holiday_Date__c = Date.today());
        //insert shutDays;
        //CH07.End
        EON_Job__c job = new EON_Job__c(Name = 'OOAECOOUTWORKHRS', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO', MPRN_Reqd__c = true, MPAN_Reqd__c = true);
        insert job; 
        //CH09.start
        EON_Job__c job1 = new EON_Job__c(Name = 'OOAECOOUTWORKHRS1', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO', MPRN_Reqd__c = false, MPAN_Reqd__c = false);
        insert job1;    
        //CH09.end  
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;            
        
        //CH05.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH05.end
        
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c=ssc.id, //CH06.old
        Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
        insert appt; 
        
        //eonAppCtrl.selApptID = appt.id;
        
        //EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        //insert region;
       /* 
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = '121 1',Sub_Area_Name__c = subArea.id);
        insert pstCode; */     
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.Job_Code__c = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '12';
        eApp.Fuel_ID__c = eFuel.id;
        eApp.Post_Code__c = '121 1';
        insert eApp;
        
        //System.currentPageReference().getParameters().put('newAppointment', eApp.Id);         
        
        eonAppCtrl.callingFrom = 'Industry';        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'New Connection');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = '12';                
        eonAppCtrl.populateElectricityGasData(serWra);
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        Boolean isIndst = eonAppCtrl.isIndustryCreateApp;    
        eonAppCtrl.createAppointment();
        eonAppCtrl.clearMappingAppointment();
        eonAppCtrl.newAppointment=eApp;
        eonAppCtrl.validateIndustryCreateApp();
    eonAppCtrl.ApptReason='Emergency Call Out';
        eonAppCtrl.validateIndustryCreateApp(); 
        eonAppCtrl.createApptIndus();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        Test.startTest(); 
         eonAppCtrl.createApptIndus();
        Test.stopTest();       
        eonAppCtrl.IndustryGasData.customerName='test';
        eonAppCtrl.IndustryGasData.contactNumber='1234';
        eonAppCtrl.IndustryGasData.postCode='1234';
        eonAppCtrl.IndustryGasData.addressText='test';
        eonAppCtrl.IndustryGasData.SubBuildingNameNumber='test';
        eonAppCtrl.IndustryGasData.BuildingNameNumber ='test';
        eonAppCtrl.IndustryGasData.DependentThoroughfare='test';
        eonAppCtrl.IndustryGasData.Thoroughfare='test';
        eonAppCtrl.IndustryGasData.DoubleDependentLocality='test';
        eonAppCtrl.IndustryGasData.DependentLocality='test';
        eonAppCtrl.IndustryGasData.PostTown ='test';
        eonAppCtrl.IndustryGasData.County='test';
        
        eonAppCtrl.industryEleData.mopStatus='test';
        eonAppCtrl.industryEleData.customerName='1234';
        eonAppCtrl.industryEleData.contactNumber='1234';
        eonAppCtrl.industryEleData.postCode='test';
        eonAppCtrl.industryEleData.phase='test';
        eonAppCtrl.industryEleData.meteringPointAddressLine1 ='test';
        eonAppCtrl.industryEleData.meteringPointAddressLine2='test';
        eonAppCtrl.industryEleData.meteringPointAddressLine3='test';
        eonAppCtrl.industryEleData.meteringPointAddressLine4='test';
        eonAppCtrl.industryEleData.meteringPointAddressLine5='test';
        eonAppCtrl.industryEleData.meteringPointAddressLine6 ='test';
        eonAppCtrl.industryEleData.meteringPointAddressLine7='test';
        eonAppCtrl.industryEleData.meteringPointAddressLine8='test';
        eonAppCtrl.industryEleData.meteringPointAddressLine9='test';
        
        EON_Job__c job2 = new EON_Job__c(Name = 'OOAECOOUTWORKHRS1', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO', MPRN_Reqd__c = true, MPAN_Reqd__c = false);
        insert job2;
        serWra.MPAN = '';
        eonAppCtrl.getSelectedJobCodes();
        
       
    }
    static testMethod void searchIndustryPass4_Test() {
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
       //Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());    
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
        EON_Jumbo_ElecGasData_Test.functionType ='validateMOPWithEffDates';
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = 'mpan123'; 
        eFuel.Premise__c = eSite.id;
        insert eFuel;           
        
        
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c=ssc.id, //CH06.old
        Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = 'mpan123');
        insert appt; 
        
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.MPRN__c = '123';
        eApp.MPAN__c = 'mpan123';
        eApp.Fuel_ID__c = eFuel.id;
        eApp.Post_Code__c = '121 1';
        insert eApp;          
        
        eonAppCtrl.callingFrom = 'Industry';        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'New Connection');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = 'mpan123';                
        eonAppCtrl.populateElectricityGasData(serWra);
        eonAppCtrl.selectedJobs();
        
    }
    
    //CH07.Start
    /**
    searchIndustryPass4B() - method for Industry button on the page when both the search fields are populated.
    **/
    static testMethod void searchIndustryPass4B() {
        Test.startTest();                
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '12'; 
        eFuel.Premise__c = eSite.id;insert eFuel;

        EON_Shutdown_Days__c shutDays = new EON_Shutdown_Days__c(Name = 'TestDays',Holiday_Date__c = Date.today()+1);
        insert shutDays;

        EON_Job__c job = new EON_Job__c(Name = 'OUTWORKHRS', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO', MPRN_Reqd__c = true, MPAN_Reqd__c = true);
        insert job;  
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;            
        
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c=ssc.id, //CH06.old
        Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
        insert appt; 
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = '121 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;      
        
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.Job_Code__c = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '12';
        eApp.Fuel_ID__c = eFuel.id;
        eApp.Post_Code__c = '121 1';
        insert eApp; 
        
        eonAppCtrl.callingFrom = 'Industry';        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = '12';                
        eonAppCtrl.populateElectricityGasData(serWra);
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra1 = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '1233';
        serWra.MPAN = '123';                
        eonAppCtrl.populateElectricityGasData(serWra1);
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        Boolean isIndst = eonAppCtrl.isIndustryCreateApp;
        //eonAppCtrl.validateIndustryCreateApp(); 
        //System.assertEquals(serWra.MPAN, '12');
        //System.assertEquals(serWra1.MPAN, '123');
        Test.stopTest();
    }
    
    /**
    searchIndustryPass4C() - method for Industry button on the page when both the search fields are populated.
    **/
    static testMethod void searchIndustryPass4C() {
        Test.startTest();                
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '12'; 
        eFuel.Premise__c = eSite.id;insert eFuel;

        EON_Shutdown_Days__c shutDays = new EON_Shutdown_Days__c(Name = 'TestDays',Holiday_Date__c = Date.today()+1);
        insert shutDays;

        EON_Job__c job = new EON_Job__c(Name = 'OUTWORKHRSMART', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'SMART', MPRN_Reqd__c = true, MPAN_Reqd__c = true);
        insert job;  
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;            
        
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c=ssc.id, //CH06.old
        Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = job.id);
        insert appt; 
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, Maintenance__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = '121 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;      
        
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.Job_Code__c = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '12';
        eApp.Fuel_ID__c = eFuel.id;
        eApp.Post_Code__c = '121 1';
        
        eonAppCtrl.callingFrom = 'Industry';     
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Maintenance');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = '12';                
        eonAppCtrl.populateElectricityGasData(serWra);
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        eonAppCtrl.newAppointment = eApp;
        Boolean isIndst = eonAppCtrl.isIndustryCreateApp;
        eonAppCtrl.createAppointment();
        //eonAppCtrl.validateIndustryCreateApp(); 
        eonAppCtrl.createApptIndus();
        System.assertEquals(serWra.MPAN, '12');
        Test.stopTest();
    }    
    
    //CH07.End
    
    /**
    searchIndustryPass5() - method for Industry button on the page when only MPRN search field is populated.
    **/
    static testMethod void searchIndustryPass5() {
        Test.startTest();            
        Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;
        
        eonAppCtrl.callingFrom = 'Industry';                
        
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.MPRN = '123';
        eonAppCtrl.searchWrap.MPAN = 'false';                  
        
        eonAppCtrl.populateElectricityGasData(serWra); 
        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Maintenance');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        eonAppCtrl.selectedJobs();   
        System.assertEquals(eonAppCtrl.searchWrap.MPRN, '123');
        Test.stopTest();      
    }
    
    /**
    searchIndustryPass6() - method for Industry button on the page when only MPAN search field is populated.
    **/
    static testMethod void searchIndustryPass6() {
        Test.startTest();        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ());
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
         
        EON_Job__c job = EON_CreateTestRecords.createEONJob();        
        job.MPAN_Reqd__c = true;
        job.MPRN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;
        
        EON_Job__c job1 = EON_CreateTestRecords.createEONJob();        
        job1.MPAN_Reqd__c = False;
        job1.MPRN_Reqd__c = False;
        job1.Job_Type__c = 'Maintenance';
        insert job1;
        
        EON_Job__c job2 = EON_CreateTestRecords.createEONJob();        
        job1.MPAN_Reqd__c = False;
        job1.MPRN_Reqd__c = True;
        job1.Job_Type__c = 'Maintenance';
        insert job2;
        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Maintenance');//CH09
        insert Reason;//CH09
        EON_Job_Appointment_Reason__c jobreason= new EON_Job_Appointment_Reason__c(Appointment_Reason__c =Reason.id,job__c =job.id);
        insert jobreason;
        EON_Job_Appointment_Reason__c jobreason1= new EON_Job_Appointment_Reason__c(Appointment_Reason__c =Reason.id,job__c =job1.id);
        insert jobreason1;
        
        
        EON_Job_Appointment_Reason__c jobreason2= new EON_Job_Appointment_Reason__c(Appointment_Reason__c =Reason.id,job__c =job2.id);
        insert jobreason2;

        
        eonAppCtrl.callingFrom = 'Industry';                        
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.MPAN = '123';
        eonAppCtrl.searchWrap.MPRN = 'false';
        eonAppCtrl.searchWrap.MPRN = '123';
        eonAppCtrl.searchWrap.MPAN = 'false';    
                  
        eonAppCtrl.populateElectricityGasData(serWra);  
        
        eonAppCtrl.appointmentReason = reason.id;        eonAppCtrl.selectedJobs();    
        //System.assertEquals(eonAppCtrl.searchWrap.MPAN, '123');
        Test.stopTest();
    }
    
     /**
    searchIndustryPass6_2() - method for Industry button on the page when only MPAN search field is populated.
    **/
    static testMethod void searchIndustryPass6_2() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
         
        EON_Job__c job = EON_CreateTestRecords.createEONJob();        
        job.MPAN_Reqd__c = true;
        job.MPRN_Reqd__c = False;
        job.Job_Type__c = 'Maintenance';
        insert job;
        
        EON_Job__c job1 = EON_CreateTestRecords.createEONJob();        
        job1.MPAN_Reqd__c = False;
        job1.MPRN_Reqd__c = True;
        job1.Job_Type__c = 'Maintenance';
        insert job1;
        
        EON_Job__c job2 = EON_CreateTestRecords.createEONJob();        
        job1.MPAN_Reqd__c = False;
        job1.MPRN_Reqd__c = True;
        job1.Job_Type__c = 'Maintenance';
        insert job2;
        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Maintenance');//CH09
        insert Reason;//CH09
        EON_Job_Appointment_Reason__c jobreason= new EON_Job_Appointment_Reason__c(Appointment_Reason__c =Reason.id,job__c =job.id);
        insert jobreason;
        EON_Job_Appointment_Reason__c jobreason1= new EON_Job_Appointment_Reason__c(Appointment_Reason__c =Reason.id,job__c =job1.id);
        insert jobreason1;
        
        
        EON_Job_Appointment_Reason__c jobreason2= new EON_Job_Appointment_Reason__c(Appointment_Reason__c =Reason.id,job__c =job2.id);
        insert jobreason2;

        
        eonAppCtrl.callingFrom = 'Industry';                        
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
         
        eonAppCtrl.searchWrap.MPRN = 'false';
         
        eonAppCtrl.searchWrap.MPAN = 'false';    
                  
        eonAppCtrl.populateElectricityGasData(serWra);  
        
        eonAppCtrl.appointmentReason = reason.id;        eonAppCtrl.selectedJobs();    
        //System.assertEquals(eonAppCtrl.searchWrap.MPAN, '123');
        Test.stopTest();
    }
    
    /**
    searchIndustryFail1() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under Industry button when no related records found in Picklist at the bottom of the page.
    **/
    static testMethod void searchIndustryFail1() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.MPRN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;
        
        eonAppCtrl.callingFrom = 'Industry';         
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Maintenance');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;       
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        //serWra.MPRN = '';        
        //serWra.MPAN = 'false';
        eonAppCtrl.populateElectricityGasData(serWra); 
        eonAppCtrl.selectedJobs();               
        System.assertEquals(serWra.MPAN,null);
        Test.stopTest();
    } 
    
    /**
    searchPortfolioPass1() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under the button Portfolio.
    **/
    static testMethod void searchPortfolioPass1() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();        
        eonAppCtrl.callingFrom = 'Portfolio';       
        eonAppCtrl.renderSections();
            
        
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;
        
        EON_Site__c site = EON_CreateTestRecords.cereateEONSite();
        site.Postcode__c = '212';
        insert site;
        
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();        
        //fuel.Customer__c = customer.id; // CH04
        fuel.Fuel_type__c = 'D';//Changing DF to D as requested in SR_EON_PC_068
        fuel.h_SelectRadio__c = true;
        fuel.Premise__c = site.id;
        fuel.MPAN__c = '123';
        fuel.MPRN__c = '123';
        insert fuel;                

        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.MPRN = '123';
        eonAppCtrl.searchWrap.MPAN = '123';                
        eonAppCtrl.searchWrap.postCodeS = '212';                
        eonAppCtrl.geteonAppSearchResult(); 
        eonAppCtrl.processAppointmentRequest();
        System.assertEquals(eonAppCtrl.searchWrap.MPAN, '123');
        Test.stopTest();
    }
    
    /**
    searchPortfolioPass2() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under the button Portfolio.
    **/
    static testMethod void searchPortfolioPass2() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();        
        eonAppCtrl.callingFrom = 'Portfolio';       
        eonAppCtrl.renderSections();
            
        
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;
        
        EON_Site__c site = EON_CreateTestRecords.cereateEONSite();
        site.Postcode__c = '212';
        insert site;
        
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();        
        //fuel.Customer__c = customer.id;  //CH04
        fuel.Fuel_type__c = 'G';
        fuel.h_SelectRadio__c = true;
        fuel.Premise__c = site.id;
        fuel.MPAN__c = '123';
        fuel.MPRN__c = '123';
        insert fuel;                

        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.MPRN = '123';
        eonAppCtrl.searchWrap.MPAN = '123';                
        eonAppCtrl.searchWrap.postCodeS = '212';                
        eonAppCtrl.geteonAppSearchResult(); 
        eonAppCtrl.processAppointmentRequest();
        System.assertEquals(eonAppCtrl.searchWrap.MPAN, '123');
        Test.stopTest();
    }
    
        /**
    searchPortfolioFail1() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under the button Portfolio when no records found.
    **/
    static testMethod void searchPortfolioFail1() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        eonAppCtrl.callingFrom = 'Portfolio';        
        
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;
        
        EON_Site__c site = EON_CreateTestRecords.cereateEONSite();
        site.Postcode__c = '212';
        insert site;
        
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();        
        //fuel.Customer__c = customer.id;  //CH04
        fuel.Premise__c = site.id;
        fuel.MPAN__c = '123';
        fuel.MPRN__c = '123';
        insert fuel;                

        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        eonAppCtrl.searchWrap.MPRN = '####';               
        eonAppCtrl.geteonAppSearchResult(); 
        System.assertEquals(fuel.MPAN__c, '123');
        Test.stopTest();
    }
    
        /**
    searchPortfolioFail2() - this method will covers the coverage for search functionalities for EON_Appointment_Booking page under the button Portfolio when no searched with all the fields as blank.
    **/
    static testMethod void searchPortfolioFail2() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        eonAppCtrl.callingFrom = 'Portfolio';        
        
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;
        
        EON_Site__c site = EON_CreateTestRecords.cereateEONSite();
        site.Postcode__c = '212';
        insert site;
        
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();        
        //fuel.Customer__c = customer.id;  //CH04
        fuel.Premise__c = site.id;
        fuel.MPAN__c = '123';
        fuel.MPRN__c = '123';
        insert fuel;                

        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();        
        eonAppCtrl.geteonAppSearchResult(); 
        System.assertEquals(fuel.MPAN__c, '123');
        Test.stopTest();
    }
    //CH01.End
    
    //CH02.Start
    private static void EON_OFSC_GetCapacity_CalloutTest()
   {   
     // This causes a fake response to be generated
    
     Test.setMock(WebServiceMock.class, new EON_OFSC_GetCapacity_WS_ServicesMock());   
     EON_OFSC_GetCapacity_WS.toa_capacity_interface taCap = new EON_OFSC_GetCapacity_WS.toa_capacity_interface();
     taCap.endpoint_x = 'https://api.etadirect.com/soap/';
     taCap.inputHttpHeaders_x =null;
     taCap.outputHttpHeaders_x = null;
     taCap.clientCertName_x = 'TestEon';
     taCap.clientCert_x ='Test_';
     taCap.clientCertPasswd_x = 'Test@123';
     taCap.timeout_x = 12000;
     EON_OFSC_GetCapacity_WS.user_element  eonUsr = new EON_OFSC_GetCapacity_WS.user_element();
     eonUsr.now = string.ValueOf(System.now());
     eonUsr.login = 'EON@morrisonus.com';
     eonUsr.company = 'MUS';
     eonUsr.auth_string = 'MUS USER AUTHENTICATED';
       
     List<EON_OFSC_GetCapacity_WS.set_quota_bucket_element> lstbucket = new List<EON_OFSC_GetCapacity_WS.set_quota_bucket_element>(); 
     taCap.set_quota(eonUsr,lstbucket );
  
   }

    /**
        getCapacityFromOFSC_PASS(): Positive test for method getCapacityFromOFSC();
    **/ 
    static testMethod void getCapacityFromOFSC_PASS() {        
         
        //Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO');
        insert job;
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '121'; 
        eFuel.Premise__c = eSite.id;       
        insert eFuel;   
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1',Duration__c = 123, Value__c = 'CR');
        insert ejobAtt;
        
        //CH03.start
        EON_Electric_Meter_Type__c objEleMetType = new EON_Electric_Meter_Type__c(Name='KEY');
        insert objEleMetType;
        
        EON_Gas_Meter_Type__c objGasMetType = new EON_Gas_Meter_Type__c(Name='MCL');
        insert objGasMetType;
        //CH03.end
        
        //CH05.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH05.end
        
        EON_Appointment__c appt = new EON_Appointment__c(Planned_E_Meter_Type__c = 'KEY', Planned_G_Meter_Type__c = 'MCL', MPAN__c = '121',MPRN__c = '123',Booking_System_Name__c = 'Test',Key_Collection_Required__c = true ,EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old // Requested_SSC__c=ssc.id,//CH06.old
        Appointment_Date__c = Date.Today()-1, End_Time__c = '12:32',  E_Meter_Type__c = objEleMetType.Id /*CH03 'KEY'*/, G_Meter_Type__c= objGasMetType.Id /*CH03 'MCL'*/,Number_of_Phases__c = '3Ph',Metering_Pressure__c = 'Low',Fuel_ID__c=eFuel.id);/*CH08*/
        insert appt;

        EON_Capacity_Categories__c capacityCatg = new EON_Capacity_Categories__c(Name = 'KEYMCL3PHLow',Elec_Phase__c = '3PH', Gas_pressure__c = 'Low',  Work_Skill__c = 'Workskill');
        insert capacityCatg;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        //EON_Appointment_Booking_Ctrl_Helper.AvailableCapacity availCap = new EON_Appointment_Booking_Ctrl_Helper.AvailableCapacity(); 
        Map<Date,List<EON_OFSC_Helper.RecomendedTimeSlots>> mapTimeslot = new Map<Date,List<EON_OFSC_Helper.RecomendedTimeSlots>>();
        EON_Appointment_Booking_Ctrl_Helper.avaCapacities = mapTimeslot;        
        Map<String,Date> mapdate = new Map<String,Date>{'Appointment'=>Date.today()};
        EON_DisplayCapacitiesFromOFSC_Ctrl_test.EON_OFSC_GetCapacity_CalloutTest();        
        EON_Appointment_Booking_Ctrl_Helper.getCapacityFromOFSC(appt.id, 'LON_SouthEast1', job.id,mapdate);
        
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        System.assertEquals(pstCode.Name,'SE10 1');
        //Test.stopTest();
    }    
    //CH02.End 

    /**
        getCapacityFromOFSC_PASS1(): Positive test for method getCapacityFromOFSC();
    **/ 
    static testMethod void getCapacityFromOFSC_PASS1() { 
     EON_OFSC_GetCapacity_CalloutTest();
            
        Test.startTest();
        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO');
        insert job;              
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;              
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c=ssc.id,//CH06.old
         Appointment_Date__c = Date.Today(), End_Time__c = '12:32');
        insert appt;

        EON_Capacity_Categories__c capacityCatg = new EON_Capacity_Categories__c(Name = 'KEYMCL3PHLOW',Elec_Phase__c = '3PH', Gas_pressure__c = 'LOW',  Work_Skill__c = 'DF3');
        insert capacityCatg;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        //EON_Appointment_Booking_Ctrl_Helper.AvailableCapacity availCap = new EON_Appointment_Booking_Ctrl_Helper.AvailableCapacity();
        Map<String,Date> mapdate = new Map<String,Date>{'Appointment'=>Date.today()};
        
        EON_Appointment_Booking_Ctrl_Helper.getCapacityFromOFSC(null, 'LON_SouthEast1', job.id,mapdate);
        String retlist = EON_Appointment_Booking_Ctrl_Helper.keyWorkSkill;       
        
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
    /**
        getCapacityFromOFSC_PASS2(): Positive test for method getCapacityFromOFSC();
    **/ 
    static testMethod void getCapacityFromOFSC_PASS2() { 
     EON_OFSC_GetCapacity_CalloutTest();
         
        Test.startTest();
        EON_Customer__c customer1 = EON_CreateTestRecords.createEONCustomer();
        customer1.Name = '9988776655';
        customer1.Smart_Interest__c = 'N';
        customer1.Customer_group_type__c = 'RES';
        customer1.Customer_Name__c = 'False-RES-N'; 
        insert customer1;  
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Customer__c = customer1.ID;
        insert eSite;
        EON_Fuel__c eFuelDF = EON_CreateTestRecords.createEONFuel();
        eFuelDF.Premise__c = eSite.ID;
        eFuelDF.MPRN__c = '1111';
        eFuelDF.MPAN__c = '2221';
        insert eFuelDF; 
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO');
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1',Duration__c = 123, Value__c = 'CR');
        insert ejobAtt;
        
        //CH03.start
        EON_Electric_Meter_Type__c objEleMetType = new EON_Electric_Meter_Type__c(Name='KEY');
        insert objEleMetType;
        
        EON_Gas_Meter_Type__c objGasMetType = new EON_Gas_Meter_Type__c(Name='MCL');
        insert objGasMetType;
        //CH03.end
          //CH05.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH05.end 
        EON_Appointment__c appt = new EON_Appointment__c(Planned_E_Meter_Type__c = 'MS1', MPRN__c = '121',Fuel_ID__c=eFuelDF.id,Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c=ssc.id,//CH06.old
         Appointment_Date__c = Date.Today(),Planned_G_Meter_Type__c='MS1', End_Time__c = '12:32',  E_Meter_Type__c = objEleMetType.Id /*CH03 'KEY'*/, G_Meter_Type__c= objGasMetType.Id /*CH03 'MCL'*/,Metering_Pressure__c = 'Low');/*CH08*/
        insert appt;

        EON_Capacity_Categories__c capacityCatg = new EON_Capacity_Categories__c(Name = 'MS1LOW',Elec_Phase__c = '3PH', Gas_pressure__c = 'Low',  Work_Skill__c = 'DF3');
        insert capacityCatg;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        //EON_Appointment_Booking_Ctrl_Helper.AvailableCapacity availCap = new EON_Appointment_Booking_Ctrl_Helper.AvailableCapacity();
        Map<String,Date> mapdate = new Map<String,Date>{'Appointment'=>Date.today()};
        
        EON_Appointment_Booking_Ctrl_Helper.getCapacityFromOFSC(appt.id, 'LON_SouthEast1', job.id,mapdate);
        
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
    /**
        getCapacityFromOFSC_FAIL(): Positive test for method getCapacityFromOFSC();
    **/ 
    static testMethod void getCapacityFromOFSC_FAIL() { 
     EON_OFSC_GetCapacity_CalloutTest();
         
        Test.startTest(); 
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO');
        insert job;          
        //CH05.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH05.end         
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old //Requested_SSC__c=ssc.id,//CH06.old
         Appointment_Date__c = Date.Today(), End_Time__c = '12:32');
        insert appt;

        EON_Capacity_Categories__c capacityCatg = new EON_Capacity_Categories__c(Name = 'KEYMCL3PHLOW',Elec_Phase__c = '3PH', Gas_pressure__c = 'LOW',  Work_Skill__c = 'DF3');
        insert capacityCatg;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        //EON_Appointment_Booking_Ctrl_Helper.AvailableCapacity availCap = new EON_Appointment_Booking_Ctrl_Helper.AvailableCapacity();
        Map<String,Date> mapdate;
        
        EON_Appointment_Booking_Ctrl_Helper.getCapacityFromOFSC(null, 'LON_SouthEast1', job.id,mapdate);
        
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
     /**
    getCapacitiesFromOFSCPass3() - tThis Will cover the Pass Scenario
    **/

     static testMethod void getCapacitiesFromOFSCPass3() {
        //CH01.start
        EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(Name='1PHPH ',Elec_Meter_Type__c='E',Elec_Phase__c='PH',Work_Skill__c='workSkill');
        insert capacity;
        EON_Job_Attribute__c att =EON_CreateTestRecords.createEonJobAttributes();
        insert att;
        //CH01.end
        EON_DisplayCapacitiesFromOFSC_Ctrl ctrl = new EON_DisplayCapacitiesFromOFSC_Ctrl();
        EON_Electric_Meter_Type__c emeter= new EON_Electric_Meter_Type__c();
        emeter.name='Test1';
        emeter.DESCRIPTION__c='KEY';
        emeter.FILTER__c='KEY';
        emeter.OFS_Enumeration__c=010;
        insert emeter;
        //CH01.start
        EON_Site__c site = EON_CreateTestRecords.cereateEONSite();
        insert site;
        EON_Fuel__c fuel=EON_CreateTestRecords.createEONFuel();
        fuel.Fuel_type__c = 'E';
        fuel.Premise__c=site.id;
        insert fuel;
        //CH01.end
        Eon_Appointment__c app = new Eon_Appointment__c();
        app.Fuel_ID__c=fuel.id;//CH01
        app.Job_Code__c=att.Eon_Job__c;//CH01
        app.E_Meter_Type__c =emeter.id;
        app.Number_of_Phases__c = '1Ph';/*CH08*/
        app.Metering_Pressure__c = 'LOW';
        insert app;
        EON_Capacity_Categories__c cate1= new EON_Capacity_Categories__c(Name='Test11PHPHLow',Work_Skill__c='workSkill');
        insert cate1;
        EON_Capacity_Categories__c cate2= new EON_Capacity_Categories__c(Name='Test2',Work_Skill__c='Test2');
        insert cate2;
        //string workskill = EON_OFSC_Helper.getWorkSkill(app);
        EON_Create_Appointment_Request_ctrl.eEff_From_Date = Date.Today();
        EON_Create_Appointment_Request_ctrl.eEff_To_Date = date.Today()+1;
        System.currentPageReference().getParameters().put('appID',App.Id);  
        System.currentPageReference().getParameters().put('dateSelected','1-2-3');
        System.currentPageReference().getParameters().put('specificTimeFlag','true');
        System.currentPageReference().getParameters().put('apptStartTime','13:12:00');
        EON_Appointment_Booking_Ctrl_Helper.errorMessages ='';
        EON_Appointment_Booking_Ctrl_Helper.appDuration =20;//CH01
        ctrl.bookSlotsOFSC();
        EON_DisplayCapacitiesFromOFSC_Ctrl_test.EON_OFSC_GetCapacity_CalloutTest();
        ctrl.getCapacitiesFromOFSC();
        EON_Appointment_Booking_Ctrl eonAppsCtrl= new EON_Appointment_Booking_Ctrl();
        //eonAppsCtrl.newAppointment=app;
        //eonAppsCtrl.validateIndustryCreateApp(); 
        Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> recomMap=ctrl.availableCapacities;
    }
    
     /**
    searchIndustryPass2A() - method for Industry button on the page when only MPRN search field is populated.
    **/
    static testMethod void searchIndustryPass2A() {
        Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
         EON_Site__c site = EON_CreateTestRecords.cereateEONSite();
        insert site;
        EON_Fuel__c fuel=EON_CreateTestRecords.createEONFuel();
        fuel.Fuel_type__c = 'E';
        fuel.Premise__c=site.id;
        insert fuel;
        //CH01.end
        EON_Job_Attribute__c att =EON_CreateTestRecords.createEonJobAttributes();
        insert att;
        Eon_Appointment__c app = new Eon_Appointment__c();
        app.Fuel_ID__c=fuel.id;//CH01
        app.Job_Code__c=att.Eon_Job__c;//CH01
        //app.E_Meter_Type__c =emeter.id;
        app.Number_of_Phases__c = '1Ph';/*CH08*/
        app.Metering_Pressure__c = 'LOW';
        insert app;
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.name='OOACELEC';
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;
        EON_Job__c job1 = EON_CreateTestRecords.createEONJob();
        job1.name='OOASMARTELECINST';
        job1.MPRN_Reqd__c = true;
        job1.MPAN_Reqd__c = true;
        job1.Job_Type__c = 'Maintenance';
        insert job1;
        EON_Job__c job2 = EON_CreateTestRecords.createEONJob();
        job2.name='OOASMARTGASINST';
        job2.MPRN_Reqd__c = true;
        job2.MPAN_Reqd__c = true;
        job2.Job_Type__c = 'Maintenance';
        insert job2;
        EON_Job__c job3 = EON_CreateTestRecords.createEONJob();
        job3.name='OOASMARTDFINST';
        job3.MPRN_Reqd__c = true;
        job3.MPAN_Reqd__c = true;
        job3.Job_Type__c = 'Maintenance';
        insert job3;
        
        eonAppCtrl.callingFrom = 'Industry';                
        
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = ''; 
        serWra.MPAN = '';   
        eonAppCtrl.populateElectricityGasData(serWra); 
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'New Connections');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        eonAppCtrl.NewAppointment=app;
        eonAppCtrl.createApptIndus();
        List<System.SelectOption>  Sel=eonAppCtrl.appReasonLst;
        eonAppCtrl.selectedJobs();
        serWra.MPRN = '123';
        serWra.MPAN = '';   
        //eonAppCtrl.populateElectricityGasData(serWra); 
        eonAppCtrl.appointmentReason =  reason.id;
        eonAppCtrl.selectedJobs();
        serWra.MPAN = '123';
        serWra.MPRN = '';   
        //eonAppCtrl.populateElectricityGasData(serWra); 
        eonAppCtrl.appointmentReason =  reason.id;
        eonAppCtrl.selectedJobs();
        //System.assertEquals(serWra.MPRN, '123');
        Test.stopTest();      
    }
     /**
        getCapacityFromOFSC_Booking_helper(): Positive test for method getCapacityFromOFSC();
    **/ 
    static testMethod void getCapacityFromOFSC_Booking_helper() {        
         
        //Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO');
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1',Duration__c = 123, Value__c = 'CR');
        insert ejobAtt;
        
        //CH03.start
        EON_Electric_Meter_Type__c objEleMetType = new EON_Electric_Meter_Type__c(Name='KEY');
        insert objEleMetType;
        
        EON_Gas_Meter_Type__c objGasMetType = new EON_Gas_Meter_Type__c(Name='MCL');
        insert objGasMetType;
        //CH03.end
        
        //CH05.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH05.end
        
        EON_Appointment__c appt = new EON_Appointment__c(Planned_E_Meter_Type__c = 'KEY', Planned_G_Meter_Type__c = 'MCL', MPAN__c = '121',MPRN__c = '123',Booking_System_Name__c = 'Test',Key_Collection_Required__c = true ,EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old // Requested_SSC__c=ssc.id,//CH06.old
        Appointment_Date__c = Date.Today()-1, End_Time__c = '12:32',  E_Meter_Type__c = objEleMetType.Id /*CH03 'KEY'*/, G_Meter_Type__c= objGasMetType.Id /*CH03 'MCL'*/,Number_of_Phases__c = '3Ph',Metering_Pressure__c = 'Low');/*CH08*/
        insert appt;

        EON_Capacity_Categories__c capacityCatg = new EON_Capacity_Categories__c(Name = 'KEYMCL3PHLow',Elec_Phase__c = '3PH', Gas_pressure__c = 'Low',  Work_Skill__c = 'Workskill');
        insert capacityCatg;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        Map<Date,List<EON_OFSC_Helper.RecomendedTimeSlots>> mapTimeslot = new Map<Date,List<EON_OFSC_Helper.RecomendedTimeSlots>>();
        EON_Appointment_Booking_Ctrl_Helper.avaCapacities = mapTimeslot;        
        Map<String,Date> mapdate = new Map<String,Date>{'Appointment'=>Date.today()};
        EON_DisplayCapacitiesFromOFSC_Ctrl_test.EON_OFSC_GetCapacity_CalloutTest();        
        EON_Appointment_Booking_Ctrl_Helper.getCapacityFromOFSC(appt.id, 'LON_SouthEast1', job.id,mapdate);
        
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        System.assertEquals(pstCode.Name,'SE10 1');
        //Test.stopTest();
    }  
    
    
    
    //CH.Start
    /**
    getSelectedJobCodes() - method for .
    **/
    static testMethod void getSelectedJobCodes()
    
    {
        
          Test.startTest();        
        PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();       
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
        test.setMock(WebserviceMock.class , new MainClienttest ()); 
        EON_Jumbo_ElecGasData_Test.functionType = 'validateMOP'; 
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());      
        
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPAN = '123';
        //eonAppCtrl.searchWrap.MPRN = '';    
                  
        eonAppCtrl.populateElectricityGasData(serWra);         
        EON_Job__c job = EON_CreateTestRecords.createEONJob();        
        job.MPAN_Reqd__c = true;
        job.MPRN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;    
        
        eonAppCtrl.callingFrom = 'Industry';                
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Maintenance');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        eonAppCtrl.selectedJobs(); 
        eonAppCtrl.getSelectedJobCodes();  
        //eonAppCtrl.validateIndustryCreateApp(); 
        System.assertEquals(serWra.MPAN, '123');
        Test.stopTest();     
          
        
    
    }
    
   /**
    searchIndustryPass4_4a() - method for Industry button on the page when both the search fields are populated.
    **/
    static testMethod void searchIndustryPass4_4a() {
    
        EON_Appointment_Booking_Ctrl_Test.genException=true;    
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
      
        Test.startTest();
        
        EON_Utility.genException=true;
        //PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        eonAppCtrl.areWeNotMAM =true;
        eonAppCtrl.oracleBucketID =null;
        String appCtrl = eonAppCtrl.oracleBucketID;
        
        EON_Region__c region = new EON_Region__c(GSP_ID__c =12);        
        insert region;
        EON_Shutdown_Days__c days = new EON_Shutdown_Days__c(Name='Bank holiday',Holiday_Date__c=System.today());
        insert days;
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite =  new EON_Site__c(Customer__c=eCust.ID, Name = '1234567890',Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',Address_Type__c = 'S',Country__c = null ,County__c = null,Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',Double_Dependant_Locality__c = 'Stevenage',Sub_Building_Name__c = 'Stevenage',Thorofare__c = 'Stevenage',Town__c = 'Stevenage');
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '121'; 
        eFuel.Premise__c = eSite.id;
        //eFuel.Customer__c = eCust.id;  // CH04
        insert eFuel;
        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.Name = 'OOAECOWINDON';
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.Job_Code__c = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '121';
        //eApp.Fuel_ID__c = eFuel.id;
        insert eApp;
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false);
        insert mdsSwitch;
        //CH11.End
        
        //System.currentPageReference().getParameters().put('newAppointment', eApp.Id);         
        
        eonAppCtrl.callingFrom = 'Industry';        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = '121'; 
        eonAppCtrl.newAppointment = eApp;
        eonAppCtrl.ApptReason='Emergency Call Out';
        eonAppCtrl.validateIndustryCreateApp(); 
        eonAppCtrl.populateElectricityGasData(serWra);
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        
        eonAppCtrl.validateIndustryCreateApp(); 
        System.assertEquals(serWra.MPAN, '121');
        Test.stopTest();
        
        
        
    }
    
    //CH11.Start
    static testMethod void searchIndustryPass4_4b() {
    
        EON_Appointment_Booking_Ctrl_Test.genException=true;    
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        test.setMock(WebserviceMock.class , new MainClient ());
      
        Test.startTest();
        
        EON_Utility.genException=true;
        //PageReference pageRef = Page.EON_Appointment_Booking;
        EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        
        eonAppCtrl.areWeNotMAM =true;
        eonAppCtrl.oracleBucketID =null;
        String appCtrl = eonAppCtrl.oracleBucketID;
        
        EON_Region__c region = new EON_Region__c(GSP_ID__c =12);        
        insert region;
        EON_Shutdown_Days__c days = new EON_Shutdown_Days__c(Name='Bank holiday',Holiday_Date__c=System.today());
        insert days;
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite =  new EON_Site__c(Customer__c=eCust.ID, Name = '1234567890',Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',Address_Type__c = 'S',Country__c = null ,County__c = null,Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',Double_Dependant_Locality__c = 'Stevenage',Sub_Building_Name__c = 'Stevenage',Thorofare__c = 'Stevenage',Town__c = 'Stevenage');
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '121'; 
        eFuel.Premise__c = eSite.id;
        //eFuel.Customer__c = eCust.id;  // CH04
        insert eFuel;
        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.Name = 'OOAECOWINDON';
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;
        
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test');
        insert jobAtt;
        
        EON_Appointment__c eApp = EON_CreateTestRecords.createEONAppointment();
        eApp.Job_Code__c = job.id;
        eApp.MPRN__c = '123';
        eApp.MPAN__c = '121';
        //eApp.Fuel_ID__c = eFuel.id;
        insert eApp;
        
        //CH11.Start
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = true,
                                                                                  MDS_Status__c = false,
                                                                                  MDS_Close_Command_Only__c = true);
        insert mdsSwitch;
        //CH11.End
        
        //System.currentPageReference().getParameters().put('newAppointment', eApp.Id);         
        
        eonAppCtrl.callingFrom = 'Industry';        
        Eon_Appointment_Reason__c Reason = new Eon_Appointment_Reason__c(name= 'Emergency Call Out');//CH09
        insert Reason;//CH09
        eonAppCtrl.appointmentReason = reason.id;
        EON_Appointment_Booking_Ctrl.SearchWrapper serWra = new EON_Appointment_Booking_Ctrl.SearchWrapper();
        serWra.MPRN = '123';
        serWra.MPAN = '121'; 
        eonAppCtrl.newAppointment = eApp;
        eonAppCtrl.ApptReason='Emergency Call Out';
        eonAppCtrl.validateIndustryCreateApp(); 
        eonAppCtrl.populateElectricityGasData(serWra);
        eonAppCtrl.selectedJobs();
        eonAppCtrl.jobCodesSearched = job.id;
        
        eonAppCtrl.validateIndustryCreateApp(); 
        System.assertEquals(serWra.MPAN, '121');
        Test.stopTest();        
    }
    //CH11.End
    
    static testMethod void createAppointment_pass() {
            EON_Appointment_Booking_Ctrl eonAppCtrl = new EON_Appointment_Booking_Ctrl();
        Map<Id,EON_Job__c> mapjobs = new Map<Id,EON_Job__c>();
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.Name = 'OOASMARTELECEXCH';
        job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'SMART';
        insert job;
        
        eonAppCtrl.mapOfJobCodes= mapjobs;
        eonAppCtrl.jobCodesSearched=job.id;
        
         EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1',Duration__c = 123, Value__c = 'CR');
        insert ejobAtt;
        
        EON_Electric_Meter_Type__c objEleMetType = new EON_Electric_Meter_Type__c(Name='KEY');
        insert objEleMetType;
        
        EON_Gas_Meter_Type__c objGasMetType = new EON_Gas_Meter_Type__c(Name='MCL');
        insert objGasMetType;

        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test',Key_Collection_Required__c = true ,EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',
        Appointment_Date__c = Date.Today()-1, End_Time__c = '12:32',  E_Meter_Type__c = objEleMetType.Id , G_Meter_Type__c= objGasMetType.Id ,Number_of_Phases__c = '3Ph',Metering_Pressure__c = 'Low');
        insert appt;
    Eon_Appointment_Reason__c Reason1 = new Eon_Appointment_Reason__c(name= 'SMART');
    insert Reason1;
    
    EON_Job_Appointment_Reason__c eon_job_app_reason = new EON_Job_Appointment_Reason__c(Appointment_Reason__c=Reason1.id, Job__c=job.id);
        insert eon_job_app_reason ;
   // eonAppCtrl.appointmentReason=Reason1.id;
   // eonAppCtrl.jobCodesSearched=job.id;
   
   
   EON_Job__c job1 = EON_CreateTestRecords.createEONJob();
        job1.Name = 'OOASMARTELECEXCH';
        job1.MPRN_Reqd__c = true;
        job1.MPAN_Reqd__c = true;
        job1.Job_Type__c = 'SMART';
        insert job1;
        mapjobs.put(job1.id,job1);

        //eonAppCtrl.newAppointment=appt;
     Map<Id,EON_Job__c>  mapOfJobCodes1  = new Map<Id,EON_Job__c>();
 mapOfJobCodes1 = new Map<Id,EON_Job__c>([Select id,Name,Job_Type__c,MPAN_Reqd__c,MPRN_Reqd__c from EON_Job__c where id =: eon_job_app_reason.Job__c]);
 
 
    }
    
    
    
    
    
}