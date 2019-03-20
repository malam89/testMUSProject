/**
    Description : This class is used to generate a WSDL for EON to send capacity information for 56 days.
    Test Class  : EON_Get_Capacity_From_Isis_WS_Test
**/
/*
    Created By : Praveen
    Created Date : 23-Feb-2016
    Service Request : SR_EON_AB_011
    Change History:
    CH01 # SR_EON_AB_022 # 13/04/2016 # Mahadev J # Amended logic to check validity while getting capacity
    CH02 # SR_EON_AB_101 # 18/04/2016 # Mahadev J # Amended logic to change in response parameter
    CH03 # 28/07/2016 # Nitin # Fixed Issue during Peer Testing.
    CH04 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
    CH05 # SR_EON_AB_126 # 25/08/2016 # Puneet Mehta # Changed the attributes that are to be sent
    CH06 # SR_EON_AB_138 # 08/09/2016 # Sivasankar K # populate the Planned E/G Meter Types = MS1 when the jobs are SMART and EON has not send the meter details.
    CH07 # SR_EON_AB_154 # 28/09/2016 # Puneet Mehta # Picklist value of Planned E Meter Type changed from 'Key' to 'KEY'
    CH08 # SR_EON_AB_155 # 03/10/2016 # Mahadev J # Logic update for considering 'Effective Dates' in case of dual fuel
    CH09 # SR_EON_AB_169 # 19/10/2016 # Puneet Mehta # IF we are not MAM AND the MPRN does not exist in an existing Fuel record then "REJECT - Morrison does not have access to Gas details to be able to accept this request"
    CH10 # SR_OptiMUS_EON_033 # 27/01/2017 # Mahadev J # Override Job Type with type - Maintenance
    CH11 # SR_OptiMUS_EON_071 # 08/06/2017 # Praveen G# add a filter for the capacity for the job code OOAEINSTALLBIND
    CH12 # SR_OptiMUS_EON_148 # 30/10/2017 # Mehboob Alam # Added a filter condition If ‘Current Phase’ is (>) 'greater than' ‘Number of Phases’ we should use the ‘Current Phase’ value to calculate capacity returned from Oracle
    CH13 # SR_OptiMUS_EON_164 # 09/11/2017 # Praveen G # Passing post code value to Get Capacity call.
    CH14 # SR_OptiMUS_EON_209 # 07/02/2017 # Mehboob Alam# add a filter for the job code OOASMARTDFINST
    CH15 # SR_OptiMUS_EON_234 # 15/03/2018 # Praveen G # added today's for the getcapacity results.
	CH16 # SR_OptiMUS_EON_297 # 05/02/2019 # Tabish Almas # Added logic to get data from MDS or Jumbo based on MDS Jumbo Dataflow Switch
*/
global with sharing class EON_Get_Capacity_From_Isis_WS {
    public static list < errMessage > lstError = new list < errMessage > ();
    /**
        Description : Request Parameter 1 / Response Parameter 2
    **/
    global with sharing class Header {
        Webservice String OrgId;
        Webservice String RequestId;
        Webservice String RequestDateTime;
    }
    /**
        Description : Request Parameter 5
    **/
    global with sharing class JobType {
        Webservice String JobCode;
        Webservice String JobDesc;
        Webservice JobAttributes JobAttributes;
    }
    /**
        Description : Request Parameter 4
    **/
    global with sharing class JobAttributes {
        webservice JobAttribute[] JobAttribute;
    }
    /**
        Description : Request Parameter 3
    **/
    global with sharing class JobAttribute {
        Webservice String Name;
        Webservice String Value;
    }
    /**
        Description : Request Parameter 2
    **/
    global with sharing class MeterPoints {
        Webservice MeterPoint[] MeterPoint;
    }
    /**
        Description : Request Parameter 1
    **/
    global with sharing class MeterPoint {
        Webservice String MPxN;
        Webservice String FuelType;
    }
    /**
        Description : Main Request Parameter
    **/
    global with sharing class CapacityRequestDetail {
        Webservice Header Header;
        Webservice String BookingSystemName;
        Webservice String Postcode;
        Webservice String KeyCollectionRequiredFlag;
        webservice JobType JobType;
        Webservice MeterPoints MeterPoints;
    }
    /**
        Description : This object will hold capacity details
    **/
    global with sharing class Capacity {
        Webservice Date CapacityDate;
        Webservice String TimeSlot;
        Webservice integer Quota;
        Webservice integer AvailableQuota;
        Webservice String StartTime; //CH02.New
        Webservice String EndTime; //CH02.New
    }
    /**
        Description : Response Parameter 3
    **/
    global with sharing class Capacities {
        Webservice Capacity[] Capacity;
    }
    /**
        Description : Response Parameter 1
    **/
    global with sharing class Activity {
        Webservice integer Duration;
        Webservice integer TravelTime;
    }
    /**
        Description : This object will hold error message with details
    **/
    global with sharing class errMessage {
        Webservice String MessageType;
        Webservice integer MessageId;
        Webservice String MessageText;
    }
    /**
        Description : Response Paramter 4
    **/
    global with sharing class errMessageLst {
        Webservice list < errMessage > Message;
    }
    /**
        Description : Main Response Parameter
    **/
    global with sharing class CapacityResponseDetail {
        Webservice Activity Activity;
        Webservice Header Header;
        Webservice Capacities Capacities;
        Webservice errMessageLst Messages;
    }
    /**
        GetCapacityResponse GetCapacity(GetCapacity GetCapacity) - This method will validate the request and fetch appropriate information from JUMBO and OFSC and bundle the response.
    **/
    webservice static CapacityResponseDetail GetCapacity(CapacityRequestDetail CapacityRequestDetail) {
        Integer duration = 0;
        string Response_Status = EON_Utility.RESULT_PASS;
        string Resp_Message = '', OracleBucketID = '';
        String workSkill = '', eMeterType = '', ePhase = '', gMeterType = '', gPressure = '';
        EON_Job__c eonJob = new EON_Job__c();
        EON_Appointment__c app = new EON_Appointment__c();
        Map < String, String > elecPhaseGasPressure = new Map < String, String > ();
        CapacityResponseDetail response = new CapacityResponseDetail();
        list < EON_OFSC_Helper.RecomendedTimeSlots > ofscCapacity = new list < EON_OFSC_Helper.RecomendedTimeSlots > ();
        EON_Get_Capacity_From_Isis_WS.Header head = new EON_Get_Capacity_From_Isis_WS.Header();
        EON_Get_Capacity_From_Isis_WS.Activity act = new EON_Get_Capacity_From_Isis_WS.Activity();
        EON_Get_Capacity_From_Isis_WS.Capacity[] lstCapacity = new list < EON_Get_Capacity_From_Isis_WS.Capacity > ();
        list < EON_Get_Capacity_From_Isis_WS.errMessage > msgLst = new list < EON_Get_Capacity_From_Isis_WS.errMessage > ();
        errMessageLst errorlst = new errMessageLst();
        EON_Data_Tracker__c eonTracker = new EON_Data_Tracker__c(); //Parent Data Tracker
        eonTracker.Direction__c = EON_Utility.DIRECTION_IN;
        eonTracker.Command__c = EON_Utility.CMD_EON_GetCapacity;
        eonTracker.Status__c = EON_Utility.RESULT_PASS;
        list < JUMBO_Data_Tracker__c > jumboTrackers = new list < JUMBO_Data_Tracker__c > (); //Jumbo Data Tracker - J.18, J.19, J.20, J.21
        list < Oracle_Data_Tracker__c > oracleTrackers = new list < Oracle_Data_Tracker__c > (); //Oracle Data Tracker - F.25
        list < MDS_Data_Tracker__c > MDSTrackers = new list < MDS_Data_Tracker__c > (); //MDS Data Tracker - J.18, J.19, J.20, J.21		//CH16
        String switchData = EON_MDS_Utility.getMDS_Jumbo_Status();	//CH16
        try {
            //CH16.Start
            if(switchData == system.label.Jumbo_Shortform) {
                if (EON_Get_Capacity_From_Isis_WS_Test.genException == null)
                	EON_Get_Capacity_From_Isis_WS_Test.genException = false;
                //Generate exception
                if (EON_Get_Capacity_From_Isis_WS_Test.genException)
                    ID test = ID.valueOf('test');
                //CH01.New.Start
                if (!EON_Utility.validateRequired(CapacityRequestDetail)) {
                    String mPAN = null, mPRN = null;
                    String jobCode = '';
                    String postCode = '';
                    list < EON_Job__c > lstEonJob = new list < EON_Job__c > ();
                    list < EON_Job_Attribute__c > lstEONJobAttaributes = new list < EON_Job_Attribute__c > ();
                    list < string > lstJobName = new list < string > ();
                    //Get All Job Code
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.JobType.JobCode)) {
                        jobCode = CapacityRequestDetail.JobType.JobCode;
                        lstEonJob = [Select ID, Name, Duration__c, Description__c, Job_Type__c, MAM_Reqd__c, MOP_Reqd__c, MPAN_Reqd__c, MPRN_Reqd__c, ICE_Maintenance_Over_ride__c from EON_Job__c where name = : CapacityRequestDetail.JobType.JobCode and Inactive__c = false]; //CH10.Update
                        EON_OFSC_Helper.overrideJobType = !lstEonJob.isEmpty() ? lstEonJob[0].ICE_Maintenance_Over_ride__c : false; //CH10.New
                    }
                    //Get Post Code
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.PostCode))
                        postCode = CapacityRequestDetail.PostCode;
                        
                    //CH13.Start
                    if(postCode != null && postCode != ''){
                        String[] strPostCode = postCode.split(' ');
                        EON_OFSC_Helper.oraclePostCodeSector = strPostCode[0] + ' ' +strPostCode[1].left(1);
                    }
                    //CH13.End                    
                        
                    System.debug('Attribuytes ' + CapacityRequestDetail.JobType);
                    System.debug('Attribuytes ' + CapacityRequestDetail.JobType.JobAttributes);
                    System.debug('Attribuytes ' + CapacityRequestDetail.JobType.JobAttributes.JobAttribute);
                    //Get EON Job Attributes
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.JobType.JobAttributes.JobAttribute)) {
                        for (JobAttribute jobAttr: CapacityRequestDetail.JobType.JobAttributes.JobAttribute) {
                            System.debug('jobAttr= ' + jobAttr);
                            lstJobName.add(jobAttr.Name);
                            EON_Job_Attribute__c jobAttribute = new EON_Job_Attribute__c();
                            if (!EON_Utility.validateRequired(jobAttr.Name))
                                jobAttribute.Name = jobAttr.Name;
                            if (!EON_Utility.validateRequired(jobAttr.Name))
                                jobAttribute.Value__c = jobAttr.Value;
                            lstEONJobAttaributes.add(jobAttribute);
                            //CH05
                            if (jobAttr.Name == 'ELECMETERTYPE' && jobAttr.Value != null) {
                                eMeterType = jobAttr.Value;
                            }
                            if (jobAttr.Name == 'GASMETERTYPE' && jobAttr.Value != null) {
                                gMeterType = jobAttr.Value;
                            }
                            if (jobAttr.Name == 'PHASE' && jobAttr.Value != null) {
                                ePhase = jobAttr.Value;
                            }
                            if (jobAttr.Name == 'PRESSURE' && jobAttr.Value != null) {
                                gPressure = jobAttr.Value;
                            }
                            
                            //CH15.Start
                            if (jobAttr.Name == 'APPTREASON' && jobAttr.Value == 'NEW_CONN') {
                                EON_OFSC_Helper.EONAppReason = 'NEW_CONN';
                            }
                            
                            //CH15.End
                            
                            //CH05
                            System.debug('2eMeterType = ' + eMeterType + ' , gMeterType=' + gMeterType + ', ePhase = ' + ePhase + ', gPressure = ' + gPressure);
                        }
                    }
                    //Get MPAN and MPRN
                    list < EON_Get_Capacity_From_Isis_WS.MeterPoint > meters = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.MeterPoints)) {
                        if (!EON_Utility.validateRequired(CapacityRequestDetail.MeterPoints.MeterPoint)) {
                            meters = CapacityRequestDetail.MeterPoints.MeterPoint;
                            if (meters.size() > 0) {
                                for (EON_Get_Capacity_From_Isis_WS.MeterPoint mp: meters) {
                                    if (mp.FuelType == 'E')
                                        mPAN = mp.MPxN; //Get MPRN - CheckValidityForOFSC - Parameter - 3
                                    if (mp.FuelType == 'G')
                                        mPRN = mp.MPxN; //Get MPRN - CheckValidityForOFSC - Parameter - 4
                                }
                            }
                        }
                    }
                    //Get Header
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.Header)) {
                        head.OrgId = System.Label.EON_Sanbox_Name;
                        if (!EON_Utility.validateRequired(CapacityRequestDetail.Header.RequestDateTime))
                            head.RequestDateTime = CapacityRequestDetail.Header.RequestDateTime;
                        if (!EON_Utility.validateRequired(CapacityRequestDetail.Header.RequestId))
                            head.RequestId = CapacityRequestDetail.Header.RequestId;
                        response.header = head;
                    }
                    //Calculate duration
                    if (!EON_Utility.validateRequired(lstEonJob))
                        if (!lstEonJob.isEmpty())
                            if (!EON_Utility.validateRequired(lstEonJob[0].Duration__c))
                                duration = Integer.valueOf(lstEonJob[0].Duration__c);
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.KeyCollectionRequiredFlag)) {
                        string keyFlag = CapacityRequestDetail.KeyCollectionRequiredFlag;
                        if (keyFlag.equalsIgnoreCase('y'))
                            duration = duration + 15;
                    }
                    act.Duration = duration;
                    //Call CheckValidityForOFSC
                    OracleBucketID = EON_OFSC_Helper.checkValidityForOFSC(jobCode, lstEONJobAttaributes, mPAN, mPRN, postCode);
                    System.debug('OracleBucketID = ' + OracleBucketID);
                    if (!EON_Utility.validateRequired(EON_OFSC_Helper.jumboDataTrackers))
                        jumboTrackers.addAll(EON_OFSC_Helper.jumboDataTrackers);
                    //PULL Data from Jumbo for MPAN and MPRN
                    if (OracleBucketID.contains('REJECTED') == false && OracleBucketID != '') {
                        System.debug('eMeterType = ' + eMeterType + ' , gMeterType=' + gMeterType + ', ePhase = ' + ePhase + ', gPressure = ' + gPressure);
                        if (!EON_Utility.validateRequired(EON_OFSC_Helper.eonAppointment))
                            app = EON_OFSC_Helper.eonAppointment;
                        //Calculate Travel Time
                        Id eonRegion = [Select Id, Region_Name__c from EON_Sub_Area__c where Oracle_Bucket_ID__c = : OracleBucketID limit 1].Region_Name__c;
                        if (!EON_Utility.validateRequired(eonRegion)) {
                            Decimal subareaTravelTime = [Select Id, Travel_Time__c from EON_Region__c where ID = : eonRegion limit 1].Travel_Time__c;
                            if (!EON_Utility.validateRequired(subareaTravelTime))
                                act.TravelTime = Integer.valueOf(subareaTravelTime);
                        }
                        if (!lstEonJob.isEmpty()) {
                            eonJob = lstEonJob[0];
                            if (eonJob.MPAN_Reqd__c) {
                                if (mPAN != null && mPAN != '') {
                                    EON_Jumbo_ReqElecMeterPointData.AccessElecMeterPointData(mPAN, app, '', ''); //Call for Jumbo to get MPAN details - J.18
                                    if (!EON_Utility.validateRequired(EON_Jumbo_ReqElecMeterPointData.apptIns))	
                                        app = EON_Jumbo_ReqElecMeterPointData.apptIns;
                                    //CH06 added condition to check the job is SMART or not if SMART job and EON has not sent the Meter inormation then it should be MS1
                                    eMeterType = ((String.isNotBlank(eMeterType)) ? (eMeterType.equalsIgnoreCase('1') ? 'KEY' : eMeterType.equalsIgnoreCase('2') ? 'MS1' : eMeterType.equalsIgnoreCase('3') ? 'MCL' : eMeterType) : (eonJob.Name.containsIgnoreCase('SMART') ? 'MS1' : (!EON_Utility.validateRequired(app.Planned_E_Meter_Type__c)) ? app.Planned_E_Meter_Type__c : '')); //CH07
                                    if (String.isNotBlank(eMeterType))
                                        elecPhaseGasPressure.put('XA_ELEC_METER_TYPE', eMeterType);
                                    app.Planned_E_Meter_Type__c = eMeterType; //CH05
                                    app.MPAN__c = mpan; //CH06
                                    ePhase = ((String.isNotBlank(ePhase) && !ePhase.containsIgnoreCase('UNCHANGE')) ? (ePhase.equalsIgnoreCase('1ph') ? '1Ph' : ePhase.equalsIgnoreCase('3ph') ? '3Ph' : ePhase) : ((!EON_Utility.validateRequired(app.Number_of_Phases__c)) ? app.Number_of_Phases__c : ''));
                                    if(mpan != null && mpan != '' && (ePhase == null || ePhase == ''))//CH31
                                        ePhase = '1Ph';
                                    app.Number_of_Phases__c = ePhase; //CH05
                                    //CH12.Start
                                    if(ePhase=='1Ph')
                                       if(!EON_Utility.validateRequired(app.Current_Phase__c))
                                          if(app.Current_Phase__c=='3Ph')
                                               ePhase ='3Ph';
                                    //CH12.End
                                    if (String.isNotBlank(ePhase))
                                        elecPhaseGasPressure.put('XA_PHASE', ePhase.toUpperCase());
                                    //CH05.NEW
                                    if (!EON_Utility.validateRequired(EON_Jumbo_ReqElecMeterPointData.cTrack))
                                        jumboTrackers.add(EON_Jumbo_ReqElecMeterPointData.cTrack);
                                }
                            }
                            if (eonJob.MPRN_Reqd__c && jobCode != 'OOASMARTDFINST'){ //CH14
                                if (mPRN != null && mPRN != '') {
                                    list < EON_Fuel__c > fuel = new list < EON_Fuel__c > ([Select ID, Gas_Meter_Mechanism__c, Gas_Meter_Mechanism__r.Code__c from EON_Fuel__c where MPRN__c = : mprn limit 1]);
                                    //Calling J21 for MAM check//CH05.start
                                    EON_Jumbo_ReqGasMAM.MAMValidationResponse wrpp = new EON_Jumbo_ReqGasMAM.MAMValidationResponse();
                                    wrpp = EON_Jumbo_ReqGasMAM.ValidateMPRNMAM(MPRN);
                                    System.debug('wrpp = ' + wrpp);
                                    //CH09.START: IF we are not MAM AND the MPRN does not exist in an existing Fuel record
                                    if (!eonJob.MAM_Reqd__c && wrpp.isError && (fuel == null || fuel.isEmpty())) {
                                        Resp_Message = 'REJECT - Morrison does not have access to Gas details to be able to accept this request';
                                        generateErrorList('Exception',0,Resp_Message);
                                        eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                                        eonTracker.Error__c = Resp_Message;
                                    }
                                    //CH09.END
                                    else { //CH09
                                        EON_Jumbo_ReqGasMeterPointData.AccessGasMeterPointData(mPRN, app, '', ''); //Call for Jumbo to get MPRN details - J.19 
                                        if (!EON_Utility.validateRequired(EON_Jumbo_ReqGasMeterPointData.apptIns))
                                            app = EON_Jumbo_ReqGasMeterPointData.apptIns;
                                        //CH05.NEW
                                        if (!EON_Utility.validateRequired(EON_Jumbo_ReqGasMeterPointData.cTrack))
                                            jumboTrackers.add(EON_Jumbo_ReqGasMeterPointData.cTrack);
                                        //CH05
                                        //CH06.start
                                        if (String.isBlank(gMeterType) && eonJob.Name.containsIgnoreCase('SMART')){
                                            gMeterType = 'MS1';
                                            elecPhaseGasPressure.put('XA_GAS_METER_TYPE', gMeterType);
                                            app.Planned_G_Meter_Type__c = gMeterType;
                                            //GAS METERING PRESSURE CALCULATION
                                            gPressure = ((wrpp.isError || (String.isNotBlank(wrpp.Error) && wrpp.Error.containsIgnoreCase('No Related supplier'))) ? 'Low' : (!EON_Utility.validateRequired(app.Metering_Pressure__c)) ? app.Metering_Pressure__c : '');
                                            if(mprn != null && mprn != '' && (gPressure == null || gPressure == ''))
                                                gPressure = 'Low';
                                            elecPhaseGasPressure.put('XA_PRESSURE', gPressure);
                                            app.Metering_Pressure__c = gPressure;
                                            app.MPRN__c = mprn;
                                        } else if (!wrpp.isError) { //CH06.end :IF we are not MAM
                                            app.G_Effective_From_Date__c = wrpp.effFromDate;
                                            app.G_Effective_To_Date__c = wrpp.effToDate;
                                            System.debug('app =' + app);
                                            System.debug('app.Planned_G_Meter_Type__c = ' + app.Planned_G_Meter_Type__c + ' , app.Metering_Pressure__c=' + app.Metering_Pressure__c + ', app.Planned_E_Meter_Type__c = ' + app.Planned_E_Meter_Type__c + ', app.Number_of_Phases__c = ' + app.Number_of_Phases__c);
                                            //CH06 added condition to check the job is SMART or not if SMART job and EON has not sent the Meter inormation then it should be MS1
                                            gMeterType = ((String.isNotBlank(gMeterType)) ? (gMeterType.equalsIgnoreCase('1') ? 'MCL' : gMeterType.equalsIgnoreCase('2') ? 'MS1' : gMeterType.equalsIgnoreCase('3') ? 'PP' : gMeterType) : (eonJob.Name.containsIgnoreCase('SMART') ? 'MS1' : (!EON_Utility.validateRequired(app.Planned_G_Meter_Type__c)) ? app.Planned_G_Meter_Type__c : ''));
                                            elecPhaseGasPressure.put('XA_GAS_METER_TYPE', gMeterType);
                                            app.Planned_G_Meter_Type__c = gMeterType; //CH05
                                            app.MPRN__c = mprn;
                                            //GAS METERING PRESSURE CALCULATION
                                            gPressure = ((String.isNotBlank(gPressure)) ? (gPressure.equalsIgnoreCase('1') ? 'low' : gPressure.equalsIgnoreCase('2') ? 'med' : gPressure) : (!EON_Utility.validateRequired(app.Metering_Pressure__c)) ? app.Metering_Pressure__c : '');
                                            if(mprn != null && mprn != '' && (gPressure == null || gPressure == ''))
                                                gPressure = 'Low';
                                            elecPhaseGasPressure.put('XA_PRESSURE', gPressure);
                                            app.Metering_Pressure__c = gPressure; //CH05
                                        } else if (fuel.size() > 0 && !EON_Utility.validateRequired(fuel[0].Gas_Meter_Mechanism__c) && !EON_Utility.validateRequired(fuel[0].Gas_Meter_Mechanism__r.Code__c)) {
                                            //CH06 added condition to check the job is SMART or not if SMART job and EON has not sent the Meter inormation then it should be MS1
                                            gMeterType = ((String.isNotBlank(gMeterType)) ? gMeterType : (eonJob.Name.containsIgnoreCase('SMART') ? 'MS1' : ((EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll() != null && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(fuel[0].Gas_Meter_Mechanism__r.Code__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(fuel[0].Gas_Meter_Mechanism__r.Code__c.toUpperCase()).Planned_Meter_Type__c : fuel[0].Gas_Meter_Mechanism__r.Code__c)));
                                            elecPhaseGasPressure.put('XA_GAS_METER_TYPE', gMeterType);
                                            app.Planned_G_Meter_Type__c = gMeterType;
                                            app.Metering_Pressure__c = 'Low'; //CH05
                                            gPressure = app.Metering_Pressure__c;
                                            app.MPRN__c = mprn;
                                            elecPhaseGasPressure.put('XA_PRESSURE', gPressure);
                                        } else {
                                            Resp_Message = 'REJECTED – Morrison have not been provided sufficient Gas Meter details to perform this request';
                                            generateErrorList('Exception',0,Resp_Message);
                                            eonTracker.Error__c = Resp_Message;
                                        }
                                    } //CH09
                                    if (!EON_Utility.validateRequired(EON_Jumbo_ReqGasMAM.cTrack))
                                        jumboTrackers.add(EON_Jumbo_ReqGasMAM.cTrack);
                                    //CH05
                                }
                            }
                            System.debug('1eMeterType = ' + eMeterType + ' , gMeterType=' + gMeterType + ', ePhase = ' + ePhase + ', gPressure = ' + gPressure);
                        }
                        if (Resp_Message != 'REJECT - Morrison does not have access to Gas details to be able to accept this request') {//CH09
                            System.debug('app.Planned_G_Meter_Type__c = ' + app.Planned_G_Meter_Type__c + ' , app.Metering_Pressure__c=' + app.Metering_Pressure__c + ', app.Planned_E_Meter_Type__c = ' + app.Planned_E_Meter_Type__c + ', app.Number_of_Phases__c = ' + app.Number_of_Phases__c);
                            System.debug('app.elecPhaseGasPressure = ' + elecPhaseGasPressure);
                            //Get workskill
                            workSkill = EON_OFSC_Helper.getWorkSkill(app);
                            system.debug('###CalWorkSkill: ' + workSkill);
                            if (workSkill != 'Invalid WorkSkill') {
                                Date effFromDate, effToDate;
                                map < String, Date > ToAndFromDate = new map < String, Date > ();
                                //CH08.New.Start
                                if (!EON_Utility.validateRequired(app.Effective_From_Date__c)) {
                                    effFromDate = app.Effective_From_Date__c > Date.today() ? app.Effective_From_Date__c : Date.today();
                                    if (!EON_Utility.validateRequired(app.G_Effective_From_Date__c))
                                        effFromDate = app.Effective_From_Date__c > app.G_Effective_From_Date__c ? app.Effective_From_Date__c : app.G_Effective_From_Date__c;
                                    if (effFromDate < Date.today()){effFromDate = Date.today();}
                                }
                                if (!EON_Utility.validateRequired(app.Effective_To_Date__c)) {
                                    effToDate = app.Effective_To_Date__c < Date.today() + 56 ? app.Effective_To_Date__c : Date.today() + 56;
                                    if (!EON_Utility.validateRequired(app.G_Effective_To_Date__c))
                                        effToDate = app.Effective_To_Date__c < app.G_Effective_To_Date__c ? app.Effective_To_Date__c : app.G_Effective_To_Date__c;
                                    if (effToDate > Date.today() + 56){effToDate = Date.today() + 56;}
                                }
                                if (!EON_Utility.validateRequired(effFromDate))
                                    ToAndFromDate.put('eff_From_Date', effFromDate > Date.today() ? effFromDate : Date.today());
                                else
                                    ToAndFromDate.put('eff_From_Date', Date.today());
                                if (!EON_Utility.validateRequired(effToDate))
                                    ToAndFromDate.put('eff_To_Date', effToDate <= Date.today() + 56 && effToDate > Date.today() ? effToDate : Date.today() + 56);
                                else
                                    ToAndFromDate.put('eff_To_Date', Date.today() + 56);
                                //CH08.New.End
                                system.debug('######OracleBucketID: ' + OracleBucketID);
                                system.debug('######duration: ' + duration);
                                system.debug('######elecPhaseGasPressure: ' + elecPhaseGasPressure);
                                system.debug('######lstEONJobAttaributes: ' + lstEONJobAttaributes + '##Size: ' + lstEONJobAttaributes.size());
                                system.debug('######workSkill: ' + workSkill);
                                system.debug('######ToAndFromDate: ' + ToAndFromDate);
                                
                                EON_OFSC_Helper.jobcodeOOAEINSTALLBIND = jobCode; //CH11
                                
                                ofscCapacity = EON_OFSC_Helper.getCapacityFromOFSC(OracleBucketID, duration, elecPhaseGasPressure, lstEONJobAttaributes, workSkill, ToAndFromDate);
                                if (EON_OFSC_Helper.OracleDataTrackers != null)
                                    oracleTrackers.addAll(EON_OFSC_Helper.OracleDataTrackers);
                                if (ofscCapacity != null) {
                                    if (ofscCapacity.size() > 0) {
                                        for (EON_OFSC_Helper.RecomendedTimeSlots capacity: ofscCapacity) {
                                            EON_Get_Capacity_From_Isis_WS.Capacity cap = new EON_Get_Capacity_From_Isis_WS.capacity();
                                            cap.CapacityDate = capacity.dt;
                                            cap.TimeSlot = capacity.timeSlots;
                                            cap.Quota = integer.valueof(capacity.quota);
                                            cap.AvailableQuota = integer.valueof(capacity.availability);
                                            //CH02.New.Start
                                            String slot = capacity.timeSlots;
                                            String[] slots = slot.split(' - ');
                                            String startTime = slots[0];
                                            startTime = startTime.replace(':', '');
                                            startTime = startTime + '00';
                                            cap.StartTime = startTime;
                                            String endTime = slots[1];
                                            endTime = endTime.replace(':', '');
                                            endTime = endTime + '00';
                                            cap.endTime = endTime;
                                            //CH02.New.End
                                            lstCapacity.add(cap);
                                        }
                                        EON_Get_Capacity_From_Isis_WS.Capacities caps = new EON_Get_Capacity_From_Isis_WS.Capacities();
                                        caps.capacity = lstCapacity;
                                        response.Capacities = caps;
                                        generateErrorList('Information',0,'Request processed Successfully.');
                                    } else {
                                        generateErrorList('Exception',0,'No capacities available at OFSC'); eonTracker.Error__c = 'No capacities available at OFSC';
                                    }
                                }
                                response.Activity = act;
                            } else {
                                generateErrorList('Exception',0,(workSkill != '' && workSkill.containsIgnoreCase('Invalid WorkSkill') ? 'Meter information could not be retrieved, please contact MUS back office.' : workSkill));
                            }
                        }//CH09
                    } else {
                        Response_Status = EON_Utility.RESULT_FAIL;
                        if (OracleBucketID == ''){Resp_Message = 'Some error occured. Please contact system admin.';}
                        else{Resp_Message = OracleBucketID;}
                        generateErrorList('Exception',0,Resp_Message);
                        eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                        eonTracker.Error__c = Resp_Message;
                    }
                } else {
                    Response_Status = EON_Utility.RESULT_FAIL;
                    Resp_Message = 'Blank request cannot be processed';
                    generateErrorList('Exception',0,Resp_Message);
                    eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                    eonTracker.Error__c = Resp_Message;
                }
                //CH01.New.End
                if (!EON_Utility.validateRequired(CapacityRequestDetail)) {
                    eonTracker.Request_Data__c = EON_Utility.validateStringLength(CapacityRequestDetail + '');
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.header)) {
                        if (!EON_Utility.validateRequired(CapacityRequestDetail.header))
                            eonTracker.Transaction_ID__c = CapacityRequestDetail.header.requestId;
                    }
                }
                errMessageLst emList = new errMessageLst();
                emList.Message = lstError;
                response.Messages = emList;
                eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
            }
            else if(switchData == system.label.MDS_Shortform) {
                if (EON_Get_Capacity_From_Isis_WS_Test.genException == null)
                	EON_Get_Capacity_From_Isis_WS_Test.genException = false;
                //Generate exception
                if (EON_Get_Capacity_From_Isis_WS_Test.genException)
                    ID test = ID.valueOf('test');
                //CH01.New.Start
                if (!EON_Utility.validateRequired(CapacityRequestDetail)) {
                    String mPAN = null, mPRN = null;
                    String jobCode = '';
                    String postCode = '';
                    list < EON_Job__c > lstEonJob = new list < EON_Job__c > ();
                    list < EON_Job_Attribute__c > lstEONJobAttaributes = new list < EON_Job_Attribute__c > ();
                    list < string > lstJobName = new list < string > ();
                    //Get All Job Code
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.JobType.JobCode)) {
                        jobCode = CapacityRequestDetail.JobType.JobCode;
                        lstEonJob = [Select ID, Name, Duration__c, Description__c, Job_Type__c, MAM_Reqd__c, MOP_Reqd__c, MPAN_Reqd__c, MPRN_Reqd__c, ICE_Maintenance_Over_ride__c from EON_Job__c where name = : CapacityRequestDetail.JobType.JobCode and Inactive__c = false]; //CH10.Update
                        EON_OFSC_Helper.overrideJobType = !lstEonJob.isEmpty() ? lstEonJob[0].ICE_Maintenance_Over_ride__c : false; //CH10.New
                    }
                    //Get Post Code
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.PostCode))
                        postCode = CapacityRequestDetail.PostCode;
                        
                    //CH13.Start
                    if(postCode != null && postCode != ''){
                        String[] strPostCode = postCode.split(' ');
                        EON_OFSC_Helper.oraclePostCodeSector = strPostCode[0] + ' ' +strPostCode[1].left(1);
                    }
                    //CH13.End                    
                        
                    System.debug('Attribuytes ' + CapacityRequestDetail.JobType);
                    System.debug('Attribuytes ' + CapacityRequestDetail.JobType.JobAttributes);
                    System.debug('Attribuytes ' + CapacityRequestDetail.JobType.JobAttributes.JobAttribute);
                    //Get EON Job Attributes
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.JobType.JobAttributes.JobAttribute)) {
                        for (JobAttribute jobAttr: CapacityRequestDetail.JobType.JobAttributes.JobAttribute) {
                            System.debug('jobAttr= ' + jobAttr);
                            lstJobName.add(jobAttr.Name);
                            EON_Job_Attribute__c jobAttribute = new EON_Job_Attribute__c();
                            if (!EON_Utility.validateRequired(jobAttr.Name))
                                jobAttribute.Name = jobAttr.Name;
                            if (!EON_Utility.validateRequired(jobAttr.Name))
                                jobAttribute.Value__c = jobAttr.Value;
                            lstEONJobAttaributes.add(jobAttribute);
                            //CH05
                            if (jobAttr.Name == 'ELECMETERTYPE' && jobAttr.Value != null) {
                                eMeterType = jobAttr.Value;
                            }
                            if (jobAttr.Name == 'GASMETERTYPE' && jobAttr.Value != null) {
                                gMeterType = jobAttr.Value;
                            }
                            if (jobAttr.Name == 'PHASE' && jobAttr.Value != null) {
                                ePhase = jobAttr.Value;
                            }
                            if (jobAttr.Name == 'PRESSURE' && jobAttr.Value != null) {
                                gPressure = jobAttr.Value;
                            }
                            
                            //CH15.Start
                            if (jobAttr.Name == 'APPTREASON' && jobAttr.Value == 'NEW_CONN') {
                                EON_OFSC_Helper.EONAppReason = 'NEW_CONN';
                            }
                            
                            //CH15.End
                            
                            //CH05
                            System.debug('2eMeterType = ' + eMeterType + ' , gMeterType=' + gMeterType + ', ePhase = ' + ePhase + ', gPressure = ' + gPressure);
                        }
                    }
                    //Get MPAN and MPRN
                    list < EON_Get_Capacity_From_Isis_WS.MeterPoint > meters = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.MeterPoints)) {
                        if (!EON_Utility.validateRequired(CapacityRequestDetail.MeterPoints.MeterPoint)) {
                            meters = CapacityRequestDetail.MeterPoints.MeterPoint;
                            if (meters.size() > 0) {
                                for (EON_Get_Capacity_From_Isis_WS.MeterPoint mp: meters) {
                                    if (mp.FuelType == 'E')
                                        mPAN = mp.MPxN; //Get MPRN - CheckValidityForOFSC - Parameter - 3
                                    if (mp.FuelType == 'G')
                                        mPRN = mp.MPxN; //Get MPRN - CheckValidityForOFSC - Parameter - 4
                                }
                            }
                        }
                    }
                    //Get Header
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.Header)) {
                        head.OrgId = System.Label.EON_Sanbox_Name;
                        if (!EON_Utility.validateRequired(CapacityRequestDetail.Header.RequestDateTime))
                            head.RequestDateTime = CapacityRequestDetail.Header.RequestDateTime;
                        if (!EON_Utility.validateRequired(CapacityRequestDetail.Header.RequestId))
                            head.RequestId = CapacityRequestDetail.Header.RequestId;
                        response.header = head;
                    }
                    //Calculate duration
                    if (!EON_Utility.validateRequired(lstEonJob))
                        if (!lstEonJob.isEmpty())
                            if (!EON_Utility.validateRequired(lstEonJob[0].Duration__c))
                                duration = Integer.valueOf(lstEonJob[0].Duration__c);
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.KeyCollectionRequiredFlag)) {
                        string keyFlag = CapacityRequestDetail.KeyCollectionRequiredFlag;
                        if (keyFlag.equalsIgnoreCase('y'))
                            duration = duration + 15;
                    }
                    act.Duration = duration;
                    //Call CheckValidityForOFSC
                    OracleBucketID = EON_OFSC_Helper.checkValidityForOFSC(jobCode, lstEONJobAttaributes, mPAN, mPRN, postCode);
                    System.debug('OracleBucketID = ' + OracleBucketID);
                    if (!EON_Utility.validateRequired(EON_OFSC_Helper.MDSDataTrackers))
                        MDSTrackers.addAll(EON_OFSC_Helper.MDSDataTrackers);
                    //PULL Data from MDS for MPAN and MPRN
                    if (OracleBucketID.contains('REJECTED') == false && OracleBucketID != '') {
                        System.debug('eMeterType = ' + eMeterType + ' , gMeterType=' + gMeterType + ', ePhase = ' + ePhase + ', gPressure = ' + gPressure);
                        if (!EON_Utility.validateRequired(EON_OFSC_Helper.eonAppointment))
                            app = EON_OFSC_Helper.eonAppointment;
                        //Calculate Travel Time
                        Id eonRegion = [Select Id, Region_Name__c from EON_Sub_Area__c where Oracle_Bucket_ID__c = : OracleBucketID limit 1].Region_Name__c;
                        if (!EON_Utility.validateRequired(eonRegion)) {
                            Decimal subareaTravelTime = [Select Id, Travel_Time__c from EON_Region__c where ID = : eonRegion limit 1].Travel_Time__c;
                            if (!EON_Utility.validateRequired(subareaTravelTime))
                                act.TravelTime = Integer.valueOf(subareaTravelTime);
                        }
                        if (!lstEonJob.isEmpty()) {
                            eonJob = lstEonJob[0];
                            if (eonJob.MPAN_Reqd__c) {
                                if (mPAN != null && mPAN != '') {
                                    EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(mPAN, app, '', ''); //Call for MDS to get MPAN details - J.18
                                    if (!EON_Utility.validateRequired(EON_MDS_ReqElecMeterPointData.apptIns))	
                                        app = EON_MDS_ReqElecMeterPointData.apptIns;
                                    //CH06 added condition to check the job is SMART or not if SMART job and EON has not sent the Meter inormation then it should be MS1
                                    eMeterType = ((String.isNotBlank(eMeterType)) ? (eMeterType.equalsIgnoreCase('1') ? 'KEY' : eMeterType.equalsIgnoreCase('2') ? 'MS1' : eMeterType.equalsIgnoreCase('3') ? 'MCL' : eMeterType) : (eonJob.Name.containsIgnoreCase('SMART') ? 'MS1' : (!EON_Utility.validateRequired(app.Planned_E_Meter_Type__c)) ? app.Planned_E_Meter_Type__c : '')); //CH07
                                    if (String.isNotBlank(eMeterType))
                                        elecPhaseGasPressure.put('XA_ELEC_METER_TYPE', eMeterType);
                                    app.Planned_E_Meter_Type__c = eMeterType; //CH05
                                    app.MPAN__c = mpan; //CH06
                                    ePhase = ((String.isNotBlank(ePhase) && !ePhase.containsIgnoreCase('UNCHANGE')) ? (ePhase.equalsIgnoreCase('1ph') ? '1Ph' : ePhase.equalsIgnoreCase('3ph') ? '3Ph' : ePhase) : ((!EON_Utility.validateRequired(app.Number_of_Phases__c)) ? app.Number_of_Phases__c : ''));
                                    if(mpan != null && mpan != '' && (ePhase == null || ePhase == ''))//CH31
                                        ePhase = '1Ph';
                                    app.Number_of_Phases__c = ePhase; //CH05
                                    //CH12.Start
                                    if(ePhase=='1Ph')
                                       if(!EON_Utility.validateRequired(app.Current_Phase__c))
                                          if(app.Current_Phase__c=='3Ph')
                                               ePhase ='3Ph';
                                    //CH12.End
                                    if (String.isNotBlank(ePhase))
                                        elecPhaseGasPressure.put('XA_PHASE', ePhase.toUpperCase());
                                    //CH05.NEW
                                    if (!EON_Utility.validateRequired(EON_MDS_ReqElecMeterPointData.cTrack))
                                        MDSTrackers.add(EON_MDS_ReqElecMeterPointData.cTrack);
                                }
                            }
                            if (eonJob.MPRN_Reqd__c && jobCode != 'OOASMARTDFINST'){ //CH14
                                if (mPRN != null && mPRN != '') {
                                    list < EON_Fuel__c > fuel = new list < EON_Fuel__c > ([Select ID, Gas_Meter_Mechanism__c, Gas_Meter_Mechanism__r.Code__c from EON_Fuel__c where MPRN__c = : mprn limit 1]);
                                    //Calling J21 for MAM check//CH05.start
                                    EON_MDS_ReqGasMAM.MAMValidationResponse wrpp = new EON_MDS_ReqGasMAM.MAMValidationResponse();
                                    wrpp = EON_MDS_ReqGasMAM.ValidateMPRNMAM(MPRN);
                                    System.debug('wrpp = ' + wrpp);
                                    //CH09.START: IF we are not MAM AND the MPRN does not exist in an existing Fuel record
                                    if (!eonJob.MAM_Reqd__c && wrpp.isError && (fuel == null || fuel.isEmpty())) {
                                        Resp_Message = 'REJECT - Morrison does not have access to Gas details to be able to accept this request';
                                        generateErrorList('Exception',0,Resp_Message);
                                        eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                                        eonTracker.Error__c = Resp_Message;
                                    }
                                    //CH09.END
                                    else { //CH09
                                        EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(mPRN, app, '', ''); //Call for MDS to get MPRN details - J.19 
                                        if (!EON_Utility.validateRequired(EON_MDS_ReqGasMeterPointData.apptIns))
                                            app = EON_MDS_ReqGasMeterPointData.apptIns;
                                        //CH05.NEW
                                        if (!EON_Utility.validateRequired(EON_MDS_ReqGasMeterPointData.cTrack))
                                            MDSTrackers.add(EON_MDS_ReqGasMeterPointData.cTrack);
                                        //CH05
                                        //CH06.start
                                        if (String.isBlank(gMeterType) && eonJob.Name.containsIgnoreCase('SMART')){
                                            gMeterType = 'MS1';
                                            elecPhaseGasPressure.put('XA_GAS_METER_TYPE', gMeterType);
                                            app.Planned_G_Meter_Type__c = gMeterType;
                                            //GAS METERING PRESSURE CALCULATION
                                            gPressure = ((wrpp.isError || (String.isNotBlank(wrpp.Error) && wrpp.Error.containsIgnoreCase('No Related supplier'))) ? 'Low' : (!EON_Utility.validateRequired(app.Metering_Pressure__c)) ? app.Metering_Pressure__c : '');
                                            if(mprn != null && mprn != '' && (gPressure == null || gPressure == ''))
                                                gPressure = 'Low';
                                            elecPhaseGasPressure.put('XA_PRESSURE', gPressure);
                                            app.Metering_Pressure__c = gPressure;
                                            app.MPRN__c = mprn;
                                        } else if (!wrpp.isError) { //CH06.end :IF we are not MAM
                                            app.G_Effective_From_Date__c = wrpp.effFromDate;
                                            app.G_Effective_To_Date__c = wrpp.effToDate;
                                            System.debug('app =' + app);
                                            System.debug('app.Planned_G_Meter_Type__c = ' + app.Planned_G_Meter_Type__c + ' , app.Metering_Pressure__c=' + app.Metering_Pressure__c + ', app.Planned_E_Meter_Type__c = ' + app.Planned_E_Meter_Type__c + ', app.Number_of_Phases__c = ' + app.Number_of_Phases__c);
                                            //CH06 added condition to check the job is SMART or not if SMART job and EON has not sent the Meter inormation then it should be MS1
                                            gMeterType = ((String.isNotBlank(gMeterType)) ? (gMeterType.equalsIgnoreCase('1') ? 'MCL' : gMeterType.equalsIgnoreCase('2') ? 'MS1' : gMeterType.equalsIgnoreCase('3') ? 'PP' : gMeterType) : (eonJob.Name.containsIgnoreCase('SMART') ? 'MS1' : (!EON_Utility.validateRequired(app.Planned_G_Meter_Type__c)) ? app.Planned_G_Meter_Type__c : ''));
                                            elecPhaseGasPressure.put('XA_GAS_METER_TYPE', gMeterType);
                                            app.Planned_G_Meter_Type__c = gMeterType; //CH05
                                            app.MPRN__c = mprn;
                                            //GAS METERING PRESSURE CALCULATION
                                            gPressure = ((String.isNotBlank(gPressure)) ? (gPressure.equalsIgnoreCase('1') ? 'low' : gPressure.equalsIgnoreCase('2') ? 'med' : gPressure) : (!EON_Utility.validateRequired(app.Metering_Pressure__c)) ? app.Metering_Pressure__c : '');
                                            if(mprn != null && mprn != '' && (gPressure == null || gPressure == ''))
                                                gPressure = 'Low';
                                            elecPhaseGasPressure.put('XA_PRESSURE', gPressure);
                                            app.Metering_Pressure__c = gPressure; //CH05
                                        } else if (fuel.size() > 0 && !EON_Utility.validateRequired(fuel[0].Gas_Meter_Mechanism__c) && !EON_Utility.validateRequired(fuel[0].Gas_Meter_Mechanism__r.Code__c)) {
                                            //CH06 added condition to check the job is SMART or not if SMART job and EON has not sent the Meter inormation then it should be MS1
                                            gMeterType = ((String.isNotBlank(gMeterType)) ? gMeterType : (eonJob.Name.containsIgnoreCase('SMART') ? 'MS1' : ((EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll() != null && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(fuel[0].Gas_Meter_Mechanism__r.Code__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(fuel[0].Gas_Meter_Mechanism__r.Code__c.toUpperCase()).Planned_Meter_Type__c : fuel[0].Gas_Meter_Mechanism__r.Code__c)));
                                            elecPhaseGasPressure.put('XA_GAS_METER_TYPE', gMeterType);
                                            app.Planned_G_Meter_Type__c = gMeterType;
                                            app.Metering_Pressure__c = 'Low'; //CH05
                                            gPressure = app.Metering_Pressure__c;
                                            app.MPRN__c = mprn;
                                            elecPhaseGasPressure.put('XA_PRESSURE', gPressure);
                                        } else {
                                            Resp_Message = 'REJECTED – Morrison have not been provided sufficient Gas Meter details to perform this request';
                                            generateErrorList('Exception',0,Resp_Message);
                                            eonTracker.Error__c = Resp_Message;
                                        }
                                    } //CH09
                                    if (!EON_Utility.validateRequired(EON_MDS_ReqGasMAM.cTrack))
                                        MDSTrackers.add(EON_MDS_ReqGasMAM.cTrack);
                                    //CH05
                                }
                            }
                            System.debug('1eMeterType = ' + eMeterType + ' , gMeterType=' + gMeterType + ', ePhase = ' + ePhase + ', gPressure = ' + gPressure);
                        }
                        if (Resp_Message != 'REJECT - Morrison does not have access to Gas details to be able to accept this request') {//CH09
                            System.debug('app.Planned_G_Meter_Type__c = ' + app.Planned_G_Meter_Type__c + ' , app.Metering_Pressure__c=' + app.Metering_Pressure__c + ', app.Planned_E_Meter_Type__c = ' + app.Planned_E_Meter_Type__c + ', app.Number_of_Phases__c = ' + app.Number_of_Phases__c);
                            System.debug('app.elecPhaseGasPressure = ' + elecPhaseGasPressure);
                            //Get workskill
                            workSkill = EON_OFSC_Helper.getWorkSkill(app);
                            system.debug('###CalWorkSkill: ' + workSkill);
                            if (workSkill != 'Invalid WorkSkill') {
                                Date effFromDate, effToDate;
                                map < String, Date > ToAndFromDate = new map < String, Date > ();
                                //CH08.New.Start
                                if (!EON_Utility.validateRequired(app.Effective_From_Date__c)) {
                                    effFromDate = app.Effective_From_Date__c > Date.today() ? app.Effective_From_Date__c : Date.today();
                                    if (!EON_Utility.validateRequired(app.G_Effective_From_Date__c))
                                        effFromDate = app.Effective_From_Date__c > app.G_Effective_From_Date__c ? app.Effective_From_Date__c : app.G_Effective_From_Date__c;
                                    if (effFromDate < Date.today()){effFromDate = Date.today();}
                                }
                                if (!EON_Utility.validateRequired(app.Effective_To_Date__c)) {
                                    effToDate = app.Effective_To_Date__c < Date.today() + 56 ? app.Effective_To_Date__c : Date.today() + 56;
                                    if (!EON_Utility.validateRequired(app.G_Effective_To_Date__c))
                                        effToDate = app.Effective_To_Date__c < app.G_Effective_To_Date__c ? app.Effective_To_Date__c : app.G_Effective_To_Date__c;
                                    if (effToDate > Date.today() + 56){effToDate = Date.today() + 56;}
                                }
                                if (!EON_Utility.validateRequired(effFromDate))
                                    ToAndFromDate.put('eff_From_Date', effFromDate > Date.today() ? effFromDate : Date.today());
                                else
                                    ToAndFromDate.put('eff_From_Date', Date.today());
                                if (!EON_Utility.validateRequired(effToDate))
                                    ToAndFromDate.put('eff_To_Date', effToDate <= Date.today() + 56 && effToDate > Date.today() ? effToDate : Date.today() + 56);
                                else
                                    ToAndFromDate.put('eff_To_Date', Date.today() + 56);
                                //CH08.New.End
                                system.debug('######OracleBucketID: ' + OracleBucketID);
                                system.debug('######duration: ' + duration);
                                system.debug('######elecPhaseGasPressure: ' + elecPhaseGasPressure);
                                system.debug('######lstEONJobAttaributes: ' + lstEONJobAttaributes + '##Size: ' + lstEONJobAttaributes.size());
                                system.debug('######workSkill: ' + workSkill);
                                system.debug('######ToAndFromDate: ' + ToAndFromDate);
                                
                                EON_OFSC_Helper.jobcodeOOAEINSTALLBIND = jobCode; //CH11
                                
                                ofscCapacity = EON_OFSC_Helper.getCapacityFromOFSC(OracleBucketID, duration, elecPhaseGasPressure, lstEONJobAttaributes, workSkill, ToAndFromDate);
                                if (EON_OFSC_Helper.OracleDataTrackers != null)
                                    oracleTrackers.addAll(EON_OFSC_Helper.OracleDataTrackers);
                                if (ofscCapacity != null) {
                                    if (ofscCapacity.size() > 0) {
                                        for (EON_OFSC_Helper.RecomendedTimeSlots capacity: ofscCapacity) {
                                            EON_Get_Capacity_From_Isis_WS.Capacity cap = new EON_Get_Capacity_From_Isis_WS.capacity();
                                            cap.CapacityDate = capacity.dt;
                                            cap.TimeSlot = capacity.timeSlots;
                                            cap.Quota = integer.valueof(capacity.quota);
                                            cap.AvailableQuota = integer.valueof(capacity.availability);
                                            //CH02.New.Start
                                            String slot = capacity.timeSlots;
                                            String[] slots = slot.split(' - ');
                                            String startTime = slots[0];
                                            startTime = startTime.replace(':', '');
                                            startTime = startTime + '00';
                                            cap.StartTime = startTime;
                                            String endTime = slots[1];
                                            endTime = endTime.replace(':', '');
                                            endTime = endTime + '00';
                                            cap.endTime = endTime;
                                            //CH02.New.End
                                            lstCapacity.add(cap);
                                        }
                                        EON_Get_Capacity_From_Isis_WS.Capacities caps = new EON_Get_Capacity_From_Isis_WS.Capacities();
                                        caps.capacity = lstCapacity;
                                        response.Capacities = caps;
                                        generateErrorList('Information',0,'Request processed Successfully.');
                                    } else {
                                        generateErrorList('Exception',0,'No capacities available at OFSC'); eonTracker.Error__c = 'No capacities available at OFSC';
                                    }
                                }
                                response.Activity = act;
                            } else {
                                generateErrorList('Exception',0,(workSkill != '' && workSkill.containsIgnoreCase('Invalid WorkSkill') ? 'Meter information could not be retrieved, please contact MUS back office.' : workSkill));
                            }
                        }//CH09
                    } else {
                        Response_Status = EON_Utility.RESULT_FAIL;
                        if (OracleBucketID == ''){Resp_Message = 'Some error occured. Please contact system admin.';}
                        else{Resp_Message = OracleBucketID;}
                        generateErrorList('Exception',0,Resp_Message);
                        eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                        eonTracker.Error__c = Resp_Message;
                    }
                } else {
                    Response_Status = EON_Utility.RESULT_FAIL;
                    Resp_Message = 'Blank request cannot be processed';
                    generateErrorList('Exception',0,Resp_Message);
                    eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                    eonTracker.Error__c = Resp_Message;
                }
                //CH01.New.End
                if (!EON_Utility.validateRequired(CapacityRequestDetail)) {
                    eonTracker.Request_Data__c = EON_Utility.validateStringLength(CapacityRequestDetail + '');
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.header)) {
                        if (!EON_Utility.validateRequired(CapacityRequestDetail.header))
                            eonTracker.Transaction_ID__c = CapacityRequestDetail.header.requestId;
                    }
                }
                errMessageLst emList = new errMessageLst();
                emList.Message = lstError;
                response.Messages = emList;
                eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
            }
            //CH16.End
        }
        catch (Exception ex) {
            system.debug('###Error1: ' + ex.getMessage());
            system.debug('###Error2: ' + ex.getStackTraceString());
            generateErrorList('Exception',0,ex.getMessage());
            eonTracker.Error__c = ex.getMessage();
            errMessageLst emList = new errMessageLst();
            emList.Message = lstError;
            response.header = head;
            //Get Header
            head = new EON_Get_Capacity_From_Isis_WS.Header();
            head.OrgId = System.Label.EON_Sanbox_Name;
            if (!EON_Utility.validateRequired(CapacityRequestDetail)) {
                if (!EON_Utility.validateRequired(CapacityRequestDetail.Header)) {
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.Header.RequestDateTime))
                        head.RequestDateTime = CapacityRequestDetail.Header.RequestDateTime;
                    if (!EON_Utility.validateRequired(CapacityRequestDetail.Header.RequestId))
                        head.RequestId = CapacityRequestDetail.Header.RequestId;
                }
            }
            response.Messages = emList;
            eonTracker.Status__c = EON_Utility.RESULT_FAIL;
            eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
        }
        //Save Tracker Transactions
        insert eonTracker;
        if (jumboTrackers.size() > 0) {
            list < JUMBO_Data_Tracker__c > updateJumboDataTracker = new list < JUMBO_Data_Tracker__c > ();
            for (JUMBO_Data_Tracker__c jdt: jumboTrackers) {
                jdt.EON_Data_Tracker__c = eonTracker.ID;
                updateJumboDataTracker.add(jdt);
            }
            insert updateJumboDataTracker;
        }
        if (oracleTrackers.size() > 0) {
            list < Oracle_Data_Tracker__c > updateOracleDataTracker = new list < Oracle_Data_Tracker__c > ();
            for (Oracle_Data_Tracker__c odt: oracleTrackers) {
                odt.EON_Data_Tracker__c = eonTracker.ID;
                updateOracleDataTracker.add(odt);
            }
            update updateOracleDataTracker;
        }
        //CH16.Start
        if (MDSTrackers.size() > 0) {
            list < MDS_Data_Tracker__c > updateMDSDataTracker = new list < MDS_Data_Tracker__c > ();
            for (MDS_Data_Tracker__c mdt: MDSTrackers) {
                mdt.EON_Data_Tracker__c = eonTracker.ID;
                updateMDSDataTracker.add(mdt);
            }
            insert updateMDSDataTracker;
        }
        //CH16.End
        system.debug('######Printing XML#######');
        EON_Get_Capacity_From_Isis_WS.getXML(response);
        return response;
    }
    public static void getXML(CapacityResponseDetail resp) {
        String XmlFormat;
        if (!EON_Utility.validateRequired(resp)) {
            XmlFormat = '<GetCapacityResponse>';
            if (!EON_Utility.validateRequired(resp.Activity)) {
                XmlFormat += '<Activity>';
                if (!EON_Utility.validateRequired(resp.Activity)) {
                    if (!EON_Utility.validateRequired(resp.Activity.Duration))
                        XmlFormat += '<Duration>' + String.valueOf(resp.Activity.Duration) + '</Duration>';
                    if (!EON_Utility.validateRequired(resp.Activity.TravelTime))
                        XmlFormat += '<TravelTime>' + String.valueOf(resp.Activity.TravelTime) + '</TravelTime>';
                }
                XmlFormat += '</Activity>';
            }
            if (!EON_Utility.validateRequired(resp.Capacities)) {
                XmlFormat += '<Capacities>';
                if (!EON_Utility.validateRequired(resp.Capacities.Capacity)) {
                    for (Capacity cap: resp.Capacities.Capacity) {
                        XmlFormat += '<Capacity>';
                            if (!EON_Utility.validateRequired(cap.AvailableQuota))
                            XmlFormat += '<AvailableQuota>' + String.valueOf(cap.AvailableQuota) + '</AvailableQuota>';
                        if (!EON_Utility.validateRequired(cap.CapacityDate))
                            XmlFormat += '<CapacityDate>' + String.valueOf(cap.CapacityDate) + '</CapacityDate>';
                        if (!EON_Utility.validateRequired(cap.EndTime))
                            XmlFormat += '<EndTime>' + String.valueOf(cap.EndTime) + '</EndTime>';
                        if (!EON_Utility.validateRequired(cap.Quota))
                            XmlFormat += '<Quota>' + String.valueOf(cap.Quota) + '</Quota>';
                        if (!EON_Utility.validateRequired(cap.StartTime))
                            XmlFormat += '<StartTime>' + String.valueOf(cap.StartTime) + '</StartTime>';
                        if (!EON_Utility.validateRequired(cap.TimeSlot))
                            XmlFormat += '<TimeSlot>' + String.valueOf(cap.TimeSlot) + '</TimeSlot>';
                        XmlFormat += '</Capacity>';
                    }
                }
                XmlFormat += '</Capacities>';
            }
                if (!EON_Utility.validateRequired(resp.Header)) {
                XmlFormat += '<Header>';
                if (!EON_Utility.validateRequired(resp.Header.OrgId))
                    XmlFormat += '<OrgId>' + resp.Header.OrgId + '</OrgId>';
                if (!EON_Utility.validateRequired(resp.Header.RequestDateTime))
                    XmlFormat += '<RequestDateTime>' + resp.Header.RequestDateTime + '</RequestDateTime>';
                if (!EON_Utility.validateRequired(resp.Header.RequestId))
                    XmlFormat += '<RequestId>' + resp.Header.RequestId + '</RequestId>';
                XmlFormat += '</Header>';
            }
            if (!EON_Utility.validateRequired(resp.Messages)) {
                XmlFormat += '<Messages>';
                if (!EON_Utility.validateRequired(resp.Messages.Message)) {
                    XmlFormat += '<Message>';
                    for (errMessage msg: resp.Messages.Message) {
                        if (!EON_Utility.validateRequired(msg.MessageId))
                            XmlFormat += '<MessageId>' + String.valueOf(msg.MessageId) + '</MessageId>';
                        if (!EON_Utility.validateRequired(msg.MessageText))
                            XmlFormat += '<MessageText>' + msg.MessageText + '</MessageText>';
                        if (!EON_Utility.validateRequired(msg.MessageType))
                            XmlFormat += '<MessageType>' + msg.MessageType + '</MessageType>';
                    }
                    XmlFormat += '</Message>';
                }
                XmlFormat += '</Messages>';
            }
        }
        if (!EON_Utility.validateRequired(XmlFormat)) {
            XmlFormat += '</GetCapacityResponse>';
        }
        system.debug('###XmlFormat: ' + XmlFormat);
    }
    /**
        generateErrorList(String msgType, Integer msgId, String msgText) - This method will edd the error send to list of errors
    **/
    private static void generateErrorList(String msgType, Integer msgId, String msgText){
        errMessage error = new errMessage();
        error.MessageType = msgType;
        error.MessageId = msgId;
        error.MessageText = msgText;
        lstError.add(error);
    }
}