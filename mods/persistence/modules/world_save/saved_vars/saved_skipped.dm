/////////////////////////////////////////
// Things Not Saved
/////////////////////////////////////////
//Mark things as not saved that couldn't go anywhere else.
//#TODO: Move things to respective files if they have one.

/mob/observer
	should_save = FALSE

///////////////////////////////////////////////////
// ZMimic stuff
///////////////////////////////////////////////////

/atom/movable/openspace
	should_save = FALSE

/mob/living/simple_animal/hostile/mimic
	should_save = FALSE

///////////////////////////////////////////////////
// Nano Stuff
///////////////////////////////////////////////////
/datum/nano_module
	should_save = FALSE

/datum/nanoui
	should_save = FALSE

///////////////////////////////////////////////////
//Extensions
///////////////////////////////////////////////////

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

//Don't save eye extension, there's no way to restore this properly, since the viewer may or may not exist after load, and the client vars are never saved
/datum/extension/eye
 	should_save = FALSE

///////////////////////////////////////////////////
// Runtime Datums
///////////////////////////////////////////////////

//Powernets are rebuilt entirely on map load
/datum/powernet
	should_save = FALSE

//Actions are runtime datums no need to save them, they get regenerated often
/datum/action
	should_save = FALSE

//Click handlers are client side stuff, we don't save anything from the clients
/datum/click_handler
	should_save = FALSE

///////////////////////////////////////////////////
//Base engine types
///////////////////////////////////////////////////

/sound
	should_save = FALSE

/datum/sound_token
	should_save = FALSE

/particles
	should_save = FALSE

///////////////////////////////////////////////////
// Things
///////////////////////////////////////////////////

/obj/item/tankassemblyproxy
	should_save = FALSE

/obj/item/radio/announcer
	should_save = FALSE

//This object is doing a bunch of nasty things, like initializing during new, and moving to nullspace, don't try saving it.
/obj/abstract/weather_system
	should_save = FALSE