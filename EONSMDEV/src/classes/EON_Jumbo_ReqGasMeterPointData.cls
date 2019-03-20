/**
    Description : This class is used To provide Gas Meter Point data relating to a specific MPRN using the MPRN as matching key
     
                  
    VF Page     : None 
    Test Class  : EON_Jumbo_ElecGasData_Test

**/ 
/*
    Created By  : Mehboob Alam
    Created On  : 19/04/2016
    Service Req : SR_EON_Jumbo_018
    Change History:
    CH01 # SR_EON_Jumbo_050 # 02/08/2016 # Mahadev J # Additional mapping for Market Participent ID
    CH02 # SR_EON_AB_119 # 12/08/2016 # Sivasankar K # Added the logic to return the incoming planned g meter type value as same when it is not K N 
    CH03 # SM-2229 # 01/09/2016 # Mahadev J # Correction to Planned G Type mapping
    CH04 # SR_EON_Jumbo_062 # 03/09/2016 # Mahadev Joshilkar # Changed mapping for 'Effective To' dates
    CH05 # NA # 19/10/2016 # Mahadev Joshilkar # Amended mapping for 'G Effective To Date'
*/
public with sharing class EON_Jumbo_ReqGasMeterPointData{
    public static JUMBO_Data_Tracker__c cTrack;
    public  static EON_Appointment__c apptIns;
    public static Map<string,EON_Appointment_Vulnerability__c> mapAppVul;
    public static boolean isError = false; //Check any failure
    public static string Errors = ''; //Contain errors body if isError is true

    /**
        AccessGasMeterPointData(string mprnVal, EON_Appointment__c app, string jumboTraId, string EonTraId)
    **/
    Public static void AccessGasMeterPointData(string mprnVal, EON_Appointment__c app, string jumboTraId, string EonTraId){
        cTrack = new JUMBO_Data_Tracker__c();
        apptIns = new EON_Appointment__c();
        list<EON_Gas_Meter_Location__c> mtrLctn = new list<EON_Gas_Meter_Location__c>();
        list<EON_Gas_Meter_Type__c> mtrType = new list<EON_Gas_Meter_Type__c>();
        list<EON_Gas_Meter_Mechanism__c> meterMech = new list<EON_Gas_Meter_Mechanism__c>();
        string tranID = EON_Utility.GenUniqueNum(); //generating unique random number value
        apptIns = app;
        cTrack.Direction__c = EON_Utility.DIRECTION_OUT;
        cTrack.Command__c =JUMBO_Utility.CMD_JUMBO_ReqGasMPRN;
        cTrack.Transaction_ID__c =tranID;
        if(jumboTraId!='')cTrack.JUMBO_Data_Tracker__c = id.ValueOf(jumboTraId);
        if(EonTraId!='')cTrack.EON_Data_Tracker__c = id.ValueOf(EonTraId);
        EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement jumboObj = new EON_JUMBO_Work_Management_WS.BasicHttpBinding_IWorkManagement();
    
        //Creating requets to send to Jumbo
        if(!EON_Utility.validateRequired(mprnVal)){
            EON_JUMBO_Work_Management_WS.GasMeterPointDataRequest reqJumbo  = new EON_JUMBO_Work_Management_WS.GasMeterPointDataRequest();
            EON_JUMBO_Work_Management_WS.ClientData clientInfo = new EON_JUMBO_Work_Management_WS.ClientData();
            ClientInfo.Id =system.label.EON_Jumbo_Client_Id;
            ClientInfo.Name =system.label.EON_Jumbo_Client_Name;
            reqJumbo.UniqueId=tranID;
            reqJumbo.MPRN =mprnVal;
            reqJumbo.Client =ClientInfo;
            cTrack.Request_Data__c=string.valueOf(reqJumbo); //populating request data
            //instantiating response object
            EON_JUMBO_Work_Management_WS.GasMeterPointDataResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasMeterPointDataResponse();
            try{
                respJumbo = jumboObj.RequestGasMeterPointData(reqJumbo);
                if(respJumbo.Success){
                //Mapping values 
                if(!EON_Utility.validateRequired(respJumbo.Customer)){   
                    if(!EON_Utility.validateRequired(respJumbo.Customer.MPRN))
                        apptIns.MPRN__c = respJumbo.Customer.MPRN; 
                    if(!EON_Utility.validateRequired(respJumbo.Customer.MeterPointStatus)) 
                        apptIns.Meter_Point_Status_Code__c = respJumbo.Customer.MeterPointStatus;
                    if(!EON_Utility.validateRequired(respJumbo.Customer.MeteringPressure)){
                        apptIns.Metering_Pressure__c=GMeteringPressure(respJumbo.Customer.MeteringPressure);
                        apptIns.h_Metering_Pressure__c =respJumbo.Customer.MeteringPressure;
                    }

                    //Populating Address Information 
                    if(!EON_Utility.validateRequired(respJumbo.Customer.Address)){
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Address.SubBuilding)) 
                            apptIns.Sub_Building_Name__c = respJumbo.Customer.Address.SubBuilding;
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Address.Building)) 
                            apptIns.Building_Name__c= respJumbo.Customer.Address.Building;  
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Address.DependentThoroughfare)) 
                            apptIns.Dependent_Thorofare__c = respJumbo.Customer.Address.DependentThoroughfare;
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Address.Thoroughfare)) 
                            apptIns.Thorofare__c = respJumbo.Customer.Address.Thoroughfare;
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Address.DoubleDependentLocality)) 
                            apptIns.Double_dependant_Locality__c = respJumbo.Customer.Address.DoubleDependentLocality;
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Address.DependentLocality)) 
                            apptIns.Dependant_Locality__c = respJumbo.Customer.Address.DependentLocality;
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Address.PostTown)) 
                            apptIns.Post_Town__c = respJumbo.Customer.Address.PostTown;
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Address.County)) 
                            apptIns.County__c = respJumbo.Customer.Address.County;
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Address.PostCode)) 
                            apptIns.Post_Code__c = respJumbo.Customer.Address.PostCode;
                    }     
                      
                    //Populating Supplier Infomration   
                    if(!EON_Utility.validateRequired(respJumbo.Customer.Supplier)){
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Supplier.AbbreviatedName)){
                            apptIns.Market_Participant_Abbreviated_Name__c = respJumbo.Customer.Supplier.AbbreviatedName;            
                            apptIns.Gas_Market_Participant_ID__c = respJumbo.Customer.Supplier.AbbreviatedName; //CH01.New
                        }
                            
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Supplier.EffectiveFromDate)) 
                            apptIns.G_Effective_From_Date__c = JUMBO_Utility.strigToDate(respJumbo.Customer.Supplier.EffectiveFromDate); //CH04.New
                            //apptIns.Effective_From_Date__c = JUMBO_Utility.strigToDate(respJumbo.Customer.Supplier.EffectiveFromDate); //CH04.Old
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Supplier.EffectiveToDate)) //CH05.New
                            apptIns.G_Effective_To_Date__c = JUMBO_Utility.strigToDate(respJumbo.Customer.Supplier.EffectiveToDate); //CH05.New
                    }
                   
                    //Populating Gas Converter Information 
                    if(!EON_Utility.validateRequired(respJumbo.Customer.Converters)){
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Converters.Converter)){ 
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Converters.Converter[0].SerialNumber)) 
                                apptIns.G_Meter_Converter_Serial_Number__c = respJumbo.Customer.Converters.Converter[0].SerialNumber;  
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Converters.Converter[0].Model)) 
                                apptIns.G_Meter_Converter_Model__c = respJumbo.Customer.Converters.Converter[0].Model;
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Converters.Converter[0].AssetClass)) 
                                apptIns.G_Meter_Converter_Asset_Class__c = respJumbo.Customer.Converters.Converter[0].AssetClass;
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Converters.Converter[0].Manufacturer)) 
                                apptIns.G_Meter_Converter_Manufacturer__c= respJumbo.Customer.Converters.Converter[0].Manufacturer;
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Converters.Converter[0].Location)) 
                                apptIns.G_Meter_Converter_Location__c= respJumbo.Customer.Converters.Converter[0].Location; 
                        } 
                    }

                    //Populating Gas Meter Information  
                    if(!EON_Utility.validateRequired(respJumbo.Customer.Meters)){
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter)){ 
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].PaymentMethod)) 
                                apptIns.Payment_Method_code__c = respJumbo.Customer.Meters.GasMeter[0].PaymentMethod;                                      
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].Model)) 
                                apptIns.G_Meter_Model__c = respJumbo.Customer.Meters.GasMeter[0].Model;
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].Manufacturer)) 
                                apptIns.G_Meter_Make__c = respJumbo.Customer.Meters.GasMeter[0].Manufacturer;
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].SerialNumber)) 
                                apptIns.G_Meter_Serial_Number__c = respJumbo.Customer.Meters.GasMeter[0].SerialNumber;
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].Type_x)){ 
                                mtrType =[select id from EON_Gas_Meter_Type__c where Industry_Code__c =:respJumbo.Customer.Meters.GasMeter[0].Type_x limit 1];
                                if(mtrType.size()>0)
                                    apptIns.G_Meter_Type__c =mtrType[0].id; 
                            }          
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].Location)) 
                                mtrLctn=[select id from EON_Gas_Meter_Location__c where Code__c =:respJumbo.Customer.Meters.GasMeter[0].Location limit 1];   
                                if(mtrLctn.size()>0)
                                   apptIns.G_Meter_Location__c =mtrLctn[0].id; 
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].Mechanism)){ 
                                meterMech = [select id from EON_Gas_Meter_Mechanism__c where Code__c =:respJumbo.Customer.Meters.GasMeter[0].Mechanism limit 1];
                                if(meterMech.size()>0)
                                    apptIns.G_Meter_Mechanism__c =meterMech[0].id;
                                if(!EON_Utility.validateRequired(PlannedMtrType(respJumbo.Customer.Meters.GasMeter[0].Mechanism))) 
                                    apptIns.Planned_G_Meter_Type__c=PlannedMtrType(respJumbo.Customer.Meters.GasMeter[0].Mechanism);
                            }
                          
                            //Populating Registers Information   
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].Registers)){       
                                if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].Registers.GasRegister)){         
                                    if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].Registers.GasRegister[0].NumberOfDigits)) 
                                        apptIns.Number_of_Dials_or_Digits__c= integer.valueOf(respJumbo.Customer.Meters.GasMeter[0].Registers.GasRegister[0].NumberOfDigits); 
                                    if(!EON_Utility.validateRequired(respJumbo.Customer.Meters.GasMeter[0].Registers.GasRegister[0].Type_x)){
                                        if(!EON_Utility.validateRequired(registerTypeCode(respJumbo.Customer.Meters.GasMeter[0].Registers.GasRegister[0].Type_x)))
                                            apptIns.G_Meter_Register_Type__c = registerTypeCode(respJumbo.Customer.Meters.GasMeter[0].Registers.GasRegister[0].Type_x);
                                    }    
                                } 
                            }                                                                                                                
                        }   
                    }
                      
                    //Populating Contact information
                    if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts)){   
                        if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts.Contact)){                                                                                           
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts.Contact[0].TypeCode)) 
                                if(!EON_Utility.validateRequired(personTypeCode(respJumbo.Customer.Contacts.Contact[0].TypeCode)))
                                    apptIns.Person_Type_Code__c= respJumbo.Customer.Contacts.Contact[0].TypeCode;  
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts.Contact[0].Title)) 
                                apptIns.Customer_Title__c= respJumbo.Customer.Contacts.Contact[0].Title;                   
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts.Contact[0].Initials)) 
                                apptIns.Person_Name__c = respJumbo.Customer.Contacts.Contact[0].Initials; 
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts.Contact[0].Surname))
                                apptIns.Person_Name__c = (!EON_Utility.validateRequired(apptIns.Person_Name__c)?apptIns.Person_Name__c:'') + respJumbo.Customer.Contacts.Contact[0].Surname;
                          
                            //Populating Contact Mechanism  Information
                            if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts.Contact[0].ContactMechanism)){  
                                if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism)){                                                              
                                    if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Code))
                                        if(!EON_Utility.validateRequired(displayConMech(respJumbo.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Code))) 
                                            apptIns.JUMBO_Contact_Mechanism__c= displayConMech(respJumbo.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Code); 
                                    if(!EON_Utility.validateRequired(respJumbo.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Value)) 
                                        apptIns.JUMBO_Contact_Value__c= respJumbo.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Value;
                                }
                            }
                        }
                    }                                   
                    cTrack.Response_Data__c=string.ValueOf(respJumbo); //populating response data
                    
                    //CH11.New.Start
                    if((cTrack.Response_Data__c != null && cTrack.Response_Data__c.length() > 131070))
                         cTrack.Response_Data__c = cTrack.Response_Data__c.substring(0, 131070);   
                    //CH11.New.End
                                            
                    cTrack.Status__c=EON_Utility.RESULT_PASS;   
                }
            }
            else{
                cTrack.Response_Data__c=string.ValueOf(respJumbo); //populating response data
                
                //CH11.New.Start
                if((cTrack.Response_Data__c != null && cTrack.Response_Data__c.length() > 131070))
                     cTrack.Response_Data__c = cTrack.Response_Data__c.substring(0, 131070);   
                //CH11.New.End                
                
                cTrack.Status__c=EON_Utility.RESULT_PASS;
                for(String str:respJumbo.Errors.Message)
                    Errors=Errors+str+'\n';  
                isError = true;
            }
        }
        catch(Exception e){
            cTrack.Response_Data__c=e.getMessage()+'\n'+e.getStackTraceString()+'\n'+e.getLineNumber();
            cTrack.Status__c=EON_Utility.RESULT_FAIL;
            Errors=cTrack.Response_Data__c;
            isError = true;
        }  
    }
    else{
        Errors='MPRN cannot pass as Blank to access Gas meter data';
        isError = true;
    }
}

    /** 
        String displayConMech(String val): Method to return Contact Mechanism.
    **/  
    public static String displayConMech(String value){
        if(value == 'EMAIL')return 'email';
        if(value == 'FAX')return 'Facsimile';
        if(value == 'MOBIL')return 'Mobile Phone';
        if(value == 'PAG')return 'Pager';
        if(value == 'POST')return 'Letter';
        if(value == 'TEL')return 'Telephone';  
        if(value == 'TEX')return 'Telex';
        if(value == 'VISIT')return 'Visit';     
        return null;                                   
    }
  
  
    /** 
        String RegisterTypeCode(String value): Method to return Register Type. 
    **/  
    public static String registerTypeCode(String value){
        if(value == 'CORR')return 'Corrected Converter Register';
        if(value == 'METER')return 'Meter Register';
        if(value == 'UNCOR')return 'Uncorrected Converter Register';    
        return null;                                   
    }
  
    /** 
        string personTypeCode(String value): Method to return Person Type code. 
    **/  
    public static String personTypeCode(String value){
        if(value == 'ASSPR')return 'Asset Provider';
        if(value == 'CCMP')return 'Connection Company';
        if(value == 'CKEY')return 'Contact for Key';
        if(value == 'CLAND')return 'Contact Landlord';
        if(value == 'CONS')return 'Consumer/Customer';
        if(value == 'CONT')return 'Uncorrected Converter Register';  
        if(value == 'CREP')return 'Contact to Report to';
        if(value == 'CSITE')return 'Site Contact';
        if(value == 'CTENT')return 'Contact Tennant';  
        if(value == 'GAO')return 'Gas Act Owner';
        if(value == 'KEYH')return 'Key Holder';
        if(value == 'MAM')return 'Meter Asset Manager';
        if(value == 'MTWK')return 'Meter Worker';
        if(value == 'REQ')return 'Requestor of Job or Query';
        if(value == 'TIOWN')return 'Title Owner';
        if(value == 'UNCON')return 'Unconnected Asset Address';
        return null;                                   
    }
  
    /** 
        string PlannedMtrType(string mtrType): Method to return Planned G Meter Type. 
    **/ 
    public static string PlannedMtrType(string mtrType){
        //CH03.Old.Start
        /*
        if(mtrType=='CR') return 'MCL';
        if(mtrType=='S1') return 'MS1';
        if(mtrType=='PP') return 'PP';
        //CH02 returning the mtrType instead of returning null. 
        return mtrType;  */
        //CH03.Old.End
        //CH03.New//&& EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(mtrType.toUpperCase()).Meter_Type__c == 'G'
        return ((EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll() != null && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(mtrType.toUpperCase()) ) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(mtrType.toUpperCase()).Planned_Meter_Type__c : null);
    }
  
    /** 
        string GMeteringPressure(string gMpre): Method to return Metering Pressure. 
    **/ 
    public static string GMeteringPressure(string gMpre){
        if(Decimal.ValueOf(gMpre) <= 0.075)
            return 'Low';
        else 
            return 'Med'; 
    }
}