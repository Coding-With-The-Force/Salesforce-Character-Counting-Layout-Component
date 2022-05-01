/**
 * Created by gerry on 5/1/2022.
 */

import {LightningElement, api, track} from 'lwc';

export default class CharacterCounterRecordEditComponent extends LightningElement {
	@api recordId;
	@api objectApiName;
	@api fieldData;
	@api renderSaveButton;
	@track fieldDataCopy;
	CHARACTERS_REMAINING = 'characters remaining';

	connectedCallback() {
		this.fieldDataCopy = JSON.parse(JSON.stringify(this.fieldData));
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
		if(field.charactersRemaining <= 25){
			field.below25Chars = true;
		}
		else{
			field.below25Chars = false;
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
		this.updateFieldData();
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