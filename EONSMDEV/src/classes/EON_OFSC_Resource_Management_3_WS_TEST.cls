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
global class EON_OFSC_Resource_Management_3_WS_TEST implements WebServiceMock {
    public static boolean temp;
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
        String responseName,String responseType) {
        //CH01
       if(temp!=true){
            EON_OFSC_Resource_Management_3_WS.SetResourceResponseElement resp = new EON_OFSC_Resource_Management_3_WS.SetResourceResponseElement();
            resp.result_code = 0;
            resp.error_msg = ''; 
            response.put('response_x', resp);
        }
        
    }
}