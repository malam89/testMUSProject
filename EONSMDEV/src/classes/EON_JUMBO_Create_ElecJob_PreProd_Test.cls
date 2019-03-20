/**
    Description : This test class covers the code coverage for below class
        1. EON_JUMBO_Create_ElecJob_PreProd
**/
/*
    Created By : Mahadev J
    Created Date : 21/11/2016
    Service Request : 
  	Change History :
*/
@isTest
global class EON_JUMBO_Create_ElecJob_PreProd_Test {
    public static boolean genException;
 	/**
    	TestCase1() - Postive test case
    **/ 
    static testMethod void TestCase1(){
        EON_JUMBO_Create_ElecJob_PreProd.ElecWorkRequest request = new EON_JUMBO_Create_ElecJob_PreProd.ElecWorkRequest();
        request.MPAN = '1234';
        request.JUMBOID = '1234';
        request.RequestTime ='111010';
        request.EarliestStartTime ='121010' ;
        request.LatestStartTime = '101010';
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'test Type'; 
        EON_JUMBO_Create_ElecJob_PreProd.JumboToIsisElecWorkResponse response = EON_JUMBO_Create_ElecJob_PreProd.createElectricityJobInIsis(request);
        system.assertEquals(response.Success, 'PASS');
    }
    
    /**
    	TestCase2() - Postive test case for Exception
    **/ 
    static testMethod void TestCase2(){
        EON_JUMBO_Create_ElecJob_PreProd.ElecWorkRequest request = new EON_JUMBO_Create_ElecJob_PreProd.ElecWorkRequest();
        request.MPAN = '1234';
        request.JUMBOID = '1234';
        request.RequestTime ='111010';
        request.EarliestStartTime ='121010' ;
        request.LatestStartTime = '101010';
        request.earliestStartDate = System.today();
        request.JUMBOJobType = 'test Type'; 
        genException = true;
        EON_JUMBO_Create_ElecJob_PreProd.JumboToIsisElecWorkResponse response = EON_JUMBO_Create_ElecJob_PreProd.createElectricityJobInIsis(request);
    }
}