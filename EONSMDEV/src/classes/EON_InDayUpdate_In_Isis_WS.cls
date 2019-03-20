/**
    Description : This class will be used for generating WSDL, so that EON can use this WSDL to Confirm InDayUpdate in Isis.
                                    
    Test Class  : EON_InDayUpdate_In_Isis_test

**/
/*
    Created By  : Akshay Bairagi
    Created On  : 15/03/2016
    Service Req : SR_EON_AB_017,SR_EON_AB_046
    Change History
    CH01 # SM-2245 # 08/09/2016 # Mahadev # Message node sent as null hence fix applied
    CH02 # SR_EON_AB_143 # 13-09-2016 # Mahadev J # Populating 'EON Appointment' reference at 'EON Data Tracker'
    CH03 # SR_EON_AB_187 # 14/11/2016 # Akshay Bairagi # Updated mapping of ExternalAppointmentID with XA_MorrisonID.
    CH04 # SR_EON_AB_189 # 16/11/2016 # Akshay Bairagi # skipped activity if XA_MorrisonID doesnot exist.
    CH05 # SR_EON_AB_219 # 13/04/2017 # Mahadev J # To amend WSDL variable assignment JobStatusDesc = EON Appointment.Status
    CH06 # INCUK0005517628 # 09/05/2017 # Praveen G # handled the time zone issue for start/end times.
*/
global with sharing class EON_InDayUpdate_In_Isis_WS {
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class HeaderElement {  
        Webservice String OrgId ;
        Webservice String RequestId ;
        Webservice datetime RequestDateTime ;
    }
    /**
        Description : Request Parameter 2 
    **/
    global with sharing class AppointmentDetailElement {  
        Webservice String ExternalAppointmentID;
        Webservice String CustomerID ;
        Webservice date AppointmentDate ;
    }
    /**
        Description : Request Parameter 3
    **/
    global with sharing class InDayUpdate {  
        Webservice HeaderElement Header;
        Webservice AppointmentDetailElement AppointmentDetails ;
    }  
    /**
        Description : Response 1
    **/
    global with sharing class errMessage {
        Webservice String MessageType ;
        Webservice integer MessageId ;
        Webservice String MessageText ;
    }
    /**
        Description : Response 2
    **/
    global with sharing class errMessageLst {
        Webservice list<errMessage> Message;
    }
    /**
        Description : Response 3
    **/
    global with sharing class AddressElement {
        Webservice String AddressLine;
        Webservice String City;
        Webservice String PostCode;
    }
    /**
        Description : Response 4
    **/
    global with sharing class ScheduleElement {
        Webservice String ExternalAppointmentID ;
        Webservice date JobDate ;
        Webservice integer TravellingTime ;
        Webservice datetime StartTime ;
        Webservice datetime EndTime ;
        Webservice String JobStatusDesc ;
        Webservice integer JobDuration ;
        Webservice String TimeSlot ;
        Webservice String ServiceWindowStart ;
        Webservice String ServiceWindowEnd ;
        Webservice String WorkTypeDesc ;
        Webservice integer PositionInRoute ;
        Webservice String JobType ;
        Webservice String TimeZone ;
        Webservice AddressElement Address ;
    }
    /**
        Description : Response 5
    **/
    global with sharing class ScheduleLst {
        Webservice list<ScheduleElement> Schedule;
    }
    /**
        Description : Response 6
    **/
    global with sharing class TechnicianElement {
        Webservice Integer ActivityCount ;
        Webservice String FullName ;
        Webservice ScheduleLst Schedules ;
    }
    /**
        Description : Response 7
    **/
    global with sharing class Isis_Response_Acknowledgement_To_EON{
        Webservice HeaderElement Header ;
        Webservice TechnicianElement Technician ;
        Webservice errMessageLst Messages ;
    }   
    /**
        Isis_Response_Acknowledgement_To_EON AppointmentInDayUpdates(InDayUpdate  InDayUpdate) - 
                This method is used to get create InDayUpdate from Isis.
    **/
    webservice static Isis_Response_Acknowledgement_To_EON AppointmentInDayUpdates(InDayUpdate InDayUpdate){ 
        Isis_Response_Acknowledgement_To_EON response = new Isis_Response_Acknowledgement_To_EON();
        errMessageLst errorlst = new errMessageLst();
        EON_Data_Tracker__c eonTracker = new EON_Data_Tracker__c();
        Oracle_Data_Tracker__c oracTracker = new Oracle_Data_Tracker__c();
        eonTracker.Direction__c = 'IN'; 
        eonTracker.Command__c = 'AppointmentInDayUpdates';
        list<errMessage> msgLst = new list<errMessage>();
        EON_OFSC_Activity_WS.activity_response Res;
        string Error = '';
        try{
            if(InDayUpdate != null){
                eonTracker.Request_Data__c = EON_Utility.validateStringLength(InDayUpdate + '');
                eonTracker.Transaction_ID__c = InDayUpdate.header.requestId;
                if(EON_Utility.validateRequired(InDayUpdate.Header.orgId) == true){
                    Error = 'OrgId cannot be blank\n';
                }
                if(EON_Utility.validateRequired(InDayUpdate.Header.requestId) == true){
                    Error = Error + 'RequestId cannot be blank\n';
                }
                if(EON_Utility.validateRequired(InDayUpdate.Header.RequestDateTime) == true){
                    Error = Error + 'RequestDateTime cannot be blank\n';
                } 
                if(EON_Utility.validateRequired(InDayUpdate.AppointmentDetails.ExternalAppointmentID) == true){
                    Error = Error + 'ExternalAppointmentID cannot be blank\n';
                }
                if(Error == ''){
                    //Processing in day updates
                    Integer max_position_in_route = 0;
                    Integer total_activities = 0;
                    Integer Duration = 0;
                    Integer position_in_route = 0;
                    
                    string XA_Morrison_ID, prop_date, start_time, end_time,delivery_window_start, delivery_window_end, Previous_position_in_route, type, prop_Address, prop_City,status,Eon_Status;
                    
                    XA_Morrison_ID = prop_date = start_time = end_time = delivery_window_start = delivery_window_end = type = prop_Address = prop_City = status = Eon_Status = Previous_position_in_route = '';
                    
                    EON_InDayUpdate_In_Isis_WS.TechnicianElement TechnicianElement = new EON_InDayUpdate_In_Isis_WS.TechnicianElement();
                    
                    EON_InDayUpdate_In_Isis_WS.ScheduleLst SchLst = new EON_InDayUpdate_In_Isis_WS.ScheduleLst();
                    
                    EON_InDayUpdate_In_Isis_WS.AddressElement AddressElement = new EON_InDayUpdate_In_Isis_WS.AddressElement();
                    
                    list<EON_InDayUpdate_In_Isis_WS.ScheduleElement> ScheduleLst = new list<EON_InDayUpdate_In_Isis_WS.ScheduleElement>();  
                        
                    list<EON_InDayUpdate_In_Isis_WS.ScheduleElement> revScheduleLst = new list<EON_InDayUpdate_In_Isis_WS.ScheduleElement>();
                    
                    list<EON_Appointment__c> Appt = new list<EON_Appointment__c>(); 
                    Appt = [select id,name,Technician__c, Technician__r.Name, Appointment_Date__c,Start_Time__c,End_Time__c,SubArea__r.Region_Name__r.Travel_Time__c,Duration__c,Time_Slot__c,Job_Code__r.Description__c,Oracle_Address__c,Oracle_Town__c,Oracle_Postcode__c, Status__c from EON_Appointment__c where name =:InDayUpdate.AppointmentDetails.ExternalAppointmentID.trim() limit 1]; //CH05.Update
                    if(Appt != null && Appt.size()>0){
                        eonTracker.Appointment__c = Appt[0].ID; //CH02.New
                        if(Appt[0].Technician__c != null){
                            //Request GET ROUTE from Oracle
                            Error =EON_Get_Route_Frm_OFSC.get_route_Frm_OFSC(Appt[0].Appointment_Date__c,Appt[0].Technician__c, Appt[0].id);
                            oracTracker = EON_Get_Route_Frm_OFSC.requestOut;
                             system.debug('Error %%%%%%%'+Error);       
                            if(Error == 'get_route in OFSC successfully'){
                                Res = EON_Get_Route_Frm_OFSC.response;
                                system.debug('---res--'+Res);
                                EON_OFSC_Activity_WS.activity_list actLst = new EON_OFSC_Activity_WS.activity_list();
                                if(Res.activity_list != null){
                                    actLst = Res.activity_list;
                                    if(actLst.total != null)
                                        total_activities = actLst.total;
                                    EON_OFSC_Activity_WS.activities activities = new EON_OFSC_Activity_WS.activities();
                                    if(actLst.activities != null)
                                        activities = actLst.activities;
                                    list<EON_OFSC_Activity_WS.activity> activity = new  list<EON_OFSC_Activity_WS.activity>();
                                    if(activities.activity != null && activities.activity.size()>0)
                                        activity = activities.activity;
                                    if(activity.size()>0){
                                        //for(integer i = activity.size()-1; i>=0 ; i--){
                                        for(EON_OFSC_Activity_WS.activity act : activity){
                                            //Clear all values:
                                            Duration = 0;
                                            position_in_route = 0;
                                            XA_Morrison_ID = prop_date = start_time = end_time = delivery_window_start = delivery_window_end = type = prop_Address = prop_City = '';
                                            //
                                            system.debug('--Prev-'+prop_Address);
                                            list<EON_OFSC_Activity_WS.property> properties = new list<EON_OFSC_Activity_WS.property>();
                                            //if(activity[i].properties != null && activity[i].properties.size()>0){
                                                //properties = activity[i].properties;
                                            if(act.properties != null && act.properties.size()>0){
                                                properties = act.properties;    
                                                if(properties.size()>0){
                                                    for(EON_OFSC_Activity_WS.property prop: properties){
                                                        if(prop.name.equalsIgnoreCase('XA_Morrison_ID'))
                                                            XA_Morrison_ID = prop.value;
                                                        if(prop.name.equalsIgnoreCase('date'))
                                                            prop_date = prop.value; 
                                                        if(prop.name.equalsIgnoreCase('start_time'))
                                                            start_time = prop.value;
                                                        if(prop.name.equalsIgnoreCase('end_time'))
                                                            end_time = prop.value;  
                                                        if(prop.name.equalsIgnoreCase('Duration'))
                                                            Duration = Integer.valueof(prop.value);
                                                        if(prop.name.equalsIgnoreCase('delivery_window_start'))
                                                            delivery_window_start = prop.value;
                                                        if(prop.name.equalsIgnoreCase('delivery_window_end'))
                                                            delivery_window_end = prop.value;
                                                        if(prop.name.equalsIgnoreCase('position_in_route'))
                                                            position_in_route = Integer.valueof(prop.value); 
                                                        if(prop.name.equalsIgnoreCase('type'))
                                                            type = prop.value;
                                                        if(prop.name.equalsIgnoreCase('Address'))
                                                            prop_Address = prop.value;  
                                                        if(prop.name.equalsIgnoreCase('City'))
                                                            prop_City = prop.value;
                                                        if(prop.name.equalsIgnoreCase('status')){
                                                            Previous_position_in_route = status;
                                                            status = prop.value;
                                                        }   
                                                    }
                                                }
                                            }
                                            if(position_in_route != 0){
                                                if(position_in_route > max_position_in_route)
                                                    max_position_in_route = position_in_route;
                                            }
                                            else
                                                continue;
                                            //CH04.Start    
                                            if(XA_Morrison_ID == '')
                                                continue;  
                                            //CH04.End      
                                            //Status logic:
                                            if(position_in_route == 1){
                                                if(status == 'complete')
                                                    Eon_Status = 'COMPLETED';
                                                else if(status == 'notdone')
                                                    Eon_Status = 'ABORTED';
                                                else if(status == 'suspended')
                                                    Eon_Status = 'SUSPENDED';
                                                else if(status == 'started')
                                                    Eon_Status = 'ONSITE';
                                                else
                                                    Eon_Status = 'ONWAY';       
                                            }
                                            else if(position_in_route > 1){
                                                if(status == 'complete')
                                                    Eon_Status = 'COMPLETED';
                                                else if(status == 'notdone')
                                                    Eon_Status = 'ABORTED';
                                                else if(status == 'suspended')
                                                    Eon_Status = 'SUSPENDED';
                                                else if(status == 'started')
                                                    Eon_Status = 'ONSITE';
                                                else if((Previous_position_in_route == 'notdone') || (Previous_position_in_route == 'complete'))Eon_Status = 'ONWAY';   
                                                else
                                                    Eon_Status = 'ASSIGNED';        
                                            }
                                            //status = '';
                                            
                                            system.debug('--Now-'+prop_Address);
                                            //
                                            //Schedule 
                                            EON_InDayUpdate_In_Isis_WS.ScheduleElement Schedule = new EON_InDayUpdate_In_Isis_WS.ScheduleElement();
                                            AddressElement = new EON_InDayUpdate_In_Isis_WS.AddressElement();
                                            Schedule.ExternalAppointmentID = XA_Morrison_ID; //CH03
                                            if(prop_date != '')
                                                Schedule.JobDate = Date.valueof(prop_date);
                                            Schedule.TravellingTime = Integer.valueof(Appt[0].SubArea__r.Region_Name__r.Travel_Time__c);
                                           
                                            if(start_time != '')
                                                //Schedule.StartTime = Datetime.Valueof(start_time); //CH06.Old
                                                Schedule.StartTime = EON_Utility.validateTimeBST(Datetime.Valueof(start_time)); //CH06.New
                                            if(end_time != '')
                                                //Schedule.EndTime = Datetime.Valueof(end_time);//CH06.Old
                                                Schedule.EndTime = EON_Utility.validateTimeBST(Datetime.Valueof(end_time));//CH06.New
                                            Schedule.JobStatusDesc = Eon_Status;
                                            Schedule.JobDuration = Duration;
                                            Schedule.TimeSlot = Appt[0].Time_Slot__c;
                                            Schedule.ServiceWindowStart = delivery_window_start;
                                            Schedule.ServiceWindowEnd = delivery_window_end;
                                            Schedule.WorkTypeDesc = Appt[0].Job_Code__r.Description__c;
                                            Schedule.PositionInRoute = position_in_route;
                                            Schedule.JobType = type;
                                            Schedule.TimeZone = 'GMT/BST';
                                            AddressElement.AddressLine = prop_Address;
                                            AddressElement.City = prop_City;
                                            AddressElement.PostCode = Appt[0].Oracle_Postcode__c;
                                            Schedule.Address = AddressElement;
                                            ScheduleLst.add(Schedule);
                                        }
                                    }
                                }
                                //Create response for EON
                                response.header = InDayUpdate.header;
                                response.header.orgId = system.label.EON_Sanbox_Name;//'MORR';
                                if(ScheduleLst != null && ScheduleLst.size()>0){
                                    //for(integer i=ScheduleLst.size()-1;i>=0;i--)
                                        //revScheduleLst.add(ScheduleLst[i]);
                                    SchLst.Schedule = ScheduleLst;
                                }   
                                TechnicianElement.ActivityCount = max_position_in_route;
                                //TechnicianElement.FullName = Appt[0].Technician__c; //CH01.Old
                                TechnicianElement.FullName = Appt[0].Technician__r.Name; //CH01.New
                                TechnicianElement.Schedules = SchLst;
                                response.Technician = TechnicianElement;
                                eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                                eonTracker.Status__c = EON_Utility.RESULT_PASS;
                                Error = '';
                                //CH01.New.Start
                                errMessage msg = new errMessage();
                                msg.MessageType = 'Information';
                                msg.MessageId = 0;
                                msg.MessageText = 'Request processed successfully.';
                                msgLst.add(msg);
                                errorlst.Message = msgLst;
                                response.Messages = errorlst;
                                //CH01.New.End
                            }
                        }
                        else{
                            //Response to EON:
                            response.header = InDayUpdate.header;
                            response.header.orgId = system.label.EON_Sanbox_Name;//'MORR';
                            TechnicianElement.ActivityCount = 1;
                            TechnicianElement.FullName = 'Null';
                            EON_InDayUpdate_In_Isis_WS.ScheduleElement Schedule = new EON_InDayUpdate_In_Isis_WS.ScheduleElement();
                            Schedule.ExternalAppointmentID = Appt[0].Name;
                            Schedule.JobDate = Appt[0].Appointment_Date__c;
                            Schedule.TravellingTime = integer.valueof(Appt[0].SubArea__r.Region_Name__r.Travel_Time__c);
                            Schedule.StartTime = null;
                            Schedule.EndTime = null;
                            if(Appt[0].Appointment_Date__c != null){
                                Integer hr1, min1;
                                hr1 = min1 = 0;
                                if(Appt[0].Start_Time__c != null && Appt[0].Start_Time__c != '' && Appt[0].Start_Time__c.contains(':')){
                                    hr1 = Integer.valueof(Appt[0].Start_Time__c.substringBefore(':'));
                                    min1 = Integer.valueof(Appt[0].Start_Time__c.substringAfter(':'));
                                    Schedule.StartTime = datetime.newInstanceGMT(Appt[0].Appointment_Date__c.year(), Appt[0].Appointment_Date__c.month(),Appt[0].Appointment_Date__c.day(), hr1,min1, 0);
                                }else{Schedule.StartTime = datetime.newInstanceGmt(Appt[0].Appointment_Date__c.year(), Appt[0].Appointment_Date__c.month(),Appt[0].Appointment_Date__c.day());}
                                if(Appt[0].End_Time__c != null && Appt[0].End_Time__c != '' && Appt[0].End_Time__c.contains(':')){
                                    hr1 = Integer.valueof(Appt[0].End_Time__c.substringBefore(':'));
                                    min1 = Integer.valueof(Appt[0].End_Time__c.substringAfter(':'));
                                    Schedule.EndTime = datetime.newInstanceGMT(Appt[0].Appointment_Date__c.year(), Appt[0].Appointment_Date__c.month(),Appt[0].Appointment_Date__c.day(), hr1,min1, 0);
                                }else{Schedule.EndTime = datetime.newInstanceGmt(Appt[0].Appointment_Date__c.year(), Appt[0].Appointment_Date__c.month(),Appt[0].Appointment_Date__c.day());}
                            }
                            system.debug('----1'+Schedule.EndTime );
                            system.debug('----2'+Appt[0].End_Time__c );
                            
                            //Schedule.JobStatusDesc = 'SCHEDULED'; //CH05.Old
                            Schedule.JobStatusDesc = !EON_Utility.validateRequired(Appt[0].Status__c) ? Appt[0].Status__c : '' ; //CH05.New
                            Schedule.JobDuration = integer.valueof(Appt[0].Duration__c);
                            Schedule.TimeSlot = Appt[0].Time_Slot__c;
                            if(Appt[0].Time_Slot__c != null && Appt[0].Time_Slot__c != '' && Appt[0].Time_Slot__c.length()>= 11){
                                Schedule.ServiceWindowStart = Appt[0].Time_Slot__c.left(5);
                                Schedule.ServiceWindowEnd = Appt[0].Time_Slot__c.right(5);
                            }   
                            Schedule.WorkTypeDesc = Appt[0].Job_Code__r.Description__c;
                            Schedule.PositionInRoute = 0;
                            Schedule.JobType = 'Regular';
                            Schedule.TimeZone = 'GMT/BST';
                            AddressElement.AddressLine = Appt[0].Oracle_Address__c;
                            AddressElement.City = Appt[0].Oracle_Town__c;
                            AddressElement.PostCode = Appt[0].Oracle_Postcode__c;
                            Schedule.Address = AddressElement;
                            ScheduleLst.add(Schedule);
                            if(ScheduleLst != null && ScheduleLst.size()>0)
                                SchLst.Schedule = ScheduleLst;
                            TechnicianElement.Schedules = SchLst;
                            response.Technician = TechnicianElement;    
                            eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + ''); 
                            eonTracker.Status__c = EON_Utility.RESULT_PASS;
                            errMessage msg = new errMessage();
                            msg.MessageType = 'Information';
                            msg.MessageId = 0;
                            msg.MessageText = 'Request processed successfully.';
                            msgLst.add(msg);
                            errorlst.Message = msgLst;
                            response.Messages = errorlst;
                        }
                    }else{
                        Error = 'Appointment does not exist\n';
                    }
                    //
                }
                if(Error != ''){
                    errMessage msg = new errMessage();
                    msg.MessageType = 'Exception';
                    msg.MessageId = 1;
                    msg.MessageText = (Error.containsIgnoreCase('cannot be blank')||Error.containsIgnoreCase('Appointment does not exist'))?Error:'Request can\'t be completed, Please contact your administrator.';
                    msgLst.add(msg);
                    errorlst.Message = msgLst;
                    response.Messages = errorlst;
                    response.header = InDayUpdate.header;
                    response.header.orgId = system.label.EON_Sanbox_Name;//UserInfo.getOrganizationId();
                    eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
                    eonTracker.Status__c = EON_Utility.RESULT_FAIL; 
                    eonTracker.Error__c = Error;
                }
            } 
            else{
                Error = 'Request Not Found';
                errMessage msg = new errMessage();
                msg.MessageType = 'Exception';
                msg.MessageId = 1;
                msg.MessageText = 'Request can\'t be completed, Please contact your administrator.';//Error;
                msgLst.add(msg);
                errorlst.Message = msgLst;
                response.Messages = errorlst;
                eonTracker.Request_Data__c = 'Blank Request';
                eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
                eonTracker.Status__c = EON_Utility.RESULT_FAIL; 
                eonTracker.Error__c = Error;
            }
        }catch(Exception ex){
            Error = ex.getmessage();
            System.debug('**** Exception Occured '+ex.getmessage()+'----' + ex.getStackTraceString());
            errMessage msg = new errMessage();
            msg.MessageType = 'Exception';
            msg.MessageId = 1;
            msg.MessageText = 'Request can\'t be completed, Please contact your administrator.';//Error;
            msgLst.add(msg);
            errorlst.Message = msgLst;
            response.Messages = errorlst;
            response.header = InDayUpdate.header;
            response.header.orgId = system.label.EON_Sanbox_Name;//UserInfo.getOrganizationId();
            eonTracker.Response_Data__c = EON_Utility.validateStringLength(response + '');
            eonTracker.Status__c = EON_Utility.RESULT_FAIL;
            eonTracker.Error__c = Error;
        }    
        insert eonTracker;
        if(oracTracker != null && oracTracker.id != null){
            oracTracker.EON_Data_Tracker__c = eonTracker.id;
            update oracTracker;
        }
        EON_Utility.createAttachment(eonTracker.id, eonTracker.Request_Data__c, eonTracker.id);
        system.debug('---got here--');
        return response; 
    }                                                                   
}