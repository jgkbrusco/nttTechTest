public with sharing class AccountController {
    @AuraEnabled
    public static void updateAccount(String accId, String name, String document, String type){

        try {
            List<Account> accList = [SELECT Name, AccountNumber, Type FROM Account WHERE Id =: accId WITH SECURITY_ENFORCED];
            accList[0].Name = name!= null ? name : accList[0].Name;
            accList[0].AccountNumber = document != null ? document : accList[0].AccountNumber;
            accList[0].Type = type != null ? type : accList[0].Type;
            update accList;            
        } catch (DMLException dml) {
            throw new AuraHandledException('Número do cliente é inválido');
        }
        
    }
}