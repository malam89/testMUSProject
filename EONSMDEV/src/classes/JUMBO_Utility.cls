/**
    Description : This class is used for utility methods for JUMBO Interfaces.
                  
    VF Page     : None
    Test Class  : JUMBO_Utility_Test

**/
/*
    Created By  : Mehboob Alam
    Created On  : 23/05/2016
    Service Req: SR_EON_Jumbo_006
    Change History
    CH01 #SR_EON_PC_067 #Nitin #03/08/2016 # Added static variables for Outbound callouts from Salesforce to Jumbo.
	CH02 # SR_EON_Jumbo_088 # Mahadev J # 07/12/2016 # Added methods
*/


global with sharing class JUMBO_Utility {
    
    //Static varaiable for Outbound callout from Salesforce to JUMBO
    public final static String CMD_Insert_ElecJUMBO = 'CreateElecJobInJUMBO'; 
    public final static String CMD_Update_ElecJUMBO = 'UpdateElecJobInJUMBO'; 
    public final static String CMD_Cancel_ElecJUMBO = 'CancelElecJobInJUMBO'; 
    public final static String CMD_Close_ElecJUMBO = 'CloseElecJobInJUMBO'; 
    public final static String CMD_Insert_GasJUMBO = 'CreateGasJobInJUMBO'; 
    public final static String CMD_Update_GasJUMBO = 'UpdateGasJobInJUMBO'; 
    public final static String CMD_Cancel_GasJUMBO = 'CancelGasJobInJUMBO';
    public final static String CMD_Close_GasJUMBO = 'CloseGasJobInJUMBO';  
    
    //Static varaiable for Inbound calls to Salesforce from JUMBO
    public final static String CMD_JUMBO_CEJ = 'Create Electricity Job';
    public final static String CMD_JUMBO_CancelEJ = 'Cancel Electricity Job';
    public final static String CMD_JUMBO_CloseEJ = 'Close Electricity Job';
    public final static String CMD_JUMBO_CGJ = 'Create Gas Job';
    public final static String CMD_JUMBO_CancelGJ = 'Cancel Gas Job';
    public final static String CMD_JUMBO_CloseGJ = 'Close Gas Job'; 
    public final static String CMD_JUMBO_GASUPDATE = 'Update Gas Job';
    public final static String CMD_Async_Close_ElecJUMBO = 'BusinessResponseCloseElecJob'; 
    public final static String CMD_Async_Close_GasJUMBO = 'BusinessResponseCloseGasJob';     
    
    public final static String CMD_JUMBO_ValidateMPAN = 'Validate MPAN';
    public final static String CMD_JUMBO_ValidateMPRN = 'Validate MPRN';
    public final static String CMD_JUMBO_ReqElecMPAN = 'ReqElecMeterPointData';
    public final static String CMD_JUMBO_ReqGasMPRN = 'ReqGasMeterPointData';
    
    public final static String CMD_JUMBO_CampaignMPRN = 'Validate MPRN - Campaign'; //CH01
    public final static String CMD_JUMBO_CampaignMPAN = 'Validate MPAN - Campaign'; //CH01
    
    //Static varaiable for Booking System name
    public final static String BookingSystemName = 'JUMBO';
    

    
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
         if(dt.length()==8){
            date dte = date.newInstance(Integer.ValueOf(dt.substring(0,4)),Integer.ValueOf(dt.substring(4,6)),Integer.ValueOf(dt.substring(6,8)));
            return dte;
          }
          else 
           return null;
        }
      return null;
    }

    /*
		closeElecJobAtJumbo - This webservice method will call J.12 i.e. Close Elec Job at Jumbo //Ch02.New
	*/
    webservice static void closeElecJobAtJumbo(ID apptID){
        EON_Jumbo_Elec_Close_Outbound_Job.closeElecJobJUMBO(apptID, false);
    }
    
    /*
		closeElecJobAtJumbo - This webservice method will call J.16 i.e. Close Gas Job at Jumbo //Ch02.New
	*/
    webservice static void closeGasJobAtJumbo(ID apptID){
        EON_Jumbo_Gas_Close_Outbound_Job.closeGasJobJUMBO(apptID, false);
    }
}