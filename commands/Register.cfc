<cfcomponent hidden="true" hint="I ask you for your name.">

	<cffunction name="execute" returntype="struct" access="public" output="false">
		<cfargument name="bot" type="any" required="true" />
		<cfargument name="event" type="struct" required="true" />
		<cfargument name="BuddyID" type="string" required="true" />
		<cfargument name="CommandArgs" type="string" required="true" />

		<cfset var result = structNew() />

		<cfset result.response = "MESSAGE" />
		<cfset result.BuddyID = arguments.BuddyID />
		<cfset result.Message = '' />

		<cfif arguments.CommandArgs contains "name is">

			<cfset var name = ListLast(arguments.CommandArgs,' ') />
			<cfset arguments.bot.getBotMemory().SetTerm(arguments.BuddyID, 'Name', name) />
			<cfset arguments.bot.say(BuddyID, "Hello, #Name#.  Type help to get started.") />
		<cfelse>
			<cfset arguments.bot.say(BuddyID, "wuts ur name?  (you must respond 'my name is your_name')") />
		</cfif>

			
		<cfreturn result />

	</cffunction>

</cfcomponent>
