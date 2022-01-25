@RestResource(urlMapping='/Account/*')
global with sharing class RestResource {
    
    @HttpGet
    global static Account getRecord() {
        RestRequest request = RestContext.request;

        String accountId = request.requestURI.substring(
        request.requestURI.lastIndexOf('/')+1);
        Account result =  [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];

        return result;
    }    
}