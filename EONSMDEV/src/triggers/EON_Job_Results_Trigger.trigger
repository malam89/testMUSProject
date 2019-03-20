/** 
Description: This trigger is for updating EON Stock records related to EON Job Results based on conditions 

Helper Class  : EON_Stock_Reconciliation_Process_Helper
Test Class    : EON_Job_Results_Trigger_Test
**/
/* 
Created By    : Shruti Moghe
Created On    : 02/04/2016
Service Req   : SR_EON_AL_005

CHANGE HISTORY: 
    CH01 # SR_EON_Mobile_044 # 23/June/2016 # Praveen Garikipati # Added Abort Reason code and sub reason code mapping.
    CH02 # SR_EON_AL_031 #10/08/2016 #Aruna Manjari # Updated code to achieve SR Functionality
    CH03 # SR_EON_AL_033 # 08/09/2016 # Mahadev J # Updated code to call reconciliatiation process upon update at EOn Job Results
    CH04 # SR_EON_Mobile_079 # 13/09/2016 # Praveen G # Added logic to make few fields value in upper case.
    CH05 # SR_EON_Mobile_077 # 20/09/2016 # Praveen G # Added logic to make field default value.
    CH06 # SR_EON_Mobile_097 # 11/11/2016 # Praveen G # changed the parameters for calculating sub reason.
    CH07 # SR_EON_AL_035 # 11/01/2017 # Praveen G # Added logic to create stock records based on the criteria.
    CH08 # SR_OptiMUS_EON_171 #04/12/2017 # Praveen G # Updating the Technician Mismatch field.
*/


trigger EON_Job_Results_Trigger on EON_Job_Results__c (after update, after insert, before insert, before update) {

  
   //to by pass the trigger when mass transfering the records.
    if (System.Label.EON_Bypass_Mass_Transfer_Records == 'FALSE'){
        //List<EON_Job_Results__c> lstJobResults = new List<EON_Job_Results__c>();
        if(trigger.isAfter){
            
            //CH07.Start
                if(Trigger.isInsert || Trigger.isUpdate)
                    EON_Job_Results_Trigger_Helper_Stock.CreateStockRecords(Trigger.New, Trigger.oldMap);
            //CH07.End
        
        
            if(Trigger.isUpdate){
                //EON_Stock_Reconciliation_Process_Helper.EON_Stock_Reconciliation_JobResults( trigger.new,true,trigger.oldMap); //CH02.Old //CH03.Old
                EON_Ceva_Stock_Reconciliation_Process.processJobResults(trigger.new,trigger.oldMap);//CH03.New                    
            }
            if(Trigger.isInsert){
                EON_Ceva_Stock_Reconciliation_Process.EON_Stock_Reconciliation_JobResults( trigger.new,true,new Map<id,EON_Job_Results__c>());   
                system.debug('-----------------'+trigger.new);
                
                //CH08.Start
                EON_Job_Results_Trigger_Helper.updateTechnicianForStock(Trigger.New);
                //CH08.End
            }
         //CH01.Start
        }else if(Trigger.isBefore){
            for(EON_Job_Results__c jobResult : Trigger.New){
                Map<String, String> mapAbortReasonWithcode = EON_Job_Results_Trigger_Helper.getMapAbortReasoncode();
               
                if(jobResult.Abort_Category__c!= null && jobResult.Abort_Reason__c != null)
                    jobResult.h_Abort_Reason__c = mapAbortReasonWithcode.get(jobResult.Abort_Category__c.toUpperCase() + 
                                                                            jobResult.Abort_Reason__c.toUpperCase());
                
                Map<String, String> mapAbortSubReasonWithcode = EON_Job_Results_Trigger_Helper.getMapAbortSubReasoncode();
                if(jobResult.Abort_Sub_Reason__c!= null)
                    jobResult.h_Abort_Sub_Reason__c = mapAbortSubReasonWithcode .get(jobResult.Abort_Category__c.toUpperCase() +
                                                                                     jobResult.Abort_Reason__c.toUpperCase() +
                                                                                     jobResult.Abort_Sub_Reason__c.toUpperCase()); //CH06
                
                if(Trigger.isInsert){
                    if(jobResult.E_Meter_Removed__c == null || jobResult.E_Meter_Removed__c == '')
                        jobResult.E_Meter_Removed__c = 'No';
                    if(jobResult.G_Meter_Removed__c == null || jobResult.G_Meter_Removed__c == '')    
                        jobResult.G_Meter_Removed__c = 'No';
                    if(jobResult.E_Meter_Installed__c == null || jobResult.E_Meter_Installed__c == '')
                        jobResult.E_Meter_Installed__c = 'No';
                    if(jobResult.G_Meter_Installed__c == null || jobResult.G_Meter_Installed__c == '')
                        jobResult.G_Meter_Installed__c = 'No';
                        
                    //CH05.Start
                    if(jobResult.Initial_Contact_Outcome__c == null || jobResult.Initial_Contact_Outcome__c == '')
                        jobResult.Initial_Contact_Outcome__c = 'Did not attempt to make customer contact';
                    //CH05.End    
                }
            }
             
        }//CH01.End
        
        //CH04.Start
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
            EON_Job_Results_Trigger_Helper.updateValueInUpperCase(Trigger.New);
        //CH04.End
          
    }
}