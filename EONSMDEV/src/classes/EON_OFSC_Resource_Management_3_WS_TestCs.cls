/* Description : This test class is for the following below classes/triggers
              EON_OFSC_Resource_Management_3_WS
              EON_OFSC_Resource_Management_3_WS_Test
*/
@istest
private class EON_OFSC_Resource_Management_3_WS_TestCs {
    /*
    Created By  : Reddeiah R
    Created On  : 09-July-2016
    Service Req : SR_EON_Scheduling_037
    Change History : 
*/
    @isTest static void set_resources_zonestest() {   
        Test.startTest();  
        EON_OFSC_Resource_Management_3_WS_TEST.temp=true;   
        Test.setMock(WebServiceMock.class, new EON_OFSC_Resource_Management_3_WS_TEST());
        EON_OFSC_Resource_Management_3_WS_TEST.temp=true;
        EON_OFSC_Resource_Management_3_WS.AuthNodeElement objAuth = new EON_OFSC_Resource_Management_3_WS.AuthNodeElement();
        objAuth.now='Test';
        objAuth.login='Login.com';
        objAuth.company='Test ZEN';
        objAuth.auth_string='Auth Test';
        
        EON_OFSC_Resource_Management_3_WS.ResourceLocationElement recElement =new EON_OFSC_Resource_Management_3_WS.ResourceLocationElement();
        recElement.resource_id= 'zensfdc';
        recElement.location_label='zen lab';
        recElement.type_x='sfdcs';
        
        /*==============frist one ===========*/
        EON_OFSC_Resource_Management_3_WS.ResourceLocationList resList = new EON_OFSC_Resource_Management_3_WS.ResourceLocationList();
        resList.resource_location=null;
        
         EON_OFSC_Resource_Management_3_WS.ResourceManagementPort objRec = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
         objRec.set_resources_locations(objAuth, resList);
         
         
        /*==============Second===========*/
        EON_OFSC_Resource_Management_3_WS.TextPropertyElement objText = new EON_OFSC_Resource_Management_3_WS.TextPropertyElement();
        objText.name='Test name';
        objText.value='Test value';
        
        EON_OFSC_Resource_Management_3_WS.TextPropertiesElement  objProp = new EON_OFSC_Resource_Management_3_WS.TextPropertiesElement();
        objProp.property=Null;

        EON_OFSC_Resource_Management_3_WS.ZoneElement objEle = new EON_OFSC_Resource_Management_3_WS.ZoneElement();
        objEle.properties=objProp;
        
        EON_OFSC_Resource_Management_3_WS.ZoneList objZone = new EON_OFSC_Resource_Management_3_WS.ZoneList();
        objZone.zone=Null;

        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort   objEON = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        objEON.set_resources_zones(objAuth,objZone);
        /*===============thired==========*/
        EON_OFSC_Resource_Management_3_WS.CalendarElement calElement = new EON_OFSC_Resource_Management_3_WS.CalendarElement();
        calElement.properties =objProp;
        
        EON_OFSC_Resource_Management_3_WS.CalendarList calList = new EON_OFSC_Resource_Management_3_WS.CalendarList();
        calList.calendar=null;
        
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort objCal= new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        objCal.set_resources_calendars(objAuth,calList);
        /*===============Fourth==========*/
        EON_OFSC_Resource_Management_3_WS.PropertiesElement proElement = new EON_OFSC_Resource_Management_3_WS.PropertiesElement ();
        proElement.property= null;
        EON_OFSC_Resource_Management_3_WS.ResourceIdListElement RecsouElement = new EON_OFSC_Resource_Management_3_WS.ResourceIdListElement();
        RecsouElement.id=null;
        string login = 'rreddeiah';
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort objupdate= new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        objupdate.update_user(objAuth,'dsfaaw',proElement,RecsouElement);
        /*====================== Fifth ====================*/
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort objDelete= new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        objDelete.delete_user(objAuth,'sfdcgt');
        /*================== sixth=====================*/
        EON_OFSC_Resource_Management_3_WS.PropertyElement propertyEle = new EON_OFSC_Resource_Management_3_WS.PropertyElement();
        propertyEle.name = 'zenlone';
        propertyEle.value='sfdclead';
        propertyEle.mime_type='selectsales';
        propertyEle.file_data='leadsfdc';
        EON_OFSC_Resource_Management_3_WS.UsersLoginList userLoginList = new EON_OFSC_Resource_Management_3_WS.UsersLoginList();
        userLoginList.login = null;
        EON_OFSC_Resource_Management_3_WS.WorkSkillList WorkList = new  EON_OFSC_Resource_Management_3_WS.WorkSkillList();
        WorkList.workskill=null;
        EON_OFSC_Resource_Management_3_WS.WorkSkillElement workSillEle = new EON_OFSC_Resource_Management_3_WS.WorkSkillElement();
        workSillEle.label = 'labelstring';
        workSillEle.ratio = 12345;
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort objUpdateUser= new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        objUpdateUser.update_resource(objAuth,'sfdcgt',proElement,userLoginList,WorkList);
        /*===========================seventh ==========================*/
        EON_OFSC_Resource_Management_3_WS.RequiredPropertiesElement reqPropertiesElement = new  EON_OFSC_Resource_Management_3_WS.RequiredPropertiesElement();
        reqPropertiesElement.label = null; 
        
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort getUserListResponseElement = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        
        getUserListResponseElement.get_users_list(objAuth,'sfdcid',12345,123,reqPropertiesElement);
        /*====================== eigth ================================== */
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort insertResource = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
            
        insertResource.insert_resource(objAuth,'sfdcid',proElement,userLoginList,WorkList );
        /*==============================ningth=====================================*/
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort getResource = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        getResource.get_resource(objAuth,'sfdcid','sfdcdate');
        /*========================tenth============================*/
        EON_OFSC_Resource_Management_3_WS.LocationResourceParamsList locResourceParamsList = new EON_OFSC_Resource_Management_3_WS.LocationResourceParamsList();
        locResourceParamsList.resource=null;
        
        EON_OFSC_Resource_Management_3_WS.LocationResourceParams locResourceParams = new EON_OFSC_Resource_Management_3_WS.LocationResourceParams();
        locResourceParams.resource_id = 'resourceid';
        locResourceParams.include_children = 'cildren';
        
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort getResourcesLocations = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        getResourcesLocations.get_resources_locations(objAuth,locResourceParamsList);
        /*=========================== 11th =======================*/
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort getResourcesList = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        getResourcesList.get_resources_list(objAuth,'sfdcid','children',12345,123,'selectcount',reqPropertiesElement );
        /*======================== 12th=======================*/
        EON_OFSC_Resource_Management_3_WS.LocationList locList = new EON_OFSC_Resource_Management_3_WS.LocationList();
        locList.location = null;
        
        EON_OFSC_Resource_Management_3_WS.LocationElement locElement = new EON_OFSC_Resource_Management_3_WS.LocationElement();
        locElement.properties = null;
        
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort updateLocation = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        
        updateLocation.update_locations(objAuth,locList);
        /*====================== 13th ====================*/
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort getUser = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        getUser.get_user(objAuth,'salsesforcelogin');
        /*=====================14th ===========================*/
        EON_OFSC_Resource_Management_3_WS.SkillList skList = new EON_OFSC_Resource_Management_3_WS.SkillList();
        skList.skill= null;
        EON_OFSC_Resource_Management_3_WS.SkillElement SkElement = new EON_OFSC_Resource_Management_3_WS.SkillElement();
        SkElement.properties=null;
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort setResourcesSkills = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        setResourcesSkills.set_resources_skills(objAuth,skList);
        /*=================================== 15th =====================*/
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort deleteLocations = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        
        deleteLocations.delete_locations(objAuth,locList);
        /*========================== 16th =====================*/
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort getLocations = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        
        getLocations.get_locations(objAuth,locResourceParamsList);
        /*========================= 17th ========================*/
        EON_OFSC_Resource_Management_3_WS.GetResourcesParamsList getResourceParamsList  = new EON_OFSC_Resource_Management_3_WS.GetResourcesParamsList();
        getResourceParamsList.resource=null;
        
        EON_OFSC_Resource_Management_3_WS.GetResourcesParamsElement getResourcesParamsEle = new EON_OFSC_Resource_Management_3_WS.GetResourcesParamsElement();
        
        getResourcesParamsEle.resource_id='resourceid';
        getResourcesParamsEle.date_x = 'resourceiddate'; 
        getResourcesParamsEle.include_children = 'Children';
        getResourcesParamsEle.include_inactive = 'Active';
        getResourcesParamsEle.duration = 123;
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort getResourcesZones = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        getResourcesZones.get_resources_zones(objAuth,getResourceParamsList);
        
        /*================================= 18th ============================*/
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort getResourcesSkills = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        getResourcesSkills.get_resources_skills(objAuth,'expandcomplexskills',getResourceParamsList);
        /*======================== 19th =================================*/
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort getResourcesCalendars = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        getResourcesCalendars.get_resources_calendars(objAuth,getResourceParamsList);
        /*===============================20th=======================================*/
        
        EON_OFSC_Resource_Management_3_WS.ResourceManagementPort insertUser = new EON_OFSC_Resource_Management_3_WS.ResourceManagementPort();
        insertUser.insert_user(objAuth,'loginsfdc',proElement,RecsouElement );
        /*=============================*/
        EON_OFSC_Resource_Management_3_WS.WeekdaysList weekdayList = new EON_OFSC_Resource_Management_3_WS.WeekdaysList();
        weekdayList.wd=null;
        EON_OFSC_Resource_Management_3_WS.SetResourceResponseElement SetResResponseElement = new EON_OFSC_Resource_Management_3_WS.SetResourceResponseElement();
        SetResResponseElement.result_code = 1234;
        SetResResponseElement.error_msg = '';
        EON_OFSC_Resource_Management_3_WS.SetResourcesLocationsResultList setResLocResults = new  EON_OFSC_Resource_Management_3_WS.SetResourcesLocationsResultList();
        
        setResLocResults.resource_location_result = null;
        EON_OFSC_Resource_Management_3_WS.LocationResultElement LocResultEle = new EON_OFSC_Resource_Management_3_WS.LocationResultElement();
        LocResultEle.result_code = 123;
        LocResultEle.result_message = 'sfdcmsg';
        
        EON_OFSC_Resource_Management_3_WS.CalendarResultElement calResultElement = new EON_OFSC_Resource_Management_3_WS.CalendarResultElement();
        calResultElement.calendar_result_code = 1234;
        calResultElement.calendar_error_msg = 'calendarerrormsg';
        calResultElement.userdata = 'zensaruser';
        
        EON_OFSC_Resource_Management_3_WS.SetUserResponseElement setUserResponseEle = new EON_OFSC_Resource_Management_3_WS.SetUserResponseElement();
        setUserResponseEle.result_code = 123;
        setUserResponseEle.error_msg = 'errormsg';
        
        EON_OFSC_Resource_Management_3_WS.GetResourcesSkillsResponseElement getResSkillResEle= new EON_OFSC_Resource_Management_3_WS.GetResourcesSkillsResponseElement();
        getResSkillResEle.result_code = 123;
        getResSkillResEle.error_msg = 'errormsg';
        
        EON_OFSC_Resource_Management_3_WS.LocationLabelList locLabel = new EON_OFSC_Resource_Management_3_WS.LocationLabelList();
        locLabel.location_label = null;
        EON_OFSC_Resource_Management_3_WS.GetResourcesCalendarsResponseElement getResCalenRespElem = new EON_OFSC_Resource_Management_3_WS.GetResourcesCalendarsResponseElement();
        getResCalenRespElem.result_code = 123;
        getResCalenRespElem.error_msg = 'errormsg';
        
        EON_OFSC_Resource_Management_3_WS.CalendarResultList calReultList = new EON_OFSC_Resource_Management_3_WS.CalendarResultList();
        calReultList.calendar_result = null;
        //EON_OFSC_Resource_Management_3_WS.ZoneResultList ZonResList = new EON_OFSC_Resource_Management_3_WS.ZoneResultLis();
       //ZonResList.zone_result = null;
        
        EON_OFSC_Resource_Management_3_WS.ZoneResultElement zoneResEle = new EON_OFSC_Resource_Management_3_WS.ZoneResultElement();
        zoneResEle.zone_result_code = 123;
        zoneResEle.zone_error_msg = 'zoneerrormsg';
        zoneResEle.userdata = 'sfdcdata';
        
        EON_OFSC_Resource_Management_3_WS.GetUserResponseElement getUserResponseEle = new EON_OFSC_Resource_Management_3_WS.GetUserResponseElement();
        getUserResponseEle.result_code=123;
        getUserResponseEle.error_msg = 'errormsg';
        
        EON_OFSC_Resource_Management_3_WS.UserListItemElement userItemElement = new EON_OFSC_Resource_Management_3_WS.UserListItemElement();
        userItemElement.properties=null;
        
        EON_OFSC_Resource_Management_3_WS.ResourceListElement resouselistElem = new  EON_OFSC_Resource_Management_3_WS.ResourceListElement();
        resouselistElem.resource=null;
        
        EON_OFSC_Resource_Management_3_WS.GetLocationsResponseElement getLocationResponseEle= new EON_OFSC_Resource_Management_3_WS.GetLocationsResponseElement();
        getLocationResponseEle.result_code=123;
        getLocationResponseEle.error_msg='errormsg';
        
        EON_OFSC_Resource_Management_3_WS.GetResourceResponseElement getResourceResponElement = new EON_OFSC_Resource_Management_3_WS.GetResourceResponseElement();
        getResourceResponElement.result_code = 123;
        getResourceResponElement.error_msg = 'error msg';
        
        EON_OFSC_Resource_Management_3_WS.SetResourcesSkillsResponseElement setResSkillResp = new EON_OFSC_Resource_Management_3_WS.SetResourcesSkillsResponseElement();
        
        setResSkillResp.result_code = 123;
        setResSkillResp.error_msg = 'error_msg';
        
        EON_OFSC_Resource_Management_3_WS.GetResourcesLocationsResponseElement getResourcesLocationsResponseElement = new EON_OFSC_Resource_Management_3_WS.GetResourcesLocationsResponseElement();
        getResourcesLocationsResponseElement.result_code = 123;
        getResourcesLocationsResponseElement.error_msg = 'error_msg';
        
        EON_OFSC_Resource_Management_3_WS.SetResourcesLocationsResponseElement setResourcesLocationsResponseElement=new EON_OFSC_Resource_Management_3_WS.SetResourcesLocationsResponseElement();
        SetResourcesLocationsResponseElement.result_code = 123;
        SetResourcesLocationsResponseElement.error_msg = 'error_msg';
        
        EON_OFSC_Resource_Management_3_WS.GetUsersListResponseElement getUsersListResponseElement = new EON_OFSC_Resource_Management_3_WS.GetUsersListResponseElement();
        getUsersListResponseElement.result_code = 123;
        getUsersListResponseElement.error_msg = 'error_msg';
        /*==============*/
        EON_OFSC_Resource_Management_3_WS.SetLocationResultList setLocationResultList= new EON_OFSC_Resource_Management_3_WS.SetLocationResultList();
        setLocationResultList.location_result = null;
        
        EON_OFSC_Resource_Management_3_WS.UserListElement userListElement = new EON_OFSC_Resource_Management_3_WS.UserListElement();
        userListElement.user_x = null; 
        EON_OFSC_Resource_Management_3_WS.GetResourcesZonesResponseElement getResourcesZonesResponseElement = new EON_OFSC_Resource_Management_3_WS.GetResourcesZonesResponseElement();
        getResourcesZonesResponseElement.result_code = 123;
        getResourcesZonesResponseElement.error_msg = 'error_msg';
        
        EON_OFSC_Resource_Management_3_WS.SetResourcesZonesResponseElement setResourcesZonesResponseElement = new EON_OFSC_Resource_Management_3_WS.SetResourcesZonesResponseElement();
        SetResourcesZonesResponseElement.result_code = 123;
        SetResourcesZonesResponseElement.error_msg = 'error_msg';
        
        EON_OFSC_Resource_Management_3_WS.SetResourcesCalendarsResponseElement setResourcesCalendarsResponseElement = new EON_OFSC_Resource_Management_3_WS.SetResourcesCalendarsResponseElement();
        setResourcesCalendarsResponseElement.result_code = 123;
        setResourcesCalendarsResponseElement.error_msg = 'error_msg';
        
        EON_OFSC_Resource_Management_3_WS.SkillResultElement skillResultElement = new EON_OFSC_Resource_Management_3_WS.SkillResultElement();
        skillResultElement.skill_result_code = 123;
        skillResultElement.skill_error_msg = 'error_msg';
        skillResultElement.userdata = 'sfdcdata';
        
        
        EON_OFSC_Resource_Management_3_WS.SetLocationsResponseElement  setLocationsResponseElement = new EON_OFSC_Resource_Management_3_WS.SetLocationsResponseElement();
        setLocationsResponseElement.result_code = 123;
        setLocationsResponseElement.error_msg = 'error_msg';
        
        EON_OFSC_Resource_Management_3_WS.SkillResultList skillResultList = new EON_OFSC_Resource_Management_3_WS.SkillResultList();
        skillResultList.skill_result= null;
        
        EON_OFSC_Resource_Management_3_WS.ResourceListItemElement resourceListItemElement = new EON_OFSC_Resource_Management_3_WS.ResourceListItemElement();
        resourceListItemElement.properties=null;
        resourceListItemElement.workskills=null;
        
        EON_OFSC_Resource_Management_3_WS.ZoneResultList zoneResultList = new  EON_OFSC_Resource_Management_3_WS.ZoneResultList();
        zoneResultList.zone_result=null;
        
        EON_OFSC_Resource_Management_3_WS.GetResourcesListResponseElement getResourcesListResponseElement = new EON_OFSC_Resource_Management_3_WS.GetResourcesListResponseElement();
        getResourcesListResponseElement.result_code = 123;
        getResourcesListResponseElement.error_msg = 'error_msg';
        getResourcesListResponseElement.resources = null;
        getResourcesListResponseElement.resources_count = 123;
        
        Test.stopTest();
    } 

}