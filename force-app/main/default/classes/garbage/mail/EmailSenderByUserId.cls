public with sharing class EmailSenderByUserId {

Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
mail1.setTargetObjectId(con1.Id);
mail1.setTemplateId('00X90000000QHUD');

Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
mail2.setTargetObjectId(con2.Id);
mail2.setTemplateId('00X90000000QHUD');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1, mail2 });
}

//-0-0-0-0-0-0-0-0-0-0-0-0-

String userId = UserInfo.getUserId();


//0-0-0-0-0-0-0-0-0-0-0-0-0-0-

private static void sendMyTemplate(Id userId, Id mergedObjectId) {
  User user = [select email, firstName, lastName from User where id = :userId];
  Contact tempContact = new Contact(email = user.email, firstName = user.firstName, lastName = user.lastName);
  insert tempContact;
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  mail.setTargetObjectId(tempContact.id); 
  mail.setTemplateId(template.Id);
  mail.setWhatId(mergedObjectId); 
  Messaging.sendEmail(new Messaging.singleemailMessage[] {mail});
  delete tempContact;
}


//-0-0-0-0-0-0-0-0-0-0-
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setTargetObjectId(t.OwnerId); 
        mail.setTemplateId(et.Id);
        mail.setWhatId(t.Id); 
        mail.SaveAsActivity = false;
        Messaging.sendEmail(new Messaging.singleemailMessage[] {mail});