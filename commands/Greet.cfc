<cfcomponent hint="{message} - I greet you the next time I see you.">

	<cffunction name="execute" returntype="struct" access="public" output="false">
		<cfargument name="bot" type="any" required="true" />
		<cfargument name="event" type="struct" required="true" />
		<cfargument name="BuddyID" type="string" required="true" />
		<cfargument name="CommandArgs" type="string" required="true" />

		<cfset var result = structNew() />

		<cfset result.response = "MESSAGE" />
		<cfset result.BuddyID = arguments.BuddyID />
		<cfset result.Message = '' />
			

		<cfset arguments.bot.getBotMemory().setTerm(BuddyID, "greeting", CommandArgs) />
		<cfset Result.Response = 'Message' />
		<cfset Result.BuddyID = BuddyID />
		<cfset Result.Message = "I'll be sure to greet you next time you return!" />

			
		<cfreturn result />

	</cffunction>

</cfcomponent>
