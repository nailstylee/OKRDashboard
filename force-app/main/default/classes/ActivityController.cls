public with sharing class ActivityController {
    @AuraEnabled(cacheable=true)
    public static List<Task> getActivities(Id keyResultId) {
        List<Task> tasks = [SELECT Id, Subject, Type FROM Task WHERE WhatId = :keyResultId];
        List<Event> events = [SELECT Id, Subject FROM Event WHERE WhatId = :keyResultId];
        List<SObject> activities = new List<SObject>();
        activities.addAll(tasks);
        activities.addAll(events);
        return activities;
    }
}
