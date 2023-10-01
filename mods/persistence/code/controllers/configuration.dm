/datum/configuration
	var/autosave_interval     = 2 HOURS
	var/autosave_auto_restart = 12 HOURS
	var/save_error_tolerance  = PERSISTENCE_ERROR_TOLERANCE_NONE

/datum/configuration/load_mod_config(name, value)
	. = ..()
	switch(name)
		if("autosave_interval")
			autosave_interval = text2num(value) MINUTES
			. = TRUE
		if("autosave_auto_restart")
			autosave_auto_restart = text2num(value) HOURS
			. =  TRUE
		if("save_error_tolerance")
			value = lowertext(value)
			switch(value)
				if("any")
					save_error_tolerance = PERSISTENCE_ERROR_TOLERANCE_ANY
				if("recoverable")
					save_error_tolerance = PERSISTENCE_ERROR_TOLERANCE_RECOVERABLE
				if("none")
					save_error_tolerance = PERSISTENCE_ERROR_TOLERANCE_NONE
				else
					log_misc("Bad value for '[name]' : '[value]'! (Expected 'any', 'recoverable' or 'none')")
			. =  TRUE

///Hook to add persistence settings meant to be in the game_options file if any.
/datum/configuration/load_mod_game_options(name, value)
	. = ..()

///Hook to add persistence settings meant to be in the dbconfig file if any.
/datum/configuration/load_mod_dbconfig(name, value)
	. = ..()