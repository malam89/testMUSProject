/**
    Description : This class is used to get the search results for Portfolio search.
       VF Page : EON_Portfolio_Search_Sidebar
       Test Class : EON_Portfolio_Search_Results_Ctrl_Test
**/
/*
    Created Date : Praveen G
    Created By : 09-April-2016
    Service Request : SR_Isis_EON_015
    Change History:
CH01 # SR_EON_PC_047 # 18/05/2016 # Krishna Y # EON Customer on Fuel has been changed to be accessed from EON Site as the Customer lookup is deleted from EON Fuel.    
*/

public with sharing class EON_Portfolio_Search_Results_Ctrl{
      
    public string openQuotes = '\'%';
    public string closeQuotes = '%\'';
    
    String customerID = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('customerID').trim());
    String customerName = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('customerName').trim());
    String street = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('street').trim());
    String town = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('town').trim()); 
    String postcode = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('postcode').trim());
    String elecAcct = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('elecAcct').trim());
    String elecSN = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('elecSN').trim());
    String mpan = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('mpan').trim());
    String gasAcct = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('gasAcct').trim());
    String gasSN = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('gasSN').trim());
    String mprn = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('mprn').trim());
 
    /**
        displayRecord() - This method returns if search gives only one record, so that when user searches.. it will be
            directly redirect to record.    
    **/
    public PageReference displayRecord(){
        List<PortfolioSearchResults_Wrapper> lstProfileResult = getPortfolioResults();
        PageReference pageRef = null;
        if(lstProfileResult!= null && lstProfileResult.size() == 1){
            pageRef = new PageReference('/'+ lstProfileResult[0].customerRecordID);
            pageRef.setRedirect(true);            
        }
        
        return pageRef;
    }
    
    /**
        getPortfolioResults() - This method will return the portfolio search results.
    **/
    public List<PortfolioSearchResults_Wrapper> getPortfolioResults(){
        try{            
            if((mprn!= null && mprn!= '') || (gasSN!= null && gasSN!= '') || (gasAcct!= null && gasAcct!= '') ||
                (mpan!= null && mpan!= '') || (elecSN!= null && elecSN!= '') || (elecAcct!= null && elecAcct!= '')){
                return getFuelRecords();
            }else if((postcode!= null && postcode!= '') || (town!= null && town!= '') || (street!= null && street!= '')){
                return getPremiseRecords();
            }else if((customerName!= null && customerName!= '') || (customerID!= null && customerID!= '')){
                return getCustomerRecords();
            }else{
                return getFuelRecords();
            }              
        }catch(Exception ex){
            System.debug('******Error: '+ ex.getStackTraceString());
        }
        return null;
    }    
    
    /**
        getFuelRecords() - This method returns the Fuel records when user enters fuel,  customer and site fields
                               in search.   
    **/    
    public List<PortfolioSearchResults_Wrapper> getFuelRecords(){
        try{                   
            String queryString = 'select MPRN__c, MPAN__c, ';
                   queryString += 'Premise__r.Address_Type__c, Premise__r.Building_Name__c ,Premise__r.Building_Number__c,';
                   queryString += 'Premise__r.Postcode__c,Premise__r.Town__c, Premise__r.Thorofare__c, ';
                   queryString += 'Premise__r.Customer__r.Customer_Name__c, Premise__r.Customer__r.Name, Premise__r.Customer__r.id, ';
                   queryString += 'Premise__r.Customer__r.Customer_group_type__c, Premise__r.Customer__r.Campaign_Flag__c';
                   queryString += ' from EON_Fuel__c where';
                   
            if(customerID!= null && customerID!= ''){
               queryString = queryString+' and Premise__r.Customer__r.Name like '+ openQuotes + customerID + closeQuotes  ;  //CH01
            } 
            if(customerName!= null && customerName!= ''){
               queryString = queryString+' and Premise__r.Customer__r.Customer_Name__c like '+ openQuotes + customerName + closeQuotes  ; //CH01
            } 
            if(street!= null && street!= ''){
               queryString = queryString+' and Premise__r.Thorofare__c like '+ openQuotes + street + closeQuotes  ;
            }
            if(town!= null && town!= ''){
               queryString = queryString+' and Premise__r.Town__c like '+ openQuotes + town + closeQuotes  ;
            }           
            if(postcode!= null && postcode!= ''){
               queryString = queryString+' and Premise__r.PostCode__c like '+ openQuotes + postcode + closeQuotes  ;
            }            
            if(elecAcct!= null && elecAcct!= ''){
               queryString = queryString+' and Customer_electric_account_reference__c like '+ openQuotes + elecAcct + closeQuotes  ;
            } 
            if(elecSN!= null && elecSN!= ''){
               queryString = queryString+' and Electric_meter_serial_number__c like '+ openQuotes + elecSN + closeQuotes  ;
            } 
            if(mpan!= null && mpan!= ''){
               queryString = queryString+' and MPAN__c like '+ openQuotes + mpan + closeQuotes  ;
            }
            if(gasAcct!= null && gasAcct!= ''){
               queryString = queryString+' and Customer_Gas_Account_Reference__c like '+ openQuotes + gasAcct + closeQuotes  ;
            }
            if(gasSN!= null && gasSN!= ''){
               queryString = queryString+' and Gas_meter_serial_number__c like '+ openQuotes + gasSN + closeQuotes  ;
            }
            if(mprn!= null && mprn!= ''){
               queryString = queryString+' and MPRN__c like '+ openQuotes + mprn + closeQuotes;
            }
                                                                                                                    
            queryString = queryString + ' order by name Limit 2000';
            queryString = queryString.replace('where order by', 'order by');
            queryString = queryString.replace('where and', 'where');    
            System.debug('******queryString ' + queryString); 
            
            List<PortfolioSearchResults_Wrapper> lstWrapper = new List<PortfolioSearchResults_Wrapper>();
            for(EON_fuel__c fuel: Database.query(queryString)){
                PortfolioSearchResults_Wrapper wrapper = new PortfolioSearchResults_Wrapper();
                wrapper.customer = fuel.Premise__r.customer__r.Name;
                wrapper.customerName = fuel.Premise__r.customer__r.Customer_Name__c;
                wrapper.customerRecordID = fuel.Premise__r.customer__r.id;
                wrapper.campaignFlag = String.valueOf(fuel.Premise__r.customer__r.Campaign_Flag__c);
                wrapper.customerGroup = fuel.Premise__r.customer__r.Customer_group_type__c;
                wrapper.buildingNumber = fuel.Premise__r.Building_Number__c;
                wrapper.buildingName = fuel.Premise__r.Building_Name__c;
                wrapper.thorofare = fuel.Premise__r.thorofare__c;
                wrapper.town = fuel.Premise__r.town__c;
                wrapper.postcode = fuel.Premise__r.Postcode__c;
                wrapper.addressType = fuel.Premise__r.Address_Type__c;
                wrapper.mpan = fuel.MPAN__c;
                wrapper.mprn = fuel.MPRN__c;        
                lstWrapper.add(wrapper);
            }
        return lstWrapper;       
        }catch(Exception ex){
            System.debug('******Error: '+ ex.getStackTraceString());
        }
        return null;
    }    
    
    /**
        getPremiseRecords() - This method returns the site records when user enters only customer and site fields
                               in search.
    **/
    public list<PortfolioSearchResults_Wrapper> getPremiseRecords(){
        String queryString = 'select Address_Type__c, Building_Name__c ,Building_Number__c,';
               queryString += 'Postcode__c,Town__c, Thorofare__c, Customer__r.Customer_Name__c,';
               queryString += 'customer__r.Name, customer__r.id, ';
               queryString += 'customer__r.Customer_group_type__c, customer__r.Campaign_Flag__c';               
               queryString += ' from EON_Site__c where';
        
        if(customerID!= null && customerID!= ''){
           queryString = queryString+' and Customer__r.Name like '+ openQuotes + customerID + closeQuotes  ;
        }         
        if(customerName!= null && customerName!= ''){
           queryString = queryString+' and Customer__r.Customer_Name__c like '+ openQuotes + customerName + closeQuotes  ;
        }                   
        if(street!= null && street!= ''){
           queryString = queryString+' and Thorofare__c like '+ openQuotes + street + closeQuotes  ;
        }
        if(town!= null && town!= ''){
           queryString = queryString+' and Town__c like '+ openQuotes + town + closeQuotes  ;
        }       
        if(postcode!= null && postcode!= ''){
           queryString = queryString+' and PostCode__c like '+ openQuotes + postcode + closeQuotes  ;
        }
        
        queryString = queryString + ' order by name Limit 2000';
        queryString = queryString.replace('where order by', 'order by');
        queryString = queryString.replace('where and', 'where');    
        System.debug('******queryString ' + queryString);
        
        List<PortfolioSearchResults_Wrapper> lstWrapper = new List<PortfolioSearchResults_Wrapper>();
        for(EON_Site__c site: Database.query(queryString)){
            PortfolioSearchResults_Wrapper wrapper = new PortfolioSearchResults_Wrapper();
            wrapper.customer = site.customer__r.Name;
            wrapper.customerName = site.customer__r.Customer_Name__c;
            wrapper.customerRecordID = site.customer__r.id;
            wrapper.campaignFlag = String.valueOf(site.customer__r.Campaign_Flag__c);
            wrapper.customerGroup = site.customer__r.Customer_group_type__c;
            wrapper.buildingNumber = site.Building_Number__c;
            wrapper.buildingName = site.Building_Name__c;
            wrapper.thorofare = site.thorofare__c;
            wrapper.town = site.town__c;
            wrapper.postcode = site.Postcode__c;
            wrapper.addressType = site.Address_Type__c;            
            lstWrapper.add(wrapper);
        }
        return lstWrapper;                         
    }
    
    /**
        getCustomerRecords() : This method retruns the customer records when user enter only customer fields in serch.
    **/
    public list<PortfolioSearchResults_Wrapper> getCustomerRecords(){
        String queryString = 'select Customer_Name__c, Name, id, Customer_group_type__c, Campaign_Flag__c';
               queryString += ' from EON_Customer__c where';
        
        if(customerID!= null && customerID!= ''){
           queryString = queryString+' and Name like '+ openQuotes + customerID + closeQuotes  ;
        } 
        if(customerName!= null && customerName!= ''){
           queryString = queryString+' and Customer_Name__c like '+ openQuotes + customerName + closeQuotes  ;
        } 
                       
        queryString = queryString + ' order by name Limit 2000';
        queryString = queryString.replace('where order by', 'order by');
        queryString = queryString.replace('where and', 'where');    
        System.debug('******queryString ' + queryString); 
        
        List<PortfolioSearchResults_Wrapper> lstWrapper = new List<PortfolioSearchResults_Wrapper>();
        for(EON_Customer__c customer : Database.query(queryString)){
            PortfolioSearchResults_Wrapper wrapper = new PortfolioSearchResults_Wrapper();
            wrapper.customer = customer.Name;
            wrapper.customerName = customer.Customer_Name__c;
            wrapper.customerRecordID = customer.id;
            wrapper.campaignFlag = String.valueOf(customer.Campaign_Flag__c);
            wrapper.customerGroup = customer.Customer_group_type__c;
            lstWrapper.add(wrapper);
        }
        return lstWrapper;            
    }
    
    
    /**
        Description : This is a wrapper class to support display portfolio search results.
    **/
    public class PortfolioSearchResults_Wrapper{
        public String customerRecordID{get;set;}
        public String customer{get;set;}
        public String customerName{get;set;}
        public String campaignFlag{get;set;}
        public String customerGroup{get;set;}
        public String buildingNumber{get;set;}
        public String buildingName{get;set;}
        public String thorofare{get;set;}
        public String town{get;set;}
        public String postcode{get;set;}
        public String addressType{get;set;}
        public String mpan{get;set;}
        public String mprn{get;set;}
    }
  
   

   
  }