/**
    Description:  This class will be called from the record IMP-004, to process the appointment records 
                    from the attachments (CSV) as a batch one record at a time as webservice call involved in it.
    Test Class : EON_Update_Appointment_OFSC_CTRL_test                
**/

/*
    Created by : Praveen G
    Created Date : 13/09/2017
    Service Request : SR_OptiMUS_EON_098
*/

global with sharing class EON_Update_Appointment_OFSC_Batch 
                            implements Database.batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
    
    //instance variables
    global String appQuery;
    global String attachmentRecID;
    global String results_PASS;
    global String results_FAIL;
    
    /**
        EON_Update_Appointment_OFSC_Batch() - Default Construcor.    
    **/
    public EON_Update_Appointment_OFSC_Batch(){
    }    
    
    /**
        EON_Update_Appointment_OFSC_Batch(String query, String PattachmentRecID)
        -Parameterized constructor.
    **/
    public EON_Update_Appointment_OFSC_Batch(String query, String PattachmentRecID){
        //Initiate the instance variables
        appQuery = query;
        attachmentRecID = PattachmentRecID;
        results_PASS = '';
        results_FAIL = '';
    }
    
    /** 
        Database.queryLocator start(Database.BatchableContext BC) - start method
    **/
    global Database.queryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(appQuery);
    }
    
    /**
        execute(Database.BatchableContext BC, List<TWM_Tasks__c> scope) - Main execute method
    **/
    global void execute(Database.BatchableContext BC, List<EON_appointment__c> scope){
        //one batch is for one apppointment record only as call out is in it.
        EON_appointment__c appt = scope[0];
            
        //get the appointment        
        EON_Appointment__c app = getAppointment(appt.id);
        
        //get the Appointment contacts            
        list<EON_Appointment_Contact__c> lstAppointmentContacts = getAppointmentContacts(app.id); 
        
        //get the AppointmentVulnerabilities           
        list<EON_Appointment_Vulnerability__c> lstAppointmentVuln = getAppointmentVuln(app.id);
        
        try{
            //call ORACLE update call to send appointment updates to ORACLE for sub area update.
            String result = EON_OFSC_Update_Appointment.sendActivityToOFSC(app, lstAppointmentContacts, 
                                                        lstAppointmentVuln, app.Booking_System_Name__c);
            if(result == 'Job sent to OFSC successfully'){
                String subArea = calculateSubArea(app.Oracle_Postcode_Sector__c, app.h_Job_Type__c);
                System.debug('**** subArea '+ subArea);
                if(subArea != ''){
                    updateAppForSubArea(app.id, subArea);
                    results_PASS += app.id + '\n';
                }else{
                    results_FAIL += app.id + '\n';
                }        
            }else{
                results_FAIL += app.id + '\n';
            }
        }catch(Exception ex){
            results_FAIL += app.id + '_ERROR' + '\n'; 
            System.debug('*** Exception Occured ' + ex.getMessage());
        }
                    
    }
    
    /**
        updateAppForSubArea(String appId, String subArea)
    **/
    global void updateAppForSubArea(String appID, String subArea){
        EON_Appointment__c appointment = new EON_Appointment__c(id = appID);
        appointment.subArea__c = subArea;
        update appointment;
    }
    
    /**
        calculateSubArea() - This method is to calculate the subArea and update in appointment record
    **/    
    global String calculateSubArea(String oraclePostCode, String jobType){
        String subArea = ''; 
        string postcode = string.isNotBlank(oraclePostCode) ? oraclePostCode : '';
        list<EON_Post_Code__c> lstPC = new list<EON_Post_Code__c>(
                [select id, name, h_sub_area_checkbox__c, Sub_Area_Name__r.Id, Sub_Area_Name__r.Oracle_Bucket_ID__c 
                From EON_Post_Code__c 
                where 
                name =: postcode]);
        for(EON_Post_Code__c objPC : lstPC){
            string check = string.isNotBlank(objPC.h_sub_area_checkbox__c)?objPC.h_sub_area_checkbox__c:'';
            if(string.isNotBlank(jobType) && string.isNotBlank(check) && check.containsIgnoreCase(jobType)){
                subArea = objPC.Sub_Area_Name__r.Id;
            }            
        } 
        
        return subArea;               
    }
    
    /**
        getAppointmentVuln(String appID) - get the Appointment Vulnerablity details related to appointment.
    **/
    global list<EON_Appointment_Vulnerability__c> getAppointmentVuln(String appID){
        return [SELECT ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,Description__c,
                EON_Appointment_ID__c,h_AppId_Code__c,h_appointmentDetailCodeUnique__c,h_Vulnerability_Desc__c,Id,
                IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,
                Name,SystemModstamp,VulnerabilityDetailCode__c,VulnerabilityTypeID__c 
                FROM 
                EON_Appointment_Vulnerability__c 
                where 
                EON_Appointment_ID__c =: appID];
    }
    
    /**
        getAppointmentContacts(String appID) - get the Appointment Contact details related to appointment.
    **/
    global list<EON_Appointment_Contact__c> getAppointmentContacts(String appID){    
        return [SELECT ConnectionReceivedId,ConnectionSentId,Contact_Full_Name__c,Contact_Type__c,
                CreatedById,CreatedDate,Customer_Assistant__c,EON_Appointment_ID__c,Id,IsDeleted, 
                Media_Type__c, Media_Detail__c 
                FROM 
                EON_Appointment_Contact__c 
                where 
                EON_Appointment_ID__c =: appID];    
    }
    
    /**
        getAppointment() - Get the Appointment Record details
    **/
    global EON_Appointment__c getAppointment(String appID){
    
    return [SELECT Abort_Datetime__c,Abort_Reason__c,Access_Instructions__c,CSP_Region__c,Comms_Hub_Variant__c,Connectivity_Likelihood__c,
                              Auxiliary_Equipment_required__c, WAN_Additional_Information__c,
        Access_Pass_Phrase__c,Additional_Information__c,Alternate_Priority_Service_Contact_Name__c,
        Alternate_Priority_Service_PhoneNumber1__c,Alternate_Priority_Service_PhoneNumber2__c,
        Appointment_Date__c,Appointment_Key__c,Appointment_reason_code__c,Assisted_Work_Reason_Code__c,
        Assisted_Work_Reason__c,Booking_System_Name__c,Braille__c,Building_Name__c,Building_Number__c,
        Caller_Name__c,Call_2_Days_before_appointment_Required__c,Cancellation_DateTime__c,
        Cancel_Electricity_Job__c,Cancel_Gas_Job__c,Cancel_Reason__c,Capacity_Override_reason__c,
        Certification_Date__c,Certification_Expiry_Date__c,Closed_in_JUMBO__c,Close_Electricity_Job__c,
        Close_Gas_Job__c,Complete_DateTime__c,Confirmed_Appointment_DateTime__c,ConnectionReceivedId,
        ConnectionSentId,Contact_Email__c,Contact_Name__c,Contact_Number__c,Contact_Telephone_Number__c,
        Contract_Reference__c,Contract__c,Country__c,County__c,CreatedById,CreatedDate,
        Create_Electricity_Job__c,Create_Gas_Job__c,Current_Phase__c,Current_SSC__c,Current__c,
        Customer_Name__c,Customer_Preferred_Contact_Method__c,Customer_Title__c,Deferral_Notes__c,
        Dependant_Locality__c,Dependent_Thorofare__c,Double_dependant_Locality__c,Duration__c,DVD_Requested__c,
        Effective_From_Date__c,Effective_To_Date__c,Elec_Daily_Data_Opted__c,Elec_Deprogramming_Time__c,
        Elec_HH_Data_Opted__c,End_Appointment_Date__c,End_Time__c,Energisation_Status__c,En_Route_DateTime__c,
        EON_Appointment_ID__c,Expected_Comms_Hub_Serial_Number__c,Expected_IHD_Serial_Number__c,
        E_Check_Meter_Installed__c,E_Check_Meter_Location__c,E_Check_Meter_Make__c,E_Check_Meter_Model__c,
        E_Check_Meter_Serial_Number__c,E_Disconnection_warning_option_flag__c,E_Job_Manually_Deprogrammed__c,
        E_Location_Code__c,E_LowBalanceAlertValue__c,E_Low_balance_alert_flag__c,E_Meter_COP_Dispensation__c,
        E_Meter_COP__c,E_Meter_CT_Ratio__c,E_Meter_Location__c,E_Meter_Make_Model__c,E_Meter_Make__c,
        E_Meter_Model__c,E_Meter_Register_1_ID__c,E_Meter_Register_1_Name__c,E_Meter_Register_1_Type__c,
        E_Meter_Register_2_ID__c,E_Meter_Register_2_Name__c,E_Meter_Register_2_Type__c,
        E_Meter_Register_3_ID__c,E_Meter_Register_3_Name__c,E_Meter_Register_4_ID__c,E_Meter_Register_4_Name__c,
        E_Meter_Register_5_ID__c,E_Meter_Register_5_Name__c,E_Meter_Register_6_ID__c,E_Meter_Register_6_Name__c,
        E_Meter_Reg_1_No_of_dials_digits__c,E_Meter_Reg_2_No_of_dials_digits__c,
        E_Meter_Reg_3_No_of_dials_digits__c,E_Meter_Reg_4_No_of_dials_digits__c,
        E_Meter_Reg_5_No_of_dials_digits__c,E_Meter_Reg_6_No_of_dials_digits__c,
        E_Meter_Serial_Link__c,E_Meter_Serial_Number__c,E_Meter_Type__c,E_Meter_VT_Ratio__c,
        E_Payment_Reminder_Date__c,E_Payment_Reminder_Day_Of_The_Week__c,E_Payment_Reminder_Frequency_Code__c,
        E_Payment_Reminder_Opt_in_Flag__c,E_Top_up_Notification_Opt_in_Flag__c,Fuel_ID__c,
        Gas_bind_performed_flag__c,Gas_Daily_Data_Opted__c,Gas_Deprogramming_Time__c,Gas_HH_Data_Opted__c,
        Gas_Map_Identifier__c,Gas_Market_Participant_ID__c,Gas_Regulator_Serial_Number__c,GSP_Group_ID__c,
        G_Check_Meter_Installed__c,G_Check_Meter_Location__c,G_Check_Meter_Make__c,G_Check_Meter_Model__c,
        G_Check_Meter_Serial_Number__c,G_Disconnection_warning_option_flag__c,G_Effective_From_Date__c,
        G_Effective_To_Date__c,G_Job_Manually_Deprogrammed__c,G_Location_Code__c,G_LowBalanceAlertValue__c,
        G_Low_balance_alert_flag__c,G_Meter_Converter_Asset_Class__c,G_Meter_Converter_Location__c,
        G_Meter_Converter_Manufacturer__c,G_Meter_Converter_Model__c,G_Meter_Converter_Serial_Number__c,
        G_Meter_Location__c,G_Meter_Make_Model__c,G_Meter_Make__c,G_Meter_Measuring_Capacity__c,
        G_Meter_Mechanism__c,G_Meter_Model__c,G_Meter_Multiplication_Factor__c,G_Meter_No_of_dials_digits__c,
        G_Meter_Register_Type__c,G_Meter_Serial_Number__c,G_Meter_Type__c,G_Meter_Units_of_Measure__c,
        G_Meter_Year_of_Manufacture__c,G_Payment_Reminder_Date__c,G_Payment_Reminder_Day_Of_The_Week__c,
        G_Payment_Reminder_Frequency_Code__c,G_Payment_Reminder_Opt_in_Flag__c,
        G_Top_up_Notification_Opt_in_Flag__c,h_aid__c,h_Appointment_Reason__c,h_Cancel_Reason_Key__c,
        h_CountVulnerability__c,H_Customer_type__c,h_Cust_PAYG_flag__c,h_EON_Appointment_Comms__c,
        H_Fuel_Type__c,h_Gas_Metering_Point_Address_Full__c,h_G_MeterMake_Enum_Mapping__c,h_Job_Code__c,
        h_Job_Type__c,h_Metering_Point_Address_Full__c,h_Metering_Pressure__c,
        h_OFSC_Assisted_Work_Reason_Code__c,h_OFSC_E_Check_Meter_Installed__c,h_OFSC_Gas_bind_performed_flag__c,
        h_OFSC_G_Check_Meter_Installed__c,h_OFSC_Install_SED_flag__c,h_OFSC_Metering_Pressure__c,
        h_OFSC_Number_of_Phases__c,h_OFSC_Planned_E_Meter_Type__c,h_OFSC_Planned_G_Meter_Type__c,
        h_OFSC_Planned_Meter_Mode__c,h_OFSC_Planned_Meter_Registers__c,h_SelectRadio__c,Id,
        Install_SED_flag__c,IsDeleted,Job_Code__c,Job_Type__c,JUMBO_Cancel_Reason__c,JUMBO_Contact_Mechanism__c,
        JUMBO_Contact_Value__c,JUMBO_ID__c,Jumbo_Manual_Upload__c,Key_Building_Name__c,Key_Building_Number__c,
        Key_Collection_Required__c,Key_Contact_Number__c,Key_Country__c,Key_County__c,Key_Dependant_Locality__c,
        Key_Dependant_Thorofare__c,Key_Double_Dependant_Locality__c,Key_Person_Name__c,Key_Post_Code__c,
        Key_Sub_Building_Name__c,Key_Thorofare__c,Key_Town__c,Large_Print__c,LastActivityDate,LastModifiedById,
        LastModifiedDate,LastReferencedDate,LastViewedDate,Last_Inspection_Date__c,
        Market_Participant_Abbreviated_Name__c,Market_Participant_ID__c,Metering_Point_Address_Line_1__c,
        Metering_Point_Address_Line_2__c,Metering_Point_Address_Line_3__c,Metering_Point_Address_Line_4__c,
        Metering_Point_Address_Line_5__c,Metering_Point_Address_Line_6__c,Metering_Point_Address_Line_7__c,
        Metering_Point_Address_Line_8__c,Metering_Point_Address_Line_9__c,Metering_Point_Postcode__c,
        Metering_Pressure__c,Metering__c,Meter_Current_Rating__c,Meter_Memory_Location__c,
        Meter_Point_Status_Code__c,MOSE_Hire__c,MPAN__c,MPRN__c,Multiple_Meters_at_Site__c,
        Name,Notes__c,Number_of_Dials_or_Digits__c,Number_of_Phases__c,OFSC_Appointment_ID__c,
        Onsite_DateTime__c,Oracle_Address__c,Oracle_Postcode_Sector__c,Oracle_Postcode__c,Oracle_Town__c,
        Original_JUMBO_ID__c,OwnerId,Parking_Type__c,PAYG_Details_Sent__c,Payment_Method_code__c,Person_Name__c,
        Person_Type_Code__c,Planned_E_Meter_Type__c,Planned_G_Meter_Type__c,Planned_Meter_Mode__c,
        Planned_Meter_Registers__c,Planned_Number_of_Registers__c,Post_Code__c,Post_Town__c,
        Primary_Priority_Service_Contact_Name__c,Primary_Priority_Service_Phone_Number_1__c,
        Primary_Priority_Service_Phone_Number_2__c,Priority_Service_Contact_Address_Line_1__c,
        Priority_Service_Contact_Address_Line_2__c,Priority_Service_Contact_Address_Line_3__c,
        Priority_Service_Contact_Address_Line_4__c,Priority_Service_Contact_Address_Line_5__c,
        Priority_Service_Contact_Address_Line_6__c,Priority_Service_Contact_Address_Line_7__c,
        Priority_Service_Contact_Address_Line_8__c,Priority_Service_Contact_Address_Line_9__c,
        Priority_Service_Contact_Postcode__c,Register_1_TPR_1__c,Register_1_TPR_2__c,Register_2_TPR_1__c,
        Register_2_TPR_2__c,Register_3_TPR_1__c,Register_3_TPR_2__c,Register_4_TPR_1__c,Register_4_TPR_2__c,
        Register_5_TPR_1__c,Register_5_TPR_2__c,Register_6_TPR_1__c,Register_6_TPR_2__c,Requested_SSC__c,
        Request_Date__c,Request_Time__c,Rescheduled_Appointment__c,Sent_to_Oracle_Update__c,Sent_to_Oracle__c,
        Smart_Meter_Scheming_Complete__c,Special_Access__c,Specific_Time_flag__c,Start_Time__c,Status__c,
        SubArea__c,Sub_Building_Name__c,Supplier_Name__c,Supply_Capacity__c,Supply_Voltage__c,Supply__c,
        Suspended_DateTime__c,SystemModstamp,Technician__c,Thorofare__c,Time_Slot__c,
        Timing_Device_Serial_Number__c,Type__c,Update_Electricity_Job__c,Update_Gas_Job__c,
        Vulnerability_Description__c,
    
        (SELECT ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,EON_Appointment_ID__c,
            Id,Inactive__c,IsDeleted,Job_Attribute__c,LastActivityDate,LastModifiedById,LastModifiedDate,
            LastReferencedDate,LastViewedDate,Name,SME_Duration__c, SystemModstamp,Value__c 
            FROM 
            EON_Appointment_Attributes__r
        ),
        
        G_Meter_Mechanism__r.OFS_Enumeration__c, 
        
        Fuel_ID__r.MPAN__c, Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c, Fuel_ID__r.MPRN__c,
        Job_code__r.h_Job_Attribute_Duration__c, Job_code__r.Duration__c, Job_code__r.SME_Duration__c, 
        Job_code__r.Name, Appointment_reason_code__r.OFS_Enumeration__c, 
        Appointment_reason_code__r.Reason_Description__c, E_Meter_Type__r.OFS_Enumeration__c
        FROM 
        EON_Appointment__c 
        where id =: appID];    
    } 
    
    /**
        finish(Database.BatchableContext BC) - finish method of the Batch
    **/
    global void finish(Database.BatchableContext BC){
        //update the import record 'IMP-004' attachment name to processed
        Attachment att = [select id, name from Attachment where id =: attachmentRecID];
        att.Name += '_Processed';
        update att;
        
        //Send email with results
        String userEmail = [select email from User where id=:UserInfo.getUserId()].email;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{}; 
        toAddresses.add(userEmail);
        mail.setToAddresses(toAddresses);
        mail.setSubject('Update Appointment to OFSC Results ' + System.now());
        
        String body = '<html><b> Import Results </b> <br/><br/><table border=1 style="border-collapse: collapse;">';
        body += '<th>PASS Records</th>';        
        //parse the results and make a table
        List<String> lstResultPASS = results_PASS.split('\n');
        for(String resPass : lstResultPASS){
            body += '<tr><td>'+resPass+'</td></tr>';
        }
        body += '</table>';
        
        body += '<br/> <br/><table border=1 style="border-collapse: collapse;">';
        body += '<th>FAIL Records</th>';        
        //parse the results and make a table
        List<String> lstResultFAIL = results_FAIL.split('\n');
        for(String resPass : lstResultFAIL){
            body += '<tr><td>'+resPass+'</td></tr>';
        }
        body += '</table></html>';        
        
        mail.setHtmlBody('' + body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        System.debug('**** Batch is Successfully executed');
    }    
}