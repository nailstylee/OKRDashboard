trigger ContractTrigger on Contract (after insert, after update, after delete, after undelete) {
    Set<Id> keyResultIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Contract contract : Trigger.new) {
            if (contract.Key_Result__c != null) {
                keyResultIds.add(contract.Key_Result__c);
            }
        }
    }

    if (Trigger.isDelete) {
        for (Contract contract : Trigger.old) {
            if (contract.Key_Result__c != null) {
                keyResultIds.add(contract.Key_Result__c);
            }
        }
    }

    if (!keyResultIds.isEmpty()) {
        List<Key_Result__c> keyResults = [SELECT Id, Contract_Completed__c FROM Key_Result__c WHERE Id IN :keyResultIds];
        for (Key_Result__c kr : keyResults) {
            Integer count = [SELECT COUNT() FROM Contract WHERE Key_Result__c = :kr.Id];
            kr.Contract_Completed__c = count;
        }
        update keyResults;
    }
}
