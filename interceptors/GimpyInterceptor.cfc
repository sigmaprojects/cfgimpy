component {
	
	property name="Logger" inject="logbox:logger:{this}";

	property name="CommandRegistrationService" inject="id:CommandRegistrationService";

	property name="ResponseService" inject="id:ResponseService";
	
	property name="SessionStorage" inject="id:SessionStorage";
	
	public void function configure(){
		variables.gatewayid = "gimpy";
	}
	
	public void function onIncomingMessage(event,struct interceptData={}){
		Logger.debug("received onIncomingMessage");
		
		//var rc = event.getCollection();
		
		prepareRequest(event,interceptData);
		
		writedump(var=event.getResponse().getMemento().toString(),output="console");
		
		Logger.debug("About to process command: " & event.getResponse().getCommand());
		
		
		
		if( left(event.getResponse().getIncommingMessage(),4) eq "stop" ) {
			event.getResponse().setOutgoingMessage("okie dokie i stop!");
			//SessionStorage.setVar('current','');
			SessionStorage.clearAll();
		} else if( CommandRegistrationService.exists(event.getResponse().getCommand()) ) {
			var InterceptionPoint = 'on' & CommandRegistrationService.get(event.getResponse().getCommand());
			Logger.debug("About to trigger point: " & InterceptionPoint);
			announceInterception(InterceptionPoint, event.getResponse());
		} else {
			event.getResponse().setOutgoingMessage("i dunno wut u want");
		}
		
		
		
		
		announceInterception('invokeSendGatewayMessage');


		writedump(var="intercepted",output="console");
	}	
	
	public void function invokeSendGatewayMessage(event,struct interceptData={}) {
		Logger.debug("received invokeSendGatewayMessage");
		// this is kind of ugly, it should be more uniform, but for now:
		// if the message & buddyId object keys exists in the interceptData, it means it is probably an outgoing message,
		// otherwise, it originated from an incomming message and we're replying.
		if(
			structKeyExists(arguments.interceptData,'Message') &&
			len(trim(arguments.interceptData.Message)) &&
			structKeyExists(arguments.interceptData,'BuddyId') &&
			len(trim(arguments.interceptData.BuddyId))
		) {
			SendGatewayMessage(variables.gatewayid,{
				Message	= arguments.interceptData.Message,
				BuddyId	= arguments.interceptData.BuddyId
			});
		} else {
			SendGatewayMessage(variables.gatewayid,{
				Message	= event.getResponse().getOutgoingMessage(),
				BuddyId	= event.getResponse().getBuddyId()
			});
		}
	}
	
	/*
	public void function onStop(event,struct interceptData={}) {
		writedump(var=event.getResponse().getMemento().toString(),output="console");
		Logger.info("received onStop");
		SessionStorage.setVar('current','');
	}
	*/
	
	private void function prepareRequest(Event, Struct EventData) {
		var Response = arguments.Event.getResponse();
		Response.setIncommingMessage( arguments.EventData.Message );
		Response.setBuddyId( arguments.EventData.Sender );
		
		writedump(var=event.getResponse().getMemento().toString(),output="console");
		
		if( SessionStorage.exists('current') && Len(trim(SessionStorage.getVar('current'))) ) {
			Response.FinalizeRequest(true);
			Logger.debug("Overriding event from session: " & SessionStorage.getVar('current') );
			Response.setCommand( SessionStorage.getVar('current') );
		} else {
			SessionStorage.setVar('current',Response.getCommand());
			Response.FinalizeRequest();
		}
		/*
		if( !SessionStorage.exists('last') ) {
			SessionStorage.setVar('last','');
		}
		if( !SessionStorage.exists('current') ) {
			SessionStorage.setVar('current','');
		}
			if(Command eq 'stop') {
				Session.Current = '';
			}

			if(Len(Session.Current)) {
				Command = Session.Current;
				CommandArgs = inbound;
			}
		}
		*/
	}
	
//throw(message="Header #arguments.header# not found in HTTP headers",detail="Headers found: #structKeyList(headers)#",type="RequestContext.InvalidHTTPHeader");
/*
try {
				DelugeClient.connect();
			} catch(any e) {
				Logger.error('DelugeTorrentService.recordClientTorrents Client #DelugeClient.getDelugeAPI().getID()#; Connection error: ', e.tagContext);
			}
*/
		
	
}
