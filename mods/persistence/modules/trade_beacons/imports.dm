/datum/beacon_import
	var/name = "Beacon Import"
	var/list/provided_items = list() // structure is list(/obj/item/example = 1, /obj/item/multi = 2) list(type = number provided).
	var/container_type = /obj/structure/closet/crate
	var/cost = 1000
	var/remaining_stock = 5 // how many are left to buy this cycle
	var/desc = "Import Desription"

/datum/beacon_import/proc/get_cost(var/tax)
	if(!tax) return cost
	return cost+((tax/100)*cost)

/datum/beacon_import/proc/get_tax(var/tax)
	if(!tax) return 0
	return (tax/100)*cost

/datum/beacon_import/proc/checkImport(var/turf/L)
	if(!L) return "Invalid telepad."
	for(var/obj/i in L.contents)
		if(!istype(i, /obj/machinery)) // machines are ok
			return "Telepad obstructed"
/datum/beacon_import/proc/spawnImport(var/turf/L)
	if(!L) return
	var/obj/structure/container = new container_type(L)
	for(var/item_type in provided_items)
		var/ind = provided_items[item_type]
		if(!ind) ind = 1
		var/obj/item/stack/stacking = 0
		for(var/i=1;i<=ind;i++)
			if(stacking)
				stacking.add(1)
			else
				var/obj/o = new item_type(container)
				if(isstack(o))
					stacking = o
	remaining_stock--


//////////////////////////////////////////////////////////////////

/datum/beacon_import/steel
	provided_items = list(/obj/item/stack/material/sheet/mapped/steel = 50)
	name = "Steel (50 Sheets)"
	cost = 500
	desc = "A stack of fifty steel sheets. Fifty sheets of grey steel."


/datum/beacon_import/example
	provided_items = list(/obj/item/stack/cable_coil/single = 10, /obj/item/plunger = 2)
	name = "Example Import"
	cost = 150
	desc = "This is a debug import that tests stacks and multiple single items. It sends 10 pieces of cable coil, stacked and 2 plungers."

