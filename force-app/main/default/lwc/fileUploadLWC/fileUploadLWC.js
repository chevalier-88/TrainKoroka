import { LightningElement, track, wire, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import saveFile from '@salesforce/apex/FileUploadController.saveFile';
import getContactsRelatedToAccount from '@salesforce/apex/FileUploadController.getContactsRelatedToAccount';

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
    @track data;

    @track columns = columns;
    @track error;

    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;

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
    
    handleFilesChange(event) {
        
        this.file = event.target.files[0];
        

        this.fileReader = new FileReader();
        this.fileReader.onload = (() => {
        
            this.fileContents = this.fileReader.result;
            
                saveFile({ base64Data: this.fileReader.result.split(',')[1], filename: this.file.name, accId: this.recordId })
           .then(result => {
                    window.console.log('result ====> ');
                    window.console.log(result);
                    this.data = result;
                    this.fileName = this.fileName + ' - Uploaded Successfully';
                    this.dispatchEvent(
                        new ShowToastEvent({
                        title: 'Success!!',
                            message: this.file.name + ' - Uploaded Successfully!!!',
                            variant: 'success',
                        }),
                    );
                }).catch(error => {
                    window.console.log(error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error while uploading File',
                            message: error.message,
                            variant: 'error',
                        }),
                    );
                });
        });
        this.fileReader.readAsDataURL(this.file);
   }
}