/**
  Description : This class is the controller for Manage Profile Permissions. It has methods for the following
                a. To get permission based on the object or profile selected.
                b. To export list of permission
  VF Page     : Manage_Profile_Permissions 
  Test Class  : Manage_Profile_Permissions_Test
**/
/*
  Created By  : Tushar
  Created On  : 15/05/2014
  Service Req : SR_ISIS_Central_499
  Change History
  CH01 # SR_ISIS_Central_518 # 28/10/2014 # Puneet Mehta # Created a function to export permission.
  CH02 # SR_ISIS_Central_522 #08-01-2015  #Shraddha K #added new column of active user count
  CH03 # Checkmarx # 05/02/2018 # Mahadev J# Code security check.
*/
public with sharing class Manage_Profile_Permissions{

  //CH01.START
  /**
    exportTable() - This method exports the permission table to excel file.
  **/
  public PageReference exportTable(){
    selectedObj = '-';
    selectedProfile = '-';
    system.debug(fileName);
    if(fileName == null || fileName == 'null'){
      return null;
    }
    if(fileName.contains('selectedObj')){selectedObj = fileName.substringBetween('selectedObj','selectedObj');}
    if(fileName.contains('selectedProfile')){selectedProfile = fileName.substringBetween('selectedProfile','selectedProfile');}
    system.debug(selectedObj);
    system.debug(selectedProfile);
    fileName = 'Object Permission';
    return new PageReference('/apex/Manage_Profile_Permissions_Export?selectedObj='+selectedObj+'&selectedProfile='+selectedProfile+'&fileName='+fileName);
  }

  public String selectedObj{get; set;}
  public String selectedProfile{get; set;}
  public String fileName{get; set;}
  public Set<String> lstStrObjects = new Set<String>();
  //CH01.END
  public List<ObjectPermissions> lstPermissions {get;set;}    //CH02
  public List<clstPermissions> ActivePermissions {get; set;}  //CH02
  public String message{get;set;}
  public MAP<string,Integer> mapActiveUser;                   //CH02
  
//CH02.start
  /**
    getPermissions() - This method returns the permissions based on the object or profile selected.
  **/
  public List<clstPermissions> getPermissions(){
    system.debug(fileName);
    mapActiveUser = new MAP<string,Integer>();
    List<Profile> profileList = [select id,Name,(select id,Name, isActive from Users where IsActive=true) from profile];
    for(profile pr:profileList){
      if(!mapActiveUser.containsKey(pr.Name)){
        mapActiveUser.put(pr.Name,pr.Users.size());
         }             
     }
      
    lstPermissions = new List<ObjectPermissions>();
    ActivePermissions = new List<clstPermissions>();
    //CH02.End
    if(Apexpages.currentpage().getparameters().get('selectedObj') != 'null' && Apexpages.currentpage().getparameters().get('selectedObj') != null && Apexpages.currentpage().getparameters().get('selectedObj') != '-'){//if an object has been selected
      //selectedObj = Apexpages.currentpage().getparameters().get('selectedObj'); //CH03.Old
      selectedObj = String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('selectedObj')); //CH03.New
      fileName = 'selectedObj'+selectedObj+'selectedObj';//CH01
      String queryStr = 'select Id,SobjectType, PermissionsCreate, PermissionsDelete, PermissionsEdit, PermissionsModifyAllRecords, PermissionsRead, PermissionsViewAllRecords,parent.ProfileId,parent.Profile.Name from ObjectPermissions where parent.IsOwnedByProfile=true and SobjectType=\''+Apexpages.currentpage().getparameters().get('selectedObj')+'\' ';
      //add profile filter only if selected by user
      if(Apexpages.currentpage().getparameters().get('selectedProfile') != null && Apexpages.currentpage().getparameters().get('selectedProfile')!='-' && Apexpages.currentpage().getparameters().get('selectedProfile') != 'null'){
        //queryStr += 'and parent.ProfileId=\''+Apexpages.currentpage().getparameters().get('selectedProfile')+'\' '; //CH03.Old
        //selectedProfile = Apexpages.currentpage().getparameters().get('selectedProfile'); //CH03.Old
        queryStr += 'and parent.ProfileId=\''+String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('selectedProfile'))+'\' '; //CH03.New
        selectedProfile = String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('selectedProfile')); //CH03.New
      }
      else
        queryStr += 'order by parent.Profile.Name';    
      lstPermissions = (LisT<ObjectPermissions>)Database.query(queryStr);
      //to check if the list is empty
      if(lstPermissions.isEmpty()){
        if(Apexpages.currentpage().getparameters().get('selectedProfile') != '-'){ message = 'The selected Object is not accessible to the given Profile'; }
      }
      else{
        message = 'Object permissions have been listed below. Any Profile that is not listed below does not have access to the Object.';
        if(Apexpages.currentpage().getparameters().get('selectedProfile') != '-'){message = 'Object permissions have been listed below.'; fileName = fileName + ' ' +'selectedProfile'+ lstPermissions[0].parent.ProfileId+'selectedProfile';}//CH01
      }
      fileName = fileName + ' Permission';//CH01
    }
    else if(Apexpages.currentpage().getparameters().get('selectedProfile') != null && Apexpages.currentpage().getparameters().get('selectedProfile') != '-' && Apexpages.currentpage().getparameters().get('selectedProfile') != 'null'){
      //CH01.START
      selectedProfile = Apexpages.currentpage().getparameters().get('selectedProfile');
      if(lstStrObjects == null || lstStrObjects.size() == 0){
        for(Schema.SObjectType objType : Schema.getGlobalDescribe().Values()){ //object list
          Schema.DescribeSObjectResult objDesc = objType.getDescribe();
          if(objDesc.isCustom()&&!objDesc.isCustomSetting()){ //custom objects
            lstStrObjects.add(objDesc.getName());//CH01
          }
        }
      }
      String queryStr = 'select Id,SobjectType, PermissionsCreate, PermissionsDelete, PermissionsEdit, PermissionsModifyAllRecords, PermissionsRead, PermissionsViewAllRecords,parent.ProfileId,parent.Profile.Name from ObjectPermissions where parent.IsOwnedByProfile=true and SobjectType in:lstStrObjects ';
      //add profile filter selected by user
      //queryStr += 'and parent.ProfileId=\''+Apexpages.currentpage().getparameters().get('selectedProfile')+'\' '; //CH03.Old
      queryStr += 'and parent.ProfileId=\''+String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('selectedProfile'))+'\' '; //CH03.New
      lstPermissions = (LisT<ObjectPermissions>)Database.query(queryStr);
      lstStrObjects.clear();
      system.debug('*****after clear******');
      if(!lstPermissions.isEmpty())
      fileName = 'selectedProfile' + lstPermissions[0].parent.ProfileId + 'selectedProfile Permission';
      system.debug('*****after select profile******');
      message = 'Object permissions have been listed below. Any Object that is not listed below is not accesible by the selected profile.';
      system.debug('*****after mesage******');
      //CH01.END
    }
    else{
      message = 'Please select an Object OR Profile from the below list.';
    }
    selectedObj = Apexpages.currentpage().getparameters().get('selectedObj');
    selectedProfile = Apexpages.currentpage().getparameters().get('selectedProfile');
    system.debug(fileName);
        for(ObjectPermissions per :lstPermissions){                                                  //CH02
        ActivePermissions.add(new clstPermissions(per,mapActiveUser.get(per.parent.Profile.Name))); //CH02
    }
     system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&'+ActivePermissions);                                //CH02
    return ActivePermissions;                                                                      //CH02
  }                                                                                             

  /**
    getObjectList() - This method generates a list of objects in the ORG that can be used for selection on the page
  **/
  public List<SelectOption> getObjectList(){
    List<SelectOption> lstObjects = new List<SelectOption>();
    lstObjects.add(new SelectOption('-','---None---'));
    for(Schema.SObjectType objType : Schema.getGlobalDescribe().Values()){ //object list
      Schema.DescribeSObjectResult objDesc = objType.getDescribe();
      if(objDesc.isCustom()&&!objDesc.isCustomSetting()){ //custom objects
        lstObjects.add(new SelectOption(objDesc.getName(),objDesc.getLabel()));
        lstStrObjects.add(objDesc.getName());//CH01
      }
    }
    lstObjects.sort();
    return lstObjects;
  }
  
  /**
    getProfileList() - This method generates a list of profiles in the ORG that can be used for selection on the page
  **/
  public List<SelectOption> getProfileList(){
    List<SelectOption> lstProfiles = new List<SelectOption>();
    lstProfiles.add(new SelectOption('-','---None---'));
    for(Profile pr : [select id,Name from Profile order by Name limit 200])
      lstProfiles.add(new SelectOption(pr.Id,pr.Name));
    return lstProfiles ;
  }
  
 //CH02.start 
 /**Wrapper class for displaying count **/
   public class clstPermissions {
        public ObjectPermissions con {get; set;}
        public Integer ActiveUserCount {get; set;}
        public clstPermissions(ObjectPermissions c, Integer UserCount) {
            con = c;
            ActiveUserCount = UserCount;
        }
    }//CH02.end
}