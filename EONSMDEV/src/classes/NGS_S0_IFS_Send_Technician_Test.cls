/**
    Description : This class is test class for NGS_S0_IFS_Send_Technician
**/
/*
    Created By  : Puneet Mehta
    Created On  : 22/03/2017
    Service Req : SR_OptiMUS_NG_006
    Change History
*/

@isTest
public class NGS_S0_IFS_Send_Technician_Test{
    @istest static void unit1(){
        NGS_OFSC_SingleReqMock fakeResourceResp = new NGS_OFSC_SingleReqMock(200,
                                                         'OK',
                                                         '[{"resourceId": "1234"}]',
                                                         null);
        NGS_OFSC_SingleReqMock fakeUserResp = new NGS_OFSC_SingleReqMock(200,
                                                         'OK',
                                                         '[{"mainResourceId": "1234"}]',
                                                         null);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://api.etadirect.com/rest/ofscCore/v1/resources/',fakeResourceResp);
        endpoint2TestResp.put('https://api.etadirect.com/rest/ofscCore/v1/users/User',fakeUserResp);
        HttpCalloutMock multiCalloutMock =
                                   new NGS_OFSC_MultiReqMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        
        NGS_Technician__c ngstech = new NGS_Technician__c(Start_Date__c = SYSTEM.TODAY(), First_Name__c='abc',Gender__c='M',Last_Name__c='xyz',Start_Location__c='SG1',Mobile_Number__c='07405898212');
        insert ngstech;
    }
    
    @istest static void unit2(){
        NGS_OFSC_SingleReqMock fakeResourceResp = new NGS_OFSC_SingleReqMock(400,
                                                         'Bad Request',
                                                         '[{"detail": "ERROR"}]',
                                                         null);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://api.etadirect.com/rest/ofscCore/v1/resources/',fakeResourceResp);
        HttpCalloutMock multiCalloutMock = new NGS_OFSC_MultiReqMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        Test.setMock(WebServiceMock.class, new NGS_S0_ReceiveHrResource_IFS_WSMock());
        NGS_Technician__c ngstech = new NGS_Technician__c(Start_Date__c = SYSTEM.TODAY(), First_Name__c='abc',Gender__c='M',Last_Name__c='xyz',Start_Location__c='SG1',Mobile_Number__c='07405898212');
        insert ngstech;
    }
    
    @istest static void unit3(){
        NGS_OFSC_SingleReqMock fakeResourceResp = new NGS_OFSC_SingleReqMock(201,
                                                         'Created',
                                                         '[{"resourceId": "1234"}]',
                                                         null);
        NGS_OFSC_SingleReqMock fakeUserResp = new NGS_OFSC_SingleReqMock(200,
                                                         'OK',
                                                         '[{"mainResourceId": "1234"}]',
                                                         null);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://api.etadirect.com/rest/ofscCore/v1/resources/',fakeResourceResp);
        endpoint2TestResp.put('https://api.etadirect.com/rest/ofscCore/v1/users/User',fakeUserResp);
        HttpCalloutMock multiCalloutMock =
                                   new NGS_OFSC_MultiReqMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        Test.setMock(WebServiceMock.class, new NGS_S0_ReceiveHrResource_IFS_WSMock());
        NGS_Technician__c ngstech = new NGS_Technician__c(Start_Date__c = SYSTEM.TODAY(), First_Name__c='abc',Gender__c='M',Last_Name__c='xyz',Start_Location__c='SG1',Mobile_Number__c='07405898212');
        insert ngstech;
    }
    
    @istest static void unit4(){
        NGS_OFSC_SingleReqMock fakeResourceResp = new NGS_OFSC_SingleReqMock(201,
                                                         'Created',
                                                         '[{"resourceId": "1234"}]',
                                                         null);
        NGS_OFSC_SingleReqMock fakeUserResp = new NGS_OFSC_SingleReqMock(200,
                                                         'OK',
                                                         '[{"mainResourceId": "1234"}]',
                                                         null);
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://api.etadirect.com/rest/ofscCore/v1/resources/',fakeResourceResp);
        endpoint2TestResp.put('https://api.etadirect.com/rest/ofscCore/v1/users/User',fakeUserResp);
        HttpCalloutMock multiCalloutMock =
                                   new NGS_OFSC_MultiReqMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        NGS_Technician__c ngstech = new NGS_Technician__c(Start_Date__c = SYSTEM.TODAY(), First_Name__c='abc',Gender__c='M',Last_Name__c='xyz',Start_Location__c='SG1',Mobile_Number__c='07405898212');
        insert ngstech;
        test.starttest();
        Test.setMock(WebServiceMock.class, new NGS_S0_ReceiveHrResource_IFS_WSMock());
        NGS_S0_IFS_Send_Technician.sendTechnicianToIfs(ngstech.id);
        test.stoptest();
    }
}