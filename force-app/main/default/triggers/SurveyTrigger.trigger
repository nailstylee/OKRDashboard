trigger SurveyTrigger on Survey__c (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Survey__c survey : Trigger.new) {
            if (survey.Key_Result__c != null) {
                keyResultIds.add(survey.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Survey__c survey : Trigger.old) {
            if (survey.Key_Result__c != null) {
                keyResultIds.add(survey.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Survey_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Survey__c WHERE Key_Result__c = :kr.Id];
            kr.Survey_Completed__c = count;
        }
        update keyResults;
    }
}
