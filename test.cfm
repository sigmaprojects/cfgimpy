<cfscript>
	writedump(application);
	abort;
	Commands = DirectoryList(expandPath('/commands'));
	for(Command in Commands) {
		
		file = listLast(Command,'/',false);
		if( file eq 'hello.cfc') {
		//obj = createObject('component','gimpy.commands.' & command)
		obj = createObject('component','gimpy.commands.' & replaceNoCase(file,'.cfc','','all') );
		
		
		writedump( getMetaData(obj) );
		abort;
		}
	}
	writedump(commands);
	abort;
	Application.GimpyMemory = new GimpyMemory();
	/*
	GM = new GimpyMemory();
	
	writedump(GM.getKeys());
	abort;
	*/
	try {
	a = cacheGet('Gimpy');
	writedump(a);
	} catch(any e) {
		writeoutput('failed to display cache');
	}
	
	try {
		writedump(application.gimpymemory.getkeys());
	} catch(any e) {
		
	}
	
	writedump(application);
	
	/*
	abort;
	cachePut('testing','weeeeeeeeeeee');
	p = cacheGet('testing');
	writedump(p);
	
	keys = cacheGetAllIDs();
	writedump(keys);
	*/
</cfscript>