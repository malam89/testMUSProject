/**
    WARNING - PLEASE DO NOT MAKE ANY CHANGES TO THIS CLASS, AS SINGLE WHITE SPACE OR EXTRA CHARACTER CAN 
    CRITICALLY CHANGE THE DIGEST VALUE AND SUBSEQUENTLY SIGNATURE VALUE WHICH WILL BREAK THE CONNECTIVITY.
    PLEASE DO NOT MAKE ANY AMENDMENTS IF YOU ARE NOT SURE WHAT YOU ARE DEALING WITH.
    
    Description : This class Generated the security SOAP Header that is required for signing the SOAP Message digitally with client cert.
    VF Page     : 
    Test Class  : Covered by parent Class' test classes.
**/
/*
    Created Date : Akshay Bairagi
    Created By   : 14/09/2016
    SR NO        : SR_OptiMUS_EON_022
    WARNING - PLEASE DO NOT MAKE ANY CHANGES TO THIS CLASS, AS SINGLE WHITE SPACE OR EXTRA CHARACTER CAN 
    CRITICALLY CHANGE THE DIGEST VALUE AND SUBSEQUENTLY SIGNATURE VALUE WHICH WILL BREAK THE CONNECTIVITY.
    PLEASE DO NOT MAKE ANY AMENDMENTS IF YOU ARE NOT SURE WHAT YOU ARE DEALING WITH.
*/
public with sharing class EON_WSSGlobalHeaderGenerator{

    public static String generateXMLSignature(String BodyString,String ActionString,String MessageIDString,String ReplyToString,String ToString,String Key){
        // 1. Apply the Transforms, as determined by the application, to the data object.
        // (no transforms are done, since the body should be delivered in canonicalized form (Force.com offers no canonicalization algorithm))
        
        // 2. Calculate the digest value over the resulting data object. 
        
        Blob bodyDigest = Crypto.generateDigest('SHA-256',Blob.valueOf(BodyString));
        Blob ActionDigest = Crypto.generateDigest('SHA-256',Blob.valueOf(ActionString));
        Blob MessageIDDigest = Crypto.generateDigest('SHA-256',Blob.valueOf(MessageIDString));
        Blob ReplyToDigest = Crypto.generateDigest('SHA-256',Blob.valueOf(ReplyToString));
        Blob ToDigest = Crypto.generateDigest('SHA-256',Blob.valueOf(ToString));
            
        // 3. Create a Reference element, including the (optional) identification of the data object, any (optional) transform elements, the digest algorithm and the DigestValue.
        // (Note, it is the canonical form of these references that are signed and validated in next steps.)

        String referenceString = '';
        //referenceString += '';
        referenceString += '<Reference URI="#_1">';
        referenceString += '<Transforms>';
        referenceString += '<Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></Transform>';
        referenceString += '</Transforms>';
        referenceString += '<DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"></DigestMethod>';
        referenceString += '<DigestValue>'+EncodingUtil.base64Encode(bodyDigest)+'</DigestValue>';
        referenceString += '</Reference>';       
        // '<ds:Reference URI="#_2">'
        referenceString += '<Reference URI="#_2">';
        referenceString += '<Transforms>';
        referenceString += '<Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></Transform>';
        referenceString += '</Transforms>';
        referenceString += '<DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"></DigestMethod>';
        referenceString += '<DigestValue>'+EncodingUtil.base64Encode(ActionDigest)+'</DigestValue>';
        referenceString += '</Reference>';
        // '<ds:Reference URI="#_3">'
        referenceString += '<Reference URI="#_3">';
        referenceString += '<Transforms>';
        referenceString += '<Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></Transform>';
        referenceString += '</Transforms>';
        referenceString += '<DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"></DigestMethod>';
        referenceString += '<DigestValue>'+EncodingUtil.base64Encode(MessageIDDigest)+'</DigestValue>';
        referenceString += '</Reference>';
        // '<ds:Reference URI="#_4">'
        referenceString += '<Reference URI="#_4">';
        referenceString += '<Transforms>';
        referenceString += '<Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></Transform>';
        referenceString += '</Transforms>';
        referenceString += '<DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"></DigestMethod>';
        referenceString += '<DigestValue>'+EncodingUtil.base64Encode(ReplyToDigest)+'</DigestValue>';
        referenceString += '</Reference>';
        // '<ds:Reference URI="#_5">'
        referenceString += '<Reference URI="#_5">';
        referenceString += '<Transforms>';
        referenceString += '<Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></Transform>';
        referenceString += '</Transforms>';
        referenceString += '<DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"></DigestMethod>';
        referenceString += '<DigestValue>'+EncodingUtil.base64Encode(ToDigest)+'</DigestValue>';
        referenceString += '</Reference>';
        
        // 4. Create SignedInfo element with SignatureMethod, CanonicalizationMethod and Reference(s).
        String signedInfoString = '';
        signedInfoString += '<SignedInfo xmlns="http://www.w3.org/2000/09/xmldsig#"><CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></CanonicalizationMethod><SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"></SignatureMethod>';
        signedInfoString += referenceString;
        signedInfoString += '</SignedInfo>';
        
        system.debug('--signedInfoString--'+signedInfoString);
        
        // 5. Canonicalize and then calculate the SignatureValue over SignedInfo based on algorithms specified in SignedInfo.
        // (no canonicalization is done, since the signedinfo element should be delivered in canonicalized form (Force.com offers no canonicalization algorithm))

        String algorithmName = 'RSA-SHA256';
        
        Blob privateKey = EncodingUtil.base64Decode(key);
        
        Blob siBlob = Blob.valueOf(signedInfoString);
        
        //Creating signature using private key
        Blob signatureValue = Crypto.sign(algorithmName, siBlob, privateKey);
        
        //Creating signature using salesforce certificate reference
        //Blob signatureValue = Crypto.signWithCertificate(algorithmName, siBlob, 'MUS_EON_UAT_SF2_SN_CA');
        
        String signatureValueString = EncodingUtil.base64Encode(signatureValue);

        // 6. Construct the Signature element that includes SignedInfo, Object(s) (if desired, encoding may be different than that used for signing), KeyInfo (if required), and SignatureValue. 
        String signatureString = '';
        
        signatureString += '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">';
        signatureString += signedInfoString; 
        signatureString += '<SignatureValue>'+signatureValueString+'</SignatureValue>';
        signatureString += '<KeyInfo><o:SecurityTokenReference><o:Reference ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3" URI="#uuid-9d8b74a8-f5e8-48c5-9bfd-47a28a72ca1c-2"></o:Reference></o:SecurityTokenReference></KeyInfo></Signature>';
        
        return signatureString;
    }
    public static string generateXMLResponse(String actionValue,String canonicalizedBody){
        //Certificate in base64 encoding:
        string binarycert = 'MIID9TCCAt2gAwIBAgIJAPX0oM6Trc7rMA0GCSqGSIb3DQEBCwUAMIGQMQswCQYDVQQGEwJHQjEWMBQGA1UECAwNSGVydGZvcmRzaGlyZTESMBAGA1UEBwwJU3RldmVuYWdlMQswCQYDVQQKDAJJVDELMAkGA1UECwwCSVQxDTALBgNVBAMMBE1vcnIxLDAqBgkqhkiG9w0BCQEWHWFrc2hheS5iYWlyYWdpQG1vcnJpc29udXMuY29tMB4XDTE2MDkwMTExMDYzN1oXDTE3MDkwMTExMDYzN1owgZAxCzAJBgNVBAYTAkdCMRYwFAYDVQQIDA1IZXJ0Zm9yZHNoaXJlMRIwEAYDVQQHDAlTdGV2ZW5hZ2UxCzAJBgNVBAoMAklUMQswCQYDVQQLDAJJVDENMAsGA1UEAwwETW9ycjEsMCoGCSqGSIb3DQEJARYdYWtzaGF5LmJhaXJhZ2lAbW9ycmlzb251cy5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBuKsUD4DRkB2kGJ9PzWj14VPS4hGimnU5F0l52uqsYOOsiP9MQbvsD2awvui7qhN3zAbg0ch9VTE9iFScCM4fizUW7+54FHzgni1UeiQzReFs6cKgPPBEfVpQ8OW0pdY2FU5sVgDW9d4qvcoMkNhpi7Oop/OHtiwELfab6tA1zioweCxj0YU9Z8YS+3mM0mBVRFzXUMEERTD/uyJqNKe5tJKejtr6RJOK/Zlp4GBSBjaF0iVMz+devgHyC54HDBSu0cQl4T4ZWHtNHJ+zpNCQ/+wAOsW97ocRZB5Mglq1hBitsW3F1c3aHomGWgZOeLie+T5XbJAfrBeuvd0rmxaNAgMBAAGjUDBOMB0GA1UdDgQWBBSlTFD7DqcHoeiJB/R5hb0buZsJzzAfBgNVHSMEGDAWgBSlTFD7DqcHoeiJB/R5hb0buZsJzzAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAMbThBij232+Ub9+theAeNm+vCn78Vr1HLask8eDOKOe87Nf8JO/yMxsWSIXwEgbJADTmdDCxHlsqNb2RdIM/Vl7g+ROUr68twIszbIxkLC51hI0WTP3mq50M1BOE9Brzjysrz8AwbsDyYHXdCZn88s6lQAGXv626HvgLswybsYarJ7PnJoQqSTkF/h3zFkHo31OC5rxB50wRQq9nUijjiuGXM4OBnvGaX6QlbRFpA4XEULETXWslj0nNZ6rFm8lcszj/6XrU+sNCRgrIpX66MpVvwfluWhsTH3SkbfOWj7xFHFQRMrodnLWA5SbVR+yORM2ufTzTkZ0V5G1iBlEzD';
            
        // decrypted private key pkcs8 format from certificate
        /* Openssl command for converting private key into PKCS8 format-[pkcs8 -topk8 -nocrypt -in PRIVATEKEYFILENAME.pem -outform PEM]
        Please note that PRIVATEKEYFILENAME.pem can be PRIVATEKEYFILENAME.key as well in syntax depending on extension of private key file.
        */
        String key = 'MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDBuKsUD4DRkB2kGJ9PzWj14VPS4hGimnU5F0l52uqsYOOsiP9MQbvsD2awvui7qhN3zAbg0ch9VTE9iFScCM4fizUW7+54FHzgni1UeiQzReFs6cKgPPBEfVpQ8OW0pdY2FU5sVgDW9d4qvcoMkNhpi7Oop/OHtiwELfab6tA1zioweCxj0YU9Z8YS+3mM0mBVRFzXUMEERTD/uyJqNKe5tJKejtr6RJOK/Zlp4GBSBjaF0iVMz+devgHyC54HDBSu0cQl4T4ZWHtNHJ+zpNCQ/+wAOsW97ocRZB5Mglq1hBitsW3F1c3aHomGWgZOeLie+T5XbJAfrBeuvd0rmxaNAgMBAAECggEAFglKtLJ6xdvt8z+1x58nJGkoXuHGfceyM/dZLVpgvZEb9QF0gRktJlIuLUbaNJbJNiRoV+SlONSbEFPUxBcgU2hDdsN+TfyOpAJ6R5TJT2fQl9ITiKTF9BSKVJDCoIUI1AgibqJt4AYB6rzCIiHL7F2u5y2Lv1FSunr8BYp1etkw208Yj772BKGenI5c6SjBZBpktLJh7geDRaaSMOR9LnxALfYpdsdUWmCYKZxIiLSD5MJ+bxP0Z7PLYMfqU5sHNdL6lHsPA/NZi0dgw5Wf8pgFfVOs7PHQtcwSEUkFlmLpJsbGxAnKGEp3V+wAycZdcBqX7hBclIdMYhs6enIHpQKBgQD7ePqFlswUoxv/JUCaK5AZC6NHvoDvluVPfeRqWIdXrq9ZayOcEK4LDBXrra88LwnwbAXQe6/mtmWcJJ80sr3RKze9TaJFu7LetV3m2DmAQ0dlI7kociqkMSxKO5J/tdntWblmUz85o+5Rfd47lhMJ8lhnxZsf3exjFtkdbJiI4wKBgQDFNYSXsmy02VsD8ZOs4hPMZFF9hRSua9kxCBOkes0BX1fSNbU7g9AvOTKoRKQsT1Ddj/JWngPCTx/w5Db5xvPjimT1YnCkZ94VPV3QnwmH/pqdReNetVVTSCu+3dY+H1fFSDoutDERNEfJyloL1dro3QuzfI1SSEcKOMlt26GtzwKBgQC4QBG+Y5iv3jqbHR5SV2zDDQXbgTdTVIo7ThBX4vl3QyRzLc7vgEElEvvUrHNic0yi/WLdOGLPdgDJAQQtRnFRmorChulIkpgiGVzt0KuA0Mq0zhHSEqQvnV/IHBHgxMsh3sW6tW/zuarZxpFXs0PL2+buUZixJpcWmx0FNBYm5QKBgQCcj9FVEUymAsz0A4ymutDW+mmLieSSWIKUH4JgmTE5vrSc6RCZUBst8m3aEqx3lPxw+X997nKzh1enSbavc5hZ85wVB3K/wsoX+KELJ8dMVP/wjfRlUvaLaId6PumAZierMp0mSN2Pd/7qH6B/NudU6XAJrX8QbNshLVYUxkHEFwKBgQDMP6wbGPJ9BDxAJ2o4QCb6jNoqZBjDaXJnAsL6UGE13ZVe+yWwFybIgQkwqP3T3rJHu4tEzneM7OHzQ+nWIWZzeMxgp/JxN7ndXgpMd8BtP9rAWvcgtOi7ZACjQDIDRQxdi5ng69RuWfzNpVaX6kr7Mn7kaYdjeZnE+9og2qG2cw==';
            
        String docSignatureString = '';
        string Body = canonicalizedBody.trim();
        string Action = '<a:Action xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" u:Id="_2" s:mustUnderstand="1">'+actionValue.trim()+'</a:Action>';
        string MessageID = '<a:MessageID xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" u:Id="_3">urn:uuid:ee45b682-3493-4b8d-a39d-dd709ddb16e8</a:MessageID>';
        string ReplyTo = '<a:ReplyTo xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" u:Id="_4"><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo>';
        string To = '<a:To xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" u:Id="_5" s:mustUnderstand="1">https://ppsmartooa.morrisonus.com/OutOfAreaInstallationInboundService.svc</a:To>';
                        
        docSignatureString = generateXMLSignature(Body,Action,MessageID,ReplyTo,To,Key);
        system.debug('--docSignatureString--'+docSignatureString);
        string strResponseXML = '';
        strResponseXML = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><s:Header><a:Action s:mustUnderstand="1" u:Id="_2">'+actionValue.trim()+'</a:Action><a:MessageID u:Id="_3">urn:uuid:ee45b682-3493-4b8d-a39d-dd709ddb16e8</a:MessageID><a:ReplyTo u:Id="_4"><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand="1" u:Id="_5">https://ppsmartooa.morrisonus.com/OutOfAreaInstallationInboundService.svc</a:To><o:Security s:mustUnderstand="1" xmlns:o="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><o:BinarySecurityToken u:Id="uuid-9d8b74a8-f5e8-48c5-9bfd-47a28a72ca1c-2" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3" EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">'+binarycert+'</o:BinarySecurityToken>'+docSignatureString+'</o:Security></s:Header>'+Body.trim()+'</s:Envelope>';
        system.debug('@@ Request in xml format :->'+strResponseXML );
        return strResponseXML;
    }
}