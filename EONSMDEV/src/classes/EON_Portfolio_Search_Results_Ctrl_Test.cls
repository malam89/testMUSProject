/**
    Description : This test class is used to cover the below classes
            EON_Portfolio_Search_Results_Ctrl
**/
/*
    Created by : Praveen G
    Created Date : 11-April-2016
    Service Request : SR_Isis_EON_015
    Change History:
    CH01 # SR_EON_PC_047 # 19/05/2016 # Krishna Yalavarthi # Deleted reference for Customer lookup on EON Fuel.
*/
@isTest
public class EON_Portfolio_Search_Results_Ctrl_Test{
    
    /**
        unitTest1() - unitTest1 - Success test case
    **/
    testmethod static void unitTest1(){
        Eon_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        customer.Name = '1234567891';
        customer.Customer_Name__c = '1234567891';
        insert customer;
        
        EON_Site__c site = EON_CreateTestRecords.createEonSite();
        site.Customer__c = customer.id;
        site.Thorofare__c = 'test Street';
        site.Town__c = 'test town';
        site.PostCode__c = 'test PS';
        insert site;
        
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPAN__c = '12345';
        fuel.MPRN__c = '23467';
        //fuel.customer__c = customer.id; //CH01
        fuel.Premise__c = site.id;
        fuel.Customer_electric_account_reference__c = '12345';
        fuel.Electric_meter_serial_number__c = '12345';
        fuel.mpan__c = '1234';
        fuel.Customer_Gas_Account_Reference__c = '2345';
        fuel.Gas_meter_serial_number__c = '34567';
        fuel.mprn__c = '2345';
        insert fuel;
        
        System.currentPageReference().getParameters().put('customerID', customer.Name);
        System.currentPageReference().getParameters().put('customerName', customer.Customer_Name__c);
        System.currentPageReference().getParameters().put('street', site.Thorofare__c);
        System.currentPageReference().getParameters().put('town', site.town__c);
        System.currentPageReference().getParameters().put('postcode', site.PostCode__c);
        System.currentPageReference().getParameters().put('elecAcct', fuel.Customer_electric_account_reference__c);
        System.currentPageReference().getParameters().put('elecSN', fuel.Electric_meter_serial_number__c);
        System.currentPageReference().getParameters().put('mpan', fuel.mpan__c);
        System.currentPageReference().getParameters().put('gasAcct', fuel.Customer_Gas_Account_Reference__c);
        System.currentPageReference().getParameters().put('gasSN', fuel.Gas_meter_serial_number__c);
        System.currentPageReference().getParameters().put('mprn', fuel.mprn__c);
        
        EON_Portfolio_Search_Results_Ctrl controller = new EON_Portfolio_Search_Results_Ctrl();
        PageReference pg = controller.displayRecord();
        system.debug('pg value'+pg);
        System.assert(pg!=null);
        
    }
    
    /**
        unitTest2() - unitTest2 - Success test case
    **/
    testmethod static void unitTest2(){
        Eon_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        customer.Name = '1234567891';
        customer.Customer_Name__c = '1234567891';
        insert customer;
        
        EON_Site__c site = EON_CreateTestRecords.createEonSite();
        site.Customer__c = customer.id;
        site.Thorofare__c = 'test Street';
        site.Town__c = 'test town';
        site.PostCode__c = 'test PS';
        insert site;
        
        System.currentPageReference().getParameters().put('customerID', customer.Name);
        System.currentPageReference().getParameters().put('customerName', customer.Customer_Name__c);
        System.currentPageReference().getParameters().put('street', site.Thorofare__c);
        System.currentPageReference().getParameters().put('town', site.town__c);
        System.currentPageReference().getParameters().put('postcode', site.PostCode__c);
        System.currentPageReference().getParameters().put('elecAcct', '');
        System.currentPageReference().getParameters().put('elecSN', '');
        System.currentPageReference().getParameters().put('mpan', '');
        System.currentPageReference().getParameters().put('gasAcct', '');
        System.currentPageReference().getParameters().put('gasSN', '');
        System.currentPageReference().getParameters().put('mprn', '');        
        
        EON_Portfolio_Search_Results_Ctrl controller = new EON_Portfolio_Search_Results_Ctrl();
        PageReference pg = controller.displayRecord();
        System.assert(pg!=null);
        
    }   
    
    /**
        unitTest3() - unitTest3 - Success test case
    **/
    testmethod static void unitTest3(){
        Eon_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        customer.Name = '1234567891';
        customer.Customer_Name__c = '1234567891';
        insert customer;
        
        System.currentPageReference().getParameters().put('customerID', customer.Name);
        System.currentPageReference().getParameters().put('customerName', customer.Customer_Name__c);
        System.currentPageReference().getParameters().put('street', '');
        System.currentPageReference().getParameters().put('town', '');
        System.currentPageReference().getParameters().put('postcode', '');
        System.currentPageReference().getParameters().put('elecAcct', '');
        System.currentPageReference().getParameters().put('elecSN', '');
        System.currentPageReference().getParameters().put('mpan', '');
        System.currentPageReference().getParameters().put('gasAcct', '');
        System.currentPageReference().getParameters().put('gasSN', '');
        System.currentPageReference().getParameters().put('mprn', '');        
        
        EON_Portfolio_Search_Results_Ctrl controller = new EON_Portfolio_Search_Results_Ctrl();
        PageReference pg = controller.displayRecord();
        System.assert(pg!=null);
        
    }      
    
    /**
        unitTest4() - unitTest4 - Failure test case
    **/
    testmethod static void unitTest4(){
    
        System.currentPageReference().getParameters().put('customerID', '');
        System.currentPageReference().getParameters().put('customerName', '');
        System.currentPageReference().getParameters().put('street', '');
        System.currentPageReference().getParameters().put('town', '');
        System.currentPageReference().getParameters().put('postcode', '');
        System.currentPageReference().getParameters().put('elecAcct', '');
        System.currentPageReference().getParameters().put('elecSN', '');
        System.currentPageReference().getParameters().put('mpan', '');
        System.currentPageReference().getParameters().put('gasAcct', '');
        System.currentPageReference().getParameters().put('gasSN', '');
        System.currentPageReference().getParameters().put('mprn', '');  
            
        EON_Portfolio_Search_Results_Ctrl controller = new EON_Portfolio_Search_Results_Ctrl();
        PageReference pg = controller.displayRecord();
        System.assert(pg==null);        
    }
    
   /**
        unitTest5() - unitTest5 - Failure test case
    **/
    testmethod static void unitTest5(){
    
        System.currentPageReference().getParameters().put('customerID', 'test');
        System.currentPageReference().getParameters().put('customerName', '');
        System.currentPageReference().getParameters().put('street', '');
        System.currentPageReference().getParameters().put('town', '');
        System.currentPageReference().getParameters().put('postcode', '');
        System.currentPageReference().getParameters().put('elecAcct', '');
        System.currentPageReference().getParameters().put('elecSN', '');
        System.currentPageReference().getParameters().put('mpan', '');
        System.currentPageReference().getParameters().put('gasAcct', '');
        System.currentPageReference().getParameters().put('gasSN', '');
        System.currentPageReference().getParameters().put('mprn', '');  
            
        EON_Portfolio_Search_Results_Ctrl controller = new EON_Portfolio_Search_Results_Ctrl();
        controller.closeQuotes = 'test  ';
        PageReference pg = controller.displayRecord();
        System.assert(pg==null);        
    }  
    
    /**
        unitTest6() - unitTest6 - Failure test case
    **/
    testmethod static void unitTest6(){
    
        System.currentPageReference().getParameters().put('customerID', 'test');
        System.currentPageReference().getParameters().put('customerName', '');
        System.currentPageReference().getParameters().put('street', '');
        System.currentPageReference().getParameters().put('town', '');
        System.currentPageReference().getParameters().put('postcode', '');
        System.currentPageReference().getParameters().put('elecAcct', '');
        System.currentPageReference().getParameters().put('elecSN', '');
        System.currentPageReference().getParameters().put('mpan', '');
        System.currentPageReference().getParameters().put('gasAcct', '');
        System.currentPageReference().getParameters().put('gasSN', '');
        System.currentPageReference().getParameters().put('mprn', '2345');  
            
        EON_Portfolio_Search_Results_Ctrl controller = new EON_Portfolio_Search_Results_Ctrl();
        controller.closeQuotes = 'test  ';
        PageReference pg = controller.displayRecord();
        System.assert(pg==null);        
    }            
}