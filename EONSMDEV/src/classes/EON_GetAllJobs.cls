/**
    Description     : This controller is used to get all Job from EON and update the existing Job records.
    VF Page         : NA
    Test Class      : EON_GetAllJobs_test     
**/
/*
    Created By      : Dharmendra Pahadiya
    Created Date    : 04-Apr-2016
    Service Request : SR_EON_AB_038 && SR_EON_AB_081(Updated request structure)
    Change History  : CH01 # SR_Isis_EON_018 # 06/06/2016 # Dharmendra Pahadiya # Updated 'OrgId' mapping.
*/
global with sharing class EON_GetAllJobs {
    public static boolean isError = false;
    
    /*
        getAllJobs(string TrackerId) - This Method is used to get All Jobs from EON by calling webeservice and Create/Update all the EON Job and EON Job Attribute records.
    */
    webservice static void getAllJobs(string TrackerId){
        system.debug('in method call');
        list<EON_Data_Tracker__c> lstTracker = [select id, name, Request_Data__c, Response_Data__c, Status__c from EON_Data_Tracker__c where id =: TrackerId];
        //map<string,string> mapRecJob = new map<string,string>(); // Store Jobcode and JobDescription pair
        //map<string,set<string>> mapRecJobAttVal = new map<string,set<string>>(); // Store JobCode and JobAtt.Name+JobAtt.Value pair
        //map<string,map<string,string>> mapRecJobAttVal1 = new map<string,map<string,string>>(); // Store JobCode and JobAtt.Name+JobAtt.Value pair
        
        //WSDL Part
        try{
            //Create request
            EON_GET_Job_Service_Schema_WS.JobTypesRequestDto request = new EON_GET_Job_Service_Schema_WS.JobTypesRequestDto();
            //CH01.old //request.OrgId = userinfo.getOrganizationId();
            request.OrgId = system.label.EON_Sanbox_Name; //CH01
            request.RequestDateTime = datetime.now();
            request.RequestId = lstTracker[0].Name;//string.valueOf(crypto.getRandomLong());
            
            lstTracker[0].Request_Data__c = Eon_Utility.validateStringLength(string.valueOf(request));
            
            EON_GET_Job_Service_Schema_WS.JobTypesResponseDto response;
            
            try{
                EON_GET_Job_Service_from_EON_WS.CustomBinding_IJobService obj = new EON_GET_Job_Service_from_EON_WS.CustomBinding_IJobService();
                System.debug('@@@ The request: '+request);
                response = obj.GetAllJobTypes(request);
                System.debug('@@@ The response : '+response );
                lstTracker[0].Response_Data__c = EON_Utility.validateStringLength(string.valueof(response));
                lstTracker[0].Status__c = EON_Utility.RESULT_PASS;
                if(response.MessageReport != null && response.MessageReport.Messages != null && response.MessageReport.Messages.MessageDto != null 
                   && response.MessageReport.Messages.MessageDto[0].MessageType != null 
                   && response.MessageReport.Messages.MessageDto[0].MessageType == 'Exception'){
                    isError = true;
                    lstTracker[0].Status__c = EON_Utility.RESULT_FAIL;
                   }
            }
            catch(exception ex){
                system.debug('#### web service exception: '+ex.getmessage()+'\n'+ex.getStackTraceString());
                isError = true;
                lstTracker[0].Response_Data__c = ex.getmessage();
                lstTracker[0].Status__c = EON_Utility.RESULT_FAIL;
            }
            
            update lstTracker[0];
            
            //Processing of received data into Optimus if there is no error.
            if(!isError){
                map<string,EON_Job__c> mapJob = new map<string,EON_Job__c>();
                list<EON_Job__c> lstJobCodeIns = new list<EON_Job__c>();
                list<EON_Job__c> lstJobCodeUpd = new list<EON_Job__c>();
                set<string> setjobCode = new set<string>();
                
                //Get all Optimus Data
                list<EON_Job__c> lstJobs = new list<EON_Job__c>([select id,name,Description__c from EON_Job__c limit 25000]);
                for(EON_Job__c objJb : lstJobs){
                    mapJob.put(objJb.Name,objJb);
                }
                
                integer jobCount = response.JobCount;
                EON_GET_Job_Service_Schema_WS.JobTypeDto[] jobTypeArr = response.JobTypes.JobTypeDto; 
                for(EON_GET_Job_Service_Schema_WS.JobTypeDto JobType : jobTypeArr){
                    string jobC = jobType.JobCode;
                    string jobD = JobType.JobDesc;
                    //Update EON Job if record exists in Optimus and Job description is differnt.
                    if(string.isNotBlank(jobC) && mapJob.containsKey(jobC) && jobD != mapJob.get(jobC).Description__c){
                        EON_Job__c objJob =  mapJob.get(jobC);
                        objJob.Description__c = jobD;
                        lstJobCodeUpd.add(objJob);
                    }
                    //Insert EON Job record if no matching record is present.
                    else if(string.isNotBlank(jobC) && !mapJob.containsKey(jobC)){
                        EON_Job__c objJob = new EON_Job__c();
                        objJob.Name = jobC;
                        objJob.Description__c = jobD;
                        lstJobCodeIns.add(objJob);
                    }
                    
                }
                try{
                    if(!lstJobCodeIns.isEmpty())
                        insert lstJobCodeIns; //Insert EON Job
                    if(!lstJobCodeUpd.isEmpty())
                        update lstJobCodeUpd; //Update EON Job
                    if(EON_Utility.genException != null && EON_Utility.genException){
                        EON_Job__c objJob = new EON_Job__c();
                        objJob.Name = 'asdfghjkllhfdssffdddggrrgrrrrhrhh';
                        objJob.Description__c = 'Test';
                        insert objJob;
                    }//to generate exception
                }
                catch(exception ex){ system.debug('#### Job Insert/Update exception: '+ex.getmessage()+'\n'+ex.getStackTraceString());
                    isError = true; lstTracker[0].Error__c = ex.getmessage();
                }
                if(EON_Utility.genException != null && EON_Utility.genException) isError=False;
                if(!isError){
                    system.debug('@@@ in Job Attribute');
                    //Fetch latest EON Job data after insert/update
                    mapJob.clear();
                    list<EON_Job__c> lstJobs1 = new list<EON_Job__c>([select id,name,Description__c, (select id,name, Value__c from EON_Job_Attributes__r)  
                                                                      from EON_Job__c limit 25000]);
                    system.debug('');
                    map<string,list<EON_Job_Attribute__c>> mapJobAtt = new map<string,list<EON_Job_Attribute__c>>();
                    
                    for(EON_Job__c objJob: lstJobs1){
                        mapJob.put(objJob.Name,objJob);
                        for(EON_Job_Attribute__c objJA : objJob.EON_Job_Attributes__r){
                            if(!mapJobAtt.containskey(objJob.Name))
                                mapJobAtt.put(objJob.Name,new list<EON_Job_Attribute__c>{objJA});
                            else
                                mapJobAtt.get(objJob.Name).add(objJA);
                        }
                    }
                    
                    system.debug('@@@ map size: '+ mapJobAtt.size());
                    system.debug('@@@ map key: '+ mapJobAtt.keyset());
                    /*for(list<EON_Job_Attribute__c> lstJobAtt : mapJobAtt.values()){
                        for(EON_Job_Attribute__c objJobAtt : lstJobAtt)
                            system.debug('@@@ map objJobAtt: '+ objJobAtt.name);
                    }*/
                            
                    //For EON Job Attribute
                    list<EON_Job_Attribute__c> lstJobAttIns = new list<EON_Job_Attribute__c>();
                    
                    //Iterate thorugh the received data and create EON Job Attribute records.
                    for(EON_GET_Job_Service_Schema_WS.JobTypeDto JobType : jobTypeArr){
                        string jobC = jobType.JobCode;
                        EON_GET_Job_Service_Schema_WS.ArrayOfJobTypeAttributeDto JobAttArr = JobType.Attributes;
                        for(EON_GET_Job_Service_Schema_WS.JobTypeAttributeDto objJA : JobAttArr.JobTypeAttributeDto){
                            string JAName = objJA.Name;
                            string JAValue = objJA.Value;
                            boolean isPresent = false;
                            system.debug('@@@ cond1: ');
                            system.debug(!mapJobAtt.containsKey(jobC));
                            if(!mapJobAtt.containsKey(jobC)){ // Job Records without Job Attribute and for newly create Job
                                system.debug('@@@ in cond1 loop');
                                EON_Job_Attribute__c objJobAtt = new EON_Job_Attribute__c();
                                objJobAtt.Name = JAName;
                                objJobAtt.Value__c = JAValue;
                                objJobAtt.Eon_Job__c = mapJob.get(jobC).Id;
                                lstJobAttIns.add(objJobAtt);
                                isPresent = true;
                            }
                            system.debug('@@@ cond2: ');
                            system.debug(mapJobAtt.containsKey(jobC));
                            system.debug(!isPresent);
                            if(mapJobAtt.containsKey(jobC) && !isPresent){ // Job Records with Job Attribute
                                for(EON_Job_Attribute__c objJobA : mapJobAtt.get(jobC)){
                                    //isPresent = false;
                                    //If Job Attribute Name and Value pair doesn't exists against the Job then insert new Job Attribute
                                    if(objJobA.Name == JAName && objJobA.Value__c == JAValue){ isPresent = true; }
                                }
                                system.debug('@@@ in cond2 loop');
                                system.debug('@@@ isPresent: '+isPresent);
                                //If Job Attribute record is not present against the Job record then create new Job Attribute record.
                                if(!isPresent){
                                    EON_Job_Attribute__c objJobAtt = new EON_Job_Attribute__c();
                                    objJobAtt.Name = JAName;
                                    objJobAtt.Value__c = JAValue;
                                    objJobAtt.Eon_Job__c = mapJob.get(jobC).Id;
                                    isPresent = true;
                                    lstJobAttIns.add(objJobAtt);
                                }
                            }
                        }
                    }
                    
                    try{
                        if(!lstJobAttIns.isEmpty()){
                            system.debug('@@@ lstJobAttIns size: '+lstJobAttIns.size());
                            /*for(EON_Job_Attribute__c objJA : lstJobAttIns)
                                system.debug('%%% objJA.Name: '+objJA.Name+' objJA.Eon_Job__c: '+objJA.Eon_Job__c);*/
                            insert lstJobAttIns;
                        }
                        if(EON_Utility.genException != null && EON_Utility.genException){
                        EON_Job__c objJob = new EON_Job__c();
                        objJob.Name = 'asdfghjkllhfdssffdddggrrgrrrrhrhh';
                        objJob.Description__c = 'Test';
                        insert objJob;
                      }
                    }
                    catch(exception ex){
                        system.debug('#### Job Attribute Insert exception: '+ex.getmessage()+'\n'+ex.getStackTraceString());
                        isError = true;
                        lstTracker[0].Error__c = ex.getmessage();
                        update lstTracker[0];
                    }
                }
            }
        }catch(exception ex){system.debug('@@@ exception: '+ex.getMessage());lstTracker[0].Status__c ='FAIL';lstTracker[0].Response_Data__c = ex.getMessage(); update lstTracker[0];}
    }
    
}