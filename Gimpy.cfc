component displayName="Gimpy" hint="Process events from the event gateway" {
	
	THIS.GatewayID = 'gimpy';
	THIS.Version = '0.1';
	setupchecks();

	function onIncomingMessage(required struct Event) output=false {
		var BuddyID = arguments.Event.Data.Sender;
		SessionChecks(BuddyID);
		
		if(Trim(arguments.Event.Data.Message) is not 'last') {
			Session.Last = Trim(arguments.Event.Data.Message);
		}
		if(arguments.Event.Data.Message is 'last') {
			arguments.Event.Data.Message = Session.Last;
		}
		
		var Inbound = Trim(arguments.Event.Data.Message);
		var Delimiters = ",.:; ";
		var Command = ListFirst(inbound, delimiters);
		var CommandArgs = listRest(inbound, delimiters);
		var Response = '';
		var Result = {
		};
		

		if(Command eq 'stop') {
			Session.Current = '';
		}

		if(Len(Session.Current)) {
			Command = Session.Current;
			CommandArgs = inbound;
		}

		if( isRegisteredUser( BuddyID ) ) {
			switch( Command ) {
				case 'reset': {
					setupchecks(true);
						Result.Response		= 'Message';
						Result.BuddyID		= BuddyID;
						Result.Message		= 'Ive been reset, Help!';
					break;
				}
				case 'resetsession': {
					setupchecks(true);
						Result.Response		= 'Message';
						Result.BuddyID		= BuddyID;
						Result.Message		= 'Ive been reset, Help!';
					break;
				}
				case 'stop': {
						Result.Response		= 'Message';
						Result.BuddyID		= BuddyID;
						Result.Message		= 'okie dokie!';
						break;
				}
				case "hi":case "hello":case "sup":case "howdy": {
					Result = createObject('component','gimpy.commands.hello').execute(bot=THIS,Event=arguments.Event,BuddyID=arguments.Event.Data.Sender,commandArgs=CommandArgs);
					break;
				}
				default: {
					if( FileExists(ExpandPath('/gimpy/commands/' & command & '.cfc')) ) {
						Result = createObject('component','gimpy.commands.' & command).execute(bot=THIS,Event=arguments.Event,BuddyID=arguments.Event.Data.Sender,commandArgs=CommandArgs);
					} else {
						Result.Response		= 'Message';
						Result.BuddyID		= BuddyID;
						Result.Message		= 'dunno what you want me to do =/';
					};
					break;
				}
			};
		} else {
			Result = createObject('component','gimpy.commands.register').execute(bot=THIS,Event=arguments.Event,BuddyID=arguments.Event.Data.Sender,commandArgs=CommandArgs);
		};

		if( StructKeyExists(Result,'Response') and Result.Response contains 'Message' ) {
			Respond(result);
		}
	};


	function onAddBuddyRequest(required struct Event) output=false {
		var Action = {
			Command		= 'Accept',
			Reason		= 'Valid for now.',
			BuddyID		= Event.Data.Sender
		};
		return action;
	};
	
	function onAddBuddyResponse(required struct Event) output=false {
		WRiteDump(var=arguments.Event,output='console');
	};
	
	function onBuddyStatus(required struct Event) output=false {
		WRiteDump(var=arguments.Event,output='console');
	};
	
	function onIMServerMessage(required struct Event) output=false {
		WRiteDump(var=arguments.Event,output='console');
	};

	/*****************************************************/



	private void function Respond(required struct Response) {
		if( Len(Arguments.Response.Message) GT 0 and Len(Arguments.Response.BuddyID) GT 0 ) {
			/*
			savecontent variable="d" { writedump(var=Response,top=3,format="text"); }
			writelog(text=d, type="information", file="XMPPClientGateway");
			*/
			SendGatewayMessage(THIS.GatewayID,Arguments.Response);
			sleep(100);
		}
	} 


	void function say(required string BuddyID, required string Message) {
		var Response = {
			response	= "Message",
			BuddyID		= Arguments.BuddyID,
			Message		= Arguments.Message
		};
		var key = '';
		var i = 1;
		var lines = ListToArray( Response.Message, "|" );			
		if( ArrayLen(lines) ) {
			for(i=1;i LTE ArrayLen(lines);i++) {
				Response = {
					response	= "Message",
					BuddyID		= Arguments.BuddyID,
					Message		= lines[i]
				};
				Respond(Response);
			}
		} else {
			Respond(Response);
		}
	} 



	private void function SessionChecks(required string BuddyID, boolean reset=false) {
		if(Arguments.Reset) {
			Session = StructNew();
		}
		Session.BuddyID = Arguments.BuddyID;
		if( ! StructKeyExists(Session,'BeenGreeted') ) {
			Greet(Session.BuddyID);
			Session.BeenGreeted = true;
		}
		if( ! StructKeyExists(Session,'Name')) {
			Session.Name = getBotMemory().GetTerm(arguments.BuddyID,'name');
		}
		if( ! StructKeyExists(Session,'Current') ) {
			Session.Current = '';
		}
		if( ! StructKeyExists(Session,'tries')) {
			Session.tries = 0;
		}
		if( ! StructKeyExists(Session,'last')) {
			Session.last = '';
		}
		
	}

	private void function Greet(required string BuddyID) {
		var greeting = getBotMemory().GetTerm(arguments.BuddyID,'greeting');
		say(arguments.BuddyID,greeting & ", " & getBotMemory().GetTerm(arguments.BuddyID,'name'));
	}

	private void function setupchecks(boolean debug=false) {
		if(!StructKeyExists(server,'Gimpy') or arguments.debug) {
			lock scope="Server" type="exclusive" timeout="30" {
				Server.Gimpy = {
					GimpyMemory 	= New GimpyMemory(),
					StatusManager	= New StatusManager(THIS.GatewayID)
				};
			}
		}
		/*
		if( (getGatewayHelper(THIS.GatewayID).numberOfMessagesReceived() MOD 20) EQ 1) {
			getServerScope().StatusManager.ChangeStatus();
		}
		*/
	}

	private boolean function isRegisteredUser(required string BuddyID) {
		return getBotMemory().KeyExists(arguments.BuddyID);
	}

	public void function setTerm(required string Key, required string Term, required String Value) {
		getBotMemory().SetTerm(arguments.Key, arguments.Term, arguments.Value);
	} 
	public function getTerm(required string Key, required string Term) {
		return getBotMemory().GetTerm(arguments.Key, arguments.Term);
	}
	public function getBotMemory() {
		return getServerScope().GimpyMemory;
	}

	private any function getServerScope() {
		lock scope="Server" type="readonly" timeout="30" {
			return Server.Gimpy;
		}  
	}











}
