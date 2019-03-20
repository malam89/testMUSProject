/**
    Description : This class used to Validate MPAN MOP. 
                  MPAN Number will be passing as a request to JUMBO to check whether Morrison is Meter Operator (MOP) for given MPAN Number
                  this class will return a Effective from Date and Effective to date as response of the request 
     
                  
    VF Page     : None
    Test Class  : EON_Jumbo_ElecGasData_Test

**/
/*
    Created By  : Mehboob Alam
    Created On  : 08/04/2016
    Service Req : SR_EON_Jumbo_013
    Change History
    CH01 # SR_EON_Jumbo_029 # 19/05/2016 # Mehboob Alam # added new EON Supplier desciption and Codes
    CH02 # SR_OptiMUS_EON_257 # 19/07/2018 # Mehboob Alam # added new EON Supplier desciption and Codes
*/
public with sharing class EON_Jumbo_ReqElectricityMOP{
  public static JUMBO_Data_Tracker__c cTrack;

  /**
  AccessElecSupAppointment(string mpanVal){
  **/
  Public static MOPValidationResponse ValidateMPANMOP(string mpanVal){
     map<string,string> mapSuppDesc = new map<string,string>(); //contain EON supplier code and description
     string tranID = EON_Utility.GenUniqueNum(); //generating unique random number value
     MOPValidationResponse response = new MOPValidationResponse();
     cTrack = new JUMBO_Data_Tracker__c();
     cTrack.Direction__c = EON_Utility.DIRECTION_OUT;
     cTrack.Command__c =EON_Utility.CMD_JUMBO_ValidateMPAN;
     cTrack.Transaction_ID__c =tranID;
     EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
    
     //Creating requets to send to Jumbo
     if(!EON_Utility.validateRequired(mpanVal)){
       List<string> lSupp = system.label.EON_Jumbo_Supplier.split(';');
       for(string st : lSupp){
        if(!mapSuppDesc.containsKey(st))
           mapSuppDesc.put(st,supplierDesc(st));
       }
       //instantiating response object
       EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
       EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
       ClientInfo.Id =system.label.EON_Jumbo_Client_Id;
       ClientInfo.Name =system.label.EON_Jumbo_Client_Name;
       EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest reqJumbo  = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest();
       reqJumbo.UniqueId=tranID;
       reqJumbo.MPAN =mpanVal;
       reqJumbo.Client =ClientInfo;
       cTrack.Request_Data__c=string.valueOf(reqJumbo); //populating request data
       try{
         respJumbo = jumboObj.RequestElectricitySupplierAppointments(reqJumbo);
         if(respJumbo.Success){  
            for(EON_JUMBO_Work_Management_WS.ElecAppointedParty mop: respJumbo.MeterPoint.SupplierAppointments.ElecAppointedParty){
               if(mapSuppDesc.containsKey(mop.MarketParticipantId)){
                      response.marParticipantId = mapSuppDesc.get(mop.MarketParticipantId);
                      response.effFromDate = JUMBO_Utility.strigToDate(mop.EffectiveFromDate);
                      response.effToDate = JUMBO_Utility.strigToDate(mop.EffectiveToDate);
                      cTrack.Response_Data__c=string.ValueOf(respJumbo); //populating response data
                      cTrack.Status__c=EON_Utility.RESULT_PASS; 
                      return response; 
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
         cTrack.Response_Data__c=e.getMessage()+'\n'+e.getStackTraceString()+'\n'+e.getLineNumber()+'\n'+cTrack.Response_Data__c;
         cTrack.Status__c=EON_Utility.RESULT_FAIL;
         response.Error=cTrack.Response_Data__c;
         response.isError = true;
         return response;
      }  
    } 
      else{
       response.Error='MPAN cannot pass as Blank to check MOP Validation';
       response.isError = true;
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
  
 
  //CH01.Start
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
  //CH01.End
}