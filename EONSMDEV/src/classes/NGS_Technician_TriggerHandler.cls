/**
    Description   : Trigger Handler Class for the "NGS Technician" object (NGS_Technician__c)
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
    Test Class    : 
**/
/*
    Created By    : Puneet Mehta
    Created On    : 07/03/2017
    Service Req   : SR_OptiMUS_NG_019
*/
public class NGS_Technician_TriggerHandler extends TriggerHandler {
    /**
        beforeInsert() : BEFORE INSERT Handler.
        @param           newSObjects    List of NGS Technicians to be inserted.
        @return          void
    **/
    /*
    public void beforeInsert(List<NGS_Technician__c > newSObjects) {
        // Prevent recursion. This functionality is implemented by the parent class
        if (beforeInsertHasRun()) {
            return;
        }
        // Handler logic
        return;
    }
    /**
        beforeUpdate() : BEFORE UPDATE Handler.
        @param           originalSObjects      List of NGS Technicians in their original state.
        @param           originalSObjectsMap   Map of NGS Technicians in their original state.
        @param           updatedSObjects       List of NGS Technicians with updated data.
        @param           updatedSObjectsMap    Map of NGS Technicians with updated data.
        @return          void
    */
    /*
    public void beforeUpdate(List<NGS_Technician__c >    oldSObjects, 
                             Map<ID, NGS_Technician__c > oldSObjectsMap,
                             List<NGS_Technician__c >    updatedSObjects, 
                             Map<ID, NGS_Technician__c > updatedSObjectsMap) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(beforeUpdateHasRun()) {
            return;
        }
        // Handler logic.
        calculateStatus(updatedSObjects);
        return;
    }
    /**
        beforeDelete() :  BEFORE DELETE Handler.
        @param            deletedSObjects     List of NGS Technicians that are going to be deleted.
        @param            deletedSObjectsMap  Map of NGS Technicians that are going to be deleted.
        @return           void
    */
    /*
    public void beforeDelete(List<NGS_Technician__c >    deletedSObjects, 
                             Map<ID, NGS_Technician__c > deletedSObjectsMap) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(beforeDeleteHasRun()) {
            return;
        }
        // Handler logic.
        // [Add your custom handler logic here.]
        return;
    }
    */
    /**
        afterInsert() : AFTER INSERT Handler.
        @param          newSObjects     List of NGS Technicians that were just inserted.
        @param          newSObjectsMap  Map of NGS Technicians that were just inserted.
        @return         void
    */
    public void afterInsert(List<NGS_Technician__c >     newSObjects, 
                            Map<ID, NGS_Technician__c >  newSObjectsMap) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(afterInsertHasRun()) {
            return;
        }
        // Handler logic.
        Boolean isUpdate = true;
        for(NGS_Technician__c technician : newSObjects){
            if (!System.isFuture() && Limits.getFutureCalls() < (Limits.getLimitFutureCalls() - 1)) {
                try {
                    isUpdate = technician.Sent_to_Oracle__c != null ? true : false;
                    //call method to send the technician details to OFSC
                    sendTechnicianToOFSC(technician.id,isUpdate);} catch(Exception ex ){ technician.addError(ex.getMessage());}
            }
        }
        return;
    }
    /**
        afterUpdate() :  AFTER UPDATE Handler.
        @param           originalSObjects    List of NGS Technicians in their original state.
        @param           originalSObjectsMap Map of NGS Technicians in their original state.
        @param           updatedSObjects     List of NGS Technicians with updated data.
        @param           updatedSObjectsMap  Map of NGS Technicians with updated data.
        @return          void
    */
    public void afterUpdate(List<NGS_Technician__c >     originalSObjects, 
                            Map<ID, NGS_Technician__c >  originalSObjectsMap,
                            List<NGS_Technician__c >     updatedSObjects, 
                            Map<ID, NGS_Technician__c >  updatedSObjectsMap) {
        // Prevent recursion. This functionality is implemented by the parent class.
        if(afterUpdateHasRun()) {
            return;
        }
        // Handler logic.
        Boolean isUpdate = true;
        for(NGS_Technician__c technician : updatedSObjects){
            if (!System.isFuture() && Limits.getFutureCalls() < (Limits.getLimitFutureCalls() - 1)) {
                try {
                    isUpdate = technician.Sent_to_Oracle__c != null ? true : false;
                    //call method to send the technician details to OFSC
                    sendTechnicianToOFSC(technician.id,isUpdate);} catch(Exception ex ){ technician.addError(ex.getMessage());}
            }
        }
        return;
    }
    /**
        afterDelete() : AFTER DELETE Handler.
        @param          deletedSObjects     List of NGS Technicians that were just deleted.
        @param          deletedSObjectsMap  Map of NGS Technicians that were just deleted.
        @return         void
    */
    /*
    public void afterDelete(List<NGS_Technician__c >     deletedSObjects, 
                            Map<ID, NGS_Technician__c >  deletedSObjectsMap) {
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
        @param            restoredSObjects    List of NGS Technicians recovered from the Recycle Bin.
        @return           void
    */
    /*
    public void afterUndelete(List<NGS_Technician__c > restoredSObjects) {
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
        sendTechnicianToOFSC() : future method for trigger to send technician to OFSC
        @param                   techId    Record Id NGS Technician Id
        @param                   isUpdate  Boolean   
        @return                  boolean
    */
    @future (callout=true)
    private static void sendTechnicianToOFSC(String techId, Boolean isUpdate) {
        String response = NGS_OFSC_Technician_Handler.sendTechnicianToOFSC(techId, isUpdate);
    }
}