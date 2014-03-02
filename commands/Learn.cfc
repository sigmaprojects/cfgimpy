component output=false hint="- i learn stuffs!" {

	public struct function execute(required any Bot, required struct Event, required string BuddyID, required string CommandArgs) {
		var Result = {
			Response		= 'Message',
			BuddyID		= Arguments.BuddyID,
			Message		= 'i dunno what you want me to learn =/'
		};
		var Delimiters = ",; ";
		
		//result.Message = "Args: '#Arguments.CommandArgs#', ListLen: '#listLen(Arguments.CommandArgs,Delimiters)#'";

		if(ListLen(Arguments.CommandArgs,Delimiters) EQ 3) {
			arguments.bot.getBotMemory().SetTerm(
				ListGetAt(Arguments.CommandArgs,1,Delimiters),
				ListGetAt(Arguments.CommandArgs,2,Delimiters),
				ListGetAt(Arguments.CommandArgs,3,Delimiters)
			);
			result.Message = 'you learned me!';
		}

		
		return Result;
	}


}