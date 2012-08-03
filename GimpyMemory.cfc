component output=false {
/*
	This is Gimpy's Memory, its very gimp.
	Memory is stored as Keys.
	Most of the time, we're trying to remember greetings, names, tasks, etc for each 'Buddy',
	so, each Key or 'BuddyID', will have those under it.  Other, more generic terms, are again, Keys.
*/
	
	public GimpyMemory function init() {
		variables.Keys = {};
		LoadKeys();
		return This;
	}

	public void function SetTerm(required string Key, required string Term, required any Value) {
		if( IsSimpleValue(Arguments.Value) && Arguments.Value contains "&" && Arguments.Value contains "=") {
			Arguments.Value = queryStringToStruct(Arguments.Value);
		}
		variables.keys[Arguments.Key][Arguments.Term] = Arguments.Value;
		SaveKeys();
	}
	public any function GetTerm(required string Key, required string Term) {
		if( StructKeyExists(variables.keys,arguments.key) and StructKeyExists(variables.keys[arguments.key],arguments.Term) ) {
			return variables.keys[arguments.key][arguments.Term];
		}
		return '';
	}
	public boolean function TermExists(required string Key, required string Term) {
		if(!KeyExists(arguments.Key)) {
			return false;
		}
		return StructKeyExists(variables.keys[arguments.Key], arguments.Term);
	}
	public void function RemoveTerm(required string Key, required string Term) {
		if(TermExists(arguments.Key,arguments.Term)) {
			StructDelete(variables.keys[arguments.Key],arguments.Term,false);
		}
		SaveKeys();
	}
	public boolean function KeyExists(required string Key) {
		return StructKeyExists(variables.keys,arguments.Key);
	}
	public void function RemoveKey(required string Key) {
		if(KeyExists(arguments.Key)) {
			StructDelete(variables.keys,arguments.Key);
		}
		SaveKeys();
	}


	public void function Snapshot() {
		var json = getKeys( true );
		FileWrite(ExpandPath('./snapshots/GimpyMemory_#DateFormat(now(),'mm-dd-yy')#_#TimeFormat(now(),'hh-m-s')#.json'),json);
	}



	public any function getKeys(boolean json=false){
		if(arguments.json) {
			return SerializeJSON(variables.Keys);
		}
		return variables.Keys;
	}




	private struct function queryStringToStruct(required string QueryString) {
		var struct = StructNew();
		var i = 1;
		var pairi = "";
		var keyi = "";
		var valuei = "";
		var qsarray = "";
		var qs = Arguments.QueryString;

		qsarray = listToArray(qs, "&");
		for(i=1;i LTE ArrayLen(qsarray);i++){
			pairi = qsarray[i];
			keyi = listFirst(pairi,"=");
			valuei = urlDecode(listLast(pairi,"="));
			if(structKeyExists(struct,keyi)) {
				struct[keyi] = listAppend(struct[keyi],valuei);
			} else {
				StructInsert(struct,keyi,valuei);
			}
		}
		return struct;
	}

	private void function SaveKeys() {
		var json = SerializeJSON( variables.keys );
		FileWrite(ExpandPath('GimpyMemory.json'),json);
	}
	private void function LoadKeys() {
		try{
			var json = FileRead(ExpandPath('GimpyMemory.json'));
			variables.keys = DeSerializeJSON(json);
		} catch(any error) {
			FileWrite(ExpandPath('GimpyMemory.json'),'{}');
		}
		var json = FileRead(ExpandPath('GimpyMemory.json'));
		variables.keys = DeSerializeJSON(json);
	}

}