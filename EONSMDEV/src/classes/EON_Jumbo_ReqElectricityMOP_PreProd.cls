/**
    Description: This class is duplicate of EON_Jumbo_ReqElectricityMOP and created for deployment puppose and will be removed immediately after 
				deployment of interface EON_Jumbo_ReqElectricityMOP
    Test Class : EON_Jumbo_ReqElectricityMOP_PreProd_Test
**/
/*
    Created By : Mahadev J
    Created Date : 21/11/2016
    Service Request : 
    Change History:
*/
public with sharing class EON_Jumbo_ReqElectricityMOP_PreProd {
    /**
  		AccessElecSupAppointment(string mpanVal){
  	**/
    Public static MOPValidationResponse ValidateMPANMOP(string mpanVal){
        string tranID = EON_Utility.GenUniqueNum();
        MOPValidationResponse response = new MOPValidationResponse();
        EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
        try{
            if(EON_Jumbo_ReqElectricityMOP_PreProd_Test.genException == null)
                EON_Jumbo_ReqElectricityMOP_PreProd_Test.genException = false;
            if(EON_Jumbo_ReqElectricityMOP_PreProd_Test.genException == true)
               ID test = ID.valueOf('test') ;
           	EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
           	EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
           	ClientInfo.Id =system.label.EON_Jumbo_Client_Id;
           	ClientInfo.Name =system.label.EON_Jumbo_Client_Name;
           	EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest reqJumbo  = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest();
           	reqJumbo.UniqueId=tranID;
           	reqJumbo.MPAN =mpanVal;
           	reqJumbo.Client =ClientInfo;
            respJumbo = jumboObj.RequestElectricitySupplierAppointments(reqJumbo);
            system.debug('**********Jumbo Response***********');
            system.debug('Jumbo Response: '+respJumbo);
            if(respJumbo.Success){
                system.debug('*******Jumbo Success Received*******');
            }
            else{
                system.debug('*******Jumbo Failure Received*******');
            }
        }
        catch(Exception ex){
            system.debug('***************Error***************');
            System.debug('Error Stack Trace: '+ex.getStackTraceString());
            System.debug('Error Message: '+ex.getMessage());
            system.debug('Error Type: '+ex.getTypeName());
            system.debug('Error Cause: '+ex.getCause());
        }
        return response;
    }
    
    // class to Sent back the response
 	public class MOPValidationResponse{
    	public Date effFromDate; //Contain Effective From Date
    	public Date effToDate; //Contain Effective To Date
    	public string marParticipantId = ''; //Contain Market Participent ID 
    	public boolean isError = false; //Check for any unexpected error 
    	public string  Error = '';  //contains the Error Body 
  	}
}