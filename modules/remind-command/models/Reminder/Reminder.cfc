component table="reminder" persistent=true accessors=true {

	property name="id" column="reminder_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	property
		name="buddyid"
		index="buddyid"
		ormtype="string"
		type="string"
		length="170";
	
	property
		name="sendon"
		ormtype="timestamp"
		type="date";
	
	property
		name="message"
		ormtype="string"
		type="string"
		length="9999"; // hacky to force longtext (mysql)

	property
		name="sent"
		ormtype="boolean"
		type="boolean"
		default="false";
	
	property
		name="trycount"
		ormtype="integer"  
		type="numeric"  
		default="1";

	property
		name="created"
		index="created"
		ormtype="timestamp"
		type="date";
	
	property
		name="updated"
		index="updated"
		ormtype="timestamp"
		type="date";
	

	
	public struct function toJSON() {
		var d = {};
		d['id']					= getID();
		d['buddyid']			= getBuddyID();
		d['message']			= getMessage();
		d['sent']				= getSent();
		d['sendon']				= dateTimeFormat(getSendOn(),"yyyy-mm-dd'T'HH:nn:ss");
		d['created']			= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']			= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}

	public void function setMessage(Required String input) { variables.message = trim(arguments.input); }
	public void function setBuddyID(Required String input) { variables.buddyid = trim(arguments.input); }


	public void function preUpdate() {
		setUpdated(Now());
	}
	public void function preInsert() {
		setCreated(Now());
		setUpdated(Now());
	}

}