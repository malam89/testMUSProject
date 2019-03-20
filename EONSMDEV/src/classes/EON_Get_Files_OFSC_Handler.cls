/**
    description : This class is used to get the files from OFSC.
**/
public class EON_Get_Files_OFSC_Handler{
    
    public static void getFilesFromOFSC(){
        EON_OFSC_Activity_WS.User_X userElement = EON_Get_Files_OFSC_Handler.getUserElement();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.get_file_response_element response = null;
        String entity_id = '70';
        String property_id = '478';
        system.debug('@@@ userElement: '+ userElement);
        system.debug('@@@ entity_id: '+ entity_id);
        system.debug('@@@ property_id: '+ property_id);
        system.debug('@@@ res: '+request.get_file(userElement, entity_id, property_id));
        response = request.get_file(userElement, entity_id, property_id);
        system.debug('@@@ response: '+ response);
    }
    
    /**
    getUserElement() - This method is used to get the user information w.r.to OFSC    
    **/
    public static EON_OFSC_Activity_WS.User_X getUserElement(){
        EON_OFSC_Activity_WS.User_X userElement = new EON_OFSC_Activity_WS.User_X();
        userElement.company = System.Label.EON_OFSC_Company;
        userElement.login = 'soap';
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
    md5(string input_string) - Utility method    
    **/
    public static string md5(string input_string){
        blob md = Crypto.generateDigest('MD5', blob.valueOf(input_string));        
        string auth_hash = EncodingUtil.convertToHex(md);        
        return auth_hash;       
    } 
}