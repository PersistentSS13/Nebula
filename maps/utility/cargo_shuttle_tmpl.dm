///Default identifier for the starting waypoint for the cargo shuttle map template.
#define CARGO_SHUTTLE_TEMPLATE_WAYPOINT_OFFSITE "nav_supply_shuttle_offsite_dock"
///Default identifier for the station dock waypoint for the cargo shuttle map template.
#define CARGO_SHUTTLE_TEMPLATE_WAYPOINT_STATION "nav_supply_shuttle_station_dock"

///Default identifier for the off site docking controller id for the supply shuttle
#define CARGO_SHUTTLE_TEMPLATE_CTRL_ID_OFFSITE "supply_shuttle_ctrl_offsite"
///Default identifier for the station dock cargo shuttle template docking controller.
#define CARGO_SHUTTLE_TEMPLATE_CTRL_ID_STATION "supply_shuttle_ctrl_station"
///Default identifier for the cargo shuttle template's shuttle docking controller.
#define CARGO_SHUTTLE_TEMPLATE_CTRL_ID_SHUTTLE "supply_shuttle_ctrl"

///Id tag for the shuttle's own rear shutters
#define CARGO_SHUTTLE_TEMPLATE_DOORS_ID_SHUTTLE "supply_shuttle_shutters"
///Id tag for the offsite docks's shutters (Might get removed at one point)
#define CARGO_SHUTTLE_TEMPLATE_DOORS_ID_OFFSITE "_supply_shuttle_offsite_shutters"
///Id tag for station side docks's doors. That's just a default suggestion.
#define CARGO_SHUTTLE_TEMPLATE_DOORS_ID_STATION "supply_shuttle_station_shutters"
///Id tag for the conveyors inside the shuttle.
#define CARGO_SHUTTLE_TEMPLATE_CONVEYORS_ID     "supply_shuttle_conveyors"

///////////////////////////////////////////////////////////////////////////////////////////
// Areas
///////////////////////////////////////////////////////////////////////////////////////////

///Area for the cargo shuttle
/area/shuttle/supply_shuttle
	name       = "supply shuttle"
	icon_state = "shuttle3"
	area_flags = AREA_FLAG_SHUTTLE | AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT

///Area for the small area where the supply shuttle docks to offsite
/area/cargo_shuttle_dock
	name             = "supply shuttle offsite docks"
	icon_state       = "centcom"
	requires_power   = FALSE
	dynamic_lighting = FALSE
	area_flags       = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT

///////////////////////////////////////////////////////////////////////////////////////////
// Template
///////////////////////////////////////////////////////////////////////////////////////////

///A utility template meant for adding a pre-mapped supply shuttle to any map that want to use one.
/datum/map_template/cargo_shuttle
	name                   = "supply shuttle"
	template_flags         = TEMPLATE_FLAG_SPAWN_GUARANTEED | TEMPLATE_FLAG_NO_RADS | TEMPLATE_FLAG_NO_RUINS
	modify_tag_vars        = FALSE
	level_data_type        = /datum/level_data/space
	mappaths               = list("maps/utility/cargo_shuttle_tmpl.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/ferry/supply/cargo)
	template_categories    = list(MAP_TEMPLATE_CATEGORY_MAIN_SITE) //Wait until all the other templates are loaded first
	apc_test_exempt_areas  = list(
		/area/shuttle/supply_shuttle = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/cargo_shuttle_dock     = NO_SCRUBBER|NO_VENT|NO_APC,
	)

///////////////////////////////////////////////////////////////////////////////////////////
// Shuttle
///////////////////////////////////////////////////////////////////////////////////////////

///Cargo shuttle data
/datum/shuttle/autodock/ferry/supply/cargo
	name                 = "supply shuttle"
	display_name         = "supply shuttle"
	defer_initialisation = TRUE
	warmup_time          = 10 //in seconds
	location             = 1 //#FIXME: Shuttle code is very dumb
	direction            = 0 //#FIXME: Shuttle code is very dumb
	shuttle_area         = /area/shuttle/supply_shuttle
	dock_target          = CARGO_SHUTTLE_TEMPLATE_CTRL_ID_SHUTTLE
	current_location     = CARGO_SHUTTLE_TEMPLATE_WAYPOINT_OFFSITE
	waypoint_offsite     = CARGO_SHUTTLE_TEMPLATE_WAYPOINT_OFFSITE
	waypoint_station     = CARGO_SHUTTLE_TEMPLATE_WAYPOINT_STATION

///////////////////////////////////////////////////////////////////////////////////////////
// Waypoints
///////////////////////////////////////////////////////////////////////////////////////////

///Starting point in space for the cargo shuttle
/obj/effect/shuttle_landmark/supply/offsite
	name               = "supply shuttle offsite"
	landmark_tag       = CARGO_SHUTTLE_TEMPLATE_WAYPOINT_OFFSITE
	docking_controller = CARGO_SHUTTLE_TEMPLATE_CTRL_ID_OFFSITE
	base_area          = /area/space
	base_turf          = /turf/space

///Point on the station where the supply shuttle will dock.
/obj/effect/shuttle_landmark/supply/dock
	name               = "supply shuttle station dock"
	flags              = SLANDMARK_FLAG_AUTOSET
	landmark_tag       = CARGO_SHUTTLE_TEMPLATE_WAYPOINT_STATION
	docking_controller = CARGO_SHUTTLE_TEMPLATE_CTRL_ID_STATION

///////////////////////////////////////////////////////////////////////////////////////////
// Supply Override
///////////////////////////////////////////////////////////////////////////////////////////

///Returns turfs inside the shuttle that can be used for placing ordered items.
/datum/controller/subsystem/supply/get_clear_turfs()
	var/list/clear_turfs = ..()
	//Only place crates where there's a crate conveyor
	for(var/turf/T in clear_turfs)
		if(!(locate(/obj/machinery/conveyor) in T))
			clear_turfs -= T
	return clear_turfs

///////////////////////////////////////////////////////////////////////////////////////////
// Machines
///////////////////////////////////////////////////////////////////////////////////////////

// *** Conveyors Switch ***
/obj/machinery/conveyor_switch/indestructible
	stat_immune = BROKEN | NOPOWER | MAINT | EMPED | NOSCREEN | NOINPUT
	id_tag      = CARGO_SHUTTLE_TEMPLATE_CONVEYORS_ID
/obj/machinery/conveyor_switch/indestructible/take_damage(amount, damtype, silent)
	return
/obj/machinery/door/airlock/hatch/indestructible/attackby(obj/item/C, mob/user)
	return
/obj/machinery/conveyor_switch/indestructible/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	return

// *** Conveyors ***
/obj/machinery/conveyor/indestructible
	stat_immune = BROKEN | NOPOWER | MAINT | EMPED | NOSCREEN | NOINPUT
	id_tag      = CARGO_SHUTTLE_TEMPLATE_CONVEYORS_ID
/obj/machinery/conveyor/indestructible/take_damage(amount, damtype, silent)
	return
/obj/machinery/conveyor/indestructible/attackby(obj/item/C, mob/user)
	return
/obj/machinery/conveyor/indestructible/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	return

// *** Shutter Button ***
/obj/machinery/button/blast_door/indestructible
	stat_immune = BROKEN | NOPOWER | MAINT | EMPED | NOSCREEN | NOINPUT
	id_tag      = CARGO_SHUTTLE_TEMPLATE_DOORS_ID_SHUTTLE
/obj/machinery/button/blast_door/indestructible/take_damage(amount, damtype, silent)
	return
/obj/machinery/button/blast_door/indestructible/attackby(obj/item/C, mob/user)
	return
/obj/machinery/button/blast_door/indestructible/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	return

// *** Shutters ***
/obj/machinery/door/blast/shutters/indestructible
	stat_immune = BROKEN | NOPOWER | MAINT | EMPED | NOSCREEN | NOINPUT
	id_tag      = CARGO_SHUTTLE_TEMPLATE_DOORS_ID_SHUTTLE
/obj/machinery/door/blast/shutters/indestructible/supply_dock
	id_tag = CARGO_SHUTTLE_TEMPLATE_DOORS_ID_OFFSITE
/obj/machinery/door/blast/shutters/indestructible/take_damage(amount, damtype, silent)
	return
/obj/machinery/door/blast/shutters/indestructible/attackby(obj/item/C, mob/user)
	return
/obj/machinery/door/blast/shutters/indestructible/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	return

// *** Airlock Door ***
/obj/machinery/door/airlock/hatch/indestructible
	stat_immune = BROKEN | NOPOWER | MAINT | EMPED | NOSCREEN | NOINPUT
	hackProof   = TRUE
/obj/machinery/door/airlock/hatch/indestructible/take_damage(amount, damtype, silent)
	return
/obj/machinery/door/airlock/hatch/indestructible/attackby(obj/item/C, mob/user)
	return
/obj/machinery/door/airlock/hatch/indestructible/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	return


// *** Shuttle Docking Controller Templates ***

///Indestructible variant of the simple_docking_controller
/obj/machinery/embedded_controller/radio/simple_docking_controller/indestructible
	stat_immune = BROKEN | NOPOWER | MAINT | EMPED | NOSCREEN | NOINPUT
///Controller for the supply shuttle
/obj/machinery/embedded_controller/radio/simple_docking_controller/indestructible/supply_shuttle
	id_tag      = CARGO_SHUTTLE_TEMPLATE_CTRL_ID_SHUTTLE
	tag_door    = CARGO_SHUTTLE_TEMPLATE_DOORS_ID_SHUTTLE
///Controller for the supply shuttle offsite docks
/obj/machinery/embedded_controller/radio/simple_docking_controller/indestructible/supply_offsite
	id_tag      = CARGO_SHUTTLE_TEMPLATE_CTRL_ID_OFFSITE
	tag_door    = CARGO_SHUTTLE_TEMPLATE_DOORS_ID_OFFSITE
///Controller for the supply shuttle station's docking area
/obj/machinery/embedded_controller/radio/simple_docking_controller/indestructible/supply_station
	name     = "supply shuttle docking controller"
	id_tag   = CARGO_SHUTTLE_TEMPLATE_CTRL_ID_STATION
	tag_door = CARGO_SHUTTLE_TEMPLATE_DOORS_ID_STATION

/obj/machinery/embedded_controller/radio/simple_docking_controller/indestructible/take_damage(amount, damtype, silent)
	return
/obj/machinery/embedded_controller/radio/simple_docking_controller/indestructible/attackby(obj/item/C, mob/user)
	return
/obj/machinery/embedded_controller/radio/simple_docking_controller/indestructible/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	return

///////////////////////////////////////////////////////////////////////////////////////////
// Structures
///////////////////////////////////////////////////////////////////////////////////////////

///A dummy airtight plasticflap to hide the inside of the cargo shuttle offsite docks.
/obj/structure/plasticflaps/airtight/indestructible
	anchored = TRUE
	density  = TRUE
	opacity  = TRUE
/obj/structure/plasticflaps/airtight/indestructible/clear_airtight()
	return
/obj/structure/plasticflaps/airtight/indestructible/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return
/obj/structure/plasticflaps/airtight/indestructible/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return
/obj/structure/plasticflaps/airtight/indestructible/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	return
/obj/structure/plasticflaps/airtight/indestructible/attackby(var/obj/item/C, var/mob/user)
	return

///Sign
/obj/structure/sign/warning/hot_exhaust/indestructible/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return
/obj/structure/sign/warning/hot_exhaust/indestructible/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return
/obj/structure/sign/warning/hot_exhaust/indestructible/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	return
/obj/structure/sign/warning/hot_exhaust/indestructible/attackby(var/obj/item/C, var/mob/user)
	return
/obj/structure/sign/warning/hot_exhaust/indestructible/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return


///////////////////////////////////////////////////////////////////////////////////////////
// Turfs
///////////////////////////////////////////////////////////////////////////////////////////

///Unbreakable floor tile for cargo shuttle
/turf/simulated/floor/indestructible
	name          = "hull plating"
	icon          = 'icons/turf/flooring/tiles.dmi'
	icon_state    = "reinforced_light"
	footstep_type = /decl/footsteps/plating

/turf/simulated/floor/indestructible/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return
/turf/simulated/floor/indestructible/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return
/turf/simulated/floor/indestructible/attack_hand(mob/user)
	return
/turf/simulated/floor/indestructible/attackby(var/obj/item/C, var/mob/user)
	return

/turf/simulated/floor/indestructible/airless
	initial_gas = null
	icon        = 'icons/turf/flooring/plating.dmi'
	icon_state  = "plating"

///Unbreakable wall for cargo shuttle
/turf/simulated/wall/r_titanium/indestructible
	name = "hull plating"

/turf/simulated/wall/r_titanium/indestructible/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return
/turf/simulated/wall/r_titanium/indestructible/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return
/turf/simulated/wall/r_titanium/indestructible/attack_hand(mob/user)
	return
/turf/simulated/wall/r_titanium/indestructible/attackby(var/obj/item/C, var/mob/user)
	return

#undef CARGO_SHUTTLE_TEMPLATE_DOORS_ID_OFFSITE
#undef CARGO_SHUTTLE_TEMPLATE_CTRL_ID_OFFSITE