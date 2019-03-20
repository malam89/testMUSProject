/**
    Description :    This class is used to send Work Order Assignment to IFS in batch                   
    Test Class  :    
**/
/*
    Created By  : Shruti Moghe
    Created On  : 10/05/2017
    Service Req : SR_OptiMUS_NG_044
    Change History
    CH01 # 16/06/2017 # SR_OptiMUS_NG_051 # Shruti Moghe # Added condition for considering appointments based on status and to send the appointment of three days on friday

    

*/
global class  NGS_S3_Send_WOAssignment_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    public static List<NGS_Work_Order_Appointment__c> AppttoUpdate = new List<NGS_Work_Order_Appointment__c>();
    Public static String batchresult='';
/** 
    Database.queryLocator start(Database.BatchableContext BC) - start method
**/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {    
        //CH01.start
        String dayOfWeek =  (system.now()).format('E');
        // dayOfWeek is Sun, Mon, Tue, etc.
        system.debug(dayOfWeek);
        if(dayOfWeek=='Fri')
        return Database.getQueryLocator('select id, name,Appointment_Start_Time__c,Assignment_sent_to_IFS__c,Cancellation_Notes__c, h_IFS_Duration__c,Duration__c,Employee_ID__c, Employee_ID__r.name, Employee_ID__r.Technician_Name__c,(select id, note__c from NGS_Notes__r) from NGS_Work_Order_Appointment__c where Appointment_Start_Time__c >=TOMORROW and  Appointment_Start_Time__c <=TOday+3 and Assignment_sent_to_IFS__c=null and Employee_ID__c=!=null');
        else
        return Database.getQueryLocator('select id, name,Appointment_Start_Time__c,Assignment_sent_to_IFS__c,Cancellation_Notes__c, h_IFS_Duration__c,Duration__c,Employee_ID__c, Employee_ID__r.name, Employee_ID__r.Technician_Name__c,(select id, note__c from NGS_Notes__r) from NGS_Work_Order_Appointment__c where Appointment_Start_Time__c =TOMORROW and Assignment_sent_to_IFS__c=null and Employee_ID__c!=null');// and id=:recid //CH01
        //CH01.end
    }

/** 
    execute(Database.BatchableContext BC, List<NGS_Technician__c> scope) - Main execute method
**/

    global void execute(Database.BatchableContext BC, List<NGS_Work_Order_Appointment__c> scope){
        System.debug('----->'+scope);
        try{
            for(NGS_Work_Order_Appointment__c objWOAppt : scope){
                boolean acceptance = true;
                if(objWOAppt.Employee_ID__r.Technician_Name__c=='Rejected Rejected') acceptance =false;               
                NGS_S3_Send_WO_Assignment_to_IFS.Sent_WO_Assignment(acceptance,objWOAppt.id);               
            }
           }
           catch(Exception e){ 
            System.debug('Error occured--->'+e.getMessage()+' Line Number--->'+e.getLinenumber());
           }      
    }

    /**
        finish(Database.BatchableContext BC) - finish method of the Batch
    **/
    global void finish(Database.BatchableContext BC){      
        if(batchresult=='') System.debug('Batch is Successfully executed');
        else System.debug(batchresult);
    }
}