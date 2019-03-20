/**
    Description : This class is the test class for below Classes/Triggers
                  1)EON_MorrisonDate
**/
/*
    Created By : Tashika Gupta
    Created On : 07/06/2016
    Service Request : SR_EON_AL_016
    Change History :
    CH01 # CH01 # SR_EON_AL_026 # 03/08/2016 # Tashika Gupta # Updated the test class to cover the changes done as per the SR.
*/
@istest
public class EON_MorrisonDate_Test{
    public static testMethod void CalculatedFinishDatetest(){
        EON_Shutdown_Days__c holidaydate = EON_CreateTestRecords.createEon_ShutdownDays();
        insert holidaydate ;
        EON_MorrisonDate.CalculatedFinishDate(date.newInstance(2016,06,07),02);
        EON_MorrisonDate.CalculatedFinishDate(date.newInstance(2016,06,05),02);
        EON_MorrisonDate.CalculatedFinishDate(date.newInstance(2016,06,04),02);
        System.assertEquals(holidaydate.Holiday_Date__c,date.newInstance(2016,06,06));    
    
    }
}