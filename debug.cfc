component output=false hint="debug" {

	public struct function queryStringToStruct(required string QueryString) {
		var struct = StructNew();
		var i = 1;
		var pairi = "";
		var keyi = "";
		var valuei = "";
		var qsarray = "";
		var qs = Arguments.QueryString; 
		if(arrayLen(arguments) GT 0) {
			qs = arguments[1];
		}

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

}

