/**
    Description : This class created from the wsdl file provided through IFS for S3 - Work Order Assignment
    Test Class  : NGS_S3_Send_WO_Assignment_to_IFS_test
**/
/*
    Created By  : Shruti Moghe
    Created On  : 29/03/2017
    Service Req : SR_OptiMUS_NG_013
    Change History :
*/
public class NGS_S3_WO_Assignment_to_IFS_WS {
    public class WebServiceException extends exception {
        public String message;
        public String type_x;
        public String extraInfo;
        public String causedClass;
        public String causedStackTrace;
        private String[] message_type_info = new String[]{'message','http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] extraInfo_type_info = new String[]{'extraInfo','http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] causedClass_type_info = new String[]{'causedClass','http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] causedStackTrace_type_info = new String[]{'causedStackTrace','http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'message','type_x','extraInfo','causedClass','causedStackTrace'};
    }
    public class receiveWoAssignmentDataResponse {
        public NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse return_x;
        private String[] return_x_type_info = new String[]{'return','http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class receiveWoAssignmentData {
        public NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignment workOrderAssignment;
        private String[] workOrderAssignment_type_info = new String[]{'workOrderAssignment','http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'workOrderAssignment'};
    }
    public class workOrderAssignmentResponse {
        public Long workOrderNumber;
        public String action;
        public DateTime startDate;
        public DateTime messageDate;
        public Double executionTime;
        public String employeeId;
        public String employeeName;
        public String notes;
        public String serviceProvider;
        private String[] workOrderNumber_type_info = new String[]{'workOrderNumber','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] action_type_info = new String[]{'action','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] messageDate_type_info = new String[]{'messageDate','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] executionTime_type_info = new String[]{'executionTime','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] employeeId_type_info = new String[]{'employeeId','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] employeeName_type_info = new String[]{'employeeName','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] notes_type_info = new String[]{'notes','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] serviceProvider_type_info = new String[]{'serviceProvider','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'workOrderNumber','action','startDate','messageDate','executionTime','employeeId','employeeName','notes','serviceProvider'};
    }
    public class workOrderAssignment {
        public Double workOrderNumber;
        public String acceptance;
        public DateTime startDate;
        public DateTime messageDate;
        public Double executionTime;
        public String employeeId;
        public String employeeName;
        public String notes;
        public String serviceProvider;
        private String[] workOrderNumber_type_info = new String[]{'workOrderNumber','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] acceptance_type_info = new String[]{'acceptance','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] startDate_type_info = new String[]{'startDate','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] messageDate_type_info = new String[]{'messageDate','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] executionTime_type_info = new String[]{'executionTime','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] employeeId_type_info = new String[]{'employeeId','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] employeeName_type_info = new String[]{'employeeName','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] notes_type_info = new String[]{'notes','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] serviceProvider_type_info = new String[]{'serviceProvider','http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'workOrderNumber','acceptance','startDate','messageDate','executionTime','employeeId','employeeName','notes','serviceProvider'};
    }
    public class WorkOrderAssignmentServiceHandlerPort {
        public String endpoint_x =System.Label.NGS_S3_Endpoint;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x = 120000;
        private String[] ns_map_type_info = new String[]{'http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/', 'NGS_S3_WO_Assignment_to_IFS_WS', 'http://types.creceiveworkorderassignmentdata.webservices.ifsworld.com/', 'NGS_S3_WO_Assignment_to_IFS_WS'};
        public NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse receiveWoAssignmentData(NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignment workOrderAssignment) {
            NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentData request_x = new NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentData();
            request_x.workOrderAssignment = workOrderAssignment;
            NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse response_x;
            Map<String, NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse> response_map_x = new Map<String, NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/',
              'receiveWoAssignmentData',
              'http://workorderassignmentservicehandler.creceiveworkorderassignmentdata.webservices.ifsworld.com/',
              'receiveWoAssignmentDataResponse',
              'NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
    }
}