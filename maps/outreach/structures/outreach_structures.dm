///////////////////////////////////////////////////////////////////////////////////
// Painted Wall frames
///////////////////////////////////////////////////////////////////////////////////
/obj/structure/wall_frame/prepainted/medical
	color        = COLOR_PALE_BLUE_GRAY
	paint_color  = COLOR_PALE_BLUE_GRAY
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
	paint_color  = COLOR_BEASTY_BROWN
	stripe_color = COLOR_PALE_ORANGE
/obj/structure/wall_frame/prepainted/command
	color        = COLOR_COMMAND_BLUE
	paint_color  = COLOR_COMMAND_BLUE
	stripe_color = COLOR_COMMAND_BLUE
/obj/structure/wall_frame/prepainted/security
	color        = COLOR_NT_RED
	paint_color  = COLOR_NT_RED
	stripe_color = COLOR_ORANGE
/obj/structure/wall_frame/prepainted/botany
	color        = COLOR_CIVIE_GREEN
	paint_color  = COLOR_CIVIE_GREEN
	//stripe_color = COLOR_CIVIE_GREEN




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
	paint_color  = COLOR_PALE_BLUE_GRAY
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
/obj/effect/wallframe_spawn/no_grille/concrete/chapel
	win_path = /obj/structure/window/basic/full/chapel

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
/obj/effect/wallframe_spawn/reinforced/prepainted/command
	color      = COLOR_COMMAND_BLUE
	frame_path = /obj/structure/wall_frame/prepainted/command
/obj/effect/wallframe_spawn/reinforced/prepainted/security
	color      = COLOR_NT_RED
	frame_path = /obj/structure/wall_frame/prepainted/security


/obj/effect/wallframe_spawn/reinforced_borosilicate/ocp
	frame_path = /obj/structure/wall_frame/ocp/prepainted/exterior

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

//

/decl/closet_appearance/secure_closet/bio
	color = COLOR_PALE_ORANGE
	decals = list(
		"l3" = COLOR_OFF_WHITE,
		"stripe_horizontal_narrow" = COLOR_ORANGE
	)
	extra_decals = list(
		"biohazard" = COLOR_OFF_WHITE
	)

/obj/structure/closet/secure_closet/outreach/hazard_suit
	name              = "protective suit locker"
	closet_appearance = /decl/closet_appearance/secure_closet/bio

/obj/structure/closet/secure_closet/outreach/hazard_suit/WillContain()
	return list(
			/obj/item/flashlight/maglight,
			/obj/item/flashlight/maglight,
			/obj/item/scanner/gas,
			/obj/item/scanner/gas,
			/obj/item/clothing/mask/gas/half,
			/obj/item/clothing/mask/gas/half,
			/obj/item/clothing/gloves/fire,
			/obj/item/clothing/gloves/fire,
			/obj/item/clothing/suit/bio_suit/general,
			/obj/item/clothing/suit/bio_suit/general,
			/obj/item/clothing/head/bio_hood/general,
			/obj/item/clothing/head/bio_hood/general,
			/obj/item/clothing/shoes/workboots,
			/obj/item/clothing/shoes/workboots,
		)

//

/obj/structure/closet/secure_closet/outreach/eva
	name              = "eva gear locker"
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/pathfinder

/obj/structure/closet/secure_closet/outreach/eva/WillContain()
	return list(
			/obj/item/flashlight/maglight,
			/obj/item/flashlight/maglight,
			/obj/item/scanner/gas,
			/obj/item/scanner/gas,
			/obj/item/clothing/mask/gas/half,
			/obj/item/clothing/mask/gas/half,
			/obj/item/clothing/gloves/fire,
			/obj/item/clothing/gloves/fire,
			/obj/item/clothing/shoes/workboots,
			/obj/item/clothing/shoes/workboots,
		)

/obj/structure/closet/secure_closet/hydroponics/outreach
	name = "botanist's locker"
	req_access = list(access_hydroponics, OUTREACH_USR_GRP_BOTANY)
	closet_appearance = /decl/closet_appearance/secure_closet/hydroponics
	//mapper preview
	color = COLOR_GREEN_GRAY

/obj/structure/closet/secure_closet/hydroponics/outreach/WillContain()
	return list(
		new /datum/atom_creator/weighted(list(/obj/item/clothing/suit/apron, /obj/item/clothing/suit/apron/overalls)),
		/obj/item/storage/plants,
		/obj/item/clothing/under/hydroponics,
		/obj/item/scanner/plant,
		/obj/item/radio/headset/headset_service,
		/obj/item/clothing/mask/bandana/botany,
		/obj/item/clothing/head/bandana/green,
		/obj/item/minihoe,
		/obj/item/hatchet,
		/obj/item/wirecutters/clippers,
		/obj/item/chems/spray/plantbgone,
	)

/obj/structure/closet/secure_closet/outreach/chemistry
	name              = "chemistry locker"
	closet_appearance = /decl/closet_appearance/secure_closet/rd
	req_access        = list(access_research, OUTREACH_USR_GRP_RESEARCH_CHEM)

/obj/structure/closet/secure_closet/outreach/chemistry/WillContain()
	return list(
		/obj/item/clothing/gloves/latex/nitrile = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/chemist = 2,
		/obj/item/clothing/shoes/color/white = 2,
		/obj/item/clothing/under/chemist = 2,
		/obj/item/storage/belt/general = 2,
		/obj/item/clothing/glasses/science = 2,
		/obj/item/radio/headset/headset_sci = 2,
		/obj/item/chems/glass/beaker/large = 2,
		/obj/item/scanner/reagent = 2,
		/obj/item/scanner/spectrometer = 2,
	)


/obj/structure/closet/crate/internals/WillContain()
	return list(
		/obj/item/clothing/mask/gas/half = 8,
		/obj/item/tank/emergency/oxygen = 8,
	)

/obj/structure/closet/emcloset/outreach/WillContain()
	//Guaranteed kit - two tanks and masks
	. = list(
		/obj/item/tank/emergency/oxygen = 4,
		/obj/item/clothing/mask/gas/half = 4,
		/obj/item/oxycandle = 4,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/toolbox/emergency,
	)

// Tables

/obj/structure/table/plastic
	icon_state = "plain_preview"
	color = COLOR_GRAY40
	reinf_material = /decl/material/solid/organic/plastic


/obj/effect/floor_decal/arrow/red
	name  = "red floor arrow"
	color = COLOR_DARK_RED
/obj/effect/floor_decal/arrow/yellow
	name  = "yellow floor arrow"
	color = COLOR_YELLOW_GRAY

/obj/effect/floor_decal/arrows/red
	name  = "red floor arrows"
	color = COLOR_DARK_RED
/obj/effect/floor_decal/arrows/yellow
	name  = "yellow floor arrows"
	color = COLOR_YELLOW_GRAY

/obj/structure/closet/secure_closet/outreach/command
	req_access = list(list(access_bridge), list(OUTREACH_USR_GRP_COMMAND_RECORDS))



/obj/structure/window/basic/full/chapel
	color = GLASS_COLOR