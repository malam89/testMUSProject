/**
    Description :   S2 – Work Order Appointment Import Routine (Business Continuity Management)
    NGS_S2_WO_Appointment_Import_test
**/
/*
    Created By  : Shruti Moghe
    Created On  : 29/03/2017
    Service Req : SR_OptiMUS_NG_024
    Change History :


*/
    
@isTest
global class NGS_S2_WO_Appointment_Import_test{
    /*
        newSmartTest(): 
    */
    static testmethod void newSmartTest(){
        NGS_Job_Code__c ngsJobCode = new NGS_Job_Code__c(name = 'EXCRE_DSP02', Bucket_Type__c  = 'Smart' ,Job_Type__c = 'Smart', Job_Description__c = 'Accuracy Attend (Electric)');
        insert ngsJobCode;
        
        NGS_Region__c ngsRegion = new NGS_Region__c(name  = 'Southern');
        insert ngsRegion;
        
        NGS_Sub_Region__c subRegion = new NGS_Sub_Region__c(Smart__c = true, Oracle_Bucket_ID__c = 'SN_001', name = 'Southern Area 1', Region__c = ngsRegion.id);
        insert subRegion;
        NGS_Sub_Region__c subRegion1 = new NGS_Sub_Region__c(Smart__c = true, Oracle_Bucket_ID__c = 'SN_002', name = '1Southern Area 1', Region__c = ngsRegion.id);
        insert subRegion1;
        
        NGS_Postcode__c ngsPCinst = new NGS_Postcode__c (name = 'RG2 6', sub_region__c  = subRegion.id);
        insert ngsPCinst;
        NGS_Postcode__c ngsPCinst1 = new NGS_Postcode__c (name = 'RG2 6', sub_region__c  = subRegion1.id);
        insert ngsPCinst1;
        NGS_Import__c import1 = new NGS_Import__c();
        insert import1;
        string body='Work Order Number,Change Type,Std Job Id,Job Description,Appt Start Time,Appt Finish Date,Appointment Type,Message Date,Mpan,Mprn,Duration,Service Provider Id,Addr Line 1,Addr Line 2,City,County,Post Code,Country,Latitude,Longitude,Note Type,Note Text,Employee Id'+'\r\n';
        body=body+'6000277,NEW,EXCRE_DSP02,CRE Exchange (Dual),29/06/2017 12:00,29/06/2017 16:00,Appointment to Start,19/06/2017 15:41,1.42E+12,2538365410,1.25,SP02,56,56  WOODHOUSE ROAD,BIRMINGHAM,,RG2 6UJ,GB,52.45780945,-1.981809378,test,testing,123456789'+'\r\n';
        body=body+'17111988,UPDATE,EXCRE_DSP02,CRE Exchange (Dual),28/06/2017 10:00,28/06/2017 12:00,Appointment to Start,18/06/2017 15:41,1.41E+12,2511909309,1.25,SP02,39,AVERN CLOSE ALEXANDRA ROAD,WEST MIDLANDS,TIPTON,RG2 6UJ,GC,52.53158951,-2.04658246,test,testing,987654321'+'\r\n';
        utility.createAttachment(import1.id, body ,'ImportFile');
         Test.setmock(HttpCalloutMock.class, new NGS_WO_Appointment_TriggerMock());
        NGS_S2_WO_Appointment_Import.ReadandparseCSV(import1.id);
  
    }
}