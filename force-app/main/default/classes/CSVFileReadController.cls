public with sharing class CSVFileReadController {
    
    @AuraEnabled
    public static list<Contact> csvFileRead(Id contentDocumentId){
        list<Contact> contactInsertList = new list<Contact>();
        if(contentDocumentId != null) {
            
            // Fetch File Data based on the basic of document id 
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            // split the file data
            list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');

            for(Integer i = 1; i < csvRecordsList.size(); i++){
                Contact contactObj = new Contact();
                list<String> csvRowData = csvRecordsList[i].split(',');
                System.debug('csvRowData====> '+csvRowData);
                contactObj.FirstName = csvRowData[0];
                contactObj.LastName = csvRowData[1];
                contactInsertList.add(contactObj);
            }

            try{    
                if(!contactInsertList.isEmpty()) {
                    insert contactInsertList;

                }
            }
            catch (Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            } 
        }
        return contactInsertList;    
    }
}