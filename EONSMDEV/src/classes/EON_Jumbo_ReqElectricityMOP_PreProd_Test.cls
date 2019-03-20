/**
    Description : This test class covers the code coverage for below class
        1. EON_Jumbo_ReqElectricityMOP_PreProd
**/
/*
    Created By : Mahadev J
    Created Date : 21/11/2016
    Service Request : 
  	Change History :
*/
@isTest
global class EON_Jumbo_ReqElectricityMOP_PreProd_Test implements WebServiceMock{
	public static boolean isError = false;
    public static boolean genException;
    /*
		TestCase1() = Postitive Response Test Case
	*/
    static testmethod void TestCase1(){
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ReqElectricityMOP_PreProd_Test());
        EON_Jumbo_ReqElectricityMOP_PreProd_Test.isError = true;
        EON_Jumbo_ReqElectricityMOP.MOPValidationResponse mopResp = new EON_Jumbo_ReqElectricityMOP.MOPValidationResponse();
        test.startTest();
        mopResp = EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP('test');
        EON_Jumbo_ReqElectricityMOP.supplierDesc('test');
        test.stopTest();
    }
    
    /*
		TestCase2() = Negative Response Test Case
	*/
    static testmethod void TestCase2(){
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ReqElectricityMOP_PreProd_Test());
        EON_Jumbo_ReqElectricityMOP_PreProd_Test.isError = false;
        EON_Jumbo_ReqElectricityMOP.MOPValidationResponse mopResp = new EON_Jumbo_ReqElectricityMOP.MOPValidationResponse();
        test.startTest();
        mopResp = EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP('test');
        test.stopTest();
    }
    
    /*
		TestCase3() = Cover exception
	*/
    static testmethod void TestCase3(){
		EON_Jumbo_ReqElectricityMOP_PreProd_Test.genException = true;
        EON_Jumbo_ReqElectricityMOP.MOPValidationResponse mopResp = new EON_Jumbo_ReqElectricityMOP.MOPValidationResponse();
        test.startTest();
        mopResp = EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP('test');
        test.stopTest();
    }
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType){
		String[] Msg = new String[]{'Message1','Message2','Message3'};
        EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
        errObj.Message = Msg;
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
        EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
        respJumbo.Success = EON_Jumbo_ReqElectricityMOP_PreProd_Test.isError;
        respJumbo.MeterPoint=empObj;
        respJumbo.Errors = errObj;
        EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
        obj.RequestElectricitySupplierAppointmentsResult = respJumbo;
        response.put('response_x', obj);        
    }
}