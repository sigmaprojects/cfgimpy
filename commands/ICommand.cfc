interface hint="The interface for all Gimpy commands" {

	public struct function execute(
		required struct Event,
		required string BuddyID,
		required string CommandArgs
	);
	
}