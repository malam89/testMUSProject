/**
    Description : This test class covers the code coverage for below class
                  EON_Utility
**/
/*
    Created By : Praveen G
    Created Date : 07-March-2016
    Service Request : N/A
    Change History
*/
@isTest
private class EON_Ceva_Utility_Test {
    static testMethod void unitTest3(){
        
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
        List<EON_Order__c> orderList1 = EON_CreateTestRecords.createEon_OrderList();
        orderList1[0].Technician_Name__c = eonTech.id;
        orderList1[0].Reservation__c = '';
        orderList1[1].Technician_Name__c = eonTech.id;
        orderList1[1].Reservation__c = '9600000001';
        insert orderList1;
        EON_Ceva_Utility.CreateOrderRecords(eonTech,epLst[0],5, 'INITIAL',1000,null);
        EON_Ceva_Utility.GetReservationNumber();
    }
}