/**
    Description : This test class is for the following below classes/triggers
                  EON_OFSC_JobResults_Wrapper
                       
**/
/*
    Created By  : Mehboob Alam
    Created On  :  27/04/2018
    Covering Components : EON_OFSC_JobResults_Wrapper
    Service Req : SR_OptiMUS_EON_243
    Change History
    
*/
@isTest
private class EON_OFSC_JobResults_Wrapper_Test{

    static testMethod void myUnitTest() {
    	EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTag();
    	EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTagForNumbers();
    	EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTagForLookup();
    	EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTagForDate();
    	EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTagForLookupFaultyAssets();
    }
}