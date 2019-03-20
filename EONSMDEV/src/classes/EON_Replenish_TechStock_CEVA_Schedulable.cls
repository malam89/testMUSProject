/**
    Description : This class will schedule the EON_Replenish_TechStock_CEVA_Batch batch class. Thanks 
    
    VF Page     : None
    Test Class  : EON_Replenish_TechStock_CEVA_Batch_Test
**/
/*
    Created By  : Mehboob Alam
    Created On  : 01/12/2017
    Service Req : SR_OptiMUS_EON_168
    Change History
*/


public with sharing class EON_Replenish_TechStock_CEVA_Schedulable  implements Schedulable{
   
   public void execute(SchedulableContext SC) {
       EON_Replenish_TechStock_CEVA_Batch tt = new EON_Replenish_TechStock_CEVA_Batch();
       ID newid = Database.executebatch(tt ,10);
     } 
}