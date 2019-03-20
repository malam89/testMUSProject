/**
    Description : This class is used to cancel the Activities in OFSC.
**/

/*
    Created By      : Akshay B
    Created Date    : 06-Aprl-2016
    Service Request : SR_EON_Scheduling_008
    
    Change History:
    CH01 # SR_EON_AB_075 # 16/June/2016 # Praveen G # Updated the error message.
    CH02 # SR_EON_AB_162 # 10/10/2016 # Puneet Mehta #  Changed the message when the Appointment is already cancelled in OFSC
	CH03 # SR_EON_AB_188 # 11/11/2016 # Mahadev J #  Change for synch call to OFSC  
*/

global with sharing class EON_Cancel_Activity_OFSC{

    public static string toaDateFormat = 'yyyy-MM-dd';
    public static string dateFormat = 'dd-MM-yyyy';
    public static Oracle_Data_Tracker__c requestOut;

    /**
        cancelActivitiesInOFSC(String AppointmentID) - This method is called from send to Oracle button on task record.
                      is used to send tasks as cancelled to OFSC.
    **/
    webservice static String cancelActivitiesInOFSC(String AppID){
        String requestXML = '';
        //Request Elements.
        EON_OFSC_Inbound_WS.UserElement userElement = getUserElement();
        EON_OFSC_Inbound_WS.HeadElement headerElement = getHeaderElement();
        system.debug('----AppID>>'+AppID);
        List<String> lstActiviyIds = new List<String>();
        lstActiviyIds.add(AppID);
        return cancelActivities(userElement, headerElement, lstActiviyIds,AppID); 
    }
    /**
        cancelActivities() - This method is used to cancel the activities in OFSC.
    **/
    
    public Static String cancelActivities(EON_OFSC_Inbound_WS.UserElement userElement ,
                                            EON_OFSC_Inbound_WS.HeadElement header, String[] activityIds, String ApptID){ //
        String result = '';
        requestOut = new Oracle_Data_Tracker__c(); // For Tracking request & response
        requestOut.EON_Appointment__c = ApptID;
        //Request Element
        EON_OFSC_Inbound_WS.InboundInterfacePort request = new EON_OFSC_Inbound_WS.InboundInterfacePort();
        EON_OFSC_Inbound_WS.DataElement dataElement = new EON_OFSC_Inbound_WS.DataElement();
        EON_OFSC_Inbound_WS.CommandsArray commands = new EON_OFSC_Inbound_WS.CommandsArray();
        List<EON_OFSC_Inbound_WS.CommandElement> commandElements = new List<EON_OFSC_Inbound_WS.CommandElement>();
        //Response Element
        EON_OFSC_Inbound_WS.InboundInterfaceResponseElement response;
        try{
            requestOut.Command__c = 'Cancel Activity';
            requestOut.Direction__c = 'OUT';
            map<ID,EON_Appointment__c> mapAppt = new map<ID,EON_Appointment__c>([Select ID, Appointment_Key__c from EON_Appointment__c where ID in: activityIds]); //CH03.New
            for(String activity : activityIds){
                EON_OFSC_Inbound_WS.CommandElement commandElement = new EON_OFSC_Inbound_WS.CommandElement();
                commandElement.type_x = 'cancel_activity';
                EON_OFSC_Inbound_WS.AppointmentElement appointmentElement = new EON_OFSC_Inbound_WS.AppointmentElement();
                appointmentElement.appt_number = !EON_Utility.validateRequired(mapAppt.get(activity).Appointment_Key__c) ?  mapAppt.get(activity).Appointment_Key__c : activity.trim(); //CH03.Update
                commandElement.appointment = appointmentElement;
                commandElements.add(commandElement);
            }
            commands.command = commandElements;
            dataElement.commands = commands;
            response = request.inbound_interface(userElement , header , dataElement);
            String strResultCode = '';
            system.debug('###ResponseSize: '+ response);
            system.debug('###ResSize: '+ response.data.commands.command.size());
            if(response != null && response.data.commands.command != null && response.data.commands.command.size() > 0 )
                strResultCode = response.data.commands.command[0].appointment.report.message[0].code;
            List<EON_OFSC_Response_Code__c> responseCode = [select id,name, OFSC_Text__c, Error_Warning_Success__c from EON_OFSC_Response_Code__c where name =: strResultCode AND API__c = 'Inbound'];
            if(!responseCode.isEmpty())
                requestOut.Error_Code__c = responseCode[0].id;
            if(response != null && String.valueof(response).length() > 131072)
                requestOut.Response_Data__c = '' + String.valueof(response).substring(0, 131072);
            else
                requestOut.Response_Data__c = '' + response;
            //if the response got error then revert team's TOA field as it was before.
            if(!responseCode.isEmpty() && (responseCode[0].Name == '0' && responseCode[0].Error_Warning_Success__c != 'error')){
                requestOut.Status__c = 'PASS' ;
                result = 'Activity cancelled in OFSC successfully';
            }else{
                requestOut.Status__c = 'FAIL' ;
                if(!responseCode.isEmpty() && responseCode[0].OFSC_Text__c == 'Appointment not found. cannot cancel')//CH02.NEW
                    result = 'Appointment already cancelled in OFSC';//CH02.NEW
                else //CH02.NEW
                    result = 'Unexpected error. Please contact MUS Back office for more information.';//CH02.NEW
                //result = 'Cancellation request rejected - Appointment already cancelled'; //CH01 amended the message.//CH02.OLD
            }
        }catch(Exception ex){
            String errMsg = '';
            errMsg = ex.getMessage() + ex.getStackTraceString() + '\n' + response;
            system.debug('####ErrorOFSC'+errMsg);
            if(errMsg.length() > 131072)
            requestOut.Response_Data__c = errMsg.substring(0, 131072);
            else
            requestOut.Response_Data__c = errMsg;
            requestOut.Status__c = 'FAIL' ;
            result = 'Exception Occured :' + ex.getStackTraceString();
        }
        String requestXML = '' + userElement +'\n\n' +header+'\n\n' +dataElement;
        if(requestXML.length() > 131072)
            requestOut.Request_Data__c = '' + requestXML.substring(0, 131072);
        else
            requestOut.Request_Data__c = '' + requestXML;
        insert requestOut;
        return result;
    }
    /** 
        getUserElement() - This method is used to create userelement.
    **/
    public Static EON_OFSC_Inbound_WS.UserElement getUserElement(){
        EON_OFSC_Inbound_WS.UserElement userElement = new EON_OFSC_Inbound_WS.UserElement();
        userElement.company = System.Label.EON_OFSC_Company;
        userElement.login = System.Label.EON_OFSC_Login;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeDateTime(Datetime.now());            
        // Cope with the formatter returning .123Z as the time zone offset for GMT //
        if (gen.getAsString().length() == 27)
            userElement.now = gen.getAsString().substring(1,26);       
        else
            userElement.now = gen.getAsString().substring(1,20) + '+00:00';
        userElement.auth_string = md5(userElement.now + md5(System.Label.EON_OFSC_Password));
        return userElement;
    }
    /**
        getHeaderElement() - This method is used to created HeaderElement.
    **/
    public static EON_OFSC_Inbound_WS.HeadElement getHeaderElement(){
        EON_OFSC_Inbound_WS.HeadElement headerElement = new EON_OFSC_Inbound_WS.HeadElement();
        headerElement.upload_type = 'incremental';
        headerElement.id = string.valueOf(crypto.getRandomLong());
        headerElement.date_x = datetime.now().format(toaDateFormat);
        headerElement.allow_change_date = 'yes';
        List<string> appointment_key = new List<string>();
        appointment_key.add('appt_number');
        EON_OFSC_Inbound_WS.KeysArray appointment_keys = new EON_OFSC_Inbound_WS.KeysArray();
        appointment_keys.field = appointment_key;
        EON_OFSC_Inbound_WS.AppointmentSettings appointment_settings = new EON_OFSC_Inbound_WS.AppointmentSettings();
        appointment_settings.keys = appointment_keys;
        headerElement.appointment = appointment_settings;
        List<string> inventory_key = new List<string>();
        inventory_key.add('invsn');
        EON_OFSC_Inbound_WS.KeysArray inventory_keys = new EON_OFSC_Inbound_WS.KeysArray();
        inventory_keys.field = inventory_key;
        EON_OFSC_Inbound_WS.InventorySettings inventory_settings = new EON_OFSC_Inbound_WS.InventorySettings();
        inventory_settings.keys = inventory_keys;
        headerElement.inventory = inventory_settings;
        return headerElement;
    }

    /**
        md5(string input_string) - This is Utility method.
    **/
    public static string md5(string input_string){
        blob md = Crypto.generateDigest('MD5', blob.valueOf(input_string));
        string auth_hash = EncodingUtil.convertToHex(md);
        return auth_hash;
    }
}