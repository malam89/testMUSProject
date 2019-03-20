/**
    Description : This Test Class covers the code for following classes/Triggers
    Class: EON_Ceva_Stock_Reconciliation_Process
**/

/*
    created By : Shruti Moghe
    Created Date : 11-Apr-2016
    Service Request : SR_EON_AL_005
    CHANGE HISTORY: 
    CH01 # SR_EON_AL_020 # 10-06-2016 # Purvi  # Added new method to cover functionality as per SR.  
    CH02 # SR_EON_AL_033 # 10-09-2016 # Mahadev J # Covers code
    CH03 # SR_EON_AL_038 # 21-02-2017 # Praveen G # Added new method for new changes in SR.
    CH04 # SR_OptiMUS_EON_146 # 01/02/2018 #Guna P # increased the code coverage.
*/
@isTest(SeeAllData=false)
public class EON_Ceva_Stock_Reconcil_Process_Test{
    public static boolean genException=false;        

   
   /**
      JobResults_AfterInsert_Pass_Test() : Positive Unit Testing 
   **/
    static testMethod void JobResults_AfterInsert_Pass_Test(){
        EON_Job_Results__c jobRes = EON_CreateTestRecords.createEon_Job_Results();
        jobRes.Job_Status__c = 'Aborted';
        insert jobRes;
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        lstStocks= EON_CreateTestRecords.createEonStockList();
        lstStocks[0].Technician_Name__c=job.Technician__c;
        lstStocks[0].Serial_Number__c='1234';
        insert lstStocks[0];
        List<EON_Job_Results__c> jobList= new List<EON_Job_Results__c>();
        jobList.add(job);
        EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_Process_JobResults(jobList,true);               
        try{
        EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_JobResults( new List<EON_Job_Results__c>(),true,new Map<id,EON_Job_Results__c>());
        }
        catch(exception e){}
    }
    /**
      JobResults_AfterInsert_Fail_Test() : Negative Unit Testing 
   **/
    static testMethod void JobResults_AfterInsert_Fail_Test(){
         
        EON_Job_Results__c Job1 = EON_CreateTestRecords.createEon_Job_Results();
        Job1.Found_Comms_Hub_Serial_Number__c='23565676';
        Job1.Found_IHD_Serial_Number__c='23565676';     
        insert Job1;
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        lstStocks= EON_CreateTestRecords.createEonStockList();
        lstStocks[0].Technician_Name__c=job.Technician__c;
        lstStocks[0].Serial_Number__c='2345';       
        insert lstStocks[0];
        List<EON_Job_Results__c> jobList= new List<EON_Job_Results__c>();
        jobList.add(job);
        EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_Process_JobResults(jobList,true);               
        EON_Ceva_Stock_Reconciliation_Process.ProcessStockRecords(new EON_Job_Results__c(),new List<EON_Stock__c>());
        
    }
    /**
      Process_JobResults_Test2() : Testing multiple Stock Records Scenario for some serial numbers 
   **/

    static testMethod void Process_JobResults_Test2(){
         
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id,Installed_Cradle_Serial_Number__c,Installed_Hot_Shoe_Serial_Number__c,Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=techlist[0].id;        
        lstStocks.add(stock);       
        }       
        insert lstStocks;
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        stock.status__c='On Van';
        lstStocksupdate.add(stock);
        }
        lstStocksupdate[0].Serial_Number__c='5345';
        update lstStocksupdate;
        job.New_IHD_Serial_Number__c='2345';
        job.New_Comms_Hub_Serial_Number__c='5345';
        update job;
        job.Found_IHD_Serial_Number__c='12345'; 
        job.Found_Comms_Hub_Serial_Number__c='12345';
        
        update job;
              
   }
    //CH 01 Start
    /**
      Process_JobResults_TestIHD() : testing matching technician with Job Result
   **/

    static testMethod void Process_JobResults_TestIHD(){
         
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Installed_Cradle_Serial_Number__c,Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=job.Technician__c; 
        lstStocks.add(stock);       
        }       
        insert lstStocks;
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        stock.status__c='On Van';
        lstStocksupdate.add(stock);
        }
        lstStocksupdate[0].Serial_Number__c='5345';
        update lstStocksupdate;
        job.New_IHD_Serial_Number__c='2345';
        job.New_Comms_Hub_Serial_Number__c='5345';
        update job;
        job.Found_IHD_Serial_Number__c='12345'; 
        job.Found_Comms_Hub_Serial_Number__c='12345';
        update job;
        job.Installed_Cradle_Serial_Number__c='2354';                    
        update job;
    }    //CH01 End
     /**
      Process_JobResults_Test3() :  Testing multiple Stock Records Scenario for other serial numbers  
   **/
    static testMethod void Process_JobResults_Test3(){
        
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=techlist[0].id;
        lstStocks.add(stock);
        }       
        insert lstStocks;
        for(EON_Stock__c stock : lstStocks){
            stock.Serial_Number__c='Test'; 
            lstStocksupdate.add(stock);
        }
        update lstStocksupdate;
        job.New_Gas_Regulator_Serial_Number__c='Test';      
        job.New_G_Meter_Serial_Number__c='Test';
        job.New_E_Meter_Serial_Number__c='Test';
        job.Removed_Gas_Regulator_Serial_Number__c='Test';
        job.E_Meter_Removed__c='no';
        job.G_Meter_Removed__c='no';
        job.G_Meter_Installed__c='no';
        job.E_Meter_Installed__c= 'no'; 
        job.Removed_G_Meter_Serial_Number__c='Test';        
        job.Removed_E_Meter_Serial_Number__c='Test';
        update job;           
    }
    /**
      Process_JobResults_Test4() :  Technician not matching scenario
    **/
     static testMethod void Process_JobResults_Test4(){
        
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        
        List<EON_Technician__c> lstTech = EON_CreateTestRecords.createEonTechnicianList();
        insert lstTech;
        
        EON_Stock__c eonstock= EON_CreateTestRecords.createEonStock();
        eonstock.Technician_Name__c=lstTech[0].id;
        insert eonstock;
        
        EON_Stock__c eonstock1= EON_CreateTestRecords.createEonStock();
        eonstock1.Technician_Name__c=lstTech[1].id;
        insert eonstock1;
        eonstock1.Serial_Number__c='1234';
        Update eonstock1;
        
        EON_Stock__c eonstock2= EON_CreateTestRecords.createEonStock();
        eonstock2.Technician_Name__c=lstTech[2].id;
        insert eonstock2;
        eonstock2.Serial_Number__c='4125';
        Update eonstock2;
        
        EON_Stock__c eonstock3= EON_CreateTestRecords.createEonStock();
        eonstock3.Technician_Name__c=lstTech[3].id;
        insert eonstock3;
        eonstock3.Serial_Number__c='6787';
        Update eonstock3;
        
        EON_Stock__c eonstock4= EON_CreateTestRecords.createEonStock();
        eonstock4.Technician_Name__c=lstTech[4].id;
        insert eonstock4;
        eonstock4.Serial_Number__c='';
        update eonstock4;      
        job.New_E_Meter_Serial_Number__c='6787';
        update job;     
    }
    /**
      Process_JobResults_Test5() :  Stock Record Creation Scenario
    **/
    static testMethod void Process_JobResults_Test5(){
        EON_Job_Results__c Job1 = EON_CreateTestRecords.createEon_Job_Results();
        Job1.Found_Comms_Hub_Serial_Number__c='23565676';
        Job1.Found_IHD_Serial_Number__c='23565676';
        job1.New_IHD_Serial_Number__c='';
        job1.New_Comms_Hub_Serial_Number__c='';
        job1.Installed_Cradle_Serial_Number__c='2345';
        job1.Installed_Hot_Shoe_Serial_Number__c='2345';
        insert Job1;
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=techlist[0].id;
        lstStocks.add(stock);
        }       
        insert lstStocks;
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        lstStocksupdate.add(stock);
        }
        update lstStocksupdate;
        job.New_IHD_Serial_Number__c='2345';
        job.New_Comms_Hub_Serial_Number__c='2345';
        job.Found_IHD_Serial_Number__c='2345'; 
        job.Found_Comms_Hub_Serial_Number__c='2345';
        update job;
    
    }
    /**
      Process_JobResults_Test6() :  Stock Record updation Scenario
    **/
    static testMethod void Process_JobResults_Test6(){
         
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        techlist[0].name='MUSTechnicianTest';
        insert techlist[0];
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=techlist[0].id;        
        lstStocks.add(stock);       
        }       
        insert lstStocks;
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        stock.status__c='On Van';
        lstStocksupdate.add(stock);
        }
        lstStocksupdate[0].Serial_Number__c='1345';
        lstStocksupdate[1].Serial_Number__c='2345';
        lstStocksupdate[2].Serial_Number__c='4345';
        lstStocksupdate[3].Serial_Number__c='5345';
        lstStocksupdate[4].Serial_Number__c='6345';
        update lstStocksupdate;
        job.New_IHD_Serial_Number__c='2345';
        job.New_Gas_Regulator_Serial_Number__c='1345';      
        job.New_G_Meter_Serial_Number__c='4345';
        job.New_E_Meter_Serial_Number__c='6345';
        job.New_Comms_Hub_Serial_Number__c='5345';
        update job;
        job.Found_IHD_Serial_Number__c='12345'; 
        job.Found_Comms_Hub_Serial_Number__c='12345';
        update job; 
        
    }
    /**
      Process_JobResults_Test7() :  Stock Record updation Scenario
    **/
    static testMethod void Process_JobResults_Test7(){
        
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=techlist[0].id;
        lstStocks.add(stock);
        }       
        insert lstStocks;
        integer i=0;
        for(EON_Stock__c stock : lstStocks){            
            stock.Serial_Number__c='Test'+i;                            
            if(i==6){
                i=0;
            }
            i++;
            lstStocksupdate.add(stock);
        }
        update lstStocksupdate;
        job.New_Gas_Regulator_Serial_Number__c='Test1';      
        job.New_G_Meter_Serial_Number__c='Test2';
        job.New_E_Meter_Serial_Number__c='Test3';
        job.Removed_Gas_Regulator_Serial_Number__c='Test4';
        job.New_Comms_Hub_Serial_Number__c='Test5';
        job.New_IHD_Serial_Number__c='Test6';
        update job;       
        
        
    }
    //CH01 Start    
    /**
      Process_JobResults_Test8() :  matching technician scenario
    **/
    static testMethod void Process_JobResults_Test8(){
        
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=job.Technician__c;
        lstStocks.add(stock);
        }       
        insert lstStocks;
        integer i=0;
        for(EON_Stock__c stock : lstStocks){            
            stock.Serial_Number__c='Test'+i;                            
            if(i==6){
                i=0;
            }
            i++;
            lstStocksupdate.add(stock);
        }
        update lstStocksupdate;
        job.New_Gas_Regulator_Serial_Number__c='Test1';      
        job.New_G_Meter_Serial_Number__c='Test2';
        job.New_E_Meter_Serial_Number__c='Test3';
        job.Removed_Gas_Regulator_Serial_Number__c='Test4';
        job.New_Comms_Hub_Serial_Number__c='Test5';
        job.New_IHD_Serial_Number__c='Test6';
        update job;             
        
    }    
    //CH01 End
    
    static testmethod void  Process_FaultyAsset_Test()
    {
        List<EON_Technician__c> lstTech = EON_CreateTestRecords.createEonTechnicianList();
        insert lstTech;
        
        EON_Stock__c eonstock= EON_CreateTestRecords.createEonStock();
        eonstock.Technician_Name__c=lstTech[0].id;
        insert eonstock;
        
        EON_Stock__c eonstock1= EON_CreateTestRecords.createEonStock();
        eonstock1.Technician_Name__c=lstTech[1].id;
        insert eonstock1;
        eonstock1.Serial_Number__c='4123';
        Update eonstock1;
        
        EON_Stock__c eonstock2= EON_CreateTestRecords.createEonStock();
        eonstock2.Technician_Name__c=lstTech[2].id;
        insert eonstock2;
        eonstock2.Serial_Number__c='4125';
        Update eonstock2;
        
        EON_Stock__c eonstock3= EON_CreateTestRecords.createEonStock();
        eonstock3.Technician_Name__c=lstTech[3].id;
        insert eonstock3;
        eonstock3.Serial_Number__c='4126';
        Update eonstock3;
        
        EON_Stock__c eonstock4= EON_CreateTestRecords.createEonStock();
        eonstock4.Technician_Name__c=lstTech[4].id;
        insert eonstock4;
        eonstock4.Serial_Number__c='';
        update eonstock4;
        
        EON_Appointment__c appointment= EON_CreateTestRecords.createEONAppointment();
        appointment.Technician__c=lstTech[0].id;
        insert appointment;
        
        Test.startTest();
        List<EON_Faulty_Asset__c> listfaultyasset = new List<EON_Faulty_Asset__c>();
        for(integer i=0;i<3;i++)
        {
            EON_Faulty_Asset__c eonfult = EON_CreateTestRecords.createEonFaultyAsset();
            eonfult.Job_Reference__c = appointment.id;
            listfaultyasset.add(eonfult);            
        }
        insert listfaultyasset;
        EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_Process_FaultyAsset(listfaultyasset,true);
        system.debug('@@@faulty@@@'+listfaultyasset);
        
     
    }
    static testmethod void  Process_FaultyAsset_Test3()
    {
        List<EON_Technician__c> lstTech = EON_CreateTestRecords.createEonTechnicianList();
        insert lstTech;
        
        EON_Stock__c eonstock= EON_CreateTestRecords.createEonStock();
        eonstock.Technician_Name__c=lstTech[1].id;
        eonstock.Serial_Number__c='1234';      
        insert eonstock;

        EON_Appointment__c appointment= EON_CreateTestRecords.createEONAppointment();
        appointment.Technician__c=lstTech[0].id;
        insert appointment;
        
        Test.startTest();
        List<EON_Faulty_Asset__c> listfaultyasset = new List<EON_Faulty_Asset__c>();
        for(integer i=0;i<3;i++)
        {
            EON_Faulty_Asset__c eonfult = EON_CreateTestRecords.createEonFaultyAsset();
            eonfult.Job_Reference__c = appointment.id;
            listfaultyasset.add(eonfult);            
        }
        insert listfaultyasset;
        EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_Process_FaultyAsset(listfaultyasset,true);
        system.debug('@@@faulty@@@'+listfaultyasset);
        
     
    }
    static testmethod void  Process_FaultyAsset_Test1()
    {
        List<EON_Technician__c> lstTech = EON_CreateTestRecords.createEonTechnicianList();
        insert lstTech;
        EON_Appointment__c appointment= EON_CreateTestRecords.createEONAppointment();
        appointment.Technician__c=lstTech[0].id;
        insert appointment;
        
        Test.startTest();
        List<EON_Faulty_Asset__c> listfaultyasset = new List<EON_Faulty_Asset__c>();   
        EON_Faulty_Asset__c eonfult = EON_CreateTestRecords.createEonFaultyAsset();
            eonfult.Job_Reference__c = appointment.id;
            eonfult.Serial_Number_1__c='Test1';
            eonfult.Serial_Number_2__c='Test2';
            eonfult.Serial_Number_3__c='Test3';
            eonfult.Serial_Number_4__c='Test4';
            listfaultyasset.add(eonfult);            
        insert listfaultyasset;
        EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_Process_FaultyAsset(listfaultyasset,true);     
    }
   
    
    static testmethod void  Process_FaultyAsset_Test2()
    {
         List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
         List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Technician__c> lstTech = EON_CreateTestRecords.createEonTechnicianList();
        insert lstTech;
        EON_Appointment__c appointment= EON_CreateTestRecords.createEONAppointment();
        appointment.Technician__c=lstTech[0].id;
        insert appointment;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=lstTech[0].id;
         stock.Serial_Number__c='1234';
        stock.status__c='On Van'; 
        lstStocks.add(stock);
        } 
        insert lstStocks;
        integer i=1;
        for(EON_Stock__c stock : lstStocks){            
            stock.Serial_Number__c='Test'+i;                            
            if(i==4){
                i=0;
            }
            i++;
            lstStocksupdate.add(stock);
        }
        update lstStocksupdate;
        Test.startTest();
        List<EON_Faulty_Asset__c> listfaultyasset = new List<EON_Faulty_Asset__c>();   
        EON_Faulty_Asset__c eonfult = EON_CreateTestRecords.createEonFaultyAsset();
            eonfult.Job_Reference__c = appointment.id;
            eonfult.Serial_Number_1__c='Test1';
            eonfult.Serial_Number_2__c='Test2';
            eonfult.Serial_Number_3__c='Test3';
            eonfult.Serial_Number_4__c='Test4';
            listfaultyasset.add(eonfult);            
        insert listfaultyasset;
        EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_Process_FaultyAsset(listfaultyasset,true);     
    }
   
   static testmethod void  Process_Exception_Test()
    {
    try{
        EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_Process_JobResults(null,true);               
        }
        catch(Exception e){
            System.debug('Error:--->'+e);
        }
    }
    
    static testMethod void EON_Job_Results_Trigger_After(){
         
        EON_Job_Results__c jobRes = EON_CreateTestRecords.createEon_Job_Results();
        jobRes.Job_Status__c = 'Aborted';
        insert jobRes;
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=techlist[0].id;
        lstStocks.add(stock);
        }       
        insert lstStocks;
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        lstStocksupdate.add(stock);
        }
        update lstStocksupdate;
          test.startTest();
        job.New_Gas_Regulator_Serial_Number__c='2345';      
        job.New_G_Meter_Serial_Number__c='2345';
        job.New_E_Meter_Serial_Number__c='2345';
        update job;
        test.stopTest();
        job.Removed_Gas_Regulator_Serial_Number__c='12345';
        update job;
        job.E_Meter_Removed__c='yes';
        update job;
        job.G_Meter_Removed__c='yes';       
        update job;
        job.G_Meter_Installed__c='yes';        
        update job;
        job.E_Meter_Installed__c= 'yes';         
        update job;
        job.Removed_G_Meter_Serial_Number__c='12345';
        update job;
        job.Removed_E_Meter_Serial_Number__c='12345';
        update job;                      
    }
    static testMethod void Process_JobResults_Test_vR(){
         
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=job.Technician__c;        
        lstStocks.add(stock);       
        }       
        insert lstStocks;
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        stock.status__c='Validation Required';
        lstStocksupdate.add(stock);
        }
        lstStocksupdate[0].Serial_Number__c='6345';
        lstStocksupdate[1].Serial_Number__c='4345';
        lstStocksupdate[2].Serial_Number__c='4345';
        lstStocksupdate[3].Serial_Number__c='4345';
        lstStocksupdate[4].Serial_Number__c='6345';
        update lstStocksupdate;
        job.New_G_Meter_Serial_Number__c='4345';
        job.New_E_Meter_Serial_Number__c='6345';
        update job;
    
    }
    static testMethod void Process_JobResults_Test_vR1(){
         
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=job.Technician__c;        
        lstStocks.add(stock);       
        }       
        insert lstStocks;    
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        stock.status__c='Validation Required';
        lstStocksupdate.add(stock);
        }
        lstStocksupdate[0].Serial_Number__c='6345';
        lstStocksupdate[1].Serial_Number__c='4345';
        lstStocksupdate[2].Serial_Number__c='4345';
        lstStocksupdate[3].Serial_Number__c='4345';
        lstStocksupdate[4].Serial_Number__c='6345';
        update lstStocksupdate;
        job.Removed_Gas_Regulator_Serial_Number__c='4345';
        job.New_IHD_Serial_Number__c='6345';
        update job;    
    }
    static testMethod void Process_JobResults_Test_vR2(){
         
        insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=job.Technician__c;        
        lstStocks.add(stock);       
        }       
        insert lstStocks;    
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        stock.status__c='Validation Required';
        lstStocksupdate.add(stock);
        }
        lstStocksupdate[0].Serial_Number__c='6345';
        lstStocksupdate[1].Serial_Number__c='4345';
        lstStocksupdate[2].Serial_Number__c='4345';
        lstStocksupdate[3].Serial_Number__c='4345';
        lstStocksupdate[4].Serial_Number__c='6345';
        update lstStocksupdate;
        job.New_Gas_Regulator_Serial_Number__c='4345';
        job.New_IHD_Serial_Number__c='6345';
        update job;    
        
    }
    //CH04.commented the below method
    //CH02.New.Start
    /**
        EON_Stock_Reconciliation_JobResults_Pass() - Covers code.
    **/  /*  
    static testMethod void EON_Stock_Reconciliation_JobResults_Pass(){
        EON_Job_Results__c jobRes = EON_CreateTestRecords.createEon_Job_Results();
        jobRes.Job_Status__c = 'Aborted';
        jobRes.E_Meter_Removed__c='yes';
        jobRes.G_Meter_Removed__c='yes';  
        jobRes.G_Meter_Installed__c='yes';
        jobRes.E_Meter_Installed__c= 'yes';
        jobRes.New_IHD_Serial_Number__c = '2345';
        insert jobRes;
        jobRes.New_IHD_Serial_Number__c = '2345';
        
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();

        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
            stock.Technician_Name__c=techlist[0].id;
            stock.Serial_Number__c='2345';
            lstStocks.add(stock);
        }       
        insert lstStocks;
        List<EON_Stock__c> lstStocks1= new List<EON_Stock__c>();
        lstStocks1=EON_CreateTestRecords.createEonStockList();
        EON_Stock__c stock1 = lstStocks1[0];
        stock1.Technician_Name__c=techlist[0].id;
        stock1.Serial_Number__c='1111';
        insert stock1;
        EON_Stock__c stock2 = lstStocks1[1];
        stock2.Technician_Name__c=techlist[1].id;
        stock2.Serial_Number__c='2222';
        stock2.status__c='On Van';
        insert stock2;
        EON_Stock__c stock3 = lstStocks1[2];
        stock3.Technician_Name__c=jobRes.Technician__c;
        stock3.Serial_Number__c='2222';
        stock3.status__c='On Van';
        insert stock3;
        
        jobRes.New_Gas_Regulator_Serial_Number__c='2222';
        jobRes.New_IHD_Serial_Number__c = '1111';
        update jobRes;
        
        stock3.Serial_Number__c='2222';
        stock3.status__c='On Van';
        update stock3;
        
        stock2.Serial_Number__c='2222';
        stock2.status__c='On Van';
        update stock2;
        
        jobRes.New_G_Meter_Serial_Number__c = '2222';
        update jobRes;     
        
        list<EON_Job_Results__c> job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        map<id,EON_Job_Results__c> mapRec = new Map<id,EON_Job_Results__c>();
        EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_JobResults(job, true, mapRec);
    }*/
    static testMethod void generateException_PASS(){
    EON_Ceva_Stock_Reconcil_Process_Test.genException=true;
    insert EON_CreateTestRecords.createEon_Job_Results();
        EON_Job_Results__c job= [select id, Found_IHD_Serial_Number__c,Found_Comms_Hub_Serial_Number__c,New_IHD_Serial_Number__c,New_Comms_Hub_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_G_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,Removed_Gas_Regulator_Serial_Number__c,E_Meter_Removed__c,G_Meter_Removed__c,G_Meter_Installed__c,E_Meter_Installed__c,Removed_G_Meter_Serial_Number__c,Removed_E_Meter_Serial_Number__c,Job_Status__c,Technician__c from EON_Job_Results__c limit 1];
        List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
        List<EON_Stock__c> lstStocksupdate= new List<EON_Stock__c>();
        for(EON_Stock__c stock :EON_CreateTestRecords.createEonStockList()){
        stock.Technician_Name__c=job.Technician__c;        
        lstStocks.add(stock);       
        }       
        insert lstStocks;    
        for(EON_Stock__c stock : lstStocks){
        stock.Serial_Number__c='2345';
        stock.status__c='Validation Required';
        lstStocksupdate.add(stock);
        }
        lstStocksupdate[0].Serial_Number__c='6345';
        lstStocksupdate[1].Serial_Number__c='4345';
        lstStocksupdate[2].Serial_Number__c='4345';
        lstStocksupdate[3].Serial_Number__c='4345';
        lstStocksupdate[4].Serial_Number__c='6345';
        update lstStocksupdate;
        job.New_Gas_Regulator_Serial_Number__c='4345';
        job.New_IHD_Serial_Number__c='6345';
        update job;
    
    }
    //CH02.New.End
    
    /*
        Praveen Added 
    */
    static testMethod void unitTEST1(){
    
        List<EON_Technician__c> techlist= EON_CreateTestRecords.createEonTechnicianList();
        insert techlist;
            
        List<EON_Stock__c> lstStocks1= new List<EON_Stock__c>();
        lstStocks1=EON_CreateTestRecords.createEonStockList();
        EON_Stock__c stock1 = lstStocks1[0];
        stock1.Technician_Name__c=techlist[0].id;
        insert stock1;
        lstStocks1.add(stock1);
        
        EON_Appointment__c appointment= EON_CreateTestRecords.createEONAppointment();
        appointment.Technician__c=techlist[0].id;
        insert appointment;
        
        EON_Faulty_Asset__c eonfult = EON_CreateTestRecords.createEonFaultyAsset();
        eonfult.Job_Reference__c = appointment.id; 
        insert eonfult; 
        
        List<EON_Stock__c> stocks = [select id, Technician_Name__c  
                                         from EON_Stock__c where id =: stock1.id];
        EON_Faulty_Asset__c fault = [select id, Job_Reference__r.Technician__c, Asset_Tag_2__c, Asset_Type_2__c,
                                    Asset_Tag_3__c, Asset_Type_3__c, Asset_Tag_4__c, Asset_Type_4__c,
                                    Job_Reference__r.Appointment_Date__c  
                            from EON_Faulty_Asset__c where id =: eonfult.id];
        
        EON_Ceva_Stock_Reconciliation_Process.ProcessEON_StockForFaultyAsset_SR2(stocks , fault); 
        
        EON_Ceva_Stock_Reconciliation_Process.ProcessEON_StockForFaultyAsset_SR3(stocks , fault); 
        
        EON_Ceva_Stock_Reconciliation_Process.ProcessEON_StockForFaultyAsset_SR4(stocks , fault); 
        
         
        
    }
}