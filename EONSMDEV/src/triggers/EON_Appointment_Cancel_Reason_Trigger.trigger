/**
Description: This trigger is for updating the Appointment Status field when Reason Key is update in on EON Appointment Cancel Reason .

Helper Class  : EON_Appment_CancelReason_Trigger_Helper  
Test Class    : EON_Appointment_Trigger_Test

**/
/* 
Created By    : Sivasankar K
Created On    : 17/02/2016
Service Req   : SR_EON_AB_002
Change History
*/
trigger EON_Appointment_Cancel_Reason_Trigger on EON_Appointment_Cancel_Reason__c (after Update) {
    //to by pass the trigger when mass transfering the records.
    if (System.Label.EON_Bypass_Mass_Transfer_Records == 'FALSE'){
        if (Trigger.IsAfter) {
            //calling the method for calcualting the Appointment Status.
            EON_Appment_CancelReason_Trigger_Helper.updateEonAppointments(trigger.newMap,trigger.oldMap);
        }
    }
}