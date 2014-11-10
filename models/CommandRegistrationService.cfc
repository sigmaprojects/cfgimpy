component output="false" hint="Manages what command modules are available" {
	
	public CommandRegistrationService function init() {
		variables.commands = [];
		return this;
	}
	
	
	public array function list() {
		return variables.commands;
	}
	
	public boolean function exists(Required String command) {
		var ecommand = get(arguments.command);
		if( IsNull(ecommand) ) {
			return false;
		}
		return true;
	}

	// this double loop really sucks for every incomming message
	// should build a yes/no exists index in the future	
	public any function get(Required String input) {
		for(var modu in variables.commands) {
			if( modu.commandName == arguments.input ) {
				return modu.commandName;
			}
			if( structKeyExists(modu,'commandAliases') ) {
				for(var alias in listToArray(modu.commandAliases) )  {
					if( alias == arguments.input) {
						return modu.commandName;
					}
				}
			}
		}
	}
	
	public void function register(Required Struct module) {
		if( !exists(arguments.module.commandName) ) {
			var command = {};
			command['commandName']		= arguments.module.commandName;
			command['commandAliases']	= "";
			if( structKeyExists(arguments.module,'commandAliases') ) {
				command['commandAliases'] = arguments.module.commandAliases;
			}
			arrayAppend(variables.commands,command);
		}
	}
	
	public void function unregister(Required Struct module) {
		if( ArrayContains(variables.commands, arguments.module) ) {
			arrayDeleteAt(variables.commands, ArrayFind(variables.commands, arguments.module) );
		}
	}
	
} 