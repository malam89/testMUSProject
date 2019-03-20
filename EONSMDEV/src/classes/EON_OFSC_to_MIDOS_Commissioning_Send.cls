/**
    Description : This class is used to prepare data to send to MIDOS for commissioning.
    Test Class  : EON_OFSC_to_MIDOS_Commission_Helper_test
**/
/*
    Created By  : Dharmendra Pahadiya
    Created On  : 12/05/2016
    Service Req : SR_EON_Mobile_019
    Change History
    CH01 # SR_EON_Mobile_020  # 16/05/2016 # Shruti Moghe # added logic for SubmitPrePayBalance
    CH02 # SR_EON_Mobile_022 # Dharmendra Pahadiya # 20/05/2016 # Added logic to send Credit Meter Reading to MIDOS
    CH03 # SR_EON_Mobile_039  # 20/05/2016 # Shruti Moghe # added logic for SubmitPrePayBalance when multiple meters data is received
    CH04 # SR_EON_Mobile_021  # 24/05/2016 # Shruti Moghe # Added logic to send ValidateSMSAsset to MIDOS
    CH05 # SR_Isis_EON_018 # 06/06/2016 # Dharmendra Pahadiya # Updated 'OrgId' mapping.
    CH06 # SR_OptiMUS_EON_022 # 16/09/2016 # Puneet Mehta # Reworked MIDOS web services calls to cater for the digital signing of request
    CH07 # SR_EON_Mobile_086 # 04/10/2016 # Shruti Moghe # Updated code to send AssetType if the request from Oracle includes a Serial Number for that asset. 
    CH08 # SR_EON_Mobile_087 # 05/10/2016 # Akshay Bairagi # Updated code to achieve SR functionality
    CH09 # SR_EON_Mobile_088 # 05/10/2016 # Dharmendra Pahadiya # Added code for sending info to OFSC for Read Time Out for MIDOS.
    CH10 # SR_EON_Mobile_112 # 21/12/2016 # Puneet Mehta # Added Logic to Send the Serial number in upper case to MIDOS system.
    CH11 # SR_OptiMUS_EON_117 # 10/10/2017 # Praveen G # Added mapping for RegisterID - configureSMSAsset 
    CH12 # SR_OptiMUS_EON_191 # 15/12/2017 # Praveen G # removed '-' from serial number for ValidateSMSAsset, ConfigureSMSAsset 
    CH13 # SR_OptiMUS_EON_177 # 25/01/2018 # Praveen G # Added new method for UnConfigureSMSAsset 
    CH14 # SR_OptiMUS_EON_219 # 06/02/2018 # Praveen G # reverted the changes for SR_OptiMUS_EON_117
    CH15 # SR_OptiMUS_EON_192 # 25/01/2018 # Praveen G # Added fix for quiuing issue
    CH16 # SR_OptiMUS_EON_225 # 15/02/2018 # Praveen G # Added fix for quiuing issue
    CH17 # SR_OptiMUS_EON_215 # 15/02/2018 # Praveen G # Changed the Register ID Mapping.
*/
public with sharing class EON_OFSC_to_MIDOS_Commissioning_Send {

    private static String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static String toaNS = 'urn:toatech:agent';
    private static string OrgId;
    private static string RequestId;
    private static string RequestDateTime;
    private static string bodyStartTag = '<s:Body xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" u:Id="_1">';//CH06
    private static string headerTag;//CH06

    /*
        sendCreditMeter(string midosTrackeId, string xmlFile, integer noOfMeters) -- This method is used to send data to MIDOS received from Oracle for subject = 'SubmitCreditMeterReading'
    */
    @future(callout=true)
    public static void sendCreditMeter(string midosTrackeId, string xmlFile, integer noOfMeters){
        list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>();
        try{
            //Get Midos Data Tracker record
            lstTrack = [select id, name, Request_Data__c, Response_Data__c, Status__c, Transaction_ID__c from MIDOS_Data_Tracker__c where id=:midosTrackeId];
            dom.XmlNode[] xmlBody1 = getXmlBody(xmlFile);
            dom.XmlNode[] xmlBody = xmlBody1[0].getChildElements(); //Get the root CreditMeterReading
            string xmlBody_ele = xmlBody[0].getName();
            //Extract Header information
            getHeader(xmlBody[0],lstTrack[0].Name);
            system.debug('@@@ OrgId: '+ OrgId);
            system.debug('@@@ RequestId: '+ RequestId);
            system.debug('@@@ RequestDateTime: '+ RequestDateTime);
            system.debug('@@@ headerTag: '+ headerTag);
            //Get appointment
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where Name =: RequestId]);
            //Iterate through whole xml to fetch and map data
            integer j =1; //j is used to fetch the exact meter information by comparing with noOfMeters.//CH03
            String mpan=''; String mprn=''; String SerialNumber =''; String StrRegisters='';
            for(Dom.XmlNode node : xmlBody){
                if(node.getName().containsIgnoreCase('Header'))continue;
                if(j!=noOfMeters){j++;continue;}//CH03
                system.debug('*** node name: '+node.getName()+' value: '+node.getText());
                if(node.getChildren()!=null)
                for(Dom.XmlNode cnode : node.getChildElements()){
                    system.debug('*** child node name: '+cnode.getName()+' value: '+cnode.getText());
                    if(cnode.getName().containsIgnoreCase('MPAN'))
                        Mpan=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('SerialNumber'))
                        SerialNumber=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('MPRN'))
                        Mprn=cnode.getText();
                    if(cnode.getChildren()!=null)
                    for(Dom.XmlNode gcnode : cnode.getChildElements()){
                        system.debug('*** grand child node name: '+gcnode.getName()+' value: '+gcnode.getText());
                        String RegisterRead=''; String RegisterId='';
                        for(Dom.XmlNode gccnode : gcnode.getChildElements()){
                            system.debug('*** grand grand child node name: '+gccnode.getName()+' value: '+gccnode.getText());
                            if(gccnode.getName().containsIgnoreCase('RegisterId'))
                                RegisterId= gccnode.getText();
                            if(gccnode.getName().containsIgnoreCase('RegisterRead'))
                               RegisterRead=gccnode.getText();//RegisterRead= string.isNotBlank(gccnode.getText())?gccnode.getText():'0';//CH08
                        }
                       if(!String.isBlank(RegisterRead))//CH08
                        StrRegisters= StrRegisters+'<b:RegisterDto><b:RegisterId>'+RegisterId+'</b:RegisterId><b:RegisterRead>'+RegisterRead+'</b:RegisterRead></b:RegisterDto>';//CH06
                    }
                }
                j++;//CH03
            }
            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/SubmitCreditMeterReading';//CH06
            string strResponseXML = '';
            //CH06
            strResponseXML = bodyStartTag + '<SubmitCreditMeterReading xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request>'+headerTag+'<b:MeterData xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:Mpan>'+Mpan+'</b:Mpan><b:Mprn>'+Mprn+'</b:Mprn><b:Registers>'+StrRegisters+'</b:Registers><b:SerialNumber>'+SerialNumber+'</b:SerialNumber></b:MeterData></request></SubmitCreditMeterReading></s:Body>';//CH06
            system.debug('@@ Request in xml format :->'+strResponseXML );
            strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,strResponseXML);//CH06
            calloutAndPostProcess(Action,strResponseXML,lstTrack[0],lstApp);//CH06
        }catch(exception ex){
            exceptionAndPostProcess(ex,lstTrack[0]);
        }
    }
    //CH01.start
    /*
        sendPrePayBalance(string midosTrackeId, string xmlFile, integer noOfMeters) -- This method is used to send data to MIDOS received from Oracle for subject = 'SubmitPrePayBalance'
    */
    @future(callout=true)
    public static void sendPrePayBalance(string midosTrackeId, string xmlFile, integer noOfMeters){
        list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>();
        try{
            //Get Midos Data Tracker record
            lstTrack = [select id, name, Request_Data__c, Response_Data__c, Status__c, Transaction_ID__c from MIDOS_Data_Tracker__c where id=:midosTrackeId];
            dom.XmlNode[] xmlBody1 = getXmlBody(xmlFile);
            dom.XmlNode[] xmlBody = xmlBody1[0].getChildElements(); //Get the root PrePayMeterBalance
            string xmlBody_ele = xmlBody[0].getName();
            //Extract Header information
            getHeader(xmlBody[0],lstTrack[0].Name);
            system.debug('@@@ OrgId: '+OrgId);
            system.debug('@@@ RequestId: '+RequestId);
            system.debug('@@@ RequestDateTime: '+RequestDateTime);
            system.debug('@@@ headerTag: '+ headerTag);
            //Get appointment
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where Name =: RequestId]);
            string strResponseXML = '';
            strResponseXML = bodyStartTag + '<SubmitPrePayBalance xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request>';//CH06
            //Iterate through whole xml to fetch and map data
            String DeviceType='';
            String Mpan='';
            String Mprn='';
            String SerialNumber='';
            String CurrentBalance='';
            String TotalDebt='';
            integer j =1; //j is used to fetch the exact meter information by comparing with noOfMeters.
            for(Dom.XmlNode node : xmlBody){
                if(node.getName().containsIgnoreCase('Header'))continue;
                if(j!=noOfMeters){j++;continue;}
                system.debug('*** node name: '+node.getName()+' value: '+node.getText());
                if(node.getChildren()!=null)
                for(Dom.XmlNode cnode : node.getChildElements()){
                    system.debug('*** child node name: '+cnode.getName()+' value: '+cnode.getText());
                    if(cnode.getName().containsIgnoreCase('DeviceType'))
                        DeviceType=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('MPAN'))
                        Mpan=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('MPRN'))
                        Mprn=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('SerialNumber'))
                        SerialNumber=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('CurrentBalance') && string.isNotBlank(cnode.getText()))
                        CurrentBalance=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('TotalDebt') && string.isNotBlank(cnode.getText()))
                        TotalDebt=cnode.getText();
                }
                j++;
            }
            strResponseXML = strResponseXML +'<b:BalanceData xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:CurrentBalance>'+CurrentBalance+'</b:CurrentBalance><b:DeviceType>'+DeviceType+'</b:DeviceType><b:Mpan>'+Mpan+'</b:Mpan><b:Mprn>'+Mprn+'</b:Mprn><b:SerialNumber>'+SerialNumber+'</b:SerialNumber><b:TotalDebt>'+TotalDebt+'</b:TotalDebt></b:BalanceData>'+headerTag+'</request></SubmitPrePayBalance></s:Body>';//CH06
            system.debug('@@ Request in xml format :->'+strResponseXML );
            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/SubmitPrePayBalance';//CH06
            strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,strResponseXML);//CH06
            calloutAndPostProcess(Action,strResponseXML,lstTrack[0],lstApp);//CH06
        }catch(exception ex){
            exceptionAndPostProcess(ex,lstTrack[0]);
        }
    }
    //CH01.end
    //CH02.Start
    /*
        sendConfigAsset(string midosTrackeId, string xmlFile) -- This method is used to send data to MIDOS received from Oracle for subject = 'ConfigureSMSAsset'
    */
    @future(callout=true)
    public static void sendConfigAsset(string midosTrackeId, string xmlFile){
        list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>();
        try{
            //Get Midos Data Tracker record
            lstTrack = [select id, name, Request_Data__c, Response_Data__c, Status__c, Transaction_ID__c from MIDOS_Data_Tracker__c where id=:midosTrackeId];
            dom.XmlNode[] xmlBody1 = getXmlBody(xmlFile);
            dom.XmlNode[] xmlBody = xmlBody1[0].getChildElements(); //Get the root SMSAssetConfiguration
            string xmlBody_ele = xmlBody[0].getName();
            //Extract Header information
            getHeader(xmlBody[0],lstTrack[0].Name);
            system.debug('@@@ OrgId: '+OrgId);
            system.debug('@@@ RequestId: '+RequestId);
            system.debug('@@@ RequestDateTime: '+RequestDateTime);
            system.debug('@@@ headerTag: '+ headerTag);
            //Get appointment
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where Name =: RequestId]);
            string strResponseXML = '';
            strResponseXML = bodyStartTag + '<ConfigureSmsAsset xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request>';//CH06
            //Iterate through whole xml to fetch and map data
            String ESerialNumber=''; String GSerialNumber=''; String HSerialNumber=''; String ISerialNumber='';
            String EAssetSubType=''; String GAssetSubType=''; String HAssetSubType=''; String IAssetSubType='';
            String EAssetType=''; String GAssetType=''; String HAssetType=''; String IAssetType='';
            String Mpan=''; String Mprn=''; string Ssc=''; 
            String strResponseRegister='';
            for(Dom.XmlNode node : xmlBody){
                if(node.getName().containsIgnoreCase('Header'))continue;
                system.debug('*** node name: '+node.getName()+' value: '+node.getText());
                if(node.getChildren()!=null)
                for(Dom.XmlNode cnode : node.getChildElements()){
                    system.debug('*** child node name: '+cnode.getName()+' value: '+cnode.getText());
                    if(cnode.getName().containsIgnoreCase('SerialNumber')){
                        if(node.getName().containsIgnoreCase('Hub') && cnode.getText() != null)//CH10
                            HSerialNumber = cnode.getText();
                        else if(node.getName().containsIgnoreCase('ElectricMeter') && cnode.getText() != null)//CH10
                            ESerialNumber = cnode.getText();
                        else if(node.getName().containsIgnoreCase('GasMeter') && cnode.getText() != null)//CH10
                            gSerialNumber = cnode.getText();
                        else if(node.getName().containsIgnoreCase('IHD') && cnode.getText() != null)//CH10
                            ISerialNumber = cnode.getText();
                    }
   
                    if(cnode.getName().containsIgnoreCase('MPAN'))
                        Mpan = cnode.getText();
                    if(cnode.getName().containsIgnoreCase('MPRN'))
                        Mprn =cnode.getText();
                    if(cnode.getName().containsIgnoreCase('SSC'))
                        Ssc = cnode.getText();                        
                    if(cnode.getChildren()!=null)
                    for(Dom.XmlNode gcnode : cnode.getChildElements()){
                        String regid='';
                        String tpr='';
                        system.debug('*** grand child node name: '+gcnode.getName()+' value: '+gcnode.getText());
                        for(Dom.XmlNode gccnode : gcnode.getChildElements()){
                            system.debug('*** grand grand child node name: '+gccnode.getName()+' value: '+gccnode.getText());
                            if(gccnode.getName().containsIgnoreCase('RegisterId'))
                               regid= gccnode.getText();
                            if(gccnode.getName().containsIgnoreCase('TPR'))
                               Tpr= gccnode.getText();
                        }
                        if(regid!=null && regid!=''){
                            //CH11.Start
                            /*
                            String mapRegId = regid;
                            if(HSerialNumber != null && HSerialNumber.length() == 10){
                                Map<String, String> mapEMeterRegisterID = 
                                        EON_Job_Results_Trigger_Helper.getEMeterRegisterIDMap();
                                if(mapEMeterRegisterID.get(regid) != null)                                    
                                    mapRegId = mapEMeterRegisterID.get(regid); 
                            } 
                            */      
                            //CH11.End
                            strResponseRegister = strResponseRegister+'<b:ElecRegisterDto><b:RegisterId>'+regid+'</b:RegisterId><b:Tpr>'+Tpr+'</b:Tpr></b:ElecRegisterDto>';//CH06
                        }
                    }
                }
            }
            strResponseXML = strResponseXML +'<b:ElecMeter xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:AssetSubType>'+EAssetSubType+'</b:AssetSubType><b:AssetType>'+EAssetType+'</b:AssetType><b:SerialNumber>'+ESerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber><b:Mpan>'+mpan+'</b:Mpan><b:Registers>'+strResponseRegister+'</b:Registers>';//CH06 //CH10 //CH12
            strResponseXML = strResponseXML +'<b:Ssc>'+ssc+'</b:Ssc></b:ElecMeter>';
       //CH08.Start
       if(GSerialNumber!=null && GSerialNumber!='')
       strResponseXML = strResponseXML +'<b:GasMeter xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:AssetSubType>'+GAssetSubType+'</b:AssetSubType><b:AssetType>'+GAssetType+'</b:AssetType><b:SerialNumber>'+GSerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber><b:Mprn>'+mprn+'</b:Mprn></b:GasMeter>';//CH10 //CH12
        strResponseXML = strResponseXML +headerTag;
         strResponseXML = strResponseXML +'<b:Hub xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:AssetSubType>'+HAssetSubType+'</b:AssetSubType><b:AssetType>'+HAssetType+'</b:AssetType><b:SerialNumber>'+HSerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber></b:Hub>';//CH10 //CH12
         if(ISerialNumber!=null && ISerialNumber!='')
          strResponseXML = strResponseXML +'<b:Ihd xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:AssetSubType>'+IAssetSubType+'</b:AssetSubType><b:AssetType>'+IAssetType+'</b:AssetType><b:SerialNumber>'+ISerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber></b:Ihd>';//CH10 //CH12
          strResponseXML = strResponseXML +'</request></ConfigureSmsAsset></s:Body>';//CH06
        //CH08.end

            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/ConfigureSmsAsset';//CH06
            strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,strResponseXML);//CH06
            calloutAndPostProcess(Action,strResponseXML,lstTrack[0],lstApp);//CH06
        }catch(exception ex){
            exceptionAndPostProcess(ex,lstTrack[0]);
        }
    }
    //CH02.End
    //CH04.Start
    /*
        sendValidateSMSAsset(string midosTrackeId, string xmlFile) -- This method is used to send data to MIDOS received from Oracle for subject = 'ValidateSMSAsset'
    */
    @future(callout=true)
    public static void sendValidateSMSAsset(string midosTrackeId, string xmlFile){
        list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>();
        try{
            //Get Midos Data Tracker record
            lstTrack = [select id, name, Request_Data__c, Response_Data__c, Status__c, Transaction_ID__c from MIDOS_Data_Tracker__c where id=:midosTrackeId];
            dom.XmlNode[] xmlBody1 = getXmlBody(xmlFile);
            dom.XmlNode[] xmlBody = xmlBody1[0].getChildElements(); //Get the root SMSAssetValidation
            string xmlBody_ele = xmlBody[0].getName();
            //Extract Header information
            getHeader(xmlBody[0],lstTrack[0].Name);
            system.debug('@@@ OrgId: '+OrgId);
            system.debug('@@@ RequestId: '+RequestId);
            system.debug('@@@ RequestDateTime: '+RequestDateTime);
            system.debug('@@@ headerTag: '+ headerTag);
            //Get appointment
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where Name =: RequestId]);
            string strResponseXML = '';
            strResponseXML = bodyStartTag + '<ValidateSmsAsset xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request>';//CH06
            strResponseXML =strResponseXML +'<b:Assets xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa">';//CH06
            //Iterate through whole xml to fetch and map data
            for(Dom.XmlNode node : xmlBody){
                if(node.getName().containsIgnoreCase('Header'))continue;
                system.debug('*** node name: '+node.getName()+' value: '+node.getText());
                if(node.getChildren()!=null)
                for(Dom.XmlNode cnode : node.getChildElements()){
                    system.debug('*** child node name: '+cnode.getName()+' value: '+cnode.getText());
                    if(cnode.getChildren() != null){
                        String AssetType='';
                        String AssetSubType='';
                        String SerialNumber='';
                        for(Dom.XmlNode gcnode : cnode.getChildElements()){
                            system.debug('*** grand child node name: '+gcnode.getName()+' value: '+gcnode.getText());
                            if(gcnode.getName().containsIgnoreCase('AssetSubType'))
                                AssetSubType =gcnode.getText(); 
                            if(gcnode.getName().containsIgnoreCase('AssetType'))
                                AssetType =gcnode.getText();
                            if(gcnode.getName().containsIgnoreCase('SerialNumber') && gcnode.getText() != null)//CH10
                                SerialNumber=gcnode.getText();
                        }
            if(SerialNumber!=null && SerialNumber!='')//CH07 //CH12 for line 323
                        strResponseXML =strResponseXML +'<b:AssetDto><b:AssetSubType>'+AssetSubType+'</b:AssetSubType><b:AssetType>'+AssetType+'</b:AssetType><b:SerialNumber>'+SerialNumber.toupperCase().replace('-', '')+'</b:SerialNumber></b:AssetDto>';//CH06//CH10
                    }
                }
            }
            strResponseXML = strResponseXML +'</b:Assets>'+headerTag+'</request></ValidateSmsAsset></s:Body>';//CH06
            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/ValidateSmsAsset';//CH06
            strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,strResponseXML);//CH06
            system.debug('@@ Request in xml format :->'+strResponseXML );
            calloutAndPostProcess(Action,strResponseXML,lstTrack[0],lstApp);//CH06
        }catch(exception ex){
            exceptionAndPostProcess(ex,lstTrack[0]);
        }
    }
    //CH04.end

    /**
        getXmlBody(string xmlFile) - This method is used to get the body part of xml from the full xml which is used for sending data to MIDOS.
    **/
    public static dom.XmlNode[] getXmlBody(string xmlFile){
        Dom.Document docx = new Dom.Document();
        docx.load(xmlFile);
        dom.XmlNode xroot = docx.getrootelement() ;
        dom.XmlNode xbody = xroot.getChildElement('Body', null);
        dom.XmlNode[] bodyCont = xroot.getChildElement('Body', soapNS).getChildElement('send_message', toaNS).getChildElement('messages', toaNS).getChildElement('message', toaNS).getChildElement('body', toaNS).getChildElements();
        system.debug('@@@ bodyCont: '+bodyCont);
        return bodyCont;
    }

    /**
        getHeader(dom.XmlNode node) - This method is used to get the body part of xml from the full xml which is used for sending data to MIDOS.
    **/
    public static void getHeader(dom.XmlNode node, string MTrackerName){
        //CH05.old //OrgId = node.getChildElement('OrgId', null).gettext();
        OrgId = system.label.EON_Sanbox_Name; //CH05
        
        //RequestId = node.getChildElement('RequestId', toaNS).gettext();
        RequestId = node.getChildElement('OrgId', toaNS).gettext();
        String RequestId_MDT = MTrackerName;
        
        RequestDateTime = node.getChildElement('RequestDateTime', toaNS).gettext();
        headerTag = '<b:Header xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:OrgId>'+OrgId+'</b:OrgId><b:RequestDateTime>'+(RequestDateTime!=null && RequestDateTime!= ''?convertStringToDatetime(RequestDateTime).format('yyyy-MM-dd\'T\'HH:mm:ss'):'')+'</b:RequestDateTime><b:RequestId>'+(RequestId_MDT!=null?RequestId_MDT:'')+'</b:RequestId></b:Header>';//CH06
    }

    /**
        convertStringToDatetime(string sDT) - This method is used to convert String to Datetime.
    **/
    public static datetime convertStringToDatetime(string sDT){ // sDT - 2016-01-18 15:47
        try{
            string year = sDT.substring(0,4);//'2008';
            string month = sDT.substring(5,7);//'10';
            string day = sDT.substring(8,10);//'5';
            string hour = sDT.substring(11,13);//'12';
            string minute = sDT.substring(14,16);//'20';
            string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + 00;
            datetime myDate1 = Datetime.valueOf(stringDate);
            datetime myDate = getNewdatetime(myDate1);
            return myDate;
        }catch(exception ex){system.debug('### date conversion exception: '+ex.getMessage()+'\n'+ex.getStackTraceString());return datetime.now();}
    }

    /**
        getNewdatetime(Datetime dt) - This method is used to to add extra hour in datetime for daylight saving.
    **/
    public static Datetime getNewdatetime(Datetime dt){
        DateTime inputDT = dt;
        Integer YearVal = dt.year();
        Date MarchEndDate = date.newInstance(YearVal, 3, 31);
        Date OctEndDate = date.newInstance(YearVal, 10, 31);
        Date StartDate = MarchEndDate.toStartofWeek();
        Date EndDate = OctEndDate.toStartofWeek();
        Datetime DaylightStartDt = datetime.newInstance(StartDate.year(), StartDate.month(), StartDate.day(), 01,00,00);
        Datetime DaylightEndDt = datetime.newInstance(EndDate.year(), EndDate.month(), EndDate.day(), 02,00,00);
        // adding an hour if date faling under day light saving.
        if(inputDT>=DaylightStartDt && inputDT<= DaylightEndDt){
            inputDT=inputDT.addHours(1);
            return inputDT;
        }
        else
            return inputDT;
    }

    /**
        calloutAndPostProcess(String action, String strResponseXML, MIDOS_Data_Tracker__c midosTrackerInst, list<EON_Appointment__c> lstApp, String vRequestId) - This method will make the callout and perform the post callout processes.
    **/
    private static void calloutAndPostProcess(String action, String strResponseXML, MIDOS_Data_Tracker__c midosTrackerInst, list<EON_Appointment__c> lstApp){
        //Prepare request
        HttpRequest req = new HttpRequest();
        //A response object is generated as a result of the request
        HttpResponse res = new HttpResponse();
        //New http object to send the request object
        Http http = new Http();
        //Set HTTPRequest header properties
        req.setHeader('Content-Type','text/xml;charset=utf-8');
        req.setHeader('SOAPAction', Action.trim());//CH06
        req.setEndpoint(system.label.EON_MIDOS_Endpoint);//CH06
        //Set HTTPRequest Method
        req.setMethod('POST');
        //Set the HTTPRequest body
        req.setBody(strResponseXML);
        req.setTimeout(120000);
        //Update MIDOS Data Tracker record with Request
        if(!lstApp.isEmpty() && lstApp.size()>0){midosTrackerInst.Appointment_Number__c = lstApp[0].id;}
        midosTrackerInst.Request_Data__c = Eon_Utility.validateStringLength(string.valueOf(req.getbody().substringBetween(bodyStartTag,'</s:Body>')));
        //Execute web service call
        res = http.send(req);
        //Update MIDOS Data Tracker record with Response.
        midosTrackerInst.Response_Data__c = res.getBody(); 
        if(midosTrackerInst.Response_Data__c != null && (midosTrackerInst.Response_Data__c.contains('MessageType>Information</') || midosTrackerInst.Response_Data__c.contains('MessageType>Warning</'))){midosTrackerInst.Status__c = EON_Utility.RESULT_PASS;}
        else {midosTrackerInst.Status__c = EON_Utility.RESULT_FAIL;}
        //To cover exception in test class
        if(EON_Utility.genException != null && EON_Utility.genException) midosTrackerInst.Appointment_Number__c = 'test';
        //Update the record
        update midosTrackerInst;
        //Tracking the complete request as an attachment for MIDOSRequestOut.
        EON_Utility.createAttachment(midosTrackerInst.id,strResponseXML, midosTrackerInst.id);
    }

    /**
        exceptionAndPostProcess(Exception ex, MIDOS_Data_Tracker__c midosTrackerInst) - This method will be called in case an exception occurs and update the tracker record accordningly.
    **/
    private static void exceptionAndPostProcess(Exception ex, MIDOS_Data_Tracker__c midosTrackerInst){
        system.debug('### Data creation exc: '+ex.getMessage()+' \n'+ex.getStackTraceString());
        midosTrackerInst.Response_Data__c = ex.getMessage()+' \n'+ex.getStackTraceString();
        midosTrackerInst.Status__c = EON_Utility.RESULT_FAIL;
        //CH09.start
        if(Test.isrunningTest()) midosTrackerInst.Response_Data__c ='Read Timed Out';
        if(midosTrackerInst.Response_Data__c != null && (midosTrackerInst.Response_Data__c.containsIgnoreCase('Read timed out'))){
            EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
            objWrap.Subject = 'MIDOS Failure Update';
            objWrap.midosId = midosTrackerInst.Id;
            EON_MIDOS_To_Isis_Wrapper.HeaderElement head = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
            head.RequestId = midosTrackerInst.Appointment_Number__c;
            objWrap.Header = head;
            EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        }
        //CH09.End 
        upsert midosTrackerInst;
    }
    
    //CH15.Start
    /*
        sendConfigAsset(string midosTrackeId, string xmlFile) -- This method is used to send data to MIDOS received from Oracle for subject = 'ConfigureSMSAsset'
    */
    //@future(callout=true)
    public static String sendConfigAsset1(string xmlFile){
        //CH17.Start
        map<string, List<EON_SSC_Register__c>> mapRegID = new map<string, List<EON_SSC_Register__c>>();
        List<EON_SSC__c> eSSC = [Select id, Name,(select id,S1_Register_ID__c,TPR__c from EON_SSC_Registers__r) from EON_SSC__c where Type__c='Smart'];
        for(EON_SSC__c es :eSSC){
            mapRegID.put(es.Name,es.EON_SSC_Registers__r);
        }
        //CH17.End
        
        list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>();
        MIDOS_Data_Tracker__c MIDOSTRACKER = new MIDOS_Data_Tracker__c(Direction__c=Eon_Utility.DIRECTION_OUT, Command__c='ConfigureSMSAsset');
        try{
            //Get Midos Data Tracker record
            //lstTrack = [select id, name, Request_Data__c, Response_Data__c, Status__c, Transaction_ID__c from MIDOS_Data_Tracker__c where id=:midosTrackeId];
            dom.XmlNode[] xmlBody1 = getXmlBody(xmlFile);
            dom.XmlNode[] xmlBody = xmlBody1[0].getChildElements(); //Get the root SMSAssetConfiguration
            string xmlBody_ele = xmlBody[0].getName();
            //Extract Header information
            MIDOSTRACKER.Transaction_Id__c = EON_Utility.GenUniqueNum().Right(20);
            getHeader(xmlBody[0],MIDOSTRACKER.Transaction_Id__c);
            system.debug('@@@ OrgId: '+OrgId);
            system.debug('@@@ RequestId: '+RequestId);
            system.debug('@@@ RequestDateTime: '+RequestDateTime);
            system.debug('@@@ headerTag: '+ headerTag);
            //Get appointment
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where Name =: RequestId]);
            string strResponseXML = '';
            strResponseXML = bodyStartTag + '<ConfigureSmsAsset xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request>';//CH06
            //Iterate through whole xml to fetch and map data
            String ESerialNumber=''; String GSerialNumber=''; String HSerialNumber=''; String ISerialNumber='';
            String EAssetSubType=''; String GAssetSubType=''; String HAssetSubType=''; String IAssetSubType='';
            String EAssetType=''; String GAssetType=''; String HAssetType=''; String IAssetType='';
            String Mpan=''; String Mprn=''; string Ssc=''; 
            String strResponseRegister='';
            for(Dom.XmlNode node : xmlBody){
                if(node.getName().containsIgnoreCase('Header'))continue;
                system.debug('*** node name: '+node.getName()+' value: '+node.getText());
                if(node.getChildren()!=null)
                for(Dom.XmlNode cnode : node.getChildElements()){
                    system.debug('*** child node name: '+cnode.getName()+' value: '+cnode.getText());
                    if(cnode.getName().containsIgnoreCase('SerialNumber')){
                        if(node.getName().containsIgnoreCase('Hub') && cnode.getText() != null)//CH10
                            HSerialNumber = cnode.getText();
                        else if(node.getName().containsIgnoreCase('ElectricMeter') && cnode.getText() != null)//CH10
                            ESerialNumber = cnode.getText();
                        else if(node.getName().containsIgnoreCase('GasMeter') && cnode.getText() != null)//CH10
                            gSerialNumber = cnode.getText();
                        else if(node.getName().containsIgnoreCase('IHD') && cnode.getText() != null)//CH10
                            ISerialNumber = cnode.getText();
                    }
                    if(cnode.getName().containsIgnoreCase('AssetSubType')){
                        if(node.getName().containsIgnoreCase('Hub'))
                            HAssetSubType = cnode.getText();
                        else if(node.getName().containsIgnoreCase('ElectricMeter'))
                            EAssetSubType =cnode.getText();
                        else if(node.getName().containsIgnoreCase('GasMeter'))
                            GAssetSubType =cnode.getText();
                        else if(node.getName().containsIgnoreCase('IHD'))
                            IAssetSubType = cnode.getText();
                    }
                    if(cnode.getName().containsIgnoreCase('AssetType')){
                        if(node.getName().containsIgnoreCase('Hub'))
                            HAssetType = cnode.getText();
                        else if(node.getName().containsIgnoreCase('ElectricMeter'))
                            EAssetType =cnode.getText();
                        else if(node.getName().containsIgnoreCase('GasMeter'))
                            GAssetType =cnode.getText();
                        else if(node.getName().containsIgnoreCase('IHD'))
                            IAssetType = cnode.getText();
                    }
                    if(cnode.getName().containsIgnoreCase('MPAN'))
                        Mpan = cnode.getText();
                    if(cnode.getName().containsIgnoreCase('SSC'))
                        Ssc = cnode.getText();
                    if(cnode.getName().containsIgnoreCase('MPRN'))
                        Mprn =cnode.getText();
                    if(cnode.getChildren()!=null)
                    for(Dom.XmlNode gcnode : cnode.getChildElements()){
                        String regid='';
                        String tpr='';
                        system.debug('*** grand child node name: '+gcnode.getName()+' value: '+gcnode.getText());
                        for(Dom.XmlNode gccnode : gcnode.getChildElements()){
                            system.debug('*** grand grand child node name: '+gccnode.getName()+' value: '+gccnode.getText());
                            if(gccnode.getName().containsIgnoreCase('RegisterId'))
                               regid= gccnode.getText();
                            if(gccnode.getName().containsIgnoreCase('TPR'))
                               Tpr= gccnode.getText();
                        }
                        if(regid!=null && regid!=''){
                            //CH11.Start
                            /*
                            String mapRegId = regid;
                            if(HSerialNumber != null && HSerialNumber.length() == 10){
                                Map<String, String> mapEMeterRegisterID = 
                                        EON_Job_Results_Trigger_Helper.getEMeterRegisterIDMap();
                                if(mapEMeterRegisterID.get(regid) != null)                                    
                                    mapRegId = mapEMeterRegisterID.get(regid); 
                            } 
                            */ 
                              //CH17.Start
                              if(HSerialNumber != null && HSerialNumber.length() == 10 && Ssc!='' && Ssc!=null){ 
                               if(mapRegID.containsKey(Ssc)) {
                                   for(EON_SSC_Register__c sr : mapRegID.get(Ssc)){
                                   	  if(Tpr!=null && Tpr!=''){
                                       if(sr.TPR__c==Tpr)
                                           regid=sr.S1_Register_ID__c;
                                   	  }
                                    }
                               }
                            } //CH17.End
                                   
                            //CH11.End
                            strResponseRegister = strResponseRegister+'<b:ElecRegisterDto><b:RegisterId>'+regid+'</b:RegisterId><b:Tpr>'+Tpr+'</b:Tpr></b:ElecRegisterDto>';//CH06
                        }
                    }
                }
            }
            strResponseXML = strResponseXML +'<b:ElecMeter xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:AssetSubType>'+EAssetSubType+'</b:AssetSubType><b:AssetType>'+EAssetType+'</b:AssetType><b:SerialNumber>'+ESerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber><b:Mpan>'+mpan+'</b:Mpan><b:Registers>'+strResponseRegister+'</b:Registers>';//CH06 //CH10 //CH12
            strResponseXML = strResponseXML +'<b:Ssc>'+ssc+'</b:Ssc></b:ElecMeter>';
       //CH08.Start
       if(GSerialNumber!=null && GSerialNumber!='')
       strResponseXML = strResponseXML +'<b:GasMeter xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:AssetSubType>'+GAssetSubType+'</b:AssetSubType><b:AssetType>'+GAssetType+'</b:AssetType><b:SerialNumber>'+GSerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber><b:Mprn>'+mprn+'</b:Mprn></b:GasMeter>';//CH10 //CH12
        strResponseXML = strResponseXML +headerTag;
         strResponseXML = strResponseXML +'<b:Hub xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:AssetSubType>'+HAssetSubType+'</b:AssetSubType><b:AssetType>'+HAssetType+'</b:AssetType><b:SerialNumber>'+HSerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber></b:Hub>';//CH10 //CH12
         if(ISerialNumber!=null && ISerialNumber!='')
          strResponseXML = strResponseXML +'<b:Ihd xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:AssetSubType>'+IAssetSubType+'</b:AssetSubType><b:AssetType>'+IAssetType+'</b:AssetType><b:SerialNumber>'+ISerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber></b:Ihd>';//CH10 //CH12
          strResponseXML = strResponseXML +'</request></ConfigureSmsAsset></s:Body>';//CH06
        //CH08.end

            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/ConfigureSmsAsset';//CH06
            strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,strResponseXML);//CH06
            String midosID = calloutAndPostProcess1(Action,strResponseXML,(MIDOSTRACKER),lstApp);//CH06
            return midosID;
        }catch(exception ex){
            exceptionAndPostProcess1(ex,MIDOSTRACKER);
        }
        return null;
    }
    
    
    /*
        sendValidateSMSAsset1(string midosTrackeId, string xmlFile) -- This method is used to send data to MIDOS received from Oracle for subject = 'ValidateSMSAsset'
    */
    //@future(callout=true)
    public static String sendValidateSMSAsset1(string xmlFile){
        list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>();
        MIDOS_Data_Tracker__c MIDOSTRACKER = new MIDOS_Data_Tracker__c(Direction__c=Eon_Utility.DIRECTION_OUT, Command__c='ValidateSMSAsset');
        try{
            //Get Midos Data Tracker record
            //lstTrack = [select id, name, Request_Data__c, Response_Data__c, Status__c, Transaction_ID__c from MIDOS_Data_Tracker__c where id=:midosTrackeId];
            dom.XmlNode[] xmlBody1 = getXmlBody(xmlFile);
            dom.XmlNode[] xmlBody = xmlBody1[0].getChildElements(); //Get the root SMSAssetValidation
            string xmlBody_ele = xmlBody[0].getName();
            //Extract Header information
            MIDOSTRACKER.Transaction_Id__c = EON_Utility.GenUniqueNum().Right(20);
            getHeader(xmlBody[0],MIDOSTRACKER.Transaction_Id__c);
            system.debug('@@@ OrgId: '+OrgId);
            system.debug('@@@ RequestId: '+RequestId);
            system.debug('@@@ RequestDateTime: '+RequestDateTime);
            system.debug('@@@ headerTag: '+ headerTag);
            //Get appointment
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where Name =: RequestId]);
            string strResponseXML = '';
            strResponseXML = bodyStartTag + '<ValidateSmsAsset xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request>';//CH06
            strResponseXML =strResponseXML +'<b:Assets xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa">';//CH06
            //Iterate through whole xml to fetch and map data
            for(Dom.XmlNode node : xmlBody){
                if(node.getName().containsIgnoreCase('Header'))continue;
                system.debug('*** node name: '+node.getName()+' value: '+node.getText());
                if(node.getChildren()!=null)
                for(Dom.XmlNode cnode : node.getChildElements()){
                    system.debug('*** child node name: '+cnode.getName()+' value: '+cnode.getText());
                    if(cnode.getChildren() != null){
                        String AssetType='';
                        String AssetSubType='';
                        String SerialNumber='';
                        for(Dom.XmlNode gcnode : cnode.getChildElements()){
                            system.debug('*** grand child node name: '+gcnode.getName()+' value: '+gcnode.getText());
                            if(gcnode.getName().containsIgnoreCase('AssetSubType'))
                                AssetSubType =gcnode.getText(); 
                            if(gcnode.getName().containsIgnoreCase('AssetType'))
                                AssetType =gcnode.getText();
                            if(gcnode.getName().containsIgnoreCase('SerialNumber') && gcnode.getText() != null)//CH10
                                SerialNumber=gcnode.getText();
                        }
            if(SerialNumber!=null && SerialNumber!='')//CH07 //CH12 for line 323
                        strResponseXML =strResponseXML +'<b:AssetDto><b:AssetSubType>'+AssetSubType+'</b:AssetSubType><b:AssetType>'+AssetType+'</b:AssetType><b:SerialNumber>'+SerialNumber.toupperCase().replace('-', '')+'</b:SerialNumber></b:AssetDto>';//CH06//CH10
                    }
                }
            }
            strResponseXML = strResponseXML +'</b:Assets>'+headerTag+'</request></ValidateSmsAsset></s:Body>';//CH06
            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/ValidateSmsAsset';//CH06
            strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,strResponseXML);//CH06
            system.debug('@@ Request in xml format :->'+strResponseXML );
            String midosID = calloutAndPostProcess1(Action,strResponseXML,(MIDOSTRACKER),lstApp);//CH06
            return midosID;
        }catch(exception ex){
            exceptionAndPostProcess1(ex,MIDOSTRACKER);
        }
        return null;
    }    
    
    /**
        calloutAndPostProcess(String action, String strResponseXML, MIDOS_Data_Tracker__c midosTrackerInst, list<EON_Appointment__c> lstApp, String vRequestId) - This method will make the callout and perform the post callout processes.
    **/
    private static String calloutAndPostProcess1(String action, String strResponseXML, 
                                        MIDOS_Data_Tracker__c midosTrackerInst, list<EON_Appointment__c> lstApp){
        //Prepare request
        HttpRequest req = new HttpRequest();
        //A response object is generated as a result of the request
        HttpResponse res = new HttpResponse();
        //New http object to send the request object
        Http http = new Http();
        //Set HTTPRequest header properties
        req.setHeader('Content-Type','text/xml;charset=utf-8');
        req.setHeader('SOAPAction', Action.trim());//CH06
        req.setEndpoint(system.label.EON_MIDOS_Endpoint);
        //Set HTTPRequest Method
        req.setMethod('POST');
        //Set the HTTPRequest body
        req.setBody(strResponseXML);
        req.setTimeout(120000);
        //Update MIDOS Data Tracker record with Request
        if(!lstApp.isEmpty() && lstApp.size()>0){midosTrackerInst.Appointment_Number__c = lstApp[0].id;}
        midosTrackerInst.Request_Data__c = Eon_Utility.validateStringLength(string.valueOf(req.getbody().substringBetween(bodyStartTag,'</s:Body>')));
        //Execute web service call
        res = http.send(req);
        //Update MIDOS Data Tracker record with Response.
        midosTrackerInst.Response_Data__c = res.getBody(); 
        if(midosTrackerInst.Response_Data__c != null && (midosTrackerInst.Response_Data__c.contains('MessageType>Information</') || midosTrackerInst.Response_Data__c.contains('MessageType>Warning</'))){midosTrackerInst.Status__c = EON_Utility.RESULT_PASS;}
        else {midosTrackerInst.Status__c = EON_Utility.RESULT_FAIL;}
        //To cover exception in test class
        if(EON_Utility.genException != null && EON_Utility.genException) midosTrackerInst.Appointment_Number__c = 'test';
        //Update the record
        upsert midosTrackerInst;
        //Tracking the complete request as an attachment for MIDOSRequestOut.
        EON_Utility.createAttachment(midosTrackerInst.id,strResponseXML, midosTrackerInst.id);
        return midosTrackerInst.id;
    }  
    
    private static String exceptionAndPostProcess1(Exception ex, MIDOS_Data_Tracker__c midosTrackerInst){
        system.debug('### Data creation exc: '+ex.getMessage()+' \n'+ex.getStackTraceString());
        midosTrackerInst.Response_Data__c = ex.getMessage()+' \n'+ex.getStackTraceString();
        midosTrackerInst.Status__c = EON_Utility.RESULT_FAIL;
        //midosTrackerInst.Request_Data__c = Eon_Utility.validateStringLength(string.valueOf(req.getbody().substringBetween(bodyStartTag,'</s:Body>')));
        //CH09.start
        if(Test.isrunningTest()) midosTrackerInst.Response_Data__c ='Read Timed Out';
        if(midosTrackerInst.Response_Data__c != null && (midosTrackerInst.Response_Data__c.containsIgnoreCase('Read timed out'))){
            EON_MIDOS_To_Isis_Wrapper objWrap = new EON_MIDOS_To_Isis_Wrapper();
            objWrap.Subject = 'MIDOS Failure Update';
            objWrap.midosId = midosTrackerInst.Id;
            EON_MIDOS_To_Isis_Wrapper.HeaderElement head = new EON_MIDOS_To_Isis_Wrapper.HeaderElement();
            head.RequestId = midosTrackerInst.Appointment_Number__c;
            objWrap.Header = head;
            EON_MIDOS_to_OFSC.sendToOFSC(objWrap);
        }
        //CH09.End 
        upsert midosTrackerInst;
        return midosTrackerInst.id;
    }
    //CH15.End
    
    //CH13.Start
    /**
        sendUnConfigSMSAsset(string xmlFile) - New method for UnConfigureSMSAsset 
    **/
    public static String sendUnConfigSMSAsset(string xmlFile){
        list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>();
        MIDOS_Data_Tracker__c MIDOSTRACKER = new MIDOS_Data_Tracker__c(Direction__c=Eon_Utility.DIRECTION_OUT, Command__c='UnConfigureSMSAsset');
        try{
            //Get Midos Data Tracker record
            //lstTrack = [select id, name, Request_Data__c, Response_Data__c, Status__c, Transaction_ID__c from MIDOS_Data_Tracker__c where id=:midosTrackeId];
            dom.XmlNode[] xmlBody1 = getXmlBody(xmlFile);
            dom.XmlNode[] xmlBody = xmlBody1[0].getChildElements(); //Get the root SMSAssetConfiguration
            string xmlBody_ele = xmlBody[0].getName();
            //Extract Header information
            MIDOSTRACKER.Transaction_Id__c = EON_Utility.GenUniqueNum().Right(20);
            getHeader(xmlBody[0],MIDOSTRACKER.Transaction_Id__c);
            system.debug('@@@ OrgId: '+OrgId);
            system.debug('@@@ RequestId: '+RequestId);
            system.debug('@@@ RequestDateTime: '+RequestDateTime);
            system.debug('@@@ headerTag: '+ headerTag);
            //Get appointment
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where Name =: RequestId]);
            string strResponseXML = '';
            strResponseXML = bodyStartTag + '<UnConfigureSmsAsset xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request>';//CH06
            //Iterate through whole xml to fetch and map data
            String ESerialNumber=''; String GSerialNumber=''; String HSerialNumber=''; String ISerialNumber='';
            String EAssetSubType=''; String GAssetSubType=''; String HAssetSubType=''; String IAssetSubType='';
            String EAssetType=''; String GAssetType=''; String HAssetType=''; String IAssetType='';
            String Mpan=''; String Mprn=''; string Ssc=''; 
            String strResponseRegister='';
            for(Dom.XmlNode node : xmlBody){
                if(node.getName().containsIgnoreCase('Header'))continue;
                system.debug('*** node name: '+node.getName()+' value: '+node.getText());
                if(node.getChildren()!=null)
                for(Dom.XmlNode cnode : node.getChildElements()){
                    system.debug('*** child node name: '+cnode.getName()+' value: '+cnode.getText());
                    if(cnode.getName().containsIgnoreCase('SerialNumber')){
                        if(node.getName().containsIgnoreCase('Hub') && cnode.getText() != null)//CH10
                            HSerialNumber = cnode.getText();
                        else if(node.getName().containsIgnoreCase('ElectricMeter') && cnode.getText() != null)//CH10
                            ESerialNumber = cnode.getText();
                        else if(node.getName().containsIgnoreCase('GasMeter') && cnode.getText() != null)//CH10
                            gSerialNumber = cnode.getText();
                        else if(node.getName().containsIgnoreCase('IHD') && cnode.getText() != null)//CH10
                            ISerialNumber = cnode.getText();
                    }
                    if(cnode.getName().containsIgnoreCase('AssetSubType')){
                        if(node.getName().containsIgnoreCase('Hub'))
                            HAssetSubType = cnode.getText();
                        else if(node.getName().containsIgnoreCase('ElectricMeter'))
                            EAssetSubType =cnode.getText();
                        else if(node.getName().containsIgnoreCase('GasMeter'))
                            GAssetSubType =cnode.getText();
                        else if(node.getName().containsIgnoreCase('IHD'))
                            IAssetSubType = cnode.getText();
                    }
                    if(cnode.getName().containsIgnoreCase('AssetType')){
                        if(node.getName().containsIgnoreCase('Hub'))
                            HAssetType = cnode.getText();
                        else if(node.getName().containsIgnoreCase('ElectricMeter'))
                            EAssetType =cnode.getText();
                        else if(node.getName().containsIgnoreCase('GasMeter'))
                            GAssetType =cnode.getText();
                        else if(node.getName().containsIgnoreCase('IHD'))
                            IAssetType = cnode.getText();
                    }
                    if(cnode.getName().containsIgnoreCase('MPAN'))
                        Mpan = cnode.getText();
                    if(cnode.getName().containsIgnoreCase('SSC'))
                        Ssc = cnode.getText();
                    if(cnode.getName().containsIgnoreCase('MPRN'))
                        Mprn =cnode.getText();
                    if(cnode.getChildren()!=null)
                    for(Dom.XmlNode gcnode : cnode.getChildElements()){
                        String regid='';
                        String tpr='';
                        system.debug('*** grand child node name: '+gcnode.getName()+' value: '+gcnode.getText());
                        for(Dom.XmlNode gccnode : gcnode.getChildElements()){
                            system.debug('*** grand grand child node name: '+gccnode.getName()+' value: '+gccnode.getText());
                            if(gccnode.getName().containsIgnoreCase('RegisterId'))
                               regid= gccnode.getText();
                            if(gccnode.getName().containsIgnoreCase('TPR'))
                               Tpr= gccnode.getText();
                        }
 
                    }
                }
            }
            strResponseXML = strResponseXML +'<b:ElecMeter xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:SerialNumber>'+ESerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber><b:Mpan>'+mpan+'</b:Mpan>';
            strResponseXML = strResponseXML +'</b:ElecMeter>';
       //CH08.Start
       if(GSerialNumber!=null && GSerialNumber!='')
       strResponseXML = strResponseXML +'<b:GasMeter xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:SerialNumber>'+GSerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber><b:Mprn>'+mprn+'</b:Mprn></b:GasMeter>';
        strResponseXML = strResponseXML +headerTag;
         strResponseXML = strResponseXML +'<b:Hub xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:SerialNumber>'+HSerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber></b:Hub>';
         if(ISerialNumber!=null && ISerialNumber!='')
          strResponseXML = strResponseXML +'<b:Ihd xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:SerialNumber>'+ISerialNumber.toUpperCase().replace('-', '')+'</b:SerialNumber></b:Ihd>';
          strResponseXML = strResponseXML +'</request></UnConfigureSmsAsset></s:Body>';
        
            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/UnConfigureSmsAsset';
            strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,strResponseXML);
            String midosID = calloutAndPostProcess1(Action,strResponseXML,(MIDOSTRACKER),lstApp);
            return midosID;
        }catch(exception ex){
            exceptionAndPostProcess1(ex,MIDOSTRACKER);
        }
        return null;
    }     
    //CH13.End
    
    //CH16.Start
    /*
        sendCreditMeter1(string midosTrackeId, string xmlFile, integer noOfMeters) -- This method is used to send data to MIDOS received from Oracle for subject = 'SubmitCreditMeterReading'
    */
    public static MIDOS_Data_Tracker__c sendCreditMeter1(string xmlFile, integer noOfMeters){
        list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>();
        MIDOS_Data_Tracker__c MIDOSTRACKER = new MIDOS_Data_Tracker__c(Direction__c=Eon_Utility.DIRECTION_OUT, Command__c='SubmitCreditMeterReading');

        try{
            //Get Midos Data Tracker record
            //lstTrack = [select id, name, Request_Data__c, Response_Data__c, Status__c, Transaction_ID__c from MIDOS_Data_Tracker__c where id=:midosTrackeId];
            dom.XmlNode[] xmlBody1 = getXmlBody(xmlFile);
            dom.XmlNode[] xmlBody = xmlBody1[0].getChildElements(); //Get the root CreditMeterReading
            string xmlBody_ele = xmlBody[0].getName();
            //Extract Header information
            MIDOSTRACKER.Transaction_Id__c = EON_Utility.GenUniqueNum().Right(20);
            getHeader(xmlBody[0],MIDOSTRACKER.Transaction_Id__c);
            system.debug('@@@ OrgId: '+ OrgId);
            system.debug('@@@ RequestId: '+ RequestId);
            system.debug('@@@ RequestDateTime: '+ RequestDateTime);
            system.debug('@@@ headerTag: '+ headerTag);
            //Get appointment
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where Name =: RequestId]);
            //Iterate through whole xml to fetch and map data
            integer j =1; //j is used to fetch the exact meter information by comparing with noOfMeters.//CH03
            String mpan=''; String mprn=''; String SerialNumber =''; String StrRegisters='';
            for(Dom.XmlNode node : xmlBody){
                if(node.getName().containsIgnoreCase('Header'))continue;
                if(j!=noOfMeters){j++;continue;}//CH03
                system.debug('*** node name: '+node.getName()+' value: '+node.getText());
                if(node.getChildren()!=null)
                for(Dom.XmlNode cnode : node.getChildElements()){
                    system.debug('*** child node name: '+cnode.getName()+' value: '+cnode.getText());
                    if(cnode.getName().containsIgnoreCase('MPAN'))
                        Mpan=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('SerialNumber'))
                        SerialNumber=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('MPRN'))
                        Mprn=cnode.getText();
                    if(cnode.getChildren()!=null)
                    for(Dom.XmlNode gcnode : cnode.getChildElements()){
                        system.debug('*** grand child node name: '+gcnode.getName()+' value: '+gcnode.getText());
                        String RegisterRead=''; String RegisterId='';
                        for(Dom.XmlNode gccnode : gcnode.getChildElements()){
                            system.debug('*** grand grand child node name: '+gccnode.getName()+' value: '+gccnode.getText());
                            if(gccnode.getName().containsIgnoreCase('RegisterId'))
                                RegisterId= gccnode.getText();
                            if(gccnode.getName().containsIgnoreCase('RegisterRead'))
                               RegisterRead=gccnode.getText();//RegisterRead= string.isNotBlank(gccnode.getText())?gccnode.getText():'0';//CH08
                        }
                       if(!String.isBlank(RegisterRead))//CH08
                        StrRegisters= StrRegisters+'<b:RegisterDto><b:RegisterId>'+RegisterId+'</b:RegisterId><b:RegisterRead>'+RegisterRead+'</b:RegisterRead></b:RegisterDto>';//CH06
                    }
                }
                j++;//CH03
            }
            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/SubmitCreditMeterReading';//CH06
            string strResponseXML = '';
            //CH06
            strResponseXML = bodyStartTag + '<SubmitCreditMeterReading xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request>'+headerTag+'<b:MeterData xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:Mpan>'+Mpan+'</b:Mpan><b:Mprn>'+Mprn+'</b:Mprn><b:Registers>'+StrRegisters+'</b:Registers><b:SerialNumber>'+SerialNumber+'</b:SerialNumber></b:MeterData></request></SubmitCreditMeterReading></s:Body>';//CH06
            system.debug('@@ Request in xml format :->'+strResponseXML );
            strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,strResponseXML);//CH06
            MIDOS_Data_Tracker__c midosTRACKERRec = calloutAndPostProcess_Direct(Action,strResponseXML,(MIDOSTRACKER),lstApp);//CH06
            return midosTRACKERRec;
        }catch(exception ex){
            exceptionAndPostProcess(ex,MIDOSTRACKER);
        }
        return null;
    }   
    
    /*
        sendPrePayBalance1(string midosTrackeId, string xmlFile, integer noOfMeters) -- This method is used to send data to MIDOS received from Oracle for subject = 'SubmitPrePayBalance'
    */
    public static MIDOS_Data_Tracker__c sendPrePayBalance1(String xmlFile, integer noOfMeters){
        list<MIDOS_Data_Tracker__c> lstTrack = new list<MIDOS_Data_Tracker__c>();
        MIDOS_Data_Tracker__c MIDOSTRACKER = new MIDOS_Data_Tracker__c(Direction__c=Eon_Utility.DIRECTION_OUT, Command__c='SubmitPrePayBalance');
        
        try{
            //Get Midos Data Tracker record
            //lstTrack = [select id, name, Request_Data__c, Response_Data__c, Status__c, Transaction_ID__c from MIDOS_Data_Tracker__c where id=:midosTrackeId];
            dom.XmlNode[] xmlBody1 = getXmlBody(xmlFile);
            dom.XmlNode[] xmlBody = xmlBody1[0].getChildElements(); //Get the root PrePayMeterBalance
            string xmlBody_ele = xmlBody[0].getName();
            MIDOSTRACKER.Transaction_Id__c = EON_Utility.GenUniqueNum().Right(20);
            //Extract Header information
            getHeader(xmlBody[0], MIDOSTRACKER.Transaction_Id__c);
            system.debug('@@@ OrgId: '+OrgId);
            system.debug('@@@ RequestId: '+RequestId);
            system.debug('@@@ RequestDateTime: '+RequestDateTime);
            system.debug('@@@ headerTag: '+ headerTag);
            //Get appointment
            list<EON_Appointment__c> lstApp = new list<EON_Appointment__c>([select id, name from EON_Appointment__c where Name =: RequestId]);
            string strResponseXML = '';
            strResponseXML = bodyStartTag + '<SubmitPrePayBalance xmlns="http://schemas.eonenergy.com/services/appointmentmanagement/ooa"><request>';//CH06
            //Iterate through whole xml to fetch and map data
            String DeviceType='';
            String Mpan='';
            String Mprn='';
            String SerialNumber='';
            String CurrentBalance='';
            String TotalDebt='';
            integer j =1; //j is used to fetch the exact meter information by comparing with noOfMeters.
            for(Dom.XmlNode node : xmlBody){
                if(node.getName().containsIgnoreCase('Header'))continue;
                if(j!=noOfMeters){j++;continue;}
                system.debug('*** node name: '+node.getName()+' value: '+node.getText());
                if(node.getChildren()!=null)
                for(Dom.XmlNode cnode : node.getChildElements()){
                    system.debug('*** child node name: '+cnode.getName()+' value: '+cnode.getText());
                    if(cnode.getName().containsIgnoreCase('DeviceType'))
                        DeviceType=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('MPAN'))
                        Mpan=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('MPRN'))
                        Mprn=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('SerialNumber'))
                        SerialNumber=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('CurrentBalance') && string.isNotBlank(cnode.getText()))
                        CurrentBalance=cnode.getText();
                    if(cnode.getName().containsIgnoreCase('TotalDebt') && string.isNotBlank(cnode.getText()))
                        TotalDebt=cnode.getText();
                }
                j++;
            }
            strResponseXML = strResponseXML +'<b:BalanceData xmlns:b="http://schemas.eonenergy.com/data/appointmentmanagement/ooa"><b:CurrentBalance>'+CurrentBalance+'</b:CurrentBalance><b:DeviceType>'+DeviceType+'</b:DeviceType><b:Mpan>'+Mpan+'</b:Mpan><b:Mprn>'+Mprn+'</b:Mprn><b:SerialNumber>'+SerialNumber+'</b:SerialNumber><b:TotalDebt>'+TotalDebt+'</b:TotalDebt></b:BalanceData>'+headerTag+'</request></SubmitPrePayBalance></s:Body>';//CH06
            system.debug('@@ Request in xml format :->'+strResponseXML );
            String Action = 'http://schemas.eonenergy.com/services/appointmentmanagement/ooa/IOutOfAreaInstallationInboundService/SubmitPrePayBalance';//CH06
            strResponseXML = EON_WSSGlobalHeaderGenerator.generateXMLResponse(Action,strResponseXML);//CH06
            MIDOS_Data_Tracker__c MIDOSTRCKER = calloutAndPostProcess_Direct(Action,strResponseXML,MIDOSTRACKER,lstApp);//CH06
            return MIDOSTRCKER;
        }catch(exception ex){
            MIDOSTRACKER.Response_Data__c = ex.getStackTraceString() + '\n' + ex.getMessage()+'\n'+xmlFile;
            exceptionAndPostProcess(ex,MIDOSTRACKER);
            
        }
        return MIDOSTRACKER;
    }     
    //CH16.End  
    
    
    /**
        calloutAndPostProcess_Direct(String action, String strResponseXML, MIDOS_Data_Tracker__c midosTrackerInst, list<EON_Appointment__c> lstApp, String vRequestId) - This method will make the callout and perform the post callout processes.
    **/
    private static MIDOS_Data_Tracker__c calloutAndPostProcess_Direct(String action, String strResponseXML, 
                                        MIDOS_Data_Tracker__c midosTrackerInst, list<EON_Appointment__c> lstApp){
        //Prepare request
        HttpRequest req = new HttpRequest();
        //A response object is generated as a result of the request
        HttpResponse res = new HttpResponse();
        //New http object to send the request object
        Http http = new Http();
        //Set HTTPRequest header properties
        req.setHeader('Content-Type','text/xml;charset=utf-8');
        req.setHeader('SOAPAction', Action.trim());//CH06
        req.setEndpoint(system.label.EON_MIDOS_Endpoint);
        //Set HTTPRequest Method
        req.setMethod('POST');
        //Set the HTTPRequest body
        req.setBody(strResponseXML);
        req.setTimeout(120000);
        //Update MIDOS Data Tracker record with Request
        if(!lstApp.isEmpty() && lstApp.size()>0){midosTrackerInst.Appointment_Number__c = lstApp[0].id;}
        midosTrackerInst.Request_Data__c = Eon_Utility.validateStringLength(string.valueOf(req.getbody().substringBetween(bodyStartTag,'</s:Body>')));
        //Execute web service call
        res = http.send(req);
        //Update MIDOS Data Tracker record with Response.
        midosTrackerInst.Response_Data__c = res.getBody(); 
        if(midosTrackerInst.Response_Data__c != null && (midosTrackerInst.Response_Data__c.contains('MessageType>Information</') || midosTrackerInst.Response_Data__c.contains('MessageType>Warning</'))){midosTrackerInst.Status__c = EON_Utility.RESULT_PASS;}
        else {midosTrackerInst.Status__c = EON_Utility.RESULT_FAIL;}
        //To cover exception in test class
        if(EON_Utility.genException != null && EON_Utility.genException) midosTrackerInst.Appointment_Number__c = 'test';
        //Update the record
        //upsert midosTrackerInst;
        //Tracking the complete request as an attachment for MIDOSRequestOut.
        //EON_Utility.createAttachment(midosTrackerInst.id,strResponseXML, midosTrackerInst.id);
        return midosTrackerInst;
    }      
              
}