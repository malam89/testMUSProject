/**
    Description : This generic class will be used to display attachments with type image in record display page
                  
    VF Page     : EON_Job_Result_Image
    Test Class  : EON_Image_Viewer_Test

**/
/*
    Created By  : Mahadev Joshilkar
    Created On  : 08/04/2016
    Service Req : SR_EON_Mobile_009
    Change History : CH00 # Developer_Name # Date # SR_ID # Details
*/

public with sharing class EON_Image_Viewer 
{
    public List<Image> imageAttachments;    //to hold all the image attachments
    public SObject customObject;  //used SObject so that the Controller can be used for all objects
    //Wrapper class for images
    public class Image
    {
        public String id{get;set;}
        public String url{get;set;}
        public String name{get;set;}
        public String type{get;set;}
        public String attachedOn{get;set;}
        public Image(String imageId, String imageName, DateTime imageAttachedOn, String ImageURL)
        {
            id   = imageId;
            // standard URL for downloading attachments
            //url  = '/servlet/servlet.FileDownload?file=' + imageId; 
            url  = ImageURL;
            name = imageName;
            type = 'IMG';
            attachedOn = imageAttachedOn.format();
        }
    }
    /**
    	EON_Image_Viewer() - Constructor to get the images on page load///////
    **/
    public EON_Image_Viewer(ApexPages.StandardController currentRecord)
    {
        this.customObject = currentRecord.getRecord();
        imageAttachments  = new List<Image>();
        getImages();
    }
    /**
        getImages() -  gets all the attachments on a record and filters only the images
    **/
    public void getImages()
    {
        imageAttachments.clear(); 
        for (Attachment objAttachment : [Select Id, Name, CreatedDate From Attachment Where ParentID = :customObject.Id order by createddate desc])
        {
           if(isValidImage(objAttachment.Name))     // Only consider images
                imageAttachments.add(new Image(objAttachment.Id, objAttachment.Name, objAttachment.CreatedDate,System.label.EON_OptiMUS_Content_Domain+'servlet/servlet.FileDownload?file='+objAttachment.Id));
        }
    }
    /**
    	getImageAttachments() - returns the list of image attachments on the corresponding record
    **/                              
    public List<Image> getImageAttachments()
    {
        return imageAttachments;
    }
    /**
    	isValidImage() - checks the file extension to determine if the attachement is a valid image file
    **/     
    public boolean isValidImage(String fileName)    
    {
        fileName = fileName.toUpperCase();    //to check with standard upper case
        if(
            (fileName.endswith('.JPG')) ||
            (fileName.endswith('.JPEG'))||
            (fileName.endswith('.BMP')) ||
            (fileName.endswith('.GIF')) ||
            (fileName.endswith('.PNG')) ||
            (fileName.endswith('.TIF')) ||
            (fileName.endswith('.TIFF')))   
        return true;        
        return false;       
    }
}