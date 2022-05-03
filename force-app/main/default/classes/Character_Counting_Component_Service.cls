/**
 * Created by gerry on 4/30/2022.
 */

public with sharing class Character_Counting_Component_Service
{
	private final String STRING_TEXT = 'STRING';
	private final String TEXT_AREA_TEXT = 'TEXTAREA';
	private DescribeSObjectResult[] describes;

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

	public List<FieldData> getFieldsToDisplay(String fieldSetName, String objectApiName, Id recordId, Integer characterWarningThreshold){
		describes = Schema.describeSObjects(new String[]{objectApiName});
		System.debug('This is the Id ::: ' + recordId);
		if(recordId != null){
			return getRecordData(getFieldSetFields(fieldSetName), recordId, characterWarningThreshold);
		}
		else{
			return createFieldDataWithNoExistingRecord(getFieldSetFields(fieldSetName));
		}
	}

	public List<FieldData> createFieldDataWithNoExistingRecord(List<Schema.FieldSetMember> fieldSetFields){
		List<FieldData> fieldDataList = new List<FieldData>();
		Map<String, SObjectField> fieldMap = describes[0].fields.getMap();
		for(Schema.FieldSetMember field: fieldSetFields){
			FieldData fieldInfo = new FieldData();
			fieldInfo.fieldApiName = field.getFieldPath();
			determineColumnSplit(fieldInfo, fieldSetFields.size());
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

	private List<Schema.FieldSetMember> getFieldSetFields(String fieldSetName)
	{
		if (!describes.isEmpty()) {
			return describes[0].fieldSets.getMap().get(fieldSetName).fields;
		}
		else{
			throw new CharacterCountingException('No field set for this object exists! ' +
					'Please check the name of the field set you passed into the component!');
		}
	}

	private List<FieldData> getRecordData(List<Schema.FieldSetMember> fieldSetFields, Id recordId, Integer characterWarningThreshold){
		String query = 'SELECT ';
		Map<String, FieldData> fieldDataMap = new Map<String, FieldData>();
		Map<String, SObjectField> fieldMap = describes[0].fields.getMap();
		for(Schema.FieldSetMember field: fieldSetFields){
			FieldData fieldInfo = new FieldData();
			fieldInfo.fieldApiName = field.getFieldPath();
			determineColumnSplit(fieldInfo, fieldSetFields.size());
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
		System.debug('This is the query ::: ' + query);
		fieldDataMap = queryForFieldData(query, fieldDataMap, characterWarningThreshold);
		return fieldDataMap.values();
	}

	private void determineColumnSplit(FieldData fieldInfo, Integer fieldSetLength){
		if(Math.mod(fieldSetLength, 2) != 0){
			fieldInfo.columnSplitPoint = (fieldSetLength/2) + 1;
		}
		else{
			fieldInfo.columnSplitPoint = fieldSetLength;
		}
	}

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
		public Integer columnSplitPoint;
		@AuraEnabled
		public Boolean isString = false;
		@AuraEnabled
		public Boolean belowCharsThreshold = false;
	}

	private class CharacterCountingException extends Exception{}
}