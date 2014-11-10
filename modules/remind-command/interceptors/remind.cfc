/*-----------------------------------------------------------------------
********************************************************************************

Author      :   Don Quist
Description :   Interceptor for the Hello command module
    
-----------------------------------------------------------------------*/
component hint="Interceptor for Hello command module" output="false" extends="coldbox.system.Interceptor" {


	property name="ReminderService" inject="id:ReminderService@GimpyReminder";
	
	property name="SessionStorage" inject="id:SessionStorage";
	
	property name="Logger" inject="logbox:logger:{this}";

    public void function configure() {
    	//variables.moduleMapping = arguments.moduleMapping;
    }


    public void function onRemind( required Any event, required Struct interceptData ) {
    	Logger.debug("Command Invocation Received");
		
		var Response = event.getResponse();
		var BuddyId = Response.getBuddyId();
		var arrCmdArgs = Response.getCommandArgs();
		
		SessionStorage.setVar('Current','Remind');
		if( !SessionStorage.exists('Remind') ) {
			SessionStorage.setVar('Remind',{});
		}
		var CommandSession = SessionStorage.getVar('Remind');
		
		
		if( arrayLen(arrCmdArgs) gte 4 ) {
			if( arrCmdArgs[1] eq 'me' || arrCmdArgs[2] eq 'me' ) {
				
				var NLDate = createObject("component","#getProperty('moduleMapping')#.models.CF-NLDate.NLDate").init();
				var dateObj = NLDate.parse( arrCmdArgs[2] & ' ' & arrCmdArgs[3] & ' ' & arrCmdArgs[4]);
				CommandSession.Date = dateFormat(dateObj,'mm/dd/yyyy');
				CommandSession.Time = timeFormat(dateObj,'medium');
				CommandSession.CurrentActionNeeded = 'details';
				arrCmdArgs = arrayNew(1);
			}
			
		}
		
		if(!StructKeyExists(CommandSession,'CurrentActionNeeded')) {
			CommandSession.CurrentActionNeeded = 'date';
		}
		
		Logger.debug(arrCmdArgs.toString());
		
		switch(CommandSession.CurrentActionNeeded) {
			case 'date': {
				if( ArrayLen(arrCmdArgs) LT 1 or !IsDate(arrCmdArgs[1]) ) {
					Response.setOutgoingMessage("wut day u want me to remind you?  (mm-dd-yy)");
					//TO-DO Session.tries++;
				} else if( IsDate(arrCmdArgs[1]) && arrCmdArgs[1] LT Now() ) {
					announceInterception('invokeSendGatewayMessage', {BuddyId:BuddyId,Message="i dun have flux capacitor =/"});
					Response.setOutgoingMessage("wut day u want me to remind you?  (mm-dd-yy)");
					//1.21 Jigawatts
				} else {
					CommandSession.Date = DateFormat(arrCmdArgs[1],'mm/dd/yyyy');
					CommandSession.CurrentActionNeeded = 'time';
					Response.setOutgoingMessage("wut time u want me to remind you?  (12:01 PM)");
				}
				break;
			}
			
			case 'time': {
				Response.setDelimiters(".");
				Response.compileCommandArgs();
				arrCmdArgs = Response.getCommandArgs();
				if( ArrayLen(arrCmdArgs) LT 1 or !IsDate(arrCmdArgs[1]) ) {
					Response.setOutgoingMessage("wut time u want me to remind you?  (12:01 PM) {remember, im in pst!})");
					// TO-DO Session.tries++;
				} else {
					CommandSession.Time = TimeFormat(arrCmdArgs[1],'full' );
					CommandSession.CurrentActionNeeded = 'details';
					Response.setOutgoingMessage("wut u want me tell u?");
				}
				break;
			}
			case 'details': {
				if( ArrayLen(arrCmdArgs) LT 1 ) {
					Response.setOutgoingMessage("wut u want me tell u?");
					// TO-DO Session.tries++;
				} else {
					CommandSession.Details = arrCmdArgs;
					
					var RemindDetails = {
						Message	= Response.getIncommingMessage(),
						BuddyID	= BuddyID,
						Date	= CommandSession.Date,
						Time	= CommandSession.Time
					};
					
					ReminderService.createReminder(argumentCollection=RemindDetails);
					Response.setOutgoingMessage("k, ill remind u!!!");

					SessionStorage.deleteVar('Remind');
					SessionStorage.setVar('Current','');
				}
				break;
			}
		}
		

		/*
		if(Session.Tries GTE 6) {
			Result.Message = 'if u want stop, just say stop';
		}	
		*/
    	
    }


}