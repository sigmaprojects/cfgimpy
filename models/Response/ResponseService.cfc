component output="false" hint="The Response service" {
	
	public ResponseService function init() {
		return this;
	}
	
	public Response function createResponse() {
		return createObject("component","Response").init();
	}
	
	
}  