/**
    Description : This class is used for test coverage for the below classes
    1. EON_Update_Appointment_OFSC_CTRL
    2. EON_Update_Appointment_OFSC_Batch
**/
/*
    Created By : Praveen G
    Created Date : 25-09-2016 
    Service Request : SR_OptiMUS_EON_098
    Change History: 
*/
@isTest
private class EON_Update_Appointment_OFSC_CTRL_test {

    /**
        unitTest1() - unitTest1 .
    **/
    static testmethod void unitTest1() {
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        Contract_Number__c contract = EON_CreateTestRecords.createContractNumber();
        contract.Contract_Client_Short_Name__c = 'EON';
        insert contract;
        
        //Create EON Job
        EON_Job__c objJob = new EON_Job__c(Name='OOASMARTDFINST', Description__c='Smart Dual Fuel Installation', Job_Type__c='Maintenance', Duration__c=10); //CH09 - Added job type
        insert objJob;

        EON_Appointment__c app = EON_CreateTestRecords.createEONAppointment();
        app.MPRN__c = 'TEST1234';
        app.Appointment_Date__c = System.today();
        app.Contract__c = contract.id;
        app.Key_Collection_Required__c=false;
        app.Post_Code__c = 'SG1 2ST';
        app.Job_Code__c = objJob.id;
        insert app;
        
        Attachment att = new Attachment();
        att.body = blob.valueOf(''+app.id+'\n');
        att.Name = 'Test.XLS';
        att.parentID = app.id;
        insert att;
        
        System.currentPageReference().getParameters().put('recId', app.id);
        EON_Update_Appointment_OFSC_CTRL ctrl = new EON_Update_Appointment_OFSC_CTRL();
        ctrl.processCSVFileAppointments();
        
        att.Name='TEST_processed.csv';
        update att;        
        ctrl.processCSVFileAppointments();
        
        att.Name='TEST.csv';
        update att;                
        ctrl.processCSVFileAppointments();
        
        att.body = blob.valueOf(''+app.id+',\n'); 
        update att;
        ctrl.processCSVFileAppointments();  
        
        att.body = blob.valueOf('\n'); 
        update att;
        ctrl.processCSVFileAppointments(); 
        
        EON_Update_Appointment_OFSC_Batch batch = new EON_Update_Appointment_OFSC_Batch();              
        EON_Sub_Area__c subarea = new EON_Sub_Area__c();
        subarea.Name = 'Smart';
        subarea.Smart__c = true;
        subarea.Oracle_Bucket_ID__c = 'bucketID';
        subarea.Region_Subarea__c = 'subarea';
        insert subarea;
        batch.updateAppForSubArea(app.id, subarea.id);
        
        EON_Post_Code__c postcode = new EON_Post_Code__c();
        postcode.Name = 'SG1';
        postcode.Sub_Area_Name__c = subarea.id;
        postcode.Subarea_PostCode__c = 'SG1 1TT';
        insert postCode;
        
        batch.calculateSubArea('SG1', 'Smart');
         
    }
}