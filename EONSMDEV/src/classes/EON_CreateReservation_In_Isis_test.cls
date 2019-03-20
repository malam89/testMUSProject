/**
    Description : This test class covers the code coverage for below class
        1. EON_CreateReservation_In_Isis_WS
**/
/*
    Created By : Nitin Bangar
    Created Date : 30-March-2016
    Service Request : SR_EON_AB_017
    Change History:
        CH01 # 25/10/2016 # Mahadev J # Improved test coverage
*/
@isTest
global class EON_CreateReservation_In_Isis_test implements WebServiceMock{
    public static string functionType = '';
    public static boolean genException = false;
    public static boolean DateLessThanToday = false;
    public static string EffectiveFromDate = '';
    public static string EffectiveToDate = '';
    public static boolean isMAM = true;
    public static boolean isGetMPAN = true;
    public static boolean isGetMPRN = true;
    public static boolean isGetOFSC = true;
    public static string NumOfPhases = '1';
    public static boolean coverUncovered = false;
    /*
        PostitiveTest(): Postive test scenario
    */
    static testmethod void PostitiveTest(){
        EON_Vulnerability_Code__c vCode = new EON_Vulnerability_Code__c();
        vCode.Name = 'test';
        vCode.Vulnerability_Code__c = 11;
        vCode.JUMBO_Vulnerability_Code__c = 11;
        insert vCode;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c fuel = new EON_Fuel__c(Premise__c = eSite.ID, MPRN__c='123', MPAN__c='123', Gas_supplier_code__c='STGL');
        insert fuel;
        
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
                
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name='Test1PH', Elec_Meter_Type__c='Test', Elec_Phase__c='1PH', Work_Skill__c='Elec3');
        insert eCapCategory;
        
        EON_Job__c job = new EON_Job__c(Name = 'smart', Description__c = 'Test describe', Job_Type__c = 'Smart',MAM_Reqd__c = false ,MOP_Reqd__c = true ,MPAN_Reqd__c = true ,MPRN_Reqd__c = true);
        insert job;
        
        list<EON_Job_Attribute__c> allJobAttr = new list<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Phase',Duration__c =0, Value__c = '3PH');
        allJobAttr.add(ejobAtt);
        EON_Job_Attribute__c ejobAtt1 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'ELECMETERTYPE',Duration__c =0, Value__c = 'KEY');
        allJobAttr.add(ejobAtt1);
        EON_Job_Attribute__c ejobAtt2 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'GASMETERTYPE',Duration__c =0, Value__c = 'MS1');
        allJobAttr.add(ejobAtt2);
        EON_Job_Attribute__c ejobAtt3 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'APPTREASON',Duration__c =0, Value__c = 'CUST_REQ');
        allJobAttr.add(ejobAtt3);
        insert allJobAttr;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c(name='0', API__c = 'Inbound', Error_Warning_Success__c = 'warning');
        insert eOFSCResCode;
        
        EON_AttributeName_Field_Mapping__c allAttrMap = new EON_AttributeName_Field_Mapping__c();
        allAttrMap.name = 'APPTREASONCUST_REQ';
        allAttrMap.Appointment_Field_Value__c = 'CUSTOMER REQUEST';
        allAttrMap.Field_Mapping_API_Name__c = 'Appointment_reason_code__c';
        allAttrMap.EON_Attribute_Name__c = 'APPTREASON';
        allAttrMap.EON_Attribute_Value__c = 'CUST_REQ';
        insert allAttrMap;
        
        Eon_Appointment_Reason__c apptReason = new Eon_Appointment_Reason__c(Name='CUSTOMER REQUEST');
        insert apptReason;
        
        EON_CreateReservation_In_Isis_WS controller = new EON_CreateReservation_In_Isis_WS();
        
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '123321';
        appDetailElem.AppointmentDate = System.Today();
        appDetailElem.StartTime = timeElem;
        //appDetailElem.EndTime = timeElem1;
        appDetailElem.TimeSlot = '10:00-12:00';
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = '3PH';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = 'smart'; //Job Test
        jobTypeElem.JobDesc = 'Job desc';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = 'Booking System';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;   
            
        test.startTest();   
        Test.setMock(WebServiceMock.class, new EON_CreateReservation_In_Isis_test());
        EON_CreateReservation_In_Isis_test.functionType ='GetJumbo';
        EON_CreateReservation_In_Isis_test.EffectiveFromDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()-1) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.EffectiveToDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+2) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /*
        PostitiveTest_OutOfEffectiveDates(): Postive test scenario - Appointment booked out of valid effective dates
    */
    static testmethod void PostitiveTest_OutOfEffectiveDates(){
        EON_Vulnerability_Code__c vCode = new EON_Vulnerability_Code__c();
        vCode.Name = 'test';
        vCode.Vulnerability_Code__c = 11;
        vCode.JUMBO_Vulnerability_Code__c = 11;
        insert vCode;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c fuel = new EON_Fuel__c(Premise__c = eSite.ID, MPRN__c='123', MPAN__c='123', Gas_supplier_code__c='STGL');
        insert fuel;
        
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
                
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name='Test1PH', Elec_Meter_Type__c='Test', Elec_Phase__c='1PH', Work_Skill__c='Elec3');
        insert eCapCategory;
        
        //Job Test
        EON_Job__c job = new EON_Job__c(Name = 'smart', Description__c = 'Test describe', Job_Type__c = 'Smart',MAM_Reqd__c = false ,MOP_Reqd__c = true ,MPAN_Reqd__c = true ,MPRN_Reqd__c = true);
        insert job;
        
        list<EON_Job_Attribute__c> allJobAttr = new list<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Phase',Duration__c =0, Value__c = '3PH');
        allJobAttr.add(ejobAtt);
        EON_Job_Attribute__c ejobAtt1 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'ELECMETERTYPE',Duration__c =0, Value__c = 'KEY');
        allJobAttr.add(ejobAtt1);
        EON_Job_Attribute__c ejobAtt2 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'GASMETERTYPE',Duration__c =0, Value__c = 'MS1');
        allJobAttr.add(ejobAtt2);
        EON_Job_Attribute__c ejobAtt3 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'APPTREASON',Duration__c =0, Value__c = 'CUST_REQ');
        allJobAttr.add(ejobAtt3);
        insert allJobAttr;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c(name='0', API__c = 'Inbound', Error_Warning_Success__c = 'warning');
        insert eOFSCResCode;
        
        EON_AttributeName_Field_Mapping__c allAttrMap = new EON_AttributeName_Field_Mapping__c();
        allAttrMap.name = 'APPTREASONCUST_REQ';
        allAttrMap.Appointment_Field_Value__c = 'CUSTOMER REQUEST';
        allAttrMap.Field_Mapping_API_Name__c = 'Appointment_reason_code__c';
        allAttrMap.EON_Attribute_Name__c = 'APPTREASON';
        allAttrMap.EON_Attribute_Value__c = 'CUST_REQ';
        insert allAttrMap;
        
        Eon_Appointment_Reason__c apptReason = new Eon_Appointment_Reason__c(Name='CUSTOMER REQUEST');
        insert apptReason;
        
        EON_CreateReservation_In_Isis_WS controller = new EON_CreateReservation_In_Isis_WS();
        
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '123321';
        appDetailElem.AppointmentDate = System.Today();
        appDetailElem.StartTime = timeElem;
        //appDetailElem.EndTime = timeElem1;
        appDetailElem.TimeSlot = '10:00-12:00';
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = '3PH';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = 'smart'; //Job Test
        jobTypeElem.JobDesc = 'Job desc';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = 'Booking System';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;   
            
        test.startTest();   
        Test.setMock(WebServiceMock.class, new EON_CreateReservation_In_Isis_test());
        EON_CreateReservation_In_Isis_test.functionType ='GetJumbo';
        EON_CreateReservation_In_Isis_test.EffectiveFromDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+1) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.EffectiveToDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+2) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /*
        PostitiveTest1(): Postive test scenario
    */
    static testmethod void PostitiveTest1(){
        EON_Vulnerability_Code__c vCode = new EON_Vulnerability_Code__c();
        vCode.Name = 'test';
        vCode.Vulnerability_Code__c = 11;
        vCode.JUMBO_Vulnerability_Code__c = 11;
        insert vCode;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c fuel = new EON_Fuel__c(Premise__c = eSite.ID, MPRN__c='123', MPAN__c='123', Gas_supplier_code__c='STGL');
        insert fuel;
        
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
                
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name='Test1PH', Elec_Meter_Type__c='Test', Elec_Phase__c='1PH', Work_Skill__c='Elec3');
        insert eCapCategory;
        
        EON_Job__c job = new EON_Job__c(Name = 'smart', Description__c = 'Test describe', Job_Type__c = 'Smart',MAM_Reqd__c = false ,MOP_Reqd__c = true ,MPAN_Reqd__c = true ,MPRN_Reqd__c = true);
        insert job;
        
        list<EON_Job_Attribute__c> allJobAttr = new list<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Phase',Duration__c =0, Value__c = '3PH');
        allJobAttr.add(ejobAtt);
        EON_Job_Attribute__c ejobAtt1 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'ELECMETERTYPE',Duration__c =0, Value__c = 'KEY');
        allJobAttr.add(ejobAtt1);
        EON_Job_Attribute__c ejobAtt2 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'GASMETERTYPE',Duration__c =0, Value__c = 'MS1');
        allJobAttr.add(ejobAtt2);
        EON_Job_Attribute__c ejobAtt3 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'APPTREASON',Duration__c =0, Value__c = 'CUST_REQ');
        allJobAttr.add(ejobAtt3);
        insert allJobAttr;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c(name='0', API__c = 'Inbound', Error_Warning_Success__c = 'warning');
        insert eOFSCResCode;
        
        EON_AttributeName_Field_Mapping__c allAttrMap = new EON_AttributeName_Field_Mapping__c();
        allAttrMap.name = 'APPTREASONCUST_REQ';
        allAttrMap.Appointment_Field_Value__c = 'CUSTOMER REQUEST';
        allAttrMap.Field_Mapping_API_Name__c = 'Appointment_reason_code__c';
        allAttrMap.EON_Attribute_Name__c = 'APPTREASON';
        allAttrMap.EON_Attribute_Value__c = 'CUST_REQ';
        insert allAttrMap;
        
        Eon_Appointment_Reason__c apptReason = new Eon_Appointment_Reason__c(Name='CUSTOMER REQUEST');
        insert apptReason;
        
        EON_CreateReservation_In_Isis_WS controller = new EON_CreateReservation_In_Isis_WS();
        
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '123321';
        appDetailElem.AppointmentDate = System.Today();
        appDetailElem.StartTime = timeElem;
        //appDetailElem.EndTime = timeElem1;
        appDetailElem.TimeSlot = '10:00-12:00';
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = '3PH';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = 'smart'; //Job Test
        jobTypeElem.JobDesc = 'Job desc';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = 'Booking System';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;   
            
        test.startTest();   
        Test.setMock(WebServiceMock.class, new EON_CreateReservation_In_Isis_test());
        EON_CreateReservation_In_Isis_test.functionType ='GetJumbo';
        EON_CreateReservation_In_Isis_test.EffectiveFromDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()-1) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.EffectiveToDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+2) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    
     /*
        PostitiveTest_OutOfEffectiveDates1(): Postive test scenario - Appointment booked out of valid effective dates
    */
    static testmethod void PostitiveTest_OutOfEffectiveDates1(){
        EON_Vulnerability_Code__c vCode = new EON_Vulnerability_Code__c();
        vCode.Name = 'test';
        vCode.Vulnerability_Code__c = 11;
        vCode.JUMBO_Vulnerability_Code__c = 11;
        insert vCode;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c fuel = new EON_Fuel__c(Premise__c = eSite.ID, MPRN__c='123', MPAN__c='123', Gas_supplier_code__c='STGL');
        insert fuel;
        
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
                
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name='Test1PH', Elec_Meter_Type__c='Test', Elec_Phase__c='1PH', Work_Skill__c='Elec3');
        insert eCapCategory;
        
        //Job Test
        EON_Job__c job = new EON_Job__c(Name = 'smart', Description__c = 'Test describe', Job_Type__c = 'Smart',MAM_Reqd__c = false ,MOP_Reqd__c = true ,MPAN_Reqd__c = true ,MPRN_Reqd__c = true);
        insert job;
        
        list<EON_Job_Attribute__c> allJobAttr = new list<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Phase',Duration__c =0, Value__c = '3PH');
        allJobAttr.add(ejobAtt);
        EON_Job_Attribute__c ejobAtt1 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'ELECMETERTYPE',Duration__c =0, Value__c = 'KEY');
        allJobAttr.add(ejobAtt1);
        EON_Job_Attribute__c ejobAtt2 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'GASMETERTYPE',Duration__c =0, Value__c = 'MS1');
        allJobAttr.add(ejobAtt2);
        EON_Job_Attribute__c ejobAtt3 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'APPTREASON',Duration__c =0, Value__c = 'CUST_REQ');
        allJobAttr.add(ejobAtt3);
        insert allJobAttr;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c(name='0', API__c = 'Inbound', Error_Warning_Success__c = 'warning');
        insert eOFSCResCode;
        
        EON_AttributeName_Field_Mapping__c allAttrMap = new EON_AttributeName_Field_Mapping__c();
        allAttrMap.name = 'APPTREASONCUST_REQ';
        allAttrMap.Appointment_Field_Value__c = 'CUSTOMER REQUEST';
        allAttrMap.Field_Mapping_API_Name__c = 'Appointment_reason_code__c';
        allAttrMap.EON_Attribute_Name__c = 'APPTREASON';
        allAttrMap.EON_Attribute_Value__c = 'CUST_REQ';
        insert allAttrMap;
        
        Eon_Appointment_Reason__c apptReason = new Eon_Appointment_Reason__c(Name='CUSTOMER REQUEST');
        insert apptReason;
        
        EON_CreateReservation_In_Isis_WS controller = new EON_CreateReservation_In_Isis_WS();
        
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '123321';
        appDetailElem.AppointmentDate = System.Today();
        appDetailElem.StartTime = timeElem;
        //appDetailElem.EndTime = timeElem1;
        appDetailElem.TimeSlot = '10:00-12:00';
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = '3PH';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = 'smart'; //Job Test
        jobTypeElem.JobDesc = 'Job desc';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = 'Booking System';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;   
            
        test.startTest();   
        Test.setMock(WebServiceMock.class, new EON_CreateReservation_In_Isis_test());
        EON_CreateReservation_In_Isis_test.functionType ='GetJumbo';
        EON_CreateReservation_In_Isis_test.EffectiveFromDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+1) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.EffectiveToDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+2) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /*
        PostitiveTest_ErrorFromOracle(): Postive test scenario where error received from OFSC
    */
    static testmethod void PostitiveTest_ErrorFromOracle(){
        EON_Vulnerability_Code__c vCode = new EON_Vulnerability_Code__c();
        vCode.Name = 'test';
        vCode.Vulnerability_Code__c = 11;
        vCode.JUMBO_Vulnerability_Code__c = 11;
        insert vCode;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c fuel = new EON_Fuel__c(Premise__c = eSite.ID, MPRN__c='123', MPAN__c='123', Gas_supplier_code__c='STGL');
        insert fuel;
        
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
                
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name='Test1PH', Elec_Meter_Type__c='Test', Elec_Phase__c='1PH', Work_Skill__c='Elec3');
        insert eCapCategory;
        
        //Job Test
        EON_Job__c job = new EON_Job__c(Name = 'smart', Description__c = 'Test describe', Job_Type__c = 'Smart',MAM_Reqd__c = false ,MOP_Reqd__c = true ,MPAN_Reqd__c = true ,MPRN_Reqd__c = true);
        insert job;
        
        list<EON_Job_Attribute__c> allJobAttr = new list<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Phase',Duration__c =0, Value__c = '1PH');
        allJobAttr.add(ejobAtt);
        EON_Job_Attribute__c ejobAtt1 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'ELECMETERTYPE',Duration__c =0, Value__c = 'KEY');
        allJobAttr.add(ejobAtt1);
        EON_Job_Attribute__c ejobAtt2 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'GASMETERTYPE',Duration__c =0, Value__c = 'MS1');
        allJobAttr.add(ejobAtt2);
        EON_Job_Attribute__c ejobAtt3 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'APPTREASON',Duration__c =0, Value__c = 'CUST_REQ');
        allJobAttr.add(ejobAtt3);
        insert allJobAttr;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c(name='10', API__c = 'Inbound', Error_Warning_Success__c = 'warning');
        insert eOFSCResCode;
        
        EON_AttributeName_Field_Mapping__c allAttrMap = new EON_AttributeName_Field_Mapping__c();
        allAttrMap.name = 'APPTREASONCUST_REQ';
        allAttrMap.Appointment_Field_Value__c = 'CUSTOMER REQUEST';
        allAttrMap.Field_Mapping_API_Name__c = 'Appointment_reason_code__c';
        allAttrMap.EON_Attribute_Name__c = 'APPTREASON';
        allAttrMap.EON_Attribute_Value__c = 'CUST_REQ';
        insert allAttrMap;
        
        Eon_Appointment_Reason__c apptReason = new Eon_Appointment_Reason__c(Name='CUSTOMER REQUEST');
        insert apptReason;
        
        EON_CreateReservation_In_Isis_WS controller = new EON_CreateReservation_In_Isis_WS();
        
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '123321';
        appDetailElem.AppointmentDate = System.Today();
        appDetailElem.StartTime = timeElem;
        //appDetailElem.EndTime = timeElem1;
        appDetailElem.TimeSlot = '10:00-12:00';
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = '1PH';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = 'smart'; //Job Test
        jobTypeElem.JobDesc = 'Job desc';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = 'Booking System';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;   
            
        test.startTest();   
        Test.setMock(WebServiceMock.class, new EON_CreateReservation_In_Isis_test());
        EON_CreateReservation_In_Isis_test.functionType ='GetJumbo';
        EON_CreateReservation_In_Isis_test.isGetOFSC = false;
        EON_CreateReservation_In_Isis_test.NumOfPhases = '3';
        EON_CreateReservation_In_Isis_test.EffectiveFromDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()-1) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.EffectiveToDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+2) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /*
        PostitiveTest_ErrorFromJumbo(): Postive test scenario - Error from Jumbo
    */
    static testmethod void PostitiveTest_ErrorFromJumbo(){
        EON_CreateReservation_In_Isis_test.isGetMPAN = false;
        EON_CreateReservation_In_Isis_test.isGetMPRN = false;
        EON_Vulnerability_Code__c vCode = new EON_Vulnerability_Code__c();
        vCode.Name = 'test';
        vCode.Vulnerability_Code__c = 11;
        vCode.JUMBO_Vulnerability_Code__c = 11;
        insert vCode;
        
        EON_Sub_Area__c eSubArea = new EON_Sub_Area__c();
        eSubArea.Smart__c = true;
        eSubArea.Oracle_Bucket_ID__c = 'test';
        insert eSubArea;
        
        EON_Post_Code__c ePost = new EON_Post_Code__c();
        ePost.Name = 'test';
        ePost.Sub_Area_Name__c = eSubArea.ID;
        insert ePost;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Postcode__c = 'testte';
        insert eSite;
        
        EON_Fuel__c fuel = new EON_Fuel__c(Premise__c = eSite.ID, MPRN__c='123', MPAN__c='123', Gas_supplier_code__c='STGL');
        insert fuel;
        
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
                
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name='Test1PH', Elec_Meter_Type__c='Test', Elec_Phase__c='1PH', Work_Skill__c='Elec3');
        insert eCapCategory;
        
        //Job Test
        EON_Job__c job = new EON_Job__c(Name = 'smart', Description__c = 'Test describe', Job_Type__c = 'Smart',MAM_Reqd__c = false ,MOP_Reqd__c = true ,MPAN_Reqd__c = true ,MPRN_Reqd__c = true);
        insert job;
        
        EON_AttributeName_Field_Mapping__c allAttrMap = new EON_AttributeName_Field_Mapping__c();
        allAttrMap.name = 'GASMETERTYPEMS1';
        allAttrMap.Appointment_Field_Value__c = 'CUSTOMER REQUEST';
        allAttrMap.Field_Mapping_API_Name__c = 'Appointment_reason_code__c';
        allAttrMap.EON_Attribute_Name__c = 'GASMETERTYPE';
        allAttrMap.EON_Attribute_Value__c = 'MS1';
        insert allAttrMap;
        
        list<EON_Job_Attribute__c> allJobAttr = new list<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Phase',Duration__c =0, Value__c = '3PH');
        allJobAttr.add(ejobAtt);
        EON_Job_Attribute__c ejobAtt1 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'ELECMETERTYPE',Duration__c =0, Value__c = 'KEY');
        allJobAttr.add(ejobAtt1);
        EON_Job_Attribute__c ejobAtt2 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'GASMETERTYPE',Duration__c =0, Value__c = 'MS1');
        allJobAttr.add(ejobAtt2);
        EON_Job_Attribute__c ejobAtt3 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'APPTREASON',Duration__c =0, Value__c = 'CUST_REQ');
        allJobAttr.add(ejobAtt3);
        insert allJobAttr;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_OFSC_Response_Code__c eOFSCResCode = new EON_OFSC_Response_Code__c(name='0', API__c = 'Inbound', Error_Warning_Success__c = 'warning');
        insert eOFSCResCode;
        
        EON_CreateReservation_In_Isis_WS controller = new EON_CreateReservation_In_Isis_WS();
        
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '123321';
        appDetailElem.AppointmentDate = System.Today();
        appDetailElem.StartTime = timeElem;
        appDetailElem.EndTime = timeElem1;
        appDetailElem.TimeSlot = '10:00-12:00';
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = '3PH';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        //JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = 'smart'; //Job Test
        jobTypeElem.JobDesc = 'Job desc';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = 'Booking System';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;   
            
        test.startTest();   
        EON_CreateReservation_In_Isis_WS.validateStringLen('Test', 2);
        Test.setMock(WebServiceMock.class, new EON_CreateReservation_In_Isis_test());
        EON_CreateReservation_In_Isis_test.functionType ='GetJumbo';
        EON_CreateReservation_In_Isis_test.coverUncovered =true;
        EON_CreateReservation_In_Isis_test.EffectiveFromDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()-1) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.EffectiveToDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+2) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /*
        PostitiveTest_NotMAM(): Postive test scenario
    */
    static testmethod void PostitiveTest_NotMAM(){
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'RES';
        insert customer;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Customer__c = customer.ID;
        insert eSite;
        
        EON_Gas_Meter_Mechanism__c gMech = new EON_Gas_Meter_Mechanism__c(name='test', OFS_Enumeration__c = 12, Code__c='T');
        insert gMech;
        
        EON_Fuel__c fuel = new EON_Fuel__c(Premise__c = eSite.ID, MPRN__c='123', MPAN__c='123', Gas_supplier_code__c='STGL', Gas_Meter_Mechanism__c = gMech.ID);
        insert fuel;
        
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
                
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name='Test1PH', Elec_Meter_Type__c='Test', Elec_Phase__c='1PH', Work_Skill__c='Elec3');
        insert eCapCategory;
        
        EON_Job__c job = new EON_Job__c(Name = 'smart', Description__c = 'Test describe', Job_Type__c = 'ECO',MAM_Reqd__c = false ,MOP_Reqd__c = true ,MPAN_Reqd__c = true ,MPRN_Reqd__c = true);
        insert job;
        
        list<EON_Job_Attribute__c> allJobAttr = new list<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Phase',Duration__c =0, Value__c = 'unchanged');
        allJobAttr.add(ejobAtt);
        EON_Job_Attribute__c ejobAtt1 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'ELECMETERTYPE',Duration__c =0, Value__c = 'KEY');
        allJobAttr.add(ejobAtt1);
        EON_Job_Attribute__c ejobAtt2 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'GASMETERTYPE',Duration__c =0, Value__c = 'MS1');
        allJobAttr.add(ejobAtt2);
        EON_Job_Attribute__c ejobAtt3 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'APPTREASON',Duration__c =0, Value__c = 'CUST_REQ');
        allJobAttr.add(ejobAtt3);
        insert allJobAttr;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_CreateReservation_In_Isis_WS controller = new EON_CreateReservation_In_Isis_WS();
        
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '123321';
        appDetailElem.AppointmentDate = System.Today();
        appDetailElem.StartTime = timeElem;
        //appDetailElem.EndTime = timeElem1;
        appDetailElem.TimeSlot = '10:00-12:00';
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = 'unchanged';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = 'smart';
        jobTypeElem.JobDesc = 'Job desc';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = 'Booking System';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;   
            
        test.startTest();   
        Test.setMock(WebServiceMock.class, new EON_CreateReservation_In_Isis_test());
        EON_CreateReservation_In_Isis_test.functionType ='GetJumbo';
        EON_CreateReservation_In_Isis_Test.NumOfPhases = '3';
        EON_CreateReservation_In_Isis_test.EffectiveFromDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()-1) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.EffectiveToDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+2) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.isMAM = false;
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    
    /*
        PostitiveTest_NotMAM(): Postive test scenario
    */
    static testmethod void PostitiveTest_NotMAM1(){
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'RES';
        insert customer;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Customer__c = customer.ID;
        insert eSite;
        
        EON_Gas_Meter_Mechanism__c gMech = new EON_Gas_Meter_Mechanism__c(name='test', OFS_Enumeration__c = 12, Code__c='T');
        insert gMech;
        
        EON_Fuel__c fuel = new EON_Fuel__c(Premise__c = eSite.ID, MPRN__c='123', MPAN__c='123', Gas_supplier_code__c='STGL', Gas_Meter_Mechanism__c = gMech.ID);
        insert fuel;
        
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
                
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name='Test1PH', Elec_Meter_Type__c='Test', Elec_Phase__c='1PH', Work_Skill__c='Elec3');
        insert eCapCategory;
        
        EON_Job__c job = new EON_Job__c(Name = 'smart', Description__c = 'Test describe', Job_Type__c = 'ECO',MAM_Reqd__c = false ,MOP_Reqd__c = true ,MPAN_Reqd__c = true ,MPRN_Reqd__c = true);
        insert job;
        
        list<EON_Job_Attribute__c> allJobAttr = new list<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Phase',Duration__c =0, Value__c = 'unchanged');
        allJobAttr.add(ejobAtt);
        EON_Job_Attribute__c ejobAtt1 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'ELECMETERTYPE',Duration__c =0, Value__c = 'KEY');
        allJobAttr.add(ejobAtt1);
        EON_Job_Attribute__c ejobAtt2 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'GASMETERTYPE',Duration__c =0, Value__c = 'MS1');
        allJobAttr.add(ejobAtt2);
        EON_Job_Attribute__c ejobAtt3 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'APPTREASON',Duration__c =0, Value__c = 'CUST_REQ');
        allJobAttr.add(ejobAtt3);
        insert allJobAttr;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_CreateReservation_In_Isis_WS controller = new EON_CreateReservation_In_Isis_WS();
        
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '123321';
        appDetailElem.AppointmentDate = System.Today();
        appDetailElem.StartTime = timeElem;
        //appDetailElem.EndTime = timeElem1;
        appDetailElem.TimeSlot = '10:00-12:00';
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = 'unchanged';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = 'smart';
        jobTypeElem.JobDesc = 'Job desc';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = 'Booking System';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;   
            
        test.startTest();   
        Test.setMock(WebServiceMock.class, new EON_CreateReservation_In_Isis_test());
        EON_CreateReservation_In_Isis_test.functionType ='GetJumbo';
        EON_CreateReservation_In_Isis_Test.NumOfPhases = '3';
        EON_CreateReservation_In_Isis_test.EffectiveFromDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()-1) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.EffectiveToDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+2) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.isMAM = false;
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /*
        PostitiveTest_NotMAMwithoutFUEL(): Postive test scenario - We are not mam without Fuel record 
    */
    static testmethod void PostitiveTest_NotMAMwithoutFUEL(){
        EON_Customer__c customer = new EON_Customer__c();
        customer.Name = '1234567890';
        customer.Customer_Name__c = 'test';
        customer.Customer_group_type__c = 'RES';
        insert customer;
        
        EON_Site__c eSite = EON_CreateTestRecords.createEonSite();
        eSite.Customer__c = customer.ID;
        insert eSite;
        
        EON_Gas_Meter_Mechanism__c gMech = new EON_Gas_Meter_Mechanism__c(name='test', OFS_Enumeration__c = 12, Code__c='T');
        insert gMech;
        
        EON_Fuel__c fuel = new EON_Fuel__c(Premise__c = eSite.ID, MPRN__c='1234', MPAN__c='1234', Gas_supplier_code__c='STGL', Gas_Meter_Mechanism__c = gMech.ID);
        insert fuel;
        
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
                
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name='Test1PH', Elec_Meter_Type__c='Test', Elec_Phase__c='1PH', Work_Skill__c='Elec3');
        insert eCapCategory;
        
        EON_Job__c job = new EON_Job__c(Name = 'smart', Description__c = 'Test describe', Job_Type__c = 'ECO',MAM_Reqd__c = false ,MOP_Reqd__c = true ,MPAN_Reqd__c = true ,MPRN_Reqd__c = true);
        insert job;
        
        list<EON_Job_Attribute__c> allJobAttr = new list<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Phase',Duration__c =0, Value__c = 'unchanged');
        allJobAttr.add(ejobAtt);
        EON_Job_Attribute__c ejobAtt1 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'ELECMETERTYPE',Duration__c =0, Value__c = 'KEY');
        allJobAttr.add(ejobAtt1);
        EON_Job_Attribute__c ejobAtt2 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'GASMETERTYPE',Duration__c =0, Value__c = 'MS1');
        allJobAttr.add(ejobAtt2);
        EON_Job_Attribute__c ejobAtt3 = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'APPTREASON',Duration__c =0, Value__c = 'CUST_REQ');
        allJobAttr.add(ejobAtt3);
        insert allJobAttr;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_CreateReservation_In_Isis_WS controller = new EON_CreateReservation_In_Isis_WS();
        
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '123321';
        appDetailElem.AppointmentDate = System.Today();
        appDetailElem.StartTime = timeElem;
        //appDetailElem.EndTime = timeElem1;
        appDetailElem.TimeSlot = '10:00-12:00';
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = 'unchanged';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = 'smart';
        jobTypeElem.JobDesc = 'Job desc';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = 'Booking System';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;   
            
        test.startTest();   
        Test.setMock(WebServiceMock.class, new EON_CreateReservation_In_Isis_test());
        EON_CreateReservation_In_Isis_test.functionType ='GetJumbo';
        EON_CreateReservation_In_Isis_test.EffectiveFromDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()-1) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.EffectiveToDate = String.valueOf(System.Date.today().year()) + String.valueOf(System.Date.today().month()+2) + String.valueOf(System.Date.today().day());
        EON_CreateReservation_In_Isis_test.isMAM = false;
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        System.assert(response != null);                                     
        test.stopTest();
    }
    
    /*
        PostitiveTest_Exception(): This method will cover exception
    */
    static testmethod void PostitiveTest_Exception(){
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='12345';
        header.requestId='Test';
        header.requestDateTime = System.now();
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.header = header;
        EON_CreateReservation_In_Isis_test.genException = true;
        Test.startTest();
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        Test.stopTest();
    }
    
    /*
        PostitiveTest_NullRequest(): Request is null
    */
    static testmethod void PostitiveTest_NullRequest(){
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        Test.startTest();
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(null); 
        Test.stopTest();
    }
    
    /*
        PostiveTest_ErrorRequest(): Request missing required paramter
    */
    static testmethod void PostiveTest_ErrorRequest(){
        EON_CreateReservation_In_Isis_WS.HeaderElement header = new EON_CreateReservation_In_Isis_WS.HeaderElement();
        header.orgId='';
        header.requestId='';
        header.requestDateTime = null;
              
        EON_CreateReservation_In_Isis_WS.Timelement timeElem = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem.Hours = 10;
        timeElem.Minutes = 00;  
        EON_CreateReservation_In_Isis_WS.Timelement timeElem1 = new EON_CreateReservation_In_Isis_WS.Timelement(); 
        timeElem1.Hours = 12;
        timeElem1.Minutes = 00; 
        EON_CreateReservation_In_Isis_WS.AppointmentDetailElement appDetailElem = new EON_CreateReservation_In_Isis_WS.AppointmentDetailElement();        
        appDetailElem.EONAppointmentID = '';
        appDetailElem.AppointmentDate = null;
        appDetailElem.StartTime = timeElem;
        appDetailElem.EndTime = timeElem1;
        
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem.Name = '';
        jobAttElem.Value = '3PH';   
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem1 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem1.Name = 'ELECMETERTYPE';
        jobAttElem1.Value = 'KEY';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem2 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem2.Name = 'GASMETERTYPE';
        jobAttElem2.Value = 'MS1';
        EON_CreateReservation_In_Isis_WS.JobAttributeElement jobAttElem3 = new EON_CreateReservation_In_Isis_WS.JobAttributeElement();    
        jobAttElem3.Name = 'APPTREASON';
        jobAttElem3.Value = 'CUST_REQ';     
        list<EON_CreateReservation_In_Isis_WS.JobAttributeElement> JobAttLst = new list<EON_CreateReservation_In_Isis_WS.JobAttributeElement>();
        JobAttLst.add(jobAttElem);
        JobAttLst.add(jobAttElem1);
        JobAttLst.add(jobAttElem2);
        JobAttLst.add(jobAttElem3);
        EON_CreateReservation_In_Isis_WS.JobAttributesElement jobAttsElem = new EON_CreateReservation_In_Isis_WS.JobAttributesElement();    
        jobAttsElem.JobAttribute = JobAttLst;      
        EON_CreateReservation_In_Isis_WS.JobTypeElement jobTypeElem = new EON_CreateReservation_In_Isis_WS.JobTypeElement();    
        jobTypeElem.JobCode = '';
        jobTypeElem.JobDesc = '';       
        jobTypeElem.JobAttributes = jobAttsElem;      
        
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint.MPxN = '';
        mtrPoint.FuelType = 'E';
        EON_CreateReservation_In_Isis_WS.MeterPointElement mtrPoint1 = new EON_CreateReservation_In_Isis_WS.MeterPointElement();
        mtrPoint1.MPxN = '123';
        mtrPoint1.FuelType = 'G';
        list<EON_CreateReservation_In_Isis_WS.MeterPointElement> meterlst = new list<EON_CreateReservation_In_Isis_WS.MeterPointElement>();
        meterlst.add(mtrPoint);
        meterlst.add(mtrPoint1);
        EON_CreateReservation_In_Isis_WS.MeterPointsElement meterPoints = new EON_CreateReservation_In_Isis_WS.MeterPointsElement();
        meterPoints.MeterPoint = meterlst;
        
        EON_CreateReservation_In_Isis_WS.CreateReservation createReserv = new EON_CreateReservation_In_Isis_WS.CreateReservation();
        createReserv.Header = header;
        createReserv.BookingSystemName = '';
        createReserv.AssistedWorkReason = 'Urgent';
        createReserv.AppointmentDetails = appDetailElem;
        createReserv.JobType = jobTypeElem;
        createReserv.MeterPoints = meterPoints;  
        Test.startTest();
        EON_CreateReservation_In_Isis_WS.Isis_Response_Acknowledgement_To_EON response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        mtrPoint.MPxN = '123';
        mtrPoint.FuelType = '';
        jobAttElem.Name = 'Phase';
        jobAttElem.Value = '';  
        response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        jobAttsElem.JobAttribute = null;
        response = EON_CreateReservation_In_Isis_WS.CreateReservation(createReserv); 
        Test.stopTest();
    }
 
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType){
        if(functionType == 'GetJumbo'){
            //Validate MOP
            if(request instanceof  EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty(); 
                eapObj.EffectiveFromDate = EON_CreateReservation_In_Isis_test.EffectiveFromDate;//'20150423';
                eapObj.EffectiveToDate = EON_CreateReservation_In_Isis_test.EffectiveToDate; //'20160823';
                eapObj.MarketParticipantId='EMEB';
                EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[]{eapObj};
                EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
                aepObj.ElecAppointedParty = aEobj;
                EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
                empObj.MPAN = 'mpan123';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element validMop = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
                validMop.RequestElectricitySupplierAppointmentsResult = respJumbo;
                response.put('response_x', validMop);
            }
            //validate MAM
            else if(request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element){
                String[] Msg1 = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg1;
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj1 = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
                gasAObj1.EffectiveFromDate = EON_CreateReservation_In_Isis_test.EffectiveFromDate;
                gasAObj1.EffectiveToDate = EON_CreateReservation_In_Isis_test.EffectiveToDate;
                gasAObj1.AbbreviatedName='SGL';
                EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[]{gasAObj1};
                EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                aepObj.GasAppointedParty = gasAppobj;
                EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                empObj.MPRN = 'mprn123';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                respJumbo.Success = isMAM;
                respJumbo.MeterPoint=empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
            
            
            
          
            //Get Electric Details
            else if(request instanceof EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                err.Message = Msg;
          
                EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
                eCode.Code = 'Code';
                eCode.Dispensation = 'Dispensation';
                eCode.IssueNumber = '007';
    
                EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
                elecCon.Name = 'Name';
                elecCon.Telephone = '12345678';
                elecCon.PreferredContactMethod = 'P';
                elecCon.Email = 'test@email.com';
                elecCon.Fax = '4004';      
          
                EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
                elecApp.EffectiveFromDate = EON_CreateReservation_In_Isis_test.EffectiveFromDate; //'20150423';
                elecApp.EffectiveToDate = EON_CreateReservation_In_Isis_test.EffectiveToDate; //'20161223';
                elecApp.MarketParticipantId = '007';
          
                EON_JUMBO_Work_Management_WS.ElecAddress elecAdd = new EON_JUMBO_Work_Management_WS.ElecAddress();
                elecAdd.PostCode = '007';
                elecAdd.Line1 = 'Line1';
                elecAdd.Line2 = 'Line2';
                elecAdd.Line3 = 'Line3';
                elecAdd.Line4 = 'Line4';
                elecAdd.Line5 = 'Line5';
                elecAdd.Line6 = 'Line6';
                elecAdd.Line7 = 'Line7';
                elecAdd.Line8 = 'Line8';
                elecAdd.Line9 = 'Line90';  
                  
                EON_JUMBO_Work_Management_WS.TimePatternRegime timePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime();
                timePatt.Code = '007';
                timePatt.RegisterMappingCoefficient= '4';
                  
                EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[]{timePatt}; 
                EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
                arrTimePatt.TimePatternRegime = objTimePatt ;
                  
                EON_JUMBO_Work_Management_WS.ElecRegister eReg = new EON_JUMBO_Work_Management_WS.ElecRegister();
                eReg.AssociatedMeterId = '007';
                eReg.AssociatedRegisterId = '007';
                eReg.ChannelNumber = '1';     
                eReg.Description = 'Description';
                eReg.Id = '12';
                eReg.MeasurementQuantityId = '50';
                eReg.MeterMemoryLocation = '200';
                eReg.Multiplier ='3';
                eReg.NumberOfDigits = '2';
                eReg.PulseMultiplier = '3';
                eReg.TimestampMeterMemoryLocation = '5';
                eReg.Type_x = 'Type_x';
                eReg.TimePatternRegimes = arrTimePatt ;     
                  
                EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[]{eReg};
                EON_JUMBO_Work_Management_WS.ArrayOfElecRegister arrEReg = new EON_JUMBO_Work_Management_WS.ArrayOfElecRegister();
                arrEReg.ElecRegister = objEReg;
                  
                EON_JUMBO_Work_Management_WS.ElecMeter eMeter = new EON_JUMBO_Work_Management_WS.ElecMeter();
                eMeter.CTRatio = '20';
                eMeter.CertificationDate = '2015-04-23';
                eMeter.CertificationExpiryDate = '2017-08-23';
                eMeter.CodeOfPractice = eCode;
                eMeter.CurrentRating = '2';
                eMeter.Location = 'Location';
                eMeter.MainOrCheck = 'MainOrCheck';
                eMeter.ManufacturerAndModel = 'ManufacturerAndModel';
                eMeter.RetrievalMethod = 'RetrievalMethod';
                eMeter.RetrievalMethodEffectiveDate = '2015-04-23';
                eMeter.SerialNumber = '007';
                String eMeterTypeValue = 'Test';//String.valueOf(eMeterType.name);
                eMeter.TimingDeviceSerialNumber = eMeterTypeValue;
                eMeter.Type_x = 'test';
                eMeter.VTRatio = '7';
                eMeter.Registers = arrEReg ;
                  
                EON_JUMBO_Work_Management_WS.ElecMeter[] objEMeter = new EON_JUMBO_Work_Management_WS.ElecMeter[]{eMeter};
                EON_JUMBO_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
                arrayEM.ElecMeter = objEMeter;
                  
                EON_JUMBO_Work_Management_WS.DataEffectiveFrom dataEff  = new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
                dataEff.Id = '1234';
                dataEff.EffectiveFromDate = '2015-04-23';  
            
                EON_JUMBO_Work_Management_WS.OutstationPasswords oStatPwd = new EON_JUMBO_Work_Management_WS.OutstationPasswords();
                oStatPwd.Level1 = 'Level1';
                oStatPwd.Level2 = 'Level2';
                oStatPwd.Level3 = 'Level3';
            
                EON_JUMBO_Work_Management_WS.OutstationUsernames oStatUser = new EON_JUMBO_Work_Management_WS.OutstationUsernames ();
                oStatUser.Level1 = 'Level1';
                oStatUser.Level2 = 'Level2';
                oStatUser.Level3 = 'Level3';
                
                EON_JUMBO_Work_Management_WS.CommsBase cBase = new EON_JUMBO_Work_Management_WS.CommsBase();
                cBase.Address = 'Address';
                cBase.BaudRate = '2';
                cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
                cBase.Method = 'Method';
                cBase.Provider = 'Provider';   
                 
                EON_JUMBO_Work_Management_WS.CommsBase[] objCBase = new EON_JUMBO_Work_Management_WS.CommsBase[]{cBase};
                EON_JUMBO_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
                arrCBase.CommsBase = objCBase ;
                 
                EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice outCode= new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
                outCode.Code = '12345';
                outCode.Dispensation ='Dispensation';
                  
                EON_JUMBO_Work_Management_WS.Outstation outStat = new EON_JUMBO_Work_Management_WS.Outstation();
                outStat.CodeOfPractice = outCode;
                outStat.EncryptionKey = 'EncryptionKey';
                outStat.Id = '007';
                outStat.Multiplier = '3';
                outStat.NumberOfChannels = '2';
                outStat.NumberOfDigits = '5';
                outStat.Passwords = oStatPwd;
                outStat.Pin = '45698';
                outStat.Type_x = 'Type_x';
                outStat.Usernames = oStatUser;
                outStat.Comms = arrCBase;
                
                EON_JUMBO_Work_Management_WS.Outstation[] objOutStat = new EON_JUMBO_Work_Management_WS.Outstation[]{outStat};
                EON_JUMBO_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
                arrOutStat.Outstation = objOutStat;
                
                EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
                priorService.AlternateName = 'AlternateName';      
                priorService.AlternateTelephone1 = '988445632';
                priorService.AlternateTelephone2 = '123456987';
                priorService.Name ='Name';
                priorService.Telephone3 = '123456778';
                priorService.Address = elecAdd;
                priorService.Telephone1= '988445632';
                priorService.Telephone2= '988445632';
                priorService.Telephone3= '988445632';      
            
                EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
                elecSup.EnergisationStatus = 'EnergisationStatus';
                elecSup.Phases = EON_CreateReservation_In_Isis_Test.NumOfPhases; //1
                elecSup.Voltage = '140';
                elecSup.Capacity = '200'; 
                
                EON_JUMBO_Work_Management_WS.SpecialNeed sNeed = new EON_JUMBO_Work_Management_WS.SpecialNeed();
                sNeed.AdditionalInformation = 'test';
                sNeed.Category = '11';
                
                EON_JUMBO_Work_Management_WS.SpecialNeed[] AllSpecialNeed = new EON_JUMBO_Work_Management_WS.SpecialNeed[]{sNeed};
                EON_JUMBO_Work_Management_WS.ArrayOfSpecialNeed arrayOfSpecialNeed = new EON_JUMBO_Work_Management_WS.ArrayOfSpecialNeed();
                arrayOfSpecialNeed.SpecialNeed = AllSpecialNeed;
                
                EON_JUMBO_Work_Management_WS.ElecCustomer eCust = new EON_JUMBO_Work_Management_WS.ElecCustomer();
                eCust.SpecialNeeds = arrayOfSpecialNeed; //
                eCust.AdditionalInformation = 'test';
                eCust.ContractReference = 'test';
                eCust.StdSettlementConfig = dataEff;
                eCust.Supply = elecSup;
                eCust.MeterPointAddress = elecAdd;
                eCust.CustomerName = 'CustomerName';
                eCust.CustomerContact = elecCon;
                eCust.SpecialAccess ='SpecialAccess';
                eCust.CustomerPassword = 'CustomerPassword';
                eCust.MeterPointAddress = elecAdd ;
                eCust.PriorityServiceContactInfo = priorService;
                eCust.CodeOfPractice= eCode;
                eCust.CustomerPasswordEffectivefromDate = '2015-04-23';   
                eCust.DataCollector = elecApp;
                eCust.GridSupplyPointsGroupId = '007';
                eCust.MPAN = '007';
                eCust.MaximumPowerRequirement = '200';
                eCust.MailingAddress = elecAdd;
                eCust.MeasurementClassId = '007';
                eCust.MeterOperator = elecApp;
                eCust.Meters = arrayEM;
                eCust.NonSettlementFunction = dataEff;
                eCust.Outstations = arrOutStat;
                eCust.PriorityServiceContactInfo = priorService;
                eCust.RegistrationEffectiveFromDate = '2015-04-23';
                eCust.RemoteDisableEnableCapability='test Remote';
                eCust.ServiceLevelReference='test ServiceLevel';
                eCust.ServiceLocation ='test ServiceLocation';
                eCust.ServiceReference='test ServiceReference';
                eCust.SpecialAccess='test SpecialAccess';
                  
                EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
                resp.Errors = err;
                resp.Success = EON_CreateReservation_In_Isis_test.isGetMPAN; //true;
                resp.Customer = eCust;
            
                EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();    
                obj.RequestElectricityMeterPointDataResult = resp;
                response.put('response_x', obj);
            }
            //Get Gas Details
            else if(request instanceof EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element){
                String[] Msg = new String[]{'Message1','Message2','Message3'};
                EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                err.Message = Msg;
                EON_JUMBO_Work_Management_WS.GasAddress gasAdd = new EON_JUMBO_Work_Management_WS.GasAddress ();
                gasAdd.AddressText='AddressText';
                gasAdd.Building='AddressText';
                gasAdd.DependentLocality='AddressText';
                gasAdd.County='County';
                gasAdd.DependentThoroughfare='DependentThoroughfare';
                gasAdd.DoubleDependentLocality='DoubleDependentLocality';
                gasAdd.PostCode='PostCode';
                gasAdd.PostTown='PostTown';
                gasAdd.PostTown='PostTown';
                gasAdd.SubBuilding='SubBuilding';
                gasAdd.UPRN='UPRN';
                gasAdd.Thoroughfare='Thoroughfare';
          
                EON_JUMBO_Work_Management_WS.GasRegister gRegi = new EON_JUMBO_Work_Management_WS.GasRegister();
                gRegi.MultiplicationFactor = '3';
                gRegi.NumberOfDigits = '2';
                gRegi.UnitsOfMeasure = '5';
         
                EON_JUMBO_Work_Management_WS.GasRegister[] objGasReg = new EON_JUMBO_Work_Management_WS.GasRegister[]{gRegi};          
                EON_JUMBO_Work_Management_WS.ArrayOfGasRegister arrGReg = new EON_JUMBO_Work_Management_WS.ArrayOfGasRegister(); 
                arrGReg.GasRegister = objGasReg;
                
                EON_JUMBO_Work_Management_WS.GasMeter gMet = new EON_JUMBO_Work_Management_WS.GasMeter();
                gMet.CollarStatus = 'CollarStatus';
                gMet.Location = 'Location';
                gMet.LocationNotes = 'LocationNotes';      
                gMet.Manufacturer = 'Manufacturer';
                gMet.MeasuringCapacity = 'MeasuringCapacity';
                gMet.Mechanism = 'MCL';
                gMet.Model = 'Model';
                gMet.PaymentMethod='Pay';
                gMet.PulseValue = '789';
                gMet.SerialNumber='1245';
                gMet.Status='Status';
                gMet.Type_x='T';
                gMet.Usage='Usage';
                gMet.YearOfManufacture = '2015';
                gMet.Registers = arrGReg;     
          
                EON_JUMBO_Work_Management_WS.GasMeter[] objGasMet = new EON_JUMBO_Work_Management_WS.GasMeter[]{gMet};          
                EON_JUMBO_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter(); 
                arrGMeter.GasMeter = objGasMet;      
    
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
               gasAObj.EffectiveFromDate = EON_CreateReservation_In_Isis_test.EffectiveFromDate;
               gasAObj.EffectiveToDate = EON_CreateReservation_In_Isis_test.EffectiveToDate;
               gasAObj.AbbreviatedName='MOR';
           
               EON_JUMBO_Work_Management_WS.Converter conver = new EON_JUMBO_Work_Management_WS.Converter();
                conver.SerialNumber = '007';
                conver.Model = 'Model';
                conver.AssetClass = 'AssetClass';
                conver.Manufacturer='Manufacturer';
                conver.Location = 'Location';
        
                EON_JUMBO_Work_Management_WS.Converter[] objConver = new EON_JUMBO_Work_Management_WS.Converter[]{conver};
                EON_JUMBO_Work_Management_WS.ArrayOfConverter arrConver = new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
                arrConver.Converter = objConver;
    
                EON_JUMBO_Work_Management_WS.ContactMechanism contMec = new EON_JUMBO_Work_Management_WS.ContactMechanism();
                contMec.Code = '007';
                contMec.Value = '007';       
               
                EON_JUMBO_Work_Management_WS.ContactMechanism[] objContMec = new EON_JUMBO_Work_Management_WS.ContactMechanism[]{contMec};
                EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism arrContMec = new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
                arrContMec.ContactMechanism = objContMec;
               
                EON_JUMBO_Work_Management_WS.Contact cont = new EON_JUMBO_Work_Management_WS.Contact();
                cont.TypeCode = 'TypeCode';
                cont.Initials = 'Initials';
                cont.Surname = 'Surname';
                cont.Title = 'Title';
                cont.ContactMechanism = arrContMec;
           
                EON_JUMBO_Work_Management_WS.Contact[] objCont = new EON_JUMBO_Work_Management_WS.Contact[]{cont};
                EON_JUMBO_Work_Management_WS.ArrayOfContact arrCont = new EON_JUMBO_Work_Management_WS.ArrayOfContact();
                arrCont.Contact = objCont;
                         
                EON_JUMBO_Work_Management_WS.gasCustomer gCust = new EON_JUMBO_Work_Management_WS.gasCustomer();
                gCust.AccessInstructions = 'AccessInstructions';
                gCust.AccessPassword = 'AccessPassword';
                gCust.ConversionFactor= 'ConversionFactor';
                gCust.LastInspectionDate= 'LastInspectionDate';
                gCust.Location= 'Location';
                gCust.LocationNotes= 'LocationNotes';
                gCust.MPRN= 'MPRN';
                gCust.MeterLink= 'MeterLink';
                gCust.MeterPointStatus= 'MeterP';
                gCust.MeteringPressure= '1';
                gCust.Address=gasAdd;
                gCust.Meters = arrGMeter;
                gCust.Supplier = gasAObj;
                gCust.Converters = arrConver;
                gCust.Contacts = arrCont;
           
                EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
                resp.Errors = err;
                resp.Success = EON_CreateReservation_In_Isis_test.isGetMPRN; //true;
                resp.Customer = gCust;
                EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();    
              obj.RequestgasMeterPointDataResult = resp;
              response.put('response_x', obj);
            }
            //Get Oracle Response
            else if(request instanceof EON_OFSC_Inbound_WS.InboundInterfaceElement){
                EON_OFSC_Inbound_WS.ReportMessageElement message = new EON_OFSC_Inbound_WS.ReportMessageElement();
                message.result = 'success';
                if(EON_CreateReservation_In_Isis_test.isGetOFSC){
                    message.code = '0';    
                    message.result = 'error';
                }
                else
                    message.code = '10';
                message.description = 'Appointment id = 126';
                EON_OFSC_Inbound_WS.ReportMessageElement[] messages = new EON_OFSC_Inbound_WS.ReportMessageElement[]{message};
                EON_OFSC_Inbound_WS.ReportElement reports = new EON_OFSC_Inbound_WS.ReportElement();
                reports.message = messages;
                EON_OFSC_Inbound_WS.AppointmentResponseElement appointment = new EON_OFSC_Inbound_WS.AppointmentResponseElement();
                appointment.appt_number = 'test';
                appointment.name = 'test';
                appointment.aid = 126;
                appointment.report = reports;
                EON_OFSC_Inbound_WS.CommandResponseElement command = new EON_OFSC_Inbound_WS.CommandResponseElement();
                command.appointment = appointment;
                EON_OFSC_Inbound_WS.CommandResponseElement[] commandarray = new EON_OFSC_Inbound_WS.CommandResponseElement[]{command};
                EON_OFSC_Inbound_WS.CommandsResponseArray commands = new EON_OFSC_Inbound_WS.CommandsResponseArray();
                commands.command = commandarray;
                EON_OFSC_Inbound_WS.DataResponseElement data = new EON_OFSC_Inbound_WS.DataResponseElement();
                data.commands = commands;
                EON_OFSC_Inbound_WS.InboundInterfaceResponseElement res = new EON_OFSC_Inbound_WS.InboundInterfaceResponseElement();
                res.user_x = new EON_OFSC_Inbound_WS.UserElement();
                res.head = new EON_OFSC_Inbound_WS.HeadResponseElement();
                res.data = data;
                response.put('response_x', res);
            }
        }
    }
}