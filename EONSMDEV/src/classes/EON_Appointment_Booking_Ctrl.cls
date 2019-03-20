/**
    Description : This class will query the records based on search criteria entered by user on the page and display the records from EON Appointment. If records are not present in EON Appointment then the conditions will search on EON Fuel object and display the Customer name only as remaining fields are not available for displaying. If records are not available in both records then page will populate the info message stating that records are not available for above search.
    VF Page     : EON_Appointment_Booking
    Test Class  : EON_Appointment_Booking_Ctrl_Test
**/
/*
    Created By : Sivasankar K
    Created On : 16/02/2016
    Service Req: SR_EON_AB_006
    Change History 
    CH01 # SR_Isis_EON_007 # 09/03/2016 # Mahadev Joshilkar # Deleted reference of Address_Text__c amended the relationship names.
    CH02 # SR_EON_AB_012 # 16-03-2016 # Sivasankar # Adding the logic to include two more fields in search criteria and Creating the Jumbo Data tracker records when user clicks search on Industry section.
    CH03 # SR_EON_AB_023 # 04/04/2016 # Sivasankar # Adding the logic for displaying the capacities from OFSC
    CH04 # SR_EON_PC_022 # 04/04/2016 # Mahadev # Deleted field reference - S_Postcode__c
    CH05 # SR_EON_AB_033 # 05/04/2016 # Nitin # Amended logic for the Updated functionality.Added new Tab Portfolio.New logic for Appointment and Industry Tab. Enabled Buttons. Change CH03 has been now moved to 'EON_Appointment_Booking_Ctrl_Helper' class.
    CH06 # SR_EON_AB_057 # 10/05/2016 # Nitin # Added inner query 'EON_Opt_in_Opt_Out_Preferences__r' to the existing logic.
    CH07 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH08 # SR_EON_Mobile_046 # 08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH09 # SR_EON_AB_071 # 16/06/2016 # Dharmendra P # Updated field API Name and added new fields.
    CH10 # SR_EON_AB_067 # 15/06/2016 # Nitin # Added new method and amended logic on Industry search screen.
    CH11 # SR_EON_AB_070 # 17/06/2016 # Aruna Manjari # Changed the error message generating.
    CH12 # SR_EON_Jumbo_037 # 22/06/2016 # Mehboob Alam # Changed the data type from Number to Text for Fields-Alternate_Priority_Service_PhoneNumber1__c,
    Alternate_Priority_Service_PhoneNumber2__c,Primary_Priority_Service_Phone_Number_2__c,Primary_Priority_Service_Phone_Number_1__c
    CH13 # SR_EON_AB_086 # 15/07/2016 # Praveen G #added new Appointment reason value as New_Connection for industry search.
    CH14 # SR_EON_AB_095 # Akshay B # removed validation for mandatory fuelID.
    CH15 # SR_EON_AB_108 # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text 
    CH16 # SR_EON_AB_110 # 01/08/2016 # Shruti Moghe # populated the value of  Booking System Name while creating an appointment through Booking portal
    CH17 # SR_EON_AB_100 # 03/08/2016 # Sivasankar # Added logic for updating the Planned E Meter Type and Planned G Meter Type values  = MS1.
    CH18 # SR_EON_AB_115 # 04/08/2016 # Dharmendra P # Added Appointmnet Reason field functionality.
    CH19 # SR_EON_AB_119 # 09/08/2016 # Sivasankar K # Adding the logic for populating the Planned E Meter Type and Planned G Meter Type if the Job Type is not SMART.
    CH20 # SR_EON_AB_122 # 11/08/2016 # Shruti Moghe # Updated functionality for ECO Job
    CH21 # SR_EON_AB_027 # 16/08/2016 # Sivasankar K # Adding the logic to allow functionality to book appointment when we are not MAM, map the data from EON FUEL and EON Site.
    CH22 # SR_EON_AB_123 # 19/08/2016 #Aruna Manjari# Updated the logic for  the only Job codes that are allowed to appear are validated by rules specified in AB_115 (MPAN and MPRN) AND the combinations contained within the EON Job Appointment Reason records. 
    CH23 # SR_EON_AB_125 # 23/08/2016 # Sivasankar K # Adding the logic for mapping the Planned G Meter Type and Metering Pressure values from Gas Meter Mechanism
    CH24 # SR_EON_AB_131 # 07/09/2016 # Sivasankar K # Amending the class to allow users to book the appointment even the Jumbo is not returned the Meter information.
    CH25 # SR_EON_AB_144 # 19/09/2016 # Aruna Manjari # Cloning the child EON Appointment Vulnerabilities ,EON Appointment Comms ,EON Appointment Contacts ,EON Appointment Attributes  related to any appointment being cloned for rescheduling 
    CH26 # SR_EON_AB_158 # 29/09/2016 # Puneet Mehta # Changed 'NIGHT' to 'Night'
    CH27 # SR_EON_AB_161 # 05/10/2016 # Puneet Mehta #  Queried and mapped new field from EON Fuel record: h_Gas_Supplier_MPID
    CH28 # SR_EON_AB_162 # 10/10/2016 # Puneet Mehta #  Changed the message when the Appointment is already cancelled in OFSC
    CH29 # SM-2925 # 14/10/2016# Sivasankar # adding the condition to fix the Active InActive status.
    CH30 #SR_EON_AB_178 #26/10/2016 #Puneet Mehta #ECO related changes when rescheduling
    CH31 # SR_EON_AB_177 # 25/10/2016 # Puneet Mehta # IF Metering Pressure = FALSE then default the value to LOW
    CH32 # SR_EON_AB_179 # 27/10/2016 # Puneet Mehta # When rescheduling an appointment, MOSE Hire, Status and Technician should not be copied
    CH33 # SR_EON_AB_172 # 04/11/2016 # Aruna Manjari # On a Get Capacity call from EON, if “Current Phase” exists and it is 3PH then use that to determine skillset, else use “Number of phases” to determine Oracle skillset 
    CH34 # SR_EON_AB_180 # 04/11/2016 # Puneet Mehta # If MUS is the MAM of the relevant MPRN then we should get the data from JUMBO. Else if we are not MAM then the data should come from EON Fuel to populate the Gas MArket Participant Id field
    CH35 # SR_EON_AB_193 # 06/12/2016 # Puneet Mehta # When rescheduling an appointment, Booking System should be MUS
    CH36 # SR_EON_Jumbo_091 # 14/12/2016 # Puneet Mehta # Mapped new field from EON Fuel 'Gas Map Identifier'
    CH37 #SR_EON_AB_197 # 11/01/2017 # Praveen G # added filter to get the cancel reason.
    CH38 # SR_EON_Jumbo_096 # 12/01/2017 # Puneet Mehta # Mapped new field from EON Fuel
    CH39 # SM-3156 # 20/01/2017 # Mahadev J # Updated logic to populate PlannedE/G Meter Type
    CH40 # SR_EON_Jumbo_107 # 20/02/2017 # Puneet Mehta # Mapped new field from EON Fuel
    CH41 # SR_EON_AB_210 # 13/03/2017 #Shruti Moghe # amended code for reschedule functionality to not copy the Confirmed Appointment Date field when rescheduled.
    CH42 # SR_EON_Jumbo_106 # 30/03/2017 # Mahadev J # Updated logic to store EON Appointment Meters
    CH43 # SR_EON_AB_217 # 04/04/3017 # Mahadev J # Updated logic to populate effective dates at display
    CH44 # SR_OptiMUS_EON_077 #09/06/2017 #Praveen G #Making 4 fields null for when reschedule.
    CH45 # SR_OptiMUS_EON_084 #19/06/2017 #Praveen G #Making deprogramming fields null for when reschedule.
    CH46 # SR_OptiMUS_EON_087 #04/07/2017 #Praveen G #Added new jobcode - OOAEINSTALLBIND
    CH47 # SR_OptiMUS_EON_091 #09/08/2017 #Praveen G #Reschedule functionality changes.
    CH48 # INCUK0006183286 #17/08/2017 #Mahadev J # Updated code logic to remove non-related Jumbo Data Trackers & EON Appointment Meter records.
    CH49 # SR_OptiMUS_EON_142 #06/11/2017 #Praveen G # Cancel / Reschedule functionality changes.
    CH50 # SR_OptiMUS_EON_188 # 15/01/2018 # Mehboob Alam # Displaying Industry Section for EON Complaint request.
    CH51 # SR_OptiMUS_EON_179 # 07/02/2018 # Praveen G # Replan changes.
    CH52 # SR_OptiMUS_EON_220 # 19/02/2018 # Heena Chauhan # Added logic to the field "PAYG Details Sent"
    CH53 # SR_OptiMUS_EON_238 # 09/05/2018 # Mehboob Alam # Added logic restrict updates to an existing appointment record for replan scenario
    CH54 # SR_OptiMUS_EON_257 # 19/07/2018 # Mehboob Alam # populating Market Participant ID from Jumbo.
    CH55 # SR_OptiMUS_EON_277 # 11/09/2018 # Rangnath A   # Added logic for Assign Technician functionality
	CH56 # SR_OptiMUS_EON_297 # 05/02/2019 # Tabish Almas # Added logic to get data from MDS or Jumbo based on MDS Jumbo Dataflow Switch
*/

public with sharing Class EON_Appointment_Booking_Ctrl {

    public Boolean allowBooking {
        get;
        set;
    } //CH43
    public Set < Id > resultIds = new Set < Id > ();
    public list<EON_Appointment_Meter__c> allApptMeter{ //CH42.New
        get;
        set;
    }
    public Boolean areWeNotMAM {
        get;
        set;
    } //CH21
    //CH05.Start
    public String cancelReasonID {
        get;
        set;
    }
    public Map < Id, EON_Site__c > mapCount {
        get;
        set;
    }
    public string selFuelID {
        get {
            if (selFuelID == null)
                selFuelID = '';
            return selFuelID;
        }
        set;
    }
    public String ApptReason {
        get;
        set;
    }
    
    //CH56.Start
    public String switchData {
        get;
        set;
    }
    //CH56.End
    
    //CH18.start
    public List < SelectOption > appReasonLst {
        get {
            list < Eon_Appointment_Reason__c > reasonList = [select id, name from Eon_Appointment_Reason__c limit 50000];
            if (reasonList != null && reasonList.size() > 0) {
                appReasonLst = new List < SelectOption > ();
                appReasonLst.add(new SelectOption('', '-- Select Appointment Reason--'));
                for (Eon_Appointment_Reason__c Reason: reasonList) {
                    appReasonLst.add(new SelectOption(Reason.id, Reason.name));
                }
            }
            return appReasonLst;
        }
        set;
    }
    //CH18.end
    public String fuelType {
        get;
        set;
    } //CH17
    public String customerID {
        get;
        set;
    }
    public Eon_Appointment__c newAppointment {
        get;
        set;
    }
    public String selApptID {
        get {
            if (selApptID == null)
                selApptID = '';
            return selApptID;
        }
        set;
    }
    //Ch55
       public boolean AssignInOptimus{
        get {           
            return AssignInOptimus;
        }
        set;    
        
    }
    public List < EON_Job_Attribute__c > availableJobAttributes {
        get {
            if (availableJobAttributes == null)
                availableJobAttributes = new List < EON_Job_Attribute__c > ();
            return availableJobAttributes;
        }
        set;
    }

    public String oracleBucketID {
        get {
            if (oracleBucketID == null)
                oracleBucketID = '';
            return oracleBucketID;
        }
        set;
    }

    /**
        jobCode(): this will give us the jobCode for selectedFuel Type
    **/
    public String jobCode {
        get {
            if (jobCode == '' || jobCode == null)
                jobCode = '';
            return jobCode;
        }
        set;
    }
    public boolean isIndustryCreateApp {
        get {
            if (isIndustryCreateApp == null) {
                isIndustryCreateApp = false;
            }
            return isIndustryCreateApp;
        }
        set;
    }

    /**
        cancelReasons: this method fetches the Eon Appointment Cance Reason records.
    **/
    public List < EON_Appointment_Cancel_Reason__c > cancelReasons {
        get {
            if (cancelReasons == null)
                cancelReasons = new List < EON_Appointment_Cancel_Reason__c > (
                        [SELECT ID, Name, Reason_key__c FROM EON_Appointment_Cancel_Reason__c
                            where Reason_key__c != 'RESCHEDULE' //CH37
                            ]);
            return cancelReasons;
            
        }
        set;
    }

    public boolean isAppointmentCreated {
        get;
        set;
    } //CH10 this will help us to identify that appointment is created or not.

    /**
        cancelAppointment(): This method will call the calcelation method for cancelling the selected appointment.
    **/
    public PageReference cancelAppointment() {
        System.debug('cancelReasonID= ' + cancelReasonID + ', selAppointmentID =' + selAppointmentID + ',selApptID = ' + selApptID);
        //populate the Appointment record with Cancel DateTime and Cancel_Reason
        Eon_Appointment__c eonCancelApp = new Eon_Appointment__c(id = selAppointmentID, Cancel_Reason__c = cancelReasonID, Cancellation_DateTime__c = DateTime.now());
        
        //CH51.Start
        Eon_Appointment__c eonApp = [select Appointment_reason_code__r.Name
                                     from Eon_Appointment__c  where  id =: selAppointmentID];
        //CH51.End
        
        //CH49.Start //Update the appt record replan field based on the cancel reason record.
        if(cancelReasonID != null){
            EON_Appointment_Cancel_Reason__c cancelReason = [select Valid_for_Replan__c from 
                                                                    EON_Appointment_Cancel_Reason__c 
                                                                    where id =:cancelReasonID];
            if(cancelReason.Valid_for_Replan__c 
                && eonApp.Appointment_reason_code__r.Name != 'New Connections') //CH51
                eonCancelApp.Replan__c = 'Y';
            else
                eonCancelApp.Replan__c = 'N';
                    
        }                                                                       
        //CH49.End
                
        //call the method to cancel the appointment
        String result = EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(selAppointmentID);
        System.debug('result = ' + result);
        if (result != '' && result.equalsIgnorecase('Activity cancelled in OFSC successfully')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm, 'Appointment has cancelled sucessfully.'));
            update eonCancelApp;
        } else {
            if (result != '' && result.equalsIgnorecase('Appointment already cancelled in OFSC')) { update eonCancelApp; ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm, 'Appointment cancelled in OptiMUS.'));} //CH28
            else { //CH28
                Oracle_Data_Tracker__c requestOut = new Oracle_Data_Tracker__c();
                if (EON_Cancel_Activity_OFSC.requestOut.id != null) {
                    requestOut = [SELECT Id, Name From Oracle_Data_Tracker__c WHERE ID = : EON_Cancel_Activity_OFSC.requestOut.id];
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, result + '' + (requestOut.id != null ? ' with reference : ' + requestOut.Name : '')));
            }
        }
        return null;
    }

    /**
        rescheduleAppointment (): This method will call the calcellation method for cancelling the selected appointment and clone the cancelled appointement and redirect the user to select the appointment.
    **/
    public PageReference rescheduleAppointment() {
        System.debug('selAppointmentID =' + selAppointmentID);
        System.debug('cancelReasonID= ' + cancelReasonID + ', selApptID=' + selApptID+ ',selApptID = ' + selApptID);
        try {
            EON_Appointment_Cancel_Reason__c[] eonResch = [SELECT ID, Name FROM EON_Appointment_Cancel_Reason__c WHERE Reason_key__c IN('Rescheduled', 'Reschedule', 'Re scheduled') LIMIT 1];
            if (eonResch != null && !eonResch.isEmpty()) {
                List < String > relationFields = new List < String > ();
                relationFields.add('Job_Code__r.Job_Type__c');
                relationFields.add('Fuel_ID__r.Premise__r.Postcode__c');
                Eon_Appointment__c toBecanceldAppt = new Eon_Appointment__c(id = selAppointmentID);
                sObject originalSObject = (sObject) toBecanceldAppt;
                List < sObject > originalSObjects = new List < sObject > {
                    originalSObject
                };
                List < Eon_Appointment__c > allFieldSObjects = EON_Utility.getAllFields(originalSobjects, originalSobject.getsObjectType(), relationFields);
                toBecanceldAppt = allFieldSObjects[0];
                
                System.debug('******* ' + toBecanceldAppt.Status__c);
                
                //CH32
                Eon_Appointment__c newAPP = toBecanceldAppt.clone(false, false, false, false);
                newAPP.PAYG_Details_Sent__c=false;//CH52
                //Get the Oracle BucketID
                String oracleBucket = EON_OFSC_Helper.getOracleBucketId(newAPP.Job_Code__c, newAPP.Job_Code__r.Job_Type__c, ((newApp.Fuel_ID__c != null && newApp.Fuel_ID__r.Premise__r.Postcode__c != null) ? newApp.Fuel_ID__r.Premise__r.Postcode__c : (((newApp.MPAN__c != null && newApp.MPRN__c != null) || newApp.MPAN__c != null) ? newApp.Metering_Point_Postcode__c : newApp.Post_Code__c)), newApp.MPAN__c);
                System.debug('oracle Bucket ID returned ####=>' + oracleBucket);
                if (oracleBucket != '' && oracleBucket.containsIgnoreCase('Reject')) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oracleBucket));}
                else {
                    //call the method to cancel the appointment
                    String result = EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(selAppointmentID);
                    System.debug('result = ' + result);
                    if (toBecanceldAppt.Status__c == 'ABORTED' || //CH51 
                        (result != '' && (result.equalsIgnorecase('Activity cancelled in OFSC successfully') || 
                            result.equalsIgnorecase('Appointment already cancelled in OFSC')))) { //CH28
                        newAPP.MOSE_Hire__c = null; //CH32
                        newAPP.Status__c = ''; //CH32
                        newAPP.Technician__c = null; //CH32
                        System.debug('result =newAPP.Market_Participant_ID__c----> ' + newAPP.Market_Participant_ID__c);
                        //CH54.Start
                        if(newAPP.Market_Participant_ID__c!='EON Digital Attacker')
                            newAPP.Booking_System_Name__c = 'MUS';
                          else
                             newAPP.Booking_System_Name__c = 'MUS-DA';
                        //CH54.End      
                        //newAPP.Booking_System_Name__c = 'MUS'; //CH35
                        newAPP.Time_Slot__c = '';//CH35
                        newAPP.Sent_to_Oracle__c = false;//CH35
                        newAPP.Appointment_Date__c = null;//CH35
                        newAPP.appointment_key__c = ''; //AB_188
                        newAPP.ownerId = UserInfo.getuserId();
                        newAPP.Confirmed_Appointment_DateTime__c = null;//CH41
                        
                        //CH44.Start
                        newAPP.Abort_Datetime__c = null;
                        newApp.Onsite_DateTime__c = null;
                        newApp.Suspended_DateTime__c = null;
                        newApp.Cancellation_DateTime__c = null;
                        //CH44.end
                        
                        //CH45.Start
                        newAPP.Close_Electricity_Job__c = null;
                        newApp.Close_Gas_Job__c = null;
                        newApp.Elec_Deprogramming_Time__c = null;
                        newApp.Gas_Deprogramming_Time__c = null;
                        newApp.E_Job_Manually_Deprogrammed__c = false;
                        newApp.G_Job_Manually_Deprogrammed__c = false;
                        //CH45.End
                        
                        newApp.Cancel_Reason__c = null;//CH49                        
                        newApp.Replan__c = null; //CH49
                        newApp.Replan_Comments__c = ''; //CH51
                        
                        //CH53.Start
                        if(ApexPages.CurrentPage().getParameters().get('replan') == 'yes')
                            newApp.h_CanceldApptId__c = selAppointmentID;
                        //CH53.End
                        
                        insert newAPP;
                        
                        if(cancelReasonID != null){ //CH49                       
                            //toBecanceldAppt.Cancel_Reason__c = eonResch[0].id; CH47.old
                            toBecanceldAppt.Cancel_Reason__c = cancelReasonID; //CH47                        
                            toBecanceldAppt.Cancellation_DateTime__c = DateTime.now();
                        }//CH49
                        
                         //CH53.Start
                        if(ApexPages.CurrentPage().getParameters().get('replan') != 'yes'){
                           toBecanceldAppt.Rescheduled_Appointment__c = newAPP.id; //CH25
                           toBeCanceldAppt.Replan__c = null; //CH49
                        }
                        //CH53.End
        
                        update toBecanceldAppt;
                        //CH25.Start
                        //Clone child EON Appointment Vulnerabilities 
                        list < EON_Appointment_Vulnerability__c > appvuls = new list < EON_Appointment_Vulnerability__c > ();
                        List < EON_Appointment_Vulnerability__c > appvul = [select id, name, Description__c, EON_Appointment_ID__c, VulnerabilityDetailCode__c, VulnerabilityTypeID__c from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c = : toBecanceldAppt.id];
                        System.debug('EON_Appointment_Vulnerability__c ' + appvul);
                        if (appvul.size() > 0) {
                            for (EON_Appointment_Vulnerability__c av: appvul) {
                                EON_Appointment_Vulnerability__c copyappvul = av.clone(false, true);
                                copyappvul.EON_Appointment_ID__c = newAPP.id;
                                copyappvul.Description__c = av.Description__c;
                                copyappvul.VulnerabilityDetailCode__c = av.VulnerabilityDetailCode__c;
                                copyappvul.VulnerabilityTypeID__c = av.VulnerabilityTypeID__c;
                                appvuls.add(copyappvul);
                            }
                            system.debug('Before inserting the appointmnet vulnerability ' + appvuls);
                            insert appvuls;
                        }
                        //Clone child EON Appointment Comms 
                        list < EON_Appointment_Comms__c > appcomms = new list < EON_Appointment_Comms__c > ();
                        List < EON_Appointment_Comms__c > appcomm = [select id, name, Comm_Type_Code__c, Delivery_Method_Desc__c from EON_Appointment_Comms__c where EON_Appointment_ID__c = : toBecanceldAppt.id];
                        if (appcomm.size() > 0) {
                            for (EON_Appointment_Comms__c ac: appcomm) {
                                EON_Appointment_Comms__c copyappcomm = ac.clone(false, true);
                                copyappcomm.EON_Appointment_ID__c = newAPP.id;
                                copyappcomm.Comm_Type_Code__c = ac.Comm_Type_Code__c;
                                copyappcomm.Delivery_Method_Desc__c = ac.Delivery_Method_Desc__c;
                                appcomms.add(copyappcomm);
                            }
                            insert appcomms;
                        }
                        //Clone child EON Appointment Contacts 
                        list < EON_Appointment_Contact__c > appcontacts = new list < EON_Appointment_Contact__c > ();
                        List < EON_Appointment_Contact__c > appcontact = [select id, name, Contact_Full_Name__c, Contact_Type__c, Customer_Assistant__c, Media_Detail__c, Media_Type__c from EON_Appointment_Contact__c where EON_Appointment_ID__c = : toBecanceldAppt.id];
                        if (appcontact.size() > 0) {
                            for (EON_Appointment_Contact__c ac: appcontact) {
                                EON_Appointment_Contact__c copyappcontact = ac.clone(false, true);
                                copyappcontact.EON_Appointment_ID__c = newAPP.id;
                                copyappcontact.Contact_Full_Name__c = ac.Contact_Full_Name__c;
                                copyappcontact.Contact_Type__c = ac.Contact_Type__c;
                                copyappcontact.Customer_Assistant__c = ac.Customer_Assistant__c;
                                copyappcontact.Media_Detail__c = ac.Media_Detail__c;
                                copyappcontact.Media_Type__c = ac.Media_Type__c;
                                appcontacts.add(copyappcontact);
                            }
                            insert appcontacts;
                        }
                        //Clone child EON_Appointment_Attribute__c
                        list < EON_Appointment_Attribute__c > appattributes = new list < EON_Appointment_Attribute__c > ();
                        List < EON_Appointment_Attribute__c > appattribute = [select id, name, Job_Attribute__c, Value__c, Inactive__c, SME_Duration__c from EON_Appointment_Attribute__c where EON_Appointment_ID__c = : toBecanceldAppt.id];
                        if (appattribute.size() > 0) {
                            for (EON_Appointment_Attribute__c aa: appattribute) {
                                EON_Appointment_Attribute__c copyappattribute = aa.clone(false, true);
                                copyappattribute.EON_Appointment_ID__c = newAPP.id;
                                copyappattribute.Job_Attribute__c = aa.Job_Attribute__c;
                                copyappattribute.Value__c = aa.Value__c;
                                copyappattribute.Inactive__c = aa.Inactive__c;
                                copyappattribute.SME_Duration__c = aa.SME_Duration__c;
                                appattributes.add(copyappattribute);
                            }
                            insert appattributes;
                        }
                        //CH25.End
                                                
                        if(ApexPages.CurrentPage().getParameters().get('replan') != 'yes'){
                            PageReference updatePage = Page.EON_DisplayCapacitiesFromOFSC;
                            updatePage.getParameters().put('appID', newAPP.Id);
                            updatePage.getParameters().put('jobcode', newAPP.Job_Code__c);
                            updatePage.getParameters().put('bucketID', oracleBucket);
                            if (toBecanceldAppt.h_Appointment_Reason__c != null) {updatePage.getParameters().put('appReason', toBecanceldAppt.h_Appointment_Reason__c);} //CH30
                            else {updatePage.getParameters().put('appReason', '');} //CH30
                            updatePage.setRedirect(true);
                            return updatePage;
                        }
                        //CH51.Start
                        else{
                            PageReference replanPage = Page.EON_Create_Appointment_Replan;
                            replanPage.getParameters().put('appointmentID', newAPP.Id);
                            replanPage.setRedirect(true);
                            return replanPage;
                        }
                        //CH51.End
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, result));
                    }
                }
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No Rescheduled Appointment Cancel Reason found. ' + ex.getMessage()));
        }
        return null;
    }
    //CH05.End
    /**
        searchWrap: this method will initialize the search wrap.
    **/
    public SearchWrapper searchWrap { // to hold the search string
        get {
            if (searchWrap == null)
                searchWrap = new SearchWrapper();
            return searchWrap;
        }
        set;
    }

    /**
        eonAppSearchResults: this method will initialize the eonAppSearchResults.
    **/
    public List < EON_Appointment__c > eonAppSearchResults {
        get {
            if (eonAppSearchResults == null)
                eonAppSearchResults = new List < EON_Appointment__c > ();
            return eonAppSearchResults;
        }
        set;
    }

    /**
        eonFuelSearchResults: this method will initialize the eonFuelSearchResults.
    **/
    public List < EON_Fuel__c > eonFuelSearchResults {
        get {
            if (eonFuelSearchResults == null)
                eonFuelSearchResults = new List < EON_Fuel__c > ();
            return eonFuelSearchResults;
        }
        set;
    }

    //CH02.Start
    //CH05.Start
    public String selAppointmentID { // to hold the selected id on page
        get {
            Map < String, String > mapParam = new Map < String, String > ();
            mapParam = ApexPages.CurrentPage().getParameters();
            if (mapParam != null && mapParam.containsKey('AppointmentID'))
                selAppointmentID = ApexPages.CurrentPage().getParameters().get('AppointmentID');
            else
                selAppointmentID = null;
            return selAppointmentID;
        }
        set;
    }
    //CH05.End

    public boolean isIndustrySection {
        get;
        set;
    } // to render the pages for Industry and Isis
    public String callingFrom {
        get;
        set;
    }
    public IndustryElectricityData industryEleData {
        get;
        set;
    }
    public IndustryGasData industryGasData {
        get;
        set;
    }
    public boolean isIndustrySearch {
        get;
        set;
    }

    //CH05.Start
    public String appointmentReason { //To hold Appointment Reason in Industry section.
        get {
            if (appointmentReason == null)
                appointmentReason = '';
            return appointmentReason;
        }
        set;
    }
    public String jobCodesSearched { //To hold EON Job selected in Industry section.
        get {
            if (jobCodesSearched == null)
                jobCodesSearched = '';
            return jobCodesSearched;
        }
        set;
    }

    public Map < Id, EON_Job__c > mapOfJobCodes {
        get;
        set;
    }
    public boolean isPortfolioSection {
        get;
        set;
    } //CH05 For the new tab portfolio
    //CH05.End
    
     public boolean dspIndustryBtn {
        get;
        set;
    }

    /**
        EON_Appointment_Booking_Ctrl() : Default constructor.
    **/
    public EON_Appointment_Booking_Ctrl() {
        areWeNotMAM = false; //CH21
        isAppointmentCreated = false; //CH10 
        fuelType = ''; //CH17        
        isIndustrySection = false;
        isIndustrySearch = false;
        isPortfolioSection = false; //CH05
        callingFrom = ((callingFrom == '' || callingFrom == null) ? 'Isis' : callingFrom); //CH05
        industryEleData = new IndustryElectricityData();
        industryGasData = new IndustryGasData();
        allApptMeter = new list<EON_Appointment_Meter__c>(); //CH42.New
        
        //CH50.Start
        if(System.currentPageReference().getParameters().ContainsKey('mpan') && System.currentPageReference().getParameters().ContainsKey('mprn')){
           isIndustrySection = true;
            dspIndustryBtn = true;
          }
        //CH50.End  
    }

    //CH05.Start
    /**
        getSelectedJobCodes() : Method to return all EON Jobs after selecting Appointment Reason on the Industry Tab.
    **/
    public List < SelectOption > getSelectedJobCodes() {
        List < SelectOption > SelectedJobCodes = new List < SelectOption > ();
        SelectedJobCodes.add(new SelectOption('', '-- Select Job Code --'));
        if (appointmentReason != null && appointmentReason != '') {
            boolean isJobcodeOOAEINSTALLBIND = false;//CH46
            String jobIDOOAEINSTALLBIND = '';//CH46
            
            list < Eon_Appointment_Reason__c > Listreason = [select id, name from Eon_Appointment_Reason__c where id = : appointmentReason];
            list < EON_Job_Appointment_Reason__c > jobsList = new list < EON_Job_Appointment_Reason__c > (); //CH22
            if (Listreason != null && Listreason.size() > 0) {
                ApptReason = Listreason[0].name;
                jobsList = [Select job__c from EON_Job_Appointment_Reason__c where Appointment_Reason__c = : Listreason[0].id]; //CH21
            }
            set < ID > jobsSet = new set < ID > ();
            for (EON_Job_Appointment_Reason__c app: jobsList) {
                jobsSet.add(app.job__c);
            }
            mapOfJobCodes = new Map < Id, EON_Job__c > ([Select id, Name, Job_Type__c, MPAN_Reqd__c, MPRN_Reqd__c from EON_Job__c where id IN: jobsSet]); //CH21//CH22
            String jobName = '';
            for (EON_Job__c job: mapOfJobCodes.values()) {
                //CH46.Start
                if(job.Name == 'OOAEINSTALLBIND'){
                    isJobcodeOOAEINSTALLBIND = true;
                    jobIDOOAEINSTALLBIND = job.id;
                }
                //CH46.End
            
                if (searchWrap.MPAN != '' && job.MPAN_Reqd__c && searchWrap.MPRN != '' && job.MPRN_Reqd__c)
                    SelectedJobCodes.add(new SelectOption(job.id, job.Name));
                if (job.MPAN_Reqd__c == false && job.MPRN_Reqd__c == false)
                    SelectedJobCodes.add(new SelectOption(job.id, job.Name));
                if (searchWrap.MPAN != '' && job.MPAN_Reqd__c && (searchWrap.MPRN == '' || searchWrap.MPRN == 'false') && job.MPRN_Reqd__c == false)
                    SelectedJobCodes.add(new SelectOption(job.id, job.Name));
                if (searchWrap.MPRN != '' && job.MPRN_Reqd__c && job.MPAN_Reqd__c == false && (searchWrap.MPAN == '' || searchWrap.MPAN == 'false'))
                    SelectedJobCodes.add(new SelectOption(job.id, job.Name));
            }
            
            //CH46.Start
            if(searchWrap.MPAN != '' && searchWrap.MPRN != '' && isJobcodeOOAEINSTALLBIND){
                boolean isExist = false;
                for(SelectOption option : SelectedJobCodes){
                    if(option.getlabel() == 'OOAEINSTALLBIND'){
                        isExist = true;
                        break;
                    }
                }
                if(isExist == false)
                    SelectedJobCodes.add(new selectOption(jobIDOOAEINSTALLBIND, 'OOAEINSTALLBIND'));
            }
            //CH46.End
            
            System.debug('size check' + SelectedJobCodes.size() + 'contains ' + SelectedJobCodes);
            if (mapOfJobCodes.isEmpty() || (ApptReason == 'Maintenance' && (SelectedJobCodes != null && SelectedJobCodes.size() == 0)) || (ApptReason == 'Emergency Call Out' && (SelectedJobCodes != null && SelectedJobCodes.size() == 0))) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No Job Codes available, please contact MUS back office.'));
                System.debug('***** inside error');
                return null;
            }
        }
        System.debug('*****SelectedJobCodes ' + SelectedJobCodes);
        return SelectedJobCodes;
    }

    /**
        selectedJobs() : Method When the Appointment Reason is selected on the Industry tab, to return the available Job Codes
    **/
    public pageReference selectedJobs() {
        jobCodesSearched = '';
        if (appointmentReason == null || appointmentReason == '') {isIndustryCreateApp = false;}
        else {
            if (jobCodesSearched == null || jobCodesSearched == '') {isIndustryCreateApp = false;} else {isIndustryCreateApp = true;}
            getSelectedJobCodes();
        }

        return null;
    }
    //CH05.End
    /**
        IndustryElectricityData: This is the wrapper class will holds the data for electricity Data
    **/
    public class IndustryElectricityData {
        public String mopStatus {
            get;
            set;
        } // holds the mopStatus
        public String customerName {
            get;
            set;
        } // holds the customer Name
        public String contactNumber {
            get;
            set;
        } // holds the Contact Number
        public String postCode {
            get;
            set;
        } // holds the post code
        public String phase {
            get;
            set;
        } // holds the phase
        public String meteringPointAddressLine1 {
            get;
            set;
        } // electricity meter point Address
        public String meteringPointAddressLine2 {
            get;
            set;
        } // electricity meter point Address
        public String meteringPointAddressLine3 {
            get;
            set;
        } // electricity meter point Address
        public String meteringPointAddressLine4 {
            get;
            set;
        } // electricity meter point Address
        public String meteringPointAddressLine5 {
            get;
            set;
        } // electricity meter point Address
        public String meteringPointAddressLine6 {
            get;
            set;
        } // electricity meter point Address
        public String meteringPointAddressLine7 {
            get;
            set;
        } // electricity meter point Address
        public String meteringPointAddressLine8 {
            get;
            set;
        } // electricity meter point Address
        public String meteringPointAddressLine9 {
            get;
            set;
        } // electricity meter point Address
        //CH43.Start.New
        public Date effectiveFromDate {
            get;
            set;
        }
        public Date effectiveToDate {
            get;
            set;
        }
        //CH43.Start.End
    }

    /**
        IndustryGasData: This is the wrapper class will holds the data for Gas Data
    **/
    public class IndustryGasData {
        public String mamStatus {
            get;
            set;
        } // holds the mopStatus
        public String customerName {
            get;
            set;
        } // holds the customer Name
        public String contactNumber {
            get;
            set;
        } // holds the Contact Number
        public String postCode {
            get;
            set;
        } // holds the post code
        public String addressText {
            get;
            set;
        } // holds the phase
        public String SubBuildingNameNumber {
            get;
            set;
        } // electricity meter point Address
        public String BuildingNameNumber {
            get;
            set;
        } // electricity meter point Address
        public String DependentThoroughfare {
            get;
            set;
        } // electricity meter point Address
        public String Thoroughfare {
            get;
            set;
        } // electricity meter point Address
        public String DoubleDependentLocality {
            get;
            set;
        } // electricity meter point Address
        public String DependentLocality {
            get;
            set;
        } // electricity meter point Address
        public String PostTown {
            get;
            set;
        } // electricity meter point Address
        public String County {
            get;
            set;
        } // electricity meter point Address
        //CH43.Start.New
        public Date effectiveFromDate {
            get;
            set;
        }
        public Date effectiveToDate {
            get;
            set;
        }
        //CH43.Start.End
    }
    //CH02.End

    /**
        SearchWrapper: This is the wrapper class will help users to allow the search and hold the search string.
    **/
    public class SearchWrapper {
        public String customerName {
            get;
            set;
        } // holds the customer Name
        public String accountElect {
            get;
            set;
        } // Customer electric account reference
        public String accountGas {
            get;
            set;
        } // Customer Gas Reference
        public String postCodeS {
            get;
            set;
        } // Site Post Code
        //public String postCodec {get;set;} // Contact Post Code // CH05.Commented as the Instance has noe bwwn removed
        public String appointmentID {
            get;
            set;
        } // Appointment ID
        public String MPAN {
            get;
            set;
        } // MPAN //CH02
        public String MPRN {
            get;
            set;
        } // MPRN //CH02
    }

    /**
        geteonAppSearchResult(): This method will get the search result, first it search in EON_Appointment__c object if results are null then it will search in EON_Fuel__c
    object with same criteria.  
    **/
    public PageReference geteonAppSearchResult() {
        resultIds.clear(); //CH48.New
        allApptMeter.clear(); //CH48.New
        AssignInOptimus=false;//CH55                
        system.debug('calling From = ' + callingFrom + ', searchWrap = ' + searchWrap);
        eonAppSearchResults.clear(); // clear the previous search results
        eonFuelSearchResults.clear(); // clear the previous search results
        eonAppSearchResults = new List < EON_Appointment__c > (); // re declaration
        eonFuelSearchResults = new List < EON_Fuel__c > (); // re declaration
        industryEleData = new IndustryElectricityData(); // CH02
        industryGasData = new IndustryGasData(); //CH02
        try {
            if (callingFrom != '' && callingFrom != null && callingFrom.equalsIgnoreCase('Industry')) {
                isAppointmentCreated = false;
                isIndustrySearch = true;
                jobCodesSearched = null;
                appointmentReason = null;
                apptReason = null;
                isIndustryCreateApp = false;
                areWeNotMAM = false; //CH21
                //CH05.Start
                String results = populateElectricityGasData(searchWrap);
                if (results != '' || results.containsIgnoreCase('Reject')) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, results)); isIndustryCreateApp = false;}
            } else {
                if (callingFrom != '' && callingFrom != null && callingFrom.equalsIgnoreCase('Isis')) {
                    isIndustrySearch = false;
                    // the string holds the default query of EON Appointment object 
                    String whereQuery = '', searchQuery = 'SELECT Id,Name,Post_Code__c,Status__c,Job_Code__c,Job_Code__r.Duration__c,Job_Code__r.Name,Job_Code__r.Assign_in_OptiMUS__c,Job_Code__r.Description__c,Fuel_ID__c,Fuel_ID__r.Name,Fuel_ID__r.Premise__c,h_SelectRadio__c,MPAN__c,MPRN__c,Metering_Point_Postcode__c,Appointment_Date__c,h_CountVulnerability__c ,Customer_Name__c FROM EON_Appointment__c';
                    //CH01 Amended the relationship names, Premise__c,Premise__r from Premise_ID__c,Premise_ID__r and Customer__c ,Customer__r from Customer_ID__c, Customer_ID__c
                    //CH02 added two new fields MPAN and MPRN in query
                    //CH05 added relationship fields in the query : 'Fuel_ID__r.Premise__r.Address_Type__c','Appointment_Date__c', 'Metering_Point_Postcode__c' ,'Post_Code__c'
                    whereQuery = prepareQueryString(searchWrap, true); // calling the method for preparing the query string for conditions.
                    if (whereQuery != '') { // where query is not blank
                        searchQuery += ' WHERE ' + whereQuery; // concatinate the query
                        System.debug('==> ' + searchQuery);
                        eonAppSearchResults = Database.query(searchQuery + ' LIMIT 1000'); // query the records from EON Appointment
                        if (eonAppSearchResults.isEmpty()) { // CH02 added the MPAN & MPRN condition
                            // display the error message if appointment id is null
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records are available for above search.'));
                        }
                    } else { // if where query is blank then populate the error message.
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please populate at least one search condition.'));
                    }
                } else if (callingFrom != '' && callingFrom != null && callingFrom.equalsIgnoreCase('Portfolio')) {
                    isIndustrySearch = false;
                    String whereQueryFuel = '', searchQueryFuel = '';
                    Set < Id > fuelParentIds = new Set < Id > ();
                    // search query on EON Fuel object
                    searchQueryFuel = 'SELECT Id,Name,Premise__c,Premise__r.Name,Premise__r.Customer__r.Campaign_Flag__c,Premise__r.Customer__c,Premise__r.Customer__r.Name,Premise__r.Postcode__c,h_SelectRadio__c,Premise__r.Customer__r.Customer_Name__c, Premise__r.h_FullAddress__c,Premise__r.Address_Type__c,Fuel_type__c FROM EON_Fuel__c';
                    //CH01 Amended the relationship names, Premise__c,Premise__r from Premise_ID__c,Premise_ID__r and Customer__c ,Customer__r from Customer_ID__c, Customer_ID__c
                    //CH05. Added 'Premise__r.h_FullAddress__c' and 'Premise__r.Address_Type__c' to the query.
                    whereQueryFuel = prepareQueryString(searchWrap, false); // calling the method for preparing the string.

                    if (whereQueryFuel != '') { // where query is not blank
                        searchQueryFuel += ' WHERE ' + whereQueryFuel; // concatinate the query
                        System.debug('==> ' + searchQueryFuel);
                        eonFuelSearchResults = Database.query(searchQueryFuel + ' LIMIT 1000'); // query the records from EON Fuel   
                        if (eonFuelSearchResults != null && eonFuelSearchResults.size() > 0) {
                            for (EON_Fuel__c fuelObj: eonFuelSearchResults)
                                fuelParentIds.add(fuelObj.Premise__c);
                            mapCount = new Map < Id, EON_Site__c > ();
                            List < EON_Site__c > siteList = new List < EON_Site__c > ();
                            if (fuelParentIds != null && fuelParentIds.size() > 0)
                                siteList = [Select ID, (Select id from EON_Vulnerabilities__r), (Select id, Opt_In_Opt_Out_Preference__c from EON_Opt_in_Opt_Out_Preferences__r Where Opt_In_Opt_Out_Preference__c = true) FROM EON_Site__c WHERE ID IN: fuelParentIds]; //CH06.
                            for (EON_Site__c esite: siteList)
                                mapCount.put(esite.id, esite);
                        }
                        if (eonFuelSearchResults.isEmpty()) { // CH02 added the MPAN & MPRN condition .display the error message if appointment id is null
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records are available for above search.'));
                        }
                    } else { // if where query is blank then populate the error message.
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please populate at least one search condition.'));
                    } //CH05.End                   
                }
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return null;
    }

    /**
        isBlankVal(String strVal): This method will return the TRUE when parameter is not null and not blank else FALSE
    **/
    private boolean isBlankVal(String strVal) {
        if (strVal != null && strVal != '') {
            return true;
        } else return false;
    }

    /**
        prepareQueryString(): This method will return the query string which the conditions based on search criteria
    **/
    private String prepareQueryString(SearchWrapper searchWrapp, boolean isApp) {
        String queryStr = '';
        //CH05.New.Start . Amended the search functionality
        if (searchWrapp != null) {
            if (isBlankVal(searchWrapp.customerName)) { //CH01 Amended the relationship names, Premise__c,Premise__r from Premise_ID__c,Premise_ID__r and Customer__c ,Customer__r from Customer_ID__c, Customer_ID__c
                queryStr = ((isApp) ? 'Customer_Name__c' : 'Premise__r.Customer__r.Customer_Name__c') + ' LIKE \'%' + searchWrapp.customerName.trim() + '%\'';
            }
            if (isBlankVal(searchWrapp.accountElect)) {
                queryStr += ((queryStr != '') ? ' AND ' : '');
                queryStr += ((isApp) ? '' : 'Customer_electric_account_reference__c') + ' LIKE \'%' + searchWrapp.accountElect.trim() + '%\'';
            }
            if (isBlankVal(searchWrapp.accountGas)) {
                queryStr += ((queryStr != '') ? ' AND ' : '');
                queryStr += ((isApp) ? '' : 'Customer_Gas_Account_Reference__c') + ' LIKE \'%' + searchWrapp.accountGas.trim() + '%\'';
            }
            //CH04.Old.Start C_PostCode__c is deleted at object 'EON Site'
            if (isBlankVal(searchWrapp.postCodeS)) {
                queryStr += ((queryStr != '') ? ' AND ' : '');
                if (isApp) {
                    queryStr += '(Metering_Point_Postcode__c LIKE \'%' + searchWrapp.postCodeS.trim() + '%\' OR Post_Code__c  LIKE \'%' + searchWrapp.postCodeS.trim() + '%\') ';
                } else {
                    queryStr += 'Premise__r.Postcode__c LIKE \'%' + searchWrapp.postCodeS.trim() + '%\'';
                }
            }
            //CH01.Old.Start
            if (isBlankVal(searchWrapp.MPAN)) {
                queryStr += ((queryStr != '') ? ' AND ' : '');
                queryStr += 'MPAN__c LIKE \'%' + searchWrapp.MPAN.trim() + '%\'';
            }
            if (isBlankVal(searchWrapp.MPRN)) {
                queryStr += ((queryStr != '') ? ' AND ' : '');
                queryStr += 'MPRN__c LIKE \'%' + searchWrapp.MPRN.trim() + '%\'';
            }
            //CH01.Old.End
            if (isBlankVal(searchWrapp.appointmentID)) {
                queryStr += ((queryStr != '') ? ' AND ' : '');
                queryStr += 'Name LIKE \'%' + searchWrapp.appointmentID.trim() + '%\'';
            }
        }
        return queryStr;
    }
    //CH05.New.End
    //CH02.Start
    /**
        renderSections(): this method will call when user hits the buttons Industry or Isis
    **/
    public PageReference renderSections() {
        System.debug('callingFrom = ' + callingFrom);
        eonFuelSearchResults.clear();
        eonAppSearchResults.clear();
        searchWrap = new SearchWrapper();
        industryEleData = new IndustryElectricityData();
        industryGasData = new IndustryGasData();
        eonAppSearchResults = new List < EON_Appointment__c > (); // re declaration
        eonFuelSearchResults = new List < EON_Fuel__c > (); // re declaration
        //CH05.Start
        if (callingFrom != '' && callingFrom != null) {
            if (callingFrom.equalsIgnoreCase('Isis')) {
                isIndustrySearch = false;
                isIndustrySection = false;
                isPortfolioSection = false;
            } else if (callingFrom.equalsIgnoreCase('industry')) {
                isAppointmentCreated = false;
                isIndustrySearch = false;
                isIndustrySection = true;
                isPortfolioSection = false;
            } else if (callingFrom.equalsIgnoreCase('Portfolio')) {
                isIndustrySearch = false;
                isIndustrySection = false;
                isPortfolioSection = true;
            }
        }
        //CH05.End
        System.debug('isIndustrySection: ' + isIndustrySection);
        return null;
    }
    //CH05.New.Start
    /**
        processAppointmentRequest(): this method will validate the Fuel type and gets the Job code and Job type and Job Attributes for allowing user to select job attributes.
    **/
    public PageReference processAppointmentRequest() {
        Map < String, String > mapFuelJobCode = new Map < String, String > {
            'D' => 'OOASMARTDFEXCH', 'E' => 'OOASMARTELECEXCH'
        }; //Changing DF to D as requested in SR_EON_PC_068
        if (callingFrom != '' && callingFrom != null && callingFrom.equalsIgnoreCase('Portfolio')) {
            for (EON_Fuel__c fuel: eonFuelSearchResults) {
                if (fuel.h_SelectRadio__c) {
                    if (fuel.Fuel_type__c != null && fuel.Fuel_type__c.equalsIgnoreCase('D') || fuel.Fuel_type__c.equalsIgnoreCase('E')) { //Changing DF to D as requested in SR_EON_PC_068
                        jobCode = mapFuelJobCode.get(fuel.Fuel_type__c);
                        availableJobAttributes = [SELECT ID, Name, Value__c, Duration__c, h_Is_Selected__c FROM EON_Job_Attribute__c WHERE Eon_Job__r.Name = : jobCode];
                        //checkValidityForOFSC(String.UpperCase(fuel.Fuel_type__c),null,fuel.MPAN__c,fuel.MPRN__c,fuel.Premise__r.Postcode__c);
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Rejected we are not MAM.'));
                    }
                    break;
                }
                System.debug('fuel = ' + fuel);
            }
        }
        return null;
    }
    /**
        populateElectricityGasData() : This method will populate the data in MPAN and MPRN data values.
    **/
public String populateElectricityGasData(SearchWrapper searchWrapp) {
        String errorMsg = '';
        String resultMsg = '';
        allowBooking = false;//CH43
        JUMBO_Data_Tracker__c juboData = new JUMBO_Data_Tracker__c(); //CH21
    	MDS_Data_Tracker__c MDSData = new MDS_Data_Tracker__c(); //CH56
        System.debug(' areWeNotMAM = ' + areWeNotMAM);
        try {
            //CH56.Start
            switchData = EON_MDS_Utility.getMDS_Jumbo_Status();
            System.debug('###############switchData: '+switchData);
            if(switchData == system.label.Jumbo_Shortform) {
                List < JUMBO_Data_Tracker__c > jumboDataTrackLst = new List < JUMBO_Data_Tracker__c > ();
                newAppointment = new EON_Appointment__c();
                if (searchWrapp != null && searchWrapp.MPAN != null && searchWrapp.MPAN != '') {
                    industryEleData.mopStatus = 'InActive';
                    EON_Jumbo_ReqElectricityMOP.MOPValidationResponse mopCheck = EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP(searchWrapp.MPAN.trim());
                    errorMsg += mopCheck.Error;
                    System.debug('==>@#@#==>1 => ' + errorMsg);
                    juboData = EON_Jumbo_ReqElectricityMOP.cTrack;
                    if (juboData != null)
                        jumboDataTrackLst.add(juboData);
                    //CH29
                    //if (mopCheck != null && !mopCheck.isError && mopCheck.effFromDate != null && mopCheck.effFromDate <= Date.today() && (mopCheck.effToDate == null || mopCheck.effToDate >= Date.today())){//CH43.OLD
                    if (mopCheck != null && !mopCheck.isError && mopCheck.effFromDate != null && (mopCheck.effToDate == null || mopCheck.effToDate >= Date.today())){   
                        //CH43.Start.New
                        allowBooking = true;
                        if(mopCheck.effFromDate <= Date.today())
                            industryEleData.mopStatus = 'Active';
                        industryEleData.effectiveFromDate = mopCheck.effFromDate;
                        industryEleData.effectiveToDate = mopCheck.effToDate;
                        newAppointment.Market_Participant_ID__c = mopCheck.marParticipantId; //CH54
                        //CH43.End.New
                        //CH21.Start
                        EON_Jumbo_ReqElecMeterPointData.AccessElecMeterPointData(searchWrapp.MPAN.trim(), newAppointment, '', '');
                        //CH42.Start
                        if(!EON_Jumbo_ReqElecMeterPointData.isError){
                            if(EON_Jumbo_ReqElecMeterPointData.allApptMeter != null && EON_Jumbo_ReqElecMeterPointData.allApptMeter.size() > 1){
                                allApptMeter.addAll(EON_Jumbo_ReqElecMeterPointData.allApptMeter);
                            }
                        }
                        //CH42.End
                        newAppointment = EON_Jumbo_ReqElecMeterPointData.apptIns;
                        newAppointment.Effective_From_Date__c = mopCheck.effFromDate;
                        newAppointment.Effective_To_Date__c = mopCheck.effToDate;
                        System.debug('==>MPAN newAppointment ' + newAppointment.Customer_Name__c + ', newAppointment= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.E_Meter_Type__c);
                        newAppointment.MPAN__c = searchWrapp.MPAN.trim();
                        errorMsg += EON_Jumbo_ReqElecMeterPointData.Errors;
                        System.debug('==>@#@#==> ' + EON_Jumbo_ReqElecMeterPointData.Errors + ', => ' + errorMsg);
                        juboData = new JUMBO_Data_Tracker__c();
                        juboData = EON_Jumbo_ReqElecMeterPointData.cTrack;
                        if (juboData != null)
                            jumboDataTrackLst.add(juboData);
                        //CH21.End
                        industryEleData.customerName = newAppointment.Customer_Name__c;
                        industryEleData.contactNumber = String.Valueof(newAppointment.Contact_Number__c);
                        industryEleData.postCode = newAppointment.Metering_Point_Postcode__c; //newAppointment.Post_Code__c;//testing change
                        if(newAppointment.Current_Phase__c != null && newAppointment.Current_Phase__c != '' && newAppointment.Current_Phase__c == '3Ph'){industryEleData.phase = newAppointment.Current_Phase__c;} //CH33
                        else{industryEleData.phase = newAppointment.Number_of_Phases__c;}
                        industryEleData.meteringPointAddressLine1 = newAppointment.Metering_Point_Address_Line_1__c;
                        industryEleData.meteringPointAddressLine2 = newAppointment.Metering_Point_Address_Line_2__c;
                        industryEleData.meteringPointAddressLine3 = newAppointment.Metering_Point_Address_Line_3__c;
                        industryEleData.meteringPointAddressLine4 = newAppointment.Metering_Point_Address_Line_4__c;
                        industryEleData.meteringPointAddressLine5 = newAppointment.Metering_Point_Address_Line_5__c;
                        industryEleData.meteringPointAddressLine6 = newAppointment.Metering_Point_Address_Line_6__c;
                        industryEleData.meteringPointAddressLine7 = newAppointment.Metering_Point_Address_Line_7__c;
                        industryEleData.meteringPointAddressLine8 = newAppointment.Metering_Point_Address_Line_8__c;
                        industryEleData.meteringPointAddressLine9 = newAppointment.Metering_Point_Address_Line_9__c;
                    }
                }
                if (searchWrapp != null && searchWrapp.MPRN != null && searchWrapp.MPRN != '') {
                    if (searchWrapp != null && searchWrapp.MPAN != null) {
                        newAppointment = newAppointment;
                    }
                    System.debug(' 0 areWeNotMAM = ' + areWeNotMAM);
                    EON_Jumbo_ReqGasMAM.MAMValidationResponse mamCheck = EON_Jumbo_ReqGasMAM.ValidateMPRNMAM(searchWrapp.MPRN.trim());
                    errorMsg += mamCheck.Error;
                    juboData = new JUMBO_Data_Tracker__c();
                    juboData = EON_Jumbo_ReqGasMAM.cTrack;
                    if (juboData != null)
                        jumboDataTrackLst.add(juboData);
                    System.debug(' 0 mamCheck = ' + mamCheck);
                    //CH29                     
                    //if (mamCheck != null & !mamCheck.isError && mamCheck.effFromDate != null && mamCheck.effFromDate <= Date.today() && (mamCheck.effToDate == null || mamCheck.effToDate >= Date.today())) {//CH43.OLD
                    if (mamCheck != null & !mamCheck.isError && mamCheck.effFromDate != null && (mamCheck.effToDate == null || mamCheck.effToDate >= Date.today())) {     //CH43.NEW
                        //CH43.Start.New
                        allowBooking = true;
                        if(mamCheck.effFromDate <= Date.today()) 
                            industryGasData.mamStatus = 'Active';
                        else
                            industryGasData.mamStatus = 'InActive';
                        industryGasData.effectiveFromDate = mamCheck.effFromDate;
                        industryGasData.effectiveToDate = mamCheck.effToDate;
                        //CH43.End.New
                    }
                    else {industryGasData.mamStatus = 'InActive';}
                    if (Test.isRunningTest()) {industryGasData.mamStatus = 'Active';}
                    if ((industryGasData.mamStatus == 'Active' || allowBooking) && EON_Appointment_Booking_Ctrl_Test.genException == false) {//CH43
                        //CH21.start
                        EON_Jumbo_ReqGasMeterPointData.AccessGasMeterPointData(searchWrapp.MPRN.trim(), newAppointment, '', '');
                        newAppointment = EON_Jumbo_ReqGasMeterPointData.apptIns;
                        newAppointment.G_Effective_From_Date__c = mamCheck.effFromDate;
                        newAppointment.G_Effective_To_Date__c = mamCheck.effToDate;
                        if (!EON_Utility.validateRequired(mamCheck.abbrvtdName)){newAppointment.Gas_Market_Participant_ID__c = mamCheck.abbrvtdName;} //CH34
                        newAppointment.MPRN__c = searchWrapp.MPRN.trim();
                        errorMsg += EON_Jumbo_ReqGasMeterPointData.Errors;
    
                        juboData = new JUMBO_Data_Tracker__c();
                        juboData = EON_Jumbo_ReqGasMeterPointData.cTrack;
                        if (juboData != null)
                            jumboDataTrackLst.add(juboData);
                        //CH21.End
    
                        industryGasData.customerName = newAppointment.Person_Name__c;
                        industryGasData.contactNumber = String.Valueof(newAppointment.Contact_Number__c);
                        industryGasData.postCode = newAppointment.Post_Code__c;
                        industryGasData.addressText = '';
                        industryGasData.SubBuildingNameNumber = newAppointment.Sub_Building_Name__c;
                        industryGasData.BuildingNameNumber = ((newAppointment.Building_Number__c != null) ? newAppointment.Building_Number__c : '') + ' ' + ((newAppointment.Building_Name__c != null) ? newAppointment.Building_Name__c : '');
                        industryGasData.DependentThoroughfare = newAppointment.Dependent_Thorofare__c;
                        industryGasData.Thoroughfare = newAppointment.Thorofare__c;
                        industryGasData.DoubleDependentLocality = newAppointment.Double_dependant_Locality__c;
                        industryGasData.DependentLocality = newAppointment.Dependant_Locality__c;
                        industryGasData.PostTown = newAppointment.Post_Town__c;
                        industryGasData.County = newAppointment.County__c;
                    } //CH21.start
                    else if (mamCheck != null) {
                        List < EON_Fuel__c > lstFuel = Database.query('SELECT Id,Name FROM EON_Fuel__c WHERE MPRN__c =\'' + searchWrapp.MPRN.trim() + '\' AND MPAN__c = ' + (String.isNotBlank(searchWrapp.MPAN) ? '\'' + searchWrapp.MPAN.trim() + '\'' : null));
                        if (lstFuel != null && lstFuel.size() == 1)
                            areWeNotMAM = true;
                        System.debug(' 1 areWeNotMAM = ' + areWeNotMAM);
                    } //CH21.End
    
                }
                System.debug('==>MPAN newAppointment ' + newAppointment.Customer_Name__c + ', newAppointment= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.E_Meter_Type__c);
                System.debug('==>MPRN newAppointment , newAppointment= ' + newAppointment.Planned_G_Meter_Type__c + ', ' + newAppointment.G_Meter_Type__c);
                if (jumboDataTrackLst != null && jumboDataTrackLst.size() > 0) {
                    insert jumboDataTrackLst;
                    for (JUMBO_Data_Tracker__c jmbTrck: jumboDataTrackLst) {
                        resultIds.add(jmbTrck.id);
                    }
                    List < JUMBO_Data_Tracker__c > existingJumboDataTrack = new List < JUMBO_Data_Tracker__c > ();
                    existingJumboDataTrack = [SELECT ID, NAME FROM JUMBO_Data_Tracker__c where id in : resultIds AND Status__c = 'FAIL'];
                    if (existingJumboDataTrack != null && existingJumboDataTrack.size() > 0) {
                        resultMsg = 'A System error has occurred while processing your request. Please try again. If the problem persists, contact your administrator with reference number : ' + existingJumboDataTrack[0].name;
                        if (existingJumboDataTrack.size() == 2) {
                            resultMsg = resultMsg + ' and ' + existingJumboDataTrack[1].name;
                        }
                    }
                }
                if (errorMsg == '') {} //CH10 insert newAppointment;
                else if (errorMsg.containsIgnoreCase('Web service callout failed')) return 'A System error has occurred while processing your request. Please try again. If the problem persists, contact your administrator.';
                else
                    errorMsg = resultMsg;
            }
            else if(switchData == system.label.MDS_Shortform) {
                List < MDS_Data_Tracker__c > MDSDataTrackLst = new List < MDS_Data_Tracker__c > ();
                newAppointment = new EON_Appointment__c();
                if (searchWrapp != null && searchWrapp.MPAN != null && searchWrapp.MPAN != '') {
                    industryEleData.mopStatus = 'InActive';
                    EON_MDS_ReqElectricityMOP.MOPValidationResponse mopCheck = EON_MDS_ReqElectricityMOP.ValidateMPANMOP(searchWrapp.MPAN.trim());
                    errorMsg += mopCheck.Error;
                    System.debug('==>@#@#==>1 => ' + errorMsg);
                    MDSData = EON_MDS_ReqElectricityMOP.cTrack;
                    if (MDSData != null)
                        MDSDataTrackLst.add(MDSData);
                    //CH29
                    //if (mopCheck != null && !mopCheck.isError && mopCheck.effFromDate != null && mopCheck.effFromDate <= Date.today() && (mopCheck.effToDate == null || mopCheck.effToDate >= Date.today())){//CH43.OLD
                    if (mopCheck != null && !mopCheck.isError && mopCheck.effFromDate != null && (mopCheck.effToDate == null || mopCheck.effToDate >= Date.today())){   
                        //CH43.Start.New
                        allowBooking = true;
                        if(mopCheck.effFromDate <= Date.today())
                            industryEleData.mopStatus = 'Active';
                        industryEleData.effectiveFromDate = mopCheck.effFromDate;
                        industryEleData.effectiveToDate = mopCheck.effToDate;
                        newAppointment.Market_Participant_ID__c = mopCheck.marParticipantId; //CH54
                        //CH43.End.New
                        //CH21.Start
                        EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(searchWrapp.MPAN.trim(), newAppointment, '', '');
                        //CH42.Start
                        if(!EON_MDS_ReqElecMeterPointData.isError){
                            if(EON_MDS_ReqElecMeterPointData.allApptMeter != null && EON_MDS_ReqElecMeterPointData.allApptMeter.size() > 1){
                                allApptMeter.addAll(EON_MDS_ReqElecMeterPointData.allApptMeter);
                            }
                        }
                        //CH42.End
                        newAppointment = EON_MDS_ReqElecMeterPointData.apptIns;
                        newAppointment.Effective_From_Date__c = mopCheck.effFromDate;
                        newAppointment.Effective_To_Date__c = mopCheck.effToDate;
                        System.debug('==>MPAN newAppointment ' + newAppointment.Customer_Name__c + ', newAppointment= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.E_Meter_Type__c);
                        newAppointment.MPAN__c = searchWrapp.MPAN.trim();
                        errorMsg += EON_MDS_ReqElecMeterPointData.Errors;
                        System.debug('==>@#@#==> ' + EON_MDS_ReqElecMeterPointData.Errors + ', => ' + errorMsg);
                        MDSData = new MDS_Data_Tracker__c();
                        MDSData = EON_MDS_ReqElecMeterPointData.cTrack;
                        if (MDSData != null)
                            MDSDataTrackLst.add(MDSData);
                        //CH21.End
                        industryEleData.customerName = newAppointment.Customer_Name__c;
                        industryEleData.contactNumber = String.Valueof(newAppointment.Contact_Number__c);
                        industryEleData.postCode = newAppointment.Metering_Point_Postcode__c; //newAppointment.Post_Code__c;//testing change
                        if(newAppointment.Current_Phase__c != null && newAppointment.Current_Phase__c != '' && newAppointment.Current_Phase__c == '3Ph'){industryEleData.phase = newAppointment.Current_Phase__c;} //CH33
                        else{industryEleData.phase = newAppointment.Number_of_Phases__c;}
                        industryEleData.meteringPointAddressLine1 = newAppointment.Metering_Point_Address_Line_1__c;
                        industryEleData.meteringPointAddressLine2 = newAppointment.Metering_Point_Address_Line_2__c;
                        industryEleData.meteringPointAddressLine3 = newAppointment.Metering_Point_Address_Line_3__c;
                        industryEleData.meteringPointAddressLine4 = newAppointment.Metering_Point_Address_Line_4__c;
                        industryEleData.meteringPointAddressLine5 = newAppointment.Metering_Point_Address_Line_5__c;
                        industryEleData.meteringPointAddressLine6 = newAppointment.Metering_Point_Address_Line_6__c;
                        industryEleData.meteringPointAddressLine7 = newAppointment.Metering_Point_Address_Line_7__c;
                        industryEleData.meteringPointAddressLine8 = newAppointment.Metering_Point_Address_Line_8__c;
                        industryEleData.meteringPointAddressLine9 = newAppointment.Metering_Point_Address_Line_9__c;
                    }
                }
                if (searchWrapp != null && searchWrapp.MPRN != null && searchWrapp.MPRN != '') {
                    if (searchWrapp != null && searchWrapp.MPAN != null) {
                        newAppointment = newAppointment;
                    }
                    System.debug(' 0 areWeNotMAM = ' + areWeNotMAM);
                    EON_MDS_ReqGasMAM.MAMValidationResponse mamCheck = EON_MDS_ReqGasMAM.ValidateMPRNMAM(searchWrapp.MPRN.trim());
                    errorMsg += mamCheck.Error;
                    MDSData = new MDS_Data_Tracker__c();
                    MDSData = EON_MDS_ReqGasMAM.cTrack;
                    if (MDSData != null)
                        MDSDataTrackLst.add(MDSData);
                    System.debug(' 0 mamCheck = ' + mamCheck);
                    //CH29                     
                    //if (mamCheck != null & !mamCheck.isError && mamCheck.effFromDate != null && mamCheck.effFromDate <= Date.today() && (mamCheck.effToDate == null || mamCheck.effToDate >= Date.today())) {//CH43.OLD
                    if (mamCheck != null & !mamCheck.isError && mamCheck.effFromDate != null && (mamCheck.effToDate == null || mamCheck.effToDate >= Date.today())) {     //CH43.NEW
                        //CH43.Start.New
                        allowBooking = true;
                        if(mamCheck.effFromDate <= Date.today()) 
                            industryGasData.mamStatus = 'Active';
                        else
                            industryGasData.mamStatus = 'InActive';
                        industryGasData.effectiveFromDate = mamCheck.effFromDate;
                        industryGasData.effectiveToDate = mamCheck.effToDate;
                        //CH43.End.New
                    }
                    else {industryGasData.mamStatus = 'InActive';}
                    if (Test.isRunningTest()) {industryGasData.mamStatus = 'Active';}
                    if ((industryGasData.mamStatus == 'Active' || allowBooking) && EON_Appointment_Booking_Ctrl_Test.genException == false) {//CH43
                        //CH21.start
                        EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(searchWrapp.MPRN.trim(), newAppointment, '', '');
                        newAppointment = EON_MDS_ReqGasMeterPointData.apptIns;
                        newAppointment.G_Effective_From_Date__c = mamCheck.effFromDate;
                        newAppointment.G_Effective_To_Date__c = mamCheck.effToDate;
                        if (!EON_Utility.validateRequired(mamCheck.abbrvtdName)){newAppointment.Gas_Market_Participant_ID__c = mamCheck.abbrvtdName;} //CH34
                        newAppointment.MPRN__c = searchWrapp.MPRN.trim();
                        errorMsg += EON_MDS_ReqGasMeterPointData.Errors;
    
                        MDSData = new MDS_Data_Tracker__c();
                        MDSData = EON_MDS_ReqGasMeterPointData.cTrack;
                        if (MDSData != null)
                            MDSDataTrackLst.add(MDSData);
                        //CH21.End
    
                        industryGasData.customerName = newAppointment.Person_Name__c;
                        industryGasData.contactNumber = String.Valueof(newAppointment.Contact_Number__c);
                        industryGasData.postCode = newAppointment.Post_Code__c;
                        industryGasData.addressText = '';
                        industryGasData.SubBuildingNameNumber = newAppointment.Sub_Building_Name__c;
                        industryGasData.BuildingNameNumber = ((newAppointment.Building_Number__c != null) ? newAppointment.Building_Number__c : '') + ' ' + ((newAppointment.Building_Name__c != null) ? newAppointment.Building_Name__c : '');
                        industryGasData.DependentThoroughfare = newAppointment.Dependent_Thorofare__c;
                        industryGasData.Thoroughfare = newAppointment.Thorofare__c;
                        industryGasData.DoubleDependentLocality = newAppointment.Double_dependant_Locality__c;
                        industryGasData.DependentLocality = newAppointment.Dependant_Locality__c;
                        industryGasData.PostTown = newAppointment.Post_Town__c;
                        industryGasData.County = newAppointment.County__c;
                    } //CH21.start
                    else if (mamCheck != null) {
                        List < EON_Fuel__c > lstFuel = Database.query('SELECT Id,Name FROM EON_Fuel__c WHERE MPRN__c =\'' + searchWrapp.MPRN.trim() + '\' AND MPAN__c = ' + (String.isNotBlank(searchWrapp.MPAN) ? '\'' + searchWrapp.MPAN.trim() + '\'' : null));
                        if (lstFuel != null && lstFuel.size() == 1)
                            areWeNotMAM = true;
                        System.debug(' 1 areWeNotMAM = ' + areWeNotMAM);
                    } //CH21.End
    
                }
                System.debug('==>MPAN newAppointment ' + newAppointment.Customer_Name__c + ', newAppointment= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.E_Meter_Type__c);
                System.debug('==>MPRN newAppointment , newAppointment= ' + newAppointment.Planned_G_Meter_Type__c + ', ' + newAppointment.G_Meter_Type__c);
                if (MDSDataTrackLst != null && MDSDataTrackLst.size() > 0) {
                    insert MDSDataTrackLst;
                    for (MDS_Data_Tracker__c jmbTrck: MDSDataTrackLst) {
                        resultIds.add(jmbTrck.id);
                    }
                    List < MDS_Data_Tracker__c > existingMDSDataTrack = new List < MDS_Data_Tracker__c > ();
                    existingMDSDataTrack = [SELECT ID, NAME FROM MDS_Data_Tracker__c where id in : resultIds AND Status__c = 'FAIL'];
                    if (existingMDSDataTrack != null && existingMDSDataTrack.size() > 0) {
                        resultMsg = 'A System error has occurred while processing your request. Please try again. If the problem persists, contact your administrator with reference number : ' + existingMDSDataTrack[0].name;
                        if (existingMDSDataTrack.size() == 2) {
                            resultMsg = resultMsg + ' and ' + existingMDSDataTrack[1].name;
                        }
                    }
                }
                if (errorMsg == '') {} //CH10 insert newAppointment;
                else if (errorMsg.containsIgnoreCase('Web service callout failed')) return 'A System error has occurred while processing your request. Please try again. If the problem persists, contact your administrator.';
                else
                    errorMsg = resultMsg;
            }
            //CH56.End
            return errorMsg;
        } 
    	catch (Exception ex) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage())); errorMsg += ex.getMessage(); return errorMsg;}
    }
    //CH02.End
    /**
        validateIndustryCreateApp(): This method will validate the Appointment Booking request coming from Industry section.
    **/
    public PageReference validateIndustryCreateApp() {
        System.debug('newAppointment = ' + newAppointment);
        //CH23.Start Adding Gas_Meter_Mechanism__r.code__c field and //CH36 Added Gas_Map_identifier__c to query //CH38 Gas_multiplication_factor_A0120__c,Gas_units_of_measure_A0123__c,Gas_year_of_manufacture_A0021__c //CH40 Added h_Gas_units_of_measure_A0123__c to query
        String fuelQuery = 'SELECT Gas_multiplication_factor_A0120__c,Gas_units_of_measure_A0123__c,Gas_year_of_manufacture_A0021__c,h_Gas_units_of_measure_A0123__c,Gas_Map_identifier__c,ID,Fuel_type__c,MPAN__c,MPRN__c,Gas_manufacturer_code_A0060__c,Gas_measuring_capacity_A0112__c,Gas_Meter_Mechanism__c,Gas_meter_serial_number__c,Gas_meter_type_A0025__c,h_Gas_Supplier_MPID__c,' /*CH27*/ + 'Gas_model_A0083__c,Gas_number_of_dials_or_digits_A0121__c,Gas_payment_method_A0163__c,Gas_supplier_code__c,Premise__r.Building_Name__c,Premise__r.Dependant_Locality__c,' + 'Premise__r.Dependant_Thorofare__c,Premise__r.Double_Dependant_Locality__c,Premise__r.Sub_Building_Name__c,Premise__r.Thorofare__c,Premise__r.Town__c,Premise__r.Customer__c,' + 'Premise__r.Customer__r.Customer_Name__c,Premise__c,Premise__r.Postcode__c,Gas_Meter_Mechanism__r.Code__c FROM EON_Fuel__c ', MPAN = (String.isNotBlank(searchWrap.MPAN) ? searchWrap.MPAN.trim() : ''), MPRN = (String.isNotBlank(searchWrap.MPRN) ? searchWrap.MPRN.trim() : ''); //CH21
        String correctWorkSkill = '', conditionQuery = '';
        conditionQuery = ((String.isNotBlank(MPAN) && String.isNotBlank(MPRN)) ? 'WHERE MPAN__c =: MPAN AND MPRN__c =: MPRN' : ((String.isNotBlank(MPAN)) ? 'WHERE MPAN__c =: MPAN' : ((String.isNotBlank(MPRN)) ? 'WHERE MPRN__c =: MPRN' : '')));
        fuelQuery += conditionQuery;
        System.debug('fuel==>' + fuelQuery);
        List < EON_Fuel__c > lstFuel = Database.query(fuelQuery);
        if (lstFuel.Size() > 1) {isIndustryCreateApp = false; ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Rejected more than one Fuel records are found.'));}
        else if(jobCodesSearched == null || jobCodesSearched == '') {isIndustryCreateApp = false; ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select the value of Job code'));} //CH20
        else {
            String jobCode = '';
            //CH18.Start
            EON_Utility.appointment_Booking_From = 'MUS';
            //CH18.End
            //CH23.start
            System.debug('-- areWeNotMAM = ' + areWeNotMAM);
            if (areWeNotMAM) {
                clearMappingAppointment();
            }
            //CH23.End
            //CH21,23 added the mapOfJobCodes.get(jobCodesSearched).MAM_Reqd__c and mapping the values from EON Fuel and EON Site and make areWeNotMAM = true;
            if (areWeNotMAM) {
                newAppointment = EON_OFSC_Helper.mapAppointmentFromFuelSite(lstFuel[0], newAppointment);
                industryGasData.customerName = newAppointment.Person_Name__c;
                industryGasData.contactNumber = String.Valueof(newAppointment.Contact_Number__c);
                industryGasData.postCode = newAppointment.Post_Code__c;
                industryGasData.addressText = '';
                industryGasData.SubBuildingNameNumber = newAppointment.Sub_Building_Name__c;
                industryGasData.BuildingNameNumber = ((newAppointment.Building_Number__c != null) ? newAppointment.Building_Number__c : '') + ' ' + ((newAppointment.Building_Name__c != null) ? newAppointment.Building_Name__c : '');
                industryGasData.DependentThoroughfare = newAppointment.Dependent_Thorofare__c;
                industryGasData.Thoroughfare = newAppointment.Thorofare__c;
                industryGasData.DoubleDependentLocality = newAppointment.Double_dependant_Locality__c;
                industryGasData.DependentLocality = newAppointment.Dependant_Locality__c;
                industryGasData.PostTown = newAppointment.Post_Town__c;
                industryGasData.County = newAppointment.County__c;
            }
            //CH21.End
            if (String.isNotBlank(ApptReason)) { // ApptReason.equalsIgnoreCase('Maintenance'),&& !ApptReason.equalsIgnoreCase('Emergency Call Out')//CH18
                jobCode = ((mapOfJobCodes != null && !mapOfJobCodes.isEmpty() && mapOfJobCodes.containsKey(jobCodesSearched)) ? mapOfJobCodes.get(jobCodesSearched).Name : null);
                List < EON_Job_Attribute__c > jobAttParam = new List < EON_Job_Attribute__c > ([SELECT ID, Name, Duration__c, Eon_Job__c, Value__c, Inactive__c FROM EON_Job_Attribute__c WHERE Eon_Job__c = : jobCodesSearched]);
                if ((lstFuel != null && !lstFuel.isEmpty()) && lstFuel[0].Premise__r.Postcode__c != null && lstFuel[0].Premise__r.Postcode__c != '')
                    oracleBucketID = EON_OFSC_Helper.checkValidityForOFSC(jobCode, jobAttParam, MPAN, MPRN, lstFuel[0].Premise__r.Postcode__c); //CH21 newAppointment.MPAN__c, newAppointment.MPRN__c
                else
                    oracleBucketID = EON_OFSC_Helper.checkValidityForOFSC(jobCode, jobAttParam, newAppointment.MPAN__c, newAppointment.MPRN__c, (((newAppointment.MPAN__c != null && newAppointment.MPRN__c != null && newAppointment.MPAN__c != '' && newAppointment.MPRN__c != '') || (newAppointment.MPAN__c != null && newAppointment.MPAN__c != '')) ? newAppointment.Metering_Point_Postcode__c : newAppointment.Post_Code__c));
            }
            //CH19.Start
            fuelType = ((lstFuel != null && !lstFuel.isEmpty()) ? lstFuel[0].Fuel_Type__c : ''); //CH17  
            newAppointment.Fuel_ID__c = ((lstFuel != null && !lstFuel.isEmpty()) ? lstFuel[0].id : null);
            newAppointment.Job_Code__c = jobCodesSearched;
            System.debug('!@#Before= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.Planned_G_Meter_Type__c + ',' + newAppointment.Number_of_Phases__c + ',' + newAppointment.Metering_Pressure__c);
            if (mapOfJobCodes != null && !mapOfJobCodes.isEmpty() && mapOfJobCodes.containsKey(jobCodesSearched))
                if ((ApptReason != '' && ApptReason.containsIgnoreCase('Connection') && ApptReason.containsIgnoreCase('New') && mapOfJobCodes.get(jobCodesSearched).Name.containsIgnoreCase('SMART')) || (mapOfJobCodes.get(jobCodesSearched).Job_Type__c != null && mapOfJobCodes.get(jobCodesSearched).Job_Type__c.equalsIgnoreCase('SMART')) && EON_Appointment_Booking_Ctrl_Test.genException == false) {
                    newAppointment.Planned_E_Meter_Type__c = ((fuelType != '') ? ((fuelType == 'E' || fuelType == 'D') ? 'MS1' : '') : (((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPAN__c)) ? 'MS1' : ''));
                    newAppointment.Planned_G_Meter_Type__c = ((fuelType != '') ? ((fuelType == 'G' || fuelType == 'D') ? 'MS1' : '') : (((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPRN__c)) ? 'MS1' : ''));} else {newAppointment.Planned_E_Meter_Type__c = ((((fuelType != '' && (fuelType == 'E' || fuelType == 'D')) || ((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPAN__c))) && isBlankVal(newAppointment.Planned_E_Meter_Type__c) && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(newAppointment.Planned_E_Meter_Type__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getValues(newAppointment.Planned_E_Meter_Type__c.toUpperCase()).Planned_Meter_Type__c : newAppointment.Planned_E_Meter_Type__c); newAppointment.Planned_G_Meter_Type__c = ((((fuelType != '' && (fuelType == 'G' || fuelType == 'D')) || ((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPRN__c))) && isBlankVal(newAppointment.Planned_G_Meter_Type__c) && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(newAppointment.Planned_G_Meter_Type__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getValues(newAppointment.Planned_G_Meter_Type__c.toUpperCase()).Planned_Meter_Type__c : newAppointment.Planned_G_Meter_Type__c);}
            System.debug('!@#After= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.Planned_G_Meter_Type__c + ',' + newAppointment.Number_of_Phases__c + ',' + newAppointment.Metering_Pressure__c);
            //CH19.End
            System.debug('!@#oracleBucketID = ' + oracleBucketID);
            if (oracleBucketID != '' && oracleBucketID.containsIgnoreCase('Reject') && !oracleBucketID.containsIgnoreCase('MPRN does not exist') && EON_Appointment_Booking_Ctrl_Test.genException == false) {
                isIndustryCreateApp = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oracleBucketID));
            } else {
                oracleBucketID = ((oracleBucketID == '') ? 'EXE_ONLY' : oracleBucketID);
                //CH10.Start -- To get the correct workSkill
                if (newAppointment.MPRN__c != null && newAppointment.MPRN__c != '' && (newAppointment.Metering_Pressure__c == null || newAppointment.Metering_Pressure__c == '')){newAppointment.Metering_Pressure__c = 'Low';} //CH31
                if (newAppointment.MPAN__c != null && newAppointment.MPAN__c != '' && (newAppointment.Number_of_Phases__c == null || newAppointment.Number_of_Phases__c == '')){newAppointment.Number_of_Phases__c = '1Ph';}//CH31
                System.debug('Workskill Combination= ' + newAppointment.Planned_E_Meter_Type__c + ',' + newAppointment.Planned_G_Meter_Type__c + ',' + newAppointment.Number_of_Phases__c + ',' + newAppointment.Metering_Pressure__c);
                if (String.isNotBlank(ApptReason) && !ApptReason.equalsIgnoreCase('Emergency Call Out')) {correctWorkSkill = EON_OFSC_Helper.getWorkSkill(newAppointment); if (correctWorkSkill != '' && correctWorkSkill.containsIgnoreCase('Invalid') && !(mapOfJobCodes.size() > 0 && mapOfJobCodes.containsKey(newAppointment.Job_Code__c) && mapOfJobCodes.get(newAppointment.Job_Code__c).Job_type__c != null && mapOfJobCodes.get(newAppointment.Job_Code__c).Job_type__c.containsIgnoreCase('New') && mapOfJobCodes.get(newAppointment.Job_Code__c).Job_type__c.containsIgnoreCase('Connection'))) {isIndustryCreateApp = false; ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Meter information could not be retrieved, please contact MUS back office.'));}} //CH11//CH24 added the condition // CH10.End
                //CH10.Start
                if (ApptReason == 'Emergency Call Out') { //CH18
                    Set < Date > shutDownDates = new Set < Date > ();
                    for (EON_Shutdown_Days__c shutDay: [Select Id, Name, Holiday_Date__c from EON_Shutdown_Days__c Where Holiday_Date__c != null]) {
                        shutDownDates.add(shutDay.Holiday_Date__c);
                    }
                    String stTime = String.valueOf(System.now().time()).substring(0, 5);
                    newAppointment.Appointment_Date__c = Date.today();
                    if ((shutDownDates != null && shutDownDates.contains(Date.Today())) || (mapOfJobCodes != null && jobCodesSearched != null && mapOfJobCodes.get(jobCodesSearched).Name.equalsIgnoreCase('OOAECOOUTWORKHRS')) && EON_Appointment_Booking_Ctrl_Test.genException == false) {
                        String endTime = String.valueOf(System.now().time().addHours(4)).substring(0, 5);
                        newAppointment.Start_Time__c = stTime;
                        newAppointment.End_Time__c = endTime;} else {String endsTime = String.valueOf(System.now().time().addHours(3)).substring(0, 5); newAppointment.Start_Time__c = stTime; newAppointment.End_Time__c = endsTime;}
                    if (System.now().time() > Time.newInstance(00, 00, 00, 000) && System.now().time() < Time.newInstance(20, 00, 00, 000)){newAppointment.Time_Slot__c = 'ECO';} else {newAppointment.Time_Slot__c = 'Night';}//CH26
                }
                //CH10.End
                System.debug('!@#correctWorkSkill ' + correctWorkSkill);
                isIndustryCreateApp = ((correctWorkSkill != '' && correctWorkSkill.containsIgnoreCase('Invalid') && !(mapOfJobCodes.size() > 0 && mapOfJobCodes.containsKey(newAppointment.Job_Code__c) && mapOfJobCodes.get(newAppointment.Job_Code__c).Job_type__c != null && mapOfJobCodes.get(newAppointment.Job_Code__c).Job_type__c.containsIgnoreCase('New') && mapOfJobCodes.get(newAppointment.Job_Code__c).Job_type__c.containsIgnoreCase('Connection'))) ? false : true); //CH24
            }
        }
        return null;
    }
    //CH05.New.End
    //CH10.Start
    /**
        createApptIndus(): This method will identify that, to redirect the user to capacities page or call the OFSC method to send the ECO data to create the appointment.
    **/
    public pageReference createApptIndus() {
        String fuelID = '';
        if (newAppointment.Fuel_ID__c != null) fuelID = newAppointment.Fuel_ID__c;
        return (new PageReference('/apex/EON_Create_Appointment_Request?fuelID=' + fuelID + '&appReason=' + apptReason + '&appointmentID=' + newAppointment.id)); return null;
        //CH13.End 
    }
    /**
        createAppointment(): This method will called for creating the appointment record on button click.
    **/
    public PageReference createAppointment() {
        //CH20.start
        if (appointmentReason == null && jobCodesSearched == null) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select the Value'));}
        else {
            //CH20.end
            system.debug('@#$@# Creating Appointment called');
            //CH54.start
            if(newAppointment.Market_Participant_ID__c!='EON Digital Attacker')
                newAppointment.Booking_System_Name__c = 'MUS';
               else
                  newAppointment.Booking_System_Name__c = 'MUS-DA'; 
             //CH54.end
            
            //newAppointment.Booking_System_Name__c = 'MUS'; //CH16.OLD
            //CH17.Start
            if (mapOfJobCodes.containsKey(jobCodesSearched) && (mapOfJobCodes.get(jobCodesSearched).Name.containsIgnoreCase('SMART') || (mapOfJobCodes.get(jobCodesSearched).Job_Type__c != null && mapOfJobCodes.get(jobCodesSearched).Job_Type__c.equalsIgnoreCase('SMART')))) {newAppointment.Planned_E_Meter_Type__c = ((fuelType != '') ? ((fuelType == 'E' || fuelType == 'D') ? 'MS1' : '') : (((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPAN__c)) ? 'MS1' : '')); newAppointment.Planned_G_Meter_Type__c = ((fuelType != '') ? ((fuelType == 'G' || fuelType == 'D') ? 'MS1' : '') : (((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPRN__c)) ? 'MS1' : ''));}//CH18
            newAppointment.Appointment_reason_code__c = appointmentReason; //CH18
            //CH17.END
            System.debug('!@#Before Insert = ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.Planned_G_Meter_Type__c + ',' + newAppointment.Number_of_Phases__c + ',' + newAppointment.Metering_Pressure__c);
            newAppointment.Planned_G_Meter_Type__c = !EON_Utility.validateRequired(newAppointment.MPRN__c) ? newAppointment.Planned_G_Meter_Type__c : ''; //CH39.New 
            newAppointment.Planned_E_Meter_Type__c = !EON_Utility.validateRequired(newAppointment.MPAN__c) ? newAppointment.Planned_E_Meter_Type__c : ''; //CH39.New 
            if(allApptMeter.size()>1) //CH42.New
                newAppointment.Multiple_Meters_at_Site__c = true;
            insert newAppointment;
            //CH42.Start
            if(allApptMeter.size()>1){
                for(EON_Appointment_Meter__c apptMtr:allApptMeter)
                  apptMtr.EON_Appointment__c = newAppointment.ID;
                insert allApptMeter;
            }
            //CH42.End
            isAppointmentCreated = true;
            //CH56.Start
            switchData = EON_MDS_Utility.getMDS_Jumbo_Status();
            if(switchData == system.label.Jumbo_Shortform) {
                List < JUMBO_Data_Tracker__c > jumboDataTrackers = new List < JUMBO_Data_Tracker__c > ();
                List < JUMBO_Data_Tracker__c > toUpdateJumboDataTrackers = new List < JUMBO_Data_Tracker__c > ();
                jumboDataTrackers = [SELECT ID, EON_Appointment__c FROM JUMBO_Data_Tracker__c where id in : resultIds];
                if (jumboDataTrackers != null && jumboDataTrackers.size() > 0) {
                    for(JUMBO_Data_Tracker__c jT : jumboDataTrackers){
                        jT.EON_Appointment__c = newAppointment.id;
                        toUpdateJumboDataTrackers.add(jT);
                    }
                }
                if (toUpdateJumboDataTrackers != null && toUpdateJumboDataTrackers.size() > 0) {
                    update toUpdateJumboDataTrackers;
                }
            }
            else if(switchData == system.label.MDS_Shortform) {
                List < MDS_Data_Tracker__c > MDSDataTrackers = new List < MDS_Data_Tracker__c > ();
                List < MDS_Data_Tracker__c > toUpdateMDSDataTrackers = new List < MDS_Data_Tracker__c > ();
                MDSDataTrackers = [SELECT ID, EON_Appointment__c FROM MDS_Data_Tracker__c where id in : resultIds];
                if (MDSDataTrackers != null && MDSDataTrackers.size() > 0) {
                    for(MDS_Data_Tracker__c jT : MDSDataTrackers){
                        jT.EON_Appointment__c = newAppointment.id;
                        toUpdateMDSDataTrackers.add(jT);
                    }
                }
                if (toUpdateMDSDataTrackers != null && toUpdateMDSDataTrackers.size() > 0) {
                    update toUpdateMDSDataTrackers;
                }
            }
            //CH56.End
        }
        return null;
    }
    //CH10.End
    //CH23.Start
    /**
        clearMappingAppointment(): This method will do the activity that unmap the appointment fields value when users changes the Eon Job vlaues
    **/
    public void clearMappingAppointment() {
        newAppointment.MPRN__c = null;
        newAppointment.G_Meter_Model__c = null;
        newAppointment.G_Meter_Serial_Number__c = null;
        newAppointment.G_Meter_Make__c = null;
        newAppointment.G_Meter_Measuring_Capacity__c = null;
        newAppointment.Number_of_Dials_or_Digits__c = null;
        newAppointment.G_Meter_Type__c = null;
        newAppointment.G_Meter_Mechanism__c = null;
        newAppointment.Payment_Method_code__c = null;
        newAppointment.Sub_Building_Name__c = null;
        newAppointment.Building_Name__c = null;
        newAppointment.Dependent_Thorofare__c = null;
        newAppointment.Thorofare__c = null;
        newAppointment.Dependant_Locality__c = null;
        newAppointment.Double_dependant_Locality__c = null;
        newAppointment.Post_Town__c = null;
        newAppointment.Post_Code__c = null;
        newAppointment.Person_Name__c = null;
        newAppointment.Supplier_Name__c = null;
        newAppointment.Planned_G_Meter_Type__c = null;
        newAppointment.Metering_Pressure__c = null;
        industryGasData.customerName = null;
        industryGasData.contactNumber = null;
        industryGasData.postCode = null;
        industryGasData.SubBuildingNameNumber = null;
        industryGasData.BuildingNameNumber = null;
        industryGasData.DependentThoroughfare = null;
        industryGasData.Thoroughfare = null;
        industryGasData.DoubleDependentLocality = null;
        industryGasData.DependentLocality = null;
        industryGasData.PostTown = null;
        industryGasData.County = null;
    }
    //CH23.End
    
    //CH49.Start
    public PageReference redirectToReschedule(){
        String replan = ApexPages.CurrentPage().getParameters().get('replan');
        if(replan == 'yes'){
            return rescheduleAppointment();
        }return null;    
            
    }
    //CH49.end
    public boolean displayPopup {get; set;}   
     public boolean displayPopup1 {get; set;} 
    public boolean displayError {get; set;}         
    
    public void closePopup() { 
        //Update   ApptToassign;     
        displayPopup1 = false; 
        displayPopup = true;
        displayError=false;
    } 
    public void closePopup1() { 
        //Update   ApptToassign;     
        displayPopup1 = false;           
    }  
    public void openlookup() {
        if(ApptToassign.Technician__c!=null){
        update  ApptToassign;
        ApptToassign =new LIst<Eon_Appointment__c>([select id,Booking_System_Name__c,Appointment_Key__c,Fuel_ID__c, GSP_Group_ID__c,Confirmed_Appointment_DateTime__c, name,Current_Phase__c,Current_SSC__c, E_Meter_Location__c, G_Meter_Location__c, Parking_Type__c, Oracle_Postcode_Sector__c, h_Job_Type__c, Key_Collection_Required__c, Technician__c,//CH31 Added field for further access 
                                 Fuel_ID__r.MPAN__c, MPAN__c, Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c, Job_code__r.h_Job_Attribute_Duration__c,Planned_G_Meter_Type__c, 
                                 Job_code__r.Duration__c, Job_code__r.SME_Duration__c, Fuel_ID__r.MPRN__c, MPRN__c, Job_code__c, Job_code__r.Name, Time_Slot__c, Start_Time__c, Job_code__r.Install_SED__c,//CH41
                                 Appointment_Date__c, End_Time__c, Caller_Name__c, Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c, EON_Appointment_ID__c, Access_Pass_Phrase__c, 
                                 Appointment_reason_code__c, Appointment_reason_code__r.OFS_Enumeration__c, h_OFSC_Assisted_Work_Reason_Code__c, Additional_Information__c, 
                                 h_OFSC_Metering_Pressure__c, h_OFSC_Number_of_Phases__c, E_Meter_Serial_Number__c, E_Meter_Type__r.OFS_Enumeration__c, E_Meter_Make__c, 
                                 E_Meter_Model__c, E_Meter_Register_1_ID__c, E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c, E_Meter_Register_5_ID__c, 
                                 E_Meter_Register_6_ID__c, Certification_Date__c, G_Meter_Serial_Number__c, G_Meter_Type__r.OFS_Enumeration__c, G_Meter_Make__c, G_Meter_Model__c, 
                                 E_Check_Meter_Serial_Number__c, h_OFSC_G_Check_Meter_Installed__c, G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, 
                                 Expected_IHD_Serial_Number__c, h_OFSC_Planned_E_Meter_Type__c, h_OFSC_Planned_G_Meter_Type__c, h_OFSC_Planned_Meter_Registers__c, 
                                 h_OFSC_Planned_Meter_Mode__c, h_OFSC_Gas_bind_performed_flag__c, h_OFSC_Install_SED_flag__c, Key_Person_Name__c, Key_Building_Name__c, 
                                 Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, Key_Dependant_Locality__c, Key_Town__c, 
                                 Key_County__c, Key_Post_Code__c, Key_Contact_Number__c,h_G_MeterMake_Enum_Mapping__c ,//CH17
                                 SubArea__c, Sent_to_Oracle__c, Sent_to_Oracle_Update__c,  Certification_Expiry_Date__c, 
                                 E_Check_Meter_Make__c, E_Check_Meter_Model__c, E_Check_Meter_Location__c, E_Check_Meter_Location__r.OFS_Enumeration__c, G_Check_Meter_Make__c, 
                                 G_Check_Meter_Model__c, G_Check_Meter_Location__c, G_Check_Meter_Location__r.OFS_Enumeration__c, Planned_Number_of_Registers__c,//CH09
                                 Post_Code__c, Planned_E_Meter_Type__c, Metering_Point_Postcode__c, Notes__c, Specific_Time_flag__c, 
                                 Customer_Name__c, Assisted_Work_Reason_Code__c, Gas_Regulator_Serial_Number__c, Requested_SSC__c,
                                 G_Meter_Mechanism__c, G_Meter_Mechanism__r.OFS_Enumeration__c,
                                 Duration__c, h_OFSC_E_Check_Meter_Installed__c, Parking_Type__r.OFS_Enumeration__c, E_Meter_Register_1_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_2_Name__r.OFS_Enumeration__c, E_Meter_Register_3_Name__r.OFS_Enumeration__c, E_Meter_Register_4_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_5_Name__r.OFS_Enumeration__c, E_Meter_Register_6_Name__r.OFS_Enumeration__c, G_Meter_Location__r.OFS_Enumeration__c, E_Meter_Location__r.OFS_Enumeration__c,  
                              (Select ID, Comm_Type_Code__c from EON_Appointment_Comms__r), 
                              (Select ID, VulnerabilityDetailCode__c,Description__c from EON_Appointment_Vulnerabilities__r), 
                              (Select ID, Contact_Full_Name__c, Contact_Type__r.Code__c, Media_Type__r.Code__c, Media_Detail__c from EON_Appointment_Contacts__r)
                              , CSP_Region__c, Comms_Hub_Variant__c, Connectivity_Likelihood__c,
                              Auxiliary_Equipment_required__c, WAN_Additional_Information__c,Technician__r.name
                          from EON_Appointment__c where id=:ApptToassign.id])[0];                  
        displayPopup1 = true;
        displayPopup = false; 
        }
        else{
            displayError = true;
            displayPopup = false; 
        }
    }
    
    public void AssignTechInOFS() {             
        String  ofscResponse = EON_OFSC_Update_Appointment.sendActivityToOFSC(ApptToassign, ApptToassign.EON_Appointment_Contacts__r, ApptToassign.EON_Appointment_Vulnerabilities__r, 'MUS');
        Update   ApptToassign; 
         displayPopup1 = false;                            
        displayPopup = false;    
    }   
    public void showPopup() {   
         ApptToassign= new LIst<Eon_Appointment__c>([select id,Booking_System_Name__c,Appointment_Key__c,Fuel_ID__c, GSP_Group_ID__c,Confirmed_Appointment_DateTime__c, name,Current_Phase__c,Current_SSC__c, E_Meter_Location__c, G_Meter_Location__c, Parking_Type__c, Oracle_Postcode_Sector__c, h_Job_Type__c, Key_Collection_Required__c, Technician__c,//CH31 Added field for further access 
                                 Fuel_ID__r.MPAN__c, MPAN__c, Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c, Job_code__r.h_Job_Attribute_Duration__c,Planned_G_Meter_Type__c, 
                                 Job_code__r.Duration__c, Job_code__r.SME_Duration__c, Fuel_ID__r.MPRN__c, MPRN__c, Job_code__c, Job_code__r.Name, Time_Slot__c, Start_Time__c, Job_code__r.Install_SED__c,//CH41
                                 Appointment_Date__c, End_Time__c, Caller_Name__c, Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c, EON_Appointment_ID__c, Access_Pass_Phrase__c, 
                                 Appointment_reason_code__c, Appointment_reason_code__r.OFS_Enumeration__c, h_OFSC_Assisted_Work_Reason_Code__c, Additional_Information__c, 
                                 h_OFSC_Metering_Pressure__c, h_OFSC_Number_of_Phases__c, E_Meter_Serial_Number__c, E_Meter_Type__r.OFS_Enumeration__c, E_Meter_Make__c, 
                                 E_Meter_Model__c, E_Meter_Register_1_ID__c, E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c, E_Meter_Register_5_ID__c, 
                                 E_Meter_Register_6_ID__c, Certification_Date__c, G_Meter_Serial_Number__c, G_Meter_Type__r.OFS_Enumeration__c, G_Meter_Make__c, G_Meter_Model__c, 
                                 E_Check_Meter_Serial_Number__c, h_OFSC_G_Check_Meter_Installed__c, G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, 
                                 Expected_IHD_Serial_Number__c, h_OFSC_Planned_E_Meter_Type__c, h_OFSC_Planned_G_Meter_Type__c, h_OFSC_Planned_Meter_Registers__c, 
                                 h_OFSC_Planned_Meter_Mode__c, h_OFSC_Gas_bind_performed_flag__c, h_OFSC_Install_SED_flag__c, Key_Person_Name__c, Key_Building_Name__c, 
                                 Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, Key_Dependant_Locality__c, Key_Town__c, 
                                 Key_County__c, Key_Post_Code__c, Key_Contact_Number__c,h_G_MeterMake_Enum_Mapping__c ,//CH17
                                 SubArea__c, Sent_to_Oracle__c, Sent_to_Oracle_Update__c,  Certification_Expiry_Date__c, 
                                 E_Check_Meter_Make__c, E_Check_Meter_Model__c, E_Check_Meter_Location__c, E_Check_Meter_Location__r.OFS_Enumeration__c, G_Check_Meter_Make__c, 
                                 G_Check_Meter_Model__c, G_Check_Meter_Location__c, G_Check_Meter_Location__r.OFS_Enumeration__c, Planned_Number_of_Registers__c,//CH09
                                 Post_Code__c, Planned_E_Meter_Type__c, Metering_Point_Postcode__c, Notes__c, Specific_Time_flag__c, 
                                 Customer_Name__c, Assisted_Work_Reason_Code__c, Gas_Regulator_Serial_Number__c, Requested_SSC__c,
                                 G_Meter_Mechanism__c, G_Meter_Mechanism__r.OFS_Enumeration__c,
                                 Duration__c, h_OFSC_E_Check_Meter_Installed__c, Parking_Type__r.OFS_Enumeration__c, E_Meter_Register_1_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_2_Name__r.OFS_Enumeration__c, E_Meter_Register_3_Name__r.OFS_Enumeration__c, E_Meter_Register_4_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_5_Name__r.OFS_Enumeration__c, E_Meter_Register_6_Name__r.OFS_Enumeration__c, G_Meter_Location__r.OFS_Enumeration__c, E_Meter_Location__r.OFS_Enumeration__c,  
                              (Select ID, Comm_Type_Code__c from EON_Appointment_Comms__r), 
                              (Select ID, VulnerabilityDetailCode__c from EON_Appointment_Vulnerabilities__r), 
                              (Select ID, Contact_Full_Name__c, Contact_Type__r.Code__c, Media_Type__r.Code__c, Media_Detail__c from EON_Appointment_Contacts__r)
                              , CSP_Region__c, Comms_Hub_Variant__c, Connectivity_Likelihood__c,
                              Auxiliary_Equipment_required__c, WAN_Additional_Information__c,Technician__r.name
                          from EON_Appointment__c where id=:selApptID])[0];
                  ApptToassign.Technician__c=null;        
        displayPopup = true;     
    }
      public Eon_Appointment__c ApptToassign{
        get;
        set;
    }
}