/**
Description:  . This is Trigger is used to update the EON Stock records based on this conditions.
                1. When Eon faulty Asset Serial Number and Eon Stock Serial Number are matched.
                2. When Eon Stock techinision field and Eon Appointment Techinision field is matched.

Helper Class  : EON_Ceva_Stock_Reconciliation_Process 
Test Class    : EON_Fault_Asset_Trigger_Test

**/
/* 
Created By    : Kondal
Created On    : 30/03/2016
Service Req   : SR_EON_AL_008

CHANGE HISTORY: 
*/

trigger EON_Fault_Asset_Trigger on EON_Faulty_Asset__c ( after insert, after update) 
{
    if (System.Label.EON_Bypass_Mass_Transfer_Records.equalsIgnoreCase('False'))
    {
         if (Trigger.isafter) 
         {
            
            EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_FaultyAsset(trigger.new,true);
        } 
    }  
  }