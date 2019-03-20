/**
    Description     : This class will will process appointment bulk and this functionality mostly used as utility while deployment or immediate deployment of EON project.
    Test Class      : EON_Process_Bulk_Appointment_Batch_test/EON_Deployment_Utility_Test     
**/
/*
    Created By : Mahadev Joshilkar
    Created Date : 07-Oct-2016
    Service Request : SR_EON_Jumbo_055
    Change History :
    CH01 # SR_EON_JUMBO_098 # 16/01/2017 # Mahadev Joshilkar #  Improved logic to create - EON Appointment Contacts
    CH02 # SR_EON_AB_200 # 23/01/2017 # Mahadev Joshilkar #  Improved logic to handle - Planned E Meter Type
	CH03 # SR_OptiMUS_EON_297 # 11/02/2019 # Tabish Almas #  Added logic to get data from MDS or Jumbo based on MDS Jumbo Dataflow Switch
*/
global class EON_Process_Bulk_Appointment_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts{
  global list<String> allAppointment;
    global string query;
    global string emailToNotify;
    global String allError;
    global string eMeterType;
    global Database.QueryLocator start(Database.BatchableContext bc){
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> allAppointments){
		list<Jumbo_Data_Tracker__c> jTrack = new list<Jumbo_Data_Tracker__c>();
		list<MDS_Data_Tracker__c> mTrack = new list<MDS_Data_Tracker__c>();		//CH03
		list<Oracle_Data_Tracker__c> oTrack = new list<Oracle_Data_Tracker__c>();
		list<EON_Appointment__c> updateAllAppointment = new list<EON_Appointment__c>();
		list<EON_Appointment_Contact__c> allAppCon = new list<EON_Appointment_Contact__c>();
		String switchData = EON_MDS_Utility.getMDS_Jumbo_Status();	//CH03
        for(sObject obj:allAppointments){
            EON_Appointment__c app = (EON_Appointment__c)obj;
            try{
				if(switchData == system.label.Jumbo_Shortform) {
					if(EON_Deployment_Utility_test.genException == null)
					EON_Deployment_Utility_test.genException = false;
					if(EON_Deployment_Utility_test.genException) //Generate exception
					ID test = ID.valueOf('test');
					
					system.debug('###MPAN: '+app.MPAN__c);
					system.debug('###MPRN: '+app.MPRN__c);
					eMeterType = !EON_Utility.validateRequired(app.Planned_E_Meter_Type__c) ? app.Planned_E_Meter_Type__c : ''; //CH02.New
					//Call J.18 - Get MPAN Details
					if(app.MPAN__c != null && app.MPAN__c != ''){
						EON_Jumbo_ReqElecMeterPointData.AccessElecMeterPointData(app.MPAN__c,app,'','');
						if(!EON_Utility.validateRequired(EON_Jumbo_ReqElecMeterPointData.apptIns))
						app = EON_Jumbo_ReqElecMeterPointData.apptIns;
						app.Planned_E_Meter_Type__c = !EON_Utility.validateRequired(eMeterType) ? eMeterType : app.Planned_E_Meter_Type__c; //CH02.New
						if(!EON_Utility.validateRequired(EON_Jumbo_ReqElecMeterPointData.cTrack)){
							JUMBO_Data_Tracker__c jmTrack = new JUMBO_Data_Tracker__c();
							jmTrack = EON_Jumbo_ReqElecMeterPointData.cTrack;
							jmTrack.EON_Appointment__c = app.ID;
							jTrack.add(jmTrack);
						}
					}
					//Call J.19 - Get MPRN Details
					if(app.MPRN__c != null && app.MPRN__c != ''){
						EON_Jumbo_ReqGasMeterPointData.AccessGasMeterPointData(app.MPRN__c,app,'','');
						if(!EON_Utility.validateRequired(EON_Jumbo_ReqGasMeterPointData.apptIns))
						app = EON_Jumbo_ReqGasMeterPointData.apptIns;        
						if(!EON_Utility.validateRequired(EON_Jumbo_ReqGasMeterPointData.cTrack)){
							JUMBO_Data_Tracker__c jmTrack = new JUMBO_Data_Tracker__c();
							jmTrack = EON_Jumbo_ReqGasMeterPointData.cTrack;
							jmTrack.EON_Appointment__c = app.ID;
							jTrack.add(jmTrack);
						}
					}
					
					//Create EON Appointment Contact
					EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
					appCon.Contact_Type__c=[select id from EON_Contact_Type__c where Code__c='A' limit 1].id; //Static Data
					if(!EON_Utility.validateRequired(app.Customer_Preferred_Contact_Method__c)){
						List<EON_Media_Type__c> lMediaType = new List<EON_Media_Type__c>();
						if(!EON_Utility.validateRequired(EON_JUMBO_Create_ElecJob_In_Isis_WS.mediaType(app.Customer_Preferred_Contact_Method__c)))
						lMediaType=[select id from EON_Media_Type__c where code__c =:EON_JUMBO_Create_ElecJob_In_Isis_WS.mediaType(app.Customer_Preferred_Contact_Method__c) limit 1];
						if(!lMediaType.isEmpty())
						appCon.Media_Type__c = lMediaType[0].id;
						if(!EON_Utility.validateRequired(EON_JUMBO_Create_ElecJob_In_Isis_WS.mediaDetails(app)))
						appCon.Media_Detail__c = EON_JUMBO_Create_ElecJob_In_Isis_WS.mediaDetails(app); 
					}
					else{ //CH01.New
						List<EON_Media_Type__c> lMediaType = [select id from EON_Media_Type__c where Name = 'Telephone' limit 1];
						if(!lMediaType.isEmpty())
						appCon.Media_Type__c = lMediaType[0].id;
						if(!EON_Utility.validateRequired(app.Contact_Telephone_Number__c))
						appCon.Media_Detail__c = app.Contact_Telephone_Number__c;
						else 
						appCon.Media_Detail__c = '0151 541 6563';
					}
					if(!EON_Utility.validateRequired(app.Customer_Name__c)) 
					appCon.Contact_Full_Name__c = app.Customer_Name__c;  
					updateAllAppointment.add(app);
					//update app;
					appCon.EON_Appointment_ID__c =app.id;
					allAppCon.add(appCon);
					
					//Call F.22/O.16 - Create reservation in OFSC
					string result = EON_Deployment_Utility.sendActivityToOFSC(app, 'CREATE', '', '', String.valueOf(app.Appointment_Date__c), App.Time_Slot__c, app.Booking_System_Name__c, appCon);
					system.debug('####Result: '+result);
					if(!EON_Utility.validateRequired(EON_Deployment_Utility.requestOut))
					oTrack.add(EON_Deployment_Utility.requestOut);
					if(result == 'Job sent to OFSC successfully')
					app.Sent_to_Oracle__c = true;
					if(!EON_Utility.validateRequired(app.Customer_Name__c))
					app.Caller_Name__c = app.Customer_Name__c;
					app.Confirmed_Appointment_DateTime__c = System.now();
					app.Status__c = 'SCHEDULED';
					//if(!EON_Utility.validateRequired(app.Start_Time__c) && !EON_Utility.validateRequired(app.End_Time__c))
					//  app.Time_Slot__c = app.Start_Time__c +' - '+ app.End_Time__c;
					if(!EON_Utility.validateRequired(app.Planned_Number_of_Registers__c)){
						String plannedNumberReg = app.Planned_Number_of_Registers__c;
						system.debug('####Planned: '+plannedNumberReg);
						if(plannedNumberReg.isnumeric()){
							if(Integer.valueOf(plannedNumberReg) == 1)
							app.Planned_Meter_Registers__c = 'Single-rate';
							if(Integer.valueOf(plannedNumberReg) > 1)
							app.Planned_Meter_Registers__c = 'Multi-rate';
						}
					}
					//app.Appointment_reason_code__c = [Select ID from Eon_Appointment_Reason__c where Name='Customer Request' limit 1].ID;
					//app.Parking_Type__c = [Select ID from EON_Parking__c where name = 'On Street Parking'].ID;
					//Calculate Sub Area
					string postcode = '';
					if(App.Metering_Point_Postcode__c != '')
					postcode = App.Metering_Point_Postcode__c.substring(0, App.Metering_Point_Postcode__c.length()-2);
					EON_Job__c job = [Select ID, Name, Duration__c, SME_Duration__c, h_Job_Attribute_Duration__c, Job_Type__c from EON_Job__c where ID=: app.Job_Code__c limit 1];
					String jobType = job.Job_Type__c;
					list<EON_Post_Code__c> lstPC = new list<EON_Post_Code__c>([select id, name, h_sub_area_checkbox__c, Sub_Area_Name__r.Id, Sub_Area_Name__r.Oracle_Bucket_ID__c from EON_Post_Code__c where name =: postcode]);
					for(EON_Post_Code__c objPC : lstPC){
						string check = string.isNotBlank(objPC.h_sub_area_checkbox__c) ? objPC.h_sub_area_checkbox__c : '';
						if (jobType != '' && check != '' && check.containsIgnoreCase(jobType)) {
							app.SubArea__c = objPC.Sub_Area_Name__r.Id; 
						}
					}
					/*if(app.MPAN__c != null && app.MPAN__c != ''){
					EON_Sub_Area__c subArea = new EON_Sub_Area__c();
					String getGSP = app.MPAN__c.substring(0,2); 
					if(getGSP.isNumeric()){
						ID regionID = [Select ID, GSP_ID__c from EON_Region__c where GSP_ID__c =: Integer.valueOf(getGSP) limit 1].ID;
						if(app.Job_Code__r.Job_Type__c != '' && app.Job_Code__r.Job_Type__c != null){
							if(app.Job_Code__r.Job_Type__c == 'Maintenance')
								subArea = [Select ID from EON_Sub_Area__c where Region_Name__c=:regionID and Maintenance__c = true limit 1];
							else if(app.Job_Code__r.Job_Type__c == 'ECO')
								subArea = [Select ID from EON_Sub_Area__c where Region_Name__c=:regionID and ECO__c = true limit 1];
							else if(app.Job_Code__r.Job_Type__c == 'Smart')
								subArea = [Select ID from EON_Sub_Area__c where Region_Name__c=:regionID and Smart__c = true limit 1];
							else if(app.Job_Code__r.Job_Type__c == 'New Connections')
								subArea = [Select ID from EON_Sub_Area__c where Region_Name__c=:regionID and New_Connections__c = true limit 1];
							app.SubArea__c = subArea.ID;
						}
					}
				}*/
				}
				else if(switchData == system.label.MDS_Shortform) {
					if(EON_Deployment_Utility_test.genException == null)
					EON_Deployment_Utility_test.genException = false;
					if(EON_Deployment_Utility_test.genException) //Generate exception
					ID test = ID.valueOf('test');
					
					system.debug('###MPAN: '+app.MPAN__c);
					system.debug('###MPRN: '+app.MPRN__c);
					eMeterType = !EON_Utility.validateRequired(app.Planned_E_Meter_Type__c) ? app.Planned_E_Meter_Type__c : '';
					//Call J.18 - Get MPAN Details
					if(app.MPAN__c != null && app.MPAN__c != ''){
						EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(app.MPAN__c,app,'','');
						if(!EON_Utility.validateRequired(EON_MDS_ReqElecMeterPointData.apptIns))
						app = EON_MDS_ReqElecMeterPointData.apptIns;
						app.Planned_E_Meter_Type__c = !EON_Utility.validateRequired(eMeterType) ? eMeterType : app.Planned_E_Meter_Type__c;
						if(!EON_Utility.validateRequired(EON_MDS_ReqElecMeterPointData.cTrack)){
							MDS_Data_Tracker__c mdsTrack = new MDS_Data_Tracker__c();
							mdsTrack = EON_MDS_ReqElecMeterPointData.cTrack;
							mdsTrack.EON_Appointment__c = app.ID;
							mTrack.add(mdsTrack);
						}
					}
					//Call J.19 - Get MPRN Details
					if(app.MPRN__c != null && app.MPRN__c != ''){
						EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(app.MPRN__c,app,'','');
						if(!EON_Utility.validateRequired(EON_MDS_ReqGasMeterPointData.apptIns))
						app = EON_MDS_ReqGasMeterPointData.apptIns;        
						if(!EON_Utility.validateRequired(EON_MDS_ReqGasMeterPointData.cTrack)){
							MDS_Data_Tracker__c mdsTrack = new MDS_Data_Tracker__c();
							mdsTrack = EON_MDS_ReqGasMeterPointData.cTrack;
							mdsTrack.EON_Appointment__c = app.ID;
							mTrack.add(mdsTrack);
						}
					}
					
					//Create EON Appointment Contact
					EON_Appointment_Contact__c appCon = new EON_Appointment_Contact__c();
					appCon.Contact_Type__c=[select id from EON_Contact_Type__c where Code__c='A' limit 1].id; //Static Data
					if(!EON_Utility.validateRequired(app.Customer_Preferred_Contact_Method__c)){
						List<EON_Media_Type__c> lMediaType = new List<EON_Media_Type__c>();
						if(!EON_Utility.validateRequired(EON_Jumbo_Create_ElecJob_In_Isis_WS.mediaType(app.Customer_Preferred_Contact_Method__c)))
						lMediaType=[select id from EON_Media_Type__c where code__c =:EON_Jumbo_Create_ElecJob_In_Isis_WS.mediaType(app.Customer_Preferred_Contact_Method__c) limit 1];
						if(!lMediaType.isEmpty())
						appCon.Media_Type__c = lMediaType[0].id;
						if(!EON_Utility.validateRequired(EON_Jumbo_Create_ElecJob_In_Isis_WS.mediaDetails(app)))
						appCon.Media_Detail__c = EON_Jumbo_Create_ElecJob_In_Isis_WS.mediaDetails(app); 
					}
					else{ //CH01.New
						List<EON_Media_Type__c> lMediaType = [select id from EON_Media_Type__c where Name = 'Telephone' limit 1];
						if(!lMediaType.isEmpty())
						appCon.Media_Type__c = lMediaType[0].id;
						if(!EON_Utility.validateRequired(app.Contact_Telephone_Number__c))
						appCon.Media_Detail__c = app.Contact_Telephone_Number__c;
						else 
						appCon.Media_Detail__c = '0151 541 6563';
					}
					if(!EON_Utility.validateRequired(app.Customer_Name__c)) 
					appCon.Contact_Full_Name__c = app.Customer_Name__c;  
					updateAllAppointment.add(app);
					//update app;
					appCon.EON_Appointment_ID__c =app.id;
					allAppCon.add(appCon);
					
					//Call F.22/O.16 - Create reservation in OFSC
					string result = EON_Deployment_Utility.sendActivityToOFSC(app, 'CREATE', '', '', String.valueOf(app.Appointment_Date__c), App.Time_Slot__c, app.Booking_System_Name__c, appCon);
					system.debug('####Result: '+result);
					if(!EON_Utility.validateRequired(EON_Deployment_Utility.requestOut))
					oTrack.add(EON_Deployment_Utility.requestOut);
					if(result == 'Job sent to OFSC successfully')
					app.Sent_to_Oracle__c = true;
					if(!EON_Utility.validateRequired(app.Customer_Name__c))
					app.Caller_Name__c = app.Customer_Name__c;
					app.Confirmed_Appointment_DateTime__c = System.now();
					app.Status__c = 'SCHEDULED';
					if(!EON_Utility.validateRequired(app.Planned_Number_of_Registers__c)){
						String plannedNumberReg = app.Planned_Number_of_Registers__c;
						system.debug('####Planned: '+plannedNumberReg);
						if(plannedNumberReg.isnumeric()){
							if(Integer.valueOf(plannedNumberReg) == 1)
							app.Planned_Meter_Registers__c = 'Single-rate';
							if(Integer.valueOf(plannedNumberReg) > 1)
							app.Planned_Meter_Registers__c = 'Multi-rate';
						}
					}
					string postcode = '';
					if(App.Metering_Point_Postcode__c != '')
					postcode = App.Metering_Point_Postcode__c.substring(0, App.Metering_Point_Postcode__c.length()-2);
					EON_Job__c job = [Select ID, Name, Duration__c, SME_Duration__c, h_Job_Attribute_Duration__c, Job_Type__c from EON_Job__c where ID=: app.Job_Code__c limit 1];
					String jobType = job.Job_Type__c;
					list<EON_Post_Code__c> lstPC = new list<EON_Post_Code__c>([select id, name, h_sub_area_checkbox__c, Sub_Area_Name__r.Id, Sub_Area_Name__r.Oracle_Bucket_ID__c from EON_Post_Code__c where name =: postcode]);
					for(EON_Post_Code__c objPC : lstPC){
						string check = string.isNotBlank(objPC.h_sub_area_checkbox__c) ? objPC.h_sub_area_checkbox__c : '';
						if (jobType != '' && check != '' && check.containsIgnoreCase(jobType)) {
							app.SubArea__c = objPC.Sub_Area_Name__r.Id; 
						}
					}
				}
            }
            catch(Exception ex){
                system.debug('####Exception while Inserting Tracker: '+ex.getMessage()+' - '+ ex.getStackTraceString());
                allError += app.Name+' - '+ex.getMessage()+' - '+ ex.getStackTraceString();
            }
        }
        try{
            if(!updateAllAppointment.isEmpty())
                update updateAllAppointment;
            system.debug('###Count Appointment Contact: '+allAppCon.size());
            if(!allAppCon.isEmpty())
                insert allAppCon;
            system.debug('###Count Jumbo: '+jTrack.size());
            if(!jTrack.isEmpty())
                insert jTrack;
			//CH03.Start
			system.debug('###Count MDS: '+mTrack.size());
            if(!mTrack.isEmpty())
                insert mTrack;
			//CH03.End
            system.debug('###Count Oracle: '+oTrack.size());
            if(!oTrack.isEmpty())
                insert oTrack;
         }
        catch(Exception ex){
            system.debug('####Exception while Inserting Tracker: '+ex.getMessage()+' - '+ ex.getStackTraceString());
            allError += ex.getMessage() +' | '+ ex.getStackTraceString();
        }
    }
    global void finish(Database.BatchableContext bc){
        String msgBody = 'MUS Appointment processing is finished.';
        if(allError != '' && allError != null){
            msgBody += '\n Below are error details \n'+allError;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new String[] {emailToNotify});
    mail.setReplyTo(System.Label.Appointment_Utility_Email); 
    mail.setSenderDisplayName('Bulk Appointment Process');
    mail.setSubject('Batch Process Completed');
    mail.setPlainTextBody(msgBody);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}