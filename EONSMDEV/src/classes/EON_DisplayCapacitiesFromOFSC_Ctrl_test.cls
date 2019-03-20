/**
    Description : This test class covers the code coverage for below class
                1. EON_DisplayCapacitiesFromOFSC_Ctrl
**/
/* 
    Created By    : Nitin Bangar
    Created On    : 28/04/2016
    Service Req   : 
    Change History:
    CH01 # SR_EON_AB_068 # 27/06/2016  #Shruti Moghe # Updated the code coverage
    CH02 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
*/
@isTest
public class EON_DisplayCapacitiesFromOFSC_Ctrl_test{
    
    /**
        getCapacitiesFromOFSCPass1() - This Will cover the Pass Scenario
    **/
    static testMethod void getCapacitiesFromOFSCPass1() {
        PageReference pageRef = Page.EON_DisplayCapacitiesFromOFSC;
        Test.setCurrentPage(pageRef);
        EON_DisplayCapacitiesFromOFSC_Ctrl ctrl = new EON_DisplayCapacitiesFromOFSC_Ctrl();
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        insert eonApp;
        EON_Create_Appointment_Request_ctrl.eEff_From_Date = Date.Today();
        EON_Create_Appointment_Request_ctrl.eEff_To_Date = date.Today()+1;
        System.currentPageReference().getParameters().put('appID',eonApp.Id);  
        System.currentPageReference().getParameters().put('dateSelected','01-02-2013');
        EON_Appointment_Booking_Ctrl_Helper.errorMessages ='';
        EON_OFSC_GetCapacity_CalloutTest();
        ctrl.getCapacitiesFromOFSC();
        ctrl.bookSlotsOFSC();
        Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> recomMap=ctrl.availableCapacities;
        ctrl.apptInstance=eonApp;
        System.assertEquals(recomMap.size()>0,false);
    }

    /**
        getCapacitiesFromOFSCPass2() - tThis Will cover the Pass Scenario
    **/
    static testMethod void getCapacitiesFromOFSCPass2() {   
      
        EON_DisplayCapacitiesFromOFSC_Ctrl ctrl = new EON_DisplayCapacitiesFromOFSC_Ctrl();
        String recdtimeSlots =ctrl.recdtimeSlots;
        List < EON_OFSC_Helper.RecomendedTimeSlots > recomendedTimeslot =  ctrl.recomendedTimeslot ;
        Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> recomMap=ctrl.availableCapacities;
        ctrl.getCapacitiesFromOFSC();
        ctrl.bookSlotsOFSC();
        System.assertEquals(ctrl.recdtimeSlots!=null,True); 
    }
     /**
    getCapacitiesFromOFSCPass3() - tThis Will cover the Pass Scenario
    **/

     static testMethod void getCapacitiesFromOFSCPass3() {
        //CH01.start
        PageReference pageRef = Page.EON_DisplayCapacitiesFromOFSC;
        Test.setCurrentPage(pageRef);
        EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(Name='1PH',Elec_Meter_Type__c='E',Elec_Phase__c='PH',Work_Skill__c='workSkill');
        insert capacity;
        EON_Job_Attribute__c att =EON_CreateTestRecords.createEonJobAttributes();
        insert att;
        //CH01.end
        EON_DisplayCapacitiesFromOFSC_Ctrl ctrl = new EON_DisplayCapacitiesFromOFSC_Ctrl();
        EON_Electric_Meter_Type__c emeter= new EON_Electric_Meter_Type__c();
        emeter.name='Test1';
        emeter.DESCRIPTION__c='KEY';
        emeter.FILTER__c='KEY';
        emeter.OFS_Enumeration__c=010;
        insert emeter;
        //CH01.start
        EON_Site__c site = EON_CreateTestRecords.cereateEONSite();
        insert site;
        EON_Fuel__c fuel=EON_CreateTestRecords.createEONFuel();
        fuel.Fuel_type__c = 'E';
        fuel.Premise__c=site.id;
        insert fuel;
        //CH01.end
        Eon_Appointment__c app = new Eon_Appointment__c();
        app.Fuel_ID__c=fuel.id;//CH01
        app.Job_Code__c=att.Eon_Job__c;//CH01
        app.E_Meter_Type__c =emeter.id;
        app.Number_of_Phases__c = '1Ph';//CH02
        app.Metering_Pressure__c = 'LOW';
        insert app;
        EON_Capacity_Categories__c cate1= new EON_Capacity_Categories__c(Name='1PH',Work_Skill__c='workSkill');
        insert cate1;
        EON_Capacity_Categories__c cate2= new EON_Capacity_Categories__c(Name='Test2',Work_Skill__c='Test2');
        insert cate2;
        //string workskill = EON_OFSC_Helper.getWorkSkill(app);
        EON_Create_Appointment_Request_ctrl.eEff_From_Date = Date.Today();
        EON_Create_Appointment_Request_ctrl.eEff_To_Date = date.Today()+1;
        System.currentPageReference().getParameters().put('appID',App.Id);  
        System.currentPageReference().getParameters().put('dateSelected','01-02-2013');
        System.currentPageReference().getParameters().put('specificTimeFlag','true');//CH01
        System.currentPageReference().getParameters().put('apptStartTime','13:12:00');//CH01
        EON_Appointment_Booking_Ctrl_Helper.errorMessages ='';
        EON_Appointment_Booking_Ctrl_Helper.appDuration =20;//CH01
        EON_OFSC_GetCapacity_CalloutTest();
        ctrl.getCapacitiesFromOFSC();
        ctrl.bookSlotsOFSC();
        Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> recomMap=ctrl.availableCapacities;
        //System.assertEquals(recomMap.size()>0,true);
    }
     /**
    getCapacitiesFromOFSCFAIL() - tThis Will cover the FAIL Scenario
    **/
    static testMethod void getCapacitiesFromOFSCFAIL() {
        EON_DisplayCapacitiesFromOFSC_Ctrl ctrl = new EON_DisplayCapacitiesFromOFSC_Ctrl();
        ctrl.getCapacitiesFromOFSC();
        ctrl.bookSlotsOFSC();
    }
    /**
    EON_OFSC_GetCapacity_CalloutTest(): this method will cover the callout scenario
    **/
    
    public static void EON_OFSC_GetCapacity_CalloutTest(){
        Test.startTest();
        EON_OFSC_Helper.RecomendedTimeSlots  slots = new EON_OFSC_Helper.RecomendedTimeSlots();
        slots.dt =Date.today();
        slots.dayVal ='Mon';
        slots.timeFormat ='test';
        slots.timeSlots ='test';
        slots.workSkill ='workSkill';
        slots.quota =2147483648L;
        slots.availability =2147483648L;
        slots.activity_duration=2147483648L;
        slots.activity_travel_time=2147483648L;
        EON_OFSC_Helper.RecomendedTimeslots  slots1 = new EON_OFSC_Helper.RecomendedTimeslots();
        slots1.dt =Date.today()+1;
        slots1.dayVal ='Mon';
        slots1.timeFormat ='test';
        slots1.timeslots ='test';
        slots1.workSkill ='workSkill';
        slots1.quota =2147483648L;
        slots1.availability =2147483648L;
        slots1.activity_duration=2147483648L;
        slots1.activity_travel_time=2147483648L;
        Test.setMock(WebServiceMock.class, new EON_OFSC_GetCapacity_WS_ServicesMock());   
        EON_OFSC_GetCapacity_WS.toa_capacity_interface taCap = new EON_OFSC_GetCapacity_WS.toa_capacity_interface();
        taCap.endpoint_x = 'https://api.etadirect.com/soap/';
        taCap.inputHttpHeaders_x =null;
        taCap.outputHttpHeaders_x = null;
        taCap.clientCertName_x = 'TestEon';
        taCap.clientCert_x ='Test_';
        taCap.clientCertPasswd_x = 'Test@123';
        taCap.timeout_x = 12000;
        EON_OFSC_GetCapacity_WS.user_element  eonUsr = new EON_OFSC_GetCapacity_WS.user_element();
        eonUsr.now = string.ValueOf(System.now());
        eonUsr.login = 'EON@morrisonus.com';
        eonUsr.company = 'MUS';
        eonUsr.auth_string = 'MUS USER AUTHENTICATED';
        List<EON_OFSC_GetCapacity_WS.set_quota_day_element> edlst = new List<EON_OFSC_GetCapacity_WS.set_quota_day_element>();
        EON_OFSC_GetCapacity_WS.set_quota_bucket_element testbuk = new EON_OFSC_GetCapacity_WS.set_quota_bucket_element(); 
        testbuk.bucket_id ='1213444';
        testbuk.day =edlst ;
        List<EON_OFSC_GetCapacity_WS.set_quota_bucket_element> lstbucket = new List<EON_OFSC_GetCapacity_WS.set_quota_bucket_element>();
        lstbucket.add(testbuk); 
        taCap.set_quota(eonUsr,lstbucket);
        Test.stopTest();
    }
}