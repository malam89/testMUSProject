/**
  This test class will cover for below classes
  1. EON_CsvReader 
**/
/*
    Created By : Nitin Bangar
    Created Date : 14/07/2016
    Service Request : SR_EON_PC_067
    Change History :
*/
@isTest(SeeAllData=true)
private with sharing class EON_CsvReader_Test {
  
   public static String data = null,ParserCR = '\r',ParserLF = '\n',ParserCOMMA = String.fromCharArray(new List<Integer> { 44 });  // Placeholder for data to use in testing.
    public static String ParserCRLF = ParserCR + ParserLF;

    /**
     * Test some use cases for reading IETF RFC 4180-compliant CSV values.
     * Move to a separate class
    **/
    public static testMethod void readIETFRFC4180CSVValueTest() {
        
        System.debug(data = ParserCRLF);

         new EON_CsvReader.CSVValue('', false, ParserCRLF)
                .assertEquals(EON_CsvReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '""' + ParserCRLF);
        new EON_CsvReader.CSVValue('', true, ParserCRLF)
                .assertEquals(EON_CsvReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"",asdf' + ParserCRLF);
        new EON_CsvReader.CSVValue('', true, ParserCOMMA)
                .assertEquals(EON_CsvReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = ',asdf' + ParserCRLF);
        new EON_CsvReader.CSVValue('', false, ParserCOMMA)
                .assertEquals(EON_CsvReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"' + ParserCRLF + '",blah' + ParserCRLF);
        new EON_CsvReader.CSVValue(ParserCRLF, true, ParserCOMMA)
                .assertEquals(EON_CsvReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"""marty""","""chang"""' + ParserCRLF);
        new EON_CsvReader.CSVValue('"marty"', true, ParserCOMMA)
                .assertEquals(EON_CsvReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"com""pli""cate' + ParserCRLF + 'd"'
                + ParserCRLF);
        new EON_CsvReader.CSVValue('com"pli"cate' + ParserCRLF + 'd', true, ParserCRLF)
                .assertEquals(EON_CsvReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = 'asdf' + ParserCRLF);
        new EON_CsvReader.CSVValue('asdf', false, ParserCRLF)
                .assertEquals(EON_CsvReader.readIETFRFC4180CSVValue(data));
                
        System.debug(data = 'tester' + ParserCRLF);
        new EON_CsvReader.CSVValue('asdf', false, ParserCRLF)
                .equals(EON_CsvReader.readIETFRFC4180CSVValue(data));
    }
    
        public static testMethod void TestPass() {
        Test.startTest();
                
        EON_CsvReader.CampaignCSV('MPAN,MPRN,Cust ID');
        Test.stopTest();
    }
    
    public static testMethod void TestPass1() {
        Test.startTest();
                
        EON_CsvReader.CampaignCSV('');
        Test.stopTest();
        }
}