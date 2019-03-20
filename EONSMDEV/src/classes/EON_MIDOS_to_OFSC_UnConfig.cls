/**
    Description : This class is used to send the data received from EON MIDOS to OFSC.
    VF Page     : Not present
    Test Class  : EON_MIDOS_UnConfig_OFSC_test

**/
/*
    Created By  : Praveen G
    Created On  : 29/01/2018
    Service Req : SR_OptiMUS_EON_178 
 
    Change History : 
*/
public with sharing class EON_MIDOS_to_OFSC_UnConfig {
    public static Oracle_Data_Tracker__c objTrack;
    
    /*
        sendToOFSC_unConfig(EON_MIDOS_To_Isis_Wrapper objWrapper) - This method is used to send data to OFSC 
                                                        received from MIDOS
    */
    public static string sendToOFSC_unConfig(EON_MIDOS_To_Isis_Wrapper objWrapper){
        try{
            Oracle_Data_Tracker__c requestOut = new Oracle_Data_Tracker__c(Direction__c = 'OUT', 
                                                                    Command__c = objWrapper.Subject);
            string subject = objWrapper.Subject;
            string appId = objWrapper.Header.RequestId; //contains Appointment Id
            if(string.isBlank(appId)) return 'Appointment Number is required. Please contact your Administrator.';
            string result = '';
            
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>(
                            [select id, name, Appointment_Key__c, Duration__c, Job_code__r.Name, Oracle_Address__c,
                            Smart_Meter_Scheming_Complete__c from EON_Appointment__c where id =: appId]);
            
            //Request Elements.
            EON_OFSC_Inbound_WS.UserElement userElement = EON_OFSC_Helper.getInboundUserElement();//getUserElement();
            EON_OFSC_Inbound_WS.HeadElement headerElement = EON_OFSC_Helper.getHeaderElementForMIDOS(); //CH03.New
            
            //response Element
            EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response;
            
            //data element
            EON_OFSC_Inbound_WS.DataElement dataElement = new EON_OFSC_Inbound_WS.DataElement();
            
            //Create appointment Element
            EON_OFSC_Inbound_WS.AppointmentElement appointmentElement = new EON_OFSC_Inbound_WS.AppointmentElement();
            appointmentElement.appt_number = (!lstApp.isEmpty()&&lstApp.size()>0) ? 
                                            (!EON_Utility.validateRequired(lstApp[0].Appointment_Key__c) ? 
                                            lstApp[0].Appointment_Key__c : lstApp[0].ID) : '';
            appointmentElement.duration = (!lstApp.isEmpty()&&lstApp.size()>0?string.valueOf(lstApp[0].Duration__c):'');
            appointmentElement.worktype_label = (!lstApp.isEmpty()&&lstApp.size()>0&&lstApp[0].Job_code__r!=null?
                                                lstApp[0].Job_code__r.Name:'');
            appointmentElement.address = (!lstApp.isEmpty()&&lstApp.size()>0?lstApp[0].Oracle_Address__c:'');
            
            //Property Element
            List<EON_OFSC_Inbound_WS.PropertyElement> property_elements = new List<EON_OFSC_Inbound_WS.PropertyElement>(); 
            EON_OFSC_Inbound_WS.PropertyElement property_element = new EON_OFSC_Inbound_WS.PropertyElement(); 
            
            if(subject == 'PushUnConfigProgressStatus'){
                string assetType = objWrapper.AssetType!=''?objWrapper.AssetType:'';
                string statusMsgProperty = '';
                
                if(assetType =='ELECMETER')
                    statusMsgProperty = 'XA_COMM_E_STATUS';
                else if(assetType =='GASMETER')
                    statusMsgProperty = 'XA_COMM_G_STATUS';
                else if(assetType =='HUB')
                    statusMsgProperty = 'XA_COMM_H_STATUS';
                else if(assetType =='IHD')
                    statusMsgProperty = 'XA_COMM_I_STATUS';
                if(statusMsgProperty !=''){
                    property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                    property_element.label = statusMsgProperty;
                    property_element.value = objWrapper.StatusMessage;
                    system.debug('@@@ XA_COMM_*_STATUS Value: '+property_element.value);
                    property_elements.add(property_element);
                }
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_COMM_STATUS';
                property_element.value = objWrapper.ErrorMessage;
                system.debug('@@@ XA_COMM_STATUS Value: '+property_element.value);
                property_elements.add(property_element); 
            }
            else if(subject == 'PushUnConfigStatus'){
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_COMM_STATUS';
                property_element.value = objWrapper.StatusMessage+' '+ objWrapper.ErrorMessage;
                system.debug('@@@ XA_COMM_STATUS Value: '+property_element.value);
                
                property_elements.add(property_element);
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_SCHEME_COMPLETE';
                property_element.value = ((!lstApp.isEmpty() && lstApp.size()>0) ? 
                                        (lstApp[0].Smart_Meter_Scheming_Complete__c == true ? 'Yes':'No'):'');
                system.debug('@@@ XA_SCHEME_COMPLETE Value: '+property_element.value);
                property_elements.add(property_element);
            }

            else if(subject == 'MIDOS Failure Update'){
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_COMM_STATUS';
                property_element.value = 'Connection to MIDOS failed. Please try again';
                system.debug('@@@ XA_COMM_STATUS Value: '+property_element.value);
                property_elements.add(property_element);
            }
            
            EON_OFSC_Inbound_WS.PropertiesArray propertiesArray = new EON_OFSC_Inbound_WS.PropertiesArray();
            propertiesArray.property = property_elements;
                       
            appointmentElement.properties = propertiesArray;
            
            System.debug('****** propertiesArray ' + propertiesArray);
            
            EON_OFSC_Inbound_WS.CommandElement commandElement = new EON_OFSC_Inbound_WS.CommandElement();
            commandElement.type_x = 'update_activity';
            commandElement.external_id = '';
            commandElement.appointment = appointmentElement;

            
            List<EON_OFSC_Inbound_WS.CommandElement> commandElements = new List<EON_OFSC_Inbound_WS.CommandElement>();
            commandElements.add(commandElement);
            
            EON_OFSC_Inbound_WS.CommandsArray commandArray = new EON_OFSC_Inbound_WS.CommandsArray();
            commandArray.command = commandElements;
                        
            dataElement.commands = commandArray;
            
            try{
                //calling web service
                EON_OFSC_Inbound_WS.InboundInterfacePort request = new EON_OFSC_Inbound_WS.InboundInterfacePort();
                response = request.inbound_interface(userElement, headerElement, dataElement);
                
                string strResultCode = '';
                boolean iserror = false;
                if(response != null && response.data != null && response.data.commands != null && 
                            response.data.commands.command != null && response.data.commands.command.size() > 0 ){
                    strResultCode = response.data.commands.command[0].appointment.report.message[0].code;
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
                
                List<EON_OFSC_Response_Code__c> responseCode = [select id, Name, Error_Warning_Success__c from 
                                                    EON_OFSC_Response_Code__c where 
                                                    name =: strResultCode and API__c ='Inbound'];
                
                if(!responseCode.isEmpty())
                    requestOut.Error_Code__c = responseCode[0].id;
                
                if(!responseCode.isEmpty()){
                    if(responseCode[0].Name == '0' || 
                        responseCode[0].Error_Warning_Success__c.containsignorecase('warning')) 
                        requestOut.Status__c = 'PASS';
                    if((responseCode[0].Error_Warning_Success__c!='' && 
                        responseCode[0].Error_Warning_Success__c.containsignorecase('error')) || iserror) 
                        requestOut.Status__c = 'FAIL';
                }
                else if(strResultCode!='0')
                    requestOut.Status__c = 'FAIL';
                    
                String toaResponse = '' + response;
                if(toaResponse.length() > 131072) requestOut.Response_Data__c = toaResponse.substring(0, 131072);
                else
                    requestOut.Response_Data__c = '' + toaResponse;
                System.debug('responseCode 1 = '+responseCode);
                
                //if the response got error then revert team's TOA field as it was before.
                if(!responseCode.isEmpty() && responseCode[0].Error_Warning_Success__c != 'error' || !iserror){
                    result = 'Request sent to OFSC successfully';
                }else{
                    result = 'No Response Code found or error found in the Response';   
                } 
            }catch(Exception ex){
                requestOut.Status__c = 'FAIL'; result = ex.getMessage(); requestOut.Response_Data__c= ex.getMessage()+ '\n' +ex.getStackTraceString();system.debug('Web service exception: '+ex.getMessage()+ '\n' +ex.getStackTraceString());
            }
            try{
                String requestXML = '';
                requestXML = '' + userElement +'\n' +headerElement +'\n' +dataElement;  
                requestOut.EON_Appointment__c = (!lstApp.isEmpty()&&lstApp.size()>0)?lstApp[0].id:null;
                requestOut.Transaction_ID__c = (!lstApp.isEmpty()&&lstApp.size()>0)?lstApp[0].id:'';
            
                if(requestXML.length() > 131072) requestOut.Request_Data__c = '' + requestXML.substring(0, 131072);
                else
                    requestOut.Request_Data__c = '' + requestXML;   
                
                if(objWrapper.Subject == 'MIDOS Failure Update')requestOut.MIDOS_Data_Tracker__c=objWrapper.midosId;//CH01
          
                insert requestOut;  
                objTrack = requestOut;
                System.debug('***Request_Data__c-->' + requestXML);
    
                //just to track the full request as an attachment for OFSCRequestOut.
                insert new attachment(parentId = requestOut.id,body = Blob.valueOf(requestXML),name=requestOut.id+'.txt');}catch(Exception ex){system.debug('Trakcer exception: '+ex.getMessage()+ '\n' +ex.getStackTraceString());}
            return result;
        }
        catch(exception ex){system.debug('exception ex: '+ex.getMessage()+'\n'+ex.getStackTraceString());return ex.getMessage();}
    }
}