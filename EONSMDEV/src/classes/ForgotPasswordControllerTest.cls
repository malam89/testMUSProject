/**
    Description : 	STANDARD CLASS PROVIDED BY SALESFORCE. An apex page controller that exposes the site forgot password functionality
					As per aricle https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_sites.htm
					Site.forgotPassword() never return false when called outside Visulaforce Page, hence it will not cover failure scenario
	Apex Class: ForgotPasswordController

**/
/*
    Created By : Salesforce
    Created Date : 16-04-2016 
    Service Request : NA
    
*/
@IsTest public with sharing class ForgotPasswordControllerTest {
  	 @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
    	// Instantiate a new controller with all parameters in the page
    	ForgotPasswordController controller = new ForgotPasswordController();
    	controller.username = 'test@salesforce.com';     	
    	System.assertEquals(controller.forgotPassword(),null); 
    }
}