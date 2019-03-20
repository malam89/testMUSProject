/**
    Description: This class is duplicate of EON_JUMBO_Create_ElecJob_In_Isis_WS and created for deployment puppose and will be removed immediately after 
				deployment of interface EON_JUMBO_Create_ElecJob_In_Isis_WS
    Test Class : EON_JUMBO_Create_ElecJob_PreProd_Test
**/
/*
    Created By : Mahadev J
    Created Date : 21/11/2016
    Service Request : 
    Change History:
*/
global with sharing class EON_JUMBO_Create_ElecJob_PreProd{
/**
     Description : Request Parameter
    **/
    global with sharing class ElecWorkRequest {
        Webservice String MPAN;
        Webservice Date RequestDate;
        Webservice String RequestTime;
        Webservice Date EarliestStartDate;
        Webservice String EarliestStartTime;
        Webservice Date LatestStartDate;
        Webservice String LatestStartTime;
        Webservice String JUMBOJobType;
        Webservice String JUMBOID;
        Webservice String AdditionalInformation;
        Webservice String RequestedSSC;
    }
    /**
     Description : Response
    **/
    global with sharing class JumboToIsisElecWorkResponse {
        Webservice String Success;
        Webservice String Message;
        Webservice String ExternalJobReference;
    }
    /**
    	createElectricityJobInIsis(ElecWorkRequest elecRequest) - This method is used to create an app record in Isis.
    **/
    webservice static JumboToIsisElecWorkResponse createElectricityJobInIsis(ElecWorkRequest elecRequest){
        JumboToIsisElecWorkResponse response = new JumboToIsisElecWorkResponse();
        try{
            if(EON_JUMBO_Create_ElecJob_PreProd_Test.genException == null)
                EON_JUMBO_Create_ElecJob_PreProd_Test.genException = false;
            if(EON_JUMBO_Create_ElecJob_PreProd_Test.genException == true)
                ID test = ID.valueOf('test');
            response.Success = 'PASS';
            response.Message = 'Test is successfull.';
            response.ExternalJobReference = 'MORR - Test';
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
}