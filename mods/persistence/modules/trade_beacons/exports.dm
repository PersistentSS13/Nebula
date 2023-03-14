
/datum/beacon_export
	var/name = "Beacon Export"
	var/list/required_items = list() // structure is list(/obj/item/example = 1, /obj/item/multi = 2) list(type = number required).
	var/cost = 1000
	var/remaining_stock = 5
	var/desc = "Export Description"
	var/obj/checked_closet
/datum/beacon_export/proc/get_cost(var/tax)
	if(!tax) return cost
	return cost-((tax/100)*cost)

/datum/beacon_export/proc/get_tax(var/tax)
	if(!tax) return 0
	return (tax/100)*cost

/datum/beacon_export/proc/takeExport()
	if(checked_closet)
		checked_closet.forceMove(null)
		qdel(checked_closet)
	checked_closet = null
	remaining_stock--
/datum/beacon_export/proc/resetExport()
	checked_closet = null


/datum/beacon_export/proc/checkExport(var/turf/L)
	if(!L) return "No valid location detected"
	var/obj/closet_found = 0
	var/valid_items = list()
	for(var/obj/structure/closet/C in L.contents)
		closet_found = C
		for(var/item_type in required_items)
			var/ind = required_items[item_type]
			if(!ind) ind = 1
			var/found = 0
			for(var/obj/o in C.contents)
				if(istype(o, item_type))
					if(isstack(o))
						var/obj/item/stack/s = o
						ind -= s.amount
						if(ind >= 0)
							valid_items |= o
					else
						ind--
						valid_items |= o
				if(ind < 0)
					return "Too many items included ([o.name]). Exact orders only."
				if(ind == 0)
					found = 1
					break
			if(!found)
				return "Incomplete Export Detected ([item_type])"
		break // only check 1, the for loop is just a convient way to search
	if(!closet_found)
		return "No container detected"
	else
		var/obj/invalid_item = 0
		for(var/obj/o in closet_found.contents)
			if(!(o in valid_items))
				invalid_item = o
				break
		if(invalid_item)
			return "Too many items included ([invalid_item.name]). Exact orders only."
		checked_closet = closet_found
		return // SUCCESS


/////////////////////////////////////////

/datum/beacon_export/example
	required_items = list(/obj/item/stack/cable_coil = 10, /obj/item/plunger = 2)
	name = "Example Export"
	desc = "This is a debug export to test sending stacked items and multiple single items. It requires a ten stack of cable coil and two plungers to complete."
	cost = 500

/datum/beacon_export/xanaducrystal
	required_items = list(/obj/item/plunger = 1)
	name = "Xanadu Crystal"
	desc = "The rare Xanadu Crystal is much prized across the Galaxy."
	cost = 5000