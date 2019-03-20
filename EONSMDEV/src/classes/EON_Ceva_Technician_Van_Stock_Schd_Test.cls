/**
        Description : This Test Class covers the code for following classes/Triggers
        Class: 1.EON_Ceva_Technician_Van_Stock_Scheduler           
               2.EON_Check_Technician_Van_Stock_Helper
    **/

    /*
        created By : Tashika Gupta
        Created Date : 09/04/2016
        Service Request : SR_EON_AL_007
        Change History:
        CH01 # SR_EON_AL_016 # 06/06/2016 # Tashika G # Added method to cover class EON_Check_Technician_Van_Stock_Helper.
        CH02 #SR_EON_AL_032 # 22/08/2016 # Shruti Moghe # Added logic to update the code coverage
        CH03 # 13/09/2016 # Shruti Moghe # Renamed the class from EON_Check_Technician_Van_Stock_Schd_Test to EON_Ceva_Technician_Van_Stock_Schd_Test

    */
    @isTest(SeeAllData=false)
    public class EON_Ceva_Technician_Van_Stock_Schd_Test{
        public static boolean genException;
        /**
             EmailToCEVAProcessData_PASS():- Postitive Unit test for the method  EmailToCEVAProcessData()
        **/   
        static testMethod void EmailToCEVAProcessData_PASS(){
        
            EON_Ceva_Technician_Van_Stock_Scheduler scheduler = new EON_Ceva_Technician_Van_Stock_Scheduler();
            String sch = '0 0 8 1/1 * ? *';
            system.schedule('Test', sch, scheduler);
            
            List<EON_Technician__c> TechList = EON_CreateTestRecords.createEonTechnicianList();
            insert TechList;
            
            List<EON_Product__c> products = EON_CreateTestRecords.createEonProduct();
            insert products;
            
            List<EON_Stock__c> stockList = EON_CreateTestRecords.createEonStockList();
            for(EON_Stock__c  sList : stockList ){
                sList.Technician_Name__c = TechList[0].id;
            
            }
            
            insert stockList;
            System.assertEquals(TechList[0].h_BAU_Order_sent__c,false);    
        }
        //CH01.Start
         /**
             getResrvationNumber_PASS1():- Postitive Unit test for the method  GetReservationNumber().
        **/   
        static testMethod void getResrvationNumber_PASS1(){
        
            EON_Ceva_Technician_Van_Stock_Scheduler scheduler = new EON_Ceva_Technician_Van_Stock_Scheduler();
            String sch = '0 0 8 1/1 * ? *';
            system.schedule('Test', sch, scheduler);
        
            List<EON_Technician__c> TechList = EON_CreateTestRecords.createEonTechnicianList();
            insert TechList;
            
            List<EON_Product__c> products = EON_CreateTestRecords.createEonProduct();
            insert products;
            
            List<EON_Stock__c> stockList = EON_CreateTestRecords.createEonStockList();
            for(EON_Stock__c  sList : stockList ){
                sList.Technician_Name__c = TechList[0].id;
            }
            insert stockList;
            System.assertEquals(TechList[0].h_BAU_Order_sent__c,false);   
            
            List<EON_Order__c> orderList1 = EON_CreateTestRecords.createEon_OrderList();
            orderList1[0].Technician_Name__c = TechList[0].id;
            orderList1[0].Reservation__c = '';
            orderList1[1].Technician_Name__c = TechList[0].id;
            orderList1[1].Reservation__c = '9600000001';
            insert orderList1;
            system.debug('^^^^order list ^^^^'+orderList1);
            
        }
        
         /**
             getResrvationNumber_PASS2():- Postitive Unit test for the method  GetReservationNumber()
        **/   
        static testMethod void getResrvationNumber_PASS2(){
        
            List<EON_Technician__c> TechList = EON_CreateTestRecords.createEonTechnicianList();
            insert TechList;
            EON_Check_Technician_Van_Stock_Helper.GetReservationNumber();
            List<EON_Order__c> orderList2 = EON_CreateTestRecords.createEon_OrderList();
            orderList2[0].Technician_Name__c = TechList[1].id;
            orderList2[0].Reservation__c = '';
            orderList2[1].Technician_Name__c = TechList[1].id;
            insert orderList2;
            
            EON_Ceva_Utility.GetReservationNumber();
            EON_Check_Technician_Van_Stock_Helper.GetReservationNumber();
            system.assertEquals(orderList2[0].Reservation__c,'');
        }
        //CH01.End
        
        //CH02.start
    @isTest static void BAUTriggerPopulateDateFields_Test() {
        
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='RJ', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='TestingAl@mus.com');
       System.runAs(u) {
        Test.startTest();
            EON_Ceva_Technician_Van_Stock_Scheduler scheduler = new EON_Ceva_Technician_Van_Stock_Scheduler();
            String sch = '0 0 8 1/1 * ? *';
            system.schedule('Test', sch, scheduler);  
            List<EON_Product__c> products = EON_CreateTestRecords.createEonProduct();
            insert products;
            List<EON_Technician__c> TechList = EON_CreateTestRecords.createEonTechnicianList();
            insert TechList;
            
            List<EON_Stock__c> stockList = EON_CreateTestRecords.createEonStockList();
            for(EON_Stock__c  sList : stockList ){
                sList.Technician_Name__c = TechList[0].id;
            
            }
            insert stockList;
            TechList[0].h_BAU_Check_Processed__c = true;
            TechList[0].h_Processed_BAU__c=false;
            update TechList[0];   
                
        Test.stopTest();
        }
    }
    //CH02.end
    	/**
             generateException_PASS():- This will cover exception
        **/   
        static testMethod void generateException_PASS(){
        	EON_Ceva_Technician_Van_Stock_Schd_Test.genException = true;
            EON_Ceva_Technician_Van_Stock_Scheduler scheduler = new EON_Ceva_Technician_Van_Stock_Scheduler();
            String sch = '0 0 8 1/1 * ? *';
            system.schedule('Test', sch, scheduler);
            
            List<EON_Technician__c> TechList = EON_CreateTestRecords.createEonTechnicianList();
            insert TechList;
            
            List<EON_Product__c> products = EON_CreateTestRecords.createEonProduct();
            insert products;
            
            List<EON_Stock__c> stockList = EON_CreateTestRecords.createEonStockList();
            for(EON_Stock__c  sList : stockList ){
                sList.Technician_Name__c = TechList[0].id;
            
            }
            insert stockList;
            System.assertEquals(TechList[0].h_BAU_Order_sent__c,false);    
        }
    }