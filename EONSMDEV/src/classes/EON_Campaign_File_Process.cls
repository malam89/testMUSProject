/**
    Description :   This class will receive data from attachment at 'EON Caompaign' object and will send for processing to future class
                    EON_Validate_Fuel_From_Jumbo
                    VF Page     : NA
                    Test Class  : EON_Campaign_File_Process_Test 
**/
/*
        Created By : Nitin Bangar
        Created On : 01/07/2016
        Service Req : SR_EON_PC_067
        Change History :
        CH02 # 14/11/2016 # SR_EON_PC_093 # Shruti Moghe # Added Mapping for three fields in CSV file
*/
    
global class EON_Campaign_File_Process{
    public static List <String> header_row = new List <String>();
    public static List <List<String>> fileValues = new List <List<String>>();// This field holds the entair file rows after reading the file List<Rows,List<Column values>>
    public static List<String> MPRNVal = new List<String>();
    public static List<String> MPANVal = new List<String>();
    webservice static String ReadandparseCSV(String ParentRecodID){
    List<Attachment> attach = [Select id,Name,Body,contentType,parentid from Attachment where ParentId =:ParentRecodID LIMIT 1];
    List<EON_Campaign_Csv__c> csvdata = new List<EON_Campaign_Csv__c>();
    String error ='';
    Map<String, EON_Fuel__c> MapFuelMprnAll= new Map<String, EON_Fuel__c>();
    Map<String, EON_Fuel__c> MapFuelMpanAll= new Map<String, EON_Fuel__c>();
    //CH01.Old.Start
    /*list<EON_Fuel__c> lstEONFuel = [SELECT Id,Name,Premise__c,Premise__r.Name,Premise__r.Customer__r.Campaign_Flag__c,Premise__r.Customer__c,Premise__r.Customer__r.Name,Premise__r.Postcode__c,Premise__r.Customer__r.Customer_Name__c,MPAN__c,MPRN__c,Fuel_type__c FROM EON_Fuel__c Where MPAN__c!='' or MPRN__c !='']; 
    for(EON_Fuel__c fuel: lstEONFuel){
        if(fuel.MPAN__c!='')MapFuelMpanAll.put(fuel.MPAN__c,fuel);
        if(fuel.MPRN__c!='')MapFuelMprnAll.put(fuel.MPRN__c,fuel);
    }   */
    //CH01.Old.End
    try{
        if(EON_Campaign_File_Process_Test.genException == null)
           EON_Campaign_File_Process_Test.genException = false;
         if(EON_Campaign_File_Process_Test.genException == true)
          ID test = ID.valueof('test');
        if(attach!=null && attach.size()>0){
            Blob fileBody = attach[0].Body;                        
            //if(attach[0].contentType == 'application/vnd.ms-excel' || attach[0].contenttype == 'text/csv' || attach[0].contenttype == 'application/csv'){ // passing the file body as String to the CSV reader class 
                fileValues = EON_CsvReader.CampaignCSV( fileBody.toString());
                system.debug('fileValues Size = '+fileValues.size());              
                if(fileValues!=null && fileValues.size() > 0 && fileValues.get(0)!=null && fileValues.get(0).get(0) != '' ){ 
                    header_row = fileValues[0];//first row of the file contains the Headernames                                                        
                    integer rowNumber = 0, rCount = 0;   
                    //CH01.New.Start
                    //Get all EON Fuel
                    String allMPAN = '', allMPRN = '';
                    for(list <String> row: fileValues){                            
                        system.debug('**Row '+row);                 
                        if (rCount == 0){                    
                            rCount++;
                            continue;                   
                        }  
                        else{
                            if(String.isBlank(allMPAN)){
                                if(!EON_Utility.validateRequired(row[1]))
                                    allMPAN += '\''+row[1]+'\'';
                            }
                            else{
                                if(!EON_Utility.validateRequired(row[1]))
                                    allMPAN += ',\''+row[1]+'\'';
                            }
                            if(String.isBlank(allMPRN)){
                                if(!EON_Utility.validateRequired(row[0]))
                                    allMPRN += '\''+row[0]+'\'';
                            }
                            else{
                                if(!EON_Utility.validateRequired(row[0]))
                                    allMPRN += ',\''+row[0]+'\'';
                            }
                            rCount++;
                        }
                    }
                    boolean mpanExist = false;
                    String fuelQuery = 'SELECT Id,Name,Premise__c,Premise__r.Name,Premise__r.Customer__r.Campaign_Flag__c,Premise__r.Customer__c,Premise__r.Customer__r.Name,Premise__r.Postcode__c,Premise__r.Customer__r.Customer_Name__c,MPAN__c,MPRN__c,Fuel_type__c FROM EON_Fuel__c'; // Where MPAN__c in ('+allMPAN+') or MPRN__c !='''
                    if(!EON_Utility.validateRequired(allMPAN)){
                        fuelQuery += ' Where MPAN__c in ('+allMPAN+')';
                        mpanExist = true;
                     }
                    if(!EON_Utility.validateRequired(allMPAN))
                        fuelQuery += mpanExist ? (' OR MPRN__c in ('+allMPRN+')') : (' Where MPRN__c in ('+allMPRN+')');
                    list<sObject> getResult = new list<sObject>();
                    system.debug('###fuelQuery: '+fuelQuery);
                    getResult = Database.query(fuelQuery);
                    if(!getResult.isEmpty()){
                        for(sObject obj: getResult){
              EON_Fuel__c fuelRec = (EON_Fuel__c)obj;
              if(fuelRec.MPAN__c!='')MapFuelMpanAll.put(fuelRec.MPAN__c,fuelRec);
                  if(fuelRec.MPRN__c!='')MapFuelMprnAll.put(fuelRec.MPRN__c,fuelRec);                           
                        }
                    }
                    //CH01.New.End
                    for(list <String> row: fileValues){                            
                        system.debug('**Row '+row);                 
                        if (rowNumber == 0){                    
                            rowNumber++;
                            continue;                   
                        }  
                        else{
                            EON_Campaign_Csv__c csv = new EON_Campaign_Csv__c();
                            csv.name='1';
                            csv.MPRN__c= row[0];
                            csv.MPAN__c= row[1];
                            csv.Cust_ID__c=row[2];
                            csv.Premise_SFID__c=row[3];
                            csv.Cust_SFID__c= row[4];
                            csv.Campaign_Letter__c=(Row[0]==''&& row[1]=='' && row[2]!='')?'Error':'';
                            csv.Smart__c=(Row[0]==''&& row[1]=='' && row[2]!='')?'Error':'';
                            csv.Re_Cert__c=(Row[0]==''&& row[1]=='' && row[2]!='')?'Error':'';
                            csv.Opt_in_Opt_out_preference__c =row[8];
                            csvdata.add(csv);
                            error=(Row[0]==''&& row[1]=='' && row[2]!='')?'There were Error(s) processing the campaign':'';
                            if(csv.MPRN__c!=null && csv.MPRN__c!='' && MapFuelMprnAll!=null && MapFuelMprnAll.containsKey(csv.MPRN__c)){
                                  MPRNVal.add(csv.MPRN__c);
                            }
                            else{
                                csv.Campaign_Letter__c='Error';
                                csv.Smart__c='Error';
                                csv.Re_Cert__c='Error';
                            }
                            if(csv.MPRN__c=='' && csv.MPAN__c!=null && csv.MPAN__c!='' && MapFuelMpanAll!=null && MapFuelMpanAll.containsKey(csv.MPAN__c) ){
                                 MPANVal.add(csv.MPAN__c);
                            }
                            else{
                                csv.Campaign_Letter__c='Error';
                                csv.Smart__c='Error';
                                csv.Re_Cert__c='Error';
                            }
                            System.debug('-------->Reached Error 1');
                        }
                        rowNumber++;
                    }
                    list<EON_Fuel__c> lstEONFuelNew = [SELECT Id,Name,Premise__c,Premise__r.Name,Premise__r.Customer__r.Campaign_Flag__c,Premise__r.Customer__c,Premise__r.Customer__r.Name,Premise__r.Postcode__c,Premise__r.Customer__r.Customer_Name__c,MPAN__c,MPRN__c,Fuel_type__c FROM EON_Fuel__c Where MPAN__c=:MPANVal or MPRN__c =:MPRNVal];
                    Set<ID> PremiseId= new Set<ID>();
                    for(EON_Fuel__c fuel :lstEONFuelNew ){
                        PremiseId.add(fuel.Premise__c);
                    } 
                    Map<id, EON_Site__c> siteMap = new Map<id,EON_Site__c>([select id, Name,Customer__c,Customer__r.PAYG_Flag__c,Customer__r.Current_Payment_Method_Indicator__c,Customer__r.Customer_group_type__c,Customer__r.Campaign_Flag__c,(select id, name, Premise__c,Customer__c,Vulnerability_code__c from EON_Vulnerabilities__r) from EON_Site__c where id in:PremiseId]);
                    list<EON_Fuel__c> EONFuelWithMpan = [SELECT Id,Name,Premise__c,Premise__r.Name,Premise__r.Customer__r.Customer_group_type__c,Premise__r.Customer__r.Campaign_Flag__c,Premise__r.Customer__c,Premise__r.Customer__r.Name,Premise__r.Postcode__c,Premise__r.Customer__r.Customer_Name__c,MPAN__c,MPRN__c,Fuel_type__c FROM EON_Fuel__c Where MPAN__c=:MPANVal];                       
                    list<EON_Fuel__c> EONFuelWithMprn =[SELECT Id,Name,Premise__c,Premise__r.Name,Premise__r.Customer__r.Customer_group_type__c,Premise__r.Customer__r.Campaign_Flag__c,Premise__r.Customer__c,Premise__r.Customer__r.Name,Premise__r.Postcode__c,Premise__r.Customer__r.Customer_Name__c,MPAN__c,MPRN__c,Fuel_type__c FROM EON_Fuel__c Where MPRN__c =:MPRNVal];                    
                    Map<String, EON_Fuel__c> MapFuelMpan= new Map<String, EON_Fuel__c>();
                    Map<String, EON_Fuel__c> MapFuelMprn= new Map<String, EON_Fuel__c>();                   
                    for(EON_Fuel__c fuel: EONFuelWithMpan){
                        MapFuelMpan.put(fuel.MPAN__c,fuel);
                    }
                    for(EON_Fuel__c fuel: EONFuelWithMprn){
                        MapFuelMprn.put(fuel.MPRN__c,fuel);
                    }
                    //CH02.start
                    List<EON_Opt_in_Opt_Out_Preference__c> lstOptin = new List<EON_Opt_in_Opt_Out_Preference__c>();
                    lstOptin=[select id, Customer__c,Opt_In_Opt_Out_Preference__c,Premise__c from EON_Opt_in_Opt_Out_Preference__c where Premise__c IN:PremiseId];
                    Map<id, Map<id, List<EON_Opt_in_Opt_Out_Preference__c>>> mapOptIn= new Map<id, Map<id, List<EON_Opt_in_Opt_Out_Preference__c>>>();
                    for(EON_Opt_in_Opt_Out_Preference__c objOpt : lstOptin){
                        if(!mapOptIn.containsKey(objOpt.Customer__c))
                            mapOptIn.put(objOpt.Customer__c,new map<id,List<EON_Opt_in_Opt_Out_Preference__c>>());
                        if(!mapOptIn.get(objOpt.Customer__c).containsKey(objOpt.Premise__c))
                           mapOptIn.get(objOpt.Customer__c).put(objOpt.Premise__c, new List<EON_Opt_in_Opt_Out_Preference__c>());  
                        mapOptIn.get(objOpt.Customer__c).get(objOpt.Premise__c).add(objOpt);      
                    }
                    //CH02.end
                    //to populate the value of Smart column
                    for(EON_Campaign_Csv__c csv : csvData){
                        if(csv.MPRN__c!=null && csv.MPRN__c!='' ){
                            if(MapFuelMprn.get(csv.MPRN__c)!=null){
                                EON_Fuel__c fuel = MapFuelMprn.get(csv.MPRN__c);
                                //CH02.start
                                csv.Cust_ID__c= fuel.Premise__r.Customer__r.name;
                                csv.Premise_SFID__c= fuel.Premise__c;
                                csv.Cust_SFID__c=fuel.Premise__r.Customer__c;
                                if(mapOptIn.containsKey(fuel.Premise__r.Customer__c) && mapOptIn.get(fuel.Premise__r.Customer__c).containsKey(fuel.Premise__c) && mapOptIn.get(fuel.Premise__r.Customer__c).get(fuel.Premise__c).size()>0){                             
                                    csv.Opt_in_Opt_out_preference__c=mapOptIn.get(fuel.Premise__r.Customer__c).get(fuel.Premise__c)[0].Opt_In_Opt_Out_Preference__c ?'Y':'N';
                                }
                                //CH02.end
                                if(fuel.Premise__r.Customer__r.Campaign_Flag__c == true){
                                    csv.Smart__c='Y';
                                }
                                else 
                                    csv.Smart__c='N';
                                if(siteMap.get(fuel.Premise__c)!=null && siteMap.get(fuel.Premise__c).EON_Vulnerabilities__r!=null && siteMap.get(fuel.Premise__c).EON_Vulnerabilities__r.size()>0 ){
                                    csv.Campaign_Letter__c='ALLVULN001';    
                                }
                                else{
                                    if(siteMap.get(fuel.Premise__c)!=null && siteMap.get(fuel.Premise__c).Customer__r.Campaign_Flag__c){
                                        if(siteMap.get(fuel.Premise__c).Customer__r.Customer_group_type__c=='SME'){
                                            if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='D5465_07_15';
                                            if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='D') csv.Campaign_Letter__c='D5466_07_15';
                                            if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                                        }
                                        else if(siteMap.get(fuel.Premise__c).Customer__r.Customer_group_type__c=='RES'){
                                            System.debug('###'+siteMap);
                                            if(siteMap.get(fuel.Premise__c).Customer__r.Current_Payment_Method_Indicator__c=='OD'){ 
                                                if(siteMap.get(fuel.Premise__c).Customer__r.PAYG_Flag__c=='Y'){
                                                    if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='D5516_01_16';
                                                    if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='D') csv.Campaign_Letter__c='D5517_01_16';
                                                    if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                                                }
                                                else if(siteMap.get(fuel.Premise__c).Customer__r.PAYG_Flag__c=='N'){
                                                    if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='D5470_07_15';
                                                    if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='D') csv.Campaign_Letter__c='D5471_07_15';
                                                    if(MapFuelMprn.get(csv.MPRN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                                                }
                                            }
                                            else 
                                                csv.Campaign_Letter__c='TBC001';
                                           }
                                    }
                                    else{csv.Campaign_Letter__c='No Campaign Flag';}                                    
                                }      
                            }
                            else{
                                csv.Campaign_Letter__c='Error';
                                csv.Smart__c='Error';
                                csv.Re_Cert__c='Error';
                                error='There were Error(s) processing the campaign';
                                System.debug('-------->Reached Error Point2');
                            }
                        }  
                        else if(csv.MPAN__c!=null && csv.MPAN__c!='' ){
                            if(MapFuelMpan.get(csv.MPAN__c)!=null){
                                EON_Fuel__c fuel = MapFuelMpan.get(csv.MPAN__c);
                               //CH02.start
                                csv.Cust_ID__c= fuel.Premise__r.Customer__r.name;
                                csv.Premise_SFID__c= fuel.Premise__c;
                                csv.Cust_SFID__c=fuel.Premise__r.Customer__c;
                                if(mapOptIn.containsKey(fuel.Premise__r.Customer__c) && mapOptIn.get(fuel.Premise__r.Customer__c).containsKey(fuel.Premise__c) && mapOptIn.get(fuel.Premise__r.Customer__c).get(fuel.Premise__c).size()>0){                             
                                    csv.Opt_in_Opt_out_preference__c=mapOptIn.get(fuel.Premise__r.Customer__c).get(fuel.Premise__c)[0].Opt_In_Opt_Out_Preference__c ?'Y':'N';
                                }
                                //CH02.start
                                if(fuel.Premise__r.Customer__r.Campaign_Flag__c == true){
                                    csv.Smart__c='Y';
                                }
                                else 
                                    csv.Smart__c='N';
                                if(siteMap.get(fuel.Premise__c)!=null && siteMap.get(fuel.Premise__c).EON_Vulnerabilities__r!=null && siteMap.get(fuel.Premise__c).EON_Vulnerabilities__r.size()>0 ){
                                    csv.Campaign_Letter__c='ALLVULN001';    
                                }
                                else{
                                    if(siteMap.get(fuel.Premise__c)!=null && siteMap.get(fuel.Premise__c).Customer__r.Campaign_Flag__c){
                                        if(siteMap.get(fuel.Premise__c).Customer__r.Customer_group_type__c=='SME'){
                                            if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='D5465_07_15';
                                            if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='D') csv.Campaign_Letter__c='D5466_07_15';
                                            if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                                        }
                                        else if(siteMap.get(fuel.Premise__c).Customer__r.Customer_group_type__c=='RES'){
                                            if(siteMap.get(fuel.Premise__c).Customer__r.Current_Payment_Method_Indicator__c=='OD'){ 
                                                if(siteMap.get(fuel.Premise__c).Customer__r.PAYG_Flag__c=='Y'){
                                                    if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='D5516_01_16';
                                                    if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='D') csv.Campaign_Letter__c='D5517_01_16';
                                                    if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                                                }
                                                else if(siteMap.get(fuel.Premise__c).Customer__r.PAYG_Flag__c=='N'){
                                                    if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='E') csv.Campaign_Letter__c='D5470_07_15';
                                                    if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='D') csv.Campaign_Letter__c='D5471_07_15';  if(MapFuelMpan.get(csv.MPAN__c).Fuel_type__c=='G') csv.Campaign_Letter__c='';
                                                }
                                            }
                                            else 
                                                csv.Campaign_Letter__c='TBC001';
                                        }
                                    }
                                    else{csv.Campaign_Letter__c='No Campaign Flag';}
                                    }
                                } 
                                else{
                                    csv.Campaign_Letter__c='Error';
                                    csv.Smart__c='Error';
                                    csv.Re_Cert__c='Error';
                                    error='There were Error(s) processing the campaign';
                                    System.debug('-------->Reached Error Point3');
                                }                             
                            }
                        }
                        
                        List<String> fuelsAll = new List<String>();
                        fuelsAll.addAll(MPANval);
                        fuelsAll.addAll(MPRNval);                   
                        EON_Validate_Fuel_From_Jumbo resultFuel = new EON_Validate_Fuel_From_Jumbo();
                        ID batchprocessid;
                        if((MPANVal!=null && MPANVal.size()>0) && (MPRNVal!=null && MPRNVal.size()>0)){
                            System.debug('Inside the IF----->');                         
                            resultFuel.csvdata=csvdata;
                            resultFuel.attach=attach[0];
                            resultFuel.FuelAll=fuelsAll;
                            resultFuel.MpanValues=MPANval;
                            resultFuel.MprnValues=MPRNval;
                            resultFuel.MapFuelMprn=MapFuelMprn;
                            resultFuel.MapFuelMpan=MapFuelMpan;
                            batchprocessid = Database.executeBatch(resultFuel,50); 
                            System.debug(' batchprocessid------>'+ batchprocessid);
                            return batchprocessid;
                        }
                        else{
                               String finalStr = '';
                                finalStr='MPRN,MPAN,Cust ID,Premise SFID,Cust SFID,Campaign Letter,Smart ,Re-Cert,Opt in / Opt out preference'+'\n';
                                for(EON_Campaign_Csv__c csv : csvData){
                                    finalStr+=csv.MPRN__c+','+csv.MPAN__c+','+csv.Cust_ID__c+','+csv.Premise_SFID__c+','+csv.Cust_SFID__c+','+csv.Campaign_Letter__c+','+csv.Smart__c+','+'Error'+','+csv.Opt_in_Opt_out_preference__c+'\n';
                                }
                                Blob csvBlob = Blob.valueOf(finalStr);
                                String[] name =attach[0].Name.split('.csv');
                                string csvname = name[0]+'-processed.csv';
                                Attachment attProcessed = new Attachment(); 
                                attProcessed.ParentId = attach[0].parentid;
                                attProcessed.ContentType = 'text/csv';
                                attProcessed.Name = csvname;
                                attProcessed.Body = csvBlob;
                                insert attProcessed;
                                system.debug('----->'+attProcessed.id); 
                            }                                               
                    }
                //}
            } 
        }
        catch(Exception e){
            System.debug('Error Message:--'+e.getMessage());
        }
        return error;       
    }

    webservice static List<AsyncApexJob> getJobDetails(String JobId){
        List<AsyncApexJob> jobList = new List<AsyncApexJob>();
        jobList= [Select ID, Status from AsyncApexJob where ID =:JobId];
        return jobList;
    }
}