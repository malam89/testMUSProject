/**
    Description : This is a type of wrapper class. Used in EON_VOICE_Incoming_WS
**/
/*
    Created By : Praveen G
    Created Date : 29-April-2016
    Service Request : Not sure for now.
*/
    
public class EON_VOICE_app {
    public class AppointmentClass {
        public String AppointmentCancelReason;
        public String AppointmentContactNumber;
        public String AppointmentCustomerCall2DaysBefore;
        public String AppointmentDate;
        public String AppointmentStatus;
        public String AppointmentTechnicianName;
        public String AppointmentTimeSlot;
        public String CustomerID;
        public String PremiseID;
        public EON_VOICE_app.ArrayOfVulnerability VulnerabilityList;
        public String VulnerableBrail;
        public String VulnerableCustomerAssistantName;
        public String VulnerableCustomerAssistantNumber;
        public String VulnerableCustomerRepresentativeName;
        public String VulnerableCustomerRepresentativeNumber;
        private String[] AppointmentCancelReason_type_info = new String[]{'AppointmentCancelReason','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] AppointmentContactNumber_type_info = new String[]{'AppointmentContactNumber','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] AppointmentCustomerCall2DaysBefore_type_info = new String[]{'AppointmentCustomerCall2DaysBefore','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] AppointmentDate_type_info = new String[]{'AppointmentDate','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] AppointmentStatus_type_info = new String[]{'AppointmentStatus','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] AppointmentTechnicianName_type_info = new String[]{'AppointmentTechnicianName','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] AppointmentTimeSlot_type_info = new String[]{'AppointmentTimeSlot','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] CustomerID_type_info = new String[]{'CustomerID','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] PremiseID_type_info = new String[]{'PremiseID','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] VulnerabilityList_type_info = new String[]{'VulnerabilityList','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','ArrayOfVulnerability','0','1','true'};
        private String[] VulnerableBrail_type_info = new String[]{'VulnerableBrail','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] VulnerableCustomerAssistantName_type_info = new String[]{'VulnerableCustomerAssistantName','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] VulnerableCustomerAssistantNumber_type_info = new String[]{'VulnerableCustomerAssistantNumber','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] VulnerableCustomerRepresentativeName_type_info = new String[]{'VulnerableCustomerRepresentativeName','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] VulnerableCustomerRepresentativeNumber_type_info = new String[]{'VulnerableCustomerRepresentativeNumber','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','true','false'};
        private String[] field_order_type_info = new String[]{'AppointmentCancelReason','AppointmentContactNumber','AppointmentCustomerCall2DaysBefore','AppointmentDate','AppointmentStatus','AppointmentTechnicianName','AppointmentTimeSlot','CustomerID','PremiseID','VulnerabilityList','VulnerableBrail','VulnerableCustomerAssistantName','VulnerableCustomerAssistantNumber','VulnerableCustomerRepresentativeName','VulnerableCustomerRepresentativeNumber'};
    }
    public class ArrayOfVulnerability {
        public EON_VOICE_app.Vulnerability[] Vulnerability;
        private String[] Vulnerability_type_info = new String[]{'Vulnerability','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','Vulnerability','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','true','false'};
        private String[] field_order_type_info = new String[]{'Vulnerability'};
    }
    public class Vulnerability {
        public String Vulnerablecode;
        public String Vulnerabledescription;
        private String[] Vulnerablecode_type_info = new String[]{'Vulnerablecode','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] Vulnerabledescription_type_info = new String[]{'Vulnerabledescription','http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/MUS_Appointment_Service','true','false'};
        private String[] field_order_type_info = new String[]{'Vulnerablecode','Vulnerabledescription'};
    }
}