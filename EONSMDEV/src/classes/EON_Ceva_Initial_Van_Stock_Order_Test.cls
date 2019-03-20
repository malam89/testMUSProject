/**
    Description : This Test Class covers the code for following classes/Triggers
    Class: EON_Ceva_Initial_Van_Stock_Order           
**/

/*
    created By : Shruti Moghe
    Created Date : 21-Mar-2016
    Service Request : SR_EON_AL_003
    Change History:
    CH01 # SR_EON_AL_010 # 13/04/2016 # Shruti Moghe #changed as per SR requirements
    CH02 # 13/09/2016 # Shruti Moghe # Renamed the class from EON_Initial_Van_Stock_Order_Test to EON_Ceva_Initial_Van_Stock_Order_Test

    
*/
@isTest
public class EON_Ceva_Initial_Van_Stock_Order_Test{
     public static boolean genException=false;        

    /**
         EmailToCEVAProcessData_PASS():- Postitive Unit test for the method  EmailToCEVAProcessData()
    **/   
    static testMethod void EmailToCEVAProcessData_PASS(){
     
        List<EON_Technician__c> TechList= EON_CreateTestRecords.createEonTechnicianList();        
        insert TechList;    
        System.debug('Technicians List------------->'+TechList);
        TechList[0].Date_left__c=null;
        TechList[0].h_Send_to_CEVA__c=system.today();
        TechList[0].h_IsProcessed__c=false;
        TechList[0].h_Order_Sent__c =true;
        update TechList[0];
        EON_Utility.createAttachment(TechList[0].id,'Testing','MUS New Starter Kit');
        List<EON_Product__c> products = EON_CreateTestRecords.createEonProduct();
        insert products;
        //EON_Initial_Van_Stock_Order_Scheduler scheduler = new EON_Initial_Van_Stock_Order_Scheduler();//CH01.old
        //scheduler.EmailToCEVAProcessData();//CH01.old
        EON_Ceva_Initial_Van_Stock_Order.EmailToCEVAProcessData(TechList[0].id);//CH01
        EON_Technician__c tech= [select id ,h_IsProcessed__c from EON_Technician__c limit 1 ];
    
    }
     static testMethod void EmailToCEVAProcessData_PASS1(){
     
        List<EON_Technician__c> TechList= EON_CreateTestRecords.createEonTechnicianList();        
        insert TechList;    
        System.debug('Technicians List------------->'+TechList);
        TechList[0].Date_left__c=null;
        TechList[0].h_Send_to_CEVA__c=system.today();
        TechList[0].h_IsProcessed__c=false;
        TechList[0].h_Order_Sent__c =true;
        update TechList[0];
        EON_Utility.createAttachment(TechList[0].id,'Testing','MUS New Starter Kit');
        List<EON_Product__c> products = EON_CreateTestRecords.createEonProduct();
        insert products;
        //EON_Initial_Van_Stock_Order_Scheduler scheduler = new EON_Initial_Van_Stock_Order_Scheduler();//CH01.old
        //scheduler.EmailToCEVAProcessData();//CH01.old
        EON_Ceva_Initial_Van_Stock_Order_Test.genException=true;
        EON_Ceva_Initial_Van_Stock_Order.EmailToCEVAProcessData(TechList[0].id);
        EON_Ceva_Initial_Van_Stock_Order_Test.genException=false;
        EON_Ceva_Initial_Van_Stock_Order.EmailToCEVAProcessData(TechList[0].id);//CH01
        EON_Technician__c tech= [select id ,h_IsProcessed__c from EON_Technician__c limit 1 ];
    
    }
    /**
         EmailToCEVAProcessData_FAIL() :- Negative Unit test for the method  EmailToCEVAProcessData()  
    **/  
    static testMethod void EmailToCEVAProcessData_FAIL1(){
        List<EON_Technician__c> TechList= EON_CreateTestRecords.createEonTechnicianList();        
        insert TechList;    
        System.debug('Technicians List------------->'+TechList);
        TechList[0].Date_left__c=null;
        TechList[0].h_Send_to_CEVA__c=system.today();
        TechList[0].h_IsProcessed__c=false;
        TechList[0].h_Order_Sent__c =true;
        update TechList[0];
        List<EON_Product__c> products = EON_CreateTestRecords.createEonProduct();
        insert products;
        //EON_Initial_Van_Stock_Order_Scheduler scheduler = new EON_Initial_Van_Stock_Order_Scheduler();//CH01.old
        //scheduler.EmailToCEVAProcessData();//CH01.old
        EON_Ceva_Initial_Van_Stock_Order.EmailToCEVAProcessData(TechList[0].id);//CH01
        EON_Technician__c tech= [select id ,h_IsProcessed__c from EON_Technician__c limit 1 ];
        System.assert(tech.h_IsProcessed__c=true);       
    }
    
    /**
         EmailToCEVAProcessData_FAIL2() :- Negative Unit test for the method  EmailToCEVAProcessData()  
    **/  
    static testMethod void EmailToCEVAProcessData_FAIL2(){      
        List<EON_Product__c> products = EON_CreateTestRecords.createEonProduct();
        insert products;
        //EON_Initial_Van_Stock_Order_Scheduler scheduler = new EON_Initial_Van_Stock_Order_Scheduler();//CH01.old
        //scheduler.EmailToCEVAProcessData();//CH01.old
        
        try{
        EON_Ceva_Initial_Van_Stock_Order.EmailToCEVAProcessData(new EON_Technician__c().id);//CH01       
        }
        catch(Exception e){}             
    }
}