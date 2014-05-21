<cfcomponent output=false hint="- i remind you stuff!">

	<cffunction name="execute" access="public" output="false" returntype="struct">
		<cfargument name="Bot" type="struct" required="true" />
		<cfargument name="Event" type="struct" required="true" />
		<cfargument name="BuddyID" type="string" required="true" />
		<cfargument name="CommandArgs" type="string" required="true" />
		<cfscript>
		var RemindID = CreateUUID();
		var Result = {
			Response	= 'Message',
			BuddyID		= Arguments.BuddyID,
			Message		= ''
		};
		var Delimiters = " ";
		var arrCmdArgs = ListToArray(Arguments.CommandArgs,Delimiters);
		Session.Current = 'Remind';
		if(!StructKeyExists(Session,'Remind')) {
			Session.Remind = {};
		}
		
		if( arrayLen(arrCmdArgs) gte 4 ) {
			if( arrCmdArgs[1] eq 'me' ) {

				var NLDate = createObject("component","gimpy.commands.CF-NLDate.NLDate").init();
				var dateObj = NLDate.parse( arrCmdArgs[2] & ' ' & arrCmdArgs[3] & ' ' & arrCmdArgs[4]);
				Session.Remind.Date = dateFormat(dateObj,'mm/dd/yyyy');
				Session.Remind.Time = timeFormat(dateObj,'medium');
				Session.Remind.CurrentActionNeeded = 'details';
				arrCmdArgs = arrayNew(1);
			}
			
		}
		
		if(!StructKeyExists(Session.Remind,'CurrentActionNeeded')) {
			Session.Remind.CurrentActionNeeded = 'date';
		}
		
		switch(Session.Remind.CurrentActionNeeded) {
			case 'date': {
				if( ArrayLen(arrCmdArgs) LT 1 or !IsDate(arrCmdArgs[1]) ) {
					Arguments.Bot.Say(Arguments.BuddyID, 'wut day u want me to remind you?  (mm-dd-yy)');
					Session.tries++;
				} else if( IsDate(arrCmdArgs[1]) && arrCmdArgs[1] LT Now() ) {
					Arguments.Bot.Say(Arguments.BuddyID, 'i dun have flux capacitor =/');
					Arguments.Bot.Say(Arguments.BuddyID, 'wut day u want me to remind you?  (mm-dd-yy)');
					//1.21 Jigawatts
				} else {
					Session.Remind.Date = DateFormat(arrCmdArgs[1],'mm/dd/yyyy');
					Session.Remind.CurrentActionNeeded = 'time';
					Arguments.Bot.Say(Arguments.BuddyID, 'wut time u want me to remind you?  (12:01 PM)');
				}
				break;
			}
			
			case 'time': {
				if( ArrayLen(arrCmdArgs) LT 1 or !IsDate(arrCmdArgs[1]) ) {
					Arguments.Bot.Say(Arguments.BuddyID, 'wut time u want me to remind you?  (12:01 PM) {remember, im in pst!}');
					Session.tries++;
				} else {
					Session.Remind.Time = TimeFormat(arrCmdArgs[1],'full' );
					Session.Remind.CurrentActionNeeded = 'details';
					Arguments.Bot.Say(Arguments.BuddyID, 'wut u want me tell u?');
				}
				break;
			}
			case 'details': {
				if( ArrayLen(arrCmdArgs) LT 1 ) {
					Arguments.Bot.Say(Arguments.BuddyID, 'wut u want me tell u?');
					Session.tries++;
				} else {
					Session.Remind.Details = Arguments.CommandArgs;
					
					var RemindDetails = {
						Message	= Session.Remind.Details,
						BuddyID	= Arguments.BuddyID,
						Date	= Session.Remind.Date,
						Time	= Session.Remind.Time
					};
					lock scope="Application" type="exclusive" throwontimeout="false" timeout="60" {
						try {
							Application.ReminderService.createReminder(argumentCollection=RemindDetails);
							Arguments.Bot.Say(Arguments.BuddyID, 'k, ill remind u!');
						} catch(any e) {
							Arguments.Bot.Say(Arguments.BuddyID, 'kaboooom! whoopsie err');
						}
					} 
					StructDelete(Session,'Remind');
					Session.Current = '';
				}
				break;
			}
		}

		if(Session.Tries GTE 6) {
			Result.Message = 'if u want stop, just say stop';
		}	

		</cfscript>
		<cfreturn Result /> 
	</cffunction>


	<cffunction name="Remind" access="remote" output="false" returnType="string" returnFormat="json">
		<cfscript>
			lock scope="Application" type="exclusive" throwontimeout="false" timeout="60" {
				var Reminders = Application.ReminderService.getReadyMessages();
				for(var Reminder in Reminders) {
					Reminder.setTryCount( Reminder.getTryCount()+1 );
					try {
						SendGatewayMessage('Gimpy',Reminder.toJSON());
						Reminder.setSent(1);
					} catch(any e) {}
				}
				Application.ReminderService.save(Reminders,false,true);
			}
		</cfscript>
		<cfreturn "i done did it!" /> 
	</cffunction> 



</cfcomponent>