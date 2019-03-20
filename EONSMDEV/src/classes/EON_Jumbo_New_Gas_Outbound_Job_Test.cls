/**
    Description : This test class covers the code coverage for below class
        1. EON_Jumbo_New_Gas_Outbound_Job
**/
/*
    Created By : Shruti Moghe
    Created Date : 11-May-2016
    Service Request : SR_EON_Jumbo_009
    Change History : 
    CH01 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH02 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c

*/

@isTest
global class EON_Jumbo_New_Gas_Outbound_Job_Test implements WebServiceMock {  
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
            EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element obj = new EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element();
            obj.CreateJumboGasJobResult=resp;
            response.put('response_x', obj);
         }
     catch(Exception ex){
             System.debug('*** Exception Occured : ' + ex.getMessage());
             system.debug('$$$$'+ex.getLineNumber());
         }                
      }
    
    
    
    /**
        createGasJobinJUMBOPASS() - postitive Unit test for the method createGasJobinJUMBO
    **/
    static testMethod void createGasJobinJUMBOPASS() {  
    
        EON_JUMBO_Outbound_Func_Code__c codeObj = new EON_JUMBO_Outbound_Func_Code__c(name='CreateGasJob_Jumbo',Function_Code__c='CGJ');
        insert codeobj;
         EON_Job__c jobObj = new EON_Job__c();
        jobObj.Name = '44456';
        jobObj.Description__c = 'test';
        Insert jobObj;
        //CH01.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH01.end
        EON_Appointment__c appObj = new EON_Appointment__c();
        appObj.Booking_System_Name__c = 'Test Book';
        appObj.Requested_SSC__c = '007';//CH01.old //CH02.new
        //appObj.Requested_SSC__c =ssc.id;//CH01.New//CH02.old
        appObj.EON_Appointment_ID__c = '489756332';
        appObj.Appointment_Date__c = system.today();
        appObj.Start_Time__c = '22';
        appObj.Job_Code__c= jobObj.Id;
        appObj.End_Appointment_Date__c = system.today();
        appObj.End_Time__c = '45';
        appObj.Request_Date__c = system.today();
        appObj.Request_Time__c = '35';
        appObj.MPRN__c = '24';
        Insert appObj;
        Success='true';
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_Jumbo_New_Gas_Outbound_Job_Test());
        EON_Jumbo_New_Gas_Outbound_Job.createGasJobinJUMBO(string.valueof(appObj.Id));
        test.stopTest();
    
    }
    
    /**
        createGasJobinJUMBOFAIL() - Negative Unit test for the method createGasJobinJUMBO
    **/
    static testMethod void createGasJobinJUMBOFAIL() {  
        EON_Job__c jobObj = new EON_Job__c();
        jobObj.Name = '44456';
        jobObj.Description__c = 'test';
        Insert jobObj;
        //CH01.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH01.end
        EON_Appointment__c appObj = new EON_Appointment__c();
        appObj.Booking_System_Name__c = 'Test Book';
        appObj.Requested_SSC__c = '007';//CH01.old //CH02.new
        //appObj.Requested_SSC__c =ssc.id;//CH01.New//CH02.OLD
        appObj.EON_Appointment_ID__c = '489756332';
        appObj.Appointment_Date__c = system.today();
        appObj.Job_Code__c= jobObj.Id;
        appObj.MPRN__c = '24';
        Insert appObj;         
        EON_Jumbo_New_Gas_Outbound_Job.createGasJobinJUMBO(string.valueof(appObj.Id));
        test.startTest(); 
        Success='false';  
        Test.setMock(WebServiceMock.class, new EON_Jumbo_New_Gas_Outbound_Job_Test());
        EON_Jumbo_New_Gas_Outbound_Job.createGasJobinJUMBO(string.valueof(appObj.Id));
        test.stopTest();
    
    }
    
    
}