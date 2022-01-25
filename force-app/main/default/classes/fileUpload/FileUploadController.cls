public with sharing class FileUploadController{
  private String base64Data;
  private String filename;
  private String accId;
    
  @AuraEnabled(cacheable=true)
  public static List<Contact> getContactsRelatedToAccount(String accId) {
    System.debug('accId >> ' + accId);
    return [SELECT Id, FirstName, LastName, Email, Phone from Contact where AccountId = :accId];
  }

  @AuraEnabled
  public static List<Contact> saveFile(String base64Data, String filename, String accId) {
    
    Blob sourceContactValue = EncodingUtil.base64Decode(base64Data);
    ContentVersion cv = createContentVersion(sourceContactValue, filename);
    ContentDocumentLink cdl = createContentLink(cv.Id, accId);


    List<Contact> contactList = new list<Contact>();
    List<String> contactSourceList = sourceContactValue.toString().split('\n');
    System.debug('apex: print contact list: '+contactSourceList);

    for(Integer i = 1; i < contactSourceList.size(); i++){
      Contact contactObj = new Contact();
      list<String> csvRowData = contactSourceList[i].split(',');

      contactObj.FirstName = csvRowData[0].trim();
      contactObj.LastName = csvRowData[1].trim();
      // contactObj.AccountId = accId;
      contactObj.AccountId = '00109000014JXhSAAW';
      contactList.add(contactObj);
    }
    try{    
      if(!contactList.isEmpty()) {
        insert contactList;
      }
    }catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    } 
    return contactList;
  }

  private static ContentVersion createContentVersion(Blob base64, String filename) {
    ContentVersion cv = new ContentVersion();
    cv.VersionData = base64;
    // cv.VersionData = EncodingUtil.base64Decode(base64);
    cv.Title = filename;
    cv.PathOnClient = filename;
    try {
      insert cv;
      return cv;
    } catch(DMLException e) {
      System.debug(e);
      return null;
    }
  }
   private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
              if (contentVersionId == null || recordId == null) { return null; }
    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.ContentDocumentId = [
      SELECT ContentDocumentId 
      FROM ContentVersion 
      WHERE Id =: contentVersionId
    ].ContentDocumentId;
    cdl.LinkedEntityId = recordId;
    cdl.ShareType = 'V';
    try {
      insert cdl;
      return cdl;
    } catch(DMLException e) {
      System.debug(e);
      return null;
    }
  }
}