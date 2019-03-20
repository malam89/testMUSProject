global with sharing class EON_GetSessioId {

   global with sharing class xyzReq{
        Webservice String mrtID;
    } 
         
    global with sharing class abcRes{
        Webservice String retMrtID;
    }
    
    webservice static abcRes accessA(xyzReq aRequest){
         
         abcRes sendResp = new abcRes();
         sendResp.retMrtID='Here we go';
      return sendResp;
}
}