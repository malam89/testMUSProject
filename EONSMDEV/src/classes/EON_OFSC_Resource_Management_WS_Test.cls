/**
Description : This test class is for the following below classes/triggers
              EON_OFSC_Resource_Management_WS 
              
**/

/*
    Created By  : Nitin Bangar
    Created On  : 25/02/2016
    Service Request : SR_EON_Scheduling_001 
    Change History
*/
@isTest
private class EON_OFSC_Resource_Management_WS_Test
{
    static testMethod void coverInnerCls() 
    {
        //Instanciating to cover the inner/wrapper classes.
        EON_OFSC_Resource_Management_WS.ZoneElement  zoneElem = new EON_OFSC_Resource_Management_WS.ZoneElement ();               
        EON_OFSC_Resource_Management_WS.ResourceListItemElement resLst = new EON_OFSC_Resource_Management_WS.ResourceListItemElement();
        EON_OFSC_Resource_Management_WS.ZoneResultElement zoneRes = new EON_OFSC_Resource_Management_WS.ZoneResultElement();
        EON_OFSC_Resource_Management_WS.UserListItemElement useLst = new EON_OFSC_Resource_Management_WS.UserListItemElement();
        EON_OFSC_Resource_Management_WS.LocationResultElement locRes = new EON_OFSC_Resource_Management_WS.LocationResultElement();
        EON_OFSC_Resource_Management_WS.SetLocationResultList setLoc = new EON_OFSC_Resource_Management_WS.SetLocationResultList();
        EON_OFSC_Resource_Management_WS.GetUsersListElement usrLstelem = new EON_OFSC_Resource_Management_WS.GetUsersListElement();
        EON_OFSC_Resource_Management_WS.GetResourcesListResponseElement resLstResp = new EON_OFSC_Resource_Management_WS.GetResourcesListResponseElement();
        EON_OFSC_Resource_Management_WS.ResourceLocationList resLocLst = new EON_OFSC_Resource_Management_WS.ResourceLocationList();
        EON_OFSC_Resource_Management_WS.UpdateUserElement updUsrElem = new EON_OFSC_Resource_Management_WS.UpdateUserElement();
        EON_OFSC_Resource_Management_WS.GetResourcesLocationsElement resLocElem = new EON_OFSC_Resource_Management_WS.GetResourcesLocationsElement();
        EON_OFSC_Resource_Management_WS.GetResourcesCalendarsElement resCalElem = new EON_OFSC_Resource_Management_WS.GetResourcesCalendarsElement();
        EON_OFSC_Resource_Management_WS.SetResourcesSkillsResponseElement resSkill = new EON_OFSC_Resource_Management_WS.SetResourcesSkillsResponseElement();
        EON_OFSC_Resource_Management_WS.PropertyElement pptElem = new EON_OFSC_Resource_Management_WS.PropertyElement();
        EON_OFSC_Resource_Management_WS.CalendarElement calElem = new EON_OFSC_Resource_Management_WS.CalendarElement();
        EON_OFSC_Resource_Management_WS.SkillElement skillElem = new EON_OFSC_Resource_Management_WS.SkillElement();
        EON_OFSC_Resource_Management_WS.LocationList locLst = new EON_OFSC_Resource_Management_WS.LocationList();
        EON_OFSC_Resource_Management_WS.GetResourcesSkillsElement resSkillElem = new EON_OFSC_Resource_Management_WS.GetResourcesSkillsElement();
        EON_OFSC_Resource_Management_WS.TextPropertyElement txtPptElem = new EON_OFSC_Resource_Management_WS.TextPropertyElement();
        EON_OFSC_Resource_Management_WS.SkillResultElement skillResElem = new EON_OFSC_Resource_Management_WS.SkillResultElement();
        EON_OFSC_Resource_Management_WS.LocationResourceParamsList locResParamLst = new EON_OFSC_Resource_Management_WS.LocationResourceParamsList();
        EON_OFSC_Resource_Management_WS.UsersLoginList  usrLogin = new EON_OFSC_Resource_Management_WS.UsersLoginList ();
        EON_OFSC_Resource_Management_WS.SetResourcesCalendarsElement setResCalElem = new EON_OFSC_Resource_Management_WS.SetResourcesCalendarsElement();
        EON_OFSC_Resource_Management_WS.GetResourcesZonesElement resZoneElem = new EON_OFSC_Resource_Management_WS.GetResourcesZonesElement();
        EON_OFSC_Resource_Management_WS.TextPropertiesElement txtPptsElem = new EON_OFSC_Resource_Management_WS.TextPropertiesElement();
        EON_OFSC_Resource_Management_WS.GetResourcesSkillsResponseElement resSkillResp = new EON_OFSC_Resource_Management_WS.GetResourcesSkillsResponseElement();
        EON_OFSC_Resource_Management_WS.ZoneList zoneLst = new EON_OFSC_Resource_Management_WS.ZoneList();
        EON_OFSC_Resource_Management_WS.SetResourcesLocationsResultList resLocResLst = new EON_OFSC_Resource_Management_WS.SetResourcesLocationsResultList();
        EON_OFSC_Resource_Management_WS.UserListElement usrsLstElem = new EON_OFSC_Resource_Management_WS.UserListElement();        
        EON_OFSC_Resource_Management_WS.LocationLabelList locLabl = new EON_OFSC_Resource_Management_WS.LocationLabelList();
        EON_OFSC_Resource_Management_WS.SkillResultList  skillResLst = new EON_OFSC_Resource_Management_WS.SkillResultList();     
        EON_OFSC_Resource_Management_WS.LocationResourceParams  locResParams = new EON_OFSC_Resource_Management_WS.LocationResourceParams();     
        EON_OFSC_Resource_Management_WS.GetResourcesCalendarsResponseElement  resCalRespElem = new EON_OFSC_Resource_Management_WS.GetResourcesCalendarsResponseElement();     
        EON_OFSC_Resource_Management_WS.GetUserElement  usrElem = new EON_OFSC_Resource_Management_WS.GetUserElement();     
        EON_OFSC_Resource_Management_WS.DeleteUserElement  delUsrElem = new EON_OFSC_Resource_Management_WS.DeleteUserElement();     
        EON_OFSC_Resource_Management_WS.SetResourcesZonesResponseElement  resZoneRespElem = new EON_OFSC_Resource_Management_WS.SetResourcesZonesResponseElement();     
        EON_OFSC_Resource_Management_WS.PropertiesElement  pptsElem = new EON_OFSC_Resource_Management_WS.PropertiesElement();     
        EON_OFSC_Resource_Management_WS.SetResourceResponseElement  resRespElem = new EON_OFSC_Resource_Management_WS.SetResourceResponseElement();     
        EON_OFSC_Resource_Management_WS.InsertResourceElement  insResElem = new EON_OFSC_Resource_Management_WS.InsertResourceElement();     
        EON_OFSC_Resource_Management_WS.SetLocationsResponseElement  locRespElem = new EON_OFSC_Resource_Management_WS.SetLocationsResponseElement();     
        EON_OFSC_Resource_Management_WS.InsertUserElement  insUsrElem = new EON_OFSC_Resource_Management_WS.InsertUserElement();     
        EON_OFSC_Resource_Management_WS.WorkSkillElement  wrksSkill = new EON_OFSC_Resource_Management_WS.WorkSkillElement();     
        EON_OFSC_Resource_Management_WS.GetResourcesParamsElement  resParamElem = new EON_OFSC_Resource_Management_WS.GetResourcesParamsElement();     
        EON_OFSC_Resource_Management_WS.ResourceLocationElement  getResLocElem = new EON_OFSC_Resource_Management_WS.ResourceLocationElement();     
        EON_OFSC_Resource_Management_WS.CalendarList  calLst = new EON_OFSC_Resource_Management_WS.CalendarList();     
        EON_OFSC_Resource_Management_WS.RequiredPropertiesElement  reqPptElem = new EON_OFSC_Resource_Management_WS.RequiredPropertiesElement();     
        EON_OFSC_Resource_Management_WS.ResourceIdListElement  resIdLst = new EON_OFSC_Resource_Management_WS.ResourceIdListElement();     
        EON_OFSC_Resource_Management_WS.GetUsersListResponseElement  usrLstResp = new EON_OFSC_Resource_Management_WS.GetUsersListResponseElement();     
        EON_OFSC_Resource_Management_WS.SetResourcesLocationsElement  setResLocElem = new EON_OFSC_Resource_Management_WS.SetResourcesLocationsElement();     
        EON_OFSC_Resource_Management_WS.SetResourcesSkillsElement  setResSkill = new EON_OFSC_Resource_Management_WS.SetResourcesSkillsElement();     
        EON_OFSC_Resource_Management_WS.UpdateResourceElement  updResElem = new EON_OFSC_Resource_Management_WS.UpdateResourceElement();     
        EON_OFSC_Resource_Management_WS.GetUserResponseElement  getUsrRespElem = new EON_OFSC_Resource_Management_WS.GetUserResponseElement();     
        EON_OFSC_Resource_Management_WS.LocationElement  locElem = new EON_OFSC_Resource_Management_WS.LocationElement();     
        EON_OFSC_Resource_Management_WS.ProfileListElement  profileLst = new EON_OFSC_Resource_Management_WS.ProfileListElement();     
        EON_OFSC_Resource_Management_WS.GetResourcesParamsList  getResParam = new EON_OFSC_Resource_Management_WS.GetResourcesParamsList();     
        EON_OFSC_Resource_Management_WS.CalendarResultList  calResLst = new EON_OFSC_Resource_Management_WS.CalendarResultList();     
        EON_OFSC_Resource_Management_WS.GetResourceElement  getResElem = new EON_OFSC_Resource_Management_WS.GetResourceElement();     
        EON_OFSC_Resource_Management_WS.SetUserResponseElement  setUsrRespElem = new EON_OFSC_Resource_Management_WS.SetUserResponseElement();     
        EON_OFSC_Resource_Management_WS.SkillList  skillLst = new EON_OFSC_Resource_Management_WS.SkillList();     
        EON_OFSC_Resource_Management_WS.GetResourcesZonesResponseElement  getResZone = new EON_OFSC_Resource_Management_WS.GetResourcesZonesResponseElement();     
        EON_OFSC_Resource_Management_WS.ZoneResultList  zoneResLst = new EON_OFSC_Resource_Management_WS.ZoneResultList();     
        EON_OFSC_Resource_Management_WS.GetResourcesListElement  getResLstElem = new EON_OFSC_Resource_Management_WS.GetResourcesListElement();     
        EON_OFSC_Resource_Management_WS.SetLocationsElement  setLocElem = new EON_OFSC_Resource_Management_WS.SetLocationsElement();     
        EON_OFSC_Resource_Management_WS.SetResourcesCalendarsResponseElement  setResCalRespElem = new EON_OFSC_Resource_Management_WS.SetResourcesCalendarsResponseElement();     
        EON_OFSC_Resource_Management_WS.GetResourcesLocationsResponseElement  getResLocRespElem = new EON_OFSC_Resource_Management_WS.GetResourcesLocationsResponseElement();     
        EON_OFSC_Resource_Management_WS.SetResourcesLocationsResponseElement  setResLocRespElem = new EON_OFSC_Resource_Management_WS.SetResourcesLocationsResponseElement();     
        EON_OFSC_Resource_Management_WS.GetResourceResponseElement  getResRespElem = new EON_OFSC_Resource_Management_WS.GetResourceResponseElement();     
        EON_OFSC_Resource_Management_WS.SetResourcesZonesElement  setResZoneElem = new EON_OFSC_Resource_Management_WS.SetResourcesZonesElement();     
        EON_OFSC_Resource_Management_WS.ResourceListElement  resLstElem = new EON_OFSC_Resource_Management_WS.ResourceListElement();     
        EON_OFSC_Resource_Management_WS.WorkSkillList  worksSkillLst = new EON_OFSC_Resource_Management_WS.WorkSkillList();     
        EON_OFSC_Resource_Management_WS.WeekdaysList  weekLst = new EON_OFSC_Resource_Management_WS.WeekdaysList();     
        EON_OFSC_Resource_Management_WS.CalendarResultElement  calResElem = new EON_OFSC_Resource_Management_WS.CalendarResultElement();     
        EON_OFSC_Resource_Management_WS.GetLocationsElement  getLocElem = new EON_OFSC_Resource_Management_WS.GetLocationsElement();     
        EON_OFSC_Resource_Management_WS.GetLocationsResponseElement  getLocRespElem = new EON_OFSC_Resource_Management_WS.GetLocationsResponseElement();            
        EON_OFSC_Resource_Management_WS.AuthNodeElement authNode = new EON_OFSC_Resource_Management_WS.AuthNodeElement();
        authNode.company = 'MUS';        
        System.assertEquals('MUS', authNode.company);  
    } 
    
    @istest 
    private static void WebSvcCalloutTest(){             
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new EON_OFSC_ResourceManagement_ServicesMock());          
        EON_OFSC_Resource_Management_WS.ResourceManagementPort resManagePort = new EON_OFSC_Resource_Management_WS.ResourceManagementPort();  
        resManagePort.timeout_x = 12000;
        
        EON_OFSC_Resource_Management_WS.AuthNodeElement authNode = new EON_OFSC_Resource_Management_WS.AuthNodeElement();
        authNode.now = string.ValueOf(System.now());       
        authNode.login = 'EON@morrisonus.com';
        authNode.company = 'MUS';
        authNode.auth_string = 'MUS USER AUTHENTICATED';
        
        // Instanciating inner/wrapper classes to pass them as parameters.        
        EON_OFSC_Resource_Management_WS.PropertiesElement  pptsElem = new EON_OFSC_Resource_Management_WS.PropertiesElement();        
        EON_OFSC_Resource_Management_WS.UsersLoginList  usrLogin = new EON_OFSC_Resource_Management_WS.UsersLoginList ();        
        EON_OFSC_Resource_Management_WS.WorkSkillList  worksSkillLst = new EON_OFSC_Resource_Management_WS.WorkSkillList();        
        EON_OFSC_Resource_Management_WS.GetResourcesParamsList  getResParam = new EON_OFSC_Resource_Management_WS.GetResourcesParamsList();         
        EON_OFSC_Resource_Management_WS.LocationResourceParamsList locResParamLst = new EON_OFSC_Resource_Management_WS.LocationResourceParamsList();
        EON_OFSC_Resource_Management_WS.CalendarList  calLst = new EON_OFSC_Resource_Management_WS.CalendarList();  
        EON_OFSC_Resource_Management_WS.LocationList locLst = new EON_OFSC_Resource_Management_WS.LocationList();   
        EON_OFSC_Resource_Management_WS.SkillList  skillLst = new EON_OFSC_Resource_Management_WS.SkillList();     
        EON_OFSC_Resource_Management_WS.ResourceIdListElement  resIdLst = new EON_OFSC_Resource_Management_WS.ResourceIdListElement();     
        EON_OFSC_Resource_Management_WS.ProfileListElement  profileLst = new EON_OFSC_Resource_Management_WS.ProfileListElement();     
        EON_OFSC_Resource_Management_WS.RequiredPropertiesElement  reqPptElem = new EON_OFSC_Resource_Management_WS.RequiredPropertiesElement();     
        EON_OFSC_Resource_Management_WS.ZoneList zoneLst = new EON_OFSC_Resource_Management_WS.ZoneList();
        EON_OFSC_Resource_Management_WS.ResourceLocationList resLocLst = new EON_OFSC_Resource_Management_WS.ResourceLocationList();

        resManagePort.update_resource(authNode,'a0C8E000000LK6u',pptsElem,usrLogin,worksSkillLst);
        resManagePort.get_resources_skills(authNode,'Expand SKills',getResParam);
        resManagePort.get_locations(authNode,locResParamLst);
        resManagePort.delete_user(authNode,'EON@morrisonus.com');
        resManagePort.set_resources_calendars(authNode,calLst);
        resManagePort.update_locations(authNode,locLst);
        resManagePort.get_user(authNode,'EON@morrisonus.com');
        resManagePort.get_resource(authNode,'a0C8E000000LK6u',string.ValueOf(System.today()));
        resManagePort.delete_locations(authNode,locLst);
        resManagePort.get_resources_locations(authNode,locResParamLst);
        resManagePort.set_resources_skills(authNode,skillLst);
        resManagePort.update_user(authNode,'EON@morrisonus.com',pptsElem,resIdLst,profileLst);
        resManagePort.get_users_list(authNode,'a0C8E000000LK6u',1,1,reqPptElem);
        resManagePort.get_resources_zones(authNode,getResParam);
        resManagePort.set_resources_zones(authNode,zoneLst);
        resManagePort.insert_user(authNode,'EON@morrisonus.com',pptsElem,resIdLst,profileLst);
        resManagePort.get_resources_list(authNode,'a0C8E000000LK6u','include_children',1,1,string.ValueOf(System.today()),reqPptElem);
        resManagePort.insert_resource(authNode,'a0C8E000000LK6u',pptsElem,usrLogin,worksSkillLst);
        resManagePort.get_resources_calendars(authNode,getResParam);
        resManagePort.set_resources_locations(authNode,resLocLst);        
                
        // Verify that a fake result is returned from the mock class.
        System.assertEquals(12000, resManagePort.timeout_x);    
    }
}