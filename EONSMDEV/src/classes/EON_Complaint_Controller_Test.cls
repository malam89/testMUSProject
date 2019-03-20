/**
Description : This test class is for the following below classes/triggers
              EON_Complaint_Controller
              
**/

/*
    Created By  : Mehboob Alam
    Created On  : 02/10/2017
    Service Req : SR_OptiMUS_EON_107
    Covering Components : EON_Complaint_Controller
    Change History
*/
@isTest
private class EON_Complaint_Controller_Test {

    static testMethod void myUnitTest() {
    	
    	Contract_Number__c contract = EON_CreateTestRecords.createContractNumber();
        contract.Contract_Client_Short_Name__c = 'EON';
        insert contract;
        
    	EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Appointment_Date__c = System.today();
        app.Contract__c = contract.id;
        app.Customer_Preferred_Contact_Method__c='H';
        insert app; 
        
        EON_Complaint__c eonCOmplaint = EON_CreateTestRecords.createEonComplaint();
        insert eonCOmplaint;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(eonCOmplaint);
        ApexPages.currentPage().getParameters().put('ApptId', app.id);  
        stdController.getRecord();
        EON_Complaint_Controller controller = new EON_Complaint_Controller(stdController);
    }
    
        static testMethod void myUnitTest2() {
    	
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        
        //Create EON Customer
        list<EON_Customer__c> allCustomer = new list<EON_Customer__c>();
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        customer.Name = '9999999999';
        allCustomer.add(customer);
        
        EON_Customer__c customerNew = EON_CreateTestRecords.createEONCustomer();
        customerNew.Name = '7777777777';
        allCustomer.add(customerNew);
        
        EON_Customer__c customerD = EON_CreateTestRecords.createEONCustomer();
        customerD.Name = '8888888888';
        customerD.Eon_Customer_Change_Type__c = 'D';
        allCustomer.add(customerD);       
        insert allCustomer;
        
        //Create EON Contact Representative
        list<EON_Contact_representative__c> allContactRep = new list<EON_Contact_representative__c>();
        EON_Contact_representative__c representative = EON_CreateTestRecords.createEonContactRepresentative();
        representative.Name = '1223';
        representative.Customer__c = customer.ID;
        allContactRep.add(representative);
        
        EON_Contact_representative__c representativeD = EON_CreateTestRecords.createEonContactRepresentative();
        representativeD.Name = '1224';
        representativeD.Eon_Contact_Representative_Change_Type__c = 'D';
        representativeD.Customer__c = customerD.ID;
        allContactRep.add(representativeD);
        insert allContactRep;
        
        EON_Contact_Media__c contactMedia = EON_CreateTestRecords.createEonContactMedia();
        contactMedia.Name = '1234';
        contactMedia.Email__c ='abc@test.com';
        contactMedia.Customer__c = eCust.ID;
        contactMedia.Representative__c = representative.ID;
        insert contactMedia;
    	
    	EON_Site__c eSite =  new EON_Site__c(Customer__c=eCust.ID, Name = '1234567890',Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',
    	                         Address_Type__c = 'S',Country__c = null ,County__c = null,Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',
    	                         Double_Dependant_Locality__c = 'Stevenage',Sub_Building_Name__c = 'Stevenage',Thorofare__c = 'Stevenage',Town__c = 'Stevenage');
        insert eSite;
    	
    	
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '121'; 
        eFuel.Premise__c = eSite.id;
        eFuel.Fuel_type__c='E';
        insert eFuel;
        
        
    	Contract_Number__c contract = EON_CreateTestRecords.createContractNumber();
        contract.Contract_Client_Short_Name__c = 'EON';
        insert contract;
        
    	EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Appointment_Date__c = System.today();
        app.Contract__c = contract.id;
        insert app; 
        
        EON_Complaint__c eonCOmplaint = EON_CreateTestRecords.createEonComplaint();
        insert eonCOmplaint;
       
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(eonCOmplaint);
        ApexPages.currentPage().getParameters().put('CustId', eCust.id);  
        stdController.getRecord();
        EON_Complaint_Controller controller = new EON_Complaint_Controller(stdController);
    }
    
    
      static testMethod void myUnitTest3() {
        
        EON_Complaint__c eonCOmplaint = EON_CreateTestRecords.createEonComplaint();
        insert eonCOmplaint;
       
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(eonCOmplaint);
        stdController.getRecord();
        EON_Complaint_Controller controller = new EON_Complaint_Controller(stdController);
        controller.saveNew();
    }
}