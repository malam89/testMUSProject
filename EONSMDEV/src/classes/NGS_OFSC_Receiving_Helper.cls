/**
    Description : This class is used to help NGS_OFSC_Receiving_Service based on the subject coming from OFSC.
                    These methods called from NGS_OFSC_Receiving_Service class based on the subject.
    Test Class: NGS_OFSC_Receiving_Service_Test                    
**/

/*
    Created By : Shruti Moghe
    Created Date : 24/03/2017
    Service Request : SR_OptiMUS_NG_013
    CH01 #SR_OptiMUS_NG_044 #08/05/2017 #Shruti Moghe #Commented code as S3 will be sent from batch class
    CH02 #SR_OptiMUS_NG_047 #18/05/2017 #Shruti Moghe #Added the logic to send the S3 call in real time when Acceptance =false
    CH03 #SR_OptiMUS_NG_048 #01/06/2017 #Shruti Moghe #update the mapping of start and end time
    CH04 # SR_OptiMUS_NG_051 # 20/06/2017  # Shruti Moghe # Added condition for rejected appointment logic
    

*/

public with sharing class NGS_OFSC_Receiving_Helper{
    
    /**
        processSubjectAsAssignActivity(Map<String, String> mapRequest) - This method will be called when the subject is 'ASSIGN ACTIVITY'
            
    **/
    public static NGS_OFSC_Receiving_Service.message_response processSubjectAsAssignActivity(Map<String, String> mapRequest, id orackeDataTrackerID){
        boolean acceptance = true;
        try{
            String MUSAppointmentID = mapRequest.get('appointment_number');
            String activityIDForAPP = mapRequest.get('activity_id');
            if(activityIDForAPP != null){
                NGS_Work_Order_Appointment__c[] appointment = [select id, Employee_ID__c,MUS_Rejection_Notes__c,Appointment_Start_Time__c,Scheduled_End__c,Scheduled_Start__c,Appointment_Finish_Time__c,Duration__c from NGS_Work_Order_Appointment__c where Oracle_Activity_ID__c =: activityIDForAPP];//CH03
                if(!appointment.isEmpty()){
                    String technicianID = mapRequest.get('tech_number');
                    String activityID = mapRequest.get('activity_id');
                    if(activityID != null)
                        appointment[0].Oracle_Activity_ID__c = activityID;
                     Utility.ByPassOFSCUpdate =false;
                    if(technicianID != null && technicianID != ''){             
                        NGS_Technician__c[] technician = [select id,name, Technician_Name__c from NGS_Technician__c where id=:technicianID];
                        if(!technician.isEmpty()){
                            appointment[0].Employee_ID__c = technician[0].id;
                            appointment[0].MUS_Rejection_Notes__c = mapRequest.get('XA_Reject_Notes');//CH04.old
                            DateTime date1 = appointment[0].Appointment_Start_Time__c;//CH03
                            List<String> arrStr = new List<String>();
                            arrStr = mapRequest.get('activity_start_time').split(':');
                            //appointment[0].Appointment_Start_Time__c = DateTIme.NewInstance(date1.date(),Time.NewInstance(Integer.valueof(arrStr[0]),Integer.valueof(arrStr[1]),0,0));//CH03.old
                            appointment[0].Scheduled_Start__c = DateTIme.NewInstance(date1.date(),Time.NewInstance(Integer.valueof(arrStr[0]),Integer.valueof(arrStr[1]),0,0));//CH03.new
                            date1 = appointment[0].Appointment_Finish_Time__c; //CH03
                            arrStr = new List<String>();
                            arrStr = mapRequest.get('activity_end_time').split(':');
                            //appointment[0].Appointment_Finish_Time__c = DateTIme.NewInstance(date1.date(),Time.NewInstance(Integer.valueof(arrStr[0]),Integer.valueof(arrStr[1]),0,0));//CH03.old
                            appointment[0].Scheduled_End__c = DateTIme.NewInstance(date1.date(),Time.NewInstance(Integer.valueof(arrStr[0]),Integer.valueof(arrStr[1]),0,0));//CH03.new
                            appointment[0].h_IFS_Duration__c =  appointment[0].Duration__c ;
                            appointment[0].Duration__c = String.valueof((Integer.valueof(mapRequest.get('length'))/60)) +':'+String.valueof((Integer.valueof(mapRequest.get('length'))>60 ? Integer.valueof(mapRequest.get('length'))-(60*(Integer.valueof(mapRequest.get('length'))/60)) : Integer.valueof(mapRequest.get('length'))));
                            if(technician[0].Technician_Name__c=='Rejected Rejected'){
                            //CH04.start
                                if(String.isblank(mapRequest.get('XA_Reject_Notes')) ) appointment[0].MUS_Rejection_Notes__c=(appointment[0].MUS_Rejection_Notes__c!='' && appointment[0].MUS_Rejection_Notes__c!=null ?appointment[0].MUS_Rejection_Notes__c+', ':'')+String.valueof(system.today().format())+'-'+ 'Appointment cannot be fulfilled';
                                else
                                 appointment[0].MUS_Rejection_Notes__c=(appointment[0].MUS_Rejection_Notes__c!='' && appointment[0].MUS_Rejection_Notes__c!=null ?appointment[0].MUS_Rejection_Notes__c+', ':'')+String.valueof(system.today().format())+'-'+ mapRequest.get('XA_Reject_Notes');
                                acceptance=false;
                            //CH04.end
                            }      
                            update appointment[0];
                            updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                            if(acceptance==false) NGS_S3_Send_WO_Assignment_to_IFS.Sent_WO_Assignment_future(acceptance,appointment[0].id);//CH01//CH02
                            return new NGS_OFSC_Receiving_Service.message_response('', 'sent', 'Appointment updated with provided technician');
                        }else{
                            if(appointment[0].Employee_ID__c != null){
                                appointment[0].Employee_ID__c = null;
                                update appointment[0];    
                            }                                                  
                            updateOrackeDataTracker(orackeDataTrackerID, appointment[0].id);
                            return new NGS_OFSC_Receiving_Service.message_response('', 'failed', 'No Technician found in OptiMUS :' +technicianID);
                        }
                    }else{
                        appointment[0].Employee_ID__c = null;
                        update appointment[0];
                        return new NGS_OFSC_Receiving_Service.message_response('', 'sent', 'Appointment updated with no technician');                    
                    } 
                }else{
                    return new NGS_OFSC_Receiving_Service.message_response('', 'failed', 'No Appointment record found in OptiMUS :' +MUSAppointmentID +' with the activityId '+activityIDForAPP);
                }
            }else{
                return new NGS_OFSC_Receiving_Service.message_response('', 'failed', 'No MUSAppointmentID found in request');
            }
        }catch(Exception ex){
            System.debug('******Error ' + ex.getStackTraceString());
            return new NGS_OFSC_Receiving_Service.message_response('', 'failed', 'Error Occured while processing the request data : ' + ex.getMessage());
        }       
    }
    
     /**
        updateOrackeDataTracker(Id trackerID, id appointmentID) - This method updates the Oracke Data Tracker record with appointment id
    **/        
    public static void updateOrackeDataTracker(Id trackerID, id appointmentID){
        NGS_Oracle_Data_Tracker__c ODT = new NGS_Oracle_Data_Tracker__c(id = trackerID);
        ODT.Works_Order__c = appointmentID;
        update ODT;
    }
}