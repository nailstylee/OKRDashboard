public class OKRController {
    @AuraEnabled(cacheable=true)
    public static List<Objective__c> getObjectives(Decimal year, String userId) {
        return [SELECT Id, Name, Year__c, 
                (SELECT Id, Name, Survey_Target__c, Survey_Completed__c, 
                        Review_Target__c, Review_Completed__c, 
                        Trackable_Objects__c,
                        Lead_Target__c, Lead_Completed__c,
                        Opportunity_Target__c, Opportunity_Completed__c,
                        Google_Review_Target__c, Google_Review_Completed__c,
                        Case_Study_Target__c, Case_Study_Completed__c,
                        Contract_Target__c, Contract_Completed__c,
                        Call_Target__c, Call_Completed__c,
                        Event_Target__c, Event_Completed__c
                 FROM Key_Results__r)
                FROM Objective__c 
                WHERE Year__c = :year AND Assigned_User__c = :userId];
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getUsers() {
        return [SELECT Id, Name FROM User WHERE IsActive = true AND UserType = 'Standard'];
    }

    @AuraEnabled(cacheable=true)
    public static List<Task> getCallsForKeyResult(String keyResultId) {
        return [SELECT Id, Subject, Type FROM Task WHERE Key_Result__c = :keyResultId AND Subject = 'Call'];
    }

    @AuraEnabled(cacheable=true)
    public static List<Event> getEventsForKeyResult(String keyResultId) {
        return [SELECT Id, Subject, Type FROM Event WHERE Key_Result__c = :keyResultId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesForKeyResult(String keyResultId) {
        return [SELECT Id, Name, StageName FROM Opportunity WHERE Key_Result__c = :keyResultId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contract> getContractsForKeyResult(String keyResultId) {
        return [SELECT Id, ContractNumber, Status FROM Contract WHERE Key_Result__c = :keyResultId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Lead> getLeadsForKeyResult(String keyResultId) {
        return [SELECT Id, Name, Status FROM Lead WHERE Key_Result__c = :keyResultId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Survey__c> getSurveysForKeyResult(String keyResultId) {
        return [SELECT Id, Name, Survey_Status__c FROM Survey__c WHERE Key_Result__c = :keyResultId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Review__c> getReviewsForKeyResult(String keyResultId) {
        return [SELECT Id, Name, Review_Rating__c FROM Review__c WHERE Key_Result__c = :keyResultId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Google_Review__c> getGoogleReviewsForKeyResult(String keyResultId) {
        return [SELECT Id, Name, Rating__c FROM Google_Review__c WHERE Key_Result__c = :keyResultId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Case_Study__c> getCaseStudiesForKeyResult(String keyResultId) {
        return [SELECT Id, Name, Status__c FROM Case_Study__c WHERE Key_Result__c = :keyResultId];
    }
}
