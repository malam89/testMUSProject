/**
    Description : This class is used to send 'PAYG Details Sent' flag value to OFSC using inbound API.
    Test Class : EON_OFSC_to_MIDOS_Commission_Helper_test
**/
/*
    Created By : Praveen G
    Created Date : 29/06/2017
    Service Request : SR_OptiMUS_EON_081
    
    CHANGE HISTORY : 
    CH01 # SR_OptiMUS_EON_095 # 11/08/2017 # Praveen G # updated the appt_number value
*/

public with sharing class EON_Send_PAYG_Sent_OFSC_Handler{

    public static final String command = 'PAYG Details Sent';
    public static final string OFSCDateFormat = 'yyyy-MM-dd';

    /**
        sendPAYGFlatToOFSC(String appointmentID) - 
            This method is used to send 'PAYG Details Sent' flag value to OFSC using inbound API.
    **/
    @future(callout = true)
    public static void sendPAYGFlatToOFSC(String appointmentID){                

        //get the appointment record info
        Eon_Appointment__c appointment = [select id, Name, Job_code__r.Name, Oracle_Address__c,
                                            Appointment_Date__c, Oracle_Postcode_Sector__c, Technician__c
                                            ,booking_system_name__c, Appointment_Key__c //CH01
                                            from 
                                            EON_Appointment__c where id =: appointmentID];
                                                    
        //Crate ODT record instance
        Oracle_Data_Tracker__c requestOut = new Oracle_Data_Tracker__c();
        requestOut.Command__c = command;
        requestOut.Direction__c = EON_Utility.DIRECTION_OUT;
        requestOut.EON_Appointment__c = appointment.Id;                
        
        //Set the request
        EON_OFSC_Inbound_WS.DataElement dataElement = new EON_OFSC_Inbound_WS.DataElement();
        EON_OFSC_Inbound_WS.UserElement userElement = EON_OFSC_Helper.getInboundUserElement();
        EON_OFSC_Inbound_WS.HeadElement headerElement = EON_OFSC_Helper.getHeaderElementForMIDOS();
        
        EON_OFSC_Inbound_WS.CommandsArray commandArray = new EON_OFSC_Inbound_WS.CommandsArray();
        List <EON_OFSC_Inbound_WS.CommandElement> commandElements = new List <EON_OFSC_Inbound_WS.CommandElement>();        
        EON_OFSC_Inbound_WS.CommandElement commandElement = new EON_OFSC_Inbound_WS.CommandElement();
        
        EON_OFSC_Inbound_WS.AppointmentElement appointmentElement = new EON_OFSC_Inbound_WS.AppointmentElement();        
        appointmentElement.appt_number = appointment.Id;
        
        //CH01.Start
        if(appointment.booking_system_name__c == 'ICE')
            appointmentElement.appt_number = appointment.Appointment_Key__c;
        //CH01.End
        
        appointmentElement.worktype_label = appointment.Job_code__r.Name; 
        appointmentElement.address = appointment.Oracle_Address__c;       
        
        EON_OFSC_Inbound_WS.PropertiesArray propertiesArray = new EON_OFSC_Inbound_WS.PropertiesArray();
        List <EON_OFSC_Inbound_WS.PropertyElement> property_elements = new List <EON_OFSC_Inbound_WS.PropertyElement>();
        EON_OFSC_Inbound_WS.PropertyElement property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                
        
        property_element = new EON_OFSC_Inbound_WS.PropertyElement();
        property_element.label = 'XA_PAYG_SENT';
        property_element.value = 'Yes';
        property_elements.add(property_element);  
        
        propertiesArray.property = property_elements;      
        appointmentElement.properties = propertiesArray;
        
        commandElement.type_x = 'update_activity';
        commandElement.date_x = convertDateToOFSCFormat(appointment.Appointment_Date__c);
        commandElement.external_id = appointment.Technician__c;
        commandElement.appointment = appointmentElement;
        
        commandElements.add(commandElement);
        commandArray.command = commandElements;
        dataElement.commands = commandArray;
        
        String requestXML = '' + userElement + '\n' + headerElement + '\n' + 
                                OFSC_Utility.convertDataElementInToXML(dataElement);
        requestOut.Request_Data__c = EON_Utility.validateStringLength(requestXML);
        EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response;
         
        try{
            EON_OFSC_Inbound_WS.InboundInterfacePort request = new EON_OFSC_Inbound_WS.InboundInterfacePort();
            response = request.inbound_interface(userElement, headerElement, dataElement); 
            
            processResponse(response, requestOut);                
            
            requestOut.Response_Data__c = '' + response;                       
        }catch(Exception ex){
            requestOut.Response_Data__c = '' + response + '\n' + ex.getStackTraceString();
            System.debug('****** Exception Occured ' + ex.getStackTraceString());
        }
        
        insert requestOut;

    }
    
    /**
        processResponse(EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response) - 
                This method is used to process the response.
    **/
    public static Oracle_Data_Tracker__c processResponse(EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response,
                        Oracle_Data_Tracker__c requestOut){
    
            String strResultCode = '';
            boolean iserror = false;
            if (response != null && response.data != null && response.data.commands != null && 
                    response.data.commands.command != null && response.data.commands.command.size() > 0) {
                strResultCode = response.data.commands.command[0].appointment.report.message[0].code;
                integer messageSize = response.data.commands.command[0].appointment.report.message.size();
                string tempError = '';
                for (integer i = 0; i < messageSize; i++) {
                    if (response.data.commands.command[0].appointment.report.message[i].code == '0')
                        strResultCode = '0';
                    else
                        tempError = response.data.commands.command[0].appointment.report.message[i].code;
                    if (response.data.commands.command[0].appointment.report.message[i].result == 'error') {
                        iserror = true;
                        strResultCode = tempError;
                    }
                }
            }
            
            List < EON_OFSC_Response_Code__c > responseCode = [select id, Name, Error_Warning_Success__c 
                                                                from EON_OFSC_Response_Code__c 
                                                                where 
                                                                name = : strResultCode and API__c = 'Inbound'];
            if (!responseCode.isEmpty())
                requestOut.Error_Code__c = responseCode[0].id;
                
            if (!responseCode.isEmpty()) {
                if (responseCode[0].Name == '0' || 
                            responseCode[0].Error_Warning_Success__c.containsignorecase('warning'))
                    requestOut.Status__c = EON_Utility.RESULT_PASS;
                if ((responseCode[0].Error_Warning_Success__c != '' && 
                            responseCode[0].Error_Warning_Success__c.containsignorecase('error')) || iserror)
                    requestOut.Status__c = EON_Utility.RESULT_FAIL; 
            }else if (strResultCode != '0')
                requestOut.Status__c = EON_Utility.RESULT_FAIL;
            else if (strResultCode == '0')
                requestOut.Status__c = EON_Utility.RESULT_PASS;
                
        return requestOut;                    
        
    }
    
    /**
        convertDateToDateTime(Date dt) - This method converts date to TOA Date Format.
    **/
    public static String convertDateToOFSCFormat(Date dt) {
        String OFSCDate = '';
        if (dt != null)
            OFSCDate = datetime.newInstance(dt, time.newInstance(0, 0, 0, 0)).format(OFSCDateFormat);
        return OFSCDate;
    }    
}