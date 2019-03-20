/**
    Description :    This class is used to send the Resource Availability to IFS                     
    Test Class  :   NGS_S1_Send_ResourceAvailability_to_IFS_Test
**/
/*
    Created By  : Shruti Moghe
    Created On  : 23/03/2017
    Service Req : SR_OptiMUS_NG_027
    Change History
*/
global class  NGS_S1_Send_ResourceAvailability_to_IFS{
    public static void Send_ResourceAvailability(List<NGS_Technician_Shifts__c> ListShifts){
        IFS_Data_Tracker__c ifsDataTrackerObj = new IFS_Data_Tracker__c();
        ifsDataTrackerObj.Direction__c = 'OUT';
        ifsDataTrackerObj.Command__c = 'S1 SEND SHIFTS';
        ifsDataTrackerObj.Request_Data__c = '';
        List<NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shiftAvailability> availabilities = new List<NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shiftAvailability>();
        NGS_S1_ResourceAvailabiltiy_IFS_WS.ReceiveShiftPort request = new NGS_S1_ResourceAvailabiltiy_IFS_WS.ReceiveShiftPort();
        NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfoResponse response;
        //List<NGS_Technician_Shifts__c> ListShifts = new List<NGS_Technician_Shifts__c>([select id,Name,Employee_ID__c,Employee_ID__r.name,Shift_Date__c,Shift_Start__c,Shift_End__c,IsWorking__c from NGS_Technician_Shifts__c]);
        SET<ID> Ids= new SET<ID>();
         for(NGS_Technician_Shifts__c objShift: ListShifts){
            Ids.add(objShift.Employee_ID__c);
         }
        Map<id,NGS_Technician__c> techlist  = new Map<id,NGS_Technician__c>([select id,name,Sent_to_IFS__c from NGS_Technician__c where id in:Ids and  Sent_to_IFS__c=true]);
        for(NGS_Technician_Shifts__c objShift: ListShifts){
        if(techlist!=null && techlist.size()>0 && techlist.get(objShift.Employee_ID__c)!=null){
                NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shiftAvailability  Availability = new  NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shiftAvailability();
                Availability.employeeId=techlist.get(objShift.Employee_ID__c).name;
                Availability.shiftDate=objShift.Shift_Date__c;
                if(objShift.Shift_Start__c!=null){
                    String[] StartTIme=objShift.Shift_Start__c.split(':');
                    Availability.shiftStartTime  = DateTime.newInstance(objShift.Shift_Date__c, Time.newInstance(Integer.valueof(StartTIme[0]), Integer.valueof(StartTIme[1]), 0, 0));
                   // Availability.shiftStartTime  = Availability.shiftStartTime!=null ? Utility.getNewdatetimeAdd(Availability.shiftStartTime) :Availability.shiftStartTime;                  
                }
                if(objShift.Shift_End__c!=null){
                    String[] FinishTime=objShift.Shift_End__c.split(':'); 
                    Availability.shiftFinishTime =DateTime.newInstance(objShift.Shift_Date__c,Time.newInstance(Integer.valueof(FinishTIme[0]), Integer.valueof(FinishTIme[1]), 0, 0));
                  //  Availability.shiftFinishTime  = Availability.shiftFinishTime!=null ? Utility.getNewdatetimeAdd(Availability.shiftFinishTime) :Availability.shiftFinishTime;
                }
                Availability.active=objShift.IsWorking__c==true ? 'TRUE' : 'FALSE';
                Availability.serviceProvider='SP02';
                availabilities.add(Availability);
            }
        }
        NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shifts  Shifts = new  NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shifts();
        Shifts.availabilities=availabilities;
        NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfo receiveShiftInfo = new NGS_S1_ResourceAvailabiltiy_IFS_WS.receiveShiftInfo();
        receiveShiftInfo.ngsHrSp1In =Shifts;
        ifsDataTrackerObj.Request_Data__c = Utility.validateStringLength(receiveShiftInfo + '\n');
        Blob headerValue = Blob.valueOf(System.Label.NGS_IFS_USER + ':' + System.Label.NGS_IFS_PASSWORD);
        request.inputHttpHeaders_x = new Map<String, String>();
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.inputHttpHeaders_x.put('Authorization', authorizationHeader);
        try{
            if(!Test.isrunningTest()){ 
            NGS_S1_TypesResourceAvailabiltiy_IFS_WS.shifts result = request.receiveShiftInfo(Shifts); 
            //response.return_x=request.receiveShiftInfo(Shifts);
            system.debug('##### '+result);
            ifsDataTrackerObj.Status__c = 'PASS';
            ifsDataTrackerObj.Response_Data__c = String.valueof(result ); }
            insert ifsDataTrackerObj;
                         
        }   
        catch(System.CalloutException ex){
            system.debug(String.valueof(response));
            system.debug(String.valueof(ex));
            ifsDataTrackerObj.Status__c = 'FAIL'; 
            ifsDataTrackerObj.Response_Data__c = String.valueof(response);
            ifsDataTrackerObj.Error__c = ex.getMessage()+'\n'+ ex.getStackTraceString();
            upsert ifsDataTrackerObj;           
        }
    }
    webservice static void ResourceAvailibilityCall(){
        Database.executeBatch(new NGS_OFSC_Technician_getWorkScheduleBatch(),5);

    }
}