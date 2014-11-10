/* Gimpy memory is just a key/value store,   
 * with the key comprised of [buddyId]&[term], essentially a composite key.
 * see the generateCompositeKey for a rudimentary composition
*/

component output="false" hint="{term} {value} - i remember stuffs!" {
	
	// to trigger a gateway message (but still have it handled by the interceptor)
	property name="interceptorService" inject="coldbox:interceptorService";
	
	// reference to gimpys cache
	property name="gimpyCache" inject="cachebox:GimpyLearnCommandCache";
	
	property name="Logger" inject="logbox:logger:{this}";
	
	public void function set(
		Required	String		buddyId,
		Required	String		term,
		Required	Any			value
	) {
		var key = generateCompositeKey(argumentCollection=arguments);
		gimpyCache.set(key,trim(arguments.value));
	}

	public any function get(
		Required	String		buddyId,
		Required	String		term
	) {
		var key = generateCompositeKey(argumentCollection=arguments);
		return gimpyCache.get(key);
	}
	
	public boolean function exists(
		Required	String		buddyId,
		Required	String		term
	) {
		var key = generateCompositeKey(argumentCollection=arguments);
		return gimpyCache.lookup(key);
	}

	private string function generateCompositeKey(
		Required	String		buddyId,
		Required	String		term
	) {
		return trim(arguments.buddyId) & "-" & trim(arguments.term);
	}

}