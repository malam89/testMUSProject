/**
    Description : This class is used to cover the below classes test coverage :
                    EON_Appointment_Trigger_VOICE_Helper
**/
/*
    Created By : Praveen G
    Created Date : 18-July-2016
    Service Request : SR_EON_AB_073
    CHANGE HISTORY:
    CH01 # SR_EON_Jumbo_109 # 31/03/2017 # Akshay B # introduced email service code coverage.
*/

@isTest
private class EON_Appointment_Triger_VOICE_Helper_Test implements WebServiceMock{
    
      public void doInvoke(
      Object stub,
      Object request,
      Map<String, Object> response,
      String endpoint,
      String soapAction,
      String requestName,
      String responseNS,
      String responseName,
      String responseType) {
      
          if(request instanceOf EON_Voice_Appointment_Mgmt_Helper_WS.GetData_element) {
              Map<String, EON_Voice_Appointment_Mgmt_Helper_WS.GetDataResponse_element> response_map_x = new 
                                                Map<String, EON_Voice_Appointment_Mgmt_Helper_WS.GetDataResponse_element>();          
              EON_Voice_Appointment_Mgmt_Helper_WS.GetDataResponse_element response_x =  new 
                                                  EON_Voice_Appointment_Mgmt_Helper_WS.GetDataResponse_element();
              response_x.GetDataResult = 'Success';                                    
              response.put('response_x', response_x);
              
          }else if(request instanceOf EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetails_element) {
              Map<String, EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element> response_map_x = 
                          new Map<String, EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element>();
              EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element response_x = 
                      new EON_Voice_Appointment_Mgmt_Helper_WS.UpdateAppointmentDetailsResponse_element();
              response_x.UpdateAppointmentDetailsResult = 'Fail';        
              response.put('response_x', response_x);                                    
          }
      }    
    
    
    /**
        unitTest() - unitTest
    **/
    static testMethod void unitTest() {
        Test.setMock(WebServiceMock.class, new EON_Appointment_Triger_VOICE_Helper_Test());
        
        EON_Voice_Appointment_Mgmt_Helper_WS.BasicHttpBinding_IAppointment reqq_TEMP = new 
                    EON_Voice_Appointment_Mgmt_Helper_WS.BasicHttpBinding_IAppointment();        
        
        EON_Voice_Appointment_Mgmt_Helper_WS.BasicHttpsBinding_IAppointment reqq = new 
                    EON_Voice_Appointment_Mgmt_Helper_WS.BasicHttpsBinding_IAppointment();
        reqq.GetData(2);
        
        //Create custom settings
        insert new EON_AppReason_JobCode__c(Name = 'Test_Reason', C_EON_JobCode__c = 'TEST1234', C_MUS_Jobcode__c='TEST1234');
        
        EON_Job__c job = new EON_Job__c();
        job.Name='TEST1234';
        job.Description__c = 'Test Description';
        insert job;
        
        Eon_Appointment_Reason__c appReason = new Eon_Appointment_Reason__c();
        appReason.Appointment_reason_code__c = 'Test_Reason';
        insert appReason;
        
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        eonApp.Gas_Daily_Data_Opted__c = false;
        eonApp.Job_Code__c = job.id;
        eonApp.Appointment_reason_code__c = appReason.id;
        eonApp.Booking_System_Name__c = 'ICE';
        eonApp.Confirmed_Appointment_DateTime__c = System.today();
        insert eonApp; 
        
        List<EON_Appointment__c> lstAppointment = new List<EON_Appointment__c>();
        lstAppointment.add(eonApp);
        
        Eon_Appointment__c eonApp1 = EON_CreateTestRecords.createEONAppointment();
        eonApp1.Planned_Meter_Mode__c = 'CR';
        
        eonApp.Planned_Meter_Mode__c = 'PAYG';
        update eonApp;
        
        eonApp.Booking_System_Name__c = 'MUS';
        update eonApp;
        
        MAP<id, EON_Appointment__c> oldMapIDAppointment = new MAP<id, EON_Appointment__c>();
        oldMapIDAppointment.put(eonApp.id, eonApp1);
        
        EON_Appointment_Contact__c appcontact = new EON_Appointment_Contact__c();
        appcontact.EON_Appointment_ID__c = eonApp.id;
        insert appcontact;
        
        //Created comms records - Praveen G
        
        Eon_Delivery_Method__c deliveryMethod1 = new Eon_Delivery_Method__c();
        deliveryMethod1.Code__c = 'E';
        deliveryMethod1.Name = 'method1';
        insert deliveryMethod1;
        
        Eon_Delivery_Method__c deliveryMethod2 = new Eon_Delivery_Method__c();
        deliveryMethod2.Code__c = 'L';
        deliveryMethod2.Name = 'method2';
        insert deliveryMethod2;
        
        Eon_Delivery_Method__c deliveryMethod3 = new Eon_Delivery_Method__c();
        deliveryMethod3.Code__c = 'M';
        deliveryMethod3.Name = 'method3';
        insert deliveryMethod3;
        
        Eon_Delivery_Method__c deliveryMethod4 = new Eon_Delivery_Method__c();
        deliveryMethod4.Code__c = 'N';
        deliveryMethod4.Name = 'method4';
        insert deliveryMethod4;                        
        
        EON_Appointment_Comms__c comm1 = new EON_Appointment_Comms__c();
        comm1.EON_Appointment_ID__c = eonApp.id;
        comm1.Comm_Type_Code__c = 'C';
        comm1.Delivery_Method_Desc__c = deliveryMethod1.id;
        insert comm1;
        
        EON_Appointment_Comms__c comm2 = new EON_Appointment_Comms__c();
        comm2.EON_Appointment_ID__c = eonApp.id;
        comm2.Comm_Type_Code__c = 'I';
        comm2.Delivery_Method_Desc__c = deliveryMethod2.id;
        insert comm2; 
        
        EON_Appointment_Comms__c comm3 = new EON_Appointment_Comms__c();
        comm3.EON_Appointment_ID__c = eonApp.id;
        comm3.Comm_Type_Code__c = 'R';
        comm3.Delivery_Method_Desc__c = deliveryMethod3.id;
        insert comm3; 
        
        EON_Appointment_Comms__c comm4 = new EON_Appointment_Comms__c();
        comm4.EON_Appointment_ID__c = eonApp.id;
        comm4.Comm_Type_Code__c = 'R';
        comm4.Delivery_Method_Desc__c = deliveryMethod4.id;
        insert comm4;                      
               
        EON_Appointment_Trigger_VOICE_Helper.sendAppointmentInfoToVoice(lstAppointment, oldMapIDAppointment, false);
        
        EON_Appointment_Trigger_VOICE_Helper.sendAppointmentInfoToVoice(lstAppointment, oldMapIDAppointment, true);
        
        //CH01.start
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.plainTextBody = 'Text Body';
        email.htmlbody = 'HTML Content';
        email.fromAddress ='test@test.com';
        email.subject = eonApp.id;
        EON_Appointment_VOICE_EmailService obj = new EON_Appointment_VOICE_EmailService();
        obj.handleInboundEmail(email, env);
        //CH01.End
    }
    
    /**
        unitTest1() - unitTest1
    **/
    static testMethod void unitTest1() {
        EON_Appointment_Trigger_VOICE_Helper.sendInfoToVOICE(null);
        
    }
    
    /**
        unitTest2()
    **/
    static testMethod void unitTest2() {
   
        EON_Job__c job = new EON_Job__c();
        job.Name='TEST1234';
        job.Description__c = 'Test Description';
        insert job;
        
        Eon_Appointment_Reason__c appReason = new Eon_Appointment_Reason__c();
        appReason.Appointment_reason_code__c = 'Test_Reason';
        insert appReason;        
            
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        eonApp.Gas_Daily_Data_Opted__c = false;
        eonApp.Job_Code__c = job.id;
        eonApp.Appointment_reason_code__c = appReason.id;
        eonApp.Booking_System_Name__c = 'ICE';

        insert eonApp;       

        EON_Appointment_Trigger_VOICE_Helper.sendInfoToVOICE(eonApp.id);
      
    }    
    
}