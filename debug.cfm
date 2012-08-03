<cfset m = Server.Gimpy.GimpyMemory />
<!---
<cfset m.RemoveKey('Reminders') />
--->
<cfdump var="#m.getKeys()#">

<cfabort>

<cfset h = getGatewayHelper('Gimpy') />
<cfoutput>
#h.numberOfMessagesReceived()#
	<hr>
#(h.numberOfMessagesReceived() MOD 20)#
<br />
<cfif (h.numberOfMessagesReceived() MOD 20) EQ 1>
	we have a winner
</cfif>

</cfoutput>
<cfabort>
<cfdump var="#Server.Gimpy#">

<cfabort>
<cfset past = "11-4-10">
<cfif past LT DateFormat(Now(),'mm/dd/yy')>
	wtf
</cfif>

<cfabort>
<cfset m = Server.Gimpy.GimpyMemory />
<!---
<cfset m.RemoveKey('Reminders') />
--->
<cfdump var="#m.getKeys()#">

<cfabort>
<!---
<cfset m.RemoveTerm('Reminders','DE2E4DD2-0260-A47A-BB9A721FC50431A3') />
<cfset m.RemoveTerm('Reminders','DE594D67-05A9-839B-BFE0E8FCC95CF7BE') />
--->

<cfset f = DeserializeJson(FileRead(ExpandPath('GimpyMemory.json')))>

<cfdump var="#f#">

<cfabort>

<cfset t = "10:00pm">

<cfdump var="#ISDate(t)#">
<cfabort>
<cfdump var="#server#">
<cfabort>
<cfset s = Server.Gimpy />

<cfdump var="#S#">

<cfabort>
<!---
<cfset server.gimpy = new Gimpy() />
--->
<cfdump var='#server#' >
<cfabort>
<cfscript>

	thread name="GimpyWorker" action="run" {
		thread.sleepTimes=0;
		thread.running=true;


		while(thread.running) {
			thread.sleepTimes++;
			writedump(var=thread,output='console');
			Sleep(1000);

			if(thread.sleepTimes gte 10) {
				thread.running=false;
			}


		}
		writedump(var='where am i',output='console');
	}
	
</cfscript>

<cfabort>
<cfset m = new GimpyMemory() /> 
<cfdump var="#m.getKeys()#">
<cfabort>
<cfexecute name="java" arguments="-version" timeout="1" variable="output" />
<cfoutput>#output#</cfoutput>
<Cfdump var="#err#">
<cfabort>
<cfexecute name="java" arguments="-version" timeout="30" variable="output" />
<cfoutput>#output#</cfoutput>




<cfabort>
<cfdump var="#err#">

<cfabort>
<cfset Args = {
	FromAddress		= "14081 Magnolia",
	FromCity		= "Westminster",
	FromState		= "CA",
	FromCountry		= "US",
	ToAddress		= "",
	ToCity			= "Huntington Beach",
	ToState			= "CA",
	ToCountry		= "USA"

} />
<cfhttp method='get' url='http://maps.googleapis.com/maps/api/directions/json' result='httpCall'>
	<cfhttpparam type='url' name='origin' value='14081 magnolia, westminster, ca' >
	<cfhttpparam type='url' name='destination' value='costa mesa, ca' >
	<cfhttpparam type='url' name='sensor' value='false' >
</cfhttp>

<cfset fc = httpCall.FileContent />
				
				<cfdump var="#DeserializeJson(fc)#">
				<cfabort>


<cfabort>
<cfhttp method="get" url="http://google.com/news" result="httpcall">
<cfset l = "html,head,title,body,h1,table,tr,th,img,a,tr,td,address,nbsp">
<cfset fc = httpcall.filecontent />
<cfset fc = hrefsToList(fc,'|') />
<cfset fc = tagStripper(fc) />
<cfoutput>
	<cfset content = listtoarray(fc,"|") />
	<cfloop array="#content#" index="con">
	#con#<br>
	</cfloop>
	
</cfoutput>
<cfabort>
<cfset fc = tagStripper(fc) />
<cfset content = listtoarray(fc,"|") />
<cfoutput>
<cfset search = "720p">
<cfset Delimiters = ",.:; " />
<cfset qTest = QueryNew( 'name' ) />

<cfloop array="#content#" index="con">
<cfset string = listChangeDelims(trim(con),' ','.') />
<!---
<cfif listcontainsnocase(string,search,Delimiters)>
#string#<br>
</cfif>
--->

	<cfset QueryAddRow( qTest ) />
	<cfset qTest[ "name" ][ qTest.RecordCount ] = string />


</cfloop>
</cfoutput>

<cfset keywords = search>
<cfset fieldname = "name">

<cfset sqlSearch = smartSearch(keywords, fieldname, "OR")>

<cfquery dbtype="query" name="res">
    SELECT * FROM qTest WHERE PreserveSingleQuotes( smartSearch(keywords, fieldname, "OR") )
</cfquery>

<cfdump var="#res#" />
<cfdump var="#qTest#" />



		<!---#stripTags('disallow',l,con)#<br />--->
		<!---#tagStripper(con)# <br />--->

<!---
<cfdump var="#content#">
--->
<cfscript>
/**
* Smart boolean searching in SQL queries.
*
* @param searchterm      Search string. (Required)
* @param field      List of fields to search against. (Required)
* @return Returns a string.
* @author Craig McDonald (&#99;&#114;&#97;&#105;&#103;&#64;&#110;&#101;&#117;&#114;&#97;&#108;&#109;&#111;&#116;&#105;&#111;&#110;&#46;&#99;&#111;&#109;&#46;&#97;&#117;)
* @version 0, September 27, 2008
*/
function smartSearch(searchterm, field) {
    //init fields
    var fieldcount = 0;
    var currentfield = "";
    var searchstring = "";
    var startBracketCount = 0;
    var endBracketCount = 0;
    var bracketPoint = 0;
    var searchtermflag = "";
    var counter = "";
    var numchars = "";
    var preboolterm = "";
    var searchportion = "";
    var temp = "";
    var thisSearchTerm = "";
    
    arguments.booloperator = "OR";
    
    if(ArrayLen(arguments) GTE 3)
        arguments.booloperator = arguments[3];
        
    //trim leading and trailing spaces from the search term
    arguments.searchterm = trim(arguments.searchterm);
        
    //Count number of brackets for safety - if there is an uneven number
    //remove them all. Otherwise, it is safe to leave them.
    bracketPoint = Find("(", arguments.searchterm);
    while(bracketPoint IS NOT 0) {
        startBracketCount = startBracketCount + 1;
        bracketPoint = Find("(", arguments.searchterm, bracketPoint+1);
    }    
        
    bracketPoint = Find(")", arguments.searchterm);
    while(bracketPoint IS NOT 0) {
        endBracketCount = endBracketCount + 1;
        bracketPoint = Find(")", arguments.searchterm, bracketPoint+1);
    }
        
    if(startBracketCount IS NOT endBracketCount) {
        //Remove the brackets from the searchterm
        arguments.searchterm = Replace(arguments.searchterm, "(", "", "ALL");
        arguments.searchterm = Replace(arguments.searchterm, ")", "", "ALL");
    }
    
    if(arguments.booloperator IS "EXACT") {
        for (fieldcount = 1; fieldcount LTE ListLen(arguments.field); fieldcount = fieldcount + 1) {
            if(fieldcount IS 1)
                searchstring = searchstring & "(";
            else
                searchstring = searchstring & " OR ";
            
            currentfield = ListGetAt(arguments.field, fieldcount);
            searchstring = searchstring & "(" & currentfield & " Like '%" & arguments.searchterm & "%')";
        }
        
        if (Len(searchstring) GT 0)
            searchstring = searchstring & ")";
    }
    else {
        //init vars
        searchtermflag = 1;
        counter = 1;
        numchars = 0;
        prevboolterm = '';
        
        // Loop until there are no keywords left in the searchterm
        while (counter LTE Len(arguments.searchterm)) {
            //If this is the last searchterm, set the portion to the rest of the string
            if(counter IS Len(arguments.searchterm))
                searchportion = Len(arguments.searchterm);
            else //otherwise find the next keyword
            {
                searchportion = Find(" ", Right(arguments.searchterm, Len(arguments.searchterm) - counter));
                //Check if there is a ( opening bracket at the start of the string and if there is a " directly following
                if(Find("(", Mid(arguments.searchterm, counter, searchportion)) IS 1 AND Find('"', Mid(arguments.searchterm, counter, searchportion)) IS 2)
                {
                    //Remove the start quote from the beginning
                    attributes.searchterm = RemoveChars(arguments.searchterm, counter + 1, 1);
                    searchportion = searchportion - 1;

                    //There is, so find the end quote.
                    searchportion = Find('"', Mid(arguments.searchterm, counter, Len(arguments.searchterm))) - 1;
                    
                    //Remove the end quote from the position found
                    arguments.searchterm = RemoveChars(arguments.searchterm, counter + searchportion, 1);

                    //Check if the last character after the " quote is a ) closing bracket.
                    //If it is, extend the searchportion to include it.
                    if(Mid(arguments.searchterm, counter + searchportion, 1) IS ")")
                        searchportion = searchportion + 1;
                }
                
                //otherwise find if there's just a quote at the start of the keyword
                if(Find('"', Mid(arguments.searchterm, counter, searchportion)) IS 1)
                {
                    //There is, so find the end quote.
                    counter = counter + 1;
                    temp = 1;
                    searchportion = Find('"', Mid(arguments.searchterm, counter, Len(arguments.searchterm))) - 1;
                    
                    //Remove the end quote from the position found
                    arguments.searchterm = RemoveChars(arguments.searchterm, counter + searchportion, 1);
                                    
                    //Check if the last character after the " quote is a ) closing bracket.
                    //If it is, extend the searchportion to include it.
                    if(Mid(arguments.searchterm, counter + searchportion, 1) IS ")")
                        searchportion = searchportion + 1;                    
                }
                
                //if there are no keywords left, set the portion to the rest of the string
                if(searchportion IS 0)
                    searchportion = Len(arguments.searchterm);
            }
    
            // Check if this portion contains any boolean terms
            if ((Mid(arguments.searchterm, counter, searchportion) IS "OR" OR Mid(arguments.searchterm, counter, searchportion) IS "AND" OR Mid(arguments.searchterm, counter, searchportion) IS "NOT") AND counter IS NOT 1 AND searchportion IS NOT Len(arguments.searchterm)) {
                // Check if the current boolean term is just a NOT by itself (no AND or OR preceding it)
                if ((prevboolterm IS NOT "AND" AND prevboolterm IS NOT "OR") AND Mid(arguments.searchterm, counter, searchportion) IS "NOT") {
                    // Append AND and the boolean term to the SQL string
                    searchstring = searchstring & " AND " & Mid(arguments.searchterm, counter, searchportion) & " ";
                }
                else {
                    // Append this boolean term to the SQL string
                    searchstring = searchstring & " " & Mid(arguments.searchterm, counter, searchportion) & " ";
                }
                
                // Set the previous boolean term to the current boolean term
                prevboolterm = Mid(arguments.searchterm, counter, searchportion);
                
                // Set the search term set flag
                searchtermflag = 1;
            }
            else {
                // Loop through each of the fields to search on
                for (fieldcount = 1; fieldcount LTE ListLen(arguments.field); fieldcount = fieldcount + 1) {
                    currentfield = ListGetAt(arguments.field, fieldcount);
                
                    //if there were no boolean terms pre-existing, add some
                    if(searchtermflag LTE 0)
                    {
                        //if there's more than one field to search on, OR the keyword
                        if(fieldcount GT 1)
                            searchstring = searchstring & " OR ";
                        else //otherwise, AND the keyword (by default), or whatever the booloperator is set to
                            searchstring = searchstring & " " & arguments.booloperator & " ";
                    }
                    
                    //if this is the first field to search on, add an opening bracket
                    if(fieldcount IS 1)
                        searchstring = searchstring & "(";
                    
                    //Replace all ' single quotes with '' double quotes - safe parsing
                    thisSearchTerm = Replace(Mid(arguments.searchterm, counter, searchportion), "'", "''", "ALL");
                    
                    //init loop vars
                    startBrackets = "";
                    endBrackets = "";
                    
                    //Find any brackets at the start of the searchterm
                    bracketPoint = Find("(", thisSearchTerm);
                    while(bracketPoint IS NOT 0)
                    {
                        startBrackets = startBrackets & "(";
                        bracketPoint = Find("(", thisSearchTerm, bracketPoint+1);
                    }

                    //Find any brackets at the end of the searchterm                    
                    bracketPoint = Find(")", thisSearchTerm);
                    while(bracketPoint IS NOT 0)
                    {
                        endBrackets = endBrackets & ")";
                        bracketPoint = Find(")", thisSearchTerm, bracketPoint+1);
                    }
                    
                    //Remove the brackets from the searchterm
                    thisSearchTerm = Replace(thisSearchTerm, "(", "", "ALL");
                    thisSearchTerm = Replace(thisSearchTerm, ")", "", "ALL");
                    
                    //append this keyword to the SQL string
                    searchstring = searchstring & startBrackets & "(" & currentfield & " LIKE '%" & thisSearchTerm & "%')" & endBrackets;
                    //set the end of searchterm flag
                    searchtermflag = searchtermflag - 1;
                    
                    //clear the previous boolean term - should be reset for next word to be checked correctly
                    //Re: NOT's without AND's
                    prevboolterm = "";
                }    
            }
            
            // If there are no search terms left then close the bracket
            if (searchtermflag LTE 0)
                searchstring = searchstring & ")";
        
            // Move to the next search portion
            counter = counter + searchportion + 1;
        }
    }
    
    //Return the SQL string
    return searchstring;
}



/**
* Extracts all links from a given string and puts them into a list.
*
* @param inputString      String to parse. (Required)
* @param delimiter      Delimiter for returned list. Defaults to a comma. (Optional)
* @return Returns a list.
* @author Marcus Raphelt (&#99;&#102;&#109;&#108;&#64;&#114;&#97;&#112;&#104;&#101;&#108;&#116;&#46;&#100;&#101;)
* @version 1, February 22, 2006
*/
function hrefsToList(inputString) {
    var pos=1;
    var tmp=0;
    var linklist = "";
    var delimiter = ",";
    var endpos = "";
    
    if(arrayLen(arguments) gte 2) delimiter = arguments[2];
        
    while(1) {
        tmp = reFindNoCase("<a[^>]*>[^>]*</a>", inputString, pos);
        if(tmp) {
            pos = tmp;
            endpos = findNoCase("</a>", inputString, pos)+4;
            linkList = listAppend(linkList, mid(inputString, pos, endpos-pos), delimiter);
            pos = endpos;
        }
        else break;
    }

    return linkList;
}
	

	
/**
* Function to strip HTML tags, with options to preserve certain tags.
* v2 by Ray Camden, fix to closing tag
*
* @param str      String to manipulate. (Required)
* @param action      Strip or preserve. Default is strip. (Optional)
* @param tagList      Tags to strip or perserve. (Optional)
* @return Returns a string.
* @author Rick Root (&#114;&#105;&#99;&#107;&#64;&#119;&#101;&#98;&#119;&#111;&#114;&#107;&#115;&#108;&#108;&#99;&#46;&#99;&#111;&#109;)
* @version 2, July 2, 2008
*/
function tagStripper(str) {
    var i = 1;
    var action = 'strip';
    var tagList = '';
    var tag = '';
    
    if (ArrayLen(arguments) gt 1 and lcase(arguments[2]) eq 'preserve') {
        action = 'preserve';
    }
    if (ArrayLen(arguments) gt 2) tagList = arguments[3];

    if (trim(lcase(action)) eq "preserve") {
        // strip only those tags in the tagList argument
        for (i=1;i lte listlen(tagList); i = i + 1) {
            tag = listGetAt(tagList,i);
            str = REReplaceNoCase(str,"</?#tag#.*?>","","ALL");
        }
    } else {
        // strip all, except those in the tagList argument
        // if there are exclusions, mark them with NOSTRIP
        if (tagList neq "") {
            for (i=1;i lte listlen(tagList); i = i + 1) {
                tag = listGetAt(tagList,i);
                str = REReplaceNoCase(str,"<(/?#tag#.*?)>","___TEMP___NOSTRIP___\1___TEMP___ENDNOSTRIP___","ALL");
            }
        }
        // strip all remaining tsgs. This does NOT strip comments
        str = reReplaceNoCase(str,"</{0,1}[A-Z].*?>","","ALL");
        // convert unstripped back to normal
        str = replace(str,"___TEMP___NOSTRIP___","<","ALL");
        str = replace(str,"___TEMP___ENDNOSTRIP___",">","ALL");
    }
    
    return str;    
}

/**
* Strip xml-like tags from a string when they are within or not within a list of tags.
*
* @param stripmode      A string, disallow or allow. Specifies if the list of tags in the mytags attribute is a list of tags to allow or disallow. (Required)
* @param mytags      List of tags to either allow or disallow. (Required)
* @param mystring      The string to check. (Required)
* @param findonly      Boolean value. If true, returns the first match. If false, all instances are replaced. (Optional)
* @return Returns either a string or the first instance of a match.
* @author Isaac Dealey (&#105;&#110;&#102;&#111;&#64;&#116;&#117;&#114;&#110;&#107;&#101;&#121;&#46;&#116;&#111;)
* @version 2, September 22, 2004
*/
function stripTags(stripmode,mytags,mystring) {
    var spanquotes = "([^"">]*""[^""]*"")*";
    var spanstart = "[[:space:]]*/?[[:space:]]*";
    var endstring = "[^>$]*?(>|$)";
    var x = 1;
    var currenttag = structNew();
    var subex = "";
    var findonly = false;
    var cfversion = iif(structKeyExists(GetFunctionList(),"getPageContext"), 6, 5);
    var backref = "\\1"; // this backreference works in cf 5 but not cf mx
    var rexlimit = len(mystring);

    if (arraylen(arguments) gt 3) { findonly = arguments[4]; }
    if (cfversion gt 5) { backref = "\#backref#"; } // fix backreference for mx and later cf versions
    else { rexlimit = 19000; } // limit regular expression searches to 19000 characters to support CF 5 regex character limit

    if (len(trim(mystring))) {
        // initialize defaults for examining this string
        currenttag.pos = ListToArray("0");
        currenttag.len = ListToArray("0");

        mytags = ArrayToList(ListToArray(mytags)); // remove any empty items in the list
        if (len(trim(mytags))) {
            // turn the comma delimited list of tags with * as a wildcard into a regular expression
            mytags = REReplace(mytags,"[[:space:]]","","ALL");
            mytags = REReplace(mytags,"([[:punct:]])",backref,"ALL");
            mytags = Replace(mytags,"\*","[^$>[:space:]]*","ALL");
            mytags = Replace(mytags,"\,","[$>[:space:]]|","ALL");
            mytags = "#mytags#[$>[:space:]]";
        } else { mytags = "$"; } // set the tag list to end of string to evaluate the "allow nothing" condition

        // loop over the string
        for (x = 1; x gt 0 and x lt len(mystring); x = x + currenttag.pos[1] + currenttag.len[1] -1)
        {
            // find the next tag within rexlimit characters of the starting point
            currenttag = REFind("<#spanquotes##endstring#",mid(mystring,x,rexlimit),1,true);
            if (currenttag.pos[1])
            {
                // if a tag was found, compare it to the regular expression
                subex = mid(mystring,x + currenttag.pos[1] -1,currenttag.len[1]);
                if (stripmode is "allow" XOR REFindNoCase("^<#spanstart#(#mytags#)",subex,1,false) eq 1)
                {
                    if (findonly) { return subex; } // return invalid tag as an error message
                    else { // remove the invalid tag from the string
                        myString = RemoveChars(myString,x + currenttag.pos[1] -1,currenttag.len[1]);
                        currenttag.len[1] = 0; // set the length of the tag string found to zero because it was removed
                    }
                }
            }
            // no tag was found within rexlimit characters
            // move to the next block of rexlimit characters -- CF 5 regex limitation
            else { currenttag.pos[1] = rexlimit; }
        }
    }
    if (findonly) { return ""; } // return an empty string indicating no invalid tags found
    else { return mystring; } // return the new string discluding any invalid tags
}
</cfscript>

<cfabort>
<cfset m = new GimpyMemory() />

<cfset t = m.getTerm('statustrackerapi','sigma') />

<cfdump var="#T#">
 
<cfabort>
<cfset f = FileRead(ExpandPath('GimpyMemory.json')) />
<cfset s = DeSerializeJson(f) />

<cfdump var="#s#" />
<cfabort>
<cfset d = new debug() />


<cfset qs = "username=don&password=windows" />

<cfdump var="#d.queryStringToStruct(qs)#" /> 






<cfabort>
<cfscript>

		path = "\\sigmaserver\shared\incomplete_torrents\";
		httpService = new http(); 
		httpService.setUserAgent('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; T312461; .NET CLR 1.1.4322)');
		httpService.setMethod("get");
		torrenturl = "http://dl.btjunkie.org/torrent/Justice-Discography-3-albums-cross-A-Cross-The-Unive/3952e6bbabc4be43b4a93dd393835da763c2c4a8adf1/download.torrent";
		httpService.setUrl(torrenturl); 
		httpService.setPath(path);
		httpService.clearParams(); 
		result = httpService.send().getPrefix();
		writedump(result);

abort;
		path = "\\sigmaserver\shared\incomplete_torrents\";
		tl_cookies = {};
		
		httpService = new http(); 
		httpService.setUserAgent('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; T312461; .NET CLR 1.1.4322)');
		httpService.setMethod("get");
		httpService.setUrl("http://www.torrentleech.org/user/account/login/"); 
		result_1 = httpService.send().getPrefix();

		httpService.setMethod("post");
		httpService.setUrl("http://www.torrentleech.org/user/account/login/"); 
		httpService.addParam(type="formfield",name="username",value="sigmaproject"); 
		httpService.addParam(type="formfield",name="password",value="Resedit2!");
		httpService.addParam(type="formfield",name="remember_me",value="false");
		httpService.addParam(type="formfield",name="login",value="submit");
		addCookies(httpService,result_1);
		result_2 = httpService.send().getPrefix();
		
		torrenturl = "http://www.torrentleech.org/download/288334/Kanye.West.Ft.Rihanna.And.Kid.Cudi-All.Of.The.Lights-CONVERT-x264-2011-FRAY.torrent";
		
		httpService.setMethod("get");
		httpService.setUrl(torrenturl); 
		httpService.setPath(path);
		httpService.clearParams(); 
		addCookies(httpService,result_2);
		result_3 = httpService.send().getPrefix();
	
		
function addCookies(httpService,result) {
	var tl_cookies = {};
	var temp = '';
	var cName = '';
	var cValue = '';
	var key = '';
	var tl_key = '';
	for(key in arguments.result.responseHeader['Set-Cookie']) {
		temp = arguments.result.responseHeader['set-cookie'][key];
		temp = REReplace(temp, ";.*", "");
		cName = listFirst(temp,"=");
		cValue = listLast(temp,"=");
		tl_cookies[cName] = cValue;
	};
	for(tl_key in tl_cookies) {
		arguments.httpService.addParam(type="cookie",name="#tl_key#",value="#tl_cookies[tl_key]#");
	};
}

</cfscript>

<cfdump var="#result_2#" />
<cfdump var="#result_3#" />
<cfdump var="#tl_cookies#">
<cfabort>


<cfset tl_cookies=structNew()>

<cfhttp url="http://www.torrentleech.org/user/account/login/" method="GET" userAgent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; T312461; .NET CLR 1.1.4322)">
	<cfloop collection="#tl_cookies#" item="i">
		<cfhttpparam type="cookie" name="#i#" value="#tl_cookies[i]#">
	</cfloop>
</cfhttp>

<cfloop collection="#cfhttp.responseHeader['Set-Cookie']#" item="i">
	<cfset temp = cfhttp.responseHeader['set-cookie'][i]>
	<cfset temp = REReplace(temp, ";.*", "")>
	<cfset cName = listFirst(temp,"=")>
	<cfset cValue = listLast(temp,"=")>
	<cfset tl_cookies[cName] = cValue>
</cfloop>

<cfdump var="#tl_cookies#">
<cfdump var="#cfhttp#" />


<cfhttp url="http://www.torrentleech.org/user/account/login/" method="POST" userAgent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; T312461; .NET CLR 1.1.4322)">
	<cfhttpparam type="formfield" name="login" value="submit">
	<cfhttpparam type="formfield" name="username" value="sigmaproject">
	<cfhttpparam type="formfield" name="password" value="Resedit2!">
	<cfhttpparam type="formfield" name="remember_me" value="false">
	<cfloop collection="#tl_cookies#" item="i">
		<cfhttpparam type="cookie" name="#i#" value="#tl_cookies[i]#">
	</cfloop>
</cfhttp>


<cfdump var="#tl_cookies#">
<cfdump var="#cfhttp#" />





<cfabort>
<cfset path = "\\sigmaserver\shared\incomplete_torrents\" />
<cfset f = "test.txt" /> 


<cfset FileWrite(path & f,'hi') />

<cfset debug = New debug() />


 
<cfabort>
<cfset server.GimpyMemory.snapshot() />
<cfabort>
<cfset t = server.GimpyMemory.GetTerm('don.sigmaprojects@gmail.com','greeting') />
<cfoutput>
Termd:#t#
</cfoutput>
<br />
<cfdump var="#server.GimpyMemory.getv()#">
<cfdump var="#server#">
<cfabort>

<cfabort>

			<cfdirectory action="list" directory="#expandPath('commands')#" filter="*.cfc" name="commands" />
			
			<cfloop query="commands">
				<cfset cmdName = left(commands.name,len(commands.name)-4) />
				<cfset showHelp = true />
				
					<cfset obj = createObject("component","commands.#cmdName#") />
					<cfif structKeyExists(getMetadata(obj),"hidden") and getMetadata(obj).hidden and
							arguments.args is not "hidden">
						<cfset showHelp = false />
					</cfif>
					<cfif showHelp>
						<cfif structKeyExists(getMetadata(obj),"hint")>
							<!---
							<cfset arguments.bot.say(gatewayID,arguments.event.data.sender, "    " & cmdName & " " & getMetadata(obj).hint) />
							--->
							<cfdump var="#cmdName & ' ' & getMetadata(obj).hint#">
						<cfelse>
							<!---
							<cfset arguments.bot.say(gatewayID,arguments.event.data.sender,cmdName & " - no hint given for this command!") />
							--->
							<cfdump var="#cmdName#">
						</cfif>
					</cfif>

			</cfloop>