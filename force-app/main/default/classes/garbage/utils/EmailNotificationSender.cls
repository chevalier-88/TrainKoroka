public with sharing class EmailNotificationSender {


    public static String sendMail(String address, String subject, String body) {
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		if(String.isEmpty(address)) {
            return 'Email address- '+address+' is not correct';
        }
        String[] toAddresses = new String[] {address};
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);

        // Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
        // Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        if (results[0].success){
            return 'OK';
        }else{
            return 'The email failed to send: ' + results[0].errors[0].message+'!';
        }
    }
}