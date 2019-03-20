/**
Description : This test class is for the following below classes:
              EON_OFSC_Create_Appointment_Wrapper    
**/

/*
    Created By  : Mahadev J
    Created On  : 15/11/2016
    Service Req: SR_EON_AB_188
    Change History
*/


@isTest
public class EON_OFSC_Create_Appointment_Wrapper_Test{
    
    static testMethod void Test1(){
        EON_Job__c job = new EON_Job__c();
        job.name = 'test';
        job.Description__c = 'test';
        job.Job_Type__c = 'test';
        insert job;
        
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'test';
        insert customer;
        
        EON_Site__c eSite = new EON_Site__c();
        eSite.Customer__c = customer.ID;
        eSite.Postcode__c = 'test';
        insert eSite;
        
        EON_Fuel__c eFuel = new EON_Fuel__c();
        eFuel.Premise__c = eSite.ID;
        eFuel.MPAN__c = 'test';
        eFuel.MPRN__c = 'test';
        insert eFuel;
        
        EON_Electric_Meter_Type__c eMeterType = new EON_Electric_Meter_Type__c();
        eMeterType.OFS_Enumeration__c = 234;
        insert eMeterType;
        
        EON_Gas_Meter_Type__c gMeterType = new EON_Gas_Meter_Type__c();
        gMeterType.OFS_Enumeration__c = 234;
        insert gMeterType;
        
        EON_Electric_Meter_Location__c eMeterLocation = new EON_Electric_Meter_Location__c();
        eMeterLocation.OFS_Enumeration__c = 123;
        insert eMeterLocation;
        
        EON_Gas_Meter_Location__c gMeterLocation = new EON_Gas_Meter_Location__c();
        gMeterLocation.OFS_Enumeration__c = 123;
        insert gMeterLocation;
        
        EON_Gas_Meter_Mechanism__c gMeterMech = new EON_Gas_Meter_Mechanism__c();
        gMeterMech.OFS_Enumeration__c = 123;
        insert gMeterMech;
        
        Eon_Appointment_Reason__c appReason = new Eon_Appointment_Reason__c();
        appReason.OFS_Enumeration__c = 123;
        insert appReason;
        
        EON_Parking__c ePark = new EON_Parking__c();
        ePark.OFS_Enumeration__c = 123;
        insert ePark;
        
        EON_Vulnerability_Code__c eVul = new EON_Vulnerability_Code__c();
        eVul.name = 'test';
        insert eVul;
        
        test.startTest();
        EON_Appointment__c appt = new EON_Appointment__c();
        appt.Appointment_Key__c = '2344';
        appt.Current_Phase__c = '1PH';
        appt.Job_Code__c = job.ID;
        EON_OFSC_Create_Appointment_Wrapper apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,null,null);
        appt.Fuel_ID__c = eFuel.ID;
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,null,null);
        appt.MPAN__c = 'test';
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,null,null);
        appt.Metering_Point_Address_Line_2__c = 'test';
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,null,null);
        appt.E_Meter_Type__c = eMeterType.ID;
        appt.E_Check_Meter_Location__c = eMeterLocation.ID;
        appt.E_Meter_Location__c = eMeterLocation.ID;
        appt.G_Meter_Type__c = gMeterType.ID;
        appt.G_Check_Meter_Location__c = gMeterLocation.ID;
        appt.G_Meter_Location__c = gMeterLocation.ID;
        appt.G_Meter_Mechanism__c = gMeterMech.ID;
        appt.Appointment_reason_code__c = appReason.ID;
        appt.Parking_Type__c = ePark.ID;
        appt.Metering_Point_Address_Line_5__c = 'test';
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,null,null);
        
        appt.Metering_Point_Address_Line_2__c = '';
        appt.Metering_Point_Address_Line_3__c = 'test';
        appt.Metering_Point_Address_Line_4__c = 'test';
        appt.Metering_Point_Address_Line_8__c = 'test';
        appt.Metering_Point_Postcode__c = 'test';
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,null,null);
        
        appt.MPAN__c = '';
        appt.Building_Name__c = 'test';
        appt.Thorofare__c = 'test';
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,null,null);
        appt.Building_Name__c = '';
        appt.Post_Code__c = 'test';
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,null,null);
        appt.Fuel_ID__c = null;
        appt.MPAN__c = 'test';
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,null,null);
        
        EON_Appointment_Vulnerability__c appVal = new EON_Appointment_Vulnerability__c();
        appVal.Description__c = eVul.ID;
        list<EON_Appointment_Vulnerability__c> allAppVal = new list<EON_Appointment_Vulnerability__c>();
        allAppVal.add(appVal);
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,allAppVal,null);
        
        EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
        appCon.Contact_Full_Name__c = 'test';
        list<EON_Appointment_Contact__c> allAppCon = new list<EON_Appointment_Contact__c>();
        allAppCon.add(appCon);
        apptWrapper = new EON_OFSC_Create_Appointment_Wrapper(appt,allAppVal,allAppCon);
        
        test.stopTest();
    }
}