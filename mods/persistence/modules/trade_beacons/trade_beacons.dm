/atom/proc/get_adjacent_trade_beacons()
	var/list/adjacent_trade_beacons = list()
	var/atom/target = src
	if(!istype(src, /turf))
		target = get_turf(src)
	var/obj/ob = target.get_owning_overmap_object()
	if(ob)
		var/turf/T = get_turf(ob)
		if(T)
			for(var/obj/beacon in SStrade_beacons.all_trade_beacons)
				var/turf/beacon_turf = get_turf(beacon)
				if(beacon_turf && beacon_turf.Adjacent(T))
					adjacent_trade_beacons |= beacon
	return adjacent_trade_beacons

/obj/effect/overmap/trade_beacon
	name = "Trade Beacon"
	var/list/possible_imports = list() // structure is list(/datum/beacon_import/example = 100) list(type = percentage chance of appearing).
	var/list/possible_exports = list()
	var/list/active_imports = list()
	var/list/active_exports = list()
	icon = 'icons/misc/overmap_icons.dmi'
	icon_state = "beacon"
	var/datum/extension/network_device/trade_controller/linked_controller
	var/datum/money_account/beacon_account
	desc = "A generic trade beacon."
	color = "#623eff"

/obj/effect/overmap/trade_beacon/Destroy()
	if(SStrade_beacons && SStrade_beacons.all_trade_beacons)
		SStrade_beacons.all_trade_beacons.Remove(src)
	QDEL_NULL(beacon_account)
	QDEL_NULL_LIST(active_imports)
	QDEL_NULL_LIST(active_exports)
	..()


/obj/effect/overmap/trade_beacon/Initialize()
	beacon_account = new()
	beacon_account.account_name = name
	regenerate_imports()
	regenerate_exports()
	. = ..()

/obj/effect/overmap/trade_beacon/proc/get_security_level()
	var/datum/overmap_quadrant/quadrant = SSquadrants.get_quadrant(loc)
	if(quadrant)
		return quadrant.get_security_level()

/obj/effect/overmap/trade_beacon/proc/finish_export(var/export)
	src.active_exports.Remove(export)
	if(!active_exports.len)
		var/datum/overmap_quadrant/quadrant = SSquadrants.get_quadrant(loc)
		if(quadrant.security_level.completed_exports <= 5)
			quadrant.security_level.completed_exports++


/obj/effect/overmap/trade_beacon/proc/regenerate_imports()
	if(!active_imports) active_imports = list()
	active_imports.Cut()
	for(var/import in possible_imports)
		if(!prob(possible_imports[import])) continue
		var/datum/beacon_import/import_m = new import()
		if(import_m.valid_choice(SSquadrants.get_quadrant(loc))) active_imports |= import_m



/obj/effect/overmap/trade_beacon/proc/regenerate_exports()
	if(active_exports)
		var/datum/overmap_quadrant/quadrant = SSquadrants.get_quadrant(loc)
		if(quadrant.security_level.completed_exports && active_exports.len)
			quadrant.security_level.completed_exports--
		if(quadrant.security_level.adjacent_completed_criminal_exports)
			quadrant.security_level.adjacent_completed_criminal_exports--
	if(!active_exports) active_exports = list()
	active_exports.Cut()
	for(var/export in possible_exports)
		if(!prob(possible_exports[export])) continue
		var/datum/beacon_export/export_m = new export()
		if(export_m.valid_choice(SSquadrants.get_quadrant(loc)))	active_exports |= export_m

//////////////////////////////// BEACONS

/obj/effect/overmap/trade_beacon/criminal
	icon_state = "derelict_beacon"
	color = "#ff0000"

/obj/effect/overmap/trade_beacon/criminal/finish_export(var/export)
	src.active_exports.Remove(export)
	var/datum/overmap_quadrant/quadrant = SSquadrants.get_quadrant(loc)
	quadrant.security_level.completed_criminal_exports += 2
	quadrant.security_level.completed_criminal_exports = clamp(quadrant.security_level.completed_criminal_exports , 0, 6)
	var/list/adjacent = SSquadrants.get_adjacent_quadrants(quadrant)
	for(var/datum/overmap_quadrant/adjacent_quadrant in adjacent)
		if(adjacent_quadrant.security_level.adjacent_completed_criminal_exports <= 5)
			adjacent_quadrant.security_level.adjacent_completed_criminal_exports++

/obj/effect/overmap/trade_beacon/criminal/regenerate_exports()
	if(active_exports && active_exports.len)
		var/datum/overmap_quadrant/quadrant = SSquadrants.get_quadrant(loc)
		if(quadrant.security_level.completed_criminal_exports)
			quadrant.security_level.completed_criminal_exports--
	if(!active_exports) active_exports = list()
	active_exports.Cut()
	for(var/export in possible_exports)
		if(!prob(possible_exports[export])) continue
		var/datum/beacon_export/export_m = new export()
		if(export_m.valid_choice(SSquadrants.get_quadrant(loc)))	active_exports |= export_m



/obj/effect/overmap/trade_beacon/criminal/crone
	name = "The Crones Office"
	desc = "A mysterious witch operates this hacked beacon to collect materials and reagents. She's been trapped out here for years at this point."
	possible_imports = list(
		/datum/beacon_import/clothing/hat/plaguedoctorhat = 40,	// evil
		/datum/beacon_import/clothing/hat/hasturhood = 40, // evil
		/datum/beacon_import/clothing/hat/witchwig = 40, // evil
		/datum/beacon_import/clothing/hat/richard = 40, // evil
		/datum/beacon_import/clothing/hat/facecover = 40,// infil
		/datum/beacon_import/clothing/hat/welding/demon = 40, // fun
		/datum/beacon_import/clothing/glasses/blindfold = 40, // cult
		/datum/beacon_import/clothing/mask/muzzle = 40, // evil
		/datum/beacon_import/clothing/mask/pig = 40, // evil
		/datum/beacon_import/clothing/mask/spirit = 40, // cult
		/datum/beacon_import/clothing/shoes/cult = 40, // cult
		/datum/beacon_import/clothing/suit/hastur = 40, // evil
		/datum/beacon_import/clothing/suit/straight_jacket = 40, // evil
		/datum/beacon_import/clothing/accessory/knifeharness = 40,  // cult
		/datum/beacon_import/clothing/storage/backpack/cultpack = 40 // evil cult

	)
	possible_exports = list(
		/datum/beacon_export/liquid_material/gleam = 25,
		/datum/beacon_export/liquid_material/amphetamines = 25,
		/datum/beacon_export/liquid_material/psychotropics = 25,
		/datum/beacon_export/liquid_material/hallucinogenics = 25,
		/datum/beacon_export/solid_material/phoron_criminal_low = 60,
		/datum/beacon_export/solid_material/phoron_criminal_mid = 60,
		/datum/beacon_export/solid_material/phoron_criminal_high = 60
	)


/obj/effect/overmap/trade_beacon/criminal/portfranco
	name = "Port Franco"
	desc = "A group of free spirited pirates operate this salvaged beacon. They roam the hidden routes to sell products that shouldn't be sold."
	possible_imports = list(
		/datum/beacon_import/seeds/reishimycelium = 60,
		/datum/beacon_import/seeds/amanitamycelium = 60,
		/datum/beacon_import/seeds/glowbell = 60,
		/datum/beacon_import/seeds/ambrosiavulgaris = 60,
		/datum/beacon_import/clothing/hat/piratecaptainhat = 40, // pirate
		/datum/beacon_import/clothing/hat/piratebandana = 40, // pirate
		/datum/beacon_import/clothing/hat/greenbandana = 40, // pirate
		/datum/beacon_import/clothing/hat/orangebandana = 40, // pirate
		/datum/beacon_import/clothing/glasses/eyepatch = 40, // pirate
		/datum/beacon_import/clothing/glasses/eyepatch/hud = 40, // pirate
		/datum/beacon_import/clothing/mask/bandana = 40, // pirate
		/datum/beacon_import/clothing/mask/bandana/skull = 40, // pirate
		/datum/beacon_import/clothing/suit/pirate = 40, // pirate
		/datum/beacon_import/clothing/suit/hgpirate = 40, // pirate
		/datum/beacon_import/clothing/under/captain_fly = 40, // evil pirate
		/datum/beacon_import/clothing/under/pirate = 40 // pirate

	)
	possible_exports = list(
		/datum/beacon_export/liquid_material/gleam = 25,
		/datum/beacon_export/liquid_material/psychoactives = 25,
		/datum/beacon_export/liquid_material/narcotics = 25,
		/datum/beacon_export/liquid_material/hallucinogenics = 25,
		/datum/beacon_export/liquid_material/phorophedamine = 60,
		/datum/beacon_export/liquid_material/bluespice = 60,
	)



/obj/effect/overmap/trade_beacon/criminal/syndicate
	name = "The Syndicate Beacon"
	desc = "This suspicous beacon appears to be automated. It buys and sells a variety of contraband, depending on the security level of the Quadrant."
	possible_imports = list(
		/datum/beacon_import/clothing/hat/infilhat = 40, // infil
		/datum/beacon_import/clothing/suit/infilsuit = 40, // infil
		/datum/beacon_import/clothing/under/infil = 40, // infil
		/datum/beacon_import/clothing/hat/infilhat/fem = 40, // infil
		/datum/beacon_import/clothing/suit/infilsuit/fem = 40, // infil
		/datum/beacon_import/clothing/under/infil/fem = 40, // infil
		/datum/beacon_import/clothing/mask/balaclava = 40, // infil
		/datum/beacon_import/clothing/mask/rubber/barros = 40, // infil
		/datum/beacon_import/clothing/mask/rubber/admiral = 40, // infil
		/datum/beacon_import/clothing/mask/rubber/turner = 40, // infil
		/datum/beacon_import/clothing/storage/backpack/satchel/flat = 40 // evil pirate crime
	)
	possible_exports = list(
		/datum/beacon_export/liquid_material/gleam = 25,
		/datum/beacon_export/liquid_material/paralytics = 25,
		/datum/beacon_export/liquid_material/presyncopics = 25,
		/datum/beacon_export/liquid_material/hallucinogenics = 25,
		/datum/beacon_export/solid_material/nebu_crminal_mid = 60,
		/datum/beacon_export/solid_material/nebu_crminal_high = 60,
	)


/obj/effect/overmap/trade_beacon/dictashipwright
	name = "Queen Dicta's Royal Shipwright"
	desc = "Even though the crown corperation of SolGov is not permitted to sell ships directly, they can still provide quality parts and circuits to the enterprising frontiersfolk. They also sell excess bluespace crystals collected by SolGov within the Frontier, and purchase phoron."

	possible_imports = list(
		/datum/beacon_import/dicta/engine = 100,
		/datum/beacon_import/dicta/computers = 100,
		/datum/beacon_import/dicta/pointdefense = 100,
		/datum/beacon_import/dicta/shieldgenerator = 100,
		/datum/beacon_import/bluespacecrystal_low = 100
	)
	possible_exports = list(
		/datum/beacon_export/solid_material/phoron_low = 100
	)

/obj/effect/overmap/trade_beacon/gerena // xanadu
	name = "Gerena General Supplies"
	desc = "Named after the first planet liberated by the Terrans, Gerena is also where a lot of these supplies are manufactured, mined or produced. The Terran Federation is happy to help the brave colonists of the frontier."
	possible_imports = list(
		/datum/beacon_import/gerena/mining_drill = 100,
		/datum/beacon_import/gerena/mining_equipment = 100,
		/datum/beacon_import/clothing/storage/backpack/generic = 100, // fun
		/datum/beacon_import/clothing/storage/wallet = 100,
		/datum/beacon_import/clothing/gloves/insulated/cheap = 100, // job engi
		/datum/beacon_import/clothing/spacesuit = 100, // eva
		/datum/beacon_import/clothing/under/serviceoveralls = 40, // fun
		/datum/beacon_import/clothing/hat/flatcap = 40, // fun
		/datum/beacon_import/clothing/hat/soft = 40, // fun
		/datum/beacon_import/clothing/gloves/color = 40, // fun
		/datum/beacon_import/clothing/shoes/color = 40, // fun
		/datum/beacon_import/clothing/suit/overalls = 40, // fun
		/datum/beacon_import/clothing/under/overalls = 40, // fun
		/datum/beacon_import/clothing/under/frontier = 40, // fun
		/datum/beacon_import/clothing/under/hazard = 40, // fun
		/datum/beacon_import/clothing/under/color = 40, // fun
		/datum/beacon_import/clothing/under/cargotech = 40, // job cargo
		/datum/beacon_import/clothing/under/janitor = 40, // fun
		/datum/beacon_import/clothing/under/hydroponics = 40, // fun
		/datum/beacon_import/clothing/suit/hoodie = 40, // fun
		/datum/beacon_import/clothing/accessory/scarf = 40, // fun
		/datum/beacon_import/clothing/under/pj/blue = 40, // fun
		/datum/beacon_import/clothing/under/pj = 40, // fun
		/datum/beacon_import/clothing/under/waiter = 40, // fun
		/datum/beacon_import/clothing/storage/backpack/dufflebag/generic = 40, // fun
		/datum/beacon_import/clothing/storage/backpack/satchel/generic = 40, // fun
		/datum/beacon_import/clothing/storage/backpack/satchel/pocketbook/generic = 40, // fun
		/datum/beacon_import/clothing/storage/backpack/messenger = 40 // fun
	)
	possible_exports = list(
		/datum/beacon_export/solid_material/phoron_low = 100
	)
/obj/effect/overmap/trade_beacon/huntershall // border territory
	name = "Hunters Hall"
	desc = "A sect of poly-religious fanatics control this beacon, buying flesh and bone and teeth and bile. They sell hunting equipment alongside religious clothing and materials."
	possible_imports = list(
		/datum/beacon_import/huntershall/smartfridge = 100,
		/datum/beacon_import/clothing/hat/bearpelt = 40, // hunter
		/datum/beacon_import/clothing/hat/xenos = 40, // hunter
		/datum/beacon_import/clothing/hat/welding/carp = 40,
		/datum/beacon_import/clothing/gloves/tactical = 40, // armor
		/datum/beacon_import/clothing/gloves/guards = 40, // armor
		/datum/beacon_import/clothing/spacesuit/voidsuit/merc = 40, // eva
		/datum/beacon_import/clothing/spacesuit/voidsuit/mining = 40,// eva
		/datum/beacon_import/clothing/head/xeno/scarf = 40, // hunter
		/datum/beacon_import/clothing/suit/xenos = 40, // hunter
		/datum/beacon_import/clothing/accessory/cloak/mining = 40, // hunter
		/datum/beacon_import/clothing/accessory/holster/machete = 40, // hunter
		/datum/beacon_import/clothing/accessory/holster/knife = 40, // hunter
		/datum/beacon_import/clothing/under/miner = 40, // hunter
		/datum/beacon_import/clothing/suit/armor/hos = 40, // military hunter
		/datum/beacon_import/clothing/under/savage_hunter = 40, // hunter
		/datum/beacon_import/clothing/under/savage_hunter/female = 40, // hunter
		/datum/beacon_import/clothing/hat/hijab = 40, // religion
		/datum/beacon_import/clothing/hat/kippa = 40, // religion
		/datum/beacon_import/clothing/hat/turban = 40, // religion
		/datum/beacon_import/clothing/hat/taqiyah = 40, // religion
		/datum/beacon_import/clothing/hat/rastacap = 40, // fun
		/datum/beacon_import/clothing/hat/chaplain_hood = 40, // religion
		/datum/beacon_import/clothing/hat/nun_hood = 40, // religion
		/datum/beacon_import/clothing/suit/robe = 40, // religion
		/datum/beacon_import/clothing/suit/chaplain_hoodie = 40, // religion
		/datum/beacon_import/clothing/suit/nun = 40, // religion
		/datum/beacon_import/clothing/suit/imperium_monk = 40,
		/datum/beacon_import/clothing/suit/holidaypriest = 40, // religion
		/datum/beacon_import/clothing/accessory/thawb = 40,// fun
		/datum/beacon_import/clothing/under/chaplain = 40, // religion
		/datum/beacon_import/clothing/under/abaya = 40, // religion
		/datum/beacon_import/bluespacecrystal_mid = 60,
		/datum/beacon_import/bluespacecrystal_high = 60
	)
	possible_exports = list(
		/datum/beacon_export/huntershall/greedmeat_basic = 100,
		/datum/beacon_export/solid_material/huntershall/greedleather_basic = 100,
		/datum/beacon_export/solid_material/huntershall/greedleather_mid = 60,
		/datum/beacon_export/huntershall/greedmeat_mid = 60,
		/datum/beacon_export/food_export/creamcheesebread = 20, // 32*2
		/datum/beacon_export/food_export/cheesyfries = 20, // 50*2
		/datum/beacon_export/food_export/candiedapple = 20, // 30*2
		/datum/beacon_export/liquid_material/retroviral = 20, // 44*2
		/datum/beacon_export/liquid_material/antiseptic = 20, // 45*2
		/datum/beacon_export/liquid_material/nanite = 20, // 48*2
		/datum/beacon_export/liquid_material/immunobooster = 20, // 35*2
		/datum/beacon_export/solid_material/iron = 20, // 32*2
		/datum/beacon_export/solid_material/bronze = 20, // 25*2
		/datum/beacon_export/solid_material/osmium = 20 // 19*2
	)

/obj/effect/overmap/trade_beacon/moonlight // buffer zone
	name = "Moonlight Beacon"
	desc = "This beacon is operated by men and women who first arrived with the Terrans first wave into the frontier. They have settled on a hidden moon and have become increasingly influenced by mysterious Faeren culture."
	possible_imports = list(
		/datum/beacon_import/moonlight/nebu_basic = 100,
		/datum/beacon_import/moonlight/nebu_mid = 60,
		/datum/beacon_import/moonlight/nebu_high = 25,
		/datum/beacon_import/clothing/accessory/tangzhuang, // fun
		/datum/beacon_import/clothing/accessory/dashiki = 40,// fun
		/datum/beacon_import/clothing/accessory/dashiki/red = 40, // fun
		/datum/beacon_import/clothing/accessory/dashiki/blue = 40, // fun
		/datum/beacon_import/clothing/accessory/qipao = 40, // fun
		/datum/beacon_import/clothing/under/cheongsam = 40, // fun
		/datum/beacon_import/clothing/under/kimono = 40, // fun
		/datum/beacon_import/clothing/hat/flowerpin/pink = 40,
		/datum/beacon_import/clothing/glasses/threedglasses = 40, // fun
		/datum/beacon_import/clothing/glasses/sunglasses = 40, // fun
		/datum/beacon_import/clothing/pants/casual/greyjeans = 40,// fun
		/datum/beacon_import/clothing/pants/casual/youngfolksjeans = 40,// fun
		/datum/beacon_import/clothing/pants/casual/track = 40,// fun
		/datum/beacon_import/clothing/pants/casual/track/blue = 40,// fun
		/datum/beacon_import/clothing/pants/casual/track/navy = 40, // fun
		/datum/beacon_import/clothing/pants/casual/track/red = 40, // fun
		/datum/beacon_import/clothing/pants/casual/baggy = 40, // fun
		/datum/beacon_import/clothing/pants/casual/baggy/classic = 40, // fun
		/datum/beacon_import/clothing/pants/casual/baggy/mustang = 40, // fun
		/datum/beacon_import/clothing/pants/casual/baggy/youngfolksjeans = 40, // fun
		/datum/beacon_import/clothing/pants/shorts/athletic = 40, // fun
		/datum/beacon_import/clothing/pants/baggy = 40, // fun
		/datum/beacon_import/clothing/shoes/slippers = 40, // fun
		/datum/beacon_import/clothing/suit/det_trench/grey = 40, // fun
		/datum/beacon_import/clothing/suit/bomber = 40, // fun
		/datum/beacon_import/clothing/suit/leather_jacket = 40, // fun
		/datum/beacon_import/clothing/suit/track/navy = 40, // fun
		/datum/beacon_import/clothing/suit/letterman = 40, // fun
		/datum/beacon_import/clothing/accessory/necklace = 40, // fun
		/datum/beacon_import/clothing/accessory/cloak = 40, // fun
		/datum/beacon_import/clothing/accessory/bracelet = 40, // fun
		/datum/beacon_import/clothing/accessory/wcoat = 40, // fun
		/datum/beacon_import/clothing/accessory/long = 40, // fun
		/datum/beacon_import/clothing/accessory/horrible = 40, // fun
		/datum/beacon_import/clothing/accessory/bowtie  = 40,// fun
		/datum/beacon_import/clothing/accessory/bowtie/ugly  = 40,// fun
		/datum/beacon_import/clothing/under/bartender  = 40,// job service
		/datum/beacon_import/clothing/head/det/wack  = 40,// fun
		/datum/beacon_import/clothing/head/det/grey  = 40,// fun
		/datum/beacon_import/clothing/under/skirt = 40, // fun
		/datum/beacon_import/clothing/under/skirt/plaid_blue  = 40,// fun
		/datum/beacon_import/clothing/under/skirt/khaki  = 40,// fun
		/datum/beacon_import/clothing/under/skirt_c  = 40,// fun
		/datum/beacon_import/clothing/under/sundress = 40,// fun /datum/beacon_import/clothing/hat/flowerpin/pink
		/datum/beacon_import/clothing/glasses/threedglasses  = 40,// fun
		/datum/beacon_import/clothing/glasses/sunglasses = 40,// fun
		/datum/beacon_import/clothing/pants/casual/greyjeans = 40,// fun
		/datum/beacon_import/clothing/pants/casual/youngfolksjeans = 40,// fun
		/datum/beacon_import/clothing/pants/casual/track = 40,// fun
		/datum/beacon_import/clothing/pants/casual/track/blue = 40,// fun
		/datum/beacon_import/clothing/pants/casual/track/navy = 40, // fun
		/datum/beacon_import/clothing/pants/casual/track/red  = 40,// fun
		/datum/beacon_import/clothing/pants/casual/baggy = 40, // fun
		/datum/beacon_import/clothing/pants/casual/baggy/classic = 40, // fun
		/datum/beacon_import/clothing/pants/casual/baggy/mustang  = 40,// fun
		/datum/beacon_import/clothing/pants/casual/baggy/youngfolksjeans = 40, // fun
		/datum/beacon_import/clothing/pants/shorts/athletic = 40, // fun
		/datum/beacon_import/clothing/pants/baggy = 40, // fun
		/datum/beacon_import/clothing/shoes/slippers  = 40,// fun
		/datum/beacon_import/clothing/suit/det_trench/grey = 40, // fun
		/datum/beacon_import/clothing/suit/bomber = 40, // fun
		/datum/beacon_import/clothing/suit/leather_jacket = 40, // fun
		/datum/beacon_import/clothing/suit/track/navy = 40, // fun
		/datum/beacon_import/clothing/suit/letterman = 40, // fun
		/datum/beacon_import/clothing/accessory/necklace = 40, // fun
		/datum/beacon_import/clothing/accessory/cloak = 40, // fun
		/datum/beacon_import/clothing/accessory/bracelet = 40, // fun
		/datum/beacon_import/clothing/accessory/wcoat = 40, // fun
		/datum/beacon_import/clothing/accessory/long = 40, // fun
		/datum/beacon_import/clothing/accessory/horrible = 40, // fun
		/datum/beacon_import/clothing/accessory/bowtie = 40, // fun
		/datum/beacon_import/clothing/accessory/bowtie/ugly = 40, // fun
		/datum/beacon_import/clothing/under/bartender = 40, // job service
		/datum/beacon_import/clothing/head/det/wack = 40, // fun
		/datum/beacon_import/clothing/head/det/grey = 40, // fun
		/datum/beacon_import/clothing/under/skirt = 40, // fun
		/datum/beacon_import/clothing/under/skirt/plaid_blue = 40, // fun
		/datum/beacon_import/clothing/under/skirt/khaki = 40, // fun
		/datum/beacon_import/clothing/under/skirt_c = 40, // fun
		/datum/beacon_import/clothing/under/sundress = 40// fun
	)
	possible_exports = list(
		/datum/beacon_export/moonlight/mollusc_basic = 30,
		/datum/beacon_export/moonlight/clam_basic = 40,
		/datum/beacon_export/moonlight/barnacle_basic = 40,
		/datum/beacon_export/food_export/fishburger = 20,
		/datum/beacon_export/food_export/ricecake = 20,
		/datum/beacon_export/food_export/ricepudding = 20,
		/datum/beacon_export/solid_material/copper = 20,
		/datum/beacon_export/solid_material/redgold = 20,
		/datum/beacon_export/liquid_material/sedative = 20,
		/datum/beacon_export/liquid_material/neuroannealer = 20,
	)


/obj/effect/overmap/trade_beacon/alphaquad // alpha quad
	name = "Terran Alpha Quadrant Outpost"
	desc = "This beacon is controlled by a fortified batallion of Terran forces that try to contain the insanity of the Alpha Quadrant."
	possible_imports = list(
		 /datum/beacon_import/clothing/accessory/cloak/hos = 40, // fun
		/datum/beacon_import/clothing/accessory/holster/thigh = 40, // military
		/datum/beacon_import/clothing/accessory/webbing_large = 40, // military
		/datum/beacon_import/clothing/accessory/storage/vest = 40, // military
		/datum/beacon_import/clothing/accessory/bandolier = 40, // military
		/datum/beacon_import/clothing/under/warden = 40, // military
		/datum/beacon_import/clothing/head/warden = 40, // military
		/datum/beacon_import/clothing/under/head_of_security = 40, // military
		/datum/beacon_import/clothing/head/HoS = 40,// military
		/datum/beacon_import/clothing/suit/armor/hos = 40, // military hunter
		/datum/beacon_import/clothing/under/head_of_security/jensen = 40, // military
		/datum/beacon_import/clothing/suit/armor/hos/jensen = 40, // military hunter
		/datum/beacon_import/clothing/under/wetsuit = 40,// military
		/datum/beacon_import/clothing/storage/backpack/rucksack/tan = 40, // military
		/datum/beacon_import/clothing/storage/backpack/dufflebag/sec = 40, // military
		/datum/beacon_import/clothing/storage/backpack/satchel/sec = 40 // military
	)
	possible_exports = list( // AVG 144 AT NEUTRAL SEC LEVEL
		/datum/beacon_export/food_export/loaded_steak = 20, // 32*2
		/datum/beacon_export/food_export/hotdogs = 20, // 50*2
		/datum/beacon_export/food_export/burger = 20, // 30*2
		/datum/beacon_export/liquid_material/brutemed = 20, // 44*2
		/datum/beacon_export/liquid_material/antiburn = 20, // 45*2
		/datum/beacon_export/liquid_material/antirads = 20, // 48*2
		/datum/beacon_export/liquid_material/stimulants = 20, // 35*2
		/datum/beacon_export/solid_material/iron = 20, // 32*2
		/datum/beacon_export/solid_material/titanium = 20, // 25*2
		/datum/beacon_export/solid_material/blackbronze = 20, // 19*2
		/datum/beacon_export/solid_material/phoron_mid = 60,
		/datum/beacon_export/solid_material/phoron_high = 60
	)



/obj/effect/overmap/trade_beacon/corporateshipping // peel
	name = "Corporate Bluespace Shipping"
	desc = "This is the only quadrant where external megacorps are allowed to conducxt business with the Fronier; officially. This beacon is shared between them."
	possible_imports = list(
		/datum/beacon_import/clothing/hat/flowerpin/blue = 40,
		/datum/beacon_import/clothing/hat/flowerpin = 40,
		/datum/beacon_import/clothing/hat/flowerpin/yellow = 40,
		/datum/beacon_import/clothing/hat/beanie = 40, // fun
		/datum/beacon_import/clothing/hat/beret = 40, // fun
		/datum/beacon_import/clothing/ear/stud = 40, // fun
		/datum/beacon_import/clothing/ear/dangle = 40, // fun
		/datum/beacon_import/clothing/glasses/sunglasses/big = 40, // fun
		/datum/beacon_import/clothing/gloves/color/evening = 40, // fun
		/datum/beacon_import/clothing/pants/casual/classicjeans = 40,// fun
		/datum/beacon_import/clothing/pants/casual/mustangjeans = 40,// fun
		/datum/beacon_import/clothing/pants/casual/blackjeans = 40,// fun
		/datum/beacon_import/clothing/pants/casual/baggy/black = 40, // fun
		/datum/beacon_import/clothing/pants/casual/baggy/grey = 40, // fun
		/datum/beacon_import/clothing/shoes/color/hightops = 40, // fun
		/datum/beacon_import/clothing/shoes/sandal = 40, // fun
		/datum/beacon_import/clothing/suit/brown_jacket = 40, // fun
		/datum/beacon_import/clothing/suit/track/blue = 40, // fun
		/datum/beacon_import/clothing/suit/track = 40, // fun
		/datum/beacon_import/clothing/suit/track/red = 40,// fun
		/datum/beacon_import/clothing/suit/det_trench = 40, // fun
		/datum/beacon_import/clothing/accessory/suspenders = 40,// fun
		/datum/beacon_import/clothing/accessory/sweater = 40, // fun
		/datum/beacon_import/clothing/accessory = 40, // fun
		/datum/beacon_import/clothing/under/turtleneck = 40, // fun
		/datum/beacon_import/clothing/head/det = 40, // fun
		/datum/beacon_import/clothing/under/skirt/plaid_red = 40, // fun
		/datum/beacon_import/clothing/under/skirt/plaid_purple = 40, // fun
		/datum/beacon_import/clothing/under/skirt/swept = 40, // fun
		/datum/beacon_import/clothing/under/sundress_white = 40,// fun
		/datum/beacon_import/clothing/under/blackjumpskirt = 40, // fun
		/datum/beacon_import/clothing/under/shortjumpskirt = 40, // fun
		/datum/beacon_import/clothing/under/sweater = 40, // fun
		/datum/beacon_import/clothing/storage/wallet/poly = 40,
		/datum/beacon_import/clothing/gloves/boxing = 60, // boxing
		/datum/beacon_import/clothing/mask/luchador = 40, // boxing
		/datum/beacon_import/clothing/mask/luchador/tecnicos = 40, // boxing
		/datum/beacon_import/clothing/mask/luchador/rudos = 40, // boxing
		/datum/beacon_import/clothing/suit/bluetag = 40, // boxing
		/datum/beacon_import/clothing/suit/redtag = 40, // boxing
		/datum/beacon_import/clothing/under/gladiator = 40 // boxing
	)
	possible_exports = list( // AVG 143.2 AT NEUTRAL SEC LEVEL
		/datum/beacon_export/food_export/spaget = 20, // 55*2
		/datum/beacon_export/food_export/donut = 20, // 40*2
		/datum/beacon_export/food_export/loaded_steak = 20, // 32*1
		/datum/beacon_export/liquid_material/nanite = 20, // 45*2
		/datum/beacon_export/liquid_material/neuroannealer = 20, // 20*2
		/datum/beacon_export/liquid_material/regenerator = 20, // 43*2
		/datum/beacon_export/liquid_material/pacid = 20, // 33*2
		/datum/beacon_export/solid_material/aluminium = 20, // 30*2
		/datum/beacon_export/solid_material/silver = 20, // 18*2
		/datum/beacon_export/solid_material/stainless_steel = 20, // 21*2
		/datum/beacon_export/food_export/cake_cheese = 20, // 36*2
		/datum/beacon_export/solid_material/nebu_mid = 60,
		/datum/beacon_export/solid_material/nebu_high = 60
	)



/obj/effect/overmap/trade_beacon/terrantitan // beta quad
	name = "Terran Titan Command"
	desc = "This beacon is used by the headquarters of the Terran Titans. They need rations and basic materials, but may ask for more if the security level is raised here."
	possible_imports = list(
		/datum/beacon_import/clothing/pants/casual/camo = 40, // military
		/datum/beacon_import/clothing/pants/casual/baggy/camo = 40, // military
		/datum/beacon_import/clothing/shoes/jackboots = 40, // armor
		/datum/beacon_import/clothing/accessory/shouldercape = 40, // military
		/datum/beacon_import/clothing/accessory/shouldercape/officer = 40, // military
		/datum/beacon_import/clothing/accessory/shouldercape/command = 40, // military
		/datum/beacon_import/clothing/accessory/shouldercape/general = 40, // military
		/datum/beacon_import/clothing/hat/tankcap = 40, // mil
		/datum/beacon_import/clothing/glasses/hud/jensenshades = 40, // job det
		/datum/beacon_import/clothing/gloves/forensic = 40, // job det
		/datum/beacon_import/clothing/gloves/tactical = 40, // armor
		/datum/beacon_import/clothing/mask/bandana/camo = 40, // military
		/datum/beacon_import/clothing/accessory/ubac = 40,
		/datum/beacon_import/clothing/accessory/ubac/blue = 40, // military
		/datum/beacon_import/clothing/accessory/ubac/tan = 40, // military
		/datum/beacon_import/clothing/accessory/ubac/green = 40, // military
		/datum/beacon_import/clothing/accessory/holster = 40, // military
		/datum/beacon_import/clothing/accessory/holster/waist = 40, // military
		/datum/beacon_import/clothing/under/security = 40, // military
		/datum/beacon_import/clothing/under/security2 = 40, // military
		/datum/beacon_import/clothing/under/tactical = 40, // military
		/datum/beacon_import/clothing/storage/backpack/security = 40, // military
		/datum/beacon_import/clothing/storage/backpack/rucksack = 40, // military
		/datum/beacon_import/clothing/storage/backpack/rucksack/blue = 40, // military
		/datum/beacon_import/clothing/storage/backpack/rucksack/green = 40, // military
		/datum/beacon_import/clothing/storage/backpack/rucksack/navy = 40, // military
		/datum/beacon_import/bluespacecrystal_mid = 60,
		/datum/beacon_import/bluespacecrystal_high = 60
	)
	possible_exports = list( // AVG 131.2 AT NEUTRAL SEC LEVEL
		/datum/beacon_export/food_export/stew_big = 20, // 95*1
		/datum/beacon_export/food_export/cake_apple = 20, // 36*2
		/datum/beacon_export/food_export/fries = 20, // 37*2
		/datum/beacon_export/liquid_material/adrenaline = 20, // 44*2
		/datum/beacon_export/liquid_material/oxygel = 20, // 34*2
		/datum/beacon_export/liquid_material/immunobooster = 20, // 26*2
		/datum/beacon_export/liquid_material/stabilizer = 20, // 36*2
		/datum/beacon_export/solid_material/bronze = 20, // 23*2
		/datum/beacon_export/solid_material/brass = 20, // 20*2
		/datum/beacon_export/solid_material/osmium = 20, // 25*2
		/datum/beacon_export/terrantitan/laser_scalpel = 20, //=
		/datum/beacon_export/terrantitan/advancedsyringe = 20,
		/datum/beacon_export/terrantitan/manipulator_nano = 20,
		/datum/beacon_export/terrantitan/shield_diffuser = 40,
		/datum/beacon_export/terrantitan/hypospray = 40,
	)





/obj/effect/overmap/trade_beacon/dredward // hopeful landing
	name = "Doctor Edwards Chemical & Medical Emporium"
	desc = "Doctor Cornleius Edwards offers fair pricing to desperate clientelle. He's also looking to buy your chemicals, would you like to know more?"
	possible_imports = list(
		/datum/beacon_import/clothing/glasses/science = 40, // job sci
		/datum/beacon_import/clothing/under/research_director = 40,// job sci
		/datum/beacon_import/clothing/under/research_director/dress_rd = 40,// job sci
		/datum/beacon_import/clothing/accessory/cloak/rd = 40, // fun
		/datum/beacon_import/clothing/storage/backpack/toxins = 40, // job sci
		/datum/beacon_import/clothing/storage/backpack/satchel/chem = 40, // job chemistry
		/datum/beacon_import/clothing/under/chemist = 40, // job chem
		/datum/beacon_import/clothing/hat/nursehat = 40, // job medical
		/datum/beacon_import/clothing/hat/surgical_cap = 40, // job medical
		/datum/beacon_import/clothing/hat/hardhat/ems = 40, // job medical
		/datum/beacon_import/clothing/gloves/latex = 40, // job medical
		/datum/beacon_import/clothing/mask/surgical = 40, // job medical
		/datum/beacon_import/clothing/suit/fr_jacket = 40, // job medic
		/datum/beacon_import/clothing/suit/fr_jacket/ems = 40, // job medic
		/datum/beacon_import/clothing/suit/medical_chest_rig = 40, // job medic
		/datum/beacon_import/clothing/suit/surgicalapron = 40, // job medic
		/datum/beacon_import/clothing/suit/hospital = 40, // job medic
		/datum/beacon_import/clothing/accessory/stethoscope = 40, // job medic
		/datum/beacon_import/clothing/under/chief_medical_officer = 40, // job medic
		/datum/beacon_import/clothing/under/geneticist = 40, // job medic
		/datum/beacon_import/clothing/under/virologist = 40, // job medic
		/datum/beacon_import/clothing/under/nurse = 40, // job medic
		/datum/beacon_import/clothing/under/orderly = 40, // job medic
		/datum/beacon_import/clothing/under/medical = 40, // job medic
		/datum/beacon_import/clothing/under/medical/paramedic = 40, // job medic
		/datum/beacon_import/clothing/under/scrubs = 40, // job medic
		/datum/beacon_import/clothing/under/psych = 40, // job medic
		/datum/beacon_import/clothing/under/sterile = 40, // job medical
		/datum/beacon_import/clothing/storage/backpack/medic = 40, // job medic
		/datum/beacon_import/clothing/storage/backpack/dufflebag/med = 40, // job medic
		/datum/beacon_import/clothing/storage/backpack/satchel/med = 40 // job medical

	)
	possible_exports = list( // AVG 144 AT NEUTRAL SEC LEVEL
		/datum/beacon_export/food_export/cake_orange = 20, // 36*2
		/datum/beacon_export/food_export/muffin = 20, // 47*2
		/datum/beacon_export/liquid_material/immunobooster = 20, // 26*2
		/datum/beacon_export/liquid_material/brutemed = 20, // 44*2
		/datum/beacon_export/liquid_material/antiburn = 20, // 45*2
		/datum/beacon_export/liquid_material/antirads = 20, // 48*2
		/datum/beacon_export/liquid_material/stimulants = 20, // 35*2
		/datum/beacon_export/liquid_material/clotting = 20, // 34*2
		/datum/beacon_export/solid_material/titanium = 20, // 25*2
		/datum/beacon_export/solid_material/gold = 20, // 19*2
		/datum/beacon_export/liquid_material/sedative = 20, // 20*2,
		/datum/beacon_export/liquid_material/dredward/antieverything = 40,
		/datum/beacon_export/liquid_material/dredward/mentalmedication = 40,
		/datum/beacon_export/solid_material/nebu_high = 60
	)


/obj/effect/overmap/trade_beacon/jupitersoutpost // southern rim
	name = "Jupiters Outpost"
	desc = "This mysterious beacon belongs to Jupiter herself. She can't possibly be in the frontier, could she? The beacon offers fine clothing imported directly from the Sol System."
	possible_imports = list(
		/datum/beacon_import/jupitersoutpost/skillpotentiator1 = 100,
		/datum/beacon_import/clothing/hat/powdered_wig = 40,
		/datum/beacon_import/clothing/hat/that = 40, // fun
		/datum/beacon_import/clothing/hat/bowler = 40, // fun
		/datum/beacon_import/clothing/hat/beaverhat = 40, // fun
		/datum/beacon_import/clothing/hat/boaterhat = 40, // fun
		/datum/beacon_import/clothing/hat/fedora = 40, // fun
		/datum/beacon_import/clothing/hat/fez = 40, // fun
		/datum/beacon_import/clothing/hat/feathertrilby = 40, // fun
		/datum/beacon_import/clothing/hat/ushanka = 40,  // fun
		/datum/beacon_import/clothing/hat/headphones = 40, // fun
		/datum/beacon_import/clothing/glasses/eyepatch/monocle = 40, // fun
		/datum/beacon_import/clothing/shoes/galoshes = 40, // fun
		/datum/beacon_import/clothing/shoes/dress = 40, // fun
		/datum/beacon_import/clothing/shoes/heels = 40, // fun
		/datum/beacon_import/clothing/shoes/flats = 40,
		/datum/beacon_import/clothing/suit/suit = 40, // job lawyer
		/datum/beacon_import/clothing/suit/judgerobe = 40, // fun
		/datum/beacon_import/clothing/under/head_of_personnel = 40, // fun
		/datum/beacon_import/clothing/under/cargo = 40, // job cargo
		/datum/beacon_import/clothing/under/head_of_personnel_whimsy = 40, // fun
		/datum/beacon_import/clothing/under/internalaffairs = 40, // fun
		/datum/beacon_import/clothing/under/lawyer = 40, // fun
		/datum/beacon_import/clothing/under/lawyer/female = 40, // fun
		/datum/beacon_import/clothing/under/lawyer/red = 40, // fun
		/datum/beacon_import/clothing/under/lawyer/blue = 40, // fun
		/datum/beacon_import/clothing/under/lawyer/purpsuit = 40, // fun
		/datum/beacon_import/clothing/under/lawyer/oldman  = 40,// fun
		/datum/beacon_import/clothing/under/lawyer/librarian = 40, // fun
		/datum/beacon_import/clothing/under/det = 40, // fun
		/datum/beacon_import/clothing/under/skirt_c/dress = 40, // fun
		/datum/beacon_import/clothing/under/skirt_c/dress/long = 40, // fun
		/datum/beacon_import/clothing/under/skirt_c/dress/long/gown  = 40,// fun
		/datum/beacon_import/clothing/under/scratch  = 40,// fun
		/datum/beacon_import/clothing/under/sl_suit  = 40,// fun
		/datum/beacon_import/clothing/under/vice  = 40,// fun
		/datum/beacon_import/clothing/under/gentlesuit  = 40,// fun
		/datum/beacon_import/clothing/under/suit_jacket  = 40,// fun
		/datum/beacon_import/clothing/under/suit_jacket/female  = 40,// fun
		/datum/beacon_import/clothing/under/suit_jacket/really_black  = 40,// fun
		/datum/beacon_import/clothing/under/suit_jacket/red  = 40,// fun
		/datum/beacon_import/clothing/under/blackskirt = 40,// fun
		/datum/beacon_import/clothing/under/dress  = 40,// fun
		/datum/beacon_import/clothing/under/dress/dress_green  = 40,// fun
		/datum/beacon_import/clothing/under/dress/dress_yellow  = 40,// fun
		/datum/beacon_import/clothing/under/dress/dress_orange  = 40,// fun
		/datum/beacon_import/clothing/under/dress/dress_pink  = 40,// fun
		/datum/beacon_import/clothing/under/dress/dress_purple  = 40,// fun
		/datum/beacon_import/clothing/under/dress/dress_saloon  = 40,// fun
		/datum/beacon_import/clothing/under/suit_jacket  = 40,// fun
		/datum/beacon_import/clothing/under/suit_jacket/navy  = 40,// fun
		/datum/beacon_import/clothing/under/suit_jacket/burgundy  = 40,// fun
		/datum/beacon_import/clothing/under/suit_jacket/tan  = 40,// fun
		/datum/beacon_import/clothing/under/blazer  = 40// fun
	)
	possible_exports = list(
		/datum/beacon_export/food_export/pumpkinpie = 20, // 36*2
		/datum/beacon_export/food_export/katsucurry_big = 20, // 59*2
		/datum/beacon_export/food_export/cookie = 20, // 77*2
		/datum/beacon_export/food_export/spesslaw = 20, // 44*2
		/datum/beacon_export/liquid_material/painkillers = 20, // 45*2
		/datum/beacon_export/liquid_material/adrenaline = 20, // 48*2
		/datum/beacon_export/solid_material/copper = 20, // 35*2
		/datum/beacon_export/solid_material/aluminium = 20, // 34*2
		/datum/beacon_export/solid_material/titanium = 20, // 25*2
		/datum/beacon_export/solid_material/phoron_mid,
		/datum/beacon_export/solid_material/nebu_mid,
		/datum/beacon_export/solid_material/nebu_high

	)

/obj/effect/overmap/trade_beacon/nanotrasenmemorial // trasen territory
	name = "Nanotrasen Memorial Beacon"
	desc = "Dedicated to the thirteen board members of the original Nanotrasen expedition into the Frontier. They helped draw the borders. The beacon still offers a lot of construction and engineering equipment."
	possible_imports = list(
		/datum/beacon_import/clothing/hat/welding/engie = 40, // fun
		/datum/beacon_import/clothing/hat/hardhat = 40,  // job engi
		/datum/beacon_import/clothing/hat/hardhat/firefighter = 40, // job engi
		/datum/beacon_import/clothing/glasses/welding/superior = 40, // fun
		/datum/beacon_import/clothing/gloves/insulated = 40, // job engi
		/datum/beacon_import/clothing/gloves/fire  = 40,// job
		/datum/beacon_import/clothing/shoes/workboots = 40, // armor
		/datum/beacon_import/clothing/shoes/magboots = 40, // job engi
		/datum/beacon_import/clothing/spacesuit/voidsuit = 40, // eva
		/datum/beacon_import/clothing/spacesuit/voidsuit/engineering = 40, // eva
		/datum/beacon_import/clothing/suit/hazardvest = 40, // job engi
		/datum/beacon_import/clothing/under/atmospheric_technician = 40, // job engi
		/datum/beacon_import/clothing/under/chief_engineer = 40, // job engi
		/datum/beacon_import/clothing/under/engineer = 40, // job engi
		/datum/beacon_import/clothing/under/roboticist = 40,// job engi
		/datum/beacon_import/clothing/under/roboticist/skirt = 40, // job engi
		/datum/beacon_import/clothing/storage/backpack/industrial = 40, // job engi
		/datum/beacon_import/clothing/storage/backpack/dufflebag/eng = 40, // job engi
		/datum/beacon_import/clothing/storage/backpack/satchel/eng = 40, // job engi
		/datum/beacon_import/clothing/hat/centcomhat = 25, // fun
		/datum/beacon_import/clothing/hat/caphat= 25, // fun
		/datum/beacon_import/clothing/hat/caphat/cap= 25, // fun
		/datum/beacon_import/clothing/hat/caphat/formal= 25, // fun
		/datum/beacon_import/clothing/hat/caphat/hop= 25, // fun
		/datum/beacon_import/clothing/gloves/captain= 25, // fun
		/datum/beacon_import/clothing/suit/capjacket= 25, // fun
		/datum/beacon_import/clothing/accessory/cloak/captain= 25, // fun
		/datum/beacon_import/clothing/suit/captunic= 25, // fun
		/datum/beacon_import/clothing/under/captain= 25, // fun
		/datum/beacon_import/clothing/under/dress/dress_cap= 25, // fun
		/datum/beacon_import/clothing/under/captainformal= 25, // fun
		/datum/beacon_import/clothing/storage/backpack/captain= 25, // fun
		/datum/beacon_import/clothing/storage/backpack/dufflebag/captain= 25, // fun
		/datum/beacon_import/clothing/storage/backpack/satchel/cap= 25 // fun

	)
	possible_exports = list( // AVG 131.2 AT NEUTRAL SEC LEVEL
		/datum/beacon_export/food_export/berryclafoutis = 20, // 95*1
		/datum/beacon_export/solid_material/copper = 20, // 36*2
		/datum/beacon_export/solid_material/redgold = 20, // 37*2
		/datum/beacon_export/solid_material/titanium = 20, // 44*2
		/datum/beacon_export/liquid_material/oxygel = 20, // 34*2
		/datum/beacon_export/solid_material/aluminium = 20, // 26*2
		/datum/beacon_export/solid_material/gold = 20, // 36*2
		/datum/beacon_export/solid_material/bronze = 20, // 23*2
		/datum/beacon_export/solid_material/brass = 20, // 20*2
		/datum/beacon_export/solid_material/osmium = 20, // 25*2
		/datum/beacon_export/solid_material/nanotrasenmemorial/diamondgold = 40,
		/datum/beacon_export/solid_material/nanotrasenmemorial/copperbronzesilver = 40,
		/datum/beacon_export/solid_material/nanotrasenmemorial/blackbronzeredgold = 40,
		/datum/beacon_export/solid_material/phoron_mid = 60,
		/datum/beacon_export/solid_material/phoron_high = 60
	)


/obj/effect/overmap/trade_beacon/earthsgarden // domdaniel
	name = "Mother Earths Green Garden"
	desc = "This Solgov installation scrapes an existence together by selling fresh seeds imported from Earth and buying food, medicine and materials."
	possible_imports = list(
		/datum/beacon_import/earthsgarden/chili_seeds = 100,
		/datum/beacon_import/earthsgarden/plastic_seeds = 100,
		/datum/beacon_import/earthsgarden/grape_seeds = 100,
		/datum/beacon_import/earthsgarden/greengrape_seeds = 100,
		/datum/beacon_import/earthsgarden/peanut_seeds = 100,
		/datum/beacon_import/earthsgarden/cabbage_seeds = 100,
		/datum/beacon_import/earthsgarden/shand_seeds = 100,
		/datum/beacon_import/earthsgarden/mtear_seeds = 100,
		/datum/beacon_import/earthsgarden/berry_seeds = 100,
		/datum/beacon_import/earthsgarden/blueberry_seeds = 100,
		/datum/beacon_import/earthsgarden/banana_seeds = 100,
		/datum/beacon_import/earthsgarden/eggplant_seeds = 100,
		/datum/beacon_import/earthsgarden/tomato_seeds = 100,
		/datum/beacon_import/earthsgarden/corn_seeds = 100,
		/datum/beacon_import/earthsgarden/poppy_seeds = 100,
		/datum/beacon_import/earthsgarden/potato_seeds = 100,
		/datum/beacon_import/earthsgarden/soya_seeds = 100,
		/datum/beacon_import/earthsgarden/wheat_seeds = 100,
		/datum/beacon_import/earthsgarden/rice_seeds = 100,
		/datum/beacon_import/earthsgarden/carrot_seeds = 100,
		/datum/beacon_import/earthsgarden/apple_seeds = 100,
		/datum/beacon_import/earthsgarden/whitebeet_seeds = 100,
		/datum/beacon_import/earthsgarden/sugarcane_seeds = 100,
		/datum/beacon_import/earthsgarden/watermelon_seeds = 100,
		/datum/beacon_import/earthsgarden/pumpkin_seeds = 100,
		/datum/beacon_import/earthsgarden/lime_seeds = 100,
		/datum/beacon_import/earthsgarden/lemon_seeds = 100,
		/datum/beacon_import/earthsgarden/orange_seeds = 100,
		/datum/beacon_import/earthsgarden/cocoa_seeds = 100,
		/datum/beacon_import/earthsgarden/cherry_seeds = 100,
		/datum/beacon_import/earthsgarden/peppercorn_seeds = 100,
		/datum/beacon_import/earthsgarden/garlic_seeds = 100,
		/datum/beacon_import/earthsgarden/onion_seeds = 100,
		/datum/beacon_import/earthsgarden/orange_seeds = 100,
		/datum/beacon_import/earthsgarden/cotton_seeds = 100,
		/datum/beacon_import/earthsgarden/mushroom_seeds = 100,
		/datum/beacon_import/earthsgarden/towercap_seeds = 100,
		/datum/beacon_import/earthsgarden/plumpmycelium_seeds = 100,
		/datum/beacon_import/earthsgarden/nettle_seeds = 100,
		/datum/beacon_import/earthsgarden/harebell_seeds = 100,
		/datum/beacon_import/earthsgarden/sunflower_seeds = 100,
		/datum/beacon_import/earthsgarden/lavender_seeds = 100,
		/datum/beacon_import/clothing/storage/backpack/hydroponics = 40, // job hydro
		/datum/beacon_import/clothing/storage/backpack/satchel/hyd = 40 // botany
	)
	possible_exports = list( // AVG 144 AT NEUTRAL SEC LEVEL
		/datum/beacon_export/food_export/loaded_steak = 20, // 32*2
		/datum/beacon_export/food_export/hotdogs = 20, // 50*2
		/datum/beacon_export/food_export/burger = 20, // 30*2
		/datum/beacon_export/liquid_material/brutemed = 20, // 44*2
		/datum/beacon_export/liquid_material/antiburn = 20, // 45*2
		/datum/beacon_export/liquid_material/antirads = 20, // 48*2
		/datum/beacon_export/liquid_material/stimulants = 20, // 35*2
		/datum/beacon_export/solid_material/iron = 20, // 32*2
		/datum/beacon_export/solid_material/titanium = 20, // 25*2
		/datum/beacon_export/solid_material/blackbronze = 20, // 19*2
		/datum/beacon_export/solid_material/nebu_mid = 60,
		/datum/beacon_export/solid_material/nebu_high = 60
	)


/obj/effect/overmap/trade_beacon/fruitflyjunction // neutral zonee
	name = "Fruit Fly Junction"
	desc = "No one knows who runs this beacon or why."
	possible_imports = list(
		/datum/beacon_import/nebu_mid = 60,
		/datum/beacon_import/nebu_high = 60,
		/datum/beacon_import/clothing/hat/rabbitears = 40, // fun
		/datum/beacon_import/clothing/hat/philosopher_wig  = 40,// fun
		/datum/beacon_import/clothing/hat/kitty = 40, // fun
		/datum/beacon_import/clothing/mask/snorkel = 40, // fun
		/datum/beacon_import/clothing/mask/fakemoustache = 40,
		/datum/beacon_import/clothing/mask/horsehead = 40, // fun
		/datum/beacon_import/clothing/suit/chickensuit = 40, // fun
		/datum/beacon_import/clothing/suit/monkeysuit = 40, // fun
		/datum/beacon_import/clothing/suit/mankini = 40, // fun
		/datum/beacon_import/clothing/head/santahat = 40, // fun
		/datum/beacon_import/clothing/suit/santa = 40, // fun
		/datum/beacon_import/clothing/accessory/badge/press = 40, // fun
		/datum/beacon_import/clothing/under/clown = 40, // fun
		/datum/beacon_import/clothing/under/mime = 40, // fun
		/datum/beacon_import/clothing/under/mailman = 40, // fun
		/datum/beacon_import/clothing/under/sexyclown = 40, // fun
		/datum/beacon_import/clothing/under/owl = 40, // fun
		/datum/beacon_import/clothing/under/schoolgirl = 40,// fun
		/datum/beacon_import/clothing/under/soviet = 40, // fun
		/datum/beacon_import/clothing/under/redcoat = 40, // fun
		/datum/beacon_import/clothing/under/kilt = 40, // fun
		/datum/beacon_import/clothing/under/sexymime = 40, // fun
		/datum/beacon_import/clothing/under/wedding = 40, // fun
		/datum/beacon_import/clothing/under/wedding/bride_purple = 40, // fun
		/datum/beacon_import/clothing/under/wedding/bride_blue = 40, // fun
		/datum/beacon_import/clothing/under/wedding/bride_red = 40, // fun
		/datum/beacon_import/clothing/under/wedding/bride_white = 40, // fun
		/datum/beacon_import/clothing/storage/backpack/clown = 40, // fun clown
		/datum/beacon_import/clothing/gloves/rainbow  = 10,
		/datum/beacon_import/clothing/under/rainbow = 10  // fun

	)
	possible_exports = list( // AVG 144 AT NEUTRAL SEC LEVEL
		/datum/beacon_export/food_export/creamcheesebread = 20, // 32*2
		/datum/beacon_export/food_export/cheesyfries = 20, // 50*2
		/datum/beacon_export/food_export/candiedapple = 20, // 30*2
		/datum/beacon_export/liquid_material/retroviral = 20, // 44*2
		/datum/beacon_export/liquid_material/antiseptic = 20, // 45*2
		/datum/beacon_export/liquid_material/nanite = 20, // 48*2
		/datum/beacon_export/liquid_material/immunobooster = 20, // 35*2
		/datum/beacon_export/solid_material/iron = 20, // 32*2
		/datum/beacon_export/solid_material/bronze = 20, // 25*2
		/datum/beacon_export/solid_material/osmium = 20 // 19*2
	)



/obj/effect/overmap/trade_beacon/eddys // hamlet jean
	name = "Eddys All Day Breakfast"
	desc = "This beacon is styled like a 24/7 diner. You can do a lot of food business here."
	possible_imports = list(
		/datum/beacon_import/beer = 100,
		/datum/beacon_import/kahlua = 100,
		/datum/beacon_import/whiskey = 100,
		/datum/beacon_import/wine = 100,
		/datum/beacon_import/whitewine = 100,
		/datum/beacon_import/vodka = 100,
		/datum/beacon_import/gin = 100,
		/datum/beacon_import/rum = 100,
		/datum/beacon_import/tequila = 100,
		/datum/beacon_import/vermouth = 100,
		/datum/beacon_import/cognac = 100,
		/datum/beacon_import/ale = 100,
		/datum/beacon_import/mead = 100,
		/datum/beacon_import/water = 100,
		/datum/beacon_import/ice = 100,
		/datum/beacon_import/sugar = 100,
		/datum/beacon_import/black_tea = 100,
		/datum/beacon_import/cola = 100,
		/datum/beacon_import/citrussoda = 100,
		/datum/beacon_import/cherrycola = 100,
		/datum/beacon_import/lemonade = 100,
		/datum/beacon_import/tonic = 100,
		/datum/beacon_import/sodawater = 100,
		/datum/beacon_import/lemon_lime = 100,
		/datum/beacon_import/orange = 100,
		/datum/beacon_import/lime = 100,
		/datum/beacon_import/watermelon = 100,
		/datum/beacon_import/syrup_chocolate = 100,
		/datum/beacon_import/syrup_caramel = 100,
		/datum/beacon_import/syrup_vanilla = 100,
		/datum/beacon_import/syrup_pumpkin = 100,
		/datum/beacon_import/coffee = 100,
		/datum/beacon_import/hot_coco = 100,
		/datum/beacon_import/milk = 100,
		/datum/beacon_import/cream = 100,
		/datum/beacon_import/dozeneggs = 100,
		/datum/beacon_import/cowmeat = 100,
		/datum/beacon_import/goatmeat = 100,
		/datum/beacon_import/chickenmeat = 100,
		/datum/beacon_import/fishmeat = 100,
		/datum/beacon_import/chemical_dispenser = 100,
		/datum/beacon_import/clothing/suit/apron = 60, // job
		/datum/beacon_import/clothing/hat/chefhat = 60, // job chef
		/datum/beacon_import/clothing/suit/chef = 60, // job chef
		/datum/beacon_import/clothing/suit/chef/classic = 60, // job chef
		/datum/beacon_import/clothing/under/chef = 60 // job service

	)
	possible_exports = list( // AVG 144 AT NEUTRAL SEC LEVEL
		/datum/beacon_export/food_export/creamcheesebread = 20, // 32*2
		/datum/beacon_export/food_export/cheesyfries = 20, // 50*2
		/datum/beacon_export/food_export/muffin = 20, // 30*2
		/datum/beacon_export/food_export/waffles = 20, // 44*2
		/datum/beacon_export/food_export/pie_big = 20, // 45*2
		/datum/beacon_export/food_export/cake_all = 20,
		/datum/beacon_export/food_export/pancakes = 20,
		/datum/beacon_export/food_export/ricepudding = 20,
		/datum/beacon_export/food_export/jelliedtoast = 20,
		/datum/beacon_export/liquid_material/antiburn = 20, // 48*2
		/datum/beacon_export/solid_material/aluminium = 20 // 19*2
	)


/obj/effect/overmap/trade_beacon/cash4nebu // wild space
	name = "Crazy Carls Cash 4 Nebu Emporium"
	desc = "At Cash 4 Nebu we offer competetive rates for YOUR nebu! Got spare nebu lying around? Rare cosmetics are available here if the security level is high enough."
	possible_imports = list(
		/datum/beacon_import/clothing/hat/welding/knight = 30, // fun
		/datum/beacon_import/clothing/hat/welding/fancy = 30,  // fun
		/datum/beacon_import/clothing/under/dress/dress_hop = 30,  // fun
		/datum/beacon_import/clothing/accessory/cloak/ce = 30,  // fun
		/datum/beacon_import/clothing/accessory/cloak/cmo = 30,  // fun
		/datum/beacon_import/clothing/accessory/cloak/hop = 30,  // fun
		/datum/beacon_import/clothing/accessory/cloak/qm  = 30, // fun
		/datum/beacon_import/clothing/mask/rubber/cat = 30,  // fun
		/datum/beacon_import/clothing/mask/monitor  = 30, // fun
		/datum/beacon_import/clothing/hat/cakehat  = 30, // fun
		/datum/beacon_import/clothing/under/hosformalmale  = 30, // fun
		/datum/beacon_import/clothing/under/assistantformal  = 30, // fun


	)
	possible_exports = list( // AVG 144 AT NEUTRAL SEC LEVEL
		/datum/beacon_export/food_export/fishfingers = 20, // 32*2
		/datum/beacon_export/food_export/beetsoup = 20, // 50*2
		/datum/beacon_export/food_export/taco = 20, // 30*2
		/datum/beacon_export/liquid_material/retroviral = 20, // 44*2
		/datum/beacon_export/liquid_material/crystalagent = 20, // 45*2
		/datum/beacon_export/liquid_material/nanite = 20, // 48*2
		/datum/beacon_export/liquid_material/neuroannealer = 20, // 35*2
		/datum/beacon_export/solid_material/blackbronze = 20, // 32*2
		/datum/beacon_export/solid_material/gold = 20, // 25*2
		/datum/beacon_export/solid_material/stainless_steel = 20, // 19*2
		/datum/beacon_export/solid_material/cash4nebu/nebu_low = 100,
		/datum/beacon_export/solid_material/cash4nebu/nebu_mid = 60,
		/datum/beacon_export/solid_material/cash4nebu/nebu_high = 40
	)


/obj/effect/overmap/trade_beacon/test_beacon
	possible_imports = list(
		/datum/beacon_import/example = 100,
		/datum/beacon_import/steel = 100
		)
	possible_exports = list(
		/datum/beacon_export/example = 100,
		/datum/beacon_export/xanaducrystal = 100
		)
	name = "Kleibkhar Debug Trade Beacon"

/obj/effect/overmap/trade_beacon/test_beacon2
	possible_imports = list(
		/datum/beacon_import/example = 100,
		/datum/beacon_import/steel = 100
		)
	possible_exports = list(
		/datum/beacon_export/example = 100,
		/datum/beacon_export/xanaducrystal = 100
		)
	name = "Kleibkhar Debug Trade Beacon Secondus"
