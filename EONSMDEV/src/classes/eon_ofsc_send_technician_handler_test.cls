/**
description : this test class is for the following below classes/triggers
              eon_ofsc_send_technician_handler          
**/
/* 
created by    : nitin bangar
created on    : 14/04/2016
service req   : sr_eon_scheduling_001
change history 
ch01 # sr_eon_scheduling_030 # 04/05/2016 # tashika # amended whole class and created new methods to cover the class.
CH02 # 17-05-2016 # peddareddeiah # added logic for creating the test technician record to cover the code 100%
CH03 # 08-July-2016 # Praveen G # added code for test coverage of the  method (createOFSCTrackerForUser) for class - EON_OFSC_Send_Technician_Handler
*/
@istest
public class eon_ofsc_send_technician_handler_test{   
    //CH02.Start
    /**
    setuptestdata() - this method will create the test data for covering the code coverage
    **/
    @testsetup
    static void setuptestdata() {                   
     
       eon_ofsc_response_code__c eontech2 = eon_createtestrecords.createeonofscresponsecode();
        //eontech2.name = '10';
        insert eontech2;
        
        eon_technician__c eontech = eon_createtestrecords.createeontechnician(); 
        eontech.name = 'eontest';  
        eontech.Training_Start_Date__c = System.today();     
        insert eontech;
       
        eon_technician__c eontech1 = eon_createtestrecords.createeontechnician(); 
        eontech1.name = 'eontesttt'; 
        eontech1.sent_to_ofs__c = datetime.now();   
        eontech1.Training_Start_Date__c = System.today(); 
        insert eontech1;
        
        //CH03.Start
            EON_OFSC_Response_Code__c code = new EON_OFSC_Response_Code__c();
            code.API__c = 'Resource';
            code.Name = '0';
            insert code;
            
            EON_OFSC_Response_Code__c code1 = new EON_OFSC_Response_Code__c();
            code1.API__c = 'Resource';
            code1.Name = '99';
            code1.Error_Warning_Success__c = 'error';
            insert code1;            
        
            List<String> lstResponse = new List<String>();
            lstResponse.add('REQUEST');
            lstResponse.add('RESPONSE');
            lstResponse.add('0');
            EON_OFSC_Send_Technician_Handler.createOFSCTrackerForUser(lstResponse, eontech1.id);
            
            List<String> lstResponse1 = new List<String>();
            lstResponse1.add('REQUEST');
            lstResponse1.add('RESPONSE');
            lstResponse1.add('99');
            EON_OFSC_Send_Technician_Handler.createOFSCTrackerForUser(lstResponse1, eontech1.id);            
            
        //CH03.End
       
    } 
    //CH02.End
    //ch01.start
    /**
    sendtechniciantoofsc_pass1() : positive test for method : sendtechniciantoofsc();
    **/
     @istest()//ch02seealldata=true
        static void sendtechniciantoofsc_pass1() {
        eon_technician__c eontech = [select id, name , work_zone__c , start_date__c  , date_left__c  , sent_to_ofs__c  from eon_technician__c where work_zone__c!=null and start_date__c <=today and  (date_left__c=null or date_left__c>= today) and sent_to_ofs__c=null limit 1];
        
        system.debug('******technician value****'+eontech);
        
        test.starttest(); 
        // this causes a fake response to be generated
        test.setmock(webservicemock.class, new eon_ofsc_resourcemanagement_servicesmock());
        
        EON_OFSC_Resource_Management_WS.SetResourceResponseElement resp = new EON_OFSC_Resource_Management_WS.SetResourceResponseElement();
        Map<String, EON_OFSC_Resource_Management_WS.SetResourceResponseElement> response_map_x = new Map<String, EON_OFSC_Resource_Management_WS.SetResourceResponseElement>();
        resp.result_code = 0;
        resp.error_msg = '';
        response_map_x.put('response_x', resp);
        
        eon_ofsc_send_technician_handler.sendtechniciantoofsc(eontech.id);
        //system.assertequals('tech',eontech.name);             
        
        test.stoptest();
    }
     /**
    sendtechniciantoofsc_pass3() : positive test for method : sendtechniciantoofsc();
    **/
    
     @istest()//ch02 seealldata=true
        static void sendtechniciantoofsc_pass3() {
        eon_technician__c eontech = [select id, name , work_zone__c , start_date__c  , date_left__c  , sent_to_ofs__c  from eon_technician__c where work_zone__c!=null and start_date__c <=today and  (date_left__c=null or date_left__c>= today) and sent_to_ofs__c!=null limit 1];
        
        system.debug('******technician value****'+eontech);
        
        test.starttest(); 
        // this causes a fake response to be generated
        test.setmock(webservicemock.class, new eon_ofsc_resourcemanagement_servicesmock());
        
        eon_ofsc_send_technician_handler.sendtechniciantoofsc(eontech.id);
        //system.assertequals('tech',eontech.name);             
        
        test.stoptest();
    }
    
    /**
    sendtechniciantoofsc_pass2() : positive test for method : sendtechniciantoofsc() which covers exception;
    **/
        @istest static void sendtechniciantoofsc_pass2() {
        
        eon_technician__c eontech = eon_createtestrecords.createeontechnician();      
        eontech.Training_Start_Date__c = System.today();  
        insert eontech;
        
        eontech.mobile__c = '123456899';
        eontech.name = 'tech';         
        update eontech;     
        
        eon_workzonemapping__c workzonemap = eon_createtestrecords.createeon_workzonemappping();
        insert workzonemap;
        eon_ofsc_response_code__c code = new  eon_ofsc_response_code__c(name='0',api__c = 'resource');//CH02.name='200'
        insert code;
  //CH02.Start           
        test.starttest();  
            test.setmock(webservicemock.class, new eon_ofsc_resourcemanagement_servicesmock());
            eon_ofsc_send_technician_handler.sendtechniciantoofsc(eontech.id);
 
 //CH02.End
        system.assertequals('tech',eontech.name);             
        test.stoptest();
    }

   //ch01.end
   
   /**
   **/
   
   static testmethod void unitTest1(){
  
    eon_technician__c eontech = [select id, name , work_zone__c , start_date__c  , date_left__c  , sent_to_ofs__c  from eon_technician__c where work_zone__c!=null and start_date__c <=today and  (date_left__c=null or date_left__c>= today) and sent_to_ofs__c=null limit 1];   
    
        EON_OFSC_Technician_User_Handler.CreateOFSCUserForTechnician('TEST123', eontech.id, 'Technician');
        EON_OFSC_Technician_User_Handler.DeleteOFSCUserForTechnician('TEST234');
        EON_OFSC_Technician_User_Handler.getAuthenticationElement();
        
        EON_OFSC_Send_Technician_Handler.updateTechnicianLocationinOFSC(eontech.id);
        EON_OFSC_Send_Technician_Handler.updateTechnicianInfoInOFSC(eontech.id);
   
   }

   
}