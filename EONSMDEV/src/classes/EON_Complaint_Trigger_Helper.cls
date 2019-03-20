/**
    Description : This is the helper class for 'EON_Complaint_Trigger' Trigger.

    Test Class  : EON_Complaint_Trigger_Helper_Test
**/
/* 
Created By  : Mahadev J
Created On  : 28/04/2016
Service Req : SR_EON_PC_015

CHANGE HISTORY:     
CH01 # SR_OptiMUS_EON_057 # 02/05/2017 # Praveen G # added new method for auto updating the complaint fields from related appointment.
CH02 # SR_OptiMUS_EON_188 # 15/01/2018 # Mehboob Alam # Added a new method for calculating number of Complaints for an Appointment.
*/

public with sharing class EON_Complaint_Trigger_Helper 
{
    /**
        sendEmailOnInsert(List<EON_Complaint__c>) : This method will call from the trigger EON_Complaint_Trigger to list all email messages.
    **/
    public static void sendEmailOnInsert(List<EON_Complaint__c> EONComplaints){
        String severity = '';
        String status = '';
        EON_Complaint_Trigger_Helper eonComplainHelper = new EON_Complaint_Trigger_Helper();
        List<Messaging.SingleEmailMessage>  emailList = new List<Messaging.SingleEmailMessage>();   //Hold list of email message to send 
        List<String> sendToNormal = new List<String>();                                             //Hold list of TO-email address for NORMAL severity
        sendToNormal = Label.EON_Complaint_Normal_Severity_Emails.split(';');
        
        List<String> sendToHighest = new List<String>();                                            //Hold list of TO-email address for Highest severity
        sendToHighest = Label.EON_Complaint_Highest_Severity_Emails.split(';');
        if(EON_Complaint_Trigger_Helper_Test.genException == null)
            EON_Complaint_Trigger_Helper_Test.genException = false;
        try
        {
            if(EON_Complaint_Trigger_Helper_Test.genException) //Generate Exception
                ID test = ID.valueOf('incorrectID');
            for(EON_Complaint__c eonComp:EONComplaints)
            {
               if(eonComp.Complaint_status__c != null && eonComp.Complaint_status__c != '')
                    status = eonComp.Complaint_status__c;
                if(status.equalsIgnoreCase('RAISED'))
                {
                    if( eonComp.Complaint_Category_Level_1__c!=null &&  eonComp.Complaint_Category_Level_1__c != '')
                    {
                        String eMessageBody = '';
                        String eMessageSubject = '';
                        Messaging.SingleEmailMessage eMessage = new Messaging.SingleEmailMessage();
                        severity = eonComp.Complaint_Category_Level_1__c;
                        String complaintStatus = '';                    
                        if(eonComp.Status_update_time__c != null)                    
                        {                        
                            DateTime complaintDate = eonComp.Status_update_time__c;   
                            complaintStatus = String.valueOf(complaintDate.day())+'/'+String.valueOf(complaintDate.month())+'/'+String.valueOf(complaintDate.year())+' '+String.valueOf(complaintDate.hour())+':'+String.valueOf(complaintDate.minute());
                            //complaintStatus = complaintDate.format('dd/mmm/yyyy hh:mm');                    
                        }
                        if(severity.equalsIgnoreCase('HIGH PRIORITY'))
                        {
                            eMessageSubject = 'URGENT – HIGH PRIORITY COMPLAINT';
                            eMessageBody = 'A high priority complaint with reference '+ eonComp.Name +' has been raised at '+complaintStatus+'.';
                            eMessage.setToAddresses(sendToHighest);
                            eMessage.emailPriority = 'Highest';
                        }
                        else
                        {
                            eMessageSubject = 'New complaint logged';
                            eMessageBody = 'A new complaint with reference '+ eonComp.Name +' has been raised at '+complaintStatus+'.';
                            eMessage.setToAddresses(sendToNormal);
                        }
                        eMessage.setSubject(eMessageSubject);
                        eMessage.setHtmlBody(eMessageBody);
                        emailList.add(eMessage);
                    }
                }
            }
            eonComplainHelper.sendEmail(emailList);
        }
        catch(Exception ex){System.debug('***Error while sending email: '+ex.getStackTraceString());}
    }
    /**
        sendEmailOnUpdate(List<EON_Complaint__c>) : This method will call from the trigger EON_Complaint_Trigger to list all email messages.
    **/
    public static void sendEmailOnUpdate(Map<Id, EON_Complaint__c> oldEONComplaints, Map<Id, EON_Complaint__c> newEONComplaints)
    {
        String severity = '';
        String status = '';
        String eMessageBody = '';
        String eMessageSubject = '';
        EON_Complaint_Trigger_Helper eonComplainHelper = new EON_Complaint_Trigger_Helper();
        List<Messaging.SingleEmailMessage>  emailList = new List<Messaging.SingleEmailMessage>();   //Hold list of email message to send 
        List<String> sendToNormal = new List<String>();                                             //Hold list of TO-email address for NORMAL severity
        sendToNormal = Label.EON_Complaint_Normal_Severity_Emails.split(';');
        
        List<String> sendToHighest = new List<String>();                                            //Hold list of TO-email address for Highest severity
        sendToHighest = Label.EON_Complaint_Highest_Severity_Emails.split(';');
        if(EON_Complaint_Trigger_Helper_Test.genException == null)
            EON_Complaint_Trigger_Helper_Test.genException = false;
        try
        {
            if(EON_Complaint_Trigger_Helper_Test.genException) //Generate Exception
                ID test = ID.valueOf('incorrectID');
            for(EON_Complaint__c eonComp:newEONComplaints.values())
            {
                if(eonComp.Complaint_status__c != null && eonComp.Complaint_status__c != '')
                    status = eonComp.Complaint_status__c;
                if(status.equalsIgnoreCase('RAISED'))
                {
                    if( eonComp.Complaint_Category_Level_1__c!=null &&  eonComp.Complaint_Category_Level_1__c != '')
                    {
                        severity = eonComp.Complaint_Category_Level_1__c;
                        EON_Complaint__c oldComp = oldEONComplaints.get(eonComp.ID);
                        String complaintStatus = '';                    
                        if(eonComp.Status_update_time__c != null)                    
                        {                        
                            DateTime complaintDate = eonComp.Status_update_time__c;                        
                            complaintStatus = String.valueOf(complaintDate.day())+'/'+String.valueOf(complaintDate.month())+'/'+String.valueOf(complaintDate.year())+' '+String.valueOf(complaintDate.hour())+':'+String.valueOf(complaintDate.minute());
                            //complaintStatus = complaintDate.format('dd/mmm/yyyy hh:mm');                    
                        }
                        if(eonComp.Complaint_Category_Level_1__c != oldComp.Complaint_Category_Level_1__c)
                        {
                            Messaging.SingleEmailMessage eMessage = new Messaging.SingleEmailMessage();
                            if(severity.equalsIgnoreCase('HIGH PRIORITY'))
                            {
                                eMessageSubject = 'URGENT – HIGH PRIORITY COMPLAINT';
                                eMessageBody = 'A high priority complaint with reference '+ eonComp.Name +' has been raised at '+complaintStatus+'.';
                                eMessage.setToAddresses(sendToHighest);
                                eMessage.emailPriority = 'Highest';
                            }
                            else
                            {
                                eMessageSubject = 'New complaint logged';
                                eMessageBody = 'A new complaint with reference '+ eonComp.Name +' has been raised at '+complaintStatus+'.';
                                eMessage.setToAddresses(sendToNormal);
                            }
                            eMessage.setSubject(eMessageSubject);
                            eMessage.setHtmlBody(eMessageBody);
                            emailList.add(eMessage);
                        }
                    }
                }
            }
            eonComplainHelper.sendEmail(emailList);
        }
        catch(Exception ex){System.debug('***Error while sending email: '+ex.getStackTraceString());}
    }
    /**
    sendEmail(List<Messaging.SingleEmailMessage>) : This is generic method to send email
    **/
    private void sendEmail(List<Messaging.SingleEmailMessage> emailMessages)
    {
        if(emailMessages != null)
            if(emailMessages.size()>0)
                Messaging.sendEmail(emailMessages);
    }
    
    
    /**
        UpdateComplaintfieldsFromAppointment(List<EON_Complaint__c> triggerNew): 
                            This method is used to update the complaint related fields from related Appointment.
    **/    
    public static void UpdateComplaintfieldsFromAppointment(List<EON_Complaint__c> triggerNew){
        List<id> lstAppointmentId = new List<id>();
        for(EON_Complaint__c complaint : triggerNew){
            lstAppointmentId.add(complaint.Appointment__c);
        }
        
        Map<id, Eon_Appointment__c> mapIDAppointment = new Map<id, Eon_Appointment__c>(
                    [select id, Customer_Name__c, Caller_Name__c, Contact_Telephone_Number__c,
                            Oracle_Address__c, Oracle_Town__c, Oracle_Postcode__c 
                         from Eon_Appointment__c where id in : lstAppointmentId]);
                    
        for(EON_Complaint__c complaint : triggerNew){
            Eon_Appointment__c app = mapIDAppointment.get(complaint.Appointment__c);
            
            if(app != null){
                if(String.isBlank(complaint.Customer_Name__c))
                    complaint.Customer_Name__c = app.Customer_Name__c; 
                    
                if(String.isBlank(complaint.Name_of_Contact__c))
                    complaint.Name_of_Contact__c = app.Caller_Name__c;                
                    
                if(String.isBlank(complaint.Contact_Information1__c))
                    complaint.Contact_Information1__c = app.Contact_Telephone_Number__c;
                    
                if(String.isBlank(complaint.Address__c))
                    complaint.Address__c = app.Oracle_Address__c;
                    
                if(String.isBlank(complaint.City__c))
                    complaint.City__c = app.Oracle_Town__c; 
                    
                if(String.isBlank(complaint.Post_Code__c))
                    complaint.Post_Code__c= app.Oracle_Postcode__c;
            }                                                       
                
        }                    
    }
    
    
    //CH02.Start
    /**
    ComplaintCountOnAppointment(List<EON_Complaint__c> LstComplaint):This method for calculating number of Complaints for an Appointment..
    **/    
    public static void ComplaintCountOnAppointment(List<EON_Complaint__c> LstComplaint){
    	List<EON_Appointment__c> lstApp = new List<EON_Appointment__c>();
    	List<EON_Appointment__c> udpateApp = new List<EON_Appointment__c>();
    	Set<ID> AppIds =  new Set<ID>(); //List of All Appointment ids
            for(EON_Complaint__c cmp : LstComplaint)
               if(cmp.Appointment_ID__c!=null)
                   AppIds.add(cmp.Appointment_ID__c);

    
        // Relationship Query to get all child records 
        lstApp = [select ID, Appointment_Complaint_Count__c, (select ID from EON_Complaints1__r) from EON_Appointment__c where ID in: AppIds];
        
         for(EON_Appointment__c eApp : lstApp){
         	if(eApp.Appointment_Complaint_Count__c!=null){
         	   if(eApp.Appointment_Complaint_Count__c != string.ValueOf(eApp.EON_Complaints1__r.size())){
         	 	   eApp.Appointment_Complaint_Count__c = string.ValueOf(eApp.EON_Complaints1__r.size());
         	        udpateApp.add(eApp);
         	    }
         	} 
         	  else{  
         	     eApp.Appointment_Complaint_Count__c = string.ValueOf(eApp.EON_Complaints1__r.size());
         	     udpateApp.add(eApp);
         	  }
         } 
         if(!udpateApp.isEmpty())
             update udpateApp;
      }         
      //CH02.End                       
}