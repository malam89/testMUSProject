/**
    Description : This class is to create appointment when reschedule button is clicked for replan.
                    Test Class : EON_Create_Appointment_Replan_ctrl_Test
**/

/*
    Created By : Praveen G
    Created Date : 08/02/2018
    Service Request : SR_OptiMUS_EON_179
	Change Request:
	CH01 # SR_OptiMUS_EON_297 # 11/02/2019 # Tabish Almas # Added logic to get data from MDS or Jumbo based on MDS Jumbo Dataflow Switch
*/

public with sharing class EON_Create_Appointment_Replan_ctrl {

    public String appointmentID {get;set;}
    public EON_Appointment__c newAppointment{get;set;}
    public List <SelectOption> GMetLocLst {get;set;} 
    public List <SelectOption> EMetLocLst {get;set;}  
    public List <SelectOption> DeliveryMethodLstC {get;set;}
    public List <SelectOption> DeliveryMethodLstI {get;set;}
    public List <SelectOption> DeliveryMethodLstR {get;set;}   
    public String selectedDeliveryMethod_c {get;set;}
    public String selectedDeliveryMethod_I {get;set;}
    public String selectedDeliveryMethod_R {get;set;}
    public String selectedParking {get;set;}
    public List <SelectOption> parkingLst {get;set;}  
    public List < EON_Appointment_Contact__c > lstApptContact {get;set;}    
    public Integer removeIndex {get;set;}  
    public String addErrorMsg {get;set;}    
    public String selectedContact {get;set;} 
    public EON_Appointment_Contact__c ApptCont {get;set;} 
    public String selectedMediaType {get;set;}  
    public List <SelectOption> MediaTypeLst {get;set;}  
    public List <SelectOption> ContactLst {get;set;} 
    public String selectedVulnerability {get;set;}
    public EON_Appointment_Vulnerability__c EON_Appt_Vuln {get;set;}       
    public List <EON_Appointment_Vulnerability__c> lstApptVulnerability {get;set;} 
    public List < SelectOption > VulnerabilityLst {get;set;}     
    
    /**
        isRejected : to check the errors are persent or not
    **/
    public Boolean canProceed {
        get {
            if(canProceed == null)
                canProceed = false;
            return canProceed;
        }
        set;
    }    
    
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
        EON_Create_Appointment_Request_ctrl(ApexPages.StandardController controller) - 
            Standard controller.    
    **/
    public EON_Create_Appointment_Replan_ctrl(ApexPages.StandardController controller) {
        //newAppointment = new EON_Appointment__c();
        
		String switchData = EON_MDS_Utility.getMDS_Jumbo_Status();	//CH01
		
        try{
            appointmentID = ApexPages.CurrentPage().getParameters().get('appointmentID');
            Eon_Appointment__c reSchedulednewAppoitment = new Eon_Appointment__c(id = appointmentID);
            sObject originalSObject = (sObject) reSchedulednewAppoitment; 
            
            ApptCont = new EON_Appointment_Contact__c();
            EON_Appt_Vuln = new EON_Appointment_Vulnerability__c();
            
            List <String> relationFields = new List <String>();
            relationFields.add('Job_Code__r.Job_Type__c');
            relationFields.add('Fuel_ID__r.Premise__r.Postcode__c');
            
            List <sObject> originalSObjects = new List <sObject> {
                originalSObject
            };                
                   
            List <Eon_Appointment__c> allFieldSObjects = 
                    EON_Utility.getAllFields(originalSobjects, originalSobject.getsObjectType(), relationFields);
            
            newAppointment = allFieldSObjects[0];
            
			//CH01.Start
			if(switchData == system.label.Jumbo_Shortform) {
				if(allFieldSObjects[0].MPAN__c != null){        
					EON_Jumbo_ReqElecMeterPointData.AccessElecMeterPointData(newAppointment.MPAN__c.trim(),
					newAppointment, '', '');
					newAppointment = EON_Jumbo_ReqElecMeterPointData.apptIns;
				}
				
				if(allFieldSObjects[0].MPRN__c != null){
					EON_Jumbo_ReqGasMeterPointData.AccessGasMeterPointData(newAppointment.MPRN__c.trim(), 
					newAppointment, '', '');
					newAppointment = EON_Jumbo_ReqGasMeterPointData.apptIns;
				}
			}
			else if(switchData == system.label.MDS_Shortform) {
				if(allFieldSObjects[0].MPAN__c != null){        
					EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(newAppointment.MPAN__c.trim(),
					newAppointment, '', '');
					newAppointment = EON_MDS_ReqElecMeterPointData.apptIns;
				}
				
				if(allFieldSObjects[0].MPRN__c != null){
					EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(newAppointment.MPRN__c.trim(), 
					newAppointment, '', '');
					newAppointment = EON_MDS_ReqGasMeterPointData.apptIns;
				}
			}
			//CH01.End
            
            
            Eon_Appointment__c tempApp = [select Planned_E_Meter_Type__c from Eon_Appointment__c where id =:appointmentID];
            
            newAppointment.Planned_E_Meter_Type__c = tempApp.Planned_E_Meter_Type__c;
            
            lstApptContact = new List < EON_Appointment_Contact__c > ([SELECT Contact_Full_Name__c, Contact_Type__c, Id, Name, 
                                Customer_Assistant__c, EON_Appointment_ID__c, Media_Detail__c, Media_Type__c 
                                FROM EON_Appointment_Contact__c WHERE EON_Appointment_ID__c = : newAppointment.id]);
            lstApptVulnerability = new List < EON_Appointment_Vulnerability__c > ([SELECT Description__c, EON_Appointment_ID__c, Id, 
                                            Name, VulnerabilityDetailCode__c, VulnerabilityTypeID__c FROM 
                                            EON_Appointment_Vulnerability__c WHERE EON_Appointment_ID__c = : newAppointment.id]);
                                
            
                            
            getVulnerablities();
            getParkingTypes();
            getDeliveryMethodC();
            getDeliveryMethodI();
            getDeliveryMethodR();
            getEMeterloc();
            getGMeterloc();
            getMediaType();  
            getVulnerablities(); 
            getContactTypes();  
        }catch(Exception ex){
        }   
    }
    
    public void getMediaType() {
        list < EON_Media_Type__c > MTypelist = [select id, name from EON_Media_Type__c limit 50000];
        if (MTypelist != null && MTypelist.size() > 0) {
            MediaTypeLst = new List < SelectOption > ();
            for (EON_Media_Type__c MT: MTypelist) {
                MediaTypeLst.add(new SelectOption(MT.id, MT.name));
            }
        }
    }    
    
    public void getVulnerablities() {
        list < EON_Vulnerability_Code__c > VulnerabilityList = [select id, name from EON_Vulnerability_Code__c limit 50000];
        if (VulnerabilityList != null && VulnerabilityList.size() > 0) {
            VulnerabilityLst = new List < SelectOption > ();
            for (EON_Vulnerability_Code__c vulnerability: VulnerabilityList) {
                VulnerabilityLst.add(new SelectOption(vulnerability.id, vulnerability.name));
            }
        }
    }    
    
    /**
        addRowCon(): This method will add the new row to the list to for adding the new Appointment Contact.
    **/
    public PageReference addRowCon() {
        if (selectedContact != null && ApptCont.Contact_Full_Name__c != null && selectedMediaType != null && 
                                ApptCont.Media_Detail__c != null) { 
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
            if(addContact){
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
            }
        } else {
            addErrorMsg = 'Any of the following fields: Contact Type, Contact Full Name, Media Type, Media Detail can\'t be blank';
        }
        return null;
    }    
    
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
    
    /**
        removeRow(): This method will remove the record from the list and delete the record from isis.
    **/
    public PageReference removeRowCon() {
        System.debug('index to remove = ' + removeIndex);
        try {
            if (EON_Utility.genException != null && EON_Utility.genException){System.debug(lstApptContact[0].name);} //To cover exception in test class
            if (removeIndex != null && lstApptContact.size() >= removeIndex) {
                EON_Appointment_Contact__c appcon = ((lstApptContact[removeIndex].id != null) ? lstApptContact[removeIndex] : null);
                
                List<EON_Appointment_Contact__c> lstTemp = new List<EON_Appointment_Contact__c>(lstApptContact);
                lstTemp.remove(removeIndex);
                boolean isAllow = validateAppointmentContacts(lstTemp);
                              
                if (appcon != null && lstApptContact.size()>1 
                                    && !isAllow){
                    delete appcon;}
                   
                if(lstApptContact.size() !=1 && removeIndex!=0 
                                        && !isAllow) 
                  lstApptContact.remove(removeIndex);
            }
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        }
        return null;
    }    
    
    /**
        isKeycollection(): This method will render the Key collection section if it is ticked then it will be 
                            displayed else remainng fields will be hide.
    **/    
    public PageReference isKeycollection() {
        System.debug('Method called.');
        return null;
    } 
    
    /**
        getGMeterloc() - to get the meter locaiton.
    **/
    public void getGMeterloc() {
        list <EON_Gas_Meter_Location__c> GMeterlist = [select id, name from EON_Gas_Meter_Location__c limit 50000];
        if (GMeterlist != null && GMeterlist.size() > 0) {
            GMetLocLst = new List < SelectOption > ();
            for (EON_Gas_Meter_Location__c GMl: GMeterlist) {
                GMetLocLst.add(new SelectOption(GMl.id, GMl.name));
            }
        }
    }
    
    /**
        getGMeterloc() - to get the meter locaiton.
    **/    
    public void getEMeterloc() {
        list < EON_Electric_Meter_Location__c > EMeterlist = [select id, name from EON_Electric_Meter_Location__c limit 50000];
        if (EMeterlist != null && EMeterlist.size() > 0) {
            EMetLocLst = new List < SelectOption > ();
            for (EON_Electric_Meter_Location__c EMl: EMeterlist) {
                EMetLocLst.add(new SelectOption(EMl.id, EMl.name));
            }
        }
    }
    
    public List <EON_Appointment_Comms__c> getAppCommsLst() {
        List <EON_Appointment_Comms__c> existComms = new List <EON_Appointment_Comms__c> ();
        if (newAppointment != null)
            existComms = [select id, Comm_Type_Code__c, Delivery_Method_Desc__c, Delivery_Method_Desc__r.name, 
                            EON_Appointment_ID__c from EON_Appointment_Comms__c 
                            where EON_Appointment_ID__c = : newAppointment.id];
        return existComms;
    } 
    
    public List <Eon_Delivery_Method__c> delMethLst = [select id, name from Eon_Delivery_Method__c limit 50000];
    
    public void getDeliveryMethodC() {
        String dmName1 = '', dNone1 = '';
        if (delMethLst != null && delMethLst.size() > 0) {
            DeliveryMethodLstC = new List <SelectOption> ();
            List <EON_Appointment_Comms__c> appCommsLst = getAppCommsLst();
            if (appCommsLst != null && appCommsLst.size() > 0) {
                for (EON_Appointment_Comms__c comms: appCommsLst) {
                    if (comms.Delivery_Method_Desc__c != null && comms.Comm_Type_Code__c != null && comms.Comm_Type_Code__c != '' && 
                                    comms.Comm_Type_Code__c == 'C') {
                        DeliveryMethodLstC.add(new SelectOption(comms.Delivery_Method_Desc__c, comms.Delivery_Method_Desc__r.name));
                        dmName1 = comms.Delivery_Method_Desc__r.name;
                    }
                }
            }
            if (newAppointment != null && newAppointment.h_Job_Code__c != null && newAppointment.h_Job_Code__c != '' && 
                                            newAppointment.h_Job_Code__c.containsIgnoreCase('smart')) {
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
            if (newAppointment != null && newAppointment.h_Job_Code__c != null && newAppointment.h_Job_Code__c != '' && 
                    newAppointment.h_Job_Code__c.containsIgnoreCase('smart')) {
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
            List <EON_Appointment_Comms__c> appCommsLst = getAppCommsLst();
            if (appCommsLst != null && appCommsLst.size() > 0) {
                for (EON_Appointment_Comms__c comms: appCommsLst) {
                    if (comms.Delivery_Method_Desc__c != null && comms.Comm_Type_Code__c != null && comms.Comm_Type_Code__c != '' && comms.Comm_Type_Code__c == 'R') {
                        DeliveryMethodLstR.add(new SelectOption(comms.Delivery_Method_Desc__c, comms.Delivery_Method_Desc__r.name));
                        dmName3 = comms.Delivery_Method_Desc__r.name;
                    }
                }
            }
            if (newAppointment != null && newAppointment.h_Job_Code__c != null && newAppointment.h_Job_Code__c != '' && 
                    newAppointment.h_Job_Code__c.containsIgnoreCase('smart')) {
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
    
    public void getParkingTypes() {
        list < EON_Parking__c > parkinglist = [select id, name from EON_Parking__c limit 50000];
        if (parkinglist != null && parkinglist.size() > 0) {
            parkingLst = new List < SelectOption > ();
            for (EON_Parking__c Park: parkinglist) {
                parkingLst.add(new SelectOption(Park.id, Park.name));
            }
        }
    } 
    
    public PageReference addRow() {
        if (selectedVulnerability != null) {
            List < EON_Vulnerability_Code__c > eonVulnerabilityCode = [select id, name, Vulnerability_Code__c from 
                                                EON_Vulnerability_Code__c where id = : selectedVulnerability]; 
            EON_Appt_Vuln.Description__c = selectedVulnerability;
            if (eonVulnerabilityCode != null && eonVulnerabilityCode.size() > 0) {
                EON_Appt_Vuln.VulnerabilityDetailCode__c = eonVulnerabilityCode[0].Vulnerability_Code__c;
                if ((EON_Appt_Vuln.VulnerabilityTypeID__c == null || EON_Appt_Vuln.VulnerabilityTypeID__c == '') && 
                (selectedVulnerability != null && selectedVulnerability != '')) {
                    addErrorMsg = 'Vulnerability type field is mandatory if vulnerability exists';} 
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
    }     
    
    
    /**
        removeRow(): This method will remove the record from the list and delete the record from isis.
    **/
    public PageReference removeRow() {
        System.debug('index to remove = ' + removeIndex);
        try {
            if (EON_Utility.genException != null && EON_Utility.genException){System.debug(lstApptVulnerability[0].name);}//To cover exception in test class
            if (removeIndex != null && lstApptVulnerability.size() >= removeIndex) {
                EON_Appointment_Vulnerability__c appVul = ((lstApptVulnerability[removeIndex].id != null) ? 
                                                                            lstApptVulnerability[removeIndex] : null);
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
    
    public void getContactTypes() {
        list < EON_Contact_Type__c > ContactList = [select id, name from EON_Contact_Type__c limit 50000];
        if (ContactList != null && ContactList.size() > 0) {
            ContactLst = new List < SelectOption > ();
            for (EON_Contact_Type__c contact: ContactList) {
                String cName = contact.Name;
                if(contact.Name == 'Appointment Contact')
                    cName = 'Appointment Contact (Default)';
                else if(contact.Name == 'Reminder Contact (Default)')
                    cName = 'Reminder Contact';
                    
                ContactLst.add(new SelectOption(contact.id, cName)); 
            }
        }
    } 
    
    public PageReference save(){
        try{
            String correctWorkSkill = EON_OFSC_Helper.getWorkSkill(newAppointment);
            if (correctWorkSkill != '' && correctWorkSkill.containsIgnoreCase('Invalid')) {
                canProceed = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 
                                    'Meter information could not be retrieved, please contact MUS back office.'));
                return null;
            } 
            
            for (EON_Appointment_Contact__c appContact: lstApptContact) {
                if (appContact.EON_Appointment_ID__c == null) {
                    appContact.EON_Appointment_ID__c = newAppointment.id;
                }
            }                  
            
            if(!lstApptContact.isEmpty())
                upsert lstApptContact;
            
            for (EON_Appointment_Vulnerability__c apptVul: lstApptVulnerability) {
                if (apptVul.EON_Appointment_ID__c == null) 
                    apptVul.EON_Appointment_ID__c = newAppointment.id;
            }
            
            if(!lstApptVulnerability .isEmpty())
                upsert lstApptVulnerability;
                
                
            for(EON_Appointment_Comms__c appCom : getAppCommsLst()){
                if(appcom.Comm_Type_Code__c == 'C'){
                    if(appCom.Delivery_Method_Desc__c != selectedDeliveryMethod_c){
                        appCom.Delivery_Method_Desc__c = selectedDeliveryMethod_c;
                        upsert appCom; //Thsi loop will run only 3 times, this DML is fine.
                    }
                }
                
                if(appcom.Comm_Type_Code__c == 'I'){
                    if(appCom.Delivery_Method_Desc__c != selectedDeliveryMethod_I){
                        appCom.Delivery_Method_Desc__c = selectedDeliveryMethod_I;
                        upsert appCom; //Thsi loop will run only 3 times, this DML is fine.
                    }
                }
                if(appcom.Comm_Type_Code__c == 'R'){
                    if(appCom.Delivery_Method_Desc__c != selectedDeliveryMethod_R){
                        appCom.Delivery_Method_Desc__c = selectedDeliveryMethod_R;
                        upsert appCom; //Thsi loop will run only 3 times, this DML is fine.
                    }
                }                                
            }

            upsert newAppointment; 
            canProceed = true;          
        }
        catch (Exception ex) {
            System.debug('##exception occurs here' + ex.getMessage() + 'at line no-->' + ex.getStackTraceString());
            canProceed = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        }
        return null; 
    } 
    
    /**
        createApptInOFSC(): This method will identify that, to redirect the user to capacities page or call the OFSC method to send 
                    the ECO data to create the appointment.
    **/
    public pageReference createApptInOFSC() {
        EON_Appointment__c tempApp = [select id, Job_Code__c, Job_code__r.Name, Job_code__r.Job_Type__c, Fuel_ID__r.Premise__r.Postcode__c, 
                                     MPAN__c, Metering_Point_Postcode__c, MPRN__c  
                                    from Eon_Appointment__c where id=:newAppointment.id];
                                    
        oracleBucketID = EON_OFSC_Helper.getOracleBucketId(tempApp.Job_code__r.Name, tempApp.Job_code__r.Job_Type__c, ((tempApp.Fuel_ID__r.Premise__r.Postcode__c != null) ? tempApp.Fuel_ID__r.Premise__r.Postcode__c : (((tempApp.MPAN__c != null && tempApp.MPRN__c != null) || tempApp.MPAN__c != null) ? tempApp.Metering_Point_Postcode__c : tempApp.Post_Code__c)), tempApp.MPAN__c);
        oracleBucketID = ((string.isBlank(oracleBucketID)) ? 'EXE_ONLY' : oracleBucketID);        
        return (new PageReference('/apex/EON_DisplayCapacitiesFromOFSC?appID=' + newAppointment.id + '&jobcode=' + tempApp.Job_Code__c + '&bucketID=' + oracleBucketID));
               
    }      
                 
}