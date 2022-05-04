/*
@description: This component is used to display a record view form that displays character counts for text fields. This is embedded
in the character_counting_component lwc, but could also be used independently in other components as well if desired.

@author: Matt Gerry (codingwiththeforce@gmail.com)

@date: 5/3/2022
*/

import {LightningElement, api, track} from 'lwc';

export default class CharacterCounterRecordViewForm extends LightningElement {
	@api recordId;
	@api objectApiName;
	@api fieldData;
	@api renderEditButton;
	@api fieldColumns = 1;
	@track fieldDataCopy
	CHARACTERS_REMAINING = 'characters remaining';
	columnClasses = 'column-class';

	connectedCallback() {
		//Due to this.fieldData being an api exposed variable, we need to clone it to be able to update it. This is how you clone objects in js.
		this.fieldDataCopy = JSON.parse(JSON.stringify(this.fieldData));
		this.determinePageLayout();
	}

	/*
	  @description: This method is used to setup the correct classes for a two column layout if the user has chosen to display the
	  component in that fashion.
	 */
	determinePageLayout(){
		if(this.fieldColumns == 2){
			this.columnClasses = 'column-class slds-col slds-size_6-of-12 slds-p-horizontal_medium slds-float-left inline-grid';
		}
	}

	/*
	  @description: This method is used to dispatch an event to its parent component to inform it that the user has clicked the edit
	  button and that we should switch to the lightning record edit form.
	 */
	enableEditing(){
		this.dispatchEvent(new CustomEvent("enableedit"));
	}
}