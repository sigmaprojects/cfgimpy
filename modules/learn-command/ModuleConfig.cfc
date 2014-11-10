component {

	// Module Properties
	this.title 				= "Learn-Command";
	this.author 			= "Don Quist";
	this.webURL 			= "http://www.sigmaprojects.org";
	this.description 		= "A way to store key/value pairs via messages";
	this.version			= "2.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "learn-command";
	// Model Namespace
	this.modelNamespace		= "GimpyLearn";
	// CF Mapping
	this.cfmapping			= "";

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			commandName			= "learn",
			commandAliases		= "remember"
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
			customInterceptionPoints = "onLearn"
		};

		// Custom Declared Interceptors
		interceptors = [
			{class="#moduleMapping#.interceptors.learn", properties={}}
		];

		// register the diskStore cache for the memory service
		if( !cacheBox.cacheExists( "GimpyLearnCommandCache" ) ) {
			var gimpyCache = cachebox.createCache(
				name		= "GimpyLearnCommandCache",
				provider	= "coldbox.system.cache.providers.CacheBoxProvider",
				properties	= {
					objectDefaultTimeout = 0,
					objectDefaultLastAccessTimeout = 0,
					maxObjects = 5000,
					objectStore = "JDBCStore",
					dsn = "cfgimpy",
					table = "gimpymemory"
				}
			);
		}

		// Binder Mappings
		binder.map("MemoryService@GimpyLearn").to("#moduleMapping#.models.MemoryService");

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
		cacheBox.removeCache( "GimpyLearnCommandCache" );
		controller.getWirebox().getInstance('CommandRegistrationService').unregister( settings );
	}

}