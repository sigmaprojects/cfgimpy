component {

	// Module Properties
	this.title 				= "Remind-Command";
	this.author 			= "Don Quist";
	this.webURL 			= "http://www.sigmaprojects.org";
	this.description 		= "Lets the user to create reminders to message them back at specific date/times";
	this.version			= "2.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "remind-command";
	// Model Namespace
	this.modelNamespace		= "GimpyRemind";
	// CF Mapping
	this.cfmapping			= "";

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			commandName		= "remind",
			commandAliases	= "reminder"
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
			{pattern="/", handler="Reminder",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = "onRemind"
		};
		/*
		writedump(controller.getSetting('htmlBaseURL'));
		abort;
		*/
		/*
		writedump(controller.getSetting('sesBaseURL'));abort;
		var t = event.buildLink(linkto='home.about',baseURL="#getSetting('htmlBaseURL')#");
		writedump(t);
		abort;
		*/
			
		// Custom Declared Interceptors
		interceptors = [
			{class="#moduleMapping#.interceptors.remind", properties={moduleMapping=moduleMapping}}
		];

		// Binder Mappings
		binder.map("ReminderService@GimpyReminder").to("#moduleMapping#.models.Reminder.ReminderService")
			.initArg(name="moduleMapping", value=moduleMapping)
			.initArg(name="entryPoint", value=this.entryPoint);

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