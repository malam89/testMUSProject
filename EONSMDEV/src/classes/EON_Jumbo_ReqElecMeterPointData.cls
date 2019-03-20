/**
    Description : This class is used To provide Electricity Meter Point data relating to a specific MPAN using the MPAN as the matching key
    Test Class  : EON_Jumbo_ElecGasData_Test
**/
/*
    Created By  : Mehboob Alam
    Created On  : 08/04/2016
    Service Req : SR_EON_Jumbo_003
    Change History
    CH01 # SR_EON_Jumbo_038 # 27/06/2016 # Mehboob Alam # Populating 'Planned E Meter Type' field.
    CH02 # SR_EON_AB_097 # 28/06/2016 # Mehboob Alam # Changed 'Number of Phases' value from 1,3 to 1Ph and 3Ph
    CH03 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Mapping for JUMBO Vulnerability Code with EON Vulnerability Code
    CH04 # SR_EON_AB_119 # 12/08/2016 # Sivasankar K # Added the logic to return the incoming planned e meter type value as same when it is not K N 
    CH05 # SR_EON_Jumbo_059 # 16/08/2016 # Mahadev J # Map TimePatternRegime for old meter registers assets.
    CH06 # SM-2229 # 01/09/2016 # Mahadev J # Correction to Planned E Type mapping 
    CH07 # SR_EON_Jumbo_066 # 07/09/2016 # Mahadev J # Updated mapping for E Meter Location
    CH08 # NA # 19/10/2016 # Mahadev Joshilkar # Amended mapping for 'Effective Dates'
    CH09 # SR_EON_Jumbo_069 # 28/10/2016 # Mahadev J # Amend new mapping for field 'GSP Group ID'.
    CH10 # SR_EON_AB_172 # 31/10/2016 # Sivasankar K # Adding the Current Phase to store the number of phase valule comming from JUMBO
    CH11 # Production Issue reported by Danny # 02/03/2017 # Praveen G # Response_Data_C length is exceeded.
    CH12 # SR_EON_Jumbo_106 # 24/03/2017 # Mahasdev J # Amended to return all meter list from Jumbo
*/
public with sharing class EON_Jumbo_ReqElecMeterPointData {
    public static JUMBO_Data_Tracker__c cTrack;
    public static EON_Appointment__c apptIns;
    public static Map < string, EON_Vulnerability_Code__c > eonVulnerabilityCode; //CH03
    public static boolean isError = false; //Check any failure
    public static string Errors = ''; //Contain errors body if 'isError' is true
    public static list<EON_Appointment_Meter__c> allApptMeter; //CH12.New

    /**
        AccessElecMeterPointData(string mpanVal, EON_Appointment__c app, string jumboTraId, string EonTraId)
    **/
    public static void AccessElecMeterPointData(string mpanVal, EON_Appointment__c app, string jumboTraId, string EonTraId) {
        cTrack = new JUMBO_Data_Tracker__c();
        apptIns = new EON_Appointment__c();
        list < EON_Electric_Meter_Location__c > mtrLctn = new list < EON_Electric_Meter_Location__c > ();
        list < EON_Electric_Meter_Type__c > mtrType = new list < EON_Electric_Meter_Type__c > ();
        string tranID = EON_Utility.GenUniqueNum(); //generating unique random number value
        apptIns = app;
        cTrack.Direction__c = EON_Utility.DIRECTION_OUT;
        cTrack.Command__c = JUMBO_Utility.CMD_JUMBO_ReqElecMPAN;
        cTrack.Transaction_ID__c = tranID;
        if (jumboTraId != '') cTrack.JUMBO_Data_Tracker__c = id.ValueOf(jumboTraId);
        if (EonTraId != '') cTrack.EON_Data_Tracker__c = id.ValueOf(EonTraId);
        EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();

        //Creating requets to send to Jumbo
        if (!EON_Utility.validateRequired(mpanVal)) {
            EON_JUMBO_Work_Management_WS.ElecMeterPointDataRequest reqJumbo = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataRequest();
            EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
            ClientInfo.Id = system.label.EON_Jumbo_Client_Id;
            ClientInfo.Name = system.label.EON_Jumbo_Client_Name;
            reqJumbo.UniqueId = tranID;
            reqJumbo.MPAN = mpanVal;
            reqJumbo.Client = ClientInfo;
            cTrack.Request_Data__c = string.valueOf(reqJumbo); //populating request data
            //instantiating response object
            EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
            try {
                respJumbo = jumboObj.RequestElectricityMeterPointData(reqJumbo);
                if (respJumbo.Success) {
                    //Mapping values  
                    if (!EON_Utility.validateRequired(respJumbo.Customer)) {
                        if (!EON_Utility.validateRequired(respJumbo.Customer.MPAN))
                            apptIns.MPAN__c = respJumbo.Customer.MPAN;
                        if (!EON_Utility.validateRequired(respJumbo.Customer.AdditionalInformation))
                            apptIns.Additional_Information__c = respJumbo.Customer.AdditionalInformation;
                        if (!EON_Utility.validateRequired(respJumbo.Customer.ContractReference))
                            apptIns.Contract_Reference__c = respJumbo.Customer.ContractReference;
                        //Checking StdSettlementConfig object for null values  
                        if (!EON_Utility.validateRequired(respJumbo.Customer.StdSettlementConfig)) {
                            if (!EON_Utility.validateRequired(respJumbo.Customer.StdSettlementConfig.id))
                                apptIns.Current_SSC__c = respJumbo.Customer.StdSettlementConfig.id;
                        }
                        if (!EON_Utility.validateRequired(respJumbo.Customer.CustomerName))
                            apptIns.Customer_Name__c = respJumbo.Customer.CustomerName;
                        if (!EON_Utility.validateRequired(respJumbo.Customer.GridSupplyPointsGroupId)) //CH09.New
                         apptIns.GSP_Group_ID__c = respJumbo.Customer.GridSupplyPointsGroupId; //CH09.New
                          //apptIns.GSP_Group_ID__c ='_N';
                        //Checking supply object for null values   
                        if (!EON_Utility.validateRequired(respJumbo.Customer.Supply)) {
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Supply.EnergisationStatus))
                                apptIns.Energisation_Status__c = respJumbo.Customer.Supply.EnergisationStatus;
                            //Number of Phases   
                            apptIns.Number_of_Phases__c = nPhases(respJumbo.Customer.Supply.Phases); //CH02
                            apptIns.Current_Phase__c = nPhases(respJumbo.Customer.Supply.Phases); //CH10
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Supply.Voltage))
                                apptIns.Supply_Voltage__c = Decimal.valueOf(respJumbo.Customer.Supply.Voltage);
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Supply.Capacity))
                                apptIns.Supply_Capacity__c = Decimal.valueOf(respJumbo.Customer.Supply.Capacity);
                        }
                        //Checking CustomerContact object for null values
                        if (!EON_Utility.validateRequired(respJumbo.Customer.CustomerContact)) {
                            if (!EON_Utility.validateRequired(respJumbo.Customer.CustomerContact.Name))
                                apptIns.Contact_Name__c = respJumbo.Customer.CustomerContact.Name;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.CustomerContact.Telephone))
                                apptIns.Contact_Telephone_Number__c = respJumbo.Customer.CustomerContact.Telephone;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.CustomerContact.PreferredContactMethod))
                                apptIns.Customer_Preferred_Contact_Method__c = respJumbo.Customer.CustomerContact.PreferredContactMethod;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.CustomerContact.Email))
                                apptIns.Contact_Email__c = respJumbo.Customer.CustomerContact.Email;
                        }
                        if (!EON_Utility.validateRequired(respJumbo.Customer.SpecialAccess))
                            apptIns.Special_Access__c = respJumbo.Customer.SpecialAccess;
                        if (!EON_Utility.validateRequired(respJumbo.Customer.CustomerPassword))
                            apptIns.Access_Pass_Phrase__c = respJumbo.Customer.CustomerPassword;
                        //Checking MeterPointAddress object for null values
                        if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress)) {
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.PostCode))
                                apptIns.Metering_Point_Postcode__c = respJumbo.Customer.MeterPointAddress.PostCode;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.Line1))
                                apptIns.Metering_Point_Address_Line_1__c = respJumbo.Customer.MeterPointAddress.Line1;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.Line2))
                                apptIns.Metering_Point_Address_Line_2__c = respJumbo.Customer.MeterPointAddress.Line2;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.Line3))
                                apptIns.Metering_Point_Address_Line_3__c = respJumbo.Customer.MeterPointAddress.Line3;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.Line4))
                                apptIns.Metering_Point_Address_Line_4__c = respJumbo.Customer.MeterPointAddress.Line4;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.Line5))
                                apptIns.Metering_Point_Address_Line_5__c = respJumbo.Customer.MeterPointAddress.Line5;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.Line6))
                                apptIns.Metering_Point_Address_Line_6__c = respJumbo.Customer.MeterPointAddress.Line6;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.Line7))
                                apptIns.Metering_Point_Address_Line_7__c = respJumbo.Customer.MeterPointAddress.Line7;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.Line8))
                                apptIns.Metering_Point_Address_Line_8__c = respJumbo.Customer.MeterPointAddress.Line8;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.MeterPointAddress.Line9))
                                apptIns.Metering_Point_Address_Line_9__c = respJumbo.Customer.MeterPointAddress.Line9;
                        }
                        //Checking PriorityServiceContactInfo object for null values
                        if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo)) {
                            if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.AlternateName))
                                apptIns.Alternate_Priority_Service_Contact_Name__c = respJumbo.Customer.PriorityServiceContactInfo.AlternateName;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Telephone1))
                                apptIns.Primary_Priority_Service_Phone_Number_1__c = respJumbo.Customer.PriorityServiceContactInfo.Telephone1;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Name))
                                apptIns.Primary_Priority_Service_Contact_Name__c = respJumbo.Customer.PriorityServiceContactInfo.Name;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Telephone3))
                                apptIns.Primary_Priority_Service_Phone_Number_2__c = respJumbo.Customer.PriorityServiceContactInfo.Telephone3;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.AlternateTelephone1))
                                apptIns.Alternate_Priority_Service_PhoneNumber1__c = respJumbo.Customer.PriorityServiceContactInfo.AlternateTelephone1;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.AlternateTelephone2))
                                apptIns.Alternate_Priority_Service_PhoneNumber2__c = respJumbo.Customer.PriorityServiceContactInfo.AlternateTelephone2;
                            //Checking Address object for null values
                            if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address)) {
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.Line1))
                                    apptIns.Priority_Service_Contact_Address_Line_1__c = respJumbo.Customer.PriorityServiceContactInfo.Address.Line1;
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.Line2))
                                    apptIns.Priority_Service_Contact_Address_Line_2__c = respJumbo.Customer.PriorityServiceContactInfo.Address.Line2;
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.Line3))
                                    apptIns.Priority_Service_Contact_Address_Line_3__c = respJumbo.Customer.PriorityServiceContactInfo.Address.Line3;
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.Line4))
                                    apptIns.Priority_Service_Contact_Address_Line_4__c = respJumbo.Customer.PriorityServiceContactInfo.Address.Line4;
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.Line5))
                                    apptIns.Priority_Service_Contact_Address_Line_5__c = respJumbo.Customer.PriorityServiceContactInfo.Address.Line5;
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.Line6))
                                    apptIns.Priority_Service_Contact_Address_Line_6__c = respJumbo.Customer.PriorityServiceContactInfo.Address.Line6;
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.Line7))
                                    apptIns.Priority_Service_Contact_Address_Line_7__c = respJumbo.Customer.PriorityServiceContactInfo.Address.Line7;
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.Line8))
                                    apptIns.Priority_Service_Contact_Address_Line_8__c = respJumbo.Customer.PriorityServiceContactInfo.Address.Line8;
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.Line9))
                                    apptIns.Priority_Service_Contact_Address_Line_9__c = respJumbo.Customer.PriorityServiceContactInfo.Address.Line9;
                                if (!EON_Utility.validateRequired(respJumbo.Customer.PriorityServiceContactInfo.Address.PostCode))
                                    apptIns.Priority_Service_Contact_Postcode__c = respJumbo.Customer.PriorityServiceContactInfo.Address.PostCode;
                            }
                        }
                        // SpecialNeedsCategory information //CH03.Start
                        if (!EON_Utility.validateRequired(respJumbo.Customer.SpecialNeeds)) {
                            list < decimal > allJumboCategory = new list < decimal > ();
                            EON_JUMBO_Work_Management_WS.ArrayOfSpecialNeed arrayOfJumboVulnerability = respJumbo.Customer.SpecialNeeds;
                            if (!EON_Utility.validateRequired(arrayOfJumboVulnerability.SpecialNeed)) {
                                list < EON_JUMBO_Work_Management_WS.SpecialNeed > allJumboVulnerability = arrayOfJumboVulnerability.SpecialNeed;
                                if (!allJumboVulnerability.isEmpty()) {
                                    for (EON_JUMBO_Work_Management_WS.SpecialNeed specialNeed: allJumboVulnerability) {
                                        if (!EON_Utility.validateRequired(specialNeed.Category))
                                            allJumboCategory.add(decimal.valueOf(specialNeed.Category));
                                    }
                                    if (!allJumboCategory.isEmpty()) {
                                        list < EON_Vulnerability_Code__c > allEONVulnerabilityCode = new list < EON_Vulnerability_Code__c > ();
                                        allEONVulnerabilityCode = [Select ID, Name, Vulnerability_Code__c from EON_Vulnerability_Code__c where JUMBO_Vulnerability_Code__c = : allJumboCategory];
                                        if (!allEONVulnerabilityCode.isEmpty()) {
                                            eonVulnerabilityCode = new map < String, EON_Vulnerability_Code__c > ();
                                            for (EON_Vulnerability_Code__c eonVulCode: allEONVulnerabilityCode)
                                                eonVulnerabilityCode.put(String.valueOf(eonVulCode.Vulnerability_Code__c), eonVulCode);
                                        }
                                    }
                                }
                            }
                        }
                        //CH03.End
                        //Effective Dates //CH08.New.Start
                        if (!EON_Utility.validateRequired(respJumbo.Customer.DataCollector)) {
                            if (!EON_Utility.validateRequired(respJumbo.Customer.DataCollector.EffectiveFromDate)) {
                                apptIns.Effective_From_Date__c = JUMBO_Utility.strigToDate(respJumbo.Customer.DataCollector.EffectiveFromDate);
                            }
                            if (!EON_Utility.validateRequired(respJumbo.Customer.DataCollector.EffectiveToDate)) {
                                apptIns.Effective_To_Date__c = JUMBO_Utility.strigToDate(respJumbo.Customer.DataCollector.EffectiveToDate);
                            } 
                        } //CH08.New.End
                        //Checking Meters object for null values
                        if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter)) {
                            //Ch12.New.Start
                            allApptMeter = new list<EON_Appointment_Meter__c>();
                            EON_JUMBO_Work_Management_WS.ElecMeter[] allMeters = respJumbo.Customer.Meters.elecmeter;
                            for(EON_JUMBO_Work_Management_WS.ElecMeter meter:allMeters){
                                EON_Appointment_Meter__c appMeter = new EON_Appointment_Meter__c();
                                appMeter.Name = meter.SerialNumber;
                                appMeter.E_Meter_Make__c = meter.ManufacturerAndModel;
                                if(!EON_Utility.validateRequired(meter.Type_x)){
                                    list<EON_Electric_Meter_Type__c> allMtrType = new list<EON_Electric_Meter_Type__c>();
                                    allMtrType = [select id from EON_Electric_Meter_Type__c where name = : meter.Type_x limit 1];
                                    if (allMtrType.size() > 0)
                                        appMeter.E_Meter_Type__c = allMtrType[0].id;
                                }
                                if (!EON_Utility.validateRequired(meter.Registers.ElecRegister)) {
                                    if(meter.Registers.ElecRegister.size() > 0){
                                        appMeter.E_Meter_Register_1_ID__c = meter.Registers.ElecRegister[0].id;
                                        if (!EON_Utility.validateRequired(meter.Registers.ElecRegister[0].TimePatternRegimes)) {
                                            String[] timePatternRegimes = getTimePatternRegime(meter.Registers.ElecRegister[0].TimePatternRegimes);
                                            if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                                if (!timePatternRegimes.isEmpty()) {
                                                    if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                        appMeter.Register_1_TPR_1__c = timePatternRegimes[0];
                                                    if (timePatternRegimes.size() > 1)
                                                        appMeter.Register_1_TPR_2__c = timePatternRegimes[1];
                                                }
                                            }
                                        }
                                    }
                                    if(meter.Registers.ElecRegister.size() > 1) {
                                        appMeter.E_Meter_Register_2_ID__c = meter.Registers.ElecRegister[1].id;
                                        if (!EON_Utility.validateRequired(meter.Registers.ElecRegister[1].TimePatternRegimes)) {
                                            String[] timePatternRegimes = getTimePatternRegime(meter.Registers.ElecRegister[1].TimePatternRegimes);
                                            if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                                if (!timePatternRegimes.isEmpty()) {
                                                    if(!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                        appMeter.Register_2_TPR_1__c = timePatternRegimes[0];
                                                    if (timePatternRegimes.size() > 1)
                                                        appMeter.Register_2_TPR_2__c = timePatternRegimes[1];
                                                }
                                            }
                                        }
                                    }
                                    if(meter.Registers.ElecRegister.size() > 2) {
                                        appMeter.E_Meter_Register_3_ID__c = meter.Registers.ElecRegister[2].id;
                                        if (!EON_Utility.validateRequired(meter.Registers.ElecRegister[2].TimePatternRegimes)) {
                                            String[] timePatternRegimes = getTimePatternRegime(meter.Registers.ElecRegister[2].TimePatternRegimes);
                                            if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                                if (!timePatternRegimes.isEmpty()) {
                                                    if(!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                        appMeter.Register_3_TPR_1__c = timePatternRegimes[0];
                                                    if (timePatternRegimes.size() > 1)
                                                        appMeter.Register_3_TPR_2__c = timePatternRegimes[1];
                                                }
                                            }
                                        }
                                    }
                                    if(meter.Registers.ElecRegister.size() > 3) {
                                        appMeter.E_Meter_Register_4_ID__c = meter.Registers.ElecRegister[3].id;
                                        if (!EON_Utility.validateRequired(meter.Registers.ElecRegister[3].TimePatternRegimes)) {
                                            String[] timePatternRegimes = getTimePatternRegime(meter.Registers.ElecRegister[3].TimePatternRegimes);
                                            if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                                if (!timePatternRegimes.isEmpty()) {
                                                    if(!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                        appMeter.Register_4_TPR_1__c = timePatternRegimes[0];
                                                    if (timePatternRegimes.size() > 1)
                                                        appMeter.Register_4_TPR_2__c = timePatternRegimes[1];
                                                }
                                            }
                                        }
                                    }
                                    if(meter.Registers.ElecRegister.size() > 4) {
                                        appMeter.E_Meter_Register_5_ID__c = meter.Registers.ElecRegister[4].id;
                                        if (!EON_Utility.validateRequired(meter.Registers.ElecRegister[4].TimePatternRegimes)) {
                                            String[] timePatternRegimes = getTimePatternRegime(meter.Registers.ElecRegister[4].TimePatternRegimes);
                                            if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                                if (!timePatternRegimes.isEmpty()) {
                                                    if(!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                        appMeter.Register_5_TPR_1__c = timePatternRegimes[0];
                                                    if (timePatternRegimes.size() > 1)
                                                        appMeter.Register_5_TPR_2__c = timePatternRegimes[1];
                                                }
                                            }
                                        }
                                    }
                                    if(meter.Registers.ElecRegister.size() > 5) {
                                        appMeter.E_Meter_Register_6_ID__c = meter.Registers.ElecRegister[5].id;
                                        if (!EON_Utility.validateRequired(meter.Registers.ElecRegister[5].TimePatternRegimes)) {
                                            String[] timePatternRegimes = getTimePatternRegime(meter.Registers.ElecRegister[5].TimePatternRegimes);
                                            if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                                if (!timePatternRegimes.isEmpty()) {
                                                    if(!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                        appMeter.Register_6_TPR_1__c = timePatternRegimes[0];
                                                    if (timePatternRegimes.size() > 1)
                                                        appMeter.Register_6_TPR_2__c = timePatternRegimes[1];
                                                }
                                            }
                                        }
                                    }
                                }
                                allApptMeter.add(appMeter);
                            }
                            //CH12.New.End
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].SerialNumber))
                                apptIns.E_Meter_Serial_Number__c = respJumbo.Customer.Meters.elecmeter[0].SerialNumber;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].ManufacturerAndModel))
                                apptIns.E_Meter_Make_Model__c = respJumbo.Customer.Meters.elecmeter[0].ManufacturerAndModel;
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].location))
                                mtrLctn = [select name from EON_Electric_Meter_Location__c where Code__c = : respJumbo.Customer.Meters.elecmeter[0].location limit 1];
                            if (mtrLctn.size() > 0)
                                apptIns.E_Meter_Location__c = mtrLctn[0].id; //CH07.New
                            //apptIns.E_Location_Code__c =mtrLctn[0].id;     //CH07.Old
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].CertificationExpiryDate))
                                apptIns.Certification_Expiry_Date__c = JUMBO_Utility.strigToDate(respJumbo.Customer.Meters.elecmeter[0].CertificationExpiryDate);
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].Type_x)) {
                                mtrType = [select id from EON_Electric_Meter_Type__c where name = : respJumbo.Customer.Meters.elecmeter[0].Type_x limit 1];
                                if (mtrType.size() > 0)
                                    apptIns.E_Meter_Type__c = mtrType[0].id;
                                //CH01.Start
                                if (!EON_Utility.validateRequired(PlannedMtrType(respJumbo.Customer.Meters.elecmeter[0].Type_x)))
                                    apptIns.Planned_E_Meter_Type__c = PlannedMtrType(respJumbo.Customer.Meters.elecmeter[0].Type_x);
                                    system.debug('Value of apptIns.Planned_E_Meter_Type__c %%%%%%%%'+apptIns.Planned_E_Meter_Type__c);
                                //CH01.End
                            }
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].CurrentRating))
                                apptIns.Meter_Current_Rating__c = Decimal.valueof(respJumbo.Customer.Meters.elecmeter[0].CurrentRating);
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].TimingDeviceSerialNumber))
                                apptIns.Timing_Device_Serial_Number__c = respJumbo.Customer.Meters.elecmeter[0].TimingDeviceSerialNumber;
                            //Checking Registers object for null values
                            if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister)) {
                                if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].id)) {
                                    apptIns.E_Meter_Register_1_ID__c = respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].id;
                                    //CH05.Start
                                    if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_1_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_1_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                    //CH05.End
                                }
                                if (respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].MeterMemoryLocation != null)
                                    apptIns.Meter_Memory_Location__c = respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].MeterMemoryLocation;
                                if (respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 1) {
                                    apptIns.E_Meter_Register_2_ID__c = respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[1].id;
                                    //CH05.Start
                                    if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[1].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[1].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_2_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_2_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                    //CH05.End
                                }
                                if (respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 2) {
                                    apptIns.E_Meter_Register_3_ID__c = respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[2].id;
                                    //CH05.Start
                                    if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[2].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[2].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_3_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_3_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                    //CH05.End
                                }
                                if (respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 3) {
                                    apptIns.E_Meter_Register_4_ID__c = respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[3].id;
                                    //CH05.Start
                                    if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[3].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[3].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_4_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_4_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                    //CH05.End
                                }
                                if (respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 4) {
                                    apptIns.E_Meter_Register_5_ID__c = respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[4].id;
                                    //CH05.Start
                                    if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[4].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[4].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_5_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_5_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                    //CH05.End
                                }
                                if (respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 5) {
                                    apptIns.E_Meter_Register_6_ID__c = respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[5].id;
                                    //CH05.Start
                                    if (!EON_Utility.validateRequired(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[5].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respJumbo.Customer.Meters.elecmeter[0].Registers.ElecRegister[5].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_6_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_6_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                    //CH05.End
                                }
                            }
                        }
                        cTrack.Response_Data__c = string.ValueOf(respJumbo); //populating response data 
                        
                        //CH11.New.Start
                        if((cTrack.Response_Data__c != null && cTrack.Response_Data__c.length() > 131070))
                             cTrack.Response_Data__c = cTrack.Response_Data__c.substring(0, 131070);   
                        //CH11.New.End
                        
                        cTrack.Status__c = EON_Utility.RESULT_PASS;
                    }
                } else {
                    cTrack.Response_Data__c = string.ValueOf(respJumbo); //populating response data
                    //CH11.New.Start
                    if((cTrack.Response_Data__c != null && cTrack.Response_Data__c.length() > 131070))
                         cTrack.Response_Data__c = cTrack.Response_Data__c.substring(0, 131070);   
                    //CH11.New.End                    
                    cTrack.Status__c = EON_Utility.RESULT_PASS;
                    for (String str: respJumbo.Errors.Message)
                        Errors = Errors + str + '\n';
                    isError = true;
                }
            } catch (Exception e) {
                cTrack.Response_Data__c = e.getMessage() + '\n' + e.getStackTraceString() + '\n' + e.getLineNumber() + '\n' + cTrack.Response_Data__c;
                cTrack.Status__c = EON_Utility.RESULT_FAIL;
                Errors = cTrack.Response_Data__c;
                isError = true;
            }
        } else {
            Errors = 'MPAN cannot pass as Blank to access Electeric meter data';
            isError = true;
        }
    }
    /** 
        string PlannedMtrType(string mtrType): Method to return Planned E Meter Type. 
    **/
    //CH01.Start
    public static string PlannedMtrType(string mtrType) {
        //CH06.New
        return ((EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll() != null && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(mtrType.toUpperCase()) && EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(mtrType.toUpperCase()).Meter_Type__c == 'E') ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(mtrType.toUpperCase()).Planned_Meter_Type__c : null);
    }
    //CH01.End
    //CH02.Start
    /** 
        string nPhases(string pHases): Method to return Number of Phases. 
    **/
    public static string nPhases(string pHases) {
        if (pHases == '3')
            return '3Ph';
        else
            return '1Ph';
    }
    //CH02.End
    //CH05.Start
    /**
        getTimePatternRegime(): This function will add extra zero to TimePatternRegime received from Jumbo
    **/
    public static string[] getTimePatternRegime(EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime jumboTPR) {
        string[] allTPR = new string[] {};
        String addZero = '', tprCode = '';
        list < EON_JUMBO_Work_Management_WS.TimePatternRegime > listTPR = new list < EON_JUMBO_Work_Management_WS.TimePatternRegime > ();
        if (!EON_Utility.validateRequired(jumboTPR)) {
            if (!EON_Utility.validateRequired(jumboTPR.TimePatternRegime)) {
                listTPR.addAll(jumboTPR.TimePatternRegime);
                for (EON_JUMBO_Work_Management_WS.TimePatternRegime tpr: listTPR) {
                    addZero = '';
                    if (!EON_Utility.validateRequired(tpr.code)) {
                        tprCode = tpr.code;
                        if (tprCode.length() < 5) {
                            for (integer i = 0; i < 5 - tprCode.length(); i++)
                                addZero = '0' + addZero;
                            tprCode = addZero + tprCode;
                        }
                        allTPR.add(tprCode);
                    }
                }
            }
        }
        return allTPR;
    }
    //CH05.End
}