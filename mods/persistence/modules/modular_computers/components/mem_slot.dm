/obj/item/stock_parts/computer/mem_slot
	name = "Memory Slot"
	desc = "Slot that allows this computer to write data on memory cards. Necessary for some programs to run properly."
	power_usage = 10 //W
	critical = 0
	icon_state = "memreader"
	hardware_size = 1
	origin_tech = "{'programming':2}"
	usage_flags = PROGRAM_ALL & ~PROGRAM_PDA
	external_slot = TRUE
	material = /decl/material/solid/metal/steel

	var/can_write = TRUE
	var/can_broadcast = FALSE
	var/obj/item/memory/stored_memory = null

	var/datum/computer_file/program/reader/driver_type = /datum/computer_file/program/reader		// A program type that the scanner interfaces with and attempts to install on insertion.
	var/datum/computer_file/program/reader/driver		 		// A driver program which has been set up to interface with the scanner.
	var/can_run_scan = 1	//Whether scans can be run from the program directly.
	var/can_view_scan = 1	//Whether the scan output can be viewed in the program.
	var/can_save_scan = 1	//Whether the scan output can be saved to disk.

/obj/item/stock_parts/computer/mem_slot/Destroy()
	do_before_uninstall()
	. = ..()

/obj/item/stock_parts/computer/mem_slot/proc/do_after_install(user, atom/device)
	var/datum/extension/interactive/ntos/os = get_extension(device, /datum/extension/interactive/ntos)
	if(!driver_type || !device || !os)
		return 0
	if(!os.has_component(PART_HDD))
		to_chat(user, "Driver installation for \the [src] failed: \the [device] lacks a hard drive.")
		return 0
	var/datum/computer_file/program/reader/old_driver = os.get_file(initial(driver_type.filename))
	if(istype(old_driver))
		to_chat(user, "Drivers found on \the [device]; \the [src] has been installed.")
		old_driver.connect_reader()
		return 1
	var/datum/computer_file/program/reader/driver_file = new driver_type
	if(!os.store_file(driver_file))
		to_chat(user, "Driver installation for \the [src] failed: file could not be written to the hard drive.")
		return 0
	to_chat(user, "Driver software for \the [src] has been installed on \the [device].")
	driver_file.computer = os
	driver_file.connect_reader()
	return 1

/obj/item/stock_parts/computer/mem_slot/proc/do_before_uninstall()
	if(driver)
		driver.disconnect_reader()
	if(driver)	//In case the driver doesn't find it.
		driver = null

/obj/item/stock_parts/computer/mem_slot/proc/run_scan(mob/user, datum/computer_file/program/reader/program) //For scans done from the software.

/obj/item/stock_parts/computer/mem_slot/proc/do_on_afterattack(mob/user, atom/target, proximity)

/obj/item/stock_parts/computer/mem_slot/attackby(obj/W, mob/living/user)
	do_on_attackby(user, W)

/obj/item/stock_parts/computer/mem_slot/proc/do_on_attackby(mob/user, atom/target)

/obj/item/stock_parts/computer/mem_slot/proc/can_use_reader(mob/user, atom/target, proximity = TRUE)
	if(!check_functionality())
		return 0
	if(user.incapacitated())
		return 0
	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS))
		return 0
	if(!proximity)
		return 0
	return 1


/obj/item/stock_parts/computer/mem_slot/proc/verb_eject_memory()
	set name = "Remove Memory"
	set category = "Object"
	set src in view(1)

	if(!CanPhysicallyInteract(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	var/obj/item/stock_parts/computer/mem_slot/device = src
	if (!istype(device))
		device = locate() in src

	if(!device.stored_memory)
		if(usr)
			to_chat(usr, "There is no memory in \the [src]")
		return

	device.eject_memory(usr)

/obj/item/stock_parts/computer/mem_slot/proc/eject_memory(mob/user)
	if(!stored_memory)
		return FALSE

	if(user)
		to_chat(user, "You remove [stored_memory] from [src].")
		user.put_in_hands(stored_memory)
	else
		dropInto(loc)
	stored_memory = null

	var/datum/extension/interactive/ntos/os = get_extension(loc, /datum/extension/interactive/ntos)
	if(os)
		os.event_idremoved()
	loc.verbs -= /obj/item/stock_parts/computer/mem_slot/proc/verb_eject_memory
	return TRUE

/obj/item/stock_parts/computer/mem_slot/proc/insert_memory(var/obj/item/memory/M, mob/user)
	if(!istype(M))
		return FALSE

	if(stored_memory)
		to_chat(user, "You try to insert [M] into [src], but its memory slot is occupied.")
		return FALSE

	if(user && !user.unEquip(M, src))
		return FALSE

	stored_memory = M
	to_chat(user, "You insert [M] into [src].")
	if(isobj(loc))
		loc.verbs |= /obj/item/stock_parts/computer/mem_slot/proc/verb_eject_memory
	return TRUE

/obj/item/stock_parts/computer/mem_slot/attackby(obj/item/memory/M, mob/living/user)
	if(!istype(M))
		return ..()
	insert_memory(M, user)
	return TRUE


/obj/item/stock_parts/computer/mem_slot/Destroy()
	if(loc)
		loc.verbs -= /obj/item/stock_parts/computer/mem_slot/proc/verb_eject_memory
	if(stored_memory)
		QDEL_NULL(stored_memory)
	return ..()

/obj/item/stock_parts/computer/mem_slot/can_use_reader(mob/user, obj/item/memory/M, proximity = TRUE)
	if(!..())
		return 0
	if(!istype(M))
		return 0
	return 1

/obj/item/stock_parts/computer/mem_slot/do_on_afterattack(mob/user, obj/item/memory/M, proximity)
	if(!driver || !driver.using_reader)
		return
	if(!can_use_reader(user, M, proximity))
		return
	var/data = html2pencode(M.storedinfo)
	if(!data)
		return
	if(M.metadata)
		driver.metadata_buffer = M.storedinfo.Copy()
	driver.paper_type = /obj/item/paper

	driver.scan_file_type = /datum/computer_file/data/text

	driver.data_buffer = data

	to_chat(user, "You scan \the [M] with [src].")
	SSnano.update_uis(driver.NM)

/obj/item/stock_parts/computer/mem_slot/do_on_attackby(mob/user, atom/target)
	do_on_afterattack(user, target, TRUE)