/**
 * Created by gerry on 4/30/2022.
 */

public with sharing class Character_Counting_Component_Controller
{
	@AuraEnabled
	public static List<Character_Counting_Component_Service.FieldData> getFieldsToDisplay(String fieldSetName, String objectApiName, Id recordId){
		Character_Counting_Component_Service countingService = new Character_Counting_Component_Service();
		try{
			return countingService.getFieldsToDisplay(fieldSetName, objectApiName, recordId);
		}
		catch(Exception ex){
			throw new AuraHandledException(ex.getMessage());
		}
	}

}