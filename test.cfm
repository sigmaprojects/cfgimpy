<cfscript>


	writedump(application.statusManager.ChangeStatus(1));
	abort;
	m = 'Available';
	PresenceMode = createObject('java','org.jivesoftware.smack.packet.Presence$Mode')[m];
	
	t = 'Available';
	PresenceType = createObject('java','org.jivesoftware.smack.packet.Presence$Type')[t];
	
	
	Presence = createObject('java','org.jivesoftware.smack.packet.Presence').init(
		PresenceType,
		'Weeee',
		50,
		PresenceMode
	);
	
	gateway = application.XMPPClientGateway;
	
	gateway.getServer().sendPacket(Presence);
	writedump(gateway.getServer());
	
	abort;
	
	writedump(PresenceType);
	
	abort;
	//writedump(server);
	writedump(application);
	abort;
	pc = GetPageContext();
	
	g = createObject('java','railo.runtime.functions.gateway.GetGatewayHelper').call(pc,'Gimpy');
	writedump(pc);
	writedump(g);
	abort;
	
	abort;
	var h = GetGatewayHelper('Gimpy');
	writedump(h);
	abort;
	
	abort;
	thisDir = '/var/www/gimpy.sigmaprojects.org/WEB-INF/railo/components/railo/extension/gateway/';
	/*
	cl = createObject('java','com.jacob.com.LibraryLoader').init();
	writedump(cl);
	abort;
	*/
  	//cl = new LibraryLoader(thisDir & 'lib/',true).init();
	jThread = createObject('java','java.lang.Thread');
	jSASLAuthentication = createObject('java','org.jivesoftware.smack.SASLAuthentication');
	jConnectionConfiguration = createObject('java','org.jivesoftware.smack.ConnectionConfiguration');
	jXMPPConnection = createObject('java','org.jivesoftware.smack.XMPPConnection');
	jSASLMechanism = createObject('java','org.jivesoftware.smack.sasl.SASLMechanism');
	jBase64 = createObject('java','org.jivesoftware.smack.util.Base64');
	
	config = jConnectionConfiguration.init('talk.google.com', '5222');
	
	writedump(config);
</cfscript>