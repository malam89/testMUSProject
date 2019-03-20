/**
    Description : This class generated through Oracle Activity WSDL
                  
    VF Page     : 
    Test Class  : EON_OFSC_Activity_WS_Test

**/
/*
    Created By  : Mahadev Joshilkar
    Created On  : 08/04/2016
    Service Req : SR_EON_Mobile_009
    Change History : 
*/
public class EON_OFSC_Activity_WS {
    public class get_required_inventories_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id'};
    }
    public class get_route_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String date_x;
        public String resource_id;
        public String[] property_filter;
        public Integer select_from;
        public Integer select_count;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] date_x_type_info = new String[]{'date','urn:toa:activity',null,'1','1','false'};
        private String[] resource_id_type_info = new String[]{'resource_id','urn:toa:activity',null,'1','1','false'};
        private String[] property_filter_type_info = new String[]{'property_filter','urn:toa:activity',null,'0','-1','false'};
        private String[] select_from_type_info = new String[]{'select_from','urn:toa:activity',null,'0','1','false'};
        private String[] select_count_type_info = new String[]{'select_count','urn:toa:activity',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','date_x','resource_id','property_filter','select_from','select_count'};
    }
    public class start_route_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String resource_id;
        public String time_x;
        public String date_x;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] resource_id_type_info = new String[]{'resource_id','urn:toa:activity',null,'1','1','false'};
        private String[] time_x_type_info = new String[]{'time','urn:toa:activity',null,'1','1','false'};
        private String[] date_x_type_info = new String[]{'date','urn:toa:activity',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','resource_id','time_x','date_x'};
    }
    public class get_file_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String entity_id;
        public String property_id;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] entity_id_type_info = new String[]{'entity_id','urn:toa:activity',null,'1','1','false'};
        private String[] property_id_type_info = new String[]{'property_id','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','entity_id','property_id'};
    }
    public class unlink_activities_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String from_activity_id;
        public String to_activity_id;
        public String link_type;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] from_activity_id_type_info = new String[]{'from_activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] to_activity_id_type_info = new String[]{'to_activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] link_type_type_info = new String[]{'link_type','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','from_activity_id','to_activity_id','link_type'};
    }
    public class link {
        public String link_type;
        public String activity_id;
        public String resource_id;
        public String resource_name;
        public String activity_status;
        public String activity_identifier;
        public String activity_start_time;
        public Integer alerts;
        public Boolean is_broken;
        public String min_interval;
        public String max_interval;
        private String[] link_type_type_info = new String[]{'link_type','urn:toa:activity',null,'0','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'0','1','false'};
        private String[] resource_id_type_info = new String[]{'resource_id','urn:toa:activity',null,'0','1','false'};
        private String[] resource_name_type_info = new String[]{'resource_name','urn:toa:activity',null,'0','1','false'};
        private String[] activity_status_type_info = new String[]{'activity_status','urn:toa:activity',null,'0','1','false'};
        private String[] activity_identifier_type_info = new String[]{'activity_identifier','urn:toa:activity',null,'0','1','false'};
        private String[] activity_start_time_type_info = new String[]{'activity_start_time','urn:toa:activity',null,'0','1','false'};
        private String[] alerts_type_info = new String[]{'alerts','urn:toa:activity',null,'0','1','false'};
        private String[] is_broken_type_info = new String[]{'is_broken','urn:toa:activity',null,'0','1','false'};
        private String[] min_interval_type_info = new String[]{'min_interval','urn:toa:activity',null,'0','1','false'};
        private String[] max_interval_type_info = new String[]{'max_interval','urn:toa:activity',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'link_type','activity_id','resource_id','resource_name','activity_status','activity_identifier','activity_start_time','alerts','is_broken','min_interval','max_interval'};
    }
    public class search_activities_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String search_in;
        public String search_for;
        public String date_from;
        public String date_to;
        public String select_from;
        public String select_count;
        public String order;
        public String[] property_filter;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] search_in_type_info = new String[]{'search_in','urn:toa:activity',null,'1','1','false'};
        private String[] search_for_type_info = new String[]{'search_for','urn:toa:activity',null,'1','1','false'};
        private String[] date_from_type_info = new String[]{'date_from','urn:toa:activity',null,'1','1','false'};
        private String[] date_to_type_info = new String[]{'date_to','urn:toa:activity',null,'1','1','false'};
        private String[] select_from_type_info = new String[]{'select_from','urn:toa:activity',null,'1','1','false'};
        private String[] select_count_type_info = new String[]{'select_count','urn:toa:activity',null,'1','1','false'};
        private String[] order_type_info = new String[]{'order','urn:toa:activity',null,'0','1','false'};
        private String[] property_filter_type_info = new String[]{'property_filter','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','search_in','search_for','date_from','date_to','select_from','select_count','order','property_filter'};
    }
    public class create_activity_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String date_x;
        public String resource_id;
        public String position_in_route;
        public EON_OFSC_Activity_WS.property[] properties;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] date_x_type_info = new String[]{'date','urn:toa:activity',null,'1','1','false'};
        private String[] resource_id_type_info = new String[]{'resource_id','urn:toa:activity',null,'1','1','false'};
        private String[] position_in_route_type_info = new String[]{'position_in_route','urn:toa:activity',null,'1','1','false'};
        private String[] properties_type_info = new String[]{'properties','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','date_x','resource_id','position_in_route','properties'};
    }
    public class set_resource_preferences_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        public EON_OFSC_Activity_WS.resource_preference[] preference;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] preference_type_info = new String[]{'preference','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id','preference'};
    }
    public class get_resource_preferences_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id'};
    }
    public class get_file_response_element {
        public Integer result_code;
        public String error_msg;
        public String file_name;
        public String file_data;
        public String file_mime_type;
        private String[] result_code_type_info = new String[]{'result_code','urn:toa:activity',null,'1','1','false'};
        private String[] error_msg_type_info = new String[]{'error_msg','urn:toa:activity',null,'0','1','false'};
        private String[] file_name_type_info = new String[]{'file_name','urn:toa:activity',null,'0','1','false'};
        private String[] file_data_type_info = new String[]{'file_data','urn:toa:activity',null,'0','1','false'};
        private String[] file_mime_type_type_info = new String[]{'file_mime_type','urn:toa:activity',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'result_code','error_msg','file_name','file_data','file_mime_type'};
    }
    public class get_resource_preferences_response {
        public Integer result_code;
        public String error_msg;
        public EON_OFSC_Activity_WS.resource_preference[] preference;
        private String[] result_code_type_info = new String[]{'result_code','urn:toa:activity',null,'1','1','false'};
        private String[] error_msg_type_info = new String[]{'error_msg','urn:toa:activity',null,'0','1','false'};
        private String[] preference_type_info = new String[]{'preference','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'result_code','error_msg','preference'};
    }
    public class get_activity_work_skills_response {
        public Integer result_code;
        public String error_msg;
        public EON_OFSC_Activity_WS.work_skill[] work_skill;
        public EON_OFSC_Activity_WS.capacity_category[] capacity_category;
        private String[] result_code_type_info = new String[]{'result_code','urn:toa:activity',null,'1','1','false'};
        private String[] error_msg_type_info = new String[]{'error_msg','urn:toa:activity',null,'0','1','false'};
        private String[] work_skill_type_info = new String[]{'work_skill','urn:toa:activity',null,'0','-1','false'};
        private String[] capacity_category_type_info = new String[]{'capacity_category','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'result_code','error_msg','work_skill','capacity_category'};
    }
    public class get_required_inventories_response {
        public Integer result_code;
        public String error_msg;
        public EON_OFSC_Activity_WS.required_inventory[] required_inventory;
        private String[] result_code_type_info = new String[]{'result_code','urn:toa:activity',null,'1','1','false'};
        private String[] error_msg_type_info = new String[]{'error_msg','urn:toa:activity',null,'0','1','false'};
        private String[] required_inventory_type_info = new String[]{'required_inventory','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'result_code','error_msg','required_inventory'};
    }
    public class resource_preference {
        public String resource_id;
        public String type_x;
        private String[] resource_id_type_info = new String[]{'resource_id','urn:toa:activity',null,'1','1','false'};
        private String[] type_x_type_info = new String[]{'type','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'resource_id','type_x'};
    }
    public class set_required_inventories_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        public EON_OFSC_Activity_WS.required_inventory[] required_inventory;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] required_inventory_type_info = new String[]{'required_inventory','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id','required_inventory'};
    }
    public class action_activity_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        public String date_x;
        public String time_x;
        public EON_OFSC_Activity_WS.property[] properties;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] date_x_type_info = new String[]{'date','urn:toa:activity',null,'0','1','false'};
        private String[] time_x_type_info = new String[]{'time','urn:toa:activity',null,'1','1','false'};
        private String[] properties_type_info = new String[]{'properties','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id','date_x','time_x','properties'};
    }
    public class activity_list {
        public Integer total;
        public EON_OFSC_Activity_WS.activities activities;
        public String route_start_time;
        public String route_end_time;
        private String[] total_type_info = new String[]{'total','urn:toa:activity',null,'1','1','false'};
        private String[] activities_type_info = new String[]{'activities','urn:toa:activity',null,'0','1','false'};
        private String[] route_start_time_type_info = new String[]{'route_start_time','urn:toa:activity',null,'0','1','false'};
        private String[] route_end_time_type_info = new String[]{'route_end_time','urn:toa:activity',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'total','activities','route_start_time','route_end_time'};
    }
    public class activities {
        public EON_OFSC_Activity_WS.activity[] activity;
        private String[] activity_type_info = new String[]{'activity','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'activity'};
    }
    public class get_activity_links_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id'};
    }
    public class activity {
        public EON_OFSC_Activity_WS.property[] properties;
        private String[] properties_type_info = new String[]{'properties','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'properties'};
    }
    public class capacity_category {
        public String name;
        public String description;
        private String[] name_type_info = new String[]{'name','urn:toa:activity',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'name','description'};
    }
    public class get_activity_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id'};
    }
    public class link_activities_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String from_activity_id;
        public String to_activity_id;
        public String link_type;
        public String min_interval;
        public String max_interval;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] from_activity_id_type_info = new String[]{'from_activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] to_activity_id_type_info = new String[]{'to_activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] link_type_type_info = new String[]{'link_type','urn:toa:activity',null,'1','1','false'};
        private String[] min_interval_type_info = new String[]{'min_interval','urn:toa:activity',null,'0','1','false'};
        private String[] max_interval_type_info = new String[]{'max_interval','urn:toa:activity',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','from_activity_id','to_activity_id','link_type','min_interval','max_interval'};
    }
    public class activity_response {
        public Integer result_code;
        public String error_msg;
        public EON_OFSC_Activity_WS.activity activity;
        public EON_OFSC_Activity_WS.activity_list activity_list;
        private String[] result_code_type_info = new String[]{'result_code','urn:toa:activity',null,'1','1','false'};
        private String[] error_msg_type_info = new String[]{'error_msg','urn:toa:activity',null,'0','1','false'};
        private String[] activity_type_info = new String[]{'activity','urn:toa:activity',null,'0','1','false'};
        private String[] activity_list_type_info = new String[]{'activity_list','urn:toa:activity',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'result_code','error_msg','activity','activity_list'};
    }
    public class work_skill {
        public String name;
        public String description;
        public Integer required_level;
        public Integer preferable_level;
        private String[] name_type_info = new String[]{'name','urn:toa:activity',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','urn:toa:activity',null,'1','1','false'};
        private String[] required_level_type_info = new String[]{'required_level','urn:toa:activity',null,'1','1','false'};
        private String[] preferable_level_type_info = new String[]{'preferable_level','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'name','description','required_level','preferable_level'};
    }
    public class delay_activity_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        public String date_x;
        public Integer value;
        public EON_OFSC_Activity_WS.property[] properties;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] date_x_type_info = new String[]{'date','urn:toa:activity',null,'0','1','false'};
        private String[] value_type_info = new String[]{'value','urn:toa:activity',null,'1','1','false'};
        private String[] properties_type_info = new String[]{'properties','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id','date_x','value','properties'};
    }
    public class links {
        public Integer total;
        public EON_OFSC_Activity_WS.link[] link;
        private String[] total_type_info = new String[]{'total','urn:toa:activity',null,'1','1','false'};
        private String[] link_type_info = new String[]{'link','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'total','link'};
    }
    public class property {
        public String name;
        public String value;
        private String[] name_type_info = new String[]{'name','urn:toa:activity',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'name','value'};
    }
    public class required_inventory {
        public String type_x;
        public String model;
        public String quantity;
        private String[] type_x_type_info = new String[]{'type','urn:toa:activity',null,'1','1','false'};
        private String[] model_type_info = new String[]{'model','urn:toa:activity',null,'0','1','false'};
        private String[] quantity_type_info = new String[]{'quantity','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'type_x','model','quantity'};
    }
    public class get_activity_links_response_element {
        public Integer result_code;
        public String error_msg;
        public EON_OFSC_Activity_WS.link[] link;
        private String[] result_code_type_info = new String[]{'result_code','urn:toa:activity',null,'1','1','false'};
        private String[] error_msg_type_info = new String[]{'error_msg','urn:toa:activity',null,'0','1','false'};
        private String[] link_type_info = new String[]{'link','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'result_code','error_msg','link'};
    }
    public class simple_response {
        public Integer result_code;
        public String error_msg;
        private String[] result_code_type_info = new String[]{'result_code','urn:toa:activity',null,'1','1','false'};
        private String[] error_msg_type_info = new String[]{'error_msg','urn:toa:activity',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'result_code','error_msg'};
    }
    public class get_activity_work_skills_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id'};
    }
    public class user_x {
        public String now;
        public String login;
        public String company;
        public String auth_string;
        private String[] now_type_info = new String[]{'now','urn:toa:activity',null,'1','1','false'};
        private String[] login_type_info = new String[]{'login','urn:toa:activity',null,'1','1','false'};
        private String[] company_type_info = new String[]{'company','urn:toa:activity',null,'1','1','false'};
        private String[] auth_string_type_info = new String[]{'auth_string','urn:toa:activity',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'now','login','company','auth_string'};
    }
    public class set_file_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String entity_id;
        public String property_id;
        public String file_name;
        public String file_data;
        public String file_mime_type;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] entity_id_type_info = new String[]{'entity_id','urn:toa:activity',null,'1','1','false'};
        private String[] property_id_type_info = new String[]{'property_id','urn:toa:activity',null,'1','1','false'};
        private String[] file_name_type_info = new String[]{'file_name','urn:toa:activity',null,'1','1','false'};
        private String[] file_data_type_info = new String[]{'file_data','urn:toa:activity',null,'1','1','false'};
        private String[] file_mime_type_type_info = new String[]{'file_mime_type','urn:toa:activity',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','entity_id','property_id','file_name','file_data','file_mime_type'};
    }
    public class update_activity_parameters {
        public EON_OFSC_Activity_WS.user_x user_x;
        public String activity_id;
        public String position_in_route;
        public EON_OFSC_Activity_WS.property[] properties;
        private String[] user_x_type_info = new String[]{'user','urn:toa:activity',null,'1','1','false'};
        private String[] activity_id_type_info = new String[]{'activity_id','urn:toa:activity',null,'1','1','false'};
        private String[] position_in_route_type_info = new String[]{'position_in_route','urn:toa:activity',null,'1','1','false'};
        private String[] properties_type_info = new String[]{'properties','urn:toa:activity',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:toa:activity','false','false'};
        private String[] field_order_type_info = new String[]{'user_x','activity_id','position_in_route','properties'};
    }
    public class activity_binding {
        //public String endpoint_x = 'https://api.etadirect.com/soap/activity/';
        public String endpoint_x = System.label.EON_OFSC_Activity_Endpoint;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'urn:toa:activity', 'EON_OFSC_Activity_WS'};
        public EON_OFSC_Activity_WS.get_resource_preferences_response get_resource_preferences(EON_OFSC_Activity_WS.user_x user_x,String activity_id) {
            EON_OFSC_Activity_WS.get_resource_preferences_parameters request_x = new EON_OFSC_Activity_WS.get_resource_preferences_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            EON_OFSC_Activity_WS.get_resource_preferences_response response_x;
            Map<String, EON_OFSC_Activity_WS.get_resource_preferences_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.get_resource_preferences_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/get_resource_preferences',
              'urn:toa:activity',
              'get_resource_preferences',
              'urn:toa:activity',
              'get_resource_preferences_response',
              'EON_OFSC_Activity_WS.get_resource_preferences_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response cancel_activity(EON_OFSC_Activity_WS.user_x user_x,String activity_id,String date_x,String time_x,EON_OFSC_Activity_WS.property[] properties) {
            EON_OFSC_Activity_WS.action_activity_parameters request_x = new EON_OFSC_Activity_WS.action_activity_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.date_x = date_x;
            request_x.time_x = time_x;
            request_x.properties = properties;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/cancel_activity',
              'urn:toa:activity',
              'cancel_activity',
              'urn:toa:activity',
              'cancel_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response search_activities(EON_OFSC_Activity_WS.user_x user_x,String search_in,String search_for,String date_from,String date_to,String select_from,String select_count,String order,String[] property_filter) {
            EON_OFSC_Activity_WS.search_activities_parameters request_x = new EON_OFSC_Activity_WS.search_activities_parameters();
            request_x.user_x = user_x;
            request_x.search_in = search_in;
            request_x.search_for = search_for;
            request_x.date_from = date_from;
            request_x.date_to = date_to;
            request_x.select_from = select_from;
            request_x.select_count = select_count;
            request_x.order = order;
            request_x.property_filter = property_filter;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/search_activities',
              'urn:toa:activity',
              'search_activities',
              'urn:toa:activity',
              'search_activities_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response get_activity(EON_OFSC_Activity_WS.user_x user_x,String activity_id) {
            EON_OFSC_Activity_WS.get_activity_parameters request_x = new EON_OFSC_Activity_WS.get_activity_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/get_activity',
              'urn:toa:activity',
              'get_activity',
              'urn:toa:activity',
              'get_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response delay_activity(EON_OFSC_Activity_WS.user_x user_x,String activity_id,String date_x,Integer value,EON_OFSC_Activity_WS.property[] properties) {
            EON_OFSC_Activity_WS.delay_activity_parameters request_x = new EON_OFSC_Activity_WS.delay_activity_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.date_x = date_x;
            request_x.value = value;
            request_x.properties = properties;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/delay_activity',
              'urn:toa:activity',
              'delay_activity',
              'urn:toa:activity',
              'delay_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.simple_response set_required_inventories(EON_OFSC_Activity_WS.user_x user_x,String activity_id,EON_OFSC_Activity_WS.required_inventory[] required_inventory) {
            EON_OFSC_Activity_WS.set_required_inventories_parameters request_x = new EON_OFSC_Activity_WS.set_required_inventories_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.required_inventory = required_inventory;
            EON_OFSC_Activity_WS.simple_response response_x;
            Map<String, EON_OFSC_Activity_WS.simple_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.simple_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/set_required_inventories',
              'urn:toa:activity',
              'set_required_inventories',
              'urn:toa:activity',
              'set_required_inventories_response',
              'EON_OFSC_Activity_WS.simple_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response complete_activity(EON_OFSC_Activity_WS.user_x user_x,String activity_id,String date_x,String time_x,EON_OFSC_Activity_WS.property[] properties) {
            EON_OFSC_Activity_WS.action_activity_parameters request_x = new EON_OFSC_Activity_WS.action_activity_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.date_x = date_x;
            request_x.time_x = time_x;
            request_x.properties = properties;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/complete_activity',
              'urn:toa:activity',
              'complete_activity',
              'urn:toa:activity',
              'complete_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.simple_response start_route(EON_OFSC_Activity_WS.user_x user_x,String resource_id,String time_x,String date_x) {
            EON_OFSC_Activity_WS.start_route_parameters request_x = new EON_OFSC_Activity_WS.start_route_parameters();
            request_x.user_x = user_x;
            request_x.resource_id = resource_id;
            request_x.time_x = time_x;
            request_x.date_x = date_x;
            EON_OFSC_Activity_WS.simple_response response_x;
            Map<String, EON_OFSC_Activity_WS.simple_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.simple_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/start_route',
              'urn:toa:activity',
              'start_route',
              'urn:toa:activity',
              'start_route_response',
              'EON_OFSC_Activity_WS.simple_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response suspend_activity(EON_OFSC_Activity_WS.user_x user_x,String activity_id,String date_x,String time_x,EON_OFSC_Activity_WS.property[] properties) {
            EON_OFSC_Activity_WS.action_activity_parameters request_x = new EON_OFSC_Activity_WS.action_activity_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.date_x = date_x;
            request_x.time_x = time_x;
            request_x.properties = properties;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/suspend_activity',
              'urn:toa:activity',
              'suspend_activity',
              'urn:toa:activity',
              'suspend_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.get_file_response_element get_file(EON_OFSC_Activity_WS.user_x user_x,String entity_id,String property_id) {
            EON_OFSC_Activity_WS.get_file_parameters request_x = new EON_OFSC_Activity_WS.get_file_parameters();
            request_x.user_x = user_x;
            request_x.entity_id = entity_id;
            request_x.property_id = property_id;
            EON_OFSC_Activity_WS.get_file_response_element response_x;
            Map<String, EON_OFSC_Activity_WS.get_file_response_element> response_map_x = new Map<String, EON_OFSC_Activity_WS.get_file_response_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/get_file',
              'urn:toa:activity',
              'get_file',
              'urn:toa:activity',
              'get_file_response',
              'EON_OFSC_Activity_WS.get_file_response_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response prework_activity(EON_OFSC_Activity_WS.user_x user_x,String activity_id,String date_x,String time_x,EON_OFSC_Activity_WS.property[] properties) {
            EON_OFSC_Activity_WS.action_activity_parameters request_x = new EON_OFSC_Activity_WS.action_activity_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.date_x = date_x;
            request_x.time_x = time_x;
            request_x.properties = properties;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/prework_activity',
              'urn:toa:activity',
              'prework_activity',
              'urn:toa:activity',
              'prework_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.simple_response delete_file(EON_OFSC_Activity_WS.user_x user_x,String entity_id,String property_id) {
            EON_OFSC_Activity_WS.get_file_parameters request_x = new EON_OFSC_Activity_WS.get_file_parameters();
            request_x.user_x = user_x;
            request_x.entity_id = entity_id;
            request_x.property_id = property_id;
            EON_OFSC_Activity_WS.simple_response response_x;
            Map<String, EON_OFSC_Activity_WS.simple_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.simple_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/delete_file',
              'urn:toa:activity',
              'delete_file',
              'urn:toa:activity',
              'delete_file_response',
              'EON_OFSC_Activity_WS.simple_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.get_activity_work_skills_response get_activity_work_skills(EON_OFSC_Activity_WS.user_x user_x,String activity_id) {
            EON_OFSC_Activity_WS.get_activity_work_skills_parameters request_x = new EON_OFSC_Activity_WS.get_activity_work_skills_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            EON_OFSC_Activity_WS.get_activity_work_skills_response response_x;
            Map<String, EON_OFSC_Activity_WS.get_activity_work_skills_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.get_activity_work_skills_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/get_activity_work_skills',
              'urn:toa:activity',
              'get_activity_work_skills',
              'urn:toa:activity',
              'get_activity_work_skills_response',
              'EON_OFSC_Activity_WS.get_activity_work_skills_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response start_activity(EON_OFSC_Activity_WS.user_x user_x,String activity_id,String date_x,String time_x,EON_OFSC_Activity_WS.property[] properties) {
            EON_OFSC_Activity_WS.action_activity_parameters request_x = new EON_OFSC_Activity_WS.action_activity_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.date_x = date_x;
            request_x.time_x = time_x;
            request_x.properties = properties;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/start_activity',
              'urn:toa:activity',
              'start_activity',
              'urn:toa:activity',
              'start_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.simple_response set_resource_preferences(EON_OFSC_Activity_WS.user_x user_x,String activity_id,EON_OFSC_Activity_WS.resource_preference[] preference) {
            EON_OFSC_Activity_WS.set_resource_preferences_parameters request_x = new EON_OFSC_Activity_WS.set_resource_preferences_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.preference = preference;
            EON_OFSC_Activity_WS.simple_response response_x;
            Map<String, EON_OFSC_Activity_WS.simple_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.simple_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/set_resource_preferences',
              'urn:toa:activity',
              'set_resource_preferences',
              'urn:toa:activity',
              'set_resource_preferences_response',
              'EON_OFSC_Activity_WS.simple_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.simple_response end_route(EON_OFSC_Activity_WS.user_x user_x,String resource_id,String time_x,String date_x) {
            EON_OFSC_Activity_WS.start_route_parameters request_x = new EON_OFSC_Activity_WS.start_route_parameters();
            request_x.user_x = user_x;
            request_x.resource_id = resource_id;
            request_x.time_x = time_x;
            request_x.date_x = date_x;
            EON_OFSC_Activity_WS.simple_response response_x;
            Map<String, EON_OFSC_Activity_WS.simple_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.simple_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/end_route',
              'urn:toa:activity',
              'end_route',
              'urn:toa:activity',
              'end_route_response',
              'EON_OFSC_Activity_WS.simple_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response get_route(EON_OFSC_Activity_WS.user_x user_x,String date_x,String resource_id,String[] property_filter,Integer select_from,Integer select_count) {
            EON_OFSC_Activity_WS.get_route_parameters request_x = new EON_OFSC_Activity_WS.get_route_parameters();
            request_x.user_x = user_x;
            request_x.date_x = date_x;
            request_x.resource_id = resource_id;
            request_x.property_filter = property_filter;
            request_x.select_from = select_from;
            request_x.select_count = select_count;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/get_route',
              'urn:toa:activity',
              'get_route',
              'urn:toa:activity',
              'get_route_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.get_required_inventories_response get_required_inventories(EON_OFSC_Activity_WS.user_x user_x,String activity_id) {
            EON_OFSC_Activity_WS.get_required_inventories_parameters request_x = new EON_OFSC_Activity_WS.get_required_inventories_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            EON_OFSC_Activity_WS.get_required_inventories_response response_x;
            Map<String, EON_OFSC_Activity_WS.get_required_inventories_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.get_required_inventories_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/get_required_inventories',
              'urn:toa:activity',
              'get_required_inventories',
              'urn:toa:activity',
              'get_required_inventories_response',
              'EON_OFSC_Activity_WS.get_required_inventories_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.simple_response set_file(EON_OFSC_Activity_WS.user_x user_x,String entity_id,String property_id,String file_name,String file_data,String file_mime_type) {
            EON_OFSC_Activity_WS.set_file_parameters request_x = new EON_OFSC_Activity_WS.set_file_parameters();
            request_x.user_x = user_x;
            request_x.entity_id = entity_id;
            request_x.property_id = property_id;
            request_x.file_name = file_name;
            request_x.file_data = file_data;
            request_x.file_mime_type = file_mime_type;
            EON_OFSC_Activity_WS.simple_response response_x;
            Map<String, EON_OFSC_Activity_WS.simple_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.simple_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/set_file',
              'urn:toa:activity',
              'set_file',
              'urn:toa:activity',
              'set_file_response',
              'EON_OFSC_Activity_WS.simple_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.simple_response unlink_activities(EON_OFSC_Activity_WS.user_x user_x,String from_activity_id,String to_activity_id,String link_type) {
            EON_OFSC_Activity_WS.unlink_activities_parameters request_x = new EON_OFSC_Activity_WS.unlink_activities_parameters();
            request_x.user_x = user_x;
            request_x.from_activity_id = from_activity_id;
            request_x.to_activity_id = to_activity_id;
            request_x.link_type = link_type;
            EON_OFSC_Activity_WS.simple_response response_x;
            Map<String, EON_OFSC_Activity_WS.simple_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.simple_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/unlink_activities',
              'urn:toa:activity',
              'unlink_activities',
              'urn:toa:activity',
              'unlink_activities_response',
              'EON_OFSC_Activity_WS.simple_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.get_activity_links_response_element get_activity_links(EON_OFSC_Activity_WS.user_x user_x,String activity_id) {
            EON_OFSC_Activity_WS.get_activity_links_parameters request_x = new EON_OFSC_Activity_WS.get_activity_links_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            EON_OFSC_Activity_WS.get_activity_links_response_element response_x;
            Map<String, EON_OFSC_Activity_WS.get_activity_links_response_element> response_map_x = new Map<String, EON_OFSC_Activity_WS.get_activity_links_response_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/get_activity_links',
              'urn:toa:activity',
              'get_activity_links',
              'urn:toa:activity',
              'get_activity_links_response',
              'EON_OFSC_Activity_WS.get_activity_links_response_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response create_activity(EON_OFSC_Activity_WS.user_x user_x,String date_x,String resource_id,String position_in_route,EON_OFSC_Activity_WS.property[] properties) {
            EON_OFSC_Activity_WS.create_activity_parameters request_x = new EON_OFSC_Activity_WS.create_activity_parameters();
            request_x.user_x = user_x;
            request_x.date_x = date_x;
            request_x.resource_id = resource_id;
            request_x.position_in_route = position_in_route;
            request_x.properties = properties;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/create_activity',
              'urn:toa:activity',
              'create_activity',
              'urn:toa:activity',
              'create_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response reopen_activity(EON_OFSC_Activity_WS.user_x user_x,String activity_id,String position_in_route,EON_OFSC_Activity_WS.property[] properties) {
            EON_OFSC_Activity_WS.update_activity_parameters request_x = new EON_OFSC_Activity_WS.update_activity_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.position_in_route = position_in_route;
            request_x.properties = properties;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/reopen_activity',
              'urn:toa:activity',
              'reopen_activity',
              'urn:toa:activity',
              'reopen_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.simple_response link_activities(EON_OFSC_Activity_WS.user_x user_x,String from_activity_id,String to_activity_id,String link_type,String min_interval,String max_interval) {
            EON_OFSC_Activity_WS.link_activities_parameters request_x = new EON_OFSC_Activity_WS.link_activities_parameters();
            request_x.user_x = user_x;
            request_x.from_activity_id = from_activity_id;
            request_x.to_activity_id = to_activity_id;
            request_x.link_type = link_type;
            request_x.min_interval = min_interval;
            request_x.max_interval = max_interval;
            EON_OFSC_Activity_WS.simple_response response_x;
            Map<String, EON_OFSC_Activity_WS.simple_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.simple_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/link_activities',
              'urn:toa:activity',
              'link_activities',
              'urn:toa:activity',
              'link_activities_response',
              'EON_OFSC_Activity_WS.simple_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public EON_OFSC_Activity_WS.activity_response update_activity(EON_OFSC_Activity_WS.user_x user_x,String activity_id,String position_in_route,EON_OFSC_Activity_WS.property[] properties) {
            EON_OFSC_Activity_WS.update_activity_parameters request_x = new EON_OFSC_Activity_WS.update_activity_parameters();
            request_x.user_x = user_x;
            request_x.activity_id = activity_id;
            request_x.position_in_route = position_in_route;
            request_x.properties = properties;
            EON_OFSC_Activity_WS.activity_response response_x;
            Map<String, EON_OFSC_Activity_WS.activity_response> response_map_x = new Map<String, EON_OFSC_Activity_WS.activity_response>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'activity/update_activity',
              'urn:toa:activity',
              'update_activity',
              'urn:toa:activity',
              'update_activity_response',
              'EON_OFSC_Activity_WS.activity_response'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}