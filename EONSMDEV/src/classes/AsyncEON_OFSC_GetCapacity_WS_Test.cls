/**
Description:   This class covers following Trigeer/Classes
                1.AsyncEON_OFSC_GetCapacity_WS 
**/
/*
    Created By: Chandan Kumar
    Created On: 07/04/2016
    Service Req: SR_EON_AB_022
    Change History
*/
@isTest
public class AsyncEON_OFSC_GetCapacity_WS_Test{
    static testMethod void myTest() {

            System.Continuation continuation = new System.Continuation(60);
            AsyncEON_OFSC_GetCapacity_WS.set_quota_response_elementFuture obj1=new AsyncEON_OFSC_GetCapacity_WS.set_quota_response_elementFuture();
            AsyncEON_OFSC_GetCapacity_WS.Asynctoa_capacity_interface obj2 = New AsyncEON_OFSC_GetCapacity_WS.Asynctoa_capacity_interface();
            obj1 = obj2.beginSet_quota(continuation,Null,Null); 
            obj2.beginSet_quota(continuation,Null,Null);
            obj2.beginSet_quota_close_time(continuation,Null,Null);
            obj2.beginGet_quota_data(continuation,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null);
            obj2.beginGet_quota_close_time(continuation,Null,Null,Null,Null,Null,Null);
            obj2.beginGet_capacity(continuation,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null);
            
            EON_OFSC_GetCapacity_WS.set_quota_response_element obj3=new EON_OFSC_GetCapacity_WS.set_quota_response_element();
            EON_OFSC_GetCapacity_WS.set_quota_result_element listEONObj =new EON_OFSC_GetCapacity_WS.set_quota_result_element();
            listEONObj.bucket_id ='test123';
            listEONObj.date_x ='12/02/2016';
            listEONObj.time_slot ='time_slot';
            listEONObj.category ='test';
            listEONObj.result_code = 10;
            listEONObj.error_msg = 'test error';
  
            List<EON_OFSC_GetCapacity_WS.set_quota_result_element> listEON=new List<EON_OFSC_GetCapacity_WS.set_quota_result_element>();
            listEON.add(listEONObj);
            obj3.result= listEON;
            try{
                obj1.getValue();
            }Catch(Exception e){}
            try{
                AsyncEON_OFSC_GetCapacity_WS.set_quota_close_time_response_elementFuture obj4=new AsyncEON_OFSC_GetCapacity_WS.set_quota_close_time_response_elementFuture();
                obj4.getValue();
            }Catch(Exception e){}
            try{
                AsyncEON_OFSC_GetCapacity_WS.get_quota_data_response_elementFuture obj5=new AsyncEON_OFSC_GetCapacity_WS.get_quota_data_response_elementFuture();
                obj5.getValue();
            }Catch(Exception e){}
            try{
                AsyncEON_OFSC_GetCapacity_WS.get_quota_close_time_response_elementFuture obj6=new AsyncEON_OFSC_GetCapacity_WS.get_quota_close_time_response_elementFuture();
                obj6.getValue();
            }Catch(Exception e){}
            try{
                AsyncEON_OFSC_GetCapacity_WS.capacity_response_elementFuture obj7=new AsyncEON_OFSC_GetCapacity_WS.capacity_response_elementFuture();
                obj7.getValue();
            }Catch(Exception e){}
    }
}