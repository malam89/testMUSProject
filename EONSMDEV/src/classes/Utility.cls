/**
    Description : This class is used for utility methods for NGS Application
**/
/*
    Created by : Shruti Moghe
    Created Date : 24/03/2017
    Test Class : Utility_Test
    Change History: 
*/
global with sharing class Utility{
    //Static labels
    public final static String RESULT_PASS = 'PASS';
    public final static String RESULT_FAIL = 'FAIL';
    public final static String DIRECTION_IN = 'In';
    public final static String DIRECTION_OUT = 'Out';
     public static boolean ByPassOFSCUpdate = true;
    //Static variable to genException 
    public static boolean genException { get; set; }
    /**
        validateStringLength(String value) - This method truncates the string if it has more than length of 131070 and if null
    **/
    public static String validateStringLength(String value){
        if(value!= null && value.length() > 131070)
            value = value.subString(0, 131070);
        else if(value== null)
            value=' ';
        return value;
    }
    /**
        validateRequired(String value) - this method is used to verify if the value is blank or not.
    **/
    public static boolean validateRequired(object value){
       if(value != null && value != '')
           return false;
       return true;
    }
     /**
        createAttachment(string parentId, string body, String attachmentMane) - This is a utility method to create attachment record for the respective parent record.
    **/
    public static void createAttachment(string parentId, string attachmentBody, String attachmentMane){
        insert new attachment(parentId = parentId, body = Blob.valueOf(attachmentBody), name=attachmentMane +'.txt');
    }
    
    public static Datetime getNewdatetime(Datetime dt){
      DateTime inputDT = dt;
      Integer YearVal = dt.year();
      Date MarchEndDate = date.newInstance(YearVal, 3, 31);
        Date OctEndDate   =  date.newInstance(YearVal, 10, 31);
        Date StartDate = MarchEndDate.toStartofWeek();
        Date EndDate = OctEndDate.toStartofWeek();
        Datetime DaylightStartDt = datetime.newInstance(StartDate.year(), StartDate.month(), StartDate.day(), 01,00,00);
        Datetime DaylightEndDt = datetime.newInstance(EndDate.year(), EndDate.month(), EndDate.day(), 02,00,00);
        
        // adding an hour if date faling under day light saving.
        if(inputDT>=DaylightStartDt && inputDT<= DaylightEndDt){
          inputDT=inputDT.addhours(-1);
          return inputDT;
        }
         else
         return inputDT;
    }
    
     // method to add an hour in the given datetime.
      public static Datetime getNewdatetimeAdd(Datetime dt){
      DateTime inputDT = dt;
      Integer YearVal = dt.year();
      Date MarchEndDate = date.newInstance(YearVal, 3, 31);
        Date OctEndDate   =  date.newInstance(YearVal, 10, 31);
        Date StartDate = MarchEndDate.toStartofWeek();
        Date EndDate = OctEndDate.toStartofWeek();
        Datetime DaylightStartDt = datetime.newInstance(StartDate.year(), StartDate.month(), StartDate.day(), 01,00,00);
        Datetime DaylightEndDt = datetime.newInstance(EndDate.year(), EndDate.month(), EndDate.day(), 02,00,00);
        
        // adding an hour if date faling under day light saving.
        if(inputDT>=DaylightStartDt && inputDT<= DaylightEndDt){
          inputDT=inputDT.addHours(1);
          return inputDT;
        }
         else
         return inputDT;
         }
}