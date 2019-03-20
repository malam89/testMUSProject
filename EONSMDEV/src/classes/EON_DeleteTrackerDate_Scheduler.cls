/**
    Description : This class is used for EON Job Results object trigger helper.
    Test Class : EON_DeleteTrackerDate_Scheduler_Test
    
EON_DeleteTrackerDate_Scheduler sch= new EON_DeleteTrackerDate_Scheduler();
String cronString='0 0 10 ? * SUN *';
String jobID = System.schedule('EON DeleteTrackerData Scheduler On Sunday @10 AM', cronString, sch);

    
**/

/*    
    Created By : Manish Jha
    Created Date : 26/10/2017
    Service Request : SR_OptiMUS_EON_118
   
    
*/
global class EON_DeleteTrackerDate_Scheduler implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        EON_DeleteData_Oracle_Data_Tracker oracle = new EON_DeleteData_Oracle_Data_Tracker();
        EON_DeleteData_JUMBO_Data_Tracker  Jumbo= new EON_DeleteData_JUMBO_Data_Tracker();
        EON_DeleteData_EON_Data_Tracker   EON= new EON_DeleteData_EON_Data_Tracker();
        EON_DeleteData_Voice_Data_Tracker voice= new EON_DeleteData_Voice_Data_Tracker();
        EON_DeleteData_MIDOS_Data_Tracker MIDOS= new EON_DeleteData_MIDOS_Data_Tracker();

        Database.executeBatch(oracle,10);
        Database.executeBatch(Jumbo,10);
        Database.executeBatch(EON,10);
        Database.executeBatch(voice,10);
        Database.executeBatch(MIDOS,10);

    }
}