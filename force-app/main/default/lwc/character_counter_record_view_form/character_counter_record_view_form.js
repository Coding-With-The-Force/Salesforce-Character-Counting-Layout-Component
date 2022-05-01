/**
 * Created by gerry on 5/1/2022.
 */

import {LightningElement, api, track} from 'lwc';

export default class CharacterCounterRecordViewForm extends LightningElement {
	@api recordId;
	@api objectApiName;
	@api fieldData;
	@api renderEditButton;
	@track fieldDataCopy
	CHARACTERS_REMAINING = 'characters remaining';

	connectedCallback() {
		this.fieldDataCopy = JSON.parse(JSON.stringify(this.fieldData));
	}

	enableEditing(){
		this.dispatchEvent(new CustomEvent("enableedit"));
	}
}