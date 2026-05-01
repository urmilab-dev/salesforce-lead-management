import { LightningElement, wire, track } from 'lwc';
import getHotLeads from '@salesforce/apex/LeadDashboardController.getHotLeads';
import getLeadSummary from '@salesforce/apex/LeadDashboardController.getLeadSummary';

const COLUMNS = [
    { label: 'Lead Name', fieldName: 'leadUrl', type: 'url',
      typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' } },
    { label: 'Company', fieldName: 'Company', type: 'text' },
    { label: 'Industry', fieldName: 'Industry', type: 'text' },
    { label: 'Lead Score', fieldName: 'Lead_Score__c', type: 'number' },
    { label: 'Country', fieldName: 'Country', type: 'text' },
    { label: 'Owner', fieldName: 'OwnerName', type: 'text' }
];

export default class LeadDashboard extends LightningElement {

    @track hotLeads = [];
    @track hotLeadCount = 0;
    @track warmLeadCount = 0;
    @track coldLeadCount = 0;
    @track isLoading = true;

    columns = COLUMNS;
    sortedBy = 'Lead_Score__c';
    sortedDirection = 'desc';

    @wire(getHotLeads)
    wiredHotLeads({ data, error }) {
        if (data) {
            this.hotLeads = data.map(lead => ({
                ...lead,
                leadUrl: `/lightning/r/Lead/${lead.Id}/view`,
                OwnerName: lead.Owner ? lead.Owner.Name : ''
            }));
            this.isLoading = false;
        } else if (error) {
            console.error('Error loading hot leads:', error);
            this.isLoading = false;
        }
    }

    @wire(getLeadSummary)
    wiredSummary({ data, error }) {
        if (data) {
            this.hotLeadCount = data.hotCount || 0;
            this.warmLeadCount = data.warmCount || 0;
            this.coldLeadCount = data.coldCount || 0;
        } else if (error) {
            console.error('Error loading lead summary:', error);
        }
    }

    get hasHotLeads() {
        return this.hotLeads && this.hotLeads.length > 0;
    }

    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortedDirection);
    }

    sortData(field, direction) {
        const cloneData = [...this.hotLeads];
        cloneData.sort((a, b) => {
            let valA = a[field] || '';
            let valB = b[field] || '';
            return direction === 'asc'
                ? valA > valB ? 1 : -1
                : valA < valB ? 1 : -1;
        });
        this.hotLeads = cloneData;
    }
}
