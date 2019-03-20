/**
    Description : This class is used for EON Job Results object trigger helper.
    Test Class : EON_RetrieveDataInCache_Schedule_Test
    
    EON_RetrieveDataInCache_Schedule schObj = new EON_RetrieveDataInCache_Schedule();
    System.schedule('EON_RetrieveDataInCache_Schedule@00', '0 00 * * * ? *', schObj);
    System.schedule('EON_RetrieveDataInCache_Schedule@10', '0 10 * * * ? *', schObj);
    System.schedule('EON_RetrieveDataInCache_Schedule@20', '0 20 * * * ? *', schObj);
    System.schedule('EON_RetrieveDataInCache_Schedule@30', '0 30 * * * ? *', schObj);
    System.schedule('EON_RetrieveDataInCache_Schedule@40', '0 40 * * * ? *', schObj);
    System.schedule('EON_RetrieveDataInCache_Schedule@50', '0 50 * * * ? *', schObj); 
**/

/*    
    Created By : Mehboob Alam
    Created Date : 19/04/2018
    Service Request : SR_OptiMUS_ALL_ORGS_129
    Change History
    
*/
global class EON_RetrieveDataInCache_Schedule implements Schedulable {
	
    global void execute(SchedulableContext sc){
    	
       List<EON_Fuel__c> lstFuel = [SELECT Gas_multiplication_factor_A0120__c,h_Gas_units_of_measure_A0123__c,Gas_units_of_measure_A0123__c,Gas_year_of_manufacture_A0021__c,ID, 
                                    Gas_Map_identifier__c, Fuel_type__c, MPAN__c, MPRN__c, Gas_manufacturer_code_A0060__c, Gas_measuring_capacity_A0112__c, Gas_Meter_Mechanism__c, 
                                    Gas_meter_serial_number__c, Electric_Meter_Location__c, Gas_meter_location__c, h_Gas_Supplier_MPID__c,
					                Gas_meter_type_A0025__c, Gas_model_A0083__c, Gas_number_of_dials_or_digits_A0121__c, Gas_payment_method_A0163__c, Gas_supplier_code__c,
					                Premise__r.Building_Name__c, Premise__r.Dependant_Locality__c, Premise__r.Dependant_Thorofare__c, Premise__r.Double_Dependant_Locality__c,
					                Premise__r.Sub_Building_Name__c, Premise__r.Thorofare__c, Premise__r.Town__c, Premise__r.Customer__c, Premise__r.Customer__r.Customer_Name__c,
					                Premise__c, Premise__r.Postcode__c, Premise__r.Customer__r.Customer_group_type__c, Premise__r.Customer__r.PAYG_Flag__c, Gas_Meter_Mechanism__r.Code__c
					                FROM EON_Fuel__c ORDER BY CreatedDate DESC LIMIT 10000];
        
       List<EON_Site_Vulnerability__c> lstVul = [SELECT ID, Vulnerability_code__c, EON_Site_Vulnerability_Change_Type__c,Vulnerability_code__r.Vulnerability_Code__c, Vulnerability_Type__c 
                                                 FROM EON_Site_Vulnerability__c ORDER BY CreatedDate DESC LIMIT 10000];
                                                  
       List <EON_Appointment_Contact__c> lstCon =[SELECT Contact_Full_Name__c, Contact_Type__c, Id,Name, Customer_Assistant__c, EON_Appointment_ID__c, Media_Detail__c, Media_Type__c
                                                  FROM EON_Appointment_Contact__c ORDER BY CreatedDate DESC LIMIT 10000];
                                                  
       List <EON_Appointment_Contact__c> lstCon1  = [SELECT Contact_Full_Name__c,Contact_Type__c,EON_Appointment_ID__c,Id,Media_Detail__c,Media_Type__c FROM EON_Appointment_Contact__c 
                                                     WHERE EON_Appointment_ID__c = :system.label.EON_Appointment_Id];
                                                  
       List<Eon_Appointment__c> lstApp = [SELECT Id, Fuel_ID__c, Name, Appointment_Date__c, Start_Time__c, End_Time__c, Time_Slot__c FROM Eon_Appointment__c ORDER BY CreatedDate DESC LIMIT 10000];
       
       List<EON_Stock__c> lstStock = [SELECT Asset_Type__c,CreatedById,Technician_Mismatch__c,CreatedDate,Date_Faulty__c,Date_of_Dispatch__c,Date_of_Installation__c,Date_Returned_Received__c,
                                      EON_Job_Results__c,Faulty_Asset_Unique_ID__c,Id,IsDeleted,Job_Reference__c,KID__c,Manufacture__c,Model__c,Name,Order_Reference__c,
                                      Product_Code__c,Serial_Number__c,Status__c,SystemModstamp,Technician_Name__c FROM EON_Stock__c ORDER BY CreatedDate DESC LIMIT 10000];
                                                  

    }
}