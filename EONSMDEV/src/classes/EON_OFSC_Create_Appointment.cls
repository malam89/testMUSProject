/**
    Description     : This class will be used to create activity in OFSC with referencec of Oracle Data Tracker records
    Test Class      : EON_OFSC_Create_Appointment_Test     
**/
/*
    Created By : Mahadev Joshilkar
    Created Date : 08/11/2016
    Service Request : SR_EON_AB_188
    Change History :
        CH01 # SR_EON_Mobile_106 # 07/12/2016 # Praveen G #  logic updated to consider if only one register found.
    CH02 # SR_EON_Mobile_111 # 19/12/2016 # Mahadev J # Referring field G_Meter_No_of_dials_digits__c
    CH03 # SR_OptiMUS_EON_033 # 27/01/2017 # Mahadev J # Override Job Type with type - Maintenance
    CH04 # SM-3183 #15/03/2017 #Praveen G #Added logic send failure to EON when it is catch block as well.
    CH05 # SR_OptiMUS_EON_140 # 02/10/2017 # Praveen G # Added WAN Coverage details send to ORACLE.
    CH06 # SR_OptiMUS_EON_148 # 30/10/2017 # Mehboob Alam # Number of Phases needs to send for Every Appointment.
    CH07 # SR_EON_OFSC_017 # 20/12/2017 # Praveen G # Changes for Install SED flag.
    CH08 # SR_OptiMUS_EON_240 # 02/05/2018 # Shruti Moghe # added variable and logic as per SR requirements

*/
public class EON_OFSC_Create_Appointment {
    /*public String AllApptID {
        get;
        set;
    }*/
    //public static Oracle_Data_Tracker__c requestOut;
    public static Oracle_Data_Tracker__c oTracker;
    public static string toaDateFormat = 'yyyy-MM-dd';
    public static boolean hasError = false;
    public static blob reqToOFSC;
    public static blob respFromOFSC;
    public static string ofscAID;
    public static integer ofscDuration;
    public static string ofscSubArea;
    public static string InstallSEDFlag; //CH07  
    public static string sendActivityToOFSC(EON_OFSC_Create_Appointment_Wrapper apptWrapper, string activityType, string eonTrackerId, string jumboTrackerId, string appDate, string appTime, string bookingSystem) {
        integer dur = 0;
        string error = '', requestXML = '', result = '', subArea = '', aid = '';
        oTracker = new Oracle_Data_Tracker__c();
        
        //Request Elements.
        EON_OFSC_Inbound_WS.UserElement userElement;
        EON_OFSC_Inbound_WS.HeadElement headerElement;
        EON_OFSC_Inbound_WS.DataElement dataElement = new EON_OFSC_Inbound_WS.DataElement();
        
        //Response Element
        EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response;

        try{
            //Generate Exception
            if(EON_OFSC_Create_Appointment_Test.genException == null)
                EON_OFSC_Create_Appointment_Test.genException = false;
            if(EON_OFSC_Create_Appointment_Test.genException)
                ID test = ID.valueOf('test');
            
            //Get Oracle Tracker Record
            oTracker.Command__c = (activityType == 'CREATE' ? EON_Utility.CMD_OFSC_CreateActivity : EON_Utility.CMD_OFSC_UpdateActivity);
            oTracker.Direction__c = EON_Utility.DIRECTION_OUT;
            oTracker.h_Booking_System_Name__c = string.isNotBlank(bookingSystem) ? (bookingSystem.length() < 255 ? bookingSystem : bookingSystem.substring(0, 254)) : '';
            //oTracker.EON_Appointment__c = Appt.Id;
            oTracker.EON_Data_Tracker__c = !EON_Utility.validateRequired(eonTrackerId) ? eonTrackerId : null;
            oTracker.JUMBO_Data_Tracker__c = !EON_Utility.validateRequired(jumboTrackerId) ? jumboTrackerId : null;
            
            //Get User Element
            userElement = EON_OFSC_Helper.getInboundUserElement();

            //Get Header Element
            headerElement = EON_OFSC_Helper.getHeaderElement();
            
            string mtrType = !EON_Utility.validateRequired(apptWrapper.Planned_E_Meter_Type) ? apptWrapper.Planned_E_Meter_Type : '';
            string G_mtrType = !EON_Utility.validateRequired(apptWrapper.Planned_G_Meter_Type) ? apptWrapper.Planned_G_Meter_Type : '';
            list<EON_SSC_Register__c> lstSSCReg = new list<EON_SSC_Register__c>();
            if(!EON_Utility.validateRequired(apptWrapper.Requested_SSC)){
                list<EON_SSC__c> lstSSC = new list<EON_SSC__c>([select id, name, Type__c, (select id, name, Register_ID__c, TPR__c from EON_SSC_Registers__r) from EON_SSC__c where name = : apptWrapper.Requested_SSC]);
                
                /*
                if(!lstSSC.isEmpty() && lstSSC.size() == 1)
                    lstSSCReg.addall(lstSSC[0].EON_SSC_Registers__r);
                else{ commneted as part of the change CH01*/                
                
                   if(string.isNotBlank(mtrType) && mtrType.containsignorecase('MS1')){
                        for(EON_SSC__c objSSC: lstSSC){
                            if(!EON_Utility.validateRequired(objSSC.Type__c)){
                                if(objSSC.Type__c.equalsIgnoreCase('Smart')){
                                    lstSSCReg.addall(objSSC.EON_SSC_Registers__r);
                                    break;
                                }                                
                            }
                        }
                    } 
                    else{
                        for(EON_SSC__c objSSC: lstSSC){
                            if(!EON_Utility.validateRequired(objSSC.Type__c)){
                                if(objSSC.Type__c.equalsIgnoreCase('Classic')){
                                    lstSSCReg.addall(objSSC.EON_SSC_Registers__r);
                                    break;
                                }
                            }
                        }
                    }
                //}
            }
            
            //CH05.Start
            String CSPRegion = '';
            String commsHUBVarient = '';
            String connectivityLikelyHood = '';           
            //CH05.End
            
            //Get bucket Id
            string postcode = !EON_Utility.validateRequired(apptWrapper.Fuel_ID_Premise_Postcode) ? apptWrapper.Fuel_ID_Premise_Postcode : '';
            system.debug('###PostCode1111: '+postcode);
            string JobType = EON_OFSC_Helper.overrideJobType ? 'Maintenance' : (!EON_Utility.validateRequired(apptWrapper.h_Job_Type) ? apptWrapper.h_Job_Type : ''); //Ch03.Update
            string bucketId = '';
            list<EON_Post_Code__c> lstPC = new list<EON_Post_Code__c>([select id, name, h_sub_area_checkbox__c, 
                
                //CH05.Start
                Sub_Area_Name__r.Region_Name__r.CSP_Region__c, Sub_Area_Name__r.Region_Name__r.Comms_Hub_Variant__c, 
                Sub_Area_Name__r.Region_Name__r.Connectivity_Likelihood__c, 
                //CH05.End
                Sub_Area_Name__r.Id, Sub_Area_Name__r.Oracle_Bucket_ID__c from EON_Post_Code__c where name = : postcode]);
            system.debug('###PostCode: '+lstPC);
            for(EON_Post_Code__c objPC: lstPC){
                string check = string.isNotBlank(objPC.h_sub_area_checkbox__c) ? objPC.h_sub_area_checkbox__c : '';
                if (JobType != '' && check != '' && check.containsIgnoreCase(JobType)) {
                    system.debug('###PostCode1: '+objPC);
                    bucketId = objPC.Sub_Area_Name__r.Oracle_Bucket_ID__c;
                    subArea = objPC.Sub_Area_Name__r.Id;
                }
            }
            if (bucketId == '')
                bucketId = system.label.EON_Exception_BucketID;
            
            //Get Vulnerabilities
            string vulnerabilites = '';
            if(!EON_Utility.validateRequired(apptWrapper.listOfEONVulnerability)){
                for(EON_OFSC_Create_Appointment_Wrapper.EONVulnerability apptVul : apptWrapper.listOfEONVulnerability){
                    //if(!EON_Utility.validateRequired(apptVul.h_Vulnerability_Desc)){
                        vulnerabilites = !EON_Utility.validateRequired(apptVul.h_Vulnerability_Desc) ? (String.isBlank(vulnerabilites) ? apptVul.h_Vulnerability_Desc : vulnerabilites + ', ' + apptVul.h_Vulnerability_Desc) : '';
                        /*if (vulnerabilites == '')
                            vulnerabilites = apptVul.h_Vulnerability_Desc;
                        else
                            vulnerabilites = vulnerabilites + ', ' + apptVul.h_Vulnerability_Desc; */                       
                    //}
                }
            }
            
            //Get Duration
            string duration = '';
            if (activityType == 'UPDATE' && apptWrapper.Key_Collection_Required)
                dur = dur + 15;

            if(activityType == 'UPDATE'){
                if(apptWrapper.Fuel_ID != null){
                    if(apptWrapper.Fuel_ID_MPAN == apptWrapper.MPAN){
                        dur = apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'RES' ? (dur + Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_Duration != null ? apptWrapper.Job_code_Duration : 0))) : (apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'SME' ? (dur + Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_SME_Duration != null ? apptWrapper.Job_code_SME_Duration : 0))) : 0);
                        /*if(apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'RES')
                            dur = dur + Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_Duration != null ? apptWrapper.Job_code_Duration : 0));
                        else if (apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'SME')
                            dur = dur + Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_SME_Duration != null ? apptWrapper.Job_code_SME_Duration : 0)); */
                    } 
                    else if (apptWrapper.Fuel_ID_MPRN == apptWrapper.MPRN) {
                        dur = apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'RES' ? (dur + Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_Duration != null ? apptWrapper.Job_code_Duration : 0))) : (apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'SME' ? (dur + Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_SME_Duration != null ? apptWrapper.Job_code_SME_Duration : 0))) : 0);
                        /*if (apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'RES')
                            dur = dur + Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_Duration != null ? apptWrapper.Job_code_Duration : 0));
                        else if (apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'SME')
                            dur = dur + Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_SME_Duration != null ? apptWrapper.Job_code_SME_Duration : 0));*/
                    }
                } 
                else
                    dur = dur + Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_Duration != null ? apptWrapper.Job_code_Duration : 0));
            }
            if (activityType == 'CREATE' && (apptWrapper.Job_code_h_Job_Attribute_Duration != null || apptWrapper.Job_code_Duration != null))
                dur = Integer.valueOf((apptWrapper.Job_code_h_Job_Attribute_Duration != null ? apptWrapper.Job_code_h_Job_Attribute_Duration : 0) + (apptWrapper.Job_code_Duration != null ? apptWrapper.Job_code_Duration : 0));
            if (dur != 0)
                duration = string.valueof(dur);
            
            //Create Data element ----------------------
            //Create appointment Element
            EON_OFSC_Inbound_WS.AppointmentElement appointmentElement = new EON_OFSC_Inbound_WS.AppointmentElement();
            appointmentElement.appt_number = apptWrapper.Appointment_Key; 
            appointmentElement.duration = duration;
            appointmentElement.worktype_label = !EON_Utility.validateRequired(apptWrapper.Job_code_Name) ? apptWrapper.Job_code_Name : '';
            appointmentElement.time_slot = checkNullBlank((bookingSystem != 'MUS' ? apptWrapper.Time_Slot : appTime)); 
            string startTime = !EON_Utility.validateRequired(apptWrapper.Start_Time) ? apptWrapper.Start_Time : ''; 
            appointmentElement.sla_window_start = (apptWrapper.Appointment_Date != null && startTime != '' ? string.valueOf(apptWrapper.Appointment_Date) + ' ' + apptWrapper.Start_Time : '');
            string endTime = '';
            if(apptWrapper.Appointment_Date != null && startTime != '' && apptWrapper.End_Time != '' && apptWrapper.End_Time.length() > 2 && startTime.length() > 2){
                integer sHr = integer.valueOf(startTime.left(2));
                integer eHr = integer.valueOf(apptWrapper.End_Time.left(2));
                integer i = sHr - eHr;
                date endDate = apptWrapper.Appointment_Date;
                if(i > 0) 
                    endDate = apptWrapper.Appointment_Date.addDays(1);
                endTime = string.valueOf(endDate) + ' ' + apptWrapper.End_Time;
            }
            appointmentElement.sla_window_end = endTime;
            appointmentElement.name = apptWrapper.Caller_Name;
            appointmentElement.address = apptWrapper.Oracle_Address; //'FLAT 43 BLAKE HOUSE, , HERCULES ROAD'; 
            appointmentElement.city = apptWrapper.Oracle_Town; //'LONDON';
            appointmentElement.zip = apptWrapper.Oracle_Postcode; //'SE1 7DX';

            //Property Element
            List < EON_OFSC_Inbound_WS.PropertyElement > property_elements = new List < EON_OFSC_Inbound_WS.PropertyElement > ();
            EON_OFSC_Inbound_WS.PropertyElement property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_APPT_NOTES';
            property_element.value = checkNullBlank(apptWrapper.Notes);
            property_elements.add(property_element);
                             
            
            //CH05.Start
            if(subArea != ''){
                EON_Sub_Area__c[] lstArea = [select id, Region_Name__r.CSP_Region__c,
                                                Region_Name__r.Comms_Hub_Variant__c,
                                                Region_Name__r.Connectivity_Likelihood__c
                                             from EON_Sub_Area__c where id =:subArea];
                if(!lstArea.isEmpty()){                                             
                    CSPRegion = lstArea[0].Region_Name__r.CSP_Region__c;
                    commsHUBVarient = lstArea[0].region_Name__r.Comms_Hub_Variant__c;
                    connectivityLikelyHood = lstArea[0].Region_Name__r.Connectivity_Likelihood__c;
                }
            }
            //CH05.End            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_REGION';
            property_element.value = checkNullBlank(CSPRegion);
            system.debug('@@@ XA_ASSET_H_REGION '+property_element.value);
            property_elements.add(property_element); 
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_REQ';
            property_element.value = checkNullBlank(commsHUBVarient);
            system.debug('@@@ XA_ASSET_H_REQ '+property_element.value);
            property_elements.add(property_element);  
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_CON_HOOD';
            property_element.value = checkNullBlank(connectivityLikelyHood);
            system.debug('@@@ XA_ASSET_H_CON_HOOD '+property_element.value);
            property_elements.add(property_element);            
            //CH05.End            

            //CH02.New
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_NO_DIG';
            property_element.value = (apptWrapper.G_Meter_No_of_dials_digits != null) ? (apptWrapper.G_Meter_No_of_dials_digits + '') : '';
            system.debug('@@@ XA_ASSET_G_NO_DIG Value: ' + property_element.value);
            property_elements.add(property_element); 
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_Morrison_ID';
            property_element.value = ''; //Appt.Name - TBD
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_EON_ID';
            property_element.value = checkNullBlank(apptWrapper.EON_Appointment_ID);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PARKING';
            property_element.value = (string.isNotBlank(apptWrapper.Parking_Type) && apptWrapper.Parking_Type_OFS_Enumeration != 0.0 ? checkNullBlank(string.valueOf(apptWrapper.Parking_Type_OFS_Enumeration)) : '');
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PASSPHRASE';
            property_element.value = checkNullBlank(apptWrapper.Access_Pass_Phrase);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_VULNERABLE';
            property_element.value = vulnerabilites;
            property_elements.add(property_element);

            //CH04.new
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_APPOINTMENT_REASON';
            property_element.value = (apptWrapper.Appointment_reason_code != null && apptWrapper.Appointment_reason_code_OFS_Enumeration != null ? checkNullBlank(string.valueOf(apptWrapper.Appointment_reason_code_OFS_Enumeration)) : ''); 
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSIST_REASON';
            property_element.value = checkNullBlank(apptWrapper.h_OFSC_Assisted_Work_Reason_Code);
            property_elements.add(property_element);
            
            if(!EON_Utility.validateRequired(apptWrapper.listOfApptContacts)){
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_CONTACT_NAME';
                property_element.value = ((!apptWrapper.listOfApptContacts.isEmpty() && apptWrapper.listOfApptContacts.size() > 0) ? checkNullBlank(apptWrapper.listOfApptContacts[0].Contact_Full_Name) : '');
                property_elements.add(property_element);

                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_CONTACT_NUMBER';
                property_element.value = ((!apptWrapper.listOfApptContacts.isEmpty() && apptWrapper.listOfApptContacts.size() > 0) ? checkNullBlank(apptWrapper.listOfApptContacts[0].Media_Detail) : '');
                system.debug('@@@ XA_CONTACT_NUMBER Value: ' + property_element.value);
                property_elements.add(property_element);
    
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_CONTACT_NAME_2';
                property_element.value = ((!apptWrapper.listOfApptContacts.isEmpty() && apptWrapper.listOfApptContacts.size() > 1) ? checkNullBlank(apptWrapper.listOfApptContacts[1].Contact_Full_Name) : '');
                system.debug('@@@ XA_CONTACT_NAME_2 Value: ' + property_element.value);
                property_elements.add(property_element);
    
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_CONTACT_NUMBER_2';
                property_element.value = ((!apptWrapper.listOfApptContacts.isEmpty() && apptWrapper.listOfApptContacts.size() > 1) ? checkNullBlank(apptWrapper.listOfApptContacts[1].Media_Detail) : '');
                system.debug('@@@ XA_CONTACT_NUMBER_2 Value: ' + property_element.value);
                property_elements.add(property_element);
    
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_CONTACT_NAME_3';
                property_element.value = ((!apptWrapper.listOfApptContacts.isEmpty() && apptWrapper.listOfApptContacts.size() > 2) ? checkNullBlank(apptWrapper.listOfApptContacts[2].Contact_Full_Name) : '');
                system.debug('@@@ XA_CONTACT_NAME_3 Value: ' + property_element.value);
                property_elements.add(property_element);
    
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_CONTACT_NUMBER_3';
                property_element.value = ((!apptWrapper.listOfApptContacts.isEmpty() && apptWrapper.listOfApptContacts.size() > 2) ? checkNullBlank(apptWrapper.listOfApptContacts[2].Media_Detail) : '');
                system.debug('@@@ XA_CONTACT_NUMBER_3 Value: ' + property_element.value);
                property_elements.add(property_element);
    
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_CONTACT_NAME_4';
                property_element.value = ((!apptWrapper.listOfApptContacts.isEmpty() && apptWrapper.listOfApptContacts.size() > 3) ? checkNullBlank(apptWrapper.listOfApptContacts[3].Contact_Full_Name) : '');
                system.debug('@@@ XA_CONTACT_NAME_4 Value: ' + property_element.value);
                property_elements.add(property_element);
    
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_CONTACT_NUMBER_4';
                property_element.value = ((!apptWrapper.listOfApptContacts.isEmpty() && apptWrapper.listOfApptContacts.size() > 3) ? checkNullBlank(apptWrapper.listOfApptContacts[3].Media_Detail) : '');
                system.debug('@@@ XA_CONTACT_NUMBER_4 Value: ' + property_element.value);
                property_elements.add(property_element);
            }

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_POSTCODE_SECTOR';
            property_element.value = checkNullBlank(apptWrapper.Oracle_Postcode_Sector);
            system.debug('@@@ XA_POSTCODE_SECTOR Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ADDITIONAL_INFO';
            property_element.value = checkNullBlank(apptWrapper.Additional_Information);
            system.debug('@@@ XA_ADDITIONAL_INFO Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_MPAN_NUMBER';
            property_element.value = checkNullBlank(apptWrapper.MPAN);
            system.debug('@@@ XA_MPAN_NUMBER Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_MPRN_NUMBER';
            property_element.value = checkNullBlank(apptWrapper.MPRN);
            system.debug('@@@ XA_MPRN_NUMBER Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PRESSURE';
            property_element.value = checkNullBlank(apptWrapper.h_OFSC_Metering_Pressure);
            system.debug('@@@ XA_PRESSURE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PHASE';
            //CH06.End
            //if(apptWrapper.Current_Phase !=null && apptWrapper.Current_Phase != '' && apptWrapper.Current_Phase == '3Ph')
                //property_element.value = '2';
            //else
             //CH06.End
            property_element.value = checkNullBlank(apptWrapper.h_OFSC_Number_of_Phases); 
            system.debug('@@@ XA_PHASE Value: ' + property_element.value);
            property_elements.add(property_element);

            //Electric Meter specific info
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_MSN';
            property_element.value = checkNullBlank(apptWrapper.E_Meter_Serial_Number);
            system.debug('@@@ XA_ASSET_E_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_TYPE';
            property_element.value = (apptWrapper.E_Meter_Type != null && apptWrapper.E_Meter_Type_OFS_Enumeration != 0.0 ? checkNullBlank(string.valueOf(apptWrapper.E_Meter_Type_OFS_Enumeration)) : '');
            system.debug('@@@ XA_ASSET_E_TYPE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_LOCATION';
            property_element.value = (apptWrapper.E_Meter_Location != null && apptWrapper.E_Meter_Location_OFS_Enumeration != 0.0 ? checkNullBlank(string.valueOf(apptWrapper.E_Meter_Location_OFS_Enumeration)) : '');
            system.debug('@@@ XA_ASSET_E_LOCATION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_MANFCT';
            property_element.value = checkNullBlank(apptWrapper.E_Meter_Make);
            system.debug('@@@ XA_ASSET_E_MANFCT Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_VERSION';
            property_element.value = checkNullBlank(apptWrapper.E_Meter_Model);
            system.debug('@@@ XA_ASSET_E_VERSION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID';
            property_element.value = checkNullBlank(apptWrapper.E_Meter_Register_1_ID);
            system.debug('@@@ XA_ASSET_E_REG_ID Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID2';
            property_element.value = checkNullBlank(apptWrapper.E_Meter_Register_2_ID);
            system.debug('@@@ XA_ASSET_E_REG_ID2 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID3';
            property_element.value = checkNullBlank(apptWrapper.E_Meter_Register_3_ID);
            system.debug('@@@ XA_ASSET_E_REG_ID3 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID4';
            property_element.value = checkNullBlank(apptWrapper.E_Meter_Register_4_ID);
            system.debug('@@@ XA_ASSET_E_REG_ID4 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID5';
            property_element.value = checkNullBlank(apptWrapper.E_Meter_Register_5_ID);
            system.debug('@@@ XA_ASSET_E_REG_ID5 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID6';
            property_element.value = checkNullBlank(apptWrapper.E_Meter_Register_6_ID);
            system.debug('@@@ XA_ASSET_E_REG_ID6 Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_CERTDT';
            property_element.value = convertDateToOFSCFormat(apptWrapper.Certification_Date);
            system.debug('@@@ XA_ASSET_E_CERTDT Value: ' + property_element.value);
            property_elements.add(property_element);

            //CH09.new.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_CERTEXPDT';
            property_element.value = convertDateToOFSCFormat(apptWrapper.Certification_Expiry_Date);
            system.debug('@@@ XA_ASSET_E_CERTEXPDT Value: ' + property_element.value);
            property_elements.add(property_element);

            //Gas meter information
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_MSN';
            property_element.value = checkNullBlank(apptWrapper.G_Meter_Serial_Number);
            system.debug('@@@ XA_ASSET_G_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_TYPE';
            property_element.value = (apptWrapper.G_Meter_Mechanism != null && apptWrapper.G_Meter_Mechanism_OFS_Enumeration != null ? checkNullBlank(string.valueOf(apptWrapper.G_Meter_Mechanism_OFS_Enumeration)) : '');
            system.debug('@@@ XA_ASSET_G_TYPE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_LOCATION';
            property_element.value = (apptWrapper.G_Meter_Location != null && apptWrapper.G_Meter_Location_OFS_Enumeration != null ? checkNullBlank(string.valueOf(apptWrapper.G_Meter_Location_OFS_Enumeration)) : '');
            system.debug('@@@ XA_ASSET_G_LOCATION Value: ' + property_element.value);
            property_elements.add(property_element);
            
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_MAKE'; //CH19       
            property_element.value = checkNullBlank(apptWrapper.h_G_MeterMake_Enum_Mapping);
            system.debug('@@@ XA_ASSET_G_MAKE Value: ' + property_element.value);
            property_elements.add(property_element);
            */
            
            //Praveen added start
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
            property_element.label = 'XA_ASSET_G_MAKE';  //CH19
            if(apptWrapper.G_Meter_Make != null && apptWrapper.G_Meter_Make != '')       
                property_element.value = GMeterMakeEnum.get(apptWrapper.G_Meter_Make); 
            property_elements.add(property_element);    
            system.debug('@@@ XA_ASSET_G_MAKE Value: '+property_element.value);            
            //Praveen added 
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_VERSION';
            property_element.value = checkNullBlank(apptWrapper.G_Meter_Model);
            system.debug('@@@ XA_ASSET_G_VERSION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_MSN';
            property_element.value = checkNullBlank(apptWrapper.E_Check_Meter_Serial_Number);
            system.debug('@@@ XA_ASSET_EC_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_MANFCT';
            property_element.value = checkNullBlank(apptWrapper.E_Check_Meter_Make);
            system.debug('@@@ XA_ASSET_EC_MANFCT Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_VERSION';
            property_element.value = checkNullBlank(apptWrapper.E_Check_Meter_Model);
            system.debug('@@@ XA_ASSET_EC_VERSION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_LOCATION';
            property_element.value = (apptWrapper.E_Check_Meter_Location != null && apptWrapper.E_Check_Meter_Location_OFS_Enumeration != null ? checkNullBlank(string.valueOf(apptWrapper.E_Check_Meter_Location_OFS_Enumeration)) : '');
            system.debug('@@@ XA_ASSET_EC_LOCATION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_MANFCT';
            property_element.value = checkNullBlank(apptWrapper.G_Check_Meter_Make);
            system.debug('@@@ XA_ASSET_GC_MANFCT Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_VERSION';
            property_element.value = checkNullBlank(apptWrapper.G_Check_Meter_Model);
            system.debug('@@@ XA_ASSET_GC_VERSION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_LOCATION';
            property_element.value = (apptWrapper.G_Check_Meter_Location != null && apptWrapper.G_Check_Meter_Location_OFS_Enumeration != null ? checkNullBlank(string.valueOf(apptWrapper.G_Check_Meter_Location_OFS_Enumeration)) : '');
            system.debug('@@@ XA_ASSET_GC_LOCATION Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_MSN';
            property_element.value = checkNullBlank(apptWrapper.G_Check_Meter_Serial_Number);
            system.debug('@@@ XA_ASSET_GC_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            //Asset Details - Comms Hub
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_MSN';
            property_element.value = checkNullBlank(apptWrapper.Expected_Comms_Hub_Serial_Number);
            system.debug('@@@ XA_ASSET_H_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            // Asset Details - IHD/SED
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_I_MSN';
            property_element.value = checkNullBlank(apptWrapper.Expected_IHD_Serial_Number);
            system.debug('@@@ XA_ASSET_I_MSN Value: ' + property_element.value);
            property_elements.add(property_element);

            //New Meter details
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ELEC_METER_TYPE';
            property_element.value = checkNullBlank(apptWrapper.h_OFSC_Planned_E_Meter_Type);
            system.debug('@@@ XA_ELEC_METER_TYPE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_GAS_METER_TYPE';
            property_element.value = checkNullBlank(apptWrapper.h_OFSC_Planned_G_Meter_Type);
            system.debug('@@@ XA_GAS_METER_TYPE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_TARIFF_NEW';
            property_element.value = checkNullBlank(apptWrapper.h_OFSC_Planned_Meter_Registers);
            system.debug('@@@ XA_ASSET_E_TARIFF_NEW Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_SSC_NEW';
            property_element.value = checkNullBlank(apptWrapper.Requested_SSC);
            system.debug('@@@ XA_ASSET_E_SSC_NEW Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_NOREG_NEW';
            property_element.value = checkNullBlank(apptWrapper.Planned_Number_of_Registers);
            system.debug('@@@ XA_ASSET_E_NOREG_NEW Value: ' + property_element.value);
            property_elements.add(property_element);

            if (!(mtrType == 'MCL' || mtrType == 'KEY' || G_mtrType == 'MCL' || G_mtrType == 'PP')) {
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_E_MODE_NEW';
                property_element.value = checkNullBlank(apptWrapper.h_OFSC_Planned_Meter_Mode);
                system.debug('@@@ XA_ASSET_E_MODE_NEW Value: ' + property_element.value);
                property_elements.add(property_element);
            }
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_GAS_BIND';
            property_element.value = checkNullBlank(apptWrapper.h_OFSC_Gas_bind_performed_flag);
            system.debug('@@@ XA_GAS_BIND Value: ' + property_element.value);
            property_elements.add(property_element);
            
            //CH07.Start            
            String installSED = '';
                if(apptWrapper.Install_SED){    //CH08.added new if/else block          
                    if(apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'SME')
                        installSED = '2';
                    else if(apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == 'RES')     
                        installSED = '1';
                    else if(apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == null || 
                            apptWrapper.Fuel_ID_Premise_Customer_Customer_group_type == '') 
                        installSED = '1'; 
                        
                    if(installSED == '2'){
                        property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                        property_element.label = 'XA_ASSET_I_SUPP';             
                        property_element.value = '2';
                        property_elements.add(property_element);
                        property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                        property_element.label = 'XA_ASSET_I_REASON';             
                        property_element.value = '2';
                        property_elements.add(property_element);
                    } 
                    if(InstallSED=='1') InstallSEDFlag='Yes';
                    if(InstallSED=='2') InstallSEDFlag='No';
                }
                else{
                    if(apptWrapper.h_OFSC_Install_SED_flag=='1') InstallSEDFlag='Yes';
                    if(apptWrapper.h_OFSC_Install_SED_flag=='2') InstallSEDFlag='No';
                }
                //CH08.end
            //CH07.End           
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_INSTALL_SED';
            //CH08.start
            if(apptWrapper.Install_SED)  property_element.value = checkNullBlank(installSED); // CH07
            else property_element.value = checkNullBlank(apptWrapper.h_OFSC_Install_SED_flag); //CH07 commented//CH08 Uncommented
            //CH08.end
            system.debug('@@@ XA_INSTALL_SED Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY';
            string keyCol = '';
            if (apptWrapper.Key_Collection_Required != null)
                keyCol = apptWrapper.Key_Collection_Required ? 'Yes' : 'No';
            property_element.value = keyCol;
            system.debug('@@@ XA_KEY Value: ' + property_element.value);
            property_elements.add(property_element);

            integer j = 1;
            map < string, string > mapRegNameOFSVal = new map < string, string > {
                'EXPORT' => '1', 'NORMAL' => '2', 'LOW' => '3', 'EVENING WEEKEND' => '4', 'RATE 1' => '5', 'RATE 2' => '6',
                'RATE 3' => '7', 'RATE 4' => '8', 'RATE 5' => '9', 'RATE 6' => '10', 'TOTAL' => '11'
            }; 
            for(EON_SSC_Register__c objReg: lstSSCReg){
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_REGTYPE_NEW_' + j;
                property_element.value = mapRegNameOFSVal.containsKey(objReg.Name.toUpperCase()) ? mapRegNameOFSVal.get(objReg.Name.toUpperCase()) : '';
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
                if (j > 6) break;
            }

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_PERSON';
            property_element.value = checkNullBlank(apptWrapper.Key_Person_Name);
            system.debug('@@@ XA_KEY_PERSON Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_BUILD_NAME';
            property_element.value = checkNullBlank(apptWrapper.Key_Building_Name);
            system.debug('@@@ XA_KEY_BUILD_NAME Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_BUILD_NO';
            property_element.value = checkNullBlank(apptWrapper.Key_Building_Number);
            system.debug('@@@ XA_KEY_BUILD_NO Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_SUB_BUILD';
            property_element.value = checkNullBlank(apptWrapper.Key_Sub_Building_Name);
            system.debug('@@@ XA_KEY_SUB_BUILD Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_THOROFARE';
            property_element.value = checkNullBlank(apptWrapper.Key_Thorofare);
            system.debug('@@@ XA_KEY_THOROFARE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_D_THOROFARE';
            property_element.value = checkNullBlank(apptWrapper.Key_Dependant_Thorofare);
            system.debug('@@@ XA_KEY_D_THOROFARE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_D_LOC';
            property_element.value = checkNullBlank(apptWrapper.Key_Dependant_Locality);
            system.debug('@@@ XA_KEY_D_LOC Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_TOWN';
            property_element.value = checkNullBlank(apptWrapper.Key_Town);
            system.debug('@@@ XA_KEY_TOWN Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_COUNTY';
            property_element.value = checkNullBlank(apptWrapper.Key_County);
            system.debug('@@@ XA_KEY_COUNTY Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_POSTCODE';
            property_element.value = checkNullBlank(apptWrapper.Key_Post_Code);
            system.debug('@@@ XA_KEY_POSTCODE Value: ' + property_element.value);
            property_elements.add(property_element);

            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_CONTACT_NO';
            property_element.value = checkNullBlank(string.valueof(apptWrapper.Key_Contact_Number)); //CH17
            system.debug('@@@ XA_KEY_CONTACT_NO Value: ' + property_element.value);
            property_elements.add(property_element);

            if(bookingSystem.containsIgnoreCase('mus') && (apptWrapper.Specific_Time_flag || EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag)) {
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_SPECIAL_CUSTOMER';
                property_element.value = '1';
                system.debug('@@@ XA_SPECIAL_CUSTOMER Value: ' + property_element.value);
                property_elements.add(property_element);
                appointmentElement.sla_window_start = (EON_DisplayCapacitiesFromOFSC_Ctrl.apptDate != null && EON_DisplayCapacitiesFromOFSC_Ctrl.apptStartTime != '' ? string.valueOf(EON_DisplayCapacitiesFromOFSC_Ctrl.apptDate) + ' ' + EON_DisplayCapacitiesFromOFSC_Ctrl.apptStartTime : '');
                appointmentElement.sla_window_end = string.valueOf(EON_DisplayCapacitiesFromOFSC_Ctrl.apptDate) + ' ' + EON_DisplayCapacitiesFromOFSC_Ctrl.endTime;
                if (EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag)
                    EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag = false;
            }

            EON_OFSC_Inbound_WS.PropertiesArray propertiesArray = new EON_OFSC_Inbound_WS.PropertiesArray();
            propertiesArray.property = property_elements;
            system.debug('@@@ property_elements: ' + property_elements);

            appointmentElement.properties = propertiesArray;

            //Command element
            EON_OFSC_Inbound_WS.CommandElement commandElement = new EON_OFSC_Inbound_WS.CommandElement();
            date appointDate = null;
            if (bookingSystem == 'MUS' && string.isNotBlank(appDate))
                appointDate = date.valueOf(appDate);
            else if (apptWrapper.Appointment_Date != null)
                appointDate = apptWrapper.Appointment_Date;
            commandElement.date_x = convertDateToOFSCFormat(appointDate); 
            commandElement.type_x = 'update_activity';
            commandElement.external_id = bucketId;
            commandElement.appointment = appointmentElement;

            List<EON_OFSC_Inbound_WS.CommandElement> commandElements = new List<EON_OFSC_Inbound_WS.CommandElement>();
            commandElements.add(commandElement);

            EON_OFSC_Inbound_WS.CommandsArray commandArray = new EON_OFSC_Inbound_WS.CommandsArray();
            commandArray.command = commandElements;

            dataElement.commands = commandArray;
            
            reqToOFSC = blob.valueOf(String.valueof(userElement)+'\n'+String.valueof(headerElement)+'\n'+String.valueof(dataElement));
            //Calling OFSC WebService
            EON_OFSC_Inbound_WS.InboundInterfacePort request = new EON_OFSC_Inbound_WS.InboundInterfacePort();
            response = request.inbound_interface(userElement, headerElement, dataElement);
            respFromOFSC = blob.valueOf(String.valueof(response));
            System.debug('**** OptiMUS request: ' + userElement + '\n' + headerElement + '\n' + dataElement);
            System.debug('**** OFSC response: ' + response);

            String strResultCode = '';
            boolean iserror = false;
            if(response != null && response.data != null && response.data.commands != null && response.data.commands.command != null && response.data.commands.command.size() > 0){
                strResultCode = response.data.commands.command[0].appointment.report.message[0].code;
                if(response.data.commands.command[0].appointment.aid != null) 
                    aid = string.valueOf(response.data.commands.command[0].appointment.aid);
                integer messageSize = response.data.commands.command[0].appointment.report.message.size();
                string tempError = '';
                for(integer i = 0; i < messageSize; i++){
                    system.debug('@@@ res code: ' + response.data.commands.command[0].appointment.report.message[i].code);
                    system.debug('@@@ res result: ' + response.data.commands.command[0].appointment.report.message[i].result);
                    if (response.data.commands.command[0].appointment.report.message[i].code == '0')
                        strResultCode = '0';
                    else
                        tempError = response.data.commands.command[0].appointment.report.message[i].code;
                    if(response.data.commands.command[0].appointment.report.message[i].result == 'error'){
                        hasError = true;
                        iserror = true;
                        strResultCode = tempError;
                    }
                }
            }
            system.debug('$$$ final response code: ' + strResultCode);
            system.debug('$$$ aid: ' + aid);

            List<EON_OFSC_Response_Code__c> responseCode = [select id, Name, Error_Warning_Success__c from EON_OFSC_Response_Code__c where name = : strResultCode and API__c = 'Inbound'];

            if (!responseCode.isEmpty())
                oTracker.Error_Code__c = responseCode[0].id;
            if (!responseCode.isEmpty()){
                if (responseCode[0].Name == '0' || responseCode[0].Error_Warning_Success__c.containsignorecase('warning'))
                    oTracker.Status__c = EON_Utility.RESULT_PASS; 
                if ((responseCode[0].Error_Warning_Success__c != '' && responseCode[0].Error_Warning_Success__c.containsignorecase('error')) || iserror)
                    oTracker.Status__c = EON_Utility.RESULT_FAIL; 
            } 
            else if (strResultCode != '0')
                oTracker.Status__c = EON_Utility.RESULT_FAIL; 
            else if (strResultCode == '0')
                oTracker.Status__c = EON_Utility.RESULT_PASS; 

            String toaResponse = '' + response;
            oTracker.Response_Data__c = toaResponse.length() > 131072 ? toaResponse.substring(0, 131072) : '' + toaResponse;
            /*if (toaResponse.length() > 131072) 
                oTracker.Response_Data__c = toaResponse.substring(0, 131072);
            else
                oTracker.Response_Data__c = '' + toaResponse; */

            //if the response got error then revert team's TOA field as it was before.
            if(oTracker.Status__c == EON_Utility.RESULT_PASS){
                result = 'Job sent to OFSC successfully';
                ofscAID = aid;
                ofscDuration = dur;
                ofscSubArea = subArea;
                system.debug('###SubArea: '+subArea);
            } 
            else{
                result = 'No Response Code found or error found in the Response';
            }
            
            requestXML = '' + userElement + '\n' + headerElement + '\n' + dataElement;
            oTracker.Request_Data__c = EON_Utility.validateStringLength(requestXML);
            //Create attachment
            //EON_Utility.createAttachment(oTracker.id, requestXML, oTracker.id); //This will enabled later - TBD
            /*try{
                
                if (EON_OFSC_Send_Appointment_test.genexception)
                    ID test = ID.valueOf('test'); //Generate Exception
            } 
            catch (Exception ex){
                system.debug('### Isis exception: ' + ex.getMessage() + '\n' + ex.getStackTraceString());
                oTracker.Isis_Error__c = ex.getMessage() + '\n' + ex.getStackTraceString();
                upsert oTracker;
            } */
        } 
        catch(Exception ex){
            hasError = true; //CH04
            system.debug('###Error: ' + ex.getMessage() + '\n' + ex.getStackTraceString()+ex.getlinenumber());
            String errMsg = '';
            errMsg = ex.getMessage() + ex.getStackTraceString() + '\n' + response;
            oTracker.Response_Data__c = errMsg.length() > 131072 ? errMsg.substring(0, 131072) : errMsg;
            /*if (errMsg.length() > 131072) 
                oTracker.Response_Data__c = errMsg.substring(0, 131072);
            else
                oTracker.Response_Data__c = errMsg; */
            oTracker.Status__c = EON_Utility.RESULT_FAIL;
            result = 'Exception occurred Please see Error : ' + ex.getMessage();
        }
        system.debug('###OFSC Returning: ' + result);
        return result;
    }

    /**
        checkNullBlank(string val) - This method checks for null or blank.
    **/
    public static String checkNullBlank(string val){
        if(val == null || val == '')
            return '';            
        return val;        
    }
     /**
        convertDateToDateTime(Date dt) - This method converts date to TOA Date Format.
    **/
    public static String convertDateToOFSCFormat(Date dt){
        String TOADate = '';
        if(dt != null)
            TOADate = datetime.newInstance(dt, time.newInstance(0, 0, 0, 0)).format(toaDateFormat);            
        return TOADate;        
    }
}