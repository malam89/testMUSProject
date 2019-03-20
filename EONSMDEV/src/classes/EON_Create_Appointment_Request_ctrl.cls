/**
    Description: this page will allow the user to enter the details on the screen and will displays the result of create appointment validata functions.
    Test class : EON_Create_Appointment_Request_ctrl_Test
                 EON_Create_Appointment_Request_ctrlTest
**/
/*
    Created By : Sivasankar K
    On : 21/04/2016
    SR : SR_EON_AB_033
    Change History : 
    CH01 # SR_EON_AB_049 # 06/05/2016 # Nitin # Added field mapping for Fuel ID and Job Code with the selected Fuel on Appointment Booking Portal.
    CH02 # SR_EON_AB_044 # 10-05-2016 # Sivasankar K # Adding the functionality for displaying the Site Vulnerabilities to add and remove them.
    CH03 # SR_EON_AB_064 # 26/05/2016 # Nitin # Added standard controller to the page. Displayed all the fields for creatinf appointment as per EON_Update_Appointment page.
    CH04 # SR_EON_AB_070 # 17/06/2016 # Aruna Manjari # Changed the error message generating.
    CH05 # SR_EON_AB_071 # 23/06/2016 # Dharmendra P # Added EON Appointment Validations 
    CH06 # SR_EON_AB_077 # 29/06/2016 # Akshay # changed API Name 
    CH07 # SR_EON_AB_066 # 29/06/2016 # Akshay # Added functionality related to changing of lookup to picklist.
    CH09 # SR_EON_AB_084 # 06/07/2016 # Dharmendra P # Added method to render section on page
    CH10 # SR_EON_AB_088 # 15-07-2016 # Sivasankar K # Adding Current SSC field in layout and changing Requested SSC field from text to lookup.
    CH11 # SR_EON_AB_086 # 19-07-2016 # Praveen # Amending the logic for allowing user to create appointment for New Connections as well.
    CH12 # SR_EON_AB_083 # 28-07-2016 # Sivasankar K # Amending the logic for calcuating the oracle bucketID.
    CH13 # SR_EON_AB_108 # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text 
    CH14 # SR_EON_AB_104 # 01/08/2016 # Tashika # Added functionality related to changing of lookup to picklist and more.
    CH15 # SR_EON_AB_100 # 03/08/2016 # Sivasankar # Added logic for updating the Planned E Meter Type and Planned G Meter Type values  = MS1.
    CH16 # SR_EON_AB_115 # 04/08/2016 # Dharmendra P # Added Appointmnet Reason field functionality.
    CH17 # SR_EON_AB_119 # 09/08/2016 # Sivasankar K # Adding the logic for populating the Planned E Meter Type and Planned G Meter Type if the Job Type is not SMART. 
    CH18 # SR_EON_AB_122 # 11/08/2016 # Shruti Moghe #updated functionality for ECO jobs
    CH19 # SR_EON_AB_116 # 09/08/2016 # Puneet Mehta # Adding code for vulnerability code mapping
    CH20 # SR_EON_AB_125 # 24/08/2016 # Sivasankar K # Adding the logic for Not MAM logic
    CH21 # SR_EON_AB_131 # 07/09/2016 # Sivasankar K # Amending the validation method that not to calculate the work skill and calculat it on Save click.
    CH22 # SR_EON_AB_135 # 08/09/2016 # Aruna Manjari # Added conditions 1.All Smart jobs must have 3 EON Appointment Comms records. 2.All jobs must have at least 1 EON Appointment Contacts records  
    CH23 # SR_EON_AB_146 # 13/09/2016 # Shruti Moghe # Added pattern for E Low Balance Alert Value and G Low Balance Alert Value fields
    CH24 # SR_EON_AB_148 # 14/09/2016 # Puneet Mehta # Changed condition for Data Consent Section
    CH25 # SR_EON_AB_140 # 08/09/2016 # Praveen G # Added logic to display e meter location is there in appointment record.
    CH26 # SR_EON_AB_150 # 20/09/2016 # Mahadev J # Amended'Request SSC' is required if 'EON Job' has MPAN required as 'True'
    CH27 # SR_EON_AB_160 # 05/10/2016 # Puneet Mehta #  Enabled Gas/Electric New Connection appointments to be created via the Appointment Booking Portal using the Industry Search where calls to J19/J18 calls retrieve no meter details.
    CH28 # SR_EON_AB_161 # 05/10/2016 # Puneet Mehta #  Queried and mapped new field from EON Fuel record: h_Gas_Supplier_MPID
    CH29 # SR_EON_AB_159 # 10/10/2016 # Sivasankar # Amending the method to display the EON SSC.
    CH30 # SR_EON_AB_168 # 17/10/2016 # Puneet Mehta # Default appointment reason to Customer Request
    CH31 # SR_EON_AB_177 # 25/10/2016 # Puneet Mehta # IF Metering Pressure = FALSE then default the value to LOW
    CH32 # SR_EON_AB_182 # 31/10/2016 # Mahadev J # Validation for Media Detail based upon Media Type.
    CH33 # SR_EON_AB_180 # 04/11/2016 # Puneet Mehta # If MUS is the MAM of the relevant MPRN then we should get the data from JUMBO. Else if we are not MAM then the data should come from EON Fuel to populate the Gas MArket Participant Id field
    CH34 # SR_EON_AB_186 # 09/11/2016 # Puneet Mehta # Changed regex to validate email,mobile and telephone number
    CH35 # SR_EON_AB_183 # 10/11/2016 # Aruna Manjari# added the logic to display EON SSC on the screen based on the EON GSP Group if the value match JUMBO J.18 values
    CH36 # SR_EON_Jumbo_091 # 14/12/2016 # Puneet Mehta # Mapped new field from EON Fuel 'Gas Map Identifier'
    CH37 # SR_EON_Jumbo_096 # 12/01/2017 # Puneet Mehta # Mapped new field from EON Fuel
    CH38 # SR_EON_Jumbo_107 # 20/02/2017 # Puneet Mehta # Mapped new field from EON Fuel
    CH39 # SR_EON_AB_202 # 21/02/2017 # Praveen G # added logic to default planned meter mode.
    CH40 # SR_EON_AB_212 # 23/03/2017 # Praveen G# updated the field value for VulnerabilityTypeID
    CH41 # SR_EON_AB_215 #28/03/2017 # Aruna Manjari # When creating an appointment the Planned E Meter Type on an OOAMETERFUNCHANGE should default to <blank> else should throw error 
    CH42 # SR_EON_Jumbo_106 # 30/03/2017 # Mahadev J# Amended logic to create EON Appointment Meter
    CH43 # SR_OptiMUS_EON_053 # 11-04-2017 # Aruna manjari # Prevent deletion of the final appointment contact record once at least 1 exists.
    CH44 # SR_OptiMUS_EON_068 # 02/06/2017 # Praveen G# Added condition to not update the planned meter mode value.
    CH45 # SR_OptiMUS_EON_072 # 05/06/2017 # Praveen G# Added new condition for app contact record validation.
    CH46 # SR_OptiMUS_EON_079 # 20/06/2017 # Praveen G# Amanded the contact type picklist values.
    CH47 # SR_OptiMUS_EON_076 # 13/07/2017 # Praveen G# Added new condition for app contact record validation for delete.
    CH48 # SR_OptiMUS_EON_094 # 05/09/2017 # Praveen G# Not allow delete appointment contacts once save is clicked.
    CH49 # SR_OptiMUS_EON_155 # 02/11/2017 # Praveen G# New changes to validate / populate Requested SSC.
    CH50 # Checkmarx # 05/02/2018 # Mahadev J# Code security check.
    CH51 # SR_OptiMUS_EON_200 # 19/02/2018 # Mehboob Alam # Added new field.
    CH52 # SR_OptiMUS_EON_257 # 19/07/2018 # Mehboob Alam # populating booking system name as per Market Participant ID return from Jumbo.
    CH53 # SR_OptiMUS_EON_248 # 13/08/2018 # Shruti Moghe # added logic to create appt contacts on load from customer
	CH54 # SR_OptiMUS_EON_297 # 11/02/2019 # Tabish Almas # Added logic to get data from MDS or Jumbo based on MDS Jumbo Dataflow Switch
*/
public with sharing class EON_Create_Appointment_Request_ctrl {
    public list<EON_Appointment_Meter__c> allApptMeter = new list<EON_Appointment_Meter__c>(); //CH42.New
    //CH07.Start
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
    //CH14.Start
    public List < SelectOption > ContactLst {
        get;
        set;
    }
    public String selectedContact {
        get;
        set;
    }
    
    public List < SelectOption > VulnerabilityLst {
        get;
        set;
    }
    public String selectedVulnerability {
        get;
        set;
    }
    //CH14.End
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
    public List < SelectOption > DeliveryMethodLst {
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
    } // this will hold the Contact 
    //CH07.End    
    public Boolean fieldSetVisibility {
        get;
        set;
    } //CH09
    public boolean updateCOntact{get;set;}//CH53
    public String selectedAppRea {
        get;
        set;
    } //CH16
    public List < SelectOption > appReasonLst {
        get;
        set;
    } //CH16 
    public Map < string, EON_Vulnerability_Code__c > eVulCodeMap = new Map < string, EON_Vulnerability_Code__c > (); //CH19
    public Set < string > vulDetailCodeSet = new Set < string > (); //CH19
    public Set < string > vulDescriptionSet = new Set < string > (); //CH19
    /**
        newAppointment : this method will assign the EON_appointment__c record.
    **/
    public Eon_Appointment__c newAppointment {
        get {
            if (newAppointment == null)
                newAppointment = new Eon_Appointment__c();
            return newAppointment;
        }
        set;
    }
    /**
        selectedFuelID: get the selected Fuel ID from page.
    **/
    public String selectedFuelID {
        get {
            if (selectedFuelID == null)
                //selectedFuelID = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('fuelID')); //CH50.New
                selectedFuelID = ApexPages.CurrentPage().getParameters().get('fuelID'); //CH50.Old
            return selectedFuelID;
        }
        set;
    }

    //CH11.Start
    public String appReason {
        get;
        set;
    }
    public String appointmentID {
        get;
        set;
    }
    //CH11.End
    /**
        selFuelRecord : this will get the selected Fuel record
    **/
    public EON_Fuel__c selFuelRecord {
        get {
            if (selFuelRecord == null && selectedFuelID != null && selectedFuelID != '') {//CH36 Added Gas_Map_identifier__c to query //CH38 Added h_Gas_units_of_measure_A0123__c to query
                selFuelRecord = [SELECT Gas_multiplication_factor_A0120__c,h_Gas_units_of_measure_A0123__c,Gas_units_of_measure_A0123__c,Gas_year_of_manufacture_A0021__c,ID, Gas_Map_identifier__c, Fuel_type__c, MPAN__c, MPRN__c, Gas_manufacturer_code_A0060__c, Gas_measuring_capacity_A0112__c, Gas_Meter_Mechanism__c, Gas_meter_serial_number__c, Electric_Meter_Location__c, Gas_meter_location__c, h_Gas_Supplier_MPID__c, /*CH28*/
                    Gas_meter_type_A0025__c, Gas_model_A0083__c, Gas_number_of_dials_or_digits_A0121__c, Gas_payment_method_A0163__c, Gas_supplier_code__c,
                    Premise__r.Building_Name__c, Premise__r.Dependant_Locality__c, Premise__r.Dependant_Thorofare__c, Premise__r.Double_Dependant_Locality__c,
                    Premise__r.Sub_Building_Name__c, Premise__r.Thorofare__c, Premise__r.Town__c, Premise__r.Customer__c, Premise__r.Customer__r.Customer_Name__c,
                    Premise__c, Premise__r.Postcode__c, Premise__r.Customer__r.Customer_group_type__c, Premise__r.Customer__r.PAYG_Flag__c, Gas_Meter_Mechanism__r.Code__c // CH05,CH20
                    FROM EON_Fuel__c
                    WHERE Id = : selectedFuelID
                ];//CH37 Added new field in query
            } else if (selFuelRecord == null) {
                selFuelRecord = new EON_Fuel__c();
                system.debug('%%%%%Value at line 192%%%%%%%');
            }
            return selFuelRecord;
        }
        set;
    }
    /**
        selJobRecord : this will get the selected Job record
    **/
    public List < EON_Job__c > selJobRecord {
        get {
            if (selFuelRecord != null && selFuelRecord.Fuel_type__c != null) {
                selJobRecord = new List < EON_Job__c > ([SELECT ID, Name, Duration__c, h_Job_Attribute_Duration__c, Job_Type__c, Inactive__c, MAM_Reqd__c, MOP_Reqd__c, MPAN_Reqd__c, MPRN_Reqd__c, (Select ID, Appointment_Reason__r.name, Appointment_Reason__c from EON_Job_Appointment_Reasons__r) FROM EON_Job__c WHERE Name = : ((selFuelRecord.Fuel_type__c.equalsIgnoreCase('E')) ? 'OOASMARTELECEXCH' : (selFuelRecord.Fuel_type__c.equalsIgnoreCase('D')) ? 'OOASMARTDFEXCH' : '')]);
                //CH26.New.Start
                if (selJobRecord != null && selJobRecord.size() > 0 && selJobRecord[0] != null) {
                    if (selJobRecord[0].EON_Job_Appointment_Reasons__r != null) {
                        appReasonLst = new List < SelectOption > ();
                        for (EON_Job_Appointment_Reason__c res: selJobRecord[0].EON_Job_Appointment_Reasons__r) {
                            if (selectedFuelID != null && selectedFuelID != '' && res.Appointment_Reason__r.name == 'Customer Request') {
                                selectedAppRea = res.Appointment_Reason__c;
                            } //CH30
                            appReasonLst.add(new SelectOption(res.Appointment_Reason__c, res.Appointment_Reason__r.name));
                             system.debug('%%%%Debug at line 214');
                        }
                    }
                }
                //CH26.New.End
            } else
                selJobRecord = new List < EON_Job__c > ();
            return selJobRecord;
        }
        set;
    }
    /**
        jobAttParam: this will fetches the EON_Job_Attribute records.
    **/
    public List < EON_Job_Attribute__c > jobAttParam {
        get {
            if (selJobRecord != null && !selJobRecord.isEmpty() && selJobRecord[0].id != null && jobAttParam == null)
                jobAttParam = new List < EON_Job_Attribute__c > ([SELECT ID, Eon_Job__c, Name, Duration__c, Value__c, Inactive__c FROM EON_Job_Attribute__c WHERE Eon_Job__c = : selJobRecord[0].id]);
            else {
                jobAttParam = new List < EON_Job_Attribute__c > ();
            }
            return jobAttParam;
        }
        set;
    }

    /**
        lstJumboTracker : this will store the list of Jumbo Tracker records.
    **/
    public List < JUMBO_Data_Tracker__c > lstJumboTracker {
            get {
                if (lstJumboTracker == null)
                    lstJumboTracker = new List < JUMBO_Data_Tracker__c > ();
                return lstJumboTracker;
            }
            set;
        }
		
	//CH54.Start
	/**
        lstMDSTracker : this will store the list of MDS Tracker records.
    **/
    public List < MDS_Data_Tracker__c > lstMDSTracker {
            get {
                if (lstMDSTracker == null)
                    lstMDSTracker = new List < MDS_Data_Tracker__c > ();
                return lstMDSTracker;
            }
            set;
        }
	//CH54.End
	
    /**
        oracleBucketID : this will get the Oracle bucket ID
    **/
    public String oracleBucketID {
        get {
            if (oracleBucketID == null)
                oracleBucketID = '';
            return oracleBucketID;
        }
        set;
    }
    /**
        isRejected : to check the errors are persent or not
    **/
    public Boolean isRejected {
        get {
            if (isRejected == null)
                isRejected = false;
            return isRejected;
        }
        set;
    }

    /**
        isRejected : to check the errors are persent or not
    **/
    public Boolean canProceed {
        get {
            if (canProceed == null)
                canProceed = false;
            return canProceed;
        }
        set;
    }
       /**
        isupdatecon : to check the errors are persent or not
    **/
    public Boolean isupdatecon {
        get {
            if (isupdatecon == null)
                isupdatecon = false;
            return isupdatecon;
        }
        set;
    }
    public EON_Appointment_Comms__c ApptComms {
        get;
        set;
    } //CH03
    public EON_Appointment_Contact__c ApptCont {
        get;
        set;
    } // CH03
    public EON_Appointment__c Appt {
        get;
        set;
    } // CH03
    public static Date eEff_From_Date {
        get;
        set;
    } // to store the effective From date
    public static Date eEff_To_Date {
        get;
        set;
    } // to store the effective To date.
    //CH02.Start
    public static boolean CustPaygFlag {
        get;
        set;
    } //CH05
    public List < EON_Appointment_Vulnerability__c > eonApptVulnerabilities {
        get;
        set;
    }
    public EON_Appointment_Vulnerability__c eonApptVulnerability {
        get;
        set;
    }
    public String addErrorMsg {
        get;
        set;
    }
    public Integer removeIndex {
        get;
        set;
    } // this will store the selected Appointment Vulnerability.
    //CH03.start
    public EON_Create_Appointment_Request_ctrl(ApexPages.StandardController controller) {
        appReason = ApexPages.CurrentPage().getParameters().get('appReason'); //CH11
        appointmentID = ApexPages.CurrentPage().getParameters().get('appointmentID'); //CH11 changing the parameter to id from appointmentID
        ApptCont = new EON_Appointment_Contact__c();
        ApptComms = new EON_Appointment_Comms__c();
        this.Appt = (EON_Appointment__c) controller.getRecord(); //CH03
         system.debug('%%%%Debug at line 333');
        //CH39.start       
        String isPortfolio = ApexPages.CurrentPage().getParameters().get('source');
        if(isPortfolio == 'portfolio'){
            if(selFuelRecord.Premise__r.Customer__r.PAYG_Flag__c == 'Y')
                this.Appt.Planned_Meter_Mode__c = 'PAYG';
            else
                this.Appt.Planned_Meter_Mode__c = 'CR';    
        }
        //CH39.end
        
        //CH51.Start
        if(System.currentPageReference().getParameters().ContainsKey('Eligible'))
           this.Appt.Subject_of_Eligibility_Override__c = true;
           else        
              this.Appt.Subject_of_Eligibility_Override__c = false;
        //CH51.End
                
        eonApptVulnerabilities = new List < EON_Appointment_Vulnerability__c > ();
        //CH09.start
        if (appReason != null && appReason != '') {
            List < Eon_Appointment_Reason__c > lstreason = new List < Eon_Appointment_Reason__c > ([select id from Eon_Appointment_Reason__c where name = : appReason]); //CH16
            selectedAppRea = lstreason != null && lstreason.size() > 0 ? lstreason[0].id : ''; //CH16
        }
        if (appt.Planned_Meter_Mode__c == 'PAYG' && (!selJobRecord.isEmpty() && selJobRecord.size() > 0 && string.isNotBlank(selJobRecord[0].Job_Type__c) && selJobRecord[0].Job_Type__c.containsIgnoreCase('smart') && (string.isNotBlank(selFuelRecord.MPAN__c) || string.isNotBlank(selFuelRecord.MPRN__c))) || (Appt.Job_Code__c != null && Appt.Job_Code__r.Name != null && Appt.Job_Code__r.Name.containsIgnoreCase('SMART')))
            fieldSetVisibility = true;
        else
            fieldSetVisibility = false;
        if (appt.Planned_Meter_Mode__c != 'PAYG') {
            fieldSetVisibility = false;
        }
        //CH09.end
        Set<String> setVTypeCode = new Set<String>();
        if (selFuelRecord.Premise__c != null)
            for (EON_Site_Vulnerability__c siteVul: [SELECT ID, Vulnerability_code__c, EON_Site_Vulnerability_Change_Type__c, 
                                                        Vulnerability_code__r.Vulnerability_Code__c, Vulnerability_Type__c 
                                                        FROM EON_Site_Vulnerability__c WHERE Premise__c = : selFuelRecord.Premise__c]) {
                //eonApptVulnerabilities.add(new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = Appt.id, Description__c = siteVul.Vulnerability_code__c, VulnerabilityTypeID__c = siteVul.EON_Site_Vulnerability_Change_Type__c, VulnerabilityDetailCode__c = siteVul.Vulnerability_code__r.Vulnerability_Code__c));
                 system.debug('%%%%Debug at line 364');
                //CH40.Start                
                if(!setVTypeCode.Contains(siteVul.Vulnerability_code__c + siteVul.Vulnerability_Type__c)){
                    setVTypeCode.add(siteVul.Vulnerability_code__c + siteVul.Vulnerability_Type__c);
                    EON_Appointment_Vulnerability__c tempAppVul = new EON_Appointment_Vulnerability__c();
                    tempAppVul.EON_Appointment_ID__c = Appt.id;
                    tempAppVul.Description__c = siteVul.Vulnerability_code__c;
                     system.debug('%%%%Debug at line 371');
                    if(siteVul.Vulnerability_Type__c == 'C')
                        tempAppVul.VulnerabilityTypeID__c = 'Customer level';
                     else if(siteVul.Vulnerability_Type__c == 'H')  
                        tempAppVul.VulnerabilityTypeID__c = 'Household level';
    
                    tempAppVul.VulnerabilityDetailCode__c = siteVul.Vulnerability_code__r.Vulnerability_Code__c;
                    eonApptVulnerabilities.add(tempAppVul);                    
                }
                //CH40.end
                
                // CH19
                if (siteVul.Vulnerability_code__c != null) {
                    vulDescriptionSet.add(String.valueOf(siteVul.Vulnerability_code__c));
                    if (siteVul.Vulnerability_code__r.Vulnerability_Code__c != null)
                        vulDetailCodeSet.add(String.valueOf(siteVul.Vulnerability_code__r.Vulnerability_Code__c));
                }
                // CH19
            }
        eonApptVulnerability = new EON_Appointment_Vulnerability__c();
        //CH07.Start
        lstApptContact = new List < EON_Appointment_Contact__c > ([SELECT Contact_Full_Name__c, Contact_Type__c, Id,
            Name, Customer_Assistant__c, EON_Appointment_ID__c, Media_Detail__c, Media_Type__c
            FROM EON_Appointment_Contact__c WHERE EON_Appointment_ID__c = : Appt.id
        ]);
         //CH53.start
        list < EON_Contact_Type__c > ContactList = [select id, name from EON_Contact_Type__c where name='Reminder Contact (Default)' limit 1];
        list < EON_Media_Type__c > MTypelist = [select id, name from EON_Media_Type__c where name='Email' limit 1 ];
        List<EON_Contact_media__c> LstCOnMedia = new List<EON_Contact_media__c>([select id, Contact_method_type__c,Contact_method_type__r.Name,Customer__c,Email__c from EON_Contact_media__c where Contact_method_type__r.Name='Electronic Mail' and Customer__c=:selFuelRecord.Premise__r.Customer__c]);
        List<EON_Contact_representative__c> LstConReps = new List<EON_Contact_representative__c>([select id, Contact_Name__c from EON_Contact_representative__c where Customer__c=:selFuelRecord.Premise__r.Customer__c]);
        
        System.debug('LstCOnMedia-->'+LstCOnMedia);
        if(LstCOnMedia!=null && LstCOnMedia.size()>0){
            for(EON_Contact_media__c media : LstCOnMedia){
                EON_Appointment_Contact__c contact = new EON_Appointment_Contact__c();
                contact.Contact_Full_Name__c= LstConReps.size()>0 ? LstConReps[0].Contact_Name__c:'';
                contact.Contact_Type__c=ContactList[0].id;
                contact.Media_Type__c=MTypelist[0].id;
                contact.Media_Detail__c=media.Email__c;
                contact.EON_Appointment_ID__c=Appt.id;
                lstApptContact.add(contact);
            }
        }
        //CH53.end
        //CH25.Start
        EON_Appointment__c appoint = new EON_Appointment__c();
        if (appointmentID != null)
            appoint = [select G_Meter_Location__c, E_Meter_Location__c from EON_Appointment__c where id = : appointmentID];
        System.debug('***E_Meter_Location__r.Name ' + appoint.E_Meter_Location__c);
        if (appointmentID != null) {
            selectedGMetLoc = appoint.G_Meter_Location__C;
            selectedEMetLoc = appoint.E_Meter_Location__C;
        } else {
            selectedGMetLoc = selFuelRecord.Gas_meter_location__c;
            selectedEMetLoc = selFuelRecord.Electric_Meter_Location__c;
        }
        //CH25.End
                updateCOntact=false;
        selectedParking = Appt.Parking_Type__c;
        getParkingTypes();
        getEMeterloc();
        getGMeterloc();
        getMediaType();
        //CH14.Start
        getContactTypes();
        getVulnerablities();
        //CH14.End
        //CH07.End
        getAppReasons(); //CH16
    }
    //CH03.End
    //CH07.Start
    public void getMediaType() {
        if(updateCOntact && Apptcont!=null) selectedMediaType=ApptCont.Media_Type__c;
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
    //CH16
    public void getAppReasons() {}
    //CH14.Start
    public void getContactTypes() {
            // if(updateCOntact && Apptcont!=null) selectedContact =Apptcont.Contact_Type__c;
   
        list < EON_Contact_Type__c > ContactList = [select id, name from EON_Contact_Type__c 
                                                    order by Name //CH45
                                                    limit 50000];
        if (ContactList != null && ContactList.size() > 0) {
            ContactLst = new List < SelectOption > ();
            for (EON_Contact_Type__c contact: ContactList) {
                //CH46.Start
                String cName = contact.Name;
                if(contact.Name == 'Appointment Contact')
                    cName = 'Appointment Contact (Default)';
                else if(contact.Name == 'Reminder Contact (Default)')
                    cName = 'Reminder Contact';
                    
                ContactLst.add(new SelectOption(contact.id, cName));      
                //CH46.End
                //ContactLst.add(new SelectOption(contact.id, contact.name));//CH46.Old
                
            }

        }    }
    public void getVulnerablities() {
        list < EON_Vulnerability_Code__c > VulnerabilityList = [select id, name from EON_Vulnerability_Code__c limit 50000];
        if (VulnerabilityList != null && VulnerabilityList.size() > 0) {
            VulnerabilityLst = new List < SelectOption > ();
            for (EON_Vulnerability_Code__c vulnerability: VulnerabilityList) {
                VulnerabilityLst.add(new SelectOption(vulnerability.id, vulnerability.name));
            }
        }
    }
    //CH14.End
    public void getDeliveryMethod() {
        if (DeliveryMethodLst == null || DeliveryMethodLst.size() == 0) {
            list < Eon_Delivery_Method__c > DMlist = [select id, name from Eon_Delivery_Method__c limit 50000];
            if (DMlist != null && DMlist.size() > 0) {
                DeliveryMethodLst = new List < SelectOption > ();
                System.debug('==>' + newAppointment.Job_Code__c + ', newAppointment.Job_Code__r.Name = ' + newAppointment.Job_Code__r.Name + ', = ' + selJobRecord);
                if ((newAppointment.Job_Code__c != null && newAppointment.Job_Code__r.Name != null && !newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART')) || (selJobRecord != null && selJobRecord.size() > 0 && !selJobRecord[0].name.containsIgnoreCase('SMART'))) {DeliveryMethodLst.add(new SelectOption('', '--None--'));}//CH22.Start
                for (Eon_Delivery_Method__c DM: DMlist) {
                    if (String.isNotBlank(DM.Name) && DM.Name.containsIgnoreCase('None') && ((newAppointment.Job_Code__c != null && newAppointment.Job_Code__r.Name != null && newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART')) || (String.isBlank(appReason) && selJobRecord != null && selJobRecord.size() > 0 && selJobRecord[0].name.containsIgnoreCase('SMART')))) {
                        selectedDeliveryMethod_c = (String.isBlank(selectedDeliveryMethod_c) ? DM.id : selectedDeliveryMethod_c);
                        selectedDeliveryMethod_I = (String.isBlank(selectedDeliveryMethod_I) ? DM.id : selectedDeliveryMethod_I);
                        selectedDeliveryMethod_R = (String.isBlank(selectedDeliveryMethod_R) ? DM.id : selectedDeliveryMethod_R);
                    }
                    DeliveryMethodLst.add(new SelectOption(DM.id, DM.name));
                }
            }
        }
    } //CH08.Start
    /**
        addRowCon(): This method will add the new row to the list to for adding the new Appointment Contact.
    **/
    public PageReference addRowCon() {
        if (lstApptContact == null) {
            lstApptContact = new List < EON_Appointment_Contact__c > ();
        }
        if (selectedContact != null && ApptCont.Contact_Full_Name__c != null && selectedMediaType != null && ApptCont.Media_Detail__c != null) { //CH14
            //CH32.New.Start
            boolean addContact = true;
            String mediaType = '';
            String emailRegex = '^([\\w-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([\\w-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$'; //CH34.NEW
            String telRegex = '^(?:(?:\\(?(?:0(?:0|11)\\)?[\\s-]?\\(?|\\+)44\\)?[\\s-]?(?:\\(?0\\)?[\\s-]?)?)|(?:\\(?0))(?:(?:\\d{5}\\)?[\\s-]?\\d{4,5})|(?:\\d{4}\\)?[\\s-]?(?:\\d{5}|\\d{3}[\\s-]?\\d{3}))|(?:\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{3,4})|(?:\\d{2}\\)?[\\s-]?\\d{4}[\\s-]?\\d{4}))(?:[\\s-]?(?:x|ext\\.?|\\#)\\d{3,4})?$'; //CH34.NEW
            String mobileRegex = '^(?:(?:\\(?(?:0(?:0|11)\\)?[\\s-]?\\(?|\\+)44\\)?[\\s-]?(?:\\(?0\\)?[\\s-]?)?)|(?:\\(?0))(?:(?:\\d{5}\\)?[\\s-]?\\d{4,5})|(?:\\d{4}\\)?[\\s-]?(?:\\d{5}|\\d{3}[\\s-]?\\d{3}))|(?:\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{3,4})|(?:\\d{2}\\)?[\\s-]?\\d{4}[\\s-]?\\d{4}))(?:[\\s-]?(?:x|ext\\.?|\\#)\\d{3,4})?$'; //CH34.NEW
            if (!MediaTypeLst.isEmpty()) {
                for (SelectOption mediaOption: MediaTypeLst) {
                    if (mediaOption.getValue() == selectedMediaType) {
                        mediaType = mediaOption.getLabel();
                        break;
                    }
                }
                if (mediaType.equalsIgnoreCase('Telephone')) {
                    Pattern MyPattern = Pattern.compile(telRegex);
                    Matcher MyMatcher = MyPattern.matcher(ApptCont.Media_Detail__c);
                    if (!MyMatcher.matches()) {
                        addErrorMsg = 'Contact Media Detail must be a valid telephone number';
                        addContact = false;
                    }
                }
                if (mediaType.equalsIgnoreCase('Email')) {
                    Pattern MyPattern = Pattern.compile(emailRegex);
                    Matcher MyMatcher = MyPattern.matcher(ApptCont.Media_Detail__c);
                    if (!MyMatcher.matches()) {
                        addErrorMsg = 'Contact Media Detail must be a valid email address';
                        addContact = false;
                    }
                }
                if (mediaType.equalsIgnoreCase('Mobile')) {
                    Pattern MyPattern = Pattern.compile(mobileRegex);
                    Matcher MyMatcher = MyPattern.matcher(ApptCont.Media_Detail__c);
                    if (!MyMatcher.matches()) {
                        addErrorMsg = 'Contact Media Detail must be a valid mobile number';
                        addContact = false;
                    }
                }
            }
            //CH32.New.End
            if (addContact) {
                EON_Appointment_Contact__c cont = new EON_Appointment_Contact__c();
                cont.EON_Appointment_ID__c = newAppointment.id;
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
                 system.debug('%%%%Debug at line 559');
            }
        } else {
            addErrorMsg = 'Any of the following fields: Contact Type, Contact Full Name, Media Type, Media Detail can\'t be blank';
        }
        return null;
    }
    /**
        removeRowCon(): This method will remove the record from the list and delete the record from isis.
    **/
    public PageReference removeRowCon() {
        if(!canProceed){ //Ch48
            System.debug('index to remove = ' + removeIndex);
            System.debug('lstApptContact.size' + lstApptContact.size());
            try {
                if (removeIndex != null && lstApptContact.size() >= removeIndex) {
                    EON_Appointment_Contact__c appcon = ((lstApptContact[removeIndex].id != null) ? lstApptContact[removeIndex] : null);
                    
                    //CH47.
                    List<EON_Appointment_Contact__c> lstTemp = new List<EON_Appointment_Contact__c>(lstApptContact);
                    lstTemp.remove(removeIndex);
                    boolean isAllow = validateAppointmentContacts(lstTemp);
                    //CH47.end
                    
                    if (appcon != null  && lstApptContact.size()>1 
                                    && !isAllow) //CH47
                    { delete appcon;} //CH43 added the condition
                    
                    if(lstApptContact.size()!=1 //CH43
                                            && !isAllow) //CH47
                    lstApptContact.remove(removeIndex);
                }
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            }
        }else//CH48
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You are not allowed to delete'));
        
        return null;
    }
    //CH08.End
    //CH07.End
    /**
        EON_Create_Appointment_Request_ctrl(): Default constructor
    **/
    public EON_Create_Appointment_Request_ctrl() {}
    /**
        addRow(): This method will add the new row to the list to for adding the new Eon Site Vulnerability.
    **/
    public PageReference addRow() {
        //Vulnerability_Type__c,EON_Site_Vulnerability_Change_Type__c
        //CH14.Start
        if (selectedVulnerability != null) {
            if (vulDescriptionSet != null && vulDescriptionSet.size() > 0 && vulDescriptionSet.contains(selectedVulnerability)) { addErrorMsg = 'Duplicate records not allowed';} //CH19
            else {
                vulDescriptionSet.add(selectedVulnerability); //CH19
                eonApptVulnerability.Description__c = selectedVulnerability;
                if ((eonApptVulnerability.VulnerabilityTypeID__c == null || eonApptVulnerability.VulnerabilityTypeID__c == '') && (selectedVulnerability != null && selectedVulnerability != '')) {
                    addErrorMsg = 'Vulnerability type field is mandatory if vulnerability exists';
                }
                //CH14.End
                eonApptVulnerabilities.add(eonApptVulnerability);
                eonApptVulnerability = new EON_Appointment_Vulnerability__c();
                addErrorMsg = null;
            }
        } else {
            addErrorMsg = 'Please populate Description value.';
        }
        return null;
    }
    /**
        removeRow(): This method will remove theI  record from the list and delete the record from isis.
    **/
    public PageReference removeRow() {
        System.debug('index to remove = ' + removeIndex);
        try {
            if (removeIndex != null && eonApptVulnerabilities.size() >= removeIndex) {
                eonApptVulnerabilities.remove(removeIndex); //remove the site vulnerability from list
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        }
        return null;
    }
    //CH02.End
    //CH09.start
    /**
        setVisibilityPayg();this method will sets the Planned Meter Mode value
    **/
    public pagereference setVisibilityPayg() {
        if (appt.Planned_Meter_Mode__c == 'PAYG' && (!selJobRecord.isEmpty() && selJobRecord.size() > 0 && string.isNotBlank(selJobRecord[0].Job_Type__c) && selJobRecord[0].Job_Type__c.containsIgnoreCase('smart') && (string.isNotBlank(selFuelRecord.MPAN__c) || string.isNotBlank(selFuelRecord.MPRN__c))) || (newAppointment.Job_Code__c != null && newAppointment.Job_Code__r.Name != null && newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART'))) {fieldSetVisibility = true;}
        else{ fieldSetVisibility = false;}
        if (appt.Planned_Meter_Mode__c != 'PAYG'){ fieldSetVisibility = false;}
        return null;
    }
    //CH09.end
    /**
        save() : This method will save the Appointment Booking request by calling the validate methods and Oracle Bucket ID
    **/
    public PageReference save() {
        try {
            //CH26.New.Start
            if (Appt.MPAN__c != null && Appt.MPAN__c != '' && Appt.Requested_SSC__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Requested SSC is mandatory'));
                return null;
            }
            //CH26.New.End
            Boolean errorOccured = false;
            //CH07.Start
            if (Appt.Key_Collection_Required__c == true && (Appt.Key_Person_Name__c == null || Appt.Key_Person_Name__c == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Key Person Name: You must enter a value'));
                errorOccured = true;
            }
            String keyContactRegex = '^(?:(?:\\(?(?:0(?:0|11)\\)?[\\s-]?\\(?|\\+)44\\)?[\\s-]?(?:\\(?0\\)?[\\s-]?)?)|(?:\\(?0))(?:(?:\\d{5}\\)?[\\s-]?\\d{4,5})|(?:\\d{4}\\)?[\\s-]?(?:\\d{5}|\\d{3}[\\s-]?\\d{3}))|(?:\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{3,4})|(?:\\d{2}\\)?[\\s-]?\\d{4}[\\s-]?\\d{4}))(?:[\\s-]?(?:x|ext\\.?|\\#)\\d{3,4})?$'; //CH34
            Pattern MyPattern = Pattern.compile(keyContactRegex); //CH34
            if (Appt.Key_Collection_Required__c == true && Appt.Key_Contact_Number__c == null) { //CH13
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Key Contact Number: You must enter a value'));
                errorOccured = true;
            }
            if (Appt.Key_Collection_Required__c == true && Appt.Key_Contact_Number__c != null && !MyPattern.matcher(Appt.Key_Contact_Number__c).matches()) { //CH34
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Key Contact Number: You must enter valid value')); //CH34
                errorOccured = true; //CH34
            }
            //CH07.End
            //CH23.start
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
            //CH26.New.Start
            if (newAppointment.MPAN__c != null && appt.Requested_SSC__c == null) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Requested SSC is mandatory')); errorOccured = true;}
            //CH26.New.End
            if (errorOccured) return null;
            //CH23.end
            newAppointment.Access_Pass_Phrase__c = Appt.Access_Pass_Phrase__c;
            //CH52.Start
            if(!EON_Utility.validateRequired(newAppointment.Market_Participant_ID__c)){
               if(newAppointment.Market_Participant_ID__c!='EON Digital Attacker')
                   newAppointment.Booking_System_Name__c = 'MUS';
                 else
                   newAppointment.Booking_System_Name__c = 'MUS-DA'; 
            }
            else
               newAppointment.Booking_System_Name__c = 'MUS';
            //CH52.end
           
            //newAppointment.Booking_System_Name__c = 'MUS';
            newAppointment.Subject_of_Eligibility_Override__c = Appt.Subject_of_Eligibility_Override__c; //CH51
            newAppointment.Caller_Name__c = Appt.Caller_Name__c;
            newAppointment.Requested_SSC__c = Appt.Requested_SSC__c;
            if (appReason != null)
                newAppointment.Notes__c = newAppointment.Notes__c;
            else
                newAppointment.Notes__c = Appt.Notes__c;
            if (String.isBlank(appReason)) newAppointment.Appointment_Date__c = Appt.Appointment_Date__c;
            else newAppointment.Appointment_Date__c = newAppointment.Appointment_Date__c;
            if (String.isBlank(appReason)) newAppointment.Time_Slot__c = Appt.Time_Slot__c;
            else newAppointment.Time_Slot__c = newAppointment.Time_Slot__c;
            newAppointment.Install_SED_flag__c = Appt.Install_SED_flag__c;
            newAppointment.DVD_Requested__c = Appt.DVD_Requested__c;
            newAppointment.Braille__c = Appt.Braille__c; //CH06
            newAppointment.Large_Print__c = Appt.Large_Print__c; //CH20
            newAppointment.Call_2_Days_before_appointment_Required__c = Appt.Call_2_Days_before_appointment_Required__c;
            newAppointment.Key_Collection_Required__c = Appt.Key_Collection_Required__c;
            newAppointment.Key_Person_Name__c = Appt.Key_Person_Name__c;
            newAppointment.Key_Contact_Number__c = Appt.Key_Contact_Number__c; //CH13
            newAppointment.Key_Building_Number__c = Appt.Key_Building_Number__c;
            newAppointment.Key_Sub_Building_Name__c = Appt.Key_Sub_Building_Name__c;
            newAppointment.Key_Building_Name__c = Appt.Key_Building_Name__c;
            newAppointment.Key_Town__c = Appt.Key_Town__c;
            newAppointment.Key_Dependant_Locality__c = Appt.Key_Dependant_Locality__c;
            newAppointment.Key_Double_Dependant_Locality__c = Appt.Key_Double_Dependant_Locality__c;
            newAppointment.Key_Thorofare__c = Appt.Key_Thorofare__c;
            newAppointment.Key_Dependant_Thorofare__c = Appt.Key_Dependant_Thorofare__c;
            newAppointment.Key_County__c = Appt.Key_County__c;
            newAppointment.Key_Post_Code__c = Appt.Key_Post_Code__c;
            newAppointment.Key_Country__c = Appt.Key_Country__c;
             system.debug('%%%%Debug at line 717');
            if (selectedEMetLoc != null && selectedEMetLoc != '')
                newAppointment.E_Meter_Location__c = selectedEMetLoc;
            if (selectedGMetLoc != null && selectedGMetLoc != '') {
                newAppointment.G_Meter_Location__c = selectedGMetLoc;
            }
            if (selectedParking != null && selectedParking != '')
                newAppointment.Parking_Type__c = selectedParking;
            //CH16
            if (appReason != null && appReason != '') {
                List < Eon_Appointment_Reason__c > lstreason = new List < Eon_Appointment_Reason__c > ([select id from Eon_Appointment_Reason__c where name = : appReason]); //CH16
                selectedAppRea = lstreason != null && lstreason.size() > 0 ? lstreason[0].id : ''; //CH16
            }
            if (selectedAppRea != null && selectedAppRea != '')
                newAppointment.Appointment_reason_code__c = selectedAppRea;
            newAppointment.Elec_HH_Data_Opted__c = Appt.Elec_HH_Data_Opted__c;
            newAppointment.Elec_Daily_Data_Opted__c = Appt.Elec_Daily_Data_Opted__c;
            newAppointment.Gas_HH_Data_Opted__c = Appt.Gas_HH_Data_Opted__c;
            newAppointment.Gas_Daily_Data_Opted__c = Appt.Gas_Daily_Data_Opted__c;
            //For electric
            newAppointment.E_Disconnection_warning_option_flag__c = Appt.E_Disconnection_warning_option_flag__c;
            newAppointment.E_Low_balance_alert_flag__c = Appt.E_Low_balance_alert_flag__c;
            newAppointment.E_LowBalanceAlertValue__c = Appt.E_LowBalanceAlertValue__c;
            newAppointment.E_Top_up_Notification_Opt_in_Flag__c = Appt.E_Top_up_Notification_Opt_in_Flag__c;
            newAppointment.E_Payment_Reminder_Opt_in_Flag__c = Appt.E_Payment_Reminder_Opt_in_Flag__c;
            newAppointment.E_Payment_Reminder_Frequency_Code__c = Appt.E_Payment_Reminder_Frequency_Code__c;
            newAppointment.E_Payment_Reminder_Day_Of_The_Week__c = Appt.E_Payment_Reminder_Day_Of_The_Week__c;
            newAppointment.E_Payment_Reminder_Date__c = Appt.E_Payment_Reminder_Date__c;
            //For gas
            newAppointment.G_Disconnection_warning_option_flag__c = Appt.G_Disconnection_warning_option_flag__c;
            newAppointment.G_Low_balance_alert_flag__c = Appt.G_Low_balance_alert_flag__c;
            newAppointment.G_LowBalanceAlertValue__c = Appt.G_LowBalanceAlertValue__c;
            newAppointment.G_Top_up_Notification_Opt_in_Flag__c = Appt.G_Top_up_Notification_Opt_in_Flag__c;
            newAppointment.G_Payment_Reminder_Opt_in_Flag__c = Appt.G_Payment_Reminder_Opt_in_Flag__c;
            newAppointment.G_Payment_Reminder_Frequency_Code__c = Appt.G_Payment_Reminder_Frequency_Code__c;
            newAppointment.G_Payment_Reminder_Day_Of_The_Week__c = Appt.G_Payment_Reminder_Day_Of_The_Week__c;
            newAppointment.G_Payment_Reminder_Date__c = Appt.G_Payment_Reminder_Date__c;
            //CH07.Start

            if(newAppointment.Job_Code__r.Name != 'OOAEINSTALLBIND')//CH44
                newAppointment.Planned_Meter_Mode__c = Appt.Planned_Meter_Mode__c; //CH09
                
            list < EON_Appointment_Comms__c > commLst = new list < EON_Appointment_Comms__c > ();
            if (selectedDeliveryMethod_c != null && selectedDeliveryMethod_c != '') {
                EON_Appointment_Comms__c comm = new EON_Appointment_Comms__c();
                comm.EON_Appointment_ID__c = newAppointment.id;
                comm.Comm_Type_Code__c = 'C';
                comm.Delivery_Method_Desc__c = selectedDeliveryMethod_c;
                commLst.add(comm);
            }
            if (selectedDeliveryMethod_I != null && selectedDeliveryMethod_I != '') {
                EON_Appointment_Comms__c comm1 = new EON_Appointment_Comms__c();
                comm1.EON_Appointment_ID__c = newAppointment.id;
                comm1.Comm_Type_Code__c = 'I';
                comm1.Delivery_Method_Desc__c = selectedDeliveryMethod_I;
                commLst.add(comm1);
            }
            if (selectedDeliveryMethod_R != null && selectedDeliveryMethod_R != '') {
                EON_Appointment_Comms__c comm2 = new EON_Appointment_Comms__c();
                comm2.EON_Appointment_ID__c = newAppointment.id;
                comm2.Comm_Type_Code__c = 'R';
                comm2.Delivery_Method_Desc__c = selectedDeliveryMethod_R;
                commLst.add(comm2);
            }
            //CH22.Start
            if (((newAppointment.Job_Code__c != null && newAppointment.Job_Code__r.Name != null && newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART')) || (String.isBlank(appReason) && selJobRecord != null && selJobRecord.size() > 0 && selJobRecord[0].name.containsIgnoreCase('SMART'))) && commLst.size() < 3) { //CH22.Start
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'SMART Job must have 3 communication methods.'));
                return null;
            }
            //CH22.End
            //CH07.End
            if (!newAppointment.E_Low_balance_alert_flag__c) { newAppointment.E_LowBalanceAlertValue__c = null; }
            if (!newAppointment.G_Low_balance_alert_flag__c) { newAppointment.G_LowBalanceAlertValue__c = null; }
            if (!newAppointment.E_Payment_Reminder_Opt_in_Flag__c) { newAppointment.E_Payment_Reminder_Frequency_Code__c = ''; newAppointment.E_Payment_Reminder_Day_Of_The_Week__c = null; newAppointment.E_Payment_Reminder_Date__c = null;}
            if (!newAppointment.G_Payment_Reminder_Opt_in_Flag__c) { newAppointment.G_Payment_Reminder_Frequency_Code__c = ''; newAppointment.G_Payment_Reminder_Day_Of_The_Week__c = null; newAppointment.G_Payment_Reminder_Date__c = null;}
            if (newAppointment.E_Payment_Reminder_Frequency_Code__c != null && newAppointment.E_Payment_Reminder_Frequency_Code__c != '' && newAppointment.E_Payment_Reminder_Frequency_Code__c == 'W') {newAppointment.E_Payment_Reminder_Date__c = null;}
            if (newAppointment.E_Payment_Reminder_Frequency_Code__c != null && newAppointment.E_Payment_Reminder_Frequency_Code__c != '' && newAppointment.E_Payment_Reminder_Frequency_Code__c == 'M') {newAppointment.E_Payment_Reminder_Day_Of_The_Week__c = null;}
            if (newAppointment.G_Payment_Reminder_Frequency_Code__c != null && newAppointment.G_Payment_Reminder_Frequency_Code__c != '' && newAppointment.G_Payment_Reminder_Frequency_Code__c == 'W') {newAppointment.G_Payment_Reminder_Date__c = null;}
            if (newAppointment.G_Payment_Reminder_Frequency_Code__c != null && newAppointment.G_Payment_Reminder_Frequency_Code__c != '' && newAppointment.G_Payment_Reminder_Frequency_Code__c == 'M') {newAppointment.G_Payment_Reminder_Day_Of_The_Week__c = null;}
            //CH05.Start 
            string errors = EON_OFSC_Helper.checkValidations(newAppointment);
            system.debug('### errors: ' + errors);
            if (string.isNotBlank(errors)) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errors)); return null; }
            //CH05.End
            //CH02.start
            //CH21.Start
            //get the correct workSkill
            System.debug('E Meter = ' + newAppointment.Planned_E_Meter_Type__c + ', G Meter = ' + newAppointment.Planned_G_Meter_Type__c);
            System.debug('PHASE = ' + newAppointment.Number_of_Phases__c + ', Pressure = ' + newAppointment.Metering_Pressure__c);
            //CH27
            if (newAppointment.MPRN__c != null && newAppointment.MPRN__c != '' && (newAppointment.Metering_Pressure__c == null || newAppointment.Metering_Pressure__c == '')) { newAppointment.Metering_Pressure__c = 'Low';}//CH31
            if (newAppointment.MPAN__c != null && newAppointment.MPAN__c != '' && (newAppointment.Number_of_Phases__c == null || newAppointment.Number_of_Phases__c == '')){ newAppointment.Number_of_Phases__c = '1Ph';}//CH31
            //CH27
             //CH41.Start
            if (newAppointment.Planned_E_Meter_Type__c=='--None--') {
                canProceed = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select a value for Planned E meter Type')); //CH04
                return null;
            }
            //CH41.End
            
            String correctWorkSkill = EON_OFSC_Helper.getWorkSkill(newAppointment);
            if (correctWorkSkill != '' && correctWorkSkill.containsIgnoreCase('Invalid')) {
                canProceed = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Meter information could not be retrieved, please contact MUS back office.')); //CH04
                return null;
            }
            //CH21.End
            if(allApptMeter.size()>1){ //CH42.New
                newAppointment.Multiple_Meters_at_Site__c = true;
            }
            if (newAppointment.Key_Collection_Required__c && (newAppointment.Key_Contact_Number__c == null || newAppointment.Key_Contact_Number__c == '' || newAppointment.Key_Person_Name__c == null || newAppointment.Key_Person_Name__c == '')) {canProceed = false;}
            else {
                upsert newAppointment;
                List < JUMBO_Data_Tracker__c > toUpdateJumboDataTrackers = new List < JUMBO_Data_Tracker__c > ();
                for(JUMBO_Data_Tracker__c  jT : lstJumboTracker){
                    jT.EON_Appointment__c = newAppointment.id;
                    toUpdateJumboDataTrackers.add(jT);
                }
                if (toUpdateJumboDataTrackers != null && toUpdateJumboDataTrackers.size() > 0) {
                    update toUpdateJumboDataTrackers;
                }
                for (EON_Appointment_Vulnerability__c apptVul: eonApptVulnerabilities) {
                    if (apptVul.EON_Appointment_ID__c == null) apptVul.EON_Appointment_ID__c = newAppointment.id;
                }
                
                Set<ID> lstContactTypeID = new set<ID>();//CH45
                for (EON_Appointment_Contact__c appContact: lstApptContact) {
                    if (appContact.EON_Appointment_ID__c == null) {
                        appContact.EON_Appointment_ID__c = newAppointment.id;
                    }
                    lstContactTypeID.add(appContact.Contact_Type__c);//CH45
                }
                for (EON_Appointment_Comms__c appComm: commLst) {
                    if (appComm.EON_Appointment_ID__c == null) { appComm.EON_Appointment_ID__c = newAppointment.id;}
                }
                //System.debug('the list size###'+eonApptVulnerabilities.size());
                if (eonApptVulnerabilities.size() > 0) {
                    upsert eonApptVulnerabilities;
                }
                
                //CH45.Start
                boolean isContactTypeError = true;
                for(EON_Contact_Type__c contactType : [select name from EON_Contact_Type__c where id in : lstContactTypeID] ){
                    if(contactType.name == 'Appointment Contact'){
                        isContactTypeError = false;
                        break;
                    }
                        
                }
                //CH45.End
                
                
                //CH02.end
                if (lstApptContact.size() < 1
                            || isContactTypeError //CH45
                                ) { 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'At least one EON Appointment Contact record with Appointment Contact type is mandatory')); return null;}//CH22
                upsert lstApptContact;
                if (commLst != null && commLst.size() > 0)
                    insert commLst;
                canProceed = true;
                 system.debug('%%%%Debug at line 857');
                 //CH42.Start
                if(allApptMeter.size()>1){
                    for(EON_Appointment_Meter__c meter: allApptMeter)
                        meter.EON_Appointment__c = newAppointment.ID;
                    insert allApptMeter;
                     system.debug('%%%%Debug at line 863');
                }
                //CH42.End
            }
        } catch (Exception ex) {
            System.debug('##exception occurs here' + ex.getMessage() + 'at line no-->' + ex.getStackTraceString());
            canProceed = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        }
        return null;
    }
    /**
        validateAppointmentBookingRequest(): This method will validate the Appointment Booking request by calling the validate methods and Oracle Bucket ID
    **/
    public PageReference validateAppointmentBookingRequest() {
		String switchData = EON_MDS_Utility.getMDS_Jumbo_Status();	//CH54
        try {
        
            if (String.isBlank(appReason)) {
                eEff_From_Date = null;
                eEff_To_Date = null;
                if (selFuelRecord != null && (selFuelRecord.Fuel_type__c == null || (!selFuelRecord.Fuel_type__c.equalsIgnoreCase('D') && !selFuelRecord.Fuel_type__c.equalsIgnoreCase('E')))) {
                    isRejected = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Rejected we are not MAM.'));
                } else if (selJobRecord == null || selJobRecord.isEmpty() || selJobRecord[0].id == null) {
                    isRejected = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Rejected EON Job Code is not available: \'' + ((selFuelRecord.Fuel_type__c.equalsIgnoreCase('E')) ? 'OOASMARTELECEXCH' : (selFuelRecord.Fuel_type__c.equalsIgnoreCase('D')) ? 'OOASMARTDFEXCH' : '') + '\' for Fuel Type : \'' + selFuelRecord.Fuel_type__c + '\''));
                } else {
                    system.debug(selJobRecord[0].id);
                    system.debug(selFuelRecord.MPAN__c);
                     system.debug('%%%%Debug at line 891');
                    oracleBucketID = EON_OFSC_Helper.checkValidityForOFSC(selJobRecord[0].name, jobAttParam, selFuelRecord.MPAN__c, selFuelRecord.MPRN__c, selFuelRecord.Premise__r.Postcode__c);
                    eEff_From_Date = EON_OFSC_Helper.eonAppointment.Effective_From_Date__c;
                    eEff_To_Date = EON_OFSC_Helper.eonAppointment.Effective_To_Date__c;
                    system.debug(oracleBucketID);
                     system.debug('%%%%Debug at line 896');
                    if (EON_OFSC_Helper.JumboDataTrackers != null && !EON_OFSC_Helper.JumboDataTrackers.isEmpty() && EON_OFSC_Helper.JumboDataTrackers.size() > 0){lstJumboTracker.addALL(EON_OFSC_Helper.JumboDataTrackers);}
                    newAppointment = EON_OFSC_Helper.eonAppointment;
                    //CH20 avoid the error if we get the Error like we are not MAM
                    if (String.isNotBlank(oracleBucketID) && oracleBucketID.containsIgnoreCase('MPRN does not exist')) { oracleBucketID = EON_OFSC_Helper.getOracleBucketId(selJobRecord[0].name, selJobRecord[0].Job_Type__c, selFuelRecord.Premise__r.Postcode__c, selFuelRecord.MPAN__c);}
                    if (String.isNotBlank(oracleBucketID) && oracleBucketID.containsIgnoreCase('Reject') && !oracleBucketID.containsIgnoreCase('MPRN does not exist')) {
                        isRejected = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, oracleBucketID));
                         system.debug('%%%%Debug at line 904');
                    }
                }
                if (!isRejected) {
					//CH54.Start
					if(switchData == system.label.Jumbo_Shortform) {
						if (selFuelRecord.MPAN__c != null) {
							EON_Jumbo_ReqElecMeterPointData.AccessElecMeterPointData(selFuelRecord.MPAN__c, newAppointment, '', '');
							if (EON_Jumbo_ReqElecMeterPointData.eonVulnerabilityCode != null) { eVulCodeMap = EON_Jumbo_ReqElecMeterPointData.eonVulnerabilityCode;} //CH19
							newAppointment = EON_Jumbo_ReqElecMeterPointData.apptIns;
							if (EON_Jumbo_ReqElecMeterPointData.cTrack != null) {
								lstJumboTracker.add(EON_Jumbo_ReqElecMeterPointData.cTrack);
							}
							if (EON_Jumbo_ReqElecMeterPointData.isError) {
								isRejected = true;
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, EON_Jumbo_ReqElecMeterPointData.Errors));
							}
							//CH42.Start
							if(!EON_Utility.validateRequired(EON_Jumbo_ReqElecMeterPointData.allApptMeter)){
								if(EON_Jumbo_ReqElecMeterPointData.allApptMeter.size() > 1){
									allApptMeter.addAll(EON_Jumbo_ReqElecMeterPointData.allApptMeter);
								}
							}
							//CH42.End
						}
						if (!isRejected && selFuelRecord.MPRN__c != null) {
							//Check that we are 
							EON_Jumbo_ReqGasMAM.MAMValidationResponse mamCheck = EON_Jumbo_ReqGasMAM.ValidateMPRNMAM(selFuelRecord.MPRN__c);
							if (EON_Jumbo_ReqGasMAM.cTrack != null) {
								lstJumboTracker.add(EON_Jumbo_ReqGasMAM.cTrack);
							}
							if (Test.isRunningTest()) {
								mamCheck.isError = false;
								mamCheck.effToDate = system.today();
								mamCheck.effFromDate = system.today(); // + 5;
							}
							//CH20 Added the condition for checking the effective From date <= today                            
							if (mamCheck != null && !mamCheck.isError && mamCheck.effFromDate != null && mamCheck.effFromDate <= Date.today()) {
								EON_Jumbo_ReqGasMeterPointData.AccessGasMeterPointData(selFuelRecord.MPRN__c, newAppointment, '', '');
								newAppointment = EON_Jumbo_ReqGasMeterPointData.apptIns;
								newAppointment.G_Effective_From_Date__c = mamCheck.effFromDate;
								newAppointment.G_Effective_To_Date__c = mamCheck.effToDate;
								if (!EON_Utility.validateRequired(mamCheck.abbrvtdName)){newAppointment.Gas_Market_Participant_ID__c = mamCheck.abbrvtdName;}//CH33
								if (EON_Jumbo_ReqGasMeterPointData.cTrack != null)	
								lstJumboTracker.add(EON_Jumbo_ReqGasMeterPointData.cTrack);	
								
								system.debug('%%%%Debug at line 939');
							} else { newAppointment = EON_OFSC_Helper.mapAppointmentFromFuelSite(selFuelRecord, newAppointment);system.debug('%%%%Debug at line 940');} //CH20
							if (Test.isRunningTest()) {
								mamCheck.isError = true;
							}
						}
						//CH12.Start
						if (String.isBlank(oracleBucketID)) //CH20
						oracleBucketID = EON_OFSC_Helper.getOracleBucketId(selJobRecord[0].name, selJobRecord[0].Job_Type__c, (((newAppointment.MPAN__c != null && newAppointment.MPRN__c != null && newAppointment.MPAN__c != '' && newAppointment.MPRN__c != '') || (newAppointment.MPAN__c != null && newAppointment.MPAN__c != '')) ? newAppointment.Metering_Point_Postcode__c : newAppointment.Post_Code__c), newAppointment.MPAN__c);
						if (oracleBucketID != '' && oracleBucketID.containsIgnoreCase('Reject')) {
							isRejected = true;
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ((oracleBucketID == '') ? 'Rejected Oracle Bucket ID not found.' : oracleBucketID)));
						}
						oracleBucketID = ((String.isBlank(oracleBucketID)) ? 'EXE_ONLY' : oracleBucketID);
						//CH12.End
						//CH01.Start --> mapped the Fuel record to Appointemnt.
						newAppointment.Fuel_ID__c = selFuelRecord.id;
						newAppointment.Job_Code__c = selJobRecord[0].id;
						//CH01.End
						//get the correct workSkill
						//CH15.Start
						//CH17.start
						System.debug('!@#Before= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.Planned_G_Meter_Type__c);
						if (selJobRecord[0].name.containsIgnoreCase('SMART') || (selJobRecord[0].Job_Type__c != null && selJobRecord[0].Job_Type__c.equalsIgnoreCase('SMART'))) {
							newAppointment.Planned_E_Meter_Type__c = ((selFuelRecord.Fuel_Type__c != null) ? ((selFuelRecord.Fuel_Type__c == 'E' || selFuelRecord.Fuel_Type__c == 'D') ? 'MS1' : '') : (((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPAN__c)) ? 'MS1' : ''));
							newAppointment.Planned_G_Meter_Type__c = ((selFuelRecord.Fuel_Type__c != null) ? ((selFuelRecord.Fuel_Type__c == 'G' || selFuelRecord.Fuel_Type__c == 'D') ? 'MS1' : '') : (((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPRN__c)) ? 'MS1' : ''));
						} else {
							newAppointment.Planned_E_Meter_Type__c = ((((selFuelRecord.Fuel_Type__c != null && (selFuelRecord.Fuel_Type__c == 'E' || selFuelRecord.Fuel_Type__c == 'D')) || ((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPAN__c))) && isBlankVal(newAppointment.Planned_E_Meter_Type__c) && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(newAppointment.Planned_E_Meter_Type__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getValues(newAppointment.Planned_E_Meter_Type__c.toUpperCase()).Planned_Meter_Type__c : newAppointment.Planned_E_Meter_Type__c);
							newAppointment.Planned_G_Meter_Type__c = ((((selFuelRecord.Fuel_Type__c != null && (selFuelRecord.Fuel_Type__c == 'G' || selFuelRecord.Fuel_Type__c == 'D')) || ((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPRN__c))) && isBlankVal(newAppointment.Planned_G_Meter_Type__c) && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(newAppointment.Planned_G_Meter_Type__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getValues(newAppointment.Planned_G_Meter_Type__c.toUpperCase()).Planned_Meter_Type__c : newAppointment.Planned_G_Meter_Type__c);
						}
						System.debug('!@#After= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.Planned_G_Meter_Type__c);
						//CH17.End
						//CH15.End
						if (selFuelRecord.Fuel_type__c == 'E' && newAppointment.Job_Code__c != null && selJobRecord[0].name.containsIgnoreCase('SMART')){appt.Elec_Daily_Data_Opted__c = true;}//CH24
						if (selFuelRecord.Fuel_type__c == 'D' && newAppointment.Job_Code__c != null && selJobRecord[0].name.containsIgnoreCase('SMART')) {appt.Elec_Daily_Data_Opted__c = true; appt.Gas_Daily_Data_Opted__c = true;}//CH24
						if (selFuelRecord.Fuel_type__c == 'G' && newAppointment.Job_Code__c != null && selJobRecord[0].name.containsIgnoreCase('SMART')) {appt.Gas_Daily_Data_Opted__c = true;}//CH24
						if (newAppointment.MPRN__c != null && newAppointment.MPRN__c != '' && (newAppointment.Metering_Pressure__c == null || newAppointment.Metering_Pressure__c == '')){ newAppointment.Metering_Pressure__c = 'Low'; } //CH31
						if (newAppointment.MPAN__c != null && newAppointment.MPAN__c != '' && (newAppointment.Number_of_Phases__c == null || newAppointment.Number_of_Phases__c == '')){ newAppointment.Number_of_Phases__c = '1Ph'; }//CH31
						String correctWorkSkill = EON_OFSC_Helper.getWorkSkill(newAppointment);
						if (correctWorkSkill != '' && correctWorkSkill.containsIgnoreCase('Invalid')) {
							isRejected = true;
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Meter information could not be retrieved, please contact MUS back office.')); //CH04
							//CH04 commented out ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Work Skill is not found or invalid work skill for the combination of metertypes and number of phases/ Metering pressure '));
						}
						//get the correct workSkill
						validateSSC(newAppointment.job_Code__c, newAppointment.Current_SSC__c); //CH49
						
						if (!isRejected) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your Appointment Booking request has been validated.'));}
					}
					else if(switchData == system.label.MDS_Shortform) {
						if (selFuelRecord.MPAN__c != null) {
							EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(selFuelRecord.MPAN__c, newAppointment, '', '');
							if (EON_MDS_ReqElecMeterPointData.eonVulnerabilityCode != null) { eVulCodeMap = EON_MDS_ReqElecMeterPointData.eonVulnerabilityCode;} //CH19
							newAppointment = EON_MDS_ReqElecMeterPointData.apptIns;
							if (EON_MDS_ReqElecMeterPointData.cTrack != null) {
								lstMDSTracker.add(EON_MDS_ReqElecMeterPointData.cTrack);
							}
							if (EON_MDS_ReqElecMeterPointData.isError) {
								isRejected = true;
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, EON_MDS_ReqElecMeterPointData.Errors));
							}
							//CH42.Start
							if(!EON_Utility.validateRequired(EON_MDS_ReqElecMeterPointData.allApptMeter)){
								if(EON_MDS_ReqElecMeterPointData.allApptMeter.size() > 1){
									allApptMeter.addAll(EON_MDS_ReqElecMeterPointData.allApptMeter);
								}
							}
							//CH42.End
						}
						if (!isRejected && selFuelRecord.MPRN__c != null) {
							//Check that we are 
							EON_MDS_ReqGasMAM.MAMValidationResponse mamCheck = EON_MDS_ReqGasMAM.ValidateMPRNMAM(selFuelRecord.MPRN__c);
							if (EON_MDS_ReqGasMAM.cTrack != null) {
								lstMDSTracker.add(EON_MDS_ReqGasMAM.cTrack);
							}
							if (Test.isRunningTest()) {
								mamCheck.isError = false;
								mamCheck.effToDate = system.today();
								mamCheck.effFromDate = system.today(); // + 5;
							}
							//CH20 Added the condition for checking the effective From date <= today                            
							if (mamCheck != null && !mamCheck.isError && mamCheck.effFromDate != null && mamCheck.effFromDate <= Date.today()) {
								EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(selFuelRecord.MPRN__c, newAppointment, '', '');
								newAppointment = EON_MDS_ReqGasMeterPointData.apptIns;
								newAppointment.G_Effective_From_Date__c = mamCheck.effFromDate;
								newAppointment.G_Effective_To_Date__c = mamCheck.effToDate;
								if (!EON_Utility.validateRequired(mamCheck.abbrvtdName)){newAppointment.Gas_Market_Participant_ID__c = mamCheck.abbrvtdName;}//CH33
								if (EON_MDS_ReqGasMeterPointData.cTrack != null)	
								lstMDSTracker.add(EON_MDS_ReqGasMeterPointData.cTrack);	
								
								system.debug('%%%%Debug at line 939');
							} else { newAppointment = EON_OFSC_Helper.mapAppointmentFromFuelSite(selFuelRecord, newAppointment);system.debug('%%%%Debug at line 940');} //CH20
							if (Test.isRunningTest()) {
								mamCheck.isError = true;
							}
						}
						//CH12.Start
						if (String.isBlank(oracleBucketID)) //CH20
						oracleBucketID = EON_OFSC_Helper.getOracleBucketId(selJobRecord[0].name, selJobRecord[0].Job_Type__c, (((newAppointment.MPAN__c != null && newAppointment.MPRN__c != null && newAppointment.MPAN__c != '' && newAppointment.MPRN__c != '') || (newAppointment.MPAN__c != null && newAppointment.MPAN__c != '')) ? newAppointment.Metering_Point_Postcode__c : newAppointment.Post_Code__c), newAppointment.MPAN__c);
						if (oracleBucketID != '' && oracleBucketID.containsIgnoreCase('Reject')) {
							isRejected = true;
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ((oracleBucketID == '') ? 'Rejected Oracle Bucket ID not found.' : oracleBucketID)));
						}
						oracleBucketID = ((String.isBlank(oracleBucketID)) ? 'EXE_ONLY' : oracleBucketID);
						//CH12.End
						//CH01.Start --> mapped the Fuel record to Appointemnt.
						newAppointment.Fuel_ID__c = selFuelRecord.id;
						newAppointment.Job_Code__c = selJobRecord[0].id;
						//CH01.End
						//get the correct workSkill
						//CH15.Start
						//CH17.start
						System.debug('!@#Before= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.Planned_G_Meter_Type__c);
						if (selJobRecord[0].name.containsIgnoreCase('SMART') || (selJobRecord[0].Job_Type__c != null && selJobRecord[0].Job_Type__c.equalsIgnoreCase('SMART'))) {
							newAppointment.Planned_E_Meter_Type__c = ((selFuelRecord.Fuel_Type__c != null) ? ((selFuelRecord.Fuel_Type__c == 'E' || selFuelRecord.Fuel_Type__c == 'D') ? 'MS1' : '') : (((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPAN__c)) ? 'MS1' : ''));
							newAppointment.Planned_G_Meter_Type__c = ((selFuelRecord.Fuel_Type__c != null) ? ((selFuelRecord.Fuel_Type__c == 'G' || selFuelRecord.Fuel_Type__c == 'D') ? 'MS1' : '') : (((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPRN__c)) ? 'MS1' : ''));
						} else {
							newAppointment.Planned_E_Meter_Type__c = ((((selFuelRecord.Fuel_Type__c != null && (selFuelRecord.Fuel_Type__c == 'E' || selFuelRecord.Fuel_Type__c == 'D')) || ((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPAN__c))) && isBlankVal(newAppointment.Planned_E_Meter_Type__c) && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(newAppointment.Planned_E_Meter_Type__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getValues(newAppointment.Planned_E_Meter_Type__c.toUpperCase()).Planned_Meter_Type__c : newAppointment.Planned_E_Meter_Type__c);
							newAppointment.Planned_G_Meter_Type__c = ((((selFuelRecord.Fuel_Type__c != null && (selFuelRecord.Fuel_Type__c == 'G' || selFuelRecord.Fuel_Type__c == 'D')) || ((isBlankVal(newAppointment.MPAN__c) && isBlankVal(newAppointment.MPRN__c)) || isBlankVal(newAppointment.MPRN__c))) && isBlankVal(newAppointment.Planned_G_Meter_Type__c) && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(newAppointment.Planned_G_Meter_Type__c.toUpperCase())) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getValues(newAppointment.Planned_G_Meter_Type__c.toUpperCase()).Planned_Meter_Type__c : newAppointment.Planned_G_Meter_Type__c);
						}
						System.debug('!@#After= ' + newAppointment.Planned_E_Meter_Type__c + ', ' + newAppointment.Planned_G_Meter_Type__c);
						//CH17.End
						//CH15.End
						if (selFuelRecord.Fuel_type__c == 'E' && newAppointment.Job_Code__c != null && selJobRecord[0].name.containsIgnoreCase('SMART')){appt.Elec_Daily_Data_Opted__c = true;}//CH24
						if (selFuelRecord.Fuel_type__c == 'D' && newAppointment.Job_Code__c != null && selJobRecord[0].name.containsIgnoreCase('SMART')) {appt.Elec_Daily_Data_Opted__c = true; appt.Gas_Daily_Data_Opted__c = true;}//CH24
						if (selFuelRecord.Fuel_type__c == 'G' && newAppointment.Job_Code__c != null && selJobRecord[0].name.containsIgnoreCase('SMART')) {appt.Gas_Daily_Data_Opted__c = true;}//CH24
						if (newAppointment.MPRN__c != null && newAppointment.MPRN__c != '' && (newAppointment.Metering_Pressure__c == null || newAppointment.Metering_Pressure__c == '')){ newAppointment.Metering_Pressure__c = 'Low'; } //CH31
						if (newAppointment.MPAN__c != null && newAppointment.MPAN__c != '' && (newAppointment.Number_of_Phases__c == null || newAppointment.Number_of_Phases__c == '')){ newAppointment.Number_of_Phases__c = '1Ph'; }//CH31
						String correctWorkSkill = EON_OFSC_Helper.getWorkSkill(newAppointment);
						if (correctWorkSkill != '' && correctWorkSkill.containsIgnoreCase('Invalid')) {
							isRejected = true;
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Meter information could not be retrieved, please contact MUS back office.')); //CH04
							//CH04 commented out ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Work Skill is not found or invalid work skill for the combination of metertypes and number of phases/ Metering pressure '));
						}
						//get the correct workSkill
						validateSSC(newAppointment.job_Code__c, newAppointment.Current_SSC__c); //CH49
						
						if (!isRejected) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your Appointment Booking request has been validated.'));}
					}
					//CH54.End
                }
                //CH01
                System.debug('@#$lstJumboTracker = ' + lstJumboTracker);
                if (lstJumboTracker != null && !lstJumboTracker.isEmpty())
                    insert lstJumboTracker;
                //CH01
				//CH54.Start
                System.debug('@#$lstMDSTracker = ' + lstMDSTracker);
                if (lstMDSTracker != null && !lstMDSTracker.isEmpty())
                    insert lstMDSTracker;
                //CH54.End
                //CH11.Start
            } else if (String.isNotBlank(appReason)) {
                if (appointmentID != null && appointmentID != '') {
                    newAppointment = [SELECT Abort_Datetime__c, Abort_Reason__c, Access_Instructions__c, Access_Pass_Phrase__c, Additional_Information__c, Alternate_Priority_Service_Contact_Name__c, Alternate_Priority_Service_PhoneNumber1__c, Alternate_Priority_Service_PhoneNumber2__c, Appointment_Date__c, Appointment_reason_code__c, Assisted_Work_Reason_Code__c, Assisted_Work_Reason__c, Booking_System_Name__c, Braille__c, Building_Name__c, Building_Number__c, Caller_Name__c, Call_2_Days_before_appointment_Required__c, Cancellation_DateTime__c, Cancel_Electricity_Job__c, Cancel_Gas_Job__c, Cancel_Reason__c, Capacity_Override_reason__c, Certification_Date__c, Certification_Expiry_Date__c, Closed_in_JUMBO__c, Close_Electricity_Job__c, Close_Gas_Job__c, Complete_DateTime__c, Confirmed_Appointment_DateTime__c, Contact_Email__c, Contact_Name__c, Contact_Number__c, Contact_Telephone_Number__c, Contract_Reference__c, Contract__c, Country__c, County__c, CreatedById, CreatedDate, Create_Electricity_Job__c, Create_Gas_Job__c, Current_SSC__c, Customer_Name__c, Customer_Preferred_Contact_Method__c, Customer_Title__c, Deferral_Notes__c, Dependant_Locality__c, Dependent_Thorofare__c, Double_dependant_Locality__c, Duration__c, DVD_Requested__c, Effective_From_Date__c, Effective_To_Date__c, Elec_Daily_Data_Opted__c, Elec_HH_Data_Opted__c, End_Appointment_Date__c, End_Time__c, Energisation_Status__c, En_Route_DateTime__c, EON_Appointment_ID__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c, E_Check_Meter_Installed__c, E_Check_Meter_Location__c, E_Check_Meter_Make__c, E_Check_Meter_Model__c, E_Check_Meter_Serial_Number__c, E_Disconnection_warning_option_flag__c, E_Location_Code__c, E_LowBalanceAlertValue__c, E_Low_balance_alert_flag__c, E_Meter_COP_Dispensation__c, E_Meter_COP__c, E_Meter_CT_Ratio__c, E_Meter_Location__c, E_Meter_Make_Model__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, E_Meter_Register_1_Name__c, E_Meter_Register_1_Type__c, E_Meter_Register_2_ID__c, E_Meter_Register_2_Name__c, E_Meter_Register_2_Type__c, E_Meter_Register_3_ID__c, E_Meter_Register_3_Name__c, E_Meter_Register_4_ID__c, E_Meter_Register_4_Name__c, E_Meter_Register_5_ID__c, E_Meter_Register_5_Name__c, E_Meter_Register_6_ID__c, E_Meter_Register_6_Name__c, E_Meter_Reg_1_No_of_dials_digits__c, E_Meter_Reg_2_No_of_dials_digits__c, E_Meter_Reg_3_No_of_dials_digits__c, E_Meter_Reg_4_No_of_dials_digits__c, E_Meter_Reg_5_No_of_dials_digits__c, E_Meter_Reg_6_No_of_dials_digits__c, E_Meter_Serial_Number__c, E_Meter_Type__c, E_Meter_VT_Ratio__c, E_Payment_Reminder_Date__c, E_Payment_Reminder_Day_Of_The_Week__c, E_Payment_Reminder_Frequency_Code__c, E_Payment_Reminder_Opt_in_Flag__c, E_Top_up_Notification_Opt_in_Flag__c, Fuel_ID__c, Fuel_ID__r.Premise__r.Postcode__c, Gas_bind_performed_flag__c, Gas_Daily_Data_Opted__c, Gas_HH_Data_Opted__c, Gas_Regulator_Serial_Number__c, G_Check_Meter_Installed__c, G_Check_Meter_Location__c, G_Check_Meter_Make__c, G_Check_Meter_Model__c, G_Check_Meter_Serial_Number__c, G_Disconnection_warning_option_flag__c, G_Location_Code__c, G_LowBalanceAlertValue__c, G_Low_balance_alert_flag__c, G_Meter_Converter_Asset_Class__c, G_Meter_Converter_Location__c, G_Meter_Converter_Manufacturer__c, G_Meter_Converter_Model__c, G_Meter_Converter_Serial_Number__c, G_Meter_Location__c, G_Meter_Make_Model__c, G_Meter_Make__c, G_Meter_Measuring_Capacity__c, G_Meter_Mechanism__c, G_Meter_Model__c, G_Meter_No_of_dials_digits__c, G_Meter_Register_Type__c, G_Meter_Serial_Number__c, G_Meter_Type__c, G_Payment_Reminder_Date__c, G_Payment_Reminder_Day_Of_The_Week__c, G_Payment_Reminder_Frequency_Code__c, G_Payment_Reminder_Opt_in_Flag__c, G_Top_up_Notification_Opt_in_Flag__c, Id, Install_SED_flag__c, IsDeleted, Job_Code__c, Job_Code__r.Name, Job_Code__r.Job_Type__c, Job_Code__r.MPAN_Reqd__c /*CH19*/ , Job_Type__c, JUMBO_Cancel_Reason__c, JUMBO_Contact_Mechanism__c, JUMBO_Contact_Value__c, JUMBO_ID__c, Key_Building_Name__c, Key_Building_Number__c, Key_Collection_Required__c, Key_Contact_Number__c, //CH13
                        Key_Country__c, Key_County__c, Key_Dependant_Locality__c, Key_Dependant_Thorofare__c, Key_Double_Dependant_Locality__c, Key_Person_Name__c, Key_Post_Code__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Town__c, Large_Print__c, Last_Inspection_Date__c, Market_Participant_Abbreviated_Name__c, Market_Participant_ID__c, Metering_Point_Address_Line_1__c, Metering_Point_Address_Line_2__c, Metering_Point_Address_Line_3__c, Metering_Point_Address_Line_4__c, Metering_Point_Address_Line_5__c, Metering_Point_Address_Line_6__c, Metering_Point_Address_Line_7__c, Metering_Point_Address_Line_8__c, Metering_Point_Address_Line_9__c, Metering_Point_Postcode__c, Metering_Pressure__c, Meter_Current_Rating__c, Meter_Memory_Location__c, Meter_Point_Status_Code__c, MOSE_Hire__c, MPAN__c, MPRN__c, Name, Notes__c, Number_of_Dials_or_Digits__c, Number_of_Phases__c, Onsite_DateTime__c, Oracle_Address__c, Oracle_Postcode_Sector__c, Oracle_Postcode__c, Oracle_Town__c, Original_JUMBO_ID__c, OwnerId, Parking_Type__c, Payment_Method_code__c, Person_Name__c, Person_Type_Code__c, Planned_E_Meter_Type__c, Planned_G_Meter_Type__c, Planned_Meter_Mode__c, Planned_Meter_Registers__c, Planned_Number_of_Registers__c, Post_Code__c, Post_Town__c, Primary_Priority_Service_Contact_Name__c, Primary_Priority_Service_Phone_Number_1__c, Primary_Priority_Service_Phone_Number_2__c, Priority_Service_Contact_Address_Line_1__c, Priority_Service_Contact_Address_Line_2__c, Priority_Service_Contact_Address_Line_3__c, Priority_Service_Contact_Address_Line_4__c, Priority_Service_Contact_Address_Line_5__c, Priority_Service_Contact_Address_Line_6__c, Priority_Service_Contact_Address_Line_7__c, Priority_Service_Contact_Address_Line_8__c, Priority_Service_Contact_Address_Line_9__c, Priority_Service_Contact_Postcode__c, Requested_SSC__c, Request_Date__c, Request_Time__c, Rescheduled_Appointment__c, Sent_to_Oracle_Update__c, Sent_to_Oracle__c, Special_Access__c, Specific_Time_flag__c, Start_Time__c, Status__c, SubArea__c, Sub_Building_Name__c, Supplier_Name__c, Supply_Capacity__c, Supply_Voltage__c, Suspended_DateTime__c, Technician__c, Thorofare__c, Time_Slot__c, Timing_Device_Serial_Number__c, Type__c, Update_Electricity_Job__c, Update_Gas_Job__c, Vulnerability_Description__c FROM EON_Appointment__c WHERE ID = : appointmentID
                    ];
                    oracleBucketID = EON_OFSC_Helper.getOracleBucketId(newAppointment.Job_code__r.Name, newAppointment.Job_code__r.Job_Type__c, ((newAppointment.Fuel_ID__r.Premise__r.Postcode__c != null) ? newAppointment.Fuel_ID__r.Premise__r.Postcode__c : (((newAppointment.MPAN__c != null && newAppointment.MPRN__c != null) || newAppointment.MPAN__c != null) ? newAppointment.Metering_Point_Postcode__c : newAppointment.Post_Code__c)), newAppointment.MPAN__c);
                    oracleBucketID = ((string.isBlank(oracleBucketID)) ? 'EXE_ONLY' : oracleBucketID); //CH20
                    if (newAppointment.MPAN__c != null && newAppointment.MPAN__c != '' && newAppointment.Job_Code__c != null && newAppointment.Job_Code__r.Name != null && newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART')){appt.Elec_Daily_Data_Opted__c = true;}//CH24
                    if (newAppointment.MPRN__c != null && newAppointment.MPRN__c != '' && newAppointment.Job_Code__c != null && newAppointment.Job_Code__r.Name != null && newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART')){appt.Gas_Daily_Data_Opted__c = true;}//CH24
                    if (newAppointment.MPAN__c != null && newAppointment.MPAN__c != '' && newAppointment.MPRN__c != null && newAppointment.MPRN__c != '' && newAppointment.Job_Code__c != null && newAppointment.Job_Code__r.Name != null && newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART')) {appt.Elec_Daily_Data_Opted__c = true; appt.Gas_Daily_Data_Opted__c = true;}//CH24
                    //CH54.Start
					if(switchData == system.label.Jumbo_Shortform) {
						//CH19
						if (newAppointment.MPAN__c != null) { //CH20
							EON_Jumbo_ReqElecMeterPointData.AccessElecMeterPointData(newAppointment.MPAN__c, new EON_Appointment__c(), '', '');
							if (EON_Jumbo_ReqElecMeterPointData.eonVulnerabilityCode != null) {eVulCodeMap = EON_Jumbo_ReqElecMeterPointData.eonVulnerabilityCode;}
						}
						//CH19
					}
					else if(switchData == system.label.MDS_Shortform) {
						if (newAppointment.MPAN__c != null) {
							EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(newAppointment.MPAN__c, new EON_Appointment__c(), '', '');
							if (EON_MDS_ReqElecMeterPointData.eonVulnerabilityCode != null) {eVulCodeMap = EON_MDS_ReqElecMeterPointData.eonVulnerabilityCode;}
						}
					}
					//CH54.End
                } else {
                    isRejected = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invalid Appointment booking request / Appointment is required for New Connection.'));
                }
                
                validateSSC(newAppointment.job_Code__c, newAppointment.Current_SSC__c); //CH49
                if (!isRejected) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your Appointment Booking request has been validated.'));}
            }
            //CH11.End
            //CH19
            if (eVulCodeMap != null && eVulCodeMap.size() > 0) {
                EON_Vulnerability_Code__c eonVunCode;
                // Remove elements from Map if they are already present in existing list
                if (vulDetailCodeSet != null && vulDetailCodeSet.size() > 0) {
                    for (String s: vulDetailCodeSet) {
                        if (eVulCodeMap.size() > 0 && eVulCodeMap.containsKey(s)) {
                            eVulCodeMap.remove(s);
                        }
                    }
                }
                // Check if any element is left in Map and add it to the list to be be upserted
                if (eVulCodeMap.size() > 0) {
                    for (String s: eVulCodeMap.keySet()) {
                        eonVunCode = eVulCodeMap.get(s);
                        vulDescriptionSet.add(eonVunCode.id);
                        eonApptVulnerabilities.add(new EON_Appointment_Vulnerability__c(EON_Appointment_ID__c = newAppointment.id, Description__c = eonVunCode.id, VulnerabilityDetailCode__c = eonVunCode.Vulnerability_Code__c));
                    }
                }
            }
            //CH22
            getDeliveryMethod();
            //CH19
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        }
        return null;
    }
    //CH03.Start
    /**
        isKeycollection(): This method will render the Key collection section if it is ticked then it will be displayed else remainng fields will be hide.
    **/
    public PageReference isKeycollection() {
        System.debug('Method called.');
        return null;
    }
    //CH03.End
    //CH10.Start
    /**
        getEonSSC(): This method will get the list of EON SCC values as picklist values.
    **/
    public List < SelectOption > getEonSSC() {
        //Add the None option to pick list
        List < SelectOption > eonSSCOptions = new List < SelectOption > {
            new SelectOption('', '-- None --')
        };
        
        //CH49.Start
        String Current_SSC = newAppointment.Current_SSC__c;
        String h_Job_type = '';
        String Job_Code_Name = '';
        String GSP_Group_ID = '';
        
        if(appointmentID != null){
            EON_Appointment__c orgApp = [select Current_SSC__c,h_Job_type__c,Job_Code__r.Name, GSP_Group_ID__c
                                     from EON_Appointment__c  where id=:appointmentID]; 
            Current_SSC = orgApp.Current_SSC__c;
            h_Job_type = orgApp.h_Job_type__c;
            Job_Code_Name = orgApp.Job_Code__r.Name;
            GSP_Group_ID  = orgApp.GSP_Group_ID__c;                                                
        }else{
            EON_Job__c job = [select Name, Job_Type__c from Eon_Job__c where id=: newAppointment.Job_Code__c];
            h_Job_type = job.Job_Type__c;
            Job_Code_Name = job.Name;
            GSP_Group_ID = newAppointment.GSP_Group_ID__c;
        }       
        
        System.debug('******123 '+ Current_SSC);
        System.debug('JobName**** '+ h_Job_type);
        System.debug('GSP_Group_ID **** '+ GSP_Group_ID );
        EON_SSC__c[] lstEonSSC = [select id from EON_SSC__c where name =: Current_SSC and 
                                  type__c = 'Smart'];  
        //If job type is SMART                                        
        if(String.isNotBlank(h_Job_type) && h_Job_type.containsIgnoreCase('SMART')){
            if(lstEonSSC.isEmpty()){
                eonSSCOptions = getUnSupportedSSC(Current_SSC);
                return eonSSCOptions;
            }  
            //This is for only OOAMETERFUNCCHANGE          
        }else if(String.isNotBlank(Job_Code_Name) && Job_Code_Name.containsIgnoreCase('OOAMETERFUNCCHANGE')
                            && appointmentID != null){
            EON_SSC__c[] lstEonSSCClassic = [select id from EON_SSC__c where name =: Current_SSC and 
                                  type__c = 'Classic'];                            
            eonSSCOptions.add(new SelectOption('', '-- None --'));
            eonSSCOptions = getSSCGroup(GSP_Group_ID, current_SSC, !lstEonSSCClassic.isEmpty());
            if(!lstEonSSCClassic.isEmpty()){
                this.Appt.Requested_SSC__c = Current_SSC;
            }
            return eonSSCOptions;
        }
        //CH49.End
                
        //CH29.Start
        if (String.isNotBlank(newAppointment.MPAN__c)) { //CH029 Added condition if MPAN id not null
            //CH21 changed the map values from EONSSC to EONSSC.Name
            Map < String, String > mapofEonSSC = new Map < String, String > (); // to store the Key as Name+Type__c(SMart or Classic) and EONSSC.Name
            Map < String, String > mapClassicEonSSC = new Map < String, String > (); //CH21 to store the Classic EON SSC records.
            Boolean isTermination = false;
            system.debug(newAppointment.Current_SSC__c);
            System.debug('newAppointment.Job_Code__c = ' + newAppointment.Job_Code__c);
            String JobName = (selJobRecord != null && selJobRecord.size() > 0 ? selJobRecord[0].Name : '');
            String JobType = (selJobRecord != null && selJobRecord.size() > 0 ? selJobRecord[0].Job_Type__c : '');
            //Query the records for EON SSC with Name of Current SSC or Type = SMART
            //CH35.Start
            list < Eon_Appointment__c > apptg = new list < Eon_Appointment__c > ();
            apptg = [SELECT Id, GSP_Group_ID__c from Eon_Appointment__c where ID = : newAppointment.id and GSP_Group_ID__c != null and GSP_Group_ID__c != '']; //CH35
            Map < string, id > mGroupMap = new Map < string, id > ();
            if (!apptg.isEmpty()) {
                for (EON_SSC_Group__c gg: [select SSC__c, Group__c, Group__r.name, SSC__r.name from EON_SSC_Group__c where Group__r.name = : apptg[0].GSP_Group_ID__c]) { mGroupMap.put(gg.SSC__r.name, gg.id);}//CH35
            }
            //CH35.Stop
            for (EON_SSC__c eSSC: [SELECT ID, Name, Number_of_Registers__c, Type__c FROM EON_SSC__c WHERE Type__c != null OR Name = : newAppointment.Current_SSC__c Order by Type__c ASC LIMIT 50000]) {
                if (newAppointment.Job_Code__c != null && ((string.isBlank(appReason) && String.isNotBlank(JobName) && JobName.containsIgnoreCase('SMART')) || (String.isNotBlank(newAppointment.Job_Code__r.Name) && newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART')))) {
                    if (String.isNotBlank(newAppointment.Current_SSC__c) && ((string.isBlank(appReason) && String.isNotBlank(JobType) && !JobType.containsignorecase('New') && !JobType.containsignorecase('Connection')) || (String.isNotBlank(newAppointment.Job_Code__r.Job_Type__c) && !newAppointment.Job_Code__r.Job_Type__c.containsignorecase('New') && !newAppointment.Job_Code__r.Job_Type__c.containsignorecase('Connection'))) && eSSC.Name.equalsIgnoreCase(newAppointment.Current_SSC__c) && eSSC.Type__c.equalsIgnoreCase('Smart')) {
                        //CH35
                        if (appReason != null && appReason != '' && appReason == 'New Connections' && mGroupMap != null && mGroupMap.size() > 0 && mGroupMap.containsKey(eSSC.Name)) {return new List < SelectOption > {new SelectOption(eSSC.Name, eSSC.Name)};}
                        else {return new List < SelectOption > {new SelectOption(eSSC.Name, eSSC.Name)};}
                        //CH35
                    }
                    if (eSSC.Type__c.equalsIgnoreCase('Smart')) {mapofEonSSC.put(eSSC.Name, eSSC.Name);}
                } else {
                    if (!isTermination && newAppointment.Job_Code__c != null && String.isNotBlank(newAppointment.Current_SSC__c) && ((string.isBlank(appReason) && string.isNotBlank(JobType) && !JobType.containsignorecase('New') && !JobType.containsignorecase('Connection')) || (String.isNotBlank(newAppointment.Job_Code__r.Job_Type__c) && !newAppointment.Job_Code__r.Job_Type__c.containsignorecase('New') && !newAppointment.Job_Code__r.Job_Type__c.containsignorecase('Connection')))) {isTermination = true;}
                    if (eSSC.Type__c.equalsIgnoreCase('Classic')) {mapClassicEonSSC.put(eSSC.Name, eSSC.Name);}
                }
                if (eSSC.Type__c.equalsIgnoreCase('Smart')) {
                    mapofEonSSC.put(eSSC.Name, eSSC.Name);
                }
                if (eSSC.Type__c.equalsIgnoreCase('Classic')) {
                    mapClassicEonSSC.put(eSSC.Name, eSSC.Name);
                }
            }
            System.debug('isTermination = ' + isTermination + mapClassicEonSSC.size() + ',' + mapofEonSSC.size());
            //if eonSSCOptions is already has the size = 1 and current SSC is null or Current SSC is not exist in EON SSC then return all Smart EON SSC records 
            if (isTermination && ((mapClassicEonSSC.size() > 0 && mapClassicEonSSC.containsKey(newAppointment.Current_SSC__c)) || (mapofEonSSC.size() > 0 && mapofEonSSC.containsKey(newAppointment.Current_SSC__c)))) {
                //CH35
                if (appReason != null && appReason != '' && appReason == 'New Connections' && mGroupMap != null && mGroupMap.size() > 0 && mGroupMap.containsKey(newAppointment.Current_SSC__c)) { return new List < SelectOption > {new SelectOption(newAppointment.Current_SSC__c, newAppointment.Current_SSC__c)};}
               else
                 return new List < SelectOption > {new SelectOption(newAppointment.Current_SSC__c, newAppointment.Current_SSC__c)};
                
            }
            //CH21 adding condition
            if (eonSSCOptions.size() == 1 && newAppointment.Job_Code__c != null && ((string.isBlank(appReason) && String.isNotBlank(JobName) && JobName.containsIgnoreCase('SMART')) || (newAppointment.Job_Code__r.Name != null && newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART'))) && (((string.isBlank(appReason) && string.isNotBlank(JobType) && JobType.containsIgnoreCase('New') && JobType.containsIgnoreCase('Connection')) || (String.isNotBlank(newAppointment.Job_Code__r.Job_Type__c) && newAppointment.Job_Code__r.Job_Type__c.containsIgnoreCase('New') && newAppointment.Job_Code__r.Job_Type__c.containsIgnoreCase('Connection'))) || String.isBlank(newAppointment.Current_SSC__c) || (mapofEonSSC.size() > 0 && !mapofEonSSC.containsKey(newAppointment.Current_SSC__c)))) {
                for (String eSS: mapofEonSSC.values()) {
                    //CH35.Start
                    if (appReason != null && appReason != '' && appReason == 'New Connections' && mGroupMap != null && mGroupMap.size() > 0 && mGroupMap.containsKey(eSS)) {eonSSCOptions.add(new SelectOption(eSS, eSS));} 
                    else if (appReason != null && appReason != '' && appReason != 'New Connections'){eonSSCOptions.add(new SelectOption(eSS, eSS));}
                    else if (appReason != null && appReason != '' && mGroupMap.size() == 0){eonSSCOptions.add(new SelectOption(eSS, eSS));}
                    else if(appReason != 'New Connections') {eonSSCOptions.add(new SelectOption(eSS, eSS));}

                    //CH35.END
                }
            }
            if (eonSSCOptions.size() == 1 && newAppointment.Job_Code__c != null && ((string.isBlank(appReason) && String.isNotBlank(JobName) && !JobName.containsIgnoreCase('SMART')) || (newAppointment.Job_Code__r.Name != null && !newAppointment.Job_Code__r.Name.containsIgnoreCase('SMART'))) && ((string.isBlank(appReason) && string.isNotBlank(JobType) && JobType.containsIgnoreCase('New') && JobType.containsIgnoreCase('Connection')) || (String.isNotBlank(newAppointment.Job_Code__r.Job_Type__c) && newAppointment.Job_Code__r.Job_Type__c.containsIgnoreCase('New') && newAppointment.Job_Code__r.Job_Type__c.containsIgnoreCase('Connection')))) {
                System.debug('Entered in to condition' + mapClassicEonSSC.size());
                for (String eSS: mapClassicEonSSC.values()) {
                    //CH35.Start
                    if (appReason != null && appReason != '' && appReason == 'New Connections' && mGroupMap != null && mGroupMap.size() > 0 && mGroupMap.containsKey(eSS)) {eonSSCOptions.add(new SelectOption(eSS, eSS));}
                    else if (appReason != null && appReason != '' && appReason != 'New Connections'){eonSSCOptions.add(new SelectOption(eSS, eSS));}
                    else if (appReason != null && appReason != '' && mGroupMap.size() == 0){eonSSCOptions.add(new SelectOption(eSS, eSS));}
                    else if(appReason != 'New Connections'){eonSSCOptions.add(new SelectOption(eSS, eSS));}
                    //CH35.END
                }
            }
            if (eonSSCOptions.size() == 1 && appReason != null && appReason != '' && !appReason.containsignorecase('New') && !appReason.containsignorecase('Connection') && newAppointment.Current_SSC__c != null && newAppointment.Current_SSC__c != '' && !newAppointment.Job_Code__r.Name.containsignorecase('SMART')) {
                //CH35.Start
                if (appReason != null && appReason != '' && appReason == 'New Connections' && mGroupMap != null && mGroupMap.size() > 0 && mGroupMap.containsKey(newAppointment.Current_SSC__c)) {return new List < SelectOption > {new SelectOption(newAppointment.Current_SSC__c, newAppointment.Current_SSC__c)};}
                else if (appReason != null && appReason != '' && appReason != 'New Connections') return new List < SelectOption > {new SelectOption(newAppointment.Current_SSC__c, newAppointment.Current_SSC__c)};
                else  return new List < SelectOption > {new SelectOption(newAppointment.Current_SSC__c, newAppointment.Current_SSC__c)};

                //CH35.END
            }
            //CH21.End
        } //CH029.End Added condition
        return eonSSCOptions;
    }
    //CH10.End
    //CH15.Start
    //CH18.start
    /**
        createApptIndus(): This method will identify that, to redirect the user to capacities page or call the OFSC method to send the ECO data to create the appointment.
    **/
    public pageReference createApptIndus() {
        if (string.isNotBlank(appReason) && appReason.equalsIgnoreCase('Emergency Call Out')) {
            String ofscResponse = EON_OFSC_Send_Appointment.sendActivityToOFSC((String) newAppointment.id, 'CREATE', '', '', String.valueOf(newAppointment.Appointment_Date__c), newAppointment.Time_Slot__c, 'MUS');
            if (ofscResponse != '' && ofscResponse.containsIgnoreCase('OFSC successfully')) {
                newAppointment.Sent_to_Oracle__c = true;
                newAppointment.Confirmed_Appointment_DateTime__c = System.now();
                update newAppointment;
                Eon_Appointment__c app = [SELECT Id, Fuel_ID__c, Name, Appointment_Date__c, Start_Time__c, End_Time__c, Time_Slot__c FROM Eon_Appointment__c WHERE ID = : newAppointment.id];
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ofscResponse));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Appointment : ' + app.Name));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Appointment Date : ' + app.Appointment_Date__c + ', Start Time:' + app.Start_Time__c + ', End Time: ' + app.End_time__c + ', Time Slot : ' + app.Time_Slot__c));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ofscResponse));
            }
        } else {
            return (new PageReference('/apex/EON_DisplayCapacitiesFromOFSC?appID=' + newAppointment.id + '&jobcode=' + newAppointment.Job_Code__c + '&bucketID=' + oracleBucketID));
        }
        return null;
    }
    //CH18.end
    /**
        isBlankVal(String strVal): This method will return the TRUE when parameter is not null and not blank else FALSE
    **/
    private boolean isBlankVal(String strVal) {
        if (strVal != null && strVal != '') {
            return true;
        } else return false;
    }
    //CH15.End
    
    //CH47.Start
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
    //CH47.End   
    
    //CH49.Start
    /**
        validateRequestedSSC(String currentSSC) - This method validates the Current SSC with unsupported SSC.
    **/
    public boolean validateRequestedSSC(String currentSSC){
        EON_SSC__c[] lstEonSSC = [select id from EON_SSC__c where name =: currentSSC and type__c = 'Smart'];
        if(lstEonSSC.isEmpty()){
            EON_Unsupported_SSC__c[] lstUnSupportedSSC = [select id from EON_Unsupported_SSC__c 
                                                            where Name =: currentSSC];     
            if(lstUnSupportedSSC.isEmpty())
                return true;
            else
                return false;    
        }
        return false;
    }
    
    /**
        getUnSupportedSSC() - This method returns the unsupported SSC to display in pick list in the page.   
    **/
    public List<SelectOption> getUnSupportedSSC(String currentSSC){
        List<SelectOption> lstOption = new List<SelectOption>();
        for(EON_Unsupported_SSC__c  unSupportedSSC : [select id, Supported_SSC__r.Name from EON_Unsupported_SSC__c 
                                                              where Name =: currentSSC]){
            lstOption.add(new SelectOption(unSupportedSSC.Supported_SSC__r.Name, unSupportedSSC.Supported_SSC__r.Name));
        }
        return lstOption;
    }
    
    /**
        getSSCGroup() - This method returns the SSC names related to appointment group id.   
    **/
    public List<SelectOption> getSSCGroup(String groupID, String currentSSC, boolean isCurrentSSCExists){
        List<SelectOption> lstOption = new List<SelectOption>();
        boolean isExist = false;
        for(EON_SSC_Group__c SSCGroup: [select SSC__r.name from 
                                        EON_SSC_Group__c where Group__r.name = : groupID]){                                                        
            if(SSCGroup.SSC__r.name == currentSSC)
                isExist = true;    
            lstOption.add(new SelectOption(SSCGroup.SSC__r.Name, SSCGroup.SSC__r.Name));
        }
        
        if(!isExist && isCurrentSSCExists)
            lstOption.add(new SelectOption(currentSSC, currentSSC));
            
        return lstOption;
    }    
    //CH49.End
    
    /**
        validateSSC(String jobID, String currentSSC) - this method is for validate the current SSC value
    **/
    public void validateSSC(String jobID, String currentSSC){
        //CH49.Start
        System.debug('****currentSSC ' + currentSSC);
        System.debug('****jobID ' + jobID);
        EON_Job__c job = [select Name, Job_Type__c from Eon_Job__c where id=: jobID];

        if(job.Job_type__c.containsignorecase('Smart') && validateRequestedSSC(currentSSC)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 
            'The current SSC of this electric meter is not supported for a smart exchange by MUS. EON will need to be contacted regarding a potential change of tariff conversation with the customer and appointment booking'));
            isRejected = true;
        }
        //CH49.End      
    }
    
    //CH53.start
      /**
        UpdateRowCon(): This method will remove the record from the list and delete the record from isis.
    **/
    public PageReference UpdateRowCon() {
    updateCOntact=true;
        if(!canProceed){ 
        isupdatecon=true;
            try {
                   ApptCont = lstApptContact[removeIndex];
                   lstApptContact.remove(removeIndex);
                }
            catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            }
        }else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You are not allowed to delete'));
        
        return null;
    }
    //CH53.end
}