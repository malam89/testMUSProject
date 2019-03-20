/**
    Description : This class is used to send 'E Meter Serial Number' flag value to OFSC using inbound API.
    Test Class : EON_OFSC_to_MIDOS_Commission_Helper_test
**/
/*
    Created By : Praveen G
    Created Date : 07/09/2017
    Service Request : SR_OptiMUS_EON_110
*/

public with sharing class EON_Send_MTRSNO_OFSC_Handler{

    public static final String command = 'E Meter Serial Number';
    public static final string OFSCDateFormat = 'yyyy-MM-dd';
    
    /**
        sendEmeterSerialNumToOFSC(String appointmentID) - 
            This method is used to send 'E Meter Serial Number' value to OFSC using inbound API.
    **/
    @future(callout = true)
    public static void sendEmeterSerialNumToOFSC(String appointmentID){ 
    
        //get the appointment record info
        Eon_Appointment__c appointment = [select id, Name, Job_code__r.Name, Oracle_Address__c,
                                            Appointment_Date__c, Oracle_Postcode_Sector__c, Technician__c
                                            ,booking_system_name__c, Appointment_Key__c,
                                            E_Meter_Serial_Number__c, h_Job_Type__c,
                                            Job_Code__r.ICE_Maintenance_Over_ride__c,
                                            SubArea__r.Oracle_Bucket_ID__c, SubArea__c
                                            from 
                                            EON_Appointment__c where id =: appointmentID];
                                            
        //Calculate the bucketID  
        string bucketId = '';
        if(appointment.SubArea__c != null)
            bucketId = appointment.SubArea__r.Oracle_Bucket_ID__c;
            
        if(appointment.Technician__c!=null) 
            bucketId = appointment.Technician__c;
            
        if(bucketId == '')
            bucketId = system.label.EON_Exception_BucketID;                                            
                                                    
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
        
        if(appointment.booking_system_name__c == 'ICE')
            appointmentElement.appt_number = appointment.Appointment_Key__c;
        
        appointmentElement.worktype_label = appointment.Job_code__r.Name; 
        appointmentElement.address = appointment.Oracle_Address__c;       
        
        EON_OFSC_Inbound_WS.PropertiesArray propertiesArray = new EON_OFSC_Inbound_WS.PropertiesArray();
        List <EON_OFSC_Inbound_WS.PropertyElement> property_elements = new List <EON_OFSC_Inbound_WS.PropertyElement>();
        EON_OFSC_Inbound_WS.PropertyElement property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                
        
        property_element = new EON_OFSC_Inbound_WS.PropertyElement();
        property_element.label = 'XA_ASSET_E_MSN';
        property_element.value = appointment.E_Meter_Serial_Number__c;
        property_elements.add(property_element);  
        
        propertiesArray.property = property_elements;      
        appointmentElement.properties = propertiesArray;
        
        commandElement.type_x = 'update_activity';
        commandElement.date_x = convertDateToOFSCFormat(appointment.Appointment_Date__c);
        commandElement.external_id = bucketId;
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