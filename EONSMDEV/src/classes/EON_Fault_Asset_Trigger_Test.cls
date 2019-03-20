/**
Description : This test class is for the following below classes/triggers
              EON_Fault_Asset_Trigger 
**/
/* 
Created By    : Kondal
Created On    : 06-04-2016
Service Req   : SR_EON_AL_008 
Change History:

*/
@isTest
public class EON_Fault_Asset_Trigger_Test
{
    /**
    eonCreateAppTestDataUpdateAppointmentStatus(): this method will create the test data for entair test class
    **/
     static testmethod void  eonCreateAppTestDataUpdatestock()
    {
        List<EON_Technician__c> lstTech = EON_CreateTestRecords.createEonTechnicianList();
        insert lstTech;
        
        EON_Stock__c eonstock= EON_CreateTestRecords.createEonStock();
        eonstock.Technician_Name__c=lstTech[0].id;
        insert eonstock;
        
        EON_Stock__c eonstock1= EON_CreateTestRecords.createEonStock();
        eonstock1.Technician_Name__c=lstTech[1].id;
        insert eonstock1;
        eonstock1.Serial_Number__c='4123';
        Update eonstock1;
        
        EON_Stock__c eonstock2= EON_CreateTestRecords.createEonStock();
        eonstock2.Technician_Name__c=lstTech[2].id;
        insert eonstock2;
        eonstock2.Serial_Number__c='4125';
        Update eonstock2;
        
        EON_Stock__c eonstock3= EON_CreateTestRecords.createEonStock();
        eonstock3.Technician_Name__c=lstTech[3].id;
        insert eonstock3;
        eonstock3.Serial_Number__c='4126';
        Update eonstock3;
        
       /* EON_Stock__c eonstock4= EON_CreateTestRecords.createEonStock();
        eonstock4.Technician_Name__c=lstTech[4].id;
        insert eonstock4;
        eonstock4.Serial_Number__c='';
        update eonstock4;*/
        
        EON_Appointment__c appointment= EON_CreateTestRecords.createEONAppointment();
        appointment.Technician__c=lstTech[0].id;
        insert appointment;
        
        Test.startTest();
        List<EON_Faulty_Asset__c> listfaultyasset = new List<EON_Faulty_Asset__c>();
        for(integer i=0;i<3;i++)
        {
            EON_Faulty_Asset__c eonfult = EON_CreateTestRecords.createEonFaultyAsset();
            eonfult.Job_Reference__c = appointment.id;
            listfaultyasset.add(eonfult);            
        }
        insert listfaultyasset;
        //listfaultyasset[1].Serial_Number_1__c='';
        //update listfaultyasset;
        system.debug('@@@faulty@@@'+listfaultyasset);
        
     
    }
    
    }