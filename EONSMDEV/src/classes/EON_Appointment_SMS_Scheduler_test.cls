/**
    Description : This test class covers the code coverage for below class
        1.EON_Appointment_SMS_Sender_Scheduler
        2.EON_Appointment_SMS_Sender_Helper
        3.EON_Appointment_email_Sender_Scheduler
**/
/*
    Created By : Aruna Manjari
    Created Date : 04-April-2016
    Service Request : SR_Isis_EON_012
*/

@isTest(SeeAllData=false)
global class EON_Appointment_SMS_Scheduler_test {
     
   // CRON expression: midnight on March 15. 
    
   // Because this is a test, job executes 
    
   // immediately after Test.stopTest(). 
 
   public static String CRON_EXP = '0 00 20 * * ?';
   /**
       SMSsendtoCustomer_Pass() - poisitive test method to cover SMSsendtoCustomer method.
   **/
  
  public static testmethod void SMSsendtoCustomer_Pass() {
      
      // Schedule the test job 
    
      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new EON_Appointment_SMS_Sender_Scheduler());
         
      // Get the information from the CronTrigger API object 
    
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same 
    
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run 
    
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run 
    
    //  System.assertEquals('2016-04-18 20:00:00', 
   //   String.valueOf(ct.NextFireTime));
     
      List<EON_Appointment__c> AppointList = EON_CreateTestRecords.createEONAppointmentList();
      insert AppointList;
      List<Eon_Delivery_Method__c> deliveryList = EON_CreateTestRecords.createEonDeliveryMethodList();
      
      insert deliveryList;
      
      List<EON_Appointment_Comms__c> ListAppointcomm = EON_CreateTestRecords.createEonAppointmentCommsList();
      ListAppointcomm[0].Delivery_Method_Desc__c= deliveryList[0].id;
      ListAppointcomm[0].EON_Appointment_ID__c= AppointList[0].id;
      ListAppointcomm[1].Delivery_Method_Desc__c= deliveryList[1].id;
      ListAppointcomm[1].EON_Appointment_ID__c= AppointList[1].id;
      ListAppointcomm[2].EON_Appointment_ID__c= AppointList[1].id;
      ListAppointcomm[3].EON_Appointment_ID__c= AppointList[1].id;
      insert ListAppointcomm ;
      system.debug('*******list of comms********'+ListAppointcomm);
      Test.startTest();
      EON_Appointment_SMS_Sender_Scheduler scheduler = new EON_Appointment_SMS_Sender_Scheduler();
      scheduler.SMSsendtoCustomer();
      Test.stopTest();
    
    }
    
    /**
       SMSsendtoCustomer_Fail() - negative test method to cover SMSsendtoCustomer method.
   **/

  public static testmethod void SMSsendtoCustomer_Fail() {
      EON_Appointment_SMS_Sender_Scheduler scheduler = new EON_Appointment_SMS_Sender_Scheduler();
       scheduler.SMSsendtoCustomer();
   }
   
    /**
       SMSsendtoCustomer_Pass() - poisitive test method to cover SMSsendtoCustomer method.
   **/

  public static testmethod void EmailsendtoCustomer_Pass() {
      Test.startTest();

      // Schedule the test job 
    
      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP,  new EON_Appointment_email_Sender_Scheduler ());
         
      // Get the information from the CronTrigger API object 

      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same 
    
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run 
    
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run 
    
    //  System.assertEquals('2016-04-18 20:00:00', 
    //  String.valueOf(ct.NextFireTime));
    
      List<EON_Appointment__c> AppointList = EON_CreateTestRecords.createEONAppointmentList();
      insert AppointList;
      List<Eon_Delivery_Method__c> deliveryList = EON_CreateTestRecords.createEonDeliveryMethodList();
      insert deliveryList;
      List<EON_Appointment_Comms__c> ListAppointcomm = EON_CreateTestRecords.createEonAppointmentCommsList();
      ListAppointcomm[0].Delivery_Method_Desc__c= deliveryList[0].id;
      ListAppointcomm[0].EON_Appointment_ID__c= AppointList[0].id;
      ListAppointcomm[1].Delivery_Method_Desc__c= deliveryList[1].id;
      ListAppointcomm[1].EON_Appointment_ID__c= AppointList[1].id;
      ListAppointcomm[2].EON_Appointment_ID__c= AppointList[1].id;
      ListAppointcomm[3].EON_Appointment_ID__c= AppointList[1].id;
      insert ListAppointcomm ;
      system.debug('*******list of comms********'+ListAppointcomm);
      EON_Appointment_email_Sender_Scheduler scheduler = new EON_Appointment_email_Sender_Scheduler();
      scheduler.EmailtoCustomer();
   Test.stopTest();
   
   }
   /**
       SMSsendtoCustomer_Fail1() - poisitive test method to cover SMSsendtoCustomer method.
   **/
   public static testmethod void SMSsendtoCustomer_Fail1() {
      Test.startTest();

      // Schedule the test job 
    
      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP,  new EON_Appointment_email_Sender_Scheduler ());
         
      // Get the information from the CronTrigger API object 

      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same 
    
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run 
    
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run 
    
    //  System.assertEquals('2016-04-18 20:00:00', 
    //  String.valueOf(ct.NextFireTime));
    try{
         List<EON_Appointment__c> AppointList = EON_CreateTestRecords.createEONAppointmentList();
      insert AppointList;
      Test.setMock(HttpCalloutMock.class, new EON_Appointment_SMS_Scheduler_MockRes());
      EON_Appointment_SMS_Sender_Scheduler scheduler = new EON_Appointment_SMS_Sender_Scheduler();
      scheduler.SMSsendtoCustomer();
    }
    catch(Exception e){}
   Test.stopTest();
   
   }
   
    /**
      EmailsendtoCustomer_Pass2() - poisitive test method to cover EmailtoCustomer method.
   **/

   public static testmethod void EmailsendtoCustomer_Pass2() {
      Test.startTest();
      List<EON_Appointment__c> AppointList = EON_CreateTestRecords.createEONAppointmentList();
      insert AppointList;
      List<Eon_Delivery_Method__c> deliveryList = EON_CreateTestRecords.createEonDeliveryMethodList();
      insert deliveryList;
     // List<EON_Appointment_Comms__c> ListAppointcomm = EON_CreateTestRecords.createEonAppointmentCommsList();
      EON_Appointment_Comms__c appointComm1 = new EON_Appointment_Comms__c(Comm_Type_Code__c='R');
    //  appointComm1.Delivery_Method_Desc__c= deliveryList[0].id;
      appointComm1.EON_Appointment_ID__c= AppointList[0].id;
      insert appointComm1;
      Note objNote=new Note(ParentId=AppointList[0].id,Title='SMS Technical Failure');
      insert objNote;
     // system.debug('*******list of comms********'+ListAppointcomm);
      EON_Appointment_email_Sender_Scheduler scheduler = new EON_Appointment_email_Sender_Scheduler();
      scheduler.EmailtoCustomer();
     Test.stopTest();
   
   }
   
    /**
      smssenderhelper_pass() - poisitive test method to cover SMSSender method.
   **/

   public static testmethod void smssenderhelper_pass() {
      
     
    /* List<EON_Appointment__c> AppointList = EON_CreateTestRecords.createEONAppointmentList();
     insert AppointList;
     List<Eon_Delivery_Method__c> deliveryList = EON_CreateTestRecords.createEonDeliveryMethodList();
     insert deliveryList;
     // Note objNote=new Note(ParentId=AppointList[0].id,Title='SMS Technical Failure');
      //insert objNote;*/
      Test.startTest();
      Test.setMock(HttpCalloutMock.class, new EON_Appointment_SMS_Scheduler_MockRes());
    EON_Appointment_SMS_Sender_Helper.SMSSender('a0A4E000000EYzc','Test','9186003623','testing','Aruna','test','test');    //EON_Appointment_SMS_Sender_Helper.SMSSender(AppointList[0].id,'Test',deliveryList[0].name,'Scheduled_EON_Appointments',Null,Null,Null);
      Test.stopTest();

   }
   
   /**
     smssenderhelper_insert() - poisitive test method to cover SMSSender method.
   **/


    public static testmethod void smssenderhelper_insert() {

     List<EON_Appointment__c> AppointList = EON_CreateTestRecords.createEONAppointmentList();
     insert AppointList;
     List<Eon_Delivery_Method__c> deliveryList = EON_CreateTestRecords.createEonDeliveryMethodList();
     insert deliveryList;
     Note objNote=new Note(ParentId=AppointList[0].id,Title='SMS Technical Failure');
     insert objNote; 
     Test.startTest();
      Test.setMock(HttpCalloutMock.class, new EON_Appointment_SMS_Scheduler_MockRes());
    EON_Appointment_SMS_Sender_Helper.SMSSender('a0A4E000000EYzc','Test','','testing','Aruna','test','test');    //EON_Appointment_SMS_Sender_Helper.SMSSender(AppointList[0].id,'Test',deliveryList[0].name,'Scheduled_EON_Appointments',Null,Null,Null);
      Test.stopTest();

   }
    public static testmethod void smssenderhelper_errorlog() {
    EON_Appointment_SMS_Sender_Helper.logError('a0A4E000000EYzc','Sent_to_Oracle__c','error');
   }
   }