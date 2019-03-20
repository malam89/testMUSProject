/**
    Description     : This controller is used to re-send the Activity to OFSC if it is failed.
    Test Class      : EON_OFSC_Send_Appointment_test     
**/
/*
    Created By : Dharmendra Pahadiya
    Created Date : 19-Apr-2016
    Service Request : SR_EON_Scheduling_025
    Change History : 
*/
global with sharing class EON_OFSC_Send_Appointment_Scheduler implements Schedulable{

	global void execute(SchedulableContext SC){
		try{
			set<id> setAppId = new set<id>();
			string actType = EON_Utility.CMD_OFSC_CreateActivity;
			list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name, 
																			(select id, name, EON_Data_Tracker__c, JUMBO_Data_Tracker__c, Command__c from Oracle_Data_Tracker__r 
																			where Command__c =: actType order by createdDate desc limit 1) 
																			from EON_Appointment__c 
																			where Sent_to_Oracle__c= false /*or Sent_to_Oracle_Update__c =false) and createdDate = today*/ order by createdDate desc limit 10]);
			for(EON_Appointment__c objApp : lstApp){
				string eonTracker = '';
				string jumboTracker = '';
				//string activity = 'CREATE';
				for(Oracle_Data_Tracker__c objTra : objApp.Oracle_Data_Tracker__r){
					eonTracker = objTra.EON_Data_Tracker__c;
					jumboTracker = objTra.JUMBO_Data_Tracker__c;
					//activity = objTra.Command__c.containsIgnorecase('create')?'CREATE':'UPDATE';
				}
				EON_OFSC_Send_Appointment_Scheduler.sendActToOFSC(objApp.Id, 'CREATE', eonTracker, jumboTracker);}}catch(Exception Ex){System.debug('==>> OFSC Send retry: Exceptions:'+Ex.getMessage()+', '+Ex.getStackTraceString());}
	}

	@future(callout=true)
	public static void sendActToOFSC(string appId, string actType, string eonTra, string jumboTra){
		EON_OFSC_Send_Appointment.sendActivityToOFSC(appId, actType, eonTra, jumboTra, '', '', '');
	}

}