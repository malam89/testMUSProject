/**
    Description : 	This class is used to print help text based on MDS/Jumbo Switch Value.
    
    VF Page     : None
    Test Class  : EON_Appointment_Asynchronous_Test

**/
/*
    Created By  : Tabish Almas
    Created On  : 08/02/2019
    Service Req : SR_OptiMUS_EON_297
    Change History

*/  
public with sharing class EON_Appointment_Asynchronous_Helper {
    public String selectedValue {get;set;}
    public EON_Appointment_Asynchronous_Helper(ApexPages.StandardController controller) {
        String switchData = EON_MDS_Utility.getMDS_Jumbo_Status();
        if(switchData == system.label.Jumbo_Shortform) {
            selectedValue = 'Warning - Sending message to Onyx system is active now';
        }
        else if(switchData == system.label.MDS_Shortform) {
            selectedValue = 'Warning - Sending message to Onyx system is deactive now';
        }
        
    }
}