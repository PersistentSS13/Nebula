//If we got a roundstart datum/seed (AKA a seed defined in the code), don't save it
#define SAVE_SEED(SEEDVAR) if(SEEDVAR && !SEEDVAR.roundstart){CUSTOM_SV("saved_seed", SEEDVAR);}
#define SAVE_SEED_OR_SEEDNAME(SEEDVAR) if(SEEDVAR){if(!SEEDVAR.roundstart){CUSTOM_SV("saved_seed", SEEDVAR);}else{CUSTOM_SV("saved_seed_name", SEEDVAR.name);}}

#define REGISTER_LOADED_SEED(SEEDVAR) \
	if(SEEDVAR){ \
		SSplants.seeds[SEEDVAR.name] = SEEDVAR;\
	}

//Attempts loading the saved_seed first. If it fails, loads the saved_seed_name. 
// Then if all fails and we already have a seed, register the seed if valid
#define LOAD_SAVED_SEED_OR_SEEDNAME(SEEDVAR)\
	var/datum/seed/saved_seed = LOAD_CUSTOM_SV("saved_seed"); \
	if(saved_seed){ \
		SEEDVAR = saved_seed; \
		REGISTER_LOADED_SEED(SEEDVAR); \
	} \
	else { \
		var/sname = LOAD_CUSTOM_SV("saved_seed_name"); \
		var/datum/seed/SE = SSplants.seeds[sname]; \
		if(SE) { SEEDVAR = SE; } \
		else if(SEEDVAR) {REGISTER_LOADED_SEED(SEEDVAR);} \
	}

//If the seed is a roundstart seed it'll get automatically setup using the seed_type in the initialize proc!
#define LOAD_SAVED_SEED(SEEDVAR, SEEDNAMEVAR) LOAD_SAVED_SEED_OR_SEEDNAME(SEEDVAR);\
	if(!saved_seed && !SEEDNAMEVAR) { log_debug("[src.type]/after_deserialize(): '[src]' is missing both a seed and a seed name after deserialization!"); }
