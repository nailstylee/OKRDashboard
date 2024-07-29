trigger TaskTrigger on Task (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Task task : Trigger.new) {
            if (task.Key_Result__c != null && task.Subject == 'Call') {
                keyResultIds.add(task.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Task task : Trigger.old) {
            if (task.Key_Result__c != null && task.Subject == 'Call') {
                keyResultIds.add(task.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Call_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Task WHERE Key_Result__c = :kr.Id AND Subject = 'Call'];
            kr.Call_Completed__c = count;
        }
        update keyResults;
    }
}
