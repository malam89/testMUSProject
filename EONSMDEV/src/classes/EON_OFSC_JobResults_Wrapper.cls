/**
    Description : This class is used to prepare a map with Job Results object field value as a key and the OFSC label as a value.
                    (Used in the class EON_OFSC_Process_Job_Results_Helper)
    VF Page:
    Test Class : EON_OFSC_JobResults_Wrapper_Test                    
**/
/*
    Created By : Praveen G
    Created Date : 11-May-2016
    Service Request : SR_EON_Mobile_035
    
    Change History:
    CH01 # SR_EON_Mobile_050 # 30/06/2016 # Praveen G # Added few text fields.
    CH02 # SR_EON_Mobile_057 # 14-July-2016 # Praveen G #Added few text fields.
    CH03 # SR_EON_Mobile_061 # 21-July-2016 # Praveen G #Added / commented few text fields.
    CH04 # SR_EON_Mobile_072 # 19-August-2016 # Praveen G #Added one more text field mapping.
    CH05 # SR_EON_Mobile_075 # 05-September-2016 # Praveen G #Added 50 new fields 
    CH06 # SR_EON_Mobile_076 # 14-September-2016 # Praveen G #Added new field mapping
    CH07 #SR_EON_Mobile_102 # 19/11/2016 # Praveen G # Added new nodes
    CH08 #SR_EON_Mobile_105 # 02/12/2016 # Praveen G # Added new nodes and mapping fields.
    CH09 # SR_EON_Mobile_111 # 17/12/2016 # Praveen G # added new number field from OFSC.
    CH10 # SR_EON_Mobile_114 # 05/01/2017 # Praveen G # added 2 new text fields in the mapping.
    CH11 # SR_EON_Mobile_117 # 08/02/2017 # Praveen G # added a new text field in the mapping.
    CH12 # SR_EON_Mobile_118 # 28/02/2017 # Praveen G # Removed the mapping for couple of fields.
    CH13 # SR_OptiMUS_EON_090 # 11/08/2017 # Praveen G # Added new pick list field mapping.
    CH14 # SR_EON_OFSC_009 # 19/09/2017 # Praveen G # Added mapping for 11 text fields.
    CH15 # SR_EON_OFSC_034 # 22/02/2018 # Puneet Mehta G # Added mapping for new fields.
    CH16 # SR_OptiMUS_EON_243 # 27/04/2018 # Mehboob Alam # Removed and Added mapping for new fields.
    CH17 # SR_OptiMUS_EON_247 # 09/05/2018 # Mehboob Alam # Added mapping for new fields. 
    CH18 # SR_EON_OFSC_032 # 24/05/2018 # Shruti Moghe # Added mapping for new fields. 
    
*/

public with sharing class EON_OFSC_JobResults_Wrapper{
    
    /**
        getMapFieldNameWithOFSCTag() - This method constructs a map with a Job Resutl object field API as a 
                    value and OFSC Job Results request node as a value.
    **/
    public static MAP<String, String> getMapFieldNameWithOFSCTag(){
        MAP<String , String> mapAPIwithNode = new Map<String, String>();
        
        mapAPIwithNode.put('Job_Status__c' , 'activity_status');
        mapAPIwithNode.put('Initial_Contact_Outcome__c', 'conoutcome');
        mapAPIwithNode.put('Initial_Contact_Comment__c' , 'shortcomm');
        mapAPIwithNode.put('Arrival_Comment__c' , 'onsiteshortcomm');
        mapAPIwithNode.put('Late_Reason__c' , 'latereason');
        mapAPIwithNode.put('E_Meter_Serial_Number__c' , 'asset_e_msn');
        mapAPIwithNode.put('E_Meter_Serial_Number__c' , 'asset_e_msn');
        mapAPIwithNode.put('E_Meter_Type__c' , 'asset_e_type');
        mapAPIwithNode.put('E_Meter_Location__c' , 'asset_e_location');
        mapAPIwithNode.put('E_Meter_Manufacturer__c' , 'asset_e_manfct');
        mapAPIwithNode.put('E_Meter_Version__c' , 'asset_e_version');
        mapAPIwithNode.put('E_Meter_Register_1_ID__c' , 'asset_e_regID');
        mapAPIwithNode.put('E_Meter_Register_1_Read__c' , 'asset_e_regread');
        mapAPIwithNode.put('E_Meter_Register_2_ID__c' , 'asset_e_regID2');
        mapAPIwithNode.put('E_Meter_Register_2_Read__c' , 'asset_e_regread2');
        mapAPIwithNode.put('E_Meter_Register_3_ID__c' , 'asset_e_regID3');
        mapAPIwithNode.put('E_Meter_Register_3_Read__c' , 'asset_e_regread3');
        mapAPIwithNode.put('E_Meter_Register_4_ID__c' , 'asset_e_regID4');
        mapAPIwithNode.put('E_Meter_Register_4_Read__c' , 'asset_e_regread4');
        mapAPIwithNode.put('E_Meter_Register_5_ID__c' , 'asset_e_regID5');
        mapAPIwithNode.put('E_Meter_Register_5_Read__c' , 'asset_e_regread5');
        mapAPIwithNode.put('E_Meter_Register_6_ID__c' , 'asset_e_regID6');
        mapAPIwithNode.put('E_Meter_Register_6_Read__c' , 'asset_e_regread6');
        mapAPIwithNode.put('G_Meter_Serial_Number__c' , 'asset_g_msn');
        mapAPIwithNode.put('G_Meter_Type__c' , 'asset_g_type');
        mapAPIwithNode.put('G_Meter_Register_Read__c' , 'asset_g_read');
        mapAPIwithNode.put('G_Meter_Location__c' , 'asset_g_location');
        mapAPIwithNode.put('G_Meter_Manufacturer__c' , 'asset_g_manfct');
        mapAPIwithNode.put('G_Meter_Version__c' , 'asset_g_version');
        mapAPIwithNode.put('Reason_for_not_taking_Gas_Reading__c' , 'asset_g_noread');
        mapAPIwithNode.put('Uxp_Gas_Collar_Status__c' , 'asset_g_collar');
        mapAPIwithNode.put('Uxp_G_Meter_Closing_Read__c' , 'asset_g_remred');
        mapAPIwithNode.put('Uxp_G_Meter_Opening_Read__c' , 'asset_g_uxored');
        mapAPIwithNode.put('New_G_Meter_Number_of_digits__c' , 'asset_g_nodig_new');
        mapAPIwithNode.put('Gas_Regulator_Serial_Number__c' , 'asset_gr_msn');
        mapAPIwithNode.put('New_Gas_Regulator_Serial_Number__c' , 'asset_gr_msn_new');
        mapAPIwithNode.put('New_E_Meter_Serial_Number__c' , 'asset_e_msn_new');
        mapAPIwithNode.put('New_E_Meter_Type__c' , 'asset_e_meter_type_new');
        mapAPIwithNode.put('Electric_SSC_to_be_installed__c' , 'asset_e_SSC_new');
        mapAPIwithNode.put('Compliant_Meter__c' , 'asset_e_compliant_new');
        mapAPIwithNode.put('Installed_Meter_Tariff__c' , 'asset_e_tariff_new');
        mapAPIwithNode.put('New_E_Meter_Register_1_Reading__c' , 'asset_e_regread1_new');
        mapAPIwithNode.put('New_E_Meter_Register_2_Reading__c' , 'asset_e_regread2_new');
        mapAPIwithNode.put('New_E_Meter_Register_3_Reading__c' , 'asset_e_regread3_new');
        mapAPIwithNode.put('New_E_Meter_Register_4_Reading__c' , 'asset_e_regread4_new');
        mapAPIwithNode.put('New_E_Meter_Register_5_Reading__c' , 'asset_e_regread5_new');
        mapAPIwithNode.put('New_E_Meter_Register_6_Reading__c' , 'asset_e_regread6_new');
        mapAPIwithNode.put('New_G_Meter_Serial_Number__c' , 'asset_g_msn_new'); 
        mapAPIwithNode.put('New_G_Meter_Type__c' , 'asset_g_meter_type');
        mapAPIwithNode.put('EON_Regulator__c' , 'asset_g_eonregulator');
        mapAPIwithNode.put('Electricity_Action_Required__c' , 'faultd_e_actionrequired');
        mapAPIwithNode.put('Electricity_Fault_Diagnosis_Visit_Notes__c' , 'faultd_e_visitnotes');
        mapAPIwithNode.put('Electricity_Remedy_Notes__c' , 'faultd_e_remedynotes');
        mapAPIwithNode.put('Electricity_Remedy_Applied__c' , 'faultd_e_remedyapplied');
        mapAPIwithNode.put('Electricity_Replacement_Notes__c' , 'faultd_e_replacementnotes');
        mapAPIwithNode.put('Electricity_Replacement_Reason__c' , 'faultd_e_replacementreason');
        mapAPIwithNode.put('Electricity_Replacement_Strategy__c' , 'faultd_e_replacementstra');
        mapAPIwithNode.put('Electricity_Driver_for_reverting_type__c' , 'faultd_e_revert_driver');
        mapAPIwithNode.put('Electricity_Reason_for_Reverting_type__c' , 'faultd_e_revert_previous');
        mapAPIwithNode.put('Elec_Revert_Reason_Notes__c' , 'faultd_e_revert_note');
        mapAPIwithNode.put('Gas_Action_Required__c' , 'faultd_g_actionrequired');
        mapAPIwithNode.put('Gas_Fault_Diagnosis_Visit_Notes__c' , 'faultd_g_visitnotes');
        mapAPIwithNode.put('Gas_Remedy_Notes__c' , 'faultd_g_remedynotes'); 
        mapAPIwithNode.put('Gas_Remedy_Applied__c' , 'faultd_g_remedyapplied'); 
        mapAPIwithNode.put('Gas_Replacement_Notes__c' , 'faultd_g_replacementnotes');
        mapAPIwithNode.put('Gas_Replacement_Reason__c' , 'faultd_g_replacementreason');
        mapAPIwithNode.put('Gas_Replacement_Strategy__c' , 'faultd_g_replacementstra');
        mapAPIwithNode.put('Gas_Appliances_Relit__c' , 'faultd_g_relitindicator');
        mapAPIwithNode.put('Gas_Tightness_Test_Performed__c' , 'faultd_g_tightness');
        mapAPIwithNode.put('Gas_Driver_for_reverting_type__c' , 'faultd_g_revert_driver');
        mapAPIwithNode.put('Gas_Reason_for_reverting_type__c' , 'faultd_g_revert_reas');
        mapAPIwithNode.put('Gas_Revert_Reason_Notes__c' , 'faultd_g_revert_note');
        mapAPIwithNode.put('Uxp_E_Meter_Opening_Read_1__c' , 'asset_e_opening_read1');
        mapAPIwithNode.put('Uxp_E_Meter_Closing_Read_1__c' , 'asset_e_closing_read1');
        mapAPIwithNode.put('Uxp_E_Meter_Opening_Read_2__c' , 'asset_e_opening_read2');
        mapAPIwithNode.put('Uxp_E_Meter_Closing_Read_2__c' , 'asset_e_closing_read2');
        mapAPIwithNode.put('Uxp_E_Meter_Opening_Read_3__c' , 'asset_e_opening_read3');
        mapAPIwithNode.put('Uxp_E_Meter_Closing_Read_3__c' , 'asset_e_closing_read3');
        mapAPIwithNode.put('Uxp_E_Meter_Opening_Read_4__c' , 'asset_e_opening_read4');
        mapAPIwithNode.put('Uxp_E_Meter_Closing_Read_4__c' , 'asset_e_closing_read4');
        mapAPIwithNode.put('Uxp_E_Meter_Opening_Read_5__c' , 'asset_e_opening_read5');
        mapAPIwithNode.put('Uxp_E_Meter_Closing_Read_5__c' , 'asset_e_closing_read5');
        mapAPIwithNode.put('Uxp_E_Meter_Opening_Read_6__c' , 'asset_e_opening_read6');
        mapAPIwithNode.put('Uxp_E_Meter_Closing_Read_6__c' , 'asset_e_closing_read6');
        mapAPIwithNode.put('Comms_Hub_Found_on_Site__c' , 'asset_h_found');
        mapAPIwithNode.put('Expected_E_Meter_Found__c' , 'asset_e_found');
        mapAPIwithNode.put('New_Comms_Hub_Serial_Number__c' , 'asset_h_msn_new');
        mapAPIwithNode.put('Found_IHD_Serial_Number__c' , 'asset_i_msn');
        mapAPIwithNode.put('Found_IHD_Manufacturer__c' , 'asset_i_msnfct'); 
        mapAPIwithNode.put('Found_IHD_Model__c' , 'asset_i_model');
        mapAPIwithNode.put('New_IHD_supplied__c' , 'asset_i_supplied');
        mapAPIwithNode.put('New_IHD_Serial_Number__c' , 'asset_i_msn_new');
        mapAPIwithNode.put('IHD_Demo_Given__c' , 'asset_i_demo');
        mapAPIwithNode.put('Reason_IHD_Not_Supplied__c' , 'asset_i_reason');
        mapAPIwithNode.put('E_Meter_Removed__c' , 'elec_meter_removed');
        mapAPIwithNode.put('G_Meter_Removed__c' , 'gas_meter_removed');
        mapAPIwithNode.put('New_Comms_Hub_Serial_Number__c' , 'asset_h_msn_new');
        mapAPIwithNode.put('Smart_Material_Left_with_Customer__c' , 'mat_left_cust');
        mapAPIwithNode.put('Advice_Given_to_Customer__c' , 'mat_adv_given');
        mapAPIwithNode.put('WAN_Signal_Strength__c' , 'wan_signal_strength');
        mapAPIwithNode.put('HAN_Signal_Strength_at_Gas_Meter__c' , 'han_signal_strength_g');
        mapAPIwithNode.put('HAN_Signal_strength_at_IHD__c' , 'han_signal_strength_i');
        mapAPIwithNode.put('HAN_Channel_Installed__c' , 'han_channel_installed');
        mapAPIwithNode.put('HAN_Signal_Test_Performed__c' , 'han_signal_test');
        mapAPIwithNode.put('HAN_Signal_Test_not_performed_Reason__c' , 'han_signal_test_notperformed');
        mapAPIwithNode.put('Site_Specific_Risk_Assessment_Complete__c' , 'sra_complete');
        mapAPIwithNode.put('Safe_to_Continue__c' , 'sra_safe_continue');
        mapAPIwithNode.put('Safety_Check_Failure_Reason__c' , 'sra_safety_failure_r');
        mapAPIwithNode.put('Gas_Installation_Isolated__c' , 'sra_gas_inst_isolated');
        mapAPIwithNode.put('Pre_Work_Polarity_Check_Passed__c' , 'ec_pol_result');
        mapAPIwithNode.put('Pre_Work_Martindale_Check_Passed__c' , 'ec_mart_result');
        mapAPIwithNode.put('Pre_Work_Polarity_Test_Omitted_Reason__c' , 'ec_pol_omitted_reason');
        mapAPIwithNode.put('Pre_Work_Martindale_Test_Omitted_Reason__c' , 'ec_mart_omitted_reason');
        mapAPIwithNode.put('Polarity_Check_Passed__c' , 'ec_pol_result_post');
        mapAPIwithNode.put('Martindale_Check_Passed__c' , 'ec_mart_result_post');
        mapAPIwithNode.put('Polarity_Test_Omitted_Reason__c' , 'ec_pol_omitted_reason_post');
        mapAPIwithNode.put('Martindale_Test_Omitted_Reason__c' , 'ec_mart_omitted_reason_post');
        mapAPIwithNode.put('Pre_Work_DNO_Electric_Reference_Number__c' , 'ec_dno_ref');
        mapAPIwithNode.put('DNO_Safe_to_Continue__c' , 'ec_dno_safe');
        mapAPIwithNode.put('Pre_Work_DNO_Situation__c' , 'ec_dno_sitn');
        mapAPIwithNode.put('Site_Left_Energised__c' , 'esafechecks_site_energised');
        mapAPIwithNode.put('Pre_Work_DNO_Defect_Details__c' , 'esafechecks_dno_defect');
        //mapAPIwithNode.put('Pre_Work_Gas_Voltage_Check_Passed__c' , 'gsafechecks_volt');
        //mapAPIwithNode.put('Pre_Work_ECV_Check_Passed__c' , 'gsafechecks_ecv'); //CH16
        //mapAPIwithNode.put('Pre_Work_Gas_off_Check_Made__c' , 'gsafechecks_gasoffindicator'); //CH16
        mapAPIwithNode.put('Pre_Work_Appliances_Off_Check_Made__c' , 'gsafechecks_gasoffmsg');
        //mapAPIwithNode.put('Pre_Work_Meter_Box_Checked_for_Damage__c' , 'gsafechecks_damagedbox'); //CH16
        //mapAPIwithNode.put('Pre_Work_Gas_Site_Check_Performed__c' , 'gsafechecks_sitecheck'); //CH16
        //mapAPIwithNode.put('Pre_Work_Water_Corrosion_Check_Passed__c' , 'gsafechecks_watercorrosion'); //CH16
        mapAPIwithNode.put('Pre_Work_Gas_Test_Failure_Notes__c' , 'gsafechecks_gastestfailurenotes');
        //mapAPIwithNode.put('Pre_Work_Gas_Safety_Test_Omitted_Reason__c' , 'gsafechecks_omittedreason'); //CH16
        //mapAPIwithNode.put('Pre_Work_Gas_Test_Not_Performed_Reason__c' , 'gsafechecks_notperformedreason'); //CH16
        //mapAPIwithNode.put('Pre_Work_Appliances_Not_Checked_Reason__c' , 'gsafechecks_appli_notchecked'); //CH16
        //mapAPIwithNode.put('Gas_Voltage_Check_Passed__c' , 'gsafechecks_volt_post'); //CH16
        mapAPIwithNode.put('ECV_Check_Passed__c' , 'gsafechecks_ecv_post');
        //mapAPIwithNode.put('Gas_off_Check_Made__c' , 'gsafechecks_gasoffindicator_post'); //CH16
        mapAPIwithNode.put('Appliances_Off_Check_Made__c' , 'gsafechecks_gasoffmsg_post');
        //mapAPIwithNode.put('Meter_Box_Checked_for_Damage__c' , 'gsafechecks_damagedbox_post'); //CH16
        //mapAPIwithNode.put('Outlet_Pressure_Check_Passed__c' , 'gsafechecks_outletpressure'); //CH16
        //mapAPIwithNode.put('Gas_Site_Check_Performed__c' , 'gsafechecks_sitecheck_post'); //CH16
        //mapAPIwithNode.put('Relief_Vent_Pipe_Check_Passed__c' , 'gsafechecks_ventpipe'); //CH16
        //mapAPIwithNode.put('Water_Corrosion_Check_Passed__c' , 'gsafechecks_watercorrosion_post'); //CH16
        //mapAPIwithNode.put('Functional_Test_Required__c' , 'gsafechecks_functionaltest_post'); //CH16
        mapAPIwithNode.put('Gas_Inspection_Failure_Notes__c' , 'gsafechecks_failurenotes_post');
        //mapAPIwithNode.put('Relief_Valve_Check_Passed__c' , 'gsafechecks_reliefvalve'); //CH16
        //mapAPIwithNode.put('Excess_Flow_Valve_Check_Passed__c' , 'gsafechecks_excessflow'); //CH16
        mapAPIwithNode.put('Gas_Test_Failure_Notes__c' , 'gsafechecks_gastestfailurenotes_post');
        //mapAPIwithNode.put('Gas_Site_Safety_Test_Omitted_Reason__c' , 'gsafechecks_omittedreason_post'); //CH16
        //mapAPIwithNode.put('Gas_Test_Not_Performed_Reason__c' , 'gsafechecks_notperformedreason_post'); //CH16
        mapAPIwithNode.put('Gas_Appliances_Not_Checked_Reason__c' , 'gsafechecks_appli_notchecked_post'); //CH16
        mapAPIwithNode.put('Gas_Emergency_Job_Number__c' , 'gsafechecks_emergency_job_num');
        //mapAPIwithNode.put('Gas_Supply_Capped__c' , 'gsafechecks_gassupply_capped'); //CH16
        mapAPIwithNode.put('Gas_Safety_Notice_Issued__c' , 'gsafechecks_notice_indicator');
        mapAPIwithNode.put('Gas_Dangerous_Label_Attached__c' , 'gsafechecks_dangerous_label');
        mapAPIwithNode.put('Customer_Informed__c' , 'gsafechecks_cust_informed');
        mapAPIwithNode.put('E_Meter_Key_Availability_Status__c' , 'removed_e_prepay_key_availstatus');
        mapAPIwithNode.put('Elec_Prepay_Meter_Register_ID__c' , 'removed_e_prepay_registerID_1'); 
        mapAPIwithNode.put('Elec_Prepay_Meter_Register_ID_2__c' , 'removed_e_prepay_registerID_2');
        mapAPIwithNode.put('Elec_Prepay_Meter_Register_Name__c' , 'removed_e_prepay_register_name_1');
        mapAPIwithNode.put('Elec_Prepay_Meter_Register_Name_2__c' , 'removed_e_prepay_register_name_2');
        mapAPIwithNode.put('New_Prepayment_Register_ID__c' , 'e_prepay_new_regID');
        mapAPIwithNode.put('New_Prepayment_Register_Label__c' , 'e_prepay_new_reglabel');
        mapAPIwithNode.put('New_Prepayment_Register_Name__c' , 'e_prepay_new_regname');
        mapAPIwithNode.put('G_Meter_Key_Availability_Status__c' , 'removed_g_prepay_key_availstatus'); 
        mapAPIwithNode.put('Meter_Tails_1ph__c' , 'variations_meter_tails_1ph');
        mapAPIwithNode.put('Meter_Tails_3ph__c' , 'variations_meter_tails_3ph');
        mapAPIwithNode.put('De_Energisation_Reason__c' , 'dn_reason');
        mapAPIwithNode.put('De_Energisation_Notes__c' , 'dn_notes');
        //mapAPIwithNode.put('Site_Should_be_left_DeEnergised_Flag__c' , 'dn_flag');//CH03
        //mapAPIwithNode.put('Expected_End_De_Energisation_Status__c' , 'dn_status_end');//CH03
        //mapAPIwithNode.put('Starting_De_Energisation_Status__c' , 'dn_status_sta'); //CH03
        //mapAPIwithNode.put('Site_Should_be_left_Energised_Indicator__c' , 'rn_flag');//CH03
        //mapAPIwithNode.put('Starting_Energisation_Status__c' , 'rn_status_sta'); //CH03
        //mapAPIwithNode.put('Expected_End_Energisation_Status__c' , 'rn_exp_end_sta'); //CH03
        //mapAPIwithNode.put('Re_Energisation_Reason__c' , 'rn_en_reason'); //CH03
        //mapAPIwithNode.put('Re_Energisation_Notes__c' , 'rn_en_notes'); //CH03
        mapAPIwithNode.put('Cable_Conversion_Blocks_Fitted__c' , 'variations_cable_conv');
        mapAPIwithNode.put('Connector_Blocks_Fitted__c' , 'variations_conn_blocks_fitted');  
        mapAPIwithNode.put('Contactor_Fitted__c' , 'variations_contactor_fitted');
        mapAPIwithNode.put('Other_Electrical_Variations__c' , 'variations_other_elec');
        mapAPIwithNode.put('Timing_Device_Action__c' , 'variations_timingdevice');
        mapAPIwithNode.put('Other_Gas_Variations__c' , 'variations_other_gas');
        mapAPIwithNode.put('Work_Completed__c' , 'variations_workdone');
        mapAPIwithNode.put('Size_of_Tails_Used_in_Resiting__c' , 'ins_tails_size');
        //mapAPIwithNode.put('Gas_Regulator_Replaced__c' , 'gasreg_ind'); //CH02
        mapAPIwithNode.put('Genuine_ECO__c' , 'eco_genuine');
        mapAPIwithNode.put('ECO_Notes__c' , 'eco_notes');
        mapAPIwithNode.put('ECO_Invalid_Reason__c' , 'eco_invalid_reason');
        mapAPIwithNode.put('Able_to_obtain_E_Meter_reading__c' , 'able_to_read_e_meter');
        //mapAPIwithNode.put('Expected_E_Meter_Found__c' , 'expected_e_meter');
        mapAPIwithNode.put('Able_to_obtain_G_Meter_reading__c' , 'able_to_read_g_meter');
        mapAPIwithNode.put('Expected_G_Meter_Found__c' , 'expected_g_meter'); 
        mapAPIwithNode.put('DNO_Situation__c' , 'ec_dno_sitn_post');
        mapAPIwithNode.put('DNO_Defect_Details__c' , 'ec_dno_defect_post');
        mapAPIwithNode.put('DNO_Electric_Reference_Number__c' , 'ec_dno_ref_post'); 
        mapAPIwithNode.put('E_Check_Meter_Installed__c', 'asset_ec_meter'); 
        mapAPIwithNode.put('E_Check_Meter_Serial_Number__c', 'asset_ec_msn');
        mapAPIwithNode.put('G_Check_Meter_Installed__c', 'asset_gc_meter');
        mapAPIwithNode.put('G_Check_Meter_Serial_Number__c', 'asset_gc_msn');
        mapAPIwithNode.put('New_E_Meter_Register_1_ID__c', 'asset_e_regid1_new');
        mapAPIwithNode.put('New_E_Meter_Register_2_ID__c', 'asset_e_regid2_new');
        mapAPIwithNode.put('New_E_Meter_Register_3_ID__c', 'asset_e_regid3_new');
        mapAPIwithNode.put('New_E_Meter_Register_4_ID__c', 'asset_e_regid4_new');
        mapAPIwithNode.put('New_E_Meter_Register_5_ID__c', 'asset_e_regid5_new');
        mapAPIwithNode.put('New_E_Meter_Register_6_ID__c', 'asset_e_regid6_new');
        mapAPIwithNode.put('Found_Comms_Hub_Serial_Number__c', 'asset_h_msn');
        mapAPIwithNode.put('IHD_Found__c', 'asset_i_found');
        mapAPIwithNode.put('E_Meter_Installed__c', 'elec_meter_installed');
        mapAPIwithNode.put('G_Meter_Installed__c', 'gas_meter_installed');
        //mapAPIwithNode.put('Pre_Work_Gas_Inspection_Failure_Notes__c', 'gsafechecks_failurenotes'); //CH16
        mapAPIwithNode.put('New_E_Meter_Manufacturer__c', 'asset_e_make_new');
        mapAPIwithNode.put('New_E_Meter_Version__c', 'asset_e_model_new');
        mapAPIwithNode.put('New_E_Meter_Asset_Tag_Number__c', 'asset_e_tag_new');
        mapAPIwithNode.put('E_Meter_Resited__c', 'resite_e_meter');
        mapAPIwithNode.put('New_G_Meter_Manufacturer__c', 'asset_g_make_new');
        mapAPIwithNode.put('New_G_Meter_Version__c', 'asset_g_model_new');
        mapAPIwithNode.put('New_G_Meter_Asset_Tag_Number__c', 'asset_g_tag_new');   
        mapAPIwithNode.put('G_Meter_Resited__c', 'resite_g_meter'); 
           
        //Added as part of SR SR_EON_Mobile_044 - Praveen G
        mapAPIwithNode.put('Abort_Category__c','abort_category');
        mapAPIwithNode.put('Abort_Reason__c','abort_reason_description');
        mapAPIwithNode.put('Abort_Sub_Reason__c','abort_subreason_description'); 
        
        //CH01 Added  as part of SR SR_EON_Mobile_050 - Praveen G
        mapAPIwithNode.put('New_E_Meter_Register_1_dials_digits__c', 'asset_e_nodig1_new');
        mapAPIwithNode.put('New_E_Meter_Register_2_dials_digits__c', 'asset_e_nodig2_new');
        mapAPIwithNode.put('New_E_Meter_Register_3_dials_digits__c', 'asset_e_nodig3_new');
        mapAPIwithNode.put('New_E_Meter_Register_4_dials_digits__c', 'asset_e_nodig4_new');
        mapAPIwithNode.put('New_E_Meter_Register_5_dials_digits__c', 'asset_e_nodig5_new');
        mapAPIwithNode.put('New_E_Meter_Register_6_dials_digits__c', 'asset_e_nodig6_new');
        mapAPIwithNode.put('Removed_E_Meter_Asset_Tag__c', 'asset_e_tag');
        mapAPIwithNode.put('Removed_G_Meter_Asset_Tag__c', 'asset_g_tag');
        mapAPIwithNode.put('Unexpected_E_Meter_Label_Flag__c', 'asset_e_label');
                                                                                                                                                                  
        //CH02.Start
        mapAPIwithNode.put('New_E_Meter_Location__c' , 'asset_e_location_new');
        mapAPIwithNode.put('New_G_Meter_Location__c' , 'asset_g_location_new');
        mapAPIwithNode.put('Gas_Regulator_Replaced__c' , 'asset_gr_replaced');
        mapAPIwithNode.put('Abort_Comments__c' , 'abort_comments');
        //CH02.End
        
        //CH03.Start
        mapAPIwithNode.put('Starting_Energisation_Status__c','energise_stat_st');
        mapAPIwithNode.put('Ending_Energisation_Status__c','energise_stat_en');
        mapAPIwithNode.put('Reason_for_not_taking_Elec_Reading__c', 'asset_e_noread');
        //CH03.End
        
        //CH04.Start
        mapAPIwithNode.put('Opening_G_Meter_Reading__c','asset_g_read_new');
        //CH04.End 
        
        //CH05.Start
        mapAPIwithNode.put('Appliance_Type_1__c', 'appliance_type1');
        mapAPIwithNode.put('Appliance_Type_2__c', 'appliance_type2');
        mapAPIwithNode.put('Appliance_Type_3__c', 'appliance_type3');
        mapAPIwithNode.put('Appliance_Type_4__c', 'appliance_type4');
        mapAPIwithNode.put('Appliance_Type_5__c', 'appliance_type5');
        
        mapAPIwithNode.put('Appliance_Make_1__c', 'appliance_make1');
        mapAPIwithNode.put('Appliance_Make_2__c', 'appliance_make2');
        mapAPIwithNode.put('Appliance_Make_3__c', 'appliance_make3');
        mapAPIwithNode.put('Appliance_Make_4__c', 'appliance_make4');
        mapAPIwithNode.put('Appliance_Make_5__c', 'appliance_make5');
        
        mapAPIwithNode.put('Appliance_Model_1__c', 'appliance_model1');
        mapAPIwithNode.put('Appliance_Model_2__c', 'appliance_model2');
        mapAPIwithNode.put('Appliance_Model_3__c', 'appliance_model3');
        mapAPIwithNode.put('Appliance_Model_4__c', 'appliance_model4');
        mapAPIwithNode.put('Appliance_Model_5__c', 'appliance_model5');
                
        mapAPIwithNode.put('Appliance_Location_1__c', 'appliance_location1');
        mapAPIwithNode.put('Appliance_Location_2__c', 'appliance_location2');
        mapAPIwithNode.put('Appliance_Location_3__c', 'appliance_location3');
        mapAPIwithNode.put('Appliance_Location_4__c', 'appliance_location4');
        mapAPIwithNode.put('Appliance_Location_5__c', 'appliance_location5');
        
        mapAPIwithNode.put('Condition_Left_1__c', 'appliance_condition1');
        mapAPIwithNode.put('Condition_Left_2__c', 'appliance_condition2');
        mapAPIwithNode.put('Condition_Left_3__c', 'appliance_condition3');
        mapAPIwithNode.put('Condition_Left_4__c', 'appliance_condition4');
        mapAPIwithNode.put('Condition_Left_5__c', 'appliance_condition5');
        
        mapAPIwithNode.put('Action_Taken_1__c', 'appliance_action1');
        mapAPIwithNode.put('Action_Taken_2__c', 'appliance_action2');
        mapAPIwithNode.put('Action_Taken_3__c', 'appliance_action3');
        mapAPIwithNode.put('Action_Taken_4__c', 'appliance_action4');
        mapAPIwithNode.put('Action_Taken_5__c', 'appliance_action5');
        
        mapAPIwithNode.put('Safety_Notice_Issued_1__c', 'appliance_notice1');
        mapAPIwithNode.put('Safety_Notice_Issued_2__c', 'appliance_notice2');
        mapAPIwithNode.put('Safety_Notice_Issued_3__c', 'appliance_notice3');
        mapAPIwithNode.put('Safety_Notice_Issued_4__c', 'appliance_notice4');
        mapAPIwithNode.put('Safety_Notice_Issued_5__c', 'appliance_notice5');
        
        mapAPIwithNode.put('Gas_Dangerous_Label_Attached_1__c', 'appliance_label1');
        mapAPIwithNode.put('Gas_Dangerous_Label_Attached_2__c', 'appliance_label2');
        mapAPIwithNode.put('Gas_Dangerous_Label_Attached_3__c', 'appliance_label3');
        mapAPIwithNode.put('Gas_Dangerous_Label_Attached_4__c', 'appliance_label4');
        mapAPIwithNode.put('Gas_Dangerous_Label_Attached_5__c', 'appliance_label5');
        
        mapAPIwithNode.put('Customer_Informed_1__c', 'appliance_inform1');
        mapAPIwithNode.put('Customer_Informed_2__c', 'appliance_inform2');
        mapAPIwithNode.put('Customer_Informed_3__c', 'appliance_inform3');
        mapAPIwithNode.put('Customer_Informed_4__c', 'appliance_inform4');
        mapAPIwithNode.put('Customer_Informed_5__c', 'appliance_inform5');
        
        mapAPIwithNode.put('Gas_Appliance_Comments_1__c', 'appliance_comment1');
        mapAPIwithNode.put('Gas_Appliance_Comments_2__c', 'appliance_comment2');
        mapAPIwithNode.put('Gas_Appliance_Comments_3__c', 'appliance_comment3');
        mapAPIwithNode.put('Gas_Appliance_Comments_4__c', 'appliance_comment4');
        mapAPIwithNode.put('Gas_Appliance_Comments_5__c', 'appliance_comment5');        
                
        //CH05.End  
        
        //CH06.Start
        mapAPIwithNode.put('Actual_SSC_Installed__c', 'asset_e_SSC_actual');
        //CH06.End 
        
        //CH09.Start
        mapAPIwithNode.put('G_Meter_Number_of_Digits__c' , 'asset_g_nodig');
        //CH09.End
        
        //CH10.Start
        mapAPIwithNode.put('Original_E_Meter_refitted__c' , 'asset_e_refit');
        mapAPIwithNode.put('Original_G_Meter_refitted__c' , 'asset_g_refit');
        //CH10.End
        
        //CH11.Start
        mapAPIwithNode.put('E_Meter_Owner__c' , 'asset_e_owner');
        //CH11.End  

        mapAPIwithNode.put('Standard_Load_Test_Results__c' , 'load_test_result'); //CH13 
        
        //CH14.Start
        mapAPIwithNode.put('Premise_Type__c' , 'premise_type');
        mapAPIwithNode.put('Comms_Hub_Variant_Installed__c' , 'Comms_hub_variant_installed');
        mapAPIwithNode.put('Comms_Hub_Faulty__c' , 'comms_hub_faulty');
        mapAPIwithNode.put('Comms_Hub_Variant_Installed_Reason__c' , 'comms_hub_variant_installed_reason');
        mapAPIwithNode.put('Comms_Hub_Location__c' , 'comms_hub_location');
        mapAPIwithNode.put('Aerial_Fitted__c' , 'aerial_fitted');
        mapAPIwithNode.put('Connection_Method__c' , 'connection_method');
        mapAPIwithNode.put('Comms_Hub_Metal_Obstruction__c' , 'comms_hub_metal_obstruction');
        mapAPIwithNode.put('Comms_Hub_Thick_Stone_Wall__c' , 'comms_hub_thick_stone_wall');
        mapAPIwithNode.put('Comms_Hub_in_Communal_Shared_area__c' , 'comms_hub_in_communal_shared_area');
        mapAPIwithNode.put('SMETS_Type_Installed__c' , 'smets_type_installed');        
        //CH14.End  

        //CH15.Start
        mapAPIwithNode.put('Has_The_Customer_Reported_a_Smell_of_Gas__c' , 'GAS_CHECKS_SMELLOFGAS');
        //mapAPIwithNode.put('Pressure_Test_Result__c' , 'GAS_CHECKS_PRESSURETEST'); //CH16
        mapAPIwithNode.put('Metallic_surfaces_checked_with_Voltstick__c' , 'GAS_CHECKS_G_VOLT');
        mapAPIwithNode.put('Pre_Work_ECV_Check_Passed__c' , 'GAS_CHECKS_ECVTESTRESULT');
        mapAPIwithNode.put('Pre_Work_Tightness_Test_Result__c' , 'GAS_CHECKS_TIGHTNESSTESTRESULT');
        mapAPIwithNode.put('ECV_Check_Passed__c' , 'POST_GAS_CHECKS_ECVTESTRESULT');
        mapAPIwithNode.put('Post_Installation_Tightness_Test_Result__c' , 'POST_GAS_CHECKS_TIGHTNESSTESTRESULT');
        mapAPIwithNode.put('Meter_Only_Tightness_Test_Result__c' , 'POST_GAS_CHECKS_METERONLYTIGHTNESSTESTRESULT'); 
        //CH15.End
        
        //CH16.Start
        mapAPIwithNode.put('Reason_for_not_checking_metallic_surface__c' , 'gsafechecks_volt_not_check');
        mapAPIwithNode.put('Temporary_Continuity_Bonds_applied__c' , 'gsafechecks_continuity_bonds');
        mapAPIwithNode.put('Pre_Installation_Tightness_Test_outcome__c' , 'gsafechecks_tightness_outcome');
        mapAPIwithNode.put('GDN_Reference_Number__c' , 'gsafechecks_gdn_reference');
        mapAPIwithNode.put('Gas_Supply_Capped__c' , 'gsafechecks_gassupply_capped');
        mapAPIwithNode.put('Post_work_GDN_Reference_Number__c' , 'gsafechecks_post_gdn_reference');
        mapAPIwithNode.put('Post_work_Gas_Supply_Capped__c' , 'gsafechecks_post_gassupply_capped'); 
        mapAPIwithNode.put('Warning_Notice_Reference_number__c' , 'gsafechecks_warning_reference');
        mapAPIwithNode.put('Has_Leak_Detection_Fluid_been_applied__c' , 'gsafechecks_leak_detect'); 
        mapAPIwithNode.put('Standing_Pressure__c' , 'gsafechecks_standing_pressure');
        mapAPIwithNode.put('Working_Pressure__c' , 'gsafechecks_working_pressure'); 
        //CH16.End
        mapAPIwithNode.put('Post_Installation_Tightness_Test_Outcome__c' , 'gsafechecks_post_tightness_outcome'); //CH17
        //CH18.Start
        mapAPIwithNode.put('Removed_E_Meter_Reason__c','Electricity_Meter_Removed_Reason');
        mapAPIwithNode.put('Removed_E_Meter_Fault_Reason__c','Electricity_Meter_Removed_Fault');
        mapAPIwithNode.put('Removed_E_Meter_Error_Code__c','Electricity_Meter_Removed_Error_Code');
        mapAPIwithNode.put('Removed_E_Meter_Fault_Notes__c','Electricity_Meter_Removed_Fault_Notes');
        mapAPIwithNode.put('Removed_E_Meter_Left_Paired__c','Electricity_Meter_Removed_Left_Paired');
        mapAPIwithNode.put('Removed_G_Meter_Reason__c','Gas_Meter_Removed_Reason');
        mapAPIwithNode.put('Removed_G_Meter_Fault_Reason__c','Gas_Meter_Removed_Fault');
        mapAPIwithNode.put('Removed_G_Meter_Error_Code__c','Gas_Meter_Removed_Error_Code');
        mapAPIwithNode.put('Removed_G_Meter_Fault_Notes__c','Gas_Meter_Removed_Fault_Notes');
        mapAPIwithNode.put('Removed_G_Meter_Left_Paired__c','Gas_Meter_Removed_Left_Paired');
        mapAPIwithNode.put('Comms_Hub_Found_on_Site__c','Comms_Hub_Found_on_Site');
        mapAPIwithNode.put('Found_Comms_Hub_Serial_Number__c','Found_Comms_Hub_Serial_Number');
        mapAPIwithNode.put('Found_Comms_Hub_Connection_Method__c','Found_Comms_Hub_Connection_Method');
        mapAPIwithNode.put('Found_Cradle_Serial_Number__c','Found_Cradle_Serial_Number');
        mapAPIwithNode.put('Found_Cradle_Manufacturer__c','Found_Cradle_Manufacturer');
        mapAPIwithNode.put('Found_Hot_Shoe_Serial_Number__c','Found_Hot-Shoe_Serial_Number');
        mapAPIwithNode.put('Found_Hot_Shoe_Manufacturer__c','Found_Hot-Shoe_Manufacturer');
        mapAPIwithNode.put('Found_Aerial__c','Found_Aerial');
        mapAPIwithNode.put('Found_Aerial_Manufacturer__c','Found_Aerial_Manufacturer');
        mapAPIwithNode.put('Removed_Regulator_Asset_Tag__c','Removed_Gas_Regulator_Asset_Tag_Number');
        mapAPIwithNode.put('Removed_Regulator_Reason__c','Gas_Regulator_Removed_Reason');
        mapAPIwithNode.put('Removed_Gas_Regulator_Serial_Number__c','Removed_Gas_Regulator_Serial_Number');
        mapAPIwithNode.put('Removed_Gas_Regulator_Serial_Number__c','Removed_Gas_Regulator_Serial_Number_Available');
        mapAPIwithNode.put('Removed_Regulator_Fault_Reason__c','Gas_Regulator_Fault_Reason');
        mapAPIwithNode.put('Remove_Regulator_Fault_Notes__c','Gas_Regulator_Removed_Fault_Notes');
        mapAPIwithNode.put('Removed_Comms_Hub_Asset_Tag__c','Removed_Comms_Hub_Asset_Tag_Number');
        mapAPIwithNode.put('Removed_Comms_Hub_Connection_Method__c','Have_you_removed_the_Connected_Device');
        mapAPIwithNode.put('Removed_Comms_Hub_Reason__c','Removed_Comms_Hub_Reason');
        mapAPIwithNode.put('Removed_Comms_Hub_Fault_Reason__c','Removed_Comms_Hub_Fault_Reason');
        mapAPIwithNode.put('Removed_Comms_Hub_Fault_Notes__c','Removed_Comms_Hub_Notes');
        mapAPIwithNode.put('Removed_Comms_Hub_Left_Paired__c','Removed_Comms_Hub_Left_Paired');
        mapAPIwithNode.put('Removed_IHD_Asset_Tag__c','Removed_IHD_Asset_Tag_Number');
        mapAPIwithNode.put('Removed_IHD_Reason__c','Removed_IHD_Reason');
        mapAPIwithNode.put('Removed_IHD_Fault_Reason__c','Removed_IHD_Fault_Reason');
        mapAPIwithNode.put('Removed_IHD_Error_Code__c','Removed_IHD_Error_Code');
        mapAPIwithNode.put('Removed_IHD_Fault_Notes__c','Removed_IHD_Left_Paired');
        mapAPIwithNode.put('Removed_IHD_Left_Paired__c','Removed_IHD_Notes');
        mapAPIwithNode.put('Comms_Hub_Connection_Method__c','Comms_Hub_Connection_Method');
        mapAPIwithNode.put('Installed_Cradle_Serial_Number__c','Installed_Cradle_Serial_Number');
        mapAPIwithNode.put('Installed_Cradle_Manufacturer__c','Installed_Cradle_Manufacturer');
        mapAPIwithNode.put('Installed_Hot_Shoe_Serial_Number__c','Installed_Hot-Shoe_Serial_Number');
        mapAPIwithNode.put('Installed_Hot_Shoe_Manufacturer__c','Installed_Hot-Shoe _Manufacturer');
        mapAPIwithNode.put('Installed_Aerial_Manufacturer__c','Aerial_Manufacturer');
        //CH18.end
        return mapAPIwithNode;
    }
    
    /**
        getMapFieldNameWithOFSCTagForNumbers() - This method constructs a map with a Job Resutl object field 
                        API as a value and OFSC Job Results request node as a value for number fields.
    **/
    public static MAP<String, String> getMapFieldNameWithOFSCTagForNumbers(){ 
        MAP<String , String> mapAPIwithNodeNum = new Map<String, String>();  
        
        mapAPIwithNodeNum.put('New_E_Meter_Number_of_digits__c' , 'asset_e_nodig_new');
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Balance__c' , 'removed_e_prepay_balance'); 
        mapAPIwithNodeNum.put('Elec_Prepay_Debt_Recovery_Rate__c' , 'removed_e_prepay_debt_recovery');
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Emergency_Credit__c' , 'removed_e_prepay_emer_credit');
        
        //CH07.Start
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Unit_Rate_1__c' , 'removed_e_prepay_meter_unit_rate');
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Unit_Rate_2__c' , 'removed_e_prepay_meter_unit_rate2');
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Unit_Rate_3__c' , 'removed_e_prepay_meter_unit_rate3');
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Unit_Rate_4__c' , 'removed_e_prepay_meter_unit_rate4');
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Unit_Rate_5__c' , 'removed_e_prepay_meter_unit_rate5');
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Unit_Rate_6__c' , 'removed_e_prepay_meter_unit_rate6');
        //CH07.End
        
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Weekly_Charge__c' , 'removed_e_prepay_weekly_charge');
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Total_Debt__c' , 'removed_e_prepay_total_debt'); 
        
        //CH07.Start               
        mapAPIwithNodeNum.put('New_Prepayment_Meter_Unit_Rate_1__c' , 'e_prepay_new_unit_rate');
        mapAPIwithNodeNum.put('New_Prepayment_Meter_Unit_Rate_2__c' , 'e_prepay_new_unit_rate2');
        mapAPIwithNodeNum.put('New_Prepayment_Meter_Unit_Rate_3__c' , 'e_prepay_new_unit_rate3');
        mapAPIwithNodeNum.put('New_Prepayment_Meter_Unit_Rate_4__c' , 'e_prepay_new_unit_rate4');
        mapAPIwithNodeNum.put('New_Prepayment_Meter_Unit_Rate_5__c' , 'e_prepay_new_unit_rate5');
        mapAPIwithNodeNum.put('New_Prepayment_Meter_Unit_Rate_6__c' , 'e_prepay_new_unit_rate6');
        //CH07.End
        
        mapAPIwithNodeNum.put('Weekly_Debt_Repayment__c' , 'e_prepay_new_weeklydebt_repay');
        mapAPIwithNodeNum.put('Emergency_Credit__c' , 'e_prepay_new_emer_credit');
        mapAPIwithNodeNum.put('Total_Debt__c' , 'e_prepay_total_debt');
        mapAPIwithNodeNum.put('Gas_Prepay_Meter_Balance__c' , 'removed_g_prepay_balance');  
        mapAPIwithNodeNum.put('Gas_Prepay_Meter_Total_Debt__c' , 'removed_g_prepay_total_debt');
        
        //mapAPIwithNodeNum.put('X2_Pole_Isolators_fitted__c' , 'variations_num_2pole_fitted'); //CH12
        //mapAPIwithNodeNum.put('X4_Pole_Isolators_fitted__c' , 'variations_num_4pole_fitted'); //CH12
        mapAPIwithNodeNum.put('Number_of_Resite_Blocks_used__c' , 'ins_num_resite_blocks');  
        mapAPIwithNodeNum.put('Length_of_Tails_Used_in_Resiting__c' , 'ins_tails_length');
        mapAPIwithNodeNum.put('Length_of_pipe_used_in_Resiting__c' , 'ins_pipe_length'); 
        
        //CH08.Start
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Total_Credit_Accepted__c' , 'removed_e_prepay_credit_accept'); 
        mapAPIwithNodeNum.put('Elec_Prepay_Meter_Total_Debt_Outstanding__c' , 'removed_e_prepay_debt_outstanding');
        mapAPIwithNodeNum.put('New_Prepay_Meter_Standing_Charge__c' , 'e_prepay_standing_charge');
        mapAPIwithNodeNum.put('New_Prepay_Meter_Total_Debt_Oustanding__c' , 'e_prepay_debt_outstanding');
        mapAPIwithNodeNum.put('New_Prepay_Meter_Total_Credit_Accepted__c' , 'e_prepay_credit_accept');        
        //CH08.End    
        
        return mapAPIwithNodeNum; 
    }
    
    /**
        getMapFieldNameWithOFSCTagForLookup() - This method constructs a map with a Job Resutl object field API as a value and OFSC Job Results
                    request node as a value for Lookup fields.
    **/
    public static MAP<String, String> getMapFieldNameWithOFSCTagForLookup(){ 
        MAP<String , String> mapAPIwithNodeLookup = new Map<String, String>();
        
        mapAPIwithNodeLookup.put('E_Meter_Register_1_Name__c' , 'asset_e_regname');
        mapAPIwithNodeLookup.put('E_Meter_Register_2_Name__c' , 'asset_e_regname2');
        mapAPIwithNodeLookup.put('E_Meter_Register_3_Name__c' , 'asset_e_regname3');
        mapAPIwithNodeLookup.put('E_Meter_Register_4_Name__c' , 'asset_e_regname4');
        mapAPIwithNodeLookup.put('E_Meter_Register_5_Name__c' , 'asset_e_regname5');
        mapAPIwithNodeLookup.put('E_Meter_Register_6_Name__c' , 'asset_e_regname6');
        mapAPIwithNodeLookup.put('New_E_Meter_Register_1_Type__c' , 'asset_e_regname1_new');
        mapAPIwithNodeLookup.put('New_E_Meter_Register_2_Type__c' , 'asset_e_regname2_new');
        mapAPIwithNodeLookup.put('New_E_Meter_Register_3_Type__c' , 'asset_e_regname3_new');
        mapAPIwithNodeLookup.put('New_E_Meter_Register_4_Type__c' , 'asset_e_regname4_new');
        mapAPIwithNodeLookup.put('New_E_Meter_Register_5_Type__c' , 'asset_e_regname5_new');
        mapAPIwithNodeLookup.put('New_E_Meter_Register_6_Type__c' , 'asset_e_regname6_new');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Opening_Register_Name_1__c' , 'asset_e_opening_regname1');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Closing_Register_Name_1__c' , 'asset_e_closing_regname1');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Opening_Register_Name_2__c' , 'asset_e_opening_regname2');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Closing_Register_Name_2__c' , 'asset_e_closing_regname2');       
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Opening_Register_Name_3__c' , 'asset_e_opening_regname3');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Closing_Register_Name_3__c' , 'asset_e_closing_regname3');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Opening_Register_Name_4__c' , 'asset_e_opening_regname4');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Closing_Register_Name_4__c' , 'asset_e_closing_regname4');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Opening_Register_Name_5__c' , 'asset_e_opening_regname5');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Closing_Register_Name_5__c' , 'asset_e_closing_regname5');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Opening_Register_Name_6__c' , 'asset_e_opening_regname6');
        mapAPIwithNodeLookup.put('Uxp_E_Meter_Closing_Register_Name_6__c' , 'asset_e_closing_regname6');                    
        
        return mapAPIwithNodeLookup;
    }   
    
    /**
        getMapFieldNameWithOFSCTagForDate() - This method constructs a map with a Job Resutl object field API as a value and OFSC Job Results
                    request node as a value for Date fields.
    **/
    public static MAP<String, String> getMapFieldNameWithOFSCTagForDate(){ 
        MAP<String , String> mapAPIwithNodeDate = new Map<String, String>();
        mapAPIwithNodeDate.put('E_Meter_Certification_Date__c', 'asset_e_certdate');
        mapAPIwithNodeDate.put('E_Meter_Exchange_Date__c', 'asset_e_exchangedate');
        mapAPIwithNodeDate.put('Uxp_G_Meter_Exchange_Date__c', 'asset_g_uxinsd');
        return mapAPIwithNodeDate;
    }      
    
    
    /**
        convertStringToNumber(String value) : This is util method to convert string to number.
  
    public integer convertStringToNumber(String value){
        if(value != null || value != ''){
            try{
                return Integer.valueOf(value);
            }catch(exception ex){
                System.debug('Exception occured while converting string to integer ****** : ' + ex.getStackTraceString());
            }
        }        
        return null;
    }
    **/
      
    /**
        getEONElectricMeterRegisterMap() - this method will return a map which has key as name field and value as salesforce record id
            of the object EON Electric Meter Register.
    **/
    public static Map<String, String> getEONElectricMeterRegisterMap(){
    
        Map<String, String> mapLookupNameId = new Map<String, String>();
        
        for(EON_Electric_Meter_Register__c meterRegister : [select id, Name from EON_Electric_Meter_Register__c where isDeleted = false]){
            mapLookupNameId.put(meterRegister.Name , meterRegister.Id);
        }
        
        return mapLookupNameId;
    }
    
    /**
        getMapFieldNameWithOFSCTagForLookupFaultyAssets() - This method constructs a map with a EON Fault Asset object field API as a value and OFSC Job Results
                    request node as a value for EON Fault Asset object fields.
    **/
    public static MAP<String, String> getMapFieldNameWithOFSCTagForLookupFaultyAssets(){ 
        MAP<String , String> mapAPIwithNodeFaultAsset = new Map<String, String>(); 
        mapAPIwithNodeFaultAsset.put('Asset_Type_1__c', 'faulty_assets_asset_type_1');
        mapAPIwithNodeFaultAsset.put('Serial_Number_1__c', 'faulty_assets_serial_number_1');
        mapAPIwithNodeFaultAsset.put('Asset_Tag_1__c', 'faulty_assets_asset_tag_1');
        mapAPIwithNodeFaultAsset.put('Manufacturer_1__c', 'faulty_assets_asset_manufacturer_1');
        mapAPIwithNodeFaultAsset.put('Model_1__c', 'faulty_assets_asset_model_1');
        mapAPIwithNodeFaultAsset.put('Smart_Fault_1__c', 'faulty_assets_asset_smartfault_1');
        mapAPIwithNodeFaultAsset.put('BAU_Fault_1__c', 'faulty_assets_asset_baufault_1');
        mapAPIwithNodeFaultAsset.put('Notes_1__c', 'faulty_assets_asset_notes_1');
        mapAPIwithNodeFaultAsset.put('Asset_Type_2__c', 'faulty_assets_asset_type_2');
        mapAPIwithNodeFaultAsset.put('Serial_Number_2__c', 'faulty_assets_serial_number_2');
        mapAPIwithNodeFaultAsset.put('Asset_Tag_2__c', 'faulty_assets_asset_tag_2');
        mapAPIwithNodeFaultAsset.put('Manufacturer_2__c', 'faulty_assets_asset_manufacturer_2');
        mapAPIwithNodeFaultAsset.put('Model_2__c', 'faulty_assets_asset_model_2');
        mapAPIwithNodeFaultAsset.put('Smart_Fault_2__c', 'faulty_assets_asset_smartfault_2');
        mapAPIwithNodeFaultAsset.put('BAU_Fault_2__c', 'faulty_assets_asset_baufault_2');
        mapAPIwithNodeFaultAsset.put('Notes_2__c', 'faulty_assets_asset_notes_2');
        mapAPIwithNodeFaultAsset.put('Asset_Type_3__c', 'faulty_assets_asset_type_3');
        mapAPIwithNodeFaultAsset.put('Serial_Number_3__c', 'faulty_assets_serial_number_3');
        mapAPIwithNodeFaultAsset.put('Asset_Tag_3__c', 'faulty_assets_asset_tag_3');
        mapAPIwithNodeFaultAsset.put('Manufacturer_3__c', 'faulty_assets_asset_manufacturer_3');
        mapAPIwithNodeFaultAsset.put('Model_3__c', 'faulty_assets_asset_model_3');
        mapAPIwithNodeFaultAsset.put('Smart_Fault_3__c', 'faulty_assets_asset_smartfault_3');
        mapAPIwithNodeFaultAsset.put('BAU_Fault_3__c', 'faulty_assets_asset_baufault_3');
        mapAPIwithNodeFaultAsset.put('Notes_3__c', 'faulty_assets_asset_notes_3');
        mapAPIwithNodeFaultAsset.put('Asset_Type_4__c', 'faulty_assets_asset_type_4');
        mapAPIwithNodeFaultAsset.put('Serial_Number_4__c', 'faulty_assets_serial_number_4');
        mapAPIwithNodeFaultAsset.put('Asset_Tag_4__c', 'faulty_assets_asset_tag_4');
        mapAPIwithNodeFaultAsset.put('Manufacturer_4__c', 'faulty_assets_asset_manufacturer_4');
        mapAPIwithNodeFaultAsset.put('Model_4__c', 'faulty_assets_asset_model_4');
        mapAPIwithNodeFaultAsset.put('Smart_Fault_4__c', 'faulty_assets_asset_smartfault_4');
        mapAPIwithNodeFaultAsset.put('BAU_Fault_4__c', 'faulty_assets_asset_baufault_4');
        mapAPIwithNodeFaultAsset.put('Notes_4__c', 'faulty_assets_asset_notes_4');                
        
        return mapAPIwithNodeFaultAsset;
    } 
    
}