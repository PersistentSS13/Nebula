///////////////////////////////////////////////////////////////////////////////////
// Painted Wall frames
///////////////////////////////////////////////////////////////////////////////////
/obj/structure/wall_frame/prepainted/medical
	color        = COLOR_PALE_BLUE_GRAY
	paint_color  = null
	stripe_color = COLOR_PALE_BLUE_GRAY
/obj/structure/wall_frame/prepainted/engineering
	color        = COLOR_AMBER
	paint_color  = null
	stripe_color = COLOR_AMBER
/obj/structure/wall_frame/prepainted/atmos
	color        = COLOR_CYAN
	paint_color  = null
	stripe_color = COLOR_CYAN
/obj/structure/wall_frame/prepainted/mining
	color        = COLOR_BEASTY_BROWN
	paint_color  = null
	stripe_color = COLOR_PALE_ORANGE

///////////////////////////////////////////////////////////////////////////////////
// Steel Wall frames
///////////////////////////////////////////////////////////////////////////////////
/obj/structure/wall_frame/steel
	material = /decl/material/solid/metal/steel

/obj/effect/wallframe_spawn/reinforced/steel
	frame_path = /obj/structure/wall_frame/steel

///////////////////////////////////////////////////////////////////////////////////
// Concrete Wall frames
///////////////////////////////////////////////////////////////////////////////////
/obj/structure/wall_frame/concrete
	material = /decl/material/solid/stone/concrete

/obj/structure/wall_frame/concrete/prepainted/medical
	color        = COLOR_PALE_BLUE_GRAY
	paint_color  = null
	stripe_color = COLOR_PALE_BLUE_GRAY
/obj/structure/wall_frame/concrete/prepainted/engineering
	color        = COLOR_AMBER
	paint_color  = null
	stripe_color = COLOR_AMBER
/obj/structure/wall_frame/concrete/prepainted/atmos
	color        = COLOR_CYAN
	paint_color  = null
	stripe_color = COLOR_CYAN
/obj/structure/wall_frame/concrete/prepainted/mining
	color        = COLOR_BEASTY_BROWN
	paint_color  = null
	stripe_color = COLOR_PALE_ORANGE

///////////////////////////////////////////////////////////////////////////////////
// OCP Wall frames
///////////////////////////////////////////////////////////////////////////////////
/obj/structure/wall_frame/ocp
	color          = "#9bc6f2"
	material       = /decl/material/solid/metal/plasteel/ocp
/obj/structure/wall_frame/ocp/prepainted/exterior
	color          = COLOR_GUNMETAL
	paint_color    = COLOR_GUNMETAL
	stripe_color   = COLOR_AMBER

///////////////////////////////////////////////////////////////////////////////////
// Spawners
///////////////////////////////////////////////////////////////////////////////////
/obj/effect/wallframe_spawn/no_grille
	icon = 'icons/obj/structures/window.dmi'
	icon_state = "window_full"

//No grille + concrete
/obj/effect/wallframe_spawn/no_grille/concrete
	name       = "concrete wall frame window spawner"
	frame_path = /obj/structure/wall_frame/concrete
/obj/effect/wallframe_spawn/no_grille/concrete/prepainted/medical
	name       = "concrete wall frame window spawner"
	color      = COLOR_PALE_BLUE_GRAY
	frame_path = /obj/structure/wall_frame/concrete/prepainted/medical
/obj/effect/wallframe_spawn/no_grille/concrete/prepainted/engineering
	name       = "concrete wall frame window spawner"
	color      = COLOR_AMBER
	frame_path = /obj/structure/wall_frame/concrete/prepainted/engineering
/obj/effect/wallframe_spawn/no_grille/concrete/prepainted/atmos
	name       = "concrete wall frame window spawner"
	color      = COLOR_CYAN
	frame_path = /obj/structure/wall_frame/concrete/prepainted/atmos
/obj/effect/wallframe_spawn/no_grille/concrete/prepainted/mining
	name       = "concrete wall frame window spawner"
	color      = COLOR_BEASTY_BROWN
	frame_path = /obj/structure/wall_frame/concrete/prepainted/mining

//No grille + painted
/obj/effect/wallframe_spawn/no_grille/prepainted/medical
	color      = COLOR_PALE_BLUE_GRAY
	frame_path = /obj/structure/wall_frame/prepainted/medical
/obj/effect/wallframe_spawn/no_grille/prepainted/engineering
	color      = COLOR_AMBER
	frame_path = /obj/structure/wall_frame/prepainted/engineering
/obj/effect/wallframe_spawn/no_grille/prepainted/atmos
	color      = COLOR_CYAN
	frame_path = /obj/structure/wall_frame/prepainted/atmos
/obj/effect/wallframe_spawn/no_grille/prepainted/mining
	color      = COLOR_BEASTY_BROWN
	frame_path = /obj/structure/wall_frame/prepainted/mining

//Reinforced concrete + painted
/obj/effect/wallframe_spawn/reinforced/concrete
	name       = "concrete wall frame reinforced window spawner"
	frame_path = /obj/structure/wall_frame/concrete

/obj/effect/wallframe_spawn/reinforced/concrete/prepainted/medical
	color      = COLOR_PALE_BLUE_GRAY
	frame_path = /obj/structure/wall_frame/concrete/prepainted/medical
/obj/effect/wallframe_spawn/reinforced/concrete/prepainted/engineering
	color      = COLOR_AMBER
	frame_path = /obj/structure/wall_frame/concrete/prepainted/engineering
/obj/effect/wallframe_spawn/reinforced/concrete/prepainted/atmos
	color      = COLOR_CYAN
	frame_path = /obj/structure/wall_frame/concrete/prepainted/atmos
/obj/effect/wallframe_spawn/reinforced/concrete/prepainted/mining
	color      = COLOR_BEASTY_BROWN
	frame_path = /obj/structure/wall_frame/concrete/prepainted/mining

//concrete + painted
/obj/effect/wallframe_spawn/concrete/prepainted/medical
	color      = COLOR_PALE_BLUE_GRAY
	frame_path = /obj/structure/wall_frame/concrete/prepainted/medical
/obj/effect/wallframe_spawn/concrete/prepainted/engineering
	color      = COLOR_AMBER
	frame_path = /obj/structure/wall_frame/concrete/prepainted/engineering
/obj/effect/wallframe_spawn/concrete/prepainted/atmos
	color      = COLOR_CYAN
	frame_path = /obj/structure/wall_frame/concrete/prepainted/atmos
/obj/effect/wallframe_spawn/concrete/prepainted/mining
	color      = COLOR_BEASTY_BROWN
	frame_path = /obj/structure/wall_frame/concrete/prepainted/mining

//Reinforced + painted
/obj/effect/wallframe_spawn/reinforced/prepainted/medical
	color      = COLOR_PALE_BLUE_GRAY
	frame_path = /obj/structure/wall_frame/prepainted/medical
/obj/effect/wallframe_spawn/reinforced/prepainted/engineering
	color      = COLOR_AMBER
	frame_path = /obj/structure/wall_frame/prepainted/engineering
/obj/effect/wallframe_spawn/reinforced/prepainted/atmos
	color      = COLOR_CYAN
	frame_path = /obj/structure/wall_frame/prepainted/atmos
/obj/effect/wallframe_spawn/reinforced/prepainted/mining
	color      = COLOR_BEASTY_BROWN
	frame_path = /obj/structure/wall_frame/prepainted/mining

///////////////////////////////////////////////////////////////////////////////////
// Railings
///////////////////////////////////////////////////////////////////////////////////
/obj/structure/railing/mapped/stairwell
	anchored      = TRUE
	color         = COLOR_GRAY40
	painted_color = COLOR_GRAY40

///////////////////////////////////////////////////////////////////////////////////
// Barricades
///////////////////////////////////////////////////////////////////////////////////
/obj/structure/barricade/wood
	material = /decl/material/solid/organic/wood/maple

/obj/structure/door/osmium
	material = /decl/material/solid/metal/osmium

///////////////////////////////////////////////////////////////////////////////////
// Lockers
///////////////////////////////////////////////////////////////////////////////////
/obj/structure/closet/secure_closet/security/outreach
	name = "security locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/security
/obj/structure/closet/secure_closet/security/outreach/WillContain()
	return

/obj/structure/closet/secure_closet/security/outreach/gear
	name = "security gear locker"
/obj/structure/closet/secure_closet/security/outreach/gear/WillContain()
	return list(
		/obj/item/storage/box/barricade_tape/police,
		/obj/item/storage/box/barricade_tape/police,
		/obj/item/storage/box/handcuffs,
		/obj/item/storage/box/handcuffs,
		/obj/item/storage/box/holobadge,
		/obj/item/storage/box/holobadge,
		/obj/item/storage/firstaid/combat,
		/obj/item/storage/firstaid/combat,
		/obj/item/storage/firstaid/combat,
	)

/obj/structure/closet/secure_closet/security/outreach/forensics
	name = "security forensics locker"
	closet_appearance = /decl/closet_appearance/secure_closet/security
/obj/structure/closet/secure_closet/security/outreach/forensics/WillContain()
	return list(
		/obj/item/storage/briefcase/crimekit,
		/obj/item/storage/briefcase/crimekit,
		/obj/item/storage/evidence,
		/obj/item/storage/evidence,
		/obj/item/storage/box/fingerprints,
		/obj/item/storage/box/fingerprints,
		/obj/item/storage/box/evidence,
		/obj/item/storage/box/evidence,
		/obj/item/storage/box/gloves,
		/obj/item/storage/box/gloves,
		/obj/item/storage/box/csi_markers,
		/obj/item/storage/box/csi_markers,
		/obj/item/storage/box/swabs,
		/obj/item/storage/box/swabs,
		/obj/item/storage/box/tapes,
		/obj/item/storage/box/camera_films,
		/obj/item/taperecorder/empty,
		/obj/item/taperecorder/empty,
		/obj/item/camera,
		/obj/item/camera,
	)

///////////////////////////////////////////////////////////////////////////////////
// Boxes
///////////////////////////////////////////////////////////////////////////////////
/obj/item/storage/box/camera_films
	name = "box of camera film rolls"
/obj/item/storage/box/camera_films/WillContain()
	var/obj/item/camera_film/F = /obj/item/camera_film
	return list(
		/obj/item/camera_film =  BASE_STORAGE_CAPACITY(initial(F.w_class)),
		)

/obj/item/storage/box/barricade_tape/police
	name = "box of police tape"
/obj/item/storage/box/barricade_tape/police/WillContain()
	var/obj/item/stack/tape_roll/barricade_tape/police/P = /obj/item/stack/tape_roll/barricade_tape/police
	return list(
		/obj/item/stack/tape_roll/barricade_tape/police =  BASE_STORAGE_CAPACITY(initial(P.w_class)),
		)