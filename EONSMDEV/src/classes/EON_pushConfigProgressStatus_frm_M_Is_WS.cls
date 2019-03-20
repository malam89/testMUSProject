/**
    Description : This class will be used for generating WSDL, so that MIDOS can use this WSDL to push repeated progress statuses to Isis for meters just commissioned.
                  It will be the first message from MIDOS via Isis to commissioning App in oracle.
                  
    Test Class  : EON_PushConfigPrgStatus_frm_M_Is_test

**/
/*
    Created By  : Akshay Bairagi
    Created On  : 11/03/2016
    Service Req : SR_EON_Mobile_006
    Change History : CH01 # SR_EON_Mobile_036 # 06/05/2016 # Dharmendra P # Added logic to link MIDOS and Oracle Tracker records.
                     CH02 # SR_EON_Mobile_116 # 25/01/2017 # Praveen G # Added logic to update the Appointment for 
                     MIDOS tracker records.
                     CH03 # SR_OptiMUS_EON_192 # 25/01/2018 # Praveen G # Added fix for quiuing issue  
*/
global with sharing class EON_pushConfigProgressStatus_frm_M_Is_WS {
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class HeaderElement {  
        Webservice String OrgId;
        Webservice String RequestId;
        Webservice datetime RequestDateTime;
    }  
    /**
        Description : Request Parameter 2
    **/
    global with sharing class PushConfigProgressStatus {  
        Webservice HeaderElement Header;
        Webservice String AssetType;
        Webservice String StatusMessage;
        Webservice String StatusValue;
        Webservice String ErrorMessage;
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
    global with sharing class Isis_Response_Acknowledgement_To_MIDOS{
        Webservice HeaderElement Header;
        Webservice errMessageLst Messages;
    }   
    /**
        Isis_Response_Acknowledgement_To_MIDOS PushConfigProgressStatus(PushConfigProgressStatus ConfigureSMSProgressStatus) - 
                This method is used to get progress statuses from MIDOS.
    **/
    webservice static Isis_Response_Acknowledgement_To_MIDOS PushConfigProgressStatus(PushConfigProgressStatus ConfigureSMSProgressStatus){ 
        Isis_Response_Acknowledgement_To_MIDOS response = new Isis_Response_Acknowledgement_To_MIDOS();
        errMessageLst errorlst = new errMessageLst();
        MIDOS_Data_Tracker__c midosTracker = new MIDOS_Data_Tracker__c();
        Oracle_Data_Tracker__c oracTracker = new Oracle_Data_Tracker__c();
        midosTracker.Direction__c = 'IN'; 
        midosTracker.Command__c = 'PushConfigProgressStatus';
        list<errMessage> msgLst = new list<errMessage>();
        string Error = '';
        try{
            if(ConfigureSMSProgressStatus != null){
                midosTracker.Request_Data__c = EON_Utility.validateStringLength(ConfigureSMSProgressStatus + '');                                                                                             
                midosTracker.Transaction_ID__c = ConfigureSMSProgressStatus.header.requestId; 
                if(EON_Utility.validateRequired(ConfigureSMSProgressStatus.header.orgId) == true){
                    Error = 'OrgId cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSProgressStatus.header.requestId) == true){
                    Error = Error + 'RequestId cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSProgressStatus.header.RequestDateTime) == true){
                    Error = Error + 'RequestDateTime cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSProgressStatus.AssetType) == true){
                    Error = Error + 'AssetType cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSProgressStatus.StatusMessage) == true){
                    Error = Error + 'StatusMessage cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSProgressStatus.StatusValue) == true){
                    Error = Error + 'StatusValue cannot be blank\n';
                }
                if(Error == ''){
                    EON_MIDOS_To_Isis_Wrapper wppr = new EON_MIDOS_To_Isis_Wrapper();
                    wppr.Subject = 'PushConfigProgressStatus';
                    EON_MIDOS_To_Isis_Wrapper.HeaderElement head = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
                    head.OrgId = ConfigureSMSProgressStatus.header.OrgId ;
                    //Extract Appointment ID from MDT ID received in request ID and then send to OFSC i.e. Wrapper Class
                    string MDT = ConfigureSMSProgressStatus.header.RequestId.trim();
                    string Appt_Id = '';
                    
                    
                    //CH03.Start
                    list<MIDOS_Data_Tracker__c> MDTlst = new list<MIDOS_Data_Tracker__c>();
                    if(System.Label.Is_Future == 'TRUE')
                        MDTlst = [select id,name,Appointment_Number__c from MIDOS_Data_Tracker__c where Name =:MDT];
                    else
                        MDTlst = [select id,name,Appointment_Number__c from MIDOS_Data_Tracker__c where Transaction_ID__c=:MDT];
                    //CH03.End
                    
                    if(EON_Utility.genException != null && EON_Utility.genException) String NameTest= MDTlst[0].name;   
                    if(MDTlst != null && MDTlst.size()>0){
                        Appt_Id = MDTlst[0].Appointment_Number__c;
                        midosTracker.MIDOS_Data_Tracker__c = MDTlst[0].Id;
                    }else{
                        Error = 'Request ID not valid, Please contact your administrator.';
                    }
                    //
                    head.RequestId = Appt_Id;//ConfigureSMSProgressStatus.header.RequestId ;
                    head.RequestDateTime = ConfigureSMSProgressStatus.header.RequestDateTime ;
                    wppr.Header = head;
                    wppr.AssetType = ConfigureSMSProgressStatus.AssetType ;
                    wppr.StatusValue = EON_Utility.validateRequired(ConfigureSMSProgressStatus.StatusValue)?'':ConfigureSMSProgressStatus.StatusValue;
                    wppr.StatusMessage = ConfigureSMSProgressStatus.StatusMessage;
                    wppr.ErrorMessage = EON_Utility.validateRequired(ConfigureSMSProgressStatus.ErrorMessage)?'':ConfigureSMSProgressStatus.ErrorMessage;
                    String MIDOSTrack = '';
                    if(Error == ''){
                        Error = EON_MIDOS_to_OFSC.sendToOFSC(wppr);
                        oracTracker = EON_MIDOS_to_OFSC.objTrack ;
                    }
                    if(Error == 'Request sent to OFSC successfully'){
                        errMessage msg = new errMessage();
                        msg.MessageType = 'Information';
                        msg.MessageId = 0;
                        msg.MessageText = 'Request processed Successfully.';
                        msgLst.add(msg);
                        errorlst.Message = msgLst;
                        response.Messages = errorlst;
                        response.header = ConfigureSMSProgressStatus.header;
                        response.header.orgId = system.label.EON_Sanbox_Name;//'MORR';
                        midosTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                        midosTracker.Status__c = EON_Utility.RESULT_PASS; 
                        Error = '';
                    }
                    //
                }
                if(Error != '') {
                    errMessage msg = new errMessage();
                    msg.MessageType = 'Exception';
                    msg.MessageId = 1;
                     if(Error.containsIgnoreCase('cannot be blank'))
                        msg.MessageText = Error;
                    else
                        msg.MessageText = 'Request can\'t be processed, Please contact your administrator.';
                    msgLst.add(msg);
                    errorlst.Message = msgLst;
                    response.Messages = errorlst;
                    response.header = ConfigureSMSProgressStatus.header;
                    response.header.orgId = system.label.EON_Sanbox_Name;//'MORR';
                    midosTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                    midosTracker.Status__c = EON_Utility.RESULT_FAIL; 
                    midosTracker.Error__c = Error;
                }
            } 
            else{
                Error = 'Request Not Found';
                errMessage msg = new errMessage();
                msg.MessageType = 'Exception';
                msg.MessageId = 1;
                msg.MessageText = 'Request can\'t be processed, Please contact your administrator.';
                msgLst.add(msg);
                errorlst.Message = msgLst;
                response.Messages = errorlst;
                midosTracker.Request_Data__c = 'Blank Request';
                midosTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                midosTracker.Status__c = EON_Utility.RESULT_FAIL;
                midosTracker.Error__c = Error;
            }
        }catch(Exception ex){
            Error = ex.getmessage();
            System.debug('**** Exception Occured ' + ex.getStackTraceString());
            errMessage msg = new errMessage();
            msg.MessageType = 'Exception';
            msg.MessageId = 1;
            msg.MessageText = 'Request can\'t be processed, Please contact your administrator.';
            msgLst.add(msg);
            errorlst.Message = msgLst;
            response.Messages = errorlst;
            response.header = ConfigureSMSProgressStatus.header;
            midosTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
            midosTracker.Status__c = EON_Utility.RESULT_FAIL;
            midosTracker.Error__c = Error;
            response.header.orgId = system.label.EON_Sanbox_Name;//'MORR';
        }   
        
        //CH02.Start
        if(Test.isRunningTest() || oracTracker.EON_Appointment__c != null){
              midosTracker.Appointment_Number__c = oracTracker.EON_Appointment__c;
        }        
        //CH02.End
         
        insert midosTracker;
        //CH01.start
        if(oracTracker != null && oracTracker.id != null){
            oracTracker.MIDOS_Data_Tracker__c = midosTracker.id;
            update oracTracker;
        }
        //CH01.End
        EON_Utility.createAttachment(midosTracker.id, midosTracker.Request_Data__c, midosTracker.id);
        system.debug('---got here--');
        return response; 
    }                                                                   
}