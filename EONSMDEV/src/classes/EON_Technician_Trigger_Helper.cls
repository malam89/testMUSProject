/**
    Description : Trigger handler for 'EON_Technician__c' sObject.
    Test Class  : EON_Technician_Trigger_Test
**/
/* 
    Created By  : Puneet Mehta
    Created On  : 29/03/2016
    Service Req : SR_EON_Scheduling_001
    Change History : EON_Technician_Trigger_Test
    Change History:CH01 #SR_EON_Scheduling_032 # 04/05/2016 # Pedda Reddeiah # added code to achieve SR functionality 
    CH02 # SR_EON_AL_018 # 03/05/2016 # Pedda Reddeiah # amended the logic as per the SR.
    CH03 # SR_EON_AL_027 # 07/07/2016 #  Pedda Reddeiah # amended the logic as per the SR.
    CH04 #SR_EON_Scheduling_042 # 02/08/2016 # Praveen G # updating the technician in OFSC for specific fields.
    CH05 #SR_EON_AL_032 # 22/08/2016 # Shruti Moghe # Added logic to update the hidden Date fields based on conditions
    CH06 #SR_EON_Scheduling_045 # 30/08/2016 # Praveen G # added logic to send locatio details to OFSC 
    CH07 # SR_EON_AL_036 # 19/11/2016 # Shruti Moghe # added new functionality to work for new asset types
    CH08 # SR_OptiMUS_EON_168 # 04/12/2017 # Mehboob Alam # Added new validation for Technician Stock Profile.  
    
*/

public with sharing class EON_Technician_Trigger_Helper{

 //CH01.start
  /**
  OnBeforeInsert(): this method will be called when technician records are insert
  **/
 public void OnBeforeInsert(List<EON_Technician__c> newTechnicians){
      //CH08.Start
      set<id> sProId = new set<id>();
      Map<id, boolean> mapProduct = new Map<id, boolean>();
      for(EON_Technician__c technician : newTechnicians){
        if(!EON_Utility.validateRequired(technician.Stock_Profile__c)) 
            sProId.add(technician.Stock_Profile__c); 
      }
      
      for(EON_Stock_Profile__c sp : [select id,(select id from Profile_Product__r where Active__c=true) from EON_Stock_Profile__c where id=:sProId]){
          if(!mapProduct.containskey(sp.id)){
              if(sp.Profile_Product__r.isEmpty())
                  mapProduct.put(sp.id, true); 
                    else 
                     mapProduct.put(sp.id, false); 
                }                       
            }
       //CH08.End     
    
       for(EON_Technician__c technician : newTechnicians ){   
        technician.h_Email__c=System.Label.EON_Technician_emails_to_update.split(';')[0];//CH02
        technician.h_Status__c =((technician.Start_Date__c <= System.today() &&
                       (technician.Date_Left__c == null || technician.Date_Left__c >= System.today())) ? 'Active' : 'Inactive');
         //CH08.Start
           if(mapProduct.containsKey(technician.Stock_Profile__c)){
             if(mapProduct.get(technician.Stock_Profile__c))
                technician.addError('The Stock Profile has zero related products');
         }
        //CH08.End           
    }
 }
 
 /**
 OnBeforeUpdate(): this method will be called when technician records are updated
 **/
 public void OnBeforeUpdate(List<EON_Technician__c> newTechnicians){
      //CH08.Start
      set<id> sProId = new set<id>();
      Map<id, boolean> mapProduct = new Map<id, boolean>();
      for(EON_Technician__c technician : newTechnicians){
        if(!EON_Utility.validateRequired(technician.Stock_Profile__c)) 
            sProId.add(technician.Stock_Profile__c); 
      }
      
      for(EON_Stock_Profile__c sp : [select id,(select id from Profile_Product__r where Active__c=true) from EON_Stock_Profile__c where id=:sProId]){
          if(!mapProduct.containskey(sp.id)){
              if(sp.Profile_Product__r.isEmpty())
                  mapProduct.put(sp.id, true); 
                    else 
                     mapProduct.put(sp.id, false); 
                }                       
            }
       //CH08.End 
       
       for(EON_Technician__c technician : newTechnicians ){
           technician.h_Status__c =((technician.Start_Date__c <= System.today() && (technician.Date_Left__c == null || technician.Date_Left__c >= System.today())) ? 'Active' : 'Inactive');
           
           //CH08.Start
          if(mapProduct.containsKey(technician.Stock_Profile__c)){
             if(mapProduct.get(technician.Stock_Profile__c))
                technician.addError('The Stock Profile has zero related products');
         }
         //CH08.End
    }
 }
 //CH01.End
    
   /**
   OnAfterInsert(): this method will be called when technician records are inserted
   **/
   public void OnAfterInsert(List<EON_Technician__c> newTechnicians){
        for(EON_Technician__c technician : newTechnicians){
            if (  Limits.getFutureCalls() < (Limits.getLimitFutureCalls() - 1) ) {//adding the limit to 
                try {
                    //Send email to Eon team to update that Eon Technician has been created.
                      //CH01 sendEmailToEONSmartMeter(technician.Name,technician.id,((technician.Start_Date__c <= System.today() &&
                       //(technician.Date_Left__c == null || technician.Date_Left__c >= System.today())) ? 'Active' : 'Inactive'));
                    //call method to send the technician details to OFSC
                    sendTechnicianToOFSC(technician.id,technician.h_Status__c,true); } Catch(Exception ex ){ technician.addError(ex.getMessage());}
            }
        }
    }
    
    /**
        OnAfterUpdate(): This method will be invoked on update activity and the future call out will be done when the dates are changed or name is update.
    **/
    public void OnAfterUpdate(List<EON_Technician__c> oldTechnicians, List<EON_Technician__c> updatedTechnicians, Map<ID, EON_Technician__c> technicianOldMap, Map<ID, EON_Technician__c> technicianNewMap){
        
        for(EON_Technician__c technician : updatedTechnicians){
        
            //CH06.Start
                if(technician.Sent_to_OFS__c != null && 
                    (technician.Town__c != technicianOldMap.get(technician.id).Town__c) ||
                    (technician.Address_Line_1__c != technicianOldMap.get(technician.id).Address_Line_1__c) ||
                    (technician.Postcode__c != technicianOldMap.get(technician.id).Postcode__c) ){
                        EON_OFSC_Send_Technician_Handler.updateTechnicianLocationinOFSC(technician.id);
                    }
            //CH06.End
      
            Boolean isReqtosendOFSC = false;//CH01
            try{
                if(((technician.Start_Date__c != technicianOldMap.get(technician.id).Start_Date__c) || 
                    (technician.Date_Left__c != technicianOldMap.get(technician.id).Date_Left__c) || 
                    (technician.Name != technicianOldMap.get(technician.id).Name)) && Limits.getFutureCalls() < (Limits.getLimitFutureCalls() - 1) )
                {   
                    
                        //Send email to Eon team to update that Eon Technician has been created.
                        //CH01sendEmailToEONSmartMeter(technician.Name,technician.id,((technician.Start_Date__c <= System.today() &&
                         //CH01   (technician.Date_Left__c == null || technician.Date_Left__c >= System.today())) ? 'Active' : 'Inactive')); 
                        //call method to send the technician details to OFSC
                        //CH02.Amended the logic
                        isReqtosendOFSC = ((technician.Sent_to_OFS__c == null && technician.h_Status__c != null && technician.h_Status__c.equalsIgnoreCase('Active')) ? true :(technician.h_Status__c != technicianOldMap.get(technician.id).h_Status__c && technician.h_Status__c != null && technician.h_Status__c.equalsIgnoreCase('Inactive')) ? true : false );
                        sendTechnicianToOFSC(technician.id,technician.h_Status__c,isReqtosendOFSC); 
                }
                //CH02.Start
                if ( !isReqtosendOFSC && technician.Sent_to_OFS__c == null && technician.h_Status__c != null && technician.h_Status__c.equalsIgnoreCase('Active') ){ 
                    sendTechnicianToOFSC(technician.id,technician.h_Status__c,true);} 
                    
                //CH04.Start
                    if(technician.Work_Zone__c != technicianOldMap.get(technician.id).Work_Zone__c ||
                        technician.Vehicle_Reg__c != technicianOldMap.get(technician.id).Vehicle_Reg__c ||
                        technician.Email__c != technicianOldMap.get(technician.id).Email__c || 
                        technician.Name != technicianOldMap.get(technician.id).Name){
                            EON_OFSC_Send_Technician_Handler.updateTechnicianInfoInOFSC(technician.id);
                        }
                //CH04.End    
                } Catch(Exception ex ){technician.addError(ex.getMessage());}
                //CH02.End
        }
    }
    
    /**
        sendTechnicianToOFSC(): this method will receive the String as parameter and calls the sendTechniciantoOFSC method
    **/
    @future (callout=true)
    public static void sendTechnicianToOFSC(String technicianIDs,String status,Boolean isReqtosendOFSC){
        
           String response = EON_OFSC_Send_Technician_Handler.sendTechnicianToOFSC(technicianIDs);
           System.debug('response = '+response); 
           
           if ( isReqtosendOFSC && status != null && response != '' && response.containsIgnoreCase('Technician sent to OFSC') ) {sendEmailToEONSmartMeter(technicianIDs,status);}
    }

    
    /**
    sendEmailToEONSmartMeter(String Name,String Status) - This method will send email to Eon team when Technician is added or modified.
    **/ 
       
    public static void sendEmailToEONSmartMeter(String technicianID,String Status) {
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
       // CH03.Start
        if(Status=='Active'){
        for (String emID : Label.EON_Technician_emails_to_update.split(';'))
            if ( emID != '' && emID != null ){ sendTo.add(emID); }
            }
            if(Status=='InActive'){
        for (String emID : Label.EON_Technician_emails_to_Deactivated.split(';'))
            if ( emID != '' && emID != null ){ sendTo.add(emID); }
            }
        //CH03.End
        mail.setToAddresses(sendTo);
        EmailTemplate et=[select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName =: (( Status.equalsIgnoreCase('Active')) ? 'EON_Technician_Notification_Template' : 'EON_Technician_Create_Update_Template')  limit 1 ];
        mail.setSaveAsActivity(false);
        String Subject= et.Subject, htmlBody = et.HtmlValue, plainBody = et.Body;
        String recordURL = URL.getSalesforceBaseUrl().toExternalForm() +'/'+technicianID;
        
        //CH01 htmlBody= htmlBody.replace('{!EON_Technician__c.Name}',Name);
        //CH01 htmlBody= htmlBody.replace('{!Status}',Status); 
        htmlBody= htmlBody.replace('{!EON_Technician__c.Link}',recordURL); 
        //CH01 plainBody = plainBody.replace('{!EON_Technician__c.Name}',Name);
        //CH01 plainBody = plainBody.replace('{!Status}',Status); 
        plainBody = plainBody.replace('{!EON_Technician__c.Link}',recordURL); 

         
        mail.setSubject(Subject);
        mail.setHtmlBody(htmlBody);
        mail.setSaveAsActivity(false);
        mail.setPlainTextBody(plainBody);
        system.debug('Mail---->'+mail);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
    //CH05.start
     /**
    BAUTriggerPopulateDateFields() - This method will be used to populate hidden date fields based on condition.
    **/    
    public static void BAUTriggerPopulateDateFields(List<EON_Technician__c> oldTechnicians, List<EON_Technician__c> updatedTechnicians, Map<ID, EON_Technician__c> technicianOldMap, Map<ID, EON_Technician__c> technicianNewMap) {
        //Getting the information of Running User
        User RjUser=[SELECT Id,name,ProfileId,IsActive FROM User where id=:UserInfo.getUserId()];
        List<EON_Technician__c> LstToUpdate = new List<EON_Technician__c>();
        for(EON_Technician__c tech:updatedTechnicians){
            if(RjUser.name!=null && RjUser.name!='' && RjUser.name.containsignoreCase('Shruti')){
                if((tech.X3_Phase_E_Meter_0151_VS__c > technicianOldMap.get(tech.id).X3_Phase_E_Meter_0151_VS__c) || (tech.X3_Phase_E_Meter_0393_VS__c > technicianOldMap.get(tech.id).X3_Phase_E_Meter_0393_VS__c) || (tech.E_Credit_Meter_4_Term_0151_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_4_Term_0151_Classic_VS__c) || (tech.E_Credit_Meter_5_Term_0151_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_5_Term_0151_Classic_VS__c) || (tech.E_Credit_Meter_SR_1R_0393_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_SR_1R_0393_Classic_VS__c) || (tech.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c > technicianOldMap.get(tech.id).E_PP_1R_4_Term_No_Key_0393_Classic_VS__c) || (tech.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c > technicianOldMap.get(tech.id).E_PP_1R_4_Term_with_Key_0393_Classic_VS__c) || (tech.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c > technicianOldMap.get(tech.id).E_PP_2R_5_Term_No_Key_0151_Classic_VS__c) || (tech.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c > technicianOldMap.get(tech.id).E_PP_2R_5_Term_with_Key_0151_Classic_VS__c) || (tech.Gas_Credit_Meter_Classic_VS__c > technicianOldMap.get(tech.id).Gas_Credit_Meter_Classic_VS__c) || (tech.Gas_Credit_Meter_Semi_Con_Classic_VS__c > technicianOldMap.get(tech.id).Gas_Credit_Meter_Semi_Con_Classic_VS__c) || (tech.Gas_PP_Libre_210_Domestic_Classic_VS__c > technicianOldMap.get(tech.id).Gas_PP_Libre_210_Domestic_Classic_VS__c) || (tech.Gas_PP_Meter_G4_ETM_Classic_VS__c > technicianOldMap.get(tech.id).Gas_PP_Meter_G4_ETM_Classic_VS__c) || (tech.Regulators_Gas_VS__c > technicianOldMap.get(tech.id).Regulators_Gas_VS__c) || (tech.Smart_Electric_Meter_VS__c > technicianOldMap.get(tech.id).Smart_Electric_Meter_VS__c) || (tech.Smart_Electric_Meter_New_Connections_VS__c > technicianOldMap.get(tech.id).Smart_Electric_Meter_New_Connections_VS__c) || (tech.Smart_Energy_Display_SED_IHD_VS__c > technicianOldMap.get(tech.id).Smart_Energy_Display_SED_IHD_VS__c) || (tech.Smart_Gas_Meter_VS__c > technicianOldMap.get(tech.id).Smart_Gas_Meter_VS__c) || (tech.Smart_Gas_Meter_Semi_Con_VS__c > technicianOldMap.get(tech.id).Smart_Gas_Meter_Semi_Con_VS__c) || (tech.E_Credit_Meter_4_Term_0244_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_4_Term_0244_Classic_VS__c) ||(tech.E_Credit_Meter_4_Term_0935_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_4_Term_0935_Classic_VS__c) ||(tech.E_Credit_Meter_5_Term_0244_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_5_Term_0244_Classic_VS__c) ||(tech.E_Credit_Meter_5_Term_0935_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_5_Term_0935_Classic_VS__c) ||(tech.Regulators_SC_Gas_VS__c > technicianOldMap.get(tech.id).Regulators_SC_Gas_VS__c) ||(tech.Smart_Gas_Meter_New_Connections_VS__c > technicianOldMap.get(tech.id).Smart_Gas_Meter_New_Connections_VS__c)){//CH07 added new fields 
                        if(tech.X3_Phase_E_Meter_0151_VS__c > technicianOldMap.get(tech.id).X3_Phase_E_Meter_0151_VS__c ){
                            if(tech.X3_Phase_E_Meter_0151_VS__c < tech.X3_Phase_E_Meter_0151_BAU__c) tech.h_3_Phase_E_Meter_0151__c =system.today();
                            else tech.h_3_Phase_E_Meter_0151__c =null;
                        }
                        if(tech.X3_Phase_E_Meter_0393_VS__c > technicianOldMap.get(tech.id).X3_Phase_E_Meter_0393_VS__c ){ 
                            if(tech.X3_Phase_E_Meter_0393_VS__c < tech.X3_Phase_E_Meter_0393_BAU__c  ) tech.h_3_Phase_E_Meter_0393__c=system.today();
                            else tech.h_3_Phase_E_Meter_0393__c=null;
                        }                       
                        if(tech.E_Credit_Meter_4_Term_0151_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_4_Term_0151_Classic_VS__c ){
                            if(tech.E_Credit_Meter_4_Term_0151_Classic_VS__c < tech.E_Credit_Meter_4_Term_0151_Classic_BAU__c) tech.h_E_Credit_Meter_4_Term_0151_Classic__c=system.today();
                            else tech.h_E_Credit_Meter_4_Term_0151_Classic__c=null;
                        }                      
                        if(tech.E_Credit_Meter_5_Term_0151_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_5_Term_0151_Classic_VS__c ){
                            if(tech.E_Credit_Meter_5_Term_0151_Classic_VS__c < tech.E_Credit_Meter_5_Term_0151_Classic_BAU__c) tech.h_E_Credit_Meter_5_Term_0151_Classic__c=system.today();
                            else tech.h_E_Credit_Meter_5_Term_0151_Classic__c=null;
                        }                      
                        if(tech.E_Credit_Meter_SR_1R_0393_Classic_VS__c > technicianOldMap.get(tech.id).E_Credit_Meter_SR_1R_0393_Classic_VS__c ){
                            if(tech.E_Credit_Meter_SR_1R_0393_Classic_VS__c < tech.E_Credit_Meter_SR_1R_0393_Classic_BAU__c) tech.h_E_Credit_Meter_SR_1R_0393_Classic__c=system.today();
                            else tech.h_E_Credit_Meter_SR_1R_0393_Classic__c=null;
                        }
                        if(tech.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c > technicianOldMap.get(tech.id).E_PP_1R_4_Term_No_Key_0393_Classic_VS__c ){
                            if(tech.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c < tech.E_PP_1R_4_Term_No_Key_0393_Classic_BAU__c) tech.h_E_PP_1R_4_Term_No_Key_0393_Classic__c=system.today(); 
                            else tech.h_E_PP_1R_4_Term_No_Key_0393_Classic__c=null;
                        }
                        if(tech.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c > technicianOldMap.get(tech.id).E_PP_1R_4_Term_with_Key_0393_Classic_VS__c ){
                            if(tech.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c < tech.E_PP_1R_4_Term_with_Key_0393_Classic_BAU__c) tech.h_E_PP_1R_4_Term_with_Key_0393_Classic__c=system.today();
                            else tech.h_E_PP_1R_4_Term_with_Key_0393_Classic__c=null;
                        }
                        if(tech.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c > technicianOldMap.get(tech.id).E_PP_2R_5_Term_No_Key_0151_Classic_VS__c ){
                            if(tech.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c < tech.E_PP_2R_5_Term_No_Key_0151_Classic_BAU__c) tech.h_E_PP_2R_5_Term_No_Key_0151_Classic__c=system.today();
                            else tech.h_E_PP_2R_5_Term_No_Key_0151_Classic__c=null;
                        }
                        if(tech.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c > technicianOldMap.get(tech.id).E_PP_2R_5_Term_with_Key_0151_Classic_VS__c ){
                            if(tech.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c < tech.E_PP_2R_5_Term_with_Key_0151_Classic_BAU__c) tech.h_E_PP_2R_5_Term_with_Key_0151_Classic__c=System.today();
                            else tech.h_E_PP_2R_5_Term_with_Key_0151_Classic__c=null;
                        }
                        if(tech.Gas_Credit_Meter_Classic_VS__c > technicianOldMap.get(tech.id).Gas_Credit_Meter_Classic_VS__c ){
                            if(tech.Gas_Credit_Meter_Classic_VS__c < tech.Gas_Credit_Meter_Classic_BAU__c ) tech.h_Gas_Credit_Meter_Classic_date__c=System.today();
                            else tech.h_Gas_Credit_Meter_Classic_date__c=null;
                        }
                        if(tech.Gas_Credit_Meter_Semi_Con_Classic_VS__c > technicianOldMap.get(tech.id).Gas_Credit_Meter_Semi_Con_Classic_VS__c ){
                            if(tech.Gas_Credit_Meter_Semi_Con_Classic_VS__c < tech.Gas_Credit_Meter_Semi_Con_Classic_BAU__c) tech.h_Gas_Credit_Meter_Semi_Con_Classic__c=System.today();
                            else tech.h_Gas_Credit_Meter_Semi_Con_Classic__c=null;
                        }
                        if(tech.Gas_PP_Libre_210_Domestic_Classic_VS__c > technicianOldMap.get(tech.id).Gas_PP_Libre_210_Domestic_Classic_VS__c ){
                            if(tech.Gas_PP_Libre_210_Domestic_Classic_VS__c < tech.Gas_PP_Libre_210_Domestic_Classic_BAU__c) tech.h_Gas_PP_Libre_210_Domestic_Classic__c=System.today();
                            else tech.h_Gas_PP_Libre_210_Domestic_Classic__c=null;
                        }
                        if(tech.Gas_PP_Meter_G4_ETM_Classic_VS__c > technicianOldMap.get(tech.id).Gas_PP_Meter_G4_ETM_Classic_VS__c ){
                            if(tech.Gas_PP_Meter_G4_ETM_Classic_VS__c  < tech.Gas_PP_Meter_G4_ETM_Classic_BAU__c ) tech.h_Gas_PP_Meter_G4_ETM_Classic__c=System.today();
                            else tech.h_Gas_PP_Meter_G4_ETM_Classic__c=null;
                        }
                        if(tech.Regulators_Gas_VS__c > technicianOldMap.get(tech.id).Regulators_Gas_VS__c ){
                            if(tech.Regulators_Gas_VS__c < tech.Regulators_Gas_BAU__c) tech.h_Regulators_Gas_date__c=System.today();
                            else tech.h_Regulators_Gas_date__c=null;
                        }
                        if(tech.Smart_Electric_Meter_VS__c > technicianOldMap.get(tech.id).Smart_Electric_Meter_VS__c ){
                            if(tech.Smart_Electric_Meter_VS__c < tech.Smart_Electric_Meter_BAU__c ) tech.h_Smart_Electric_Meter_date__c=System.today();
                            else tech.h_Smart_Electric_Meter_date__c=null;
                        }
                        if(tech.Smart_Electric_Meter_New_Connections_VS__c > technicianOldMap.get(tech.id).Smart_Electric_Meter_New_Connections_VS__c ){
                            if(tech.Smart_Electric_Meter_New_Connections_VS__c < tech.Smart_Electric_Meter_New_Connections_BAU__c ) tech.h_Smart_Electric_Meter_New_Connections__c=System.today();
                            else tech.h_Smart_Electric_Meter_New_Connections__c=null;
                        }
                        if(tech.Smart_Energy_Display_SED_IHD_VS__c > technicianOldMap.get(tech.id).Smart_Energy_Display_SED_IHD_VS__c ){
                            if(tech.Smart_Energy_Display_SED_IHD_VS__c < tech.Smart_Energy_Display_SED_IHD_BAU__c ) tech.h_Smart_Energy_Display_SED_IHD_date__c=System.today();
                            else tech.h_Smart_Energy_Display_SED_IHD_date__c=null;
                        }
                        if(tech.Smart_Gas_Meter_VS__c > technicianOldMap.get(tech.id).Smart_Gas_Meter_VS__c ){
                            if(tech.Smart_Gas_Meter_VS__c < tech.Smart_Gas_Meter_BAU__c) tech.h_Smart_Gas_Meter_date__c=System.today();
                            else tech.h_Smart_Gas_Meter_date__c=null;
                        }
                        if(tech.Smart_Gas_Meter_Semi_Con_VS__c > technicianOldMap.get(tech.id).Smart_Gas_Meter_Semi_Con_VS__c){
                            if(tech.Smart_Gas_Meter_Semi_Con_VS__c < tech.Smart_Gas_Meter_Semi_Con_BAU__c) tech.h_Smart_Gas_Meter_Semi_Con__c=system.today(); 
                            else tech.h_Smart_Gas_Meter_Semi_Con__c=null; 
                        }
                        //CH07.start
                        if(tech.E_Credit_Meter_4_Term_0244_Classic_VS__c> technicianOldMap.get(tech.id).E_Credit_Meter_4_Term_0244_Classic_VS__c){
                            if(tech.E_Credit_Meter_4_Term_0244_Classic_VS__c< tech.E_Credit_Meter_4_Term_0244_Classic_BAU__c)  tech.h_E_Credit_Meter_4_Term_0244_Classic__c=system.today();
                            else tech.h_E_Credit_Meter_4_Term_0244_Classic__c =null;
                        }
                        if(tech.E_Credit_Meter_4_Term_0935_Classic_VS__c> technicianOldMap.get(tech.id).E_Credit_Meter_4_Term_0935_Classic_VS__c){
                            if(tech.E_Credit_Meter_4_Term_0935_Classic_VS__c< tech.E_Credit_Meter_4_Term_0935_Classic_BAU__c)  tech.h_E_Credit_Meter_4_Term_0935_Classic__c=system.today();
                            else tech.h_E_Credit_Meter_4_Term_0935_Classic__c =null;
                        }
                        if(tech.E_Credit_Meter_5_Term_0244_Classic_VS__c> technicianOldMap.get(tech.id).E_Credit_Meter_5_Term_0244_Classic_VS__c){
                            if(tech.E_Credit_Meter_5_Term_0244_Classic_VS__c< tech.E_Credit_Meter_5_Term_0244_Classic_BAU__c)  tech.h_E_Credit_Meter_5_Term_0244_Classic__c=system.today();
                            else tech.h_E_Credit_Meter_5_Term_0244_Classic__c =null;
                        }
                        if(tech.E_Credit_Meter_5_Term_0935_Classic_VS__c> technicianOldMap.get(tech.id).E_Credit_Meter_5_Term_0935_Classic_VS__c){
                            if(tech.E_Credit_Meter_5_Term_0935_Classic_VS__c< tech.E_Credit_Meter_5_Term_0935_Classic_BAU__c)  tech.h_E_Credit_Meter_5_Term_0935_Classic__c=system.today();
                            else tech.h_E_Credit_Meter_5_Term_0935_Classic__c =null;
                        }
                        if(tech.Regulators_SC_Gas_VS__c> technicianOldMap.get(tech.id).Regulators_SC_Gas_VS__c){
                            if(tech.Regulators_SC_Gas_VS__c< tech.Regulators_SC_Gas_BAU__c)  tech.h_Regulators_SC_Gas__c=system.today();
                            else tech.h_Regulators_SC_Gas__c =null;
                        }
                        if(tech.Smart_Gas_Meter_New_Connections_VS__c> technicianOldMap.get(tech.id).Smart_Gas_Meter_New_Connections_VS__c){
                            if(tech.Smart_Gas_Meter_New_Connections_VS__c< tech.Smart_Gas_Meter_New_Connections_BAU__c)  tech.h_Smart_Gas_Meter_New_Connections__c=system.today();
                            else tech.h_Smart_Gas_Meter_New_Connections__c =null;
                        }
    
                        //CH07.end      
                }
            }
            if(tech.h_BAU_Check_Processed__c && tech.h_Processed_BAU__c==false){
            tech.h_3_Phase_E_Meter_0151__c=null;
            tech.h_3_Phase_E_Meter_0393__c=null;
            tech.h_E_Credit_Meter_4_Term_0151_Classic__c=null;
            tech.h_E_Credit_Meter_5_Term_0151_Classic__c=null;
            tech.h_E_Credit_Meter_SR_1R_0393_Classic__c=null;
            tech.h_E_PP_1R_4_Term_No_Key_0393_Classic__c=null;
            tech.h_E_PP_1R_4_Term_with_Key_0393_Classic__c=null;
            tech.h_E_PP_2R_5_Term_No_Key_0151_Classic__c=null;
            tech.h_E_PP_2R_5_Term_with_Key_0151_Classic__c=null;
            tech.h_Gas_Credit_Meter_Semi_Con_Classic__c=null;
            tech.h_Gas_PP_Libre_210_Domestic_Classic__c=null;
            tech.h_Gas_PP_Meter_G4_ETM_Classic__c=null;
            tech.h_Regulators_Gas_date__c=null;
            tech.h_Smart_Electric_Meter_date__c=null;
            tech.h_Smart_Electric_Meter_New_Connections__c=null;
            tech.h_Smart_Energy_Display_SED_IHD_date__c=null;
            tech.h_Smart_Gas_Meter_date__c=null;
            tech.h_Smart_Gas_Meter_Semi_Con__c=null;
            tech.h_Gas_Credit_Meter_Classic_date__c=null;
            //CH07.start
            Tech.h_E_Credit_Meter_4_Term_0244_Classic__c = null;
            Tech.h_E_Credit_Meter_4_Term_0935_Classic__c = null;
            Tech.h_E_Credit_Meter_5_Term_0244_Classic__c = null;
            Tech.h_E_Credit_Meter_5_Term_0935_Classic__c = null;
            Tech.h_Regulators_SC_Gas__c = null;
            Tech.h_Smart_Gas_Meter_New_Connections__c = null;
            //CH07.end
            }
            if(tech.X3_Phase_E_Meter_0151_VS__c >0 && tech.X3_Phase_E_Meter_0151_VS__c < tech.X3_Phase_E_Meter_0151_BAU__c && tech.h_3_Phase_E_Meter_0151__c==null)
                tech.h_3_Phase_E_Meter_0151__c =system.today();
            if(tech.X3_Phase_E_Meter_0393_VS__c >0 && tech.X3_Phase_E_Meter_0393_VS__c < tech.X3_Phase_E_Meter_0393_BAU__c && tech.h_3_Phase_E_Meter_0393__c==null) tech.h_3_Phase_E_Meter_0393__c=system.today();
            if(tech.E_Credit_Meter_4_Term_0151_Classic_VS__c > 0 && tech.E_Credit_Meter_4_Term_0151_Classic_VS__c < tech.E_Credit_Meter_4_Term_0151_Classic_BAU__c && tech.h_E_Credit_Meter_4_Term_0151_Classic__c==null) tech.h_E_Credit_Meter_4_Term_0151_Classic__c=system.today();                    
            if(tech.E_Credit_Meter_5_Term_0151_Classic_VS__c >0 && tech.E_Credit_Meter_5_Term_0151_Classic_VS__c < tech.E_Credit_Meter_5_Term_0151_Classic_BAU__c && tech.h_E_Credit_Meter_5_Term_0151_Classic__c==null) tech.h_E_Credit_Meter_5_Term_0151_Classic__c=system.today();                      
            if(tech.E_Credit_Meter_SR_1R_0393_Classic_VS__c >0 && tech.E_Credit_Meter_SR_1R_0393_Classic_VS__c < tech.E_Credit_Meter_SR_1R_0393_Classic_BAU__c && tech.h_E_Credit_Meter_SR_1R_0393_Classic__c==null) tech.h_E_Credit_Meter_SR_1R_0393_Classic__c=system.today();
            if(tech.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c >0 && tech.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c < tech.E_PP_1R_4_Term_No_Key_0393_Classic_BAU__c && tech.h_E_PP_1R_4_Term_No_Key_0393_Classic__c==null) tech.h_E_PP_1R_4_Term_No_Key_0393_Classic__c=system.today(); 
            if(tech.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c >0 && tech.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c < tech.E_PP_1R_4_Term_with_Key_0393_Classic_BAU__c && tech.h_E_PP_1R_4_Term_with_Key_0393_Classic__c==null) tech.h_E_PP_1R_4_Term_with_Key_0393_Classic__c=system.today();
            if(tech.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c >0 && tech.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c < tech.E_PP_2R_5_Term_No_Key_0151_Classic_BAU__c && tech.h_E_PP_2R_5_Term_No_Key_0151_Classic__c==null) tech.h_E_PP_2R_5_Term_No_Key_0151_Classic__c=system.today();
            if(tech.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c >0 && tech.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c < tech.E_PP_2R_5_Term_with_Key_0151_Classic_BAU__c && tech.h_E_PP_2R_5_Term_with_Key_0151_Classic__c==null) tech.h_E_PP_2R_5_Term_with_Key_0151_Classic__c=System.today();
            if(tech.Gas_Credit_Meter_Classic_VS__c >0 && tech.Gas_Credit_Meter_Classic_VS__c < tech.Gas_Credit_Meter_Classic_BAU__c && tech.h_Gas_Credit_Meter_Classic_date__c==null) tech.h_Gas_Credit_Meter_Classic_date__c=System.today();
            if(tech.Gas_Credit_Meter_Semi_Con_Classic_VS__c >0 && tech.Gas_Credit_Meter_Semi_Con_Classic_VS__c < tech.Gas_Credit_Meter_Semi_Con_Classic_BAU__c && tech.h_Gas_Credit_Meter_Semi_Con_Classic__c==null) tech.h_Gas_Credit_Meter_Semi_Con_Classic__c=System.today();
            if(tech.Gas_PP_Libre_210_Domestic_Classic_VS__c < tech.Gas_PP_Libre_210_Domestic_Classic_BAU__c && tech.h_Gas_PP_Libre_210_Domestic_Classic__c==null) tech.h_Gas_PP_Libre_210_Domestic_Classic__c=System.today();
            if(tech.Gas_PP_Meter_G4_ETM_Classic_VS__c >0 && tech.Gas_PP_Meter_G4_ETM_Classic_VS__c  < tech.Gas_PP_Meter_G4_ETM_Classic_BAU__c && tech.h_Gas_PP_Meter_G4_ETM_Classic__c==null) tech.h_Gas_PP_Meter_G4_ETM_Classic__c=System.today();
            if(tech.Gas_PP_Meter_G4_ETM_Classic_VS__c > 0 && tech.Regulators_Gas_VS__c < tech.Regulators_Gas_BAU__c && tech.h_Regulators_Gas_date__c==null) tech.h_Regulators_Gas_date__c=System.today();
            if(tech.Smart_Electric_Meter_VS__c  > 0 && tech.Smart_Electric_Meter_VS__c < tech.Smart_Electric_Meter_BAU__c && tech.h_Smart_Electric_Meter_date__c==null ) tech.h_Smart_Electric_Meter_date__c=System.today();
            if(tech.Smart_Electric_Meter_New_Connections_VS__c > 0 && tech.Smart_Electric_Meter_New_Connections_VS__c < tech.Smart_Electric_Meter_New_Connections_BAU__c && tech.h_Smart_Electric_Meter_New_Connections__c==null) tech.h_Smart_Electric_Meter_New_Connections__c=System.today();
            if(tech.Smart_Energy_Display_SED_IHD_VS__c > 0 && tech.Smart_Energy_Display_SED_IHD_VS__c < tech.Smart_Energy_Display_SED_IHD_BAU__c && tech.h_Smart_Energy_Display_SED_IHD_date__c==null ) tech.h_Smart_Energy_Display_SED_IHD_date__c=System.today();
            if(tech.Smart_Gas_Meter_VS__c > 0 && tech.Smart_Gas_Meter_VS__c < tech.Smart_Gas_Meter_BAU__c && tech.h_Smart_Gas_Meter_date__c==null) tech.h_Smart_Gas_Meter_date__c=System.today();
            if(tech.Smart_Gas_Meter_Semi_Con_VS__c > 0 && tech.Smart_Gas_Meter_Semi_Con_VS__c < tech.Smart_Gas_Meter_Semi_Con_BAU__c && tech.h_Smart_Gas_Meter_Semi_Con__c==null) tech.h_Smart_Gas_Meter_Semi_Con__c=system.today(); 
            //CH07.start
             if(tech.E_Credit_Meter_4_Term_0244_Classic_VS__c>0 && tech.E_Credit_Meter_4_Term_0244_Classic_VS__c< tech.E_Credit_Meter_4_Term_0244_Classic_BAU__c && tech.h_E_Credit_Meter_4_Term_0244_Classic__c==null)
            tech.h_E_Credit_Meter_4_Term_0244_Classic__c=system.today(); 
             if(tech.E_Credit_Meter_4_Term_0935_Classic_VS__c>0 && tech.E_Credit_Meter_4_Term_0935_Classic_VS__c< tech.E_Credit_Meter_4_Term_0935_Classic_BAU__c && tech.h_E_Credit_Meter_4_Term_0935_Classic__c==null)
            tech.h_E_Credit_Meter_4_Term_0935_Classic__c=system.today(); 
             if(tech.E_Credit_Meter_5_Term_0244_Classic_VS__c>0 && tech.E_Credit_Meter_5_Term_0244_Classic_VS__c< tech.E_Credit_Meter_5_Term_0244_Classic_BAU__c && tech.h_E_Credit_Meter_5_Term_0244_Classic__c==null)
            tech.h_E_Credit_Meter_5_Term_0244_Classic__c=system.today(); 
             if(tech.E_Credit_Meter_5_Term_0935_Classic_VS__c>0 && tech.E_Credit_Meter_5_Term_0935_Classic_VS__c< tech.E_Credit_Meter_5_Term_0935_Classic_BAU__c && tech.h_E_Credit_Meter_5_Term_0935_Classic__c==null)
            tech.h_E_Credit_Meter_5_Term_0935_Classic__c=system.today(); 
             if(tech.Regulators_SC_Gas_VS__c>0 && tech.Regulators_SC_Gas_VS__c< tech.Regulators_SC_Gas_BAU__c && tech.h_Regulators_SC_Gas__c==null)
            tech.h_Regulators_SC_Gas__c=system.today(); 
             if(tech.Smart_Gas_Meter_New_Connections_VS__c>0 && tech.Smart_Gas_Meter_New_Connections_VS__c< tech.Smart_Gas_Meter_New_Connections_BAU__c && tech.h_Smart_Gas_Meter_New_Connections__c==null)
            tech.h_Smart_Gas_Meter_New_Connections__c=system.today(); 
            //CH07.end
        }   
    }
    //CH05.end
       
}