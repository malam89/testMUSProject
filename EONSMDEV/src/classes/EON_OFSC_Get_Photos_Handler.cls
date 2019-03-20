/**
    Description : This generic class will be used to get photos from OFSC
                  
    VF Page     : 
    Test Class  : EON_OFSC_Get_Photos_Handler_Test

**/
/*
    Created By  : Mahadev Joshilkar
    Created On  : 08/04/2016
    Service Req : SR_EON_Mobile_009
    Change History : CH00 # Developer_Name # Date # SR_ID # Details
    CH01 # SR_EON_OFSC_034 # 22/02/2018 # Puneet Mehta G # Added mapping for new nodes
*/
public class EON_OFSC_Get_Photos_Handler 
{
    /**
        getPhotosFromOFSC(list<id>) - This method is used to get the photos from OFSC    
        objID -> This will be any Appointment Record Salesforce ID of record in object at Isis 
    **/
    @future(callout=true)
    public static void getPhotosFromOFSC(list<ID> objID){
        String errorMessage = '';
        EON_Job_Results__c eonJobResult;
        EON_Faulty_Asset__c eonFaultAsset;
        list<Attachment> attachAll = new list<Attachment>();  //Attach Photos
        map<String, Attachment> mapOracleResponse = new map<String, Attachment>();    
        list<EON_OFSC_Photo_Property__c> allPhotoProperty = EON_OFSC_Photo_Property__c.getall().values(); //[Select Id, Name, Object_Name__c from EON_OFSC_Photo_Property__c];
        list<EON_Appointment__c> allEonAppointment = [Select ID, Name, OFSC_Appointment_ID__c, (Select ID from EON_Job_Results__r limit 1), (Select ID from EON_Faulty_Asset__r limit 1) from EON_Appointment__c where ID=:objID];
        list<Oracle_Data_Tracker__c> allOracleDataTracker = new list<Oracle_Data_Tracker__c>();
        EON_OFSC_Activity_WS.User_X userElement = EON_OFSC_Helper.getUserElementForActivity();
        EON_OFSC_Activity_WS.activity_binding request = new EON_OFSC_Activity_WS.activity_binding();
        EON_OFSC_Activity_WS.get_file_response_element response = new EON_OFSC_Activity_WS.get_file_response_element();
        try{
            for(EON_Appointment__c eonAppointment:allEonAppointment){
                if(eonAppointment.EON_Job_Results__r != null){
                    if(eonAppointment.EON_Job_Results__r.size()>0)
                        eonJobResult = eonAppointment.EON_Job_Results__r.get(0);
                }
                if(eonAppointment.EON_Faulty_Asset__r != null){
                    if(eonAppointment.EON_Faulty_Asset__r.size()>0)
                        eonFaultAsset = eonAppointment.EON_Faulty_Asset__r.get(0);
                }
                for(EON_OFSC_Photo_Property__c ofscPhotoProperty:allPhotoProperty){
                    Oracle_Data_Tracker__c callOracle = new Oracle_Data_Tracker__c();
                    callOracle.Direction__c = EON_Utility.DIRECTION_OUT;       
                    callOracle.Command__c = EON_Utility.CMD_OFSC_GetPhoto;
                    callOracle.EON_Appointment__c = eonAppointment.ID;
                    //String entity_id = '70';
                    String entity_id = eonAppointment.OFSC_Appointment_ID__c;
                    //String property_id = '478';
                    String property_id = ofscPhotoProperty.Name;
                    if(!property_id.startsWith('XA_')) //CH01
                        property_id = 'XA_' + property_id; //CH01
                    callOracle.Request_Data__c = userElement + '\n' + entity_id + '\n' + property_id;
                    response = request.get_file(userElement, entity_id, property_id);
                    if(response != null){
                        String strResponse = String.valueOf(response);
                        if(strResponse.length()>131070){
                            Attachment attach = new Attachment(body=blob.valueOf(strResponse));
                            //mapOracleResponse.put(ofscPhotoProperty.Name, attach);//CH01
                            mapOracleResponse.put(property_id, attach);//CH01
                            //callOracle.Response_Data__c = 'Large Response for Proerty Name '+ofscPhotoProperty.Name+'. Refer attachment.';//CH01
                            callOracle.Response_Data__c = 'Large Response for Proerty Name '+property_id+'. Refer attachment.';//CH01
                        }
                        else
                            callOracle.Response_Data__c = EON_Utility.validateStringLength(strResponse);
                        if(response.result_code != null){
                            string resCode = String.valueOf(response.result_code);
                            string respCodeId = [Select ID from EON_OFSC_Response_Code__c where name=: resCode and API__c='Activity' limit 1].ID;
                            if(respCodeId != null)
                                callOracle.Error_Code__c = respCodeId;
                        }
                        if(response.result_code == 0){
                            callOracle.Status__c = EON_Utility.RESULT_PASS;
                            Attachment attach = new Attachment(); 
                            attach.body = EncodingUtil.base64Decode(response.file_data); 
                            attach.contentType = 'image/jpeg';
                            attach.Name = response.file_name;
                            if(ofscPhotoProperty.Object_Name__c == 'EON_Job_Results__c'){
                                if(eonJobResult != null){
                                    attach.ParentId = eonJobResult.Id;
                                    attachAll.add(attach);
                                }
                            }
                            else if(ofscPhotoProperty.Object_Name__c == 'EON_Faulty_Asset__c'){
                                if(eonFaultAsset != null){
                                    attach.ParentId = eonFaultAsset.ID;
                                    attachAll.add(attach);
                                }
                            }
                        }
                        else
                            callOracle.Status__c = EON_Utility.RESULT_FAIL;
                    }
                    else{
                        //callOracle.Response_Data__c = 'Property Name: '+ofscPhotoProperty.Name +' Response from OFSC: '+response;//CH01
                        callOracle.Response_Data__c = 'Property Name: '+property_id+' Response from OFSC: '+response;//CH01
                        callOracle.Status__c = EON_Utility.RESULT_FAIL;
                    }
                    allOracleDataTracker.add(callOracle);
                }
            }
            insert allOracleDataTracker;
            if(mapOracleResponse.size()>0){
                list<Oracle_Data_Tracker__c> updatedOracleTracker = new list<Oracle_Data_Tracker__c>();
                updatedOracleTracker = [Select ID, Command__c, Response_Data__c from Oracle_Data_Tracker__c where ID=:allOracleDataTracker];
                for(EON_OFSC_Photo_Property__c ofscPhotoProperty:allPhotoProperty){
                    String property_id = ofscPhotoProperty.Name;//CH01
                    if(!property_id.startsWith('XA_')) //CH01
                        property_id = 'XA_' + property_id; //CH01
                    //Attachment attach = mapOracleResponse.get(ofscPhotoProperty.Name);//CH01
                    Attachment attach = mapOracleResponse.get(property_id);//CH01
                    if(Attach != null){
                        for(Oracle_Data_Tracker__c oracle:updatedOracleTracker){
                            String cmd = oracle.Response_Data__c;
                            //if(cmd.contains(ofscPhotoProperty.Name)){//CH01
                            if(cmd.contains(property_id)){//CH01
                                attach.ParentId = oracle.ID;
                                attachAll.add(attach);
                            }
                        }
                    }
                }
            }
            if(attachAll.size()>0)
                insert attachAll;   
        }
        catch(Exception ex){
            errorMessage = ex.getMessage();
        }
        finally{
            Oracle_Data_Tracker__c failTracker = new Oracle_Data_Tracker__c();
            failTracker.Command__c = EON_Utility.CMD_OFSC_GetPhoto;
            failTracker.Direction__c = EON_Utility.DIRECTION_OUT;
            failTracker.Isis_Error__c = errorMessage;
            failTracker.Status__c = EON_Utility.RESULT_FAIL;
            insert failTracker;
        }
    }
}