@isTest
public class NGS_S1_ResourceAvailabiltiy_IFS_MockImpl implements WebServiceMock {
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
       
        System.debug(LoggingLevel.INFO, 'NGS_S1_ResourceAvailabiltiy_IFS_MockImpl.doInvoke() - ' +
            '\n request: ' + request +
            '\n response: ' + response +
            '\n endpoint: ' + endpoint +
            '\n soapAction: ' + soapAction +
            '\n requestName: ' + requestName +
            '\n responseNS: ' + responseNS +
            '\n responseName: ' + responseName +
            '\n responseType: ' + responseType);

        if(request instanceOf NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfo) {
            response.put( 'response_x', new NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse());
        }
    }
}