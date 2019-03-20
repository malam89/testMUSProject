/**
    Description : This class is used To provide Electricity Meter Point data relating to a specific MPAN using the MPAN as the matching key for MDS.
				  This class functionality is replicated from Apex Class - EON_MDS_ReqElectricityMOP
    Test Class  : EON_MDS_ElecGasData_Test
**/
/*
    Created By  : Tabish Almas
    Created On  : 29/01/2019
    Service Req : SR_OptiMUS_EON_297
    Change History
	
*/
public with sharing class EON_MDS_ReqElecMeterPointData {
	public static MDS_Data_Tracker__c cTrack;
    public static EON_Appointment__c apptIns;
    public static Map < string, EON_Vulnerability_Code__c > eonVulnerabilityCode; 
    public static boolean isError = false; //Check any failure
    public static string Errors = ''; //Contain errors body if 'isError' is true
    public static list<EON_Appointment_Meter__c> allApptMeter;
    
    /**
        AccessElecMeterPointData(string mpanVal, EON_Appointment__c app, string MDSTraId, string EonTraId)
    **/
    public static void AccessElecMeterPointData(string mpanVal, EON_Appointment__c app, string MDSTraId, string EonTraId) {
    	cTrack = new MDS_Data_Tracker__c();
        apptIns = new EON_Appointment__c();
        list < EON_Electric_Meter_Location__c > mtrLctn = new list < EON_Electric_Meter_Location__c > ();
        list < EON_Electric_Meter_Type__c > mtrType = new list < EON_Electric_Meter_Type__c > ();
        string tranID = EON_Utility.GenUniqueNum(); //generating unique random number value
        apptIns = app;
        cTrack.Direction__c = EON_Utility.DIRECTION_OUT;
        cTrack.Command__c = EON_MDS_Utility.CMD_MDS_ReqElecMPAN;
        cTrack.Transaction_ID__c = tranID;
        if (MDSTraId != '') cTrack.MDS_Data_Tracker__c = id.ValueOf(MDSTraId);
        if (EonTraId != '') cTrack.EON_Data_Tracker__c = id.ValueOf(EonTraId);
        EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement MDSObj = new EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement();
        string Access_Token = system.label.EON_MDS_AccessToken;
        MDSObj.inputHttpHeaders_x = new Map<String, String>();
        MDSObj.inputHttpHeaders_x.put('Authorization','Bearer ' + Access_Token);
        
        //Creating requets to send to MDS
        if (!EON_Utility.validateRequired(mpanVal)) {
        	EON_MDS_Work_Management_WS.ElecMeterPointDataRequest reqMDS = new EON_MDS_Work_Management_WS.ElecMeterPointDataRequest();
            EON_MDS_Work_Management_WS.ClientData clientInfo = new EON_MDS_Work_Management_WS.ClientData();
            ClientInfo.Id = system.label.EON_MDS_Client_Id;
            ClientInfo.Name = system.label.EON_MDS_Client_Name;
            reqMDS.UniqueId = tranID;
            reqMDS.MPAN = mpanVal;
            reqMDS.Client = ClientInfo;
            cTrack.Request_Data__c = string.valueOf(reqMDS); //populating request data
            //instantiating response object
            EON_MDS_Work_Management_WS.ElecMeterPointDataResponse respMDS = new EON_MDS_Work_Management_WS.ElecMeterPointDataResponse();
            try {
                respMDS = MDSObj.RequestElectricityMeterPointData(reqMDS);
                if (respMDS.Success) {
                	//Mapping values
                	if (!EON_Utility.validateRequired(respMDS.Customer)) {
                    	if (!EON_Utility.validateRequired(respMDS.Customer.MPAN))
                            apptIns.MPAN__c = respMDS.Customer.MPAN;
                        if (!EON_Utility.validateRequired(respMDS.Customer.AdditionalInformation))
                            apptIns.Additional_Information__c = respMDS.Customer.AdditionalInformation;
                        if (!EON_Utility.validateRequired(respMDS.Customer.ContractReference))
                            apptIns.Contract_Reference__c = respMDS.Customer.ContractReference;
                        //Checking StdSettlementConfig object for null values  
                        if (!EON_Utility.validateRequired(respMDS.Customer.StdSettlementConfig)) {
                            if (!EON_Utility.validateRequired(respMDS.Customer.StdSettlementConfig.id))
                                apptIns.Current_SSC__c = respMDS.Customer.StdSettlementConfig.id;
                        }
                        if (!EON_Utility.validateRequired(respMDS.Customer.CustomerName))
                            apptIns.Customer_Name__c = respMDS.Customer.CustomerName;
                        if (!EON_Utility.validateRequired(respMDS.Customer.GridSupplyPointsGroupId))
                         apptIns.GSP_Group_ID__c = respMDS.Customer.GridSupplyPointsGroupId;
                          //apptIns.GSP_Group_ID__c ='_N';
                        //Checking supply object for null values   
                        if (!EON_Utility.validateRequired(respMDS.Customer.Supply)) {
                            if (!EON_Utility.validateRequired(respMDS.Customer.Supply.EnergisationStatus))
                                apptIns.Energisation_Status__c = respMDS.Customer.Supply.EnergisationStatus;
                            //Number of Phases   
                            apptIns.Number_of_Phases__c = nPhases(respMDS.Customer.Supply.Phases); 
                            apptIns.Current_Phase__c = nPhases(respMDS.Customer.Supply.Phases); 
                            if (!EON_Utility.validateRequired(respMDS.Customer.Supply.Voltage))
                                apptIns.Supply_Voltage__c = Decimal.valueOf(respMDS.Customer.Supply.Voltage);
                            if (!EON_Utility.validateRequired(respMDS.Customer.Supply.Capacity))
                                apptIns.Supply_Capacity__c = Decimal.valueOf(respMDS.Customer.Supply.Capacity);
                        }
                        //Checking CustomerContact object for null values
                        if (!EON_Utility.validateRequired(respMDS.Customer.CustomerContact)) {
                            if (!EON_Utility.validateRequired(respMDS.Customer.CustomerContact.Name))
                                apptIns.Contact_Name__c = respMDS.Customer.CustomerContact.Name;
                            if (!EON_Utility.validateRequired(respMDS.Customer.CustomerContact.Telephone))
                                apptIns.Contact_Telephone_Number__c = respMDS.Customer.CustomerContact.Telephone;
                            if (!EON_Utility.validateRequired(respMDS.Customer.CustomerContact.PreferredContactMethod))
                                apptIns.Customer_Preferred_Contact_Method__c = respMDS.Customer.CustomerContact.PreferredContactMethod;
                            if (!EON_Utility.validateRequired(respMDS.Customer.CustomerContact.Email))
                                apptIns.Contact_Email__c = respMDS.Customer.CustomerContact.Email;
                        }
                        if (!EON_Utility.validateRequired(respMDS.Customer.SpecialAccess))
                            apptIns.Special_Access__c = respMDS.Customer.SpecialAccess;
                        if (!EON_Utility.validateRequired(respMDS.Customer.CustomerPassword))
                            apptIns.Access_Pass_Phrase__c = respMDS.Customer.CustomerPassword;
                        //Checking MeterPointAddress object for null values
                        if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress)) {
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.PostCode))
                                apptIns.Metering_Point_Postcode__c = respMDS.Customer.MeterPointAddress.PostCode;
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.Line1))
                                apptIns.Metering_Point_Address_Line_1__c = respMDS.Customer.MeterPointAddress.Line1;
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.Line2))
                                apptIns.Metering_Point_Address_Line_2__c = respMDS.Customer.MeterPointAddress.Line2;
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.Line3))
                                apptIns.Metering_Point_Address_Line_3__c = respMDS.Customer.MeterPointAddress.Line3;
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.Line4))
                                apptIns.Metering_Point_Address_Line_4__c = respMDS.Customer.MeterPointAddress.Line4;
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.Line5))
                                apptIns.Metering_Point_Address_Line_5__c = respMDS.Customer.MeterPointAddress.Line5;
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.Line6))
                                apptIns.Metering_Point_Address_Line_6__c = respMDS.Customer.MeterPointAddress.Line6;
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.Line7))
                                apptIns.Metering_Point_Address_Line_7__c = respMDS.Customer.MeterPointAddress.Line7;
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.Line8))
                                apptIns.Metering_Point_Address_Line_8__c = respMDS.Customer.MeterPointAddress.Line8;
                            if (!EON_Utility.validateRequired(respMDS.Customer.MeterPointAddress.Line9))
                                apptIns.Metering_Point_Address_Line_9__c = respMDS.Customer.MeterPointAddress.Line9;
                        }
                        //Checking PriorityServiceContactInfo object for null values
                        if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo)) {
                            if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.AlternateName))
                                apptIns.Alternate_Priority_Service_Contact_Name__c = respMDS.Customer.PriorityServiceContactInfo.AlternateName;
                            if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Telephone1))
                                apptIns.Primary_Priority_Service_Phone_Number_1__c = respMDS.Customer.PriorityServiceContactInfo.Telephone1;
                            if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Name))
                                apptIns.Primary_Priority_Service_Contact_Name__c = respMDS.Customer.PriorityServiceContactInfo.Name;
                            if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Telephone3))
                                apptIns.Primary_Priority_Service_Phone_Number_2__c = respMDS.Customer.PriorityServiceContactInfo.Telephone3;
                            if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.AlternateTelephone1))
                                apptIns.Alternate_Priority_Service_PhoneNumber1__c = respMDS.Customer.PriorityServiceContactInfo.AlternateTelephone1;
                            if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.AlternateTelephone2))
                                apptIns.Alternate_Priority_Service_PhoneNumber2__c = respMDS.Customer.PriorityServiceContactInfo.AlternateTelephone2;
                            //Checking Address object for null values
                            if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address)) {
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.Line1))
                                    apptIns.Priority_Service_Contact_Address_Line_1__c = respMDS.Customer.PriorityServiceContactInfo.Address.Line1;
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.Line2))
                                    apptIns.Priority_Service_Contact_Address_Line_2__c = respMDS.Customer.PriorityServiceContactInfo.Address.Line2;
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.Line3))
                                    apptIns.Priority_Service_Contact_Address_Line_3__c = respMDS.Customer.PriorityServiceContactInfo.Address.Line3;
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.Line4))
                                    apptIns.Priority_Service_Contact_Address_Line_4__c = respMDS.Customer.PriorityServiceContactInfo.Address.Line4;
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.Line5))
                                    apptIns.Priority_Service_Contact_Address_Line_5__c = respMDS.Customer.PriorityServiceContactInfo.Address.Line5;
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.Line6))
                                    apptIns.Priority_Service_Contact_Address_Line_6__c = respMDS.Customer.PriorityServiceContactInfo.Address.Line6;
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.Line7))
                                    apptIns.Priority_Service_Contact_Address_Line_7__c = respMDS.Customer.PriorityServiceContactInfo.Address.Line7;
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.Line8))
                                    apptIns.Priority_Service_Contact_Address_Line_8__c = respMDS.Customer.PriorityServiceContactInfo.Address.Line8;
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.Line9))
                                    apptIns.Priority_Service_Contact_Address_Line_9__c = respMDS.Customer.PriorityServiceContactInfo.Address.Line9;
                                if (!EON_Utility.validateRequired(respMDS.Customer.PriorityServiceContactInfo.Address.PostCode))
                                    apptIns.Priority_Service_Contact_Postcode__c = respMDS.Customer.PriorityServiceContactInfo.Address.PostCode;
                            }
                        }
                        // SpecialNeedsCategory information //CH03.Start
                        if (!EON_Utility.validateRequired(respMDS.Customer.SpecialNeeds)) {
                            list < decimal > allMDSCategory = new list < decimal > ();
                            EON_MDS_Work_Management_WS.ArrayOfSpecialNeed arrayOfMDSVulnerability = respMDS.Customer.SpecialNeeds;
                            if (!EON_Utility.validateRequired(arrayOfMDSVulnerability.SpecialNeed)) {
                                list < EON_MDS_Work_Management_WS.SpecialNeed > allMDSVulnerability = arrayOfMDSVulnerability.SpecialNeed;
                                if (!allMDSVulnerability.isEmpty()) {
                                    for (EON_MDS_Work_Management_WS.SpecialNeed specialNeed: allMDSVulnerability) {
                                        if (!EON_Utility.validateRequired(specialNeed.Category))
                                            allMDSCategory.add(decimal.valueOf(specialNeed.Category));
                                    }
                                    if (!allMDSCategory.isEmpty()) {
                                        list < EON_Vulnerability_Code__c > allEONVulnerabilityCode = new list < EON_Vulnerability_Code__c > ();
                                        allEONVulnerabilityCode = [Select ID, Name, Vulnerability_Code__c from EON_Vulnerability_Code__c where JUMBO_Vulnerability_Code__c = : allMDSCategory];	//#TODO: Create MDS_Vulnerability_Code__c?
                                        if (!allEONVulnerabilityCode.isEmpty()) {
                                            eonVulnerabilityCode = new map < String, EON_Vulnerability_Code__c > ();
                                            for (EON_Vulnerability_Code__c eonVulCode: allEONVulnerabilityCode)
                                                eonVulnerabilityCode.put(String.valueOf(eonVulCode.Vulnerability_Code__c), eonVulCode);
                                        }
                                    }
                                }
                            }
                        }
                        //Effective Dates
                        if (!EON_Utility.validateRequired(respMDS.Customer.DataCollector)) {
                            if (!EON_Utility.validateRequired(respMDS.Customer.DataCollector.EffectiveFromDate)) {
                                apptIns.Effective_From_Date__c = EON_MDS_Utility.strigToDate(respMDS.Customer.DataCollector.EffectiveFromDate);
                            }
                            if (!EON_Utility.validateRequired(respMDS.Customer.DataCollector.EffectiveToDate)) {
                                apptIns.Effective_To_Date__c = EON_MDS_Utility.strigToDate(respMDS.Customer.DataCollector.EffectiveToDate);
                            } 
                        }
                        //Checking Meters object for null values
                        if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter)) {
                        	allApptMeter = new list<EON_Appointment_Meter__c>();
                            EON_MDS_Work_Management_WS.ElecMeter[] allMeters = respMDS.Customer.Meters.elecmeter;
                            for(EON_MDS_Work_Management_WS.ElecMeter meter:allMeters){
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
                            if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].SerialNumber))
                                apptIns.E_Meter_Serial_Number__c = respMDS.Customer.Meters.elecmeter[0].SerialNumber;
                            if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].ManufacturerAndModel))
                                apptIns.E_Meter_Make_Model__c = respMDS.Customer.Meters.elecmeter[0].ManufacturerAndModel;
                            if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].location))
                                mtrLctn = [select name from EON_Electric_Meter_Location__c where Code__c = : respMDS.Customer.Meters.elecmeter[0].location limit 1];
                            if (mtrLctn.size() > 0)
                                apptIns.E_Meter_Location__c = mtrLctn[0].id; 
                            //apptIns.E_Location_Code__c =mtrLctn[0].id;    
                            if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].CertificationExpiryDate))
                                apptIns.Certification_Expiry_Date__c = EON_MDS_Utility.strigToDate(respMDS.Customer.Meters.elecmeter[0].CertificationExpiryDate);
                            if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].Type_x)) {
                                mtrType = [select id from EON_Electric_Meter_Type__c where name = : respMDS.Customer.Meters.elecmeter[0].Type_x limit 1];
                                if (mtrType.size() > 0)
                                    apptIns.E_Meter_Type__c = mtrType[0].id;
                                if (!EON_Utility.validateRequired(PlannedMtrType(respMDS.Customer.Meters.elecmeter[0].Type_x)))
                                    apptIns.Planned_E_Meter_Type__c = PlannedMtrType(respMDS.Customer.Meters.elecmeter[0].Type_x);
                                    system.debug('Value of apptIns.Planned_E_Meter_Type__c %%%%%%%%'+apptIns.Planned_E_Meter_Type__c);
                            }
                            if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].CurrentRating))
                                apptIns.Meter_Current_Rating__c = Decimal.valueof(respMDS.Customer.Meters.elecmeter[0].CurrentRating);
                            if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].TimingDeviceSerialNumber))
                                apptIns.Timing_Device_Serial_Number__c = respMDS.Customer.Meters.elecmeter[0].TimingDeviceSerialNumber;
                            //Checking Registers object for null values
                            if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister)) {
                                if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].id)) {
                                    apptIns.E_Meter_Register_1_ID__c = respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].id;
                                    if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_1_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_1_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                }
                                if (respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].MeterMemoryLocation != null)
                                    apptIns.Meter_Memory_Location__c = respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[0].MeterMemoryLocation;
                                if (respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 1) {
                                    apptIns.E_Meter_Register_2_ID__c = respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[1].id;
                                    if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[1].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[1].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_2_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_2_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                }
                                if (respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 2) {
                                    apptIns.E_Meter_Register_3_ID__c = respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[2].id;
                                    if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[2].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[2].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_3_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_3_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                }
                                if (respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 3) {
                                    apptIns.E_Meter_Register_4_ID__c = respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[3].id;
                                    if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[3].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[3].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_4_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_4_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                }
                                if (respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 4) {
                                    apptIns.E_Meter_Register_5_ID__c = respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[4].id;
                                    if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[4].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[4].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_5_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_5_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                }
                                if (respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister.size() > 5) {
                                    apptIns.E_Meter_Register_6_ID__c = respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[5].id;
                                    if (!EON_Utility.validateRequired(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[5].TimePatternRegimes)) {
                                        String[] timePatternRegimes = getTimePatternRegime(respMDS.Customer.Meters.elecmeter[0].Registers.ElecRegister[5].TimePatternRegimes);
                                        if (!EON_Utility.validateRequired(timePatternRegimes)) {
                                            if (!timePatternRegimes.isEmpty()) {
                                                if (!EON_Utility.validateRequired(timePatternRegimes[0]))
                                                    apptIns.Register_6_TPR_1__c = timePatternRegimes[0];
                                                if (timePatternRegimes.size() > 1)
                                                    apptIns.Register_6_TPR_2__c = timePatternRegimes[1];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        cTrack.Response_Data__c = string.ValueOf(respMDS); //populating response data 
                        
                        if((cTrack.Response_Data__c != null && cTrack.Response_Data__c.length() > 131070))
                             cTrack.Response_Data__c = cTrack.Response_Data__c.substring(0, 131070);   
                        
                        cTrack.Status__c = EON_Utility.RESULT_PASS;
                    }
                } else {
                    cTrack.Response_Data__c = string.ValueOf(respMDS); //populating response data
                    if((cTrack.Response_Data__c != null && cTrack.Response_Data__c.length() > 131070))
                         cTrack.Response_Data__c = cTrack.Response_Data__c.substring(0, 131070);                 
                    cTrack.Status__c = EON_Utility.RESULT_PASS;
                    for (String str: respMDS.Errors.Message)
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
    //#TODO: Need to replace EON_Jumbo_E_G_Meter_Types_Mappings__c?
    public static string PlannedMtrType(string mtrType) {
        return ((EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll() != null && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(mtrType.toUpperCase()) && EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(mtrType.toUpperCase()).Meter_Type__c == 'E') ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(mtrType.toUpperCase()).Planned_Meter_Type__c : null);
    }
    /** 
        string nPhases(string pHases): Method to return Number of Phases. 
    **/
    public static string nPhases(string pHases) {
        if (pHases == '3')
            return '3Ph';
        else
            return '1Ph';
    }
    /**
        getTimePatternRegime(): This function will add extra zero to TimePatternRegime received from MDS
    **/
    public static string[] getTimePatternRegime(EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime MDSTPR) {
        string[] allTPR = new string[] {};
        String addZero = '', tprCode = '';
        list < EON_MDS_Work_Management_WS.TimePatternRegime > listTPR = new list < EON_MDS_Work_Management_WS.TimePatternRegime > ();
        if (!EON_Utility.validateRequired(MDSTPR)) {
            if (!EON_Utility.validateRequired(MDSTPR.TimePatternRegime)) {
                listTPR.addAll(MDSTPR.TimePatternRegime);
                for (EON_MDS_Work_Management_WS.TimePatternRegime tpr: listTPR) {
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
}