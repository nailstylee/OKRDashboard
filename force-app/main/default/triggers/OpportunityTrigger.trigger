trigger OpportunityTrigger on Opportunity (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Opportunity opp : Trigger.new) {
            if (opp.Key_Result__c != null) {
                keyResultIds.add(opp.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Opportunity opp : Trigger.old) {
            if (opp.Key_Result__c != null) {
                keyResultIds.add(opp.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Opportunity_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Opportunity WHERE Key_Result__c = :kr.Id];
            kr.Opportunity_Completed__c = count;
        }
        update keyResults;
    }
}
