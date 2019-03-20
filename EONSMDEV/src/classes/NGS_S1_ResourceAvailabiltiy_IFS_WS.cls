/**
    Description : This class created from the wsdl file provided through IFS for S1 – Resource Availability to IFS
                  
    VF Page     : None
    Test Class  : NGS_S1_ResourceAvailabiltiy_IFS_Test

**/
/*
    Created By  : Shruti Moghe
    Created On  : 23/03/2017
    Service Req : SR_OptiMUS_NG_027
    Change History :

*/
    
public class NGS_S1_ResourceAvailabiltiy_IFS_WS {
    public class receiveShiftInfo {
        public NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shifts ngsHrSp1In;
        private String[] ngsHrSp1In_type_info = new String[]{'ngsHrSp1In','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://receiveshift.creceivewoshift.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'ngsHrSp1In'};
    }
    public class WebServiceException Extends Exception{
        public String message;
        public String type_x;
        public String extraInfo;
        public String causedClass;
        public String causedStackTrace;
        private String[] message_type_info = new String[]{'message','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] extraInfo_type_info = new String[]{'extraInfo','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] causedClass_type_info = new String[]{'causedClass','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] causedStackTrace_type_info = new String[]{'causedStackTrace','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://receiveshift.creceivewoshift.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'message','type_x','extraInfo','causedClass','causedStackTrace'};
    }
    public class shiftAvailability {
        public String employeeId;
        public DateTime shiftDate;
        public DateTime shiftStartTime;
        public DateTime shiftFinishTime;
        public String active;
        public String serviceProvider;
        private String[] employeeId_type_info = new String[]{'employeeId','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] shiftDate_type_info = new String[]{'shiftDate','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] shiftStartTime_type_info = new String[]{'shiftStartTime','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] shiftFinishTime_type_info = new String[]{'shiftFinishTime','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] active_type_info = new String[]{'active','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] serviceProvider_type_info = new String[]{'serviceProvider','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://receiveshift.creceivewoshift.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'employeeId','shiftDate','shiftStartTime','shiftFinishTime','active','serviceProvider'};
    }
    public class receiveShiftInfoResponse {
        public NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shifts return_x;
        private String[] return_x_type_info = new String[]{'return','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://receiveshift.creceivewoshift.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class shifts {
        public NGS_S1_ResourceAvailabiltiy_IFS_WS.shiftAvailability[] availabilities;
        private String[] availabilities_type_info = new String[]{'availabilities','http://receiveshift.creceivewoshift.webservices.ifsworld.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://receiveshift.creceivewoshift.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'availabilities'};
    }
    public class ReceiveShiftPort {
        //public String endpoint_x = 'https://natitest01.ifscloud.net:59101/webservices/ReceiveShift';
        public String endpoint_x ='https://natitest01.ifscloud.net:60443/webservices/ReceiveShift';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://types.creceivewoshift.webservices.ifsworld.com/', 'NGS_S1_TypesResourceAvailabiltiy_IFS_WS', 'http://receiveshift.creceivewoshift.webservices.ifsworld.com/', 'NGS_S1_ResourceAvailabiltiy_IFS_WS'};
        public NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shifts receiveShiftInfo(NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shifts ngsHrSp1In) {
            NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfo request_x = new NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfo();
            request_x.ngsHrSp1In = ngsHrSp1In;
            NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse response_x;
            Map<String, NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse> response_map_x = new Map<String, NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://receiveshift.creceivewoshift.webservices.ifsworld.com/',
              'receiveShiftInfo',
              'http://receiveshift.creceivewoshift.webservices.ifsworld.com/',
              'receiveShiftInfoResponse',
              'NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
    }
}