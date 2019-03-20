/**
    Description:  This Class is a utility class for calculating date or days excluding holidays and weekends.
    Vf Page : none
    Test Class  :NGS_MorrisonDate_Test
**/
/*
    Created By : Tashika Gupta
    Created On : 30/03/2017
    Service Request : SR_OptiMUS_NG_036
    Change History : 
*/
public class NGS_MorrisonDate{

    
    /*
        calculateDayisWeekday() : This method calculates the next working date .
    */
    public static Boolean calculateDayisWeekday(DateTime checkDate ){
        Boolean isWeekday ;
        Date checkDateWeekday = checkDate.Date();
        Integer intDayOfWeek = DayOfWeek(checkDateWeekday);
        if(intDayOfWeek==0 || intDayOfWeek==6)
        isWeekday = false;
        else isWeekday = true;
        return isWeekday;
    
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