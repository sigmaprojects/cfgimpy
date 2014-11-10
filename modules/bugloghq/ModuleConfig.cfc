/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component {

	// Module Properties
	this.title 				= "bugloghq";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "Bug Log HQ Interaction";
	this.version			= "2.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "bugloghq";
	// Auto Map Models
	this.autoMapModels		= false;

	/**
	* Configure
	*/
	function configure(){
		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="test",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// parse parent settings
		parseParentSettings();
		var settings = controller.getConfigSettings().buglogHQ;
		// Map service
		binder.map( "BugLogService@bugloghq" )
			.to( "#moduleMapping#.models.BugLogService" )
			.asSingleton()
			.initArg( name="bugLogListener", 		value=settings.bugLogListener )
			.initArg( name="bugEmailRecipients", 	value=settings.bugEmailRecipients )
			.initArg( name="bugEmailSender", 		value=settings.bugEmailSender )
			.initArg( name="hostname", 				value=settings.hostname )
			.initArg( name="apikey", 				value=settings.apikey )
			.initArg( name="appName", 				value=settings.appName )
			.initArg( name="maxDumpDepth", 			value=settings.maxDumpDepth )
			.initArg( name="writeToCFLog", 			value=settings.writeToCFLog );

		// Load the LogBox Appenders
		if( settings.enableLogBoxAppender ){
			loadAppenders();
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

	/**
	* Trap exceptions and send them to BugLogHQ
	*/
	function onException( event, interceptData, buffer ){
		wirebox.getInstance( "BugLogService@bugloghq" )
			.notifyService(
				message 		= interceptData.exception.message & "." & interceptData.exception.detail,
				exception 		= interceptData.exception,
				extraInfo 		= getHTTPRequestData(),
				severityCode 	= "error"
			);
	}

	//**************************************** PRIVATE ************************************************//	

	// load LogBox appenders
	private function loadAppenders(){
		// Get config
		var logBoxConfig 	= controller.getLogBox().getConfig();
		var rootConfig 		= "";

		// Register tracer appender
		rootConfig = logBoxConfig.getRoot();
		logBoxConfig.appender( name="bugloghq_appender", class="#moduleMapping#.models.BugLogAppender" );
		logBoxConfig.root( levelMin=rootConfig.levelMin,
						   levelMax=rootConfig.levelMax,
						   appenders=listAppend( rootConfig.appenders, "bugloghq_appender") );

		// Store back config
		controller.getLogBox().configure( logBoxConfig );
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var bugloghq 		= oConfig.getPropertyMixin( "bugloghq", "variables", structnew() );

		//defaults
		configStruct.bugloghq = {
			// The location of the listener where to send the bug reports
			"bugLogListener" : "https://buglog.sigmaprojects.org/listeners/bugLogListenerREST.cfm",
			// A comma-delimited list of email addresses to which send the bug reports in case
			"bugEmailRecipients" :  "",
			// The sender address to use when sending the emails mentioned above.
			"bugEmailSender" : "",
			// The api key in use to submit the reports, empty if none.
			"apikey" : "2CF20630-DD24-491F-BA44314842183AFC",
			// The hostname of the server you are on, leave empty for auto calculated
			"hostname" : "",
			// The aplication name
			"appName"	: "",
			// The max dump depth
			"maxDumpDepth" : 10,
			// Write out errors to CFLog
			"writeToCFLog" : true,
			// Enable the BugLogHQ LogBox Appender Bridge
			"enableLogBoxAppender" : true
		};

		// incorporate settings
		structAppend( configStruct.bugloghq, bugloghq, true );

	}

}