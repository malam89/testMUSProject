/**
    Description : This class created from the wsdl file provided through IFS for S1 – Resource Availability to IFS
                  
    VF Page     : None
    Test Class  : NGS_S1_TypesResAvailabiltiy_IFS_WS_test 

**/
/*
    Created By  : Shruti Moghe
    Created On  : 23/03/2017
    Service Req : SR_OptiMUS_NG_027
    Change History :

*/
public class NGS_S1_TypesResourceAvailabiltiy_IFS_WS {
    public class shiftAvailability {
        public String employeeId;
        public DateTime shiftDate;
        public DateTime shiftStartTime;
        public DateTime shiftFinishTime;
        public String active;
        public String serviceProvider;
        private String[] employeeId_type_info = new String[]{'employeeId','http://types.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] shiftDate_type_info = new String[]{'shiftDate','http://types.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] shiftStartTime_type_info = new String[]{'shiftStartTime','http://types.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] shiftFinishTime_type_info = new String[]{'shiftFinishTime','http://types.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] active_type_info = new String[]{'active','http://types.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] serviceProvider_type_info = new String[]{'serviceProvider','http://types.creceivewoshift.webservices.ifsworld.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://types.creceivewoshift.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'employeeId','shiftDate','shiftStartTime','shiftFinishTime','active','serviceProvider'};
    }
    public class shifts {
        public NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shiftAvailability[] availabilities;
        private String[] availabilities_type_info = new String[]{'availabilities','http://types.creceivewoshift.webservices.ifsworld.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://types.creceivewoshift.webservices.ifsworld.com/','false','false'};
        private String[] field_order_type_info = new String[]{'availabilities'};
    }
}