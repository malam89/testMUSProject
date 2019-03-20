/**
    Description :   This class used to Validate MPAN MOP for MDS. 
                    MPAN Number will be passing as a request to MDS to check whether Morrison is Meter Operator (MOP) for given MPAN Number.
                    This class will return a Effective from Date and Effective to date as response of the request.
                    This class functionality is replicated from Apex Class - EON_Jumbo_ReqElectricityMOP
    
    
    VF Page     : None
    Test Class  : EON_MDS_ElecGasData_Test

**/
/*
    Created By  : Tabish Almas
    Created On  : 29/01/2019
    Service Req : SR_OptiMUS_EON_297
    Change History

*/    
public with sharing class EON_MDS_ReqElectricityMOP {
    public static MDS_Data_Tracker__c cTrack;
    /**
    AccessElecSupAppointment(string mpanVal){
    **/
    Public static MOPValidationResponse ValidateMPANMOP(string mpanVal){
        map<string,string> mapSuppDesc = new map<string,string>(); //contain EON supplier code and description
        string tranID = EON_Utility.GenUniqueNum(); //generating unique random number value
        MOPValidationResponse response = new MOPValidationResponse();
        cTrack = new MDS_Data_Tracker__c();
        cTrack.Direction__c = EON_Utility.DIRECTION_OUT;
        cTrack.Command__c =EON_Utility.CMD_MDS_ValidateMPAN;
        cTrack.Transaction_ID__c =tranID;
        EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement MDSObj = new EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement();
        EON_MDS_OAuth_Authentication.AuthDetail authToken = EON_MDS_OAuth_Authentication.genAccessToken();
        MDSObj.inputHttpHeaders_x = new Map<String, String>();
        MDSObj.inputHttpHeaders_x.put('Authorization','Bearer ' + authToken.accessToken);

        //Creating requets to send to MDS
        if(!EON_Utility.validateRequired(mpanVal)){
            List<string> lSupp = system.label.EON_MDS_Supplier.split(';');
            for(string st : lSupp){
                if(!mapSuppDesc.containsKey(st))
                    mapSuppDesc.put(st,supplierDesc(st));
            }
            //instantiating response object
            EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse();
            EON_MDS_Work_Management_WS.ClientData clientInfo = new EON_MDS_Work_Management_WS.ClientData();
            ClientInfo.Id =system.label.EON_MDS_Client_Id;
            ClientInfo.Name =system.label.EON_MDS_Client_Name;
            EON_MDS_Work_Management_WS.ElecSupplierDetailsRequest reqMDS  = new EON_MDS_Work_Management_WS.ElecSupplierDetailsRequest();
            reqMDS.UniqueId=tranID;
            reqMDS.MPAN =mpanVal;
            reqMDS.Client =ClientInfo;
            cTrack.Request_Data__c=string.valueOf(reqMDS); //populating request data
            try{
                respMDS = MDSObj.RequestElectricitySupplierAppointments(reqMDS);
                //system.debug('###respMDS: '+respMDS);
                if(respMDS.Success){  
                    for(EON_MDS_Work_Management_WS.ElecAppointedParty mop: respMDS.MeterPoint.SupplierAppointments.ElecAppointedParty){
                        if(mapSuppDesc.containsKey(mop.MarketParticipantId)){
                            //system.debug('###mop1: '+mop);
                            response.marParticipantId = mapSuppDesc.get(mop.MarketParticipantId);
                            response.effFromDate = EON_MDS_Utility.strigToDate(mop.EffectiveFromDate);
                            response.effToDate = EON_MDS_Utility.strigToDate(mop.EffectiveToDate);
                            cTrack.Response_Data__c=string.ValueOf(respMDS); //populating response data
                            cTrack.Status__c=EON_Utility.RESULT_PASS;
                            //system.debug('###response1: '+response);
                            //system.debug('###cTrack1: '+cTrack);
                            return response; 
                        }
                    }
                    cTrack.Response_Data__c=string.ValueOf(respMDS); //populating response data
                    cTrack.Status__c=EON_Utility.RESULT_PASS;
                    response.Error='No Related supplier record Found'; 
                    response.isError = true;
                    //system.debug('###response2: '+response);
                    return response;                               
                }
                else{
                    cTrack.Response_Data__c=string.ValueOf(respMDS); //populating response data
                    cTrack.Status__c=EON_Utility.RESULT_PASS;
                    for(String str:respMDS.Errors.Message)
                        response.Error=response.Error+str+'\n'; 
                    response.isError = true;
                    //system.debug('###response3: '+response);
                    return response;
                }
            }
            catch(Exception e){
                if(authToken.Error != '') {
                    cTrack.Response_Data__c=e.getMessage()+'\n'+e.getStackTraceString()+'\n'+e.getLineNumber()+'\n'+cTrack.Response_Data__c+'\nAuthentication Failure:\n'+authToken.Error;
                }
                else {
                    cTrack.Response_Data__c=e.getMessage()+'\n'+e.getStackTraceString()+'\n'+e.getLineNumber()+'\n'+cTrack.Response_Data__c;
                }
                cTrack.Status__c=EON_Utility.RESULT_FAIL;
                response.Error=cTrack.Response_Data__c;
                response.isError = true;
                //system.debug('###response4: '+response);
                return response;
            }  
        } 
        else{
            response.Error='MPAN cannot pass as Blank to check MOP Validation';
            response.isError = true;
            //system.debug('###response5: '+response);
            return response;
        }
    }
    // class to Sent back the response
    public class MOPValidationResponse{
        public Date effFromDate; //Contain Effective From Date
        public Date effToDate; //Contain Effective To Date
        public string marParticipantId = ''; //Contain Market Participent ID 
        public boolean isError = false; //Check for any unexpected error 
        public string  Error = '';  //contains the Error Body 
    }
    
    /** 
    supplierDesc(String val):return Eon supplier description as per Code Supplied 
    **/  
    public static String supplierDesc(String suppVal){ 
        if(suppVal == 'EENG')return 'EON Energy';
        if(suppVal == 'EELC')return 'Eastern Electricity Board';
        if(suppVal == 'EMEB')return 'East Midlands Electricity Board';
        if(suppVal == 'NORW')return 'North Western Electricity Board';
        if(suppVal == 'PGEN')return 'Powergen'; 
        if(suppVal == 'EOND')return 'EON Digital Attacker'; //CH02      
        return null ;                                   
    }
}