component output=false name="RequestContextDecorator" extends="coldbox.system.web.context.requestContextDecorator" autowire=true {

	public void function Configure() {
		return;
	}
	
	public Response function getResponse() {
		var rc = getRequestContext().getCollection();
		if( structKeyExists(rc,'Response') ) {
			return rc.Response;
		}
		var newResponse = getController().getWirebox().getInstance("ResponseService").createResponse();
		rc.Response = newResponse;
		return rc.Response;
	}


}
