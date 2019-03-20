/**
Description : This test class is for the following below classes/triggers
              JUMBO_Utility_Test;    
              
**/

/*
    Created By  : Mehboob Alam
    Created On  : 23/05/2016
    Service Req: SR_EON_Jumbo_006
    Change History
*/


@isTest
public with sharing class JUMBO_Utility_Test {
 
    /**
    UtilityTest()   
    **/   
   static testMethod void UtilityTest() { 
 
        //test cases for method strigToDate
        JUMBO_Utility.strigToDate('20160201');
        JUMBO_Utility.strigToDate('201602');
        JUMBO_Utility.strigToDate(null);
        
        //test cases for method DateToString
        JUMBO_Utility.DateToString(date.today());
        JUMBO_Utility.DateToString(null);
        
        //test cases for method TimeToString
        JUMBO_Utility.TimeToString('12:12');
        JUMBO_Utility.TimeToString(null);
        
        //test cases for method StringToTime
        JUMBO_Utility.StringToTime('121200');
        JUMBO_Utility.StringToTime('1212');
        JUMBO_Utility.StringToTime(null);
       
		//Test call to J.12 and J.16
       EON_Appointment__c appt = new EON_Appointment__c();
       insert appt;
       JUMBO_Utility.closeElecJobAtJumbo(appt.ID);
       JUMBO_Utility.closeGasJobAtJumbo(appt.ID);
    }
}