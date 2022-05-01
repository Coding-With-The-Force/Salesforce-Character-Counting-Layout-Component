/**
 * Created by gerry on 4/30/2022.
 */

import {LightningElement, api, track} from 'lwc';
import {loadStyle} from "lightning/platformResourceLoader";
import characterCountingComponentStyle from '@salesforce/resourceUrl/character_counter_css';
import getFieldsToDisplayController from '@salesforce/apex/Character_Counting_Component_Controller.getFieldsToDisplay';
import {ShowToastEvent} from "lightning/platformShowToastEvent";


export default class CharacterCountingComponent extends LightningElement {
	@api recordId;
	@api objectApiName;
	@api sectionHeader;
	@api fieldSetName;
	@api renderEditButton = false;
	@api renderSaveButton = false;
	@api displayAsFieldSection = false;
	@api displayAsIndependentSection = false;
	@api fieldColumns = 1;

	@track fieldData;
	errorMsg;
	userEditing = false;
	dataRetrieved = false;

	@api saveData(){
		this.template.querySelector('c-character_counter_record_view_form').saveData();
	}

	async connectedCallback() {
		await loadStyle(this, characterCountingComponentStyle);
		this.getFieldsToDisplay();
	}

	getFieldsToDisplay(){
		getFieldsToDisplayController({fieldSetName: this.fieldSetName, objectApiName: this.objectApiName,
			recordId: this.recordId}).then(fieldInfo =>{
				console.log('This is the field data ::: ' + JSON.stringify(fieldInfo));
			this.fieldData = fieldInfo;
			this.dataRetrieved = true;
		}).catch(error =>{
			this.displayErrors(error);
		})
	}

	enableEditing(){
		this.userEditing = true;
	}

	disableEditing(){
		this.userEditing = false;
	}

	updateFieldData(event){
		this.fieldData = event.detail.fielddata;
		this.disableEditing();
	}

	displayErrors(error){
		this.handleErrors(error);
		this.dispatchEvent(this.showToast('Error', this.errorMsg, 'error', 'sticky'));
	}

	handleErrors(err){
		if (Array.isArray(err.body)) {
			this.errorMsg = err.body.map(e => e.message).join(', ');
		} else if (typeof err.body.message === 'string') {
			this.errorMsg = err.body.message;
		}
	}

	showToast(toastTitle, toastMessage, toastVariant, toastMode) {
		const evt = new ShowToastEvent({
			title: toastTitle,
			message: toastMessage,
			variant: toastVariant,
			mode: toastMode
		});
		return evt;
	}

	get notEditingAndDataRetrieved(){
		if(!this.userEditing && this.dataRetrieved){
			return true;
		}
	}
}