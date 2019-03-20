/**
    Description : This is wrapper class used for interaction from MIDOS to OFSC via Isis.
**/
/*
    Created By : Akshay Bairagi
    Created Date : 29-April-2016
    Service Request : SR_EON_Mobile_023-026
    Change History : CH01 # SR_EON_Mobile_088 # 05/10/2016 # Dharmendra Pahadiya # Added code for sending info to OFSC for Read Time Out for MIDOS.
*/
public with sharing class EON_MIDOS_To_Isis_Wrapper{
    public string Subject{get;set;}
    public HeaderElement Header{get;set;}
    public ElectricMeterRead_Element EleMeterRead{get;set;}
    public GasMeterRead_Element GasMeterRead{get;set;}
    public string AssetType{get;set;}
    public string StatusMessage{get;set;}
    public string StatusValue{get;set;}
    public string ErrorMessage{get;set;} 
    public string midosId{get;set;}
    /**
        Description : HeaderElement 
    **/  
    public class HeaderElement{
        public String OrgId{get;set;}
        public String RequestId{get;set;}
        public DateTime RequestDateTime{get;set;}
    }
    /**
        Description : ElectricMeterRead_Element 
    **/
    public class ElectricMeterRead_Element{
        public String SSC{get;set;}
        public list<RegisterElement> Registers{get;set;}
    }
    /**
        Description : RegisterElement  
    **/
    public class RegisterElement {  
        public string RegisterId{get;set;}
        public Integer RegisterRead{get;set;}
        public String TPR{get;set;}
    }
    /**
        Description : GasMeterRead_Element 
    **/
    public class GasMeterRead_Element{
        public Integer GasRegisterRead{get;set;}
    }
}