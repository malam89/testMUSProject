/** 
Description: This trigger is for updating EON Stock records related to EON Stock based on conditions 

Helper Class  : EON_Stock_Trigger_Helper
Test Class    : EON_Job_Results_Trigger_Test
**/
/* 
Created By    : Guna P
Created On    : 20/03/2018
Service Req   : SR_OptiMUS_EON_185

CHANGE HISTORY: 
CH01 # shruti Moghe # 29/03/2018 # Added logic to send email to customer

*/


trigger EON_Stock_Trigger on EON_Stock__c (after insert, before update) {

  
   //to by pass the trigger when mass transfering the records.
    if (System.Label.EON_Bypass_Mass_Transfer_Records == 'FALSE'){
        if(trigger.isafter)
        EON_Stock_Trigger_Helper.UpdateStockForSerialNo(trigger.new);
        //CH01.start
        if(trigger.isbefore){
            for(EON_Stock__c stock : trigger.new){
                if(trigger.oldmap!=null && trigger.oldmap.get(stock.id)!=null && trigger.oldmap.get(stock.id).Date_Returned_Received__c!=stock.Date_Returned_Received__c && stock.Date_Returned_Received__c!=null && stock.Date_Failed__c==null && stock.Date_Faulty__c==null && stock.Date_Off_Circuit__c==null && stock.Date_sent_back_to_CEVA__c==null){
                    stock.status__c='Validation Required';   
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo=System.Label.EON_Stock_Reconciliation_email.split(';');
                    email.setToAddresses(sendTo);
                    email.setSubject('EON Stock Record(s) Require Manual Validation (CEVA Returned');
                      String emailbody='';
                    String recordURLFaulty = EON_Utility.getInstanceURL() +'/'+stock.Id; 
                     emailbody='Dear recipient, <br/><br/>A date has been entered into “Date Returned/Received” but there is no date present in Date Failed, Date Faulty or Date Off-Circuit <br/><br/>Below is the relevant record link in OptiMUS;';
                    emailbody=emailbody+'<br/><br/> <a href='+recordURLFaulty+'>'+recordURLFaulty+'</a><br/><br/>Please double check the reason for this asset being returned to CEVA and manually update the date field where applicable. <br/><br/>Kind regards<br/> The Stock Reconciliation Team';
                    email.setHtmlBody(emailbody);
                    try{
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                    }catch(exception e){
                       // apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
                    }         
                }
                
            
            }
        }
        //CH01.end
        
    }
}