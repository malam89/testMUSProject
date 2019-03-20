/**
    Description : This is a class to send SMS to the customer
    Test Class  : EON_Appointment_SMS_Scheduler_test
**/
/*
    Created By : Aruna Manjari 
    Created On : 16/03/2016
    Service Req: SR_Isis_EON_012
*/

global with sharing class EON_Appointment_SMS_Sender_Helper
{
   // public string trackerId{get;set;} 
   
       /**
        logError(Id isisRecordId,string errorFlag,String errors) - This method is to log error messages.
                     
    **/
    public static void logError(Id isisRecordId,string errorFlag,String errors)
            {
                sObject isisRecord = isisRecordId.getSObjectType().newSobject();
                isisRecord.put('Id',isisRecordId);
                isisRecord.put(errorFlag,true);
                update isisRecord;
                insert new Note(Title='Errors',Body=errors,ParentId=isisRecordId);
            }
    /**
        SMSSender(Id isisRecordId,String message, String phoneNum,String subject,String recipientName,String relatedObj) - This method
        sends out an SMS notification to the specified mobile number. Once done, it logs the request in the SMS Tracker object with all the details.
    **/
    @future(callout=true)
    public static void SMSSender(Id isisRecordId,String message, String phoneNum,String subject,String recipientName,String relatedObj,String contractToCharge)
    {
    
   
            //error log
            try{
            //
            String pnumber = phoneNum.toLowerCase();
            pnumber = pnumber.replaceAll('[\\-_ /().*abcdefghijklmnopqrstuvwxyz~`!@#$%&"<,>.?]','');
            if(!(pnumber.startsWith('0')))
                pnumber = pnumber.replaceFirst('','0');
            if(pnumber.startsWith('0'))
           // pnumber = pnumber.replaceFirst('0','44'); 
            pnumber = pnumber.replaceFirst('0','91');  
            //check for wrong phone numbers
            Pattern p = Pattern.compile('[-() ]');
            String sPhone = p.matcher(phoneNum).replaceAll('');
            //check length without punctuation
            if (sPhone.length() != 10)
            logError(isisRecordId,'Errors__c','The Phonenumber is  less than 10 digit value');
            p = Pattern.compile('\\d');
            sPhone = p.matcher(sPhone).replaceAll('');
            //if (sPhone.length() < 0)
            //logError(isisRecordId,'Errors__c','The Phonenumber is digit value');
            system.debug('$$$$$pnumber$$$$$$$$$'+pnumber+'********Appointment ID**********'+isisRecordId);
            String encodedMSG = EncodingUtil.urlEncode(message, 'UTF-8');
            String url_submitMsg;
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            String strSubject = EncodingUtil.urlEncode(subject, 'UTF-8');
            url_submitMsg = 'https://www.emsoap.net/smsservice.asmx/SendSimpleExtendedMessage?Account=elephant@morrisonus.com.MUS&Password=morri123&Subject='+strSubject+'&UserReference=12345&ReplyType=Collect&ReplyURL=&ReplyEmail=&Scheduled=&DeliveryReceipt=1&Originator=Morrison&Expiry=&MobileCSV='+pnumber+'&MessageBody='+encodedMSG+'';
            req = new HttpRequest();
            req.setEndpoint(url_submitMsg);
            req.setMethod('GET');
            HttpResponse res = http.send(req);
            String ns9 = 'https://www.emsoap.net';
            Dom.Document doc = res.getBodyDocument();
            Dom.XMLNode SendExtendedMessage_Response = doc.getRootElement();        
            Dom.XMLNode Message_StatusNode = SendExtendedMessage_Response.getChildElement('Message_Status',ns9);
            Dom.XMLNode MessageStatusNode = Message_StatusNode.getChildElement('MessageStatus',ns9);
            Dom.XMLNode MessageIDNode = MessageStatusNode.getChildElement('MessageID',ns9);
            Dom.XMLNode resultNode = MessageStatusNode.getChildElement('result',ns9);
            insert new SMS_Tracker__c(Content__c=message,Contract__c=contractToCharge,Date_Time_of_Dispatch__c=System.now(),Message_ID__c=MessageIDNode.getText(),
                                   Recipient_Name__c=recipientName,Recipient_Phone_No__c=pnumber,Related_Object__c=relatedObj,Status__c=resultNode.getText(),
                                   Subject__c=subject,SMS_Count__c=Decimal.valueOf(message.length()).divide(126, 0, System.RoundingMode.CEILING));
           
            
        }
        catch(Exception e)
        {
            System.debug('Eceoption==>'+e.getMessage());
            insert new Note(Title='SMS Technical Failure',Body=e.getStackTraceString(),ParentId=isisRecordId);
        }
    }
    
}