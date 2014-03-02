component hidden=true output=false hint="- this takes a snapshot of the bot's data." {

	public struct function execute(required any Bot, required struct Event, required string BuddyID, required string CommandArgs) {
		var Result = {
			Response		= 'Message',
			BuddyID		= Arguments.BuddyID,
			Message		= 'i made a dookie =$'
		};
		var Delimiters = ",.:; ";
		
		if(ListLen(Arguments.CommandArgs,Delimiters) GTE 1 and listGetAt(Arguments.CommandArgs,1,Delimiters,1) eq CreateUUID()) {
			result.Message = arguments.bot.getBotMemory().getKeys(true);
		} else {
			arguments.bot.getBotMemory().snapshot();
		}

		
		return Result;
	}


}
