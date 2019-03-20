/**
    Description : This test class is used to cover the below classesEON_NonCustomer_Result_Ctrl
                  1.EON_Complaint_Search_Result_Ctrl
**/
/*
    Created by :Aruna Manjari
    Created Date : 27-April-2016
    Service Request : SR_EON_PC_028
    Change History:
        CH01 # SR_EON_PC_099 # 09/01/2017 # Mahadev J # Updated API reference of 'Customer' to 'Customer Name' of object 'EON Complaint' | Update API data type of Complainant_Address__c
        CH02 # SR_EON_PC_101 # 18/01/2017 # Aruna Manjari # Removed the reference of the field Complainant_Address__c and add new fields (Complainant_Address_1__c,Complainant_City__c,Complainant_Post_Code1__c)

*/

@isTest
public class EON_Complaint_Search_Result_Ctrl_Test{

    /**
        unitTest1() - unitTest1 - Success test case
    **/
    testmethod static void unitTest1(){
    /*
        Test.startTest();
        EON_Complaint__c comp= EON_CreateTestRecords.createEonComplaint();
        EON_Customer__c cust  =EON_CreateTestRecords.createEONCustomer();
        EON_Fuel__c fuel  =EON_CreateTestRecords.createEONFuel();
        EON_Technician__c tech=EON_CreateTestRecords.createEONTechnician();
        EON_Appointment__c app=EON_CreateTestRecords.createEONAppointment();
        EON_Site__c site = EON_CreateTestRecords.cereateEONSite();
        insert cust;
        insert  tech;
        insert app;
        insert site;
        
        //comp.Name  = 'name Cust';
        comp.Customer_Name__c=cust.id; //CH01.Update
        comp.Technician__c=tech.id;
        comp.Premise__c=site.id;
        comp.Customer_Service_Advisor_Name__c='test';
        comp.Appointment__c=app.id;

        insert comp;
        System.debug('Comp:'+comp);
        EON_Complaint__c complaint= [select Name,Customer_Name__r.name,Customer_Name__r.Customer_Name__c,Premise__r.name,Technician__r.name,Appointment__r.name,Customer_Service_Advisor_Name__c from EON_Complaint__c where id =: comp.id]; //CH01.Update
        EON_Complaint_Search_Result_Ctrl controller = new EON_Complaint_Search_Result_Ctrl();
        System.currentPageReference().getParameters().put('appointmentID', complaint.Name);
        System.currentPageReference().getParameters().put('customerName', complaint.Customer_Name__r.name ); //CH01.Update
        System.currentPageReference().getParameters().put('mpan', complaint.Customer_Name__r.Customer_Name__c);   //CH01.Update
        System.currentPageReference().getParameters().put('mprn', complaint.Premise__r.name);  
        System.currentPageReference().getParameters().put('Technician', complaint.Technician__r.name);
        System.currentPageReference().getParameters().put('Appointment', complaint.Appointment__r.name);  
        System.currentPageReference().getParameters().put('CustomerServiceAdvisorName', complaint.Customer_Service_Advisor_Name__c);   
        List<EON_Complaint__c> resultList = controller.getAppointmentResults();               
        PageReference pg = controller.displayRecord();    
       // System.assertEquals(resultList!=null,false);
       Test.stopTest();
       */
    }
    
    /**
        unitTest2() - unitTest2 - Failure test case
    **/
    testmethod static void unitTest2(){
    /*
      Test.startTest();
        EON_Complaint__c comp= EON_CreateTestRecords.createEonComplaint();
        comp.Complainant_Name__c = 'test Cust';
        //CH02.old comp.Complainant_Address__c = '12345';       //CH01.Update 
        comp.Complainant_Address_1__c = '12345'; 
        comp.Complainant_City__c = '12345'; 
        comp.Complainant_Post_Code1__c = '12345'; 
        insert comp;
        System.debug('Comp:'+comp);
        EON_Complaint__c complaint= [select Name,Customer_Name__r.name,Customer_Name__r.Customer_Name__c,Premise__r.name,Technician__r.name,Appointment__r.name,Customer_Service_Advisor_Name__c from EON_Complaint__c where id =: comp.id]; //CH01.Update
        EON_Complaint_Search_Result_Ctrl controller = new EON_Complaint_Search_Result_Ctrl();
        System.currentPageReference().getParameters().put('appointmentID', null);
        System.currentPageReference().getParameters().put('customerName', null ); 
        System.currentPageReference().getParameters().put('mpan', null);
        System.currentPageReference().getParameters().put('mprn', null);  
        System.currentPageReference().getParameters().put('Technician',null);
        System.currentPageReference().getParameters().put('Appointment', null);  
        System.currentPageReference().getParameters().put('CustomerServiceAdvisorName', null);
        System.currentPageReference().getParameters().put('Complaintaddress', null);      
        List<EON_Complaint__c> resultList = controller.getAppointmentResults();
        System.assertEquals(resultList,null);
        Test.stopTest();
        */}           
       
}