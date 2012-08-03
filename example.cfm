<!--- Set the gateway buddy name to default values.---> 
<cfparam name="session.gwid" default="Gimpy"> 
<cfparam name="session.buddyid" default="gimpy@sigmaprojects.org"> 
 
<!--- Reset gateway and buddy ID if form was submitted. ---> 
<cfif isdefined("form.submitbuddy")> 
    <cfset session.buddyid=form.buddyid> 
    <cfset session.gwid=form.gwid> 
</cfif> 
 
<!--- Display the current gateway and buddy ID. ---> 
<h3>Using the GatewayHelper</h3> 
<!--- Form to display and reset gateway and Buddy ID. ---> 
<cfform action="#cgi.script_name#" method="post" name="changeIDs"> 
    Current buddy ID: <cfinput type="text" name="buddyid" value="#session.buddyid#"><br> 
    Current gateway ID: <cfinput type="text" name="gwid" value="#session.gwid#"><br> 
    <cfinput name="submitbuddy" value="Change gateway/buddy" type="submit"> 
</cfform> 
 
<!--- When a buddy is set, display the links and forms to get and set 
        information, and so on, Where form input is required, the form uses a GET method 
        so a url.cmd variable represents each selection. ---> 
     
<cfoutput> 
<h3>Select one of the following to get or set.</h3> 
<ul> 
    <li><a href="#cgi.script_name#?cmd=buddyinfo">buddyinfo</a> 
    <li>LIST: <a href="#cgi.script_name#?cmd=buddylist">buddylist</a> |  
        <a href="#cgi.script_name#?cmd=permitlist">permitlist</a> |  
        <a href="#cgi.script_name#?cmd=denylist">denylist</a> 
    <li>ADD: <a href="#cgi.script_name#?cmd=addbuddy">addbuddy</a> |  
        <a href="#cgi.script_name#?cmd=addpermit">addpermit</a> |  
        <a href="#cgi.script_name#?cmd=adddeny">adddeny</a> 
    <li>REMOVE: <a href="#cgi.script_name#?cmd=removebuddy">removebuddy</a> |  
        <a href="#cgi.script_name#?cmd=removepermit">removepermit</a> |  
            <a href="#cgi.script_name#?cmd=removedeny">removedeny</a> 
    <!--- NOTE: This list does not include OFFLINE because the gateway resets itself to online. ---> 
    <li>setStatus (XMPP):  
        <cfloop list="ONLINE,AWAY,DND,NA,FREE_TO_CHAT" index="e"> 
            <a href="#cgi.script_name#?cmd=setstatus&status=#e#">#e#</a> |  
        </cfloop> 
    <li>setStatus (Sametime):  
        <cfloop list="ONLINE,AWAY,DND,IDLE" index="e"> 
            <a href="#cgi.script_name#?cmd=setstatus&status=#e#">#e#</a> |  
        </cfloop> 
    <li> 
        <form action="#cgi.script_name#" method="get"> 
            setStatus with CustomAwayMessage:  
            <input type="hidden" name="cmd" value="setstatus2"> 
            <select name="status"> 
                <cfloop list="ONLINE,OFFLINE,AWAY,DND,IDLE,INVISIBLE,NA,OCCUPIED,FREE_TO_CHAT,ONPHONE,ATLUNCH,BUSY,NOT_AT_HOME,NOT_AT_DESK,NOT_IN_OFFICE,ON_VACATION,STEPPED_OUT,CUSTOM_AWAY" index="e"> 
                    <option value="#e#">#e#</option> 
                </cfloop> 
            </select> 
            <input type="text" name="custommsg" value="(custom away massage)" size="30"/> 
            <input type="submit"/> 
        </form> 
    <li> 
        <form action="#cgi.script_name#" method="get"> 
            setNickName:  
            <input type="hidden" name="cmd" value="setnickname"> 
            <input type="text" name="nickname" value="(enter nickname)"> 
            <input type="submit"> 
        </form> 
---> 
    <li>INFO: <a href="#cgi.script_name#?cmd=getname">getname</a> |  
        <a href="#cgi.script_name#?cmd=getnickname">getnickname</a> |  
        <a href="#cgi.script_name#?cmd=getcustomawaymessage">getcustomawaymessage</a> |  
        <a href="#cgi.script_name#?cmd=getprotocolname">getprotocolname</a> |  
        <a href="#cgi.script_name#?cmd=getstatusasstring">getstatusasstring</a> |  
        <a href="#cgi.script_name#?cmd=isonline">isonline</a> 
    <li>MESSAGE COUNT:  
        <a href="#cgi.script_name#?cmd=numberofmessagesreceived">numberofmessagesreceived</a> |  
        <a href="#cgi.script_name#?cmd=numberofmessagessent">numberofmessagessent</a> 
    <li>RUNNING TIME: <a href="#cgi.script_name#?cmd=getsignontimestamp">getsignontimestamp</a> |  
        <a href="#cgi.script_name#?cmd=getstatustimestamp">getstatustimestamp</a> 
    <li>setPermitMode:  
        <cfloop list="PERMIT_ALL,DENY_ALL,PERMIT_SOME,DENY_SOME,IGNORE_IN_LIST,IGNORE_NOT_IN_LIST" 
                index="e"><a href="#cgi.script_name#?cmd=setpermitmode&mode=#e#">#e#</a> |  
        </cfloop> <span class="note">doesn't work for XMPP</span> 
    <li><a href="#cgi.script_name#?cmd=getpermitmode">getpermitmode</a> 
    <li>setPlainTextMode:  
        <cfloop list="PLAIN_TEXT,RICH_TEXT" index="e"> 
            <a href="#cgi.script_name#?cmd=setplaintextmode&mode=#e#">#e#</a> |  
        </cfloop> 
    <li><a href="#cgi.script_name#?cmd=getplaintextmode">getplaintextmode</a> 
</ul> 
</cfoutput> 
 
<!--- The url.cmd value exists if one of the previous links or forms has been submitted, and identifies the type of request. ---> 
<cfoutput> 
<cfif isdefined("url.cmd")> 
    <!--- Get the GatewayHelper for the gateway. ---> 
    <cfset helper = getGatewayHelper(session.gwid)> 
    <!--- Get the buddy list if the list or full buddy information was requested. ---> 
    <cfswitch expression="#LCase(url.cmd)#"> 
        <cfcase value="buddylist,buddyinfo"> 
            <cfset ret=helper.getBuddyList()> 
        </cfcase> 
        <cfcase value="denylist"> 
            <cfset ret=helper.getDenyList()> 
        </cfcase> 
        <cfcase value="permitlist"> 
            <cfset ret=helper.getPermitList()> 
        </cfcase> 
        <cfcase value="addbuddy"> 
            <cfset ret=helper.addBuddy("#session.buddyid#",  
                "#session.buddyid#", "")> 
        </cfcase> 
        <cfcase value="addpermit"> 
            <cfset ret=helper.addPermit("#session.buddyid#",  
                "#session.buddyid#", "")> 
        </cfcase> 
        <cfcase value="adddeny"> 
            <cfset ret=helper.addDeny("#session.buddyid#",  
                "#session.buddyid#", "")> 
        </cfcase> 
        <cfcase value="removebuddy"> 
            <cfset ret=helper.removeBuddy("#session.buddyid#", "")> 
        </cfcase> 
        <cfcase value="removepermit"> 
            <cfset ret=helper.removePermit("#session.buddyid#", "")> 
        </cfcase> 
        <cfcase value="removedeny"> 
            <cfset ret=helper.removeDeny("#session.buddyid#", "")> 
        </cfcase> 
        <cfcase value="setstatus"> 
            <cfset ret=helper.setStatus(url.status, "")> 
        </cfcase> 
        <cfcase value="setstatus2"> 
            <cfset ret=helper.setStatus(url.status, url.custommsg)> 
        </cfcase> 
        <cfcase value="getcustomawaymessage"> 
            <cfset ret=helper.getCustomAwayMessage()> 
        </cfcase> 
        <cfcase value="getname"> 
            <cfset ret=helper.getName()> 
        </cfcase> 
        <cfcase value="getnickname"> 
            <cfset ret=helper.getNickname()> 
        </cfcase> 
        <cfcase value="getprotocolname"> 
            <cfset ret=helper.getProtocolName()> 
        </cfcase> 
        <cfcase value="getsignontimestamp"> 
            <cfset ret=helper.getSignOnTimeStamp()> 
        </cfcase> 
        <cfcase value="getstatusasstring"> 
            <cfset ret=helper.getStatusAsString()> 
        </cfcase> 
        <cfcase value="getstatustimestamp"> 
            <cfset ret=helper.getStatusTimeStamp()> 
        </cfcase> 
        <cfcase value="isonline"> 
            <cfset ret=helper.isOnline()> 
        </cfcase> 
        <cfcase value="numberofmessagesreceived"> 
            <cfset ret=helper.numberOfMessagesReceived()> 
        </cfcase> 
        <cfcase value="numberofmessagessent"> 
            <cfset ret=helper.numberOfMessagesSent()> 
        </cfcase> 
        <cfcase value="setnickname"> 
            <cfset ret=helper.setNickName(url.nickname)> 
        </cfcase> 
        <cfcase value="setpermitmode"> 
            <cfset ret=helper.setPermitMode(url.mode)> 
        </cfcase> 
        <cfcase value="getpermitmode"> 
            <cfset ret=helper.getPermitMode()> 
        </cfcase> 
        <cfcase value="setplaintextmode"> 
            <cfset ret=helper.setPlainTextMode(url.mode)> 
        </cfcase> 
        <cfcase value="getplaintextmode"> 
            <cfset ret=helper.getPlainTextMode()> 
        </cfcase> 
        <cfdefaultcase> 
            <cfset ret[1]="Error; Invalid command. You shouldn't get this."> 
        </cfdefaultcase> 
    </cfswitch> 
    <br> 
    <!--- Display the results returned by the called GatewayHelper method. ---> 
    <strong>#url.cmd#</strong><br> 
    <cfdump var="#ret#"> 
    <br> 
    <!--- If buddy information was requested, loop through buddy list to get  
        information for each buddy and display it. ---> 
    <cfif comparenocase(url.cmd, "buddyinfo") is 0 and arraylen(ret) gt 0> 
    <b>Buddy info for all buddies</b><br> 
        <cfloop index="i" from="1" to="#arraylen(ret)#"> 
            <cfdump var="#helper.getBuddyInfo(ret[i])#" label="#ret[i]#"></cfloop> 
    </cfif> 
</cfif> 
</cfoutput>