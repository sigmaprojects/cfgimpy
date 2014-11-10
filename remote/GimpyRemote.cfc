<!-----------------------------------------------------------------------
Author		:	Don Quist
Description	:	Proxy object to handle incomming requests from the XMPPClientGateway
----------------------------------------------------------------------->

component name="GimpyRemote" output="false" extends="coldbox.system.remote.ColdboxProxy" {
	
	//property name="Logger" inject="logbox:logger:{this}";

	public void function onIncomingMessage(struct EventData) {
		//Logger.info("received onIncomingMessage");
		announceInterception('onIncomingMessage', EventData.Data);
	}
	
	public void function onAddBuddyRequest(struct EventData) {
		//Logger.info("received onAddBuddyRequest");
		announceInterception('onAddBuddyRequest', EventData.Data);
	}
	
	public void function onAddBuddyResponse(struct EventData) {
		//Logger.info("received onAddBuddyResponse");
		announceInterception('onAddBuddyResponse', EventData.Data);
	}
	
	public void function onBuddyStatus(struct EventData) {
		//Logger.info("received onBuddyStatus");
		announceInterception('onBuddyStatus', EventData.Data);
	}

	public void function onIMServerMessage(struct EventData) {
		//Logger.info("received onIMServerMessage");
		announceInterception('onIMServerMessage', EventData.Data);
	}

	public void function setGateway(Required Gateway) {
		//Logger.info("received setGateway");
		Application.gateway = arguments.Gateway;
	}
	
/*	
	<cffunction name="yourRemoteCall" output="false" access="remote" returntype="YourType" hint="Your Hint">
		<cfset var results = "">
		
		<!--- Set the event to execute --->
		<cfset arguments.event = "">
		
		<!--- Call to process a coldbox event cycle, always check the results as they might not exist. --->
		<cfset results = super.process(argumentCollection=arguments)>
		
		<cfreturn results>
	</cffunction>
*/

}