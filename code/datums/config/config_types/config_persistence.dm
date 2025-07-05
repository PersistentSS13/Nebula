/decl/configuration_category/serialization
	name = "Serialization"
	desc = "Configuration options relating to serialization and autosave."
	associated_configuration = list(
		/decl/config/num/autosave_interval,
		/decl/config/num/autosave_auto_restart,
		/decl/config/enum/save_error_tolerance,
	)

/decl/config/num/autosave_interval
	uid           = "autosave_interval"
	desc          = "Time in deciseconds between automated world saves. Default is every 120 minutes (72,000 deciseconds)."
	default_value = 2 HOURS

/decl/config/num/autosave_auto_restart
	uid           = "autosave_auto_restart"
	desc          = "Uptime in deciseconds after which the next autosave will force a server reboot. Default is 12 Hours (432,000 deciseconds). Setting to 0 disables it."
	default_value = 12 HOURS

/decl/config/enum/save_error_tolerance
	uid           = "save_error_tolerance"
	desc          = "Set what kind of errors will be skipped over during saving/loading if encountered. Default is \"NONE\". This value is meant to be used for rescuing a broken save, or forcing a broken save to work. As it will most likely cause problems if used constantly. The possible values are: \"NONE\"->No errors allowed at all, \"RECOVERABLE\"->Only recoverable errors allowed, \"ANY\"->Any error, even connection error will be ignored."
	default_value = PERSISTENCE_ERROR_TOLERANCE_NONE
	enum_map      = list(
		"none"        = PERSISTENCE_ERROR_TOLERANCE_NONE,
		"any"         = PERSISTENCE_ERROR_TOLERANCE_ANY,
		"recoverable" = PERSISTENCE_ERROR_TOLERANCE_RECOVERABLE,
	)
