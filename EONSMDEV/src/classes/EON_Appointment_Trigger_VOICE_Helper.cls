/**
    Description : This class is used to send appointment and appointment contact information to VOICE.
    Test Class : EON_Appointment_Triger_VOICE_Helper_Test
**/
/*
    Created By : Praveen G
    Created Date : 18-July-2016
    Service Request : SR_EON_AB_073
    
    CHANGE HISTORY:
    CH01 # SR_EON_AB_118 # 05/08/2016 # Praveen Garikipati # added new fields to be sent to VOICE. 
    CH02 # SR_EON_AB_128 # 24/08/2016 # Praveen Garikipati # added new rule before send it to VOICE. 
    CH03 # SR_EON_AB_165 # 12/10/2016 # Puneet Mehta # Mapped three new variables as per the new WSDL.
    CH04 # SR_EON_AB_173 # 27/10/2016 # Praveen Garikipati # Removed the jobcode logic filter to send VOICE.
            removed SR_EON_AB_118 changes (CH01)  
    CH05 # SR_EON_Jumbo_109 # 31/03/2017 # Akshay B # introduced email service to avoid future to future error.
    CH06 # SR_OptiMUS_EON_142 # 06/11/2017 # Praveen Garikipati # Added 2 new fields to send to VOICE.
    CH07 # CheckMark # 08/02/2018 # Abhilash # Checkmarx report related code improvement
    CH08 # SR_OptiMUS_EON_257 # 19/07/2018 # Mehboob Alam # IF EON Appointment Booking System Name - MUS-DA DO NOT send the appointment to Voice
    CH09 # Puneet Mehta #20/11/2018 #added logic to avoid email limit in live
*/
public with sharing class EON_Appointment_Trigger_VOICE_Helper{
    
    /**
        sendAppointmentInfoToVoice(List<EON_Appointment__c> lstAppointment MAP<id, EON_Appointment__c> mapIDAppointment,
                                    , boolean isNew) - 
                        This method is called from EON Appointment Trigger and send the same info to VOICE via 
                        webservice interface.
    **/
    public static void sendAppointmentInfoToVoice(List<EON_Appointment__c> lstAppointment, MAP<id, EON_Appointment__c> oldMapIDAppointment, boolean isNew){
        boolean isTrue = false;
        boolean isSentToVoice = true; //CH08
        if(!isNew){
            for(EON_Appointment__c newApp : lstAppointment){
               if(newApp.Booking_System_Name__c=='MUS-DA') //CH08
                  isSentToVoice = false;  //CH08
                if(isSentToVoice){   //CH08
                    EON_Appointment__c oldAppoitment = oldMapIDAppointment.get(newApp.id);
                    if(newApp.Fuel_ID__c != oldAppoitment.Fuel_ID__c || newApp.Booking_System_Name__c != oldAppoitment.Booking_System_Name__c
                        || newApp.Status__c != oldAppoitment.Status__c || newApp.Cancel_Reason__c != oldAppoitment.Cancel_Reason__c
                        || newApp.Appointment_Date__c != oldAppoitment.Appointment_Date__c
                        || newApp.Time_Slot__c != oldAppoitment.Time_Slot__c
                        || newApp.Start_Time__c != oldAppoitment.Start_Time__c
                        || newApp.End_Time__c != oldAppoitment.End_Time__c
                        || newApp.Technician__c != oldAppoitment.Technician__c
                        || newApp.Caller_Name__c != oldAppoitment.Caller_Name__c
                        || newApp.Call_2_Days_before_appointment_Required__c != oldAppoitment.Call_2_Days_before_appointment_Required__c
                        || newApp.Large_Print__c != oldAppoitment.Large_Print__c
                        || newApp.Braille__c != oldAppoitment.Braille__c
                        || newApp.DVD_Requested__c != oldAppoitment.DVD_Requested__c
                        || newApp.Elec_HH_Data_Opted__c != oldAppoitment.Elec_HH_Data_Opted__c
                        || newApp.Elec_Daily_Data_Opted__c != oldAppoitment.Elec_Daily_Data_Opted__c
                        || newApp.Gas_HH_Data_Opted__c != oldAppoitment.Gas_HH_Data_Opted__c
                        || newApp.Gas_Daily_Data_Opted__c != oldAppoitment.Gas_Daily_Data_Opted__c
                        //CH01
                        || newApp.Job_Code__c != oldAppoitment.Job_Code__c
                        || newApp.Appointment_reason_code__c != oldAppoitment.Appointment_reason_code__c
                        || newApp.Planned_Meter_Mode__c != oldAppoitment.Planned_Meter_Mode__c
                        //CH01
                        //CH06.Start
                        || (newApp.Replan__c!= oldAppoitment.Replan__c && newApp.Replan__c == 'Y')
                        //CH06.end
                        ){
                        
                        //webservice call - Allow only for valid job code
                            //CH02
                        if(newApp.Confirmed_Appointment_DateTime__c != null){ // CH01
                            //sendInfoToVOICE(newApp.id);
                            //Call email service
                            //CH05.Start
                            Messaging.SingleEmailMessage Email = new Messaging.SingleEmailMessage();
                            List<String> sendTo = new List<String>(); 
                            sendTo.add(system.label.VoiceEmailService_Address);
                            //CH09.start
                            List<User> userLst = [Select id from USER where name = 'Voice Email Service' limit 1];
                            if(userLst != null && userLst.size() > 0){
                                Email.setTargetObjectId(userLst[0].id); Email.setSaveAsActivity(false);}
                            else
                                Email.setToAddresses(sendTo);
                            Email.setSubject(newApp.id);
                            String body ='';
                            Email.setHtmlBody(body);
                            List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); 
                            emaillist.add(Email);
                            if(emaillist!=null && emaillist.size()>0) 
                                Messaging.sendEmail(emaillist);
                            //CH05.End 
                            //CH09.end
                        }    
                            isTrue = true;
      
                    }
                }
            } 
        }else{
            for(EON_Appointment__c newApp : lstAppointment){
                //webservice call - Allow only for valid job code
                if(newApp.Confirmed_Appointment_DateTime__c != null){ //CH02
                        sendInfoToVOICE(newApp.id);
                        
                        isTrue = true;
                }    
            }    
        } 
        
    }
    
    
    /**
        sendInfoToVOICE(String appointmentId) - this method is used to send appointment info to VOICE
    **/
    @Future(callout=true)
    public static void sendInfoToVOICE(String appointmentId){
       
        Voice_Data_Tracker__c voiceTracker = new Voice_Data_Tracker__c();
        voiceTracker.Direction__c = 'out';
        voiceTracker.Command__c = 'Create/Update Appointment';
        String requestData = '';
        String responseData = '';
        voiceTracker.EON_Appointment__c = (ID)appointmentId;
        voiceTracker.status__c = 'PASS';
        try{
            //Get the appointment record details.
            EON_Appointment__c appoitment = [select id, Name, Fuel_ID__c, Fuel_ID__r.Premise__r.Customer__r.Name, 
                                              Booking_System_Name__c,Status__c, Fuel_ID__r.Premise__r.Name,
                                              Cancel_Reason__r.Name, Appointment_Date__c, Fuel_ID__r.Premise__r.Customer__r.Customer_Name__c, 
                                              Fuel_ID__r.Premise__r.Customer__r.ID, Fuel_ID__r.Premise__r.ID, 
                                              Time_Slot__c, Start_Time__c, End_Time__c, Technician__r.Name,  Caller_Name__c, 
                                              Call_2_Days_before_appointment_Required__c, h_Appointment_Reason__c, h_Job_Code__c,
                                              Large_Print__c, Braille__c,DVD_Requested__c, Elec_HH_Data_Opted__c,
                                              Elec_Daily_Data_Opted__c, Gas_HH_Data_Opted__c, Gas_Daily_Data_Opted__c,
                                              Confirmed_Appointment_DateTime__c,
                                              Replan__c, h_Abort_Description__c,//CH06 
                                              Job_Code__r.Name, Appointment_reason_code__r.Appointment_reason_code__c, Planned_Meter_Mode__c //CH01   
                                             from EON_Appointment__c where id =: appointmentId];
            
            //Validate 
            if(appoitment.Confirmed_Appointment_DateTime__c == null){
                return; 
            }            
            
            EON_Appointment_Vulnerability__c[] lstVulnerabilities = [select id from EON_Appointment_Vulnerability__c where EON_Appointment_ID__c =:appointmentId limit 1];
            List<EON_Appointment_Comms__c> eonCommsList = [select id,EON_Appointment_ID__c,Comm_Type_Code__c,Delivery_Method_Desc__c,
                                            Delivery_Method_Desc__r.Code__c 
                                            from EON_Appointment_Comms__c 
                                            where EON_Appointment_ID__c =:appointmentId limit 3];//CH03

            //interface setup
            EON_Voice_Appointment_Management_WS.AppointmentClass app_WS = new EON_Voice_Appointment_Management_WS.AppointmentClass();
            app_WS.AppointmentCancelReason = appoitment.Cancel_Reason__r.Name;
            app_WS.AppointmentDate = (appoitment.Appointment_Date__c != null) ? appoitment.Appointment_Date__c.format() : '';
            app_WS.AppointmentEndTime = appoitment.End_Time__c;
            app_WS.AppointmentStartTime = appoitment.Start_Time__c;
            app_WS.AppointmentStatus = appoitment.Status__c;
            app_WS.AppointmentTechnicianName = appoitment.Technician__r.Name;
            app_WS.AppointmentTimeSlot = appoitment.Time_Slot__c;
            app_WS.BookingSystemName = appoitment.Booking_System_Name__c;
            app_WS.BrailPrint = ((appoitment.Braille__c) ? 'Y' : 'N');
            app_WS.Call2DaysBeforeAppointment =  ((appoitment.Call_2_Days_before_appointment_Required__c) ? 'Y' : 'N');
            app_WS.CustomerID =  appoitment.Fuel_ID__r.Premise__r.Customer__r.Name;
            app_WS.CustomerName = appoitment.Fuel_ID__r.Premise__r.Customer__r.Customer_Name__c;
            app_WS.CustomerSFID = appoitment.Fuel_ID__r.Premise__r.Customer__r.ID;
            app_WS.DVDRequired = ((appoitment.DVD_Requested__c) ? 'Y' : 'N');
            app_WS.ElecDailyDataOpted = ((appoitment.Elec_Daily_Data_Opted__c) ? 'Y' : '');
            app_WS.ElecHHDataOpted =  ((appoitment.Elec_HH_Data_Opted__c) ? 'Y' : '');
            app_WS.GasDailyDataOpted = ((appoitment.Gas_Daily_Data_Opted__c) ? 'Y' : '');
            app_WS.GasHHDataOpted = ((appoitment.Gas_HH_Data_Opted__c) ? 'Y' : '');
            app_WS.LargePrint = ((appoitment.Large_Print__c) ? 'Y' : 'N');
            app_Ws.MUSAppointmentReferenceNumber = appoitment.Name;
            app_Ws.SitePremiseID = appoitment.Fuel_ID__r.Premise__r.Name;
            app_Ws.SitePremiseSFID = appoitment.Fuel_ID__r.Premise__r.ID;        
            app_Ws.VulnerableCustomerFlag = ((!lstVulnerabilities.isEmpty()) ? 'Y' : 'N');
            //CH03.START
            if(eonCommsList != null && eonCommsList.size() > 0){
                for(EON_Appointment_Comms__c eonAppComm : eonCommsList){
                    if(eonAppComm.Comm_Type_Code__c != null && eonAppComm.Comm_Type_Code__c != '' && eonAppComm.Delivery_Method_Desc__c != null && eonAppComm.Delivery_Method_Desc__r.Code__c != null && eonAppComm.Delivery_Method_Desc__r.Code__c != ''){
                        if(eonAppComm.Comm_Type_Code__c == 'C')
                            app_Ws.Confirmation = eonAppComm.Delivery_Method_Desc__r.Code__c;
                        if(eonAppComm.Comm_Type_Code__c == 'I')
                            app_Ws.Information = eonAppComm.Delivery_Method_Desc__r.Code__c;
                        if(eonAppComm.Comm_Type_Code__c == 'R')
                            app_Ws.Reminder = eonAppComm.Delivery_Method_Desc__r.Code__c;
                    }
                }
            }
            //CH03.END
            //CH01.Start
            app_Ws.AppointmentReason = appoitment.Appointment_reason_code__r.Appointment_reason_code__c;
            app_Ws.JobCode = appoitment.Job_Code__r.Name;
            app_Ws.MeterMode = appoitment.Planned_Meter_Mode__c;
            //CH01.End
            
            //CH06.Start
            if(appoitment.Replan__c == 'Y'){
                app_Ws.Replan = 'Y';
                app_Ws.AbortDescription = appoitment.h_Abort_Description__c;
            }
            //CH06.End
    
            //get the appointment Contact details.
            EON_Appointment_Contact__c[] lstContacts = [select id, Contact_Full_Name__c, Contact_Type__r.Name, Customer_Assistant__c,
                                                        EON_Appointment_ID__r.Name, Media_Detail__c, Media_Type__r.Name  
                                                        from EON_Appointment_Contact__c 
                                                        where EON_Appointment_ID__c =: appointmentId];
            
            //Get the appointment Vulrenability records                                                                
            EON_Voice_Appointment_Management_WS.AppointmentContactRep[] lstAppContacts = 
                            new EON_Voice_Appointment_Management_WS.AppointmentContactRep[]{};
            
            for(EON_Appointment_Contact__c appContact : lstContacts){
                EON_Voice_Appointment_Management_WS.AppointmentContactRep appContactRep = new EON_Voice_Appointment_Management_WS.AppointmentContactRep();
                appContactRep.AppointmentID = appcontact.EON_Appointment_ID__r.Name;
                appContactRep.ContactFullName = appcontact.Contact_Full_Name__c;
                appContactRep.ContactType = appcontact.Contact_Type__r.Name;
                appContactRep.CustomerAssistant = (appcontact.Customer_Assistant__c ? 'Y' : 'N');
                appContactRep.MediaType = appcontact.Media_Type__r.Name;
                appContactRep.MedialDetails = appcontact.Media_Detail__c;
                lstAppContacts.add(appContactRep);
            }
            
            EON_Voice_Appointment_Management_WS.ArrayOfAppointmentContactRep AppointmentConRep = new EON_Voice_Appointment_Management_WS.ArrayOfAppointmentContactRep();
            AppointmentConRep.AppointmentContactRep = lstAppContacts;
            app_Ws.AppointmentConRep = AppointmentConRep;
            
            EON_Voice_Appointment_Management_WS.AccessToken authDetails = new EON_Voice_Appointment_Management_WS.AccessToken();
            authDetails.username = System.Label.EON_VOICE_UserName;
            authDetails.password = System.Label.EON_VOICE_Password;
            
            
            EON_Voice_Appointment_Mgmt_Helper_WS.BasicHttpsBinding_IAppointment request = new 
                                                            EON_Voice_Appointment_Mgmt_Helper_WS.BasicHttpsBinding_IAppointment();
            requestData =  authDetails + '\n' + app_Ws;                                                           
            responseData = request.UpdateAppointmentDetails(authDetails, app_Ws); 
            if(!responseData.contains('Success'))
                voiceTracker.status__c = 'FAIL';
                       
        }catch(Exception ex){
            voiceTracker.status__c = 'FAIL';
            voiceTracker.Error__c = ex + '\n' + ex.getStackTraceString();
            System.debug('******** Error Occured ' + ex.getStackTraceString());
            responseData = ex + '';            
        }
        voiceTracker.Request_Data__c = requestData;
        voiceTracker.Response_Data__c = responseData;
        //insert voiceTracker; //CH07.Old
        //CH07.New.Start
        list<Voice_Data_Tracker__c> voiceTracker1 = new list<Voice_Data_Tracker__c>();
        voiceTracker1.add(voiceTracker);
        insert voiceTracker1; 
        //CH07.New.End
    }
    
    
}