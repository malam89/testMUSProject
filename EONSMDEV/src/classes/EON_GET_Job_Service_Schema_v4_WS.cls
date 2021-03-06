//Generated by wsdl2apex

public class EON_GET_Job_Service_Schema_v4_WS {
    public class ResponseBaseDto {
        public EON_GET_Job_Service_Schema_v4_WS.MessageReportDto MessageReport;
        private String[] MessageReport_type_info = new String[]{'MessageReport','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'MessageReport'};
    }
    public class JobTypesRequestDto {
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class ServiceStatusRequestDto {
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class JobTypesResponseDto {
        public Integer JobCount;
        public EON_GET_Job_Service_Schema_v4_WS.ArrayOfJobTypeDto JobTypes;
        private String[] JobCount_type_info = new String[]{'JobCount','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','false'};
        private String[] JobTypes_type_info = new String[]{'JobTypes','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'JobCount','JobTypes'};
    }
    public class ServiceStatusResponseDto {
        public Long AcknowledgementId;
        public DateTime AuditDate;
        public String ErrorMessage;
        public String OrgId;
        public Integer Status;
        private String[] AcknowledgementId_type_info = new String[]{'AcknowledgementId','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','false'};
        private String[] AuditDate_type_info = new String[]{'AuditDate','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','false'};
        private String[] ErrorMessage_type_info = new String[]{'ErrorMessage','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] OrgId_type_info = new String[]{'OrgId','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] Status_type_info = new String[]{'Status','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'AcknowledgementId','AuditDate','ErrorMessage','OrgId','Status'};
    }
    public class RequestBaseDto {
        public String OrgId;
        public DateTime RequestDateTime;
        public String RequestId;
        private String[] OrgId_type_info = new String[]{'OrgId','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] RequestDateTime_type_info = new String[]{'RequestDateTime','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','false'};
        private String[] RequestId_type_info = new String[]{'RequestId','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'OrgId','RequestDateTime','RequestId'};
    }
    public class JobTypeDto {
        public EON_GET_Job_Service_Schema_v4_WS.ArrayOfJobTypeAttributeDto Attributes;
        public String JobCode;
        public String JobDesc;
        private String[] Attributes_type_info = new String[]{'Attributes','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] JobCode_type_info = new String[]{'JobCode','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] JobDesc_type_info = new String[]{'JobDesc','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'Attributes','JobCode','JobDesc'};
    }
    public class ArrayOfJobTypeAttributeDto {
        public EON_GET_Job_Service_Schema_v4_WS.JobTypeAttributeDto[] JobTypeAttributeDto;
        private String[] JobTypeAttributeDto_type_info = new String[]{'JobTypeAttributeDto','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'JobTypeAttributeDto'};
    }
    public class MessageDto {
        public Integer MessageId;
        public String MessageText;
        public String MessageType;
        private String[] MessageId_type_info = new String[]{'MessageId','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','false'};
        private String[] MessageText_type_info = new String[]{'MessageText','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] MessageType_type_info = new String[]{'MessageType','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'MessageId','MessageText','MessageType'};
    }
    public class ArrayOfJobTypeDto {
        public EON_GET_Job_Service_Schema_v4_WS.JobTypeDto[] JobTypeDto;
        private String[] JobTypeDto_type_info = new String[]{'JobTypeDto','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'JobTypeDto'};
    }
    public class ArrayOfMessageDto {
        public EON_GET_Job_Service_Schema_v4_WS.MessageDto[] MessageDto;
        private String[] MessageDto_type_info = new String[]{'MessageDto','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'MessageDto'};
    }
    public class MessageReportDto {
        public EON_GET_Job_Service_Schema_v4_WS.ArrayOfMessageDto Messages;
        private String[] Messages_type_info = new String[]{'Messages','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'Messages'};
    }
    public class JobTypeAttributeDto {
        public String Name;
        public String Value;
        private String[] Name_type_info = new String[]{'Name','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] Value_type_info = new String[]{'Value','http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/EonUK.Retail.ExternalService.AppointmentManagement.Inbound.Interface.DataTransferObjects','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Value'};
    }
}