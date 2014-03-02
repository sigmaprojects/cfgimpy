<cfcomponent extends="Gateway">

    <cfset fields=array(
		field("Host","host","jabber.org",true,"XMPP host server","text"),
		field("Server Port","serverport","5222",true,"Port of the XMPP server","text"),
		field("userID","userID","",true,"User Name or API Key","text"),
		field("Password","password","",true,"User Password or API Secret","text"),
		field("secure protocol","secureprotocol","",true,"Secure Protocol (not implemented)","text"),
		field("securerequirement","securerequirement","false",true,"Require Secure (not implemented)","text"),
		field("retries","retries","false",true,"retry (not implemented)","text"),
		field("retryinterval","retryinterval","5",true,"retry Interval (not implemented)","text"),
		field("Verbose","verbose","false",true,"Enable verbose logging","radio","true,false"),
		group("CFC Listener Function Defintion","Definitation for the CFC Listener Functions, when empty no listener is called",3),
		field("ClientOpen","onClientOpen","onClientOpen",false,"called when a client open a connection (not implemented)","text"),
		field("Message","onMessage","onMessage",false,"called when a client send a new message","text"),
		field("Add Buddy Request","onAddBuddyRequest","onAddBuddyRequest",false,"called when buddy request (not implemented)","text"),
		field("Add Buddy Response","onAddBuddyResponse","onAddBuddyResponse",false,"called when buddy Response (not implemented)","text"),
		field("ClientClose","onClientClose","onClientClose",false,"called when the client close the connection (not implemented)","text")
	)>

	<cffunction name="getClass" returntype="string">
    	<cfreturn "">
    </cffunction>

	<cffunction name="getCFCPath" returntype="string">
    	<cfreturn "railo.extension.gateway.XMPPClientGateway" />
    </cffunction>

	<cffunction name="getLabel" returntype="string" output="no">
    	<cfreturn "XMPPClient">
    </cffunction>

	<cffunction name="getDescription" returntype="string" output="no">
    	<cfreturn "Create an xmpp client gateway">
    </cffunction>

	<cffunction name="onBeforeUpdate" returntype="void" output="false">
		<cfargument name="cfcPath" required="true" type="string">
		<cfargument name="startupMode" required="true" type="string">
		<cfargument name="custom" required="true" type="struct">

	</cffunction>

	<cffunction name="getListenerCfcMode" returntype="string" output="no">
		<cfreturn "required">
	</cffunction>

	<cffunction name="getListenerPath" returntype="string" output="no">
		<!---<cfreturn "railo.extension.gateway.WebSocketListener">--->
		<cfreturn "">
	</cffunction>

</cfcomponent>