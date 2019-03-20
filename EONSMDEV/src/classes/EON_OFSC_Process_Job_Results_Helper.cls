/**
    Description : This class is used to process the job resutls and triggered from EON_OFSC_Receiving_Helper class.
    VF Page :
    Test Class : EON_OFSC_Receiving_Helper_Test
**/

/*
    Created By : Praveen G
    Created Date : 11-May-2016
    Service Request : SR_EON_Mobile_035
    CH01 # SR_EON_Mobile_082 # 23/09/2016 # Mahadev J # Change data type for field 'E_Meter_Certification_Date__c', 'E_Meter_Exchange_Date__c', 'Uxp_G_Meter_Exchange_Date__c' from 'Date'
    CH02 # SR_EON_Mobile_095 # 10/11/2016 # Praveen G # Added new date field for not done job results.
    CH03 # SR_EON_Mobile_096 # 11/11/2016 # Praveen G # converted value for the Abort Category field.
    CH04 # SR_EON_Mobile_118 # 28/02/2017 # Praveen G # Added mapping for couple of number fields.
    CH05 # SR_EON_OFSC_025 # 10/11/2017 # Praveen G # Added mapping for 3 new filds as logic involved for these.
    CH06 # SR_EON_OFSC_032 # 24/05/2018 # Shruti Moghe # Added mapping for new filds as logic involved for these.
    
*/

public with sharing class EON_OFSC_Process_Job_Results_Helper{

    /**
        processJobResults(Map<String, String> mapRequest, id appointmentID)
             - This method is used to process Job resutls and add a new record in EON Job Results object
    **/
    public static void processJobResults(Map<String, String> mapRequest, id appointmentID){

        //For Text fields.
        Map<String, String> mapAPIwithNode = EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTag();
        EON_Job_Results__c jobResult = new EON_Job_Results__c();
        jobResult.Job_Reference__c = appointmentID;

        for(String fieldAPIName : mapAPIwithNode.keySet()){          
            jobResult.put(fieldAPIName , mapRequest.get(mapAPIwithNode.get(fieldAPIName)));
        }
        
        //For Number Fields
        Map<String, String> mapAPIwithNodeNum = EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTagForNumbers();
        for(String fieldAPIName : mapAPIwithNodeNum.keySet()){
            jobResult.put(fieldAPIName , EON_Utility.convertStringToDecimal(mapRequest.get(mapAPIwithNodeNum.get(fieldAPIName))));
        } 
        
        //For Lookup Fields - EON Electric Meter Register
        Map<String, String> mapAPIwithNodeLookup = EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTagForLookup();
        Map<String, String> mapLookupNameId = EON_OFSC_JobResults_Wrapper.getEONElectricMeterRegisterMap();        
        for(String fieldAPIName : mapAPIwithNodeLookup.keySet()){
            jobResult.put(fieldAPIName , mapLookupNameId.get(mapRequest.get(mapAPIwithNodeLookup.get(fieldAPIName))));
        }  
        
        //For Date Fields
        Map<String, String> mapAPIwithNodeDate = EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTagForDate();
        for(String fieldAPIName : mapAPIwithNodeDate.keySet()){
            if(mapRequest.get(mapAPIwithNodeDate.get(fieldAPIName)) != null && mapRequest.get(mapAPIwithNodeDate.get(fieldAPIName)) != ''){
                //jobResult.put(fieldAPIName , Date.valueOf(mapRequest.get(mapAPIwithNodeDate.get(fieldAPIName)))); //CH01.Old
                //CH01.New.Start
                String formatDate = mapRequest.get(mapAPIwithNodeDate.get(fieldAPIName));
                String specialChars = '.|-|/|:|@|;|*|,';
                for(integer i=0; i<specialChars.split('|').size(); i++)
                    formatDate = formatDate.replace(specialChars.split('|')[i], '');
                jobResult.put(fieldAPIName , formatDate);
                //CH01.New.End
            }
        }                         
        
        //For Technician 
        jobResult.put('Technician__c', mapRequest.get('tech_number'));     
        
        //DateTime Field Time_On_Site__c
        String updateDate = mapRequest.get('update_date');
        String TimeOnSite = mapRequest.get('start_time');
                   
        if(updateDate != null && TimeOnSite != null){
            DateTime completeDateTime = Datetime.valueOf(updateDate + ' ' + TimeOnSite + ':00');   
            jobResult.put('Time_On_Site__c' , completeDateTime);  
        }
        
        //DateTime field Time_Closed__c for Complete Appointment
        String TimeClosed = mapRequest.get('end_time');
        if(updateDate != null && TimeClosed != null){
            DateTime CloseDateTime = Datetime.valueOf(updateDate + ' ' + TimeClosed + ':00');   
            jobResult.put('Time_Closed__c' , CloseDateTime);  
        }
        
        //CH02.Start  DateTime field Time_Closed__c for Not Done Appointment
        String notDoneTime = mapRequest.get('notdone_time');
                   
        if(updateDate != null && notDoneTime != null){
            DateTime notDoneDateTime = Datetime.valueOf(updateDate + ' ' + notDoneTime + ':00');   
            jobResult.put('Time_Closed__c' , notDoneDateTime);  
        }            
        //CH02.End 
        
        //CH03.Start
        if(mapRequest.get('abort_category') != null && mapRequest.get('abort_category') == '4. Gas checks details')
            jobResult.Abort_Category__c = '4. Gas check details';
        //CH03.End
        
        //CH04.Start
        if(mapRequest.get('variations_2or4_pole_isotr') != null && mapRequest.get('variations_no_isotr') != null){
            if(mapRequest.get('variations_2or4_pole_isotr').trim() == '2'){
               jobResult.X2_Pole_Isolators_fitted__c =  Integer.valueOf(mapRequest.get('variations_no_isotr')) ;
            }else if(mapRequest.get('variations_2or4_pole_isotr').trim() == '4'){
                jobResult.X4_Pole_Isolators_fitted__c = Integer.valueOf(mapRequest.get('variations_no_isotr'));
            }
        }
        //CH04.End
        
        System.debug('*********mapRequest.get ' + mapRequest.get('abort_subreason_description'));
        System.debug('*********jobResult.Abort_Sub_Reason__c ' + jobResult.Abort_Sub_Reason__c);
        
        //CH05.Start
        if(jobResult.get('New_E_Meter_Manufacturer__c') == null || jobResult.get('New_E_Meter_Manufacturer__c') == '')
            jobResult.put('New_E_Meter_Manufacturer__c', mapRequest.get('asset_e_smart_make_new'));
        if(jobResult.get('New_E_Meter_Version__c') == null || jobResult.get('New_E_Meter_Version__c') == '')
            jobResult.put('New_E_Meter_Version__c', mapRequest.get('asset_e_smart_model_new')); 
        if(jobResult.get('New_G_Meter_Version__c') == null || jobResult.get('New_G_Meter_Version__c') == '')
            jobResult.put('New_G_Meter_Version__c', mapRequest.get('asset_g_smart_model_new'));
        //CH05.End
                                            
        insert jobResult; 
                      
        //Create Fault Asset record for the appointment only if 'faulty_assets_asset_type_1' tag has a value.
        if(mapRequest!= null && mapRequest.get('faulty_assets_asset_type_1') != null)
            processJobResultsForFaultAssets(mapRequest, appointmentID); 
        //CH06.start
        List<EON_Failed_Asset__c> FailedAssetList= new List<EON_Failed_Asset__c>();
        if(mapRequest.get('Failed_Asset_Type_1') != null ){
            EON_Failed_Asset__c failedAsset1 = new EON_Failed_Asset__c();
            failedAsset1.EON_Job_Results__c= jobResult.id;
            failedAsset1.Failed_Asset_Type__c=mapRequest.get('Failed_Asset_Type_1') ;
            if(mapRequest.get('Failed_Asset_Serial_Number_1') != null ) failedAsset1.Failed_Asset_Serial_Number__c=mapRequest.get('Failed_Asset_Serial_Number_1') ;
            if(mapRequest.get('Failure_Reason_1') != null ) failedAsset1.Failure_Reason__c=mapRequest.get('Failure_Reason_1') ;
            if(mapRequest.get('Fault_Code_1') != null ) failedAsset1.Fault_Code__c=mapRequest.get('Fault_Code_1') ;
            if(mapRequest.get('Failed_Asset_Left_Paired_to_Device_1') != null ) failedAsset1.Failed_Asset_Left_Paired_to_Device__c=mapRequest.get('Failed_Asset_Left_Paired_to_Device_1') ;
            if(mapRequest.get('Failed_Asset_Notes_1') != null ) failedAsset1.Failed_Asset_Notes__c=mapRequest.get('Failed_Asset_Notes_1') ;
            FailedAssetList.add(failedAsset1);
        }
        if(mapRequest.get('Failed_Asset_Type_2') != null ){
            EON_Failed_Asset__c failedAsset2 = new EON_Failed_Asset__c();
            failedAsset2.EON_Job_Results__c= jobResult.id;
            failedAsset2.Failed_Asset_Type__c=mapRequest.get('Failed_Asset_Type_2') ;
            if(mapRequest.get('Failed_Asset_Serial_Number_2') != null ) failedAsset2.Failed_Asset_Serial_Number__c=mapRequest.get('Failed_Asset_Serial_Number_2') ;
            if(mapRequest.get('Failure_Reason_2') != null ) failedAsset2.Failure_Reason__c=mapRequest.get('Failure_Reason_2') ;
            if(mapRequest.get('Fault_Code_2') != null ) failedAsset2.Fault_Code__c=mapRequest.get('Fault_Code_2') ;
            if(mapRequest.get('Failed_Asset_Left_Paired_to_Device_2') != null ) failedAsset2.Failed_Asset_Left_Paired_to_Device__c=mapRequest.get('Failed_Asset_Left_Paired_to_Device_2') ;
            if(mapRequest.get('Failed_Asset_Notes_2') != null ) failedAsset2.Failed_Asset_Notes__c=mapRequest.get('Failed_Asset_Notes_2') ;
            FailedAssetList.add(failedAsset2);  
        }
        if(mapRequest.get('Failed_Asset_Type_3') != null ){
            EON_Failed_Asset__c failedAsset3 = new EON_Failed_Asset__c();
            failedAsset3.EON_Job_Results__c= jobResult.id;
            failedAsset3.Failed_Asset_Type__c=mapRequest.get('Failed_Asset_Type_3') ;
            if(mapRequest.get('Failed_Asset_Serial_Number_3') != null ) failedAsset3.Failed_Asset_Serial_Number__c=mapRequest.get('Failed_Asset_Serial_Number_3') ;
            if(mapRequest.get('Failure_Reason_3') != null ) failedAsset3.Failure_Reason__c=mapRequest.get('Failure_Reason_3') ;
            if(mapRequest.get('Fault_Code_3') != null ) failedAsset3.Fault_Code__c=mapRequest.get('Fault_Code_3') ;
            if(mapRequest.get('Failed_Asset_Left_Paired_to_Device_3') != null ) failedAsset3.Failed_Asset_Left_Paired_to_Device__c=mapRequest.get('Failed_Asset_Left_Paired_to_Device_3') ;
            if(mapRequest.get('Failed_Asset_Notes_3') != null ) failedAsset3.Failed_Asset_Notes__c=mapRequest.get('Failed_Asset_Notes_3') ;
            FailedAssetList.add(failedAsset3);  
        }
        if(mapRequest.get('Failed_Asset_Type_4') != null ){
            EON_Failed_Asset__c failedAsset4 = new EON_Failed_Asset__c();
            failedAsset4.EON_Job_Results__c= jobResult.id;
            failedAsset4.Failed_Asset_Type__c=mapRequest.get('Failed_Asset_Type_4') ;
            if(mapRequest.get('Failed_Asset_Serial_Number_4') != null ) failedAsset4.Failed_Asset_Serial_Number__c=mapRequest.get('Failed_Asset_Serial_Number_4') ;
            if(mapRequest.get('Failure_Reason_4') != null ) failedAsset4.Failure_Reason__c=mapRequest.get('Failure_Reason_4') ;
            if(mapRequest.get('Fault_Code_4') != null ) failedAsset4.Fault_Code__c=mapRequest.get('Fault_Code_4') ;
            if(mapRequest.get('Failed_Asset_Left_Paired_to_Device_4') != null ) failedAsset4.Failed_Asset_Left_Paired_to_Device__c=mapRequest.get('Failed_Asset_Left_Paired_to_Device_4') ;
            if(mapRequest.get('Failed_Asset_Notes_4') != null ) failedAsset4.Failed_Asset_Notes__c=mapRequest.get('Failed_Asset_Notes_4') ;
            FailedAssetList.add(failedAsset4);  
        }
        if(mapRequest.get('Failed_Asset_Type_5') != null ){
            EON_Failed_Asset__c failedAsset5 = new EON_Failed_Asset__c();
            failedAsset5.EON_Job_Results__c= jobResult.id;
            failedAsset5.Failed_Asset_Type__c=mapRequest.get('Failed_Asset_Type_5') ;
            if(mapRequest.get('Failed_Asset_Serial_Number_5') != null ) failedAsset5.Failed_Asset_Serial_Number__c=mapRequest.get('Failed_Asset_Serial_Number_5') ;
            if(mapRequest.get('Failure_Reason_5') != null ) failedAsset5.Failure_Reason__c=mapRequest.get('Failure_Reason_5') ;
            if(mapRequest.get('Fault_Code_5') != null ) failedAsset5.Fault_Code__c=mapRequest.get('Fault_Code_5') ;
            if(mapRequest.get('Failed_Asset_Left_Paired_to_Device_5') != null ) failedAsset5.Failed_Asset_Left_Paired_to_Device__c=mapRequest.get('Failed_Asset_Left_Paired_to_Device_5') ;
            if(mapRequest.get('Failed_Asset_Notes_5') != null ) failedAsset5.Failed_Asset_Notes__c=mapRequest.get('Failed_Asset_Notes_5') ;
            FailedAssetList.add(failedAsset5);  
        }
        if(mapRequest.get('Failed_Asset_Type_6') != null ){
            EON_Failed_Asset__c failedAsset6 = new EON_Failed_Asset__c();
            failedAsset6.EON_Job_Results__c= jobResult.id;
            failedAsset6.Failed_Asset_Type__c=mapRequest.get('Failed_Asset_Type_6') ;
            if(mapRequest.get('Failed_Asset_Serial_Number_6') != null ) failedAsset6.Failed_Asset_Serial_Number__c=mapRequest.get('Failed_Asset_Serial_Number_6') ;
            if(mapRequest.get('Failure_Reason_6') != null ) failedAsset6.Failure_Reason__c=mapRequest.get('Failure_Reason_6') ;
            if(mapRequest.get('Fault_Code_6') != null ) failedAsset6.Fault_Code__c=mapRequest.get('Fault_Code_6') ;
            if(mapRequest.get('Failed_Asset_Left_Paired_to_Device_6') != null ) failedAsset6.Failed_Asset_Left_Paired_to_Device__c=mapRequest.get('Failed_Asset_Left_Paired_to_Device_6') ;
            if(mapRequest.get('Failed_Asset_Notes_6') != null ) failedAsset6.Failed_Asset_Notes__c=mapRequest.get('Failed_Asset_Notes_6') ;
            FailedAssetList.add(failedAsset6);  
        }
        if(FailedAssetList!=null && FailedAssetList.size()>0) insert FailedAssetList; 
        //CH06.end
    }
    
    /**
        processJobResultsForFaultAssets(Map<String, String> mapRequest, id appointmentID)
             - This method is used to process Job resutls and add a new record in EON Fault Asset object
    **/
    public static void processJobResultsForFaultAssets(Map<String, String> mapRequest, id appointmentID){

        //Faulty asset records will be created only if the tag - faulty_assets_asset_type_1 has a value populated.
        if(mapRequest.get('faulty_assets_asset_type_1') != null && mapRequest.get('faulty_assets_asset_type_1') != ''){        
            //For Text fields.
            Map<String, String> mapAPIwithNodeFaultAsset = EON_OFSC_JobResults_Wrapper.getMapFieldNameWithOFSCTagForLookupFaultyAssets();
            EON_Faulty_Asset__c faultAsset = new EON_Faulty_Asset__c();
            faultAsset.Job_Reference__c = appointmentID;
            for(String fieldAPIName : mapAPIwithNodeFaultAsset.keySet()){
                faultAsset.put(fieldAPIName , mapRequest.get(mapAPIwithNodeFaultAsset.get(fieldAPIName)));
            }
            insert faultAsset;
        }
        
    }    
}