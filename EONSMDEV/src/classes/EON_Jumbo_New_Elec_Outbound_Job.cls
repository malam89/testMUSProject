/**
    Description : This class is used To provide Electricity Meter Point data relating to a specific MPAN using the MPAN as the matching key   
                  
    VF Page     : None
    Test Class  : EON_Jumbo_New_Elec_Outbound_Job_Test 

**/
/*
    Created By  : Purvi
    Created On  : 30/04/2016
    Service Req : SR_EON_Jumbo_006
    Change History
    CH01 # SR_EON_Jumbo_031 # 23/05/2016 # Mehboob Alam # Updated flag to Capture TechResponse Received.
   
*/
global with sharing class EON_Jumbo_New_Elec_Outbound_Job{ 
   
   /**
    createElecJobinJUMBO(String appId)
   **/
   webservice static string createElecJobinJUMBO(String appId){
    string tranID = EON_Utility.GenUniqueNum(); //generating random Unique number for transection ID
    JUMBO_Data_Tracker__c tracker = new JUMBO_Data_Tracker__c();
    List<EON_Appointment__c> apptIns = new List<EON_Appointment__c>();
    Id appointmentID = Id.valueOf(appId);
    String response='';
    tracker.Direction__c = EON_Utility.DIRECTION_OUT ;
    tracker.Command__c = JUMBO_Utility.CMD_Insert_ElecJUMBO;
    tracker.Transaction_ID__c = tranID;
    apptIns =[select id, Name, MPAN__c, Request_Date__c, Request_Time__c, Appointment_Date__c,Start_Time__c,End_Appointment_Date__c,End_Time__c,
              Job_Code__r.Jumbo_Job_Code__c from EON_Appointment__c where id=:appointmentID limit 1];

      try{
         if(apptIns.size()>0){
            tracker.EON_Appointment__c=apptIns[0].id;           
            EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
            EON_JUMBO_Work_Management_WS.JumboTechnicalResponse respJumbo = new EON_JUMBO_Work_Management_WS.JumboTechnicalResponse();
            EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
            ClientInfo.Id =system.label.EON_Jumbo_Client_Id;
            ClientInfo.Name =system.label.EON_Jumbo_Client_Name;
            EON_JUMBO_Work_Management_WS.CreateElecWork CreateElecWorkObj = new EON_JUMBO_Work_Management_WS.CreateElecWork();
            
            //Mapping Values for  EarliestStartDate and EarliestStartTime
            CreateElecWorkObj.EarliestStartDate= JUMBO_Utility.DateToString(apptIns[0].Appointment_Date__c);
            if(apptIns[0].Start_Time__c != null)
               CreateElecWorkObj.EarliestStartTime= JUMBO_Utility.TimeToString(apptIns[0].Start_Time__c);
                else 
                  CreateElecWorkObj.EarliestStartTime = '000000'; //hhmmss format
                  
            //Mapping values for LatestStartDate and LatestStartTime      
            if(apptIns[0].End_Appointment_Date__c != null)
               CreateElecWorkObj.LatestStartDate= JUMBO_Utility.DateToString(apptIns[0].End_Appointment_Date__c);
                else 
                  CreateElecWorkObj.LatestStartDate= CreateElecWorkObj.EarliestStartDate;
            if(apptIns[0].End_Time__c != null)
               CreateElecWorkObj.LatestStartTime= JUMBO_Utility.TimeToString(apptIns[0].End_Time__c);
                else
                  CreateElecWorkObj.LatestStartTime= '000000'; //hhmmss format
            
            //Mapping values for Request Date and Request Time 
            if(apptIns[0].Request_Date__c != null)
               CreateElecWorkObj.RequestDate= JUMBO_Utility.DateToString(apptIns[0].Request_Date__c);
                else
                  CreateElecWorkObj.RequestDate= JUMBO_Utility.DateToString(Date.today());
            if(apptIns[0].Request_Time__c != null) 
               CreateElecWorkObj.RequestTime= JUMBO_Utility.TimeToString(apptIns[0].Request_Time__c);
                else
                  CreateElecWorkObj.RequestTime= string.valueof(Datetime.now().format('hhmmss'));  //hhmmss format
                  
            CreateElecWorkObj.JumboJobType= String.valueof(apptIns[0].Job_Code__r.Jumbo_Job_Code__c); 
            CreateElecWorkObj.MPAN= String.valueof(apptIns[0].MPAN__c);
            CreateElecWorkObj.ExternalJobReference= String.valueof(apptIns[0].Name);
          
            EON_JUMBO_Work_Management_WS.CreateElecWorkRequest request = new EON_JUMBO_Work_Management_WS.CreateElecWorkRequest();
            request.Client=clientInfo;
            request.CreateElecWork= CreateElecWorkObj; 
            request.UniqueId = tranID; //assigning unique number value
            tracker.Request_Data__c = string.ValueOf(request); 
            //Calling CreateJumboElectricityJob Web Service method 
            respJumbo = jumboObj.CreateJumboElectricityJob(request);
            tracker.Response_Data__c =  String.valueof(respJumbo);
            tracker.Status__c = EON_Utility.RESULT_PASS;  
            if(respJumbo.Success){
                response='Request successfully sent to Jumbo';
                update new  EON_Appointment__c(id=appointmentID,Create_Electricity_Job__c='TechResponse Received');  
            }
              else
                 for(String str:respJumbo.Errors.Message)
                     response = response+str+'\n';                            
         }
          insert tracker;
          return response;             
      }
      catch(Exception ex){         
         tracker.Response_Data__c=ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber()+'\n'+(!EON_Utility.validateRequired(tracker.Response_Data__c)?tracker.Response_Data__c:'');
         tracker.Status__c = EON_Utility.RESULT_FAIL;
         insert tracker; 
         return 'An Unknown error has occurred while creating this appointment In Jumbo. Please contact to System Administrator'; 
      }                         
    }               
}