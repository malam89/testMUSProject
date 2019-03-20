/**
    Description     : This class is used to get the status of Jumbo & OFSC web service status.
    Test Class      : EON_GetServiceStatus_WS_Test     
**/
/*
    Created By : Dharmendra Pahadiya
    Created Date : 31-05-2016
    Service Request : SR_EON_AB_050
    Change History : 
*/
public with sharing class EON_Service_Status_Jumbo_OFSC {
    
    /**
        getJumboServiceStatus() :- This mehtod is used to get the service status of Jumbo Web service by calling J.18 (Request Elec MPAN Data)
    **/
    public static string getJumboServiceStatus(){
        string result = '';
        system.debug('@@@ start');
        EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
        EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
        system.debug('@@@ EON_Jumbo_Client_Id: '+system.label.EON_Jumbo_Client_Id);
        system.debug('@@@ EON_Jumbo_Client_Name: '+system.label.EON_Jumbo_Client_Name);
        ClientInfo.Id =system.label.EON_Jumbo_Client_Id;
        ClientInfo.Name =system.label.EON_Jumbo_Client_Name;
        EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest reqJumbo  = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsRequest();
        reqJumbo.UniqueId=EON_Utility.GenUniqueNum();
        reqJumbo.MPAN ='11111';
        reqJumbo.Client =ClientInfo;
        EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
        try{
             system.debug('@@@ request: '+reqJumbo);
             respJumbo = jumboObj.RequestElectricitySupplierAppointments(reqJumbo);  result = 'PASS';
             system.debug('@@@ response: '+respJumbo);
           
        }
        catch(Exception e){
            system.debug('### excepton: '+e.getMessage()+'\n'+e.getStackTraceString()+'\n'+e.getLineNumber());
            result = 'FAIL';
        } 
        return result;
    }
    
    /**
        getOFSCServiceStatus() :- This mehtod is used to get the service status of OFSC Web service by calling O.13(get_capacity)
    **/
    public static string getOFSCServiceStatus(){
        string result = '';
        System.debug('Calling capacity call');
        List<EON_OFSC_Helper.RecomendedTimeSlots> recTimeSlots = new List<EON_OFSC_Helper.RecomendedTimeSlots>(); // this will return the code logic 
        Integer taskDuration = 90;//duration; // it is the duration that needs to be sent to OFSC
        try 
        {
            //Get the User Element details.
            EON_OFSC_GetCapacity_WS.User_Element userElement = getUserElement();   
            
            //Add the activities to the list
            List<EON_OFSC_GetCapacity_WS.activity_field_element> activites = new List<EON_OFSC_GetCapacity_WS.activity_field_element>();//addIndustryActivities(elecPhaseGasPressure);
            EON_OFSC_GetCapacity_WS.activity_field_element activity = new EON_OFSC_GetCapacity_WS.activity_field_element();
            activites.add ( activity );
        
                    
            //prepare the Dates list for 56 days for getting the capacity from OFSC
            List<Date> lstRequestDates = new List<Date>();
            lstRequestDates.add(Date.today());
            //Request Workskills
            List<String> lstWorkSkills = new List<String>();
            
            //add the Oracle bucket ID to the location
            List<String> lstLocation = new List<String>();
            lstLocation.add('LON_NEWCONN');
            
            //Request Timeslots                 
            List<String> lstTimeslots = new List<String>(); 
            
            //Actual Request
            EON_OFSC_GetCapacity_WS.toa_capacity_interface request = new EON_OFSC_GetCapacity_WS.toa_capacity_interface();
            EON_OFSC_GetCapacity_WS.capacity_response_element response =  request.get_capacity(userElement, lstRequestDates, lstLocation, null, null, null, null, null, null, 2, taskDuration, lstTimeslots, lstWorkSkills, activites);
            System.debug('@@@ Response ' + response);  
            result = 'PASS';
        }Catch (Exception ex) { System.debug(ex.getMessage()+','+ex.getLineNumber() );
            System.debug('### exception ' + ex.getMessage()+','+ex.getLineNumber());
            result = 'FAIL';
        }
        return result;
    }
    
    /**
        getUserElement() - This method is used to create userelement for OFSC.
    **/
    private static EON_OFSC_GetCapacity_WS.User_Element getUserElement() {
    
        EON_OFSC_GetCapacity_WS.User_Element userElement = new EON_OFSC_GetCapacity_WS.User_Element();
        userElement.company = System.Label.EON_OFSC_Company;//company name
        userElement.login = System.Label.EON_OFSC_Login;//username //'soap';
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeDateTime(Datetime.now()); // Time Stamp            
        // Cope with the formatter returning .123Z as the time zone offset for GMT //        
        if (gen.getAsString().length() == 27) { userElement.now = gen.getAsString().substring(1,26); }      
        else
            userElement.now = gen.getAsString().substring(1,20) + '+00:00';                
        //call the methods for encript and prepare the authentication string.
        userElement.auth_string = EON_Utility.md5(userElement.now + EON_Utility.md5(System.Label.EON_OFSC_Password));
        return userElement;    
    }
    
}