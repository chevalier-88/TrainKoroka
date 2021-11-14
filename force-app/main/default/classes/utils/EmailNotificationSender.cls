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

        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        if (!results.get(0).isSuccess()) {
            return 'OK';
        }else{
            return 'The email failed to send: ' + results.get(0).getErrors()[0].getMessage();
        }
    }
}