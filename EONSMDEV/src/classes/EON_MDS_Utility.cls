/**
    Description : This class is used for utility methods for MDS Interfaces.
                  
    VF Page     : None
    Test Class  : EON_MDS_Utility_Test

**/
/*
    Created By  : Tabish Almas
    Created On  : 29/01/2019
    Service Req: SR_OptiMUS_EON_297
    Change History
  CH01 #SR_EON_303 # Tabish Almas # 14/02/2019 # Added condition to bypass MDS Go - Live Button and required for testing purposes.
        
*/

global with sharing class EON_MDS_Utility {
    //Static varaiable for Outbound callout from Salesforce to MDS
    public final static String CMD_Insert_ElecMDS = 'CreateElecJobInMDS'; 
    public final static String CMD_Update_ElecMDS = 'UpdateElecJobInMDS'; 
    public final static String CMD_Cancel_ElecMDS = 'CancelElecJobInMDS'; 
    public final static String CMD_Close_ElecMDS = 'CloseElecJobInMDS'; 
    public final static String CMD_Insert_GasMDS = 'CreateGasJobInMDS'; 
    public final static String CMD_Update_GasMDS = 'UpdateGasJobInMDS'; 
    public final static String CMD_Cancel_GasMDS = 'CancelGasJobInMDS';
    public final static String CMD_Close_GasMDS = 'CloseGasJobInMDS';  
    
    //Static varaiable for Inbound calls to Salesforce from MDS
    public final static String CMD_MDS_CEJ = 'Create Electricity Job';
    public final static String CMD_MDS_CancelEJ = 'Cancel Electricity Job';
    public final static String CMD_MDS_CloseEJ = 'Close Electricity Job';
    public final static String CMD_MDS_CGJ = 'Create Gas Job';
    public final static String CMD_MDS_CancelGJ = 'Cancel Gas Job';
    public final static String CMD_MDS_CloseGJ = 'Close Gas Job'; 
    public final static String CMD_MDS_GASUPDATE = 'Update Gas Job';
    public final static String CMD_Async_Close_ElecMDS = 'BusinessResponseCloseElecJob'; 
    public final static String CMD_Async_Close_GasMDS = 'BusinessResponseCloseGasJob';     
    
    public final static String CMD_MDS_ValidateMPAN = 'Validate MPAN';
    public final static String CMD_MDS_ValidateMPRN = 'Validate MPRN';
    public final static String CMD_MDS_ReqElecMPAN = 'ReqElecMeterPointData';
    public final static String CMD_MDS_ReqGasMPRN = 'ReqGasMeterPointData';
    
    public final static String CMD_MDS_CampaignMPRN = 'Validate MPRN - Campaign'; 
    public final static String CMD_MDS_CampaignMPAN = 'Validate MPAN - Campaign'; 
    
    //Static varaiable for Booking System name
    public final static String BookingSystemName = 'MDS';
    
    /**
     DateToString(Date dt) - This method is used to convert date format into YYYYMMDD.
    **/
    public static string DateToString(Date dt) {
        if(!EON_Utility.validateRequired(dt))
            return String.valueof(dt).deleteWhitespace().replace('-','');
        else 
            return null;
    }    
    
    /**
     TimeToString(string tm) - This method is used to convert 5 digit time value passing as HH:MM to a string format as HHMMSS.
    **/
    public static string TimeToString(string tm) {
        if(!EON_Utility.validateRequired(tm))
            return tm.replace(':','')+'00';
        else 
            return null;
    }    
    
    /**
    String(string tme) - This method is used to convert 6 digit string value passing as HHMMSS to a string format as HH:MM
    **/
    public static string StringToTime(string tme) {
      if(!EON_Utility.validateRequired(tme)){
         if(tme.length()==6)
            return tme.substring(0,2) +':'+tme.substring(2,4);
         else 
            return null;
      }
      else 
        return null;
    }

    /**
     strigToDate(string myDate) - this method is used to convert YYYYMMDD string to date value .
    **/
    public static Date strigToDate(string dt) {
        if(!EON_Utility.validateRequired(dt)){
            if(dt.length()==19){
                date dte = date.newInstance(Integer.ValueOf(dt.substring(0,4)),Integer.ValueOf(dt.substring(5,7)),Integer.ValueOf(dt.substring(8,10)));
                return dte;
            }
            else 
                return null;
        }
        return null;
    }

    /*
    closeElecJobAtMDS - This webservice method will call J.12 i.e. Close Elec Job at Jumbo 
  */
    webservice static void closeElecJobAtMDS(ID apptID){
        EON_MDS_Elec_Close_Outbound_Job.closeElecJobMDS(apptID, false);
    }
    
    /*
    closeGasJobAtMDS- This webservice method will call J.16 i.e. Close Gas Job at Jumbo 
  */
    webservice static void closeGasJobAtMDS(ID apptID){
        EON_MDS_Gas_Close_Outbound_Job.closeGasJobMDS(apptID, false);
    }
    
    /**
     getMDS_Jumbo_Status() - this method is used to get Go Live status from MDS Jumbo Dataflow Switch object.
    **/
    webservice static String getMDS_Jumbo_Status() {
        String switchData='';
        MDS_Jumbo_Dataflow_Switch__c MDSJumboSwitch = [select Id,Name,Onyx_Status__c,MDS_Status__c,MDS_Close_Command_Only__c,Validate_Request_from_MDS__c from MDS_Jumbo_Dataflow_Switch__c ORDER BY CreatedDate ASC LIMIT 1];  //CH01
        //CH01.Start
        if(MDSJumboSwitch.Onyx_Status__c == true && MDSJumboSwitch.MDS_Status__c == false && MDSJumboSwitch.MDS_Close_Command_Only__c  == true) {
            switchData = system.label.Jumbo_Shortform;
        }
        else if(MDSJumboSwitch.Onyx_Status__c == false && MDSJumboSwitch.MDS_Status__c == true && MDSJumboSwitch.MDS_Close_Command_Only__c  == false) {
            switchData = system.label.MDS_Shortform;
        }
        /*if(MDSJumboSwitch.Validate_Request_from_MDS__c == false) {
            switchData = system.label.Jumbo_Shortform;
        }
        else if(MDSJumboSwitch.Validate_Request_from_MDS__c == true) {
            switchData = system.label.MDS_Shortform;
        }*/
        //CH01.End
        return switchData;
    }
}