/*
    Description : this class do the coverage of the below
            EON_Job_Results_Trigger_Helper_Stock
            EON_Fault_Asset_Trigger_Helper
*/

/*
ChangeHistory:
       CH01# SR_OptiMUS_EON_185 # Guna Sekhar P # Increased the code coverage
*/
@isTest
public class EON_Job_Results_Trigger_Stock_Test{
    
    public static testmethod void unitTest(){
        EON_Job_Results__c jobResult = EON_CreateTestRecords.createEon_Job_Results();
        jobresult.E_Meter_Removed__c = 'Yes';
        jobresult.G_Meter_Removed__c = 'Yes';
        jobresult.E_Meter_Manufacturer__c = '12365';
        jobresult.Removed_E_Meter_Asset_Tag__c = 'Test Tag';
        jobResult.E_Meter_Type__c = 'Type';
        jobResult.G_Meter_Manufacturer__c = 'G1234';
        jobResult.Removed_G_Meter_Asset_Tag__c = 'GAsset';
        jobResult.G_Meter_Type__c = 'GType';
        jobResult.Original_E_Meter_refitted__c = 'No';
        jobResult.Original_G_Meter_refitted__c = 'No';
        jobResult.Removed_Gas_Regulator_Serial_Number__c='12345';
        jobResult.Found_IHD_Serial_Number__c='12345';
        jobResult.Found_Comms_Hub_Serial_Number__c='123456789102';
        jobResult.E_Meter_Serial_Number__c='123456';
        jobResult.G_Meter_Serial_Number__c='123456';
        insert jobResult;
         jobResult.Removed_Gas_Regulator_Serial_Number__c='123456';
        jobResult.Found_IHD_Serial_Number__c='123456';
        jobResult.Found_Comms_Hub_Serial_Number__c='1234567891026';
        jobResult.E_Meter_Serial_Number__c='1234566';
        jobResult.G_Meter_Serial_Number__c='1234566';
        jobResult.Removed_Comms_Hub_Reason__c='Faulty/ Damaged';
        jobResult.Removed_E_Meter_Reason__c='Faulty/ Damaged';
        jobResult.Removed_G_Meter_Reason__c='Faulty/ Damaged';
        jobResult.Removed_IHD_Reason__c='Fault / Damaged';
        jobResult.Removed_Regulator_Reason__c='Faulty/ Damaged';
        Update jobResult;
    }
    
    public static testmethod void unitTest5(){
        EON_Job_Results__c jobResult = EON_CreateTestRecords.createEon_Job_Results();
        jobresult.E_Meter_Removed__c = 'Yes';
        jobresult.G_Meter_Removed__c = 'Yes';
        jobresult.E_Meter_Manufacturer__c = '12365';
        jobresult.Removed_E_Meter_Asset_Tag__c = 'Test Tag';
        jobResult.E_Meter_Type__c = 'Type';
        jobResult.G_Meter_Manufacturer__c = 'G1234';
        jobResult.Removed_G_Meter_Asset_Tag__c = 'GAsset';
        jobResult.G_Meter_Type__c = 'GType';
        jobResult.Original_E_Meter_refitted__c = 'Yes';
        jobResult.Original_G_Meter_refitted__c = 'Yes';
        
        insert jobResult;
    }    
    
    public static testmethod void unitTest6(){
        EON_Job_Results__c jobResult = EON_CreateTestRecords.createEon_Job_Results();
        jobresult.E_Meter_Removed__c = 'No';
        jobresult.G_Meter_Removed__c = 'No';
        jobresult.E_Meter_Manufacturer__c = '12365';
        jobresult.Removed_E_Meter_Asset_Tag__c = 'Test Tag';
        jobResult.E_Meter_Type__c = 'Type';
        jobResult.G_Meter_Manufacturer__c = 'G1234';
        jobResult.Removed_G_Meter_Asset_Tag__c = 'GAsset';
        jobResult.G_Meter_Type__c = 'GType';
        jobResult.Original_E_Meter_refitted__c = 'No';
        jobResult.Original_G_Meter_refitted__c = 'No';
        
        insert jobResult;
        
        jobresult.E_Meter_Removed__c = 'Yes';
        jobresult.G_Meter_Removed__c = 'Yes';    
        update jobResult;    
    }   
    
    public static testmethod void unitTest7(){
        EON_Job_Results__c jobResult = EON_CreateTestRecords.createEon_Job_Results();
        jobresult.E_Meter_Removed__c = 'No';
        jobresult.G_Meter_Removed__c = 'No';
        jobresult.E_Meter_Manufacturer__c = '12365';
        jobresult.Removed_E_Meter_Asset_Tag__c = 'Test Tag';
        jobResult.E_Meter_Type__c = 'Type';
        jobResult.G_Meter_Manufacturer__c = 'G1234';
        jobResult.Removed_G_Meter_Asset_Tag__c = 'GAsset';
        jobResult.G_Meter_Type__c = 'GType';
        jobResult.Original_E_Meter_refitted__c = 'Yes';
        jobResult.Original_G_Meter_refitted__c = 'Yes';
        
        insert jobResult;
        
        jobresult.E_Meter_Removed__c = 'Yes';
        jobresult.G_Meter_Removed__c = 'Yes';    
        update jobResult;    
    }      
    
    public static testmethod void unitTest1(){
        EON_Job_Results__c jobResult1 = EON_CreateTestRecords.createEon_Job_Results();
        jobresult1.E_Meter_Manufacturer__c = '12365';
        insert jobResult1;
        
        jobresult1.E_Meter_Removed__c = 'Yes';
        jobresult1.G_Meter_Removed__c = 'Yes';
        jobresult1.E_Meter_Manufacturer__c = '1236547893214569871236541236546547';
        jobResult1.Removed_E_Meter_Asset_Tag__c = 'TESTTESTTESTTESTTEST';
        jobResult1.E_Meter_Type__c = '1236547893214569871236541236546547';
        
        jobresult1.G_Meter_Manufacturer__c = '1236547893214569871236541236546547';
        jobResult1.Removed_G_Meter_Asset_Tag__c = 'TESTTESTTESTTESTTEST';
        jobResult1.G_Meter_Type__c = '1236547893214569871236541236546547';        
        
        update jobResult1;
    }    
    /*
    public static testmethod void unitTest3(){
        try{
            EON_Job_Results_Trigger_Helper_Stock.CreateStockRecords(null, null);
        }catch(Exception ex){
        }
    }
    */
    public Static testmethod void unitTest4(){
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
            stock.status__c = 'On Van';
            stock.Technician_Name__c =techlist[0].id;
            lstStocks.add(stock);
        } 
        insert lstStocks;   
        
        Eon_Appointment__c eonApp = EON_CreateTestRecords.createEONAppointment();
        eonApp.Technician__c = techlist[0].id;
        insert eonApp;
        
        EON_Faulty_Asset__c faultyAsset = new EON_Faulty_Asset__c();
        faultyAsset.Job_Reference__c = eonApp.id; 
        faultyAsset.Serial_Number_1__c = '1234'; 
        faultyAsset.Serial_Number_2__c = '1235';   
        faultyAsset.Serial_Number_3__c = '1236'; 
        faultyAsset.Serial_Number_4__c = '1237'; 
        insert faultyAsset;
        
                
        
    }
}