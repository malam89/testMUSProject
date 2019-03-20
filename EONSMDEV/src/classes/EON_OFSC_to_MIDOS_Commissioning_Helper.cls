/**
    Description : This class is used to prepare data to send to MIDOS for commissioning.
    VF Page     : Not Available
    Test Class  : EON_OFSC_to_MIDOS_Commission_Helper_test

**/
/*
    Created By  : Dharmendra Pahadiya
    Created On  : 12/05/2016
    Service Req : SR_EON_Mobile_019
    Change History
    CH01 # SR_EON_Mobile_020  # 16/05/2016 # Shruti Moghe # added logic for SubmitPrePayBalance
    CH02 # SR_EON_Mobile_022 # Dharmendra Pahadiya # 20/05/2016 # Added logic to send Credit Meter Reading to MIDOS
    CH03 # SR_EON_Mobile_021 # Shruti Moghe # 24/05/2016 # Added logic to send ValidateSMSAsset to MIDOS
    CH04 # SM-3103 # Mahadev J # 15/11/2016 # Fix for issue
    CH05 # SR_OptiMUS_EON_081 # Praveen G # 03/07/2017 # Update the new field on Appointment for specific status come from OFSC.
*/
public with sharing class EON_OFSC_to_MIDOS_Commissioning_Helper {
    private static String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static String toaNS = 'urn:toatech:agent';
    
    /**
        SendtoMIDOS(Map<String, String> mapRequest) - This method is used to prepare data which needs to be sent to MIDOS.
    **/
    public static String SendtoMIDOS(string subject, string orackeDataTrackerID, string req){
        MIDOS_Data_Tracker__c objTrack;
        String appStatus='Notfound';
        String appointmentID; //CH05
        try{
            
            string midosId = '';
            objTrack = new MIDOS_Data_Tracker__c(Direction__c=Eon_Utility.DIRECTION_OUT, Command__c=subject, Oracle_Data_Tracker__c=orackeDataTrackerID);
            //insert objTrack;
            //midosId = objTrack.Id;
            //to avoid the creation of MIDOS Data Tracker record on failure of ODT record
            Dom.Document docx = new Dom.Document();
            docx.load(req);
            dom.XmlNode xroot = docx.getrootelement() ;
            
            
            Dom.Document domRequest=new Dom.Document();
            domRequest.load(req.unescapeXml().replace('&', '&amp;'));            
            Dom.XmlNode envelope=domRequest.getRootElement();
            
            req = req.unescapeXml();
            
            System.debug('******req ' + req);
            System.debug('******subject ' + subject);
            System.debug('******orackeDataTrackerID ' + orackeDataTrackerID);
            
            //Fetch the Appointment Id from the xml and update it into Oracle Data Tracker
            string bodyStartNode = '';
            if(subject=='SubmitCreditMeterReading')bodyStartNode='CreditMeterReading';
            if(subject=='SubmitPrePayBalance')bodyStartNode='PrePayMeterBalance'; //CH01
            if(subject=='ConfigureSMSAsset')bodyStartNode='SMSAssetConfiguration'; //CH02
            if(subject=='ValidateSMSAsset')bodyStartNode='SMSAssetValidation'; //CH03
            system.debug('@@@ subject: '+subject);
            system.debug('@@@ bodyStartNode: '+bodyStartNode);
            dom.XmlNode[] Header;
            
            System.debug('******body ' + envelope.getChildElement('Body', soapNS));
            System.debug('******send_message' + envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS));
            System.debug('****** 1 ' + envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS));
           System.debug('****** 2 '  + envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS));
            System.debug('******3 ' + envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS));
           System.debug('*****4 ' + envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElement('SMSAssetConfiguration', toaNS));
            
            if(string.isNotBlank(bodyStartNode)){
                if(envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElement(bodyStartNode, toaNS)==null){
                    objTrack.Request_Data__c='Invalid XML format for '+bodyStartNode+', Please verify once and try again';
                    objTrack.Status__c = EON_Utility.RESULT_FAIL;
                    upsert objTrack;
                }
                else{
                    Header= envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElement(bodyStartNode, toaNS).getChildElements();//'CreditMeterReading'
                    system.debug('@@@ Header: '+Header);
                    //string appId = Header[0].getChildElement('RequestId', toaNS).gettext(); //CH04.Old
                    string appId = Header[0].getChildElement('OrgId', toaNS).gettext(); //CH04.New
                    system.debug('@@@ appId: '+appId);
                    //Get appointment
                    list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where name =: appId]); //CH04.Update
                    if(!lstApp.isEmpty() && lstApp.size()>0){
                        appointmentID = lstAPP[0].ID; //CH05
                        appStatus='found';
                        Oracle_Data_Tracker__c ODT = new Oracle_Data_Tracker__c(id = orackeDataTrackerID);
                        ODT.EON_Appointment__c = lstApp[0].ID;
                        ODT.Transaction_ID__c = lstApp[0].ID + '1234';
                        update ODT;
                    }
                }
            }
            if(Header!=null && appStatus=='found'){
                 // string midosId = '';
                //objTrack = new MIDOS_Data_Tracker__c(Direction__c=Eon_Utility.DIRECTION_OUT, Command__c=subject, Oracle_Data_Tracker__c=orackeDataTrackerID);
                insert objTrack;
                midosId = objTrack.Id;
                //SubmitCreditMeterReading or SubmitPrePayBalance request - both may have multiple meter information
                if(subject.equalsIgnoreCase('SubmitCreditMeterReading') || subject.equalsIgnoreCase('SubmitPrePayBalance')){//CH01
                    dom.XmlNode[] CreditMeterReading= envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElement(bodyStartNode, toaNS).getChildElements();
                     
                    system.debug('@@@ CreditMeterReading size: '+CreditMeterReading.size());
                    
                    integer i =1;
                    boolean mpan =false;
                    for(dom.XmlNode cnode: CreditMeterReading){ //To call the method to send data to MIDOS for multiple no of meters
                        system.debug('@@@ CreditMeterReading node name: '+cnode.getName());
                        system.debug('@@@ i: '+i);
                        if(cnode.getName().containsIgnoreCase('Header'))continue;
                        //if(node.getChildElement('MPAN', toaNS)!=null && string.isBlank(node.getChildElement('MPAN', toaNS).getText()))continue;
                        //if(node.getChildElement('MPRN', toaNS)!=null && string.isBlank(node.getChildElement('MPRN', toaNS).getText()))continue;
                        else if(cnode.getChildren()!=null)
                        for(Dom.XmlNode node : cnode.getChildElements()){
                            if(subject.equalsIgnoreCase('SubmitCreditMeterReading')){
                                if(node.getName().containsIgnoreCase('MPAN') && node.getText()!='' && node.getText()!=null){
                                    EON_OFSC_to_MIDOS_Commissioning_Send.sendCreditMeter(midosId, req, 1);
                                    updateAppointmentRec(appointmentID);//CH05
                                    Mpan=true;  
                                }
                                if(node.getName().containsIgnoreCase('MPRN') && node.getText()!='' && node.getText()!=null){
                                    if(Mpan){ //Create new MIDOS Data Tracker record for the more than one request to be sent to MIDOS.
                                        MIDOS_Data_Tracker__c objTrack1 = new MIDOS_Data_Tracker__c(Direction__c=Eon_Utility.DIRECTION_OUT, Command__c=subject, Oracle_Data_Tracker__c=orackeDataTrackerID);
                                        insert objTrack1;
                                        midosId = objTrack1.Id;
                                    }
                                    updateAppointmentRec(appointmentID);//CH05
                                    EON_OFSC_to_MIDOS_Commissioning_Send.sendCreditMeter(midosId, req, 2);
                                }                                                       
                            }
                            else if(subject.equalsIgnoreCase('SubmitPrePayBalance')){
                                if(node.getName().containsIgnoreCase('MPAN') && node.getText()!='' && node.getText()!=null){
                                    EON_OFSC_to_MIDOS_Commissioning_Send.sendPrePayBalance(midosId, req, 1);
                                    updateAppointmentRec(appointmentID);//CH05
                                    Mpan=true;
                                }
                                if(node.getName().containsIgnoreCase('MPRN') && node.getText()!='' && node.getText()!=null){
                                    if(Mpan){ //Create new MIDOS Data Tracker record for the more than one request to be sent to MIDOS.
                                        MIDOS_Data_Tracker__c objTrack1 = new MIDOS_Data_Tracker__c(Direction__c=Eon_Utility.DIRECTION_OUT, Command__c=subject, Oracle_Data_Tracker__c=orackeDataTrackerID);
                                        insert objTrack1;
                                        midosId = objTrack1.Id;
                                    }
                                    EON_OFSC_to_MIDOS_Commissioning_Send.sendPrePayBalance(midosId, req, 2);
                                    updateAppointmentRec(appointmentID);//CH05
                                }
                            } 
                        }           
                    }
                    
                }
                // ConfigureSMSAsset subject
                else if(subject.equalsIgnoreCase('ConfigureSMSAsset')){
                    EON_OFSC_to_MIDOS_Commissioning_Send.sendConfigAsset(midosId, req); //CH02
                }
                else if(subject.equalsIgnoreCase('ValidateSMSAsset')){
                    EON_OFSC_to_MIDOS_Commissioning_Send.sendValidateSMSAsset(midosId, req); //CH03
                }
            }
        

        }catch(exception ex){
            system.debug('### Data creation exc: '+ex.getMessage()+' \n'+ex.getStackTraceString());
            objTrack.Request_Data__c = ex.getMessage()+' \n'+ex.getStackTraceString();
            objTrack.Status__c = EON_Utility.RESULT_FAIL;
            upsert objTrack;
        }
        return appStatus;
    }
    
    //CH05.Start
    /**
        updateAppointmentRec(String AppID) - This method is used to update the appointment record.
    **/
    public static void updateAppointmentRec(String appID){
        if(appID != null){
            EON_Appointment__c appointment = new Eon_Appointment__c(id = appID);
            appointment.PAYG_Details_Sent__c = true;
            update appointment;
        }
    }
    //CH05.End
}