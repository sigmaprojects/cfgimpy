component {

    variables.state="stopped";

    public void function init(String id, Struct config, Any listener){
    	variables.id = arguments.id;
        variables.config = arguments.config;
        variables.listener = arguments.listener;
        variables.listener.setGateway( this );
		if(variables.config.verbose){
        	writelog(text="XMPP Client Gateway [#arguments.id#] initialized", type="information", file="XMPPClientGateway");
        }
    }

	public void function start() {
		if(variables.config.verbose){
			writelog(text="Starting XMPPClient", type="information", file="XMPPClientGateway");
		}
		
		// just keeping with ACF normalization for the event data, could be changed easily.
		var Event = {
			Data = {
				Message	= '',
				Sender	= ''
			},
			Gateway = THIS,
			GatewayID = variables.id
		};
		
		
		variables.state = "starting";

		variables.jXMPPConfig = createObject('java','org.jivesoftware.smack.ConnectionConfiguration').init( variables.config.host, variables.config.serverport, 'gmail.com' );
		variables.jXMPPConfig.setSASLAuthenticationEnabled( true );

		variables.connection = createObject('java','org.jivesoftware.smack.XMPPConnection').init( variables.jXMPPConfig );

		variables.connection.connect();
		// gotta wait a second sometimes.
		sleep(100);
		variables.connection.login( variables.config.userID, variables.config.password );
        
        variables.state = "running";

		// using a packet filter is seriously low tech and blocking, but it works.
		// the connection can easily create multiple collectors at once using createPacketCollector
		// so it's possible to just add a filter for each packet type, but not necessary for sigmaprojects.org purposes..
		// or someone smarter can do this cleaner.
		// Also FYI: there are extra packets that come through using this route, so we only check for packets with a body length > 0
		var Message = createObject('java','org.jivesoftware.smack.packet.Message').init();
		var PacketTypeFilter = createObject('java','org.jivesoftware.smack.filter.PacketTypeFilter').init( Message.getClass() );
        
        var collector = variables.connection.createPacketCollector(PacketTypeFilter);

        while( variables.state eq 'running' ) {

			try {
			
	            var packet = collector.nextResult();
            	
            	if( len(trim(packet.getBody())) gt 0 ) {
            		
            		if(variables.config.verbose){
	            		writelog(text="Message From: #packet.getFrom()#.  Body: #packet.getBody()#", type="information", file="XMPPClientGateway");
            		}
            		
            		if(len(variables.config.onMessage)){
            			Event.Data.Message	= packet.getBody();
            			Event.Data.Sender	= ( listLen(packet.getFrom(),'/',false) gt 0 ? listFirst(packet.getFrom(),'/',false) : packet.getFrom() ); // sometimes the sender has stuff like user@gmail.com/Talk.v10etc appended, we cut it off.
                 		variables.listener[variables.config.onMessage](Event);
                	}
            	}
            	
            } catch(Any e) {
            	writelog(text="#e.message#", type="fatal", file="XMPPClientGateway");
            }

        	sleep(100);
        }

		return;
	}

	public void function stop() {
		if(variables.config.verbose){
			writelog(text="Stopping XMPPClient", type="information", file="XMPPClientGateway");
		}
		
		try {
			
			variables.state = "stopping";
			variables.connection.disconnect();
			variables.state="stopped";
			
			if(variables.config.verbose){
				writelog(text="Stopped XMPPClient", type="information", file="XMPPClientGateway");
			}
		}
		catch(Any e) {
			variables.state = "failed";
			writelog(text="#e.message#", type="fatal", file="XMPPClientGateway");
			rethrow;
		}
	}

	public void function restart() {
		if(variables.config.verbose){
			writelog(text="Restarting XMPPClient", type="information", file="XMPPClientGateway");
		}
		if (variables.state EQ "running") {
			stop();
		}
		start();
	}

	public any function getHelper(){
	}

	public String function getState(){
	    return variables.state;
	}

	public any function getServer(){
	    return variables.connection;
	}

	public void function SendMessage(Struct data) {
		var Packet = createObject('java','org.jivesoftware.smack.packet.Message').init( arguments.data.buddyid );
		Packet.setBody( arguments.data.message );
		variables.connection.sendPacket( Packet );
	}
	
	public void function setStatus(Required String Mode='available', Required String Status, String Type='available') {
		var validMods = 'chat,available,away,xa,dnd';
		if( !listContainsNoCase(validMods,arguments.Mode) ) {return;}
		
		var PresenceMode = createObject('java','org.jivesoftware.smack.packet.Presence$Mode')[arguments.Mode];

		var PresenceType = createObject('java','org.jivesoftware.smack.packet.Presence$Type')[arguments.Type];
	
		var Presence = createObject('java','org.jivesoftware.smack.packet.Presence').init(
			PresenceType,
			trim(arguments.Status),
			50,
			PresenceMode
		);
		variables.connection.sendPacket(Presence);
	}

}