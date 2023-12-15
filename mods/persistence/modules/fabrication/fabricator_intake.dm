//Disable the annoyance.
/obj/machinery/fabricator
	has_recycler = FALSE
/obj/machinery/fabricator/can_ingest(obj/item/thing)
	return istype(thing, /obj/item/stack/material) //Prevents the fabricators from eating things you didn't want it to eat

/obj/machinery/fabricator/attackby(obj/item/O, mob/user)
	if(user.a_intent != I_HURT)
		if(istype(O, /obj/item/stock_parts/computer/hard_drive/portable))
			var/obj/item/stock_parts/computer/hard_drive/portable/disk = O
			var/list/found_designs = add_designs(disk.stored_files)
			if(length(found_designs))
				visible_message(SPAN_NOTICE("\The [user] inserts \the [O] into \the [src], and after a second or so of loud clicking, the fabricator beeps and spits it out again."))
			else
				visible_message(SPAN_WARNING("\The [user] inserts \the [O] into \the [src], but the fabricator spits it back out after a moment, producing an error tone."))
			return

	. = ..()