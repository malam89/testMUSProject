/**
    Description : This class is used to map the abort reason and abort reason category
    Test Class : EON_Job_Results_Trigger_Test
**/

/*
    Created By : Praveen G
    Created Date : 23-June-2016
    Service Request : SR_EON_Mobile_044
    Change History
    CH01 # SR_EON_Mobile_068 # 28/07/2016 # Mahadev # Abort Reson Code Updated for sequence number
    CH02 # SR_EON_Mobile_073 # 24/08/2016 # Mahadev # Abort Reson Code based on new mapping
    CH03 # SR_EON_Mobile_079 # 13/09/2016 # Praveen G # Added logic to make few fields value in upper case.
    CH04 # SR_EON_Mobile_076 # 15/09/2016 # Praveen G # Added logic to populate the New E Meter Register 2 ID
    CH05 # SR_EON_Mobile_077 # 20/09/2016 # Praveen G # Added logic to auto populate the On Time Indicator field 
    CH06 # SR_EON_Mobile_081 # 22/09/2016 # Praveen G # Added logic to auto populate the Late Reason field
    CH07 # SR_EON_AB_154 # 28/09/2016 # Puneet Mehta # Changed 'Key' to 'KEY'
    CH08 # SR_EON_Mobile_097 # 11/11/2016 # Praveen G # created new method for sub reason mapping.
    CH09 # SR_EON_Mobile_103 # 22/11/2016 # Praveen G # logic to populate the fields gas / Electricity 
                                                            Driver_for_reverting_type__c
    CH10 # SR_EON_Mobile_108 # 08/12/2016 # Praveen G # Added logic for time slots as ECO and Night. 
    CH11 # SR_OptiMUS_EON_032 # 23/01/2017 # Praveen G # Added logic to make fields empty.     
    CH12 # SM-3175 #28/02/2017 # Praveen G  
    CH13 # SR_OptiMUS_EON_074 #09/06/2017 # Praveen G # Update fields to add preceeding zeros.
    CH14 # INCUK0005837579 #28/06/2017 # Praveen G # Removed the unwanted spaces
    CH15 # SR_OptiMUS_EON_117 #10/10/2017 # Praveen G # Added Mapping for  New_E_Meter_Register_(n)_ID__c fields  
    CH16 # SR_OptiMUS_EON_132 #18/10/2017 # Praveen G # Added new mapping for abort reason and sub reason. 
    CH17 # SR_OptiMUS_EON_171 #04/12/2017 # Praveen G # Updating the Technician Mismatch field. 
    CH18 # SR_OptiMUS_EON_193 #19/12/2017 # Praveen G # update stock fields when comms serial number matches. 
    CH19 # SR_OptiMUS_EON_219 #06/02/2018 # Praveen G # revert the changes for SR_OptiMUS_EON_117
    CH20 # SR_OptiMUS_EON_222 #16/02/2018 # Mehboob Alam # Not Updating EON Stock Record for IHD if Original E Meter refitted = Yes and Original G Meter refitted = Yes. 
    CH21 # SR_OptiMUS_EON_215 #05/03/2018 # Mehboob # Added New mapping for S1 Register ID.   
    CH22 # SR_OptiMUS_EON_236 #16/04/2018 # Rangnath Agrahari # added functionality for adding the S2 exception emails  
    CH23 # SR_OptiMUS_EON_246 #16/05/2018 # Venkat P # Added filter on SOQL for to update only VAN records.     
*/

public with sharing class EON_Job_Results_Trigger_Helper{
    
    /**
        GETMAPABORTREASONCODE() - THIS METHOD RETRUNS THE ABORT REASON CODE BASED ON THE ABORT REASON AND CATEGORY.
    **/
    PUBLIC STATIC MAP<STRING, STRING> GETMAPABORTREASONCODE(){
        MAP<STRING, STRING> MAPABORTREASONWITHCODE = NEW MAP<STRING, STRING>();
        //CH01.UPDATE.START
        MAPABORTREASONWITHCODE.PUT('1. PRE-SITEPRE VISIT CUSTOMER REFUSAL','CUSTREFUSE');
        //MAPABORTREASONWITHCODE.PUT('1. PRE-SITESYSTEM OUTAGE - UNABLE TO SCHEME','002');//CH02.OLD
       //MAPABORTREASONWITHCODE.PUT('1. PRE-SITENO SIGNAL ON HHU UNABLE TO SEND SCHEME','003');//CH02.OLD
        MAPABORTREASONWITHCODE.PUT('1. PRE-SITESYSTEM OUTAGE - UNABLE TO SCHEME','002$');//CH02.NEW
        MAPABORTREASONWITHCODE.PUT('1. PRE-SITENO SIGNAL ON HHU UNABLE TO SEND SCHEME','003$');//CH02.NEW
        MAPABORTREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALNO ACCESS','SVCC20');
        MAPABORTREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALON SITE CUSTOMER REFUSAL','SVCC21');
        MAPABORTREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALPERSONAL SAFETY','PSAFE');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSCOMMUNAL LOCKS / ACCESS','EC$CLOCK');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSVULNERABLE CUSTOMER','EC$VULN');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWORK NOT REQUIRED','EC$WNR');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWORK ALREADY DONE','EC$DONE');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWORK REFUSED','EC$WREF');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSPERSONAL SAFETY','EC$PSAFE');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSASSET ISSUES','EC$AIELEC');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSMETER BOX DAMAGED','EC$MBD');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSSHARED FUSE','EC$SHFUS');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSNO ROOM FOR CONTACTOR - 5 TERM REQ','EC$NORM');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSDNO VISIT REQUIRED','EC$DNO');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERING','EC$SVCC04');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSELEC METER OBSTRUCTED','EC$SVCC22');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSBOTH METERS OBSTRUCTED','EC$BMO');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSLADDER REQUIRED','EC$LR');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWRONG SKILL SET','EC$SK');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSHEATWISE','EC$HW');
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSOTHER (DEFINE)','EC$OTHER');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS DISTRIBUTION','GC$GDIST');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSPERSONAL SAFETY','GC$GPERS');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSWORK NOT REQUIRED','GC$GDONE');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSVULNERABLE CUSTOMER','GC$GVULN');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS SAFETY','GC$GSA');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS METER OBSTRUCTED','GC$GMO');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS INTERFERENCE','GC$GINT');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSCOMMUNAL LOCKS / ACCESS','GC$GCLOCK');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS OTHER','GC$GO');//CH14
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSBOTH METERS OBSTRUCTED','GC$GBMO');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS TECHNICAL PROBLEM','GC$GTP');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSWORK REFUSED','GC$GWORKR');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSASSET ISSUES','GC$AIGAS');
        MAPABORTREASONWITHCODE.PUT('5. SMART PRE-INSTALLPRE INSTALL TEST FAILURE','PIC$001');
        MAPABORTREASONWITHCODE.PUT('5. SMART PRE-INSTALLSYSTEM OUTAGE - UNABLE TO SCHEME','PIC$002');
        MAPABORTREASONWITHCODE.PUT('5. SMART PRE-INSTALLNO SIGNAL ON HHU UNABLE TO SEND SCHEME','PIC$003');
        /*MAPABORTREASONWITHCODE.PUT('6. 6. SMS CONFIGURATIONMETER INSTALL HAN FAILED','SMS$INSTHANFAILED');
        MAPABORTREASONWITHCODE.PUT('6. SMS CONFIGURATIONMETER INSTALL WAN FAILED','SMS$INSTWANFAILED');
        MAPABORTREASONWITHCODE.PUT('6. SMS CONFIGURATIONNONE OF THE ABOVE','SMS$NOTA');
        MAPABORTREASONWITHCODE.PUT('6. SMS CONFIGURATIONSYSTEM OUTAGE - UNABLE TO SCHEME','SMS$002');
        MAPABORTREASONWITHCODE.PUT('6. SMS CONFIGURATIONNO SIGNAL ON HHU UNABLE TO SEND SCHEME','SMS$003');*/
        //CH02.START
        MAPABORTREASONWITHCODE.PUT('6. SMS CONFIGURATIONSMS CONFIGURATION FAILURE','SMS$');
        MAPABORTREASONWITHCODE.PUT('7. PAIR CONFIGURATIONMETER INSTALL HAN FAILED','INSTHANFAILED$');
        MAPABORTREASONWITHCODE.PUT('7. PAIR CONFIGURATIONMETER INSTALL WAN FAILED','INSTWANFAILED$');
        MAPABORTREASONWITHCODE.PUT('7. PAIR CONFIGURATIONNONE OF THE ABOVE','NOTA$');
        MAPABORTREASONWITHCODE.PUT('7. PAIR CONFIGURATIONSYSTEM OUTAGE - UNABLE TO SCHEME','002$');
        MAPABORTREASONWITHCODE.PUT('7. PAIR CONFIGURATIONNO SIGNAL ON HHU UNABLE TO SEND SCHEME','003$');
        //CH02.END
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSNO ROOM FOR CONTACTOR - 5 TERM REQ','NORM$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSELEC METER OBSTRUCTED','SVCC22');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSLADDER REQUIRED','LR$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERING','SVCC04');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSVULNERABLE CUSTOMER','VULN$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSWORK REFUSED','WREF');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSMETER BOX DAMAGED','MBD$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSHEATWISE','HW');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSPRE INSTALL TEST FAILURE','001');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSMETER INSTALL HAN FAILED','SMS002$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSGAS METER OBSTRUCTED','GMO');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSDNO VISIT REQUIRED','DNO');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSNO SIGNAL ON HHU UNABLE TO SEND SCHEME','003$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSWORK ALREADY DONE','DONE$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSWRONG SKILL SET','SK');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSGAS TECHNICAL PROBLEM','GTP');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSBOTH METERS OBSTRUCTED','BMO');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSPERSONAL SAFETY','PSAFE');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSSHARED FUSE','SHFUS$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSOTHER','OTHER$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSSYSTEM OUTAGE - UNABLE TO SCHEME','002$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSMETER INSTALL WAN FAILED','SMS001$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSGAS INTERFERENCE','GINT');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSCOMMUNAL LOCKS / ACCESS','CLOCK$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSGAS DISTRIBUTION','GDIST');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSNO SUITABLE REASONS EXIST','NA$');//CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSGAS SAFETY','GSA');
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSWORK NOT REQUIRED','WNR$'); //CH02
        MAPABORTREASONWITHCODE.PUT('8. OUT OF PROCESSGAS OTHER','GO');//CH14
        //CH01.UPDATE.END
        
        //CH16.Start
        MAPABORTREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSADDITIONAL SUB METER ON SITE','EC$ESUBMETER');
        MAPABORTREASONWITHCODE.PUT('4. GAS CHECK DETAILSADDITIONAL SUB METER ON SITE','GC$GSUBMETER');
        MAPABORTREASONWITHCODE.PUT('7. PAIR CONFIGURATIONCUSTOMER REQUEST TO LEAVE','CRLEAVE');
        //CH16.End
        RETURN MAPABORTREASONWITHCODE;
    }
    
    /** CH08 commented this method.
        getMapAbortSubReasoncode() - This method retruns the Abort Reason code based on the abort Sub 
                        reason and category.
    
    public static Map<String, String>getMapAbortSubReasoncode(){ 
        Map<String, String> mapAbortSubReasonWithcode = new Map<String, String>();

        mapAbortSubReasonWithcode.put('Not conven/rearrange','NC');
        mapAbortSubReasonWithcode.put('Customer refusal','CR');
        mapAbortSubReasonWithcode.put('No Longer Energy Supplier','NES');
        mapAbortSubReasonWithcode.put('Site Not Ready','SNR');
        mapAbortSubReasonWithcode.put('Other','O');
        mapAbortSubReasonWithcode.put('No answer','NOANSWER');
        mapAbortSubReasonWithcode.put('No responsible adult','NORESAD');
        mapAbortSubReasonWithcode.put('Language barrier','LANGBAR');
        mapAbortSubReasonWithcode.put('Site demolished','SITEDEM');
        mapAbortSubReasonWithcode.put('Not located','SITELOST');
        mapAbortSubReasonWithcode.put('No Parking Available','NPA');
        mapAbortSubReasonWithcode.put('Property vacant','PROPVAC');
        mapAbortSubReasonWithcode.put('Other','OO');
        mapAbortSubReasonWithcode.put('Not conven/rearrange','NC');
        mapAbortSubReasonWithcode.put('Customer refuses visit','CR');
        mapAbortSubReasonWithcode.put('No Longer energy supplier','NES');
        mapAbortSubReasonWithcode.put('Site not ready','SNR');
        mapAbortSubReasonWithcode.put('Other','OO');
        mapAbortSubReasonWithcode.put('A/C or Customer issue','AC');
        mapAbortSubReasonWithcode.put('Site Condition','SITECON');
        mapAbortSubReasonWithcode.put('Animals','ANIMAL');
        mapAbortSubReasonWithcode.put('Weather','WEATH');
        mapAbortSubReasonWithcode.put('Other','PSO');
        mapAbortSubReasonWithcode.put('Permanent  - Other Reason','PERMO');
        mapAbortSubReasonWithcode.put('Permanent - Health Concerns','PERMH');
        mapAbortSubReasonWithcode.put('Temporary - Health Concerns','TEMPH');
        mapAbortSubReasonWithcode.put('Temporary - Data Privacy Concerns','TEMPD');
        mapAbortSubReasonWithcode.put('Temporary - Other Reason','TEMPO');
        mapAbortSubReasonWithcode.put('Permanent - Data Privacy Concerns','PERMD');
        mapAbortSubReasonWithcode.put('A/C or Customer issue','AC');
        mapAbortSubReasonWithcode.put('Site Condition','SITECON');
        mapAbortSubReasonWithcode.put('Animals','ANIMAL');
        mapAbortSubReasonWithcode.put('Weather','WEATH');
        mapAbortSubReasonWithcode.put('Other','PSO');
        mapAbortSubReasonWithcode.put('Unable To Fit Smart Due To Space','NOSPACEE');
        mapAbortSubReasonWithcode.put('Asset Unavailable','ASUNAVAILE');
        mapAbortSubReasonWithcode.put('Others','ASOOE');
        mapAbortSubReasonWithcode.put('Category B Fault','DNOCATB');
        mapAbortSubReasonWithcode.put('Category C Fault','DNOCATC');
        mapAbortSubReasonWithcode.put('Category A Fault','DNOCATA');
        mapAbortSubReasonWithcode.put('Illegal connection/ disconnection','TAM13');
        mapAbortSubReasonWithcode.put('Bypass fitted (loop)','TAM08');
        mapAbortSubReasonWithcode.put('Black box fitted','TAM07');
        mapAbortSubReasonWithcode.put('Other','TAM17');
        mapAbortSubReasonWithcode.put('Suspected electronic interference','TAM10');
        mapAbortSubReasonWithcode.put('Meter stopped illegally','TAM09');
        mapAbortSubReasonWithcode.put('Abnormal marks on meter disks','TAM14');
        mapAbortSubReasonWithcode.put('Timeswitch Irregularity','TAM16');
        mapAbortSubReasonWithcode.put('Tails reversed','TAM11');
        mapAbortSubReasonWithcode.put('Loose tails','TAM15');
        mapAbortSubReasonWithcode.put('Temporary','ELECT');
        mapAbortSubReasonWithcode.put('Permanent','ELECP');
        mapAbortSubReasonWithcode.put('Temporary','BOTHT');
        mapAbortSubReasonWithcode.put('Permanent','BOTHP');
        mapAbortSubReasonWithcode.put('CT','CT');
        mapAbortSubReasonWithcode.put('Band 6 required','B6');
        mapAbortSubReasonWithcode.put('3 phase','3P');
        mapAbortSubReasonWithcode.put('Key','KEY');
        mapAbortSubReasonWithcode.put('Credit','CR');
        mapAbortSubReasonWithcode.put('ECV stiff','GD001');
        mapAbortSubReasonWithcode.put('ECV let-by failed','GD002');
        mapAbortSubReasonWithcode.put('No gas supply','GD003');
        mapAbortSubReasonWithcode.put('Voltage at meter position','GS002');
        mapAbortSubReasonWithcode.put('Electric meter/supply too close','GS003');
        mapAbortSubReasonWithcode.put('Gas escape (Switch off)','GS001');
        mapAbortSubReasonWithcode.put('Temporary','GMO002');
        mapAbortSubReasonWithcode.put('Permanent','GMO001');
        mapAbortSubReasonWithcode.put('Actual tampering (theft of gas)','GI002');
        mapAbortSubReasonWithcode.put('Suspected tampering (theft of gas)','GI001');
        mapAbortSubReasonWithcode.put('IGT meter (gas)','GO005');
        mapAbortSubReasonWithcode.put('Medium pressure gas','GO004');
        mapAbortSubReasonWithcode.put('U16 gas meter','GO002');
        mapAbortSubReasonWithcode.put('Other','GO001');
        mapAbortSubReasonWithcode.put('Further work required','GO003');
        mapAbortSubReasonWithcode.put('Temporary','BM002');
        mapAbortSubReasonWithcode.put('Permanent','BM001');
        mapAbortSubReasonWithcode.put('Meter box damaged','GTP002');
        mapAbortSubReasonWithcode.put('Meter door damaged','GTP003');
        mapAbortSubReasonWithcode.put('Correct fittings unavailable','GTP001');
        mapAbortSubReasonWithcode.put('HAN failed','PTEST02');
        mapAbortSubReasonWithcode.put('WAN failed','PTEST01');
        mapAbortSubReasonWithcode.put('Temporary','ELECT');
        mapAbortSubReasonWithcode.put('Permanent','ELECP');
        mapAbortSubReasonWithcode.put('Illegal connection/ disconnection','TAM13');
        mapAbortSubReasonWithcode.put('Bypass fitted (loop)','TAM08');
        mapAbortSubReasonWithcode.put('Black box fitted','TAM07');
        mapAbortSubReasonWithcode.put('Other','TAM17');
        mapAbortSubReasonWithcode.put('Suspected electronic interference','TAM10');
        mapAbortSubReasonWithcode.put('Meter stopped illegally','TAM09');
        mapAbortSubReasonWithcode.put('Abnormal marks on meter disks','TAM14');
        mapAbortSubReasonWithcode.put('Timeswitch Irregularity','TAM16');
        mapAbortSubReasonWithcode.put('Tails reversed','TAM11');
        mapAbortSubReasonWithcode.put('Loose tails','TAM15');
        mapAbortSubReasonWithcode.put('Permanent  - Other Reason','PERMO');
        mapAbortSubReasonWithcode.put('Permanent - Health Concerns','PERMH');
        mapAbortSubReasonWithcode.put('Temporary - Health Concerns','TEMPH');
        mapAbortSubReasonWithcode.put('Temporary - Data Privacy Concerns','TEMPD');
        mapAbortSubReasonWithcode.put('Temporary - Other Reason','TEMPO');
        mapAbortSubReasonWithcode.put('Permanent - Data Privacy Concerns','PERMD');
        mapAbortSubReasonWithcode.put('Key','KEY');
        mapAbortSubReasonWithcode.put('Credit','CR');
        mapAbortSubReasonWithcode.put('HAN failed','PTEST02');
        mapAbortSubReasonWithcode.put('WAN failed','PTEST01');
        mapAbortSubReasonWithcode.put('Temporary','GMO002');
        mapAbortSubReasonWithcode.put('Permanent','GMO001');
        mapAbortSubReasonWithcode.put('Category B Fault','DNOCATB');
        mapAbortSubReasonWithcode.put('Category C Fault','DNOCATC');
        mapAbortSubReasonWithcode.put('Category A Fault','DNOCATA');
        mapAbortSubReasonWithcode.put('CT','CT');
        mapAbortSubReasonWithcode.put('Band 6 required','B6');
        mapAbortSubReasonWithcode.put('3 phase','3P');
        mapAbortSubReasonWithcode.put('Meter box damaged','GTP002');
        mapAbortSubReasonWithcode.put('Meter door damaged','GTP003');
        mapAbortSubReasonWithcode.put('Correct fittings unavailable','GTP001');
        mapAbortSubReasonWithcode.put('Temporary','BOTHT');
        mapAbortSubReasonWithcode.put('Permanent','BOTHP');
        mapAbortSubReasonWithcode.put('A/C or Customer issue','AC');
        mapAbortSubReasonWithcode.put('Site Condition','SITECON');
        mapAbortSubReasonWithcode.put('Animals','ANIMAL');
        mapAbortSubReasonWithcode.put('Weather','WEATH');
        mapAbortSubReasonWithcode.put('Other','PSO');
        mapAbortSubReasonWithcode.put('Actual tampering (theft of gas)','GI002');
        mapAbortSubReasonWithcode.put('Suspected tampering (theft of gas)','GI001');
        mapAbortSubReasonWithcode.put('ECV stiff','GD001');
        mapAbortSubReasonWithcode.put('ECV let-by failed','GD002');
        mapAbortSubReasonWithcode.put('No gas supply','GD003');
        mapAbortSubReasonWithcode.put('Voltage at meter position','GS002');
        mapAbortSubReasonWithcode.put('Electric meter/supply too close','GS003');
        mapAbortSubReasonWithcode.put('Gas escape (Switch off)','GS001');
        mapAbortSubReasonWithcode.put('IGT meter (gas)','GO005');
        mapAbortSubReasonWithcode.put('Medium pressure gas','GO004');
        mapAbortSubReasonWithcode.put('U16 gas meter','GO002');
        mapAbortSubReasonWithcode.put('Other','GO001');
        mapAbortSubReasonWithcode.put('Further work required','GO003');
        
        return mapAbortSubReasonWithcode;
    }
    **/
    
    //CH03.Start
    /**
        updateValueInUpperCase(List<EON_Job_Results__c> triggerNew) - 
            This method is used to make few fields value in upper case while job results record got created and updated.
    **/
    public static void updateValueInUpperCase(List<EON_Job_Results__c> triggerNew){
       
        Set<String> lstActualSSC = new Set<String>();
        Set<String> lstNewMeterType = New Set<String>();
        
        //Prepare map to get the e meter type value mapping
        Map<String, String> mapMeterType = new Map<String, String>();
        mapMeterType.put('MS1', 'Smart');
        mapMeterType.put('MCL', 'Classic');
        mapMeterType.put('KEY', 'Classic');//CH07
        
        //CH21.start
        map<string, List<EON_SSC_Register__c>> mapRegID = new map<string, List<EON_SSC_Register__c>>();
        List<EON_SSC__c> eSSC = [Select id, Name,(select id,S1_Register_ID__c from EON_SSC_Registers__r order by S1_Register_ID__c ASC) from EON_SSC__c where Type__c='Smart'];
        for(EON_SSC__c es :eSSC){
             mapRegID.put(es.Name,es.EON_SSC_Registers__r);
        }
        //CH21.End
    
        for(EON_Job_Results__c jobResult : triggerNew){
        
            //Electric_SSC_to_be_installed__c
            //CH15.Start
            /*
            if(jobResult.New_Comms_Hub_Serial_Number__c != null && 
                    jobResult.New_Comms_Hub_Serial_Number__c.length() == 10){            
                Map<String, String> mapEMeterRegisterID = getEMeterRegisterIDMap();
                for(integer i=1; i<=6; i++){
                    if(jobResult.get('New_E_Meter_Register_' + i + '_ID__c') != null &&
                        mapEMeterRegisterID.get((String)jobResult.get('New_E_Meter_Register_' + i + '_ID__c')) != null)
                        jobResult.put('New_E_Meter_Register_' + i + '_ID__c', 
                                mapEMeterRegisterID.get((String)jobResult.get('New_E_Meter_Register_' + i + '_ID__c')));    
                } 
            } 
            */             
            //CH15.End
            
             //CH21.start
             if(jobResult.New_Comms_Hub_Serial_Number__c != null && jobResult.New_Comms_Hub_Serial_Number__c.length() == 10 
                 && jobResult.h_Requested_SSC__c!=null && jobResult.h_Requested_SSC__c!=''){
                  if(mapRegID.containsKey(jobResult.h_Requested_SSC__c)){
                     for(integer i=1; i<=mapRegID.get(jobResult.h_Requested_SSC__c).size(); i++){
                       if(jobResult.get('New_E_Meter_Register_' + i + '_ID__c') != null)
                          jobResult.put('New_E_Meter_Register_' + i + '_ID__c', mapRegID.get(jobResult.h_Requested_SSC__c)[i-1].S1_Register_ID__c);    
                   } 
                }
             } 
            //CH21.start
            
            
            //CH13.Start
            jobResult.G_Meter_Register_Read__c = 
                        addPrecedingZeros(jobResult.G_Meter_Register_Read__c, jobResult.G_Meter_Number_of_Digits__c);
            jobResult.Opening_G_Meter_Reading__c = 
                    addPrecedingZeros(jobResult.Opening_G_Meter_Reading__c, jobResult.New_G_Meter_Number_of_digits__c);
            //CH13.End
                        
            //CH11.Start
            if(jobResult.Pre_Work_DNO_Situation__c != null && jobResult.Pre_Work_DNO_Situation__c.equalsIgnoreCase('No')){
                jobResult.Pre_Work_DNO_Defect_Details__c = '';
                jobResult.Pre_Work_DNO_Electric_Reference_Number__c ='';
                jobResult.DNO_Safe_to_Continue__c = ''; 
            }
            //CH11.End
            
            //CH09.Start
            jobResult.Electricity_Driver_for_reverting_type__c =  calculateElectricityDriverforrevertingtype(jobResult);  
            jobResult.Gas_Driver_for_reverting_type__c =  calculateGasDriverforrevertingtype(jobResult);  
            //CH09.End
        
            //CH10.Start
            if(jobResult.h_App_Time_Slots__c!= null && (jobResult.h_App_Time_Slots__c.equalsIgnoreCase('ECO') || 
                       jobResult.h_App_Time_Slots__c.equalsIgnoreCase('NIGHT')) ) {
                jobResult.On_Time_Indicator__c = validateTimeSlotsForEchoORNight(jobResult.h_Start_Time__c, 
                                                            jobResult.h_End_Time__c, jobResult.Time_On_Site__c,
                                                            jobResult.h_Appointment_Date__c );                           
            }else
            //CH10.End
            //CH05.Start
            jobResult.On_Time_Indicator__c = validateTimeSlots(jobResult.h_Start_Time__c, jobResult.h_End_Time__c, 
                                                            jobResult.h_App_Time_Slots__c, jobResult.Time_On_Site__c);
            //CH05.End
            
            //CH06 Start
            if(jobResult.On_Time_Indicator__c != null && jobResult.On_Time_Indicator__c == 'No' && 
                        (jobResult.Late_Reason__c == null || jobResult.Late_Reason__c == ''))
                jobResult.Late_Reason__c = 'Traffic Delay';                        
            //CH06 End
        
            jobResult.E_Meter_Serial_Number__c = EON_Utility.validateRequired(jobResult.E_Meter_Serial_Number__c) ?
                                                 jobResult.E_Meter_Serial_Number__c : jobResult.E_Meter_Serial_Number__c.toUppercase();
            
            jobResult.G_Meter_Serial_Number__c = EON_Utility.validateRequired(jobResult.G_Meter_Serial_Number__c) ?
                                                 jobResult.G_Meter_Serial_Number__c : jobResult.G_Meter_Serial_Number__c.toUppercase();
            
            jobResult.Gas_Regulator_Serial_Number__c = EON_Utility.validateRequired(jobResult.Gas_Regulator_Serial_Number__c) ?
                                                 jobResult.Gas_Regulator_Serial_Number__c : jobResult.Gas_Regulator_Serial_Number__c.toUppercase();
            
            jobResult.Removed_E_Meter_Serial_Number__c = EON_Utility.validateRequired(jobResult.Removed_E_Meter_Serial_Number__c) ?
                                                 jobResult.Removed_E_Meter_Serial_Number__c : jobResult.Removed_E_Meter_Serial_Number__c.toUppercase();
            
            jobResult.Removed_G_Meter_Serial_Number__c = EON_Utility.validateRequired(jobResult.Removed_G_Meter_Serial_Number__c) ?
                                                 jobResult.Removed_G_Meter_Serial_Number__c : jobResult.Removed_G_Meter_Serial_Number__c.toUppercase();
            
            jobResult.Removed_Gas_Regulator_Serial_Number__c = EON_Utility.validateRequired(jobResult.Removed_Gas_Regulator_Serial_Number__c) ?
                                                 jobResult.Removed_Gas_Regulator_Serial_Number__c: jobResult.Removed_Gas_Regulator_Serial_Number__c.toUppercase();
            
            jobResult.New_E_Meter_Serial_Number__c = EON_Utility.validateRequired(jobResult.New_E_Meter_Serial_Number__c) ?
                                                 jobResult.New_E_Meter_Serial_Number__c: jobResult.New_E_Meter_Serial_Number__c.toUppercase();
            
            jobResult.New_G_Meter_Serial_Number__c = EON_Utility.validateRequired(jobResult.New_G_Meter_Serial_Number__c) ?
                                                 jobResult.New_G_Meter_Serial_Number__c: jobResult.New_G_Meter_Serial_Number__c.toUppercase();
            
            jobResult.New_Gas_Regulator_Serial_Number__c = EON_Utility.validateRequired(jobResult.New_Gas_Regulator_Serial_Number__c) ?
                                                 jobResult.New_Gas_Regulator_Serial_Number__c: jobResult.New_Gas_Regulator_Serial_Number__c.toUppercase();
            
            jobResult.Found_IHD_Serial_Number__c = EON_Utility.validateRequired(jobResult.Found_IHD_Serial_Number__c) ?
                                                 jobResult.Found_IHD_Serial_Number__c : jobResult.Found_IHD_Serial_Number__c.toUppercase();
            
            jobResult.New_IHD_Serial_Number__c = EON_Utility.validateRequired(jobResult.New_IHD_Serial_Number__c) ?
                                                 jobResult.New_IHD_Serial_Number__c : jobResult.New_IHD_Serial_Number__c.toUppercase();
            
            jobResult.Found_Comms_Hub_Serial_Number__c = EON_Utility.validateRequired(jobResult.Found_Comms_Hub_Serial_Number__c) ?
                                                 jobResult.Found_Comms_Hub_Serial_Number__c : jobResult.Found_Comms_Hub_Serial_Number__c.toUppercase();
            
            jobResult.New_Comms_Hub_Serial_Number__c = EON_Utility.validateRequired(jobResult.New_Comms_Hub_Serial_Number__c) ?
                                                 jobResult.New_Comms_Hub_Serial_Number__c : jobResult.New_Comms_Hub_Serial_Number__c.toUppercase();
            
            jobResult.E_Check_Meter_Serial_Number__c = EON_Utility.validateRequired(jobResult.E_Check_Meter_Serial_Number__c) ?
                                                 jobResult.E_Check_Meter_Serial_Number__c : jobResult.E_Check_Meter_Serial_Number__c.toUppercase();
            
            jobResult.G_Check_Meter_Serial_Number__c = EON_Utility.validateRequired(jobResult.G_Check_Meter_Serial_Number__c) ?
                                                 jobResult.G_Check_Meter_Serial_Number__c : jobResult.G_Check_Meter_Serial_Number__c.toUppercase();
           
           //CH04.Start
           if(jobResult.Actual_SSC_Installed__c != null && jobResult.Actual_SSC_Installed__c!= '')
               lstActualSSC.add(jobResult.Actual_SSC_Installed__c);
               
           if(jobResult.New_E_Meter_Type__c != null && jobResult.New_E_Meter_Type__c != '')
               lstNewMeterType.add(mapMeterType.get(jobResult.New_E_Meter_Type__c));    
           //CH04.End            
                                                   
        }
        
        
        //CH04.Start
        if(!lstActualSSC.isEmpty()){
            
            Map<id, EON_Electric_Meter_Register__c> MapElecMeterReg = new Map<id,EON_Electric_Meter_Register__c>
                                        ([select id, Name from EON_Electric_Meter_Register__c where isDeleted = false]);            
            
            
            Map<String, List<List<EON_SSC_Register__c>>> mapSSCIDWithRegisters = 
                                                    new Map<String, List<List<EON_SSC_Register__c>>>();
            for(EON_SSC__c SSC : [select id, Name, (select name, Register_ID__c,  SSC__r.Type__c from EON_SSC_Registers__r) 
                                        from EON_SSC__C where name in : lstActualSSC and Type__c  in :lstNewMeterType]){
                if(mapSSCIDWithRegisters.get(SSC.Name) == null){
                    List<List<EON_SSC_Register__c>> lstlstRegisters = new List<List<EON_SSC_Register__c>>();
                    lstlstRegisters.add(SSC.EON_SSC_Registers__r);
                    mapSSCIDWithRegisters.put(SSC.Name, lstlstRegisters);
                }  else{
                    List<List<EON_SSC_Register__c>> lstlstRegisters1 = mapSSCIDWithRegisters.get(SSC.Name);
                    lstlstRegisters1.add(SSC.EON_SSC_Registers__r); 
                    mapSSCIDWithRegisters.put(SSC.Name, lstlstRegisters1);                 
                }  
            }            
            
            for(EON_Job_Results__c jobResult : triggerNew){
                if(jobResult.Actual_SSC_Installed__c != null && jobResult.Actual_SSC_Installed__c!= '' &&
                        mapSSCIDWithRegisters.get(jobResult.Actual_SSC_Installed__c) != null){
                    for(List<EON_SSC_Register__c> lstRegister : mapSSCIDWithRegisters.get(jobResult.Actual_SSC_Installed__c)){
                        if(lstRegister[0].SSC__r.Type__c == mapMeterType.get(jobResult.New_E_Meter_Type__c)){                            

                            for(integer i=1; i<=6; i++){
                                jobResult.put('New_E_Meter_Register_'+i+'_ID__c', ''); // Just to make default before set.
                                for(EON_SSC_Register__c Register : lstRegister){
                                    if(jobResult.get('New_E_Meter_Register_'+i+'_Type__c') != null &&
                                      MapElecMeterReg.get((ID)jobResult.get('New_E_Meter_Register_'+i+'_Type__c')).Name == Register.Name){
                                        jobResult.put('New_E_Meter_Register_'+i+'_ID__c', Register.Register_ID__c);
                                    }
                                }
                            }

                        }
                    }
                }                
            }
                                    
        }                       
        //CH04.End
    }
    //CH03.End
    
    
    //CH10.Start    
    
    /**
        validateTimeSlotsForEchoORNight(String Starttime, String endTime, datetime timeOnSite,
                                                            date appointmentDate)
            This method is used to calculate the On Time Indicator field value if timeslots are ECHO and Night.
    **/    
    public static String validateTimeSlotsForEchoORNight(String Starttime, String endTime, datetime timeOnSite,
                                                            date appointmentDate){ 
        String result = '';
        try{
            String appDate = appointmentDate.Year() + '-'+appointmentDate.month() + '-'+appointmentDate.day();
            
            if(Starttime != null && endTime != null && timeOnSite != null && appointmentDate != null){
            DateTime startDateTime = Datetime.valueOf(appDate + ' ' + Starttime + ': 00'); 
            DateTime endDateTime;
            
            integer startT = integer.valueOf((Starttime.replace(':', '')).trim());
            integer endT = integer.valueOf((endTime.replace(':', '')).trim());  
            
            if((endT - StartT) < 0){
                Date afterOneDay = appointmentDate.addDays(1);
                appDate = afterOneDay.Year() + '-'+afterOneDay.month() + '-'+afterOneDay.day();
                endDateTime = Datetime.valueOf(appDate + ' ' + endTime + ':00');
            }else
                endDateTime = Datetime.valueOf(appDate + ' ' + endTime+ ':00');
                
            if(timeOnSite >=  startDateTime && timeOnSite <= endDateTime)
                result = 'Yes';
            else
                result = 'No';    
        }
        }catch(Exception ex){
            System.debug('Exception Occured : '+ ex.getMessage() + ' ' + ex.getStackTraceString());
        }
        return result;
    }
    //CH10.end
    
    //CH05.Start
    /**
        validateTimeSlots(String Starttime, String endTime, String timeslots, datetime timeOnSite)
            This method is used to calculate the On Time Indicator field value.
    **/
    public static String validateTimeSlots(String Starttime, String endTime, String timeslots, datetime timeOnSite){    
        String result = '';
        try{
        if(timeOnSite != null){
            //timeOnSite = timeOnSite.addHours(1);
            integer timeonsitehours = timeOnSite.Hour();
            integer timeonsiteMinutes = timeOnSite.Minute();
            
            integer timeOnsiteTime = integer.valueOf((timeonsitehours + 
                                    ((timeonsiteMinutes < 10) ? '0' : '') + //CH12
                                    timeOnSite.Minute()).trim());
            
            if(timeslots != null && timeslots != ''){
                String[] slots = timeSlots.split('-');
                if(slots.size() > 1){
                    integer slot1 = integer.valueOf((slots[0].replace(':', '')).trim());
                    integer slot2 = integer.valueOf((slots[1].replace(':', '')).trim());
                    
                    if(timeOnsiteTime >= slot1 && timeOnsiteTime <= slot2){
                        result = 'Yes';
                    }else
                        result = 'No';
                }
            }else if(Starttime != null && Starttime != '' && endTime != null && endTime != ''){
                integer slot1 = integer.valueOf((Starttime.replace(':', '')).trim());
                integer slot2 = integer.valueOf((endTime.replace(':', '')).trim());
                
                if(timeOnsiteTime >= slot1 && timeOnsiteTime <= slot2){
                    result = 'Yes';
                }else
                    result = 'No';                
            }
        }
        }catch(Exception ex){
            System.debug('Exception Occured : '+ ex.getMessage() + ' ' + ex.getStackTraceString());
        }
        return result;
    }
    //CH05.End
       

    //CH08.Start
    /**
        GETMAPABORTSUBREASONCODE() - THIS METHOD RETRUNS THE ABORT REASON CODE BASED ON THE ABORT SUB 
                        REASON AND CATEGORY.
    **/    
    PUBLIC STATIC MAP<STRING, STRING> GETMAPABORTSUBREASONCODE(){ 
        MAP<STRING, STRING> MAPABORTSUBREASONWITHCODE = NEW MAP<STRING, STRING>();

        MAPABORTSUBREASONWITHCODE.PUT('1. PRE-SITEPRE VISIT CUSTOMER REFUSALNOT CONVEN/REARRANGE','NC');
        MAPABORTSUBREASONWITHCODE.PUT('1. PRE-SITEPRE VISIT CUSTOMER REFUSALCUSTOMER REFUSAL','CR');
        MAPABORTSUBREASONWITHCODE.PUT('1. PRE-SITEPRE VISIT CUSTOMER REFUSALNO LONGER ENERGY SUPPLIER','NES');
        MAPABORTSUBREASONWITHCODE.PUT('1. PRE-SITEPRE VISIT CUSTOMER REFUSALSITE NOT READY','SNR');
        MAPABORTSUBREASONWITHCODE.PUT('1. PRE-SITEPRE VISIT CUSTOMER REFUSALOTHER','O');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALNO ACCESSNO ANSWER','NOANSWER');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALNO ACCESSNO RESPONSIBLE ADULT','NORESAD');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALNO ACCESSLANGUAGE BARRIER','LANGBAR');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALNO ACCESSSITE DEMOLISHED','SITEDEM');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALNO ACCESSNOT LOCATED','SITELOST');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALNO ACCESSNO PARKING AVAILABLE','NPA');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALNO ACCESSPROPERTY VACANT','PROPVAC');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALNO ACCESSOTHER','OO');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALON SITE CUSTOMER REFUSALNOT CONVEN/REARRANGE','NC');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALON SITE CUSTOMER REFUSALCUSTOMER REFUSES VISIT','CR');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALON SITE CUSTOMER REFUSALNO LONGER ENERGY SUPPLIER','NES');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALON SITE CUSTOMER REFUSALSITE NOT READY','SNR');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALON SITE CUSTOMER REFUSALOTHER','OO');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALPERSONAL SAFETYA/C OR CUSTOMER ISSUE','AC');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALPERSONAL SAFETYSITE CONDITION','SITECON');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALPERSONAL SAFETYANIMALS','ANIMAL');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALPERSONAL SAFETYWEATHER','WEATH');
        MAPABORTSUBREASONWITHCODE.PUT('2. ABORT AFTER SITE ARRIVALPERSONAL SAFETYOTHER','PSO');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWORK REFUSEDPERMANENT - OTHER REASON','PERMO');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWORK REFUSEDPERMANENT - HEALTH CONCERNS','PERMH');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWORK REFUSEDTEMPORARY - HEALTH CONCERNS','TEMPH');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWORK REFUSEDTEMPORARY - DATA PRIVACY CONCERNS','TEMPD');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWORK REFUSEDTEMPORARY - OTHER REASON','TEMPO');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWORK REFUSEDPERMANENT - DATA PRIVACY CONCERNS','PERMD');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSPERSONAL SAFETYA/C OR CUSTOMER ISSUE','AC');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSPERSONAL SAFETYSITE CONDITION','SITECON');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSPERSONAL SAFETYANIMALS','ANIMAL');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSPERSONAL SAFETYWEATHER','WEATH');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSPERSONAL SAFETYOTHER','PSO');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSASSET ISSUESUNABLE TO FIT SMART DUE TO SPACE','NOSPACEE');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSASSET ISSUESASSET UNAVAILABLE','ASUNAVAILE');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSASSET ISSUESOTHERS','ASOOE');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSDNO VISIT REQUIREDCATEGORY B FAULT','DNOCATB');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSDNO VISIT REQUIREDCATEGORY C FAULT','DNOCATC');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSDNO VISIT REQUIREDCATEGORY A FAULT','DNOCATA');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGILLEGAL CONNECTION/ DISCONNECTION','TAM13');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGBYPASS FITTED (LOOP)','TAM08');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGBLACK BOX FITTED','TAM07');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGOTHER','TAM17');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGSUSPECTED ELECTRONIC INTERFERENCE','TAM10');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGMETER STOPPED ILLEGALLY','TAM09');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGABNORMAL MARKS ON METER DISKS','TAM14');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGTIMESWITCH IRREGULARITY','TAM16');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGTAILS REVERSED','TAM11');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSTAMPERINGLOOSE TAILS','TAM15');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSELEC METER OBSTRUCTEDTEMPORARY','ELECT');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSELEC METER OBSTRUCTEDPERMANENT','ELECP');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSBOTH METERS OBSTRUCTEDTEMPORARY','BOTHT');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSBOTH METERS OBSTRUCTEDPERMANENT','BOTHP');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWRONG SKILL SETCT','CT');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWRONG SKILL SETBAND 6 REQUIRED','B6');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSWRONG SKILL SET3 PHASE','3P');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSHEATWISEKEY','KEY');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSHEATWISECREDIT','CR');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS DISTRIBUTIONECV STIFF','GD001');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS DISTRIBUTIONECV LET-BY FAILED','GD002');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS DISTRIBUTIONNO GAS SUPPLY','GD003');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS SAFETYVOLTAGE AT METER POSITION','GS002');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS SAFETYELECTRIC METER/SUPPLY TOO CLOSE','GS003');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS SAFETYGAS ESCAPE (SWITCH OFF)','GS001');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS METER OBSTRUCTEDTEMPORARY','GMO002');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS METER OBSTRUCTEDPERMANENT','GMO001');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS INTERFERENCEACTUAL TAMPERING (THEFT OF GAS)','GI002');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS INTERFERENCESUSPECTED TAMPERING (THEFT OF GAS)','GI001');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS OTHERIGT METER (GAS)','GO005');//CH14
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS OTHERMEDIUM PRESSURE GAS','GO004');//CH14
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS OTHERU16 GAS METER','GO002');//CH14
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS OTHEROTHER','GO001');//CH14
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS OTHERFURTHER WORK REQUIRED','GO003');//CH14
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSBOTH METERS OBSTRUCTEDTEMPORARY','BM002');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSBOTH METERS OBSTRUCTEDPERMANENT','BM001');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS TECHNICAL PROBLEMMETER BOX DAMAGED','GTP002');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS TECHNICAL PROBLEMMETER DOOR DAMAGED','GTP003');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSGAS TECHNICAL PROBLEMCORRECT FITTINGS UNAVAILABLE','GTP001');
        MAPABORTSUBREASONWITHCODE.PUT('5. SMART PRE-INSTALLPRE INSTALL TEST FAILUREHAN FAILED','PTEST02');
        MAPABORTSUBREASONWITHCODE.PUT('5. SMART PRE-INSTALLPRE INSTALL TEST FAILUREWAN FAILED','PTEST01');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSELEC METER OBSTRUCTEDTEMPORARY','ELECT');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSELEC METER OBSTRUCTEDPERMANENT','ELECP');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGILLEGAL CONNECTION/ DISCONNECTION','TAM13');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGBYPASS FITTED (LOOP)','TAM08');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGBLACK BOX FITTED','TAM07');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGOTHER','TAM17');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGSUSPECTED ELECTRONIC INTERFERENCE','TAM10');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGMETER STOPPED ILLEGALLY','TAM09');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGABNORMAL MARKS ON METER DISKS','TAM14');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGTIMESWITCH IRREGULARITY','TAM16');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGTAILS REVERSED','TAM11');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSTAMPERINGLOOSE TAILS','TAM15');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSWORK REFUSEDPERMANENT - OTHER REASON','PERMO');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSWORK REFUSEDPERMANENT - HEALTH CONCERNS','PERMH');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSWORK REFUSEDTEMPORARY - HEALTH CONCERNS','TEMPH');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSWORK REFUSEDTEMPORARY - DATA PRIVACY CONCERNS','TEMPD');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSWORK REFUSEDTEMPORARY - OTHER REASON','TEMPO');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSWORK REFUSEDPERMANENT - DATA PRIVACY CONCERNS','PERMD');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSHEATWISEKEY','KEY');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSHEATWISECREDIT','CR');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSPRE INSTALL TEST FAILUREHAN FAILED','PTEST02');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSPRE INSTALL TEST FAILUREWAN FAILED','PTEST01');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS METER OBSTRUCTEDTEMPORARY','GMO002');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS METER OBSTRUCTEDPERMANENT','GMO001');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSDNO VISIT REQUIREDCATEGORY B FAULT','DNOCATB');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSDNO VISIT REQUIREDCATEGORY C FAULT','DNOCATC');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSDNO VISIT REQUIREDCATEGORY A FAULT','DNOCATA');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSWRONG SKILL SETCT','CT');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSWRONG SKILL SETBAND 6 REQUIRED','B6');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSWRONG SKILL SET3 PHASE','3P');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS TECHNICAL PROBLEMMETER BOX DAMAGED','GTP002');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS TECHNICAL PROBLEMMETER DOOR DAMAGED','GTP003');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS TECHNICAL PROBLEMCORRECT FITTINGS UNAVAILABLE','GTP001');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSBOTH METERS OBSTRUCTEDTEMPORARY','BOTHT');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSBOTH METERS OBSTRUCTEDPERMANENT','BOTHP');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSPERSONAL SAFETYA/C OR CUSTOMER ISSUE','AC');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSPERSONAL SAFETYSITE CONDITION','SITECON');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSPERSONAL SAFETYANIMALS','ANIMAL');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSPERSONAL SAFETYWEATHER','WEATH');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSPERSONAL SAFETYOTHER','PSO');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS INTERFERENCEACTUAL TAMPERING (THEFT OF GAS)','GI002');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS INTERFERENCESUSPECTED TAMPERING (THEFT OF GAS)','GI001');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS DISTRIBUTIONECV STIFF','GD001');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS DISTRIBUTIONECV LET-BY FAILED','GD002');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS DISTRIBUTIONNO GAS SUPPLY','GD003');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS SAFETYVOLTAGE AT METER POSITION','GS002');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS SAFETYELECTRIC METER/SUPPLY TOO CLOSE','GS003');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS SAFETYGAS ESCAPE (SWITCH OFF)','GS001');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS OTHERIGT METER (GAS)','GO005');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS OTHERMEDIUM PRESSURE GAS','GO004');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS OTHERU16 GAS METER','GO002');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS OTHEROTHER','GO001');
        MAPABORTSUBREASONWITHCODE.PUT('8. OUT OF PROCESSGAS OTHERFURTHER WORK REQUIRED','GO003');
        
        //CH16.Start
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSASSET ISSUESUNABLE TO FIT SEPARATE COMMS HUB - SPACE',
                                                'NOSPACEH');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSADDITIONAL SUB METER ON SITEMICROGEN','MICROGEN');
        MAPABORTSUBREASONWITHCODE.PUT('3. ELECTRIC CHECK DETAILSADDITIONAL SUB METER ON SITEOTHER','ESUBOTHER');
        MAPABORTSUBREASONWITHCODE.PUT('4. GAS CHECK DETAILSADDITIONAL SUB METER ON SITEOTHER','OTHER'); 
        MAPABORTSUBREASONWITHCODE.PUT('7. PAIR CONFIGURATIONCUSTOMER REQUEST TO LEAVEREFITTED ORIGINAL METER','REFIT');
        MAPABORTSUBREASONWITHCODE.PUT('7. PAIR CONFIGURATIONCUSTOMER REQUEST TO LEAVENO SUITABLE SUB-REASONS EXIST','NA');                                               
        //CH16.End

        
        RETURN MAPABORTSUBREASONWITHCODE;
        
    }
    //CH08.end
    
    //CH09.Start
    /**
        calculateElectricityDriverforrevertingtype(EON_Job_Results__c jobResult) - 
                This method is used to calculate the vlaue for the field - Electricity_Driver_for_reverting_type__c
    **/
    public static string calculateElectricityDriverforrevertingtype(EON_Job_Results__c jobResult){
        if(jobResult.Electricity_Reason_for_Reverting_type__c == null || jobResult.Electricity_Reason_for_Reverting_type__c =='')
            return null;
        else if(jobResult.Electricity_Reason_for_Reverting_type__c != null){
            if(jobResult.h_Appointment_Reason_Code__c != null && jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('Statutory'))
                return 'RECERT';
            else if(jobResult.h_Appointment_Reason_Code__c != null && jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('New Connections'))
                return 'NEWCONN';    
            else if(jobResult.h_Appointment_Reason_Code__c != null && 
                (jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('Fault') || jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('Emergency Call Out'))
                && (jobResult.Electricity_Replacement_Reason__c!= null && jobResult.Electricity_Replacement_Reason__c.equalsIgnoreCase('Equipment faulty')))    
                return 'FAULTY';
            else if(jobResult.h_Appointment_Reason_Code__c != null && 
                (jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('Fault') || jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('Emergency Call Out'))
                && (jobResult.Electricity_Replacement_Reason__c!= null && jobResult.Electricity_Replacement_Reason__c.equalsIgnoreCase('Equipment damaged')))   
            return 'MTRDAM';
        }
        
        return null;    
    }
    
    /**
        calculateGasDriverforrevertingtype(EON_Job_Results__c jobResult) - 
                This method is used to calculate the vlaue for the field - Gas_Driver_for_reverting_type__c
    **/
    public static string calculateGasDriverforrevertingtype(EON_Job_Results__c jobResult){
        if(jobResult.Gas_Reason_for_reverting_type__c == null || jobResult.Gas_Reason_for_reverting_type__c =='')
            return null;
        else if(jobResult.Gas_Reason_for_reverting_type__c != null){
            if(jobResult.h_Appointment_Reason_Code__c != null && jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('Statutory'))
                return 'POLEX';
            else if(jobResult.h_Appointment_Reason_Code__c != null && jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('New Connections'))
                return 'GNEWCONN';    
            else if(jobResult.h_Appointment_Reason_Code__c != null && 
                (jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('Fault') || 
                    jobResult.h_Appointment_Reason_Code__c.equalsIgnoreCase('Emergency Call Out')))    
                return 'GFAULTY';

        }
        
        return null;    
    } 
    //CH09.End
    
    //CH13.Start
    /**
        addPrecedingZeros(String value, String numOfDigits)
    **/    
    public static string addPrecedingZeros(String value, String numOfDigits){
        try{    
            if(value != null && numOfDigits != null){
                integer noOfDigits = integer.valueOf(numOfDigits) - value.length();
                for(integer i=0; i<noOfDigits; i++){
                    value = '0'+ value;
                }
            }
        }catch(Exception ex){
            System.debug('******** ' + ex.getStackTraceString());
        }
        return value;
    }
    //CH13.End
    
    //CH15.Start
    /**
        getEMeterRegisterIDMap() - This method is for mapping for E Meter Register ID fields.
    **/
    /*
    public static MAP<String, String> getEMeterRegisterIDMap(){
        Map<String, String> mapEMeterRegisterID = new Map<String, String>();
        mapEMeterRegisterID.put('1', '01');
        mapEMeterRegisterID.put('2', '02');
        mapEMeterRegisterID.put('3', '03');
        mapEMeterRegisterID.put('4', '04');
        return mapEMeterRegisterID;
    }
    */
    //CH15.End
    
    //CH17.Start
    /**
        updateTechnicianForStock(List<EON_Job_Results__c> triggerNEW) - This method is used to update the 
                    technician mismatch for stock when job results created. (by Trigger)
    **/
    public static void updateTechnicianForStock(List<EON_Job_Results__c> triggerNEW){
        List<EON_Stock__c> lstStock = getStockRecords(triggerNEW);
        List<String> lstSerialNumber = getSerialNumberForJobResults(triggerNew);
        List<EON_Stock__c> lstStockUpdate = new List<EON_Stock__c>();
        
        for(EON_Job_Results__c result : triggerNEW){
            if(!lstStock.isEmpty()){
                List<Eon_Stock__c> stocklist= new list<Eon_Stock__c>();
                stocklist=getStockswithTechnicianKIDMisMatch(lstStock, result.h_KID__c, lstSerialNumber);
                if(stocklist.size()==1){
                    for(Eon_Stock__c stock :stocklist){
                        stock.Technician_Mismatch__c = true;
                        stock.Technician_Name__c = result.Technician__c;
                        lstStockUpdate.add(stock);
                    } 
                }
             }   
           /*if(result.Original_E_Meter_refitted__c!='Yes'){ //CH20
            if(result.New_Comms_Hub_Serial_Number__c != null && result.New_Comms_Hub_Serial_Number__c != '')
                updateStockForInstall(lstStock, result);  
           }  */ //CH22.old moved code to EON_Ceva_Stock_Reconciliation_Process                                           
        }
        
        if(!lstStockUpdate.isEmpty())
            update lstStockUpdate;
    }
    
    /**
        getSerialNumberForJobResults(List<EON_Job_Results__c> triggerNew) - This method to get the serial 
                    numbers on Job Results.
    **/
    public static List<String> getSerialNumberForJobResults(List<EON_Job_Results__c> triggerNew){
        List<String> lstSerialNumber = new List<String>();
        for(EON_Job_Results__c result : triggerNew){
            if(result.New_E_Meter_Serial_Number__c != null)
                lstSerialNumber.add(result.New_E_Meter_Serial_Number__c);
            if(result.New_G_Meter_Serial_Number__c != null)    
                lstSerialNumber.add(result.New_G_Meter_Serial_Number__c);
            if(result.New_Gas_Regulator_Serial_Number__c != null)    
                lstSerialNumber.add(result.New_Gas_Regulator_Serial_Number__c);
            if(result.New_IHD_Serial_Number__c != null)     
                lstSerialNumber.add(result.New_IHD_Serial_Number__c);
            if(result.New_Comms_Hub_Serial_Number__c != null)
                lstSerialNumber.add(result.New_Comms_Hub_Serial_Number__c);
        }
        return lstSerialNumber;    
    }
        
    /**
        getStockRecords(List<EON_Job_Results__c> triggerNew) - This method is to get the stock records with 
            job Results serial numbers.
    **/
    public static List<EON_Stock__c> getStockRecords(List<EON_Job_Results__c> triggerNew){
        List<String> lstSerialNumber = getSerialNumberForJobResults(triggerNew);
        return [select KID__c, Serial_Number__c from EON_Stock__c where Serial_Number__c in : lstSerialNumber and Status__c='On Van']; //CH23.Added 'On Van' filter
    }
        
    /**
       getStockswithTechnicianKIDMisMatch(List<EON_Stock__c> lstStock, String kID, List<String> lstSerialNumber) -
           This method is to identify the technician mis match stock records.
    **/
    public static List<EON_Stock__c> getStockswithTechnicianKIDMisMatch(List<EON_Stock__c> lstStock, String kID, 
                                                                            List<String> lstSerialNumber){
        List<EON_Stock__c> lstStockUpdate = new List<EON_Stock__c>();
        for(EON_Stock__c stock :lstStock){
            for(String serialNum : lstSerialNumber){
                if(stock.Serial_Number__c == serialNum){
                    if(KID != stock.KID__c)
                        lstStockUpdate.add(stock);
                }
            }

        }
        return lstStockUpdate;
    }
    
    /**    
        updateStockForInstall(List<EON_Stock__c> lstStock, String commsHubSerialNum, String jobResID) - This method is
               to update the stock record with status as Installed for matching commshubserial number.
    **/
    public static void updateStockForInstall(List<EON_Stock__c> lstStock, EON_Job_Results__c jobRes){
        System.debug('*****inside ' + lstStock.size());
        List<EON_Stock__c> lstStockUpdate = new List<EON_Stock__c>();
        //Ch22.start
        Map<String,List<EON_Stock__c>> mapStocks= new Map<String,List<EON_Stock__c>>();
        for(EON_Stock__c stock :lstStock){
             if(!mapStocks.containsKey(jobRes.New_Comms_Hub_Serial_Number__c))
                mapStocks.put(jobRes.New_Comms_Hub_Serial_Number__c, new List<EON_Stock__c>());
            mapStocks.get(jobRes.New_Comms_Hub_Serial_Number__c).add(stock);
        }
        if(mapStocks.get(jobRes.New_Comms_Hub_Serial_Number__c)!=null && mapStocks.get(jobRes.New_Comms_Hub_Serial_Number__c).size()==1){
        EON_Stock__c stock = new EON_Stock__c ();
        stock=mapStocks.get(jobRes.New_Comms_Hub_Serial_Number__c)[0];//CH22.end
            if(stock.Serial_Number__c == jobRes.New_Comms_Hub_Serial_Number__c){
                    stock.Status__c = 'Installed';                  
                    //CH18.Start
                    if(jobRes.Time_On_Site__c != null)
                        stock.date_Of_Installation__c = jobRes.Time_On_Site__c.date();
                    stock.EON_Job_Results__c = jobRes.id; 
                    //CH18.End  
                     
                    lstStockUpdate.add(stock);
            }
        }
        System.debug('*****lstStockUpdate ' + lstStockUpdate.size());
        if(!lstStockUpdate.isEmpty())
            update lstStockUpdate;
        //Send an email if no match found 
        /*   
        else if(jobRes.New_Comms_Hub_Serial_Number__c.length() > 10){
            List<Messaging.SingleEmailMessage> emaillist = new List<Messaging.SingleEmailMessage>();
            emaillist.add(EON_Ceva_Stock_Reconciliation_Process.ProcessEmails_JobResults(new List<EON_Stock__c>(),
                                        jobRes,
                                        jobRes.New_Comms_Hub_Serial_Number__c,
                                        System.Label.EON_Stock_No_matching_serial_number_Template));             
            System.debug('***** ' + emaillist.size());
            if(!emaillist.isEmpty())
                Messaging.sendEmail(emaillist);
        }*/ //CH22.old
        //CH22.start
        if(mapStocks.get(jobRes.New_Comms_Hub_Serial_Number__c)!=null && mapStocks.get(jobRes.New_Comms_Hub_Serial_Number__c).size()>1 && jobRes.New_Comms_Hub_Serial_Number__c.length() > 10) {
            List<Messaging.SingleEmailMessage> emaillist = new List<Messaging.SingleEmailMessage>();
            emaillist.add(EON_Ceva_Stock_Reconciliation_Process.ProcessEmails_JobResults(mapStocks.get(jobRes.New_Comms_Hub_Serial_Number__c),
                                        jobRes,
                                        jobRes.New_Comms_Hub_Serial_Number__c,
                                        System.Label.EON_Stock_More_than_one_serial_number_Template));
            
            System.debug('***** ' + emaillist.size());
            if(!emaillist.isEmpty())
                Messaging.sendEmail(emaillist);
        }
        //CH22.end
    }
    //CH17.end
    
    
    
}