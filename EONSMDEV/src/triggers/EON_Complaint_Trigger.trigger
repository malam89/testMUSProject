/** 
Description: This trigger is for sending email with High/Normal severity at 'EON Complaint' to business.

Helper Class  : EON_Complaint_Trigger_Helper
Test Class    : EON_Complaint_Trigger_Test
**/
/* 
Created By    : Mahadev J
Created On    : 28/04/2016
Service Req   : SR_EON_PC_015

CHANGE HISTORY: 
CH01 # SR_OptiMUS_EON_057 # 02/05/2017 # Praveen G# added new method for auto updating the complaint fields from related appointment.
CH02 # SR_OptiMUS_EON_188 # 15/01/2018 # Mehboob Alam# Added a new method for calculating number of Complaints for an Appointment.
*/
trigger EON_Complaint_Trigger on EON_Complaint__c (after insert, after update, before insert, after delete) 
{
    //to by pass the trigger when mass transfering the records.
    if (System.Label.EON_Bypass_Mass_Transfer_Records == 'FALSE'){
        if(Trigger.isAfter && Trigger.isInsert )
            EON_Complaint_Trigger_Helper.sendEmailOnInsert(Trigger.New);

        if(Trigger.isAfter && Trigger.isUpdate )
            EON_Complaint_Trigger_Helper.sendEmailOnUpdate(trigger.oldMap, Trigger.newMap);
        
        //CH01.Start
        if(Trigger.isbefore && Trigger.isInsert)
            EON_Complaint_Trigger_Helper.UpdateComplaintfieldsFromAppointment(Trigger.New);
        //CH01.End   
        
        //CH02.Start
        if(Trigger.isAfter){
            if(Trigger.isInsert)
              EON_Complaint_Trigger_Helper.ComplaintCountOnAppointment(Trigger.New);
            if(Trigger.isDelete)
              EON_Complaint_Trigger_Helper.ComplaintCountOnAppointment(Trigger.Old);
              }
        //CH02.End            
    }
}