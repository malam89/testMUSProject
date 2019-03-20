/**
Description : This class is used To provide Gas Meter Point data relating to a specific MPRN using the MPRN as matching key
This class is replicated from apex class EON_Jumbo_ReqGasMeterPointData

VF Page     : None 
Test Class  : EON_MDS_ElecGasData_Test

**/ 
/*
Created By  : Tabish Almas
Created On  : 30/01/2019
Service Req : SR_OptiMUS_EON_297
Change History:

*/
public with sharing class EON_MDS_ReqGasMeterPointData{
    public static MDS_Data_Tracker__c cTrack;
    public  static EON_Appointment__c apptIns;
    public static Map<string,EON_Appointment_Vulnerability__c> mapAppVul;
    public static boolean isError = false; //Check any failure
    public static string Errors = ''; //Contain errors body if isError is true
    
    /**
    AccessGasMeterPointData(string mprnVal, EON_Appointment__c app, string jumboTraId, string EonTraId)
    **/
    Public static void AccessGasMeterPointData(string mprnVal, EON_Appointment__c app, string mdsTraId, string EonTraId){
        cTrack = new MDS_Data_Tracker__c();
        apptIns = new EON_Appointment__c();
        list<EON_Gas_Meter_Location__c> mtrLctn = new list<EON_Gas_Meter_Location__c>();
        list<EON_Gas_Meter_Type__c> mtrType = new list<EON_Gas_Meter_Type__c>();
        list<EON_Gas_Meter_Mechanism__c> meterMech = new list<EON_Gas_Meter_Mechanism__c>();
        string tranID = EON_Utility.GenUniqueNum(); //generating unique random number value
        apptIns = app;
        cTrack.Direction__c = EON_Utility.DIRECTION_OUT;
        cTrack.Command__c = EON_MDS_Utility.CMD_MDS_ReqGasMPRN;
        cTrack.Transaction_ID__c =tranID;
        if(mdsTraId!='')cTrack.MDS_Data_Tracker__c = id.ValueOf(mdsTraId);
        if(EonTraId!='')cTrack.EON_Data_Tracker__c = id.ValueOf(EonTraId);
        EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement MDSObj = new EON_MDS_Work_Management_WS.BasicHttpsBinding_IWorkManagement();
        string Access_Token = system.label.EON_MDS_AccessToken;
        MDSObj.inputHttpHeaders_x = new Map<String, String>();
        MDSObj.inputHttpHeaders_x.put('Authorization','Bearer ' + Access_Token);
        
        //Creating requets to send to MDS 
        if(!EON_Utility.validateRequired(mprnVal)){
            EON_MDS_Work_Management_WS.GasMeterPointDataRequest reqMDS  = new EON_MDS_Work_Management_WS.GasMeterPointDataRequest();
            EON_MDS_Work_Management_WS.ClientData clientInfo = new EON_MDS_Work_Management_WS.ClientData();
            ClientInfo.Id =system.label.EON_MDS_Client_Id;
            ClientInfo.Name =system.label.EON_MDS_Client_Name;
            reqMDS.UniqueId=tranID;
            reqMDS.MPRN =mprnVal;
            reqMDS.Client =ClientInfo;
            cTrack.Request_Data__c=string.valueOf(reqMDS); //populating request data
            //instantiating response object 
            EON_MDS_Work_Management_WS.GasMeterPointDataResponse respMDS = new EON_MDS_Work_Management_WS.GasMeterPointDataResponse();
            try{
                respMDS = MDSObj.RequestGasMeterPointData(reqMDS);
                if(respMDS.Success){
                    //Mapping values 
                    if(!EON_Utility.validateRequired(respMDS.Customer)){   
                        if(!EON_Utility.validateRequired(respMDS.Customer.MPRN))
                            apptIns.MPRN__c = respMDS.Customer.MPRN; 
                        if(!EON_Utility.validateRequired(respMDS.Customer.MeterPointStatus)) 
                            apptIns.Meter_Point_Status_Code__c = respMDS.Customer.MeterPointStatus;
                        if(!EON_Utility.validateRequired(respMDS.Customer.MeteringPressure)){
                            apptIns.Metering_Pressure__c= GMeteringPressure(respMDS.Customer.MeteringPressure);
                            apptIns.h_Metering_Pressure__c = respMDS.Customer.MeteringPressure;
                        }
                        
                        //Populating Address Information 
                        if(!EON_Utility.validateRequired(respMDS.Customer.Address)){
                            if(!EON_Utility.validateRequired(respMDS.Customer.Address.SubBuilding)) 
                                apptIns.Sub_Building_Name__c = respMDS.Customer.Address.SubBuilding;
                            if(!EON_Utility.validateRequired(respMDS.Customer.Address.Building)) 
                                apptIns.Building_Name__c= respMDS.Customer.Address.Building;  
                            if(!EON_Utility.validateRequired(respMDS.Customer.Address.DependentThoroughfare)) 
                                apptIns.Dependent_Thorofare__c = respMDS.Customer.Address.DependentThoroughfare;
                            if(!EON_Utility.validateRequired(respMDS.Customer.Address.Thoroughfare)) 
                                apptIns.Thorofare__c = respMDS.Customer.Address.Thoroughfare;
                            if(!EON_Utility.validateRequired(respMDS.Customer.Address.DoubleDependentLocality)) 
                                apptIns.Double_dependant_Locality__c = respMDS.Customer.Address.DoubleDependentLocality;
                            if(!EON_Utility.validateRequired(respMDS.Customer.Address.DependentLocality)) 
                                apptIns.Dependant_Locality__c = respMDS.Customer.Address.DependentLocality;
                            if(!EON_Utility.validateRequired(respMDS.Customer.Address.PostTown)) 
                                apptIns.Post_Town__c = respMDS.Customer.Address.PostTown;
                            if(!EON_Utility.validateRequired(respMDS.Customer.Address.County)) 
                                apptIns.County__c = respMDS.Customer.Address.County;
                            if(!EON_Utility.validateRequired(respMDS.Customer.Address.PostCode)) 
                                apptIns.Post_Code__c = respMDS.Customer.Address.PostCode;
                        }     
                        
                        //Populating Supplier Infomration   
                        if(!EON_Utility.validateRequired(respMDS.Customer.Supplier)){
                            if(!EON_Utility.validateRequired(respMDS.Customer.Supplier.AbbreviatedName)){
                                apptIns.Market_Participant_Abbreviated_Name__c = respMDS.Customer.Supplier.AbbreviatedName;            
                                apptIns.Gas_Market_Participant_ID__c = respMDS.Customer.Supplier.AbbreviatedName; 
                            }
                            
                            if(!EON_Utility.validateRequired(respMDS.Customer.Supplier.EffectiveFromDate)) 
                                apptIns.G_Effective_From_Date__c = EON_MDS_Utility.strigToDate(respMDS.Customer.Supplier.EffectiveFromDate); 
                            if(!EON_Utility.validateRequired(respMDS.Customer.Supplier.EffectiveToDate)) 
                                apptIns.G_Effective_To_Date__c = EON_MDS_Utility.strigToDate(respMDS.Customer.Supplier.EffectiveToDate); 
                        }
                        
                        //Populating Gas Converter Information 
                        if(!EON_Utility.validateRequired(respMDS.Customer.Converters)){
                            if(!EON_Utility.validateRequired(respMDS.Customer.Converters.Converter)){ 
                                if(!EON_Utility.validateRequired(respMDS.Customer.Converters.Converter[0].SerialNumber)) 
                                    apptIns.G_Meter_Converter_Serial_Number__c = respMDS.Customer.Converters.Converter[0].SerialNumber;  
                                if(!EON_Utility.validateRequired(respMDS.Customer.Converters.Converter[0].Model)) 
                                    apptIns.G_Meter_Converter_Model__c = respMDS.Customer.Converters.Converter[0].Model;
                                if(!EON_Utility.validateRequired(respMDS.Customer.Converters.Converter[0].AssetClass)) 
                                    apptIns.G_Meter_Converter_Asset_Class__c = respMDS.Customer.Converters.Converter[0].AssetClass;
                                if(!EON_Utility.validateRequired(respMDS.Customer.Converters.Converter[0].Manufacturer)) 
                                    apptIns.G_Meter_Converter_Manufacturer__c= respMDS.Customer.Converters.Converter[0].Manufacturer;
                                if(!EON_Utility.validateRequired(respMDS.Customer.Converters.Converter[0].Location)) 
                                    apptIns.G_Meter_Converter_Location__c= respMDS.Customer.Converters.Converter[0].Location; 
                            } 
                        }
                        
                        //Populating Gas Meter Information  
                        if(!EON_Utility.validateRequired(respMDS.Customer.Meters)){
                            if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter)){ 
                                if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].PaymentMethod)) 
                                    apptIns.Payment_Method_code__c = respMDS.Customer.Meters.GasMeter[0].PaymentMethod;                                      
                                if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].Model)) 
                                    apptIns.G_Meter_Model__c = respMDS.Customer.Meters.GasMeter[0].Model;
                                if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].Manufacturer)) 
                                    apptIns.G_Meter_Make__c = respMDS.Customer.Meters.GasMeter[0].Manufacturer;
                                if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].SerialNumber)) 
                                    apptIns.G_Meter_Serial_Number__c = respMDS.Customer.Meters.GasMeter[0].SerialNumber;
                                if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].Type_x)){ 
                                    mtrType =[select id from EON_Gas_Meter_Type__c where Industry_Code__c =:respMDS.Customer.Meters.GasMeter[0].Type_x limit 1];
                                    if(mtrType.size()>0)
                                        apptIns.G_Meter_Type__c =mtrType[0].id; 
                                }          
                                if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].Location)) 
                                    mtrLctn=[select id from EON_Gas_Meter_Location__c where Code__c =:respMDS.Customer.Meters.GasMeter[0].Location limit 1];   
                                if(mtrLctn.size()>0)
                                    apptIns.G_Meter_Location__c =mtrLctn[0].id; 
                                if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].Mechanism)){ 
                                    meterMech = [select id from EON_Gas_Meter_Mechanism__c where Code__c =:respMDS.Customer.Meters.GasMeter[0].Mechanism limit 1];
                                    if(meterMech.size()>0)
                                        apptIns.G_Meter_Mechanism__c =meterMech[0].id;
                                    if(!EON_Utility.validateRequired(PlannedMtrType(respMDS.Customer.Meters.GasMeter[0].Mechanism))) 
                                        apptIns.Planned_G_Meter_Type__c=PlannedMtrType(respMDS.Customer.Meters.GasMeter[0].Mechanism);
                                }
                                
                                //Populating Registers Information   
                                if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].Registers)){       
                                    if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].Registers.GasRegister)){         
                                        if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].Registers.GasRegister[0].NumberOfDigits)) 
                                            apptIns.Number_of_Dials_or_Digits__c= integer.valueOf(respMDS.Customer.Meters.GasMeter[0].Registers.GasRegister[0].NumberOfDigits); 
                                        if(!EON_Utility.validateRequired(respMDS.Customer.Meters.GasMeter[0].Registers.GasRegister[0].Type_x)){
                                            if(!EON_Utility.validateRequired(registerTypeCode(respMDS.Customer.Meters.GasMeter[0].Registers.GasRegister[0].Type_x)))
                                                apptIns.G_Meter_Register_Type__c = registerTypeCode(respMDS.Customer.Meters.GasMeter[0].Registers.GasRegister[0].Type_x);
                                        }    
                                    } 
                                }                                                                                                                
                            }   
                        }
                        
                        //Populating Contact information
                        if(!EON_Utility.validateRequired(respMDS.Customer.Contacts)){   
                            if(!EON_Utility.validateRequired(respMDS.Customer.Contacts.Contact)){                                                                                           
                                if(!EON_Utility.validateRequired(respMDS.Customer.Contacts.Contact[0].TypeCode)) 
                                    if(!EON_Utility.validateRequired(personTypeCode(respMDS.Customer.Contacts.Contact[0].TypeCode)))
                                    apptIns.Person_Type_Code__c= respMDS.Customer.Contacts.Contact[0].TypeCode;  
                                if(!EON_Utility.validateRequired(respMDS.Customer.Contacts.Contact[0].Title)) 
                                    apptIns.Customer_Title__c= respMDS.Customer.Contacts.Contact[0].Title;                   
                                if(!EON_Utility.validateRequired(respMDS.Customer.Contacts.Contact[0].Initials)) 
                                    apptIns.Person_Name__c = respMDS.Customer.Contacts.Contact[0].Initials; 
                                if(!EON_Utility.validateRequired(respMDS.Customer.Contacts.Contact[0].Surname))
                                    apptIns.Person_Name__c = (!EON_Utility.validateRequired(apptIns.Person_Name__c)?apptIns.Person_Name__c:'') + respMDS.Customer.Contacts.Contact[0].Surname;
                                
                                //Populating Contact Mechanism  Information
                                if(!EON_Utility.validateRequired(respMDS.Customer.Contacts.Contact[0].ContactMechanism)){  
                                    if(!EON_Utility.validateRequired(respMDS.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism)){                                                              
                                        if(!EON_Utility.validateRequired(respMDS.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Code))
                                            if(!EON_Utility.validateRequired(displayConMech(respMDS.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Code))) 
                                            apptIns.JUMBO_Contact_Mechanism__c= displayConMech(respMDS.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Code); 
                                        if(!EON_Utility.validateRequired(respMDS.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Value)) 
                                            apptIns.JUMBO_Contact_Value__c= respMDS.Customer.Contacts.Contact[0].ContactMechanism.ContactMechanism[0].Value;
                                    }
                                }
                            }
                        }                                   
                        cTrack.Response_Data__c=string.ValueOf(respMDS); //populating response data
                        
                        //CH11.New.Start
                        if((cTrack.Response_Data__c != null && cTrack.Response_Data__c.length() > 131070))
                            cTrack.Response_Data__c = cTrack.Response_Data__c.substring(0, 131070);   
                        //CH11.New.End
                        
                        cTrack.Status__c=EON_Utility.RESULT_PASS;   
                    }
                }
                else{
                    cTrack.Response_Data__c=string.ValueOf(respMDS); //populating response data
                    
                    //CH11.New.Start
                    if((cTrack.Response_Data__c != null && cTrack.Response_Data__c.length() > 131070))
                        cTrack.Response_Data__c = cTrack.Response_Data__c.substring(0, 131070);   
                    //CH11.New.End                
                    
                    cTrack.Status__c=EON_Utility.RESULT_PASS;
                    for(String str:respMDS.Errors.Message)
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