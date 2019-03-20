/**
    Description : This trigger is used for the logic : 
                Only allow date change if there are no related EON Appointment records else "Date cannot be changed as Appointments have already 
                been assigned. Please unassign appointments to be able to change the date of this hire"
                Test Class : EON_Mose_Hire_Trigger_Test
**/
/*
    Created By : Praveen G
    Created Date : 19-April-2016
    Service Request : SR_EON_AB_047
*/
trigger EON_Mose_Hire_Trigger on EON_MOSE_Hire__c (before update) {
    
    if(System.Label.EON_Bypass_Mass_Transfer_Records == 'FALSE')
        //This will return error if any date changed and Mose Hire record has any Appointment child records.
        EON_Mose_Hire_Trigger_Helper.validateDateChange(Trigger.newMap, Trigger.oldMap);
}