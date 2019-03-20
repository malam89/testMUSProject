/**
    Description : This controller is used to perform the operations for the page - EON_Application
    Service Request : SR_Isis_EON_010
    Test Class : EON_Application_Ctrl_Test
**/
/*
    Created By : Praveen G
    Created Date : 19-March-2016
*/

public with sharing class EON_Application_Ctrl{

    //Instatnce variables
    public EON_Application__c application{get;set;}
    public String selectedContract{get;set;}
    public integer countAppointment{get;set;}
    public decimal totalValue{get;set;}
    public boolean renderCalAppBtn{get;set;}
    public boolean renderNorecordsText{get;set;}
    public List<ID> lstAppointmentValueID{get;set;}
    public integer totalAppointmentValue{get;set;}
    
    /**
        EON_Application_Ctrl() - Default constructor to initialize the variables.
    **/
    public EON_Application_Ctrl(){
        application = new EON_Application__c();
        countAppointment = 0;
        totalValue = 0;
        renderCalAppBtn = false;
        renderNorecordsText = false;
        lstAppointmentValueID = new List<ID>();
        totalAppointmentValue = 0;
    }
    
    /**
        getContracts() - This method returns the contracts for EON. This list will be displayed in the pick list.
    **/    
    public List<SelectOption> getContracts(){
        Set<String> controlSet = new Set<String>(); // this is to avoid duplicate contracts in the options
        List<SelectOption> lstContractOption = new List<SelectOption>(); 
        List<Contract_Number__c> lstEonContract = [select id, Name from Contract_Number__c where Contract_Client_Short_Name__c = 'EON'];
        
        for(Contract_Number__c contract : lstEonContract){
            if(!controlSet.contains(contract.Name)){
                controlSet.add(contract.Name);
                lstContractOption.add(new SelectOption(contract.ID, contract.Name)); 
            }
        }
        
        return lstContractOption;
    }
    
    /**
        calculateValue() - this method calculate the number of appointments and the value.
    **/
    public void calculateValue(){
        try{
            //validations 
            if(application.Date_To__c > System.today() || 
                    (application.date_From__c != null && application.Date_To__c < application.date_From__c)){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                        'Error : Date To must be less than or equal to today and must be greater then equal to Date From if exists'));
                return;                        
            }    
            renderCalAppBtn = false;
            renderNorecordsText = false;               
            //logic to calculate Appointments and value.
            EON_Appointment__c[] lstAppointment = [select id, Appointment_Date__c, 
                                                    (select id, value__c from EON_Appointment_Values__r where Application__c = null)
                                                   from EON_Appointment__c 
                                                   where 
                                                   Contract__c =:selectedContract AND
                                                   Appointment_Date__c >= : application.Date_From__c AND
                                                   Appointment_Date__c <= : application.Date_To__c
                                                   limit : Integer.valueOf(System.Label.Appointment_Limit)
                                                   ];
            countAppointment = 0;  
            totalvalue = 0; 
            totalAppointmentValue = 0;
            lstAppointmentValueID.clear();                                              
            for(EON_Appointment__c appointment : lstAppointment){
                if(!appointment.EON_Appointment_Values__r.isEmpty()){
                    countAppointment++;
                    totalAppointmentValue += appointment.EON_Appointment_Values__r.size();
                } 
                if(totalAppointmentValue >= 10000){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                    'Error : Maximum records has been exceeded. Please reduce date window accordingly'));
                    return;                                        
                }     
                for(EON_Appointment_Value__c appValue : appointment.EON_Appointment_Values__r){
                    lstAppointmentValueID.add(appValue.id);
                    totalvalue += appValue.value__c;
                }        
            }
            
            if(countAppointment > 0 )
                renderCalAppBtn = true;
            else
                renderNorecordsText = true;  
        }catch(Exception ex){
            System.debug('Exception occured : ' + ex.getStackTraceString());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error :'+ex.getMessage() ));
            
        }          
                                                         
    }
    
    /**
        createApplication() - this method creates an application record based on the apppointments between the dates selected.
    **/
    public void createApplication(){
        try{
            //create application record
            EON_Application__c application = new EON_Application__c();
            application.Application_Date__c = System.today();
            insert application;
            
            //Map application record to appointment value record.
            List<EON_Appointment_Value__c> lstUpdateAppointmentValue = new List<EON_Appointment_Value__c>();
            for(ID appValueID : lstAppointmentValueID){
                EON_Appointment_Value__c appointmentValue = new EON_Appointment_Value__c(id=appValueID);
                appointmentValue.Application__c = application.id;
                lstUpdateAppointmentValue.add(appointmentValue);
            }
            update lstUpdateAppointmentValue;
            String applicationName = [select name from EON_Application__c where id=:application.id].Name;
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Application <a href=/'+application.id+' target="_blank">'+applicationName+'</a> has been created - click here to open' ));
            renderCalAppBtn = false;
            renderNorecordsText = false;
        }catch(exception ex){
            System.debug('Exception occured : ' + ex.getStackTraceString());
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error :'+ex.getMessage() ));            
        }
    }
    
    
}