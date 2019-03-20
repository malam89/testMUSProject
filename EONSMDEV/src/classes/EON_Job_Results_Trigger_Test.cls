/**
    Description : This Test Class covers the code for following classes/Triggers
    trigger:   EON_Job_Results_Trigger      
**/

/*
    created By : Shruti Moghe
    Created Date : 11-Apr-2016
    Service Request : SR_EON_AL_005
    
    Change History:
     CH01 - Praveen  - Added fields for abort reason category
    CH02 # SR_EON_Mobile_081 # 26/09/2016 # Mahadev # Updated code coverage.
*/
@isTest(SeeAllData=false)
private class EON_Job_Results_Trigger_Test{
    
    /**
         EON_Job_Results_Trigger_After:- AfterUpdate ans AfterInsert Unit test for trigger
    **/   
   
    static testMethod void EON_Job_Results_Trigger_After(){ 
    
        EON_Job_Results_Trigger_Helper.addPrecedingZeros('TEST', '6');   
        EON_Job_Results_Trigger_Helper.addPrecedingZeros('TEST', 'TEST');
         
        EON_Job_Results__c job1 = EON_CreateTestRecords.createEon_Job_Results();
        job1.E_Meter_Removed__c='';
        job1.G_Meter_Removed__c='';
        job1.E_Meter_Installed__c='';
        job1.G_Meter_Installed__c='';
        job1.New_Comms_Hub_Serial_Number__c = '0123456789';
        job1.New_E_Meter_Register_1_ID__c = '1';
        insert job1;
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,
                            New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,
                            New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,
                            Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c 
                            from EON_Job_Results__c limit 1];
                            
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=techlist[0].id;
        lstStocks.add(stock);
        }       
        insert lstStocks;
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        lstStocksupdate.add(stock);
        }
        update lstStocksupdate;
          test.startTest();
        job.New_Gas_Regulator_Serial_Number__c='2345';      
        job.New_G_Meter_Serial_Number__c='2345';
        job.New_E_Meter_Serial_Number__c='2345';
        update job;
        test.stopTest();
        job.Removed_Gas_Regulator_Serial_Number__c='12345';
        update job;
        job.Removed_G_Meter_Serial_Number__c='12345';
        update job;
        job.Removed_E_Meter_Serial_Number__c='12345';
        //Ch01.Start
        job.Abort_Category__c = 'Pre-Site';
        job.Abort_Reason__c = 'Pre Visit Customer Refusal';
        job.Abort_Sub_Reason__c = 'Site Not Ready';
        //Ch01.End
        update job;  
        
        //Praveen Start
        EON_SSC__c SSC = new EON_SSC__c();
        SSC.Name = '0000';
        SSC.Type__c = 'Classic';
        insert SSC;
        
        EON_SSC__c SSC1 = new EON_SSC__c();
        SSC1.Name = '0000';
        SSC1.Type__c = 'Classic';
        insert SSC1;        
        
        
        EON_SSC_Register__c register1 = new EON_SSC_Register__c();
        register1.Name = 'TESTSSC_Register';
        register1.SSC__c = SSC1.id;
        insert register1;
                
        EON_SSC_Register__c register = new EON_SSC_Register__c();
        register.Name = 'TESTSSC_Register';
        register.SSC__c = SSC.id;
        insert register;
        
        EON_Electric_Meter_Register__c meterRegister = new EON_Electric_Meter_Register__c();
        meterRegister.Name = 'TESTSSC_Register';
        insert meterRegister;
        
        job.Actual_SSC_Installed__c = SSC.Name;
        job.New_E_Meter_Type__c = 'MCL';
        job.New_E_Meter_Register_1_Type__c = meterRegister.id;
        
        List<EON_Job_Results__c> lstUpdateResults = new List<EON_Job_Results__c>();
                   
        EON_Job_Results__c job2 = new EON_Job_Results__c();
        job2.E_Meter_Removed__c='';
        job2.G_Meter_Removed__c='';
        job2.E_Meter_Installed__c='';
        job2.G_Meter_Installed__c='';
        insert job2;        
        
        
        job2.Actual_SSC_Installed__c = SSC1.Name;
        job2.New_E_Meter_Type__c = 'MCL';        
        
        lstUpdateResults.add(job2);
        lstUpdateResults.add(job);
         
        
        update lstUpdateResults;
        
        
        DateTime timeOnSite = System.now().addHours(-2);
        integer timeonsitehours = timeOnSite.Hour();
        integer timeonsiteMinutes = timeOnSite.Minute(); 
        String startTime = timeonsitehours + ':'+ timeonsiteMinutes;
        
        DateTime timeOnSite1 = System.now().addHours(6);
        integer timeonsitehours1 = timeOnSite.Hour();
        integer timeonsiteMinutes1 = timeOnSite.Minute(); 
        String endTime = timeonsitehours + ':'+ timeonsiteMinutes;
        
        String timeSlots =   startTime + '-' + endTime;                    
        
        //For No value
        String ontime = EON_Job_Results_Trigger_Helper.validateTimeSlots(startTime, endTime, '', System.now());
        String ontime1 = EON_Job_Results_Trigger_Helper.validateTimeSlots('', '', timeSlots, System.now());                
        
        
        DateTime timeOnSite2 = System.now().addHours(-2);
        integer timeonsitehours2 = timeOnSite2.Hour();
        integer timeonsiteMinutes2 = timeOnSite2.Minute(); 
        String startTime2 = timeonsitehours2 + ':'+ timeonsiteMinutes2;
        
        DateTime timeOnSite3 = System.now().addHours(6);
        integer timeonsitehours3 = timeOnSite3.Hour();
        integer timeonsiteMinutes3 = timeOnSite3.Minute(); 
        String endTime3 = timeonsitehours3 + ':'+ timeonsiteMinutes3;
        
        String timeSlots3 =   startTime2 + '-' + endTime3;          
        
        //For Yes Value
        String ontime2 = EON_Job_Results_Trigger_Helper.validateTimeSlots(startTime2, endTime3, '', System.now());
        String ontime3 = EON_Job_Results_Trigger_Helper.validateTimeSlots('', '', timeSlots3, System.now());        
        
        //For Exception
        String ontime5 = EON_Job_Results_Trigger_Helper.validateTimeSlots('junk:junk', 'junk:junk', 'junk - Junk', System.now());
        
        //For Yes Value
        String ontime6 = EON_Job_Results_Trigger_Helper.validateTimeSlotsForEchoORNight
                                                    (startTime2, endTime3, System.now(), System.today());
                                                    
        String ontime7 = EON_Job_Results_Trigger_Helper.validateTimeSlotsForEchoORNight
                                                    ('junk:junk', 'junk:junk', System.now(), System.today());   
                                                    
        //For Yes Value
        String ontime8 = EON_Job_Results_Trigger_Helper.validateTimeSlotsForEchoORNight
                                                    ('11:00', '03:00', System.now(), System.today());                                                                                                     
        //Praveen End     
        
        //CH02.New.Start
        Eon_Appointment_Reason__c appReason = new Eon_Appointment_Reason__c();
        appReason.Name = 'Statutory';
        appReason.Appointment_reason_code__c = 'Statutory';
        insert appReason;
        
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Time_Slot__c = '16:00 - 18:00';
        appt.Appointment_Date__c = date.today();
        appt.Start_Time__c = '16:00';
        appt.Start_Time__c = '18:00';
        appt.Appointment_reason_code__c = appReason.ID;
        insert appt;
        
        //Test 1
        job1.Job_Reference__c = appt.ID;
        job1.Time_On_Site__c = System.now();
        Update job1; //Test 1
        //CH02.New.End
        
        //Test 2
        job1.Gas_Reason_for_reverting_type__c = 'test';
        job1.Electricity_Reason_for_Reverting_type__c = 'test';
        update job1;
        
        //Test 3
        appReason.Name = 'New Connections';
        update appreason;
        job1.Electricity_Reason_for_Reverting_type__c = 'test1';
        update job1;
        
        //Test 4
        appReason.Name = 'Emergency Call Out';
        update appreason;
        job1.Electricity_Replacement_Reason__c = 'Equipment faulty';
        update job1; 
        
        //Test 5
        job1.Electricity_Replacement_Reason__c = 'Equipment Damaged';
        update job1; 
        
        //Test 6
        appReason.Name = 'test';
        update appreason;
        job1.Electricity_Replacement_Reason__c = 'test';
        job1.Pre_Work_DNO_Situation__c = 'No';
        update job1;
        
        appt.Time_Slot__c = 'ECO';
        update appt;
        
        update job1;        
        
    }
}