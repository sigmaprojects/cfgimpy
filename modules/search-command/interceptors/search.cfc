/*-----------------------------------------------------------------------
********************************************************************************

Author      :   Don Quist
Description :   Interceptor for the Search command module
    
-----------------------------------------------------------------------*/
component hint="Interceptor for Search command module" output="false" extends="coldbox.system.Interceptor" {

	property name="SearchService" inject="id:SearchService@GimpySearch";
	
	property name="SessionStorage" inject="id:SessionStorage";
	
	property name="Logger" inject="logbox:logger:{this}";

    public void function configure() {}


    public void function onSearch( required Any event, required Struct interceptData ) {
    	Logger.debug("Command Invocation Received");
    	SearchService.search( event.getResponse() );
    	//event.getResponse().setOutgoingMessage( HelloService.getRandomResponse() );
    	SessionStorage.setVar('Current','');
    }


}