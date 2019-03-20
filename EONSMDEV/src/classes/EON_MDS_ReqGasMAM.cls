/**
Description : This class used to Validate MPRN MAM. 
MPRN Number will pass as request to MDS to check whether Morrison is Meter Asset Manager (MAM) for given MPRN Number
This class will return a Effective from Date and Effective to date as response of the request

VF Page     : None
Test Class  : EON_MDS_ElecGasData_Test

**/
/*
Created By  : Tabish Almas
Created On  : 29/01/2019
Service Req : SR_optiMUS_EON_297
Change History
*/

public class EON_MDS_ReqGasMAM {
    public static MDS_Data_Tracker__c cTrack;
    
    /**
        ValidateMPRNMAM(string mpanVal)
    **/
    public static MAMValidationResponse ValidateMPRNMAM(string mprnVal){
        map<string,string> mapSuppDesc = new map<string,string>(); //contain EON supplier code and description
        string tranID = EON_Utility.GenUniqueNum(); //generating unique random number value
        MAMValidationResponse response = new MAMValidationResponse();
        cTrack = new MDS_Data_Tracker__c();
        cTrack.Direction__c = EON_Utility.DIRECTION_OUT;
        cTrack.Command__c =EON_MDS_Utility.CMD_MDS_ValidateMPRN;
        cTrack.Transaction_ID__c =tranID;
        EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement MDSObj = new EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement();
        string Access_Token = system.label.EON_MDS_AccessToken;
        MDSObj.inputHttpHeaders_x = new Map<String, String>();
        MDSObj.inputHttpHeaders_x.put('Authorization','Bearer ' + Access_Token);
        
        //Creating requets to send to Jumbo
        if(!EON_Utility.validateRequired(mprnVal)){
            List<string> lSupp = system.label.EON_MDS_Gas_Supplier.split(';'); 
            for(string st : lSupp){
                if(!mapSuppDesc.containsKey(st))
                    mapSuppDesc.put(st,st); 
            }
            //instantiating response object
            EON_MDS_Work_Management_WS.GasSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.GasSupplierDetailsResponse();
            EON_MDS_Work_Management_WS.ClientData clientInfo = new EON_MDS_Work_Management_WS.ClientData();
            ClientInfo.Id =system.label.EON_MDS_Client_Id;
            ClientInfo.Name =system.label.EON_MDS_Client_Name;
            EON_MDS_Work_Management_WS.GasSupplierDetailsRequest reqMDS  = new EON_MDS_Work_Management_WS.GasSupplierDetailsRequest();
            reqMDS.UniqueId = tranID;
            reqMDS.MPRN = mprnVal;
            reqMDS.Client = ClientInfo;
            cTrack.Request_Data__c = string.valueOf(reqMDS); //populating request data
            try{
                respMDS = MDSObj.RequestGasSupplierAppointments(reqMDS);
                if(respMDS.Success){
                    if(!EON_Utility.validateRequired(respMDS.MeterPoint)){
                        if(!EON_Utility.validateRequired(respMDS.MeterPoint.SupplierAppointments)){
                            if(!EON_Utility.validateRequired(respMDS.MeterPoint.SupplierAppointments.GasAppointedParty)){
                                for(EON_MDS_Work_Management_WS.GasAppointedParty mam: respMDS.MeterPoint.SupplierAppointments.GasAppointedParty){
                                    if(mapSuppDesc.containsKey(mam.AbbreviatedName)){
                                        response.abbrvtdName =  mapSuppDesc.get(mam.AbbreviatedName);
                                        response.effFromDate = EON_MDS_Utility.strigToDate(mam.EffectiveFromDate);
                                        response.effToDate = EON_MDS_Utility.strigToDate(mam.EffectiveToDate);
                                        cTrack.Response_Data__c=string.ValueOf(respMDS); //populating response data
                                        cTrack.Status__c=EON_Utility.RESULT_PASS;
                                        return response; 
                                    }  
                                }
                            }
                        }    
                    }  
                    
                    cTrack.Response_Data__c=string.ValueOf(respMDS); //populating response data
                    cTrack.Status__c=EON_Utility.RESULT_PASS;
                    response.Error='No Related supplier record Found'; 
                    response.isError = true;
                    return response;                  
                }
                else{
                    cTrack.Response_Data__c=string.ValueOf(respMDS); //populating response data
                    cTrack.Status__c=EON_Utility.RESULT_PASS;
                    for(String str:respMDS.Errors.Message)
                        response.Error=response.Error+str+'\n';  
                    response.isError = true;
                    return response;
                }
            }
            catch(Exception e){
                cTrack.Response_Data__c=e.getMessage()+'\n'+e.getStackTraceString()+'\n'+e.getLineNumber()+'\n'+(!EON_Utility.validateRequired(cTrack.Response_Data__c)?cTrack.Response_Data__c:'');
                cTrack.Status__c=EON_Utility.RESULT_FAIL;
                response.Error=cTrack.Response_Data__c;
                response.isError =true;
                return response;
            }  
        }
        else{
            response.Error='MPRN cannot pass as Blank to check MAM Validation';
            response.isError = true;
            return response;
        }
    }

    // class to Sent back the response
    public class MAMValidationResponse{
        public Date effFromDate; //Contain Effective From Date
        public Date effToDate; //Contain Effective To Date
        public string abbrvtdName = ''; //Contain Market bbreviated Name
        public boolean isError = false; //Check for any unexpected error 
        public string  Error = '';  //contains the Error Body 
    }
    
    /** 
        supplierDesc(String val):return Eon supplier description as per Code Supplied 
    **/  
    public static String supplierDesc(String suppVal){ 
        if(suppVal == 'EAS')return 'E.ON Energy Gas (Eastern) Ltd';
        if(suppVal == 'EMI')return 'E.ON Industrial Shipping Ltd';
        if(suppVal == 'KIN')return 'E.ON Gas Ltd';
        if(suppVal == 'POW')return 'E.ON UK Plc';
        if(suppVal == 'SGL')return 'E.ON Energy Solutions Ltd';   
        if(suppVal == 'TUK')return 'E.ON Energy Solutions Ltd';
        if(suppVal == 'TUU')return 'E.ON Energy Solutions Ltd';
        if(suppVal == 'UNI')return 'E.ON Energy Gas (North West) Ltd';   
        return null ;                                   
    }
}