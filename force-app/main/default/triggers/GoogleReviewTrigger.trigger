trigger GoogleReviewTrigger on Google_Review__c (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Google_Review__c googleReview : Trigger.new) {
            if (googleReview.Key_Result__c != null) {
                keyResultIds.add(googleReview.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Google_Review__c googleReview : Trigger.old) {
            if (googleReview.Key_Result__c != null) {
                keyResultIds.add(googleReview.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Google_Review_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Google_Review__c WHERE Key_Result__c = :kr.Id];
            kr.Google_Review_Completed__c = count;
        }
        update keyResults;
    }
}
