/**
    Description : This class is used for test coverage for the below classes
    1.EON_OFSC_Activity_WS    
**/
/*
    Created By : Mahadev J
    Created Date : 23-April-2016 
    Service Request : SR_EON_Mobile_009
*/

@isTest
global class EON_OFSC_Activity_WS_Test implements WebServiceMock
{
    /**
        unitTest() - unitTest1 Success test case.
    **/
    public static String methodName;
    public static String status_value;
    /**
        utGetFile() - This is to verify response for method get_file()
    **/
    testmethod static void utGet_File()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'Get_File';
        EON_OFSC_Activity_WS.user_x user = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
       EON_OFSC_Activity_WS.get_file_response_element res = request.get_file(user,'test','test');
       system.assertEquals(0, res.result_code);
    } 
    /**
        utget_resource_preferences() - This is to verify response for method get_resource_preferences()
    **/
    testmethod static void utGet_Resource_Preferences()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'get_resource_preferences';
        
        
        EON_OFSC_Activity_WS.user_x user =  new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.get_resource_preferences_response res = request.get_resource_preferences(user,'test');
       system.assertEquals(0, res.result_code);
    }
    /**
        utCancel_Activity() - This is to verify response for method cancel_activity()
    **/
    testmethod static void utCancel_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
       

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.property[] prop;
       
        EON_OFSC_Activity_WS.activity_response res = request.cancel_activity(usr,'test','date', 'time', prop);
       system.assertEquals(0, res.result_code);
    }
    /**
        utSearch_Activities() - This is to verify response for method search_activities()
    **/
    testmethod static void utSearch_Activities()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
     

        EON_OFSC_Activity_WS.user_x usr =  new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        String[] strArray;
        EON_OFSC_Activity_WS.activity_response res = request.search_activities(usr,'SearchIn','SaerchFor', 'DateFrom', 'DateTo', 'SelectFrom', 'SelectCount', 'Order', strArray);
        system.assertEquals(0, res.result_code);
    }
    /**
        utGet_Activity() - This is to verify response for method get_activity()
    **/
    testmethod static void utGet_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
   

        EON_OFSC_Activity_WS.user_x usr =  new EON_OFSC_Activity_WS.user_x ();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.activity_response res = request.get_activity(usr,'ActId');
        system.assertEquals(0, res.result_code);
    }
    /**
        utDelay_Activity() - This is to verify response for method delay_activity()
    **/
    testmethod static void utDelay_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
      

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.property[] prop;
        EON_OFSC_Activity_WS.activity_response res = request.delay_activity(usr,'ActId','Date',0,prop);
        system.assertEquals(0, res.result_code);
    }
    /**
        utSetRequiredInventories() - This is to verify response for method set_required_inventories()
    **/
    testmethod static void utSetRequiredInventories()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'simple_response';
    

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.required_inventory[] inv;
        EON_OFSC_Activity_WS.required_inventory i = new EON_OFSC_Activity_WS.required_inventory();
        i.type_x = 'Test';
        i.model = 'Test';
        i.quantity = 'Test';
        //inv.add(i);
        EON_OFSC_Activity_WS.simple_response res = request.set_required_inventories(usr,'ActId',inv);
        system.assertEquals(0, res.result_code);
    }
    /**
        utComplete_Activity() - This is to verify response for method complete_activity()
    **/
    testmethod static void utComplete_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
     

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.property[] prop;
        EON_OFSC_Activity_WS.activity_response res = request.complete_activity(usr,'ActId','Date','Time',prop);
        system.assertEquals(0, res.result_code);
    }
    /**
        utStartRoute() - This is to verify response for method start_route()
    **/
    testmethod static void utStartRoute()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'simple_response';
        
        EON_OFSC_Activity_WS.user_x usr = new  EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.simple_response res = request.start_route(usr,'RecId','time','date');
        system.assertEquals(0, res.result_code);
    }
    /**
        utSuspend_Activity() - This is to verify response for method suspend_activity()
    **/
    testmethod static void utSuspend_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
    

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.property[] prop;
        EON_OFSC_Activity_WS.activity_response res = request.suspend_activity(usr,'ActId','Time','Date',prop);
        system.assertEquals(0, res.result_code);
    }
    /**
        utPrework_Activity() - This is to verify response for method prework_activity()
    **/
    testmethod static void utPrework_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
    

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.property[] prop;
        EON_OFSC_Activity_WS.activity_response res = request.prework_activity(usr,'ActId','Time','Date',prop);
        system.assertEquals(0, res.result_code);
    }
    /**
        utDeleteFile() - This is to verify response for method delete_file()
    **/
    testmethod static void utDeleteFile()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'simple_response';
        EON_OFSC_Activity_WS.user_x usr =  new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.simple_response res = request.delete_file(usr,'eId','pId');
        system.assertEquals(0, res.result_code);
    }
    /**
        utGetActivityWorkSkills() - This is to verify response for method get_activity_work_skills()
    **/
    testmethod static void utGetActivityWorkSkills()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'get_activity_work_skills_response';
        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.get_activity_work_skills_response res = request.get_activity_work_skills(usr,'ActId');
        system.assertEquals(0, res.result_code);
    }
    /**
        utStart_Activity() - This is to verify response for method start_activity()
    **/
    testmethod static void utStart_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
      

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.property[] prop;
        EON_OFSC_Activity_WS.activity_response res = request.start_activity(usr,'ActId','Date','Time',prop);
        system.assertEquals(0, res.result_code);
    }
    /**
        utSet_Resource_Preferences() - This is to verify response for method set_resource_preferences()
    **/
    testmethod static void utSet_Resource_Preferences()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'simple_response';
        EON_OFSC_Activity_WS.user_x usr =  new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.resource_preference[] pref;
        EON_OFSC_Activity_WS.simple_response res = request.set_resource_preferences(usr,'ActId',pref);
        system.assertEquals(0, res.result_code);
    }
    /**
        utEnd_Route() - This is to verify response for method end_route()
    **/
    testmethod static void utEnd_Route()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'simple_response';
        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.simple_response res = request.end_route(usr,'ActId','Time', 'Date');
        system.assertEquals(0, res.result_code);
    }
    /**
        utGet_Route() - This is to verify response for method get_route()
    **/
    testmethod static void utGet_Route()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
         

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        String[] prop;
        EON_OFSC_Activity_WS.activity_response res = request.get_route(usr,'Date','RecId',prop, 0, 0);
        system.assertEquals(0, res.result_code);
    }
    /**
        utGet_Required_Inventories() - This is to verify response for method get_required_inventories()
    **/
    testmethod static void utGet_Required_Inventories()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'get_required_inventories_response';
        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.get_required_inventories_response res = request.get_required_inventories(usr,'ActId');
        system.assertEquals(0, res.result_code);
    }
    /**
        utSet_File() - This is to verify response for method set_file()
    **/
    testmethod static void utSet_File()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'simple_response';
        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.simple_response res = request.set_file(usr,'EntId','PropId', 'FileName', 'FileDate','FileMimeType');
        system.assertEquals(0, res.result_code);
    }
    /**
        utUnlink_activities() - This is to verify response for method unlink_activities()
    **/
    testmethod static void utUnlink_activities()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'simple_response';
        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.simple_response res = request.unlink_activities(usr,'FromActId','ToActId', 'LinkType');
        system.assertEquals(0, res.result_code);
    }
    /**
        utGet_Activity_Links() - This is to verify response for method get_activity_links()
    **/
    testmethod static void utGet_Activity_Links()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'get_activity_links_response_element';
        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.get_activity_links_response_element res = request.get_activity_links(usr,'ActId');
        system.assertEquals(0, res.result_code);
    }
    /**
        utCreate_Activity() - This is to verify response for method create_activity()
    **/
    testmethod static void utCreate_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
     

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.property[] propArray;
        EON_OFSC_Activity_WS.activity_response res = request.create_activity(usr,'Date','ResId','position_in_route',propArray);
        system.assertEquals(0, res.result_code);
    }
    /**
        utReopen_Activity() - This is to verify response for method reopen_activity()
    **/
    testmethod static void utReopen_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
      

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.property[] propArray;
        EON_OFSC_Activity_WS.activity_response res = request.reopen_activity(usr,'ActId','position_in_route',propArray);
        system.assertEquals(0, res.result_code);
    }
    /**
        utLink_Activities() - This is to verify response for method link_activities()
    **/
    testmethod static void utLink_Activities()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'simple_response';
        EON_OFSC_Activity_WS.user_x usr =  new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.simple_response res = request.link_activities(usr,'FromActId','ToActId', 'LinkType','MinInt','MaxInt');
        system.assertEquals(0, res.result_code);
    }
    /**
        utUpdate_Activity() - This is to verify response for method update_activity()
    **/
    testmethod static void utUpdate_Activity()
    {
        Test.setMock(WebServiceMock.class, new EON_OFSC_Activity_WS_Test());
        EON_OFSC_Activity_WS_Test.methodName = 'activity_response';
      

        EON_OFSC_Activity_WS.user_x usr = new EON_OFSC_Activity_WS.user_x();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.property[] propArray;
        EON_OFSC_Activity_WS.activity_response res = request.update_activity(usr,'ActId','position_in_route',propArray);
        system.assertEquals(0, res.result_code);
    }
    global void doInvoke(
           Object stub, Object request, Map<String, Object> response, String endpoint,
           String soapAction,String requestName, String responseNS,
           String responseName,String responseType) 
    {
        if(methodName == 'Get_File')
        {
            EON_OFSC_Activity_WS.get_file_response_element resp = new EON_OFSC_Activity_WS.get_file_response_element();
            resp.result_code = 0;
            resp.error_msg = 'test';
            resp.file_name = 'test';
            resp.file_data = 'test';
            resp.file_mime_type = 'test';
            response.put('response_x', resp);
        }
        if(methodName == 'get_resource_preferences')
        {
            EON_OFSC_Activity_WS.get_resource_preferences_response resp = new EON_OFSC_Activity_WS.get_resource_preferences_response();
            list<EON_OFSC_Activity_WS.resource_preference> listResPref = new list<EON_OFSC_Activity_WS.resource_preference>();
            EON_OFSC_Activity_WS.resource_preference pref = new EON_OFSC_Activity_WS.resource_preference();
            //pref.resource_id = 'ResId';
            //pref.type_x = 'TypeX';
            resp.preference = listResPref;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        if(methodName == 'activity_response')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = '1999-01-01';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '1';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = 'complete';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
            
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
        //Added by Aruna 
        
         if(methodName == 'activity_response1')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = '2014-03-25';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '1';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = 'notdone';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }


           //Added by Aruna 
        
         if(methodName == 'activity_response2')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '1';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = 'suspended';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
        
        //Added by Aruna 
        
         if(methodName == 'activity_response3')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-21 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '1';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = 'started';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
        //Added by Aruna 
        
         if(methodName == 'activity_response4')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '1';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = '';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
        //Added by Aruna 
        
         if(methodName == 'activity_response5')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '4';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = '';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
        
         //Added by Aruna 
        
         if(methodName == 'activity_response6')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '4';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = 'complete';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
        
         //Added by Aruna 
        
         if(methodName == 'activity_response7')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '4';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = 'notdone';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
         //Added by Aruna 
        
         if(methodName == 'activity_response8')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '4';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = 'suspended';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
        //Added by Aruna 
        
         if(methodName == 'activity_response9')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '4';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = 'started';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
        
         //Added by Aruna 
        
         if(methodName == 'activity_response10')
        {   
            list<EON_OFSC_Activity_WS.activity> acttt = new  list<EON_OFSC_Activity_WS.activity>();
            List<EON_OFSC_Activity_WS.property> propertislist = new List<EON_OFSC_Activity_WS.property>();
        
            List<EON_OFSC_Activity_WS.property> propertislist1 = new List<EON_OFSC_Activity_WS.property>();

        
            EON_OFSC_Activity_WS.property  property1 = new  EON_OFSC_Activity_WS.property ();
            property1.name = 'customer_number';
            property1.value = 'customer_number';
           
            
            
            EON_OFSC_Activity_WS.property  property2 = new  EON_OFSC_Activity_WS.property ();
            property2.name = 'date';
            property2.value = 'date';
            
            
            EON_OFSC_Activity_WS.property  property3 = new  EON_OFSC_Activity_WS.property ();
            property3.name = 'start_time';
            property3.value = '2014-03-20 10:21:47';
            
            
            EON_OFSC_Activity_WS.property  property4 = new  EON_OFSC_Activity_WS.property ();
            property4.name = 'end_time';
            property4.value = '2014-03-20 10:21:47';
            
            EON_OFSC_Activity_WS.property  property5 = new  EON_OFSC_Activity_WS.property ();
            property5.name = 'Duration';
            property5.value ='6';
            
            EON_OFSC_Activity_WS.property  property6 = new  EON_OFSC_Activity_WS.property ();
            property6.name = 'delivery_window_start';
            property6.value ='delivery_window_start';
          
          
            EON_OFSC_Activity_WS.property  property7 = new  EON_OFSC_Activity_WS.property ();
            property7.name = 'delivery_window_end';
            property7.value = 'delivery_window_end';
            
            EON_OFSC_Activity_WS.property  property8 = new  EON_OFSC_Activity_WS.property ();
            property8.name = 'position_in_route';
            property8.value = '0';
            
           
            
            EON_OFSC_Activity_WS.property  property9 = new  EON_OFSC_Activity_WS.property ();
            property9.name = 'type';
            property9.value = 'type';
             
             
             
            EON_OFSC_Activity_WS.property  property10 = new  EON_OFSC_Activity_WS.property ();
            property10.name = 'Address';
            property10.value = 'Address';
             
           
           
            
            EON_OFSC_Activity_WS.property  property11 = new  EON_OFSC_Activity_WS.property ();
            property11.name = 'City';
            property11.value = 'City';
            
            
            
            EON_OFSC_Activity_WS.property  property12 = new  EON_OFSC_Activity_WS.property ();
            property12.name = 'status';
            property12.value = 'started';
            
           
            propertislist.add(property1);
            propertislist.add(property2);
            propertislist.add(property3);
            propertislist.add(property4);
            propertislist.add(property5);
            propertislist.add(property6);
            propertislist.add(property7);
            propertislist.add(property8); 
            propertislist.add(property9);
            propertislist.add(property10);
            propertislist.add(property11);
            propertislist.add(property12);
            
           
           
            EON_OFSC_Activity_WS.activity acty1 = new  EON_OFSC_Activity_WS.activity();
            acty1.properties = propertislist; 
            
            EON_OFSC_Activity_WS.activity acty2 = new  EON_OFSC_Activity_WS.activity();
            acty2.properties = propertislist; 
            
            
            EON_OFSC_Activity_WS.activity acty3 = new  EON_OFSC_Activity_WS.activity();
            acty3.properties = propertislist1; 
            
            acttt.add(acty1);
            acttt.add(acty2);
            acttt.add(acty3);
            
            EON_OFSC_Activity_WS.activities acties = new EON_OFSC_Activity_WS.activities();
            acties.activity=acttt;  
            EON_OFSC_Activity_WS.activity_response resp = new EON_OFSC_Activity_WS.activity_response();
            EON_OFSC_Activity_WS.activity act = new EON_OFSC_Activity_WS.activity();
            EON_OFSC_Activity_WS.activity_list actList = new EON_OFSC_Activity_WS.activity_list();
            actList.total = 0;
            actList.activities =acties ;
         
            
            EON_OFSC_Activity_WS.property  prop = new  EON_OFSC_Activity_WS.property();
            prop.name='customer_number';
            
            resp.activity = act;
            resp.activity_list = actList;
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        
        if(methodName == 'simple_response')
        {
            EON_OFSC_Activity_WS.simple_response resp = new EON_OFSC_Activity_WS.simple_response();
            resp.result_code = 0;
            resp.error_msg = 'test';
            response.put('response_x', resp);
        }
        if(methodName == 'get_activity_work_skills_response')
        {
            EON_OFSC_Activity_WS.get_activity_work_skills_response resp = new EON_OFSC_Activity_WS.get_activity_work_skills_response();
            EON_OFSC_Activity_WS.work_skill[] skillArray;
            EON_OFSC_Activity_WS.capacity_category[] capArray;
            EON_OFSC_Activity_WS.capacity_category cat = new EON_OFSC_Activity_WS.capacity_category();
            EON_OFSC_Activity_WS.work_skill ws = new EON_OFSC_Activity_WS.work_skill(); //Added to cover code
            EON_OFSC_Activity_WS.links l = new EON_OFSC_Activity_WS.links(); // Added to cover code
            EON_OFSC_Activity_WS.property p = new EON_OFSC_Activity_WS.property(); //Added to cover code
            EON_OFSC_Activity_WS.activities act = new EON_OFSC_Activity_WS.activities(); //Added to cover code
            resp.result_code = 0;
            resp.error_msg = 'test';
            resp.work_skill = skillArray;
            resp.capacity_category = capArray;
            response.put('response_x', resp);
        }
        if(methodName == 'get_required_inventories_response')
        {
            EON_OFSC_Activity_WS.get_required_inventories_response resp = new EON_OFSC_Activity_WS.get_required_inventories_response();
            EON_OFSC_Activity_WS.required_inventory[] invArray;
            resp.result_code = 0;
            resp.error_msg = 'test';
            resp.required_inventory = invArray;
            response.put('response_x', resp);
        }
        if(methodName == 'get_activity_links_response_element')
        {
            EON_OFSC_Activity_WS.get_activity_links_response_element resp = new EON_OFSC_Activity_WS.get_activity_links_response_element();
            EON_OFSC_Activity_WS.link[] linkArray;
            EON_OFSC_Activity_WS.link l = new EON_OFSC_Activity_WS.link();
            l.link_type = 'Test';
            l.activity_id = 'Test';
            l.resource_id = 'Test';
            l.resource_name = 'Test';
            l.activity_status = 'Test';
            l.activity_identifier = 'Test';
            l.activity_start_time = 'Test';
            l.alerts = 0;
            l.is_broken = true;
            l.min_interval='Test';
            l.max_interval='Test';
            resp.result_code = 0;
            resp.error_msg = 'test';
            resp.link = linkArray;
            response.put('response_x', resp);
        }
        
        
        if(methodName == 'activity_binding')
        {
             EON_OFSC_Activity_WS.activity_binding request_x = new EON_OFSC_Activity_WS.activity_binding();
             
      request_x.endpoint_x = 'test';
       
        request_x.clientCertName_x='test';
        request_x.clientCert_x='test';
        request_x.clientCertPasswd_x='terere';
        request_x.timeout_x=01;
             
             
             
        }
   }
}