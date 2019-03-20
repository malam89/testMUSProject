/**
    Description : This class  will Generate and send an email based on the validations for Initial_Van_Stock_Order button 
    
    VF Page     : None
    Test Class  : EON_CEVA_Van_Stock_Order_Email_Test
**/
/*
    Created By  : Mehboob Alam
    Created On  : 01/12/2017
    Service Req : 
    Change History
*/
global with sharing class EON_CEVA_Van_Stock_Order_Email {

    /**
    sentOrderEmailCEVA(id techId, id stockId)- This Method will Process the EON Technician Record and Generate the Email that will be sent to CEVA  
    **/  
    webservice static string sentOrderEmailCEVA(id techId, id stockId){
        String Response='This order has been sent to CEVA to be processed.';
        decimal productQnty =0;
        boolean orderSent = false; 
        Date DateRequired= EON_MorrisonDate.CalculatedFinishDate(date.today(),02); 
        EON_Technician__c objTechnician = new EON_Technician__c();
        Map<string,integer> mapStockCount= new Map<string,integer>();
        List<EON_Order__c> LstOrdersToInsert= new List<EON_Order__c>(); 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        List<Messaging.SingleEmailMessage>  emaillist = new List<Messaging.SingleEmailMessage>(); //Email list of All emails to be sent to CEVA
        try{
	        //Checking EON Stock 
	        for(EON_Stock__c es : [select id, Product_Code__c from EON_Stock__c where Technician_Name__c=:techId and Product_Code__c <> null and Status__c='On Van']){
	            if(mapStockCount.containsKey(es.Product_Code__c))
	                 mapStockCount.put(es.Product_Code__c, mapStockCount.get(es.Product_Code__c)+1);
	                else
	                  mapStockCount.put(es.Product_Code__c, 1);
	        }
	        
	       //Getting data for Technician 
	       objTechnician =[select id,Name,h_Send_to_CEVA__c,Initial_Stock_Pickup_Location__c,Start_Date__c,KID__c,Mobile__c from EON_Technician__c where Date_left__c=null and h_IsProcessed__c=false and id=: techId];
	       
	           //Email Content
	           sendTo.add(System.Label.EON_Ceva_Initial_Order_Email);
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
	        
	           //Calculating product Count to be send.   
	           for(Profile_Product__c pd :[select id,Max_Level__c,Product__c,Product__r.Name,Product__r.Product_Description__c from Profile_Product__c where Stock_Profile__c=:stockId and Active__c=true]){
		           productQnty =0;
		           if(!EON_Utility.validateRequired(pd.Max_Level__c) && !EON_Utility.validateRequired(pd.Product__c)){
			          if(mapStockCount.containsKey(pd.Product__r.Name)){
			        	  if(pd.Max_Level__c>= mapStockCount.get(pd.Product__r.Name))
			        	      productQnty = pd.Max_Level__c-mapStockCount.get(pd.Product__r.Name);
			        	 }
			        	  else 
			        	     productQnty = pd.Max_Level__c;
		       }
		        	           
	        	 if(productQnty>0){
	        	 	orderSent = true;
	        	 	body+='<tr><td align="Left">'+objTechnician.name+'</td><td align="Left">'+objTechnician.KID__c+'</td><td align="Left">'+objTechnician.Mobile__c+'</td><td align="Left">'+pd.Product__r.Name+'</td><td align="Left">'+pd.Product__r.Product_Description__c+'</td><td align="Left">'+productQnty+'</td><td align="Left">'+checknullDate(objTechnician.Start_Date__c)+'</td></tr>';
	                EON_Order__c order =new EON_Order__c();
	                order.Date_Required__c= objTechnician.Start_Date__c;
	                order.Mobile__c= objTechnician.Mobile__c;
	                order.Order_Date__c=objTechnician.h_Send_to_CEVA__c;
	                order.Product_Code__c=pd.Product__c;
	                order.Product_Description__c=pd.Product__r.Product_Description__c;
	                order.Quantity_Required__c=string.valueOf(productQnty);
	                order.Technician_Name__c=objTechnician.id;
	                LstOrdersToInsert.add(Order);
	        	 } 
	        }
	      
	          if(orderSent){
		      	 body+= '</table>'+'<br/>';                      
		      	 body+='Kind regards'+'<br/>';
		      	 body+='MORRISON UTILITY SERVICES'+'<br/>';          
		      	 mail.setHtmlBody(body);
		         Messaging.EmailFileAttachment AttachmentFile = new Messaging.EmailFileAttachment();
		         List<Attachment> att = new List<Attachment>();
		         att =[SELECT id, Name, Body FROM Attachment WHERE ParentID = : objTechnician.id AND name like 'MUS New Starter Kit%' limit 1];
		         //Attachment is attached to Email
		         if(att!=null && att.size()>0 ) {
		            AttachmentFile = new Messaging.EmailFileAttachment();
		            AttachmentFile.setFileName(att[0].name);
		            AttachmentFile.setBody(att[0].Body);     
		            Integer fileSize = att[0].body.size()/1000; 
		           //checking the file Size of attachment (less than 3MB)
		            if(fileSize <= 2800 && EON_Ceva_Initial_Van_Stock_Order_Test.genException==false){
		              List<Messaging.EmailFileAttachment> AttachmentList = new List<Messaging.EmailFileAttachment>();
		              AttachmentList.add(AttachmentFile);
		              mail.setFileAttachments(AttachmentList);        
		              emaillist.add(mail);
		              insert LstOrdersToInsert;
		              objTechnician.h_Stock_Required_Date__c=DateRequired;
		              objTechnician.h_IsProcessed__c=true; // processed successfully
		              update objTechnician;    
		              }           
		              else{
		                   objTechnician.h_Send_to_CEVA__c=null; objTechnician.h_Order_Sent__c=false; update objTechnician;
		                   Response='The Attachment MUS New Starter Kit is exceeding the Size limit of 3MB, Please check once and try again';                               
		              }
		         }
		         else{
		         	 objTechnician.h_Stock_Required_Date__c=DateRequired;
		             objTechnician.h_IsProcessed__c=true;
		             update objTechnician;                           
		             insert LstOrdersToInsert;
		             emaillist.add(mail);                                          
		          }
		        if(emaillist !=null && emaillist.size()>0)
		            Messaging.sendEmail(emaillist);
		      }
		       else
	             Response ='Products are in Stock, No Order has been send to CEVA';
	         return Response;
        }
        catch(Exception e){ 
            return e.getMessage()+'\n'+e.getStackTraceString()+'\n'+e.getLineNumber();
        }
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