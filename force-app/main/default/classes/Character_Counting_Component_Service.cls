/*
@description: This service class serves to provide the data necessary to run the character_counting_component lwc.
Its primary purpose is to retrieve field set data, metadata about that fields and data in those fields for the current record
and merge that info into a list of our FieldData wrapper inner class. This class also provides a way to check if a user has
access to edit the record they are operating on.

@author: Matt Gerry (codingwiththeforce@gmail.com)

@date: 5/3/2022
*/

public with sharing class Character_Counting_Component_Service
{
	private final String STRING_TEXT = 'STRING';
	private final String TEXT_AREA_TEXT = 'TEXTAREA';
	private DescribeSObjectResult[] describes;

	/*
	  @description: This method is used to determine whether a user has edit access to the record they are currently viewing.
	 */
	public Boolean canUserEditRecord(Id recordId){
		try{
			return [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE
			UserId = :UserInfo.getUserId() AND RecordId = :recordId LIMIT 1].HasEditAccess;
		}
		catch(QueryException qe){
			throw new CharacterCountingException('There was an issue determining your access to the record. ' +
					'Please ensure the component has been setup appropriately and that your user has access to the' +
					'object you\'re viewing. This was the system generated issue: ' + qe.getMessage());
		}
	}

	/*
	  @description: This method is called to retrieve our list of FieldData to display in our component in both the view and edit forms.
	  If we have a record id the user is currently viewing a record we intend to edit, otherwise we are creating a new record.
	 */
	public List<FieldData> getFieldsToDisplay(String fieldSetName, String objectApiName, Id recordId, Integer characterWarningThreshold){
		describes = Schema.describeSObjects(new String[]{objectApiName});
		if(recordId != null){
			return getRecordData(getFieldSetFields(fieldSetName), recordId, characterWarningThreshold);
		}
		else{
			return createFieldDataWithNoExistingRecord(getFieldSetFields(fieldSetName));
		}
	}

	/*
	  @description: This method is used to setup FieldData to display in a lightning record edit form for new record layouts
	 */
	private List<FieldData> createFieldDataWithNoExistingRecord(List<Schema.FieldSetMember> fieldSetFields){
		List<FieldData> fieldDataList = new List<FieldData>();
		Map<String, SObjectField> fieldMap = describes[0].fields.getMap();
		for(Schema.FieldSetMember field: fieldSetFields){
			FieldData fieldInfo = new FieldData();
			fieldInfo.fieldApiName = field.getFieldPath();
			if(field.getType().name() == STRING_TEXT || field.getType().name() == TEXT_AREA_TEXT){
				SObjectField fieldMetadata = fieldMap.get(field.getFieldPath());
				fieldInfo.stringFieldLength = fieldMetadata.getDescribe().getLength();
				fieldInfo.charactersRemaining = fieldInfo.stringFieldLength;
				fieldInfo.isString = true;
			}
			fieldDataList.add(fieldInfo);
		}
		return fieldDataList;
	}

	/*
	  @description: This method is used to retrieve our field sets fields so that we can collect more information from them from both
	  the current record we are editing (potentially) and the metadata of that field (like field length).
	 */
	private List<Schema.FieldSetMember> getFieldSetFields(String fieldSetName)
	{
		if (!describes.isEmpty()) {
			try{
				return describes[0].fieldSets.getMap().get(fieldSetName).fields;
			}
			catch(Exception ex){
				throw new CharacterCountingException('The field set you entered for this object does not exist! ' +
						'Please check the name of the field set you passed into the component!');
			}
		}
		else{
			throw new CharacterCountingException('The object api name you passed into the component is invalid! ' +
					'Please check the name of the object api name you passed into the component!');
		}
	}

	/*
	  @description: This method is used to actually gather both the fields record data and metadata information and merge it into a
	  list of FieldData for display in the UI.
	 */
	private List<FieldData> getRecordData(List<Schema.FieldSetMember> fieldSetFields, Id recordId, Integer characterWarningThreshold){
		String query = 'SELECT ';
		Map<String, FieldData> fieldDataMap = new Map<String, FieldData>();
		Map<String, SObjectField> fieldMap = describes[0].fields.getMap();
		for(Schema.FieldSetMember field: fieldSetFields){
			FieldData fieldInfo = new FieldData();
			fieldInfo.fieldApiName = field.getFieldPath();
			query += fieldInfo.fieldApiName + ',';
			if(field.getType().name() == STRING_TEXT || field.getType().name() == TEXT_AREA_TEXT){
				SObjectField fieldMetadata = fieldMap.get(field.getFieldPath());
				fieldInfo.stringFieldLength = fieldMetadata.getDescribe().getLength();
				fieldInfo.isString = true;
			}
			fieldDataMap.put(fieldInfo.fieldApiName, fieldInfo);
		}
		query = query.removeEnd(',');
		query += ' FROM ' + recordId.getSobjectType() + ' WHERE Id = \'' + recordId + '\' WITH SECURITY_ENFORCED';
		fieldDataMap = queryForFieldData(query, fieldDataMap, characterWarningThreshold);
		return fieldDataMap.values();
	}

	/*
	  @description: This method is used for actually querying the data from our record for the fields we care about.
	 */
	private Map<String, FieldData> queryForFieldData(String query, Map<String, FieldData> fieldDataMap, Integer characterWarningThreshold){
		List<SObject> objectList;
		try{
			objectList = Database.query(query);
		}
		catch(QueryException qe){
			throw new CharacterCountingException('There was an issue retrieving data to display in your ' +
					'fields due to the following problem: ' + qe.getMessage());
		}
		if(!objectList.isEmpty()){
			return fillOutStringFieldData(objectList, fieldDataMap, characterWarningThreshold);
		}
		else{
			throw new CharacterCountingException('There was an issue building your data to display. The record id you passed ' +
					'in was not present in the system. Please make sure the record you are working on wasn\'t removed from the system.');
		}
	}

	/*
	  @description: This method is used to fill out information relevant to strings to display their character counts appropriately in the UI.
	 */
	private Map<String, FieldData> fillOutStringFieldData(List<SObject> objectList, Map<String, FieldData> fieldDataMap, Integer characterWarningThreshold){
		Map<String, FieldData> fieldDataMapClone = fieldDataMap.clone();
		for(SObject obj: objectList){
			for(String fieldName: fieldDataMap.keySet()){
				FieldData fieldInfo = fieldDataMap.get(fieldName);
				if(fieldInfo.isString){
					String stringField = (String)obj.get(fieldInfo.fieldApiName);
					if(stringField == null){
						fieldInfo.charactersRemaining = fieldInfo.stringFieldLength;
						fieldDataMapClone.put(fieldInfo.fieldApiName, fieldInfo);
						continue;
					}
					fieldInfo.currentLength = stringField.length();
					fieldInfo.charactersRemaining = fieldInfo.stringFieldLength - fieldInfo.currentLength;
					if(fieldInfo.charactersRemaining <= characterWarningThreshold){
						fieldInfo.belowCharsThreshold = true;
					}
					fieldDataMapClone.put(fieldInfo.fieldApiName, fieldInfo);
				}
			}
		}
		return fieldDataMapClone;
	}

	/*
	  @description: This inner wrapper class is what allows us to merge our field set data, field metadata and field record data together
	  to return a nice clean list of records to the UI for an easy display.
	 */
	public class FieldData{
		@AuraEnabled
		public String fieldApiName;
		@AuraEnabled
		public Integer charactersRemaining;
		@AuraEnabled
		public Integer stringFieldLength;
		@AuraEnabled
		public Integer currentLength;
		@AuraEnabled
		public Boolean isString = false;
		@AuraEnabled
		public Boolean belowCharsThreshold = false;
	}

	/*
	  @description: Custom exception type used for throwing errors from within this service class.
	 */
	@TestVisible
	private class CharacterCountingException extends Exception{}
}