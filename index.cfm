<cfdump var="#Application#">

<cfset gH = getGatewayHelper('Gimpy') />

<cfdump var="#gh#">

<cfset happen = getGatewayHelper('Gimpy').removeBuddy('don@sigmaprojects.org','') />

<cfdump var="#gh.getBuddyList()#" />

<cfdump var="#happen#" />

