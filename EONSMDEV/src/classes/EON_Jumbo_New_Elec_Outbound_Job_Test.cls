/**
    Description : This test class covers the code coverage for below class
        1. EON_Jumbo_New_Elec_Outbound_Job
**/
/*
    Created By : Purvi
    Created Date : 05-May-2016
    Service Request : SR_EON_Jumbo_006
    Change History : 
    CH01 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH02 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c

*/

@isTest
global class EON_Jumbo_New_Elec_Outbound_Job_Test implements WebServiceMock {  
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
            EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element obj = new EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element();
            obj.CreateJumboElectricityJobResult=resp;
            response.put('response_x', obj);
         }
     catch(Exception ex){
             System.debug('*** Exception Occured : ' + ex.getMessage());
             system.debug('$$$$'+ex.getLineNumber());
         }                
      }
    
    
    
    /**
        createResponseInJumboPASS() - postitive Unit test for the method createElectricityJobInIsis
    **/
    static testMethod void createResponseInJumboPASS() {  
    
        //CH01.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH01.end
        EON_JUMBO_Outbound_Func_Code__c codeObj = new EON_JUMBO_Outbound_Func_Code__c(name='CreateElecJob_Jumbo',Function_Code__c='CEJ');
        insert codeobj;
        
        EON_Appointment__c appObj = new EON_Appointment__c();
        appObj.Booking_System_Name__c = 'Test Book';
        appObj.Requested_SSC__c = '007';//CH01.old //CH02.new
        //appObj.Requested_SSC__c=ssc.id; //CH01.New//CH02.old
        appObj.EON_Appointment_ID__c = '489756332';
        Insert appObj;
        Success='true';
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_Jumbo_New_Elec_Outbound_Job_Test());
        EON_Jumbo_New_Elec_Outbound_Job.createElecJobinJUMBO(string.valueof(appObj.Id));
        test.stopTest();
    
    }
    
    /**
        createElectricityJobInIsisFAIL() - Negative Unit test for the method createElectricityJobInIsis
    **/
    static testMethod void createElectricityJobInIsisFAIL() {  
    
        //CH01.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH01.end
        EON_Appointment__c appObj = new EON_Appointment__c();
        appObj.Booking_System_Name__c = 'Test Book';
        appObj.Requested_SSC__c = '007';//CH01.old //CH02.new
        //appObj.Requested_SSC__c=ssc.id; //CH01.New//CH02.old
        appObj.EON_Appointment_ID__c = '489756332';
        Insert appObj;
        Success='false';
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_Jumbo_New_Elec_Outbound_Job_Test());
        EON_Jumbo_New_Elec_Outbound_Job.createElecJobinJUMBO(string.valueof(appObj.Id));
        test.stopTest();
    
    }
    
    /**
        createElectricityJobInIsisFAILCatch() - Negative Unit test for the method createElectricityJobInIsis
    **/
    static testMethod void createElectricityJobInIsisFAILCatch() {  
        
        EON_Job__c jobObj = new EON_Job__c();
        jobObj.Name = '44456';
        jobObj.Description__c = 'test';
        Insert jobObj;
        
        EON_Job__c queryJob = new EON_Job__c();
        queryJob = [select id, name from EON_Job__c where id=:jobObj.id];
        
        //CH01.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH01.end
        
        EON_Appointment__c appObj = new EON_Appointment__c();
        appObj.Booking_System_Name__c = 'Test Book';
        appObj.Requested_SSC__c = '007';//CH01.old
        //appObj.Requested_SSC__c=ssc.id; //CH01.New//CH02.old
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
        EON_Jumbo_New_Elec_Outbound_Job.createElecJobinJUMBO(string.valueof(appObj.Id));
        test.stopTest();
        
    }
    
    /**
        createElectricityJobInIsisFAIL1() - Negative Unit test for the method createElectricityJobInIsis
    **/
    static testMethod void createElectricityJobInIsisFAIL1() {  
        test.startTest();
        EON_Jumbo_New_Elec_Outbound_Job.createElecJobinJUMBO(string.valueof('a0A4E00000084n2'));
        test.stopTest();
    
    }
    /**
        createElectricityJobInIsisCS() - custom setting set to test for the method createElectricityJobInIsis
    **/    
    static testMethod void createElectricityJobInIsisCS() {  
        
        EON_JUMBO_Outbound_Func_Code__c codeObj = new EON_JUMBO_Outbound_Func_Code__c(name='CreateElecJob_Jumbo',Function_Code__c='CEJ');
        insert codeobj;
        //CH01.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        //CH01.end
        EON_Appointment__c appObj = new EON_Appointment__c();
        appObj.Booking_System_Name__c = 'Test Book';
        //appObj.Requested_SSC__c = '007';//CH01.old
        //appObj.Requested_SSC__c=ssc.id; //CH01.New//CH02.old
        appObj.EON_Appointment_ID__c = '489756332';
        Insert appObj;
        Success='false';
        test.startTest();
        Test.setMock(WebServiceMock.class, new EON_Jumbo_New_Elec_Outbound_Job_Test());
        EON_Jumbo_New_Elec_Outbound_Job.createElecJobinJUMBO(string.valueof(appObj.Id));
        test.stopTest();
            
    }
}