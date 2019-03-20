/**
    Description :   This class will receive data from attachment at 'EON Caompaign' object and will process to get data from JUMBO
                    EON_Validate_Fuel_From_Jumbo
                    VF Page     : NA
                    Test Class  : EON_Validate_Fuel_From_Jumbo_Test 
**/
/*
        Created By : SHRUTI MOGHE
        Created On : 01/07/2016
        Service Req : SR_EON_PC_067
        Change History :        
*/

global class EON_Validate_Fuel_From_Jumbo implements Database.Batchable<String> ,database.stateful,Database.AllowsCallouts {
    global map<String, String> FuelResult; //map<MPAN/MPRN, True/False>
    global List<String> MpanValues;
    global List<String> MprnValues ;                    //Either E or G
    global boolean isError;
    global string Message;
    global Map<String, EON_Fuel__c> MapFuelMpan;
    global Map<String, EON_Fuel__c> MapFuelMprn;
    global List<EON_Campaign_Csv__c> csvdata;
    global Attachment attach;
    global boolean status=false;
    global List<String> FuelAll;
    global Iterable<String> start(Database.BatchableContext BC){
        Iterable<String> allFuel = FuelAll;
        return allFuel;
    }
    global void execute(Database.BatchableContext bc,  list<String> fuelDetails){
        FuelResult=new map<String, String>(); 
        isError = false;
        List<JUMBO_Data_Tracker__c> ElecList = new List<JUMBO_Data_Tracker__c>();
        List<JUMBO_Data_Tracker__c> GasList = new List<JUMBO_Data_Tracker__c>();
        //String validMarketPartipantId = System.Label.EON_Jumbo_Supplier;
        //String ValidAbbrName = System.Label.EON_Jumbo_Gas_Supplier ;
            List<String> elecFuels = new List<String>();
            
            for(String mpan1 : MpanValues){
                for(String fuel : fuelDetails){
                    if(fuel==mpan1){
                        elecFuels.add(fuel);
                        break;
                    }
                }
            }
            List<String> gasFuels = new List<String>();
            for(String mprn1 : MprnValues){
                for(String fuel : fuelDetails){
                    if(fuel==mprn1){
                        gasFuels.add(fuel);
                        break;
                    }
                }
            }
            for(String fuel: elecFuels){
                EON_Jumbo_ReqElectricityMOP.MOPValidationResponse result = new EON_Jumbo_ReqElectricityMOP.MOPValidationResponse();  //To validate we are MOP	//TODO.Start	//Call EON_Jumbo_ReqElectricityMOP
                result = EON_Jumbo_ReqElectricityMOP.ValidateMPANMOP(fuel);
                JUMBO_Data_Tracker__c elecTracker = EON_Jumbo_ReqElectricityMOP.cTrack;	//TODO.End
                elecTracker.Command__c = JUMBO_Utility.CMD_JUMBO_CampaignMPAN;    
                System.debug('Result for elec---->'+result.marParticipantId);
                if(result.isError == false){
                    elecTracker.Status__c = EON_Utility.RESULT_PASS;                    
                    //String receivedMarketPartipantId = result.marParticipantId;
                    if(result.marParticipantId != null && result.marParticipantId!='')
                    { FuelResult.put(fuel, 'Y'); } else {FuelResult.put(fuel, 'N');}
                     System.debug('------>'+FuelResult);
                }
                else{
                    elecTracker.Status__c = EON_Utility.RESULT_FAIL;
                    FuelResult.put(fuel, 'N');
                    isError = true;
                    Message = result.Error;                   
                }
                ElecList.add(elecTracker);
            }           
            for(String fuel: gasFuels){
                EON_Jumbo_ReqGasMAM.MAMValidationResponse result = new EON_Jumbo_ReqGasMAM.MAMValidationResponse();//To validate we are MAM		//TODO.Start	//Call EON_Jumbo_ReqGasMAM
                result = EON_Jumbo_ReqGasMAM.ValidateMPRNMAM(fuel);
                JUMBO_Data_Tracker__c gasTracker = EON_Jumbo_ReqGasMAM.cTrack;	//TODO.End
                gasTracker.Command__c = JUMBO_Utility.CMD_JUMBO_CampaignMPRN;
                System.debug('Result for gas---->'+result.abbrvtdName);
                if(result.isError == false){
                    gasTracker.Status__c = EON_Utility.RESULT_PASS;
                    String receivedMarketPartipantId = result.abbrvtdName;
                    if(result.abbrvtdName!=null && result.abbrvtdName!='')
                    {FuelResult.put(fuel, 'Y');}else { FuelResult.put(fuel, 'N');}
                }
                else{
                    gasTracker.Status__c = EON_Utility.RESULT_FAIL;
                    FuelResult.put(fuel, 'N');
                    isError = true;
                    Message = result.Error;
                    //break;
                }
                GasList.add(gasTracker);
            }
            
            if(GasList!=null && GasList.size()>0) insert GasList;
            if(ElecList!=null && ElecList.size()>0) insert ElecList;
    }
    global void finish(Database.BatchableContext bc){
        status=true;
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        System.debug('------>'+FuelResult);
        System.debug('------>'+iserror);
        //CH01.start
        for(EON_Campaign_Csv__c csv : csvData){
               if(csv.MPRN__c!=''&& FuelResult!=null && FuelResult.size()>0){
                    csv.Re_Cert__c=FuelResult.get(csv.MPRN__c);
                    if(csv.Campaign_Letter__c=='No Campaign Flag' && FuelResult.get(csv.MPRN__c)!='Error'){
                        if(MapFuelMprn.get(csv.MPRN__c).Premise__r.Customer__r.Customer_group_type__c=='SME'){
                            if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='TBC002';
                            if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='D') csv.Campaign_Letter__c='TBC003';
                            if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                        }
                        else if(MapFuelMprn.get(csv.MPRN__c).Premise__r.Customer__r.Customer_group_type__c=='RES'){                                   
                            if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='D5003_07_15';
                            if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='D') csv.Campaign_Letter__c='D5002_07_15';
                            if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                        }
                    }
                    else if(csv.Campaign_Letter__c=='No Campaign Flag' && FuelResult.get(csv.MPRN__c)=='Error'){csv.Campaign_Letter__c='';}
                    
               }               
               if(csv.MPRN__c==''&& csv.MPAN__c!=null && FuelResult!=null && FuelResult.size()>0){
                    csv.Re_Cert__c=FuelResult.get(csv.MPAN__c);
                    
                        if(csv.Campaign_Letter__c=='No Campaign Flag' && FuelResult.get(csv.MPAN__c)!='Error'){
                            if(MapFuelMpan.get(csv.MPAN__c).Premise__r.Customer__r.Customer_group_type__c=='SME'){
                                if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='TBC002';
                                if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='DF') csv.Campaign_Letter__c='TBC003';
                                if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                            }
                            else if(MapFuelMpan.get(csv.MPAN__c).Premise__r.Customer__r.Customer_group_type__c=='RES'){
                                if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='D5003_07_15';
                                if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='DF') csv.Campaign_Letter__c='D5002_07_15';
                                if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                            }
                        }
                        else if(csv.Campaign_Letter__c=='No Campaign Flag' && FuelResult.get(csv.MPAN__c)=='Error'){ csv.Campaign_Letter__c='';  }                        
               }
               if(csv.Re_Cert__c==null) csv.Re_Cert__c='Error';               
                  System.debug('Re-cert value----->'+csv.Re_Cert__c);
                  
        }//CH01.end
        String finalStr = '';
        finalStr='MPRN,MPAN,Cust ID,Premise SFID,Cust SFID,Campaign Letter,Smart ,Re-Cert,Opt in / Opt out preference'+'\n';
        for(EON_Campaign_Csv__c csv : csvData){
            finalStr+=csv.MPRN__c+','+csv.MPAN__c+','+csv.Cust_ID__c+','+csv.Premise_SFID__c+','+csv.Cust_SFID__c+','+csv.Campaign_Letter__c+','+csv.Smart__c+','+csv.Re_Cert__c+','+csv.Opt_in_Opt_out_preference__c+'\n';
        }
        Blob csvBlob = Blob.valueOf(finalStr);
        String[] name =attach.Name.split('.csv');
        string csvname = name[0]+'-processed.csv';
        Attachment attProcessed = new Attachment(); 
        attProcessed.ParentId = attach.parentid;
        attProcessed.ContentType = 'text/csv';
        attProcessed.Name = csvname;
        attProcessed.Body = csvBlob;
        insert attProcessed;
        system.debug('----->'+attProcessed.id);
       
    } 
    
}