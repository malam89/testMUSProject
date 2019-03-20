/**
Description : This test class is for the following below classes.
              EON_ServiceStatus
**/

/*
    Created By      : Dharmendra Pahadiya
    Created Date    : 12/07/2016
    Service Request : SR_EON_AB_081 & SR_Isis_EON_021
    Change History  : 
*/
@isTest
private class EON_ServiceStatus_test {
	
	/*
		EONServiceStatus_myUnitTest1 - 
	*/
	static testMethod void EONServiceStatus_myUnitTest1() {
		//Create Data
		EON_Data_Tracker__c objTrcker = new EON_Data_Tracker__c(Direction__c = 'OUT', Command__c = 'Get Service Status');
		insert objTrcker;
		
		// This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_GET_Job_Service_from_EON_WSMockImpl());
        test.startTest();
        EON_ServiceStatus.getEONServiceStatus(objTrcker.Id);
        test.stopTest();
	}
	
	/*
		EONServiceStatus_myUnitTest2 - Web service fail
	*/
	static testMethod void EONServiceStatus_myUnitTest2() {
		//Create Data
		EON_Data_Tracker__c objTrcker = new EON_Data_Tracker__c(Direction__c = 'OUT', Command__c = 'Get Service Status');
		insert objTrcker;
		
		test.startTest();
        EON_ServiceStatus.getEONServiceStatus(objTrcker.Id);
        test.stopTest();
	}
	
	/*
		MIDOSServiceStatus_myUnitTest1 - 
	*/
	static testMethod void MIDOSServiceStatus_myUnitTest1() {
		//Create Data
		MIDOS_Data_Tracker__c objTrcker = new MIDOS_Data_Tracker__c(Direction__c = 'OUT', Command__c = 'Get Service Status');
		insert objTrcker;
		
		// This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_MIDOS_Send_Data_WSMockImpl());
		test.startTest();
        EON_ServiceStatus.getMIDOSServiceStatus(objTrcker.Id);
        test.stopTest();
	}
	
	/*
		MIDOSServiceStatus_myUnitTest2 - Web service fail
	*/
	static testMethod void MIDOSServiceStatus_myUnitTest2() {
		//Create Data
		MIDOS_Data_Tracker__c objTrcker = new MIDOS_Data_Tracker__c(Direction__c = 'OUT', Command__c = 'Get Service Status');
		insert objTrcker;
		
		test.startTest();
        EON_ServiceStatus.getMIDOSServiceStatus(objTrcker.Id);
        test.stopTest();
	}
}