/**
Description : This test class is for the following below classes/triggers
              EON_MDS_Elec_Close_Outbound_Job;    
              
**/

/*
    Created By  : Mehboob Alam
    Created On  : 07/02/2019
    Service Req	: SR_EON_297
    Change History
	CH01 # SR_OptiMUS_EON_298 # 05/03/2019 # Tabish Almas # Added new method closeElecJobCheckCode_Pass()
    
*/

@isTest
global class EON_MDS_Elec_Close_Outbound_Job_Test implements WebServiceMock {
 public static boolean successFlag=true;
    public static string opName = '';
    public static string markerParID = '';

   /**
   doInvoke - Mock callout method   
   **/   
  global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
            String[] Msg = new String[]{'Message1','Message2','Message3'};    
            EON_MDS_Work_Management_WS.ErrorList err = new EON_MDS_Work_Management_WS.ErrorList();
            err.Message = Msg;
            EON_MDS_Work_Management_WS.JumboTechnicalResponse resp = new EON_MDS_Work_Management_WS.JumboTechnicalResponse();
            resp.Errors = err;
            if(successFlag)
              resp.Success=true;
              else
               resp.Success=false;
               
            EON_MDS_Work_Management_WS.CloseJumboElectricityJobResponse_element obj = new EON_MDS_Work_Management_WS.CloseJumboElectricityJobResponse_element();
            obj.CloseJumboElectricityJobResult=resp;
            if(opName == 'closeElecJob')
                response.put('response_x', obj);
            if(opName == 'closeElecJobViaTrigger'){
                if(request instanceof EON_MDS_Work_Management_WS.CloseJumboElectricityJob_element)
                    response.put('response_x', obj);
                else if(request instanceof EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointments_element){
                    String[] Msg1 = new String[]{'Message1','Message2','Message3'};
                    EON_MDS_Work_Management_WS.ErrorList errObj = new EON_MDS_Work_Management_WS.ErrorList();
                    errObj.Message = Msg1;
                    EON_MDS_Work_Management_WS.ElecAppointedParty eapObj = new EON_MDS_Work_Management_WS.ElecAppointedParty(); 
                    eapObj.EffectiveFromDate ='20150423'; 
                    eapObj.EffectiveToDate='20160823';    
                    eapObj.MarketParticipantId= markerParID;//'EMEB';
                    EON_MDS_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_MDS_Work_Management_WS.ElecAppointedParty[]{eapObj};
                    EON_MDS_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_MDS_Work_Management_WS.ArrayOfElecAppointedParty();
                    aepObj.ElecAppointedParty = aEobj;
                    EON_MDS_Work_Management_WS.ElecMeterPoint empObj = new EON_MDS_Work_Management_WS.ElecMeterPoint();
                    empObj.MPAN = 'mpan123';
                    empObj.SupplierAppointments = aepObj;
                    EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse respMDS = new EON_MDS_Work_Management_WS.ElecSupplierDetailsResponse();
                    if(successFlag)
                        respMDS.Success = true;
                    else 
                        respMDS.Success = false;
                    respMDS.MeterPoint=empObj;
                    respMDS.Errors = errObj;
                    EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj1 = new EON_MDS_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
                    obj1.RequestElectricitySupplierAppointmentsResult = respMDS;
                    response.put('response_x', obj1);
                }
                    
            }
         }              
    
    /**
        closeElecJobMDS_Test1() - Positive test for EON_MDS_Elec_Close_Outbound_Job
    **/
    static testMethod void closeElecJobMDS_Test1() {
        //CH06.New.Start
        EON_SSC__c scc = EON_CreateTestRecords.createEON_SSC();
        scc.Name = '1122';
        scc.Type__c = 'Classic';
        scc.Tariff_Code__c = '111'; 
        insert scc;
        //CH06.New.End
        //test cases for method MapLocationCode
        EON_MDS_Elec_Close_Outbound_Job.MapLocationCode('Test');
        EON_MDS_Elec_Close_Outbound_Job.IndCodeMeterType('Test');
        EON_MDS_Elec_Close_Outbound_Job.EnergStatus('Test');
        //EON_MDS_Elec_Close_Outbound_Job.IndCodeNewMeterType('Test');
        Test.setMock(WebServiceMock.class, new EON_MDS_Elec_Close_Outbound_Job_Test());
        EON_MDS_Elec_Close_Outbound_Job_Test.opName = 'closeElecJob';
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='1Ph';
        app.GSP_Group_ID__c = '1122';
        insert app; 
        
        EON_Electric_Meter_Type__c emeterType = new EON_Electric_Meter_Type__c();
        emeterType.Name = 'MS1';
        emeterType.Description__c = 'MS1';
        insert emeterType;
        
        EON_Electric_Meter_Location__c eMeterLoc = new EON_Electric_Meter_Location__c(); //CH13.New
        eMeterLoc.Name = 'Communal Cupboard';
        eMeterLoc.Code__c = 'C';
        insert eMeterLoc;
        
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = '1122';
        insert eSSC;
        
        EON_GSP_Group__c eGSP = new EON_GSP_Group__c();
        eGSP.Name = '1122';
        insert eGSP;
        
        EON_SSC_Group__c eSccGroup = new EON_SSC_Group__c();
        eSccGroup.SSC__c = eSSC.ID;
        eSccGroup.Group__c = eGSP.ID;
        eSccGroup.Tariff_Code__c = '1122';
        insert eSccGroup;
        
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Job_Reference__c =app.id;
        appJobRes.Time_On_Site__c = DateTime.now();
        appJobRes.Time_Closed__c = DateTime.now();
        appJobRes.Reason_for_not_taking_Elec_Reading__c='Equipment/Meter Damaged';  //CH03.Update
        appJobRes.Abort_Reason__c ='Pre Visit Customer Refusal';
        appJobRes.Work_Completed__c ='WorkCompleted';
        appJobRes.Ending_Energisation_Status__c ='De-Energised';
        //appJobRes.Electric_SSC_to_be_installed__c= 'ssc'; //CH06.Old
        appJobRes.Electric_SSC_to_be_installed__c= '1122'; //CH06.New
        appJobRes.E_Meter_Type__c='MS1'; 
        appJobRes.New_E_Meter_Type__c='KEY';//CH05
        appJobRes.DNO_Safe_to_Continue__c = 'Yes';
        appJobRes.E_Meter_Serial_Number__c = 'EMeterSerialNumber';
        appJobRes.New_E_Meter_Serial_Number__c= 'NewMeterSerialNumber';
        appJobRes.E_Meter_Manufacturer_version__c= 'Manufacturer';
        appJobRes.New_E_Meter_Manufacturer__c= 'Manufacturer';
        appJobRes.New_E_Meter_Version__c= 'Version';
        appJobRes.New_E_Meter_Location__c='Communal Cupboard';
        appJobRes.E_Meter_Location__c='Communal Cupboard';
        appJobRes.E_Meter_Installed__c ='Yes';
        //appJobRes.E_Meter_Certification_Date__c =Date.today(); //CH04.Old
        appJobRes.E_Meter_Certification_Date__c ='20160909'; //CH04.New
        appJobRes.Elec_Prepay_Meter_Balance__c=2;
        appJobRes.Elec_Prepay_Meter_Total_Debt__c=2;
        appJobRes.Elec_Prepay_Debt_Recovery_Rate__c=2;
        appJobRes.Elec_Prepay_Meter_Weekly_Charge__c=2;
        appJobRes.E_Meter_Removed__c='No';
        appJobRes.E_Meter_Register_1_ID__c='12';
        appJobRes.E_Meter_Register_2_ID__c='12';
        appJobRes.E_Meter_Register_3_ID__c='12';
        appJobRes.E_Meter_Register_4_ID__c='12';
        appJobRes.E_Meter_Register_5_ID__c='12';
        appJobRes.E_Meter_Register_6_ID__c='12';
        appJobRes.New_E_Meter_Register_1_ID__c='13';
        appJobRes.New_E_Meter_Register_2_ID__c='13';
        appJobRes.New_E_Meter_Register_3_ID__c='13';
        appJobRes.New_E_Meter_Register_4_ID__c='13';
        appJobRes.New_E_Meter_Register_5_ID__c='13';
        appJobRes.New_E_Meter_Register_6_ID__c='13';
        appJobRes.New_E_Meter_Number_of_digits__c=8;
        appJobRes.E_Meter_Register_1_Read__c='12345';
        appJobRes.E_Meter_Register_2_Read__c='12345';
        appJobRes.E_Meter_Register_3_Read__c='12345';
        appJobRes.E_Meter_Register_4_Read__c='12345';
        appJobRes.E_Meter_Register_5_Read__c='12345';
        appJobRes.E_Meter_Register_6_Read__c='12345';
        appJobRes.New_E_Meter_Register_1_Reading__c='54321';
        appJobRes.New_E_Meter_Register_2_Reading__c='54321';
        appJobRes.New_E_Meter_Register_3_Reading__c='54321';
        appJobRes.New_E_Meter_Register_4_Reading__c='54321';
        appJobRes.New_E_Meter_Register_5_Reading__c='54321';
        appJobRes.New_E_Meter_Register_6_Reading__c='54321';
        appJobRes.Pre_Work_DNO_Defect_Details__c = 'Atest';
        appJobRes.Pre_Work_DNO_Electric_Reference_Number__c = 'Atest';
        //appJobRes.Actual_SSC_Installed__c = '1122';
        insert appJobRes;
        
        //Calling close Elec job method method
        test.startTest();
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.id,false);
        test.stopTest();
    }
    
    /**
        closeElecJobMDS_Test1_1() - Positive test for EON_MDS_Elec_Close_Outbound_Job
    **/
    static testMethod void closeElecJobMDS_Test1_1() {
        EON_SSC__c scc = EON_CreateTestRecords.createEON_SSC();
        scc.Name = '1122';
        scc.Type__c = 'Classic';
        scc.Tariff_Code__c = '111'; 
        insert scc;
        //test cases for method MapLocationCode
        EON_MDS_Elec_Close_Outbound_Job.MapLocationCode('Test');
        EON_MDS_Elec_Close_Outbound_Job.IndCodeMeterType('Test');
        EON_MDS_Elec_Close_Outbound_Job.EnergStatus('Test');
        //EON_MDS_Elec_Close_Outbound_Job.IndCodeNewMeterType('Test');
        Test.setMock(WebServiceMock.class, new EON_MDS_Elec_Close_Outbound_Job_Test());
        EON_MDS_Elec_Close_Outbound_Job_Test.opName = 'closeElecJob';
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='3Ph';
        app.Current_SSC__c = '1122';
        app.GSP_Group_ID__c = '1122';
        insert app; 
        
        EON_Electric_Meter_Type__c emeterType = new EON_Electric_Meter_Type__c();
        emeterType.Name = 'MS1';
        emeterType.Description__c = 'MS1';
        insert emeterType;
        
        EON_SSC__c eSSC = new EON_SSC__c();
        eSSC.Name = '1122';
        insert eSSC;
        
        EON_GSP_Group__c eGSP = new EON_GSP_Group__c();
        eGSP.Name = '1122';
        insert eGSP;
        
        EON_SSC_Group__c eSccGroup = new EON_SSC_Group__c();
        eSccGroup.SSC__c = eSSC.ID;
        eSccGroup.Group__c = eGSP.ID;
        eSccGroup.Tariff_Code__c = '1122';
        insert eSccGroup;
        
        EON_Technician__c tech = new EON_Technician__c();
        tech.Name = 'test';
        tech.Start_Date__c = Date.today();
        insert tech;
        
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Technician__c = tech.ID;
        appJobRes.Job_Reference__c =app.id;
        appJobRes.Time_On_Site__c = DateTime.now();
        appJobRes.Time_Closed__c = DateTime.now();
        appJobRes.Reason_for_not_taking_Elec_Reading__c='Equipment/Meter Damaged';  //CH03.Update
        appJobRes.Abort_Reason__c ='Pre Visit Customer Refusal';
        appJobRes.Work_Completed__c ='WorkCompleted';
        appJobRes.Ending_Energisation_Status__c ='De-Energised';
        //appJobRes.Electric_SSC_to_be_installed__c= 'ssc'; //CH06.Old
        appJobRes.Electric_SSC_to_be_installed__c= '1122'; //CH06.New
        appJobRes.E_Meter_Type__c='KEY'; 
        
        //appJobRes.New_E_Meter_Type__c='MS1';//CH05
        appJobRes.DNO_Safe_to_Continue__c = 'Yes';
        appJobRes.E_Meter_Serial_Number__c = 'EMeterSerialNumber';
        appJobRes.New_E_Meter_Serial_Number__c= 'NewMeterSerialNumber';
        appJobRes.E_Meter_Manufacturer_version__c= 'Manufacturer';
        appJobRes.New_E_Meter_Manufacturer__c= 'Manufacturer';
        appJobRes.New_E_Meter_Version__c= 'Version';
        appJobRes.New_E_Meter_Location__c='Communal Cupboard';
        appJobRes.E_Meter_Location__c='Communal Cupboard';
        appJobRes.E_Meter_Installed__c ='Yes';
        //appJobRes.E_Meter_Certification_Date__c =Date.today(); //CH04.Old
        appJobRes.E_Meter_Certification_Date__c ='20160909'; //CH04.New
        appJobRes.Elec_Prepay_Meter_Balance__c=2;
        appJobRes.Elec_Prepay_Meter_Total_Debt__c=2;
        appJobRes.Elec_Prepay_Debt_Recovery_Rate__c=2;
        appJobRes.Elec_Prepay_Meter_Weekly_Charge__c=2;
        appJobRes.E_Meter_Removed__c='Yes';
        appJobRes.E_Meter_Register_1_ID__c='12';
        appJobRes.E_Meter_Register_2_ID__c='12';
        appJobRes.E_Meter_Register_3_ID__c='12';
        appJobRes.E_Meter_Register_4_ID__c='12';
        appJobRes.E_Meter_Register_5_ID__c='12';
        appJobRes.E_Meter_Register_6_ID__c='12';
        appJobRes.New_E_Meter_Register_1_ID__c='13';
        appJobRes.New_E_Meter_Register_2_ID__c='13';
        appJobRes.New_E_Meter_Register_3_ID__c='13';
        appJobRes.New_E_Meter_Register_4_ID__c='13';
        appJobRes.New_E_Meter_Register_5_ID__c='13';
        appJobRes.New_E_Meter_Register_6_ID__c='13';
        appJobRes.New_E_Meter_Number_of_digits__c=8;
        appJobRes.E_Meter_Register_1_Read__c='12345';
        appJobRes.E_Meter_Register_2_Read__c='12345';
        appJobRes.E_Meter_Register_3_Read__c='12345';
        appJobRes.E_Meter_Register_4_Read__c='12345';
        appJobRes.E_Meter_Register_5_Read__c='12345';
        appJobRes.E_Meter_Register_6_Read__c='12345';
        appJobRes.New_E_Meter_Register_1_Reading__c='54321';
        appJobRes.New_E_Meter_Register_2_Reading__c='54321';
        appJobRes.New_E_Meter_Register_3_Reading__c='54321';
        appJobRes.New_E_Meter_Register_4_Reading__c='54321';
        appJobRes.New_E_Meter_Register_5_Reading__c='54321';
        appJobRes.New_E_Meter_Register_6_Reading__c='54321';
        appJobRes.Weekly_Debt_Repayment__c = 12.00; //CH08
        appJobRes.Emergency_Credit__c = 12.00;   //CH08
        appJobRes.Total_Debt__c = 12.00;   //CH08
        appJobRes.Elec_Prepay_Meter_Emergency_Credit__c = 12.00;  //CH08
        appJobRes.New_Prepayment_Meter_Unit_Rate_1__c = 12.00;  //CH08
        appJobRes.New_Prepayment_Meter_Unit_Rate_2__c = 12.00;
        appJobRes.New_Prepayment_Meter_Unit_Rate_3__c = 12.00;
        appJobRes.New_Prepayment_Meter_Unit_Rate_4__c = 12.00;
        appJobRes.New_Prepayment_Meter_Unit_Rate_5__c = 12.00;
        appJobRes.New_Prepayment_Meter_Unit_Rate_6__c = 12.00;
        appJobRes.Elec_Prepay_Meter_Unit_Rate_1__c = 12.00;
        appJobRes.Elec_Prepay_Meter_Unit_Rate_2__c = 12.00;
        appJobRes.Elec_Prepay_Meter_Unit_Rate_3__c = 12.00;
        appJobRes.Elec_Prepay_Meter_Unit_Rate_4__c = 12.00;
        appJobRes.Elec_Prepay_Meter_Unit_Rate_5__c = 12.00;
        appJobRes.Elec_Prepay_Meter_Unit_Rate_6__c = 12.00;
        insert appJobRes;
        
        //Calling close Elec job method method
        test.startTest();
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.id, false);
        test.stopTest();
    }
    
    /**
        closeElecJobMDS_Test2() - Positive test to EON_MDS_Elec_Close_Outbound_Job as part of CH01
    **/
    static testmethod void closeElecJobMDS_Test2(){
        //Create EON SSC Record
        EON_SSC__c scc = EON_CreateTestRecords.createEON_SSC();
        scc.Name = '1122';
        scc.Type__c = 'Classic';
        scc.Tariff_Code__c = '111'; //CH06
        insert scc;
        
        //Create EON SSC Register records
        list<EON_SSC_Register__c> allRegisters = new list<EON_SSC_Register__c>();
        for(integer i = 0; i<=5; i++){
            EON_SSC_Register__c reg = new EON_SSC_Register__c();
            reg.SSC__c = scc.ID;
            reg.Register_ID__c = 'A'+i;
            allRegisters.add(reg);
        }
        insert allRegisters;
        
        EON_Job__c job = new EON_Job__c(name='test', Jumbo_job_code__c = 'test', description__c = 'test');
        insert job;
            
        Test.setMock(WebServiceMock.class, new EON_MDS_Elec_Close_Outbound_Job_Test());
        EON_MDS_Elec_Close_Outbound_Job_Test.opName = 'closeElecJob';
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.Job_Code__c = job.ID;
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='1Ph';
        app.Planned_E_Meter_Type__c = 'MS1';
        app.Register_1_TPR_1__c = '11'; 
        app.Register_1_TPR_2__c = '12';
        app.Register_2_TPR_1__c = '21';
        app.Register_2_TPR_2__c = '22';
        app.Register_3_TPR_1__c = '31';
        app.Register_3_TPR_2__c = '32';
        app.Register_4_TPR_1__c = '41';
        app.Register_4_TPR_2__c = '41';
        app.Register_5_TPR_1__c = '51';
        app.Register_5_TPR_2__c = '52';
        app.Register_6_TPR_1__c = '61';
        app.Register_6_TPR_2__c = '62';
        insert app; 
        
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Job_Reference__c =app.id;
        appJobRes.Time_On_Site__c = DateTime.now();
        appJobRes.Electric_SSC_to_be_installed__c= '1122';
        appJobRes.E_Meter_Type__c='MS1'; 
        appJobRes.New_E_Meter_Type__c='MCL';
        appJobRes.E_Meter_Serial_Number__c = 'EMeterSerialNumber';
        appJobRes.New_E_Meter_Serial_Number__c= 'NewMeterSerialNumber';
        appJobRes.E_Meter_Installed__c ='Yes';
        appJobRes.E_Meter_Removed__c='No';
        appJobRes.New_E_Meter_Register_1_ID__c='A0';
        appJobRes.New_E_Meter_Register_2_ID__c='A1';
        appJobRes.New_E_Meter_Register_3_ID__c='A2';
        appJobRes.New_E_Meter_Register_4_ID__c='A3';
        appJobRes.New_E_Meter_Register_5_ID__c='A4';
        appJobRes.New_E_Meter_Register_6_ID__c='A5';
        appJobRes.E_Meter_Register_1_ID__c='A0';
        appJobRes.E_Meter_Register_2_ID__c='A1';
        appJobRes.E_Meter_Register_3_ID__c='A2';
        appJobRes.E_Meter_Register_4_ID__c='A3';
        appJobRes.E_Meter_Register_5_ID__c='A4';
        appJobRes.E_Meter_Register_6_ID__c='A5';
        appJobRes.Elec_Prepay_Meter_Unit_Rate_1__c= 23.5;
        appJobRes.New_Prepayment_Meter_Unit_Rate_1__c = 23.5;
        insert appJobRes;
        
        //Calling close Elec job method method
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.id, false);
    }
    
    /**
        closeElecJobMDS_Test3() - Positive test for EON_MDS_Elec_Close_Outbound_Job
    **/
    static testMethod void closeElecJobMDS_Test3(){
        successFlag=false;
        Test.setMock(WebServiceMock.class, new EON_MDS_Elec_Close_Outbound_Job_Test());
        EON_MDS_Elec_Close_Outbound_Job_Test.opName = 'closeElecJob';
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='3Ph';
        app.Complete_DateTime__c = system.now(); //CH09
        insert app; 
        
        EON_Technician__c tech = new EON_Technician__c();
        tech.Name = 'test';
        tech.Start_Date__c = Date.today();
        insert tech;
        
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Technician__c = tech.ID;
        appJobRes.Job_Reference__c =app.id;
        appJobRes.E_Meter_Removed__c='Yes';
        appJobRes.New_E_Meter_Type__c='MS1';
        appJobRes.E_Meter_Installed__c ='No';
        appJobRes.Electric_SSC_to_be_installed__c = '1122'; //CH09
        appJobRes.Actual_SSC_Installed__c = '1122'; //
        insert appJobRes;
        
        //Calling close Elec job method method
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.id, false);
    }
    
    /**
        closeElecJobMDS_Test4() - Positive test for EON_MDS_Elec_Close_Outbound_Job   //CH10
    **/
    static testMethod void closeElecJobMDS_Test4(){
        successFlag=false;
        Test.setMock(WebServiceMock.class, new EON_MDS_Elec_Close_Outbound_Job_Test());
        EON_MDS_Elec_Close_Outbound_Job_Test.opName = 'closeElecJob';
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='3Ph';
        app.Complete_DateTime__c = system.now();
        insert app; 
        
        EON_Technician__c tech = new EON_Technician__c();
        tech.Name = 'test';
        tech.Start_Date__c = Date.today();
        insert tech;
        
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Technician__c = tech.ID;
        appJobRes.Job_Reference__c =app.id;
        appJobRes.E_Meter_Removed__c='Yes';
        appJobRes.New_E_Meter_Type__c='MS1';
        appJobRes.E_Meter_Installed__c ='No';
        appJobRes.Electric_SSC_to_be_installed__c = '1122';
        insert appJobRes;
        
        //Calling close Elec job method method
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.id, false);
    }
    
     /**
        closeElecJobMDS_Test_Fail() - Negative test for EON_MDS_Elec_Close_Outbound_Job
     **/
    static testMethod void closeElecJobMDS_Test_Fail(){
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='1Ph';
        insert app; 
        //Calling close Elec job method method
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.id, false);
    }
    
    /**
        closeElecJobAbortReason_Pass() - This methos will cover AbortReasonCode() //CH07.New
    **/
    static testmethod void closeElecJobAbortReason_Pass(){
        EON_Jumbo_Abort_Reason_Code__c code = new EON_Jumbo_Abort_Reason_Code__c();
        code.name = 'test';
        code.Electric_Abort_Reason__c = '3';
        insert code;
        string resCode = EON_MDS_Elec_Close_Outbound_Job.AbortReasonCode('test');
        system.assertEquals('3', resCode);
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='1Ph';
        app.Current_SSC__c = '1122';   //CH09
        app.Abort_Datetime__c = system.now(); //CH09
        insert app; 
        
        //CH09.New.Start
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Job_Reference__c =app.id;
        appJobRes.Time_On_Site__c = DateTime.now();
        appJobRes.Electric_SSC_to_be_installed__c= '1122';
        appJobRes.E_Meter_Type__c='MS1'; 
        appJobRes.New_E_Meter_Type__c='MCL';
        appJobRes.E_Meter_Serial_Number__c = 'EMeterSerialNumber';
        appJobRes.New_E_Meter_Serial_Number__c= 'NewMeterSerialNumber';
        appJobRes.E_Meter_Installed__c ='Yes';
        appJobRes.E_Meter_Removed__c='No';
        appJobRes.New_E_Meter_Register_1_ID__c='A0';
        appJobRes.New_E_Meter_Register_2_ID__c='A1';
        appJobRes.New_E_Meter_Register_3_ID__c='A2';
        appJobRes.New_E_Meter_Register_4_ID__c='A3';
        appJobRes.New_E_Meter_Register_5_ID__c='A4';
        appJobRes.New_E_Meter_Register_6_ID__c='A5';
        appJobRes.E_Meter_Register_1_ID__c='A0';
        appJobRes.E_Meter_Register_2_ID__c='A1';
        appJobRes.E_Meter_Register_3_ID__c='A2';
        appJobRes.E_Meter_Register_4_ID__c='A3';
        appJobRes.E_Meter_Register_5_ID__c='A4';
        appJobRes.E_Meter_Register_6_ID__c='A5';
        appJobRes.Abort_Reason__c = 'Pre Visit Customer Refusal';
        insert appJobRes;
        //CH09.New.End
        
        Test.setMock(WebServiceMock.class, new EON_MDS_Elec_Close_Outbound_Job_Test());
        EON_MDS_Elec_Close_Outbound_Job_Test.opName = 'closeElecJobViaTrigger';
        EON_MDS_Elec_Close_Outbound_Job_Test.markerParID = 'EMEB';
        test.startTest();
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.ID, true);
        test.stopTest();
    }
    /**
        closeElecJobAbortReason_Pass1() - This methos will cover with incorrect Market Participant ID //CH07.New
    **/
    static testmethod void closeElecJobAbortReason_Pass1(){
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='1Ph';
        insert app; 
        Test.setMock(WebServiceMock.class, new EON_MDS_Elec_Close_Outbound_Job_Test());
        EON_MDS_Elec_Close_Outbound_Job_Test.opName = 'closeElecJobViaTrigger';
        EON_MDS_Elec_Close_Outbound_Job_Test.markerParID = 'test';
        test.startTest();
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.ID, true);
        test.stopTest();
    }
    /**
        closeElecJobAbortReason_Pass2() - This method will cover positive test  //CH11.New
    **/
    static testmethod void closeElecJobAbortReason_Pass2(){
        EON_Jumbo_Abort_Reason_Code__c code = new EON_Jumbo_Abort_Reason_Code__c();
        code.name = 'test';
        code.Electric_Abort_Reason__c = '3';
        insert code;
        
        EON_Job__c job = new EON_Job__c(name = 'OOAREPOSELEC', Description__c='test');
        insert job;
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='1Ph';
        app.Current_SSC__c = '1122';   
        app.Complete_DateTime__c = system.now(); 
        app.Job_Code__c = job.ID;
        insert app; 
        
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Job_Reference__c =app.id;
        appJobRes.Time_On_Site__c = DateTime.now();
        appJobRes.Electric_SSC_to_be_installed__c= '1122';
        appJobRes.E_Meter_Type__c='MS1'; 
        appJobRes.New_E_Meter_Type__c='MCL';
        appJobRes.E_Meter_Serial_Number__c = 'EMeterSerialNumber';
        appJobRes.New_E_Meter_Serial_Number__c= 'NewMeterSerialNumber';
        appJobRes.E_Meter_Installed__c ='Yes';
        appJobRes.E_Meter_Removed__c='No';
        appJobRes.New_E_Meter_Register_1_ID__c='A0';
        appJobRes.New_E_Meter_Register_2_ID__c='A1';
        appJobRes.New_E_Meter_Register_3_ID__c='A2';
        appJobRes.New_E_Meter_Register_4_ID__c='A3';
        appJobRes.New_E_Meter_Register_5_ID__c='A4';
        appJobRes.New_E_Meter_Register_6_ID__c='A5';
        appJobRes.E_Meter_Register_1_ID__c='A0';
        appJobRes.E_Meter_Register_2_ID__c='A1';
        appJobRes.E_Meter_Register_3_ID__c='A2';
        appJobRes.E_Meter_Register_4_ID__c='A3';
        appJobRes.E_Meter_Register_5_ID__c='A4';
        appJobRes.E_Meter_Register_6_ID__c='A5';
        appJobRes.New_E_Meter_Location__c = 'Indoors';
        insert appJobRes;
        
        Test.setMock(WebServiceMock.class, new EON_MDS_Elec_Close_Outbound_Job_Test());
        EON_MDS_Elec_Close_Outbound_Job_Test.opName = 'closeElecJobViaTrigger';
        EON_MDS_Elec_Close_Outbound_Job_Test.markerParID = 'EMEB';
        test.startTest();
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.ID, true);
        test.stopTest();
    }
    //CH01.Start
    /**
        closeElecJobCheckCode_Pass() - This method will cover populateCheckCode()
    **/
    static testmethod void closeElecJobCheckCode_Pass(){
        EON_Jumbo_Abort_Reason_Code__c code = new EON_Jumbo_Abort_Reason_Code__c();
        code.name = 'test';
        code.Electric_Abort_Reason__c = '3';
        insert code;
        string resCode = EON_MDS_Elec_Close_Outbound_Job.AbortReasonCode('test');
        system.assertEquals('3', resCode);
        
        insert new EON_Check_Code__c(Name='999', Abort_Reason__c = 'Personal Safety',Abort_Sub_Reason__c='Weather',CheckCode__c='57');
        string checkCode = EON_MDS_Elec_Close_Outbound_Job.populateCheckCode('Personal Safety','Weather');
        system.assertEquals('57', checkCode);
        
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPAN__c = 'TEST1234';
        app.JUMBO_ID__c = '12345';
        app.Number_of_Phases__c='1Ph';
        app.Current_SSC__c = '1122';   //CH09
        app.Abort_Datetime__c = system.now(); //CH09
        insert app; 
        
        EON_Job_Results__c appJobRes = new EON_Job_Results__c();
        appJobRes.Job_Reference__c =app.id;
        appJobRes.Time_On_Site__c = DateTime.now();
        appJobRes.Electric_SSC_to_be_installed__c= '1122';
        appJobRes.E_Meter_Type__c='MS1'; 
        appJobRes.New_E_Meter_Type__c='MCL';
        appJobRes.E_Meter_Serial_Number__c = 'EMeterSerialNumber';
        appJobRes.New_E_Meter_Serial_Number__c= 'NewMeterSerialNumber';
        appJobRes.E_Meter_Installed__c ='Yes';
        appJobRes.E_Meter_Removed__c='No';
        appJobRes.New_E_Meter_Register_1_ID__c='A0';
        appJobRes.New_E_Meter_Register_2_ID__c='A1';
        appJobRes.New_E_Meter_Register_3_ID__c='A2';
        appJobRes.New_E_Meter_Register_4_ID__c='A3';
        appJobRes.New_E_Meter_Register_5_ID__c='A4';
        appJobRes.New_E_Meter_Register_6_ID__c='A5';
        appJobRes.E_Meter_Register_1_ID__c='A0';
        appJobRes.E_Meter_Register_2_ID__c='A1';
        appJobRes.E_Meter_Register_3_ID__c='A2';
        appJobRes.E_Meter_Register_4_ID__c='A3';
        appJobRes.E_Meter_Register_5_ID__c='A4';
        appJobRes.E_Meter_Register_6_ID__c='A5';
        appJobRes.Abort_Reason__c = 'Pre Visit Customer Refusal';
        insert appJobRes;
        
        Test.setMock(WebServiceMock.class, new EON_MDS_Elec_Close_Outbound_Job_Test());
        EON_MDS_Elec_Close_Outbound_Job_Test.opName = 'closeElecJobViaTrigger';
        EON_MDS_Elec_Close_Outbound_Job_Test.markerParID = 'EMEB';
        test.startTest();
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.ID, true);
        test.stopTest();
    }
    //CH01.End
}