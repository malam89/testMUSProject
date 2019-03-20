/**
    Description : This class is used for the extension controller for the page : EON_Eligibility_Override_Create
    Test Class : EON_Eligibility_Overd_Create_Ctrl_Test
**/
/*
    Created By : Praveen G
    Created Date : 30/10/2017
    Service Request : SR_OptiMUS_EON_136
*/

public class EON_Eligibility_Override_Create_Ctrl{

    //Instance Variables
    public String siteName{get;set;}
    public String customerName{get;set;}
    public String selectedFlag{get;set;}
    public EON_Eligibility_Override__c record {get;set;}
    public String siteID{get;set;}
    
    /**
        EON_EON_Eligibility_Override_Create_Ctrl(ApexPages.StandardController stdController) - 
            Standard controller constructor.
    **/
    public EON_Eligibility_Override_Create_Ctrl(ApexPages.StandardController stdController) {
        record = (EON_Eligibility_Override__c)stdController.getRecord();
        siteID = ApexPages.currentPage().getParameters().get('siteID');
        Eon_Site__C siteRec = [select id, Name, Customer__r.Name from Eon_Site__c where id =:siteID];
        siteName = siteRec.Name;
        customerName = siteRec.Customer__r.Name;
    }
    
    /**
        getEligibilityFlags() - This method returns the Eligibility override flags. 
                            This list will be displayed in the pick list.
    **/    
    public List<SelectOption> getEligibilityFlags(){
        Set<String> controlSet = new Set<String>(); // this is to avoid duplicate contracts in the options
        List<SelectOption> lstCodeOption = new List<SelectOption>(); 
        lstCodeOption.add(new SelectOption('', 'None'));
        List<EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c> lstFlags = [select id, Name from EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c
                                            where isDeleted = false];
        
        for(EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c flag: lstFlags){
            if(!controlSet.contains(flag.Name)){
                controlSet.add(flag.Name);
                lstCodeOption.add(new SelectOption(flag.ID, flag.Name)); 
            }
        }
        
        return lstCodeOption;
    }    
    
    /**
        saveRec() - This method is used to override the standard save and saves the record.
    **/
    public pageReference saveRec(){
        try{
            //validate
            if(selectedFlag == null || selectedFlag ==''){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                    'Error : Please select Eligibility Override Code'));
                return null;
            }else{
                EON_Eligibility_Override__c[] records = [select id from EON_Eligibility_Override__c where
                                                        Premise__c =: siteID and 
                                                        Eligibility_Code__c =: selectedFlag];
                if(!records.isEmpty()){
                    Apexpages.addMessage(new ApexPages.Message
                      (ApexPages.Severity.ERROR,'Error : Eligibility Override cannot be inserted as already exists'));
                    return null;
                }                                                        
            }    
            
            EON_Site__c site = [select Customer__c from EON_Site__c where id=:siteID];
            
            record.Premise__c = siteID;
            record.Customer__c = site.Customer__c;
            record.Eligibility_Code__c = selectedFlag;
            record.Eligibility_Change_Type__c = 'I';
            upsert record;
            
            return (new PageReference('/'+siteID));
        }catch(Exception e){
            System.debug('Exception occured ' + e.getStackTraceString());
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error :' + e.getStackTraceString()));            
        }
        
        return null;
    }
    
    /**
        gotoSite()- this method is used to redirect to site reocrd.
    **/
    public PageReference gotoSite(){
        return (new PageReference('/'+siteID));
    }
       
}