@isTest
public class NGS_S0_ReceiveHrResource_IFS_WSMockImpl implements WebServiceMock {
    public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
       
        System.debug(LoggingLevel.INFO, 'NGS_S0_ReceiveHrResource_IFS_WSMockImpl.doInvoke() - ' +
            '\n request: ' + request +
            '\n response: ' + response +
            '\n endpoint: ' + endpoint +
            '\n soapAction: ' + soapAction +
            '\n requestName: ' + requestName +
            '\n responseNS: ' + responseNS +
            '\n responseName: ' + responseName +
            '\n responseType: ' + responseType);

        if(request instanceOf NGS_S0_ReceiveHrResource_IFS_WS.receiveResource) {
            response.put( 'response_x', new NGS_S0_ReceiveHrResource_IFS_WS.receiveResourceResponse());
        }
    }
      
}