/*
@description: This component is the parent component that is used to display the character counting component. Its purpose is to facilitate
communication between its subcomponents and the user entered settings to display the character counter as desired. This component is the component
that will actually be placed within your lightning app builder page, new record page, flow, etc. Its variables are exposed and available to both
flows and lightning app builder record pages

@author: Matt Gerry (codingwiththeforce@gmail.com)

@date: 5/3/2022
*/

import {LightningElement, api, track} from 'lwc';
import {loadStyle} from "lightning/platformResourceLoader";
import {NavigationMixin} from "lightning/navigation";
import characterCountingComponentStyle from '@salesforce/resourceUrl/character_counter_css';
import getFieldsToDisplayController from '@salesforce/apex/Character_Counting_Component_Controller.getFieldsToDisplay';
import canUserEditRecordController from '@salesforce/apex/Character_Counting_Component_Controller.canUserEditRecord';
import {ShowToastEvent} from "lightning/platformShowToastEvent";


export default class CharacterCountingComponent extends NavigationMixin(LightningElement) {
	@api recordId;
	@api objectApiName;
	@api sectionHeader;
	@api fieldSetName;
	@api renderEditButton = false;
	@api renderSaveButton = false;
	@api displayAsFieldSection = false;
	@api displayAsIndependentSection = false;
	@api fieldColumns = 1;
	@api characterWarningThreshold = 25;
	@api iconName = "";

	@track fieldData;
	@track activeSections = [];

	errorMsg;
	userEditing = false;
	dataRetrieved = false;
	userCreatingRecord = false;

	/*
	  @description: This method is exposed so that if embedded into a parent component the parent component can call the edit forms save
	  functionality.
	 */
	@api saveData(){
		this.template.querySelector('c-character_counter_record_edit_component').saveData();
	}

	async connectedCallback() {
		await this.prepComponent();
	}

	/*
	  @description: This method is used to setup the component to ensure it is styled appropriately, security is upheld and that the correct
	  data is retrieved from the system to be displayed.
	 */
	async prepComponent(){
		await loadStyle(this, characterCountingComponentStyle);
		this.setActiveSections();
		this.determineIfNewRecordOrEditingRecord();
		this.getFieldsToDisplay();
	}

	/*
	   @description: If we have an id, we are updating a record so we need to check security. Otherwise we're on a new record form
	   and should immediately flip to display a record edit form.
	 */
	determineIfNewRecordOrEditingRecord(){
		if(this.recordId) {
			this.canUserEditRecord();
		}
		else{
			this.userCreatingRecord = true;
		}
	}

	/*
	   @description: Sets the active section for the accordion element.
	 */
	setActiveSections(){
		this.activeSections = [this.sectionHeader];
	}

	/*
	   @description: This method calls to the apex controller to ensure that a user has rights to edit a record before allowing them to do it.
	 */
	canUserEditRecord(){
		canUserEditRecordController({recordId: this.recordId}).then(canUserEdit =>{
			if(canUserEdit === false && this.renderEditButton === true) {
				this.renderEditButton = canUserEdit;
			}
		}).catch(error =>{
			this.displayErrors(error);
		});
	}

	/*
	   @description: This method calls to the controller to retrieve the field data from our field set and current record
	   to display to our user.
	 */
	getFieldsToDisplay(){
		getFieldsToDisplayController({fieldSetName: this.fieldSetName, objectApiName: this.objectApiName,
			recordId: this.recordId, characterWarningThreshold: this.characterWarningThreshold}).then(fieldInfo =>{
			this.fieldData = fieldInfo;
			this.dataRetrieved = true;
		}).catch(error =>{
			this.displayErrors(error);
		})
	}

	/*
	   @description: Used to render the record edit form
	 */
	@api enableEditing(){
		this.userEditing = true;
	}

	/*
	   @description: Used to un-render the record edit form. When there is a record id present we are editing an existing record
	   so we just need to move back to the record view form. If there is no record id then we are creating a new record and need
	   to navigate back to the objects home page instead.
	 */
	@api disableEditing(){
		if(this.recordId) {
			this.userEditing = false;
		}
		else{
			this.navigateToObjectHomePage();
		}
	}

	navigateToObjectHomePage(){
		this[NavigationMixin.Navigate]({
			type: 'standard__objectPage',
			attributes: {
				objectApiName: this.objectApiName,
				actionName: 'home'
			}
		});
	}

	/*
	   @description: Called from the record edit forms onupdatefielddata event to ensure data is consistent between components
	   after being edited
	 */
	@api updateFieldData(event){
		this.fieldData = event.detail.fielddata;
		this.disableEditing();
	}

	/*
	   @description: Used to prep and display error toasts in catch blocks
	 */
	displayErrors(error){
		this.handleErrors(error);
		this.dispatchEvent(this.showToast('Error', this.errorMsg, 'error', 'sticky'));
	}

	/*
	   @description: Properly parses aura handled exceptions for display to the user in a toast.
	 */
	handleErrors(err){
		if (Array.isArray(err.body)) {
			this.errorMsg = err.body.map(e => e.message).join(', ');
		} else if (typeof err.body.message === 'string') {
			this.errorMsg = err.body.message;
		}
	}

	/*
	   @description: Used for toast displays
	 */
	showToast(toastTitle, toastMessage, toastVariant, toastMode) {
		const evt = new ShowToastEvent({
			title: toastTitle,
			message: toastMessage,
			variant: toastVariant,
			mode: toastMode
		});
		return evt;
	}

	/*
	   @description: Used to render the view form template
	 */
	get notEditingAndDataRetrieved(){
		if(this.userEditing === false && this.userCreatingRecord === false && this.dataRetrieved === true){
			return true;
		}
	}

	/*
	   @description: Used to render the edit form template
	 */
	get userEditingOrCreating(){
		if((this.userEditing === true || this.userCreatingRecord === true) && this.dataRetrieved === true){
			return true;
		}
	}
}