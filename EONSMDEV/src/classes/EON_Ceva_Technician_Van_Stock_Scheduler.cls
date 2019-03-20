/**
    Description : This class  will Generate and send an email based on the validations for 'Check Technician Van Stock' button .
                  To run the schedular of Van Stock to CEVA daily at 8:00 pm , Run the following code:
                  EON_Check_Technician_Van_Stock_Scheduler schObj = new EON_Check_Technician_Van_Stock_Scheduler();
                  System.schedule('EON_Technician_Van_Stock_Sch', '0 0 20 1/1 * ? *', schObj);
    Test Class: EON_Ceva_Technician_Van_Stock_Schd_Test
**/
/*
    Created By : Tashika Gupta
    Created Date : 04/04/2016
    Service Request : SR_EON_AL_007
    Change History: 
    CH01 # SR_EON_AL_014 # 04/05/2016 # Shruti Moghe # Updated the field name for ByBox Ref to 'ByBox Locker ID' 
    CH02 # SR_EON_AL_016 # 30/05/2016 # Tashika Gupta # Replaced the field name from supplier to manufacturer, updated logics as per SR.
    CH03 # SR_EON_AL_028 # 07/07/2016 # Vinod # Renamed Electric_Credit_Meter_Classic__c to E_Credit_Meter_SR_1R_0393_Classic__c
    CH03 # SR_EON_AL_026 # 08/07/2016 # Vinod # changed Electric_Credit_Meter_Classic_BAU__c to E_Credit_Meter_SR_1R_0393_Classic_BAU__c    
                                                    Electric_Credit_Meter_Classic_VS__c to    E_Credit_Meter_SR_1R_0393_Classic_VS__c
    CH04 # SR_EON_AL_026 # 06/07/2016 #Vinod # Updated the logic as per the SR functionality.
    CH05 # SR_EON_AL_030 # 27/07/2016 # Aruna Manjari # commented out certain condition for SR  functionality  
    CH06 # SR_EON_AL_026 # 03/08/2016 # Tashika Gupta # Updated the Date logic as per the SR functionality.
    CH07 # SR_EON_AL_032 # 19/08/2016 # Shruti Moghe # Updated the code as per SR functionality
    CH08 # 13/09/2016 # Shruti Moghe # Renamed the class from EON_Check_Technician_Van_Stock_Scheduler to EON_Ceva_Technician_Van_Stock_Scheduler 
    CH09 # SR_EON_AL_036 # 18/11/2016 # Shruti Moghe # added new functionality to work for new asset types
    CH10 # INCUK0006034185 #24/07/20147 # Praveen Garikipati # Fixed the nullpointer exception.


*/

global class EON_Ceva_Technician_Van_Stock_Scheduler implements schedulable{
    public static List<EON_Technician__c> lstTechnician = new List<EON_Technician__c>(); //List will hold all Eon Technician Records whose Order needs to be sent to CEVA   
    public static List<EON_Product__c> lstProducts = new List<EON_Product__c>(); //List of EON Products
    public List<EON_Order__c> LstOrdersToInsert= new List<EON_Order__c>(); 
    //public List<Profile_Product__c> profleproduct = new List<Profile_Product__c> //CH11
    //Public List<EON_Stock_Profile__c> eonstockprofile = new List<EON_Stock_Profile__c> //CH11
    
    global void execute(schedulableContext sc){
         EmailToCEVAProcessData();
     }
    /**
     EmailToCEVAProcessData()- This Method will Process the EON Technician Records and Generate the Email that will be sent to CEVA  
    **/
    Public void EmailToCEVAProcessData(){
        integer Count = 0;
        try{
            
            //Map to store List of Products in pair of Asset_Type__c
            map<String,List<EON_Product__c>> MapProducts = new map<String,List<EON_Product__c>>();
            List<EON_Technician__c> LstToUpdateTech = new List<EON_Technician__c>();//CH07
            //List of all EON Technician records where button is clicked today to send order to CEVA
            lstTechnician =[select id,ByBox_Locker_ID__c,BAU_Ship_to_Location__c,Date_left__c, E_Credit_Meter_SR_1R_0393_Classic_VS__c,E_Credit_Meter_SR_1R_0393_Classic__c, Email__c,Gas_Credit_Meter_Classic__c,Gas_Credit_Meter_Classic_BAU__c,Gas_Credit_Meter_Classic_VS__c, h_Eon_Stock__c,h_IsProcessed__c,h_BAU_Order_sent__c,KID__c, Mobile__c,Regulators_Gas__c,Regulators_Gas_BAU__c,Regulators_Gas_VS__c,Smart_Electric_Meter__c,Smart_Electric_Meter_BAU__c,Smart_Electric_Meter_VS__c, Smart_Energy_Display_SED_IHD__c,Smart_Energy_Display_SED_IHD_BAU__c,Smart_Energy_Display_SED_IHD_VS__c,Smart_Gas_Meter__c,Smart_Gas_Meter_BAU__c,Smart_Gas_Meter_VS__c,h_BAU_Send_To_CEVA__c,h_3_Phase_Electric_Meter_date__c,h_Electric_Prepayment_Meter_Classic_date__c,h_Fuses_Electric_date__c,h_Gas_Credit_Meter_Classic_date__c,h_Gas_Prepayment_Meter_Classic_date__c,h_Isolators_Electric_date__c,h_Regulators_Gas_date__c,h_Smart_Electric_Meter_date__c,h_Smart_Energy_Display_SED_IHD_date__c,h_Smart_Gas_Meter_date__c,Technician_Skill__c,E_Credit_Meter_5_Term_0151_Classic__c,h_E_PP_2R_5_Term_No_Key_0151_Classic__c,E_Credit_Meter_5_Term_0151_Classic_BAU__c,E_Credit_Meter_5_Term_0151_Classic_VS__c,h_E_Credit_Meter_5_Term_0151_Classic__c, E_Credit_Meter_4_Term_0151_Classic__c,E_Credit_Meter_4_Term_0151_Classic_BAU__c,E_Credit_Meter_4_Term_0151_Classic_VS__c,h_E_Credit_Meter_4_Term_0151_Classic__c, E_PP_1R_4_Term_with_Key_0393_Classic__c,E_PP_1R_4_Term_with_Key_0393_Classic_BAU__c,E_PP_1R_4_Term_with_Key_0393_Classic_VS__c,h_E_PP_1R_4_Term_with_Key_0393_Classic__c, E_PP_1R_4_Term_No_Key_0393_Classic__c,E_PP_1R_4_Term_No_Key_0393_Classic_BAU__c,E_PP_1R_4_Term_No_Key_0393_Classic_VS__c,h_E_PP_1R_4_Term_No_Key_0393_Classic__c, E_PP_2R_5_Term_with_Key_0151_Classic__c,E_PP_2R_5_Term_with_Key_0151_Classic_BAU__c,E_PP_2R_5_Term_with_Key_0151_Classic_VS__c,h_E_PP_2R_5_Term_with_Key_0151_Classic__c, Smart_Electric_Meter_New_Connections__c,Smart_Electric_Meter_New_Connections_BAU__c,Smart_Electric_Meter_New_Connections_VS__c,h_Smart_Electric_Meter_New_Connections__c, X3_Phase_E_Meter_0151__c,X3_Phase_E_Meter_0151_BAU__c,X3_Phase_E_Meter_0151_VS__c,h_3_Phase_E_Meter_0151__c, X3_Phase_E_Meter_0393__c,X3_Phase_E_Meter_0393_BAU__c,X3_Phase_E_Meter_0393_VS__c,h_3_Phase_E_Meter_0393__c, Gas_Credit_Meter_Semi_Con_Classic__c,Gas_Credit_Meter_Semi_Con_Classic_BAU__c,Gas_Credit_Meter_Semi_Con_Classic_VS__c,h_Gas_Credit_Meter_Semi_Con_Classic__c, Gas_PP_Meter_G4_ETM_Classic__c,Gas_PP_Meter_G4_ETM_Classic_BAU__c,Gas_PP_Meter_G4_ETM_Classic_VS__c,h_Gas_PP_Meter_G4_ETM_Classic__c, Gas_PP_Libre_210_Domestic_Classic__c,Gas_PP_Libre_210_Domestic_Classic_BAU__c,Gas_PP_Libre_210_Domestic_Classic_VS__c,h_Gas_PP_Libre_210_Domestic_Classic__c, Smart_Gas_Meter_Semi_Con__c,Smart_Gas_Meter_Semi_Con_BAU__c,E_PP_2R_5_Term_No_Key_0151_Classic__c,Smart_Gas_Meter_Semi_Con_VS__c,h_Smart_Gas_Meter_Semi_Con__c, E_PP_2R_5_Term_No_Key_0151_Classic_VS__c,h_E_Credit_Meter_SR_1R_0393_Classic__c, Work_Zone__c,Name,Cost_Centre__c,E_Credit_Meter_4_Term_0244_Classic_BAU__c,E_Credit_Meter_4_Term_0244_Classic__c,E_Credit_Meter_4_Term_0244_Classic_VS__c,E_Credit_Meter_4_Term_0935_Classic_BAU__c,E_Credit_Meter_4_Term_0935_Classic__c,E_Credit_Meter_4_Term_0935_Classic_VS__c,E_Credit_Meter_5_Term_0244_Classic_BAU__c,E_Credit_Meter_5_Term_0244_Classic__c,E_Credit_Meter_5_Term_0244_Classic_VS__c,E_Credit_Meter_5_Term_0935_Classic_BAU__c,E_Credit_Meter_5_Term_0935_Classic__c,E_Credit_Meter_5_Term_0935_Classic_VS__c,h_E_Credit_Meter_4_Term_0244_Classic__c,h_E_Credit_Meter_4_Term_0935_Classic__c,h_E_Credit_Meter_5_Term_0244_Classic__c,h_E_Credit_Meter_5_Term_0935_Classic__c,h_Regulators_SC_Gas__c,h_Smart_Gas_Meter_New_Connections__c,Regulators_SC_Gas_BAU__c,Regulators_SC_Gas__c,Regulators_SC_Gas_VS__c,Smart_Gas_Meter_New_Connections_BAU__c,Smart_Gas_Meter_New_Connections__c,Smart_Gas_Meter_New_Connections_VS__c from EON_Technician__c where Date_left__c = null and h_BAU_Order_sent__c = true and h_BAU_Send_To_CEVA__c = TODAY ];//CH02 //CH04 //CH09 added new fields
            system.debug('******Technicians list*******'+lstTechnician);
            system.debug('******Technicians list size*******'+lstTechnician.size());
            //List of all Products where Asset type is populated
            lstProducts= [select id,Name,Asset_Type__c,Product_Description__c,Manufacturer__c from EON_Product__c where Asset_Type__c!=null]; 
            for(EON_Product__c objProduct:lstProducts){             
                if(!MapProducts.containsKey(objProduct.Asset_Type__c))
                    MapProducts.put(objProduct.Asset_Type__c, new List<EON_Product__c>());
                MapProducts.get(objProduct.Asset_Type__c).add(objProduct);                
            }
        if(lstTechnician!=null && lstTechnician.size()>0 ){
        List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); //Email list of All emails to be sent to CEVA
        List<EON_Order__c> LstOrdersToInsert= new List<EON_Order__c>(); 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String sendTo = '';
        sendTo= System.Label.EON_Ceva_BAU_Trigger_Order_Email;
        if(sendTo!=null)
        mail.setToAddresses(sendTo.split(';'));
        mail.setSubject('EON MORRISONS ORDERS');
        String body = '<font style="font-family:arial;font-size:12px;"><b>Date of Order: '+system.today().format()+'</b><br/>';
        body+='<br/>';       
        //CH02.start
        string header = 'Reservation,Date,Locker,KID,Name,Cost Centre,Material,Description,Quantity\n';      
        string finalstr = header ;
        long maxReser = EON_Ceva_Utility.GetReservationNumber();
        boolean check = EON_Ceva_Utility.noMinReser;
        system.debug('******boolean value :******'+check);
        system.debug('******max reservation number till now :******'+maxReser);
        //CH02.End
        for(EON_Technician__c objTechnician:lstTechnician)
        {
            //CH02.start
            if(maxReser==9600000000L && check==true){
            maxReser = maxReser;
            check = false;
            }
            else
            maxReser = maxReser + 1;
            system.debug('******max reservation number now :******'+maxReser);
            //CH02.End
            Date DateRequired= EON_MorrisonDate.CalculatedFinishDate(objTechnician.h_BAU_Send_To_CEVA__c,02);//CH07
            if(lstProducts!=null && lstProducts.size()>0 &&(objTechnician.Gas_Credit_Meter_Classic_VS__c > 0 || objTechnician.Regulators_Gas_VS__c > 0 || objTechnician.Smart_Electric_Meter_VS__c > 0 || objTechnician.Smart_Electric_Meter_VS__c > 0 || objTechnician.Smart_Energy_Display_SED_IHD_VS__c > 0|| objTechnician.Smart_Gas_Meter_VS__c > 0 || objTechnician.E_Credit_Meter_SR_1R_0393_Classic_VS__c > 0 || objTechnician.E_Credit_Meter_5_Term_0151_Classic_VS__c > 0 || objTechnician.E_Credit_Meter_4_Term_0151_Classic_VS__c > 0 || objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c > 0 || objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c > 0 || objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c > 0 || objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c > 0 || objTechnician.Smart_Electric_Meter_New_Connections_VS__c  > 0 || objTechnician.X3_Phase_E_Meter_0151_VS__c > 0 || objTechnician.X3_Phase_E_Meter_0393_VS__c > 0 || objTechnician.Gas_Credit_Meter_Semi_Con_Classic_VS__c > 0 || objTechnician.Gas_PP_Meter_G4_ETM_Classic_VS__c > 0 || objTechnician.Gas_PP_Libre_210_Domestic_Classic_VS__c> 0 || objTechnician.Smart_Gas_Meter_Semi_Con_VS__c > 0 || objTechnician.Regulators_SC_Gas_VS__c>0 || objTechnician.E_Credit_Meter_4_Term_0244_Classic_VS__c>0 || objTechnician.E_Credit_Meter_4_Term_0935_Classic_VS__c>0 || objTechnician.E_Credit_Meter_5_Term_0244_Classic_VS__c>0 || objTechnician.E_Credit_Meter_5_Term_0935_Classic_VS__c>0 || objTechnician.Smart_Gas_Meter_New_Connections_VS__c>0 )){//CH09 added new fields
                system.debug('*********Van Stocks not null**********');                  
                    system.debug('*********Assets Date field populated**********');
                    //CH07.start
                    try{
                        if(EON_Ceva_Technician_Van_Stock_Schd_Test.genException == null)
                            EON_Ceva_Technician_Van_Stock_Schd_Test.genException = false;
                        if(EON_Ceva_Technician_Van_Stock_Schd_Test.genException)
                            ID test = ID.valueOf('test');  //Generate Exception
                        //when Gas_Credit_Meter_Classic_VS__c(Van Stock) is less then Gas_Credit_Meter_Classic_BAU__c(BAU Trigger)
                        if(objTechnician.Gas_Credit_Meter_Classic_VS__c > 0 && 
                            objTechnician.Gas_Credit_Meter_Classic__c != null && objTechnician.Gas_Credit_Meter_Classic_VS__c!= null && //CH10
                        (objTechnician.Gas_Credit_Meter_Classic__c - objTechnician.Gas_Credit_Meter_Classic_VS__c) > 0 &&(objTechnician.h_Gas_Credit_Meter_Classic_date__c==null || objTechnician.h_Gas_Credit_Meter_Classic_date__c==System.today()) && MapProducts.get('Gas Credit Meter (Classic)')!=null && MapProducts.get('Gas Credit Meter (Classic)').size()>0){                       
                            //EON order is created per Quantity Field value populated                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Gas Credit Meter (Classic)')[0],(objTechnician.Gas_Credit_Meter_Classic__c-objTechnician.Gas_Credit_Meter_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Gas Credit Meter (Classic)')[0].Name+'","'+MapProducts.get('Gas Credit Meter (Classic)')[0].Product_Description__c+'","'+(objTechnician.Gas_Credit_Meter_Classic__c-objTechnician.Gas_Credit_Meter_Classic_VS__c)+'"\n';//CH02
                            if(objTechnician.h_Gas_Credit_Meter_Classic_date__c==null) objTechnician.h_Gas_Credit_Meter_Classic_date__c=system.today();
                        }
                        //when Regulators_Gas_VS__c(Van Stock) is less then Regulators_Gas_BAU__c(BAU Trigger)
                        if(objTechnician.Regulators_Gas_VS__c > 0 &&
                            (objTechnician.h_Regulators_Gas_date__c==null || objTechnician.h_Regulators_Gas_date__c==System.today()) &&
                            objTechnician.Regulators_Gas__c != null && objTechnician.Regulators_Gas_VS__c!= null  //CH10
                            && (objTechnician.Regulators_Gas__c-objTechnician.Regulators_Gas_VS__c)> 0 && MapProducts.get('Regulators (Gas)')!=null && MapProducts.get('Regulators (Gas)').size()>0){                                                     
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Regulators (Gas)')[0],(objTechnician.Regulators_Gas__c-objTechnician.Regulators_Gas_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Regulators (Gas)')[0].Name+'","'+MapProducts.get('Regulators (Gas)')[0].Product_Description__c+'","'+(objTechnician.Regulators_Gas__c-objTechnician.Regulators_Gas_VS__c)+'"\n';//CH02
                            if(objTechnician.h_Regulators_Gas_date__c ==null) objTechnician.h_Regulators_Gas_date__c =system.today();
                            
                        }
                        //when Smart_Electric_Meter_VS__c(Van Stock) is less then Smart_Electric_Meter_BAU__c(BAU Trigger)
                        if(objTechnician.Smart_Electric_Meter_VS__c > 0 && (objTechnician.h_Smart_Electric_Meter_date__c==null || objTechnician.h_Smart_Electric_Meter_date__c==System.today()) && 
                        objTechnician.Smart_Electric_Meter__c!= null && objTechnician.Smart_Electric_Meter_VS__c!= null && //CH10
                        
                        (objTechnician.Smart_Electric_Meter__c-objTechnician.Smart_Electric_Meter_VS__c) > 0 && MapProducts.get('Smart Electric Meter')!=null && MapProducts.get('Smart Electric Meter').size()>0){                           
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Electric Meter')[0],(objTechnician.Smart_Electric_Meter__c-objTechnician.Smart_Electric_Meter_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Smart Electric Meter')[0].Name+'","'+MapProducts.get('Smart Electric Meter')[0].Product_Description__c+'","'+(objTechnician.Smart_Electric_Meter__c-objTechnician.Smart_Electric_Meter_VS__c)+'"\n';//CH02
                            if(objTechnician.h_Smart_Electric_Meter_date__c  ==null) objTechnician.h_Smart_Electric_Meter_date__c  =system.today();
                        }
                        //when Smart_Energy_Display_SED_IHD_VS__c(Van Stock) is less then Smart_Energy_Display_SED_IHD_BAU__c(BAU Trigger)
                        if(objTechnician.Smart_Energy_Display_SED_IHD_VS__c > 0 &&  
                        (objTechnician.h_Smart_Energy_Display_SED_IHD_date__c==null || objTechnician.h_Smart_Energy_Display_SED_IHD_date__c==System.today()) && 
                        objTechnician.Smart_Energy_Display_SED_IHD__c != null && objTechnician.Smart_Energy_Display_SED_IHD_VS__c!= null && //CH10
                        
                        (objTechnician.Smart_Energy_Display_SED_IHD__c-objTechnician.Smart_Energy_Display_SED_IHD_VS__c) > 0 && MapProducts.get('Smart Energy Display (SED / IHD)')!=null && MapProducts.get('Smart Energy Display (SED / IHD)').size()>0){                          
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Energy Display (SED / IHD)')[0],(objTechnician.Smart_Energy_Display_SED_IHD__c-objTechnician.Smart_Energy_Display_SED_IHD_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Smart Energy Display (SED / IHD)')[0].Name+'","'+MapProducts.get('Smart Energy Display (SED / IHD)')[0].Product_Description__c+'","'+(objTechnician.Smart_Energy_Display_SED_IHD__c-objTechnician.Smart_Energy_Display_SED_IHD_VS__c)+'"\n';//CH02
                            if(objTechnician.h_Smart_Energy_Display_SED_IHD_date__c ==null) objTechnician.h_Smart_Energy_Display_SED_IHD_date__c =system.today();
                        }
                        //when Smart_Gas_Meter_VS__c(Van Stock) is less then Smart_Gas_Meter_BAU__c(BAU Trigger)
                     if(objTechnician.Smart_Gas_Meter_VS__c > 0 && (objTechnician.h_Smart_Gas_Meter_date__c==null || objTechnician.h_Smart_Gas_Meter_date__c==System.today()) &&  
                     objTechnician.Smart_Gas_Meter__c != null && objTechnician.Smart_Gas_Meter_VS__c != null && //CH10
                     (objTechnician.Smart_Gas_Meter__c-objTechnician.Smart_Gas_Meter_VS__c) > 0 && MapProducts.get('Smart Gas Meter')!=null && MapProducts.get('Smart Gas Meter').size()>0){
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Gas Meter')[0],(objTechnician.Smart_Gas_Meter__c-objTechnician.Smart_Gas_Meter_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr +='"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Smart Gas Meter')[0].Name+'","'+MapProducts.get('Smart Gas Meter')[0].Product_Description__c+'","'+(objTechnician.Smart_Gas_Meter__c-objTechnician.Smart_Gas_Meter_VS__c)+'"\n';/*CH02*/
                            if(objTechnician.h_Smart_Gas_Meter_date__c ==null) objTechnician.h_Smart_Gas_Meter_date__c =system.today();
                    }
                    //when E_Credit_Meter_SR_1R_0393_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
                     if(objTechnician.E_Credit_Meter_SR_1R_0393_Classic_VS__c > 0 && (objTechnician.h_E_Credit_Meter_SR_1R_0393_Classic__c==null || objTechnician.h_E_Credit_Meter_SR_1R_0393_Classic__c==System.today()) && 
                     objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c!= null && objTechnician.E_Credit_Meter_SR_1R_0393_Classic_VS__c!= null && //CH10
                     (objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c-objTechnician.E_Credit_Meter_SR_1R_0393_Classic_VS__c)> 0 && MapProducts.get('E Credit Meter SR 1R 0393 (Classic)')!=null && MapProducts.get('E Credit Meter SR 1R 0393 (Classic)').size()>0){                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter SR 1R 0393 (Classic)')[0],(objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c-objTechnician.E_Credit_Meter_SR_1R_0393_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E Credit Meter SR 1R 0393 (Classic)')[0].Name+'","'+MapProducts.get('E Credit Meter SR 1R 0393 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c-objTechnician.E_Credit_Meter_SR_1R_0393_Classic_VS__c)+'"\n';
                            if(objTechnician.h_E_Credit_Meter_SR_1R_0393_Classic__c  ==null) objTechnician.h_E_Credit_Meter_SR_1R_0393_Classic__c  =system.today();
                        }
                    //when E_Credit_Meter_5_Term_0151_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.E_Credit_Meter_5_Term_0151_Classic_VS__c > 0 && (objTechnician.h_E_Credit_Meter_5_Term_0151_Classic__c==null || objTechnician.h_E_Credit_Meter_5_Term_0151_Classic__c==System.today()) && 
                        objTechnician.E_Credit_Meter_5_Term_0151_Classic__c != null && objTechnician.E_Credit_Meter_5_Term_0151_Classic_VS__c!= null && //CH10
                        (objTechnician.E_Credit_Meter_5_Term_0151_Classic__c-objTechnician.E_Credit_Meter_5_Term_0151_Classic_VS__c) > 0 && MapProducts.get('E Credit Meter 5 Term 0151 (Classic)')!=null && MapProducts.get('E Credit Meter 5 Term 0151 (Classic)').size()>0){
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter 5 Term 0151 (Classic)')[0],(objTechnician.E_Credit_Meter_5_Term_0151_Classic__c-objTechnician.E_Credit_Meter_5_Term_0151_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E Credit Meter 5 Term 0151 (Classic)')[0].Name+'","'+MapProducts.get('E Credit Meter 5 Term 0151 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_Credit_Meter_5_Term_0151_Classic__c-objTechnician.E_Credit_Meter_5_Term_0151_Classic_VS__c)+'"\n';
                            if(objTechnician.h_E_Credit_Meter_5_Term_0151_Classic__c ==null) objTechnician.h_E_Credit_Meter_5_Term_0151_Classic__c =system.today();
                        }
                        
                        //when E_Credit_Meter_4_Term_0151_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.E_Credit_Meter_4_Term_0151_Classic_VS__c > 0 && (objTechnician.h_E_Credit_Meter_4_Term_0151_Classic__c==null || objTechnician.h_E_Credit_Meter_4_Term_0151_Classic__c==System.today()) && 
                        objTechnician.E_Credit_Meter_4_Term_0151_Classic__c != null && objTechnician.E_Credit_Meter_4_Term_0151_Classic_VS__c!= null && //CH10
                        (objTechnician.E_Credit_Meter_4_Term_0151_Classic__c-objTechnician.E_Credit_Meter_4_Term_0151_Classic_VS__c)>0 && MapProducts.get('E Credit Meter 4 Term 0151 (Classic)')!=null && MapProducts.get('E Credit Meter 4 Term 0151 (Classic)').size()>0){
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter 4 Term 0151 (Classic)')[0],(objTechnician.E_Credit_Meter_4_Term_0151_Classic__c-objTechnician.E_Credit_Meter_4_Term_0151_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E Credit Meter 4 Term 0151 (Classic)')[0].Name+'","'+MapProducts.get('E Credit Meter 4 Term 0151 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_Credit_Meter_4_Term_0151_Classic__c-objTechnician.E_Credit_Meter_4_Term_0151_Classic_VS__c)+'"\n';
                            if(objTechnician.h_E_Credit_Meter_4_Term_0151_Classic__c ==null) objTechnician.h_E_Credit_Meter_4_Term_0151_Classic__c =system.today();
                        }
                        
                        //when E_PP_1R_4_Term_with_Key_0393_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c > 0 && (objTechnician.h_E_PP_1R_4_Term_with_Key_0393_Classic__c==null || objTechnician.h_E_PP_1R_4_Term_with_Key_0393_Classic__c==System.today()) && 
                        objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic__c!= null && objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c!= null && //CH10
                        (objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic__c-objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c) >0 && MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)')!=null && MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)').size()>0){
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)')[0],(objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic__c-objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)')[0].Name+'","'+MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic__c-objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic_VS__c)+'"\n';
                            if(objTechnician.h_E_PP_1R_4_Term_with_Key_0393_Classic__c ==null) objTechnician.h_E_PP_1R_4_Term_with_Key_0393_Classic__c =system.today();
                        }
                        
                        //when E_PP_1R_4_Term_No_Key_0393_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c > 0 && (objTechnician.h_E_PP_1R_4_Term_No_Key_0393_Classic__c==null || objTechnician.h_E_PP_1R_4_Term_No_Key_0393_Classic__c==System.today()) && 
                        objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic__c!= null && objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c!= null && //CH10
                        (objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic__c-objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c)>0 && MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)')!=null && MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)').size()>0){
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)')[0],(objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic__c-objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)')[0].Name+'","'+MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic__c-objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic_VS__c)+'"\n';
                            if(objTechnician.h_E_PP_1R_4_Term_No_Key_0393_Classic__c ==null) objTechnician.h_E_PP_1R_4_Term_No_Key_0393_Classic__c =system.today();
                        }
                        
                        //when E_PP_2R_5_Term_with_Key_0151_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c > 0 && (objTechnician.h_E_PP_2R_5_Term_with_Key_0151_Classic__c==null || objTechnician.h_E_PP_2R_5_Term_with_Key_0151_Classic__c==System.today()) &&  
                        objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic__c!= null && objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c!= null && //CH10
                        (objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic__c-objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c)>0  && MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)')!=null && MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)').size()>0){
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)')[0],(objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic__c-objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)')[0].Name+'","'+MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic__c-objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic_VS__c)+'"\n';
                            if(objTechnician.h_E_PP_2R_5_Term_with_Key_0151_Classic__c ==null)  objTechnician.h_E_PP_2R_5_Term_with_Key_0151_Classic__c =system.today();
                        }
                        
                        //when E_PP_2R_5_Term_No_Key_0151_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c > 0 && (objTechnician.h_E_PP_2R_5_Term_No_Key_0151_Classic__c==null || objTechnician.h_E_PP_2R_5_Term_No_Key_0151_Classic__c==System.today()) && 
                        objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic__c!= null && objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c!= null && //CH10
                         (objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic__c-objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c) >0 && MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)')!=null && MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)').size()>0){                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)')[0],(objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic__c-objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)')[0].Name+'","'+MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic__c-objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic_VS__c)+'"\n';
                            if(objTechnician.h_E_PP_2R_5_Term_No_Key_0151_Classic__c ==null) objTechnician.h_E_PP_2R_5_Term_No_Key_0151_Classic__c=system.today();
                        }
                        
                         
                        
                         //when Smart_Electric_Meter_New_Connections_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.Smart_Electric_Meter_New_Connections_VS__c > 0 && (objTechnician.h_Smart_Electric_Meter_New_Connections__c==null || objTechnician.h_Smart_Electric_Meter_New_Connections__c==System.today()) && 
                        objTechnician.Smart_Electric_Meter_New_Connections__c!= null && objTechnician.Smart_Electric_Meter_New_Connections_VS__c!= null && //CH10
                        (objTechnician.Smart_Electric_Meter_New_Connections__c-objTechnician.Smart_Electric_Meter_New_Connections_VS__c) >0 && MapProducts.get('Smart Electric Meter (New Connections)')!=null && MapProducts.get('Smart Electric Meter (New Connections)').size()>0){
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Electric Meter (New Connections)')[0],(objTechnician.Smart_Electric_Meter_New_Connections__c-objTechnician.Smart_Electric_Meter_New_Connections_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Smart Electric Meter (New Connections)')[0].Name+'","'+MapProducts.get('Smart Electric Meter (New Connections)')[0].Product_Description__c+'","'+(objTechnician.Smart_Electric_Meter_New_Connections__c-objTechnician.Smart_Electric_Meter_New_Connections_VS__c)+'"\n';
                            if(objTechnician.h_Smart_Electric_Meter_New_Connections__c ==null)  objTechnician.h_Smart_Electric_Meter_New_Connections__c  =system.today();
                        }
                         //when X3_Phase_E_Meter_0151_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.X3_Phase_E_Meter_0151_VS__c > 0 && (objTechnician.h_3_Phase_E_Meter_0151__c==null || objTechnician.h_3_Phase_E_Meter_0151__c==System.today()) && 
                        objTechnician.X3_Phase_E_Meter_0151__c!= null && objTechnician.X3_Phase_E_Meter_0151_VS__c!= null && //CH10
                        (objTechnician.X3_Phase_E_Meter_0151__c-objTechnician.X3_Phase_E_Meter_0151_VS__c) >0 && MapProducts.get('3 Phase E Meter 0151')!=null && MapProducts.get('3 Phase E Meter 0151').size()>0){                          
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('3 Phase E Meter 0151')[0],(objTechnician.X3_Phase_E_Meter_0151__c-objTechnician.X3_Phase_E_Meter_0151_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('3 Phase E Meter 0151')[0].Name+'","'+MapProducts.get('3 Phase E Meter 0151')[0].Product_Description__c+'","'+(objTechnician.X3_Phase_E_Meter_0151__c-objTechnician.X3_Phase_E_Meter_0151_VS__c)+'"\n';
                            if(objTechnician.h_3_Phase_E_Meter_0151__c ==null)  objTechnician.h_3_Phase_E_Meter_0151__c  =system.today();
                        }
                        
                         //when X3_Phase_E_Meter_0393_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.X3_Phase_E_Meter_0393_VS__c > 0 && (objTechnician.h_3_Phase_E_Meter_0393__c==null || objTechnician.h_3_Phase_E_Meter_0393__c==System.today()) && 
                        objTechnician.X3_Phase_E_Meter_0393__c!= null && objTechnician.X3_Phase_E_Meter_0393_VS__c!= null && //CH10
                        (objTechnician.X3_Phase_E_Meter_0393__c-objTechnician.X3_Phase_E_Meter_0393_VS__c) >0 && MapProducts.get('3 Phase E Meter 0393')!=null && MapProducts.get('3 Phase E Meter 0393').size()>0){                          
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('3 Phase E Meter 0393')[0],(objTechnician.X3_Phase_E_Meter_0393__c-objTechnician.X3_Phase_E_Meter_0393_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('3 Phase E Meter 0393')[0].Name+'","'+MapProducts.get('3 Phase E Meter 0393')[0].Product_Description__c+'","'+(objTechnician.X3_Phase_E_Meter_0393__c-objTechnician.X3_Phase_E_Meter_0393_VS__c)+'"\n';
                            if(objTechnician.h_3_Phase_E_Meter_0393__c  ==null) objTechnician.h_3_Phase_E_Meter_0393__c  =system.today();
                        }
                         //when Gas_Credit_Meter_Semi_Con_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.Gas_Credit_Meter_Semi_Con_Classic_VS__c > 0 && (objTechnician.h_Gas_Credit_Meter_Semi_Con_Classic__c==null || objTechnician.h_Gas_Credit_Meter_Semi_Con_Classic__c==System.today()) && 
                        objTechnician.Gas_Credit_Meter_Semi_Con_Classic__c!= null && objTechnician.Gas_Credit_Meter_Semi_Con_Classic_VS__c!= null && //CH10
                        (objTechnician.Gas_Credit_Meter_Semi_Con_Classic__c-objTechnician.Gas_Credit_Meter_Semi_Con_Classic_VS__c)>0 && MapProducts.get('Gas Credit Meter Semi Con (Classic)')!=null && MapProducts.get('Gas Credit Meter Semi Con (Classic)').size()>0){                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Gas Credit Meter Semi Con (Classic)')[0],(objTechnician.Gas_Credit_Meter_Semi_Con_Classic__c-objTechnician.Gas_Credit_Meter_Semi_Con_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Gas Credit Meter Semi Con (Classic)')[0].Name+'","'+MapProducts.get('Gas Credit Meter Semi Con (Classic)')[0].Product_Description__c+'","'+(objTechnician.Gas_Credit_Meter_Semi_Con_Classic__c-objTechnician.Gas_Credit_Meter_Semi_Con_Classic_VS__c)+'"\n';
                            if(objTechnician.h_Gas_Credit_Meter_Semi_Con_Classic__c  ==null) objTechnician.h_Gas_Credit_Meter_Semi_Con_Classic__c  =system.today();
                        }
                        
                         //when Gas_PP_Meter_G4_ETM_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.Gas_PP_Meter_G4_ETM_Classic_VS__c > 0 && (objTechnician.h_Gas_PP_Meter_G4_ETM_Classic__c==null || objTechnician.h_Gas_PP_Meter_G4_ETM_Classic__c==System.today()) && 
                        objTechnician.Gas_PP_Meter_G4_ETM_Classic__c!= null && objTechnician.Gas_PP_Meter_G4_ETM_Classic_VS__c!= null && //CH10
                        (objTechnician.Gas_PP_Meter_G4_ETM_Classic__c-objTechnician.Gas_PP_Meter_G4_ETM_Classic_VS__c) >0 && MapProducts.get('Gas PP Meter G4 ETM (Classic)')!=null && MapProducts.get('Gas PP Meter G4 ETM (Classic)').size()>0){                           
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Gas PP Meter G4 ETM (Classic)')[0],(objTechnician.Gas_PP_Meter_G4_ETM_Classic__c-objTechnician.Gas_PP_Meter_G4_ETM_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Gas PP Meter G4 ETM (Classic)')[0].Name+'","'+MapProducts.get('Gas PP Meter G4 ETM (Classic)')[0].Product_Description__c+'","'+(objTechnician.Gas_PP_Meter_G4_ETM_Classic__c-objTechnician.Gas_PP_Meter_G4_ETM_Classic_VS__c)+'"\n';
                            if(objTechnician.h_Gas_PP_Meter_G4_ETM_Classic__c  ==null) objTechnician.h_Gas_PP_Meter_G4_ETM_Classic__c  =system.today();
                        }
                         //when Gas_PP_Libre_210_Domestic_Classic_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.Gas_PP_Libre_210_Domestic_Classic_VS__c > 0 && (objTechnician.h_Gas_PP_Libre_210_Domestic_Classic__c==null || objTechnician.h_Gas_PP_Libre_210_Domestic_Classic__c==System.today()) && 
                        objTechnician.Gas_PP_Libre_210_Domestic_Classic__c!= null && objTechnician.Gas_PP_Libre_210_Domestic_Classic_VS__c!= null && //CH10
                        (objTechnician.Gas_PP_Libre_210_Domestic_Classic__c-objTechnician.Gas_PP_Libre_210_Domestic_Classic_VS__c)>0 && MapProducts.get('Gas PP Libre 210 Domestic (Classic)')!=null && MapProducts.get('Gas PP Libre 210 Domestic (Classic)').size()>0){                          
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Gas PP Libre 210 Domestic (Classic)')[0],(objTechnician.Gas_PP_Libre_210_Domestic_Classic__c-objTechnician.Gas_PP_Libre_210_Domestic_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Gas PP Libre 210 Domestic (Classic)')[0].Name+'","'+MapProducts.get('Gas PP Libre 210 Domestic (Classic)')[0].Product_Description__c+'","'+(objTechnician.Gas_PP_Libre_210_Domestic_Classic__c-objTechnician.Gas_PP_Libre_210_Domestic_Classic_VS__c)+'"\n';
                            if(objTechnician.h_Gas_PP_Libre_210_Domestic_Classic__c  ==null)  objTechnician.h_Gas_PP_Libre_210_Domestic_Classic__c  =system.today();
                        }
                         //when Smart_Gas_Meter_Semi_Con_VS__c in Van Initial Stock / Max Van Stock Levels) is greater than zero
 
                        if(objTechnician.Smart_Gas_Meter_Semi_Con_VS__c > 0 && (objTechnician.h_Smart_Gas_Meter_Semi_Con__c==null || objTechnician.h_Smart_Gas_Meter_Semi_Con__c==System.today()) && 
                        objTechnician.Smart_Gas_Meter_Semi_Con__c!= null && objTechnician.Smart_Gas_Meter_Semi_Con_VS__c!= null && //CH10
                        (objTechnician.Smart_Gas_Meter_Semi_Con__c-objTechnician.Smart_Gas_Meter_Semi_Con_VS__c)>0  && MapProducts.get('Smart Gas Meter Semi Con')!=null && MapProducts.get('Smart Gas Meter Semi Con').size()>0){                       
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Gas Meter Semi Con')[0],(objTechnician.Smart_Gas_Meter_Semi_Con__c-objTechnician.Smart_Gas_Meter_Semi_Con_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Smart Gas Meter Semi Con')[0].Name+'","'+MapProducts.get('Smart Gas Meter Semi Con')[0].Product_Description__c+'","'+(objTechnician.Smart_Gas_Meter_Semi_Con__c-objTechnician.Smart_Gas_Meter_Semi_Con_VS__c)+'"\n';
                            if(objTechnician.h_Smart_Gas_Meter_Semi_Con__c  ==null)  objTechnician.h_Smart_Gas_Meter_Semi_Con__c  =system.today();
                        }                        
                    //CH04.End
                    //CH09.start
                        //when E_Credit_Meter_4_Term_0244_Classic_VS__c(Van Stock) is less then E_Credit_Meter_4_Term_0244_Classic_BAU__c(BAU Trigger)
                        if(objTechnician.E_Credit_Meter_4_Term_0244_Classic_VS__c > 0 && 
                        objTechnician.E_Credit_Meter_4_Term_0244_Classic__c != null && objTechnician.E_Credit_Meter_4_Term_0244_Classic_VS__c!= null && //CH10
                        (objTechnician.E_Credit_Meter_4_Term_0244_Classic__c - objTechnician.E_Credit_Meter_4_Term_0244_Classic_VS__c) > 0 &&(objTechnician.h_E_Credit_Meter_4_Term_0244_Classic__c==null || objTechnician.h_E_Credit_Meter_4_Term_0244_Classic__c==System.today()) && MapProducts.get('E Credit Meter 4 Term 0244 (Classic)')!=null && MapProducts.get('E Credit Meter 4 Term 0244 (Classic)').size()>0){                       
                            //EON order is created per Quantity Field value populated                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter 4 Term 0244 (Classic)')[0],(objTechnician.E_Credit_Meter_4_Term_0244_Classic__c-objTechnician.E_Credit_Meter_4_Term_0244_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E Credit Meter 4 Term 0244 (Classic)')[0].Name+'","'+MapProducts.get('E Credit Meter 4 Term 0244 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_Credit_Meter_4_Term_0244_Classic__c-objTechnician.E_Credit_Meter_4_Term_0244_Classic_VS__c)+'"\n';//CH02
                            if(objTechnician.h_E_Credit_Meter_4_Term_0244_Classic__c==null) objTechnician.h_E_Credit_Meter_4_Term_0244_Classic__c=system.today();
                        }
                        //when E_Credit_Meter_4_Term_0935_Classic_VS__c(Van Stock) is less then E_Credit_Meter_4_Term_0935_Classic_BAU__c(BAU Trigger)
                        if(objTechnician.E_Credit_Meter_4_Term_0935_Classic_VS__c > 0 && 
                        objTechnician.E_Credit_Meter_4_Term_0935_Classic__c != null && objTechnician.E_Credit_Meter_4_Term_0935_Classic_VS__c!= null && //CH10
                        (objTechnician.E_Credit_Meter_4_Term_0935_Classic__c - objTechnician.E_Credit_Meter_4_Term_0935_Classic_VS__c) > 0 &&(objTechnician.h_E_Credit_Meter_4_Term_0935_Classic__c==null || objTechnician.h_E_Credit_Meter_4_Term_0935_Classic__c==System.today()) && MapProducts.get('E Credit Meter 4 Term 0935 (Classic)')!=null && MapProducts.get('E Credit Meter 4 Term 0935 (Classic)').size()>0){                       
                            //EON order is created per Quantity Field value populated                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter 4 Term 0935 (Classic)')[0],(objTechnician.E_Credit_Meter_4_Term_0935_Classic__c-objTechnician.E_Credit_Meter_4_Term_0935_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E Credit Meter 4 Term 0935 (Classic)')[0].Name+'","'+MapProducts.get('E Credit Meter 4 Term 0935 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_Credit_Meter_4_Term_0935_Classic__c-objTechnician.E_Credit_Meter_4_Term_0935_Classic_VS__c)+'"\n';//CH02
                            if(objTechnician.h_E_Credit_Meter_4_Term_0935_Classic__c==null) objTechnician.h_E_Credit_Meter_4_Term_0935_Classic__c=system.today();
                        }
                        //when E_Credit_Meter_5_Term_0244_Classic_VS__c(Van Stock) is less then E_Credit_Meter_5_Term_0244_Classic_BAU__c(BAU Trigger)
                        if(objTechnician.E_Credit_Meter_5_Term_0244_Classic_VS__c > 0 && 
                        objTechnician.E_Credit_Meter_5_Term_0244_Classic__c != null && objTechnician.E_Credit_Meter_5_Term_0244_Classic_VS__c!= null && //CH10
                        (objTechnician.E_Credit_Meter_5_Term_0244_Classic__c - objTechnician.E_Credit_Meter_5_Term_0244_Classic_VS__c) > 0 &&(objTechnician.h_E_Credit_Meter_5_Term_0244_Classic__c==null || objTechnician.h_E_Credit_Meter_5_Term_0244_Classic__c==System.today()) && MapProducts.get('E Credit Meter 5 Term 0244 (Classic)')!=null && MapProducts.get('E Credit Meter 5 Term 0244 (Classic)').size()>0){                       
                            //EON order is created per Quantity Field value populated                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter 5 Term 0244 (Classic)')[0],(objTechnician.E_Credit_Meter_5_Term_0244_Classic__c-objTechnician.E_Credit_Meter_5_Term_0244_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E Credit Meter 5 Term 0244 (Classic)')[0].Name+'","'+MapProducts.get('E Credit Meter 5 Term 0244 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_Credit_Meter_5_Term_0244_Classic__c-objTechnician.E_Credit_Meter_5_Term_0244_Classic_VS__c)+'"\n';//CH02
                            if(objTechnician.h_E_Credit_Meter_5_Term_0244_Classic__c==null) objTechnician.h_E_Credit_Meter_5_Term_0244_Classic__c=system.today();
                        }
                        //when E_Credit_Meter_5_Term_0935_Classic_VS__c(Van Stock) is less then E_Credit_Meter_5_Term_0244_Classic_BAU__c(BAU Trigger)
                        if(objTechnician.E_Credit_Meter_5_Term_0935_Classic_VS__c > 0 && 
                        objTechnician.E_Credit_Meter_5_Term_0935_Classic__c != null && objTechnician.E_Credit_Meter_5_Term_0935_Classic_VS__c!= null && //CH10
                        (objTechnician.E_Credit_Meter_5_Term_0935_Classic__c - objTechnician.E_Credit_Meter_5_Term_0935_Classic_VS__c) > 0 &&(objTechnician.h_E_Credit_Meter_5_Term_0935_Classic__c==null || objTechnician.h_E_Credit_Meter_5_Term_0935_Classic__c==System.today()) && MapProducts.get('E Credit Meter 5 Term 0935 (Classic)')!=null && MapProducts.get('E Credit Meter 5 Term 0935 (Classic)').size()>0){                       
                            //EON order is created per Quantity Field value populated                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter 5 Term 0935 (Classic)')[0],(objTechnician.E_Credit_Meter_5_Term_0935_Classic__c-objTechnician.E_Credit_Meter_5_Term_0935_Classic_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('E Credit Meter 5 Term 0935 (Classic)')[0].Name+'","'+MapProducts.get('E Credit Meter 5 Term 0935 (Classic)')[0].Product_Description__c+'","'+(objTechnician.E_Credit_Meter_5_Term_0935_Classic__c-objTechnician.E_Credit_Meter_5_Term_0935_Classic_VS__c)+'"\n';//CH02
                            if(objTechnician.h_E_Credit_Meter_5_Term_0935_Classic__c==null) objTechnician.h_E_Credit_Meter_5_Term_0935_Classic__c=system.today();
                        }
                        //when Regulators_SC_Gas_VS__c(Van Stock) is less then E_Credit_Meter_5_Term_0244_Classic_BAU__c(BAU Trigger)
                        if(objTechnician.Regulators_SC_Gas_VS__c > 0 && 
                        objTechnician.Regulators_SC_Gas__c != null && objTechnician.Regulators_SC_Gas_VS__c!= null && //CH10
                        (objTechnician.Regulators_SC_Gas__c - objTechnician.Regulators_SC_Gas_VS__c) > 0 &&(objTechnician.h_Regulators_SC_Gas__c==null || objTechnician.h_Regulators_SC_Gas__c==System.today()) && MapProducts.get('Regulators (SC Gas)')!=null && MapProducts.get('Regulators (SC Gas)').size()>0){                       
                            //EON order is created per Quantity Field value populated                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Regulators (SC Gas)')[0],(objTechnician.Regulators_SC_Gas__c-objTechnician.Regulators_SC_Gas_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Regulators (SC Gas)')[0].Name+'","'+MapProducts.get('Regulators (SC Gas)')[0].Product_Description__c+'","'+(objTechnician.Regulators_SC_Gas__c-objTechnician.Regulators_SC_Gas_VS__c)+'"\n';//CH02
                            if(objTechnician.h_Regulators_SC_Gas__c==null) objTechnician.h_Regulators_SC_Gas__c=system.today();
                        }
                        //when Smart_Gas_Meter_New_Connections_VS__c(Van Stock) is less then E_Credit_Meter_5_Term_0244_Classic_BAU__c(BAU Trigger)
                        if(objTechnician.Smart_Gas_Meter_New_Connections_VS__c > 0 && 
                        objTechnician.Smart_Gas_Meter_New_Connections__c != null && objTechnician.Smart_Gas_Meter_New_Connections_VS__c!= null && //CH10
                        (objTechnician.Smart_Gas_Meter_New_Connections__c - objTechnician.Smart_Gas_Meter_New_Connections_VS__c) > 0 &&(objTechnician.h_Smart_Gas_Meter_New_Connections__c==null || objTechnician.h_Smart_Gas_Meter_New_Connections__c==System.today()) && MapProducts.get('Smart Gas Meter (New Connections)')!=null && MapProducts.get('Smart Gas Meter (New Connections)').size()>0){                       
                            //EON order is created per Quantity Field value populated                            
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Gas Meter (New Connections)')[0],(objTechnician.Smart_Gas_Meter_New_Connections__c-objTechnician.Smart_Gas_Meter_New_Connections_VS__c),'BAU',maxReser,DateRequired));
                            count ++;
                            finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(objTechnician.ByBox_Locker_ID__c)+'","'+objTechnician.KID__c+'","'+objTechnician.name+'","'+objTechnician.Cost_Centre__c+'","'+MapProducts.get('Smart Gas Meter (New Connections)')[0].Name+'","'+MapProducts.get('Smart Gas Meter (New Connections)')[0].Product_Description__c+'","'+(objTechnician.Smart_Gas_Meter_New_Connections__c-objTechnician.Smart_Gas_Meter_New_Connections_VS__c)+'"\n';//CH02
                            if(objTechnician.h_Smart_Gas_Meter_New_Connections__c==null) objTechnician.h_Smart_Gas_Meter_New_Connections__c=system.today();
                        }   
                    //CH09.end  
                //}
                }catch(Exception e){ 
                       system.debug(e.getMessage()+'---'+e.getLineNumber() );
                    }
                }
                objTechnician.h_Processed_BAU__c=true;
                LstToUpdateTech.add(objTechnician);
            }  
                try{
                if(LstToUpdateTech!=null && LstToUpdateTech.size()>0){ update LstToUpdateTech;}}catch(Exception e){system.debug(e.getMessage()+'---'+e.getLineNumber() );} //CH07.end
               mail.setHtmlBody(body);
               //CH01.start
               Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
               blob csvBlob = Blob.valueOf(finalstr);
               string csvname= 'MUS BAU Van Stock Order.csv';
               //string content ="text/plain; charset=utf-8";
               csvAttc.setContentType('text/csv; charset=UTF-8');//CH02
               csvAttc.setFileName(csvname);
               csvAttc.setBody(csvBlob);
               mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
               //CH01.end
               insert LstOrdersToInsert;
               emaillist.add(mail);
               system.debug('*******Count******'+count);
               if(count!=null && count>0 ){
               Messaging.sendEmail(emaillist);} }}catch(Exception e){ 
            system.debug(e.getMessage()+'---'+e.getLineNumber() );
        }
    }
    
    /**
    checknullDate(Date Date1) :- This Method is to Check the null values and Replace it with Blank 
    **/
    Public String checknullDate(Date Date1){
        if(Date1==null) { return ''; } else {return Date1.format(); }
    }
    //CH01.start
    /**
    checknullString(String Text) :- This Method is to Check the null values and Replace it with Blank 
    **/
    Public String checknullString(String Text){
        if(Text==null) { return ''; } else {return Text; }
    }
    //CH01.end
}