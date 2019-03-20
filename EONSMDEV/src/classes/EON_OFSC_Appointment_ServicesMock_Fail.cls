/**
Description : This class is a Web Service mock class to generate the failure response.
              EON_OFSC_Send_Appointment
              EON_OFSC_Update_Appointment
**/

/*
    Created By  : Dharmendra Pahadiya
    Created On  : 08/04/2016
    Service Req : SR_EON_Scheduling_006
    Change History : 
*/
@isTest
global with sharing class EON_OFSC_Appointment_ServicesMock_Fail implements WebServiceMock {
	
	/*
		doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
           String responseName,String responseType) - This method is used to generate failed mock response.
	*/
	global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
           String responseName,String responseType) {
       		// Send success response
       		EON_OFSC_Inbound_WS.ReportMessageElement message = new EON_OFSC_Inbound_WS.ReportMessageElement();
           	message.result = 'error';
           	message.code = '10';
           	message.description = 'Error';
           	EON_OFSC_Inbound_WS.ReportMessageElement[] messages = new EON_OFSC_Inbound_WS.ReportMessageElement[]{message};
           	EON_OFSC_Inbound_WS.ReportElement reports = new EON_OFSC_Inbound_WS.ReportElement();
           	reports.message = messages;
           	EON_OFSC_Inbound_WS.AppointmentResponseElement appointment = new EON_OFSC_Inbound_WS.AppointmentResponseElement();
           	appointment.appt_number = 'test';
           	appointment.name = 'test';
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
       		response.put('response_x', res);
   }
}