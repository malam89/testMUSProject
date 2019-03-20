/**
    Description : This class is used to get the search results for Complain2 search.
       VF Page : EON_Complaint_CustomerInfo_Sidebar
       Test Class :EON_Complaint_Search_Result_Ctrl_Test
**/
/*
    Created Date : Aruna Manajri
    Created By : 11-April-2016
    Service Request : SR_EON_PC_028
    
    CH01 # SR_EON_PC_077# 30/06/2016 #Krishna Yalavarthi# Hide from the 'Premise'label as per sr logic 
    CH02 # SR_OptiMUS_EON_057 # 02/05/2017 # Removed the custmer look up references 
*/
public with sharing class EON_Complaint_Search_Result_Ctrl{
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
            String customerName = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('customerName').trim());
            String mpan = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('mpan').trim());
            //String mprn = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('mprn').trim()); 
            
            String Technician = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('Technician').trim());
            String Appointment = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('Appointment').trim());
            String CustomerServiceAdvisorName = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('CustomerServiceAdvisorName').trim());
            
            String queryString = 'SELECT Name,Customer_Name__c,Premise__r.name,';
                   queryString += 'Technician__r.name, Appointment__r.name ,Customer_Service_Advisor_Name__c,';
                   queryString += 'Complaint_description__c, Complaint_status__c ,Status_update_time__c,Complainant_Name__c';
            
            
                   queryString +='  FROM EON_Complaint__c where';               
                   
                                             
            if(appointmentID != null && appointmentID != ''){
               queryString = queryString+' and Name like '+ openQuotes + appointmentID + closeQuotes  ;
            } 
            /*//CH02
            if(customerName != null && customerName != ''){
               queryString = queryString+' and Customer_Name__r.name like '+ openQuotes + customerName + closeQuotes  ;
            }  
            */
            if(mpan != null && mpan != ''){
               queryString = queryString+' and Customer_Name__c like '+ openQuotes + mpan + closeQuotes  ;
            }
            /*if(mprn != null && mprn != ''){
               queryString = queryString+' and Premise__r.name  like '+ openQuotes + mprn + closeQuotes  ;
            }*/
            
            if(Technician != null && Technician != ''){
               queryString = queryString+' and Technician__r.name like '+ openQuotes + Technician + closeQuotes  ;
            }  
            if(Appointment != null && Appointment != ''){
               queryString = queryString+' and Appointment__r.name like '+ openQuotes + Appointment + closeQuotes  ;
            }
            if(CustomerServiceAdvisorName != null && CustomerServiceAdvisorName != ''){
               queryString = queryString+' and Customer_Service_Advisor_Name__c  like '+ openQuotes + CustomerServiceAdvisorName + closeQuotes  ;
            }
            
            queryString = queryString + ' order by name Limit 10';
            queryString = queryString.replace('where order by', 'order by');
            queryString = queryString.replace('where and', 'where');    
            System.debug('******queryString ' + queryString); 
            System.debug('******appointmentID ' +appointmentID); 
            System.debug('******customerName' +customerName); 
            System.debug('******mpan' +mpan); 
            //System.debug('******mprn' +mprn);
            System.debug('******Appointment' +Appointment);
            
             
            return  Database.query(queryString);                     
        }catch(exception ex){
            System.debug('******Error: '+ ex.getStackTraceString());
        }        
        return null;
    } 
}