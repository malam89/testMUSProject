/**
    Description : This class is the controller for EON Complaint Object to Override the Existing New button.
                  
    VF Page     : EON_Complaint_New_Override
    Test Class  : EON_Complaint_Controller_Test

**/
/*
    Created By  : Mehboob Alam
    Created On  : 02/10/2017
    Service Req : SR_OptiMUS_EON_104,SR_OptiMUS_EON_105,SR_OptiMUS_EON_106
    Change History
*/
public with sharing class EON_Complaint_Controller{
    public EON_Complaint__c eComplaint;
    public boolean dspVoice {get;set;} 
    
    public EON_Complaint_Controller(ApexPages.StandardController stdController){
        this.eComplaint = (EON_Complaint__c)stdController.getRecord();
        
        
        //This block of code run when user create Complaint from Eon Appointment record
        if(System.currentPageReference().getParameters().containsKey('ApptId')){
           id ApptID = System.currentPageReference().getParameters().get('ApptId');
           EON_Appointment__c appt =  [select id,name,Customer_Name__c,Customer_Preferred_Contact_Method__c,Contact_Telephone_Number__c,Contact_Email__c,
                                       h_Metering_Point_Address_Full__c,Oracle_Town__c,Oracle_Postcode__c,MPAN__c,MPRN__c,Technician__c,h_Job_Type__c
                                       from EON_Appointment__c where id =:ApptID ];
           //Populating Complainant Name from EON Appointment
           stdController.getRecord().put('Complainant_Name__c',appt.Customer_Name__c);
           //Populating Customer Name from EON Appointment
           stdController.getRecord().put('Customer_Name__c',appt.Customer_Name__c);
           //Populating Preferred Contact Method from EON Appointment
           if(appt.Customer_Preferred_Contact_Method__c=='H' ||  appt.Customer_Preferred_Contact_Method__c=='W' || appt.Customer_Preferred_Contact_Method__c=='T'){
              stdController.getRecord().put('Preferred_Contact_Method__c','Telephone');
              stdController.getRecord().put('Telephone__c',appt.Contact_Telephone_Number__c);
           }
                else if(appt.Customer_Preferred_Contact_Method__c=='E'){
                       stdController.getRecord().put('Preferred_Contact_Method__c','Email');
                       stdController.getRecord().put('Email__c',appt.Contact_Email__c);
                }
          
          //Populating Preferred Contact Method from EON Appointment    
          stdController.getRecord().put('Site_Address__c',appt.h_Metering_Point_Address_Full__c);
          stdController.getRecord().put('Site_City__c',appt.Oracle_Town__c); 
          stdController.getRecord().put('Site_Postcode__c',appt.Oracle_Postcode__c);  
          
          //Populating Appointment ID from EON Appointment

          profile pr = [select Name from profile where id = :userinfo.getProfileId()];
          if(!pr.Name.contains('Voice')) 
              stdController.getRecord().put('Complaint_Received_By__c','MUS Back Office');
          //Populating Appointment ID from EON Appointment 
          stdController.getRecord().put('Appointment_ID__c',appt.Id);
          //Populating MPRN from EON Appointment 
          stdController.getRecord().put('MPAN__c',appt.MPAN__c); 
          //Populating MPAN from EON Appointment 
          stdController.getRecord().put('MPRN__c',appt.MPRN__c);  
          //Populating Technician from EON Appointment 
          stdController.getRecord().put('Technician__c',appt.Technician__c);
          //Populating Job Type from EON Appointment 
          stdController.getRecord().put('Job_Type__c',appt.h_Job_Type__c);
        }
        
        
        //This block of code run when user create Complaint from EON Customer record
        else if(System.currentPageReference().getParameters().containsKey('CustId')){
            id CusID = System.currentPageReference().getParameters().get('CustId');
            EON_Customer__c eCus =  [select id,Customer_Name__c from EON_Customer__c where id =:CusID ]; 
            
            //EON Contact media Deatils
            List<EON_Contact_media__c> lMedia = [select id,Email__c,Phone_Code__c,Phone_Extension__c,Phone_Number__c 
                                                 from EON_Contact_media__c where Customer__c=:CusID ORDER BY LastModifiedDate DESC];
            List<EON_Site__c> lSite  = [select id,Building_Number__c,Thorofare__c,Town__c,Postcode__c,(select id,Fuel_type__c,MPAN__c,MPRN__c from EON_Fuel__r 
                                        ORDER BY LastModifiedDate DESC limit 1) from EON_Site__c where Customer__c=:CusID and Address_Type__c='S' ORDER BY 
                                        LastModifiedDate DESC limit 1];
        
            if(eCus!=null){
               stdController.getRecord().put('Customer_Name1__c',eCus.id);
               //Populating Complainant Name from EON Customer
               stdController.getRecord().put('Complainant_Name__c',(eCus.Customer_Name__c!= null?eCus.Customer_Name__c:''));
               //Populating Customer Name from EON Customer
               stdController.getRecord().put('Customer_Name__c',(eCus.Customer_Name__c!= null?eCus.Customer_Name__c:''));
               
               //Populating Contact Media Details from EON Customer
               if(!lMedia.isEmpty()){
                  for(EON_Contact_media__c eConE : lMedia)
                      if(eConE.Email__c!=null){
                         stdController.getRecord().put('Email__c',(eConE.Email__c!=null?eConE.Email__c:''));
                         break;
                      }
                      
                  for(EON_Contact_media__c eConT : lMedia)
                      if(eConT.Phone_Code__c!=null || eConT.Phone_Extension__c!=null || eConT.Phone_Number__c!=null){
                         
                         stdController.getRecord().put('Telephone__c',(eConT.Phone_Code__c!=null?eConT.Phone_Code__c:'')
                                                                      +(eConT.Phone_Extension__c!=null?eConT.Phone_Extension__c:'')
                                                                       +(eConT.Phone_Number__c!=null?eConT.Phone_Number__c:''));
                         break;
                      }    
               }
               
                //Populating Site Details from EON Site
                if(!lSite.isEmpty()){
                   if(lSite[0].Building_Number__c!=null || lSite[0].Thorofare__c!=null)
                      stdController.getRecord().put('Site_Address__c',(lSite[0].Building_Number__c!=null?lSite[0].Building_Number__c:'')
                                                                      +(lSite[0].Thorofare__c!=null?lSite[0].Thorofare__c:''));
                        
                   if(lSite[0].Town__c!=null)
                      stdController.getRecord().put('Site_City__c',(lSite[0].Town__c!=null?lSite[0].Town__c:'')); 
                        
                   if(lSite[0].Postcode__c!=null)
                      stdController.getRecord().put('Site_Postcode__c',(lSite[0].Postcode__c!=null?lSite[0].Postcode__c:''));
                }
                
                profile prName = [select Name from profile where id =:userinfo.getProfileId()];
                  if(!prName.Name.contains('Voice')) 
                     stdController.getRecord().put('Complaint_Received_By__c','MUS Back Office');
                     
                if(!lSite[0].EON_Fuel__r.isEmpty()){ 
                    if(lSite[0].EON_Fuel__r[0].Fuel_type__c=='E')
                      //Populating MPAN from EON Fuel 
                       stdController.getRecord().put('MPAN__c',(lSite[0].EON_Fuel__r[0].MPAN__c!=null?lSite[0].EON_Fuel__r[0].MPAN__c:'')); 
                       else if(lSite[0].EON_Fuel__r[0].Fuel_type__c=='D'){
                             //Populating MPAN from EON Fuel 
                             stdController.getRecord().put('MPAN__c',(lSite[0].EON_Fuel__r[0].MPAN__c!=null?lSite[0].EON_Fuel__r[0].MPAN__c:'')); 
                             //Populating MPRN from EON Fuel 
                             stdController.getRecord().put('MPRN__c',(lSite[0].EON_Fuel__r[0].MPRN__c!=null?lSite[0].EON_Fuel__r[0].MPRN__c:''));  
                       }
                }   
            }  
            
        }
        else if(eComplaint.id==null){
                stdController.getRecord().put('Preferred_Contact_Method__c','Telephone');
        }
          else if(eComplaint.id!=null){
                string proName =  [select Name from profile where id = :userinfo.getProfileId()].Name;
                if(proName=='VOICE Community Plus User' || proName=='VOICE Community User')
                    dspVoice = true; 
          } 
    }
    
    public PageReference saveNew(){   
      try{
          upsert eComplaint;
          Schema.DescribeSObjectResult describeResult = eComplaint.getSObjectType().getDescribe();
          PageReference pr = new PageReference('/' + describeResult.getKeyPrefix() + '/e');
          pr.setRedirect(true);
          return pr; 
        }
        catch (DMLException ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getDMLMessage(0));
            ApexPages.addMessage(msg);
            return null;
        }
    }


}