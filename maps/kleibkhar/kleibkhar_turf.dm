#define KLEIBKHAR_GRASS_EDGE_LAYER  0.053
#define KLEIBKHAR_VEGETATION_CHANCE 10 //1 in 10 chance of spawning vegetation/props

//#TODO: once the seed system is sorted out use types instead of strings for seed types.

/** Seeds clearing grass tiles may yield */
var/global/list/grass_seed_drop_types_common = list(
	"chili",
	"berries",
	"corn",
	"eggplant",
	"tomato",
	"soybean",
	"wheat",
	"carrot",
	"harebells",
	"grass",
	"sunflowers",
	"potato",
	"peanut",
	"cabbage",
	"blueberries",
	"rice",
	"nettle",
	"weeds",
	"whitebeet",
	"watermelon",
	"pumpkin",
	"peppercorn",
	"garlic",
	"onion",
)
var/global/list/grass_seed_drop_types_uncommon = list(
	"biteleaf",
	"sugarcane",
	"tobacco",
	"poppies",
	"icechili",
	"mtear",
	"grapes",
	"greengrapes",
	"cotton",
	"plastic",
	"shand",
	"lavender",
	"algae",
)

var/global/list/kleibkhar_possible_mushroom_seeds = list(
	"mold",
	"reishi",
	"amanita",
	"destroyingangel",
	"libertycap",
	"mushrooms",
	"towercap",
	"glowbell",
	"plumphelmet",
)

var/global/list/kleibkhar_possible_tree_seeds = list(
	"banana",
	"apple",
	"lime",
	"lemon",
	"orange",
	"cocoa",
	"cherry",
	"bamboo",
)

/turf/exterior/kleibkhar_grass
	name = "wild grass"
	icon = 'icons/turf/exterior/wildgrass.dmi'
	icon_edge_layer = KLEIBKHAR_GRASS_EDGE_LAYER
	icon_has_corners = TRUE
	color = "#799c4b"
	footstep_type = /decl/footsteps/grass

/turf/exterior/kleibkhar_grass/Initialize(mapload, no_update_icon)
	. = ..()
	var/datum/planetoid_data/PD = SSmapping.planetoid_data_by_z[z]
	if(istype(PD) && PD.get_grass_color())
		color = PD.get_grass_color()

	// Turfs don't retain persistent IDs across load currently, so we just check if we're in a loaded world instead.
	if(!SSpersistence.in_loaded_world)
		generate_tile_prop()

/turf/exterior/kleibkhar_grass/proc/generate_tile_prop()
	if(rand(0, KLEIBKHAR_VEGETATION_CHANCE) != KLEIBKHAR_VEGETATION_CHANCE || length(contents))
		return //No vegetation/prop for this tile

	//Pick a prop/plant
	var/picked = pick(
			prob(60); "plant",
			prob(60); "lichen",
			prob(40); "dirt",
			prob(25); "rock",
			prob(25); "dead_tree",
			prob(3); "seed_tree",
			prob(2); "seed_plant",
			prob(1); "seed_mushroom"
		)

	//Handle props
	var/obj/prop
	switch(picked)
		if("plant")
			prop = new /obj/structure/flora/grass/green(src)
		if("rock")
			prop = new /obj/structure/boulder(src)
		if("dirt")
			prop = new /obj/effect/decal/cleanable/dirt(src)
		if("lichen")
			prop = new /obj/effect/decal/cleanable/lichen(src)
		if("dead_tree")
			prop = new /obj/structure/flora/tree/dead(src)

	//Handle seeds
	if(!prop)
		var/picked_seed
		switch(picked)
			if("seed_tree")
				picked_seed = pick(global.kleibkhar_possible_tree_seeds)
			if("seed_plant")
				picked_seed = prob(80)? pick(global.grass_seed_drop_types_common) : pick(global.grass_seed_drop_types_uncommon)
			if("seed_mushroom")
				picked_seed = pick(global.kleibkhar_possible_mushroom_seeds)
		if(picked_seed)
			prop = new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(src, picked_seed, prob(50))

	//Add some randomness to the placement
	prop.pixel_x += rand(-8, 8)
	prop.pixel_y += rand(-8, 8)

/turf/exterior/kleibkhar_grass/attackby(obj/item/W, mob/user, click_params)
	if(istype(W, /obj/item/minihoe) || istype(W, /obj/item/scythe))
		to_chat(user, SPAN_NOTICE("You begin clearing the grass..."))
		if(user.do_skilled(4 SECONDS, SKILL_BOTANY, src))
			//If skilled, we may get some drops
			if(user.skill_check(SKILL_BOTANY, SKILL_ADEPT) && prob(20))
				var/rand_seedname  = prob(80)? pick(global.grass_seed_drop_types_common) : pick(global.grass_seed_drop_types_uncommon)
				var/obj/item/seeds/rand_seeds = new /obj/item/seeds
				rand_seeds.seed_type = rand_seedname
				rand_seeds.update_seed()
				user.put_in_hands(rand_seeds)
				to_chat(user, SPAN_BOLD("Your botany skill allowed you to recover some seeds!"))
			to_chat(user, SPAN_NOTICE("You cleared the grass."))
			ChangeTurf(/turf/exterior/mud/dark)
		return TRUE
	. = ..()

/turf/exterior/kleibkhar_grass/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if((temperature > T0C + 200 && prob(5)) || temperature > T0C + 1000)
		melt()

/turf/exterior/kleibkhar_grass/melt()
	if(icon_state != "scorched")
		SetName("scorched ground")
		icon_state = "scorched"
		icon_edge_layer = -1
		footstep_type = /decl/footsteps/asteroid
		color = null

//
//Terraforming
//

//Mud working
var/global/list/exterior_mud_dark_radial_choices
/turf/exterior/mud/dark/proc/cache_radial_shovel_interactions()
		var/image/radial_choice_tile    = image('icons/obj/hydroponics/hydroponics_machines.dmi', null, "soil",)
		var/image/radial_choice_extract = image('icons/obj/items/tool/shovels/shovel.dmi', ICON_STATE_WORLD)
		var/image/radial_choice_dig     = image('icons/obj/structures/pit.dmi', "pit1")
		radial_choice_tile.name    = "Tile Soil"
		radial_choice_extract.name = "Extract Clay"
		radial_choice_dig.name     = "Dig Pit"
		exterior_mud_dark_radial_choices = list("Tile Soil" = radial_choice_tile, "Extract Clay" = radial_choice_extract, "Dig Pit" = radial_choice_dig)

/turf/exterior/mud/dark/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/minihoe))
		if(user.do_skilled(8 SECONDS, SKILL_HAULING, src) && !QDELETED(W))
			to_chat(user, SPAN_NOTICE("You remove the muddy layer of the ground."))
			ChangeTurf(/turf/exterior/barren)
		return TRUE

	if(IS_SHOVEL(W))
		if((locate(/obj/machinery/portable_atmospherics/hydroponics/soil) in contents))
			to_chat(user, SPAN_WARNING("You can't manipulate the ground until you remove the plants here."))
			return TRUE

		var/obj/item/shovel/S = W
		if(!LAZYLEN(exterior_mud_dark_radial_choices))
			cache_radial_shovel_interactions()

		var/choice = show_radial_menu(user, src, global.exterior_mud_dark_radial_choices, "turf_what_do", require_near = TRUE, use_labels = TRUE)
		if(choice == "Tile Soil")
			//Create soil
			if(S.do_tool_interaction(/decl/tool_archetype/shovel, user, src, 10 SECONDS, "tiling", "tiling", null, null, SKILL_BOTANY, SKILL_ADEPT) && \
					!QDELETED(W) && \
					!(locate(/obj/machinery/portable_atmospherics/hydroponics/soil) in contents))
				new /obj/machinery/portable_atmospherics/hydroponics/soil(src)

		if(choice == "Extract Clay")
			//Extract mud
			if(S.do_tool_interaction(/decl/tool_archetype/shovel, user, src, 10 SECONDS, "digging out some clay", "digging out some clay", null, null, SKILL_HAULING))
				SSmaterials.create_object(/decl/material/solid/clay, src, 25)
				ChangeTurf(/turf/exterior/dry)

		if(choice == "Dig Pit")
			return ..() //Let after_attack do its thing
		return TRUE //Override normal shovel behavior

	if(istype(W, /obj/item/seeds))
		var/obj/item/seeds/S = W
		to_chat(user, SPAN_NOTICE("You begin planting some [S] on \the [src]..."))
		if(S.seed_type == "grass" && user.do_skilled(5 SECONDS, SKILL_BOTANY, src) && !QDELETED(S) && user.unequip(S))
			to_chat(user, SPAN_NOTICE("You finished planting \the [S]."))
			qdel(S)
			ChangeTurf(/turf/exterior/kleibkhar_grass)
		return TRUE
	. = ..()

//damp mud
/turf/exterior/mud/attackby(obj/item/W, mob/user)
	if(ATOM_IS_OPEN_CONTAINER(W) && ispath(W?.reagents?.primary_reagent, /decl/material/liquid/water) && W.reagents.has_reagent(/decl/material/liquid/water, 50))
		if(do_after(user, 2 SECONDS, src) && !QDELETED(W) && W.reagents.has_reagent(/decl/material/liquid/water, 50))
			W.reagents.remove_any(50)
			playsound(src, 'sound/effects/slosh.ogg', 50, TRUE)
			to_chat(user, SPAN_NOTICE("You soak \the [src]."))
			ChangeTurf(/turf/exterior/mud/dark)
		return TRUE
	. = ..()

//Dried mud
/turf/exterior/dry/attackby(obj/item/W, mob/user)
	if(ATOM_IS_OPEN_CONTAINER(W) && ispath(W?.reagents?.primary_reagent, /decl/material/liquid/water) && W.reagents.has_reagent(/decl/material/liquid/water, 50))
		if(do_after(user, 2 SECONDS, src) && !QDELETED(W) && W.reagents.has_reagent(/decl/material/liquid/water, 50))
			W.reagents.remove_any(50)
			playsound(src, 'sound/effects/slosh.ogg', 50, TRUE)
			to_chat(user, SPAN_NOTICE("You soak \the [src] and turns it into mud."))
			ChangeTurf(/turf/exterior/mud)
		return TRUE
	. = ..()

//Barren turf
//#FIXME: Ideally this would be handled by fluid stuff, but currently the system doesn't work. So no way to test it. Made this placeholder meanwhile.
/turf/exterior/barren/attackby(obj/item/W, mob/user)
	if(ATOM_IS_OPEN_CONTAINER(W) && ispath(W?.reagents?.primary_reagent, /decl/material/liquid/water) && W.reagents.has_reagent(/decl/material/liquid/water, 50))
		if(do_after(user, 2 SECONDS, src) && !QDELETED(W) && W.reagents.has_reagent(/decl/material/liquid/water, 50))
			W.reagents.remove_any(50)
			playsound(src, 'sound/effects/slosh.ogg', 50, TRUE)
			to_chat(user, SPAN_NOTICE("You soak \the [src] and turns it into mud."))
			ChangeTurf(/turf/exterior/mud)
		return TRUE
	. = ..()

#undef KLEIBKHAR_GRASS_EDGE_LAYER
#undef KLEIBKHAR_VEGETATION_CHANCE