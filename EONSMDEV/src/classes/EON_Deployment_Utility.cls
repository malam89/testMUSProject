/**
    Description     : This class will hold utility methods used as one time activity for deployment purpose
    Test Class      : EON_Deployment_Utility_test     
**/
/*
    Created By : Mahadev Joshilkar
    Created Date : 31-Aug-2016
    Service Request : SR_EON_Jumbo_055
    Change History :
*/
public class EON_Deployment_Utility{
    public String AllApptID {
        get;
        set;
    }
    public static Oracle_Data_Tracker__c requestOut;
    public static string toaDateFormat = 'yyyy-MM-dd';
    
    public static string sendActivityToOFSC(EON_Appointment__c Appt, string activityType, string eonTrackerId, string jumboTrackerId, string appDate, string appTime, string bookingSystem, EON_Appointment_Contact__c appContact){
        String result = '', requestXML = '', subArea = '', aid = '', bucketId = '';
        integer dur = 0;
        requestOut = new Oracle_Data_Tracker__c();

        //Request Elements.
        EON_OFSC_Inbound_WS.UserElement userElement;
        EON_OFSC_Inbound_WS.HeadElement headerElement;
        EON_OFSC_Inbound_WS.DataElement dataElement = new EON_OFSC_Inbound_WS.DataElement();
        
        //Response Element
        EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response;

    try{
            //Generate Exception
            if(EON_Deployment_Utility_Test.genException == null)
                EON_Deployment_Utility_Test.genException = false;
            
            string sscName = checkNullBlank(Appt.Requested_SSC__c);
            string mtrType = Appt.Planned_E_Meter_Type__c;
            string G_mtrType = Appt.Planned_G_Meter_Type__c;
            string postcode = '';
            if(Appt.Metering_Point_Postcode__c != '')
              postcode = Appt.Metering_Point_Postcode__c.substring(0, Appt.Metering_Point_Postcode__c.length()-2); 
            string JobType = string.isNotBlank(Appt.h_Job_Type__c)?Appt.h_Job_Type__c:'';
            
            //Get Oracle Tracker Record
            requestOut.Command__c = (activityType=='CREATE'?EON_Utility.CMD_OFSC_CreateActivity:EON_Utility.CMD_OFSC_UpdateActivity);
            requestOut.Direction__c = EON_Utility.DIRECTION_OUT;
            requestOut.h_Booking_System_Name__c = string.isNotBlank(bookingSystem)?(bookingSystem.length()<255?bookingSystem:bookingSystem.substring(0,254)):'';
            requestOut.EON_Appointment__c = Appt.Id;
            requestOut.Transaction_ID__c = Appt.Id;
            
            //Get User Element
            userElement = EON_OFSC_Helper.getInboundUserElement();
            
            //Get Header Element
            headerElement = EON_OFSC_Helper.getHeaderElement();
            
            if(string.isNotBlank(eonTrackerId))
                requestOut.EON_Data_Tracker__c = eonTrackerId;
            //if(string.isNotBlank(jumboTrackerId))
            //    requestOut.JUMBO_Data_Tracker__c = jumboTrackerId;
            
            list<EON_SSC_Register__c> lstSSCReg = new list<EON_SSC_Register__c>();
            if(string.isNotBlank(sscName)){
              list<EON_SSC__c> lstSSC = new list<EON_SSC__c>([select id, name, Type__c, (select id, name, Register_ID__c, TPR__c from EON_SSC_Registers__r) from EON_SSC__c where name =: sscName]);
                if(!lstSSC.isEmpty() && lstSSC.size()==1)
                  lstSSCReg.addall(lstSSC[0].EON_SSC_Registers__r);
                else{
                  if(string.isNotBlank(mtrType) && mtrType.containsignorecase('MS1')){ 
                    for(EON_SSC__c objSSC : lstSSC){
                        if(objSSC.Type__c == 'Smart'){
                            lstSSCReg.addall(objSSC.EON_SSC_Registers__r);
                              break;
                          }
                      }
                  }
                  else{
                    for(EON_SSC__c objSSC : lstSSC){
                        if(objSSC.Type__c == 'Classic'){
                            lstSSCReg.addall(objSSC.EON_SSC_Registers__r);
                              break;
                          }
                      }
                  }
             }
            }
            
            list<EON_Post_Code__c> lstPC = new list<EON_Post_Code__c>([select id, name, h_sub_area_checkbox__c, Sub_Area_Name__r.Id, Sub_Area_Name__r.Oracle_Bucket_ID__c from EON_Post_Code__c where name =: postcode]);
            for(EON_Post_Code__c objPC : lstPC){
                string check = string.isNotBlank(objPC.h_sub_area_checkbox__c)?objPC.h_sub_area_checkbox__c:'';
                if(JobType != '' && check!= '' && check.containsIgnoreCase(JobType)){
                    bucketId = objPC.Sub_Area_Name__r.Oracle_Bucket_ID__c;
                    subArea = objPC.Sub_Area_Name__r.Id; 
                }
            }
            if(EON_Deployment_Utility_test.genException)
                bucketId = '';
            if(bucketId == '')
                bucketId = system.label.EON_Exception_BucketID;
            //Cover exception
            if(EON_Deployment_Utility_Test.genException) 
                ID test = ID.valueOf('incorrect'); 
            /**string vulnerabilites = '';
            for(EON_Appointment_Vulnerability__c objVul : Appt.EON_Appointment_Vulnerabilities__r){
                if(vulnerabilites =='')
                    vulnerabilites = objVul.h_Vulnerability_Desc__c;
                else
                    vulnerabilites = vulnerabilites +', '+objVul.h_Vulnerability_Desc__c;
            }*/
            string duration ='';
            if(activityType=='CREATE' && (Appt.Job_code__r.h_Job_Attribute_Duration__c!=null || Appt.Job_code__r.Duration__c!=null))
                dur = Integer.valueOf((Appt.Job_code__r.h_Job_Attribute_Duration__c!=null?Appt.Job_code__r.h_Job_Attribute_Duration__c:0) + (Appt.Job_code__r.Duration__c!=null?Appt.Job_code__r.Duration__c:0));
            if(dur!=0)
                duration = string.valueof(dur);
            //Create appointment Element
            EON_OFSC_Inbound_WS.AppointmentElement appointmentElement = new EON_OFSC_Inbound_WS.AppointmentElement();
            appointmentElement.appt_number = Appt.Id;
            appointmentElement.duration = duration;
            appointmentElement.worktype_label = string.isNotBlank(Appt.Job_code__c)?Appt.Job_code__r.Name:'';
            appointmentElement.time_slot = checkNullBlank((bookingSystem!='MUS'?Appt.Time_Slot__c:appTime));
            string startTime = string.isNotBlank(Appt.Start_Time__c)?Appt.Start_Time__c:'';
            appointmentElement.sla_window_start = (Appt.Appointment_Date__c!=null&& startTime!=''?string.valueOf(Appt.Appointment_Date__c) +' '+Appt.Start_Time__c:''); 
            string endTime = '';
             if(Appt.Appointment_Date__c!=null&& startTime!='' && Appt.End_Time__c!='' && Appt.End_Time__c.length() >2 && startTime.length()>2){
              integer sHr = integer.valueOf(startTime.left(2));
                integer eHr = integer.valueOf(Appt.End_Time__c.left(2));
                integer i = sHr-eHr;
                date endDate = Appt.Appointment_Date__c;
                if(i>0) 
                  endDate=Appt.Appointment_Date__c.addDays(1);
                 endTime = string.valueOf(endDate) +' '+ Appt.End_Time__c;
            }
            appointmentElement.sla_window_end = endTime;
            appointmentElement.name = string.isNotBlank(Appt.Caller_Name__c)?Appt.Caller_Name__c:Appt.Customer_Name__c;
            appointmentElement.address = Appt.Oracle_Address__c;
            String oracleTown = '';
            appointmentElement.city = !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_8__c) ? oracleTown + appt.Metering_Point_Address_Line_8__c : (!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_9__c) ? oracleTown + appt.Metering_Point_Address_Line_9__c : (!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_7__c) ? oracleTown + appt.Metering_Point_Address_Line_7__c :oracleTown)); //Appt.Oracle_Town__c;
            appointmentElement.zip = Appt.Metering_Point_Postcode__c;//Appt.Oracle_Postcode__c;
            
            //Property Element
            List<EON_OFSC_Inbound_WS.PropertyElement> property_elements = new List<EON_OFSC_Inbound_WS.PropertyElement>(); 
            EON_OFSC_Inbound_WS.PropertyElement property_element = new EON_OFSC_Inbound_WS.PropertyElement(); 
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_APPT_NOTES';
            property_element.value = checkNullBlank(Appt.Notes__c);
            property_elements.add(property_element);            
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_Morrison_ID';
            property_element.value = Appt.Name;
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_EON_ID';
            property_element.value = checkNullBlank(Appt.EON_Appointment_ID__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            if(!EON_Utility.validateRequired(Appt.Parking_Type__c)){
              property_element = new EON_OFSC_Inbound_WS.PropertyElement();
              property_element.label = 'XA_PARKING';
              integer enumVal = Appt.Parking_Type__r.OFS_Enumeration__c!=0.0 ? integer.valueOf(Appt.Parking_Type__r.OFS_Enumeration__c) : null;
              property_element.value = string.valueOf(enumVal);
              property_elements.add(property_element);
              system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);    
            }
            
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PASSPHRASE';
            property_element.value = checkNullBlank(Appt.Access_Pass_Phrase__c);//Appt.Access_Pass_Phrase__c
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            /*property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_VULNERABLE';
            property_element.value = vulnerabilites;
            property_elements.add(property_element); */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_APPOINTMENT_REASON';
            integer enumVal_ApptRes = Appt.Appointment_reason_code__c!=null && Appt.Appointment_reason_code__r.OFS_Enumeration__c!=null ? integer.valueOf(Appt.Appointment_reason_code__r.OFS_Enumeration__c) : null;
            property_element.value = string.valueOf(enumVal_ApptRes); //(Appt.Appointment_reason_code__c!=null && Appt.Appointment_reason_code__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.Appointment_reason_code__r.OFS_Enumeration__c)):'');//CH06
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSIST_REASON';
            property_element.value = (!EON_Utility.validateRequired(appt.Assisted_Work_Reason__c)) ? (appt.Assisted_Work_Reason__c.equalsIgnoreCase('2nd Technician Required') ? '1' : (appt.Assisted_Work_Reason__c.equalsIgnoreCase('Ladder') ? '2' : (appt.Assisted_Work_Reason__c.equalsIgnoreCase('Tech Specialist') ? '3' : ''))) : ''; //checkNullBlank(Appt.h_OFSC_Assisted_Work_Reason_Code__c);//CH06
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            if(!EON_Utility.validateRequired(appContact)){
              property_element = new EON_OFSC_Inbound_WS.PropertyElement();
              property_element.label = 'XA_CONTACT_NAME'; //
              property_element.value = !EON_Utility.validateRequired(appContact.Contact_Full_Name__c) ? appContact.Contact_Full_Name__c : ''; //((!Appt.EON_Appointment_Contacts__r.isEmpty()&&Appt.EON_Appointment_Contacts__r.size()>0)?checkNullBlank(Appt.EON_Appointment_Contacts__r[0].Contact_Full_Name__c):'');
              property_elements.add(property_element);
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
              property_element = new EON_OFSC_Inbound_WS.PropertyElement();
              property_element.label = 'XA_CONTACT_NUMBER';
              property_element.value =  !EON_Utility.validateRequired(appContact.Media_Detail__c) ? appContact.Media_Detail__c : ''; //((!Appt.EON_Appointment_Contacts__r.isEmpty()&&Appt.EON_Appointment_Contacts__r.size()>0)?checkNullBlank(Appt.EON_Appointment_Contacts__r[0].Media_Detail__c):'');
              property_elements.add(property_element);    
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            }
            
            
            /*
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME_2';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty()&&Appt.EON_Appointment_Contacts__r.size()>1)?checkNullBlank(Appt.EON_Appointment_Contacts__r[1].Contact_Full_Name__c):'');
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER_2';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty()&&Appt.EON_Appointment_Contacts__r.size()>1)?checkNullBlank(Appt.EON_Appointment_Contacts__r[1].Media_Detail__c):'');
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME_3';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty()&&Appt.EON_Appointment_Contacts__r.size()>2)?checkNullBlank(Appt.EON_Appointment_Contacts__r[2].Contact_Full_Name__c):'');
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER_3';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty()&&Appt.EON_Appointment_Contacts__r.size()>2)?checkNullBlank(Appt.EON_Appointment_Contacts__r[2].Media_Detail__c):'');
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NAME_4';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty()&&Appt.EON_Appointment_Contacts__r.size()>3)?checkNullBlank(Appt.EON_Appointment_Contacts__r[3].Contact_Full_Name__c):'');
            property_elements.add(property_element);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_CONTACT_NUMBER_4';
            property_element.value = ((!Appt.EON_Appointment_Contacts__r.isEmpty()&&Appt.EON_Appointment_Contacts__r.size()>3)?checkNullBlank(Appt.EON_Appointment_Contacts__r[3].Media_Detail__c):'');
            property_elements.add(property_element); */
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_POSTCODE_SECTOR';
            property_element.value = !EON_Utility.validateRequired(Appt.Metering_Point_Postcode__c) ? Appt.Metering_Point_Postcode__c.substring(0, Appt.Metering_Point_Postcode__c.length()-2) : '' ;  //checkNullBlank(Appt.Oracle_Postcode_Sector__c); //CH04.New
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ADDITIONAL_INFO';
            property_element.value = checkNullBlank(Appt.Additional_Information__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_MPAN_NUMBER';
            property_element.value = checkNullBlank(Appt.MPAN__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_MPRN_NUMBER';
            property_element.value = checkNullBlank(Appt.MPRN__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PRESSURE';
            property_element.value = (!EON_Utility.validateRequired(appt.Metering_Pressure__c)) ? (appt.Metering_Pressure__c.equalsIgnoreCase('Low') ? '1' : (appt.Metering_Pressure__c.equalsIgnoreCase('Med') ? '2' : '')) : ''; //checkNullBlank(Appt.h_OFSC_Metering_Pressure__c); //CH06
            property_elements.add(property_element); 
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_PHASE';
            property_element.value = (!EON_Utility.validateRequired(appt.Number_of_Phases__c)) ? (appt.Number_of_Phases__c.equalsIgnoreCase('1ph') ? '1' : (appt.Number_of_Phases__c.equalsIgnoreCase('3ph') ? '2' : '')) : ''; //checkNullBlank(Appt.h_OFSC_Number_of_Phases__c);//CH06
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_MSN';
            property_element.value = checkNullBlank(Appt.E_Meter_Serial_Number__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            if(!EON_Utility.validateRequired(Appt.E_Meter_Type__c)){
                list<EON_Electric_Meter_Type__c> eMeterType = [Select ID, Name, OFS_Enumeration__c from EON_Electric_Meter_Type__c where ID=: Appt.E_Meter_Type__c];
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_E_TYPE';
                property_element.value = (eMeterType.size() > 0 && eMeterType[0].OFS_Enumeration__c != 0.0) ? checkNullBlank(string.valueOf(eMeterType[0].OFS_Enumeration__c)) : '';  //(Appt.E_Meter_Type__c!=null && Appt.E_Meter_Type__r.OFS_Enumeration__c!=0.0?checkNullBlank(string.valueOf(Appt.E_Meter_Type__r.OFS_Enumeration__c)):'');//CH06 
                property_elements.add(property_element);
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            }
            
            if(!EON_Utility.validateRequired(Appt.E_Meter_Location__c)){
        list<EON_Electric_Meter_Location__c> eMeterLocation = [Select ID, name, OFS_Enumeration__c from EON_Electric_Meter_Location__c where ID =:Appt.E_Meter_Location__c];
               property_element = new EON_OFSC_Inbound_WS.PropertyElement();
              property_element.label = 'XA_ASSET_E_LOCATION';
              property_element.value = (eMeterLocation.size() > 0 && eMeterLocation[0].OFS_Enumeration__c != 0.0) ? checkNullBlank(string.valueOf(eMeterLocation[0].OFS_Enumeration__c)) : '';//(Appt.E_Meter_Location__c!=null && Appt.E_Meter_Location__r.OFS_Enumeration__c!=0.0?checkNullBlank(string.valueOf(Appt.E_Meter_Location__r.OFS_Enumeration__c)):'');//CH06
              property_elements.add(property_element);   
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            }
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_MANFCT';
            property_element.value = checkNullBlank(Appt.E_Meter_Make__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_VERSION';
            property_element.value = checkNullBlank(Appt.E_Meter_Model__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_1_ID__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID2';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_2_ID__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID3';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_3_ID__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID4';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_4_ID__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID5';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_5_ID__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_REG_ID6';
            property_element.value = checkNullBlank(Appt.E_Meter_Register_6_ID__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_CERTDT';
            property_element.value = convertDateToOFSCFormat(Appt.Certification_Date__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_CERTEXPDT';
            property_element.value = convertDateToOFSCFormat(Appt.Certification_Expiry_Date__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            //Gas meter information
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_MSN';
            property_element.value = checkNullBlank(Appt.G_Meter_Serial_Number__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            if(!EON_Utility.validateRequired(Appt.G_Meter_Mechanism__c)){
                list<EON_Gas_Meter_Mechanism__c> gMeterMech = [Select ID, Name, OFS_Enumeration__c from EON_Gas_Meter_Mechanism__c where ID =:Appt.G_Meter_Mechanism__c];
              property_element = new EON_OFSC_Inbound_WS.PropertyElement();
              property_element.label = 'XA_ASSET_G_TYPE';
              property_element.value = (gMeterMech.size() > 0 && gMeterMech[0].OFS_Enumeration__c != 0.0) ? checkNullBlank(string.valueOf(gMeterMech[0].OFS_Enumeration__c)) : ''; //(Appt.G_Meter_Mechanism__c!=null && Appt.G_Meter_Mechanism__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.G_Meter_Mechanism__r.OFS_Enumeration__c)):'');//CH15
              property_elements.add(property_element);    
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            }
            
            if(!EON_Utility.validateRequired(Appt.G_Meter_Location__c)){
                list<EON_Gas_Meter_Location__c> gMeterLoc = [Select ID, Name, OFS_Enumeration__c from EON_Gas_Meter_Location__c where ID =:Appt.G_Meter_Location__c];
              property_element = new EON_OFSC_Inbound_WS.PropertyElement();
              property_element.label = 'XA_ASSET_G_LOCATION';
              property_element.value = (gMeterLoc.size() > 0 && gMeterLoc[0].OFS_Enumeration__c != 0.0) ? checkNullBlank(string.valueOf(gMeterLoc[0].OFS_Enumeration__c)) : ''; //(Appt.G_Meter_Location__c!=null && Appt.G_Meter_Location__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.G_Meter_Location__r.OFS_Enumeration__c)):'');//CH06
              property_elements.add(property_element);    
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            }
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_MAKE';     //CH19       
            property_element.value = checkNullBlank(Appt.h_G_MeterMake_Enum_Mapping__c); //CH19
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_G_VERSION';
            property_element.value = checkNullBlank(Appt.G_Meter_Model__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
             
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_MSN';
            property_element.value = checkNullBlank(Appt.E_Check_Meter_Serial_Number__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            //CH09.new.start
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_MANFCT';
            property_element.value = checkNullBlank(Appt.E_Check_Meter_Make__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_EC_VERSION';
            property_element.value = checkNullBlank(Appt.E_Check_Meter_Model__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            if(!EON_Utility.validateRequired(Appt.E_Check_Meter_Location__c)){
                list<EON_Electric_Meter_Location__c> eMeterLoc = [Select ID, Name, OFS_Enumeration__c from EON_Electric_Meter_Location__c where ID =: Appt.E_Check_Meter_Location__c];
              property_element = new EON_OFSC_Inbound_WS.PropertyElement();
              property_element.label = 'XA_ASSET_EC_LOCATION';
              property_element.value = (eMeterLoc.size() > 0 && eMeterLoc[0].OFS_Enumeration__c != 0.0) ? checkNullBlank(string.valueOf(eMeterLoc[0].OFS_Enumeration__c)) : '';//(Appt.E_Check_Meter_Location__c!=null && Appt.E_Check_Meter_Location__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.E_Check_Meter_Location__r.OFS_Enumeration__c)):''); 
              property_elements.add(property_element);    
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            }
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_MANFCT';
            property_element.value = checkNullBlank(Appt.G_Check_Meter_Make__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_VERSION';
            property_element.value = checkNullBlank(Appt.G_Check_Meter_Model__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            if(!EON_Utility.validateRequired(Appt.G_Check_Meter_Location__c)){
                list<EON_Gas_Meter_Location__c> gMeterLoc = [Select ID, Name, OFS_Enumeration__c from EON_Gas_Meter_Location__c where ID =:Appt.G_Check_Meter_Location__c];
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_GC_LOCATION';
                property_element.value = (gMeterLoc.size() > 0 && gMeterLoc[0].OFS_Enumeration__c != 0.0) ? checkNullBlank(string.valueOf(gMeterLoc[0].OFS_Enumeration__c)) : ''; //(Appt.G_Check_Meter_Location__c!=null && Appt.G_Check_Meter_Location__r.OFS_Enumeration__c!=null?checkNullBlank(string.valueOf(Appt.G_Check_Meter_Location__r.OFS_Enumeration__c)):'');
                property_elements.add(property_element);
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            }
             
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_GC_MSN';
            property_element.value = checkNullBlank(Appt.G_Check_Meter_Serial_Number__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_H_MSN';
            property_element.value = checkNullBlank(Appt.Expected_Comms_Hub_Serial_Number__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_I_MSN';
            property_element.value = checkNullBlank(Appt.Expected_IHD_Serial_Number__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            string pEleMeterType = '';
            if(!EON_Utility.validateRequired(Appt.Job_Code__c)){
                pEleMeterType = [Select ID, Name from EON_Job__c where ID =: Appt.Job_Code__c].Name;
            }
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ELEC_METER_TYPE';
            if(pEleMeterType == 'OOACELEC')
                property_element.value = '3';
            else
              property_element.value = !EON_Utility.validateRequired(appt.Planned_E_Meter_Type__c) ? (appt.Planned_E_Meter_Type__c.equalsIgnoreCase('Key') ? '1' : (appt.Planned_E_Meter_Type__c.equalsIgnoreCase('MS1') ? '2' : (appt.Planned_E_Meter_Type__c.equalsIgnoreCase('MCL') ? '3' : ''))) : ''; //checkNullBlank(Appt.h_OFSC_Planned_E_Meter_Type__c);//CH06
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_GAS_METER_TYPE';
            property_element.value = (!EON_Utility.validateRequired(appt.Planned_G_Meter_Type__c)) ? (appt.Planned_G_Meter_Type__c.equalsIgnoreCase('Key') ? '1' : (appt.Planned_G_Meter_Type__c.equalsIgnoreCase('MS1') ? '2' : (appt.Planned_G_Meter_Type__c.equalsIgnoreCase('PP') ? '3' : ''))) : ''; //checkNullBlank(Appt.h_OFSC_Planned_G_Meter_Type__c);//CH06
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_TARIFF_NEW';
            property_element.value =  (!EON_Utility.validateRequired(appt.Planned_Meter_Registers__c)) ? (appt.Planned_Meter_Registers__c.equalsIgnoreCase('Single-rate') ? '1' : (appt.Planned_Meter_Registers__c.equalsIgnoreCase('Multi-rate') ? '2' : '')) : ''; //checkNullBlank(Appt.h_OFSC_Planned_Meter_Registers__c);//CH06
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_SSC_NEW';
            property_element.value = checkNullBlank(Appt.Requested_SSC__c);//CH08.old
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_ASSET_E_NOREG_NEW';
            property_element.value = checkNullBlank(Appt.Planned_Number_of_Registers__c);
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            if (!(mtrType == 'MCL' || mtrType == 'KEY' || G_mtrType == 'MCL' || G_mtrType == 'PP')) {
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_E_MODE_NEW';
                property_element.value = (!EON_Utility.validateRequired(appt.Planned_Meter_Mode__c)) ? (appt.Planned_Meter_Mode__c.equalsIgnoreCase('CR') ? '1' : (appt.Planned_Meter_Mode__c.equalsIgnoreCase('PAYG') ? '2' : '')) : ''; //checkNullBlank(Appt.h_OFSC_Planned_Meter_Mode__c);//CH06
                property_elements.add(property_element);
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            }
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_GAS_BIND';
            property_element.value = (!EON_Utility.validateRequired(appt.Gas_bind_performed_flag__c)) ? (appt.Gas_bind_performed_flag__c.equalsIgnoreCase('Yes') ? '1' : (appt.Gas_bind_performed_flag__c.equalsIgnoreCase('No') ? '2' : '')) : ''; //checkNullBlank(Appt.h_OFSC_Gas_bind_performed_flag__c);//CH06
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_INSTALL_SED';
            property_element.value = (!EON_Utility.validateRequired(appt.Install_SED_flag__c)) ? (appt.Install_SED_flag__c.equalsIgnoreCase('Yes') ? '1' : (appt.Install_SED_flag__c.equalsIgnoreCase('No') ? '2' : '')) : ''; //checkNullBlank(Appt.h_OFSC_Install_SED_flag__c);//CH06
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY';
            string keyCol = '';
            if(Appt.Key_Collection_Required__c!=null)
              keyCol = Appt.Key_Collection_Required__c?'Yes':'No';
            property_element.value = keyCol;
            property_elements.add(property_element);
            system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
            
            integer j =1;
            map<string,string> mapRegNameOFSVal = new map<string,string>{'EXPORT' =>'1','NORMAL'=>'2','Low' => '3', 'EVENING WEEKEND'=>'4','RATE 1'=>'5','RATE 2'=>'6',
                                           'RATE 3'=>'7', 'RATE 4'=>'8', 'RATE 5'=>'9', 'RATE 6'=>'10'};//TOTAL //CH13
            for(EON_SSC_Register__c objReg : lstSSCReg){
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_REGTYPE_NEW_'+j;
                property_element.value = mapRegNameOFSVal.containsKey(objReg.Name.toUpperCase())?mapRegNameOFSVal.get(objReg.Name.toUpperCase()):''; //CH13
                property_elements.add(property_element);
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
                
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_E_REG_ID_NEW_'+j;
                property_element.value = checkNullBlank(objReg.Register_ID__c);
                property_elements.add(property_element);
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
                    
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_ASSET_E_TPR'+j+'_NEW';
                property_element.value = checkNullBlank(objReg.TPR__c);
                property_elements.add(property_element);
                system.debug('###Property: '+property_element.label+' | Value: '+property_element.value);
                j++;
                if(j>6) 
                    break;
      }
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_PERSON';
            property_element.value = checkNullBlank(Appt.Key_Person_Name__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_PERSON | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_BUILD_NAME';
            property_element.value = checkNullBlank(Appt.Key_Building_Name__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_BUILD_NAME | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_BUILD_NO';
            property_element.value = checkNullBlank(Appt.Key_Building_Number__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_BUILD_NO | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_SUB_BUILD';
            property_element.value = checkNullBlank(Appt.Key_Sub_Building_Name__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_SUB_BUILD | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_THOROFARE';
            property_element.value = checkNullBlank(Appt.Key_Thorofare__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_THOROFARE | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_D_THOROFARE';
            property_element.value = checkNullBlank(Appt.Key_Dependant_Thorofare__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_D_THOROFARE | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_D_LOC';
            property_element.value = checkNullBlank(Appt.Key_Dependant_Locality__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_D_LOC | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_TOWN';
            property_element.value = checkNullBlank(Appt.Key_Town__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_TOWN | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_COUNTY';
            property_element.value = checkNullBlank(Appt.Key_County__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_COUNTY | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_POSTCODE';
            property_element.value = checkNullBlank(Appt.Key_Post_Code__c);
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_POSTCODE | Value: '+property_element.value);
            
            property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_KEY_CONTACT_NO';
            property_element.value = checkNullBlank(string.valueof(Appt.Key_Contact_Number__c));//CH17
            property_elements.add(property_element);
            system.debug('###Property: XA_KEY_CONTACT_NO | Value: '+property_element.value);
            
            if(bookingSystem.containsIgnoreCase('mus') && (Appt.Specific_Time_flag__c || EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag)){
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_SPECIAL_CUSTOMER';
                property_element.value = '1';
                property_elements.add(property_element);
                system.debug('###Property: XA_APPT_NOTES | Value: '+property_element.value);
                if(EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag)
                    EON_DisplayCapacitiesFromOFSC_Ctrl.specTimeFlag = false;
            }
                        
            EON_OFSC_Inbound_WS.PropertiesArray propertiesArray = new EON_OFSC_Inbound_WS.PropertiesArray();
            propertiesArray.property = property_elements;
            
            appointmentElement.properties = propertiesArray;
            EON_OFSC_Inbound_WS.CommandElement commandElement = new EON_OFSC_Inbound_WS.CommandElement();
            date appointDate = null;
            if(bookingSystem=='MUS'&&string.isNotBlank(appDate))
                appointDate = date.valueOf(appDate);
            else if(Appt.Appointment_Date__c != null)
                appointDate = Appt.Appointment_Date__c;
            commandElement.date_x = convertDateToOFSCFormat(appointDate); //CH04.New
            commandElement.type_x = 'update_activity';
            commandElement.external_id = bucketId;
            commandElement.appointment = appointmentElement;
            
            List<EON_OFSC_Inbound_WS.CommandElement> commandElements = new List<EON_OFSC_Inbound_WS.CommandElement>();
            commandElements.add(commandElement);
            
            EON_OFSC_Inbound_WS.CommandsArray commandArray = new EON_OFSC_Inbound_WS.CommandsArray();
            commandArray.command = commandElements;
                        
            dataElement.commands = commandArray;
            
            EON_OFSC_Inbound_WS.InboundInterfacePort request = new EON_OFSC_Inbound_WS.InboundInterfacePort();
            response = request.inbound_interface(userElement, headerElement, dataElement);
            String strResultCode = '';
            boolean iserror = false;
            if(response != null && response.data != null && response.data.commands != null && response.data.commands.command != null && response.data.commands.command.size() > 0 ){
                strResultCode = response.data.commands.command[0].appointment.report.message[0].code;
                if(response.data.commands.command[0].appointment.aid!=null) aid = string.valueOf(response.data.commands.command[0].appointment.aid); //CH07
                integer messageSize = response.data.commands.command[0].appointment.report.message.size();
                string tempError = '';
                for(integer i=0;i<messageSize;i++){
                    if(response.data.commands.command[0].appointment.report.message[i].code == '0')
                        strResultCode = '0';
                    else
                        tempError = response.data.commands.command[0].appointment.report.message[i].code;
                    if(response.data.commands.command[0].appointment.report.message[i].result == 'error'){
                        iserror = true;
                        strResultCode = tempError;
                    }
                }
            }
            List<EON_OFSC_Response_Code__c> responseCode = [select id, Name, Error_Warning_Success__c from EON_OFSC_Response_Code__c where name =: strResultCode and API__c ='Inbound'];
            if(!responseCode.isEmpty())
                requestOut.Error_Code__c = responseCode[0].id;
            if(!responseCode.isEmpty()){
                if(responseCode[0].Name == '0' || responseCode[0].Error_Warning_Success__c.containsignorecase('warning'))
                    requestOut.Status__c = EON_Utility.RESULT_PASS;
                if((responseCode[0].Error_Warning_Success__c!='' && responseCode[0].Error_Warning_Success__c.containsignorecase('error')) || iserror)
                    requestOut.Status__c = EON_Utility.RESULT_FAIL;
            }
            else if(strResultCode!='0')
                requestOut.Status__c = EON_Utility.RESULT_FAIL;
            else if(strResultCode=='0')
                requestOut.Status__c = EON_Utility.RESULT_PASS;
                
            String toaResponse = '' + response;
            if(toaResponse.length() > 131072) requestOut.Response_Data__c = toaResponse.substring(0, 131072);
            else
                requestOut.Response_Data__c = '' + toaResponse;
            
            //if the response got error then revert team's TOA field as it was before.
            if(requestOut.Status__c == EON_Utility.RESULT_PASS)
                result = 'Job sent to OFSC successfully';
            else
                result = 'No Response Code found or error found in the Response';   
        }
        catch(Exception ex){
            String errMsg = '';
            errMsg = ex.getMessage() + ex.getStackTraceString() + '\n' + response;
            system.debug('### exc: '+ex.getMessage() + '\n' + ex.getStackTraceString() );
            if(errMsg.length() > 131072) requestOut.Response_Data__c = errMsg.substring(0, 131072);
            else
            requestOut.Response_Data__c = errMsg;
            requestOut.Status__c = EON_Utility.RESULT_FAIL;//'FAIL';
            result = 'Exception occurred Please see Error : ' + ex.getMessage();          
        }
        try{
            requestXML = '' + userElement +'\n' +headerElement +'\n' +dataElement;  
            requestOut.Request_Data__c = EON_Utility.validateStringLength(requestXML);
            //insert requestOut;  
            //EON_Utility.createAttachment(requestOut.id, requestXML, requestOut.id);
            
            //try{
                if(requestOut.Status__c == EON_Utility.RESULT_PASS){
                    Appt.Duration__c = dur;
                    if(subArea!='')Appt.SubArea__c = subArea;
                    Appt.h_aid__c = aid;//CH07
                    if(activityType=='CREATE' && !Appt.Sent_to_Oracle__c)Appt.Sent_to_Oracle__c = true; 
                    //if(activityType=='UPDATE' && !Appt.Sent_to_Oracle_Update__c)Appt.Sent_to_Oracle_Update__c = true; 
                    //update Appt;   
                }
              if(EON_Deployment_Utility_test.genException)
                    ID test = ID.valueof('incorrect');
             /*}
            catch(Exception ex){
              system.debug('### Isis exception: '+ex.getMessage()+ '\n' +ex.getStackTraceString());
                requestOut.Isis_Error__c = ex.getMessage() +'\n'+ex.getStackTraceString(); 
                //upsert requestOut;
             }*/
       }
        catch(Exception ex){
            result = 'Exception occurred Please see Error : ' + ex.getMessage(); 
            system.debug('### Tracker exception: '+ex.getMessage()+ '\n' +ex.getStackTraceString());
            requestOut = new Oracle_Data_Tracker__c(Direction__c = EON_Utility.DIRECTION_OUT, Status__c = EON_Utility.RESULT_FAIL);
            String errMsg = ''; 
            errMsg = ex.getMessage() + ex.getStackTraceString() + '\n' + response; 
            if(errMsg.length() > 131072) requestOut.Response_Data__c = errMsg.substring(0, 131072);
            else 
              requestOut.Response_Data__c = errMsg;
            //insert requestOut;
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
    public PageReference ProcessAppointment(){
        String allAppID = '';
        if(string.isNotBlank(AllApptID)){
            list<String> listAppt = new list<String>();
            listAppt = AllApptID.split(',');
            /*if(listAppt.isEmpty()){
                allAppID = '\''+AllApptID+'\'';
                listAppt.add(AllApptID);
            }*/
            //else{
                for(String str:listAppt){
                    allAppID += String.isBlank(allAppID) ? '\''+str+'\'' : ',\''+str+'\'';
                }
            //}
            EON_Process_Bulk_Appointment_Batch batchJob = new EON_Process_Bulk_Appointment_Batch();
      batchJob.allAppointment = listAppt;
            batchJob.query = 'Select ID, Name, Planned_E_Meter_Type__c, Metering_Point_Address_Line_7__c, h_Job_Type__c, Metering_Point_Address_Line_8__c, Metering_Point_Address_Line_9__c, Planned_Meter_Registers__c, Job_code__c, Job_code__r.Name, Job_Code__r.Job_Type__c, Metering_Pressure__c, Number_of_Phases__c, Planned_G_Meter_Type__c, Planned_Meter_Mode__c, Gas_bind_performed_flag__c, Install_SED_flag__c, Assisted_Work_Reason__c, Job_code__r.h_Job_Attribute_Duration__c, Job_code__r.Duration__c, Time_Slot__c,Start_Time__c, End_Time__c, Appointment_Date__c, Caller_Name__c, Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c, Notes__c, Booking_System_Name__c, EON_Appointment_ID__c, Parking_Type__c, Parking_Type__r.OFS_Enumeration__c, Access_Pass_Phrase__c, Appointment_reason_code__c, Appointment_reason_code__r.OFS_Enumeration__c, h_OFSC_Assisted_Work_Reason_Code__c, Contact_Name__c, Oracle_Postcode_Sector__c, Additional_Information__c,MPAN__c, MPRN__c, h_OFSC_Metering_Pressure__c, h_OFSC_Number_of_Phases__c, E_Meter_Serial_Number__c, E_Meter_Type__c, E_Meter_Location__c, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Register_1_ID__c, E_Meter_Register_2_ID__c, E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c, E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c, Certification_Date__c, Certification_Expiry_Date__c, G_Meter_Serial_Number__c, G_Meter_Mechanism__c, G_Meter_Location__c, h_G_MeterMake_Enum_Mapping__c, G_Meter_Model__c, E_Check_Meter_Serial_Number__c, E_Check_Meter_Make__c, E_Check_Meter_Model__c, G_Check_Meter_Make__c, G_Check_Meter_Model__c, G_Check_Meter_Location__c, G_Check_Meter_Serial_Number__c, Expected_Comms_Hub_Serial_Number__c, Expected_IHD_Serial_Number__c, h_OFSC_Planned_E_Meter_Type__c, h_OFSC_Planned_G_Meter_Type__c, h_OFSC_Planned_Meter_Registers__c, Requested_SSC__c, Planned_Number_of_Registers__c, h_OFSC_Planned_Meter_Mode__c, h_OFSC_Gas_bind_performed_flag__c, h_OFSC_Install_SED_flag__c, Key_Collection_Required__c, Customer_Name__c, Key_Person_Name__c, Key_Building_Name__c, Key_Building_Number__c, Key_Sub_Building_Name__c, Key_Thorofare__c, Key_Dependant_Thorofare__c, Key_Dependant_Locality__c, Key_Town__c, Key_County__c, Key_Post_Code__c, Key_Contact_Number__c, Specific_Time_flag__c, Customer_Preferred_Contact_Method__c, Contact_Email__c  from EON_Appointment__c where name in ('+allAppID+')';
            batchJob.emailToNotify = System.Label.Appointment_Utility_Email;
            ID processJob = Database.executeBatch(batchJob, 1);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter MUS Appointment ID(s).'));
                return null;
        }
        return null;
    }
}