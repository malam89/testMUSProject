/**
    Description : This class will be used for generating WSDL, so that EON can use this WSDL to create Reservation in Isis.
                                    
    Test Class  : EON_CreateReservation_In_Isis_test

**/
/*
    Created By  : Praveen G
    Created On  : 15/03/2016
*/
global with sharing class EON_CreateReservation_In_Isis_WS_TEST {
    /**
        Description : Request Parameter 1 / Response Parameter
    **/
    global with sharing class HeaderElement {
        Webservice String OrgId;
        Webservice String RequestId;
        Webservice datetime RequestDateTime;
    }
    /**
        Description : Request Parameter 2
    **/
    global with sharing class Timelement {
        Webservice Integer Hours;
        Webservice Integer Minutes;
    }
    /**
        Description : Request Parameter 3
    **/
    global with sharing class AppointmentDetailElement {
        Webservice String EONAppointmentID;
        Webservice Date AppointmentDate;
        Webservice Timelement StartTime;
        Webservice Timelement EndTime;
        Webservice String TimeSlot;
    }
    /**
        Description : Request Parameter 4
    **/
    global with sharing class JobAttributeElement {
        Webservice String Name;
        Webservice String Value;
    }
    /**
        Description : Request Parameter 5
    **/
    global with sharing class JobAttributesElement {
        Webservice list < JobAttributeElement > JobAttribute;
    }
    /**
        Description : Request Parameter 6
    **/
    global with sharing class JobTypeElement {
        Webservice String JobCode;
        Webservice String JobDesc;
        Webservice JobAttributesElement JobAttributes;
    }
    /**
        Description : Request Parameter 7
    
    global with sharing class JobTypesElement {  
        Webservice list<JobTypeElement> JobTypes;
    }
    **/
    /**
        Description : Request Parameter 8
    **/
    global with sharing class MeterPointElement {
        Webservice String MPxN;
        Webservice String FuelType;
    }
    /**
        Description : Request Parameter 9
    **/
    global with sharing class MeterPointsElement {
        Webservice list < MeterPointElement > MeterPoint;
    }
    /**
        Description : Request Parameter 10
    **/
    global with sharing class CreateReservation {
        Webservice HeaderElement Header;
        Webservice String BookingSystemName;
        Webservice String AssistedWorkReason;
        Webservice AppointmentDetailElement AppointmentDetails;
        Webservice JobTypeElement JobType;
        Webservice MeterPointsElement MeterPoints;
    }

    /**
        Description : Response 1
    **/
    global with sharing class errMessage {
        Webservice String MessageType;
        Webservice integer MessageId;
        Webservice String MessageText;
    }
    /**
        Description : Response 2
    **/
    global with sharing class errMessageLst {
        Webservice list < errMessage > Message;
    }
    /**
        Description : Response 3
    **/
    global with sharing class Isis_Response_Acknowledgement_To_EON {
        Webservice HeaderElement Header;
        Webservice Datetime ReservationCreationDate;
        Webservice String ExternalAppointmentID;
        Webservice String EONAppointmentID;
        Webservice errMessageLst Messages;
    }
    /**
        Description : validateStringLen
    **/
    public static String validateStringLen(String value, integer len) {
            if (value != null && value.length() > len)
                value = value.subString(0, len);
            return value;
        }
        /**
            Description : checkLength
        **/
    public static String checkLength(String val) {
            if (String.isNotBlank(val) && val.length() == 1) {
                val = '0' + val;
            }
            return val;
        }
        /**
            Isis_Response_Acknowledgement_To_EON CreateReservation(CreateReservation Reservation) - 
                    This method is used to get create Reservation from Isis.
        **/
    webservice static Isis_Response_Acknowledgement_To_EON CreateReservation(CreateReservation Reservation) {
        Isis_Response_Acknowledgement_To_EON response = new Isis_Response_Acknowledgement_To_EON();
        
        EON_Appointment__c app = new EON_Appointment__c();
        insert app;
        
        //Internal webservice call to send it to OFSC.
       
        /**
       
        Http h = new Http();
        Httprequest req = new Httprequest();
        req.setMethod('GET');
        req.setBody(''+app.id);
        req.setEndpoint('https://eonsmdev-morrisonus.cs83.force.com/OFSC/services/apexrest/outboundEON2/');
        h.send(req);        
        
        **/
        List<Oracle_Data_Tracker__c> lstODT = [select id from Oracle_Data_Tracker__c order by createddate desc limit 1];
        System.debug('lstODT***** ' + lstODT);
        
        return response;
    }    

}