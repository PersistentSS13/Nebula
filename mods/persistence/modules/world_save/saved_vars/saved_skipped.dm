/////////////////////////////////////////
// Things Not Saved
/////////////////////////////////////////
//Mark things as not saved that couldn't go anywhere else.
//#TODO: Move things to respective files if they have one.

/mob/observer
	should_save = FALSE

/atom/movable/openspace
	should_save = FALSE
/mob/living/simple_animal/hostile/mimic
	should_save = FALSE

/datum/extension/penetration
	should_save = FALSE
/datum/extension/armor
	should_save = FALSE
/datum/extension/turf_hand 
	should_save = FALSE
/datum/extension/interactive/multitool
	should_save = FALSE
/datum/extension/interactive/multitool/circuitboards/buildtype_select
	should_save = FALSE
/datum/extension/ship_engine
	should_save = FALSE

//Powernets are rebuilt entirely on map load
/datum/powernet
	should_save = FALSE

/obj/item/tankassemblyproxy
	should_save = FALSE
