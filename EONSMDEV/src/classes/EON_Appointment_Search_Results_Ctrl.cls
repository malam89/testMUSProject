/**
    Description : This class is used to get the search results for Appointment search.
       VF Page : EON_Appointment_Search_Sidebar
       Test Class : EON_Appointment_Search_Results_Ctrl_Test
**/
/*
    Created Date : Praveen G
    Created By : 11-April-2016
    Service Request : SR_Isis_EON_015
*/
public with sharing class EON_Appointment_Search_Results_Ctrl{
    public string openQuotes = '\'%';
    public string closeQuotes = '%\'';
    
    /**
        displayRecord() - This method returns if search gives only one record, so that when user searches.. 
        it will be directly redirect to record.    
    **/
    public PageReference displayRecord(){
        List<EON_Appointment__c> lstAppointment = getAppointmentResults();
        PageReference pageRef = null;
        if(lstAppointment!= null && lstAppointment.size() == 1){
            pageRef = new PageReference('/'+ lstAppointment[0].id);
            pageRef.setRedirect(true);            
        }
        
        return pageRef;
    }
        
    /**
        getAppointmentResults() - This method will return the Appointment search results.
    **/    
    public List<EON_Appointment__c> getAppointmentResults(){   
        try{
            String appointmentID = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('appointmentID').trim());
            String customerName = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('customerName').trim());
            String mpan = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('mpan').trim());
            String mprn = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('mprn').trim());                
    
            String queryString = 'select MPRN__c, MPAN__c, Customer_Name__c, Name, id, Appointment_Date__c, '; 
                   queryString += 'Status__c, Technician__r.Name'; 
                   queryString += ' from EON_Appointment__c where';
                                             
            if(appointmentID != null && appointmentID != ''){
               queryString = queryString+' and Name like '+ openQuotes + appointmentID + closeQuotes  ;
            } 
            if(customerName != null && customerName != ''){
               queryString = queryString+' and Customer_Name__c like '+ openQuotes + customerName + closeQuotes  ;
            }  
            if(mpan != null && mpan != ''){
               queryString = queryString+' and MPAN__c like '+ openQuotes + mpan + closeQuotes  ;
            }
            if(mprn != null && mprn != ''){
               queryString = queryString+' and MPRN__c like '+ openQuotes + mprn + closeQuotes  ;
            }
            
            queryString = queryString + ' order by name Limit 1000';
            queryString = queryString.replace('where order by', 'order by');
            queryString = queryString.replace('where and', 'where');    
            System.debug('******queryString ' + queryString); 
            
            return  Database.query(queryString);                     
        }catch(exception ex){
            System.debug('******Error: '+ ex.getStackTraceString());
        }        
        return null;
    } 
}