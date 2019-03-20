/**
    Description : This class  will Generate and send an email based on the validations for Initial_Van_Stock_Order button 
    
    VF Page     : None
    Test Class  : EON_Replenish_TechStock_CEVA_Batch_Test
**/
/*
    Created By  : Mehboob Alam
    Created On  : 01/12/2017
    Service Req : SR_OptiMUS_EON_168
    Change History
    CH01 # SR_OptiMUS_EON_205 # 10/03/2018 # Mehboob Alam # Changes as per SR Description.
*/

global with sharing class EON_Replenish_TechStock_CEVA_Batch implements Database.Batchable<sObject>, Database.Stateful{
      public string finalstr = 'Reservation,Date,Locker,KID,Name,Cost Centre,Material,Description,Quantity\n';   
      public boolean ordrInst = false;   

    /**
     start(Database.BatchableContext BC) - Start method for the Batch class to fetch records that need to be processed
    **/
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT id FROM EON_Technician__c where Date_left__c = null and Stock_Profile__c<>null and (h_Stock_Required_Date__c < TODAY or h_Stock_Required_Date__c = TODAY or h_Stock_Required_Date__c=null)');
    }
    
    /**
     execute(Database.BatchableContext BC, List<EON_Technician__c> scope) - Execute method to process each record
    **/
    global void execute(Database.BatchableContext BC, List<EON_Technician__c> scope){
      try{
           EON_Ceva_Utility.byPassTechTrigger = false;
           set<id> techId = new set<id>();
           for(EON_Technician__c et: scope){
                techId.add(et.id);
           } 
           
           
        //Variable Declaration
        List<EON_Technician__c> lstTechnician = new List<EON_Technician__c>();
        Map<id,list<Profile_Product__c>> mapProduct = new Map<id,list<Profile_Product__c>>();
        Map<string,integer> mapStockCount = new Map<string,integer>();
        List<EON_Order__c> LstOrdersToInsert= new List<EON_Order__c>();
        List<EON_Order__c> lstRepOrders= new List<EON_Order__c>(); 
        List<EON_Technician__c> lstUpdateTech = new List<EON_Technician__c>();
        Set<id> sProId = New Set<id>(); //Hold id list of all StockProfile
        Boolean inStockOrder = false;
        Boolean nonStockOrder = false;
        string repString = '';
        Map<id,boolean> incInProcess = new Map<id,boolean>(); //CH01
        
        //List of all EON Technician records where button is clicked today to send order to CEVA
        lstTechnician =[select id,Name,Stock_Profile__c,Mobile__c,h_BAU_Send_To_CEVA__c,ByBox_Locker_ID__c,KID__c,Cost_Centre__c,Cease_Stock_Auto_Replen__c,Resume_Stock_Auto_Replen__c,
                       (select id,Product_Code__c from EON_Stock__r where Status__c='On Van') from EON_Technician__c where id=:techId];
                        
        //if any technician exist                
        if(!lstTechnician.isEmpty()){
            for(EON_Technician__c et : lstTechnician){
                    sProId.add(et.Stock_Profile__c);
                       for(EON_Stock__c es : et.EON_Stock__r){
                          if(mapStockCount.containsKey(et.id+'-'+es.Product_Code__c))
                             mapStockCount.put(et.id+'-'+es.Product_Code__c, mapStockCount.get(et.id+'-'+es.Product_Code__c)+1);
                            else
                              mapStockCount.put(et.id+'-'+es.Product_Code__c, 1);
                           }
                           
	               //CH01.Start
	               if(EON_Utility.validateRequired(et.Cease_Stock_Auto_Replen__c))
	                    incInProcess.put(et.id,true);
	                      else if(et.Cease_Stock_Auto_Replen__c > date.today())
	                               incInProcess.put(et.id,true);
	                                 else if(EON_Utility.validateRequired(et.Resume_Stock_Auto_Replen__c))
	                                         incInProcess.put(et.id,false);   
	                                            else if(et.Resume_Stock_Auto_Replen__c > date.today())
	                                                   incInProcess.put(et.id,false);    
	                                                     else 
	                                                        incInProcess.put(et.id,true);
	              //CH01.End
                }
             
             
            //Collecting Profile Product records    
            for(EON_Stock_Profile__c sp : [select id, (select id,Max_Level__c,Product__c,Product__r.Name,Product__r.Product_Description__c,                               
                                           BAU_Trigger_Level__c from Profile_Product__r where Active__c=true and Max_Level__c<>null and                               
                                           BAU_Trigger_Level__c<>null and Product__c<>null) from EON_Stock_Profile__c where id=:sProId]){
                if(!mapProduct.containskey(sp.id))
                   if(!sp.Profile_Product__r.isEmpty())
                       mapProduct.put(sp.id, sp.Profile_Product__r);                       
            }         
            long maxReser = EON_Ceva_Utility.GetReservationNumber();
            boolean check = EON_Ceva_Utility.noMinReser;
            Date DateRequired= EON_MorrisonDate.CalculatedFinishDate(date.today(),02);
                  
            //Genrating Orders   
            for(EON_Technician__c Tech : lstTechnician){
              if(incInProcess.get(Tech.id)){   //CH01
                if(maxReser==9600000000L && check==true){
                     maxReser = maxReser;
                     check = false;
                }
                else
                 maxReser = maxReser + 1;
                 inStockOrder = false;
                 nonStockOrder = false;
                 repString ='';
                 lstRepOrders.clear();
                 if(mapProduct.containsKey(Tech.Stock_Profile__c)){
                    for(Profile_Product__c ppf : mapProduct.get(Tech.Stock_Profile__c)){
                        if(mapStockCount.containsKey(Tech.id+'-'+ppf.Product__r.Name)){
                            if(mapStockCount.get(Tech.id+'-'+ppf.Product__r.Name) < ppf.BAU_Trigger_Level__c){
                               inStockOrder = true;
                            
                               //EON order is created per Quantity Field value populated                            
                               EON_Order__c order =new EON_Order__c();
                               order.Date_Required__c= DateRequired;
                               order.Mobile__c= Tech.Mobile__c;
                               order.Reservation__c = string.valueOf(maxReser);
                               order.Order_Date__c=Tech.h_BAU_Send_To_CEVA__c;
                               order.Product_Code__c=ppf.Product__c;
                               order.Product_Description__c=ppf.Product__r.Product_Description__c;
                               order.Quantity_Required__c=string.valueOf(ppf.Max_Level__c-mapStockCount.get(Tech.id+'-'+ppf.Product__r.Name));
                               order.Technician_Name__c=Tech.id;
                               lstRepOrders.add(Order);
                               repString += '"'+String.valueof(maxReser)+'","'+DateRequired.format()+'","'+Tech.ByBox_Locker_ID__c+'","'+Tech.KID__c+'","'+Tech.name+'","'+Tech.Cost_Centre__c+'","'+ppf.Product__r.Name+'","'+ppf.Product__r.Product_Description__c+'","'+(ppf.Max_Level__c-mapStockCount.get(Tech.id+'-'+ppf.Product__r.Name))+'"\n';
                            }
                        } 
                         else{
                            if(ppf.Max_Level__c>0){
                               nonStockOrder = true;
                               //EON order is created per Quantity Field value populated                            
                               EON_Order__c order =new EON_Order__c();
                               order.Date_Required__c= DateRequired;
                               order.Mobile__c= Tech.Mobile__c;
                               order.Reservation__c = string.valueOf(maxReser);
                               order.Order_Date__c=Tech.h_BAU_Send_To_CEVA__c;
                               order.Product_Code__c=ppf.Product__c;
                               order.Product_Description__c=ppf.Product__r.Product_Description__c;
                               order.Quantity_Required__c=string.valueOf(ppf.Max_Level__c);
                               order.Technician_Name__c=Tech.id;
                               LstOrdersToInsert.add(Order);
                               finalstr += '"'+String.valueof(maxReser)+'","'+DateRequired.format()+'","'+Tech.ByBox_Locker_ID__c+'","'+Tech.KID__c+'","'+Tech.name+'","'+Tech.Cost_Centre__c+'","'+ppf.Product__r.Name+'","'+ppf.Product__r.Product_Description__c+'","'+ppf.Max_Level__c+'"\n';
                            }
                         }                                       
                     }
                 }
                    if(inStockOrder || nonStockOrder){
                       //CH01.Start
                        if(!EON_Utility.validateRequired(Tech.Cease_Stock_Auto_Replen__c) && !EON_Utility.validateRequired(Tech.Resume_Stock_Auto_Replen__c)){
                              Tech.Cease_Stock_Auto_Replen__c=null;
                              Tech.Resume_Stock_Auto_Replen__c=null;
                         }
                       //CH01.End
                       Tech.h_Stock_Required_Date__c=DateRequired;
                       lstUpdateTech.add(Tech);
                       LstOrdersToInsert.addall(lstRepOrders);
                       finalstr = finalstr+repString;
                      }
                   } 
                }
                   
                    if(!lstUpdateTech.isEmpty()) 
                       update lstUpdateTech;

                    if(!LstOrdersToInsert.isEmpty()){
                       insert LstOrdersToInsert;
                       ordrInst =true; 
                    }                  
                }  
             }
             catch(Exception e){
             
             }
    }
    
    /**
    finish(Database.BatchableContext BC) - Finish method for the batch class that would run when all images would have been attached
    **/
    global void finish(Database.BatchableContext BC){
        if(ordrInst){
            system.debug('-------->'+finalstr);
            List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); //Email list of All emails to be sent to CEVA
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String sendTo = '';
            sendTo= System.Label.EON_Ceva_BAU_Trigger_Order_Email;
            mail.setToAddresses(sendTo.split(';'));
            mail.setSubject('EON MORRISONS ORDERS');
            String body = '<font style="font-family:arial;font-size:12px;"><b>Date of Order: '+system.today().format()+'</b><br/>';
            body+='<br/>';
            mail.setHtmlBody(body);
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            string csvname= 'MUS BAU Van Stock Order.csv';
            csvAttc.setContentType('text/csv; charset=UTF-8');
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            emaillist.add(mail);
            Messaging.sendEmail(emaillist); 
        }       
    }
}