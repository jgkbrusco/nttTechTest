@IsTest
public with sharing class AccountTriggerHelperTest {

    @TestSetup
    static void makeData(){

        Account acc = new Account();
        acc.Name = 'New Test';
        acc.AccountNumber = '12345678901';
        acc.Type = 'CPF';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parceiro').getRecordTypeId();
        insert acc;

        Account acc2 = new Account();
        acc2.Name = 'New Test';
        acc2.AccountNumber = '12345678901234';
        acc2.Type = 'CNPJ';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumidor final').getRecordTypeId();
        insert acc2;
        
    }

    @IsTest
    static void testInvalidDocument(){        
        
        Test.startTest();
        Account acc = [SELECT Id, Name, AccountNumber FROM Account LIMIT 1];
        acc.AccountNumber = '1';
        try {            
            update acc;
        } catch (Exception ex) {
            Assert.areEqual(true, ex.getMessage().contains('Número do cliente é inválido'));
        }
        Test.stopTest();
        
    }

    @IsTest
    static void massInsert(){
        
        List<Account> accList = createMassAccounts(200);
        Test.startTest();
        insert accList;
        Test.stopTest();
        
    }

    private static List<Account> createMassAccounts(Integer qtd){
        List<Account> accList = new List<Account>();
        Id recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parceiro').getRecordTypeId();
        for (Integer i = 0; i < qtd; i++) {
            Account acc = new Account();
            acc.Name = 'Mass test account number ' + i;
            acc.AccountNumber = '12345678901';
            acc.Type = 'CPF';
            acc.RecordTypeId = recordType;
            accList.add(acc);
        }
        return accList;
    }

}