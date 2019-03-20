/**
    Description : This class will be used for deserialize .
                                    
    Test Class  : EON_CancelAppointment_RequestParser_Test

**/
/*
    Created By  : Mahadev J
    Created On  : 14/10/2016
    Service Req : SR_EON_AB_166
    Change History
*/
public class EON_CancelAppointment_RequestParser{
	public class Header{
		public String RequestId;
		public String RequestDateTime;
		public String OrgId;
	}
	public Header Header;
	public AppointmentDetails AppointmentDetails;
	public class AppointmentDetails{
		public String ExternalAppointmentID;
		public String EONAppointmentID;
		public String CancelReasonCode;
		public String CancellationDateTime;
	}
	public static void processCancelRequest(String apptID){
        System.debug('####Cancelling appointment...');
        EON_CancelAppointment_RequestParser parseData = new EON_CancelAppointment_RequestParser();
		list<EON_Data_Tracker__c> eTracker = [Select ID, Name, h_JSON_Request_Data__c from EON_Data_Tracker__c where Appointment__c =:apptID and Pending_Cancellation_At_Oracle__c = true];
        if(eTracker != null && !eTracker.isEmpty()){
            System.debug('####Started cancelling appointment...');
            parseData = (EON_CancelAppointment_RequestParser) System.JSON.deserialize(eTracker[0].h_JSON_Request_Data__c, EON_CancelAppointment_RequestParser.class);
            EON_CancelAppointment_In_Isis_WS.HeaderElement header = new EON_CancelAppointment_In_Isis_WS.HeaderElement();
            header.RequestId = parseData.Header.RequestId;
            Datetime requestDateTime = (DateTime)JSON.deserialize(parseData.Header.RequestDateTime, DateTime.class);
            header.RequestDateTime = requestDateTime;//Datetime.valueOf(parseData.Header.RequestDateTime);
            header.OrgId = parseData.Header.OrgId;
            
            EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement appointmentElement  = new EON_CancelAppointment_In_Isis_WS.AppointmentDetailElement();
            appointmentElement.EONAppointmentID = parseData.AppointmentDetails.EONAppointmentID + ';'+eTracker[0].ID;
            appointmentElement.ExternalAppointmentID = parseData.AppointmentDetails.ExternalAppointmentID;
            appointmentElement.CancelReasonCode = parseData.AppointmentDetails.CancelReasonCode;
            Datetime cancelDateTime = (DateTime)JSON.deserialize(parseData.AppointmentDetails.CancellationDateTime, DateTime.class);
            appointmentElement.CancellationDateTime = cancelDateTime; //Datetime.valueOf(parseData.AppointmentDetails.CancellationDateTime);
            
            EON_CancelAppointment_In_Isis_WS.CancelBooking cancelBooking = new EON_CancelAppointment_In_Isis_WS.CancelBooking();
            cancelBooking.Header = header;
            cancelBooking.AppointmentDetails = appointmentElement;
            
            EON_CancelAppointment_In_Isis_WS.Isis_Response_Acknowledgement_To_EON cancelResult = EON_CancelAppointment_In_Isis_WS.CancelAppointment(cancelBooking);
        }
        //return parseData;
	}
}