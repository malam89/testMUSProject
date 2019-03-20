/*
    Created By    : venkat pattapu
    Created On    : 03/04/2017
    class         : NGS_OFSC_Technician_Handler
*/

@istest
public class NGS_OFSC_Technician_Handler_Test {
     public string jsonBody;
    static testMethod void  myUnitest1(){
         
        NGS_Technician__c NGST= new NGS_Technician__c (First_Name__c = 'Rejected',Start_Date__c=system.today(),Leaving_Date__c=system.today()+1, h_oracle_user_created__c=true,Last_Name__c = 'Test1', Gender__c = 'F',Start_Location__c = 'UK', Mobile_Number__c = '07705898212');
         insert NGST;
        NGS_Technician_Shifts__c nshifts =new NGS_Technician_Shifts__c(Employee_ID__c=NGST.id,IsWorking__c=true,Shift_Date__c=system.today());
        insert nshifts;
        
         NGS_Oracle_Data_Tracker__c NGSO =new NGS_Oracle_Data_Tracker__c(Command__c='Create User',NGS_Technician__c=NGST.id,Direction__c='OUT',Response_Data__c='den');
         insert NGSO;
         update NGSO;
           
         Test.startTest();
         test.setmock(HttpCalloutMock.class, new NGS_OFSC_Technician_HandlerMock());
       //  HttpResponse res = CalloutClass.getInfoFromExternalService();
          NGS_OFSC_Technician_Handler.sendTechnicianToOFSC(NGSt.id,true);
     
         Test.stopTest(); 
          }
    
 
   static testMethod void  myUnitest2(){
        NGS_OFSC_Technician_Handler.UserDetail pg= new NGS_OFSC_Technician_Handler.UserDetail();
        pg.userType='TECHNICIAN';
        pg.name='venkat';
        pg.login='ggg@gmail.com';
        
    }
    static testMethod void  myUnitest3(){
        NGS_OFSC_Technician_Handler.ResourceDetail pg= new NGS_OFSC_Technician_Handler.ResourceDetail();
        pg.parentResourceId='TECHNICIAN';
        pg.name='venkat';
        pg.language='en';
        pg.timeZone='(UTC+00:00) London - Greenwich Mean Time (GMT)';
        
       
        
    }
     static testMethod void  myUnitest4(){
         
        NGS_Technician__c NGST= new NGS_Technician__c (First_Name__c = 'Rejected',Start_Date__c=system.today(),Leaving_Date__c=system.today()+1, h_oracle_user_created__c=true,Last_Name__c = 'Test1', Gender__c = 'F',Start_Location__c = 'UK', Mobile_Number__c = '07705898212');
         insert NGST;
        NGS_Technician_Shifts__c nshifts =new NGS_Technician_Shifts__c(Employee_ID__c=NGST.id,IsWorking__c=true,Shift_Date__c=system.today());
        insert nshifts;
        
         NGS_Oracle_Data_Tracker__c NGSO =new NGS_Oracle_Data_Tracker__c(Command__c='Create User',NGS_Technician__c=NGST.id,Direction__c='OUT',Response_Data__c='den');
         insert NGSO;
         update NGSO;
           
         Test.startTest();
         test.setmock(HttpCalloutMock.class, new Ngs_Ofsc_Technician_Mock2());
        // test.setmock(HttpCalloutMock.class, new Ngs_Ofsc_Technician_Mock3());
       //  HttpResponse res = CalloutClass.getInfoFromExternalService();
          NGS_OFSC_Technician_Handler.sendTechnicianToOFSC(NGSt.id,true);
     
         Test.stopTest(); 
          }
    
     static testMethod void  myUnitest5(){
         
        NGS_Technician__c NGST= new NGS_Technician__c (First_Name__c = 'Rejected',Start_Date__c=system.today(),Leaving_Date__c=system.today()+1, h_oracle_user_created__c=true,Last_Name__c = 'Test1', Gender__c = 'F',Start_Location__c = 'UK', Mobile_Number__c = '07705898212');
         insert NGST;
        NGS_Technician_Shifts__c nshifts =new NGS_Technician_Shifts__c(Employee_ID__c=NGST.id,IsWorking__c=true,Shift_Date__c=system.today());
        insert nshifts;
        
         NGS_Oracle_Data_Tracker__c NGSO =new NGS_Oracle_Data_Tracker__c(Command__c='Create User',NGS_Technician__c=NGST.id,Direction__c='OUT',Response_Data__c='den');
         insert NGSO;
         update NGSO;
         NGS_Oracle_Data_Tracker__c NGSO1 =new NGS_Oracle_Data_Tracker__c(Command__c='Create User',NGS_Technician__c=NGST.id,Direction__c='OUT',Response_Data__c='den');
         insert NGSO1;
         
           
         Test.startTest();
        
         test.setmock(HttpCalloutMock.class, new Ngs_Ofsc_Technician_Mock3());
       //  HttpResponse res = CalloutClass.getInfoFromExternalService();
          NGS_OFSC_Technician_Handler.sendTechnicianToOFSC(NGSt.id,true);
     
         Test.stopTest(); 
          }

    
   

}