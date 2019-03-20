/**
    Description :   This class is the scheduler which schedules the to send the Resource Availability to OFS                 
    Test Class  :   NGS_OFSC_Technician_getWorkSchedule_test
    
    //To execute in LIVE
    NGS_OFSC_Tech_getWorkSchedule_Scheduler sch = new NGS_OFSC_Tech_getWorkSchedule_Scheduler ();
    system.schedule('NGS_OFSC_Tech_getWorkSchedule_Scheduler','0 0 22 1/1 * ? *',sch);
**/
/*
    Created By  : Tashika Gupta
    Created On  : 24/03/2017
    Service Req : SR_OptiMUS_NG_023
    Change History
*/
global class NGS_OFSC_Tech_getWorkSchedule_Scheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
       NGS_OFSC_Technician_getWorkScheduleBatch objClass = new NGS_OFSC_Technician_getWorkScheduleBatch ();
       ID batchprocessid = Database.executeBatch(objClass,20);
   }
}