/**
    Description : This class is the helper class for EON_Check_Technician_Van_Stock_Scheduler .It includes methods called in main class
    Test Class: EON_Check_Technician_Van_Stock_Schd_Test           
**/
/*
    Created By : Tashika Gupta
    Created Date : 02/06/2016
    Service Request : SR_EON_AL_016
    Change History: 
*/

public class EON_Check_Technician_Van_Stock_Helper{
   public static boolean noMinReser = false;
    /**
   GetReservationNumber(): This method will return a maximum reservation number from Eon Order records.
    **/
   public static long GetReservationNumber(){
    long  Max_Reservation_Number ;
    long ReservationNum = 0;
    List<EON_Order__c> Orderlist = new List<EON_Order__c> ();
    Orderlist =[SELECT id ,Reservation__c FROM EON_Order__c order by Reservation__c Desc NULLS LAST LIMIT 1];
    system.debug('*****orderlist is *******:'+Orderlist);
    if(Orderlist!=null && Orderlist.size()>0){ 
        if(Orderlist[0].Reservation__c!=null && Orderlist[0].Reservation__c !=''){
        ReservationNum = long.valueOf(Orderlist[0].Reservation__c);
        }
        if(ReservationNum !=null && ReservationNum >=long.valueof(system.Label.EON_Order_Reservation_Min_Value )&& ReservationNum <long.valueof(system.Label.EON_Order_Reservation_Max_Value ))
        Max_Reservation_Number = ReservationNum ;
        
        else {
        Max_Reservation_Number = long.valueof(system.Label.EON_Order_Reservation_Min_Value);
        noMinReser = true;
        }
        system.debug('*****Maximun Reservation number is *******:'+Max_Reservation_Number);
        return Max_Reservation_Number;
        }
    else{
        noMinReser = true;
        return long.valueof(system.Label.EON_Order_Reservation_Min_Value);
        
        }
    }
}