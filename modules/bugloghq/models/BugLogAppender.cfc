/**
********************************************************************************
*Copyright 2012 Ortus Solutions, Corp
* www.ortussolutions.com
********************************************************************************
* A BugLogHQ Appender
**/
component extends="coldbox.system.logging.AbstractAppender"{
	
	/**
	* Constructor
	*/
	function init( 
		required name,
		struct properties=structnew(),
		layout="",
		numeric levelMin=0,
		numeric levelMax=4
	){
		super.init( argumentCollection=arguments );
		
		// Get buglogHQ Service, wirebox must be in application scope.
		variables.buglogHQService = application.wirebox.getInstance( "BugLogService@bugloghq" );
		
		return this;
	}
	
	/**
	* Log a message
	*/
	function logMessage( required logEvent ){
		var loge	= arguments.logEvent;
		var entry 	= "";
		
		if ( hasCustomLayout() ){
			entry = getCustomLayout().format( loge );
		} else {
			entry = loge.getCategory() & ":" & loge.getMessage();
		}
		
		// log it
		variables.buglogHQService.notifyService(
			message 		= entry,
			exception 		= {},
			extraInfo 		= loge.getExtraInfo(),
			severityCode 	= this.logLevels.lookup( loge.getSeverity() )
		);
	}
	
}