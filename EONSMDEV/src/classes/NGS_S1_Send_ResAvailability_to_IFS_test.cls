/*
    Created By  : Venkat Pattapu
    Created On  : 7/04/2017
    Class       : NGS_S1_Send_ResourceAvailability_to_IFS
    mock class  : NGS_S1_Send_ResAvailability_to_IFS_Mock
        
        Change History
*/

@istest

global class NGS_S1_Send_ResAvailability_to_IFS_test {
   
   @istest  static  void unit1(){

       NGS_Technician__c NGST= new NGS_Technician__c (First_Name__c = 'Rejected',Start_Date__c=system.today(),Leaving_Date__c=system.today()+1, h_oracle_user_created__c=true,Last_Name__c = 'Test1', Gender__c = 'F',Start_Location__c = 'UK', Mobile_Number__c = '07705898212',Sent_to_IFS__c=true);
         insert NGST;
         NGS_Technician_Shifts__c nshifts =new NGS_Technician_Shifts__c(Employee_ID__c=NGST.id,IsWorking__c=true,Shift_Date__c=system.today());
         insert nshifts;
         NGS_Technician_Shifts__c nshiftss =new NGS_Technician_Shifts__c(Employee_ID__c=NGST.id,IsWorking__c=true,Shift_Date__c=system.today(),Shift_Start__c='18042017',Shift_End__c='19042017');
         insert nshiftss;
         upsert nshiftss;
         NGS_Oracle_Data_Tracker__c NGSO =new NGS_Oracle_Data_Tracker__c(Command__c='Create User',NGS_Technician__c=NGST.id,Direction__c='OUT',Response_Data__c='den');
         insert NGSO;
         upsert NGSO;
         NGS_Work_Order_Appointment__c app = new NGS_Work_Order_Appointment__c(City__c = 'MyCity', Country__c = 'Country', Appointment_Start_Time__c = system.now(), Appointment_Finish_Time__c = system.now(), Message_Date__c = system.today() ,Duration__c = '11:44',Name = 'WO-XXXX', Address_Line_1__c = 'Add1', Post_Code__c = 'SG1 2ST');
         insert app;
         IFS_Data_Tracker__c ifstrack=new IFS_Data_Tracker__c(Command__c='S1 SEND SHIFTS',Direction__c='OUT',NGS_Work_Order_Appointment__c=app.id,NGS_Technician__c=NGST.Id,Response_Data__c='response data',status__c='Pass');
         insert IFStrack;
         upsert IFStrack;
         IFS_Data_Tracker__c ifstrack1=new IFS_Data_Tracker__c(Command__c='S1 SEND SHIFTS',Direction__c='OUT',NGS_Work_Order_Appointment__c=app.id,NGS_Technician__c=NGST.Id,Response_Data__c='response data',status__c='Pass');
         insert IFStrack1;
       
      
         list<NGS_Technician_Shifts__c> lst=new list<NGS_Technician_Shifts__c>();
       lst.add(nshifts);
        
       Test.startTest();
         
            test.setmock(WebServiceMock.class, new NGS_S1_Send_ResAvailability_to_IFS_Mock()); 
            NGS_S1_Send_ResourceAvailability_to_IFS.Send_ResourceAvailability(lst);
       Test.stopTest();  
    }
    
     @istest static void unit2(){
       test.setmock(WebServiceMock.class, new NGS_S1_Send_ResAvailability_to_IFS_Mock());  
       NGS_S1_Send_ResourceAvailability_to_IFS.ResourceAvailibilityCall();
    }
    
    
    
}