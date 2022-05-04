/**
 * Created by gerry on 5/3/2022.
 */
//ApexTestFieldSet
@IsTest
public with sharing class Character_Counting_Component_Test
{
	private static final String CAN_USER_EDIT_RECORD_METHOD = 'canUserEditRecord';
	private static final String TEST_FIELD_SET = 'ApexTestFieldSet';
	private static final String ACCOUNT_OBJECT = 'Account';
	private static final Integer WARNING_THRESHOLD = 200;

	@IsTest
	private static void canUserEditRecord_UserCanEditRecord_UnitTest(){
		Test.startTest();
			Boolean canUserEdit = Character_Counting_Component_Controller.canUserEditRecord(createAccount().Id);
		Test.stopTest();
		System.assertEquals(true, canUserEdit, 'For some reason admins cant edit records. Somethings not right');
	}

	@IsTest
	private static void canUserEditRecord_QueryException_UnitTest(){
		Id mockAccountId = MockIdBuilder.getMockId(Account.SObjectType);
		UniversalMocker characterCountingServiceMockPrep = UniversalMocker.mock(Character_Counting_Component_Service.class);
		characterCountingServiceMockPrep.when(CAN_USER_EDIT_RECORD_METHOD).withParamTypes(new List<Type>{Id.class}).thenThrow(new QueryException());
		Character_Counting_Component_Service mockService = (Character_Counting_Component_Service)characterCountingServiceMockPrep.createStub();
		Character_Counting_Component_Application.service.setMock(Character_Counting_Component_Service.class, mockService);
		try{
			Test.startTest();
			Character_Counting_Component_Controller.canUserEditRecord(mockAccountId);
			Test.stopTest();
		}
		catch(Exception ex){
			System.assert(ex instanceof AuraHandledException);
		}
	}

	@IsTest
	private static void getFieldsToDisplay_RetrieveFieldsForRecordEdit_IntTest(){
		Test.startTest();
			List<Character_Counting_Component_Service.FieldData> fieldInfo = Character_Counting_Component_Controller.getFieldsToDisplay(TEST_FIELD_SET, ACCOUNT_OBJECT, createAccount().Id, WARNING_THRESHOLD);
		Test.stopTest();
		System.assertEquals(4, fieldInfo.size(), 'The field info records dont match the size of the field set');
	}

	@IsTest
	private static void getFieldsToDisplay_RetrieveFieldsForNewRecord_IntTest(){
		Test.startTest();
		List<Character_Counting_Component_Service.FieldData> fieldInfo = Character_Counting_Component_Controller.getFieldsToDisplay(TEST_FIELD_SET, ACCOUNT_OBJECT, null, WARNING_THRESHOLD);
		Test.stopTest();
		System.assertEquals(4, fieldInfo.size(), 'The field info records dont match the size of the field set');
	}

	@IsTest
	private static void getFieldsToDisplay_QueryForFieldDataCountingException_UnitTest(){
		Id mockAccountId = MockIdBuilder.getMockId(Account.SObjectType);
		try{
			Test.startTest();
			Character_Counting_Component_Controller.getFieldsToDisplay(TEST_FIELD_SET, ACCOUNT_OBJECT, mockAccountId, WARNING_THRESHOLD);
			Test.stopTest();
		}
		catch(Exception ex){
			System.assert(ex instanceof AuraHandledException);
		}
	}

	private static Account createAccount(){
		Account acct = new Account(Name = 'Test Account', BillingCity = ' Test City');
		insert acct;
		return acct;
	}
}