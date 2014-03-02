component output=false hint="{computer_name} - i ask my friend how kumputer is" {

	public struct function execute(required any Bot, required struct Event, required string BuddyID, required string CommandArgs) {
		var Result = {
			Response	= 'Message',
			BuddyID		= Arguments.BuddyID,
			Message		= 'i dont know that guy =/'
		};
		var Delimiters = ",.:; ";
		
		
		if( ListLen(Arguments.CommandArgs,Delimiters) EQ 1 AND arguments.bot.getBotMemory().KeyExists('statustrackerapi') AND IsStruct(arguments.bot.getBotMemory().getTerm('statustrackerapi',ListGetAt(Arguments.CommandArgs,1,Delimiters))) ) {
			Arguments.Bot.say( Arguments.BuddyID, 'me will ask now, wait please...' );
			var StatusTrackerLogin = arguments.bot.getBotMemory().getTerm('statustrackerapi',ListGetAt(Arguments.CommandArgs,1,Delimiters));  
			var ApiKey = GetStatusTrackerAPIKey(StatusTrackerLogin.UserName,StatusTrackerLogin.Password);
			var Status = GetLatestSpeedFanLog( ApiKey );
			Result.Message = FormatStatus(Status);
			var Hottest_1 = GetHottestSpeedFanLog(ApiKey, 'temp1');
			var Hottest_2 = GetHottestSpeedFanLog(ApiKey, 'temp2');
			Arguments.Bot.say( Arguments.BuddyID, 'Hottest Temp-1 #Hottest_1.day#:  #Hottest_1.temp1# @ #Hottest_1.seconds#' );
			Arguments.Bot.say( Arguments.BuddyID, 'Hottest Temp-2 #Hottest_2.day#:  #Hottest_2.temp2# @ #Hottest_2.seconds#' );
			
		}
		
		return Result;
	}

	private string function FormatStatus(required struct status) {
		var key = '';
		var logs = '';
		var ret = 'Current Taken: #arguments.status.day# @ #arguments.status.seconds#: ';
		
		for(key in arguments.status) {
			if(key contains "temp" or key contains "fan") {
				logs = "#key#=#arguments.status[key]#, #logs#";
			}
		}
		return ret & logs;
	}

	private string function GetStatusTrackerAPIKey(required string UserName, required string Password) {
		var httpService = new http();
			httpService.setMethod("get");
			httpService.setUrl( 'http://statustracker.sigmaprojects.org/api.cfc' );
			httpService.addParam(type="url",name="method",value="getAPIKey");
			httpService.addParam(type="url",name="username",value="#arguments.UserName#");
			httpService.addParam(type="url",name="password",value="#arguments.Password#");
			httpService.addParam(type="url",name="returnFormat",value="json");
		var result = httpService.send().getPrefix();
		var ApiKeyStruct = DeSerializeJson(result.FileContent);
		return ApiKeyStruct.apiKey;
	}

	private struct function GetLatestSpeedFanLog(required string ApiKey) {
		var httpService = new http();
			httpService.setMethod("get");
			httpService.setUrl( 'http://statustracker.sigmaprojects.org/api.cfc' );
			httpService.addParam(type="url",name="method",value="GetLatestSpeedFanLog");
			httpService.addParam(type="url",name="apiKey",value="#arguments.ApiKey#");
			httpService.addParam(type="url",name="returnFormat",value="json");
		var result = httpService.send().getPrefix();
		var returnResult = DeSerializeJson(result.FileContent);
		return returnResult;
	}

	private struct function GetHottestSpeedFanLog(required string ApiKey, required string Field) {
		var httpService = new http();
			httpService.setMethod("get");
			httpService.setUrl( 'http://statustracker.sigmaprojects.org/api.cfc' );
			httpService.addParam(type="url",name="method",value="GetSpeedFanHottest");
			httpService.addParam(type="url",name="apiKey",value="#arguments.ApiKey#");
			httpService.addParam(type="url",name="field",value="#arguments.Field#");
			httpService.addParam(type="url",name="returnFormat",value="json");
		var result = httpService.send().getPrefix();
		var returnResult = DeSerializeJson(result.FileContent);
		return returnResult;
	}

}