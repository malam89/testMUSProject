/**
Description : This Mock class is used in below test class
                EON_OFSC_to_MIDOS_Commission_Helper_test
**/

/*
    Created By  : Dharmendra Pahadiya
    Created On  : 17/05/2016
    Service Req : SR_EON_Mobile_019
    Change History :
    CH01 # SR_EON_Mobile_020  # 18/05/2016 # Shruti Moghe # added code to cover logic for SubmitPrePayBalance
    CH02 # SR_EON_Mobile_022  # 20/05/2016 # Dharmendra Pahadiya # added code to cover logic for ConfigureSMSAsset
*/
@isTest
global class EON_OFSC_to_MIDOS_Commissioning_Mock implements WebServiceMock {

    /*
        doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
           String responseName,String responseType) - This method is used to generate success mock response.
    */
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,
           String responseName,String responseType) {
            // Send success response
            EON_MIDOS_Send_Data_Schema_WS.MessageDto msg = new EON_MIDOS_Send_Data_Schema_WS.MessageDto();
            msg.MessageId =1;
            msg.MessageText ='success';
            msg.MessageType ='Information';
            EON_MIDOS_Send_Data_Schema_WS.MessageDto[] arrMsg = new EON_MIDOS_Send_Data_Schema_WS.MessageDto[]{msg};
            EON_MIDOS_Send_Data_Schema_WS.ArrayOfMessageDto arrMsgsRepo = new EON_MIDOS_Send_Data_Schema_WS.ArrayOfMessageDto();
            arrMsgsRepo.MessageDto = arrMsg;
            EON_MIDOS_Send_Data_Schema_WS.MessageReportDto msgRepo = new EON_MIDOS_Send_Data_Schema_WS.MessageReportDto();
            msgRepo.Messages =arrMsgsRepo;
            //if(EON_OFSC_to_MIDOS_Commission_Helper_test.subject=='SubmitCreditMeterReading'){
            if(request instanceOf EON_MIDOS_Send_Data_WS.SubmitCreditMeterReading_element) {
                EON_MIDOS_Send_Data_Schema_WS.SubmitCreditMeterReadingResponseDto resData = new EON_MIDOS_Send_Data_Schema_WS.SubmitCreditMeterReadingResponseDto();
                resData.MessageReport = msgRepo;
                EON_MIDOS_Send_Data_WS.SubmitCreditMeterReadingResponse_element res = new EON_MIDOS_Send_Data_WS.SubmitCreditMeterReadingResponse_element();
                res.SubmitCreditMeterReadingResult = resData;
                response.put('response_x', res);
            }
            //CH01.start
            //if(EON_OFSC_to_MIDOS_Commission_Helper_test.subject=='SubmitPrePayBalance'){
            if(request instanceOf EON_MIDOS_Send_Data_WS.SubmitPrePayBalance_element) {
                EON_MIDOS_Send_Data_Schema_WS.SubmitPrepayMeterBalanceResponseDto resData = new EON_MIDOS_Send_Data_Schema_WS.SubmitPrepayMeterBalanceResponseDto();
                resData.MessageReport = msgRepo;
                EON_MIDOS_Send_Data_WS.SubmitPrePayBalanceResponse_element res = new EON_MIDOS_Send_Data_WS.SubmitPrePayBalanceResponse_element();
                res.SubmitPrePayBalanceResult = resData;
                response.put('response_x', res);
            }
            //CH01.end
            //CH02.start
            //if(EON_OFSC_to_MIDOS_Commission_Helper_test.subject=='ConfigureSMSAsset'){
            if(request instanceOf EON_MIDOS_Send_Data_WS.ConfigureSmsAsset_element) {
                EON_MIDOS_Send_Data_Schema_WS.ConfigureSmsAssetResponseDto resData = new EON_MIDOS_Send_Data_Schema_WS.ConfigureSmsAssetResponseDto();
                resData.MessageReport = msgRepo;
                EON_MIDOS_Send_Data_WS.ConfigureSmsAssetResponse_element res = new EON_MIDOS_Send_Data_WS.ConfigureSmsAssetResponse_element();
                res.ConfigureSmsAssetResult = resData;
                response.put('response_x', res);
            }
            //if(EON_OFSC_to_MIDOS_Commission_Helper_test.subject=='ServiceStatus'){
            if(request instanceOf EON_MIDOS_Send_Data_WS.ProvideServiceStatus_element) {
            	EON_MIDOS_Send_Data_Schema_WS.ResponseMessageHeaderDto resHeader = new EON_MIDOS_Send_Data_Schema_WS.ResponseMessageHeaderDto();
            	resHeader.AcknowledgementId = '1';
            	resHeader.AuditDate = datetime.now();
            	resHeader.ErrorMessage = '0';
            	resHeader.OrgId = 'test';
            	resHeader.Status = 0;
            	EON_MIDOS_Send_Data_Schema_WS.ServiceStatusResponseDto resData = new EON_MIDOS_Send_Data_Schema_WS.ServiceStatusResponseDto();
                resData.Header = resHeader;
                EON_MIDOS_Send_Data_WS.ProvideServiceStatusResponse_element res = new EON_MIDOS_Send_Data_WS.ProvideServiceStatusResponse_element();
                res.ProvideServiceStatusResult = resData;
                response.put('response_x', res);
            }
            //if(EON_OFSC_to_MIDOS_Commission_Helper_test.subject=='ValidateSMSAsset'){
            if(request instanceOf EON_MIDOS_Send_Data_WS.ValidateSmsAsset_element) {
                EON_MIDOS_Send_Data_Schema_WS.ValidateSmsAssetReponseDto resData = new EON_MIDOS_Send_Data_Schema_WS.ValidateSmsAssetReponseDto();
                resData.MessageReport = msgRepo;
                EON_MIDOS_Send_Data_WS.ValidateSmsAssetResponse_element res = new EON_MIDOS_Send_Data_WS.ValidateSmsAssetResponse_element();
                res.ValidateSmsAssetResult = resData;
                response.put('response_x', res);
            }
            //CH02.end
   }

}