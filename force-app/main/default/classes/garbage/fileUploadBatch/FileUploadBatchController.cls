public with sharing class FileUploadBatchController implements Database.Batchable<sObject>, Database.Stateful {

    public Iterable<SObject> start(Database.BatchableContext bc) {
        
        List<Account> result = [SELECT Id, Name FROM Account LIMIT 1];

        return result;
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        //TODO
    }
    public void finish(Database.BatchableContext bc){
        
    }

}




    
//     public Integer recordsProcessed = 0;


//     public Iterable<SObject> start(Database.BatchableContext bc) {
        
//         List<Account> result = [SELECT Id, Name FROM Account LIMIT 1];

//         return result;
//     }
//     public void execute(Database.BatchableContext bc, List<Account> scope){
//         //TODO
//     }
//     public void finish(Database.BatchableContext bc){
//         System.debug(recordsProcessed + ' records processed. Shazam!');
//         AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
//             JobItemsProcessed,
//             TotalJobItems, CreatedBy.Email
//             FROM AsyncApexJob
//             WHERE Id = :bc.getJobId()];
//         // call some utility to send email
//         EmailUtils.sendMessage(job, recordsProcessed);
//     }

//     @AuraEnabled
// public static Account getAccount(Id accountId) {
//     // do some preprocessing.
//     // execute the batch here
//     Id jobId = Database.executeBatch(new BatchSync()); // optional batch size can be provides as well.
// }
// }