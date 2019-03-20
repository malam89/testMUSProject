/**
    Description     : This controller is used to Update Activity in OFSC system from EON System.
    Test Class      : EON_OFSC_Update_Appointment_test     
**/
/*
    Created By : Dharmendra Pahadiya
    Created Date : 04-Apr-2016
    Service Request : SR_EON_Scheduling_007
    Change History : 
     CH01 # SR_EON_AB_045 # 16/04/2016 # Dharmendra P # Updated 'SubArea' & 'Duration' fields of EON Appointment if Activity successfully created.
     CH02 # SR_EON_Scheduling_024 # 16/04/2016 # Dharmendra P # Check 'Sent to Oracle' field of EON Appointment on Successful Create Activity 
     CH03 # SR_EON_AB_042 # 16/04/2016 # Dharmendra P # Updated duration calculation logic.
     CH04 # SR_EON_Scheduling_023 # 18/04/2016 # Dharmendra P # Updated field mapping.
     CH05 # SR_EON_Scheduling_025 # 20/04/2016 # Dharmendra P # Updating Sent_to_Oracle_Update__c field for UPDATE activity.
     CH06 # SR_EON_Mobile_031 # 21/04/2016 # Dharmendra P # Updated mapping.
     CH07 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
     CH08 # SR_EON_Mobile_043 # 07/06/2016 # Dharmendra P # Added/Updated mapping.
     CH09 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c,Planned_Number_of_Registers__c  
     CH10 #SR_EON_AB_072 #16/06/2016 #Shruti Moghe # Added Current_SSC__c field in Query 
     CH11 # SR_EON_AB_068 # 22/06/2016 # Puneet Mehta # Added new property mapping.
     CH12 # SR_EON_Mobile_049 # 29/06/2016 # Dharmendra P # Added/Update new mapping.
     CH13 # SR_EON_Mobile_053 # 01/07/2016 # Dharmendra P # Updated mapping enumeration.
     CH14 # SR_EON_AB_087 # 12/07/2016 # Akshay B # Assigned Execption BucketID.
     CH15 # SR_EON_AB_094 # Dharmendra P # Updated mapping for 'XA_ASSET_G_TYPE' OFSC label.
     CH16 # SR_EON_AB_095 # Akshay B # duration calculation when fuel is blank
     CH17 # SR_EON_AB_108 # 30/07/2016 # Shruti Moghe # updated the Key_Contact_Number__c field data type from number to Text
     CH18 # SR_EON_Mobile_070 # 05/08/2016 # Purvi # removed check for MS1 
     CH19 # SR_EON_Mobile_071 # 08/08/2016 # Purvi # added logic as as per SR.
     CH20 # SR_EON_AB_139 # 14/09/2016 # Mahadev # Fetaching EON Appointment Comms realetd to 'EON Appointment'
     CH21 # SR_EON_Mobile_084 # 23/09/2016 # Dharmendra P # Added new enumeartion value for 'XA_ASSET_REGTYPE_NEW_*' tag
     CH22 # SR_EON_Mobile_085 # 05/10/2016 # Akshay Bairagi # Added condition to not send meter mode.
     CH23 # SR_EON_AB_166 # 14-10-2016 # Mahadev J # Added new method to get appointment for EON
     CH25 # SR_EON_AB_172 # 07/11/2016 #Aruna Manjari #  updating the sending logic to XA PHASE                    
     CH26 # SR_EON_AB_188 # 11/11/2016 # Mahadev J #  Change for synch call to OFSC
     CH27 # SR_EON_Mobile_100 # 19/11/2016 # Praveen G #  removed the logic for Planned Number of Registers                     
     CH28 # SR_EON_Mobile_106 # 07/12/2016 # Praveen G #  logic updated to consider if only one register found.
     CH29 # SR_EON_Mobile_106 # 07/12/2016 # Praveen G #  logic updated to consider if only one register found.
     CH30 # SR_EON_Mobile_111 # 17/12/2016 # Praveen G # added new field to OFSC.
     CH31 # SR_EON_Scheduling_052 # 04/01/2017 # Shruti Moghe # added logic to set External ID = Technician ID when EON Appointment.Technician IS NOT NULL
     CH32 # SR_OptiMUS_EON_047 # 24/03/2017 # Praveen G # added new field to find the bucket id based on ICE Maintenance Over-ride.
     CH33 # SR_EON_Jumbo_106 # 31/03/2016 # Mahadev J # Added field Booking_System_Name__c
     CH34 # REQUK0005751842 # 02/05/2017 # Praveen G # Added Booking system name condition.
     CH35 # REQUK0005760844 # 05/05/2017 # Praveen G # Updated the qurie with correct field.
     CH36 # SR_OptiMUS_EON_140 # 02/10/2017 # Praveen G # Added WAN Coverage details send to ORACLE.
     CH37 # SR_OptiMUS_EON_125 # 03/10/2017 # Praveen G # Added WAN Coverage fields in SOQL query.
     CH38 # SR_OptiMUS_EON_148 # 30/10/2017 # Mehboob Alam # Number of Phases needs to send for Every Appointment.
     CH39 # SR_EON_OFSC_017 # 20/12/2017 # Praveen G # Changes for Install SED flag.
     CH40 # CheckMark report # 07/02/2018 # Abhilash # Code improvement as per checkmark report
     CH41 # SR_OptiMUS_EON_240 # 02/05/2018 # Shruti Moghe # added variable and logic as per SR requirements
*/
global with sharing class EON_OFSC_Update_Appointment {
    public static string toaDateFormat = 'yyyy-MM-dd';
    public static EON_Appointment__c objAppt;// = new EON_Appointment__c();
    public static Oracle_Data_Tracker__c requestOut;
    public static EON_Appointment__c objAppt1; //CH08
    
    /**
        sendActivityToOFSC(String AppointmentId, string activityType, string eonTrackerId) - This method will create/update Activity in OFSC system.
        Appt -- EON Appointment Object
        lstAppointmentContacts -- list of "EON Appointment Contact" records
        lstAppointmentVuln -- list of "EON Appointment Vulnerability" records
        bookingSystem -- Name of System booking apppointment like 'EON' or 'JUMBO' or 'MUS'
    **/
    webservice static string sendActivityToOFSC(EON_Appointment__c Appt, list<EON_Appointment_Contact__c> lstAppointmentContacts, list<EON_Appointment_Vulnerability__c> lstAppointmentVuln, string bookingSystem){
        String result = '';
        requestOut = new Oracle_Data_Tracker__c();
        String strProperties = '';
         
        String requestXML = '';
        
        //Request Elements.
        EON_OFSC_Inbound_WS.UserElement userElement;
        EON_OFSC_Inbound_WS.HeadElement headerElement;
        
        //response Element
        EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response;
        
        //EON_Appointment__c Appt = objAppointment;
        
        EON_OFSC_Inbound_WS.DataElement dataElement = new EON_OFSC_Inbound_WS.DataElement();
        //CH01.start
        integer dur = 0;
        string subArea = '';
        //CH01.end
        try{
            //Request Elements.
            userElement = EON_OFSC_Helper.getInboundUserElement();//getUserElement();
            headerElement = EON_OFSC_Helper.getHeaderElement();//getHeaderElement();
            
            system.debug('$$$ Appointent Id: '+Appt.Id + ' APP Name: '+Appt.Name);
            system.debug('$$$ bookingSystem: '+bookingSystem);
            
            string appId = Appt.Id;
            requestOut.Command__c = EON_Utility.CMD_OFSC_UpdateActivity;//'Update Activity';
            requestOut.Direction__c = EON_Utility.DIRECTION_OUT;//'OUT';
            requestOut.h_Booking_System_Name__c = string.isNotBlank(bookingSystem)?(bookingSystem.length()<255?bookingSystem:bookingSystem.substring(0,254)):'';
            requestOut.EON_Appointment__c = appId;
            requestOut.Transaction_ID__c = Appt.Id;
            
            //CH12.start - Get SSC records
            string sscName = checkNullBlank(Appt.Requested_SSC__c);
            string mtrType = Appt.Planned_E_Meter_Type__c;
            string G_mtrType = Appt.Planned_G_Meter_Type__c;
            
            system.debug('@@@ sscName: '+sscName);
            system.debug('@@@ mtrType: '+mtrType);
            list<EON_SSC_Register__c> lstSSCReg = new list<EON_SSC_Register__c>();
            if(string.isNotBlank(sscName)){
              list<EON_SSC__c> lstSSC = new list<EON_SSC__c>([select id, name, Type__c, (select id, name, Register_ID__c, TPR__c from EON_SSC_Registers__r) from EON_SSC__c where name =: sscName]);
              system.debug('@@@ retrieved ssc records: '+lstSSC.size());
              
              /*
              if(!lstSSC.isEmpty() && lstSSC.size()==1){
                lstSSCReg.addall(lstSSC[0].EON_SSC_Registers__r);
              }
              else{Commented as part of the change CH29*/
              
                //system.debug('@@@ mtrType.containsignorecase(MS1): '+mtrType.containsignorecase('MS1'));
                if(string.isNotBlank(mtrType) && mtrType.containsignorecase('MS1')){ 
                        for(EON_SSC__c objSSC : lstSSC){
                          //system.debug('@@@ objSSC.Type__c: '+objSSC.Type__c);
                            if(objSSC.Type__c == 'Smart'){
                                lstSSCReg.addall(objSSC.EON_SSC_Registers__r);
                                break;
                            }
                        }
                    }
                    else {
                        for(EON_SSC__c objSSC : lstSSC){if(objSSC.Type__c == 'Classic'){lstSSCReg.addall(objSSC.EON_SSC_Registers__r); break;}
                        }
                    }
              //}
            }
            //CH12.end
            
            //get Contact and Media info from EON Appointment Contacts object
            list<EON_Appointment_Contact__c> lstContSend = new list<EON_Appointment_Contact__c>();
            list<EON_Appointment_Contact__c> lstCont = new list<EON_Appointment_Contact__c>([select id, name, Contact_Full_Name__c, Media_Detail__c, Contact_Type__c from EON_Appointment_Contact__c 
                                                                                                where EON_Appointment_ID__c =: appId and
                                                                                                //Contact_Type__r.Name ='A' CH35.OLD
                                                                                                Contact_Type__r.Code__c ='A' //CH35.New
                                                                                                and Media_Type__r.Code__c != 'E' 
                                                                                                order by name desc limit 4]);
            system.debug('@@@ Isis App Contacts: '+lstCont.size());
            
            list<EON_Contact_Type__c> lstConType = new list<EON_Contact_Type__c>([select id from EON_Contact_Type__c where Code__c = 'A']);
            string contactTypeId = (!lstConType.isEmpty()&&lstConType.size()>0?string.valueOf(lstConType[0].id):'');
            system.debug('@@@ contactTypeId: '+contactTypeId);
            list<EON_Media_Type__c> lstMedia = new list<EON_Media_Type__c>([select id from EON_Media_Type__c where Code__c ='E']);
            string mediaId = (!lstMedia.isEmpty()&&lstMedia.size()>0?string.valueOf(lstMedia[0].Id):'');
            system.debug('@@@ mediaId: '+mediaId);
            
            
            if(contactTypeId != '')
            for(EON_Appointment_Contact__c objCon: lstAppointmentContacts){ //Contacts received in the method parameter
                string contType = string.valueOf(objCon.Contact_Type__c);
                string medType = string.valueOf(objCon.Media_Type__c);
                system.debug('@@@ EON rec contType: '+contType);
                system.debug('@@@ EON rec medType: '+medType);
                //system.debug('@@@ string.isBlank(mediaId): '+string.isBlank(mediaId));
                //system.debug('@@@ check 2: '+(string.isNotBlank(medType) && mediaId!= '' &&!medType.Contains(mediaId)));
                if(string.isNotBlank(contType) && contType.contains(contactTypeId) && ((string.isNotBlank(medType) && mediaId!= '' &&!medType.Contains(mediaId)) || string.isBlank(medType))){lstContSend.add(objCon);}
            }
            system.debug('@@@ lstContSend size: '+lstContSend.size());
            if(lstContSend.size()<4 && lstCont.size()>0){
                for(EON_Appointment_Contact__c objCon : lstCont){ //contacts fetched from Isis
                    if(lstContSend.size()<4)
                        lstContSend.add(objCon); else break;
                }
            }
            system.debug('$$$ EON App Contacts final size: '+lstContSend.size());
            
            list<EON_Appointment_Vulnerability__c> lstVul = new list<EON_Appointment_Vulnerability__c>([select id, name, h_Vulnerability_Desc__c, Description__c from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c =: appId]);
            lstVul.addall(lstAppointmentVuln);
            set<string> vulCode = new set<string>();
            for(EON_Appointment_Vulnerability__c objVul : lstVul){
                vulCode.add(objVul.Description__c);
            }
            list<EON_Vulnerability_Code__c> lstVulCode = new list<EON_Vulnerability_Code__c>([select id, name from EON_Vulnerability_Code__c where id in: vulCode]);
            
            //get meter location
            list<EON_Electric_Meter_Location__c> lstEleMetLoc = new list<EON_Electric_Meter_Location__c>([select id, name, OFS_Enumeration__c from EON_Electric_Meter_Location__c where id=:Appt.E_Meter_Location__c]);
            string eleMeterLoc = (!lstEleMetLoc.isEmpty()&& lstEleMetLoc.size()>0)?string.valueOf(lstEleMetLoc[0].OFS_Enumeration__c):'';
            list<EON_Gas_Meter_Location__c> lstGasMetLoc = new list<EON_Gas_Meter_Location__c>([select id, name, OFS_Enumeration__c from EON_Gas_Meter_Location__c where id=:Appt.G_Meter_Location__c]);
            string gasMeterLoc = (!lstGasMetLoc.isEmpty()&&lstGasMetLoc.size()>0)?string.valueOf(lstGasMetLoc[0].OFS_Enumeration__c):'';
            
            
            //get Parking enumeration
            list<EON_Parking__c> lstPark = new list<EON_Parking__c>([select id, name, OFS_Enumeration__c from EON_Parking__c where id=: Appt.Parking_Type__c]);
            string parkingEnumeration = (!lstPark.isEmpty()&&lstPark.size()>0?string.valueOf(lstPark[0].OFS_Enumeration__c):'');
            system.debug('@@@ parkingEnumeration: '+parkingEnumeration);
            
            //Start from here
            //get bucket Id
            //CH04 //string postcode = string.isNotBlank(Appt.Post_Code__c)?Appt.Post_Code__c.substring(0,5):''; //stting.isNotBlank(Appt.Post_Code__c)
            string postcode = string.isNotBlank(Appt.Oracle_Postcode_Sector__c)?Appt.Oracle_Postcode_Sector__c:'';
            
            //string JobType = string.isNotBlank(Appt.h_Job_Type__c)?Appt.h_Job_Type__c:''; CH32.Old
            //CH32.Start 
            EON_Appointment__c appTemp = [select Job_Code__r.ICE_Maintenance_Over_ride__c, 
                                            booking_system_name__c //CH34
                                            from EON_Appointment__c where id =: appt.id];
            string JobType = (appTemp.Job_Code__r.ICE_Maintenance_Over_ride__c && 
                                                appTemp.booking_system_name__c == 'ICE' ) ? //CH34 
                                        'Maintenance' : 
                                    (string.isNotBlank(Appt.h_Job_Type__c)?Appt.h_Job_Type__c:'');
            //CH32.End 
            
            string bucketId = '';
            
            system.debug('@@@ postcode: '+postcode);
            list<EON_Post_Code__c> lstPC = new list<EON_Post_Code__c>([select id, name, h_sub_area_checkbox__c, Sub_Area_Name__r.Id, Sub_Area_Name__r.Oracle_Bucket_ID__c from EON_Post_Code__c where name =: postcode]);
            system.debug('@@@ lstPC: '+lstPC.size());
            for(EON_Post_Code__c objPC : lstPC){
                //system.debug('@@@ objPC.h_sub_area_checkbox__c: '+objPC.h_sub_area_checkbox__c);
                string check = string.isNotBlank(objPC.h_sub_area_checkbox__c)?objPC.h_sub_area_checkbox__c:'';
                //system.debug('@@@ check: '+check);
                //system.debug('@@@ JobType: '+JobType);
                //system.debug('@@@ check.containsIgnoreCase(JobType): '+check.containsIgnoreCase(JobType));
                if(string.isNotBlank(JobType) && string.isNotBlank(check) && check.containsIgnoreCase(JobType)){
                    bucketId = objPC.Sub_Area_Name__r.Oracle_Bucket_ID__c;
                    subArea = objPC.Sub_Area_Name__r.Id; //CH01
                    system.debug('$$$ subArea: '+subArea);
                }
            }
            if(Appt.Technician__c!=null) bucketId=Appt.Technician__c;//CH31
            //CH14.Start
            if(bucketId == '')
                bucketId = system.label.EON_Exception_BucketID;
            //CH14.End 
            //get Vulnerabilities
            string vulnerabilites = '';
            //for(EON_Appointment_Vulnerability__c objVul : lstVul ){
            for(EON_Vulnerability_Code__c objVulCode: lstVulCode){
                if(vulnerabilites =='')
                    vulnerabilites = objVulCode.name;
                else
                    vulnerabilites = vulnerabilites +', '+objVulCode.name;
                //vulnerabilites = vulnerabilites + objVul.h_Vulnerability_Desc__c+', ';
            }
            system.debug('@@@ XA_VULNERABLE Value: '+vulnerabilites);
            
            //CH08.Start
            list<EON_SSC__c> lstSSC = new list<EON_SSC__c>([select id, name, Number_of_Registers__c, Type__c from EON_SSC__c where id != '']); //CH40.Change
            map<string,List<EON_SSC__c>> mapSSC = new map<String,List<EON_SSC__c>>();
            for(EON_SSC__c objSSC : lstSSC){
                if(!mapSSC.containsKey(objSSC.Name))
                            mapSSC.put(objSSC.Name, new List<EON_SSC__c>());
                mapSSC.get(objSSC.Name).add(objSSC);
            }
            string plannedNoReg  = EON_OFSC_Update_Appointment.getPlannedReg(Appt, mapSSC);
            system.debug('@@@ plannedNoReg: '+plannedNoReg);
            //CH08.End
            
            //CH04.old.start
            //get Meter Type
            /*string eleMeterType, gasMeterType, meterReg, meterMode;
            eleMeterType = gasMeterType = meterReg = meterMode = '';
            for(EON_Appointment_Attribute__c objAtt : Appt.EON_Appointment_Attributes__r){
                if(objAtt.Job_Attribute__c == 'Electric Meter Type')
                    eleMeterType = objAtt.Value__c;
                else if(objAtt.Job_Attribute__c == 'Gas Meter Type')
                    gasMeterType = objAtt.Value__c;
                else if(objAtt.Job_Attribute__c == 'Meter Registers')
                    meterReg = objAtt.Value__c;
                else if(objAtt.Job_Attribute__c == 'Meter Mode')
                    meterMode = objAtt.Value__c;
            }
            
            //get Post Code Sector
            string sector ='';
            if(string.isNotBlank(Appt.Post_Code__c)){
                sector = Appt.Post_Code__c;
                sector = sector.right(2);
            }
            
            //Get address, Zip, Customer Name, Phone Number
            string add, zipCode, custName, phoneNo;
            add = zipCode = custName = phoneNo = '';
            if(string.isNotBlank(Appt.MPAN__c)){
                add = Appt.h_Metering_Point_Address_Full__c;
                zipCode = Appt.Post_Code__c;
                custName = Appt.Customer_Name__c;
                phoneNo = string.valueOf(Appt.Primary_Priority_Service_Phone_Number_1__c);
            }
            else{ 
                add = Appt.h_Gas_Metering_Point_Address_Full__c;
                zipCode = Appt.Metering_Point_Postcode__c;
                custName = Appt.Person_Name__c;
                phoneNo = string.valueOf(Appt.Contact_Number__c);
            }*/
            //CH04.old.start
            
            //get Duration
            string duration ='';
            if(Appt.Key_Collection_Required__c){
                dur = dur + 15;
            }
            
            //CH03.start
            //CH16.start
            if(Appt.Fuel_ID__c != null){
                if(Appt.Fuel_ID__r.MPAN__c == Appt.MPAN__c){
                    if(Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'RES')
                        dur = dur + Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c!=null?Appt.Job_code__r.h_Job_Attribute_Duration__c:0) + (Appt.Job_code__r.Duration__c!=null?Appt.Job_code__r.Duration__c:0));
                    else if(Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'SME')
                        dur = dur + Integer.valueOf(/*(Appt.Job_code__r.h_Job_Attribute_Duration__c!=null?Appt.Job_code__r.h_Job_Attribute_Duration__c:0) +*/ (Appt.Job_code__r.SME_Duration__c!=null?Appt.Job_code__r.SME_Duration__c:0));
                }
                else if(Appt.Fuel_ID__r.MPRN__c == Appt.MPRN__c){
                    if(Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'RES'){dur = dur + Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c!=null?Appt.Job_code__r.h_Job_Attribute_Duration__c:0) + (Appt.Job_code__r.Duration__c!=null?Appt.Job_code__r.Duration__c:0));}
                    else if(Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'SME'){dur = dur + Integer.valueOf(/*(Appt.Job_code__r.h_Job_Attribute_Duration__c!=null?Appt.Job_code__r.h_Job_Attribute_Duration__c:0) +*/ (Appt.Job_code__r.SME_Duration__c!=null?Appt.Job_code__r.SME_Duration__c:0));}
                }
            }else{
                dur = dur + Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c!=null?Appt.Job_code__r.h_Job_Attribute_Duration__c:0) + (Appt.Job_code__r.Duration__c!=null?Appt.Job_code__r.Duration__c:0));
            }
            //CH16.End
            //CH03.start
            
            /*if(Appt.Job_code__r.h_Job_Attribute_Duration__c!=null || Appt.Job_code__r.Duration__c!=null)
                dur = Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c!=null?Appt.Job_code__r.h_Job_Attribute_Duration__c:0) + (Appt.Job_code__r.Duration__c!=null?Appt.Job_code__r.Duration__c:0));
                //duration = string.valueOf(Appt.Job_code__r.h_Job_Attribute_Duration__c + Appt.Job_code__r.Duration__c);
            */
            
            if(dur!=0)
                duration = string.valueof(dur);
            system.debug('$$$ duration: '+duration);
            
            //------------- Create Data element ----------------------
            
            //Create appointment Element
            EON_OFSC_Inbound_WS.AppointmentElement appointmentElement = new EON_OFSC_Inbound_WS.AppointmentElement();
            appointmentElement.appt_number = !EON_Utility.validateRequired(Appt.Appointment_Key__c) ? Appt.Appointment_Key__c : Appt.Id; //Appt.Id; //CH26.Update
            appointmentElement.duration = duration; ///'60'
            appointmentElement.worktype_label = string.isNotBlank(Appt.Job_code__c)?Appt.Job_code__r.Name:'';
            system.debug('$$$ worktype_label: '+appointmentElement.worktype_label);
            appointmentElement.time_slot = checkNullBlank(Appt.Time_Slot__c); // like 12:00 - 14:00
            system.debug('$$$ time_slot: '+appointmentElement.time_slot);
            //CH04.New.start
            //CH06.New.start
            string startTime = checkNullBlank(Appt.Start_Time__c);
            appointmentElement.sla_window_start = (Appt.Appointment_Date__c!=null&& startTime!=''?string.valueof(Appt.Appointment_Date__c) +' '+Appt.Start_Time__c:''); 
            string endTime = '';
            try{
            if(Appt.Appointment_Date__c!=null&& startTime!='' && Appt.End_Time__c!='' && Appt.End_Time__c.length() >2 && startTime.length()>2){
                integer sHr = integer.valueOf(startTime.left(2));
                integer eHr = integer.valueOf(Appt.End_Time__c.left(2));
                integer i = sHr-eHr;
                date endDate = Appt.Appointment_Date__c;
                if(i>0) endDate=Appt.Appointment_Date__c.addDays(1);
                endTime = string.valueof(endDate) +' '+ Appt.End_Time__c;}} catch(exception e){system.debug('### end date conversion error: '+e.getMessage()+'\n'+e.getStackTraceString());}
            appointmentElement.sla_window_end = endTime; //convertDateToOFSCFormat(Appt.End_Time__c); 
            //CH06.New.End 
            appointmentElement.name = checkNullBlank(Appt.Caller_Name__c);
            appointmentElement.address = checkNullBlank(Appt.Oracle_Address__c);
            appointmentElement.city = checkNullBlank(Appt.Oracle_Town__c);
            appointmentElement.zip = checkNullBlank(Appt.Oracle_Postcode__c);
            //CH04.New.End
            
            //CH04.old.start 
            /*appointmentElement.name = custName;
            appointmentElement.phone = phoneNo;
            appointmentElement.address = add;
            appointmentElement.city = Appt.Post_Town__c;
            appointmentElement.zip = zipCode;
            */
            //CH04.old.End
            
            //Property Element
            List<EON_OFSC_Inbound_WS.PropertyElement> property_elements = new List<EON_OFSC_Inbound_WS.PropertyElement>(); 
            EON_OFSC_Inbound_WS.PropertyElement property_element = new EON_OFSC_Inbound_WS.PropertyElement(); 
            
            
            //SSC related information
            //CH12.start
            integer j =1;
            map<string,string> mapRegNameOFSVal = new map<string,string>{'EXPORT' =>'1','NORMAL'=>'2','LOW' => '3', 'EVENING WEEKEND'=>'4','RATE 1'=>'5','RATE 2'=>'6',
                                           'RATE 3'=>'7', 'RATE 4'=>'8', 'RATE 5'=>'9', 'RATE 6'=>'10', 'TOTAL'=>'11'};//TOTAL //CH13 //CH21
            System.debug('******lstSSCReg.size() '+ lstSSCReg.size());
            System.debug('******lstSSCReg '+ lstSSCReg);
            for(EON_SSC_Register__c objReg : lstSSCReg){
             
                  property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                  property_element.label = 'XA_ASSET_REGTYPE_NEW_'+j;
                  //CH12.old //property_element.value = checkNullBlank(objReg.Name);
                  property_element.value = mapRegNameOFSVal.containsKey(objReg.Name.toUpperCase())?mapRegNameOFSVal.get(objReg.Name.toUpperCase()):''; //CH13
                  system.debug('@@@ XA_ASSET_REGTYPE_NEW_'+j+': '+property_element.value);
                  property_elements.add(property_element);
                  
                  //if(string.isNotBlank(mtrType) && mtrType.containsignorecase('MS1')){ //CH18
                    property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                    property_element.label = 'XA_ASSET_E_REG_ID_NEW_'+j;
                    property_element.value = checkNullBlank(objReg.Register_ID__c);
                    system.debug('@@@ XA_ASSET_E_REG_ID_NEW_'+j+': '+property_element.value);
                    property_elements.add(property_element);
                    
                    property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                    property_element.label = 'XA_ASSET_E_TPR'+j+'_NEW';
                    property_element.value = checkNullBlank(objReg.TPR__c);
                    system.debug('@@@ XA_ASSET_E_TPR'+j+'_NEW: '+property_element.value);
                    property_elements.add(property_element);
                  //}            
                    j++;              
                    if(j>6) break;
            }
            //CH12.end  
            
            
            //CH36.Start
            /*
            EON_Appointment__c AppWAN = [Select id, CSP_Region__c, Comms_Hub_Variant__c,
                                         Connectivity_Likelihood__c, Auxiliary_Equipment_required__c,
                                         WAN_Additional_Information__c
                                         from EON_Appointment__c where id =:Appt.id];
            */                             
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_REGION';
            property_element.value = checkNullBlank(appt.CSP_Region__c);
            system.debug('@@@ XA_ASSET_H_REGION '+property_element.value);
            property_elements.add(property_element); 
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_REQ';
            property_element.value = checkNullBlank(appt.Comms_Hub_Variant__c);
            system.debug('@@@ XA_ASSET_H_REQ '+property_element.value);
            property_elements.add(property_element);  
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_CON_HOOD';
            property_element.value = checkNullBlank(appt.Connectivity_Likelihood__c);
            system.debug('@@@ XA_ASSET_H_CON_HOOD '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_AUX';
            property_element.value = checkNullBlank(appt.Auxiliary_Equipment_required__c);
            system.debug('@@@ XA_ASSET_H_AUX '+property_element.value);
            property_elements.add(property_element); 
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_ADD_INFO';
            property_element.value = checkNullBlank(appt.WAN_Additional_Information__c);
            system.debug('@@@ XA_ASSET_H_ADD_INFO '+property_element.value);
            property_elements.add(property_element);                                                                                                      
            
            //CH36.End
            
            
            //CH26.Start
            EON_Appointment__c apptRec = [select G_Meter_No_of_dials_digits__c from EON_Appointment__c where name =: appt.Name];
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_NO_DIG';
            property_element.value = (apptRec.G_Meter_No_of_dials_digits__c != null) ? (apptRec.G_Meter_No_of_dials_digits__c + '') : '';
            system.debug('@@@ XA_ASSET_G_NO_DIG Value: ' + property_element.value);
            property_elements.add(property_element);            
            //CH26.Start                      
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_APPT_NOTES';
            property_element.value = checkNullBlank(Appt.Notes__c);
            system.debug('@@@ XA_APPT_NOTES Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';            
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_Morrison_ID';
            property_element.value = Appt.Name;
            property_elements.add(property_element);
            strProperties += '\n' +property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_EON_ID';
            property_element.value = checkNullBlank(Appt.EON_Appointment_ID__c);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PARKING';
            //CH04 //property_element.value = Appt.Parking_Type__r.Name;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_PARKING')!=null?mapOFSCCodes.get('XA_PARKING').get(Appt.Parking_Type__r.Name):'');
            //property_element.value = (string.isNotBlank(Appt.Parking_Type__c)&& Appt.Parking_Type__r.OFS_Enumeration__c!=0.0?string.valueOf(Appt.Parking_Type__r.OFS_Enumeration__c):'');//CH06
            property_element.value = parkingEnumeration;//CH06
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PASSPHRASE';
            property_element.value = checkNullBlank(Appt.Access_Pass_Phrase__c);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_VULNERABLE';
            property_element.value = vulnerabilites;
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH04.new
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_APPOINTMENT_REASON';
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_APPOINTMENT_REASON')!=null?mapOFSCCodes.get('XA_APPOINTMENT_REASON').get(Appt.Appointment_reason_code__r.Reason_Description__c):'');
            property_element.value = (Appt.Appointment_reason_code__c!=null && Appt.Appointment_reason_code__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.Appointment_reason_code__r.OFS_Enumeration__c)):'');//CH06
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH04.old
            /* property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_LADDER';
            //property_element.value = string.valueOf(Appt.Ladder_Required_Indicator__c);
            property_element.value = (Appt.Assisted_Work_Reason_Code__c=='Ladder'?'Ladder':'');
            property_elements.add(property_element);*/
            
            //CH04.old
            /* property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSIST';
            // property_element.value = string.valueOf(Appt.Assisted_Work_Indicator__c);
            property_element.value = Appt.Assisted_Work_Reason_Code__c;
            property_elements.add(property_element);*/
             
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSIST_REASON';
            //CH06.old //property_element.value = Appt.Assisted_Work_Reason_Code__c;
            property_element.value = checkNullBlank(Appt.h_OFSC_Assisted_Work_Reason_Code__c);//CH06
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            //CH04.old //property_element.label = 'XA_Contact_Name';
            //CH04.old //property_element.value = Appt.Contact_Name__c;
            property_element.label = 'XA_CONTACT_NAME';
            //property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty()&&Appt.EON_Appointment_Contacts__r.size()>0)?Appt.EON_Appointment_Contacts__r[0].Contact_Full_Name__c:'');
            property_element.value = ((!lstContSend.isEmpty()&&lstContSend.size()>0)?checkNullBlank(lstContSend[0].Contact_Full_Name__c):'');
            system.debug('@@@ XA_CONTACT_NAME Value: '+property_element.value);
            property_elements.add(property_element);//lstCont
            strProperties += property_element + '\n';
            
            //CH04.New.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER';
            property_element.value = ((!lstContSend.isEmpty()&&lstContSend.size()>0)?checkNullBlank(lstContSend[0].Media_Detail__c):'');
            system.debug('@@@ XA_CONTACT_NUMBER Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME_2';
            property_element.value = ((!lstContSend.isEmpty()&&lstContSend.size()>1)?checkNullBlank(lstContSend[1].Contact_Full_Name__c):'');
            system.debug('@@@ XA_CONTACT_NAME_2 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER_2';
            property_element.value = ((!lstContSend.isEmpty()&&lstContSend.size()>1)?checkNullBlank(lstContSend[1].Media_Detail__c):'');
            system.debug('@@@ XA_CONTACT_NUMBER_2 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME_3';
            property_element.value = ((!lstContSend.isEmpty()&&lstContSend.size()>2)?checkNullBlank(lstContSend[2].Contact_Full_Name__c):'');
            system.debug('@@@ XA_CONTACT_NAME_3 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER_3';
            property_element.value = ((!lstContSend.isEmpty()&&lstContSend.size()>2)?checkNullBlank(lstContSend[2].Media_Detail__c):'');
            system.debug('@@@ XA_CONTACT_NUMBER_3 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME_4';
            property_element.value = ((!lstContSend.isEmpty()&&lstContSend.size()>3)?checkNullBlank(lstContSend[3].Contact_Full_Name__c):'');
            system.debug('@@@ XA_CONTACT_NAME_4 Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER_4';
            property_element.value = ((!lstContSend.isEmpty()&&lstContSend.size()>3)?checkNullBlank(lstContSend[3].Media_Detail__c):'');
            system.debug('@@@ XA_CONTACT_NUMBER_4 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH04.New.end
            
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_POSTCODE_SECTOR';
            //CH04.old //property_element.value = sector;
            property_element.value = checkNullBlank(Appt.Oracle_Postcode_Sector__c); //CH04.New
            system.debug('@@@ XA_POSTCODE_SECTOR Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH08.new
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_APPT_NOTES';
            property_element.value = checkNullBlank(Appt.Notes__c);
            system.debug('@@@ XA_APPT_NOTES Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ADDITIONAL_INFO';
            property_element.value = checkNullBlank(Appt.Additional_Information__c);
            system.debug('@@@ XA_ADDITIONAL_INFO Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_MPAN_NUMBER';
            property_element.value = checkNullBlank(Appt.MPAN__c);
            system.debug('@@@ XA_MPAN_NUMBER Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_MPRN_NUMBER';
            property_element.value = checkNullBlank(Appt.MPRN__c);
            system.debug('@@@ XA_MPRN_NUMBER Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PRESSURE';
            //CH04.old //property_element.value = Appt.Metering_Pressure__c;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_PRESSURE')!=null?mapOFSCCodes.get('XA_PRESSURE').get(Appt.Metering_Pressure__c):'');//CH04
            property_element.value = checkNullBlank(Appt.h_OFSC_Metering_Pressure__c); //CH06
            system.debug('@@@ XA_PRESSURE Value: '+property_element.value);
            property_elements.add(property_element); 
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PHASE';
            //CH04.old 
            //CH38.Start
            //if(Appt.Current_Phase__c!=null && Appt.Current_Phase__c!= '' && Appt.Current_Phase__c=='3Ph') property_element.value = '2';//Ch25.Stop
            //else
            //CH38.End
            property_element.value = checkNullBlank(Appt.h_OFSC_Number_of_Phases__c);//CH06
            system.debug('@@@ XA_PHASE Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //Electric Meter specific info
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_MSN';
            property_element.value = checkNullBlank(Appt.E_Meter_Serial_Number__c);
            system.debug('@@@ XA_ASSET_E_MSN Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_TYPE';
            //CH04 //property_element.value = Appt.E_Meter_Type__c;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_E_TYPE')!=null?mapOFSCCodes.get('XA_ASSET_E_TYPE').get(Appt.E_Meter_Type__c):'');
            property_element.value = checkNullBlank(string.valueOf(Appt.E_Meter_Type__r.OFS_Enumeration__c)); //CH06    
            system.debug('@@@ XA_ASSET_E_TYPE Value: '+property_element.value);       
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_LOCATION';
            //CH04 //property_element.value = Appt.E_Meter_Location__r.Name;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_E_LOCATION')!=null?mapOFSCCodes.get('XA_ASSET_E_LOCATION').get(Appt.E_Meter_Location__r.Name):'');
            property_element.value = checkNullBlank(eleMeterLoc);//(Appt.E_Meter_Location__c!=null && Appt.E_Meter_Location__c!='' && Appt.E_Meter_Location__r.OFS_Enumeration__c!=0.0?string.valueOf(Appt.E_Meter_Location__r.OFS_Enumeration__c):'');//CH06
            system.debug('@@@ XA_ASSET_E_LOCATION Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_MANFCT';
            property_element.value = checkNullBlank(Appt.E_Meter_Make__c);
            system.debug('@@@ XA_ASSET_E_MANFCT Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_VERSION';
            property_element.value = checkNullBlank(Appt.E_Meter_Model__c);
            system.debug('@@@ XA_ASSET_E_VERSION Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_1_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH08.old
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_NAME';
            //CH04 //property_element.value = Appt.E_Meter_Register_1_Name__c;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_E_REG_NAME')!=null?mapOFSCCodes.get('XA_ASSET_E_REG_NAME').get(Appt.E_Meter_Register_1_Name__c):'');
            property_element.value = (Appt.E_Meter_Register_1_Name__c!=null && Appt.E_Meter_Register_1_Name__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.E_Meter_Register_1_Name__r.OFS_Enumeration__c)):'');//CH06
            system.debug('@@@ XA_ASSET_E_REG_NAME Value: '+property_element.value);
            property_elements.add(property_element);
            */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID2';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_2_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID2 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH08.old
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_NAME2';
            //CH04 //property_element.value = Appt.E_Meter_Register_2_Name__c;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_E_REG_NAME2')!=null?mapOFSCCodes.get('XA_ASSET_E_REG_NAME2').get(Appt.E_Meter_Register_2_Name__c):'');
            property_element.value = (Appt.E_Meter_Register_2_Name__c!=null && Appt.E_Meter_Register_2_Name__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.E_Meter_Register_2_Name__r.OFS_Enumeration__c)):'');//CH06
            system.debug('@@@ XA_ASSET_E_REG_NAME2 Value: '+property_element.value);
            property_elements.add(property_element);
            */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID3';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_3_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID3 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH08.old
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_NAME3';
            //CH04 //property_element.value = Appt.E_Meter_Register_3_Name__c;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_E_REG_NAME3')!=null?mapOFSCCodes.get('XA_ASSET_E_REG_NAME3').get(Appt.E_Meter_Register_3_Name__c):'');
            property_element.value = (Appt.E_Meter_Register_3_Name__c!=null && Appt.E_Meter_Register_3_Name__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.E_Meter_Register_3_Name__r.OFS_Enumeration__c)):'');//CH06
            system.debug('@@@ XA_ASSET_E_REG_NAME3 Value: '+property_element.value);
            property_elements.add(property_element);
            */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID4';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_4_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID4 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH08.old
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_NAME4';
            //CH04 //property_element.value = Appt.E_Meter_Register_4_Name__c;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_E_REG_NAME4')!=null?mapOFSCCodes.get('XA_ASSET_E_REG_NAME4').get(Appt.E_Meter_Register_4_Name__c):'');
            property_element.value = (Appt.E_Meter_Register_4_Name__c!=null && Appt.E_Meter_Register_4_Name__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.E_Meter_Register_4_Name__r.OFS_Enumeration__c)):'');//CH06
            system.debug('@@@ XA_ASSET_E_REG_NAME4 Value: '+property_element.value);
            property_elements.add(property_element);
            */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID5';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_5_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID5 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH08.old
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_NAME5';
            //CH04 //property_element.value = Appt.E_Meter_Register_5_Name__c;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_E_REG_NAME5')!=null?mapOFSCCodes.get('XA_ASSET_E_REG_NAME5').get(Appt.E_Meter_Register_5_Name__c):'');
            property_element.value = (Appt.E_Meter_Register_5_Name__c!=null && Appt.E_Meter_Register_5_Name__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.E_Meter_Register_5_Name__r.OFS_Enumeration__c)):'');//CH06
            system.debug('@@@ XA_ASSET_E_REG_NAME5 Value: '+property_element.value);
            property_elements.add(property_element);
            */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID6';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_6_ID__c);
            system.debug('@@@ XA_ASSET_E_REG_ID6 Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH08.old
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_NAME6';
            //CH04 //property_element.value = Appt.E_Meter_Register_6_Name__c;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_E_REG_NAME6')!=null?mapOFSCCodes.get('XA_ASSET_E_REG_NAME6').get(Appt.E_Meter_Register_6_Name__c):'');
            property_element.value = (Appt.E_Meter_Register_6_Name__c!=null && Appt.E_Meter_Register_6_Name__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.E_Meter_Register_6_Name__r.OFS_Enumeration__c)):'');//CH06
            system.debug('@@@ XA_ASSET_E_REG_NAME6 Value: '+property_element.value);
            property_elements.add(property_element);
            */ 
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_CERTDT';
            property_element.value = convertDateToOFSCFormat(Appt.Certification_Date__c);
            system.debug('@@@ XA_ASSET_E_CERTDT Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH08.new.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_CERTEXPDT';
            property_element.value = convertDateToOFSCFormat(Appt.Certification_Expiry_Date__c);
            system.debug('@@@ XA_ASSET_E_CERTEXPDT Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            //CH08.new.end
            
            //Gas meter information
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_MSN';
            property_element.value = checkNullBlank(Appt.G_Meter_Serial_Number__c);
            system.debug('@@@ XA_ASSET_G_MSN Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            //CH08.old
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GR_MSN';
            property_element.value = checkNullBlank(Appt.Gas_Regulator_Serial_Number__c);
            system.debug('@@@ XA_ASSET_GR_MSN Value: '+property_element.value);
            property_elements.add(property_element);
            */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_TYPE';
            //CH04 //property_element.value = Appt.G_Meter_Type__c;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_G_TYPE')!=null?mapOFSCCodes.get('XA_ASSET_G_TYPE').get(Appt.G_Meter_Type__c):'');
            //CH15.old //property_element.value = checkNullBlank(string.valueOf(Appt.G_Meter_Type__r.OFS_Enumeration__c));//CH06
            property_element.value = (Appt.G_Meter_Mechanism__c!=null && Appt.G_Meter_Mechanism__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.G_Meter_Mechanism__r.OFS_Enumeration__c)):'');//CH15
            system.debug('@@@ XA_ASSET_G_TYPE Value: '+property_element.value);
            property_elements.add(property_element);
            strProperties += property_element + '\n';
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_LOCATION';
            //CH06.old //property_element.value = Appt.G_Meter_Location__r.Name;
            property_element.value = checkNullBlank(gasMeterLoc);//CH06
            system.debug('@@@ XA_ASSET_G_LOCATION Value: '+property_element.value);
            property_elements.add(property_element);
            
            Map<String, String> GMeterMakeEnum = new Map<String, String>{'UNK'=>'1', //CH19
                                                'ACT'=>'7',
                                                'AGS'=>'6',
                                                'AM'=>'8',
                                                'AMC'=>'9',
                                                'AS'=>'10',
                                                'BGL'=>'11',
                                                'BGW'=>'12',
                                                'BMM'=>'82',
                                                'BRA'=>'13',
                                                'BW'=>'14',
                                                'CHE'=>'16',
                                                'COM'=>'83',
                                                'CVM'=>'18',
                                                'CMN'=>'3',
                                                'DAN'=>'98',
                                                'DEL'=>'19',
                                                'DG'=>'84',
                                                'DGM'=>'85',
                                                'DR'=>'20',
                                                'ELG'=>'96',
                                                'EMI'=>'22',
                                                'EUR'=>'23',
                                                'EXI '=>'94',
                                                'FLA'=>'24',
                                                'FLN'=>'99',
                                                'GG'=>'25',
                                                'GL'=>'27',
                                                'GM'=>'26',
                                                'GMC'=>'29',
                                                'GW'=>'30',
                                                'HIL'=>'31',
                                                'HOC'=>'32',
                                                'IGA'=>'33',
                                                'IGT'=>'34',
                                                'IMA'=>'35',
                                                'INS'=>'36',
                                                'INV'=>'80',
                                                'ITR'=>'4',
                                                'JEA'=>'39',
                                                'JR'=>'40',
                                                'KRO'=>'41',
                                                'LG '=>'42',
                                                'LPG'=>'43',
                                                'MAG'=>'44',
                                                'MET'=>'45',
                                                'ML'=>'46',
                                                'MM'=>'47',
                                                'MTK'=>'88',
                                                'MTL'=>'48',
                                                'MTN'=>'89',
                                                'MTX'=>'100',
                                                'NFC'=>'49',
                                                'NP'=>'101',
                                                'OMN'=>'92',
                                                'ONS'=>'5',
                                                'ORM'=>'51',
                                                'OT'=>'81',
                                                'PC'=>'52',
                                                'PCC'=>'53',
                                                'PCU'=>'54',
                                                'PE'=>'55',
                                                'PH'=>'56',
                                                'PRI '=>'2',
                                                'RCK'=>'57',
                                                'RMG'=>'58',
                                                'ROM'=>'59',
                                                'ROO'=>'60',
                                                'RPB'=>'61',
                                                'SAR'=>'97',
                                                'SCH'=>'62',
                                                'SEN'=>'90',
                                                'SGR'=>'63',
                                                'SIE'=>'64',
                                                'SM'=>'65',
                                                'SOL'=>'91',
                                                'SP'=>'66',
                                                'STH'=>'67',
                                                'TAC'=>'87',
                                                'TB'=>'68',
                                                'TEC'=>'93',
                                                'TG'=>'69',
                                                'UGI'=>'70',
                                                'UWL'=>'95',
                                                'VAL'=>'71',
                                                'VAN'=>'72',
                                                'WBC'=>'74',
                                                'WCH'=>'75',
                                                'WLK'=>'76',
                                                'WLN'=>'77',
                                                'WLY'=>'78',
                                                'AIU'=>'102',
                                                'EDM'=>'103',
                                                'ELM'=>'104',
                                                'FMG'=>'105',
                                                'GFO'=>'106',
                                                'NGM'=>'107',
                                                'SCM'=>'108',
                                                'SCK'=>'109',
                                                'SIC'=>'110',
                                                'VMT'=>'111'};
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            //property_element.label = 'XA_ASSET_G_MANFCT'; //CH19
            property_element.label = 'XA_ASSET_G_MAKE';  //CH19
            if(Appt.G_Meter_Make__c != null && Appt.G_Meter_Make__c != '')  //CH19     
                property_element.value = GMeterMakeEnum.get(Appt.G_Meter_Make__c); //CH19
            property_elements.add(property_element);    
            system.debug('@@@ XA_ASSET_G_MAKE Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_VERSION';
            property_element.value = checkNullBlank(Appt.G_Meter_Model__c);
            system.debug('@@@ XA_ASSET_G_VERSION Value: '+property_element.value);
            property_elements.add(property_element);
             
            //CH08.old
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_METER';
            //CH04 //property_element.value = string.valueof(Appt.E_Check_Meter_Installed__c);
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_EC_METER')!=null?mapOFSCCodes.get('XA_ASSET_EC_METER').get(string.valueof(Appt.E_Check_Meter_Installed__c)):'');
            property_element.value = checkNullBlank(Appt.h_OFSC_E_Check_Meter_Installed__c); //CH06
            system.debug('@@@ XA_ASSET_EC_METER Value: '+property_element.value);
            property_elements.add(property_element);
            */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_MSN';
            property_element.value = checkNullBlank(Appt.E_Check_Meter_Serial_Number__c);
            system.debug('@@@ XA_ASSET_EC_MSN Value: '+property_element.value);
            property_elements.add(property_element);
            
            //CH08.new.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_MANFCT';
            property_element.value = checkNullBlank(Appt.E_Check_Meter_Make__c);
            system.debug('@@@ XA_ASSET_EC_MANFCT Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_VERSION';
            property_element.value = checkNullBlank(Appt.E_Check_Meter_Model__c);
            system.debug('@@@ XA_ASSET_EC_VERSION Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_LOCATION';
            property_element.value = (Appt.E_Check_Meter_Location__c!=null && Appt.E_Check_Meter_Location__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.E_Check_Meter_Location__r.OFS_Enumeration__c)):''); 
            system.debug('@@@ XA_ASSET_EC_LOCATION Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_MANFCT';
            property_element.value = checkNullBlank(Appt.G_Check_Meter_Make__c);
            system.debug('@@@ XA_ASSET_GC_MANFCT Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_VERSION';
            property_element.value = checkNullBlank(Appt.G_Check_Meter_Model__c);
            system.debug('@@@ XA_ASSET_GC_VERSION Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_LOCATION';
            property_element.value = (Appt.G_Check_Meter_Location__c!=null && Appt.G_Check_Meter_Location__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.G_Check_Meter_Location__r.OFS_Enumeration__c)):''); 
            system.debug('@@@ XA_ASSET_GC_LOCATION Value: '+property_element.value);
            property_elements.add(property_element);
            //CH08.new.end
             
            //cH08.old
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_METER';
            //CH04 //property_element.value = string.valueof(Appt.G_Check_Meter_Installed__c);
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_GC_METER')!=null?mapOFSCCodes.get('XA_ASSET_GC_METER').get(string.valueof(Appt.G_Check_Meter_Installed__c)):'');
            property_element.value = checkNullBlank(Appt.h_OFSC_G_Check_Meter_Installed__c);//CH06
            system.debug('@@@ XA_ASSET_GC_METER Value: '+property_element.value);
            property_elements.add(property_element);
            */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_MSN';
            property_element.value = checkNullBlank(Appt.G_Check_Meter_Serial_Number__c);
            system.debug('@@@ XA_ASSET_GC_MSN Value: '+property_element.value);
            property_elements.add(property_element);
            
            //Asset Details - Comms Hub
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_MSN';
            property_element.value = checkNullBlank(Appt.Expected_Comms_Hub_Serial_Number__c);
            system.debug('@@@ XA_ASSET_H_MSN Value: '+property_element.value);
            property_elements.add(property_element);
            
            // Asset Details - IHD/SED
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_I_MSN';
            property_element.value = checkNullBlank(Appt.Expected_IHD_Serial_Number__c);
            system.debug('@@@ XA_ASSET_I_MSN Value: '+property_element.value);
            property_elements.add(property_element);
            
            //New Meter details
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ELEC_METER_TYPE';
            //CH04.old //property_element.value = eleMeterType;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ELEC_METER_TYPE')!=null?mapOFSCCodes.get('XA_ELEC_METER_TYPE').get(Appt.Planned_E_Meter_Type__c):''); //CH04
            property_element.value = checkNullBlank(Appt.h_OFSC_Planned_E_Meter_Type__c);//CH06
            system.debug('@@@ XA_ELEC_METER_TYPE Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_GAS_METER_TYPE';
            //CH04.old //property_element.value = gasMeterType;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_GAS_METER_TYPE')!=null?mapOFSCCodes.get('XA_GAS_METER_TYPE').get(Appt.Planned_G_Meter_Type__c):'');//CH04
            property_element.value = checkNullBlank(Appt.h_OFSC_Planned_G_Meter_Type__c);//CH06
            system.debug('@@@ XA_GAS_METER_TYPE Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_TARIFF_NEW';
            //CH04.old //property_element.value = meterReg;
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_ASSET_E_TARIFF_NEW')!=null?mapOFSCCodes.get('XA_ASSET_E_TARIFF_NEW').get(Appt.Planned_Meter_Registers__c):''); //CH04
            property_element.value = checkNullBlank(Appt.h_OFSC_Planned_Meter_Registers__c);//CH06
            system.debug('@@@ XA_ASSET_E_TARIFF_NEW Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_SSC_NEW';
            property_element.value = checkNullBlank(Appt.Requested_SSC__c);//CH07.old //CH09.new
            //property_element.value = checkNullBlank(Appt.Requested_SSC__r.Name);//CH07.New//CH09.old
            system.debug('@@@ XA_ASSET_E_SSC_NEW Value: '+property_element.value);
            property_elements.add(property_element);
            
            //CH08.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_NOREG_NEW';
            property_element.value = checkNullBlank(plannedNoReg);
            //property_element.value = checkNullBlank(Appt.Planned_Number_of_Registers__c);//CH09
            system.debug('@@@ XA_ASSET_E_NOREG_NEW Value: '+property_element.value);
            property_elements.add(property_element);
            //CH08.end
            
            //CH04.New.start
            //CH22.Start
            if(!(mtrType == 'MCL' || mtrType == 'KEY' || G_mtrType == 'MCL' || G_mtrType == 'PP')){
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_E_MODE_NEW';
                property_element.value = checkNullBlank(Appt.h_OFSC_Planned_Meter_Mode__c);//CH06
                system.debug('@@@ XA_ASSET_E_MODE_NEW Value: '+property_element.value);
                property_elements.add(property_element);
            }
            //CH22.End
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_GAS_BIND';
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_GAS_BIND')!=null?mapOFSCCodes.get('XA_GAS_BIND').get(string.valueOf(Appt.Gas_bind_performed_flag__c)):'');
            property_element.value = checkNullBlank(Appt.h_OFSC_Gas_bind_performed_flag__c);//CH06
            system.debug('@@@ XA_GAS_BIND Value: '+property_element.value);
            property_elements.add(property_element);
            
            //CH39.Start
            String installSED = '';
            if(bookingSystem.containsIgnoreCase('ICE') && appt.Job_code__r.Install_SED__c){  //CH41          
                if(Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'SME')
                    installSED = '2';
                else if(Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == 'RES')     
                    installSED = '1';
                else if(Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == null || 
                        Appt.Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c == '') 
                    installSED = '1';
            }else
                installSED = checkNullBlank(Appt.h_OFSC_Install_SED_flag__c);
            
            if(installSED == '2' && appt.Job_code__r.Install_SED__c){//CH41
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_I_SUPP';             
                property_element.value = '2';
                property_elements.add(property_element);
                 property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_I_REASON';             
                property_element.value = '2';
                property_elements.add(property_element);
            }
            //CH39.End              
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_INSTALL_SED';
            //CH06.old //property_element.value = (mapOFSCCodes.get('XA_INSTALL_SED')!=null?mapOFSCCodes.get('XA_INSTALL_SED').get(string.valueOf(Appt.Install_SED_flag__c)):'');
            //property_element.value = checkNullBlank(Appt.h_OFSC_Install_SED_flag__c);//CH06 //CH39.Commented
            property_element.value = checkNullBlank(installSED);//CH39
            system.debug('@@@ XA_INSTALL_SED Value: '+property_element.value);
            property_elements.add(property_element);
            //CH04.New.end
            
            //CH04.Old.start
            /*property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET';
            property_element.value = meterMode;
            property_elements.add(property_element);*/
            //CH04.Old.end
            
            //Key collection
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY';
            //CH12.old //property_element.value = checkNullBlank(string.valueof(Appt.Key_Collection_Required__c));
            //CH12.start
            string keyCol = '';
            if(Appt.Key_Collection_Required__c!=null)
              keyCol = Appt.Key_Collection_Required__c?'Yes':'No';
            property_element.value = keyCol;
            //CH12.end
            system.debug('@@@ XA_KEY Value: '+property_element.value);
            property_elements.add(property_element);
            
            /**
            //SSC related information
            //CH12.start
            integer j =1;
            map<string,string> mapRegNameOFSVal = new map<string,string>{'EXPORT' =>'1','NORMAL'=>'2','LOW' => '3', 'EVENING WEEKEND'=>'4','RATE 1'=>'5','RATE 2'=>'6',
                                           'RATE 3'=>'7', 'RATE 4'=>'8', 'RATE 5'=>'9', 'RATE 6'=>'10'};//TOTAL //CH13
            for(EON_SSC_Register__c objReg : lstSSCReg){
             
                  property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                  property_element.label = 'XA_ASSET_REGTYPE_NEW_'+j;
                  //CH12.old //property_element.value = checkNullBlank(objReg.Name);
                  property_element.value = mapRegNameOFSVal.containsKey(objReg.Name.toUpperCase())?mapRegNameOFSVal.get(objReg.Name.toUpperCase()):''; //CH13
                  system.debug('@@@ XA_ASSET_REGTYPE_NEW_'+j+': '+property_element.value);
                  property_elements.add(property_element);
                  
                  //if(string.isNotBlank(mtrType) && mtrType.containsignorecase('MS1')){ //CH18
                    property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                    property_element.label = 'XA_ASSET_E_REG_ID_NEW_'+j;
                    property_element.value = checkNullBlank(objReg.Register_ID__c);
                    system.debug('@@@ XA_ASSET_E_REG_ID_NEW_'+j+': '+property_element.value);
                    property_elements.add(property_element);
                    
                    property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                    property_element.label = 'XA_ASSET_E_TPR'+j+'_NEW';
                    property_element.value = checkNullBlank(objReg.TPR__c);
                    system.debug('@@@ XA_ASSET_E_TPR'+j+'_NEW: '+property_element.value);
                    property_elements.add(property_element);
                  //}            
                    j++;              
                    if(j>6) break;
            }
            //CH12.end
            **/
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_PERSON';
            property_element.value = checkNullBlank(Appt.Key_Person_Name__c);
            system.debug('@@@ XA_KEY_PERSON Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_BUILD_NAME';
            property_element.value = checkNullBlank(Appt.Key_Building_Name__c);
            system.debug('@@@ XA_KEY_BUILD_NAME Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_BUILD_NO';
            property_element.value = checkNullBlank(Appt.Key_Building_Number__c);
            system.debug('@@@ XA_KEY_BUILD_NO Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_SUB_BUILD';
            property_element.value = checkNullBlank(Appt.Key_Sub_Building_Name__c);
            system.debug('@@@ XA_KEY_SUB_BUILD Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_THOROFARE';
            property_element.value = checkNullBlank(Appt.Key_Thorofare__c);
            system.debug('@@@ XA_KEY_THOROFARE Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_D_THOROFARE';
            property_element.value = checkNullBlank(Appt.Key_Dependant_Thorofare__c);
            system.debug('@@@ XA_KEY_D_THOROFARE Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_D_LOC';
            property_element.value = checkNullBlank(Appt.Key_Dependant_Locality__c);
            system.debug('@@@ XA_KEY_D_LOC Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_TOWN';
            property_element.value = checkNullBlank(Appt.Key_Town__c);
            system.debug('@@@ XA_KEY_TOWN Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_COUNTY';
            property_element.value = checkNullBlank(Appt.Key_County__c);
            system.debug('@@@ XA_KEY_COUNTY Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_POSTCODE';
            property_element.value = checkNullBlank(Appt.Key_Post_Code__c);
            system.debug('@@@ XA_KEY_POSTCODE Value: '+property_element.value);
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_CONTACT_NO';
            property_element.value = checkNullBlank(string.valueof(Appt.Key_Contact_Number__c));//CH17
            system.debug('@@@ XA_KEY_CONTACT_NO Value: '+property_element.value);
            property_elements.add(property_element);
            
            //CH11.start
            if(bookingSystem.containsIgnoreCase('mus')  && Appt.Specific_Time_flag__c){property_element = new EON_OFSC_Inbound_WS.PropertyElement(); property_element.label = 'XA_SPECIAL_CUSTOMER'; property_element.value = '1'; system.debug('@@@ XA_SPECIAL_CUSTOMER Value: '+property_element.value); property_elements.add(property_element);}
            //CH11.end
                        
            EON_OFSC_Inbound_WS.PropertiesArray propertiesArray = new EON_OFSC_Inbound_WS.PropertiesArray();
            propertiesArray.property = property_elements;
            
            appointmentElement.properties = propertiesArray;
            
            //Command element
            system.debug('$$$ bucket: '+bucketId);
            EON_OFSC_Inbound_WS.CommandElement commandElement = new EON_OFSC_Inbound_WS.CommandElement();
            //CH04.old //commandElement.date_x = convertDateToOFSCFormat(Date.today());
            commandElement.date_x = convertDateToOFSCFormat(Appt.Appointment_Date__c); //CH04.New
            commandElement.type_x = 'update_activity';
            commandElement.external_id = bucketId;
            commandElement.appointment = appointmentElement;
            
            List<EON_OFSC_Inbound_WS.CommandElement> commandElements = new List<EON_OFSC_Inbound_WS.CommandElement>();
            commandElements.add(commandElement);
            
            EON_OFSC_Inbound_WS.CommandsArray commandArray = new EON_OFSC_Inbound_WS.CommandsArray();
            commandArray.command = commandElements;
                        
            dataElement.commands = commandArray;
            
            //calling web service
            EON_OFSC_Inbound_WS.InboundInterfacePort request = new EON_OFSC_Inbound_WS.InboundInterfacePort();
            response = request.inbound_interface(userElement, headerElement, dataElement);
            System.debug('**** request: ' + userElement +'\n' +headerElement +'\n' +dataElement);
            System.debug('**** response: ' + response);
            
            String strResultCode = '';
            boolean iserror = false;
            if(response != null && response.data != null && response.data.commands != null && response.data.commands.command != null && response.data.commands.command.size() > 0 ){
                //system.debug('@@@ command[0]: '+response.data.commands.command[0]);
                //system.debug('@@@ appointment: '+response.data.commands.command[0].appointment);
                //system.debug('@@@ report: '+response.data.commands.command[0].appointment.report);
                //system.debug('@@@ message: '+response.data.commands.command[0].appointment.report.message[0]);
                //system.debug('@@@ error: '+response.data.commands.command[0].appointment.report.message[0].code);
                strResultCode = response.data.commands.command[0].appointment.report.message[0].code;
                integer messageSize = response.data.commands.command[0].appointment.report.message.size();
                string tempError = '';
                for(integer i=0;i<messageSize;i++){
                    system.debug('$$$ res code: '+response.data.commands.command[0].appointment.report.message[i].code);
                    system.debug('$$$ res result: '+response.data.commands.command[0].appointment.report.message[i].result);
                    system.debug('$$$ res desc: '+response.data.commands.command[0].appointment.report.message[i].description);
                    if(response.data.commands.command[0].appointment.report.message[i].code == '0'){strResultCode = '0';} else{tempError = response.data.commands.command[0].appointment.report.message[i].code;}
                    if(response.data.commands.command[0].appointment.report.message[i].result == 'error'){iserror = true; strResultCode = tempError;}
                }
            }
            system.debug('$$$ final response code: ' + strResultCode);
            //if(Test.isRunningTest()){
            //EON_OFSC_Response_Code__c responseCode = new  EON_OFSC_Response_Code__c(name = strResultCode, API__c ='Inbound',Error_Warning_Success__c='warning'); insert responseCode;}
              
            List<EON_OFSC_Response_Code__c> responseCode = [select id, Name, Error_Warning_Success__c from EON_OFSC_Response_Code__c where name =: strResultCode and API__c ='Inbound'];
                 
            if(!responseCode.isEmpty())
                requestOut.Error_Code__c = responseCode[0].id;
            
            if(!responseCode.isEmpty()){
                if(responseCode[0].Name == '0' || responseCode[0].Error_Warning_Success__c.containsignorecase('warning'))
                    requestOut.Status__c = EON_Utility.RESULT_PASS;//'PASS';
                if(responseCode[0].Error_Warning_Success__c.containsignorecase('error') || iserror)requestOut.Status__c = EON_Utility.RESULT_FAIL;//'FAIL';
            }
            else if(strResultCode!='0'){requestOut.Status__c = EON_Utility.RESULT_FAIL;}//'FAIL';
            else if(strResultCode=='0'){requestOut.Status__c = EON_Utility.RESULT_PASS;}//'PASS';
                
            String toaResponse = '' + response;
            if(toaResponse.length() > 131072) requestOut.Response_Data__c = toaResponse.substring(0, 131072);
            else
                requestOut.Response_Data__c = '' + toaResponse;
            system.debug('@@@ OFSC responseCode: '+responseCode);
            system.debug('$$$ request Status: '+requestOut.Status__c);
            
            //if the response got error then revert team's TOA field as it was before.
            //!responseCode.isEmpty() && responseCode[0].Error_Warning_Success__c != 'error' || !iserror){
            if(requestOut.Status__c == EON_Utility.RESULT_PASS){result = 'Job sent to OFSC successfully';} else{result = 'Appointment can\'t be updated, Please contact your administrator.';}//'No Response Code found or error found in the Response';
            
        }catch(Exception ex){
            String errMsg = '';
            errMsg = ex.getMessage() + ex.getStackTraceString() + '\n' + response;
            system.debug('### exc: '+ex.getMessage() + '\n' + ex.getStackTraceString() );
            if(errMsg.length() > 131072) requestOut.Response_Data__c = errMsg.substring(0, 131072);
            else
            requestOut.Response_Data__c = errMsg;
            requestOut.Status__c = EON_Utility.RESULT_FAIL;//'FAIL';
            //result = 'Exception occurred Please see Error : ' + ex.getMessage();
            result = 'Appointment can\'t be updated, Please contact your administrator.';          
        }
        
        try{
            requestXML = '' + userElement +'\n' +headerElement +'\n' +dataElement;  
            requestOut.Request_Data__c = EON_Utility.validateStringLength(requestXML);
            insert requestOut;  
            
            //just to track the full request as an attachment for TOARequestOut.
            EON_Utility.createAttachment(requestOut.id, requestXML, requestOut.id);
            
            //CH01.start
            //try{
                /*
                if(requestOut.Status__c == 'PASS'){
                    Appt.Duration__c = dur;
                    if(subArea!='')Appt.SubArea__c = subArea;
                    if(!Appt.Sent_to_Oracle_Update__c)Appt.Sent_to_Oracle_Update__c = true; //CH05
                    update Appt;   
                }
                //CH05.start
                if(requestOut.Status__c == 'FAIL' && Appt.Sent_to_Oracle_Update__c){
                    Appt.Sent_to_Oracle_Update__c = false;
                    update Appt;}/CH05.End
                }catch(Exception ex){system.debug('Isis exception: '+ex.getMessage()+ '\n' +ex.getStackTraceString());requestOut.Isis_Error__c = ex.getMessage() +'\n'+ex.getStackTraceString(); update requestOut;}//CH01.End
                */
                if(requestOut.Status__c == EON_Utility.RESULT_PASS){//'PASS'
                    objAppt = Appt;
                    objAppt.Duration__c = dur;
                    if(subArea!='')objAppt.SubArea__c = subArea;
                    if(!objAppt.Sent_to_Oracle__c)objAppt.Sent_to_Oracle__c = true; //CH05
                    if(!objAppt.Sent_to_Oracle_Update__c)objAppt.Sent_to_Oracle_Update__c = true; //CH05
                    //update Appt;   
                }
                //}catch(Exception ex){system.debug('Isis exception: '+ex.getMessage()+ '\n' +ex.getStackTraceString());requestOut.Isis_Error__c = ex.getMessage() +'\n'+ex.getStackTraceString(); update requestOut;}/*CH01.End*/
            }catch(Exception ex){
                result = 'Appointment can\'t be updated, Please contact your administrator.';/*'Exception occurred Please see Error : ' + ex.getMessage()*/
                system.debug('### Tracker exception: '+ex.getMessage()+ '\n' +ex.getStackTraceString());
                requestOut = new Oracle_Data_Tracker__c(Direction__c = EON_Utility.DIRECTION_OUT, Status__c = EON_Utility.RESULT_FAIL); 
                String errMsg = ''; 
                errMsg = ex.getMessage() + ex.getStackTraceString() + '\n' + response; 
                if(errMsg.length() > 131072) requestOut.Response_Data__c = errMsg.substring(0, 131072);
                else 
                    requestOut.Response_Data__c = errMsg;
                insert requestOut;
            }
        system.debug('$$$ final result: '+result);
        return result;                        
    }
    
    /**
        convertDateToDateTime(Date dt) - This method converts date to TOA Date Format.
    **/
    public static String convertDateToOFSCFormat(Date dt){
        String TOADate = '';
        if(dt != null)
            TOADate = datetime.newInstance(dt, time.newInstance(0, 0, 0, 0)).format(toaDateFormat);            
        return TOADate;        
    }
    
    /**
        checkNullBlank(string val) - This method checks for null or blank.
    **/
    public static String checkNullBlank(string val){
        if(val == null || val == '')
            return '';            
        return val;        
    }
    
    /**
        getAppointment(string appName) - This method create static EON_Appointment record object, which will further be used to send update activity 
                                         to OFSC after once this object is updated with recieved data from various interfaces.
    **/
    public static string getAppointment(string appName){
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>();
        system.debug('@@@ in getAppointment call: '+appName);
        try{
            string response = '';
            if(string.isBlank(appName)){ 
                objAppt1 = new EON_Appointment__c();
                response = 'Appointment Id is blank.';
            }
            else{ //CH33.Update Added  Booking_System_Name__c
                lstApp = [select id,Booking_System_Name__c,Appointment_Key__c,Fuel_ID__c, GSP_Group_ID__c,Confirmed_Appointment_DateTime__c, name,Current_Phase__c,Current_SSC__c, E_Meter_Location__c, G_Meter_Location__c, Parking_Type__c, Oracle_Postcode_Sector__c, h_Job_Type__c, Key_Collection_Required__c, Technician__c,//CH31 Added field for further access 
                                 Fuel_ID__r.MPAN__c, MPAN__c, Fuel_ID__r.Premise__r.Customer__r.Customer_group_type__c, Job_code__r.h_Job_Attribute_Duration__c,Planned_G_Meter_Type__c, 
                                 Job_code__r.Duration__c, Job_code__r.SME_Duration__c, Fuel_ID__r.MPRN__c, MPRN__c, Job_code__c, Job_code__r.Name, Time_Slot__c, Start_Time__c, Job_code__r.Install_SED__c,//CH41
                                 Appointment_Date__c, End_Time__c, Caller_Name__c, Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c, EON_Appointment_ID__c, Access_Pass_Phrase__c, 
                                 Appointment_reason_code__c, Appointment_reason_code__r.OFS_Enumeration__c, h_OFSC_Assisted_Work_Reason_Code__c, Additional_Information__c, 
                                 h_OFSC_Metering_Pressure__c, h_OFSC_Number_of_Phases__c, E_Meter_Serial_Number__c, E_Meter_Type__r.OFS_Enumeration__c, E_Meter_Make__c, 
                                 E_Meter_Model__c, E_Meter_Register_1_ID__c, E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c, E_Meter_Register_5_ID__c, 
                                 E_Meter_Register_6_ID__c, Certification_Date__c, G_Meter_Serial_Number__c, G_Meter_Type__r.OFS_Enumeration__c, G_Meter_Make__c, G_Meter_Model__c, 
                                 E_Check_Meter_Serial_Number__c, h_OFSC_G_Check_Meter_Installed__c, G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, 
                                 Expected_IHD_Serial_Number__c, h_OFSC_Planned_E_Meter_Type__c, h_OFSC_Planned_G_Meter_Type__c, h_OFSC_Planned_Meter_Registers__c, //Requested_SSC__r.Name,//CH09.old
                                 h_OFSC_Planned_Meter_Mode__c, h_OFSC_Gas_bind_performed_flag__c, h_OFSC_Install_SED_flag__c, Key_Person_Name__c, Key_Building_Name__c, 
                                 Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, Key_Dependant_Locality__c, Key_Town__c, 
                                 Key_County__c, Key_Post_Code__c, Key_Contact_Number__c,h_G_MeterMake_Enum_Mapping__c ,//CH17
                                 SubArea__c, Sent_to_Oracle__c, Sent_to_Oracle_Update__c,  Certification_Expiry_Date__c, 
                                 E_Check_Meter_Make__c, E_Check_Meter_Model__c, E_Check_Meter_Location__c, E_Check_Meter_Location__r.OFS_Enumeration__c, G_Check_Meter_Make__c, 
                                 G_Check_Meter_Model__c, G_Check_Meter_Location__c, G_Check_Meter_Location__r.OFS_Enumeration__c, Planned_Number_of_Registers__c,//CH09
                                 Post_Code__c, Planned_E_Meter_Type__c, Metering_Point_Postcode__c, Notes__c, Specific_Time_flag__c, //CH11
                                 Customer_Name__c, Assisted_Work_Reason_Code__c, Gas_Regulator_Serial_Number__c, Requested_SSC__c,//CH09
                                 G_Meter_Mechanism__c, G_Meter_Mechanism__r.OFS_Enumeration__c, //CH15
                                 Duration__c, h_OFSC_E_Check_Meter_Installed__c, Parking_Type__r.OFS_Enumeration__c, E_Meter_Register_1_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_2_Name__r.OFS_Enumeration__c, E_Meter_Register_3_Name__r.OFS_Enumeration__c, E_Meter_Register_4_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_5_Name__r.OFS_Enumeration__c, E_Meter_Register_6_Name__r.OFS_Enumeration__c, G_Meter_Location__r.OFS_Enumeration__c, E_Meter_Location__r.OFS_Enumeration__c,  
                              (Select ID, Comm_Type_Code__c from EON_Appointment_Comms__r), //CH20.New
                              (Select ID, VulnerabilityDetailCode__c from EON_Appointment_Vulnerabilities__r), //CH20.New
                              (Select ID, Contact_Full_Name__c, Contact_Type__r.Code__c, Media_Type__r.Code__c, Media_Detail__c from EON_Appointment_Contacts__r) //CH20.New
                          
                              //CH37.Start
                              , CSP_Region__c, Comms_Hub_Variant__c, Connectivity_Likelihood__c,
                              Auxiliary_Equipment_required__c, WAN_Additional_Information__c
                              //CH37.End                          
                          
                          from EON_Appointment__c 
                          where Name =: appName and Sent_to_Oracle__c = true limit 1];//CH10
                if(lstApp.size()>0){
                    objAppt1 =  lstApp[0];
                    response = 'Appointment Exists.';
                }
                else
                    response = 'Appointment doesn\'t exists.';  
            } 
            system.debug('@@@ in getAppointment response: '+response);
            return response;} catch(exception ex){system.debug('### getAppointment exception: '+ex.getmessage() +'\n'+ex.getStackTraceString());return ('Error: '+ ex.getmessage());}      
    }
    
    /**
        getAppointmentForEON(string appName) - This method is duplicate of getAppointment and need to amended if any changes in above method //CH23
    **/
    public static string getAppointmentForEON(string appName){
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>();
        try{
            string response = '';
            if(string.isBlank(appName)){ 
                objAppt1 = new EON_Appointment__c();
                response = 'Appointment Id is blank.';
            }
            else{
                lstApp = [select id,Appointment_Key__c, GSP_Group_ID__c,Fuel_ID__c,Confirmed_Appointment_DateTime__c, name,Current_Phase__c,Current_SSC__c, E_Meter_Location__c, G_Meter_Location__c, Parking_Type__c, Oracle_Postcode_Sector__c, h_Job_Type__c, Key_Collection_Required__c, Technician__c,//CH31
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
                                 Key_County__c, Key_Post_Code__c, Key_Contact_Number__c,h_G_MeterMake_Enum_Mapping__c ,
                                 SubArea__c, Sent_to_Oracle__c, Sent_to_Oracle_Update__c,  Certification_Expiry_Date__c, 
                                 E_Check_Meter_Make__c, E_Check_Meter_Model__c, E_Check_Meter_Location__c, E_Check_Meter_Location__r.OFS_Enumeration__c, G_Check_Meter_Make__c, 
                                 G_Check_Meter_Model__c, G_Check_Meter_Location__c, G_Check_Meter_Location__r.OFS_Enumeration__c, Planned_Number_of_Registers__c,
                                 Post_Code__c, Planned_E_Meter_Type__c, Metering_Point_Postcode__c, Notes__c, Specific_Time_flag__c, 
                                 Customer_Name__c, Assisted_Work_Reason_Code__c, Gas_Regulator_Serial_Number__c, Requested_SSC__c,
                                 G_Meter_Mechanism__c, G_Meter_Mechanism__r.OFS_Enumeration__c, 
                                 Duration__c, h_OFSC_E_Check_Meter_Installed__c, Parking_Type__r.OFS_Enumeration__c, E_Meter_Register_1_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_2_Name__r.OFS_Enumeration__c, E_Meter_Register_3_Name__r.OFS_Enumeration__c, E_Meter_Register_4_Name__r.OFS_Enumeration__c, 
                                   E_Meter_Register_5_Name__r.OFS_Enumeration__c, E_Meter_Register_6_Name__r.OFS_Enumeration__c, G_Meter_Location__r.OFS_Enumeration__c, E_Meter_Location__r.OFS_Enumeration__c,  
                              (Select ID, Comm_Type_Code__c from EON_Appointment_Comms__r), 
                              (Select ID, Description__c, VulnerabilityDetailCode__c, VulnerabilityTypeID__c from EON_Appointment_Vulnerabilities__r), //CH23.Update
                              (Select ID, Contact_Full_Name__c, Contact_Type__r.Code__c, Media_Type__r.Code__c, Media_Detail__c from EON_Appointment_Contacts__r) 
                          
                              //CH37.Start
                              , CSP_Region__c, Comms_Hub_Variant__c, Connectivity_Likelihood__c,
                              Auxiliary_Equipment_required__c, WAN_Additional_Information__c
                              //CH37.End
                          
                          from EON_Appointment__c 
                          where Name =: appName limit 1 ]; 
                    objAppt1 =  lstApp[0];
                  response = lstApp.isEmpty()?'Appointment doesn\'t exists.':(lstApp[0].Sent_to_Oracle__c?'Appointment Exists.':'OOA System is background processing this appointment. Please try again.'); 
             } 
            system.debug('@@@ in getAppointmentForEON response: '+response);
            return response;} catch(exception ex){system.debug('### getAppointmentForEON exception: '+ex.getmessage() +'\n'+ex.getStackTraceString());return ('Error: '+ ex.getmessage());}      
    }
    
    /*
        getPlannedReg() -- Return Planned_Number_of_Registers__c value as per SR_EON_Mobile_046.
    */
    public static string getPlannedReg(EON_Appointment__c objAp, map<string,list<EON_SSC__c>> mapSSC){
        try{
            string plannedReg = '';
            string reqSSC = string.isNotBlank(objAP.Requested_SSC__c)?objAP.Requested_SSC__c:'';
            //list<EON_SSC__c> lstSSC = new list<EON_SSC__c>([select id, name, Number_of_Registers__c, Type__c from EON_SSC__c where name=:reqSSC]);
            if(!mapSSC.isEmpty() && mapSSC.get(reqSSC)!= null && mapSSC.get(reqSSC).size()>0){
                list<EON_SSC__c> lstSSC = mapSSC.get(reqSSC);
                /*
                if(lstSSC.size()==1){
                    plannedReg = string.valueOf(lstSSC[0].Number_of_Registers__c);
                }
                else{ commented this part as part of the change CH28*/ 
                
                string mtrType = objAp.Planned_E_Meter_Type__c;
                if(string.isNotBlank(mtrType) && mtrType.containsignorecase('MS1')){
                    for(EON_SSC__c objSSC : lstSSC){
                        if(objSSC.Type__c == 'Smart'){
                            plannedReg = string.valueOf(objSSC.Number_of_Registers__c);
                            break;
                        }
                    }
                }
                else {
                    for(EON_SSC__c objSSC : lstSSC){
                        if(objSSC.Type__c == 'Classic'){
                            plannedReg = string.valueOf(objSSC.Number_of_Registers__c);
                            break;
                        }
                    }
                }
                //}
            }
            //CH27 commented this logic
            /*
            if(string.isBlank(plannedReg)){                                  
                 integer noOfMeterRegIds = 0; 
                 if(string.isNotBlank(objAp.E_Meter_Register_1_ID__c))
                    noOfMeterRegIds++;
                 if(string.isNotBlank(objAp.E_Meter_Register_2_ID__c))
                    noOfMeterRegIds++;
                 if(string.isNotBlank(objAp.E_Meter_Register_3_ID__c))
                    noOfMeterRegIds++;
                 if(string.isNotBlank(objAp.E_Meter_Register_4_ID__c))
                    noOfMeterRegIds++;
                 if(string.isNotBlank(objAp.E_Meter_Register_5_ID__c))
                    noOfMeterRegIds++;
                 if(string.isNotBlank(objAp.E_Meter_Register_6_ID__c))
                    noOfMeterRegIds++;
                 plannedReg =String.valueof(noOfMeterRegIds);
                  
            }
            */
            system.debug('@@@ PlannedReg value from method: '+plannedReg);
            return plannedReg;
        }
        catch(exception ex){system.debug('### getPlannedReg Exc: '+ex.getMessage()+'\n'+ex.getStackTraceString()); return '';}
    }
}