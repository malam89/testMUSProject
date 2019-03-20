/**
    Description   : This class is a core class to provide required funtions for child classes.
                    All trigger handler classes that implement the pattern must extend this class.
    Test Class    : TriggerHandlerTest
*/
/*
    Created By    : Puneet Mehta
    Created On    : 02/03/2017
    Service Req   : SR_OptiMUS_NG_017
*/
public virtual class TriggerHandler {

    // Initialize static booleans to track if this is the first time a specific
    // Trigger Action has been called within the current Execution Context.
    public   static  boolean isBeforeInsertFirstRun   = true;
    public   static  boolean isBeforeUpdateFirstRun   = true;
    public   static  boolean isBeforeDeleteFirstRun   = true;
    public   static  boolean isAfterInsertFirstRun    = true;
    public   static  boolean isAfterUpdateFirstRun    = true;
    public   static  boolean isAfterDeleteFirstRun    = true;
    public   static  boolean isAfterUndeleteFirstRun  = true;

    // If the trigger was invoked by a DML operation on more than 200 records, 
    // multiple instances of the handler class will be created within the same
    // execution context.  This attribute tracks the batch size each instance
    // works on.
    protected final integer batchSize;

    // Inner class that extends Exception. This will throw a custom Exception
    // from within this Handler Class. If presented to a user, or inspected in
    // a debug log, this exception will appear as an exception of type
    // "TriggerHandler.HandlerException".

    private class HandlerException extends Exception {}

    /**
        TriggerHandler() : Constructor
    */
    public TriggerHandler() {

        // Ensure that this handler class is being instantiated by a Trigger.
        // If not, then kill execution and throw an Exception. The only
        // exception to this rule is if this handler class is being
        // instantiated by a test method.

        if (Trigger.isExecuting != true && Test.isRunningTest() == false) {throw new HandlerException('This class may only be instantiated within a Trigger-based Execution Context.');}

        // Initialize the batchSize instance variable with the value from the
        // Trigger.size context variable. This allows us to track the number of
        // records in the trigger batch at the time this class was instantiated

        batchSize = Trigger.size;
    }
    /**
        beforeInsertHasRun() : Checks if the BEFORE INSERT static flag has been tripped, and trips the flag if it has not.
        @return                boolean   Returns TRUE if the BEFORE INSERT trigger has already run, FALSE if not.
    */
    @testVisible
    protected boolean beforeInsertHasRun() {
        if (isBeforeInsertFirstRun) {
            return isBeforeInsertFirstRun = false;
        }
        return true;
    }
    /**
        beforeUpdateHasRun() : Checks if the BEFORE UPDATE static flag has been tripped, and trips the flag if it has not.
        @return                boolean   Returns TRUE if the BEFORE UPDATE trigger has already run, FALSE if not.
    */
    @testVisible
    protected boolean beforeUpdateHasRun() {
        if (isBeforeUpdateFirstRun) {
            return isBeforeUpdateFirstRun = false;
        }
        return true;
    }
    /**
        beforeDeleteHasRun() : Checks if the BEFORE DELETE static flag has been tripped, and trips the flag if it has not.
        @return                boolean   Returns TRUE if the BEFORE DELETE trigger has already run, FALSE if not.
    */
    @testVisible
    protected boolean beforeDeleteHasRun() {
        if (isBeforeDeleteFirstRun) {
            return isBeforeDeleteFirstRun = false;
        }
        return true;
    }
    /**
        afterInsertHasRun() : Checks if the AFTER INSERT static flag has been tripped, and trips the flag if it has not.
        @return               boolean   Returns TRUE if the AFTER INSERT trigger has already run, FALSE if not.
    */
    @testVisible
    protected boolean afterInsertHasRun() {
        if (isAfterInsertFirstRun) {
            return isAfterInsertFirstRun = false;
        }
        return true;
    }
    /**
        afterUpdateHasRun() : Checks if the AFTER UPDATE static flag has been tripped, and trips the flag if it has not.
        @return               boolean   Returns TRUE if the AFTER UPDATE trigger has already run, FALSE if not.
    */
    @testVisible
    protected boolean afterUpdateHasRun() {
        if (isAfterUpdateFirstRun) {
            return isAfterUpdateFirstRun = false;
        }
        return true;
    }
    /**
        afterDeleteHasRun() : Checks if the AFTER DELETE static flag has been tripped, and trips the flag if it has not.
        @return               boolean   Returns TRUE if the AFTER DELETE trigger has already run, FALSE if not.
    */
    @testVisible
    protected boolean afterDeleteHasRun() {
        if (isAfterDeleteFirstRun) {
            return isAfterDeleteFirstRun = false;
        }
        return true;
    }
    /**
        afterUndeleteHasRun() : Checks if the AFTER UNDELETE static flag has been tripped, and trips the flag if it has not.
        @return                 boolean   Returns TRUE if the AFTER UNDELETE trigger has already run, FALSE if not.
    */
    @testVisible
    protected boolean afterUndeleteHasRun() {
        if (isAfterUndeleteFirstRun) {
            return isAfterUndeleteFirstRun = false;
        }
        return true;
    }
}