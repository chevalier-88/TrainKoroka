@RestResource(urlMapping='/Employees/*')
global with sharing class EmployRest {

    // 00509000007SsO0AAK

    @HttpPost
    global static void createCase() {
        
        RestRequest req = RestContext.request;
        
        String fileName = req.params.get('filename');
        String accId = req.params.get('accid');

        Blob blobBase64 = req.requestBody;

        // String strr = EncodingUtil.base64Encode(blobBase64);
        // System.debug('----> '+strr);


        ContentVersion cv = new ContentVersion();
        cv.VersionData = blobBase64;
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        
        System.debug('----> blob file: '+cv);

        try {
                insert cv;
            } catch(DMLException e) {
                System.debug(e);
            }

        ContentDocumentLink cdl = createContentLink(cv.Id, accId);

        System.debug('-----> doc link: '+cdl);

        
    } 


    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [ SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        return cdl;


        // try {
        // insert cdl;
        // return cdl;
        // } catch(DMLException e) {
        // System.debug(e);
        // return null;
        // }
    }
}