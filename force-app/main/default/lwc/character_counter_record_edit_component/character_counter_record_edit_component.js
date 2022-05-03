/**
 * Created by gerry on 5/1/2022.
 */

import {LightningElement, api, track} from 'lwc';
import {NavigationMixin} from "lightning/navigation";

export default class CharacterCounterRecordEditComponent extends NavigationMixin(LightningElement) {
	@api recordId;
	@api objectApiName;
	@api fieldData;
	@api renderSaveButton;
	@api characterWarningThreshold;
	@api fieldColumns = 1;
	@track fieldDataCopy;
	CHARACTERS_REMAINING = 'characters remaining';
	columnClasses = '';

	connectedCallback() {
		this.fieldDataCopy = JSON.parse(JSON.stringify(this.fieldData));
		this.determinePageLayout();
	}

	determinePageLayout(){
		if(this.fieldColumns == 2){
			this.columnClasses = 'slds-col slds-size_6-of-12 slds-p-horizontal_medium slds-float-left inline-grid';
		}
	}

	determineCharactersLeft(event){
		let fieldValue = event.detail.value;
		let fieldName = event.target.fieldName;
		for(let field of this.fieldDataCopy){
			if(field.fieldApiName === fieldName){
				field.currentLength = fieldValue.length;
				field.charactersRemaining = field.stringFieldLength - field.currentLength;
				this.checkFieldConstraints(field)
			}
		}
	}

	checkFieldConstraints(field){
		if(field.charactersRemaining <= this.characterWarningThreshold){
			field.belowCharsThreshold = true;
		}
		else{
			field.belowCharsThreshold = false;
		}
		if(field.noCharsLeft === 0){
			field.noCharsLeft = true;
		}
		else{
			field.noCharsLeft = false;
		}
	}

	@api saveData(event){
		event.preventDefault();
		this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
		console.log('The record Id is ::: ' + this.recordId);
		this.updateFieldData();
	}

	handleSaveSuccess(event){
		if(!this.recordId){
			this.navigateToNewRecordPage(event.detail.id);
		}
	}

	navigateToNewRecordPage(recordId){
		console.log('Trying to navigate');
		// View a custom object record.
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: recordId,
				objectApiName: this.objectApiName,
				actionName: 'view'
			}
		});
	}

	disableEditing(){
		this.dispatchEvent(new CustomEvent('disableedit'));
	}

	updateFieldData(){
		this.dispatchEvent(new CustomEvent('updatefielddata', {
			detail:{
				fielddata: this.fieldDataCopy
			}
		}));
	}
}