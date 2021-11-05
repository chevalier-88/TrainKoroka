
public with sharing class FileUploadController {


    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsRelatedToAccount(String accId) {
        system.debug('accId >> ' + accId);
        return [SELECT Id, FirstName, LastName, Email, Phone from Contact where AccountId = :accId];
    }



        @AuraEnabled
        public static list<Contact> csvFileRead(String recordId, Id contentDocumentId){
        
        list<Contact> contactInsertList = new list<Contact>();
        if(contentDocumentId != null) {
            
            
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            
            list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');

            for(Integer i = 1; i < csvRecordsList.size(); i++){
                Contact contactObj = new Contact();
                list<String> csvRowData = csvRecordsList[i].split(',');

                contactObj.FirstName = csvRowData[0];
                contactObj.LastName = csvRowData[1];
                contactObj.AccountId = recordId;
                contactInsertList.add(contactObj);
            }

            try{    
                if(!contactInsertList.isEmpty()) {
                    insert contactInsertList;
                    // Database.insert(contactInsertList, false);
                }
            }
            catch (Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            } 
        }
        return contactInsertList;    
    }
}