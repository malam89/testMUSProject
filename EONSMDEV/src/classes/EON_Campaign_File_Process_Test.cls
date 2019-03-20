/**
Description : This test class is for the following classes
              EON_Campaign_File_Process
**/
/*
    Created By  : Mahadev Joshilkar
    Created On  : 11/07/2016
    Service Req : SR_EON_PC_067
    Change History 
*/
@isTest
public class EON_Campaign_File_Process_Test {
    public static boolean genException;
    /**
        setup(): Method to setup test data for the class
    **/
    @testSetup static void setup(){
        //Create EON Customer
        EON_Customer__c customer1 = EON_CreateTestRecords.createEONCustomer();
        customer1.Name = '9988776655';
        customer1.Smart_Interest__c = 'N';
        customer1.Customer_group_type__c = 'RES';
        customer1.Customer_Name__c = 'False-RES-N'; //Campaign Flag, Customer_group_type__c, Smart Integerest
        insert customer1;
        
        //Create EON Site
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Customer__c = customer1.ID;
        insert eSite;
        
        //Create EON Fuel
        list<EON_Fuel__c> allFuel = new list<EON_Fuel__c>();
        EON_Fuel__c eFuelDF = EON_CreateTestRecords.createEONFuel();
        eFuelDF.Premise__c = eSite.ID;
        eFuelDF.MPRN__c = '1111';
        eFuelDF.MPAN__c = '2221';
        allFuel.add(eFuelDF);
        EON_Fuel__c eFuelGas = EON_CreateTestRecords.createEONFuel();
        eFuelGas.Premise__c = eSite.ID;
        eFuelGas.MPRN__c = '1112';
        eFuelGas.Fuel_type__c = 'G';
        allFuel.add(eFuelGas);
        EON_Fuel__c eFuelElec = EON_CreateTestRecords.createEONFuel();
        eFuelElec.Premise__c = eSite.ID;
        eFuelElec.MPAN__c = '2222';
        allFuel.add(eFuelElec);
        insert allFuel;
        
        //Create EON Campaign
        EON_Campaign__c campaign = EON_CreateTestRecords.createEONCampaign();
        campaign.Campaign_Type__c = 'SME';
        insert campaign;
        
        EON_Opt_in_Opt_Out_Preference__c  optin = new EON_Opt_in_Opt_Out_Preference__c(Customer__c=customer1.ID,Opt_In_Opt_Out_Preference__c=true,Premise__c=eSite.ID);
        insert optin;
        
        //Create Attachment
        String finalStr='MPRN,MPAN,Cust ID,Premise SFID,Cust SFID,Campaign Letter,Smart ,Re-Cert,Opt in / Opt out preference'+'\r\n';
        finalStr+='1111'+','+'2221'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        finalStr+='1112'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        finalStr+=''+','+'2222'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        Attachment attach = new Attachment();
        attach.ParentId = campaign.ID;
        attach.Name = 'test.csv';
        attach.ContentType = 'application/vnd.ms-excel';
        attach.Body = Blob.valueOf(finalStr);
        insert attach;
        
        //Create EON Campaign CSV 
        EON_Campaign_Csv__c cCsv = new EON_Campaign_Csv__c(Name='zensar',Campaign_Letter__c='ALLVU001',Cust_ID__c='sfdc',Cust_SFID__c='cdfs',MPAN__c='sfd12',MPRN__c='redgf45',Opt_in_Opt_out_preference__c='redgf',Premise_SFID__c='sfdxc',Re_Cert__c='redgsf',Smart__c='smart');
        insert cCsv; 

    }
    /**
      processCampaign(): This method will
  **/
    static testmethod void processCampaign(){
        EON_Customer__c customer = [Select ID, Campaign_Flag__c, Customer_group_type__c, Smart_Interest__c from EON_Customer__c where Name='9988776655'];
        EON_Campaign__c campaign = [Select ID from EON_Campaign__c where Campaign_Type__c='SME' limit 1];
        Attachment attach = [Select ID, Body from Attachment where ParentID=:campaign.Id];
        string body = attach.Body.toString();
        EON_Campaign_Csv__c cCsv = [ Select Name,Campaign_Letter__c,Cust_ID__c,Cust_SFID__c,MPAN__c,MPRN__c,Opt_in_Opt_out_preference__c,Premise_SFID__c,Re_Cert__c,Smart__c From EON_Campaign_Csv__c limit 1 ];
       
        test.startTest();
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        //customer.Smart_Interest__c = 'Y';
        customer.Customer_group_type__c = 'SME';
        update customer;
        
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        customer.Customer_group_type__c = 'RES';
        customer.Campaign_Flag__c = true;
        update customer;
        
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        customer.Campaign_Flag__c = false;
        update customer;
        
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        customer.Customer_group_type__c = 'SME';
        update customer;
        
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        body +='9999'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        body +=''+','+'9999'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        attach.Body = blob.valueOf(body);
        update attach;        
        
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        customer.Customer_group_type__c = 'RES';
        customer.Current_Payment_Method_Indicator__c = 'OD';
        customer.Campaign_Flag__c = true;
        customer.PAYG_Flag__c = 'N';  
        update customer;       
                
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        customer.Customer_group_type__c = 'RES';
        customer.Current_Payment_Method_Indicator__c = '1';
        update customer;
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        
        
        test.stopTest();
    }
    
    static testmethod void processCampaign1(){
        
        EON_Customer__c customer2 = EON_CreateTestRecords.createEONCustomer();
        customer2.Name = '9988776644';
        customer2.Smart_Interest__c = 'N';
        customer2.Customer_group_type__c = 'RES';
        customer2.Current_Payment_Method_Indicator__c = 'Not OD';
        customer2.Customer_Name__c = 'False-RES-N';
        customer2.Campaign_Flag__c = false;
        insert customer2;
        
        EON_Site__c eSite2 = EON_CreateTestRecords.createEonSite();
        eSite2.Customer__c = customer2.ID;
        insert eSite2;
        
        EON_Fuel__c eFuelElec2 = EON_CreateTestRecords.createEONFuel();
        eFuelElec2.Premise__c = eSite2.ID;
        eFuelElec2.MPAN__c = '2222';
        eFuelElec2.MPRN__c = '1111';
        insert eFuelElec2;
        
        EON_Vulnerability_Code__c eonVulnerabilityCode = EON_CreateTestRecords.createVulnerabilityCode();
        eonVulnerabilityCode.name = 'TestVC';
        eonVulnerabilityCode.Vulnerability_Code__c = 98;
        insert eonVulnerabilityCode;
        
        EON_Site_Vulnerability__c siteVul = new EON_Site_Vulnerability__c();
        siteVul.Customer__c = customer2.ID;
        siteVul.Premise__c = eSite2.id;
        siteVul.Vulnerability_Type__c = 'C';
        siteVul.Vulnerability_code__c = eonVulnerabilityCode.ID;
        insert siteVul;  
        
        EON_Campaign__c campaign = EON_CreateTestRecords.createEONCampaign();
        campaign.Campaign_Type__c = 'SME';
        insert campaign;
        String finalStr='MPRN,MPAN,Cust ID,Premise SFID,Cust SFID,Campaign Letter,Smart ,Re-Cert,Opt in / Opt out preference'+'\r\n';
        finalStr+='1111'+','+'2221'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        finalStr+='1112'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        finalStr+=''+','+'2222'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';
        Attachment attachmnt = new Attachment();
        attachmnt.ParentId = campaign.ID;
        attachmnt.Name = 'test.csv';
        attachmnt.ContentType = 'application/vnd.ms-excel';
        attachmnt.Body = Blob.valueOf(finalStr);
        insert attachmnt;
        
        EON_Campaign_Csv__c cCsvv = new EON_Campaign_Csv__c(Name='zensar',Campaign_Letter__c='ALLVU001',Cust_ID__c='sfdc',Cust_SFID__c='cdfs',MPAN__c='sfd12',MPRN__c='redgf45',Opt_in_Opt_out_preference__c='redgf',Premise_SFID__c='sfdxc',Re_Cert__c='redgsf',Smart__c='smart');
        insert cCsvv;             
        
        Attachment attach = [Select ID, Body from Attachment where ParentID=:campaign.Id];
        string body = attach.Body.toString();
        EON_Campaign_Csv__c cCsv = [ Select Name,Campaign_Letter__c,Cust_ID__c,Cust_SFID__c,MPAN__c,MPRN__c,Opt_in_Opt_out_preference__c,Premise_SFID__c,Re_Cert__c,Smart__c From EON_Campaign_Csv__c limit 1 ];
        test.startTest();   
        
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        customer2.Current_Payment_Method_Indicator__c = 'Not OD';
        update customer2;
        
        test.stopTest();
    }
    
    static testmethod void processCampaign2(){
        
        EON_Customer__c customer2 = EON_CreateTestRecords.createEONCustomer();
        customer2.Name = '9988776644';
        customer2.Smart_Interest__c = 'N';
        customer2.Customer_group_type__c = 'RES';
        customer2.Current_Payment_Method_Indicator__c = 'Not OD';
        customer2.Customer_Name__c = 'False-RES-NN';
        customer2.Campaign_Flag__c = true;
        insert customer2;
        
        EON_Site__c eSite2 = EON_CreateTestRecords.createEonSite();
        eSite2.Customer__c = customer2.ID;
        insert eSite2;
        
        EON_Fuel__c eFuelElec2 = EON_CreateTestRecords.createEONFuel();
        eFuelElec2.Premise__c = eSite2.ID;                
        eFuelElec2.MPRN__c = '1111';        
        insert eFuelElec2; 
        
        EON_Campaign__c campaign = EON_CreateTestRecords.createEONCampaign();
        campaign.Campaign_Type__c = 'RES';
        insert campaign;
        String finalStr='MPRN,MPAN,Cust ID,Premise SFID,Cust SFID,Campaign Letter,Smart ,Re-Cert,Opt in / Opt out preference'+'\r\n';
        finalStr+='1111'+','+'2221'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';        
        Attachment attachmnt = new Attachment();
        attachmnt.ParentId = campaign.ID;
        attachmnt.Name = 'test.csv';
        attachmnt.ContentType = 'application/vnd.ms-excel';
        attachmnt.Body = Blob.valueOf(finalStr);
        insert attachmnt;
        
        EON_Campaign_Csv__c cCsvv = new EON_Campaign_Csv__c(Name='zensar',Campaign_Letter__c='ALLVU001',Cust_ID__c='sfdc',Cust_SFID__c='cdfs',MPAN__c='sfd12',MPRN__c='redgf45',Opt_in_Opt_out_preference__c='redgf',Premise_SFID__c='sfdxc',Re_Cert__c='redgsf',Smart__c='smart');
        insert cCsvv;             
        
        Attachment attach = [Select ID, Body from Attachment where ParentID=:campaign.Id];
        string body = attach.Body.toString();
        EON_Campaign_Csv__c cCsv = [ Select Name,Campaign_Letter__c,Cust_ID__c,Cust_SFID__c,MPAN__c,MPRN__c,Opt_in_Opt_out_preference__c,Premise_SFID__c,Re_Cert__c,Smart__c From EON_Campaign_Csv__c limit 1 ];
        test.startTest();   
        
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        customer2.Customer_Name__c = 'False-RES-NN';
        update customer2;
        
        test.stopTest();
    }
    
    static testmethod void processCampaign3(){
        
        EON_Customer__c customer2 = EON_CreateTestRecords.createEONCustomer();
        customer2.Name = '9988776644';
        customer2.Smart_Interest__c = 'N';
        customer2.Customer_group_type__c = 'RES';
        customer2.Current_Payment_Method_Indicator__c = 'Not OD';
        customer2.Customer_Name__c = 'False-RES-NN';
        customer2.Campaign_Flag__c = true;
        insert customer2;
        
        EON_Site__c eSite2 = EON_CreateTestRecords.createEonSite();
        eSite2.Customer__c = customer2.ID;
        insert eSite2;
        
        EON_Fuel__c eFuelElec2 = EON_CreateTestRecords.createEONFuel();
        eFuelElec2.Premise__c = eSite2.ID;                
        eFuelElec2.MPAN__c = '1111';        
        insert eFuelElec2; 
        
        EON_Campaign__c campaign = EON_CreateTestRecords.createEONCampaign();
        campaign.Campaign_Type__c = 'RES';
        insert campaign;
        String finalStr='MPRN,MPAN,Cust ID,Premise SFID,Cust SFID,Campaign Letter,Smart ,Re-Cert,Opt in / Opt out preference'+'\r\n';
        finalStr+=''+','+'1111'+'2221'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';        
        Attachment attachmnt = new Attachment();
        attachmnt.ParentId = campaign.ID;
        attachmnt.Name = 'test.csv';
        attachmnt.ContentType = 'application/vnd.ms-excel';
        attachmnt.Body = Blob.valueOf(finalStr);
        insert attachmnt;
        
        EON_Campaign_Csv__c cCsvv = new EON_Campaign_Csv__c(Name='zensar',Campaign_Letter__c='ALLVU001',Cust_ID__c='sfdc',Cust_SFID__c='cdfs',MPAN__c='sfd12',MPRN__c='redgf45',Opt_in_Opt_out_preference__c='redgf',Premise_SFID__c='sfdxc',Re_Cert__c='redgsf',Smart__c='smart');
        insert cCsvv;             
        
        Attachment attach = [Select ID, Body from Attachment where ParentID=:campaign.Id];
        string body = attach.Body.toString();
        EON_Campaign_Csv__c cCsv = [ Select Name,Campaign_Letter__c,Cust_ID__c,Cust_SFID__c,MPAN__c,MPRN__c,Opt_in_Opt_out_preference__c,Premise_SFID__c,Re_Cert__c,Smart__c From EON_Campaign_Csv__c limit 1 ];
        test.startTest();   
        
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
        customer2.Customer_Name__c = 'False-RES-NN';
        update customer2;
        
        test.stopTest();
    }
    
    static testmethod void GenerateException(){
        EON_Campaign_File_Process.getJobDetails('24347686');
        EON_Customer__c customer2 = EON_CreateTestRecords.createEONCustomer();
        customer2.Name = '9988776644';
        customer2.Smart_Interest__c = 'N';
        customer2.Customer_group_type__c = 'RES';
        customer2.Current_Payment_Method_Indicator__c = 'Not OD';
        customer2.Customer_Name__c = 'False-RES-NN';
        customer2.Campaign_Flag__c = true;
        insert customer2;
        
        EON_Campaign__c campaign = EON_CreateTestRecords.createEONCampaign();
        campaign.Campaign_Type__c = 'RES';
        insert campaign;
        String finalStr='MPRN,MPAN,Cust ID,Premise SFID,Cust SFID,Campaign Letter,Smart ,Re-Cert,Opt in / Opt out preference'+'\r\n';
        finalStr+=''+','+'1111'+'2221'+','+''+','+''+','+''+','+''+','+''+','+''+','+''+'\r\n';        
        Attachment attachmnt = new Attachment();
        attachmnt.ParentId = campaign.ID;
        attachmnt.Name = 'test.csv';
        attachmnt.ContentType = 'application/vnd.ms-excel';
        attachmnt.Body = Blob.valueOf(finalStr);
        insert attachmnt;
        
        EON_Campaign_File_Process_Test.genException = true;
        EON_Campaign_File_Process.ReadandparseCSV(campaign.ID);
    }
}