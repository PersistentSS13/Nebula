SUBSYSTEM_DEF(autosave)
	name = "Autosave"
	wait = 1 MINUTE
	runlevels = RUNLEVEL_GAME

	var/saves = 0 // Number of times we've autosaved.
	var/saving = 0 // Whether or not we are saving right now.
	var/announced = 0 // Whether or not we've announced we're about to save.

	var/last_save			// world.time of the last save
	var/autosave_interval	// Time between autosaves.

/datum/controller/subsystem/autosave/Initialize()
	. = ..()
	last_save = world.time
	autosave_interval = config.autosave_interval	// To prevent saving upon start.

/datum/controller/subsystem/autosave/stat_entry()
	var/msg
	if(flags & SS_NO_FIRE || suspended || !can_fire)
		msg = "Autosave Disabled!"
	else if(saving)
		msg = "Currently Saving..."
	else
		msg = "Next Autosave in [ round(((last_save + autosave_interval) - world.time) / (1 MINUTE), 0.1)] Minutes."
	..(msg)

/datum/controller/subsystem/autosave/fire()
	AnnounceSave()
	if(last_save + autosave_interval <= world.time)
		Save()

/datum/controller/subsystem/autosave/proc/Save(var/check_for_restart = TRUE)
	if(saving)
		message_admins(SPAN_DANGER("Attempted to save while already saving!"))
	else
		saves += 1
		to_world("<font size=4 color='green'>Beginning save! Server will unpause when save is complete.</font>")

		var/reset_after_save = config.autosave_auto_reset > 0 && world.time >= config.autosave_auto_reset

	//	if(check_for_restart && reset_after_save)
	//		to_world("<font size=4 color='red'>Server is resetting after this save!</font>")

		saving = 1
		for(var/datum/controller/subsystem/S in Master.subsystems)
			S.disable()
		SSpersistence.SaveWorld()
		for(var/datum/controller/subsystem/S in Master.subsystems)
			S.enable()
		saving = 0
		to_world("<font size=4 color='green'>World save complete!</font>")
		/**
		if(check_for_restart && reset_after_save)
			to_world("<font size=4 color='red'>Server is going down NOW!</font>")
			world.Reboot()
		**/
		last_save = world.time

/datum/controller/subsystem/autosave/proc/AnnounceSave()
	var/minutes = (last_save + autosave_interval - world.time) / (1 MINUTE)

	if(!announced && minutes <= 5)
		to_world("<font size=4 color='green'>Autosave in 5 minutes!</font>")
		if((world.time + minutes MINUTES) >= config.autosave_auto_reset)
			to_world("<font size=4 color='green'>The server will reboot after this save!</font>")
		announced = 1
	if(announced == 1 && minutes <= 1)
		to_world("<font size=4 color='green'>Autosave in 1 minute!</font>")
		if((world.time + minutes MINUTES) >= config.autosave_auto_reset)
			to_world("<font size=4 color='green'>The server will reboot after this save!</font>")
		announced = 2
	if(announced == 2 && minutes >= 6)
		announced = 0