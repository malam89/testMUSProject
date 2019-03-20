/**
Description : This Mock class is for the following below classes

**/

/*
    Created By  : Shruti Moghe
    Created On  : 25/04/2017
    Service Req : 
    Change History
*/
@isTest
global class NGS_S3_WO_Assignment_to_IFS_WSMock implements WebServiceMock {
    /*
        doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
           String responseName,String responseType) - This method is used to generate success mock response.
    */
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,
                                        String soapAction,String requestName,String responseNS,
                                        String responseName,String responseType) {
        NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignment workOrderAssignment = new NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignment();
        workOrderAssignment.workOrderNumber =453489340;
        workOrderAssignment.acceptance='true';
        workOrderAssignment.startDate =system.now();
        workOrderAssignment.messageDate=system.now();
        workOrderAssignment.executionTime=45;
        workOrderAssignment.employeeId='38833';
        workOrderAssignment.employeeName='test';
        workOrderAssignment.notes='testing';
        workOrderAssignment.serviceProvider='SP02';
        NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse  responseFinal = new NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse();
        Map<String, NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse> response_map_x = new Map<String, NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse>();
        NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse response_x = new NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse();
        NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentData request_x = new NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentData();
        request_x.workOrderAssignment = workOrderAssignment;
        responseFinal.workOrderNumber=123455;
        responseFinal.action='TRUE';
        responseFinal.startDate=system.now();
        responseFinal.messageDate=system.now();
        responseFinal.executionTime=45;
        responseFinal.employeeId='325638659';
        responseFinal.employeeName='Test User';
        responseFinal.notes='Testing';
        responseFinal.serviceProvider='SP02';
        response_x.return_x = responseFinal;
        response_map_x.put('response_x',response_x);
        response = response_map_x;
    }
}