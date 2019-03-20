/**
    Description : This class is used to help EON_OFSC_Receiving_Service based on the subject coming from OFSC.
                    These methods called from EON_OFSC_Receiving_Service class based on the subject.
    Test Class: EON_OFSC_Receiving_Helper_Test                    
**/

/*
    Created By : Praveen G
    Created Date : 18-April-2016
    Service Request : SR_EON_Scheduling_017
    CH01 # SR_EON_Mobile_041  # 19/07/2016 # Mahadev J # Added logic to clear Suspended DateTime at 'EON Appointment'  
    CH02 # SR_EON_Mobile_062  # 21/07/2016 # Mahadev J # Added logic to map field 'OFSC Appointment ID' from OFSC
    CH03 # SR_EON_Scheduling_040 #26/07/2016 # Praveen G # Added logic for Assign Appointment subject requests.
    CH04 # SR_EON_AB_188 #11/11/2016 # Praveen G # changed logic to identify the appointment record.
    CH05 # SR_EON_Scheduling_053 #27/01/2017 #Praveen G #Changed text from Isis to OptiMUS.
    CH06 # SR_OptiMUS_EON_142 #06/11/2017 #Praveen G #Changes for Replan flag update.
    CH07 # SR_OptiMUS_EON_196 #25/01/2018 #Shruti Moghe #Added logic to update the date/time.
    CH08 # SR_OptiMUS_EON_179 # 07/02/2018 # Praveen G # Replan changes. 
    CH09 # SR_OptiMUS_EON_210 # 13/02/2018 # Mehboob Alam # Search Appointment by MUS Appointment ID for Suspended Appointment. 
    CH10 # SR_OptiMUS_EON_233 # 21/03/2018 # Mehboob Alam # Not Updating Onsite DateTime and time if already populated. 
*/

public with sharing class EON_OFSC_Receiving_Helper{
    
    /**
        processSubjectAsAssignActivity(Map<String, String> mapRequest) - This method will be called when the subject is 'ASSIGN ACTIVITY'
            SR_EON_Scheduling_017
    **/
    public static EON_OFSC_Receiving_Service.message_response processSubjectAsAssignActivity(Map<String, String> mapRequest, id orackeDataTrackerID){
    
        try{
            String MUSAppointmentID = mapRequest.get('appointment_number');
            String activityIDForAPP = mapRequest.get('activity_id');
            if(activityIDForAPP != null){
                EON_Appointment__c[] appointment = [select id, Technician__c from EON_Appointment__c where h_aid__c =: activityIDForAPP];
                if(!appointment.isEmpty()){
                    String technicianID = mapRequest.get('tech_number');
                    //CH02.New.Start
                    String activityID = mapRequest.get('activity_id');
                    if(activityID != null)
                        appointment[0].OFSC_Appointment_ID__c = activityID;
                    //CH02.New.End
                    if(technicianID != null && technicianID != ''){
                        EON_Technician__c[] technician = [select id from EON_Technician__c where id=:technicianID];
                        if(!technician.isEmpty()){
                            appointment[0].Technician__c = technician[0].id;
                            update appointment[0];
                            updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                            return new EON_OFSC_Receiving_Service.message_response('', 'sent', 'Appointment updated with provided technician');
                        }else{
                            //CH03.Start
                            if(appointment[0].Technician__c != null){
                                appointment[0].Technician__c = null;
                                update appointment[0];    
                            }                            
                            //CH03.End                        
                            updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                            return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No Technician found in OptiMUS :' +technicianID);
                        }
                    }else{
                        appointment[0].Technician__c = null;
                        update appointment[0];
                        return new EON_OFSC_Receiving_Service.message_response('', 'sent', 'Appointment updated with no technician');                    
                    } 
                }else{
                    return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No Appointment record found in OptiMUS :' +MUSAppointmentID +' with the activityId '+activityIDForAPP);
                }
            }else{
                return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No MUSAppointmentID found in request');
            }
        }catch(Exception ex){
            System.debug('******Error ' + ex.getStackTraceString());
            return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'Error Occured while processing the request data : ' + ex.getMessage());
        }       
    }
    
    /**
        processSubjectAsStartAppointment(Map<String, String> mapRequest) - This method will be called when the subject is 'START APPOINTMENT'
            SR_EON_Scheduling_018
    **/
    public static EON_OFSC_Receiving_Service.message_response processSubjectAsStartAppointment(Map<String, String> mapRequest, id orackeDataTrackerID){
        try{
            String MUSAppointmentID = mapRequest.get('appointment_number');
            String activityIDForAPP = mapRequest.get('activity_id');
            if(activityIDForAPP != null){
                EON_Appointment__c[] appointment = [select id, Onsite_DateTime__c from EON_Appointment__c where h_aid__c =: activityIDForAPP];
                if(!appointment.isEmpty()){
                    //String onsiteDate = mapRequest.get('date');//CH07.old
                    //String onsiteTime = mapRequest.get('start_time');//CH07.old
                     String onsiteDate = mapRequest.get('update_date');//Ch07.new
                    String onsiteTime = mapRequest.get('update_time');//CH07.new
                    if(onsiteDate != null && onsiteTime != null){
                    	if(EON_Utility.validateRequired(appointment[0].Onsite_DateTime__c)){ //CH10
                           DateTime onsiteDateTime = Datetime.valueOf(onsiteDate + ' ' + onsiteTime + ':00');
                           appointment[0].Onsite_DateTime__c = onsiteDateTime;
                    	}
                        appointment[0].Suspended_DateTime__c = null;  //CH01.New
                        update appointment[0];
                        updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                        return new EON_OFSC_Receiving_Service.message_response('', 'sent', 'Appointment updated with start appointment date time');
                    }else{
                        updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                        return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No Date or time found in request');
                    }
                }else{
                    return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No Appointment record found in OptiMUS :' +MUSAppointmentID);
                }
            }else{
                return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No MUSAppointmentID found in request');
            }
        }catch(Exception ex){
            System.debug('******Error ' + ex.getStackTraceString());
            return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'Error Occured while processing the request data : ' + ex.getMessage());
        }
    }     
    
    
    /**
        processSubjectAsSuspendAppointment(Map<String, String> mapRequest) - This method will be called when the subject is 'SUSPEND APPOINTMENT'
            SR_EON_Scheduling_019
    **/
    public static EON_OFSC_Receiving_Service.message_response processSubjectAsSuspendAppointment(Map<String, String> mapRequest, id orackeDataTrackerID){
        try{
            String MUSAppointmentID = mapRequest.get('appointment_number');
            String activityIDForAPP = mapRequest.get('activity_id');
            if(activityIDForAPP != null){
                EON_Appointment__c[] appointment = [select id, Suspended_DateTime__c from EON_Appointment__c where Name =: MUSAppointmentID];
                if(!appointment.isEmpty()){
                    //String suspendDate = mapRequest.get('date');//Ch07.old
                    //String suspendTime = mapRequest.get('suspend_time');//Ch07.old
                    String suspendDate = mapRequest.get('update_date');//Ch07.new
                    String suspendTime = mapRequest.get('update_time');//CH07.new
                    if(suspendDate != null && suspendTime != null){
                        DateTime suspendDateTime = Datetime.valueOf(suspendDate + ' ' + suspendTime + ':00');
                        appointment[0].Suspended_DateTime__c = suspendDateTime;
                        update appointment[0];
                        updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                        return new EON_OFSC_Receiving_Service.message_response('', 'sent', 'Appointment updated with suspend date time');
                    }else{
                        updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                        return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No suspend date or time found in request');
                    }
                }else{
                    return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No Appointment record found in OptiMUS :' +MUSAppointmentID);
                }
            }else{
                return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No MUSAppointmentID found in request');
            }    
        }catch(Exception ex){
            System.debug('******Error ' + ex.getStackTraceString());
            return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'Error Occured while processing the request data : ' + ex.getMessage());
        }
    }
        
    /**
        processSubjectAsNotDoneAppointment(Map<String, String> mapRequest) - This method will be called when the subject is 'NOT DONE APPOINTMENT'
            SR_EON_Scheduling_020
    **/
    public static EON_OFSC_Receiving_Service.message_response processSubjectAsNotDoneAppointment(Map<String, String> mapRequest, id orackeDataTrackerID){
        try{
            String MUSAppointmentID = mapRequest.get('appointment_number');
            String activityIDForAPP = mapRequest.get('activity_id');
            if(activityIDForAPP != null){
                EON_Appointment__c[] appointment = [select id, Abort_Datetime__c 
                                                    ,Appointment_reason_code__r.Name// CH08
                                            from EON_Appointment__c where h_aid__c =: activityIDForAPP];
                if(!appointment.isEmpty()){
                    //String notDoneDate = mapRequest.get('date');//CH07.old
                    //String notDoneTime = mapRequest.get('notdone_time');//CH07.old
                    String notDoneDate = mapRequest.get('update_date');//Ch07.new
                    String notDoneTime = mapRequest.get('update_time');//CH07.new
                    if(notDoneDate != null && notDoneTime != null){
                        DateTime notDoneDateTime = Datetime.valueOf(notDoneDate + ' ' + notDoneTime + ':00');
                        appointment[0].Abort_Datetime__c = notDoneDateTime;
                        
                        //CH06.Start
                        if(isReplanPopulate(mapRequest)){
                            if(appointment[0].Appointment_reason_code__r.Name 
                                                        != 'New Connections') //CH08
                                appointment[0].Replan__c = 'Y';
                            else
                                appointment[0].Replan__c = 'N'; //CH08
                            appointment[0].h_Abort_Description__c = mapRequest.get('abort_subreason_description');                            
                        }else
                            appointment[0].Replan__c = 'N';    
                        //CH06.End
                        
                        appointment[0].Replan_Comments__c = mapRequest.get('abort_comments'); //CH08
                        
                        update appointment[0];
                        updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                        
                        //Create Job Result and Fault Asset records for appointment.
                        EON_OFSC_Process_Job_Results_Helper.processJobResults(mapRequest, appointment[0].id);
                        return new EON_OFSC_Receiving_Service.message_response('', 'sent', 'Appointment updated with Not Done date time');
                    }else{
                        updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                        return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No Date or time found in request');
                    }
                }else{
                    return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No Appointment record found in OptiMUS :' +MUSAppointmentID);
                }
            }else{
                return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No MUSAppointmentID found in request');
            }
        }catch(Exception ex){
            System.debug('******Error ' + ex.getStackTraceString());
            return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'Error Occured while processing the request data : ' + ex.getMessage());
        }
    } 
    

    /**
        processSubjectAsCompleteAppointment(Map<String, String> mapRequest) - This method will be called when the subject is 'COMPLETE APPOINTMENT'
            SR_EON_Scheduling_021
    **/
    public static EON_OFSC_Receiving_Service.message_response processSubjectAsCompleteAppointment(Map<String, String> mapRequest, id orackeDataTrackerID){
        try{
            String MUSAppointmentID = mapRequest.get('appointment_number');
            String activityIDForAPP = mapRequest.get('activity_id');
            if(activityIDForAPP != null){
                EON_Appointment__c[] appointment = [select id, Complete_DateTime__c from EON_Appointment__c where h_aid__c =: activityIDForAPP];
                if(!appointment.isEmpty()){
                    String completeDate = mapRequest.get('update_date');
                    String completeTime = mapRequest.get('update_time');
                    if(completeDate != null && completeTime != null){
                        //Create Job Result and Fault Asset records for appointment.
                        updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                        EON_OFSC_Process_Job_Results_Helper.processJobResults(mapRequest, appointment[0].id);
                        
                        DateTime completeDateTime = Datetime.valueOf(completeDate + ' ' + completeTime + ':00');                        
                        appointment[0].Complete_DateTime__c = completeDateTime;
                        update appointment[0];                                                
                        
                        return new EON_OFSC_Receiving_Service.message_response('', 'sent', 'Appointment updated with Complete date time');
                    }else{
                        updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                        return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No Date or time found in request');
                    }
                }else{
                    return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No Appointment record found in OptiMUS :' +MUSAppointmentID);
                }
            }else{
                return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'No MUSAppointmentID found in request');
            }
        }catch(Exception ex){
            System.debug('******Error ' + ex.getStackTraceString());
            return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'Error Occured while processing the request data : ' + ex.getMessage());
        }
    }
    
    /**
        processSubjectAsCancelAppointment(Map<String, String> mapRequest) - This method will be called when the subject is 'CANCEL APPOINTMENT'
            SR_EON_Scheduling_033
    **/
    public static void processSubjectAsCancelAppointment(Map<String, String> mapRequest, id orackeDataTrackerID){
        try{
            String MUSAppointmentID = mapRequest.get('appointment_number');
            String activityIDForAPP = mapRequest.get('activity_id');
            if(activityIDForAPP != null){
                EON_Appointment__c[] appointment = [select id from EON_Appointment__c where h_aid__c =: activityIDForAPP];
                if(!appointment.isEmpty()){
                    updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                }
            }else{
                System.debug('**** No MUSAppointmentID found in request');
            }
        }catch(Exception ex){
            System.debug('******Error ' + ex.getStackTraceString());
            //return new EON_OFSC_Receiving_Service.message_response('', 'failed', 'Error Occured while processing the request data : ' + ex.getMessage());
        }        
    }     
    
    /**
        updateOrackeDataTracker(Id trackerID, id appointmentID) - This method updates the Oracke Data Tracker record with appointment id
    **/        
    public static void updateOrackeDataTracker(Id trackerID, id appointmentID){
        Oracle_Data_Tracker__c ODT = new Oracle_Data_Tracker__c(id = trackerID);
        ODT.EON_Appointment__c = appointmentID;
        update ODT;
    }
    
    //CH06.Start
    /**
        isReplanPopulate(Map<String, String> mapRequest) - This method is for to deside replan
            flag on Appointment should populated or not based on Abort Sub Reason.
    **/
    public static boolean isReplanPopulate(Map<String, String> mapRequest){
        String subReason = mapRequest.get('abort_subreason_description');
        Set<String> lstCSReasons = EON_Abort_Reason_Replan__c.getall().keySet();
        if(subReason != null && lstCSReasons.contains(subReason)){
            return true;
        }
        return false;
    }
    //CH06.End
}