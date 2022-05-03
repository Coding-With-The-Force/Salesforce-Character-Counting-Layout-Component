/**
 * Created by gerry on 5/1/2022.
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

	enableEditing(){
		this.dispatchEvent(new CustomEvent("enableedit"));
	}
}