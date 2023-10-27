public with sharing class ManageInactivateAccountsBatch implements Database.Batchable<sObject> {
    public ManageInactivateAccountsBatch() {
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Inativa__c, 
                                        (SELECT Id FROM Tasks WHERE CreatedDate = LAST_90_DAYS),
                                        (SELECT Id FROM Opportunities WHERE (IsWon = true AND CloseDate = LAST_N_DAYS:120) OR StageName = 'Negotiation/Review' )
                                        FROM Account WHERE Inativa__c = false WITH SECURITY_ENFORCED]);
   }

   public void execute(Database.BatchableContext BC, List<Account> scope){
        List<Account> accList = new List<Account>();
        for (Account acc : scope) {
            if (acc.Tasks.size() == 0 || acc.Opportunities.size() == 0) {
                acc.Inativa__c = true;
                accList.add(acc);
            }
        }
        if (!accList.isEmpty()) {
            Database.update(accList);
        }
        
    }

   public void finish(Database.BatchableContext BC){
   }
}