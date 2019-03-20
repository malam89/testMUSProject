/**
    Description : This test class covers the below classes                   
                  1)NGS_OFSC_Technician_getWorkScheduleBatch 
                  2)NGS_OFSC_Technician_getWorkSchedule
                  3)NGS_OFSC_Tech_getWorkSchedule_Scheduler
**/
/*
    Created By  : Tashika Gupta
    Created On  : 24/03/2017
    Service Req : SR_OptiMUS_NG_023
    Change History
*/
@istest
public class NGS_OFSC_Technician_getWorkSchedule_test{

    static testmethod void pass1(){
        NGS_Technician__c tech = new NGS_Technician__c();
        tech.First_Name__c='Test';
        tech.Last_Name__c='Test';
        tech.Gender__c='F';
        tech.Leaving_Date__c=System.today()+5;
        tech.Mobile_Number__c='07447447441';
       // tech.Start_Date__c=System.today();
        tech.Start_Location__c='LON';       
        insert Tech;
         NGS_OFSC_Tech_getWorkSchedule_Scheduler sch = new NGS_OFSC_Tech_getWorkSchedule_Scheduler ();
         system.schedule('NGS_OFSC_Tech_getWorkSchedule_Scheduler','0 0 22 1/1 * ? *',sch);
    
    }
}