/**
    Description : This class is as a helper class for EON Failed Asset object's Trigger.
    Test Class : EON_Failed_Asset_Trigger_Test
**/

/*
    Created By : Praveen G
    Created Date : 05/01/2018
    Service Request : SR_OptiMUS_EON_190
    
    Change History : 
    CH01 # SR_OptiMUS_EON_181 # 07/03/2018 # Praveen G # update stock record logic for failed assets
    CH02 # SR_OptiMUS_EON_224 # 22/03/2018 # Abhilash #  send an email IF a match is found in EON Stock
    CH03 # SR_OptiMUS_EON_273 # 14/09/2018 # Junaid #  Add EON Job Results field as per SR.

*/

public with sharing class EON_Failed_Asset_Trigger_Helper{

    /**
        calculateFailureCode(List<EON_Failed_Asset__c> triggerNew) - This method is for calculate the failure code 
            based on Failure Reason and Failed Asset Type fields.
    **/
    public static void calculateFailureCode(List<EON_Failed_Asset__c> triggerNew){
        MAP<String, String> mapFailureCode = getFailureCodeMapping();
        
        for(EON_Failed_Asset__c failedAsset : triggerNew){                    
            if(failedAsset.Failure_Reason__c!= null && failedAsset.Failed_Asset_Type__c != null &&
                    mapFailureCode.get(failedAsset.Failure_Reason__c.toUppercase()+
                                        failedAsset.Failed_Asset_Type__c.toUppercase()) != null)
                failedAsset.h_Failure_Code__c = 
                    mapFailureCode.get(failedAsset.Failure_Reason__c.toUppercase() + failedAsset.Failed_Asset_Type__c.toUppercase());                
            else
                failedAsset.h_Failure_Code__c = '';
        }
    }
    
    /**
        getFailureCodeMapping()- this method is to calculate the Failure code mapping
    **/
    public static MAP<String, String> getFailureCodeMapping(){
        MAP<String, String> mapFailureCode = new MAP<String, String>();
        
        MAPFAILURECODE.PUT('UNABLE TO BINDSMART ELECTRIC METER', 'SEUBIND');
        MAPFAILURECODE.PUT('UNABLE TO BINDSMART GAS METER', 'SEUBIND');
        MAPFAILURECODE.PUT('UNABLE TO BINDIHD', 'SEUBIND');
        
        MAPFAILURECODE.PUT('THD CONFIRMED SYSTEM OUTAGE DURING INSTALLSMART ELECTRIC METER', 'SEOUTAGE');
        MAPFAILURECODE.PUT('THD CONFIRMED SYSTEM OUTAGE DURING INSTALLSMART GAS METER', 'SEOUTAGE');
        
        MAPFAILURECODE.PUT('UNABLE TO SCHEME / CONFIGURE THE METER REMOTELYSMART ELECTRIC METER', 'SEUSCHEME');
        MAPFAILURECODE.PUT('UNABLE TO SCHEME / CONFIGURE THE METER REMOTELYSMART GAS METER', 'SGUSCHEME');
        
        MAPFAILURECODE.PUT('ALREADY ASSOCIATED TO ANOTHER MPAN/MPRNSMART ELECTRIC METER', 'SEUSED');
        MAPFAILURECODE.PUT('ALREADY ASSOCIATED TO ANOTHER MPAN/MPRNSMART GAS METER', 'SGUSED');
        
        MAPFAILURECODE.PUT('NOT IN MIDOSSMART ELECTRIC METER', 'SEUNKNOWN');
        MAPFAILURECODE.PUT('NOT IN MIDOSSMART GAS METER', 'SGUNKNOWN');
        
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDSMART ELECTRIC METER', 'SEERRCODE');
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDSMART GAS METER', 'SGERRCODE');
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDIHD', 'IERRCODE');
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDCLASSIC GAS METER', 'CGERRCODE');
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDCLASSIC ELECTRIC METER', 'CEERRCODE');
        
        MAPFAILURECODE.PUT('BLANK SCREENSMART ELECTRIC METER', 'SEBLANKDISPLAY');
        MAPFAILURECODE.PUT('BLANK SCREENSMART GAS METER', 'SGBLANKDISPLAY');
        MAPFAILURECODE.PUT('BLANK SCREENIHD', 'IBLANKDISPLAY');
        MAPFAILURECODE.PUT('BLANK SCREENCLASSIC GAS METER', 'CGBLANKDISPLAY');
        MAPFAILURECODE.PUT('BLANK SCREENCLASSIC ELECTRIC METER', 'CEBLANKDISPLAY');
                
        MAPFAILURECODE.PUT('WARNING TRIANGLESMART ELECTRIC METER', 'SEWARNING');
        MAPFAILURECODE.PUT('WARNING TRIANGLESMART GAS METER', 'SGWARNING');
        MAPFAILURECODE.PUT('WARNING TRIANGLECLASSIC GAS METER', 'CGWARNING');
        MAPFAILURECODE.PUT('WARNING TRIANGLECLASSIC ELECTRIC METER', 'CEWARNING');
        
        MAPFAILURECODE.PUT('PHYSICAL DAMAGESMART ELECTRIC METER', 'SEDAMAGE');
        MAPFAILURECODE.PUT('PHYSICAL DAMAGESMART GAS METER', 'SGDAMAGE');
        MAPFAILURECODE.PUT('PHYSICAL DAMAGEIHD', 'IDAMAGE');
        MAPFAILURECODE.PUT('PHYSICAL DAMAGEREGULATOR', 'RDAMAGE');
        MAPFAILURECODE.PUT('PHYSICAL DAMAGECLASSIC GAS METER', 'CGDAMAGE');
        MAPFAILURECODE.PUT('PHYSICAL DAMAGECLASSIC ELECTRIC METER', 'CEDAMAGE');
        
        MAPFAILURECODE.PUT('RETURN OF ASSET SETSMART ELECTRIC METER', 'SERETURNSET');
        MAPFAILURECODE.PUT('RETURN OF ASSET SETSMART GAS METER', 'SGRETURNSET');
        
        MAPFAILURECODE.PUT('FAULTY KEYPADSMART ELECTRIC METER', 'SEFAULTKEY');
        MAPFAILURECODE.PUT('FAULTY KEYPADSMART GAS METER', 'SGFAULTKEY');
        MAPFAILURECODE.PUT('FAULTY KEYPADIHD', 'IFAULTKEY');
        MAPFAILURECODE.PUT('FAULTY KEYPADCLASSIC GAS METER', 'CGFAULTKEY');
        MAPFAILURECODE.PUT('FAULTY KEYPADCLASSIC ELECTRIC METER', 'CEFAULTKEY');
        
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDSMART ELECTRIC METER', 'SEERRCODE');
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDSMART GAS METER', 'SGERRCODE');
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDIHD', 'IERRCODE');
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDCLASSIC GAS METER', 'CGERRCODE');
        MAPFAILURECODE.PUT('ERROR CODE DISPLAYEDCLASSIC ELECTRIC METER', 'CEERRCODE');
        
        MAPFAILURECODE.PUT('NO FLOWREGULATOR', 'RNOFLOW');
        MAPFAILURECODE.PUT('NO FLOWCLASSIC GAS METER', 'CGNOFLOW');
        MAPFAILURECODE.PUT('NO FLOWCLASSIC ELECTRIC METER', 'CENOFLOW');
        
        MAPFAILURECODE.PUT('PREPAYMENT FAULTCLASSIC GAS METER', 'CGPREPAYFAULT');
        MAPFAILURECODE.PUT('PREPAYMENT FAULTCLASSIC ELECTRIC METER', 'CEPREPAYFAULT');
        
        MAPFAILURECODE.PUT('DAMAGED CASECOMMS HUB', 'CHDAMCASE');
        
        MAPFAILURECODE.PUT('DAMAGED CONNECTOR/TAMPER/MISSING SEALSCOMMS HUB', 'CHDAMCONN');
        
        MAPFAILURECODE.PUT('ENVIRONMENTAL CONDITIONS EXCEEDEDCOMMS HUB', 'CHENVIRONMENTAL');
        MAPFAILURECODE.PUT('SM WAN FAULTCOMMS HUB', 'CHSMWAN');
        MAPFAILURECODE.PUT('SMHAN INTERFACE FAULTCOMMS HUB', 'CHSMHAN');
        MAPFAILURECODE.PUT('LED FAULTCOMMS HUB', 'CHLEDFAULT');
        MAPFAILURECODE.PUT('AERIAL FAULTCOMMS HUB', 'CHAERIALFAULT');
        
        MAPFAILURECODE.PUT('MANUFACTURING DEFECTCOMMS HUB', 'CHMANUFACTUREFAULT');
        MAPFAILURECODE.PUT('CELLULAR FAILEDCOMMS HUB', 'SKU1FAILED');
        MAPFAILURECODE.PUT('MESH NO SIGNAL', 'SKU2NOSIGNAL');
        MAPFAILURECODE.PUT('PSU FAULTY', '');
        
        MAPFAILURECODE.PUT('PSU FAULTYIHD', 'IPSU');
        MAPFAILURECODE.PUT('HAN FAILUREIHD', 'IHANFAIL');
        MAPFAILURECODE.PUT('PART OF ASSET SETIHD', 'PARTOFSET');
        
        MAPFAILURECODE.PUT('LOW PRESSUREREGULATOR', 'RLOWPRESSURE');
        MAPFAILURECODE.PUT('LEAKINGREGULATOR', 'RLEAK');
                
        return mapFailureCode;
    }
    
    //CH01.Start
    /**
        updateStockForFailedAsset(List<EON_Failed_Asset__c> lstTriggerNew) - 
            This method will update stock record with the failed asset date.
    **/
    public static void updateStockForFailedAsset(List<EON_Failed_Asset__c> lstTriggerNew){
        Map<String, EON_Failed_Asset__c> mapSNFailedAsset = new Map<String, EON_Failed_Asset__c>();
        Map<String, EON_Failed_Asset__c> mapSNFailedAssettech = new Map<String, EON_Failed_Asset__c>();      //CH03
        
        for(EON_Failed_Asset__c failedAsset : lstTriggerNew){
            mapSNFailedAsset.put(failedAsset.Failed_Asset_Serial_Number__c, failedAsset);
            
         }
        //ch02 starts
        Set<String> EonStck = new Set<String>();
        
        //ch02 ends
        List<Eon_Stock__c> lstUpdateStock = new List<Eon_Stock__c>();
        for(Eon_Stock__c Stock : [select id, Technician_Name__c,Serial_Number__c,Status__c,EON_Job_Results__c from Eon_Stock__c where  
                                        Serial_number__c in : mapSNFailedAsset.keySet()]){
                                        
            //ch02 
            EonStck.add(Stock.Serial_number__c);
            //ch02 ends
    
            
            if(stock.Serial_Number__c != null && mapSNFailedAsset.get(stock.serial_number__c) != null
                && mapSNFailedAsset.get(stock.serial_number__c).h_Time_On_Site__c != null && stock.status__c=='On Van'){//CH03 added 'On Van' condition                                        
                stock.Date_Failed__c = mapSNFailedAsset.get(stock.serial_number__c).h_Time_On_Site__c.date();
                //CH03 Start
                stock.EON_Job_Results__c = mapSNFailedAsset.get(stock.Serial_Number__c).EON_Job_Results__c;     
                stock.status__c='Failed';
                if(stock.Technician_Name__c!=mapSNFailedAsset.get(stock.Serial_Number__c).h_Technician__c)
                   stock.Technician_Mismatch__c=true;
                stock.Technician_Name__c=mapSNFailedAsset.get(stock.Serial_Number__c).h_Technician__c; 
                system.debug('======>>jobResultId'+stock.EON_Job_Results__c );
                //Ch03 End
                lstUpdateStock.add(stock);
            } 
            //ch02 starts
            if(stock.Status__c != 'On Van'){
                 sendMail(mapSNFailedAsset.get(stock.serial_number__c),Stock.ID);
            }
            
        }                               
        for(EON_Failed_Asset__c failedAsset : lstTriggerNew){
        system.debug('assetnumebr%%%%%%'+failedAsset.Failed_Asset_Serial_Number__c + EonStck);
            if(!EonStck.contains(failedAsset.Failed_Asset_Serial_Number__c)){
            sendMail(failedAsset,null);
            }
        }
         //ch02 ends  
        if(!lstUpdateStock.isEmpty())
            upsert lstUpdateStock;
    }

    //CH01.End       
    
    //ch02 Starts
                
        public static void sendMail(EON_Failed_Asset__c failedasset,String StockId){
        string toMail;
        string ccMail ;
        string repMail;
        System.debug('abhilash--->'+StockId);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo=System.Label.EON_Stock_Reconciliation_email.split(';');
       
        //string[] to = new string[] {toMail};
        string[] cc = new string[] {ccMail};
         
        email.setToAddresses(sendTo);
        if(ccMail!=null && ccMail != '')
            email.setCcAddresses(cc);
        if(repmail!=null && repmail!= '')
            email.setInReplyTo(repMail);
        String recordURLFaulty = EON_Utility.getInstanceURL() +'/'+failedasset.Id;
        String recordURLFaulty1 = EON_Utility.getInstanceURL() +'/'+StockID;
        email.setSubject('EON Stock Record Require Manual Validation (Failed Assets)');
         String emailbody='';
         emailbody='Dear recipient, <br/><br/>Serial Number '+failedasset.Failed_Asset_Serial_Number__c+' has been recorded as a failed asset. Either no match has been found in EON stock or a match has been found that IS NOT in “On Van” status <br/><br/>Below are all the relevant record links in OptiMUS;';
        emailbody=StockID!=null ? emailbody+'<a href='+recordURLFaulty1+'>'+recordURLFaulty1+'</a>': emailbody; 
        emailbody=emailbody+'<br/><br/> <a href='+recordURLFaulty+'>'+recordURLFaulty+'</a><br/><br/>Please investigate as to why this stock record doesn’t exist or isn’t showing as “On Van” and manually update where applicable.<br/><br/>Kind regards<br/> The Stock Reconciliation Team';
        email.setHtmlBody(emailbody);
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }catch(exception e){
           // apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
         
        toMail = '';
        ccMail = '';
        repMail = '';
    }
    //ch02 Ends
}