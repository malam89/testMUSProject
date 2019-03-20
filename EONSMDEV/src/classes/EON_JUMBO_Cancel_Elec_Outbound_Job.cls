/**
    Description : When a job is cancelled in EON Appointment object and JUMBO ID exists in the record then same job needs to cancelled in Jumbo.
                  This Webservice is invoked by 'Cancel Job' custom button on the appointment object
                  
    VF Page     : None
    Test Class  : EON_JUMBO_Cancel_Elec_Outbound_Job_Test 

**/
/*
    Created By  : Aruna manjari
    Created On  : 02/05/2016
    Service Req : SR_EON_Jumbo_008
    Change History : 
*/
global with sharing class EON_JUMBO_Cancel_Elec_Outbound_Job{
    
   /**
   CancelElectricJobinJumbo(String appId)
   **/
   webservice static string CancelElecJobinJUMBO(String appId){
     string tranID = EON_Utility.GenUniqueNum(); //generating random Unique number for transection ID
     Id appointmentID = Id.valueOf(appId);
     JUMBO_Data_Tracker__c tracker = new JUMBO_Data_Tracker__c();
     List<EON_Appointment__c> apptIns = new List<EON_Appointment__c>();
     tracker.Direction__c = EON_Utility.DIRECTION_OUT ;
     tracker.Command__c = Jumbo_Utility.CMD_Cancel_ElecJUMBO;
     tracker.Transaction_ID__c = tranID; 
     String response='';       
     apptIns =[select id,Name,JUMBO_ID__c,MPAN__c,Cancel_Reason__c from EON_Appointment__c where id=:appointmentID limit 1]; 
        try{
           if(!apptIns.isEmpty()){
               tracker.EON_Appointment__c=apptIns[0].id;
               EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
               EON_JUMBO_Work_Management_WS.JumboTechnicalResponse respJumbo = new EON_JUMBO_Work_Management_WS.JumboTechnicalResponse();
               //instantiating the ClientData 
               EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
               ClientInfo.Id =system.label.EON_Jumbo_Client_Id;
               ClientInfo.Name =system.label.EON_Jumbo_Client_Name;
               //instantiating the CancelElecWork
               EON_JUMBO_Work_Management_WS.CancelElecWork CancelElecWorkObj = new EON_JUMBO_Work_Management_WS.CancelElecWork();
               if(!EON_Utility.validateRequired(apptIns[0].Cancel_Reason__c)) CancelElecWorkObj.Reason=apptIns[0].Cancel_Reason__c;
               CancelElecWorkObj.ExternalJobReference=apptIns[0].Name;
               CancelElecWorkObj.JumboId=apptIns[0].JUMBO_ID__c;
               CancelElecWorkObj.MPAN=apptIns[0].MPAN__c;
               //instantiating the request
               EON_JUMBO_Work_Management_WS.CancelElecWorkRequest request = new EON_JUMBO_Work_Management_WS.CancelElecWorkRequest();
               request.Client=clientInfo;
               request.CancelElecWork=CancelElecWorkObj;
               request.UniqueId =tranID; 
               tracker.Request_Data__c = string.valueOf(request);
               respJumbo = jumboObj.CancelJumboElectricityJob(request);
               tracker.Response_Data__c =  String.valueof(respJumbo);
               tracker.Status__c = EON_Utility.RESULT_PASS; 
               if(respJumbo.Success){
                  response='Request successfully sent to Jumbo';
                  update new  EON_Appointment__c(id=appointmentID,Cancel_Electricity_Job__c='TechResponse Received');  
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