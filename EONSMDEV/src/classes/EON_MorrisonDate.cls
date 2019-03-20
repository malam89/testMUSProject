/**
    Description:  This Class is a utility class for calculating date or days excluding holidays and weekends.
    Vf Page : none
    Test Class  :EON_MorrisonDate_Test
**/
/*
    Created By : Tashika Gupta
    Created On : 01/06/2016
    Service Request : SR_EON_AL_016
    Change History : 
    CH01 # SR_EON_AL_026 # 03/08/2016 # Tashika Gupta # Updated the Date logic(Whole class) as per the SR functionality.
*/

public class EON_MorrisonDate{

    /*
        CalculatedFinishDate() : This method calculates the next working date .
    */
    public static Date CalculatedFinishDate(Date startDate, Double duration){
    Integer addedDays = duration.intValue();
    Date currentDay;
    Integer lastDay=0;
    
    Date maxEndDate = startDate + (duration.intValue() * 2);
    maxEndDate = maxEndDate.addMonths(2);
    List<EON_Shutdown_Days__c> ShutdownDaysInRange = [select Holiday_Date__c from EON_Shutdown_Days__c where Holiday_Date__c >=: startDate and Holiday_Date__c < :maxEndDate order by Holiday_Date__c];
   
    Boolean isWeekendDay;
    Boolean isShutdownDay;
    Integer i=0;
    Date shutdownDay = null;
     
    if (!ShutdownDaysInRange.isEmpty()){
        shutdownDay = ShutdownDaysInRange[i].Holiday_Date__c;
    }
    
    Integer intDayOfWeek = DayOfWeek(startDate);
    
    for(Integer x=1;x<=addedDays;x++){
        isShutdownDay = false;
        isWeekendDay = false;
        currentDay = startDate.addDays(x);
        
        if (intDayofWeek==6)
            intDayOfWeek = 0;    
        else
            intDayOfWeek= intDayOfWeek+1;
            
    
           
        if(intDayOfWeek==0||intDayOfWeek==6){
            addedDays++;
            isWeekendDay = true;
        }
        else{
            if(shutdownday!=null){
            if (shutdownday.isSameDay(currentDay)){
                addedDays++;
                isShutdownDay = true;
                i++;
                
                if(i<ShutdownDaysInRange.size()){shutdownDay = ShutdownDaysInRange[i].Holiday_Date__c;}
                else{
                    shutdownDay = null;
                } 
                
            }
                
            }
        }          
    if(!isShutdownDay&&!isWeekendDay){
         lastDay = x;    
        }
    }
    return startDate.addDays(lastDay);
}
    
    /*
        DayOfWeek() : This method calculates the day of the week .
    */
    public static Integer DayOfWeek(Date x){

    Integer dayNoOfWeek;
    Datetime dt = (DateTime)x;
    String dayOfWeekString = dt.format('EEEE');
    Map<String,Integer> dayDayNo = new Map<String,Integer>{'Sunday'=> 0,'Monday'=> 1,'Tuesday'=> 2,'Wednesday'=> 3,'Thursday'=> 4,'Friday'=> 5,'Saturday'=> 6};
    dayNoOfWeek = dayDayNo.get(dayOfWeekString);
    return dayNoOfWeek;
    
    }

}