import { LightningElement, track, wire, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getContactsRelatedToAccount from '@salesforce/apex/FileUploadController.getContactsRelatedToAccount';
import csvFileRead from '@salesforce/apex/FileUploadController.csvFileRead';


export default class FileUploadLWC extends LightningElement {

    @api recordId;
    @track error;
    @track contacts;
    
    @track columns = [
        { label: 'First Name', fieldName: 'FirstName', type: 'text' },
        { label: 'Last Name', fieldName: 'LastName', type: 'text' }
    ];

    get csvFormat() {
        return ['.csv'];
    }
    
    @wire(getContactsRelatedToAccount, {accId: '$recordId'}) 
    WireContactRecords({error, data}){
        if(data){
            this.contacts = data;
            this.error = undefined;
        }else{
            this.error = error;
            this.contacts = undefined;
        }
    }

    uploadFileHandler(event) {
           
        const uploadedFiles = event.detail.files;

        
        // csvFileRead({ contentDocumentId: uploadedFiles[0].documentI, recordId: this.recordId})
        csvFileRead({recordId: this.recordId, contentDocumentId: uploadedFiles[0].documentId})
        .then(result => {
            window.console.log('result ===> '+result);
            this.data = result;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Accounts are created according to the CSV file upload!!!',
                    variant: 'Success',
                }),
            );
        })
        .catch(error => {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(error),
                    variant: 'error',
                }),
            );     
        })

    }
}
 
  