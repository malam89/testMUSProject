/**
Description : This test class is test mock response genereated for the following class: 
              EON_OFSC_GetCapacity_WS
**/

/*
Created By  : Chandan K
Created On  : 8/04/2016
Service Req : SR_EON_AB_022 
Change History    
*/

@isTest
global class EON_OFSC_GetCapacity_WS_ServicesMock implements WebServiceMock {
    /**
        doInvoke(Object,Object, Map<String, Object>, String, String, String, String, String, String): This method is to generate mock webservice response.
    **/  
   global void doInvoke(
    Object stub,
    Object request,
    Map<String, Object> response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNS,
    String responseName,
    String responseType)
    {   
        List<EON_OFSC_GetCapacity_WS.capacity_element> capacities = new List<EON_OFSC_GetCapacity_WS.capacity_element>();
    
        EON_OFSC_GetCapacity_WS.capacity_element capacityElement = new EON_OFSC_GetCapacity_WS.capacity_element();
        capacityElement.location = 'location';
        capacityElement.date_x=system.today();
        //capacityElement.time_slot='14:00-16:00';
        capacityElement.time_slot='25:00-26:00';
        capacityElement.work_skill='GA';
        //capacityElement.quota =2;        
        //capacityElement.available= 2;
        capacityElement.quota =5;
        capacityElement.available= 5;
        
        EON_OFSC_GetCapacity_WS.capacity_element capacityElement1 = new EON_OFSC_GetCapacity_WS.capacity_element();
        capacityElement1.location = 'location';
        capacityElement1.date_x=system.today();
        capacityElement1.time_slot='25:00-26:00';
        capacityElement1.work_skill='workSkill';
        capacityElement1.quota =1;
        capacityElement1.available= 1;
        //capacityElement1.quota =5;
        //capacityElement1.available= 5;       
        
        EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
        capacityElement2.location = 'location';
        capacityElement2.date_x=system.today();
        //capacityElement2.time_slot='14-16';
        capacityElement2.time_slot='25:00-26:00';
        capacityElement2.work_skill='workSkill';
        //capacityElement2.quota =1;
        //capacityElement2.available= 1;
        capacityElement2.quota =5;
        capacityElement2.available= 5;
        
        EON_OFSC_GetCapacity_WS.capacity_element capacityElement3 = new EON_OFSC_GetCapacity_WS.capacity_element();
        capacityElement3.location = 'location';
        capacityElement3.date_x=system.today();
        //capacityElement2.time_slot='14-16';
        capacityElement3.time_slot='25:00-26:00';
        capacityElement3.work_skill='Error';
        //capacityElement2.quota =1;
        //capacityElement2.available= 1;
        capacityElement3.quota =1;
        capacityElement3.available= 1;
                
        capacities.add(capacityElement);
        capacities.add(capacityElement1);
        capacities.add(capacityElement2);
        capacities.add(capacityElement3);        
   
    EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
    getCapacityResp.capacity = capacities;
    getCapacityResp.activity_duration = 1;
    getCapacityResp.activity_travel_time = 1;
    
    if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_request_element)
        response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_response_element());    
    
    else if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_close_time_request_element)
        response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_close_time_response_element());  
        
   else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_data_request_element)
        response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_data_response_element()); 
        
   else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_close_time_request_element)
        response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_close_time_response_element());  
        
   else if(request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element)
        response.put('response_x', getCapacityResp);   
    }
}