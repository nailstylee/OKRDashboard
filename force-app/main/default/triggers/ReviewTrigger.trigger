trigger ReviewTrigger on Review__c (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Review__c review : Trigger.new) {
            if (review.Key_Result__c != null) {
                keyResultIds.add(review.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Review__c review : Trigger.old) {
            if (review.Key_Result__c != null) {
                keyResultIds.add(review.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Review_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Review__c WHERE Key_Result__c = :kr.Id];
            kr.Review_Completed__c = count;
        }
        update keyResults;
    }
}
