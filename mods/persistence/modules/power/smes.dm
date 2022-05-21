/obj/machinery/power/smes/populate_parts(full_populate)
	if(persistent_id)
		return
	return ..()

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