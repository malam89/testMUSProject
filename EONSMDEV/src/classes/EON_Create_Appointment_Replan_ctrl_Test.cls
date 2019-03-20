/**
    Descriptin : This class covers 1. EON_Create_Appointment_Replan_ctrl 
**/

/*
    Created By : Praveen G
    Created Date : 20-02-2018
    Service Request : SR_OptiMUS_EON_179
*/

@isTest
global class EON_Create_Appointment_Replan_ctrl_Test  {
    
    /**
        unitTest() - unitTest
    **/
    public testMethod static void unitTest() {
    
        EON_Customer__c eCust = EON_CreateTestRecords.createEONCustomer();
        eCust.Customer_Name__c = 'Eon_Test';
        insert eCust;
        EON_Site__c eSite = EON_CreateTestRecords.cereateEONSite();
        eSite.Postcode__c = 'SE10 2';
        insert eSite;
        EON_Fuel__c eFuel = EON_CreateTestRecords.createEONFuel();
        eFuel.MPAN__c = '12'; 
        eFuel.MPRN__c = '123';        
        eFuel.Premise__c = eSite.id;
        eFuel.Fuel_Type__c = 'E';
        insert eFuel;        
        
        EON_Media_Type__c objMedType1 = new EON_Media_Type__c(Name='A', Code__c='1');
        insert objMedType1;
        EON_Media_Type__c objMedType2 = new EON_Media_Type__c(Name='E', Code__c='E');
        insert objMedType2;
        
       //Create EON Vulnerability Code
        EON_Vulnerability_Code__c objVulCode1 = new EON_Vulnerability_Code__c(Name='test description', Vulnerability_Code__c=1); 
        insert objVulCode1;
        EON_Vulnerability_Code__c objVulCode2 = new EON_Vulnerability_Code__c(Name='test description1', Vulnerability_Code__c=2); 
        insert objVulCode2;
        
        //Create EON Contact Type 
        EON_Contact_Type__c objConType = new EON_Contact_Type__c(Name='A', Code__c='1');
        insert objConType;
        
        EON_Contact_Type__c objConType1 = new EON_Contact_Type__c(Name='Appointment Contact', Code__c='1');
        insert objConType1;                 
        
                
        EON_Appointment__c appt = new EON_Appointment__c(Booking_System_Name__c = 'Test', EON_Appointment_ID__c = 'Test123',Requested_SSC__c = '1234',//CH02.old//CH03
        Appointment_Date__c = Date.Today(), End_Time__c = '12:32',Post_Code__c = 'SE10 1', MPAN__c = '12',Job_Code__c = null);
        insert appt; 
        
        EON_Job__c job = new EON_Job__c();
        job.Name = 'smart Job';
        job.Description__c = 'smart Description';
        insert job;
        
        appt.job_Code__c = job.id;
        update appt;           
        
        //Create EON Appointment Contact1
        EON_Appointment_Contact__c objCont = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail', EON_Appointment_ID__c=appt.Id);
        insert objCont;
        
        //Create EON Appointment Contact2
        EON_Appointment_Contact__c objCont1 = new EON_Appointment_Contact__c(Contact_Type__c=objConType.Id, Media_Type__c=objMedType1.Id, Contact_Full_Name__c='test contact full name', Media_Detail__c='test media detail');
        insert objCont1;          
        
        Test.setMock(WebServiceMock.class, new EON_Create_Appointment_Request_ctrl_Test());

        ApexPages.currentPage().getParameters().put('appointmentID',appt.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(appt);
        EON_Create_Appointment_Replan_ctrl controller = new EON_Create_Appointment_Replan_ctrl(sc);  
        
        //Create EON Appointment Reason
        Eon_Appointment_Reason__c ObjReason = new Eon_Appointment_Reason__c(Name='TestReason',Appointment_reason_code__c='NEW_CONN');
        insert ObjReason;        
        
        controller.ApptCont = objCont;
        controller.selectedContact = objConType.Id;
        controller.selectedMediaType = objMedType1.id;         
        
        
        controller.addRowCon();
        controller.removeRowCon();  
         
        
       list<EON_Media_Type__c> allMediaType = new list<EON_Media_Type__c>();
        EON_Media_Type__c mediaType1 = new EON_Media_Type__c();
        mediaType1.Name = 'Telephone';
        allMediaType.add(mediaType1);
        EON_Media_Type__c mediaType2 = new EON_Media_Type__c();
        mediaType2.Name = 'Email';
        allMediaType.add(mediaType2);
        EON_Media_Type__c mediaType3 = new EON_Media_Type__c();
        mediaType3.Name = 'Mobile';
        allMediaType.add(mediaType3);
        insert allMediaType; 
        
        EON_Appointment_Contact__c apptContact = new EON_Appointment_Contact__c();
        apptContact.EON_Appointment_ID__c = appt.ID;
        apptContact.Contact_Full_Name__c = 'test';
        apptContact.Media_Detail__c = 'Test';
        apptContact.Media_Type__c = mediaType1.ID;
        insert apptContact;  
        
        EON_Contact_Type__c conType = new EON_Contact_Type__c();
        conType.name = 'test1';
        insert conType;              
        
        list<SelectOption> medTypeOption = new list<SelectOption>();
        medTypeOption.add(new SelectOption(mediaType1.ID, 'Telephone'));
        medTypeOption.add(new SelectOption(mediaType2.ID, 'Email'));
        medTypeOption.add(new SelectOption(mediaType3.ID, 'Mobile'));               
        
        controller.MediaTypeLst = medTypeOption;
        
        controller.selectedContact = conType.ID;
        controller.ApptCont = apptContact;
        controller.MediaTypeLst = medTypeOption;
        controller.selectedMediaType = mediaType1.ID;
        controller.addRowCon(); 
        controller.selectedMediaType = mediaType2.ID;
        controller.addRowCon();
        controller.selectedMediaType = mediaType3.ID;
        controller.addRowCon(); 
        
        list<EON_Appointment_Contact__c> lstCon = new list<EON_Appointment_Contact__c>();
            lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name1',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med1',Media_Type__c=objMedType1.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name2',Contact_Type__c=objConType.Id,Media_Detail__c='test eon med2',Media_Type__c=objMedType2.Id));
        lstCon.add(new EON_Appointment_Contact__c(Contact_Full_Name__c='test eon name3',Contact_Type__c=objConType1.Id,Media_Detail__c='test eon med3',Media_Type__c=objMedType1.Id));
                          
        controller.validateAppointmentContacts(lstCon);
        
        List<EON_Appointment_Contact__c> lstAppt = new List<EON_Appointment_Contact__c>();
        EON_Appointment_Contact__c  cont = new EON_Appointment_Contact__c(Contact_Full_Name__c='test');
        lstAppt.add(cont);
        insert lstAppt;
        
        controller.lstApptContact=lstAppt;
        controller.removeIndex = 0;
        controller.removeRowCon();
        
        controller.lstApptContact=null;
        controller.removeIndex = 0;
        controller.removeRowCon(); 
        
        controller.isKeycollection();
        
        EON_Gas_Meter_Location__c GMLoc = new EON_Gas_Meter_Location__c();
        GMLoc.Name = 'GLOCATION';
        insert GMLoc;
        
        EON_Electric_Meter_Location__c EMLoc = new EON_Electric_Meter_Location__c();
        EMLoc.Name = 'ELOCATION';
        insert EMLoc;
        
        controller.getGMeterloc();
        controller.getEMeterloc();
        
        
        Eon_Delivery_Method__c DM1 = new Eon_Delivery_Method__c(Name = 'test_DM',Code__c = 'E');
        insert DM1;
                
        EON_Appointment_Comms__c comm1 = new EON_Appointment_Comms__c(); 
        comm1.EON_Appointment_ID__c = appt.id;
        comm1.Comm_Type_Code__c = 'I';
        comm1.Delivery_Method_Desc__c = DM1.id;
        
        EON_Appointment_Comms__c comm2 = new EON_Appointment_Comms__c(); 
        comm2.EON_Appointment_ID__c = appt.id;
        comm2.Comm_Type_Code__c = 'R';
        comm2.Delivery_Method_Desc__c = DM1.id;
        
        EON_Appointment_Comms__c comm3 = new EON_Appointment_Comms__c(); 
        comm3.EON_Appointment_ID__c = appt.id;
        comm3.Comm_Type_Code__c = 'C';
        comm3.Delivery_Method_Desc__c = DM1.id;
        list<EON_Appointment_Comms__c> AClist = new list<EON_Appointment_Comms__c>();
        AClist.add(comm1);
        AClist.add(comm2);
        AClist.add(comm3);
        
        insert ACList; 
        
        
        controller.newAppointment = appt;
        controller.getAppCommsLst();
        
        List<Eon_Delivery_Method__c> lstDM = new List<Eon_Delivery_Method__c>();
        lstDM.add(DM1);
        

        
        controller.delMethLst =lstDM; 
        controller.getDeliveryMethodC();
        controller.getDeliveryMethodR();
        controller.getDeliveryMethodI();
        
        EON_Vulnerability_Code__c EVC = new EON_Vulnerability_Code__c();
        EVC.Vulnerability_Code__c = 12;
        EVC.Name = 'test';
        insert EVC;        
        controller.selectedVulnerability = EVC.id;
        controller.addRow();
        
        controller.removeRow();  
        
        controller.save();  
        
        controller.createApptInOFSC(); 
        
        controller.selectedDeliveryMethod_c = 'C';
        controller.selectedDeliveryMethod_I = 'I';
        controller.selectedDeliveryMethod_R = 'R';
        controller.selectedParking = 'P';
        controller.selectedParking = null;
        controller.lstApptContact = null;
        controller.canProceed = null;
                    
        
               
    }
}