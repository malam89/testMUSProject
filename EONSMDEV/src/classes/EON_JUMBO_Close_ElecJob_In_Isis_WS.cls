/**
    Description: This class used to generate a WSDL for the close electricity job in Isis. This WSDL will be consumed by JUMBO and 
                send job information, as part of this an Appointment record will be updated to closed.
    Test Class :  EON_JUMBO_Close_ElecJob_In_Isis_WS_Test               
**/
/*
    Created By : Praveen G
    Created Date : 21-March-2016
    Service Request : SR_EON_Jumbo_015
    Change History :
    CH01 # SR_EON_Jumbo_036 # 26/06/2016 # Mehboob Alam # Added a new validation if Complete DateTime within the associated Isis Appointment is populated 
                                                          then validation msg should be return.
    CH02 # SR_EON_Jumbo_041 # 08/07/2016 # Mehboob Alam # Change the format coming as HHMMSS to HH:MM                                                     
    
*/
global with sharing class EON_JUMBO_Close_ElecJob_In_Isis_WS {

    /**
    Description : Request Parameter
    **/
    global with sharing class ElecWorkRequest{    
        Webservice String MPAN;
        Webservice String ExternalJobReference;
        Webservice String JUMBOID;
        Webservice Date VisitStartDate;
        Webservice String VisitStartTime;
        Webservice Date VisitEndDate;
        Webservice String VisitEndTime;              
    }
    
    /**
    Description : Response
    **/
    global with sharing class JumboToIsisElecWorkResponse{
        Webservice String Success;
        Webservice String Message;
        Webservice String ExternalJobReference;
    }  
    
    
    /**
    closeElectricityJobInIsis(ElecWorkRequest elecRequest) - This method is used to close an Appointment record in Isis.
    **/
    webservice static JumboToIsisElecWorkResponse closeElectricityJobInIsis(ElecWorkRequest elecRequest){ 
         JumboToIsisElecWorkResponse response = new JumboToIsisElecWorkResponse();
         JUMBO_Data_Tracker__c tracker = new JUMBO_Data_Tracker__c();
         
         
         //tracker information
         tracker.Direction__c = EON_Utility.DIRECTION_IN;
         tracker.Command__c = JUMBO_Utility.CMD_JUMBO_CloseEJ;
         tracker.Status__c = EON_Utility.RESULT_PASS;         
         String result = ''; 
         try{     
             if(!EON_Utility.validateRequired(elecRequest)){ 
             	 tracker.Request_Data__c = string.valueOf(elecRequest);
                 //Validation for mandatory fields
                 if(EON_Utility.validateRequired(elecRequest.MPAN))
                    result =result + 'Mandatory field MPAN is missing.\n';   
                 if(EON_Utility.validateRequired(elecRequest.JUMBOID))
                    result =result + 'Mandatory field JUMBOID is missing.\n';   
                 if(EON_Utility.validateRequired(elecRequest.VisitStartDate))
                    result =result + 'Mandatory field VisitStartDate is missing.\n';   
                 if(EON_Utility.validateRequired(elecRequest.VisitStartTime))
                    result =result + 'Mandatory field VisitStartTime is missing.\n'; 
                    
                  if(EON_Utility.validateRequired(result)){                                              
                    //logic to update the EON Appointment record for closing. 
                    EON_Appointment__c[] appointment = [select id,Name,Complete_DateTime__c from EON_Appointment__c where MPAN__c =: elecRequest.MPAN and JUMBO_ID__c=:elecRequest.JUMBOID];
                     if(!appointment.isEmpty()){
                     	 response.externalJobReference = appointment[0].Name; 
                     	 tracker.EON_Appointment__c = appointment[0].id;
                     	  if(EON_Utility.validateRequired(appointment[0].Complete_DateTime__c)){ //CH01    
	                         Time vStartTime = Time.newInstance(Integer.ValueOf(elecRequest.VisitStartTime.substring(0,2)), 
	                                                         Integer.ValueOf(elecRequest.VisitStartTime.substring(2,4)), 0, 0); //CH02
	                         appointment[0].Onsite_DateTime__c = DateTime.newInstance(elecRequest.VisitStartDate, vStartTime);
	                         
	                         if(!EON_Utility.validateRequired(elecRequest.VisitEndTime) && !EON_Utility.validateRequired(elecRequest.VisitEndDate)){
	                              Time vEndTime= Time.newInstance(Integer.ValueOf(elecRequest.VisitEndTime.substring(0,2)), 
	                                                         Integer.ValueOf(elecRequest.VisitEndTime.substring(2,4)), 0, 0);   //CH02                      
	                              appointment[0].Complete_DateTime__c = DateTime.newInstance(elecRequest.VisitEndDate, vEndTime);
	                         }
	                         appointment[0].Closed_in_JUMBO__c = true;
	                         update appointment;
	                         
	                         //update the response
	                         response.success = EON_Utility.RESULT_PASS; 
                     	  }
                             else 
                               result = 'The corresponding job for '+appointment[0].Name+' is already completed' ;    //CH01                              
                 }
                   else 
                      result = 'No Appointment found with the MPAN :'+ elecRequest.MPAN+' and JUMBOID :'+elecRequest.JUMBOID ;     
             }
          }
             else
                result = 'No Request found (Request is null)';
            
         }
         catch(Exception ex){
            result = 'An Unknown error has occurred while processing this request. Please contact to System Administrator';
            tracker.Status__c = EON_Utility.RESULT_FAIL;
            tracker.Response_Data__c = ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getLineNumber();
         }
         
         if(!EON_Utility.validateRequired(result)){
             response.success = EON_Utility.RESULT_FAIL;
             response.message = result;         
         } 
         
         tracker.Response_Data__c = string.valueOf(response)+'\n'+(!EON_Utility.validateRequired(Tracker.Response_Data__c)?Tracker.Response_Data__c:'');
         insert tracker;          
         return response;
     }        
    
}