/**
	Description : This test class is for the following below classes/triggers
                  EON_MDS_OAuth_Authentication;    

**/
/*
    Created By  : Tabish Almas
    Created On  : 18/02/2019
    Service Req	: SR_OptiMUS_EON_297
    Change History
*/

@isTest
public with sharing class EON_MDS_OAuth_Authentication_Test {
    /**
	UnitTest1()   
	**/   
    static testMethod void UnitTest1() {
        Test.setMock(HttpCalloutMock.class, new EON_MDS_OAuth_MockResponse());
        
        Test.startTest();
        String accessToken = EON_MDS_OAuth_Authentication.genAccessToken();
        System.debug('AccessToken->'+accessToken);
        Test.stopTest();
    }
}