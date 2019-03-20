/**
    Description : This Trigger is to help operations for the object EON_Failed_Asset__c.
**/

/*
    Created By : Praveen G
    Created Date : 05/01/2018
    Service Request : SR_OptiMUS_EON_190
    
    Change History : 
    CH01 # SR_OptiMUS_EON_181 # 08/03/2018 # Praveen G # update stock record logic for failed assets 
        CH02 # SR_OptiMUS_EON_224 # 22/03/2018 # Abhilash #  added one more event in trigger events after update
   
*/
trigger EON_Failed_Asset_Trigger on EON_Failed_Asset__c (before insert, before update, after insert, after Update) {
    
    if(Trigger.isBefore)
        //Auto calculate the hidden field values 
        EON_Failed_Asset_Trigger_Helper.calculateFailureCode(Trigger.New);
    
    //CH01.Start    
    if(Trigger.isAfter)
        //Update stock records for failed date based on serial number. 
        EON_Failed_Asset_Trigger_Helper.updateStockForFailedAsset(Trigger.New);             
    //CH01.End

}