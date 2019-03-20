/**
    Description : This class is used to implement logic for the trigger : EON_Mose_Hire_Trigger
                    Test Class : EON_Mose_Hire_Trigger_Test
**/
/*
    Created By : Praveen G
    created Date : 19-April-2016
    Service Request : SR_EON_AB_047
*/

public with sharing class EON_Mose_Hire_Trigger_Helper{

    /**
        validateDateChange(MAP<id, EON_MOSE_Hire__c> mapTriggerNew, MAP<id, EON_MOSE_Hire__c> mapTriggerOld) - 
            This method is used to validate the date if changed and called from trigger.
    **/
    public static void validateDateChange(MAP<id, EON_MOSE_Hire__c> mapTriggerNew, MAP<id, EON_MOSE_Hire__c> mapTriggerOld){
        
        try{
        List<id> lstMoseHireID = new List<id>();
        for(EON_MOSE_Hire__c moseHire : mapTriggerNew.values()){
            if(moseHire.Date__c != mapTriggerold.get(moseHire.id).Date__c)
                lstMoseHireID.add(moseHire.id);
        }
        
        for(EON_Mose_Hire__c moseHire :  [select id, (select id from EON_Appointments__r limit 1) 
                                                from EON_MOSE_Hire__c where id in : lstMoseHireID]){
            if(!moseHire.EON_Appointments__r.isEmpty())
                mapTriggerNew.get(moseHire.id).addError('Date cannot be changed as Appointments have already been assigned. Please unassign appointments to be able to change the date of this hire');
        } 
        }catch(Exception ex){
            System.debug('Exception occured ' + ex.getMessage());
            mapTriggerNew.get(mapTriggerNew.values()[0].id).addError('Error occured during this process. Please contact your administrator');
        }                       
    }
}