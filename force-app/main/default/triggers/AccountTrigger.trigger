trigger AccountTrigger on Account (after insert, after update) {
    AccountTriggerHelper.doProcess(Trigger.New);
}