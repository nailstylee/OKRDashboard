@isTest
public class ActivityControllerTest {

    @TestSetup
    static void setup() {
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User assignedUser = new User(
            Username = 'uniqueUsername' + DateTime.now().getTime() + '@test.com',
            Email = 'testuser@example.com',
            Alias = 'testusr',
            ProfileId = standardProfile.Id,
            LastName = 'Test',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US'
        );
        insert assignedUser;

        Objective__c testObjective = new Objective__c(
            Name = 'Test Objective',
            Year__c = 2024,
            Assigned_User__c = assignedUser.Id
        );
        insert testObjective;

        Key_Result__c keyResult = new Key_Result__c(
            Name = 'Sample Key Result',
            Objective__c = testObjective.Id
        );
        insert keyResult;

        Task testTask = new Task(
            Subject = 'Test Task', 
            Priority = 'Normal',  
            Status = 'Completed',
            WhatId = keyResult.Id,
            OwnerId = assignedUser.Id,
            Key_Result__c = keyResult.Id
        );
        insert testTask;

        Event testEvent = new Event(
            Subject = 'Call',
            StartDateTime = DateTime.now().addHours(1),
            EndDateTime = DateTime.now().addHours(2),
            WhatId = keyResult.Id,
            OwnerId = assignedUser.Id,
            Key_Result__c = keyResult.Id 
        );
        insert testEvent;
    }

    @isTest
    static void testGetActivitiesWithValidKeyResultId() {
        Key_Result__c testKeyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Sample Key Result' LIMIT 1];

        Test.startTest();
        List<SObject> activities = ActivityController.getActivities(testKeyResult.Id);
        Test.stopTest();

        System.assertEquals(2, activities.size(), 'There should be two activities related to the Key Result.');
        System.assert(activities[0] instanceof Task, 'The first activity should be a Task.');
        System.assert(activities[1] instanceof Event, 'The second activity should be an Event.');
    }
}
