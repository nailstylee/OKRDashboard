import { LightningElement, api, track } from 'lwc';

export default class RecordCreationModal extends LightningElement {
    @api isOpen = false;
    @api objectApiName;
    @api modalTitle = 'New Record';
    @api fields = [];

    handleClose() {
        this.isOpen = false;
        this.dispatchEvent(new CustomEvent('close'));
    }

    handleSuccess(event) {
        this.isOpen = false;
        const recordId = event.detail.id;
        this.dispatchEvent(new CustomEvent('success', { detail: recordId }));
    }

    get sanitizedFields() {
        return this.fields.map(field => {
            const [fieldName] = field.split('=');
            return fieldName;
        });
    }

    get defaultFieldValues() {
        return this.fields.reduce((acc, field) => {
            const [fieldName, fieldValue] = field.split('=');
            if (fieldValue) {
                acc[fieldName] = fieldValue;
            }
            return acc;
        }, {});
    }
}
