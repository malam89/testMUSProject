/**
    Description : This class will be used for generating WSDL, so that EON can use this WSDL to create Reservation in OptiMUS.                            
    Test Class  : EON_CreateReservation_In_Isis_test
**/
/*
    Created By  : Akshay Bairagi
    Created On  : 15/03/2016
    Service Req : SR_EON_AB_017
    Change History:
    CH01 # SR_EON_AB_079 # 12-07-2016 # Sivasasnkar K # adding logic for mapping the incoming Job Attribute values with given mappin in SR spec doc. This action will only perform only on Create Appointment from EON Service.
    CH02 # SR_EON_AB_082 # 15-07-2016 # Akshay Bairagi # adding logic for no. of phases.
    CH03 # 27/07/2016 # Nitin # Fixed the issues while Peer Tesing. 
    CH04 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of NUmber of Phases changed from 1 and 3 to 1Ph and 3Ph
    CH05 # SR_EON_AB_109,SR_EON_AB_110 #28/09/2016 #Shruti Moghe # updated the code to achieve SR functionality
    CH06 # SR_EON_AB_116 # Puneet Mehta # Added code to insert vulnerabilities.
    CH07 # SR_EON_AB_125 # Sivasasnkar K # Added new mapping.
    CH08 # SR_EON_AB_130 # Sivasasnkar K # Added new mapping.
    CH09 # SR_EON_AB_143 # 13-09-2016 # Mahadev J # Populating 'EON Appointment' reference at 'EON Data Tracker'
    CH10 # SR_EON_AB_167 # 14/10/2016 # Akshay Bairagi # Removed "MPAN" from list of fields to copy data from Fuel record when dual fuel and we are not MAM
    CH11 # SR_EON_AB_169 # 19/10/2016 # Puneet Mehta # IF we are not MAM AND the MPRN does not exist in an existing Fuel record then "REJECT - Morrison does not have access to Gas details to be able to accept this request"
    CH12 # SR_EON_AB_175 # 25-10-2016 # Mahadev J # Populated 'Gas Market Participant ID' via 'EON Fuel' when 'We are not MAM'.
    CH13 # SR_EON_AB_180 # 04/11/2016 # Puneet Mehta # If MUS is the MAM of the relevant MPRN then we should get the data from JUMBO. Else if we are not MAM then the data should come from EON Fuel to populate the Gas MArket Participant Id field
    CH14 # SR_EON_AB_188 # 09/11/2016 # Mahadev J # Asynch to synch call to OFSC.
    CH15 # SR_EON_AB_185 # 04/11/2016 # Puneet Mehta # To return error if appointment date sent is not in the effective date range
    CH16 # SM-3119 # 21/11/2016 # Mahadev J # Create Jumbo Data Tracker
    CH17 # SR_EON_Jumbo_091 # 14/12/2016 # Puneet Mehta # Mapped new field from EON Fuel 'Gas Map Identifier'
    CH18 # SR_EON_Jumbo_093 # 16/12/2016 # Nitin bangar # Mapped new field from EON Fuel 'Gas number of dials or digits (A0121)'
    CH19 # SR_EON_Jumbo_096 # 12/01/2017 # Puneet Mehta # Mapped new field from EON Fuel
    CH20 # SR_OptiMUS_EON_033 # 27/01/2017 # Mahadev J # Override Job Type with type - Maintenance
    CH21 # SR_EON_Jumbo_107 # 20/02/2017 # Puneet Mehta # Mapped new field from EON Fuel
    CH22 # SR_EON_Jumbo_106 # 30/03/2017 # Mahadev J # Amendment for saving meters.
    CH23 # SR_EON_Jumbo_110 #05/04/2017 #Aruna Manjari # Mapping of appointment 'G Meter Model' field from custom setting. 
    CH24 # UAT Issue # 26/06/2017 # Praveen G # Fixed for the exception
    CH25 # SR_OptiMUS_EON_085 # 30/06/2017 # Praveen G # ignore the validation for the jobcode OOAEINSTALLBIND 
    CH26 # SR_OptiMUS_EON_165 UAT Issue # 11/12/2017 # Praveen G # ignore the validation for the jobcode OOASMARTDFINST
    CH27 # SR_EON_OFSC_017 # 20/12/2017 # Praveen G # Changes for Install SED flag.
    CH28 # SR_OptiMUS_EON_228 # 30/06/2017 # Praveen G # If EON Appointment MPRN is NOT null and MUS are NOT MAM and Fuel record does NOT exist then we should default 'Planned G Meter Type - MS1' 
                                                         and 'Metering Pressure - Low' 
    CH29 # SR_OptiMUS_EON_257 # 19/07/2018 # Mehboob Alam # populating Market Participant ID from Jumbo.
	CH30 # SR_OptiMUS_EON_297 # 05/02/2019 # Tabish Almas # Added logic to get data from MDS or Jumbo based on MDS Jumbo Dataflow Switch
*/
global with sharing class EON_CreateReservation_In_Isis_WS {
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class HeaderElement {
        Webservice String OrgId;
        Webservice String RequestId;
        Webservice datetime RequestDateTime;
    }
    /**
        Description : Request Parameter 2
    **/
    global with sharing class Timelement {
        Webservice Integer Hours;
        Webservice Integer Minutes;
    }
    /**
        Description : Request Parameter 3
    **/
    global with sharing class AppointmentDetailElement {
        Webservice String EONAppointmentID;
        Webservice Date AppointmentDate;
        Webservice Timelement StartTime;
        Webservice Timelement EndTime;
        Webservice String TimeSlot;
    }
    /**
        Description : Request Parameter 4
    **/
    global with sharing class JobAttributeElement {
        Webservice String Name;
        Webservice String Value;
    }
    /**
        Description : Request Parameter 5
    **/
    global with sharing class JobAttributesElement {
        Webservice list < JobAttributeElement > JobAttribute;
    }
    /**
        Description : Request Parameter 6
    **/
    global with sharing class JobTypeElement {
        Webservice String JobCode;
        Webservice String JobDesc;
        Webservice JobAttributesElement JobAttributes;
    }
    /**
        Description : Request Parameter 8
    **/
    global with sharing class MeterPointElement {
        Webservice String MPxN;
        Webservice String FuelType;
    }
    /**
        Description : Request Parameter 9
    **/
    global with sharing class MeterPointsElement {
        Webservice list < MeterPointElement > MeterPoint;
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class CreateReservation {
        Webservice HeaderElement Header;
        Webservice String BookingSystemName;
        Webservice String AssistedWorkReason;
        Webservice AppointmentDetailElement AppointmentDetails;
        Webservice JobTypeElement JobType;
        Webservice MeterPointsElement MeterPoints;
    }
    /**
        Description : Response 1
    **/
    global with sharing class errMessage {
        Webservice String MessageType;
        Webservice integer MessageId;
        Webservice String MessageText;
    }
    /**
        Description : Response 2
    **/
    global with sharing class errMessageLst {
        Webservice list < errMessage > Message;
    }
    /**
        Description : Response 3
    **/
    global with sharing class Isis_Response_Acknowledgement_To_EON {
        Webservice HeaderElement Header;
        Webservice Datetime ReservationCreationDate;
        Webservice String ExternalAppointmentID;
        Webservice String EONAppointmentID;
        Webservice errMessageLst Messages;
    }
    /**
        Description : validateStringLen
    **/
    public static String validateStringLen(String value, integer len){
        if (value != null && value.length() > len)
            value = value.subString(0, len);
        return value;
    }
    /**
        Description : checkLength
    **/
    public static String checkLength(String val){
        if(String.isNotBlank(val) && val.length() == 1)
            val = '0' + val;
        return val;
    }
    /**
        Isis_Response_Acknowledgement_To_EON CreateReservation(CreateReservation Reservation) - 
        This method is used to get create Reservation from Isis.
    **/
    webservice static Isis_Response_Acknowledgement_To_EON CreateReservation(CreateReservation Reservation) {
        Isis_Response_Acknowledgement_To_EON response = new Isis_Response_Acknowledgement_To_EON();
        errMessageLst errorlst = new errMessageLst();
        EON_Data_Tracker__c eonTracker = new EON_Data_Tracker__c();
        Oracle_Data_Tracker__c oTracker = new Oracle_Data_Tracker__c();
        list<Jumbo_Data_Tracker__c> jTracker = new list<Jumbo_Data_Tracker__c>(); //CH16.New
        list<MDS_Data_Tracker__c> mTracker = new list<MDS_Data_Tracker__c>(); //CH30
        eonTracker.Direction__c = EON_Utility.DIRECTION_IN ;
        eonTracker.Command__c = EON_Utility.CMD_EON_Create ;
        list < errMessage > msgLst = new list < errMessage > ();
        string Error = '';
        Map<string, EON_Vulnerability_Code__c> eonVulnerabilityCode = new Map <string, EON_Vulnerability_Code__c>();
        boolean insertAppt, NotMAM;
        insertAppt = NotMAM = false;
        list<attachment> allOFSCAttachments = new list<attachment>();
        list<attachment> allEONAttachments = new list<attachment>();
        list<EON_Appointment_Meter__c> allApptMeter = new list<EON_Appointment_Meter__c>(); //CH22
        String switchData = EON_MDS_Utility.getMDS_Jumbo_Status();	//CH30
        try{
            //CH30.Start
            if(switchData == system.label.Jumbo_Shortform) {
                //CH12.New.Start
                if(EON_CreateReservation_In_Isis_test.genException)
                    ID test = ID.valueof('test'); 
               //CH12.New.End
                if (Reservation != null) {
                    eonTracker.Request_Data__c = EON_Utility.validateStringLength(Reservation + '');
                    eonTracker.Transaction_ID__c = Reservation.header.requestId;
                    if (EON_Utility.validateRequired(Reservation.header.orgId) == true)
                        Error = 'OrgId cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.header.requestId) == true)
                        Error = Error + 'RequestId cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.header.RequestDateTime) == true)
                        Error = Error + 'RequestDateTime cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.BookingSystemName) == true)
                        Error = Error + 'BookingSystemName cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.AppointmentDetails.EONAppointmentID) == true)
                        Error = Error + 'EONAppointmentID cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.AppointmentDetails.AppointmentDate) == true)
                        Error = Error + 'AppointmentDate cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.JobType) != true) {
                        if (EON_Utility.validateRequired(Reservation.JobType.JobCode) == true)
                            Error = Error + 'JobCode cannot be blank\n';
                        if (EON_Utility.validateRequired(Reservation.JobType.JobDesc) == true)
                            Error = Error + 'JobDesc cannot be blank\n';
                    }
                    if (EON_Utility.validateRequired(Reservation.JobType) != true){
                        if (EON_Utility.validateRequired(Reservation.JobType.JobAttributes.JobAttribute) == true)
                            Error = Error + 'JobAttribute\'s cannot be blank\n';
                        else{
                            for (JobAttributeElement JAE: Reservation.JobType.JobAttributes.JobAttribute){
                                if (EON_Utility.validateRequired(JAE.Name) == true){
                                    Error = Error + 'JobAttribute\'s Name cannot be blank\n';
                                    Break;
                                }
                                if (EON_Utility.validateRequired(JAE.Value) == true){
                                    Error = Error + 'JobAttribute\'s Value cannot be blank\n';
                                    Break;
                                }
                            }
                        }
                    }
                    if(EON_Utility.validateRequired(Reservation.MeterPoints.MeterPoint) != true){
                        for (MeterPointElement ME: Reservation.MeterPoints.MeterPoint){
                            if (EON_Utility.validateRequired(ME.MPxN) == true) {
                                Error = Error + 'MPxN cannot be blank\n';
                                Break;
                            }
                            if (EON_Utility.validateRequired(ME.FuelType) == true) {
                                Error = Error + 'FuelType cannot be blank\n';
                                Break;
                            }
                        }
                    }
                    if (Error == ''){
                        EON_Appointment__c appointment = new EON_Appointment__c();
                        appointment.Booking_System_Name__c = validateStringLen(Reservation.BookingSystemName.trim(), 20); //CH05
                        appointment.EON_Appointment_ID__c = validateStringLen(Reservation.AppointmentDetails.EONAppointmentID.trim(), 22);
                        appointment.Assisted_Work_Reason__c = EON_Utility.validateRequired(Reservation.AssistedWorkReason) ? '' : validateStringLen(Reservation.AssistedWorkReason.trim(), 50);
                        appointment.Appointment_Date__c = Reservation.AppointmentDetails.AppointmentDate;
                        //Fix for Start time is opitonal - Praveen
                        appointment.Start_Time__c = '';
                        if (Reservation.AppointmentDetails.StartTime != null)
                            appointment.Start_Time__c = checkLength(EON_Utility.validateRequired(Reservation.AppointmentDetails.StartTime.Hours) ? '' : string.valueof(Reservation.AppointmentDetails.StartTime.Hours)) + ':' + checkLength((EON_Utility.validateRequired(Reservation.AppointmentDetails.StartTime.Minutes) ? '' : string.valueof(Reservation.AppointmentDetails.StartTime.Minutes)));
    
                        if(EON_CreateReservation_In_Isis_test.coverUncovered)
                            appointment.Start_Time__c = ':';
                        if (appointment.Start_Time__c == ':')
                            appointment.Start_Time__c = '';
                        string varJobCode = '';
    
                        if(!EON_Utility.validateRequired(Reservation.AppointmentDetails.TimeSlot))
                            appointment.Time_Slot__c = validateStringLen(Reservation.AppointmentDetails.TimeSlot.trim(), 20);
    
                        if (EON_Utility.validateRequired(Reservation.JobType.JobCode) != true)
                            varJobCode = validateStringLen(Reservation.JobType.JobCode.trim(), 20);
    
                        Datetime endtime;
                        Integer jobAttDuration = 0;
                        integer smeDuration = 0;
                        integer resDuration = 0;
                        boolean getMPIDfromFuel = false; //CH12.New
                        String jobAttKey = '', apptReasonCode = '', phaseValue = '', eMeterType = '', gMeterType = ''; //CH01 //CH08
                        list < EON_Job__c > jobLst = [select id, Job_Type__c, name, SME_Duration__c, Duration__c, MOP_Reqd__c, MAM_Reqd__c, ICE_Maintenance_Over_ride__c, (select id, Duration__c from EON_Job_Attributes__r) from EON_Job__c where name = : varJobCode limit 1]; //CH12.Update //CH15 //CH20.Update
                        if (jobLst != null && jobLst.size() > 0) {
                            appointment.Job_Code__c = jobLst[0].id;
                            EON_OFSC_Helper.overrideJobType = jobLst[0].ICE_Maintenance_Over_ride__c; //CH20.New
                            if (jobLst[0].EON_Job_Attributes__r != null && jobLst[0].EON_Job_Attributes__r.size() > 0) {
                                for (EON_Job_Attribute__c jobAtt: jobLst[0].EON_Job_Attributes__r) {
                                    if (jobAtt.Duration__c != null)
                                        jobAttDuration = jobAttDuration + integer.valueof(jobAtt.Duration__c);
                                }
                            }
                            smeDuration = integer.valueof(((jobLst[0].SME_Duration__c == null) ? 0 : jobLst[0].SME_Duration__c) + jobAttDuration);
                            resDuration = integer.valueof(((jobLst[0].Duration__c == null) ? 0 : jobLst[0].Duration__c) + jobAttDuration);
                            //CH12.New.Start
                            if(!jobLst[0].MAM_Reqd__c){
                                getMPIDfromFuel = true;
                                
                            }    
                            //CH12.New.End
                        }
                        //Job Attribute:
                        List<EON_Job_Attribute__c> lstJobAttr = new List < EON_Job_Attribute__c > ();
                        EON_Job_Attribute__c jobAtt;
    
                        //CH01 get all custom setting values
                        Map<String, EON_AttributeName_Field_Mapping__c> mapJobAttrFieldMapping = EON_AttributeName_Field_Mapping__c.getAll();
    
    
                        //Appointment Attribute:
                        List<EON_Appointment_Attribute__c> lstApptAttr = new List <EON_Appointment_Attribute__c>();
                        EON_Appointment_Attribute__c ApptAtt;
                        for(JobAttributeElement JAE: Reservation.JobType.JobAttributes.JobAttribute){
                            jobAtt = new EON_Job_Attribute__c(Name = JAE.Name, value__c = JAE.Value);
                            lstJobAttr.add(jobAtt);
                            ApptAtt = new EON_Appointment_Attribute__c(Job_Attribute__c = JAE.Name, Value__c = JAE.Value);
                            lstApptAttr.add(ApptAtt); //list of appointment attributes
                            //CH02.Start
                            if (JAE.Name.equalsIgnoreCase('Phase'))
                                phaseValue = JAE.Value.trim();
                            if (JAE.Name.equalsIgnoreCase('ELECMETERTYPE')) //CH08
                                eMeterType = JAE.Value.trim(); //CH08
                            if (JAE.Name.equalsIgnoreCase('GASMETERTYPE')) //CH08
                                gMeterType = JAE.Value.trim(); //CH08
                            //CH02.End
                            //CH01.Start Map the Eon Appointment fields based on incoming Job Attribues from Eon Appointment.
                            jobAttKey = JAE.Name.replace(' ', '') + JAE.Value.replace(' ', '');
                            if (jobAttKey != '' && jobAttKey != null && mapJobAttrFieldMapping != null && mapJobAttrFieldMapping.containsKey(jobAttKey.toUpperCase())) {
                                if(!JAE.Name.equalsIgnoreCase('APPTREASON')){
                                    System.debug('jobAttKey Values F= ' + mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Field_Mapping_API_Name__c + ', V = ' + mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Appointment_Field_Value__c);
                                    appointment.put(mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Field_Mapping_API_Name__c, mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Appointment_Field_Value__c);
                                } 
                                else
                                    apptReasonCode = mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Appointment_Field_Value__c;
                            }
                            //CH01.End
                        }
                        //CH01.Start
                        if (apptReasonCode != '') {
                            Eon_Appointment_Reason__c[] reasons = [SELECT ID,Name FROM Eon_Appointment_Reason__c WHERE Name = : apptReasonCode];
                            if (reasons != null && !reasons.isEmpty() && reasons.size() == 1){
                                appointment.Appointment_reason_code__c = reasons[0].id;
                            }    
                        }
                        //CH01.End
    
                        String MPAN, MPRN, postcode, custType;
                        MPAN = MPRN = postcode = custType = '';
                        for (MeterPointElement ME: Reservation.MeterPoints.MeterPoint) {
                            if (ME.FuelType == 'E') {
                                MPAN = ME.MPxN;
                                appointment.MPAN__c = MPAN;
                            }
                            if (ME.FuelType == 'G') {
                                MPRN = ME.MPxN;
                                appointment.MPRN__c = MPRN;
                            }
                        }
                        //Fix for End time as optional
                        appointment.End_Time__c = '';
                        if (Reservation.AppointmentDetails.EndTime != null)
                            appointment.End_Time__c = EON_Utility.validateRequired(Reservation.AppointmentDetails.EndTime.Hours) ? '' : checkLength(string.valueof(Reservation.AppointmentDetails.EndTime.Hours)) + ':' + (EON_Utility.validateRequired(Reservation.AppointmentDetails.EndTime.Minutes) ? '' : checkLength(string.valueof(Reservation.AppointmentDetails.EndTime.Minutes)));
    
                        list < EON_Fuel__c > mpanfuelLst;
                        if (appointment.End_Time__c == '') {
                            if (MPAN != '') {
                                mpanfuelLst = [select id, MPAN__c, Premise__r.Postcode__c, Premise__r.Customer__r.Customer_group_type__c from EON_Fuel__c where MPAN__c = : MPAN limit 1];
                                if (mpanfuelLst != null && mpanfuelLst.size() > 0) {
                                    appointment.Fuel_ID__c = mpanfuelLst[0].id;
                                    custType = mpanfuelLst[0].Premise__r.Customer__r.Customer_group_type__c;
                                    if ((appointment.Start_Time__c != ':') && (appointment.Start_Time__c != '')) {
                                        if (custType == 'SME')
                                            appointment.End_Time__c = checkLength(string.valueof(Math.floor((Integer.valueof(appointment.Start_Time__c.left(2)) * 60 + Integer.valueof(appointment.Start_Time__c.right(2)) + smeDuration) / 60).intValue())) + ':' + checkLength(string.valueof(Math.mod((Integer.valueof(appointment.Start_Time__c.left(2)) * 60 + Integer.valueof(appointment.Start_Time__c.right(2)) + smeDuration), 60)));
                                        else if (custType == 'RES')
                                            appointment.End_Time__c = checkLength(string.valueof(Math.floor((Integer.valueof(appointment.Start_Time__c.left(2)) * 60 + Integer.valueof(appointment.Start_Time__c.right(2)) + resDuration) / 60).intValue())) + ':' + checkLength(string.valueof(Math.mod((Integer.valueof(appointment.Start_Time__c.left(2)) * 60 + Integer.valueof(appointment.Start_Time__c.right(2)) + resDuration), 60)));
                                    }
                                }
                            }
                        }
                        list < EON_Fuel__c > fuelLst;
                        String jumboTraId, EonTraId;
                        jumboTraId = EonTraId = '';
                        //Calling Check validity function
                        Error = EON_OFSC_Helper.checkValidityForOFSC(varJobCode, lstJobAttr, MPAN, MPRN, postcode) + '\n'; //Check what we will get
                        if(!EON_Utility.validateRequired(EON_OFSC_Helper.jumboDataTrackers)){ //CH16.New
                            if(!EON_OFSC_Helper.jumboDataTrackers.isEmpty()){
                                jTracker.addAll(EON_OFSC_Helper.jumboDataTrackers);
                            }
                        }
                        system.debug('####OFSC Error: ' + Error);
                        if (!Error.containsIgnoreCase('REJECTED')) {
                            Error = '';
                            if (MPAN != '') {
                            
                            //CH29.Start
                            EON_Jumbo_ReqElectricityMOP.MOPValidationResponse mopCheck = EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP(MPAN);
                            appointment.Market_Participant_ID__c = mopCheck.marParticipantId;
                            //CH29.End
                            
                                //Calling J18 - Electric Data
                                EON_Jumbo_ReqElecMeterPointData.AccessElecMeterPointData(MPAN, appointment, jumboTraId, EonTraId);
                                if(!EON_Utility.validateRequired(EON_Jumbo_ReqElecMeterPointData.cTrack)){ //CH16.New
                                    jTracker.add(EON_Jumbo_ReqElecMeterPointData.cTrack);
                                }
                                
                                if (!EON_Jumbo_ReqElecMeterPointData.isError) {
                                    appointment = EON_Jumbo_ReqElecMeterPointData.apptIns;
                                    //CH22.Start
                                    if(!EON_Utility.validateRequired(EON_Jumbo_ReqElecMeterPointData.allApptMeter)){
                                        if(EON_Jumbo_ReqElecMeterPointData.allApptMeter.size()>1)
                                            allApptMeter.addAll(EON_Jumbo_ReqElecMeterPointData.allApptMeter);
                                    }
                                    //CH22.End
                                    System.debug('<<<<<<<<EON_OFSC_Helper.eonAppointment.>>>>>>>>>>'+EON_OFSC_Helper.eonAppointment.Effective_From_Date__c);
                                    System.debug('<<<appointment.Appointment_Date__c >>>'+appointment.Appointment_Date__c );
                                    System.debug('<<<EON_OFSC_Helper.eonAppointment.Effective_From_Date__c>>>'+EON_OFSC_Helper.eonAppointment.Effective_From_Date__c);
                                    System.debug('<<<EON_OFSC_Helper.eonAppointment.Effective_To_Date__c>>>'+EON_OFSC_Helper.eonAppointment.Effective_To_Date__c);
                                    System.debug('<<<appointment.Appointment_Date__c>>>'+appointment.Appointment_Date__c);
                                    System.debug('<<<EON_OFSC_Helper.eonAppointment.Effective_To_Date__c>>>'+EON_OFSC_Helper.eonAppointment.Effective_To_Date__c);
                                    
                                    if(EON_OFSC_Helper.eonAppointment.Effective_From_Date__c != null && appointment.Appointment_Date__c >= EON_OFSC_Helper.eonAppointment.Effective_From_Date__c && (EON_OFSC_Helper.eonAppointment.Effective_To_Date__c  == null || appointment.Appointment_Date__c <= EON_OFSC_Helper.eonAppointment.Effective_To_Date__c)){//CH15
                                        //CH02.Start //CH04.START
                                        //CH05.start
                                        if (appointment.Job_Code__c != null && jobLst != null && jobLst.size() > 0) {
                                            if (jobLst[0].name.containsIgnoreCase('SMART')) //CH08
                                                appointment.Planned_E_Meter_Type__c = 'MS1';
                                        } //CH05.end     
                                        if (phaseValue.equalsIgnoreCase('unchanged') && appointment.Number_of_Phases__c == '1Ph')
                                            appointment.Number_of_Phases__c = '1Ph';
                                        if (phaseValue.equalsIgnoreCase('unchanged') && appointment.Number_of_Phases__c == '3Ph')
                                            appointment.Number_of_Phases__c = '3Ph';
                                        if (phaseValue.equalsIgnoreCase('3PH') && appointment.Number_of_Phases__c == '1Ph')
                                            appointment.Number_of_Phases__c = '3Ph';
                                        if (phaseValue.equalsIgnoreCase('1PH') && appointment.Number_of_Phases__c == '3Ph')
                                            appointment.Number_of_Phases__c = '1Ph';
                                        if (String.isNotBlank(eMeterType)) //CH08
                                            appointment.Planned_E_Meter_Type__c = eMeterType; //CH08
                                        //CH02.End  //CH04.END
                                        //Call O.16 here || update appointment
                                        insertAppt = true; //CH05.new
                                        eonVulnerabilityCode = EON_Jumbo_ReqElecMeterPointData.eonVulnerabilityCode;
                                        system.debug('--camehere--');
                                    }//CH15
                                    else if(jobLst[0].MOP_Reqd__c){Error = 'REJECTED - MUS are not MOP for this MPAN on this date';}//CH15
                                } 
                                else
                                    Error = EON_Jumbo_ReqElecMeterPointData.Errors + '\n';
                            }
                            if (MPRN != '') {
                                appointment.Metering_Pressure__c = 'Low'; //CH28
                                appointment.Planned_G_Meter_Type__c = 'MS1'; //CH28
                                //Get data from EON fuel and Site records: //CH17 Added Gas_Map_Identifier__c to query //CH21 Added h_Gas_units_of_measure_A0123__c to query
                                fuelLst = [select Gas_year_of_manufacture_A0021__c, Gas_Map_Identifier__c, id, MPRN__c, MPAN__c, Gas_meter_serial_number__c, 
                                            Gas_model_A0083__c, Gas_manufacturer_code_A0060__c, Gas_measuring_capacity_A0112__c, Gas_multiplication_factor_A0120__c, Gas_number_of_dials_or_digits_A0121__c, Gas_units_of_measure_A0123__c,h_Gas_units_of_measure_A0123__c, Gas_meter_type_A0025__c, Gas_Meter_Mechanism__c, Gas_Meter_Mechanism__r.Code__c, /*CH07*/ Gas_payment_method_A0163__c, Premise__r.Sub_Building_Name__c, Premise__r.Building_Name__c, Premise__r.Dependant_Thorofare__c, Premise__r.Thorofare__c, Premise__r.Dependant_Locality__c, Premise__r.Double_Dependant_Locality__c, Premise__r.Town__c, Premise__r.Postcode__c, Gas_supplier_code__c, Premise__r.Customer__r.Customer_Name__c , h_Gas_Supplier_MPID__c from EON_Fuel__c where MPRN__c = : MPRN limit 1]; //CH12.Update
    
                                if (fuelLst != null && fuelLst.size() > 0) {
                                    appointment.Fuel_ID__c = fuelLst[0].id;
                                    //CH12.New.Strat
                                    if(getMPIDfromFuel)
                                        appointment.Gas_Market_Participant_ID__c = fuelLst[0].h_Gas_Supplier_MPID__c;
                                         
                                    //CH12.New.End
                                }
                                //Gas Data                            
                                //Calling J21 for MAM check
                                EON_Jumbo_ReqGasMAM.MAMValidationResponse wrpp = new EON_Jumbo_ReqGasMAM.MAMValidationResponse();
                                wrpp = EON_Jumbo_ReqGasMAM.ValidateMPRNMAM(MPRN);
                                if(!EON_Utility.validateRequired(EON_Jumbo_ReqGasMAM.cTrack)){ //CH16.New
                                    jTracker.add(EON_Jumbo_ReqGasMAM.cTrack);
                                }
                                
                                if (!wrpp.isError) {
                                system.debug('####wrpp.effFromDate: '+wrpp.effFromDate);
                                
                                    if (wrpp.effFromDate != null){ //&& wrpp.effToDate != null//CH05
                                        system.debug('####wrpp.effFromDate: '+wrpp.effFromDate);
                                        system.debug('####wrpp.effToDate: '+wrpp.effToDate);
                                        if ((appointment.Appointment_Date__c >= wrpp.effFromDate) && (wrpp.effToDate == null || appointment.Appointment_Date__c <= wrpp.effToDate)) { //CH05
                                            //If Appt Date decides whether MAM or Not
                                            //Calling J19 and get Gas data
                                            
                                            
                                            
                                            EON_Jumbo_ReqGasMeterPointData.AccessGasMeterPointData(MPRN, appointment, jumboTraId, EonTraId);
                                              //CH23
                                             if(getMPIDfromFuel){
                                             Map<String, EON_Model_ID_to_Model_Name_Mapping__c> allGasModels_A0083 = EON_Model_ID_to_Model_Name_Mapping__c.getAll();
                                             if(!allGasModels_A0083.isEmpty()){
                                                for(EON_Model_ID_to_Model_Name_Mapping__c  GasModel : allGasModels_A0083.values()){
                                                     if(fuelLst[0].Gas_model_A0083__c.equalsIgnoreCase(GasModel.Name)){
                                                    appointment.G_Meter_Model__c = GasModel.Model_Name__c; 
                                                    system.debug('%%%%%%%%Debug at line 479'+appointment.G_Meter_Model__c);
                                                    }
                                                }
                                            }
                                        }
                                        //CH23 
                                            
                                            if(!EON_Utility.validateRequired(EON_Jumbo_ReqGasMeterPointData.cTrack)){ //CH16.New
                                                jTracker.add(EON_Jumbo_ReqGasMeterPointData.cTrack);
                                            }
                                            if (!EON_Jumbo_ReqGasMeterPointData.isError) {
                                                appointment = EON_Jumbo_ReqGasMeterPointData.apptIns;
                                                appointment.G_Effective_From_Date__c = wrpp.effFromDate;
                                                appointment.G_Effective_To_Date__c = wrpp.effToDate;
                                                if(!EON_Utility.validateRequired(wrpp.abbrvtdName))//CH13
                                                    appointment.Gas_Market_Participant_ID__c = wrpp.abbrvtdName;//CH13
                                                //CH05.start
                                                if (appointment.Job_Code__c != null && jobLst != null && jobLst.size() > 0) {
                                                    if (jobLst[0].name.containsIgnoreCase('SMART')) //CH08
                                                        appointment.Planned_G_Meter_Type__c = 'MS1';
                                                } //CH05.end 
                                                if (String.isNotBlank(gMeterType)) //CH08
                                                    appointment.Planned_G_Meter_Type__c = gMeterType; //CH08
                                            } 
                                            else
                                                Error = Error + EON_Jumbo_ReqGasMeterPointData.Errors + '\n';
                                            //Call O.16 here || update appointment
                                            insertAppt = true; //CH05.new
                                        } 
                                        else if(jobLst[0].MAM_Reqd__c){Error = 'Rejected - MUS are not MAM for this MPRN on this date';}//CH15
                                        else
                                            NotMAM = true;
                                    }
                                } 
                                else{
                                    NotMAM = true;
                                }
                                if (NotMAM) {
                                    if (fuelLst != null && fuelLst.size() > 0) {
                                        appointment.Fuel_ID__c = fuelLst[0].id;
                                        appointment.MPRN__c = fuelLst[0].MPRN__c;
                                        appointment.G_Meter_Serial_Number__c = fuelLst[0].Gas_meter_serial_number__c;
                                        //appointment.G_Meter_Model__c = fuelLst[0].Gas_model_A0083__c; 
                                         //CH23
                                             if(getMPIDfromFuel){
                                             Map<String, EON_Model_ID_to_Model_Name_Mapping__c> allGasModels_A0083 = EON_Model_ID_to_Model_Name_Mapping__c.getAll();
                                             if(!allGasModels_A0083.isEmpty()){
                                                for(EON_Model_ID_to_Model_Name_Mapping__c  GasModel : allGasModels_A0083.values()){
                                                     if(fuelLst[0].Gas_model_A0083__c.equalsIgnoreCase(GasModel.Name)){
                                                    appointment.G_Meter_Model__c = GasModel.Model_Name__c; 
                                                    system.debug('%%%%%%%%Debug at line 501'+appointment.G_Meter_Model__c);
                                                    }
                                                }
                                            }
                                        }
                                        //CH23 
                                        
                                        appointment.G_Meter_Make__c = fuelLst[0].Gas_manufacturer_code_A0060__c;
                                        appointment.G_Meter_Measuring_Capacity__c = string.valueof(fuelLst[0].Gas_measuring_capacity_A0112__c);
                                        appointment.Number_of_Dials_or_Digits__c = fuelLst[0].Gas_number_of_dials_or_digits_A0121__c;
                                        appointment.G_Meter_Type__c = fuelLst[0].Gas_meter_type_A0025__c;
                                        appointment.G_Meter_Mechanism__c = fuelLst[0].Gas_Meter_Mechanism__c;
                                        appointment.Payment_Method_code__c = fuelLst[0].Gas_payment_method_A0163__c;
                                        appointment.Sub_Building_Name__c = fuelLst[0].Premise__r.Sub_Building_Name__c;
                                        appointment.Building_Name__c = fuelLst[0].Premise__r.Building_Name__c;
                                        appointment.Dependent_Thorofare__c = fuelLst[0].Premise__r.Dependant_Thorofare__c;
                                        appointment.Thorofare__c = fuelLst[0].Premise__r.Thorofare__c;
                                        appointment.Dependant_Locality__c = fuelLst[0].Premise__r.Dependant_Locality__c;
                                        appointment.Double_dependant_Locality__c = fuelLst[0].Premise__r.Double_Dependant_Locality__c;
                                        appointment.Post_Town__c = fuelLst[0].Premise__r.Town__c;
                                        appointment.Post_Code__c = fuelLst[0].Premise__r.Postcode__c;
                                        appointment.Person_Name__c = fuelLst[0].Premise__r.Customer__r.Customer_Name__c;
                                        //appointment.MPAN__c = fuelLst[0].MPAN__c;//CH10
                                        appointment.Supplier_Name__c = fuelLst[0].Gas_supplier_code__c;
                                        appointment.Gas_Map_Identifier__c = fuelLst[0].Gas_Map_Identifier__c;//CH17
                                        appointment.G_Meter_No_of_dials_digits__c = fuelLst[0].Gas_number_of_dials_or_digits_A0121__c;//CH18
                                        appointment.G_Meter_Year_of_Manufacture__c = fuelLst[0].Gas_year_of_manufacture_A0021__c;//CH19
                                        appointment.G_Meter_Units_of_Measure__c = fuelLst[0].h_Gas_units_of_measure_A0123__c;//CH21
                                        appointment.G_Meter_Multiplication_Factor__c = fuelLst[0].Gas_multiplication_factor_A0120__c;//CH19
                                        //CH07.START
                                        //appointment.Metering_Pressure__c = 'Low'; //CH28.old
                                        if (fuelLst[0].Gas_Meter_Mechanism__r.Code__c != null)
                                            appointment.Planned_G_Meter_Type__c = ((EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll() != null && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(fuelLst[0].Gas_Meter_Mechanism__r.Code__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(fuelLst[0].Gas_Meter_Mechanism__r.Code__c.toUpperCase()).Planned_Meter_Type__c : appointment.Planned_G_Meter_Type__c);
                                        if (appointment.Job_Code__c != null && jobLst != null && jobLst.size() > 0) {
                                            if (jobLst[0].name.containsIgnoreCase('SMART')) //CH08
                                                appointment.Planned_G_Meter_Type__c = 'MS1';
                                        }
                                        if (String.isNotBlank(gMeterType)) //CH08
                                            appointment.Planned_G_Meter_Type__c = gMeterType; //CH08
                                        system.debug('Planned_G_Meter_Type__c--->' + appointment.Planned_G_Meter_Type__c);
                                        //CH07.END
                                        //Call O.16 here || update appointment
                                        insertAppt = true;
                                    }
                                    //CH11.START
                                    else
                                        //CH25.Start
                                        if(varJobCode != 'OOAEINSTALLBIND'
                                          && varJobCode != 'OOASMARTDFINST') //CH26
                                        //CH25.end 
                                        Error = 'REJECT - Morrison does not have access to Gas details to be able to accept this request';
                                    //CH11.END
                                }
                            }
                            if (MPAN == '' && MPRN == '') {
                                //DoorKnocking Scenario for Future Development.
                            }
                        }
                        //CH05.start
                       System.debug('<<<<insertAppt>>>>'+insertAppt);
                        if (insertAppt) {
                            //CH06.start
                            list < EON_Appointment_Vulnerability__c > allEONVulnerabilityCode = new list < EON_Appointment_Vulnerability__c > (); //Ch14.New
                            if (eonVulnerabilityCode != null && eonVulnerabilityCode.size() > 0) {
                                //list < EON_Appointment_Vulnerability__c > allEONVulnerabilityCode = new list < EON_Appointment_Vulnerability__c > (); //CH14.Old
                                for (EON_Vulnerability_Code__c vul: eonVulnerabilityCode.values()) {
                                    EON_Appointment_Vulnerability__c appVul = new EON_Appointment_Vulnerability__c();
                                    appVul.Description__c = vul.id;
                                    //appVul.EON_Appointment_ID__c = appointment.id;
                                    appVul.VulnerabilityDetailCode__c = vul.Vulnerability_Code__c;
                                    allEONVulnerabilityCode.add(appVul);
                                }
                                //if (allEONVulnerabilityCode != null && allEONVulnerabilityCode.size() > 0) insert allEONVulnerabilityCode; //Ch14.Old
                            }
                            //CH06.end
                            //CH14.New.Start
                            appointment.Appointment_Key__c = EON_Utility.GenUniqueNum();
                            EON_OFSC_Create_Appointment_Wrapper apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appointment, allEONVulnerabilityCode, null);
                            //Call OFSC Create Activity API
                            String ofscResult = EON_OFSC_Create_Appointment.sendActivityToOFSC(apptWrapper, 'CREATE', '', '', string.valueof(appointment.Appointment_Date__c), appointment.Time_Slot__c, 'EON');
                            oTracker = EON_OFSC_Create_Appointment.oTracker;
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.reqToOFSC))
                                allOFSCAttachments.add(new Attachment(body = EON_OFSC_Create_Appointment.reqToOFSC, Name='Req'));
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.respFromOFSC))
                                allOFSCAttachments.add(new Attachment(body = EON_OFSC_Create_Appointment.respFromOFSC, Name='Resp'));
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.ofscAID))
                                appointment.h_aid__c = EON_OFSC_Create_Appointment.ofscAID;
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.ofscAID))
                                appointment.Duration__c = EON_OFSC_Create_Appointment.ofscDuration;
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.ofscSubArea))
                                appointment.SubArea__c = EON_OFSC_Create_Appointment.ofscSubArea;
                            //CH27.start
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.InstallSEDFlag))
                                appointment.Install_SED_flag__c= EON_OFSC_Create_Appointment.InstallSEDFlag; 
                            //CH27.end
                            if(EON_OFSC_Create_Appointment.hasError){  //Error
                                Error = ofscResult;
                            }
                            else{ //Success
                                appointment.Sent_to_Oracle__c = true;
                                if(allApptMeter != null && allApptMeter.size() > 1){ //CH22.New
                                    appointment.Multiple_Meters_at_Site__c = true;
                                }
                                insert appointment;
                                if(allEONVulnerabilityCode != null && allEONVulnerabilityCode.size() > 0){
                                    for(EON_Appointment_Vulnerability__c appVul: allEONVulnerabilityCode)
                                        appVul.EON_Appointment_ID__c = appointment.id;
                                    insert allEONVulnerabilityCode;
                                } 
                                if(allEONVulnerabilityCode != null && allEONVulnerabilityCode.size() > 0){
                                    for(EON_Appointment_Attribute__c att: lstApptAttr)
                                        att.EON_Appointment_ID__c = appointment.id;
                                    insert lstApptAttr;
                                }
                                 //CH22.Start
                                if(allApptMeter != null && allApptMeter.size() > 1){
                                    for(EON_Appointment_Meter__c apptMeter: allApptMeter)
                                        apptMeter.EON_Appointment__c = appointment.id;
                                    insert allApptMeter;
                                 }
                                //CH22.End
                                errMessage msg = new errMessage();
                                msg.MessageType = 'Information';
                                msg.MessageId = 0;
                                msg.MessageText = 'Request processed Successfully.';
                                msgLst.add(msg);
                                errorlst.Message = msgLst;
                                response.Messages = errorlst;
                                response.ReservationCreationDate = system.now();
                                response.ExternalAppointmentID = [select id, name from EON_Appointment__c where id = : appointment.id limit 1].Name;
                                response.EONAppointmentID = Reservation.AppointmentDetails.EONAppointmentID.trim();
                                response.header = Reservation.header;
                                response.header.orgId = system.label.EON_Sanbox_Name;
                                eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
                                eonTracker.Status__c = EON_Utility.RESULT_PASS;
                                eonTracker.Appointment__c = appointment.ID;
                                insert eonTracker;
                                oTracker = EON_OFSC_Create_Appointment.oTracker;
                                oTracker.EON_Appointment__c = appointment.ID;
                                oTracker.EON_Data_Tracker__c = eonTracker.ID;
                                oTracker.Transaction_ID__c = appointment.Id;
                                insert oTracker;
                                
                                //CH16.New
                                if(!jTracker.isEmpty()){
                                    for(Jumbo_Data_Tracker__c jData : jTracker){
                                        jData.EON_Appointment__c = appointment.ID;
                                        jData.EON_Data_Tracker__c = eonTracker.ID;
                                    }
                                }
                            }
                            //CH14.New.End
                        }
                        //CH05.end
                    }
                    if(Error != '') {
                        errMessage msg = new errMessage();
                        msg.MessageType = 'Exception';
                        msg.MessageId = 1;
                        if (Error.containsIgnoreCase('cannot be blank') || Error.containsIgnoreCase('REJECT')) //CH11
                            msg.MessageText = Error;
                        else
                            msg.MessageText = 'Appointment can\'t be created, Please contact your administrator.';
                        msgLst.add(msg);
                        errorlst.Message = msgLst;
                        response.Messages = errorlst;
                        response.header = Reservation.header;
                        response.header.orgId = system.label.EON_Sanbox_Name;
                        eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
                        eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                        eonTracker.Error__c = Error;
                        //insert eonTracker; CH24.OLD
                        upsert eonTracker; //CH24.NEW
                        if(!EON_Utility.validateRequired(oTracker.Status__c)){
                            oTracker.EON_Data_Tracker__c = eonTracker.Id;
                            oTracker.Isis_Error__c = Error;
                            //insert oTracker; CH24.OLD
                            upsert oTracker; //CH24.New                      
                        }
                        //CH16.New
                        if(!jTracker.isEmpty()){
                            for(Jumbo_Data_Tracker__c jData : jTracker){
                                jData.EON_Data_Tracker__c = eonTracker.ID;
                            }
                        }
                    }
                } 
                else{
                    Error = 'Request Not Found';
                    errMessage msg = new errMessage();
                    msg.MessageType = 'Exception';
                    msg.MessageId = 1;
                    msg.MessageText = 'Appointment can\'t be created, Please contact your administrator.';
                    msgLst.add(msg);
                    errorlst.Message = msgLst;
                    response.Messages = errorlst;
                    eonTracker.Request_Data__c = 'Blank Request';
                    eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
                    eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                    eonTracker.Error__c = Error;
                }
            }
            else if(switchData == system.label.MDS_Shortform) {
                //CH12.New.Start
                if(EON_CreateReservation_In_Isis_test.genException)
                    ID test = ID.valueof('test'); 
               //CH12.New.End
                if (Reservation != null) {
                    eonTracker.Request_Data__c = EON_Utility.validateStringLength(Reservation + '');
                    eonTracker.Transaction_ID__c = Reservation.header.requestId;
                    if (EON_Utility.validateRequired(Reservation.header.orgId) == true)
                        Error = 'OrgId cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.header.requestId) == true)
                        Error = Error + 'RequestId cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.header.RequestDateTime) == true)
                        Error = Error + 'RequestDateTime cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.BookingSystemName) == true)
                        Error = Error + 'BookingSystemName cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.AppointmentDetails.EONAppointmentID) == true)
                        Error = Error + 'EONAppointmentID cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.AppointmentDetails.AppointmentDate) == true)
                        Error = Error + 'AppointmentDate cannot be blank\n';
                    if (EON_Utility.validateRequired(Reservation.JobType) != true) {
                        if (EON_Utility.validateRequired(Reservation.JobType.JobCode) == true)
                            Error = Error + 'JobCode cannot be blank\n';
                        if (EON_Utility.validateRequired(Reservation.JobType.JobDesc) == true)
                            Error = Error + 'JobDesc cannot be blank\n';
                    }
                    if (EON_Utility.validateRequired(Reservation.JobType) != true){
                        if (EON_Utility.validateRequired(Reservation.JobType.JobAttributes.JobAttribute) == true)
                            Error = Error + 'JobAttribute\'s cannot be blank\n';
                        else{
                            for (JobAttributeElement JAE: Reservation.JobType.JobAttributes.JobAttribute){
                                if (EON_Utility.validateRequired(JAE.Name) == true){
                                    Error = Error + 'JobAttribute\'s Name cannot be blank\n';
                                    Break;
                                }
                                if (EON_Utility.validateRequired(JAE.Value) == true){
                                    Error = Error + 'JobAttribute\'s Value cannot be blank\n';
                                    Break;
                                }
                            }
                        }
                    }
                    if(EON_Utility.validateRequired(Reservation.MeterPoints.MeterPoint) != true){
                        for (MeterPointElement ME: Reservation.MeterPoints.MeterPoint){
                            if (EON_Utility.validateRequired(ME.MPxN) == true) {
                                Error = Error + 'MPxN cannot be blank\n';
                                Break;
                            }
                            if (EON_Utility.validateRequired(ME.FuelType) == true) {
                                Error = Error + 'FuelType cannot be blank\n';
                                Break;
                            }
                        }
                    }
                    if (Error == ''){
                        EON_Appointment__c appointment = new EON_Appointment__c();
                        appointment.Booking_System_Name__c = validateStringLen(Reservation.BookingSystemName.trim(), 20); //CH05
                        appointment.EON_Appointment_ID__c = validateStringLen(Reservation.AppointmentDetails.EONAppointmentID.trim(), 22);
                        appointment.Assisted_Work_Reason__c = EON_Utility.validateRequired(Reservation.AssistedWorkReason) ? '' : validateStringLen(Reservation.AssistedWorkReason.trim(), 50);
                        appointment.Appointment_Date__c = Reservation.AppointmentDetails.AppointmentDate;
                        //Fix for Start time is opitonal - Praveen
                        appointment.Start_Time__c = '';
                        if (Reservation.AppointmentDetails.StartTime != null)
                            appointment.Start_Time__c = checkLength(EON_Utility.validateRequired(Reservation.AppointmentDetails.StartTime.Hours) ? '' : string.valueof(Reservation.AppointmentDetails.StartTime.Hours)) + ':' + checkLength((EON_Utility.validateRequired(Reservation.AppointmentDetails.StartTime.Minutes) ? '' : string.valueof(Reservation.AppointmentDetails.StartTime.Minutes)));
    
                        if(EON_CreateReservation_In_Isis_test.coverUncovered)
                            appointment.Start_Time__c = ':';
                        if (appointment.Start_Time__c == ':')
                            appointment.Start_Time__c = '';
                        string varJobCode = '';
    
                        if(!EON_Utility.validateRequired(Reservation.AppointmentDetails.TimeSlot))
                            appointment.Time_Slot__c = validateStringLen(Reservation.AppointmentDetails.TimeSlot.trim(), 20);
    
                        if (EON_Utility.validateRequired(Reservation.JobType.JobCode) != true)
                            varJobCode = validateStringLen(Reservation.JobType.JobCode.trim(), 20);
    
                        Datetime endtime;
                        Integer jobAttDuration = 0;
                        integer smeDuration = 0;
                        integer resDuration = 0;
                        boolean getMPIDfromFuel = false; //CH12.New
                        String jobAttKey = '', apptReasonCode = '', phaseValue = '', eMeterType = '', gMeterType = ''; //CH01 //CH08
                        list < EON_Job__c > jobLst = [select id, Job_Type__c, name, SME_Duration__c, Duration__c, MOP_Reqd__c, MAM_Reqd__c, ICE_Maintenance_Over_ride__c, (select id, Duration__c from EON_Job_Attributes__r) from EON_Job__c where name = : varJobCode limit 1]; //CH12.Update //CH15 //CH20.Update
                        if (jobLst != null && jobLst.size() > 0) {
                            appointment.Job_Code__c = jobLst[0].id;
                            EON_OFSC_Helper.overrideJobType = jobLst[0].ICE_Maintenance_Over_ride__c; //CH20.New
                            if (jobLst[0].EON_Job_Attributes__r != null && jobLst[0].EON_Job_Attributes__r.size() > 0) {
                                for (EON_Job_Attribute__c jobAtt: jobLst[0].EON_Job_Attributes__r) {
                                    if (jobAtt.Duration__c != null)
                                        jobAttDuration = jobAttDuration + integer.valueof(jobAtt.Duration__c);
                                }
                            }
                            smeDuration = integer.valueof(((jobLst[0].SME_Duration__c == null) ? 0 : jobLst[0].SME_Duration__c) + jobAttDuration);
                            resDuration = integer.valueof(((jobLst[0].Duration__c == null) ? 0 : jobLst[0].Duration__c) + jobAttDuration);
                            //CH12.New.Start
                            if(!jobLst[0].MAM_Reqd__c){
                                getMPIDfromFuel = true;
                                
                            }    
                            //CH12.New.End
                        }
                        //Job Attribute:
                        List<EON_Job_Attribute__c> lstJobAttr = new List < EON_Job_Attribute__c > ();
                        EON_Job_Attribute__c jobAtt;
    
                        //CH01 get all custom setting values
                        Map<String, EON_AttributeName_Field_Mapping__c> mapJobAttrFieldMapping = EON_AttributeName_Field_Mapping__c.getAll();
    
    
                        //Appointment Attribute:
                        List<EON_Appointment_Attribute__c> lstApptAttr = new List <EON_Appointment_Attribute__c>();
                        EON_Appointment_Attribute__c ApptAtt;
                        for(JobAttributeElement JAE: Reservation.JobType.JobAttributes.JobAttribute){
                            jobAtt = new EON_Job_Attribute__c(Name = JAE.Name, value__c = JAE.Value);
                            lstJobAttr.add(jobAtt);
                            ApptAtt = new EON_Appointment_Attribute__c(Job_Attribute__c = JAE.Name, Value__c = JAE.Value);
                            lstApptAttr.add(ApptAtt); //list of appointment attributes
                            //CH02.Start
                            if (JAE.Name.equalsIgnoreCase('Phase'))
                                phaseValue = JAE.Value.trim();
                            if (JAE.Name.equalsIgnoreCase('ELECMETERTYPE')) //CH08
                                eMeterType = JAE.Value.trim(); //CH08
                            if (JAE.Name.equalsIgnoreCase('GASMETERTYPE')) //CH08
                                gMeterType = JAE.Value.trim(); //CH08
                            //CH02.End
                            //CH01.Start Map the Eon Appointment fields based on incoming Job Attribues from Eon Appointment.
                            jobAttKey = JAE.Name.replace(' ', '') + JAE.Value.replace(' ', '');
                            if (jobAttKey != '' && jobAttKey != null && mapJobAttrFieldMapping != null && mapJobAttrFieldMapping.containsKey(jobAttKey.toUpperCase())) {
                                if(!JAE.Name.equalsIgnoreCase('APPTREASON')){
                                    System.debug('jobAttKey Values F= ' + mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Field_Mapping_API_Name__c + ', V = ' + mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Appointment_Field_Value__c);
                                    appointment.put(mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Field_Mapping_API_Name__c, mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Appointment_Field_Value__c);
                                } 
                                else
                                    apptReasonCode = mapJobAttrFieldMapping.get(jobAttKey.toUpperCase()).Appointment_Field_Value__c;
                            }
                            //CH01.End
                        }
                        //CH01.Start
                        if (apptReasonCode != '') {
                            Eon_Appointment_Reason__c[] reasons = [SELECT ID,Name FROM Eon_Appointment_Reason__c WHERE Name = : apptReasonCode];
                            if (reasons != null && !reasons.isEmpty() && reasons.size() == 1){
                                appointment.Appointment_reason_code__c = reasons[0].id;
                            }    
                        }
                        //CH01.End
    
                        String MPAN, MPRN, postcode, custType;
                        MPAN = MPRN = postcode = custType = '';
                        for (MeterPointElement ME: Reservation.MeterPoints.MeterPoint) {
                            if (ME.FuelType == 'E') {
                                MPAN = ME.MPxN;
                                appointment.MPAN__c = MPAN;
                            }
                            if (ME.FuelType == 'G') {
                                MPRN = ME.MPxN;
                                appointment.MPRN__c = MPRN;
                            }
                        }
                        //Fix for End time as optional
                        appointment.End_Time__c = '';
                        if (Reservation.AppointmentDetails.EndTime != null)
                            appointment.End_Time__c = EON_Utility.validateRequired(Reservation.AppointmentDetails.EndTime.Hours) ? '' : checkLength(string.valueof(Reservation.AppointmentDetails.EndTime.Hours)) + ':' + (EON_Utility.validateRequired(Reservation.AppointmentDetails.EndTime.Minutes) ? '' : checkLength(string.valueof(Reservation.AppointmentDetails.EndTime.Minutes)));
    
                        list < EON_Fuel__c > mpanfuelLst;
                        if (appointment.End_Time__c == '') {
                            if (MPAN != '') {
                                mpanfuelLst = [select id, MPAN__c, Premise__r.Postcode__c, Premise__r.Customer__r.Customer_group_type__c from EON_Fuel__c where MPAN__c = : MPAN limit 1];
                                if (mpanfuelLst != null && mpanfuelLst.size() > 0) {
                                    appointment.Fuel_ID__c = mpanfuelLst[0].id;
                                    custType = mpanfuelLst[0].Premise__r.Customer__r.Customer_group_type__c;
                                    if ((appointment.Start_Time__c != ':') && (appointment.Start_Time__c != '')) {
                                        if (custType == 'SME')
                                            appointment.End_Time__c = checkLength(string.valueof(Math.floor((Integer.valueof(appointment.Start_Time__c.left(2)) * 60 + Integer.valueof(appointment.Start_Time__c.right(2)) + smeDuration) / 60).intValue())) + ':' + checkLength(string.valueof(Math.mod((Integer.valueof(appointment.Start_Time__c.left(2)) * 60 + Integer.valueof(appointment.Start_Time__c.right(2)) + smeDuration), 60)));
                                        else if (custType == 'RES')
                                            appointment.End_Time__c = checkLength(string.valueof(Math.floor((Integer.valueof(appointment.Start_Time__c.left(2)) * 60 + Integer.valueof(appointment.Start_Time__c.right(2)) + resDuration) / 60).intValue())) + ':' + checkLength(string.valueof(Math.mod((Integer.valueof(appointment.Start_Time__c.left(2)) * 60 + Integer.valueof(appointment.Start_Time__c.right(2)) + resDuration), 60)));
                                    }
                                }
                            }
                        }
                        list < EON_Fuel__c > fuelLst;
                        String MDSTraId, EonTraId;
                        MDSTraId = EonTraId = '';
                        //Calling Check validity function
                        Error = EON_OFSC_Helper.checkValidityForOFSC(varJobCode, lstJobAttr, MPAN, MPRN, postcode) + '\n'; //Check what we will get
                        if(!EON_Utility.validateRequired(EON_OFSC_Helper.MDSDataTrackers)){ //CH16.New
                            if(!EON_OFSC_Helper.MDSDataTrackers.isEmpty()){
                                mTracker.addAll(EON_OFSC_Helper.MDSDataTrackers);
                            }
                        }
                        system.debug('####OFSC Error: ' + Error);
                        if (!Error.containsIgnoreCase('REJECTED')) {
                            Error = '';
                            if (MPAN != '') {
                            
                            //CH29.Start
                            EON_MDS_ReqElectricityMOP.MOPValidationResponse mopCheck = EON_MDS_ReqElectricityMOP.ValidateMPANMOP(MPAN);
                            appointment.Market_Participant_ID__c = mopCheck.marParticipantId;
                            //CH29.End
                            
                                //Calling J18 - Electric Data
                                EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(MPAN, appointment, MDSTraId, EonTraId);
                                if(!EON_Utility.validateRequired(EON_MDS_ReqElecMeterPointData.cTrack)){ //CH16.New
                                    mTracker.add(EON_MDS_ReqElecMeterPointData.cTrack);
                                }
                                
                                if (!EON_MDS_ReqElecMeterPointData.isError) {
                                    appointment = EON_MDS_ReqElecMeterPointData.apptIns;
                                    //CH22.Start
                                    if(!EON_Utility.validateRequired(EON_MDS_ReqElecMeterPointData.allApptMeter)){
                                        if(EON_MDS_ReqElecMeterPointData.allApptMeter.size()>1)
                                            allApptMeter.addAll(EON_MDS_ReqElecMeterPointData.allApptMeter);
                                    }
                                    //CH22.End
                                    System.debug('<<<<<<<<EON_OFSC_Helper.eonAppointment.>>>>>>>>>>'+EON_OFSC_Helper.eonAppointment.Effective_From_Date__c);
                                    System.debug('<<<appointment.Appointment_Date__c >>>'+appointment.Appointment_Date__c );
                                    System.debug('<<<EON_OFSC_Helper.eonAppointment.Effective_From_Date__c>>>'+EON_OFSC_Helper.eonAppointment.Effective_From_Date__c);
                                    System.debug('<<<EON_OFSC_Helper.eonAppointment.Effective_To_Date__c>>>'+EON_OFSC_Helper.eonAppointment.Effective_To_Date__c);
                                    System.debug('<<<appointment.Appointment_Date__c>>>'+appointment.Appointment_Date__c);
                                    System.debug('<<<EON_OFSC_Helper.eonAppointment.Effective_To_Date__c>>>'+EON_OFSC_Helper.eonAppointment.Effective_To_Date__c);
                                    
                                    if(EON_OFSC_Helper.eonAppointment.Effective_From_Date__c != null && appointment.Appointment_Date__c >= EON_OFSC_Helper.eonAppointment.Effective_From_Date__c && (EON_OFSC_Helper.eonAppointment.Effective_To_Date__c  == null || appointment.Appointment_Date__c <= EON_OFSC_Helper.eonAppointment.Effective_To_Date__c)){//CH15
                                        //CH02.Start //CH04.START
                                        //CH05.start
                                        if (appointment.Job_Code__c != null && jobLst != null && jobLst.size() > 0) {
                                            if (jobLst[0].name.containsIgnoreCase('SMART')) //CH08
                                                appointment.Planned_E_Meter_Type__c = 'MS1';
                                        } //CH05.end     
                                        if (phaseValue.equalsIgnoreCase('unchanged') && appointment.Number_of_Phases__c == '1Ph')
                                            appointment.Number_of_Phases__c = '1Ph';
                                        if (phaseValue.equalsIgnoreCase('unchanged') && appointment.Number_of_Phases__c == '3Ph')
                                            appointment.Number_of_Phases__c = '3Ph';
                                        if (phaseValue.equalsIgnoreCase('3PH') && appointment.Number_of_Phases__c == '1Ph')
                                            appointment.Number_of_Phases__c = '3Ph';
                                        if (phaseValue.equalsIgnoreCase('1PH') && appointment.Number_of_Phases__c == '3Ph')
                                            appointment.Number_of_Phases__c = '1Ph';
                                        if (String.isNotBlank(eMeterType)) //CH08
                                            appointment.Planned_E_Meter_Type__c = eMeterType; //CH08
                                        //CH02.End  //CH04.END
                                        //Call O.16 here || update appointment
                                        insertAppt = true; //CH05.new
                                        eonVulnerabilityCode = EON_MDS_ReqElecMeterPointData.eonVulnerabilityCode;
                                        system.debug('--camehere--');
                                    }//CH15
                                    else if(jobLst[0].MOP_Reqd__c){Error = 'REJECTED - MUS are not MOP for this MPAN on this date';}//CH15
                                } 
                                else
                                    Error = EON_MDS_ReqElecMeterPointData.Errors + '\n';
                            }
                            if (MPRN != '') {
                                appointment.Metering_Pressure__c = 'Low'; //CH28
                                appointment.Planned_G_Meter_Type__c = 'MS1'; //CH28
                                //Get data from EON fuel and Site records: //CH17 Added Gas_Map_Identifier__c to query //CH21 Added h_Gas_units_of_measure_A0123__c to query
                                fuelLst = [select Gas_year_of_manufacture_A0021__c, Gas_Map_Identifier__c, id, MPRN__c, MPAN__c, Gas_meter_serial_number__c, 
                                            Gas_model_A0083__c, Gas_manufacturer_code_A0060__c, Gas_measuring_capacity_A0112__c, Gas_multiplication_factor_A0120__c, Gas_number_of_dials_or_digits_A0121__c, Gas_units_of_measure_A0123__c,h_Gas_units_of_measure_A0123__c, Gas_meter_type_A0025__c, Gas_Meter_Mechanism__c, Gas_Meter_Mechanism__r.Code__c, /*CH07*/ Gas_payment_method_A0163__c, Premise__r.Sub_Building_Name__c, Premise__r.Building_Name__c, Premise__r.Dependant_Thorofare__c, Premise__r.Thorofare__c, Premise__r.Dependant_Locality__c, Premise__r.Double_Dependant_Locality__c, Premise__r.Town__c, Premise__r.Postcode__c, Gas_supplier_code__c, Premise__r.Customer__r.Customer_Name__c , h_Gas_Supplier_MPID__c from EON_Fuel__c where MPRN__c = : MPRN limit 1]; //CH12.Update
    
                                if (fuelLst != null && fuelLst.size() > 0) {
                                    appointment.Fuel_ID__c = fuelLst[0].id;
                                    //CH12.New.Strat
                                    if(getMPIDfromFuel)
                                        appointment.Gas_Market_Participant_ID__c = fuelLst[0].h_Gas_Supplier_MPID__c;
                                         
                                    //CH12.New.End
                                }
                                //Gas Data                            
                                //Calling J21 for MAM check
                                EON_MDS_ReqGasMAM.MAMValidationResponse wrpp = new EON_MDS_ReqGasMAM.MAMValidationResponse();
                                wrpp = EON_MDS_ReqGasMAM.ValidateMPRNMAM(MPRN);
                                if(!EON_Utility.validateRequired(EON_MDS_ReqGasMAM.cTrack)){ //CH16.New
                                    mTracker.add(EON_MDS_ReqGasMAM.cTrack);
                                }
                                
                                if (!wrpp.isError) {
                                system.debug('####wrpp.effFromDate: '+wrpp.effFromDate);
                                
                                    if (wrpp.effFromDate != null){ //&& wrpp.effToDate != null//CH05
                                        system.debug('####wrpp.effFromDate: '+wrpp.effFromDate);
                                        system.debug('####wrpp.effToDate: '+wrpp.effToDate);
                                        if ((appointment.Appointment_Date__c >= wrpp.effFromDate) && (wrpp.effToDate == null || appointment.Appointment_Date__c <= wrpp.effToDate)) { //CH05
                                            //If Appt Date decides whether MAM or Not
                                            //Calling J19 and get Gas data
                                            
                                            
                                            
                                            EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(MPRN, appointment, MDSTraId, EonTraId);
                                              //CH23
                                             if(getMPIDfromFuel){
                                             Map<String, EON_Model_ID_to_Model_Name_Mapping__c> allGasModels_A0083 = EON_Model_ID_to_Model_Name_Mapping__c.getAll();
                                             if(!allGasModels_A0083.isEmpty()){
                                                for(EON_Model_ID_to_Model_Name_Mapping__c  GasModel : allGasModels_A0083.values()){
                                                     if(fuelLst[0].Gas_model_A0083__c.equalsIgnoreCase(GasModel.Name)){
                                                    appointment.G_Meter_Model__c = GasModel.Model_Name__c; 
                                                    system.debug('%%%%%%%%Debug at line 479'+appointment.G_Meter_Model__c);
                                                    }
                                                }
                                            }
                                        }
                                        //CH23 
                                            
                                            if(!EON_Utility.validateRequired(EON_MDS_ReqGasMeterPointData.cTrack)){ //CH16.New
                                                mTracker.add(EON_MDS_ReqGasMeterPointData.cTrack);
                                            }
                                            if (!EON_MDS_ReqGasMeterPointData.isError) {
                                                appointment = EON_MDS_ReqGasMeterPointData.apptIns;
                                                appointment.G_Effective_From_Date__c = wrpp.effFromDate;
                                                appointment.G_Effective_To_Date__c = wrpp.effToDate;
                                                if(!EON_Utility.validateRequired(wrpp.abbrvtdName))//CH13
                                                    appointment.Gas_Market_Participant_ID__c = wrpp.abbrvtdName;//CH13
                                                //CH05.start
                                                if (appointment.Job_Code__c != null && jobLst != null && jobLst.size() > 0) {
                                                    if (jobLst[0].name.containsIgnoreCase('SMART')) //CH08
                                                        appointment.Planned_G_Meter_Type__c = 'MS1';
                                                } //CH05.end 
                                                if (String.isNotBlank(gMeterType)) //CH08
                                                    appointment.Planned_G_Meter_Type__c = gMeterType; //CH08
                                            } 
                                            else
                                                Error = Error + EON_MDS_ReqGasMeterPointData.Errors + '\n';
                                            //Call O.16 here || update appointment
                                            insertAppt = true; //CH05.new
                                        } 
                                        else if(jobLst[0].MAM_Reqd__c){Error = 'Rejected - MUS are not MAM for this MPRN on this date';}//CH15
                                        else
                                            NotMAM = true;
                                    }
                                } 
                                else{
                                    NotMAM = true;
                                }
                                if (NotMAM) {
                                    if (fuelLst != null && fuelLst.size() > 0) {
                                        appointment.Fuel_ID__c = fuelLst[0].id;
                                        appointment.MPRN__c = fuelLst[0].MPRN__c;
                                        appointment.G_Meter_Serial_Number__c = fuelLst[0].Gas_meter_serial_number__c;
                                        //appointment.G_Meter_Model__c = fuelLst[0].Gas_model_A0083__c; 
                                         //CH23
                                             if(getMPIDfromFuel){
                                             Map<String, EON_Model_ID_to_Model_Name_Mapping__c> allGasModels_A0083 = EON_Model_ID_to_Model_Name_Mapping__c.getAll();
                                             if(!allGasModels_A0083.isEmpty()){
                                                for(EON_Model_ID_to_Model_Name_Mapping__c  GasModel : allGasModels_A0083.values()){
                                                     if(fuelLst[0].Gas_model_A0083__c.equalsIgnoreCase(GasModel.Name)){
                                                    appointment.G_Meter_Model__c = GasModel.Model_Name__c; 
                                                    system.debug('%%%%%%%%Debug at line 501'+appointment.G_Meter_Model__c);
                                                    }
                                                }
                                            }
                                        }
                                        //CH23 
                                        
                                        appointment.G_Meter_Make__c = fuelLst[0].Gas_manufacturer_code_A0060__c;
                                        appointment.G_Meter_Measuring_Capacity__c = string.valueof(fuelLst[0].Gas_measuring_capacity_A0112__c);
                                        appointment.Number_of_Dials_or_Digits__c = fuelLst[0].Gas_number_of_dials_or_digits_A0121__c;
                                        appointment.G_Meter_Type__c = fuelLst[0].Gas_meter_type_A0025__c;
                                        appointment.G_Meter_Mechanism__c = fuelLst[0].Gas_Meter_Mechanism__c;
                                        appointment.Payment_Method_code__c = fuelLst[0].Gas_payment_method_A0163__c;
                                        appointment.Sub_Building_Name__c = fuelLst[0].Premise__r.Sub_Building_Name__c;
                                        appointment.Building_Name__c = fuelLst[0].Premise__r.Building_Name__c;
                                        appointment.Dependent_Thorofare__c = fuelLst[0].Premise__r.Dependant_Thorofare__c;
                                        appointment.Thorofare__c = fuelLst[0].Premise__r.Thorofare__c;
                                        appointment.Dependant_Locality__c = fuelLst[0].Premise__r.Dependant_Locality__c;
                                        appointment.Double_dependant_Locality__c = fuelLst[0].Premise__r.Double_Dependant_Locality__c;
                                        appointment.Post_Town__c = fuelLst[0].Premise__r.Town__c;
                                        appointment.Post_Code__c = fuelLst[0].Premise__r.Postcode__c;
                                        appointment.Person_Name__c = fuelLst[0].Premise__r.Customer__r.Customer_Name__c;
                                        //appointment.MPAN__c = fuelLst[0].MPAN__c;//CH10
                                        appointment.Supplier_Name__c = fuelLst[0].Gas_supplier_code__c;
                                        appointment.Gas_Map_Identifier__c = fuelLst[0].Gas_Map_Identifier__c;//CH17
                                        appointment.G_Meter_No_of_dials_digits__c = fuelLst[0].Gas_number_of_dials_or_digits_A0121__c;//CH18
                                        appointment.G_Meter_Year_of_Manufacture__c = fuelLst[0].Gas_year_of_manufacture_A0021__c;//CH19
                                        appointment.G_Meter_Units_of_Measure__c = fuelLst[0].h_Gas_units_of_measure_A0123__c;//CH21
                                        appointment.G_Meter_Multiplication_Factor__c = fuelLst[0].Gas_multiplication_factor_A0120__c;//CH19
                                        //CH07.START
                                        //appointment.Metering_Pressure__c = 'Low'; //CH28.old
                                        if (fuelLst[0].Gas_Meter_Mechanism__r.Code__c != null)
                                            appointment.Planned_G_Meter_Type__c = ((EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll() != null && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(fuelLst[0].Gas_Meter_Mechanism__r.Code__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(fuelLst[0].Gas_Meter_Mechanism__r.Code__c.toUpperCase()).Planned_Meter_Type__c : appointment.Planned_G_Meter_Type__c);
                                        if (appointment.Job_Code__c != null && jobLst != null && jobLst.size() > 0) {
                                            if (jobLst[0].name.containsIgnoreCase('SMART')) //CH08
                                                appointment.Planned_G_Meter_Type__c = 'MS1';
                                        }
                                        if (String.isNotBlank(gMeterType)) //CH08
                                            appointment.Planned_G_Meter_Type__c = gMeterType; //CH08
                                        system.debug('Planned_G_Meter_Type__c--->' + appointment.Planned_G_Meter_Type__c);
                                        //CH07.END
                                        //Call O.16 here || update appointment
                                        insertAppt = true;
                                    }
                                    //CH11.START
                                    else
                                        //CH25.Start
                                        if(varJobCode != 'OOAEINSTALLBIND'
                                          && varJobCode != 'OOASMARTDFINST') //CH26
                                        //CH25.end 
                                        Error = 'REJECT - Morrison does not have access to Gas details to be able to accept this request';
                                    //CH11.END
                                }
                            }
                            if (MPAN == '' && MPRN == '') {
                                //DoorKnocking Scenario for Future Development.
                            }
                        }
                        //CH05.start
                       System.debug('<<<<insertAppt>>>>'+insertAppt);
                        if (insertAppt) {
                            //CH06.start
                            list < EON_Appointment_Vulnerability__c > allEONVulnerabilityCode = new list < EON_Appointment_Vulnerability__c > (); //Ch14.New
                            if (eonVulnerabilityCode != null && eonVulnerabilityCode.size() > 0) {
                                //list < EON_Appointment_Vulnerability__c > allEONVulnerabilityCode = new list < EON_Appointment_Vulnerability__c > (); //CH14.Old
                                for (EON_Vulnerability_Code__c vul: eonVulnerabilityCode.values()) {
                                    EON_Appointment_Vulnerability__c appVul = new EON_Appointment_Vulnerability__c();
                                    appVul.Description__c = vul.id;
                                    //appVul.EON_Appointment_ID__c = appointment.id;
                                    appVul.VulnerabilityDetailCode__c = vul.Vulnerability_Code__c;
                                    allEONVulnerabilityCode.add(appVul);
                                }
                                //if (allEONVulnerabilityCode != null && allEONVulnerabilityCode.size() > 0) insert allEONVulnerabilityCode; //Ch14.Old
                            }
                            //CH06.end
                            //CH14.New.Start
                            appointment.Appointment_Key__c = EON_Utility.GenUniqueNum();
                            EON_OFSC_Create_Appointment_Wrapper apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appointment, allEONVulnerabilityCode, null);
                            //Call OFSC Create Activity API
                            String ofscResult = EON_OFSC_Create_Appointment.sendActivityToOFSC(apptWrapper, 'CREATE', '', '', string.valueof(appointment.Appointment_Date__c), appointment.Time_Slot__c, 'EON');
                            oTracker = EON_OFSC_Create_Appointment.oTracker;
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.reqToOFSC))
                                allOFSCAttachments.add(new Attachment(body = EON_OFSC_Create_Appointment.reqToOFSC, Name='Req'));
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.respFromOFSC))
                                allOFSCAttachments.add(new Attachment(body = EON_OFSC_Create_Appointment.respFromOFSC, Name='Resp'));
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.ofscAID))
                                appointment.h_aid__c = EON_OFSC_Create_Appointment.ofscAID;
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.ofscAID))
                                appointment.Duration__c = EON_OFSC_Create_Appointment.ofscDuration;
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.ofscSubArea))
                                appointment.SubArea__c = EON_OFSC_Create_Appointment.ofscSubArea;
                            //CH27.start
                            if(!EON_Utility.validateRequired(EON_OFSC_Create_Appointment.InstallSEDFlag))
                                appointment.Install_SED_flag__c= EON_OFSC_Create_Appointment.InstallSEDFlag; 
                            //CH27.end
                            if(EON_OFSC_Create_Appointment.hasError){  //Error
                                Error = ofscResult;
                            }
                            else{ //Success
                                appointment.Sent_to_Oracle__c = true;
                                if(allApptMeter != null && allApptMeter.size() > 1){ //CH22.New
                                    appointment.Multiple_Meters_at_Site__c = true;
                                }
                                insert appointment;
                                if(allEONVulnerabilityCode != null && allEONVulnerabilityCode.size() > 0){
                                    for(EON_Appointment_Vulnerability__c appVul: allEONVulnerabilityCode)
                                        appVul.EON_Appointment_ID__c = appointment.id;
                                    insert allEONVulnerabilityCode;
                                } 
                                if(allEONVulnerabilityCode != null && allEONVulnerabilityCode.size() > 0){
                                    for(EON_Appointment_Attribute__c att: lstApptAttr)
                                        att.EON_Appointment_ID__c = appointment.id;
                                    insert lstApptAttr;
                                }
                                 //CH22.Start
                                if(allApptMeter != null && allApptMeter.size() > 1){
                                    for(EON_Appointment_Meter__c apptMeter: allApptMeter)
                                        apptMeter.EON_Appointment__c = appointment.id;
                                    insert allApptMeter;
                                 }
                                //CH22.End
                                errMessage msg = new errMessage();
                                msg.MessageType = 'Information';
                                msg.MessageId = 0;
                                msg.MessageText = 'Request processed Successfully.';
                                msgLst.add(msg);
                                errorlst.Message = msgLst;
                                response.Messages = errorlst;
                                response.ReservationCreationDate = system.now();
                                response.ExternalAppointmentID = [select id, name from EON_Appointment__c where id = : appointment.id limit 1].Name;
                                response.EONAppointmentID = Reservation.AppointmentDetails.EONAppointmentID.trim();
                                response.header = Reservation.header;
                                response.header.orgId = system.label.EON_Sanbox_Name;
                                eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
                                eonTracker.Status__c = EON_Utility.RESULT_PASS;
                                eonTracker.Appointment__c = appointment.ID;
                                insert eonTracker;
                                oTracker = EON_OFSC_Create_Appointment.oTracker;
                                oTracker.EON_Appointment__c = appointment.ID;
                                oTracker.EON_Data_Tracker__c = eonTracker.ID;
                                oTracker.Transaction_ID__c = appointment.Id;
                                insert oTracker;
                                
                                //CH16.New
                                if(!mTracker.isEmpty()){
                                    for(MDS_Data_Tracker__c mData : mTracker){
                                        mData.EON_Appointment__c = appointment.ID;
                                        mData.EON_Data_Tracker__c = eonTracker.ID;
                                    }
                                }
                            }
                            //CH14.New.End
                        }
                        //CH05.end
                    }
                    if(Error != '') {
                        errMessage msg = new errMessage();
                        msg.MessageType = 'Exception';
                        msg.MessageId = 1;
                        if (Error.containsIgnoreCase('cannot be blank') || Error.containsIgnoreCase('REJECT')) //CH11
                            msg.MessageText = Error;
                        else
                            msg.MessageText = 'Appointment can\'t be created, Please contact your administrator.';
                        msgLst.add(msg);
                        errorlst.Message = msgLst;
                        response.Messages = errorlst;
                        response.header = Reservation.header;
                        response.header.orgId = system.label.EON_Sanbox_Name;
                        eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
                        eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                        eonTracker.Error__c = Error;
                        //insert eonTracker; CH24.OLD
                        upsert eonTracker; //CH24.NEW
                        if(!EON_Utility.validateRequired(oTracker.Status__c)){
                            oTracker.EON_Data_Tracker__c = eonTracker.Id;
                            oTracker.Isis_Error__c = Error;
                            //insert oTracker; CH24.OLD
                            upsert oTracker; //CH24.New                      
                        }
                        //CH16.New
                        if(!mTracker.isEmpty()){
                            for(MDS_Data_Tracker__c mData : mTracker){
                                mData.EON_Data_Tracker__c = eonTracker.ID;
                            }
                        }
                    }
                } 
                else{
                    Error = 'Request Not Found';
                    errMessage msg = new errMessage();
                    msg.MessageType = 'Exception';
                    msg.MessageId = 1;
                    msg.MessageText = 'Appointment can\'t be created, Please contact your administrator.';
                    msgLst.add(msg);
                    errorlst.Message = msgLst;
                    response.Messages = errorlst;
                    eonTracker.Request_Data__c = 'Blank Request';
                    eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
                    eonTracker.Status__c = EON_Utility.RESULT_FAIL;
                    eonTracker.Error__c = Error;
                }
            }
            //CH30.End
        }
        catch(Exception ex){
            System.debug('####Exception Occured ' + ex.getmessage() + '----' + ex.getStackTraceString());
            Error = ex.getmessage();
            errMessage msg = new errMessage();
            msg.MessageType = 'Exception';
            msg.MessageId = 1;
            msg.MessageText = 'Appointment can\'t be created, Please contact your administrator.';
            msgLst.add(msg);
            errorlst.Message = msgLst;
            response.Messages = errorlst;
            if(!EON_Utility.validateRequired(Reservation)){
                if(!EON_Utility.validateRequired(Reservation.header))
                    response.header = Reservation.header;
            }
            HeaderElement head = new HeaderElement();
            head.orgId = system.label.EON_Sanbox_Name;            
            response.header = head; //response.header.orgId = system.label.EON_Sanbox_Name;
            if(!EON_Utility.validateRequired(response))
                eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
            eonTracker.Status__c = EON_Utility.RESULT_FAIL;
            eonTracker.Error__c = Error;
            eonTracker.Request_Data__c = !EON_Utility.validateRequired(Reservation) ? String.valueOf(Reservation) : '';
            upsert eonTracker;
        }
        if(!EON_Utility.validateRequired(response))
            allEONAttachments.add(new Attachment(body = blob.valueOf(String.valueOf(response)), name='Resp'));
        if(!EON_Utility.validateRequired(Reservation))
            allEONAttachments.add(new Attachment(body = blob.valueOf(String.valueOf(Reservation)), name= 'Req'));
        if(!allOFSCAttachments.isEmpty() && !EON_Utility.validateRequired(oTracker.ID)){
            for(Attachment attach: allOFSCAttachments){
                attach.parentId = oTracker.ID;
                attach.name = attach.name + '_'+eonTracker.ID+'.txt';
            }
            insert allOFSCAttachments;
        }
        if(!allEONAttachments.isEmpty() && !EON_Utility.validateRequired(eonTracker.ID)){
            for(Attachment attach: allEONAttachments){
                attach.parentId = eonTracker.ID;
                attach.name = attach.name + '_'+eonTracker.ID+'.txt';
            }
            insert allEONAttachments;
        }
        //CH16.New
        if(!jTracker.isEmpty())
            insert jTracker;
        
        //CH30.Start
        if(!mTracker.isEmpty())
            insert mTracker;
        //CH30.End
        return response;
    }
}