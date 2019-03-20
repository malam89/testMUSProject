/**
    Description : This is the helper class for 
                    1)Trigger EON_Job_Result_Completion_Process 
                    2)It will process records on button click of Reprocess On EON Stock Object
    Test Class  : EON_Ceva_Stock_Reconcil_Process_Test

**/

    /* 
    Created By  : Shruti Moghe
    Created On  : 30/03/2016
    Service Req : SR_EON_AL_005 

    CHANGE HISTORY: 
    CH01 # SR_EON_AL_008 # 01-04-2016 # Kondal  # Added the code as per the logic    
    CH02 # SR_EON_Mobile_030 # 21-04-2016 # Krishna  # updated to code as per the  logic  
    CH03 # SR_EON_Mobile_042 #31/05/2016 #Shruti Moghe # Changed field type for the field Electric_SSC_to_be_installed__c
    CH04 # SR_EON_AL_019 # 02-06-2016 # Purvi  # Added the code as per the logic  
    CH05 # SR_EON_AL_020 # 10-06-2016 # Purvi  # Added the code as per the logic  
    CH06 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Electric_SSC_to_be_installed__c   
    CH07 # SR_EON_AL_022 # 10-06-2016 # Purvi  # changed status from Installed to Faulty
    CH08 # SR_EON_Mobile_044 # 16-06-2016 # Vinod # Changed Abort_Reason to picklist 
    CH09 # SR_EON_Mobile_048 # 20-06-2016 # Heena # Deleted the custom field "E_Meter_Manufacturer__c" as per the SR required.Hence, removed the field from this class as well. 
    CH10 # SR_EON_AL_024 # 27-06-2016 # Shruti Moghe # Updated the logic of process 
    CH11 # SR_EON_AL_031 # 10-08-2016 # Aruna Manjari # Updated the logic of process 
    CH12 # SR_EON_AL_033 # 08-09-2016 # Mahadev J # Updated the logic of process for Job result updates
    CH13 # 13/09/2016 # Shruti Moghe # Renamed the class from EON_Stock_Reconciliation_Process_Helper to EON_Ceva_Stock_Reconciliation_Process
    CH14 # SR_EON_Mobile_082 # 23/09/2016 # Mahadev J # Change data type for field 'E_Meter_Certification_Date__c', 'E_Meter_Exchange_Date__c', 'Uxp_G_Meter_Exchange_Date__c' from 'Date'
    CH15 # SR_EON_AL_037 #26/12/2016 # Vinod D # Deleted the field EON Holding Serialised Asset Unique ID
    CH16 # SR_EON_AL_038 #31/01/2017 # Praveen G # Added new methods for each serial number on Asset to update stock.
    CH17 # No Reference #15/03/2017 # Praveen G # Replaced URL.getSalesforceBaseUrl().toExternalForm() with EON_Utility.getInstanceURL()
    CH18 # REQUK0005891662 #26/05/2017 #Praveen G # fix for too many query rows.
    CH19 # SR_OptiMUS_EON_146 #28/11/2017 # Guna Sekhar P# Added functionality to update EON_Job_Results__c.EON_Stock_Status__c.
    CH20 # SR_OptiMUS_EON_171 #04/12/2017 # Praveen G # Update the condition to not create install stock.
    CH21 # SR_OptiMUS_EON_204 #01/01/2018 # Mehboob Alam # Added functionality as per SR requirement
    CH22 # SR_OptiMUS_EON_208 #12/02/2018 # Venkat # Added functionality to update EON_Stock_Status__c when IHD serial Number not found in EON Stock.
    CH23 # SR_OptiMUS_EON_222 #16/02/2018 # Mehboob Alam # Not Updating EON Stock Record for IHD if Original E Meter refitted = Yes and Original G Meter refitted = Yes. 
    CH24 # SR_EON_OFSC_034 #01/03/2018 # Puneet Mehta # Removed reference to ECV_Check_Passed
    CH25 # SR_OptiMUS_EON_229 #09/03/2018 # Mehboob Alam # Filter condition to query 6 month back Stock only.
    CH26 # SR_OptiMUS_EON_185 #14/03/2018 # Guna Sekhar P# Added functionality to update EON_Job_Results__c.EON_Stock_Status__c.
    CH27 # SR_OptiMUS_EON_187 #14/03/2018 # Shruti Moghe # added functionality for removing the S2 exception emails
    CH28 # SR_OptiMUS_EON_236 #16/04/2018 # Rangnath Agrahari # added functionality for adding the S2 exception emails 
    CH29 # SR_OptiMUS_EON_246 #25/05/2018 # Venkat Pattapu # Added functuonality
    */
global with sharing class EON_Ceva_Stock_Reconciliation_Process{

    /**
    EON_Stock_Reconciliation_Process_FaultyAsset(List<EON_Faulty_Asset__c> lstFaultyAssets, Boolean isTrigger) - This webservice is invokede on Button Click 'Reprocess' on EON Stock Object
    **/
     //CH01.Start 
    webservice static void EON_Stock_Reconciliation_Process_FaultyAsset(List<EON_Faulty_Asset__c> lstFaultyAssets, Boolean isTrigger)
    {             
         EON_Stock_Reconciliation_FaultyAsset(lstFaultyAssets,isTrigger);                
    }
     //CH01.End
    
    /**
    EON_Stock_Reconciliation_Process_JobResults(List<EON_Job_Results__c> lstJobResults, Boolean isTrigger) - This webservice is invokede on Button Click 'Reprocess' on EON Stock Object
    **/
    
    webservice static void EON_Stock_Reconciliation_Process_JobResults(List<EON_Job_Results__c> lstJobResults, Boolean isTrigger)
    {               
            EON_Stock_Reconciliation_JobResults(lstJobResults,isTrigger, null); 
    } 
    
    /**
    EON_Stock_Reconciliation_JobResults - This Method will Process the EON Stock Record based on EON_Stock_Reconciliation_Process
    **/
    
    public static void EON_Stock_Reconciliation_JobResults(List<EON_Job_Results__c> lstJobResultsnew, Boolean isTrigger ,Map<id,EON_Job_Results__c> lstJobResultsOld){  
        List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>();
        //List<EON_Job_Results__c> lstJobResultsnew = new List<EON_Job_Results__c>();
        //CH11.start
        /*if(lstJobResultsOld!=null && lstJobResultsOld.size()>0){
            for(EON_Job_Results__c job :lstJobResultsnew){
                if((lstJobResultsOld.get(job.Id).Found_IHD_Serial_Number__c!=job.Found_IHD_Serial_Number__c||
                lstJobResultsOld.get(job.Id) .Found_Comms_Hub_Serial_Number__c!=job.Found_Comms_Hub_Serial_Number__c||
                lstJobResultsOld.get(job.Id).New_IHD_Serial_Number__c!=job.New_IHD_Serial_Number__c||
                lstJobResultsOld.get(job.Id).New_Comms_Hub_Serial_Number__c!=job.New_Comms_Hub_Serial_Number__c||
                lstJobResultsOld.get(job.Id).New_Gas_Regulator_Serial_Number__c!=job.New_Gas_Regulator_Serial_Number__c||
                lstJobResultsOld.get(job.Id).New_G_Meter_Serial_Number__c!=job.New_G_Meter_Serial_Number__c||
                lstJobResultsOld.get(job.Id).New_E_Meter_Serial_Number__c!=job.New_E_Meter_Serial_Number__c||
                lstJobResultsOld.get(job.Id).Removed_Gas_Regulator_Serial_Number__c!=job.Removed_Gas_Regulator_Serial_Number__c||
                lstJobResultsOld.get(job.Id).Removed_G_Meter_Serial_Number__c!=job.Removed_G_Meter_Serial_Number__c||
                lstJobResultsOld.get(job.Id).Removed_E_Meter_Serial_Number__c!=job.Removed_E_Meter_Serial_Number__c ||
                lstJobResultsOld.get(job.Id).E_Meter_Removed__c!=job.E_Meter_Removed__c ||    //CH05
                lstJobResultsOld.get(job.Id).G_Meter_Removed__c!=job.G_Meter_Removed__c ||     //CH05
                lstJobResultsOld.get(job.Id).G_Meter_Installed__c!=job.G_Meter_Installed__c ||     //CH05
                lstJobResultsOld.get(job.Id).E_Meter_Installed__c!=job.E_Meter_Installed__c)     //CH05
                && (job.Job_Status__c!=null && job.Job_Status__c!='')){
                    if(job.Job_Status__c.equalsIgnoreCase('completed') || job.Job_Status__c.equalsIgnoreCase('Aborted')) //CH05
                        lstJobResultsnew.add(job);
                }
            }
        }*/
         //CH11.end else{
          /*  for(EON_Job_Results__c job : lstJobResultsnew){
                if(job.Job_Status__c!=null && job.Job_Status__c!=' ' ){
                 if(job.Job_Status__c.equalsIgnoreCase('completed') || job.Job_Status__c.equalsIgnoreCase('Aborted') ){ //CH05
                    lstJobResultsnew.add(job); 
                    System.debug('lstJobResults'+lstJobResultsnew);
                    }
                }
            }*/
        //}//CH11
        Map<String,List<EON_Stock__c>> mapStocks= new Map<String,List<EON_Stock__c>>();
        List<EON_Job_Results__c> lstJobResults = new List<EON_Job_Results__c>();
        set<EON_Job_Results__c> lstJobResultsUpdate = new set<EON_Job_Results__c>();//CH19     
        
        try{ 
        if(EON_Ceva_Stock_Reconcil_Process_Test.genException)
                   ID test = ID.valueOf('test');  //Generate Exception
            if(lstJobResultsnew!=null && lstJobResultsnew.size()>0) 
                  //CH09 Start
            lstJobResults=[SELECT New_E_Meter_Serial_Number__c,Original_E_Meter_refitted__c,Original_G_Meter_refitted__c,//CH21.Added new field
            Abort_Reason__c,Abort_Sub_Reason__c,Actual_Meter_Type_Installed__c,
                                        Advice_Given_to_Customer__c,Appliances_Off_Check_Made__c,Are_you_able_to_obtain_a_Reading__c,
                                        Arrival_Comment__c,Atmosphere_Check_Passed__c,Cable_Conversion_Blocks_Fitted__c,Comms_Hub_Found_on_Site__c,
                                        Compliant_Meter__c,Connector_Blocks_Fitted__c,Contactor_Fitted__c,CreatedById,CreatedDate,Customer_Informed__c,
                                        De_Energisation_Notes__c,De_Energisation_Reason__c, DNO_Electric_Reference_Number__c,
                                        DNO_Safe_to_Continue__c,DNO_Situation__c,Dual_Fuel_Remedy_Applied__c,Dual_Fuel_Remedy_Notes__c,
                                        Dual_Fuel_Replacement_Reason__c,Dual_Fuel_Replacement_Strategy__c,ECO_Callout__c,ECO_Invalid_Reason__c,
                                        ECO_Notes__c,/*ECV_Check_Passed__c, CH24*/Electricity_Action_Required__c,Electricity_Fault_Diagnosis_Visit_Notes__c,
                                        Electricity_Remedy_Applied__c,Electricity_Remedy_Notes__c,Electricity_Replacement_Notes__c,
                                        Electricity_Replacement_Reason__c,Electricity_Replacement_Strategy__c,Electric_SSC_to_be_installed__c,
                                        Elec_Prepay_Debt_Recovery_Rate__c,Elec_Prepay_Meter_Balance__c,Elec_Prepay_Meter_Emergency_Credit__c,
                                        Elec_Prepay_Meter_Register_ID__c,Elec_Prepay_Meter_Register_Label__c,Elec_Prepay_Meter_Register_Name__c,
                                        Elec_Prepay_Meter_Total_Debt__c,Elec_Prepay_Meter_Weekly_Charge__c,
                                        Elec_Revert_Reason_Notes__c,Emergency_Credit__c,EON_Regulator__c,Excess_Flow_Valve_Check_Passed__c,
                                        Expected_E_Meter_Found__c,Expected_G_Meter_Found__c,Expected_IHD_Found__c,Expected_Meter_Type_to_be_installed__c,
                                        Expected_Tariff__c,E_Meter_Certification_Date__c,E_Meter_Exchange_Date__c,E_Meter_Location__c,E_Meter_Manufacturer_version__c,
                                        E_Meter_Purpose__c,E_Meter_Register_1_ID__c,E_Meter_Register_1_Name__c,E_Meter_Register_1_Read__c,E_Meter_Register_2_ID__c,
                                        E_Meter_Register_2_Name__c,E_Meter_Register_2_Read__c,E_Meter_Register_3_ID__c,E_Meter_Register_3_Name__c,
                                        E_Meter_Register_3_Read__c,E_Meter_Register_4_ID__c,E_Meter_Register_4_Name__c,E_Meter_Register_4_Read__c,
                                        E_Meter_Register_5_Name__c,E_Meter_Register_5_Read__c,E_Meter_Register_6_ID__c,E_Meter_Register_6_Name__c,
                                        E_Meter_Register_6_Read__c,E_Meter_Removed__c,E_Meter_Serial_Number__c,E_Meter_Type__c,E_Meter_Version__c,
                                        Found_Comms_Hub_Serial_Number__c,Found_IHD_Manufacturer__c,Found_IHD_Model__c,Found_IHD_Serial_Number__c,
                                        Functional_Test_Required__c,Gas_Action_Required__c,Gas_Appliances_Not_Checked_Reason__c,Gas_Appliances_Relit__c,
                                        Gas_Dangerous_Label_Attached__c,Gas_Emergency_Job_Number__c,Gas_Fault_Diagnosis_Visit_Notes__c,Gas_Gaddpipe_Action__c,
                                        Gas_Inspection_Failure_Notes__c,Gas_Installation_Isolated__c,Gas_Meter_Exchange_Flag__c,Gas_off_Check_Made__c,
                                        Gas_Prepay_Meter_Balance__c,Gas_Prepay_Meter_Total_Debt__c,Gas_Regulator_Replaced__c,Gas_Regulator_Serial_Number__c,
                                        Gas_Remedy_Applied__c,Gas_Remedy_Notes__c,Gas_Replacement_Notes__c,Gas_Replacement_Reason__c,Gas_Replacement_Strategy__c,
                                        Gas_Revert_Reason_Notes__c,Gas_Safety_Notice_Issued__c,Gas_Site_Check_Performed__c,Gas_Site_Safety_Test_Omitted_Reason__c,
                                        Gas_Supply_Capped__c,Gas_Test_Failure_Notes__c,Gas_Test_Not_Performed_Reason__c,Gas_Tightness_Test_Performed__c,
                                        Gas_Voltage_Check_Passed__c,Genuine_ECO__c,G_Meter_Location__c,G_Meter_Manufacturer__c,G_Meter_Register_Read__c,
                                        G_Meter_Removed__c,G_Meter_Serial_Number__c,G_Meter_Type__c,G_Meter_Version__c,HAN_Channel_Installed__c,
                                        //HAN_Signal_Strength_at_Gas_Meter__c,
                                        //HAN_Signal_strength_at_IHD__c,
                                        HAN_Signal_Test_not_performed_Reason__c,
                                        HAN_Signal_Test_Performed__c,h_2_Pole_Isolators_Indicator__c,h_4_Pole_Isolators_Indicator__c,Id,IHD_Demo_Given__c,
                                        Initial_Contact_Comment__c,Initial_Contact_Outcome__c,G_Meter_Installed__c,E_Meter_Installed__c,
                                        Installed_Gas_Meter_Type__c,Installed_Meter_Tariff__c,IsDeleted,Job_Reference__c,Job_Status__c,Job_Sub_Type__c,Job_Type__c,
                                        Late_Reason__c,Length_of_pipe_used_in_Resiting__c,Length_of_Tails_Used_in_Resiting__c,Martindale_Check_Passed__c,
                                        Martindale_Test_Omitted_Reason__c,Meter_Box_Checked_for_Damage__c,Meter_Tails_1ph__c,Meter_Tails_3ph__c,
                                        Meter_Type_Tariff_Mismatch_Reason__c,Name,New_Comms_Hub_Serial_Number__c,New_E_Meter_Asset_Tag_Number__c,
                                        New_E_Meter_Number_of_digits__c,New_E_Meter_Register_1_Reading__c,New_E_Meter_Register_1_Type__c,
                                        New_E_Meter_Register_2_Reading__c,New_E_Meter_Register_2_Type__c,New_E_Meter_Register_3_Reading__c,
                                        New_E_Meter_Register_3_Type__c,New_E_Meter_Register_4_Reading__c,New_E_Meter_Register_4_Type__c,New_E_Meter_Register_5_Reading__c,
                                        New_E_Meter_Register_5_Type__c,New_E_Meter_Register_6_Reading__c,New_E_Meter_Register_6_Type__c,New_E_Meter_Type__c,New_Gas_Regulator_Serial_Number__c,
                                        New_G_Meter_Asset_Tag_Number__c,New_G_Meter_Number_of_digits__c,New_G_Meter_Serial_Number__c,New_G_Meter_Type__c,
                                        New_IHD_Serial_Number__c,New_IHD_supplied__c,New_Prepayment_Register_ID__c,
                                        New_Prepayment_Register_Label__c,New_Prepayment_Register_Name__c,
                                        Number_of_Resite_Blocks_used__c,Opening_G_Meter_Reading__c,Other_Electrical_Variations__c,
                                        Other_Gas_Variations__c,Outlet_Pressure_Check_Passed__c,OwnerId,Polarity_Check_Passed__c,Polarity_Test_Omitted_Reason__c,
                                        Pre_Work_Gas_Test_Failure_Notes__c,Reason_for_not_taking_Elec_Reading__c,Reason_for_not_taking_Gas_Reading__c,
                                        Reason_IHD_Not_Supplied__c,Relief_Valve_Check_Passed__c,Relief_Vent_Pipe_Check_Passed__c,Removed_Electricity_Register_1_ID__c,
                                        Removed_Electricity_Register_1_Read__c,Removed_Electricity_Register_2_ID__c,Removed_Electricity_Register_2_Read__c,
                                        Removed_E_Meter_Asset_Tag__c,Removed_E_Meter_Location__c,Removed_E_Meter_Serial_Number__c,Removed_E_Meter_Type__c,
                                        Removed_Gas_Meter_Register_Read__c,Removed_Gas_Regulator_Serial_Number__c,Removed_G_Meter_Asset_Tag__c,Removed_G_Meter_Location__c,
                                        Removed_G_Meter_Serial_Number__c,Removed_G_Meter_Type__c,Re_Energisation_Notes__c,Re_Energisation_Reason__c,
                                        Safety_Check_Failure_Reason__c,Safe_to_Continue__c,Site_Left_Energised__c,Site_Should_be_left_DeEnergised_Flag__c,
                                        Site_Should_be_left_Energised_Indicator__c,Site_Specific_Risk_Assessment_Complete__c,Size_of_Tails_Used_in_Resiting__c,
                                        Smart_Material_Left_with_Customer__c,Starting_De_Energisation_Status__c,Starting_Energisation_Status__c,SystemModstamp,
                                        Technician__c,Time_Closed__c,Time_Enroute__c,Time_On_Site__c,Timing_Device_Action__c,Total_Debt__c,Unexpected_E_Meter_Label_Flag__c,
                                        Uxp_E_Meter_Closing_Read_1__c,Uxp_E_Meter_Closing_Read_2__c,Uxp_E_Meter_Closing_Read_3__c,Uxp_E_Meter_Closing_Read_4__c,
                                        Uxp_E_Meter_Closing_Read_5__c,Uxp_E_Meter_Closing_Read_6__c,Uxp_E_Meter_Closing_Register_Name_2__c,Uxp_E_Meter_Closing_Register_Name_3__c,
                                        Uxp_E_Meter_Closing_Register_Name_4__c,Uxp_E_Meter_Closing_Register_Name_5__c,Uxp_E_Meter_Closing_Register_Name_6__c,
                                        Uxp_E_Meter_Opening_Read_1__c,Uxp_E_Meter_Opening_Read_2__c,Uxp_E_Meter_Opening_Read_3__c,Uxp_E_Meter_Opening_Read_4__c,
                                        Uxp_E_Meter_Opening_Read_5__c,Uxp_E_Meter_Opening_Read_6__c,Uxp_E_Meter_Opening_Register_Name_2__c,Uxp_G_Meter_Closing_Read__c,
                                        Uxp_G_Meter_Exchange_Date__c, Uxp_G_Meter_Opening_Read__c,Uxp_E_Meter_Opening_Register_Name_3__c,Uxp_E_Meter_Opening_Register_Name_4__c,
                                        Uxp_E_Meter_Opening_Register_Name_5__c,Uxp_E_Meter_Opening_Register_Name_6__c,Uxp_Gas_Collar_Status__c,WAN_Signal_Strength__c,
                                        Water_Corrosion_Check_Passed__c,Weekly_Debt_Repayment__c,Work_Completed__c,Work_Summary__c,X2_Pole_Isolators_fitted__c,
                                        X4_Pole_Isolators_fitted__c,Job_Reference__r.Appointment_Date__c,EON_Stock_Status__c,Removed_Regulator_Reason__c,Removed_IHD_Reason__c,
                                        Removed_Comms_Hub_Reason__c,Installed_Cradle_Serial_Number__c,Installed_Hot_Shoe_Serial_Number__c 
                                        FROM EON_Job_Results__c  where id IN: lstJobResultsnew];//CH03//CH06//CH19.added.EON_Stock_Status__c//CH26
            
            
            /*CH25.Start.Old
            //CH18.Start
            system.debug('Alljobs');
            Set<String> lstSerialNumber = new Set<String>();
            if(!lstJobResults.isEmpty()){
                lstSerialNumber.add(lstJobResults[0].New_E_Meter_Serial_Number__c);
                lstSerialNumber.add(lstJobResults[0].New_G_Meter_Serial_Number__c);
                lstSerialNumber.add(lstJobResults[0].New_Gas_Regulator_Serial_Number__c);
                lstSerialNumber.add(lstJobResults[0].New_Comms_Hub_Serial_Number__c);
                lstSerialNumber.add(lstJobResults[0].New_IHD_Serial_Number__c);            
            }
            //CH18.End
            //mapStocks =StockRecord();
            mapStocks =StockRecord(lstSerialNumber);//CH18   
            CH25.End.Old*/ 
            
            //CH25.Start
            if(!lstJobResults.isEmpty()){
                if(lstJobResults[0].New_E_Meter_Serial_Number__c!=null && lstJobResults[0].New_E_Meter_Serial_Number__c!='')
                    mapStocks.putAll(newStockRecord(lstJobResults[0].New_E_Meter_Serial_Number__c));
                if(lstJobResults[0].New_G_Meter_Serial_Number__c!=null && lstJobResults[0].New_G_Meter_Serial_Number__c!='')
                    mapStocks.putAll(newStockRecord(lstJobResults[0].New_G_Meter_Serial_Number__c));
                if(lstJobResults[0].New_Gas_Regulator_Serial_Number__c!=null && lstJobResults[0].New_Gas_Regulator_Serial_Number__c!='')
                    mapStocks.putAll(newStockRecord(lstJobResults[0].New_Gas_Regulator_Serial_Number__c));
                if(lstJobResults[0].New_IHD_Serial_Number__c!=null && lstJobResults[0].New_IHD_Serial_Number__c!='')
                    mapStocks.putAll(newStockRecord(lstJobResults[0].New_IHD_Serial_Number__c));  
                if(lstJobResults[0].Installed_Cradle_Serial_Number__c!=null && lstJobResults[0].Installed_Cradle_Serial_Number__c!='')//CH26
                    mapStocks.putAll(newStockRecord(lstJobResults[0].Installed_Cradle_Serial_Number__c));
                if(lstJobResults[0].Installed_Hot_Shoe_Serial_Number__c!=null && lstJobResults[0].Installed_Hot_Shoe_Serial_Number__c!='')//CH26
                    mapStocks.putAll(newStockRecord(lstJobResults[0].Installed_Hot_Shoe_Serial_Number__c));
                if(lstJobResults[0].New_Comms_Hub_Serial_Number__c!=null && lstJobResults[0].New_Comms_Hub_Serial_Number__c!='')//CH26
                    mapStocks.putAll(newStockRecord(lstJobResults[0].New_Comms_Hub_Serial_Number__c));  
                
            }
            //CH25.End
            
            //CH09 End
            SET<EON_Stock__c> lstStockToInsert = new SET<EON_Stock__c>();
            SET<EON_Stock__c> lstStockToUpdate = new SET<EON_Stock__c>();
            for(EON_Job_Results__c objJobResult : lstJobResults){
                if(isTrigger){
                    system.debug('###');                      
                    //CH05.Start
                if(objJobResult.Job_Status__c!=null) {
                    if(objJobResult.Job_Status__c.equalsIgnoreCase('Aborted') && objJobResult.E_Meter_Removed__c.equalsIgnoreCase('Yes') &&
                       objJobResult.G_Meter_Removed__c.equalsIgnoreCase('Yes') && objJobResult.E_Meter_Installed__c.equalsIgnoreCase('Yes') &&
                       objJobResult.G_Meter_Installed__c.equalsIgnoreCase('Yes')){ 
                           emaillist.add(ProcessEmails_JobResults(new List<EON_Stock__c>(),objJobResult,'',System.Label.EON_Job_Results_Aborted));   
                    }
                }
                    system.debug('&&&');
                    //CH05.End 
                    /*  
                    if(lstJobResultsOld!=null && lstJobResultsOld.size()>0 ){
                        if((lstJobResultsOld.get(objJobResult.Id).Removed_E_Meter_Serial_Number__c!=objJobResult.Removed_E_Meter_Serial_Number__c) && (objJobResult.Removed_E_Meter_Serial_Number__c !=null && objJobResult.Removed_E_Meter_Serial_Number__c !='' && objJobResult.Technician__c!=null)) {
                            EON_Stock__c stock = new EON_Stock__c();
                            stock=CreateStockRecords(objJobResult,objJobResult.Removed_E_Meter_Serial_Number__c); 
                            lstStockToInsert.add(stock);                        
                        }
                        if((lstJobResultsOld.get(objJobResult.Id).Removed_G_Meter_Serial_Number__c!=objJobResult.Removed_G_Meter_Serial_Number__c) && (objJobResult.Removed_G_Meter_Serial_Number__c !=null && objJobResult.Removed_G_Meter_Serial_Number__c !='' && objJobResult.Technician__c!=null))
                        {
                            EON_Stock__c stock = new EON_Stock__c();
                            stock=CreateStockRecords(objJobResult,objJobResult.Removed_G_Meter_Serial_Number__c ); 
                            lstStockToInsert.add(stock);
                        
                        }
                        if((lstJobResultsOld.get(objJobResult.Id).Removed_Gas_Regulator_Serial_Number__c!=objJobResult.Removed_Gas_Regulator_Serial_Number__c) && (objJobResult.Removed_Gas_Regulator_Serial_Number__c !=null && objJobResult.Removed_Gas_Regulator_Serial_Number__c !='' && objJobResult.Technician__c!=null)){
                            EON_Stock__c stock = new EON_Stock__c();
                            stock=CreateStockRecords(objJobResult,objJobResult.Removed_Gas_Regulator_Serial_Number__c ); 
                            lstStockToInsert.add(stock);
                        }
                        if((lstJobResultsOld.get(objJobResult.Id).Found_Comms_Hub_Serial_Number__c!=objJobResult.Found_Comms_Hub_Serial_Number__c) && (objJobResult.Found_Comms_Hub_Serial_Number__c !=null && objJobResult.Found_Comms_Hub_Serial_Number__c !='' && objJobResult.Technician__c!=null)){
                        if(objJobResult.Found_Comms_Hub_Serial_Number__c==objJobResult.New_Comms_Hub_Serial_Number__c){
                                EON_Stock__c stock = new EON_Stock__c();
                                stock.Serial_Number__c=objJobResult.Found_Comms_Hub_Serial_Number__c;
                                stock.Date_of_Installation__c=objJobResult.Job_Reference__r.Appointment_Date__c;
                                stock.Technician_Name__c=objJobResult.Technician__c;
                                stock.EON_Job_Results__c=objJobResult.id;
                                stock.Status__c='Installed';
                                lstStockToInsert.add(stock);        
                            }
                            if(objJobResult.Found_Comms_Hub_Serial_Number__c!=objJobResult.New_Comms_Hub_Serial_Number__c){
                                EON_Stock__c stock = new EON_Stock__c();
                                stock=CreateStockRecords(objJobResult,objJobResult.Found_Comms_Hub_Serial_Number__c ); 
                                lstStockToInsert.add(stock);         
                            }
                        
                        }
                        if((lstJobResultsOld.get(objJobResult.Id).Found_IHD_Serial_Number__c!=objJobResult.Found_IHD_Serial_Number__c) && (objJobResult.Found_IHD_Serial_Number__c !=null && objJobResult.Found_IHD_Serial_Number__c !='' && objJobResult.Technician__c!=null)){
                            if(objJobResult.Found_IHD_Serial_Number__c==objJobResult.New_IHD_Serial_Number__c){
                                EON_Stock__c stock = new EON_Stock__c();
                                stock.Serial_Number__c=objJobResult.Found_IHD_Serial_Number__c;
                                stock.Date_of_Installation__c=objJobResult.Job_Reference__r.Appointment_Date__c;
                                stock.Technician_Name__c=objJobResult.Technician__c;
                                stock.EON_Job_Results__c=objJobResult.id;
                                stock.Status__c='Installed';
                                lstStockToInsert.add(stock);        
                            }
                            if(objJobResult.Found_IHD_Serial_Number__c!=objJobResult.New_IHD_Serial_Number__c){
                                EON_Stock__c stock = new EON_Stock__c();
                                stock=CreateStockRecords(objJobResult,objJobResult.Found_IHD_Serial_Number__c ); 
                                lstStockToInsert.add(stock);    
                            }
                        }   
                        
                    }
                    else{*/
                         /* //Commented as part of CH20
                         if(objJobResult.New_Comms_Hub_Serial_Number__c !=null && objJobResult.New_Comms_Hub_Serial_Number__c !=''){
                            //CH05 Start
                            EON_Stock__c stock = new EON_Stock__c();
                            stock.Serial_Number__c=objJobResult.New_Comms_Hub_Serial_Number__c ;
                            stock.Date_of_Installation__c=objJobResult.Job_Reference__r.Appointment_Date__c;
                            stock.Technician_Name__c=objJobResult.Technician__c;
                            stock.EON_Job_Results__c=objJobResult.id;
                            stock.Status__c='Installed';
                            lstStockToInsert.add(stock);
                            //CH05.end
                        } 
                        */    
                        if(objJobResult.Removed_E_Meter_Serial_Number__c !=null && objJobResult.Removed_E_Meter_Serial_Number__c !='' && objJobResult.Technician__c!=null){                             
                                EON_Stock__c stock = new EON_Stock__c();
                                stock=CreateStockRecords(objJobResult,objJobResult.Removed_E_Meter_Serial_Number__c); 
                                lstStockToInsert.add(stock);
                        }                   
                        if(objJobResult.Removed_G_Meter_Serial_Number__c !=null && objJobResult.Removed_G_Meter_Serial_Number__c !='' && objJobResult.Technician__c!=null){
                                EON_Stock__c stock = new EON_Stock__c();
                                stock=CreateStockRecords(objJobResult,objJobResult.Removed_G_Meter_Serial_Number__c); 
                                lstStockToInsert.add(stock);
                        }
                       //CH26.Removed the below code and moved(Off-Circuit Stock records creation)to EON_Job_Results_Trigger_Helper_Stock Class.
                       /*
                        if(objJobResult.Removed_Gas_Regulator_Serial_Number__c !=null && objJobResult.Removed_Gas_Regulator_Serial_Number__c !='' && objJobResult.Technician__c!=null){
                                 stock=CreateStockRecords(objJobResult,objJobResult.Removed_Gas_Regulator_Serial_Number__c); 
                                lstStockToInsert.add(stock);   
                        } */
                        //for Found Comms Hub Serial Number
                        if(objJobResult.Found_Comms_Hub_Serial_Number__c !=null && objJobResult.Found_Comms_Hub_Serial_Number__c !='' && objJobResult.Technician__c!=null){
                            if(objJobResult.Found_Comms_Hub_Serial_Number__c==objJobResult.New_Comms_Hub_Serial_Number__c){
                                EON_Stock__c stock = new EON_Stock__c();
                                stock.Serial_Number__c=objJobResult.Found_Comms_Hub_Serial_Number__c;
                                stock.Date_of_Installation__c=objJobResult.Job_Reference__r.Appointment_Date__c;
                                stock.Technician_Name__c=objJobResult.Technician__c;
                                stock.EON_Job_Results__c=objJobResult.id;
                                stock.Status__c='Installed';
                                lstStockToInsert.add(stock);        
                        }
                        //CH26.Removed the below code and moved(Off-Circuit Stock records creation)to EON_Job_Results_Trigger_Helper_Stock Class.
                       /*
                       if(objJobResult.Found_Comms_Hub_Serial_Number__c!=objJobResult.New_Comms_Hub_Serial_Number__c){
                                EON_Stock__c stock = new EON_Stock__c();
                                stock=CreateStockRecords(objJobResult,objJobResult.Found_Comms_Hub_Serial_Number__c); 
                                lstStockToInsert.add(stock);        
                         }*/
                        }
                        //for Found IHD Serial Number  Found_IHD_Serial_Number__c
                        if(objJobResult.Found_IHD_Serial_Number__c !=null && objJobResult.Found_IHD_Serial_Number__c !='' && objJobResult.Technician__c!=null){
                            if(objJobResult.Found_IHD_Serial_Number__c==objJobResult.New_IHD_Serial_Number__c){
                                EON_Stock__c stock = new EON_Stock__c();
                                stock.Serial_Number__c=objJobResult.Found_IHD_Serial_Number__c;
                                stock.Date_of_Installation__c=objJobResult.Job_Reference__r.Appointment_Date__c;
                                stock.Technician_Name__c=objJobResult.Technician__c;
                                stock.EON_Job_Results__c=objJobResult.id;
                                stock.Status__c='Installed';
                                lstStockToInsert.add(stock);        
                            }
                            //CH26.Removed the below code and moved(Off-Circuit Stock records creation)to EON_Job_Results_Trigger_Helper_Stock Class.
                            /*
                              if(objJobResult.Found_IHD_Serial_Number__c!=objJobResult.New_IHD_Serial_Number__c){
                                 EON_Stock__c stock = new EON_Stock__c();
                                stock=CreateStockRecords(objJobResult,objJobResult.Found_IHD_Serial_Number__c ); 
                                lstStockToInsert.add(stock);         
                              }*/
                        }   
                    
                }
                
                //CH26.Start
                //for Installed Cradle Serial Number 
                  if(objJobResult.Installed_Cradle_Serial_Number__c!=null && objJobResult.Installed_Cradle_Serial_Number__c!=''){
                  System.debug('Cradle--->'+mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c));
                      if(mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c)!=null && mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c).size()==1){//CH28 removed >= and added ==
                        /* List< EON_Stock__c> lststock = mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c);
                             for(EON_Stock__c stock :lststock){
                                 stock.EON_Job_Results__c=objJobResult.id;
                                 stock.Status__c='Installed';
                                 stock.Date_of_Installation__c=Date.valueOf(objJobResult.Time_On_Site__c);
                                 lstStockToUpdate.add(stock);
                             }*/
                          EON_Stock__c stock1= new EON_Stock__c();
                         stock1= ProcessStockRecords(objJobResult,mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c));
                         if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Installed') )
                         lstStockToUpdate.add(stock1);         
                       }
                       
                   //CH28.start
                   //no match found for serial number
                    else if(mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c)==null){
                            //CH19.Start
                            if(objJobResult.EON_Stock_Status__c!='Reviewed'){
                               objJobResult.EON_Stock_Status__c='Validation Required';
                               lstJobResultsUpdate.add(objJobResult);
                               }
                    }
                   else{
                        List<EON_Stock__c> LstStockToMail= new list<EON_Stock__c>();
                        List<EON_Stock__c> LstStockTechMail= new list<EON_Stock__c>();
                        for(EON_Stock__c stock1: mapStocks.get(objJobResult.Installed_Cradle_Serial_Number__c)){                             
                            if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('On Van')){
                                LstStockToMail.add(stock1);
                            }
                        }
                        if(LstStockToMail != null && LstStockToMail.size()>1)
                            emaillist.add(ProcessEmails_JobResults(LstStockToMail,objJobResult,objJobResult.Installed_Cradle_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                   }
                 }
                   //CH28.end
                  //for Installed Hot-Shoe Serial Number  
                  if(objJobResult.Installed_Hot_Shoe_Serial_Number__c!=null && objJobResult.Installed_Hot_Shoe_Serial_Number__c!=''){
                    System.debug('Cradle--->'+mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c)); 
                      if(mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c)!=null && mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c).size()==1){//CH28 removed >= and added ==
                        /* List< EON_Stock__c> lststock = mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c);
                             for(EON_Stock__c stock :lststock){
                                 stock.EON_Job_Results__c=objJobResult.id;
                                 stock.Status__c='Installed';
                                 stock.Date_of_Installation__c=Date.valueOf(objJobResult.Time_On_Site__c);
                                 lstStockToUpdate.add(stock);
                             }*/
                         EON_Stock__c stock1= new EON_Stock__c();
                         stock1= ProcessStockRecords(objJobResult,mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c));
                         if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Installed') )
                         lstStockToUpdate.add(stock1); 
                       }
                  
                    //CH28.start
                     //no match found for serial number
                    else if(mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c)==null){
                            //CH19.Start
                            if(objJobResult.EON_Stock_Status__c!='Reviewed'){
                               objJobResult.EON_Stock_Status__c='Validation Required';
                               lstJobResultsUpdate.add(objJobResult);
                               }
                    }
                   else{
                        List<EON_Stock__c> LstStockToMail= new list<EON_Stock__c>();
                        List<EON_Stock__c> LstStockTechMail= new list<EON_Stock__c>();
                        for(EON_Stock__c stock1: mapStocks.get(objJobResult.Installed_Hot_Shoe_Serial_Number__c)){                             
                            if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('On Van')){
                                LstStockToMail.add(stock1);
                            }
                        }
                        if(LstStockToMail != null && LstStockToMail.size()>1)
                            emaillist.add(ProcessEmails_JobResults(LstStockToMail,objJobResult,objJobResult.Installed_Hot_Shoe_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                   }
                   }
                   //CH28.end
                   //for New_Comms_Hub_Serial_Number__c                
                  if(objJobResult.New_Comms_Hub_Serial_Number__c!=null && objJobResult.New_Comms_Hub_Serial_Number__c!='' && objJobResult.Original_E_Meter_refitted__c!='Yes' && objJobResult.New_Comms_Hub_Serial_Number__c.length() > 10){
                  System.debug('Cradle--->'+mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c));
                      if(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c)!=null && mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c).size()==1){//CH28 removed >= and added ==
                         /*List< EON_Stock__c> lststock = mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c);
                             for(EON_Stock__c stock :lststock){
                                 stock.EON_Job_Results__c=objJobResult.id;
                                 stock.Technician_Mismatch__c=true;//CH29
                                 stock.Technician_Name__c=objJobResult.Technician__c;//CH29
                                 stock.Status__c='Installed';
                                 stock.Date_of_Installation__c=Date.valueOf(objJobResult.Time_On_Site__c);
                                 lstStockToUpdate.add(stock);
                             }*/
                             EON_Stock__c stock1= new EON_Stock__c();
                         stock1= ProcessStockRecords(objJobResult,mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c));
                         if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Installed') )
                         lstStockToUpdate.add(stock1); 
                       }
                   //CH28.start
                   //no match found for serial number
                    else if(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c)==null){
                            //CH19.Start
                            if(objJobResult.EON_Stock_Status__c!='Reviewed'){
                               objJobResult.EON_Stock_Status__c='Validation Required';
                               lstJobResultsUpdate.add(objJobResult);
                               }
                    }
                   else{
                        List<EON_Stock__c> LstStockToMail= new list<EON_Stock__c>();
                        List<EON_Stock__c> LstStockTechMail= new list<EON_Stock__c>();
                        for(EON_Stock__c stock1: mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c)){                             
                            if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('On Van')){
                                LstStockToMail.add(stock1);
                            }
                        }
                        if(LstStockToMail != null && LstStockToMail.size()>1)
                            emaillist.add(ProcessEmails_JobResults(LstStockToMail,objJobResult,objJobResult.New_Comms_Hub_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                   }
                 }
                  //CH26.End    
                      
                //for Confirmed Electricity Meter Serial Number which is renamed now as "New E Meter Serial Number"
                if(objJobResult.New_E_Meter_Serial_Number__c !=null && objJobResult.New_E_Meter_Serial_Number__c !=''){
                    //single match found
                    system.debug('+++++'+mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c));
                    if(mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c)!=null && mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c).size()==1){
                        EON_Stock__c stock1= new EON_Stock__c();
                        stock1= ProcessStockRecords(objJobResult,mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c));
                         if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Installed') && objJobResult.Original_E_Meter_refitted__c!='Yes')//CH21
                        lstStockToUpdate.add(stock1);               
                         if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Validation Required')){ 
                            List<EON_Stock__c> lstStockForEmail = new List<EON_Stock__c>();
                            lstStockForEmail.add(stock1);
                            //emaillist.add(ProcessEmails_JobResults(lstStockForEmail,objJobResult,objJobResult.New_E_Meter_Serial_Number__c,System.Label.EON_Stock_Technician_Name_manual_update_Template)); //CH27 - E001 Technician Mismatch – An email is no longer required for this exception as a reportable field has been created “EON Stock . Technician Mismatch” in a previous SR.  
                        }
                    }
                    //no match found for serial number
                    else if(mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c)==null){
                            //CH19.Start
                            if(objJobResult.EON_Stock_Status__c!='Reviewed' /*&& objJobResult.EON_Stock_Status__c!='Email Sent'*/){//CH28
                               objJobResult.EON_Stock_Status__c='Validation Required';
                               lstJobResultsUpdate.add(objJobResult);
                               }/*else if(objJobResult.EON_Stock_Status__c!='Validated By Routine'){//CH19.End
                               emaillist.add(ProcessEmails_JobResults(new List<EON_Stock__c>(),objJobResult,objJobResult.New_E_Meter_Serial_Number__c,System.Label.EON_Stock_No_matching_serial_number_Template));
                               //objJobResult.EON_Stock_Status__c='Email Sent';//CH26//CH28.commented as per SR
                               lstJobResultsUpdate.add(objJobResult);
                               }*/ //CH28. Removed E003 email
                           }
                    //more than one match found
                    else{
                    //CH05 Start
                        List<EON_Stock__c> LstStockToMail= new list<EON_Stock__c>();
                        List<EON_Stock__c> LstStockTechMail= new list<EON_Stock__c>();
                        
                        for(EON_Stock__c stock1: mapStocks.get(objJobResult.New_E_Meter_Serial_Number__c)){                             
                            if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('On Van')){
                                //CH27.old.start
                                /*
                                if( stock1.Technician_Name__c != objJobResult.Technician__c ){
                                    stock1.status__c='Validation Required'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    LstStockTechMail.add(stock1);               
                                    lstStockToUpdate.add(stock1);               
                                }
                                if( stock1.Technician_Name__c == objJobResult.Technician__c ){
                                    stock1.status__c = 'Installed'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    stock1.Date_of_Installation__c= objJobResult.Job_Reference__r.Appointment_Date__c;
                                    lstStockToUpdate.add(stock1);               
                                }
                                */
                                //CH27.old.end
                                //CH27.new.start                                
                                LstStockToMail.add(stock1);
                                //Ch27.new.end                  
                            }
                            //else LstStockToMail.add(stock1);
                            //CH10 Updated logic to avoid loop
                            else if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Validation Required')){
                                if( stock1.Technician_Name__c != objJobResult.Technician__c ) LstStockTechMail.add(stock1);
                                if( stock1.Technician_Name__c == objJobResult.Technician__c ){
                                    stock1.status__c = 'Installed'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    stock1.Date_of_Installation__c= objJobResult.Job_Reference__r.Appointment_Date__c;
                                    lstStockToUpdate.add(stock1);               
                                }
                            }
                            //else
                            //LstStockToMail.add(stock1);//CH27.old
                        }
                        if(LstStockToMail != null && LstStockToMail.size()>1)//CH27
                            emaillist.add(ProcessEmails_JobResults(LstStockToMail,objJobResult,objJobResult.New_E_Meter_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                           // if(LstStockTechMail != null && LstStockTechMail.size()>0)//CH27
                           // emaillist.add(ProcessEmails_JobResults(LstStockTechMail,objJobResult,objJobResult.New_E_Meter_Serial_Number__c,System.Label.EON_Stock_Technician_Name_manual_update_Template));   //CH27 - E001 Technician Mismatch – An email is no longer required for this exception as a reportable field has been created “EON Stock . Technician Mismatch” in a previous SR.                     
                    //CH05 End                   
                    }               
                }
                //for Confirmed Gas Meter Serial Number which is renamed now as "New G Meter Serial Number"
                if(objJobResult.New_G_Meter_Serial_Number__c !=null && objJobResult.New_G_Meter_Serial_Number__c !=''){
                    system.debug('+++++++++++++++'+mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c));
                    if(mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c)!=null && mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c).size()==1){
                         EON_Stock__c stock1= new EON_Stock__c();
                         stock1= ProcessStockRecords(objJobResult,mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c));
                         if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Installed') && objJobResult.Original_G_Meter_refitted__c!='Yes')//CH21
                         lstStockToUpdate.add(stock1);                   
                         if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Validation Required')){
                            List<EON_Stock__c> lstStockForEmail = new List<EON_Stock__c>();
                            lstStockForEmail.add(stock1);
                            //emaillist.add(ProcessEmails_JobResults(lstStockForEmail,objJobResult,objJobResult.New_G_Meter_Serial_Number__c,System.Label.EON_Stock_Technician_Name_manual_update_Template)); //CH27-E001 Technician Mismatch – An email is no longer required for this exception as a reportable field has been created “EON Stock . Technician Mismatch” in a previous SR.
                        }   
                    }
                    else if(mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c)==null){
                            //CH19.Start
                            if(objJobResult.EON_Stock_Status__c!='Reviewed' /*&& objJobResult.EON_Stock_Status__c!='Email Sent'*/){//CH28
                                 objJobResult.EON_Stock_Status__c='Validation Required';
                                 lstJobResultsUpdate.add(objJobResult);
                               }/*else if(objJobResult.EON_Stock_Status__c!='Validated By Routine'){//CH19.End
                               emaillist.add(ProcessEmails_JobResults(new List<EON_Stock__c>(),objJobResult,objJobResult.New_G_Meter_Serial_Number__c,System.Label.EON_Stock_No_matching_serial_number_Template));
                               //objJobResult.EON_Stock_Status__c='Email Sent';//CH26//CH28.commented as per SR
                               lstJobResultsUpdate.add(objJobResult);
                               }*/ //CH28. Removed E003 email
                    }
                    else{
                    //CH05 Start
                        List<EON_Stock__c> LstStockToMail= new list<EON_Stock__c>();
                        List<EON_Stock__c> LstStockTechMail= new list<EON_Stock__c>();
                        
                        for(EON_Stock__c stock1: mapStocks.get(objJobResult.New_G_Meter_Serial_Number__c)){                             
                            if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('On Van')){
                                //CH27.old.start
                                /*
                                if( stock1.Technician_Name__c != objJobResult.Technician__c ){
                                    stock1.status__c='Validation Required'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    LstStockTechMail.add(stock1);               
                                    lstStockToUpdate.add(stock1);               
                                }
                                if( stock1.Technician_Name__c == objJobResult.Technician__c ){
                                    stock1.status__c = 'Installed'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    stock1.Date_of_Installation__c= objJobResult.Job_Reference__r.Appointment_Date__c;
                                    lstStockToUpdate.add(stock1);               
                                }
                                */
                                //CH27.old.end
                                //CH27.new.start                                
                                LstStockToMail.add(stock1);
                                //Ch27.new.end  
                            }
                            //else LstStockToMail.add(stock1);
                            //CH10 Updated logic to avoid loop
                            else if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Validation Required')){
                                if( stock1.Technician_Name__c != objJobResult.Technician__c ){
                                    LstStockTechMail.add(stock1);                            
                                }
                                if( stock1.Technician_Name__c == objJobResult.Technician__c ){
                                    stock1.status__c = 'Installed'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    stock1.Date_of_Installation__c= objJobResult.Job_Reference__r.Appointment_Date__c;
                                    lstStockToUpdate.add(stock1);               
                                }
                            }
                            //else
                           // LstStockToMail.add(stock1);//CH27.old
                        }
                        //CH10.start
                        if(LstStockToMail != null && LstStockToMail.size()>1)//CH27
                        emaillist.add(ProcessEmails_JobResults(LstStockToMail,objJobResult,objJobResult.New_G_Meter_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));//CH28
                        //CH10.end
                       /* if(LstStockTechMail != null && LstStockTechMail.size()>0)
                            emaillist.add(ProcessEmails_JobResults(LstStockTechMail,objJobResult,objJobResult.New_E_Meter_Serial_Number__c,System.Label.EON_Stock_Technician_Name_manual_update_Template)); */ //CH27-E001 Technician Mismatch – An email is no longer required for this exception as a reportable field has been created “EON Stock . Technician Mismatch” in a previous SR.                  
                    //CH05 End                   
                    }                     
                }
                
                
                //for New Gas Regulator Serial Number
               if(objJobResult.Original_G_Meter_refitted__c!='Yes'){ //CH23
               System.debug('shruti---->'+mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c)+'--->'+objJobResult.New_Gas_Regulator_Serial_Number__c);
                if(objJobResult.New_Gas_Regulator_Serial_Number__c !=null && objJobResult.New_Gas_Regulator_Serial_Number__c !=''){
                    if(mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c)!=null && mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c).size()==1){
                        EON_Stock__c stock1= new EON_Stock__c();
                        stock1= ProcessStockRecords(objJobResult,mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c));
                        lstStockToUpdate.add(stock1);
                          if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Validation Required')){
                            List<EON_Stock__c> lstStockForEmail = new List<EON_Stock__c>();
                            lstStockForEmail.add(stock1);
                            //emaillist.add(ProcessEmails_JobResults(lstStockForEmail,objJobResult,objJobResult.New_Gas_Regulator_Serial_Number__c,System.Label.EON_Stock_Technician_Name_manual_update_Template));//CH27-E001 Technician Mismatch – An email is no longer required for this exception as a reportable field has been created “EON Stock . Technician Mismatch” in a previous SR.
                        }
                    }
                    else if(mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c)==null){
                            //CH19.Start
                            if(objJobResult.EON_Stock_Status__c!='Reviewed' /*&& objJobResult.EON_Stock_Status__c!='Email Sent'*/){//CH28
                                objJobResult.EON_Stock_Status__c='Validation Required';
                                lstJobResultsUpdate.add(objJobResult);
                               }/*else if(objJobResult.EON_Stock_Status__c!='Validated By Routine'){//CH19.End
                               emaillist.add(ProcessEmails_JobResults(new List<EON_Stock__c>(),objJobResult,objJobResult.New_Gas_Regulator_Serial_Number__c,System.Label.EON_Stock_No_matching_serial_number_Template));
                               //objJobResult.EON_Stock_Status__c='Email Sent';//CH26//CH28.commented as per SR
                               lstJobResultsUpdate.add(objJobResult);
                               }*/ //CH28. Removed E003 email
                    }
                    else{
                    //CH05 Start    
                        List<EON_Stock__c> LstStockToMail= new list<EON_Stock__c>();
                        List<EON_Stock__c> LstStockTechMail= new list<EON_Stock__c>();
                        
                        for(EON_Stock__c stock1: mapStocks.get(objJobResult.New_Gas_Regulator_Serial_Number__c)){                             
                            if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('On Van')){
                               //CH27.old.start
                                /*
                                if( stock1.Technician_Name__c != objJobResult.Technician__c ){
                                    stock1.status__c='Validation Required'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    LstStockTechMail.add(stock1);               
                                    lstStockToUpdate.add(stock1);               
                                }
                                if( stock1.Technician_Name__c == objJobResult.Technician__c ){
                                    stock1.status__c = 'Installed'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    stock1.Date_of_Installation__c= objJobResult.Job_Reference__r.Appointment_Date__c;
                                    lstStockToUpdate.add(stock1);               
                                }
                                */
                                //CH27.old.end
                                //CH27.new.start                                
                                LstStockToMail.add(stock1);
                                //Ch27.new.end  
                            }
                            //else LstStockToMail.add(stock1);
                            //CH10 Updated logic to avoid loop
                            else if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Validation Required')){
                                if( stock1.Technician_Name__c != objJobResult.Technician__c ){
                                    LstStockTechMail.add(stock1);                            
                                }
                                if( stock1.Technician_Name__c == objJobResult.Technician__c ){
                                    stock1.status__c = 'Installed'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    stock1.Date_of_Installation__c= objJobResult.Job_Reference__r.Appointment_Date__c;
                                    lstStockToUpdate.add(stock1);               
                                }
                            }
                            //else/
                            //LstStockToMail.add(stock1);//CH27.old
                        }
                        //CH10.start
                       if(LstStockToMail != null && LstStockToMail.size()>1)//CH27
                            emaillist.add(ProcessEmails_JobResults(LstStockToMail,objJobResult,objJobResult.New_Gas_Regulator_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));//CH28
                        //CH10.end
                       /* if(LstStockTechMail != null && LstStockTechMail.size()>0)
                            emaillist.add(ProcessEmails_JobResults(LstStockTechMail,objJobResult,objJobResult.New_E_Meter_Serial_Number__c,System.Label.EON_Stock_Technician_Name_manual_update_Template)); */ //CH27-E001 Technician Mismatch – An email is no longer required for this exception as a reportable field has been created “EON Stock . Technician Mismatch” in a previous SR.                       
                    //CH05 End                   
                    }               
                 }
               }
                
                //for New Comms Hub Serial Number 
                 
            
                    /*
                    if(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c)!=null && mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c).size()==1){
                         EON_Stock__c stock1= new EON_Stock__c();
                         stock1= ProcessStockRecords(objJobResult,mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c));
                         system.debug('stock to update in new'+stock1);
                         lstStockToUpdate.add(stock1);
                         if(stock1!=null && stock1.Status__c=='Validation Required'){
                            List<EON_Stock__c> lstStockForEmail = new List<EON_Stock__c>();
                            lstStockForEmail.add(stock1);
                           emaillist.add(ProcessEmails_JobResults(lstStockForEmail,objJobResult,objJobResult.New_Comms_Hub_Serial_Number__c,System.Label.EON_Stock_Technician_Name_manual_update_Template));
                         }
                    }
                    else if(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c)==null ){
                        emaillist.add(ProcessEmails_JobResults(new List<EON_Stock__c>(),objJobResult,objJobResult.New_Comms_Hub_Serial_Number__c,System.Label.EON_Stock_No_matching_serial_number_Template));
                    
                    }
                    else{
                        for(EON_Stock__c stock1: mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c)){
                         
                            if(stock1.status__c=='On Van')
                                stock1.status__c='Validation Required'; 
                            stock1.EON_Job_Results__c=objJobResult.id;  
                            lstStockToUpdate.add(stock1);           
                        }
                         emaillist.add(ProcessEmails_JobResults(mapStocks.get(objJobResult.New_Comms_Hub_Serial_Number__c),objJobResult,objJobResult.New_Comms_Hub_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                    } */    
                    //CH05 End          
                //}
                //for New IHD Serial Number
               if(objJobResult.Original_E_Meter_refitted__c!='Yes'){ //CH23
                if(objJobResult.New_IHD_Serial_Number__c !=null && objJobResult.New_IHD_Serial_Number__c !=''){
                    if(mapStocks.get(objJobResult.New_IHD_Serial_Number__c)!=null && mapStocks.get(objJobResult.New_IHD_Serial_Number__c).size()==1){
                         EON_Stock__c stock1= new EON_Stock__c();
                         stock1= ProcessStockRecords(objJobResult,mapStocks.get(objJobResult.New_IHD_Serial_Number__c));
                         lstStockToUpdate.add(stock1);
                          if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Validation Required')){
                            List<EON_Stock__c> lstStockForEmail = new List<EON_Stock__c>();
                            lstStockForEmail.add(stock1);
                            //emaillist.add(ProcessEmails_JobResults(lstStockForEmail,objJobResult,objJobResult.New_IHD_Serial_Number__c,System.Label.EON_Stock_Technician_Name_manual_update_Template));//CH27 .E001 Technician Mismatch – An email is no longer required for this exception as a reportable field has been created “EON Stock . Technician Mismatch” in a previous SR.
                         }
                    }
                    //CH22 START
                    else if(mapStocks.get(objJobResult.New_IHD_Serial_Number__c)==null ){
                           if(objJobResult.EON_Stock_Status__c!='Reviewed' /*&& objJobResult.EON_Stock_Status__c!='Email Sent'*/){//CH28
                              objJobResult.EON_Stock_Status__c='Validation Required';
                              lstJobResultsUpdate.add(objJobResult);
                             }
                         /* else if(objJobResult.EON_Stock_Status__c!='Validated By Routine'){
                          emaillist.add(ProcessEmails_JobResults(new List<EON_Stock__c>(),objJobResult,objJobResult.New_IHD_Serial_Number__c,System.Label.EON_Stock_No_matching_serial_number_Template));
                          //objJobResult.EON_Stock_Status__c='Email Sent';//CH26//CH28.commented as per SR
                          lstJobResultsUpdate.add(objJobResult);
                          }*/ //CH28. Removed E003 email
                         }   
                    //CH22 END
                    else{
                    //CH05 Start
                        List<EON_Stock__c> LstStockToMail= new list<EON_Stock__c>();
                        List<EON_Stock__c> LstStockTechMail= new list<EON_Stock__c>();
                        
                        for(EON_Stock__c stock1: mapStocks.get(objJobResult.New_IHD_Serial_Number__c)){                             
                            if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('On Van')){
                                //CH27.old.start
                                /*
                                if( stock1.Technician_Name__c != objJobResult.Technician__c ){
                                    stock1.status__c='Validation Required'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    LstStockTechMail.add(stock1);               
                                    lstStockToUpdate.add(stock1);               
                                }
                                if( stock1.Technician_Name__c == objJobResult.Technician__c ){
                                    stock1.status__c = 'Installed'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    stock1.Date_of_Installation__c= objJobResult.Job_Reference__r.Appointment_Date__c;
                                    lstStockToUpdate.add(stock1);               
                                }
                                */
                                //CH27.old.end
                                //CH27.new.start                                
                                LstStockToMail.add(stock1);
                                //Ch27.new.end  
                            }
                            //else LstStockToMail.add(stock1);
                            //CH10 Updated logic to avoid loop
                            else if(stock1!=null && stock1.status__c!=null &&stock1.status__c!='' && stock1.status__c.equalsIgnoreCase('Validation Required')){
                                if( stock1.Technician_Name__c != objJobResult.Technician__c ){
                                    LstStockTechMail.add(stock1);                            
                                }
                                if( stock1.Technician_Name__c == objJobResult.Technician__c ){
                                    stock1.status__c = 'Installed'; 
                                    stock1.EON_Job_Results__c=objJobResult.id;
                                    stock1.Date_of_Installation__c= objJobResult.Job_Reference__r.Appointment_Date__c;
                                    lstStockToUpdate.add(stock1);               
                                }
                            }
                           // else
                           // LstStockToMail.add(stock1);//CH27.old
                        }
                        //CH10.start
                        if(LstStockToMail != null && LstStockToMail.size()>1)//CH27
                            emaillist.add(ProcessEmails_JobResults(LstStockToMail,objJobResult,objJobResult.New_IHD_Serial_Number__c,System.Label.EON_Stock_More_than_one_serial_number_Template));
                            //CH10.end
                        /*if(LstStockTechMail != null && LstStockTechMail.size()>0)
                            emaillist.add(ProcessEmails_JobResults(LstStockTechMail,objJobResult,objJobResult.New_E_Meter_Serial_Number__c,System.Label.EON_Stock_Technician_Name_manual_update_Template));  */ //CH27 -E001 Technician Mismatch – An email is no longer required for this exception as a reportable field has been created “EON Stock . Technician Mismatch” in a previous SR.                      
                    //CH05 End                   
                    }               
                }
             }
                
            }
            update new List<EON_Stock__c>(lstStockToUpdate);
            insert new List<EON_Stock__c>(lstStockToInsert);
            
            if(lstJobResultsUpdate.size()>0){//CH19
              update (new List<Eon_Job_Results__c>(lstJobResultsUpdate)); 
              }           
            if(emaillist !=null && emaillist.size()>0) Messaging.sendEmail(emaillist);
        }
        catch(Exception e){
            system.debug(e.getMessage()+'---'+e.getLineNumber() );
        }
    }
        
    //CH01.Start
    /**
    EON_Stock_Reconciliation_FaultyAsset - This Method will Process the EON Stock Record based on EON_Stock_Reconciliation_Process
    **/

    public static void EON_Stock_Reconciliation_FaultyAsset(list<EON_Faulty_Asset__c> lstFaultyAssets, boolean isTrigger)
    {
        List<EON_Faulty_Asset__c> eonfult=[select id , name,Serial_Number_1__c,Serial_Number_2__c,Serial_Number_3__c,
                                Serial_Number_4__c,Job_Reference__r.Technician__c ,Job_Reference__r.Appointment_Date__c,
                                Asset_Tag_1__c,Asset_Tag_2__c,Asset_Tag_3__c,Asset_Tag_4__c,
                                Asset_Type_1__c, Asset_Type_2__c, Asset_Type_3__c, Asset_Type_4__c  
                                 from   EON_Faulty_Asset__c where id IN : lstFaultyAssets ];      
        Map<String,list<EON_Stock__c>>mapstocks= new Map<String,list<EON_Stock__c>>();
        List<EON_Stock__c>LstStockToUpdate= new list<EON_Stock__c>();
        List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>();
        set<EON_Stock__c>setstock= new set<EON_Stock__c>(); 
        
            //CH18.Start
            Set<String> lstSerialNumber = new Set<String>();
            if(!eonfult.isEmpty()){
                lstSerialNumber.add(eonfult[0].Serial_Number_1__c );
                lstSerialNumber.add(eonfult[0].Serial_Number_2__c );
                lstSerialNumber.add(eonfult[0].Serial_Number_3__c );
                lstSerialNumber.add(eonfult[0].Serial_Number_4__c );            
            }
            //CH18.End        
        
                
        //mapStocks =StockRecord(); old CH18
        mapStocks =StockRecord(lstSerialNumber); //CH18    
        try{
            for(EON_Faulty_Asset__c Eonasst: eonfult )
            {
                if(Eonasst.Serial_Number_1__c != Null && Eonasst.Serial_Number_1__c !='')
                {            
                    if( mapStocks.get(Eonasst.Serial_Number_1__c )!=Null && mapStocks.get(Eonasst.Serial_Number_1__c ).size()==1 )
                    {
                        EON_Stock__c stock = ProcessEON_StockForFaultyAsset(mapStocks.get(Eonasst.Serial_Number_1__c ),Eonasst);
                        LstStockToUpdate.add(stock);
                        if(stock!=null && stock.status__c=='Validation Required'){
                           List<EON_Stock__c> lstStockForEmail = new List<EON_Stock__c>();
                           lstStockForEmail.add(stock);
                           emaillist.add(ProcessEmails_Faultyasset(lstStockForEmail,Eonasst,Eonasst.Serial_Number_1__c ,System.Label.EON_StockvsEON_Faulty_Asset_Technician_Name_manual_update));                 
                        }
                    }
                    else if(mapStocks.get(Eonasst.Serial_Number_1__c )==Null)
                    {
                        emaillist.add(ProcessEmails_Faultyasset(new List<EON_Stock__c>(),Eonasst,Eonasst.Serial_Number_1__c ,System.Label.EON_StockvsEON_Faulty_Asset_No_matching_serial_number_Template)); 
                    }
                    //more than one match found
                    else
                    {
                        List<EON_Stock__c> LstStockToSend= new list<EON_Stock__c>();
                        for(EON_Stock__c stock1: mapStocks.get(Eonasst.Serial_Number_1__c ))
                        { //CH04 Start                          
                            if(stock1.status__c.equalsignoreCase('On Van'))
                            {
                                stock1.status__c='Faulty'; //CH07 
                                stock1.Faulty_Asset_Unique_ID__c= Eonasst.id;
                                Stock1.Date_Faulty__c=Eonasst.Job_Reference__r.Appointment_Date__c;
                                
                                //CH16.Start
                                Stock1.MUS_Asset_Tag__c = EonAsst.Asset_Tag_1__c;
                                Stock1.Faulty_Asset_Type__c = EonAsst.Asset_Type_1__c; 
                                //CH16.End 
                                
                                LstStockToUpdate.add(stock1);   
                            }
                            else LstStockToSend.add(stock1);
                            //CH04 End                                          
                        }
                        if(LstStockToSend!=null && LstStockToSend.size()>0)
                       emaillist.add(ProcessEmails_Faultyasset(LstStockToSend,Eonasst,Eonasst.Serial_Number_1__c ,System.Label.EON_StockvsEON_Faulty_Asset_More_than_one_serial_number_Template));        
                            
                    }
                }
                // Checking Serial Number 2 field for the EonFaulty asset
                if(Eonasst.Serial_Number_2__c != Null && Eonasst.Serial_Number_2__c !='')
                {            
                    if( mapStocks.get(Eonasst.Serial_Number_2__c )!=Null && mapStocks.get(Eonasst.Serial_Number_2__c ).size()==1 )
                    {
                        EON_Stock__c stock = ProcessEON_StockForFaultyAsset_SR2(mapStocks.get(Eonasst.Serial_Number_2__c ),Eonasst);
                        LstStockToUpdate.add(stock);
                        if(stock!=null && stock.status__c=='Validation Required'){
                           List<EON_Stock__c> lstStockForEmail = new List<EON_Stock__c>();
                           lstStockForEmail.add(stock);
                           emaillist.add(ProcessEmails_Faultyasset(lstStockForEmail,Eonasst,Eonasst.Serial_Number_2__c ,System.Label.EON_StockvsEON_Faulty_Asset_Technician_Name_manual_update));                        
                        }
                    }
                    else if(mapStocks.get(Eonasst.Serial_Number_2__c )==Null)
                    {
                       emaillist.add(ProcessEmails_Faultyasset(new List<EON_Stock__c>(),Eonasst,Eonasst.Serial_Number_2__c ,System.Label.EON_StockvsEON_Faulty_Asset_No_matching_serial_number_Template)); 
                    }
                    //more than one match found
                    else
                    {
                        List<EON_Stock__c> LstStockToSend= new list<EON_Stock__c>();
                        for(EON_Stock__c stock1: mapStocks.get(Eonasst.Serial_Number_2__c ))
                        { //CH04 Start
                            if(stock1.status__c.equalsignoreCase('On Van'))
                            {
                                stock1.status__c='Faulty';//CH07 
                                stock1.Faulty_Asset_Unique_ID__c= Eonasst.id;
                                Stock1.Date_Faulty__c=Eonasst.Job_Reference__r.Appointment_Date__c; 
                                //CH16.Start
                                Stock1.MUS_Asset_Tag__c = EonAsst.Asset_Tag_2__c;
                                Stock1.Faulty_Asset_Type__c = EonAsst.Asset_Type_2__c; 
                                //CH16.End                                
                                LstStockToUpdate.add(stock1);
                            }
                            else LstStockToSend.add(stock1);
                            //CH04 End                                       
                        }
                        if(LstStockToSend!=null && LstStockToSend.size()>0)
                        emaillist.add(ProcessEmails_Faultyasset(LstStockToSend,Eonasst,Eonasst.Serial_Number_2__c ,System.Label.EON_StockvsEON_Faulty_Asset_More_than_one_serial_number_Template));       
                            
                    }
                }
                // Checking Serial Number 3 field for the EonFaulty asset
                if(Eonasst.Serial_Number_3__c != Null && Eonasst.Serial_Number_3__c !='')
                {            
                    if( mapStocks.get(Eonasst.Serial_Number_3__c )!=Null && mapStocks.get(Eonasst.Serial_Number_3__c ).size()==1 )
                    {
                        EON_Stock__c stock = ProcessEON_StockForFaultyAsset_SR3(mapStocks.get(Eonasst.Serial_Number_3__c ),Eonasst);
                        LstStockToUpdate.add(stock);
                        if(stock!=null && stock.status__c=='Validation Required'){
                           List<EON_Stock__c> lstStockForEmail = new List<EON_Stock__c>();
                           lstStockForEmail.add(stock);
                           emaillist.add(ProcessEmails_Faultyasset(lstStockForEmail,Eonasst,Eonasst.Serial_Number_3__c ,System.Label.EON_StockvsEON_Faulty_Asset_Technician_Name_manual_update));                         
                        }
                    }
                    else if(mapStocks.get(Eonasst.Serial_Number_3__c )==Null)
                    {
                        emaillist.add(ProcessEmails_Faultyasset(new List<EON_Stock__c>(),Eonasst,Eonasst.Serial_Number_3__c ,System.Label.EON_StockvsEON_Faulty_Asset_No_matching_serial_number_Template)); 
                    }
                    //more than one match found
                    else
                    {
                        List<EON_Stock__c> LstStockToSend= new list<EON_Stock__c>();
                        for(EON_Stock__c stock1: mapStocks.get(Eonasst.Serial_Number_3__c ))
                        { //CH04 Start
                            if(stock1.status__c.equalsignoreCase('On Van'))
                            {
                                stock1.status__c='Faulty';//CH07 
                                stock1.Faulty_Asset_Unique_ID__c= Eonasst.id;
                                Stock1.Date_Faulty__c=Eonasst.Job_Reference__r.Appointment_Date__c; 
                                //CH16.Start
                                Stock1.MUS_Asset_Tag__c = EonAsst.Asset_Tag_3__c;
                                Stock1.Faulty_Asset_Type__c = EonAsst.Asset_Type_3__c; 
                                //CH16.End                                
                                LstStockToUpdate.add(stock1);
                            }
                            else LstStockToSend.add(stock1);             
                            //CH04 End                                          
                        }
                        if(LstStockToSend!=null && LstStockToSend.size()>0)
                        emaillist.add(ProcessEmails_Faultyasset(LstStockToSend,Eonasst,Eonasst.Serial_Number_3__c ,System.Label.EON_StockvsEON_Faulty_Asset_More_than_one_serial_number_Template));     
                            
                    }
                }
                // Checking Serial Number 4 field for the EonFaulty asset
                if(Eonasst.Serial_Number_4__c != Null && Eonasst.Serial_Number_4__c !='')
                {            
                    if( mapStocks.get(Eonasst.Serial_Number_4__c )!=Null && mapStocks.get(Eonasst.Serial_Number_4__c ).size()==1 )
                    {
                        EON_Stock__c stock = ProcessEON_StockForFaultyAsset_SR4(mapStocks.get(Eonasst.Serial_Number_4__c ),Eonasst);
                        LstStockToUpdate.add(Stock);
                        if(stock!=null && stock.status__c=='Validation Required'){
                          List<EON_Stock__c> lstStockForEmail = new List<EON_Stock__c>();
                           lstStockForEmail.add(stock);
                           emaillist.add(ProcessEmails_Faultyasset(lstStockForEmail,Eonasst,Eonasst.Serial_Number_4__c ,System.Label.EON_StockvsEON_Faulty_Asset_Technician_Name_manual_update));                       
                        }
                    }
                    else if(mapStocks.get(Eonasst.Serial_Number_4__c )==Null)
                    {
                       emaillist.add(ProcessEmails_Faultyasset(new List<EON_Stock__c>(),Eonasst,Eonasst.Serial_Number_4__c ,System.Label.EON_StockvsEON_Faulty_Asset_No_matching_serial_number_Template));                       
                    }
                    //more than one match found
                    else
                    {
                        List<EON_Stock__c> LstStockToSend= new list<EON_Stock__c>();
                        for(EON_Stock__c stock1: mapStocks.get(Eonasst.Serial_Number_4__c ))
                        {   //CH04 Start
                            if(stock1.status__c.equalsignoreCase('On Van'))
                            {
                                stock1.status__c='Faulty';//CH07 
                                stock1.Faulty_Asset_Unique_ID__c= Eonasst.id;
                                Stock1.Date_Faulty__c=Eonasst.Job_Reference__r.Appointment_Date__c; 
                                //CH16.Start
                                Stock1.MUS_Asset_Tag__c = EonAsst.Asset_Tag_4__c;
                                Stock1.Faulty_Asset_Type__c = EonAsst.Asset_Type_4__c; 
                                //CH16.End                                
                                LstStockToUpdate.add(stock1);
                            }
                            else LstStockToSend.add(stock1); 
                            //CH04 End                                      
                        }
                        if(LstStockToSend!=null && LstStockToSend.size()>0)
                         emaillist.add(ProcessEmails_Faultyasset(LstStockToSend,Eonasst,Eonasst.Serial_Number_4__c ,System.Label.EON_StockvsEON_Faulty_Asset_More_than_one_serial_number_Template));        
                            
                    }
                }
            }       
            Update LstStockToUpdate;
            if(emaillist !=null && emaillist.size()>0)
               Messaging.sendEmail(emaillist);
               system.debug('emaillist'+emaillist);
        }catch(Exception e){} 
    } 
       
    /**
        ProcessEON_StockForFaultyAsset(List<EON_Stock__c> StockFaulty,EON_Faulty_Asset__c Eonasst)- This method will return instance EON_Stock__c after processing as per conditions
    **/
   
    public static EON_Stock__c ProcessEON_StockForFaultyAsset(List<EON_Stock__c> StockFaulty,EON_Faulty_Asset__c Eonasst){
        if(StockFaulty!= Null &&  Eonasst.Job_Reference__r.Technician__c == StockFaulty[0].Technician_Name__c)
        {
               StockFaulty[0].Status__c= 'Faulty';
               StockFaulty[0].Faulty_Asset_Unique_ID__c=Eonasst.id;
               StockFaulty[0].Date_Faulty__c=Eonasst.Job_Reference__r.Appointment_Date__c;
               //CH16.Start
               StockFaulty[0].MUS_Asset_Tag__c = EonAsst.Asset_Tag_1__c;
               StockFaulty[0].Faulty_Asset_Type__c = EonAsst.Asset_Type_1__c;               
               //CH16.End
               return StockFaulty[0];
        }
        else
        {
               StockFaulty[0].Status__c = 'Validation Required';
               StockFaulty[0].Faulty_Asset_Unique_ID__c = Eonasst.id;
               return StockFaulty[0];
        }
        
    }      
    //CH01.End
    
    //CH16.Start
    /**
        ProcessEON_StockForFaultyAsset_SR2(List<EON_Stock__c> StockFaulty,EON_Faulty_Asset__c Eonasst)- This method will return instance EON_Stock__c after processing as per conditions
    **/
   
    public static EON_Stock__c ProcessEON_StockForFaultyAsset_SR2(List<EON_Stock__c> StockFaulty,EON_Faulty_Asset__c Eonasst){
        if(StockFaulty!= Null &&  Eonasst.Job_Reference__r.Technician__c == StockFaulty[0].Technician_Name__c)
        {
               StockFaulty[0].Status__c= 'Faulty';
               StockFaulty[0].Faulty_Asset_Unique_ID__c=Eonasst.id;
               StockFaulty[0].Date_Faulty__c=Eonasst.Job_Reference__r.Appointment_Date__c;
               StockFaulty[0].MUS_Asset_Tag__c = EonAsst.Asset_Tag_2__c;
               StockFaulty[0].Faulty_Asset_Type__c = EonAsst.Asset_Type_2__c;
               return StockFaulty[0];
        }
        else
        {
               StockFaulty[0].Status__c = 'Validation Required';
               StockFaulty[0].Faulty_Asset_Unique_ID__c = Eonasst.id;
               return StockFaulty[0];
        }
        
    }     

    /**
        ProcessEON_StockForFaultyAsset_SR3(List<EON_Stock__c> StockFaulty,EON_Faulty_Asset__c Eonasst)- This method will return instance EON_Stock__c after processing as per conditions
    **/
   
    public static EON_Stock__c ProcessEON_StockForFaultyAsset_SR3(List<EON_Stock__c> StockFaulty,EON_Faulty_Asset__c Eonasst){
        if(StockFaulty!= Null &&  Eonasst.Job_Reference__r.Technician__c == StockFaulty[0].Technician_Name__c)
        {
               StockFaulty[0].Status__c= 'Faulty';
               StockFaulty[0].Faulty_Asset_Unique_ID__c=Eonasst.id;
               StockFaulty[0].Date_Faulty__c=Eonasst.Job_Reference__r.Appointment_Date__c;
               StockFaulty[0].MUS_Asset_Tag__c = EonAsst.Asset_Tag_3__c;
               StockFaulty[0].Faulty_Asset_Type__c = EonAsst.Asset_Type_3__c;
               return StockFaulty[0];
        }
        else
        {
               StockFaulty[0].Status__c = 'Validation Required';
               StockFaulty[0].Faulty_Asset_Unique_ID__c = Eonasst.id;
               return StockFaulty[0];
        }
        
    }     

    /**
        ProcessEON_StockForFaultyAsset_SR4(List<EON_Stock__c> StockFaulty,EON_Faulty_Asset__c Eonasst)- This method will return instance EON_Stock__c after processing as per conditions
    **/
   
    public static EON_Stock__c ProcessEON_StockForFaultyAsset_SR4(List<EON_Stock__c> StockFaulty,EON_Faulty_Asset__c Eonasst){
        if(StockFaulty!= Null &&  Eonasst.Job_Reference__r.Technician__c == StockFaulty[0].Technician_Name__c)
        {
               StockFaulty[0].Status__c= 'Faulty';
               StockFaulty[0].Faulty_Asset_Unique_ID__c=Eonasst.id;
               StockFaulty[0].Date_Faulty__c=Eonasst.Job_Reference__r.Appointment_Date__c;
               StockFaulty[0].MUS_Asset_Tag__c = EonAsst.Asset_Tag_4__c;
               StockFaulty[0].Faulty_Asset_Type__c = EonAsst.Asset_Type_4__c;
               return StockFaulty[0];
        }
        else
        {
               StockFaulty[0].Status__c = 'Validation Required';
               StockFaulty[0].Faulty_Asset_Unique_ID__c = Eonasst.id;
               return StockFaulty[0];
        }
        
    }     
    //CH16.end        
    
    
    /**
        CreateStockRecords(EON_Job_Results__c objJobResult,  String serialNumber)- This method will return instance EON_Stock__c 
    **/
    public static EON_Stock__c CreateStockRecords(EON_Job_Results__c objJobResult, String serialNumber){
            EON_Stock__c stock = new EON_Stock__c();
            stock.Serial_Number__c=serialNumber;
            //stock.Date_Off_Circuit__c=objJobResult.Job_Reference__r.Appointment_Date__c;//CH26.Updated Date_Removed__c to Date_Off_Circuit__c
            stock.Date_Off_Circuit__c=Date.valueOf(objJobResult.Time_On_Site__c);//CH26.New
            stock.Technician_Name__c=objJobResult.Technician__c;
            stock.EON_Job_Results__c=objJobResult.id;
            stock.Status__c='Off-Circuit';
            return stock;
    }
    
    /**
        ProcessStockRecords(EON_Job_Results__c objJobResult,List<EON_Stock__c> lststocks)- This method will return instance EON_Stock__c after processing as per conditions
    **/
    
    public static EON_Stock__c ProcessStockRecords(EON_Job_Results__c objJobResult,List<EON_Stock__c> lststocks){
        if(lststocks!=null && lststocks.size()==1){
        //CH27.old.start
        /*
            if(lststocks[0].Technician_Name__c==objJobResult.Technician__c){
                lststocks[0].Status__c='Installed';
                lststocks[0].EON_Job_Results__c=objJobResult.id;
                lststocks[0].Date_of_Installation__c=objJobResult.Job_Reference__r.Appointment_Date__c;
                system.debug('stock to update'+lststocks[0]);
                return lststocks[0];
                
            }
            else{
                lststocks[0].Status__c='Validation Required';
                lststocks[0].EON_Job_Results__c=objJobResult.id;
                system.debug('stock to update with validation'+lststocks[0]);
                return lststocks[0];
                
            
            }*/
        //CH27.old.end
        //CH27.start
        if(lststocks[0].Technician_Name__c!=objJobResult.Technician__c) lststocks[0].Technician_Mismatch__c=true;
        lststocks[0].Status__c='Installed';
        lststocks[0].Technician_Name__c=objJobResult.Technician__c;//CH29
        lststocks[0].EON_Job_Results__c=objJobResult.id;
        lststocks[0].Date_of_Installation__c=Date.valueOf(objJobResult.Time_On_Site__c);
        system.debug('stock to update'+lststocks[0]);
        return lststocks[0];
        //CH27.end       
        }
        return null;
    }
        
    /**
        ProcessEmails_JobResults(List<EON_Stock__c> stocks,EON_Job_Results__c objJobResult,String SerialNum,String TempName) - This method will return instance of mail generated based on conditioons 
    **/

    public static Messaging.SingleEmailMessage ProcessEmails_JobResults(List<EON_Stock__c> stocks,EON_Job_Results__c objJobResult,String SerialNum,String TempName)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo=System.Label.EON_Stock_Reconciliation_email.split(';');
        if(sendTo!=null)
            mail.setToAddresses(sendTo);
        mail.setToAddresses(sendTo);
        EmailTemplate et=[select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName =: TempName limit 1 ];
        mail.setSaveAsActivity(false);
        String Subject= et.Subject;
        String htmlBody = et.HtmlValue;
        String plainBody = et.Body;
        //CH27.start
       /* if(TempName==System.Label.EON_Stock_Technician_Name_manual_update_Template){
            htmlBody= htmlBody.replace('{!EON_Stock__c.Serial_Number__c}',stocks[0].Serial_Number__c);
            String recordURL = EON_Utility.getInstanceURL() +'/'+objJobResult.id; //CH17
            String recordURLStock = EON_Utility.getInstanceURL() +'/'+stocks[0].id;    //CH05 ////CH17
            htmlBody= htmlBody.replace('{!EON_Stock__c.Id.Link}','<a href='+recordURLStock+'>'+recordURLStock+'</a>');    //CH05             
            htmlBody= htmlBody.replace('{!EON_Stock__c.EON_Job_Results__c}','<a href='+recordURL+'>'+recordURL+'</a>'); //CH05               
            htmlBody= htmlBody.replace('{!EON_Stock__c.Technician_Name__c}','<a href='+recordURL+'>'+recordURL+'</a>'); 
            plainBody = plainBody.replace('{!EON_Stock__c.Serial_Number__c}',stocks[0].Serial_Number__c);
            plainBody = plainBody.replace('{!EON_Stock__c.Technician_Name__c}','<a href='+recordURL+'>'+recordURL+'</a>');              
            plainBody = plainBody.replace('{!EON_Stock__c.Id.Link}','<a href='+recordURLStock+'>'+recordURLStock+'</a>'); 
            plainBody = plainBody.replace('{!EON_Stock__c.EON_Job_Results__c}','<a href='+recordURL+'>'+recordURL+'</a>');//CH05                
        }*/ //CH27.end - E001 Technician Mismatch – An email is no longer required for this exception as a reportable field has been created “EON Stock . Technician Mismatch” in a previous SR.
        if(TempName==System.Label.EON_Stock_No_matching_serial_number_Template){
            htmlBody= htmlBody.replace('{!missing serial number field}',SerialNum);
            String recordURL = EON_Utility.getInstanceURL() +'/'+objJobResult.id; //CH17
            htmlBody= htmlBody.replace('{!EON Jobs Results salesforce link}','<a href='+recordURL+'>'+recordURL+'</a><br/>'); 
            plainBody = plainBody.replace('{!missing serial number field}',SerialNum);
            plainBody = plainBody.replace('{!EON Jobs Results salesforce link}','<a href='+recordURL+'>'+recordURL+'</a><br/>');              
        }
       if(TempName==System.Label.EON_Stock_More_than_one_serial_number_Template){
            htmlBody= htmlBody.replace('{!EON_Stock__c.Serial_Number__c}',stocks[0].Serial_Number__c);           
            String recordURLJob = EON_Utility.getInstanceURL() +'/'+objJobResult.id; //CH05 //CH17
            htmlBody= htmlBody.replace('{!EON_Stock__c.EON_Job_Results__c}','<a href='+recordURLJob+'>'+recordURLJob+'</a>'); //CH05                               
            plainBody = plainBody.replace('{!EON_Stock__c.Serial_Number__c}',stocks[0].Serial_Number__c);
            String linkurl='';
            for(EON_Stock__c stock :  stocks){
                String recordURL = EON_Utility.getInstanceURL() +'/'+stock.id; //CH17
                linkurl+='<a href='+recordURL+'>'+recordURL+'</a><br/>';
                linkurl+='<br/>';
            }
            htmlBody= htmlBody.replace('{List of EON Stock Records}',linkurl);
            plainBody = plainBody.replace('{List of EON Stock Records}',linkurl);          
        }
        //For Aborted EON job //CH05 Start
        if(TempName==System.Label.EON_Job_Results_Aborted){
            String recordURL = EON_Utility.getInstanceURL() +'/'+objJobResult.id; //CH17
            htmlBody= htmlBody.replace('{!EON Jobs Results salesforce link}','<a href='+recordURL+'>'+recordURL+'</a><br/>'); 
            plainBody = plainBody.replace('{!EON Jobs Results salesforce link}','<a href='+recordURL+'>'+recordURL+'</a><br/>');              
        } //CH05 End          
        mail.setSubject(Subject);
        mail.setHtmlBody(htmlBody);
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody(plainBody);
        system.debug('Mail---->'+mail);
        return mail;
    }
    //CH01.start
    /**
        ProcessEmails_Faultyasset(List<EON_Stock__c> stocks,EON_Faulty_Asset__c FaultyAsset,String SerialNum,String TempName) - This method will return instance of mail generated based on conditioons 
    **/
    
    public static Messaging.SingleEmailMessage ProcessEmails_Faultyasset(List<EON_Stock__c> stocks,EON_Faulty_Asset__c FaultyAsset,String SerialNum,String TempName)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(System.Label.EON_Stock_Reconciliation_email);
        if(sendTo!=null)
            mail.setToAddresses(sendTo);
        mail.setToAddresses(sendTo);
        EmailTemplate et=[select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName =: TempName limit 1 ];
        mail.setSaveAsActivity(false);
        String Subject= et.Subject;
        String htmlBody = et.HtmlValue;
        String plainBody = et.Body;
        if(TempName==System.Label.EON_StockvsEON_Faulty_Asset_Technician_Name_manual_update){
            htmlBody= htmlBody.replace('{!EON_Stock__c.Serial_Number__c}',stocks[0].Serial_Number__c);
            String recordURLFaulty = EON_Utility.getInstanceURL() +'/'+FaultyAsset.id;//CH04 //CH17
            String recordURLStock = EON_Utility.getInstanceURL() +'/'+stocks[0].id; //CH17
            htmlBody= htmlBody.replace('{!EON_Stock__c.Id.Link}','<a href='+recordURLStock+'>'+recordURLStock+'</a>'); 
            htmlBody= htmlBody.replace('{!EON_Stock__c.Faulty_Asset_Unique_ID__c}','<a href='+recordURLFaulty+'>'+recordURLFaulty+'</a>'); //CH04
            plainBody = plainBody.replace('{!EON_Stock__c.Serial_Number__c}',stocks[0].Serial_Number__c);
            plainBody = plainBody.replace('{!EON_Stock__c.Id.Link}','<a href='+recordURLStock+'>'+recordURLStock+'</a>'); 
            plainBody = plainBody.replace('{!EON_Stock__c.Faulty_Asset_Unique_ID__c}','<a href='+recordURLFaulty+'>'+recordURLFaulty+'</a>');//CH04
            
        }
        if(TempName==System.Label.EON_StockvsEON_Faulty_Asset_No_matching_serial_number_Template){
            htmlBody= htmlBody.replace('{!EON_Stock__c.Serial_Number__c}',SerialNum);
            String recordURL = EON_Utility.getInstanceURL() +'/'+FaultyAsset.id; //CH17
            htmlBody= htmlBody.replace('{!EON_Stock__c.Faulty_Asset_Unique_IDId__c}','<a href='+recordURL+'>'+recordURL+'</a><br/>'); 
            plainBody = plainBody.replace('{!EON_Stock__c.Serial_Number__c}',SerialNum);
            plainBody = plainBody.replace('{!EON_Stock__c.Faulty_Asset_Unique_IDId__c}','<a href='+recordURL+'>'+recordURL+'</a><br/>');              
        }
        if(TempName==System.Label.EON_StockvsEON_Faulty_Asset_More_than_one_serial_number_Template){              
            htmlBody= htmlBody.replace('{!EON_Stock__c.Serial_Number__c}',stocks[0].Serial_Number__c);
            String recordURLFaulty = EON_Utility.getInstanceURL() +'/'+FaultyAsset.id;//CH04 //CH17
            htmlBody= htmlBody.replace('{!EON_Stock__c.Faulty_Asset_Unique_ID__c}','<a href='+recordURLFaulty+'>'+recordURLFaulty+'</a>'); //CH04                
            plainBody = plainBody.replace('{!EON_Stock__c.Serial_Number__c}',stocks[0].Serial_Number__c);
            String linkurl='';
            for(EON_Stock__c stock :  stocks){
                if(!stock.status__c.equalsIgnoreCase('On Van')){ //CH04
                    String recordURL = EON_Utility.getInstanceURL() +'/'+stock.id; //CH17
                    linkurl+='<a href='+recordURL+'>'+recordURL+'</a><br/>';
                    linkurl+='<br/>';
                }
            }
            htmlBody= htmlBody.replace('{!List_Of_Eon_Stocks}',linkurl);
            plainBody = plainBody.replace('{!List_Of_Eon_Stocks}',linkurl);          
        }
        mail.setSubject(Subject);
        mail.setHtmlBody(htmlBody);
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody(plainBody);
        system.debug('Mail---->'+mail);
        return mail;
    }
    //CH01.end
    /**
        StockRecord() - This method will return Map<Serial number,List<EON_Stock__c>> to access in both the methods 
    **/
     //public static Map<String,List<EON_Stock__c>> StockRecord(){
     public static Map<String,List<EON_Stock__c>> StockRecord(Set<String> lstSerialNumber){ //CH17
       Map<String,List<EON_Stock__c>> mapStocks= new Map<String,List<EON_Stock__c>>();
       List<EON_Stock__c> lstStock1 = new List<EON_Stock__c>();
       lstStock1 =[SELECT Asset_Type__c,Technician_Mismatch__c,CreatedById,CreatedDate,Date_Faulty__c,Date_of_Dispatch__c,Date_of_Installation__c,Date_Returned_Received__c,//EON_Holding_Serialised_Asset_Unique_ID__c,//CH15
       EON_Job_Results__c,Faulty_Asset_Unique_ID__c,Id,IsDeleted,Job_Reference__c,KID__c,Manufacture__c,Model__c,Name,Order_Reference__c,Product_Code__c,Serial_Number__c,Status__c,SystemModstamp,Technician_Name__c FROM EON_Stock__c
       where Serial_Number__c in : lstSerialNumber and Status__c='On Van' //CH18 // CH29 Added 'on van' to SOQL
       ];
        for(EON_Stock__c objStock:lstStock1){
            if(!mapStocks.containsKey(objStock.Serial_Number__c))
                        mapStocks.put(objStock.Serial_Number__c, new List<EON_Stock__c>());
            mapStocks.get(objStock.Serial_Number__c).add(objStock);
        }
       return mapStocks;
    }
    
    
    //CH25.start
     /**
     newStockRecord(string lstSerialNumber) - This method will return Map<Serial number,List<EON_Stock__c>>
     **/
     public static Map<String,List<EON_Stock__c>> newStockRecord(string lstSerialNumber){
       DateTime stockDate = Datetime.valueOf(system.label.EON_Stock_Consideration_Date);
       Map<String,List<EON_Stock__c>> mapStocks= new Map<String,List<EON_Stock__c>>();
       List<EON_Stock__c> lstStock1 = new List<EON_Stock__c>();
       lstStock1 =[SELECT Asset_Type__c,CreatedById,Technician_Mismatch__c,CreatedDate,Date_Faulty__c,Date_of_Dispatch__c,Date_of_Installation__c,Date_Returned_Received__c,
                   EON_Job_Results__c,Faulty_Asset_Unique_ID__c,Id,IsDeleted,Job_Reference__c,KID__c,Manufacture__c,Model__c,Name,Order_Reference__c,
                   Product_Code__c,Serial_Number__c,Status__c,SystemModstamp,Technician_Name__c FROM EON_Stock__c where Serial_Number__c = :lstSerialNumber and CreatedDate > :stockDate and Status__c='On Van']; // CH29 Added on van to SOQL
       System.debug('debug Shruti-->'+lstStock1);
        for(EON_Stock__c objStock:lstStock1){
            if(!mapStocks.containsKey(objStock.Serial_Number__c))
                mapStocks.put(objStock.Serial_Number__c, new List<EON_Stock__c>());
            mapStocks.get(objStock.Serial_Number__c).add(objStock);
        }
        System.debug('debug Shruti-->'+mapStocks);
       return mapStocks;
    }
    //CH25.End
    
    
    //CH012.start
    /**
       EON_Stock_Reconciliation_JobResults(): This method will call the Stock_Reconciliation_Process based on the conditions
    **/
    public static void processJobResults(List<EON_Job_Results__c> newJobResultslst,Map<id,EON_Job_Results__c> OldJobResultsMap){
        List<EON_Job_Results__c> allJobResults = new List<EON_Job_Results__c>();
        for(EON_Job_Results__c JobResult : newJobResultslst){
            if((JobResult.New_E_Meter_Serial_Number__c !=null && JobResult.New_E_Meter_Serial_Number__c!='' && JobResult.New_E_Meter_Serial_Number__c != OldJobResultsMap.get(JobResult.id).New_E_Meter_Serial_Number__c) || (JobResult.New_G_Meter_Serial_Number__c !=null && JobResult.New_G_Meter_Serial_Number__c!='' && JobResult.New_G_Meter_Serial_Number__c != OldJobResultsMap.get(JobResult.id).New_G_Meter_Serial_Number__c) || (JobResult.New_Gas_Regulator_Serial_Number__c!=null && JobResult.New_Gas_Regulator_Serial_Number__c!=''&& JobResult.New_Gas_Regulator_Serial_Number__c != OldJobResultsMap.get(JobResult.id).New_Gas_Regulator_Serial_Number__c) || (JobResult.New_IHD_Serial_Number__c!=null && JobResult.New_IHD_Serial_Number__c!='' && JobResult.New_IHD_Serial_Number__c != OldJobResultsMap.get(JobResult.id).New_IHD_Serial_Number__c) || (JobResult.Installed_Cradle_Serial_Number__c!=null && JobResult.Installed_Cradle_Serial_Number__c!='' && JobResult.Installed_Cradle_Serial_Number__c != OldJobResultsMap.get(JobResult.id).Installed_Cradle_Serial_Number__c) || (JobResult.Installed_Hot_Shoe_Serial_Number__c !=null && JobResult.Installed_Hot_Shoe_Serial_Number__c !='' && JobResult.Installed_Hot_Shoe_Serial_Number__c  != OldJobResultsMap.get(JobResult.id).Installed_Hot_Shoe_Serial_Number__c ) || (JobResult.New_Comms_Hub_Serial_Number__c !=null && JobResult.New_Comms_Hub_Serial_Number__c !='' && JobResult.New_Comms_Hub_Serial_Number__c  != OldJobResultsMap.get(JobResult.id).New_Comms_Hub_Serial_Number__c ) || (JobResult.EON_Stock_Status__c!=null && JobResult.EON_Stock_Status__c!='' && JobResult.EON_Stock_Status__c != OldJobResultsMap.get(JobResult.id).EON_Stock_Status__c &&  JobResult.EON_Stock_Status__c!='Validation Required'))//CH19//CH28 added Validation Required to avoid two email getting triggered
              allJobResults.add(JobResult);
        }
        if(allJobResults.size()>0)
            EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_JobResults(allJobResults,false ,new Map<id,EON_Job_Results__c>());                       
    }
    //CH012.end
}