import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getObjectives from '@salesforce/apex/OKRController.getObjectives';
import getUsers from '@salesforce/apex/OKRController.getUsers';
import { refreshApex } from '@salesforce/apex';

export default class OkrDashboard extends NavigationMixin(LightningElement) {
    @track year;
    @track selectedUser;
    @track objectives;
    @track yearOptions = [{ label: '2023', value: 2023 }, { label: '2024', value: 2024 }];
    @track userOptions = [];
    @track objectiveOptions = [];
    @track keyResultOptions = [];
    @track selectedObjectiveId;
    @track selectedKeyResultId;
    @track isSelectObjectiveModalOpen = false;
    @track isSelectObjectiveForOpportunityModalOpen = false;
    @track isSelectKeyResultForOpportunityModalOpen = false;
    @track isSelectObjectiveForReviewModalOpen = false;
    @track isSelectKeyResultForReviewModalOpen = false;
    @track isNewObjectiveModalOpen = false;
    @track isNewKeyResultModalOpen = false;
    @track isNewOpportunityModalOpen = false;
    @track isNewReviewModalOpen = false;
    @track isNewLeadModalOpen = false;
    @track isNewGoogleReviewModalOpen = false;
    @track isNewEventModalOpen = false;
    @track isNewContractModalOpen = false;
    @track isNewSurveyModalOpen = false;
    @track isNewCaseStudyModalOpen = false;
    @track isNewCallModalOpen = false;
    @track isSelectObjectiveForLeadModalOpen = false;
    @track isSelectKeyResultForLeadModalOpen = false;
    @track isSelectObjectiveForGoogleReviewModalOpen = false;
    @track isSelectKeyResultForGoogleReviewModalOpen = false;
    @track isSelectObjectiveForEventModalOpen = false;
    @track isSelectKeyResultForEventModalOpen = false;
    @track isSelectObjectiveForContractModalOpen = false;
    @track isSelectKeyResultForContractModalOpen = false;
    @track isSelectObjectiveForSurveyModalOpen = false;
    @track isSelectKeyResultForSurveyModalOpen = false;
    @track isSelectObjectiveForCaseStudyModalOpen = false;
    @track isSelectKeyResultForCaseStudyModalOpen = false;
    @track isSelectObjectiveForCallModalOpen = false;
    @track isSelectKeyResultForCallModalOpen = false;
    @track error;
    wiredObjectivesResult;

    @wire(getUsers)
    wiredUsers({ error, data }) {
        if (data) {
            this.userOptions = data.map(user => ({ label: user.Name, value: user.Id }));
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getObjectives, { year: '$year', userId: '$selectedUser' })
    wiredObjectives(result) {
        this.wiredObjectivesResult = result;
        const { error, data } = result;
        if (data) {
            this.objectives = data.map(objective => {
                return {
                    ...objective,
                    keyResults: objective.Key_Results__r ? objective.Key_Results__r.map(keyResult => {
                        const trackableObjects = keyResult.Trackable_Objects__c ? keyResult.Trackable_Objects__c.split(';') : [];
                        return {
                            ...keyResult,
                            hideLeads: !trackableObjects.includes('Leads'),
                            hideOpportunities: !trackableObjects.includes('Opportunities'),
                            hideReviews: !trackableObjects.includes('Reviews'),
                            hideGoogleReviews: !trackableObjects.includes('Google Reviews'),
                            hideCaseStudies: !trackableObjects.includes('Case Studies'),
                            hideSurveys: !trackableObjects.includes('Surveys'),
                            hideContracts: !trackableObjects.includes('Contracts'),
                            hideCalls: !trackableObjects.includes('Calls'),
                            hideEvents: !trackableObjects.includes('Events')
                        };
                    }) : []
                };
            });
            this.objectiveOptions = data.map(objective => ({ label: objective.Name, value: objective.Id }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.objectives = undefined;
        }
    }

    handleYearChange(event) {
        this.year = Number(event.detail.value);
    }

    handleUserChange(event) {
        this.selectedUser = event.detail.value;
    }

    handleObjectiveChange(event) {
        this.selectedObjectiveId = event.detail.value;
        this.keyResultOptions = this.objectives.find(obj => obj.Id === this.selectedObjectiveId)?.keyResults.map(kr => ({ label: kr.Name, value: kr.Id })) || [];
    }

    handleKeyResultChange(event) {
        this.selectedKeyResultId = event.detail.value;
    }

    openNewObjectiveModal() {
        this.isNewObjectiveModalOpen = true;
    }

    closeNewObjectiveModal() {
        this.isNewObjectiveModalOpen = false;
    }

    openNewKeyResultModal() {
        if (this.selectedObjectiveId) {
            this.isNewKeyResultModalOpen = true;
        }
    }

    closeNewKeyResultModal() {
        this.isNewKeyResultModalOpen = false;
    }

    openSelectObjectiveModal() {
        this.isSelectObjectiveModalOpen = true;
    }

    closeSelectObjectiveModal() {
        this.isSelectObjectiveModalOpen = false;
    }

    handleNewKeyResult() {
        this.closeSelectObjectiveModal();
        this.openNewKeyResultModal();
    }

    openSelectObjectiveForOpportunityModal() {
        this.isSelectObjectiveForOpportunityModalOpen = true;
    }

    closeSelectObjectiveForOpportunityModal() {
        this.isSelectObjectiveForOpportunityModalOpen = false;
    }

    openSelectKeyResultForOpportunityModal() {
        if (this.selectedObjectiveId) {
            this.isSelectKeyResultForOpportunityModalOpen = true;
        }
    }

    closeSelectKeyResultForOpportunityModal() {
        this.isSelectKeyResultForOpportunityModalOpen = false;
    }

    handleNewOpportunity() {
        if (this.selectedKeyResultId) {
            this.isNewOpportunityModalOpen = true;
        }
    }

    closeNewOpportunityModal() {
        this.isNewOpportunityModalOpen = false;
    }

    handleOpportunitySuccess(event) {
        this.closeNewOpportunityModal();
        refreshApex(this.wiredObjectivesResult);
    }

    openSelectObjectiveForReviewModal() {
        this.isSelectObjectiveForReviewModalOpen = true;
    }

    closeSelectObjectiveForReviewModal() {
        this.isSelectObjectiveForReviewModalOpen = false;
    }

    openSelectKeyResultForReviewModal() {
        if (this.selectedObjectiveId) {
            this.isSelectKeyResultForReviewModalOpen = true;
        }
    }

    closeSelectKeyResultForReviewModal() {
        this.isSelectKeyResultForReviewModalOpen = false;
    }

    handleNewReview() {
        if (this.selectedKeyResultId) {
            this.isNewReviewModalOpen = true;
        }
    }

    closeNewReviewModal() {
        this.isNewReviewModalOpen = false;
    }

    handleReviewSuccess(event) {
        this.closeNewReviewModal();
        refreshApex(this.wiredObjectivesResult);
    }

    openSelectObjectiveForLeadModal() {
        this.isSelectObjectiveForLeadModalOpen = true;
    }

    closeSelectObjectiveForLeadModal() {
        this.isSelectObjectiveForLeadModalOpen = false;
    }

    openSelectKeyResultForLeadModal() {
        if (this.selectedObjectiveId) {
            this.isSelectKeyResultForLeadModalOpen = true;
        }
    }

    closeSelectKeyResultForLeadModal() {
        this.isSelectKeyResultForLeadModalOpen = false;
    }

    handleNewLead() {
        if (this.selectedKeyResultId) {
            this.isNewLeadModalOpen = true;
        }
    }

    closeNewLeadModal() {
        this.isNewLeadModalOpen = false;
    }

    handleLeadSuccess(event) {
        this.closeNewLeadModal();
        refreshApex(this.wiredObjectivesResult);
    }

    openSelectObjectiveForGoogleReviewModal() {
        this.isSelectObjectiveForGoogleReviewModalOpen = true;
    }

    closeSelectObjectiveForGoogleReviewModal() {
        this.isSelectObjectiveForGoogleReviewModalOpen = false;
    }

    openSelectKeyResultForGoogleReviewModal() {
        if (this.selectedObjectiveId) {
            this.isSelectKeyResultForGoogleReviewModalOpen = true;
        }
    }

    closeSelectKeyResultForGoogleReviewModal() {
        this.isSelectKeyResultForGoogleReviewModalOpen = false;
    }

    handleNewGoogleReview() {
        if (this.selectedKeyResultId) {
            this.isNewGoogleReviewModalOpen = true;
        }
    }

    closeNewGoogleReviewModal() {
        this.isNewGoogleReviewModalOpen = false;
    }

    handleGoogleReviewSuccess(event) {
        this.closeNewGoogleReviewModal();
        refreshApex(this.wiredObjectivesResult);
    }

    openSelectObjectiveForEventModal() {
        this.isSelectObjectiveForEventModalOpen = true;
    }

    closeSelectObjectiveForEventModal() {
        this.isSelectObjectiveForEventModalOpen = false;
    }

    openSelectKeyResultForEventModal() {
        if (this.selectedObjectiveId) {
            this.isSelectKeyResultForEventModalOpen = true;
        }
    }

    closeSelectKeyResultForEventModal() {
        this.isSelectKeyResultForEventModalOpen = false;
    }

    handleNewEvent() {
        if (this.selectedKeyResultId) {
            window.open(`/lightning/o/Event/new?defaultFieldValues=Key_Result__c=${this.selectedKeyResultId}`, '_blank');
        }
    }

    openSelectObjectiveForContractModal() {
        this.isSelectObjectiveForContractModalOpen = true;
    }

    closeSelectObjectiveForContractModal() {
        this.isSelectObjectiveForContractModalOpen = false;
    }

    openSelectKeyResultForContractModal() {
        if (this.selectedObjectiveId) {
            this.isSelectKeyResultForContractModalOpen = true;
        }
    }

    closeSelectKeyResultForContractModal() {
        this.isSelectKeyResultForContractModalOpen = false;
    }

    handleNewContract() {
        if (this.selectedKeyResultId) {
            this.isNewContractModalOpen = true;
        }
    }

    closeNewContractModal() {
        this.isNewContractModalOpen = false;
    }

    handleContractSuccess(event) {
        this.closeNewContractModal();
        refreshApex(this.wiredObjectivesResult);
    }

    openSelectObjectiveForSurveyModal() {
        this.isSelectObjectiveForSurveyModalOpen = true;
    }

    closeSelectObjectiveForSurveyModal() {
        this.isSelectObjectiveForSurveyModalOpen = false;
    }

    openSelectKeyResultForSurveyModal() {
        if (this.selectedObjectiveId) {
            this.isSelectKeyResultForSurveyModalOpen = true;
        }
    }

    closeSelectKeyResultForSurveyModal() {
        this.isSelectKeyResultForSurveyModalOpen = false;
    }

    handleNewSurvey() {
        if (this.selectedKeyResultId) {
            this.isNewSurveyModalOpen = true;
        }
    }

    closeNewSurveyModal() {
        this.isNewSurveyModalOpen = false;
    }

    handleSurveySuccess(event) {
        this.closeNewSurveyModal();
        refreshApex(this.wiredObjectivesResult);
    }

    openSelectObjectiveForCaseStudyModal() {
        this.isSelectObjectiveForCaseStudyModalOpen = true;
    }

    closeSelectObjectiveForCaseStudyModal() {
        this.isSelectObjectiveForCaseStudyModalOpen = false;
    }

    openSelectKeyResultForCaseStudyModal() {
        if (this.selectedObjectiveId) {
            this.isSelectKeyResultForCaseStudyModalOpen = true;
        }
    }

    closeSelectKeyResultForCaseStudyModal() {
        this.isSelectKeyResultForCaseStudyModalOpen = false;
    }

    handleNewCaseStudy() {
        if (this.selectedKeyResultId) {
            this.isNewCaseStudyModalOpen = true;
        }
    }

    closeNewCaseStudyModal() {
        this.isNewCaseStudyModalOpen = false;
    }

    handleCaseStudySuccess(event) {
        this.closeNewCaseStudyModal();
        refreshApex(this.wiredObjectivesResult);
    }

    openSelectObjectiveForCallModal() {
        this.isSelectObjectiveForCallModalOpen = true;
    }

    closeSelectObjectiveForCallModal() {
        this.isSelectObjectiveForCallModalOpen = false;
    }

    openSelectKeyResultForCallModal() {
        if (this.selectedObjectiveId) {
            this.isSelectKeyResultForCallModalOpen = true;
        }
    }

    closeSelectKeyResultForCallModal() {
        this.isSelectKeyResultForCallModalOpen = false;
    }

    handleNewCall() {
        if (this.selectedKeyResultId) {
            window.open(`/lightning/o/Task/new?defaultFieldValues=Key_Result__c=${this.selectedKeyResultId}`, '_blank');
        }
    }
    

    handleObjectiveSuccess(event) {
        this.closeNewObjectiveModal();
        refreshApex(this.wiredObjectivesResult);
    }

    handleKeyResultSuccess(event) {
        this.closeNewKeyResultModal();
        refreshApex(this.wiredObjectivesResult);
    }
}
