public with sharing class AccountTriggerHelper {

    public static void doProcess(List<Account> newList){
        List<Opportunity> oppList = new List<Opportunity>();
        List<Task> taskList = new List<Task>();
        Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Name FROM RecordType WHERE sObjectType = 'Account']);
        
        for(Account acc : newList){

            Boolean isValid = checkDocuments(acc);
            if(!isValid){
                acc.addError('Número do cliente é inválido');
            }else{
                switch on recordTypes.get(acc.RecordTypeId)?.Name {
                    when 'Parceiro' {
                        oppList.add(createOpp(acc));
                    }
                    when 'Consumidor final' {
                        taskList.add(createTask(acc));
                    }
                }
            }

        }
        if(oppList.size() > 0){
            insert oppList;
        }
        if(taskList.size() > 0){
            insert taskList;
        }

    }

    private static Boolean checkDocuments(Account acc){
        Utils utils = new Utils();
        Boolean valid;
        switch on acc.Type {
            when 'CPF' {
                valid = utils.ValidaCPF(acc.AccountNumber);
            }
            when 'CNPJ' {
                valid = utils.validaCNPJ(acc.AccountNumber);
            }
        }
        return valid;

    }

    private static Opportunity createOpp(Account acc){
        Opportunity opp = new Opportunity();
        opp.Name = acc.Name + ' - opp Parceiro';
        opp.CloseDate = System.today().addDays(30);
        opp.StageName = 'Qualification';
        return opp;
    }

    private static Task createTask(Account acc){
        Task task = new Task();
        task.Subject = 'Consumidor final';
        task.WhatId = Acc.Id;
        task.Status = 'Not Started';
        task.Priority = 'Normal';
        return task;
    }

}