/** 
Description: This trigger is for updating the Appointment Status field on EON Appointment object .

Helper Class  : EON_Appointment_Trigger_Helper
Test Class    : EON_Appointment_Trigger_Test
**/
/* 
Created By    : Sivasankar K
Created On    : 17/02/2016
Service Req   : SR_EON_AB_002

CHANGE HISTORY:
 CH01 #SR_Isis_EON_009 #09/03/2016 # Purvi# calling a method autopopulateContract().
 CH02 # SR_EON_Mobile_009 # 11/04/2016 # Mahadev #  Call to method ofscPhotoDownload, so that photos get downloaded from OFSC.
 CH03 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # called a method to calculate a field value
 CH04 # SR_EON_Jumbo_027 # 15/06/2016 # Mehboob Alam # Called a method to close all the completed appointment in Jumbo.
 CH05 # SR_EON_AB_073 # 19/07-2016 # Praveen G # added new block for sending appointment information to VOICE.
 CH06 # SR_EON_Jumbo_106 # 28/03/2017 # Mahadev J # Amended logic to send update to Oracle
 CH07 # SR_OptiMUS_EON_081 # 30/06/2017 # Praveen G # New interface call to OFSC when PAYG flag is true
 CH08 # SR_OptiMUS_EON_110 # 07/09/2017 # Praveen G # New interface call to OFSC when E Meter Serial Number is populated
 CH09 # SR_OptiMUS_EON_297 # 07/02/2019 # Tabish Almas # Added condition to call Jumbo and/or MDS based on MDS Go Live Status
*/


trigger EON_Appointment_Trigger on EON_Appointment__c (before insert, before update, after update, after insert) { // CH05 added after insert.
    //to by pass the trigger when mass transfering the records.
    if (System.Label.EON_Bypass_Mass_Transfer_Records == 'FALSE'){
        if (Trigger.isBefore) {
            system.debug('###Trigger.New: '+trigger.new+' Type: '+Trigger.isInsert+' Type1: '+Trigger.isUpdate);
            //calling the method for calcualting the Appointment Status.
            EON_Appointment_Trigger_Helper.updateEONAppointmentStatus(trigger.new);
            //CH03.start
            EON_Appointment_Trigger_Helper.CalculatePlannedNumberofRegisters(trigger.new);
            //CH03.end
        } 
        //CH01 START
        if(Trigger.isBefore && Trigger.isInsert){
            //calling the method for autopopulating contract number.
            EON_Appointment_Trigger_Helper.autopopulateContract(trigger.new);
        } //CH01 END
        //CH02.Start
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            //Calling the method to download photos from OFSC
            EON_Appointment_Trigger_Helper.ofscPhotoDownload(trigger.old,trigger.new);
            
            //Calling method to close job in Jumbo once appointment status has been updated to
            //CH09.Start
            String switchData = EON_MDS_Utility.getMDS_Jumbo_Status();
            if(switchData == system.label.Jumbo_Shortform) {
                EON_Appointment_Trigger_Helper.CloseJobInJumbo(trigger.oldMap,trigger.new); //CH04
                //EON_Appointment_Trigger_Helper.CloseJobInMDS(trigger.oldMap,trigger.new); //Call CloseJobInMDS only when CloseJobInJumbo is SUCCESS.
            }
            else if(switchData == system.label.MDS_Shortform) {
                EON_Appointment_Trigger_Helper.CloseJobInMDS(trigger.oldMap,trigger.new);
            }
            //Ch09.End
        }
        //CH02.End
       
        //CH05.Startt
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
            EON_Appointment_Trigger_VOICE_Helper.sendAppointmentInfoToVoice(Trigger.New, Trigger.oldMap, 
                        (Trigger.isInsert ?  true : false));
        }
        //CH05.Start
         //CH06.Start
        if(Trigger.isBefore && trigger.isUpdate){
            EON_Appointment_Trigger_Helper.UpdateAppointment(trigger.new);
        }
        if(Trigger.isAfter && trigger.isUpdate){
            EON_Appointment_Trigger_Helper.UpdateJobInOracle(Trigger.New, Trigger.oldMap);
        }
        //CH06.End
        
        //CH07.Start
        if(Trigger.isBefore && trigger.isUpdate){
            for(EON_Appointment__c appointment : trigger.New){
            //Allow only if PAYG sent flag is true and it is changed from false.
                if(appointment.PAYG_Details_Sent__c != Trigger.oldMap.get(appointment.id).PAYG_Details_Sent__c &&
                                                        appointment.PAYG_Details_Sent__c)            
                    EON_Send_PAYG_Sent_OFSC_Handler.sendPAYGFlatToOFSC(appointment.id);
                
                //CH08.Start    
                if(appointment.E_Meter_Serial_Number__c != Trigger.oldMap.get(appointment.id).E_Meter_Serial_Number__c 
                        && appointment.E_Meter_Serial_Number__c != null && appointment.E_Meter_Serial_Number__c != '')            
                    EON_Send_MTRSNO_OFSC_Handler.sendEmeterSerialNumToOFSC(appointment.id); 
                //CH08.End                       
            }
        }        
        //CH07.end
    }
}