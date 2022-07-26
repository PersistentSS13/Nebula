/obj/machinery/power/smes/Initialize(ml)
	if(persistent_id)
		CUSTOM_SV_LIST(\
		"last_charge"         = charge,\
		"last_input_level"    = input_level,\
		"last_output_level"   = output_level,\
		"last_output_attempt" = output_attempt,\
		"last_input_attempt"  = input_attempt,\
		)
	. = ..()
	if(persistent_id)
		charge         = LOAD_CUSTOM_SV("last_charge")
		input_level    = LOAD_CUSTOM_SV("last_input_level")
		output_level   = LOAD_CUSTOM_SV("last_output_level")
		output_attempt = LOAD_CUSTOM_SV("last_output_attempt")
		input_attempt  = LOAD_CUSTOM_SV("last_input_attempt")
		CLEAR_SV("last_charge")
		CLEAR_SV("last_input_level")
		CLEAR_SV("last_output_level")
		CLEAR_SV("last_output_attempt")
		CLEAR_SV("last_input_attempt")
	update_icon()

//Saved Variables Define
SAVED_VAR(/obj/machinery/power/smes/batteryrack, mode)
SAVED_VAR(/obj/machinery/power/smes/batteryrack, internal_cells)

SAVED_VAR(/obj/machinery/power/smes, capacity)
SAVED_VAR(/obj/machinery/power/smes, charge)
SAVED_VAR(/obj/machinery/power/smes, input_attempt)
SAVED_VAR(/obj/machinery/power/smes, input_level)
SAVED_VAR(/obj/machinery/power/smes, output_attempt)
SAVED_VAR(/obj/machinery/power/smes, output_level)
SAVED_VAR(/obj/machinery/power/smes, should_be_mapped)
SAVED_VAR(/obj/machinery/power/smes, input_cut)
SAVED_VAR(/obj/machinery/power/smes, output_cut)
SAVED_VAR(/obj/machinery/power/smes, failure_timer)
SAVED_VAR(/obj/machinery/power/smes, name_tag)

SAVED_VAR(/obj/machinery/power/smes/buildable, safeties_enabled)
SAVED_VAR(/obj/machinery/power/smes/buildable, failing)
SAVED_VAR(/obj/machinery/power/smes/buildable, grounding)
SAVED_VAR(/obj/machinery/power/smes/buildable, RCon)
SAVED_VAR(/obj/machinery/power/smes/buildable, RCon_tag)