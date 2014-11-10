component extends="modules.cborm.models.VirtualEntityService" singleton {

	// for the schedule url, setup in onDIComplete
	property name="sesBaseURL" inject="coldbox:setting:sesBaseURL";
	
	// to trigger a gateway message (but still have it handled by the interceptor)
	property name="interceptorService" inject="coldbox:interceptorService";	
	
	// to create a Response object and pass it to the interception point
	property name="ResponseService" inject="id:ResponseService";
	
	
	public ReminderService function init(
		Required	String	moduleMapping,
		Required	String	entryPoint
	){
		variables.moduleMapping = arguments.moduleMapping;
		variables.entryPoint	= arguments.entryPoint;
		super.init("Reminder", "Reminder.query.cache", true );
		return this;
	}
	
	public void function onDiComplete() onDiComplete {
		var scheduleUrl = variables.sesBaseURL & '/' & variables.entryPoint & '/reminder/scheduler';
		verifyScheduler( scheduleUrl );
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
			Hour(arguments.time),
			Minute(arguments.time),
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
	
	public void function remind() {
		lock name="scheduled_reminder" type="exclusive" throwontimeout="true" timeout="15" {
			var Reminders = getReadyMessages();
			// Railo specific .each() parallel feature
			Reminders.each(function(Reminder) {
				var Response = ResponseService.createResponse();
				Response.setBuddyId( Reminder.getBuddyId() );
				Response.setOutgoingMessage( Reminder.getMessage() );

				Reminder.setTryCount( Reminder.getTryCount()+1 );
				
					interceptorService.processState(
						'invokeSendGatewayMessage',
						Reminder.toJSON()
					);
					Reminder.setSent(1);
				try {
				} catch(any e) {}
			}, true);
			
			save(Reminders,false,true);
		}
	}
	
	public void function verifyScheduler(
		Required	String	scheduleUrl
	) {
		schedule action="update" startDate="#Now()#" requesttimeout="60" startTime="#Now()#" interval=20 url=arguments.scheduleUrl task="Reminders_Task";
	}


}
