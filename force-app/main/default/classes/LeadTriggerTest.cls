@isTest
public class LeadTriggerTest {

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
                Objective__c = objective.Id,
                Lead_Completed__c = 0 
            );
            insert keyResult;
        }
    }

    @isTest
    public static void testLeadTrigger() {
        User testUser = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        Key_Result__c keyResult = [SELECT Id, Lead_Completed__c FROM Key_Result__c WHERE Name = 'Test Key Result' LIMIT 1];

        System.assertEquals(0, keyResult.Lead_Completed__c, 'Initial Lead_Completed__c should be 0');

        Lead lead = new Lead(LastName = 'Test Lead', Company = 'Test Company', Key_Result__c = keyResult.Id, LeadSource = 'Web');
        insert lead;

        keyResult = [SELECT Id, Lead_Completed__c FROM Key_Result__c WHERE Id = :keyResult.Id];
        System.assertEquals(1, keyResult.Lead_Completed__c, 'Lead_Completed__c should be 1 after inserting a lead');

        delete lead;

        keyResult = [SELECT Id, Lead_Completed__c FROM Key_Result__c WHERE Id = :keyResult.Id];
        System.assertEquals(0, keyResult.Lead_Completed__c, 'Lead_Completed__c should be 0 after deleting the lead');
    }
}
