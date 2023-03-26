///////////////////////////////////////////////////////////////////////////////////
// Transition Edges
///////////////////////////////////////////////////////////////////////////////////
/**Special turf to teleport to an adjacent z-level */
/turf/exterior/transition_edge
	name             = "level connection"
	desc             = "The government actually wants you to see this!"
	density          = TRUE
	blocks_air       = TRUE
	dynamic_lighting = FALSE
	icon             = null
	icon_state       = null
	permit_ao        = FALSE
	var/mimicx
	var/mimicy
	var/mimicz

/turf/exterior/transition_edge/Initialize()
	. = ..()
	var/obj/effect/overmap/visitable/sector/exoplanet/E = global.overmap_sectors[num2text(z)]
	if(!istype(E))
		return
	var/obj/abstract/level_data/ldat = SSmapping.levels_by_z[z]

	//Figure out our orientation on the map
	var/edge_dir = 0
	var/halfmaxx = round(world.maxx/2)
	var/halfmaxy = round(world.maxy/2)
	if(x < halfmaxx)
		edge_dir |= WEST
	else
		edge_dir |= EAST

	if(y < halfmaxy)
		edge_dir |= SOUTH
	else
		edge_dir |= NORTH

	var/connected_level
	for(var/level_id in ldat.connects_to)
		if((ldat.connects_to[level_id]) & edge_dir)
			connected_level = level_id
			break
	if(!connected_level)
		log_warning("Got transition_edge turf([x], [y], [z]) in direction [dir2text(edge_dir)] that doesn't connect to anything!")
		ChangeTurf(/turf/unsimulated/wall, FALSE, FALSE, FALSE)
		return .

	var/obj/abstract/level_data/target_ldat = SSmapping.levels_by_id[connected_level]
	if(!target_ldat)
		CRASH("Got transition_edge turf([x], [y], [z]) linking to a non-existent level id '[connected_level]'!")
	mimicx = x
	if (x <= TRANSITIONEDGE)
		mimicx = x + (E.maxx - 2*TRANSITIONEDGE) - 1
	else if (x >= (E.maxx - TRANSITIONEDGE))
		mimicx = x - (E.maxx  - 2*TRANSITIONEDGE) + 1

	mimicy = y
	if(y <= TRANSITIONEDGE)
		mimicy = y + (E.maxy - 2*TRANSITIONEDGE) - 1
	else if (y >= (E.maxy - TRANSITIONEDGE))
		mimicy = y - (E.maxy - 2*TRANSITIONEDGE) + 1

	mimicz = target_ldat.my_z

	refresh_vis_contents()

	//Need to put a mouse-opaque overlay there to prevent people turning/shooting towards ACTUAL location of vis_content things
	var/obj/effect/overlay/O = new(src)
	O.mouse_opacity = 2
	O.name = "distant terrain"
	O.desc = "You need to come over there to take a better look."

/turf/exterior/transition_edge/Bumped(atom/movable/A)
	. = ..()
	var/obj/effect/overmap/visitable/sector/exoplanet/E = global.overmap_sectors[num2text(mimicz)]
	if(!istype(E))
		return
	if(E.planetary_area && istype(loc, world.area))
		ChangeArea(src, E.planetary_area)
	var/new_x = A.x
	var/new_y = A.y
	if(x <= TRANSITIONEDGE)
		new_x = E.maxx - TRANSITIONEDGE - 1
	else if (x >= (E.maxx - TRANSITIONEDGE))
		new_x = TRANSITIONEDGE + 1
	else if (y <= TRANSITIONEDGE)
		new_y = E.maxy - TRANSITIONEDGE - 1
	else if (y >= (E.maxy - TRANSITIONEDGE))
		new_y = TRANSITIONEDGE + 1

	var/turf/T = locate(new_x, new_y, mimicz)
	if(T && !T.density)
		A.forceMove(T)
		if(isliving(A))
			var/mob/living/L = A
			for(var/obj/item/grab/G in L.get_active_grabs())
				G.affecting.forceMove(T)

/turf/exterior/transition_edge/on_update_icon()
	return

/turf/exterior/transition_edge/get_vis_contents_to_add()
	. = ..()
	var/turf/NT = mimicx && mimicy && mimicz && locate(mimicx, mimicy, mimicz)
	if(NT)
		opacity = NT.opacity
		//log_debug("[src]([x],[y],[z]) mirroring [NT]([NT.x],[NT.y],[NT.z])")
		LAZYADD(., NT)
