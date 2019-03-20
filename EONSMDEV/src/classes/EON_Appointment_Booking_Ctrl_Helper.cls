/**
    Description: This class will hold the methods which will be called from EON_Appointment_Booking_Ctrl class.
    Test Class  : EON_Appointment_Booking_Ctrl_Test,EON_DisplayCapacitiesFromOFSC_Ctrl_test,EON_OFSC_Helper_test
**/
/*
    Created By : Sivasankar K
    Created On : 19/03/2016
    Service Req: SR_EON_AB_012
    Change History :
    CH01 # SR_EON_AB_070 # 17/06/2016 # Aruna Manjari # Changed the error message generating.
    CH02 # SR_EON_AB_068 # 22/06/2016 # Puneet Mehta # Made duration public static
    CH03 # SR_EON_Jumbo_038 # 28/06/2016 # Sivasankar K # Adding fields to query.
    CH04 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
    CH05 # SR_EON_AB_132 # 02/09/2016 # Puneet Mehta # Calculated Travel Time and sent to OFSC to check availability accordingly.
    CH06 # SR_EON_AB_172 # 04/11/2016 # Aruna Manjari # Queried “Current Phase”
    CH07 #SR_EON_AB_217 #06/04/2017 #Mahadev J# Logic update for effective dates consideration for capacity
    CH08 # SR_OptiMUS_EON_071 # 08/06/2017 # Praveen G# add a filter for the capacity for the job code OOAEINSTALLBIND
    CH09 # SR_OptiMUS_EON_164 # 09/11/2017 # Praveen G # Passing post code value to Get Capacity call.
*/
global with sharing class EON_Appointment_Booking_Ctrl_Helper {
    public static Decimal appDuration = 0.0;//CH02

    public static Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> avaCapacities {
        get;
        set;
    }
    public static List < EON_OFSC_Helper.RecomendedTimeSlots > recTimeSlots {
        get;
        set;
    }
    public static List < EON_Appointment__c > lstAppointment {
        get;
        set;
    }
    public static String keyWorkSkill {
        get;
        set;
    }
    public static String errorMessages {
        get;
        set;
    }
    public static Boolean mamReqd {
        get;
        set;
    }
    public static Boolean mpanReqd {
        get;
        set;
    }
    public static Boolean mopReqd {
        get;
        set;
    }
    public static Boolean mprnReqd {
        get;
        set;
    }
    /**
        getCapacityFromOFSC(): This method will be called from EON_Appointment_Booking_Ctrl to retrieve available slots and date in required format.
    **/
    public static Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> getCapacityFromOFSC(String appointmentID, String oracleBucketID, String jobcodeID, Map < String, Date > mapDates) {
        errorMessages = '';
        String correctWorkSkill = '';
        Map < String, String > elecPhaseGasPressure = new Map < String, String > ();
        avaCapacities = new Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> ();
        recTimeSlots = new List < EON_OFSC_Helper.RecomendedTimeSlots > ();
        //Decimal appDuration = 0.0;//CH02
        Decimal jobDuration = 0.0;
        String jobCode = ''; //CH08
        try {
            //Query the Job codes to pass them in activities.
            List < EON_Job_Attribute__c > jobAttributes = new List < EON_Job_Attribute__c > (
                                [SELECT EON_Job__r.Name, Eon_Job__r.MAM_Reqd__c,Eon_Job__r.MOP_Reqd__c,Eon_Job__r.MPAN_Reqd__c,Eon_Job__r.MPRN_Reqd__c, ID, Duration__c, Eon_Job__r.Duration__c, Name, value__c FROM EON_Job_Attribute__c WHERE EON_Job__c = : jobcodeID]);
            for (EON_Job_Attribute__c job: jobAttributes) {
                
                jobCode = job.EON_Job__r.Name;//CH08
                
                jobDuration = ((job.Eon_Job__r.Duration__c != null) ? job.Eon_Job__r.Duration__c : 0);
                mamReqd = job.Eon_Job__r.MAM_Reqd__c;
                mpanReqd = job.Eon_Job__r.MPAN_Reqd__c;
                mopReqd = job.Eon_Job__r.MOP_Reqd__c;
                mprnReqd = job.Eon_Job__r.MPRN_Reqd__c;
                if (job.duration__c != null) {
                    appDuration += job.duration__c;
                }
            }
            if(jobAttributes.size() == 0){List<EON_Job__c> eonJobLst = new List<EON_Job__c>([select MAM_Reqd__c,MOP_Reqd__c,MPAN_Reqd__c,MPRN_Reqd__c,id, Duration__c from EON_Job__c where id = :jobcodeID]); if(eonJobLst != null && eonJobLst.size() > 0){jobDuration = eonJobLst[0].Duration__c; mamReqd = eonJobLst[0].MAM_Reqd__c; mpanReqd = eonJobLst[0].MPAN_Reqd__c; mopReqd = eonJobLst[0].MOP_Reqd__c; mprnReqd = eonJobLst[0].MPRN_Reqd__c;}}
            if (jobDuration != null) {
                appDuration = ((appDuration != null) ? appDuration + jobDuration : jobDuration);
            }
            //CH03 added Planned_E_Meter_Type__c,Planned_G_Meter_Type__c to query
            lstAppointment = new List < Eon_Appointment__c > ([SELECT  Current_Phase__c, 
                            Oracle_Postcode_Sector__c, //CH09
                            Effective_From_Date__c, Effective_To_Date__c, G_Effective_From_Date__c, G_Effective_To_Date__c,ID,MPAN__c,MPRN__c,Planned_E_Meter_Type__c,Planned_G_Meter_Type__c,Fuel_ID__c, Key_Collection_Required__c, Name, E_Meter_Type__c, E_Meter_Type__r.name, G_Meter_Type__c, G_Meter_Type__r.name, Number_of_Phases__c, Metering_Pressure__c FROM EON_Appointment__c WHERE ID =: appointmentID]);
            if (lstAppointment != null && lstAppointment.size() > 0) {
                //CH07.START
                if(lstAppointment[0].Effective_From_Date__c != null && (lstAppointment[0].G_Effective_From_Date__c == null || lstAppointment[0].Effective_From_Date__c < lstAppointment[0].G_Effective_From_Date__c))
                   mapDates.put('eff_From_Date',lstAppointment[0].Effective_From_Date__c);
                else if(lstAppointment[0].G_Effective_From_Date__c != null && (lstAppointment[0].Effective_From_Date__c == null || lstAppointment[0].G_Effective_From_Date__c < lstAppointment[0].Effective_From_Date__c))
                    mapDates.put('eff_From_Date',lstAppointment[0].G_Effective_From_Date__c);
                if(lstAppointment[0].Effective_To_Date__c != null && (lstAppointment[0].G_Effective_To_Date__c == null || lstAppointment[0].Effective_To_Date__c > lstAppointment[0].G_Effective_To_Date__c))
                    mapDates.put('eff_To_Date',lstAppointment[0].Effective_To_Date__c);
                else if(lstAppointment[0].G_Effective_To_Date__c != null && (lstAppointment[0].Effective_To_Date__c == null || lstAppointment[0].G_Effective_To_Date__c > lstAppointment[0].Effective_To_Date__c))
                    mapDates.put('eff_To_Date',lstAppointment[0].G_Effective_To_Date__c);
                //CH07.END
                appDuration += ((lstAppointment[0].Key_Collection_Required__c) ? 15 : 0);
               System.debug('lstAppointment = '+lstAppointment[0].Planned_E_Meter_Type__c+','+lstAppointment[0].Planned_G_Meter_Type__c+','+lstAppointment[0].Number_of_Phases__c+','+lstAppointment[0].Metering_Pressure__c ); 
               correctWorkSkill = EON_OFSC_Helper.getWorkSkill(lstAppointment[0]);
                if (correctWorkSkill != '' && !correctWorkSkill.containsIgnoreCase('Invalid')) {
                    if ( lstAppointment[0].Planned_E_Meter_Type__c != null ) { elecPhaseGasPressure.put('XA_ELEC_METER_TYPE', lstAppointment[0].Planned_E_Meter_Type__c); }
                    //elecPhaseGasPressure.put('XA_PHASE', lstAppointment[0].Number_of_Phases__c + 'PH'); CH04.OLD
                    if ( lstAppointment[0].Number_of_Phases__c != null ){elecPhaseGasPressure.put('XA_PHASE', (lstAppointment[0].Number_of_Phases__c).toUpperCase());}//CH04
                    if ( lstAppointment[0].Planned_G_Meter_Type__c != null ){ elecPhaseGasPressure.put('XA_GAS_METER_TYPE', lstAppointment[0].Planned_G_Meter_Type__c); }
                    if ( lstAppointment[0].Metering_Pressure__c != null ) { elecPhaseGasPressure.put('XA_PRESSURE', lstAppointment[0].Metering_Pressure__c); }
                    System.debug('Calling --> ');
                    //CH05
                    //Calculate Travel Time
                    Integer travelTime = Integer.valueOf(appDuration);
                    List<EON_Sub_Area__c> subAreaLst = new List<EON_Sub_Area__c>();
                    subAreaLst = [Select Id, Oracle_Bucket_ID__c, Region_Name__r.Travel_Time__c from EON_Sub_Area__c where Oracle_Bucket_ID__c=:oracleBucketID limit 1];
                    if(subAreaLst != null && subAreaLst.size() > 0 && subAreaLst[0].Region_Name__r.Travel_Time__c != null){travelTime = Integer.valueOf(subAreaLst[0].Region_Name__r.Travel_Time__c) + travelTime;}
                    
                    EON_OFSC_Helper.jobcodeOOAEINSTALLBIND = jobCode; //CH08
                    EON_OFSC_Helper.oraclePostCodeSector = lstAppointment[0].Oracle_Postcode_Sector__c; //CH09
                    
                    recTimeSlots = EON_OFSC_Helper.getCapacityFromOFSC(oracleBucketID, travelTime, elecPhaseGasPressure, jobAttributes, correctWorkSkill, mapDates);
                    //CH05
                    //recTimeSlots = EON_OFSC_Helper.getCapacityFromOFSC(oracleBucketID, Integer.valueOf(appDuration), elecPhaseGasPressure, jobAttributes, correctWorkSkill, mapDates);//CH05.OLD
                    System.debug('Calling -R-> ' + recTimeSlots); 
                    for (EON_OFSC_Helper.RecomendedTimeSlots rec: recTimeSlots) {if (avaCapacities == null || !avaCapacities.containsKey(rec.dt)) {avaCapacities.put(rec.dt, new List < EON_OFSC_Helper.RecomendedTimeSlots > {rec});} else if (avaCapacities != null || avaCapacities.containsKey(rec.dt)){avaCapacities.get(rec.dt).add(rec);}}
                } else {
                      errorMessages += 'Meter information could not be retrieved, please contact MUS back office.';//CH01
                    //CH01 errorMessages += 'No work skills found.';
                }
            } else {
                errorMessages += 'Invalid Appointment Booking Request'; } } catch (Exception ex) {throw ex;}
        return avaCapacities;
    }
}