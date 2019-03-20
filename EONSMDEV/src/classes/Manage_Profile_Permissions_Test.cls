/**
    Description : This is the test class for Manage_Profile_Permissions_Test class
**/
/*
    Created By  : Tushar
    Created On  : 15/05/2014
    Service Req : SR_ISIS_Central_499
    Change History
    CH01 # SR_ISIS_Central_518 # 28/10/2014 # Puneet Mehta # Created a function to export permission.
*/
@isTest
public class Manage_Profile_Permissions_Test{
    static testmethod void myTest(){
        Manage_Profile_Permissions controller = new Manage_Profile_Permissions();
        System.assertEquals(controller.getPermissions().size(),0);//no object selected, no permissions retrieved
        controller.exportTable();//CH01
        Apexpages.currentpage().getparameters().put('selectedObj',controller.getObjectList().get(1).getValue());    //object selected alone
        Apexpages.currentpage().getparameters().put('selectedProfile','-');
        controller.getPermissions();
        controller.exportTable();//CH01
        Apexpages.currentpage().getparameters().put('selectedProfile',controller.getProfileList().get(1).getValue());//object and profile selected
        controller.getPermissions();
        controller.exportTable();//CH01
    }
//CH01.START
    static testmethod void myTest1(){
        Manage_Profile_Permissions controller = new Manage_Profile_Permissions();
        Apexpages.currentpage().getparameters().put('selectedProfile',controller.getProfileList().get(1).getValue());//profile selected alone
        controller.getPermissions();
        controller.exportTable();
    }
//CH01.END
}