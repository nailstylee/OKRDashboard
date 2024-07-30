public class KeyResultHelper {
    public static void updateKeyResultCounts(Set<Id> keyResultIds) {
        if (keyResultIds.isEmpty()) {
            return;
        }

        List<Key_Result__c> keyResultsToUpdate = new List<Key_Result__c>();

        for (Id keyResultId : keyResultIds) {
            Key_Result__c keyResult = [
                SELECT Id, (SELECT Id FROM Tasks), (SELECT Id FROM Events) 
                FROM Key_Result__c WHERE Id = :keyResultId LIMIT 1
            ];

            Integer taskCount = keyResult.Tasks.size();
            Integer eventCount = keyResult.Events.size();
            keyResult.Completed__c = taskCount + eventCount;  
            keyResultsToUpdate.add(keyResult);
        }

        if (!keyResultsToUpdate.isEmpty()) {
            update keyResultsToUpdate;
        }
    }
}
