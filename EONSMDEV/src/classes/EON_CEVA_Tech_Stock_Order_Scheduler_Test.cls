/*
 Description : this class do the coverage of the below
              EON_CEVA_Tech_Stock_Order_Scheduler
            
*/

/*
 Created By     : GunaSekhar P
 Created Date   : 28/03/2018
 Service Request: SR_OptiMUS_EON_185 
*/
@isTest
public class EON_CEVA_Tech_Stock_Order_Scheduler_Test{
    
    public static testmethod void unitTest(){
    List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
    insert techlist;
    
     List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
    for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=techlist[0].id;
        lstStocks.add(stock);
        }       
        insert lstStocks;
     
    Test.StartTest();
    EON_CEVA_Tech_Stock_Order_Scheduler sh1 = new EON_CEVA_Tech_Stock_Order_Scheduler();
    String sch = '0 0 23 * * ?';
    system.schedule('Order Scheduler', sch, sh1);
    Test.stopTest(); 
    
    
    }
    
    }