/**
Description : This test class is for the following below classes/triggers
              Class - EON_InterfacesHealthCheck  
              Class - EON_Monitoring_Controller       
**/
/*
    Created By  : Mehboob Alam
    Created On  : 09/10/2017
    Service Req : SR_OptiMUS_EON_149
    Covering Components : EON_Monitoring_Controller,EON_InterfacesHealthCheck
    Change History
*/

@isTest
public with sharing class EON_Monitoring_Controller_Test {
 
    /**
    reqResponseTimeTest1() - Test Method
    **/   
   static testMethod void reqResponseTimeTest1() { 
         MIDOS_Data_Tracker__c mds = new MIDOS_Data_Tracker__c();
         insert mds;
         MIDOS_Data_Tracker__c mds1 = new MIDOS_Data_Tracker__c(Command__c='PushValidationStatus', MIDOS_Data_Tracker__c=mds.id);
         insert mds1;
         
         Oracle_Data_Tracker__c ODT = new Oracle_Data_Tracker__c();
         insert ODT;
         
         mds.Oracle_Data_Tracker__c=ODT.id;
         update mds;
         
         Oracle_Data_Tracker__c ODT1 = new Oracle_Data_Tracker__c(MIDOS_Data_Tracker__c=mds1.id,Command__c='PushValidationStatus');
         insert ODT1;
         
         JUMBO_Data_Tracker__c jdt = new JUMBO_Data_Tracker__c(Transaction_ID__c='1212121212',Direction__c='OUT');
         insert jdt;
         JUMBO_Data_Tracker__c jdt1 = new JUMBO_Data_Tracker__c(Direction__c='IN',Command__c = 'BusinessResponseCloseGasJob');
         jdt1.Request_Data__c= 'AsyncRequest:[JumboId=null, Message=MPAN , Success=false, UniqueID=1212121212]';
         insert jdt1;
         
         EON_Monitoring_Controller eMon = New EON_Monitoring_Controller();
         eMon.reqResponseTime();
    }
       
       
        /**
        reqResponseTimeTest2() - Test Method
        **/  
       static testMethod void reqResponseTimeTest2() { 
         MIDOS_Data_Tracker__c mds = new MIDOS_Data_Tracker__c(Command__c='PushValidationStatus');
         insert mds;
         
         Oracle_Data_Tracker__c ODT1 = new Oracle_Data_Tracker__c(Command__c='PushValidationStatus');
         insert ODT1;
         
         JUMBO_Data_Tracker__c jdt = new JUMBO_Data_Tracker__c(Transaction_ID__c='1212121212',Direction__c='OUT');
         insert jdt;
         
         JUMBO_Data_Tracker__c jdt1 = new JUMBO_Data_Tracker__c(Direction__c='IN',Command__c = 'BusinessResponseCloseGasJob');
         jdt1.Request_Data__c= 'AsyncRequest:[JumboId=null, Message=MPAN , Success=false, UniqueID=1212121]';
         insert jdt1;
         
         EON_Monitoring_Controller eMon = New EON_Monitoring_Controller();
         eMon.reqResponseTime();
         
          jdt1.Request_Data__c='Test';
          update jdt1;
         eMon.reqResponseTime();
    }
    
        /**
        lstWebServicCallTest1() - Test Method
        **/ 
       static testMethod void lstWebServicCallTest1(){ 
         MIDOS_Data_Tracker__c mds = new MIDOS_Data_Tracker__c(Command__c='ConfigureSMSAsset',Direction__c='OUT',Status__c='PASS');
         insert mds;
         
         Oracle_Data_Tracker__c Odt = new Oracle_Data_Tracker__c(Command__c='PushConfigProgressStatus',Direction__c='OUT',Status__c='PASS');
         insert Odt;
         
         JUMBO_Data_Tracker__c jdt = new JUMBO_Data_Tracker__c(Command__c = 'CloseGasJobInJUMBO',Direction__c='OUT',Status__c='PASS'); 
         insert jdt;
         
         EON_Monitoring_Controller eMon = New EON_Monitoring_Controller();
         eMon.lstWebServicCall();
    }
    
    
       /**
       lstWebServicCallTest2() - Test Method
       **/     
      static testMethod void lstWebServicCallTest2(){ 
         MIDOS_Data_Tracker__c mds = new MIDOS_Data_Tracker__c(Command__c='ConfigureSMSAsset',Direction__c='OUT',Status__c='FAIL');
         insert mds;
         
         Oracle_Data_Tracker__c Odt = new Oracle_Data_Tracker__c(Command__c='PushConfigProgressStatus',Direction__c='OUT',Status__c='FAIL');
         insert Odt;
         
         JUMBO_Data_Tracker__c jdt = new JUMBO_Data_Tracker__c(Command__c = 'CloseGasJobInJUMBO',Direction__c='OUT',Status__c='FAIL'); 
         insert jdt;
         
         EON_Monitoring_Controller eMon = New EON_Monitoring_Controller();
         eMon.lstWebServicCall();
    }
    
       
        /**
        IntrfaceStatusTest() - Test Method
        **/ 
       static testMethod void IntrfaceStatusTest(){ 
           EON_Monitoring_Controller eMon = New EON_Monitoring_Controller();
            eMon.jIntrStatus();
            eMon.OFSCIntrStatus();
            eMon.MIDOSIntrStatus();
            eMon.EONIntrStatus(); 

          }

    
        /**
        unitTests() - Test Method
        **/ 
        static testMethod void unitTests(){
          EON_Monitoring_Controller eMon = New EON_Monitoring_Controller();
            eMon.refreshPage(); 
            EON_Monitoring_Controller.ElapsedTime(DateTime.newInstanceGMT(2017, 10, 12, 3, 3, 3),dateTime.now());
            Time myTime1 = Time.newInstance(18, 30, 2, 20);
            Time myTime2 = Time.newInstance(19, 33, 3, 21);
            EON_Monitoring_Controller.ElapsedTime(DateTime.newInstanceGMT(date.today(), myTime1),DateTime.newInstanceGMT(date.today(), myTime2));
          }

}