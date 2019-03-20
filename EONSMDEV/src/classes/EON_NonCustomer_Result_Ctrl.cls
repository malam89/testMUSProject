/**
    Description : This class is used to get the search results for Complaint search.
       VF Page : EON_NonCustomer_Complaint_Search_Result    
       Test Class : 
**/
/*
    Created Date : Aruna Manajri
    Created By : 11-April-2016
    Service Request : SR_EON_PC_028
*/
public with sharing class EON_NonCustomer_Result_Ctrl{
    public string openQuotes = '\'%';
    public string closeQuotes = '%\'';
    
    /**
        displayRecord() - This method returns if search gives only one record, so that when user searches.. 
        it will be directly redirect to record.    
    **/
    public PageReference displayRecord(){
        List<EON_Complaint__c> lstAppointment = getAppointmentResults();
        PageReference pageRef = null;
      return pageRef;
    }
        
    /**
        getAppointmentResults() - This method will return the Complaint search results.
    **/    
    public List<EON_Complaint__c> getAppointmentResults(){   
        try{
            String appointmentID = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('appointmentID').trim());
            String Complaintaddress = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('Complaintaddress').trim());
          
            
            String queryString = 'SELECT Name,Customer__r.name,Customer__r.Customer_Name__c,Premise__r.name,';
                   queryString += 'Technician__r.name, Appointment__r.name ,Customer_Service_Advisor_Name__c,';
                   queryString += 'Complaint_description__c, Complaint_status__c ,Status_update_time__c,Complainant_Address__c,Complainant_Name__c';
            
            
                   queryString +='  FROM EON_Complaint__c where';               
                   
                                             
            if(appointmentID != null && appointmentID != ''){
               queryString = queryString+' and Complainant_Name__c like '+ openQuotes + appointmentID + closeQuotes  ;
            } 
            if(Complaintaddress != null && Complaintaddress != ''){
               queryString = queryString+' and Complainant_Address__c like '+ openQuotes + Complaintaddress + closeQuotes  ;
            }  
           
            
            queryString = queryString + ' order by name Limit 10';
            queryString = queryString.replace('where order by', 'order by');
            queryString = queryString.replace('where and', 'where');    
            System.debug('******queryString ' + queryString); 
            System.debug('******appointmentID ' +appointmentID); 
            System.debug('******customerName' +Complaintaddress); 
          
            
             
            return  Database.query(queryString);                     
        }catch(exception ex){
            System.debug('******Error: '+ ex.getStackTraceString());
        }        
        return null;
    } 
}