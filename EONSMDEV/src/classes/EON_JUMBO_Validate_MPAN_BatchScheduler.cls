/**
    Description : This batch Apex class validate that Morrison is MOP one day before every appointment. 
                  At 6pm the day before all existing appointments where an MPAN exists, we require to call J.20 to return the validation data 
                  populating the relevant fields in the Appointment record. Morrison is no more MOP for an MPAN we need to cancel that Activity in Oracle.
                  
                  We will have to consider one reord at a time only.
                  
    VF Page     : None
    Test Class  : EON_JUMBO_Validate_MPAN_BatchScheduler_Test

**/
/*
    Created By  : Mehboob Alam
    Created On  : 20/04/2016
    Service Req : SR_EON_Jumbo_025
    Change History
    CH01 : SR_EON_AB_130 # 30-08-2016 # Sivasankar K # Amending the logic for as part of spec doc of  SR_EON_AB_130.
    This will fetch the all EON Appointemnts and follows the spec process.
    CH02 # SR_EON_AB_155 # 03/10/2016 # Mahadev J # Updated logic to respect effective dates when job is duel fuel.
    CH03 # SR_EON_Jumbo_095 # 26/12/2016 # Shruti Moghe #amended class to pick only appointments with SCHEDULED or ASSIGNED status value
    CH04 # SR_EON_Jumbo_104 # 10/02/2017 # Puneet Mehta # Original values of Planned E/G Meter Type retained.
    CH05 # SR_EON_Jumbo_109 # 10/02/2017 # Akshay Bairagi # cancel the appointment if effective to and from dates are null.
    CH06 # SR_EON_Jumbo_113 # 10/02/2017 # Akshay Bairagi # Changed the cancellation reason for Night jobs
    CH07 # SR_EON_Jumbo_115 # 23/05/2017 # Praveen G # Mapped the model ID field.
    CH08 # SR_OptiMUS_EON_110 # 07/09/2017 # Praveen G # Added new filter in the query.
	CH09 # SR_OptiMUS_EON_297 # 11/02/2019 # Tabish Almas # Added logic to get data from MDS or Jumbo based on MDS Jumbo Dataflow Switch
*/
global class EON_JUMBO_Validate_MPAN_BatchScheduler implements Database.batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
      
 global List<EON_appointment__c> upEonApp;

/** 
    Database.queryLocator start(Database.BatchableContext BC) - start method
**/
    global Database.queryLocator start(Database.BatchableContext BC){
        List<String> Status = new List<String>{'SCHEDULED','ASSIGNED'};
        return Database.getQueryLocator([select Planned_E_Meter_Type__c ,Planned_G_Meter_Type__c,id,Name,Booking_System_Name__c,Fuel_ID__r.Gas_Meter_Mechanism__r.Code__c,Fuel_ID__c,Fuel_ID__r.Fuel_Type__c,Fuel_ID__r.id,Fuel_ID__r.MPRN__c,Fuel_ID__r.Gas_meter_serial_number__c,Fuel_ID__r.Gas_model_A0083__c,Fuel_ID__r.Gas_manufacturer_code_A0060__c,Fuel_ID__r.Gas_measuring_capacity_A0112__c,Fuel_ID__r.Gas_number_of_dials_or_digits_A0121__c,Fuel_ID__r.Gas_meter_type_A0025__c,Fuel_ID__r.Gas_Meter_Mechanism__c,Fuel_ID__r.Gas_payment_method_A0163__c,Fuel_ID__r.Premise__r.Sub_Building_Name__c,Fuel_ID__r.Premise__r.Building_Name__c,Fuel_ID__r.Premise__r.Dependant_Thorofare__c,Fuel_ID__r.Premise__r.Thorofare__c,Fuel_ID__r.Premise__r.Dependant_Locality__c,Fuel_ID__r.Premise__r.Double_Dependant_Locality__c,Fuel_ID__r.Premise__r.Town__c,Fuel_ID__r.Premise__r.Postcode__c,Fuel_ID__r.Premise__r.Customer__r.Customer_Name__c,Fuel_ID__r.MPAN__c,Fuel_ID__r.Gas_supplier_code__c,Job_Code__c,Job_Code__r.Name,Job_Code__r.Job_type__c,appointment_Date__c,MPAN__c,MPRN__c,Sent_to_Oracle__c,(SELECT Id,Name,EON_Appointment_ID__c,Job_Attribute__c,Value__c,SME_Duration__c FROM EON_Appointment_Attributes__r) from EON_appointment__c
         where 
         Status__c IN:Status and appointment_Date__c = tomorrow AND Sent_to_Oracle__c = true
         AND Multiple_Meters_at_Site__c = false //CH08
         //and id='a0A3E000001CeelUAC'
         ]);//MPAN__c <> null and //CH03//CH04

    }


/** 
    execute(Database.BatchableContext BC, List<TWM_Tasks__c> scope) - Main execute method
**/
    global void execute(Database.BatchableContext BC, List<EON_appointment__c> scope){
        List<JUMBO_Data_Tracker__c> pTracker = new List<JUMBO_Data_Tracker__c>();
		List<MDS_Data_Tracker__c> mTracker = new List<MDS_Data_Tracker__c>();
        upEonApp = new List<EON_appointment__c>(); //CH05
        Oracle_Data_Tracker__c cTracker= new Oracle_Data_Tracker__c();
        EON_appointment__c updateAppointment = new EON_appointment__c();//CH01
        String eMeterType = '',gMeterType = '', ePhase = '',updateResponse = '';//CH01
        Date mopEffFrom, mopEffTo, mamEffFrom, mamEffTo, effectiveFrom, effectiveTo; //Ch02
        String originalEmeterType = '', originalGmeterType = '';//CH04
        String switchData = EON_MDS_Utility.getMDS_Jumbo_Status();	//CH09
		
		if(switchData == system.label.Jumbo_Shortform) {
			for(EON_appointment__c eApp: scope){
				originalEmeterType = eApp.Planned_E_Meter_Type__c;//CH04
				originalGmeterType = eApp.Planned_G_Meter_Type__c;//CH04
				EON_OFSC_Update_Appointment.getAppointment(eApp.name);//CH01
				updateAppointment =  EON_OFSC_Update_Appointment.objAppt1;
				string cnclRes = '';
				Boolean cancelActivity=false;
				//Validating MOP for MPAN Value
				system.debug('--->in-->');
				EON_Jumbo_ReqElectricityMOP.MOPValidationResponse MOPResp = new EON_Jumbo_ReqElectricityMOP.MOPValidationResponse();//CH01
				if (eApp.MPAN__c != null ) {//CH01
					MOPResp =  EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP(eApp.MPAN__c);
					system.debug('--->in1-->'+MOPResp);
					if(MOPResp.Error.contains('The specified MPAN has no current or future appointments') && MOPResp.effFromDate == null && MOPResp.effToDate == null)//CH05
					cancelActivity = true;
					if(!MOPResp.isError){
						//CH02.New.Start
						system.debug('--->in2-->'); 
						if(!EON_Utility.validateRequired(MOPResp.effFromDate))
						mopEffFrom = MOPResp.effFromDate;
						if(!EON_Utility.validateRequired(MOPResp.effToDate))
						mopEffTo = MOPResp.effToDate;
						//CH02.New.End
						system.debug('--->in-->'+cancelActivity);   
						if(EON_Utility.validateRequired(eApp.MPRN__c)) //CH02.New
						if(!EON_Utility.validateRequired(MOPResp.effToDate) && !EON_Utility.validateRequired(MOPResp.effFromDate))
						if((MOPResp.effFromDate>eApp.appointment_Date__c || MOPResp.effToDate <eApp.appointment_Date__c)) 
						cancelActivity = true;
						
					}
					else if(MOPResp.Error.EqualsIgnoreCase('No Related supplier record Found'))
					cancelActivity = true;
				}
				if(EON_JUMBO_Schedulable_Validating_Test.genException) cancelActivity = true; 

				//Cancel the Activity if flag is true means we are no more MOP for this MPAN.       
				if(cancelActivity && eApp.Sent_to_Oracle__c){//CH01
					//Calling Web Service to cancel this Appointment in OFSC
					cnclRes = EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(eApp.id);
					if(cnclRes.equalsIgnoreCase('Activity cancelled in OFSC successfully') || Test.isrunningTest()){    
						eApp.Cancel_Reason__c = [Select ID from EON_Appointment_Cancel_Reason__c where Reason_key__c =: system.label.EON_Jumbo_CancelationReason_Night].ID; //CH06
						eApp.Status__c = EON_Utility.STATUS_CANCELLED;
						eApp.Cancellation_DateTime__c = datetime.now();
						if(!EON_Utility.validateRequired(MOPResp.effFromDate))
						eApp.Effective_From_Date__c =  MOPResp.effFromDate;  
						if(!EON_Utility.validateRequired(MOPResp.effToDate))
						eApp.Effective_To_Date__c=MOPResp.effToDate;   
						if(!EON_Utility.validateRequired(MOPResp.marParticipantId)) 
						eApp.Market_Participant_ID__c = MOPResp.marParticipantId;                                                        
					} 
					if(Test.isRunningTest())
					eApp.Confirmed_Appointment_DateTime__c = null;
					upEonApp.add(eApp);
					if (!EON_Utility.validateRequired(EON_Jumbo_ReqElectricityMOP.cTrack)){
						EON_Jumbo_ReqElectricityMOP.cTrack.EON_Appointment__c = eApp.Id;
						pTracker.add(EON_Jumbo_ReqElectricityMOP.cTrack);
					}
					if(!EON_Utility.validateRequired(EON_Cancel_Activity_OFSC.requestOut)){
						cTracker =EON_Cancel_Activity_OFSC.requestOut; 
						cTracker.EON_Appointment__c = eApp.id;
					}
					if(!upEonApp.isEmpty()) //Updating Appointments
					update upEonApp;
				}
				//CH01.Start
				if (!cancelActivity){
					for (EON_Appointment_Attribute__c eAppAtt : eApp.EON_Appointment_Attributes__r){
						if ( !EON_Utility.validateRequired(eAppAtt.Job_Attribute__c) && !EON_Utility.validateRequired(eAppAtt.Value__c) ) { 
							if (eAppAtt.Job_Attribute__c.equalsIgnoreCase('ELECMETERTYPE')) { eMeterType = eAppAtt.Value__c; }
							else if (eAppAtt.Job_Attribute__c.equalsIgnoreCase('PHASE')) { ePhase = eAppAtt.Value__c; } 
							else if (eAppAtt.Job_Attribute__c.equalsIgnoreCase('GASMETERTYPE')) { gMeterType = eAppAtt.Value__c; }
						} 
					}
					
					if ( !EON_Utility.validateRequired(eApp.MPAN__c) ){
						//Calling J18 - Electric Data
						EON_Jumbo_ReqElecMeterPointData.AccessElecMeterPointData(eApp.MPAN__c,updateAppointment,'', '');
						if(!EON_Jumbo_ReqElecMeterPointData.isError){
							updateAppointment = EON_Jumbo_ReqElecMeterPointData.apptIns;
							//if the record is SMART JOB
							updateAppointment.Planned_E_Meter_Type__c = ((String.isNotBlank(eMeterType)) ? eMeterType : updateAppointment.Planned_E_Meter_Type__c);
							if( String.isBlank(eMeterType) && !EON_Utility.validateRequired(eApp.Job_Code__r.Name) && (eApp.Job_Code__r.Name == 'OOASMARTELECEXCH' || eApp.Job_Code__r.Name == 'OOASMARTDFEXCH' || eApp.Job_Code__r.Name == 'OOASMARTELECINST' || eApp.Job_Code__r.Name == 'OOASMARTDFINST' || eApp.Job_Code__r.Name == 'OOASMARTGASINST') && eApp.Job_Code__r.Job_Type__c == 'Smart')
							updateAppointment.Planned_E_Meter_Type__c='MS1';
							
							//if Phase is populated from EON and it is not unchanged.
							if (String.isNotBlank(ePhase) && !ePhase.equalsIgnoreCase('unchanged')) {    
								if(ePhase.equalsIgnoreCase('3PH')) { updateAppointment.Number_of_Phases__c = '3Ph'; }
								if(ePhase.equalsIgnoreCase('1PH')) { updateAppointment.Number_of_Phases__c = '1Ph'; }  
							}    
						}
						if (!EON_Utility.validateRequired(EON_Jumbo_ReqElecMeterPointData.cTrack)){
							EON_Jumbo_ReqElecMeterPointData.cTrack.EON_Appointment__c = eApp.Id;
							pTracker.add(EON_Jumbo_ReqElecMeterPointData.cTrack);
						}
					}
					
					if ( !EON_Utility.validateRequired(eApp.MPRN__c) ){
						Boolean NotMAM = false;
						//Calling J21 for MAM check
						EON_Jumbo_ReqGasMAM.MAMValidationResponse wrpp = new EON_Jumbo_ReqGasMAM.MAMValidationResponse();
						wrpp = EON_Jumbo_ReqGasMAM.ValidateMPRNMAM(eApp.MPRN__c);
						if (!EON_Utility.validateRequired(EON_Jumbo_ReqGasMAM.cTrack)){
							EON_Jumbo_ReqGasMAM.cTrack.EON_Appointment__c = eApp.Id;
							pTracker.add(EON_Jumbo_ReqGasMAM.cTrack);
						}
						if(EON_JUMBO_Schedulable_Validating_Test.genExceptionforGas){wrpp.isError =false; wrpp.effFromDate=System.today(); }    
						if(!wrpp.isError){
							//CH02.New.Start
							if(!EON_Utility.validateRequired(wrpp.effFromDate)){
								mamEffFrom = wrpp.effFromDate;
								effectiveFrom = mamEffFrom;
								if(!EON_Utility.validateRequired(mopEffFrom))
								effectiveFrom = mopEffFrom > mamEffFrom ? mopEffFrom : mamEffFrom;
							}
							if(!EON_Utility.validateRequired(wrpp.effToDate)){
								mamEffTo = wrpp.effToDate;
								effectiveTo = mamEffTo;                            
								if(!EON_Utility.validateRequired(mopEffTo))
								effectiveTo = mopEffTo < mamEffTo ? mopEffTo : mamEffFrom;
							}
							//CH02.New.End
							if(wrpp.effFromDate != null )//&& wrpp.effToDate != null//
							{                                    
								//if((updateAppointment.Appointment_Date__c >= wrpp.effFromDate) && (wrpp.effToDate==null || updateAppointment.Appointment_Date__c <= wrpp.effToDate)){//CH02.Old
								if((updateAppointment.Appointment_Date__c >= effectiveFrom) && (effectiveTo==null || updateAppointment.Appointment_Date__c <= effectiveTo)){//CH02.New
									//If Appt Date decides whether MAM or Not
									//Calling J19 and get Gas data
									EON_Jumbo_ReqGasMeterPointData.AccessGasMeterPointData(eApp.MPRN__c,updateAppointment,'','');
									if(!EON_Jumbo_ReqGasMeterPointData.isError){
										updateAppointment = EON_Jumbo_ReqGasMeterPointData.apptIns;
										updateAppointment.G_Effective_From_Date__c = wrpp.effFromDate;
										updateAppointment.G_Effective_To_Date__c = wrpp.effToDate;
										updateAppointment.Planned_G_Meter_Type__c = ((String.isNotBlank(gMeterType)) ? gMeterType : updateAppointment.Planned_G_Meter_Type__c);
										system.debug('####gMeterType: '+gMeterType);
										system.debug('####eApp.Job_Code__r.Job_Type__c: '+eApp.Job_Code__r.Job_Type__c);
										system.debug('####eApp.Job_Code__r.Name: '+eApp.Job_Code__r.Name);
										if( String.isBlank(gMeterType) && !EON_Utility.validateRequired(eApp.Job_Code__r.Name) && eApp.Job_Code__r.Job_Type__c == 'Smart' && ( eApp.Job_Code__r.Name == 'OOASMARTELECEXCH' || eApp.Job_Code__r.Name == 'OOASMARTDFEXCH' || eApp.Job_Code__r.Name == 'OOASMARTELECINST' || eApp.Job_Code__r.Name == 'OOASMARTDFINST' || eApp.Job_Code__r.Name == 'OOASMARTGASINST'))
										updateAppointment.Planned_G_Meter_Type__c='MS1';
									}
									if (!EON_Utility.validateRequired(EON_Jumbo_ReqGasMeterPointData.cTrack)){
										EON_Jumbo_ReqGasMeterPointData.cTrack.EON_Appointment__c = eApp.Id;
										pTracker.add(EON_Jumbo_ReqGasMeterPointData.cTrack);
									}
								}else{
									NotMAM = true;
								}
							} else { NotMAM = true; }                              
						}else { NotMAM = true; }
						System.debug('eApp.Fuel_ID__c = '+eApp.Fuel_ID__c+',eApp.MPRN = '+eApp.MPRN__c+',eApp.MPAN = '+eApp.MPAN__c);
						if ( NotMAM && eApp.Fuel_ID__c != null ){
							updateAppointment.Fuel_ID__c = eApp.Fuel_ID__r.id;
							updateAppointment.MPRN__c = eApp.Fuel_ID__r.MPRN__c;
							updateAppointment.G_Meter_Serial_Number__c = eApp.Fuel_ID__r.Gas_meter_serial_number__c;
							
							//updateAppointment.G_Meter_Model__c = eApp.Fuel_ID__r.Gas_model_A0083__c; CH07.OLD
							
							//CH07.Start.New
							Map<String, EON_Model_ID_to_Model_Name_Mapping__c> mapModelIdName = 
							EON_Model_ID_to_Model_Name_Mapping__c.getAll();
							if(!mapModelIdName.isEmpty()){
								if(eApp.Fuel_ID__r.Gas_model_A0083__c != null && 
										mapModelIdName.get(eApp.Fuel_ID__r.Gas_model_A0083__c) != null)
								updateAppointment.G_Meter_Model__c =  
								mapModelIdName.get(eApp.Fuel_ID__r.Gas_model_A0083__c).Model_Name__c;   
							}                                        
							//CH07.End.New
							
							
							updateAppointment.G_Meter_Make__c = eApp.Fuel_ID__r.Gas_manufacturer_code_A0060__c;
							updateAppointment.G_Meter_Measuring_Capacity__c = string.valueof(eApp.Fuel_ID__r.Gas_measuring_capacity_A0112__c);
							updateAppointment.Number_of_Dials_or_Digits__c = eApp.Fuel_ID__r.Gas_number_of_dials_or_digits_A0121__c;
							updateAppointment.G_Meter_Type__c = eApp.Fuel_ID__r.Gas_meter_type_A0025__c;
							updateAppointment.G_Meter_Mechanism__c = eApp.Fuel_ID__r.Gas_Meter_Mechanism__c;
							updateAppointment.Payment_Method_code__c = eApp.Fuel_ID__r.Gas_payment_method_A0163__c;
							updateAppointment.Sub_Building_Name__c = eApp.Fuel_ID__r.Premise__r.Sub_Building_Name__c;
							updateAppointment.Building_Name__c = eApp.Fuel_ID__r.Premise__r.Building_Name__c;
							updateAppointment.Dependent_Thorofare__c = eApp.Fuel_ID__r.Premise__r.Dependant_Thorofare__c;
							updateAppointment.Thorofare__c = eApp.Fuel_ID__r.Premise__r.Thorofare__c;
							updateAppointment.Dependant_Locality__c = eApp.Fuel_ID__r.Premise__r.Dependant_Locality__c;
							updateAppointment.Double_dependant_Locality__c = eApp.Fuel_ID__r.Premise__r.Double_Dependant_Locality__c;
							updateAppointment.Post_Town__c = eApp.Fuel_ID__r.Premise__r.Town__c;
							updateAppointment.Post_Code__c = eApp.Fuel_ID__r.Premise__r.Postcode__c;
							updateAppointment.Person_Name__c = eApp.Fuel_ID__r.Premise__r.Customer__r.Customer_Name__c;
							updateAppointment.MPAN__c = eApp.Fuel_ID__r.MPAN__c;
							updateAppointment.Supplier_Name__c = eApp.Fuel_ID__r.Gas_supplier_code__c;
							updateAppointment.Metering_Pressure__c = 'Low';
							if( eApp.Fuel_ID__r.Gas_Meter_Mechanism__r.Code__c != null ){
								updateAppointment.Planned_G_Meter_Type__c =(( EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll() != null && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(eApp.Fuel_ID__r.Gas_Meter_Mechanism__r.Code__c.toUpperCase()) ) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(eApp.Fuel_ID__r.Gas_Meter_Mechanism__r.Code__c.toUpperCase()).Planned_Meter_Type__c : eApp.Fuel_ID__r.Gas_Meter_Mechanism__r.Code__c);
							}
							updateAppointment.Planned_G_Meter_Type__c = ((String.isNotBlank(gMeterType)) ? gMeterType : updateAppointment.Planned_G_Meter_Type__c);
							if( String.isBlank(gMeterType) && !EON_Utility.validateRequired(eApp.Job_Code__r.Name) && eApp.Job_Code__r.Job_Type__c == 'Smart' && ( eApp.Job_Code__r.Name == 'OOASMARTELECEXCH' || eApp.Job_Code__r.Name == 'OOASMARTDFEXCH' || eApp.Job_Code__r.Name == 'OOASMARTELECINST' || eApp.Job_Code__r.Name == 'OOASMARTDFINST' || eApp.Job_Code__r.Name == 'OOASMARTGASINST'))
							updateAppointment.Planned_G_Meter_Type__c='MS1';
						}
					}
					updateResponse = EON_OFSC_Update_Appointment.sendActivityToOFSC(updateAppointment,new List<EON_Appointment_Contact__c>(),new List<EON_Appointment_Vulnerability__c>(),(String.isNotBlank(eApp.Booking_System_Name__c) ? eApp.Booking_System_Name__c:'MUS'));
					cTracker = EON_OFSC_Update_Appointment.requestOut;
					if ( String.isNotBlank(updateResponse) && updateResponse.containsIgnoreCase('Job sent to OFSC successfully') ){
						updateAppointment = EON_OFSC_Update_Appointment.objAppt;
						updateAppointment.Planned_E_Meter_Type__c = originalEmeterType; //CH04
						updateAppointment.Planned_G_Meter_Type__c = originalGmeterType; //CH04
						if(!Test.isrunningTest()) Update updateAppointment;
					}
				}
				//CH01.End
			}
		}
		else if(switchData == system.label.MDS_Shortform) {
			for(EON_appointment__c eApp: scope){
				originalEmeterType = eApp.Planned_E_Meter_Type__c;//CH04
				originalGmeterType = eApp.Planned_G_Meter_Type__c;//CH04
				EON_OFSC_Update_Appointment.getAppointment(eApp.name);//CH01
				updateAppointment =  EON_OFSC_Update_Appointment.objAppt1;
				string cnclRes = '';
				Boolean cancelActivity=false;
				//Validating MOP for MPAN Value
				system.debug('--->in-->');
				EON_MDS_ReqElectricityMOP.MOPValidationResponse MOPResp = new EON_MDS_ReqElectricityMOP.MOPValidationResponse();
				if (eApp.MPAN__c != null ) {//CH01
					MOPResp =  EON_MDS_ReqElectricityMOP.ValidateMPANMOP(eApp.MPAN__c);
					system.debug('--->in1-->'+MOPResp);
					if(MOPResp.Error.contains('The specified MPAN has no current or future appointments') && MOPResp.effFromDate == null && MOPResp.effToDate == null)//CH05
					cancelActivity = true;
					if(!MOPResp.isError){
						//CH02.New.Start
						system.debug('--->in2-->'); 
						if(!EON_Utility.validateRequired(MOPResp.effFromDate))
						mopEffFrom = MOPResp.effFromDate;
						if(!EON_Utility.validateRequired(MOPResp.effToDate))
						mopEffTo = MOPResp.effToDate;
						//CH02.New.End
						system.debug('--->in-->'+cancelActivity);   
						if(EON_Utility.validateRequired(eApp.MPRN__c)) //CH02.New
						if(!EON_Utility.validateRequired(MOPResp.effToDate) && !EON_Utility.validateRequired(MOPResp.effFromDate))
						if((MOPResp.effFromDate>eApp.appointment_Date__c || MOPResp.effToDate <eApp.appointment_Date__c)) 
						cancelActivity = true;
						
					}
					else if(MOPResp.Error.EqualsIgnoreCase('No Related supplier record Found'))
					cancelActivity = true;
				}
				if(EON_JUMBO_Schedulable_Validating_Test.genException) cancelActivity = true; 

				//Cancel the Activity if flag is true means we are no more MOP for this MPAN.       
				if(cancelActivity && eApp.Sent_to_Oracle__c){//CH01
					//Calling Web Service to cancel this Appointment in OFSC
					cnclRes = EON_Cancel_Activity_OFSC.cancelActivitiesInOFSC(eApp.id);
					if(cnclRes.equalsIgnoreCase('Activity cancelled in OFSC successfully') || Test.isrunningTest()){    
						eApp.Cancel_Reason__c = [Select ID from EON_Appointment_Cancel_Reason__c where Reason_key__c =: system.label.EON_Jumbo_CancelationReason_Night].ID; //CH06
						eApp.Status__c = EON_Utility.STATUS_CANCELLED;
						eApp.Cancellation_DateTime__c = datetime.now();
						if(!EON_Utility.validateRequired(MOPResp.effFromDate))
						eApp.Effective_From_Date__c =  MOPResp.effFromDate;  
						if(!EON_Utility.validateRequired(MOPResp.effToDate))
						eApp.Effective_To_Date__c=MOPResp.effToDate;   
						if(!EON_Utility.validateRequired(MOPResp.marParticipantId)) 
						eApp.Market_Participant_ID__c = MOPResp.marParticipantId;                                                        
					} 
					if(Test.isRunningTest())
					eApp.Confirmed_Appointment_DateTime__c = null;
					upEonApp.add(eApp);
					if (!EON_Utility.validateRequired(EON_MDS_ReqElectricityMOP.cTrack)){
						EON_MDS_ReqElectricityMOP.cTrack.EON_Appointment__c = eApp.Id;
						mTracker.add(EON_MDS_ReqElectricityMOP.cTrack);
					}
					if(!EON_Utility.validateRequired(EON_Cancel_Activity_OFSC.requestOut)){
						cTracker =EON_Cancel_Activity_OFSC.requestOut; 
						cTracker.EON_Appointment__c = eApp.id;
					}
					if(!upEonApp.isEmpty()) //Updating Appointments
					update upEonApp;
				}
				//CH01.Start
				if (!cancelActivity){
					for (EON_Appointment_Attribute__c eAppAtt : eApp.EON_Appointment_Attributes__r){
						if ( !EON_Utility.validateRequired(eAppAtt.Job_Attribute__c) && !EON_Utility.validateRequired(eAppAtt.Value__c) ) { 
							if (eAppAtt.Job_Attribute__c.equalsIgnoreCase('ELECMETERTYPE')) { eMeterType = eAppAtt.Value__c; }
							else if (eAppAtt.Job_Attribute__c.equalsIgnoreCase('PHASE')) { ePhase = eAppAtt.Value__c; } 
							else if (eAppAtt.Job_Attribute__c.equalsIgnoreCase('GASMETERTYPE')) { gMeterType = eAppAtt.Value__c; }
						} 
					}
					
					if ( !EON_Utility.validateRequired(eApp.MPAN__c) ){
						//Calling J18 - Electric Data
						EON_MDS_ReqElecMeterPointData.AccessElecMeterPointData(eApp.MPAN__c,updateAppointment,'', '');
						if(!EON_MDS_ReqElecMeterPointData.isError){
							updateAppointment = EON_MDS_ReqElecMeterPointData.apptIns;
							//if the record is SMART JOB
							updateAppointment.Planned_E_Meter_Type__c = ((String.isNotBlank(eMeterType)) ? eMeterType : updateAppointment.Planned_E_Meter_Type__c);
							if( String.isBlank(eMeterType) && !EON_Utility.validateRequired(eApp.Job_Code__r.Name) && (eApp.Job_Code__r.Name == 'OOASMARTELECEXCH' || eApp.Job_Code__r.Name == 'OOASMARTDFEXCH' || eApp.Job_Code__r.Name == 'OOASMARTELECINST' || eApp.Job_Code__r.Name == 'OOASMARTDFINST' || eApp.Job_Code__r.Name == 'OOASMARTGASINST') && eApp.Job_Code__r.Job_Type__c == 'Smart')
							updateAppointment.Planned_E_Meter_Type__c='MS1';
							
							//if Phase is populated from EON and it is not unchanged.
							if (String.isNotBlank(ePhase) && !ePhase.equalsIgnoreCase('unchanged')) {    
								if(ePhase.equalsIgnoreCase('3PH')) { updateAppointment.Number_of_Phases__c = '3Ph'; }
								if(ePhase.equalsIgnoreCase('1PH')) { updateAppointment.Number_of_Phases__c = '1Ph'; }  
							}    
						}
						if (!EON_Utility.validateRequired(EON_MDS_ReqElecMeterPointData.cTrack)){
							EON_MDS_ReqElecMeterPointData.cTrack.EON_Appointment__c = eApp.Id;
							mTracker.add(EON_MDS_ReqElecMeterPointData.cTrack);
						}
					}
					
					if ( !EON_Utility.validateRequired(eApp.MPRN__c) ){
						Boolean NotMAM = false;
						//Calling J21 for MAM check
						EON_MDS_ReqGasMAM.MAMValidationResponse wrpp = new EON_MDS_ReqGasMAM.MAMValidationResponse();
						wrpp = EON_MDS_ReqGasMAM.ValidateMPRNMAM(eApp.MPRN__c);
						if (!EON_Utility.validateRequired(EON_MDS_ReqGasMAM.cTrack)){
							EON_MDS_ReqGasMAM.cTrack.EON_Appointment__c = eApp.Id;
							mTracker.add(EON_MDS_ReqGasMAM.cTrack);
						}
						if(EON_JUMBO_Schedulable_Validating_Test.genExceptionforGas){wrpp.isError =false; wrpp.effFromDate=System.today(); }    
						if(!wrpp.isError){
							//CH02.New.Start
							if(!EON_Utility.validateRequired(wrpp.effFromDate)){
								mamEffFrom = wrpp.effFromDate;
								effectiveFrom = mamEffFrom;
								if(!EON_Utility.validateRequired(mopEffFrom))
								effectiveFrom = mopEffFrom > mamEffFrom ? mopEffFrom : mamEffFrom;
							}
							if(!EON_Utility.validateRequired(wrpp.effToDate)){
								mamEffTo = wrpp.effToDate;
								effectiveTo = mamEffTo;                            
								if(!EON_Utility.validateRequired(mopEffTo))
								effectiveTo = mopEffTo < mamEffTo ? mopEffTo : mamEffFrom;
							}
							//CH02.New.End
							if(wrpp.effFromDate != null )//&& wrpp.effToDate != null//
							{                                    
								//if((updateAppointment.Appointment_Date__c >= wrpp.effFromDate) && (wrpp.effToDate==null || updateAppointment.Appointment_Date__c <= wrpp.effToDate)){//CH02.Old
								if((updateAppointment.Appointment_Date__c >= effectiveFrom) && (effectiveTo==null || updateAppointment.Appointment_Date__c <= effectiveTo)){//CH02.New
									//If Appt Date decides whether MAM or Not
									//Calling J19 and get Gas data
									EON_MDS_ReqGasMeterPointData.AccessGasMeterPointData(eApp.MPRN__c,updateAppointment,'','');
									if(!EON_MDS_ReqGasMeterPointData.isError){
										updateAppointment = EON_MDS_ReqGasMeterPointData.apptIns;
										updateAppointment.G_Effective_From_Date__c = wrpp.effFromDate;
										updateAppointment.G_Effective_To_Date__c = wrpp.effToDate;
										updateAppointment.Planned_G_Meter_Type__c = ((String.isNotBlank(gMeterType)) ? gMeterType : updateAppointment.Planned_G_Meter_Type__c);
										system.debug('####gMeterType: '+gMeterType);
										system.debug('####eApp.Job_Code__r.Job_Type__c: '+eApp.Job_Code__r.Job_Type__c);
										system.debug('####eApp.Job_Code__r.Name: '+eApp.Job_Code__r.Name);
										if( String.isBlank(gMeterType) && !EON_Utility.validateRequired(eApp.Job_Code__r.Name) && eApp.Job_Code__r.Job_Type__c == 'Smart' && ( eApp.Job_Code__r.Name == 'OOASMARTELECEXCH' || eApp.Job_Code__r.Name == 'OOASMARTDFEXCH' || eApp.Job_Code__r.Name == 'OOASMARTELECINST' || eApp.Job_Code__r.Name == 'OOASMARTDFINST' || eApp.Job_Code__r.Name == 'OOASMARTGASINST'))
										updateAppointment.Planned_G_Meter_Type__c='MS1';
									}
									if (!EON_Utility.validateRequired(EON_MDS_ReqGasMeterPointData.cTrack)){
										EON_MDS_ReqGasMeterPointData.cTrack.EON_Appointment__c = eApp.Id;
										mTracker.add(EON_MDS_ReqGasMeterPointData.cTrack);
									}
								}else{
									NotMAM = true;
								}
							} else { NotMAM = true; }                              
						}else { NotMAM = true; }
						System.debug('eApp.Fuel_ID__c = '+eApp.Fuel_ID__c+',eApp.MPRN = '+eApp.MPRN__c+',eApp.MPAN = '+eApp.MPAN__c);
						if ( NotMAM && eApp.Fuel_ID__c != null ){
							updateAppointment.Fuel_ID__c = eApp.Fuel_ID__r.id;
							updateAppointment.MPRN__c = eApp.Fuel_ID__r.MPRN__c;
							updateAppointment.G_Meter_Serial_Number__c = eApp.Fuel_ID__r.Gas_meter_serial_number__c;
							
							//updateAppointment.G_Meter_Model__c = eApp.Fuel_ID__r.Gas_model_A0083__c; CH07.OLD
							
							//CH07.Start.New
							Map<String, EON_Model_ID_to_Model_Name_Mapping__c> mapModelIdName = 
							EON_Model_ID_to_Model_Name_Mapping__c.getAll();
							if(!mapModelIdName.isEmpty()){
								if(eApp.Fuel_ID__r.Gas_model_A0083__c != null && 
										mapModelIdName.get(eApp.Fuel_ID__r.Gas_model_A0083__c) != null)
								updateAppointment.G_Meter_Model__c =  
								mapModelIdName.get(eApp.Fuel_ID__r.Gas_model_A0083__c).Model_Name__c;   
							}                                        
							//CH07.End.New
							
							
							updateAppointment.G_Meter_Make__c = eApp.Fuel_ID__r.Gas_manufacturer_code_A0060__c;
							updateAppointment.G_Meter_Measuring_Capacity__c = string.valueof(eApp.Fuel_ID__r.Gas_measuring_capacity_A0112__c);
							updateAppointment.Number_of_Dials_or_Digits__c = eApp.Fuel_ID__r.Gas_number_of_dials_or_digits_A0121__c;
							updateAppointment.G_Meter_Type__c = eApp.Fuel_ID__r.Gas_meter_type_A0025__c;
							updateAppointment.G_Meter_Mechanism__c = eApp.Fuel_ID__r.Gas_Meter_Mechanism__c;
							updateAppointment.Payment_Method_code__c = eApp.Fuel_ID__r.Gas_payment_method_A0163__c;
							updateAppointment.Sub_Building_Name__c = eApp.Fuel_ID__r.Premise__r.Sub_Building_Name__c;
							updateAppointment.Building_Name__c = eApp.Fuel_ID__r.Premise__r.Building_Name__c;
							updateAppointment.Dependent_Thorofare__c = eApp.Fuel_ID__r.Premise__r.Dependant_Thorofare__c;
							updateAppointment.Thorofare__c = eApp.Fuel_ID__r.Premise__r.Thorofare__c;
							updateAppointment.Dependant_Locality__c = eApp.Fuel_ID__r.Premise__r.Dependant_Locality__c;
							updateAppointment.Double_dependant_Locality__c = eApp.Fuel_ID__r.Premise__r.Double_Dependant_Locality__c;
							updateAppointment.Post_Town__c = eApp.Fuel_ID__r.Premise__r.Town__c;
							updateAppointment.Post_Code__c = eApp.Fuel_ID__r.Premise__r.Postcode__c;
							updateAppointment.Person_Name__c = eApp.Fuel_ID__r.Premise__r.Customer__r.Customer_Name__c;
							updateAppointment.MPAN__c = eApp.Fuel_ID__r.MPAN__c;
							updateAppointment.Supplier_Name__c = eApp.Fuel_ID__r.Gas_supplier_code__c;
							updateAppointment.Metering_Pressure__c = 'Low';
							if( eApp.Fuel_ID__r.Gas_Meter_Mechanism__r.Code__c != null ){
								updateAppointment.Planned_G_Meter_Type__c =(( EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll() != null && EON_Jumbo_E_G_Meter_Types_Mappings__c.getAll().containsKey(eApp.Fuel_ID__r.Gas_Meter_Mechanism__r.Code__c.toUpperCase()) ) ? EON_Jumbo_E_G_Meter_Types_Mappings__c.getInstance(eApp.Fuel_ID__r.Gas_Meter_Mechanism__r.Code__c.toUpperCase()).Planned_Meter_Type__c : eApp.Fuel_ID__r.Gas_Meter_Mechanism__r.Code__c);
							}
							updateAppointment.Planned_G_Meter_Type__c = ((String.isNotBlank(gMeterType)) ? gMeterType : updateAppointment.Planned_G_Meter_Type__c);
							if( String.isBlank(gMeterType) && !EON_Utility.validateRequired(eApp.Job_Code__r.Name) && eApp.Job_Code__r.Job_Type__c == 'Smart' && ( eApp.Job_Code__r.Name == 'OOASMARTELECEXCH' || eApp.Job_Code__r.Name == 'OOASMARTDFEXCH' || eApp.Job_Code__r.Name == 'OOASMARTELECINST' || eApp.Job_Code__r.Name == 'OOASMARTDFINST' || eApp.Job_Code__r.Name == 'OOASMARTGASINST'))
							updateAppointment.Planned_G_Meter_Type__c='MS1';
						}
					}
					updateResponse = EON_OFSC_Update_Appointment.sendActivityToOFSC(updateAppointment,new List<EON_Appointment_Contact__c>(),new List<EON_Appointment_Vulnerability__c>(),(String.isNotBlank(eApp.Booking_System_Name__c) ? eApp.Booking_System_Name__c:'MUS'));
					cTracker = EON_OFSC_Update_Appointment.requestOut;
					if ( String.isNotBlank(updateResponse) && updateResponse.containsIgnoreCase('Job sent to OFSC successfully') ){
						updateAppointment = EON_OFSC_Update_Appointment.objAppt;
						updateAppointment.Planned_E_Meter_Type__c = originalEmeterType; //CH04
						updateAppointment.Planned_G_Meter_Type__c = originalGmeterType; //CH04
						if(!Test.isrunningTest()) Update updateAppointment;
					}
				}
				//CH01.End
			}
		}
		
        //Inserting parent tracker record 
        if(!pTracker.isEmpty()) {  
            insert pTracker;
            cTracker.JUMBO_Data_Tracker__c=pTracker[0].id;
        }
		//Inserting parent tracker record 
        if(!mTracker.isEmpty()) {  
            insert mTracker;
            cTracker.MDS_Data_Tracker__c=mTracker[0].id;
        }
        if(!EON_Utility.validateRequired(cTracker)){ //Updating child tracker record
             
             update cTracker;
        }
        
  }
  
/**
    finish(Database.BatchableContext BC) - finish method of the Batch
**/
    global void finish(Database.BatchableContext BC){
        /*try {
            
        }catch (Exception Ex) {
            system.debug('Batch exception occured-->'+Ex);
        }*/
        System.debug('Batch is Successfully executed');
    }
}