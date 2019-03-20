/**
    Description : This class  will Generate and send an email based on the validations for Initial_Van_Stock_Order button 
    
    VF Page     : None
    Test Class  : EON_CEVA_Tech_Stock_Order_Scheduler_Test
**/
/*
    Created By  : Mehboob Alam
    Created On  : 01/12/2017
    Service Req : SR_OptiMUS_EON_168
    Change History
    CH01 # SR_OptiMUS_EON_205 # 10/03/2018 # Mehboob Alam # Changes as per SR Description.
    CH02 # SR_OptiMUS_EON_185 # 20/03/2018 # GunaSekhar P # Added condition as per SR.
*/

global with sharing class EON_CEVA_Tech_Stock_Order_Scheduler implements schedulable{
      
     /**
     Execute()- This Method will Execute the Scheduler.
    **/
     global void execute(schedulableContext sc){
         EmailToCEVAProcessData();
     }  
     /**
     EmailToCEVAProcessData()- This Method will Process the EON Technician Records and Generate the Email that will be sent to CEVA  
    **/
    Public void EmailToCEVAProcessData(){
        
        //Variable Declaration
        Integer Count = 0; //Count the record which need to be sent to CEVA
        List<EON_Technician__c> lstTechnician = new List<EON_Technician__c>();
        Map<id,list<Profile_Product__c>> mapProduct = new Map<id,list<Profile_Product__c>>();
        Map<string,integer> mapStockCount = new Map<string,integer>();
        List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); //Email list of All emails to be sent to CEVA
        List<EON_Order__c> LstOrdersToInsert= new List<EON_Order__c>();
        List<EON_Order__c> lstRepOrders= new List<EON_Order__c>(); 
        List<EON_Technician__c> lstUpdateTech = new List<EON_Technician__c>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Set<id> sProId = New Set<id>(); //Hold id list of all StockProfile
        Boolean inStockOrder = false;
        Boolean nonStockOrder = false;
        string repString = '';
        Map<id,boolean> incInProcess = new Map<id,boolean>(); //CH01
        
        //List of all EON Technician records where button is clicked today to send order to CEVA
        lstTechnician =[select id,Name,Stock_Profile__c,Mobile__c,h_BAU_Send_To_CEVA__c,ByBox_Locker_ID__c,KID__c,Cost_Centre__c,Cease_Stock_Auto_Replen__c,Resume_Stock_Auto_Replen__c,(select id,
                        Product_Code__c from EON_Stock__r where Product_Code__c <> null and Status__c='On Van') from EON_Technician__c where                
                        Date_left__c = null and Stock_Profile__c<>null and (h_Stock_Required_Date__c < TODAY or h_Stock_Required_Date__c = TODAY 
                        or h_Stock_Required_Date__c=null)];
        
        //CH02.Start
        Map<String, String> mapProductWithLinkedProduct = new Map<String, String>();
        if(!lstTechnician.isEmpty()){
            for(EON_Technician__c et : lstTechnician){
                sProId.add(et.Stock_Profile__c);
            }
        }
        //CH02.End
        
        //Collecting Profile Product records     
        for(EON_Stock_Profile__c sp : [select id, (select id,Max_Level__c,Product__c,Product__r.Name,Product__r.Product_Description__c,
                                          Product__r.Linked_Product__r.Name,//CH02                           
                                       BAU_Trigger_Level__c from Profile_Product__r where Active__c=true and Max_Level__c<>null and                               
                                       BAU_Trigger_Level__c<>null and Product__c<>null) from EON_Stock_Profile__c where id=:sProId]){
            if(!mapProduct.containskey(sp.id))
               if(!sp.Profile_Product__r.isEmpty())
                   mapProduct.put(sp.id, sp.Profile_Product__r);  
            //CH02.Start
            for(Profile_Product__c profileProduct : sp.Profile_Product__r){
                if(profileProduct.Product__r.Linked_Product__r.Name != null)
                    mapProductWithLinkedProduct.put(profileProduct.Product__r.Name, 
                                                profileProduct.Product__r.Linked_Product__r.Name);
            }
            //CH02.End                                        
        }        
        
        //if any technician exist                
        if(!lstTechnician.isEmpty()){
            for(EON_Technician__c et : lstTechnician){
                    //sProId.add(et.Stock_Profile__c);//CH02.Removed
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
                 
            //Genrating Email to send to CEVA    
            String sendTo = '';
            sendTo= System.Label.EON_Ceva_BAU_Trigger_Order_Email;
            mail.setToAddresses(sendTo.split(';'));
            mail.setSubject('EON MORRISONS ORDERS');
            String body = '<font style="font-family:arial;font-size:12px;"><b>Date of Order: '+system.today().format()+'</b><br/>';
            body+='<br/>';       
            string header = 'Reservation,Date,Locker,KID,Name,Cost Centre,Material,Description,Quantity\n';      
            string finalstr = header ;
            long maxReser = EON_Ceva_Utility.GetReservationNumber();
            boolean check = EON_Ceva_Utility.noMinReser;
            Date DateRequired= EON_MorrisonDate.CalculatedFinishDate(date.today(),03);
                
             //Genrating Orders   
            for(EON_Technician__c Tech : lstTechnician){
                if(incInProcess.get(Tech.id)){   //CH01
                    if(maxReser==9600000000L && check==true){
                         maxReser = maxReser;
                         check = false;
                    }
                    else
                     maxReser = maxReser + 1;
                 //Iterating realted Profile Product 
                    if(mapProduct.containsKey(Tech.Stock_Profile__c)){
                        inStockOrder = false;
                        nonStockOrder = false;
                        repString ='';
                        lstRepOrders.clear();
                        for(Profile_Product__c ppf : mapProduct.get(Tech.Stock_Profile__c)){
                            if(mapStockCount.containsKey(Tech.id+'-'+ppf.Product__r.Name)){
                                if(mapStockCount.get(Tech.id+'-'+ppf.Product__r.Name) <= ppf.BAU_Trigger_Level__c)
                                   inStockOrder = true;
                                
                                   //EON order is created per Quantity Field value populated                            
                                   EON_Order__c order =new EON_Order__c();
                                   order.Date_Required__c= DateRequired;
                                   order.Mobile__c= Tech.Mobile__c;
                                   order.Reservation__c = string.valueOf(maxReser);
                                   order.Order_Date__c=Tech.h_BAU_Send_To_CEVA__c;
                                   order.Product_Code__c=ppf.Product__c;
                                   order.Product_Description__c=ppf.Product__r.Product_Description__c;
                                   //CH02.Start
                                   if(mapProductWithLinkedProduct.get(ppf.Product__r.Name) != null && 
                                       mapStockCount.get(Tech.id+'-'+ mapProductWithLinkedProduct.get(ppf.Product__r.Name)) != null){
                                       order.Quantity_Required__c= string.valueOf(ppf.Max_Level__c- mapStockCount.get(Tech.id+'-'+ppf.Product__r.Name) - mapStockCount.get(Tech.id+'-'+ mapProductWithLinkedProduct.get(ppf.Product__r.Name)));
                                   }else{
                                       order.Quantity_Required__c=string.valueOf(ppf.Max_Level__c-mapStockCount.get(Tech.id+'-'+ppf.Product__r.Name));
                                       }//CH02.End
                                   order.Technician_Name__c=Tech.id;
                                   lstRepOrders.add(Order);
                                   repString += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(Tech.ByBox_Locker_ID__c)+'","'+Tech.KID__c+'","'+Tech.name+'","'+Tech.Cost_Centre__c+'","'+ppf.Product__r.Name+'","'+ppf.Product__r.Product_Description__c+'","'+(ppf.Max_Level__c-mapStockCount.get(Tech.id+'-'+ppf.Product__r.Name))+'"\n';
                            } 
                             else{
                                   nonStockOrder = true;
                                   //EON order is created per Quantity Field value populated                            
                                   EON_Order__c order =new EON_Order__c();
                                   order.Date_Required__c= DateRequired;
                                   order.Mobile__c= Tech.Mobile__c;
                                   order.Reservation__c = string.valueOf(maxReser);
                                   order.Order_Date__c=Tech.h_BAU_Send_To_CEVA__c;
                                   order.Product_Code__c=ppf.Product__c;
                                   order.Product_Description__c=ppf.Product__r.Product_Description__c;
                                   //CH02.Start
                                   if(mapStockCount.get(Tech.id+'-'+ mapProductWithLinkedProduct.get(ppf.Product__r.Name))!=null){
                                       order.Quantity_Required__c=string.valueOf(ppf.Max_Level__c-mapStockCount.get(Tech.id+'-'+ mapProductWithLinkedProduct.get(ppf.Product__r.Name)));//CH02
                                   }else{
                                       order.Quantity_Required__c=string.valueOf(ppf.Max_Level__c);
                                       }//CH02.End
                                   order.Technician_Name__c=Tech.id;
                                   LstOrdersToInsert.add(Order);
                                   finalstr += '"'+checknullString(String.valueof(maxReser))+'","'+checknullDate(DateRequired)+'","'+checknullString(Tech.ByBox_Locker_ID__c)+'","'+Tech.KID__c+'","'+Tech.name+'","'+Tech.Cost_Centre__c+'","'+ppf.Product__r.Name+'","'+ppf.Product__r.Product_Description__c+'","'+ppf.Max_Level__c+'"\n';
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
            } 
            
            try{
                if(!lstUpdateTech.isEmpty()) 
                    update lstUpdateTech;
                }
                catch(Exception e){
                    system.debug(e.getMessage()+'---'+e.getLineNumber() );
                 } 
                
            mail.setHtmlBody(body);
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            string csvname= 'MUS BAU Van Stock Order.csv';
            csvAttc.setContentType('text/csv; charset=UTF-8');
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            insert LstOrdersToInsert;
            emaillist.add(mail);
            if(!LstOrdersToInsert.isEmpty()){
                 Messaging.sendEmail(emaillist);
            } 
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