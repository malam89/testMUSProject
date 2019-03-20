/**
Description : This test class is test mock response genereated for the following class: 
              EON_OFSC_Resource_Management_WS
**/

/*
Created By  : Nitin Bangar
Created On  : 25/02/2016
Service Req : 
Change History    
CH01 # SR_EON_Scheduling_030 # 05/05/2016 # Tashika # Added response values in insert_resource WS method.
*/
@isTest
global class EON_OFSC_ResourceManagement_ServicesMock implements WebServiceMock {

    global void doInvoke(
    Object stub,
    Object request,
    Map<String, Object> response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNS,
    String responseName,
    String responseType){   
        
    if(request instanceof EON_OFSC_Resource_Management_WS.UpdateResourceElement){
        response.put('response_x', new EON_OFSC_Resource_Management_WS.SetResourceResponseElement()); 
        //CH02.Start
        EON_OFSC_Resource_Management_WS.SetResourceResponseElement res= new EON_OFSC_Resource_Management_WS.SetResourceResponseElement();
        res.result_code=0;
        res.error_msg='PASS';  
        response.put('response_x',res); 
        //CH02.End    
    }       
    
    else if(request instanceof EON_OFSC_Resource_Management_WS.GetResourcesSkillsElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.GetResourcesSkillsResponseElement());
    
    else if(request instanceof EON_OFSC_Resource_Management_WS.GetLocationsElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.GetLocationsResponseElement());
    
    else if(request instanceof EON_OFSC_Resource_Management_WS.DeleteUserElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.SetUserResponseElement());
    
    else if(request instanceof EON_OFSC_Resource_Management_WS.SetResourcesCalendarsElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.SetResourcesCalendarsResponseElement());    

    else if(request instanceof EON_OFSC_Resource_Management_WS.SetLocationsElement){

        EON_OFSC_Resource_Management_WS.SetLocationsResponseElement res= new EON_OFSC_Resource_Management_WS.SetLocationsResponseElement();
        res.result_code=0;
        res.error_msg='PASS';  
        response.put('response_x',res); 

        //response.put('response_x', new EON_OFSC_Resource_Management_WS.SetLocationsResponseElement()); 

    }else if(request instanceof EON_OFSC_Resource_Management_WS.GetUserElement)
            response.put('response_x', new EON_OFSC_Resource_Management_WS.GetUserResponseElement()); 

    else if(request instanceof EON_OFSC_Resource_Management_WS.GetResourceElement)
            response.put('response_x', new EON_OFSC_Resource_Management_WS.GetResourceResponseElement()); 

    else if(request instanceof EON_OFSC_Resource_Management_WS.SetLocationsElement)
            response.put('response_x', new EON_OFSC_Resource_Management_WS.SetLocationsResponseElement()); 

    else if(request instanceof EON_OFSC_Resource_Management_WS.GetResourcesLocationsElement)
            response.put('response_x', new EON_OFSC_Resource_Management_WS.GetResourcesLocationsResponseElement()); 

    else if(request instanceof EON_OFSC_Resource_Management_WS.SetResourcesSkillsElement)
            response.put('response_x', new EON_OFSC_Resource_Management_WS.SetResourcesSkillsResponseElement()); 

    else if(request instanceof EON_OFSC_Resource_Management_WS.UpdateUserElement)
            response.put('response_x', new EON_OFSC_Resource_Management_WS.SetUserResponseElement()); 

    else if(request instanceof EON_OFSC_Resource_Management_WS.GetUsersListElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.GetUsersListResponseElement());  
        
    else if(request instanceof EON_OFSC_Resource_Management_WS.GetResourcesZonesElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.GetResourcesZonesResponseElement());     
        
    else if(request instanceof EON_OFSC_Resource_Management_WS.SetResourcesZonesElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.SetResourcesZonesResponseElement());     
        
    else if(request instanceof EON_OFSC_Resource_Management_WS.InsertUserElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.SetUserResponseElement());   
        
    else if(request instanceof EON_OFSC_Resource_Management_WS.GetResourcesListElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.GetResourcesListResponseElement());  
        
    else if(request instanceof EON_OFSC_Resource_Management_WS.InsertResourceElement){
        //CH01.Start
        EON_OFSC_Resource_Management_WS.SetResourceResponseElement res= new EON_OFSC_Resource_Management_WS.SetResourceResponseElement();
        res.result_code=0;
        res.error_msg='PASS';  
        response.put('response_x',res); 
        //CH01.End
    }

    else if(request instanceof EON_OFSC_Resource_Management_WS.GetResourcesCalendarsElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.GetResourcesCalendarsResponseElement());     

    else if(request instanceof EON_OFSC_Resource_Management_WS.SetResourcesLocationsElement)
        response.put('response_x', new EON_OFSC_Resource_Management_WS.SetResourcesLocationsResponseElement());  
        
        
    //CH02.start
    else if(request instanceof EON_OFSC_Resource_Management_3_WS.InsertUserElement){
        EON_OFSC_Resource_Management_3_WS.SetUserResponseElement res = new EON_OFSC_Resource_Management_3_WS.SetUserResponseElement();
        res.result_code=0;
        res.error_msg='PASS';  
        response.put('response_x',res);  
    }
    
    else if(request instanceof EON_OFSC_Resource_Management_3_WS.DeleteUserElement){
        EON_OFSC_Resource_Management_3_WS.SetUserResponseElement res = new EON_OFSC_Resource_Management_3_WS.SetUserResponseElement();
        res.result_code=0;
        res.error_msg='PASS';  
        response.put('response_x',res);  
    }    
    //CH02.End           
    }
    

}