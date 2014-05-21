component output="false" {

	
	public ReminderService function init(
		Required	String	entityName,
		Required	String	scheduleUrl
	){
		variables.entityName = trim(arguments.entityName);
		verifyScheduler( trim(arguments.scheduleUrl) );
		return this;
	}

	public any function get(Required Numeric Id) {
		return entityLoadByPK(variables.entityName,arguments.Id);
	}

	public array function getReadyMessages() {
		var q = new Query();
		var sql = "
			SELECT r.reminder_id
			FROM reminder r
			WHERE r.sendon < NOW()
			AND r.sent = false
			AND r.trycount < 11
		";
		q.setSQL(sql);
		var r = q.execute().getResult();
		var Reminders = [];
		r.each(function(item){
			arrayAppend(Reminders,get(item.reminder_id));
		});
		return Reminders;
	}

	public Reminder function new() {
		return EntityNew(variables.entityName);
	}
	
	public Reminder function createReminder(
		Required	String		buddyId,
		Required	String		message,
		Required	Date		date,
		Required	Date		time
	) {
		var Reminder = this.new();
		Reminder.setBuddyid(arguments.buddyId);
		Reminder.setMessage(arguments.message);
		var sendOn = CreateDateTime(
			Year(arguments.date),
			Month(arguments.date),
			Day(arguments.date),
			Hour(arguments.date),
			Minute(arguments.date),
			1
		);
		Reminder.setSendOn(sendOn);
		this.save(Reminder,true);
		return Reminder;
	}
	
	public void function save(
		Required	Any			Reminder,
					Boolean		reload		= false,
					Boolean		flush		= false
	) {
		
		if( isArray(arguments.Reminder) ) {
			var Reminders = arguments.Reminder;
		} else {
			var Reminders = [];
			arrayAppend(Reminders,arguments.Reminder);
		}
		for(var R in Reminders) {
			R.setUpdated( Now() );
			if( IsNull(R.getCreated()) || !isDate(R.getCreated()) ) {
				R.setCreated( Now() );
			}
		
			EntitySave( R );

			if( arguments.reload ) {
				EntityReload( R );
			}
		}
		if( arguments.flush ) {
			ORMFlush();
		}
	}
	
	
	public void function verifyScheduler(
		Required	String	scheduleUrl
	) {
		schedule action="update" startDate="#Now()#" startTime="#Now()#" interval=20 url=arguments.scheduleUrl task="Reminders_Task";
	}


}
