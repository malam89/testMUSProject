/**
    Description : This test class is for the following below classes
                  EON_OFSC_Receiving_Helper.         
**/
    /* 
        Created By    : PeddaReddeiah
        Created On    : 19/04/2016
        Service Req   : SR_EON_Scheduling_017
        Change History
        CH01 # SR_EON_Mobile_041  # 19/07/2016 # Mahadev J # Added required field.
        CH02 # SR_EON_Mobile_062  # 21/07/2016 # Mahadev J # Added required field to cover additional mapping related changes.
        CH03 # SR_EON_Mobile_095 # 10/11/2016 # Praveen G # Added new date field for not done job results.
    */

@isTest
public class EON_OFSC_Receiving_Helper_Test {
    
    static testMethod void Receiving_Helper(){
        
     test.startTest();
                EON_Electric_Meter_Register__c register = new EON_Electric_Meter_Register__c();
                register.Name = 'test';
                insert register;
                
                EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
                app.h_aid__c = '1234';
                insert app;
                EON_Technician__c teh = EON_CreateTestRecords.createEONTechnician();
                teh.Training_Start_Date__c = system.today(); //CH01.New
                insert teh;
                
                Oracle_Data_Tracker__c ODT = new Oracle_Data_Tracker__c();
                ODT.Direction__c = 'IN';
                insert ODT;
                
                EON_Appointment__c ap = [select id,name, h_aid__c from EON_Appointment__c];
                
                Map<String, String> mapRequest = new  Map<String, String>();
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('tech_number', teh.id);
                EON_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('tech_number', ap.id);
                EON_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('tech_number',null);
                EON_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',null);
                mapRequest.put('tech_number',null);
                EON_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('tech_number','1234567987');

                mapRequest.put('activity_id','test'); //CH02.New
                
                EON_OFSC_Receiving_Service.message_response response = EON_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
                System.debug('response = '+response);
                //System.AssertEquals(response.status,'sent');

 
               //*============ second method======================
                
                String dateinString= String.valueOf(date.today());
                String timeString= '03:45';
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date', dateinString);
                mapRequest.put('start_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date',null);
                mapRequest.put('start_time',null);
                EON_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest, ODT.id);
        
                
                mapRequest.put('activity_id',ap.id );
                mapRequest.put('date','');
                mapRequest.put('start_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',null );
                mapRequest.put('date','');
                mapRequest.put('start_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest, ODT.id);
             
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date','');
                mapRequest.put('start_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest, ODT.id);
        
                EON_OFSC_Receiving_Service.message_response response1 = EON_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest, ODT.id);
                System.debug('response1 = '+response);
                System.AssertEquals(response1.status,'failed');
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('update_date', dateinString);
                mapRequest.put('update_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest, ODT.id);                

                
                 //*============== Thrird method ==============
              
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date', dateinString);
                mapRequest.put('suspend_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date',null);
                mapRequest.put('suspend_time',null);
                EON_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.id);
                mapRequest.put('date','');
                mapRequest.put('start_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest, ODT.id); 
                
                mapRequest.put('activity_id',null );
                mapRequest.put('date','');
                mapRequest.put('suspend_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date','');
                mapRequest.put('suspend_time', timeString);
                //EON_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest, ODT.id);
        
                EON_OFSC_Receiving_Service.message_response response2 = EON_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest, ODT.id);
                System.AssertEquals(response2.status,'failed');
                
                mapRequest.put('appointment_number',ap.Name);
                mapRequest.put('update_date', dateinString);
                mapRequest.put('update_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest, ODT.id);                
        
                //*============fourth Method============
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date', dateinString);
                mapRequest.put('notdone_time', timeString);
                
                //Praveen Added Start
                mapRequest.put('faulty_assets_asset_type_1', 'test1_Asset');
                mapRequest.put('start_time', '12:23');
                mapRequest.put('end_time', '12:23');
                mapRequest.put('notdone_time', '12:23'); // CH03
                mapRequest.put('asset_g_uxinsd', '2016-05-25');
                mapRequest.put('tech_number', teh.id);

                //EON_OFSC_Process_Job_Results_Helper.processJobResults(null , null);
                //EON_OFSC_Process_Job_Results_Helper.processJobResultsForFaultAssets(null, null);
                mapRequest.put('asset_e_certdate', '2016-05-25');
                mapRequest.put('asset_e_exchangedate', '2016-05-25');                
                //Praveen Added End
                //EON_OFSC_Receiving_Helper.processSubjectAsNotDoneAppointment(mapRequest, ODT.id);
        
                EON_OFSC_Receiving_Service.message_response response4 = EON_OFSC_Receiving_Helper.processSubjectAsNotDoneAppointment(mapRequest, ODT.id);
                //System.AssertEquals(response4.status,'sent');

                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date',null);
                mapRequest.put('notdone_time',null);
                EON_OFSC_Receiving_Helper.processSubjectAsNotDoneAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',null);
                mapRequest.put('date','');
                mapRequest.put('notdone_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsNotDoneAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.Name);
                mapRequest.put('date','');
                mapRequest.put('notdone_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsNotDoneAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date','');
                mapRequest.put('notdone_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsNotDoneAppointment(mapRequest, ODT.id);
        
                
                //*============fifth Method============
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('update_date', dateinString);
                mapRequest.put('update_time', timeString);
                mapRequest.put('abort_category', '4. Gas checks details');
                mapRequest.put('faulty_assets_asset_type_1', 'test1_Asset');
                EON_OFSC_Receiving_Helper.processSubjectAsCompleteAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('update_date',null);
                mapRequest.put('update_time',null);
                EON_OFSC_Receiving_Helper.processSubjectAsCompleteAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',null );
                mapRequest.put('update_date','');
                mapRequest.put('update_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsCompleteAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.name);
                mapRequest.put('update_date','');
                mapRequest.put('update_time', timeString);
                EON_OFSC_Receiving_Helper.processSubjectAsCompleteAppointment(mapRequest, ODT.id);
                
                mapRequest.put('activity_id',ap.h_aid__c);
                mapRequest.put('date','');
                mapRequest.put('notdone_time', timeString);
                //EON_OFSC_Receiving_Helper.processSubjectAsCompleteAppointment(mapRequest, ODT.id);
        
                EON_OFSC_Receiving_Service.message_response response5 = EON_OFSC_Receiving_Helper.processSubjectAsCompleteAppointment(mapRequest, ODT.id);
                System.AssertEquals(response5.status,'failed');
                
                Map<String, String> mapRequest1 ;
                try{
                    
                    EON_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest1, ODT.id);
                    EON_OFSC_Receiving_Helper.processSubjectAsStartAppointment(mapRequest1, ODT.id);
                    EON_OFSC_Receiving_Helper.processSubjectAsSuspendAppointment(mapRequest1, ODT.id);
                    EON_OFSC_Receiving_Helper.processSubjectAsNotDoneAppointment(mapRequest1, ODT.id);
                    EON_OFSC_Receiving_Helper.processSubjectAsCompleteAppointment(mapRequest1, ODT.id);
                    
                }Catch(Exception ex){ }
     test.stopTest();    
          
    }
    
    /**
        unitTest2() - unitTest2
    **/
    static testMethod void unitTest2(){
        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.h_aid__c = '1234';
        insert app;    
        Oracle_Data_Tracker__c ODT = new Oracle_Data_Tracker__c();
        ODT.Direction__c = 'IN';
        insert ODT;        
        
        EON_Appointment__c appointment = [select name, h_aid__c from EON_Appointment__c where id=:app.id];
        
        Map<String, String> mapRequest = new  Map<String, String>();        
        mapRequest.put('activity_id',appointment.h_aid__c);
        EON_OFSC_Receiving_Helper.processSubjectAsCancelAppointment(mapRequest, ODT.id);  
        
        //System.assert([select EON_Appointment__c from Oracle_Data_Tracker__c where EON_Appointment__c =: app.id].EON_Appointment__c == app.id);      
        EON_OFSC_Receiving_Helper.processSubjectAsCancelAppointment(null, ODT.id);  
    }

    
}