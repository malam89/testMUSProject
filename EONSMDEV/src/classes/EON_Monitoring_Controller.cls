/**
    Description : This class is the controller for EON_Monitoring page
                   1. Interface Status
                   2. Recent file transfer result
                   3. Errors/Failures for most recent web service call
                   4. Response time of most recent web service call
                  
    VF Page     : EON_Monitoring
    Test Class  : EON_Monitoring_Controller_Test

**/
/*
    Created By  : Mehboob Alam
    Created On  : 09/10/2017
    Service Req: SR_OptiMUS_EON_149
    Change History
*/
public with sharing class EON_Monitoring_Controller{
public integer futureQueue{get; set;}
public list<reqLifeTimeStaus> lList{get; set;}
public list<reqTurnAroundTime> tList{get; set;}
public list<EON_Import_Job_Result__c> jList{get; set;}
public boolean lLoading{get; set;}
public boolean tLoading{get; set;}
public string baseURL{get; set;}
public string tabId='';

    public EON_Monitoring_Controller(){
        lLoading = true;
        tLoading = true;
        baseURL= System.URL.getSalesforceBaseUrl().toExternalForm()+'/';
        tabId = System.currentPageReference().getParameters().get('sfdc.tabName');
        jList = new List<EON_Import_Job_Result__c>();
        futureQueue= [SELECT count() FROM AsyncApexJob WHERE JobType = 'Future' AND Status = 'Queued'];                                  
        //Recent file transfer result Jobs Results 
        jList = [select id,Name,Last_Run_Time__c,Result__c from EON_Import_Job_Result__c where Latest_Result__c=true ORDER BY CreatedDate LIMIT 5];
    }


      /**
      reqResponseTime() - This Method is used to get Last reqResponse Time.
      **/
      public void reqResponseTime(){
          tList = new List<reqTurnAroundTime>();    //Response Time of Most Recent Web Service Call
          List<MIDOS_Data_Tracker__c> mRT = [select id,Name,CreatedDate,MIDOS_Data_Tracker__c,MIDOS_Data_Tracker__r.LastModifiedDate from MIDOS_Data_Tracker__c 
                                             where Command__c='PushValidationStatus' AND Status__c != null ORDER BY CreatedDate DESC LIMIT 1];
                                                    
          List<Oracle_Data_Tracker__c> oRT = [select id,Name,CreatedDate,MIDOS_Data_Tracker__r.MIDOS_Data_Tracker__r.Oracle_Data_Tracker__r.CreatedDate 
                                              from Oracle_Data_Tracker__c where Command__c='PushValidationStatus' AND Status__c != null ORDER BY CreatedDate DESC LIMIT 1];  
                                              
          List<JUMBO_Data_Tracker__c> jRT = [select id,Name,CreatedDate,Request_Data__c from JUMBO_Data_Tracker__c where Direction__c='IN' AND 
                                            (Command__c = 'BusinessResponseCloseElecJob' or Command__c = 'BusinessResponseCloseGasJob')
                                             AND Status__c != null ORDER BY CreatedDate DESC LIMIT 1];                                 
            if(!jRT.isEmpty()){
                List<string> tt = jRT[0].Request_data__c.split('=');
                if(tt.size()==5){
                    string tranId = tt[4].removeEnd(']');
                       List<JUMBO_Data_Tracker__c> jRTFinal = [select id,Name,CreatedDate from JUMBO_Data_Tracker__c where Direction__c='OUT' AND 
                                                               Transaction_ID__c=:tranId ORDER BY CreatedDate LIMIT 1];
                        if(!jRTFinal.isEmpty()){
                           string jRtime = ElapsedTime(jRTFinal[0].CreatedDate, jRT[0].CreatedDate);
                            tList.add(New reqTurnAroundTime('OptiMUS-JUMBO-OptiMUS',jRtime, jRTFinal[0].id, jRTFinal[0].Name,jRT[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
                        }
                           else
                           tList.add(New reqTurnAroundTime('OptiMUS-JUMBO-OptiMUS','Request not Completed', jRT[0].id, jRT[0].Name,jRT[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
                }
                   else
                     tList.add(New reqTurnAroundTime('OptiMUS-JUMBO-OptiMUS','Request not Completed', jRT[0].id, jRT[0].Name,jRT[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
            }                                  
                                                
                                                                                     
          if(!mRT.isEmpty()){
             if(mRT[0].MIDOS_Data_Tracker__c!=null){
                string mRtime = ElapsedTime(mRT[0].MIDOS_Data_Tracker__r.LastModifiedDate,mRT[0].CreatedDate);
                 tList.add(New reqTurnAroundTime('OptiMUS-MIDOS-OptiMUS', mRtime, mRT[0].id, mRT[0].Name,mRT[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
             }
              else
                tList.add(New reqTurnAroundTime('OptiMUS-MIDOS-OptiMUS','Request not Completed', mRT[0].id, mRT[0].Name,mRT[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
          }
             
             
           if(!oRT.isEmpty()){
             if(oRT[0].MIDOS_Data_Tracker__r.MIDOS_Data_Tracker__r.Oracle_Data_Tracker__c!=null){
                string oRtime = ElapsedTime(oRT[0].MIDOS_Data_Tracker__r.MIDOS_Data_Tracker__r.Oracle_Data_Tracker__r.CreatedDate, oRT[0].CreatedDate);
                 tList.add(New reqTurnAroundTime('OFSC-MIDOS-OFSC', oRtime, oRT[0].id, oRT[0].Name,oRT[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
                 }
                 else
                   tList.add(New reqTurnAroundTime('OFSC-MIDOS-OFSC','Request not Completed', oRT[0].id,oRT[0].Name,oRT[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
                   
           }
          tLoading= false;
    }



      /**
      lstWebServicCall() - This Method is used to get Last web service call status
      **/
      public void lstWebServicCall(){
          lList = new List<reqLifeTimeStaus>();
          //Errors - Failures for most recent web service call 
          List<MIDOS_Data_Tracker__c> lCallM = [select id,Name,Status__c,CreatedDate from MIDOS_Data_Tracker__c where Direction__c='OUT' AND ( Command__c='ValidateSMSAsset' or  
                                                Command__c='ConfigureSMSAsset') AND Status__c != null ORDER BY CreatedDate DESC LIMIT 1];
                                                
          List<Oracle_Data_Tracker__c> lCallO = [select id,Name,Status__c,CreatedDate from Oracle_Data_Tracker__c where Direction__c='OUT' AND (Command__c='PushValidationStatus' 
                                                 OR Command__c='PushConfigProgressStatus' OR Command__c='PushConfgAssetReadStatus' OR Command__c='PushConfigStatus')  
                                                 AND Status__c != null ORDER BY CreatedDate DESC LIMIT 1];
                                                 
          List<JUMBO_Data_Tracker__c> lCallJ =  [SELECT id,Name,Status__c,CreatedDate FROM JUMBO_Data_Tracker__c WHERE Direction__c='OUT' AND (Command__c = 'CloseElecJobInJUMBO' or Command__c = 'CloseGasJobInJUMBO')
                                                 AND Status__c != null ORDER BY CreatedDate DESC LIMIT 1];
                                                 
          List<Voice_Data_Tracker__c> lCallV =  [SELECT id,Name,Status__c,CreatedDate FROM Voice_Data_Tracker__c WHERE Direction__c='OUT' AND Command__c = 'Create/Update Appointment' 
                                                 and Status__c != null ORDER BY CreatedDate DESC LIMIT 1];
                                                                                        
                                                
          if(!lCallM.isEmpty()){
             if(lCallM[0].Status__c=='PASS')
                lList.add(New reqLifeTimeStaus('OptiMUS-MIDOS',true,lCallM[0].id, lCallM[0].Name,lCallM[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
                else
                  lList.add(New reqLifeTimeStaus('OptiMUS-MIDOS',false,lCallM[0].id, lCallM[0].Name,lCallM[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
          }
          
          
           if(!lCallO.isEmpty()){
             if(lCallO[0].Status__c=='PASS')
                lList.add(New reqLifeTimeStaus('OptiMUS-OFSC',true,lCallO[0].id, lCallO[0].Name,lCallO[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
                else
                  lList.add(New reqLifeTimeStaus('OptiMUS-OFSC',false,lCallO[0].id, lCallO[0].Name,lCallO[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
          }
          
           if(!lCallJ.isEmpty()){
             if(lCallJ[0].Status__c=='PASS')
                lList.add(New reqLifeTimeStaus('OptiMUS-JUMBO',true,lCallJ[0].id, lCallJ[0].Name,lCallJ[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
                else
                  lList.add(New reqLifeTimeStaus('OptiMUS-JUMBO',false,lCallJ[0].id, lCallJ[0].Name,lCallJ[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
          }
          
          if(!lCallV.isEmpty()){
             if(lCallJ[0].Status__c=='PASS')
                lList.add(New reqLifeTimeStaus('OptiMUS-Voice',true,lCallV[0].id, lCallV[0].Name,lCallV[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
                else
                  lList.add(New reqLifeTimeStaus('OptiMUS-Voice',false,lCallV[0].id, lCallV[0].Name,lCallV[0].CreatedDate.format('MM/dd/yyyy HH:mm')));
          }
          lLoading= false;
    }


   
   
    @RemoteAction
    public static iInterfaceStaus JUMBOInterfaceStatus(){
       iInterfaceStaus JStatus = new iInterfaceStaus();
       //Interface Health Check for Jumbo
       JUMBO_Data_Tracker__c jData = new JUMBO_Data_Tracker__c(); 
       jData = EON_InterfacesHealthCheck.JUMBOServiceStatus();
       
       //JUMBO Health Check Result
       if (jData != null){
           jData.Command__c = 'Get Service Status';
           insert jData;
           if(jData.Status__c=='PASS'){
              JStatus.status =true;
              JStatus.link = jData.id;
           } 
              else{
                JStatus.status =false;
                JStatus.link = jData.id;
              }
       } 
        return JStatus;
    }
   
     @RemoteAction
     public static iInterfaceStaus OFSCInterfaceStatus(){
       iInterfaceStaus OStatus = new iInterfaceStaus();
       Oracle_Data_Tracker__c oData = new Oracle_Data_Tracker__c();
       oData = EON_InterfacesHealthCheck.OFSCServiceStatus();
           
           //JUMBO Health Check Result
           if (oData != null){
               insert oData;
               if(oData.Status__c=='PASS'){
                  OStatus.status =true;
                  OStatus.link = oData.id;
               } 
                  else{
                    OStatus.status =false;
                    OStatus.link = oData.id;
                  }
           } 
           return  OStatus;
        }
 
    @RemoteAction
    public static iInterfaceStaus MIDOSInterfaceStatus(){
       iInterfaceStaus MStatus = new iInterfaceStaus();
       //Interface Health Check for Jumbo
       //Interface Health Check for OFSC
       MIDOS_Data_Tracker__c mData = new MIDOS_Data_Tracker__c();
       mData = EON_InterfacesHealthCheck.MIDOSServiceStatus();
       
       //JUMBO Health Check Result
       if (mData != null){
           insert mData;
           if(mData.Status__c=='PASS'){
              MStatus.status =true;
              MStatus.link = mData.id;
           } 
              else{
                MStatus.status =false;
                MStatus.link = mData.id;
              }
       } 
        return  MStatus;
    }
    
    
        /**
      EONIntrStatus() - This Method is used to get EON Interface Status
      **/
      @RemoteAction
      public static iInterfaceStaus EONInterfaceStatus(){
       iInterfaceStaus EStatus = new iInterfaceStaus();
       //Interface Health Check for Jumbo
       EON_Data_Tracker__c eData = new EON_Data_Tracker__c();
       eData = EON_InterfacesHealthCheck.EONServiceStatus();
       
       //JUMBO Health Check Result
       if (eData != null){
           insert eData;
           if(eData.Status__c=='PASS'){
              EStatus.status =true;
              EStatus.link = eData.id;
           } 
              else{
                EStatus.status =false;
                EStatus.link = eData.id;
              }
       } 
           return EStatus;
    }
    
    
      /**
      VOICEInterfaceStatus() - This Method is used to get Voice Interface Status
      **/
      @RemoteAction
      public static iInterfaceStaus VOICEInterfaceStatus(){
       iInterfaceStaus vStatus = new iInterfaceStaus();
       //Interface Health Check for Jumbo
       Voice_Data_Tracker__c vData = new Voice_Data_Tracker__c(); 
       vData =[select id,Status__c from Voice_Data_Tracker__c where Status__c != null ORDER BY CreatedDate DESC LIMIT 1];
       //JUMBO Health Check Result
       if (vData != null){
           if(vData.Status__c=='PASS'){
              vStatus.status =true;
              vStatus.link = vData.id;
           } 
              else{
                vStatus.status =false;
                vStatus.link = vData.id;
              }
       } 
           return vStatus;
    }

     /**
      refreshPage() - This Method is used to refresh the page
      **/
      public PageReference refreshPage(){   
          PageReference pr = new PageReference('/apex/EON_Monitoring?sfdc.tabName='+tabId);
           pr.setRedirect(true);
          return pr; 
        }

    
    
        /**
       class iInterfaceStaus - Wrapper Class
       **/   
       public class iInterfaceStaus{
        public boolean status {get; set;}
        public string link{get;set;}
     }
     
      /**
       class iInterfaceStaus - Wrapper Class
       **/   
       public class interfaceInfo{
        public string intrName {get; set;}
        public string link{get;set;}
        public boolean status {get; set;}
        public boolean dspstatus {get; set;}
        public interfaceInfo(string intrName ,string link,boolean status,boolean dspstatus){
          this.intrName =intrName ;
          this.link= link;
          this.status= status;
          this.dspstatus= dspstatus;
        }
     }
    
    
    
        /**
       class reqLifeTimeStaus - Wrapper Class
        **/
       public class reqLifeTimeStaus{
        public string Name {get; set;}
        public boolean status {get; set;}
        public string recId{get;set;}
        public string recName{get;set;}
        public string cTime{get;set;}
        public reqLifeTimeStaus(string Name,boolean status,string recId, string recName,string cTime){
          this.Name =Name;
          this.status = status;
          this.recId = recId;
          this.recName = recName;
          this.cTime = cTime;
        }
    }
    
       /**
       class reqTurnAroundTime - Wrapper Class
        **/
       public class reqTurnAroundTime{
        public string Name {get; set;}
        public string LifeTime{get; set;}
        public string recId{get;set;}
        public string recName{get;set;}
        public string cTime{get;set;}
        public reqTurnAroundTime(string Name,string LifeTime,string recId, string recName,string cTime ){
          this.Name =Name;
          this.LifeTime = LifeTime; 
          this.recId = recId;
          this.recName = recName;
          this.cTime = cTime;
        }
    }
    
    
    /**
    ElapsedTime() - This Method is used to get time difrence
    **/
    public static string ElapsedTime(datetime startDate, datetime enddate){
        string ElapsedTime = '';
        Integer elapseddays =startDate.Date().daysBetween(enddate.date());
        if(elapseddays>0)
           ElapsedTime = string.valueOf(elapseddays)+'day';
           else{
            Integer elapsedHours = endDate.time().hour() - startDate.time().hour();
            Integer elapsedMinutes = endDate.time().minute() - startDate.time().minute();
            Integer elapsedSeconds = endDate.time().second() - startDate.time().second();
            Integer elapsedMiliseconds = endDate.time().millisecond() - startDate.time().millisecond();
             if(elapsedHours>0)
                 ElapsedTime=string.valueOf(elapsedHours)+'h ';
             if(elapsedMinutes>0)
                 ElapsedTime=ElapsedTime+string.valueOf(elapsedMinutes)+'m ';
             if(elapsedSeconds>0)
                 ElapsedTime=ElapsedTime+string.valueOf(elapsedSeconds)+'s ';
             if(elapsedMiliseconds>0)
                 ElapsedTime=ElapsedTime+string.valueOf(elapsedMiliseconds)+'ms';
           }
           return ElapsedTime;
     }
}