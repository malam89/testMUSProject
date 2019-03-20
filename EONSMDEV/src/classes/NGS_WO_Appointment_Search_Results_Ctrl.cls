/**
    Description : This class is used to get the search results for NGS Work Order Appointment search.
    VF Page : NGS_WO_Appointment_Search_Results, NGS_WO_Appointment_Search_Sidebar
    Test Class : NGS_WO_Appt_Search_Results_Ctrl_Test
**/
/*
    Created By : Puneet Mehta
    Created Date : 06/02/2017
    Service Request : SR_OptiMUS_NG_012
*/
public with sharing class NGS_WO_Appointment_Search_Results_Ctrl{
    public string openQuotes = '\'%';
    public string closeQuotes = '%\'';
    public Integer pageSize{get;set;}
    public Integer noOfPages{get;set;}
    public Integer pageNumber{get;set;}
    public Integer totalNoOfRecs{get;set;}

    public NGS_WO_Appointment_Search_Results_Ctrl(){
        totalNoOfRecs = 0;
        if(System.currentPageReference().getParameters().size() > 0){
            String woNumber = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('woNumber').trim());
            String address1 = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('address1').trim());
            String postCode = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('postCode').trim());
            String queryString = 'select Id, Name, Address_Line_1__c, Post_Code__c, Address_Line_2__c, City__c, Depot__c';
            queryString += ' from NGS_Work_Order_Appointment__c where';
            if(woNumber != null && woNumber != ''){
                queryString = queryString+' and Name like '+ openQuotes + woNumber + closeQuotes;
            }
            if(address1 != null && address1 != ''){
               queryString = queryString+' and Address_Line_1__c like '+ openQuotes + address1 + closeQuotes;
            }
            if(postCode != null && postCode != ''){
               queryString = queryString+' and Post_Code__c like '+ openQuotes + postCode + closeQuotes;
            }
            queryString = queryString + ' order by name';
            queryString = queryString.replace('where order by', 'order by');
            queryString = queryString.replace('where and', 'where');
            List<NGS_Work_Order_Appointment__c> lstAppointment1 = Database.query(queryString);
            totalNoOfRecs = lstAppointment1.size();
        }
    }
    /**
        displayRecord() - This method redirects the user to the NGS Work Order Appointment record if only 1 record is returned as result of search
    **/
    public PageReference displayRecord(){
        pageSize = 50;
        noOfPages = 0;
        pageNumber = 0;
        List<NGS_Work_Order_Appointment__c> lstAppointment = getAppointmentResults();
        noOfPages = totalNoOfRecs/pageSize;
        if (Math.mod(totalNoOfRecs, pageSize) > 0)
            noOfPages++;
        PageReference pageRef = null;
        if(lstAppointment != null && lstAppointment.size() == 1){
            pageRef = new PageReference('/'+ lstAppointment[0].id);
            pageRef.setRedirect(true);
        }
        return pageRef;
    }
    /**
        getAppointmentResults() - This method will return the NGS Work Order Appointment search results.
    **/
    public List<NGS_Work_Order_Appointment__c> getAppointmentResults(){
        try{
            Integer offset = 0;
            offset = pageNumber * pageSize;
            String woNumber = '';
            String address1 = '';
            String postCode = '';
            String queryString = '';
            if(System.currentPageReference().getParameters().size() > 0){
                woNumber = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('woNumber').trim());
                address1 = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('address1').trim());
                postCode = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('postCode').trim());
                queryString = 'select Id, Name, Address_Line_1__c, Post_Code__c, Address_Line_2__c, City__c, Depot__c';
                queryString += ' from NGS_Work_Order_Appointment__c where';
                if(woNumber != null && woNumber != ''){
                   queryString = queryString+' and Name like '+ openQuotes + woNumber + closeQuotes;
                } 
                if(address1 != null && address1 != ''){
                   queryString = queryString+' and Address_Line_1__c like '+ openQuotes + address1 + closeQuotes;
                }  
                if(postCode != null && postCode != ''){
                   queryString = queryString+' and Post_Code__c like '+ openQuotes + postCode + closeQuotes;
                }
                queryString = queryString + ' order by name Limit ' + pageSize +' offset '+ offset;
                queryString = queryString.replace('where order by', 'order by');
                queryString = queryString.replace('where and', 'where');
                return Database.query(queryString);}}catch(exception ex){ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getMessage()); ApexPages.addMessage(msg);}
        return null;
    }

    public PageReference next(){
        pageNumber++; 
        getAppointmentResults();
        return null;
    }
    public PageReference previous(){
        pageNumber--;
        if (pageNumber < 0)
            return null;
        getAppointmentResults();
        return null;
    }
}