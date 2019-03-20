/**
    Description : This class is called from the custom button on EON Site Vulnerability object called Delete Vulnerability.
    Test Class : EON_Site_Vulnerability_Create_Ctrl_Test
                 EON_Eligibility_Overd_Create_Ctrl_Test 
**/

/*
    Created By : Praveen G
    Created Date : 13/03/2017
    Service Request : SR_EON_PC_105
    Change History : 
    CH01 # SR_OptiMUS_EON_136 # 30/10/2017 # Praveen G #  Added new method.
*/

global class EON_Site_Vul_Handler{

    /**
        UpdateSiteVulnerabilityAsDelete(String recordID) - This method is called from Delete Vulnerability button on 
                    EON Site Vulnerability object to update the record as deleted.
    **/
    webservice static String UpdateSiteVulnerabilityAsDelete(String recordID){
        try{
            EON_Site_Vulnerability__c rec = new EON_Site_Vulnerability__c(id=recordID);
            rec.EON_Site_Vulnerability_Change_Type__c = 'D';
            upsert rec;
            return 'SUCCESS';
        }catch(Exception ex){
            System.debug('Exception Occured ' + ex.getStackTraceString());
            return 'Fail';
        }
    }
    
    //CH01.Start
    /**
        UpdateSiteEligibilityOverrideAsDelete(String recordID) - This method is called from Delete Site 
                    Eligibility Override button on 
                    EON Eligibility Override  object to update the record as deleted.
    **/
    webservice static String UpdateSiteEligibilityOverrideAsDelete(String recordID){
        try{
            EON_Eligibility_Override__c rec = new EON_Eligibility_Override__c(id=recordID);
            rec.Eligibility_Change_Type__c = 'D';
            upsert rec;
            return 'SUCCESS';
        }catch(Exception ex){
            System.debug('Exception Occured ' + ex.getStackTraceString());
            return 'Fail';
        }
    }
    //CH01.End
}