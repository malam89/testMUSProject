/**
    Description : This test class is used to cover the below classesEON_NonCustomer_Result_Ctrl
                  1.EON_NonCustomer_Result_Ctrl
**/
/*
    Created by :Aruna Manjari
    Created Date : 27-April-2016
    Service Request : SR_EON_PC_028
    Change History
        CH01 # SR_EON_PC_099 # 09/01/2017 # Mahadev J # Changed data type of field - Complainant_Address__c
        CH02 # SR_EON_PC_101 # 18/01/2017 # Aruna Manjari # Removed the reference of the field - Complainant_Address__c and added new field (Complainant_Address_1__c,Complainant_City__c,Complainant_Post_Code1__c)
*/ 

@isTest
public class EON_NonCustomer_Result_Ctrl_Test{

    /**
        unitTest1() - unitTest1 - Success test case
    **/
    testmethod static void unitTest1(){
        Test.startTest();
        EON_Complaint__c comp= EON_CreateTestRecords.createEonComplaint();
        comp.Complainant_Name__c = 'test Cust';
        //CH02.old comp.Complainant_Address__c = '12345';        //CH01.Update
        comp.Complainant_Address_1__c='Addresss';
        comp.Complainant_City__c='city';
        comp.Complainant_Post_Code1__c='post code';
        insert comp;
        System.debug('Comp:'+comp);
        EON_Complaint__c complaint= [select Complainant_Name__c ,/*CH02.New */ Complainant_Address_1__c,Complainant_City__c,Complainant_Post_Code1__c /*CH02.old Complainant_Address__c */ /*CH01.Update*/ from EON_Complaint__c where id =: comp.id];                     
        EON_NonCustomer_Result_Ctrl controller = new EON_NonCustomer_Result_Ctrl();
        System.currentPageReference().getParameters().put('appointmentID', complaint.Complainant_Name__c);
        //CH02.Old System.currentPageReference().getParameters().put('Complaintaddress', complaint.Complainant_Address__c);  //CH01.Update
        //CH02.Start
        System.currentPageReference().getParameters().put('Complaintaddress', complaint.Complainant_Address_1__c);  
        System.currentPageReference().getParameters().put('Complaintaddress', complaint.Complainant_City__c);  
        System.currentPageReference().getParameters().put('Complaintaddress', complaint.Complainant_Post_Code1__c);  
        // CH02.End
        List<EON_Complaint__c> resultList = controller.getAppointmentResults();               
        PageReference pg = controller.displayRecord();    
        System.assertEquals(resultList.size()>0,true);
       Test.stopTest();
    }
    
    /**
        unitTest2() - unitTest2 - Failure test case
    **/
    testmethod static void unitTest2(){
      Test.startTest();
        EON_Complaint__c comp= EON_CreateTestRecords.createEonComplaint();
        comp.Complainant_Name__c = 'test Cust';
        //CH02.Old comp.Complainant_Address__c = '12345'; //CH01.Update
        comp.Complainant_Address_1__c = '12345';
        comp.Complainant_City__c = '12345';
        comp.Complainant_Post_Code1__c = '12345';  
        insert comp;
        System.debug('Comp:'+comp);
        EON_Complaint__c complaint= [select Complainant_Name__c ,/*CH02.old  Complainant_Address__c/*CH01.Update*/  /*CH02.New*/ Complainant_Address_1__c,Complainant_City__c,Complainant_Post_Code1__c  from EON_Complaint__c where id =: comp.id];                     
        EON_NonCustomer_Result_Ctrl controller = new EON_NonCustomer_Result_Ctrl();
        System.currentPageReference().getParameters().put('appointmentID',null);
        System.currentPageReference().getParameters().put('Complaintaddress',null);        
        List<EON_Complaint__c> resultList = controller.getAppointmentResults();
        System.assertEquals(resultList,null);  
        Test.stopTest();
    }           
       
}