/**
Description : This is mock class for the below classes
              EON_GET_Job_Service_from_EON_WS
              EON_GET_Job_Service_Schema_WS
**/

/*
    Created By  : Dharmendra Pahadiya
    Created On  : 11/07/2016
    Service Req : SR_EON_AB_081
    Change History : 
*/
@isTest
public class EON_GET_Job_Service_Fail_EON_WSMockImpl implements WebServiceMock {
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
       
    System.debug(LoggingLevel.INFO, 'EON_GET_Job_Service_from_EON_WSMockImpl.doInvoke() - ' +
      '\n request: ' + request +
      '\n response: ' + response +
      '\n endpoint: ' + endpoint +
      '\n soapAction: ' + soapAction +
      '\n requestName: ' + requestName +
      '\n responseNS: ' + responseNS +
      '\n responseName: ' + responseName +
      '\n responseType: ' + responseType);

    if(request instanceOf EON_GET_Job_Service_from_EON_WS.GetAllJobTypes_element) {
      
      EON_GET_Job_Service_Schema_WS.MessageDto msg = new EON_GET_Job_Service_Schema_WS.MessageDto();
      msg.MessageId = 1;
      msg.MessageText = 'Exception occurred';
      msg.MessageType = 'Exception';
      
      EON_GET_Job_Service_Schema_WS.MessageDto[] msgs = new EON_GET_Job_Service_Schema_WS.MessageDto[]{msg};
      
      EON_GET_Job_Service_Schema_WS.ArrayOfMessageDto msgArr = new EON_GET_Job_Service_Schema_WS.ArrayOfMessageDto();
      msgArr.MessageDto = msgs;
      
      EON_GET_Job_Service_Schema_WS.MessageReportDto msgRpt = new EON_GET_Job_Service_Schema_WS.MessageReportDto();
      msgRpt.Messages = msgArr;
      
      EON_GET_Job_Service_Schema_WS.JobTypesResponseDto getAllJobsRes = new EON_GET_Job_Service_Schema_WS.JobTypesResponseDto();
      getAllJobsRes.MessageReport = msgRpt;
      
      EON_GET_Job_Service_from_EON_WS.GetAllJobTypesResponse_element respElem = new EON_GET_Job_Service_from_EON_WS.GetAllJobTypesResponse_element();
      respElem.GetAllJobTypesResult = getAllJobsRes;
      
      response.put( 'response_x', respElem);//
    }
    /*else if(request instanceOf EON_GET_Job_Service_from_EON_WS.ProvideServiceStatus_element) {
      EON_GET_Job_Service_Schema_WS.ServiceStatusResponseDto responseData = new EON_GET_Job_Service_Schema_WS.ServiceStatusResponseDto();
      responseData.AcknowledgementId = 123456789;
      responseData.AuditDate = datetime.now();
      responseData.ErrorMessage = '';
      responseData.OrgId = 'EON';
      responseData.Status = 1;
      
      EON_GET_Job_Service_from_EON_WS.ProvideServiceStatusResponse_element res = new EON_GET_Job_Service_from_EON_WS.ProvideServiceStatusResponse_element();
      res.ProvideServiceStatusResult = responseData;
      response.put( 'response_x', new EON_GET_Job_Service_from_EON_WS.ProvideServiceStatusResponse_element());
    }*/
  }
}