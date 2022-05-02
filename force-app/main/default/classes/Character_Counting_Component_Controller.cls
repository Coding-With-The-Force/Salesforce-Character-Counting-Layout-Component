/**
 * Created by gerry on 4/30/2022.
 */

public with sharing class Character_Counting_Component_Controller
{
	private static Character_Counting_Component_Service countingService = new Character_Counting_Component_Service();

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