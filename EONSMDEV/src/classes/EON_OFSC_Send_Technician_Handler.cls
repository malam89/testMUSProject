/**
    Description : This class is used to transfer Technician information from Isis to OFSC.
**/

/*
    Created By : Praveen G
    Created Date : 24-Feb-2016
    Service Request : SR_EON_Scheduling_001
    Test class : EON_OFSC_Send_Technician_Handler_Test
    
    Change History: 
    CH01 # SR_EON_AL_003 # 16/03/2016 # Shruti Moghe # updated the field API Date_Started__c to Start_Date__c
    CH02 # SR_EON_PC_016 # 28/03/2016 # Purvi # Changed API name of OFSC_Response_Code__c Objects.
    CH03 # SR_EON_Scheduling_030 # 04/05/2016 # Tashika # Changed the mapping of value of parentId.   
    CH04 #SR_EON_Scheduling_032 # 04/05/2016 # Pedda Reddeiah # added code to achieve SR functionality 
    CH05 #SR_EON_Scheduling_034 # 28/06/2016 # added code to create a user for the technician. 
    CH06 #SR_EON_Scheduling_042 # 02/08/2016 # Praveen G # added new property and another method to update the technician info.
    CH07 #SR_EON_Scheduling_045 # 30/08/2016 # added code new method to send locatio details to OFSC 
    CH08 #SR_EON_Scheduling_049 # 10/11/2016 # updated method signature and added employee type. 
    CH09 #SR_EON_Scheduling_054 # 15/02/2017 # Send workskils as null to OFSC
	CH10 # CheckMark # 08/2/2018 # Abhilash # Code improvement
*/
global with sharing class EON_OFSC_Send_Technician_Handler{
    
    
    /**
        sendTechnicianToOFSC(String technicianID) - This method is used to send Technician information to OFSC.
    **/
    webservice static String sendTechnicianToOFSC(String technicianID){
        String result = '';
        String strRequest = '';
        EON_OFSC_Resource_Management_WS.SetResourceResponseElement response = new EON_OFSC_Resource_Management_WS.SetResourceResponseElement();
        try{
            //Request elements to OFSC
            EON_OFSC_Resource_Management_WS.AuthNodeElement authNodeElement  = EON_OFSC_Send_Technician_Handler.getAuthenticationElement();        
            EON_OFSC_Resource_Management_WS.UsersLoginList userLogin = new EON_OFSC_Resource_Management_WS.UsersLoginList();  
            //EON_OFSC_Resource_Management_WS.WorkSkillList workskills = new EON_OFSC_Resource_Management_WS.WorkSkillList();
            EON_OFSC_Resource_Management_WS.PropertyElement propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();        
            List<EON_OFSC_Resource_Management_WS.PropertyElement> lstPropertyElement = new List<EON_OFSC_Resource_Management_WS.PropertyElement>();
            EON_OFSC_Resource_Management_WS.PropertiesElement propertiesElement = new EON_OFSC_Resource_Management_WS.PropertiesElement();                        
            
            EON_Technician__c technician = [select id, Name, Sent_to_OFS__c,// Date_Started__c //CH01.old
                                             Start_Date__c, Date_Left__c, Mobile__c, Email__c, Work_Zone__c 
                                             , Vehicle_Reg__c //CH06
                                             ,Employee_Type__c // CH08
                                             from EON_Technician__c where id =: technicianID];//CH01.new
            
            String isTechnicianActive = 'inactive';
            system.debug('******technician details******'+technician);
            
            if(//technician.Date_Started__c <= System.today() && //CH01.old
                technician.Start_Date__c <= System.today() &&
                    (technician.Date_Left__c == null || technician.Date_Left__c >= System.today())){ //CH01.new
                isTechnicianActive = 'active';
            } 
            
            //Request and Response element from OFSC
            EON_OFSC_Resource_Management_WS.ResourceManagementPort request = new EON_OFSC_Resource_Management_WS.ResourceManagementPort();                             
                    
            if(technician.Sent_to_OFS__c == null){   
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'status';
                propertyElement.value = isTechnicianActive;
                lstPropertyElement.add(propertyElement);
                //CH03.Start
                Eon_WorkZoneMapping__c workZoneMap;
                String valueWorkZone = '';
                if(technician.Work_Zone__c!=null && technician.Work_Zone__c !='' && Eon_WorkZoneMapping__c.getInstance(technician.Work_Zone__c)!=null ){
                    workZoneMap = Eon_WorkZoneMapping__c.getInstance(technician.Work_Zone__c);
                    valueWorkZone = workZoneMap.Parent_id__c;
                    system.debug('******Workzone parent id value *******:'+valueWorkZone);
                }
                //CH03.End
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'parent_id';
                propertyElement.value = valueWorkZone; //CH03
                lstPropertyElement.add(propertyElement);     
        
                
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'type';
                propertyElement.value = 'TE';
                lstPropertyElement.add(propertyElement); 
                
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'name';
                propertyElement.value = technician.Name; 
                lstPropertyElement.add(propertyElement); 
                
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'mobile';
                propertyElement.value = technician.Mobile__c; 
                lstPropertyElement.add(propertyElement); 
                
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'email';
                propertyElement.value = technician.Email__c; 
                lstPropertyElement.add(propertyElement);                                            
                
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'language';
                propertyElement.value = 'en';
                lstPropertyElement.add(propertyElement);
                
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'time_zone';
                propertyElement.value = 'Western Europe'; 
                lstPropertyElement.add(propertyElement);  
                
                //CH06.Start
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'XA_VEHICLE_PLATE';
                propertyElement.value = technician.Vehicle_Reg__c; 
                lstPropertyElement.add(propertyElement);                  
                //CH06.End   
                
                propertiesElement.property = lstPropertyElement;
                
                strRequest = authNodeElement + '\n' + technicianID + '\n' + propertiesElement + '\n' + userLogin + '\n' + null + '\n'; // CH09
                
                response = request.insert_resource(authNodeElement, technicianID, propertiesElement, userLogin, null); 
                result = 'Technician sent to OFSC, please verify the related data tracker record';  
                //CH05.start
                if(response != null && String.valueOf(response.result_code) == '0'){
                    String[] lstResponseArray = EON_OFSC_Technician_User_Handler.CreateOFSCUserForTechnician(
                                                        technician.Name, technicianID, technician.Employee_Type__c);               
                    
                    //CH07.Start
                    String[] lstLocationResponseArray = sendTechnicianLocationToOFSC(technicianID);
                    //CH07.End
                                        
                    createOFSCTrackerForUser(lstResponseArray, technicianID);
                    createOFSCTrackerForUser(lstLocationResponseArray, technicianID);                    
                }
                //CH05.End
            }else{
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'status';
                propertyElement.value = isTechnicianActive;
                lstPropertyElement.add(propertyElement);   
                propertiesElement.property = lstPropertyElement;
                strRequest = authNodeElement + '\n' + technicianID + '\n' + propertiesElement + '\n' + userLogin + '\n' + null + '\n'; // CH09
                
                response = request.update_resource(authNodeElement, technicianID, propertiesElement, userLogin, null); 
                result = 'Technician sent to OFSC, please verify the related data tracker record';//CH04    
                
                //CH05.start
                if(response != null && String.valueOf(response.result_code) == '0'){
                    String[] lstResponseArray =  EON_OFSC_Technician_User_Handler.DeleteOFSCUserForTechnician(technician.Name);
                    createOFSCTrackerForUser(lstResponseArray, technicianID);
                }   
                //CH05.End                         
            }
            createOFSCTracker(response, strRequest, technicianID, '');
           
        }Catch(Exception ex){
            System.debug('***** ' + ex.getStackTraceString());
            result = 'Exception occured and the Technician information cannot be sent to OFSC';
            createOFSCTracker(response, strRequest, technicianID, (ex.getStackTraceString() + ex.getMessage()));
        } 
        
        return result;   
    }
    
    
    
    //CH07.Start
    
    /**
        sendTechnicianLocationToOFSC(String technicianID) - This method is used to send Technician information for the location 
                    details to OFSC.
    **/
    webservice static String[] sendTechnicianLocationToOFSC(String technicianID){
        String result = '';
        String strRequest = '';
        
        List<String> lstResponseArray = new List<String>();
        EON_OFSC_Resource_Management_WS.SetLocationsResponseElement response = new EON_OFSC_Resource_Management_WS.SetLocationsResponseElement();
        try{
            //Request elements to OFSC
            EON_OFSC_Resource_Management_WS.AuthNodeElement authNodeElement  = EON_OFSC_Send_Technician_Handler.getAuthenticationElement();        
            EON_OFSC_Resource_Management_WS.LocationList lstLocation = new EON_OFSC_Resource_Management_WS.LocationList();
            List<EON_OFSC_Resource_Management_WS.LocationElement> lstlocationelement = new List<EON_OFSC_Resource_Management_WS.LocationElement>();
            EON_OFSC_Resource_Management_WS.LocationElement locationElement = new EON_OFSC_Resource_Management_WS.LocationElement();
            
            List<EON_OFSC_Resource_Management_WS.TextPropertyElement> lstPropertyElement = new List<EON_OFSC_Resource_Management_WS.TextPropertyElement>();
            EON_OFSC_Resource_Management_WS.TextPropertiesElement propertiesElement = new EON_OFSC_Resource_Management_WS.TextPropertiesElement();
            EON_OFSC_Resource_Management_WS.TextPropertyElement propertyElement = new EON_OFSC_Resource_Management_WS.TextPropertyElement();
                       
            EON_Technician__c technician = [select id, Name, Town__c, Address_Line_1__c, Postcode__c  
                                             from EON_Technician__c where id =: technicianID];

            
            //Request and Response element from OFSC
            EON_OFSC_Resource_Management_WS.ResourceManagementPort request = new EON_OFSC_Resource_Management_WS.ResourceManagementPort();                             
                    
  
            propertyElement = new EON_OFSC_Resource_Management_WS.TextPropertyElement();
            propertyElement.name = 'resource_id';
            propertyElement.value = technician.id;
            lstPropertyElement.add(propertyElement);
            
            propertyElement = new EON_OFSC_Resource_Management_WS.TextPropertyElement();
            propertyElement.name = 'label';
            propertyElement.value = 'Start Location';
            lstPropertyElement.add(propertyElement);
            
            propertyElement = new EON_OFSC_Resource_Management_WS.TextPropertyElement();
            propertyElement.name = 'city';
            propertyElement.value = technician.Town__c;
            lstPropertyElement.add(propertyElement);
            
            propertyElement = new EON_OFSC_Resource_Management_WS.TextPropertyElement();
            propertyElement.name = 'street';
            propertyElement.value = technician.Address_Line_1__c;
            lstPropertyElement.add(propertyElement);  
            
            propertyElement = new EON_OFSC_Resource_Management_WS.TextPropertyElement();
            propertyElement.name = 'zip';
            propertyElement.value = technician.Postcode__c;
            lstPropertyElement.add(propertyElement);                                               
             
            propertiesElement.property = lstPropertyElement;
            locationElement.properties = propertiesElement;
            lstlocationelement.add(locationElement);
            lstLocation.location = lstlocationelement;
            
            strRequest = authNodeElement + '\n' + technicianID + '\n' + lstLocation + '\n';
            
            response = request.update_locations(authNodeElement,lstLocation); 
            result = 'Technician sent to OFSC, please verify the related data tracker record';  
            
            lstResponseArray.add(strRequest);
            lstResponseArray.add(((response!=null) ? (response+'') : '')); 
                                   
        }Catch(Exception ex){
            System.debug('***** ' + ex.getStackTraceString());
            result = 'Exception occured and the Technician locations information cannot be sent to OFSC';
            
            lstResponseArray.add(strRequest);
            lstResponseArray.add(((response!=null) ? (response+'') : '') + ex.getStackTraceString());             
        } 
        
        if(response != null && response.result_code != null)
            lstResponseArray.add(String.valueOf(response.result_code));        
        
        lstResponseArray.add('Resource Management Location');
        return lstResponseArray; 
    }  
    
    /**
        updateTechnicianLocationinOFSC(String technicianID) - This method is used to update the location details in OFSC
                if any related field values changed in EON Technician object.
    **/
    @future (callout=true)
    public static void updateTechnicianLocationinOFSC(String technicianID){
        String[] lstLocationResponseArray = sendTechnicianLocationToOFSC(technicianID);
        createOFSCTrackerForUser(lstLocationResponseArray, technicianID);           
    }
        
    //CH07.end
   
    
    //CH06.Start        
        /**
            updateTechnicianInfoInOFSC(String technicianID, String propertyName) - This method will be called when 
                veg regi number or workzone or name fields of technician has been modified.
        **/
        @future (callout=true)
        public static void updateTechnicianInfoInOFSC(String technicianID){
            String strRequest = '';
            //Request elements to OFSC
            EON_OFSC_Resource_Management_WS.AuthNodeElement authNodeElement  = EON_OFSC_Send_Technician_Handler.getAuthenticationElement();        
            EON_OFSC_Resource_Management_WS.UsersLoginList userLogin = new EON_OFSC_Resource_Management_WS.UsersLoginList();  
            //EON_OFSC_Resource_Management_WS.WorkSkillList workskills = new EON_OFSC_Resource_Management_WS.WorkSkillList();
            EON_OFSC_Resource_Management_WS.PropertyElement propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();        
            List<EON_OFSC_Resource_Management_WS.PropertyElement> lstPropertyElement = new List<EON_OFSC_Resource_Management_WS.PropertyElement>();
            EON_OFSC_Resource_Management_WS.PropertiesElement propertiesElement = new EON_OFSC_Resource_Management_WS.PropertiesElement();                        
            EON_OFSC_Resource_Management_WS.SetResourceResponseElement response = new EON_OFSC_Resource_Management_WS.SetResourceResponseElement();
            
            EON_Technician__c technician = [select id, Name, Sent_to_OFS__c , Work_Zone__c , Vehicle_Reg__c, Email__c
                                             from EON_Technician__c where id =: technicianID];            
            
            try{
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'name';
                propertyElement.value = technician.Name; 
                lstPropertyElement.add(propertyElement);            
                        
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'XA_VEHICLE_PLATE';
                propertyElement.value = technician.Vehicle_Reg__c; 
                lstPropertyElement.add(propertyElement);   
                            
                Eon_WorkZoneMapping__c workZoneMap;
                String valueWorkZone = '';
                if(technician.Work_Zone__c!=null && technician.Work_Zone__c !='' && Eon_WorkZoneMapping__c.getInstance(technician.Work_Zone__c)!=null ){
                    workZoneMap = Eon_WorkZoneMapping__c.getInstance(technician.Work_Zone__c);
                    valueWorkZone = workZoneMap.Parent_id__c;
                }  
                
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'parent_id';
                propertyElement.value = valueWorkZone; 
                lstPropertyElement.add(propertyElement);
                
                propertyElement = new EON_OFSC_Resource_Management_WS.PropertyElement();
                propertyElement.name = 'email';
                propertyElement.value = technician.Email__c; 
                lstPropertyElement.add(propertyElement);                                                 
                
                propertiesElement.property = lstPropertyElement;
                strRequest = authNodeElement + '\n' + technicianID + '\n' + propertiesElement + '\n' + userLogin + '\n' + null + '\n'; //CH09
                
                //Request and Response element from OFSC
                EON_OFSC_Resource_Management_WS.ResourceManagementPort request = new EON_OFSC_Resource_Management_WS.ResourceManagementPort();                             
                
                response = request.update_resource(authNodeElement, technicianID, propertiesElement, userLogin, null);               
                createOFSCTracker(response, strRequest, technicianID, '');
            }Catch(Exception ex){
                System.debug('***** ' + ex.getStackTraceString());
                createOFSCTracker(response, strRequest, technicianID, (ex.getStackTraceString() + ex.getMessage()));
            }  
            
            
        }
    //CH06.End
    

    //CH05.Start
    /**
        createOFSCTrackerForUser() - This method is used to create Oracke Data Tracker record for the user creation.
    **/
    public Static void createOFSCTrackerForUser(String[] lstResponse, String technicianID){
        List<EON_OFSC_Response_Code__c> responseCode = new List<EON_OFSC_Response_Code__c>();
        if(lstResponse.size() > 2)
            responseCode = [select id, Error_Warning_Success__c from EON_OFSC_Response_Code__c where name =: lstResponse[2] and API__c = 'Resource'];  
        
        Oracle_Data_Tracker__c requestOut = new Oracle_Data_Tracker__c();
        
        if(lstResponse.get(lstResponse.size()-1).contains('Location'))
            requestOut.Command__c = lstResponse.get(lstResponse.size() - 1);
        else        
            requestOut.Command__c = 'Resource Management User';
        requestOut.Direction__c = 'OUT';
        if(!responseCode.isEmpty() && responseCode.size() > 0){
            requestOut.Error_Code__c = responseCode[0].id;  
            if(responseCode[0].Error_Warning_Success__c != 'error' ) 
                requestOut.Status__c ='PASS';  
            else
                requestOut.Status__c ='FAIL';        
        }    
            
        requestOut.Request_Data__c = lstResponse[0];
        requestOut.Response_Data__c = '' + lstResponse[1];                                    
        requestOut.Technician__c = technicianID; 
       /* list<Oracle_Data_Tracker__c> requestOut1 = new list<Oracle_Data_Tracker__c>(); //Ch10 update
        requestOut1.add(requestOut); //Ch10 update
        insert requestOut1;*/ //Ch10 update
        insert requestOut;                 
    }
    
    
    /**
        createOFSCTracker(EON_OFSC_Resource_Management_WS.SetResourceResponseElement response, String request, String technicianID,
                                            String exception) - 
            This method is used to create OFSC tracker record to track the request and response and update the technician record with sent 
            to OFSC with today's Date.
    **/
    public Static void createOFSCTracker(EON_OFSC_Resource_Management_WS.SetResourceResponseElement response, String request, String technicianID,
                                            String error){
            //CH02 START
            List<EON_OFSC_Response_Code__c> responseCode = new List<EON_OFSC_Response_Code__c>();
            
             if(response != null)
                 
                responseCode = [select id, Error_Warning_Success__c from EON_OFSC_Response_Code__c where name =: String.valueOf(response.result_code) and API__c = 'Resource'];  
                     system.debug('<<<<<<<<<<<<<<<<<<<<reddy>>>>>>>>>>>>>>>>>>'+response.result_code);
           //CH02 END
            Oracle_Data_Tracker__c requestOut = new Oracle_Data_Tracker__c();            
            requestOut.Command__c = 'Resource Management';
            requestOut.Direction__c = 'OUT';
            if(!responseCode.isEmpty())
                requestOut.Error_Code__c = responseCode[0].id;
            requestOut.Request_Data__c = request;
            requestOut.Response_Data__c = '' + response + '\n' + error;                                    
            requestOut.Technician__c = technicianID;
            
            //Update the Sent to OFSC field to update with current system time stamp
            if(!responseCode.isEmpty() ) { 
                EON_Technician__c updateTechnician = new EON_Technician__c(id = technicianID);
                
                if ( responseCode[0].Error_Warning_Success__c != 'error' ){
                    updateTechnician.Sent_to_OFS__c = System.now();
                    requestOut.Status__c ='PASS';
                    /* list<EON_Technician__c> updateTechnician1 = new list<EON_Technician__c>(); //CH10 update
                     updateTechnician1.add(updateTechnician);//CH10 update
                     update updateTechnician1; */ //CH10 update
                    update updateTechnician; } else { requestOut.Status__c ='FAIL'; } 
            }     
            
            insert requestOut;
            system.debug('*******response check ******'+requestOut.id);
    }
    
    /**
        getAuthenticationElement() - This method is used to prepare authentication element to pass to OFSC
    **/
    public static EON_OFSC_Resource_Management_WS.AuthNodeElement getAuthenticationElement(){
        EON_OFSC_Resource_Management_WS.AuthNodeElement authNodeElement = new EON_OFSC_Resource_Management_WS.AuthNodeElement();
        //Create Authentication node with parameters
        //authNodeElement.company = 'MUS-SMB2.TEST'; //TEST2
        authNodeElement.company = System.Label.EON_OFSC_Company; //TEST1
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