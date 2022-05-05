/*
@description: This component is used to display a record edit form that displays character counts for text fields. This is embedded
in the character_counting_component lwc, but could also be used independently in other components as well if desired.
@author: Matt Gerry (codingwiththeforce@gmail.com)
@date: 5/3/2022
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
	columnClasses = '';

	connectedCallback() {
		// Due to this.fieldData being an api exposed variable, we need to clone it to be able to update it. This is how you clone objects in js.
		this.fieldDataCopy = JSON.parse(JSON.stringify(this.fieldData)).map(fieldData => this.addFieldSpecificStyling(fieldData));
		this.determinePageLayout();
	}

	/*
	  @description: This method is used to setup the correct classes for a two column layout if the user has chosen to display the
	  component in that fashion.
	 */
	determinePageLayout(){
		if(this.fieldColumns == 2){
			this.columnClasses = 'slds-col slds-size_6-of-12 slds-var-p-horizontal_medium slds-float-left inline-grid';
		}
	}

	/*
	  @description: This method is called by the onchange event within each lightning input field that is of type string to allow it to count
	  down the characters remaining appropriately.
	 */
	determineCharactersLeft(event){
		let fieldValue = event.detail.value;
		let fieldName = event.target.fieldName;
		for(let field of this.fieldDataCopy){
			if(field.fieldApiName === fieldName){
				field.currentLength = fieldValue.length;
				field.charactersRemaining = field.stringFieldLength - field.currentLength;
				this.checkFieldConstraints(field);
				this.addFieldSpecificStyling(field);
			}
		}
	}

	/*
	  @description: This method is used to determine whether we should show the red warning text in the character counter and whether
	  or not we should prevent further input into the field if we are out of characters
	 */
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

	/*
	  @description: This method is called by an onsubmit event from the lightning record edit form and it only updates field data if we have
	  a recordId populated in the component. If we don't have a record id, then this is a record creation even and record creation events are
	  handled in the handleSaveSuccess method below.
	 */
	@api saveData(event){
		event.preventDefault();
		this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
		if(this.recordId) {
			this.updateFieldData();
		}
	}

	/*
	  @description: This method is called by an onsuccess event handler on the lightning record edit form and only navigates
	  to a new record page if we have actually created a record (via a new record page setup).
	  We currently determine whether we are creating a new record based upon whether or not a recordId was passed into this component or not.
	 */
	handleSaveSuccess(event){
		if(!this.recordId){
			this.navigateToNewRecordPage(event.detail.id);
		}
	}

	navigateToNewRecordPage(recordId){
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: recordId,
				objectApiName: this.objectApiName,
				actionName: 'view'
			}
		});
	}

	/*
	  @description: This method is used to dispatch an event to its parent component to inform it that the user has clicked the save
	  button and that we should switch to the lightning record view form.
	 */
	disableEditing(){
		this.dispatchEvent(new CustomEvent('disableedit'));
	}

	/*
	  @description: This event is necessary to keep the parent and view component up to date with the changes that
	  were enacted in this edit component.
	 */
	updateFieldData(){
		this.dispatchEvent(new CustomEvent('updatefielddata', {
			detail:{
				fielddata: this.fieldDataCopy
			}
		}));
	}

	/*
	  @description: Does bookkeeping on field-related styles/counter text
	 */
	addFieldSpecificStyling(fieldData) {
		let inputStyle = '';
		let paragraphStyle = '';
		if (fieldData.isString) {
			inputStyle = 'character-counter';
			paragraphStyle = `characters-remaining${fieldData.belowCharsThreshold ? '-red' : ''}`;
			fieldData.paragraphText = `${fieldData.charactersRemaining} characters remaining out of ${fieldData.stringFieldLength}`
			if (fieldData.noCharsLeft) {
				fieldData.disabled = true;
			} else if (fieldData.disabled) {
				delete fieldData.disabled;
			}
		}
		fieldData.inputStyle = inputStyle;
		fieldData.paragraphStyle = paragraphStyle;
		fieldData.paragraphKey = fieldData.fieldApiName + 'paragraph'
		return fieldData
	}
}