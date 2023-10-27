global with sharing class ManageInactivateAccountsSchedulable implements Schedulable{
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new ManageInactivateAccountsBatch());
      }
        //ManageInactivateAccountsSchedulable job = new ManageInactivateAccountsSchedulable ();
        //String sch = '0 0 0/6 ? * MON-FRI *';
        //System.schedule('InactivateAccounts', sch, job);
}