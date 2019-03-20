/**
Description : This test class is for the following below classes
              EON_Image_Viewer
**/
/*
    Created By  	: Mahadev Joshilkar
    Created On  	: 08/04/2016
    Service Req 	: SR_EON_Mobile_009
    Change History 	:CH00 # Developer_Name # Date # SR_ID # Details
*/
@isTest
private class EON_Image_Viewer_Test 
{
	/**
    EON_ImageViewer_Valid(): This method will cover valid image scenario
    **/
    public static testmethod void EON_ImageViewer_Valid()
    {
         EON_Job_Results__c request = new EON_Job_Results__c();
         request.Job_Status__c = 'Completed';
         insert request;
        
         Attachment attach_JPG = new attachment();
         attach_JPG.Name='Test.JPG';
         attach_JPG.ParentID = request.ID;
         attach_JPG.body=Blob.valueOf('Test');
         insert attach_JPG;

        
        Attachment attach_JPEG = new attachment();
         attach_JPEG.Name='Test.BMP';
         attach_JPEG.ParentID = request.ID;
         attach_JPEG.body=Blob.valueOf('Test');
         insert attach_JPEG;
        
        Attachment attach_GIF = new attachment();
         attach_GIF.Name='Test.GIF';
         attach_GIF.ParentID = request.ID;
         attach_GIF.body=Blob.valueOf('Test');
         insert attach_GIF;
        
        Attachment attach_PNG = new attachment();
         attach_PNG.Name='Test.PNG';
         attach_PNG.ParentID = request.ID;
         attach_PNG.body=Blob.valueOf('Test');
         insert attach_PNG;
        
        Attachment attach_TIF = new attachment();
         attach_TIF.Name='Test.TIF';
         attach_TIF.ParentID = request.ID;
         attach_TIF.body=Blob.valueOf('Test');
         insert attach_TIF;
        
        Attachment attach_TIFF = new attachment();
         attach_TIFF.Name='Test.TIFF';
         attach_TIFF.ParentID = request.ID;
         attach_TIFF.body=Blob.valueOf('Test');
         insert attach_TIFF;
        
         ApexPages.StandardController sc = new ApexPages.StandardController(request);
         EON_Image_Viewer o = new EON_Image_Viewer(sc);
        test.startTest();
         o.getImages();
         o.getImageAttachments();   
         test.stopTest();
     }   
    /**
    EON_ImageViewer_Invalid(): This method will cover invalid image scenario
    **/
    public static testmethod void EON_ImageViewer_Invalid()
    {
         EON_Job_Results__c request = new EON_Job_Results__c();
         request.Job_Status__c = 'Completed';
         insert request;
        
        Attachment attach_T = new attachment();
         attach_T.Name='Test.T';
         attach_T.ParentID = request.ID;
         attach_T.body=Blob.valueOf('Test');
         insert attach_T;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(request);
         EON_Image_Viewer o = new EON_Image_Viewer(sc);
        test.startTest();
         o.getImages();
         o.getImageAttachments();  
        test.stopTest();
    }
}