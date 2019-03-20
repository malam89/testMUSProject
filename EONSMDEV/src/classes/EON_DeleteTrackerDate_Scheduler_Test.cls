@isTest(SeeAllData=true)
public class EON_DeleteTrackerDate_Scheduler_Test{

    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    public static Boolean genException;
    

    static testmethod void testScheduledJob() { 
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new EON_DeleteTrackerDate_Scheduler());         
        Test.stopTest();
 
    }
    
     static testmethod void testHandleException(){
       genException=true;
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new EON_DeleteTrackerDate_Scheduler());         
        Test.stopTest();
 
     }
}