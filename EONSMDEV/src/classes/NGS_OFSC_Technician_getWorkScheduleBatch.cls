/**
    Description :    This class is used to send the Resource Availability to IFS                     
    Test Class  :   NGS_OFSC_Technician_getWorkSchedule_test
**/
/*
    Created By  : Tashika Gupta
    Created On  : 24/03/2017
    Service Req : SR_OptiMUS_NG_023
    Change History
    CH01 # 07/02/2018 # CheckMark Report # Abhilash # Code improvement
*/
global class  NGS_OFSC_Technician_getWorkScheduleBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{

    public Static Integer SuccessCount =0;
    public Static Integer FailureCount =0;
    Public SET<NGS_Technician_Shifts__c> FinalReceivedShifts = new SET<NGS_Technician_Shifts__c>();
    public List<NGS_Oracle_Data_Tracker__c> oracleTrackers = new List<NGS_Oracle_Data_Tracker__c>();
    public static String Error='';

/** 
    Database.queryLocator start(Database.BatchableContext BC) - start method
**/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        Date startDate =date.today() ;
        Date endDate = startDate.addDays(42);
        
        List<NGS_Technician_Shifts__c> techlist = new List<NGS_Technician_Shifts__c>();
        techlist=[select id from NGS_Technician_Shifts__c where id != '']; //CH01.Update
        Delete techlist; 
        return Database.getQueryLocator('select id,Name, Active__c,Leaving_Date__c, h_oracle_user_created__c from NGS_Technician__c where Sent_to_Oracle__c!=null and (Leaving_Date__c=null OR (Leaving_Date__c>:startDate AND Leaving_Date__c<=:endDate))' );
        
    }

/** 
    execute(Database.BatchableContext BC, List<NGS_Technician__c> scope) - Main execute method
**/

    global void execute(Database.BatchableContext BC, List<NGS_Technician__c> scope){
        try{
            for(NGS_Technician__c objTechnician : scope){
                List<NGS_Technician_Shifts__c> ReceivedShifts = new List<NGS_Technician_Shifts__c>();
                ReceivedShifts = NGS_OFSC_Technician_getWorkSchedule.getWorkScheduleFromOFS(objTechnician.id);
                FinalReceivedShifts.addAll(ReceivedShifts);
                oracleTrackers.add(NGS_OFSC_Technician_getWorkSchedule.ngsOdataActivityObj);
            }
           }
           catch(Exception e){ 
           Error =e.getMessage()+' Line Number-'+e.getLinenumber();}      
    }

    /**
        finish(Database.BatchableContext BC) - finish method of the Batch
    **/
    global void finish(Database.BatchableContext BC){
       LIst<NGS_Technician_Shifts__c> ListShifts =  New LIst<NGS_Technician_Shifts__c>();
        ListShifts.addAll(FinalReceivedShifts);
       NGS_S1_Send_ResourceAvailability_to_IFS.Send_ResourceAvailability(ListShifts);
        upsert ListShifts;
        upsert oracleTrackers;
        List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String sendTo = '';
            sendTo= System.Label.NGS_BCM_CSV_Email;
            if(sendTo!=null)
            mail.setToAddresses(sendTo.split(';'));
            mail.setSubject('NGS - get work schedule has run'+ (String.isBlank(Error)? 'Successfully' : 'Failed'));           
            String body= String.isBlank(Error)?'Successfully received the Work Schedules': Error+'<br/>';
            mail.setHtmlBody(body);                      
            emaillist.add(mail);
            if(emaillist!= null && emaillist.size() > 0)
            Messaging.sendEmail(emaillist);
        System.debug('Batch is Successfully executed');
    }
}