/**
Description : This test class will create the object instance with test data.
              
**/

/* 
Created By    : Sivasankar K
Created On    : 17/02/2016
Service Req   : SR_EON_AB_002
Change History
CH01 # 25-02-2016 # Sivasankar K # SR_EON_AB_006 # Added the new methods for creating the test record.
CH02 # 26-02-2016 # Mahadev J # SR_EON_AL_001 # Rename the API name Resource_ID__c to KID__c.
CH03 # 02-03-2016 # Akshay Bairagi # SR_EON_PC_007 # changed the API name of Campaign to Campaign_Flag__c.
CH04 # 09/03/2016 # Mahadev J # SR_Isis_EON_007 # Updated field API Town__c to Post_Town__c.
CH05 # 10/03/2016 # Purvi # SR_Isis_EON_009 # Added a method to create Contract Number test data.
CH06 # 10/03/2016 # Puneet Mehta # SR_Isis_EON_005 # Added a method to create EON Service Sattus test data.
CH07 # 16-03-2016 # Shruti Moghe # SR_EON_AL_003 # updated the field API Date_Started__c to Start_Date__c and added two new new method
CH08 # 17-03-2016 # Kondal # SR_EON_PC_011 # updated the field API Gas_Meter_Type__c to Gas_Meter_Mechanism__c and Current_Payment_Method_indicator__c changed the data type lookup to checkbox and removed the fields Customer_Name_Reason_for_Update__c,DOB_Reason_for_Update__c,Reason_for_Update__c,Record_Type__c,Customer_information_Change_Type__c,
Opt_out_reason_code__c,Opt_in__c,Date_of_Birth__c,C_Address__c,S_Address__c
CH09 #19-March-2016 # Praveen G # SR_Isis_EON_010 # Added a method to create Appointment Value test data.
CH10 # 21-03-2016 # Purvi # SR_EON_AL_006 #removed KID field from query due to change in field type.
CH11 #23/03/2016 #Shruti #SR_EON_PC_018 #updated the field type of Code__c
CH12 #22/03/2016 #Mahadev #SR_EON_PC_008 #Improvement to test class coverage
CH13 #23/03/2016 ~Mahadev #SR_EON_PC_020 #Changed data type of field PAYG_Interest__c
CH14 # 28-03-2016 # Kondal # SR_EON_PC_019 # Changed label name from EON Op-Out Reason to EON Opt-Out Reason
CH15 # 28-03-2016 # Purvi # SR_EON_PC_016 # changed API name of some Objects.
CH16 #30-03-2016 #krishna yalavarthi # SR_EON_AB_026 # Delete the field Cancellation DateTime field from EON Appointment Cancel Reason. 
CH17 #04/04/2016 #Mahadev #SR_EON_PC_022 #Deleted fields
CH18 #06-04-2016 # Kondal # SR_EON_AL_008 # Added new methods for creating test record.
CH19 # 09/04/2016 # Tashika # SR_EON_AL_007 # Added fields in EON Technician List and created new method to create list on Eon Stock Records.
CH20 # 09/04/2016 # Aruna # SR_Isis_EON_012 # Added a method to create list EON Appointment Comms test data and Added fields in EON Appointment test data.
CH21 #11/04/2016 #Shruti Moghe # SR_EON_AL_005 # Added method to create records of EON Job Results Object.
CH22 # 11/04/2016 # Chandan K # Removed Assisted_Work_Indicator__c and Ladder_Required_Indicator__c deleted field reference.
CH23 # 13/04/2016 # EON_PC_030 # Nitin # Changed the value of the field Code__c to two characters, as per the modification of the field length in the SR.
CH24 # 14/014/2016 # # Nitin # Added method createEonOFSCResponseCode(), to create test record of EON_OFSC_Response_Code__c object.
CH25 # 18/04/2016 # SR_EON_PC_028 # Aruna Manjari# Added a method to create EON_Complaint test data.
CH26 # 19/04/2016 # Mahadev # SR_EON_PC_040 # Updated field data type 
CH27 # 19/04/2016 # Mahadev # SR_EON_AB_022 # Create test records.
CH28 # 28/04/2016 # Tashika # SR_EON_Mobile_009 # Added method to return record of custom setting EON OFSC Photo Property.
CH29 # 04/05/2016 # Tashika # SR_EON_Scheduling_030 # Added method to return record of custom setting Eon_WorkZoneMapping and added field in eon technician.
CH30 # 10/05/2016 # PeddaReddeiah # SR_EON_AB_058 # Address_Type__c of value changed(Stevenage to S) .
CH31 # 16/05/2016 # Shivram Survase # SR_EON_PC_053 # Deleted 'Contact Media' field at 'EON Contact Media' object.
CH32 # SR_EON_AL_013  # 27/05/2016 #Mahadev J # field deletion of Year_Month_of_Manufacture_del__c
CH33 # SR_EON_AL_016 # 30/05/2016 # Tashika Gupta # Changed name field values to alpha characters , added method to create list EON order and EON Shutdown Day.
CH34 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c, added a method to create EON SSC object record 
CH35 # SR_EON_PC_058 # 03/06/2016 # Mahadev J # Added method createContactOutcome()
CH36 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
CH37 # SR_EON_AL_028 # 07/07/2016 # Vinod # Renamed Electric_Credit_Meter_Classic__c to E_Credit_Meter_SR_1R_0393_Classic__c
CH38 # SR_EON_AL_026 # 08/07/2016 # Vinod # changed Electric_Credit_Meter_Classic_BAU__c to E_Credit_Meter_SR_1R_0393_Classic_BAU__c
CH39 # SR_EON_AL_028 # 03/06/2016 # Aruna Manjari # Added asset type in method createEonProduct() and createEonTechnicianList()
CH40 # SR_EON_PC_067 # 03/06/2016 # Mahadev J # Added method createEONCampaign()
CH41 # SR_EON_AL_026 #06/07/2016 # Vinod #  Added asset type in method createEonStockList() and createEonTechnicianList().
CH42 # SR_EON_Jumbo_054 #10/08/2016 # Mahadev J # Created function createEONSscRegister()
CH44 # SR_EON_AB_130 # 22/09/2016 # Sivasankar K # adding the createEONAppointmentAttributes() method
CH45 # SR_EON_AL_037 #26/12/2016 # Vinod D # Deleted the field EON Holding Serialised Asset Unique ID
CH46 # SR_EON_PC_099 # 12/01/2017 # Mahadev J # Changed API names - Complainant_Preferred_contact_details__c
CH47 # SR_EON_PC_101 # 18/01/2017 # Aruna Manjari # Removed the field Customer_address__c and added new field   Address__c, City__c,Post_Code__c | Removed the field Complainant_Address__c and added new fields (Address_Complainant__c,City_Complainant__c,Post_Code_Complainant__c)
CH48 # # 05/01/2018 # Praveen G # Fiex for the new validation rule on technician object.
CH49 # 01/02/2018 #GunaSekhar P # Added stock_Profile__c mandatory field on technician object to overcome the validation.
CH50 # 30/03/2018 #Gunasekhar P # Added some new fields  
**/
@isTest
public class EON_CreateTestRecords {
    static testMethod void unitTest()
    {
    
    }
    //CH01.Start
    /**
    createEONCustomer() : This method will return the object instace of  EON_Customer__c object with data
    **/
    public static EON_Customer__c createEONCustomer() {
        return new EON_Customer__c ( Campaign_Flag__c = true,Current_Payment_Method_indicator__c = 'OD',//CH08//CH18
                                    Name='2345678901', Customer_group_type__c = 'SME',Customer_Name__c = 'EON Customer',PAYG_Flag__c = 'Y',PAYG_Interest__c = 'N'); //CH03,CH12,CH13
    }
    /**
    createEONPaygDeferralReason() : This method will return the object instace of  EON_PAYG_Deferral_Reasons__c object with data
    **/ 
    //CH15 START
    public static EON_PAYG_Deferral_Reason__c createEONPaygDeferralReason() {
        return new EON_PAYG_Deferral_Reason__c( Name = ' Deferral Note',DEFERRAL_REASON_CODE__c = 'MUSEON0213');
    }
    //CH15 END
    /**
    cereateEONSite() : This method will return the object instace of  EON_Site__c object with data
    **/
    public static EON_Site__c cereateEONSite(){
        EON_Customer__c customer =  createEONCustomer();
        insert customer;
        //CH17.Old Removed references for below deleted fields
        //S_Building_Name__c = 'Stevenage',S_Building_Number__c = 'Stevenage',S_Country__c = null,S_County__c = null,S_Dependant_locality__c = 'Stevenage',S_Dependant_thorofare__c = 'Stevenage',S_Double_dependant_locality__c = 'Stevenage',S_Postcode__c = 'SG1 2ST',S_Sub_building_name__c = 'Stevenage',S_Thorofare__c = 'Stevenage',S_Town__c = 'Stevenage'
        //Renamed below references - 
        //C_Building_Name__c = 'Able Smith House',C_Building_Number__c = '1324654',C_Address_type__c = 'Stevenage',C_Country__c = null ,C_County__c = null,C_Dependant_locality__c = 'Stevenage',C_Dependant_thorofare__c = 'Stevenage',C_Double_dependant_locality__c = 'Stevenage',C_Postcode__c = 'SG1 2ST',C_Sub_building_name__c = 'Stevenage',C_Thorofare__c = 'Stevenage',C_Town__c = 'Stevenage'
    //CH30.START
        return new EON_Site__c(Customer__c=customer.ID, Name = '1234567890',Building_Name__c = 'Able Smith House',Building_Number__c = '1324654',Address_Type__c = 'S',Country__c = null ,County__c = null,Dependant_Locality__c = 'Stevenage',Dependant_Thorofare__c = 'Stevenage',Double_Dependant_Locality__c = 'Stevenage',Postcode__c = 'SG1 2ST',Sub_Building_Name__c = 'Stevenage',Thorofare__c = 'Stevenage',Town__c = 'Stevenage');//CH03, CH17
    //CH30.END
    }
    
    /**
    createEONFuel() : This method will return the object instace of  EON_Fuel__c object with data
    **/
    public static EON_Fuel__c createEONFuel() {
        return new EON_Fuel__c (Electric_meter_location__c = null, Electric_meter_serial_number__c = '12365464',Premise__c = null,E_Fuel__c = false
                                ,E_3_Phase_Meter__c = false,E_Account_Issues__c = false,E_Age_UK__c = false,E_Already_selected_for_SMART_Follow_up__c = false,E_Already_selected_for_SMART_No_follow__c = false, E_Already_Smart__c = false, E_Business_Energy_Manager_BEM__c = false, E_Change_Of_Supply_in_Progress__c = false, E_Change_Of_Tenancy_in_Progress__c = false, E_Change_to_Switching_Times__c = false, E_Commercial_Developer__c = false, E_Complaint__c = false, E_Complex_Metering1__c = false, E_Complex_Metering2__c = false, E_Complex_Metering3__c = false, E_De_energised__c = false, E_Flat_or_Apartment__c = false,  E_Incorrect_sector__c = false, E_Independent_Gas_Transporter__c = false, E_Maximum_Demand_Customer1__c = false, E_Maximum_Demand_Customer2__c = false, E_Micro_generation__c = false, E_Multi_site__c = false, E_Non_E_ON_MOP__c = false, E_Not_Business_product__c = false, E_Outstanding_Balance__c = false, E_Out_of_Area__c = false, E_Possible_Site_Issues1__c = false, E_Pre_payment_Customer__c = false, E_Self_build_Developer__c = false, E_Shared_Supply__c = false, E_Single_Gas_Customer__c = false, E_Smart_Appointment_Already_Booked__c = false, E_SME_premise_has_gas__c = false, E_Stay_warm__c = false, E_Third_Party_Intermediate_TPI__c = false, E_Unbillable__c = false, E_Unsupported_Switching_Times__c = false, E_Vulnerable__c = false,Fuel_type__c = 'G', Gas_Map_identifier__c = 'test', Gas_meter_location__c = null, Gas_meter_serial_number__c = 'MUSEONTest',G_3_Phase_Meter__c = false, G_Account_Issues__c = false, G_Age_UK__c = false, G_Already_selected_for_SMART_Follow_up__c = false,Gas_Meter_Mechanism__c = null, //CH08
                                G_Already_selected_for_SMART_No_follow__c = false, G_Already_Smart__c = false, G_Business_Energy_Manager_BEM__c = false, G_Change_Of_Supply_in_Progress__c = false, G_Change_Of_Tenancy_in_Progress__c = false, G_Change_to_Switching_Times__c = false, G_Commercial_Developer__c = false, G_Complaint__c = false, G_Complex_Metering1__c = false, G_Complex_Metering2__c = false, G_Complex_Metering3__c = false, G_De_energised__c = false, G_Flat_or_Apartment__c = false, G_Incorrect_sector__c = false, G_Independent_Gas_Transporter__c = false, G_Maximum_Demand_Customer1__c = false, G_Maximum_Demand_Customer2__c = false, G_Micro_generation__c = false, G_Multi_site__c = false, G_Non_E_ON_MOP__c = false, G_Not_Business_product__c = false, G_Outstanding_Balance__c = false, G_Out_of_Area__c = false, G_Possible_Site_Issues1__c = false, G_Pre_payment_Customer__c = false, G_Recent_meter_exchange__c = false, G_Self_build_Developer__c = false, G_Single_Gas_Customer__c = false, G_Smart_Appointment_Already_Booked__c = false, G_SME_premise_has_gas__c = false, G_Stay_warm__c = false, G_Third_Party_Intermediate_TPI__c = false, G_Unbillable__c = false, G_Unsupported_Switching_Times__c = false, G_Vulnerable__c = false, MPAN__c = 'Test',MPRN__c = 'TEst');//CH03
            
    }
    
    /**
    createEONGasMeterLocation() : This method will return the object instace of  EON_Gas_Meter_Location__c object with data
    **/
    public static EON_Gas_Meter_Location__c createEONGasMeterLocation() {
        return new EON_Gas_Meter_Location__c(Name = 'Bathroom',Code__c ='AB'); //CH11
    }
   
    
    
    /**
    createEONCurrentPaymentMethod() : This method will return the object instace of  EON_Current_Payment_Method__c object with data
    **/
    public static EON_Current_Payment_Method__c createEONCurrentPaymentMethod(){
        return new EON_Current_Payment_Method__c(Name = 'Not OD',Code__c = 0);
    }
    
    /**
    createEONOpOutReason() : This method will return the object instace of  EON_Opt_Out_Reason__c object with data
    **/
    //CH14.Start
     public static EON_Opt_Out_Reason__c createEONOpOutReason()
     {
        return new EON_Opt_Out_Reason__c (Name = 'PERMANENT – Data Privacy Concerns',Reason_Code__c = 2 );
     }
    //CH14.End
    
    //CH01.End
    
    /**
    createEONAppointment() : This method will return the object instace of  EON_Appointment__c object with data
    **/
    public static EON_Appointment__c createEONAppointment(){
        //CH34.start
        EON_SSC__c ssc = createEON_SSC();
        insert ssc;
        //CH34.end
        return new EON_Appointment__c( Abort_Reason__c = null, Cancel_Reason__c = null, Booking_System_Name__c = 'Test1', Access_Pass_Phrase__c = 'Test2', 
        Appointment_Date__c = system.today(),Assisted_Work_Reason_Code__c = 'Test3',
                                     Building_Name__c = 'Test4',Building_Number__c = 'Test5',Caller_Name__c = 'Test6',Complete_DateTime__c = null, Confirmed_Appointment_DateTime__c = null, Contact_Number__c = 1234568742,
                                     County__c = 'India',Country__c = 'Test7',Dependant_Locality__c = 'Test9',Dependent_Thorofare__c = 'Test10',Double_dependant_Locality__c = 'Test11',Elec_Daily_Data_Opted__c = false,
                                     Elec_HH_Data_Opted__c = false,EON_Appointment_ID__c = '12345',En_Route_DateTime__c = null, Gas_Daily_Data_Opted__c = false,
                                     Gas_HH_Data_Opted__c = false,
                                     MPAN__c = '123456987',MPRN__c = '123456789',Notes__c = 'Test14',Onsite_DateTime__c = null, Suspended_DateTime__c = null,Technician__c = Null,Person_Name__c = 'Test15',Post_Code__c = 'Test16',
                                     Sub_Building_Name__c = 'Test17',Thorofare__c = 'Test18',Time_Slot__c = 'Test19',Post_Town__c = 'Test19',Status__c = null,Requested_SSC__c = '4412'//CH34.old
                                     //,Requested_SSC__c=ssc.id//CH36.old
                                     ); //CH04.Change //CH20//CH34
    }
    
    /**
    createEONAppointment() : This method will return the object instace of  EON_Appointment_Abort_reason__c object with data
    **/
    public static EON_Appointment_Abort_reason__c createEONAppAbortReason() {
        return new EON_Appointment_Abort_reason__c ( Name = 'User is not willing to install',Reason_key__c = 'Not Intrested',Abort_DateTime__c = System.now());
    }
    
    /**
    createEONAppCancelReason() : This method will return the object instace of  EON_Appointment_Cancel_Reason__c object with data
    **/
    public static EON_Appointment_Cancel_Reason__c createEONAppCancelReason() {
        return new EON_Appointment_Cancel_Reason__c ( Name = 'User is not willing to install',Reason_key__c = 'CUST_NOREASON');//CH16
    }
    
    /**
    createEONEleMeterLocation() : This method will return the object instace of EON_Electric_Meter_Location__c object with data
    **/
    public static EON_Electric_Meter_Location__c createEONEleMeterLocation() {
        return new EON_Electric_Meter_Location__c ( Name = 'Bathroom',Code__c = 'EL');
    }
    
    /**
    createEONGasMeterMechanism() : This method will return the object instace of  EON_Gas_Meter_Mechanism__c object with data
    **/
   public static EON_Gas_Meter_Mechanism__c createEONGasMeterMechanism() {
        return new EON_Gas_Meter_Mechanism__c ( Name = 'London Gas',Code__c = 'G1');    //CH23
    }
    
    /**
    createEONJob() : This method will return the object instace of  EON_Job__c object with data
    **/
    public static EON_Job__c createEONJob() {
        return new EON_Job__c ( Name='EON Job',Description__c='EON Job Test',Duration__c = 203, Jumbo_Job_Code__c='WERTYYUUWAS');
    }
    
    /**
    createEONParking() : This method will return the object instace of  EON_Parking__c object with data
    **/
    public static EON_Parking__c createEONParking() {
        return new EON_Parking__c ( Name='EON Parking',Parking_Code__c='2');
    }
    
    /**
    createEONTechnician() : This method will return the object instace of  EON_Technician__c object with data
    **/
    public static EON_Technician__c createEONTechnician() {
    //CH49.Start
        EON_Product__c product = new EON_Product__c();
        product.Active__c=true;
        insert product;
        
        EON_Stock_Profile__c profile = new EON_Stock_Profile__c();
        //Generating a Unique Profile name 
        profile.name = string.valueOf(crypto.getRandomLong()).replace('-','')+String.valueof(DateTime.now()).deleteWhitespace().replace('-','').replace(':','');
        insert profile;        
        
        Profile_Product__c profileProduct = new Profile_Product__c();
        profileProduct.Product__c = product.id;
        profileProduct.Stock_Profile__c = profile.id;
        insert profileProduct;
        //CH49.End
        return new EON_Technician__c ( stock_Profile__c = profile.id,Name = 'TechnicianTest',Date_Left__c = Date.today().addDays(360),//Date_Started__c = Date.today()//CH07.old
        Start_Date__c=Date.today(),Email__c = 'test@gmail.com',Mobile__c = '123456875',/*X3_Phase_Electric_Meter__c=20,*/ E_Credit_Meter_SR_1R_0393_Classic__c=10,/*Electric_Prepayment_Meter_Classic__c=10,Fuses_Electric__c=10,*/Gas_Credit_Meter_Classic__c=20,/*Gas_Prepayment_Meter_Classic__c=10,*/ h_Order_Sent__c=true,h_Send_to_CEVA__c=system.today(),Initial_Stock_Pickup_Location__c='pune',/*Isolators_Electric__c=10,*/ Regulators_Gas__c=10, Smart_Electric_Meter__c=5,Smart_Energy_Display_SED_IHD__c=10,Smart_Gas_Meter__c=10,Work_Zone__c='London South East',Sent_to_OFS__c=null); //CH02 //CH07.new //CH10//CH29
    }
    
    /**
    createContractNumber() : This method will return the object instace of Contract_Number__c object with data
    **/ //CH05.Start 
    public static Contract_Number__c createContractNumber() {
        return new Contract_Number__c ( Name = 'Contract Number Test',Contract_Client_Short_Name__c= 'EON',Start_Date__c= date.newInstance(2016,02,01),End_Date__c=date.newInstance(2016,02,28)); //    
    }  //CH05.End

    //CH06.START
    /**
    createServiceStatus() : This method will return the object instace of EON_Service_Status__c object with data
    **/
    public static EON_Service_Status__c createServiceStatus(String typeString,String statusString,String msgString) {
        return new EON_Service_Status__c ( Type__c = typeString, Status__c = statusString, Message__c = msgString);
    }
    //CH06.END
    
    //CH09.Start
    /**
        createEonAppointmentvalue() - This method to create Appointment Value record.
    **/
    public static EON_Appointment_Value__c createEonAppointmentvalue(){
        return new EON_Appointment_Value__c (Value__c = 20.5);
    }
    //CH09.End
    
    //CH07.Start
    /**
        createEonProduct() - This method to create List of Eon Products with dofferent Asset type values.
    **/
     public static List<EON_Product__c> createEonProduct(){
        List<String> AssetType= new List<String>{'Gas Credit Meter (Classic)','Gas Prepayment Meter (Classic)', 'Electric Credit Meter (Classic)',' Electric Prepayment Meter (Classic)','Smart Gas Meter', 'Smart Electric Meter', 'Smart Energy Display (SED / IHD)', 'Regulators (Gas)','3 Phase Electric Meter', 'Isolators (Electric)', 'Fuses (Electric)','E Credit Meter SR 1R 0393 (Classic)','E Credit Meter 5 Term 0151 (Classic)','E Credit Meter 4 Term  0151 (Classic)','E PP 1R 4 Term with Key 0393 (Classic)','E PP 1R 4 Term No Key 0393 (Classic)','E PP 2R 5 Term with Key 0151 (Classic)','E PP 2R 5 Term No Key 0151 (Classic)','Smart Electric Meter (New Connections)','3 Phase E Meter 0151','3 Phase E Meter 0393','Gas Credit Meter Semi Con (Classic)','Gas PP Meter G4 ETM (Classic)','Gas PP Libre 210 Domestic (Classic)','Smart Gas Meter Semi Con','E Credit Meter 4 Term 0151 (Classic)','E Credit Meter 4 Term 0244 (Classic)','E Credit Meter 4 Term 0935 (Classic)','E Credit Meter 5 Term 0244 (Classic)','E Credit Meter 5 Term 0935 (Classic)','Smart Gas Meter (New Connections)','Regulators (SC Gas)'};//CH39
        List<EON_Product__c> lstProducts = new List<EON_Product__c>();
        Integer i=0;
        For(String Asset :AssetType ){
            i=1;
            EON_Product__c product = new EON_Product__c();
            product.Name= 'Test'+i;
            product.Asset_Type__c=Asset;
            product.Product_Description__c='testing';
            lstProducts.add(product);
            i++;
        } 
        return lstProducts;
    }
    /**
       createEonTechnicianList() - This method to create List of Eon Technicians.
    **/
    public static List<EON_Technician__c> createEonTechnicianList(){
       //CH49.Starts
        List<EON_Technician__c> lstTechnicians= new List<EON_Technician__c>();
        EON_Product__c product = new EON_Product__c();
        product.Active__c=true;
        product.Name='tests';
        
        insert product;
        EON_Product__c product1 = new EON_Product__c();
        product1.Active__c=true;
        product1.Name='tests';
        insert product1;
        product.Linked_Product__c=product1.id;//CH50
        update product;
        
        EON_Stock_Profile__c profile = new EON_Stock_Profile__c();
        //Generating a Unique Profile name 
        profile.name = string.valueOf(crypto.getRandomLong()).replace('-','')+String.valueof(DateTime.now()).deleteWhitespace().replace('-','').replace(':','');
        insert profile;        
        //insert profile;        
        
        Profile_Product__c profileProduct = new Profile_Product__c();
        profileProduct.Product__c = product.id;
        profileProduct.Stock_Profile__c = profile.id;
        profileProduct.Max_Level__c=5;//CH50
        profileProduct.BAU_Trigger_Level__c=2;//CH50
        insert profileProduct;
       //CH49.Ends
       //CH33.Start
       EON_Technician__c Tech1= new EON_Technician__c ( stock_Profile__c = profile.id, Name = 'Tech tashika',Date_left__c=null,h_IsProcessed__c=False,Start_Date__c=Date.today(),Email__c = 'test@gmail.com',Mobile__c = '123456875',/*X3_Phase_Electric_Meter__c=20,*/ E_Credit_Meter_SR_1R_0393_Classic__c=10,/*Electric_Prepayment_Meter_Classic__c=10,Fuses_Electric__c=10,*/Gas_Credit_Meter_Classic__c=20,/*Gas_Prepayment_Meter_Classic__c=10,*/h_Order_Sent__c=true,h_Send_to_CEVA__c=system.today(),Initial_Stock_Pickup_Location__c='pune',/*Isolators_Electric__c=10,*/Regulators_Gas__c=10, Smart_Electric_Meter__c=5,Smart_Energy_Display_SED_IHD__c=10,Smart_Gas_Meter__c=10,/*X3_Phase_Electric_Meter_BAU__c=10,*/E_Credit_Meter_SR_1R_0393_Classic_BAU__c=10,/*Electric_Prepayment_Meter_Classic_BAU__c=10,Fuses_Electric_BAU__c=10,*/Gas_Credit_Meter_Classic_BAU__c=10,/*Gas_Prepayment_Meter_Classic_BAU__c=10,Isolators_Electric_BAU__c=10,*/Regulators_Gas_BAU__c=10,Smart_Electric_Meter_BAU__c=10,Smart_Energy_Display_SED_IHD_BAU__c=10,Smart_Gas_Meter_BAU__c=10,Training_Start_Date__c=system.today(),E_Credit_Meter_5_Term_0151_Classic__c=6,E_Credit_Meter_4_Term_0151_Classic__c=6,E_PP_1R_4_Term_with_Key_0393_Classic__c=6,E_PP_1R_4_Term_No_Key_0393_Classic__c=6,E_PP_2R_5_Term_with_Key_0151_Classic__c=6,E_PP_2R_5_Term_No_Key_0151_Classic__c=6,Smart_Electric_Meter_New_Connections__c=6,X3_Phase_E_Meter_0151__c=6,X3_Phase_E_Meter_0393__c=6,Gas_PP_Meter_G4_ETM_Classic__c=6,Gas_PP_Libre_210_Domestic_Classic__c=6,Smart_Gas_Meter_Semi_Con__c=6,Gas_Credit_Meter_Semi_Con_Classic__c=7,E_Credit_Meter_5_Term_0151_Classic_BAU__c=4,E_Credit_Meter_4_Term_0151_Classic_BAU__c=4,E_PP_1R_4_Term_with_Key_0393_Classic_BAU__c=4,E_PP_1R_4_Term_No_Key_0393_Classic_BAU__c=4,E_PP_2R_5_Term_with_Key_0151_Classic_BAU__c=4,E_PP_2R_5_Term_No_Key_0151_Classic_BAU__c=4,Smart_Electric_Meter_New_Connections_BAU__c=4,X3_Phase_E_Meter_0151_BAU__c=4,X3_Phase_E_Meter_0393_BAU__c=4,Gas_Credit_Meter_Semi_Con_Classic_BAU__c=4,Gas_PP_Meter_G4_ETM_Classic_BAU__c=4,Gas_PP_Libre_210_Domestic_Classic_BAU__c=4,Smart_Gas_Meter_Semi_Con_BAU__c=4,E_Credit_Meter_4_Term_0244_Classic__c= 30,E_Credit_Meter_5_Term_0244_Classic__c= 32,E_Credit_Meter_4_Term_0935_Classic__c= 31,E_Credit_Meter_5_Term_0935_Classic__c= 33,Regulators_SC_Gas__c= 35,Smart_Gas_Meter_New_Connections__c= 34,E_Credit_Meter_4_Term_0244_Classic_BAU__c=10,E_Credit_Meter_5_Term_0244_Classic_BAU__c=12,E_Credit_Meter_4_Term_0935_Classic_BAU__c=11,E_Credit_Meter_5_Term_0935_Classic_BAU__c=13,Smart_Gas_Meter_New_Connections_BAU__c=15,Regulators_SC_Gas_BAU__c=14);//CH19;//CH39//CH41 
       EON_Technician__c Tech2= new EON_Technician__c ( stock_Profile__c = profile.id, Name = 'Tech nitin',Date_left__c=null,h_IsProcessed__c=False,Start_Date__c=Date.today(),Email__c = 'test@gmail.com',Mobile__c = '123456875',/*X3_Phase_Electric_Meter__c=20,*/ E_Credit_Meter_SR_1R_0393_Classic__c=10,/*Electric_Prepayment_Meter_Classic__c=10,Fuses_Electric__c=10,*/Gas_Credit_Meter_Classic__c=20,/*Gas_Prepayment_Meter_Classic__c=10,*/h_Order_Sent__c=true,h_Send_to_CEVA__c=system.today(),Initial_Stock_Pickup_Location__c='pune',/*Isolators_Electric__c=10,*/Regulators_Gas__c=10, Smart_Electric_Meter__c=5,Smart_Energy_Display_SED_IHD__c=10,Smart_Gas_Meter__c=10,/*X3_Phase_Electric_Meter_BAU__c=10,*/E_Credit_Meter_SR_1R_0393_Classic_BAU__c=10,/*Electric_Prepayment_Meter_Classic_BAU__c=10,Fuses_Electric_BAU__c=10,*/Gas_Credit_Meter_Classic_BAU__c=10,/*Gas_Prepayment_Meter_Classic_BAU__c=10,Isolators_Electric_BAU__c=10,*/Regulators_Gas_BAU__c=10,Smart_Electric_Meter_BAU__c=10,Smart_Energy_Display_SED_IHD_BAU__c=10,Smart_Gas_Meter_BAU__c=10,Training_Start_Date__c=system.today(),E_Credit_Meter_5_Term_0151_Classic__c=6,E_Credit_Meter_4_Term_0151_Classic__c=6,E_PP_1R_4_Term_with_Key_0393_Classic__c=6,E_PP_1R_4_Term_No_Key_0393_Classic__c=6,E_PP_2R_5_Term_with_Key_0151_Classic__c=6,E_PP_2R_5_Term_No_Key_0151_Classic__c=6,Smart_Electric_Meter_New_Connections__c=6,X3_Phase_E_Meter_0151__c=6,X3_Phase_E_Meter_0393__c=6,Gas_PP_Meter_G4_ETM_Classic__c=6,Gas_PP_Libre_210_Domestic_Classic__c=6,Smart_Gas_Meter_Semi_Con__c=6,Gas_Credit_Meter_Semi_Con_Classic__c=7,E_Credit_Meter_5_Term_0151_Classic_BAU__c=4,E_Credit_Meter_4_Term_0151_Classic_BAU__c=4,E_PP_1R_4_Term_with_Key_0393_Classic_BAU__c=4,E_PP_1R_4_Term_No_Key_0393_Classic_BAU__c=4,E_PP_2R_5_Term_with_Key_0151_Classic_BAU__c=4,E_PP_2R_5_Term_No_Key_0151_Classic_BAU__c=4,Smart_Electric_Meter_New_Connections_BAU__c=4,X3_Phase_E_Meter_0151_BAU__c=4,X3_Phase_E_Meter_0393_BAU__c=4,Gas_Credit_Meter_Semi_Con_Classic_BAU__c=4,Gas_PP_Meter_G4_ETM_Classic_BAU__c=4,Gas_PP_Libre_210_Domestic_Classic_BAU__c=4,Smart_Gas_Meter_Semi_Con_BAU__c=4,E_Credit_Meter_4_Term_0244_Classic__c= 30,E_Credit_Meter_5_Term_0244_Classic__c= 32,E_Credit_Meter_4_Term_0935_Classic__c= 31,E_Credit_Meter_5_Term_0935_Classic__c= 33,Regulators_SC_Gas__c= 35,Smart_Gas_Meter_New_Connections__c= 34,E_Credit_Meter_4_Term_0244_Classic_BAU__c=10,E_Credit_Meter_5_Term_0244_Classic_BAU__c=12,E_Credit_Meter_4_Term_0935_Classic_BAU__c=11,E_Credit_Meter_5_Term_0935_Classic_BAU__c=13,Smart_Gas_Meter_New_Connections_BAU__c=15,Regulators_SC_Gas_BAU__c=14);//CH19;//CH39//CH41
       EON_Technician__c Tech3= new EON_Technician__c (  stock_Profile__c = profile.id,Name = 'Tech shruti',Date_left__c=null,h_IsProcessed__c=False,Start_Date__c=Date.today(),Email__c = 'test@gmail.com',Mobile__c = '123456875',/*X3_Phase_Electric_Meter__c=20,*/ E_Credit_Meter_SR_1R_0393_Classic__c=10,/*Electric_Prepayment_Meter_Classic__c=10,Fuses_Electric__c=10,*/Gas_Credit_Meter_Classic__c=20,/*Gas_Prepayment_Meter_Classic__c=10,*/h_Order_Sent__c=true,h_Send_to_CEVA__c=system.today(),Initial_Stock_Pickup_Location__c='pune',/*Isolators_Electric__c=10,*/Regulators_Gas__c=10, Smart_Electric_Meter__c=5,Smart_Energy_Display_SED_IHD__c=10,Smart_Gas_Meter__c=10,/*X3_Phase_Electric_Meter_BAU__c=10,*/E_Credit_Meter_SR_1R_0393_Classic_BAU__c=10,/*Electric_Prepayment_Meter_Classic_BAU__c=10,Fuses_Electric_BAU__c=10,*/Gas_Credit_Meter_Classic_BAU__c=10,/*Gas_Prepayment_Meter_Classic_BAU__c=10,Isolators_Electric_BAU__c=10,*/Regulators_Gas_BAU__c=10,Smart_Electric_Meter_BAU__c=10,Smart_Energy_Display_SED_IHD_BAU__c=10,Smart_Gas_Meter_BAU__c=10,Training_Start_Date__c=system.today(),E_Credit_Meter_5_Term_0151_Classic__c=6,E_Credit_Meter_4_Term_0151_Classic__c=6,E_PP_1R_4_Term_with_Key_0393_Classic__c=6,E_PP_1R_4_Term_No_Key_0393_Classic__c=6,E_PP_2R_5_Term_with_Key_0151_Classic__c=6,E_PP_2R_5_Term_No_Key_0151_Classic__c=6,Smart_Electric_Meter_New_Connections__c=6,X3_Phase_E_Meter_0151__c=6,X3_Phase_E_Meter_0393__c=6,Gas_PP_Meter_G4_ETM_Classic__c=6,Gas_PP_Libre_210_Domestic_Classic__c=6,Smart_Gas_Meter_Semi_Con__c=6,Gas_Credit_Meter_Semi_Con_Classic__c=7,E_Credit_Meter_5_Term_0151_Classic_BAU__c=4,E_Credit_Meter_4_Term_0151_Classic_BAU__c=4,E_PP_1R_4_Term_with_Key_0393_Classic_BAU__c=4,E_PP_1R_4_Term_No_Key_0393_Classic_BAU__c=4,E_PP_2R_5_Term_with_Key_0151_Classic_BAU__c=4,E_PP_2R_5_Term_No_Key_0151_Classic_BAU__c=4,Smart_Electric_Meter_New_Connections_BAU__c=4,X3_Phase_E_Meter_0151_BAU__c=4,X3_Phase_E_Meter_0393_BAU__c=4,Gas_Credit_Meter_Semi_Con_Classic_BAU__c=4,Gas_PP_Meter_G4_ETM_Classic_BAU__c=4,Gas_PP_Libre_210_Domestic_Classic_BAU__c=4,Smart_Gas_Meter_Semi_Con_BAU__c=4,E_Credit_Meter_4_Term_0244_Classic__c= 30,E_Credit_Meter_5_Term_0244_Classic__c= 32,E_Credit_Meter_4_Term_0935_Classic__c= 31,E_Credit_Meter_5_Term_0935_Classic__c= 33,Regulators_SC_Gas__c= 35,Smart_Gas_Meter_New_Connections__c= 34,E_Credit_Meter_4_Term_0244_Classic_BAU__c=10,E_Credit_Meter_5_Term_0244_Classic_BAU__c=12,E_Credit_Meter_4_Term_0935_Classic_BAU__c=11,E_Credit_Meter_5_Term_0935_Classic_BAU__c=13,Smart_Gas_Meter_New_Connections_BAU__c=15,Regulators_SC_Gas_BAU__c=14);//CH19;//CH39//CH41
       EON_Technician__c Tech4= new EON_Technician__c ( stock_Profile__c = profile.id, Name = 'Tech rango',Date_left__c=null,h_IsProcessed__c=False,Start_Date__c=Date.today(),Email__c = 'test@gmail.com',Mobile__c = '123456875',/*X3_Phase_Electric_Meter__c=20,*/ E_Credit_Meter_SR_1R_0393_Classic__c=10,/*Electric_Prepayment_Meter_Classic__c=10,Fuses_Electric__c=10,*/Gas_Credit_Meter_Classic__c=20,/*Gas_Prepayment_Meter_Classic__c=10,*/h_Order_Sent__c=true,h_Send_to_CEVA__c=system.today(),Initial_Stock_Pickup_Location__c='pune',/*Isolators_Electric__c=10,*/Regulators_Gas__c=10, Smart_Electric_Meter__c=5,Smart_Energy_Display_SED_IHD__c=10,Smart_Gas_Meter__c=10,/*X3_Phase_Electric_Meter_BAU__c=10,*/E_Credit_Meter_SR_1R_0393_Classic_BAU__c=10,/*Electric_Prepayment_Meter_Classic_BAU__c=10,Fuses_Electric_BAU__c=10,*/Gas_Credit_Meter_Classic_BAU__c=10,/*Gas_Prepayment_Meter_Classic_BAU__c=10,Isolators_Electric_BAU__c=10,*/Regulators_Gas_BAU__c=10,Smart_Electric_Meter_BAU__c=10,Smart_Energy_Display_SED_IHD_BAU__c=10,Smart_Gas_Meter_BAU__c=10,Training_Start_Date__c=system.today(),E_Credit_Meter_5_Term_0151_Classic__c=6,E_Credit_Meter_4_Term_0151_Classic__c=6,E_PP_1R_4_Term_with_Key_0393_Classic__c=6,E_PP_1R_4_Term_No_Key_0393_Classic__c=6,E_PP_2R_5_Term_with_Key_0151_Classic__c=6,E_PP_2R_5_Term_No_Key_0151_Classic__c=6,Smart_Electric_Meter_New_Connections__c=6,X3_Phase_E_Meter_0151__c=6,X3_Phase_E_Meter_0393__c=6,Gas_PP_Meter_G4_ETM_Classic__c=6,Gas_PP_Libre_210_Domestic_Classic__c=6,Smart_Gas_Meter_Semi_Con__c=6,Gas_Credit_Meter_Semi_Con_Classic__c=7,E_Credit_Meter_5_Term_0151_Classic_BAU__c=4,E_Credit_Meter_4_Term_0151_Classic_BAU__c=4,E_PP_1R_4_Term_with_Key_0393_Classic_BAU__c=4,E_PP_1R_4_Term_No_Key_0393_Classic_BAU__c=4,E_PP_2R_5_Term_with_Key_0151_Classic_BAU__c=4,E_PP_2R_5_Term_No_Key_0151_Classic_BAU__c=4,Smart_Electric_Meter_New_Connections_BAU__c=4,X3_Phase_E_Meter_0151_BAU__c=4,X3_Phase_E_Meter_0393_BAU__c=4,Gas_Credit_Meter_Semi_Con_Classic_BAU__c=4,Gas_PP_Meter_G4_ETM_Classic_BAU__c=4,Gas_PP_Libre_210_Domestic_Classic_BAU__c=4,Smart_Gas_Meter_Semi_Con_BAU__c=4,E_Credit_Meter_4_Term_0244_Classic__c= 30,E_Credit_Meter_5_Term_0244_Classic__c= 32,E_Credit_Meter_4_Term_0935_Classic__c= 31,E_Credit_Meter_5_Term_0935_Classic__c= 33,Regulators_SC_Gas__c= 35,Smart_Gas_Meter_New_Connections__c= 34,E_Credit_Meter_4_Term_0244_Classic_BAU__c=10,E_Credit_Meter_5_Term_0244_Classic_BAU__c=12,E_Credit_Meter_4_Term_0935_Classic_BAU__c=11,E_Credit_Meter_5_Term_0935_Classic_BAU__c=13,Smart_Gas_Meter_New_Connections_BAU__c=15,Regulators_SC_Gas_BAU__c=14);//CH19;//CH39//CH41
       EON_Technician__c Tech5= new EON_Technician__c ( stock_Profile__c = profile.id, Name = 'Tech puneet',Date_left__c=null,h_IsProcessed__c=False,Start_Date__c=Date.today(),Email__c = 'test@gmail.com',Mobile__c = '123456875',/*X3_Phase_Electric_Meter__c=20,*/ E_Credit_Meter_SR_1R_0393_Classic__c=10,/*Electric_Prepayment_Meter_Classic__c=10,Fuses_Electric__c=10,*/Gas_Credit_Meter_Classic__c=20,/*Gas_Prepayment_Meter_Classic__c=10,*/h_Order_Sent__c=true,h_Send_to_CEVA__c=system.today(),Initial_Stock_Pickup_Location__c='pune',/*Isolators_Electric__c=10,*/Regulators_Gas__c=10, Smart_Electric_Meter__c=5,Smart_Energy_Display_SED_IHD__c=10,Smart_Gas_Meter__c=10,/*X3_Phase_Electric_Meter_BAU__c=10,*/E_Credit_Meter_SR_1R_0393_Classic_BAU__c=10,/*Electric_Prepayment_Meter_Classic_BAU__c=10,Fuses_Electric_BAU__c=10,*/Gas_Credit_Meter_Classic_BAU__c=10,/*Gas_Prepayment_Meter_Classic_BAU__c=10,Isolators_Electric_BAU__c=10,*/Regulators_Gas_BAU__c=10,Smart_Electric_Meter_BAU__c=10,Smart_Energy_Display_SED_IHD_BAU__c=10,Smart_Gas_Meter_BAU__c=10,Training_Start_Date__c=system.today(),E_Credit_Meter_5_Term_0151_Classic__c=6,E_Credit_Meter_4_Term_0151_Classic__c=6,E_PP_1R_4_Term_with_Key_0393_Classic__c=6,E_PP_1R_4_Term_No_Key_0393_Classic__c=6,E_PP_2R_5_Term_with_Key_0151_Classic__c=6,E_PP_2R_5_Term_No_Key_0151_Classic__c=6,Smart_Electric_Meter_New_Connections__c=6,X3_Phase_E_Meter_0151__c=6,X3_Phase_E_Meter_0393__c=6,Gas_PP_Meter_G4_ETM_Classic__c=6,Gas_PP_Libre_210_Domestic_Classic__c=6,Smart_Gas_Meter_Semi_Con__c=6,Gas_Credit_Meter_Semi_Con_Classic__c=7,E_Credit_Meter_5_Term_0151_Classic_BAU__c=4,E_Credit_Meter_4_Term_0151_Classic_BAU__c=4,E_PP_1R_4_Term_with_Key_0393_Classic_BAU__c=4,E_PP_1R_4_Term_No_Key_0393_Classic_BAU__c=4,E_PP_2R_5_Term_with_Key_0151_Classic_BAU__c=4,E_PP_2R_5_Term_No_Key_0151_Classic_BAU__c=4,Smart_Electric_Meter_New_Connections_BAU__c=4,X3_Phase_E_Meter_0151_BAU__c=4,X3_Phase_E_Meter_0393_BAU__c=4,Gas_Credit_Meter_Semi_Con_Classic_BAU__c=4,Gas_PP_Meter_G4_ETM_Classic_BAU__c=4,Gas_PP_Libre_210_Domestic_Classic_BAU__c=4,Smart_Gas_Meter_Semi_Con_BAU__c=4,E_Credit_Meter_4_Term_0244_Classic__c= 30,E_Credit_Meter_5_Term_0244_Classic__c= 32,E_Credit_Meter_4_Term_0935_Classic__c= 31,E_Credit_Meter_5_Term_0935_Classic__c= 33,Regulators_SC_Gas__c= 35,Smart_Gas_Meter_New_Connections__c= 34,E_Credit_Meter_4_Term_0244_Classic_BAU__c=10,E_Credit_Meter_5_Term_0244_Classic_BAU__c=12,E_Credit_Meter_4_Term_0935_Classic_BAU__c=11,E_Credit_Meter_5_Term_0935_Classic_BAU__c=13,Smart_Gas_Meter_New_Connections_BAU__c=15,Regulators_SC_Gas_BAU__c=14);//CH19;//CH39//CH41
       
       //CH33.End
       lstTechnicians.add(Tech1);
       lstTechnicians.add(Tech2);
       lstTechnicians.add(Tech3);
       lstTechnicians.add(Tech4);
       lstTechnicians.add(Tech5);
       return lstTechnicians;
    }
    //CH07.End 
    //CH12.New.Start
    public static EON_Complaint__c createEonComplaint(){
        return new EON_Complaint__c(Complainant_Name__c='Aalm',Customer_Name__c='Aalm',Preferred_Contact_Method__c ='TelePhone',TelePhone__c ='07466993698',
                                    Complaint_Received_By__c ='Voice', Complaint_Type__c ='Colleague Appearance',Complaint_status__c = 'Raised',Complaint_Category_Level_1__c = 'Other',
                                    Complaint_Description__c = 'test');
    }
    /**
    createEonSite() : This method will return the object instace of  EON_Site__c object with data
    **/
    public static EON_Site__c createEonSite()
    {
        /*EON_Customer__c customer = new EON_Customer__c ( Campaign_Flag__c = true,Current_Payment_Method_indicator__c = 'OD',
                                    Name='2345678902', Customer_group_type__c = 'SME',Customer_Name__c = 'EON Customer',PAYG_Flag__c = 'Y',PAYG_Interest__c = 'N'); */
        EON_Customer__c customer =  createEONCustomer();
        insert customer;
        return new EON_Site__c(Name='1234567890',Customer__c=customer.ID);
    }
    /**
    createContactMethod() : This method will return the object instace of  EON_Contact_Method__c object with data
    **/
    public static EON_Contact_Method__c createContactMethod()
    {
        return new EON_Contact_Method__c(Name='Test Method', Media_Type__c=4);
    }
    /**
    createEonFulfilment() : This method will return the object instace of  EON_Fulfillment__c object with data
    **/
    public static EON_Fulfillment__c createEonFulfilment()
    {
        return new EON_Fulfillment__c(Name='Test FUlfilment');
    }
    
    /**
    createEonServiceContactConsent() : This method will return the object instace of  EON_Service_Contact_Consent__c object with data
    **/
    public static EON_Service_Contact_Consent__c createEonServiceContactConsent()
    {
        //EON_Customer__c customer =  createEONCustomer();
        //insert customer;
        //return new EON_Service_Contact_Consent__c(Customer__c=customer.ID);
        return new EON_Service_Contact_Consent__c(); //CH40
    }
    /**
    createEONOptInOptOutPreference() : This method will return the object instace of  EON_Opt_in_Opt_Out_Preference__c object with data
    **/
    public static EON_Opt_in_Opt_Out_Preference__c createEonOptInOptOutPreference()
    {
        return new EON_Opt_in_Opt_Out_Preference__c();
     }
    /**
    createEONCounty() : This method will return the object instace of  EON_County__c object with data
    **/ 
    //CH15 START
    public static EON_County__c createEONCounty()
    {
        return new EON_County__c(Name='EON County');
    } 
    
    /**
    createEonCountry() : This method will return the object instace of  EON_Country__c object with data
    **/
    public static EON_Country__c createEonCountry()
    {
        return new EON_Country__c(Name='EON County');
    } 
    //CH15 END
    /**
    createEonContactRepresentative() : This method will return the object instace of  EON_Contact_representative__c object with data
    **/
    public static EON_Contact_representative__c createEonContactRepresentative()
    {
        EON_Customer__c customer =  createEONCustomer();
        insert customer;
        return new EON_Contact_representative__c(Name='1111', Customer__c=customer.id);
    }
     /**
    createEonContactMedia() : This method will return the object instace of  EON_Contact_Media__c object with data
    **/
    public static EON_Contact_Media__c createEonContactMedia()
    {
        EON_Customer__c customer =  createEONCustomer();
        insert customer;
        return new EON_Contact_media__c(Name='1256', Customer__c=customer.ID  );    //CH31 
    }
    
    /**
    createEonRoleTypeRepresntative() : This method will return the object instace of  EON_ROLE_TYPE_REPRESENTATIVE__c object with data
    **/
    public static EON_ROLE_TYPE_REPRESENTATIVE__c createEonRoleTypeRepresntative()
    {
        return new EON_ROLE_TYPE_REPRESENTATIVE__c(Name='Test Rep');
    }
    /**
    createEonSiteVulnerability() : This method will return the object instace of EON_Site_Vulnerability__c object with data
    **/
    public static EON_Site_Vulnerability__c createEonSiteVulnerability()
    {   
        return new EON_Site_Vulnerability__c();
     }
    //CH12.New.End
    
    //CH18.Start
    /**
    createEonFaultyAsset() : This method will return the object instace of EON_Faulty_Asset__c object with data
    **/
    public static EON_Faulty_Asset__c createEonFaultyAsset()
    {   
        EON_Appointment__c appointment = new EON_Appointment__c();
        insert appointment;
        return new EON_Faulty_Asset__c(Job_Reference__c=appointment.Id,Serial_Number_1__c='1234',Serial_Number_2__c='4123',Serial_Number_3__c='4125',Serial_Number_4__c='4126');
    }
    /**
    createEonStock() : This method will return the object instance of EON_Stock__c object with data
    **/
    public static EON_Stock__c createEonStock()
    {   
        EON_Holding_Serialised_Assets__c hold = new EON_Holding_Serialised_Assets__c(Serial_Number__c='1234');
        insert hold;
        return new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',//Year_Month_of_Manufacture__c='test1234',//CH32
                        Asset_Type__c='4126test',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    }
    //CH18.End
    //CH19.Start
    /**
       createEonStockList() - This method to create List of Eon Stocks.
    **/
    public static List<EON_Stock__c> createEonStockList(){
    List<EON_Stock__c> lstStocks= new List<EON_Stock__c>();
    EON_Holding_Serialised_Assets__c hold = new EON_Holding_Serialised_Assets__c(Serial_Number__c='1234');
    insert hold;
    //CH32.start removed field Year_Month_of_Manufacture_del__c
    EON_Stock__c stock1 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Electric Credit Meter (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock2 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Electric Prepayment Meter (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock3 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Smart Electric Meter',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock4 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Smart Energy Display (SED / IHD)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock5 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='3 Phase Electric Meter',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock6 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Isolators (Electric)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock7 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Fuses (Electric)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock8 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Gas Credit Meter (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock9 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Gas Prepayment Meter (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock10 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Smart Gas Meter',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock11 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Regulators (Gas)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    //CH32.end
    //CH41.Start
    EON_Stock__c stock12 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E Credit Meter SR 1R 0393 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock13 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E Credit Meter 5 Term 0151 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock14 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E Credit Meter 4 Term  0151 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock15 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E PP 1R 4 Term with Key 0393 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock16 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E PP 1R 4 Term No Key 0393 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock17 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E PP 2R 5 Term with Key 0151 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock18 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E PP 2R 5 Term No Key 0151 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock19 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Smart Electric Meter (New Connections)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock20 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='3 Phase E Meter 0151',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock21 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='3 Phase E Meter 0393',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock22 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Gas Credit Meter (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock23 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Gas Credit Meter Semi Con (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock24 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Gas PP Meter G4 ETM (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock25 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Gas PP Libre 210 Domestic (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock26 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Smart Gas Meter Semi Con',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock27 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Regulators (Gas)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock28 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E Credit Meter 4 Term 0151 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock29 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E Credit Meter 4 Term 0244 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock30 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E Credit Meter 4 Term 0935 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock31 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E Credit Meter 5 Term 0244 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock32 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='E Credit Meter 5 Term 0935 (Classic)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock33 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Smart Gas Meter (New Connections)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
    EON_Stock__c stock34 = new EON_Stock__c(Serial_Number__c='1234',Manufacture__c='test',Model__c='test',Asset_Type__c='Regulators (SC Gas)',Product_Code__c='tests',Order_Reference__c='test',Date_of_Dispatch__c=system.today(),/* EON_Holding_Serialised_Asset_Unique_ID__c=hold.id, //CH45 */Status__c='On Van');
   //CH41.End
    lstStocks.add(stock1);
    lstStocks.add(stock2);
    lstStocks.add(stock3);
    lstStocks.add(stock4);
    lstStocks.add(stock5);
    lstStocks.add(stock6);
    lstStocks.add(stock7);
    lstStocks.add(stock8);
    lstStocks.add(stock9);
    lstStocks.add(stock10);
    lstStocks.add(stock11);
    //CH41.start
    lstStocks.add(stock12);
    lstStocks.add(stock13);
    lstStocks.add(stock14);
    lstStocks.add(stock15);
    lstStocks.add(stock16);
    lstStocks.add(stock17);
    lstStocks.add(stock18);
    lstStocks.add(stock19);
    lstStocks.add(stock20);
    lstStocks.add(stock21);
    lstStocks.add(stock22);
    lstStocks.add(stock23);
    lstStocks.add(stock24);
    lstStocks.add(stock25);
    lstStocks.add(stock26);
    lstStocks.add(stock27);
    lstStocks.add(stock28);
    lstStocks.add(stock29);lstStocks.add(stock30);lstStocks.add(stock31);lstStocks.add(stock32);lstStocks.add(stock33);lstStocks.add(stock34);
    return lstStocks;
    //CH41.End
    //CH19.End
    }
    //CH20.Start
    /**
    createEONAppointmentList() : This method will return the list of EON_Appointment_Comms__c object with data
    **/
    public static List<EON_Appointment__c> createEONAppointmentList(){
        List<EON_Appointment__c> listAppointment = new List<EON_Appointment__c>();
        EON_Technician__c tech= new EON_Technician__c(Name = 'Tech tashika',Start_Date__c=Date.today(),Email__c = 'test@gmail.com',Mobile__c = '',/*X3_Phase_Electric_Meter__c=20,*/ E_Credit_Meter_SR_1R_0393_Classic__c=10,/*Electric_Prepayment_Meter_Classic__c=10,Fuses_Electric__c=10,*/Gas_Credit_Meter_Classic__c=20,/*Gas_Prepayment_Meter_Classic__c=10,*/h_Order_Sent__c=true,h_Send_to_CEVA__c=system.today(),Initial_Stock_Pickup_Location__c='pune',/*Isolators_Electric__c=10,*/Regulators_Gas__c=10, Smart_Electric_Meter__c=5,Smart_Energy_Display_SED_IHD__c=10,Smart_Gas_Meter__c=10);//CH33
        insert tech;
        //CH34.start
        EON_SSC__c ssc = createEON_SSC();
        insert ssc;
        //CH34.end
        
        Eon_Appointment_Reason__c appReason = new Eon_Appointment_Reason__c();
        appReason.Appointment_reason_code__c = 'New Connections';
        insert appReason;
        
        EON_Appointment__c appointment1 = new EON_Appointment__c( Abort_Reason__c = null, Cancel_Reason__c = null, Booking_System_Name__c = 'Test1', Access_Pass_Phrase__c = 'Test2', 
        Appointment_Date__c = system.today()+1,Assisted_Work_Reason_Code__c = 'Test3',
                                     Building_Name__c = 'Test4',Building_Number__c = 'Test5',Caller_Name__c = 'Test6',Complete_DateTime__c = null, Confirmed_Appointment_DateTime__c = null, Contact_Number__c = 1234568742,
                                     County__c = 'India',Country__c = 'Test7',Dependant_Locality__c = 'Test9',Dependent_Thorofare__c = 'Test10',Double_dependant_Locality__c = 'Test11',Elec_Daily_Data_Opted__c = false,
                                     Elec_HH_Data_Opted__c = false,EON_Appointment_ID__c = '12345',En_Route_DateTime__c = null, Gas_Daily_Data_Opted__c = false,
                                     Gas_HH_Data_Opted__c = false,
                                     MPAN__c = 'Test12',MPRN__c = 'Test13',Notes__c = 'Test14',Onsite_DateTime__c = null, Suspended_DateTime__c = null,Technician__c = tech.id,Person_Name__c = 'Test15',Post_Code__c = 'Test16',
                                     Sub_Building_Name__c = 'Test17',Thorofare__c = 'Test18',Time_Slot__c = 'Test19',Post_Town__c = 'Test19',Status__c = null,//Requested_SSC__c = '4412',//CH34.old
                                     //Requested_SSC__c =ssc.id ,//CH36.old
                                     End_Time__c='23:00',Start_Time__c=null);//CH34
        EON_Appointment__c appointment2 = new EON_Appointment__c( Abort_Reason__c = null, Cancel_Reason__c = null, Booking_System_Name__c = 'Test1', Access_Pass_Phrase__c = 'Test2', 
        Appointment_Date__c = system.today()+1,Assisted_Work_Reason_Code__c = 'Test3',
                                     Building_Name__c = 'Test4',Building_Number__c = 'Test5',Caller_Name__c = 'Test6',Complete_DateTime__c = null, Confirmed_Appointment_DateTime__c = null, Contact_Number__c = 1234568742,
                                     County__c = 'India',Country__c = 'Test7',Dependant_Locality__c = 'Test9',Dependent_Thorofare__c = 'Test10',Double_dependant_Locality__c = 'Test11',Elec_Daily_Data_Opted__c = false,
                                     Elec_HH_Data_Opted__c = false,EON_Appointment_ID__c = '12345',En_Route_DateTime__c = null, Gas_Daily_Data_Opted__c = false,
                                     Gas_HH_Data_Opted__c = false,
                                     MPAN__c = 'Test12',MPRN__c = 'Test13',Notes__c = 'Test14',Onsite_DateTime__c = null, Suspended_DateTime__c = null,Technician__c = tech.id,Person_Name__c = 'Test15',Post_Code__c = 'Test16',
                                     Sub_Building_Name__c = 'Test17',Thorofare__c = 'Test18',Time_Slot__c = 'Test19',Post_Town__c = 'Test19',Status__c = null,Requested_SSC__c = '4412',//CH34.old
                                     //Requested_SSC__c =ssc.id ,//CH36.old
                                     End_Time__c='23:00',Start_Time__c='');//CH34
                                     
      
        EON_Appointment__c appointment3 = new EON_Appointment__c( Abort_Reason__c = null, Cancel_Reason__c = null, Booking_System_Name__c = 'Test1', Access_Pass_Phrase__c = 'Test2', 
        Appointment_Date__c = system.today()+1,Assisted_Work_Reason_Code__c = 'Test3',
                                     Building_Name__c = 'Test4',Building_Number__c = 'Test5',Caller_Name__c = 'Test6',Complete_DateTime__c = null, Confirmed_Appointment_DateTime__c = null, Contact_Number__c = 1234568742,
                                     County__c = 'India',Country__c = 'Test7',Dependant_Locality__c = 'Test9',Dependent_Thorofare__c = 'Test10',Double_dependant_Locality__c = 'Test11',Elec_Daily_Data_Opted__c = false,
                                     Elec_HH_Data_Opted__c = false,EON_Appointment_ID__c = '12345',En_Route_DateTime__c = null, Gas_Daily_Data_Opted__c = false,
                                     Gas_HH_Data_Opted__c = false,
                                     MPAN__c = 'Test12',MPRN__c = 'Test13',Notes__c = 'Test14',Onsite_DateTime__c = null, Suspended_DateTime__c = null,Technician__c = tech.id,Person_Name__c = 'Test15',Post_Code__c = 'Test16',
                                     Sub_Building_Name__c = 'Test17',Thorofare__c = 'Test18',Time_Slot__c = 'Test19',Post_Town__c = 'Test19',Status__c = null,Requested_SSC__c = '4412',GSP_Group_ID__c='_N', Appointment_reason_code__c=appReason.id, //CH34.old 
                                     //Requested_SSC__c =ssc.id ,//CH36.old
                                     End_Time__c='23:00',Start_Time__c='');//CH34                              
                                     
                                     
        EON_Appointment__c appointment0 = new EON_Appointment__c( Abort_Reason__c = null, Cancel_Reason__c = null, Booking_System_Name__c = 'Test1', Access_Pass_Phrase__c = 'Test2', 
        Appointment_Date__c = system.today()+1,Assisted_Work_Reason_Code__c = 'Test3',
                                     Building_Name__c = 'Test4',Building_Number__c = 'Test5',Caller_Name__c = 'Test6',Complete_DateTime__c = null, Confirmed_Appointment_DateTime__c = null, Contact_Number__c = 1234568742,
                                     County__c = 'India',Country__c = 'Test7',Dependant_Locality__c = 'Test9',Dependent_Thorofare__c = 'Test10',Double_dependant_Locality__c = 'Test11',Elec_Daily_Data_Opted__c = false,
                                     Elec_HH_Data_Opted__c = false,EON_Appointment_ID__c = '12345',En_Route_DateTime__c = null, Gas_Daily_Data_Opted__c = false,
                                     Gas_HH_Data_Opted__c = false,
                                     MPAN__c = 'Test12',MPRN__c = 'Test13',Notes__c = 'Test14',Onsite_DateTime__c = null, Suspended_DateTime__c = null,Technician__c = tech.id,Person_Name__c = 'Test15',Post_Code__c = 'Test16',
                                     Sub_Building_Name__c = 'Test17',Thorofare__c = 'Test18',Time_Slot__c = 'Test19',Post_Town__c = 'Test19',Status__c = null,Requested_SSC__c = '4412',GSP_Group_ID__c='_N', Appointment_reason_code__c=appReason.id, //CH34.old 
                                     //Requested_SSC__c =ssc.id ,//CH36.old
                                     End_Time__c='23:00',Start_Time__c='');//CH34
                                     
        listAppointment.add(appointment0);                             
        listAppointment.add(appointment1);
        listAppointment.add(appointment2);
        listAppointment.add(appointment3);
      
        return listAppointment;
    }
    /**
    createEonDeliveryMethodList() : This method will return the list of EON_Appointment_Comms__c object with data
    **/
    public static List<Eon_Delivery_Method__c> createEonDeliveryMethodList(){
        list<Eon_Delivery_Method__c> listdelivery = new list<Eon_Delivery_Method__c>();
        Eon_Delivery_Method__c delivery1 = new Eon_Delivery_Method__c(Name='1234567890',Code__c='Either N');
        Eon_Delivery_Method__c delivery2 = new Eon_Delivery_Method__c(Name='testNew',Code__c='Either N');
        Eon_Delivery_Method__c delivery3 = new Eon_Delivery_Method__c(Name='Test',Code__c='Either N');
        listdelivery.add(delivery1);
        listdelivery.add(delivery2);
        listdelivery.add(delivery3);
        return listdelivery; 
    }
    /**
    createEonAppointmentCommsList() : This method will return the list of EON_Appointment_Comms__c object with data
    **/
    public static List<EON_Appointment_Comms__c> createEonAppointmentCommsList()
    {   
        List<EON_Appointment_Comms__c> listAppointComms = new List<EON_Appointment_Comms__c>(); 
        
        EON_Appointment_Comms__c appointComm1 = new EON_Appointment_Comms__c(Comm_Type_Code__c='R');
        EON_Appointment_Comms__c appointComm2 = new EON_Appointment_Comms__c(Comm_Type_Code__c='R');
        EON_Appointment_Comms__c appointComm3 = new EON_Appointment_Comms__c(Comm_Type_Code__c='R');
        EON_Appointment_Comms__c appointComm4 = new EON_Appointment_Comms__c(Comm_Type_Code__c='R');
        listAppointComms.add(appointComm1);
        listAppointComms.add(appointComm2);
        listAppointComms.add(appointComm3);
        listAppointComms.add(appointComm4);
        return listAppointComms;
    }
    //CH20.End
    
    //CH21.start
    /**
    createEon_Job_Results() : This method will return the instance of EON_Job_Results with data
    **/
    public static EON_Job_Results__c createEon_Job_Results()
    {
         
        //CH48.Start
        EON_Product__c product = new EON_Product__c();
        product.Active__c=true;
        insert product;
        
        EON_Stock_Profile__c profile = new EON_Stock_Profile__c();
        profile.name = 'Test_Profile';
        insert profile;        
        
        Profile_Product__c profileProduct = new Profile_Product__c();
        profileProduct.Product__c = product.id;
        profileProduct.Stock_Profile__c = profile.id;
        insert profileProduct;
        
        //CH48.end
        
            
        EON_Technician__c tech=createEONTechnician();
        tech.stock_Profile__c = profile.id; //CH48
        insert tech;
        
        return new EON_Job_Results__c(Found_IHD_Serial_Number__c='1234',Found_Comms_Hub_Serial_Number__c='1234',New_IHD_Serial_Number__c='1234',New_Comms_Hub_Serial_Number__c='1234',New_Gas_Regulator_Serial_Number__c='1234',New_G_Meter_Serial_Number__c='1234',New_E_Meter_Serial_Number__c='1234',Removed_Gas_Regulator_Serial_Number__c='1234',Removed_G_Meter_Serial_Number__c='1234',E_Meter_Serial_Number__c ='123456',Removed_E_Meter_Serial_Number__c='Recall',Job_Status__c='Completed',Technician__c=tech.id);
    }
    //CH21.end

    //CH24.Start
    /**
    createEonOFSCResponseCode() : This method will return the object instace of  EON_OFSC_Response_Code__c object with data
    **/
    public static EON_OFSC_Response_Code__c createEonOFSCResponseCode()
    {
        return new EON_OFSC_Response_Code__c(Name='EON OFSC',Error_Warning_Success__c = 'Error',OFSC_Description_and_Solution__c = 'Description',OFSC_Text__c = 'OFSC',API__c='Activity');
    }
    //CH24.End
    
     //CH25.Start
    /**
    createEON_Complaint() : This method will return the object instace of  EON_Complaint__c object with data
    **/
    public static EON_Complaint__c createEON_Complaint(){
         Datetime cDT = System.now();
         EON_Appointment__c appointment =  createEONAppointment();
         insert appointment;
         EON_Customer__c  customer=   createEONCustomer();
         
         insert customer;
         return new EON_Complaint__c( Appointment__c = appointment.name, /*CH47 Complainant_Address__c = 'Test address' */ Address_Complainant__c= '12345', Post_Code_Complainant__c= '12345', City_Complainant__c= '12345' , Complainant_Name__c = 'Test Name', 
                                     Complainant_Post_Code__c ='code', Complainant_Preferred_Contact_Method__c = 'Test contact', //CH46.Update
                                     Complaint_Category_Level_1__c = 'Test4',Complaint_Category_Level_2__c = 'Test5',Complaint_description__c = 'TEST TEST TESTTEST TESTTEST TEST TESTTESTTEST TEST TESTTEST TEST TESTTESTTEST TEST TESTTEST TEST TESTTESTTEST TEST TESTTEST TEST TESTTESTTEST TEST TESTTEST TEST TESTTESTTEST TEST TESTTEST TEST TESTTESTTEST TEST',Complaint_status__c = 'Test5',
                                     /*CH47 Customer_address__c = 'Test9' */Address__c='test address' , City__c='test city' ,Post_Code__c='SG1 1ST' ,Customer_preferred_contact_method__c = 'Test8', Customer_Service_Advisor_Name__c = 'Test7',
                                     Investigation_notes__c = 'Test5',Repeat_complaint__c= true, Resolution_outcome__c = 'TestResult', //CH46.Update
                                     Status_update_time__c =cDT);
    }
    //CH25.End    
    //CH27.Start
    /**
        createEonJobAttributes() : This method will return the object instace of EON_Job_Attribute__c object with data
    **/
    public static EON_Job_Attribute__c createEonJobAttributes()
    {
        EON_Job__c eJob = createEONJob();
        insert eJob;
        return new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=eJob.ID,duration__c=15,Inactive__c=false,value__c='test');
    }
    /**
        createEonPostCode() : This method will return the object instace of EON_Job_Attribute__c object with data
    **/
    public static EON_Post_Code__c createEonPostCode()
    {
        return new EON_Post_Code__c(Name='Test');
    }
    /**
        createEonSubArea() : This method will return the object instace of EON_Sub_Area__c object with data
    **/
    public static EON_Sub_Area__c createEonSubArea()
    {
        return new EON_Sub_Area__c(Name='Test', Oracle_Bucket_ID__c='OracleBuacketID');
    }
    /**
        createEonRegion() : This method will return the object instace of EON_Region__c object with data
    **/
    public static EON_Region__c createEonRegion()
    {
        return new EON_Region__c(Name='Test');
    }
    /**
        createEonElectricMeterType() : This method will return the object instace of EON_Electric_Meter_Type__c object with data
    **/
    public static EON_Electric_Meter_Type__c createEonElectricMeterType()
    {
        return new EON_Electric_Meter_Type__c(Name='Test');
    }
    //CH27.End
    //CH28.Start
    /**
        createEonOFSCPhotoPropertyList() : This method will return the list of EON_OFSC_Photo_Property__c custom setting with data
    **/
    public static List<EON_OFSC_Photo_Property__c> createEonOFSCPhotoPropertyList()
    { 
        List<EON_OFSC_Photo_Property__c> listphoto = new List<EON_OFSC_Photo_Property__c>();
        EON_OFSC_Photo_Property__c photo1 = new EON_OFSC_Photo_Property__c (Name = 'test 1',Object_Name__c='EON_Job_Results__c');
        EON_OFSC_Photo_Property__c photo2 = new EON_OFSC_Photo_Property__c (Name = 'test 2',Object_Name__c='EON_Faulty_Asset__c');
        listphoto.add(photo1); 
        listphoto.add(photo2);
        return listphoto;
    }
    //CH28.End
    //CH29.Start
    /**
        createEon_workZoneMappping() : This method will return the list of EON_OFSC_Photo_Property__c custom setting with data
    **/
    public static Eon_WorkZoneMapping__c createEon_workZoneMappping()
    { 
        return new Eon_WorkZoneMapping__c(Name='London South East',Parent_id__c='LON_SouthEast');
    }
    //CH29.End
    //CH33 Start
    /**
        createEon_Order() : This method will return the list of object EON_Order__c
    **/
    public static List<EON_Order__c> createEon_OrderList()
    { 
        List<EON_Order__c> orderList = new List<EON_Order__c>();
        EON_Order__c order1 = new EON_Order__c();
        EON_Order__c order2 = new EON_Order__c();
        orderList.add(order1);
        orderList.add(order2);
        return orderList;
    }
    /**
        createEon_ShutdownDays() : This method will return the instance of EON Shutdown Days
    **/
    public static EON_Shutdown_Days__c createEon_ShutdownDays()
    { 
        return new EON_Shutdown_Days__c (Name='testHoliday',Holiday_Date__c=date.newInstance(2016,06,06));
    }
    //CH33 End
    //CH34.start
    public static EON_SSC__c createEON_SSC(){ 
        return new EON_SSC__c(Name='0151',Type__c='Classic');
    }
    public static EON_SSC__c createEON_SSCSmart(){ 
        return new EON_SSC__c(Name='031',Type__c='Smart');
    }
    //CH34.old
    //CH035.New.Start
    /**
        createContactOutcome() : This method will return the instance of object EON_Contact_Outcome__c
    **/
    public static EON_Contact_Outcome__c createContactOutcome(){
        return new EON_Contact_Outcome__c(name='test');
    }
    /**
        createVulnerabilityCode() : This method will return the instance of object EON_Vulnerability_Code__c 
    **/
    
    public static EON_Vulnerability_Code__c createVulnerabilityCode(){
    return new EON_Vulnerability_Code__c(name='test', Vulnerability_Code__c=99);
    }
    
    /**
        createEon_workZoneMappping() : This method will return the instance of object EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c
    **/
    public static EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c createOverrideableEligivbilityFlag(){
    return new EON_OVERRIDEABLE_ELIGIBILITY_FLAG__c(name='test', Opt_Out_ID__c=99);
    }
    //CH035.New.End
    //CH40.New.Start
    public static EON_Campaign__c createEONCampaign(){
        return new EON_Campaign__c();
    }
    public static EON_Error_Code__c createEONErrorCode(){
        return new EON_Error_Code__c();
    }
    //CH40.New.End
    //CH42.New.Start
    public static EON_SSC_Register__c createEONSscRegister(){
        return new EON_SSC_Register__c();
    }
    //CH42.New.End
     //CH44.Start
    public static EON_Appointment_Attribute__c createEONAppointmentAttributes(){
        return new EON_Appointment_Attribute__c(EON_Appointment_ID__c = null,Inactive__c = false,Job_Attribute__c = null,SME_Duration__c = 20.00,Value__c = null);
    }
    //CH44.End
    //CH45.Start
    /**
    createGSPGroup() : This method will return the object instance of  EON_GSP_Group__c object with data
    **/
    public static  EON_GSP_Group__c createGSPGroup() {
        return new EON_GSP_Group__c (  name='_N', GSP_Group_Description__c ='Scottish Power'); //CH03,CH12,CH13
    }
    /**
    createSSCGroup() : This method will return the object instance of  EON_SSC_Group__c object with data
    **/
    public static EON_SSC_Group__c createSSCGroup() {
    
     EON_GSP_Group__c gspgrp =  createGSPGroup();
     insert  gspgrp;
    
    EON_SSC__c ssc = createEON_SSC();
    insert ssc;
        return new EON_SSC_Group__c ( Group__c = gspgrp.id, SSC__c=ssc.id); //CH03,CH12,CH13
    }
    //CH45.End
}