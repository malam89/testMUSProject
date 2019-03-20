/**
Description : This test class is for the following below classes/triggers
              EON_Technician_Trigger
              EON_Technician_Trigger_Helper              
**/
/* 
Created By    : Nitin Bangar
Created On    : 13/04/2016
Service Req   : SR_EON_Scheduling_001

Change History:CH01 #SR_EON_Scheduling_032 # 05/05/2016 # Pedda Reddeiah # added code to achieve SR functionality 
*/
@isTest
public class EON_Technician_Trigger_Test{    
    
    /**
    technicianTrigger_Pass(): this method will update and check the status of appointment Status, this will cover the code for EON_Appointment_Trigger_Helper and EON_Appointment_Trigger
    **/
     @isTest static void technicianTrigger_Pass() {
        
        Test.startTest();  
      
            EON_Technician__c eonTech = EON_CreateTestRecords.createEONTechnician();        
            eontech.Training_Start_Date__c = date.today();
            insert eonTech;
            eontech.Training_Start_Date__c = date.today();
            eontech.Mobile__c = '123456899';
            eonTech.Name = 'Tech'; 
            eonTech.h_Status__c = 'active';
            update eonTech;
            eonTech.h_Status__c = 'InActive';
            update eonTech;
       //Ch01.Start
            List<EON_Technician__c> lsttech =new  List<EON_Technician__c>();
            lsttech.add(eonTech);
             
            EON_Technician_Trigger_Helper helper = new EON_Technician_Trigger_Helper();
            helper.OnBeforeUpdate(lsttech);
             
            EON_Technician_Trigger_Helper.sendEmailToEONSmartMeter(eonTech.id,eonTech.h_Status__c);
       //Ch01.End
            System.assertEquals('Tech', eonTech.name); 
            EON_Technician_Trigger_Helper.sendEmailToEONSmartMeter('Test','InActive');            

        Test.stopTest();
    }
}