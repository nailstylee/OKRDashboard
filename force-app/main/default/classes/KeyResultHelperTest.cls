@isTest
public class KeyResultHelperTest {

    @TestSetup
    static void setupTestData() {
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User testUser = new User(
            Username = 'uniqueUsername' + DateTime.now().getTime() + '@test.com',
            Email = 'testuser@example.com',
            Alias = 'tuser',
            ProfileId = standardProfile.Id,
            LastName = 'Test',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        System.runAs(testUser) {
            Objective__c objective = new Objective__c(
                Name = 'Test Objective',
                Year__c = 2023,
                Assigned_User__c = testUser.Id
            );
            insert objective;

            Key_Result__c keyResult = new Key_Result__c(
                Name = 'Test Key Result',
                Objective__c = objective.Id
            );
            insert keyResult;
            Task task = new Task(Subject = 'Test Task', WhatId = keyResult.Id, Type = 'Call', OwnerId = testUser.Id, Key_Result__c = keyResult.Id);
            insert task;

            Event event = new Event(Subject = 'Test Event', WhatId = keyResult.Id, StartDateTime = System.now(), EndDateTime = System.now().addHours(1), OwnerId = testUser.Id, Key_Result__c = keyResult.Id);
            insert event;
        }
    }

    @isTest
    public static void testUpdateKeyResultCounts() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];

        Test.startTest();
        Set<Id> keyResultIds = new Set<Id>{keyResult.Id};
        KeyResultHelper.updateKeyResultCounts(keyResultIds);
        Test.stopTest();

        Key_Result__c updatedKeyResult = [SELECT Id, Completed__c FROM Key_Result__c WHERE Id = :keyResult.Id];

        System.assertEquals(2, updatedKeyResult.Completed__c, 'The completed count should be 2 (1 Task + 1 Event).');
    }

    @isTest
    public static void testUpdateKeyResultCountsWithNoTasksOrEvents() {
        Key_Result__c keyResult = new Key_Result__c(
            Name = 'Empty Key Result',
            Objective__c = [SELECT Id FROM Objective__c LIMIT 1].Id
        );
        insert keyResult;

        Test.startTest();
        Set<Id> keyResultIds = new Set<Id>{keyResult.Id};
        KeyResultHelper.updateKeyResultCounts(keyResultIds);
        Test.stopTest();

        Key_Result__c updatedKeyResult = [SELECT Id, Completed__c FROM Key_Result__c WHERE Id = :keyResult.Id];

        System.assertEquals(0, updatedKeyResult.Completed__c, 'The completed count should be 0 for a key result with no tasks or events.');
    }

    @isTest
    public static void testUpdateKeyResultCountsWithEmptySet() {
        Test.startTest();
        KeyResultHelper.updateKeyResultCounts(new Set<Id>());
        Test.stopTest();

    }
}
