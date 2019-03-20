/**
    Description : 1)When a user relates a new “Profile Product” to a Stock Profile record. Check that that EON Product IS NOT already 
                    related to the Stock Profile. 
                    IF the EON Product is already related then display the following error message “This Product is already related to 
                    this Stock Profile, please select another
                  
                  2)CH01-When a user relates a new “Profile Product” to a EON Product record,CHECK the EON Products records for Linked Product 
                    IF the Product Code matches any Linked Products then display the following error message “Error - The selected product 
                    is a linked product on another product record. Please review”
 
                                    
    VF Page     : None
    Test Class  : Profile_Product_Trigger_Helper_Test

**/
/*
    Created By : Mehboob Alam
    Created Date : 11/03/2018
    Service Req  : SR_OptiMUS_EON_205
    
    CHANGE HISTORY:
    CH01 # SR_OptiMUS_EON_185 # 15/March/2018 # GunaSekhar P # Added 'DupProProductLink' method to disply error message. 
*/
public with sharing class Profile_Product_Trigger_Helper {
        
    /**
    DupProProduct(List<Profile_Product__c> lstPPro):This method for checking duplicate product against a Stock Profile.
    **/    
    public static void DupProProduct(List<Profile_Product__c> lstPPro){
        Set<ID> sProIds =  new Set<ID>(); //List of All Stock Profile ids
        map<id,set<id>> mapSPro = new map<id,set<id>>(); //Map to contain Stock Profile ids and related Products.
        
        for(Profile_Product__c pp : lstPPro)
            sProIds.add(pp.Stock_Profile__c);


         for(EON_Stock_Profile__c esp : [select id,(select id,Product__c from Profile_Product__r) from EON_Stock_Profile__c where id in:sProIds]){
            if(!mapSPro.containsKey(esp.id)){
                mapSPro.put(esp.id, new set<id>());
                for(Profile_Product__c sp : esp.Profile_Product__r){
                   if(mapSPro.containsKey(esp.id))
                      mapSPro.get(esp.id).add(sp.Product__c);
                }
            }     
        }
             
        for(Profile_Product__c ep : lstPPro){
            if(mapSPro.containsKey(ep.Stock_Profile__c))
               if(mapSPro.get(ep.Stock_Profile__c).contains(ep.Product__c))
                  ep.addError('This Product is already related to this Stock Profile, please select another');
              }
       } 
       
    //CH01.Starts       
    /**
    DupProProductLink(List<Profile_Product__c> lstPProLink):This method for checking entered Product Code matches any Linked Products on Product already. 

    **/    
    public static void DupProProductLink(List<Profile_Product__c> lstPProLink){
        Set<ID> ProIds =  new Set<ID>(); 
       
        for(Profile_Product__c pp : lstPProLink){
            if(pp.Product__c!=null) 
               ProIds.add(pp.Product__c);
        }  
        
        Set<String> lstProductID = new Set<String>();
        for(EON_Product__c product : [select id, Linked_Product__c from EON_Product__c 
                                        where Linked_Product__c =:ProIds]){
            lstProductID.add(product.Linked_Product__c);
        }
        
        if(!ProIds.isEmpty()){        
            for(Profile_Product__c pp : lstPProLink){
                if(pp.Product__c != null && lstProductId.contains(pp.Product__c))
                    pp.adderror('Error - The selected product is a linked product on another product record. Please review');
            }
        }
              
    } 
    //CH01.Ends
}