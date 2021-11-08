import { LightningElement, track, wire, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getContactsRelatedToAccount from '@salesforce/apex/FileUploadController.getContactsRelatedToAccount';
import csvFileRead from '@salesforce/apex/FileUploadController.csvFileRead';


const columns = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text' },
    { label: 'Last Name', fieldName: 'LastName', type: 'text' },
    {type: "button", typeAttributes: {  
        label: 'View',  
        name: 'View',  
        title: 'View',  
        disabled: false,  
        value: 'view',  
        iconPosition: 'left'  
    }}
    ];

export default class FileUploadLWC extends LightningElement {

    @api recordId;
    @track error;
    @track data;
    @track columns = columns;

    get csvFormat() {
        return ['.csv'];
    }
    
    @wire(getContactsRelatedToAccount, {accId: '$recordId'}) 
    WireContactRecords({error, data}){
        if(data){
            this.data = data;
            this.error = undefined;
        }else{
            this.error = error;
            this.data = undefined;
        }
    }

    // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

    callRowAction( event ) {  
          
        const recId =  event.detail.row.Id;  
        const actionName = event.detail.action.name;  
        if ( actionName === 'Edit' ) {  
  //TODO
            // this[NavigationMixin.Navigate]({  
            //     type: 'standard__recordPage',  
            //     attributes: {  
            //         recordId: recId,  
            //         objectApiName: 'Account',  
            //         actionName: 'edit'  
            //     }  
            // })  
  
        } else if ( actionName === 'View') {  
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'View!!',
                    message: 'Congratulation!!!\n You press view button!!!!',
                    variant: 'Info',
                }));

            // this[NavigationMixin.Navigate]({  
            //     type: 'standard__recordPage',  
            //     attributes: {  
            //         recordId: recId,  
            //         objectApiName: 'Account',  
            //         actionName: 'view'  
            //     }  
            // })  
  
        }          
  
    }

    // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=
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