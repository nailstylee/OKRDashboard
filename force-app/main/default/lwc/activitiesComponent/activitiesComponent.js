import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getActivities from '@salesforce/apex/ActivityController.getActivities';

export default class ActivitiesComponent extends NavigationMixin(LightningElement) {
    @api recordId;
    activities;
    error;

    @wire(getActivities, { keyResultId: '$recordId' })
    wiredActivities({ error, data }) {
        if (data) {
            this.activities = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.activities = undefined;
        }
    }

    handleNewCall() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: `Key_Result__c=${this.recordId}, Type=Call`
            }
        });
    }

    handleNewEvent() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: `Key_Result__c=${this.recordId}`
            }
        });
    }
}
