component output="false" persistent="false" accessors="true"  hint="The Response object" {

	property
		name="responseType"
		type="string"
		default="Message";
		
	property
		name="buddyId"
		type="string";
		   
	property
		name="outgoingMessage"
		type="string";

	property
		name="incommingMessage"
		type="string";

	property
		name="command"
		type="string";
		   
	property
		name="commandArgs"
		type="array";
	
	property
		name="delimiters"
		type="string"
		default=", .:;";


	public Response function init() {
		setCommandArgs(arrayNew(1));
		return this;
	}



	public void function finalizeRequest(Boolean includeFirst=false) {
		local.Inbound = trim(getIncommingMessage());
		local.Delimiters = getDelimiters();
		local.Command = ListFirst(local.Inbound, local.Delimiters);
		setCommand(local.Command);
		local.CommandArgs = listToArray(listRest(local.Inbound, local.Delimiters),local.Delimiters);
		setCommandArgs(local.CommandArgs);
		if( includeFirst ) {
			local.CommandArgs = listToArray(local.Inbound,local.Delimiters);
			setCommandArgs(local.CommandArgs);
		}
	}
	
	public void function compileCommandArgs() {
		local.CommandArgs = listToArray(getIncommingMessage(),getDelimiters());
		writedump(var="This is the result of compile: " & local.CommandArgs.toString(),output="console");
		setCommandArgs(local.CommandArgs);
	}

	public boolean function hasResponseType() {
		if(isNull(getResponseType()) || !Len(trim(getResponseType()))) {
			return false;
		}
		return true;
	}
	
	public boolean function hasBuddyId() {
		if(isNull(getBuddyId()) || !Len(trim(getBuddyId()))) {
			return false;
		}
		return true;
	}
	
	public boolean function hasOutgoingMessage() {
		if(isNull(getOutgoingMessage()) || !Len(trim(getOutgoingMessage()))) {
			return false;
		}
		return true;
	}
	
	public void function setIncommingMessage(String input="") {
		variables.incommingmessage = trim(arguments.input);
	}
	
	
	public struct function getMemento() {
		return DeserializeJSON( SerializeJSON( this ) );
	}
	public struct function toJson() {
		return DeserializeJSON( SerializeJSON( this ) );
	}
	
}   