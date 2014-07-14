<cfscript>

jXMPPConfig = createObject('java','org.jivesoftware.smack.ConnectionConfiguration').init( 'talk.google.com', '5222', 'Talk' );
securityMode = createObject('java','org.jivesoftware.smack.ConnectionConfiguration$SecurityMode')['ENABLED'];
sc = createObject('java','javax.net.ssl.SSLContext').getInstance("TLS");
sc.init(javaCast('null',''), javaCast('null',''), createObject('java','java.security.SecureRandom').init() );
jXMPPConfig.setCustomSSLContext(sc);
jXMPPConfig.setSecurityMode( securityMode );

connection = createObject('java','org.jivesoftware.smack.tcp.XMPPTCPConnection').init( jXMPPConfig );
//connection = createObject('java','org.jivesoftware.smack.XMPPConnection').init( jXMPPConfig );
//connection = createObject('java','org.jivesoftware.smack.tcp.XMPPTCPConnection').init("talk.gmail.com");

writedump(connection);

connection.connect();

writedump(connection);

abort;
	writedump(application);
	abort;
	Commands = DirectoryList(expandPath('/commands'));
	for(Command in Commands) {
		
		file = listLast(Command,'/',false);
		if( file eq 'hello.cfc') {
		//obj = createObject('component','gimpy.commands.' & command)
		obj = createObject('component','gimpy.commands.' & replaceNoCase(file,'.cfc','','all') );
		
		
		writedump( getMetaData(obj) );
		abort;
		}
	}
	writedump(commands);
	abort;
	Application.GimpyMemory = new GimpyMemory();
	/*
	GM = new GimpyMemory();
	
	writedump(GM.getKeys());
	abort;
	*/
	try {
	a = cacheGet('Gimpy');
	writedump(a);
	} catch(any e) {
		writeoutput('failed to display cache');
	}
	
	try {
		writedump(application.gimpymemory.getkeys());
	} catch(any e) {
		
	}
	
	writedump(application);
	
	/*
	abort;
	cachePut('testing','weeeeeeeeeeee');
	p = cacheGet('testing');
	writedump(p);
	
	keys = cacheGetAllIDs();
	writedump(keys);
	*/
</cfscript>