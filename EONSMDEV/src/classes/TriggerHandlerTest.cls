/**
    Description   : Test class for the TriggerHandler virtual class
*/
/*
    Created By    : Puneet Mehta
    Created On    : 02/03/2017
    Service Req   : SR_OptiMUS_NG_017
*/
@isTest
private class TriggerHandlerTest {
  /**
    recursionCheckMethods_NormalOperation_Success() : Test method to ensure that all "recursion check" methods properly flip their answers from
                                                      FALSE, to TRUE, and that they remain TRUE for at least one more method call after detecting
                                                      the flip.
  */
    static testMethod void recursionCheckMethods_NormalOperation_Success() {

        // Instantiate a TriggerHandler parent class, then test all of the 
        // "recursion check" methods.
        TriggerHandler handler = new TriggerHandler();
        // Before Insert.
        System.AssertEquals(false,  handler.beforeInsertHasRun());
        System.AssertEquals(true,   handler.beforeInsertHasRun());
        System.AssertEquals(true,   handler.beforeInsertHasRun());
        // Before Update.
        System.AssertEquals(false,  handler.beforeUpdateHasRun());
        System.AssertEquals(true,   handler.beforeUpdateHasRun());
        System.AssertEquals(true,   handler.beforeUpdateHasRun());
        // Before Delete.
        System.AssertEquals(false,  handler.beforeDeleteHasRun());
        System.AssertEquals(true,   handler.beforeDeleteHasRun());
        System.AssertEquals(true,   handler.beforeDeleteHasRun());
        // After Insert.
        System.AssertEquals(false,  handler.afterInsertHasRun());
        System.AssertEquals(true,   handler.afterInsertHasRun());
        System.AssertEquals(true,   handler.afterInsertHasRun());
        // After Update.
        System.AssertEquals(false,  handler.afterUpdateHasRun());
        System.AssertEquals(true,   handler.afterUpdateHasRun());
        System.AssertEquals(true,   handler.afterUpdateHasRun());
        // After Delete
        System.AssertEquals(false,  handler.afterDeleteHasRun());
        System.AssertEquals(true,   handler.afterDeleteHasRun());
        System.AssertEquals(true,   handler.afterDeleteHasRun());
        // After Undelete
        System.AssertEquals(false,  handler.afterUndeleteHasRun());
        System.AssertEquals(true,   handler.afterUndeleteHasRun());
        System.AssertEquals(true,   handler.afterUndeleteHasRun());
        return;
    }
}