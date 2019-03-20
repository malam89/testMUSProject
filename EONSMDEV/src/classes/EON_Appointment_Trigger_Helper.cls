/**
    Description : This is the helper class for 'EON_Appointment_Trigger' Trigger 
                to update EON Appointment Status Field.

    Test Class  : EON_Appointment_Trigger_Test
**/
/* 
Created By  : Sivasankar K
Created On  : 17/02/2016
Service Req : SR_EON_AB_002

CHANGE HISTORY: 
CH01 # SR_Isis_EON_009 # 10/03/2016 # Purvi # Added a method autopopulateContract().
CH02 # SR_EON_AB_029 # 31/03/2016 # Tashika Gupta # Amended logic to update status field in EON Appointment.
CH03 # SR_EON_Mobile_009 # 11/04/2016 # Mahadev # Added a method ofscPhotoDownload: This method will call future method to download photos from OFSC.
CH04 # SR_EON_AB_063 # 19/05/2016 # Aruna Manjari # Amended logic to update status field in EON Appointment to show "AwaitingIndustryData" as opposed to "Awaiting Industry Data" when triggered as the field length is too long.
CH05 # SR_EON_Scheduling_033 # 23/May/2016 # Praveen G # Changed the logic for Aborted status.
CH06 # SR_EON_Mobile_046 # 08/06/2016 #Shruti Moghe # added method to populate Planned Number of Registers field
CH07 # SR_Isis_EON_020 # 14/06/2016 # Tahika Gupta # Removed the Deferral status and replaced reservation with draft.
CH08 # SR_EON_Jumbo_027 # 15/06/2016 # Mehboob Alam # Added a new method to close all the completed appointment in Jumbo.
CH09 # SR_EON_AB_097 # 21/07/2016 # Puneet Mehta # Updated Metering, Supply, Current and Planned Meter Registers as per the SR 
CH10 # SR_EON_JUMBO_050 # 02/08/2016 # Mahadev Joshilkar # Calling Jumbo Close job mehtod to sent Gas job Information 
CH11 # SR_EON_AB_134 # 05/09/2016 # Puneet Mehta # Changed 'Single rate' to 'Single-rate'
CH12 # SM-2320 # 27/09/2016 # Mahadev J # Correction to accept cancelled reason as 'RESCHEDULE'
CH13 # SR_EON_JUMBO_070 # 02/11/2016 # Mahadev J # Amend logic to send 'EON Appointment' with status 'ABORTED'
CH14 # SR_EON_JUMBO_075 # 02/11/2016 # Mahadev J # Amend additional logic to send 'EON Appointment' with status 'ABORTED'
CH15 # SR_EON_JUMBO_106 # 28/03/2017 # Mahadev J # Amend logic to send update to Oracle
CH16 # SR_OptiMUS_EON_052 # 04/04/2017 # Praveen G # added additional logic to calculate Planned Meter Registers
CH17 # SR_OptiMUS_EON_068 # 01/06/2017 # Praveen G # Default the value for the field Gas_bind_performed_flag__c
CH18 # SR_OptiMUS_EON_080 # 13/06/2017 # Praveen G # Default the value for the field Planned_G_Meter_Type__c
CH19 # SR_OptiMUS_EON_091 # 09/08/2017 # Praveen G # Reschedule status update
CH20 # SR_OptiMUS_EON_109 # 05/09/2017 # Praveen G # Defaulting the values.
CH21 # SR_OptiMUS_EON_138 # 27/09/2017 # Praveen G # Change the logic Defaulting the values.
CH22 # SR_OptiMUS_EON_125 # 10/10/2017 # Praveen G # Added logic for default values for MUS booking system.
CH23 # Checkmark Report   # 07/02/2014 # Abhilash  # Code improvement for Checkmark report
CH24 # SR_OptiMUS_EON_237 # 19/04/2018 # Mehboob Alam # MUS Appointment needs to be udpated from EON
CH25 # SR_OptiMUS_EON_297 # 07/02/2019 # Tabish Almas # Added method CloseJobInMDS
CH26 # SR_OptiMUS_EON_306 # 25/02/2019 # Tabish Almas # Added code to correctly populate WAN Coverage details in EON Appointment
*/

public with sharing class EON_Appointment_Trigger_Helper {
    
    /**
    updateEONAppointmentStatus(List<Appointment__c>) : This method will call from the trigger EON_UpdateAppointmentStatus, to calculate the Appointment Status.
    **/
    public static void updateEONAppointmentStatus(List<EON_Appointment__c> EONAppts) {
        
        try{
            for(EON_Appointment__c objEON:EONAppts){ 
                
                if(objEON.Booking_System_Name__c == 'ICE'){ //CH22
                    //CH20.Start default the CSP Region
                    if(objEON.subArea__c != null && objEON.CSP_Region__c == null){
                        objEON.CSP_Region__c = objEON.h_CSP_Region__c;
                    }
                    //CH20.End
                    
                    //CH21.Start
                    //Default the Comms Hub Variant
                    if(objEON.Comms_Hub_Variant__c == null){
                        objEON.Comms_Hub_Variant__c = objEON.h_Comms_Hub_Variant__c;   
                    } 
                    
                    //Default the Coverage Availability
                    if(objEON.Coverage_Availability__c == null){
                        objEON.Coverage_Availability__c = objEON.h_Coverage_Availability__c;   
                    } 
                    
                    //Default the Connectivity Likelihood
                    if(objEON.Connectivity_Likelihood__c == null){
                        objEON.Connectivity_Likelihood__c = objEON.h_Connectivity_Likelihood__c;   
                    } 
                }                                           
                //CH21.End            
                
                //CH22.Start
                if(objEON.Booking_System_Name__c == 'MUS'){
                    //Default the CSP Region
                    //if(objEON.CSP_Region__c == null)//CH24//CH26
                       objEON.CSP_Region__c = objEON.h_CSP_Region_ABP__c;                    
                    
                    //Default the Comms Hub Variant
                    //if(objEON.Comms_Hub_Variant__c == null)//CH24//CH26
                       objEON.Comms_Hub_Variant__c = objEON.h_Comms_Hub_Variant_ABP__c; 
                                                                 
                    //Default the Coverage Availability
                    //if(objEON.Coverage_Availability__c == null)//CH24//CH26
                       objEON.Coverage_Availability__c = objEON.h_Coverage_Availability_ABP__c; 
                                                             
                    //Default the Connectivity Likelihood
                   // if(objEON.Connectivity_Likelihood__c == null)//CH24//CH26
                       objEON.Connectivity_Likelihood__c = objEON.h_Connectivity_Likelihood_ABP__c; 
                                                                 
                    //Default the Auxiliary Equipment required
                    //if(objEON.Auxiliary_Equipment_required__c == null) //CH24//CH26
                       objEON.Auxiliary_Equipment_required__c = objEON.h_Auxiliary_Equipment_required_ABP__c;                                           
                    
                    //Default the WAN Additional Information
                    //if(objEON.WAN_Additional_Information__c== null)//CH24//CH26
                       objEON.WAN_Additional_Information__c = objEON.h_Additional_Information_ABP__c;                                                                                            
                }
                //CH22.End
            
                system.debug('####Appintment Trigger: '+objEON);
                //loop the appointment records
                //CH09.START
                if(objEON.H_Fuel_Type__c != '' && objEON.H_Fuel_Type__c == 'E'){
                    objEON.Metering__c = 'NHH'; objEON.Supply__c = 'LV'; objEON.Current__c = 'WC';
                }
                if(objEON.H_Fuel_Type__c != '' && objEON.H_Fuel_Type__c == 'G'){
                    objEON.Metering__c = 'NHH';
                }
                List<EON_SSC__c> eonSSCList = [SELECT ID,Name,Number_of_Registers__c,Type__c FROM EON_SSC__c WHERE Name =:objEON.Requested_SSC__c]; 
                if(eonSSCList != null && eonSSCList.size() > 0){
                    //if(eonSSCList[0].Number_of_Registers__c == 1){objEON.Planned_Meter_Registers__c = 'Single rate';}//CH11.OLD
                    if(eonSSCList[0].Number_of_Registers__c == 1){
                        objEON.Planned_Meter_Registers__c = 'Single-rate';
                    }//CH11.NEW
                    else if(eonSSCList[0].Number_of_Registers__c > 1){
                        system.debug('####PlannedMeterRegisters');
                        objEON.Planned_Meter_Registers__c = 'Multi-rate';
                    }
                }
                //CH09.END
            /*CH02.Start.Old
                if( objEON.Complete_DateTime__c != null && objEON.Abort_Reason__c == null ) { objEON.Status__c = 'COMPLETED'; }
                else if( objEON.Cancel_Reason__c != null ){ // Cancel reason is populated
                    if( objEON.h_Cancel_Reason_Key__c != null && objEON.h_Cancel_Reason_Key__c.equalsIgnoreCase('Rescheduled') ){   if ( objEON.Deferral_Notes__c != null ) { objEON.Status__c = 'DEFERRAL'; }
                        else { objEON.Status__c = 'RESCHEDULED'; } 
                    }
                    else { objEON.Status__c='CANCELLED'; }
                } 
                else if( objEON.Complete_DateTime__c != null && objEON.Abort_Reason__c != null ) { objEON.Status__c = 'ABORTED'; }
                else if( objEON.Suspended_DateTime__c != null ) { objEON.Status__c = 'SUSPENDED';  }
                else if( objEON.Onsite_DateTime__c != null ) { objEON.Status__c = 'ONSITE'; }
                else if( objEON.En_Route_DateTime__c != null ) { objEON.Status__c = 'ONWAY'; }
                else if( objEON.Technician__c != null ) { objEON.Status__c = 'ASSIGNED'; }
                else if( objEON.Confirmed_Appointment_DateTime__c != null ) { objEON.Status__c = 'SCHEDULED'; }
                else{ objEON.Status__c='RESERVATION'; }
                CH02.End.Old*/
                //CH02.New.Start
                objEON.Status__c='DRAFT';//CH07
                if(objEON.Complete_DateTime__c != null && objEON.Abort_Reason__c == null){
                    objEON.Status__c = 'COMPLETED'; continue;
                }
                // CH05.Old if(objEON.Abort_Reason__c != null){objEON.Status__c = 'ABORTED'; continue;}
                //CH05.New Start
                    if(objEON.Abort_Datetime__c != null){
                        objEON.Status__c = 'ABORTED'; continue;
                    }
                //CH05.New End
                if(objEON.Cancellation_DateTime__c != null ){
                    //CH19.OLDif( objEON.h_Cancel_Reason_Key__c != null && objEON.h_Cancel_Reason_Key__c.containsIgnoreCase('Reschedule') ){ //CH12 - Replaced - equalsIgnoreCase('Rescheduled')
                        //CH07.Start
                       // if ( objEON.Deferral_Notes__c != null ) { objEON.Status__c = 'DEFERRAL'; continue;}
                       // else { objEON.Status__c = 'RESCHEDULED'; continue;} 
                       //CH07.End
                   if(objEON.Rescheduled_Appointment__c != null){//CH19.New
                        objEON.Status__c = 'RESCHEDULED'; continue;
                    }
                     if(objEON.Rescheduled_Appointment__c ==null){
                         objEON.Status__c = 'CANCELLED';continue;
                     }
                }
                if( objEON.Suspended_DateTime__c != null ){ 
                    objEON.Status__c = 'SUSPENDED'; continue; 
                }
                if( objEON.Onsite_DateTime__c != null ){ 
                    objEON.Status__c = 'ONSITE'; continue;
                }
                if( objEON.En_Route_DateTime__c != null ){
                    objEON.Status__c = 'ONWAY'; continue;
                }
                if( objEON.Technician__c != null ){
                    system.debug( objEON.Technician__c); 
                    objEON.Status__c = 'ASSIGNED'; continue;
                }
                //CH07.Start
                if((objEON.Metering_Point_Postcode__c == null && objEON.MPAN__c != null ) || objEON.Post_Code__c == null && objEON.MPRN__c != null ){    
                    //if(objEON.MPAN__c != null || objEON.MPRN__c != null){
                    objEON.Status__c = 'AwaitingIndustryData'; continue; 
                } 
                //CH07.End
                    //CH04{objEON.Status__c = 'AWAITING INDUSTRY DATA'; continue; } 
                if(objEON.Confirmed_Appointment_DateTime__c != null){
                    objEON.Status__c = 'SCHEDULED'; continue;
                }
                //CH02.New.End
                System.debug('objEON.Status__c ='+objEON.Status__c);
            }
        } 
        Catch( Exception ex){ 
            EONAppts[0].addError(ex.getMessage()); 
        }
    }
     /**
    autopopulateContract(List<Appointment__c>) : This method will be called from the trigger EON_UpdateAppointmentStatus, to autopopulate Contract.
    **/ //CH01.Start 
    public static void autopopulateContract(List<EON_Appointment__c> EONAppts){   
        
        try{  
            //CH17.Start this should only execute for isInsert
            for ( EON_Appointment__c objEON: EONAppts ){
                if(objEon.h_Job_Code__c == 'OOAEINSTALLBIND'){
                    objEon.Gas_bind_performed_flag__c = 'Y';
                    
                    //CH18.Start
                    if(objEon.Booking_System_Name__c == 'ICE')
                        objEon.Planned_G_Meter_Type__c = 'MS1';
                    //CH18.End
                                            
                    if(objEon.Booking_System_Name__c == 'MUS'){
                        objEon.Planned_E_Meter_Type__c = 'MS1';
                        objEon.Planned_Meter_Mode__c = 'CR';
                        objEon.Planned_G_Meter_Type__c = 'MS1';
                    }
                }    
            }
            //CH17.End      
                
            List<Contract_Number__c> getEonContract = [select id, Start_Date__c,End_Date__c from Contract_Number__c 
                                                       where Contract_Client_Short_Name__c = 'EON'];
                                                       
            List<Contract_Number__c> listContract = new List<Contract_Number__c>();
            if (getEonContract.size() > 0 ){
                for ( EON_Appointment__c objEON: EONAppts ){ //loop the appointment records         
                    for ( Contract_Number__c objCon: getEonContract ){
                        if( objEON.Appointment_Date__c > objCon.Start_Date__c && objEON.Appointment_Date__c < objCon.End_Date__c )
                            listContract.add(objCon);
                    }                 
                    if( listContract.size() == 1 )
                        objEON.Contract__c = listContract[0].id ;
                }
            }
        } Catch( Exception ex ) { EONAppts[0].addError(ex.getMessage()); }
    } //CH01.Stop
    //CH03.Start
    /**
    ofscPhotoDownload(List<EON_Appointment__c>, List<EON_Appointment__c>) : This method will be called from the trigger EON_Appointment_Trigger to download photos from OFSC.
    **/
    public static void ofscPhotoDownload(List<EON_Appointment__c> oldAppointment, List<EON_Appointment__c> newAppointment)
    {
      list<Id> listAppointmentID = new list<Id>();
      map<ID, EON_Appointment__c> oldApp = new map<ID, EON_Appointment__c>();
      map<ID, EON_Appointment__c> newApp = new map<ID, EON_Appointment__c>();
      for(EON_Appointment__c appointment:oldAppointment)
      {
        oldApp.put(appointment.ID,appointment);
      }
      for(EON_Appointment__c appointment:newAppointment)
      {
        newApp.put(appointment.ID,appointment);
      }
      for(EON_Appointment__c appointment:oldAppointment)
      {
        EON_Appointment__c newAppDetails = newApp.get(appointment.ID);
        if(newAppDetails.status__c != null && newAppDetails.status__c != '')
        {
          if(appointment.status__c != newAppDetails.status__c)
          {
            if(newAppDetails.status__c.equalsIgnoreCase('Completed') || newAppDetails.status__c.equalsIgnoreCase('Aborted')){listAppointmentID.add(newAppDetails.ID);}
          }
        }
      }
      if(listAppointmentID.size()>0)EON_OFSC_Get_Photos_Handler.getPhotosFromOFSC(listAppointmentID);
    }
    //CH03.End
    //CH06.start
    /**
    CalculatePlannedNumberofRegisters(List<EON_Appointment__c> lstAppointments) : to populate "Planned Number of Registers"         
    **/
    public static void CalculatePlannedNumberofRegisters(List<EON_Appointment__c> lstAppointments)
    {
            Map<String,List<EON_SSC__c>> mapssc= new Map<String,List<EON_SSC__c>>();
            List<EON_SSC__c> lstSsc = new List<EON_SSC__c>();
            lstSsc =[SELECT name, Number_of_Registers__c    ,Type__c FROM EON_SSC__c where id != '']; //CH23.Change
            for(EON_SSC__c objSSC:lstSsc){
                if(!mapssc.containsKey(objSSC.Name))
                        mapssc.put(objSSC.Name, new List<EON_SSC__c>());
                mapssc.get(objSSC.Name).add(objSSC);
            }
            List<EON_Appointment__c> lstApptToUpdate = new List<EON_Appointment__c>();      
            for(EON_Appointment__c App : lstAppointments ){
                app.Planned_Number_of_Registers__c = EON_OFSC_Update_Appointment.getPlannedReg(app,mapssc);

                //CH16.Start
                if(string.isBlank(app.Planned_Number_of_Registers__c)){
                     
                    if(string.isBlank(App.E_Meter_Register_1_ID__c))
                        app.Planned_Meter_Registers__c = null;                    
                    else if(string.isNotBlank(App.E_Meter_Register_1_ID__c) && 
                        string.isBlank(App.E_Meter_Register_2_ID__c)) 
                        app.Planned_Meter_Registers__c = 'Single-rate';
                    else if(string.isNotBlank(App.E_Meter_Register_1_ID__c) && 
                        string.isNotBlank(App.E_Meter_Register_2_ID__c))
                        app.Planned_Meter_Registers__c = 'Multi-rate';
                 } 
                 //CH16.End   
                
            }
                                         
    }
    //CH06.End
    
    
    
    //CH08.Start
    /**
    CloseJobInJumbo(List<EON_Appointment__c>, List<EON_Appointment__c>) : This method will be called from the trigger EON_Appointment_Trigger to Close Appointment record in Jumbo.
    **/
    public static void CloseJobInJumbo(Map<id,EON_Appointment__c> mapOldAppointment, List<EON_Appointment__c> newAppointment){
      list<Id> elecJobIds = new list<Id>(); //list contain Electricity job ids
      list<Id> gasJobIds = new list<Id>(); //list contain Gas job ids
      //CH13.New.Start
      /*list<EON_Job_Results__c> allJobResults = new list<EON_Job_Results__c>(); //list all EON Job Results 
      map<ID, String> jobEMeterReading = new map<ID, String>();
      map<ID, String> jobGMeterReading = new map<ID, String>();
      allJobResults = [Select ID, Job_Reference__c, Able_to_obtain_E_Meter_reading__c, Able_to_obtain_G_Meter_reading__c from EON_Job_Results__c where Job_Reference__c =: mapOldAppointment.keySet()];
      for(EON_Job_Results__c jobRes:allJobResults){
        jobEMeterReading.put(jobRes.Job_Reference__c, jobRes.Able_to_obtain_E_Meter_reading__c);
        jobGMeterReading.put(jobRes.Job_Reference__c, jobRes.Able_to_obtain_G_Meter_reading__c);
      }*/
      //CH13.New.End
      //CH14.New.Start
      list<EON_Appointment__c> allApptReason = [Select ID, Appointment_reason_code__r.Name from EON_Appointment__c where ID =: mapOldAppointment.keySet()];
        map<ID, String> mapApptReason = new map<ID, String>();
        for(EON_Appointment__c appt:allApptReason){
            if(!EON_Utility.validateRequired(appt.Appointment_reason_code__r.Name)){
                mapApptReason.put(appt.ID, appt.Appointment_reason_code__r.Name);
            }
        }    
      //CH14.New.End
      for(EON_Appointment__c app:newAppointment){
          if(app.status__c != mapOldAppointment.get(app.id).status__c && app.status__c=='COMPLETED'){
             if(!EON_Utility.validateRequired(app.MPAN__c)) 
               elecJobIds.add(app.id);
             if(!EON_Utility.validateRequired(app.MPRN__c)) //CH10
                 gasJobIds.add(app.id);        //CH10
          }  
         //CH13.New.Start
          if(app.status__c != mapOldAppointment.get(app.id).status__c && app.status__c=='ABORTED'){
                //CH14.New.Start
                boolean sendtoJumbo = true;
                if(!EON_Utility.validateRequired(mapApptReason.get(app.id))){
                    string apptReason = mapApptReason.get(app.id);
                if(apptReason.containsIgnoreCase('New Connection'))
                    sendtoJumbo = false;
                }
                if(!EON_Utility.validateRequired(app.MPAN__c)){
                    if(sendtoJumbo)
                        EON_Jumbo_Elec_Close_Outbound_Job.closeElecJobJUMBO(app.Id, true);
                }
                if(!EON_Utility.validateRequired(app.MPRN__c)){
                    if(sendtoJumbo)
                        EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(app.Id, true);
                }
                //CH14.New.End
              /*CH14.Old.Start
              if(!EON_Utility.validateRequired(app.MPAN__c) & !jobEMeterReading.isEmpty()){
                  if(!EON_Utility.validateRequired(jobEMeterReading.get(app.id)) && jobEMeterReading.get(app.id) != null)
                      EON_Jumbo_Elec_Close_Outbound_Job.closeElecJobJUMBO(app.Id, true);
              }
              if(!EON_Utility.validateRequired(app.MPRN__c) & !jobGMeterReading.isEmpty()){
                  if(!EON_Utility.validateRequired(jobGMeterReading.containsKey(app.id)) && jobGMeterReading.get(app.id) != null )
                      EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(app.Id, true);
              }
            CH14.Old.End*/
          }
          //CH13.New.End
      }
      
      //Calling Jumbo Web Service method to close job in Jumbo
      for(id idval : elecJobIds)
          EON_Jumbo_Elec_Close_Outbound_Job.closeElecJobJUMBO(idval, false);  //CH13.Added boolean parameter
      for(id idval : gasJobIds)    //CH10
          EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(idval, false); //CH10  //CH13.Added boolean parameter
    }
    //CH08.End
    
    //CH25.Start
    /**
    CloseJobInMDS(List<EON_Appointment__c>, List<EON_Appointment__c>) : This method will be called from the trigger EON_Appointment_Trigger to Close Appointment record in MDS.
    **/
    public static void CloseJobInMDS(Map<id,EON_Appointment__c> mapOldAppointment, List<EON_Appointment__c> newAppointment){
      list<Id> elecJobIds = new list<Id>(); //list contain Electricity job ids
      list<Id> gasJobIds = new list<Id>(); //list contain Gas job ids
      list<EON_Appointment__c> allApptReason = [Select ID, Appointment_reason_code__r.Name from EON_Appointment__c where ID =: mapOldAppointment.keySet()];
        map<ID, String> mapApptReason = new map<ID, String>();
        for(EON_Appointment__c appt:allApptReason){
            if(!EON_Utility.validateRequired(appt.Appointment_reason_code__r.Name)){
                mapApptReason.put(appt.ID, appt.Appointment_reason_code__r.Name);
            }
        }
      for(EON_Appointment__c app:newAppointment){
          if(app.status__c != mapOldAppointment.get(app.id).status__c && app.status__c=='COMPLETED'){
             if(!EON_Utility.validateRequired(app.MPAN__c)) 
               elecJobIds.add(app.id);
             if(!EON_Utility.validateRequired(app.MPRN__c))
                 gasJobIds.add(app.id);
          }
          if(app.status__c != mapOldAppointment.get(app.id).status__c && app.status__c=='ABORTED'){
                boolean sendtoJumbo = true;
                if(!EON_Utility.validateRequired(mapApptReason.get(app.id))){
                    string apptReason = mapApptReason.get(app.id);
                if(apptReason.containsIgnoreCase('New Connection'))
                    sendtoJumbo = false;
                }
                if(!EON_Utility.validateRequired(app.MPAN__c)){
                    if(sendtoJumbo)
                        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(app.Id, true);
                }
                if(!EON_Utility.validateRequired(app.MPRN__c)){
                    if(sendtoJumbo)
                        EON_MDS_Gas_Close_Outbound_Job.closeGasJobMDS(app.Id, true);
                }
          }
      }
      
      //Calling MDS Web Service method to close job in MDS
      for(id idval : elecJobIds)
          EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(idval, false); 
      for(id idval : gasJobIds)
          EON_MDS_Gas_Close_Outbound_Job.closeGasJobMDS(idval, false);
    }
    //CH25.End
    
    ////CH15.New.Start
    public static void UpdateAppointment(List<EON_Appointment__c> newAppointment){
        list<EON_Appointment_Meter__c> allApptMeter = new list<EON_Appointment_Meter__c>();
        list<ID> allMeters = new list<ID>();
        for(EON_Appointment__c appt: newAppointment){
        
            if(!EON_Utility.validateRequired(appt.E_Meter_Serial_Link__c))
                allMeters.add(appt.E_Meter_Serial_Link__c);
        }
        if(allMeters.size()>0){
            allApptMeter = [Select ID, Name, E_Meter_Make__c, E_Meter_Model__c, E_Meter_Type__r.ID, EON_Appointment__r.ID, E_Meter_Register_1_ID__c, E_Meter_Register_2_ID__c, 
                            E_Meter_Register_3_ID__c, E_Meter_Register_4_ID__c, E_Meter_Register_5_ID__c, E_Meter_Register_6_ID__c, Register_1_TPR_1__c, 
                           Register_1_TPR_2__c, Register_2_TPR_1__c, Register_2_TPR_2__c, Register_3_TPR_1__c, Register_3_TPR_2__c, Register_4_TPR_1__c,
                           Register_4_TPR_2__c, Register_5_TPR_1__c, Register_5_TPR_2__c, Register_6_TPR_1__c, Register_6_TPR_2__c from EON_Appointment_Meter__c where
                           ID =: allMeters];
            if(allApptMeter.size() > 0){
                for(EON_Appointment__c appt: newAppointment){
                    for(EON_Appointment_Meter__c eMeter: allApptMeter){
                        if(appt.ID == eMeter.EON_Appointment__r.ID){
                            appt.E_Meter_Serial_Number__c = eMeter.Name;
                          appt.E_Meter_Make__c = eMeter.E_Meter_Make__c;
                            appt.E_Meter_Make_Model__c = eMeter.E_Meter_Model__c;
                            appt.E_Meter_Type__c = eMeter.E_Meter_Type__r.ID;
                            appt.E_Meter_Register_1_ID__c = eMeter.E_Meter_Register_1_ID__c;
                            appt.E_Meter_Register_2_ID__c = eMeter.E_Meter_Register_2_ID__c;
                            appt.E_Meter_Register_3_ID__c = eMeter.E_Meter_Register_3_ID__c;
                            appt.E_Meter_Register_4_ID__c = eMeter.E_Meter_Register_4_ID__c;
                            appt.E_Meter_Register_5_ID__c = eMeter.E_Meter_Register_5_ID__c;
                            appt.E_Meter_Register_6_ID__c = eMeter.E_Meter_Register_6_ID__c;
                            appt.Register_1_TPR_1__c = eMeter.Register_1_TPR_1__c;
                            appt.Register_1_TPR_2__c = eMeter.Register_1_TPR_2__c;
                            appt.Register_2_TPR_1__c = eMeter.Register_2_TPR_1__c;
                            appt.Register_2_TPR_2__c = eMeter.Register_2_TPR_2__c;
                            appt.Register_3_TPR_1__c = eMeter.Register_3_TPR_1__c;
                            appt.Register_3_TPR_2__c = eMeter.Register_3_TPR_2__c;
                            appt.Register_4_TPR_1__c = eMeter.Register_4_TPR_1__c;
                            appt.Register_4_TPR_2__c = eMeter.Register_4_TPR_2__c;
                            appt.Register_5_TPR_1__c = eMeter.Register_5_TPR_1__c;
                            appt.Register_5_TPR_2__c = eMeter.Register_5_TPR_2__c;
                            appt.Register_6_TPR_1__c = eMeter.Register_6_TPR_1__c;
                            appt.Register_6_TPR_2__c = eMeter.Register_6_TPR_2__c;
                        }
                    }
                }
            }
        }
    }
    /**
    UpdateJobInOracle(): Update at Oracle
  **/
    public static void UpdateJobInOracle(List<EON_Appointment__c> newAppointment, MAP<id, EON_Appointment__c> oldMapIDAppointment){
        list<ID> apptID = new list<ID>();
        for(EON_Appointment__c newApp : newAppointment){
          EON_Appointment__c oldAppoitment = oldMapIDAppointment.get(newApp.id);
            if(newApp.E_Meter_Serial_Link__c != oldAppoitment.E_Meter_Serial_Link__c )
                apptID.add(newApp.ID);
         }
        //if(!apptID.isEmpty())
           // EON_Utility.updateOFSCAppointment(apptID); 
    }
    //CH15.New.End
}