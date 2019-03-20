/**
    Description : This class will be used for generating WSDL, so that EON can use this WSDL to Confirm CancelBooking in Isis.
                                    
    Test Class  : EON_CancelAppointment_In_Isis_test

**/
/*
    Created By  : Akshay Bairagi
    Created On  : 15/03/2016
    Service Req : SR_EON_AB_017
    Change History
    CH01 # SR_EON_AB_143 # 13-09-2016 # Mahadev J # Populating 'EON Appointment' reference at 'EON Data Tracker'
    CH02 # SR_EON_AB_163 # 12-10-2016 # Akshay Bairagi # Already cancelled in OFSC cancel in OPTIMUS
    CH03 # SR_EON_AB_166 # 14-10-2016 # Mahadev J # Cancellation processing at Oracle should be on hold if appointment not created in OFSC via CreateReservation call by EON. Code clean up done.
    CH04 # SR_EON_AB_209 # 14-03-2017 # Praveen G # validate the Appointment status.
    CH05 # SR_EON_AB_216 # 31/03/2017 # Heena C # Added the logic as per the SR requirement.
*/
global with sharing class EON_CancelAppointment_In_Isis_WS {
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class HeaderElement{  
        Webservice String OrgId ;
        Webservice String RequestId ;
        Webservice datetime RequestDateTime ;
    }
    /**
        Description : Request Parameter 2 
    **/
    global with sharing class AppointmentDetailElement{  
        Webservice String ExternalAppointmentID;
        Webservice String EONAppointmentID ;
        Webservice String CancelReasonCode ;
        Webservice datetime CancellationDateTime ;
    }
    /**
        Description : Request Parameter 3
    **/
    global with sharing class CancelBooking {  
        Webservice HeaderElement Header;
        Webservice AppointmentDetailElement AppointmentDetails ;
    }  
    /**
        Description : Response 1
    **/
    global with sharing class errMessage {
        Webservice String MessageType ;
        Webservice integer MessageId ;
        Webservice String MessageText ;
    }
    /**
        Description : Response 2
    **/
    global with sharing class errMessageLst {
        Webservice list<errMessage> Message;
    }
    /**
        Description : Response 3
    **/
    global with sharing class Isis_Response_Acknowledgement_To_EON{
        Webservice HeaderElement Header ;
        Webservice errMessageLst Messages ;
    }   
    /**
        Isis_Response_Acknowledgement_To_EON CancelAppointment (CancelAppointment  CancelBooking) - 
                This method is used to get create CancelBooking from Isis.
    **/
    webservice static Isis_Response_Acknowledgement_To_EON CancelAppointment(CancelBooking CancelBooking){ 
        Isis_Response_Acknowledgement_To_EON response = new Isis_Response_Acknowledgement_To_EON();
        errMessageLst errorlst = new errMessageLst();
        EON_Data_Tracker__c eonTracker = new EON_Data_Tracker__c();
        eonTracker.Direction__c = EON_Utility.DIRECTION_IN;
        eonTracker.Command__c = EON_Utility.CMD_EON_Cancel;
        boolean pendingCancellation = false;
        list<errMessage> msgLst = new list<errMessage>();
        string Error = '';
        String eonTrackerID = '';
        Oracle_Data_Tracker__c oracleTracker = new Oracle_Data_Tracker__c();
        EON_Appointment__c appt = new EON_Appointment__c();
        list<EON_Appointment__c> appLst = new list<EON_Appointment__c>();
        list<EON_Appointment_Cancel_Reason__c> RCode = new list<EON_Appointment_Cancel_Reason__c>();
        try{
            if(CancelBooking != null){
                eonTracker.Request_Data__c = EON_Utility.validateStringLength(CancelBooking + '');                                                                                             
                eonTracker.Transaction_ID__c = CancelBooking.header.requestId;
                if(EON_Utility.validateRequired(CancelBooking.Header.orgId) == true)
                    Error = 'OrgId cannot be blank\n';
                if(EON_Utility.validateRequired(CancelBooking.Header.requestId) == true)
                    Error = Error + 'RequestId cannot be blank\n';
                if(EON_Utility.validateRequired(CancelBooking.Header.RequestDateTime) == true)
                    Error = Error + 'RequestDateTime cannot be blank\n';
                if(EON_Utility.validateRequired(CancelBooking.AppointmentDetails.ExternalAppointmentID) == true)
                    Error = Error + 'ExternalAppointmentID cannot be blank\n';
                else{
                    appLst = [select id, name, Sent_To_Oracle__c from EON_Appointment__c where name =:CancelBooking.AppointmentDetails.ExternalAppointmentID];
                    Error = Error + (appLst.isEmpty() ? 'REJECTED AppointmentID does not match active appointments\n' : '');
                }
                if(EON_Utility.validateRequired(CancelBooking.AppointmentDetails.EONAppointmentID) == true)
                    Error = Error + 'EONAppointmentID cannot be blank\n';
                if(EON_Utility.validateRequired(CancelBooking.AppointmentDetails.CancelReasonCode) == true)
                    Error = Error + 'CancelReasonCode cannot be blank\n';
                else
                    RCode = [select id,Reason_key__c from EON_Appointment_Cancel_Reason__c where Reason_key__c =: CancelBooking.AppointmentDetails.CancelReasonCode];
                if(EON_Utility.validateRequired(CancelBooking.AppointmentDetails.CancellationDateTime) == true)
                    Error = Error + 'CancellationDateTime cannot be blank\n';
               
               //CH04.Start
                if(EON_Utility.validateAppointmentStatus(CancelBooking.AppointmentDetails.ExternalAppointmentID.trim())
                    && !Test.isrunningTest())
                    Error = Error + 'REJECTED - Appointment cannot be updated or cancelled due to its current status\n';                    
                //CH04.End
                
                
                if(Error == ''){
                    String musAppId = CancelBooking.AppointmentDetails.ExternalAppointmentID;
                    eonTrackerID = CancelBooking.AppointmentDetails.EONAppointmentID; //CH03.New
                    String cancelReason = CancelBooking.AppointmentDetails.CancelReasonCode;
                    Datetime cancelDateTime = CancelBooking.AppointmentDetails.CancellationDateTime;
                    appt = appLst[0];
                    eonTracker.Appointment__c = appt.ID;
                    if(appt.Sent_to_Oracle__c){
                        appt.Cancel_Reason__c = RCode[0].id ;
                        Error = EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(appt.id); 
                        oracleTracker = EON_Cancel_Activity_OFSC.requestOut;
                        system.debug('---->>'+Error);
                        if((Error == 'Activity cancelled in OFSC successfully') || (Error == 'Appointment already cancelled in OFSC')){ //CH02
                            appt.Cancellation_DateTime__c = datetime.valueof(cancelDateTime);
                            update appt;
                            Error = '';
                        }
                        else
                            Error = Error+'\n' ;
                    }
                    else{
                        pendingCancellation = true;
                        eonTracker.h_JSON_Request_Data__c = JSON.serialize(CancelBooking); //CH03.New
                        eonTracker.Pending_Cancellation_at_Oracle__c = true;
                    }
                }
                if(Error != ''){
                    errMessage msg = new errMessage();
                    msg.MessageType = 'Exception';
                    msg.MessageId = 1;
                    msg.MessageText = Error;
                    msgLst.add(msg);
                    errorlst.Message = msgLst;
                    response.Messages = errorlst;
                    response.header = CancelBooking.header;
                    response.header.orgId = system.label.EON_Sanbox_Name;//UserInfo.getOrganizationId();
                    eonTracker.Appointment__c = !appLst.isEmpty() ? appLst[0].ID : null; //CH05
                    eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                    eonTracker.Error__c = EON_Utility.validateStringLength(Error + '');
                    eonTracker.Status__c = EON_Utility.RESULT_FAIL; 
                }
                if(Error == ''){
                    response.header = CancelBooking.header;
                    response.header.orgId = system.label.EON_Sanbox_Name;//UserInfo.getOrganizationId();
                    eonTracker.Status__c = EON_Utility.RESULT_PASS;
                    errMessage msg = new errMessage();
                    msg.MessageType = 'Information';
                    msg.MessageId = 0;
                    msg.MessageText = 'Request processed Successfully.';
                    msgLst.add(msg);
                    errorlst.Message = msgLst;
                    response.Messages = errorlst;   
                    eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');  
                    eonTracker.Appointment__c = !appLst.isEmpty() ? appLst[0].ID : null; //CH05
                }
            } 
            else{
                Error = 'Request Not Found';
                errMessage msg = new errMessage();
                msg.MessageType = 'Exception';
                msg.MessageId = 1;
                msg.MessageText = Error;
                msgLst.add(msg);
                errorlst.Message = msgLst;
                response.Messages = errorlst;
                eonTracker.Appointment__c = !appLst.isEmpty() ? appLst[0].ID : null; //CH05
                eonTracker.Request_Data__c = 'Blank Request';
                eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                eonTracker.Error__c = EON_Utility.validateStringLength(Error + '');
                eonTracker.Status__c = EON_Utility.RESULT_FAIL; 
            }
        }catch(Exception ex){
            Error = ex.getmessage();
            System.debug('**** Exception Occured '+ex.getmessage()+'----' + ex.getStackTraceString());
            errMessage msg = new errMessage();
            msg.MessageType = 'Exception';
            msg.MessageId = 1;
            msg.MessageText = Error;
            msgLst.add(msg);
            errorlst.Message = msgLst;
            response.Messages = errorlst;
            response.header = CancelBooking.header;
            response.header.orgId = system.label.EON_Sanbox_Name;
            eonTracker.Appointment__c = !appLst.isEmpty() ? appLst[0].ID : null; //CH05
            eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
            eonTracker.Error__c = EON_Utility.validateStringLength(Error + '');
            eonTracker.Status__c = EON_Utility.RESULT_FAIL;
        }
        if(!EON_Utility.validateRequired(eonTrackerID)){
            list<String> allTracker = eonTrackerID.split(';');
            if(allTracker.size() == 2){
                eonTracker.Id = allTracker[1];
                if(!EON_Utility.validateRequired(eonTracker.Request_Data__c)){
                    String requestDate = eonTracker.Request_Data__c;
                    eonTracker.h_JSON_Request_Data__c =JSON.serialize(requestDate.replace(eonTrackerID, allTracker[0]));
                    eonTracker.Pending_Cancellation_at_Oracle__c = false;
                }
                EON_Utility.createAttachment(eonTracker.id, eonTracker.Request_Data__c, eonTracker.id);
            }
        }
        upsert eonTracker;
        if(oracleTracker.id !=null){
            oracleTracker.EON_Data_Tracker__c = eonTracker.id;
            update oracleTracker;
        }
        if(!pendingCancellation)
            EON_Utility.createAttachment(eonTracker.id, eonTracker.Request_Data__c, eonTracker.id);
        return response; 
    }                                                                   
}