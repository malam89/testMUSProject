/**
     Description : This Scheduled class will send SMS and emails to the customers
                 
     Test Class :EON_Appointment_SMS_Scheduler_test
**/

/*
        Created By: Aruna Manjari
        Created Date: 16/03/2016
        SR_ID :  SR_Isis_EON_012,SR_EON_PC_009
        
        Change History:CH01 #SR_EON_PC_037 # 23/04/2016 # Pedda Reddeiah # added code to achieve SR functionality 
       
*/
   global class EON_Appointment_SMS_Sender_Scheduler implements Schedulable
   {
              /*Runs job every day at 8:00AM EST time
              EON_Appointment_SMS_Sender_Scheduler sd = new EON_Appointment_SMS_Sender_Scheduler(); //Create an instance of class to be executable.
              //Format: Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
              String interval ='0 00 20 * * ?'; //Define time interval. To execute everyday at 08:00am
              String sJobID = System.schedule('EON Appointment SMS Sender Scheduler', interval, sd); //Schedule a class.
              */
       
  global void execute(SchedulableContext sc)
    {
      
     SMSsendtoCustomer();     
           
           
     }       
     
   Public void SMSsendtoCustomer()
   {
     
     try
            {
                // Get all the appointments details whose appointments are scheduled tommorow and have a phonenumber.        
                List<EON_Appointment__c>ListofAppointments = [SELECT id,Name,Start_Time__c,End_Time__c,format(Appointment_Date__c),h_EON_Appointment_Comms__c,(Select EON_Appointment_Comms__c.EON_Appointment_ID__c,EON_Appointment_Comms__c.Delivery_Method_Desc__c,EON_Appointment_Comms__c.Delivery_Method_Desc__r.name,EON_Appointment_Comms__c.Comm_Type_Code__c,EON_Appointment_Comms__c.name from EON_Appointment_Comms__r where (EON_Appointment_Comms__c.Delivery_Method_Desc__c!='' or EON_Appointment_Comms__c.Delivery_Method_Desc__c !=null) and EON_Appointment_Comms__c.Comm_Type_Code__c='R') FROM EON_Appointment__c where Appointment_Date__c=TOMORROW and h_EON_Appointment_Comms__c>0  order by Start_Time__c asc ];
                System.debug('***********List of All Appointments Scheduled for Tommorow**********'+ ListofAppointments);  
                List<EON_Appointment_Comms__c>ListofAppointments_comm = new List<EON_Appointment_Comms__c>();
                List< EON_Customer__c> Notavailable_Phone_num_cust=new List<EON_Customer__c>();
                //Set<id> FinalListofCustomer = new Set<ID>();
                for(EON_Appointment__c appointments : ListofAppointments)
                {
                            set<string>appoint_phonenumber = new set <string>();
                            if(appointments.EON_Appointment_Comms__r.size()>0)//If there are values   
                            {
                            system.debug('*****appointments.EON_Appointment_Comms__r.size()****'+appointments.EON_Appointment_Comms__r.size()+'****Appointment ID ****'+appointments.id);
                             //If there is a single  Appointment_Comms to Appointments 
                            if(appointments.h_EON_Appointment_Comms__c==1  )
                            {
                            
                            system.debug('****There is single Appointment*****************');
                            if(appointments.Start_Time__c==null || appointments.Start_Time__c == '')
                            appointments.Start_Time__c= '-'; 
                            id streetId=appointments.id;
                            system.debug('****For single appointments.id**** ='+appointments.id+'********Appointment Name:'+appointments.Name);
                            string isismessage='Meter installation reminder: Please have someone at home to receive the engineer from'+ appointments.Start_Time__c +'to'+ appointments.End_Time__c+'. Thanks, E.ON';
                            //string isisphoneNo ='7760360564';
                            string isisphoneNo =appointments.EON_Appointment_Comms__r[0].Delivery_Method_Desc__r.name;
                            system.debug('********Phone number**********'+appointments.EON_Appointment_Comms__r[0].Delivery_Method_Desc__c);
                            string isisSubject = 'Scheduled_EON_Appointments';
                            string isisRecipient= 'Email_list_of_the_users';
                            string isisRelatedObj= 'EON_Appointment';
                            string isiscontractToCharge= 'EON';
                                
                                //CH01.start
                                If( System.Label.EON_Enable_Appointment_SMS == 'True'){
                                    
                                    EON_Appointment_SMS_Sender_Helper.SMSSender(streetId, isismessage, isisphoneNo,isisSubject ,isisRecipient,isisRelatedObj,isiscontractToCharge);
                                    system.debug('Single sender sms');
                                }
                            //CH01.End
                            }
                           //If there are multiple  Appointment_Comms to Appointments 
                           if(appointments.h_EON_Appointment_Comms__c>1 )
                           {
                           for(EON_Appointment_Comms__c appointment_comm :appointments.EON_Appointment_Comms__r)
                           //For each Appointment_comms 
                           {
                           if(appoint_phonenumber.add(appointment_comm.Delivery_Method_Desc__c))//check the Multiple Phone number for appointment_comms 
                           { 
                            system.debug('*********There are multiple appointments **********'+'*****Comms=****'+appointments.h_EON_Appointment_Comms__c+'******list of phonemunber*****'+appointment_comm.Delivery_Method_Desc__c);
                            if(appointments.Start_Time__c == null || appointments.Start_Time__c == '')
                            appointments.Start_Time__c= '-'; 
                            id streetId=appointments.id;
                            system.debug('**** For Multiple appointments.id**** ='+appointments.id+'******Appointment name ********'+appointments.name);
                            string isismessage='Meter installation reminder: Please have someone at home to receive the engineer from'+ appointments.Start_Time__c +'to'+ appointments.End_Time__c+'. Thanks, E.ON';
                                string isisphoneNo =appointment_comm.Delivery_Method_Desc__c;
                            system.debug('********Phone number**********'+appointment_comm.Delivery_Method_Desc__c);
                            string isisSubject = 'Scheduled_EON_Appointments';
                            string isisRecipient= 'Email_list_of_the_users';
                            string isisRelatedObj= 'EON_Appointment';
                            string isiscontractToCharge= 'EON';
                               
                              //CH01.start 
                               If( System.Label.EON_Enable_Appointment_SMS  == 'True'){
                                    EON_Appointment_SMS_Sender_Helper.SMSSender(streetId, isismessage, isisphoneNo,isisSubject ,isisRecipient,isisRelatedObj,isiscontractToCharge);
                                    system.debug(' Multiple sender sms ');}}}}}}}catch(Exception e){system.debug(e.getMessage()+'---'+e.getLineNumber() );}}}//CH01.end
                /*************** Email Part************************/
                //Get the list of all appointments whose phone number is not present but have their appointment tomorrow scheduled.       
                //Delay for 5 minssystem.now().minute()
                
               //commenting out the email part
               /********************
                List<EON_Appointment__c>ListofAppointments_with_no_Phonenum= [SELECT  Customer_Name__c,id,Name,Start_Time__c,End_Time__c,format(Appointment_Date__c),h_EON_Appointment_Comms__c,(Select EON_Appointment_Comms__c.EON_Appointment_ID__c,EON_Appointment_Comms__c.Delivery_Method_Desc__c,EON_Appointment_Comms__c.Comm_Type_Code__c,EON_Appointment_Comms__c.name from EON_Appointment_Comms__r where (EON_Appointment_Comms__c.Delivery_Method_Desc__c='' or EON_Appointment_Comms__c.Delivery_Method_Desc__c =null) and EON_Appointment_Comms__c.Comm_Type_Code__c='R') FROM EON_Appointment__c where Appointment_Date__c=TOMORROW and h_EON_Appointment_Comms__c>0 order by Start_Time__c asc ];
                System.debug('***********List of All Appointments Scheduled for Tommorow But having no number in the system**********ListofAppointments_with_no_Phonenum='+ ListofAppointments_with_no_Phonenum);  
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                //Set Email Subject
                email.setSubject('Undelivered EON Installation Confirmation SMS');
                //Set ToAddress
                String[] toAddresses = new String[] {System.Label.Email_list_of_the_users};
                email.setToAddresses(toAddresses);
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
                 if(app.Start_Time__c==null)
                 app.Start_Time__c= '-';
                 if(app.Customer_Name__c==null)
                 app.Customer_Name__c= '-';
                 datetime exm =app.Appointment_Date__c;
                 system.debug('********size of the appointment comm list********'+app.EON_Appointment_Comms__r.size());
                 system.debug('********size of the h_EON_Appointment_Comms__c ********'+app.EON_Appointment_Comms__r.size());
                 System.debug('List of customer'+ app.Customer_Name__c+'Appointment_Date__c'+app.Appointment_Date__c );
                 //sending the url of the cutomer records
                 //String stringURLforCustomer=String.valueOf('https://cs87.salesforce.com/')+app.Fuel_ID__r.Customer__r.id;
                 //sending the url of the Appointment ID records
                 String stringURLforAppointment=String.valueOf(System.Label.URL_link_of_the_org)+app.id;
                 body+='<tr><td align="center">'+app.Customer_Name__c+'</a></td><td align="center">'+app.Start_Time__c+'</td><td align="center">'+'<a href='+stringURLforAppointment+'>'+app.name+'</td><td align="center">'+exm.format('d-MMMM-yyyy')+'</td><tr>';            
                 } 
                 }  
                 body+='</table>'+'<br/>';             
                 //Errored SMS email logic 
                 string body1='<font style="font-family:arial;font-size:12px;">Below is the list of appointments whose SMS sending failed due to technical issues(e.g. Problem with SMS infrastructure).</font>' +'<br/>';        
                 Integer start =system.Now().millisecond();
                 while(System.Now().millisecond()< start+100)
                 { 
                 System.debug('Waiting time'+System.Now().millisecond());
               
                 }
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
                      if( erroeapp.Start_Time__c==null)
                      erroeapp.Start_Time__c= '-'; 
                      if(erroeapp.Customer_Name__c==null)
                      erroeapp.Customer_Name__c= '-';
                      datetime appdate =erroeapp.Appointment_Date__c;
                      System.debug('List of appointments having teschnical  issue  '+'****Customer name'+ erroeapp.Customer_Name__c+'Appointment start time'+erroeapp.Start_Time__c+'Appointment_Date__c'+erroeapp.Appointment_Date__c );
                      //sending the url of the cutomer records
                      //String stringURLforerrorCustomer=String.valueOf('https://cs87.salesforce.com/')+erroeapp.Fuel_ID__r.Customer__r.id;
                      //sending the url of the Appointment ID records
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
                  Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                 
                  **************/
                  //Commenting out the email part /************email part Ends ****************/
            
/****************** Below code is commented out
     Description : This Scheduled class will send SMS and emails to the customers
                 
     Test Class :EON_Appointment_SMS_Sender_Scheduler_Test
**/
/*
        Created By: Aruna Manjari
        Created Date: 16/03/2016
        SR_ID :  SR_EON_PC_009
        
        Change History:
*/

/*****************
     global class EON_Appointment_SMS_Sender_Scheduler implements Schedulable
     {
    
            // Runs job every day at 7:00AM EST time
            private static final String CRON_EXP = '0 0 23 * * ? *';
        global void execute(SchedulableContext sc){
            try{
                // Get all the appointments details         
                List<EON_Appointment__c>ListofCustomers=[SELECT Fuel_ID__r.Customer__r.name,Start_Time__c,Name,format(Appointment_Date__c)  FROM EON_Appointment__c where Appointment_Date__c=TODAY];
                //This List will hold all the appointments for today
                System.debug('List of customers having todays appointment'+ ListofCustomers);  
                Set<id> FinalListofCustomer = new Set<ID>();
                List< EON_Customer__c>available_Phone_num_cust=new List<EON_Customer__c>();
                List< EON_Customer__c> Notavailable_Phone_num_cust=new List<EON_Customer__c>();
                List<EON_Appointment__c>Appointmentdetailtobeemailed=new  List<EON_Appointment__c>();
                List<EON_Customer__c>Listoffuelidfromcustomerid=new  List<EON_Customer__c>();
                List<string>listoffuelid=new List<string>();
                Map<id,list<EON_Appointment__c>> mapofappointments =new  Map<id,List<EON_Appointment__c>>();  
                List<EON_Appointment__c>Appointmentdetailtobeemailed1=new  List<EON_Appointment__c>();
                Map<id,list<EON_Appointment__c>> mapofappointments1 =new  Map<id,List<EON_Appointment__c>>(); 
                
                For(EON_Appointment__c allcustomers :ListofCustomers)
                {
                     FinalListofCustomer.add(allcustomers.Fuel_ID__r.Customer__c);
                     System.debug('FinalListofCustomer'+FinalListofCustomer);
                }
                
                //from parent to child customer to customer media
                available_Phone_num_cust=[SELECT Name,(select EON_Contact_media__c.Contact_method_type__c,EON_contact_media__c.Phone_Number__c, EON_contact_media__c.Is_preferred_contact_method__c from EON_contact_media__r where  EON_contact_media__c.Phone_Number__c!='' OR EON_contact_media__c.Phone_Number__c!=null ) FROM EON_Customer__c WHERE Id IN: FinalListofCustomer  and h_EON_contact_Media__c >0];     
                
                //Sending the SMS to the customers whose contacts are present in the system
                //************SMS PART*************Sending SMS to customers*******************
                  
                System.debug( 'available_Phone_num_cust'+available_Phone_num_cust);
                List<EON_Fuel__c> fuels1=[select  EON_Fuel__c.Name  from EON_Fuel__c WHERE Customer__c IN:available_Phone_num_cust];
                System.debug('list of fuels'+fuels1);
                Appointmentdetailtobeemailed1=[select name,Appointment_Date__c from  EON_Appointment__c where Fuel_ID__c in : fuels1];
                System.debug('Appointmentdetailtobesms'+Appointmentdetailtobeemailed1);
                //Map to get details
                map<ID,EON_Appointment__c>listoffinalappointments1 = new Map<ID,EON_Appointment__c>([SELECT Fuel_ID__r.Customer__r.ID,Fuel_ID__r.Customer__r.name,Start_Time__c,End_Time__c,Name,Appointment_Date__c FROM EON_Appointment__c where Fuel_ID__c in : fuels1 and Appointment_Date__c=TODAY ]);
                List<ID>customertophone=new List<ID>();
                system.debug('listoffinalappointments1'+listoffinalappointments1);
                for (EON_Appointment__c app0 : listoffinalappointments1.values() ) 
                {
                    customertophone.add(app0.Fuel_ID__r.Customer__r.ID);
                    system.debug('customertophone.add(app0.Fuel_ID__r.Customer__r.name);'+customertophone);
                }
                list<EON_Contact_media__c>Listofcontactswithphonenum=[select Customer__c,Phone_Number__c from EON_Contact_media__c where Phone_Number__c!='' and  Customer__c in: customertophone];
                system.debug('Listofcontactswithphonenum'+Listofcontactswithphonenum);
                map<id,string>custphone=new  map<id,string>();
                for( EON_Contact_media__c conmedia:Listofcontactswithphonenum)
                {
                  custphone.put(conmedia.Customer__c,conmedia.Phone_Number__c);
                  system.debug('custphone'+custphone);
                }
                system.debug('map ofcustomer and phone number'+custphone);
                /*for (EON_Appointment__c app1 : listoffinalappointments1.values() ) 
                {      
                    if(custphone.get(app1.Fuel_ID__r.Customer__r.id)!='' ||custphone.get(app1.Fuel_ID__r.Customer__r.id)!='null'  )
                    {
                    system.debug('listoffinalappointments1.values()'+listoffinalappointments1.values());
                    system.debug('custphone.get(app1.Fuel_ID__r.Customer__r.id)'+custphone.get(app1.Fuel_ID__r.Customer__r.id));
                    id streetId=app1.id;
                    system.debug('app1.id ='+app1.id);
                    string isismessage='Meter installation reminder: Please have someone at home to receive the engineer from [app1.Start_Time__c - HH:MM] to [app1.End_Time__c - HH:MM]. Thanks, E.ON ';
                    string isisphoneNo =custphone.get(app1.Fuel_ID__r.Customer__r.id);
                    string isisSubject = 'Scheduled EON Appointments';
                    string isisRecipient= 'aruna.manjari@zensar.in';
                    string isisRelatedObj= 'EON Appointment';
                    string isiscontractToCharge= 'EON';
                    EON_Appointment_SMS_Sender_Helper.SMSSender(streetId, isismessage, isisphoneNo,isisSubject ,isisRecipient,isisRelatedObj,isiscontractToCharge);
                    system.debug('sms sender calling');
                    }
                }*/
                
                //Change
               /*** List<EON_Appointment__c> Listoffinalappointments2 = new List<EON_Appointment__c>([SELECT Fuel_ID__r.Customer__r.name,Fuel_ID__r.Customer__c,Start_Time__c,Name,format(Appointment_Date__c)  FROM EON_Appointment__c where Fuel_ID__c in : fuels1  and Appointment_Date__c=TODAY ]);
                map<ID,List<EON_Appointment__c>> ListoffinalappointmentsMap2 = new map<ID,List<EON_Appointment__c>>();
                for( EON_Appointment__c appFinal :Listoffinalappointments2){                 
                    if(!ListoffinalappointmentsMap2.containsKey(appFinal.Fuel_ID__r.Customer__c))
                            ListoffinalappointmentsMap2.put(appFinal.Fuel_ID__r.Customer__c, new List<EON_Appointment__c>());
                        ListoffinalappointmentsMap2.get(appFinal.Fuel_ID__r.Customer__c).add(appFinal);
                
                }
                for(EON_Customer__c custnm:available_Phone_num_cust)
                 {
                     if(custnm.EON_contact_media__r.size()>0)
                     {
                         system.debug('custnm.EON_contact_media__r.size()'+custnm.EON_contact_media__r.size());
                         List<EON_Appointment__c> lstapp= ListoffinalappointmentsMap2.get(custnm.id);
                         for(EON_Appointment__c app1:lstapp){
                            id streetId=app1.id;
                            //id streetId='a6b8E0000008OJI';
                            system.debug('app1.id ='+app1.id);
                            string isismessage='Meter Installation Reminder: Pplease have someone at home to receive the engineer from app1.Start_Time__c to app1.End_Time__c. Thanks, E.ON ';
                            //string isisphoneNo ='9637466636';
                            
                            string isisphoneNo =custnm.EON_contact_media__r[0].Phone_Number__c;
                            system.debug('custnm.EON_contact_media__r[0].Phone_Number__c'+custnm.EON_contact_media__r[0].Phone_Number__c);
                            string isisSubject = 'Scheduled_EON_Appointments';
                            string isisRecipient= 'aruna.manjari@zensar.in';
                            string isisRelatedObj= 'EON_Appointment';
                            string isiscontractToCharge= 'eEON';
                            EON_Appointment_SMS_Sender_Helper.SMSSender(streetId, isismessage, isisphoneNo,isisSubject ,isisRecipient,isisRelatedObj,isiscontractToCharge);
                            system.debug('sms sender calling');
                         
                            } 
                    }
                  }
                  //Change
                

                //**********EMAIL PART***************Sending email report *********************
                Notavailable_Phone_num_cust=[SELECT Name,(select EON_Contact_media__c.Contact_method_type__c,EON_contact_media__c.Phone_Number__c, EON_contact_media__c.Is_preferred_contact_method__c from EON_contact_media__r where  EON_contact_media__c.Phone_Number__c='' ) FROM EON_Customer__c WHERE id IN:FinalListofCustomer ];         
                //List of customers who don't have phone number updated so mail will be send for these customers        
                System.debug( 'Notavailable_Phone_num_cust'+available_Phone_num_cust);
                List<EON_Fuel__c> fuels=[select  EON_Fuel__c.Name  from EON_Fuel__c WHERE Customer__c IN:Notavailable_Phone_num_cust];
                System.debug('list of fuels'+fuels);
                Appointmentdetailtobeemailed=[select name,Appointment_Date__c from  EON_Appointment__c where Fuel_ID__c in : fuels];
                System.debug('Appointmentdetailtobeemailed'+Appointmentdetailtobeemailed);
                //Map to get details
                List<EON_Appointment__c> Listoffinalappointments = new List<EON_Appointment__c>([SELECT Fuel_ID__r.Customer__r.name,Fuel_ID__r.Customer__c,Start_Time__c,Name,format(Appointment_Date__c)  FROM EON_Appointment__c where Fuel_ID__c in : fuels  and Appointment_Date__c=TODAY ]);
                map<ID,List<EON_Appointment__c>> ListoffinalappointmentsMap = new map<ID,List<EON_Appointment__c>>();
                for( EON_Appointment__c appFinal :Listoffinalappointments){                 
                    if(!ListoffinalappointmentsMap.containsKey(appFinal.Fuel_ID__r.Customer__c))
                            ListoffinalappointmentsMap.put(appFinal.Fuel_ID__r.Customer__c, new List<EON_Appointment__c>());
                        ListoffinalappointmentsMap.get(appFinal.Fuel_ID__r.Customer__c).add(appFinal);
                
                }
                 
                system.debug('MAPoffinalappointments'+ListoffinalappointmentsMap);
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                //Set Email Subject
                email.setSubject('Undelivered SMS Report');
                //Set ToAddress
                String[] toAddresses = new String[] {'aruna.manjari@zensar.in'};
                email.setToAddresses(toAddresses);
                email.setCcAddresses(new List<String>());
                 String body = '<font style="font-family:arial;font-size:12px;">Hi,</font>' +'<br/>';
                 body+='<br/>';
                 body+='<font style="font-family:arial;font-size:12px;">Below is the report for Undelivered SMS as contact number is not available for the customers </font><br/>';
                 body+='<br/>';
                 // Table in email
                 body+='<table style="width:100%;font-family:arial;font-size:10px; border-width: thin; border-style:solid;border-collapse: collapse; align:center" border="1" cellpadding="5"><tr><td align="center"><b>Customer name</b></td><td align="center"><b>Appointment start time</b></td><td align="center"><b>MUS Appointment ID</b></td><td align="center"><b>Appointment Date</b> </td></tr>';
                 // Check if the customers have contacts in contact media
                 for(EON_Customer__c custnm1:Notavailable_Phone_num_cust)
                 {
                     if(custnm1.EON_contact_media__r.size()>0)
                     {
                         system.debug('custnm.EON_contact_media__r.size()'+custnm1.EON_contact_media__r.size());
                         List<EON_Appointment__c> lstapp= ListoffinalappointmentsMap.get(custnm1.id);
                         for(EON_Appointment__c app:lstapp){
                         if(app.Start_Time__c==null)
                                app.Start_Time__c= '-'; 
                             datetime exm =app.Appointment_Date__c;
                             system.debug('********formatdateTemp'+exm.format('d-MMMM-yyyy'));
                              System.debug('List of customer'+ app.Fuel_ID__r.Customer__r.name+'Appointment_Date__c'+app.Appointment_Date__c );
                              body+='<tr><td align="center">'+app.Fuel_ID__r.Customer__r.name+'</td><td align="center">'+app.Start_Time__c+'</td><td align="center">'+app.name+'</td><td align="center">'+exm.format('d-MMMM-yyyy')+'</td><tr>';            
                          }
                      }  
                  }
                  body+='</table>'+'<br/>';             
                  //Errored SMS email logic 
                  string body1='<font style="font-family:arial;font-size:12px;">Below is the list of appointments whose SMS sending failed due to technical issues.</font>' +'<br/>';        
                  List<Note>erroresSMS=[select ParentId from note where CreatedDate=today];
                  //get a list of errored appointment
                  set<id>listofparentid=new set<id>();
                  for (note erroredid:erroresSMS)
                  {
                      listofparentid.add(erroredid.ParentId);
                      system.debug('listofparentid'+listofparentid);
                  }
                  map<ID,EON_Appointment__c>Listoferroredappointments = new Map<ID,EON_Appointment__c> ([SELECT Fuel_ID__r.Customer__r.name,Start_Time__c,Name,format(Appointment_Date__c) FROM EON_Appointment__c where id in:listofparentid]);
                  system.debug('Listoferroredappointments'+Listoferroredappointments);
                  body1+='</table>'+'<br/>';  
                  body1+='<table style="width:100%;font-family:arial;font-size:10px; border-width: thin; border-style::solid;border-collapse: collapse; align:center" border="1" cellpadding="5" ><tr><td align="center"><b>Customer name</b></td><td align="center"><b>Appointment start time</b></td><td align="center"><b>MUS Appointment ID</b></td><td align="center"><b>Appointment Date </b></td></tr>';
                  for (EON_Appointment__c erroeapp : Listoferroredappointments.values()) 
                  {
                      system.debug('Listoferroredappointments.values()'+Listoferroredappointments.values());
                      if( erroeapp.Start_Time__c==null)
                        erroeapp.Start_Time__c= '-'; 
                      datetime appdate =erroeapp.Appointment_Date__c;
                      System.debug('List of appointments having teschnical  issue  '+'****Customer name'+ erroeapp.Fuel_ID__r.Customer__r.name+'Appointment start time'+erroeapp.Start_Time__c+'Appointment_Date__c'+erroeapp.Appointment_Date__c );
                      body1+='<tr><td align="center">'+erroeapp.Fuel_ID__r.Customer__r.name+'</td><td align="center">'+erroeapp.Start_Time__c+'</td><td align="center">'+erroeapp.name+'</td><td align="center">'+appdate.format('d-MMMM-yyyy')+'</td><tr>';                     
                  }
                  string body2='<font style="font-family:arial;font-size:12px;">&nbsp</font>'+'<br/>';
                  body2+= '</table>'+'<br/>';                      
                  body2+='Kind regards'+'<br/>';
                  body2+='MORRISON UTILITY SERVICES'+'<br/>';          
                  string body3;
                  body3=body+body1+body2;
                  email.setHtmlBody(body3);
                  Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
          catch(Exception e)
          { 
          system.debug(e.getMessage()+'---'+e.getLineNumber() ); 
          }  


        }       
      }*/