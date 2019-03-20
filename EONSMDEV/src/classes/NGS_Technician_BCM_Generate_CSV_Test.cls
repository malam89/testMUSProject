/**
    Description : This test class is used to cover the below classes
                    NGS_Technician_BCM_Generate_CSV
**/
/*
    Created By : Shruti Moghe
    Created Date : 09/03/2017
    Service Request : SR_OptiMUS_NG_022
*/
@isTest
public class NGS_Technician_BCM_Generate_CSV_Test{

    /**
        unitTest1() - unitTest1 - Success test case
    **/
    testmethod static void unitTest1(){
       
        NGS_Technician__c tech = new NGS_Technician__c();
        tech.First_Name__c='Test';
        tech.Last_Name__c='Test';
        tech.Gender__c='F';
        tech.Leaving_Date__c=System.today()+50;
        tech.Mobile_Number__c='07447447441';
        tech.Start_Date__c=System.today();
        tech.Start_Location__c='LON';       
        insert Tech;
        NGS_Technician_BCM_Generate_CSV.Generate_CSV(Tech.id);
        
    }
}