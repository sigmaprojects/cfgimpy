<cfcomponent hint="- displays the time and date (Pacific Time - I live in California!).">

	<cffunction name="execute" returntype="struct" access="public" output="false">
		<cfargument name="bot" type="any" required="true" />
		<cfargument name="event" type="struct" required="true" />
		<cfargument name="buddyid" type="string" required="true" />
		<cfargument name="CommandArgs" type="string" required="true" />

		<cfset var result = structNew() />

		<cfset result.response = "MESSAGE" />
		<cfset result.buddyid = arguments.buddyid />
		<cfset result.message = Session.Name & ", the time is " & timeformat(now(),"long") & " on " & dateformat(now(),"medium") & "." />

		<cfreturn result />

	</cffunction>

</cfcomponent>
