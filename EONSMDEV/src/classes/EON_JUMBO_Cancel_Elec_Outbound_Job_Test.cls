/**
    Description : This test class covers the code coverage for below class
        1. EON_JUMBO_Cancel_Elec_Outbound_Job
**/
/*
    Created By : Aruna Manjari
    Created Date : 05-May-2016
    Service Request : SR_EON_Jumbo_008
    Change History : 
    CH01 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH02 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    
*/

@isTest
global class EON_JUMBO_Cancel_Elec_Outbound_Job_Test implements WebServiceMock {  
     Public static string Success;
     
     global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
      try{
            String[] Msg = new String[]{'Message1','Message2','Message3'};    
            EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
            err.Message = Msg;
            EON_JUMBO_Work_Management_WS.JumboTechnicalResponse resp = new EON_JUMBO_Work_Management_WS.JumboTechnicalResponse();
             resp.Errors = err;
             
            if(Success=='true')
             resp.Success = true;
            else
              resp.Success = false;
            EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element obj = new EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element ();
            obj.CancelJumboElectricityJobResult=resp;
            response.put('response_x', obj);
         }
     catch(Exception ex){
             System.debug('*** Exception Occured : ' + ex.getMessage());
             system.debug('$$$$'+ex.getLineNumber());
         }                
      }
    
    
    
    /**
       cancelResponseInJumboPASS() - postitive Unit test for the method cancelElectricityJobInIsis
    **/
    static testMethod void cancelResponseInJumboPASS() {  
    
    //CH01.start
    EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
    insert ssc;
     //CH01.end
    EON_Appointment__c appObj = new EON_Appointment__c();
    appObj.Booking_System_Name__c = 'Test Book';
    appObj.Requested_SSC__c = '007';//CH01.old //CH02.new
   // appObj.Requested_SSC__c =ssc.id;  //CH01.new //CH02.old
    appObj.EON_Appointment_ID__c = '489756332';
    Insert appObj;
   // EON_JUMBO_Outbound_Func_Code__c funCode = EON_JUMBO_Outbound_Func_Code__c.getInstance('CancelElecJob_Jumbo');
   
    Success='true';
    test.startTest();
    Test.setMock(WebServiceMock.class, new EON_JUMBO_Cancel_Elec_Outbound_Job_Test());
    EON_JUMBO_Cancel_Elec_Outbound_Job.CancelElecJobinJUMBO(string.valueof(appObj.Id));
    test.stopTest();
    
    }
    
    /**
        cancelElectricityJobInIsisFAIL() - Negative Unit test for the method cancelElectricityJobInIsis
    **/
    static testMethod void cancelElectricityJobInIsisFAIL() {  
    
    //CH01.start
    EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
    insert ssc;
     //CH01.end
    EON_Appointment__c appObj = new EON_Appointment__c();
    appObj.Booking_System_Name__c = 'Test Book';
    appObj.Requested_SSC__c = '007';//CH01.old //CH02.new
    //appObj.Requested_SSC__c =ssc.id;  //CH01.new//CH02.old
    appObj.EON_Appointment_ID__c = '489756332';
    Insert appObj;
    Success='false';
    test.startTest();
     Test.setMock(WebServiceMock.class, new EON_JUMBO_Cancel_Elec_Outbound_Job_Test());
    EON_JUMBO_Cancel_Elec_Outbound_Job.CancelElecJobinJUMBO(string.valueof(appObj.Id));
    test.stopTest();
    
    }
    
    /**
        cancelElectricityJobInIsisFAILCatch() - Negative Unit test for the method cancelElectricityJobInIsis
    **/
    static testMethod void cancelElectricityJobInIsisFAILCatch() {  
    
    EON_Job__c jobObj = new EON_Job__c();
    jobObj.Name = '44456';
    jobObj.Description__c = 'test';
    Insert jobObj;
    //CH01.start
    EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
    insert ssc;
     //CH01.end
    EON_JUMBO_Outbound_Func_Code__c codeObj = new EON_JUMBO_Outbound_Func_Code__c(name='CancelElecJob_Jumbo',Function_Code__c='CAE');
    insert codeobj;
    
    EON_Job__c queryJob = new EON_Job__c();
    queryJob = [select id, name from EON_Job__c where id=:jobObj.id];
    
    EON_Appointment__c appObj = new EON_Appointment__c();
    appObj.Booking_System_Name__c = 'Test Book';
    appObj.Requested_SSC__c = '007';//CH01.old //CH02.new
    //appObj.Requested_SSC__c =ssc.id;  //CH01.new //CH02.old   
    appObj.EON_Appointment_ID__c = '489756332';
    appObj.Appointment_Date__c = system.today();
    appObj.Start_Time__c = '22';
    appObj.Job_Code__c= queryJob.Id;
    appObj.End_Appointment_Date__c = system.today();
    appObj.End_Time__c = '45';
    appObj.Request_Date__c = system.today();
    appObj.Request_Time__c = '35';
    appObj.MPAN__c = '24';
    Insert appObj;
    
    Success='false';
    test.startTest();
    EON_JUMBO_Cancel_Elec_Outbound_Job.CancelElecJobinJUMBO(string.valueof(appObj.Id));
    test.stopTest();
    
    }
    
   
}