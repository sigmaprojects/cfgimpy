component output=false {

	public StatusManager function init(required Any Gateway) {
		variables.gateway = arguments.gateway;
		variables.quotes = GetGirQuotes();
		return This;
	}
	public any function getGateway() {
		return variables.gateway;
	}

	public void function ChangeStatus(numeric quote) {
		if(StructKeyExists(arguments,'quote') && IsNumeric(arguments.quote)) {
			getGateway().setStatus('Available', variables.quotes[arguments.quote] );
		} else {
			getGateway().setStatus('Available', variables.quotes[RandRange(1,ArrayLen(variables.quotes))] );
		}
	}



	private array function GetGirQuotes() {
		var quotes = [];
		ArrayAppend(quotes,"I'm running, I'm running, whoohoooo! I'm running! Wheehehehe! I'm naked!");
		ArrayAppend(quotes,"Can I be a mongoose dog?");
		ArrayAppend(quotes,"Aw...my bees");
		ArrayAppend(quotes,"I miss my cupcake.");
		ArrayAppend(quotes,"I am Government Man, come from the government. The government has sent me.");
		ArrayAppend(quotes,"I love this show.");
		ArrayAppend(quotes,"Ooh, I like madness!");
		ArrayAppend(quotes,"Let's go to my room, pig!");
		ArrayAppend(quotes,"Aw, somebody needs a hug!");
		ArrayAppend(quotes,"I like you.");
		ArrayAppend(quotes,"Tacos!");
		ArrayAppend(quotes,"I love the little tacos. I love them good.");
		ArrayAppend(quotes,"But I neeeeed tacos! I need them or I will explode! That happens to me sometimes!");
		ArrayAppend(quotes,"Wait, if you destroyed Dib in the past, then he won't ever be your enemy, then you won't have to send a robot back to destroy him, and then he will be your enemy so you will have to send a robot back-");
		ArrayAppend(quotes,"Why my piggy!?! I love-ed you, piggy! I love-ed you!");
		ArrayAppend(quotes,"Let's make biscuits! Let's make biscuits!");
		ArrayAppend(quotes,"I'm dancin' like a monkey!");
		ArrayAppend(quotes,"Aww...I wanted to explode!");
		ArrayAppend(quotes,"My taquitos! Eh, homina, eh... TAQUITOS!");
		ArrayAppend(quotes,"Why is his head so big!?! Why's his head so big!?!");
		ArrayAppend(quotes,"I gonna watch it again!");
		ArrayAppend(quotes,"Me and the squirrel are friends!");
		ArrayAppend(quotes,"It's got chicken legs!");
		ArrayAppend(quotes,"The plug thing! It's not plugged!");
		ArrayAppend(quotes,"Chicken!");
		ArrayAppend(quotes,"I'm gonna eat you!");
		ArrayAppend(quotes,"Aww, you look so cute!");
		ArrayAppend(quotes,"Meooow!");
		ArrayAppend(quotes,"Cows are my frieeeeends...");
		ArrayAppend(quotes,"Doo dee doo dee dooooo, waffles!!!");
		ArrayAppend(quotes,"Hi floor! Make me a sandwich!");
		ArrayAppend(quotes,"He’s gettin’ eaten by a shark!");
		return quotes;
	}

}