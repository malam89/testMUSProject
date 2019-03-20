/**
    Description : This class will helps the system to return the Oracle Bucket ID.
    Test Class: EON_OFSC_Helper_test
**/
/*
    Created By : Nitin Bangar
    Created Date : 19-Mar-2016
    Service Request : SR_EON_AB_018
    Change History:
    CH01 # SR_EON_AB_028 # 31/03/2016 # Nitin Bangar # Amended logic for newly included parameter MPANValue, query new created field inthe SR.
    CH02 # SR_EON_AB_022 # 01/04/2016 # Nitin Bangar # Added one new method which checks the validity for OFSC.
    CH03 # SR_EON_AB_023 # 07/04/2016 # Sivasankar K # Added the getCapcity methods and it related methods.
    CH04 # SR_EON_AB_022 # 15/04/2016 # Mahadev J # Amended logic at checkValidityForOFSC method to validate MOM and MAM. And added new method getWorkSkillForEon
    CH05 # SR_EON_Scheduling_006 & SR_EON_Scheduling_007 # 27/04/2016 # 27/04/2016 # Dharmendra P # Added method to get userelement for Inbound API.
    CH06 # SR_EON_AB_060 # 12/05/2016 # Nitin # Added logic if all four fields are unchecked to Reject the JobCode.
    CH07 # SR_EON_Mobile_009 # 16/04/2016 # Mahadev # Added logic to get user element for OFSC
    CH08 # SR_EON_AB_070 # 17/06/2016 # Aruna Manjari # Changed the Logic for identifying the  "Work Skill" for filtering the capacities coming from OFSC.Commented out the old logic and added a new logic
    CH09 # SR_EON_AB_071 # 23/06/2016 # Dharmendra P # Added new method for EON Appointment validations.
    CH10 # SR_EON_Jumbo_038 # 28/06/2016 # Sivasankar K # Changing the work skill logic with different fields for identifying the workskill.
    CH11 # SR_EON_AB_084 # 07/07/2016 # Dharmendra P # Added Validations.
    CH12 # SR_EON_AB_083 # 07/07/2016 # Akshay B # Changed logic for bucketID.
    CH13 # SR_EON_AB_086 # 19-07-2016 # Praveen G # Amendeing the work skill logic when Fuel record is not available.
    CH14 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
    CH15 # SR_EON_AB_083 # 28-07-2016 # Sivasankar K # Amending logic for validating the values
    CH16 # SR_EON_AB_115 # 16/08/2016 # Sivasankar K # Added the condition for skyping the Job Not Fully Supported error When booking from ABS.
    CH17 # SR_EON_AB_125 # 23/08/2016 # Sivasankar K # Added two fields mapping to the mapAppointmentFromFuelSite
    CH18 # JIRA-2218 # 24/08/2016 # Mahadev # Update function getCapacityFromOFSC() and addIndustryActivities() for Workskill and Job Attribute mapping as per SR_Isis_EON_013
    CH19 # SR_EON_AB_132 # 02/09/2016 # Puneet Mehta # Comparing workskill capacity with first row to take other activities under consideration
    CH20 # JIRA-2234 # 24/08/2016 # Mahadev # Oracle Tracker not logging response.
    CH21 # SR_EON_Jumbo_062 # 05/09/2016 # Mahadev J # Update mapping for Effective Dates for Gas
    CH22 # SR_EON_AB_147 # 21/09/2016 # Sivasankar # Amending the PAYG section validations.
    CH23 # SR_EON_AB_161 # 05/10/2016 # Puneet Mehta #  Mapped new field from EON Fuel: h_Gas_Supplier_MPID to EON Appointment: Gas Market Participant ID
    CH24 # SR_EON_AB_172 # 04/11/2016 # Aruna Manjari # On a Get Capacity call from EON, if “Current Phase” exists and it is 3PH then use that to determine skillset, else use “Number of phases” to determine Oracle skillset
    CH25 # SR_EON_Scheduling_050 # 29/11/2016 # Praveen G # Added new method for header element for OFSC MIDOS
    CH26 # SR_EON_Jumbo_091 # 14/12/2016 # Puneet Mehta # Mapped new field from EON Fuel 'Gas Map Identifier'
    CH27 # SR_EON_Jumbo_093 # 16/12/2016 # Nitin bangar # Mapped new field from EON Fuel 'Gas number of dials or digits (A0121)'
    CH28 # SR_EON_Jumbo_096 # 12/01/2017 # Puneet Mehta # Mapped new field from EON Fuel
    CH29 # SR_EON_AB_198 # 18/01/2017 # Mahadev Joshilkar # Amended logic to skip non-numeric time-slots.
    CH30 # SR_OptiMUS_EON_033 # 27/01/2017 # Mahadev J # Override Job Type with type - Maintenance
    CH31 # SR_EON_Jumbo_107 # 20/02/2017 # Puneet Mehta # Mapped new field from EON Fuel
    CH32 # SR_EON_Jumbo_110 # 05/04/2017 #Aruna Manjari # Mapping of appointment 'G Meter Model' field from custom setting. 
    CH33 # SR_OptiMUS_EON_071 # 08/06/2017 # Praveen G# add a filter for the capacity for the job code OOAEINSTALLBIND 
    CH34 # SR_OptiMUS_EON_090 # 11/08/2017 # Praveen G# Get capacity changes for new job code OOAACCUCHECKELEC
    CH34 # SR_OptiMUS_EON_150 # 06/10/2017 # Praveen G# Updated the mapping
    CH35 # SR_OptiMUS_EON_164 # 09/11/2017 # Praveen G# Added new property to Get Capacity Call.
    CH36 # SR_OptiMUS_EON_174 # 30/10/2017 # Mehboob Alam # Calculating workSkill as per Current Phase. 
    CH37 # SR_OptiMUS_EON_209 # 07/02/2017 # Mehboob Alam# add a filter for the capacity for the job code OOASMARTDFINST       
    CH38 # SR_OptiMUS_EON_234 # 15/03/2018 # Praveen G # added today's for the getcapacity results.
    CH39 # SR_OptiMUS_EON_245 # 23/04/2018 # Mehboob Alam # Show timeslots where timeslot END TIME is greater than time of cureent hour.
	CH40 # SR_OptiMUS_EON_297 # 05/02/2019 # Tabish Almas # Added logic to get data from MDS or Jumbo based on MDS Jumbo Dataflow Switch
*/

global with sharing class EON_OFSC_Helper{
    //CH04.New.Start
    public static list<Oracle_Data_Tracker__c> oracleDataTrackers;
    public static list<JUMBO_Data_Tracker__c> jumboDataTrackers;
    public static list<MDS_Data_Tracker__c> MDSDataTrackers;	//CH40
    public static EON_Appointment__c eonAppointment;
    public static boolean overrideJobType = false; //CH30.New
    
    public static String jobCodeOOAEINSTALLBIND = ''; //CH33
    public static String oraclePostCodeSector = ''; //CH35
    public static String EONAppReason = ''; //CH38
    
    //CH04.New.End
    /**
        getOracleBucketId(): This method will search the Oracle bucket ID in EON Sub Area object.
    **/
    public static String getOracleBucketId(String jobCode, String jobType, String postCode, String MPANValue)   //CH01
    {
        String orcBucketId ='',jobTypeCondition='',conPostCode = '', MPANval ='',queryPostCode='';   //CH01 
        String[] postCodeVal;
        try{    
            List<EON_Job__c> lstjob;
            List<EON_Post_Code__c> lstpostCode;
            if(EON_OFSC_Helper_test.genException == null)
                EON_OFSC_Helper_test.genException = false;
            if(EON_OFSC_Helper_test.genException)
                ID test = ID.valueof('IncorrectID'); //generate exception
            if(jobType != '' && jobType != null)                
                lstjob = new List<EON_Job__c>([Select Id ,Name ,Job_Type__c from EON_Job__c where Name=: jobCode and Job_Type__c=: jobType]);            
            JobType = overrideJobType ? 'Maintenance' : JobType; //CH30.New
            if(JobType != '' && JobType != null)//this will prepare the condition string.
                jobTypeCondition = (( postCode != '' && postCode != null ) ? ((JobType.equalsIgnoreCase('Smart')) ? 'AND Sub_Area_Name__r.Smart__c ':((JobType.equalsIgnoreCase('ECO')) ? 'AND Sub_Area_Name__r.ECO__c' : ((JobType.equalsIgnoreCase('Maintenance')) ? 'AND Sub_Area_Name__r.Maintenance__c': ((JobType.equalsIgnoreCase('New Connections')) ? 'AND Sub_Area_Name__r.New_Connections__c':'')))) : '');  
            
                //Break the parameter postCode with all the characters before space in concatenation with next 1 character after space.  
                if(postCode != '' && postCode != null){
                    postCodeVal = postCode.split(' ');
                    if(postCodeVal != null && postCodeVal.size() == 2)
                        conPostCode = postCodeVal[0] + ' ' + postCodeVal[1].subString(0,1);    
                    
                    queryPostCode = 'Select Id, Name, Subarea_PostCode__c, Sub_Area_Name__c, Sub_Area_Name__r.ECO__c,'+ 
                    'Sub_Area_Name__r.Maintenance__c, Sub_Area_Name__r.New_Connections__c, Sub_Area_Name__r.Smart__c,'+
                    'Sub_Area_Name__r.Oracle_Bucket_ID__c, Sub_Area_Name__r.Region_Name__r.GSP_ID__c from EON_Post_Code__c Where Name = \''+ conPostCode +'\' ';
                
                    //Adding another condition in the dynamic query to get the records based on the value of jobTypeCondition                
                    queryPostCode +=  ((jobTypeCondition !='' )? String.ValueOf(jobTypeCondition) + ' = True' :'');
                    
                    if(jobTypeCondition != '')                
                        lstpostCode = Database.query(queryPostCode);
                    //CH01.Start
                    if(lstpostCode != null && lstpostCode.size() == 1){
                        orcBucketId = lstpostCode[0].Sub_Area_Name__r.Oracle_Bucket_ID__c;  
                    }
                    else if( orcBucketId == '' || (postCodeVal != null && postCodeVal.size() != 2) || (lstJob == null && lstJob.size() == 0) || (lstpostCode != null && lstpostCode.size()>1) ||  (lstpostCode == null && lstpostCode.size()==0) )
                        return 'REJECTED Post Code and Job Type could not be found in OOA';
                } 
        } catch( Exception e ){ system.debug('the e.getMessage() is'+e.getMessage() + 'at line no ==>' + e.getStackTraceString());}              
        return orcBucketId;  
    }
    
    //CH02.Start
    /**
        checkValidityForOFSC(): This method will validates the job code and job attributes. 
    **/
    public static String checkValidityForOFSC(String jobCode, List<EON_Job_Attribute__c> jobAttParam, String MPAN, String MPRN ,String Postcode)
    {
        oracleDataTrackers = new list<Oracle_Data_Tracker__c>();
        Integer matchCount = 0;
        Boolean allMatch = False;
        Boolean sizeZero = False;
        String oracle ='',MPANval ='';//CH15 added MPANval =''
        eonAppointment = new EON_Appointment__c();
        String switchData = EON_MDS_Utility.getMDS_Jumbo_Status();	//CH40
        try{  
            //Check Job Validated
            List<EON_Job__c> lstjob;            
            
            if(jobCode != '' && jobCode != null)                
                lstjob = new List<EON_Job__c>([Select Id ,Name ,Job_Type__c,MPAN_Reqd__c,MPRN_Reqd__c,MOP_Reqd__c,MAM_Reqd__c,(SELECT Id , Name ,Value__c from EON_Job_Attributes__r) from EON_Job__c where Name=: jobCode LIMIT 1]);  //CH04.Change - Added fields MOP_Reqd__c and MAM_Reqd__c
            
            if(lstjob == null || lstjob.size() != 1)
                return 'REJECTED Job code does not match active job code list.';
                
            //CH06.Start 
            //CH16 Adding the condition to verify that the Appointment is booking from Industry search appointment booking.   String.isBlank(EON_Utility.appointment_Booking_From) 
            if(String.isBlank(EON_Utility.appointment_Booking_From) && lstjob != null && lstJob.size() == 1 && ( lstjob[0].MOP_Reqd__c == false && lstjob[0].MAM_Reqd__c == false && lstjob[0].MPAN_Reqd__c == false && lstjob[0].MPRN_Reqd__c == false))
                return 'REJECTED Jobcode not fully support, Contact Morrison Utility Services for more information';
            //CH06.End
            
            //Check Validated Job Attribitues
            List<EON_Job_Attribute__c>  lstJobAttr = new List<EON_Job_Attribute__c>();
            if(lstjob != null && lstJob.size() == 1)
                if(lstjob[0].EON_Job_Attributes__r.size() != 0)
                    lstJobAttr = lstjob[0].EON_Job_Attributes__r;
            
            //if(lstJobAttr != null && (jobAttParam != null && jobAttParam.size() > 0) && (lstJobAttr.size() >= jobAttParam.size())){
            for(EON_Job_Attribute__c jobAt : jobAttParam)
                for(EON_Job_Attribute__c jobAtt : lstJobAttr)
                    if(jobAt.Name == jobAtt.Name && jobAt.Value__c == jobAtt.Value__c)
                        matchCount=matchCount+1;
            System.debug('matchCount '+matchCount+' , jobAttParam = '+jobAttParam.size()); 
            if(matchCount == jobAttParam.size())
                allMatch = true;
            
            if((lstjob[0].EON_Job_Attributes__r == null || lstjob[0].EON_Job_Attributes__r.size() == 0) && (jobAttParam == null || jobAttParam.size() == 0)) sizeZero = true;
            
            if(!allMatch && !sizeZero) return 'REJECTED Job attributes does not match active job attribute list.';
            
            system.debug('%% Value of MPAN' + MPAN);
            
            system.debug('%% Value of MPRN' + MPRN);
            
            //Check Validated MPAN/MPRN
            if(lstjob[0].MPAN_Reqd__c == true)
                if(MPAN == '' || MPAN == null)
                    return 'REJECTED MPAN expected or MPRN expected or Both if dual fuel Job';
                    
                    
            if(lstjob[0].MPRN_Reqd__c == true)
                if(MPRN == '' || MPRN == null)
                    return 'REJECTED MPAN expected or MPRN expected or Both if dual fuel Job';
                   
            //CH15.Start
            if(MPAN != '' && MPAN != null && MPAN.length() > 1)
                MPANval = MPAN.substring(0, 2);
            if(MPANval != ''){
                String queryPostCode = 'SELECT Id, GSP_ID__c FROM EON_Region__c WHERE GSP_ID__c = '+MPANval+' ';
                system.debug('---->'+queryPostCode);
                List<EON_Region__c> lstRegion = Database.query(queryPostCode);
                if (!( lstRegion != null && lstRegion.size()>0))
                    return 'REJECTED Not in OOA based on MPAN GSP ID'; 
            }
            //CH15.End          
            // Validate Oracle Bucket ID
            //CH15.Checking the functionality of Post code
            if (Postcode != null && Postcode != '')
                oracle = EON_OFSC_Helper.getOracleBucketId(jobCode, lstjob[0].Job_Type__c, Postcode, MPAN);
            //CH12.Start
            if(oracle != '' && oracle.containsIgnoreCase('REJECTED Not in OOA based on MPAN GSP ID')) return 'REJECTED Not in OOA based on MPAN GSP ID'; 
            else if(oracle != '' && oracle.containsIgnoreCase('Reject')) return 'REJECTED Post Code and Job Type could not be found in OOA'; 
            //CH12.End
            //CH04.Start
            jumboDataTrackers = new list<JUMBO_Data_Tracker__c>();
            //CH40.Start
            MDSDataTrackers = new list<MDS_Data_Tracker__c>();
            if(switchData == system.label.Jumbo_Shortform) {
                //Validate MOP - Call to Jumbo function J.20
                if(lstjob[0].MOP_Reqd__c == true){
                    if(MPAN!=null && MPAN!=''){
                        EON_Jumbo_ReqElectricityMOP.MOPValidationResponse result = new EON_Jumbo_ReqElectricityMOP.MOPValidationResponse();
                        result = EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP(MPAN);
                        if(result != null){
                            if(EON_Jumbo_ReqElectricityMOP.cTrack != null)
                                jumboDataTrackers.add(EON_Jumbo_ReqElectricityMOP.cTrack);
                            if(result.isError == false){
                                if(!EON_Utility.validateRequired(result.marParticipantId)){
                                    if(result.effFromDate != null)
                                        eonAppointment.Effective_From_Date__c = result.effFromDate;
                                    if(result.effToDate != null)
                                        eonAppointment.Effective_To_Date__c = result.effToDate;
                                }
                            } 
                            else
                                return 'REJECTED - '+result.Error;
                        } 
                    }                               
                }
            
                //Validate MAM - Call to Jumbo function J.21
                if(lstjob[0].MAM_Reqd__c == true){
                    if(MPRN!=null && MPRN!=''){
                        EON_Jumbo_ReqGasMAM.MAMValidationResponse result = new EON_Jumbo_ReqGasMAM.MAMValidationResponse();
                        result = EON_Jumbo_ReqGasMAM.ValidateMPRNMAM(MPRN);
                        System.debug('@#result = '+result);
                        if(result != null){
                            if(EON_Jumbo_ReqGasMAM.cTrack != null)
                                jumboDataTrackers.add(EON_Jumbo_ReqGasMAM.cTrack);
                            if(result.isError == false){
                                if(!EON_Utility.validateRequired(result.abbrvtdName)){
                                    if(result.effFromDate != null)
                                        eonAppointment.G_Effective_From_Date__c = result.effFromDate; //CH21.New
                                    if(result.effToDate != null)
                                      eonAppointment.G_Effective_To_Date__c = result.effToDate; //CH21.New
                                }
                            }
                            else
                                return 'REJECTED - '+result.Error;
                        }
                    }
                }
            }
            else if(switchData == system.label.MDS_Shortform) {
                //Validate MOP - Call to MDS function J.20
                if(lstjob[0].MOP_Reqd__c == true){
                    if(MPAN!=null && MPAN!=''){
                        EON_MDS_ReqElectricityMOP.MOPValidationResponse result = new EON_MDS_ReqElectricityMOP.MOPValidationResponse();
                        result = EON_MDS_ReqElectricityMOP.ValidateMPANMOP(MPAN);
                        if(result != null){
                            if(EON_MDS_ReqElectricityMOP.cTrack != null)
                                MDSDataTrackers.add(EON_MDS_ReqElectricityMOP.cTrack);
                            if(result.isError == false){
                                if(!EON_Utility.validateRequired(result.marParticipantId)){
                                    if(result.effFromDate != null)
                                        eonAppointment.Effective_From_Date__c = result.effFromDate;
                                    if(result.effToDate != null)
                                        eonAppointment.Effective_To_Date__c = result.effToDate;
                                }
                            } 
                            else
                                return 'REJECTED - '+result.Error;
                        } 
                    }                               
                }
            
                //Validate MAM - Call to MDS function J.21
                if(lstjob[0].MAM_Reqd__c == true){
                    if(MPRN!=null && MPRN!=''){
                        EON_MDS_ReqGasMAM.MAMValidationResponse result = new EON_MDS_ReqGasMAM.MAMValidationResponse();
                        result = EON_MDS_ReqGasMAM.ValidateMPRNMAM(MPRN);
                        System.debug('@#result = '+result);
                        if(result != null){
                            if(EON_MDS_ReqGasMAM.cTrack != null)
                                MDSDataTrackers.add(EON_MDS_ReqGasMAM.cTrack);
                            if(result.isError == false){
                                if(!EON_Utility.validateRequired(result.abbrvtdName)){
                                    if(result.effFromDate != null)
                                        eonAppointment.G_Effective_From_Date__c = result.effFromDate; //CH21.New
                                    if(result.effToDate != null)
                                      eonAppointment.G_Effective_To_Date__c = result.effToDate; //CH21.New
                                }
                            }
                            else
                                return 'REJECTED - '+result.Error;
                        }
                    }
                }
            }
            //CH40.End
            //CH04.End
        } 
        catch(Exception e){
            system.debug('the e.getMessage() is'+e.getMessage() + 'at line no ==>' + e.getStackTraceString()); 
            return 'REJECTED - '+e.getMessage();
        } 
        return oracle; 
    }
    //CH02.End
    //CH03.Start
    /*
        RecomendedTimeSlots: This class represents the recomended Time slots to the user.
    */
    public class RecomendedTimeSlots {
        public Date dt {get;set;}
        public String dayVal {get;set;}
        public String timeFormat {get;set;}
        public String timeSlots {get;set;}
        public String workSkill {get;set;}
        public Long quota {get;set;}
        public Long availability {get;set;}
        public Long activity_duration {get;set;}
        public Long activity_travel_time {get;set;}
    }
    
    /**
        getCapacityFromOFSC(): this method will call from Appointment booking controller and returns the data in the format of Date and available time slots along with workskill.
    **/
    public static List<EON_OFSC_Helper.RecomendedTimeSlots> getCapacityFromOFSC( String oracleBucketID, Integer duration, Map<String,String> elecPhaseGasPressure, List <EON_Job_Attribute__c>  jobAttributes, String workSkill, Map<String,Date> mapDates ) 
    {
        List<EON_OFSC_Helper.RecomendedTimeSlots> recTimeSlots = new List<EON_OFSC_Helper.RecomendedTimeSlots>();
        String apptID = ((EON_Appointment_Booking_Ctrl_Helper.lstAppointment != null && EON_Appointment_Booking_Ctrl_Helper.lstAppointment.size() > 0) ? EON_Appointment_Booking_Ctrl_Helper.lstAppointment[0].id:null);
        Date eff_From_Date = (( mapDates != null && mapDates.containsKey('eff_From_Date')) ? mapDates.get('eff_From_Date') : null );
        Date eff_To_Date = (( mapDates != null && mapDates.containsKey('eff_To_Date')) ? mapDates.get('eff_To_Date') : null );
        
        oracleDataTrackers = new list<Oracle_Data_Tracker__c>();
        Integer taskDuration = duration; 
        Date previousDate = null; // this will store the previous date value
        //List<Oracle_Data_Tracker__c> lstOracleDataTracker = new List<Oracle_Data_Tracker__c>();
        Oracle_Data_Tracker__c outGoingOracleTracker = new Oracle_Data_Tracker__c(Command__c=EON_Utility.CMD_EON_GetCapacity, Direction__c=EON_Utility.DIRECTION_OUT, Error_Code__c=null, Request_Data__c=null, Response_Data__c=null, Status__c=EON_Utility.RESULT_PASS, Transaction_ID__c=null, EON_Appointment__c=apptID);
        try{
            //Get the User Element details.
            EON_OFSC_GetCapacity_WS.User_Element userElement = getUserElement();   
            
            //Add the activities to the list
            List<EON_OFSC_GetCapacity_WS.activity_field_element> lstActivityElement = addIndustryActivities(elecPhaseGasPressure);
                    
            //prepare the Dates list for 56 days for getting the capacity from OFSC
            List<Date> lstRequestDates = new List<Date>();
            System.debug('eff_From_Date = '+eff_From_Date+', eff_To_Date = '+eff_To_Date);
            
            //CH38.Start
            integer startNumber = 1;
            if(EONAppReason == 'NEW_CONN')
                startNumber = 0;
            //CH38.End
            
            for(integer i=startNumber ; i<56 ; i++){
                if(eff_From_Date != null && eff_To_Date != null && eff_From_Date <= (Date.today()+i)  && eff_To_Date >= (Date.today()+i))
                    lstRequestDates.add(Date.today()+i);
                else if(eff_From_Date != null && eff_To_Date == null && eff_From_Date <= (Date.today()+i))
                    lstRequestDates.add(Date.today()+i);
                else if(eff_From_Date == null && eff_To_Date != null && eff_To_Date >= (Date.today()+i) )
                    lstRequestDates.add(Date.today()+i);
                else if(eff_From_Date == null && eff_To_Date == null)
                    lstRequestDates.add(Date.today()+i);
            }
            //Request Workskills
            List<String> lstWorkSkills = new List<String>();
                
            //CH33.Start
            if(jobcodeOOAEINSTALLBIND == 'OOAEINSTALLBIND' || jobcodeOOAEINSTALLBIND == 'OOASMARTDFINST')//CH37
                workSkill = 'DF2';    
            //CH33.End
            
            //CH34.Start
            if(jobcodeOOAEINSTALLBIND == 'OOAACCUCHECKELEC'){
                if(elecPhaseGasPressure.get('XA_ELEC_METER_TYPE') != null && 
                                elecPhaseGasPressure.get('XA_PHASE') != null){
                    //Map<String, String> mapOOAACCUCHECKELECTypePhase = getOOAACCUCHECKELECTypePhase();                                
                    workSkill = getOOAACCUCHECKELECTypePhase().get(
                                                        elecPhaseGasPressure.get('XA_ELEC_METER_TYPE').toUpperCase()+
                                                        elecPhaseGasPressure.get('XA_PHASE'));       
                }
                                        
            }
            //CH34.End
            
            
            lstWorkSkills.add(workSkill); //CH18.New
            
            //add the Oracle bucket ID to the location
            List<String> lstLocation = new List<String>();
            lstLocation.add(oracleBucketID);
            
            //Request Timeslots                 
            List<String> lstTimeslots = new List<String>(); 
            System.debug(' lstRequestDates= '+lstRequestDates);
            System.debug(' lstTimeslots= '+lstTimeslots);
            System.debug('lstWorkSkills = '+lstWorkSkills);
            System.debug('lstActivityElement = '+lstActivityElement);
            System.debug('lstLocation = '+lstLocation);
            
            //populate the data in Oracle request tracker
            outGoingOracleTracker.Request_Data__c = 'Request Data : '+userElement+lstRequestDates+lstLocation+lstTimeslots+lstWorkSkills+lstActivityElement;
            
            outGoingOracleTracker.Request_Data__c = (( outGoingOracleTracker.Request_Data__c.length() <= 131072 ) ? outGoingOracleTracker.Request_Data__c :  outGoingOracleTracker.Request_Data__c.subString(0,131070));
            //Actual Request
            EON_OFSC_GetCapacity_WS.toa_capacity_interface request = new EON_OFSC_GetCapacity_WS.toa_capacity_interface();
            EON_OFSC_GetCapacity_WS.capacity_response_element response =  request.get_capacity(userElement, lstRequestDates, lstLocation, null, null, null, null, true, null, 
                                                            2, //CH35
                                                            taskDuration, lstTimeslots, lstWorkSkills, lstActivityElement);
            System.debug('****Response ' + response);            
            if(!EON_Utility.validateRequired(response.capacity) && !response.capacity.isEmpty()){
                EON_OFSC_Helper.RecomendedTimeSlots recTS ; //to store the correct work skill capacity
                EON_OFSC_Helper.RecomendedTimeSlots recTSGA ; // to store the GA work skill capacity
                map<Date, EON_OFSC_Helper.RecomendedTimeSlots> mapGaWorkSkill = new map<Date, EON_OFSC_Helper.RecomendedTimeSlots>();
                map<String, EON_OFSC_Helper.RecomendedTimeSlots> mapNoWorkSkill = new map<String, EON_OFSC_Helper.RecomendedTimeSlots>();//CH19
                Set<string> duplicateDateSlot = new Set<string>();
                //Collect All GA Capacities
                for(EON_OFSC_GetCapacity_WS.capacity_element capacityElement : response.capacity){
                    if(isValidTimeSlot(capacityElement.time_slot)){ //CH29.New
                        if(capacityElement.work_skill == null && capacityElement.time_slot != null)//CH19
                            mapNoWorkSkill.put(capacityElement.date_x+''+capacityElement.time_slot,populateCapacityElement(capacityElement));//CH19
                        if(capacityElement.available > 0 && capacityElement.date_x >= Date.today() && !EON_Utility.validateRequired(capacityElement.work_skill)){
                            if(capacityElement.work_skill.equalsIgnoreCase('GA'))
                                mapGaWorkSkill.put(capacityElement.date_x, populateCapacityElement(capacityElement));
                        }
                    }
                }
                //Calculate capacities to return
                for(EON_OFSC_GetCapacity_WS.capacity_element capacityElement : response.capacity){
                    //system.debug('###CapacityEle: '+capacityElement);
                    //CH19
                    Boolean  flag = null;
                    if(isValidTimeSlot(capacityElement.time_slot)){ //CH29.New
                        if(mapNoWorkSkill != null && mapNoWorkSkill.size() > 0 && mapNoWorkSkill.containsKey(capacityElement.date_x+''+capacityElement.time_slot) && mapNoWorkSkill.get(capacityElement.date_x+''+capacityElement.time_slot) != null){
                            EON_OFSC_Helper.RecomendedTimeSlots noCapacity = mapNoWorkSkill.get(capacityElement.date_x+''+capacityElement.time_slot);
                            if(!EON_Utility.validateRequired(noCapacity)){
                                if(!EON_Utility.validateRequired(capacityElement.work_skill) && capacityElement.work_skill.equalsIgnoreCase(workSkill)){
                                        if(noCapacity.quota > capacityElement.quota && noCapacity.availability > capacityElement.available){   
                                                if(capacityElement.date_x == Date.today())
                                                    flag = isSlotAvailable(capacityElement.time_slot); 
                                                if(flag == null || flag){
                                                    recTS = populateCapacityElement(capacityElement);
                                                    recTS.activity_duration = response.activity_duration;
                                                    recTS.activity_travel_time = response.activity_travel_time;
                                                if(duplicateDateSlot != null && duplicateDateSlot.size() > 0 && duplicateDateSlot.contains(recTS.dt+''+recTS.timeSlots)){}
                                                else{if(duplicateDateSlot == null){duplicateDateSlot = new Set<string>();}
                                                    if(recTS.availability >= taskDuration){
                                                        duplicateDateSlot.add(recTS.dt+''+recTS.timeSlots);
                                                        recTimeSlots.add(recTS);
                                                    }
                                                }
                                            }
                                        }
                                        else{ 
                                            if (noCapacity.dt == Date.today())
                                                flag = isSlotAvailable(noCapacity.timeSlots);
                                            if(flag == null || flag){
                                                if(duplicateDateSlot != null && duplicateDateSlot.size() > 0 && duplicateDateSlot.contains(noCapacity.dt+''+noCapacity.timeSlots)){}
                                                else{if(duplicateDateSlot == null){duplicateDateSlot = new Set<string>();}
                                                    if(noCapacity.availability >= taskDuration){
                                                        duplicateDateSlot.add(noCapacity.dt+''+noCapacity.timeSlots);
                                                        recTimeSlots.add(noCapacity);
                                                    }
                                                } 
                                            }
                                        }
                                }
                            }   
                        }//CH19
                        else{
                            EON_OFSC_Helper.RecomendedTimeSlots gaCapacity = mapGaWorkSkill.get(capacityElement.date_x);
                            if(!EON_Utility.validateRequired(gaCapacity)){
                                if(!EON_Utility.validateRequired(capacityElement.work_skill) && capacityElement.work_skill.equalsIgnoreCase(workSkill)){
                                        flag = null;
                                        if(gaCapacity.quota > capacityElement.quota && gaCapacity.availability > capacityElement.available){   
                                                if(capacityElement.date_x == Date.today())
                                                    flag = isSlotAvailable(capacityElement.time_slot); 
                                            if(flag == null || flag){
                                                    recTS = populateCapacityElement(capacityElement);
                                                    recTS.activity_duration = response.activity_duration;
                                                    recTS.activity_travel_time = response.activity_travel_time;
                                                if(duplicateDateSlot != null && duplicateDateSlot.size() > 0 && duplicateDateSlot.contains(recTS.dt+''+recTS.timeSlots)){}
                                                else{if(duplicateDateSlot == null){duplicateDateSlot = new Set<string>();}
                                                    if(recTS.availability >= taskDuration){
                                                        duplicateDateSlot.add(recTS.dt+''+recTS.timeSlots);
                                                        recTimeSlots.add(recTS);
                                                    }
                                                }
                                            }
                                        }
                                        else{ 
                                            if (gaCapacity.dt == Date.today())
                                                flag = isSlotAvailable(gaCapacity.timeSlots);
                                            if(flag == null || flag){
                                                if(duplicateDateSlot != null && duplicateDateSlot.size() > 0 && duplicateDateSlot.contains(gaCapacity.dt+''+gaCapacity.timeSlots)){}
                                                else{if(duplicateDateSlot == null){duplicateDateSlot = new Set<string>();}
                                                    if(gaCapacity.availability >= taskDuration){
                                                        duplicateDateSlot.add(gaCapacity.dt+''+gaCapacity.timeSlots);
                                                        recTimeSlots.add(gaCapacity);
                                                    }
                                                } 
                                            }
                                        }
                                }
                            }
                            else{
                                if(!EON_Utility.validateRequired(capacityElement.work_skill) && capacityElement.work_skill.equalsIgnoreCase(workSkill) && !EON_Utility.validateRequired(capacityElement.time_slot) && !EON_Utility.validateRequired(capacityElement.date_x)){
                                    flag = null;
                                    if(capacityElement.date_x == Date.today())
                                        flag = isSlotAvailable(capacityElement.time_slot); 
                                    if(flag == null || flag){
                                        recTS = populateCapacityElement(capacityElement);
                                        recTS.activity_duration = response.activity_duration;
                                        recTS.activity_travel_time = response.activity_travel_time;
                                        if(duplicateDateSlot != null && duplicateDateSlot.size() > 0 && duplicateDateSlot.contains(recTS.dt+''+recTS.timeSlots)){}
                                        else{if(duplicateDateSlot == null){duplicateDateSlot = new Set<string>();}
                                            if(recTS.availability >= taskDuration){
                                                duplicateDateSlot.add(recTS.dt+''+recTS.timeSlots);
                                                recTimeSlots.add(recTS);
                                            }
                                        } 
                                    }
                                }
                            }
                        }
                    }
                }
            }
            outGoingOracleTracker.Response_Data__c = (response == null ? '' : (String.valueOf(response).length() <= 131072) ? String.valueOf(response) : String.valueOf(response).subString(0,131070)); //CH20.New
            if(EON_Utility.validateRequired(response.capacity)) outGoingOracleTracker.Status__c = EON_Utility.RESULT_FAIL; //CH18.Update
            oracleDataTrackers.add(outGoingOracleTracker);  //CH20.New
            insert oracleDataTrackers;
            System.debug('******recTimeSlots = '+recTimeSlots);
        }
        catch(Exception ex){ 
            System.debug('###Error: '+ex.getMessage()+','+ex.getLineNumber());
            outGoingOracleTracker.Response_Data__c = ex.getMessage()+ex.getLineNumber();
            outGoingOracleTracker.Status__c = EON_Utility.RESULT_FAIL; //CH18.Update
            upsert outGoingOracleTracker;
        }
        return recTimeSlots;
    }
    
    /**
        isSlotAvailable(String timeSlot) : this method will take the timeSlot as parameter and compars with current time today and if the slot is already left then will return the false or return the true.
    **/
    public static Boolean isSlotAvailable(String timeSlot){
        if ( timeSlot != '' && timeSlot != null ){
            system.debug(timeSlot);
            String slotStartHour = (( timeSlot.contains('-') ) ? (timeSlot.split('-')[0]).trim() : '');
            system.debug(slotStartHour);
            slotStartHour = (( slotStartHour.contains(':') ) ? (slotStartHour.split(':')[0]).trim() : '');
            system.debug(slotStartHour);
            if(EONAppReason != 'NEW_CONN'){   //CH39
              if (slotStartHour != '' && System.now().hour() > 0 && System.now().hour() < integer.valueOf(slotStartHour) ) 
                  return true;
                  else 
                    return false;
            }
            else
               return true; //CH39
        }
        return false;
    }
    
    /**
        populateCapacityElement(): this method will help us to populate the capacity element record.
    **/
    private static EON_OFSC_Helper.RecomendedTimeSlots populateCapacityElement( EON_OFSC_GetCapacity_WS.capacity_element capacityElement ){
        EON_OFSC_Helper.RecomendedTimeSlots temprecTS = new EON_OFSC_Helper.RecomendedTimeSlots();
        if(!EON_Utility.validateRequired(capacityElement.date_x)){
            temprecTS.dt = capacityElement.date_x;
            temprecTS.dayVal = EON_Utility.getDayOfWeek(capacityElement.date_x);
        }
        if(!EON_Utility.validateRequired(capacityElement.time_slot)){
            temprecTS.timeSlots = (capacityElement.time_slot.replace(' ','')).replaceAll('-',' - ');
            temprecTS.timeFormat = gettimeFormat(capacityElement.time_slot);
        }
        if(!EON_Utility.validateRequired(capacityElement.work_Skill))
            temprecTS.workSkill = capacityElement.work_Skill ;
        if(!EON_Utility.validateRequired(capacityElement.available))
            temprecTS.availability = capacityElement.available;
        if(!EON_Utility.validateRequired(capacityElement.quota))
            temprecTS.quota = capacityElement.quota;
        return temprecTS;
    }
    
    /**
        getUserElement() - This method is used to create userelement.
    **/
    private static EON_OFSC_GetCapacity_WS.User_Element getUserElement(){
        EON_OFSC_GetCapacity_WS.User_Element userElement = new EON_OFSC_GetCapacity_WS.User_Element();
        userElement.company = System.Label.EON_OFSC_Company;//company name
        userElement.login = System.Label.EON_OFSC_Login;//username
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeDateTime(Datetime.now()); // Time Stamp            
        // Cope with the formatter returning .123Z as the time zone offset for GMT //        
        if (gen.getAsString().length() == 27) { userElement.now = gen.getAsString().substring(1,26); }      
        else
            userElement.now = gen.getAsString().substring(1,20) + '+00:00';                
        //call the methods for encript and prepare the authentication string.
        userElement.auth_string = EON_Utility.md5(userElement.now + EON_Utility.md5(System.Label.EON_OFSC_Password));
        return userElement;    
    }
    //CH07.New.Start
    /**
        getUserElementForActivity() - This method is used to create userelement for activity.
    **/
    public static EON_OFSC_Activity_WS.User_X getUserElementForActivity(){
        EON_OFSC_Activity_WS.User_X userElement = new EON_OFSC_Activity_WS.User_X();
        userElement.company = System.Label.EON_OFSC_Company;
        userElement.login = 'soap';
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeDateTime(Datetime.now());
        // Cope with the formatter returning .123Z as the time zone offset for GMT //                
        if (gen.getAsString().length() == 27)  userElement.now = gen.getAsString().substring(1,26);               
        else        
            userElement.now = gen.getAsString().substring(1,20) + '+00:00';
        userElement.auth_string = md5(userElement.now + md5(System.Label.EON_OFSC_Password));
        return userElement;                       
    }
    /**
        md5(string input_string) - Utility method    
    **/
    public static string md5(string input_string){
        blob md = Crypto.generateDigest('MD5', blob.valueOf(input_string));        
        string auth_hash = EncodingUtil.convertToHex(md);        
        return auth_hash;       
    }
    //CH07.New.End
    /**
        addIndustryActivities() - This method will add the industry data( Electric meter type, Gas meter type, Number of phases and pressure details to Activities.)
        //CH18.Update
    **/
    private static List<EON_OFSC_GetCapacity_WS.activity_field_element> addIndustryActivities( Map<String,String> jobAtt){
        List<EON_OFSC_GetCapacity_WS.activity_field_element> activites = new List<EON_OFSC_GetCapacity_WS.activity_field_element>();
        if(!EON_Utility.validateRequired(jobAtt)){
            if(!jobAtt.isEmpty()){
                EON_OFSC_GetCapacity_WS.activity_field_element activity;
                if(jobAtt.containsKey('XA_ELEC_METER_TYPE')){
                    activity = new EON_OFSC_GetCapacity_WS.activity_field_element();
                    activity.name = 'XA_ELEC_METER_TYPE';
                    string eType = jobAtt.get('XA_ELEC_METER_TYPE');
                    activity.value = ((String.isNotBlank(eType)) ? (eType.equalsIgnoreCase('Key') ? '1' : eType.equalsIgnoreCase('MS1') ? '2' :  eType.equalsIgnoreCase('MCL') ? '3' :''): '');
                    activites.add(activity);
                }
                
                if(jobAtt.containsKey('XA_PHASE')){
                    activity = new EON_OFSC_GetCapacity_WS.activity_field_element();
                    activity.name = 'XA_PHASE';
                    string phase = jobAtt.get('XA_PHASE');
                    activity.value = ((String.isNotBlank(phase)) ? (phase.equalsIgnoreCase('1ph') ? '1' : phase.equalsIgnoreCase('3ph') ? '2' : ''): '');
                    activites.add(activity);
                }
                
                if(jobAtt.containsKey('XA_GAS_METER_TYPE')){
                    activity = new EON_OFSC_GetCapacity_WS.activity_field_element();
                    activity.name = 'XA_GAS_METER_TYPE';
                    string mType = jobAtt.get('XA_GAS_METER_TYPE');
                    activity.value = ((String.isNotBlank(mType)) ? (mType.equalsIgnoreCase('MCL') ? '1' : mType.equalsIgnoreCase('MS1') ? '2' :  mType.equalsIgnoreCase('PP') ? '3' :''): '');
                    activites.add(activity);
                }
                
                if(jobAtt.containsKey('XA_PRESSURE')){
                    activity = new EON_OFSC_GetCapacity_WS.activity_field_element();
                    activity.name = 'XA_PRESSURE';    
                    string pressure = jobAtt.get('XA_PRESSURE');
                    activity.value = ((String.isNotBlank(pressure)) ? (pressure.equalsIgnoreCase('low') ? '1' : pressure.equalsIgnoreCase('med') ? '2' : ''): '');
                    activites.add(activity);
                }
                
            }
        }
        
        //CH35.Start
        EON_OFSC_GetCapacity_WS.activity_field_element activity_WorkZone = new EON_OFSC_GetCapacity_WS.activity_field_element();
        activity_WorkZone.name = 'XA_POSTCODE_SECTOR';
        activity_WorkZone.value = oraclePostCodeSector;
        activites.add(activity_WorkZone);
        //CH35.End
        
        return activites;
    }
    
    /**
        gettimeFormat(): this method will help us to return the value of AM up to 12, PM up to 16 or EVE from 16 onwards.
    **/
    public static String gettimeFormat( String timeSlot ){
        //CH19 System.debug('!@#timeSlot = '+timeSlot);
        String[] strFromats = timeSlot.split('-');
        Integer startTime = Integer.valueOf(strFromats[0].trim().replace(':00',''));
        Integer endTime = Integer.valueOf(strFromats[1].trim().replace(':00',''));
        String formatVal = (( strFromats != null && strFromats.size() == 2 ) ? (( startTime < 12 ) ? 'AM': ( startTime < 16 ) ? 'PM' : ( startTime >= 16 ) ? 'EVE' :'' ) : '');
        //CH19 System.debug('formatVal = '+formatVal);
        return formatVal;
    }
    //CH03.End

    //CH08.Start
    /**
        getWorkSkill(): Logic for identifying the WorkSkill for filtering the capacities coming from OFSC.
    **/
    //CH08.Start
    public static  String getWorkSkill(Eon_Appointment__c eonApp){
        system.debug('###WorkAppt: '+eonApp);
        String keyWorkSkill = '';
        /*
        List <EON_Fuel__c> Fuel_type = new List <EON_Fuel__c>();
        if(!EON_Utility.validateRequired(eonApp.Fuel_ID__c))
            Fuel_type = [Select Fuel_type__c FROM EON_Fuel__c where id=:eonApp.Fuel_ID__c];
        if(Fuel_type.size()>0){
            if(Fuel_type[0].Fuel_type__c == 'E'){
                keyWorkSkill += ((eonApp.Planned_E_Meter_Type__c != null )?eonApp.Planned_E_Meter_Type__c:'');//CH10
                if(eonApp.Current_Phase__c != null && eonApp.Current_Phase__c != '' && eonApp.Current_Phase__c == '3Ph')//CH24
                    keyWorkSkill += String.valueOf(eonApp.Current_Phase__c).toUpperCase();//CH24
                else
                    keyWorkSkill += ((eonApp.Number_of_Phases__c != null )?String.valueOf(eonApp.Number_of_Phases__c).toUpperCase():'');//CH14.NEW
            }
            if(Fuel_type[0].Fuel_type__c == 'G'){
                keyWorkSkill += ((eonApp.Planned_G_Meter_Type__c != null )?eonApp.Planned_G_Meter_Type__c:'');//CH10
                keyWorkSkill += ((eonApp.Metering_Pressure__c != null )?eonApp.Metering_Pressure__c:'');
            }
            if(Fuel_type[0].Fuel_type__c == 'D'){
                if(String.isNotBlank(eonApp.Planned_E_Meter_Type__c) && String.isNotBlank(eonApp.Planned_G_Meter_Type__c) && String.isNotBlank(eonApp.Number_of_Phases__c) && String.isNotBlank(eonApp.Metering_Pressure__c)){
                    keyWorkSkill += ((eonApp.Planned_E_Meter_Type__c != null )?eonApp.Planned_E_Meter_Type__c:'');//CH10
                    keyWorkSkill += ((eonApp.Planned_G_Meter_Type__c != null )?eonApp.Planned_G_Meter_Type__c:'');//CH10
                    if(eonApp.Current_Phase__c != null && eonApp.Current_Phase__c != '' && eonApp.Current_Phase__c == '3Ph')//CH24
                        keyWorkSkill += String.valueOf(eonApp.Current_Phase__c).toUpperCase();//CH24
                    else
                        keyWorkSkill += ((eonApp.Number_of_Phases__c != null )?String.valueOf(eonApp.Number_of_Phases__c).toUpperCase():'');//CH14.NEW
                    keyWorkSkill += ((eonApp.Metering_Pressure__c != null )?eonApp.Metering_Pressure__c:'');
                }
                else{keyWorkSkill = 'Invalid WorkSkill';}
            }
        //CH13.Start        
        }
        */      
        //else{
            if(eonApp.MPAN__c != null && eonApp.MPRN__c != null && eonApp.MPAN__c != '' && eonApp.MPRN__c != ''){
                if(String.isNotBlank(eonApp.Planned_E_Meter_Type__c) && String.isNotBlank(eonApp.Planned_G_Meter_Type__c) && String.isNotBlank(eonApp.Number_of_Phases__c) && String.isNotBlank(eonApp.Metering_Pressure__c)){
                    keyWorkSkill += ((eonApp.Planned_E_Meter_Type__c != null )?eonApp.Planned_E_Meter_Type__c:'');
                    keyWorkSkill += ((eonApp.Planned_G_Meter_Type__c != null )?eonApp.Planned_G_Meter_Type__c:'');
                    //CH36.Start
                    if(!EON_Utility.validateRequired(eonApp.Number_of_Phases__c) && !EON_Utility.validateRequired(eonApp.Current_Phase__c)){
                        if(eonApp.Number_of_Phases__c=='1ph' && eonApp.Current_Phase__c=='3Ph')
                              keyWorkSkill += String.valueOf(eonApp.Current_Phase__c).toUpperCase();
                         else                  
                            keyWorkSkill += String.valueOf(eonApp.Number_of_Phases__c).toUpperCase();
                    }
                    else
                    keyWorkSkill += ((eonApp.Number_of_Phases__c != null )?String.valueOf(eonApp.Number_of_Phases__c).toUpperCase():'');
                    //CH36.End
                    keyWorkSkill += ((eonApp.Metering_Pressure__c != null )?eonApp.Metering_Pressure__c:'');
                }
                else{keyWorkSkill = 'Invalid WorkSkill';}
            } 
            else if( eonApp.MPAN__c != null && eonApp.MPAN__c != ''){
                    keyWorkSkill += ((eonApp.Planned_E_Meter_Type__c != null )?eonApp.Planned_E_Meter_Type__c:'');
                    //CH36.Start 
                    if(!EON_Utility.validateRequired(eonApp.Number_of_Phases__c) && !EON_Utility.validateRequired(eonApp.Current_Phase__c)){
                        if(eonApp.Number_of_Phases__c=='1ph' && eonApp.Current_Phase__c=='3Ph')
                              keyWorkSkill += String.valueOf(eonApp.Current_Phase__c).toUpperCase();
                         else                  
                            keyWorkSkill += String.valueOf(eonApp.Number_of_Phases__c).toUpperCase();
                    }
                    else
                    keyWorkSkill += ((eonApp.Number_of_Phases__c != null )?String.valueOf(eonApp.Number_of_Phases__c).toUpperCase():'');
                    //CH36.End
            } 
            else if( eonApp.MPRN__c != null && eonApp.MPRN__c != null){
                    keyWorkSkill += ((eonApp.Planned_G_Meter_Type__c != null )?eonApp.Planned_G_Meter_Type__c:'');
                    keyWorkSkill += ((eonApp.Metering_Pressure__c != null )?eonApp.Metering_Pressure__c:'');
            }
        //}
        System.debug('keyWorkSkill ='+keyWorkSkill);
        if(keyWorkSkill != '' && keyWorkSkill != 'Invalid WorkSkill' && EON_Capacity_Categories__c.getValues(keyWorkSkill.toUpperCase())!= null 
            && EON_Capacity_Categories__c.getValues(keyWorkSkill.toUpperCase()).Work_Skill__c != null ){
            keyWorkSkill = EON_Capacity_Categories__c.getValues(keyWorkSkill.toUpperCase()).Work_Skill__c;
        } 
        else{
            keyWorkSkill = 'Invalid WorkSkill';
        }
        System.debug('calculate keyWorkSkill ='+keyWorkSkill );
        //CH13.End
        return keyWorkSkill;
    }
    //CH08.End
     
    /**
        mapAppointmentFromFuelSite(Eon_Fuel__c fuel,Eon_Appointment__c mapAppointment): this method will map the records in EON Appointment record.
    **/
    public static EON_Appointment__c mapAppointmentFromFuelSite(Eon_Fuel__c fuel,Eon_Appointment__c mapAppointment){
        mapAppointment.MPAN__c = fuel.MPAN__c;
        mapAppointment.MPRN__c = fuel.MPRN__c;
        //mapAppointment.G_Meter_Model__c = fuel.Gas_model_A0083__c;commented out
         //CH32
                                       
                                         Map<String, EON_Model_ID_to_Model_Name_Mapping__c> allGasModels_A0083 = EON_Model_ID_to_Model_Name_Mapping__c.getAll();
                                         if(!allGasModels_A0083.isEmpty()){
                                            for(EON_Model_ID_to_Model_Name_Mapping__c  GasModel : allGasModels_A0083.values()){
                                                 if(fuel.Gas_model_A0083__c==GasModel.Name){
                                                mapAppointment.G_Meter_Model__c = GasModel.Model_Name__c; 
                                                system.debug('%%%%%%%%Debug at line 479'+mapAppointment.G_Meter_Model__c);
                                                }
                                            }
                                        }
                                  
                                    //CH32 
        
       
        
        mapAppointment.G_Meter_Serial_Number__c = fuel.Gas_meter_serial_number__c;
        mapAppointment.G_Meter_Make__c = fuel.Gas_manufacturer_code_A0060__c;
        mapAppointment.G_Meter_Measuring_Capacity__c = ((fuel.Gas_measuring_capacity_A0112__c != null ) ? String.valueOf(fuel.Gas_measuring_capacity_A0112__c) : '');
        mapAppointment.Number_of_Dials_or_Digits__c = fuel.Gas_number_of_dials_or_digits_A0121__c;
        mapAppointment.G_Meter_Type__c = fuel.Gas_meter_type_A0025__c; 
        mapAppointment.G_Meter_Mechanism__c = fuel.Gas_Meter_Mechanism__c;
        mapAppointment.Payment_Method_code__c = fuel.Gas_payment_method_A0163__c;
        mapAppointment.Sub_Building_Name__c = fuel.Premise__r.Sub_Building_Name__c;
        mapAppointment.Building_Name__c = fuel.Premise__r.Building_Name__c;
        mapAppointment.Dependent_Thorofare__c = fuel.Premise__r.Dependant_Thorofare__c;
        mapAppointment.Thorofare__c = fuel.Premise__r.Thorofare__c;
        mapAppointment.Dependant_Locality__c = fuel.Premise__r.Dependant_Locality__c;
        mapAppointment.Double_dependant_Locality__c = fuel.Premise__r.Double_Dependant_Locality__c;
        mapAppointment.Post_Town__c = fuel.Premise__r.Town__c;
        mapAppointment.Post_Code__c = fuel.Premise__r.Postcode__c;
        mapAppointment.Person_Name__c = fuel.Premise__r.Customer__r.Customer_Name__c;
        //CH17.Start
        mapAppointment.Supplier_Name__c = fuel.Gas_supplier_code__c;
        mapAppointment.Planned_G_Meter_Type__c = fuel.Gas_Meter_Mechanism__r.Code__c;
        mapAppointment.Metering_Pressure__c= 'Low';
        //CH17.END
        mapAppointment.Gas_Market_Participant_ID__c = fuel.h_Gas_Supplier_MPID__c;//CH23
        mapAppointment.Gas_Map_Identifier__c = fuel.Gas_Map_identifier__c;//CH26
        mapAppointment.G_Meter_No_of_dials_digits__c = fuel.Gas_number_of_dials_or_digits_A0121__c;//CH27
        mapAppointment.G_Meter_Year_of_Manufacture__c = fuel.Gas_year_of_manufacture_A0021__c;//CH28
        mapAppointment.G_Meter_Units_of_Measure__c = fuel.h_Gas_units_of_measure_A0123__c;//CH28//CH31
        mapAppointment.G_Meter_Multiplication_Factor__c = fuel.Gas_multiplication_factor_A0120__c;//CH28
        return mapAppointment;
    }

    //CH05.start
    /**
        getInboundUserElement() - This method is used to create userelement.
    **/
    public Static EON_OFSC_Inbound_WS.UserElement getInboundUserElement(){
        EON_OFSC_Inbound_WS.UserElement userElement = new EON_OFSC_Inbound_WS.UserElement();
        userElement.company = System.Label.EON_OFSC_Company;
        userElement.login = System.Label.EON_OFSC_Login;//'soap';
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeDateTime(Datetime.now());            
        // Cope with the formatter returning .123Z as the time zone offset for GMT //        
        if (gen.getAsString().length() == 27)userElement.now = gen.getAsString().substring(1,26);       
        else userElement.now = gen.getAsString().substring(1,20) + '+00:00';                
        userElement.auth_string = EON_Utility.md5(userElement.now + EON_Utility.md5(System.Label.EON_OFSC_Password));
        return userElement;    
    }
    /**
        getHeaderElement() - This method is used to created HeaderElement.
    **/
    public static EON_OFSC_Inbound_WS.HeadElement getHeaderElement(){
        string toaDateFormat = 'yyyy-MM-dd';
        EON_OFSC_Inbound_WS.HeadElement headerElement = new EON_OFSC_Inbound_WS.HeadElement();
        headerElement.upload_type = 'incremental';
        headerElement.id = string.valueOf(crypto.getRandomLong());
        headerElement.date_x = datetime.now().format(toaDateFormat);
        headerElement.allow_change_date = 'yes'; 
        List<string> appointment_key = new List<string>();
        appointment_key.add('appt_number');                       
        
        EON_OFSC_Inbound_WS.KeysArray appointment_keys = new EON_OFSC_Inbound_WS.KeysArray();
        appointment_keys.field = appointment_key;                    
        EON_OFSC_Inbound_WS.AppointmentSettings appointment_settings = new EON_OFSC_Inbound_WS.AppointmentSettings();
        appointment_settings.keys = appointment_keys;
        appointment_settings.action_if_completed = 'update';
        
        headerElement.appointment = appointment_settings; 
        
        List<string> inventory_key = new List<string>();
        inventory_key.add('invsn');
        
        EON_OFSC_Inbound_WS.KeysArray inventory_keys = new EON_OFSC_Inbound_WS.KeysArray();
        inventory_keys.field = inventory_key;        
        EON_OFSC_Inbound_WS.InventorySettings inventory_settings = new EON_OFSC_Inbound_WS.InventorySettings();
        inventory_settings.keys = inventory_keys;
        
        headerElement.inventory = inventory_settings; 
        
        return headerElement;   
    }
    /**
        convertDateToDateTime(Date dt) - This method converts date to TOA Date Format.
    **/
    public static String convertDateToTOAFormat(Date dt){
        string toaDateFormat = 'yyyy-MM-dd';
        String TOADate = '';
        if(dt != null)
            TOADate = datetime.newInstance(dt, time.newInstance(0, 0, 0, 0)).format(toaDateFormat);            
        return TOADate;        
    }
    //CH05.end
    
    //CH09.start
    /*
        checkValidations() -- This method checks for the validation present on the EON Appointment
    */
    public static string checkValidations(EON_Appointment__c objApp){
        string error = '';
        //CH11.start
        list<EON_Job__c> lstJob = new list<EON_Job__c>([select id, name, Job_Type__c from EON_Job__c where id=: objApp.Job_code__c]);
        if(string.isBlank(objApp.Planned_Meter_Mode__c) && !lstJob.isEmpty() && lstJob.size()>0 && string.isNotBlank(lstJob[0].Job_Type__c) &&  lstJob[0].Job_Type__c.containsIgnoreCase('Smart')){//Job_Type__c //objApp.h_Job_Type__c.containsIgnoreCase('smart')
            error = 'Planned Meter Mode: required if \'Job Type\' is Smart.';
            return error;
        }
        //CH11.end
        //CH22
        if(String.isNotBlank(objApp.Planned_Meter_Mode__c) && objApp.Planned_Meter_Mode__c.containsIgnoreCase('PAYG')) {
            if(objApp.E_Low_balance_alert_flag__c && objApp.E_LowBalanceAlertValue__c == null){
                error = error + 'E LowBalanceAlertValue: required if \'E Low balance alert flag\' is checked.';
                //CH22 return error;
            }
            if(objApp.E_Payment_Reminder_Opt_in_Flag__c && string.isBlank(objApp.E_Payment_Reminder_Frequency_Code__c)){
                error = error + 'E Payment Reminder Frequency Code: required if \'E Payment Reminder Opt in Flag\' is checked.';
                //CH22 return error;
            }
            if(String.isNotBlank(objApp.E_Payment_Reminder_Frequency_Code__c)){
                if(objApp.E_Payment_Reminder_Frequency_Code__c =='W' && string.isBlank(objApp.E_Payment_Reminder_Day_Of_The_Week__c)){
                    error = error + 'E Payment Reminder Day Of The Week: required if \'E Payment Reminder Frequency Code\' is W.';
                    //CH22 return error;
                }
                //CH22.Start
                if(objApp.E_Payment_Reminder_Frequency_Code__c != null && objApp.E_Payment_Reminder_Frequency_Code__c =='W' && objApp.E_Payment_Reminder_Date__c != null){
                    error = error + 'E Payment Reminder Date must be null if \'E Payment Reminder Frequency Code\' is W.';
                }
                if (objApp.E_Payment_Reminder_Frequency_Code__c != null && objApp.E_Payment_Reminder_Frequency_Code__c.containsIgnoreCase('M') && objApp.E_Payment_Reminder_Date__c == null) {
                    error = error + 'E Payment Reminder Date is required if \'E Payment Reminder Frequency Code\' is M.';
                }
                if (objApp.E_Payment_Reminder_Frequency_Code__c != null && objApp.E_Payment_Reminder_Frequency_Code__c.containsIgnoreCase('M') && objApp.E_Payment_Reminder_Day_Of_The_Week__c != null){
                    error = error + 'E Payment Reminder day of the Week must be null if \'E Payment Reminder Frequency Code\' is M.';
                }
            }
            //CH22.End
            if(objApp.G_Low_balance_alert_flag__c && objApp.G_LowBalanceAlertValue__c == null){
                error = error + 'G LowBalanceAlertValue: required if \'G Low balance alert flag\' is checked.';
                //CH22 return error;
            }
            if(objApp.G_Payment_Reminder_Opt_in_Flag__c && string.isBlank(objApp.G_Payment_Reminder_Frequency_Code__c)){
                error = error + 'G Payment Reminder Frequency Code: required if \'G Payment Reminder Opt in Flag\' is checked.';
                //CH22 return error;
            }
            
            if ( String.isNotBlank(objApp.G_Payment_Reminder_Frequency_Code__c)) {
                if(objApp.G_Payment_Reminder_Frequency_Code__c =='W' && string.isBlank(objApp.G_Payment_Reminder_Day_Of_The_Week__c)){
                    error = error + 'G Payment Reminder Day Of The Week: required if \'G Payment Reminder Frequency Code\' is W.';
                    //CH22 return error;
                }
                //CH22.Start
                if(objApp.G_Payment_Reminder_Frequency_Code__c =='W' && objApp.G_Payment_Reminder_Date__c != null){
                    error = error + 'G Payment Reminder Date must be null if \'G Payment Reminder Frequency Code\' is W.';
                }
                if (objApp.G_Payment_Reminder_Frequency_Code__c.containsIgnoreCase('M') && objApp.G_Payment_Reminder_Date__c == null) {
                    error = error + 'G Payment Reminder Date is required if \'G Payment Reminder Frequency Code\' is M.';
                }
                if (objApp.G_Payment_Reminder_Frequency_Code__c.containsIgnoreCase('M') && objApp.G_Payment_Reminder_Day_Of_The_Week__c != null){
                    error = error + 'G Payment Reminder day of the Week must be null if \'G Payment Reminder Frequency Code\' is M.';
                }
            }
        }
        //CH22.End
        return error;
    }
    //CH09.end
    
    //CH25.Start
    /**
        getHeaderElementForMIDOS() - This method is used to created HeaderElement for MIDOS.
    **/
    public static EON_OFSC_Inbound_WS.HeadElement getHeaderElementForMIDOS(){
        string toaDateFormat = 'yyyy-MM-dd';
        EON_OFSC_Inbound_WS.HeadElement headerElement = new EON_OFSC_Inbound_WS.HeadElement();
        headerElement.upload_type = 'incremental';
        headerElement.id = string.valueOf(crypto.getRandomLong());
        headerElement.date_x = datetime.now().format(toaDateFormat);
        headerElement.allow_change_date = 'yes'; 
        List<string> appointment_key = new List<string>();
        appointment_key.add('appt_number');
        EON_OFSC_Inbound_WS.KeysArray appointment_keys = new EON_OFSC_Inbound_WS.KeysArray();
        appointment_keys.field = appointment_key;                    
        EON_OFSC_Inbound_WS.AppointmentSettings appointment_settings = new EON_OFSC_Inbound_WS.AppointmentSettings();
        appointment_settings.keys = appointment_keys;
        appointment_settings.action_if_completed = 'update';
        headerElement.appointment = appointment_settings;
        List<string> inventory_key = new List<string>();
        inventory_key.add('invsn');
        EON_OFSC_Inbound_WS.KeysArray inventory_keys = new EON_OFSC_Inbound_WS.KeysArray();
        inventory_keys.field = inventory_key;        
        EON_OFSC_Inbound_WS.InventorySettings inventory_settings = new EON_OFSC_Inbound_WS.InventorySettings();
        inventory_settings.keys = inventory_keys;
        headerElement.inventory = inventory_settings;
        headerElement.properties_mode = 'update';
        return headerElement;   
    }    
    //CH25.end
    //CH29.New.Start
    /**
        isValidTimeSlot() - This method is used to validate timeslot in format NN:NN - NN:NN
    **/
    public static boolean isValidTimeSlot(String timeSlot){
        if(!EON_Utility.validateRequired(timeSlot)){
            if(timeSlot.contains('-')){
                list<String> tmSlots = new list<String>();
                list<String> newTmSlots = new list<String>();
                list<String> timeList = new list<String>();
                tmSlots = timeSlot.split('-');
                for(String slot:tmSlots)
                    newTmSlots.add(slot.trim());
                for(String slot:newTmSlots){
                    list<String> strNumber = new list<String>(); 
                    strNumber = slot.split(':');
                    if(!strNumber.isEmpty())
                        timeList.addAll(strNumber);
                }
                if(!timeList.isEmpty()){
                    for(String str: timeList){
                        if(!str.isnumeric()){
                            return false;
                        }
                    }
                }
            }
            else
                return false;
        }
        else 
            return false;
        return true;
    }
    //CH29.New.End
    
    
    //CH34.Start
    /**
        getOOAACCUCHECKELECTypePhase();
    **/
    public static Map<String, String> getOOAACCUCHECKELECTypePhase(){
        Map<String, String> mapElecTypePhase = new Map<String, String>();
        mapElecTypePhase.put('MCL1PH', 'SLT1');
        mapElecTypePhase.put('MCL3PH', 'SLT3');
        mapElecTypePhase.put('KEY1PH', 'SLT1');
        mapElecTypePhase.put('KEY3PH', 'SLT3');
        return mapElecTypePhase;        
    }
    //CH34.End
}