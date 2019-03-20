/** 
Description: This trigger is for updating EON Stock records related to EON Stock based on conditions 

Helper Class  : EON_Stock_Trigger_Helper
Test Class    : EON_Job_Results_Trigger_Test
**/
/* 
Created By    : Guna P
Created On    : 20/03/2018
Service Req   : SR_OptiMUS_EON_185
CHANGE HISTORY: 
 CH01 # SR_OptiMUS_EON_236 #16/04/2018 # Rangnath Agrahari # added functionality for adding the S2 exception emails  
 CH02 # SR_OptiMUS_EON_284 #18/10/2018 # Guna P #Added Stock functionality for 'New Comms Hub Serial Number'.
 CH03 # SR_OptiMUS_EON_293 #05/12/2018 # Shruti Moghe # updated condition from >=10 to >10


CHANGE HISTORY: 
**/

public with sharing class EON_Stock_Trigger_Helper {

    /**
        UpdateStockForSerialNo(list<EON_Stock__c> triggerNew) -
            This method is to triggering the Job Reconciliation Process
    **/
    public static void UpdateStockForSerialNo(list<EON_Stock__c> triggerNew){
        Map<String,List<EON_Stock__c>> mapStocks= new Map<String,List<EON_Stock__c>>();
        Map<String,List<EON_Stock__c>> mapStocksInstalled= new Map<String,List<EON_Stock__c>>();
        SET<string> serialnumbers = new SET<string>();
        for(EON_Stock__c stock :triggerNew){
            serialnumbers.add(stock.Serial_Number__c);
        }
        List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>();
       List<EON_Stock__c> lstStock1 = new List<EON_Stock__c>();
       lstStock1 =[SELECT Asset_Type__c,CreatedById,CreatedDate,Date_Faulty__c,Date_of_Dispatch__c,Date_of_Installation__c,Date_Returned_Received__c,
                   EON_Job_Results__c,Faulty_Asset_Unique_ID__c,Id,IsDeleted,Job_Reference__c,KID__c,Manufacture__c,Model__c,Name,Order_Reference__c,
                   Product_Code__c,Serial_Number__c,Status__c,SystemModstamp,Technician_Name__c,Technician_Mismatch__c FROM EON_Stock__c where id IN:triggerNew];
        for(EON_Stock__c objStock:lstStock1){
            if(!mapStocks.containsKey(objStock.Serial_Number__c))
                mapStocks.put(objStock.Serial_Number__c, new List<EON_Stock__c>());
            mapStocks.get(objStock.Serial_Number__c).add(objStock);
        }
        Map<string, list<EON_Job_Results__c>> jobresultmap= new Map<string, list<EON_Job_Results__c>>();//CH02
        //List<EON_Job_Results__c> jobresultlist= new list<EON_Job_Results__c>([select id, New_E_Meter_Serial_Number__c,New_G_Meter_Serial_Number__c,Installed_Cradle_Serial_Number__c,Installed_Hot_Shoe_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_IHD_Serial_Number__c,Technician__c,EON_Stock_Status__c,Time_On_Site__c from EON_Job_Results__c where EON_Stock_Status__c=:'Email Sent' and createddate>=LAST_N_Days:14 and (New_E_Meter_Serial_Number__c in: serialnumbers OR New_G_Meter_Serial_Number__c in: serialnumbers OR Installed_Cradle_Serial_Number__c in: serialnumbers OR Installed_Hot_Shoe_Serial_Number__c in: serialnumbers oR New_Gas_Regulator_Serial_Number__c in: serialnumbers OR New_IHD_Serial_Number__c in: serialnumbers)]);//Ch01
       List<EON_Job_Results__c> jobresultlist= new list<EON_Job_Results__c>([select id, New_E_Meter_Serial_Number__c,New_G_Meter_Serial_Number__c,Installed_Cradle_Serial_Number__c,Installed_Hot_Shoe_Serial_Number__c,New_Gas_Regulator_Serial_Number__c,New_IHD_Serial_Number__c,Technician__c,EON_Stock_Status__c,Time_On_Site__c,New_Comms_Hub_Serial_Number__c from EON_Job_Results__c where EON_Stock_Status__c=:'Reviewed' and createddate>=LAST_N_Days:13 and (New_E_Meter_Serial_Number__c in: serialnumbers OR New_G_Meter_Serial_Number__c in: serialnumbers OR Installed_Cradle_Serial_Number__c in: serialnumbers OR Installed_Hot_Shoe_Serial_Number__c in: serialnumbers oR New_Gas_Regulator_Serial_Number__c in: serialnumbers OR New_Comms_Hub_Serial_Number__c in: serialnumbers OR New_IHD_Serial_Number__c in: serialnumbers)]);

        List<EON_Stock__c> lstStockInstalled = new List<EON_Stock__c>();
        lstStockInstalled=[SELECT Asset_Type__c,CreatedDate,Date_Faulty__c,Date_of_Dispatch__c,Date_of_Installation__c,Date_Returned_Received__c,
                   EON_Job_Results__c,Faulty_Asset_Unique_ID__c,Id,Job_Reference__c,KID__c,Manufacture__c,Model__c,Name,Order_Reference__c,
                   Product_Code__c,Serial_Number__c,Status__c,Technician_Name__c,Technician_Mismatch__c FROM EON_Stock__c where EON_Job_Results__c IN:jobresultlist];
        for(EON_Stock__c objStock:lstStockInstalled){
            if(!mapStocksInstalled.containsKey(objStock.Serial_Number__c))
                    mapStocksInstalled.put(objStock.Serial_Number__c, new List<EON_Stock__c>());
                    mapStocksInstalled.get(objStock.Serial_Number__c).add(objStock);
                     
        }
        List<EON_Job_Results__c> jobresulterror= new List<EON_Job_Results__c>();
        MAP<String,EON_Stock__c> MapStockToUpdate = new MAP<String,EON_Stock__c>();
        SET<String> Serialnumberset = new SET<String>();
        Map<String,EON_Job_Results__c > duplicateJobresults = new Map<String, EON_Job_Results__c>();
        //CH02.Start
         for(EON_Job_Results__c objJobResult : jobresultlist){
             if(!String.isblank(objJobResult.New_E_Meter_Serial_Number__c)){
                 if(!jobresultmap.containsKey(objJobResult.New_E_Meter_Serial_Number__c))
                    jobresultmap.put(objJobResult.New_E_Meter_Serial_Number__c, new List<EON_Job_Results__c>());
                    jobresultmap.get(objJobResult.New_E_Meter_Serial_Number__c).add(objJobResult);
              }
             
             if(!String.isblank(objJobResult.New_Comms_Hub_Serial_Number__c)){
                 if(!jobresultmap.containsKey(objJobResult.New_Comms_Hub_Serial_Number__c))
                    jobresultmap.put(objJobResult.New_Comms_Hub_Serial_Number__c, new List<EON_Job_Results__c>());
                    jobresultmap.get(objJobResult.New_Comms_Hub_Serial_Number__c).add(objJobResult);
              }
           
             if(!String.isblank(objJobResult.New_Gas_Regulator_Serial_Number__c)){
                 if(!jobresultmap.containsKey(objJobResult.New_Gas_Regulator_Serial_Number__c))
                    jobresultmap.put(objJobResult.New_Gas_Regulator_Serial_Number__c, new List<EON_Job_Results__c>());
                    jobresultmap.get(objJobResult.New_Gas_Regulator_Serial_Number__c).add(objJobResult);
              }
              
             if(!String.isblank(objJobResult.New_G_Meter_Serial_Number__c)){
                 if(!jobresultmap.containsKey(objJobResult.New_G_Meter_Serial_Number__c))
                    jobresultmap.put(objJobResult.New_G_Meter_Serial_Number__c, new List<EON_Job_Results__c>());
                    jobresultmap.get(objJobResult.New_G_Meter_Serial_Number__c).add(objJobResult);
              }
           
             if(!String.isblank(objJobResult.Installed_Cradle_Serial_Number__c)){
                 if(!jobresultmap.containsKey(objJobResult.Installed_Cradle_Serial_Number__c))
                    jobresultmap.put(objJobResult.Installed_Cradle_Serial_Number__c, new List<EON_Job_Results__c>());
                    jobresultmap.get(objJobResult.Installed_Cradle_Serial_Number__c).add(objJobResult);
              }
              
             if(!String.isblank(objJobResult.Installed_Hot_Shoe_Serial_Number__c)){
                 if(!jobresultmap.containsKey(objJobResult.Installed_Hot_Shoe_Serial_Number__c))
                    jobresultmap.put(objJobResult.Installed_Hot_Shoe_Serial_Number__c, new List<EON_Job_Results__c>());
                    jobresultmap.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c).add(objJobResult);
              }
              
             if(!String.isblank(objJobResult.New_IHD_Serial_Number__c)){
                 if(!jobresultmap.containsKey(objJobResult.New_IHD_Serial_Number__c))
                    jobresultmap.put(objJobResult.New_IHD_Serial_Number__c, new List<EON_Job_Results__c>());
                    jobresultmap.get(objJobResult.New_IHD_Serial_Number__c).add(objJobResult);
              }
           }
          //CH02.End
            
        for(EON_Job_Results__c objJobResult : jobresultlist){
            boolean flagstatus=false;
            boolean ValidatedByRoutine=false;//CH02
             if(!String.isblank(objJobResult.New_E_Meter_Serial_Number__c)){
                    if(mapStocksInstalled.get(objJobResult.New_E_Meter_Serial_Number__c)==null){
                        if(mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c)!=null){
                            if(mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c).size()==1){
                                if(!Serialnumberset.contains(objJobResult.New_E_Meter_Serial_Number__c)){
                                    EON_Stock__c stock = mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c)[0];
                                    stock.Date_of_Installation__c=Date.valueof(objJobResult.Time_On_Site__c);
                                    if(mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c)[0].Technician_Name__c!=objJobResult.Technician__c) 
                                    stock.Technician_Mismatch__c=true;
                                    stock.Technician_Name__c=objJobResult.Technician__c;
                                    stock.EON_Job_Results__c=objJobResult.id;
                                    stock.Status__c='Installed';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);      
                                    Serialnumberset.add(objJobResult.New_E_Meter_Serial_Number__c);
                                    if(!duplicateJobresults.containskey(objJobResult.New_E_Meter_Serial_Number__c)) duplicateJobresults.put(objJobResult.New_E_Meter_Serial_Number__c,objJobResult);
                                
                                }
                                else
                                {   
                                    List<EON_Job_Results__c> listjobs= new List<EON_Job_Results__c>();
                                    listjobs.add(objJobResult);
                                    listjobs.add(duplicateJobresults.get(objJobResult.New_E_Meter_Serial_Number__c));
                                    emaillist.add(ProcessEmails_DuplicateJobs(mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c),listjobs));
                                    EON_Stock__c stock = MapStockToUpdate.get(objJobResult.New_E_Meter_Serial_Number__c);
                                    stock.Date_of_Installation__c=null;                                    
                                    stock.Technician_Mismatch__c=false;
                                    stock.EON_Job_Results__c=null;
                                    stock.Status__c='Validation Required';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);
                                }
                            }
                            else{
                             emaillist.add(EON_Ceva_Stock_Reconciliation_Process.ProcessEmails_JobResults(mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c),objJobResult,objJobResult.New_E_Meter_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                             flagstatus=true;
                             }
                        }
                        else{
                            flagstatus=true;
                            }
                    }   
             }
             //CH02.Start
             
             if(!String.isblank(objJobResult.New_Comms_Hub_Serial_Number__c)&& objJobResult.New_Comms_Hub_Serial_Number__c.length()>10){ //CH03 updated condition from>=10 to >10
                    if(mapStocksInstalled.get(objJobResult.New_Comms_Hub_Serial_Number__c)==null){
                        if(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c)!=null){
                            if(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c).size()==1){
                                if(!Serialnumberset.contains(objJobResult.New_Comms_Hub_Serial_Number__c)){
                                    EON_Stock__c stock = mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c)[0];
                                    stock.Date_of_Installation__c=Date.valueof(objJobResult.Time_On_Site__c);
                                    if(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c)[0].Technician_Name__c!=objJobResult.Technician__c) 
                                    stock.Technician_Mismatch__c=true;
                                    stock.Technician_Name__c=objJobResult.Technician__c;
                                    stock.EON_Job_Results__c=objJobResult.id;
                                    stock.Status__c='Installed';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);      
                                    Serialnumberset.add(objJobResult.New_Comms_Hub_Serial_Number__c);
                                    if(!duplicateJobresults.containskey(objJobResult.New_Comms_Hub_Serial_Number__c)) duplicateJobresults.put(objJobResult.New_Comms_Hub_Serial_Number__c,objJobResult);
                                }
                                else
                                {   
                                    List<EON_Job_Results__c> listjobs= new List<EON_Job_Results__c>();
                                    listjobs.add(objJobResult);
                                    listjobs.add(duplicateJobresults.get(objJobResult.New_Comms_Hub_Serial_Number__c));
                                    emaillist.add(ProcessEmails_DuplicateJobs(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c),listjobs));
                                    EON_Stock__c stock = MapStockToUpdate.get(objJobResult.New_Comms_Hub_Serial_Number__c);
                                    stock.Date_of_Installation__c=null;                                    
                                    stock.Technician_Mismatch__c=false;
                                    stock.EON_Job_Results__c=null;
                                    stock.Status__c='Validation Required';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);
                                    
                                }
                            }
                            else{
                             emaillist.add(EON_Ceva_Stock_Reconciliation_Process.ProcessEmails_JobResults(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c),objJobResult,objJobResult.New_Comms_Hub_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                             flagstatus=true;
                             }
                        }
                        else{
                            flagstatus=true;
                            }
                    }   
             }
             
             //CH02.End
             
             if(!String.isblank(objJobResult.New_G_Meter_Serial_Number__c)){
                    if(mapStocksInstalled.get(objJobResult.New_G_Meter_Serial_Number__c)==null){
                        if(mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c)!=null){
                            if(mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c).size()==1){
                                if(!Serialnumberset.contains(objJobResult.New_G_Meter_Serial_Number__c)){                           
                                EON_Stock__c stock = mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c)[0];
                                stock.Date_of_Installation__c=Date.valueof(objJobResult.Time_On_Site__c);
                                if(mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c)[0].Technician_Name__c!=objJobResult.Technician__c) 
                                stock.Technician_Mismatch__c=true;
                                stock.Technician_Name__c=objJobResult.Technician__c;
                                stock.EON_Job_Results__c=objJobResult.id;
                                stock.Status__c='Installed';
                                MapStockToUpdate.put(stock.serial_number__c,stock);      
                                Serialnumberset.add(objJobResult.New_G_Meter_Serial_Number__c);
                                if(!duplicateJobresults.containskey(objJobResult.New_G_Meter_Serial_Number__c)) duplicateJobresults.put(objJobResult.New_G_Meter_Serial_Number__c,objJobResult);
                                }
                                else
                                {   
                                    List<EON_Job_Results__c> listjobs= new List<EON_Job_Results__c>();
                                    listjobs.add(objJobResult);
                                    listjobs.add(duplicateJobresults.get(objJobResult.New_G_Meter_Serial_Number__c));
                                    emaillist.add(ProcessEmails_DuplicateJobs(mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c),listjobs));
                                    EON_Stock__c stock = MapStockToUpdate.get(objJobResult.New_G_Meter_Serial_Number__c);
                                    stock.Date_of_Installation__c=null;                                    
                                    stock.Technician_Mismatch__c=false;
                                    stock.EON_Job_Results__c=null;
                                    stock.Status__c='Validation Required';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);
                                }
                                
                            }
                            else{
                             emaillist.add(EON_Ceva_Stock_Reconciliation_Process.ProcessEmails_JobResults(mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c),objJobResult,objJobResult.New_G_Meter_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                             flagstatus=true;
                             }
                        }
                        else{
                            flagstatus=true;
                            }
                    }   
             }
             if(!String.isblank(objJobResult.Installed_Cradle_Serial_Number__c)){
                    if(mapStocksInstalled.get(objJobResult.Installed_Cradle_Serial_Number__c)==null){
                        if(mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c)!=null){
                            if(mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c).size()==1){
                                if(!Serialnumberset.contains(objJobResult.Installed_Cradle_Serial_Number__c)){      
                                    EON_Stock__c stock = mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c)[0];
                                    stock.Date_of_Installation__c=Date.valueof(objJobResult.Time_On_Site__c);
                                    if(mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c)[0].Technician_Name__c!=objJobResult.Technician__c) 
                                    stock.Technician_Mismatch__c=true;
                                    stock.Technician_Name__c=objJobResult.Technician__c;
                                    stock.EON_Job_Results__c=objJobResult.id;
                                    stock.Status__c='Installed';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);      
                                    Serialnumberset.add(objJobResult.Installed_Cradle_Serial_Number__c);
                                    if(!duplicateJobresults.containskey(objJobResult.Installed_Cradle_Serial_Number__c)) duplicateJobresults.put(objJobResult.Installed_Cradle_Serial_Number__c,objJobResult);
                                }
                                else
                                {   
                                    List<EON_Job_Results__c> listjobs= new List<EON_Job_Results__c>();
                                    listjobs.add(objJobResult);
                                    listjobs.add(duplicateJobresults.get(objJobResult.Installed_Cradle_Serial_Number__c));
                                    emaillist.add(ProcessEmails_DuplicateJobs(mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c),listjobs));
                                    EON_Stock__c stock = MapStockToUpdate.get(objJobResult.Installed_Cradle_Serial_Number__c);
                                    stock.Date_of_Installation__c=null;                                    
                                    stock.Technician_Mismatch__c=false;
                                    stock.EON_Job_Results__c=null;
                                    stock.Status__c='Validation Required';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);
                                }                               
                            }
                            else{
                             emaillist.add(EON_Ceva_Stock_Reconciliation_Process.ProcessEmails_JobResults(mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c),objJobResult,objJobResult.Installed_Cradle_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                             flagstatus=true;
                             }
                        }
                        else{
                            flagstatus=true;
                            }
                    }   
             }
             if(!String.isblank(objJobResult.Installed_Hot_Shoe_Serial_Number__c)){
                    if(mapStocksInstalled.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c)==null){
                        if(mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c)!=null){
                            if(mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c).size()==1){
                                if(!Serialnumberset.contains(objJobResult.Installed_Hot_Shoe_Serial_Number__c)){                
                                EON_Stock__c stock = mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c)[0];
                                stock.Date_of_Installation__c=Date.valueof(objJobResult.Time_On_Site__c);
                                if(mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c)[0].Technician_Name__c!=objJobResult.Technician__c) 
                                stock.Technician_Mismatch__c=true;
                                stock.Technician_Name__c=objJobResult.Technician__c;
                                stock.EON_Job_Results__c=objJobResult.id;
                                stock.Status__c='Installed';
                                MapStockToUpdate.put(stock.serial_number__c,stock);      
                                Serialnumberset.add(objJobResult.Installed_Hot_Shoe_Serial_Number__c);
                                if(!duplicateJobresults.containskey(objJobResult.Installed_Hot_Shoe_Serial_Number__c)) duplicateJobresults.put(objJobResult.Installed_Hot_Shoe_Serial_Number__c,objJobResult);
                                }
                                else
                                {   
                                    List<EON_Job_Results__c> listjobs= new List<EON_Job_Results__c>();
                                    listjobs.add(objJobResult);
                                    listjobs.add(duplicateJobresults.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c));
                                    emaillist.add(ProcessEmails_DuplicateJobs(mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c),listjobs));
                                    EON_Stock__c stock = MapStockToUpdate.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c);
                                    stock.Date_of_Installation__c=null;                                    
                                    stock.Technician_Mismatch__c=false;
                                    stock.EON_Job_Results__c=null;
                                    stock.Status__c='Validation Required';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);
                                }                               
                            
                            }
                            else{
                             emaillist.add(EON_Ceva_Stock_Reconciliation_Process.ProcessEmails_JobResults(mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c),objJobResult,objJobResult.Installed_Hot_Shoe_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                             flagstatus=true;
                             }
                        }
                        else{
                            flagstatus=true;
                            }
                    }   
             }
             if(!String.isblank(objJobResult.New_Gas_Regulator_Serial_Number__c)){
                    if(mapStocksInstalled.get(objJobResult.New_Gas_Regulator_Serial_Number__c)==null){
                        if(mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c)!=null){
                            if(mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c).size()==1){
                                if(!Serialnumberset.contains(objJobResult.Installed_Hot_Shoe_Serial_Number__c)){  
                                    EON_Stock__c stock = mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c)[0];
                                    stock.Date_of_Installation__c=Date.valueof(objJobResult.Time_On_Site__c);
                                    if(mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c)[0].Technician_Name__c!=objJobResult.Technician__c) 
                                    stock.Technician_Mismatch__c=true;
                                    stock.Technician_Name__c=objJobResult.Technician__c;
                                    stock.EON_Job_Results__c=objJobResult.id;
                                    stock.Status__c='Installed';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);      
                                    Serialnumberset.add(objJobResult.New_Gas_Regulator_Serial_Number__c);
                                    if(!duplicateJobresults.containskey(objJobResult.New_Gas_Regulator_Serial_Number__c)) duplicateJobresults.put(objJobResult.New_Gas_Regulator_Serial_Number__c,objJobResult);
                                }
                                else
                                {   
                                    List<EON_Job_Results__c> listjobs= new List<EON_Job_Results__c>();
                                    listjobs.add(objJobResult);
                                    listjobs.add(duplicateJobresults.get(objJobResult.New_Gas_Regulator_Serial_Number__c));
                                    emaillist.add(ProcessEmails_DuplicateJobs(mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c),listjobs));
                                    EON_Stock__c stock = MapStockToUpdate.get(objJobResult.New_Gas_Regulator_Serial_Number__c);
                                    stock.Date_of_Installation__c=null;                                    
                                    stock.Technician_Mismatch__c=false;
                                    stock.EON_Job_Results__c=null;
                                    stock.Status__c='Validation Required';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);
                                }                                   
                            
                            }
                            else{
                             emaillist.add(EON_Ceva_Stock_Reconciliation_Process.ProcessEmails_JobResults(mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c),objJobResult,objJobResult.New_Gas_Regulator_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                             flagstatus=true;
                             }
                        }
                        else{
                            flagstatus=true;
                            }
                    }   
             }
             if(!String.isblank(objJobResult.New_IHD_Serial_Number__c)){
                    if(mapStocksInstalled.get(objJobResult.New_IHD_Serial_Number__c)==null){
                        if(mapStocks.get(objJobResult.New_IHD_Serial_Number__c)!=null){
                            if(mapStocks.get(objJobResult.New_IHD_Serial_Number__c).size()==1){
                                if(!Serialnumberset.contains(objJobResult.Installed_Hot_Shoe_Serial_Number__c)){
                                    EON_Stock__c stock = mapStocks.get(objJobResult.New_IHD_Serial_Number__c)[0];
                                    stock.Date_of_Installation__c=Date.valueof(objJobResult.Time_On_Site__c);
                                    if(mapStocks.get(objJobResult.New_IHD_Serial_Number__c)[0].Technician_Name__c!=objJobResult.Technician__c) 
                                    stock.Technician_Mismatch__c=true;
                                    stock.Technician_Name__c=objJobResult.Technician__c;
                                    stock.EON_Job_Results__c=objJobResult.id;
                                    stock.Status__c='Installed';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);      
                                    Serialnumberset.add(objJobResult.New_IHD_Serial_Number__c);                             
                                    if(!duplicateJobresults.containskey(objJobResult.New_IHD_Serial_Number__c)) duplicateJobresults.put(objJobResult.New_IHD_Serial_Number__c,objJobResult);
                                }
                                else
                                {   
                                    List<EON_Job_Results__c> listjobs= new List<EON_Job_Results__c>();
                                    listjobs.add(objJobResult);
                                    listjobs.add(duplicateJobresults.get(objJobResult.New_IHD_Serial_Number__c));
                                    emaillist.add(ProcessEmails_DuplicateJobs(mapStocks.get(objJobResult.New_IHD_Serial_Number__c),listjobs));
                                    EON_Stock__c stock = MapStockToUpdate.get(objJobResult.New_IHD_Serial_Number__c);
                                    stock.Date_of_Installation__c=null;                                    
                                    stock.Technician_Mismatch__c=false;
                                    stock.EON_Job_Results__c=null;
                                    stock.Status__c='Validation Required';
                                    MapStockToUpdate.put(stock.serial_number__c,stock);
                                }           
                            }
                            else{
                             emaillist.add(EON_Ceva_Stock_Reconciliation_Process.ProcessEmails_JobResults(mapStocks.get(objJobResult.New_IHD_Serial_Number__c),objJobResult,objJobResult.New_IHD_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                             flagstatus=true;
                             }
                        }
                        else{
                            flagstatus=true;
                            }
                    }   
             }
            //CH02.Start
               if(!String.isblank(objJobResult.New_E_Meter_Serial_Number__c))
                 if(jobresultmap.get(objJobResult.New_E_Meter_Serial_Number__c).size()>1)
                 ValidatedByRoutine=true;
                 
               if(!String.isblank(objJobResult.New_Comms_Hub_Serial_Number__c))
                 if(jobresultmap.get(objJobResult.New_Comms_Hub_Serial_Number__c).size()>1)
                 ValidatedByRoutine=true;
                 
                 if(!String.isblank(objJobResult.New_Gas_Regulator_Serial_Number__c))
                 if(jobresultmap.get(objJobResult.New_Gas_Regulator_Serial_Number__c).size()>1)
                 ValidatedByRoutine=true;
                 
                 if(!String.isblank(objJobResult.New_G_Meter_Serial_Number__c))
                 if(jobresultmap.get(objJobResult.New_G_Meter_Serial_Number__c).size()>1)
                 ValidatedByRoutine=true;
                 
                 if(!String.isblank(objJobResult.Installed_Cradle_Serial_Number__c))
                 if(jobresultmap.get(objJobResult.Installed_Cradle_Serial_Number__c).size()>1)
                 ValidatedByRoutine=true;
                 
                 if(!String.isblank(objJobResult.Installed_Hot_Shoe_Serial_Number__c))
                 if(jobresultmap.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c).size()>1)
                 ValidatedByRoutine=true;
                 
                 if(!String.isblank(objJobResult.New_IHD_Serial_Number__c))
                 if(jobresultmap.get(objJobResult.New_IHD_Serial_Number__c).size()>1)
                 ValidatedByRoutine=true;
            
            if(flagstatus==false &&ValidatedByRoutine==false){
              objJobResult.EON_Stock_Status__c='Validated By Routine';
              jobresulterror.add(objJobResult);
             }
             //CH02.End
        }
        
        if(MapStockToUpdate!=null && MapStockToUpdate.size()>0)  Update MapStockToUpdate.values();
        if(jobresulterror!=null && jobresulterror.size()>0)  Update jobresulterror;
         if(emaillist !=null && emaillist.size()>0) Messaging.sendEmail(emaillist); 
     }   
      public static Messaging.SingleEmailMessage ProcessEmails_DuplicateJobs(List<EON_Stock__c> stock,List<EON_Job_Results__c> jobresultlist){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo=System.Label.EON_Stock_Reconciliation_email.split(';');
        email.setToAddresses(sendTo);
        email.setSubject('EON Job Result(s) Require Manual Validation (Serial Number recorded twice or more in Job Results)');
          String emailbody='';
        String recordURL = EON_Utility.getInstanceURL() +'/'+stock[0].Id; 
         emailbody='Dear recipient, <br/><br/>Serial Number '+stock[0].serial_number__C+' has more than one entry in EON Job Results. <br/><br/> Below are all the relevant record links in OptiMUS;';
        emailbody=emailbody+'<br/><br/> <a href='+recordURL+'>'+recordURL+'</a><br/><br/><a href='+EON_Utility.getInstanceURL()+'/'+jobresultlist[0].Id+'>'+EON_Utility.getInstanceURL()+'/'+jobresultlist[0].Id+'</a><br/><br/><a href='+EON_Utility.getInstanceURL()+'/'+jobresultlist[1].Id+'>'+EON_Utility.getInstanceURL()+'/'+jobresultlist[1].Id+'</a><br/><br/>Please double check that the serial number entered in EON Job Result is correct by matching against the photos uploaded and update the relevant field as necessary in EON Job Result.<br/><br/>Kind regards<br/> The Stock Reconciliation Team';
        email.setHtmlBody(emailbody);
        return email;          
    }

}