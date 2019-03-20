/**
    Description : This class is for after creation of Gas jobs in Isis,communication of data to JUMBO to allow the job to also be raised on the jumbo system.
    VF Page     : None
    Test Class  : EON_Jumbo_New_Gas_Outbound_Job_Test 

**/
/*
    Created By  : Shruti Moghe
    Created On  : 09/05/2016
    Service Req : SR_EON_Jumbo_009
    Change History :
    CH01 # SR_EON_Jumbo_031 # 23/05/2016 # Mehboob Alam # Updated flag to Capture TechResponse Received.
    
*/

global with sharing class EON_Jumbo_New_Gas_Outbound_Job{ 
   
   /**
    createGasJobinJUMBO(String appId) : This Webservice method is invoked from Button Click on EON Appointment 
                                        which will Create the same Appointment in Jumbo.
   **/
   webservice static string createGasJobinJUMBO(String appId){
    string tranID = EON_Utility.GenUniqueNum(); //generating Unique number for transection ID
    JUMBO_Data_Tracker__c tracker = new JUMBO_Data_Tracker__c();
    List<EON_Appointment__c> apptIns= new List<EON_Appointment__c>(); // List to store Appointment Records
    Id apptID = Id.valueOf(appId);
    String response='';
    tracker.Direction__c = EON_Utility.DIRECTION_OUT ;
    tracker.Command__c = JUMBO_Utility.CMD_Insert_GasJUMBO; //command value for "CreateGasJobInJUMBO"
    apptIns =[select id, Name, MPRN__c, Request_Date__c, Request_Time__c, Appointment_Date__c,Start_Time__c,End_Appointment_Date__c,
              End_Time__c,Job_Code__r.Jumbo_Job_Code__c from EON_Appointment__c where id=:apptID limit 1];
    try{
        if(apptIns.size()>0){
            tracker.EON_Appointment__c=apptIns[0].id;
            EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
            EON_JUMBO_Work_Management_WS.JumboTechnicalResponse respJumbo = new EON_JUMBO_Work_Management_WS.JumboTechnicalResponse();
            //instantiating the ClientData 
            EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
            ClientInfo.Id =system.label.EON_Jumbo_Client_Id; //Client ID from Custom Label
            ClientInfo.Name =system.label.EON_Jumbo_Client_Name;//Client Name from Custom Label
            //instantiating the CreateGasWork
            EON_JUMBO_Work_Management_WS.CreateGasWork CreateGasWork = new EON_JUMBO_Work_Management_WS.CreateGasWork();
            
            //Mapping Values for  EarliestStartDate and EarliestStartTime
            CreateGasWork.EarliestStartDate= JUMBO_Utility.DateToString(apptIns[0].Appointment_Date__c);
            if(!EON_Utility.validateRequired(apptIns[0].Start_Time__c))
                 CreateGasWork.EarliestStartTime= String.valueof(apptIns[0].Start_Time__c);
                   else 
                    CreateGasWork.EarliestStartTime = '000000'; //hhmmss format
                  
            //Mapping values for LatestStartDate and LatestStartTime      
            if(!EON_Utility.validateRequired(apptIns[0].End_Appointment_Date__c))
                CreateGasWork.LatestStartDate= JUMBO_Utility.DateToString(apptIns[0].End_Appointment_Date__c);
                  else 
                    CreateGasWork.LatestStartDate= CreateGasWork.EarliestStartDate;
            if(!EON_Utility.validateRequired(apptIns[0].End_Time__c))
                CreateGasWork.LatestStartTime= JUMBO_Utility.TimeToString(apptIns[0].End_Time__c);
                   else
                    CreateGasWork.LatestStartTime= '000000'; //hhmmss format
            
            //Mapping values for Request Date and Request Time 
            if(!EON_Utility.validateRequired(apptIns[0].Request_Date__c))
                CreateGasWork.RequestDate= JUMBO_Utility.DateToString(apptIns[0].Request_Date__c);
                 else
                   CreateGasWork.RequestDate= JUMBO_Utility.DateToString(Date.today());
            if(!EON_Utility.validateRequired(apptIns[0].Request_Time__c)) 
                CreateGasWork.RequestTime= String.valueof(apptIns[0].Request_Time__c);
                 else
                   CreateGasWork.RequestTime= string.valueof(Datetime.now().format('hhmmss'));  //hhmmss format
            
            CreateGasWork.MPRN= String.valueof(apptIns[0].MPRN__c);
            CreateGasWork.ExternalJobReference= apptIns[0].Name; 
            
            
            CreateGasWork.JumboJobType= String.valueof(apptIns[0].Job_Code__r.Jumbo_Job_Code__c);
            
            //instantiating the request
            EON_JUMBO_Work_Management_WS.CreateGasWorkRequest request = new EON_JUMBO_Work_Management_WS.CreateGasWorkRequest();
            request.Client=clientInfo;
            request.CreateGasWork=CreateGasWork;            
            request.UniqueId =tranID;
            tracker.Request_Data__c = string.ValueOf(request);
            //Getting the response from Jumbo
            respJumbo = jumboObj.CreateJumboGasJob(request);
            tracker.Response_Data__c =  String.valueof(respJumbo);         
            if(respJumbo.Success){
                response='Request successfully sent to Jumbo';
                update new  EON_Appointment__c(id=apptID, Create_Gas_Job__c='TechResponse Received');  
            }
              else
                 for(String str:respJumbo.Errors.Message)
                     response = response+str+'\n';     
        }
          insert tracker;   
          return response;             
      }
      catch(Exception ex){         
         tracker.Response_Data__c = ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber()+'\n'+(!EON_Utility.validateRequired(tracker.Response_Data__c)?tracker.Response_Data__c:'');
         tracker.Status__c = EON_Utility.RESULT_FAIL;
         insert tracker; 
         return 'An Unknown error has occurred while creating this Appointment. Please contact to System Administrator'; 
      }                         
    }               
}