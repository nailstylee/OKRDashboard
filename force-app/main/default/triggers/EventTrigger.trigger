trigger EventTrigger on Event (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Event event : Trigger.new) {
            if (event.Key_Result__c != null) {
                keyResultIds.add(event.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Event event : Trigger.old) {
            if (event.Key_Result__c != null) {
                keyResultIds.add(event.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Event_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Event WHERE Key_Result__c = :kr.Id];
            kr.Event_Completed__c = count;
        }
        update keyResults;
    }
}
