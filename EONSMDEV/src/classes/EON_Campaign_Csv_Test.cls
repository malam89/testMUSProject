/**
    Description : This class is used for test coverage for the below classes
    1.EON_Campaign_Csv_Test
**/
    
/*
        Created By : Shruti Moghe
        Created On : 01/07/2016
        Service Req : SR_EON_PC_067
        Change History :
*/
@isTest
private class EON_Campaign_Csv_Test {

    /**
        unitTest1() - unitTest1 Success test case.
    **/
    static testmethod void unitTest(){
        
        EON_Campaign__c camp = new EON_Campaign__c();
        insert camp;
        String finalStr = '';
        finalStr='MPRN,MPAN,Cust ID,Premise SFID,Cust SFID,Campaign Letter,Smart ,Re-Cert,Opt in / Opt out preference'+'\n';
            finalStr+='1234'+','+'2345'+','+'243'+','+''+','+''+','+''+','+''+','+''+','+''+'\n';
            finalStr+='1234'+','+'2345'+','+'243'+','+''+','+''+','+''+','+''+','+''+','+''+'\n';
        Blob csvBlob = Blob.valueOf(finalStr);
        string csvname ='-processed.csv';
        Attachment attProcessed = new Attachment(); 
        attProcessed.ParentId =camp.id;
        attProcessed.ContentType = 'text/csv';
        attProcessed.Name = csvname;
        attProcessed.Body = csvBlob;
        insert attProcessed;
        EON_Campaign_File_Process.ReadandparseCSV(camp.id);
    }
}