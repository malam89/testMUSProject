/**
    Description :1)This trigger does the following
                   When a user relates a new “Profile Product” to a Stock Profile record. Check that that EON Product IS NOT already 
                   related to the Stock Profile. 
                   IF the EON Product is already related then display the following error message “This Product is already related to 
                   this Stock Profile, please select another
                 2)When a user relates a new “Profile Product” to a EON Product record,CHECK the EON Products records for Linked Product 
                   IF the Product Code matches any Linked Products then display the following error message “Error - The selected product 
                   is a linked product on another product record. Please review”

    
    Test Class :  Profile_Product_Trigger_Helper_Test
**/

/*
    Created By : Mehboob Alam
    Created Date : 11/03/2018
    Service Req: SR_OptiMUS_EON_205
    
    CHANGE HISTORY: CH01 # SR_OptiMUS_EON_185 # 15/March/2018 # GunaSekhar P # Calling Profile_Product_Trigger_Helper.DupProProductLink method.    
*/
trigger Profile_Product_Trigger on Profile_Product__c (before insert, before update) {
    
     if(Trigger.isBefore && Trigger.isInsert)
        Profile_Product_Trigger_Helper.DupProProduct(Trigger.New);
     
     if((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate))
         Profile_Product_Trigger_Helper.DupProProductLink(Trigger.New);//CH01
}