/**
Description : This test class is for the following below classes

**/

/*
    Created By  : 
    Created On  : 
    Service Req : 
    Change History
*/
@isTest
global class NGS_S0_ReceiveHrResource_IFS_WSMock implements WebServiceMock {
    /*
        doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
           String responseName,String responseType) - This method is used to generate success mock response.
    */
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,
                                        String soapAction,String requestName,String responseNS,
                                        String responseName,String responseType) {
        NGS_S0_typesHrResource_IFS_WS.resources responseFinal = new NGS_S0_typesHrResource_IFS_WS.resources();
        Map<String, NGS_S0_ReceiveHrResource_IFS_WS.receiveResourceResponse> response_map_x = new Map<String, NGS_S0_ReceiveHrResource_IFS_WS.receiveResourceResponse>();
        NGS_S0_typesHrResource_IFS_WS.resource[] resourcesArray = new NGS_S0_typesHrResource_IFS_WS.resource[]{};
        NGS_S0_typesHrResource_IFS_WS.resource resourceInst = new NGS_S0_typesHrResource_IFS_WS.resource();
        resourceInst.employeeId = '1234';
        resourceInst.firstName = 'Test';
        resourceInst.lastName = 'Test';
        resourceInst.gender = 'M';
        resourceInst.startLocation = 'SG1';
        resourceInst.mobileNumber = '07405898212';
        resourceInst.serviceProvider = 'SP02';
        resourcesArray.add(resourceInst);
        responseFinal.resourcesConn = resourcesArray;
        NGS_S0_ReceiveHrResource_IFS_WS.receiveResourceResponse response_x = new NGS_S0_ReceiveHrResource_IFS_WS.receiveResourceResponse();
        response_x.return_x = responseFinal;
        response_map_x.put('response_x',response_x);
        response = response_map_x;
    }
}