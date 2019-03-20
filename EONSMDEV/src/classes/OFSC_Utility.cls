/**
    Description : This class is used for utility methods for OFSC interface
**/
/*
    Created By : Praveen G
    Created Date : 30/06/2017
    Service Request : 
*/

public with sharing class OFSC_Utility{

    /**
        convertDataElementInToXML(EON_OFSC_Inbound_WS.DataElement dataElement) - This method is used to convert OFSC inbound interface request into XML
    **/
    public Static String convertDataElementInToXML(EON_OFSC_Inbound_WS.DataElement dataElement){
        String resultXML = '<data><commands><command>';
        
        try{
            resultXML += '<date>' + dataElement.commands.command[0].date_x + '</date>';
            resultXML += '<type>' + dataElement.commands.command[0].type_x + '</type>';
            resultXML += '<external_id>' + dataElement.commands.command[0].external_id + '</external_id>';
            
            resultXML += '<appointment>';
            resultXML += '<appt_number>' + dataElement.commands.command[0].appointment.appt_number  + '</appt_number>';
            resultXML += '<worktype_label >' + dataElement.commands.command[0].appointment.worktype_label + '</worktype_label >';
            resultXML += '<address>' + dataElement.commands.command[0].appointment.address + '</address>';
            
            resultXML += '<properties>';
            for(EON_OFSC_Inbound_WS.PropertyElement property :
                                dataElement.commands.command[0].appointment.properties.property){
                resultXML += '<property>';                
                resultXML += '<label>' + property.label + '</label>'; 
                resultXML += '<value>' + property.value + '</value>';
                resultXML += '</property>';                               
            }
            
            resultXML += '</properties>';
            resultXML += '</appointment></command></commands></data>';
        }catch(Exception ex){
            System.debug('***Exception Occured : ' + ex.getStackTraceString());
        }
        return resultXML;
    }
}