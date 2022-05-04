/**
 * Created by gerry on 5/4/2022.
 */

public with sharing class Character_Counting_Component_Application
{
	//This allows us to create a factory for instantiating service classes. You send it the interface for your service class
	//and it will return the correct service layer class
	//Exmaple initialization: Object objectService = Application.service.newInstance(Character_Counting_Component_Service.class);
	public static final ServiceFactory service =
			new ServiceFactory(
					new Map<Type, Type>{
							Character_Counting_Component_Service.class => Character_Counting_Component_Service.class}
			);

	/**
	 * Simple Service Factory implementation
	 **/
	public class ServiceFactory
	{
		protected Map<Type, Type> m_serviceInterfaceTypeByServiceImplType;

		protected Map<Type, Object> m_serviceInterfaceTypeByMockService;

		/**
		 * Constructs a simple Service Factory
		 **/
		public ServiceFactory() { }

		/**
		 * Constructs a simple Service Factory,
		 *   using a Map of Apex Interfaces to Apex Classes implementing the interface
		 *   Note that this will not check the Apex Classes given actually implement the interfaces
		 *     as this information is not presently available via the Apex runtime
		 *
		 * @param serviceInterfaceTypeByServiceImplType Map ofi interfaces to classes
		 **/
		public ServiceFactory(Map<Type, Type> serviceInterfaceTypeByServiceImplType)
		{
			m_serviceInterfaceTypeByServiceImplType = serviceInterfaceTypeByServiceImplType;
			m_serviceInterfaceTypeByMockService = new Map<Type, Object>();
		}

		/**
		 * Returns a new instance of the Apex class associated with the given Apex interface
		 *   Will return any mock implementation of the interface provided via setMock
		 *   Note that this method will not check the configured Apex class actually implements the interface
		 *
		 * @param serviceInterfaceType Apex interface type
		 * @exception Is thrown if there is no registered Apex class for the interface type
		 **/
		public virtual Object newInstance(Type serviceInterfaceType)
		{
			// Mock implementation?
			if(m_serviceInterfaceTypeByMockService.containsKey(serviceInterfaceType))
				return m_serviceInterfaceTypeByMockService.get(serviceInterfaceType);

			// Create an instance of the type implementing the given interface
			Type serviceImpl = m_serviceInterfaceTypeByServiceImplType.get(serviceInterfaceType);
			if(serviceImpl==null)
				throw new DeveloperException('No implementation registered for service interface ' + serviceInterfaceType.getName());
			return serviceImpl.newInstance();
		}

		@TestVisible
		private virtual void setMock(Type serviceInterfaceType, Object serviceImpl)
		{
			m_serviceInterfaceTypeByMockService.put(serviceInterfaceType, serviceImpl);
		}
	}

	/**
	 * Exception representing a developer coding error, not intended for end user eyes
	 **/
	public class DeveloperException extends Exception { }
}