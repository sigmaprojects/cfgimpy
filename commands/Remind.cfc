<cfcomponent output=false hint="- i remind you stuff!">

	<cffunction name="execute" access="public" output="false" returntype="struct">
		<cfargument name="Bot" type="struct" required="true" />
		<cfargument name="Event" type="struct" required="true" />
		<cfargument name="BuddyID" type="string" required="true" />
		<cfargument name="CommandArgs" type="string" required="true" />
		<cfscript>
		var RemindID = CreateUUID();
		var Result = {
			Response		= 'Message',
			BuddyID		= Arguments.BuddyID,
			Message		= ''
		};
		var Delimiters = ",";
		var arrCmdArgs = ListToArray(Arguments.CommandArgs,Delimiters);
		Session.Current = 'Remind';
		if(!StructKeyExists(Session,'Remind')) {
			Session.Remind = {};
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
					Arguments.Bot.Say(Arguments.BuddyID, 'k, ill remind u!');
					var RemindDetails = {
						Message	= Session.Remind.Details,
						BuddyID	= Arguments.BuddyID,
						Date	= Session.Remind.Date,
						Time	= Session.Remind.Time
					};
					Arguments.bot.getBotMemory().SetTerm(
						'Reminders',
						RemindID,
						RemindDetails
					);
					CreateReminder(
						Session.Remind.Date,
						Session.Remind.Time,
						RemindID
					);
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

	<cffunction name="CreateReminder" access="private" output="false" returnType="void">
		<cfargument name="RemindDate" type="string" required="true" />
		<cfargument name="RemindTime" type="string" required="true" />
		<cfargument name="RemindID" type="string" required="true" /> 
			<cfschedule action="update" 
				task="Gimy_Reminder_#Arguments.RemindID#"  
				operation="HTTPRequest" 
				url="http://gimpy.sigmaprojects.org/commands/remind.cfc?method=Remind&RemindID=#Arguments.RemindID#" 
				startDate="#DateFormat(Arguments.RemindDate,'mm/dd/yyyy')#" 
				startTime="#TimeFormat(Arguments.RemindTime,'medium')#"
				interval="once" 
				requestTimeOut="600" />
	</cffunction> 

	<cffunction name="Remind" access="remote" output="false" returnType="string" returnFormat="json">
		<cfargument name="RemindID" type="string" required="true" />
		<cfscript>
			var GimpyMemory = Application.GimpyMemory;
			var Reminder = GimpyMemory.GetTerm('Reminders',Arguments.RemindID); 
			
			var Response = {
				Response	= 'Message',
				BuddyID		= Reminder.BuddyID,
				Message		= Reminder.Message
			};
			SendGatewayMessage('Gimpy',Response);
			GimpyMemory.RemoveTerm('Reminders',Arguments.RemindID);
		</cfscript>
		<cfschedule action="delete" task="Gimy_Reminder_#Arguments.RemindID#" />
		<cfreturn "i done did it!" /> 
	</cffunction> 



</cfcomponent>