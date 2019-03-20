/**
    Description : This test class covers the code coverage for below class
                  EON_Utility
**/
/*
    Created By : Praveen G
    Created Date : 07-March-2016
    Service Request : N/A
    Change History
    CH01 # 28-03-2016 # Purvi # SR_EON_PC_016 # Changed API name of some Objects.
    CH02 # SR_EON_Mobile_042 #30/05/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
    CH03 # SR_EON_AB_050 # 03/06/2016 # Increase coverage for new method.
    CH04 # SR_EON_Mobile_046 #08/06/2016 #Shruti Moghe # Changed field type for the field Requested_SSC__c
	CH05 # SR_EON_Jumbo_106 # 05/06/2017 # Mahadev # Improve coverage for new method.
*/
@isTest
private class EON_Utility_Test {
    static testMethod void unitTest1() {
        EON_Utility.md5('test'); 
        EON_PAYG_Deferral_Reason__c instance = EON_CreateTestRecords.createEONPaygDeferralReason(); //CH01
        insert instance;
        EON_Utility.createAttachment(instance.id, 'test Body', 'test');
        EON_Utility.validateStringLength('test');
        EON_Utility.validateRequired('test');
        boolean result = EON_Utility.validateRequired('');
        String value = 'Test 1234';
        for(integer i=0; i<68075; i++){
            value += 'Bc ';
        }
        //CH02.start
        EON_SSC__c  ssc= EON_CreateTestRecords.createEON_SSC();
        insert ssc;
         //CH02.end      
        EON_Utility.validateStringLength(value);
        System.assert(result, true);
        EON_Utility.getDayOfWeek(system.today());
        EON_Appointment__c app = new EON_Appointment__c();
        app.Booking_System_Name__c = 'JUMBO';
        app.Requested_SSC__c     = '1234';//CH02.old //CH04.new
        //app.Requested_SSC__c     =ssc.id; //CH02.New//CH04.old
        app.EON_Appointment_ID__c  = '12345897';
        insert app;
        EON_Utility.convertStringToNumber('2016');
        EON_Utility.convertStringToNumber('sss');
        EON_Utility.GenUniqueNum();
        //CH03.start
        datetime dt = datetime.newInstance(2016, 12, 1);
        EON_Utility.getNewdatetime(dt);
        datetime dt1 = datetime.newInstance(2016, 06, 1); //daylight saving time
        EON_Utility.getNewdatetime(dt1);
        //CH03.end
        EON_Utility.callOFSCAppointment(String.valueof(app.Id),'Create','','','2016-02-02','','');
        EON_Utility.genException = true;
        EON_Utility util= new EON_Utility();
        util.getErrorCode('Type');
        try{
            integer total= 1/0;
        }
        catch(exception e){
            util.getErrorCode(e);
        }
        EON_Error_Code__c error5 = new EON_Error_Code__c(name='100',Error_Name__c='UnknownError');
        insert error5;
        util.getErrorCode('Type');
        EON_Error_Code__c error3 = new EON_Error_Code__c(name='UnknownError',Error_Name__c='type');
        insert error3;
        util.getErrorCode('Type');
        EON_Error_Code__c error4 = new EON_Error_Code__c(name='type',Error_Name__c='UnknownError');
        insert error4;
        util.getErrorCode('Type');
        try{
            integer total= 1/0;
        }
        catch(exception e){
            EON_Error_Code__c  error2=util.getErrorCode(e);
        }
    }

    static testMethod void unitTest2() {
        String orgId = userInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = 'fName',
                            lastName = 'lName',
                            email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org',
                            EmailEncodingKey = 'ISO-8859-1',
                            Alias = uniqueName.substring(18, 23),
                            TimeZoneSidKey = 'America/Los_Angeles',
                            LocaleSidKey = 'en_US',
                            LanguageLocaleKey = 'en_US',
                            ProfileId = UserInfo.getProfileId(),
                            UserRoleId = UserInfo.getUserRoleId());
        insert tuser;
        List <String> relationFields = new List <String>();
        relationFields.add('Profile.Name');
        User currentUser = new User(id = UserInfo.getUserId());
        sObject originalSObject = (sObject) currentUser;
        List<sObject> originalSObjects = new List<sObject>{originalSObject};
        originalSObjects.add(tuser);
        EON_Utility.getAllFields(originalSobjects,originalSobject.getsObjectType(),relationFields);
        EON_Utility.getLongText();
    }
    
    static testMethod void unitTest3() {
        EON_Appointment__c app = new EON_Appointment__c();
        insert app;
        EON_Appointment__c appRec = [select name, ID, Sent_to_Oracle__c from EON_Appointment__c where id=:app.id]; //CH05.Update
        EON_Utility.validateAppointmentStatus(appRec.Name);
        
        EON_Utility.validateAppointmentStatus('TESTlkiju');
        EON_Utility.getInstanceURL();
        //CH05.New.Start
        list<ID> allApptID = new list<ID>();
        appRec.Sent_to_Oracle__c = true;
        update appRec;
        allApptID.add(appRec.ID);
        EON_Utility.updateOFSCAppointment(allApptID);
        //CH05.New.End
        EON_Utility.smartMeterModel('fType', 'MS1', 'Manufacturer', 'model');
        EON_Utility.convertStringToDecimal('123');
        EON_Utility.validateTimeBST(dateTime.now());
    }
}