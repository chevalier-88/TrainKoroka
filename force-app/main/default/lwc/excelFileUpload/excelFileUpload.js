import { LightningElement, track, wire, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import JQUERY_MINI_JS from '@salesforce/resourceUrl/JQUERY_MINI_JS';
import XLSX_MINI_JS from '@salesforce/resourceUrl/XLSX_MINI_JS';


export default class ExcelFileUpload extends LightningElement {

    @api recordId;

    @track error;
    
    file;
    reader;
    
    handleFilesChange(e) {
        console.log('---- inside handlFile function1'+e);

        this.file = e.target.files[0];

        Promise.all([
            loadScript(this, JQUERY_MINI_JS),
            loadScript(this, XLSX_MINI_JS)
        ]).then(() => {
            this.handleFile(this.file);
        
        }).catch(error => {
            alert('---> BROKEN <---');
            console.log('----> error: '+error);
        });
   }

   handleFile(file){
    console.log('---- inside handlFile function2'+file);
    

    //   var reader = new FileReader();
    this.reader = new FileReader();
      var name = file.name;
      console.log("----> filename: "+file);

    //   reader.onload = function(e){
        this.reader.onload = (() => {
          debugger;
          
          var data = this.reader.result;
          
          debugger;

        var result;
        var workbook = XLSX.read(data, {type: 'binary'});
        console.log('-----> '+workbook);

          var sheet_name_list = workbook.SheetNames;
          console.log("----> sheet_name_list: "+sheet_name_list);
          var roa;
          sheet_name_list.forEach(function(y){
              /* iterate through sheets */
              //Convert the cell value to Json
              roa = XLSX.utils.sheet_to_json(workbook.Sheets[y]);
              if (roa.length > 0){
                  result = roa;
                  console.log("----> roa "+JSON.stringify(roa));
              }
          });
      });
      this.reader.readAsArrayBuffer(file);
}

// $(document).ready(function(){
//     $('#files').change(handleFile);
// });
}