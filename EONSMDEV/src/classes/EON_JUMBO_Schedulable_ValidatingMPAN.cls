/**
    Description : This schedular class used to run batch apex class(WM_GetPhotosNightlyBatchJob) to download  photos 
                  This scheduler will run in every 10 min  
                  
    VF Page     : None       
    Test Class  : EON_JUMBO_Schedulable_ValidatingMPAN_Test
    Schedule Job Name : EON_JUMBO_Schedulable_ValidatingMPAN                                               
**/
/*
    Created By  : Mehboob Alam
    Created On  : 20/04/2016
    Service Req : SR_EON_Jumbo_025
    Change History
*/

public with sharing class EON_JUMBO_Schedulable_ValidatingMPAN  implements Schedulable {
	
    /** 
    execute(SchedulableContext SC) - Execute method
    **/
	public void execute(SchedulableContext SC) {
        EON_JUMBO_Validate_MPAN_BatchScheduler tt = new EON_JUMBO_Validate_MPAN_BatchScheduler();
        ID newid = Database.executebatch(tt ,1);
     } 

}