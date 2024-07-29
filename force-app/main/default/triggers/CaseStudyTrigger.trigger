trigger CaseStudyTrigger on Case_Study__c (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Case_Study__c caseStudy : Trigger.new) {
            if (caseStudy.Key_Result__c != null) {
                keyResultIds.add(caseStudy.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Case_Study__c caseStudy : Trigger.old) {
            if (caseStudy.Key_Result__c != null) {
                keyResultIds.add(caseStudy.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Case_Study_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Case_Study__c WHERE Key_Result__c = :kr.Id];
            kr.Case_Study_Completed__c = count;
        }
        update keyResults;
    }
}
