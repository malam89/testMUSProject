/**
    Description : This class will be used to map appointment field values wit wrapper variables for OFSC Create Activity API
    Test Class  : EON_OFSC_Create_Appointment_Wrapper_Test

**/
/*
    Created By  : Mahadev J
    Created On  : 11/11/2016
    Service Req : SR_EON_AB_188
    Change History
    CH01 # SR_EON_Mobile_111 # 19/12/2016 # Mahadev J # Referring field G_Meter_No_of_dials_digits__c 
    CH02 # SR_OptiMUS_EON_240 # 02/05/2018 # Shruti Moghe # added variable and logic as per SR requirements
*/
public class EON_OFSC_Create_Appointment_Wrapper {
    public string Appointment_Key;
    public string Current_Phase;
    public string h_Job_Type;
    public string Fuel_ID; 
    public string Time_Slot;
    public string MPAN; 
    public string Customer_Name;
    public string Metering_Point_Postcode;
    public string EON_Appointment_ID;
    public string Access_Pass_Phrase;
    public string Assisted_Work_Reason_Code;
    public string Additional_Information;
    public string MPRN;
    public string E_Meter_Serial_Number;
    public string E_Meter_Make;
    public string E_Meter_Model;
    public string E_Meter_Register_1_ID;
    public string E_Meter_Register_2_ID;
    public string E_Meter_Register_3_ID;
    public string E_Meter_Register_4_ID;
    public string E_Meter_Register_5_ID;
    public string E_Meter_Register_6_ID;
    public date Certification_Date;
    public string G_Meter_Serial_Number;
    public string Gas_Regulator_Serial_Number;
    public string G_Meter_Make;
    public string G_Meter_Model;
    public string E_Check_Meter_Serial_Number;
    public string G_Check_Meter_Serial_Number;
    public string Expected_Comms_Hub_Serial_Number;
    public string Expected_IHD_Serial_Number;
    public string Requested_SSC;
    public boolean Key_Collection_Required;
    public string E_Check_Meter_Location;
    public boolean Specific_Time_flag;
    public string h_G_MeterMake_Enum_Mapping ;
    public string Key_Person_Name;
    public string Key_Building_Name;
    public string Key_Building_Number;
    public string Key_Sub_Building_Name;
    public string Key_Thorofare;
    public string Key_Dependant_Thorofare;
    public string Key_Dependant_Locality;
    public string Key_Town;
    public string Key_County;
    public string Key_Post_Code;
    public string Key_Contact_Number;
    public string Job_code_Name;
    public decimal Job_code_h_Job_Attribute_Duration;
    public decimal Job_code_Duration;
    public decimal Job_code_SME_Duration;
    public string Planned_E_Meter_Type;
    public string Planned_G_Meter_Type;
    public string Fuel_ID_Premise_Customer_Customer_group_type;
    public string Fuel_ID_Premise_Postcode;
    public string Fuel_ID_MPAN;
    public decimal Duration;
    public string SubArea;
    public boolean Sent_to_Oracle;
    public string Start_Time;
    public string End_Time;
    public string Caller_Name;
    public string Oracle_Address;
    public string Oracle_Town;
    public string Oracle_Postcode;
    public string Oracle_Postcode_Sector;
    public date Appointment_Date;
    public string Fuel_ID_MPRN;
    public string h_OFSC_Metering_Pressure;
    public string h_OFSC_Number_of_Phases;
    public string h_OFSC_Planned_E_Meter_Type;
    public string h_OFSC_Planned_G_Meter_Type;
    public string h_OFSC_Planned_Meter_Registers;
    public string h_OFSC_Planned_Meter_Mode;
    public string h_OFSC_Gas_bind_performed_flag;
    public string h_OFSC_Install_SED_flag;
    public string h_OFSC_E_Check_Meter_Installed;
    public string h_OFSC_G_Check_Meter_Installed;
    public string h_OFSC_Assisted_Work_Reason_Code;
    public decimal E_Meter_Type_OFS_Enumeration;
    public decimal G_Meter_Type_OFS_Enumeration;
    public string Parking_Type;
    public decimal Parking_Type_OFS_Enumeration;
    public string Appointment_reason_code;
    public decimal Appointment_reason_code_OFS_Enumeration;
    public string G_Meter_Location;
    public decimal G_Meter_Location_OFS_Enumeration;
    public string E_Meter_Location;
    public decimal E_Meter_Location_OFS_Enumeration;
    public boolean Sent_to_Oracle_Update;
    public string E_Meter_Type;
    public string G_Meter_Type;
    public string Notes;
    public date Certification_Expiry_Date;
    public string E_Check_Meter_Make;
    public string E_Check_Meter_Model;
    public decimal E_Check_Meter_Location_OFS_Enumeration;
    public string G_Check_Meter_Make;
    public string G_Check_Meter_Model;
    public string G_Check_Meter_Location;
    public decimal G_Check_Meter_Location_OFS_Enumeration ;
    public string Planned_Number_of_Registers;
    public string G_Meter_Mechanism;
    public decimal G_Meter_Mechanism_OFS_Enumeration;
    public string G_Meter_No_of_dials_digits; //CH01.New
    public list<EONAppointmentContact> listOfApptContacts;
    public list<EONVulnerability> listOfEONVulnerability;
    public boolean Install_SED;//CH02
    //public stat
    public class EONAppointmentContact{
        public string name;
        public string Contact_Full_Name;
        public string Media_Detail;
    }
    public class EONVulnerability{
        public string name;
        public string h_Vulnerability_Desc;
    }
    public EON_OFSC_Create_Appointment_Wrapper(EON_Appointment__c appt, list<EON_Appointment_Vulnerability__c> appVul, list<EON_Appointment_Contact__c> appContact){
        String jobType = '', jobName = '', oracleAddress = '', oracleTown = '', oraclePostCode = '';
        decimal gMeterMechanismOFSEnumeration, eCheckMeterLocationOFSEnumeration, gCheckMeterLocationOFSEnumeration, eMeterLocationOFSEnumeration, gMeterLocationOFSEnumeration, apptReasonCodeOFSEnumeration, parkingTypeOFSEnumeration, gMeterTypeOFSEnumeration, eMeterTypeOFSEnumeration;
        //Map Appointment Fields
        Appointment_Key = !EON_Utility.validateRequired(appt.Appointment_Key__c) ? appt.Appointment_Key__c : null;
        Current_Phase = !EON_Utility.validateRequired(appt.Current_Phase__c) ? appt.Current_Phase__c : null;
        if(!EON_Utility.validateRequired(appt.Job_Code__c)){
            EON_Job__c job = [Select ID, Name, Install_SED__c,Duration__c, SME_Duration__c, h_Job_Attribute_Duration__c, Job_Type__c from EON_Job__c where ID=: appt.Job_Code__c limit 1];//CH02 -- Added a field in query Install_SED__c
            jobType = job.Job_Type__c;
            jobName = job.Name;
            Install_SED= job.Install_SED__c;//CH02
            h_Job_Type = !EON_Utility.validateRequired(jobType) ? jobType : null;   
            Job_code_Name = !EON_Utility.validateRequired(job.Name) ? jobName : null;   
            Job_code_h_Job_Attribute_Duration = !EON_Utility.validateRequired(job.h_Job_Attribute_Duration__c) ? job.h_Job_Attribute_Duration__c : null;
            Job_code_Duration = !EON_Utility.validateRequired(job.Duration__c) ? job.Duration__c : null;
            Job_code_SME_Duration = !EON_Utility.validateRequired(job.SME_Duration__c) ? job.SME_Duration__c : null;
        }
        if(!EON_Utility.validateRequired(appt.Fuel_ID__c)){
            Fuel_ID = !EON_Utility.validateRequired(appt.Fuel_ID__c) ? appt.Fuel_ID__c : null;
            EON_Fuel__c fuel = [Select ID, Premise__r.Customer__r.Customer_group_type__c, Premise__r.Postcode__c, MPAN__c, MPRN__c from EON_Fuel__c where ID =: appt.Fuel_ID__c limit 1];
            Fuel_ID_Premise_Customer_Customer_group_type = !EON_Utility.validateRequired(fuel.Premise__r.Customer__r.Customer_group_type__c) ? fuel.Premise__r.Customer__r.Customer_group_type__c : null;
            Fuel_ID_Premise_Postcode = !EON_Utility.validateRequired(fuel.Premise__r.Postcode__c) ? fuel.Premise__r.Postcode__c.substring(0, fuel.Premise__r.Postcode__c.length() - 2) : '';
            Fuel_ID_MPAN = !EON_Utility.validateRequired(fuel.MPAN__c) ? fuel.MPAN__c : null;
            Fuel_ID_MPRN = !EON_Utility.validateRequired(fuel.MPRN__c) ? fuel.MPRN__c : null;
        }
        else{
            if(!EON_Utility.validateRequired(appt.MPAN__c)){
                Fuel_ID_Premise_Postcode = !EON_Utility.validateRequired(appt.Metering_Point_Postcode__c) ? appt.Metering_Point_Postcode__c.substring(0, appt.Metering_Point_Postcode__c.length() - 2) : (!EON_Utility.validateRequired(appt.Post_Code__c) ? appt.Post_Code__c: '');
                /*if(!EON_Utility.validateRequired(appt.Metering_Point_Postcode__c))
                    Fuel_ID_Premise_Postcode = appt.Metering_Point_Postcode__c.substring(0, appt.Metering_Point_Postcode__c.length() - 2);
                else if(!EON_Utility.validateRequired(appt.Post_Code__c))
                    Fuel_ID_Premise_Postcode = appt.Post_Code__c.substring(0, appt.Post_Code__c.length() - 2); */
            }
        }
        Time_Slot = !EON_Utility.validateRequired(appt.Time_Slot__c) ? appt.Time_Slot__c : null;
        if(!EON_Utility.validateRequired(appt.MPAN__c)){
            MPAN =appt.MPAN__c;
            if(!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_2__c) || !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_1__c)){
                oracleAddress = !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_2__c) ? oracleAddress + appt.Metering_Point_Address_Line_2__c : (!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_1__c) ? oracleAddress + appt.Metering_Point_Address_Line_1__c: oracleAddress);
                /*if(!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_2__c))
                    oracleAddress += appt.Metering_Point_Address_Line_2__c;
                else if(!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_1__c))
                    oracleAddress += appt.Metering_Point_Address_Line_1__c; */
                
                oracleAddress = !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_3__c) ? oracleAddress + ' '+appt.Metering_Point_Address_Line_3__c : (!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_4__c) ? oracleAddress + ' '+appt.Metering_Point_Address_Line_4__c:oracleAddress);
                /*if(!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_3__c))
                    oracleAddress += ' '+appt.Metering_Point_Address_Line_3__c;
                else if(!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_4__c))
                    oracleAddress += ' '+appt.Metering_Point_Address_Line_4__c;*/
                
                if(!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_1__c) || !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_2__c) || !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_3__c) || !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_4__c))
                    oracleAddress += ', ';            
                
                if(!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_5__c))
                    oracleAddress += ', '+appt.Metering_Point_Address_Line_5__c;
            }
            else{
                oracleAddress = !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_3__c) ? oracleAddress + appt.Metering_Point_Address_Line_3__c : (!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_4__c) ? oracleAddress + appt.Metering_Point_Address_Line_4__c : oracleAddress);
                if(!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_1__c) || !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_2__c) || !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_3__c) || !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_4__c))
                    oracleAddress += ', ';

                if(!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_5__c))
                    oracleAddress += appt.Metering_Point_Address_Line_5__c;
            }
            Oracle_Address = oracleAddress;
            oracleTown = !EON_Utility.validateRequired(appt.Metering_Point_Address_Line_8__c) ? oracleTown + appt.Metering_Point_Address_Line_8__c : (!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_9__c) ? oracleTown + appt.Metering_Point_Address_Line_9__c : (!EON_Utility.validateRequired(appt.Metering_Point_Address_Line_7__c) ? oracleTown + appt.Metering_Point_Address_Line_7__c :oracleTown));           
            
            Oracle_Town = oracleTown;
            if(!EON_Utility.validateRequired(appt.Metering_Point_Postcode__c))
                oraclePostCode = appt.Metering_Point_Postcode__c;
            Oracle_Postcode = oraclePostCode;
        }
        else{
            if(!EON_Utility.validateRequired(appt.Building_Name__c) || !EON_Utility.validateRequired(appt.Building_Number__c)){
                oracleAddress = !EON_Utility.validateRequired(appt.Building_Name__c) ? oracleAddress + appt.Building_Name__c : (!EON_Utility.validateRequired(appt.Building_Number__c) ? oracleAddress + appt.Building_Number__c : oracleAddress);
                /*if(!EON_Utility.validateRequired(appt.Building_Name__c))
                    oracleAddress += appt.Building_Name__c;
                else if(!EON_Utility.validateRequired(appt.Building_Number__c))
                    oracleAddress += appt.Building_Number__c;*/
                
                if(!EON_Utility.validateRequired(appt.Thorofare__c) || !EON_Utility.validateRequired(appt.Dependent_Thorofare__c))
                    oracleAddress += ', ';
                
                oracleAddress = !EON_Utility.validateRequired(appt.Thorofare__c) ? oracleAddress + appt.Thorofare__c : (!EON_Utility.validateRequired(appt.Dependent_Thorofare__c) ? oracleAddress + appt.Dependent_Thorofare__c : oracleAddress);
                /*if(!EON_Utility.validateRequired(appt.Thorofare__c))
                    oracleAddress += appt.Thorofare__c;
                else if(!EON_Utility.validateRequired(appt.Dependent_Thorofare__c))
                    oracleAddress += appt.Dependent_Thorofare__c;*/
            }
            else{
                oracleAddress = !EON_Utility.validateRequired(appt.Thorofare__c) ? oracleAddress + appt.Thorofare__c : (!EON_Utility.validateRequired(appt.Dependent_Thorofare__c) ? oracleAddress + appt.Dependent_Thorofare__c : oracleAddress);
                /*if(!EON_Utility.validateRequired(appt.Thorofare__c))
                    oracleAddress += appt.Thorofare__c;
                else if(!EON_Utility.validateRequired(appt.Dependent_Thorofare__c))
                    oracleAddress += appt.Dependent_Thorofare__c;*/
            }
            Oracle_Address = oracleAddress;
            oracleTown = !EON_Utility.validateRequired(appt.Post_Town__c) ? oracleTown + appt.Post_Town__c : (!EON_Utility.validateRequired(appt.Dependant_Locality__c) ? oracleTown + appt.Dependant_Locality__c : oracleTown);
            /*if(!EON_Utility.validateRequired(appt.Post_Town__c))
                oracleTown += appt.Post_Town__c;
            else if(!EON_Utility.validateRequired(appt.Dependant_Locality__c))
                oracleTown += appt.Dependant_Locality__c;*/
            Oracle_Town = oracleTown;
            if(!EON_Utility.validateRequired(appt.Post_Code__c))
                oraclePostCode = appt.Post_Code__c;
            Oracle_Postcode = oraclePostCode;
        }
        Customer_Name = !EON_Utility.validateRequired(appt.Customer_Name__c) ? appt.Customer_Name__c : null;
        Metering_Point_Postcode = !EON_Utility.validateRequired(appt.Metering_Point_Postcode__c) ? appt.Metering_Point_Postcode__c : null;
        EON_Appointment_ID = !EON_Utility.validateRequired(appt.EON_Appointment_ID__c) ? appt.EON_Appointment_ID__c : null;
        Access_Pass_Phrase = !EON_Utility.validateRequired(appt.Access_Pass_Phrase__c) ? appt.Access_Pass_Phrase__c : null;
        Assisted_Work_Reason_Code = !EON_Utility.validateRequired(appt.Assisted_Work_Reason_Code__c) ? appt.Assisted_Work_Reason_Code__c : null;
        Additional_Information = !EON_Utility.validateRequired(appt.Additional_Information__c) ? appt.Additional_Information__c : null;
        MPRN = !EON_Utility.validateRequired(appt.MPRN__c) ? appt.MPRN__c : null;
        E_Meter_Serial_Number = !EON_Utility.validateRequired(appt.E_Meter_Serial_Number__c) ? appt.E_Meter_Serial_Number__c : null;
        E_Meter_Make = !EON_Utility.validateRequired(appt.E_Meter_Make__c) ? appt.E_Meter_Make__c : null;
        E_Meter_Model = !EON_Utility.validateRequired(appt.E_Meter_Model__c) ? appt.E_Meter_Model__c : null;
        E_Meter_Register_1_ID = !EON_Utility.validateRequired(appt.E_Meter_Register_1_ID__c) ? appt.E_Meter_Register_1_ID__c : null;
        E_Meter_Register_2_ID = !EON_Utility.validateRequired(appt.E_Meter_Register_2_ID__c) ? appt.E_Meter_Register_2_ID__c : null;
        E_Meter_Register_3_ID = !EON_Utility.validateRequired(appt.E_Meter_Register_3_ID__c) ? appt.E_Meter_Register_3_ID__c : null;
        E_Meter_Register_4_ID = !EON_Utility.validateRequired(appt.E_Meter_Register_4_ID__c) ? appt.E_Meter_Register_4_ID__c : null;
        E_Meter_Register_5_ID = !EON_Utility.validateRequired(appt.E_Meter_Register_5_ID__c) ? appt.E_Meter_Register_5_ID__c : null;
        E_Meter_Register_6_ID = !EON_Utility.validateRequired(appt.E_Meter_Register_6_ID__c) ? appt.E_Meter_Register_6_ID__c : null;
        Certification_Date = !EON_Utility.validateRequired(appt.Certification_Date__c) ? appt.Certification_Date__c : null;
        G_Meter_Serial_Number = !EON_Utility.validateRequired(appt.G_Meter_Serial_Number__c) ? appt.G_Meter_Serial_Number__c : null;
        Gas_Regulator_Serial_Number = !EON_Utility.validateRequired(appt.Gas_Regulator_Serial_Number__c) ? appt.Gas_Regulator_Serial_Number__c : null;
        G_Meter_Make = !EON_Utility.validateRequired(appt.G_Meter_Make__c) ? appt.G_Meter_Make__c : null;
        G_Meter_Model = !EON_Utility.validateRequired(appt.G_Meter_Model__c) ? appt.G_Meter_Model__c : null;
        E_Check_Meter_Serial_Number = !EON_Utility.validateRequired(appt.E_Check_Meter_Serial_Number__c) ? appt.E_Check_Meter_Serial_Number__c : null;
        G_Check_Meter_Serial_Number = !EON_Utility.validateRequired(appt.G_Check_Meter_Serial_Number__c) ? appt.G_Check_Meter_Serial_Number__c : null;
        Expected_Comms_Hub_Serial_Number = !EON_Utility.validateRequired(appt.Expected_Comms_Hub_Serial_Number__c) ? appt.Expected_Comms_Hub_Serial_Number__c : null;
        Expected_IHD_Serial_Number = !EON_Utility.validateRequired(appt.Expected_IHD_Serial_Number__c) ? appt.Expected_IHD_Serial_Number__c : null;
        Requested_SSC = !EON_Utility.validateRequired(appt.Requested_SSC__c) ? appt.Requested_SSC__c : null;
        Key_Collection_Required = !EON_Utility.validateRequired(appt.Key_Collection_Required__c) ? appt.Key_Collection_Required__c : null;
        E_Check_Meter_Location = !EON_Utility.validateRequired(appt.E_Check_Meter_Location__c) ? appt.E_Check_Meter_Location__c : null;
        Specific_Time_flag = !EON_Utility.validateRequired(appt.Specific_Time_flag__c) ? appt.Specific_Time_flag__c : null;
        h_G_MeterMake_Enum_Mapping = !EON_Utility.validateRequired(appt.h_G_MeterMake_Enum_Mapping__c) ? appt.h_G_MeterMake_Enum_Mapping__c : null;
        Key_Person_Name = !EON_Utility.validateRequired(appt.Key_Person_Name__c) ? appt.Key_Person_Name__c : null;
        Key_Building_Name = !EON_Utility.validateRequired(appt.Key_Building_Name__c) ? appt.Key_Building_Name__c : null;
        Key_Building_Number = !EON_Utility.validateRequired(appt.Key_Building_Number__c) ? appt.Key_Building_Number__c : null;
        Key_Sub_Building_Name = !EON_Utility.validateRequired(appt.Key_Sub_Building_Name__c) ? appt.Key_Building_Number__c : null;
        Key_Thorofare = !EON_Utility.validateRequired(appt.Key_Thorofare__c) ? appt.Key_Thorofare__c : null;
        Key_Dependant_Thorofare = !EON_Utility.validateRequired(appt.Key_Dependant_Thorofare__c) ? appt.Key_Dependant_Thorofare__c : null;
        Key_Dependant_Locality = !EON_Utility.validateRequired(appt.Key_Dependant_Locality__c) ? appt.Key_Dependant_Locality__c : null;
        Key_Town = !EON_Utility.validateRequired(appt.Key_Town__c) ? appt.Key_Town__c : null;
        Key_County = !EON_Utility.validateRequired(appt.Key_County__c) ? appt.Key_County__c : null;
        Key_Post_Code = !EON_Utility.validateRequired(appt.Key_Post_Code__c) ? appt.Key_Post_Code__c : null;
        Key_Contact_Number = !EON_Utility.validateRequired(appt.Key_Contact_Number__c) ? appt.Key_Contact_Number__c : null;
        Planned_E_Meter_Type = !EON_Utility.validateRequired(appt.Planned_E_Meter_Type__c) ? appt.Planned_E_Meter_Type__c : null;
        Planned_G_Meter_Type = !EON_Utility.validateRequired(appt.Planned_G_Meter_Type__c) ? appt.Planned_G_Meter_Type__c : null;
        Duration = !EON_Utility.validateRequired(appt.Duration__c) ? appt.Duration__c : null;
        SubArea = !EON_Utility.validateRequired(appt.SubArea__c) ? appt.SubArea__c : null;
        Sent_to_Oracle = !EON_Utility.validateRequired(appt.Sent_to_Oracle__c) ? (appt.Sent_to_Oracle__c ? true : false) : false;
        Start_Time = !EON_Utility.validateRequired(appt.Start_Time__c) ? appt.Start_Time__c : null;
        End_Time = !EON_Utility.validateRequired(appt.End_Time__c) ? appt.End_Time__c : null;
        Caller_Name = !EON_Utility.validateRequired(appt.Caller_Name__c) ? appt.Caller_Name__c : null;
        Oracle_Postcode_Sector = !EON_Utility.validateRequired(appt.Oracle_Postcode_Sector__c) ? appt.Oracle_Postcode_Sector__c : null;
        Appointment_Date = !EON_Utility.validateRequired(appt.Appointment_Date__c) ? appt.Appointment_Date__c : null;
        h_OFSC_Metering_Pressure = (!EON_Utility.validateRequired(appt.Metering_Pressure__c)) ? (appt.Metering_Pressure__c.equalsIgnoreCase('Low') ? '1' : (appt.Metering_Pressure__c.equalsIgnoreCase('Med') ? '2' : '')) : '';
        h_OFSC_Number_of_Phases = (!EON_Utility.validateRequired(appt.Number_of_Phases__c)) ? (appt.Number_of_Phases__c.equalsIgnoreCase('1ph') ? '1' : (appt.Number_of_Phases__c.equalsIgnoreCase('3ph') ? '2' : '')) : '';
        h_OFSC_Planned_E_Meter_Type = (!EON_Utility.validateRequired(appt.Planned_E_Meter_Type__c)) ? (appt.Planned_E_Meter_Type__c.equalsIgnoreCase('Key') ? '1' : (appt.Planned_E_Meter_Type__c.equalsIgnoreCase('MS1') ? '2' : (appt.Planned_E_Meter_Type__c.equalsIgnoreCase('MCL') ? '3' : ''))) : '';
        h_OFSC_Planned_G_Meter_Type = (!EON_Utility.validateRequired(appt.Planned_G_Meter_Type__c)) ? (appt.Planned_G_Meter_Type__c.equalsIgnoreCase('Key') ? '1' : (appt.Planned_G_Meter_Type__c.equalsIgnoreCase('MS1') ? '2' : (appt.Planned_G_Meter_Type__c.equalsIgnoreCase('PP') ? '3' : ''))) : '';
        h_OFSC_Planned_Meter_Registers = (!EON_Utility.validateRequired(appt.Planned_Meter_Registers__c)) ? (appt.Planned_Meter_Registers__c.equalsIgnoreCase('Single-rate') ? '1' : (appt.Planned_Meter_Registers__c.equalsIgnoreCase('Multi-rate') ? '2' : '')) : '';
        h_OFSC_Planned_Meter_Mode = (!EON_Utility.validateRequired(appt.Planned_Meter_Mode__c)) ? (appt.Planned_Meter_Mode__c.equalsIgnoreCase('CR') ? '1' : (appt.Planned_Meter_Mode__c.equalsIgnoreCase('PAYG') ? '2' : '')) : '';
        h_OFSC_Gas_bind_performed_flag = (!EON_Utility.validateRequired(appt.Gas_bind_performed_flag__c)) ? (appt.Gas_bind_performed_flag__c.equalsIgnoreCase('Yes') ? '1' : (appt.Gas_bind_performed_flag__c.equalsIgnoreCase('No') ? '2' : '')) : '';
        h_OFSC_Install_SED_flag = (!EON_Utility.validateRequired(appt.Install_SED_flag__c)) ? (appt.Install_SED_flag__c.equalsIgnoreCase('Yes') ? '1' : (appt.Install_SED_flag__c.equalsIgnoreCase('No') ? '2' : '')) : '';
        h_OFSC_E_Check_Meter_Installed = (!EON_Utility.validateRequired(appt.E_Check_Meter_Installed__c)) ? (appt.E_Check_Meter_Installed__c.equalsIgnoreCase('Yes') ? '1' : (appt.E_Check_Meter_Installed__c.equalsIgnoreCase('No') ? '2' : '')) : '';
        h_OFSC_G_Check_Meter_Installed = (!EON_Utility.validateRequired(appt.G_Check_Meter_Installed__c)) ? (appt.G_Check_Meter_Installed__c.equalsIgnoreCase('Yes') ? '1' : (appt.G_Check_Meter_Installed__c.equalsIgnoreCase('No') ? '2' : '')) : '';
        h_OFSC_Assisted_Work_Reason_Code = (!EON_Utility.validateRequired(appt.Assisted_Work_Reason__c)) ? (appt.Assisted_Work_Reason__c.equalsIgnoreCase('2nd Technician Required') ? '1' : (appt.Assisted_Work_Reason__c.equalsIgnoreCase('Ladder') ? '2' : (appt.Assisted_Work_Reason__c.equalsIgnoreCase('Tech Specialist') ? '3' : ''))) : '';
        Sent_to_Oracle_Update = !EON_Utility.validateRequired(appt.Sent_to_Oracle_Update__c) ? (appt.Sent_to_Oracle_Update__c ? true : false) : false;
        G_Meter_No_of_dials_digits = !EON_Utility.validateRequired(appt.G_Meter_No_of_dials_digits__c) ? String.valueOf(appt.G_Meter_No_of_dials_digits__c) : ''; //CH01.New
        if(!EON_Utility.validateRequired(appt.E_Meter_Type__c)){
            E_Meter_Type = !EON_Utility.validateRequired(appt.E_Meter_Type__c) ? appt.E_Meter_Type__c : null;    
            eMeterTypeOFSEnumeration = [Select ID, OFS_Enumeration__c from EON_Electric_Meter_Type__c where ID=: appt.E_Meter_Type__c].OFS_Enumeration__c;
            E_Meter_Type_OFS_Enumeration = !EON_Utility.validateRequired(eMeterTypeOFSEnumeration) ? eMeterTypeOFSEnumeration : null;
        }
        E_Meter_Type = !EON_Utility.validateRequired(appt.E_Meter_Type__c) ? appt.E_Meter_Type__c : null;
        if(!EON_Utility.validateRequired(appt.G_Meter_Type__c)){
            G_Meter_Type = !EON_Utility.validateRequired(appt.G_Meter_Type__c) ? appt.G_Meter_Type__c : null;    
            gMeterTypeOFSEnumeration = [Select ID, OFS_Enumeration__c from EON_Gas_Meter_Type__c where ID=: appt.G_Meter_Type__c].OFS_Enumeration__c;
            G_Meter_Type_OFS_Enumeration = !EON_Utility.validateRequired(gMeterTypeOFSEnumeration) ? gMeterTypeOFSEnumeration : null;
        }
        Notes = !EON_Utility.validateRequired(appt.Notes__c) ? appt.Notes__c : null;
        Notes = !EON_Utility.validateRequired(appt.Notes__c) ? appt.Notes__c : null;
        Certification_Expiry_Date = !EON_Utility.validateRequired(appt.Certification_Expiry_Date__c) ? appt.Certification_Expiry_Date__c : null;
        E_Check_Meter_Make = !EON_Utility.validateRequired(appt.E_Check_Meter_Make__c) ? appt.E_Check_Meter_Make__c : null;
        E_Check_Meter_Model = !EON_Utility.validateRequired(appt.E_Check_Meter_Model__c) ? appt.E_Check_Meter_Model__c : null;
        G_Check_Meter_Make = !EON_Utility.validateRequired(appt.G_Check_Meter_Make__c) ? appt.G_Check_Meter_Make__c : null;
        G_Check_Meter_Model = !EON_Utility.validateRequired(appt.G_Check_Meter_Model__c) ? appt.G_Check_Meter_Model__c : null;
        Planned_Number_of_Registers = !EON_Utility.validateRequired(appt.Planned_Number_of_Registers__c) ? appt.Planned_Number_of_Registers__c : null;
        if(!EON_Utility.validateRequired(appt.E_Check_Meter_Location__c)){
            eCheckMeterLocationOFSEnumeration = [Select ID, OFS_Enumeration__c from EON_Electric_Meter_Location__c where ID =: appt.E_Check_Meter_Location__c].OFS_Enumeration__c;
            E_Check_Meter_Location_OFS_Enumeration = !EON_Utility.validateRequired(eCheckMeterLocationOFSEnumeration) ? eCheckMeterLocationOFSEnumeration : null;            
        }
        if(!EON_Utility.validateRequired(appt.G_Check_Meter_Location__c)){
            G_Check_Meter_Location = appt.G_Check_Meter_Location__c;
            gCheckMeterLocationOFSEnumeration = [Select ID, OFS_Enumeration__c from EON_Gas_Meter_Location__c where ID =: appt.G_Check_Meter_Location__c].OFS_Enumeration__c;
            G_Check_Meter_Location_OFS_Enumeration = !EON_Utility.validateRequired(gCheckMeterLocationOFSEnumeration) ? gCheckMeterLocationOFSEnumeration : null;            
        }
        if(!EON_Utility.validateRequired(appt.G_Meter_Mechanism__c)){
            G_Meter_Mechanism = appt.G_Meter_Mechanism__c;
            gMeterMechanismOFSEnumeration = [Select ID, OFS_Enumeration__c from EON_Gas_Meter_Mechanism__c where ID=:appt.G_Meter_Mechanism__c limit 1].OFS_Enumeration__c;
            G_Meter_Mechanism_OFS_Enumeration = !EON_Utility.validateRequired(gMeterMechanismOFSEnumeration) ? gMeterMechanismOFSEnumeration : null;            
        }
        if(!EON_Utility.validateRequired(appt.E_Meter_Location__c)){
            E_Meter_Location = appt.E_Meter_Location__c;
            eMeterLocationOFSEnumeration = [Select ID, OFS_Enumeration__c from EON_Electric_Meter_Location__c where ID =: appt.E_Meter_Location__c].OFS_Enumeration__c;
            E_Meter_Location_OFS_Enumeration = !EON_Utility.validateRequired(eMeterLocationOFSEnumeration) ? eMeterLocationOFSEnumeration : null;            
        }
        if(!EON_Utility.validateRequired(appt.G_Meter_Location__c)){
            G_Meter_Location = appt.G_Meter_Location__c;
            gMeterLocationOFSEnumeration = [Select ID, OFS_Enumeration__c from EON_Gas_Meter_Location__c where ID =: appt.G_Meter_Location__c].OFS_Enumeration__c;
            G_Meter_Location_OFS_Enumeration = !EON_Utility.validateRequired(gMeterLocationOFSEnumeration) ? gMeterLocationOFSEnumeration : null;            
        }
        if(!EON_Utility.validateRequired(appt.Appointment_reason_code__c)){
            Appointment_reason_code = appt.Appointment_reason_code__c;
            apptReasonCodeOFSEnumeration = [Select ID, OFS_Enumeration__c from Eon_Appointment_Reason__c where ID =: appt.Appointment_reason_code__c].OFS_Enumeration__c;
            Appointment_reason_code_OFS_Enumeration = !EON_Utility.validateRequired(apptReasonCodeOFSEnumeration) ? apptReasonCodeOFSEnumeration : null;
        }
        /*if(!EON_Utility.validateRequired(appt.Appointment_reason_code__c)){
            apptReasonCodeOFSEnumeration = [Select ID, OFS_Enumeration__c from Eon_Appointment_Reason__c where ID =: appt.Appointment_reason_code__c].OFS_Enumeration__c;
            Appointment_reason_code_OFS_Enumeration = !EON_Utility.validateRequired(apptReasonCodeOFSEnumeration) ? apptReasonCodeOFSEnumeration : null;
        }*/
        if(!EON_Utility.validateRequired(appt.Parking_Type__c)){
            Parking_Type = appt.Parking_Type__c;
            parkingTypeOFSEnumeration = [Select ID, OFS_Enumeration__c from EON_Parking__c where ID=:appt.Parking_Type__c].OFS_Enumeration__c;
            Parking_Type_OFS_Enumeration = !EON_Utility.validateRequired(parkingTypeOFSEnumeration) ? parkingTypeOFSEnumeration : null;
        }
        //Map EON Appointment Vulnerability
        if(!EON_Utility.validateRequired(appVul)){
            list<EONVulnerability> allVul = new list<EONVulnerability>();
            for(EON_Appointment_Vulnerability__c vul : appVul){
                EONVulnerability vulInstance = new EONVulnerability();
                vulInstance.name = !EON_Utility.validateRequired(vul.Name) ? vul.Name : '';
                vulInstance.h_Vulnerability_Desc = !EON_Utility.validateRequired(vul.h_Vulnerability_Desc__c ) ? vul.h_Vulnerability_Desc__c : '';
                allVul.add(vulInstance);
            }
            listOfEONVulnerability = allVul;
        }
        //Map EON Appointment Contacts
        if(!EON_Utility.validateRequired(appContact)){
            list<EONAppointmentContact> allContact = new list<EONAppointmentContact>();
            for(EON_Appointment_Contact__c contact : appContact){
                EONAppointmentContact apptContact = new EONAppointmentContact();
                apptContact.Name = !EON_Utility.validateRequired(contact.Name) ? contact.Name : '';
                apptContact.Contact_Full_Name = !EON_Utility.validateRequired(contact.Contact_Full_Name__c) ? contact.Contact_Full_Name__c : '';
                apptContact.Media_Detail = !EON_Utility.validateRequired(contact.Media_Detail__c) ? contact.Media_Detail__c : '';
                allContact.add(apptContact);
            }
            listOfApptContacts = allContact;
        }
    }
}