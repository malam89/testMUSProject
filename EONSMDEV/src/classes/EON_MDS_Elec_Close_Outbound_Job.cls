/**
    Description : This class is invoked through a trigger on ‘EON Appointment’ Object to call a Close Electricity Job Web Service Method in MDS
                  This class functionality is replicated from Apex Class - EON_Jumbo_Elec_Close_Outbound_Job
    Test Class  : EON_MDS_Elec_Close_Outbound_Job_Test
**/
/*
    Created By  : Tabish Almas
    Created On  : 30/01/2019
    Service Req : SR_OptiMUS_EON_297
    Change History
    CH01 # SR_OptiMUS_EON_298 # 05/03/2019 # Tabish Almas # Added logic to populate CheckCode based on condition of Abort Reason and Abort Sub-Reason
    CH02 # SR_OptiMUS_EON_315 # 20/03/2019 # Tabish Almas # Added logic to pass null when StandingCharge, TotalDebtOutstanding, TotalCreditAccepted values are not available.
    
*/

public with sharing class EON_MDS_Elec_Close_Outbound_Job {

    /**
    closeElecJobMDS(String appId) -  Method to close Elec Job
    **/
    @future (callout=true)
    public static void closeElecJobMDS(String appId, boolean callMOP){
        EON_MDS_OAuth_Authentication.AuthDetail authToken;
        boolean callMDSWS = true; 
        list<MDS_Data_Tracker__c> allTracker = new list<MDS_Data_Tracker__c>(); 
        string tranID = EON_Utility.GenUniqueNum(); //generating random Unique number for transaction ID
        MDS_Data_Tracker__c tracker = new MDS_Data_Tracker__c();
        EON_Appointment__c apptIns = new EON_Appointment__c();
        list<EON_SSC__c> allEonSsc = new list<EON_SSC__c>(); 
        list<EON_SSC_Register__c> classicRegister = new list<EON_SSC_Register__c>();
        list<EON_SSC_Register__c> allEonSscRegister = new list<EON_SSC_Register__c>();
        boolean ClassicAtSmart = false; 
        EON_Job_Results__c InsJobRes = new EON_Job_Results__c();
        Id appointmentID = Id.valueOf(appId);
        string oldAssetReadingType='';
        string NewAssetReadingType='';
        string OldRegisterRemoved ='';
        string NewRegisterRemoved ='';
        string tariffCode = '';
        boolean OldAssetFlag = false;
        boolean NewAssetFlag = false;
        tracker.Direction__c = EON_Utility.DIRECTION_OUT ;
        tracker.Command__c = EON_MDS_Utility.CMD_Close_ElecMDS;
        tracker.Transaction_ID__c = tranID;
        tracker.EON_Appointment__c=appointmentID;
        try{
            apptIns = [select id, GSP_Group_ID__c, Name, MPAN__c,JUMBO_ID__c,Number_of_Phases__c, Planned_E_Meter_Type__c, Register_1_TPR_1__c, Register_1_TPR_2__c, Register_2_TPR_1__c, Register_2_TPR_2__c, h_Job_Code__c, //TODO: Replace Jumbo in here?
                    Register_3_TPR_1__c, Register_3_TPR_2__c, Register_4_TPR_1__c, Register_4_TPR_2__c, Register_5_TPR_1__c, Register_5_TPR_2__c, Register_6_TPR_1__c, Register_6_TPR_2__c,
                    Current_SSC__c, Status__c, Job_Code__c, Job_Code__r.Jumbo_Job_Code__c, (select id,Name,Time_On_Site__c,Time_Closed__c,Reason_for_not_taking_Elec_Reading__c, h_Reason_for_not_taking_Elec_Reading__c,Original_E_Meter_refitted__c,
                    Abort_Reason__c,Work_Completed__c,Ending_Energisation_Status__c,Electric_SSC_to_be_installed__c,E_Meter_Type__c,New_E_Meter_Type__c,DNO_Safe_to_Continue__c,
                    E_Meter_Serial_Number__c,New_E_Meter_Serial_Number__c,E_Meter_Manufacturer_version__c,New_E_Meter_Manufacturer__c,New_E_Meter_Version__c,
                    New_E_Meter_Location__c,E_Meter_Location__c,E_Meter_Certification_Date__c,E_Meter_Installed__c,Elec_Prepay_Meter_Balance__c,
                    Elec_Prepay_Meter_Total_Debt__c,Elec_Prepay_Debt_Recovery_Rate__c,Elec_Prepay_Meter_Weekly_Charge__c,E_Meter_Removed__c,E_Meter_Register_1_ID__c,
                    E_Meter_Register_2_ID__c,E_Meter_Register_3_ID__c,E_Meter_Register_4_ID__c,E_Meter_Register_5_ID__c,E_Meter_Register_6_ID__c,
                    New_E_Meter_Register_1_ID__c,New_E_Meter_Register_2_ID__c,New_E_Meter_Register_3_ID__c,New_E_Meter_Register_4_ID__c,New_E_Meter_Register_5_ID__c,
                    New_E_Meter_Register_6_ID__c,E_Meter_Register_1_Read__c,E_Meter_Register_2_Read__c,E_Meter_Register_3_Read__c,E_Meter_Register_4_Read__c,
                    E_Meter_Register_5_Read__c,E_Meter_Register_6_Read__c,New_E_Meter_Register_1_Reading__c,New_E_Meter_Register_2_Reading__c,New_E_Meter_Register_3_Reading__c,
                    New_E_Meter_Register_4_Reading__c,New_E_Meter_Register_5_Reading__c,New_E_Meter_Register_6_Reading__c,New_E_Meter_Register_1_dials_digits__c,
                    New_E_Meter_Register_2_dials_digits__c,New_E_Meter_Register_3_dials_digits__c,New_E_Meter_Register_4_dials_digits__c,New_E_Meter_Register_5_dials_digits__c,
                    New_E_Meter_Register_6_dials_digits__c, Elec_Prepay_Meter_Emergency_Credit__c, Weekly_Debt_Repayment__c, Emergency_Credit__c, Total_Debt__c,
                    New_Prepayment_Meter_Unit_Rate_1__c, New_Prepayment_Meter_Unit_Rate_2__c, New_Prepayment_Meter_Unit_Rate_3__c, New_Prepayment_Meter_Unit_Rate_4__c,
                    New_Prepayment_Meter_Unit_Rate_5__c, New_Prepayment_Meter_Unit_Rate_6__c, Initial_Credit__c, Actual_SSC_Installed__c, Pre_Work_DNO_Defect_Details__c,  
                    Elec_Prepay_Meter_Unit_Rate_1__c, Elec_Prepay_Meter_Unit_Rate_2__c, Elec_Prepay_Meter_Unit_Rate_3__c, Elec_Prepay_Meter_Unit_Rate_4__c, Elec_Prepay_Meter_Unit_Rate_5__c,
                    Elec_Prepay_Meter_Unit_Rate_6__c, Elec_Prepay_Meter_Total_Credit_Accepted__c, Elec_Prepay_Meter_Total_Debt_Outstanding__c,
                    New_Prepay_Meter_Standing_Charge__c, New_Prepay_Meter_Total_Debt_Oustanding__c, New_Prepay_Meter_Total_Credit_Accepted__c , Pre_Work_DNO_Situation__c, Pre_Work_DNO_Electric_Reference_Number__c, 
                    DNO_Electric_Reference_Number__c,DNO_Defect_Details__c
                    , h_Abort_Reason__c,G_Meter_Installed__c,New_G_Meter_Type__c,Original_G_Meter_refitted__c,Abort_Sub_Reason__c,h_Abort_Sub_Reason__c //CH01
                    from EON_Job_Results__r) from EON_Appointment__c where id=:appointmentID limit 1]; 
            
             //BasicHttpsBinding_IWorkManagement - Instantiating main method                     
            EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement MDSObj = new EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement();
            authToken = EON_MDS_OAuth_Authentication.genAccessToken();
            MDSObj.inputHttpHeaders_x = new Map<String, String>();
            MDSObj.inputHttpHeaders_x.put('Authorization','Bearer ' + authToken.accessToken);
            //JumboTechnicalResponse - Instantiating response object //TODO: Replace JumboTechnicalResponse?
            EON_MDS_Work_Management_WS.JumboTechnicalResponse respMDS = new EON_MDS_Work_Management_WS.JumboTechnicalResponse();
            //ClientData Instantiating clientData
            EON_MDS_Work_Management_WS.ClientData clientInfo = new EON_MDS_Work_Management_WS.ClientData();
            ClientInfo.Id =system.label.EON_MDS_Client_Id;
            ClientInfo.Name =system.label.EON_MDS_Client_Name;
           
            //Instantiating main request Object for Close Electricity Job
            EON_MDS_Work_Management_WS.CloseElecWorkRequest reqCloseElecWorkObj = new EON_MDS_Work_Management_WS.CloseElecWorkRequest();
            reqCloseElecWorkObj.Client=clientInfo;
            reqCloseElecWorkObj.UniqueId = tranID;
                
            //CloseElecWork - Instantiating Object for CloseElecWork
            EON_MDS_Work_Management_WS.CloseElecWork CloseElecWorkObj = new EON_MDS_Work_Management_WS.CloseElecWork();
            //ElecSupply - Instantiating Object for ElecSupply
            EON_MDS_Work_Management_WS.ElecSupply ElecSupplyObj = new EON_MDS_Work_Management_WS.ElecSupply();
            //SiteVisit - Instantiating Object for SiteVisit
            EON_MDS_Work_Management_WS.ElecSiteVisit SiteVisitObj = new EON_MDS_Work_Management_WS.ElecSiteVisit();
            
            //CloseElecMeter - Instantiating Object for Old Assets
            EON_MDS_Work_Management_WS.CloseElecMeter OldAssetsObj = new EON_MDS_Work_Management_WS.CloseElecMeter();
            //CloseElecMeter - Instantiating Object for New Assets
            EON_MDS_Work_Management_WS.CloseElecMeter NewAssetsObj = new EON_MDS_Work_Management_WS.CloseElecMeter();
           
            //ArrayOfElecRegister - Array to populate all Close Elec Meters 
            EON_MDS_Work_Management_WS.ArrayOfCloseElecMeter ArrayElecMeter  = new EON_MDS_Work_Management_WS.ArrayOfCloseElecMeter();
            List<EON_MDS_Work_Management_WS.CloseElecMeter> ListElecMeter= new List<EON_MDS_Work_Management_WS.CloseElecMeter>();
           
            //ArrayOfElecRegister - Array to populate all Registers for Old Assets
            EON_MDS_Work_Management_WS.ArrayOfCloseElecRegister ArrayOldAssetRegister  = new  EON_MDS_Work_Management_WS.ArrayOfCloseElecRegister();
            List<EON_MDS_Work_Management_WS.CloseElecRegister> listOldAssetRegister = new List<EON_MDS_Work_Management_WS.CloseElecRegister>();
            
            //ArrayOfElecRegister - Array to populate all Registers for New Asset
            EON_MDS_Work_Management_WS.ArrayOfCloseElecRegister ArrayNewAssetRegister  = new  EON_MDS_Work_Management_WS.ArrayOfCloseElecRegister();
            List<EON_MDS_Work_Management_WS.CloseElecRegister> listNewAssetRegister = new List<EON_MDS_Work_Management_WS.CloseElecRegister>();
            
            //CloseElecRegister - Instantiating Registers for Old Assets
            EON_MDS_Work_Management_WS.CloseElecRegister  OldAssetRegister1  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  OldAssetRegister2  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  OldAssetRegister3  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  OldAssetRegister4  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  OldAssetRegister5  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  OldAssetRegister6  = new EON_MDS_Work_Management_WS.CloseElecRegister();
           
            //CloseElecRegister  - Instantiating Registers for New Asset
            EON_MDS_Work_Management_WS.CloseElecRegister  NewAssetRegister1  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  NewAssetRegister2  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  NewAssetRegister3  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  NewAssetRegister4  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  NewAssetRegister5  = new EON_MDS_Work_Management_WS.CloseElecRegister();
            EON_MDS_Work_Management_WS.CloseElecRegister  NewAssetRegister6  = new EON_MDS_Work_Management_WS.CloseElecRegister();
                
            //ElecRegisterReading - Instantiating Reading for Old Asset
            EON_MDS_Work_Management_WS.ElecRegisterReading OldAssetReading1  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading OldAssetReading2  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading OldAssetReading3  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading OldAssetReading4  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading OldAssetReading5  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading OldAssetReading6  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
           
            //ElecRegisterReading - Instantiating Reading for New Asset
            EON_MDS_Work_Management_WS.ElecRegisterReading NewAssetReading1  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading NewAssetReading2  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading NewAssetReading3  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading NewAssetReading4  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading NewAssetReading5  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
            EON_MDS_Work_Management_WS.ElecRegisterReading NewAssetReading6  = new EON_MDS_Work_Management_WS.ElecRegisterReading();
           
            //TimePatternRegime - Instantiating TimePatternRegime for New Asset
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime NewListTimePatternRegime1 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime NewListTimePatternRegime2 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime NewListTimePatternRegime3 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime NewListTimePatternRegime4 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime NewListTimePatternRegime5 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime NewListTimePatternRegime6 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllNewTimePatternRegime1 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            NewListTimePatternRegime1.TimePatternRegime = AllNewTimePatternRegime1;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllNewTimePatternRegime2 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            NewListTimePatternRegime2.TimePatternRegime = AllNewTimePatternRegime2;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllNewTimePatternRegime3 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            NewListTimePatternRegime3.TimePatternRegime = AllNewTimePatternRegime3;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllNewTimePatternRegime4 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            NewListTimePatternRegime4.TimePatternRegime = AllNewTimePatternRegime4;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllNewTimePatternRegime5 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            NewListTimePatternRegime5.TimePatternRegime = AllNewTimePatternRegime5;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllNewTimePatternRegime6 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            NewListTimePatternRegime6.TimePatternRegime = AllNewTimePatternRegime6;
            
            //TimePatternRegime - Instantiating TimePatternRegime for New Asset
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime OldListTimePatternRegime1 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime OldListTimePatternRegime2 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime OldListTimePatternRegime3 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime oldListTimePatternRegime4 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime oldListTimePatternRegime5 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime OldListTimePatternRegime6 = new EON_MDS_Work_Management_WS.ArrayOfTimePatternRegime();
            
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllOldTimePatternRegime1 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            OldListTimePatternRegime1.TimePatternRegime = AllOldTimePatternRegime1;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllOldTimePatternRegime2 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            OldListTimePatternRegime2.TimePatternRegime = AllOldTimePatternRegime2;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllOldTimePatternRegime3 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            OldListTimePatternRegime3.TimePatternRegime = AllOldTimePatternRegime3;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllOldTimePatternRegime4 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            OldListTimePatternRegime4.TimePatternRegime = AllOldTimePatternRegime4;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllOldTimePatternRegime5 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            OldListTimePatternRegime5.TimePatternRegime = AllOldTimePatternRegime5;
            list<EON_MDS_Work_Management_WS.TimePatternRegime> AllOldTimePatternRegime6 = new list<EON_MDS_Work_Management_WS.TimePatternRegime>();
            OldListTimePatternRegime6.TimePatternRegime = AllOldTimePatternRegime6;
            
            //MPAN 
            if(!EON_Utility.validateRequired(apptIns.MPAN__c)){
                CloseElecWorkObj.MPAN = apptIns.MPAN__c;
                if(callMOP){
                    EON_MDS_ReqElectricityMOP.MOPValidationResponse mopRes = EON_MDS_ReqElectricityMOP.ValidateMPANMOP(apptIns.MPAN__c);
                    if(!EON_Utility.validateRequired(EON_MDS_ReqElectricityMOP.cTrack)){
                        MDS_Data_Tracker__c mopTracker = EON_MDS_ReqElectricityMOP.cTrack;
                        mopTracker.EON_Appointment__c = apptIns.ID;
                        allTracker.add(mopTracker);
                    }
                    if(mopRes.isError)
                        callMDSWS = false;
                }
            }
            
            //MDSId     //TODO: Replace JumboId?
            if(!EON_Utility.validateRequired(apptIns.JUMBO_ID__c))
                CloseElecWorkObj.JumboId = apptIns.JUMBO_ID__c;
             
            //ExternalJobReference   
            if(!EON_Utility.validateRequired(apptIns.Name))
                CloseElecWorkObj.ExternalJobReference = apptIns.Name;
                
            //MDSJobType
            if(!EON_Utility.validateRequired(apptIns.Job_Code__c)){
                if(!EON_Utility.validateRequired(apptIns.Job_Code__r.Jumbo_Job_Code__c))
                    CloseElecWorkObj.JumboJobType = apptIns.Job_Code__r.Jumbo_Job_Code__c;  //TODO: Replace JumboJobType and Job_Code__c
            }
            
            if(!apptIns.EON_Job_Results__r.isEmpty()){
                InsJobRes =  apptIns.EON_Job_Results__r[0];
                //Mapping Job Result values
                boolean E_StatusTosend=false;
                if(InsJobRes.New_E_Meter_Type__c=='MS1' && InsJobRes.E_Meter_Installed__c=='Yes' && InsJobRes.Original_E_Meter_refitted__c=='No') E_StatusTosend=true;
                if(!EON_Utility.validateRequired(InsJobRes.Time_On_Site__c))
                    CloseElecWorkObj.DateFaultDetected = EON_MDS_Utility.DateToString(InsJobRes.Time_On_Site__c.date());
                
                //TariffCode
                if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Type__c)){
                    if(InsJobRes.New_E_Meter_Type__c.equalsIgnoreCase('Key')){
                        if(!EON_Utility.validateRequired(InsJobRes.Electric_SSC_to_be_installed__c)){
                            if(!EON_Utility.validateRequired(apptIns.GSP_Group_ID__c)){
                                list<EON_SSC_Group__c> sscgroup = new list<EON_SSC_Group__c>();
                                sscgroup = [SELECT  Tariff_Code__c from EON_SSC_Group__c where  SSC__r.name = : InsJobRes.Electric_SSC_to_be_installed__c and Group__r.name =:apptIns.GSP_Group_ID__c];//CH3                           
                                if(!sscgroup.isEmpty())
                                  tariffCode = !EON_Utility.validateRequired(sscgroup[0].Tariff_Code__c) ? sscgroup[0].Tariff_Code__c : null;
                                CloseElecWorkObj.TariffCode = tariffCode; //TariffCode
                            }                           
                        }
                    }
                }
                
                if(!EON_Utility.validateRequired(DnoInfo(apptIns.Status__c,InsJobRes))){
                    string DNODetails = DnoInfo(apptIns.Status__c,InsJobRes);
                    if(DNODetails=='PreDNO'){
                        if(!EON_Utility.validateRequired(InsJobRes.Pre_Work_DNO_Electric_Reference_Number__c))
                            CloseElecWorkObj.SafetyProblem = InsJobRes.Pre_Work_DNO_Electric_Reference_Number__c;
                        CloseElecWorkObj.AssetCondition = InsJobRes.Pre_Work_DNO_Defect_Details__c.substring(0, 3);
                    }
                    if(DNODetails=='PostDNO'){
                        if(!EON_Utility.validateRequired(InsJobRes.DNO_Electric_Reference_Number__c))
                            CloseElecWorkObj.SafetyProblem = InsJobRes.DNO_Electric_Reference_Number__c;
                        CloseElecWorkObj.AssetCondition = InsJobRes.DNO_Defect_Details__c.substring(0, 3);
                    }
                }
                
                //StartDate 
                if(!EON_Utility.validateRequired(InsJobRes.Time_On_Site__c))
                    SiteVisitObj.StartDate = EON_MDS_Utility.DateToString(InsJobRes.Time_On_Site__c.date());
                 
                //StartTime  
                if(!EON_Utility.validateRequired(InsJobRes.Time_On_Site__c))
                    SiteVisitObj.StartTime = InsJobRes.Time_On_Site__c.format('HHmmss'); //Sending time in HHMMSS format
                   
                //EndDate   
                if(!EON_Utility.validateRequired(InsJobRes.Time_Closed__c))
                    SiteVisitObj.EndDate = EON_MDS_Utility.DateToString(InsJobRes.Time_Closed__c.date());
                   
                //EndTime   
                if(!EON_Utility.validateRequired(InsJobRes.Time_Closed__c))
                    SiteVisitObj.EndTime = InsJobRes.Time_Closed__c.format('HHmmss'); //Sending time in HHMMSS format
                   
                //CheckCode
                //CH01.Start
                if(!EON_Utility.validateRequired(InsJobRes.Abort_Reason__c)) {
                    SiteVisitObj.CheckCode = populateCheckCode(InsJobRes.Abort_Reason__c, InsJobRes.Abort_Sub_Reason__c);
                    //System.debug('#####Checkcode: '+SiteVisitObj.CheckCode);
                }
                /*
                if(!EON_Utility.validateRequired(InsJobRes.Reason_for_not_taking_Elec_Reading__c))
                    SiteVisitObj.CheckCode = (InsJobRes.Reason_for_not_taking_Elec_Reading__c == 'Equipment/Meter Damaged' ? '05' : InsJobRes.Reason_for_not_taking_Elec_Reading__c == 'Phase/Fuse Failure' ? '08' : InsJobRes.Reason_for_not_taking_Elec_Reading__c == 'Suspected Tampering' ? '06' : ''); 
                */
                //CH01.End
                
                //ReasonNotResolved
                if(!EON_Utility.validateRequired(InsJobRes.Abort_Reason__c)){
                    //CloseElecWorkObj.ReasonNotResolved = AbortReasonCode(InsJobRes.Abort_Reason__c);
                    //CloseElecWorkObj.ReasonNotResolved = InsJobRes.Abort_Reason__c;
                    if(apptIns.Status__c=='ABORTED' && E_StatusTosend==false){
                        if(InsJobRes.Original_E_Meter_refitted__c != 'Yes' && InsJobRes.E_Meter_Installed__c != 'Yes' && !(InsJobRes.h_Abort_Reason__c.equalsIgnorecase('True')))
                            CloseElecWorkObj.ReasonNotResolved = AbortReasonCode(InsJobRes.Abort_Reason__c); 
                        if(InsJobRes.Original_E_Meter_refitted__c == 'Yes')
                            CloseElecWorkObj.ReasonNotResolved = AbortReasonCode(InsJobRes.Abort_Reason__c);
                        //CloseElecWorkObj.ReasonNotResolved = InsJobRes.Abort_Reason__c;
                    }
                }
                
                //AdditionalInformation   
                if(!EON_Utility.validateRequired(InsJobRes.Work_Completed__c))
                   CloseElecWorkObj.AdditionalInformation = InsJobRes.Work_Completed__c;
                
                if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Installed__c)){
                    if(InsJobRes.Original_E_Meter_refitted__c == 'Yes' || InsJobRes.E_Meter_Installed__c.equalsIgnorecase('No'))//CH31
                        CloseElecWorkObj.SSC = !EON_Utility.validateRequired(apptIns.Current_SSC__c) ? apptIns.Current_SSC__c : '';
                    if(InsJobRes.Original_E_Meter_refitted__c != 'Yes' && InsJobRes.E_Meter_Installed__c.equalsIgnorecase('Yes'))//CH29
                        CloseElecWorkObj.SSC = !EON_Utility.validateRequired(InsJobRes.Actual_SSC_Installed__c) ? InsJobRes.Actual_SSC_Installed__c : (!EON_Utility.validateRequired(InsJobRes.Electric_SSC_to_be_installed__c) ? InsJobRes.Electric_SSC_to_be_installed__c : '');
                }
                
                if(!EON_Utility.validateRequired(InsJobRes.Actual_SSC_Installed__c))
                    allEonSsc = new list<EON_SSC__c>([Select ID, Name, Type__c, (Select ID, TPR__c, Register_ID__c,S1_Register_ID__c from EON_SSC_Registers__r) from EON_SSC__c where name=:InsJobRes.Actual_SSC_Installed__c]);  //CH15.New
                else if(!EON_Utility.validateRequired(InsJobRes.Electric_SSC_to_be_installed__c))
                    allEonSsc = new list<EON_SSC__c>([Select ID, Name, Type__c, (Select ID, TPR__c, Register_ID__c,S1_Register_ID__c from EON_SSC_Registers__r) from EON_SSC__c where name=:InsJobRes.Electric_SSC_to_be_installed__c]);  //CH15.New
                if(!allEonSsc.isEmpty()){
                    for(EON_SSC__c ssc:allEonSsc){
                        if(!EON_Utility.validateRequired(ssc.EON_SSC_Registers__r)){
                            if(!ssc.EON_SSC_Registers__r.isEmpty())
                                allEonSscRegister.addAll(ssc.EON_SSC_Registers__r);
                        }
                    }
                }
                
                //EnergisationStatus   
                if(!EON_Utility.validateRequired(InsJobRes.Ending_Energisation_Status__c))
                   if(!EON_Utility.validateRequired(EnergStatus(InsJobRes.Ending_Energisation_Status__c)))
                      ElecSupplyObj.EnergisationStatus = EnergStatus(InsJobRes.Ending_Energisation_Status__c);
                
                //Phases  
                ElecSupplyObj.Phases = (apptIns.Status__c.equalsIgnoreCase('Aborted') && E_StatusTosend==false) ? null : (!EON_Utility.validateRequired(apptIns.Number_of_Phases__c) ? (apptIns.Number_of_Phases__c.equalsIgnoreCase('3ph') ? '3' : '1') : null);
                           
                //SmartMeterInstallation   
                if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Type__c))
                  if(InsJobRes.New_E_Meter_Type__c=='MS1')
                    CloseElecWorkObj.SmartMeterInstallation = 'T';
                     else 
                       CloseElecWorkObj.SmartMeterInstallation = 'F';
                 
                //AssetConditionReportDate  
                if(!EON_Utility.validateRequired(InsJobRes.Time_On_Site__c) && !EON_Utility.validateRequired(InsJobRes.DNO_Safe_to_Continue__c))
                   if(InsJobRes.DNO_Safe_to_Continue__c=='Yes')
                       CloseElecWorkObj.AssetConditionReportDate = EON_MDS_Utility.DateToString(InsJobRes.Time_On_Site__c.date());
              
                //Meters - Populating old and new Meter Information     
                //RetrievalMethod
                OldAssetsObj.RetrievalMethod = (apptIns.Status__c.equalsIgnoreCase('Aborted')  && E_StatusTosend==false) ? null : (!EON_Utility.validateRequired(InsJobRes.E_Meter_Type__c) ? (InsJobRes.E_Meter_Type__c.equalsIgnoreCase('MS1') ? 'R' : 'H') : 'H');
                NewAssetsObj.RetrievalMethod =( apptIns.Status__c.equalsIgnoreCase('Aborted') && E_StatusTosend==false)  ? null : (!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Type__c) ? (InsJobRes.New_E_Meter_Type__c.equalsIgnoreCase('MS1') ? 'R' : 'H') : 'H');
                
                //TotalCreditAccepted
                if(apptIns.Status__c.equalsIgnoreCase('Completed') || E_StatusTosend){
                    //CH02.Start
                    //OldAssetsObj.TotalCreditAccepted = !EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Total_Credit_Accepted__c) ? String.valueOf(InsJobRes.Elec_Prepay_Meter_Total_Credit_Accepted__c) : '';
                    //NewAssetsObj.TotalCreditAccepted = !EON_Utility.validateRequired(InsJobRes.New_Prepay_Meter_Total_Credit_Accepted__c) ? String.valueOf(InsJobRes.New_Prepay_Meter_Total_Credit_Accepted__c) : '';
                    if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Total_Credit_Accepted__c))
                        OldAssetsObj.TotalCreditAccepted = String.valueOf(InsJobRes.Elec_Prepay_Meter_Total_Credit_Accepted__c);
                    if(!EON_Utility.validateRequired(InsJobRes.New_Prepay_Meter_Total_Credit_Accepted__c))
                        NewAssetsObj.TotalCreditAccepted = String.valueOf(InsJobRes.New_Prepay_Meter_Total_Credit_Accepted__c);
                    //CH02.End
                }
                
                //SerialNumber
                if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Serial_Number__c)){
                    OldAssetsObj.SerialNumber = InsJobRes.E_Meter_Serial_Number__c;
                    OldAssetFlag = true;
                }
                if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Serial_Number__c))
                    NewAssetsObj.SerialNumber = InsJobRes.New_E_Meter_Serial_Number__c;
                    //NewAssetFlag = true;
                
                if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Installed__c))
                    if(InsJobRes.Original_E_Meter_refitted__c != 'Yes' && InsJobRes.E_Meter_Installed__c == 'Yes')
                        NewAssetFlag = true;
                
                //MainOrCheck 
                NewAssetsObj.MainOrCheck = 'T';
                 
                //ManufacturerAndModel   
                if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Manufacturer_version__c))  
                    OldAssetsObj.ManufacturerAndModel = InsJobRes.E_Meter_Manufacturer_version__c;  
                if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Manufacturer__c))  
                    NewAssetsObj.ManufacturerAndModel = InsJobRes.New_E_Meter_Manufacturer__c+'\n';    
                if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Version__c))  
                    NewAssetsObj.ManufacturerAndModel = NewAssetsObj.ManufacturerAndModel+InsJobRes.New_E_Meter_Version__c;  
                    
                //Location
                if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Location__c)){  
                    if(!EON_Utility.validateRequired(MapLocationCode(InsJobRes.E_Meter_Location__c))){
                        if(!EON_Utility.validateRequired(apptIns.Status__c)){
                            if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || E_StatusTosend)
                                OldAssetsObj.Location = MapLocationCode(InsJobRes.E_Meter_Location__c); 
                        }
                    }
                }

                if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Location__c) && !EON_Utility.validateRequired(MapLocationCode(InsJobRes.New_E_Meter_Location__c)) && !EON_Utility.validateRequired(apptIns.h_Job_Code__c) && (apptIns.h_Job_Code__c.containsignorecase('OOAREPOSELEC') || apptIns.h_Job_Code__c.containsignorecase('OOAREPOSGAS'))){
                    if(!EON_Utility.validateRequired(apptIns.Status__c)){
                        if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || E_StatusTosend)
                            OldAssetsObj.Location = MapLocationCode(InsJobRes.New_E_Meter_Location__c);
                    }
                }

                if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Location__c)){
                    if(!EON_Utility.validateRequired(MapLocationCode(InsJobRes.New_E_Meter_Location__c))){
                        if(!EON_Utility.validateRequired(apptIns.Status__c)){
                            if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || E_StatusTosend)
                                NewAssetsObj.Location = MapLocationCode(InsJobRes.New_E_Meter_Location__c);
                        }
                    }
                }  
                
                //CertificationDate    
                if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Certification_Date__c))  
                    OldAssetsObj.CertificationDate = InsJobRes.E_Meter_Certification_Date__c;
                //    OldAssetsObj.CertificationDate = EON_MDS_Utility.DateToString(InsJobRes.E_Meter_Certification_Date__c);
                 
                //Type_x
                if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Type__c))
                   if(!EON_Utility.validateRequired(IndCodeMeterType(InsJobRes.E_Meter_Type__c)))
                          OldAssetsObj.Type_x = IndCodeMeterType(InsJobRes.E_Meter_Type__c);
                if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Type__c))
                   if(!EON_Utility.validateRequired(EON_Utility.smartMeterModel('Electric',InsJobRes.New_E_Meter_Type__c,InsJobRes.New_E_Meter_Manufacturer__c,InsJobRes.New_E_Meter_Version__c)))
                      NewAssetsObj.Type_x = EON_Utility.smartMeterModel('Electric',InsJobRes.New_E_Meter_Type__c,InsJobRes.New_E_Meter_Manufacturer__c,InsJobRes.New_E_Meter_Version__c);
                
                //DebtRecoveryRate
                if(!EON_Utility.validateRequired(InsJobRes.Weekly_Debt_Repayment__c))
                    NewAssetsObj.DebtRecoveryRate = string.ValueOf(InsJobRes.Weekly_Debt_Repayment__c);
                
                //EmergencyCredit
                if(!EON_Utility.validateRequired(InsJobRes.Emergency_Credit__c))
                    NewAssetsObj.EmergencyCredit = string.ValueOf(InsJobRes.Emergency_Credit__c);
                
                //TotalDebt
                if(!EON_Utility.validateRequired(InsJobRes.Total_Debt__c))
                    NewAssetsObj.TotalDebt = string.ValueOf(InsJobRes.Total_Debt__c);
                
                //StandingCharge
                //CH02.Start
                //NewAssetsObj.StandingCharge = (apptIns.Status__c.equalsIgnoreCase('Completed') || E_StatusTosend)? (!EON_Utility.validateRequired(InsJobRes.New_Prepay_Meter_Standing_Charge__c) ? String.valueOf(InsJobRes.New_Prepay_Meter_Standing_Charge__c) : '') : '';
                if(apptIns.Status__c.equalsIgnoreCase('Completed') || E_StatusTosend )
                    if(!EON_Utility.validateRequired(InsJobRes.New_Prepay_Meter_Standing_Charge__c))
                        NewAssetsObj.StandingCharge = String.valueOf(InsJobRes.New_Prepay_Meter_Standing_Charge__c);
                //CH02.End
                
                //InitialCredit
                if(!EON_Utility.validateRequired(InsJobRes.Initial_Credit__c)){
                    NewAssetsObj.InitialCredit = string.ValueOf(InsJobRes.Initial_Credit__c);
                    if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Type__c)){
                        if(InsJobRes.New_E_Meter_Type__c.equalsIgnoreCase('Key'))
                            NewAssetsObj.InitialCredit = '10.00';
                    }                 
                }
                
                //CreditBalance
                OldAssetsObj.CreditBalance = (apptIns.Status__c.equalsIgnoreCase('Completed') || E_StatusTosend)? (!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Balance__c) ? String.valueOf(InsJobRes.Elec_Prepay_Meter_Balance__c) : '10.00') : '';
                NewAssetsObj.CreditBalance = (apptIns.Status__c.equalsIgnoreCase('Completed')  || E_StatusTosend) ? (!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Balance__c) ? String.valueOf(InsJobRes.Elec_Prepay_Meter_Balance__c) : '10.00') : '';
                    
                //TotalDebtOutstanding
                //CH02.Start
                //OldAssetsObj.TotalDebtOutstanding = (apptIns.Status__c.equalsIgnoreCase('Completed') || E_StatusTosend)? (!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Total_Debt_Outstanding__c) ? String.valueOf(InsJobRes.Elec_Prepay_Meter_Total_Debt_Outstanding__c) : '') : '';
                //NewAssetsObj.TotalDebtOutstanding = (apptIns.Status__c.equalsIgnoreCase('Completed') || E_StatusTosend)? (!EON_Utility.validateRequired(InsJobRes.New_Prepay_Meter_Total_Debt_Oustanding__c) ? String.valueOf(InsJobRes.New_Prepay_Meter_Total_Debt_Oustanding__c) : '') : '';
                if((apptIns.Status__c.equalsIgnoreCase('Completed') || E_StatusTosend)) {
                    if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Total_Debt_Outstanding__c))
                        OldAssetsObj.TotalDebtOutstanding = String.valueOf(InsJobRes.Elec_Prepay_Meter_Total_Debt_Outstanding__c);
                    if(!EON_Utility.validateRequired(InsJobRes.New_Prepay_Meter_Total_Debt_Oustanding__c))
                        NewAssetsObj.TotalDebtOutstanding = String.valueOf(InsJobRes.New_Prepay_Meter_Total_Debt_Oustanding__c);
                }
                //CH02.End
                
                //TotalDebt   
                if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Total_Debt__c)){  
                    //OldAssetsObj.TotalDebtOutstanding = string.ValueOf(InsJobRes.Elec_Prepay_Meter_Total_Debt__c);
                    OldAssetsObj.TotalDebt = string.ValueOf(InsJobRes.Elec_Prepay_Meter_Total_Debt__c);
                }
                
                //EmergencyCredit
                if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Emergency_Credit__c))  
                    OldAssetsObj.EmergencyCredit = string.ValueOf(InsJobRes.Elec_Prepay_Meter_Emergency_Credit__c);
                
                //DebtRecoveryRate
                if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Debt_Recovery_Rate__c))  
                    OldAssetsObj.DebtRecoveryRate = string.ValueOf(InsJobRes.Elec_Prepay_Debt_Recovery_Rate__c);
                    
                //StandingCharge
                if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Weekly_Charge__c)) 
                    OldAssetsObj.StandingCharge = string.ValueOf(InsJobRes.Elec_Prepay_Meter_Weekly_Charge__c);
                    
                //Removed   
                NewAssetsObj.Removed='N'; 
                NewRegisterRemoved='N';
                if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Removed__c)){ 
                    if(InsJobRes.Original_E_Meter_refitted__c != 'Yes' && InsJobRes.E_Meter_Removed__c=='Yes'){
                        OldAssetsObj.Removed = 'Y';
                        oldAssetReadingType='F';
                        OldRegisterRemoved ='Y';
                    }
                    if(InsJobRes.Original_E_Meter_refitted__c == 'Yes' || InsJobRes.E_Meter_Removed__c=='No'){
                        OldAssetsObj.Removed = 'N';
                        oldAssetReadingType='R';
                        OldRegisterRemoved ='N';
                    }
                }
                
                //NewAssetReadingType   
                if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Installed__c))
                   if(InsJobRes.Original_E_Meter_refitted__c != 'Yes' && InsJobRes.E_Meter_Installed__c=='Yes')
                       NewAssetReadingType='I';

                if(!EON_Utility.validateRequired(apptIns.Planned_E_Meter_Type__c)){
                    if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Type__c)){
                        if(!EON_Utility.validateRequired(InsJobRes.Electric_SSC_to_be_installed__c)){
                            if(!allEonSsc.isEmpty()){
                                EON_SSC__c classicSSC = new EON_SSC__c();
                                for(EON_SSC__c ssc:allEonSsc){
                                    if(ssc.Type__c == 'Classic'){
                                        if(apptIns.Planned_E_Meter_Type__c == 'MS1' && InsJobRes.New_E_Meter_Type__c == 'MCL'){
                                            classicSSC = ssc;
                                            break;
                                        }
                                    }
                                }
                                if(!EON_Utility.validateRequired(classicSSC.EON_SSC_Registers__r)){
                                    if(!classicSSC.EON_SSC_Registers__r.isEmpty()){
                                        classicRegister.addAll(classicSSC.EON_SSC_Registers__r);
                                        ClassicAtSmart = true;
                                    }
                                }
                            }
                        }
                    }
                }
                
                //Registers - Popualting old register information
                if(OldAssetFlag){
                    //Registers1 for old Asset
                    if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_1_ID__c)){  
                        OldAssetRegister1.id = InsJobRes.E_Meter_Register_1_ID__c;
                        OldAssetRegister1.Removed=OldRegisterRemoved;
                        OldAssetRegister1.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Unit_Rate_1__c))
                            OldAssetRegister1.PrepayUnitRate = String.valueOf(InsJobRes.Elec_Prepay_Meter_Unit_Rate_1__c);
                        OldAssetReading1.Type_x =oldAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_1_Read__c)){
                            OldAssetReading1.Value = InsJobRes.E_Meter_Register_1_Read__c;
                            OldAssetReading1.Flag = 'T';
                        }
                        //Adding old Asset Reading1 to Old Asset Register1     
                        OldAssetRegister1.Reading =OldAssetReading1;
                        //Addding Time Pattern Regimes to Old Asset Register1
                        if(!EON_Utility.validateRequired(apptIns.Register_1_TPR_1__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_1_TPR_1__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime1.add(tpr);
                            OldAssetRegister1.TimePatternRegimes = OldListTimePatternRegime1;
                        }
                        if(!EON_Utility.validateRequired(apptIns.Register_1_TPR_2__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_1_TPR_2__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime1.add(tpr);
                            OldAssetRegister1.TimePatternRegimes = OldListTimePatternRegime1;
                        }
                        //Adding Old Asset Register1 to List of Old Registers
                        listOldAssetRegister.add(OldAssetRegister1);
                    }
                    
                    //Registers2 for old Asset
                    if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_2_ID__c)){  
                        OldAssetRegister2.id = InsJobRes.E_Meter_Register_2_ID__c;
                        OldAssetRegister2.Removed=OldRegisterRemoved;
                        OldAssetRegister2.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Unit_Rate_2__c))
                            OldAssetRegister2.PrepayUnitRate = String.valueOf(InsJobRes.Elec_Prepay_Meter_Unit_Rate_2__c);
                        OldAssetReading2.Type_x =oldAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_2_Read__c)){
                            OldAssetReading2.Value = InsJobRes.E_Meter_Register_2_Read__c;
                            OldAssetReading2.Flag = 'T';
                        }
                        //Adding old Asset Reading2 to Old Asset Register2
                        OldAssetRegister2.Reading =OldAssetReading2;
                        //Addding Time Pattern Regimes to Old Asset Register2
                        if(!EON_Utility.validateRequired(apptIns.Register_2_TPR_1__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_2_TPR_1__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime2.add(tpr);
                            OldAssetRegister2.TimePatternRegimes = OldListTimePatternRegime2;
                        }
                        if(!EON_Utility.validateRequired(apptIns.Register_2_TPR_2__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_2_TPR_2__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime2.add(tpr);
                            OldAssetRegister2.TimePatternRegimes = OldListTimePatternRegime2;
                        }
                        //Adding Old Asset Register2 to List of Old Registers
                        listOldAssetRegister.add(OldAssetRegister2);
                    }
                    
                    //Registers3 for old Asset
                    if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_3_ID__c)){  
                        OldAssetRegister3.id = InsJobRes.E_Meter_Register_3_ID__c;
                        OldAssetRegister3.Removed=OldRegisterRemoved;
                        OldAssetRegister3.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Unit_Rate_3__c))
                            OldAssetRegister3.PrepayUnitRate = String.valueOf(InsJobRes.Elec_Prepay_Meter_Unit_Rate_3__c);
                        OldAssetReading3.Type_x =oldAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_3_Read__c)){
                            OldAssetReading3.Value = InsJobRes.E_Meter_Register_3_Read__c;
                            OldAssetReading3.Flag = 'T';
                        }
                        //Adding old Asset Reading3 to Old Asset Register3
                        OldAssetRegister3.Reading =OldAssetReading3;
                        //Addding Time Pattern Regimes to Old Asset Register3
                        if(!EON_Utility.validateRequired(apptIns.Register_3_TPR_1__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_3_TPR_1__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime3.add(tpr);
                            OldAssetRegister3.TimePatternRegimes = OldListTimePatternRegime3;
                        }
                        if(!EON_Utility.validateRequired(apptIns.Register_3_TPR_2__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_3_TPR_2__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime3.add(tpr);
                            OldAssetRegister3.TimePatternRegimes = OldListTimePatternRegime3;
                        }
                        //Adding Old Asset Register3 to List of Old Registers
                        listOldAssetRegister.add(OldAssetRegister3);
                    }
                    
                    //Registers4 for old Asset
                    if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_4_ID__c)){  
                        OldAssetRegister4.id = InsJobRes.E_Meter_Register_4_ID__c;
                        OldAssetRegister4.Removed=OldRegisterRemoved;
                        OldAssetRegister4.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Unit_Rate_4__c))
                            OldAssetRegister4.PrepayUnitRate = String.valueOf(InsJobRes.Elec_Prepay_Meter_Unit_Rate_4__c);
                        OldAssetReading4.Type_x =oldAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_4_Read__c)){
                            OldAssetReading4.Value = InsJobRes.E_Meter_Register_4_Read__c;
                            OldAssetReading4.Flag = 'T';
                        }
                        //Adding old Asset Reading4 to Old Asset Register4
                        OldAssetRegister4.Reading =OldAssetReading4;
                        //Addding Time Pattern Regimes to Old Asset Register4
                        if(!EON_Utility.validateRequired(apptIns.Register_4_TPR_1__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_4_TPR_1__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime4.add(tpr);
                            OldAssetRegister4.TimePatternRegimes = OldListTimePatternRegime4;
                        }
                        if(!EON_Utility.validateRequired(apptIns.Register_4_TPR_2__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_4_TPR_2__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime4.add(tpr);
                            OldAssetRegister4.TimePatternRegimes = OldListTimePatternRegime4;
                        }
                        //Adding Old Asset Register4 to List of Old Registers
                        listOldAssetRegister.add(OldAssetRegister4);
                    }
                     
                    //Registers5 for old Asset
                    if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_5_ID__c)){  
                        OldAssetRegister5.id = InsJobRes.E_Meter_Register_5_ID__c;
                        OldAssetRegister5.Removed=OldRegisterRemoved;
                        OldAssetRegister5.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Unit_Rate_5__c))
                            OldAssetRegister5.PrepayUnitRate = String.valueOf(InsJobRes.Elec_Prepay_Meter_Unit_Rate_5__c);
                        OldAssetReading5.Type_x =oldAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_5_Read__c)){
                            OldAssetReading5.Value = InsJobRes.E_Meter_Register_5_Read__c;
                            OldAssetReading5.Flag = 'T';
                        }
                        //Adding old Asset Reading5 to Old Asset Register5
                        OldAssetRegister5.Reading =OldAssetReading5;
                        //Addding Time Pattern Regimes to Old Asset Register5
                        if(!EON_Utility.validateRequired(apptIns.Register_5_TPR_1__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_5_TPR_1__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime5.add(tpr);
                            OldAssetRegister5.TimePatternRegimes = OldListTimePatternRegime5;
                        }
                        if(!EON_Utility.validateRequired(apptIns.Register_5_TPR_2__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_5_TPR_2__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime5.add(tpr);
                            OldAssetRegister5.TimePatternRegimes = OldListTimePatternRegime5;
                        }
                        //Adding Old Asset Register5 to List of Old Registers
                        listOldAssetRegister.add(OldAssetRegister5);
                    }
                    
                    //Registers6 for old Asset
                    if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_6_ID__c)){  
                        OldAssetRegister6.id = InsJobRes.E_Meter_Register_6_ID__c;
                        OldAssetRegister6.Removed=OldRegisterRemoved;
                        OldAssetRegister6.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.Elec_Prepay_Meter_Unit_Rate_6__c))
                            OldAssetRegister6.PrepayUnitRate = String.valueOf(InsJobRes.Elec_Prepay_Meter_Unit_Rate_6__c);
                        OldAssetReading6.Type_x =oldAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.E_Meter_Register_6_Read__c)){
                            OldAssetReading6.Value = InsJobRes.E_Meter_Register_6_Read__c;
                            OldAssetReading6.Flag = 'T';
                        }
                        //Adding old Asset Reading6 to Old Asset Register6
                        OldAssetRegister6.Reading =OldAssetReading6;
                        //Addding Time Pattern Regimes to Old Asset Register6
                        if(!EON_Utility.validateRequired(apptIns.Register_6_TPR_1__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_6_TPR_1__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime6.add(tpr);
                            OldAssetRegister6.TimePatternRegimes = OldListTimePatternRegime6;
                        }
                        if(!EON_Utility.validateRequired(apptIns.Register_6_TPR_2__c)){
                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                            tpr.code = apptIns.Register_6_TPR_2__c;
                            tpr.RegisterMappingCoefficient = '1';
                            AllOldTimePatternRegime6.add(tpr);
                            OldAssetRegister6.TimePatternRegimes = OldListTimePatternRegime6;
                        }
                        //Adding Old Asset Register6 to List of Old Registers
                        listOldAssetRegister.add(OldAssetRegister6);
                    }
                }
                
                //Registers - Popualting New Register information 
                if(NewAssetFlag){ 
                    //Registers1 for New Asset
                    if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_1_ID__c)){
                        //Add TPR
                        if(!EON_Utility.validateRequired(allEonSscRegister)){
                            if(!allEonSscRegister.isEmpty()){
                                for(EON_SSC_Register__c register:allEonSscRegister){
                                    if(!EON_Utility.validateRequired(register.Register_ID__c)){                                                                     
                                        if(register.Register_ID__c == InsJobRes.New_E_Meter_Register_1_ID__c){
                                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                            tpr.code = register.TPR__c;
                                            tpr.RegisterMappingCoefficient = '1';
                                            AllNewTimePatternRegime1.add(tpr);
                                            NewAssetRegister1.TimePatternRegimes = NewListTimePatternRegime1;
                                        }
                                        else if(!EON_Utility.validateRequired(register.S1_Register_ID__c)){
                                               if(register.S1_Register_ID__c == InsJobRes.New_E_Meter_Register_1_ID__c){
                                                   EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                                   tpr.code = register.TPR__c;
                                                   tpr.RegisterMappingCoefficient = '1';
                                                   AllNewTimePatternRegime1.add(tpr);
                                                   NewAssetRegister1.TimePatternRegimes = NewListTimePatternRegime1;
                                              }
                                        }
                                    }
                                }
                            }
                        }
                        if(ClassicAtSmart){
                            if(!EON_Utility.validateRequired(classicRegister)){
                                if(classicRegister.size()>0){
                                    if(!EON_Utility.validateRequired(classicRegister[0].Register_ID__c)){
                                        NewAssetRegister1.id = classicRegister[0].Register_ID__c;
                                        InsJobRes.New_E_Meter_Register_1_ID__c = classicRegister[0].Register_ID__c;
                                    }
                                }
                            }
                        }
                        else
                            NewAssetRegister1.id = InsJobRes.New_E_Meter_Register_1_ID__c;
                        NewAssetRegister1.NumberOfDigits = InsJobRes.New_E_Meter_Register_1_dials_digits__c;
                        NewAssetRegister1.Removed=NewRegisterRemoved;
                        NewAssetRegister1.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.New_Prepayment_Meter_Unit_Rate_1__c))
                            NewAssetRegister1.PrepayUnitRate = String.valueOf(InsJobRes.New_Prepayment_Meter_Unit_Rate_1__c);
                        NewAssetReading1.Type_x =NewAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_1_Reading__c)){
                            NewAssetReading1.Value = InsJobRes.New_E_Meter_Register_1_Reading__c;
                            NewAssetReading1.Flag = 'T';
                        }
                        //Adding New Asset Reading1 to New Asset Register1
                        NewAssetRegister1.Reading = NewAssetReading1;
                        //Adding New Asset Register1 to List of New Registers
                        listNewAssetRegister.add(NewAssetRegister1);
                        
                    }
                    
                    //Registers2 for New Asset
                    if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_2_ID__c)){  
                        //Add TPR
                        if(!EON_Utility.validateRequired(allEonSscRegister)){
                            if(!allEonSscRegister.isEmpty()){
                                for(EON_SSC_Register__c register:allEonSscRegister){
                                    if(!EON_Utility.validateRequired(register.Register_ID__c)){
                                        if(register.Register_ID__c == InsJobRes.New_E_Meter_Register_2_ID__c){
                                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                            tpr.code = register.TPR__c;
                                            tpr.RegisterMappingCoefficient = '1';
                                            AllNewTimePatternRegime2.add(tpr);
                                            NewAssetRegister2.TimePatternRegimes = NewListTimePatternRegime2;
                                        }
                                        else if(!EON_Utility.validateRequired(register.S1_Register_ID__c)){
                                               if(register.S1_Register_ID__c == InsJobRes.New_E_Meter_Register_2_ID__c){
                                                   EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                                   tpr.code = register.TPR__c;
                                                   tpr.RegisterMappingCoefficient = '1';
                                                   AllNewTimePatternRegime2.add(tpr);
                                                   NewAssetRegister2.TimePatternRegimes = NewListTimePatternRegime2;
                                              }
                                        }
                                    }
                                }
                            }
                        }
                        if(ClassicAtSmart){
                            if(!EON_Utility.validateRequired(classicRegister)){
                                if(classicRegister.size()>1){
                                    if(!EON_Utility.validateRequired(classicRegister[1].Register_ID__c)){
                                        NewAssetRegister2.id = classicRegister[1].Register_ID__c;
                                        InsJobRes.New_E_Meter_Register_2_ID__c = classicRegister[1].Register_ID__c;
                                    }
                                }
                            }
                        }
                        else
                            NewAssetRegister2.id = InsJobRes.New_E_Meter_Register_2_ID__c;
                        NewAssetRegister2.NumberOfDigits = InsJobRes.New_E_Meter_Register_2_dials_digits__c;
                        NewAssetRegister2.Removed=NewRegisterRemoved;
                        NewAssetRegister2.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.New_Prepayment_Meter_Unit_Rate_2__c))
                            NewAssetRegister2.PrepayUnitRate = String.valueOf(InsJobRes.New_Prepayment_Meter_Unit_Rate_2__c);
                        NewAssetReading2.Type_x =NewAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_2_Reading__c)){
                            NewAssetReading2.Value = InsJobRes.New_E_Meter_Register_2_Reading__c;
                            NewAssetReading2.Flag = 'T';
                        }
                        //Adding New Asset Reading2 to New Asset Register2
                        NewAssetRegister2.Reading = NewAssetReading2;
                        //Adding New Asset Register2 to List of New Registers
                        listNewAssetRegister.add(NewAssetRegister2);
                    }
                    
                    //Registers3 for New Asset
                    if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_3_ID__c)){  
                        //Add TPR
                        if(!EON_Utility.validateRequired(allEonSscRegister)){
                            if(!allEonSscRegister.isEmpty()){
                                for(EON_SSC_Register__c register:allEonSscRegister){
                                    if(!EON_Utility.validateRequired(register.Register_ID__c)){
                                        if(register.Register_ID__c == InsJobRes.New_E_Meter_Register_3_ID__c){
                                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                            tpr.code = register.TPR__c;
                                            tpr.RegisterMappingCoefficient = '1';
                                            AllNewTimePatternRegime3.add(tpr);
                                            NewAssetRegister3.TimePatternRegimes = NewListTimePatternRegime3;
                                        }
                                        else if(!EON_Utility.validateRequired(register.S1_Register_ID__c)){
                                               if(register.S1_Register_ID__c == InsJobRes.New_E_Meter_Register_3_ID__c){
                                                   EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                                   tpr.code = register.TPR__c;
                                                   tpr.RegisterMappingCoefficient = '1';
                                                   AllNewTimePatternRegime3.add(tpr);
                                                   NewAssetRegister3.TimePatternRegimes = NewListTimePatternRegime3;
                                              }
                                        }
                                    }
                                }
                            }
                        }
                        if(ClassicAtSmart){
                            if(!EON_Utility.validateRequired(classicRegister)){
                                if(classicRegister.size()>2){
                                    if(!EON_Utility.validateRequired(classicRegister[2].Register_ID__c)){
                                        NewAssetRegister3.id = classicRegister[2].Register_ID__c;
                                        InsJobRes.New_E_Meter_Register_3_ID__c = classicRegister[2].Register_ID__c;
                                    }
                                }
                            }
                        }
                        else
                            NewAssetRegister3.id = InsJobRes.New_E_Meter_Register_3_ID__c;
                        NewAssetRegister3.NumberOfDigits = InsJobRes.New_E_Meter_Register_3_dials_digits__c;
                        NewAssetRegister3.Removed=NewRegisterRemoved;
                        NewAssetRegister3.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.New_Prepayment_Meter_Unit_Rate_3__c))
                            NewAssetRegister3.PrepayUnitRate = String.valueOf(InsJobRes.New_Prepayment_Meter_Unit_Rate_3__c);
                        NewAssetReading3.Type_x =NewAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_3_Reading__c)){
                            NewAssetReading3.Value = InsJobRes.New_E_Meter_Register_3_Reading__c;
                            NewAssetReading3.Flag = 'T';
                        }
                        //Adding New Asset Reading3 to New Asset Register3
                        NewAssetRegister3.Reading = NewAssetReading3;
                        //Adding New Asset Register3 to List of New Registers
                        listNewAssetRegister.add(NewAssetRegister3);
                    }
                    
                    //Registers4 for New Asset
                    if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_4_ID__c)){  
                        //Add TPR
                        if(!EON_Utility.validateRequired(allEonSscRegister)){
                            if(!allEonSscRegister.isEmpty()){
                                for(EON_SSC_Register__c register:allEonSscRegister){
                                    if(!EON_Utility.validateRequired(register.Register_ID__c)){
                                        if(register.Register_ID__c == InsJobRes.New_E_Meter_Register_4_ID__c){
                                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                            tpr.code = register.TPR__c;
                                            tpr.RegisterMappingCoefficient = '1';
                                            AllNewTimePatternRegime4.add(tpr);
                                            NewAssetRegister4.TimePatternRegimes = NewListTimePatternRegime4;
                                        }
                                        else if(!EON_Utility.validateRequired(register.S1_Register_ID__c)){
                                               if(register.S1_Register_ID__c == InsJobRes.New_E_Meter_Register_4_ID__c){
                                                   EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                                   tpr.code = register.TPR__c;
                                                   tpr.RegisterMappingCoefficient = '1';
                                                   AllNewTimePatternRegime4.add(tpr);
                                                   NewAssetRegister4.TimePatternRegimes = NewListTimePatternRegime4;
                                              }
                                        }
                                    }
                                }
                            }
                        }
                        if(ClassicAtSmart){
                            if(!EON_Utility.validateRequired(classicRegister)){
                                if(classicRegister.size()>3){
                                    if(!EON_Utility.validateRequired(classicRegister[3].Register_ID__c)){
                                        NewAssetRegister4.id = classicRegister[3].Register_ID__c;
                                        InsJobRes.New_E_Meter_Register_4_ID__c = classicRegister[3].Register_ID__c;
                                    }
                                }
                            }
                        }
                        else
                            NewAssetRegister4.id = InsJobRes.New_E_Meter_Register_4_ID__c;
                        NewAssetRegister4.NumberOfDigits = InsJobRes.New_E_Meter_Register_4_dials_digits__c;
                        NewAssetRegister4.Removed=NewRegisterRemoved;
                        NewAssetRegister4.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.New_Prepayment_Meter_Unit_Rate_4__c))
                            NewAssetRegister4.PrepayUnitRate = String.valueOf(InsJobRes.New_Prepayment_Meter_Unit_Rate_4__c);
                        NewAssetReading4.Type_x =NewAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_4_Reading__c)){
                            NewAssetReading4.Value = InsJobRes.New_E_Meter_Register_4_Reading__c;
                            NewAssetReading4.Flag = 'T';
                        }
                        //Adding New Asset Reading4 to New Asset Register4
                        NewAssetRegister4.Reading = NewAssetReading4;
                        //Adding New Asset Register2 to List of New Registers
                        listNewAssetRegister.add(NewAssetRegister4);
                    }
                    
                    //Registers5 for New Asset
                    if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_5_ID__c)){  
                        //Add TPR
                        if(!EON_Utility.validateRequired(allEonSscRegister)){
                            if(!allEonSscRegister.isEmpty()){
                                for(EON_SSC_Register__c register:allEonSscRegister){
                                    if(!EON_Utility.validateRequired(register.Register_ID__c)){
                                        if(register.Register_ID__c == InsJobRes.New_E_Meter_Register_5_ID__c){
                                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                            tpr.code = register.TPR__c;
                                            tpr.RegisterMappingCoefficient = '1';
                                            AllNewTimePatternRegime5.add(tpr);
                                            NewAssetRegister5.TimePatternRegimes = NewListTimePatternRegime5;
                                        }
                                        else if(!EON_Utility.validateRequired(register.S1_Register_ID__c)){
                                               if(register.S1_Register_ID__c == InsJobRes.New_E_Meter_Register_5_ID__c){
                                                   EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                                   tpr.code = register.TPR__c;
                                                   tpr.RegisterMappingCoefficient = '1';
                                                   AllNewTimePatternRegime5.add(tpr);
                                                   NewAssetRegister5.TimePatternRegimes = NewListTimePatternRegime5;
                                              }
                                        }
                                    }
                                }
                            }
                        }
                        if(ClassicAtSmart){
                            if(!EON_Utility.validateRequired(classicRegister)){
                                if(classicRegister.size()>4){
                                    if(!EON_Utility.validateRequired(classicRegister[4].Register_ID__c)){
                                        NewAssetRegister5.id = classicRegister[4].Register_ID__c;
                                        InsJobRes.New_E_Meter_Register_5_ID__c = classicRegister[4].Register_ID__c;
                                    }
                                }
                            }
                        }
                        else
                            NewAssetRegister5.id = InsJobRes.New_E_Meter_Register_5_ID__c;
                        NewAssetRegister5.NumberOfDigits = InsJobRes.New_E_Meter_Register_5_dials_digits__c;
                        NewAssetRegister5.Removed=NewRegisterRemoved;
                        NewAssetRegister5.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.New_Prepayment_Meter_Unit_Rate_5__c))
                            NewAssetRegister5.PrepayUnitRate = String.valueOf(InsJobRes.New_Prepayment_Meter_Unit_Rate_5__c);
                        NewAssetReading5.Type_x =NewAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_5_Reading__c)){
                            NewAssetReading5.Value = InsJobRes.New_E_Meter_Register_5_Reading__c;
                            NewAssetReading5.Flag = 'T';
                        }
                        //Adding New Asset Reading5 to New Asset Register5
                        NewAssetRegister5.Reading = NewAssetReading5;
                        //Adding New Asset Register5 to List of New Registers
                        listNewAssetRegister.add(NewAssetRegister5);
                    }
                    
                    //Registers6 for New Asset
                    if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_6_ID__c)){  
                        //Add TPR
                        if(!EON_Utility.validateRequired(allEonSscRegister)){
                            if(!allEonSscRegister.isEmpty()){
                                for(EON_SSC_Register__c register:allEonSscRegister){
                                    if(!EON_Utility.validateRequired(register.Register_ID__c)){
                                        if(register.Register_ID__c == InsJobRes.New_E_Meter_Register_6_ID__c){                                            
                                            EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                            tpr.code = register.TPR__c;
                                            tpr.RegisterMappingCoefficient = '1';
                                            AllNewTimePatternRegime6.add(tpr);
                                            NewAssetRegister6.TimePatternRegimes = NewListTimePatternRegime6;
                                        }
                                        else if(!EON_Utility.validateRequired(register.S1_Register_ID__c)){
                                               if(register.S1_Register_ID__c == InsJobRes.New_E_Meter_Register_6_ID__c){
                                                   EON_MDS_Work_Management_WS.TimePatternRegime tpr = new EON_MDS_Work_Management_WS.TimePatternRegime();
                                                   tpr.code = register.TPR__c;
                                                   tpr.RegisterMappingCoefficient = '1';
                                                   AllNewTimePatternRegime6.add(tpr);
                                                   NewAssetRegister6.TimePatternRegimes = NewListTimePatternRegime6;
                                              }
                                        }
                                    }
                                }
                            }
                        }
                        if(ClassicAtSmart){
                            if(!EON_Utility.validateRequired(classicRegister)){
                                if(classicRegister.size()>5){
                                    if(!EON_Utility.validateRequired(classicRegister[5].Register_ID__c)){
                                        NewAssetRegister6.id = classicRegister[5].Register_ID__c;
                                        InsJobRes.New_E_Meter_Register_6_ID__c = classicRegister[5].Register_ID__c;
                                    }
                                }
                            } 
                        }
                        else
                            NewAssetRegister6.id = InsJobRes.New_E_Meter_Register_6_ID__c;
                        NewAssetRegister6.NumberOfDigits = InsJobRes.New_E_Meter_Register_6_dials_digits__c;
                        NewAssetRegister6.Removed=NewRegisterRemoved;
                        NewAssetRegister6.Type_x ='C';
                        if(!EON_Utility.validateRequired(InsJobRes.New_Prepayment_Meter_Unit_Rate_6__c))
                            NewAssetRegister6.PrepayUnitRate = String.valueOf(InsJobRes.New_Prepayment_Meter_Unit_Rate_6__c);
                        NewAssetReading6.Type_x =NewAssetReadingType;
                        if(!EON_Utility.validateRequired(InsJobRes.New_E_Meter_Register_6_Reading__c)){
                            NewAssetReading6.Value = InsJobRes.New_E_Meter_Register_6_Reading__c;
                            NewAssetReading6.Flag = 'T';
                        }
                        //Adding New Asset Reading6 to New Asset Register6
                        NewAssetRegister6.Reading = NewAssetReading6;
                        //Adding New Asset Register6 to List of New Registers
                        listNewAssetRegister.add(NewAssetRegister6);
                    }
                }
                
                //Adding Register list to Array of Registers
                //Old Register List
                if(!listOldAssetRegister.isEmpty())
                    ArrayOldAssetRegister.CloseElecRegister=listOldAssetRegister;
                //New Rigister List   
                if(!listNewAssetRegister.isEmpty())
                    ArrayNewAssetRegister.CloseElecRegister=listNewAssetRegister;
                 
                //Adding Elec meter to List of Elec Meter 
                //Old Meter Information 
                if(OldAssetFlag){
                    //Adding Old Register Arrays to Elec Meters
                    OldAssetsObj.Registers = ArrayOldAssetRegister;
                    ListElecMeter.add(OldAssetsObj);
                }
                //New Meter Information  
                if(NewAssetFlag){
                    //Adding New Register Arrays to Elec Meters
                    NewAssetsObj.Registers = ArrayNewAssetRegister;
                    ListElecMeter.add(NewAssetsObj);
                }
                //Adding List of Elec meters to Array of Elec Meters
                if(!ListElecMeter.isEmpty())
                ArrayElecMeter.CloseElecMeter =ListElecMeter;
            }
            
            //Adding all paramters to Close Elec Work Obj 
            CloseElecWorkObj.Meters = ArrayElecMeter;
            CloseElecWorkObj.SiteVisit = SiteVisitObj;
            CloseElecWorkObj.Supply =ElecSupplyObj;
              
            //Adding information to main request object
            reqCloseElecWorkObj.CloseElecWork =CloseElecWorkObj;

            tracker.Request_Data__c = string.ValueOf(reqCloseElecWorkObj);
            //Calling Web Service Method
            if(callMDSWS)
                respMDS = MDSObj.CloseJumboElectricityJob(reqCloseElecWorkObj);
            //Update Job Results
            if(!EON_Utility.validateRequired(InsJobRes) && ClassicAtSmart)
                update InsJobRes; 
            tracker.Response_Data__c =  String.valueof(respMDS);
            tracker.Status__c = EON_Utility.RESULT_PASS;  
            if(respMDS.Success){
                tracker.Status__c = EON_Utility.RESULT_PASS; 
                update new EON_Appointment__c(id=appointmentID, MDS_Close_Electricity_Job__c='Dispatched');
            }
            else{ 
                tracker.Status__c = EON_Utility.RESULT_FAIL;
                string Errors='';
                for(String str:respMDS.Errors.Message)
                    Errors=Errors+str+'\n'; 
                insert new Note(Title='Close Elec Job Failure',Body= Errors,ParentId=appointmentID);
                update new EON_Appointment__c(id=appointmentID, MDS_Close_Electricity_Job__c='Failed to Dispatch');
            } 
            //Inserting MDS Data Tracker record    
            //insert tracker;
            if(callMDSWS)
              allTracker.add(tracker);
            insert allTracker;
        }
        
        
        
        
        catch (Exception ex){
            if(authToken.Error != '') {
                tracker.Response_Data__c=ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber()+'\n'+(!EON_Utility.validateRequired(tracker.Response_Data__c)?tracker.Response_Data__c:'')+'\nAuthentication Failure:\n'+authToken.Error;
            }
            else {
                tracker.Response_Data__c=ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber()+'\n'+(!EON_Utility.validateRequired(tracker.Response_Data__c)?tracker.Response_Data__c:'');
            }
            tracker.Status__c = EON_Utility.RESULT_FAIL;
            //Inserting MDS Data Tracker record 
            insert tracker; 
        }
    }
    
    
    /** 
        MapLocationCode(String lValue): This method is return the Industry Specific Location Code
    **/  
    public static String MapLocationCode(String lValue){
         if(lValue != null){
            EON_Electric_Meter_Location__c[] lstMeterLocation = [select ID, Code__c from EON_Electric_Meter_Location__c where Name =: lValue];
            if(!lstMeterLocation.isEmpty())
                return lstMeterLocation[0].Code__c;
        }                                                            
        return null;                              
    }
    
    /** 
        string IndCodeMeterType(string mType): Method to return industry coded Meter Type.
    **/ 
    public static string IndCodeMeterType(string mType){
        if(mType != null){
            EON_Electric_Meter_Type__c[] lstMeterType = [select name from EON_Electric_Meter_Type__c where DESCRIPTION__c =: mType];
            if(!lstMeterType.isEmpty())
                return lstMeterType[0].Name;
        }                                                            
        return mType;
    }
    
    /** 
    string EnergStatus(string ESval): Method to return Industry mapped 'Site Left Energised' values 
    **/ 
    public static string EnergStatus(string ESval){
        if(ESval=='Energised') return 'E';
        if(ESval=='De-Energised') return 'D';
        return null;
    }
    
    /** 
    string dnoInfo(string ESval): Method to return Industry mapped 'Site Left Energised' values 
    **/ 
    public static string DnoInfo(string appIns,EON_Job_Results__c jr){
         string preCatagory='';
         string postCatagory='';
         if(!EON_Utility.validateRequired(jr.Pre_Work_DNO_Defect_Details__c))
             preCatagory = 'CAT'+jr.Pre_Work_DNO_Defect_Details__c.substring(0,1).toUppercase();
        
         if(!EON_Utility.validateRequired(jr.DNO_Defect_Details__c))
             postCatagory = 'CAT'+jr.DNO_Defect_Details__c.substring(0,1).toUppercase();
        List<EON_DNO_Details_Categories__c> dCat = new List<EON_DNO_Details_Categories__c>();
        if((preCatagory!='' && preCatagory == 'CATB') || (postCatagory!='' && postCatagory=='CATB'))
            dCat = [SELECT Send_In_J12__c FROM EON_DNO_Details_Categories__c where PostDNO__c=:postCatagory and PreDNO__c=:preCatagory and Status__c =:appIns and E_Meter_Installed__c=:jr.E_Meter_Installed__c and Original_E_Meter_Refitted__c=:jr.Original_E_Meter_Refitted__c];
        else  dCat = [SELECT Send_In_J12__c FROM EON_DNO_Details_Categories__c where PostDNO__c=:postCatagory and PreDNO__c=:preCatagory and Status__c =:appIns];     
           if(!dCat.isEmpty())
             return dCat[0].Send_In_J12__c; 
             else                                        
               return null;
    }
    
    /**
        String AbortReasonCode(String abortReason): This method will return MDS specific abort code
    **/
    //TODO: Need to replace custom setting EON_Jumbo_Abort_Reason_Code__c?
    public static string AbortReasonCode(String abortReason){
        Map<String, EON_Jumbo_Abort_Reason_Code__c> allAbortReasonCode = EON_Jumbo_Abort_Reason_Code__c.getAll();
        if(!allAbortReasonCode.isEmpty()){
            for(EON_Jumbo_Abort_Reason_Code__c abortRes: allAbortReasonCode.values()){
                if(abortReason.equalsIgnoreCase(abortRes.Name))
                    return !EON_Utility.validateRequired(abortRes.Electric_Abort_Reason__c) ? abortRes.Electric_Abort_Reason__c : null;
            }            
        }
        return '1';
    }
    
    //CH01.Start
    /**
        String populateCheckCode(String abortReason,String abortSubReason): This method will return MDS specific checkCode based on Abort Reason and Abort SubReason
    **/
    public static string populateCheckCode(String abortReason,String abortSubReason){
        Map<String, EON_Check_Code__c> allCheckCode = EON_Check_Code__c.getAll();
        if(!allCheckCode.isEmpty()){
            for(EON_Check_Code__c checkCode : allCheckCode.values()){
                if(abortReason.equalsIgnoreCase(checkCode.Abort_Reason__c)  &&  (abortSubReason!=null ? abortSubReason.equalsIgnoreCase(checkCode.Abort_Sub_Reason__c) : true))
                    return !EON_Utility.validateRequired(checkCode.CheckCode__c) ? checkCode.CheckCode__c : null;
            }            
        }
        return '';
    }
    //CH01.End
}