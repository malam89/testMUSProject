/**
    Description : This class is used to create a new user for technician in OFSC 
    Test Class : EON_OFSC_Technician_User_Handler_Test
**/

/*
    Created By : Praveen G
    Created Date : 28-June-2018
    Service Request : SR_EON_Scheduling_034
    
    CHANGE HISTORY :
    CH01 #SR_EON_Scheduling_043 # 03/08/2016 # Praveen G # added new property for password.
    CH02 #SR_EON_Scheduling_049 # 10/11/2016 # Praveen G # added employee type for 'type' property.
    CH03 #SR_EON_Scheduling_051 # 01/12/2016 # Praveen G # added main_resource_id property.    
*/
public with sharing class EON_OFSC_Technician_User_Handler{

    /**
        CreateOFSCUserForTechnician(String technicianName, String technicianID, String employeeType ) - 
                            This method is used to create user for the technician sending to OFSC.
    **/
    
    public static String[] CreateOFSCUserForTechnician(String technicianName, String technicianID, String employeeType ){
        EON_OFSC_Resource_Management_3_WS.AuthNodeElement user_x = getAuthenticationElement();
        EON_OFSC_Resource_Management_3_WS.ResourceIdListElement resources = new EON_OFSC_Resource_Management_3_WS.ResourceIdListElement();
        EON_OFSC_Resource_Management_3_WS.PropertyElement propertyElement = new EON_OFSC_Resource_Management_3_WS.PropertyElement();        
        List<EON_OFSC_Resource_Management_3_WS.PropertyElement> lstPropertyElement = new List<EON_OFSC_Resource_Management_3_WS.PropertyElement>();
        EON_OFSC_Resource_Management_3_WS.PropertiesElement propertiesElement = new EON_OFSC_Resource_Management_3_WS.PropertiesElement();                                 
        
        List<String> lstResponseArray = new List<String>();
        String strRequest = '';
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort request = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort(); 
        EON_OFSC_Resource_Management_3_WS.SetUserResponseElement response = new EON_OFSC_Resource_Management_3_WS.SetUserResponseElement();                                                                
        
        try{
            propertyElement = new EON_OFSC_Resource_Management_3_WS.PropertyElement();
            propertyElement.name = 'status';
            propertyElement.value = 'active';
            lstPropertyElement.add(propertyElement);
            
            propertyElement = new EON_OFSC_Resource_Management_3_WS.PropertyElement();
            propertyElement.name = 'password';
            propertyElement.value = EON_Utility.md5('Password1'); //Temporary password.
            lstPropertyElement.add(propertyElement);
            
            //CH01.Start
            propertyElement = new EON_OFSC_Resource_Management_3_WS.PropertyElement();
            propertyElement.name = 'password_temporary';
            propertyElement.value = 'yes';
            lstPropertyElement.add(propertyElement);            
            //CH01.End              
            
            propertyElement = new EON_OFSC_Resource_Management_3_WS.PropertyElement();
            propertyElement.name = 'name';
            propertyElement.value = technicianName; 
            lstPropertyElement.add(propertyElement); 
            
            propertyElement = new EON_OFSC_Resource_Management_3_WS.PropertyElement();
            propertyElement.name = 'language';
                propertyElement.value = 'en';
            lstPropertyElement.add(propertyElement);
            
            propertyElement = new EON_OFSC_Resource_Management_3_WS.PropertyElement();
            propertyElement.name = 'time_zone';
            propertyElement.value = 'Western Europe'; 
            lstPropertyElement.add(propertyElement);  
            
            propertyElement = new EON_OFSC_Resource_Management_3_WS.PropertyElement();
            propertyElement.name = 'type';
            propertyElement.value = employeeType; //CH02
            lstPropertyElement.add(propertyElement);  
            
            //CH03.Start
            propertyElement = new EON_OFSC_Resource_Management_3_WS.PropertyElement();
            propertyElement.name = 'main_resource_id';
            propertyElement.value = technicianID; 
            lstPropertyElement.add(propertyElement);                    
            //CH03.Start
            
            propertiesElement.property = lstPropertyElement;
            
            List<String> lstID = new List<String>();
            lstID.add(technicianID);
            resources.id = lstID; 
                    
            strRequest = user_x + '\n' + technicianName + '\n' + propertiesElement + '\n' +  resources + '\n'; 
            response = request.insert_User(user_x, technicianName, propertiesElement, resources);  
            
            lstResponseArray.add(strRequest);
            lstResponseArray.add(((response!=null) ? (response+'') : ''));                                      
        }Catch(Exception ex){
            System.debug('***** ' + ex.getStackTraceString());
            lstResponseArray.add(strRequest);
            lstResponseArray.add(((response!=null) ? (response+'') : '') + ex.getStackTraceString());                        
        }                
        
        if(response != null && response.result_code != null)
            lstResponseArray.add(String.valueOf(response.result_code));
                     
        return lstResponseArray;
        
    }
    
    /**
        DeleteOFSCUserForTechnician(EON_OFSC_Resource_Management_3_WS.AuthNodeElement user_x, String technicianName) - 
                    This method is used to delete the user related to the technician sending to OFSC.
    **/
    public static String[] DeleteOFSCUserForTechnician(String technicianName){    
        EON_OFSC_Resource_Management_3_WS.AuthNodeElement user_x = getAuthenticationElement();                    
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort request = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort(); 
        EON_OFSC_Resource_Management_3_WS.SetUserResponseElement response = new EON_OFSC_Resource_Management_3_WS.SetUserResponseElement();                                                                
        List<String> lstResponseArray = new List<String>();
        String strRequest = '';
        try{
            strRequest = user_x + '\n' + technicianName + '\n';
            response = request.delete_user(user_x, technicianName);
        }catch(Exception ex){
            System.debug('***** ' + ex.getStackTraceString());
            lstResponseArray.add(strRequest);
            lstResponseArray.add(((response!=null) ? (response+'') : '') + ex.getStackTraceString());            
        }
        
        if(response != null && response.result_code != null)
            lstResponseArray.add(String.valueOf(response.result_code));        
        return lstResponseArray;   
    } 
    
    /**
        getAuthenticationElement() - This method is used to prepare authentication element to pass to OFSC
    **/
    public static EON_OFSC_Resource_Management_3_WS.AuthNodeElement getAuthenticationElement(){
        EON_OFSC_Resource_Management_3_WS.AuthNodeElement authNodeElement = new EON_OFSC_Resource_Management_3_WS.AuthNodeElement();
        //Create Authentication node with parameters
        //authNodeElement.company = 'MUS-SMB2.TEST';
        authNodeElement.company = System.Label.EON_OFSC_Company;
        authNodeElement.login = System.Label.EON_OFSC_Login;
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeDateTime(Datetime.now());
        
        //Cope with the formatter returning .123Z as the time zone offset for GMT
        if (gen.getAsString().length() == 27)authNodeElement.now = gen.getAsString().substring(1,26);
        else
            authNodeElement.now = gen.getAsString().substring(1,20) + '+00:00';

        authNodeElement.auth_string = EON_Utility.md5(authNodeElement.now + EON_Utility.md5(System.Label.EON_OFSC_Password));        
        return authNodeElement;
    }                        
}