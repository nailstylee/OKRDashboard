trigger CallTrigger on Task (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Task call : Trigger.new) {
            if (call.Key_Result__c != null && call.Type == 'Call') {
                keyResultIds.add(call.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Task call : Trigger.old) {
            if (call.Key_Result__c != null && call.Type == 'Call') {
                keyResultIds.add(call.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Call_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Task WHERE Key_Result__c = :kr.Id AND Type = 'Call'];
            kr.Call_Completed__c = count;
        }
        update keyResults;
    }
}
