/**
    Description : This test class will have coverage of the below Class
                  1. EON_Cancel_Activity_OFSC

**/
/*
    Created By : Akshay Bairagi
    Created Date : 26-04-2016
    Service Request : SR_EON_Scheduling_008
*/
@isTest
public class EON_Cancel_Activity_OFSC_Test {
    /**
       unitTest- Pass scenario 
    **/
    public testmethod static void unitTest() {

        EON_Appointment__c appt = new EON_Appointment__c();
        insert appt;
        Test.startTest();
        //This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock());
        EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(appt.id);
        Test.stopTest(); 
    }
    
    /*
		unitTest2(): Pass scenario with fail response from OFSC
	*/
    public testmethod static void unitTest2(){
        EON_OFSC_Response_Code__c ofscRes = EON_CreateTestRecords.createEonOFSCResponseCode();
        ofscRes.API__c = 'Inbound';
        ofscRes.name = '10';
        ofscRes.OFSC_Text__c = 'Appointment not found. cannot cancel';
        insert ofscRes;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        insert appt;
        Test.startTest();
        //This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_Appointment_ServicesMock_Fail());
        EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(appt.id);
        Test.stopTest(); 
    }
}