/**
    Description : This class is invoked through a trigger on ‘EON Appointment’ Object to call a Close Gas Job Web Service Method in MDS
          This class functionality is replicated from Apex Class - EON_Jumbo_Gas_Close_Outbound_Job
                  
    VF Page     : None
    Test Class  : EON_MDS_Gas_Close_Outbound_Job_Test 

**/
/*
    Created By  : Tabish Almas
    Created On  : 30/01/2019
    Service Req : SR_OptiMUS_EON_297
    Change History :
    CH01 # SR_OptiMUS_EON_315 # 20/03/2019 # Tabish Almas # Added logic to pass null when YearOfManufacture is not available.
    
*/

public with sharing class EON_MDS_Gas_Close_Outbound_Job {

    /**
    closeGasJobMDS(String appId) -  Method to close Gas Job
    **/
    @future (callout=true)
    public static void closeGasJobMDS(String appId, boolean callMAM){
        EON_MDS_OAuth_Authentication.AuthDetail authToken;
        boolean callMDSWS = true; 
        list<MDS_Data_Tracker__c> allTracker = new list<MDS_Data_Tracker__c>();
        string tranID = EON_Utility.GenUniqueNum(); //generating random Unique number for transection ID
        MDS_Data_Tracker__c tracker = new MDS_Data_Tracker__c();
        EON_Appointment__c apptIns = new EON_Appointment__c();
        Id appointmentID = Id.valueOf(appId);
        boolean OldAssetFlag = false;
        boolean NewAssetFlag = false;
        string RegisterRemoved ='';
        tracker.Direction__c = EON_Utility.DIRECTION_OUT ;
        tracker.Command__c = EON_MDS_Utility.CMD_Close_GasMDS;
        tracker.Transaction_ID__c = tranID;
        tracker.EON_Appointment__c=appointmentID;
        
        try{
            apptIns =[select id, Name, MPRN__c,JUMBO_ID__c,h_Metering_Pressure__c,Gas_Market_Participant_ID__c,h_Job_Code__c, Status__c, Gas_Map_Identifier__c, G_Meter_Year_of_Manufacture__c, //TODO: Replace Jumbo in here?
                 G_Meter_Type__r.Industry_Code__c, G_Meter_Measuring_Capacity__c, G_Meter_Units_of_Measure__c, G_Meter_Multiplication_Factor__c,
                 Job_Code__c, Job_Code__r.Jumbo_Job_Code__c, (select id,Name,Time_On_Site__c,Time_Closed__c,Site_Left_Energised__c, Original_G_Meter_refitted__c,h_Abort_Reason__c,
                 Gas_Supply_Capped__c,G_Meter_Location__c,G_Meter_Version__c,New_G_Meter_Version__c,G_Meter_Manufacturer__c,h_G_Meter_Manufacturer__c,New_G_Meter_Manufacturer__c,h_New_G_Meter_Manufacturer__c,
                 Removed_G_Meter_Location__c,New_G_Meter_Location__c,G_Meter_Removed__c,G_Meter_Type__c,New_G_Meter_Type__c,G_Meter_Register_ID__c,New_G_Meter_Number_of_digits__c,G_Meter_Register_Read__c,
                 Abort_Comments__c,Job_Status__c,Abort_Reason__c,Work_Summary__c,G_Meter_Serial_Number__c,Removed_G_Meter_Serial_Number__c,New_G_Meter_Serial_Number__c,
                 G_Meter_Number_of_Digits__c,Opening_G_Meter_Reading__c, G_Meter_Installed__c,New_E_Meter_Type__c,E_Meter_Installed__c,Original_E_Meter_refitted__c from EON_Job_Results__r)from EON_Appointment__c where id=:appointmentID limit 1];
            
            if(apptIns.h_Job_Code__c == 'OOAEINSTALLBIND' && 
                    (apptIns.status__c == 'COMPLETED' || apptIns.status__c == 'ABORTED'))
                return;
            
            if(!Test.isRunningTest() && apptIns.Status__c == 'ABORTED'){
                MDS_Data_Tracker__c MDSTracker = validateMPRNAtMDS(apptIns);                
                if(MDSTracker!= null && MDSTracker.id != null)
                    return;                
                allTracker.add(MDSTracker);
            }
            
            //BasicHttpBinding_IWorkManagement - Instantiating main method     
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
            
            //Instantiating main request Object for Close Gas Job
            EON_MDS_Work_Management_WS.CloseGasWorkRequest reqCloseGasWorkObj = new EON_MDS_Work_Management_WS.CloseGasWorkRequest();
            reqCloseGasWorkObj.Client=clientInfo;
            reqCloseGasWorkObj.UniqueId = tranID;
            
            //CloseGasWork - Instantiating Object
            EON_MDS_Work_Management_WS.CloseGasWork CloseGasWorkObj = new EON_MDS_Work_Management_WS.CloseGasWork();
            //SiteVisit - Instantiating Object
            EON_MDS_Work_Management_WS.SiteVisit SiteVisitObj = new EON_MDS_Work_Management_WS.SiteVisit();
            //GasTransaction - Instantiating Object
            EON_MDS_Work_Management_WS.GasTransaction GasTransactionObj = new EON_MDS_Work_Management_WS.GasTransaction();
            
            //CloseGasMeter - Instantiating Object for Old Assets
            EON_MDS_Work_Management_WS.CloseGasMeter OldAssetObj = new EON_MDS_Work_Management_WS.CloseGasMeter();
            //CloseGasMeter - Instantiating Object for New Assets
            EON_MDS_Work_Management_WS.CloseGasMeter NewAssetObj = new EON_MDS_Work_Management_WS.CloseGasMeter();
            
            //ArrayOfCloseGasMeter - Array to populate all Close Meters 
            EON_MDS_Work_Management_WS.ArrayOfCloseGasMeter ArrayGasMeter  = new EON_MDS_Work_Management_WS.ArrayOfCloseGasMeter();
            List<EON_MDS_Work_Management_WS.CloseGasMeter> ListGasMeter= new List<EON_MDS_Work_Management_WS.CloseGasMeter>();
            
            //ArrayOfGasRegister - Array to populate all Registers for Old Asset
            EON_MDS_Work_Management_WS.ArrayOfCloseGasRegister ArrayOldAssetRegister  = new  EON_MDS_Work_Management_WS.ArrayOfCloseGasRegister();
            
            //ArrayOfGasRegister - Array to populate all Registers for New Asset
            EON_MDS_Work_Management_WS.ArrayOfCloseGasRegister ArrayNewAssetRegister  = new  EON_MDS_Work_Management_WS.ArrayOfCloseGasRegister();
            //List to contain old Asset Register
            List<EON_MDS_Work_Management_WS.CloseGasRegister> listOldAssetRegister = new List<EON_MDS_Work_Management_WS.CloseGasRegister>();
            //List to contain New Asset Register
            List<EON_MDS_Work_Management_WS.CloseGasRegister> listNewAssetRegister = new List<EON_MDS_Work_Management_WS.CloseGasRegister>();
            //CloseGasRegister - Instantiating Registers for Old Assets
            EON_MDS_Work_Management_WS.CloseGasRegister  OldAssetRegister  = new EON_MDS_Work_Management_WS.CloseGasRegister();
            //CloseGasRegister - Instantiating Registers for New Assets
            EON_MDS_Work_Management_WS.CloseGasRegister NewAssetRegister = new EON_MDS_Work_Management_WS.CloseGasRegister();
            
            //MPRN 
            if(!EON_Utility.validateRequired(apptIns.MPRN__c))
                CloseGasWorkObj.MPRN = apptIns.MPRN__c;
            
            //MDSId    //TODO: Replace JumboId?
            if(!EON_Utility.validateRequired(apptIns.JUMBO_ID__c))
                CloseGasWorkObj.JumboId = apptIns.JUMBO_ID__c;
            
            //MeterLink
            CloseGasWorkObj.MeterLink ='F';
            
            //ExternalJobReference   
            if(!EON_Utility.validateRequired(apptIns.Name))
                CloseGasWorkObj.ExternalJobReference = apptIns.Name;
            
            //MDSJobType
            if(!EON_Utility.validateRequired(apptIns.Job_Code__c)){
                if(!EON_Utility.validateRequired(apptIns.Job_Code__r.Jumbo_Job_Code__c))
                    CloseGasWorkObj.JumboJobType = apptIns.Job_Code__r.Jumbo_Job_Code__c;    //TODO: Replace JumboJobType and Job_Code__c
            }
            
            //SupplierMarketParticipantId   
            if(!EON_Utility.validateRequired(apptIns.Gas_Market_Participant_ID__c))
                CloseGasWorkObj.SupplierMarketParticipantId = apptIns.Gas_Market_Participant_ID__c;
            
            if(!apptIns.EON_Job_Results__r.isEmpty()){
                EON_Job_Results__c InsJobRes =  apptIns.EON_Job_Results__r[0];
                //Mapping Job Result values
                
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
                
                //MeterPointStatus   
                if(!EON_Utility.validateRequired(InsJobRes.Site_Left_Energised__c))
                    CloseGasWorkObj.MeterPointStatus = 'CA';
                
                //MeterPointStatus   
                if(!EON_Utility.validateRequired(InsJobRes.Gas_Supply_Capped__c))
                    CloseGasWorkObj.MeterPointStatus = 'LI';
                //Location
                if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Location__c)){
                    if(!EON_Utility.validateRequired(MapLocationCode(InsJobRes.G_Meter_Location__c))){
                        if(!EON_Utility.validateRequired(apptIns.Status__c)){
                            if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || (InsJobRes.New_E_Meter_Type__c=='MS1' && InsJobRes.E_Meter_Installed__c=='Yes' && InsJobRes.Original_E_Meter_refitted__c=='Yes') || (InsJobRes.New_G_Meter_Type__c=='MS1' && InsJobRes.G_Meter_Installed__c    =='Yes' && InsJobRes.Original_G_Meter_refitted__c=='Yes'))
                                CloseGasWorkObj.Location = MapLocationCode(InsJobRes.G_Meter_Location__c);                  
                        }
                    }
                }
                
                if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Location__c) && !EON_Utility.validateRequired(MapLocationCode(InsJobRes.New_G_Meter_Location__c)) && !EON_Utility.validateRequired(apptIns.h_Job_Code__c) && (apptIns.h_Job_Code__c.containsignorecase('OOAREPOSELEC') || apptIns.h_Job_Code__c.containsignorecase('OOAREPOSGAS'))){CloseGasWorkObj.Location = MapLocationCode(InsJobRes.New_G_Meter_Location__c);}
                
                //MeteringPressure
                if(!EON_Utility.validateRequired(apptIns.h_Metering_Pressure__c))
                    CloseGasWorkObj.MeteringPressure = apptIns.h_Metering_Pressure__c;        
                if(!EON_Utility.validateRequired(InsJobRes.Abort_Reason__c)){
                    //commented out GasTransactionObj.StatusChangeReason = AbortReasonCode(InsJobRes.Abort_Reason__c);
                    if(apptIns.Status__c == 'ABORTED' && InsJobRes.New_E_Meter_Type__c!='MS1' && InsJobRes.E_Meter_Installed__c!='Yes' && InsJobRes.Original_E_Meter_refitted__c!='Yes' && InsJobRes.New_G_Meter_Type__c!='MS1' && InsJobRes.G_Meter_Installed__c   !='Yes' && InsJobRes.Original_G_Meter_refitted__c!='Yes'){
                        if( !InsJobRes.G_Meter_Installed__c.equalsIgnoreCase('Yes') && InsJobRes.Original_G_Meter_refitted__c != 'Yes' && !InsJobRes.h_Abort_Reason__c.equalsIgnoreCase('true'))     GasTransactionObj.StatusChangeReason = AbortReasonCode(InsJobRes.Abort_Reason__c);
                        if(InsJobRes.G_Meter_Installed__c.equalsIgnoreCase('Yes'))
                            GasTransactionObj.StatusChangeReason = AbortReasonCode(InsJobRes.Abort_Reason__c);
                        system.debug('Value of GasTransactionObj.StatusChangeReason %%%%%%' +GasTransactionObj.StatusChangeReason);
                        system.debug('Value of InsJobRes.Abort_Reason__c %%%%' +InsJobRes.Abort_Reason__c );
                    }
                }
                
                //Status
                GasTransactionObj.Status = !EON_Utility.validateRequired(apptIns.Status__c) ? ((apptIns.Status__c.equalsIgnoreCase('Aborted') && InsJobRes.New_E_Meter_Type__c!='MS1' && InsJobRes.E_Meter_Installed__c!='Yes' && InsJobRes.Original_E_Meter_refitted__c!='Yes' && InsJobRes.New_G_Meter_Type__c!='MS1' && InsJobRes.G_Meter_Installed__c   !='Yes' && InsJobRes.Original_G_Meter_refitted__c!='Yes' )? 'ABORT' : ((apptIns.Status__c.equalsIgnoreCase('Completed') || (InsJobRes.New_E_Meter_Type__c=='MS1' && InsJobRes.E_Meter_Installed__c=='Yes' && InsJobRes.Original_E_Meter_refitted__c=='Yes') || (InsJobRes.New_G_Meter_Type__c=='MS1' && InsJobRes.G_Meter_Installed__c  =='Yes' && InsJobRes.Original_G_Meter_refitted__c=='Yes') )? 'COMLT' : '')) : '';
                if(!EON_Utility.validateRequired(InsJobRes.Work_Summary__c))
                    CloseGasWorkObj.FieldWorkerNotes = InsJobRes.Work_Summary__c;
                
                //Meters - Populating old and new Meter Information     
                //SerialNumber
                if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Serial_Number__c)){
                    OldAssetObj.SerialNumber = InsJobRes.G_Meter_Serial_Number__c;
                    OldAssetFlag = true;
                }
                
                if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Serial_Number__c)){
                    NewAssetObj.SerialNumber = InsJobRes.New_G_Meter_Serial_Number__c;
                    NewAssetFlag = true;
                }
                
                //YearOfManufacture
                //CH01.Start
                //OldAssetObj.YearOfManufacture = !EON_Utility.validateRequired(apptIns.G_Meter_Year_of_Manufacture__c) ? apptIns.G_Meter_Year_of_Manufacture__c : '';
                if(!EON_Utility.validateRequired(apptIns.G_Meter_Year_of_Manufacture__c))
                    OldAssetObj.YearOfManufacture = apptIns.G_Meter_Year_of_Manufacture__c;
                //CH01.End
                
                //Type_x
                OldAssetObj.Type_x = !EON_Utility.validateRequired(apptIns.G_Meter_Type__r.Industry_Code__c) ? apptIns.G_Meter_Type__r.Industry_Code__c : '';
                
                //MeasuringCapacity
                OldAssetObj.MeasuringCapacity = !EON_Utility.validateRequired(apptIns.G_Meter_Measuring_Capacity__c) ? apptIns.G_Meter_Measuring_Capacity__c : '';
                
                //Mechanism
                if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Type__c))
                    if(!EON_Utility.validateRequired(IndCodeMeterType(InsJobRes.G_Meter_Type__c)))
                    OldAssetObj.Mechanism = IndCodeMeterType(InsJobRes.G_Meter_Type__c);

                if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Type__c))
                    if(!EON_Utility.validateRequired(EON_Utility.smartMeterModel('Gas',InsJobRes.New_G_Meter_Type__c,InsJobRes.New_G_Meter_Manufacturer__c,InsJobRes.New_G_Meter_Version__c))) 
                    NewAssetObj.Mechanism = EON_Utility.smartMeterModel('Gas',InsJobRes.New_G_Meter_Type__c,InsJobRes.New_G_Meter_Manufacturer__c,InsJobRes.New_G_Meter_Version__c);
                
                //Model
                if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Version__c))
                    OldAssetObj.Model = InsJobRes.G_Meter_Version__c;
                if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Version__c))
                    NewAssetObj.Model = InsJobRes.New_G_Meter_Version__c;
                
                //Manufacturer
                if(!EON_Utility.validateRequired(InsJobRes.h_G_Meter_Manufacturer__c))
                    OldAssetObj.Manufacturer = InsJobRes.h_G_Meter_Manufacturer__c; 
                if(!EON_Utility.validateRequired(InsJobRes.h_New_G_Meter_Manufacturer__c))
                    NewAssetObj.Manufacturer = InsJobRes.h_New_G_Meter_Manufacturer__c;
                
                //Location
                if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Location__c)){
                    if(!EON_Utility.validateRequired(apptIns.Status__c)){
                        if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || (InsJobRes.New_E_Meter_Type__c=='MS1' && InsJobRes.E_Meter_Installed__c=='Yes' && InsJobRes.Original_E_Meter_refitted__c=='Yes') || (InsJobRes.New_G_Meter_Type__c=='MS1' && InsJobRes.G_Meter_Installed__c    =='Yes' && InsJobRes.Original_G_Meter_refitted__c=='Yes'))
                            OldAssetObj.Location = MapLocationCode(InsJobRes.G_Meter_Location__c);
                    }
                }  

                if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Location__c) && !EON_Utility.validateRequired(MapLocationCode(InsJobRes.New_G_Meter_Location__c)) && !EON_Utility.validateRequired(apptIns.h_Job_Code__c) && (apptIns.h_Job_Code__c.containsignorecase('OOAREPOSELEC') || apptIns.h_Job_Code__c.containsignorecase('OOAREPOSGAS'))){
                    if(!EON_Utility.validateRequired(apptIns.Status__c)){
                        if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || (InsJobRes.New_E_Meter_Type__c=='MS1' && InsJobRes.E_Meter_Installed__c=='Yes' && InsJobRes.Original_E_Meter_refitted__c=='Yes') || (InsJobRes.New_G_Meter_Type__c=='MS1' && InsJobRes.G_Meter_Installed__c    =='Yes' && InsJobRes.Original_G_Meter_refitted__c=='Yes'))
                            OldAssetObj.Location = MapLocationCode(InsJobRes.New_G_Meter_Location__c);
                    }
                }
                //OwnerMarketParticipantId
                OldAssetObj.OwnerMarketParticipantId = !EON_Utility.validateRequired(apptIns.Gas_Map_Identifier__c) ? apptIns.Gas_Map_Identifier__c : '';

                if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Location__c)){
                    if(!EON_Utility.validateRequired(apptIns.Status__c)){
                        if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || (InsJobRes.New_E_Meter_Type__c=='MS1' && InsJobRes.E_Meter_Installed__c=='Yes' && InsJobRes.Original_E_Meter_refitted__c=='Yes') || (InsJobRes.New_G_Meter_Type__c=='MS1' && InsJobRes.G_Meter_Installed__c    =='Yes' && InsJobRes.Original_G_Meter_refitted__c=='Yes'))
                            NewAssetObj.Location = MapLocationCode(InsJobRes.New_G_Meter_Location__c);
                    }
                }  
                
                //Removed
                NewAssetObj.Removed='N';
                NewAssetRegister.Removed= 'N';
                if(InsJobRes.Original_G_Meter_refitted__c != 'Yes' && InsJobRes.G_Meter_Removed__c == 'Yes'){
                    OldAssetObj.Removed = 'Y';
                    OldAssetObj.Status = 'RE';
                    RegisterRemoved ='Y';
                }
                
                if(InsJobRes.Original_G_Meter_refitted__c == 'Yes' || InsJobRes.G_Meter_Removed__c=='No'){
                    OldAssetObj.Removed = 'N';
                    OldAssetObj.Status = 'LI';
                    RegisterRemoved ='N';
                }
                
                //Status
                NewAssetObj.Status = !EON_Utility.validateRequired(InsJobRes.G_Meter_Installed__c) ? ((InsJobRes.G_Meter_Installed__c.equalsIgnoreCase('Yes') && InsJobRes.Original_G_Meter_refitted__c != 'Yes') ? 'LI' :(InsJobRes.Original_G_Meter_refitted__c == 'Yes' || InsJobRes.G_Meter_Installed__c.equalsIgnoreCase('No') ? 'LI':'')) : '';
                
                //Register Information
                //Old Asset
                OldAssetRegister.Removed=RegisterRemoved;
                //Reading
                if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Register_Read__c))
                    OldAssetRegister.Reading = InsJobRes.G_Meter_Register_Read__c;
                //NumberOfDigits    
                if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Number_of_Digits__c))
                    OldAssetRegister.NumberOfDigits = InsJobRes.G_Meter_Number_of_Digits__c;
                listOldAssetRegister.add(OldAssetRegister);
                
                //Reading  
                if(!EON_Utility.validateRequired(InsJobRes.Opening_G_Meter_Reading__c))
                    NewAssetRegister.Reading = InsJobRes.Opening_G_Meter_Reading__c;
                //NumberOfDigits    
                if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Number_of_Digits__c))
                    NewAssetRegister.NumberOfDigits = InsJobRes.New_G_Meter_Number_of_Digits__c;
                //UnitsOfMeasure
                OldAssetRegister.UnitsOfMeasure = !EON_Utility.validateRequired(apptIns.G_Meter_Units_of_Measure__c) ? apptIns.G_Meter_Units_of_Measure__c : '';
                //MultiplicationFactor
                OldAssetRegister.MultiplicationFactor = !EON_Utility.validateRequired(apptIns.G_Meter_Multiplication_Factor__c) ? String.valueOf(apptIns.G_Meter_Multiplication_Factor__c) : '';
                listNewAssetRegister.add(NewAssetRegister);
                
                //Adding Register list to Array of Registers
                //Old Register List
                if(!listOldAssetRegister.isEmpty())
                    ArrayOldAssetRegister.CloseGasRegister=listOldAssetRegister;
                //New Rigister List   
                if(!listNewAssetRegister.isEmpty())
                    ArrayNewAssetRegister.CloseGasRegister=listNewAssetRegister;
            }
            
            if(OldAssetFlag){
                OldAssetObj.Registers=ArrayOldAssetRegister;
                ListGasMeter.add(OldAssetObj);
            }
            
            if(NewAssetFlag){
                NewAssetObj.Registers=ArrayNewAssetRegister;
                ListGasMeter.add(NewAssetObj);
            }
            
            if(!ListGasMeter.isEmpty())
                ArrayGasMeter.CloseGasMeter =ListGasMeter;
            CloseGasWorkObj.SiteVisit =  SiteVisitObj;
            CloseGasWorkObj.Transaction_x = GasTransactionObj; 
            CloseGasWorkObj.Meters = ArrayGasMeter;  
            reqCloseGasWorkObj.CloseGasWork = CloseGasWorkObj;       
            tracker.Request_Data__c = string.ValueOf(reqCloseGasWorkObj); 
            //Calling Web Service Method
            if(callMDSWS)
                respMDS = MDSObj.CloseJumboGasJob(reqCloseGasWorkObj);    //TODO: Replace CloseJumboGasJob?
            tracker.Response_Data__c =  String.valueof(respMDS);
            tracker.Status__c = EON_Utility.RESULT_PASS;  
            if(respMDS.Success)
                update new EON_Appointment__c(id=appointmentID, MDS_Close_Gas_Job__c='Dispatched');
            else{ 
                string Errors='';
                for(String str:respMDS.Errors.Message)
                    Errors=Errors+str+'\n'; 
                insert new Note(Title='Close Gas Job Failure',Body= Errors,ParentId=appointmentID);
                update new EON_Appointment__c(id=appointmentID, MDS_Close_Gas_Job__c='Failed to Dispatch');
            } 
            //Inserting MDS Data Tracker record    
            //insert tracker; 
            if(callMDSWS)
                allTracker.add(tracker); 
            insert allTracker;
              
        }
        catch(Exception ex){
            if(authToken.Error != '') {
                tracker.Response_Data__c=ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber()+'\n'+(!EON_Utility.validateRequired(tracker.Response_Data__c)?tracker.Response_Data__c:'')+'\nAuthentication Failure:\n'+authToken.Error;
            }
            else {
                tracker.Response_Data__c=ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber()+'\n'+(!EON_Utility.validateRequired(tracker.Response_Data__c)?tracker.Response_Data__c:'');
            }
            //system.debug('###Exception: '+ex.getMessage()+ex.getStackTraceString() );
            tracker.Status__c = EON_Utility.RESULT_FAIL;
            //Inserting MDS Data Tracker record 
            insert tracker; 
        }
    }
    
    /** 
        MapLocationCode(String value): This method is return the MDS Specific Location Code for Gas Location
    **/  
    public static String MapLocationCode(String lValue){
        if(lValue == 'Unknown')return '00';
        if(lValue == 'Cellar')return '01';
        if(lValue == 'Under Stairs')return '02';
        if(lValue == 'Hall')return '03';
        if(lValue == 'Kitchen')return '04';  
        if(lValue == 'Bathroom')return '05';
        if(lValue == 'Garage')return '06'; 
        if(lValue == 'Canteen')return '07';
        if(lValue == 'Cloakroom')return '08';
        if(lValue == 'Cupboard')return '09';
        if(lValue == 'Domestic Science')return '10';
        if(lValue == 'Front Door')return '11';
        if(lValue == 'Hall Cupboard')return '12';  
        if(lValue == 'Kitchen Cupboard')return '13';
        if(lValue == 'Kitchen under sink')return '14'; 
        if(lValue == 'Ladder Required')return '15';
        if(lValue == 'Landing')return '16';
        if(lValue == 'Office Cupboard')return '17';
        if(lValue == 'Outside WC')return '18';
        if(lValue == 'Pantry')return '19';
        if(lValue == 'Porch')return '20';
        if(lValue == 'Public Bar')return '21';
        if(lValue == 'Rear of Shop')return '22';
        if(lValue == 'Outside Box')return '23';  
        if(lValue == 'Saloon Bar')return '24';
        if(lValue == 'Shed')return '25'; 
        if(lValue == 'Shop Front')return '26';
        if(lValue == 'Shop Window')return '27';
        if(lValue == 'Store Room')return '28';
        if(lValue == 'Toilet')return '29';
        if(lValue == 'Under Counter')return '30';  
        if(lValue == 'Waiting Room')return '31';
        if(lValue == 'Meterbox Outside')return '32';
        if(lValue == 'Other')return '98';
        if(lValue == 'Outside')return '99'; 
        return null;                                      
    }
    
    /** 
        string IndCodeMeterType(string mType): Method to return industry coded Meter Type. 
    **/ 
    public static string IndCodeMeterType(string mType){
        list<EON_Gas_Meter_Mechanism__c> gMeterMechanism = new list<EON_Gas_Meter_Mechanism__c>();
        gMeterMechanism = [Select ID, Name, Code__c from EON_Gas_Meter_Mechanism__c where Name=:mType];
        if(!gMeterMechanism.isEmpty())
            if(!EON_Utility.validateRequired(gMeterMechanism[0])) 
            if(!EON_Utility.validateRequired(gMeterMechanism[0].Code__c))
            return gMeterMechanism[0].Code__c;
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
                    return !EON_Utility.validateRequired(abortRes.Gas_Abort_Reason__c) ? abortRes.Gas_Abort_Reason__c : null;
            }            
        }
        return null;
    }
    
    /**
        validateMPRNAtMDS(String appID) - this method validates the MAM or not.
    **/
    public static MDS_Data_Tracker__c validateMPRNAtMDS(Eon_Appointment__c appointment){
        MDS_Data_Tracker__c MDSData = new MDS_Data_Tracker__c();
        
        
        EON_MDS_ReqGasMAM.MAMValidationResponse mamCheck;
        if(appointment.MPRN__c != null){
            mamCheck = EON_MDS_ReqGasMAM.ValidateMPRNMAM(appointment.MPRN__c);
            MDSData = EON_MDS_ReqGasMAM.cTrack;
        }    
        
        if (appointment.MPRN__c != null && appointment.MPRN__c != '' &&
            mamCheck != null & !mamCheck.isError && mamCheck.effFromDate != null && 
            (mamCheck.effToDate == null || mamCheck.effToDate >= Date.today())) {                                    
                return MDSData;
            }else{
                if(MDSData != null){
                    MDSData.EON_Appointment__c = appointment.id;
                    insert MDSData;
                }    
                return MDSData; 
            }           
    }
}