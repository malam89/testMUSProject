/**
Description : This test class is for the following below classes/triggers
              EON_OFSC_Resource_Management_3_WS
**/

/*
    Created By  : Praveen Garikipati
    Created On  : 08-July-2016
    Service Req : SR_EON_Scheduling_037
    Change History : CH01# 11/07/2016# Reddeiah R # add if condiction.
*/
@isTest
global class EON_OFSC_Resource_Management_3_WS_Tst implements WebServiceMock {
    
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
        String responseName,String responseType) {
        
        EON_OFSC_Resource_Management_3_WS.SetUserResponseElement resp = new EON_OFSC_Resource_Management_3_WS.SetUserResponseElement();
        resp.result_code = 0;
        resp.error_msg = '';
        
        EON_OFSC_Resource_Management_3_WS.SetUserResponseElement mapResp = new EON_OFSC_Resource_Management_3_WS.SetUserResponseElement();
        Map<String, EON_OFSC_Resource_Management_3_WS.SetUserResponseElement> response_map_x = new Map<String, EON_OFSC_Resource_Management_3_WS.SetUserResponseElement>();
        
        response_map_x.put('response_x', resp);
    }
    
 }