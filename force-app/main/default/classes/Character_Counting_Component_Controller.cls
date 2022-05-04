/*
@description: This controller class is used by the character_counting_component to retrieve data from the Character_Counting_Component_Service
Apex Class to allow the lwc to function as expected (displaying data and locking down fields and forms as expected). All real logic resides in the
service class, comments on each methods purpose can be found within the service class.

@author: Matt Gerry (codingwiththeforce@gmail.com)

@date: 5/3/2022
*/

public with sharing class Character_Counting_Component_Controller
{
	private static Character_Counting_Component_Service countingService =
			(Character_Counting_Component_Service)Character_Counting_Component_Application.service.newInstance(Character_Counting_Component_Service.class);

	@AuraEnabled
	public static List<Character_Counting_Component_Service.FieldData> getFieldsToDisplay(String fieldSetName, String objectApiName, Id recordId, Integer characterWarningThreshold){
		try{
			return countingService.getFieldsToDisplay(fieldSetName, objectApiName, recordId, characterWarningThreshold);
		}
		catch(Exception ex){
			throw new AuraHandledException(ex.getMessage());
		}
	}

	@AuraEnabled
	public static Boolean canUserEditRecord(Id recordId){
		try{
			return countingService.canUserEditRecord(recordId);
		}
		catch(Exception ex){
			throw new AuraHandledException(ex.getMessage());
		}
	}
}