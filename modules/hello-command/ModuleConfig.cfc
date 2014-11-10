component {

	// Module Properties
	this.title 				= "Hello-Command";
	this.author 			= "Don Quist";
	this.webURL 			= "http://www.sigmaprojects.org";
	this.description 		= "Replies with a hard-coded set of replies";
	this.version			= "2.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "hello-command";
	// Model Namespace
	this.modelNamespace		= "GimpyHello";
	// CF Mapping
	this.cfmapping			= "";

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			commandName		= "hello",
			commandAliases	= "hi,howdy,sup"
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
			customInterceptionPoints = "onHello"
		};

		// Custom Declared Interceptors
		interceptors = [
			{class="#moduleMapping#.interceptors.hello", properties={}}
		];

		// Binder Mappings
		binder.map("HelloService@GimpyHello").to("#moduleMapping#.models.helloService");

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