/**
	Description : This test class is for the following below classes/triggers
                  EON_MDS_Utility;    

**/
/*
    Created By  : Ashay Ingle
    Created On  : 30/01/2019
    Service Req: SR_OptiMUS_EON_297
    Change History
	CH01 #SR_EON_303 # Tabish Almas # 14/02/2019 # Added new field in query and added new method UtilityTest2()
*/

@isTest
public with sharing class EON_MDS_Utility_Test {
    
    /**
	UtilityTest1()   
	**/   
    static testMethod void UtilityTest1() {        
        //test cases for method strigToDate
        EON_MDS_Utility.strigToDate('2017-03-28T00:00:00');
        EON_MDS_Utility.strigToDate('2017-03-28T00:00');
        EON_MDS_Utility.strigToDate(null);
        
        //test cases for method DateToString
        EON_MDS_Utility.DateToString(date.today());
        EON_MDS_Utility.DateToString(null);
        
        //test cases for method TimeToString
        EON_MDS_Utility.TimeToString('12:12');
        EON_MDS_Utility.TimeToString(null);
        
        //test cases for method StringToTime
        EON_MDS_Utility.StringToTime('121200');
        EON_MDS_Utility.StringToTime('1212');
        EON_MDS_Utility.StringToTime(null);
        
        //Test call to J.12 and J.16
        EON_Appointment__c appt = new EON_Appointment__c();
        insert appt;
        EON_MDS_Utility.closeElecJobAtMDS(appt.ID);
        EON_MDS_Utility.closeGasJobAtMDS(appt.ID);
        
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = false,
                                                                                  MDS_Status__c = true,
                                                                                  MDS_Close_Command_Only__c = false,
                                                                                  Validate_Request_from_MDS__c = true);	//CH01
        insert mdsSwitch;
        EON_MDS_Utility.getMDS_Jumbo_Status();
    }
    
    /**
	UtilityTest2()   
	**/  
    static testMethod void UtilityTest2() {        
        //test cases for method strigToDate
        EON_MDS_Utility.strigToDate('2017-03-28T00:00:00');
        EON_MDS_Utility.strigToDate('2017-03-28T00:00');
        EON_MDS_Utility.strigToDate(null);
        
        //test cases for method DateToString
        EON_MDS_Utility.DateToString(date.today());
        EON_MDS_Utility.DateToString(null);
        
        //test cases for method TimeToString
        EON_MDS_Utility.TimeToString('12:12');
        EON_MDS_Utility.TimeToString(null);
        
        //test cases for method StringToTime
        EON_MDS_Utility.StringToTime('121200');
        EON_MDS_Utility.StringToTime('1212');
        EON_MDS_Utility.StringToTime(null);
        
        //Test call to J.12 and J.16
        EON_Appointment__c appt = new EON_Appointment__c();
        insert appt;
        EON_MDS_Utility.closeElecJobAtMDS(appt.ID);
        EON_MDS_Utility.closeGasJobAtMDS(appt.ID);
        
        //Insert new record in MDS_Jumbo_Dataflow_Switch__c 
        MDS_Jumbo_Dataflow_Switch__c mdsSwitch = new MDS_Jumbo_Dataflow_Switch__c(Onyx_Status__c = true,
                                                                                  MDS_Status__c = false,
                                                                                  MDS_Close_Command_Only__c = true,
                                                                                  Validate_Request_from_MDS__c = false);
        insert mdsSwitch;
        EON_MDS_Utility.getMDS_Jumbo_Status();
    }
}