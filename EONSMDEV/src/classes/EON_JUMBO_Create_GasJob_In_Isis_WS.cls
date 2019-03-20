/**
    Description: This class used to generate a WSDL for the create Gas job in Isis. This WSDL will be consumed by JUMBO and
                send job information, as part of this an Appointment record will be created.
    Test Class :  EON_JUMBO_Create_GasJob_In_Isis_WS_Test
**/
/*
    Created By : Praveen G
    Created Date : 16-March-2016
    Service Request : SR_EON_Jumbo_010
    Change History : 
    CH01 # SR_EON_Jumbo_022 # 19/04/2016 # Aruna Manjari # added code to achieve SR functionality.
    CH02 # SR_EON_Jumbo_041 # 08/07/2016 # Mehboob Alam # Change the format coming as HHMMSS to HH:MM
    CH03 # SR_EON_Jumbo_046 # 25/07/2016 # Mahadev Joshilkar # Mapped Appointment Reasson Code with Jumbo Code.
    CH04 # SR_EON_Jumbo_063 # 31/08/2016 # Mahadev Joshilkar # Popuplate 'Confirmed Appointment DateTime' with default current time
    CH05 # SR_EON_Jumbo_062 # 03/09/2016 # Mahadev Joshilkar # Validation to restrict appointment creation if 'Effective To Date' is before 'Appointment Date'
	CH06 # SR_EON_Jumbo_089 # 08/12/2016 # Mahadev J # Mapping for Time_Slot__c
*/
global with sharing class EON_JUMBO_Create_GasJob_In_Isis_WS{

    /**
        Description : Request Parameter
    **/
    global with sharing class GasWorkRequest{
        Webservice String MPRN;
        Webservice Date RequestDate;
        Webservice String RequestTime;
        Webservice Date EarliestStartDate;
        Webservice String EarliestStartTime;
        Webservice Date LatestStartDate;
        Webservice String LatestStartTime;
        Webservice String JUMBOJobType;
        Webservice String JUMBOID; 
        Webservice String AdditionalInformation;
    }

    /**
        Description : Response
    **/
    global with sharing class JumboToIsisGasWorkResponse{
        Webservice String Success;
        Webservice String Message;
        Webservice String ExternalJobReference;
    }  

    /**
        createGasJobInIsis(GasorkRequest gasRequest) - 
                This method is used to create an Appointment record in Isis.
    **/
    webservice static JumboToIsisGasWorkResponse createGasJobInIsis(GasWorkRequest gasRequest){
        JumboToIsisGasWorkResponse response = new JumboToIsisGasWorkResponse();
        JUMBO_Data_Tracker__c pTracker = new JUMBO_Data_Tracker__c();
        list<JUMBO_Data_Tracker__c> cTracker ; //CH05.New
        //JUMBO_Data_Tracker__c cTracker ;
        EON_appointment__c appJob = new EON_appointment__c();
        List<EON_Job__c> jCode = new List<EON_Job__c>();
        //tracker information
        pTracker.Direction__c = EON_Utility.DIRECTION_IN;
        pTracker.Command__c = JUMBO_Utility.CMD_JUMBO_CGJ; 
        pTracker.Status__c = EON_Utility.RESULT_PASS;       
        String result = '';
        Date effectiveFrom, effectiveTo;//CH05
        try{
            if(!EON_Utility.validateRequired(gasRequest)){
                cTracker = new list<JUMBO_Data_Tracker__c>(); //CH05.New
                pTracker.Request_Data__c = string.valueOf(gasRequest);
                //validate the request for required fields.
                if(EON_Utility.validateRequired(gasRequest.MPRN))
                    result = result + 'Mandatory field MPRN is missing.\n';   
                if(EON_Utility.validateRequired(gasRequest.earliestStartDate))
                    result = result + 'Mandatory field EarliestStartDate is missing.\n';  
                if(EON_Utility.validateRequired(gasRequest.JUMBOID))
                    result = result + 'Mandatory field JUMBOID is missing.\n';
                if(EON_Utility.validateRequired(gasRequest.JUMBOJobType))
                    result = result + 'Mandatory field JUMBOJobType is missing.\n';
                else{
                    jCode = [select id, h_Appointment_Reason_Code__c from EON_Job__c where Jumbo_Job_Code__c=:gasRequest.JUMBOJobType limit 1]; //CH03
                    if(jCode.size()==0)
                        result = result + 'Job type is not found.\n';
                }
                //CH05.New.Start
                if(!EON_Utility.validateRequired(gasRequest.MPRN)){
                    EON_Jumbo_ReqGasMAM.MAMValidationResponse mamResponse = EON_Jumbo_ReqGasMAM.ValidateMPRNMAM(gasRequest.MPRN);	//TODO.Start	//Call EON_Jumbo_ReqGasMAM
                    if(!EON_Utility.validateRequired(mamResponse)){
                        cTracker.add(EON_Jumbo_ReqGasMAM.cTrack);		//TODO.End
                        if(!EON_Utility.validateRequired(mamResponse.effToDate) && !EON_Utility.validateRequired(gasRequest.earliestStartDate)){
                            if(mamResponse.effToDate < gasRequest.earliestStartDate)
                                result = result + 'Appointment Earliest Start Date should be before MAM Effective To date.\n';
                        }
                        if(!EON_Utility.validateRequired(mamResponse.effToDate))
                            effectiveTo = mamResponse.effToDate;
                        if(!EON_Utility.validateRequired(mamResponse.effFromDate))
                            effectiveFrom = mamResponse.effFromDate;
                    }
                }
                //CH05.New.End
            }
            else
                result = 'No Request found (Request is null)';
            //Processing request if requestus is not null
            if(EON_Utility.validateRequired(result)){
                //calling RequestElectricityMeterPointData to get industry data for MPRN
                EON_Jumbo_ReqGasMeterPointData.AccessGasMeterPointData(gasRequest.MPRN,appJob,'','');		//TODO.Start	//Call EON_Jumbo_ReqGasMeterPointData
                //cTracker = new JUMBO_Data_Tracker__c(); //CH05.Old
                //cTracker = EON_Jumbo_ReqGasMeterPointData.cTrack; //CH05.Old
                cTracker.add(EON_Jumbo_ReqGasMeterPointData.cTrack);
                if(!EON_Jumbo_ReqGasMeterPointData.isError){
                    appJob =  EON_Jumbo_ReqGasMeterPointData.apptIns; //assigning values to Appointmen instance		//TODO.End
                    if(!EON_Utility.validateRequired(effectiveTo))//CH05
                        appJob.G_Effective_To_Date__c = effectiveTo;//CH05
                    if(!EON_Utility.validateRequired(effectiveFrom))//CH05
                        appJob.G_Effective_From_Date__c = effectiveFrom;//CH05
                    if(EON_Utility.validateRequired(appJob.Post_Code__c))
                        result = result +'Post code is missing.\n';
                    if(EON_Utility.validateRequired(appJob.Thorofare__c) && EON_Utility.validateRequired(appJob.Building_Name__c) && EON_Utility.validateRequired(appJob.Dependent_Thorofare__c))
                        result =result +'Address is missing.\n';
                    if(EON_Utility.validateRequired(result)){
                        appJob.MPRN__c = gasRequest.MPRN;
                        appJob.Request_Date__c  = gasRequest.requestDate;
                        if(!EON_Utility.validateRequired(JUMBO_Utility.StringToTime(gasRequest.requestTime)))
                            appJob.Request_Time__c = JUMBO_Utility.StringToTime(gasRequest.requestTime);//CH02
                        appJob.appointment_Date__c = gasRequest.earliestStartDate;
                        if(!EON_Utility.validateRequired(JUMBO_Utility.StringToTime(gasRequest.earliestStartTime)))
                            appJob.Start_Time__c = JUMBO_Utility.StringToTime(gasRequest.earliestStartTime);//CH02
                        appJob.End_appointment_Date__c = gasRequest.LatestStartDate;
                        if(!EON_Utility.validateRequired(JUMBO_Utility.StringToTime(gasRequest.LatestStartTime)))
                            appJob.End_Time__c = JUMBO_Utility.StringToTime(gasRequest.LatestStartTime);//CH02
                        if(!EON_Utility.validateRequired(JUMBO_Utility.StringToTime(gasRequest.earliestStartTime)) && !EON_Utility.validateRequired(JUMBO_Utility.StringToTime(gasRequest.LatestStartTime)))
							appJob.Time_Slot__c = JUMBO_Utility.StringToTime(gasRequest.earliestStartTime) +' - '+JUMBO_Utility.StringToTime(gasRequest.LatestStartTime); //CH06.New
                        appJob.JUMBO_ID__c = gasRequest.JUMBOID; 
                        appJob.Notes__c = gasRequest.AdditionalInformation;
                        appJob.Job_Code__c = jCode[0].id;
                        appJob.Booking_System_Name__c =JUMBO_Utility.BookingSystemName;
                        //CH04.New.Start
                        if(!EON_Utility.validateRequired(jCode[0].h_Appointment_Reason_Code__c)){
                            Eon_Appointment_Reason__c appReasonCode = [Select id from Eon_Appointment_Reason__c where name=:jCode[0].h_Appointment_Reason_Code__c];
                            appJob.Appointment_reason_code__c = appReasonCode.ID;
                        }
                        //CH04.New.End
                        appJob.Parking_Type__c=[select id from EON_Parking__c where Parking_Code__c='O' limit 1].id; 
                        appjob.Confirmed_Appointment_DateTime__c = system.now(); //CH04.New
                        insert appJob;
                        //sending success response 
                        response.success = EON_Utility.RESULT_PASS;
                        response.externalJobReference = [select name from EON_appointment__c where id =: appJob.id].Name;
                    }
                }
                else
                    result = EON_Jumbo_ReqGasMeterPointData.Errors;		//TODO		//Call EON_Jumbo_ReqGasMeterPointData
            }
        } 
        catch(Exception ex){ 
            system.debug('##ErrorException: '+ex.getMessage());
            result = 'An Unknown error has occurred while processing this request. Please contact to System Administrator';
            pTracker.Status__c = EON_Utility.RESULT_FAIL;
            pTracker.Response_Data__c = ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber();
        }
        finally{
            //This is error message block
            if(!EON_Utility.validateRequired(result)){
                response.success = EON_Utility.RESULT_FAIL;
                response.message = result;   
            }
            //Inserting parent tracker values
            pTracker.Response_Data__c = string.valueOf(response)+'\n'+(!EON_Utility.validateRequired(pTracker.Response_Data__c)?pTracker.Response_Data__c:'');
            if(!EON_Utility.validateRequired(appJob.id))
                pTracker.EON_Appointment__c = appJob.id;
            insert pTracker;
            //CH01.Start
            //Inserting child tracker record
            if(!EON_Utility.validateRequired(cTracker)){
                /* CH05.Old.Start
                cTracker.JUMBO_Data_Tracker__c = pTracker.id;
                if(!EON_Utility.validateRequired(appJob.id))
                    cTracker.EON_Appointment__c = appJob.id;
                insert cTracker;
                CH05.Old.End*/
                //CH05.New.Start
                list<JUMBO_Data_Tracker__c> createChildTracker = new list<JUMBO_Data_Tracker__c>();
                for(JUMBO_Data_Tracker__c jtrack:cTracker){
                    jtrack.JUMBO_Data_Tracker__c = pTracker.id;
                    if(!EON_Utility.validateRequired(appJob.id))
                        jtrack.EON_Appointment__c = appJob.id;
                    createChildTracker.add(jtrack);
                }
                if(!createChildTracker.isEmpty())
                    insert createChildTracker;
                //CH05.New.End
                if(!EON_Utility.validateRequired(appJob.id))
                    EON_Utility.callOFSCAppointment(String.valueOf(appJob.id),'CREATE','',String.valueOf(pTracker.id),String.valueOf(appJob.appointment_Date__c),appJob.Request_Time__c,'JUMBO');
            }
            //CH01.End
        }
        return response;
    }
}