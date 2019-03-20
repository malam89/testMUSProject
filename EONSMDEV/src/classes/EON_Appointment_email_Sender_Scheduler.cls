/**
     Description : This Scheduled class will send SMS and emails to the customers
                 
     Test Class :EON_Appointment_SMS_Scheduler_test
**/
/*
        Created By: Aruna Manjari
        Created Date: 16/03/2016
        SR_ID :  SR_Isis_EON_012,SR_EON_PC_009
        
        Change History:
*/
   global with sharing class EON_Appointment_email_Sender_Scheduler implements Schedulable
   {
            /*
            //Runs job every day at 8:05 AM EST time
            EON_Appointment_email_Sender_Scheduler(); //Create an instance of class to be executable.
            //Format: Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
            String interval ='0 05 20 * * ?'; //Define time interval. To execute everyday at 08:05am
            String sJobID = System.schedule('EON Appointment email Sender Scheduler', interval, sd); //Schedule a class.
            */
  global void execute(SchedulableContext sc)
    {
      EmailtoCustomer();
         
    }      
       /**
        EmailtoCustomer()- This method is used to send email to customers with details of appointments whose Phone number is not present and also a list of records having technical issues while sending SMS.
    **/
     Public void EmailtoCustomer(){
      try
            {

                List<EON_Appointment__c>ListofAppointments_with_no_Phonenum= [SELECT  Customer_Name__c,id,Name,Start_Time__c,End_Time__c,format(Appointment_Date__c),h_EON_Appointment_Comms__c,(Select EON_Appointment_Comms__c.EON_Appointment_ID__c,EON_Appointment_Comms__c.Delivery_Method_Desc__c,EON_Appointment_Comms__c.Comm_Type_Code__c,EON_Appointment_Comms__c.name from EON_Appointment_Comms__r where (EON_Appointment_Comms__c.Delivery_Method_Desc__c='' or EON_Appointment_Comms__c.Delivery_Method_Desc__c =null) and EON_Appointment_Comms__c.Comm_Type_Code__c='R') FROM EON_Appointment__c where Appointment_Date__c=TOMORROW and h_EON_Appointment_Comms__c>0 order by Start_Time__c asc ];
                System.debug('***********List of All Appointments Scheduled for Tommorow But having no number in the system**********ListofAppointments_with_no_Phonenum='+ ListofAppointments_with_no_Phonenum);  
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                //Set Email Subject
                email.setSubject('Undelivered EON Installation Confirmation SMS');
                //Set ToAddress
                List<String> sendTo = new List<String>();
                for (String emID : Label.Email_list_of_the_users.split(';'))
                if ( emID != '' && emID != null ){ sendTo.add(emID); }
                email.setToAddresses(sendTo);
                email.setCcAddresses(new List<String>());
                String body = '<font style="font-family:arial;font-size:12px;">Hi,</font>' +'<br/>';
                body+='<br/>';
                body+='<font style="font-family:arial;font-size:12px;">Below is the report for Undelivered SMS as contact number is not available for the customers </font><br/>';
                body+='<br/>';
                // Table in email
                body+='<table style="width:100%;font-family:arial;font-size:10px; border-width: thin; border-style:solid;border-collapse: collapse; align:center" border="1" cellpadding="5"><tr><td align="center"><b>Customer name</b></td><td align="center"><b>Appointment start time</b></td><td align="center"><b>MUS Appointment ID</b></td><td align="center"><b>Appointment Date</b> </td></tr>';
                for( EON_Appointment__c app :ListofAppointments_with_no_Phonenum)
                { 
                    if(app.EON_Appointment_Comms__r.size()>0  && app.h_EON_Appointment_Comms__c<=app.EON_Appointment_Comms__r.size() )//If there are values  
                {
                 if(app.Start_Time__c==null ||app.Start_Time__c=='')
                 app.Start_Time__c= '-';
                 if(app.Customer_Name__c==null)
                 app.Customer_Name__c= '-';
                 datetime exm =app.Appointment_Date__c;
                 system.debug('********size of the appointment comm list********'+app.EON_Appointment_Comms__r.size());
                 system.debug('********size of the h_EON_Appointment_Comms__c ********'+app.EON_Appointment_Comms__r.size());
                 System.debug('List of customer'+ app.Customer_Name__c+'Appointment_Date__c'+app.Appointment_Date__c );
                 //sending the url of the cutomer records
               
                 String stringURLforAppointment=String.valueOf(System.Label.URL_link_of_the_org)+app.id;
                 body+='<tr><td align="center">'+app.Customer_Name__c+'</a></td><td align="center">'+app.Start_Time__c+'</td><td align="center">'+'<a href='+stringURLforAppointment+'>'+app.name+'</td><td align="center">'+exm.format('d-MMMM-yyyy')+'</td><tr>';            
                 } 
                 }  
                 body+='</table>'+'<br/>';             
                 //Errored SMS email logic 
                 string body1='<font style="font-family:arial;font-size:12px;">Below is the list of appointments whose SMS sending failed due to technical issues(e.g. Problem with SMS infrastructure).</font>' +'<br/>';        
                 Integer start =system.Now().millisecond();
                 List<Note>erroresSMS=[select ParentId from note where CreatedDate=today and Title='SMS Technical Failure'];
                 //get a list of errored appointment
                 List<id>listofparentid=new List<id>();
                 for (note erroredid:erroresSMS)
                  {
                      listofparentid.add(erroredid.ParentId);
                      system.debug('listofparentid'+listofparentid);
                  }
                  map<ID,EON_Appointment__c>Listoferroredappointments = new Map<ID,EON_Appointment__c> ([SELECT Customer_Name__c,Start_Time__c,Name,format(Appointment_Date__c) FROM EON_Appointment__c where Appointment_Date__c=TOMORROW and id in:listofparentid order by Start_Time__c asc ] );
                  system.debug('Listoferroredappointments'+Listoferroredappointments);
                  body1+='</table>'+'<br/>';  
                  body1+='<table style="width:100%;font-family:arial;font-size:10px; border-width: thin; border-style::solid;border-collapse: collapse; align:center" border="1" cellpadding="5" ><tr><td align="center"><b>Customer name</b></td><td align="center"><b>Appointment start time</b></td><td align="center"><b>MUS Appointment ID</b></td><td align="center"><b>Appointment Date </b></td></tr>';
                  for (EON_Appointment__c erroeapp : Listoferroredappointments.values()) 
                  {
                      system.debug('Listoferroredappointments.values()'+Listoferroredappointments.values());
                      if( erroeapp.Start_Time__c==null||erroeapp.Start_Time__c=='')
                      erroeapp.Start_Time__c= '-'; 
                      if(erroeapp.Customer_Name__c==null || erroeapp.Customer_Name__c=='')
                      erroeapp.Customer_Name__c= '-';
                      datetime appdate =erroeapp.Appointment_Date__c;
                      System.debug('List of appointments having teschnical  issue  '+'****Customer name'+ erroeapp.Customer_Name__c+'Appointment start time'+erroeapp.Start_Time__c+'Appointment_Date__c'+erroeapp.Appointment_Date__c );
                    
                      String stringURLforerrorAppointment=String.valueOf(System.Label.URL_link_of_the_org)+erroeapp.id;
                      
                      body1+='<tr><td align="center">'+erroeapp.Customer_Name__c+'</td><td align="center">'+erroeapp.Start_Time__c+'</td><td align="center">'+'<a href='+stringURLforerrorAppointment+'>'+erroeapp.name+'</td><td align="center">'+appdate.format('d-MMMM-yyyy')+'</td><tr>';                     
                  }
                  string body2='<font style="font-family:arial;font-size:12px;">&nbsp</font>'+'<br/>';
                  body2+= '</table>'+'<br/>';                      
                  body2+='Kind regards'+'<br/>';
                  body2+='MORRISON UTILITY SERVICES'+'<br/>';          
                  string body3;
                  body3=body+body1+body2;
                  email.setHtmlBody(body3);
                  Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});}catch(Exception e){ system.debug(e.getMessage()+'---'+e.getLineNumber() );}}}