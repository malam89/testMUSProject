/**
    Description : This class  will Generate and send an email based on the validations for Initial_Van_Stock_Order button 
    Test Class: EON_Ceva_Initial_Van_Stock_Order_Test           
**/

/*
    Created By : Shruti Moghe
    Created Date : 17-Mar-2016
    Service Request : SR_EON_AL_003
    Change History:
    CH01 # SR_EON_AL_01 0# 13/04/2016 # Shruti Moghe # changed class to normal class from Scheduler, to send email as soon as the User clicks on the button
    CH02 # SR_EON_AL_014 # 04/05/2016 # Shruti Moghe # Updated the field name for ByBox Ref to 'ByBox Locker ID' 
    CH03 # SR_EON_AL_016 # 30/05/2016 # Tashika Gupta # Replaced the field name from supplier to manufacturer.
    CH04 # SR_EON_AL_028 # 07/07/2016 # Aruna Manjari # changed as per SR requirements of adding new Update processing logic for 'Initial Stock' order to CEVA with respect to new asset types at 'EON  Product'
    CH05 # SR_EON_AL_030 # 27/07/2016 # Aruna Manjari # Commented out fields to achieve SR functonality 
    CH06 # 13/09/2016 # Shruti Moghe # Renamed the class from EON_Initial_Van_Stock_Order to EON_Ceva_Initial_Van_Stock_Order
*/

global class EON_Ceva_Initial_Van_Stock_Order{

     public static List<EON_Technician__c> lstTechnician = new List<EON_Technician__c>(); //List will hold all Eon Technician Records whose Order needs to be sent to CEVA
     public static List<EON_Product__c> lstProducts = new List<EON_Product__c>(); //List of EON Products
     public static List<EON_Technician__c> lstFailTechnician;  
     
     /**
     EmailToCEVAProcessData(ID techId)- This Method will Process the EON Technician Record and Generate the Email that will be sent to CEVA  
     **/
     webservice static string EmailToCEVAProcessData(ID techId){
        long maxresev;
        String Response='This order has been sent to CEVA to be processed.';
        try{
            //Map to store List of Products in pair of Asset_Type__c
            map<String,List<EON_Product__c>> MapProducts = new map<String,List<EON_Product__c>>();  
            //List of all EON Technician records where button is clicked today to send order to CEVA          
            EON_Technician__c objTechnician = new EON_Technician__c();
            objTechnician =[select id,E_Credit_Meter_SR_1R_0393_Classic__c,E_Credit_Meter_5_Term_0151_Classic__c, E_Credit_Meter_4_Term_0151_Classic__c,E_PP_1R_4_Term_with_Key_0393_Classic__c,E_PP_1R_4_Term_No_Key_0393_Classic__c,E_PP_2R_5_Term_with_Key_0151_Classic__c,E_PP_2R_5_Term_No_Key_0151_Classic__c,Smart_Electric_Meter_New_Connections__c,X3_Phase_E_Meter_0151__c,X3_Phase_E_Meter_0393__c,Gas_Credit_Meter_Semi_Con_Classic__c,Gas_PP_Meter_G4_ETM_Classic__c,Gas_PP_Libre_210_Domestic_Classic__c,Smart_Gas_Meter_Semi_Con__c,  ByBox_Locker_ID__c,BAU_Ship_to_Location__c,Date_left__c,Electric_Credit_Meter_Classic__c, Email__c,Fuses_Electric__c,Gas_Credit_Meter_Classic__c,h_Eon_Stock__c,h_IsProcessed__c,h_Order_Sent__c,h_Send_to_CEVA__c,Initial_Stock_Pickup_Location__c,KID__c, Mobile__c,Regulators_Gas__c,Smart_Electric_Meter__c,Smart_Energy_Display_SED_IHD__c,Smart_Gas_Meter__c,Start_Date__c,Technician_Skill__c, Work_Zone__c,Name from EON_Technician__c where Date_left__c=null and h_IsProcessed__c!=True and id=: techId];//CH02
            
            System.debug('Technician------------->'+objTechnician );
            //List of all Products where Asset type is populated
            lstProducts= [select id,Name,Asset_Type__c,Product_Description__c,Manufacturer__c from EON_Product__c where Asset_Type__c!=null]; //CH03
             system.debug(' lstProducts *****************66'+ lstProducts);
            //populating Map with values required
            for(EON_Product__c objProduct:lstProducts){
                    if(!MapProducts.containsKey(objProduct.Asset_Type__c))
                        MapProducts.put(objProduct.Asset_Type__c, new List<EON_Product__c>());
                    MapProducts.get(objProduct.Asset_Type__c).add(objProduct);                      
            }
            List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); //Email list of All emails to be sent to CEVA
            lstFailTechnician= new List<EON_Technician__c> ();//List of Eon Technician failed to Process
            //Processing EON technician to create Email Template
            //for(EON_Technician__c objTechnician:lstTechnician){//CH01
                if(lstProducts!=null && lstProducts.size()>0 &&( objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c!=null || objTechnician.Fuses_Electric__c!=null || objTechnician.Gas_Credit_Meter_Classic__c!=null ||objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c!=null ||objTechnician.E_Credit_Meter_5_Term_0151_Classic__c!=null ||objTechnician.E_Credit_Meter_4_Term_0151_Classic__c!=null ||objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic__c!=null ||objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic__c!=null ||objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic__c!=null ||objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic__c!=null ||objTechnician.Smart_Electric_Meter_New_Connections__c!=null ||objTechnician.X3_Phase_E_Meter_0151__c!=null ||objTechnician.X3_Phase_E_Meter_0393__c!=null ||objTechnician.Gas_Credit_Meter_Semi_Con_Classic__c!=null ||objTechnician.Gas_PP_Meter_G4_ETM_Classic__c!=null ||objTechnician.Gas_PP_Libre_210_Domestic_Classic__c!=null ||objTechnician.Smart_Gas_Meter_Semi_Con__c!=null ||objTechnician.Regulators_Gas__c!=null ||objTechnician.Smart_Electric_Meter__c!=null || objTechnician.Smart_Energy_Display_SED_IHD__c!=null || objTechnician.Smart_Gas_Meter__c!=null)){
                        List<EON_Order__c> LstOrdersToInsert= new List<EON_Order__c>(); 
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> sendTo = new List<String>();
                        sendTo.add(System.Label.EON_Ceva_Initial_Order_Email);
                        if(sendTo!=null)
                            mail.setToAddresses(sendTo);
                        mail.setSubject('MUS New Starter');
                        String body = '<font style="font-family:arial;font-size:12px;"><b>Date of Order: '+objTechnician.h_Send_to_CEVA__c.format()+'</b><br/>';
                        body+='<br/>';
                        body+='<font style="font-family:arial;font-size:12px;">Dear CEVA, </font>' +'<br/>';
                        body+='<br/>';
                        body+='<font style="font-family:arial;font-size:12px;">Please find attached a completed pro-forma for '+checknull(objTechnician.name)+' who will be collecting their van, PPE, tools and consumables from your '+ checknull(objTechnician.Initial_Stock_Pickup_Location__c)+' '+'site on '+checknullDate(objTechnician.Start_Date__c)+'.</font><br/>';
                        body+='<br/>';
                        body+='<font style="font-family:arial;font-size:12px;">They will also require the below assets to be available for collection on the same day.'+'</font><br/>';
                        body+='<br/>';
                        body+='<table style="width:100%;font-family:arial;font-size:12px; border-width: thin; border-style:solid;border-collapse: collapse; align:center" border="1" cellpadding="5"><tr><td align="center"><b>Name</b></td><td align="center"><b>KID</b></td><td align="center"><b>Contact Number</b></td><td align="center"><b>Product Code</b></td><td align="center"><b>Product Description</b></td><td align="center"><b>Quantity Needed</b></td><td align="center"><b>Date Required</b></td></tr>';                        
                        //when Electric_Credit_Meter_Classic__c is populated
                        if(objTechnician.Electric_Credit_Meter_Classic__c!=null && MapProducts.get('Electric Credit Meter (Classic)')!=null && MapProducts.get('Electric Credit Meter (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Electric Credit Meter (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('Electric Credit Meter (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Electric_Credit_Meter_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Electric Credit Meter (Classic)')[0],objTechnician.Electric_Credit_Meter_Classic__c,'INITIAL',maxresev,null));
                        }
                        
                        //when Fuses_Electric__c is populated
                        if(objTechnician.Fuses_Electric__c!=null && MapProducts.get('Fuses (Electric)')!=null && MapProducts.get('Fuses (Electric)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Fuses (Electric)')[0].Name+'</td><td align="Left">'+MapProducts.get('Fuses (Electric)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Fuses_Electric__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                           LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Fuses (Electric)')[0],objTechnician.Fuses_Electric__c,'INITIAL',maxresev,null));
                        }
                        //when Gas_Credit_Meter_Classic__c is populated
                        if(objTechnician.Gas_Credit_Meter_Classic__c!=null && objTechnician.Gas_Credit_Meter_Classic__c>0 && MapProducts.get('Gas Credit Meter (Classic)')!=null && MapProducts.get('Gas Credit Meter (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Gas Credit Meter (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('Gas Credit Meter (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Gas_Credit_Meter_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Gas Credit Meter (Classic)')[0],objTechnician.Gas_Credit_Meter_Classic__c,'INITIAL',maxresev,null));
                        }
                        
                        //when Regulators_Gas__c is populated
                        if(objTechnician.Regulators_Gas__c!=null &&  objTechnician.Regulators_Gas__c>0 && MapProducts.get('Regulators (Gas)')!=null && MapProducts.get('Regulators (Gas)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Regulators (Gas)')[0].Name+'</td><td align="Left">'+MapProducts.get('Regulators (Gas)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Regulators_Gas__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Regulators (Gas)')[0],objTechnician.Regulators_Gas__c,'INITIAL',maxresev,null));
                        }
                        //when Smart_Electric_Meter__c is populated
                        if(objTechnician.Smart_Electric_Meter__c!=null && objTechnician.Smart_Electric_Meter__c>0 && MapProducts.get('Smart Electric Meter')!=null && MapProducts.get('Smart Electric Meter').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Smart Electric Meter')[0].Name+'</td><td align="Left">'+MapProducts.get('Smart Electric Meter')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Smart_Electric_Meter__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Electric Meter')[0],objTechnician.Smart_Electric_Meter__c,'INITIAL',maxresev,null));
                        }
                        //when Smart_Energy_Display_SED_IHD__c is populated
                        if(objTechnician.Smart_Energy_Display_SED_IHD__c!=null && objTechnician.Smart_Energy_Display_SED_IHD__c>0 && MapProducts.get('Smart Energy Display (SED / IHD)')!=null && MapProducts.get('Smart Energy Display (SED / IHD)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Smart Energy Display (SED / IHD)')[0].Name+'</td><td align="Left">'+MapProducts.get('Smart Energy Display (SED / IHD)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Smart_Energy_Display_SED_IHD__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Energy Display (SED / IHD)')[0],objTechnician.Smart_Energy_Display_SED_IHD__c,'INITIAL',maxresev,null));
                        }
                        //when Smart_Gas_Meter__c is populated
                        if(objTechnician.Smart_Gas_Meter__c!=null && objTechnician.Smart_Gas_Meter__c>0  &&  MapProducts.get('Smart Gas Meter')!=null && MapProducts.get('Smart Gas Meter').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Smart Gas Meter')[0].Name+'</td><td align="Left">'+MapProducts.get('Smart Gas Meter')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Smart_Gas_Meter__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Gas Meter')[0],objTechnician.Smart_Gas_Meter__c,'INITIAL',maxresev,null));
                        }
                         //CH04.Start 
                        //when E_Credit_Meter_SR_1R_0393_Classic__c is populated
                        if(objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c!=null && objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c>0 && MapProducts.get('E Credit Meter SR 1R 0393 (Classic)')!=null && MapProducts.get('E Credit Meter SR 1R 0393 (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('E Credit Meter SR 1R 0393 (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('E Credit Meter SR 1R 0393 (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                             LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter SR 1R 0393 (Classic)')[0],objTechnician.E_Credit_Meter_SR_1R_0393_Classic__c,'INITIAL',maxresev,null));
                        } 
                         //when E_Credit_Meter_5_Term_0151_Classic__c is populated
                        if(objTechnician.E_Credit_Meter_5_Term_0151_Classic__c!=null && objTechnician.E_Credit_Meter_5_Term_0151_Classic__c>0 && MapProducts.get('E Credit Meter 5 Term 0151 (Classic)')!=null && MapProducts.get('E Credit Meter 5 Term 0151 (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('E Credit Meter 5 Term 0151 (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('E Credit Meter 5 Term 0151 (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.E_Credit_Meter_5_Term_0151_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter 5 Term 0151 (Classic)')[0],objTechnician.E_Credit_Meter_5_Term_0151_Classic__c,'INITIAL',maxresev,null));
                            system.debug('E_Credit_Meter_5_Term_0151_Classic__c ******Line 330');
                        } 
                        //when E_Credit_Meter_4_Term_0151_Classic__c is populated
                        if(objTechnician.E_Credit_Meter_4_Term_0151_Classic__c!=null && objTechnician.E_Credit_Meter_4_Term_0151_Classic__c>0 && MapProducts.get('E Credit Meter 4 Term 0151 (Classic)')!=null && MapProducts.get('E Credit Meter 4 Term 0151 (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('E Credit Meter 4 Term 0151 (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('E Credit Meter 4 Term 0151 (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.E_Credit_Meter_4_Term_0151_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E Credit Meter 4 Term 0151 (Classic)')[0],objTechnician.E_Credit_Meter_4_Term_0151_Classic__c,'INITIAL',maxresev,null));
                            system.debug('E_Credit_Meter_4_Term_0151_Classic__c ******Line 349');
                        } 
                        
                         //when E_PP_1R_4_Term_with_Key_0393_Classic__c is populated
                        if(objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic__c!=null && objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic__c>0 && MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)')!=null && MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                           LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E PP 1R 4 Term with Key 0393 (Classic)')[0],objTechnician.E_PP_1R_4_Term_with_Key_0393_Classic__c,'INITIAL',maxresev,null));
                            system.debug('E_PP_1R_4_Term_with_Key_0393_Classic__c ******Line 393');
                        }
                        //when E_PP_1R_4_Term_No_Key_0393_Classic__c is populated
                        if(objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic__c!=null && objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic__c>0 && MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)')!=null && MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E PP 1R 4 Term No Key 0393 (Classic)')[0],objTechnician.E_PP_1R_4_Term_No_Key_0393_Classic__c,'INITIAL',maxresev,null));
                            system.debug('E_PP_1R_4_Term_No_Key_0393_Classic__c ******Line 407');
                        }
                        
                        //when E_PP_2R_5_Term_with_Key_0151_Classic__c is populated
                        if(objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic__c!=null && objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic__c>0 && MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)')!=null && MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E PP 2R 5 Term with Key 0151 (Classic)')[0],objTechnician.E_PP_2R_5_Term_with_Key_0151_Classic__c,'INITIAL',maxresev,null));
                            system.debug('E_PP_2R_5_Term_with_Key_0151_Classic__c ******Line 422');
                        }
                        
                        //when E_PP_2R_5_Term_No_Key_0151_Classic__c is populated
                        if(objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic__c!=null && objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic__c>0 && MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)')!=null && MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('E PP 2R 5 Term No Key 0151 (Classic)')[0],objTechnician.E_PP_2R_5_Term_No_Key_0151_Classic__c,'INITIAL',maxresev,null));
                            system.debug('E_PP_2R_5_Term_No_Key_0151_Classic__c ******Line 437');
                        }
                        
                         //when Smart_Electric_Meter_New_Connections__c is populated
                        if(objTechnician.Smart_Electric_Meter_New_Connections__c!=null && objTechnician.Smart_Electric_Meter_New_Connections__c>0 && MapProducts.get('Smart Electric Meter (New Connections)')!=null && MapProducts.get('Smart Electric Meter (New Connections)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Smart Electric Meter (New Connections)')[0].Name+'</td><td align="Left">'+MapProducts.get('Smart Electric Meter (New Connections)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Smart_Electric_Meter_New_Connections__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Electric Meter (New Connections)')[0],objTechnician.Smart_Electric_Meter_New_Connections__c,'INITIAL',maxresev,null));
                            system.debug('Smart_Electric_Meter_New_Connections__c #########');
                        }
                        
                        // when X3_Phase_E_Meter_0151__c is populated
                        if(objTechnician.X3_Phase_E_Meter_0151__c!=null && objTechnician.X3_Phase_E_Meter_0151__c>0 && MapProducts.get('3 Phase E Meter 0151')!=null && MapProducts.get('3 Phase E Meter 0151').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('3 Phase E Meter 0151')[0].Name+'</td><td align="Left">'+MapProducts.get('3 Phase E Meter 0151')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.X3_Phase_E_Meter_0151__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('3 Phase E Meter 0151')[0],objTechnician.X3_Phase_E_Meter_0151__c,'INITIAL',maxresev,null));
                            system.debug('X3_Phase_E_Meter_0151__c  #########');
                        }
                        
                         // when X3_Phase_E_Meter_0393__c is populated
                        if(objTechnician.X3_Phase_E_Meter_0393__c!=null && objTechnician.X3_Phase_E_Meter_0393__c>0 && MapProducts.get('3 Phase E Meter 0393')!=null && MapProducts.get('3 Phase E Meter 0393').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('3 Phase E Meter 0393')[0].Name+'</td><td align="Left">'+MapProducts.get('3 Phase E Meter 0393')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.X3_Phase_E_Meter_0393__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('3 Phase E Meter 0393')[0],objTechnician.X3_Phase_E_Meter_0393__c,'INITIAL',maxresev,null));
                            system.debug('X3_Phase_E_Meter_0393__c  #########');
                        }
                        
                          // when Gas_Credit_Meter_Semi_Con_Classic__c is populated
                        if(objTechnician.Gas_Credit_Meter_Semi_Con_Classic__c!=null && objTechnician.Gas_Credit_Meter_Semi_Con_Classic__c>0 && MapProducts.get('Gas Credit Meter Semi Con (Classic)')!=null && MapProducts.get('Gas Credit Meter Semi Con (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Gas Credit Meter Semi Con (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('Gas Credit Meter Semi Con (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Gas_Credit_Meter_Semi_Con_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Gas Credit Meter Semi Con (Classic)')[0],objTechnician.Gas_Credit_Meter_Semi_Con_Classic__c,'INITIAL',maxresev,null));
                            system.debug('Gas_Credit_Meter_Semi_Con_Classic__c #########');
                        }
                         
                         // when Gas_PP_Meter_G4_ETM_Classic__c is populated
                        if(objTechnician.Gas_PP_Meter_G4_ETM_Classic__c!=null && objTechnician.Gas_PP_Meter_G4_ETM_Classic__c>0 && MapProducts.get('Gas PP Meter G4 ETM (Classic)')!=null && MapProducts.get('Gas PP Meter G4 ETM (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Gas PP Meter G4 ETM (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('Gas PP Meter G4 ETM (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Gas_PP_Meter_G4_ETM_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Gas PP Meter G4 ETM (Classic)')[0],objTechnician.Gas_PP_Meter_G4_ETM_Classic__c,'INITIAL',maxresev,null));
                            system.debug('Gas_PP_Meter_G4_ETM_Classic__c #########');
                        }
                        
                        // when Gas_PP_Libre_210_Domestic_Classic__c is populated
                        if(objTechnician.Gas_PP_Libre_210_Domestic_Classic__c!=null && objTechnician.Gas_PP_Libre_210_Domestic_Classic__c>0 && MapProducts.get('Gas PP Libre 210 Domestic (Classic)')!=null && MapProducts.get('Gas PP Libre 210 Domestic (Classic)').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Gas PP Libre 210 Domestic (Classic)')[0].Name+'</td><td align="Left">'+MapProducts.get('Gas PP Libre 210 Domestic (Classic)')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Gas_PP_Libre_210_Domestic_Classic__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                            LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Gas PP Libre 210 Domestic (Classic)')[0],objTechnician.Gas_PP_Libre_210_Domestic_Classic__c,'INITIAL',maxresev,null));
                            system.debug('Gas_PP_Libre_210_Domestic_Classic__c #########');
                        }
                       
                         // when Smart_Gas_Meter_Semi_Con__c is populated
                        if(objTechnician.Smart_Gas_Meter_Semi_Con__c!=null && objTechnician.Smart_Gas_Meter_Semi_Con__c>0 && MapProducts.get('Smart Gas Meter Semi Con')!=null && MapProducts.get('Smart Gas Meter Semi Con').size()>0){
                            body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+MapProducts.get('Smart Gas Meter Semi Con')[0].Name+'</td><td align="Left">'+MapProducts.get('Smart Gas Meter Semi Con')[0].Product_Description__c+'</td><td align="Left">'+objTechnician.Smart_Gas_Meter_Semi_Con__c+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
                           LstOrdersToInsert.add(EON_Ceva_Utility.CreateOrderRecords(objTechnician,MapProducts.get('Smart Gas Meter Semi Con')[0],objTechnician.Smart_Gas_Meter_Semi_Con__c,'INITIAL',maxresev,null));
                            system.debug('Smart_Gas_Meter_Semi_Con__c #########');
                        } 
                        //CH04.Stop
                        
                        body+= '</table>'+'<br/>';                      
                        body+='Kind regards'+'<br/>';
                        body+='MORRISON UTILITY SERVICES'+'<br/>';          
                        mail.setHtmlBody(body);
                        Messaging.EmailFileAttachment AttachmentFile = new Messaging.EmailFileAttachment();
                        List<Attachment> att = new List<Attachment>();
                        att =[SELECT id, Name, Body FROM Attachment WHERE ParentID = : objTechnician.id AND name like 'MUS New Starter Kit%' limit 1];
                        //Attachment is attached to Email
                        if(att!=null && att.size()>0){
                            AttachmentFile = new Messaging.EmailFileAttachment();
                            AttachmentFile.setFileName(att[0].name);
                            AttachmentFile.setBody(att[0].Body);     
                            Integer fileSize = att[0].body.size()/1000; 
                            //checking the file Size of attachment (less than 3MB)
                            if(fileSize <= 2800 &&  EON_Ceva_Initial_Van_Stock_Order_Test.genException==false){
                                List<Messaging.EmailFileAttachment> AttachmentList = new List<Messaging.EmailFileAttachment>();
                                AttachmentList.add(AttachmentFile);
                                 mail.setFileAttachments(AttachmentList);        
                                 emaillist.add(mail);
                                 insert LstOrdersToInsert;
                                 objTechnician.h_IsProcessed__c=true; // processed successfully
                                 update objTechnician;
                                 
                            }           
                            else{
                                objTechnician.h_Send_to_CEVA__c=null; objTechnician.h_Order_Sent__c=false; update objTechnician;
                                Response='The Attachment MUS New Starter Kit is exceeding the Size limit of 3MB, Please check once and try again';                               
                                //CH01.end.new
                            }
                        }
                        else{
                            objTechnician.h_IsProcessed__c=true;
                            update objTechnician;                           
                            insert LstOrdersToInsert;
                            emaillist.add(mail);                                            
                            System.debug(emaillist.size());
                        }        
                }       
           
            if(emaillist !=null && emaillist.size()>0)
                Messaging.sendEmail(emaillist);
        }
        catch(Exception e){ 
            system.debug(e.getMessage()+'---'+e.getLineNumber() );
        }
        return Response;
    }
    
    /**
    Checknull(String text) :- This Method is to Check the null values and Replace it with Blank 
    **/
    Public static String Checknull(String text){
        if(text==null) { return ''; } else {return text; }
    }
    /**
    checknullDate(Date Date1) :- This Method is to Check the null values and Replace it with Blank 
    **/
    Public static String checknullDate(Date Date1){
        if(Date1==null) { return ''; } else {return Date1.format(); }
    }
}