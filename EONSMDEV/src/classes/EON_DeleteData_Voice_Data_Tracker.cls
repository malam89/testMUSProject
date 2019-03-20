/**
    Description : This class is used for EON Job Results object trigger helper.
    Test Class : EON_Job_Results_Trigger_Stock_Test
**/

/*    
    Created By : Manish Jha
    Created Date : 26/10/2017
    Service Request : SR_OptiMUS_EON_118
    Change History
    CH01 # SR_OptiMUS_EON_218#14/02/2018 # Venkat # As per SR, Deleting Existing data from Recycle .
*/

public with sharing class EON_DeleteData_Voice_Data_Tracker implements Database.Batchable<sObject>{
   Exception[] errors = new Exception[0];   
   public Database.QueryLocator start(Database.BatchableContext BC){
      Date dToday = Date.today();
      Date dateIns= Date.newInstance(dToday.Year() , dToday.Month() , dToday.Day()-84);
      return Database.getQueryLocator([Select id from Voice_Data_Tracker__c where CreatedDate <: dateIns Limit 5]);
   }

   public void execute(Database.BatchableContext BC, List<sObject> scope){
     List<Voice_Data_Tracker__c> lTracker= new List<Voice_Data_Tracker__c>();
     for(sobject scp : scope){
     lTracker.add((Voice_Data_Tracker__c) scp); 
     }try{
     if(EON_DeleteTrackerDate_Scheduler_Test.genException==NULL)
        EON_DeleteTrackerDate_Scheduler_Test.genException=False;
     if(EON_DeleteTrackerDate_Scheduler_Test.genException==True)
         Id test=id.ValueOf('test');
      if(!lTracker.isEmpty())
      DELETE lTracker;
      Database.emptyRecycleBin(lTracker); //CH01
     }Catch(Exception e){errors.add(e);}
    }

   public void finish(Database.BatchableContext BC){
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
        System.debug('Total records'+a.TotalJobItems);
        if(!errors.isEmpty()){
                      System.debug('Errors--'+errors);
           }
        }
}