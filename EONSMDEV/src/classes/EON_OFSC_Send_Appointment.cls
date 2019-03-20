/**
    Description     : This controller is used to Create Activity in OFSC system for EON, MUS Booking Portal & Jumbo and update activity for MUS Booking Portal.
    Test Class      : EON_OFSC_Send_Appointment_test     
**/
/*
    Created By : Dharmendra Pahadiya
    Created Date : 04-Apr-2016
    Service Request : SR_EON_Scheduling_006 & SR_EON_Scheduling_007
    Change History : 
    CH01 # SR_EON_AB_045 # 16/04/2016 # Dharmendra P # Updated 'SubArea' & 'Duration' fields of EON Appointment if Activity successfully created.
    CH02 # SR_EON_Scheduling_024 # 16/04/2016 # Dharmendra P # Check 'Sent to Oracle' field of EON Appointment on Successful Create Activity 
    CH03 # SR_EON_AB_042 # 16/04/2016 # Dharmendra P # Updated duration calculation logic.
    CH04 # SR_EON_Scheduling_023 # 18/04/2016 # Dharmendra P # Updated field mapping.
    CH05 # SR_EON_Scheduling_025 # 20/04/2016 # Dharmendra P # Updating Sent_to_Oracle_Update__c field for UPDATE activity.
    CH06 # SR_EON_Mobile_031 # 21/04/2016 # Dharmendra P # Updated mapping.
    CH07 # SR_EON_Mobile_034 # 09/05/2016 # Dharmendra P # Added aid to be populated in EON Appointment.
    CH08 # SR_EON_Mobile_042 # 30/05/2016 # Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH09 # SR_EON_Mobile_043 # 07/06/2016 # Dharmendra P # Added/Updated mapping.
    CH10 # SR_EON_Mobile_046 # 08/06/2016 # Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH11 # SR_EON_AB_068 # 22/06/2016 # Puneet Mehta # Added new property mapping.
    CH12 # SR_EON_Mobile_049 # 29/06/2016 # Dharmendra P # Added/Update new mapping.
    CH13 # SR_EON_Mobile_053 # 01/07/2016 # Dharmendra P # Updated mapping enumeration.
    CH14 # SR_EON_AB_087 # 12/07/2016 # Akshay B # Assigned Execption BucketID.
    CH15 # SR_EON_AB_094 # Dharmendra P # Updated mapping for 'XA_ASSET_G_TYPE' OFSC label.
    CH16 # SR_EON_AB_095 # Akshay B # duration calculation when fuel is blank
    CH17 # SR_EON_AB_108  # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text 
    CH18 # SR_EON_Mobile_070 # 05/08/2016 # Purvi # removed check for MS1
    CH19 # SR_EON_Mobile_071 # 05/08/2016 # Purvi # added logic as as per SR.
    CH20 # SR_EON_Mobile_084 # 23/09/2016 # Dharmendra P # Added new enumeartion value for 'XA_ASSET_REGTYPE_NEW_*' tag
    CH21 # SR_EON_Mobile_085 # 05/10/2016 # Akshay Bairagi # Added condition to not send meter mode.
    CH22 # SR_EON_AB_166 # 17-10-2016 # Mahadev J # Cancellation processing at Oracle should be on hold if appointment not created in OFSC via CreateReservation call by EON.
    CH23 # SR_EON_AB_171 #21/10/2016 #Puneet Mehta #On capacity override, send sla_window_start and sla_window_end to OFSC
    CH24 # SR_EON_AB_172 #07/11/2016 #Aruna Manjari # sending logic to XA PHASE also added current_phase field in the query
    CH25 # SR_EON_Mobile_106 # 07/12/2016 # Praveen G #  logic updated to consider if only one register found.
    CH26 # SR_EON_Mobile_111 # 17/12/2016 # Praveen G # added new field to OFSC.
    CH27 # SR_OptiMUS_EON_126 # 03/10/2017 # Praveen G # Added WAN Coverage details send to ORACLE
    CH28 # SR_OptiMUS_EON_306 # 25/02/2019 # Tabish Almas # Added code to correctly populate WAN Coverage details in EON Appointment
*/
global with sharing class EON_OFSC_Send_Appointment {
    public static string toaDateFormat = 'yyyy-MM-dd';

    /**
        sendActivityToOFSC(String AppointmentId, string activityType, string eonTrackerId, string jumboTrackerId, string appDate, string appTime, string bookingSystem) - This method will create/update Activity in OFSC system.
        AppointmentId -- EON Appointment record Id
        activityType -- 'CREATE' or 'UPDATE' based on request to create or update activity
        eonTrackerId -- EON Data Tracker Id
        jumboTrackerId – Jumbo Data Tracker Id
        appDate -- Appointment Date - format should be "2016-04-21"
        appTime -- Appointment Time - format should be "12:00 - 14:00"
        bookingSystem -- Name of System booking apppointment like 'EON' or 'JUMBO' or 'MUS'
    **/
    webservice static string sendActivityToOFSC(String AppointmentId, string activityType, string eonTrackerId, string jumboTrackerId, string appDate, string appTime, string bookingSystem) {
        String result = '';
        Oracle_Data_Tracker__c requestOut = new Oracle_Data_Tracker__c();
        String requestXML = '';
        //Request Elements.
        EON_OFSC_Inbound_WS.UserElement userElement;
        EON_OFSC_Inbound_WS.HeadElement headerElement;
        //response Element
        EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response;

        EON_Appointment__c Appt = [select id,Current_Phase__c, Name, h_Job_Type__c, Fuel_ID__c, Time_Slot__c, MPAN__c, Customer_Name__c, Metering_Point_Postcode__c,
            EON_Appointment_ID__c, Access_Pass_Phrase__c, Assisted_Work_Reason_Code__c, Additional_Information__c, MPRN__c,
            E_Meter_Serial_Number__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c,
            E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c, E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c,
            Certification_Date__c, G_Meter_Serial_Number__c, Gas_Regulator_Serial_Number__c, G_Meter_Make__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c,
            G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c, Requested_SSC__c, //CH10.old
            //Requested_SSC__r.name,//CH10.old
            Key_Collection_Required__c, E_Check_Meter_Location__c, Specific_Time_flag__c, h_G_MeterMake_Enum_Mapping__c, //CH11 //CH19
            Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c,
            Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c, Key_Contact_Number__c, //CH17
            Job_code__r.Name, Job_code__r.h_Job_Attribute_Duration__c, Job_code__r.Duration__c, Job_code__r.SME_Duration__c, Planned_E_Meter_Type__c, //CH12
            Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c, Fuel_ID__r.MPAN__c, Duration__c, SubArea__c, Sent_to_Oracle__c,
            Start_Time__c, End_Time__c, Caller_Name__c, Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c, Oracle_Postcode_Sector__c, Appointment_Date__c, //CH04
            Fuel_ID__r.MPRN__c, h_OFSC_Metering_Pressure__c, h_OFSC_Number_of_Phases__c, h_OFSC_Planned_E_Meter_Type__c, h_OFSC_Planned_G_Meter_Type__c, Planned_G_Meter_Type__c, //CH06
            h_OFSC_Planned_Meter_Registers__c, h_OFSC_Planned_Meter_Mode__c, h_OFSC_Gas_bind_performed_flag__c, h_OFSC_Install_SED_flag__c, //CH06
            h_OFSC_E_Check_Meter_Installed__c, h_OFSC_G_Check_Meter_Installed__c, h_OFSC_Assisted_Work_Reason_Code__c, E_Meter_Type__r.OFS_Enumeration__c, //CH06
            G_Meter_Type__r.OFS_Enumeration__c, Parking_Type__r.OFS_Enumeration__c,
            Appointment_reason_code__r.OFS_Enumeration__c, //CH06
            G_Meter_Location__r.OFS_Enumeration__c, E_Meter_Location__r.OFS_Enumeration__c, Sent_to_Oracle_Update__c, E_Meter_Type__c, G_Meter_Type__c, //CH06
            Notes__c, Certification_Expiry_Date__c, E_Check_Meter_Make__c, E_Check_Meter_Model__c, E_Check_Meter_Location__r.OFS_Enumeration__c, //CH09
            G_Check_Meter_Make__c, G_Check_Meter_Model__c, G_Check_Meter_Location__r.OFS_Enumeration__c, Planned_Number_of_Registers__c, //CH09
            G_Meter_Mechanism__c, G_Meter_Mechanism__r.OFS_Enumeration__c, //CH15
            (select id, name, Contact_Full_Name__c, Media_Detail__c from EON_Appointment_Contacts__r where Contact_Type__r.Code__c = 'A'
                and Media_Type__r.Code__c != 'E'
                order by createdDate desc limit 4), //CH04//CH08//CH24
            (select id, name, h_Vulnerability_Desc__c from EON_Appointment_Vulnerabilities__r),
            G_Meter_No_of_dials_digits__c // CH26
            
          //CH27.Start
          , CSP_Region__c, Comms_Hub_Variant__c, Connectivity_Likelihood__c,
          Auxiliary_Equipment_required__c, WAN_Additional_Information__c,
          
          Fuel_ID__r.Premise__r.CSP_Region__c, Fuel_ID__r.Premise__r.Comms_Hub_Variant__c, 
          Fuel_ID__r.Premise__r.Connectivity_Likelihood__c,
          Fuel_ID__r.Premise__r.Coverage_Availability__c,    //CH28
          Fuel_ID__r.Premise__r.Auxiliary_Equipment_required__c, Fuel_ID__r.Premise__r.Additional_Information__c            
          //CH27.End            
            from EON_Appointment__c where id = : AppointmentId
        ];

        EON_OFSC_Inbound_WS.DataElement dataElement = new EON_OFSC_Inbound_WS.DataElement();
        //CH01.start
        integer dur = 0;
        string subArea = '';
        //CH01.end
        string aid = ''; //CH07
        try {
            //Request Elements.
            userElement = EON_OFSC_Helper.getInboundUserElement(); //getUserElement();
            headerElement = EON_OFSC_Helper.getHeaderElement(); //getHeaderElement();

            system.debug('$$$ Appointent Id: ' + Appt.Id + ' APP Name: ' + Appt.Name);
            system.debug('$$$ bookingSystem: ' + bookingSystem);
            system.debug('$$$ activityType: ' + activityType);

            requestOut.Command__c = (activityType == 'CREATE' ? EON_Utility.CMD_OFSC_CreateActivity : EON_Utility.CMD_OFSC_UpdateActivity); //'Create Activity':'Update Activity');
            requestOut.Direction__c = EON_Utility.DIRECTION_OUT; //'OUT';
            requestOut.h_Booking_System_Name__c = string.isNotBlank(bookingSystem) ? (bookingSystem.length() < 255 ? bookingSystem : bookingSystem.substring(0, 254)) : '';
            requestOut.EON_Appointment__c = Appt.Id;
            requestOut.Transaction_ID__c = Appt.Id;
            if (string.isNotBlank(eonTrackerId)) requestOut.EON_Data_Tracker__c = eonTrackerId;
            if (string.isNotBlank(jumboTrackerId)) requestOut.JUMBO_Data_Tracker__c = jumboTrackerId;

            //CH12.start - Get SSC records
            string sscName = checkNullBlank(Appt.Requested_SSC__c);
            string mtrType = Appt.Planned_E_Meter_Type__c;
            string G_mtrType = Appt.Planned_G_Meter_Type__c;
            system.debug('@@@ sscName: ' + sscName);
            system.debug('@@@ mtrType: ' + mtrType);
            list < EON_SSC_Register__c > lstSSCReg = new list < EON_SSC_Register__c > ();
            if (string.isNotBlank(sscName)) {
                list < EON_SSC__c > lstSSC = new list < EON_SSC__c > ([select id, name, Type__c, (select id, name, Register_ID__c, TPR__c from EON_SSC_Registers__r) from EON_SSC__c where name = : sscName]);
                system.debug('@@@ retrieved ssc records: ' + lstSSC.size());
                
                /*
                if (!lstSSC.isEmpty() && lstSSC.size() == 1) {
                    lstSSCReg.addall(lstSSC[0].EON_SSC_Registers__r);
                } else {COmmented as part of the change CH25*/
                                
                    //system.debug('@@@ mtrType.containsignorecase(MS1): '+mtrType.containsignorecase('MS1'));
                    if (string.isNotBlank(mtrType) && mtrType.containsignorecase('MS1')) {
                        for (EON_SSC__c objSSC: lstSSC) {
                            //system.debug('@@@ objSSC.Type__c: '+objSSC.Type__c);
                            if (objSSC.Type__c == 'Smart') {
                                lstSSCReg.addall(objSSC.EON_SSC_Registers__r);
                                break;
                            }
                        }
                    } else {
                        for (EON_SSC__c objSSC: lstSSC) {
                            if (objSSC.Type__c == 'Classic') {
                                lstSSCReg.addall(objSSC.EON_SSC_Registers__r);
                                break;
                            }
                        }
                    }
                //}
            }
            system.debug('@@@ SSC reg size: ' + lstSSCReg.size());
            //CH12.end

            //get bucket Id
            //CH04 //string postcode = string.isNotBlank(Appt.Post_Code__c)?Appt.Post_Code__c.substring(0,5):''; //stting.isNotBlank(Appt.Post_Code__c)
            string postcode = string.isNotBlank(Appt.Oracle_Postcode_Sector__c) ? Appt.Oracle_Postcode_Sector__c : '';
            string JobType = string.isNotBlank(Appt.h_Job_Type__c) ? Appt.h_Job_Type__c : '';
            system.debug('@@@ JobType: ' + JobType);
            string bucketId = '';

            system.debug('@@@ postcode: ' + postcode);
            list < EON_Post_Code__c > lstPC = new list < EON_Post_Code__c > ([select id, name, h_sub_area_checkbox__c, Sub_Area_Name__r.Id, Sub_Area_Name__r.Oracle_Bucket_ID__c from EON_Post_Code__c where name = : postcode]);
            system.debug('@@@ lstPC: ' + lstPC.size());
            for (EON_Post_Code__c objPC: lstPC) {
                string check = string.isNotBlank(objPC.h_sub_area_checkbox__c) ? objPC.h_sub_area_checkbox__c : '';
                if (JobType != '' && check != '' && check.containsIgnoreCase(JobType)) {
                    bucketId = objPC.Sub_Area_Name__r.Oracle_Bucket_ID__c;
                    subArea = objPC.Sub_Area_Name__r.Id; //CH01
                    system.debug('$$$ subArea: ' + subArea);
                }
            }
            //CH14.Start
            if (bucketId == '')
                bucketId = system.label.EON_Exception_BucketID;
            //CH14.End  
            //get Vulnerabilities
            string vulnerabilites = '';
            for (EON_Appointment_Vulnerability__c objVul: Appt.EON_Appointment_Vulnerabilities__r) {
                if (vulnerabilites == '')
                    vulnerabilites = objVul.h_Vulnerability_Desc__c;
                else
                    vulnerabilites = vulnerabilites + ', ' + objVul.h_Vulnerability_Desc__c;
                //vulnerabilites = vulnerabilites + objVul.h_Vulnerability_Desc__c+', ';
            }
            //get Duration
            string duration = '';
            if (activityType == 'UPDATE' && Appt.Key_Collection_Required__c) {
                dur = dur + 15;
            }

            //CH03.start
            //CH16.start
            if (activityType == 'UPDATE') {
                if (Appt.Fuel_ID__c != null) {
                    if (Appt.Fuel_ID__r.MPAN__c == Appt.MPAN__c) {
                        if (Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'RES')
                            dur = dur + Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c != null ? Appt.Job_code__r.h_Job_Attribute_Duration__c : 0) + (Appt.Job_code__r.Duration__c != null ? Appt.Job_code__r.Duration__c : 0));
                        else if (Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'SME')
                            dur = dur + Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c != null ? Appt.Job_code__r.h_Job_Attribute_Duration__c : 0) + (Appt.Job_code__r.SME_Duration__c != null ? Appt.Job_code__r.SME_Duration__c : 0));
                    } else if (Appt.Fuel_ID__r.MPRN__c == Appt.MPRN__c) {
                        if (Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'RES')
                            dur = dur + Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c != null ? Appt.Job_code__r.h_Job_Attribute_Duration__c : 0) + (Appt.Job_code__r.Duration__c != null ? Appt.Job_code__r.Duration__c : 0));
                        else if (Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'SME')
                            dur = dur + Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c != null ? Appt.Job_code__r.h_Job_Attribute_Duration__c : 0) + (Appt.Job_code__r.SME_Duration__c != null ? Appt.Job_code__r.SME_Duration__c : 0));
                    }
                } else {
                    dur = dur + Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c != null ? Appt.Job_code__r.h_Job_Attribute_Duration__c : 0) + (Appt.Job_code__r.Duration__c != null ? Appt.Job_code__r.Duration__c : 0));
                }
            }
            //CH16.End
            //CH03.start

            if (activityType == 'CREATE' && (Appt.Job_code__r.h_Job_Attribute_Duration__c != null || Appt.Job_code__r.Duration__c != null))
                dur = Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c != null ? Appt.Job_code__r.h_Job_Attribute_Duration__c : 0) + (Appt.Job_code__r.Duration__c != null ? Appt.Job_code__r.Duration__c : 0));
            //duration = string.valueOf(Appt.Job_code__r.h_Job_Attribute_Duration__c + Appt.Job_code__r.Duration__c);

            if (dur != 0)
                duration = string.valueof(dur);
            system.debug('$$$ duration: ' + duration);

            //------------- Create Data element ----------------------

            //Create appointment Element
            EON_OFSC_Inbound_WS.AppointmentElement appointmentElement = new EON_OFSC_Inbound_WS.AppointmentElement();
            appointmentElement.appt_number = Appt.Id;
            //appointmentElement.appt_number = '587231588708737167420161107152254';
            appointmentElement.duration = duration; ///'60'
            appointmentElement.worktype_label = string.isNotBlank(Appt.Job_code__c) ? Appt.Job_code__r.Name : '';
            system.debug('@@@ MUS appDate: ' + appDate);
            system.debug('@@@ MUS appTime: ' + appTime);
            appointmentElement.time_slot = checkNullBlank((bookingSystem != 'MUS' ? Appt.Time_Slot__c : appTime)); // like 12:00 - 14:00
            system.debug('$$$ time_slot: ' + appointmentElement.time_slot);
            //CH04.New.start
            //CH06.New.start
            string startTime = string.isNotBlank(Appt.Start_Time__c) ? Appt.Start_Time__c : '';
            appointmentElement.sla_window_start = (Appt.Appointment_Date__c != null && startTime != '' ? string.valueOf(Appt.Appointment_Date__c) + ' ' + Appt.Start_Time__c : '');
            system.debug('$$$ sla_window_start: ' + appointmentElement.sla_window_start);
            string endTime = '';
            try {
                if (Appt.Appointment_Date__c != null && startTime != '' && Appt.End_Time__c != '' && Appt.End_Time__c.length() > 2 && startTime.length() > 2) {
                    integer sHr = integer.valueOf(startTime.left(2));
                    integer eHr = integer.valueOf(Appt.End_Time__c.left(2));
                    integer i = sHr - eHr;
                    date endDate = Appt.Appointment_Date__c;
                    if (i > 0) endDate = Appt.Appointment_Date__c.addDays(1);
                    endTime = string.valueOf(endDate) + ' ' + Appt.End_Time__c;
                }
            } catch (exception e) {
                system.debug('### end date conversion error: ' + e.getMessage() + '\n' + e.getStackTraceString());
            }
            appointmentElement.sla_window_end = endTime; //convertDateToOFSCFormat(Appt.End_Time__c); 
            system.debug('$$$ sla_window_end: ' + endTime);
            //CH06.New.End
            appointmentElement.name = Appt.Caller_Name__c;
            appointmentElement.address = Appt.Oracle_Address__c;
            appointmentElement.city = Appt.Oracle_Town__c;
            appointmentElement.zip = Appt.Oracle_Postcode__c;
            system.debug('$$$ appointmentElement: ' + appointmentElement);
            //CH04.New.End

            //Property Element
            List < EON_OFSC_Inbound_WS.PropertyElement > property_elements = new List < EON_OFSC_Inbound_WS.PropertyElement > ();
            EON_OFSC_Inbound_WS.PropertyElement property_element = new EON_OFSC_Inbound_WS.PropertyElement();

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_APPT_NOTES';
            property_element.value = checkNullBlank(Appt.Notes__c);
            system.debug('@@@ XA_APPT_NOTES Value: ' + property_element.value);
            property_elements.add(property_element);
            
            //CH27.Start
            
            //calculate values
            String CSPRegion = '';
            String commsHUBVarient = '';
            String connectivityLikelyHood = '';
            String coverageAvailability = '';    //CH28
                        
            if(subArea != ''){
                EON_Sub_Area__c[] lstArea = [select id, Region_Name__r.CSP_Region__c,
                                                Region_Name__r.Comms_Hub_Variant__c,
                                                Region_Name__r.Connectivity_Likelihood__c,
                                                Region_Name__r.Coverage_Availability__c    //CH28
                                             from EON_Sub_Area__c where id =:subArea];
                System.debug('****Shruti*******Lstsubarea--->'+lstArea);                             
                if(!lstArea.isEmpty()){                                             
                    CSPRegion = lstArea[0].Region_Name__r.CSP_Region__c;
                    commsHUBVarient = lstArea[0].region_Name__r.Comms_Hub_Variant__c;
                    connectivityLikelyHood = lstArea[0].Region_Name__r.Connectivity_Likelihood__c;
                    coverageAvailability = lstArea[0].Region_Name__r.Coverage_Availability__c;  //CH28
                }
            }
                        
            String CSP_Region= '';
            if(!String.isblank(appt.Fuel_ID__r.Premise__r.CSP_Region__c))
                CSP_Region = appt.Fuel_ID__r.Premise__r.CSP_Region__c;
            else if(String.isNotBlank(CSPRegion))    //CH28
                CSP_Region = CSPRegion;
            else
                CSP_Region = 'SOUTH';        

            String Comms_Hub_Variant = '';
            if(!String.isblank(appt.Fuel_ID__r.Premise__r.Comms_Hub_Variant__c))
                Comms_Hub_Variant  = appt.Fuel_ID__r.Premise__r.Comms_Hub_Variant__c;
            else if(!String.isBlank(commsHUBVarient))  //CH28
                 Comms_Hub_Variant = commsHUBVarient;
            else 
                 Comms_Hub_Variant = 'CELLULAR';          
                
            String Connectivity_Likelihood= '';
            if(!String.isblank(appt.Fuel_ID__r.Premise__r.Connectivity_Likelihood__c))
                Connectivity_Likelihood = appt.Fuel_ID__r.Premise__r.Connectivity_Likelihood__c;
            else if(!String.isBlank(connectivityLikelyHood))  //CH28
                Connectivity_Likelihood = connectivityLikelyHood ;
            else
                Connectivity_Likelihood = 'MEDIUM';   
                    
            //CH28.Start
            String Coverage_Availability= '';
            if(!String.isblank(appt.Fuel_ID__r.Premise__r.Coverage_Availability__c))
                Coverage_Availability = appt.Fuel_ID__r.Premise__r.Coverage_Availability__c;
            else if(!String.isBlank(coverageAvailability))
                Coverage_Availability = coverageAvailability ;
            else
                Coverage_Availability = 'Y';  
            //CH28.End
            
            String Auxiliary_Equipment_required= '';
            if(appt.Fuel_ID__r.Premise__r.Auxiliary_Equipment_required__c!= null)
                Auxiliary_Equipment_required = appt.Fuel_ID__r.Premise__r.Auxiliary_Equipment_required__c; 
                
            String Additional_Information= '';
            if(appt.Fuel_ID__r.Premise__r.Additional_Information__c!= null)
                Additional_Information = appt.Fuel_ID__r.Premise__r.Additional_Information__c;                                                             
                
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_REGION';
            property_element.value = checkNullBlank(CSP_Region);
            system.debug('@@@ XA_ASSET_H_REGION '+property_element.value);
            property_elements.add(property_element); 
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_REQ';
            property_element.value = checkNullBlank(Comms_Hub_Variant);
            system.debug('@@@ XA_ASSET_H_REQ '+property_element.value);
            property_elements.add(property_element);  
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_CON_HOOD';
            property_element.value = checkNullBlank(Connectivity_Likelihood);
            system.debug('@@@ XA_ASSET_H_CON_HOOD '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_AUX';
            property_element.value = checkNullBlank(Auxiliary_Equipment_required);
            system.debug('@@@ XA_ASSET_H_AUX '+property_element.value);
            property_elements.add(property_element); 
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_ADD_INFO';
            property_element.value = checkNullBlank(Additional_Information);
            system.debug('@@@ XA_ASSET_H_ADD_INFO '+property_element.value);
            property_elements.add(property_element);                                                                                                                  
            //CH27.End            
            
            //CH28.Start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_COV_AVAIL';
            property_element.value = checkNullBlank(Coverage_Availability);
            system.debug('@@@ XA_ASSET_H_COV_AVAIL '+property_element.value);
            property_elements.add(property_element);
            //CH28.End
            
            //CH26.Start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_NO_DIG';
            property_element.value = (Appt.G_Meter_No_of_dials_digits__c != null) ? (Appt.G_Meter_No_of_dials_digits__c + '') : '';
            system.debug('@@@ XA_ASSET_G_NO_DIG Value: ' + property_element.value);
            property_elements.add(property_element);            
            //CH26.Start


            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_Morrison_ID';
            property_element.value = Appt.Name;
            system.debug('@@@ XA_Morrison_ID Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_EON_ID';
            property_element.value = checkNullBlank(Appt.EON_Appointment_ID__c);
            system.debug('@@@ XA_EON_ID Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PARKING';
            property_element.value = (string.isNotBlank(Appt.Parking_Type__c) && Appt.Parking_Type__r.OFS_Enumeration__c != 0.0 ? checkNullBlank(string.valueOf(Appt.Parking_Type__r.OFS_Enumeration__c)) : ''); //CH06
            system.debug('@@@ XA_PARKING Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PASSPHRASE';
            property_element.value = checkNullBlank(Appt.Access_Pass_Phrase__c); //Appt.Access_Pass_Phrase__c
            system.debug('@@@ XA_PASSPHRASE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_VULNERABLE';
            property_element.value = vulnerabilites;
            system.debug('@@@ XA_VULNERABLE Value: ' + property_element.value);
            property_elements.add(property_element);

            //CH04.new
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_APPOINTMENT_REASON';
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_APPOINTMENT_REASON')!=null?mapOFSCCodes.get('XA_APPOINTMENT_REASON').get(Appt.Appointment_reason_code__r.Reason_Description__c):'');
            property_element.value = (Appt.Appointment_reason_code__c != null && Appt.Appointment_reason_code__r.OFS_Enumeration__c != null ? checkNullBlank(string.valueOf(Appt.Appointment_reason_code__r.OFS_Enumeration__c)) : ''); //CH06
            system.debug('@@@ XA_APPOINTMENT_REASON Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSIST_REASON';
            //CH06.old //property_element.value = Appt.Assisted_Work_Reason_Code__c;
            property_element.value = checkNullBlank(Appt.h_OFSC_Assisted_Work_Reason_Code__c); //CH06
            system.debug('@@@ XA_ASSIST_REASON Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty() && Appt.EON_Appointment_Contacts__r.size() > 0) ? checkNullBlank(Appt.EON_Appointment_Contacts__r[0].Contact_Full_Name__c) : '');
            system.debug('@@@ XA_CONTACT_NAME Value: ' + property_element.value);
            property_elements.add(property_element);

            //CH04.New.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty() && Appt.EON_Appointment_Contacts__r.size() > 0) ? checkNullBlank(Appt.EON_Appointment_Contacts__r[0].Media_Detail__c) : '');
            system.debug('@@@ XA_CONTACT_NUMBER Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME_2';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty() && Appt.EON_Appointment_Contacts__r.size() > 1) ? checkNullBlank(Appt.EON_Appointment_Contacts__r[1].Contact_Full_Name__c) : '');
            system.debug('@@@ XA_CONTACT_NAME_2 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER_2';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty() && Appt.EON_Appointment_Contacts__r.size() > 1) ? checkNullBlank(Appt.EON_Appointment_Contacts__r[1].Media_Detail__c) : '');
            system.debug('@@@ XA_CONTACT_NUMBER_2 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME_3';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty() && Appt.EON_Appointment_Contacts__r.size() > 2) ? checkNullBlank(Appt.EON_Appointment_Contacts__r[2].Contact_Full_Name__c) : '');
            system.debug('@@@ XA_CONTACT_NAME_3 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER_3';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty() && Appt.EON_Appointment_Contacts__r.size() > 2) ? checkNullBlank(Appt.EON_Appointment_Contacts__r[2].Media_Detail__c) : '');
            system.debug('@@@ XA_CONTACT_NUMBER_3 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME_4';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty() && Appt.EON_Appointment_Contacts__r.size() > 3) ? checkNullBlank(Appt.EON_Appointment_Contacts__r[3].Contact_Full_Name__c) : '');
            system.debug('@@@ XA_CONTACT_NAME_4 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER_4';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty() && Appt.EON_Appointment_Contacts__r.size() > 3) ? checkNullBlank(Appt.EON_Appointment_Contacts__r[3].Media_Detail__c) : '');
            system.debug('@@@ XA_CONTACT_NUMBER_4 Value: ' + property_element.value);
            property_elements.add(property_element);
            //CH04.New.end
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_POSTCODE_SECTOR';
            property_element.value = checkNullBlank(Appt.Oracle_Postcode_Sector__c); //CH04.New
            system.debug('@@@ XA_POSTCODE_SECTOR Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ADDITIONAL_INFO';
            property_element.value = checkNullBlank(Appt.Additional_Information__c);
            system.debug('@@@ XA_ADDITIONAL_INFO Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_MPAN_NUMBER';
            property_element.value = checkNullBlank(Appt.MPAN__c);
            system.debug('@@@ XA_MPAN_NUMBER Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_MPRN_NUMBER';
            property_element.value = checkNullBlank(Appt.MPRN__c);
            system.debug('@@@ XA_MPRN_NUMBER Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PRESSURE';
            property_element.value = checkNullBlank(Appt.h_OFSC_Metering_Pressure__c); //CH06
            system.debug('@@@ XA_PRESSURE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PHASE';
             //CH24.start
            if(Appt.Current_Phase__c!=null && Appt.Current_Phase__c!= '' && Appt.Current_Phase__c=='3Ph')
            property_element.value = '2';//Ch24.Stop
            else 
            property_element.value = checkNullBlank(Appt.h_OFSC_Number_of_Phases__c); //CH06
            system.debug('@@@ XA_PHASE Value: ' + property_element.value);
            property_elements.add(property_element);

            //Electric Meter specific info
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_MSN';
            property_element.value = checkNullBlank(Appt.E_Meter_Serial_Number__c);
            system.debug('@@@ XA_ASSET_E_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_TYPE';
            property_element.value = (Appt.E_Meter_Type__c != null && Appt.E_Meter_Type__r.OFS_Enumeration__c != 0.0 ? checkNullBlank(string.valueOf(Appt.E_Meter_Type__r.OFS_Enumeration__c)) : ''); //CH06 
            system.debug('@@@ XA_ASSET_E_TYPE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_LOCATION';
            property_element.value = (Appt.E_Meter_Location__c != null && Appt.E_Meter_Location__r.OFS_Enumeration__c != 0.0 ? checkNullBlank(string.valueOf(Appt.E_Meter_Location__r.OFS_Enumeration__c)) : ''); //CH06
            system.debug('@@@ XA_ASSET_E_LOCATION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_MANFCT';
            property_element.value = checkNullBlank(Appt.E_Meter_Make__c);
            system.debug('@@@ XA_ASSET_E_MANFCT Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_VERSION';
            property_element.value = checkNullBlank(Appt.E_Meter_Model__c);
            system.debug('@@@ XA_ASSET_E_VERSION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_1_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID2';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_2_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID2 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID3';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_3_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID3 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID4';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_4_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID4 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID5';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_5_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID5 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID6';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_6_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID6 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_CERTDT';
            property_element.value = convertDateToOFSCFormat(Appt.Certification_Date__c);
            system.debug('@@@ XA_ASSET_E_CERTDT Value: ' + property_element.value);
            property_elements.add(property_element);

            //CH09.new.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_CERTEXPDT';
            property_element.value = convertDateToOFSCFormat(Appt.Certification_Expiry_Date__c);
            system.debug('@@@ XA_ASSET_E_CERTEXPDT Value: ' + property_element.value);
            property_elements.add(property_element);
            //CH09.new.end

            //Gas meter information
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_MSN';
            property_element.value = checkNullBlank(Appt.G_Meter_Serial_Number__c);
            system.debug('@@@ XA_ASSET_G_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_TYPE';
            property_element.value = (Appt.G_Meter_Mechanism__c != null && Appt.G_Meter_Mechanism__r.OFS_Enumeration__c != null ? checkNullBlank(string.valueOf(Appt.G_Meter_Mechanism__r.OFS_Enumeration__c)) : ''); //CH15
            system.debug('@@@ XA_ASSET_G_TYPE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_LOCATION';
            property_element.value = (Appt.G_Meter_Location__c != null && Appt.G_Meter_Location__r.OFS_Enumeration__c != null ? checkNullBlank(string.valueOf(Appt.G_Meter_Location__r.OFS_Enumeration__c)) : ''); //CH06
            system.debug('@@@ XA_ASSET_G_LOCATION Value: ' + property_element.value);
            property_elements.add(property_element);
            
            /** Praveen Commented
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_MAKE'; //CH19       
            property_element.value = checkNullBlank(Appt.h_G_MeterMake_Enum_Mapping__c); //CH19
            system.debug('@@@ XA_ASSET_G_MAKE Value: ' + property_element.value);
            property_elements.add(property_element);
            **/
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_VERSION';
            property_element.value = checkNullBlank(Appt.G_Meter_Model__c);
            system.debug('@@@ XA_ASSET_G_VERSION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_MSN';
            property_element.value = checkNullBlank(Appt.E_Check_Meter_Serial_Number__c);
            system.debug('@@@ XA_ASSET_EC_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            //CH09.new.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_MANFCT';
            property_element.value = checkNullBlank(Appt.E_Check_Meter_Make__c);
            system.debug('@@@ XA_ASSET_EC_MANFCT Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_VERSION';
            property_element.value = checkNullBlank(Appt.E_Check_Meter_Model__c);
            system.debug('@@@ XA_ASSET_EC_VERSION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_LOCATION';
            property_element.value = (Appt.E_Check_Meter_Location__c != null && Appt.E_Check_Meter_Location__r.OFS_Enumeration__c != null ? checkNullBlank(string.valueOf(Appt.E_Check_Meter_Location__r.OFS_Enumeration__c)) : '');
            system.debug('@@@ XA_ASSET_EC_LOCATION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_MANFCT';
            property_element.value = checkNullBlank(Appt.G_Check_Meter_Make__c);
            system.debug('@@@ XA_ASSET_GC_MANFCT Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_VERSION';
            property_element.value = checkNullBlank(Appt.G_Check_Meter_Model__c);
            system.debug('@@@ XA_ASSET_GC_VERSION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_LOCATION';
            property_element.value = (Appt.G_Check_Meter_Location__c != null && Appt.G_Check_Meter_Location__r.OFS_Enumeration__c != null ? checkNullBlank(string.valueOf(Appt.G_Check_Meter_Location__r.OFS_Enumeration__c)) : '');
            system.debug('@@@ XA_ASSET_GC_LOCATION Value: ' + property_element.value);
            property_elements.add(property_element);
            //CH09.new.end

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_MSN';
            property_element.value = checkNullBlank(Appt.G_Check_Meter_Serial_Number__c);
            system.debug('@@@ XA_ASSET_GC_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            //Asset Details - Comms Hub
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_MSN';
            property_element.value = checkNullBlank(Appt.Expected_Comms_Hub_Serial_Number__c);
            system.debug('@@@ XA_ASSET_H_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            // Asset Details - IHD/SED
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_I_MSN';
            property_element.value = checkNullBlank(Appt.Expected_IHD_Serial_Number__c);
            system.debug('@@@ XA_ASSET_I_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            //New Meter details
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ELEC_METER_TYPE';
            property_element.value = checkNullBlank(Appt.h_OFSC_Planned_E_Meter_Type__c); //CH06
            system.debug('@@@ XA_ELEC_METER_TYPE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_GAS_METER_TYPE';
            property_element.value = checkNullBlank(Appt.h_OFSC_Planned_G_Meter_Type__c); //CH06
            system.debug('@@@ XA_GAS_METER_TYPE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_TARIFF_NEW';
            property_element.value = checkNullBlank(Appt.h_OFSC_Planned_Meter_Registers__c); //CH06
            system.debug('@@@ XA_ASSET_E_TARIFF_NEW Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_SSC_NEW';
            property_element.value = checkNullBlank(Appt.Requested_SSC__c); //CH08.old
            system.debug('@@@ XA_ASSET_E_SSC_NEW Value: ' + property_element.value);
            property_elements.add(property_element);

            //CH09.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_NOREG_NEW';
            property_element.value = checkNullBlank(Appt.Planned_Number_of_Registers__c);
            system.debug('@@@ XA_ASSET_E_NOREG_NEW Value: ' + property_element.value);
            property_elements.add(property_element);
            //CH09.end

            //CH04.New.start
            //CH21.Start
            if (!(mtrType == 'MCL' || mtrType == 'KEY' || G_mtrType == 'MCL' || G_mtrType == 'PP')) {
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_E_MODE_NEW';
                property_element.value = checkNullBlank(Appt.h_OFSC_Planned_Meter_Mode__c); //CH06
                system.debug('@@@ XA_ASSET_E_MODE_NEW Value: ' + property_element.value);
                property_elements.add(property_element);
            }
            //CH21.End
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_GAS_BIND';
            property_element.value = checkNullBlank(Appt.h_OFSC_Gas_bind_performed_flag__c); //CH06
            system.debug('@@@ XA_GAS_BIND Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_INSTALL_SED';
            property_element.value = checkNullBlank(Appt.h_OFSC_Install_SED_flag__c); //CH06
            system.debug('@@@ XA_INSTALL_SED Value: ' + property_element.value);
            property_elements.add(property_element);
            //CH04.New.end

            //Key collection
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY';
            //CH12.start
            string keyCol = '';
            if (Appt.Key_Collection_Required__c != null)
                keyCol = Appt.Key_Collection_Required__c ? 'Yes' : 'No';
            property_element.value = keyCol;
            //CH12.end
            system.debug('@@@ XA_KEY Value: ' + property_element.value);
            property_elements.add(property_element);

            //SSC related information
            //CH12.start
            integer j = 1;
            map < string, string > mapRegNameOFSVal = new map < string, string > {
                'EXPORT' => '1', 'NORMAL' => '2', 'LOW' => '3', 'EVENING WEEKEND' => '4', 'RATE 1' => '5', 'RATE 2' => '6',
                'RATE 3' => '7', 'RATE 4' => '8', 'RATE 5' => '9', 'RATE 6' => '10', 'TOTAL' => '11'
            }; //TOTAL //CH13 //CH20
            for (EON_SSC_Register__c objReg: lstSSCReg) {
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_REGTYPE_NEW_' + j;
                property_element.value = mapRegNameOFSVal.containsKey(objReg.Name.toUpperCase()) ? mapRegNameOFSVal.get(objReg.Name.toUpperCase()) : ''; //CH13
                system.debug('@@@ XA_ASSET_REGTYPE_NEW_' + j + ': ' + property_element.value);
                property_elements.add(property_element);
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_E_REG_ID_NEW_' + j;
                property_element.value = checkNullBlank(objReg.Register_ID__c);
                system.debug('@@@ XA_ASSET_E_REG_ID_NEW_' + j + ': ' + property_element.value);
                property_elements.add(property_element);
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_E_TPR' + j + '_NEW';
                property_element.value = checkNullBlank(objReg.TPR__c);
                system.debug('@@@ XA_ASSET_E_TPR' + j + '_NEW: ' + property_element.value);
                property_elements.add(property_element);
                j++;
                if (j > 6) break; //CH18
            }
            //CH12.end

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_PERSON';
            property_element.value = checkNullBlank(Appt.Key_Person_Name__c);
            system.debug('@@@ XA_KEY_PERSON Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_BUILD_NAME';
            property_element.value = checkNullBlank(Appt.Key_Building_Name__c);
            system.debug('@@@ XA_KEY_BUILD_NAME Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_BUILD_NO';
            property_element.value = checkNullBlank(Appt.Key_Building_Number__c);
            system.debug('@@@ XA_KEY_BUILD_NO Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_SUB_BUILD';
            property_element.value = checkNullBlank(Appt.Key_Sub_Building_Name__c);
            system.debug('@@@ XA_KEY_SUB_BUILD Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_THOROFARE';
            property_element.value = checkNullBlank(Appt.Key_Thorofare__c);
            system.debug('@@@ XA_KEY_THOROFARE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_D_THOROFARE';
            property_element.value = checkNullBlank(Appt.Key_Dependant_Thorofare__c);
            system.debug('@@@ XA_KEY_D_THOROFARE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_D_LOC';
            property_element.value = checkNullBlank(Appt.Key_Dependant_Locality__c);
            system.debug('@@@ XA_KEY_D_LOC Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_TOWN';
            property_element.value = checkNullBlank(Appt.Key_Town__c);
            system.debug('@@@ XA_KEY_TOWN Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_COUNTY';
            property_element.value = checkNullBlank(Appt.Key_County__c);
            system.debug('@@@ XA_KEY_COUNTY Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_POSTCODE';
            property_element.value = checkNullBlank(Appt.Key_Post_Code__c);
            system.debug('@@@ XA_KEY_POSTCODE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_CONTACT_NO';
            property_element.value = checkNullBlank(string.valueof(Appt.Key_Contact_Number__c)); //CH17
            system.debug('@@@ XA_KEY_CONTACT_NO Value: ' + property_element.value);
            property_elements.add(property_element);
            
            //Praveen Added start
            Map<String, String> GMeterMakeEnum = new Map<String, String>{'UNK'=>'1', //CH19
                                                'ACT'=>'7',
                                                'AGS'=>'6',
                                                'AM'=>'8',
                                                'AMC'=>'9',
                                                'AS'=>'10',
                                                'BGL'=>'11',
                                                'BGW'=>'12',
                                                'BMM'=>'82',
                                                'BRA'=>'13',
                                                'BW'=>'14',
                                                'CHE'=>'16',
                                                'COM'=>'83',
                                                'CVM'=>'18',
                                                'CMN'=>'3',
                                                'DAN'=>'98',
                                                'DEL'=>'19',
                                                'DG'=>'84',
                                                'DGM'=>'85',
                                                'DR'=>'20',
                                                'ELG'=>'96',
                                                'EMI'=>'22',
                                                'EUR'=>'23',
                                                'EXI '=>'94',
                                                'FLA'=>'24',
                                                'FLN'=>'99',
                                                'GG'=>'25',
                                                'GL'=>'27',
                                                'GM'=>'26',
                                                'GMC'=>'29',
                                                'GW'=>'30',
                                                'HIL'=>'31',
                                                'HOC'=>'32',
                                                'IGA'=>'33',
                                                'IGT'=>'34',
                                                'IMA'=>'35',
                                                'INS'=>'36',
                                                'INV'=>'80',
                                                'ITR'=>'4',
                                                'JEA'=>'39',
                                                'JR'=>'40',
                                                'KRO'=>'41',
                                                'LG '=>'42',
                                                'LPG'=>'43',
                                                'MAG'=>'44',
                                                'MET'=>'45',
                                                'ML'=>'46',
                                                'MM'=>'47',
                                                'MTK'=>'88',
                                                'MTL'=>'48',
                                                'MTN'=>'89',
                                                'MTX'=>'100',
                                                'NFC'=>'49',
                                                'NP'=>'101',
                                                'OMN'=>'92',
                                                'ONS'=>'5',
                                                'ORM'=>'51',
                                                'OT'=>'81',
                                                'PC'=>'52',
                                                'PCC'=>'53',
                                                'PCU'=>'54',
                                                'PE'=>'55',
                                                'PH'=>'56',
                                                'PRI '=>'2',
                                                'RCK'=>'57',
                                                'RMG'=>'58',
                                                'ROM'=>'59',
                                                'ROO'=>'60',
                                                'RPB'=>'61',
                                                'SAR'=>'97',
                                                'SCH'=>'62',
                                                'SEN'=>'90',
                                                'SGR'=>'63',
                                                'SIE'=>'64',
                                                'SM'=>'65',
                                                'SOL'=>'91',
                                                'SP'=>'66',
                                                'STH'=>'67',
                                                'TAC'=>'87',
                                                'TB'=>'68',
                                                'TEC'=>'93',
                                                'TG'=>'69',
                                                'UGI'=>'70',
                                                'UWL'=>'95',
                                                'VAL'=>'71',
                                                'VAN'=>'72',
                                                'WBC'=>'74',
                                                'WCH'=>'75',
                                                'WLK'=>'76',
                                                'WLN'=>'77',
                                                'WLY'=>'78',
                                                'AIU'=>'102',
                                                'EDM'=>'103',
                                                'ELM'=>'104',
                                                'FMG'=>'105',
                                                'GFO'=>'106',
                                                'NGM'=>'107',
                                                'SCM'=>'108',
                                                'SCK'=>'109',
                                                'SIC'=>'110',
                                                'VMT'=>'111'};
                                                
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_MAKE';
            if(Appt.G_Meter_Make__c != null && Appt.G_Meter_Make__c != '')
                property_element.value = GMeterMakeEnum.get(Appt.G_Meter_Make__c);

            property_elements.add(property_element);                                                
            system.debug('@@@ XA_ASSET_G_MAKE Value: ' + property_element.value);
            //Praveen Added End

            //CH11.start
            if (bookingSystem.containsIgnoreCase('mus') && (Appt.Specific_Time_flag__c || EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag)) {
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_SPECIAL_CUSTOMER';
                property_element.value = '1';
                system.debug('@@@ XA_SPECIAL_CUSTOMER Value: ' + property_element.value);
                property_elements.add(property_element);
                //CH23
                appointmentElement.sla_window_start = (EON_DisplayCapacitiesFromOFSC_Ctrl.apptDate != null && EON_DisplayCapacitiesFromOFSC_Ctrl.apptStartTime != '' ? string.valueOf(EON_DisplayCapacitiesFromOFSC_Ctrl.apptDate) + ' ' + EON_DisplayCapacitiesFromOFSC_Ctrl.apptStartTime : '');
                appointmentElement.sla_window_end = string.valueOf(EON_DisplayCapacitiesFromOFSC_Ctrl.apptDate) + ' ' + EON_DisplayCapacitiesFromOFSC_Ctrl.endTime;
                //CH23
                if (EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag)
                    EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag = false;
            }
            //CH11.end
            
            EON_OFSC_Inbound_WS.PropertiesArray propertiesArray = new EON_OFSC_Inbound_WS.PropertiesArray();
            propertiesArray.property = property_elements;
            system.debug('@@@ property_elements: ' + property_elements);

            appointmentElement.properties = propertiesArray;

            //Command element
            system.debug('$$$ bucket: ' + bucketId);
            EON_OFSC_Inbound_WS.CommandElement commandElement = new EON_OFSC_Inbound_WS.CommandElement();
            date appointDate = null;
            if (bookingSystem == 'MUS' && string.isNotBlank(appDate))
                appointDate = date.valueOf(appDate);
            else if (Appt.Appointment_Date__c != null)
                appointDate = Appt.Appointment_Date__c;
            commandElement.date_x = convertDateToOFSCFormat(appointDate); //CH04.New
            system.debug('$$$ appointDate: ' + commandElement.date_x);
            commandElement.type_x = 'update_activity';
            commandElement.external_id = bucketId;
            commandElement.appointment = appointmentElement;
            system.debug('@@@ commandElement: ' + commandElement);

            List < EON_OFSC_Inbound_WS.CommandElement > commandElements = new List < EON_OFSC_Inbound_WS.CommandElement > ();
            commandElements.add(commandElement);

            EON_OFSC_Inbound_WS.CommandsArray commandArray = new EON_OFSC_Inbound_WS.CommandsArray();
            commandArray.command = commandElements;

            dataElement.commands = commandArray;

            //calling web service
            EON_OFSC_Inbound_WS.InboundInterfacePort request = new EON_OFSC_Inbound_WS.InboundInterfacePort();
            response = request.inbound_interface(userElement, headerElement, dataElement);
            System.debug('**** request: ' + userElement + '\n' + headerElement + '\n' + dataElement);
            System.debug('**** response: ' + response);

            String strResultCode = '';
            boolean iserror = false;
            if (response != null && response.data != null && response.data.commands != null && response.data.commands.command != null && response.data.commands.command.size() > 0) {
                strResultCode = response.data.commands.command[0].appointment.report.message[0].code;
                if (response.data.commands.command[0].appointment.aid != null) aid = string.valueOf(response.data.commands.command[0].appointment.aid); //CH07
                integer messageSize = response.data.commands.command[0].appointment.report.message.size();
                string tempError = '';
                for (integer i = 0; i < messageSize; i++) {
                    system.debug('@@@ res code: ' + response.data.commands.command[0].appointment.report.message[i].code);
                    system.debug('@@@ res result: ' + response.data.commands.command[0].appointment.report.message[i].result);
                    if (response.data.commands.command[0].appointment.report.message[i].code == '0')
                        strResultCode = '0';
                    else
                        tempError = response.data.commands.command[0].appointment.report.message[i].code;
                    if (response.data.commands.command[0].appointment.report.message[i].result == 'error') {
                        iserror = true;
                        strResultCode = tempError;
                    }
                }
            }
            system.debug('$$$ final response code: ' + strResultCode);
            system.debug('$$$ aid: ' + aid);

            List < EON_OFSC_Response_Code__c > responseCode = [select id, Name, Error_Warning_Success__c from EON_OFSC_Response_Code__c where name = : strResultCode and API__c = 'Inbound'];

            if (!responseCode.isEmpty())
                requestOut.Error_Code__c = responseCode[0].id;

            if (!responseCode.isEmpty()) {
                if (responseCode[0].Name == '0' || responseCode[0].Error_Warning_Success__c.containsignorecase('warning'))
                    requestOut.Status__c = EON_Utility.RESULT_PASS; //'PASS';
                if ((responseCode[0].Error_Warning_Success__c != '' && responseCode[0].Error_Warning_Success__c.containsignorecase('error')) || iserror)
                    requestOut.Status__c = EON_Utility.RESULT_FAIL; //'FAIL';
            } else if (strResultCode != '0')
                requestOut.Status__c = EON_Utility.RESULT_FAIL; //'FAIL';
            else if (strResultCode == '0')
                requestOut.Status__c = EON_Utility.RESULT_PASS; //'PASS';

            String toaResponse = '' + response;
            if (toaResponse.length() > 131072) requestOut.Response_Data__c = toaResponse.substring(0, 131072);
            else
                requestOut.Response_Data__c = '' + toaResponse;
            system.debug('@@@ OFSC responseCode: ' + responseCode);
            system.debug('$$$ request Status: ' + requestOut.Status__c);

            //if the response got error then revert team's TOA field as it was before.
            if (requestOut.Status__c == EON_Utility.RESULT_PASS) { //!responseCode.isEmpty() && responseCode[0].Error_Warning_Success__c != 'error' || !iserror){
                result = 'Job sent to OFSC successfully';
                //CH22.New.Start
                EON_CancelAppointment_RequestParser.processCancelRequest(Appt.ID);
                //CH22.New.End
            } else {
                result = 'No Response Code found or error found in the Response';
            }

        } catch (Exception ex) {
            String errMsg = '';
            errMsg = ex.getMessage() + ex.getStackTraceString() + '\n' + response;
            system.debug('### exc: ' + ex.getMessage() + '\n' + ex.getStackTraceString());
            if (errMsg.length() > 131072) requestOut.Response_Data__c = errMsg.substring(0, 131072);
            else
                requestOut.Response_Data__c = errMsg;
            requestOut.Status__c = EON_Utility.RESULT_FAIL; //'FAIL';
            result = 'Exception occurred Please see Error : ' + ex.getMessage();
        }

        try {
            requestXML = '' + userElement + '\n' + headerElement + '\n' + dataElement;
            requestOut.Request_Data__c = EON_Utility.validateStringLength(requestXML);
            insert requestOut;

            //just to track the full request as an attachment for OFSCRequestOut.
            EON_Utility.createAttachment(requestOut.id, requestXML, requestOut.id);

            //CH01.start
            try {
                if (requestOut.Status__c == EON_Utility.RESULT_PASS) { //'PASS'){
                    Appt.Duration__c = dur;
                    if (subArea != '') Appt.SubArea__c = subArea;
                    Appt.h_aid__c = aid; //CH07
                    if (activityType == 'CREATE' && !Appt.Sent_to_Oracle__c) Appt.Sent_to_Oracle__c = true; //CH02
                    if (activityType == 'UPDATE' && !Appt.Sent_to_Oracle_Update__c) Appt.Sent_to_Oracle_Update__c = true; //CH05
                    update Appt;
                }
                if (EON_OFSC_Send_Appointment_test.genexception)
                    ID test = ID.valueOf('test'); //Generate Exception
            } catch (Exception ex) {
                system.debug('### Isis exception: ' + ex.getMessage() + '\n' + ex.getStackTraceString());
                requestOut.Isis_Error__c = ex.getMessage() + '\n' + ex.getStackTraceString();
                upsert requestOut;
            } /*CH01.End*/
        } catch (Exception ex) {
            result = 'Exception occurred Please see Error : ' + ex.getMessage();
            system.debug('### Tracker exception: ' + ex.getMessage() + '\n' + ex.getStackTraceString());
            requestOut = new Oracle_Data_Tracker__c(Direction__c = EON_Utility.DIRECTION_OUT, Status__c = EON_Utility.RESULT_FAIL);
            String errMsg = '';
            errMsg = ex.getMessage() + ex.getStackTraceString() + '\n' + response;
            if (errMsg.length() > 131072) requestOut.Response_Data__c = errMsg.substring(0, 131072);
            else
                requestOut.Response_Data__c = errMsg;
            insert requestOut;
        }
        system.debug('$$$ final result: ' + result);
        return result;
    }

    /**
        convertDateToDateTime(Date dt) - This method converts date to TOA Date Format.
    **/
    public static String convertDateToOFSCFormat(Date dt) {
        String TOADate = '';
        if (dt != null)
            TOADate = datetime.newInstance(dt, time.newInstance(0, 0, 0, 0)).format(toaDateFormat);
        return TOADate;
    }

    /**
        checkNullBlank(string val) - This method checks for null or blank.
    **/
    public static String checkNullBlank(string val) {
        if (val == null || val == '')
            return '';
        return val;
    }
}