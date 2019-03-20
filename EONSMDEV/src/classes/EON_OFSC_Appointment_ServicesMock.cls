/**
Description : This test class is for the following below classes/triggers
              EON_OFSC_Send_Appointment
              EON_OFSC_Update_Appointment
**/

/*
    Created By  : Dharmendra Pahadiya
    Created On  : 08/04/2016
    Service Req : SR_EON_Scheduling_006
    Change History : 
		CH01 # SR_EON_Mobile_034 # 09/05/2016 # Dharmendra P # Added 'aid' in response.
*/
@isTest
global class EON_OFSC_Appointment_ServicesMock implements WebServiceMock {
    public static string methodName = '';
	/*
		doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
           String responseName,String responseType) - This method is used to generate success mock response.
	*/
	global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
           String responseName,String responseType) {
       		// Send success response
       		EON_OFSC_Inbound_WS.ReportMessageElement message = new EON_OFSC_Inbound_WS.ReportMessageElement();
           	message.result = 'success';
           	message.code = '0';
           	message.description = 'Appointment id = 126';
           	EON_OFSC_Inbound_WS.ReportMessageElement[] messages = new EON_OFSC_Inbound_WS.ReportMessageElement[]{message};
           	EON_OFSC_Inbound_WS.ReportElement reports = new EON_OFSC_Inbound_WS.ReportElement();
           	reports.message = messages;
           	EON_OFSC_Inbound_WS.AppointmentResponseElement appointment = new EON_OFSC_Inbound_WS.AppointmentResponseElement();
           	appointment.appt_number = 'test';
           	appointment.name = 'test';
           	appointment.aid = 126;
           	appointment.report = reports;
           	EON_OFSC_Inbound_WS.CommandResponseElement command = new EON_OFSC_Inbound_WS.CommandResponseElement();
           	command.appointment = appointment;
           	EON_OFSC_Inbound_WS.CommandResponseElement[] commandarray = new EON_OFSC_Inbound_WS.CommandResponseElement[]{command};
           	EON_OFSC_Inbound_WS.CommandsResponseArray commands = new EON_OFSC_Inbound_WS.CommandsResponseArray();
           	commands.command = commandarray;
           	EON_OFSC_Inbound_WS.DataResponseElement data = new EON_OFSC_Inbound_WS.DataResponseElement();
           	data.commands = commands;
           	EON_OFSC_Inbound_WS.InboundInterfaceResponseElement res = new EON_OFSC_Inbound_WS.InboundInterfaceResponseElement();
           	res.user_x = new EON_OFSC_Inbound_WS.UserElement();
           	res.head = new EON_OFSC_Inbound_WS.HeadResponseElement();
           	res.data = data;
           	if(methodName == 'errorResponse'){
            	//message.result = 'fail';
                message.result = 'error';
                message.code = '1';
                response.put('response_x', res);
          	}
            else
            	response.put('response_x', res);

   }
}