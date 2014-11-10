/*-----------------------------------------------------------------------
********************************************************************************

Author      :   Don Quist
Description :   Interceptor for the Hello command module
    
-----------------------------------------------------------------------*/
component hint="Interceptor for Hello command module" output="false" extends="coldbox.system.Interceptor" {


	property name="HelloService" inject="id:HelloService@GimpyHello";
	
	property name="SessionStorage" inject="id:SessionStorage";
	
	property name="Logger" inject="logbox:logger:{this}";

    public void function configure() {}


    public void function onHello( required Any event, required Struct interceptData ) {
    	Logger.debug("Command Invocation Received");
    	event.getResponse().setOutgoingMessage( HelloService.getRandomResponse() );
    	SessionStorage.setVar('Current','');
    }


}