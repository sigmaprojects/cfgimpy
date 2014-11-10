/*-----------------------------------------------------------------------
********************************************************************************

Author      :   Don Quist
Description :   Interceptor for the learn command module
    
-----------------------------------------------------------------------*/
component hint="Interceptor for Learn command module" output="false" extends="coldbox.system.Interceptor" {

	property name="MemoryService" inject="id:MemoryService@GimpyLearn";
	
	property name="SessionStorage" inject="id:SessionStorage";
	
	property name="Logger" inject="logbox:logger:{this}";

    public void function configure() {}


    public void function onLearn( required Any event, required Struct interceptData ) {
    	Logger.debug("Command Invocation Received");
    	
    	// get ref to the Response object
    	var Response = event.getResponse();
    	
    	// set default out message
    	Response.setOutgoingMessage( "i dunno what you want me to learn =/" );
    	
    	var arrCommandArgs = Response.getCommandArgs();
    	
    	if( arrayLen(arrCommandArgs) gt 1 ) {
			
			// parse out the original message and remove the first 2 parts, 
			// since we shouldn't muck up the learned value with delimiters 
			var incommingMessage = Response.getIncommingMessage();
    		var value = ListDeleteAt(ListDeleteAt(incommingMessage,1," "),1," ");
    		writedump(var="learn value: " & value ,output="console");
    		MemoryService.set(
    			buddyId		= Response.getBuddyId(),
    			term		= arrCommandArgs[1],
    			value		= value
    		);
    		Response.setOutgoingMessage( "you learned me!" );
    		
    	}
    	
    	SessionStorage.setVar('Current','');
    }


}