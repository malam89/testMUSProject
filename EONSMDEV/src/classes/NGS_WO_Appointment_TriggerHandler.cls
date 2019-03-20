/**
    Description   : Trigger Handler Class for the "NGS Work Order Appointment" object (NGS_Work_Order_Appointment__c)
                    This class currently defines handlers for the following Trigger Actions:
                    BEFORE INSERT
                    BEFORE UPDATE
                    //BEFORE DELETE
                    //AFTER  INSERT
                    //AFTER  UPDATE
                    //AFTER  DELETE
                    //AFTER  UNDELETE
                    The framework for unused Action Handlers has been commented out and left in place. To use
                    these Handlers, un-comment the appropriate blocks of code by ADDING a single forward-slash "/"
                    character to the "/*" that appears directly above the definition of the Action Handler you want
                    to activate. Then, add your handler logic directly below the comment that says "Handler logic".
                    
                    After implementing additional Action Handlers, make sure to un-comment the corresponding lines
                    of dispatch code in the Trigger definition.
    Test Class    : NGS_WO_Appointment_TriggerHandlerTest
**/
/*
    Created By    : Puneet Mehta
    Created On    : 02/03/2017
    Service Req   : SR_OptiMUS_NG_017
    Change History
    CH01 #SR_OptiMUS_NG_031 #14/03/2017 #Puneet Mehta #Populated Rejected field
    CH02 #SR_OptiMUS_NG_026 #15/03/2017 #Puneet Mehta #O2 Work Order Appointments OptiMUS to OFS
    CH03 #SR_OptiMUS_NG_032 #04/04/2017 #Puneet Mehta #Cancelled status
    CH04 #SR_OptiMUS_NG_039 #27/04/2017 #Shruti Moghe #Added condition to bypass Update activity call for O3 functionality
    CH05 #SR_OptiMUS_NG_046 #24/05/2017 #Shruti Moghe #Added condition for cancelled appointment reprocessing
    
*/
public class NGS_WO_Appointment_TriggerHandler extends TriggerHandler {
    /**
        beforeInsert() : BEFORE INSERT Handler.
        @param           newSObjects    List of NGS Work Order Appointments to be inserted.
        @return          void
    **/
    public void beforeInsert(List<NGS_Work_Order_Appointment__c > newSObjects) {
        // Prevent recursion. This functionality is implemented by the parent class
        if (beforeInsertHasRun()) {
            return;
        }
        // Handler logic
        calculateStatus(newSObjects);
        return;
    }
    /**
        beforeUpdate() : BEFORE UPDATE Handler.
        @param           originalSObjects      List of NGS Work Order Appointments in their original state.
        @param           originalSObjectsMap   Map of NGS Work Order Appointments in their original state.
        @param           updatedSObjects       List of NGS Work Order Appointments with updated data.
        @param           updatedSObjectsMap    Map of NGS Work Order Appointments with updated data.
        @return          void
    */
    public void beforeUpdate(List<NGS_Work_Order_Appointment__c >    oldSObjects, 
                             Map<ID, NGS_Work_Order_Appointment__c > oldSObjectsMap,
                             List<NGS_Work_Order_Appointment__c >    updatedSObjects, 
                             Map<ID, NGS_Work_Order_Appointment__c > updatedSObjectsMap) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(beforeUpdateHasRun()) { return; }
        // Handler logic.
        calculateStatus(updatedSObjects);
        return;
    }
    /**
        beforeDelete() :  BEFORE DELETE Handler.
        @param            deletedSObjects     List of NGS Work Order Appointments that are going to be deleted.
        @param            deletedSObjectsMap  Map of NGS Work Order Appointments that are going to be deleted.
        @return           void
    */
    /*
    public void beforeDelete(List<NGS_Work_Order_Appointment__c >    deletedSObjects, 
                             Map<ID, NGS_Work_Order_Appointment__c > deletedSObjectsMap) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(beforeDeleteHasRun()) {   return;}
        // Handler logic.
        // [Add your custom handler logic here.]
        return;
    }
    */
    /**
        afterInsert() : AFTER INSERT Handler.
        @param          newSObjects     List of NGS Work Order Appointments that were just inserted.
        @param          newSObjectsMap  Map of NGS Work Order Appointments that were just inserted.
        @return         void
    */
    public void afterInsert(List<NGS_Work_Order_Appointment__c >     newSObjects, 
                            Map<ID, NGS_Work_Order_Appointment__c >  newSObjectsMap) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(afterInsertHasRun()) {  return;}
        // Handler logic.
        //CH02.START
        Boolean isUpdate = true;
        for(NGS_Work_Order_Appointment__c woApptObj : newSObjects){
            if (!System.isFuture() && Limits.getFutureCalls() < (Limits.getLimitFutureCalls() - 1)) {
                try {
                    isUpdate = woApptObj.Oracle_Activity_ID__c != null && woApptObj.Oracle_Activity_ID__c != '' ? true : false;
                    //call method to send the technician details to OFSC
                    sendAppointmentToOFSC(woApptObj.id,isUpdate);} catch(Exception ex ){ woApptObj.addError(ex.getMessage());}
            }
        }
        //CH02.END
        return;
    }
    /**
        afterUpdate() :  AFTER UPDATE Handler.
        @param           originalSObjects    List of NGS Work Order Appointments in their original state.
        @param           originalSObjectsMap Map of NGS Work Order Appointments in their original state.
        @param           updatedSObjects     List of NGS Work Order Appointments with updated data.
        @param           updatedSObjectsMap  Map of NGS Work Order Appointments with updated data.
        @return          void
    */
    public void afterUpdate(List<NGS_Work_Order_Appointment__c >     originalSObjects, 
                            Map<ID, NGS_Work_Order_Appointment__c >  originalSObjectsMap,
                            List<NGS_Work_Order_Appointment__c >     updatedSObjects, 
                            Map<ID, NGS_Work_Order_Appointment__c >  updatedSObjectsMap) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(afterUpdateHasRun()) {
            return;
        }
        // Handler logic.
        //CH02.START
        Boolean isUpdate = true;
        for(NGS_Work_Order_Appointment__c woApptObj : updatedSObjects){
           if (!System.isFuture() && Limits.getFutureCalls() < (Limits.getLimitFutureCalls() - 1)) {
                try {
                    isUpdate = woApptObj.Oracle_Activity_ID__c != null && woApptObj.Oracle_Activity_ID__c != '' ? true : false;
                    //call method to send the technician details to OFSC
                    if(originalSObjectsMap!=null && originalSObjectsMap.get(woApptObj.id)!=null && originalSObjectsMap.get(woApptObj.id).Cancelled__c!=null && woApptObj.Cancelled__c==null)//CH05
                        sendAppointmentToOFSC(woApptObj.id,False);//CH05
                    else{
                    if(Utility.ByPassOFSCUpdate) sendAppointmentToOFSC(woApptObj.id,isUpdate);
                    }
                    } catch(Exception ex ){ woApptObj.addError(ex.getMessage());}//CH04
           }
        }
        //CH02.END
        return;
    }
    /**
        afterDelete() : AFTER DELETE Handler.
        @param          deletedSObjects     List of NGS Work Order Appointments that were just deleted.
        @param          deletedSObjectsMap  Map of NGS Work Order Appointments that were just deleted.
        @return         void
    */
    /*
    public void afterDelete(List<NGS_Work_Order_Appointment__c >     deletedSObjects, 
                            Map<ID, NGS_Work_Order_Appointment__c >  deletedSObjectsMap) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(afterDeleteHasRun()) {
            return;
        }
        // Handler logic.
        // [Add your custom handler logic here.]
        return;
    }
    */
    /**
        afterUndelete() : AFTER UNDELETE Handler.
        @param            restoredSObjects    List of NGS Work Order Appointments recovered from the Recycle Bin.
        @return           void
    */
    /*
    public void afterUndelete(List<NGS_Work_Order_Appointment__c > restoredSObjects) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(afterUndeleteHasRun()) {
            return;
        }
        // Handler logic.
        //Add your custom handler logic here.
        return;
    }
    */
    /**
        calculateStatus() : Updates the Status field
        @param              newSObjects    List of NGS Work Order Appointments to be inserted.
        @return             boolean
    */
    //@testVisible
    private boolean calculateStatus(List<NGS_Work_Order_Appointment__c> newSObjects) {
        try{
            //loop through the records
            for (NGS_Work_Order_Appointment__c objWOappt : newSObjects){
                if(objWOappt.Cancelled__c != null){objWOappt.Status__c = 'Cancelled';  continue;}
                else if(objWOappt.Technician_Name__c != null && objWOappt.Technician_Name__c != '' && objWOappt.Technician_Name__c.startsWithIgnoreCase('rejected')){
                    objWOappt.Status__c = 'Rejected';
                    objWOappt.Rejected__c = system.now();//CH01
                    continue;
                }
                else if(objWOappt.Work_Order_Complete__c != null){ objWOappt.Status__c = 'Completed'; continue;    }
                else if(objWOappt.Work_Order_Ops_Complete__c != null){ objWOappt.Status__c = 'Work Done';  continue;  }
                else if(objWOappt.Work_Order_Suspended__c != null){
                    objWOappt.Status__c = 'Suspended'; continue;
                }
                else if(objWOappt.Work_Order_Started__c != null){
                    objWOappt.Status__c = 'On Site';
                    continue;
                }
                else if(objWOappt.Technician_On_Route__c != null){
                    objWOappt.Status__c = 'On Route';
                    continue;
                }
                else if(objWOappt.Work_Order_Accepted_by_Technician__c != null){
                    objWOappt.Status__c = 'Accepted';
                    continue;
                }
                else if(objWOappt.Employee_ID__c != null){
                    objWOappt.Status__c = 'Assigned';
                    continue;
                }    
                else if(objWOappt.Employee_ID__c == null){
                    objWOappt.Status__c = 'Scheduled';
                    continue;
                }
            }
        }
        catch( Exception ex ){}
        return true;
    }
    /**
        sendAppointmentToOFSC() : future method for trigger to send WO Appointment to OFSC
        @param                    woApptID    Record Id NGS Technician Id
        @param                    isUpdate  Boolean   
        @return                   boolean
    */
    @future (callout=true)
    private static void sendAppointmentToOFSC(String woApptID, Boolean isUpdate) {
        String response = NGS_OFSC_WO_Appointment_Handler.sendActivityToOFSC(woApptID, isUpdate, true);
    }
}