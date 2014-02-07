<cfscript>
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