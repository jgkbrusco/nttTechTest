import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import TYPE_VALUES from '@salesforce/schema/Account.Type';
import updateAccount from '@salesforce/apex/AccountController.updateAccount';

export default class AccountManager extends LightningElement {
    picklistValues;
    @api recordId;
    @track accountName = '';
    @track documentNumber = '';
    @track typeValue = '';

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountObjectInfo; 

    @wire(getPicklistValues, {
        recordTypeId: '$accountObjectInfo.data.defaultRecordTypeId',
        fieldApiName: TYPE_VALUES
    })
    wiredPicklistValues({ data, error }) {
        if (data) {
        this.picklistValues = data.values;
        } else if (error) {
        console.error(error);
        }
    }

    handleNameChange(event) {
        this.accountName = event.target.value;        
    }

    handleDocumentChange(event) {
        this.documentNumber = event.target.value;        
    }

    handleTypeChange(event) {
        this.typeValue = event.target.value;        
    }    

    updateAccount(){
        updateAccount({accId: this.recordId, 
                    name: this.accountName, 
                    document: this.documentNumber,
                    type: this.typeValue})
        .then((account) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Successo",
                    message: "Conta atualizada com sucesso",
                    variant: "success",
                }),
            );
        })
        .catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Erro ao tentar alterar a Conta",
                    message: error.body.message,
                    variant: "error",
                }),
            );
        });
    }
}