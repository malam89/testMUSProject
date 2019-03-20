/**
    Description : This class is used for utility methods for EON application
**/
/*
    Created by : Praveen G
    Created Date : 24-Feb-2016
    Test Class : EON_Utility_Test
    Change History: 
    CH01 # SR_EON_Jumbo_016 # 22/03/2016 # Purvi # Added a string for static data.
    CH02 # SR_EON_AB_023 # 04/04/2016 # Sivasankar K # Added method for getting the day of week from date time.
    CH03 # SR_EON_Jumbo_013 # 13/04/2016 # Mehboob Alam # Created Jumbo process Name for - Validate MPAN
    CH04 # SR_EON_Jumbo_020 # 20/04/2016 # Purvi # created method callOFSCAppointment
    CH07 # SR_EON_Scheduling_007 # 04/04/2016 # Dharmendra # create OFSC variables
    CH08 # SR_EON_Jumbo_013 # 12/05/2016 Mehboob Alam # Created a static method to covert string into date and to generate a unique random number
    CH09 # SR_EON_AB_050 # 02/06/2016 # Dharmendra Pahadiya # Added method to get the datetime for daylight saving.
    CH10 # SR_EON_PC_076 # 28/06/2016 # Mahadev J # Added method to get ErrorCodes
    CH11 # SR_EON_AB_115 # 16/08/2016 # Sivasankar K # Added the condition for skyping the Job Not Fully Supported error When booking from ABS.
    CH12 # SR_EON_AB_166 # 16/10/2016 # Mahadev J # Added commands related to EON
    CH13 # NA # 24/10/2016 # Mahadev J # Added new method
    CH14 # SR_EON_AB_179 # 27/10/2016 # Puneet Mehta # Added a method to query all fields of any object passed as parameter
    CH15 # NA # 14/03/2017 # Praveen G # Added new method to validate appointment.
    CH16 # SR_EON_Jumbo_106 # 29/03/2017 # Mahadev G # Added new method to send update to OFSC
    CH17 # INCUK0005517628 # 09/05/2017 # Praveen G # Added new util method to identify GMT/BST timezone and return the correct time value
    CH18 # SR_OptiMUS_EON_192 # 25/01/2018 # Praveen G # Added fix for quiuing issue
    CH19 # SR_OptiMUS_EON_214 # 15/02/2018 # Mehboob Alam # Added new method for Smart Meter Type
	CH20 # SR_OptiMUS_EON_297 # 29/01/2019 # Tabish Almas # Added new static variables for MDS
*/
global with sharing class EON_Utility{
    //Static labels
    public final static String RESULT_PASS = 'PASS';
    public final static String RESULT_FAIL = 'FAIL';
    public final static String CMD_JUMBO_CancelEJ = 'Cancel Electricity Job';
    public final static String STATUS_CANCELLED = 'Cancelled';
    public final static String CMD_JUMBO_GASUPDATE = 'Update Gas Job';
    public final static String DIRECTION_IN = 'In';
    public final static String DIRECTION_OUT = 'Out';
    public final static String CMD_EON_GetCapacity = 'Get Capacity';
    public final static String CMD_JUMBO_CancelGJ = 'Cancel Gas Job';
    public final static String CMD_JUMBO_CloseEJ = 'Close Electricity Job';
    public final static String CMD_JUMBO_CloseGJ = 'Close Gas Job'; //CH01
    public final static String CMD_JUMBO_ValidateMPAN = 'Validate MPAN'; //CH03
    public final static String CMD_VOICE_CustomerContact = 'PushCustomerContacts';
    public final static String Op_VOICE_Create = 'Create';
    public final static String Op_VOICE_Update = 'Update';
    public final static String Op_VOICE_Delete = 'Delete';
    public final static String CMD_EON_Create = 'CreateReservation'; //CH12.New
    public final static String CMD_EON_Update = 'UpdateAppointment'; //CH12.New
    public final static String CMD_EON_Confirm = 'ConfirmAppointment'; //CH12.New
    public final static String CMD_EON_Cancel = 'CancelAppointment'; //CH12.New
    public static String OFSCresponse;
    public final static string CMD_OFSC_CreateActivity = 'Create Activity'; //CH07
    public static string CMD_OFSC_UpdateActivity = 'Update Activity'; //CH07
    public final static String CMD_OFSC_GetPhoto = 'Get Photographs';
    public static String appointment_Booking_From = '';//CH11
    //Static labels for MDS
    public final static String CMD_MDS_ValidateMPAN = 'Validate MPAN'; //CH21
    public final static String CMD_MDS_GenerateToken = 'Generate Token'; //CH21
    //Static varaiable to genException 
    public static boolean genException { get; set; }
    /**
        md5(string input_string) = This is genaric method is used to convert the value into MD5 format and used with OFSC API.
    **/
    public static string md5(string input_string){
        blob md = Crypto.generateDigest('MD5', blob.valueOf(input_string));
        string auth_hash = EncodingUtil.convertToHex(md);
        
        return auth_hash;
    }
    /**
        createAttachment(string parentId, string body, String attachmentMane) - This is a utility method to create attachment record for the respective parent record.
    **/
    public static void createAttachment(string parentId, string attachmentBody, String attachmentMane){
        insert new attachment(parentId = parentId, body = Blob.valueOf(attachmentBody), name=attachmentMane +'.txt');
    }
    /**
        validateStringLength(String value) - This method truncates the string if it has more than length of 131070.
    **/
    public static String validateStringLength(String value){
        if(value!= null && value.length() > 131070)
            value = value.subString(0, 131070);
    
        return value;
    }
    /**
        validateRequired(String value) - this method is used to verify if the value is blank or not.
    **/
    public static boolean validateRequired(object value){
       if(value != null && value != '')
           return false;
       return true;
    }
    //CH02.Start
    /**
        getDayOfWeek(Date dt) - this method is used to verify if the value is blank or not.
    **/
    public static String getDayOfWeek (Date myDate) {
        Datetime dt = DateTime.newInstance(myDate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek=dt.format('EEEE');
        return dayOfWeek; 
    }
    //CH02.End
    /**
        callOFSCAppointment(String AppointmentId, string activityType, string eonTrackerId, string jumboTrackerId, string appDate, string appTime, string bookingSystem) - this method is used to make a future call to sendActivityToOFSC.
    **/
    //CH04.START
    @future(callout= true)
    public static void callOFSCAppointment(String AppointmentId, string activityType, string eonTrackerId, string jumboTrackerId, string appDate, string appTime, string bookingSystem) {      
        OFSCresponse = EON_OFSC_Send_Appointment.sendActivityToOFSC(AppointmentId,activityType,eonTrackerId,jumboTrackerId,appDate,appTime,bookingSystem);   
    }
    //CH04.END 
    //CH08.Start
    /**
        genUniqueNum() - this method is used to generate a unique random number.
    **/
    public static string genUniqueNum(){
       return string.valueOf(crypto.getRandomLong()).replace('-','')+String.valueof(DateTime.now()).deleteWhitespace().replace('-','').replace(':','');
    }
    //CH08.End
    /**
        convertStringToNumber(String value) : This is util method to convert string to number.
    **/
    public static integer convertStringToNumber(String value){
        if(value != null || value != ''){
            try{
                return Integer.valueOf(value);
            }catch(exception ex){
                System.debug('Exception occured while converting string to integer ****** : ' + ex.getStackTraceString());
            }
        }
        return null;
    }
    //CH09
    /**
        getNewdatetime(Datetime dt) - This method is used to to add extra hour in datetime for daylight saving.
    **/
    public static Datetime getNewdatetime(Datetime dt){
        DateTime inputDT = dt;
        Integer YearVal = dt.year();
        Date MarchEndDate = date.newInstance(YearVal, 3, 31);
        Date OctEndDate   =  date.newInstance(YearVal, 10, 31);
        Date StartDate = MarchEndDate.toStartofWeek();
        Date EndDate = OctEndDate.toStartofWeek();
        Datetime DaylightStartDt = datetime.newInstance(StartDate.year(), StartDate.month(), StartDate.day(), 01,00,00);
        Datetime DaylightEndDt = datetime.newInstance(EndDate.year(), EndDate.month(), EndDate.day(), 02,00,00);
        // adding an hour if date faling under day light saving.
        if(inputDT>=DaylightStartDt && inputDT<= DaylightEndDt){
            inputDT=inputDT.addHours(1);
            return inputDT;
        }
        else 
            return inputDT;
    }
    //CH10.New.Start
    /**
        getErrorCode(Exception ex) - This class will get Exception as input paramter and based upon exception type, it will return instance of 'EON_Error_Code__c'
    **/
    public EON_Error_Code__c getErrorCode(Exception ex){
        list<String> allErrorName = new list<String>();
        String ErrorName = ex.getTypeName();
        ErrorName = ErrorName.removeStart('System.');
        allErrorName.add(ErrorName);
        allErrorName.add('UnknownError');
        EON_Error_Code__c errorCode = new EON_Error_Code__c();
        list<EON_Error_Code__c> allErrorCode = new list<EON_Error_Code__c>();
        allErrorCode = [Select ID, Name, Error_Name__c, Type__c, Description__c from EON_Error_Code__c where Error_Name__c =: allErrorName];
        //Return Name specific error code
        for(EON_Error_Code__c code: allErrorCode){
            if(code.Error_Name__c == ErrorName){return code;}
        }
        //Return 'Unknown' if no error code found
        for(EON_Error_Code__c code: allErrorCode){
            if(code.Error_Name__c == 'UnknownError')
                return code;
        }
        return errorCode;
    }
    /**
        getErrorCode(String type) - This class will get Exception type as input paramter and it will return instance of 'EON_Error_Code__c'
    **/
    public EON_Error_Code__c getErrorCode(String type){
        system.debug('###Errrrrrr: '+type);
        list<String> allErrorCode = new list<String>();//Collect Error Code
        allErrorCode.add(type);
        allErrorCode.add('100');
        list<String> allErrorName = new list<String>();//Collect Error Name
        allErrorName.add(type);
        allErrorName.add('UnknownError');
        EON_Error_Code__c errorCode = new EON_Error_Code__c();
        list<EON_Error_Code__c> allErrorCodes = new list<EON_Error_Code__c>();
        allErrorCodes = [Select ID, Name, Error_Name__c, Type__c, Description__c from EON_Error_Code__c where Name =: allErrorCode or Error_Name__c=: allErrorName];
        system.debug('####ErrorCodes: '+allErrorCodes);
        //Return Code specific error code
        for(EON_Error_Code__c code: allErrorCodes){
            if(code.Name == type)
                return code;
        }
        //Return Name specific error code
        for(EON_Error_Code__c code: allErrorCodes){
            if(code.Error_Name__c == type)
                return code;
        }
        //Return 'Unknown' if no error code found
        for(EON_Error_Code__c code: allErrorCodes){
            if(code.Name == '100')
                return code;
        }
        return errorCode;
    }
    //CH10.New.End
    //CH13.New.Start
    /**
        getLongText(): This method will return string with more than 131072 characters
    **/
    public static String getLongText(){
        String str = '';
        for(Integer i=0;i<=132;i++){
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
            str += 'TestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTestDataTest';
        }
        return str;
    }
    //CH13.New.End
    //CH14.START
    public static List < sObject > getAllFields(List < sObject > sObjects, Schema.SObjectType objectType, List <String> relationFields) {
        List < Id > sObjectIds = new List < Id > {};
        List < String > sObjectFields = new List < String > {};
        List < sObject > allFieldsSObjects = new List < sObject > {};
        if (objectType != null) {
            sObjectFields.addAll(objectType.getDescribe().fields.getMap().keySet());
        }
        if (sObjects != null || !(sObjects.isEmpty()) || sObjectFields.isEmpty()) {
            for (sObject objectInstance: sObjects) {
                sObjectIds.add(objectInstance.Id);
            }
            String allSObjectFieldsQuery = 'SELECT ' + sObjectFields.get(0);
            for (Integer i = 1; i < sObjectFields.size(); i++) {
                if(objectType.getDescribe().fields.getMap().get(sObjectFields.get(i)).getDescribe().isUpdateable())
                    allSObjectFieldsQuery += ', ' + sObjectFields.get(i);
            }
            for (Integer i = 0; i < relationFields.size(); i++) {
                allSObjectFieldsQuery += ', ' + relationFields.get(i);
            }
            allSObjectFieldsQuery += ' FROM ' + objectType.getDescribe().getName() + ' WHERE ID IN (\'' + sObjectIds.get(0) + '\'';
            for (Integer i = 1; i < sObjectIds.size(); i++) {
                allSObjectFieldsQuery += ', \'' + sObjectIds.get(i) + '\'';
            }
            allSObjectFieldsQuery += ') order by Id';
            try {for (SObject sObjectFromDatabase: Database.query(allSObjectFieldsQuery)) {allFieldsSObjects.add(sObjectFromDatabase);}} catch (exception e) {}
        }
        return allFieldsSObjects;
    }
    //CH14.END
    
    
    /**
        convertStringToNumber(String value) : This is util method to convert string to number.
    **/
    public static Decimal convertStringToDecimal(String value){
        if(value != null || value != ''){
            try{
                return Decimal.valueOf(value);
            }catch(exception ex){
                System.debug('Exception occured while converting string to integer ****** : ' + ex.getStackTraceString());
            }
        }
        return null;
    }
    
    //CH15.Start
    /**
        validateAppointmentStatus(String appName) -  this method is used to validate the appointment status to allow update.
    **/
    public static boolean validateAppointmentStatus(String appName){
        Eon_Appointment__c[] appRec = [select Status__c from Eon_Appointment__c where name =: appName];
        if(!appRec.isEmpty()){
             if(appRec[0].Status__c != null && (appRec[0].Status__c.equalsIgnoreCase('SCHEDULED') ||
                                              appRec[0].Status__c.equalsIgnoreCase('ASSIGNED') || 
                                              appRec[0].Status__c.equalsIgnoreCase('DRAFT')) ) 
                return false;
        } 
           
        return true;                                                
    }
    //CH15.End  
    
    //CH16.Start 
    /**
        getInstanceURL() - This method is used to get the instance domin url.
    **/    
    public static String getInstanceURL() {
    
            String protocolAndHost = '';
            /*
            //memoize
            String orgId = UserInfo.getOrganizationId();
            String userId = UserInfo.getUserId();
            String sessionId = UserInfo.getSessionId();

            //use getSalesforceBaseUrl within batches and schedules (not Visualforce), and fix inconsistent protocol
            if (sessionId == null) return Url.getSalesforceBaseUrl().toExternalForm().replace('http:', 'https:');

            PageReference pr = new PageReference('/id/' + orgId + '/' + userId);
            pr.getParameters().put('oauth_token', sessionId);
            pr.getParameters().put('format', 'json');

            //within test context use url class, else derive from identity api
            String data = Test.isRunningTest() ? '{"urls": {"rest": "' + Url.getSalesforceBaseUrl().toExternalForm() + '"}}' : pr.getContent().toString();
            Map<String,Object> result = (Map<String,Object>)Json.deserializeUntyped(data);
            Map<String,Object> urls = (Map<String,Object>)result.get('urls');
            Url rest = new Url((String)urls.get('rest'));
            protocolAndHost = rest.getProtocol() + '://' + rest.getHost();
            */
            String orgInstance = [Select InstanceName FROM Organization limit 1][0].InstanceName; // Returns CS17 for example.
            
            protocolAndHost = 'https://' + orgInstance.toLowerCase() + '.salesforce.com';            
            return protocolAndHost;
    
    }    
    
    //CH16.end     
    // CH16.Start
    /**
        updateOFSCAppointment(): Update at OFSC //CH16.New
    **/
    
    @future(callout = true)
    public static void updateOFSCAppointment(list<ID> apptID){
        list<EON_Appointment__c> allAppt = new list<EON_Appointment__c>();
        if(apptID != null && apptID.size() > 0){
          allAppt = [Select ID, Name from EON_Appointment__c where ID =: apptID];    
            for(EON_Appointment__c appt:allAppt){
                String result = EON_OFSC_Update_Appointment.getAppointment(appt.Name);
                if(result != 'Appointment Exists'){
                    EON_Appointment__c appointment = EON_OFSC_Update_Appointment.objAppt1;
                    if(appointment != null)
                      OFSCresponse =  EON_OFSC_Update_Appointment.sendActivityToOFSC(appointment, new list<EON_Appointment_Contact__c>(), new list<EON_Appointment_Vulnerability__c>(), appointment.Booking_System_Name__c);                
                }
            }
        }
    }
    
    //CH16.New
    
    //CH17.Start   
    /** 
        validateTimeBST(DateTime GMTTime) - new util method to identify GMT/BST timezone and return the correct time value
    **/   
    public static DateTime validateTimeBST(DateTime GMTTime){
    
        Datetime myDateTimeLocal = DateTime.newInstance(1970,1,1);
        Datetime myDateTimeGMT = DateTime.newInstanceGMT(1970,1,1);   
        
        Long myLongLocal = myDateTimeLocal.getTime();
        Long myLongGMT = myDateTimeGMT.getTime(); 
        
        Long hoursDiff = (myLongLocal - myLongGMT) / 60 / 60 / 1000;
        
        if(hoursDiff < 0 && GMTTime != null)
            return GMTTime.addHours(1);
        else     
            return GMTTime;
    }
    //CH17.End   
    
     //CH18.Start
     public static String isAppointmentFoundForCommissioning(String Req, String subject){
        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String toaNS = 'urn:toatech:agent';
        String appointmentID = '';
        
        Dom.Document docx = new Dom.Document();
        docx.load(req);
        dom.XmlNode xroot = docx.getrootelement(); 
        Dom.Document domRequest=new Dom.Document();
        domRequest.load(req.unescapeXml().replace('&', '&amp;'));            
        Dom.XmlNode envelope=domRequest.getRootElement(); 
        
        req = req.unescapeXml();
        string bodyStartNode = '';
        if(subject=='ConfigureSMSAsset')bodyStartNode='SMSAssetConfiguration'; 
        if(subject=='ValidateSMSAsset')bodyStartNode='SMSAssetValidation';  
        if(subject=='UnConfigureSMSAsset')bodyStartNode='UnConfigureSMSAsset';
        if(subject=='SubmitCreditMeterReading')bodyStartNode='CreditMeterReading';
        if(subject=='SubmitPrePayBalance')bodyStartNode='PrePayMeterBalance';      
         
        dom.XmlNode[] Header = envelope.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElement(bodyStartNode, toaNS).getChildElements();//'CreditMeterReading'
        string appId = Header[0].getChildElement('OrgId', toaNS).gettext();
        list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>(
                                            [select id, name from EON_Appointment__c where name =: appId]);          
        if(!lstApp.isEmpty() && lstApp.size()>0){
            appointmentID = lstAPP[0].ID;
        }
        return appointmentID;
     }
         
     //CH18.End
     
     
     //CH19.Start
     /**
     smartMeterModel(string fType, string mType, string Manufacturer, string model): This method will return mapping for New E Meter Type to Jumbo //CH07
    **/
    public static string smartMeterModel(string fType, string mType, string Manufacturer, string model){
        List<EON_Smart_Meter_Model__c> lstSMM = new List<EON_Smart_Meter_Model__c>();
        if(!EON_Utility.validateRequired(mType)){
           if(mType=='MS1'){
             if(!EON_Utility.validateRequired(Manufacturer) && !EON_Utility.validateRequired(model))
                lstSMM =[select id,Jumbo_Type__c from EON_Smart_Meter_Model__c where Fuel__c=:fType and Meter_Type__c=:mType and Manufacturer__c=:Manufacturer 
                         and Model__c=:model limit 1]; 
           }                     
             else
               lstSMM =[select id,Jumbo_Type__c from EON_Smart_Meter_Model__c where Fuel__c=:fType and Meter_Type__c=:mType limit 1];
        }
           
           if(lstSMM.size()==1) 
              return lstSMM[0].Jumbo_Type__c;
              else 
              return null;
    } 
    //CH19.End        
}