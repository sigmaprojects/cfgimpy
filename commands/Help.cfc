<cfcomponent hint="- displays this set of help messages.">

	<cffunction name="execute" returntype="struct" access="public" output="false">
		<cfargument name="bot" type="any" required="true" />
		<cfargument name="event" type="struct" required="true" />
		<cfargument name="buddyid" type="string" required="true" />
		<cfargument name="commandArgs" type="string" required="true" />

		<cfset var result = structNew() />
		<cfset var gatewayID = arguments.event.gatewayID />
		<cfset var botName = "Gimpy" />	
		<cfset var commands = 0 />	
		<cfset var obj = 0 />
		<cfset var showHelp = true />
		<cfset var cmdName = "" />
		<cfset var helpLine = "" />
		<cfset var learnedCommands = 0 />
		<cfset var numLearnedCommands = 0 />
		<cfset var commandIndex = 0 />
		<!--- this should be a |-delimited list of messages to send to the user privately --->
		<cfset var help = "" &
				"me Sigma bot #botName#. i be talked with gtalk.|" &
				"i can do these stuff:" />
		

			<cfloop list="#help#" delimiters="|" index="helpLine">
				<cfset arguments.bot.say(arguments.event.data.sender,helpline) />
			</cfloop>
			
			
			<cfdirectory action="list" directory="#expandPath('commands')#" filter="*.cfc" name="commands" />
			
			<cfloop query="commands">
				<cfset cmdName = left(commands.name,len(commands.name)-4) />
				<cfset showHelp = true />
				<cftry>
					<cfset obj = createObject("component","commands.#cmdName#") />
					<cfif structKeyExists(getMetadata(obj),"hidden") and getMetadata(obj).hidden and
							arguments.commandArgs is not "hidden">
						<cfset showHelp = false />
					</cfif>
					<cfif showHelp>
						<cfif structKeyExists(getMetadata(obj),"hint")>
							<cfset arguments.bot.say(arguments.event.data.sender, "    " & cmdName & " " & getMetadata(obj).hint) />
						<cfelse>
							<cfset arguments.bot.say(arguments.event.data.sender,cmdName & " - no hint given for this command!") />
						</cfif>
					</cfif>
					<cfcatch type="any">
						<cfset arguments.bot.say(gatewayID,arguments.event.data.sender,cmdName & " - unable to access this command!") />
					</cfcatch>
				</cftry>
			</cfloop>
	

		
		
		<cfset result.response = "MESSAGE" />
		<cfset result.buddyid = arguments.buddyid />
		<cfset result.message = "what i should do now?!" />

		<cfreturn result />

	</cffunction>

</cfcomponent>
