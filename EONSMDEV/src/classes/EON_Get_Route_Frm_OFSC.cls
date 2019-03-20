/**
    Description : This class is used to get route details from OFSC
	Test Class Name: EON_Get_Route_Frm_OFSC_Test
**/

/*
    Created By      : Akshay Bairagi
    Created Date    : 18-May-2016
    Service Request : SR_EON_AB_046
	CH01 # NA # 24/10/2016 # Mahadev J # Amended login for test coverage
*/

global with sharing class EON_Get_Route_Frm_OFSC{

    public static string toaDateFormat = 'yyyy-MM-dd';
    public static string dateFormat = 'dd-MM-yyyy';
    public static Oracle_Data_Tracker__c requestOut;
    public static EON_OFSC_Activity_WS.activity_response response;
    
    /**
        get_route_Frm_OFSC() - This method is used to get route details from OFSC.

        public EON_OFSC_Activity_WS.activity_response get_route(EON_OFSC_Activity_WS.user_x user_x,String date_x,String resource_id,String[] property_filter,Integer select_from,Integer select_count) 
    **/
    Public static String get_route_Frm_OFSC(Date appt_Date,Id res_ID, String ApptID){ //
        String result = '';
        requestOut = new Oracle_Data_Tracker__c(); // For Tracking request & response
        requestOut.EON_Appointment__c = ApptID;
        String date_x = string.valueof(appt_Date);
        String resource_id = string.valueof(res_ID);
        //Request Element
        EON_OFSC_Activity_WS.activity_binding  request = new EON_OFSC_Activity_WS.activity_binding ();
      
        EON_OFSC_Activity_WS.user_x userElement = getUserElement();
	
        //Response Element
        //EON_OFSC_Activity_WS.activity_response  response;
        try{
            //CH01.Start.New - Generate exception
            if(EON_Get_Route_Frm_OFSC_Test.genException == null)
                EON_Get_Route_Frm_OFSC_Test.genException = false;
            if(EON_Get_Route_Frm_OFSC_Test.genException == true)
                ID test = ID.valueof('test');
            //CH01.End.New
            requestOut.Command__c = 'get_route';
            requestOut.Direction__c = 'OUT';
            list<String> property_filter = new list<String>();
            system.debug('----req--'+userElement+'--'+date_x+'--'+resource_id);
            response = request.get_route(userElement,date_x,resource_id,property_filter,1,100);
            
            String strResultCode = '';
            
            if(response != null && response.result_code != null )
                strResultCode = String.valueof(response.result_code);
                        
            List<EON_OFSC_Response_Code__c> responseCode = [select id,name, Error_Warning_Success__c from EON_OFSC_Response_Code__c where name =: strResultCode AND API__c = 'Activity'];
            
            if(!responseCode.isEmpty())
                requestOut.Error_Code__c = responseCode[0].id;
            if(response != null && String.valueof(response).length() > 131072)
                requestOut.Response_Data__c = '' + String.valueof(response).substring(0, 131072);
            else
                requestOut.Response_Data__c = '' + response;
            
              
            //if the response got error then revert team's TOA field as it was before.
            if(!responseCode.isEmpty() && (responseCode[0].Name == '0'&& responseCode[0].Error_Warning_Success__c != 'error')){
                requestOut.Status__c = 'PASS' ;
                result = 'get_route in OFSC successfully';
            }else{
                requestOut.Status__c = 'FAIL' ;
                result = 'Request can\'t be completed, Please contact your Administrator.';
            } 
                      
        }catch(Exception ex){
            String errMsg = '';
            errMsg = ex.getMessage() + ex.getStackTraceString() + '\n' + response;
            system.debug('----'+errMsg);
			requestOut.Response_Data__c = errMsg.length() > 131072 ? errMsg.substring(0, 131072) : errMsg; //CH01.New
            /*if(errMsg.length() > 131072) //CH01.Old
            requestOut.Response_Data__c = errMsg.substring(0, 131072);
            else
            requestOut.Response_Data__c = errMsg; */
            requestOut.Status__c = 'FAIL' ;
            result = 'Exception Occured :' + ex.getStackTraceString();
        }
        
        String requestXML = '' + userElement+'\n\n'+'date_x:['+date_x+']'+'\n\n'+'resource_id:['+resource_id+']';
        requestOut.Request_Data__c = requestXML.length() > 131072 ? ('' + requestXML.substring(0, 131072)) : ('' + requestXML);
        /*if(requestXML.length() > 131072) //CH01.Old
            requestOut.Request_Data__c = '' + requestXML.substring(0, 131072);
        else
            requestOut.Request_Data__c = '' + requestXML; */
        
        insert requestOut;
        return result;                                                                                                                        
    }        
    /** 
        getUserElement() - This method is used to create userelement.
    **/
    public Static EON_OFSC_Activity_WS.user_x getUserElement(){
        EON_OFSC_Activity_WS.user_x userElement = new EON_OFSC_Activity_WS.user_x();
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
        md5(string input_string) - This is Utility method.
    **/
    public static string md5(string input_string){
        blob md = Crypto.generateDigest('MD5', blob.valueOf(input_string));        
        string auth_hash = EncodingUtil.convertToHex(md);        
        return auth_hash;       
    }       
}