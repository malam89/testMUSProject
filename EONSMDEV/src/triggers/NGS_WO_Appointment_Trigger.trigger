/**
    Description   : Master trigger for the "NGS Work Order Appointment" object (NGS_Work_Order_Appointment__c)
                    This trigger provides dispatch logic for the following Trigger Actions:
                    BEFORE INSERT
                    BEFORE UPDATE
                    BEFORE DELETE
                    AFTER  INSERT
                    AFTER  UPDATE
                    AFTER  DELETE
                    AFTER  UNDELETE
                    The framework for dispatching additional Trigger Actions has been left in place. To activate 
                    these additional dispatch calls, un-comment the appropriate lines of code.  Before doing so, 
                    make sure that the corresponding method in the handler class has been implemented.
                    IMPORTANT!  Under no circumstance should additional logic be placed here, within this Trigger 
                    definition. Trigger logic should ONLY be implemented by the Trigger Handler class, or classes
                    called by the Trigger Handler class.
    Helper Class  : NGS_WO_Appointment_Trigger_Helper
    Test Class    : 
**/
/*
    Created By    : Puneet Mehta
    Created On    : 02/03/2017
    Service Req   : SR_OptiMUS_NG_017
*/
trigger NGS_WO_Appointment_Trigger on NGS_Work_Order_Appointment__c (before insert, before update, 
                                                before delete, after insert, 
                                                after update,  after delete, 
                                                after undelete) {
    //to by pass the trigger when mass transfering the records.
    if (System.Label.NGS_Bypass_Mass_Transfer_Records == 'FALSE'){
        // Instantiate the Trigger Handler, then dispatch to the correct Action
        NGS_WO_Appointment_TriggerHandler handler = new NGS_WO_Appointment_TriggerHandler();

        /* Before Insert */
        if (trigger.isInsert && trigger.isBefore) {
            handler.beforeInsert(trigger.new);
        }
        /* Before Update */
        else if (trigger.isUpdate && trigger.isBefore) {
            handler.beforeUpdate(trigger.old, trigger.oldMap, trigger.new, trigger.newMap);
        }
        /* Before Delete */
        //else if (trigger.isDelete && trigger.isBefore) {
        //  handler.beforeDelete(trigger.old, trigger.oldMap);
        //}
        /* After Insert */
        else if (trigger.isInsert && trigger.isAfter) {
            handler.afterInsert(trigger.new, trigger.newMap);
        }
        /* After Update */
        else if (trigger.isUpdate && trigger.isAfter) {
            handler.afterUpdate(trigger.old, trigger.oldMap, trigger.new, trigger.newMap);
        }
        /* After Delete */
        //else if (trigger.isDelete && trigger.isAfter) {
        //  handler.afterDelete(trigger.old, trigger.oldMap);
        //}
        /* After Undelete */
        //else if (trigger.isUnDelete) {
        //  handler.afterUndelete(trigger.new);
        //}
    }
}