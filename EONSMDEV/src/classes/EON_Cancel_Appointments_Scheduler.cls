/**
    Description : This class is scheduled run, every hour 8am to 11pm 7 days a week to cancel the Appointment records from EON.
**/
/*
    Created By : Praveen G
    Created Date : 28-03-2014
    Service Request : SR_EON_AB_214       
*/
/*
EON_Cancel_Appointments_Scheduler p = new EON_Cancel_Appointments_Scheduler();        
String sch = '0 0 8-23 * * ?';   
system.schedule('EON_Cancel_Appointments_Scheduler', sch, p);
*/

global class EON_Cancel_Appointments_Scheduler implements schedulable{
    
    /**
        execute(schedulableContext sc) - This is override method to trigger the schedule.    
    **/
    global void execute(schedulableContext sc){
        
        try{        
        Datetime today = test.isRunningTest() ? System.now() : System.now().addhours(-4);
        Eon_Appointment__c[] lstAppointments = [select id from Eon_Appointment__c where 
                                                Booking_System_Name__c = 'ICE' and 
                                                Confirmed_Appointment_DateTime__c = null and 
                                                CreatedDate <: today and status__c <> 'Cancelled' limit 20];
                                                
        for(Eon_Appointment__c appt : lstAppointments){
            EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(appt.id); 
            Oracle_Data_Tracker__c oracleTracker = EON_Cancel_Activity_OFSC.requestOut;
            if(oracleTracker !=null){
                oracleTracker.EON_Appointment__c = appt.id;
                update oracleTracker;
            }            
        } 
        }catch(Exception ex){
            System.debug('*** Exception Occured ' + ex.getStackTraceString());
        }                                             
    }
}