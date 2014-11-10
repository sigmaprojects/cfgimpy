component {

	// Module Properties
	this.title 				= "Time-Command";
	this.author 			= "Don Quist";
	this.webURL 			= "http://www.sigmaprojects.org";
	this.description 		= "Replies with the time";
	this.version			= "2.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "time-command";
	// Model Namespace
	this.modelNamespace		= "GimpyTime";
	// CF Mapping
	this.cfmapping			= "";

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			commandName		= "time",
			commandAliases	= "what time,what time is it"
		};

		// Layout Settings
		layoutSettings = {
			defaultLayout = ""
		};

		// datasources
		datasources = {

		};

		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="home",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = "onTime"
		};

		// Custom Declared Interceptors
		interceptors = [
			{class="#moduleMapping#.interceptors.time", properties={}}
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		controller.getWirebox().getInstance('CommandRegistrationService').register( settings );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		controller.getWirebox().getInstance('CommandRegistrationService').unregister( settings );
	}

}