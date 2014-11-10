component output="false" hint="{location} {keyword} - i ask if my friends have" {
	
	// to trigger a gateway message (but still have it handled by the interceptor)
	property name="interceptorService" inject="coldbox:interceptorService";
	
	property name="wirebox" inject="wirebox";
	
	property name="Logger" inject="logbox:logger:{this}";
	
	public void function search(Required Response) {
		
		//setup the incomming Response object with defaults
		arguments.Response.setOutgoingMessage("friends say dont have =/");

		// this command only uses spaces as its command delimiter 
		var Delimiters = " ";
		arguments.Response.setDelimiters(Delimiters);
		arguments.Response.compileCommandArgs();
		
		// check if there are enough parameters to execute the request
		if( arrayLen(arguments.Response.getCommandArgs()) eq 1 ) {
			arguments.Response.setOutgoingMessage("i dunno what search for =/");
			return;
		}


		var area = arguments.Response.getCommandArgs()[2]; // location should be at index 1
		
		Logger.debug("About to search: " & area);
		
		if( IsValid("url",area) ) {
			// valid url, compile the query and respond
			
			// the url turned into a QoQ
			var qoqQuery = CompileQuery(area);
			
		} else if( memoryExists(arguments.Response.getBuddyId(),area) ) {
			// check to see if this area/term exists in gimpys memory
			
			// grab the value, check to see what it is and use it, if possible (add support later for directory searching, needs securing)
			var existing = wirebox.getInstance("MemoryService@GimpyLearn").get(buddyId=arguments.Response.getBuddyId(),term=area);
			var qoqQuery = CompileQuery(existing);
			
		} else { 
			// valid Nothing, tell them off
			arguments.Response.setOutgoingMessage("dunno how to search that...");
			return;
		}
		
		// use that java goodness, split the array after the 2nd element,
		// then turn it into a string for searching
		// (java array indexes start a 0) 
		var arrCommandArgs = arguments.Response.getCommandArgs();
		var keywords = arrayToList(arrCommandArgs.subList(2,arrayLen(arrCommandArgs))," ");
		Logger.debug("About to search with keywords: " & keywords);
		var searchResults = SearchQuery( keywords, qoqQuery );
		
		// if we found stuff, reply to the user if the record count is under 15.
		if( searchResults.RecordCount LTE 15 and searchResults.RecordCount GT 0) {
			
			sendMessage(arguments.Response.getBuddyId(),"i found stuffs! =D'");
			
			for(var i=1; i LTE searchResults.RecordCount;i++) {
				sendMessage(arguments.Response.getBuddyId(), searchResults['name'][i] );
			}
			
			// nullify the outgoing message, the interceptor should prevent it from replying a non-message
			arguments.Response.setOutgoingMessage("");
			return;
		}
		
		// found too many results, bug out.
		if( searchResults.RecordCount GT 15 ) {
			arguments.Response.setOutgoingMessage("i found too much stuffs and made a dookie =$");
		}


	}
	
	private boolean function memoryExists(Required String buddyId, Required String term) {
		// helper method to do a few checks if the memory module is present, and if the key exists.
		try {
			var MemoryService = wirebox.getInstance("MemoryService@GimpyLearn");
			if( !IsNull(MemoryService) && MemoryService.exists(argumentCollection=arguments) ) {
				return true;
			}
		} catch(any e) {
			return false;
		}
		return false;
	}

	private void function sendMessage(Required String BuddyId, Required String Message) {
		interceptorService.processState(
			'invokeSendGatewayMessage',
			arguments
		);
	}


	private query function CompileQuery(required string termURL) {
		var httpService = new http();
			httpService.setMethod("get");
			httpService.setUrl( arguments.termURL );
		var result = httpService.send().getPrefix();
		var fc = result.filecontent;
			fc = hrefsToList(fc,'|');
			fc = tagStripper(fc);
		var names = listtoarray(fc,"|");
		var i = 1;
		var SearchQuery = QueryNew( 'name' );
		for(i=1;i LTE ArrayLen(names);i++) {
			QueryAddRow( SearchQuery );
			SearchQuery[ "name" ][ SearchQuery.RecordCount ] = listChangeDelims(trim(LCase(names[i])),' ','.');
		}
		return SearchQuery;
	}

	private query function SearchQuery(required string keyword, required query SearchQuery) {

		// create new query object
		local.qoq = new Query();
       
		// set attribute of new query object to be result of first query
		// the attribute of "QoQsrcTable" is arbortrary.  It can be anything you want.
		local.qoq.setAttributes(QoQSearchTable = Arguments.SearchQuery);
       
		// use previously set attribute as table name for QoQ and set dbtype = query
		var SQL = smartSearch(LCase(arguments.keyword), 'name', 'OR');
		local.qry2Result = local.qoq.execute(sql="SELECT * FROM QoQSearchTable WHERE #SQL# ", dbtype="query");
       //SELECT * FROM QoQSearchTable WHERE PreserveSingleQuotes( smartSearch(#arguments.keyword#, 'name', 'OR') )
		// return result
        return local.qry2Result.getResult();
	}


	private string function hrefsToList(inputString) {
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
			} else {
				break;
			}
    	}
	    return linkList;
	}


	private string function tagStripper(str) {
		var i = 1;
		var action = 'strip';
		var tagList = '';
		var tag = '';

		if(ArrayLen(arguments) gt 1 and lcase(arguments[2]) eq 'preserve') {
			action = 'preserve';
		}
		if(ArrayLen(arguments) gt 2) tagList = arguments[3];

		if(trim(lcase(action)) eq "preserve") {
			for(i=1;i lte listlen(tagList); i = i + 1) {
				tag = listGetAt(tagList,i);
				str = REReplaceNoCase(str,"</?#tag#.*?>","","ALL");
			}
		} else {
			if(tagList neq "") {
				for (i=1;i lte listlen(tagList); i = i + 1) {
					tag = listGetAt(tagList,i);
					str = REReplaceNoCase(str,"<(/?#tag#.*?)>","___TEMP___NOSTRIP___\1___TEMP___ENDNOSTRIP___","ALL");
				}
			}
			str = reReplaceNoCase(str,"</{0,1}[A-Z].*?>","","ALL");
			str = replace(str,"___TEMP___NOSTRIP___","<","ALL");
			str = replace(str,"___TEMP___ENDNOSTRIP___",">","ALL");
		}
		return str;    
	}

	private string function smartSearch(searchterm, field) {
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
	
		if(ArrayLen(arguments) GTE 3) {
			arguments.booloperator = arguments[3];
		}
		arguments.searchterm = trim(arguments.searchterm);
		bracketPoint = Find("(", arguments.searchterm);
		while(bracketPoint IS NOT 0) {
			startBracketCount = startBracketCount + 1;
			bracketPoint = Find("(", arguments.searchterm, bracketPoint + 1);
		}
		
		bracketPoint = Find(")", arguments.searchterm);
		while(bracketPoint IS NOT 0) {
			endBracketCount = endBracketCount + 1;
			bracketPoint = Find(")", arguments.searchterm, bracketPoint + 1);
		}
		
		if(startBracketCount IS NOT endBracketCount) {
			arguments.searchterm = Replace(arguments.searchterm, "(", "", "ALL");
			arguments.searchterm = Replace(arguments.searchterm, ")", "", "ALL");
		}
	
		if(arguments.booloperator IS "EXACT") {
			for(fieldcount = 1; fieldcount LTE ListLen(arguments.field); fieldcount = fieldcount + 1) {
				if(fieldcount IS 1) {
					searchstring = searchstring & "(";
				} else {
					searchstring = searchstring & " OR ";
				}
				currentfield = ListGetAt(arguments.field, fieldcount);
				searchstring = searchstring & "(" & currentfield & " Like '%" & arguments.searchterm & "%')";
			}
		
			if(Len(searchstring) GT 0) {
				searchstring = searchstring & ")";
			}
		} else {
			searchtermflag = 1;
			counter = 1;
			numchars = 0;
			prevboolterm = '';
			while(counter LTE Len(arguments.searchterm)) {
				if(counter IS Len(arguments.searchterm)) {
					searchportion = Len(arguments.searchterm);
				} else {
					searchportion = Find(" ", Right(arguments.searchterm, Len(arguments.searchterm) - counter));
					if(Find("(", Mid(arguments.searchterm, counter, searchportion)) IS 1 AND Find('"', Mid(arguments.searchterm, counter, searchportion)) IS 2) {
						attributes.searchterm = RemoveChars(arguments.searchterm, counter + 1, 1);
						searchportion = searchportion - 1;
						searchportion = Find('"', Mid(arguments.searchterm, counter, Len(arguments.searchterm))) - 1;
						arguments.searchterm = RemoveChars(arguments.searchterm, counter + searchportion, 1);
						if(Mid(arguments.searchterm, counter + searchportion, 1) IS ")") {
							searchportion = searchportion + 1;
						}
					}
					if(Find('"', Mid(arguments.searchterm, counter, searchportion)) IS 1) {
						counter = counter + 1;
						temp = 1;
						searchportion = Find('"', Mid(arguments.searchterm, counter, Len(arguments.searchterm))) - 1;
						arguments.searchterm = RemoveChars(arguments.searchterm, counter + searchportion, 1);
						if(Mid(arguments.searchterm, counter + searchportion, 1) IS ")") {
							searchportion = searchportion + 1;
						}
					}
				
					if(searchportion IS 0) {
						searchportion = Len(arguments.searchterm);
					}
				}
				if((Mid(arguments.searchterm, counter, searchportion) IS "OR" OR Mid(arguments.searchterm,counter,searchportion) IS "AND" OR Mid(arguments.searchterm, counter, searchportion) IS "NOT") AND counter IS NOT 1 AND searchportion IS NOT Len(arguments.searchterm)) {
					if((prevboolterm IS NOT "AND" AND prevboolterm IS NOT "OR") AND Mid(arguments.searchterm, counter,searchportion) IS "NOT") {
						searchstring = searchstring & " AND " & Mid(arguments.searchterm, counter, searchportion) & " ";
					} else {
						searchstring = searchstring & " " & Mid(arguments.searchterm, counter, searchportion) & " ";
					}
					prevboolterm = Mid(arguments.searchterm, counter, searchportion);
					searchtermflag = 1;
				} else {
					for(fieldcount = 1; fieldcount LTE ListLen(arguments.field); fieldcount = fieldcount + 1) {
						currentfield = ListGetAt(arguments.field, fieldcount);
						if(searchtermflag LTE 0) {
							if(fieldcount GT 1) {
								searchstring = searchstring & " OR ";
							} else {
								searchstring = searchstring & " " & arguments.booloperator & " ";
							}
						}
						if(fieldcount IS 1) {
							searchstring = searchstring & "(";
						}
						thisSearchTerm = Replace(Mid(arguments.searchterm, counter, searchportion), "'", "''", "ALL");
						startBrackets = "";
						endBrackets = "";
						bracketPoint = Find("(", thisSearchTerm);
						while(bracketPoint IS NOT 0) {
							startBrackets = startBrackets & "(";
							bracketPoint = Find("(", thisSearchTerm, bracketPoint + 1);
						}
						bracketPoint = Find(")", thisSearchTerm);
						while(bracketPoint IS NOT 0) {
							endBrackets = endBrackets & ")";
							bracketPoint = Find(")", thisSearchTerm, bracketPoint + 1);
						}
						thisSearchTerm = Replace(thisSearchTerm, "(", "", "ALL");
						thisSearchTerm = Replace(thisSearchTerm, ")", "", "ALL");
						searchstring = searchstring & startBrackets & "(" & currentfield & " LIKE '%" & thisSearchTerm & "%')" & endBrackets;
						searchtermflag = searchtermflag - 1;
						prevboolterm = "";
					}
				}
			
				if(searchtermflag LTE 0) {
					searchstring = searchstring & ")";
				}
			
				counter = counter + searchportion + 1;
			}
		}
		return searchstring;
	}





	
} 