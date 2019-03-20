/**
    Description  :  This is the test class for NGS_S2_WO_Appointment_WS
**/
/*
    Created By : Puneet Mehta
    Created Date : 09/02/2017
    Service Request : SR_OptiMUS_NG_010
*/
@isTest
global class NGS_S2_WO_Appointment_WS_test{
    /*
        newSmartTest(): 
    */
    static testmethod void newSmartTest(){
        NGS_Job_Code__c ngsJobCode = new NGS_Job_Code__c(name = '12345', Bucket_Type__c  = 'Smart' ,Job_Type__c = 'Smart', Job_Description__c = 'Accuracy Attend (Electric)');
        insert ngsJobCode;
        
        NGS_Region__c ngsRegion = new NGS_Region__c(name  = 'Southern');
        insert ngsRegion;
        
        NGS_Sub_Region__c subRegion = new NGS_Sub_Region__c(Smart__c = true, Oracle_Bucket_ID__c = 'SN_001', name = 'Southern Area 1', Region__c = ngsRegion.id);
        insert subRegion;
        
        NGS_Postcode__c ngsPCinst = new NGS_Postcode__c (name = 'SG1 2', sub_region__c  = subRegion.id);
        insert ngsPCinst;
        
        NGS_S2_WO_Appointment_WS.JobElement jobE = new NGS_S2_WO_Appointment_WS.JobElement();
        jobE.WORK_ORDER_NUMBER = '111';
        jobE.JOB_ID = '12345';
        jobE.JOB_DESCRIPTION = 'test';
        
        list<NGS_S2_WO_Appointment_WS.JobElement> jeLst = new list<NGS_S2_WO_Appointment_WS.JobElement>();
        jeLst.add(jobE);

        NGS_S2_WO_Appointment_WS.JobsElement jobsEl = new NGS_S2_WO_Appointment_WS.JobsElement();
        jobsEl.Job = jeLst;
        
        NGS_S2_WO_Appointment_WS.NoteElement noteE = new NGS_S2_WO_Appointment_WS.NoteElement();
        noteE.WORK_ORDER_NUMBER = '111';
        noteE.NOTE_TYPE = 'type';
        noteE.NOTE_TEXT = 'test';
        
        List<NGS_S2_WO_Appointment_WS.NoteElement> noteLst = new List<NGS_S2_WO_Appointment_WS.NoteElement>();
        noteLst.add(noteE);
        
        NGS_S2_WO_Appointment_WS.NotesElement noteEles = new NGS_S2_WO_Appointment_WS.NotesElement();
        noteEles.Note = noteLst;
        
        NGS_S2_WO_Appointment_WS.LocationElement locE = new NGS_S2_WO_Appointment_WS.LocationElement();
        locE.WORK_ORDER_NUMBER = '111';
        locE.ADDR_LINE_1 = 'add1';
        locE.ADDR_LINE_2 = 'add2';
        locE.CITY = 'city';
        locE.COUNTY = 'county';
        locE.POST_CODE = 'SG1 2ST';
        locE.COUNTRY = 'GB';
        locE.LATITUDE = 1.0;
        locE.LONGITUDE = 1.0;
        
        NGS_S2_WO_Appointment_WS.LocationsElement locEles = new NGS_S2_WO_Appointment_WS.LocationsElement();
        locEles.Location = locE;
        
        NGS_S2_WO_Appointment_WS.ActivityElement activE = new NGS_S2_WO_Appointment_WS.ActivityElement();
        activE.WORK_ORDER_NUMBER = '111';
        activE.CHANGE_TYPE = 'NEW';
        activE.APPT_START_TIME = SYSTEM.NOW();
        activE.APPT_FINISH_TIME = SYSTEM.NOW() + 1;
        activE.APPOINTMENT_TYPE = 'county';
        activE.MESSAGE_DATE = SYSTEM.NOW();
        activE.MPAN = '1';
        activE.MPRN = '1';
        activE.DURATION = '1.0';
        activE.SERVICE_PROVIDER = 'SP02';
        
        NGS_S2_WO_Appointment_WS.ActivitiesElement actiEles = new NGS_S2_WO_Appointment_WS.ActivitiesElement();
        actiEles.Activity = activE;
        
        NGS_S2_WO_Appointment_WS.WORK_ORDER_APPOINTMENT workOrderEle = new NGS_S2_WO_Appointment_WS.WORK_ORDER_APPOINTMENT();
        workOrderEle.Activities = actiEles;
        workOrderEle.Locations = locEles;
        workOrderEle.Notes = noteEles;
        workOrderEle.Jobs = jobsEl;
        
        Test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
        NGS_S2_WO_Appointment_WS.S2_WORK_ORDER_APPOINTMENTResponse response = NGS_S2_WO_Appointment_WS.S2_webservice_WOR_ORDER_APPOINTMENT_Binder_S2_WORK_ORDER_APPOINTMENT(workOrderEle);
    }
    /*
        newDefaultTest(): 
    */
    static testmethod void newDefaultTest(){
        NGS_Job_Code__c ngsJobCode = new NGS_Job_Code__c(name = '12345', Bucket_Type__c  = 'Default' ,Job_Type__c = 'Smart', Job_Description__c = 'Accuracy Attend (Electric)');
        insert ngsJobCode;
        
        NGS_Region__c ngsRegion = new NGS_Region__c(name  = 'Southern');
        insert ngsRegion;
        
        NGS_Sub_Region__c subRegion = new NGS_Sub_Region__c(Default__c = true, Oracle_Bucket_ID__c = 'SN_001', name = 'Southern Area 1', Region__c = ngsRegion.id);
        insert subRegion;
        
        NGS_Postcode__c ngsPCinst = new NGS_Postcode__c (name = 'SG1 2', sub_region__c  = subRegion.id);
        insert ngsPCinst;
        
        NGS_S2_WO_Appointment_WS.JobElement jobE = new NGS_S2_WO_Appointment_WS.JobElement();
        jobE.WORK_ORDER_NUMBER = '111';
        jobE.JOB_ID = '12345';
        jobE.JOB_DESCRIPTION = 'test';
        
        list<NGS_S2_WO_Appointment_WS.JobElement> jeLst = new list<NGS_S2_WO_Appointment_WS.JobElement>();
        jeLst.add(jobE);

        NGS_S2_WO_Appointment_WS.JobsElement jobsEl = new NGS_S2_WO_Appointment_WS.JobsElement();
        jobsEl.Job = jeLst;
        
        NGS_S2_WO_Appointment_WS.NoteElement noteE = new NGS_S2_WO_Appointment_WS.NoteElement();
        noteE.WORK_ORDER_NUMBER = '111';
        noteE.NOTE_TYPE = 'type';
        noteE.NOTE_TEXT = 'test';
        
        List<NGS_S2_WO_Appointment_WS.NoteElement> noteLst = new List<NGS_S2_WO_Appointment_WS.NoteElement>();
        noteLst.add(noteE);
        
        NGS_S2_WO_Appointment_WS.NotesElement noteEles = new NGS_S2_WO_Appointment_WS.NotesElement();
        noteEles.Note = noteLst;
        
        NGS_S2_WO_Appointment_WS.LocationElement locE = new NGS_S2_WO_Appointment_WS.LocationElement();
        locE.WORK_ORDER_NUMBER = '111';
        locE.ADDR_LINE_1 = 'add1';
        locE.ADDR_LINE_2 = 'add2';
        locE.CITY = 'city';
        locE.COUNTY = 'county';
        locE.POST_CODE = 'SG1 2ST';
        locE.COUNTRY = 'GB';
        locE.LATITUDE = 1.0;
        locE.LONGITUDE = 1.0;
        
        NGS_S2_WO_Appointment_WS.LocationsElement locEles = new NGS_S2_WO_Appointment_WS.LocationsElement();
        locEles.Location = locE;
        
        NGS_S2_WO_Appointment_WS.ActivityElement activE = new NGS_S2_WO_Appointment_WS.ActivityElement();
        activE.WORK_ORDER_NUMBER = '111';
        activE.CHANGE_TYPE = 'NEW';
        activE.APPT_START_TIME = SYSTEM.NOW();
        activE.APPT_FINISH_TIME = SYSTEM.NOW() + 1;
        activE.APPOINTMENT_TYPE = 'county';
        activE.MESSAGE_DATE = SYSTEM.NOW();
        activE.MPAN = '1';
        activE.MPRN = '1';
        activE.DURATION = '1.0';
        activE.SERVICE_PROVIDER = 'SP02';
        
        NGS_S2_WO_Appointment_WS.ActivitiesElement actiEles = new NGS_S2_WO_Appointment_WS.ActivitiesElement();
        actiEles.Activity = activE;
        
        NGS_S2_WO_Appointment_WS.WORK_ORDER_APPOINTMENT workOrderEle = new NGS_S2_WO_Appointment_WS.WORK_ORDER_APPOINTMENT();
        workOrderEle.Activities = actiEles;
        workOrderEle.Locations = locEles;
        workOrderEle.Notes = noteEles;
        workOrderEle.Jobs = jobsEl;
        
        Test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
        NGS_S2_WO_Appointment_WS.S2_WORK_ORDER_APPOINTMENTResponse response = NGS_S2_WO_Appointment_WS.S2_webservice_WOR_ORDER_APPOINTMENT_Binder_S2_WORK_ORDER_APPOINTMENT(workOrderEle);
    }
    
    /*
        newMaintenanceTest(): 
    */
    static testmethod void newMaintenanceTest(){
        NGS_Job_Code__c ngsJobCode = new NGS_Job_Code__c(name = '12345', Bucket_Type__c  = 'Maintenance' ,Job_Type__c = 'Smart', Job_Description__c = 'Accuracy Attend (Electric)');
        insert ngsJobCode;
        
        NGS_Region__c ngsRegion = new NGS_Region__c(name  = 'Southern');
        insert ngsRegion;
        
        NGS_Sub_Region__c subRegion = new NGS_Sub_Region__c(Maintenance__c = true, Oracle_Bucket_ID__c = 'SN_001', name = 'Southern Area 1', Region__c = ngsRegion.id);
        insert subRegion;
        
        NGS_Postcode__c ngsPCinst = new NGS_Postcode__c (name = 'SG1 2', sub_region__c  = subRegion.id);
        insert ngsPCinst;
        
        NGS_S2_WO_Appointment_WS.JobElement jobE = new NGS_S2_WO_Appointment_WS.JobElement();
        jobE.WORK_ORDER_NUMBER = '111';
        jobE.JOB_ID = '12345';
        jobE.JOB_DESCRIPTION = 'test';
        
        list<NGS_S2_WO_Appointment_WS.JobElement> jeLst = new list<NGS_S2_WO_Appointment_WS.JobElement>();
        jeLst.add(jobE);

        NGS_S2_WO_Appointment_WS.JobsElement jobsEl = new NGS_S2_WO_Appointment_WS.JobsElement();
        jobsEl.Job = jeLst;
        
        NGS_S2_WO_Appointment_WS.NoteElement noteE = new NGS_S2_WO_Appointment_WS.NoteElement();
        noteE.WORK_ORDER_NUMBER = '111';
        noteE.NOTE_TYPE = 'type';
        noteE.NOTE_TEXT = 'test';
        
        List<NGS_S2_WO_Appointment_WS.NoteElement> noteLst = new List<NGS_S2_WO_Appointment_WS.NoteElement>();
        noteLst.add(noteE);
        
        NGS_S2_WO_Appointment_WS.NotesElement noteEles = new NGS_S2_WO_Appointment_WS.NotesElement();
        noteEles.Note = noteLst;
        
        NGS_S2_WO_Appointment_WS.LocationElement locE = new NGS_S2_WO_Appointment_WS.LocationElement();
        locE.WORK_ORDER_NUMBER = '111';
        locE.ADDR_LINE_1 = 'add1';
        locE.ADDR_LINE_2 = 'add2';
        locE.CITY = 'city';
        locE.COUNTY = 'county';
        locE.POST_CODE = 'SG1 2ST';
        locE.COUNTRY = 'GB';
        locE.LATITUDE = 1.0;
        locE.LONGITUDE = 1.0;
        
        NGS_S2_WO_Appointment_WS.LocationsElement locEles = new NGS_S2_WO_Appointment_WS.LocationsElement();
        locEles.Location = locE;
        
        NGS_S2_WO_Appointment_WS.ActivityElement activE = new NGS_S2_WO_Appointment_WS.ActivityElement();
        activE.WORK_ORDER_NUMBER = '111';
        activE.CHANGE_TYPE = 'NEW';
        activE.APPT_START_TIME = SYSTEM.NOW();
        activE.APPT_FINISH_TIME = SYSTEM.NOW() + 1;
        activE.APPOINTMENT_TYPE = 'county';
        activE.MESSAGE_DATE = SYSTEM.NOW();
        activE.MPAN = '1';
        activE.MPRN = '1';
        activE.DURATION = '1.0';
        activE.SERVICE_PROVIDER = 'SP02';
        
        NGS_S2_WO_Appointment_WS.ActivitiesElement actiEles = new NGS_S2_WO_Appointment_WS.ActivitiesElement();
        actiEles.Activity = activE;
        
        NGS_S2_WO_Appointment_WS.WORK_ORDER_APPOINTMENT workOrderEle = new NGS_S2_WO_Appointment_WS.WORK_ORDER_APPOINTMENT();
        workOrderEle.Activities = actiEles;
        workOrderEle.Locations = locEles;
        workOrderEle.Notes = noteEles;
        workOrderEle.Jobs = jobsEl;
        
        Test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
        NGS_S2_WO_Appointment_WS.S2_WORK_ORDER_APPOINTMENTResponse response = NGS_S2_WO_Appointment_WS.S2_webservice_WOR_ORDER_APPOINTMENT_Binder_S2_WORK_ORDER_APPOINTMENT(workOrderEle);
    }
    
    /*
        updateTest(): 
    */
    static testmethod void updateTest(){
        Test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
        NGS_Work_Order_Appointment__c ngsWOappt = new NGS_Work_Order_Appointment__c(Name = '111',Address_Line_1__c = 'add1', Post_Code__c = 'SG1 2ST',
                                                                                     Appointment_Start_Time__c = SYSTEM.NOW() + 10, Duration__c = '01:00', 
                                                                                     City__c = 'city', Country__c = 'GB', Appointment_Finish_Time__c = SYSTEM.NOW() + 11,
                                                                                     Message_Date__c = SYSTEM.NOW());
        insert ngsWOappt;
        
        NGS_Job_Code__c ngsJobCode = new NGS_Job_Code__c(name = '12345', Bucket_Type__c  = 'Smart' ,Job_Type__c = 'Smart', Job_Description__c = 'Accuracy Attend (Electric)');
        insert ngsJobCode;
        
        NGS_Region__c ngsRegion = new NGS_Region__c(name  = 'Southern');
        insert ngsRegion;
        
        NGS_Sub_Region__c subRegion = new NGS_Sub_Region__c(Smart__c = true, Oracle_Bucket_ID__c = 'SN_001', name = 'Southern Area 1', Region__c = ngsRegion.id);
        insert subRegion;
        
        NGS_Postcode__c ngsPCinst = new NGS_Postcode__c (name = 'SG1 2', sub_region__c  = subRegion.id);
        insert ngsPCinst;
        
        Test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
        
        NGS_S2_WO_Appointment_WS.JobElement jobE = new NGS_S2_WO_Appointment_WS.JobElement();
        jobE.WORK_ORDER_NUMBER = '111';
        jobE.JOB_ID = '12345';
        jobE.JOB_DESCRIPTION = 'test';
        
        list<NGS_S2_WO_Appointment_WS.JobElement> jeLst = new list<NGS_S2_WO_Appointment_WS.JobElement>();
        jeLst.add(jobE);

        NGS_S2_WO_Appointment_WS.JobsElement jobsEl = new NGS_S2_WO_Appointment_WS.JobsElement();
        jobsEl.Job = jeLst;
        
        NGS_S2_WO_Appointment_WS.NoteElement noteE = new NGS_S2_WO_Appointment_WS.NoteElement();
        noteE.WORK_ORDER_NUMBER = '111';
        noteE.NOTE_TYPE = 'type';
        noteE.NOTE_TEXT = 'test';
        
        List<NGS_S2_WO_Appointment_WS.NoteElement> noteLst = new List<NGS_S2_WO_Appointment_WS.NoteElement>();
        noteLst.add(noteE);
        
        NGS_S2_WO_Appointment_WS.NotesElement noteEles = new NGS_S2_WO_Appointment_WS.NotesElement();
        noteEles.Note = noteLst;
        
        NGS_S2_WO_Appointment_WS.LocationElement locE = new NGS_S2_WO_Appointment_WS.LocationElement();
        locE.WORK_ORDER_NUMBER = '111';
        locE.ADDR_LINE_1 = 'add1';
        locE.ADDR_LINE_2 = 'add2';
        locE.CITY = 'city';
        locE.COUNTY = 'county';
        locE.POST_CODE = 'SG1 2ST';
        locE.COUNTRY = 'GB';
        locE.LATITUDE = 1.0;
        locE.LONGITUDE = 1.0;
        
        NGS_S2_WO_Appointment_WS.LocationsElement locEles = new NGS_S2_WO_Appointment_WS.LocationsElement();
        locEles.Location = locE;
        
        NGS_S2_WO_Appointment_WS.ActivityElement activE = new NGS_S2_WO_Appointment_WS.ActivityElement();
        activE.WORK_ORDER_NUMBER = '111';
        activE.CHANGE_TYPE = 'UPDATE';
        activE.APPT_START_TIME = SYSTEM.NOW();
        activE.APPT_FINISH_TIME = SYSTEM.NOW() + 1;
        activE.APPOINTMENT_TYPE = 'county';
        activE.MESSAGE_DATE = SYSTEM.NOW();
        activE.MPAN = '1';
        activE.MPRN = '1';
        activE.DURATION = '1.0';
        activE.SERVICE_PROVIDER = 'SP02';
        
        NGS_S2_WO_Appointment_WS.ActivitiesElement actiEles = new NGS_S2_WO_Appointment_WS.ActivitiesElement();
        actiEles.Activity = activE;
        
        NGS_S2_WO_Appointment_WS.WORK_ORDER_APPOINTMENT workOrderEle = new NGS_S2_WO_Appointment_WS.WORK_ORDER_APPOINTMENT();
        workOrderEle.Activities = actiEles;
        workOrderEle.Locations = locEles;
        workOrderEle.Notes = noteEles;
        workOrderEle.Jobs = jobsEl;
        
        NGS_S2_WO_Appointment_WS.S2_WORK_ORDER_APPOINTMENTResponse response = NGS_S2_WO_Appointment_WS.S2_webservice_WOR_ORDER_APPOINTMENT_Binder_S2_WORK_ORDER_APPOINTMENT(workOrderEle);
    }
    
    /*
        blankRequestFailTest(): 
    */
    static testmethod void blankRequestFailTest(){
        NGS_S2_WO_Appointment_WS.S2_WORK_ORDER_APPOINTMENTResponse response = NGS_S2_WO_Appointment_WS.S2_webservice_WOR_ORDER_APPOINTMENT_Binder_S2_WORK_ORDER_APPOINTMENT(null);
    }
}