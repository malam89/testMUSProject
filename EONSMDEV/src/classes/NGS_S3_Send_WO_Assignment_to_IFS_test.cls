/**
    Description : This test class is for the following below classes
                  NGS_S3_Send_WO_Assignment_to_IFS,NGS_S3_WO_Assignment_to_IFS_WS         
**/
    /* 
        Created By    : Shruti Moghe
        Created On    : 21/04/2017
        Service Req   : SR_OptiMUS_NG_013
        
    */
@isTest
public class NGS_S3_Send_WO_Assignment_to_IFS_test{
    public static boolean generate_exp =false;
    static testMethod void Test1(){
         NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse response =new  NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse();
         NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignment workOrderAssignment = new NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignment();
        workOrderAssignment.workOrderNumber =453489340;
        workOrderAssignment.acceptance='true';
        workOrderAssignment.startDate =system.now();
        workOrderAssignment.messageDate=system.now();
        workOrderAssignment.executionTime=45;
        workOrderAssignment.employeeId='38833';
        workOrderAssignment.employeeName='test';
        workOrderAssignment.notes='testing';
        workOrderAssignment.serviceProvider='SP02';
        NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse  responseFinal = new NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse();
        Map<String, NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse> response_map_x = new Map<String, NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse>();
        NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse response_x = new NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentDataResponse();
        NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentData request_x = new NGS_S3_WO_Assignment_to_IFS_WS.receiveWoAssignmentData();
        NGS_S3_WO_Assignment_to_IFS_WS.WorkOrderAssignmentServiceHandlerPort request = new NGS_S3_WO_Assignment_to_IFS_WS.WorkOrderAssignmentServiceHandlerPort();
        request_x.workOrderAssignment = workOrderAssignment;
        responseFinal.workOrderNumber=123455;
        responseFinal.action='TRUE';
        responseFinal.startDate=system.now();
        responseFinal.messageDate=system.now();
        responseFinal.executionTime=45;
        responseFinal.employeeId='325638659';
        responseFinal.employeeName='Test User';
        responseFinal.notes='Testing';
        responseFinal.serviceProvider='SP02';
        
       // response  = Request.receiveWoAssignmentData(workOrderAssignment);  
    }
    static testMethod void Test2(){
                test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
                Test.setMock(WebServiceMock.class, new NGS_S3_WO_Assignment_to_IFS_WSMock());
                 test.startTest();
                 NGS_Work_Order_Appointment__c app = new NGS_Work_Order_Appointment__c(City__c = 'MyCity', Country__c = 'Country', Appointment_Start_Time__c = system.now(), Appointment_Finish_Time__c = system.now(), Message_Date__c = system.today() ,Duration__c = '11:44',Name = '12344556', Address_Line_1__c = 'Add1', Post_Code__c = 'SG1 2ST',Oracle_Activity_ID__c='17',h_IFS_Duration__c='1:50');
                insert app;

                NGS_Technician__c NGST= new NGS_Technician__c (First_Name__c = 'Rejected',Start_Date__c=system.today(),Leaving_Date__c=system.today()+1, h_oracle_user_created__c=true,Last_Name__c = 'Test1', Gender__c = 'F',Start_Location__c = 'UK', Mobile_Number__c = '07705898212',Sent_to_IFS__c=true);
                insert NGST;
                
                NGS_S3_Send_WO_Assignment_to_IFS.Sent_WO_Assignment(true, app.id);
                
    }
    static testMethod void Test3(){
                test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
                Test.setMock(WebServiceMock.class, new NGS_S3_WO_Assignment_to_IFS_WSMock());
                 test.startTest();
                 NGS_Work_Order_Appointment__c app = new NGS_Work_Order_Appointment__c(City__c = 'MyCity', Country__c = 'Country', Appointment_Start_Time__c = system.now(), Appointment_Finish_Time__c = system.now(), Message_Date__c = system.today() ,Duration__c = '11:44',Name = '12344556', Address_Line_1__c = 'Add1', Post_Code__c = 'SG1 2ST',Oracle_Activity_ID__c='17',h_IFS_Duration__c='1:50');
                insert app;

                NGS_Technician__c NGST= new NGS_Technician__c (First_Name__c = 'Rejected',Start_Date__c=system.today(),Leaving_Date__c=system.today()+1, h_oracle_user_created__c=true,Last_Name__c = 'Test1', Gender__c = 'F',Start_Location__c = 'UK', Mobile_Number__c = '07705898212',Sent_to_IFS__c=true);
                insert NGST;
                NGS_S3_Send_WO_Assignment_to_IFS_test.generate_exp =true;
                NGS_S3_Send_WO_Assignment_to_IFS.Sent_WO_Assignment(false, app.id);
                
    }
    
    static testMethod void Test4(){
                test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
                Test.setMock(WebServiceMock.class, new NGS_S3_WO_Assignment_to_IFS_WSMock());
                 test.startTest();
                 NGS_Technician__c NGST1= new NGS_Technician__c (First_Name__c = 'Suhas',Start_Date__c=system.today(),Leaving_Date__c=system.today()+1, h_oracle_user_created__c=true,Last_Name__c = 'Test1', Gender__c = 'F',Start_Location__c = 'UK', Mobile_Number__c = '07705898212',Sent_to_IFS__c=true);
                insert NGST1;
                 NGS_Work_Order_Appointment__c app = new NGS_Work_Order_Appointment__c(Employee_ID__c=NGST1.id,City__c = 'MyCity', Country__c = 'Country', Appointment_Start_Time__c = DateTIme.newInstance(System.today()+1,Time.newInstance(13,20, 0, 0)), Appointment_Finish_Time__c = DateTIme.newInstance(System.today()+2,Time.newInstance(13,20, 0, 0)), Message_Date__c = system.today() ,Duration__c = '11:44',Name = '12344556', Address_Line_1__c = 'Add1', Post_Code__c = 'SG1 2ST',Oracle_Activity_ID__c='17',h_IFS_Duration__c='1:50');
                insert app;

                NGS_Technician__c NGST= new NGS_Technician__c (First_Name__c = 'Rejected',Start_Date__c=system.today(),Leaving_Date__c=system.today()+1, h_oracle_user_created__c=true,Last_Name__c = 'Test1', Gender__c = 'F',Start_Location__c = 'UK', Mobile_Number__c = '07705898212',Sent_to_IFS__c=true);
                insert NGST;
                
                 NGS_S3_Send_WOAssignment_Batch objClass = new NGS_S3_Send_WOAssignment_Batch();
                   ID batchprocessid = Database.executeBatch(objClass,1);
                
                  NGS_S3_Send_WOAssignment_Batch_Scheduler sch = new NGS_S3_Send_WOAssignment_Batch_Scheduler();
                    system.schedule('NGS_S3_Send_WOAssignment_toIFS_test','0 0 16 1/1 * ? *',sch);
                
    }
    
}