/**
    Description : This trigger is used to perform business logics with respect to EON_Appointment_Contact
    Test Class : EON_Appointment_Triger_VOICE_Helper_Test
**/
/*
    Created By : Praveen G
    Created Date : 19-July-2016
    Service Request : SR_EON_AB_073
    
*/
trigger EON_Appointment_Contact_Trigger on EON_Appointment_Contact__c (After insert , After Update) {

    if (System.Label.EON_Bypass_Mass_Transfer_Records == 'FALSE'){
        set<ID> setAppointmentID = new Set<ID>();
    
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
            for(EON_Appointment_Contact__c appContact : Trigger.NEW){
                if(appContact.EON_Appointment_ID__c != null)
                    setAppointmentID.add(appContact.EON_Appointment_ID__c);                
            }
            
            for(ID appId : setAppointmentID){
                EON_Appointment_Trigger_VOICE_Helper.sendInfoToVOICE(appId+'');
            }
        }
    }

}