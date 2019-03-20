/** 
    Description: This trigger is for EON_Technician__c sObject.
    Helper Class  : EON_Technician_Trigger_Helper
    Test Class    : EON_Technician_Trigger_Test
**/
/* 
    Created By  : Puneet Mehta
    Created On  : 29/03/2016
    Service Req : SR_EON_Scheduling_001
    Change History :
    CH01 #SR_EON_Scheduling_032 # 04/05/2016 # Pedda Reddeiah # added code to achieve SR functionality 
    CH02 #SR_EON_AL_032 # 22/08/2016 # Shruti Moghe # Added logic to update the hidden Date fields based on conditions
*/
Trigger EON_Technician_Trigger on EON_Technician__c ( before update,before insert, after insert, after update ) {
    
    //to by pass the trigger when mass transfering the records
    if (System.Label.EON_Bypass_Mass_Transfer_Records == 'FALSE' && EON_Ceva_Utility.byPassTechTrigger){
        EON_Technician_Trigger_Helper handler = new EON_Technician_Trigger_Helper();
        //CH01.Start
        if(Trigger.isBefore && Trigger.isInsert){
            handler.OnBeforeInsert(Trigger.new);
          }
          if(Trigger.isBefore && Trigger.isUpdate){
            handler.OnBeforeUpdate(Trigger.new);
            EON_Technician_Trigger_Helper.BAUTriggerPopulateDateFields(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);//CH02

          }
          //CH01.End
        
        if(Trigger.isAfter && Trigger.isInsert){
            handler.OnAfterInsert(Trigger.new);
        }
        if(Trigger.isUpdate && Trigger.isAfter){
            handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
        
       
    }
}