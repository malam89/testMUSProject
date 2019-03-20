/**
    Description : This test class is for the following below classes/triggers
                  EON_Replenish_TechStock_CEVA_Batch,
                  EON_Replenish_TechStock_CEVA_Schedulable
                       
**/
/*
    Created By  : Mehboob Alam
    Created On  : 01/12/2017
    Covering Components : EON_Replenish_TechStock_CEVA_Batch,EON_Replenish_TechStock_CEVA_Schedulable
    Service Req : SR_OptiMUS_EON_168
    Change History
    
*/
@isTest
private class EON_Replenish_TechStock_CEVA_Batch_Test {

    static testMethod void myUnitTest() {
        
        List<EON_Product__c> epLst = New List<EON_Product__c>();
        EON_Product__c product = new EON_Product__c(Active__c=true, Name='Pro121');
        EON_Product__c product1 = new EON_Product__c(Active__c=true, Name='Pro111');
        epLst.add(product);
        epLst.add(product1);
        insert epLst;
        
        EON_Stock_Profile__c profile = new EON_Stock_Profile__c();
        profile.name = string.valueOf(crypto.getRandomLong()).replace('-','')+String.valueof(DateTime.now()).deleteWhitespace().replace('-','').replace(':','');
        insert profile;        
       
        
        List<Profile_Product__c> lstPP = new List<Profile_Product__c>();  
        Profile_Product__c profileProduct = new Profile_Product__c(Product__c = epLst[0].id,Stock_Profile__c = profile.id,Max_Level__c = 20,BAU_Trigger_Level__c =3);
        Profile_Product__c profileProduct1 = new Profile_Product__c(Product__c = epLst[1].id,Stock_Profile__c = profile.id,Max_Level__c = 20,BAU_Trigger_Level__c =3);
        lstPP.add(profileProduct);
        lstPP.add(profileProduct1);
        insert lstPP;
        
        EON_Technician__c eonTech = new EON_Technician__c (stock_Profile__c = profile.id,Name = 'TechnicianTest',Start_Date__c=Date.today(),Email__c = 'test@gmail.com',
                                      Mobile__c = '123456875', E_Credit_Meter_SR_1R_0393_Classic__c=10,Gas_Credit_Meter_Classic__c=20, h_Order_Sent__c=true,h_Send_to_CEVA__c=system.today(),
                                      Initial_Stock_Pickup_Location__c='pune',Regulators_Gas__c=10, Smart_Electric_Meter__c=5,Smart_Energy_Display_SED_IHD__c=10,Smart_Gas_Meter__c=10,
                                      Work_Zone__c='London South East',Sent_to_OFS__c=null); 
        insert eonTech; 
       
        List<EON_Stock__c> est = new  List<EON_Stock__c>();
        EON_Stock__c eonstock = new EON_Stock__c(Product_Code__c='Pro121', Technician_Name__c=eonTech.id,Status__c='On Van');
        EON_Stock__c eonstock1 = new EON_Stock__c(Product_Code__c='Pro121', Technician_Name__c=eonTech.id,Status__c='On Van');
        est.add(eonstock);
        est.add(eonstock1);
        insert est;
           	
        EON_Replenish_TechStock_CEVA_Schedulable obj = new EON_Replenish_TechStock_CEVA_Schedulable(); 
        obj.execute(null);   
    }
}