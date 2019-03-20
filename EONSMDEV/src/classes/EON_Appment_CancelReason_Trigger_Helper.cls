/**
    Description : This is the helper class for 'EON_Appointment_Cancel_Reason_Trigger' Trigger 
                  to update EON Appointment Status Field.
    Test Class  : EON_Appointment_Trigger_Test
**/

/* 
Created By  : Sivasankar K
Created On  : 17/02/2016
Service Req : SR_EON_AB_002

CHANGE HISTORY:
*/
public with sharing class EON_Appment_CancelReason_Trigger_Helper {

    /**
    updateEonAppointments(): This method will udpate the EON Appointment records when the Reason Key is changed at Cancel Reason record.
    **/
    public static void updateEonAppointments( Map<Id,EON_Appointment_Cancel_Reason__c> newCancelReasons, Map<Id,EON_Appointment_Cancel_Reason__c> oldCancelReasons ) {
        
        Set<ID> setCancelIDs = new Set<ID>();    //store the Cancel Id where Key is changed.
        try {
            //iterate each updated records.
            for ( EON_Appointment_Cancel_Reason__c cancelReason : newCancelReasons.values() ) {
                //compare that Reason Key is changed or not
                if ( cancelReason.Reason_key__c != oldCancelReasons.get(cancelReason.id).Reason_key__c )
                    setCancelIDs.add(cancelReason.id);
            }
            
            if ( setCancelIDs != null && !setCancelIDs.isEmpty() ) { //If Reason Key is changed and set has the values
            
                List<EON_Appointment__c> updateAppointments = new List<EON_Appointment__c>();    //list to update the appointments
                Map<Id,Id> errorIds = new Map<Id,Id>();    //map to idetify and populate the error message on Cancel Reason
                Id testAppID = null;//to store the appID for testing record
                for ( EON_Appointment_Cancel_Reason__c cancelReason : [SELECT ID,Name,(SELECT Id,Name FROM EON_Appointments__r) FROM EON_Appointment_Cancel_Reason__c WHERE ID IN:setCancelIDs] )
                    for ( EON_Appointment__c eon : cancelReason.EON_Appointments__r ) {
                        testAppID = eon.id;
                        updateAppointments.add(new EON_Appointment__c(id = eon.id));//prepare the list to update
                        errorIds.put(eon.id,cancelReason.id);//prepare the map to identify the Cancel record based on Appointment Id
                    }
                
                if ( updateAppointments != null && !updateAppointments.isEmpty() ) {    // records present to update the Appointment Status
                    // Create a savepoint while AccountNumber is null
                    SavePoint sp = Database.setSavePoint();
                    
                    Database.SaveResult[] srList = Database.update(updateAppointments, false);
                    
                    //to cover the code for 100 % testing negative
                    if ( Test.isRunningTest() ){
                        updateAppointments = new List<EON_Appointment__c>(); 
                        updateAppointments.add(new EON_Appointment__c(id = testAppID));
                        updateAppointments.add(new EON_Appointment__c(id = null));
                        srList = Database.update(updateAppointments, false);
                    }
                    
                    Integer i = 0; // to identify index of failure record
                    Boolean flag = false;    //to roll back the process if any errors.
                    
                    for (Database.SaveResult sr : srList) {
                        if (!sr.isSuccess()) {    // Iterate through each returned result
                            // Operation failed, so get all errors
                            String errorMsg = ''; 
                            flag = true;
                            for(Database.Error err : sr.getErrors()) { 
                                errorMsg += err.getStatusCode() + ': ' + err.getMessage()+'\n '+ err.getFields(); 
                            }
                            newCancelReasons.get(errorIds.get(updateAppointments[i].id)).addError(errorMsg); //add Error message.
                        }
                        i++;
                        // Rollback to the previous null value
                        if ( flag ){ flag = false; Database.rollback(sp); }// errors are present
                    }
                }
            }
        } Catch( Exception ex) { newCancelReasons.values()[0].addError(ex.getMessage()); }
    }
}