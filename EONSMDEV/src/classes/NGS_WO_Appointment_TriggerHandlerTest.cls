/**
    Description     : Test class containing methods that cover code implemented by the NGS_WO_Appointment_TriggerHandler class.
*/
/*
    Created By        : Puneet Mehta
    Created On        : 02/03/2017
    Service Req     : SR_OptiMUS_NG_017
*/
@isTest
private class NGS_WO_Appointment_TriggerHandlerTest {

    //below test setup method will be invoked
    // implicitly before every test methods 
    @testsetup
    static void createNgWoAppts(){
        NGS_Technician__c rejectedNgsTech = new NGS_Technician__c(First_Name__c = 'Rejected', Last_Name__c = 'Test1', Gender__c = 'F', 
                                                Start_Location__c = 'UK', Mobile_Number__c = '07705898212');
        insert rejectedNgsTech;
        NGS_Technician__c ngsTech = new NGS_Technician__c(First_Name__c = 'Test', Last_Name__c = 'Test1', Gender__c = 'F', 
                                        Start_Location__c = 'UK', Mobile_Number__c = '07705898212');
        insert ngsTech;
        List<NGS_Work_Order_Appointment__c> lstNgsWoAppts = new List<NGS_Work_Order_Appointment__c>();        
        for(Integer i = 1 ; i<=200 ; i++) {
            NGS_Work_Order_Appointment__c ngsWoAppt = new NGS_Work_Order_Appointment__c(Name = 'NGS-000' + i, Address_Line_1__c = 'Test', 
                                                          Post_Code__c = 'SG1 2ST', Appointment_Start_Time__c = system.now(), Appointment_Finish_Time__c = system.now().addDays(1), Duration__c = '11:22', City__c = 'City', Country__c = 'Country', Message_Date__c = system.now());
            //Rejected
            if(i < 21){
                ngsWoAppt.Longitude__c = i;
                ngsWoAppt.Employee_ID__c = rejectedNgsTech.id;
                lstNgsWoAppts.add(ngsWoAppt);                      
                continue;
            }
            //Completed
            else if(i < 41){
                ngsWoAppt.Longitude__c = i;
                ngsWoAppt.Work_Order_Complete__c = system.now();
                lstNgsWoAppts.add(ngsWoAppt);
                continue;
            }
            //Work Done
            else if(i < 61){
                ngsWoAppt.Longitude__c = i;
                ngsWoAppt.Work_Order_Ops_Complete__c = system.now();
                lstNgsWoAppts.add(ngsWoAppt);
                continue;
            }
            //Suspended
            else if(i < 81){
                ngsWoAppt.Longitude__c = i;
                ngsWoAppt.Work_Order_Suspended__c = system.now();
                lstNgsWoAppts.add(ngsWoAppt);                      
                continue;
            }
            //On Site
            else if(i < 101){
                ngsWoAppt.Longitude__c = i;
                ngsWoAppt.Work_Order_Started__c = system.now();
                lstNgsWoAppts.add(ngsWoAppt);
                continue;
            }
            //On Route
            else if(i < 121){
                ngsWoAppt.Longitude__c = i;
                ngsWoAppt.Technician_On_Route__c = system.now();
                lstNgsWoAppts.add(ngsWoAppt);
                continue;
            }
            //Accepted
            else if(i < 141){
                ngsWoAppt.Longitude__c = i;
                ngsWoAppt.Work_Order_Accepted_by_Technician__c = system.now();
                lstNgsWoAppts.add(ngsWoAppt);
                continue;
            }
            //Assigned
            else if(i < 161){
                ngsWoAppt.Longitude__c = i;
                ngsWoAppt.Employee_ID__c = ngsTech.id;
                lstNgsWoAppts.add(ngsWoAppt);
                continue;
            }
            //Scheduled
            else if(i < 181){
                ngsWoAppt.Longitude__c = i;
                lstNgsWoAppts.add(ngsWoAppt);
                continue;
            }
            else{
                ngsWoAppt.Longitude__c = i;
                lstNgsWoAppts.add(ngsWoAppt);
            }
        }
        insert lstNgsWoAppts;
    }
    
    /**
        beforeInsert_calculateStatus_Rejected()
    */
    static testMethod void beforeInsert_calculateStatus_Rejected() {
        // Verify that the results are as expected.
        for(NGS_Work_Order_Appointment__c ngsWoAppt : [SELECT Id, Status__c, Longitude__c FROM NGS_Work_Order_Appointment__c WHERE Longitude__c < 21]){
            System.assertEquals('Rejected', ngsWoAppt.Status__c);
        }
        return;
    }
    /**
        beforeInsert_calculateStatus_Completed()
    */
    static testMethod void beforeInsert_calculateStatus_Completed() {
        // Verify that the results are as expected.
        for(NGS_Work_Order_Appointment__c ngsWoAppt : [SELECT Id, Status__c, Longitude__c FROM NGS_Work_Order_Appointment__c WHERE Longitude__c < 41 and Longitude__c > 20]){
            System.assertEquals('Completed', ngsWoAppt.Status__c);
        }
        return;
    }
    /**
        beforeInsert_calculateStatus_Work_Done()
    */
    static testMethod void beforeInsert_calculateStatus_Work_Done() {
        // Verify that the results are as expected.
        for(NGS_Work_Order_Appointment__c ngsWoAppt : [SELECT Id, Status__c, Longitude__c FROM NGS_Work_Order_Appointment__c WHERE Longitude__c < 61 and Longitude__c > 40]){
            System.assertEquals('Work Done', ngsWoAppt.Status__c);
        }
        return;
    }
    /**
        beforeInsert_calculateStatus_Suspended()
    */
    static testMethod void beforeInsert_calculateStatus_Suspended() {
        // Verify that the results are as expected.
        for(NGS_Work_Order_Appointment__c ngsWoAppt : [SELECT Id, Status__c, Longitude__c FROM NGS_Work_Order_Appointment__c WHERE Longitude__c < 81 and Longitude__c > 60]){
            System.assertEquals('Suspended', ngsWoAppt.Status__c);
        }
        return;
    }
    /**
        beforeInsert_calculateStatus_OnSite()
    */
    static testMethod void beforeInsert_calculateStatus_OnSite() {
        // Verify that the results are as expected.
        for(NGS_Work_Order_Appointment__c ngsWoAppt : [SELECT Id, Status__c, Longitude__c FROM NGS_Work_Order_Appointment__c WHERE Longitude__c < 101 and Longitude__c > 80]){
            System.assertEquals('On Site', ngsWoAppt.Status__c);
        }
        return;
    }
    /**
        beforeInsert_calculateStatus_OnRoute()
    */
    static testMethod void beforeInsert_calculateStatus_OnRoute() {
        // Verify that the results are as expected.
        for(NGS_Work_Order_Appointment__c ngsWoAppt : [SELECT Id, Status__c, Longitude__c FROM NGS_Work_Order_Appointment__c WHERE Longitude__c < 121 and Longitude__c > 100]){
            System.assertEquals('On Route', ngsWoAppt.Status__c);
        }
        return;
    }
    /**
        beforeInsert_calculateStatus_Accepted()
    */
    static testMethod void beforeInsert_calculateStatus_Accepted() {
        // Verify that the results are as expected.
        for(NGS_Work_Order_Appointment__c ngsWoAppt : [SELECT Id, Status__c, Longitude__c FROM NGS_Work_Order_Appointment__c WHERE Longitude__c < 141 and Longitude__c > 120]){
            System.assertEquals('Accepted', ngsWoAppt.Status__c);
        }
        return;
    }
    /**
        beforeInsert_calculateStatus_Assigned()
    */
    static testMethod void beforeInsert_calculateStatus_Assigned() {
        // Verify that the results are as expected.
        for(NGS_Work_Order_Appointment__c ngsWoAppt : [SELECT Id, Status__c, Longitude__c FROM NGS_Work_Order_Appointment__c WHERE Longitude__c < 161 and Longitude__c > 140]){
            System.assertEquals('Assigned', ngsWoAppt.Status__c);
        }
        return;
    }
    /**
        beforeInsert_calculateStatus_Scheduled()
    */
    static testMethod void beforeInsert_calculateStatus_Scheduled() {
        // Verify that the results are as expected.
        for(NGS_Work_Order_Appointment__c ngsWoAppt : [SELECT Id, Status__c, Longitude__c FROM NGS_Work_Order_Appointment__c WHERE Longitude__c < 181 and Longitude__c > 160]){
            System.assertEquals('Scheduled', ngsWoAppt.Status__c);
        }
        return;
    }
}