@istest
global class NGS_S1_Send_ResAvailability_to_IFS_Mock implements WebServiceMock{
 global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType) {
     List<NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shiftAvailability> availabilities= new  List<NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shiftAvailability>();
       NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shiftAvailability objShift = new NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shiftAvailability();
       objShift.employeeId = 'hy45678';
        objShift.employeeId = '40093';
        objShift.shiftDate = datetime.now();
        objShift.shiftStartTime = datetime.now();
        objShift.shiftFinishTime = datetime.now(); 
        objShift.active = 'true';
        objShift.serviceProvider = 'test';
       availabilities.add(objShift);
       NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse responseObj = new NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse();
       NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shifts shifts = new NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shifts();
       Shifts.availabilities = availabilities;
       responseObj.return_x = shifts;
       response.put('response_x', responseObj);
   }
}