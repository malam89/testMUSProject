/**
    Description : This test class is for the following below classes
                  NGS_OFSC_Receiving_Helper.         
**/
    /* 
        Created By    : Tashika Gupta
        Created On    : 21/04/2017
        Service Req   : SR_OptiMUS_NG_013
        
    */
@isTest
public class NGS_OFSC_Receiving_Helper_Test {
    
    static testMethod void Receiving_Helper(){
                test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
                Test.setMock(WebServiceMock.class, new NGS_S3_WO_Assignment_to_IFS_WSMock());
     test.startTest();
               
                NGS_Work_Order_Appointment__c app = new NGS_Work_Order_Appointment__c(City__c = 'MyCity', Country__c = 'Country', Appointment_Start_Time__c = system.now(), Appointment_Finish_Time__c = system.now(), Message_Date__c = system.today() ,Duration__c = '11:44',Name = '12344556', Address_Line_1__c = 'Add1', Post_Code__c = 'SG1 2ST',Oracle_Activity_ID__c='17');
                insert app;

                NGS_Technician__c NGST= new NGS_Technician__c (First_Name__c = 'Rejected',Start_Date__c=system.today(),Leaving_Date__c=system.today()+1, h_oracle_user_created__c=true,Last_Name__c = 'Test1', Gender__c = 'F',Start_Location__c = 'UK', Mobile_Number__c = '07705898212',Sent_to_IFS__c=true);
                insert NGST;
                
                NGS_Oracle_Data_Tracker__c ODT = new NGS_Oracle_Data_Tracker__c();
                ODT.Direction__c = 'IN';
                insert ODT;
                
                Map<String, String> mapRequest = new  Map<String, String>();
                try{
                mapRequest.put('activity_id','17');
                mapRequest.put('tech_number', NGST.id);
                mapRequest.put('activity_start_time', '12:09');
                mapRequest.put('activity_end_time', '13:09');
                mapRequest.put('length','60');
                NGS_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
                
                mapRequest = new  Map<String, String>();
                mapRequest.put('activity_id','17');
                mapRequest.put('tech_number',null);
                mapRequest.put('activity_start_time', '12:09');
                mapRequest.put('activity_end_time', '13:09');
                mapRequest.put('length','60');
                NGS_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
                
                mapRequest = new  Map<String, String>();
                mapRequest.put('activity_id',null);
                mapRequest.put('tech_number',null);
                NGS_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
 
                mapRequest = new  Map<String, String>();
                mapRequest.put('activity_id','17');
                mapRequest.put('tech_number',app.id);
                mapRequest.put('length','60');
                NGS_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
                                
                mapRequest = new  Map<String, String>();
                mapRequest.put('activity_id','17');
                mapRequest.put('tech_number','1234567987');
                mapRequest.put('length','60');
                mapRequest.put('activity_id','test'); 
                
                NGS_OFSC_Receiving_Service.message_response response = NGS_OFSC_Receiving_Helper.processSubjectAsAssignActivity(mapRequest, ODT.id);
                System.debug('response = '+response);
                }
                Catch(Exception e){}
                }
                }