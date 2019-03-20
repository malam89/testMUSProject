/**
Description : This test class is for the following below classes/triggers
              EON_JUMBO_Work_Management_WS
   
              
**/

/*
    Created By  : Mehboob Alam
    Created On  : 22/04/2016
    Service Req : SR_EON_Jumbo_003,
    Change History
*/

@isTest
global class EON_JUMBO_Work_Management_WS_Test implements WebServiceMock {
    
    @isTest 
    static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS parentObject = new EON_JUMBO_Work_Management_WS();
		new EON_JUMBO_Work_Management_WS.ArrayOfCareDetail();
		new EON_JUMBO_Work_Management_WS.ArrayOfCloseElecMeter();
		new EON_JUMBO_Work_Management_WS.ArrayOfCloseElecOutstation();
		new EON_JUMBO_Work_Management_WS.ArrayOfCloseElecRegister();
		new EON_JUMBO_Work_Management_WS.ArrayOfCloseGasMeter();
		new EON_JUMBO_Work_Management_WS.ArrayOfCloseGasRegister();
		new EON_JUMBO_Work_Management_WS.ArrayOfComms();
		new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
		new EON_JUMBO_Work_Management_WS.ArrayOfContact();
		new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
		new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
		new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
		new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
		new EON_JUMBO_Work_Management_WS.ArrayOfElecRegister();
		new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
		new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter();
		new EON_JUMBO_Work_Management_WS.ArrayOfGasRegister();
		new EON_JUMBO_Work_Management_WS.ArrayOfMeterMemoryLocationType();
		new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
		new EON_JUMBO_Work_Management_WS.ArrayOfSpecialNeed();
		new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
		new EON_JUMBO_Work_Management_WS.CancelElecWork();
		new EON_JUMBO_Work_Management_WS.CancelElecWorkRequest();
		new EON_JUMBO_Work_Management_WS.CancelGasWork();
		new EON_JUMBO_Work_Management_WS.CancelGasWorkRequest();
		new EON_JUMBO_Work_Management_WS.CancelJumboElectricityJob_element();
		new EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element();
		new EON_JUMBO_Work_Management_WS.CancelJumboGasJob_element();
		new EON_JUMBO_Work_Management_WS.CancelJumboGasJobResponse_element();
		new EON_JUMBO_Work_Management_WS.CareDetail();
		new EON_JUMBO_Work_Management_WS.ClientData();
		new EON_JUMBO_Work_Management_WS.CloseElecMeter();
		new EON_JUMBO_Work_Management_WS.CloseElecOutstation();
		new EON_JUMBO_Work_Management_WS.CloseElecRegister();
		new EON_JUMBO_Work_Management_WS.CloseElecWork();
		new EON_JUMBO_Work_Management_WS.CloseElecWorkRequest();
		new EON_JUMBO_Work_Management_WS.CloseGasMeter();
		new EON_JUMBO_Work_Management_WS.CloseGasRegister();
		new EON_JUMBO_Work_Management_WS.CloseGasWork();
		new EON_JUMBO_Work_Management_WS.CloseGasWorkRequest();
		new EON_JUMBO_Work_Management_WS.CloseJumboElectricityJob_element();
		new EON_JUMBO_Work_Management_WS.CloseJumboElectricityJobResponse_element();
		new EON_JUMBO_Work_Management_WS.CloseJumboGasJob_element();
		new EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element();
		new EON_JUMBO_Work_Management_WS.Comms();
		new EON_JUMBO_Work_Management_WS.CommsBase();
		new EON_JUMBO_Work_Management_WS.Contact();
		new EON_JUMBO_Work_Management_WS.ContactMechanism();
		new EON_JUMBO_Work_Management_WS.Converter();
		new EON_JUMBO_Work_Management_WS.Coordinates();
		new EON_JUMBO_Work_Management_WS.CreateElecWork();
		new EON_JUMBO_Work_Management_WS.CreateElecWorkRequest();
		new EON_JUMBO_Work_Management_WS.CreateGasWork();
		new EON_JUMBO_Work_Management_WS.CreateGasWorkRequest();
		new EON_JUMBO_Work_Management_WS.CreateJumboElectricityJob_element();
		new EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element();
		new EON_JUMBO_Work_Management_WS.CreateJumboGasJob_element();
		new EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element();
		new EON_JUMBO_Work_Management_WS.CreateWorkBase();
		new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
		new EON_JUMBO_Work_Management_WS.ElecAddress();
		new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
		new EON_JUMBO_Work_Management_WS.ElecContact();
		new EON_JUMBO_Work_Management_WS.ElecCustomer();
		new EON_JUMBO_Work_Management_WS.ElecMeter();
		new EON_JUMBO_Work_Management_WS.ElecMeterBase();
		new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
		new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
		new EON_JUMBO_Work_Management_WS.ElecMeterPointDataRequest();
		new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
		new EON_JUMBO_Work_Management_WS.ElecRegister();
		new EON_JUMBO_Work_Management_WS.ElecRegisterBase();
		new EON_JUMBO_Work_Management_WS.ElecRegisterReading();
		new EON_JUMBO_Work_Management_WS.ElecSiteVisit();
		new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest();
		new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
		new EON_JUMBO_Work_Management_WS.ElecSupply();
		new EON_JUMBO_Work_Management_WS.ErrorList();
		new EON_JUMBO_Work_Management_WS.GasAddress();
		new EON_JUMBO_Work_Management_WS.GasAppointedParty();
		new EON_JUMBO_Work_Management_WS.GasCustomer();
		new EON_JUMBO_Work_Management_WS.GasMeter();
		new EON_JUMBO_Work_Management_WS.GasMeterPoint();
		new EON_JUMBO_Work_Management_WS.GasMeterPointDataRequest();
		new EON_JUMBO_Work_Management_WS.GasMeterPointDataResponse();
		new EON_JUMBO_Work_Management_WS.GasRegister();
		new EON_JUMBO_Work_Management_WS.GasSupplierDetailsRequest();
		new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
		new EON_JUMBO_Work_Management_WS.GasTransaction();
		new EON_JUMBO_Work_Management_WS.JumboTechnicalResponse();
		new EON_JUMBO_Work_Management_WS.MeterMemoryLocationType();
		new EON_JUMBO_Work_Management_WS.Outstation();
		new EON_JUMBO_Work_Management_WS.OutstationBase();
		new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
		new EON_JUMBO_Work_Management_WS.OutstationPasswords();
		new EON_JUMBO_Work_Management_WS.OutstationUsernames();
		new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
		new EON_JUMBO_Work_Management_WS.RequestBase();
		new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element();
		new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();
		new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element();
		new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
		new EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element();
		new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();
		new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element();
		new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
		new EON_JUMBO_Work_Management_WS.ResponseBase();
		new EON_JUMBO_Work_Management_WS.SiteVisit();
		new EON_JUMBO_Work_Management_WS.SpecialNeed();
		new EON_JUMBO_Work_Management_WS.TimePatternRegime();
		new EON_JUMBO_Work_Management_WS.WithEffectiveDatesBase();
	}
	@isTest static void coverCodeForCancelJumboElectricityJob(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.CancelJumboElectricityJob(null));
	}
	@isTest static void coverCodeForCancelJumboGasJob(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.CancelJumboGasJob(null));
	}
	@isTest static void coverCodeForCloseJumboElectricityJob(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.CloseJumboElectricityJob(null));
	}
	@isTest static void coverCodeForCloseJumboGasJob(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.CloseJumboGasJob(null));
	}
	@isTest static void coverCodeForCreateJumboElectricityJob(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.CreateJumboElectricityJob(null));
	}
	@isTest static void coverCodeForCreateJumboGasJob(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.CreateJumboGasJob(null));
	}
	@isTest static void coverCodeForRequestElectricityMeterPointData(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.RequestElectricityMeterPointData(null));
	}
	@isTest static void coverCodeForRequestElectricitySupplierAppointments(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.RequestElectricitySupplierAppointments(null));
	}
	@isTest static void coverCodeForRequestGasMeterPointData(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.RequestGasMeterPointData(null));
	}
	@isTest static void coverCodeForRequestGasSupplierAppointments(){
		Test.setMock(WebServiceMock.class, new EON_JUMBO_Work_Management_WS_Test());
		EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement testObject = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
		System.assertEquals(null, testObject.RequestGasSupplierAppointments(null));
	}
	
    public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType){
       
		System.debug(LoggingLevel.INFO, 'EON_JUMBO_Work_Management_WSMockImpl.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);

		if(request instanceOf EON_JUMBO_Work_Management_WS.CancelJumboElectricityJob_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element());
		}
		else if(request instanceOf EON_JUMBO_Work_Management_WS.CancelJumboGasJob_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.CancelJumboGasJobResponse_element());
		}
		else if(request instanceOf EON_JUMBO_Work_Management_WS.CloseJumboElectricityJob_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.CloseJumboElectricityJobResponse_element());
		}
		else if(request instanceOf EON_JUMBO_Work_Management_WS.CloseJumboGasJob_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element());
		}
		else if(request instanceOf EON_JUMBO_Work_Management_WS.CreateJumboElectricityJob_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element());
		}
		else if(request instanceOf EON_JUMBO_Work_Management_WS.CreateJumboGasJob_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element());
		}
		else if(request instanceOf EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element());
		}
		else if(request instanceOf EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element());
		}
		else if(request instanceOf EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element());
		}
		else if(request instanceOf EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element) {
			response.put( 'response_x', new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element());
        }
    }
}