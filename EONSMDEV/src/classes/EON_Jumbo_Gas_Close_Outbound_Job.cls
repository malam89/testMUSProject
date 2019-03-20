/**
    Description : This class is invoked through a trigger on ‘EON Appointment’ Object to call a Close Gas Job Web Service Method in Jumbo
                  
    VF Page     : None
    Test Class  : EON_Jumbo_Gas_Close_Outbound_Job_Test 

**/
/*
    Created By  : Mehboob Alam
    Created On  : 20/07/2016
    Service Req : SR_EON_Jumbo_042
    Change History :
    CH01 # SR_EON_Jumbo_050 # 02/08/2016 # Mahadev J # Mapping for Market Participent ID
    CH02 # SR_EON_Jumbo_053 # 04/08/2016 # Mahadev J # Change in mapping for G Meter Type and G Meter Manufacturer.
    CH03 # SR_EON_Jumbo_057 # 12/08/2016 # Reddeiah R # Remove the mapping values- Comment,Status,StatusChangeReason.
    CH04 # SR_EON_Jumbo_068 # 04/10/2016 # Puneet Mehta # Changed the mapping for Location based on Job Code
    CH05 # SR_EON_Jumbo_070 # 11/02/2016 # Mahadev J # Amended logic to calculate 'Abort Reason' as per Jumbo mapping
    CH06 # SR_EON_Jumbo_075 # 11/02/2016 # Mahadev J # Updated mapping for location for aborted job
    CH07 # SR_EON_Jumbo_077 # 15/11/2016 # Mahadev J # Added mapping for JUMBOJobType
    CH08 # SR_EON_Jumbo_080 # 16/11/2016 # Aruna Manjari # Added the condition that 'StatusChangeReason' would only be sent to JUMBO  when the  appointment status = 'ABORTED' and ignored in all other circumstances.
    CH09 # SR_EON_Jumbo_090 # 09/12/2016 # Mahadev J # Improved mapping
    CH10 # SR_EON_Jumbo_091 # 09/12/2016 # Mahadev J # Added mapping for Gas Map Identifier
    CH11 # SR_EON_Jumbo_096 # 11/01/2017 # Mahadev J # Added mapping
    CH12 # SR_EON_Jumbo_097 # 13/01/2017 # Mahadev J # Updated mapping
    CH13 # SR_EON_Jumbo_108 # 03/04/2017 # Akshay Bairagi # Updated logic for aborted jobs as per SR
    CH14 # SR_EON_Jumbo_112 # 03/04/2017 # Akshay Bairagi # Updated logic for aborted jobs as per SR
    CH15 # SR_EON_Jumbo_116 # 02/06/2017 # Praveen G # changes to stop close Gas job call if we are not MAM.
    CH16 # INCUK0005753030 # 14/06/2017 # Praveen G # Added condion for Aborted.
    CH17 # SR_EON_Jumbo_117 # 27/06/2017 # Praveen G # Stop close gas job for the jobcode - OOAEINSTALLBIND.
    CH18 # SR_OptiMUS_EON_167 # 06/11/2017 # Mehboob Alam # Changed the mapping for G Meter Type.
    CH19 # SR_OptiMUS_EON_214 # 15/02/2018 # Mehboob Alam # new mapping for Smart Meter Type.
    CH20 #SR_EON_Jumbo_118  # 21/06/2018 # Shruti Moghe # Updated logic to send field values when it is aborted 
    CH21 # SR_OptiMUS_EON_276# 29/08/2018 # Shruti Moghe # updated mapping for Gas Meter Location
    
*/

public with sharing class EON_Jumbo_Gas_Close_Outbound_Job{
    
    /**
    closeGasJobJUMBO(String appId) -  Method to close Gas Job
    **/
    @future (callout=true)
    public static void closeGasJobJUMBO(String appId, boolean callMAM){ //CH05.New boolean paramter
    
        boolean callJumboWS = true; //CH05.New
        list<JUMBO_Data_Tracker__c> allTracker = new list<JUMBO_Data_Tracker__c>(); //CH05.New
        string tranID = EON_Utility.GenUniqueNum(); //generating random Unique number for transection ID
        JUMBO_Data_Tracker__c tracker = new JUMBO_Data_Tracker__c();
        EON_Appointment__c apptIns = new EON_Appointment__c();
        Id appointmentID = Id.valueOf(appId);
        boolean OldAssetFlag = false;
        boolean NewAssetFlag = false;
        string RegisterRemoved ='';
        tracker.Direction__c = EON_Utility.DIRECTION_OUT ;
        tracker.Command__c = JUMBO_Utility.CMD_Close_GasJUMBO;
        tracker.Transaction_ID__c = tranID;
        tracker.EON_Appointment__c=appointmentID; 
        
        try{  
            apptIns =[select id, Name, MPRN__c,JUMBO_ID__c,h_Metering_Pressure__c,Gas_Market_Participant_ID__c,h_Job_Code__c, Status__c, Gas_Map_Identifier__c, G_Meter_Year_of_Manufacture__c, 
                 G_Meter_Type__r.Industry_Code__c, G_Meter_Measuring_Capacity__c, G_Meter_Units_of_Measure__c, G_Meter_Multiplication_Factor__c,/*CH04, CH06, CH07, CH10, CH11*/
                 Job_Code__c, Job_Code__r.Jumbo_Job_Code__c, (select id,Name,Time_On_Site__c,Time_Closed__c,Site_Left_Energised__c, Original_G_Meter_refitted__c,h_Abort_Reason__c,
                 Gas_Supply_Capped__c,G_Meter_Location__c,G_Meter_Version__c,New_G_Meter_Version__c,G_Meter_Manufacturer__c,h_G_Meter_Manufacturer__c,New_G_Meter_Manufacturer__c,h_New_G_Meter_Manufacturer__c,
                 Removed_G_Meter_Location__c,New_G_Meter_Location__c,G_Meter_Removed__c,G_Meter_Type__c,New_G_Meter_Type__c,G_Meter_Register_ID__c,New_G_Meter_Number_of_digits__c,G_Meter_Register_Read__c,
                 Abort_Comments__c,Job_Status__c,Abort_Reason__c,Work_Summary__c,G_Meter_Serial_Number__c,Removed_G_Meter_Serial_Number__c,New_G_Meter_Serial_Number__c,
                 G_Meter_Number_of_Digits__c,Opening_G_Meter_Reading__c, G_Meter_Installed__c,New_E_Meter_Type__c,E_Meter_Installed__c,Original_E_Meter_refitted__c /*CH12*/ from EON_Job_Results__r)from EON_Appointment__c where id=:appointmentID limit 1];
            
            //CH17.Start
            if(apptIns.h_Job_Code__c == 'OOAEINSTALLBIND' && 
                    (apptIns.status__c == 'COMPLETED' || apptIns.status__c == 'ABORTED'))
                return;
            //CH17.End
                       
            
             //CH15.Start
             boolean G_StatusTosendMPRN=false;
            if(!apptIns.EON_Job_Results__r.isEmpty()){
            EON_Job_Results__c InsJobRes1 =  apptIns.EON_Job_Results__r[0];
            if(InsJobRes1.New_G_Meter_Type__c=='MS1' && InsJobRes1.G_Meter_Installed__c=='Yes' && InsJobRes1.Original_G_Meter_refitted__c=='No'){ G_StatusTosendMPRN=true;}
            }
            if(!Test.isRunningTest() && apptIns.Status__c == 'ABORTED' && G_StatusTosendMPRN==false){//CH16
                JUMBO_Data_Tracker__c jumboTracker = validateMPRNAtJUMBO(apptIns);                
                if(jumboTracker!= null && jumboTracker.id != null)
                    return;                
                allTracker.add(jumboTracker);
            }
            //CH15.End
                     
       
        //BasicHttpBinding_IWorkManagement - Instantiating main method     
        EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
        
        
        jumboObj.inputHttpHeaders_x = new Map<String, String>();
            string Access_Token ='eyJhbGciOiJSUzI1NiIsImtpZCI6ImY2NTNlMzQ2MGEwNWQ1ZGExYWE1ZjBlMzdhMmRjNzdkIiwidHlwIjoiSldUIn0.eyJuYmYiOjE1NDg5NDU5NzIsImV4cCI6MTU0OTAzMjM3MiwiaXNzIjoiaHR0cDovL21ubW9uZ28xMXZ4OjgwMDAiLCJhdWQiOlsiaHR0cDovL21ubW9uZ28xMXZ4OjgwMDAvcmVzb3VyY2VzIiwiTXVzTW9wR2F0ZXdheUFjY2Vzc0FwaSJdLCJjbGllbnRfaWQiOiJNdXNNb3BHYXRld2F5QWNjZXNzIiwic3ViIjoiMiIsImF1dGhfdGltZSI6MTU0ODk0NTk3MiwiaWRwIjoibG9jYWwiLCJzY29wZSI6WyJNdXNNb3BHYXRld2F5QWNjZXNzQXBpU2NvcGUiXSwiYW1yIjpbInB3ZCJdfQ.125kZ1ORfKN5E74Gz0fF4smoBKCL8vzSLUMq3PhEeVm4O04kRo3JtYJecOS3q5cav5Ty_y2rEISdQYWmIpC_2m4xd1CK_XJcSPU-AA0LaXMdDy6e9HEmkwqY9c_qgDajUkby8pbD8qm-Ol-4zlqhKC5nxwCNJB1M8vrWmgl7jMZc-ZXBfWmE25VNAFsK365sWvmSr9oUN3oJlR30-Kevd1YRU-bRdYc4Tx5IAhOF-zB9Xme5tI2QrCOAQgTsU3ybkV1Tooiv2aeORHtgyDTwL8mpMUAaQm3_cgoZuAwF5oGcKsk6PzYcV6YWblyCLFqGFv3QOvY2cQwpMjWzYfxDIA';
       
            //jumboObj.inputHttpHeaders_x.put('Authorization','Bearer ' + Access_Token);
            
        //JumboTechnicalResponse - Instantiating response object 
        EON_JUMBO_Work_Management_WS.JumboTechnicalResponse respJumbo = new EON_JUMBO_Work_Management_WS.JumboTechnicalResponse();
        
        //ClientData Instantiating clientData
        EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
        ClientInfo.Id =system.label.EON_Jumbo_Client_Id;
        ClientInfo.Name =system.label.EON_Jumbo_Client_Name;
           
        //Instantiating main request Object for Close Gas Job
        EON_JUMBO_Work_Management_WS.CloseGasWorkRequest reqCloseGasWorkObj = new EON_JUMBO_Work_Management_WS.CloseGasWorkRequest();
        reqCloseGasWorkObj.Client=clientInfo;
        reqCloseGasWorkObj.UniqueId = tranID;
         
        //CloseGasWork - Instantiating Object
        EON_JUMBO_Work_Management_WS.CloseGasWork CloseGasWorkObj = new EON_JUMBO_Work_Management_WS.CloseGasWork();
        //SiteVisit - Instantiating Object
        EON_JUMBO_Work_Management_WS.SiteVisit SiteVisitObj = new EON_JUMBO_Work_Management_WS.SiteVisit();
        //GasTransaction - Instantiating Object
        EON_JUMBO_Work_Management_WS.GasTransaction GasTransactionObj = new EON_JUMBO_Work_Management_WS.GasTransaction();
           
        //CloseGasMeter - Instantiating Object for Old Assets
        EON_JUMBO_Work_Management_WS.CloseGasMeter OldAssetObj = new EON_JUMBO_Work_Management_WS.CloseGasMeter();
        //CloseGasMeter - Instantiating Object for New Assets
        EON_JUMBO_Work_Management_WS.CloseGasMeter NewAssetObj = new EON_JUMBO_Work_Management_WS.CloseGasMeter();
           
        //ArrayOfCloseGasMeter - Array to populate all Close Meters 
        EON_JUMBO_Work_Management_WS.ArrayOfCloseGasMeter ArrayGasMeter  = new EON_JUMBO_Work_Management_WS.ArrayOfCloseGasMeter();
        List<EON_JUMBO_Work_Management_WS.CloseGasMeter> ListGasMeter= new List<EON_JUMBO_Work_Management_WS.CloseGasMeter>();
           
        //ArrayOfGasRegister - Array to populate all Registers for Old Asset
        EON_JUMBO_Work_Management_WS.ArrayOfCloseGasRegister ArrayOldAssetRegister  = new  EON_JUMBO_Work_Management_WS.ArrayOfCloseGasRegister();
        
        //ArrayOfGasRegister - Array to populate all Registers for New Asset
        EON_JUMBO_Work_Management_WS.ArrayOfCloseGasRegister ArrayNewAssetRegister  = new  EON_JUMBO_Work_Management_WS.ArrayOfCloseGasRegister();
        //List to contain old Asset Register
        List<EON_JUMBO_Work_Management_WS.CloseGasRegister> listOldAssetRegister = new List<EON_JUMBO_Work_Management_WS.CloseGasRegister>();
        //List to contain New Asset Register
        List<EON_JUMBO_Work_Management_WS.CloseGasRegister> listNewAssetRegister = new List<EON_JUMBO_Work_Management_WS.CloseGasRegister>();
        //CloseGasRegister - Instantiating Registers for Old Assets
        EON_JUMBO_Work_Management_WS.CloseGasRegister  OldAssetRegister  = new EON_JUMBO_Work_Management_WS.CloseGasRegister();
        //CloseGasRegister - Instantiating Registers for New Assets
        EON_JUMBO_Work_Management_WS.CloseGasRegister NewAssetRegister = new EON_JUMBO_Work_Management_WS.CloseGasRegister(); //CH01.New
           
        //MPRN 
        if(!EON_Utility.validateRequired(apptIns.MPRN__c))
            CloseGasWorkObj.MPRN = apptIns.MPRN__c;
                
        //JumboId   
        if(!EON_Utility.validateRequired(apptIns.JUMBO_ID__c))
            CloseGasWorkObj.JumboId = apptIns.JUMBO_ID__c;
             
        //MeterLink
        CloseGasWorkObj.MeterLink ='F';
             
        //ExternalJobReference   
        if(!EON_Utility.validateRequired(apptIns.Name))
                CloseGasWorkObj.ExternalJobReference = apptIns.Name;
        
        //JUMBOJobType //CH07.New
        if(!EON_Utility.validateRequired(apptIns.Job_Code__c)){
            if(!EON_Utility.validateRequired(apptIns.Job_Code__r.Jumbo_Job_Code__c))
                CloseGasWorkObj.JumboJobType = apptIns.Job_Code__r.Jumbo_Job_Code__c;
        }
            
        //SupplierMarketParticipantId   
        if(!EON_Utility.validateRequired(apptIns.Gas_Market_Participant_ID__c))
            CloseGasWorkObj.SupplierMarketParticipantId = apptIns.Gas_Market_Participant_ID__c;
                
        if(!apptIns.EON_Job_Results__r.isEmpty()){
            EON_Job_Results__c InsJobRes =  apptIns.EON_Job_Results__r[0];
        //Mapping Job Result values
          //CH20.start
        boolean G_StatusTosend=false;
        if(InsJobRes.New_G_Meter_Type__c=='MS1' && InsJobRes.G_Meter_Installed__c=='Yes' && InsJobRes.Original_G_Meter_refitted__c=='No') G_StatusTosend=true;
        //CH20.end       
        //StartDate 
        if(!EON_Utility.validateRequired(InsJobRes.Time_On_Site__c))
            SiteVisitObj.StartDate = JUMBO_Utility.DateToString(InsJobRes.Time_On_Site__c.date());
                 
        //StartTime  
        if(!EON_Utility.validateRequired(InsJobRes.Time_On_Site__c))
            SiteVisitObj.StartTime = InsJobRes.Time_On_Site__c.format('HHmmss'); //Sending time in HHMMSS format
                   
        //EndDate   
        if(!EON_Utility.validateRequired(InsJobRes.Time_Closed__c))
            SiteVisitObj.EndDate = JUMBO_Utility.DateToString(InsJobRes.Time_Closed__c.date());
                   
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
                    if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || G_StatusTosend)//CH20
                        CloseGasWorkObj.Location = MapLocationCode(InsJobRes.G_Meter_Location__c);                  
                }
            }
        }
        //CH04.START
        if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Location__c) && !EON_Utility.validateRequired(MapLocationCode(InsJobRes.New_G_Meter_Location__c)) && !EON_Utility.validateRequired(apptIns.h_Job_Code__c) && (apptIns.h_Job_Code__c.containsignorecase('OOAREPOSELEC') || apptIns.h_Job_Code__c.containsignorecase('OOAREPOSGAS'))){CloseGasWorkObj.Location = MapLocationCode(InsJobRes.New_G_Meter_Location__c);}
        //CH04.END
        //MeteringPressure
        if(!EON_Utility.validateRequired(apptIns.h_Metering_Pressure__c))
            CloseGasWorkObj.MeteringPressure = apptIns.h_Metering_Pressure__c;
        //CH05.New.Start         
         if(!EON_Utility.validateRequired(InsJobRes.Abort_Reason__c)){
            //commented out GasTransactionObj.StatusChangeReason = AbortReasonCode(InsJobRes.Abort_Reason__c);
             //CH08.Start
            if(apptIns.Status__c == 'ABORTED' && G_StatusTosend==false){//Ch20
                //CH14.Start
                if( !InsJobRes.G_Meter_Installed__c.equalsIgnoreCase('Yes') && InsJobRes.Original_G_Meter_refitted__c != 'Yes' && !InsJobRes.h_Abort_Reason__c.equalsIgnoreCase('true'))     GasTransactionObj.StatusChangeReason = AbortReasonCode(InsJobRes.Abort_Reason__c);
                if(InsJobRes.G_Meter_Installed__c.equalsIgnoreCase('Yes'))//CH13
                     GasTransactionObj.StatusChangeReason = AbortReasonCode(InsJobRes.Abort_Reason__c);
                //CH14.End
                system.debug('Value of GasTransactionObj.StatusChangeReason %%%%%%' +GasTransactionObj.StatusChangeReason);
                system.debug('Value of InsJobRes.Abort_Reason__c %%%%' +InsJobRes.Abort_Reason__c );
            }//CH08.End
         }   
       //CH03.Start
         /*         
        //Comment
        if(!EON_Utility.validateRequired(InsJobRes.Abort_Reason__c))
            GasTransactionObj.Comment = InsJobRes.Abort_Reason__c;
                  
        //Status
        if(!EON_Utility.validateRequired(InsJobRes.Job_Status__c))
            GasTransactionObj.Status = InsJobRes.Job_Status__c;
                  
        //StatusChangeReason
        if(!EON_Utility.validateRequired(InsJobRes.Abort_Reason__c))
            GasTransactionObj.StatusChangeReason = InsJobRes.Abort_Reason__c;
           */   
            //CH03.End 
        //Status //CH09.New
        GasTransactionObj.Status = !EON_Utility.validateRequired(apptIns.Status__c) ? ((apptIns.Status__c.equalsIgnoreCase('Aborted') && G_StatusTosend==false)? 'ABORT' : ((apptIns.Status__c.equalsIgnoreCase('Completed') || G_StatusTosend )? 'COMLT' : '')) : '';//CH20
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
            
        //YearOfManufacture CH11.New
        OldAssetObj.YearOfManufacture = !EON_Utility.validateRequired(apptIns.G_Meter_Year_of_Manufacture__c) ? apptIns.G_Meter_Year_of_Manufacture__c : '';
        
        //Type_x CH11.New
        OldAssetObj.Type_x = !EON_Utility.validateRequired(apptIns.G_Meter_Type__r.Industry_Code__c) ? apptIns.G_Meter_Type__r.Industry_Code__c : '';
        
        //MeasuringCapacity CH11.New
        OldAssetObj.MeasuringCapacity = !EON_Utility.validateRequired(apptIns.G_Meter_Measuring_Capacity__c) ? apptIns.G_Meter_Measuring_Capacity__c : '';
                
        //Mechanism
        if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Type__c))
            if(!EON_Utility.validateRequired(IndCodeMeterType(InsJobRes.G_Meter_Type__c)))
                OldAssetObj.Mechanism = IndCodeMeterType(InsJobRes.G_Meter_Type__c);
        //CH02.New.Start
        if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Type__c))
            if(!EON_Utility.validateRequired(EON_Utility.smartMeterModel('Gas',InsJobRes.New_G_Meter_Type__c,InsJobRes.New_G_Meter_Manufacturer__c,InsJobRes.New_G_Meter_Version__c))) //CH19
                NewAssetObj.Mechanism = EON_Utility.smartMeterModel('Gas',InsJobRes.New_G_Meter_Type__c,InsJobRes.New_G_Meter_Manufacturer__c,InsJobRes.New_G_Meter_Version__c); //CH19
        //CH02.New.End
         //CH02.Old
        /*if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Type__c))
            if(!EON_Utility.validateRequired(IndCodeMeterType(InsJobRes.New_G_Meter_Type__c)))
                NewAssetObj.Mechanism = IndCodeMeterType(InsJobRes.New_G_Meter_Type__c); */
    
        //Model
        if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Version__c))
            OldAssetObj.Model = InsJobRes.G_Meter_Version__c;
        if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Version__c))
            NewAssetObj.Model = InsJobRes.New_G_Meter_Version__c;

        //Manufacturer
        if(!EON_Utility.validateRequired(InsJobRes.h_G_Meter_Manufacturer__c))
            OldAssetObj.Manufacturer = InsJobRes.h_G_Meter_Manufacturer__c;  //CH02
        if(!EON_Utility.validateRequired(InsJobRes.h_New_G_Meter_Manufacturer__c))
            NewAssetObj.Manufacturer = InsJobRes.h_New_G_Meter_Manufacturer__c; //CH02
                    
        //Location //CH06.Update
        if(!EON_Utility.validateRequired(InsJobRes.G_Meter_Location__c)){
            if(!EON_Utility.validateRequired(apptIns.Status__c)){
                if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || G_StatusTosend)//CH20
                    OldAssetObj.Location = MapLocationCode(InsJobRes.G_Meter_Location__c);
            }
        }  
        //CH04.START  //CH06.Update
        if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Location__c) && !EON_Utility.validateRequired(MapLocationCode(InsJobRes.New_G_Meter_Location__c)) && !EON_Utility.validateRequired(apptIns.h_Job_Code__c) && (apptIns.h_Job_Code__c.containsignorecase('OOAREPOSELEC') || apptIns.h_Job_Code__c.containsignorecase('OOAREPOSGAS'))){
            if(!EON_Utility.validateRequired(apptIns.Status__c)){
                if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || G_StatusTosend)//CH20
                    OldAssetObj.Location = MapLocationCode(InsJobRes.New_G_Meter_Location__c);
            }
        }
        //OwnerMarketParticipantId //CH10
         system.debug('-------------->'+apptIns.Gas_Map_Identifier__c);
        OldAssetObj.OwnerMarketParticipantId = !EON_Utility.validateRequired(apptIns.Gas_Map_Identifier__c) ? apptIns.Gas_Map_Identifier__c : '';
        system.debug('-------------->'+OldAssetObj.OwnerMarketParticipantId);
        
        //CH04.END
        //CH06.Update
        if(!EON_Utility.validateRequired(InsJobRes.New_G_Meter_Location__c)){
            if(!EON_Utility.validateRequired(apptIns.Status__c)){
                if(!apptIns.Status__c.equalsIgnoreCase('Aborted') || G_StatusTosend)//CH20
                    NewAssetObj.Location = MapLocationCode(InsJobRes.New_G_Meter_Location__c);
            }
        }  
                
        //Removed
        NewAssetObj.Removed='N';
        NewAssetRegister.Removed= 'N';
        if(InsJobRes.Original_G_Meter_refitted__c != 'Yes' && InsJobRes.G_Meter_Removed__c == 'Yes'){ //CH13
            OldAssetObj.Removed = 'Y';
            OldAssetObj.Status = 'RE'; //CH12
            RegisterRemoved ='Y';
        }
                     
        if(InsJobRes.Original_G_Meter_refitted__c == 'Yes' || InsJobRes.G_Meter_Removed__c=='No'){//CH14
            OldAssetObj.Removed = 'N';
            OldAssetObj.Status = 'LI'; //CH12
            RegisterRemoved ='N';
        }
        
        //Status //CH12//CH13
        NewAssetObj.Status = !EON_Utility.validateRequired(InsJobRes.G_Meter_Installed__c) ? ((InsJobRes.G_Meter_Installed__c.equalsIgnoreCase('Yes') && InsJobRes.Original_G_Meter_refitted__c != 'Yes') ? 'LI' :(InsJobRes.Original_G_Meter_refitted__c == 'Yes' || InsJobRes.G_Meter_Installed__c.equalsIgnoreCase('No') ? 'LI':'')) : '';
                    
        //Register Information
        //Old Asset//CH01.Start
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
        //UnitsOfMeasure //CH11.New
        OldAssetRegister.UnitsOfMeasure = !EON_Utility.validateRequired(apptIns.G_Meter_Units_of_Measure__c) ? apptIns.G_Meter_Units_of_Measure__c : '';
        //MultiplicationFactor //CH11.New
        OldAssetRegister.MultiplicationFactor = !EON_Utility.validateRequired(apptIns.G_Meter_Multiplication_Factor__c) ? String.valueOf(apptIns.G_Meter_Multiplication_Factor__c) : '';
        listNewAssetRegister.add(NewAssetRegister);
        
        //Adding Register list to Array of Registers
        //Old Register List
        if(!listOldAssetRegister.isEmpty())
            ArrayOldAssetRegister.CloseGasRegister=listOldAssetRegister;
        //New Rigister List   
        if(!listNewAssetRegister.isEmpty())
            ArrayNewAssetRegister.CloseGasRegister=listNewAssetRegister;
        //CH01.End
        
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
        if(callJumboWS) //CH05.New
            respJumbo = jumboObj.CloseJumboGasJob(reqCloseGasWorkObj);
        tracker.Response_Data__c =  String.valueof(respJumbo);
        tracker.Status__c = EON_Utility.RESULT_PASS;  
        if(respJumbo.Success)
            update new EON_Appointment__c(id=appointmentID, Close_Gas_Job__c='Dispatched');
        else{ 
            string Errors='';
            for(String str:respJumbo.Errors.Message)
                Errors=Errors+str+'\n'; 
                insert new Note(Title='Close Gas Job Failure',Body= Errors,ParentId=appointmentID);
                update new EON_Appointment__c(id=appointmentID, Close_Gas_Job__c='Failed to Dispatch');
        } 
        //Inserting Jumbo Data Tracker record    
        //insert tracker; //CH05.Old
        if(callJumboWS)   //CH12.New
          allTracker.add(tracker);  //CH05.New
         insert allTracker;   //CH05.New
    }
    catch(Exception ex){         
        system.debug('###Exception: '+ex.getMessage()+ex.getStackTraceString() );
        tracker.Response_Data__c=ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber()+'\n'+(!EON_Utility.validateRequired(tracker.Response_Data__c)?tracker.Response_Data__c:'');
        tracker.Status__c = EON_Utility.RESULT_FAIL;
        //Inserting Jumbo Data Tracker record 
        insert tracker; 
    }
}
    

    /** 
        MapLocationCode(String value): This method is return the Jumbo Specific Location Code for Gas Location
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
          //if(lValue == 'Meter box Outside')return '32'; //CH21.old 
          //if(lValue == 'Other 7')return '98';  //CH21.old
           if(lValue == 'Meterbox Outside')return '32'; //CH21.new
            if(lValue == 'Other')return '98';//CH21.New
          if(lValue == 'Outside')return '99'; 
        return null;                                      
    }
  
  
    /** 
        string IndCodeMeterType(string mType): Method to return industry coded Meter Type. 
    **/ 
    public static string IndCodeMeterType(string mType){
         //CH02.New.Start
        list<EON_Gas_Meter_Mechanism__c> gMeterMechanism = new list<EON_Gas_Meter_Mechanism__c>();
        gMeterMechanism = [Select ID, Name, Code__c from EON_Gas_Meter_Mechanism__c where Name=:mType];
        if(!gMeterMechanism.isEmpty())
            if(!EON_Utility.validateRequired(gMeterMechanism[0])) 
                if(!EON_Utility.validateRequired(gMeterMechanism[0].Code__c))
                    return gMeterMechanism[0].Code__c;
        //CH02.New.End
        return null;
    }
    
    /**
    string IndCodeNewMeterType(): This method will return mapping for New G Meter Type to Jumbo
  **/
  /*CH19.Start
    //CH02.Start
    public static string IndCodeNewMeterType(string mType,string Manufacturer, string Version){
        if(mType=='MS1'){
         //CH18.Start   
          if(!EON_Utility.validateRequired(Manufacturer) && !EON_Utility.validateRequired(Version)){
             if(Manufacturer=='Elster Metering Ltd' && Version=='BKG4 SC')
                return 'S1';
             if(Manufacturer=='Elster Metering Ltd' && Version=='BKG4')
                return 'S1';
             if(Manufacturer=='Secure Meters' && Version=='EG4V 10')
                return 'S1';
             if(Manufacturer=='Landis & Gyr' && Version=='G470')
                return 'S2';
             if(Manufacturer=='EDMI EUROPE LIMITED' && Version=='GS60')
                return 'S2';
             if(Manufacturer=='EDMI EUROPE LIMITED' && Version=='GS60A')
                return 'S2';
          } //CH18.End  
        }
        if(mType=='MCL') return 'CR';
        if(mType=='PP') return 'PP';
        return null;
    }
    //CH02.End
    CH19.End*/
    
    /**
    String AbortReasonCode(String abortReason): This method will return jumbo specific abort code //CH05.New
  **/
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
    
    //CH15.Start
    /**
        validateMPRNAtJUMBO(String appID) - this method validates the MAM or not.
    **/
    public static JUMBO_Data_Tracker__c validateMPRNAtJUMBO(Eon_Appointment__c appointment){
        JUMBO_Data_Tracker__c jumboData = new JUMBO_Data_Tracker__c();
        
        
        EON_Jumbo_ReqGasMAM.MAMValidationResponse mamCheck;		//TODO.Start	//Call EON_Jumbo_ReqGasMAM
        if(appointment.MPRN__c != null){
            mamCheck = EON_Jumbo_ReqGasMAM.ValidateMPRNMAM(appointment.MPRN__c);
            jumboData = EON_Jumbo_ReqGasMAM.cTrack;		//TODO.End
        }    
        
        if (appointment.MPRN__c != null && appointment.MPRN__c != '' &&
                    mamCheck != null & !mamCheck.isError && mamCheck.effFromDate != null && 
                    (mamCheck.effToDate == null || mamCheck.effToDate >= Date.today())) {                                    
            return jumboData;
        }else{
            if(jumboData != null){
                jumboData.EON_Appointment__c = appointment.id;
                insert jumboData;
            }    
            return jumboData; 
        }           
    }
    
    //CH15.End
}