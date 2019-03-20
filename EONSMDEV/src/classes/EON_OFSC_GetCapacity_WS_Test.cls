/**
Description:   This class covers following Trigeer/Classes
                1.EON_OFSC_GetCapacity_WS
**/
/*
    Created By: Chandan Kumar
    Created On: 07/04/2016
    Service Req: SR_EON_AB_022
    Change History
*/
@IsTest
private with sharing class EON_OFSC_GetCapacity_WS_Test{

private static testMethod void coverTypes()
    {
     
     EON_OFSC_GetCapacity_WS.set_quota_day_element ofcGetCap=  new EON_OFSC_GetCapacity_WS.set_quota_day_element();
     EON_OFSC_GetCapacity_WS.activity_field_element ofcActvity = new EON_OFSC_GetCapacity_WS.activity_field_element();
     EON_OFSC_GetCapacity_WS.set_quota_response_element ofscres = new EON_OFSC_GetCapacity_WS.set_quota_response_element();
     EON_OFSC_GetCapacity_WS.capacity_request_element ofscreq = new EON_OFSC_GetCapacity_WS.capacity_request_element ();
     EON_OFSC_GetCapacity_WS.get_quota_data_response_element ofscdres = new EON_OFSC_GetCapacity_WS.get_quota_data_response_element();
     EON_OFSC_GetCapacity_WS.get_quota_data_bucket_element ofscqdbucket = new EON_OFSC_GetCapacity_WS.get_quota_data_bucket_element();
     EON_OFSC_GetCapacity_WS.get_quota_close_time_request_element ofsctime = new EON_OFSC_GetCapacity_WS.get_quota_close_time_request_element();
     EON_OFSC_GetCapacity_WS.set_quota_close_time_response_element ofsctimeres= new EON_OFSC_GetCapacity_WS.set_quota_close_time_response_element();
     EON_OFSC_GetCapacity_WS.get_quota_data_request_element ofscqdataresp = new EON_OFSC_GetCapacity_WS.get_quota_data_request_element();
     EON_OFSC_GetCapacity_WS.set_quota_bucket_element setqbucket = new EON_OFSC_GetCapacity_WS.set_quota_bucket_element ();
     EON_OFSC_GetCapacity_WS.get_quota_close_time_response_element ofscgetctimeresp = new EON_OFSC_GetCapacity_WS.get_quota_close_time_response_element();
     EON_OFSC_GetCapacity_WS.set_quota_category_element ofscscategelmt = new EON_OFSC_GetCapacity_WS.set_quota_category_element();
     EON_OFSC_GetCapacity_WS.set_quota_close_time_request_element ofscsectimelmt =  new EON_OFSC_GetCapacity_WS.set_quota_close_time_request_element();
     EON_OFSC_GetCapacity_WS.user_element ofscCapUsr =  new EON_OFSC_GetCapacity_WS.user_element();
     EON_OFSC_GetCapacity_WS.set_quota_request_element ofscrewemt =   new EON_OFSC_GetCapacity_WS.set_quota_request_element();
     EON_OFSC_GetCapacity_WS.get_quota_data_day_total_element ofscdaytotal = new EON_OFSC_GetCapacity_WS.get_quota_data_day_total_element();
     EON_OFSC_GetCapacity_WS.set_quota_time_slot_element ofsctimeslotelmt = new EON_OFSC_GetCapacity_WS.set_quota_time_slot_element();
     EON_OFSC_GetCapacity_WS.get_quota_data_day_element ofscdataDay = new EON_OFSC_GetCapacity_WS.get_quota_data_day_element();
     EON_OFSC_GetCapacity_WS.time_slot_info_element timeslotinfo = new EON_OFSC_GetCapacity_WS.time_slot_info_element();
     EON_OFSC_GetCapacity_WS.set_quota_result_element qResult = new EON_OFSC_GetCapacity_WS.set_quota_result_element();
     EON_OFSC_GetCapacity_WS.get_quota_data_work_zone_element qdataWork = new EON_OFSC_GetCapacity_WS.get_quota_data_work_zone_element();
     EON_OFSC_GetCapacity_WS.capacity_response_element ofsceCapResp = new EON_OFSC_GetCapacity_WS.capacity_response_element ();
     EON_OFSC_GetCapacity_WS.get_quota_data_category_element ofscdataelmt = new EON_OFSC_GetCapacity_WS.get_quota_data_category_element ();
     EON_OFSC_GetCapacity_WS.get_quota_data_time_slot_element timeSlotElm = new EON_OFSC_GetCapacity_WS.get_quota_data_time_slot_element ();
     EON_OFSC_GetCapacity_WS.set_quota_close_time_result closeTime = new EON_OFSC_GetCapacity_WS.set_quota_close_time_result ();
     EON_OFSC_GetCapacity_WS.quota_close_time_schedule closeTimeSch = new EON_OFSC_GetCapacity_WS.quota_close_time_schedule ();
     EON_OFSC_GetCapacity_WS.get_quota_data_time_slot_total_element TimeSlotTotal =  new EON_OFSC_GetCapacity_WS.get_quota_data_time_slot_total_element ();
     EON_OFSC_GetCapacity_WS.capacity_element ofscCapElemt =   new EON_OFSC_GetCapacity_WS.capacity_element();
     EON_OFSC_GetCapacity_WS.set_quota_work_zone_element ofscWorkZone =  new EON_OFSC_GetCapacity_WS.set_quota_work_zone_element();
     EON_OFSC_GetCapacity_WS.toa_capacity_interface toainf = new EON_OFSC_GetCapacity_WS.toa_capacity_interface();                
        
    }
    
   private static testMethod void EON_OFSC_GetCapacity_CalloutTest()
   {   
     // This causes a fake response to be generated
     Test.setMock(WebServiceMock.class, new EON_OFSC_GetCapacity_WS_ServicesMock());   
     EON_OFSC_GetCapacity_WS.toa_capacity_interface taCap = new EON_OFSC_GetCapacity_WS.toa_capacity_interface();
     taCap.endpoint_x = 'https://api.etadirect.com/soap/';
     taCap.inputHttpHeaders_x =null;
     taCap.outputHttpHeaders_x = null;
     taCap.clientCertName_x = 'TestEon';
     taCap.clientCert_x ='Test_';
     taCap.clientCertPasswd_x = 'Test@123';
     taCap.timeout_x = 12000;
     EON_OFSC_GetCapacity_WS.user_element  eonUsr = new EON_OFSC_GetCapacity_WS.user_element();
     eonUsr.now = string.ValueOf(System.now());
     eonUsr.login = 'EON@morrisonus.com';
     eonUsr.company = 'MUS';
     eonUsr.auth_string = 'MUS USER AUTHENTICATED';
     List<EON_OFSC_GetCapacity_WS.set_quota_day_element> edlst = new List<EON_OFSC_GetCapacity_WS.set_quota_day_element>();
     EON_OFSC_GetCapacity_WS.set_quota_bucket_element testbuk = new EON_OFSC_GetCapacity_WS.set_quota_bucket_element(); 
     testbuk.bucket_id ='1213444';
     testbuk.day =edlst ;
     List<EON_OFSC_GetCapacity_WS.set_quota_bucket_element> lstbucket = new List<EON_OFSC_GetCapacity_WS.set_quota_bucket_element>(); 
     lstbucket.add(testbuk); 
     taCap.set_quota(eonUsr,lstbucket );
     taCap.set_quota(null,null);
     taCap.set_quota_close_time(eonUsr,Null);
     taCap.get_quota_data(eonUsr,Null,NUll,Null,NUll,Null,NUll,Null,NUll,Null,NUll);
     taCap.get_quota_close_time(eonUsr,Null,NUll,Null,NUll,Null);
     taCap.get_capacity(eonUsr,Null,NUll,Null,NUll,Null,Null,NUll,Null,NUll,Null,Null,NUll,Null);
     System.assertEquals(12000, taCap.timeout_x);    
   }

 
    
}