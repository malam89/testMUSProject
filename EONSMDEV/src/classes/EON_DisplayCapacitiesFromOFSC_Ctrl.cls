/**
   Description: This is the controller for page EON_DisplayCapacitiesFromOFSC which will display the recommended capacities from OFSC and allow use to book slots
   Test Class: EON_DisplayCapacitiesFromOFSC_Ctrl_Test
**/
/*
    Created By : Sivasankar K
            On : 08/04/2016
            SR : SR_EON_AB_023
    Change History :
    CH01 #SR_EON_AB_068 #22/06/2016 #Puneet Mehta #Made changes for Capacity Override logic.
    CH02 #SR_EON_AB_090 #13/07/2016 #Puneet Mehta #To display Appointment detail in page message.
    CH03 #SR_EON_AB_106 #29/07/2016 #Puneet Mehta #Updating Confirmed Appointment DateTime field.
    CH04 #SR_EON_AB_155 #30/09/2016 #Puneet Mehta #On capacity override, check appointment date is valid against the Effective To and From Dates.
    CH05 #SR_EON_AB_171 #21/10/2016 #Puneet Mehta #On capacity override, send sla_window_start and sla_window_end to OFSC
    CH06 #SR_EON_AB_208 #09/03/2017 #Praveen G #Do not update Confirmed Appointment Date if it already exists on Appointment.
    CH07 #SR_EON_AB_217 #06/04/2017 #Mahadev J# Logic update for effective dates consideration for capacity
    CH08 #SR_OptiMUS_EON_238 #09/05/2018 #Mehboob Alam# Added logic updates to an existing appointment record for replan scenario.
    CH09 #SR_OptiMUS_EON_280 #24/10/2018 #Mehboob Alam# added Capacity Override reason
*/
public with sharing class EON_DisplayCapacitiesFromOFSC_Ctrl {
    public boolean mamReqd, mpanReqd, mopReqd, mprnReqd;//CH04
    //CH07
    public Date effectiveFrom{
        get;
        set;
    }
    public Date gEffectiveFrom{
        get;
        set;
    }
    //CH07
    public Date effectiveTo,gEffectiveTo;//CH04
    public static string apptStartTime,endTime;//CH05
    public static Date apptDate;//CH05
    //CH01.START
    public Decimal appDurationValue = 0.0;
    public static boolean specTimeFlag = false;
    /**
       Object instance of Eon_Appointment__c for date field
    **/
    public Eon_Appointment__c apptInstance{
        get;
        set;
    }
    //CH01.END
    /**
       String to store the response returned by OFSC hwen the slot is booked
    **/
    public String ofscResponse {
        get;
        set;
    }
    /**
       String to store oracle bucket ID retrirved from URL
    **/
    public String oracleBucketID {
        get {
            if (oracleBucketID == null)
                oracleBucketID = ApexPages.currentPage().getParameters().get('bucketID');
            return oracleBucketID;
        }
        set;
    }
    /**
       String to store the EON Job Record Id retrirved from URL
    **/
    public String jobCode {
        get {
            if (jobCode == null)
                jobCode = ApexPages.currentPage().getParameters().get('jobcode');
            return jobCode;
        }
        set;
    }

    /**
       String to store the EON Appointment Record Id retrirved from URL
    **/
    public String appointmentID {
        get {
            if (appointmentID == null)
                appointmentID = ApexPages.currentPage().getParameters().get('appID');
            return appointmentID;
        }
        set;
    }

    /*
        availableCapacities: This map will store the capacities retrieved from OFSC system for 56 days in ascending order
    */
    public Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> availableCapacities {
        get {
            if (availableCapacities == null) {
                availableCapacities = new Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> ();
            }
            return availableCapacities;
        }
        set;
    }

    /*
        recomendedTimeslot : List to store recommended time slots 
    */
    public List < EON_OFSC_Helper.RecomendedTimeSlots > recomendedTimeslot {
            get {
                if (recomendedTimeslot == null) {
                    recomendedTimeslot = new List < EON_OFSC_Helper.RecomendedTimeSlots > ();
                }
                return recomendedTimeslot;
            }
            set;
        }

    /**
        String to be passed to be passed to javascript on visualforce page
    **/
    public String recdtimeSlots {
        get {
            if (recdtimeSlots != '' && recdtimeSlots != null) {
                return recdtimeSlots;
            } else {
                return recdtimeSlots = '';
            }
        }
        set;
    }

    /**
        getCapacitiesFromOFSC(): This method will be automatically called on page load to fetch the slots available for booking
    **/
    public pageReference getCapacitiesFromOFSC() {
        recdtimeSlots = '[]'; // initialized as blank in case there is an error
        try {
            Map<String,Date> mapDates = new Map<String,Date>();
            availableCapacities = EON_Appointment_Booking_Ctrl_Helper.getCapacityFromOFSC(appointmentID, oracleBucketID, jobCode, mapDates);
            if (EON_Appointment_Booking_Ctrl_Helper.errorMessages == '') {recomendedTimeslot = EON_Appointment_Booking_Ctrl_Helper.recTimeSlots; recdtimeSlots = '['; for (EON_OFSC_Helper.RecomendedTimeSlots rec: recomendedTimeslot) {if (rec.dayVal != null){recdtimeSlots += ((recdtimeSlots.containsIgnoreCase('dateInst')) ? ',' : '') + '{dateInst:\'' + rec.dt.day() + '-' + rec.dt.month() + '-' + rec.dt.year() + '\',slotPeriod: \'' + rec.timeSlots + '\',slot: {id: ' + DateTime.newInstance(rec.dt, Time.newInstance(0, 0, 0, 0)).format('u') + ',weekDay: \'' + rec.dayVal + '\'}}';}} recdtimeSlots += ']';} else {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, EON_Appointment_Booking_Ctrl_Helper.errorMessages));}}catch(Exception ex) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));}
            if(EON_Appointment_Booking_Ctrl_Helper.appDuration != null){appDurationValue = EON_Appointment_Booking_Ctrl_Helper.appDuration;}//CH01
            //CH04.START
            if(EON_Appointment_Booking_Ctrl_Helper.mpanReqd != null){mpanReqd = EON_Appointment_Booking_Ctrl_Helper.mpanReqd;}
            if(EON_Appointment_Booking_Ctrl_Helper.mopReqd != null){mopReqd = EON_Appointment_Booking_Ctrl_Helper.mopReqd;}
            if(EON_Appointment_Booking_Ctrl_Helper.mamReqd != null){mamReqd = EON_Appointment_Booking_Ctrl_Helper.mamReqd;}
            if(EON_Appointment_Booking_Ctrl_Helper.mprnReqd != null){mprnReqd = EON_Appointment_Booking_Ctrl_Helper.mprnReqd;}
            if(EON_Appointment_Booking_Ctrl_Helper.lstAppointment != null && EON_Appointment_Booking_Ctrl_Helper.lstAppointment.size() > 0){
                if(EON_Appointment_Booking_Ctrl_Helper.lstAppointment[0].Effective_From_Date__c != null){effectiveFrom = EON_Appointment_Booking_Ctrl_Helper.lstAppointment[0].Effective_From_Date__c;}
                if(EON_Appointment_Booking_Ctrl_Helper.lstAppointment[0].Effective_To_Date__c != null){effectiveTo = EON_Appointment_Booking_Ctrl_Helper.lstAppointment[0].Effective_To_Date__c;}
                if(EON_Appointment_Booking_Ctrl_Helper.lstAppointment[0].G_Effective_From_Date__c != null){gEffectiveFrom = EON_Appointment_Booking_Ctrl_Helper.lstAppointment[0].G_Effective_From_Date__c;}
                if(EON_Appointment_Booking_Ctrl_Helper.lstAppointment[0].G_Effective_To_Date__c != null){gEffectiveTo = EON_Appointment_Booking_Ctrl_Helper.lstAppointment[0].G_Effective_To_Date__c;}
            }//CH04.END
        return null;
    }

    /**
        bookSlotsOFSC(): This method will be called from vf page when user has selected a slot to be booked 
    **/
    public pageReference bookSlotsOFSC() {
        String slotSelected = '';
        String dateSelected = '';
        String capacityOvrReason = '';//CH01
        String specificTimeFlag = '';//CH01
        Boolean checkValidaDate = true;//CH04
        
        try{
            if(System.currentPagereference().getParameters() != null){
                slotSelected = System.currentPagereference().getParameters().get('slotSelected');
                dateSelected = System.currentPagereference().getParameters().get('dateSelected');
                //CH01.START
                capacityOvrReason = System.currentPagereference().getParameters().get('capacityOvrReason');
                apptStartTime = System.currentPagereference().getParameters().get('apptStartTime');
                specificTimeFlag = System.currentPagereference().getParameters().get('specificTimeFlag');
                if(specificTimeFlag == 'true'){
                    specTimeFlag = true;
                }
                //CH01.END
                if (appointmentID == null)
                    appointmentID = ApexPages.currentPage().getParameters().get('appID');
                ofscResponse = '';
                String[] myDateOnly = dateSelected.split('-');
                Integer myDay = integer.valueOf(myDateOnly[0]);
                Integer myMonth = integer.valueOf(myDateOnly[1]);
                Integer myYear = integer.valueOf(myDateOnly[2]);
                //CH05.START
                apptDate = Date.newInstance(myYear, myMonth, myDay);
                if(specificTimeFlag == 'true'){
                    if(appDurationValue > 0 && apptStartTime != null && apptStartTime != ''){
                        integer hrs = integer.valueOf(appDurationValue) / 60;
                        integer mints = math.mod(integer.valueOf(appDurationValue) , 60);
                        String[] apptStartTimeStr = apptStartTime.split(':');
                        integer apptStartTimeIntHr = integer.valueOf(apptStartTimeStr[0]) + hrs;
                        integer apptStartTimeIntMin = integer.valueOf(apptStartTimeStr[1]) + mints;
                        hrs = (apptStartTimeIntMin) / 60;
                        mints = math.mod(apptStartTimeIntMin , 60);
                        apptStartTimeIntHr = apptStartTimeIntHr + hrs;
                        apptStartTimeIntMin = mints;
                        String apptStartTimeStrHr = String.valueof(apptStartTimeIntHr);
                        String apptStartTimeStrMin = String.valueof(apptStartTimeIntMin);
                        if(apptStartTimeIntHr < 10){apptStartTimeStrHr = '0' + apptStartTimeStrHr;}
                        if(apptStartTimeIntMin < 10){apptStartTimeStrMin = '0' + apptStartTimeStrMin;}
                        endTime = apptStartTimeStrHr + ':' + apptStartTimeStrMin;
                    }
                }
                //CH05.END
                
                //CH06.Start
                //Datetime confirmDate = [select Confirmed_Appointment_DateTime__c from Eon_Appointment__c where id =:appointmentID].Confirmed_Appointment_DateTime__c; //CH08.Old
                //CH06.end
                
                //CH08.Start
                List<Eon_Appointment__c> lstAppt= [select Confirmed_Appointment_DateTime__c,h_CanceldApptId__c from Eon_Appointment__c where id =:appointmentID];
                Datetime confirmDate = lstAppt[0].Confirmed_Appointment_DateTime__c;
                //CH08.End
                
                //CH01.START
                if(specificTimeFlag == 'true'){
                    //CH04
                    //For Electric Job
                    if(mpanReqd != null && mopReqd != null && mpanReqd && mopReqd){if(effectiveFrom != null && apptDate < effectiveFrom){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Appointment Date can not be before Effective From Date')); checkValidaDate = false;} if(effectiveTo != null && apptDate > effectiveTo){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Appointment Date can not be after Effective To Date')); checkValidaDate = false;}}
                    //For Gas Job
                    if(mamReqd != null && mprnReqd != null && mamReqd && mprnReqd){if(gEffectiveFrom != null && apptDate < gEffectiveFrom){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Appointment Date can not be before G Effective From Date')); checkValidaDate = false;} if(gEffectiveTo != null && apptDate > gEffectiveTo){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Appointment Date can not be after G Effective To Date')); checkValidaDate = false;}}
                    //CH04
                    if(checkValidaDate){//CH04
                        ofscResponse = EON_OFSC_Send_Appointment.sendActivityToOFSC(appointmentID, 'CREATE', '', '', myDateOnly[2]+'-'+myDateOnly[1]+'-'+myDateOnly[0]+' 00:00:00', slotSelected, 'MUS');
                        //CH02.START
                        if(ofscResponse != '' && ofscResponse.equals('Job sent to OFSC successfully')){Set<string> myIds = new Set<string>(); myIds.add(appointmentID); String nameofAppt = [select id, name from Eon_Appointment__c where id in: myIds][0].name; ofscResponse = ofscResponse + '<br></br>MUS Appointment ID: ' + nameofAppt + '<br></br>Appointment Date: '+ dateSelected +'<br></br>Appointment Time Slot: ' + slotSelected;}
                        //CH02.END
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ofscResponse));
                        EON_Appointment__c Appt = new EON_Appointment__c(id = appointmentID, Time_Slot__c = slotSelected, Appointment_Date__c = apptDate, Specific_Time_flag__c = true, Capacity_Override_reason__c = capacityOvrReason,Start_Time__c = apptStartTime,End_Time__c = endTime);
                                //CH06 commented this line - Confirmed_Appointment_DateTime__c = (String.isNotBlank(ofscResponse) && ofscResponse.containsIgnoreCase('OFSC successfully') ? system.now() : null ));//CH03
                        
                        //CH06.Start                        
                        Appt.Confirmed_Appointment_DateTime__c = (String.isNotBlank(ofscResponse) && ofscResponse.containsIgnoreCase('OFSC successfully') ? system.now() : confirmDate);
                        //CH06.end
                        
                        update Appt;
                        
                        //CH08.Start
                        if(!EON_Utility.validateRequired(lstAppt[0].h_CanceldApptId__c))
                            update new EON_Appointment__c(id = lstAppt[0].h_CanceldApptId__c,Replan__c = null,Rescheduled_Appointment__c=appointmentID);
                        //CH08.End 
                    }//CH04
                }
                //CH01.END
                else{
                    ofscResponse = EON_OFSC_Send_Appointment.sendActivityToOFSC(appointmentID, 'CREATE', '', '', myDateOnly[2]+'-'+myDateOnly[1]+'-'+myDateOnly[0]+' 00:00:00', slotSelected, 'MUS');
                    //CH02.START
                    if(ofscResponse != '' && ofscResponse.equals('Job sent to OFSC successfully')){Set<string> myIds = new Set<string>(); myIds.add(appointmentID); String nameofAppt = [select id, name from Eon_Appointment__c where id in: myIds][0].name; ofscResponse = ofscResponse + '<br></br>MUS Appointment ID: ' + nameofAppt + '<br></br>Appointment Date: '+ dateSelected +'<br></br>Appointment Time Slot: ' + slotSelected;}
                    //CH02.END
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ofscResponse));
                    EON_Appointment__c Appt = new EON_Appointment__c(id = appointmentID, Time_Slot__c = slotSelected, Appointment_Date__c = apptDate,Capacity_Override_reason__c = capacityOvrReason); //CH09
                        //CH06 commented this line -  Confirmed_Appointment_DateTime__c = (String.isNotBlank(ofscResponse) && ofscResponse.containsIgnoreCase('OFSC successfully') ? system.now() : null ));//CH03
                    Appt.Confirmed_Appointment_DateTime__c = (String.isNotBlank(ofscResponse) && ofscResponse.containsIgnoreCase('OFSC successfully') ? system.now() : confirmDate);
                    update Appt;
                    
                    //CH08.Start
                    if(!EON_Utility.validateRequired(lstAppt[0].h_CanceldApptId__c))
                       update new EON_Appointment__c(id = lstAppt[0].h_CanceldApptId__c,Replan__c = null,Rescheduled_Appointment__c=appointmentID);
                    //CH08.End   
                }
            }
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return null;
    }
    /**
        EON_DisplayCapacitiesFromOFSC_Ctrl() : Default constructor.
    **/
    public EON_DisplayCapacitiesFromOFSC_Ctrl() {
        mamReqd = mpanReqd = mopReqd = mprnReqd = false;//CH04
        apptStartTime = endTime = '';//CH05
    }
}