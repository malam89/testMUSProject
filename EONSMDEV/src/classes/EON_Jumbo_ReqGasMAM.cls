/**
    Description : This class used to Validate MPRN MAM. 
                  MPRN Number will pass as request to JUMBO to check whether Morrison is Meter Asset Manager (MAM) for given MPRN Number
                  this class will return a Effective from Date and Effective to date as response of the request

    VF Page     : None
    Test Class  : EON_Jumbo_ElecGasData_Test

**/
/*
    Created By  : Mehboob Alam
    Created On  : 21/04/2016
    Service Req : SR_EON_Jumbo_014
    Change History
		CH01 # SR_EON_Jumbo_087 # 06/12/2016 # Mahadev J # Updated mapping for field AbbreviatedName
*/

public with sharing class EON_Jumbo_ReqGasMAM{
  public static JUMBO_Data_Tracker__c cTrack;

   /**
    ValidateMPRNMAM(string mpanVal)
   **/
  public static MAMValidationResponse ValidateMPRNMAM(string mprnVal){
    map<string,string> mapSuppDesc = new map<string,string>(); //contain EON supplier code and description
    string tranID = EON_Utility.GenUniqueNum(); //generating unique random number value
    MAMValidationResponse response = new MAMValidationResponse();
    cTrack = new JUMBO_Data_Tracker__c();
    cTrack.Direction__c = EON_Utility.DIRECTION_OUT;
    cTrack.Command__c =JUMBO_Utility.CMD_JUMBO_ValidateMPRN;
    cTrack.Transaction_ID__c =tranID;
    EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
    
    //Creating requets to send to Jumbo
    if(!EON_Utility.validateRequired(mprnVal)){
       List<string> lSupp = system.label.EON_Jumbo_Gas_Supplier.split(';'); 
       for(string st : lSupp){
        if(!mapSuppDesc.containsKey(st))
           //mapSuppDesc.put(st,supplierDesc(st)); //CH01.Old
           mapSuppDesc.put(st,st); //CH01.New
       }
      //instantiating response object
      EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
      EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
      ClientInfo.Id =system.label.EON_Jumbo_Client_Id;
      ClientInfo.Name =system.label.EON_Jumbo_Client_Name;
      EON_JUMBO_Work_Management_WS.GasSupplierDetailsRequest reqJumbo  = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsRequest();
      reqJumbo.UniqueId=tranID;
      reqJumbo.MPRN =mprnVal;
      reqJumbo.Client =ClientInfo;
      cTrack.Request_Data__c=string.valueOf(reqJumbo); //populating request data
      try{
        respJumbo = jumboObj.RequestGasSupplierAppointments(reqJumbo);
        if(respJumbo.Success){
            if(!EON_Utility.validateRequired(respJumbo.MeterPoint)){
                if(!EON_Utility.validateRequired(respJumbo.MeterPoint.SupplierAppointments)){
                    if(!EON_Utility.validateRequired(respJumbo.MeterPoint.SupplierAppointments.GasAppointedParty)){
                        for(EON_JUMBO_Work_Management_WS.GasAppointedParty mam: respJumbo.MeterPoint.SupplierAppointments.GasAppointedParty){
                            if(mapSuppDesc.containsKey(mam.AbbreviatedName)){
                                response.abbrvtdName =  mapSuppDesc.get(mam.AbbreviatedName);
                                response.effFromDate = JUMBO_Utility.strigToDate(mam.EffectiveFromDate);
                                response.effToDate = JUMBO_Utility.strigToDate(mam.EffectiveToDate);
                                cTrack.Response_Data__c=string.ValueOf(respJumbo); //populating response data
                                cTrack.Status__c=EON_Utility.RESULT_PASS;
                                return response; 
                            }  
                        }
                    }
                }    
            }  
            
             cTrack.Response_Data__c=string.ValueOf(respJumbo); //populating response data
             cTrack.Status__c=EON_Utility.RESULT_PASS;
             response.Error='No Related supplier record Found'; 
             response.isError = true;
             return response;                  
           }
           else{
             cTrack.Response_Data__c=string.ValueOf(respJumbo); //populating response data
             cTrack.Status__c=EON_Utility.RESULT_PASS;
             for(String str:respJumbo.Errors.Message)
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
  
   
   //CH01.Start
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
  //CH01.End
  
}