/**
Description : This test class is for the following below classes/triggers
              Class - EON_RetrieveDataInCache_Schedule       
**/
/*
    Created By  : Mehboob Alam
    Created On  : 19/04/2018
    Service Req : SR_OptiMUS_ALL_ORGS_129
    Covering Components : EON_RetrieveDataInCache_Schedule
    Change History
*/

@isTest
public with sharing class EON_RetrieveDataInCache_Schedule_Test {
 
    /**
    Test1() - Test Method
    **/   
   static testMethod void Test1() { 
    EON_RetrieveDataInCache_Schedule s = new EON_RetrieveDataInCache_Schedule();
    s.execute(null) ;
    }
 }