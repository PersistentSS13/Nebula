SUBSYSTEM_DEF(autosave)
	name = "Autosave"
	wait = 1 MINUTE
	runlevels = RUNLEVEL_GAME

	var/saves = 0 // Number of times we've autosaved.
	var/saving = 0 // Whether or not we are saving right now.
	var/announced = 0 // Whether or not we've announced we're about to save.

	var/last_save			// world.time of the last save
	var/autosave_interval	// Time between autosaves.

/datum/controller/subsystem/autosave/Initialize(start_timeofday)
	. = ..()
	last_save         = world.time
	autosave_interval = config.autosave_interval	// To prevent saving upon start.

/datum/controller/subsystem/autosave/stat_entry()
	var/msg
	if(flags & SS_NO_FIRE || suspended || !can_fire)
		msg = "Autosave Disabled!"
	else if(saving)
		msg = "Currently Saving..."
	else
		msg = "Next Autosave in [round(((last_save + autosave_interval) - world.time) / (1 MINUTE), 0.1)] Minutes."
	..(msg)

/datum/controller/subsystem/autosave/fire()
	AnnounceSave()
	if((last_save + autosave_interval) <= world.time)
		Save()

/datum/controller/subsystem/autosave/proc/Save(var/check_for_restart = TRUE)
	if(saving)
		message_admins(SPAN_DANGER("Attempted autosave while already making an autosave!"))
		return
	var/exception/last_except = null
	var/restart_after_save      = (config.autosave_auto_restart > 0) && (world.time >= config.autosave_auto_restart)
	saves  += 1
	saving = TRUE

	try
		//Announce saving start!
		to_world(SPAN_AUTOSAVE("Beginning autosave! Server will pause until complete."))
		if(check_for_restart && restart_after_save)
			to_world(SPAN_AUTOSAVE_WARN("Server is restarting after this autosave!"))
		sleep(5)

		//Begin actual save
		SSpersistence.SaveWorld(name)

	catch(var/exception/e)
		//Prevent exception going upwards the stack if we fail, so we don't keep saving over and over, and don't break saving afterwards
		log_warning("datum/controller/subsystem/autosave/proc/Save() was interrupted by an exception!")
		last_except = e

	//Set the next save timer + indicate we're done saving
	saving    = FALSE
	last_save = world.time

	//Before telling the user we've had success throw any exceptions we've hit
	if(!isnull(last_except))
		throw last_except //Kick us out after we've cleaned up our state and report the exception.

	//Otherwise, everything is going fine
	to_world(SPAN_AUTOSAVE("Autosave complete!"))

	if(check_for_restart && restart_after_save)
		to_world(SPAN_AUTOSAVE_WARN("Server is going down NOW!"))
		sleep(1 SECOND)
		world.Reboot()

/datum/controller/subsystem/autosave/proc/AnnounceSave()
	var/minutes_left = (last_save + autosave_interval - world.time) / (1 MINUTE)

	if(!announced && minutes_left <= 5)
		to_world(SPAN_AUTOSAVE("Autosave in 5 minutes!"))
		if((world.time + minutes_left MINUTES) >= config.autosave_auto_restart)
			to_world(SPAN_AUTOSAVE("The server will reboot after this save!"))
		announced = 1
	if(announced == 1 && minutes_left <= 1)
		to_world(SPAN_AUTOSAVE("Autosave in 1 minute!"))
		if((world.time + minutes_left MINUTES) >= config.autosave_auto_restart)
			to_world(SPAN_AUTOSAVE("The server will reboot after this save!"))
		announced = 2
	if(announced == 2 && minutes_left >= 6)
		announced = 0

///Adds the given amount of time to the next autosave timer.
/datum/controller/subsystem/autosave/proc/DelayNextSave(var/delay)
	//Prevent bad things from happening if we somehow trigger another save at the same time
	if(saving)
		CRASH("Cannot change the time to next save while we're currently saving!")
	last_save += delay