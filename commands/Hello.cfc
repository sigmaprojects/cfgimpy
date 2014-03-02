<cfcomponent hidden="true" output="false">

	<cffunction name="execute" returntype="struct" access="public" output="false">
		<cfargument name="bot" type="any" required="true" />
		<cfargument name="event" type="struct" required="true" />
		<cfargument name="BuddyID" type="string" required="true" />
		<cfargument name="CommandArgs" type="string" required="true" />
		<cfset var possibleResults = ArrayNew(1) />
		
		<cfset result.response = "MESSAGE" />
		<cfset result.BuddyID = arguments.BuddyID />
		<cfset result.Message = getRandomResponse() />

		<cfreturn result />

	</cffunction>

	<cffunction name="getRandomResponse" access="private" output="false" returnType="string">
		<cfscript>
			var Messages = ArrayNew(1);
			Messages[1] = 'Hellloooooo!';
			Messages[2] = '...Where am I!?';
			Messages[3] = 'How do you know my language?!';
			Messages[4] = 'so lonely';
			Messages[5] = 'thats the last time i try that command';
			Messages[6] = 'quit it, im tryin to play a game';
			Messages[7] = 'just cut your losses';
			Messages[8] = 'dont bother me now, im juggling eggs!';
			Messages[9] = 'jump off into never-never land';
			Messages[10] = 'eat flaming death!';
			Messages[11] = 'He died at the console, Of hunger and thirst.  Next day he was buried, Face down, 9-edge first.';
			Messages[12] = 'core dump, examining the entrails';
			Messages[13] = 'kamikaze packet!';
			Messages[14] = 'im all spaghetti';
		</cfscript>
		<cfreturn Messages[RandRange(1,ArrayLen(Messages))] />
	</cffunction>

</cfcomponent>
