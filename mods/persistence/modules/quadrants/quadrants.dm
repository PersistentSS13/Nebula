
/datum/overmap_quadrant
	var/name = "Overmap Quadrant"
	var/desc = "A description of the overmap that highlights exclusive imports, exports, materials or enemies. Also alludes to the default security and hostility level of the quadrant."
	var/datum/monster_table/monster_table = /datum/monster_table
	var/datum/asteroid_table/asteroid_table = /datum/asteroid_table
	var/datum/security_level/security_level = /datum/security_level
	var/datum/hostility_level/hostility_level = /datum/hostility_level
	var/list/bounds = list()

	var/default_sec_level = 1
	var/default_hostility_level = 0
	var/color = "#ff9900"

	var/list/active_hazards = list()
	var/starting_hazards = 0
	var/hazard_multiplier = 1
	var/spawn_ticks = 0
	var/host_ticks = 0
	var/list/adjacent_quadrants = list()

/obj/effect/overmap/event/meteor/quadrant
	color = "#ff9900"
	icon_state = "meteor1"

/obj/effect/overmap/event/meteor/quadrant/asteroid
	comet = 0

/obj/effect/overmap/event/meteor/quadrant/comet
	name = "comet field"
	comet = 1
	icon_state = "meteor2"
	color = "#2f00ff"

/datum/overmap_quadrant/New()

	monster_table = new monster_table()
	asteroid_table = new asteroid_table()
	security_level = new security_level()
	hostility_level = new hostility_level()

/datum/overmap_quadrant/proc/process()
	if(spawn_ticks >= 3) // each tick is 3 seconds? 9 second spawn timer?
		spawn_ticks = 0
	if(get_hostility_level() > default_hostility_level)
		host_ticks += 1
		if(host_ticks >= 10)
			host_ticks = 0
			lower_asteroid_host()

//		spawn_hazards()



/datum/overmap_quadrant/proc/check_tile(var/turf/T)
	if(T in bounds)
		return 1

/datum/overmap_quadrant/proc/get_security_level()
	return security_level.get_security_level(src)

/datum/overmap_quadrant/proc/get_hostility_level()
	return default_hostility_level + hostility_level.get_hostility_level(src)

/datum/overmap_quadrant/proc/get_asteroid()
	return asteroid_table.get_asteroid(get_hostility_level())

/datum/overmap_quadrant/proc/get_comet()
	return asteroid_table.get_comet(get_hostility_level())

/datum/overmap_quadrant/proc/lower_asteroid_host()
	if(hostility_level.asteroid_host) hostility_level.asteroid_host--

/datum/overmap_quadrant/proc/raise_asteroid_host()
	hostility_level.asteroid_host++


/datum/security_level
	var/list/modifiers = list()
	var/completed_exports = 0
	var/completed_criminal_exports = 0
	var/adjacent_completed_criminal_exports = 0

/datum/security_level/proc/get_security_level(var/datum/overmap_quadrant/quadrant)
	var/total = quadrant.default_sec_level
	total += completed_exports
	total -= completed_criminal_exports
	total -= adjacent_completed_criminal_exports
	return clamp(total, -5, 5)

/datum/security_level_modifier
	var/name = "Security Level Modifier"
	var/desc = "Description of why its modifying."
	var/effect = 0
	var/max = 5
	var/min = -5
/datum/security_level_modifier/proc/update()
	return 0

/datum/security_level_modifier/proc/get_effect()
	return effect

/datum/security_level_modifier/sold_out_exports
	name = "Successful Exports"
	desc = "Increases security by one each time all exports are sold out of a trade beacon. Effect decreases by one if a beacon resets with unfinished exports."

/datum/security_level_modifier/criminal_exports
	name = "Criminal Exports"
	desc = "Decreases security by one each time any criminal export is fufilled at an illegal trade beacon. Effect decreases by one if a criminal beacon resets with unfinished exports."


/datum/hostility_level
	var/list/modifiers = list()
	var/asteroid_host = 0

/datum/hostility_level/proc/get_hostility_level/(var/datum/overmap_quadrant/quadrant)
	var/total = asteroid_host
	for(var/datum/hostility_level_modifier/mod in modifiers)
		total += mod.get_effect()
	return clamp(total, 0, 5)


/datum/hostility_level_modifier
	var/name = "Hostility Level Modifier"
	var/desc = "Description of why its modifying."
	var/effect = 0
/datum/hostility_level_modifier/proc/update()
	return 0

/datum/hostility_level_modifier/proc/get_effect()
	return effect



/datum/monster_table
	var/name = "Monster Table"
	var/max_monsters = 3
	var/list/possible_monsters = list()
	var/list/active_monsters = list()
	var/list/monster_types = list()

/datum/monster_table/proc/update_active_monsters()
	active_monsters.Cut()
	for(var/datum/monster_choice/monster in possible_monsters)
		if(monster.valid_choice(src))
			active_monsters |= monster

/datum/monster_choice
	var/list/encounter_setup = list(/mob/living/simple_animal/hostile/carp = 3) // type = numbertospawn

	var/min_sec_level = -5
	var/max_sec_level = 5
	var/min_host_level = 0
	var/max_host_level = 1

/datum/monster_choice/proc/valid_choice(var/datum/overmap_quadrant/quadrant)
	if(quadrant.get_security_level() < min_sec_level) return 0
	if(quadrant.get_security_level() > max_sec_level) return 0
	if(quadrant.get_hostility_level() < min_host_level) return 0
	if(quadrant.get_hostility_level() > max_host_level) return 0
	return 1

/datum/asteroid_table
	var/list/possible_asteroids = list()
	var/list/possible_comets = list()
	var/node_replenishment = 2
/datum/asteroid_table/proc/get_asteroid(var/host)
	for(var/x in possible_asteroids)
		if(host <= possible_asteroids[x])
			return x

/datum/asteroid_table/proc/get_comet(var/host)
	for(var/x in possible_comets)
		if(host <= possible_comets[x])
			return x

/datum/asteroid_table/irongas_safe
	possible_asteroids = list(/decl/asteroid_class/asteroid/ironcarbon = 5)
	possible_comets = list(/decl/asteroid_class/comet/gas = 5)

/datum/asteroid_table/coppergas_safe
	possible_asteroids = list(/decl/asteroid_class/asteroid/copperdense = 5)
	possible_comets = list(/decl/asteroid_class/comet/gas = 5)


/datum/asteroid_table/ironliquid
	possible_asteroids = list(/decl/asteroid_class/asteroid/ironcarbon = 3, /decl/asteroid_class/asteroid/phoron_low = 4, /decl/asteroid_class/asteroid/phoron_high = 5)
	possible_comets = list(/decl/asteroid_class/comet/liquid = 5)

/datum/asteroid_table/coppergas
	possible_asteroids = list(/decl/asteroid_class/asteroid/copperdense = 3, /decl/asteroid_class/asteroid/phoron_low = 4, /decl/asteroid_class/asteroid/phoron_high = 5)
	possible_comets = list(/decl/asteroid_class/comet/gas = 5)

/datum/asteroid_table/shimmeringliquid
	possible_asteroids = list(/decl/asteroid_class/asteroid/shimmeringdense = 3, /decl/asteroid_class/asteroid/phoron_low = 4, /decl/asteroid_class/asteroid/phoron_high = 5)
	possible_comets = list(/decl/asteroid_class/comet/liquid = 5)



/datum/overmap_quadrant/southernrim
	name = "Southern Rim"
	desc = "The southern rim of the Frontier system is plagued by GREEDs and other hostile life forms. SolGov was forced out of this region after a defensive bastion was betrayed to darkness."
	color = "#fa0000"
	adjacent_quadrants = list("Neutral Zone", "Alpha Quadrant", "Domdaniel", "Hopeful Landing")
	asteroid_table = /datum/asteroid_table/shimmeringliquid

/datum/overmap_quadrant/neutralzone
	name = "Neutral Zone"
	desc = "The neutral zone is a neutral territory uncontrolled by either Solgov, Agartha or the rouge Vox AI. It's naturally hostile to life of any kind."
	color = "#3ec2ff"
	adjacent_quadrants = list("Southern Rim", "Border Territory", "Wild Space", "Buffer Zone")
	asteroid_table = /datum/asteroid_table/coppergas

/datum/overmap_quadrant/domdaniel
	name = "Domdaniel"
	desc = "Rare and mysterious dealings have been done in the Domdaniel. SolgGov struggles to maintain security in this region and if they slip any further the riches and secrets of this region will be left to those who can survive."
	color = "#da5d97"
	adjacent_quadrants = list("Southern Rim", "Hamlet Jean", "The Peel", "Buffer Zone")
	asteroid_table = /datum/asteroid_table/coppergas

/datum/overmap_quadrant/bufferzone
	name = "Buffer Zone"
	desc = "The buffer zone was originally designated to protect SolGov interests in the region and extended all the way to Hopeful Landing. Since being cutoff from SolGov, the Terrans have put up trade beacons in the area."
	color = "#ff7300"
	adjacent_quadrants = list("Domdaniel", "Hamlet Jean", "The Peel", "Neutral Zone")
	asteroid_table = /datum/asteroid_table/ironliquid

/datum/overmap_quadrant/hopefullanding
	name = "Hopeful Landing"
	desc = "When the Bluespace bubble collapsed, SolGov forces rushed into the system and first rallied within this Quadrant. The region was named during the seventeen hours prior to the start of the Phoron war."
	color = "#2f00ff"
	adjacent_quadrants = list("Southern Rim", "Alpha Quadrant", "The Peel", "Xanadu Zone")
	asteroid_table = /datum/asteroid_table/irongas_safe

/datum/overmap_quadrant/thepeel
	name = "The Peel"
	color = "#aef30d"
	desc = "A long stretch of space near the center of the system, this was once the center of conflict between the Terrans and Solgov. This area is unique as it's trade beacon is the only one useable by outside MegaCorps to do business in the frontier."
	adjacent_quadrants = list("Hamlet Jean", "Hopeful Landing", "Domdaniel", "Xanadu Zone")
	asteroid_table = /datum/asteroid_table/ironliquid

/datum/overmap_quadrant/xanadu
	name = "Xanadu Zone"
	color = "#3866ff"
	desc = "This area is designated to protect the only stable planet in the Frontier; Xanadu. It is governed by both Solgov and the Terran Agarthans making it one of the most secure sectors in the Frontier."
	adjacent_quadrants = list("Hopeful Landing", "The Peel", "Alpha Quadrant", "Wild Space")
	asteroid_table = /datum/asteroid_table/irongas_safe

/datum/overmap_quadrant/alphaquadrant
	name = "Alpha Quadrant"
	color = "#138308"
	desc = "This quadrant was first named five years ago by the group of colonists Nanotrasen trapped in the frontier. The mega-asteroid that proved so rich in Phoron has split and diffused it's evil across the quadrant."
	adjacent_quadrants = list("Xanadu Zone", "Southern Rim", "Beta Quadrant", "Wild Space")
	asteroid_table = /datum/asteroid_table/shimmeringliquid
/datum/overmap_quadrant/betaquadrant
	name = "Beta Quadrant"
	color = "#be9200"
	desc = "The infamous Beta Quadrant is where the Terrans first broke in to the frontier. They found the Nanotrasen Colonists but also one of the greater evils of the frontier. This region is still scarred by the terrible weaponry loosed in that initial conflict."
	adjacent_quadrants = list("Border Territory", "Alpha Quadrant", "Wild Space")
	asteroid_table = /datum/asteroid_table/coppergas
/datum/overmap_quadrant/wildspace
	name = "Wild Space"
	color = "#111935"
	desc = "The Terrans held the line at Hamlet Jean so staunchly that the creatures began to amass within the space adjacent to it. This area became known as Wild Space as it has never been worth exploring for either SolGov or the Terrans."
	adjacent_quadrants = list("Border Territory", "Alpha Quadrant", "Beta Quadrant", "Trasen Territory")
	asteroid_table = /datum/asteroid_table/coppergas
/datum/overmap_quadrant/hamletjean
	name = "Hamlet Jean"
	color = "#fefeff"
	desc = "The Terrans prioritized the security of Hamlet Jean and the lines of reinforcement that led to it throughout the Phoron War. The history extreme protection of this region is still reflected in its naturally high security."
	adjacent_quadrants = list("The Peel", "Buffer Zone", "Domdaniel", "Trasen Territory")
	asteroid_table = /datum/asteroid_table/ironliquid

/datum/overmap_quadrant/trasenterritory
	name = "Trasen Territory"
	color = "#070101"
	desc = "This mysterious region was once held by the Nanotrasen Warlords; the elite members of Nanotrasen who came to the Frontier decades ago. They were betrayed at the end of the Phoron war by the rouge Vox AI leaving this region in chaos."
	adjacent_quadrants = list("Border Territory", "Hamlet Jean", "Wild space", "Neutral Zone")
	asteroid_table = /datum/asteroid_table/ironliquid

/datum/overmap_quadrant/borderterritory
	name = "Border Territory"
	color = "#2bff00"
	desc = "This edge of the frontier is said to border the impossible space where the rouge Vox AI now resides. It's unknown how the minions of the synthetic intelligence infiltrate the frontier, but they do so in extreme concentration here."
	adjacent_quadrants = list("Neutral Zone", "Wild Space", "Beta Quadrant", "Trasen Territory")
	asteroid_table = /datum/asteroid_table/shimmeringliquid

/obj/effect/quadrant_border
	name = "quadrant"
	icon = 'icons/misc/overmap_icons.dmi'
	icon_state = "quadrant"
	layer = TURF_LAYER+0.1

/obj/effect/quadrant_title
	name = "quadrant"
	icon = 'icons/misc/overmap_titles.dmi'
	icon_state = "southern_rim"
	layer = TURF_LAYER+0.2

/obj/effect/quadrant_title/southernrim
	name = "Southern Rim"
	icon_state = "southern_rim"
	color = "#6f9fd6"

/obj/effect/quadrant_title/neutralzone
	name = "Neutral Zone"
	color = "#4a4b26"
	icon_state = "neutral_zone"

/obj/effect/quadrant_title/domdaniel
	name = "Domdaniel"
	color = "#13533e"
	icon_state = "domdaniel"

/obj/effect/quadrant_title/bufferzone
	name = "Buffer Zone"
	color = "#7a8683"
	icon_state = "buffer_zone"

/obj/effect/quadrant_title/hopefullanding
	name = "Hopeful Landing"
	color = "#3a0000"
	icon_state = "hopeful_landing"

/obj/effect/quadrant_title/thepeel
	name = "The Peel"
	color = "#ffb06f"
	icon_state = "the_peel"


/obj/effect/quadrant_title/xanadu
	name = "Xanadu Zone"
	color = "#c300ff"
	icon_state = "xanadu_zone"

/obj/effect/quadrant_title/alphaquadrant
	name = "Alpha Quadrant"
	color = "#4b0539"
	icon_state = "alpha_quadrant"

/obj/effect/quadrant_title/betaquadrant
	name = "Beta Quadrant"
	color = "#10151b"
	icon_state = "beta_quadrant"

/obj/effect/quadrant_title/wildspace
	name = "Wild Space"
	color = "#a4a6a8"
	icon_state = "wild_space"

/obj/effect/quadrant_title/hamletjean
	name = "Hamlet Jean"
	color = "#6d1b58"
	icon_state = "hamlet_jean"

/obj/effect/quadrant_title/trasenterritory
	name = "Trasen Territory"
	color = "#f4f817"
	icon_state = "trasen_territory"

/obj/effect/quadrant_title/borderterritory
	name = "Border Territory"
	color = "#011966"
	icon_state = "border_territory"


var/global/list/all_quadrant_turfs = list()
/obj/effect/quadrant_border/Initialize()
	if(isturf(loc))
		all_quadrant_turfs |= src

/obj/effect/quadrant_border/southernrim
	name = "Southern Rim"
	color = "#fa0000"

/obj/effect/quadrant_border/neutralzone
	name = "Neutral Zone"
	color = "#3ec2ff"

/obj/effect/quadrant_border/domdaniel
	name = "Domdaniel"
	color = "#da5d97"

/obj/effect/quadrant_border/bufferzone
	name = "Buffer Zone"
	color = "#9900ff"

/obj/effect/quadrant_border/hopefullanding
	name = "Hopeful Landing"
	color = "#2f00ff"

/obj/effect/quadrant_border/thepeel
	name = "The Peel"
	color = "#aef30d"

/obj/effect/quadrant_border/xanadu
	name = "Xanadu Zone"
	color = "#3866ff"

/obj/effect/quadrant_border/alphaquadrant
	name = "Alpha Quadrant"
	color = "#138308"

/obj/effect/quadrant_border/betaquadrant
	name = "Beta Quadrant"
	color = "#be9200"

/obj/effect/quadrant_border/wildspace
	name = "Wild Space"
	color = "#111935"

/obj/effect/quadrant_border/hamletjean
	name = "Hamlet Jean"
	color = "#ffffff"

/obj/effect/quadrant_border/trasenterritory
	name = "Trasen Territory"
	color = "#070101"

/obj/effect/quadrant_border/borderterritory
	name = "Border Territory"
	color = "#2bff00"