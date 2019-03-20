/*
 class         : NGS_S1_ResourceAvailabiltiy_IFS
 created by    : venkat pattapu
 changehistory :

*/

@istest
private class NGS_S1_ResourceAvailabiltiy_IFS_Test {
    @istest static void unit1(){
    NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfo sd =new NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfo();
    }
    @istest static void unit2(){
    NGS_S1_ResourceAvailabiltiy_IFS_WS.shiftAvailability sd1 =new NGS_S1_ResourceAvailabiltiy_IFS_WS.shiftAvailability();
     sd1.employeeId='text';
        sd1.shiftStartTime=system.today();
        sd1.shiftDate=system.today();
    }
    @istest static void unit3(){
    NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse sd1 =new NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse();
    }
    @istest static void unit4(){
    NGS_S1_ResourceAvailabiltiy_IFS_WS.shifts  sd1 =new NGS_S1_ResourceAvailabiltiy_IFS_WS.shifts();
    }
     
    @istest static void unit5(){
    NGS_S1_ResourceAvailabiltiy_IFS_WS.ReceiveShiftPort  sd1 =new NGS_S1_ResourceAvailabiltiy_IFS_WS.ReceiveShiftPort();
    sd1.clientCertName_x='teabs';
      sd1.clientCert_x='yert';
        sd1.clientCertPasswd_x='yurty';
        sd1.timeout_x=123;
    }
    @istest static void unit6(){
       test.setmock(WebServiceMock.class, new NGS_S1_Send_ResAvailability_to_IFS_Mock());  
       NGS_S1_Send_ResourceAvailability_to_IFS.ResourceAvailibilityCall();
    }
   
    
}