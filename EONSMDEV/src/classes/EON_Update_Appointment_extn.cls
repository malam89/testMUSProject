/**
    Description : This class is the controller for EON_Update_Appointment page.
    VF Page     : EON_Update_Appointment
    Test Class  : EON_Update_Appointment_extn_test
**/
/*
    Created By  : Akshay B
    Created On  : 10-04-2016
    Service Req : SR_EON_AB_031
    CHANGE HISTORY
    CH01 # SR_EON_AB_044 # 06/05/2016 # Sivasankar K # amending the class for displaying the Eon Appointment Vulnerabilities instead of Eon Site Vulnerabilities and changing the approach 
    CH02 # SR_EON_AB_061 # 19-05-2016 # Sivasankar K # amending the visualforce page as per Service request
    CH03 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH04 # SR_EON_Mobile_043 # 07/06/2016 # Dharmendra P # Updated logic for getting EON Appointment record
    CH05 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH06 # SR_EON_Jumbo_030 # 09/06/2016 # Mehbobo Alam # Added a filter condition in query to check 'Vulnerability Source'.
    CH07 # SR_EON_AB_071 # 16/06/2016 # Dharmendra P # Updated field API Name and added validation criteria.
    CH08 # SR_EON_AB_066 # 20/06/2016 # Akshay B # Added validation.
    CH09 # SR_EON_AB_084 # 06/07/2016 # Dharmendra P # Added method to render section on page
    CH10 # SR_EON_AB_090 # 13/07/2016 # Puneet Mehta # Display alert once the appointment is successfully updated.
    CH11 # SR_EON_AB_099 # 25-07-2016 # Sivasankar K # Adding Current SSC field in layout and changing Requested SSC field from text to lookup.
    CH12 # SR_EON_AB_108 # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text 
    CH13 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Deleted reference of field Vulnerability_Source__c
    CH14 # SR_EON_AB_104 # 02/08/2016 # Tashika Gupta # Added functionality related to changing of lookup to picklist and more.
    CH15 # SR_EON_AB_115 # 05/08/2016 # Dharmendra P # Added Appointmnet Reason field functionality.
    CH16 # SR_EON_AB_135 # 08/09/2016 # Aruna Manjari # Added conditions 1.All Smart jobs must have 3 EON Appointment Comms records. 2.All jobs must have at least 1 EON Appointment Contacts records 
    CH17 # SR_EON_AB_137 # 10/09/2016 # Puneet Mehta # Added Assisted Work Reason to page.
    CH18 # SR_EON_AB_146 # 14/09/2016 # Shruti Moghe # Added pattern logic for E Low Balance Alert Value and G Low Balance Alert Value fields
    CH19 # SR_EON_AB_148 # 14/09/2016 # Puneet Mehta # Changed condition for Data Consent Section
    CH20 # SR_EON_AB_131 # 07/09/2016 # Sivasankar K # Amending the validation method that not to calculate the work skill and calculat it on Save click.
    CH21 # SR_EON_AB_150 # 20/09/2016 # Mahadev J # Remove 'Gas bind Performed Flag' & if MPAN is true then 'Requested SSC' is required.
    CH22 # SR_EON_AB_159 # 10/10/2016 # Sivasankar # Amending the method to display the EON SSC.
    CH23 # SR_EON_AB_182 # 31/10/2016 # Mahadev J # Validation for Media Detail based upon Media Type.
    CH24 # SR_EON_AB_186 # 09/11/2016 # Puneet Mehta # Changed regex to validate email,mobile and telephone number
    CH25 # SR_EON_AB_183 # 10/11/2016 # Aruna Manjari# added the logic to display EON SSC on the screen based on the EON GSP Group if the value match JUMBO J.18 values
    CH26 # SR_OptiMUS_EON_053 # 11-04-2017 # Aruna manjari # Prevent deletion of the final appointment contact record once at least 1 exists.
    CH27 # SR_OptiMUS_EON_072 # 06/06/2017 # Praveen G# Added new condition for app contact record validation. 
    CH28 # SR_OptiMUS_EON_079 # 20/06/2017 # Praveen G# Amanded the contact type picklist values.
    CH29 # SR_OptiMUS_EON_076 # 13/07/2017 # Praveen G# Added new condition for app contact record validation for delete.
    CH30 # SR_OptiMUS_EON_155 # 02/11/2017 # Praveen G# New changes to validate / populate Requested SSC.
    CH31 # INCUK0007073271  # 22/02/2018 # Praveen G# fix for Requested SSC is not populating. 
    CH32 # SR_OptiMUS_EON_160 # 18/03/2018 # Mehboob Alam# There must be at least one contact type ‘Appointment Contact’ present on the appointment, .   
    
*/
public with sharing class EON_Update_Appointment_extn {
    public EON_Appointment__c Appt {
        get;
        set;
    }
    public EON_Appointment_Contact__c ApptCont {
        get;
        set;
    }
    public EON_Appointment_Comms__c ApptComms {
        get;
        set;
    }
    public EON_Appointment_Vulnerability__c EON_Appt_Vuln {
        get;
        set;
    } //CH01 changed to Appointment vulnerability
    public ApexPages.StandardController sController;
    public String queryString;
    public String ofscResponse {
        get;
        set;
    }
    //CH08.Start
    public List < SelectOption > MediaTypeLst {
        get;
        set;
    }
    public String selectedMediaType {
        get;
        set;
    }
    public List < SelectOption > parkingLst {
        get;
        set;
    }
    public String selectedParking {
        get;
        set;
    }
    public List < SelectOption > EMetLocLst {
        get;
        set;
    }
    public String selectedEMetLoc {
        get;
        set;
    }
    public List < SelectOption > GMetLocLst {
        get;
        set;
    }
    public String selectedGMetLoc {
        get;
        set;
    }
    public String selectedDeliveryMethod_c {
        get;
        set;
    }
    public String selectedDeliveryMethod_I {
        get;
        set;
    }
    public String selectedDeliveryMethod_R {
        get;
        set;
    }
    public List < EON_Appointment_Contact__c > lstApptContact {
        get;
        set;
    } //this will hold the Contact 
    //CH08.End
    //CH14.Start
    public List < SelectOption > VulnerabilityLst {
        get;
        set;
    }
    public String selectedVulnerability {
        get;
        set;
    }
    public List < SelectOption > ContactLst {
        get;
        set;
    }
    public String selectedContact {
        get;
        set;
    }
    //CH14.End
    public Boolean fieldSetVisibility {
        get;
        set;
    } //CH09
    //CH01.Start
    public List < EON_Appointment_Vulnerability__c > lstApptVulnerability {
        get;
        set;
    } // this will hold the Appointment Vulnerabilities.
    public Integer removeIndex {
        get;
        set;
    } // this will store the selected Appointment Vulnerability.
    public String addErrorMsg {
        get;
        set;
    }
    public EON_Appointment__c updateAppointment {
        get;
        set;
    }
    //CH01.End
    public String selectedAppRea {
        get;
        set;
    } //CH15
    public List < SelectOption > appReasonLst {
        get;
        set;
    } //CH15
    //CH16.START
    public List < SelectOption > DeliveryMethodLstC {
        get;
        set;
    }
    public List < SelectOption > DeliveryMethodLstI {
        get;
        set;
    }
    public List < SelectOption > DeliveryMethodLstR {
        get;
        set;
    }
    
    //CH30.Start
    public boolean IsReqestedEditable {get;set;}
    //CH30.End

    private List < EON_Appointment_Comms__c > getAppCommsLst() {
        List < EON_Appointment_Comms__c > existComms = new List < EON_Appointment_Comms__c > ();
        if (Appt != null)
            existComms = [select id, Comm_Type_Code__c, Delivery_Method_Desc__c, Delivery_Method_Desc__r.name, EON_Appointment_ID__c from EON_Appointment_Comms__c where EON_Appointment_ID__c = : Appt.id];
        return existComms;
    }

    private List < Eon_Delivery_Method__c > delMethLst = [select id, name from Eon_Delivery_Method__c limit 50000];

    public void getDeliveryMethodC() {
        String dmName1 = '', dNone1 = '';
        if (delMethLst != null && delMethLst.size() > 0) {
            DeliveryMethodLstC = new List < SelectOption > ();
            List < EON_Appointment_Comms__c > appCommsLst = getAppCommsLst();
            if (appCommsLst != null && appCommsLst.size() > 0) {
                for (EON_Appointment_Comms__c comms: appCommsLst) {
                    if (comms.Delivery_Method_Desc__c != null && comms.Comm_Type_Code__c != null && comms.Comm_Type_Code__c != '' && comms.Comm_Type_Code__c == 'C') {
                        DeliveryMethodLstC.add(new SelectOption(comms.Delivery_Method_Desc__c, comms.Delivery_Method_Desc__r.name));
                        dmName1 = comms.Delivery_Method_Desc__r.name;
                    }
                }
            }
            if (Appt != null && Appt.h_Job_Code__c != null && Appt.h_Job_Code__c != '' && Appt.h_Job_Code__c.containsIgnoreCase('smart')) {
                for (Eon_Delivery_Method__c DM: delMethLst) {
                    if (DM.name != null && DM.name != '' && DM.name == 'None') {
                        if (DM.name != dmName1) {
                            DeliveryMethodLstC.add(new SelectOption(DM.id, DM.name));
                            dNone1 = DM.name;
                        }
                        break;
                    }
                }
            } else {DeliveryMethodLstC.add(new SelectOption('', '--None--'));}
            for (Eon_Delivery_Method__c DM: delMethLst) {
                if (DM.name != dmName1 && DM.name != dNone1) {
                    DeliveryMethodLstC.add(new SelectOption(DM.id, DM.name));
                }
            }
        }
    }

    public void getDeliveryMethodI() {
        String dmName2 = '', dNone2 = '';
        if (delMethLst != null && delMethLst.size() > 0) {
            DeliveryMethodLstI = new List < SelectOption > ();
            List < EON_Appointment_Comms__c > appCommsLst = getAppCommsLst();
            if (appCommsLst != null && appCommsLst.size() > 0) {
                for (EON_Appointment_Comms__c comms: appCommsLst) {
                    if (comms.Delivery_Method_Desc__c != null && comms.Comm_Type_Code__c != null && comms.Comm_Type_Code__c != '' && comms.Comm_Type_Code__c == 'I') {
                        DeliveryMethodLstI.add(new SelectOption(comms.Delivery_Method_Desc__c, comms.Delivery_Method_Desc__r.name));
                        dmName2 = comms.Delivery_Method_Desc__r.name;
                    }
                }
            }
            if (Appt != null && Appt.h_Job_Code__c != null && Appt.h_Job_Code__c != '' && Appt.h_Job_Code__c.containsIgnoreCase('smart')) {
                for (Eon_Delivery_Method__c DM: delMethLst) {
                    if (DM.name != null && DM.name != '' && DM.name == 'None') {
                        if (DM.name != dmName2) {
                            DeliveryMethodLstI.add(new SelectOption(DM.id, DM.name));
                            dNone2 = DM.name;
                        }
                        break;
                    }
                }
            } else {DeliveryMethodLstI.add(new SelectOption('', '--None--'));}
            for (Eon_Delivery_Method__c DM: delMethLst) {
                if (DM.name != dmName2 && DM.name != dNone2) {
                    DeliveryMethodLstI.add(new SelectOption(DM.id, DM.name));
                }
            }
        }
    }

    public void getDeliveryMethodR() {
        String dmName3 = '', dNone3 = '';
        if (delMethLst != null && delMethLst.size() > 0) {
            DeliveryMethodLstR = new List < SelectOption > ();
            List < EON_Appointment_Comms__c > appCommsLst = getAppCommsLst();
            if (appCommsLst != null && appCommsLst.size() > 0) {
                for (EON_Appointment_Comms__c comms: appCommsLst) {
                    if (comms.Delivery_Method_Desc__c != null && comms.Comm_Type_Code__c != null && comms.Comm_Type_Code__c != '' && comms.Comm_Type_Code__c == 'R') {
                        DeliveryMethodLstR.add(new SelectOption(comms.Delivery_Method_Desc__c, comms.Delivery_Method_Desc__r.name));
                        dmName3 = comms.Delivery_Method_Desc__r.name;
                    }
                }
            }
            if (Appt != null && Appt.h_Job_Code__c != null && Appt.h_Job_Code__c != '' && Appt.h_Job_Code__c.containsIgnoreCase('smart')) {
                for (Eon_Delivery_Method__c DM: delMethLst) {
                    if (DM.name != null && DM.name != '' && DM.name == 'None') {
                        if (DM.name != dmName3) {
                            DeliveryMethodLstR.add(new SelectOption(DM.id, DM.name));
                            dNone3 = DM.name;
                        }
                        break;
                    }
                }
            } else {DeliveryMethodLstR.add(new SelectOption('', '--None--'));}
            for (Eon_Delivery_Method__c DM: delMethLst) {
                if (DM.name != dmName3 && DM.name != dNone3) {
                    DeliveryMethodLstR.add(new SelectOption(DM.id, DM.name));
                }
            }
        }
    }
    //CH16.END
    //Constructor
    public EON_Update_Appointment_extn(ApexPages.StandardController controller) {
        sController = controller;
        this.Appt = (EON_Appointment__c) controller.getRecord();
        
        //CH30.Start
        IsReqestedEditable = false;
        if(!test.isrunningtest() && (Appt.h_Job_Code__c.containsIgnoreCase('Smart') || 
                (String.isNotBlank(Appt.h_Job_Code__c) &&
                Appt.h_Job_Code__c.containsIgnoreCase('OOAMETERFUNCCHANGE')))){
            IsReqestedEditable = true;        
        }        
        //CH30.End
        
        //CH01.Start
        updateAppointment = new EON_Appointment__c();
        EON_Appt_Vuln = new EON_Appointment_Vulnerability__c();
        //CH01.End
        ApptCont = new EON_Appointment_Contact__c();
        ApptComms = new EON_Appointment_Comms__c();
        //CH09.start
        if (appt.Planned_Meter_Mode__c == 'PAYG' && string.isNotBlank(Appt.h_Job_Code__c) && Appt.h_Job_Code__c.containsIgnoreCase('smart') && (string.isNotBlank(Appt.MPAN__c) || string.isNotBlank(Appt.MPRN__c)))
            fieldSetVisibility = true;
        else
            fieldSetVisibility = false;
        system.debug('%%% constructor fieldSetVisibility: ' + fieldSetVisibility);
        //CH14.Start
        //CH19.START
        if (Appt != null && Appt.h_Job_Code__c != null && Appt.h_Job_Code__c != '' && Appt.h_Job_Code__c.containsIgnoreCase('smart')) {
            EON_Appointment__c appointmentFuel;
            appointmentFuel = [select id, name, Fuel_ID__r.Fuel_type__c from EON_Appointment__c where id = : Appt.id];
            if (appointmentFuel.Fuel_ID__r.Fuel_type__c == 'E') {
                Appt.Elec_Daily_Data_Opted__c = true;
            }
            if (appointmentFuel.Fuel_ID__r.Fuel_type__c == 'D') {
                Appt.Elec_Daily_Data_Opted__c = true;
                Appt.Gas_Daily_Data_Opted__c = true;
            }
            if (appointmentFuel.Fuel_ID__r.Fuel_type__c == 'G') {
                Appt.Gas_Daily_Data_Opted__c = true;
            }
        } //CH19.END
        //CH14.End
        //CH09.end
        //CH01 query the Appointment Vulnerabilities.
        lstApptVulnerability = new List < EON_Appointment_Vulnerability__c > ([SELECT Description__c, EON_Appointment_ID__c, Id, Name, VulnerabilityDetailCode__c, VulnerabilityTypeID__c FROM EON_Appointment_Vulnerability__c WHERE EON_Appointment_ID__c = : Appt.id]);
        //CH08.Start
        lstApptContact = new List < EON_Appointment_Contact__c > ([SELECT Contact_Full_Name__c, Contact_Type__c, Id, Name, Customer_Assistant__c, EON_Appointment_ID__c, Media_Detail__c, Media_Type__c FROM EON_Appointment_Contact__c WHERE EON_Appointment_ID__c = : Appt.id]);
        selectedGMetLoc = Appt.G_Meter_Location__c;
        selectedEMetLoc = Appt.E_Meter_Location__c;
        selectedParking = Appt.Parking_Type__c;
        getParkingTypes();
        getDeliveryMethodC();//CH16
        getDeliveryMethodI();//CH16
        getDeliveryMethodR();//CH16
        getEMeterloc();
        getGMeterloc();
        getMediaType();
        //CH08.End
        //CH14.Start
        getVulnerablities();
        getContactTypes();
        //CH14.End
        getAppReasons();//CH15
    }

    //CH09.start
    /*
        setVisibilityPayg() - Method to alter the visibility of PAYG Preference section
    */
    public pagereference setVisibilityPayg() {
        if (appt.Planned_Meter_Mode__c == 'PAYG' && string.isNotBlank(Appt.h_Job_Code__c) && Appt.h_Job_Code__c.containsIgnoreCase('smart') && (string.isNotBlank(Appt.MPAN__c) || string.isNotBlank(Appt.MPRN__c)))
            fieldSetVisibility = true;
        else
            fieldSetVisibility = false;
        system.debug('%%% fieldSetVisibility: ' + fieldSetVisibility);
        return null;
    }
    //CH09.end
    //CH08.Start
    public void getMediaType() {
        list < EON_Media_Type__c > MTypelist = [select id, name from EON_Media_Type__c limit 50000];
        if (MTypelist != null && MTypelist.size() > 0) {
            MediaTypeLst = new List < SelectOption > ();
            for (EON_Media_Type__c MT: MTypelist) {
                MediaTypeLst.add(new SelectOption(MT.id, MT.name));
            }
        }
    }
    public void getGMeterloc() {
        list < EON_Gas_Meter_Location__c > GMeterlist = [select id, name from EON_Gas_Meter_Location__c limit 50000];
        if (GMeterlist != null && GMeterlist.size() > 0) {
            GMetLocLst = new List < SelectOption > ();
            for (EON_Gas_Meter_Location__c GMl: GMeterlist) {
                GMetLocLst.add(new SelectOption(GMl.id, GMl.name));
            }
        }
    }
    public void getEMeterloc() {
        list < EON_Electric_Meter_Location__c > EMeterlist = [select id, name from EON_Electric_Meter_Location__c limit 50000];
        if (EMeterlist != null && EMeterlist.size() > 0) {
            EMetLocLst = new List < SelectOption > ();
            for (EON_Electric_Meter_Location__c EMl: EMeterlist) {
                EMetLocLst.add(new SelectOption(EMl.id, EMl.name));
            }
        }
    }
    public void getParkingTypes() {
        list < EON_Parking__c > parkinglist = [select id, name from EON_Parking__c limit 50000];
        if (parkinglist != null && parkinglist.size() > 0) {
            parkingLst = new List < SelectOption > ();
            for (EON_Parking__c Park: parkinglist) {
                parkingLst.add(new SelectOption(Park.id, Park.name));
            }
        }
    }
    //CH08.End
    //CH14.Start
    public void getVulnerablities() {
        list < EON_Vulnerability_Code__c > VulnerabilityList = [select id, name from EON_Vulnerability_Code__c limit 50000];
        if (VulnerabilityList != null && VulnerabilityList.size() > 0) {
            VulnerabilityLst = new List < SelectOption > ();
            for (EON_Vulnerability_Code__c vulnerability: VulnerabilityList) {
                VulnerabilityLst.add(new SelectOption(vulnerability.id, vulnerability.name));
            }
        }
    }
    public void getContactTypes() {
        list < EON_Contact_Type__c > ContactList = [select id, name from EON_Contact_Type__c limit 50000];
        if (ContactList != null && ContactList.size() > 0) {
            ContactLst = new List < SelectOption > ();
            for (EON_Contact_Type__c contact: ContactList) {
                //CH28.Start
                String cName = contact.Name;
                if(contact.Name == 'Appointment Contact')
                    cName = 'Appointment Contact (Default)';
                else if(contact.Name == 'Reminder Contact (Default)')
                    cName = 'Reminder Contact';
                    
                ContactLst.add(new SelectOption(contact.id, cName)); 
                //CH28.End            
                //ContactLst.add(new SelectOption(contact.id, contact.name));
            }
        }
    }
    //CH14.End
    //CH15
    public void getAppReasons() {
        list < Eon_Appointment_Reason__c > reasonList = [select id, name from Eon_Appointment_Reason__c limit 50000];
        if (reasonList != null && reasonList.size() > 0) {
            appReasonLst = new List < SelectOption > ();
            for (Eon_Appointment_Reason__c Reason: reasonList) {
                appReasonLst.add(new SelectOption(Reason.id, Reason.name));
            }
        }
    }
    //CH-1.Start
    /**
        mapFieldValues(): this method will maps the controller fields to new Eon Appointment instance.
    **/
    private String mapFieldValues() {
        System.debug('Appt.name = ' + Appt.name);
        Boolean errorOccured = false;
        //CH08.Start
        if (Appt.Key_Collection_Required__c == true && (Appt.Key_Person_Name__c == null || Appt.Key_Person_Name__c == '')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Key Person Name: You must enter a value'));
            errorOccured = true;
        }
        if (Appt.Key_Collection_Required__c == true && Appt.Key_Contact_Number__c == null){ //CH12
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Key Contact Number: You must enter a value'));
            errorOccured = true;
        }
        String keyContactRegex = '^(?:(?:\\(?(?:0(?:0|11)\\)?[\\s-]?\\(?|\\+)44\\)?[\\s-]?(?:\\(?0\\)?[\\s-]?)?)|(?:\\(?0))(?:(?:\\d{5}\\)?[\\s-]?\\d{4,5})|(?:\\d{4}\\)?[\\s-]?(?:\\d{5}|\\d{3}[\\s-]?\\d{3}))|(?:\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{3,4})|(?:\\d{2}\\)?[\\s-]?\\d{4}[\\s-]?\\d{4}))(?:[\\s-]?(?:x|ext\\.?|\\#)\\d{3,4})?$';//CH24
        Pattern MyPattern = Pattern.compile(keyContactRegex);//CH24
        if (Appt.Key_Collection_Required__c == true && Appt.Key_Contact_Number__c != null && !MyPattern.matcher(Appt.Key_Contact_Number__c).matches()){ //CH24
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Key Contact Number: You must enter valid value'));//CH24
            errorOccured = true;//CH24
        }
        //CH08.End
        //CH18.start
        if (Appt.E_LowBalanceAlertValue__c != null) {
            if ((!(String.valueof(Appt.E_LowBalanceAlertValue__c).contains('.00')) && !(String.valueof(Appt.E_LowBalanceAlertValue__c).isNumeric())) || (Appt.E_LowBalanceAlertValue__c < 3 || Appt.E_LowBalanceAlertValue__c > 100)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'E Low Balance Alert Value must be whole numbers between 3 and 100'));
                errorOccured = true;
            }
        }
        if (Appt.G_LowBalanceAlertValue__c != null) {
            if ((!(String.valueof(Appt.G_LowBalanceAlertValue__c).contains('.00')) && !(String.valueof(Appt.G_LowBalanceAlertValue__c).isNumeric())) || (Appt.G_LowBalanceAlertValue__c < 3 || Appt.G_LowBalanceAlertValue__c > 100)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'G Low Balance Alert Value must be whole numbers between 3 and 100'));
                errorOccured = true;
            }
        }
        if (errorOccured) return 'ErrorOccured';
        //CH18.end
        if (Appt.name != null) { //CH04
            string getAppResponse = EON_OFSC_Update_Appointment.getAppointment(Appt.name); //CH02
            If(Test.isRunningTest()){getAppResponse='Appointment Exists.'; EON_OFSC_Update_Appointment.objAppt1 =appt;} 
            system.debug('@@@ getAppResponse: ' + getAppResponse);
            if (getAppResponse == 'Appointment Exists.') {
                updateAppointment = EON_OFSC_Update_Appointment.objAppt1; //CH02
                system.debug('@@@ updateAppointment Id: ' + updateAppointment.Id + ' updateAppointment Name: ' + updateAppointment.name);
                updateAppointment.Access_Pass_Phrase__c = Appt.Access_Pass_Phrase__c;
                updateAppointment.Caller_Name__c = Appt.Caller_Name__c;
                updateAppointment.Requested_SSC__c = Appt.Requested_SSC__c; //CH03//CH05
                updateAppointment.Notes__c = Appt.Notes__c;
                updateAppointment.Assisted_Work_Reason__c = Appt.Assisted_Work_Reason__c; //CH17
                updateAppointment.Planned_E_Meter_Type__c = Appt.Planned_E_Meter_Type__c; //CH20
                updateAppointment.Planned_G_Meter_Type__c= Appt.Planned_G_Meter_Type__c; //CH20
                updateAppointment.Key_Collection_Required__c = Appt.Key_Collection_Required__c;
                updateAppointment.Key_Person_Name__c = Appt.Key_Person_Name__c;
                updateAppointment.Key_Contact_Number__c = Appt.Key_Contact_Number__c; //CH12
                updateAppointment.Key_Building_Number__c = Appt.Key_Building_Number__c;
                updateAppointment.Key_Sub_Building_Name__c = Appt.Key_Sub_Building_Name__c;
                updateAppointment.Key_Building_Name__c = Appt.Key_Building_Name__c;
                updateAppointment.Key_Town__c = Appt.Key_Town__c;
                updateAppointment.Key_Dependant_Locality__c = Appt.Key_Dependant_Locality__c;
                updateAppointment.Key_Double_Dependant_Locality__c = Appt.Key_Double_Dependant_Locality__c;
                updateAppointment.Key_Thorofare__c = Appt.Key_Thorofare__c;
                updateAppointment.Key_Dependant_Thorofare__c = Appt.Key_Dependant_Thorofare__c;
                updateAppointment.Key_County__c = Appt.Key_County__c;
                updateAppointment.Key_Post_Code__c = Appt.Key_Post_Code__c;
                updateAppointment.Key_Country__c = Appt.Key_Country__c;
                if (selectedEMetLoc != null && selectedEMetLoc != '') { updateAppointment.E_Meter_Location__c = selectedEMetLoc; }
                if (selectedGMetLoc != null && selectedGMetLoc != '') { updateAppointment.G_Meter_Location__c = selectedGMetLoc; }
                if (selectedParking != null && selectedParking != '') { updateAppointment.Parking_Type__c = selectedParking; }
                //CH15
                updateAppointment.Appointment_reason_code__c = Appt.Appointment_reason_code__c;//CH20
                updateAppointment.Elec_HH_Data_Opted__c = Appt.Elec_HH_Data_Opted__c;
                updateAppointment.Elec_Daily_Data_Opted__c = Appt.Elec_Daily_Data_Opted__c;
                updateAppointment.Gas_HH_Data_Opted__c = Appt.Gas_HH_Data_Opted__c;
                updateAppointment.Gas_Daily_Data_Opted__c = Appt.Gas_Daily_Data_Opted__c;
                //CH07.New.start
                //For electric
                updateAppointment.E_Disconnection_warning_option_flag__c = Appt.E_Disconnection_warning_option_flag__c;
                updateAppointment.E_Low_balance_alert_flag__c = Appt.E_Low_balance_alert_flag__c;
                updateAppointment.E_LowBalanceAlertValue__c = Appt.E_LowBalanceAlertValue__c;
                updateAppointment.E_Top_up_Notification_Opt_in_Flag__c = Appt.E_Top_up_Notification_Opt_in_Flag__c;
                updateAppointment.E_Payment_Reminder_Opt_in_Flag__c = Appt.E_Payment_Reminder_Opt_in_Flag__c;
                updateAppointment.E_Payment_Reminder_Frequency_Code__c = Appt.E_Payment_Reminder_Frequency_Code__c;
                updateAppointment.E_Payment_Reminder_Day_Of_The_Week__c = Appt.E_Payment_Reminder_Day_Of_The_Week__c;
                updateAppointment.E_Payment_Reminder_Date__c = Appt.E_Payment_Reminder_Date__c;
                //For gas
                updateAppointment.G_Disconnection_warning_option_flag__c = Appt.G_Disconnection_warning_option_flag__c;
                updateAppointment.G_Low_balance_alert_flag__c = Appt.G_Low_balance_alert_flag__c;
                updateAppointment.G_LowBalanceAlertValue__c = Appt.G_LowBalanceAlertValue__c;
                updateAppointment.G_Top_up_Notification_Opt_in_Flag__c = Appt.G_Top_up_Notification_Opt_in_Flag__c;
                updateAppointment.G_Payment_Reminder_Opt_in_Flag__c = Appt.G_Payment_Reminder_Opt_in_Flag__c;
                updateAppointment.G_Payment_Reminder_Frequency_Code__c = Appt.G_Payment_Reminder_Frequency_Code__c;
                updateAppointment.G_Payment_Reminder_Day_Of_The_Week__c = Appt.G_Payment_Reminder_Day_Of_The_Week__c;
                updateAppointment.G_Payment_Reminder_Date__c = Appt.G_Payment_Reminder_Date__c;
                //CH07.New.end
                updateAppointment.Planned_Meter_Mode__c = Appt.Planned_Meter_Mode__c; //CH09
                //Praveen added field JIRA issue - SM - 2220
                updateAppointment.DVD_Requested__c = Appt.DVD_Requested__c;
                updateAppointment.Braille__c = Appt.Braille__c;
                updateAppointment.Call_2_Days_before_appointment_Required__c = Appt.Call_2_Days_before_appointment_Required__c;
                updateAppointment.Large_Print__c = Appt.Large_Print__c;
                updateAppointment.Large_Print__c = Appt.Large_Print__c;
                updateAppointment.Install_SED_flag__c = Appt.Install_SED_flag__c;
                //Praveen added field JIRA issue - SM - 2220
                return '';} else return 'Rejected';
        } else{return 'Rejected';}
    }
    //CH08.Start
    /**
        addRowCon(): This method will add the new row to the list to for adding the new Appointment Contact.
    **/
    public PageReference addRowCon() {
        if (selectedContact != null && ApptCont.Contact_Full_Name__c != null && selectedMediaType != null && ApptCont.Media_Detail__c != null) { //CH14
            //CH23.New.Start
            boolean addContact = true;
            String mediaType = '';
            String emailRegex = '^([\\w-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([\\w-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$';//CH24.NEW
            String telRegex = '^(?:(?:\\(?(?:0(?:0|11)\\)?[\\s-]?\\(?|\\+)44\\)?[\\s-]?(?:\\(?0\\)?[\\s-]?)?)|(?:\\(?0))(?:(?:\\d{5}\\)?[\\s-]?\\d{4,5})|(?:\\d{4}\\)?[\\s-]?(?:\\d{5}|\\d{3}[\\s-]?\\d{3}))|(?:\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{3,4})|(?:\\d{2}\\)?[\\s-]?\\d{4}[\\s-]?\\d{4}))(?:[\\s-]?(?:x|ext\\.?|\\#)\\d{3,4})?$';//CH24.NEW
            String mobileRegex = '^(?:(?:\\(?(?:0(?:0|11)\\)?[\\s-]?\\(?|\\+)44\\)?[\\s-]?(?:\\(?0\\)?[\\s-]?)?)|(?:\\(?0))(?:(?:\\d{5}\\)?[\\s-]?\\d{4,5})|(?:\\d{4}\\)?[\\s-]?(?:\\d{5}|\\d{3}[\\s-]?\\d{3}))|(?:\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{3,4})|(?:\\d{2}\\)?[\\s-]?\\d{4}[\\s-]?\\d{4}))(?:[\\s-]?(?:x|ext\\.?|\\#)\\d{3,4})?$';//CH24.NEW
            if(!MediaTypeLst.isEmpty()){
                for(SelectOption mediaOption: MediaTypeLst){
                    if(mediaOption.getValue() == selectedMediaType){
                        mediaType = mediaOption.getLabel();
                        break;
                    } 
                }
                if(mediaType.equalsIgnoreCase('Telephone')){
                    Pattern MyPattern = Pattern.compile(telRegex);
                    Matcher MyMatcher = MyPattern.matcher(ApptCont.Media_Detail__c);
                    if (!MyMatcher.matches()){
                        addErrorMsg = 'Contact Media Detail must be a valid telephone number';
                        addContact = false;
                    }
                }
                if(mediaType.equalsIgnoreCase('Email')){
                    Pattern MyPattern = Pattern.compile(emailRegex);
                    Matcher MyMatcher = MyPattern.matcher(ApptCont.Media_Detail__c);
                    if (!MyMatcher.matches()){
                        addErrorMsg = 'Contact Media Detail must be a valid email address';
                        addContact = false;
                    }
                }
                if(mediaType.equalsIgnoreCase('Mobile')){
                    Pattern MyPattern = Pattern.compile(mobileRegex);
                    Matcher MyMatcher = MyPattern.matcher(ApptCont.Media_Detail__c);
                    if (!MyMatcher.matches()){
                        addErrorMsg = 'Contact Media Detail must be a valid mobile number';
                        addContact = false;
                    }
                }
            }
            //CH23.New.End
            if(addContact){
                EON_Appointment_Contact__c cont = new EON_Appointment_Contact__c();
                cont.EON_Appointment_ID__c = updateAppointment.id;
                if (selectedContact != null && selectedContact != '') //CH14
                    cont.Contact_Type__c = selectedContact; //ApptCont.Contact_Type__c;
                cont.Contact_Full_Name__c = ApptCont.Contact_Full_Name__c;
                cont.Customer_Assistant__c = ApptCont.Customer_Assistant__c;
                if (selectedMediaType != null && selectedMediaType != '')
                    cont.Media_Type__c = selectedMediaType;
                cont.Media_Detail__c = ApptCont.Media_Detail__c;
                lstApptContact.add(cont);
                ApptCont = new EON_Appointment_Contact__c();
                addErrorMsg = null;
            }
        } else {
            addErrorMsg = 'Any of the following fields: Contact Type, Contact Full Name, Media Type, Media Detail can\'t be blank';
        }
        return null;
    }
    /**
        removeRow(): This method will remove the record from the list and delete the record from isis.
    **/
    public PageReference removeRowCon() {
        System.debug('index to remove = ' + removeIndex);
        try {
            if (EON_Utility.genException != null && EON_Utility.genException){System.debug(lstApptContact[0].name);} //To cover exception in test class
            if (removeIndex != null && lstApptContact.size() >= removeIndex) {
                EON_Appointment_Contact__c appcon = ((lstApptContact[removeIndex].id != null) ? lstApptContact[removeIndex] : null);
                
                //CH29.
                List<EON_Appointment_Contact__c> lstTemp = new List<EON_Appointment_Contact__c>(lstApptContact);
                lstTemp.remove(removeIndex);
                boolean isAllow = validateAppointmentContacts(lstTemp);
                //CH29.end  
                              
                //CH26 added deletion condition
                     //CH29 added the third condition.
                    if (appcon != null && lstApptContact.size()>1 //CH26 added the condition
                                    && !isAllow) //CH29
                    {delete appcon;}
                    system.debug('%%%%Value of lstApptContact.size() %%%'+ lstApptContact.size());
                   
                if(lstApptContact.size() !=1 && !isAllow) //CH29 //CH32
                  lstApptContact.remove(removeIndex);
            }
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        }
        return null;
    }
    //CH08.End
    /**
        addRow(): This method will add the new row to the list to for adding the new Appointment Vulnerability.
    **/
    public PageReference addRow() {
        //CH14.Start
        if (selectedVulnerability != null) {
            List < EON_Vulnerability_Code__c > eonVulnerabilityCode = [select id, name, Vulnerability_Code__c from EON_Vulnerability_Code__c where id = : selectedVulnerability]; //CH06 CH13.New
            EON_Appt_Vuln.Description__c = selectedVulnerability;
            if (eonVulnerabilityCode != null && eonVulnerabilityCode.size() > 0) {
                EON_Appt_Vuln.VulnerabilityDetailCode__c = eonVulnerabilityCode[0].Vulnerability_Code__c;
                if ((EON_Appt_Vuln.VulnerabilityTypeID__c == null || EON_Appt_Vuln.VulnerabilityTypeID__c == '') && (selectedVulnerability != null && selectedVulnerability != '')) {addErrorMsg = 'Vulnerability type field is mandatory if vulnerability exists';} 
                    else {
                    lstApptVulnerability.add(EON_Appt_Vuln);
                    EON_Appt_Vuln = new EON_Appointment_Vulnerability__c();
                    addErrorMsg = null;
                }
            }
        } else {
            addErrorMsg = 'Please populate Description value.';
        }
        return null;
        //CH14.End
    }
    /**
        removeRow(): This method will remove the record from the list and delete the record from isis.
    **/
    public PageReference removeRow() {
        System.debug('index to remove = ' + removeIndex);
        try {
            if (EON_Utility.genException != null && EON_Utility.genException){System.debug(lstApptVulnerability[0].name);}//To cover exception in test class
            if (removeIndex != null && lstApptVulnerability.size() >= removeIndex) {
                EON_Appointment_Vulnerability__c appVul = ((lstApptVulnerability[removeIndex].id != null) ? lstApptVulnerability[removeIndex] : null);
                if (appVul != null) {
                    delete appVul;
                }
                lstApptVulnerability.remove(removeIndex);
            }
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        }
        return null;
    }
    //CH01.End
    /**
        save() will initiate call to Update in OFSC and save the required data to intended objects
    **/
    public PageReference save() {
        System.debug('save Method is called');
        string errors = '';
        errors = mapFieldValues();
        //CH18.start
        if (String.isNotBlank(errors) && errors.equalsIgnoreCase('ErrorOccured')) {
            return null;
        }
        //CH18.end
         //CH21.New.Start
        if(Appt.MPAN__c != null && Appt.Requested_SSC__c == null){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Requested SSC is mandatory')); return null;}
        //CH21.New.End
        if (String.isNotBlank(errors) && errors.equalsIgnoreCase('Rejected')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Appointment was not sent to OFSC. Please contact administrator.'));
            return null;
        }
        if(!updateAppointment.E_Low_balance_alert_flag__c){updateAppointment.E_LowBalanceAlertValue__c = null;}
        if(!updateAppointment.G_Low_balance_alert_flag__c){updateAppointment.G_LowBalanceAlertValue__c = null;}
        if(!updateAppointment.E_Payment_Reminder_Opt_in_Flag__c){updateAppointment.E_Payment_Reminder_Frequency_Code__c = ''; updateAppointment.E_Payment_Reminder_Day_Of_The_Week__c = null; updateAppointment.E_Payment_Reminder_Date__c = null;}
        if(!updateAppointment.G_Payment_Reminder_Opt_in_Flag__c){updateAppointment.G_Payment_Reminder_Frequency_Code__c = ''; updateAppointment.G_Payment_Reminder_Day_Of_The_Week__c = null; updateAppointment.G_Payment_Reminder_Date__c = null;}
        if(updateAppointment.E_Payment_Reminder_Frequency_Code__c != null && updateAppointment.E_Payment_Reminder_Frequency_Code__c != '' && updateAppointment.E_Payment_Reminder_Frequency_Code__c == 'W'){updateAppointment.E_Payment_Reminder_Date__c = null;}
        if(updateAppointment.E_Payment_Reminder_Frequency_Code__c != null && updateAppointment.E_Payment_Reminder_Frequency_Code__c != '' && updateAppointment.E_Payment_Reminder_Frequency_Code__c == 'M'){updateAppointment.E_Payment_Reminder_Day_Of_The_Week__c = null;}
        if(updateAppointment.G_Payment_Reminder_Frequency_Code__c != null && updateAppointment.G_Payment_Reminder_Frequency_Code__c != '' && updateAppointment.G_Payment_Reminder_Frequency_Code__c == 'W'){updateAppointment.G_Payment_Reminder_Date__c = null;}
        if(updateAppointment.G_Payment_Reminder_Frequency_Code__c != null && updateAppointment.G_Payment_Reminder_Frequency_Code__c != '' && updateAppointment.G_Payment_Reminder_Frequency_Code__c == 'M'){updateAppointment.G_Payment_Reminder_Day_Of_The_Week__c = null;}
        //CH07.Start 
        errors = EON_OFSC_Helper.checkValidations(updateAppointment);
        if (string.isNotBlank(errors)) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errors)); return null;}
        //CH07.End
        //Inserting Appt Comm record.
        //CH08.Start
        list < EON_Appointment_Comms__c > commLst = new list < EON_Appointment_Comms__c > ();
        List < EON_Appointment_Comms__c > appCommsLst = getAppCommsLst();
        if (selectedDeliveryMethod_c != null && selectedDeliveryMethod_c != '') {
            EON_Appointment_Comms__c comm = new EON_Appointment_Comms__c();
            for (EON_Appointment_Comms__c commInst: appCommsLst) {
                if (commInst.Comm_Type_Code__c == 'C') {
                    comm = new EON_Appointment_Comms__c(Id = commInst.id);
                    break;
                }
            }
            if (comm.id == null) comm.EON_Appointment_ID__c = updateAppointment.id;
            comm.Comm_Type_Code__c = 'C';
            comm.Delivery_Method_Desc__c = selectedDeliveryMethod_c;
            commLst.add(comm);
        }
        if (selectedDeliveryMethod_I != null && selectedDeliveryMethod_I != '') {
            EON_Appointment_Comms__c comm1 = new EON_Appointment_Comms__c();
            for (EON_Appointment_Comms__c commInst: appCommsLst) {
                if (commInst.Comm_Type_Code__c == 'I') {
                    comm1 = new EON_Appointment_Comms__c(Id = commInst.id);
                    break;
                }
            }
            if (comm1.id == null) comm1.EON_Appointment_ID__c = updateAppointment.id;
            comm1.Comm_Type_Code__c = 'I';
            comm1.Delivery_Method_Desc__c = selectedDeliveryMethod_I;
            commLst.add(comm1);
        }
        if (selectedDeliveryMethod_R != null && selectedDeliveryMethod_R != '') {
            EON_Appointment_Comms__c comm2 = new EON_Appointment_Comms__c();
            for (EON_Appointment_Comms__c commInst: appCommsLst) {
                if (commInst.Comm_Type_Code__c == 'R') {
                    comm2 = new EON_Appointment_Comms__c(Id = commInst.id);
                    break;
                }
            }
            if (comm2.id == null) comm2.EON_Appointment_ID__c = updateAppointment.id;
            comm2.Comm_Type_Code__c = 'R';
            comm2.Delivery_Method_Desc__c = selectedDeliveryMethod_R;
            commLst.add(comm2);
        }
        //CH08.End
        //Inserting EON Appointment vulnerability record from EON site Vulnerability
        //CH01.Start
        for (EON_Appointment_Vulnerability__c appVul: lstApptVulnerability){if (appVul.EON_Appointment_ID__c == null) {appVul.EON_Appointment_ID__c = updateAppointment.id;}}
        
        Set<ID> lstContactTypeID = new set<ID>();//CH27
        for (EON_Appointment_Contact__c appContact: lstApptContact)
        {if (appContact.EON_Appointment_ID__c == null) {appContact.EON_Appointment_ID__c = updateAppointment.id;}
             lstContactTypeID.add(appContact.Contact_Type__c);//CH27
        }
        
        //CH27.Start
        boolean isContactTypeError = true;
        for(EON_Contact_Type__c contactType : [select name from EON_Contact_Type__c where id in : lstContactTypeID] ){
            if(contactType.name == 'Appointment Contact'){
                isContactTypeError = false;
                break;
            }
                
        }
        //CH27.End      
        
        ofscResponse = '';
        if (((updateAppointment.Post_Code__c != '' && updateAppointment.Post_Code__c != null) || (updateAppointment.Metering_Point_Postcode__c != '' && updateAppointment.Metering_Point_Postcode__c != null)) && (updateAppointment.Job_Code__c != null) && (updateAppointment.Oracle_Address__c != '' || updateAppointment.Oracle_Address__c != null)) {
            ofscResponse = EON_OFSC_Update_Appointment.sendActivityToOFSC(updateAppointment, lstApptContact, lstApptVulnerability, 'MUS');
            System.debug('ofscResponse = ' + ofscResponse);
            if (ofscResponse != '' && ofscResponse.containsIgnoreCase('successfully')) {
                Savepoint sp = Database.setSavepoint();
                try {
                
                    //CH27.Start
                    if(isContactTypeError){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                            'At least one EON Appointment Contact record with Appointment Contact type is mandatory'));
                        
                        return null;
                    }
                    //CH27.End
                
                    updateAppointment = EON_OFSC_Update_Appointment.objAppt;
                    //All DML statements
                    Update updateAppointment;
                    if (lstApptContact != null && lstApptContact.size() >= 1){upsert lstApptContact;} //CH16
                    system.debug('lstApptContact %%%' +lstApptContact );
                   //else{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'At least one EON Appointment Contacts record is mandatory'));} //CH16
                    if (commLst != null && commLst.size() > 0)
                        upsert commLst;
                    upsert lstApptVulnerability;
                    system.debug('Vul%%%' +lstApptVulnerability);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Appointment updated Successfully.'));
                    PageReference page = new PageReference('/apex/EON_Appointment_Booking');
                    page.setRedirect(true);
                    return null;} catch (DMLException ex) {Database.rollback(sp);system.debug('%erro%'+ex.getDMLMessage(0) ); ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDMLMessage(0)));}} else {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Appointment can\'t be updated, please contact administrator.'));}} else {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Appointment can\'t be updated,Required field missing: Post Code or Metering Point Postcode or Job Code or Oracle Address\n'));} return null;
        //CH01.End
    }
    /**
        cancel(): this method will redirect the user to Appointment Booking Home page.
    **/
    public PageReference cancel() {
        PageReference page = new PageReference('/apex/EON_Appointment_Booking');
        page.setRedirect(true);
        return page;
    }
    //CH02.Start
    /**
        isKeycollection(): This method will render the Key collection section if it is ticked then it will be displayed else remainng fields will be hide.
    **/
    public PageReference isKeycollection() {
        System.debug('Method called.');
        return null;
    }
    //CH02.end
    //CH11.Start
    /**
        getEonSSC(): This method will get the list of EON SCC values as picklist values.
    **/
    public List < SelectOption > getEonSSC() {
        //Add the None option to pick list
        List < SelectOption > eonSSCOptions = new List < SelectOption > { new SelectOption('', '-- None --') };
        //CH22.Start
        if (String.isNotBlank(Appt.MPAN__c)){ //CH22 Added condition if MPAN id not null
            //CH20 changed the map values from EONSSC to EONSSC.Name
            Map < String, String > mapofEonSSC = new Map < String, String > (); // to store the Key as Name+Type__c(SMart or Classic) and EONSSC.Name
            Map < String, String > mapClassicEonSSC = new Map < String, String > (); //CH20 to store the Classic EON SSC records.
            Boolean isTermination = false;
            //Query the records for EON SSC with Name of Current SSC or Type = SMART
            //CH25.start
            list<Eon_Appointment__c> apptreason = new list<Eon_Appointment__c>();
            list<Eon_Appointment__c> apptg = new list<Eon_Appointment__c>();
            Map<string, id> mGroupMap = new Map<string, id>();
            apptreason = [SELECT  Appointment_reason_code__r.name ,GSP_Group_ID__c from Eon_Appointment__c where ID = :  Appt.id ];
            apptg = [SELECT Id, GSP_Group_ID__c,Appointment_reason_code__r.name from Eon_Appointment__c where ID = :  Appt.id  and GSP_Group_ID__c!=null and GSP_Group_ID__c!='' and Appointment_reason_code__r.name !=null and    
            Appointment_reason_code__r.name !='' ];
            if(!apptg.isEmpty()){
               if(apptg[0].GSP_Group_ID__c != null && apptg[0].GSP_Group_ID__c !='' && apptg[0].Appointment_reason_code__r.name == 'New Connections'){for(EON_SSC_Group__c  gg :[select SSC__c,Group__c,Group__r.name, SSC__r.name from   EON_SSC_Group__c where Group__r.name  =:apptg[0].GSP_Group_ID__c]){mGroupMap.put(gg.SSC__r.name,gg.id);}}
            }//CH25.End
            for (EON_SSC__c eSSC: [SELECT ID, Name, Number_of_Registers__c, Type__c FROM EON_SSC__c WHERE Type__c != null OR Name = : Appt.Current_SSC__c Order by Type__c ASC LIMIT 50000]) {//CH20
                if (Appt.Job_Code__c != null && Appt.Job_Code__r.Name.containsIgnoreCase('SMART')){
                    if(String.isNotBlank(Appt.Current_SSC__c) && !(String.isNotBlank(Appt.h_Job_Type__c) &&         
                       Appt.h_Job_Type__c.containsIgnoreCase('New') && Appt.h_Job_Type__c.containsIgnoreCase('Connection')) &&  
                       eSSC.Name.equalsIgnoreCase(Appt.Current_SSC__c) && eSSC.Type__c.equalsIgnoreCase('Smart') ) {
                       //CH25.Start
                        if(apptreason[0].Appointment_reason_code__r.name == 'New Connections'  && mGroupMap!=null && mGroupMap.size() > 0 &&  mGroupMap.containsKey(eSSC.Name)){ return new List < SelectOption > { new SelectOption(eSSC.Name, eSSC.Name) };}//CH25.End
                        else if(apptreason[0].Appointment_reason_code__r.name == 'New Connections' &&  apptreason[0].GSP_Group_ID__c == null ){ return new List < SelectOption > { new SelectOption(eSSC.Name, eSSC.Name) };}      
                        else if(apptreason[0].Appointment_reason_code__r.name != 'New Connections' ){ return new List < SelectOption > { new SelectOption(eSSC.Name, eSSC.Name) };}
                    } 
                } 
                else {
                    if (!isTermination && Appt.Job_Code__c != null && String.isNotBlank(Appt.Current_SSC__c) && !(String.isNotBlank(Appt.h_Job_Type__c) && Appt.h_Job_Type__c.containsIgnoreCase('New') && Appt.h_Job_Type__c.containsIgnoreCase('Connection')) ){ isTermination = true; }
                }
                if (eSSC.Type__c.equalsIgnoreCase('Smart')) { mapofEonSSC.put(eSSC.Name,eSSC.Name); }
                if (eSSC.Type__c.equalsIgnoreCase('Classic')) { mapClassicEonSSC.put(eSSC.Name,eSSC.Name);}
            }
            //if eonSSCOptions is already has the size = 1 and current SSC is null or Current SSC is not exist in EON SSC then return all Smart EON SSC records 
            if (isTermination && ((mapClassicEonSSC.size() > 0 && mapClassicEonSSC.containsKey(Appt.Current_SSC__c)) || (mapofEonSSC.size() > 0 && mapofEonSSC.containsKey(Appt.Current_SSC__c)))){if(apptreason[0].Appointment_reason_code__r.name =='New Connections' && mGroupMap!=null && mGroupMap.size() > 0 &&  mGroupMap.containsKey(Appt.Current_SSC__c)){ return new List < SelectOption > { new SelectOption(Appt.Current_SSC__c, Appt.Current_SSC__c)};} if(apptreason[0].Appointment_reason_code__r.name =='New Connections' && apptreason[0].GSP_Group_ID__c == null ){ return new List < SelectOption > { new SelectOption(Appt.Current_SSC__c, Appt.Current_SSC__c)};} else if(apptreason[0].Appointment_reason_code__r.name!='New Connections'){ return new List < SelectOption > { new SelectOption(Appt.Current_SSC__c, Appt.Current_SSC__c)};}}//CH25
            //CH21 adding condition
            if (eonSSCOptions.size() == 1 && Appt.Job_Code__c != null && Appt.Job_Code__r.Name.containsIgnoreCase('SMART') && ((String.isNotBlank(Appt.h_Job_Type__c) && Appt.h_Job_Type__c.containsIgnoreCase('New') && Appt.h_Job_Type__c.containsIgnoreCase('Connection')) || String.isBlank(Appt.Current_SSC__c) ||  (mapofEonSSC.size() > 0 && !mapofEonSSC.containsKey(Appt.Current_SSC__c)) )) {
                for (String eSS: mapofEonSSC.values()){
                    //CH25.Start
                    if(apptreason[0].Appointment_reason_code__r.name == 'New Connections' && mGroupMap != null && mGroupMap.size() > 0 && mGroupMap.containsKey(eSS)){ eonSSCOptions.add(new SelectOption(eSS, eSS)); }
                    if(apptreason[0].Appointment_reason_code__r.name == 'New Connections' && apptreason[0].GSP_Group_ID__c == null){ eonSSCOptions.add(new SelectOption(eSS, eSS)); }
                    else if(apptreason[0].Appointment_reason_code__r.name != 'New Connections' ){ eonSSCOptions.add(new SelectOption(eSS, eSS)); }
                }
            }
            if (eonSSCOptions.size() == 1 && Appt.Job_Code__c != null && !Appt.Job_Code__r.Name.containsIgnoreCase('SMART') && (String.isNotBlank(Appt.h_Job_Type__c) && Appt.h_Job_Type__c.containsIgnoreCase('New') && Appt.h_Job_Type__c.containsIgnoreCase('Connection'))) {
                for (String eSS: mapClassicEonSSC.values() ) {
                    //CH25.Start
                    if(apptreason[0].Appointment_reason_code__r.name == 'New Connections' && mGroupMap!=null && mGroupMap.size() > 0 &&  mGroupMap.containsKey(eSS)){ eonSSCOptions.add(new SelectOption(eSS, eSS)); }
                    if(apptreason[0].Appointment_reason_code__r.name == 'New Connections' && apptreason[0].GSP_Group_ID__c == null ){ eonSSCOptions.add(new SelectOption(eSS, eSS)); }
                    else if(apptreason[0].Appointment_reason_code__r.name != 'New Connections') { eonSSCOptions.add(new SelectOption(eSS, eSS)); }
                }
            }
            if (eonSSCOptions.size() == 1 && Appt.Job_Code__r.Job_Type__c != null && !Appt.Job_Code__r.Job_Type__c.containsignorecase('New') && !Appt.Job_Code__r.Job_Type__c.containsignorecase('Connection') && Appt.Current_SSC__c != null && Appt.Current_SSC__c != '' && !Appt.Job_Code__r.Name.containsignorecase('SMART')){if(apptreason[0].Appointment_reason_code__r.name =='New Connections' && mGroupMap.size() > 0 &&  mGroupMap.containsKey(Appt.Current_SSC__c)){ return new List < SelectOption > { new SelectOption(Appt.Current_SSC__c, Appt.Current_SSC__c)};}if(apptreason[0].Appointment_reason_code__r.name =='New Connections' && apptreason[0].GSP_Group_ID__c == null){ return new List < SelectOption > { new SelectOption(Appt.Current_SSC__c, Appt.Current_SSC__c)};} else if(apptreason[0].Appointment_reason_code__r.name!='New Connections'){return new List < SelectOption > { new SelectOption(Appt.Current_SSC__c, Appt.Current_SSC__c)};}}//CH25
            //CH21.End
        }
        //CH22.end
        return eonSSCOptions;
    }
    //CH11.End
    
    //CH29.Start
    /**
        validateAppointmentContacts( List<EON_Appointment_Contact__c> lstAppContact) - This method validates the appointment contact records
    **/
    public boolean validateAppointmentContacts( List<EON_Appointment_Contact__c> lstAppContacts){

        Set<ID> lstContactTypeID = new set<ID>();
        for (EON_Appointment_Contact__c appContact: lstAppContacts){
            lstContactTypeID.add(appContact.Contact_Type__c);
        }
        boolean isContactTypeError = true;
        for(EON_Contact_Type__c contactType : [select name from EON_Contact_Type__c where id in : lstContactTypeID] ){
            if(contactType.name == 'Appointment Contact'){
                isContactTypeError = false;
                break;
            }
                
        }       
        
        return isContactTypeError;
    }  
    //CH29.End 
    
    //CH30.Start
    /**
        getEonSSC(): This method will get the list of EON SCC values as picklist values.
    **/
    public List < SelectOption > getEonSSCForGroup() {
        //Add the None option to pick list
        List < SelectOption > eonSSCOptions = new List < SelectOption > {
            new SelectOption('', '-- None --')
        };
        
        EON_Appointment__c orgApp = [select Requested_SSC__c ,Current_SSC__c,h_Job_type__c,Job_Code__r.Name, GSP_Group_ID__c
                                 , h_Job_Code__c from EON_Appointment__c  where id=:this.Appt.id];        
        
        if(orgApp.h_Job_Code__c.containsIgnoreCase('Smart') ||  //CH31 changed the field to job code.
                (String.isNotBlank(orgApp.Job_Code__r.Name) &&
                orgApp.Job_Code__r.Name.containsIgnoreCase('OOAMETERFUNCCHANGE'))){
            eonSSCOptions.add(new SelectOption('', '-- None --'));
            eonSSCOptions = getSSCGroup(orgApp.GSP_Group_ID__c, orgApp.Current_SSC__c);
            this.Appt.Requested_SSC__c = orgApp.Requested_SSC__c;
        }   
        return eonSSCOptions;         
    }    
    
    
    /**
        getSSCGroup() - This method returns the SSC names related to appointment group id.   
    **/
    public List<SelectOption> getSSCGroup(String groupID, String currentSSC){
        List<SelectOption> lstOption = new List<SelectOption>();
        boolean isExists = false;
        for(EON_SSC_Group__c SSCGroup: [select SSC__r.name from 
                                        EON_SSC_Group__c where Group__r.name = : groupID]){
            
            if(CurrentSSC == SSCGroup.SSC__r.Name)
                isExists = true;
                                                        
            lstOption.add(new SelectOption(SSCGroup.SSC__r.Name, SSCGroup.SSC__r.Name));
        }
        if(!isExists && currentSSC != null)
            lstOption.add(new SelectOption(currentSSC, currentSSC));
            
        return lstOption;
    }     
    //CH30.End  
}