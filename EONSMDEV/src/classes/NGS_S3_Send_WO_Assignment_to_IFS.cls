/**
    Description :    This class is used to send Work Order Assignment                   
    Test Class  :    
**/
/*
    Created By  : Shruti Moghe
    Created On  : 01/04/2017
    Service Req : SR_OptiMUS_NG_013
    Change History
    CH01 #SR_OptiMUS_NG_044 #08/05/2017 #Shruti Moghe #Amended logic as S3 will be sent from batch class
    CH02 #SR_OptiMUS_NG_047 #19/05/2017 #Shruti Moghe #Amended logic as S3 will be sent in real time for Acceptance=false
    CH03 #SR_OptiMUS_NG_048 #01/06/2017 #Shruti Moghe #update the mapping of start and end time
    CH04 #26/09/2017 # SR_OptiMUS_NG_054 # Puneet Mehta # Renamed Cancellation Note to MUS Rejection Note

*/
global class  NGS_S3_Send_WO_Assignment_to_IFS{
    Public static boolean Result = true;//CH01
    public static boolean assigned =false;
    public static void Sent_WO_Assignment(Boolean Acceptance, string WorkOrder_id){//CH01
        IFS_Data_Tracker__c ifsDataTrackerObj = new IFS_Data_Tracker__c();
        ifsDataTrackerObj.Direction__c = 'OUT';
        ifsDataTrackerObj.Command__c = 'S3 SEND WO ASSIGNMENT';
        List<NGS_Work_Order_Appointment__c> ListWOAppt = new List<NGS_Work_Order_Appointment__c>();
        ListWOAppt=[select id, name,Appointment_Start_Time__c,Assignment_sent_to_IFS__c,Scheduled_Start__c ,MUS_Rejection_Notes__c,/*CH04*/ h_IFS_Duration__c,Duration__c,Employee_ID__c, Employee_ID__r.name, Employee_ID__r.Technician_Name__c,(select id, note__c from NGS_Notes__r) from NGS_Work_Order_Appointment__c where id =:WorkOrder_id ];//CH01
        NGS_S3_WO_Assignment_to_IFS_WS.WorkOrderAssignmentServiceHandlerPort request = new NGS_S3_WO_Assignment_to_IFS_WS.WorkOrderAssignmentServiceHandlerPort();
        NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignment workOrderAssignment = new NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignment();
        NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse response;            
       try{ 
            workOrderAssignment.workOrderNumber= Double.valueof(ListWOAppt[0].name);
            workOrderAssignment.acceptance= Acceptance ? 'TRUE' : 'FALSE';
            workOrderAssignment.messageDate= System.now();
            if(Acceptance){
               // workOrderAssignment.startDate=ListWOAppt[0].Appointment_Start_Time__c; //CH03.old
               workOrderAssignment.startDate=ListWOAppt[0].Scheduled_Start__c ; //CH03.new
               // workOrderAssignment.startDate= Utility.getNewdatetimeAdd(ListWOAppt[0].Appointment_Start_Time__c);
                List<String> duration = new List<String>();
                duration = ListWOAppt[0].h_IFS_Duration__c!=null ? ListWOAppt[0].h_IFS_Duration__c.split(':') : ListWOAppt[0].Duration__c.split(':');
                workOrderAssignment.executionTime= Integer.valueof(duration[0])*60+Integer.valueof(duration[1]);
                workOrderAssignment.employeeId= ListWOAppt[0].Employee_ID__r.name;
                workOrderAssignment.employeeName= ListWOAppt[0].Employee_ID__r.Technician_Name__c;
            }
                       
            else workOrderAssignment.startDate=system.now();
            for(NGS_Note__c note : ListWOAppt[0].NGS_Notes__r)
            workOrderAssignment.Notes= note.note__c;
            if(!Acceptance)
            workOrderAssignment.Notes= ListWOAppt[0].MUS_Rejection_Notes__c;//CH04
            workOrderAssignment.serviceProvider= 'SP02';
            Blob headerValue = Blob.valueOf(System.Label.NGS_IFS_USER + ':' + System.Label.NGS_IFS_PASSWORD);
            //Blob headerValue = Blob.valueOf('INTERFACE1' + ':' +'INTERFACE1' );
            Request.inputHttpHeaders_x = new Map<String, String>();
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            Request.inputHttpHeaders_x.put('Authorization', authorizationHeader);
            ifsDataTrackerObj.Request_Data__c = Utility.validateStringLength( workOrderAssignment+ '\n');
            ifsDataTrackerObj.NGS_Work_Order_Appointment__c =ListWOAppt[0].id;
            system.debug('##### '+String.valueof(workOrderAssignment));
              if(NGS_S3_Send_WO_Assignment_to_IFS_test.generate_exp==false) response  = Request.receiveWoAssignmentData(workOrderAssignment);             
               else {
               response= new NGS_S3_WO_Assignment_to_IFS_WS.workOrderAssignmentResponse(); response.action ='ERROR';}
                system.debug('##### '+response);
                ifsDataTrackerObj.Status__c = 'PASS';
                assigned =true;//CH01
                Result = true;//CH01
                ListWOAppt[0].Assignment_sent_to_IFS__c = System.now();//CH01
                
                if(response.action =='ERROR'){
                    ifsDataTrackerObj.Error__c = response.notes;
                    ifsDataTrackerObj.Status__c = 'FAIL';
                    ListWOAppt[0].Assignment_sent_to_IFS__c = null;//CH01
                    Result = false;//CH01
                    assigned =false;//CH01
                }
            if(assigned) NGS_OFSC_WO_Appointment_Handler.sendActivityToOFSC(ListWOAppt[0].id, true, false);     
            ifsDataTrackerObj.Response_Data__c = String.valueof(response );
            insert ifsDataTrackerObj;//CH01
            update ListWOAppt[0];//CH01 
                                   
        }   
        catch(Exception ex){
            system.debug(String.valueof(response));
            system.debug(String.valueof(ex)+'  Line number---->'+ex.getLinenumber());
            ifsDataTrackerObj.Status__c = 'FAIL'; 
            Result = false;//CH01
            ifsDataTrackerObj.Response_Data__c = String.valueof(response);
            ifsDataTrackerObj.Error__c = ex.getMessage()+'\n'+ ex.getStackTraceString();
            upsert ifsDataTrackerObj;//CH01          
        }
    }
    
   @future (callout=true)
    public static void Sent_WO_Assignment_future(Boolean Acceptance, string WorkOrder_id){
        NGS_S3_Send_WO_Assignment_to_IFS.Sent_WO_Assignment(Acceptance,WorkOrder_id);
   }
}