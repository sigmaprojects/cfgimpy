<cfcomponent output="false" hint="Sets up the application and defines top level event handlers.">

	<cfscript>
		THIS.Name = "Gimpy";
		THIS.ApplicationTimeout = CreateTimeSpan( 1, 0, 0, 0 );
		THIS.SessionManagement = true;
		THIS.SetClientCookies = true;
		if(structKeyExists(URL,'reload') and URL.reload IS 'reload') { THIS.ApplicationTimeout = CreateTimeSpan(0,0,0,0); };
		THIS.SessionTimeout = CreateTimeSpan(0,1,0,0);
	</cfscript>

	

	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="Fires when application starts.">
		<cfset StructClear( APPLICATION ) />
		<cfreturn true />
	</cffunction>

	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="true" hint="Fires when a request starts.">
		<cfargument name="Page" type="string" required="true" hint="The user-requested template." />
		<cfreturn true />
	</cffunction>

	<!---
	<cffunction name="OnRequest" access="public" returntype="void" output="true" hint="Fires when request needs to be executed.">
		<cfargument name="Page" type="string" required="true" hint="The user-requested template." />
		<cfinclude template="extensions/templates/_index.cfm" />
		<cfreturn />
	</cffunction>
	--->

	<cffunction name="onRequestEnd" access="public" returntype="void" output="false" hint="Fires when request ends.">
		<cfargument name="Page" type="string" required="true" hint="The user-requested template." />
		<cfreturn />
	</cffunction>

	<cffunction name="OnSessionStart" access="public" returntype="void" output="false" hint="Fires when session starts.">
		<cfreturn />
	</cffunction>

	<cffunction name="onSessionEnd" returnType="void" hint="Fires when session ends.">
		<cfargument name="SessionScope" required="true" />
		<cfargument name="ApplicationScope" required="true" />
	</cffunction>

<!---
	<cffunction name="onMissingTemplate" returnType="boolean" output="false">
		<cfargument name="thePage" type="string" required="true">
		<cflocation url="/home" statuscode="301" addtoken="no" />
		<cfreturn true />
	</cffunction>
--->

<!---
	<cffunction name="OnError" access="public" returntype="void" output="true" hint="Fires when an exception occures that is not caught by a try/catch.">
		<cfargument name="Exception" type="any" required="true" hint="The exception object thrown by the application."/>
		<cfargument name="EventName" type="string" required="false" default="" hint="The name of the exception."/>
		<cfset var errorDump = '' />

			<cfswitch expression="#ARGUMENTS.Exception.Cause.type#">
			
				<cfcase value="V9.securityAdvice.UnAuthorized">
					<cfdump var="#arguments#">
				</cfcase>
				<cfcase value="V9.securityAdvice.loginRequired">
					<cflocation url="/index.cfm/do/login/msg/#ARGUMENTS.Exception.Cause.Detail#" addtoken="no">
				</cfcase>

				<cfdefaultcase>
					<cfset APPLICATION.Factory.getBean('bugLogService').notifyService(ARGUMENTS.Exception.Cause, ARGUMENTS.Exception, "", "ERROR")>
					<!---<cflocation url="/index.cfm/do/home" statuscode="301" addtoken="no" />--->
					<cfinclude template="content/help/_error_static_dsp.cfm" />
				</cfdefaultcase>

			</cfswitch>

		<cfreturn />
	</cffunction>
--->


</cfcomponent>