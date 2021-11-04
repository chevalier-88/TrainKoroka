import { LightningElement, track, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import csvFileRead from '@salesforce/apex/CSVFileReadController.csvFileRead';

const columnsContact = [
    { label: 'FirstName', fieldName: 'FirstName' },
    { label: 'LastName', fieldName: 'LastName'}
];


export default class FileUploadLWC extends LightningElement {

 
    @api recordId;
    @track error;
    @track columnsContact = columnsContact;
    @track data;

    // accepted parameters
    get acceptedCSVFormats() {
        return ['.csv'];
    }

    uploadFileHandler(event) {
        
        const uploadedFiles = event.detail.files;
    
        csvFileRead({ recordId: this.recordId }).then(result => {
            window.console.log('result ===> '+result);
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

    
    // uploadFileHandler(event) {
        
    //     const uploadedFiles = event.detail.files;
    
    //     csvFileRead({ contentDocumentId: uploadedFiles[0].documentId })
    //     .then(result => {
    //         window.console.log('result ===> '+result);
    //         this.data = result;
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Success!!',
    //                 message: 'Accounts are created according to the CSV file upload!!!',
    //                 variant: 'Success',
    //             }),
    //         );
    //     })
    //     .catch(error => {
    //         this.error = error;
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Error!!',
    //                 message: JSON.stringify(error),
    //                 variant: 'error',
    //             }),
    //         );     
    //     })

    // }
    
// }