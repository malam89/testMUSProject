/**
    Description : This class is used to send the data received from EON MIDOS to OFSC.
    VF Page     : Not present
    Test Class  : EON_MIDOS_to_OFSC_test

**/
/*
    Created By  : Dharmendra Pahadiya
    Created On  : 29/04/2016
    Service Req : SR_EON_Mobile_026 - subject = PushConfgAssetReadStatus
                  SR_EON_Mobile_023 - subject = PushValidationStatus
                  SR_EON_Mobile_024 - subject = PushConfigProgressStatus
                  SR_EON_Mobile_025 - subject = PushConfigStatus 
    Change History : 
    CH01 # SR_EON_Mobile_088 # 05/10/2016 # Dharmendra Pahadiya # Added code for sending info to OFSC for Read Time Out for MIDOS.
    CH02 # SR_EON_Mobile_093 # 21/10/2016 # Praveen G # Updated properties names for OFSC.
    CH03 # SR_EON_Scheduling_050 # 29/11/2016 # Praveen G # updated the OFSC header element.
    CH04 # SR_OptiMUS_EON_056 # 12/04/2017 # Ruchi and snehal # Included an additional property, in pushconfigstatus.
    
*/
public with sharing class EON_MIDOS_to_OFSC {
    public static Oracle_Data_Tracker__c objTrack;
    
    /*
        sendToOFSC(EON_MIDOS_To_Isis_Wrapper objWrapper) - This method is used to send data to OFSC received from MIDOS
    */
    public static string sendToOFSC(EON_MIDOS_To_Isis_Wrapper objWrapper){
        try{
            Oracle_Data_Tracker__c requestOut = new Oracle_Data_Tracker__c(Direction__c = 'OUT', Command__c = objWrapper.Subject);
            string subject = objWrapper.Subject;
            system.debug('@@@ subject: '+objWrapper.Subject);
            string appId = objWrapper.Header.RequestId; //contains Appointment Id
            system.debug('@@@ appId: '+appId);
            if(string.isBlank(appId)) return 'Appointment Number is required. Please contact your Administrator.';
            string result = '';
            
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, Appointment_Key__c, Duration__c, Job_code__r.Name, Oracle_Address__c,Smart_Meter_Scheming_Complete__c from EON_Appointment__c where id =: appId]);
            system.debug('@@@ lstApp size: '+lstApp.size());
            
            //Request Elements.
            EON_OFSC_Inbound_WS.UserElement userElement = EON_OFSC_Helper.getInboundUserElement();//getUserElement();
            //EON_OFSC_Inbound_WS.HeadElement headerElement = EON_OFSC_Helper.getHeaderElement(); // CH03.Old
            EON_OFSC_Inbound_WS.HeadElement headerElement = EON_OFSC_Helper.getHeaderElementForMIDOS(); //CH03.New
            
            //response Element
            EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response;
            
            //data element
            EON_OFSC_Inbound_WS.DataElement dataElement = new EON_OFSC_Inbound_WS.DataElement();
            
            //Create appointment Element
            EON_OFSC_Inbound_WS.AppointmentElement appointmentElement = new EON_OFSC_Inbound_WS.AppointmentElement();
            appointmentElement.appt_number = (!lstApp.isEmpty()&&lstApp.size()>0) ? (!EON_Utility.validateRequired(lstApp[0].Appointment_Key__c) ? lstApp[0].Appointment_Key__c : lstApp[0].ID) : ''; //appId;//Appt.Id;
            appointmentElement.duration = (!lstApp.isEmpty()&&lstApp.size()>0?string.valueOf(lstApp[0].Duration__c):'');
            appointmentElement.worktype_label = (!lstApp.isEmpty()&&lstApp.size()>0&&lstApp[0].Job_code__r!=null?lstApp[0].Job_code__r.Name:'');
            appointmentElement.address = (!lstApp.isEmpty()&&lstApp.size()>0?lstApp[0].Oracle_Address__c:'');
            system.debug('@@@ appt_number: '+appointmentElement.appt_number);
            system.debug('@@@ duration: '+appointmentElement.duration);
            system.debug('@@@ worktype_label: '+appointmentElement.worktype_label);
            system.debug('@@@ address: '+appointmentElement.address);
            
            //Property Element
            List<EON_OFSC_Inbound_WS.PropertyElement> property_elements = new List<EON_OFSC_Inbound_WS.PropertyElement>(); 
            EON_OFSC_Inbound_WS.PropertyElement property_element = new EON_OFSC_Inbound_WS.PropertyElement(); 
            
            /*property_element = new EON_OFSC_Inbound_WS.PropertyElement();
            property_element.label = 'XA_Morrison_ID';
            property_element.value = objWrapper.Header.OrgId;//Appt.Name;
            system.debug('@@@ XA_Morrison_ID Value: '+property_element.value);
            property_elements.add(property_element);*/
            
            if(subject == 'PushValidationStatus' || subject == 'PushConfigProgressStatus'){
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
                    system.debug('@@@ statusMsg Property: '+statusMsgProperty);
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
            else if(subject == 'PushConfigStatus'){
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_COMM_STATUS';
                property_element.value = objWrapper.StatusMessage+' '+ objWrapper.ErrorMessage;
                system.debug('@@@ XA_COMM_STATUS Value: '+property_element.value);
                property_elements.add(property_element);
                //CH04.Start
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_SCHEME_COMPLETE';
                property_element.value = ((!lstApp.isEmpty() && lstApp.size()>0) ? (lstApp[0].Smart_Meter_Scheming_Complete__c == true ? 'Yes':'No'):'');
                system.debug('@@@ XA_SCHEME_COMPLETE Value: '+property_element.value);
                property_elements.add(property_element);
                //CH04.End 
            }
            else if(subject == 'PushConfgAssetReadStatus'){
                //system.debug('@@@ objWrapper.EleMeterRead: '+objWrapper.EleMeterRead);
                if(objWrapper.EleMeterRead != null){
                    property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                    property_element.label = 'XA_ASSET_E_SSC_ACTUAL_NEW';
                    property_element.value = objWrapper.EleMeterRead.SSC;//Appt.Name;
                    system.debug('@@@ XA_ASSET_E_SSC_ACTUAL_NEW Value: '+property_element.value);
                    property_elements.add(property_element);
                    
                    integer i = 1;
                    for(EON_MIDOS_To_Isis_Wrapper.RegisterElement objReg: objWrapper.EleMeterRead.Registers){
                        string regId, read_new, TPR;
                        regId = read_new = TPR = '';
                        /**CH02
                        if(i==1){
                            regId = 'XA_ASSET_E_REG_ID_NEW';
                            read_new = 'XA_ASSET_E_READ_NEW';
                            TPR = 'XA_ASSET_E_TPR_NEW';
                        }
                        else if(i>1){ 
                            regId = 'XA_ASSET_E_REG_ID'+i+'_NEW';
                            read_new = 'XA_ASSET_E_READ'+i+'_NEW';
                            TPR = 'XA_ASSET_E_TPR'+i+'_NEW';
                        }**/
                        
                        //CH02.Start
                        regId = 'XA_ASSET_E_REG_ID_NEW_'+ i;
                        read_new = 'XA_ASSET_E_READ_NEW_'+ i;
                        TPR = 'XA_ASSET_E_TPR'+ i +'_NEW';
                        //CH02.End
                        
                        property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                        system.debug('@@@ RegId label: '+regId);
                        property_element.label = regId;//'XA_ASSET_E_REG_ID_NEW';
                        property_element.value = objReg.RegisterId;
                        system.debug('@@@ '+regId+' Value: '+property_element.value);
                        property_elements.add(property_element);
                        
                        property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                        system.debug('@@@ read_new label: '+read_new);
                        property_element.label = read_new;//'XA_ASSET_E_READ_NEW';
                        property_element.value = string.valueOf(objReg.RegisterRead);
                        system.debug('@@@ '+read_new+' Value: '+property_element.value);
                        property_elements.add(property_element);
                        
                        property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                        system.debug('@@@ TPR label: '+TPR);
                        property_element.label = TPR;//'XA_ASSET_E_TPR_NEW';
                        property_element.value = objReg.TPR;
                        system.debug('@@@ '+TPR+' Value: '+property_element.value);
                        property_elements.add(property_element);
                        i++;
                    }
                }
                
                if(objWrapper.GasMeterRead != null){
                    property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                    property_element.label = 'XA_ASSET_G_READ_NEW';
                    property_element.value = string.valueOf(objWrapper.GasMeterRead.GasRegisterRead);
                    system.debug('@@@ XA_ASSET_G_READ_NEW Value: '+property_element.value);
                    property_elements.add(property_element);
                }
                
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_COMM_STATUS';
                property_element.value = objWrapper.StatusMessage +' '+ objWrapper.ErrorMessage;
                system.debug('@@@ XA_COMM_STATUS Value: '+property_element.value);
                property_elements.add(property_element);
            }
            //CH01.start
            else if(subject == 'MIDOS Failure Update'){
                property_element = new EON_OFSC_Inbound_WS.PropertyElement();
                property_element.label = 'XA_COMM_STATUS';
                property_element.value = 'Connection to MIDOS failed. Please try again';
                system.debug('@@@ XA_COMM_STATUS Value: '+property_element.value);
                property_elements.add(property_element);
            }
            //CH01.End
        
        
            EON_OFSC_Inbound_WS.PropertiesArray propertiesArray = new EON_OFSC_Inbound_WS.PropertiesArray();
            propertiesArray.property = property_elements;
            
            
            //Praveen add
            appointmentElement.properties = propertiesArray;
            //Praveen add            
            
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
                if(response != null && response.data != null && response.data.commands != null && response.data.commands.command != null && response.data.commands.command.size() > 0 ){
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
                
                List<EON_OFSC_Response_Code__c> responseCode = [select id, Name, Error_Warning_Success__c from EON_OFSC_Response_Code__c where name =: strResultCode and API__c ='Inbound'];
                
                if(!responseCode.isEmpty())
                    requestOut.Error_Code__c = responseCode[0].id;
                
                if(!responseCode.isEmpty()){
                    if(responseCode[0].Name == '0' || responseCode[0].Error_Warning_Success__c.containsignorecase('warning')) requestOut.Status__c = 'PASS';
                    if((responseCode[0].Error_Warning_Success__c!='' && responseCode[0].Error_Warning_Success__c.containsignorecase('error')) || iserror) requestOut.Status__c = 'FAIL';
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