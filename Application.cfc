component output=false hint="Sets up the application and defines top level event handlers" {

	THIS.Name = "Gimpy";
	THIS.ApplicationTimeout = CreateTimeSpan( 30, 0, 0, 0 );
	THIS.SessionManagement = true;
	THIS.SetClientCookies = true;
	THIS.SessionTimeout = CreateTimeSpan(0,0,0,30);

	this.mappings["/cfgimpy"] = ExpandPath('/');
 
	this.ormenabled = "true";
	this.datasource = "cfgimpy";
	this.ormsettings = {
		skipCFCWithError = false,
		autorebuild=true,
		dialect="org.hibernate.dialect.MySQL5InnoDBDialect",
		dbcreate="update",
		logSQL = true,
		flushAtRequestEnd = false,
		autoManageSession = false,
		eventHandling = true,
		eventHandler = "model.ORMEventHandler",
		cfclocation="/model"
	};
	//this.ormsettings.secondarycacheenabled = true;

	public boolean function OnApplicationStart() {
		Application.ReminderService = new model.Reminder.ReminderService(
			entityName	= 'Reminder',
			scheduleUrl	= 'https://gimpy.sigmaprojects.org/commands/remind.cfc?method=Remind'
			
		); 
		return true;
	}
	
	public boolean function OnRequestStart(Required String Page) {
		if(structKeyExists(URL,'fwreinit')) { applicationStop(); };
		if(structKeyExists(url,'ormreload')) { ORMReload();}
		return true;
	}

	/*
	public void function OnRequest(Required String Page) {
		return;
	}
	*/	

	public void function OnRequestEnd(Required String Page) {
		return;
	}
	
	public void function OnSessionStart() {
		return;
	}
	
	public void function OnSessionEnd(Required SessionScope, Required ApplicationScope) {
		return;
	}
	
}