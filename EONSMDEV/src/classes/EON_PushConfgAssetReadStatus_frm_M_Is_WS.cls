/**
    Description : This class will be used for generating WSDL, so that MIDOS can use this WSDL to push Asset Read Status to Isis for meters just commissioned.
                  It will be the first message from MIDOS via Isis to commissioning App in oracle.
                  
    Test Class  : EON_PushConfigAssetReadStatus_test

**/
/*
    Created By  : Akshay Bairagi
    Created On  : 14/03/2016
    Service Req : SR_EON_Mobile_007
    Change History : CH01 # SR_EON_Mobile_036 # 06/05/2016 # Dharmendra P # Added logic to link MIDOS and Oracle Tracker records.
                     CH02 # SR_Isis_EON_018 # 06/06/2016 # Dharmendra Pahadiya # Updated 'OrgId' mapping.
                     CH03 # SR_EON_Mobile_116 # 25/01/2017 # Praveen G # Added logic to update the Appointment for 
                     MIDOS tracker records.
                     CH04 # SR_OptiMUS_EON_192 # 25/01/2018 # Praveen G # Added fix for quiuing issue
*/
global with sharing class EON_PushConfgAssetReadStatus_frm_M_Is_WS {
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
    global with sharing class Register {  
        Webservice string RegisterId;
        Webservice integer RegisterRead;
        Webservice String TPR;
    }
    /**
        Description : Request Parameter 2
    **/
    global with sharing class Reglst {  
        Webservice list<Register> Register;
    }
    /**
        Description : Request Parameter 3
    **/
    global with sharing class ElectricMeterRead{  
        Webservice string SSC;
        Webservice Reglst Registers;
    }
    /**
        Description : Request Parameter 4
    **/
    global with sharing class GasMeterRead{  
        Webservice integer GasRegisterRead;
    }
    /**
        Description : Request Parameter 5
    **/
    global with sharing class PushConfgAssetReadStatus {  
        Webservice HeaderElement Header;
        Webservice String StatusMessage;
        Webservice String StatusValue;
        Webservice String ErrorMessage;
        Webservice ElectricMeterRead ElectricMeterRead;
        Webservice GasMeterRead GasMeterRead;
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
    global with sharing class Isis_Response_Acknowledgement_To_MIDOS{
        Webservice HeaderElement Header;
        Webservice errMessageLst Messages;
    }   
    /**
        Isis_Response_Acknowledgement_To_MIDOS PushConfgAssetReadStatus(PushConfgAssetReadStatus ConfigureSMSAssetReadStatus) - 
                This method is used to get progress statuses from MIDOS.
    **/
    webservice static Isis_Response_Acknowledgement_To_MIDOS PushConfgAssetReadStatus(PushConfgAssetReadStatus ConfigureSMSAssetReadStatus){ 
        Isis_Response_Acknowledgement_To_MIDOS response = new Isis_Response_Acknowledgement_To_MIDOS();
        errMessageLst errorlst = new errMessageLst();
        MIDOS_Data_Tracker__c midosTracker = new MIDOS_Data_Tracker__c();
        Oracle_Data_Tracker__c oracTracker = new Oracle_Data_Tracker__c();
        midosTracker.Direction__c = 'IN'; 
        midosTracker.Command__c = 'PushConfgAssetReadStatus';
        midosTracker.Status__c = EON_Utility.RESULT_PASS;
        list<errMessage> msgLst = new list<errMessage>();
        string Error = '';
        try{
            if(ConfigureSMSAssetReadStatus != null){
                midosTracker.Request_Data__c = EON_Utility.validateStringLength(ConfigureSMSAssetReadStatus + '');                                                                                             
                midosTracker.Transaction_ID__c = ConfigureSMSAssetReadStatus.header.requestId; 
                if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.header.orgId) == true){
                    Error = 'OrgId cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.header.requestId) == true){
                    Error = Error + 'RequestId cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.header.RequestDateTime) == true){
                    Error = Error + 'RequestDateTime cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.StatusMessage) == true){
                    Error = Error + 'StatusMessage cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.StatusValue) == true){
                    Error = Error + 'StatusValue cannot be blank\n';
                }
                if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.ElectricMeterRead) != true){
                    if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.ElectricMeterRead.SSC) == true){
                        Error = Error + 'SSC cannot be blank\n';
                    }
                    if(ConfigureSMSAssetReadStatus.ElectricMeterRead.Registers != null && ConfigureSMSAssetReadStatus.ElectricMeterRead.Registers.Register != null)
                    for(Register Reg : ConfigureSMSAssetReadStatus.ElectricMeterRead.Registers.Register){
                        if(EON_Utility.validateRequired(Reg.RegisterId) == true){
                            Error = Error + 'RegisterId cannot be blank\n'; 
                            break;
                        }
                        if(EON_Utility.validateRequired(Reg.RegisterRead) == true){
                            Error = Error + 'RegisterRead cannot be blank\n'; 
                            break;
                        }
                    }
                }else if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.GasMeterRead) != true){
                    if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.GasMeterRead.GasRegisterRead) == true){
                        Error = Error + 'GasRegisterRead cannot be blank\n';
                    }
                }else{
                    Error = Error + 'Either ElectricMeterRead or GasRegisterRead must be present.\n';
                }
                if(Error == ''){
                    EON_MIDOS_To_Isis_Wrapper wppr = new EON_MIDOS_To_Isis_Wrapper();
                    wppr.Subject = 'PushConfgAssetReadStatus';
                    EON_MIDOS_To_Isis_Wrapper.HeaderElement head = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
                    head.OrgId = ConfigureSMSAssetReadStatus.header.orgId;
                    //Extract Appointment ID from MDT ID received in request ID and then send to OFSC i.e. Wrapper Class
                    string MDT = ConfigureSMSAssetReadStatus.header.requestId;
                    string Appt_Id = '';
                    
                    //CH04.Start
                    list<MIDOS_Data_Tracker__c> MDTlst = new list<MIDOS_Data_Tracker__c>();
                    if(System.Label.Is_Future == 'TRUE')
                        MDTlst = [select id,name,Appointment_Number__c from MIDOS_Data_Tracker__c where Name =:MDT];
                    else
                        MDTlst = [select id,name,Appointment_Number__c from MIDOS_Data_Tracker__c where Transaction_ID__c=:MDT];
                    //CH04.End                    
                    
                    if(MDTlst != null && MDTlst.size()>0){
                        Appt_Id = MDTlst[0].Appointment_Number__c;
                        midosTracker.MIDOS_Data_Tracker__c = MDTlst[0].Id;
                    }
                    else{
                        Error = 'Request ID not valid, Please contact your administrator.';
                    }
                    //
                    head.RequestId = Appt_Id;//
                    head.RequestDateTime = ConfigureSMSAssetReadStatus.header.RequestDateTime;
                    wppr.Header = head;
                    wppr.StatusValue = EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.StatusValue)?'':ConfigureSMSAssetReadStatus.StatusValue;
                    wppr.StatusMessage = ConfigureSMSAssetReadStatus.StatusMessage;
                    wppr.ErrorMessage = EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.ErrorMessage)?'':ConfigureSMSAssetReadStatus.ErrorMessage;
                    if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.ElectricMeterRead) != true){
                        EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element EMR = new EON_MIDOS_To_Isis_Wrapper.ElectricMeterRead_Element();
                        EMR.SSC = ConfigureSMSAssetReadStatus.ElectricMeterRead.SSC;
                        EON_MIDOS_To_Isis_Wrapper.RegisterElement objReg;
                        list<EON_MIDOS_To_Isis_Wrapper.RegisterElement> objReglst = new list<EON_MIDOS_To_Isis_Wrapper.RegisterElement>();
                        for(Register Reg : ConfigureSMSAssetReadStatus.ElectricMeterRead.Registers.Register){
                            objReg = new EON_MIDOS_To_Isis_Wrapper.RegisterElement();
                            if(EON_Utility.validateRequired(Reg.RegisterId) != true){
                                objReg.RegisterId = Reg.RegisterId;
                                if(Reg.RegisterRead != null)
                                    objReg.RegisterRead = Reg.RegisterRead;
                                if(Reg.TPR != null) 
                                    objReg.TPR = Reg.TPR;
                                objReglst.add(objReg);
                            }
                        }
                        if(objReglst != null && objReglst.size()>0){
                            EMR.Registers = objReglst;
                        }
                        wppr.EleMeterRead = EMR;
                    }   
                    EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element GMR = new EON_MIDOS_To_Isis_Wrapper.GasMeterRead_Element();
                    if(EON_Utility.validateRequired(ConfigureSMSAssetReadStatus.GasMeterRead) != true){
                        if(ConfigureSMSAssetReadStatus.GasMeterRead.GasRegisterRead != null)
                            GMR.GasRegisterRead = ConfigureSMSAssetReadStatus.GasMeterRead.GasRegisterRead;
                        wppr.GasMeterRead = GMR;    
                    }   
                    if(Error == ''){
                        Error = EON_MIDOS_to_OFSC.sendToOFSC(wppr);
                        system.debug('$$$ ofsc response: '+Error);
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
                        response.header = ConfigureSMSAssetReadStatus.header;
                        //CH02.old //response.header.orgId = UserInfo.getOrganizationId();
                        response.header.orgId = system.label.EON_Sanbox_Name; //CH02.New
                        midosTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                        midosTracker.Status__c = EON_Utility.RESULT_PASS; 
                        Error = '';
                    }
                    else if(Error != null && Error != '' && Error.containsIgnoreCase('exception')){errMessage msg = new errMessage();msg.MessageType = 'Exception';msg.MessageId = 1; msg.MessageText = Error; msgLst.add(msg); errorlst.Message = msgLst; response.Messages = errorlst; response.header = ConfigureSMSAssetReadStatus.header; response.header.orgId = system.label.EON_Sanbox_Name; midosTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); midosTracker.Status__c = EON_Utility.RESULT_FAIL; midosTracker.Error__c = Error;}
                }
                if(Error != '') {
                    errMessage msg = new errMessage();
                    msg.MessageType = 'Exception';
                    msg.MessageId = 1;
                    msg.MessageText = Error.containsIgnoreCase('cannot be blank')?Error:'Request can\'t be processed, Please contact your administrator.';
                    msgLst.add(msg);
                    errorlst.Message = msgLst;
                    response.Messages = errorlst;
                    response.header = ConfigureSMSAssetReadStatus.header;
                    //CH02.old //response.header.orgId = UserInfo.getOrganizationId();
                    response.header.orgId = system.label.EON_Sanbox_Name; //CH02.New
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
                msg.MessageText = Error;
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
            response.header = ConfigureSMSAssetReadStatus.header;
            //CH02.old //response.header.orgId = UserInfo.getOrganizationId();
            response.header.orgId = system.label.EON_Sanbox_Name; //CH02.New
            midosTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
            midosTracker.Status__c = EON_Utility.RESULT_FAIL;
            midosTracker.Error__c = Error;
        }
        
        //CH03.Start
        if(Test.isRunningTest() || oracTracker.EON_Appointment__c != null){
              midosTracker.Appointment_Number__c = oracTracker.EON_Appointment__c;
        }        
        //CH03.End
                
        Insert midosTracker;
        //CH01.start        
        if(oracTracker != null && oracTracker.id != null){
            oracTracker.MIDOS_Data_Tracker__c = midosTracker.id;
            update oracTracker;
        }
        //CH01.end
        EON_Utility.createAttachment(midosTracker.id, midosTracker.Request_Data__c, midosTracker.id);
        system.debug('---got here--');
        return response; 
    }                                                                   
}