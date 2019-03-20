/**
    Description : This test class covers the below class code
                  EON_Get_Capacity_From_Isis_WS
**/
/* 
    Created By  : Praveen G
    Created On  : 21-March-2016
    Service Req : 
    Change History:
    CH01 # SR_EON_AB_022 # 13/04/2016 # Mahadev J # Amended logic to check validity while getting capacity
    CH02 # Code Coverage # 01/06/2016 # Mahadev J # Amended logic to skip some variables to increase code coverage.
    CH03 # SR_EON_AB_155 # 04/10/2016 # Mahadev J # Amended logic to increase code coverage.
*/
@isTest
global class EON_Get_Capacity_From_Isis_WS_Test implements WebServiceMock {
    public static boolean genException;
    public static string methodType = '';
    public static boolean DateLessThanToday = false;
    public static EON_Electric_Meter_Type__c eMeterType1;
    /**
        GetWorkSkill() : Pass - Get WorkSkill - MPRN
    **/
    static testmethod void GetWorkSkillMPRN() {
        //Create EON Customer
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;
        //Create EON Site
        EON_Site__c eonSite = EON_CreateTestRecords.cereateEONSite();
        eonSite.Customer__c = customer.ID;
        insert eonSite;
        //Create EON Fuel
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPRN__c = '12';
        fuel.Premise__c = eonSite.ID;
        insert fuel;
        //Create test records
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'test jo';
        eJob.Job_Type__c = 'Smart';
        eJob.MAM_Reqd__c = true;
        eJob.MPRN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;
        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        insert eRegion;
        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;
        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;
        list < EON_Job_Attribute__c > allJobAttribute = new list < EON_Job_Attribute__c > ();
        EON_Job_Attribute__c eJobAttribute = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute.Eon_Job__c = eJob.ID;
        eJobAttribute.Name = 'GASMETERTYPE';
        eJobAttribute.Value__c = '1';
        allJobAttribute.add(eJobAttribute);
        EON_Job_Attribute__c eJobAttribute1 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute1.Eon_Job__c = eJob.ID;
        eJobAttribute1.Name = 'PRESSURE';
        eJobAttribute1.Value__c = '1';
        allJobAttribute.add(eJobAttribute1);
        insert allJobAttribute;
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
        //CH02.new.start
        EON_Gas_Meter_Type__c gMeterType = new EON_Gas_Meter_Type__c();
        gMeterType.name = 'KEY';
        insert gMeterType;
        EON_Gas_Meter_Mechanism__c mech = new EON_Gas_Meter_Mechanism__c(Name = 'MCL');
        insert mech;
        EON_Gas_Meter_Type__c gMeterType1 = new EON_Gas_Meter_Type__c(Name = 'Type_x', Industry_Code__c = 'T');
        insert gMeterType1;
        EON_Gas_Meter_Location__c location = new EON_Gas_Meter_Location__c(Name = 'Location');
        insert location;
        //CH02.new.end
        //CH02.start
        EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(name = 'CR1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity;
        EON_Capacity_Categories__c capacity1 = new EON_Capacity_Categories__c(name = 'MCLMED', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity1;
        EON_Capacity_Categories__c capacity2 = new EON_Capacity_Categories__c(name = 'TEST1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity2;
        EON_Capacity_Categories__c capacity3 = new EON_Capacity_Categories__c(name = 'nullMeteringPressure', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity3;
        EON_Capacity_Categories__c capacity4 = new EON_Capacity_Categories__c(name = 'MCLLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity4;
        //CH02.end
        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute.Name = 'GASMETERTYPE';
        JobAttribute.value = '1';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute1 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute1.Name = 'PRESSURE';
        JobAttribute1.value = '1';

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute);
        listJobAttr.add(JobAttribute1);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG.MPxN = '12';
        MeterPointG.FuelType = 'G';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointG);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 1';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.setMock(WebServiceMock.class, new EON_Get_Capacity_From_Isis_WS_Test());
        EON_Get_Capacity_From_Isis_WS_Test.methodType = 'MPRNInddataNEW';

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response2 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }
    /**
        GetWorkSkillMPRN_MAM() : Pass - Get WorkSkill - MPRN
    **/
    static testmethod void GetWorkSkillMPRN_MAM() {
        //Create EON Customer
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;
      
        //Create EON Site
        EON_Site__c eonSite = EON_CreateTestRecords.cereateEONSite();
        eonSite.Customer__c = customer.ID;
        insert eonSite;

        //Create EON Fuel
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPRN__c = '12';
        fuel.Premise__c = eonSite.ID;
        insert fuel;

        //Create test records
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'test jo';
        eJob.Job_Type__c = 'Smart';
        eJob.MAM_Reqd__c = true;
        eJob.MPRN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;

        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        insert eRegion;

        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;

        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;

        EON_Job_Attribute__c eJobAttribute = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute.Eon_Job__c = eJob.ID;
        insert eJobAttribute;

        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;
        //CH02.new.start
        EON_Gas_Meter_Type__c gMeterType = new EON_Gas_Meter_Type__c();
        gMeterType.name = 'KEY';
        insert gMeterType;

        EON_Gas_Meter_Mechanism__c mech = new EON_Gas_Meter_Mechanism__c(Name = 'MCL');
        insert mech;

        EON_Gas_Meter_Type__c gMeterType1 = new EON_Gas_Meter_Type__c(Name = 'Type_x', Industry_Code__c = 'T');
        insert gMeterType1;

        EON_Gas_Meter_Location__c location = new EON_Gas_Meter_Location__c(Name = 'Location');
        insert location;

        //CH02.new.end
        //CH02.start
        EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(name = 'CR1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity;
        EON_Capacity_Categories__c capacity1 = new EON_Capacity_Categories__c(name = 'MCLMED', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity1;
        EON_Capacity_Categories__c capacity2 = new EON_Capacity_Categories__c(name = 'TEST1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity2;
        EON_Capacity_Categories__c capacity3 = new EON_Capacity_Categories__c(name = 'nullMeteringPressure', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity3;
        //CH02.end
        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute.Name = eJobAttribute.name;
        JobAttribute.value = eJobAttribute.Value__c;

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG.MPxN = '12';
        MeterPointG.FuelType = 'G';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointG);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 1';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.setMock(WebServiceMock.class, new EON_Get_Capacity_From_Isis_WS_Test());
        EON_Get_Capacity_From_Isis_WS_Test.methodType = 'MAMMPRNInddataNEW';

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response2 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        DateLessThanToday = true;
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response3 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }
    /**
        GetCapacityBlankRequest() : Pass - Get Blank Request
    **/
    static testmethod void GetCapacityBlankRequest() {
        Test.startTest();
      //CH05 start
      EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response = EON_Get_Capacity_From_Isis_WS.getCapacity(null);
        List<EON_Get_Capacity_From_Isis_WS.Capacity> lstCap = new List<EON_Get_Capacity_From_Isis_WS.Capacity>();
                EON_Get_Capacity_From_Isis_WS.Capacity objCap = new EON_Get_Capacity_From_Isis_WS.Capacity();
                objCap.TimeSlot='AM';
                objCap.AvailableQuota= 2;
                objCap.CapacityDate=system.today();
                objCap.EndTime='AM';
                objCap.Quota=2;
                objCap.StartTime='Test time';
                lstCap.add(objCap);
                
                EON_Get_Capacity_From_Isis_WS.Capacities objCaps = new EON_Get_Capacity_From_Isis_WS.Capacities();
                objCaps.Capacity=lstCap;
                
                EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail objCapDeatils = new EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail();
                objCapDeatils.Capacities=objCaps;
                EON_Get_Capacity_From_Isis_WS.getXML(objCapDeatils);
        Test.stopTest();
    }

    /**
        GetRequestWithoutBucketID() : Pass - Get Request Without Oracle BucketID
    **/
    static testmethod void GetRequestWithoutBucketID() {
        //Create test records
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'test jo';
        eJob.Job_Type__c = 'Smart';
        eJob.MAM_Reqd__c = false;
        eJob.MPRN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;

        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        insert eRegion;

        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;

        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;

        EON_Job_Attribute__c eJobAttribute = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute.Eon_Job__c = eJob.ID;
        insert eJobAttribute;

        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;

        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute.Name = eJobAttribute.name;
        JobAttribute.value = eJobAttribute.Value__c;

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG.MPxN = '12';
        MeterPointG.FuelType = 'G';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointG);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 0';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
        System.assertEquals('test1234', response.Header.requestId);
    }

    /**
        GetRequestWithException(): Pass - This method will generate exception   
    **/
    static testmethod void GetRequestWithException() {
        EON_Get_Capacity_From_Isis_WS_Test.genException = true;
        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';
        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }

    /**
        GetResponseWithCapacities() : Pass - process request to receive Capacities from Oracle
    **/
    static testmethod void GetResponseWithCapacities() {
        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name = '1PH', Elec_Meter_Type__c = 'KEY', Elec_Phase__c = '1PH', Work_Skill__c = 'Elec3');
        insert eCapCategory;
        //Create test records
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'test jo';
        eJob.Job_Type__c = 'Smart';
        eJob.MOP_Reqd__c = false;
        eJob.MPAN_Reqd__c = true;
        //eJob.MAM_Reqd__c = true;
        //eJob.MPRN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;

        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        insert eRegion;

        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;

        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;

        EON_Job_Attribute__c eJobAttribute = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute.Eon_Job__c = eJob.ID;
        insert eJobAttribute;

        eMeterType1 = EON_CreateTestRecords.createEonElectricMeterType();
        eMeterType1.name = 'KEY';
        insert eMeterType1;

        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        EON_Site__c site1 = EON_CreateTestRecords.cereateEONSite();
        site1.Customer__c = customer.id;
        insert site1;

        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.Premise__c = site1.Id;
        fuel.MPAN__c = '12';
        fuel.Fuel_type__c = 'E';
        insert fuel;

        EON_Jumbo_E_G_Meter_Types_Mappings__c mType = new EON_Jumbo_E_G_Meter_Types_Mappings__c();
        mType.Meter_Type__c = 'E';
        mType.Planned_Meter_Type__c = 'MS1';
        mType.Name = 'Type_X';
        insert mType;

        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute.Name = eJobAttribute.name;
        JobAttribute.value = eJobAttribute.Value__c;

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointE = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointE.MPxN = '12';
        MeterPointE.FuelType = 'E';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointE);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 1';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.setMock(WebServiceMock.class, new EON_Get_Capacity_From_Isis_WS_Test());
        EON_Get_Capacity_From_Isis_WS_Test.methodType = 'MPANInddataAndCapacity';

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response2 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }
    /**
        GetResponseWithCapacities1() : Pass - process request to receive Capacities from Oracle
    **/
    static testmethod void GetResponseWithoutCapacities() {
        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;

        EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name = '1PH', Elec_Meter_Type__c = 'KEY', Elec_Phase__c = '1PH', Work_Skill__c = 'Elec3');
        insert eCapCategory;

        //Create test records
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'test jo';
        eJob.Job_Type__c = 'Smart';
        eJob.MOP_Reqd__c = false;
        eJob.MPAN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;

        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        insert eRegion;

        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;

        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;

        EON_Job_Attribute__c eJobAttribute = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute.Eon_Job__c = eJob.ID;
        insert eJobAttribute;

        eMeterType1 = EON_CreateTestRecords.createEonElectricMeterType();
        eMeterType1.name = 'KEY';
        insert eMeterType1;

        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        EON_Site__c site1 = EON_CreateTestRecords.cereateEONSite();
        site1.Customer__c = customer.id;
        insert site1;

        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.Premise__c = site1.Id;
        fuel.MPAN__c = '12';
        fuel.Fuel_type__c = 'E';
        insert fuel;

        EON_Capacity_Categories__c capacity2 = new EON_Capacity_Categories__c(name = 'TEST1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        insert capacity2;

        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute.Name = eJobAttribute.name;
        JobAttribute.value = eJobAttribute.Value__c;

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointE = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointE.MPxN = '12';
        MeterPointE.FuelType = 'E';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointE);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 1';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.setMock(WebServiceMock.class, new EON_Get_Capacity_From_Isis_WS_Test());
        EON_Get_Capacity_From_Isis_WS_Test.methodType = 'MPANInddataWithNoCapacity';

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response2 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }
    /**
        GetResponseForDuelFuel(): Positive test case //CH03.New
    **/
    static testmethod void GetResponseForDuelFuel() {
        //Create EON Customer
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        //Create EON Site
        EON_Site__c eonSite = EON_CreateTestRecords.cereateEONSite();
        eonSite.Customer__c = customer.ID;
        insert eonSite;

        //Create EON Fuel
        list < EON_Fuel__c > allEonFuel = new list < EON_Fuel__c > ();
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPRN__c = '12';
        fuel.Premise__c = eonSite.ID;
        allEonFuel.add(fuel);
        EON_Fuel__c fuel1 = EON_CreateTestRecords.createEONFuel();
        fuel1.MPRN__c = '13';
        fuel1.Premise__c = eonSite.ID;
        allEonFuel.add(fuel1);
        insert allEonFuel;

        //Create EON Job
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'test jo';
        eJob.Job_Type__c = 'Smart';
        eJob.MOP_Reqd__c = true;
        eJob.MPAN_Reqd__c = true;
        eJob.MAM_Reqd__c = true;
        eJob.MPRN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;

        list < EON_Region__c > allRegion = new list < EON_Region__c > ();
        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        allRegion.add(eRegion);
        EON_Region__c eRegion1 = EON_CreateTestRecords.createEonRegion();
        eRegion1.Travel_Time__c = 12.0;
        eRegion1.GSP_ID__c = 13;
        allRegion.add(eRegion1);
        insert allRegion;

        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;

        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;

        list < EON_Job_Attribute__c > allJobAttribute = new list < EON_Job_Attribute__c > ();
        EON_Job_Attribute__c eJobAttribute = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute.Eon_Job__c = eJob.ID;
        eJobAttribute.Name = 'GASMETERTYPE';
        eJobAttribute.Value__c = '1';
        allJobAttribute.add(eJobAttribute);
        EON_Job_Attribute__c eJobAttribute1 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute1.Eon_Job__c = eJob.ID;
        eJobAttribute1.Name = 'PRESSURE';
        eJobAttribute1.Value__c = '1';
        allJobAttribute.add(eJobAttribute1);
        EON_Job_Attribute__c eJobAttribute3 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute3.Eon_Job__c = eJob.ID;
        eJobAttribute3.Name = 'ELECMETERTYPE';
        eJobAttribute3.Value__c = '1';
        allJobAttribute.add(eJobAttribute3);
        EON_Job_Attribute__c eJobAttribute4 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute4.Eon_Job__c = eJob.ID;
        eJobAttribute4.Name = 'PHASE';
        eJobAttribute4.Value__c = '1ph';
        allJobAttribute.add(eJobAttribute4);
        insert allJobAttribute;

        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;

        EON_Gas_Meter_Type__c gMeterType = new EON_Gas_Meter_Type__c();
        gMeterType.name = 'KEY';
        insert gMeterType;

        EON_Gas_Meter_Mechanism__c mech = new EON_Gas_Meter_Mechanism__c(Name = 'MCL');
        insert mech;

        EON_Gas_Meter_Type__c gMeterType1 = new EON_Gas_Meter_Type__c(Name = 'Type_x', Industry_Code__c = 'T');
        insert gMeterType1;

        EON_Gas_Meter_Location__c location = new EON_Gas_Meter_Location__c(Name = 'Location');
        insert location;

        list < EON_Capacity_Categories__c > allCapacityCategory = new list < EON_Capacity_Categories__c > ();
        EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(name = 'CR1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity);
        EON_Capacity_Categories__c capacity1 = new EON_Capacity_Categories__c(name = 'MCLMED', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity1);
        EON_Capacity_Categories__c capacity2 = new EON_Capacity_Categories__c(name = 'TEST1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity2);
        EON_Capacity_Categories__c capacity3 = new EON_Capacity_Categories__c(name = 'nullMeteringPressure', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity3);
        EON_Capacity_Categories__c capacity4 = new EON_Capacity_Categories__c(name = 'MCLLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity4);
        EON_Capacity_Categories__c capacity5 = new EON_Capacity_Categories__c(name = 'KEYMCL1PHLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity5);
        insert allCapacityCategory;

        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute.Name = 'GASMETERTYPE';
        JobAttribute.value = '1';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute1 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute1.Name = 'PRESSURE';
        JobAttribute1.value = '1';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute2 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute2.Name = 'ELECMETERTYPE';
        JobAttribute2.value = '1';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute3 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute3.Name = 'PHASE';
        JobAttribute3.value = '1ph';

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute);
        listJobAttr.add(JobAttribute1);
        listJobAttr.add(JobAttribute2);
        listJobAttr.add(JobAttribute3);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG.MPxN = '1276876';
        MeterPointG.FuelType = 'G';

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG1 = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG1.MPxN = '13445';
        MeterPointG1.FuelType = 'E';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointG);
        listMeterPoints.add(MeterPointG1);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 1';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.setMock(WebServiceMock.class, new EON_Get_Capacity_From_Isis_WS_Test());
        EON_Get_Capacity_From_Isis_WS_Test.methodType = 'DuelFuelWithCapacities';

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response2 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }

    /**
        GetResponseForDuelFuelWithError(): Positive test case with error scenario //CH03.New
    **/
    static testmethod void GetResponseForDuelFuelWithError() {
        //Create EON Customer
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        //Create EON Site
        EON_Site__c eonSite = EON_CreateTestRecords.cereateEONSite();
        eonSite.Customer__c = customer.ID;
        insert eonSite;

        //Create EON Fuel
        list < EON_Fuel__c > allEonFuel = new list < EON_Fuel__c > ();
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPRN__c = '12';
        fuel.Premise__c = eonSite.ID;
        allEonFuel.add(fuel);
        EON_Fuel__c fuel1 = EON_CreateTestRecords.createEONFuel();
        fuel1.MPRN__c = '13';
        fuel1.Premise__c = eonSite.ID;
        allEonFuel.add(fuel1);
        insert allEonFuel;

        //Create EON Job
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'SMART_Test';
        eJob.Job_Type__c = 'Smart';
        eJob.MOP_Reqd__c = true;
        eJob.MPAN_Reqd__c = true;
        eJob.MAM_Reqd__c = false;
        eJob.MPRN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;

        list < EON_Region__c > allRegion = new list < EON_Region__c > ();
        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        allRegion.add(eRegion);
        EON_Region__c eRegion1 = EON_CreateTestRecords.createEonRegion();
        eRegion1.Travel_Time__c = 12.0;
        eRegion1.GSP_ID__c = 13;
        allRegion.add(eRegion1);
        insert allRegion;

        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;

        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;

        list < EON_Job_Attribute__c > allJobAttribute = new list < EON_Job_Attribute__c > ();
        EON_Job_Attribute__c eJobAttribute = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute.Eon_Job__c = eJob.ID;
        eJobAttribute.Name = 'GASMETERTYPE';
        eJobAttribute.Value__c = '1';
        allJobAttribute.add(eJobAttribute);
        EON_Job_Attribute__c eJobAttribute1 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute1.Eon_Job__c = eJob.ID;
        eJobAttribute1.Name = 'PRESSURE';
        eJobAttribute1.Value__c = '1';
        allJobAttribute.add(eJobAttribute1);
        EON_Job_Attribute__c eJobAttribute3 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute3.Eon_Job__c = eJob.ID;
        eJobAttribute3.Name = 'ELECMETERTYPE';
        eJobAttribute3.Value__c = '1';
        allJobAttribute.add(eJobAttribute3);
        EON_Job_Attribute__c eJobAttribute4 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute4.Eon_Job__c = eJob.ID;
        eJobAttribute4.Name = 'PHASE';
        eJobAttribute4.Value__c = '1ph';
        allJobAttribute.add(eJobAttribute4);
        insert allJobAttribute;

        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;

        EON_Gas_Meter_Type__c gMeterType = new EON_Gas_Meter_Type__c();
        gMeterType.name = 'KEY';
        insert gMeterType;

        EON_Gas_Meter_Mechanism__c mech = new EON_Gas_Meter_Mechanism__c(Name = 'MCL');
        insert mech;

        EON_Gas_Meter_Type__c gMeterType1 = new EON_Gas_Meter_Type__c(Name = 'Type_x', Industry_Code__c = 'T');
        insert gMeterType1;

        EON_Gas_Meter_Location__c location = new EON_Gas_Meter_Location__c(Name = 'Location');
        insert location;

        list < EON_Capacity_Categories__c > allCapacityCategory = new list < EON_Capacity_Categories__c > ();
        EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(name = 'CR1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity);
        EON_Capacity_Categories__c capacity1 = new EON_Capacity_Categories__c(name = 'MCLMED', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity1);
        EON_Capacity_Categories__c capacity2 = new EON_Capacity_Categories__c(name = 'TEST1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity2);
        EON_Capacity_Categories__c capacity3 = new EON_Capacity_Categories__c(name = 'nullMeteringPressure', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity3);
        EON_Capacity_Categories__c capacity4 = new EON_Capacity_Categories__c(name = 'MCLLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity4);
        EON_Capacity_Categories__c capacity5 = new EON_Capacity_Categories__c(name = 'KEYMCL1PHLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity5);
        insert allCapacityCategory;

        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute.Name = 'GASMETERTYPE';
        JobAttribute.value = '';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute1 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute1.Name = 'PRESSURE';
        JobAttribute1.value = '1';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute2 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute2.Name = 'ELECMETERTYPE';
        JobAttribute2.value = '1';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute3 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute3.Name = 'PHASE';
        JobAttribute3.value = '1ph';

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute1);
        listJobAttr.add(JobAttribute2);
        listJobAttr.add(JobAttribute3);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG.MPxN = '1276876';
        MeterPointG.FuelType = 'G';

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG1 = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG1.MPxN = '13445';
        MeterPointG1.FuelType = 'E';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointG);
        listMeterPoints.add(MeterPointG1);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 1';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.setMock(WebServiceMock.class, new EON_Get_Capacity_From_Isis_WS_Test());
        EON_Get_Capacity_From_Isis_WS_Test.methodType = 'DuelFuelWithCapacitiesWithError';

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response2 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }

    /**
        GetResponseForDuelFuelWithFuel(): Positive test case with error scenario //CH03.New
    **/
    static testmethod void GetResponseForDuelFuelWithFuel() {
        //Create EON Customer
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        //Create EON Site
        EON_Site__c eonSite = EON_CreateTestRecords.cereateEONSite();
        eonSite.Customer__c = customer.ID;
        insert eonSite;
       EON_Gas_Meter_Mechanism__c gMech = new EON_Gas_Meter_Mechanism__c(name='test', OFS_Enumeration__c = 12, Code__c='T');
        insert gMech; 
        
        //Create EON Fuel
        list < EON_Fuel__c > allEonFuel = new list < EON_Fuel__c > ();
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPRN__c = '12';
        fuel.Premise__c = eonSite.ID;
        allEonFuel.add(fuel);
        EON_Fuel__c fuel1 = EON_CreateTestRecords.createEONFuel();
        fuel1.MPRN__c = '13445';
        fuel1.Premise__c = eonSite.ID;
        fuel1.Gas_Meter_Mechanism__c = gMech.ID;
        allEonFuel.add(fuel1);
        insert allEonFuel;

        //Create EON Job
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'Test Jo';
        eJob.Job_Type__c = 'Smart';
        eJob.MOP_Reqd__c = true;
        eJob.MPAN_Reqd__c = true;
        eJob.MAM_Reqd__c = false;
        eJob.MPRN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;

        list < EON_Region__c > allRegion = new list < EON_Region__c > ();
        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        allRegion.add(eRegion);
        EON_Region__c eRegion1 = EON_CreateTestRecords.createEonRegion();
        eRegion1.Travel_Time__c = 12.0;
        eRegion1.GSP_ID__c = 13;
        allRegion.add(eRegion1);
        insert allRegion;

        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;

        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;

        list < EON_Job_Attribute__c > allJobAttribute = new list < EON_Job_Attribute__c > ();
        EON_Job_Attribute__c eJobAttribute = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute.Eon_Job__c = eJob.ID;
        eJobAttribute.Name = 'GASMETERTYPE';
        eJobAttribute.Value__c = '1';
        allJobAttribute.add(eJobAttribute);
        EON_Job_Attribute__c eJobAttribute1 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute1.Eon_Job__c = eJob.ID;
        eJobAttribute1.Name = 'PRESSURE';
        eJobAttribute1.Value__c = '1';
        allJobAttribute.add(eJobAttribute1);
        EON_Job_Attribute__c eJobAttribute3 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute3.Eon_Job__c = eJob.ID;
        eJobAttribute3.Name = 'ELECMETERTYPE';
        eJobAttribute3.Value__c = '1';
        allJobAttribute.add(eJobAttribute3);
        EON_Job_Attribute__c eJobAttribute4 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute4.Eon_Job__c = eJob.ID;
        eJobAttribute4.Name = 'PHASE';
        eJobAttribute4.Value__c = '1ph';
        allJobAttribute.add(eJobAttribute4);
        insert allJobAttribute;

        EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
        insert eMeterType;

        EON_Gas_Meter_Type__c gMeterType = new EON_Gas_Meter_Type__c();
        gMeterType.name = 'KEY';
        insert gMeterType;

        EON_Gas_Meter_Mechanism__c mech = new EON_Gas_Meter_Mechanism__c(Name = 'MCL');
        insert mech;

        EON_Gas_Meter_Type__c gMeterType1 = new EON_Gas_Meter_Type__c(Name = 'Type_x', Industry_Code__c = 'T');
        insert gMeterType1;

        EON_Gas_Meter_Location__c location = new EON_Gas_Meter_Location__c(Name = 'Location');
        insert location;

        list < EON_Capacity_Categories__c > allCapacityCategory = new list < EON_Capacity_Categories__c > ();
        EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(name = 'CR1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity);
        EON_Capacity_Categories__c capacity1 = new EON_Capacity_Categories__c(name = 'MCLMED', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity1);
        EON_Capacity_Categories__c capacity2 = new EON_Capacity_Categories__c(name = 'TEST1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity2);
        EON_Capacity_Categories__c capacity3 = new EON_Capacity_Categories__c(name = 'nullMeteringPressure', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity3);
        EON_Capacity_Categories__c capacity4 = new EON_Capacity_Categories__c(name = 'MCLLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity4);
        EON_Capacity_Categories__c capacity5 = new EON_Capacity_Categories__c(name = 'KEYMCL1PHLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity5);
        insert allCapacityCategory;

        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute.Name = 'GASMETERTYPE';
        JobAttribute.value = '';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute1 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute1.Name = 'PRESSURE';
        JobAttribute1.value = '1';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute2 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute2.Name = 'ELECMETERTYPE';
        JobAttribute2.value = '1';
        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute3 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute3.Name = 'PHASE';
        JobAttribute3.value = '1ph';

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute1);
        listJobAttr.add(JobAttribute2);
        listJobAttr.add(JobAttribute3);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG.MPxN = '1276876';
        MeterPointG.FuelType = 'G';

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG1 = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG1.MPxN = '13445';
        MeterPointG1.FuelType = 'E';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointG);
        listMeterPoints.add(MeterPointG1);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 1';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.setMock(WebServiceMock.class, new EON_Get_Capacity_From_Isis_WS_Test());
        EON_Get_Capacity_From_Isis_WS_Test.methodType = 'DuelFuelWithCapacities';

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response2 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }
    
    /**
        GetResponseForNoGMeterType(): 
    **/
    static testmethod void GetResponseForNoGMeterType() {
        //Create EON Customer
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        //Create EON Site
        EON_Site__c eonSite = EON_CreateTestRecords.cereateEONSite();
        eonSite.Customer__c = customer.ID;
        insert eonSite;
       
       EON_Gas_Meter_Mechanism__c gMech = new EON_Gas_Meter_Mechanism__c(name='test', OFS_Enumeration__c = 12, Code__c='T');
       
        insert gMech;
        //Create EON Fuel
        list < EON_Fuel__c > allEonFuel = new list < EON_Fuel__c > ();
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPRN__c = '12';
        fuel.Premise__c = eonSite.ID;
        allEonFuel.add(fuel);
        EON_Fuel__c fuel1 = EON_CreateTestRecords.createEONFuel();
        fuel1.MPRN__c = '13';
        fuel1.Premise__c = eonSite.ID;
        fuel1.Gas_Meter_Mechanism__c = gMech.ID;
        allEonFuel.add(fuel1);
        insert allEonFuel;

        //Create EON Job
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'Smart';
        eJob.Job_Type__c = 'Smart';
        eJob.MOP_Reqd__c = true;
        eJob.MPAN_Reqd__c = true;
        eJob.MAM_Reqd__c = true;
        eJob.MPRN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;

        list < EON_Region__c > allRegion = new list < EON_Region__c > ();
        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        allRegion.add(eRegion);
        EON_Region__c eRegion1 = EON_CreateTestRecords.createEonRegion();
        eRegion1.Travel_Time__c = 12.0;
        eRegion1.GSP_ID__c = 13;
        allRegion.add(eRegion1);
        insert allRegion;

        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;

        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;

        list < EON_Job_Attribute__c > allJobAttribute = new list < EON_Job_Attribute__c > ();
        EON_Job_Attribute__c eJobAttribute1 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute1.Eon_Job__c = eJob.ID;
        eJobAttribute1.Name = 'PRESSURE';
        eJobAttribute1.Value__c = '1';
        allJobAttribute.add(eJobAttribute1);
        insert allJobAttribute;

        EON_Gas_Meter_Mechanism__c mech = new EON_Gas_Meter_Mechanism__c(Name = 'MCL');
        insert mech;

        EON_Gas_Meter_Type__c gMeterType1 = new EON_Gas_Meter_Type__c(Name = 'Type_x', Industry_Code__c = 'T');
        insert gMeterType1;

        EON_Gas_Meter_Location__c location = new EON_Gas_Meter_Location__c(Name = 'Location');
        insert location;

        list < EON_Capacity_Categories__c > allCapacityCategory = new list < EON_Capacity_Categories__c > ();
        EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(name = 'CR1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity);
        EON_Capacity_Categories__c capacity1 = new EON_Capacity_Categories__c(name = 'MCLMED', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity1);
        EON_Capacity_Categories__c capacity2 = new EON_Capacity_Categories__c(name = 'TEST1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity2);
        EON_Capacity_Categories__c capacity3 = new EON_Capacity_Categories__c(name = 'nullMeteringPressure', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity3);
        EON_Capacity_Categories__c capacity4 = new EON_Capacity_Categories__c(name = 'MCLLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity4);
        EON_Capacity_Categories__c capacity5 = new EON_Capacity_Categories__c(name = 'KEYMCL1PHLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity5);
        insert allCapacityCategory;

        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute1 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute1.Name = 'PRESSURE';
        JobAttribute1.value = '1';

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute1);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG.MPxN = '1276876';
        MeterPointG.FuelType = 'G';

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG1 = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG1.MPxN = '13445';
        MeterPointG1.FuelType = 'E';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointG);
        listMeterPoints.add(MeterPointG1);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 1';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.setMock(WebServiceMock.class, new EON_Get_Capacity_From_Isis_WS_Test());
        EON_Get_Capacity_From_Isis_WS_Test.methodType = 'DuelFuelWithCapacities';

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response2 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }
   
    /**
        GetResponseForNoGMeterType1(): 
    **/
    static testmethod void GetResponseForNoGMeterType1() {
        //Create EON Customer
        EON_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        insert customer;

        //Create EON Site
        EON_Site__c eonSite = EON_CreateTestRecords.cereateEONSite();
        eonSite.Customer__c = customer.ID;
        insert eonSite;
        EON_Gas_Meter_Mechanism__c mech = new EON_Gas_Meter_Mechanism__c(Name = 'MCL');
        insert mech;
        EON_Gas_Meter_Mechanism__c gMech = new EON_Gas_Meter_Mechanism__c(name='test', OFS_Enumeration__c = 12, Code__c='T');
       
        insert gMech;
        //Create EON Fuel
        list < EON_Fuel__c > allEonFuel = new list < EON_Fuel__c > ();
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPRN__c = '12';
        fuel.Premise__c = eonSite.ID;
        fuel.Gas_Meter_Mechanism__c = mech.id;
        allEonFuel.add(fuel);
        EON_Fuel__c fuel1 = EON_CreateTestRecords.createEONFuel();
        fuel1.MPRN__c = '13';
        fuel1.Premise__c = eonSite.ID;
        fuel1.Gas_Meter_Mechanism__c = gMech.ID;
        allEonFuel.add(fuel1);
        insert allEonFuel;

        //Create EON Job
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'aaa';
        eJob.Job_Type__c = 'Smart';
        eJob.MOP_Reqd__c = true;
        eJob.MPAN_Reqd__c = true;
        eJob.MAM_Reqd__c = true;
        eJob.MPRN_Reqd__c = true;
        eJob.Job_Type__c = 'ECO';
        insert eJob;

        list < EON_Region__c > allRegion = new list < EON_Region__c > ();
        EON_Region__c eRegion = EON_CreateTestRecords.createEonRegion();
        eRegion.Travel_Time__c = 12.0;
        eRegion.GSP_ID__c = 12;
        allRegion.add(eRegion);
        EON_Region__c eRegion1 = EON_CreateTestRecords.createEonRegion();
        eRegion1.Travel_Time__c = 12.0;
        eRegion1.GSP_ID__c = 13;
        allRegion.add(eRegion1);
        insert allRegion;

        EON_Sub_Area__c eSubArea = EON_CreateTestRecords.createEonSubArea();
        eSubArea.Region_Name__c = eRegion.ID;
        eSubArea.Oracle_Bucket_ID__c = 'Buck_121';
        eSubArea.ECO__c = true;
        insert eSubArea;

        EON_Post_Code__c ePostCode = EON_CreateTestRecords.createEonPostCode();
        ePostCode.Name = 'SE10 1';
        ePostCode.Sub_Area_Name__c = eSubArea.id;
        insert ePostCode;

        list < EON_Job_Attribute__c > allJobAttribute = new list < EON_Job_Attribute__c > ();
        EON_Job_Attribute__c eJobAttribute1 = EON_CreateTestRecords.createEonJobAttributes();
        eJobAttribute1.Eon_Job__c = eJob.ID;
        eJobAttribute1.Name = 'PRESSURE';
        eJobAttribute1.Value__c = '1';
        allJobAttribute.add(eJobAttribute1);
        insert allJobAttribute;

        EON_Gas_Meter_Type__c gMeterType1 = new EON_Gas_Meter_Type__c(Name = 'Type_x', Industry_Code__c = 'T');
        insert gMeterType1;

        EON_Gas_Meter_Location__c location = new EON_Gas_Meter_Location__c(Name = 'Location');
        insert location;

        list < EON_Capacity_Categories__c > allCapacityCategory = new list < EON_Capacity_Categories__c > ();
        EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(name = 'CR1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity);
        EON_Capacity_Categories__c capacity1 = new EON_Capacity_Categories__c(name = 'MCLMED', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity1);
        EON_Capacity_Categories__c capacity2 = new EON_Capacity_Categories__c(name = 'TEST1PH', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity2);
        EON_Capacity_Categories__c capacity3 = new EON_Capacity_Categories__c(name = 'nullMeteringPressure', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity3);
        EON_Capacity_Categories__c capacity4 = new EON_Capacity_Categories__c(name = 'MCLLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity4);
        EON_Capacity_Categories__c capacity5 = new EON_Capacity_Categories__c(name = 'KEYMCL1PHLOW', Gas_Meter_Type__c = 'Type_x', Elec_Phase__c = '1PH', Work_Skill__c = 'WorkSkill');
        allCapacityCategory.add(capacity5);
        insert allCapacityCategory;

        EON_Get_Capacity_From_Isis_WS.Header header = new EON_Get_Capacity_From_Isis_WS.Header();
        header.OrgId = 'test';
        header.RequestId = 'test1234';
        header.RequestDateTime = 'test';

        EON_Get_Capacity_From_Isis_WS.JobAttribute JobAttribute1 = new EON_Get_Capacity_From_Isis_WS.JobAttribute();
        JobAttribute1.Name = 'PRESSURE';
        JobAttribute1.value = '1';

        EON_Get_Capacity_From_Isis_WS.JobAttributes JobAttributes = new EON_Get_Capacity_From_Isis_WS.JobAttributes();
        EON_Get_Capacity_From_Isis_WS.JobAttribute[] listJobAttr = new list < EON_Get_Capacity_From_Isis_WS.JobAttribute > ();
        listJobAttr.add(JobAttribute1);
        JobAttributes.JobAttribute = listJobAttr;

        EON_Get_Capacity_From_Isis_WS.JobType JobType = new EON_Get_Capacity_From_Isis_WS.JobType();
        JobType.JobCode = eJob.name;
        JobType.JobDesc = eJob.Description__c;
        JobType.JobAttributes = JobAttributes;

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG.MPxN = '12';
        MeterPointG.FuelType = 'G';

        EON_Get_Capacity_From_Isis_WS.MeterPoint MeterPointG1 = new EON_Get_Capacity_From_Isis_WS.MeterPoint();
        MeterPointG1.MPxN = '13445';
        MeterPointG1.FuelType = 'E';

        EON_Get_Capacity_From_Isis_WS.MeterPoint[] listMeterPoints = new list < EON_Get_Capacity_From_Isis_WS.MeterPoint > ();
        listMeterPoints.add(MeterPointG);
        listMeterPoints.add(MeterPointG1);

        EON_Get_Capacity_From_Isis_WS.MeterPoints MeterPoints = new EON_Get_Capacity_From_Isis_WS.MeterPoints();
        MeterPoints.MeterPoint = listMeterPoints;

        EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail capacityRequest = new EON_Get_Capacity_From_Isis_WS.CapacityRequestDetail();
        capacityRequest.Header = header;
        capacityRequest.BookingSystemName = 'ICE';
        capacityRequest.PostCode = 'SE10 1';
        capacityRequest.KeyCollectionRequiredFlag = 'Y';
        capacityRequest.JobType = JobType;
        capacityRequest.MeterPoints = MeterPoints;

        Test.setMock(WebServiceMock.class, new EON_Get_Capacity_From_Isis_WS_Test());
        EON_Get_Capacity_From_Isis_WS_Test.methodType = 'DuelFuelWithCapacities';

        Test.startTest();
        EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail response2 = EON_Get_Capacity_From_Isis_WS.getCapacity(capacityRequest);
        Test.stopTest();
    }

    /**
        doInvoke() - Mock Responses for Jumbo web services
    **/
    global void doInvoke(Object stub, Object request, Map < String, Object > response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        if (methodType == 'MPANInddata') {
            EON_Electric_Meter_Type__c eMeterType = EON_CreateTestRecords.createEonElectricMeterType();
            insert eMeterType;

            EON_Capacity_Categories__c eCapCategory = new EON_Capacity_Categories__c(Name = 'Test1PH', Elec_Meter_Type__c = 'Test', Elec_Phase__c = '1PH', Work_Skill__c = 'Elec3');
            insert eCapCategory;

            String[] Msg = new String[] {
                'Message1', 'Message2', 'Message3'
            };
            EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
            err.Message = Msg;

            EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
            eCode.Code = 'Code';
            eCode.Dispensation = 'Dispensation';
            eCode.IssueNumber = '007';

            EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
            elecCon.Name = 'Name';
            elecCon.Telephone = '12345678';
            elecCon.PreferredContactMethod = 'PreferredContactMethod';
            elecCon.Email = 'test@email.com';
            elecCon.Fax = '4004';

            EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
            elecApp.EffectiveFromDate = '20150423';
            elecApp.EffectiveToDate = '20160823';
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
            timePatt.RegisterMappingCoefficient = '4';

            EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[] {
                timePatt
            };
            EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
            arrTimePatt.TimePatternRegime = objTimePatt;

            EON_JUMBO_Work_Management_WS.ElecRegister eReg = new EON_JUMBO_Work_Management_WS.ElecRegister();
            eReg.AssociatedMeterId = '007';
            eReg.AssociatedRegisterId = '007';
            eReg.ChannelNumber = '1';
            eReg.Description = 'Description';
            eReg.Id = '1234';
            eReg.MeasurementQuantityId = '50';
            eReg.MeterMemoryLocation = '200';
            eReg.Multiplier = '3';
            eReg.NumberOfDigits = '2';
            eReg.PulseMultiplier = '3';
            eReg.TimestampMeterMemoryLocation = '5';
            eReg.Type_x = 'Type_x';
            eReg.TimePatternRegimes = arrTimePatt;

            EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[] {
                eReg
            };
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
            String eMeterTypeValue = String.valueOf(eMeterType.name);
            eMeter.TimingDeviceSerialNumber = eMeterTypeValue;
            eMeter.Type_x = 'test';
            eMeter.VTRatio = '7';
            eMeter.Registers = arrEReg;

            EON_JUMBO_Work_Management_WS.ElecMeter[] objEMeter = new EON_JUMBO_Work_Management_WS.ElecMeter[] {
                eMeter
            };
            EON_JUMBO_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
            arrayEM.ElecMeter = objEMeter;

            EON_JUMBO_Work_Management_WS.DataEffectiveFrom dataEff = new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
            dataEff.Id = '1234';
            dataEff.EffectiveFromDate = '2015-04-23';

            EON_JUMBO_Work_Management_WS.OutstationPasswords oStatPwd = new EON_JUMBO_Work_Management_WS.OutstationPasswords();
            oStatPwd.Level1 = 'Level1';
            oStatPwd.Level2 = 'Level2';
            oStatPwd.Level3 = 'Level3';

            EON_JUMBO_Work_Management_WS.OutstationUsernames oStatUser = new EON_JUMBO_Work_Management_WS.OutstationUsernames();
            oStatUser.Level1 = 'Level1';
            oStatUser.Level2 = 'Level2';
            oStatUser.Level3 = 'Level3';

            EON_JUMBO_Work_Management_WS.CommsBase cBase = new EON_JUMBO_Work_Management_WS.CommsBase();
            cBase.Address = 'Address';
            cBase.BaudRate = '2';
            cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
            cBase.Method = 'Method';
            cBase.Provider = 'Provider';

            EON_JUMBO_Work_Management_WS.CommsBase[] objCBase = new EON_JUMBO_Work_Management_WS.CommsBase[] {
                cBase
            };
            EON_JUMBO_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
            arrCBase.CommsBase = objCBase;

            EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice outCode = new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
            outCode.Code = '12345';
            outCode.Dispensation = 'Dispensation';

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

            EON_JUMBO_Work_Management_WS.Outstation[] objOutStat = new EON_JUMBO_Work_Management_WS.Outstation[] {
                outStat
            };
            EON_JUMBO_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
            arrOutStat.Outstation = objOutStat;

            EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
            priorService.AlternateName = 'AlternateName';
            priorService.AlternateTelephone1 = '988445632';
            priorService.AlternateTelephone2 = '123456987';
            priorService.Name = 'Name';
            priorService.Telephone3 = '123456778';
            priorService.Address = elecAdd;
            priorService.Telephone1 = '988445632';
            priorService.Telephone2 = '988445632';
            priorService.Telephone3 = '988445632';

            EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
            elecSup.EnergisationStatus = 'EnergisationStatus';
            elecSup.Phases = '1';
            elecSup.Voltage = '1400';
            elecSup.Capacity = '200';

            EON_JUMBO_Work_Management_WS.ElecCustomer eCust = new EON_JUMBO_Work_Management_WS.ElecCustomer();
            eCust.AdditionalInformation = 'test';
            eCust.ContractReference = 'test';
            eCust.StdSettlementConfig = dataEff;
            eCust.Supply = elecSup;
            eCust.MeterPointAddress = elecAdd;
            eCust.CustomerName = 'CustomerName';
            eCust.CustomerContact = elecCon;
            eCust.SpecialAccess = 'SpecialAccess';
            eCust.CustomerPassword = 'CustomerPassword';
            eCust.MeterPointAddress = elecAdd;
            eCust.PriorityServiceContactInfo = priorService;
            eCust.CodeOfPractice = eCode;
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
            eCust.RemoteDisableEnableCapability = 'test Remote';
            eCust.ServiceLevelReference = 'test ServiceLevel';
            eCust.ServiceLocation = 'test ServiceLocation';
            eCust.ServiceReference = 'test ServiceReference';
            eCust.SpecialAccess = 'test SpecialAccess';

            EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
            resp.Errors = err;
            resp.Success = true;
            resp.Customer = eCust;

            EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();
            obj.RequestElectricityMeterPointDataResult = resp;
            response.put('response_x', obj);
        }
        if (methodType == 'MPRNInddata') {
            EON_Gas_Meter_Type__c gMeterType = new EON_Gas_Meter_Type__c(Name = 'MCLLOW');
            insert gMeterType;

            EON_Capacity_Categories__c gCapCategory = new EON_Capacity_Categories__c(Name = 'MCLLOW', Gas_Meter_Type__c = 'MCL', Gas_pressure__c = 'LOW', Work_Skill__c = 'Gas3');
            insert gCapCategory;

            String[] Msg = new String[] {
                'Message1', 'Message2', 'Message3'
            };
            EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
            err.Message = Msg;
            EON_JUMBO_Work_Management_WS.GasAddress gasAdd = new EON_JUMBO_Work_Management_WS.GasAddress();
            gasAdd.AddressText = 'AddressText';
            gasAdd.Building = 'AddressText';
            gasAdd.DependentLocality = 'AddressText';
            gasAdd.County = 'County';
            gasAdd.DependentThoroughfare = 'DependentThoroughfare';
            gasAdd.DoubleDependentLocality = 'DoubleDependentLocality';
            gasAdd.PostCode = 'PostCode';
            gasAdd.PostTown = 'PostTown';
            gasAdd.PostTown = 'PostTown';
            gasAdd.SubBuilding = 'SubBuilding';
            gasAdd.UPRN = 'UPRN';
            gasAdd.Thoroughfare = 'Thoroughfare';
            EON_JUMBO_Work_Management_WS.GasMeter gmeter = new EON_JUMBO_Work_Management_WS.GasMeter();
            gmeter.Type_x = String.valueOf(gMeterType.name);
            EON_JUMBO_Work_Management_WS.GasMeter[] objGMeter = new EON_JUMBO_Work_Management_WS.GasMeter[] {
                gmeter
            };
            EON_JUMBO_Work_Management_WS.ArrayOfGasMeter meters = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter();
            meters.GasMeter = objGMeter;

            EON_JUMBO_Work_Management_WS.gasCustomer gCust = new EON_JUMBO_Work_Management_WS.gasCustomer();
            gCust.AccessInstructions = 'AccessInstructions';
            gCust.AccessPassword = 'AccessPassword';
            gCust.ConversionFactor = 'ConversionFactor';
            gCust.LastInspectionDate = 'LastInspectionDate';
            gCust.Location = 'Location';
            gCust.LocationNotes = 'LocationNotes';
            gCust.MPRN = 'MPRN';
            gCust.MeterLink = 'MeterLink';
            gCust.MeterPointStatus = 'MeterPointStatus';
            gCust.MeteringPressure = String.valueOf(gMeterType.id);
            gCust.Address = gasAdd;
            gCust.Meters = meters;

            EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
            resp.Errors = err;
            resp.Success = true;
            resp.Customer = gCust;
            EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();
            obj.RequestgasMeterPointDataResult = resp;
            response.put('response_x', obj);
        }
        if (methodType == 'MPANInddataAndCapacity') {
            String[] Msg = new String[] {
                'Message1', 'Message2', 'Message3'
            };
            EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
            err.Message = Msg;

            EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
            eCode.Code = 'Code';
            eCode.Dispensation = 'Dispensation';
            eCode.IssueNumber = '007';

            EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
            elecCon.Name = 'Name';
            elecCon.Telephone = '12345678';
            elecCon.PreferredContactMethod = 'PreferredContactMethod';
            elecCon.Email = 'test@email.com';
            elecCon.Fax = '4004';

            EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
            elecApp.EffectiveFromDate = '20150423';
            elecApp.EffectiveToDate = '20160823';
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
            timePatt.RegisterMappingCoefficient = '4';

            EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[] {
                timePatt
            };
            EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
            arrTimePatt.TimePatternRegime = objTimePatt;

            EON_JUMBO_Work_Management_WS.ElecRegister eReg = new EON_JUMBO_Work_Management_WS.ElecRegister();
            eReg.AssociatedMeterId = '007';
            eReg.AssociatedRegisterId = '007';
            eReg.ChannelNumber = '1';
            eReg.Description = 'Description';
            eReg.Id = '1234';
            eReg.MeasurementQuantityId = '50';
            eReg.MeterMemoryLocation = '200';
            eReg.Multiplier = '3';
            eReg.NumberOfDigits = '2';
            eReg.PulseMultiplier = '3';
            eReg.TimestampMeterMemoryLocation = '5';
            eReg.Type_x = 'Type_x';
            eReg.TimePatternRegimes = arrTimePatt;

            EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[] {
                eReg
            };
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
            String eMeterTypeValue = String.valueOf(eMeterType1.name);
            eMeter.TimingDeviceSerialNumber = eMeterTypeValue; //'789';
            eMeter.Type_x = 'Type_x';
            eMeter.VTRatio = '7';
            eMeter.Registers = arrEReg;

            EON_JUMBO_Work_Management_WS.ElecMeter[] objEMeter = new EON_JUMBO_Work_Management_WS.ElecMeter[] {
                eMeter
            };
            EON_JUMBO_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
            arrayEM.ElecMeter = objEMeter;

            EON_JUMBO_Work_Management_WS.DataEffectiveFrom dataEff = new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
            dataEff.Id = '1234';
            dataEff.EffectiveFromDate = '2015-04-23';

            EON_JUMBO_Work_Management_WS.OutstationPasswords oStatPwd = new EON_JUMBO_Work_Management_WS.OutstationPasswords();
            oStatPwd.Level1 = 'Level1';
            oStatPwd.Level2 = 'Level2';
            oStatPwd.Level3 = 'Level3';

            EON_JUMBO_Work_Management_WS.OutstationUsernames oStatUser = new EON_JUMBO_Work_Management_WS.OutstationUsernames();
            oStatUser.Level1 = 'Level1';
            oStatUser.Level2 = 'Level2';
            oStatUser.Level3 = 'Level3';

            EON_JUMBO_Work_Management_WS.CommsBase cBase = new EON_JUMBO_Work_Management_WS.CommsBase();
            cBase.Address = 'Address';
            cBase.BaudRate = '2';
            cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
            cBase.Method = 'Method';
            cBase.Provider = 'Provider';

            EON_JUMBO_Work_Management_WS.CommsBase[] objCBase = new EON_JUMBO_Work_Management_WS.CommsBase[] {
                cBase
            };
            EON_JUMBO_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
            arrCBase.CommsBase = objCBase;

            EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice outCode = new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
            outCode.Code = '12345';
            outCode.Dispensation = 'Dispensation';

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

            EON_JUMBO_Work_Management_WS.Outstation[] objOutStat = new EON_JUMBO_Work_Management_WS.Outstation[] {
                outStat
            };
            EON_JUMBO_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
            arrOutStat.Outstation = objOutStat;

            EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
            priorService.AlternateName = 'AlternateName';
            priorService.AlternateTelephone1 = '988445632';
            priorService.AlternateTelephone2 = '123456987';
            priorService.Name = 'Name';
            priorService.Telephone3 = '123456778';
            priorService.Address = elecAdd;
            priorService.Telephone1 = '988445632';
            priorService.Telephone2 = '988445632';
            priorService.Telephone3 = '988445632';

            EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
            elecSup.EnergisationStatus = 'EnergisationStatus';
            elecSup.Phases = '1';
            elecSup.Voltage = '1400';
            elecSup.Capacity = '200';

            EON_JUMBO_Work_Management_WS.ElecCustomer eCust = new EON_JUMBO_Work_Management_WS.ElecCustomer();
            eCust.AdditionalInformation = 'test';
            eCust.ContractReference = 'test';
            eCust.StdSettlementConfig = dataEff;
            eCust.Supply = elecSup;
            eCust.MeterPointAddress = elecAdd;
            eCust.CustomerName = 'CustomerName';
            eCust.CustomerContact = elecCon;
            eCust.SpecialAccess = 'SpecialAccess';
            eCust.CustomerPassword = 'CustomerPassword';
            eCust.MeterPointAddress = elecAdd;
            eCust.PriorityServiceContactInfo = priorService;
            eCust.CodeOfPractice = eCode;
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
            eCust.RemoteDisableEnableCapability = 'test Remote';
            eCust.ServiceLevelReference = 'test ServiceLevel';
            eCust.ServiceLocation = 'test ServiceLocation';
            eCust.ServiceReference = 'test ServiceReference';
            eCust.SpecialAccess = 'test SpecialAccess';

            EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
            resp.Errors = err;
            resp.Success = true;
            resp.Customer = eCust;

            EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();
            obj.RequestElectricityMeterPointDataResult = resp;

            EON_OFSC_GetCapacity_WS.capacity_element capacityElement = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement.location = 'location';
            capacityElement.date_x = system.today();
            capacityElement.time_slot = '14:00-16:00';
            capacityElement.work_skill = 'GA';
            capacityElement.quota = 2;
            capacityElement.available = 2;
          
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement1 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement1.location = 'location';
            capacityElement1.date_x = system.today() + 2;
            capacityElement1.time_slot = '14:00-16:00';
            capacityElement1.work_skill = 'Elec3';
            capacityElement1.quota = 1;
            capacityElement1.available = 1;

            EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement2.location = 'location';
            capacityElement2.date_x = system.today() + 4;
            capacityElement2.time_slot = '14:00-16:00';
            capacityElement2.work_skill = 'Elec3';
            capacityElement2.quota = 2;
            capacityElement2.available = 2;

            List < EON_OFSC_GetCapacity_WS.capacity_element > capacities = new List < EON_OFSC_GetCapacity_WS.capacity_element > ();
            capacities.add(capacityElement);
            capacities.add(capacityElement1);
            capacities.add(capacityElement2);

            EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
            getCapacityResp.capacity = capacities;
            getCapacityResp.activity_duration = 1;
            getCapacityResp.activity_travel_time = 1;

            if (request instanceof EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element) {
                response.put('response_x', obj);
            } else if (request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element) {
                system.debug('####Test: ' + getCapacityResp);
                response.put('response_x', getCapacityResp);
            }
        }
        //CH02.start
        if (methodType == 'MPRNInddataNEW') {
            String[] Msg = new String[] {
                'Message1', 'Message2', 'Message3'
            };
            EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
            err.Message = Msg;
            EON_JUMBO_Work_Management_WS.GasAddress gasAdd = new EON_JUMBO_Work_Management_WS.GasAddress();
            gasAdd.AddressText = 'AddressText';
            gasAdd.Building = 'AddressText';
            gasAdd.DependentLocality = 'AddressText';
            gasAdd.County = 'County';
            gasAdd.DependentThoroughfare = 'DependentThoroughfare';
            gasAdd.DoubleDependentLocality = 'DoubleDependentLocality';
            gasAdd.PostCode = 'PostCode';
            gasAdd.PostTown = 'PostTown';
            gasAdd.PostTown = 'PostTown';
            gasAdd.SubBuilding = 'SubBuilding';
            gasAdd.UPRN = 'UPRN';
            gasAdd.Thoroughfare = 'Thoroughfare';

            EON_JUMBO_Work_Management_WS.GasRegister gRegi = new EON_JUMBO_Work_Management_WS.GasRegister();
            gRegi.MultiplicationFactor = '3';
            gRegi.NumberOfDigits = '2';
            gRegi.UnitsOfMeasure = '5';

            EON_JUMBO_Work_Management_WS.GasRegister[] objGasReg = new EON_JUMBO_Work_Management_WS.GasRegister[] {
                gRegi
            };
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
            gMet.PaymentMethod = 'PaymentMethod';
            gMet.PulseValue = '789';
            gMet.SerialNumber = '1245';
            gMet.Status = 'Status';
            gMet.Type_x = 'T';
            gMet.Usage = 'Usage';
            gMet.YearOfManufacture = '2015';
            gMet.Registers = arrGReg;

            EON_JUMBO_Work_Management_WS.GasMeter[] objGasMet = new EON_JUMBO_Work_Management_WS.GasMeter[] {
                gMet
            };
            EON_JUMBO_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter();
            arrGMeter.GasMeter = objGasMet;

            EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
            gasAObj.EffectiveFromDate = '20160828';
            gasAObj.EffectiveToDate = '20160923';
            gasAObj.AbbreviatedName = 'EAS';

            EON_JUMBO_Work_Management_WS.Converter conver = new EON_JUMBO_Work_Management_WS.Converter();
            conver.SerialNumber = '007';
            conver.Model = 'Model';
            conver.AssetClass = 'AssetClass';
            conver.Manufacturer = 'Manufacturer';
            conver.Location = 'Location';

            EON_JUMBO_Work_Management_WS.Converter[] objConver = new EON_JUMBO_Work_Management_WS.Converter[] {
                conver
            };
            EON_JUMBO_Work_Management_WS.ArrayOfConverter arrConver = new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
            arrConver.Converter = objConver;

            EON_JUMBO_Work_Management_WS.ContactMechanism contMec = new EON_JUMBO_Work_Management_WS.ContactMechanism();
            contMec.Code = '007';
            contMec.Value = '007';

            EON_JUMBO_Work_Management_WS.ContactMechanism[] objContMec = new EON_JUMBO_Work_Management_WS.ContactMechanism[] {
                contMec
            };
            EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism arrContMec = new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
            arrContMec.ContactMechanism = objContMec;

            EON_JUMBO_Work_Management_WS.Contact cont = new EON_JUMBO_Work_Management_WS.Contact();
            cont.TypeCode = 'TypeCode';
            cont.Initials = 'Initials';
            cont.Surname = 'Surname';
            cont.Title = 'Title';
            cont.ContactMechanism = arrContMec;

            EON_JUMBO_Work_Management_WS.Contact[] objCont = new EON_JUMBO_Work_Management_WS.Contact[] {
                cont
            };
            EON_JUMBO_Work_Management_WS.ArrayOfContact arrCont = new EON_JUMBO_Work_Management_WS.ArrayOfContact();
            arrCont.Contact = objCont;

            EON_JUMBO_Work_Management_WS.gasCustomer gCust = new EON_JUMBO_Work_Management_WS.gasCustomer();
            gCust.AccessInstructions = 'AccessInstructions';
            gCust.AccessPassword = 'AccessPassword';
            gCust.ConversionFactor = 'ConversionFactor';
            gCust.LastInspectionDate = 'LastInspectionDate';
            gCust.Location = 'Location';
            gCust.LocationNotes = 'LocationNotes';
            gCust.MPRN = 'MPRN';
            gCust.MeterLink = 'MeterLink';
            gCust.MeterPointStatus = 'MeterPointStatus';
            gCust.MeteringPressure = '1';
            gCust.Address = gasAdd;
            gCust.Meters = arrGMeter;
            gCust.Supplier = gasAObj;
            gCust.Converters = arrConver;
            gCust.Contacts = arrCont;

            EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
            resp.Errors = err;
            resp.Success = true;
            resp.Customer = gCust;

            EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();
            obj.RequestgasMeterPointDataResult = resp;
            if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element)
                response.put('response_x', obj);
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element) {
                String[] Msg1 = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList errObj1 = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj1.Message = Msg1;
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj1 = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
                gasAObj1.EffectiveFromDate = '20150423';
                gasAObj1.EffectiveToDate = '20160823';
                gasAObj1.AbbreviatedName = 'SGL';
                EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[] {
                    gasAObj1
                };
                EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                aepObj.GasAppointedParty = gasAppobj;
                EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                empObj.MPRN = 'mprn123';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint = empObj;
                respJumbo.Errors = errObj1;
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj1 = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj1.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj1);
            } else if (request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element) {
                List < EON_OFSC_GetCapacity_WS.capacity_element > capacities = new List < EON_OFSC_GetCapacity_WS.capacity_element > ();
                EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement2.location = 'location';
                capacityElement2.date_x = system.today();
                capacityElement2.time_slot = '25:00-26:00';
                capacityElement2.work_skill = 'workSkill';
                capacityElement2.quota = 218;
                capacityElement2.available = 1;
                capacities.add(capacityElement2);
                EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
                getCapacityResp.capacity = capacities;
                getCapacityResp.activity_duration = 1;
                getCapacityResp.activity_travel_time = 1;
                response.put('response_x', getCapacityResp);
            }
        }
        //CH02.end
        if (methodType == 'MPANInddataAndwithoutCapacity') {
            String[] Msg = new String[] {
                'Message1', 'Message2', 'Message3'
            };
            EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
            err.Message = Msg;

            EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
            eCode.Code = 'Code';
            eCode.Dispensation = 'Dispensation';
            eCode.IssueNumber = '007';

            EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
            elecCon.Name = 'Name';
            elecCon.Telephone = '12345678';
            elecCon.PreferredContactMethod = 'PreferredContactMethod';
            elecCon.Email = 'test@email.com';
            elecCon.Fax = '4004';

            EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
            elecApp.EffectiveFromDate = '20150423';
            elecApp.EffectiveToDate = '20160823';
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
            timePatt.RegisterMappingCoefficient = '4';

            EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[] {
                timePatt
            };
            EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
            arrTimePatt.TimePatternRegime = objTimePatt;

            EON_JUMBO_Work_Management_WS.ElecRegister eReg = new EON_JUMBO_Work_Management_WS.ElecRegister();
            eReg.AssociatedMeterId = '007';
            eReg.AssociatedRegisterId = '007';
            eReg.ChannelNumber = '1';
            eReg.Description = 'Description';
            eReg.Id = '1234';
            eReg.MeasurementQuantityId = '50';
            eReg.MeterMemoryLocation = '200';
            eReg.Multiplier = '3';
            eReg.NumberOfDigits = '2';
            eReg.PulseMultiplier = '3';
            eReg.TimestampMeterMemoryLocation = '5';
            eReg.Type_x = 'Type_x';
            eReg.TimePatternRegimes = arrTimePatt;

            EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[] {
                eReg
            };
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
            String eMeterTypeValue = String.valueOf(eMeterType1.name);
            eMeter.TimingDeviceSerialNumber = eMeterTypeValue;
            eMeter.Type_x = 'test';
            eMeter.VTRatio = '7';
            eMeter.Registers = arrEReg;

            EON_JUMBO_Work_Management_WS.ElecMeter[] objEMeter = new EON_JUMBO_Work_Management_WS.ElecMeter[] {
                eMeter
            };
            EON_JUMBO_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
            arrayEM.ElecMeter = objEMeter;

            EON_JUMBO_Work_Management_WS.DataEffectiveFrom dataEff = new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
            dataEff.Id = '1234';
            dataEff.EffectiveFromDate = '20150423';

            EON_JUMBO_Work_Management_WS.OutstationPasswords oStatPwd = new EON_JUMBO_Work_Management_WS.OutstationPasswords();
            oStatPwd.Level1 = 'Level1';
            oStatPwd.Level2 = 'Level2';
            oStatPwd.Level3 = 'Level3';

            EON_JUMBO_Work_Management_WS.OutstationUsernames oStatUser = new EON_JUMBO_Work_Management_WS.OutstationUsernames();
            oStatUser.Level1 = 'Level1';
            oStatUser.Level2 = 'Level2';
            oStatUser.Level3 = 'Level3';

            EON_JUMBO_Work_Management_WS.CommsBase cBase = new EON_JUMBO_Work_Management_WS.CommsBase();
            cBase.Address = 'Address';
            cBase.BaudRate = '2';
            cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
            cBase.Method = 'Method';
            cBase.Provider = 'Provider';

            EON_JUMBO_Work_Management_WS.CommsBase[] objCBase = new EON_JUMBO_Work_Management_WS.CommsBase[] {
                cBase
            };
            EON_JUMBO_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
            arrCBase.CommsBase = objCBase;

            EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice outCode = new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
            outCode.Code = '12345';
            outCode.Dispensation = 'Dispensation';

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

            EON_JUMBO_Work_Management_WS.Outstation[] objOutStat = new EON_JUMBO_Work_Management_WS.Outstation[] {
                outStat
            };
            EON_JUMBO_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
            arrOutStat.Outstation = objOutStat;

            EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
            priorService.AlternateName = 'AlternateName';
            priorService.AlternateTelephone1 = '988445632';
            priorService.AlternateTelephone2 = '123456987';
            priorService.Name = 'Name';
            priorService.Telephone3 = '123456778';
            priorService.Address = elecAdd;
            priorService.Telephone1 = '988445632';
            priorService.Telephone2 = '988445632';
            priorService.Telephone3 = '988445632';

            EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
            elecSup.EnergisationStatus = 'EnergisationStatus';
            elecSup.Phases = '1';
            elecSup.Voltage = '1400';
            elecSup.Capacity = '200';

            EON_JUMBO_Work_Management_WS.ElecCustomer eCust = new EON_JUMBO_Work_Management_WS.ElecCustomer();
            eCust.AdditionalInformation = 'test';
            eCust.ContractReference = 'test';
            eCust.StdSettlementConfig = dataEff;
            eCust.Supply = elecSup;
            eCust.MeterPointAddress = elecAdd;
            eCust.CustomerName = 'CustomerName';
            eCust.CustomerContact = elecCon;
            eCust.SpecialAccess = 'SpecialAccess';
            eCust.CustomerPassword = 'CustomerPassword';
            eCust.MeterPointAddress = elecAdd;
            eCust.PriorityServiceContactInfo = priorService;
            eCust.CodeOfPractice = eCode;
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
            eCust.RemoteDisableEnableCapability = 'test Remote';
            eCust.ServiceLevelReference = 'test ServiceLevel';
            eCust.ServiceLocation = 'test ServiceLocation';
            eCust.ServiceReference = 'test ServiceReference';
            eCust.SpecialAccess = 'test SpecialAccess';

            EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
            resp.Errors = err;
            resp.Success = true;
            resp.Customer = eCust;

            EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();
            obj.RequestElectricityMeterPointDataResult = resp;

            EON_OFSC_GetCapacity_WS.capacity_element capacityElement = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement.location = 'location';
            capacityElement.date_x = system.today();
            capacityElement.time_slot = '14:00-16:00';
            capacityElement.work_skill = 'GA';
            capacityElement.quota = 2;
            capacityElement.available = 2;

            EON_OFSC_GetCapacity_WS.capacity_element capacityElement1 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement1.location = 'location';
            capacityElement1.date_x = system.today() + 2;
            capacityElement1.time_slot = '14:00-16:00';
            capacityElement1.work_skill = 'Elec3';
            capacityElement1.quota = 1;
            capacityElement1.available = 1;

            EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement2.location = 'location';
            capacityElement2.date_x = system.today() + 4;
            capacityElement2.time_slot = '14:00-16:00';
            capacityElement2.work_skill = 'Elec3';
            capacityElement2.quota = 2;
            capacityElement2.available = 2;

            List < EON_OFSC_GetCapacity_WS.capacity_element > capacities = new List < EON_OFSC_GetCapacity_WS.capacity_element > ();
            capacities.add(capacityElement);
            capacities.add(capacityElement1);
            capacities.add(capacityElement2);

            EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
            getCapacityResp.capacity = capacities;
            getCapacityResp.activity_duration = 1;
            getCapacityResp.activity_travel_time = 1;

            if (request instanceof EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element) {
                response.put('response_x', obj);
            } else if (request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element) {
                response.put('response_x', getCapacityResp);
            }
        }
        if (methodType == 'MPANInddataWithNoCapacity') {
            String[] Msg = new String[] {
                'Message1', 'Message2', 'Message3'
            };
            EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
            err.Message = Msg;

            EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
            eCode.Code = 'Code';
            eCode.Dispensation = 'Dispensation';
            eCode.IssueNumber = '007';

            EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
            elecCon.Name = 'Name';
            elecCon.Telephone = '12345678';
            elecCon.PreferredContactMethod = 'PreferredContactMethod';
            elecCon.Email = 'test@email.com';
            elecCon.Fax = '4004';

            EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
            elecApp.EffectiveFromDate = '20150423';
            elecApp.EffectiveToDate = '20160823';
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
            timePatt.RegisterMappingCoefficient = '4';

            EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[] {
                timePatt
            };
            EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
            arrTimePatt.TimePatternRegime = objTimePatt;

            EON_JUMBO_Work_Management_WS.ElecRegister eReg = new EON_JUMBO_Work_Management_WS.ElecRegister();
            eReg.AssociatedMeterId = '007';
            eReg.AssociatedRegisterId = '007';
            eReg.ChannelNumber = '1';
            eReg.Description = 'Description';
            eReg.Id = '1234';
            eReg.MeasurementQuantityId = '50';
            eReg.MeterMemoryLocation = '200';
            eReg.Multiplier = '3';
            eReg.NumberOfDigits = '2';
            eReg.PulseMultiplier = '3';
            eReg.TimestampMeterMemoryLocation = '5';
            eReg.Type_x = 'Type_x';
            eReg.TimePatternRegimes = arrTimePatt;

            EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[] {
                eReg
            };
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
            String eMeterTypeValue = String.valueOf(eMeterType1.name);
            eMeter.TimingDeviceSerialNumber = eMeterTypeValue;
            eMeter.Type_x = 'test';
            eMeter.VTRatio = '7';
            eMeter.Registers = arrEReg;

            EON_JUMBO_Work_Management_WS.ElecMeter[] objEMeter = new EON_JUMBO_Work_Management_WS.ElecMeter[] {
                eMeter
            };
            EON_JUMBO_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
            arrayEM.ElecMeter = objEMeter;

            EON_JUMBO_Work_Management_WS.DataEffectiveFrom dataEff = new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
            dataEff.Id = '1234';
            dataEff.EffectiveFromDate = '2015-04-23';

            EON_JUMBO_Work_Management_WS.OutstationPasswords oStatPwd = new EON_JUMBO_Work_Management_WS.OutstationPasswords();
            oStatPwd.Level1 = 'Level1';
            oStatPwd.Level2 = 'Level2';
            oStatPwd.Level3 = 'Level3';

            EON_JUMBO_Work_Management_WS.OutstationUsernames oStatUser = new EON_JUMBO_Work_Management_WS.OutstationUsernames();
            oStatUser.Level1 = 'Level1';
            oStatUser.Level2 = 'Level2';
            oStatUser.Level3 = 'Level3';

            EON_JUMBO_Work_Management_WS.CommsBase cBase = new EON_JUMBO_Work_Management_WS.CommsBase();
            cBase.Address = 'Address';
            cBase.BaudRate = '2';
            cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
            cBase.Method = 'Method';
            cBase.Provider = 'Provider';

            EON_JUMBO_Work_Management_WS.CommsBase[] objCBase = new EON_JUMBO_Work_Management_WS.CommsBase[] {
                cBase
            };
            EON_JUMBO_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
            arrCBase.CommsBase = objCBase;

            EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice outCode = new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
            outCode.Code = '12345';
            outCode.Dispensation = 'Dispensation';

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

            EON_JUMBO_Work_Management_WS.Outstation[] objOutStat = new EON_JUMBO_Work_Management_WS.Outstation[] {
                outStat
            };
            EON_JUMBO_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
            arrOutStat.Outstation = objOutStat;

            EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
            priorService.AlternateName = 'AlternateName';
            priorService.AlternateTelephone1 = '988445632';
            priorService.AlternateTelephone2 = '123456987';
            priorService.Name = 'Name';
            priorService.Telephone3 = '123456778';
            priorService.Address = elecAdd;
            priorService.Telephone1 = '988445632';
            priorService.Telephone2 = '988445632';
            priorService.Telephone3 = '988445632';

            EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
            elecSup.EnergisationStatus = 'EnergisationStatus';
            elecSup.Phases = '1';
            elecSup.Voltage = '1400';
            elecSup.Capacity = '200';

            EON_JUMBO_Work_Management_WS.ElecCustomer eCust = new EON_JUMBO_Work_Management_WS.ElecCustomer();
            eCust.AdditionalInformation = 'test';
            eCust.ContractReference = 'test';
            eCust.StdSettlementConfig = dataEff;
            eCust.Supply = elecSup;
            eCust.MeterPointAddress = elecAdd;
            eCust.CustomerName = 'CustomerName';
            eCust.CustomerContact = elecCon;
            eCust.SpecialAccess = 'SpecialAccess';
            eCust.CustomerPassword = 'CustomerPassword';
            eCust.MeterPointAddress = elecAdd;
            eCust.PriorityServiceContactInfo = priorService;
            eCust.CodeOfPractice = eCode;
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
            eCust.RemoteDisableEnableCapability = 'test Remote';
            eCust.ServiceLevelReference = 'test ServiceLevel';
            eCust.ServiceLocation = 'test ServiceLocation';
            eCust.ServiceReference = 'test ServiceReference';
            eCust.SpecialAccess = 'test SpecialAccess';

            EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
            resp.Errors = err;
            resp.Success = true;
            resp.Customer = eCust;

            EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();
            obj.RequestElectricityMeterPointDataResult = resp;

            List < EON_OFSC_GetCapacity_WS.capacity_element > capacities = new List < EON_OFSC_GetCapacity_WS.capacity_element > ();

            EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
            getCapacityResp.capacity = capacities;
            getCapacityResp.activity_duration = 1;
            getCapacityResp.activity_travel_time = 1;

            if (request instanceof EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element) {
                response.put('response_x', obj);
            } else if (request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element) {
                response.put('response_x', getCapacityResp);
            }
        }
        if (methodType == 'MAMMPRNInddataNEW') {
            system.debug('####Request: ' + request);
            system.debug('####Stub: ' + stub);
            String[] Msg = new String[] {
                'Message1', 'Message2', 'Message3'
            };
            EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
            err.Message = Msg;
            EON_JUMBO_Work_Management_WS.GasAddress gasAdd = new EON_JUMBO_Work_Management_WS.GasAddress();
            gasAdd.AddressText = 'AddressText';
            gasAdd.Building = 'AddressText';
            gasAdd.DependentLocality = 'AddressText';
            gasAdd.County = 'County';
            gasAdd.DependentThoroughfare = 'DependentThoroughfare';
            gasAdd.DoubleDependentLocality = 'DoubleDependentLocality';
            gasAdd.PostCode = 'PostCode';
            gasAdd.PostTown = 'PostTown';
            gasAdd.PostTown = 'PostTown';
            gasAdd.SubBuilding = 'SubBuilding';
            gasAdd.UPRN = 'UPRN';
            gasAdd.Thoroughfare = 'Thoroughfare';

            EON_JUMBO_Work_Management_WS.GasRegister gRegi = new EON_JUMBO_Work_Management_WS.GasRegister();
            gRegi.MultiplicationFactor = '3';
            gRegi.NumberOfDigits = '2';
            gRegi.UnitsOfMeasure = '5';

            EON_JUMBO_Work_Management_WS.GasRegister[] objGasReg = new EON_JUMBO_Work_Management_WS.GasRegister[] {
                gRegi
            };
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
            gMet.PaymentMethod = 'PaymentMethod';
            gMet.PulseValue = '789';
            gMet.SerialNumber = '1245';
            gMet.Status = 'Status';
            gMet.Type_x = 'T';
            gMet.Usage = 'Usage';
            gMet.YearOfManufacture = '2015';
            gMet.Registers = arrGReg;

            EON_JUMBO_Work_Management_WS.GasMeter[] objGasMet = new EON_JUMBO_Work_Management_WS.GasMeter[] {
                gMet
            };
            EON_JUMBO_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter();
            arrGMeter.GasMeter = objGasMet;

            EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
            if (DateLessThanToday) {
                String month = String.valueOf(System.Date.today().month() - 1);
                if (month.length() != 2)
                    month = '0' + month;
                String day = String.valueOf(System.Date.today().day());
                if (day.length() != 2)
                    day = '0' + day;
                gasAObj.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                gasAObj.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + day;
            } else {
                String month = String.valueOf(System.Date.today().month());
                if (month.length() != 2)
                    month = '0' + month;
                String day = String.valueOf(System.Date.today().day());
                if (day.length() != 2)
                    day = '0' + day;
                gasAObj.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                gasAObj.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + String.valueOf(System.Date.today().day() + 20);
            }
            gasAObj.AbbreviatedName = 'MORR';

            EON_JUMBO_Work_Management_WS.Converter conver = new EON_JUMBO_Work_Management_WS.Converter();
            conver.SerialNumber = '007';
            conver.Model = 'Model';
            conver.AssetClass = 'AssetClass';
            conver.Manufacturer = 'Manufacturer';
            conver.Location = 'Location';

            EON_JUMBO_Work_Management_WS.Converter[] objConver = new EON_JUMBO_Work_Management_WS.Converter[] {
                conver
            };
            EON_JUMBO_Work_Management_WS.ArrayOfConverter arrConver = new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
            arrConver.Converter = objConver;

            EON_JUMBO_Work_Management_WS.ContactMechanism contMec = new EON_JUMBO_Work_Management_WS.ContactMechanism();
            contMec.Code = '007';
            contMec.Value = '007';

            EON_JUMBO_Work_Management_WS.ContactMechanism[] objContMec = new EON_JUMBO_Work_Management_WS.ContactMechanism[] {
                contMec
            };
            EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism arrContMec = new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
            arrContMec.ContactMechanism = objContMec;

            EON_JUMBO_Work_Management_WS.Contact cont = new EON_JUMBO_Work_Management_WS.Contact();
            cont.TypeCode = 'TypeCode';
            cont.Initials = 'Initials';
            cont.Surname = 'Surname';
            cont.Title = 'Title';
            cont.ContactMechanism = arrContMec;

            EON_JUMBO_Work_Management_WS.Contact[] objCont = new EON_JUMBO_Work_Management_WS.Contact[] {
                cont
            };
            EON_JUMBO_Work_Management_WS.ArrayOfContact arrCont = new EON_JUMBO_Work_Management_WS.ArrayOfContact();
            arrCont.Contact = objCont;

            EON_JUMBO_Work_Management_WS.gasCustomer gCust = new EON_JUMBO_Work_Management_WS.gasCustomer();
            gCust.AccessInstructions = 'AccessInstructions';
            gCust.AccessPassword = 'AccessPassword';
            gCust.ConversionFactor = 'ConversionFactor';
            gCust.LastInspectionDate = 'LastInspectionDate';
            gCust.Location = 'Location';
            gCust.LocationNotes = 'LocationNotes';
            gCust.MPRN = 'MPRN';
            gCust.MeterLink = 'MeterLink';
            gCust.MeterPointStatus = 'MeterPointStatus';
            gCust.MeteringPressure = '1';
            gCust.Address = gasAdd;
            gCust.Meters = arrGMeter;
            gCust.Supplier = gasAObj;
            gCust.Converters = arrConver;
            gCust.Contacts = arrCont;

            EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
            resp.Errors = err;
            resp.Success = true;
            resp.Customer = gCust;

            //MAM Response
            String[] Msg1 = new String[] {
                'Message1', 'Message2', 'Message3'
            };
            EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
            errObj.Message = Msg1;
            EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj1 = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
            //Format Date 
            if (DateLessThanToday) {
                String month = String.valueOf(System.Date.today().month() - 1);
                if (month.length() != 2)
                    month = '0' + month;
                String day = String.valueOf(System.Date.today().day());
                if (day.length() != 2)
                    day = '0' + day;
                gasAObj1.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                gasAObj1.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + day;
            } else {
                String month = String.valueOf(System.Date.today().month());
                if (month.length() != 2)
                    month = '0' + month;
                String day = String.valueOf(System.Date.today().day());
                if (day.length() != 2)
                    day = '0' + day;
                gasAObj1.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                gasAObj1.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + String.valueOf(System.Date.today().day() + 20);
            }
            gasAObj1.AbbreviatedName = 'SGL';
            EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[] {
                gasAObj1
            };
            EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
            aepObj.GasAppointedParty = gasAppobj;
            EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
            empObj.MPRN = 'mprn123';
            empObj.SupplierAppointments = aepObj;
            EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
            respJumbo.Success = true;
            respJumbo.MeterPoint = empObj;
            respJumbo.Errors = errObj;

            //Resturn result for - validate MAM
            if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element) {
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }

            //Return result - MPAN Details
            if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element) {
                EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();
                obj.RequestgasMeterPointDataResult = resp;
                response.put('response_x', obj);
            }
        }
        if (methodType == 'DuelFuelWithCapacities') {
            //Valid MOP
            if (request instanceof EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element) {
                String[] Msg = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
                eapObj.EffectiveFromDate = '20150423'; //CH04.New
                eapObj.EffectiveToDate = '20160823'; //CH04.New
                eapObj.MarketParticipantId = 'EMEB';
                EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[] {
                    eapObj
                };
                EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
                aepObj.ElecAppointedParty = aEobj;
                EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
                empObj.MPAN = 'mpan123';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint = empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element validMop = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
                validMop.RequestElectricitySupplierAppointmentsResult = respJumbo;
                response.put('response_x', validMop);
            }
            //Valid MAM
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element) {
                String[] Msg1 = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg1;
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj1 = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
                if (DateLessThanToday) {
                    String month = String.valueOf(System.Date.today().month() - 1);
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj1.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj1.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + day;
                } else {
                    String month = String.valueOf(System.Date.today().month());
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj1.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj1.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + String.valueOf(System.Date.today().day() + 20);
                }
                gasAObj1.AbbreviatedName = 'SGL';
                EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[] {
                    gasAObj1
                };
                EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                aepObj.GasAppointedParty = gasAppobj;
                EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                empObj.MPRN = 'mprn123';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint = empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
            //Get MPAN Data
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element) {
                String[] Msg = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                err.Message = Msg;

                EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
                eCode.Code = 'Code';
                eCode.Dispensation = 'Dispensation';
                eCode.IssueNumber = '007';

                EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
                elecCon.Name = 'Name';
                elecCon.Telephone = '12345678';
                elecCon.PreferredContactMethod = 'PreferredContactMethod';
                elecCon.Email = 'test@email.com';
                elecCon.Fax = '4004';

                EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
                elecApp.EffectiveFromDate = '20150423';
                elecApp.EffectiveToDate = '20160823';
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
                timePatt.RegisterMappingCoefficient = '4';

                EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[] {
                    timePatt
                };
                EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
                arrTimePatt.TimePatternRegime = objTimePatt;

                EON_JUMBO_Work_Management_WS.ElecRegister eReg = new EON_JUMBO_Work_Management_WS.ElecRegister();
                eReg.AssociatedMeterId = '007';
                eReg.AssociatedRegisterId = '007';
                eReg.ChannelNumber = '1';
                eReg.Description = 'Description';
                eReg.Id = '1234';
                eReg.MeasurementQuantityId = '50';
                eReg.MeterMemoryLocation = '200';
                eReg.Multiplier = '3';
                eReg.NumberOfDigits = '2';
                eReg.PulseMultiplier = '3';
                eReg.TimestampMeterMemoryLocation = '5';
                eReg.Type_x = 'Type_x';
                eReg.TimePatternRegimes = arrTimePatt;

                EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[] {
                    eReg
                };
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
                String eMeterTypeValue = String.valueOf(eMeterType1.name);
                eMeter.TimingDeviceSerialNumber = eMeterTypeValue; //'789';
                eMeter.Type_x = 'N';
                eMeter.VTRatio = '7';
                eMeter.Registers = arrEReg;

                EON_JUMBO_Work_Management_WS.ElecMeter[] objEMeter = new EON_JUMBO_Work_Management_WS.ElecMeter[] {
                    eMeter
                };
                EON_JUMBO_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
                arrayEM.ElecMeter = objEMeter;

                EON_JUMBO_Work_Management_WS.DataEffectiveFrom dataEff = new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
                dataEff.Id = '1234';
                dataEff.EffectiveFromDate = '2015-04-23';

                EON_JUMBO_Work_Management_WS.OutstationPasswords oStatPwd = new EON_JUMBO_Work_Management_WS.OutstationPasswords();
                oStatPwd.Level1 = 'Level1';
                oStatPwd.Level2 = 'Level2';
                oStatPwd.Level3 = 'Level3';

                EON_JUMBO_Work_Management_WS.OutstationUsernames oStatUser = new EON_JUMBO_Work_Management_WS.OutstationUsernames();
                oStatUser.Level1 = 'Level1';
                oStatUser.Level2 = 'Level2';
                oStatUser.Level3 = 'Level3';

                EON_JUMBO_Work_Management_WS.CommsBase cBase = new EON_JUMBO_Work_Management_WS.CommsBase();
                cBase.Address = 'Address';
                cBase.BaudRate = '2';
                cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
                cBase.Method = 'Method';
                cBase.Provider = 'Provider';

                EON_JUMBO_Work_Management_WS.CommsBase[] objCBase = new EON_JUMBO_Work_Management_WS.CommsBase[] {
                    cBase
                };
                EON_JUMBO_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
                arrCBase.CommsBase = objCBase;

                EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice outCode = new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
                outCode.Code = '12345';
                outCode.Dispensation = 'Dispensation';

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

                EON_JUMBO_Work_Management_WS.Outstation[] objOutStat = new EON_JUMBO_Work_Management_WS.Outstation[] {
                    outStat
                };
                EON_JUMBO_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
                arrOutStat.Outstation = objOutStat;

                EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
                priorService.AlternateName = 'AlternateName';
                priorService.AlternateTelephone1 = '988445632';
                priorService.AlternateTelephone2 = '123456987';
                priorService.Name = 'Name';
                priorService.Telephone3 = '123456778';
                priorService.Address = elecAdd;
                priorService.Telephone1 = '988445632';
                priorService.Telephone2 = '988445632';
                priorService.Telephone3 = '988445632';

                EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
                elecSup.EnergisationStatus = 'EnergisationStatus';
                elecSup.Phases = '1';
                elecSup.Voltage = '1400';
                elecSup.Capacity = '200';

                EON_JUMBO_Work_Management_WS.ElecCustomer eCust = new EON_JUMBO_Work_Management_WS.ElecCustomer();
                eCust.AdditionalInformation = 'test';
                eCust.ContractReference = 'test';
                eCust.StdSettlementConfig = dataEff;
                eCust.Supply = elecSup;
                eCust.MeterPointAddress = elecAdd;
                eCust.CustomerName = 'CustomerName';
                eCust.CustomerContact = elecCon;
                eCust.SpecialAccess = 'SpecialAccess';
                eCust.CustomerPassword = 'CustomerPassword';
                eCust.MeterPointAddress = elecAdd;
                eCust.PriorityServiceContactInfo = priorService;
                eCust.CodeOfPractice = eCode;
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
                eCust.RemoteDisableEnableCapability = 'test Remote';
                eCust.ServiceLevelReference = 'test ServiceLevel';
                eCust.ServiceLocation = 'test ServiceLocation';
                eCust.ServiceReference = 'test ServiceReference';
                eCust.SpecialAccess = 'test SpecialAccess';

                EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
                resp.Errors = err;
                resp.Success = true;
                resp.Customer = eCust;

                EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();
                obj.RequestElectricityMeterPointDataResult = resp;
                response.put('response_x', obj);
            }
            //Get MPRN Data
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element) {
                String[] Msg = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                err.Message = Msg;
                EON_JUMBO_Work_Management_WS.GasAddress gasAdd = new EON_JUMBO_Work_Management_WS.GasAddress();
                gasAdd.AddressText = 'AddressText';
                gasAdd.Building = 'AddressText';
                gasAdd.DependentLocality = 'AddressText';
                gasAdd.County = 'County';
                gasAdd.DependentThoroughfare = 'DependentThoroughfare';
                gasAdd.DoubleDependentLocality = 'DoubleDependentLocality';
                gasAdd.PostCode = 'PostCode';
                gasAdd.PostTown = 'PostTown';
                gasAdd.PostTown = 'PostTown';
                gasAdd.SubBuilding = 'SubBuilding';
                gasAdd.UPRN = 'UPRN';
                gasAdd.Thoroughfare = 'Thoroughfare';

                EON_JUMBO_Work_Management_WS.GasRegister gRegi = new EON_JUMBO_Work_Management_WS.GasRegister();
                gRegi.MultiplicationFactor = '3';
                gRegi.NumberOfDigits = '2';
                gRegi.UnitsOfMeasure = '5';

                EON_JUMBO_Work_Management_WS.GasRegister[] objGasReg = new EON_JUMBO_Work_Management_WS.GasRegister[] {
                    gRegi
                };
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
                gMet.PaymentMethod = 'PaymentMethod';
                gMet.PulseValue = '789';
                gMet.SerialNumber = '1245';
                gMet.Status = 'Status';
                gMet.Type_x = 'T';
                gMet.Usage = 'Usage';
                gMet.YearOfManufacture = '2015';
                gMet.Registers = arrGReg;

                EON_JUMBO_Work_Management_WS.GasMeter[] objGasMet = new EON_JUMBO_Work_Management_WS.GasMeter[] {
                    gMet
                };
                EON_JUMBO_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter();
                arrGMeter.GasMeter = objGasMet;

                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
                if (DateLessThanToday) {
                    String month = String.valueOf(System.Date.today().month() - 1);
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + day;
                } else {
                    String month = String.valueOf(System.Date.today().month());
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + String.valueOf(System.Date.today().day() + 20);
                }
                gasAObj.AbbreviatedName = 'MORR';

                EON_JUMBO_Work_Management_WS.Converter conver = new EON_JUMBO_Work_Management_WS.Converter();
                conver.SerialNumber = '007';
                conver.Model = 'Model';
                conver.AssetClass = 'AssetClass';
                conver.Manufacturer = 'Manufacturer';
                conver.Location = 'Location';

                EON_JUMBO_Work_Management_WS.Converter[] objConver = new EON_JUMBO_Work_Management_WS.Converter[] {
                    conver
                };
                EON_JUMBO_Work_Management_WS.ArrayOfConverter arrConver = new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
                arrConver.Converter = objConver;

                EON_JUMBO_Work_Management_WS.ContactMechanism contMec = new EON_JUMBO_Work_Management_WS.ContactMechanism();
                contMec.Code = '007';
                contMec.Value = '007';

                EON_JUMBO_Work_Management_WS.ContactMechanism[] objContMec = new EON_JUMBO_Work_Management_WS.ContactMechanism[] {
                    contMec
                };
                EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism arrContMec = new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
                arrContMec.ContactMechanism = objContMec;

                EON_JUMBO_Work_Management_WS.Contact cont = new EON_JUMBO_Work_Management_WS.Contact();
                cont.TypeCode = 'TypeCode';
                cont.Initials = 'Initials';
                cont.Surname = 'Surname';
                cont.Title = 'Title';
                cont.ContactMechanism = arrContMec;

                EON_JUMBO_Work_Management_WS.Contact[] objCont = new EON_JUMBO_Work_Management_WS.Contact[] {
                    cont
                };
                EON_JUMBO_Work_Management_WS.ArrayOfContact arrCont = new EON_JUMBO_Work_Management_WS.ArrayOfContact();
                arrCont.Contact = objCont;

                EON_JUMBO_Work_Management_WS.gasCustomer gCust = new EON_JUMBO_Work_Management_WS.gasCustomer();
                gCust.AccessInstructions = 'AccessInstructions';
                gCust.AccessPassword = 'AccessPassword';
                gCust.ConversionFactor = 'ConversionFactor';
                gCust.LastInspectionDate = 'LastInspectionDate';
                gCust.Location = 'Location';
                gCust.LocationNotes = 'LocationNotes';
                gCust.MPRN = 'MPRN';
                gCust.MeterLink = 'MeterLink';
                gCust.MeterPointStatus = 'MeterPointStatus';
                gCust.MeteringPressure = '1';
                gCust.Address = gasAdd;
                gCust.Meters = arrGMeter;
                gCust.Supplier = gasAObj;
                gCust.Converters = arrConver;
                gCust.Contacts = arrCont;

                EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
                resp.Errors = err;
                resp.Success = true;
                resp.Customer = gCust;
                EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();
                obj.RequestgasMeterPointDataResult = resp;
                response.put('response_x', obj);
            }
            //Get Capacities
            else if (request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element) {
                EON_OFSC_GetCapacity_WS.capacity_element capacityElement = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement.location = 'location';
                capacityElement.date_x = system.today();
                capacityElement.time_slot = '14:00-16:00';
                capacityElement.work_skill = 'GA';
                capacityElement.quota = 2;
                capacityElement.available = 2;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement1 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement1.location = 'location';
                capacityElement1.date_x = system.today() + 2;
                capacityElement1.time_slot = '14:00-16:00';
                capacityElement1.work_skill = 'Elec3';
                capacityElement1.quota = 1;
                capacityElement1.available = 1;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement2.location = 'location';
                capacityElement2.date_x = system.today() + 3;
                capacityElement2.time_slot = '14:00-16:00';
                capacityElement2.work_skill = 'WorkSkill';
                capacityElement2.quota = 2;
                capacityElement2.available = 2;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement3 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement3.location = 'location';
                capacityElement3.date_x = system.today() + 4;
                capacityElement3.time_slot = '14:00-16:00';
                capacityElement3.work_skill = null;
                capacityElement3.quota = 250;
                capacityElement3.available = 3;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement4 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement4.location = 'location';
                capacityElement4.date_x = system.today() + 4;
                capacityElement4.time_slot = '14:00-16:00';
                capacityElement4.work_skill = 'WorkSkill';
                capacityElement4.quota = 240;
                capacityElement4.available = 2;

                List < EON_OFSC_GetCapacity_WS.capacity_element > capacities = new List < EON_OFSC_GetCapacity_WS.capacity_element > ();
                capacities.add(capacityElement);
                capacities.add(capacityElement1);
                capacities.add(capacityElement2);
                capacities.add(capacityElement3);
                capacities.add(capacityElement4);

                EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
                getCapacityResp.capacity = capacities;
                getCapacityResp.activity_duration = 1;
                getCapacityResp.activity_travel_time = 1;
                response.put('response_x', getCapacityResp);
            }
        }
        if (methodType == 'DuelFuelWithCapacitiesWithError') {
            //Valid MOP
            if (request instanceof EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element) {
                String[] Msg = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
                eapObj.EffectiveFromDate = '20150423'; //CH04.New
                eapObj.EffectiveToDate = '20160823'; //CH04.New
                eapObj.MarketParticipantId = 'EMEB';
                EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[] {
                    eapObj
                };
                EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
                aepObj.ElecAppointedParty = aEobj;
                EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
                empObj.MPAN = 'mpan123';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint = empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element validMop = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
                validMop.RequestElectricitySupplierAppointmentsResult = respJumbo;
                response.put('response_x', validMop);
            }
            //Valid MAM - Error - Incorrect supplier
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element) {
                String[] Msg1 = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg1;
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj1 = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
                if (DateLessThanToday) {
                    String month = String.valueOf(System.Date.today().month() - 1);
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj1.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj1.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + day;
                } else {
                    String month = String.valueOf(System.Date.today().month());
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj1.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj1.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + String.valueOf(System.Date.today().day() + 20);
                }
                gasAObj1.AbbreviatedName = 'XYZ';
                EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[] {
                    gasAObj1
                };
                EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                aepObj.GasAppointedParty = gasAppobj;
                EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                empObj.MPRN = 'mprn123';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint = empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
            //Get MPAN Data
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element) {
                String[] Msg = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                err.Message = Msg;

                EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
                eCode.Code = 'Code';
                eCode.Dispensation = 'Dispensation';
                eCode.IssueNumber = '007';

                EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
                elecCon.Name = 'Name';
                elecCon.Telephone = '12345678';
                elecCon.PreferredContactMethod = 'PreferredContactMethod';
                elecCon.Email = 'test@email.com';
                elecCon.Fax = '4004';

                EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
                elecApp.EffectiveFromDate = '20150423';
                elecApp.EffectiveToDate = '20160823';
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
                timePatt.RegisterMappingCoefficient = '4';

                EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[] {
                    timePatt
                };
                EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
                arrTimePatt.TimePatternRegime = objTimePatt;

                EON_JUMBO_Work_Management_WS.ElecRegister eReg = new EON_JUMBO_Work_Management_WS.ElecRegister();
                eReg.AssociatedMeterId = '007';
                eReg.AssociatedRegisterId = '007';
                eReg.ChannelNumber = '1';
                eReg.Description = 'Description';
                eReg.Id = '1234';
                eReg.MeasurementQuantityId = '50';
                eReg.MeterMemoryLocation = '200';
                eReg.Multiplier = '3';
                eReg.NumberOfDigits = '2';
                eReg.PulseMultiplier = '3';
                eReg.TimestampMeterMemoryLocation = '5';
                eReg.Type_x = 'Type_x';
                eReg.TimePatternRegimes = arrTimePatt;

                EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[] {
                    eReg
                };
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
                String eMeterTypeValue = String.valueOf(eMeterType1.name);
                eMeter.TimingDeviceSerialNumber = eMeterTypeValue; //'789';
                eMeter.Type_x = 'N';
                eMeter.VTRatio = '7';
                eMeter.Registers = arrEReg;

                EON_JUMBO_Work_Management_WS.ElecMeter[] objEMeter = new EON_JUMBO_Work_Management_WS.ElecMeter[] {
                    eMeter
                };
                EON_JUMBO_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
                arrayEM.ElecMeter = objEMeter;

                EON_JUMBO_Work_Management_WS.DataEffectiveFrom dataEff = new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
                dataEff.Id = '1234';
                dataEff.EffectiveFromDate = '2015-04-23';

                EON_JUMBO_Work_Management_WS.OutstationPasswords oStatPwd = new EON_JUMBO_Work_Management_WS.OutstationPasswords();
                oStatPwd.Level1 = 'Level1';
                oStatPwd.Level2 = 'Level2';
                oStatPwd.Level3 = 'Level3';

                EON_JUMBO_Work_Management_WS.OutstationUsernames oStatUser = new EON_JUMBO_Work_Management_WS.OutstationUsernames();
                oStatUser.Level1 = 'Level1';
                oStatUser.Level2 = 'Level2';
                oStatUser.Level3 = 'Level3';

                EON_JUMBO_Work_Management_WS.CommsBase cBase = new EON_JUMBO_Work_Management_WS.CommsBase();
                cBase.Address = 'Address';
                cBase.BaudRate = '2';
                cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
                cBase.Method = 'Method';
                cBase.Provider = 'Provider';

                EON_JUMBO_Work_Management_WS.CommsBase[] objCBase = new EON_JUMBO_Work_Management_WS.CommsBase[] {
                    cBase
                };
                EON_JUMBO_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
                arrCBase.CommsBase = objCBase;

                EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice outCode = new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
                outCode.Code = '12345';
                outCode.Dispensation = 'Dispensation';

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

                EON_JUMBO_Work_Management_WS.Outstation[] objOutStat = new EON_JUMBO_Work_Management_WS.Outstation[] {
                    outStat
                };
                EON_JUMBO_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
                arrOutStat.Outstation = objOutStat;

                EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
                priorService.AlternateName = 'AlternateName';
                priorService.AlternateTelephone1 = '988445632';
                priorService.AlternateTelephone2 = '123456987';
                priorService.Name = 'Name';
                priorService.Telephone3 = '123456778';
                priorService.Address = elecAdd;
                priorService.Telephone1 = '988445632';
                priorService.Telephone2 = '988445632';
                priorService.Telephone3 = '988445632';

                EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
                elecSup.EnergisationStatus = 'EnergisationStatus';
                elecSup.Phases = '1';
                elecSup.Voltage = '1400';
                elecSup.Capacity = '200';

                EON_JUMBO_Work_Management_WS.ElecCustomer eCust = new EON_JUMBO_Work_Management_WS.ElecCustomer();
                eCust.AdditionalInformation = 'test';
                eCust.ContractReference = 'test';
                eCust.StdSettlementConfig = dataEff;
                eCust.Supply = elecSup;
                eCust.MeterPointAddress = elecAdd;
                eCust.CustomerName = 'CustomerName';
                eCust.CustomerContact = elecCon;
                eCust.SpecialAccess = 'SpecialAccess';
                eCust.CustomerPassword = 'CustomerPassword';
                eCust.MeterPointAddress = elecAdd;
                eCust.PriorityServiceContactInfo = priorService;
                eCust.CodeOfPractice = eCode;
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
                eCust.RemoteDisableEnableCapability = 'test Remote';
                eCust.ServiceLevelReference = 'test ServiceLevel';
                eCust.ServiceLocation = 'test ServiceLocation';
                eCust.ServiceReference = 'test ServiceReference';
                eCust.SpecialAccess = 'test SpecialAccess';

                EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
                resp.Errors = err;
                resp.Success = true;
                resp.Customer = eCust;

                EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();
                obj.RequestElectricityMeterPointDataResult = resp;
                response.put('response_x', obj);
            }
            //Get MPRN Data
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element) {
                String[] Msg = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                err.Message = Msg;
                EON_JUMBO_Work_Management_WS.GasAddress gasAdd = new EON_JUMBO_Work_Management_WS.GasAddress();
                gasAdd.AddressText = 'AddressText';
                gasAdd.Building = 'AddressText';
                gasAdd.DependentLocality = 'AddressText';
                gasAdd.County = 'County';
                gasAdd.DependentThoroughfare = 'DependentThoroughfare';
                gasAdd.DoubleDependentLocality = 'DoubleDependentLocality';
                gasAdd.PostCode = 'PostCode';
                gasAdd.PostTown = 'PostTown';
                gasAdd.PostTown = 'PostTown';
                gasAdd.SubBuilding = 'SubBuilding';
                gasAdd.UPRN = 'UPRN';
                gasAdd.Thoroughfare = 'Thoroughfare';

                EON_JUMBO_Work_Management_WS.GasRegister gRegi = new EON_JUMBO_Work_Management_WS.GasRegister();
                gRegi.MultiplicationFactor = '3';
                gRegi.NumberOfDigits = '2';
                gRegi.UnitsOfMeasure = '5';

                EON_JUMBO_Work_Management_WS.GasRegister[] objGasReg = new EON_JUMBO_Work_Management_WS.GasRegister[] {
                    gRegi
                };
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
                gMet.PaymentMethod = 'PaymentMethod';
                gMet.PulseValue = '789';
                gMet.SerialNumber = '1245';
                gMet.Status = 'Status';
                gMet.Type_x = 'T';
                gMet.Usage = 'Usage';
                gMet.YearOfManufacture = '2015';
                gMet.Registers = arrGReg;

                EON_JUMBO_Work_Management_WS.GasMeter[] objGasMet = new EON_JUMBO_Work_Management_WS.GasMeter[] {
                    gMet
                };
                EON_JUMBO_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter();
                arrGMeter.GasMeter = objGasMet;

                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
                if (DateLessThanToday) {
                    String month = String.valueOf(System.Date.today().month() - 1);
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + day;
                } else {
                    String month = String.valueOf(System.Date.today().month());
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + String.valueOf(System.Date.today().day() + 20);
                }
                gasAObj.AbbreviatedName = 'MORR';

                EON_JUMBO_Work_Management_WS.Converter conver = new EON_JUMBO_Work_Management_WS.Converter();
                conver.SerialNumber = '007';
                conver.Model = 'Model';
                conver.AssetClass = 'AssetClass';
                conver.Manufacturer = 'Manufacturer';
                conver.Location = 'Location';

                EON_JUMBO_Work_Management_WS.Converter[] objConver = new EON_JUMBO_Work_Management_WS.Converter[] {
                    conver
                };
                EON_JUMBO_Work_Management_WS.ArrayOfConverter arrConver = new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
                arrConver.Converter = objConver;

                EON_JUMBO_Work_Management_WS.ContactMechanism contMec = new EON_JUMBO_Work_Management_WS.ContactMechanism();
                contMec.Code = '007';
                contMec.Value = '007';

                EON_JUMBO_Work_Management_WS.ContactMechanism[] objContMec = new EON_JUMBO_Work_Management_WS.ContactMechanism[] {
                    contMec
                };
                EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism arrContMec = new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
                arrContMec.ContactMechanism = objContMec;

                EON_JUMBO_Work_Management_WS.Contact cont = new EON_JUMBO_Work_Management_WS.Contact();
                cont.TypeCode = 'TypeCode';
                cont.Initials = 'Initials';
                cont.Surname = 'Surname';
                cont.Title = 'Title';
                cont.ContactMechanism = arrContMec;

                EON_JUMBO_Work_Management_WS.Contact[] objCont = new EON_JUMBO_Work_Management_WS.Contact[] {
                    cont
                };
                EON_JUMBO_Work_Management_WS.ArrayOfContact arrCont = new EON_JUMBO_Work_Management_WS.ArrayOfContact();
                arrCont.Contact = objCont;

                EON_JUMBO_Work_Management_WS.gasCustomer gCust = new EON_JUMBO_Work_Management_WS.gasCustomer();
                gCust.AccessInstructions = 'AccessInstructions';
                gCust.AccessPassword = 'AccessPassword';
                gCust.ConversionFactor = 'ConversionFactor';
                gCust.LastInspectionDate = 'LastInspectionDate';
                gCust.Location = 'Location';
                gCust.LocationNotes = 'LocationNotes';
                gCust.MPRN = 'MPRN';
                gCust.MeterLink = 'MeterLink';
                gCust.MeterPointStatus = 'MeterPointStatus';
                gCust.MeteringPressure = '1';
                gCust.Address = gasAdd;
                gCust.Meters = arrGMeter;
                gCust.Supplier = gasAObj;
                gCust.Converters = arrConver;
                gCust.Contacts = arrCont;

                EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
                resp.Errors = err;
                resp.Success = true;
                resp.Customer = gCust;
                EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();
                obj.RequestgasMeterPointDataResult = resp;
                response.put('response_x', obj);
            }
            //Get Capacities
            else if (request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element) {
                EON_OFSC_GetCapacity_WS.capacity_element capacityElement = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement.location = 'location';
                capacityElement.date_x = system.today();
                capacityElement.time_slot = '14:00-16:00';
                capacityElement.work_skill = 'GA';
                capacityElement.quota = 2;
                capacityElement.available = 2;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement1 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement1.location = 'location';
                capacityElement1.date_x = system.today() + 2;
                capacityElement1.time_slot = '14:00-16:00';
                capacityElement1.work_skill = 'Elec3';
                capacityElement1.quota = 1;
                capacityElement1.available = 1;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement2.location = 'location';
                capacityElement2.date_x = system.today() + 3;
                capacityElement2.time_slot = '14:00-16:00';
                capacityElement2.work_skill = 'WorkSkill';
                capacityElement2.quota = 2;
                capacityElement2.available = 2;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement3 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement3.location = 'location';
                capacityElement3.date_x = system.today() + 4;
                capacityElement3.time_slot = '14:00-16:00';
                capacityElement3.work_skill = null;
                capacityElement3.quota = 250;
                capacityElement3.available = 3;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement4 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement4.location = 'location';
                capacityElement4.date_x = system.today() + 4;
                capacityElement4.time_slot = '14:00-16:00';
                capacityElement4.work_skill = 'WorkSkill';
                capacityElement4.quota = 240;
                capacityElement4.available = 2;

                List < EON_OFSC_GetCapacity_WS.capacity_element > capacities = new List < EON_OFSC_GetCapacity_WS.capacity_element > ();
                capacities.add(capacityElement);
                capacities.add(capacityElement1);
                capacities.add(capacityElement2);
                capacities.add(capacityElement3);
                capacities.add(capacityElement4);

                EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
                getCapacityResp.capacity = capacities;
                getCapacityResp.activity_duration = 1;
                getCapacityResp.activity_travel_time = 1;
                response.put('response_x', getCapacityResp);
            }
        }
        if (methodType == 'DuelFuelWithCapacitiesWithFuel') {
            //Valid MOP
            if (request instanceof EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointments_element) {
                String[] Msg = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg;
                EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
                eapObj.EffectiveFromDate = '20150423'; //CH04.New
                eapObj.EffectiveToDate = '20160823'; //CH04.New
                eapObj.MarketParticipantId = 'EMEB';
                EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[] {
                    eapObj
                };
                EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
                aepObj.ElecAppointedParty = aEobj;
                EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
                empObj.MPAN = 'mpan123';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint = empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element validMop = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
                validMop.RequestElectricitySupplierAppointmentsResult = respJumbo;
                response.put('response_x', validMop);
            }
            //Valid MAM - Error - 
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointments_element) {
                String[] Msg1 = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
                errObj.Message = Msg1;
                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj1 = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
                if (DateLessThanToday) {
                    String month = String.valueOf(System.Date.today().month() - 1);
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj1.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj1.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + day;
                } else {
                    String month = String.valueOf(System.Date.today().month());
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj1.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj1.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + String.valueOf(System.Date.today().day() + 20);
                }
                gasAObj1.AbbreviatedName = 'SGL';
                EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[] {
                    gasAObj1
                };
                EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
                aepObj.GasAppointedParty = gasAppobj;
                EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
                empObj.MPRN = 'mprn123';
                empObj.SupplierAppointments = aepObj;
                EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
                respJumbo.Success = true;
                respJumbo.MeterPoint = empObj;
                respJumbo.Errors = errObj;
                EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
                obj.RequestGasSupplierAppointmentsResult = respJumbo;
                response.put('response_x', obj);
            }
            //Get MPAN Data
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointData_element) {
                String[] Msg = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                err.Message = Msg;

                EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice eCode = new EON_JUMBO_Work_Management_WS.ElecMeterCodeOfPractice();
                eCode.Code = 'Code';
                eCode.Dispensation = 'Dispensation';
                eCode.IssueNumber = '007';

                EON_JUMBO_Work_Management_WS.ElecContact elecCon = new EON_JUMBO_Work_Management_WS.ElecContact();
                elecCon.Name = 'Name';
                elecCon.Telephone = '12345678';
                elecCon.PreferredContactMethod = 'PreferredContactMethod';
                elecCon.Email = 'test@email.com';
                elecCon.Fax = '4004';

                EON_JUMBO_Work_Management_WS.ElecAppointedParty elecApp = new EON_JUMBO_Work_Management_WS.ElecAppointedParty();
                elecApp.EffectiveFromDate = '20150423';
                elecApp.EffectiveToDate = '20160823';
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
                timePatt.RegisterMappingCoefficient = '4';

                EON_JUMBO_Work_Management_WS.TimePatternRegime[] objTimePatt = new EON_JUMBO_Work_Management_WS.TimePatternRegime[] {
                    timePatt
                };
                EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime arrTimePatt = new EON_JUMBO_Work_Management_WS.ArrayOfTimePatternRegime();
                arrTimePatt.TimePatternRegime = objTimePatt;

                EON_JUMBO_Work_Management_WS.ElecRegister eReg = new EON_JUMBO_Work_Management_WS.ElecRegister();
                eReg.AssociatedMeterId = '007';
                eReg.AssociatedRegisterId = '007';
                eReg.ChannelNumber = '1';
                eReg.Description = 'Description';
                eReg.Id = '1234';
                eReg.MeasurementQuantityId = '50';
                eReg.MeterMemoryLocation = '200';
                eReg.Multiplier = '3';
                eReg.NumberOfDigits = '2';
                eReg.PulseMultiplier = '3';
                eReg.TimestampMeterMemoryLocation = '5';
                eReg.Type_x = 'Type_x';
                eReg.TimePatternRegimes = arrTimePatt;

                EON_JUMBO_Work_Management_WS.ElecRegister[] objEReg = new EON_JUMBO_Work_Management_WS.ElecRegister[] {
                    eReg
                };
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
                String eMeterTypeValue = String.valueOf(eMeterType1.name);
                eMeter.TimingDeviceSerialNumber = eMeterTypeValue; //'789';
                eMeter.Type_x = 'N';
                eMeter.VTRatio = '7';
                eMeter.Registers = arrEReg;

                EON_JUMBO_Work_Management_WS.ElecMeter[] objEMeter = new EON_JUMBO_Work_Management_WS.ElecMeter[] {
                    eMeter
                };
                EON_JUMBO_Work_Management_WS.ArrayOfElecMeter arrayEM = new EON_JUMBO_Work_Management_WS.ArrayOfElecMeter();
                arrayEM.ElecMeter = objEMeter;

                EON_JUMBO_Work_Management_WS.DataEffectiveFrom dataEff = new EON_JUMBO_Work_Management_WS.DataEffectiveFrom();
                dataEff.Id = '1234';
                dataEff.EffectiveFromDate = '2015-04-23';

                EON_JUMBO_Work_Management_WS.OutstationPasswords oStatPwd = new EON_JUMBO_Work_Management_WS.OutstationPasswords();
                oStatPwd.Level1 = 'Level1';
                oStatPwd.Level2 = 'Level2';
                oStatPwd.Level3 = 'Level3';

                EON_JUMBO_Work_Management_WS.OutstationUsernames oStatUser = new EON_JUMBO_Work_Management_WS.OutstationUsernames();
                oStatUser.Level1 = 'Level1';
                oStatUser.Level2 = 'Level2';
                oStatUser.Level3 = 'Level3';

                EON_JUMBO_Work_Management_WS.CommsBase cBase = new EON_JUMBO_Work_Management_WS.CommsBase();
                cBase.Address = 'Address';
                cBase.BaudRate = '2';
                cBase.DialInDialOutIndicator = 'DialInDialOutIndicator';
                cBase.Method = 'Method';
                cBase.Provider = 'Provider';

                EON_JUMBO_Work_Management_WS.CommsBase[] objCBase = new EON_JUMBO_Work_Management_WS.CommsBase[] {
                    cBase
                };
                EON_JUMBO_Work_Management_WS.ArrayOfCommsBase arrCBase = new EON_JUMBO_Work_Management_WS.ArrayOfCommsBase();
                arrCBase.CommsBase = objCBase;

                EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice outCode = new EON_JUMBO_Work_Management_WS.OutstationCodeOfPractice();
                outCode.Code = '12345';
                outCode.Dispensation = 'Dispensation';

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

                EON_JUMBO_Work_Management_WS.Outstation[] objOutStat = new EON_JUMBO_Work_Management_WS.Outstation[] {
                    outStat
                };
                EON_JUMBO_Work_Management_WS.ArrayOfOutstation arrOutStat = new EON_JUMBO_Work_Management_WS.ArrayOfOutstation();
                arrOutStat.Outstation = objOutStat;

                EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo priorService = new EON_JUMBO_Work_Management_WS.PriorityServiceContactInfo();
                priorService.AlternateName = 'AlternateName';
                priorService.AlternateTelephone1 = '988445632';
                priorService.AlternateTelephone2 = '123456987';
                priorService.Name = 'Name';
                priorService.Telephone3 = '123456778';
                priorService.Address = elecAdd;
                priorService.Telephone1 = '988445632';
                priorService.Telephone2 = '988445632';
                priorService.Telephone3 = '988445632';

                EON_JUMBO_Work_Management_WS.ElecSupply elecSup = new EON_JUMBO_Work_Management_WS.ElecSupply();
                elecSup.EnergisationStatus = 'EnergisationStatus';
                elecSup.Phases = '1';
                elecSup.Voltage = '1400';
                elecSup.Capacity = '200';

                EON_JUMBO_Work_Management_WS.ElecCustomer eCust = new EON_JUMBO_Work_Management_WS.ElecCustomer();
                eCust.AdditionalInformation = 'test';
                eCust.ContractReference = 'test';
                eCust.StdSettlementConfig = dataEff;
                eCust.Supply = elecSup;
                eCust.MeterPointAddress = elecAdd;
                eCust.CustomerName = 'CustomerName';
                eCust.CustomerContact = elecCon;
                eCust.SpecialAccess = 'SpecialAccess';
                eCust.CustomerPassword = 'CustomerPassword';
                eCust.MeterPointAddress = elecAdd;
                eCust.PriorityServiceContactInfo = priorService;
                eCust.CodeOfPractice = eCode;
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
                eCust.RemoteDisableEnableCapability = 'test Remote';
                eCust.ServiceLevelReference = 'test ServiceLevel';
                eCust.ServiceLocation = 'test ServiceLocation';
                eCust.ServiceReference = 'test ServiceReference';
                eCust.SpecialAccess = 'test SpecialAccess';

                EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.ElecMeterPointDataResponse();
                resp.Errors = err;
                resp.Success = true;
                resp.Customer = eCust;

                EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricityMeterPointDataResponse_element();
                obj.RequestElectricityMeterPointDataResult = resp;
                response.put('response_x', obj);
            }
            //Get MPRN Data
            else if (request instanceof EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element) {
                String[] Msg = new String[] {
                    'Message1', 'Message2', 'Message3'
                };
                EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
                err.Message = Msg;
                EON_JUMBO_Work_Management_WS.GasAddress gasAdd = new EON_JUMBO_Work_Management_WS.GasAddress();
                gasAdd.AddressText = 'AddressText';
                gasAdd.Building = 'AddressText';
                gasAdd.DependentLocality = 'AddressText';
                gasAdd.County = 'County';
                gasAdd.DependentThoroughfare = 'DependentThoroughfare';
                gasAdd.DoubleDependentLocality = 'DoubleDependentLocality';
                gasAdd.PostCode = 'PostCode';
                gasAdd.PostTown = 'PostTown';
                gasAdd.PostTown = 'PostTown';
                gasAdd.SubBuilding = 'SubBuilding';
                gasAdd.UPRN = 'UPRN';
                gasAdd.Thoroughfare = 'Thoroughfare';

                EON_JUMBO_Work_Management_WS.GasRegister gRegi = new EON_JUMBO_Work_Management_WS.GasRegister();
                gRegi.MultiplicationFactor = '3';
                gRegi.NumberOfDigits = '2';
                gRegi.UnitsOfMeasure = '5';

                EON_JUMBO_Work_Management_WS.GasRegister[] objGasReg = new EON_JUMBO_Work_Management_WS.GasRegister[] {
                    gRegi
                };
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
                gMet.PaymentMethod = 'PaymentMethod';
                gMet.PulseValue = '789';
                gMet.SerialNumber = '1245';
                gMet.Status = 'Status';
                gMet.Type_x = 'T';
                gMet.Usage = 'Usage';
                gMet.YearOfManufacture = '2015';
                gMet.Registers = arrGReg;

                EON_JUMBO_Work_Management_WS.GasMeter[] objGasMet = new EON_JUMBO_Work_Management_WS.GasMeter[] {
                    gMet
                };
                EON_JUMBO_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter();
                arrGMeter.GasMeter = objGasMet;

                EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty();
                if (DateLessThanToday) {
                    String month = String.valueOf(System.Date.today().month() - 1);
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + day;
                } else {
                    String month = String.valueOf(System.Date.today().month());
                    if (month.length() != 2)
                        month = '0' + month;
                    String day = String.valueOf(System.Date.today().day());
                    if (day.length() != 2)
                        day = '0' + day;
                    gasAObj.EffectiveFromDate = String.valueOf(System.Date.today().year()) + month + day;
                    gasAObj.EffectiveToDate = String.valueOf(System.Date.today().year()) + month + String.valueOf(System.Date.today().day() + 20);
                }
                gasAObj.AbbreviatedName = 'MORR';

                EON_JUMBO_Work_Management_WS.Converter conver = new EON_JUMBO_Work_Management_WS.Converter();
                conver.SerialNumber = '007';
                conver.Model = 'Model';
                conver.AssetClass = 'AssetClass';
                conver.Manufacturer = 'Manufacturer';
                conver.Location = 'Location';

                EON_JUMBO_Work_Management_WS.Converter[] objConver = new EON_JUMBO_Work_Management_WS.Converter[] {
                    conver
                };
                EON_JUMBO_Work_Management_WS.ArrayOfConverter arrConver = new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
                arrConver.Converter = objConver;

                EON_JUMBO_Work_Management_WS.ContactMechanism contMec = new EON_JUMBO_Work_Management_WS.ContactMechanism();
                contMec.Code = '007';
                contMec.Value = '007';

                EON_JUMBO_Work_Management_WS.ContactMechanism[] objContMec = new EON_JUMBO_Work_Management_WS.ContactMechanism[] {
                    contMec
                };
                EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism arrContMec = new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
                arrContMec.ContactMechanism = objContMec;

                EON_JUMBO_Work_Management_WS.Contact cont = new EON_JUMBO_Work_Management_WS.Contact();
                cont.TypeCode = 'TypeCode';
                cont.Initials = 'Initials';
                cont.Surname = 'Surname';
                cont.Title = 'Title';
                cont.ContactMechanism = arrContMec;

                EON_JUMBO_Work_Management_WS.Contact[] objCont = new EON_JUMBO_Work_Management_WS.Contact[] {
                    cont
                };
                EON_JUMBO_Work_Management_WS.ArrayOfContact arrCont = new EON_JUMBO_Work_Management_WS.ArrayOfContact();
                arrCont.Contact = objCont;

                EON_JUMBO_Work_Management_WS.gasCustomer gCust = new EON_JUMBO_Work_Management_WS.gasCustomer();
                gCust.AccessInstructions = 'AccessInstructions';
                gCust.AccessPassword = 'AccessPassword';
                gCust.ConversionFactor = 'ConversionFactor';
                gCust.LastInspectionDate = 'LastInspectionDate';
                gCust.Location = 'Location';
                gCust.LocationNotes = 'LocationNotes';
                gCust.MPRN = 'MPRN';
                gCust.MeterLink = 'MeterLink';
                gCust.MeterPointStatus = 'MeterPointStatus';
                gCust.MeteringPressure = '1';
                gCust.Address = gasAdd;
                gCust.Meters = arrGMeter;
                gCust.Supplier = gasAObj;
                gCust.Converters = arrConver;
                gCust.Contacts = arrCont;

                EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
                resp.Errors = err;
                resp.Success = true;
                resp.Customer = gCust;
                EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();
                obj.RequestgasMeterPointDataResult = resp;
                response.put('response_x', obj);
            }
            //Get Capacities
            else if (request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element) {
                EON_OFSC_GetCapacity_WS.capacity_element capacityElement = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement.location = 'location';
                capacityElement.date_x = system.today();
                capacityElement.time_slot = '14:00-16:00';
                capacityElement.work_skill = 'GA';
                capacityElement.quota = 2;
                capacityElement.available = 2;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement1 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement1.location = 'location';
                capacityElement1.date_x = system.today() + 2;
                capacityElement1.time_slot = '14:00-16:00';
                capacityElement1.work_skill = 'Elec3';
                capacityElement1.quota = 1;
                capacityElement1.available = 1;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement2.location = 'location';
                capacityElement2.date_x = system.today() + 3;
                capacityElement2.time_slot = '14:00-16:00';
                capacityElement2.work_skill = 'WorkSkill';
                capacityElement2.quota = 2;
                capacityElement2.available = 2;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement3 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement3.location = 'location';
                capacityElement3.date_x = system.today() + 4;
                capacityElement3.time_slot = '14:00-16:00';
                capacityElement3.work_skill = null;
                capacityElement3.quota = 250;
                capacityElement3.available = 3;

                EON_OFSC_GetCapacity_WS.capacity_element capacityElement4 = new EON_OFSC_GetCapacity_WS.capacity_element();
                capacityElement4.location = 'location';
                capacityElement4.date_x = system.today() + 4;
                capacityElement4.time_slot = '14:00-16:00';
                capacityElement4.work_skill = 'WorkSkill';
                capacityElement4.quota = 240;
                capacityElement4.available = 2;

                List < EON_OFSC_GetCapacity_WS.capacity_element > capacities = new List < EON_OFSC_GetCapacity_WS.capacity_element > ();
                capacities.add(capacityElement);
                capacities.add(capacityElement1);
                capacities.add(capacityElement2);
                capacities.add(capacityElement3);
                capacities.add(capacityElement4);

                EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
                getCapacityResp.capacity = capacities;
                getCapacityResp.activity_duration = 1;
                getCapacityResp.activity_travel_time = 1;
                 
     /**
        getCapacityFromOFSC_PASS(): Positive test for method getCapacityFromOFSC();
    **/ 
      //Test.startTest(); 
             
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe',Duration__c = 123 , Job_Type__c = 'ECO');
        insert job;
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        insert eCust;
        EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPRN__c = '123';
        eFuel.MPAN__c = '121'; 
        eFuel.Premise__c = eSite.id;       
        insert eFuel;   
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1',Duration__c = 123, Value__c = 'CR');
        insert ejobAtt;
        
       
        EON_Electric_Meter_Type__c objEleMetType = new EON_Electric_Meter_Type__c(Name='KEY');
        insert objEleMetType;
        
        EON_Gas_Meter_Type__c objGasMetType = new EON_Gas_Meter_Type__c(Name='MCL');
        insert objGasMetType;
        
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
        
        
        EON_Appointment__c appt = new EON_Appointment__c(Planned_E_Meter_Type__c = 'KEY', Planned_G_Meter_Type__c = 'MCL', MPAN__c = '121',MPRN__c = '123',Booking_System_Name__c = 'Test',Key_Collection_Required__c = true ,EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH05.old // Requested_SSC__c=ssc.id,//CH06.old
        Appointment_Date__c = Date.Today()-1, End_Time__c = '12:32',  E_Meter_Type__c = objEleMetType.Id /*CH03 'KEY'*/, G_Meter_Type__c= objGasMetType.Id /*CH03 'MCL'*/,Number_of_Phases__c = '3Ph',Metering_Pressure__c = 'Low',Fuel_ID__c=eFuel.id);/*CH08*/
        insert appt;

        EON_Capacity_Categories__c capacityCatg = new EON_Capacity_Categories__c(Name = 'KEYMCL3PHLow',Elec_Phase__c = '3PH', Gas_pressure__c = 'Low',  Work_Skill__c = 'Workskill');
        insert capacityCatg;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
          EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail ofscCapacity= EON_Get_Capacity_From_Isis_WS.getCapacity(null);
        
         List<EON_Get_Capacity_From_Isis_WS.Capacity> lstCap = new List<EON_Get_Capacity_From_Isis_WS.Capacity>();
         
         Map<Date,List<EON_OFSC_Helper.RecomendedTimeSlots>> Capacity= new Map<Date,List<EON_OFSC_Helper.RecomendedTimeSlots>>();
         
         EON_Get_Capacity_From_Isis_WS.Capacity cap = new EON_Get_Capacity_From_Isis_WS.Capacity ();
         cap.CapacityDate=system.today();
         cap.TimeSlot='AM';
         cap.AvailableQuota= 2;
         cap.EndTime='AM';
         cap.Quota=2;
         cap.StartTime='Test time';
         lstCap.add(Cap);
         EON_Get_Capacity_From_Isis_WS.Capacities objCaps = new EON_Get_Capacity_From_Isis_WS.Capacities();
            objCaps.Capacity=lstCap;
                
          EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail objCapDeatils = new EON_Get_Capacity_From_Isis_WS.CapacityResponseDetail();
            objCapDeatils.Capacities=objCaps;
          EON_Get_Capacity_From_Isis_WS.getXML(objCapDeatils);
          
          EON_Get_Capacity_From_Isis_WS.Capacities caps =  new EON_Get_Capacity_From_Isis_WS.Capacities();
          
               
        
       //Test.stopTest();  
   {   
     // This causes a fake response to be generated
    
     Test.setMock(WebServiceMock.class, new EON_OFSC_GetCapacity_WS_ServicesMock());   
     EON_OFSC_GetCapacity_WS.toa_capacity_interface taCap = new EON_OFSC_GetCapacity_WS.toa_capacity_interface();
     taCap.endpoint_x = 'https://api.etadirect.com/soap/';
     taCap.inputHttpHeaders_x =null;
     taCap.outputHttpHeaders_x = null;
     taCap.clientCertName_x = 'TestEon';
     taCap.clientCert_x ='Test_';
     taCap.clientCertPasswd_x = 'Test@123';
     taCap.timeout_x = 12000;
     EON_OFSC_GetCapacity_WS.user_element  eonUsr = new EON_OFSC_GetCapacity_WS.user_element();
     eonUsr.now = string.ValueOf(System.now());
     eonUsr.login = 'EON@morrisonus.com';
     eonUsr.company = 'MUS';
     eonUsr.auth_string = 'MUS USER AUTHENTICATED';
       
     List<EON_OFSC_GetCapacity_WS.set_quota_bucket_element> lstbucket = new List<EON_OFSC_GetCapacity_WS.set_quota_bucket_element>(); 
     taCap.set_quota(eonUsr,lstbucket );
  
   }
      
       
            }
        }
    }
}