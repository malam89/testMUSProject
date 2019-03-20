/**
    Description :    This class is used to send the Resource Availability to IFS                     
    Test Class  :   NGS_OFSC_Technician_getWorkSchedule_test
**/
/*
    Created By  : Tashika Gupta
    Created On  : 24/03/2017
    Service Req : SR_OptiMUS_NG_023
    Change History :
    CH01 # SR_OptiMUS_NG_036 # 29/03/2016 # Tashika Gupta # Amended the logic for creation of NGS Technician Shift records.
*/
global class  NGS_OFSC_Technician_getWorkSchedule{

    public class ResourceDetail{
    public String isWorking ='';
    public String startDate ='';
    public String workTimeEnd ='';
    public String workTimeStart ='';        
        }
        
    public static String result='PASS';
    public static String TechId='';
    public static List<NGS_Technician_Shifts__c> finalShiftsToInsert = new List<NGS_Technician_Shifts__c>();
    public static NGS_Oracle_Data_Tracker__c ngsOdataActivityObj = new NGS_Oracle_Data_Tracker__c();
    public static map<Datetime,NGS_Technician_Shifts__c> mapNGSTechsch = new map<Datetime,NGS_Technician_Shifts__c>();//CH01
    
    /**
        getWorkScheduleFromOFS() - This method is used to get work schedule from OFSC.
    **/
    webservice static List<NGS_Technician_Shifts__c> getWorkScheduleFromOFS(String technicianID){
        String endpointURL = '';
        String httpMethod = '';
        String contentTypeString = 'application/json';
        NGS_Technician__c techObj= populateTechnician(technicianID);
        TechId = techObj.id;
        String headerString = '';
        headerString = getHeaderValue();
        httpMethod = 'GET';
        contentTypeString = 'application/json';
        endpointURL = System.Label.NGS_OFSC_URL + '/ofscCore/v1/resources/'+techObj.id+'/workSchedules';
        List<String> responseString = new List<String>();
        
        ngsOdataActivityObj = new NGS_Oracle_Data_Tracker__c(Request_Data__c = endpointURL, NGS_Technician__c=techObj.id,
                                                                                        Direction__c = 'OUT', Command__c = 'Get Work Schedules');
        responseString = calloutToOFSC(endpointURL, headerString, httpMethod, contentTypeString);
        ngsOdataActivityObj.Status__c = 'Fail';
        if(responseString != null && responseString.size() > 0){
            ngsOdataActivityObj.Response_Data__c = responseString[0];
            if(Result=='PASS'){
                ngsOdataActivityObj.Status__c = 'Pass';
            }
            else{
                ngsOdataActivityObj.Status__c = 'Fail';
            }
        }
        return finalShiftsToInsert;  
    }
    
    /**
        populateTechnician() - This method is used to fetch field values of NGS Technician record
    **/
    public static NGS_Technician__c populateTechnician(String technicianID){
        NGS_Technician__c techObj = [select id,Name, Active__c,Leaving_Date__c, h_oracle_user_created__c from NGS_Technician__c where id =: technicianID];
        return  techObj;
    }
    
    public static String populateResourceDetails(NGS_Technician__c ObjTechnician){
        String jsonBody = '';
        ResourceDetail ResourceDetailObj = new ResourceDetail();
        return null;                          
    }
    
    /**
        getHeaderValue() - This method return 
    **/
    public static String getHeaderValue(){
        String headerString = '';
        headerString = System.Label.NGS_OFSC_API_USER + '@' + System.Label.NGS_OFSC_COMPANY + ':' + System.Label.NGS_OFSC_API_PASSWORD;
        return headerString;                           
    }
    
    /**
        calloutToOFSC() - This method return 
    **/
    public static List<String> calloutToOFSC(String endpointURL, String headerString, String httpMethod, String contentTypeString){
        List<String> responseString = new List<String>();
        List<ShiftsDetails> ListDetails = new List<ShiftsDetails>();
        Map<String, String> DayofWeek = new Map<String, String>{'Sunday'=>'Sun','Monday'=>'Mon','Tuesday'=>'Tue','Wednesday'=>'Wed','Thursday'=>'Thu', 'Friday'=>'Fri','Saturday'=>'Sat'};
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointURL);
        Blob headerValue = Blob.valueOf(headerString);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod(httpMethod);
        HttpResponse res = h.send(req);
        responseString.add(res.getBody());
        JSONParser parser = JSON.createParser(res.getBody());
        if(res.getStatus() == 'OK' && res.getStatusCode() == 200){
           // Parse entire JSON response.
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            ShiftsDetails Shift = (ShiftsDetails)parser.readValueAs(ShiftsDetails.class);
                            String s = JSON.serialize(Shift);
                            // Skip the child start array and start object markers.
                            parser.skipChildren();
                            ListDetails.add(Shift);
                        }
                    }
                }
              if(parser.getText() == 'totalResults'){
                    parser.nextValue();
                    result='PASS';
                    responseString.add(parser.getText());
                }   
            }
        }
        else if(res.getStatus() == 'Bad Request' && res.getStatusCode()== 400){
            while(parser.nextToken() != null){
                if(parser.getText() == 'detail'){
                    parser.nextValue();
                    responseString.add(parser.getText());
                    Result='FAIL';
                }
            }
        }
        else{
            responseString.add(res.getStatus());
        }
        system.debug('@@@@@@@@--->'+responseString);
        //CH01.Start
        system.debug('ListDetails--->'+ListDetails);
        Boolean isCreated = false;
        Date endDateIsWorkingCheck = Date.today()+42;
        for(ShiftsDetails shift : ListDetails){
            system.debug('shift--->'+shift);
            Date startDateCheck = shift.startDate!=null ?Date.valueof(shift.startDate): null;
            Date endDateCheck = shift.endDate!=null ?Date.valueof(shift.endDate): null;
            //Date endDateIsWorkingCheck = Date.today()+42;
            
            if(isCreated==false && shift.scheduleShifts!=null && shift.scheduleShifts.size()>0 && (startDateCheck>=date.today() || (startDateCheck<date.today() &&( (endDateCheck!=null && endDateCheck>=date.today()) || endDateCheck ==null )))){
                System.debug('****Inside the if loop ****');
                Map<String,boolean> daysvalue = new Map<String,boolean>();
                if(shift.scheduleShifts[0]!=null && shift.scheduleShifts[0].weekdays!=null) for(String day : shift.scheduleShifts[0].weekdays) daysvalue.put(day,true);
                for(Integer i=0; i<42 ;i++){
                    NGS_Technician_Shifts__c shiftObj1 = new NGS_Technician_Shifts__c();
                    shiftObj1.Shift_Date__c= date.today()+i;
                    shiftObj1.Shift_Start__c= shift.scheduleShifts[0].workTimeStart;
                    shiftObj1.Shift_End__c= shift.scheduleShifts[0].workTimeEnd;
                    shiftObj1.Shift_Type__c= String.isNotBlank(shift.recordType)?shift.recordType:''; 
                    shiftObj1.Shift_Label__c= String.isNotBlank(shift.scheduleLabel)?shift.scheduleLabel:'';
                    shiftObj1.Employee_ID__c= TechId; 
                    shiftObj1.IsWorking__c=true;
                    system.debug('day value '+daysvalue.containskey(DayofWeek.get((Datetime.newInstance(shiftObj1.Shift_Date__c,time.newInstance(0,0,0,0))).format('EEEE'))));
                    if( shift.scheduleShifts[0].weekdays!=null && daysvalue.containskey(DayofWeek.get((Datetime.newInstance(shiftObj1.Shift_Date__c,time.newInstance(0,0,0,0))).format('EEEE'))))
                    {
                        System.debug('Inside working check');
                        if(endDateCheck!=null){
                            if(endDateCheck<=endDateIsWorkingCheck)
                                shiftObj1.IsWorking__c=true;
                            else shiftObj1.IsWorking__c=false;
                            System.debug('Inside loop1');
                        }
                        else shiftObj1.IsWorking__c=true;
                    }
                    else if(shift.scheduleShifts[0].weekdays==null){
                        if(endDateCheck!=null){
                            if(endDateCheck<=endDateIsWorkingCheck)
                                shiftObj1.IsWorking__c=true;
                            else shiftObj1.IsWorking__c=false;
                            System.debug('Inside loop2');
                        }
                        else shiftObj1.IsWorking__c=true;
                    }
                    else shiftObj1.IsWorking__c=false;
                    mapNGSTechsch.put(shiftObj1.Shift_Date__c,shiftObj1);
                }
                isCreated = true;
            }
            
            if(isCreated ==true && shift.scheduleShifts!=null && shift.scheduleShifts.size()>0 ){
                Date EndDateCount,StartDateCount  ;
                
                if(shift.scheduleShifts[0].endDate!=null && shift.scheduleShifts[0].endDate!='' && mapNGSTechsch.containsKey(Date.valueof(shift.scheduleShifts[0].endDate))){
                    StartDateCount = shift.startDate!=null ? Date.valueof(shift.startDate): null;
                    EndDateCount = shift.endDate!=null ? Date.valueof(shift.endDate): null;
                }
                else if(shift.scheduleShifts[0].startDate!=null && shift.scheduleShifts[0].startDate!='' && mapNGSTechsch.containsKey(Date.valueof(shift.scheduleShifts[0].startDate))){
                    StartDateCount = shift.startDate!=null ? Date.valueof(shift.startDate): null;
                    EndDateCount = Date.today()+42;
                }
                Map<String,boolean> daysvalue = new Map<String,boolean>();
                Map<String,boolean> daysvalue1 = new Map<String,boolean>();
                if(shift.scheduleShifts.size()>1 && shift.scheduleShifts[1]!=null){
                        if(shift.scheduleShifts[1]!=null && shift.scheduleShifts[1].weekdays!=null) for(String day : shift.scheduleShifts[1].weekdays) daysvalue1.put(day,true);
                            
                }
                Integer DaysBetweenDates = StartDateCount!=null && EndDateCount!=null?StartDateCount.daysBetween(EndDateCount):null;
                if(shift.scheduleShifts[0]!=null && shift.scheduleShifts[0].weekdays!=null) for(String day : shift.scheduleShifts[0].weekdays) daysvalue.put(day,true);
                
                for(Integer i=0;i<=DaysBetweenDates;i++){
                    System.debug('Loop no. '+i);
                    system.debug('mapNGSTechsch'+mapNGSTechsch);
                    NGS_Technician_Shifts__c shiftObj2 = new NGS_Technician_Shifts__c();
                    if(mapNGSTechsch.containsKey(StartDateCount+i) && mapNGSTechsch.get(StartDateCount+i).Employee_ID__c!=null && mapNGSTechsch.get(StartDateCount+i).Employee_ID__c==TechId){
                        shiftObj2 = mapNGSTechsch.remove(StartDateCount+i);
                        shiftObj2.Shift_Start__c= shift.scheduleShifts[0].workTimeStart;
                        shiftObj2.Shift_End__c= shift.scheduleShifts[0].workTimeEnd;
                        shiftObj2.Shift_Type__c= String.isNotBlank(shift.recordType)?shift.recordType:''; 
                        shiftObj2.Shift_Label__c= String.isNotBlank(shift.scheduleLabel)?shift.scheduleLabel:'';
                        shiftObj2.Employee_ID__c= TechId; 
                        shiftObj2.IsWorking__c=true;
                        if( shift.scheduleShifts[0].weekdays!=null && daysvalue.containskey(DayofWeek.get((Datetime.newInstance(shiftObj2.Shift_Date__c,time.newInstance(0,0,0,0))).format('EEEE'))))
                        {
                            if(EndDateCount!=null){
                                if(EndDateCount<=endDateIsWorkingCheck)
                                    shiftObj2.IsWorking__c=true;
                                else shiftObj2.IsWorking__c=false;
                            }
                            else shiftObj2.IsWorking__c=true;
                        }
                        else if(shift.scheduleShifts[0].weekdays==null){
                            if(EndDateCount!=null){
                                if(EndDateCount<=endDateIsWorkingCheck)
                                    shiftObj2.IsWorking__c=true;
                                else shiftObj2.IsWorking__c=false;
                            }
                            else shiftObj2.IsWorking__c=true;
                        }
                        else shiftObj2.IsWorking__c=false;
                        if(shift.scheduleShifts.size()>1 && shift.scheduleShifts[1]!=null){system.debug(shift.scheduleShifts[1]);}
                        if(shift.scheduleShifts.size()>1 && shift.scheduleShifts[1]!=null){
                            if( shift.scheduleShifts[1].weekdays!=null && shiftObj2.Shift_Date__c!=null  )
                            if(daysvalue1.containskey(DayofWeek.get((Datetime.newInstance(shiftObj2.Shift_Date__c,time.newInstance(0,0,0,0))).format('EEEE'))))
                            {
                                shiftObj2.Shift_Start__c= shift.scheduleShifts[1].workTimeStart;
                                shiftObj2.Shift_End__c= shift.scheduleShifts[1].workTimeEnd;
                                shiftObj2.IsWorking__c=true;        
                            }   
                        }
                        
                        mapNGSTechsch.put(shiftObj2.Shift_Date__c,shiftObj2);
                    }
                    
                }   
            
            }
            
            //finalShiftsToInsert = mapNGSTechsch.values();
        }
        
        for(ShiftsDetails shift : ListDetails) {
            if(shift.recordType=='extra_shift'){
                Date StartDate = shift.startDate!=null ? Date.valueof(shift.startDate): null;
                Date EndDate = shift.endDate!=null ? Date.valueof(shift.endDate): null;
                Integer DaysBetweenDates = StartDate.daysBetween(EndDate);
                system.debug('daysbetween'+DaysBetweenDates);
                for(Integer i=0;i<=DaysBetweenDates;i++){
                    System.debug('Loop no. '+i);
                    system.debug('mapNGSTechsch'+mapNGSTechsch);
                    NGS_Technician_Shifts__c shiftObj3 = new NGS_Technician_Shifts__c();
                    if(mapNGSTechsch.containsKey(StartDate+i) && mapNGSTechsch.get(StartDate+i).Employee_ID__c!=null && mapNGSTechsch.get(StartDate+i).Employee_ID__c==TechId){
                        shiftObj3 = mapNGSTechsch.remove(StartDate+i);
                        shiftObj3.IsWorking__c = true;
                        shiftObj3.Shift_Type__c= String.isNotBlank(shift.recordType)?shift.recordType:''; 
                        shiftObj3.Shift_Label__c= String.isNotBlank(shift.shiftLabel)?shift.shiftLabel:'';
                        shiftObj3.Shift_Start__c= shift.workTimeStart;
                        shiftObj3.Shift_End__c= shift.workTimeEnd;
                        mapNGSTechsch.put(shiftObj3.Shift_Date__c,shiftObj3);
                    }
                }
            }
            if(shift.recordType=='extra_working'){
                Date StartDate = shift.startDate!=null ? Date.valueof(shift.startDate): null;
                Date EndDate = shift.endDate!=null ? Date.valueof(shift.endDate): null;
                Integer DaysBetweenDates = StartDate.daysBetween(EndDate);
                system.debug('daysbetween'+DaysBetweenDates);
                for(Integer i=0;i<=DaysBetweenDates;i++){
                    System.debug('Loop no. '+i);
                    system.debug('mapNGSTechsch'+mapNGSTechsch);
                    NGS_Technician_Shifts__c shiftObj4 = new NGS_Technician_Shifts__c();
                    if(mapNGSTechsch.containsKey(StartDate+i) && mapNGSTechsch.get(StartDate+i).Employee_ID__c!=null && mapNGSTechsch.get(StartDate+i).Employee_ID__c==TechId){
                        shiftObj4 = mapNGSTechsch.remove(StartDate+i);
                        shiftObj4.IsWorking__c = true;
                        shiftObj4.Shift_Type__c= String.isNotBlank(shift.recordType)?shift.recordType:''; 
                        shiftObj4.Shift_Label__c= String.isNotBlank(shift.shiftLabel)?shift.shiftLabel:'';
                        shiftObj4.Shift_Start__c= shift.workTimeStart;
                        shiftObj4.Shift_End__c= shift.workTimeEnd;
                        mapNGSTechsch.put(shiftObj4.Shift_Date__c,shiftObj4);
                    }
                }
            }
            //finalShiftsToInsert = mapNGSTechsch.values();
        }
        finalShiftsToInsert = mapNGSTechsch.values();
        //CH01.End
        return responseString;
    }
    
    public class ShiftsDetails{
        String recordType;
        String startDate;
        String endDate;
        String shiftLabel;
        String shiftType;
        String workTimeStart;
        String workTimeEnd;
        String isWorking;
        String scheduleItemId;
        String scheduleLabel;
        List<scheduleShifts> scheduleShifts;
    }
    
    public class scheduleShifts{
        String recordType;
        String startDate;
        String endDate;
        String scheduleLabel;
        String shiftType;
        String workTimeStart;
        String workTimeEnd;
        String isWorking;
        List<String> weekdays;
    }
}