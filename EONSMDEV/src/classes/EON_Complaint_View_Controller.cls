/**
    Description : This class is the controller for EON Complaint Object to Override the Existing New button.
                  
    VF Page     : EON_Complaint_View_Override
    Test Class  : EON_Complaint_View_Controller_Test

**/
/*
    Created By  : Mehboob Alam
    Created On  : 02/10/2017
    Service Req : SR_OptiMUS_EON_107
    Change History
*/
public with sharing class EON_Complaint_View_Controller{
 private final EON_Complaint__c eComplaint;   
  public list<EON_Complaint__c> lComplaint{get; set;} 

       public EON_Complaint_View_Controller(ApexPages.StandardController stdController){
         lComplaint= new List<EON_Complaint__c>();
         this.eComplaint= (EON_Complaint__c)stdController.getRecord();
         string mpanVal = eComplaint.MPAN__c;
         if(mpanVal!=null){
           for(EON_Complaint__c ec : [select id, name,Complainant_Name__c,Complaint_Type__c,Date_Complaint_Logged__c,Complaint_Status__c from EON_Complaint__c
                                      where MPAN__c=:mpanVal ]){
               if(ec.id!=eComplaint.id)
                    lComplaint.add(ec);                     	
            }
          }
        }
}