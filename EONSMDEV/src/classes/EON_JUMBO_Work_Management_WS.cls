/**
    Description : This class created from the wsdl file provided through Wheatley-JUMBO. This class contain all the methods for JUMBO Interfaces
                  
    VF Page     : None
    Test Class  : EON_JUMBO_Work_Management_WS_Test

**/
/*
    Created By  : Mehboob Alam
    Created On  : 31/03/2016
    Service Req : SR_EON_Jumbo_003,SR_EON_Jumbo_013,
    Change History :
    CH01 # SR_EON_Jumbo_086 # 17/01/2017 # Aruna Manjari # Added the new WSDL variable SafetyProblem in class CloseElecWork

*/
    
public class EON_JUMBO_Work_Management_WS {
    public class ArrayOfCareDetail {
        public EON_JUMBO_Work_Management_WS.CareDetail[] CareDetail;
        private String[] CareDetail_type_info = new String[]{'CareDetail','Wheatley.WorkManagement','CareDetail','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CareDetail'};
    }
    public class ArrayOfCloseElecMeter {
        public EON_JUMBO_Work_Management_WS.CloseElecMeter[] CloseElecMeter;
        private String[] CloseElecMeter_type_info = new String[]{'CloseElecMeter','Wheatley.WorkManagement','CloseElecMeter','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CloseElecMeter'};
    }
    public class ArrayOfCloseElecOutstation {
        public EON_JUMBO_Work_Management_WS.CloseElecOutstation[] CloseElecOutstation;
        private String[] CloseElecOutstation_type_info = new String[]{'CloseElecOutstation','Wheatley.WorkManagement','CloseElecOutstation','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CloseElecOutstation'};
    }
    public class ArrayOfCloseElecRegister {
        public EON_JUMBO_Work_Management_WS.CloseElecRegister[] CloseElecRegister;
        private String[] CloseElecRegister_type_info = new String[]{'CloseElecRegister','Wheatley.WorkManagement','CloseElecRegister','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CloseElecRegister'};
    }
    public class ArrayOfCloseGasMeter {
        public EON_JUMBO_Work_Management_WS.CloseGasMeter[] CloseGasMeter;
        private String[] CloseGasMeter_type_info = new String[]{'CloseGasMeter','Wheatley.WorkManagement','CloseGasMeter','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CloseGasMeter'};
    }
    public class ArrayOfCloseGasRegister {
        public EON_JUMBO_Work_Management_WS.CloseGasRegister[] CloseGasRegister;
        private String[] CloseGasRegister_type_info = new String[]{'CloseGasRegister','Wheatley.WorkManagement','CloseGasRegister','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CloseGasRegister'};
    }
    public class ArrayOfComms {
        public EON_JUMBO_Work_Management_WS.Comms[] Comms;
        private String[] Comms_type_info = new String[]{'Comms','Wheatley.WorkManagement','Comms','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Comms'};
    }
    public class ArrayOfCommsBase {
        public EON_JUMBO_Work_Management_WS.CommsBase[] CommsBase;
        private String[] CommsBase_type_info = new String[]{'CommsBase','Wheatley.WorkManagement','CommsBase','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CommsBase'};
    }
    public class ArrayOfContact {
        public EON_JUMBO_Work_Management_WS.Contact[] Contact;
        private String[] Contact_type_info = new String[]{'Contact','Wheatley.WorkManagement','Contact','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Contact'};
    }
    public class ArrayOfContactMechanism {
        public EON_JUMBO_Work_Management_WS.ContactMechanism[] ContactMechanism;
        private String[] ContactMechanism_type_info = new String[]{'ContactMechanism','Wheatley.WorkManagement','ContactMechanism','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'ContactMechanism'};
    }
    public class ArrayOfConverter {
        public EON_JUMBO_Work_Management_WS.Converter[] Converter;
        private String[] Converter_type_info = new String[]{'Converter','Wheatley.WorkManagement','Converter','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Converter'};
    }
    public class ArrayOfElecAppointedParty {
        public EON_JUMBO_Work_Management_WS.ElecAppointedParty[] ElecAppointedParty;
        private String[] ElecAppointedParty_type_info = new String[]{'ElecAppointedParty','Wheatley.WorkManagement','ElecAppointedParty','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'ElecAppointedParty'};
    }
    public class ArrayOfElecMeter {
        public EON_JUMBO_Work_Management_WS.ElecMeter[] ElecMeter;
        private String[] ElecMeter_type_info = new String[]{'ElecMeter','Wheatley.WorkManagement','ElecMeter','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'ElecMeter'};
    }
    public class ArrayOfElecRegister {
        public EON_JUMBO_Work_Management_WS.ElecRegister[] ElecRegister;
        private String[] ElecRegister_type_info = new String[]{'ElecRegister','Wheatley.WorkManagement','ElecRegister','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'ElecRegister'};
    }
    public class ArrayOfGasAppointedParty {
        public EON_JUMBO_Work_Management_WS.GasAppointedParty[] GasAppointedParty;
        private String[] GasAppointedParty_type_info = new String[]{'GasAppointedParty','Wheatley.WorkManagement','GasAppointedParty','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'GasAppointedParty'};
    }
    public class ArrayOfGasMeter {
        public EON_JUMBO_Work_Management_WS.GasMeter[] GasMeter;
        private String[] GasMeter_type_info = new String[]{'GasMeter','Wheatley.WorkManagement','GasMeter','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'GasMeter'};
    }
    public class ArrayOfGasRegister {
        public EON_JUMBO_Work_Management_WS.GasRegister[] GasRegister;
        private String[] GasRegister_type_info = new String[]{'GasRegister','Wheatley.WorkManagement','GasRegister','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'GasRegister'};
    }
    public class ArrayOfMeterMemoryLocationType {
        public EON_JUMBO_Work_Management_WS.MeterMemoryLocationType[] MeterMemoryLocationType;
        private String[] MeterMemoryLocationType_type_info = new String[]{'MeterMemoryLocationType','Wheatley.WorkManagement','MeterMemoryLocationType','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'MeterMemoryLocationType'};
    }
    public class ArrayOfOutstation {
        public EON_JUMBO_Work_Management_WS.Outstation[] Outstation;
        private String[] Outstation_type_info = new String[]{'Outstation','Wheatley.WorkManagement','Outstation','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Outstation'};
    }
    public class ArrayOfSpecialNeed {
        public EON_JUMBO_Work_Management_WS.SpecialNeed[] SpecialNeed;
        private String[] SpecialNeed_type_info = new String[]{'SpecialNeed','Wheatley.WorkManagement','SpecialNeed','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'SpecialNeed'};
    }
    public class ArrayOfTimePatternRegime {
        public EON_JUMBO_Work_Management_WS.TimePatternRegime[] TimePatternRegime;
        private String[] TimePatternRegime_type_info = new String[]{'TimePatternRegime','Wheatley.WorkManagement','TimePatternRegime','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'TimePatternRegime'};
    }
    public class BasicHttpBinding_IWorkManagement {
        public String endpoint_x = system.label.EON_Jumbo_EndPointURL;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x=system.label.EON_Jumbo_ClientCertName;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x = 120000;
        private String[] ns_map_type_info = new String[]{'Wheatley.WorkManagement','EON_JUMBO_Work_Management_WS','http://schemas.microsoft.com/2003/10/Serialization/','schemasMicrosoftCom200310Serializat'};

        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CancelJumboElectricityJob(EON_JUMBO_Work_Management_WS.CancelElecWorkRequest request) {
            EON_JUMBO_Work_Management_WS.CancelJumboElectricityJob_element request_x = new EON_JUMBO_Work_Management_WS.CancelJumboElectricityJob_element();
            EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/CancelJumboElectricityJob',
                'Wheatley.WorkManagement',
                'CancelJumboElectricityJob',
                'Wheatley.WorkManagement',
                'CancelJumboElectricityJobResponse',
                'EON_JUMBO_Work_Management_WS.CancelJumboElectricityJobResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CancelJumboElectricityJobResult;
        }

        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CancelJumboGasJob(EON_JUMBO_Work_Management_WS.CancelGasWorkRequest request) {
            EON_JUMBO_Work_Management_WS.CancelJumboGasJob_element request_x = new EON_JUMBO_Work_Management_WS.CancelJumboGasJob_element();
            EON_JUMBO_Work_Management_WS.CancelJumboGasJobResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.CancelJumboGasJobResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.CancelJumboGasJobResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/CancelJumboGasJob',
                'Wheatley.WorkManagement',
                'CancelJumboGasJob',
                'Wheatley.WorkManagement',
                'CancelJumboGasJobResponse',
                'EON_JUMBO_Work_Management_WS.CancelJumboGasJobResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CancelJumboGasJobResult;
        }

        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CloseJumboElectricityJob(EON_JUMBO_Work_Management_WS.CloseElecWorkRequest request) {
            EON_JUMBO_Work_Management_WS.CloseJumboElectricityJob_element request_x = new EON_JUMBO_Work_Management_WS.CloseJumboElectricityJob_element();
            EON_JUMBO_Work_Management_WS.CloseJumboElectricityJobResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.CloseJumboElectricityJobResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.CloseJumboElectricityJobResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/CloseJumboElectricityJob',
                'Wheatley.WorkManagement',
                'CloseJumboElectricityJob',
                'Wheatley.WorkManagement',
                'CloseJumboElectricityJobResponse',
                'EON_JUMBO_Work_Management_WS.CloseJumboElectricityJobResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CloseJumboElectricityJobResult;
        }

        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CloseJumboGasJob(EON_JUMBO_Work_Management_WS.CloseGasWorkRequest request) {
            EON_JUMBO_Work_Management_WS.CloseJumboGasJob_element request_x = new EON_JUMBO_Work_Management_WS.CloseJumboGasJob_element();
            EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/CloseJumboGasJob',
                'Wheatley.WorkManagement',
                'CloseJumboGasJob',
                'Wheatley.WorkManagement',
                'CloseJumboGasJobResponse',
                'EON_JUMBO_Work_Management_WS.CloseJumboGasJobResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CloseJumboGasJobResult;
        }

        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CreateJumboElectricityJob(EON_JUMBO_Work_Management_WS.CreateElecWorkRequest request) {
            EON_JUMBO_Work_Management_WS.CreateJumboElectricityJob_element request_x = new EON_JUMBO_Work_Management_WS.CreateJumboElectricityJob_element();
            EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/CreateJumboElectricityJob',
                'Wheatley.WorkManagement',
                'CreateJumboElectricityJob',
                'Wheatley.WorkManagement',
                'CreateJumboElectricityJobResponse',
                'EON_JUMBO_Work_Management_WS.CreateJumboElectricityJobResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CreateJumboElectricityJobResult;
        }

        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CreateJumboGasJob(EON_JUMBO_Work_Management_WS.CreateGasWorkRequest request) {
            EON_JUMBO_Work_Management_WS.CreateJumboGasJob_element request_x = new EON_JUMBO_Work_Management_WS.CreateJumboGasJob_element();
            EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/CreateJumboGasJob',
                'Wheatley.WorkManagement',
                'CreateJumboGasJob',
                'Wheatley.WorkManagement',
                'CreateJumboGasJobResponse',
                'EON_JUMBO_Work_Management_WS.CreateJumboGasJobResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.CreateJumboGasJobResult;
        }

        public EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse RequestElectricityMeterPointData(EON_JUMBO_Work_Management_WS.ElecMeterPointDataRequest request) {
            EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element request_x = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element();
            EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/RequestElectricityMeterPointData',
                'Wheatley.WorkManagement',
                'RequestElectricityMeterPointData',
                'Wheatley.WorkManagement',
                'RequestElectricityMeterPointDataResponse',
                'EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestElectricityMeterPointDataResult;
        }

        public EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse RequestElectricitySupplierAppointments(EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest request) {
            EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element request_x = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element();
            EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/RequestElectricitySupplierAppointments',
                'Wheatley.WorkManagement',
                'RequestElectricitySupplierAppointments',
                'Wheatley.WorkManagement',
                'RequestElectricitySupplierAppointmentsResponse',
                'EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestElectricitySupplierAppointmentsResult;
        }

        public EON_JUMBO_Work_Management_WS.GasMeterPointDataResponse RequestGasMeterPointData(EON_JUMBO_Work_Management_WS.GasMeterPointDataRequest request) {
            EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element request_x = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element();
            EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/RequestGasMeterPointData',
                'Wheatley.WorkManagement',
                'RequestGasMeterPointData',
                'Wheatley.WorkManagement',
                'RequestGasMeterPointDataResponse',
                'EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestGasMeterPointDataResult;
        }

        public EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse RequestGasSupplierAppointments(EON_JUMBO_Work_Management_WS.GasSupplierDetailsRequest request) {
            EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element request_x = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element();
            EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element response_x;
            request_x.request = request;
            Map<String, EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element> response_map_x = new Map<String, EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'Wheatley.WorkManagement/IWorkManagement/RequestGasSupplierAppointments',
                'Wheatley.WorkManagement',
                'RequestGasSupplierAppointments',
                'Wheatley.WorkManagement',
                'RequestGasSupplierAppointmentsResponse',
                'EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.RequestGasSupplierAppointmentsResult;
        }
    }
    public class CancelElecWork {
        public String ExternalJobReference;
        public String JumboId;
        public String MPAN;
        public String Reason;
        private String[] ExternalJobReference_type_info = new String[]{'ExternalJobReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] JumboId_type_info = new String[]{'JumboId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MPAN_type_info = new String[]{'MPAN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Reason_type_info = new String[]{'Reason','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'ExternalJobReference','JumboId','MPAN','Reason'};
    }
    public class CancelElecWorkRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public EON_JUMBO_Work_Management_WS.CancelElecWork CancelElecWork;
        private String[] CancelElecWork_type_info = new String[]{'CancelElecWork','Wheatley.WorkManagement','CancelElecWork','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','CancelElecWork'};
    }
    public class CancelGasWork {
        public String ExternalJobReference;
        public String JumboId;
        public String MPRN;
        public String TransactionStatusChangeReason;
        private String[] ExternalJobReference_type_info = new String[]{'ExternalJobReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] JumboId_type_info = new String[]{'JumboId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MPRN_type_info = new String[]{'MPRN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TransactionStatusChangeReason_type_info = new String[]{'TransactionStatusChangeReason','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'ExternalJobReference','JumboId','MPRN','TransactionStatusChangeReason'};
    }
    public class CancelGasWorkRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public EON_JUMBO_Work_Management_WS.CancelGasWork CancelGasWork;
        private String[] CancelGasWork_type_info = new String[]{'CancelGasWork','Wheatley.WorkManagement','CancelGasWork','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','CancelGasWork'};
    }
    public class CancelJumboElectricityJob_element {
        public EON_JUMBO_Work_Management_WS.CancelElecWorkRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','CancelElecWorkRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class CancelJumboElectricityJobResponse_element {
        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CancelJumboElectricityJobResult;
        private String[] CancelJumboElectricityJobResult_type_info = new String[]{'CancelJumboElectricityJobResult','Wheatley.WorkManagement','JumboTechnicalResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CancelJumboElectricityJobResult'};
    }
    public class CancelJumboGasJob_element {
        public EON_JUMBO_Work_Management_WS.CancelGasWorkRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','CancelGasWorkRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class CancelJumboGasJobResponse_element {
        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CancelJumboGasJobResult;
        private String[] CancelJumboGasJobResult_type_info = new String[]{'CancelJumboGasJobResult','Wheatley.WorkManagement','JumboTechnicalResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CancelJumboGasJobResult'};
    }
    public class CareDetail {
        public String Category;
        private String[] Category_type_info = new String[]{'Category','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Category'};
    }
    public class ClientData {
        public String Id;
        public String Name;
        private String[] Id_type_info = new String[]{'Id','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Name_type_info = new String[]{'Name','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Id','Name'};
    }
    public class CloseElecMeter {
        public String CTRatio;
        public String CertificationDate;
        public String CertificationExpiryDate;
        public EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice CodeOfPractice;
        public String CurrentRating;
        public String Location;
        public String MainOrCheck;
        public String ManufacturerAndModel;
        public String RetrievalMethod;
        public String RetrievalMethodEffectiveDate;
        public String SerialNumber;
        public String TimingDeviceSerialNumber;
        public String Type_x;
        public String VTRatio;
        private String[] CTRatio_type_info = new String[]{'CTRatio','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CertificationDate_type_info = new String[]{'CertificationDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CertificationExpiryDate_type_info = new String[]{'CertificationExpiryDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CodeOfPractice_type_info = new String[]{'CodeOfPractice','Wheatley.WorkManagement','ElecMeterCodeOfPractice','0','1','true'};
        private String[] CurrentRating_type_info = new String[]{'CurrentRating','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Location_type_info = new String[]{'Location','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MainOrCheck_type_info = new String[]{'MainOrCheck','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ManufacturerAndModel_type_info = new String[]{'ManufacturerAndModel','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RetrievalMethod_type_info = new String[]{'RetrievalMethod','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RetrievalMethodEffectiveDate_type_info = new String[]{'RetrievalMethodEffectiveDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TimingDeviceSerialNumber_type_info = new String[]{'TimingDeviceSerialNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] VTRatio_type_info = new String[]{'VTRatio','Wheatley.WorkManagement','string','0','1','true'};
        public String CreditBalance;
        public String CurrentBalance;
        public String DebtRecoveryRate;
        public String EmergencyCredit;
        public String EmergencyCreditOverride;
        public String EmergencyCreditStatus;
        public String InitialCredit;
        public EON_JUMBO_Work_Management_WS.ArrayOfCloseElecRegister Registers;
        public String Removed;
        public String StandingCharge;
        public String StandingChargeOverride;
        public String TotalCreditAccepted;
        public String TotalDebt;
        public String TotalDebtOutstanding;
        public String TotalTokensInserted;
        private String[] CreditBalance_type_info = new String[]{'CreditBalance','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CurrentBalance_type_info = new String[]{'CurrentBalance','Wheatley.WorkManagement','string','0','1','true'};
        private String[] DebtRecoveryRate_type_info = new String[]{'DebtRecoveryRate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EmergencyCredit_type_info = new String[]{'EmergencyCredit','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EmergencyCreditOverride_type_info = new String[]{'EmergencyCreditOverride','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EmergencyCreditStatus_type_info = new String[]{'EmergencyCreditStatus','Wheatley.WorkManagement','string','0','1','true'};
        private String[] InitialCredit_type_info = new String[]{'InitialCredit','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Registers_type_info = new String[]{'Registers','Wheatley.WorkManagement','ArrayOfCloseElecRegister','0','1','true'};
        private String[] Removed_type_info = new String[]{'Removed','Wheatley.WorkManagement','string','0','1','true'};
        private String[] StandingCharge_type_info = new String[]{'StandingCharge','Wheatley.WorkManagement','string','0','1','true'};
        private String[] StandingChargeOverride_type_info = new String[]{'StandingChargeOverride','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TotalCreditAccepted_type_info = new String[]{'TotalCreditAccepted','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TotalDebt_type_info = new String[]{'TotalDebt','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TotalDebtOutstanding_type_info = new String[]{'TotalDebtOutstanding','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TotalTokensInserted_type_info = new String[]{'TotalTokensInserted','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CTRatio','CertificationDate','CertificationExpiryDate','CodeOfPractice','CurrentRating','Location','MainOrCheck','ManufacturerAndModel','RetrievalMethod','RetrievalMethodEffectiveDate','SerialNumber','TimingDeviceSerialNumber','Type_x','VTRatio','CreditBalance','CurrentBalance','DebtRecoveryRate','EmergencyCredit','EmergencyCreditOverride','EmergencyCreditStatus','InitialCredit','Registers','Removed','StandingCharge','StandingChargeOverride','TotalCreditAccepted','TotalDebt','TotalDebtOutstanding','TotalTokensInserted'};
    }
    public class CloseElecOutstation {
        public EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice CodeOfPractice;
        public String EncryptionKey;
        public String Id;
        public String Multiplier;
        public String NumberOfChannels;
        public String NumberOfDigits;
        public EON_JUMBO_Work_Management_WS.OutstationPasswords Passwords;
        public String Pin;
        public String Type_x;
        public EON_JUMBO_Work_Management_WS.OutstationUsernames Usernames;
        private String[] CodeOfPractice_type_info = new String[]{'CodeOfPractice','Wheatley.WorkManagement','OutstationCodeOfPractice','0','1','true'};
        private String[] EncryptionKey_type_info = new String[]{'EncryptionKey','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Id_type_info = new String[]{'Id','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Multiplier_type_info = new String[]{'Multiplier','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfChannels_type_info = new String[]{'NumberOfChannels','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfDigits_type_info = new String[]{'NumberOfDigits','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Passwords_type_info = new String[]{'Passwords','Wheatley.WorkManagement','OutstationPasswords','0','1','true'};
        private String[] Pin_type_info = new String[]{'Pin','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Usernames_type_info = new String[]{'Usernames','Wheatley.WorkManagement','OutstationUsernames','0','1','true'};
        public EON_JUMBO_Work_Management_WS.ArrayOfComms Comms;
        public String Removed;
        private String[] Comms_type_info = new String[]{'Comms','Wheatley.WorkManagement','ArrayOfComms','0','1','true'};
        private String[] Removed_type_info = new String[]{'Removed','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CodeOfPractice','EncryptionKey','Id','Multiplier','NumberOfChannels','NumberOfDigits','Passwords','Pin','Type_x','Usernames','Comms','Removed'};
    }
    public class CloseElecRegister {
        public String AssociatedMeterId;
        public String AssociatedRegisterId;
        public String ChannelNumber;
        public String Description;
        public String Id;
        public String MeasurementQuantityId;
        public String MeterMemoryLocation;
        public EON_JUMBO_Work_Management_WS.ArrayOfMeterMemoryLocationType MeterMemoryLocationTypes;
        public String Multiplier;
        public String NumberOfDigits;
        public String PulseMultiplier;
        public String TimestampMeterMemoryLocation;
        public String Type_x;
        private String[] AssociatedMeterId_type_info = new String[]{'AssociatedMeterId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AssociatedRegisterId_type_info = new String[]{'AssociatedRegisterId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ChannelNumber_type_info = new String[]{'ChannelNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Description_type_info = new String[]{'Description','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Id_type_info = new String[]{'Id','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeasurementQuantityId_type_info = new String[]{'MeasurementQuantityId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterMemoryLocation_type_info = new String[]{'MeterMemoryLocation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterMemoryLocationTypes_type_info = new String[]{'MeterMemoryLocationTypes','Wheatley.WorkManagement','ArrayOfMeterMemoryLocationType','0','1','true'};
        private String[] Multiplier_type_info = new String[]{'Multiplier','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfDigits_type_info = new String[]{'NumberOfDigits','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PulseMultiplier_type_info = new String[]{'PulseMultiplier','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TimestampMeterMemoryLocation_type_info = new String[]{'TimestampMeterMemoryLocation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        public String PrepayUnitRate;
        public EON_JUMBO_Work_Management_WS.ElecRegisterReading Reading;
        public String Removed;
        public EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime TimePatternRegimes;
        private String[] PrepayUnitRate_type_info = new String[]{'PrepayUnitRate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Reading_type_info = new String[]{'Reading','Wheatley.WorkManagement','ElecRegisterReading','0','1','true'};
        private String[] Removed_type_info = new String[]{'Removed','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TimePatternRegimes_type_info = new String[]{'TimePatternRegimes','Wheatley.WorkManagement','ArrayOfTimePatternRegime','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AssociatedMeterId','AssociatedRegisterId','ChannelNumber','Description','Id','MeasurementQuantityId','MeterMemoryLocation','MeterMemoryLocationTypes','Multiplier','NumberOfDigits','PulseMultiplier','TimestampMeterMemoryLocation','Type_x','PrepayUnitRate','Reading','Removed','TimePatternRegimes'};
    }
    public class CloseElecWork {
        public String AdditionalInformation;
        public String AssetCondition;
        public String AssetConditionReportDate;
        public String DateFaultDetected;
        public String ExternalJobReference;
        public String JumboId;
        public String JumboJobType;
        public String MPAN;
        public String MSNSFC;
        public String MaxPowerRequirement;
        public String MeasurementClassId;
        public EON_JUMBO_Work_Management_WS.ArrayOfCloseElecMeter Meters;
        public EON_JUMBO_Work_Management_WS.ArrayOfCloseElecOutstation Outstations;
        public String ReasonNotResolved;
        public String RemoteDisableEnableCapability;
        public String SSC;
        public String SafetyProblem;
        public String ServiceLocation;
        public EON_JUMBO_Work_Management_WS.ElecSiteVisit SiteVisit;
        public String SmartMeterInstallation;
        public String SpecialAccess;
        public EON_JUMBO_Work_Management_WS.ElecSupply Supply;
        public String TariffCode;
        private String[] AdditionalInformation_type_info = new String[]{'AdditionalInformation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AssetCondition_type_info = new String[]{'AssetCondition','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AssetConditionReportDate_type_info = new String[]{'AssetConditionReportDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] DateFaultDetected_type_info = new String[]{'DateFaultDetected','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ExternalJobReference_type_info = new String[]{'ExternalJobReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] JumboId_type_info = new String[]{'JumboId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] JumboJobType_type_info = new String[]{'JumboJobType','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MPAN_type_info = new String[]{'MPAN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MSNSFC_type_info = new String[]{'MSNSFC','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MaxPowerRequirement_type_info = new String[]{'MaxPowerRequirement','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeasurementClassId_type_info = new String[]{'MeasurementClassId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Meters_type_info = new String[]{'Meters','Wheatley.WorkManagement','ArrayOfCloseElecMeter','0','1','true'};
        private String[] Outstations_type_info = new String[]{'Outstations','Wheatley.WorkManagement','ArrayOfCloseElecOutstation','0','1','true'};
        private String[] ReasonNotResolved_type_info = new String[]{'ReasonNotResolved','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RemoteDisableEnableCapability_type_info = new String[]{'RemoteDisableEnableCapability','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SSC_type_info = new String[]{'SSC','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SafetyProblem_type_info = new String[]{'SafetyProblem','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ServiceLocation_type_info = new String[]{'ServiceLocation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SiteVisit_type_info = new String[]{'SiteVisit','Wheatley.WorkManagement','ElecSiteVisit','0','1','true'};
        private String[] SmartMeterInstallation_type_info = new String[]{'SmartMeterInstallation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SpecialAccess_type_info = new String[]{'SpecialAccess','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Supply_type_info = new String[]{'Supply','Wheatley.WorkManagement','ElecSupply','0','1','true'};
        private String[] TariffCode_type_info = new String[]{'TariffCode','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AdditionalInformation','AssetCondition','AssetConditionReportDate','DateFaultDetected','ExternalJobReference','JumboId','JumboJobType','MPAN','MSNSFC','MaxPowerRequirement','MeasurementClassId','Meters','Outstations','ReasonNotResolved','RemoteDisableEnableCapability','SSC','SafetyProblem','ServiceLocation','SiteVisit','SmartMeterInstallation','SpecialAccess','Supply','TariffCode'};
    }
    public class CloseElecWorkRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public EON_JUMBO_Work_Management_WS.CloseElecWork CloseElecWork;
        private String[] CloseElecWork_type_info = new String[]{'CloseElecWork','Wheatley.WorkManagement','CloseElecWork','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','CloseElecWork'};
    }
    public class CloseGasMeter {
        public String CollarStatus;
        public String Location;
        public String LocationNotes;
        public String Manufacturer;
        public String MeasuringCapacity;
        public String Mechanism;
        public String Model;
        public String OwnerMarketParticipantId;
        public String PaymentMethod;
        public String PulseValue;
        public EON_JUMBO_Work_Management_WS.ArrayOfCloseGasRegister Registers;
        public String Removed;
        public String SerialNumber;
        public String Status;
        public String Type_x;
        public String Usage;
        public String YearOfManufacture;
        private String[] CollarStatus_type_info = new String[]{'CollarStatus','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Location_type_info = new String[]{'Location','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LocationNotes_type_info = new String[]{'LocationNotes','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Manufacturer_type_info = new String[]{'Manufacturer','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeasuringCapacity_type_info = new String[]{'MeasuringCapacity','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Mechanism_type_info = new String[]{'Mechanism','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Model_type_info = new String[]{'Model','Wheatley.WorkManagement','string','0','1','true'};
        private String[] OwnerMarketParticipantId_type_info = new String[]{'OwnerMarketParticipantId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PaymentMethod_type_info = new String[]{'PaymentMethod','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PulseValue_type_info = new String[]{'PulseValue','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Registers_type_info = new String[]{'Registers','Wheatley.WorkManagement','ArrayOfCloseGasRegister','0','1','true'};
        private String[] Removed_type_info = new String[]{'Removed','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Status_type_info = new String[]{'Status','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Usage_type_info = new String[]{'Usage','Wheatley.WorkManagement','string','0','1','true'};
        private String[] YearOfManufacture_type_info = new String[]{'YearOfManufacture','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CollarStatus','Location','LocationNotes','Manufacturer','MeasuringCapacity','Mechanism','Model','OwnerMarketParticipantId','PaymentMethod','PulseValue','Registers','Removed','SerialNumber','Status','Type_x','Usage','YearOfManufacture'};
    }
    public class CloseGasRegister {
        public String MultiplicationFactor;
        public String NumberOfDigits;
        public String Reading;
        public String Removed;
        public String UnitsOfMeasure;
        private String[] MultiplicationFactor_type_info = new String[]{'MultiplicationFactor','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfDigits_type_info = new String[]{'NumberOfDigits','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Reading_type_info = new String[]{'Reading','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Removed_type_info = new String[]{'Removed','Wheatley.WorkManagement','string','0','1','true'};
        private String[] UnitsOfMeasure_type_info = new String[]{'UnitsOfMeasure','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'MultiplicationFactor','NumberOfDigits','Reading','Removed','UnitsOfMeasure'};
    }
    public class CloseGasWork {
        public String ConversionFactor;
        public EON_JUMBO_Work_Management_WS.ArrayOfConverter Converters;
        public String ExternalJobReference;
        public String FieldWorkerNotes;
        public String JumboId;
        public String JumboJobType;
        public String Location;
        public String LocationNotes;
        public String MPRN;
        public String MeterLink;
        public String MeterPointStatus;
        public String MeteringPressure;
        public EON_JUMBO_Work_Management_WS.ArrayOfCloseGasMeter Meters;
        public EON_JUMBO_Work_Management_WS.SiteVisit SiteVisit;
        public String SupplierMarketParticipantId;
        public EON_JUMBO_Work_Management_WS.GasTransaction Transaction_x;
        private String[] ConversionFactor_type_info = new String[]{'ConversionFactor','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Converters_type_info = new String[]{'Converters','Wheatley.WorkManagement','ArrayOfConverter','0','1','true'};
        private String[] ExternalJobReference_type_info = new String[]{'ExternalJobReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] FieldWorkerNotes_type_info = new String[]{'FieldWorkerNotes','Wheatley.WorkManagement','string','0','1','true'};
        private String[] JumboId_type_info = new String[]{'JumboId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] JumboJobType_type_info = new String[]{'JumboJobType','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Location_type_info = new String[]{'Location','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LocationNotes_type_info = new String[]{'LocationNotes','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MPRN_type_info = new String[]{'MPRN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterLink_type_info = new String[]{'MeterLink','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterPointStatus_type_info = new String[]{'MeterPointStatus','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeteringPressure_type_info = new String[]{'MeteringPressure','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Meters_type_info = new String[]{'Meters','Wheatley.WorkManagement','ArrayOfCloseGasMeter','0','1','true'};
        private String[] SiteVisit_type_info = new String[]{'SiteVisit','Wheatley.WorkManagement','SiteVisit','0','1','true'};
        private String[] SupplierMarketParticipantId_type_info = new String[]{'SupplierMarketParticipantId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Transaction_x_type_info = new String[]{'Transaction','Wheatley.WorkManagement','GasTransaction','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'ConversionFactor','Converters','ExternalJobReference','FieldWorkerNotes','JumboId','JumboJobType','Location','LocationNotes','MPRN','MeterLink','MeterPointStatus','MeteringPressure','Meters','SiteVisit','SupplierMarketParticipantId','Transaction_x'};
    }
    public class CloseGasWorkRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public EON_JUMBO_Work_Management_WS.CloseGasWork CloseGasWork;
        private String[] CloseGasWork_type_info = new String[]{'CloseGasWork','Wheatley.WorkManagement','CloseGasWork','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','CloseGasWork'};
    }
    public class CloseJumboElectricityJob_element {
        public EON_JUMBO_Work_Management_WS.CloseElecWorkRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','CloseElecWorkRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class CloseJumboElectricityJobResponse_element {
        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CloseJumboElectricityJobResult;
        private String[] CloseJumboElectricityJobResult_type_info = new String[]{'CloseJumboElectricityJobResult','Wheatley.WorkManagement','JumboTechnicalResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CloseJumboElectricityJobResult'};
    }
    public class CloseJumboGasJob_element {
        public EON_JUMBO_Work_Management_WS.CloseGasWorkRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','CloseGasWorkRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class CloseJumboGasJobResponse_element {
        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CloseJumboGasJobResult;
        private String[] CloseJumboGasJobResult_type_info = new String[]{'CloseJumboGasJobResult','Wheatley.WorkManagement','JumboTechnicalResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CloseJumboGasJobResult'};
    }
    public class Comms {
        public String Address;
        public String BaudRate;
        public String DialInDialOutIndicator;
        public String Method;
        public String Provider;
        private String[] Address_type_info = new String[]{'Address','Wheatley.WorkManagement','string','0','1','true'};
        private String[] BaudRate_type_info = new String[]{'BaudRate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] DialInDialOutIndicator_type_info = new String[]{'DialInDialOutIndicator','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Method_type_info = new String[]{'Method','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Provider_type_info = new String[]{'Provider','Wheatley.WorkManagement','string','0','1','true'};
        public String Removed;
        private String[] Removed_type_info = new String[]{'Removed','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Address','BaudRate','DialInDialOutIndicator','Method','Provider','Removed'};
    }
    public class CommsBase {
        public String Address;
        public String BaudRate;
        public String DialInDialOutIndicator;
        public String Method;
        public String Provider;
        private String[] Address_type_info = new String[]{'Address','Wheatley.WorkManagement','string','0','1','true'};
        private String[] BaudRate_type_info = new String[]{'BaudRate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] DialInDialOutIndicator_type_info = new String[]{'DialInDialOutIndicator','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Method_type_info = new String[]{'Method','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Provider_type_info = new String[]{'Provider','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Address','BaudRate','DialInDialOutIndicator','Method','Provider'};
    }
    public class Contact {
        public EON_JUMBO_Work_Management_WS.ArrayOfCareDetail CareDetails;
        public EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism ContactMechanism;
        public String Initials;
        public String Notes;
        public String Surname;
        public String Title;
        public String TypeCode;
        private String[] CareDetails_type_info = new String[]{'CareDetails','Wheatley.WorkManagement','ArrayOfCareDetail','0','1','true'};
        private String[] ContactMechanism_type_info = new String[]{'ContactMechanism','Wheatley.WorkManagement','ArrayOfContactMechanism','0','1','true'};
        private String[] Initials_type_info = new String[]{'Initials','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Notes_type_info = new String[]{'Notes','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Surname_type_info = new String[]{'Surname','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Title_type_info = new String[]{'Title','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TypeCode_type_info = new String[]{'TypeCode','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CareDetails','ContactMechanism','Initials','Notes','Surname','Title','TypeCode'};
    }
    public class ContactMechanism {
        public String Code;
        public String Value;
        private String[] Code_type_info = new String[]{'Code','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Value_type_info = new String[]{'Value','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Code','Value'};
    }
    public class Converter {
        public String AssetClass;
        public String AssetProvAbbrevName;
        public String AssetStatus;
        public String ConversionBasis;
        public String ConversionFactor;
        public String Location;
        public String LocationNotes;
        public String Manufacturer;
        public String Model;
        public String PaymentMethod;
        public String ProductId;
        public String SerialNumber;
        public String YearofManufacture;
        private String[] AssetClass_type_info = new String[]{'AssetClass','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AssetProvAbbrevName_type_info = new String[]{'AssetProvAbbrevName','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AssetStatus_type_info = new String[]{'AssetStatus','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ConversionBasis_type_info = new String[]{'ConversionBasis','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ConversionFactor_type_info = new String[]{'ConversionFactor','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Location_type_info = new String[]{'Location','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LocationNotes_type_info = new String[]{'LocationNotes','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Manufacturer_type_info = new String[]{'Manufacturer','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Model_type_info = new String[]{'Model','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PaymentMethod_type_info = new String[]{'PaymentMethod','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ProductId_type_info = new String[]{'ProductId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] YearofManufacture_type_info = new String[]{'YearofManufacture','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AssetClass','AssetProvAbbrevName','AssetStatus','ConversionBasis','ConversionFactor','Location','LocationNotes','Manufacturer','Model','PaymentMethod','ProductId','SerialNumber','YearofManufacture'};
    }
    public class Coordinates {
        public String X;
        public String Y;
        public String Z;
        private String[] X_type_info = new String[]{'X','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Y_type_info = new String[]{'Y','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Z_type_info = new String[]{'Z','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'X','Y','Z'};
    }
    public class CreateElecWork {
        public String EarliestStartDate;
        public String EarliestStartTime;
        public String ExternalJobReference;
        public String JumboJobType;
        public String LatestStartDate;
        public String LatestStartTime;
        public String RequestDate;
        public String RequestTime;
        private String[] EarliestStartDate_type_info = new String[]{'EarliestStartDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EarliestStartTime_type_info = new String[]{'EarliestStartTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ExternalJobReference_type_info = new String[]{'ExternalJobReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] JumboJobType_type_info = new String[]{'JumboJobType','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LatestStartDate_type_info = new String[]{'LatestStartDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LatestStartTime_type_info = new String[]{'LatestStartTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RequestDate_type_info = new String[]{'RequestDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RequestTime_type_info = new String[]{'RequestTime','Wheatley.WorkManagement','string','0','1','true'};
        public String MPAN;
        private String[] MPAN_type_info = new String[]{'MPAN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'EarliestStartDate','EarliestStartTime','ExternalJobReference','JumboJobType','LatestStartDate','LatestStartTime','RequestDate','RequestTime','MPAN'};
    }
    public class CreateElecWorkRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public EON_JUMBO_Work_Management_WS.CreateElecWork CreateElecWork;
        private String[] CreateElecWork_type_info = new String[]{'CreateElecWork','Wheatley.WorkManagement','CreateElecWork','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','CreateElecWork'};
    }
    public class CreateGasWork {
        public String EarliestStartDate;
        public String EarliestStartTime;
        public String ExternalJobReference;
        public String JumboJobType;
        public String LatestStartDate;
        public String LatestStartTime;
        public String RequestDate;
        public String RequestTime;
        private String[] EarliestStartDate_type_info = new String[]{'EarliestStartDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EarliestStartTime_type_info = new String[]{'EarliestStartTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ExternalJobReference_type_info = new String[]{'ExternalJobReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] JumboJobType_type_info = new String[]{'JumboJobType','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LatestStartDate_type_info = new String[]{'LatestStartDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LatestStartTime_type_info = new String[]{'LatestStartTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RequestDate_type_info = new String[]{'RequestDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RequestTime_type_info = new String[]{'RequestTime','Wheatley.WorkManagement','string','0','1','true'};
        public String MPRN;
        private String[] MPRN_type_info = new String[]{'MPRN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'EarliestStartDate','EarliestStartTime','ExternalJobReference','JumboJobType','LatestStartDate','LatestStartTime','RequestDate','RequestTime','MPRN'};
    }
    public class CreateGasWorkRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public EON_JUMBO_Work_Management_WS.CreateGasWork CreateGasWork;
        private String[] CreateGasWork_type_info = new String[]{'CreateGasWork','Wheatley.WorkManagement','CreateGasWork','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','CreateGasWork'};
    }
    public class CreateJumboElectricityJob_element {
        public EON_JUMBO_Work_Management_WS.CreateElecWorkRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','CreateElecWorkRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class CreateJumboElectricityJobResponse_element {
        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CreateJumboElectricityJobResult;
        private String[] CreateJumboElectricityJobResult_type_info = new String[]{'CreateJumboElectricityJobResult','Wheatley.WorkManagement','JumboTechnicalResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CreateJumboElectricityJobResult'};
    }
    public class CreateJumboGasJob_element {
        public EON_JUMBO_Work_Management_WS.CreateGasWorkRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','CreateGasWorkRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class CreateJumboGasJobResponse_element {
        public EON_JUMBO_Work_Management_WS.JumboTechnicalResponse CreateJumboGasJobResult;
        private String[] CreateJumboGasJobResult_type_info = new String[]{'CreateJumboGasJobResult','Wheatley.WorkManagement','JumboTechnicalResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CreateJumboGasJobResult'};
    }
    public class CreateWorkBase {
        public String EarliestStartDate;
        public String EarliestStartTime;
        public String ExternalJobReference;
        public String JumboJobType;
        public String LatestStartDate;
        public String LatestStartTime;
        public String RequestDate;
        public String RequestTime;
        private String[] EarliestStartDate_type_info = new String[]{'EarliestStartDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EarliestStartTime_type_info = new String[]{'EarliestStartTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ExternalJobReference_type_info = new String[]{'ExternalJobReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] JumboJobType_type_info = new String[]{'JumboJobType','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LatestStartDate_type_info = new String[]{'LatestStartDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LatestStartTime_type_info = new String[]{'LatestStartTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RequestDate_type_info = new String[]{'RequestDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RequestTime_type_info = new String[]{'RequestTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'EarliestStartDate','EarliestStartTime','ExternalJobReference','JumboJobType','LatestStartDate','LatestStartTime','RequestDate','RequestTime'};
    }
    public class DataEffectiveFrom {
        public String EffectiveFromDate;
        public String Id;
        private String[] EffectiveFromDate_type_info = new String[]{'EffectiveFromDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Id_type_info = new String[]{'Id','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'EffectiveFromDate','Id'};
    }
    public class ElecAddress {
        public String Line1;
        public String Line2;
        public String Line3;
        public String Line4;
        public String Line5;
        public String Line6;
        public String Line7;
        public String Line8;
        public String Line9;
        public String Postcode;
        private String[] Line1_type_info = new String[]{'Line1','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Line2_type_info = new String[]{'Line2','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Line3_type_info = new String[]{'Line3','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Line4_type_info = new String[]{'Line4','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Line5_type_info = new String[]{'Line5','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Line6_type_info = new String[]{'Line6','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Line7_type_info = new String[]{'Line7','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Line8_type_info = new String[]{'Line8','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Line9_type_info = new String[]{'Line9','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Postcode_type_info = new String[]{'Postcode','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Line1','Line2','Line3','Line4','Line5','Line6','Line7','Line8','Line9','Postcode'};
    }
    public class ElecAppointedParty {
        public String EffectiveFromDate;
        public String EffectiveToDate;
        private String[] EffectiveFromDate_type_info = new String[]{'EffectiveFromDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EffectiveToDate_type_info = new String[]{'EffectiveToDate','Wheatley.WorkManagement','string','0','1','true'};
        public String MarketParticipantId;
        private String[] MarketParticipantId_type_info = new String[]{'MarketParticipantId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'EffectiveFromDate','EffectiveToDate','MarketParticipantId'};
    }
    public class ElecContact {
        public String Email;
        public String Fax;
        public String Name;
        public String PreferredContactMethod;
        public String Telephone;
        private String[] Email_type_info = new String[]{'Email','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Fax_type_info = new String[]{'Fax','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Name_type_info = new String[]{'Name','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PreferredContactMethod_type_info = new String[]{'PreferredContactMethod','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Telephone_type_info = new String[]{'Telephone','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Email','Fax','Name','PreferredContactMethod','Telephone'};
    }
    public class ElecCustomer {
        public String AdditionalInformation;
        public EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice CodeOfPractice;
        public String ContractReference;
        public EON_JUMBO_Work_Management_WS.ElecContact CustomerContact;
        public String CustomerName;
        public String CustomerPassword;
        public String CustomerPasswordEffectivefromDate;
        public EON_JUMBO_Work_Management_WS.ElecAppointedParty DataCollector;
        public String GridSupplyPointsGroupId;
        public String MPAN;
        public EON_JUMBO_Work_Management_WS.ElecAddress MailingAddress;
        public String MaximumPowerRequirement;
        public String MeasurementClassId;
        public EON_JUMBO_Work_Management_WS.ElecAppointedParty MeterOperator;
        public EON_JUMBO_Work_Management_WS.ElecAddress MeterPointAddress;
        public EON_JUMBO_Work_Management_WS.ArrayOfElecMeter Meters;
        public EON_JUMBO_Work_Management_WS.DataEffectiveFrom NonSettlementFunction;
        public EON_JUMBO_Work_Management_WS.ArrayOfOutstation Outstations;
        public EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo PriorityServiceContactInfo;
        public String RegistrationEffectiveFromDate;
        public String RemoteDisableEnableCapability;
        public String ServiceLevelReference;
        public String ServiceLocation;
        public String ServiceReference;
        public String SpecialAccess;
        public EON_JUMBO_Work_Management_WS.ArrayOfSpecialNeed SpecialNeeds;
        public EON_JUMBO_Work_Management_WS.DataEffectiveFrom StdSettlementConfig;
        public EON_JUMBO_Work_Management_WS.ElecSupply Supply;
        private String[] AdditionalInformation_type_info = new String[]{'AdditionalInformation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CodeOfPractice_type_info = new String[]{'CodeOfPractice','Wheatley.WorkManagement','ElecMeterCodeOfPractice','0','1','true'};
        private String[] ContractReference_type_info = new String[]{'ContractReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CustomerContact_type_info = new String[]{'CustomerContact','Wheatley.WorkManagement','ElecContact','0','1','true'};
        private String[] CustomerName_type_info = new String[]{'CustomerName','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CustomerPassword_type_info = new String[]{'CustomerPassword','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CustomerPasswordEffectivefromDate_type_info = new String[]{'CustomerPasswordEffectivefromDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] DataCollector_type_info = new String[]{'DataCollector','Wheatley.WorkManagement','ElecAppointedParty','0','1','true'};
        private String[] GridSupplyPointsGroupId_type_info = new String[]{'GridSupplyPointsGroupId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MPAN_type_info = new String[]{'MPAN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MailingAddress_type_info = new String[]{'MailingAddress','Wheatley.WorkManagement','ElecAddress','0','1','true'};
        private String[] MaximumPowerRequirement_type_info = new String[]{'MaximumPowerRequirement','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeasurementClassId_type_info = new String[]{'MeasurementClassId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterOperator_type_info = new String[]{'MeterOperator','Wheatley.WorkManagement','ElecAppointedParty','0','1','true'};
        private String[] MeterPointAddress_type_info = new String[]{'MeterPointAddress','Wheatley.WorkManagement','ElecAddress','0','1','true'};
        private String[] Meters_type_info = new String[]{'Meters','Wheatley.WorkManagement','ArrayOfElecMeter','0','1','true'};
        private String[] NonSettlementFunction_type_info = new String[]{'NonSettlementFunction','Wheatley.WorkManagement','DataEffectiveFrom','0','1','true'};
        private String[] Outstations_type_info = new String[]{'Outstations','Wheatley.WorkManagement','ArrayOfOutstation','0','1','true'};
        private String[] PriorityServiceContactInfo_type_info = new String[]{'PriorityServiceContactInfo','Wheatley.WorkManagement','PriorityServiceContactInfo','0','1','true'};
        private String[] RegistrationEffectiveFromDate_type_info = new String[]{'RegistrationEffectiveFromDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RemoteDisableEnableCapability_type_info = new String[]{'RemoteDisableEnableCapability','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ServiceLevelReference_type_info = new String[]{'ServiceLevelReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ServiceLocation_type_info = new String[]{'ServiceLocation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ServiceReference_type_info = new String[]{'ServiceReference','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SpecialAccess_type_info = new String[]{'SpecialAccess','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SpecialNeeds_type_info = new String[]{'SpecialNeeds','Wheatley.WorkManagement','ArrayOfSpecialNeed','0','1','true'};
        private String[] StdSettlementConfig_type_info = new String[]{'StdSettlementConfig','Wheatley.WorkManagement','DataEffectiveFrom','0','1','true'};
        private String[] Supply_type_info = new String[]{'Supply','Wheatley.WorkManagement','ElecSupply','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AdditionalInformation','CodeOfPractice','ContractReference','CustomerContact','CustomerName','CustomerPassword','CustomerPasswordEffectivefromDate','DataCollector','GridSupplyPointsGroupId','MPAN','MailingAddress','MaximumPowerRequirement','MeasurementClassId','MeterOperator','MeterPointAddress','Meters','NonSettlementFunction','Outstations','PriorityServiceContactInfo','RegistrationEffectiveFromDate','RemoteDisableEnableCapability','ServiceLevelReference','ServiceLocation','ServiceReference','SpecialAccess','SpecialNeeds','StdSettlementConfig','Supply'};
    }
    public class ElecMeter {
        public String CTRatio;
        public String CertificationDate;
        public String CertificationExpiryDate;
        public EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice CodeOfPractice;
        public String CurrentRating;
        public String Location;
        public String MainOrCheck;
        public String ManufacturerAndModel;
        public String RetrievalMethod;
        public String RetrievalMethodEffectiveDate;
        public String SerialNumber;
        public String TimingDeviceSerialNumber;
        public String Type_x;
        public String VTRatio;
        private String[] CTRatio_type_info = new String[]{'CTRatio','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CertificationDate_type_info = new String[]{'CertificationDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CertificationExpiryDate_type_info = new String[]{'CertificationExpiryDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CodeOfPractice_type_info = new String[]{'CodeOfPractice','Wheatley.WorkManagement','ElecMeterCodeOfPractice','0','1','true'};
        private String[] CurrentRating_type_info = new String[]{'CurrentRating','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Location_type_info = new String[]{'Location','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MainOrCheck_type_info = new String[]{'MainOrCheck','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ManufacturerAndModel_type_info = new String[]{'ManufacturerAndModel','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RetrievalMethod_type_info = new String[]{'RetrievalMethod','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RetrievalMethodEffectiveDate_type_info = new String[]{'RetrievalMethodEffectiveDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TimingDeviceSerialNumber_type_info = new String[]{'TimingDeviceSerialNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] VTRatio_type_info = new String[]{'VTRatio','Wheatley.WorkManagement','string','0','1','true'};
        public String AssetProviderId;
        public String InstallationDate;
        public EON_JUMBO_Work_Management_WS.ArrayOfElecRegister Registers;
        public String RemovalDate;
        private String[] AssetProviderId_type_info = new String[]{'AssetProviderId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] InstallationDate_type_info = new String[]{'InstallationDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Registers_type_info = new String[]{'Registers','Wheatley.WorkManagement','ArrayOfElecRegister','0','1','true'};
        private String[] RemovalDate_type_info = new String[]{'RemovalDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CTRatio','CertificationDate','CertificationExpiryDate','CodeOfPractice','CurrentRating','Location','MainOrCheck','ManufacturerAndModel','RetrievalMethod','RetrievalMethodEffectiveDate','SerialNumber','TimingDeviceSerialNumber','Type_x','VTRatio','AssetProviderId','InstallationDate','Registers','RemovalDate'};
    }
    public class ElecMeterBase {
        public String CTRatio;
        public String CertificationDate;
        public String CertificationExpiryDate;
        public EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice CodeOfPractice;
        public String CurrentRating;
        public String Location;
        public String MainOrCheck;
        public String ManufacturerAndModel;
        public String RetrievalMethod;
        public String RetrievalMethodEffectiveDate;
        public String SerialNumber;
        public String TimingDeviceSerialNumber;
        public String Type_x;
        public String VTRatio;
        private String[] CTRatio_type_info = new String[]{'CTRatio','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CertificationDate_type_info = new String[]{'CertificationDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CertificationExpiryDate_type_info = new String[]{'CertificationExpiryDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CodeOfPractice_type_info = new String[]{'CodeOfPractice','Wheatley.WorkManagement','ElecMeterCodeOfPractice','0','1','true'};
        private String[] CurrentRating_type_info = new String[]{'CurrentRating','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Location_type_info = new String[]{'Location','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MainOrCheck_type_info = new String[]{'MainOrCheck','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ManufacturerAndModel_type_info = new String[]{'ManufacturerAndModel','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RetrievalMethod_type_info = new String[]{'RetrievalMethod','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RetrievalMethodEffectiveDate_type_info = new String[]{'RetrievalMethodEffectiveDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TimingDeviceSerialNumber_type_info = new String[]{'TimingDeviceSerialNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] VTRatio_type_info = new String[]{'VTRatio','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CTRatio','CertificationDate','CertificationExpiryDate','CodeOfPractice','CurrentRating','Location','MainOrCheck','ManufacturerAndModel','RetrievalMethod','RetrievalMethodEffectiveDate','SerialNumber','TimingDeviceSerialNumber','Type_x','VTRatio'};
    }
    public class ElecMeterCodeOfPractice {
        public String Code;
        public String Dispensation;
        public String IssueNumber;
        private String[] Code_type_info = new String[]{'Code','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Dispensation_type_info = new String[]{'Dispensation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] IssueNumber_type_info = new String[]{'IssueNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Code','Dispensation','IssueNumber'};
    }
    public class ElecMeterPoint {
        public String MPAN;
        public EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty SupplierAppointments;
        private String[] MPAN_type_info = new String[]{'MPAN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SupplierAppointments_type_info = new String[]{'SupplierAppointments','Wheatley.WorkManagement','ArrayOfElecAppointedParty','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'MPAN','SupplierAppointments'};
    }
    public class ElecMeterPointDataRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public String MPAN;
        private String[] MPAN_type_info = new String[]{'MPAN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','MPAN'};
    }
    public class ElecMeterPointDataResponse {
        public EON_JUMBO_Work_Management_WS.ErrorList Errors;
        public Boolean Success;
        private String[] Errors_type_info = new String[]{'Errors','Wheatley.WorkManagement','ErrorList','0','1','true'};
        private String[] Success_type_info = new String[]{'Success','Wheatley.WorkManagement','boolean','0','1','false'};
        public EON_JUMBO_Work_Management_WS.ElecCustomer Customer;
        private String[] Customer_type_info = new String[]{'Customer','Wheatley.WorkManagement','ElecCustomer','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Errors','Success','Customer'};
    }
    public class ElecRegister {
        public String AssociatedMeterId;
        public String AssociatedRegisterId;
        public String ChannelNumber;
        public String Description;
        public String Id;
        public String MeasurementQuantityId;
        public String MeterMemoryLocation;
        public EON_JUMBO_Work_Management_WS.ArrayOfMeterMemoryLocationType MeterMemoryLocationTypes;
        public String Multiplier;
        public String NumberOfDigits;
        public String PulseMultiplier;
        public String TimestampMeterMemoryLocation;
        public String Type_x;
        private String[] AssociatedMeterId_type_info = new String[]{'AssociatedMeterId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AssociatedRegisterId_type_info = new String[]{'AssociatedRegisterId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ChannelNumber_type_info = new String[]{'ChannelNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Description_type_info = new String[]{'Description','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Id_type_info = new String[]{'Id','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeasurementQuantityId_type_info = new String[]{'MeasurementQuantityId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterMemoryLocation_type_info = new String[]{'MeterMemoryLocation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterMemoryLocationTypes_type_info = new String[]{'MeterMemoryLocationTypes','Wheatley.WorkManagement','ArrayOfMeterMemoryLocationType','0','1','true'};
        private String[] Multiplier_type_info = new String[]{'Multiplier','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfDigits_type_info = new String[]{'NumberOfDigits','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PulseMultiplier_type_info = new String[]{'PulseMultiplier','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TimestampMeterMemoryLocation_type_info = new String[]{'TimestampMeterMemoryLocation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        public EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime TimePatternRegimes;
        private String[] TimePatternRegimes_type_info = new String[]{'TimePatternRegimes','Wheatley.WorkManagement','ArrayOfTimePatternRegime','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AssociatedMeterId','AssociatedRegisterId','ChannelNumber','Description','Id','MeasurementQuantityId','MeterMemoryLocation','MeterMemoryLocationTypes','Multiplier','NumberOfDigits','PulseMultiplier','TimestampMeterMemoryLocation','Type_x','TimePatternRegimes'};
    }
    public class ElecRegisterBase {
        public String AssociatedMeterId;
        public String AssociatedRegisterId;
        public String ChannelNumber;
        public String Description;
        public String Id;
        public String MeasurementQuantityId;
        public String MeterMemoryLocation;
        public EON_JUMBO_Work_Management_WS.ArrayOfMeterMemoryLocationType MeterMemoryLocationTypes;
        public String Multiplier;
        public String NumberOfDigits;
        public String PulseMultiplier;
        public String TimestampMeterMemoryLocation;
        public String Type_x;
        private String[] AssociatedMeterId_type_info = new String[]{'AssociatedMeterId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AssociatedRegisterId_type_info = new String[]{'AssociatedRegisterId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ChannelNumber_type_info = new String[]{'ChannelNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Description_type_info = new String[]{'Description','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Id_type_info = new String[]{'Id','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeasurementQuantityId_type_info = new String[]{'MeasurementQuantityId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterMemoryLocation_type_info = new String[]{'MeterMemoryLocation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterMemoryLocationTypes_type_info = new String[]{'MeterMemoryLocationTypes','Wheatley.WorkManagement','ArrayOfMeterMemoryLocationType','0','1','true'};
        private String[] Multiplier_type_info = new String[]{'Multiplier','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfDigits_type_info = new String[]{'NumberOfDigits','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PulseMultiplier_type_info = new String[]{'PulseMultiplier','Wheatley.WorkManagement','string','0','1','true'};
        private String[] TimestampMeterMemoryLocation_type_info = new String[]{'TimestampMeterMemoryLocation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AssociatedMeterId','AssociatedRegisterId','ChannelNumber','Description','Id','MeasurementQuantityId','MeterMemoryLocation','MeterMemoryLocationTypes','Multiplier','NumberOfDigits','PulseMultiplier','TimestampMeterMemoryLocation','Type_x'};
    }
    public class ElecRegisterReading {
        public String Flag;
        public String Type_x;
        public String Value;
        private String[] Flag_type_info = new String[]{'Flag','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Value_type_info = new String[]{'Value','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Flag','Type_x','Value'};
    }
    public class ElecSiteVisit {
        public String EndDate;
        public String EndTime;
        public String StartDate;
        public String StartTime;
        private String[] EndDate_type_info = new String[]{'EndDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EndTime_type_info = new String[]{'EndTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] StartDate_type_info = new String[]{'StartDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] StartTime_type_info = new String[]{'StartTime','Wheatley.WorkManagement','string','0','1','true'};
        public String CheckCode;
        private String[] CheckCode_type_info = new String[]{'CheckCode','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'EndDate','EndTime','StartDate','StartTime','CheckCode'};
    }
    public class ElecSupplierDetailsRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public String MPAN;
        private String[] MPAN_type_info = new String[]{'MPAN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','MPAN'};
    }
    public class ElecSupplierDetailsResponse {
        public EON_JUMBO_Work_Management_WS.ErrorList Errors;
        public Boolean Success;
        private String[] Errors_type_info = new String[]{'Errors','Wheatley.WorkManagement','ErrorList','0','1','true'};
        private String[] Success_type_info = new String[]{'Success','Wheatley.WorkManagement','boolean','0','1','false'};
        public EON_JUMBO_Work_Management_WS.ElecMeterPoint MeterPoint;
        private String[] MeterPoint_type_info = new String[]{'MeterPoint','Wheatley.WorkManagement','ElecMeterPoint','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Errors','Success','MeterPoint'};
    }
    public class ElecSupply {
        public String Capacity;
        public String EnergisationStatus;
        public String Phases;
        public String Voltage;
        private String[] Capacity_type_info = new String[]{'Capacity','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EnergisationStatus_type_info = new String[]{'EnergisationStatus','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Phases_type_info = new String[]{'Phases','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Voltage_type_info = new String[]{'Voltage','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Capacity','EnergisationStatus','Phases','Voltage'};
    }
    public class ErrorList {
        public String[] Message;
        private String[] Message_type_info = new String[]{'Message','Wheatley.WorkManagement','string','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Message'};
    }
    public class GasAddress {
        public String AddressText;
        public String Building;
        public String County;
        public String DependentLocality;
        public String DependentThoroughfare;
        public String DoubleDependentLocality;
        public EON_JUMBO_Work_Management_WS.Coordinates GridCoordinates;
        public String PostCode;
        public String PostTown;
        public String SubBuilding;
        public String Thoroughfare;
        public String UPRN;
        private String[] AddressText_type_info = new String[]{'AddressText','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Building_type_info = new String[]{'Building','Wheatley.WorkManagement','string','0','1','true'};
        private String[] County_type_info = new String[]{'County','Wheatley.WorkManagement','string','0','1','true'};
        private String[] DependentLocality_type_info = new String[]{'DependentLocality','Wheatley.WorkManagement','string','0','1','true'};
        private String[] DependentThoroughfare_type_info = new String[]{'DependentThoroughfare','Wheatley.WorkManagement','string','0','1','true'};
        private String[] DoubleDependentLocality_type_info = new String[]{'DoubleDependentLocality','Wheatley.WorkManagement','string','0','1','true'};
        private String[] GridCoordinates_type_info = new String[]{'GridCoordinates','Wheatley.WorkManagement','Coordinates','0','1','true'};
        private String[] PostCode_type_info = new String[]{'PostCode','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PostTown_type_info = new String[]{'PostTown','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SubBuilding_type_info = new String[]{'SubBuilding','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Thoroughfare_type_info = new String[]{'Thoroughfare','Wheatley.WorkManagement','string','0','1','true'};
        private String[] UPRN_type_info = new String[]{'UPRN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AddressText','Building','County','DependentLocality','DependentThoroughfare','DoubleDependentLocality','GridCoordinates','PostCode','PostTown','SubBuilding','Thoroughfare','UPRN'};
    }
    public class GasAppointedParty {
        public String EffectiveFromDate;
        public String EffectiveToDate;
        private String[] EffectiveFromDate_type_info = new String[]{'EffectiveFromDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EffectiveToDate_type_info = new String[]{'EffectiveToDate','Wheatley.WorkManagement','string','0','1','true'};
        public String AbbreviatedName;
        private String[] AbbreviatedName_type_info = new String[]{'AbbreviatedName','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'EffectiveFromDate','EffectiveToDate','AbbreviatedName'};
    }
    public class GasCustomer {
        public String AccessInstructions;
        public String AccessPassword;
        public EON_JUMBO_Work_Management_WS.GasAddress Address;
        public EON_JUMBO_Work_Management_WS.ArrayOfContact Contacts;
        public String ConversionFactor;
        public EON_JUMBO_Work_Management_WS.ArrayOfConverter Converters;
        public String LastInspectionDate;
        public String Location;
        public String LocationNotes;
        public String MPRN;
        public String MeterLink;
        public String MeterPointStatus;
        public String MeteringPressure;
        public EON_JUMBO_Work_Management_WS.ArrayOfGasMeter Meters;
        public EON_JUMBO_Work_Management_WS.GasAppointedParty Supplier;
        private String[] AccessInstructions_type_info = new String[]{'AccessInstructions','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AccessPassword_type_info = new String[]{'AccessPassword','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Address_type_info = new String[]{'Address','Wheatley.WorkManagement','GasAddress','0','1','true'};
        private String[] Contacts_type_info = new String[]{'Contacts','Wheatley.WorkManagement','ArrayOfContact','0','1','true'};
        private String[] ConversionFactor_type_info = new String[]{'ConversionFactor','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Converters_type_info = new String[]{'Converters','Wheatley.WorkManagement','ArrayOfConverter','0','1','true'};
        private String[] LastInspectionDate_type_info = new String[]{'LastInspectionDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Location_type_info = new String[]{'Location','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LocationNotes_type_info = new String[]{'LocationNotes','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MPRN_type_info = new String[]{'MPRN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterLink_type_info = new String[]{'MeterLink','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeterPointStatus_type_info = new String[]{'MeterPointStatus','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeteringPressure_type_info = new String[]{'MeteringPressure','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Meters_type_info = new String[]{'Meters','Wheatley.WorkManagement','ArrayOfGasMeter','0','1','true'};
        private String[] Supplier_type_info = new String[]{'Supplier','Wheatley.WorkManagement','GasAppointedParty','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AccessInstructions','AccessPassword','Address','Contacts','ConversionFactor','Converters','LastInspectionDate','Location','LocationNotes','MPRN','MeterLink','MeterPointStatus','MeteringPressure','Meters','Supplier'};
    }
    public class GasMeter {
        public String AssetClass;
        public String AssetProvider;
        public String CollarStatus;
        public String InspectionDate;
        public String LastRefurbishedDate;
        public String Location;
        public String LocationNotes;
        public String Manufacturer;
        public String MeasuringCapacity;
        public String Mechanism;
        public String Model;
        public String PaymentMethod;
        public String ProductId;
        public String PulseValue;
        public EON_JUMBO_Work_Management_WS.ArrayOfGasRegister Registers;
        public String SerialNumber;
        public String Status;
        public String Type_x;
        public String Usage;
        public String YearOfManufacture;
        private String[] AssetClass_type_info = new String[]{'AssetClass','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AssetProvider_type_info = new String[]{'AssetProvider','Wheatley.WorkManagement','string','0','1','true'};
        private String[] CollarStatus_type_info = new String[]{'CollarStatus','Wheatley.WorkManagement','string','0','1','true'};
        private String[] InspectionDate_type_info = new String[]{'InspectionDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LastRefurbishedDate_type_info = new String[]{'LastRefurbishedDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Location_type_info = new String[]{'Location','Wheatley.WorkManagement','string','0','1','true'};
        private String[] LocationNotes_type_info = new String[]{'LocationNotes','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Manufacturer_type_info = new String[]{'Manufacturer','Wheatley.WorkManagement','string','0','1','true'};
        private String[] MeasuringCapacity_type_info = new String[]{'MeasuringCapacity','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Mechanism_type_info = new String[]{'Mechanism','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Model_type_info = new String[]{'Model','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PaymentMethod_type_info = new String[]{'PaymentMethod','Wheatley.WorkManagement','string','0','1','true'};
        private String[] ProductId_type_info = new String[]{'ProductId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] PulseValue_type_info = new String[]{'PulseValue','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Registers_type_info = new String[]{'Registers','Wheatley.WorkManagement','ArrayOfGasRegister','0','1','true'};
        private String[] SerialNumber_type_info = new String[]{'SerialNumber','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Status_type_info = new String[]{'Status','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Usage_type_info = new String[]{'Usage','Wheatley.WorkManagement','string','0','1','true'};
        private String[] YearOfManufacture_type_info = new String[]{'YearOfManufacture','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AssetClass','AssetProvider','CollarStatus','InspectionDate','LastRefurbishedDate','Location','LocationNotes','Manufacturer','MeasuringCapacity','Mechanism','Model','PaymentMethod','ProductId','PulseValue','Registers','SerialNumber','Status','Type_x','Usage','YearOfManufacture'};
    }
    public class GasMeterPoint {
        public String MPRN;
        public EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty SupplierAppointments;
        private String[] MPRN_type_info = new String[]{'MPRN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] SupplierAppointments_type_info = new String[]{'SupplierAppointments','Wheatley.WorkManagement','ArrayOfGasAppointedParty','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'MPRN','SupplierAppointments'};
    }
    public class GasMeterPointDataRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public String MPRN;
        private String[] MPRN_type_info = new String[]{'MPRN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','MPRN'};
    }
    public class GasMeterPointDataResponse {
        public EON_JUMBO_Work_Management_WS.ErrorList Errors;
        public Boolean Success;
        private String[] Errors_type_info = new String[]{'Errors','Wheatley.WorkManagement','ErrorList','0','1','true'};
        private String[] Success_type_info = new String[]{'Success','Wheatley.WorkManagement','boolean','0','1','false'};
        public EON_JUMBO_Work_Management_WS.GasCustomer Customer;
        private String[] Customer_type_info = new String[]{'Customer','Wheatley.WorkManagement','GasCustomer','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Errors','Success','Customer'};
    }
    public class GasRegister {
        public String MultiplicationFactor;
        public String NumberOfDigits;
        public String Type_x;
        public String UnitsOfMeasure;
        private String[] MultiplicationFactor_type_info = new String[]{'MultiplicationFactor','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfDigits_type_info = new String[]{'NumberOfDigits','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] UnitsOfMeasure_type_info = new String[]{'UnitsOfMeasure','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'MultiplicationFactor','NumberOfDigits','Type_x','UnitsOfMeasure'};
    }
    public class GasSupplierDetailsRequest {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        public String MPRN;
        private String[] MPRN_type_info = new String[]{'MPRN','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId','MPRN'};
    }
    public class GasSupplierDetailsResponse {
        public EON_JUMBO_Work_Management_WS.ErrorList Errors;
        public Boolean Success;
        private String[] Errors_type_info = new String[]{'Errors','Wheatley.WorkManagement','ErrorList','0','1','true'};
        private String[] Success_type_info = new String[]{'Success','Wheatley.WorkManagement','boolean','0','1','false'};
        public EON_JUMBO_Work_Management_WS.GasMeterPoint MeterPoint;
        private String[] MeterPoint_type_info = new String[]{'MeterPoint','Wheatley.WorkManagement','GasMeterPoint','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Errors','Success','MeterPoint'};
    }
    public class GasTransaction {
        public String Comment;
        public String Status;
        public String StatusChangeReason;
        private String[] Comment_type_info = new String[]{'Comment','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Status_type_info = new String[]{'Status','Wheatley.WorkManagement','string','0','1','true'};
        private String[] StatusChangeReason_type_info = new String[]{'StatusChangeReason','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Comment','Status','StatusChangeReason'};
    }
    public class JumboTechnicalResponse {
        public EON_JUMBO_Work_Management_WS.ErrorList Errors;
        public Boolean Success;
        private String[] Errors_type_info = new String[]{'Errors','Wheatley.WorkManagement','ErrorList','0','1','true'};
        private String[] Success_type_info = new String[]{'Success','Wheatley.WorkManagement','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Errors','Success'};
    }
    public class MeterMemoryLocationType {
        public String Type_x;
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Type_x'};
    }
    public class Outstation {
        public EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice CodeOfPractice;
        public String EncryptionKey;
        public String Id;
        public String Multiplier;
        public String NumberOfChannels;
        public String NumberOfDigits;
        public EON_JUMBO_Work_Management_WS.OutstationPasswords Passwords;
        public String Pin;
        public String Type_x;
        public EON_JUMBO_Work_Management_WS.OutstationUsernames Usernames;
        private String[] CodeOfPractice_type_info = new String[]{'CodeOfPractice','Wheatley.WorkManagement','OutstationCodeOfPractice','0','1','true'};
        private String[] EncryptionKey_type_info = new String[]{'EncryptionKey','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Id_type_info = new String[]{'Id','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Multiplier_type_info = new String[]{'Multiplier','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfChannels_type_info = new String[]{'NumberOfChannels','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfDigits_type_info = new String[]{'NumberOfDigits','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Passwords_type_info = new String[]{'Passwords','Wheatley.WorkManagement','OutstationPasswords','0','1','true'};
        private String[] Pin_type_info = new String[]{'Pin','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Usernames_type_info = new String[]{'Usernames','Wheatley.WorkManagement','OutstationUsernames','0','1','true'};
        public EON_JUMBO_Work_Management_WS.ArrayOfCommsBase Comms;
        private String[] Comms_type_info = new String[]{'Comms','Wheatley.WorkManagement','ArrayOfCommsBase','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CodeOfPractice','EncryptionKey','Id','Multiplier','NumberOfChannels','NumberOfDigits','Passwords','Pin','Type_x','Usernames','Comms'};
    }
    public class OutstationBase {
        public EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice CodeOfPractice;
        public String EncryptionKey;
        public String Id;
        public String Multiplier;
        public String NumberOfChannels;
        public String NumberOfDigits;
        public EON_JUMBO_Work_Management_WS.OutstationPasswords Passwords;
        public String Pin;
        public String Type_x;
        public EON_JUMBO_Work_Management_WS.OutstationUsernames Usernames;
        private String[] CodeOfPractice_type_info = new String[]{'CodeOfPractice','Wheatley.WorkManagement','OutstationCodeOfPractice','0','1','true'};
        private String[] EncryptionKey_type_info = new String[]{'EncryptionKey','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Id_type_info = new String[]{'Id','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Multiplier_type_info = new String[]{'Multiplier','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfChannels_type_info = new String[]{'NumberOfChannels','Wheatley.WorkManagement','string','0','1','true'};
        private String[] NumberOfDigits_type_info = new String[]{'NumberOfDigits','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Passwords_type_info = new String[]{'Passwords','Wheatley.WorkManagement','OutstationPasswords','0','1','true'};
        private String[] Pin_type_info = new String[]{'Pin','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Type_x_type_info = new String[]{'Type','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Usernames_type_info = new String[]{'Usernames','Wheatley.WorkManagement','OutstationUsernames','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'CodeOfPractice','EncryptionKey','Id','Multiplier','NumberOfChannels','NumberOfDigits','Passwords','Pin','Type_x','Usernames'};
    }
    public class OutstationCodeOfPractice {
        public String Code;
        public String Dispensation;
        private String[] Code_type_info = new String[]{'Code','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Dispensation_type_info = new String[]{'Dispensation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Code','Dispensation'};
    }
    public class OutstationPasswords {
        public String Level1;
        public String Level2;
        public String Level3;
        private String[] Level1_type_info = new String[]{'Level1','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Level2_type_info = new String[]{'Level2','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Level3_type_info = new String[]{'Level3','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Level1','Level2','Level3'};
    }
    public class OutstationUsernames {
        public String Level1;
        public String Level2;
        public String Level3;
        private String[] Level1_type_info = new String[]{'Level1','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Level2_type_info = new String[]{'Level2','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Level3_type_info = new String[]{'Level3','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Level1','Level2','Level3'};
    }
    public class PriorityServiceContactInfo {
        public EON_JUMBO_Work_Management_WS.ElecAddress Address;
        public String AlternateName;
        public String AlternateTelephone1;
        public String AlternateTelephone2;
        public String Name;
        public String Telephone1;
        public String Telephone2;
        public String Telephone3;
        private String[] Address_type_info = new String[]{'Address','Wheatley.WorkManagement','ElecAddress','0','1','true'};
        private String[] AlternateName_type_info = new String[]{'AlternateName','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AlternateTelephone1_type_info = new String[]{'AlternateTelephone1','Wheatley.WorkManagement','string','0','1','true'};
        private String[] AlternateTelephone2_type_info = new String[]{'AlternateTelephone2','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Name_type_info = new String[]{'Name','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Telephone1_type_info = new String[]{'Telephone1','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Telephone2_type_info = new String[]{'Telephone2','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Telephone3_type_info = new String[]{'Telephone3','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Address','AlternateName','AlternateTelephone1','AlternateTelephone2','Name','Telephone1','Telephone2','Telephone3'};
    }
    public class RequestBase {
        public EON_JUMBO_Work_Management_WS.ClientData Client;
        public String UniqueId;
        private String[] Client_type_info = new String[]{'Client','Wheatley.WorkManagement','ClientData','0','1','true'};
        private String[] UniqueId_type_info = new String[]{'UniqueId','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Client','UniqueId'};
    }
    public class RequestElectricityMeterPointData_element {
        public EON_JUMBO_Work_Management_WS.ElecMeterPointDataRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','ElecMeterPointDataRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class RequestElectricityMeterPointDataResponse_element {
        public EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse RequestElectricityMeterPointDataResult;
        private String[] RequestElectricityMeterPointDataResult_type_info = new String[]{'RequestElectricityMeterPointDataResult','Wheatley.WorkManagement','ElecMeterPointDataResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'RequestElectricityMeterPointDataResult'};
    }
    public class RequestElectricitySupplierAppointments_element {
        public EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','ElecSupplierDetailsRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class RequestElectricitySupplierAppointmentsResponse_element {
        public EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse RequestElectricitySupplierAppointmentsResult;
        private String[] RequestElectricitySupplierAppointmentsResult_type_info = new String[]{'RequestElectricitySupplierAppointmentsResult','Wheatley.WorkManagement','ElecSupplierDetailsResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'RequestElectricitySupplierAppointmentsResult'};
    }
    public class RequestGasMeterPointData_element {
        public EON_JUMBO_Work_Management_WS.GasMeterPointDataRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','GasMeterPointDataRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class RequestGasMeterPointDataResponse_element {
        public EON_JUMBO_Work_Management_WS.GasMeterPointDataResponse RequestGasMeterPointDataResult;
        private String[] RequestGasMeterPointDataResult_type_info = new String[]{'RequestGasMeterPointDataResult','Wheatley.WorkManagement','GasMeterPointDataResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'RequestGasMeterPointDataResult'};
    }
    public class RequestGasSupplierAppointments_element {
        public EON_JUMBO_Work_Management_WS.GasSupplierDetailsRequest request;
        private String[] request_type_info = new String[]{'request','Wheatley.WorkManagement','GasSupplierDetailsRequest','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class RequestGasSupplierAppointmentsResponse_element {
        public EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse RequestGasSupplierAppointmentsResult;
        private String[] RequestGasSupplierAppointmentsResult_type_info = new String[]{'RequestGasSupplierAppointmentsResult','Wheatley.WorkManagement','GasSupplierDetailsResponse','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'RequestGasSupplierAppointmentsResult'};
    }
    public class ResponseBase {
        public EON_JUMBO_Work_Management_WS.ErrorList Errors;
        public Boolean Success;
        private String[] Errors_type_info = new String[]{'Errors','Wheatley.WorkManagement','ErrorList','0','1','true'};
        private String[] Success_type_info = new String[]{'Success','Wheatley.WorkManagement','boolean','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Errors','Success'};
    }
    public class SiteVisit {
        public String EndDate;
        public String EndTime;
        public String StartDate;
        public String StartTime;
        private String[] EndDate_type_info = new String[]{'EndDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EndTime_type_info = new String[]{'EndTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] StartDate_type_info = new String[]{'StartDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] StartTime_type_info = new String[]{'StartTime','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'EndDate','EndTime','StartDate','StartTime'};
    }
    public class SpecialNeed {
        public String AdditionalInformation;
        public String Category;
        private String[] AdditionalInformation_type_info = new String[]{'AdditionalInformation','Wheatley.WorkManagement','string','0','1','true'};
        private String[] Category_type_info = new String[]{'Category','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'AdditionalInformation','Category'};
    }
    public class TimePatternRegime {
        public String Code;
        public String RegisterMappingCoefficient;
        private String[] Code_type_info = new String[]{'Code','Wheatley.WorkManagement','string','0','1','true'};
        private String[] RegisterMappingCoefficient_type_info = new String[]{'RegisterMappingCoefficient','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'Code','RegisterMappingCoefficient'};
    }
    public class WithEffectiveDatesBase {
        public String EffectiveFromDate;
        public String EffectiveToDate;
        private String[] EffectiveFromDate_type_info = new String[]{'EffectiveFromDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] EffectiveToDate_type_info = new String[]{'EffectiveToDate','Wheatley.WorkManagement','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'Wheatley.WorkManagement','true','false'};
        private String[] field_order_type_info = new String[]{'EffectiveFromDate','EffectiveToDate'};
    }
}