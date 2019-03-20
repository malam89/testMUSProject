/**
    Description :   This class is the scheduler which schedules the to send the WO Appointment Assignment to OFS                 
    Test Class  :   NGS_S3_Send_WOAssignment_Batch_test
    
    //To execute in LIVE
    NGS_S3_Send_WOAssignment_Batch_Scheduler sch = new NGS_S3_Send_WOAssignment_Batch_Scheduler();
    system.schedule('NGS_S3_Send_WOAssignment_toIFS','0 0 16 1/1 * ? *',sch);
**/
/*
    Created By  : Shruti Moghe
    Created On  : 10/05/2017
    Service Req : SR_OptiMUS_NG_044
    Change History

*/
global class NGS_S3_Send_WOAssignment_Batch_Scheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
       NGS_S3_Send_WOAssignment_Batch objClass = new NGS_S3_Send_WOAssignment_Batch();
       ID batchprocessid = Database.executeBatch(objClass,1);
   }
}