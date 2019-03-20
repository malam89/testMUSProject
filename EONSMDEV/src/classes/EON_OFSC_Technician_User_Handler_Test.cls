/**
    Description : This class is used to test coverage of the class - EON_OFSC_Technician_User_Handler
**/

@isTest
public class EON_OFSC_Technician_User_Handler_Test{
    
    /**
        unitTest() - unitTest.
    **/

    static testmethod void unitTest(){
             

        eon_technician__c eontech = eon_createtestrecords.createeontechnician(); 
        eontech.name = 'eontest';  
        eontech.Training_Start_Date__c = System.today();     
        insert eontech;    
    
        EON_OFSC_Technician_User_Handler.CreateOFSCUserForTechnician('TEST', eontech.id);
        EON_OFSC_Technician_User_Handler.DeleteOFSCUserForTechnician('TEST');
        EON_OFSC_Technician_User_Handler.getAuthenticationElement();
    } 
    
}