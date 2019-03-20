/**
    Description: This class used to generate a WSDL for the create electricity job in Isis. This WSDL will be consumed by JUMBO and 
                send job information, as part of this an app record will be created.
    Test Class :  EON_JUMBO_Create_ElecJob_In_Isis_WS_Test
**/
/*
    Created By : Praveen G
    Created Date : 02-March-2016
    Service Request : SR_EON_Jumbo_002
    Change History 
    CH01 # SR_EON_Jumbo_020 # 19/04/2016 # Purvi # added code to achieve SR functionality
    CH02 # SR_EON_Jumbo_033 # 30/05/2016 # Aruna Manjari # Replaced field  name with Jumbo_Job_Code__c while quering EON_Job__c.
    CH03 # SR_EON_Jumbo_041 # 08/07/2016 # Mehboob Alam # Change the format coming as HHMMSS to HH:MM
    CH04 # SR_EON_Jumbo_046 # 25/07/2016 # Mahadev Joshilkar # Mapped Appointment Reason Code with Jumbo Code and Customer Name to Caller Name.
    CH05 # SR_EON_Jumbo_039 # 29/07/2016 # Mehboob Alam # Added new EON Appointment Contact record. 
    CH06 # SR_EON_JUMBO_047 # 01/08/2016 # Mahadev Joshilkar # Mapping for JUMBO Vulnerability Code with EON Vulnerability Code
    CH07 # SR_EON_Jumbo_061 # 27/08/2016 # Mahadev Joshilkar # Added new paramters in WSDL - Requested SSC
    CH08 # SR_EON_Jumbo_063 # 31/08/2016 # Mahadev Joshilkar # Popuplate 'Confirmed Appointment DateTime' with default current time
    CH09 # SR_EON_Jumbo_062 # 01/09/2016 # Mahadev Joshilkar # Validation to restrict appointment creation if 'Effective To Date' is before 'Appointment Date'
	CH10 # SR_EON_Jumbo_089 # 08/12/2016 # Mahadev J # Mapping for Time_Slot__c
	CH11 # SR_EON_Jumbo_098 # 16/01/2017 # Mahadev J # Improved logic to create - EON Appointment Contacts
*/
global with sharing class EON_JUMBO_Create_ElecJob_In_Isis_WS {
    /**
     Description : Request Parameter
    **/
    global with sharing class ElecWorkRequest {
        Webservice String MPAN;
        Webservice Date RequestDate;
        Webservice String RequestTime;
        Webservice Date EarliestStartDate;
        Webservice String EarliestStartTime;
        Webservice Date LatestStartDate;
        Webservice String LatestStartTime;
        Webservice String JUMBOJobType;
        Webservice String JUMBOID;
        Webservice String AdditionalInformation;
        Webservice String RequestedSSC;
    }
    /**
     Description : Response
    **/
    global with sharing class JumboToIsisElecWorkResponse {
        Webservice String Success;
        Webservice String Message;
        Webservice String ExternalJobReference;
    }
    /**
    createElectricityJobInIsis(ElecWorkRequest elecRequest) - This method is used to create an app record in Isis.
    **/
    webservice static JumboToIsisElecWorkResponse createElectricityJobInIsis(ElecWorkRequest elecRequest) {
        JumboToIsisElecWorkResponse response = new JumboToIsisElecWorkResponse();
        JUMBO_Data_Tracker__c pTracker = new JUMBO_Data_Tracker__c();
        list < JUMBO_Data_Tracker__c > cTracker;
        EON_appointment__c appJob = new EON_appointment__c();
        EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
        List < EON_Media_Type__c > lMediaType = new List < EON_Media_Type__c > ();
        List < EON_Job__c > jCode = new List < EON_Job__c > ();
        Map < string, EON_Vulnerability_Code__c > eonVulnerabilityCode = new Map < string, EON_Vulnerability_Code__c > (); //CH06.New
        //tracker information
        pTracker.Direction__c = EON_Utility.DIRECTION_IN;
        pTracker.Command__c = JUMBO_Utility.CMD_JUMBO_CEJ;
        pTracker.Status__c = EON_Utility.RESULT_PASS;
        String result = '';
        Date effectiveFrom, effectiveTo; //CH09
        try {
            cTracker = new list < JUMBO_Data_Tracker__c > (); //CH09.New
            if (!EON_Utility.validateRequired(elecRequest)) {
                pTracker.Request_Data__c = string.valueOf(elecRequest);
                //Validate the request for required fields.
                if (EON_Utility.validateRequired(elecRequest.MPAN))
                    result = result + 'Mandatory field MPAN is missing.\n';
                if (EON_Utility.validateRequired(elecRequest.earliestStartDate))
                    result = result + 'Mandatory field EarliestStartDate is missing.\n';
                if (EON_Utility.validateRequired(elecRequest.JUMBOID))
                    result = result + 'Mandatory field JUMBOID is missing.\n';
                if (EON_Utility.validateRequired(elecRequest.JUMBOJobType))
                    result = result + 'Mandatory field JUMBOJobType is missing.\n';
                else {
                    jCode = [select id, h_Appointment_Reason_Code__c from EON_Job__c where Jumbo_Job_Code__c = :elecRequest.JUMBOJobType limit 1]; //CH02, CH04
                    if (jCode.isEmpty())
                        result = result + 'Job type is not found.\n';
                }
                //CH09.New.Start
                if (!EON_Utility.validateRequired(elecRequest.MPAN)) {
                    EON_Jumbo_ReqElectricityMOP.MOPValidationResponse mopResponse = EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP(elecRequest.MPAN);	//TODO	//Call EON_MDS_ReqElectricityMOP
                    if (!EON_Utility.validateRequired(mopResponse)) {
                        cTracker.add(EON_Jumbo_ReqElectricityMOP.cTrack);	//TODO	//Call EON_MDS_ReqElectricityMOP
                        system.debug('###EmarParticipantId: ' + mopResponse.marParticipantId);
                        system.debug('###EffToDate: ' + mopResponse.effToDate);
                        system.debug('###EarlyEffToDate: ' + elecRequest.earliestStartDate);
                        if (!EON_Utility.validateRequired(mopResponse.effToDate) && !EON_Utility.validateRequired(elecRequest.earliestStartDate)) {
                            if (mopResponse.effToDate < elecRequest.earliestStartDate)
                                result = result + 'Appointment Earliest Start Date should be before MOP Effective To date.\n';
                        }
                        if (!EON_Utility.validateRequired(mopResponse.effToDate))
                            effectiveTo = mopResponse.effToDate;
                        if (!EON_Utility.validateRequired(mopResponse.effFromDate))
                            effectiveFrom = mopResponse.effFromDate;
                    }
                }
                //CH09.New.End
            } else
                result = 'No Request found (Request is null)';
            //Processing request if requestus is not null     
            if (EON_Utility.validateRequired(result)) {
                //Calling RequestElectricityMeterPointData to get industry data for MPAN
                EON_Jumbo_ReqElecMeterPointData.AccessElecMeterPointData(elecRequest.MPAN, appJob, '', '');		//TODO.Start	//Call EON_MDS_ReqElecMeterPointData
                //cTracker = new JUMBO_Data_Tracker__c(); //CH09.Old
                //cTracker = EON_Jumbo_ReqElecMeterPointData.cTrack; //CH09.Old
                cTracker.add(EON_Jumbo_ReqElecMeterPointData.cTrack); //CH09.New
                if (!EON_Jumbo_ReqElecMeterPointData.isError) {
                    appJob = EON_Jumbo_ReqElecMeterPointData.apptIns; //assigning values to Appointment instance	//TODO.End
                    if (!EON_Utility.validateRequired(effectiveTo)){appJob.Effective_To_Date__c = effectiveTo;} //CH09
                    if (!EON_Utility.validateRequired(effectiveFrom)){appJob.Effective_From_Date__c = effectiveFrom;} //CH09
                    if (EON_Utility.validateRequired(appJob.Metering_Point_Postcode__c))
                        result = result + 'Post code is missing.\n';
                    if (EON_Utility.validateRequired(appJob.Metering_Point_Address_Line_1__c) && EON_Utility.validateRequired(appJob.Metering_Point_Address_Line_2__c) && EON_Utility.validateRequired(appJob.Metering_Point_Address_Line_3__c) && EON_Utility.validateRequired(appJob.Metering_Point_Address_Line_4__c) && EON_Utility.validateRequired(appJob.Metering_Point_Address_Line_5__c))
                        result = result + 'Metering Address is missing.\n';
                    if (EON_Utility.validateRequired(result)) {
                        appJob.MPAN__c = elecRequest.MPAN;
                        appJob.Request_Date__c = elecRequest.requestDate;
                        if (!EON_Utility.validateRequired(JUMBO_Utility.StringToTime(elecRequest.requestTime)))
                            appJob.Request_Time__c = JUMBO_Utility.StringToTime(elecRequest.requestTime); //CH03
                        appJob.appointment_Date__c = elecRequest.earliestStartDate;
                        if (!EON_Utility.validateRequired(JUMBO_Utility.StringToTime(elecRequest.earliestStartTime)))
                            appJob.Start_Time__c = JUMBO_Utility.StringToTime(elecRequest.earliestStartTime); //CH03
                        appJob.End_appointment_Date__c = elecRequest.LatestStartDate;
                        if (!EON_Utility.validateRequired(JUMBO_Utility.StringToTime(elecRequest.LatestStartTime)))
                            appJob.End_Time__c = JUMBO_Utility.StringToTime(elecRequest.LatestStartTime); //CH03
                        if(!EON_Utility.validateRequired(JUMBO_Utility.StringToTime(elecRequest.earliestStartTime)) && !EON_Utility.validateRequired(JUMBO_Utility.StringToTime(elecRequest.LatestStartTime)))
                            appJob.Time_Slot__c = JUMBO_Utility.StringToTime(elecRequest.earliestStartTime) +' - '+ JUMBO_Utility.StringToTime(elecRequest.LatestStartTime); //CH10.New
                        appJob.JUMBO_ID__c = elecRequest.JUMBOID;
                        appJob.Notes__c = elecRequest.AdditionalInformation;
                        appJob.Job_Code__c = jCode[0].id;
                        //CH04.New.Start
                        if (!EON_Utility.validateRequired(jCode[0].h_Appointment_Reason_Code__c)) {
                            Eon_Appointment_Reason__c appReasonCode = [Select id from Eon_Appointment_Reason__c where name = : jCode[0].h_Appointment_Reason_Code__c];
                            appJob.Appointment_reason_code__c = appReasonCode.ID;
                        }
                        appJob.Caller_Name__c = appJob.Customer_Name__c;
                        //CH04.New.End
                        appJob.Parking_Type__c = [select id from EON_Parking__c where Parking_Code__c = 'O'
                            limit 1
                        ].id; //Static Data
                        //CH07.New.Start   
                        if (!EON_Utility.validateRequired(elecRequest.RequestedSSC))
                            appJob.Requested_SSC__c = elecRequest.RequestedSSC;
                        //CH07.New.End
                        //CH05.Start
                        appJob.Booking_System_Name__c = JUMBO_Utility.BookingSystemName;
                        appCon.Contact_Type__c = [select id from EON_Contact_Type__c where Code__c = 'A' limit 1].id; //Static Data
                        if (!EON_Utility.validateRequired(appJob.Customer_Preferred_Contact_Method__c)) {
                            if (!EON_Utility.validateRequired(mediaType(appJob.Customer_Preferred_Contact_Method__c)))
                                lMediaType = [select id from EON_Media_Type__c where code__c = : mediaType(appJob.Customer_Preferred_Contact_Method__c) limit 1];
                            if (!lMediaType.isEmpty())
                                appCon.Media_Type__c = lMediaType[0].id;
                            if (!EON_Utility.validateRequired(mediaDetails(appJob)))
                                appCon.Media_Detail__c = mediaDetails(appJob);
                        }
                        else{ //CH11.New
                            lMediaType = [select id from EON_Media_Type__c where Name = 'Telephone' limit 1];
                            if(!lMediaType.isEmpty())
                                appCon.Media_Type__c = lMediaType[0].id;
                            if(!EON_Utility.validateRequired(appJob.Contact_Telephone_Number__c))
                                appCon.Media_Detail__c = appJob.Contact_Telephone_Number__c;
                            else 
                                appCon.Media_Detail__c = '0151 541 6563';
                        }
                        if (!EON_Utility.validateRequired(appJob.Contact_Name__c))
                            appCon.Contact_Full_Name__c = appJob.Contact_Name__c;
                        //CH05.End
                        appjob.Confirmed_Appointment_DateTime__c = system.now(); //CH08.New
                        insert appJob;
                        appCon.EON_Appointment_ID__c = appJob.id; //CH05
                        insert appCon; //CH05 
                        //CH06.Start
                        if (!EON_Utility.validateRequired(EON_Jumbo_ReqElecMeterPointData.eonVulnerabilityCode)) {	//TODO		//Call EON_MDS_ReqElecMeterPointData
                            eonVulnerabilityCode = EON_Jumbo_ReqElecMeterPointData.eonVulnerabilityCode;	//TODO		//Call EON_MDS_ReqElecMeterPointData
                            if (!eonVulnerabilityCode.isEmpty()) {
                                list < EON_Appointment_Vulnerability__c > appVulnerability = new list < EON_Appointment_Vulnerability__c > ();
                                for (EON_Vulnerability_Code__c code: eonVulnerabilityCode.values()) {
                                    EON_Appointment_Vulnerability__c appVul = new EON_Appointment_Vulnerability__c();
                                    appVul.Description__c = code.Id;
                                    appVul.EON_Appointment_ID__c = appJob.ID;
                                    appVulnerability.add(appVul);
                                }
                                if (!appVulnerability.isEmpty())
                                    insert appVulnerability;
                            }
                        }
                        //CH06.End 
                        //sending success response 
                        response.success = EON_Utility.RESULT_PASS;
                        response.externalJobReference = [select name from EON_appointment__c where id = : appJob.id].Name;
                    }
                } else
                    result = EON_Jumbo_ReqElecMeterPointData.Errors;	//TODO		//Call EON_MDS_ReqElecMeterPointData
            }
        } catch (Exception ex) {
            result = 'An Unknown error has occurred while processing this request. Please contact to System Administrator';
            pTracker.Status__c = EON_Utility.RESULT_FAIL;
            pTracker.Response_Data__c = ex.getMessage() + '\n' + ex.getStackTraceString() + '\n' + ex.getLineNumber();
        } finally {
            //This is error message block
            if (!EON_Utility.validateRequired(result)) {
                response.success = EON_Utility.RESULT_FAIL;
                response.message = result;
            }

            //Inserting parent tracker values
            pTracker.Response_Data__c = string.valueOf(response) + '\n' + (!EON_Utility.validateRequired(pTracker.Response_Data__c) ? pTracker.Response_Data__c : '');
            if (!EON_Utility.validateRequired(appJob.id))
                pTracker.EON_Appointment__c = appJob.id;
            insert pTracker;

            //CH01.Start
            //Inserting child tracker record 
            if (!EON_Utility.validateRequired(cTracker)) {
                list < JUMBO_Data_Tracker__c > createChildTracker = new list < JUMBO_Data_Tracker__c > ();
                /* CH09.Old.Start
                 cTracker.JUMBO_Data_Tracker__c = pTracker.id;
                 if(!EON_Utility.validateRequired(appJob.id))
                     cTracker.EON_Appointment__c = appJob.id;
                 insert cTracker;
                CH09.Old.End*/
                for (JUMBO_Data_Tracker__c jtrack: cTracker) {
                    jtrack.JUMBO_Data_Tracker__c = pTracker.id;
                    if (!EON_Utility.validateRequired(appJob.id))
                        jtrack.EON_Appointment__c = appJob.id;
                    createChildTracker.add(jtrack);
                }
                if (!createChildTracker.isEmpty())
                    insert createChildTracker;
                if (!EON_Utility.validateRequired(appJob.id))
                //EON_Utility.callOFSCAppointment(String.valueOf(appJob.id),'CREATE','',String.valueOf(pTracker.id),'JUMBO',String.valueOf(appJob.appointment_Date__c),appJob.Request_Time__c);
                    EON_Utility.callOFSCAppointment(String.valueOf(appJob.id), 'CREATE', '', String.valueOf(pTracker.id), String.valueOf(appJob.appointment_Date__c), appJob.Request_Time__c, 'JUMBO');
            }
            //CH01.End
        }
        return response;

    }
    //CH05.Start
    /** 
        string mediaType(string mType): Method to return Contact Media Type.
    **/
    public static string mediaType(string mType) {
        if (mType == 'H' || mType == 'W' || mType == 'L') return 'T';
        if (mType == 'T') return 'M';
        if (mType == 'E') return 'E';
        return null;
    }

    /** 
    string mediaDetails(EON_appointment__c eApp): Method to return Contact Media Details. 
    **/
    public Static string mediaDetails(EON_appointment__c eApp) {
        if (eApp.Customer_Preferred_Contact_Method__c == 'H' || eApp.Customer_Preferred_Contact_Method__c == 'W' || eApp.Customer_Preferred_Contact_Method__c == 'T')
            return eApp.Contact_Telephone_Number__c;
        if (eApp.Customer_Preferred_Contact_Method__c == 'E')
            return eApp.Contact_Email__c;
        if (eApp.Customer_Preferred_Contact_Method__c == 'L') {
            string custAdd = '';
            if (!EON_Utility.validateRequired(eApp.Priority_Service_Contact_Address_Line_1__c))
                custAdd = eApp.Priority_Service_Contact_Address_Line_1__c + ';';
            if (!EON_Utility.validateRequired(eApp.Priority_Service_Contact_Address_Line_2__c))
                custAdd = custAdd + eApp.Priority_Service_Contact_Address_Line_2__c + ';';
            if (!EON_Utility.validateRequired(eApp.Priority_Service_Contact_Address_Line_3__c))
                custAdd = custAdd + eApp.Priority_Service_Contact_Address_Line_3__c + ';';
            if (!EON_Utility.validateRequired(eApp.Priority_Service_Contact_Address_Line_4__c))
                custAdd = custAdd + eApp.Priority_Service_Contact_Address_Line_4__c + ';';
            if (!EON_Utility.validateRequired(eApp.Priority_Service_Contact_Address_Line_5__c))
                custAdd = custAdd + eApp.Priority_Service_Contact_Address_Line_5__c + ';';
            if (!EON_Utility.validateRequired(eApp.Priority_Service_Contact_Address_Line_6__c))
                custAdd = custAdd + eApp.Priority_Service_Contact_Address_Line_6__c + ';';
            if (!EON_Utility.validateRequired(eApp.Priority_Service_Contact_Address_Line_7__c))
                custAdd = custAdd + eApp.Priority_Service_Contact_Address_Line_7__c + ';';
            if (!EON_Utility.validateRequired(eApp.Priority_Service_Contact_Address_Line_8__c))
                custAdd = custAdd + eApp.Priority_Service_Contact_Address_Line_8__c + ';';
            if (!EON_Utility.validateRequired(eApp.Priority_Service_Contact_Address_Line_9__c))
                custAdd = custAdd + eApp.Priority_Service_Contact_Address_Line_9__c + ';';
            return custAdd;
        }
        return null;
    }
    //CH05.End
}