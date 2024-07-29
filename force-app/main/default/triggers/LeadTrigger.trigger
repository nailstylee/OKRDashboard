trigger LeadTrigger on Lead (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Lead lead : Trigger.new) {
            if (lead.Key_Result__c != null) {
                keyResultIds.add(lead.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Lead lead : Trigger.old) {
            if (lead.Key_Result__c != null) {
                keyResultIds.add(lead.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Lead_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Lead WHERE Key_Result__c = :kr.Id];
            kr.Lead_Completed__c = count;
        }
        update keyResults;
    }
}
