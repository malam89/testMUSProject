/**
    Description : This class is used for EON Job Results object trigger helper.
    Test Class : EON_Job_Results_Trigger_Stock_Test
**/

/*
    Created By : Praveen G
    Created Date : 10/01/2017
    Service Request : SR_EON_AL_035
    Change History
    CH01 # SR_EON_AL_041 # 30/03/2017 #Praveen G # Added new logic for creating stock records.
    CH02 # SR_EON_AL_042 # 13/06/2017 #Praveen G # Amended a condition for creating stock records.
    CH03 # SR_OptiMUS_EON_171 #04/12/2017 # Praveen G # Removed the stock record to create of type 'Regulator'.
    CH04 # SR_OptiMUS_EON_222 #16/02/2018 # Mehboob Alam # Removed the functionality which causes an EON Stock record to be created 
                                            if Original E Meter refitted = Yes and Original G Meter refitted = Yes. 
    CH05 # SR_OptiMUS_EON_185 #14/03/2018 # Guna Sekhar P # Updated Field 'Date Removed' to 'Date Off Circuit',
           Creaing Stock records with 'Faulty' status and 'Off-Circuit' status as per the SR requirement.
	CH06 # SR_OptiMUS_EON_273 # 12/09/2018 # Junaid Khan # Added new fields as per the SR requirement.
*/
public with sharing class EON_Job_Results_Trigger_Helper_Stock{
    
    /**
        CreateStockRecords(List<Eon_Job_Results__c> TriggerNew, Map<id, Eon_Job_Results__c> TriggerOldMap) - 
                This method is used to created EON Stock records based on the criteria.
    **/    
    public static void CreateStockRecords(List<Eon_Job_Results__c> TriggerNew, Map<id, 
                                            Eon_Job_Results__c> TriggerOldMap){
        
        try{
        List<EON_Stock__c> lstInsertStock = new List<EON_Stock__c>();
        for(Eon_Job_Results__c jobResult : TriggerNew){
            Eon_Job_Results__c oldJobResult;
            if(TriggerOldMap != null)
                oldJobResult = TriggerOldMap.get(jobResult.id);
            //CH05.oldstart
            /*
            //for E Meter Removed? //CH02 - Changed the below condition.
            if(  (jobResult.Original_E_Meter_refitted__c == null || //CH01
                 jobResult.Original_E_Meter_refitted__c.equalsIgnorecase('No')) && //CH01      
                ((oldJobResult != null && jobResult.E_Meter_Removed__c != null && 
                 jobResult.E_Meter_Removed__c != oldJobResult.E_Meter_Removed__c &&  
                 jobResult.E_Meter_Removed__c.equalsIgnorecase('Yes')) // for update
                ||
                (oldJobResult == null && //for insert
                    jobResult.E_Meter_Removed__c != null && jobResult.E_Meter_Removed__c.equalsIgnorecase('Yes')))
                ){
                 */
            //CH05.oldend
            //CH05.NewStart
            if(jobResult.E_Meter_Removed__c!=null && jobResult.E_Meter_Removed__c.equalsIgnorecase('Yes') && 
               jobResult.Original_E_Meter_refitted__c!='Yes' && jobResult.E_Meter_Serial_Number__c!=null &&
               (oldJobResult == null || jobResult.E_Meter_Serial_Number__c!=oldJobResult.E_Meter_Serial_Number__c) && 
               jobResult.Removed_E_Meter_Reason__c!='Faulty/ Damaged'){
            //CH05.NewEnd 
                EON_Stock__c newStock = new EON_Stock__c();
                newStock.Serial_Number__c      = jobResult.E_Meter_Serial_Number__c;
                newStock.Manufacture__c        = (jobResult.E_Meter_Manufacturer__c != null && 
                                                    jobResult.E_Meter_Manufacturer__c.length() > 23) ? 
                                                 jobResult.E_Meter_Manufacturer__c.substring(0 , 23) :jobResult.E_Meter_Manufacturer__c ;
                newStock.Model__c              = jobResult.E_Meter_Version__c;  
                newStock.MUS_Asset_Tag__c      = (jobResult.Removed_E_Meter_Asset_Tag__c != null && 
                                                     jobResult.Removed_E_Meter_Asset_Tag__c.length() > 13)?
                                                 jobResult.Removed_E_Meter_Asset_Tag__c.subString(0, 13) : 
                                                     jobResult.Removed_E_Meter_Asset_Tag__c;
                //newStock.Date_Off_Circuit__c   = jobResult.h_Appointment_Date__c;//CH05.old
                newStock.Date_Off_Circuit__c   =Date.valueOf(jobResult.Time_On_Site__c);//CH05.New
                newStock.Technician_Name__c    = jobResult.Technician__c;
                newStock.EON_Job_Results__c    = jobResult.id;
                newStock.Status__c             = 'Off-Circuit';    
                newStock.Removed_Asset_Type__c = (jobResult.E_Meter_Type__c != null && 
                                                    jobResult.E_Meter_Type__c.length() > 24) ? 
                                                   jobResult.E_Meter_Type__c.subString(0, 24) : 
                                                   jobResult.E_Meter_Type__c;
                   
                lstInsertStock.add(newStock);
            }    
            //for G Meter Removed?
            //CH05.Old.start
            /*
            if(    //CH02 Changed the below condition.
                 (jobResult.Original_G_Meter_refitted__c == null || //CH01
                 jobResult.Original_G_Meter_refitted__c.equalsIgnorecase('No')) && //CH01   
                          
                ((oldJobResult != null && jobResult.G_Meter_Removed__c != null && 
                 jobResult.G_Meter_Removed__c != oldJobResult.G_Meter_Removed__c &&  
                 jobResult.G_Meter_Removed__c.equalsIgnorecase('Yes')) // for update
                ||
                (oldJobResult == null && //for insert
                    jobResult.G_Meter_Removed__c != null && jobResult.G_Meter_Removed__c.equalsIgnorecase('Yes')))
                ){ 
                 */
            //CH05.Old.end
            //CH05.NewStart
            if(jobResult.G_Meter_Removed__c!=null && jobResult.G_Meter_Removed__c.equalsIgnorecase('Yes') && 
               jobResult.Original_G_Meter_refitted__c!='Yes' && jobResult.G_Meter_Serial_Number__c!=null &&
               (oldJobResult == null || jobResult.G_Meter_Serial_Number__c!=oldJobResult.G_Meter_Serial_Number__c) && 
               jobResult.Removed_G_Meter_Reason__c!='Faulty/ Damaged'){
            //CH05.NewEnd
                EON_Stock__c newStockGMeterRemove = new EON_Stock__c(); 
                newStockGMeterRemove.Serial_Number__c      = jobResult.G_Meter_Serial_Number__c;
                newStockGMeterRemove.Manufacture__c        = (jobResult.G_Meter_Manufacturer__c != null && 
                                                                jobResult.G_Meter_Manufacturer__c.length() > 24) ? 
                                                             jobResult.G_Meter_Manufacturer__c.substring(0 , 23) : 
                                                             jobResult.G_Meter_Manufacturer__c;
                newStockGMeterRemove.Model__c              = jobResult.G_Meter_Version__c;  
                newStockGMeterRemove.MUS_Asset_Tag__c      = jobResult.Removed_G_Meter_Asset_Tag__c != null && 
                                                             jobResult.Removed_G_Meter_Asset_Tag__c.length() >13?
                                                             jobResult.Removed_G_Meter_Asset_Tag__c.subString(0, 13) :
                                                              jobResult.Removed_G_Meter_Asset_Tag__c;
                //newStockGMeterRemove.Date_Off_Circuit__c = jobResult.h_Appointment_Date__c;//CH05.old
                newStockGMeterRemove.Date_Off_Circuit__c   =Date.valueOf(jobResult.Time_On_Site__c);//CH05.New
                newStockGMeterRemove.Technician_Name__c    = jobResult.Technician__c;
                newStockGMeterRemove.EON_Job_Results__c    = jobResult.id;
                newStockGMeterRemove.Status__c             = 'Off-Circuit';    
                newStockGMeterRemove.Removed_Asset_Type__c = (jobResult.G_Meter_Type__c != null && 
                                                                jobResult.G_Meter_Type__c.length() > 24)? 
                                                           jobResult.G_Meter_Type__c.subString(0, 24) : 
                                                           jobResult.G_Meter_Type__c;
                lstInsertStock.add(newStockGMeterRemove);
                
                /* commented as part of CH03
                EON_Stock__c newStockGMeterRemove1 = new EON_Stock__c();
                newStockGMeterRemove1.Serial_Number__c      = jobResult.Gas_Regulator_Serial_Number__c;
                newStockGMeterRemove1.Date_Off_Circuit__c   = jobResult.h_Appointment_Date__c;//CH05.Updated Date_Removed__c to Date_Off_Circuit__c.
                newStockGMeterRemove1.Technician_Name__c    = jobResult.Technician__c;
                newStockGMeterRemove1.EON_Job_Results__c    = jobResult.id;
                newStockGMeterRemove1.Status__c             = 'Off-Circuit'; 
                newStockGMeterRemove1.Removed_Asset_Type__c = 'Regulator';
                
                lstInsertStock.add(newStockGMeterRemove1);
                */
            } 
            
                //CH05.Start
                //For Removed_Gas_Regulator_Serial_Number
                
                if(jobResult.Removed_Gas_Regulator_Serial_Number__c!=null && (oldJobResult == null || jobResult.Removed_Gas_Regulator_Serial_Number__c!=oldJobResult.Removed_Gas_Regulator_Serial_Number__c) &&
                 jobResult.Removed_Regulator_Reason__c!='Faulty/ Damaged'){
                     EON_Stock__c stock = new EON_Stock__c();
                     stock=CreateStockRecords(jobResult,jobResult.Removed_Gas_Regulator_Serial_Number__c); 
                     stock.MUS_Asset_Tag__c = jobResult.Removed_Regulator_Asset_Tag__c;		// CH06
                     lstInsertStock.add(stock);   
                     system.debug('gunatest1');
                  }
                
                //For Found_IHD_Serial_Number
                
                if(jobResult.Found_IHD_Serial_Number__c!=null && (oldJobResult == null || jobResult.Found_IHD_Serial_Number__c!=oldJobResult.Found_IHD_Serial_Number__c) && 
                   jobResult.Removed_IHD_Reason__c!='Fault / Damaged'){
                       EON_Stock__c stock = new EON_Stock__c();
                       stock=CreateStockRecords(jobResult,jobResult.Found_IHD_Serial_Number__c);
                       stock.MUS_Asset_Tag__c = jobResult.Removed_IHD_Asset_Tag__c;		// CH06
                       system.debug('=====>>t1'+stock);
                       lstInsertStock.add(stock); 
                 }
                
                //For Found_Comms_Hub_Serial_Number__c
                
                if(jobResult.Found_Comms_Hub_Serial_Number__c!=null && 
                  (oldJobResult == null || jobResult.Found_Comms_Hub_Serial_Number__c!=oldJobResult.Found_Comms_Hub_Serial_Number__c) &&
                  jobResult.Found_Comms_Hub_Serial_Number__c.length()>10 && jobResult.Removed_Comms_Hub_Reason__c!='Faulty/ Damaged'){
                      EON_Stock__c stock = new EON_Stock__c();
                      stock=CreateStockRecords(jobResult,jobResult.Found_Comms_Hub_Serial_Number__c);
                      stock.MUS_Asset_Tag__c = jobResult.Removed_Comms_Hub_Asset_Tag__c; 		//CH06
                      system.debug('===>>test'+stock.MUS_Asset_Tag__c);
                      system.debug('===>>teststock'+stock);
                      lstInsertStock.add(stock);
                
                }
                //CH05.End
            
            /* CH04.Start
            //CH01.Start
                if(  jobResult.Original_E_Meter_refitted__c != null && //CH01
                     jobResult.Original_E_Meter_refitted__c.equalsIgnorecase('Yes') && //CH01      
                    ((oldJobResult != null && jobResult.E_Meter_Removed__c != null && 
                     jobResult.E_Meter_Removed__c != oldJobResult.E_Meter_Removed__c &&  
                     jobResult.E_Meter_Removed__c.equalsIgnorecase('Yes')) // for update
                    ||
                    (oldJobResult == null && //for insert
                        jobResult.E_Meter_Removed__c != null && jobResult.E_Meter_Removed__c.equalsIgnorecase('Yes')))
                    ){
                        EON_Stock__c newStock = new EON_Stock__c();
                        newStock.Serial_Number__c      = jobResult.E_Meter_Serial_Number__c;
                        newStock.Manufacture__c        = (jobResult.E_Meter_Manufacturer__c != null && 
                                                            jobResult.E_Meter_Manufacturer__c.length() > 23) ? 
                                                         jobResult.E_Meter_Manufacturer__c.substring(0 , 23) :jobResult.E_Meter_Manufacturer__c ;
                        newStock.Model__c              = jobResult.E_Meter_Version__c;  
                        newStock.Date_Of_Installation__c = jobResult.h_Appointment_Date__c;
                        newStock.Technician_Name__c    = jobResult.Technician__c;
                        newStock.EON_Job_Results__c    = jobResult.id;
                        newStock.Status__c             = 'Refitted'; 
    
                        lstInsertStock.add(newStock);
                    } 
                    
            if(
                 jobResult.Original_G_Meter_refitted__c != null && //CH01
                 jobResult.Original_G_Meter_refitted__c.equalsIgnorecase('Yes') && //CH01   
                          
                ((oldJobResult != null && jobResult.G_Meter_Removed__c != null && 
                 jobResult.G_Meter_Removed__c != oldJobResult.G_Meter_Removed__c &&  
                 jobResult.G_Meter_Removed__c.equalsIgnorecase('Yes')) // for update
                ||
                (oldJobResult == null && //for insert
                    jobResult.G_Meter_Removed__c != null && jobResult.G_Meter_Removed__c.equalsIgnorecase('Yes')))
                ){ 
                    EON_Stock__c newStockGMeterRemove3 = new EON_Stock__c();
                    newStockGMeterRemove3.Serial_Number__c      = jobResult.G_Meter_Serial_Number__c;
                    newStockGMeterRemove3.Manufacture__c        = (jobResult.G_Meter_Manufacturer__c != null && 
                                                                    jobResult.G_Meter_Manufacturer__c.length() > 24) ? 
                                                                 jobResult.G_Meter_Manufacturer__c.substring(0 , 23) : 
                                                                 jobResult.G_Meter_Manufacturer__c;                    
                    newStockGMeterRemove3.Model__c              = jobResult.G_Meter_Version__c;
                    newStockGMeterRemove3.Date_Of_Installation__c = jobResult.h_Appointment_Date__c;
                    newStockGMeterRemove3.Technician_Name__c    = jobResult.Technician__c;
                    newStockGMeterRemove3.EON_Job_Results__c    = jobResult.id;
                    newStockGMeterRemove3.Status__c             = 'Refitted';                     
                    
                    lstInsertStock.add(newStockGMeterRemove3);                
                }                           
            //CH01.End   
            CH04.End */ 
            
            //CH05.Start
            //Creating Faulty records
              if(jobResult.Found_Comms_Hub_Serial_Number__c!=null && 
                  (oldJobResult == null || jobResult.Found_Comms_Hub_Serial_Number__c!=oldJobResult.Found_Comms_Hub_Serial_Number__c) &&
                  jobResult.Found_Comms_Hub_Serial_Number__c.length()>10 && jobResult.Removed_Comms_Hub_Reason__c=='Faulty/ Damaged'){
                      EON_Stock__c newStock = new EON_Stock__c();
                      newStock.Status__c='Faulty';
                      newStock.Technician_Name__c=jobResult.Technician__c;
                      newStock.EON_Job_Results__c=jobResult.id;
                      newStock.Serial_Number__c=jobResult.Found_Comms_Hub_Serial_Number__c;
                      newStock.Date_Faulty__c=Date.valueOf(jobResult.Time_On_Site__c);
                      newStock.MUS_Asset_Tag__c = jobResult.Removed_Comms_Hub_Asset_Tag__c;		//CH06
                      lstInsertStock.add(newStock);
              }
              
              if(jobResult.E_Meter_Removed__c!=null && jobResult.E_Meter_Removed__c.equalsIgnorecase('Yes') && jobResult.Original_E_Meter_refitted__c!='Yes' && jobResult.E_Meter_Serial_Number__c!=null &&
                 (oldJobResult == null || jobResult.E_Meter_Serial_Number__c!=oldJobResult.E_Meter_Serial_Number__c) && jobResult.Removed_E_Meter_Reason__c=='Faulty/ Damaged'){
                      EON_Stock__c newStock = new EON_Stock__c();
                      newStock.Status__c='Faulty';
                      newStock.Technician_Name__c=jobResult.Technician__c;
                      newStock.EON_Job_Results__c=jobResult.id;
                      newStock.Serial_Number__c=jobResult.E_Meter_Serial_Number__c;
                      newStock.Date_Faulty__c=Date.valueOf(jobResult.Time_On_Site__c);
                      // CH06 Start
                      newStock.MUS_Asset_Tag__c      = (jobResult.Removed_E_Meter_Asset_Tag__c != null && 
                                                     jobResult.Removed_E_Meter_Asset_Tag__c.length() > 13)?
                                                 jobResult.Removed_E_Meter_Asset_Tag__c.subString(0, 13) : 
                                                     jobResult.Removed_E_Meter_Asset_Tag__c;
                     // CH06 End
                      lstInsertStock.add(newStock);
              }
              
              if(jobResult.G_Meter_Removed__c!=null && jobResult.G_Meter_Removed__c.equalsIgnorecase('Yes') && jobResult.Original_G_Meter_refitted__c!='Yes' && jobResult.G_Meter_Serial_Number__c!=null &&
                  (oldJobResult == null || jobResult.G_Meter_Serial_Number__c!=oldJobResult.G_Meter_Serial_Number__c) && jobResult.Removed_G_Meter_Reason__c=='Faulty/ Damaged'){
                      EON_Stock__c newStock = new EON_Stock__c();
                      newStock.Status__c='Faulty';
                      newStock.Technician_Name__c=jobResult.Technician__c;
                      newStock.EON_Job_Results__c=jobResult.id;
                      newStock.Serial_Number__c=jobResult.G_Meter_Serial_Number__c;
                      newStock.Date_Faulty__c=Date.valueOf(jobResult.Time_On_Site__c);
                      // CH06 Start
                      newStock.MUS_Asset_Tag__c      = (jobResult.Removed_G_Meter_Asset_Tag__c != null && 
                                                     jobResult.Removed_G_Meter_Asset_Tag__c.length() > 13)?
                                                 jobResult.Removed_G_Meter_Asset_Tag__c.subString(0, 13) : 
                                                     jobResult.Removed_G_Meter_Asset_Tag__c;
                     // CH06 End
                     lstInsertStock.add(newStock);
              }
              
              if(jobResult.Found_IHD_Serial_Number__c!=null && (oldJobResult == null || jobResult.Found_IHD_Serial_Number__c!=oldJobResult.Found_IHD_Serial_Number__c) && 
                 jobResult.Removed_IHD_Reason__c=='Fault / Damaged'){
                      EON_Stock__c newStock = new EON_Stock__c();
                      newStock.Status__c='Faulty';
                      newStock.Technician_Name__c=jobResult.Technician__c;
                      newStock.EON_Job_Results__c=jobResult.id;
                      newStock.Serial_Number__c=jobResult.Found_IHD_Serial_Number__c;
                      newStock.Date_Faulty__c=Date.valueOf(jobResult.Time_On_Site__c);
                      newStock.MUS_Asset_Tag__c = jobResult.Removed_IHD_Asset_Tag__c;		// CH06
                     system.debug('=====>>'+newStock);
                      lstInsertStock.add(newStock);
              }
                  
              if(jobResult.Removed_Gas_Regulator_Serial_Number__c!=null && (oldJobResult == null || jobResult.Removed_Gas_Regulator_Serial_Number__c!=oldJobResult.Removed_Gas_Regulator_Serial_Number__c) &&
                 jobResult.Removed_Regulator_Reason__c=='Faulty/ Damaged'){
                      EON_Stock__c newStock = new EON_Stock__c();
                      newStock.Status__c='Faulty';
                      newStock.Technician_Name__c=jobResult.Technician__c;
                      newStock.EON_Job_Results__c=jobResult.id;
                      newStock.Serial_Number__c=jobResult.Removed_Gas_Regulator_Serial_Number__c;
                      newStock.Date_Faulty__c=Date.valueOf(jobResult.Time_On_Site__c);
                      newStock.MUS_Asset_Tag__c = jobResult.Removed_Regulator_Asset_Tag__c;		//CH06
                      lstInsertStock.add(newStock);
              }
                
            //CH05.End
        }
        
        
        if(!lstInsertStock.isEmpty())
            insert lstInsertStock;
            
        }catch(Exception ex){
            TriggerNew[0].addError('Exception Occured '+ ex.getMessage() + ' ' + ex.getStacktraceString());
        }              
    }
    //CH05.Start
    /**
        CreateStockRecords(EON_Job_Results__c jobResult,  String serialNumber)- This method will return instance EON_Stock__c 
    **/
    public static EON_Stock__c CreateStockRecords(EON_Job_Results__c jobResult, String serialNumber){
            EON_Stock__c stock = new EON_Stock__c();
            stock.Serial_Number__c=serialNumber;
            stock.Date_Off_Circuit__c=Date.valueOf(jobResult.Time_On_Site__c);
            stock.Technician_Name__c=jobResult.Technician__c;
            stock.EON_Job_Results__c=jobResult.id;
            stock.Status__c='Off-Circuit';
            return stock;
    }
    //CH05.End
    
}