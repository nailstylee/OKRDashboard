@isTest
public class OKRControllerTest {
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

            // Create a Task with subject 'Call'
            Task callTask = new Task(
                Subject = 'Call',
                WhatId = keyResult.Id,
                OwnerId = testUser.Id,
                Key_Result__c = keyResult.Id
            );
            insert callTask;
        }
    }

    @isTest
    public static void testGetObjectives() {
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        List<Objective__c> objectives = OKRController.getObjectives(2023, testUser.Id);
        System.assertNotEquals(0, objectives.size(), 'Should have at least one objective');
    }

    @isTest
    public static void testGetUsers() {
        List<User> users = OKRController.getUsers();
        System.assertNotEquals(0, users.size(), 'Should have at least one user');
    }

    @isTest
    public static void testGetCallsForKeyResult() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];
        List<Task> calls = OKRController.getCallsForKeyResult(keyResult.Id);
        System.assertEquals(1, calls.size(), 'Should have one call initially');
    }

    @isTest
    public static void testGetEventsForKeyResult() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];
        List<Event> events = OKRController.getEventsForKeyResult(keyResult.Id);
        System.assertEquals(0, events.size(), 'Should have no events initially');
    }

    @isTest
    public static void testGetOpportunitiesForKeyResult() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];
        List<Opportunity> opportunities = OKRController.getOpportunitiesForKeyResult(keyResult.Id);
        System.assertEquals(0, opportunities.size(), 'Should have no opportunities initially');
    }

    @isTest
    public static void testGetContractsForKeyResult() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];
        List<Contract> contracts = OKRController.getContractsForKeyResult(keyResult.Id);
        System.assertEquals(0, contracts.size(), 'Should have no contracts initially');
    }

    @isTest
    public static void testGetLeadsForKeyResult() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];
        List<Lead> leads = OKRController.getLeadsForKeyResult(keyResult.Id);
        System.assertEquals(0, leads.size(), 'Should have no leads initially');
    }

    @isTest
    public static void testGetSurveysForKeyResult() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];
        List<Survey__c> surveys = OKRController.getSurveysForKeyResult(keyResult.Id);
        System.assertEquals(0, surveys.size(), 'Should have no surveys initially');
    }

    @isTest
    public static void testGetReviewsForKeyResult() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];
        List<Review__c> reviews = OKRController.getReviewsForKeyResult(keyResult.Id);
        System.assertEquals(0, reviews.size(), 'Should have no reviews initially');
    }

    @isTest
    public static void testGetGoogleReviewsForKeyResult() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];
        List<Google_Review__c> googleReviews = OKRController.getGoogleReviewsForKeyResult(keyResult.Id);
        System.assertEquals(0, googleReviews.size(), 'Should have no Google reviews initially');
    }

    @isTest
    public static void testGetCaseStudiesForKeyResult() {
        Key_Result__c keyResult = [SELECT Id FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];
        List<Case_Study__c> caseStudies = OKRController.getCaseStudiesForKeyResult(keyResult.Id);
        System.assertEquals(0, caseStudies.size(), 'Should have no case studies initially');
    }
}
