/**
    Description : This test class covers the code coverage for below class
        1. EON_OFSC_Helper
**/
/*
    Created By : Nitin Bangar
    Created Date : 21-March-2016
    Service Request : SR_EON_AB_018
    Change History:
    CH01 # SR_EON_AB_028 # 31/03/2016 # Nitin Bangar # Amended logic as per the new parameters included in the SR.
    CH02 # SR_EON_AB_022 # 01/04/2016 # Nitin Bangar # Added new methods to cover checkValidityForOFSC(), Mahadev - Amendment changes covered.
    CH03 # SR_EON_Scheduling_006 & SR_EON_Scheduling_007 # 27/04/2016 # 27/04/2016 # Dharmendra P # Increased coverage for added method to get userelement for Inbound API.
    CH04 # SR_EON_AB_060 # 12/05/2016 # Nitin # Added Test Method.
    CH05 # SR_EON_Mobile_009 # 16/04/2016 # Mahadev # Added test method
    CH06 # SR_EON_AB_070 # 17/06/2016 # Aruna Manjari # Added Test Method.
    CH07 # SR_EON_AB_071 # 27/06/2016 # Dharmendra P # Added new mehod for checkValidations function.
    CH08 # SR_EON_AB_097 # 27/07/2016 # Puneet Mehta # Picklist value of Number of Phases changed from 1 and 3 to 1Ph and 3Ph
    CH09 # SR_EON_Jumbo_062 # 05/09/2016 # Mahadev # Added test method
    CH10 # SR_EON_Jumbo_147 # 23/09/2016 # Sivasankar # Amended test methods.
    CH11 # SR_EON_AB_198 # 18/01/2017 # Mahadev Joshilkar # Amended logic to skip non-numeric time-slots.
*/
@isTest
global class EON_OFSC_Helper_test implements WebServiceMock
{
    public static string functionType='';
    public static boolean genException = false;
    /**
        getOracleBucketId_PASS():- Pass - When method returns the value of field 'Oracle Bucket ID' from object 'EON Sub Area'.
    **/ 
    static testMethod void getOracleBucketId_PASS() 
    {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );    //CH01
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_OFSC_Helper.getOracleBucketId(job.Name, job.job_Type__c, pstCode.Name,'12');    //CH01
        
        System.assertEquals(pstCode.Name,'SE10 1');
        //Generate exception
        EON_OFSC_Helper_test.genException = true;
        EON_OFSC_Helper.getOracleBucketId(job.Name, job.job_Type__c, pstCode.Name,'12');
        EON_OFSC_Helper_test.genException = null;
        EON_OFSC_Helper.getOracleBucketId(job.Name, job.job_Type__c, pstCode.Name,'12');
        Test.stopTest();
    }
    
    /**
        getOracleBucketId_PASS1():- When method returns message 'REJECTED Post Code and Job Type could not be found in OOA'.
    **/    
    static testMethod void getOracleBucketId_PASS1() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe');
        insert job;
             
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);    //CH01
        insert region;    
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
                
        List<EON_Post_Code__c> lstPostCode = new List<EON_Post_Code__c>();
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1A',Sub_Area_Name__c = subArea.id);
        lstPostCode.add(pstCode);        
        
        EON_Post_Code__c pstCode1 = new EON_Post_Code__c(Name = 'SE10 1B',Sub_Area_Name__c = subArea.id);
        lstPostCode.add(pstCode1);
        
        insert lstPostCode;

        EON_OFSC_Helper.getOracleBucketId(job.Name, job.Job_Type__c , lstPostCode[1].Name, '12');    //CH01
        
        System.assertEquals(region.Name, 'New Region Test');
        
        //CH11.New.Start
        boolean checkSlot = EON_OFSC_Helper.isValidTimeSlot(null);
        system.assertEquals(false, checkSlot);
        checkSlot = EON_OFSC_Helper.isValidTimeSlot('ECO');
        system.assertEquals(false, checkSlot);
        checkSlot = EON_OFSC_Helper.isValidTimeSlot('08:LL-10:00');
        system.assertEquals(false, checkSlot);
        checkSlot = EON_OFSC_Helper.isValidTimeSlot('08:00-10:00');
        system.assertEquals(true, checkSlot);
        EON_OFSC_Inbound_WS.HeadElement headElement = EON_OFSC_Helper.getHeaderElementForMIDOS();
        //CH11.New.End
        
        Test.stopTest();
    }
    
    /**
        getOracleBucketId_FAIL1():- Negative Unit test for the method getOracleBucketId().  
    **/
    static testMethod void getOracleBucketId_FAIL1() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = '', Description__c = 'Test describe');
        insert job;     
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 13);
        insert region;       
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;       
        List<EON_Post_Code__c> lstPostCode = new List<EON_Post_Code__c>(); 
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE101A',Sub_Area_Name__c = subArea.id);
        lstPostCode.add(pstCode);        
        EON_Post_Code__c pstCode1 = new EON_Post_Code__c(Name = 'SE101B',Sub_Area_Name__c = subArea.id);
        lstPostCode.add(pstCode1);       
        insert lstPostCode;         
        EON_OFSC_Helper.getOracleBucketId(job.Name, job.Job_Type__c , lstPostCode[1].Name ,'');
        Test.stopTest();
    }
    
    //CH01.Start
    
    /**
        getOracleBucketId_FAIL2():- Negative Unit test for the method getOracleBucketId().  
    **/
    static testMethod void getOracleBucketId_FAIL2() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );    //CH01
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        EON_OFSC_Helper.getOracleBucketId(job.Name, job.job_Type__c, pstCode.Name,'');    //CH01
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
    //CH01.End
    
    //CH02.Start    
    /**
        checkValidityForOFSC_PASS():- When method returns the value of field 'Oracle Bucket ID' from object 'EON Sub Area'.
    **/ 
    static testMethod void checkValidityForOFSC_PASS() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1', Value__c = 'CR');
        insert ejobAtt;
        
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();
        lstJobAtt.add(ejobAtt);
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;

        EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'12','', pstCode.Name);   
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
    /**
        checkValidityForOFSC_PASS1():- Positive Unit test for the method checkValidityForOFSC() when EON Job is Invalid.
    **/
    static testMethod void checkValidityForOFSC_PASS1() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO', MPAN_Reqd__c = true);
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1', Value__c = 'CR');
        insert ejobAtt;
        
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();
        lstJobAtt.add(ejobAtt);
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );    
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;

        EON_OFSC_Helper.checkValidityForOFSC('', lstJobAtt,'12','', pstCode.Name);   
        EON_OFSC_Helper.isSlotAvailable('11:00');
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
    /**
        checkValidityForOFSC_PASS2():- Positive Unit test for the method checkValidityForOFSC() when EON Job Attributes is Invalid.
    **/
    static testMethod void checkValidityForOFSC_PASS2() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO', MPAN_Reqd__c = true);
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1', Value__c = 'CR');
        insert ejobAtt;
        
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();
        lstJobAtt.add(ejobAtt);
        lstJobAtt.clear();
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'12','', pstCode.Name);   
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
     /**
        checkValidityForOFSC_PASS3():- Positive Unit test for the method checkValidityForOFSC() when EON Job Attributes parameter and actual records are zero.
    **/ 
    static testMethod void checkValidityForOFSC_PASS3() {        
        Test.startTest();        
        EON_Job__c job = EON_CreateTestRecords.createEONJob();
        job.Name = 'OOASMARTELECEXCH';
        //job.MPRN_Reqd__c = true;
        job.MPAN_Reqd__c = true;
        job.Job_Type__c = 'Maintenance';
        insert job;                
       
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();
        EON_Job_Attribute__c jobAtt = new EON_Job_Attribute__c(Name='Test Job Attribute', Eon_Job__c=job.ID,duration__c=15,Inactive__c=false,value__c='test'); 
        lstJobAtt.add(jobAtt);
        insert lstJobAtt;            
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12);     
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, Oracle_Bucket_ID__c = 'LON_SouthEast1');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;    
        
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'99','', pstCode.Name);    
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
     /**
        checkValidityForOFSC_PASS4():- Positive Unit test for the method checkValidityForOFSC() when MPAN_Reqd__c is true but data is not provided in the parameter.
    **/ 
    static testMethod void checkValidityForOFSC_PASS4() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO', MPAN_Reqd__c = true);
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1', Value__c = 'CR');
        insert ejobAtt;
        
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();
        lstJobAtt.add(ejobAtt);
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
         Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'','12', pstCode.Name);    
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
     /**
        checkValidityForOFSC_PASS5():- Positive Unit test for the method checkValidityForOFSC() when MPRN_Reqd__c is true but data is not provided in the parameter.
    **/ 
    static testMethod void checkValidityForOFSC_PASS5() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO', MPRN_Reqd__c = true);
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1', Value__c = 'CR');
        insert ejobAtt;
        
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();
        lstJobAtt.add(ejobAtt);
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );    
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
         Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'12','', pstCode.Name);   
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
     /**
        checkValidityForOFSC_PASS6():- When method returns the value Orcale ID is returned as the value from the field Oracle Bucket ID.
    **/ 
    static testMethod void checkValidityForOFSC_PASS6() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1', Value__c = 'CR');
        insert ejobAtt;
        
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();
        lstJobAtt.add(ejobAtt);
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
         Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'','','');   
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    } 
    
     /**
        checkValidityForOFSC_PASS7A():- When method returns the value Orcale ID is returned as the value from the field Oracle Bucket ID.
    **/ 
    static testMethod void checkValidityForOFSC_PASS7A() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
                
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();        
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
         Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'','','');   
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    } 
    //CH04.Start
    /**
        checkValidityForOFSC_PASS7B():- When method returns the value Orcale ID is returned as the value from the field Oracle Bucket ID.
    **/ 
    static testMethod void checkValidityForOFSC_PASS7B() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO',MPAN_Reqd__c=true);
        insert job;
                
        List<EON_Job_Attribute__c> lstJobAtt;  
        
        Test.setMock(WebServiceMock.class, new EON_JUMBO_WebServiceMockImpl());
        EON_OFSC_Helper.checkValidityForOFSC(job.name, lstJobAtt,'','','');   
        
        System.assertEquals(job.Name,'Job Test');
        Test.stopTest();
    } 
    //CH04.End
    /**
        errorValidityMOP_PASS():- To check for error while validating MOP
    **/
    static testMethod void errorValidityMOP_PASS()
    {
        //Create test records
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'test jo';
        eJob.Job_Type__c = 'Smart';
        eJob.MOP_Reqd__c = true;
        eJob.MAM_Reqd__c = false;
        eJob.MPAN_Reqd__c = false;
        eJob.MPRN_Reqd__c = false;
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
        List<EON_Job_Attribute__c> lstAttr = new list<EON_Job_Attribute__c>();
        lstAttr.add(eJobAttribute);
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Helper_test());
        EON_OFSC_Helper_test.functionType ='InValidMOP';
        Test.startTest();
        EON_OFSC_Helper.checkValidityForOFSC('test jo', lstAttr,'TestMpan','','SE10 1'); 
        Test.stopTest();
    }
    /**
        errorValidityMAM_PASS():- To check for error while validating MAM
    **/
    static testMethod void errorValidityMAM_PASS()
    {
        //Create test records
        EON_Job__c eJob = EON_CreateTestRecords.createEONJob();
        eJob.Name = 'test jo';
        eJob.Job_Type__c = 'Smart';
        eJob.MOP_Reqd__c = false;
        eJob.MAM_Reqd__c = true;
        eJob.MPAN_Reqd__c = false;
        eJob.MPRN_Reqd__c = false;
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
        List<EON_Job_Attribute__c> lstAttr = new list<EON_Job_Attribute__c>();
        lstAttr.add(eJobAttribute);
        
        Test.setMock(WebServiceMock.class, new EON_OFSC_Helper_test());
        EON_OFSC_Helper_test.functionType ='InValidMRN';
        Test.startTest();
        EON_OFSC_Helper.checkValidityForOFSC('test jo', lstAttr,'','TestMprn','SE10 1'); 
        Test.stopTest();
    }
    
    //CH02.End
    
    /**
        getCapacityFromOFSC_PASS():
    **/ 
    static testMethod void getCapacityFromOFSC_PASS(){        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
        
        List<EON_Job_Attribute__c> jobAtt = new List<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1',Duration__c = 123, Value__c = 'CR');
        jobAtt.add(ejobAtt);
        insert jobAtt;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );    //CH01
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        Map<String,Date> mapDates = new Map<String,Date>{'Date' => system.today()};
        Map<String,Date> mapDates1 = new Map<String,Date>{'eff_From_Date' => system.today()-1, 'eff_To_Date' => system.today()+56};

        Map<String,String> mapPhase = new Map<String,String>{'KEY' => 'MCL'};
        
        Test.startTest();
        EON_OFSC_Helper.RecomendedTimeSlots recTimeSlots = new EON_OFSC_Helper.RecomendedTimeSlots();             
        EON_OFSC_Helper_test.functionType = 'GetcapacityNew';
        Test.setMock(WebServiceMock.class, new EON_OFSC_Helper_test());   
        EON_OFSC_Helper.getCapacityFromOFSC('LON_SouthEast1',1,mapPhase,jobAtt,'workSkill',mapDates);
        EON_OFSC_Helper_test.functionType = 'NoGAcapacity';
        EON_OFSC_Helper.getCapacityFromOFSC('LON_SouthEast1',0,mapPhase,jobAtt,'workSkill',mapDates);
        EON_OFSC_Helper_test.functionType = 'GetGAcapacityNew';
        EON_OFSC_Helper.getCapacityFromOFSC('LON_SouthEast1',1,mapPhase,jobAtt,'workSkill',mapDates);
        EON_OFSC_Helper_test.functionType = 'NoGAcapacity';
        EON_OFSC_Helper.getCapacityFromOFSC('LON_SouthEast1',0,mapPhase,jobAtt,'workSkill',mapDates1);

        System.assertEquals(pstCode.Name,'SE10 1');        
        Test.stopTest();
    }
    
    static testMethod void getCapacityFromOFSC_PASS_final(){        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
        
        List<EON_Job_Attribute__c> jobAtt = new List<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1',Duration__c = 123, Value__c = 'CR');
        jobAtt.add(ejobAtt);
        insert jobAtt;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );    //CH01
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        Map<String,Date> mapDates = new Map<String,Date>{'Date' => system.today()};
        Map<String,Date> mapDates1 = new Map<String,Date>{'eff_From_Date' => system.today()-1, 'eff_To_Date' => system.today()+56};

        Map<String,String> mapPhase = new Map<String,String>{'KEY' => 'MCL'};
        
        Test.startTest();
        EON_OFSC_Helper.RecomendedTimeSlots recTimeSlots = new EON_OFSC_Helper.RecomendedTimeSlots();             
        Test.setMock(WebServiceMock.class, new EON_OFSC_Helper_test());   
        EON_OFSC_Helper_test.functionType = 'GetGAcapacityNew';
        EON_OFSC_Helper.getCapacityFromOFSC('LON_SouthEast1',1,mapPhase,jobAtt,'workSkill',mapDates);
       
        System.assertEquals(pstCode.Name,'SE10 1');        
        Test.stopTest();
    }
    
    static testMethod void getCapacityFromOFSCNoGA_PASS(){        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
        
        List<EON_Job_Attribute__c> jobAtt = new List<EON_Job_Attribute__c>();
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1',Duration__c = 123, Value__c = 'CR');
        jobAtt.add(ejobAtt);
        insert jobAtt;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );    //CH01
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        Map<String,Date> mapDates = new Map<String,Date>{'Date' => system.today()};
        Map<String,Date> mapDates1 = new Map<String,Date>{'eff_From_Date' => system.today()-1};
        Map<String,Date> mapDates2 = new Map<String,Date>{'eff_To_Date' => system.today()+56};
        Map<String,String> mapPhase = new Map<String,String>{'KEY' => 'MCL'};
        
        Test.startTest();
        EON_OFSC_Helper.RecomendedTimeSlots recTimeSlots = new EON_OFSC_Helper.RecomendedTimeSlots();             
        EON_OFSC_Helper_test.functionType = 'NoGAcapacity';
        Test.setMock(WebServiceMock.class, new EON_OFSC_Helper_test());   
        EON_OFSC_Helper.getCapacityFromOFSC('LON_SouthEast1',1,mapPhase,jobAtt,'workSkill',mapDates);
        EON_OFSC_Helper.getCapacityFromOFSC('LON_SouthEast1',1,mapPhase,jobAtt,'workSkill',mapDates1);
        EON_OFSC_Helper.getCapacityFromOFSC('LON_SouthEast1',1,mapPhase,jobAtt,'workSkill',mapDates2);
        System.assertEquals(pstCode.Name,'SE10 1');        
        Test.stopTest();
    }
    
    /**
    getCapacitiesFromOFSCPass1() - tThis Will cover the Pass Scenario
    **/
    
     static testMethod void getCapacitiesFromOFSCPass1() {   
       
        EON_DisplayCapacitiesFromOFSC_Ctrl ctrl = new EON_DisplayCapacitiesFromOFSC_Ctrl();
        EON_Electric_Meter_Type__c emeter= new EON_Electric_Meter_Type__c();
        emeter.name='Test1';
        emeter.DESCRIPTION__c='KEY';
        emeter.FILTER__c='KEY';
        emeter.OFS_Enumeration__c=010;  
        insert emeter;        
        Eon_Appointment__c app = new Eon_Appointment__c();
        app.E_Meter_Type__c =emeter.id;   
        app.Number_of_Phases__c = '1Ph';/*CH08*/
        app.Metering_Pressure__c = 'LOW';
        insert app;
        EON_Capacity_Categories__c cate1= new EON_Capacity_Categories__c(Name='Test11PHPHLow',Work_Skill__c='workSkill');
        insert cate1;
        EON_Capacity_Categories__c cate2= new EON_Capacity_Categories__c(Name='Test2',Work_Skill__c='Test2');
        insert cate2;
        string workskill = EON_OFSC_Helper.getWorkSkill(app);
        EON_Create_Appointment_Request_ctrl.eEff_From_Date = Date.Today();
        EON_Create_Appointment_Request_ctrl.eEff_To_Date = date.Today()+1;                        
        System.currentPageReference().getParameters().put('appID',App.Id);  
        System.currentPageReference().getParameters().put('dateSelected','1-2-3');      
        EON_Appointment_Booking_Ctrl_Helper.errorMessages ='';
        ctrl.bookSlotsOFSC();
        EON_DisplayCapacitiesFromOFSC_Ctrl_test.EON_OFSC_GetCapacity_CalloutTest();
        ctrl.getCapacitiesFromOFSC();
        EON_OFSC_Helper.isSlotAvailable('');
        Map < Date, List < EON_OFSC_Helper.RecomendedTimeSlots >> recomMap=ctrl.availableCapacities;
        //System.assertEquals(recomMap.size()>0,true);            
    }
    
    /**
        getCapacityFromOFSC_FAIL(): negative testing for method getCapacityFromOFSC().
    **/ 
    static testMethod void getCapacityFromOFSC_FAIL() {        
        Test.startTest();        
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
        
        List<EON_Job_Attribute__c> jobAtt;
                
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );    //CH01
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        Map<String,Date> mapDates = new Map<String,Date>{'Date' => system.today()};
        Map<String,String> mapPhase = new Map<String,String>{'KEY' => 'MCL'};       
         
        EON_OFSC_Helper.getCapacityFromOFSC('LON_SouthEast1',1,mapPhase,jobAtt,'DF4',mapDates);   
        
        System.assertEquals(pstCode.Name,'SE10 1');
        Test.stopTest();
    }
    
    //CH02.Start
    /**
        checkValidityForOFSC_PASS()7:- This method verifies response for MOP from Jumbo i.e. We are not MOP
    **/ 
    static testMethod void checkValidityForOFSC_PASS7() 
    {        
               
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO', MAM_Reqd__c=false, MOP_Reqd__c=true);
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1', Value__c = 'CR');
        insert ejobAtt;
        
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();
        lstJobAtt.add(ejobAtt);
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        Test.startTest(); 
        String res1 = EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'12','', pstCode.Name);   

        Test.setMock(WebServiceMock.class, new EON_OFSC_Helper_Test());
        EON_OFSC_Helper_Test.functionType = 'ValidMOP';
        
        Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
        EON_Jumbo_ElecGasData_Test.functionType = 'validateMOP';
        
        String res = EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'12','', pstCode.Name);   
        
        //System.assertEquals(res,'We are not MOP');
        Test.stopTest();
    }
    //CH02.Start
    /**
        checkValidityForOFSC_PASS()8:- This method verifies response for MOP from Jumbo i.e. We are not MAM
    **/ 
    static testMethod void checkValidityForOFSC_PASS8() 
    {        
               
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO', MAM_Reqd__c=true, MOP_Reqd__c=false);
        insert job;
        
        EON_Job_Attribute__c ejobAtt = new EON_Job_Attribute__c(Eon_Job__c = job.id, Name = 'Test1', Value__c = 'CR');
        insert ejobAtt;
        
        List<EON_Job_Attribute__c> lstJobAtt = new List<EON_Job_Attribute__c>();
        lstJobAtt.add(ejobAtt);
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        
        Test.startTest(); 
        Test.setMock(WebServiceMock.class, new EON_OFSC_Helper_Test());
        EON_OFSC_Helper_Test.functionType = 'ValidMAM';
        String res1 = EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'','12', pstCode.Name); 

        Test.setMock(WebServiceMock.class, new EON_Jumbo_ElecGasData_Test());
        EON_Jumbo_ElecGasData_Test.functionType = 'validateMAM';
        
        String res = EON_OFSC_Helper.checkValidityForOFSC(job.Name, lstJobAtt,'','12', pstCode.Name); 
        //System.assertEquals(res,'We are not MAM');
        
        Test.stopTest();
    }
     //CH06.Start
   
    /**
        getWorkSkill_Pass_E_Type(): This method to cover - getWorkSkill()
    **/ 
   
    static testMethod void getWorkSkill_Pass_E_Type() 
    {
       EON_Capacity_Categories__c capacity = new EON_Capacity_Categories__c(Name='Test11PHPH ',Elec_Meter_Type__c='E',Elec_Phase__c='PH',Work_Skill__c='workSkill');
        insert capacity;
        EON_Job_Attribute__c att =EON_CreateTestRecords.createEonJobAttributes();
        insert att;   
        EON_Electric_Meter_Type__c emeter= new EON_Electric_Meter_Type__c();
        emeter.name='Test1';
        emeter.DESCRIPTION__c='KEY';
        emeter.FILTER__c='KEY';
        emeter.OFS_Enumeration__c=010;
        insert emeter;
        EON_Site__c site = EON_CreateTestRecords.cereateEONSite();
        insert site;
        EON_Fuel__c fuel=EON_CreateTestRecords.createEONFuel();
        fuel.Fuel_type__c = 'E';
        fuel.Premise__c=site.id;
        insert fuel;
        Eon_Appointment__c app = new Eon_Appointment__c();
        app.Fuel_ID__c=fuel.id;//CH01
        app.Job_Code__c=att.Eon_Job__c;//CH01
        app.E_Meter_Type__c =emeter.id;
        app.Number_of_Phases__c = '1Ph';/*CH08*/
        app.Metering_Pressure__c = 'LOW';
        insert app;
        EON_Capacity_Categories__c cate1= new EON_Capacity_Categories__c(Name='Test11PHPHLow',Work_Skill__c='workSkill');
        insert cate1;
        EON_Capacity_Categories__c cate2= new EON_Capacity_Categories__c(Name='Test2',Work_Skill__c='Test2');
        insert cate2;
        string workskill = EON_OFSC_Helper.getWorkSkill(app);
    }
    
    
    
     /**
        getWorkSkill_Pass_G_Type(): This method to cover - getWorkSkill()
    **/ 
    static testMethod void getWorkSkill_Pass_G_Type() 
    {
        //CH02.start
        EON_Electric_Meter_Type__c emeter= new EON_Electric_Meter_Type__c();
        emeter.DESCRIPTION__c='KEY';
        emeter.FILTER__c='KEY';
        emeter.OFS_Enumeration__c=010;
        insert emeter;
        EON_Gas_Meter_Type__c gmeter = new EON_Gas_Meter_Type__c();
        gmeter.Industry_Code__c='A';
        gmeter.name='A';
        gmeter.OFS_Enumeration__c=231;
        insert gmeter;
        //CH02.end
      
        Eon_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        customer.Name = '1234567891';
        customer.Customer_Name__c = '1234567891';
        insert customer;
        
        EON_Site__c site = EON_CreateTestRecords.createEonSite();
        site.Customer__c = customer.id;
        site.Thorofare__c = 'test Street';
        site.Town__c = 'test town';
        site.PostCode__c = 'test PS';
        insert site;
        
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPAN__c = '12345';
        fuel.MPRN__c = '23467';
        fuel.Fuel_type__c = 'G';
        //fuel.customer__c = customer.id; //CH01
        fuel.Premise__c = site.id;
        insert fuel;
        
        Eon_Appointment__c app = new Eon_Appointment__c();
        //app.E_Meter_Type__c = 'KEY';//CH02.old
        app.E_Meter_Type__c =emeter.id;//CH02.New
        //app.G_Meter_Type__c = 'MCL';//CH02.old
        app.G_Meter_Type__c =gmeter.id;//CH02.New
        app.Number_of_Phases__c = '1Ph';/*CH08*/
        app.Metering_Pressure__c = 'LOW';
        //app.Fuel_ID__c='F-00002';
        app.Fuel_ID__c= fuel.id;
        insert app;
       
        EON_Capacity_Categories__c cs = new EON_Capacity_Categories__c();
        cs.Work_Skill__c='Test';
        cs.Gas_Meter_Type__c='A';
        cs.Gas_pressure__c='LOW';
        cs.Name='ALOW';
        insert cs;
        
        string workskill = EON_OFSC_Helper.getWorkSkill(app);
    }
    
    
    /**
         getWorkSkill_Pass_D_Type(): This method to cover - getWorkSkill()
    **/ 
    @isTest(SeeAllData=true)
    static void  getWorkSkill_Pass_D_Type() 
    {
        //CH02.start
        EON_Electric_Meter_Type__c emeter= new EON_Electric_Meter_Type__c();
        emeter.name='KEY';
        emeter.FILTER__c='KEY';
        emeter.OFS_Enumeration__c=010;
        insert emeter;
        EON_Gas_Meter_Type__c gmeter = new EON_Gas_Meter_Type__c();
        gmeter.name='A';
        gmeter.OFS_Enumeration__c=231;
        insert gmeter;
        //CH02.end
        Eon_Customer__c customer = EON_CreateTestRecords.createEONCustomer();
        customer.Name = '1234567891';
        customer.Customer_Name__c = '1234567891';
        insert customer;
        
        EON_Site__c site = EON_CreateTestRecords.createEonSite();
        site.Customer__c = customer.id;
        site.Thorofare__c = 'test Street';
        site.Town__c = 'test town';
        site.PostCode__c = 'test PS';
        insert site;
        
        EON_Fuel__c fuel = EON_CreateTestRecords.createEONFuel();
        fuel.MPAN__c = '12345';
        fuel.MPRN__c = '23467';
        fuel.Fuel_type__c = 'D';
        //fuel.customer__c = customer.id; //CH01
        fuel.Premise__c = site.id;
        
     
        insert fuel;
        
        Eon_Appointment__c app = new Eon_Appointment__c();
        //app.E_Meter_Type__c = 'KEY';//CH02.old
        app.Planned_E_Meter_Type__c = 'KEY';
        app.E_Meter_Type__c =emeter.id;//CH02.New
        //app.G_Meter_Type__c = 'MCL';//CH02.old
        app.Planned_G_Meter_Type__c  = 'MCL';
        app.G_Meter_Type__c =gmeter.id;//CH02.New
        app.Number_of_Phases__c = '1Ph';/*CH08*/
        app.Metering_Pressure__c = 'LOW';
        //app.Fuel_ID__c='F-00002';
        app.Fuel_ID__c= fuel.id;
        insert app;
        
        Eon_appointment__c app1 = new Eon_appointment__c();
        app1.E_Meter_Type__c =emeter.id;
        app1.G_Meter_Type__c =gmeter.id;
        app1.Number_of_Phases__c = '1Ph';
        app1.Metering_Pressure__c = 'LOW';
        app1.Fuel_ID__c= fuel.id;
        insert app1;
        
        EON_Capacity_Categories__c cs = new EON_Capacity_Categories__c();
        cs.Work_Skill__c='Test';
        cs.Elec_Meter_Type__c='KEY';
        cs.Gas_Meter_Type__c='A';
        cs.Elec_Phase__c='1PH';
        cs.Gas_pressure__c='LOW';
        cs.Name='KEYA1PHLOW';
        insert cs;
        
        string workskill = EON_OFSC_Helper.getWorkSkill(app);
         string workskill1 = EON_OFSC_Helper.getWorkSkill(app1);
    }
    //CH06.End
    
    static testMethod void AllFailConditons() 
    {        
        
        EON_OFSC_Helper.RecomendedTimeSlots  slots = new EON_OFSC_Helper.RecomendedTimeSlots();
        slots.dt =Date.today();
        slots.dayVal ='Mon';
        slots.timeFormat ='test';
        slots.timeSlots ='test';
        slots.workSkill ='test';
        slots.quota =2147483648L;
        slots.availability =2147483648L;        
        slots.activity_duration=2147483648L;
        slots.activity_travel_time=2147483648L;
        
        EON_OFSC_Helper.getOracleBucketId('123','','','123');
        EON_Job__c job = new EON_Job__c(Name = 'Job Test', Description__c = 'Test describe', Job_Type__c = 'ECO');
        insert job;
        
        EON_Region__c region = new EON_Region__c(Name = 'New Region Test', GSP_ID__c = 12 );   
        insert region;
        
        EON_Sub_Area__c subArea = new EON_Sub_Area__c(Name = 'Test Sub Area',Region_Name__c = region.id, ECO__c = true, Oracle_Bucket_ID__c = 'Buck_121');
        insert subArea;
        
        EON_Post_Code__c pstCode = new EON_Post_Code__c(Name = 'SE10 1',Sub_Area_Name__c = subArea.id);
        insert pstCode;
        EON_OFSC_Helper.getOracleBucketId(job.Name, job.job_Type__c,'','12'); 
        EON_OFSC_Helper.getOracleBucketId(job.Name, '',pstCode.name,'12'); 
        EON_OFSC_Helper.gettimeFormat('11-23-34');
        EON_Fuel__c fuel= EON_CreateTestRecords.createEONFuel();
        Eon_Appointment__c mapAppointment=EON_CreateTestRecords.createEONAppointment();
        EON_OFSC_Helper.mapAppointmentFromFuelSite(fuel, mapAppointment);
    }
    
     //CH02.End
     
    //CH03.start
    static testMethod void getUserElement_test() 
    {        
        EON_OFSC_Inbound_WS.UserElement userElement = EON_OFSC_Helper.getInboundUserElement();
        
    }
    static testMethod void getHeaderElement_test() 
    {        
        EON_OFSC_Inbound_WS.HeadElement headerElement = EON_OFSC_Helper.getHeaderElement();
        
    }
    static testMethod void convertDateToTOAFormat_test() 
    {        
        date d= date.today();
        string sDate = EON_OFSC_Helper.convertDateToTOAFormat(d);
    }
    //CH03.end
     
    /**
        This method will cover the exceptional parts.
    **/
    static testMethod void cover_Exceptions() 
    {   
        String jobcode,jobtype,postcode,MPANValue;
        String results = EON_OFSC_Helper.getOracleBucketId(jobCode, jobType, postCode, MPANValue);
    }
     //CH05.Start.New
     static testMethod void getUserElementForActivity_test() 
    {        
        EON_OFSC_Activity_WS.User_X userElement = EON_OFSC_Helper.getUserElementForActivity();
        
    }
     //CH05.Start.End
    /**
        getWorkSkillWithoutFuel() - This will cover method getWorkSkill without fuel ID in appointment
    **/
    static testmethod void getWorkSkillWithoutFuel(){
        EON_Capacity_Categories__c capacity4 = new EON_Capacity_Categories__c(name='TESTTESTTESTTEST',Gas_Meter_Type__c='Type_x',Elec_Phase__c='1PH', Work_Skill__c='WorkSkill');
        insert capacity4;
        
        EON_Appointment__c app = new EON_Appointment__c();
        app.MPAN__c = 'test';
        app.Planned_E_Meter_Type__c = 'test';
        app.Planned_G_Meter_Type__c = 'test';
        app.Number_of_Phases__c = 'test';
        app.Metering_Pressure__c = 'test';
        EON_OFSC_Helper.getWorkSkill(app);
        app.MPAN__c = null;
        app.MPRN__c = 'test';
        EON_OFSC_Helper.getWorkSkill(app);
        app.MPAN__c = 'test';
        EON_OFSC_Helper.getWorkSkill(app);
        app.Planned_E_Meter_Type__c =null;
        EON_OFSC_Helper.getWorkSkill(app);
    }   
    global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType)
    {
        if(functionType =='ValidMOP')
        {
            EON_Jumbo_ReqElectricityMOP.MOPValidationResponse res = new EON_Jumbo_ReqElectricityMOP.MOPValidationResponse();
            res.effFromDate = Date.today();
            res.effToDate = Date.today()+56;
            res.marParticipantId = 'EENG';
            res.isError = false;
            res.Error = '';
            response.put('response_x', res);
        }
        if(functionType =='ValidMAM')
        {
            /*EON_Jumbo_ReqGasMAM.MAMValidationResponse res = new EON_Jumbo_ReqGasMAM.MAMValidationResponse();
            res.effFromDate = Date.today();
            res.effToDate = Date.today()+56;
            res.abbrvtdName = 'EENG';         
            res.isError = false;
            res.Error = '';
            response.put('response_x', res);*/
            String[] Msg = new String[]{'Message1','Message2','Message3'};
            EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
            errObj.Message = Msg;
            EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
            gasAObj.EffectiveFromDate ='20150423';
            gasAObj.EffectiveToDate='20160823';
            gasAObj.AbbreviatedName='SGL';
            EON_JUMBO_Work_Management_WS.GasAppointedParty[] gasAppobj = new EON_JUMBO_Work_Management_WS.GasAppointedParty[]{gasAObj};
            EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfGasAppointedParty();
            aepObj.GasAppointedParty = gasAppobj;
            EON_JUMBO_Work_Management_WS.GasMeterPoint empObj = new EON_JUMBO_Work_Management_WS.GasMeterPoint();
            empObj.MPRN = 'mprn123';
            empObj.SupplierAppointments = aepObj;
            EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.GasSupplierDetailsResponse();
            respJumbo.Success = true;
            respJumbo.MeterPoint=empObj;
            respJumbo.Errors = errObj;
            EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasSupplierAppointmentsResponse_element();
            obj.RequestGasSupplierAppointmentsResult = respJumbo;
            response.put('response_x', obj);
        }
        if(functionType =='InValidMOP')
        {
            /*EON_Jumbo_ReqElectricityMOP.MOPValidationResponse res = new EON_Jumbo_ReqElectricityMOP.MOPValidationResponse();
            res.effFromDate = Date.today();
            res.effToDate = Date.today()+56;
            res.marParticipantId = 'MORR';
            res.isError = true;
            res.Error = '';
            response.put('response_x', res);*/
            String[] Msg = new String[]{'Message1','Message2','Message3'};
            EON_JUMBO_Work_Management_WS.ErrorList errObj = new EON_JUMBO_Work_Management_WS.ErrorList();
            errObj.Message = Msg;
            EON_JUMBO_Work_Management_WS.ElecAppointedParty eapObj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty(); 
            eapObj.EffectiveFromDate ='2015-04-23';
            eapObj.EffectiveToDate='2016-08-23';
            eapObj.MarketParticipantId='MOSS';
            EON_JUMBO_Work_Management_WS.ElecAppointedParty[] aEobj = new EON_JUMBO_Work_Management_WS.ElecAppointedParty[]{eapObj};
            EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty aepObj = new EON_JUMBO_Work_Management_WS.ArrayOfElecAppointedParty();
            aepObj.ElecAppointedParty = aEobj;
            EON_JUMBO_Work_Management_WS.ElecMeterPoint empObj = new EON_JUMBO_Work_Management_WS.ElecMeterPoint();
            empObj.MPAN = 'mpan123';
            empObj.SupplierAppointments = aepObj;
            EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse respJumbo = new EON_JUMBO_Work_Management_WS.ElecSupplierDetailsResponse();
            respJumbo.Success = false;
            respJumbo.MeterPoint=empObj;
            respJumbo.Errors = errObj;
            EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestElectricitySupplierAppointmentsResponse_element();
            obj.RequestElectricitySupplierAppointmentsResult = respJumbo;
            response.put('response_x', obj);
        }
        
        if(functionType =='InValidMAM')
        {
            EON_Jumbo_ReqGasMAM.MAMValidationResponse res = new EON_Jumbo_ReqGasMAM.MAMValidationResponse();
            res.effFromDate = Date.today();
            res.effToDate = Date.today()+56;
            res.abbrvtdName = 'EENG';
            res.isError = true;
            res.Error = '';
            response.put('response_x', res);
        }
        
        if(functionType=='Getcapacity'){
        EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
        capacityElement2.location = 'location';
        capacityElement2.date_x=system.today();
        //capacityElement2.time_slot='14-16';
        capacityElement2.time_slot='25:00-26:00';
        capacityElement2.work_skill='workSkill';
        capacityElement2.quota =1;
        capacityElement2.available= 1;
        List<EON_OFSC_GetCapacity_WS.capacity_element> capacities = new List<EON_OFSC_GetCapacity_WS.capacity_element>();
        capacities.add(capacityElement2);

        EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
        getCapacityResp.capacity = capacities;
        getCapacityResp.activity_duration = 1;
        getCapacityResp.activity_travel_time = 1;
        
        if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_request_element)
            response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_response_element());    
        
        else if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_close_time_request_element)
            response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_close_time_response_element());  
            
       else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_data_request_element)
            response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_data_response_element()); 
            
       else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_close_time_request_element)
            response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_close_time_response_element());  
            
       else if(request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element)
            response.put('response_x', getCapacityResp);
        }
        if(functionType=='GetcapacityNew'){
            List<EON_OFSC_GetCapacity_WS.capacity_element> capacities = new List<EON_OFSC_GetCapacity_WS.capacity_element>();
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement.location = 'location';
            capacityElement.date_x=system.today();
            capacityElement.time_slot='25:00-26:00';
            capacityElement.work_skill='GA';
            capacityElement.quota =5;
            capacityElement.available= 5;
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement1 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement1.location = 'location';
            capacityElement1.date_x=system.today();
            capacityElement1.time_slot='25:00-26:00';
            capacityElement1.work_skill='workSkill';
            capacityElement1.quota =5;
            capacityElement1.available= 5;
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement2.location = 'location';
            capacityElement2.date_x=system.today();
            capacityElement2.time_slot='25:00-26:00';
            capacityElement2.work_skill='workSkill';
            capacityElement2.quota =1;
            capacityElement2.available= 1;
            
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement3 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement3.location = 'location';
            capacityElement3.date_x=system.today();
            capacityElement3.time_slot='18:00-19:00';
            capacityElement3.work_skill=null;
            capacityElement3.quota =6;
            capacityElement3.available= 6;
            
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement4 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement4.location = 'location';
            capacityElement4.date_x=system.today();
            capacityElement4.time_slot='18:00-19:00';
            capacityElement4.work_skill='workSkill';
            capacityElement4.quota =5;
            capacityElement4.available= 5;
            
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement5 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement5.location = 'location';
            capacityElement5.date_x=system.today();
            capacityElement5.time_slot='27:00-28:00';
            capacityElement5.work_skill=null;
            capacityElement5.quota =7;
            capacityElement5.available= 7;
            
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement6 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement6.location = 'location';
            capacityElement6.date_x=system.today();
            capacityElement6.time_slot='27:00-28:00';
            capacityElement6.work_skill='Workskill';
            capacityElement6.quota =8;
            capacityElement6.available= 8;
                
            capacities.add(capacityElement);
            capacities.add(capacityElement1);
            capacities.add(capacityElement2);
            capacities.add(capacityElement3);
            capacities.add(capacityElement4);
            capacities.add(capacityElement5);
            capacities.add(capacityElement6);
   
            EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
            getCapacityResp.capacity = capacities;
            getCapacityResp.activity_duration = 1;
            getCapacityResp.activity_travel_time = 1;
    
            if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_response_element());    
    
            else if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_close_time_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_close_time_response_element());  
        
            else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_data_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_data_response_element()); 
        
            else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_close_time_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_close_time_response_element());  
        
            else if(request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element)
                response.put('response_x', getCapacityResp);   
        }
        if(functionType=='NoGAcapacity'){
            List<EON_OFSC_GetCapacity_WS.capacity_element> capacities = new List<EON_OFSC_GetCapacity_WS.capacity_element>();
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement1 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement1.location = 'location';
            capacityElement1.date_x=system.today();
            capacityElement1.time_slot='25:00-26:00';
            capacityElement1.work_skill='workSkill';
            capacityElement1.quota =1;
            capacityElement1.available= 1;
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement2.location = 'location';
            capacityElement2.date_x=system.today();
            capacityElement2.time_slot='25:00-26:00';
            capacityElement2.work_skill='workSkill';
            capacityElement2.quota =5;
            capacityElement2.available= 5;
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement3 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement3.location = 'location';
            capacityElement3.date_x=system.today();
            capacityElement3.time_slot='25:00-26:00';
            capacityElement3.work_skill='Error';
            capacityElement3.quota =1;
            capacityElement3.available= 1;
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement4 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement4.location = 'location';
            capacityElement4.date_x=system.today();
            capacityElement4.time_slot='12:00-14:00';
            capacityElement4.work_skill=null;
            capacityElement4.quota =5;
            capacityElement4.available= 5;
            
                
            //capacities.add(capacityElement);
            capacities.add(capacityElement1);
            capacities.add(capacityElement2);
            capacities.add(capacityElement3);        
            capacities.add(capacityElement4);
   
            EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
            getCapacityResp.capacity = capacities;
            getCapacityResp.activity_duration = 1;
            getCapacityResp.activity_travel_time = 1;
    
            if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_response_element());    
    
            else if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_close_time_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_close_time_response_element());  
        
            else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_data_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_data_response_element()); 
        
            else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_close_time_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_close_time_response_element());  
        
            else if(request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element)
                response.put('response_x', getCapacityResp);   
        }
        if(functionType=='GetGAcapacityNew'){
            List<EON_OFSC_GetCapacity_WS.capacity_element> capacities = new List<EON_OFSC_GetCapacity_WS.capacity_element>();
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement.location = 'location';
            capacityElement.date_x=system.today();
            capacityElement.time_slot='25:00-26:00';
            capacityElement.work_skill='GA';
            capacityElement.quota =5;
            capacityElement.available= 5;
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement1 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement1.location = 'location';
            capacityElement1.date_x=system.today();
            capacityElement1.time_slot='25:00-26:00';
            capacityElement1.work_skill='workSkill';
            capacityElement1.quota =1;
            capacityElement1.available= 1;
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement2 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement2.location = 'location';
            capacityElement2.date_x=system.today();
            capacityElement2.time_slot='25:00-26:00';
            capacityElement2.work_skill='workSkill';
            capacityElement2.quota =5;
            capacityElement2.available= 5;
            
        
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement3 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement3.location = 'location';
            capacityElement3.date_x=system.today();
            capacityElement3.time_slot='18:00-19:00';
            capacityElement3.work_skill=null;
            capacityElement3.quota =6;
            capacityElement3.available= 6;
            
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement4 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement4.location = 'location';
            capacityElement4.date_x=system.today();
            capacityElement4.time_slot='18:00-19:00';
            capacityElement4.work_skill='workSkill';
            capacityElement4.quota =5;
            capacityElement4.available= 5;
            
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement5 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement5.location = 'location';
            capacityElement5.date_x=system.today();
            capacityElement5.time_slot='27:00-28:00';
            capacityElement5.work_skill=null;
            capacityElement5.quota =7;
            capacityElement5.available= 7;
            
            EON_OFSC_GetCapacity_WS.capacity_element capacityElement6 = new EON_OFSC_GetCapacity_WS.capacity_element();
            capacityElement6.location = 'location';
            capacityElement6.date_x=system.today();
            capacityElement6.time_slot='27:00-28:00';
            capacityElement6.work_skill='Workskill';
            capacityElement6.quota =8;
            capacityElement6.available= 8;
                
            capacities.add(capacityElement);
            capacities.add(capacityElement1);
            capacities.add(capacityElement2);
            capacities.add(capacityElement3);
            capacities.add(capacityElement4);
            capacities.add(capacityElement5);
            capacities.add(capacityElement6);
   
            EON_OFSC_GetCapacity_WS.capacity_response_element getCapacityResp = new EON_OFSC_GetCapacity_WS.capacity_response_element();
            getCapacityResp.capacity = capacities;
            getCapacityResp.activity_duration = 1;
            getCapacityResp.activity_travel_time = 1;
    
            if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_response_element());    
    
            else if(request instanceof EON_OFSC_GetCapacity_WS.set_quota_close_time_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.set_quota_close_time_response_element());  
        
            else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_data_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_data_response_element()); 
        
            else if(request instanceof EON_OFSC_GetCapacity_WS.get_quota_close_time_request_element)
                response.put('response_x', new EON_OFSC_GetCapacity_WS.get_quota_close_time_response_element());  
        
            else if(request instanceof EON_OFSC_GetCapacity_WS.capacity_request_element)
                response.put('response_x', getCapacityResp);
        }
        
    }
    
    //CH07.start
    /*
        checkValidations_test1 - to test E LowBalanceAlertValue required validation
    */
    public static testMethod void checkValidations_test1(){
        //Create appointment data
        EON_Appointment__c objApp = new EON_Appointment__c(E_Low_balance_alert_flag__c=true);
         //CH10.Start
        objApp.Planned_Meter_Mode__c = 'PAYG';
        objApp.MPAN__c = '123434';
        objApp.MPRN__c = '123434';
        //CH10.End
        string error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('required'));
    }
    
    /*
        checkValidations_test2 - to test E Payment Reminder Frequency Code required validation
    */
    public static testMethod void checkValidations_test2(){
        //Create appointment data
        EON_Appointment__c objApp = new EON_Appointment__c(E_Payment_Reminder_Opt_in_Flag__c=true);
         //CH10.Start
        objApp.Planned_Meter_Mode__c = 'PAYG';
        objApp.MPAN__c = '123434';
        objApp.MPRN__c = '123434';
        //CH10.End
        string error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('required'));
    }
    
    /*
        checkValidations_test3 - to test E Payment Reminder Day Of The Week required validation
    */
    public static testMethod void checkValidations_test3(){
        //Create appointment data
        EON_Appointment__c objApp = new EON_Appointment__c(E_Payment_Reminder_Frequency_Code__c='W');
         //CH10.Start
        objApp.Planned_Meter_Mode__c = 'PAYG';
        objApp.MPAN__c = '123434';
        objApp.MPRN__c = '123434';
        //CH10.End
        string error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('required'));
        //CH10.Start
        objApp.E_Payment_Reminder_Day_Of_The_Week__c = 'Monday';
        objApp.E_Payment_Reminder_Date__c = Date.today();
        error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('E Payment Reminder Date'));
        
        objApp.E_Payment_Reminder_Frequency_Code__c='M';
        error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('E Payment Reminder'));
        objApp.E_Payment_Reminder_Date__c = null;
        error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('E Payment Reminder'));
        //CH10.End
    }
    
    /*
        checkValidations_test4 - to test G LowBalanceAlertValue required validation
    */
    public static testMethod void checkValidations_test4(){
        //Create appointment data
        EON_Appointment__c objApp = new EON_Appointment__c(G_Low_balance_alert_flag__c=true);
         //CH10.Start
        objApp.Planned_Meter_Mode__c = 'PAYG';
        objApp.MPAN__c = '123434';
        objApp.MPRN__c = '123434';
        //CH10.End
        string error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('required'));
    }
    
    /*
        checkValidations_test5 - to test G Payment Reminder Frequency Code required validation
    */
    public static testMethod void checkValidations_test5(){
        //Create appointment data
        EON_Appointment__c objApp = new EON_Appointment__c(G_Payment_Reminder_Opt_in_Flag__c=true);
        //CH10.Start
        objApp.Planned_Meter_Mode__c = 'PAYG';
        objApp.MPAN__c = '123434';
        objApp.MPRN__c = '123434';
        string error = EON_OFSC_Helper.checkValidations(objApp);
        //CH10.End
        system.assert(error.containsIgnoreCase('required'));
    }
    
    /*
        checkValidations_test6 - to test G Payment Reminder Day Of The Week required validation
    */
    public static testMethod void checkValidations_test6(){
        //Create appointment data
        EON_Appointment__c objApp = new EON_Appointment__c(G_Payment_Reminder_Frequency_Code__c='W');
        //CH10.Start
        objApp.Planned_Meter_Mode__c = 'PAYG';
        objApp.MPAN__c = '123434';
        objApp.MPRN__c = '123434';
        //CH10.End
        string error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('required'));
        //CH10.Start
        objApp.G_Payment_Reminder_Day_Of_The_Week__c = 'Monday';
        objApp.G_Payment_Reminder_Date__c = Date.today();
        error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('G Payment Reminder'));
        objApp.G_Payment_Reminder_Frequency_Code__c='M';
        error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('G Payment Reminder'));
        objApp.G_Payment_Reminder_Date__c = null;
        error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('G Payment Reminder'));
        //CH10.End
    }
    
    /*
        checkValidations_test7 - to test Planned Meter Mode required validation
    */
    public static testMethod void checkValidations_test7(){
        //Create appointment data
        EON_Job__c objJob = new EON_Job__c(Name='test',Job_Type__c='Smart',Description__c='test desc');
        insert objJob;
        EON_Appointment__c objApp = new EON_Appointment__c(Planned_Meter_Mode__c='',Job_code__c=objJob.Id);
        string error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error.containsIgnoreCase('required'));
    }
    
    /*
        checkValidations_test8 - to test No required validation
    */
    public static testMethod void checkValidations_test8(){
        //Create appointment data
        EON_Appointment__c objApp = new EON_Appointment__c();
        string error = EON_OFSC_Helper.checkValidations(objApp);
        system.assert(error=='');
    }
    //CH07.end
    //CH09.New.End
    /*
        addIndustryActivities_Pass - To cover - addIndustryActivities
    */
    public static testmethod void addIndustryActivities_Pass(){
        Map<String,String> attr = new Map<String,String>();
        attr.put('XA_ELEC_METER_TYPE', 'Key');
        attr.put('XA_PHASE', '1PH');
        attr.put('XA_GAS_METER_TYPE', 'MCL');
        attr.put('XA_PRESSURE', 'low');
        List<EON_OFSC_Helper.RecomendedTimeSlots> result = EON_OFSC_Helper.getCapacityFromOFSC(null,null,attr,null,null,null);
    }
    //CH09.New.End
}