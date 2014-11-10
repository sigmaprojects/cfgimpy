/**
* My Event Handler Hint
*/
component extends="coldbox.system.EventHandler"{

	/**
	* Executes before all handler actions
	*/
	any function preHandler( event, rc, prc, action, eventArguments ){
		log.info( "Sending some info to BugLog HQ" );
	}

	/**
	* Index
	*/
	any function index( event, rc, prc ){
		event.throwAnException();		
	}
	
}