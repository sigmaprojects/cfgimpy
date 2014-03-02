component implements="ICommand"  hint="{message} - I greet you the next time I see you." {

	public struct function execute(required any Bot, required struct Event, required string BuddyID, required string CommandArgs) {
		var result = structNew();

		result.response = "MESSAGE";
		result.BuddyID = arguments.BuddyID;
		result.Message = '';
			

		arguments.bot.getBotMemory().setTerm(BuddyID, "greeting", CommandArgs);
		Result.Response = 'Message';
		Result.BuddyID = BuddyID;
		Result.Message = "I'll be sure to greet you next time you return!";

			
		return result;
	}
}
