/**
    Description : This class is used for utility methods for CEVA Application
**/

/*
    Created by :Shruti Moghe
    Created Date : 19-Aug-2016
    Test Class : EON_Check_Technician_Van_Stock_Schd_Test            
    Change History: 
*/

global with sharing class EON_Ceva_Utility{

 public static boolean noMinReser = false;
 public static boolean byPassTechTrigger = true;

    //Static labels
    
    public static EON_Order__c CreateOrderRecords(EON_Technician__c objTechnician,EON_Product__c ObjProduct, decimal Quantity,String FunctionType,long maxReservation,Date DateRequired) {
       
        EON_Order__c order =new EON_Order__c();
        order.Date_Required__c=(FunctionType!=null && FunctionType.equalsIgnoreCase('BAU'))?DateRequired:objTechnician.Start_Date__c;
        order.Mobile__c= objTechnician.Mobile__c;
        order.Reservation__c=(FunctionType!=null && FunctionType.equalsIgnoreCase('BAU'))?string.valueOf(maxReservation):null;
        order.Order_Date__c=(FunctionType!=null && FunctionType.equalsIgnoreCase('BAU'))? objTechnician.h_BAU_Send_To_CEVA__c:objTechnician.h_Send_to_CEVA__c;
        order.Product_Code__c=ObjProduct.id;
        order.Product_Description__c=ObjProduct.Product_Description__c;
        order.Quantity_Required__c=String.valueof(Quantity);
        order.Technician_Name__c=objTechnician.id;  
        return order;
    }
    
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