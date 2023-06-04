/datum/skillset/var/list/used_potentiators = list()

/obj/item/skill_potentiator
	name = "skill potentiator mk 0"
	var/skill_points_to_add = 0
	var/max_uses = 3
	var/used = 0
	desc = "A mysterious frontier device that can improve your skills."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"


/obj/item/skill_potentiator/attack_self(var/mob/user)
	if(!user || !user.skillset || used)
		return 0
	for(var/x in user.skillset.used_potentiators)
		if(x == name)
			if(user.skillset.used_potentiators[x] >= max_uses)
				to_chat(user, "You have already used too many of this type of potentiator.")
				return 0
	user.skillset.points_remaining += skill_points_to_add
	if(user.skillset.temp_skillset) user.skillset.temp_skillset.points_remaining += skill_points_to_add
	to_chat(user, "You inject the potentiator into yourself and <b>feel that your skills have improved! [skill_points_to_add] points added!</b>")
	used = 1
	if(name in user.skillset.used_potentiators)
		var/curr_total = user.skillset.used_potentiators[name]
		user.skillset.used_potentiators[name] = curr_total+1
	else
		user.skillset.used_potentiators[name] = 1
	qdel(src)

/obj/item/skill_potentiator/mk1
	name = "skill potentiator mark 1"
	desc = "Every sentient being can only use mark 1 skill potentiators three times maximum."
	max_uses = 3
	skill_points_to_add = 15

/datum/beacon_import
	var/name = "Beacon Import"
	var/list/provided_items = list() // structure is list(/obj/item/example = 1, /obj/item/multi = 2) list(type = number provided).
	var/container_type = /obj/item/parcel
	var/cost = 1000
	var/remaining_stock = 5 // how many are left to buy this cycle
	var/desc = "Import Desription"

	var/min_sec_level = -5
	var/max_sec_level = 5
	var/recolorable = 0

/datum/beacon_import/proc/valid_choice(var/datum/overmap_quadrant/quadrant)
	if(quadrant.get_security_level() < min_sec_level) return 0
	if(quadrant.get_security_level() > max_sec_level) return 0
	return 1


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
/datum/beacon_import/proc/spawnImport(var/turf/L, var/recolor)
	if(!L) return
	var/obj/structure/container = new container_type(L)
	container.name = name
	container.desc = desc
	var/parcel_setup = 0
	if(istype(container, /obj/item/parcel))
		parcel_setup = 1
	for(var/item_type in provided_items)
		var/ind = provided_items[item_type]
		if(!ind) ind = 1
		var/obj/item/stack/stacking = 0
		for(var/i=1;i<=ind;i++)
			if(stacking)
				stacking.add(1)
			else
				var/obj/o = new item_type(container)
				if(recolor)
					if(istype(o,/obj/item/clothing))
						var/obj/item/clothing/cloth = o
						if(cloth.markings_icon)
							cloth.markings_color = recolor
						else
							o.color= recolor
					else
						o.color = recolor
				if(parcel_setup)
					parcel_setup = 0
					var/obj/item/parcel/wrap = container
					wrap.make_parcel(o)
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

/datum/beacon_import/dicta/engine
	provided_items = list(/obj/item/stock_parts/circuitboard/unary_atmos/engine = 1)
	name = "Thermal Engine Circuitboard"
	cost = 500
	desc = "SolGov has mandated that we may sell you individual packages containing no more than one (1) circuitboard suitable in the construction of a single (one) Thermal Engine. Long Live Earth."
	remaining_stock = 2
/datum/beacon_import/dicta/computers
	provided_items = list(/obj/item/stock_parts/circuitboard/helm = 1, /obj/item/stock_parts/circuitboard/engine = 1, /obj/item/stock_parts/circuitboard/nav = 1, /obj/item/stock_parts/circuitboard/sensors = 1, /obj/item/stock_parts/circuitboard/shuttle_console/explore)
	name = "Ship Internal Computing Circuitboards"
	cost = 1800
	desc = "Earths majesty shines upon the frontier by bestowing upon thee (you) an opportunity to purchase circuits for all the necessary on board computers a ship requires."
	remaining_stock = 2

/datum/beacon_import/dicta/pointdefense
	provided_items = list(/obj/item/stock_parts/circuitboard/pointdefense = 1, /obj/item/stock_parts/circuitboard/pointdefense_control = 1)
	name = "Asteroid Point Defense Circuitboards"
	cost = 500
	desc = "Point defense and control console circuits packaged together and sold to you by request of Jupiter. It is his sincere wish that it helps you survive your first mining expedition."
	remaining_stock = 2


/datum/beacon_import/dicta/shieldgenerator
	provided_items = list(/obj/item/stock_parts/circuitboard/shield_generator = 1)
	name = "Shield Generator Circuitboard"
	cost = 650
	desc = "These shield generator circuits carry a spark of the light of Sol that will protect you from the horrors of the Frontier."
	remaining_stock = 2

/datum/beacon_import/gerena/mining_drill
	provided_items = list(/obj/item/stock_parts/circuitboard/miningdrill = 1, /obj/item/stock_parts/circuitboard/miningdrillbrace = 2)
	name = "Mining Drill Circuitboards"
	cost = 500
	desc = "You get three circuitboards, one for the drill and two for the braces. That's a good deal.. if you can't produce or purchase these from inside the Frontier."
	remaining_stock = 2

/datum/beacon_import/gerena/mining_equipment
	provided_items = list(/obj/item/pickaxe/silver = 3, /obj/item/scanner/mining = 1)
	name = "Mining Equipment"
	cost = 475
	desc = "Three silver pickaxes and an ore scanner, everything you need to start basic mining operations."
	remaining_stock = 2

/datum/beacon_import/gerena/spacesuit
	provided_items = list(/obj/item/clothing/suit/space = 1, /obj/item/clothing/head/helmet/space = 1)
	name = "Space Suit"
	cost = 525
	desc = "Three silver pickaxes and an ore scanner, everything you need to start basic mining operations."
	remaining_stock = 2

/datum/beacon_import/huntershall/smartfridge
	provided_items = list(/obj/item/stock_parts/circuitboard/fridge = 1)
	name = "Smartfridge Circuitboard"
	cost = 525
	desc = "A single smartfridge circuit. The smartfridge can be customzied into many different machines, including a drying rack. You are getting ripped off at this price."
	remaining_stock = 2

/datum/beacon_import/moonlight/nebu_basic
	provided_items = list(/obj/item/stack/material/ingot/mapped/nebu/five = 1)
	name = "Five finely crafted nebu ingots."
	cost = 1250
	desc = "Nebu is what the Faeren traded with before the calmity washed them from this place. More could be offered at a better price if we felt safer."
	remaining_stock = 1

/datum/beacon_import/moonlight/nebu_mid
	provided_items = list(/obj/item/stack/material/ingot/mapped/nebu/ten = 1)
	name = "Ten treasured nebu ingots."
	cost = 2000
	desc = "The Faeren were the original wave of colonists to the frontier. Brought here by a cruel twist of fate. There is an ever better deal that occurs rarely when at max security level."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_import/moonlight/nebu_high
	provided_items = list(/obj/item/stack/material/ingot/mapped/nebu/twentyfive = 1)
	name = "Twenty five treasures of the Faeren (nebu ingots)."
	cost = 3500
	desc = "We could never go home, but they can come home through us. In this way we can find a new home again."
	remaining_stock = 1
	min_sec_level = 5

/datum/beacon_import/nebu_mid
	provided_items = list(/obj/item/stack/material/ingot/mapped/nebu/ten = 1)
	name = "Ten nebu ingots."
	cost = 2250
	desc = "The security level of this Quadrant has allowed for a small consignment of nebu bars to be offered."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_import/nebu_high
	provided_items = list(/obj/item/stack/material/ingot/mapped/nebu/twentyfive = 1)
	name = "Twenty five nebu ingots."
	cost = 3900
	desc = "The incredible security of this quadrant has allowed for a massive load of nebu bars to be offered for import."
	remaining_stock = 1
	min_sec_level = 5


/datum/beacon_import/bluespacecrystal_low
	provided_items = list(/obj/item/stack/material/gemstone/mapped/bluespacecrystal = 1)
	name = "One Bluespace Crystal"
	cost = 300
	desc = "This is a reliable but incredibly expensive import for a rare bluespace crystal. Better prices for bluespace crystals are available at other beacons if the security level in the quadrant is high enough."
	remaining_stock = 3

/datum/beacon_import/bluespacecrystal_mid
	provided_items = list(/obj/item/stack/material/gemstone/mapped/bluespacecrystal/five = 1)
	name = "Five Bluespace Crystals"
	cost = 1400
	desc = "A load of five bluespace crystals is available due to the high security of this quadrant."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_import/bluespacecrystal_high
	provided_items = list(/obj/item/stack/material/gemstone/mapped/bluespacecrystal/twentyfive)
	name = "25 Bluespace Crystals"
	cost = 5750
	desc = "This is a reliable but incredibly expensive import for a rare bluespace crystal. Better prices for bluespace crystals are available at other beacons if the security level in the quadrant is high enough."
	remaining_stock = 3
	min_sec_level = 5

/datum/beacon_import/seeds
	container_type = /obj/item/parcel

/datum/beacon_import/seeds/reishimycelium // halluc evil
	provided_items = list(/obj/item/seeds/reishimycelium = 1)
	name = "reishimycelium seeds"
	cost = 69
	desc = "The shrooms grown from these seeds contain psychotropic chemicals. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 1

/datum/beacon_import/seeds/amanitamycelium// halluc evil
	provided_items = list(/obj/item/seeds/amanitamycelium = 1)
	name = "amanitamycelium seeds"
	cost = 101
	desc = "These mushrooms are toxic and very psychotropic. Only the first generation of this plant produces seeds."
	remaining_stock = 1

/datum/beacon_import/seeds/glowbell // gleam
	provided_items = list(/obj/item/seeds/glowbell = 1)
	name = "glowbell seeds"
	cost = 100
	desc = "These mushrooms produce glowsap, a foundation for many popular Frontier drugs. Only the first generation of this plant produces seeds."
	remaining_stock = 1

/datum/beacon_import/seeds/ambrosiavulgaris // weed
	provided_items = list(/obj/item/seeds/ambrosiavulgarisseed = 1)
	name = "biteleaf seeds"
	cost = 120
	desc = "This controversial plant is a source of both useful medicine and restricted narcotics. Only the first generation of this plant produces seeds."
	remaining_stock = 1


/datum/beacon_import/jupitersoutpost/skillpotentiator1
	provided_items = list(/obj/item/skill_potentiator/mk1 = 1)
	name = "Skill Potentiator (Mark 1, +15 Skill Points)."
	cost = 500
	desc = "The skill potentiator mark one will increase your available skills by ten points. Each person can only use three mk 1 skill potentiators."
	remaining_stock = 3
	container_type = /obj/item/parcel

/datum/beacon_import/earthsgarden
	container_type = /obj/item/parcel

/datum/beacon_import/earthsgarden/plumpmycelium_seeds
	provided_items = list(/obj/item/seeds/plumpmycelium = 1)
	name = "plump helmet seeds"
	cost = 49
	desc = "One packet of plump helmet seeds, a large mushroom used by some cultures as a primary food source. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/nettle_seeds
	provided_items = list(/obj/item/seeds/nettleseed = 1)
	name = "nettle seeds"
	cost = 89
	desc = "A natural source of acid in the Frontier. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/harebell_seeds
	provided_items = list(/obj/item/seeds/harebell = 1)
	name = "harebell seeds"
	cost = 34
	desc = "These flowers will bring a little bit of beauty to the Frontier. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/sunflower_seeds
	provided_items = list(/obj/item/seeds/sunflowerseed = 1)
	name = "sunflower seeds"
	cost = 32
	desc = "These flowers will bring a little bit of beauty to the Frontier. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/lavender_seeds
	provided_items = list(/obj/item/seeds/lavenderseed = 1)
	name = "lavender seeds"
	cost = 57
	desc = "These flowers also have medical chemical within them. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/chili_seeds
	provided_items = list(/obj/item/seeds/chiliseed = 1)
	name = "chili seeds"
	cost = 41
	desc = "One packet of chili seeds imported directly from Earth. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/plastic_seeds
	provided_items = list(/obj/item/seeds/plastiseed = 1)
	name = "plastic seeds"
	cost = 86
	desc = "One packet of special plastic producing mushrooms. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/tobacco_seeds
	provided_items = list(/obj/item/seeds/tobaccoseed = 1)
	name = "tobacco seeds"
	cost = 130
	desc = "One packet of tobacco seeds, a source of luxury in the Frontier. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/finetobacco_seeds
	provided_items = list(/obj/item/seeds/finetobaccoseed = 1)
	name = "fine tobacco seeds"
	cost = 330
	desc = "One packet of fine tobacco seeds, a source of extreme luxury and opuluance in the Frontier. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2


/datum/beacon_import/earthsgarden/grape_seeds
	provided_items = list(/obj/item/seeds/grapeseed = 1)
	name = "grape seeds"
	cost = 65
	desc = "One packet of grape seeds, praise Sol! These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/greengrape_seeds
	provided_items = list(/obj/item/seeds/greengrapeseed = 1)
	name = "green grape seeds"
	cost = 65
	desc = "Use these to produce fresh green grapes. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/peanut_seeds
	provided_items = list(/obj/item/seeds/peanutseed = 1)
	name = "peanut seeds"
	cost = 69
	desc = "Use these to produce crunchy peanuts. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/cabbage_seeds
	provided_items = list(/obj/item/seeds/cabbageseed = 1)
	name = "cabbage seeds"
	cost = 43
	desc = "Cabbages are said to bring bad luck if you sell them out of a cart. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/mushroom_seeds
	provided_items = list(/obj/item/seeds/chantermycelium = 1)
	name = "basic mushroom seeds"
	cost = 56
	desc = "These mushrooms are made for cooking with. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/towercap_seeds
	provided_items = list(/obj/item/seeds/towercap = 1)
	name = "towercap seeds"
	cost = 58
	desc = "These mushrooms are a source of wood in the Frontier."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/shand_seeds
	provided_items = list(/obj/item/seeds/shandseed = 1)
	name = "S'randar's hand seeds"
	cost = 63
	desc = "This mysterious plant produces useful chemicals. This rare and complex seed will only produce seeds in it's first generation."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_import/earthsgarden/mtear_seeds
	provided_items = list(/obj/item/seeds/mtearseed = 1)
	name = "Messa's tear seeds"
	cost = 77
	desc = "Known as one of the blessings of the Celestials. This rare and complex seed will only produce seeds in it's first generation."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_import/earthsgarden/berry_seeds
	provided_items = list(/obj/item/seeds/berryseed = 1)
	name = "berry seeds"
	cost = 61
	desc = "These berry seeds should be berry profitable for you. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/blueberry_seeds
	provided_items = list(/obj/item/seeds/blueberryseed = 1)
	name = "blueberry seeds"
	cost = 86
	desc = "These have nothing to do with bluespace. We promise! These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/banana_seeds
	provided_items = list(/obj/item/seeds/bananaseed = 1)
	name = "banana seeds"
	cost = 76
	desc = "Introduce a little clownery to the Frontier. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/eggplant_seeds
	provided_items = list(/obj/item/seeds/eggplantseed = 1)
	name = "eggplant seeds"
	cost = 58
	desc = "Eggplant Emoji? These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/tomato_seeds
	provided_items = list(/obj/item/seeds/tomatoseed = 1)
	name = "tomato seeds"
	cost = 67
	desc = "For cooking, condiments or throwing. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/corn_seeds
	provided_items = list(/obj/item/seeds/cornseed = 1)
	name = "corn seeds"
	cost = 63
	desc = "Corn that comes with it's own cob. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/poppy_seeds
	provided_items = list(/obj/item/seeds/poppyseed = 1)
	name = "poppy seeds"
	cost = 78
	desc = "Rare poppy seeds imported from the Mars Verticle Gardens. This rare and complex seed will only produce seeds in it's first generation."
	remaining_stock = 2
	min_sec_level = 3

/datum/beacon_import/earthsgarden/potato_seeds
	provided_items = list(/obj/item/seeds/potatoseed = 1)
	name = "potato seeds"
	cost = 55
	desc = "If it comes down to it, we can all live off potatos. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/soya_seeds
	provided_items = list(/obj/item/seeds/soyaseed = 1)
	name = "soybean seeds"
	cost = 88
	desc = "A source of artificial milk, originally harvested from Earth. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/wheat_seeds
	provided_items = list(/obj/item/seeds/wheatseed = 1)
	name = "wheat seeds"
	cost = 67
	desc = "With this wheat, you may harvest the future of the Frontier. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/rice_seeds
	provided_items = list(/obj/item/seeds/riceseed = 1)
	name = "rice seeds"
	cost = 59
	desc = "Make sure you have the skill to grow this rice. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/carrot_seeds
	provided_items = list(/obj/item/seeds/carrotseed = 1)
	name = "carrot seeds"
	cost = 55
	desc = "These carrot seeds are blessed by Holy Sol. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/apple_seeds
	provided_items = list(/obj/item/seeds/appleseed = 1)
	name = "apple seeds"
	cost = 131
	desc = "An apple a day keeps the cloning pod away! These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/whitebeet_seeds
	provided_items = list(/obj/item/seeds/whitebeetseed = 1)
	name = "white beet seeds"
	cost = 66
	desc = "These beets are a source of sugar. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/sugarcane_seeds
	provided_items = list(/obj/item/seeds/sugarcaneseed = 1)
	name = "sugar cane seeds"
	cost = 79
	desc = "The infamous sugar cane is a neverending driver of human labor. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/watermelon_seeds
	provided_items = list(/obj/item/seeds/watermelonseed = 1)
	name = "watermelon seeds"
	cost = 88
	desc = "Fresh watermelon is a delicacy in the Frontier. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/pumpkin_seeds
	provided_items = list(/obj/item/seeds/pumpkinseed = 1)
	name = "pumpkin seeds"
	cost = 81
	desc = "One of the spookiest seeds we offer here. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/lime_seeds
	provided_items = list(/obj/item/seeds/limeseed = 1)
	name = "lime seeds"
	cost = 63
	desc = "Lime is one of the most common products of the Mars Verticle Gardens. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/lemon_seeds
	provided_items = list(/obj/item/seeds/lemonseed = 1)
	name = "lemon seeds"
	cost = 66
	desc = "Lemon is not our favorite here, but we still offer the seeds for sale. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/orange_seeds
	provided_items = list(/obj/item/seeds/orangeseed = 1)
	name = "orange seeds"
	cost = 72
	desc = "Orange you glad we sell seeds here? These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/cocoa_seeds
	provided_items = list(/obj/item/seeds/cocoapodseed = 1)
	name = "cocoa seeds"
	cost = 91
	desc = "A key precursor to chocolate. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/cherry_seeds
	provided_items = list(/obj/item/seeds/cherryseed = 1)
	name = "cherry seeds"
	cost = 70
	desc = "Three cherries is good luck, if you're playing the slots. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/peppercorn_seeds
	provided_items = list(/obj/item/seeds/peppercornseed = 1)
	name = "peppercorn seeds"
	cost = 53
	desc = "Pepper is a delicous add to 99% of food. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/garlic_seeds
	provided_items = list(/obj/item/seeds/garlicseed = 1)
	name = "garlic seeds"
	cost = 53
	desc = "This garlic is shipped from Earth. Keep clear of vampires! These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/onion_seeds
	provided_items = list(/obj/item/seeds/onionseed = 1)
	name = "onion seeds"
	cost = 46
	desc = "Onions are like ogres, they have layers. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/coffea_seeds
	provided_items = list(/obj/item/seeds/coffeaseed = 1)
	name = "coffea seeds"
	cost = 63
	desc = "The coffea plant is the source of coffee beans produced locally in the Frontier. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/datum/beacon_import/earthsgarden/cotton_seeds
	provided_items = list(/obj/item/seeds/cotton = 1)
	name = "cotton seeds"
	cost = 77
	desc = "Cotton is a hardy source of textiles. These are fresh to the Frontier and will produce seeds for two generations."
	remaining_stock = 2

/////////////////////////////////////////area

/datum/beacon_import/beer
	provided_items = list(/obj/item/chems/chem_disp_cartridge/beer = 1)
	name = "500 units of beer"
	cost = 120
	desc = "A refreshing beer is a great product for your fellow colonists. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/kahlua
	provided_items = list(/obj/item/chems/chem_disp_cartridge/kahlua = 1)
	name = "500 units of kahlua"
	cost = 191
	desc = "It's coffee mixed with liqour, what more can you want. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/whiskey
	provided_items = list(/obj/item/chems/chem_disp_cartridge/whiskey = 1)
	name = "500 units of whiskey"
	cost = 71
	desc = "Careful! This whiskey will steal your soul."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/wine
	provided_items = list(/obj/item/chems/chem_disp_cartridge/wine = 1)
	name = "500 units of red wine"
	cost = 231
	desc = "An expensive red wine imported into the Frontier. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/whitewine
	provided_items = list(/obj/item/chems/chem_disp_cartridge/whitewine = 1)
	name = "500 units of white wine"
	cost = 361
	desc = "An incredibly expensive drink imported into the frontier."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/vodka
	provided_items = list(/obj/item/chems/chem_disp_cartridge/vodka = 1)
	name = "500 units of vodka"
	cost = 161
	desc = "Vodka is the basis of many mixed drinks, which gives it good profit margins. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/gin
	provided_items = list(/obj/item/chems/chem_disp_cartridge/gin = 1)
	name = "500 units of white wine"
	cost = 55
	desc = "Some gin to sip on."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/rum
	provided_items = list(/obj/item/chems/chem_disp_cartridge/rum = 1)
	name = "500 units of rum"
	cost = 181
	desc = "A carribean classic imported into the Frontier. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/tequila
	provided_items = list(/obj/item/chems/chem_disp_cartridge/tequila = 1)
	name = "500 units of tequila"
	cost = 66
	desc = "TEQUILA!"
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/vermouth
	provided_items = list(/obj/item/chems/chem_disp_cartridge/vermouth = 1)
	name = "500 units of vermouth"
	cost = 60
	desc = "Vermouth is often used in cocktails."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/cognac
	provided_items = list(/obj/item/chems/chem_disp_cartridge/cognac = 1)
	name = "500 units of cognac"
	cost = 59
	desc = "A very special brand of brandy."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/ale
	provided_items = list(/obj/item/chems/chem_disp_cartridge/ale = 1)
	name = "500 units of ale"
	cost = 31
	desc = "Sweet, sweet ale."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/mead
	provided_items = list(/obj/item/chems/chem_disp_cartridge/mead = 1)
	name = "500 units of mead"
	cost = 125
	desc = "Fermented honey creates a delicous drink called mead. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/water
	provided_items = list(/obj/item/chems/chem_disp_cartridge/water = 1)
	name = "500 units of water"
	cost = 10
	desc = "Water water everywhere, but not a drop for free."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/ice
	provided_items = list(/obj/item/chems/chem_disp_cartridge/ice = 1)
	name = "500 units of ice"
	cost = 13
	desc = "Smart bar owners will add ice whenever possible to stretch drinks."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/sugar
	provided_items = list(/obj/item/chems/chem_disp_cartridge/sugar = 1)
	name = "500 units of sugar"
	cost = 250
	desc = "Enough sugar to keep a bar or kitchen stocked for a long time. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/black_tea
	provided_items = list(/obj/item/chems/chem_disp_cartridge/black_tea = 1)
	name = "500 units of black tea"
	cost = 187
	desc = "Plain, black, overpriced tea. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/cola
	provided_items = list(/obj/item/chems/chem_disp_cartridge/cola = 1)
	name = "500 units of cola"
	cost = 20
	desc = "Generic 'cola', licensed under GNU GPL."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/citrussoda
	provided_items = list(/obj/item/chems/chem_disp_cartridge/citrussoda = 1)
	name = "500 units of citrus soda"
	cost = 24
	desc = "Citrus soda is used in a few specialized drinks."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/cherrycola
	provided_items = list(/obj/item/chems/chem_disp_cartridge/cherrycola = 1)
	name = "500 units of cola"
	cost = 23
	desc = "Cherry cola, some stay dry and others feel the pain."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/lemonade
	provided_items = list(/obj/item/chems/chem_disp_cartridge/lemonade = 1)
	name = "500 units of lemonade"
	cost = 19
	desc = "The cornerstone of any lemonade stand empire. Jesse, we need to squeeze!"
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/tonic
	provided_items = list(/obj/item/chems/chem_disp_cartridge/tonic = 1)
	name = "500 units of tonic"
	cost = 18
	desc = "The cheaper portion of many mixed drinks."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/sodawater
	provided_items = list(/obj/item/chems/chem_disp_cartridge/sodawater = 1)
	name = "500 units of soda water"
	cost = 16
	desc = "I can't believe it's not tonic!"
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/lemon_lime
	provided_items = list(/obj/item/chems/chem_disp_cartridge/lemon_lime = 1)
	name = "500 units of lemon-lime juice."
	cost = 17
	desc = "An artifical sweetner crafted to resemble lemon, lime or both."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/orange
	provided_items = list(/obj/item/chems/chem_disp_cartridge/orange = 1)
	name = "500 units of orange juice"
	cost = 111
	desc = "Orange juice is a great souce of vitamin C. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/lime
	provided_items = list(/obj/item/chems/chem_disp_cartridge/lime = 1)
	name = "500 units of lime juice"
	cost = 122
	desc = "Lime juice is used in many . Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/watermelon
	provided_items = list(/obj/item/chems/chem_disp_cartridge/watermelon = 1)
	name = "500 units of watermelon juice"
	cost = 109
	desc = "Watermelon juice is used in a few tropical drinks. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/syrup_chocolate
	provided_items = list(/obj/item/chems/chem_disp_cartridge/syrup_chocolate = 1)
	name = "500 units of chocolate syrup"
	cost = 20
	desc = "Chocolate syrup is surely delicous!"
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/syrup_caramel
	provided_items = list(/obj/item/chems/chem_disp_cartridge/syrup_caramel = 1)
	name = "500 units of caramel syrup"
	cost = 20
	desc = "Sugary, delicous caramel!"
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/syrup_vanilla
	provided_items = list(/obj/item/chems/chem_disp_cartridge/syrup_vanilla = 1)
	name = "500 units of vanilla syrup"
	cost = 20
	desc = "A wonderful flavoring for any drink."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/syrup_pumpkin
	provided_items = list(/obj/item/chems/chem_disp_cartridge/syrup_pumpkin = 1)
	name = "500 units of pumpkin syrup"
	cost = 20
	desc = "Pumpkin syrup is a treat indeed."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/coffee
	provided_items = list(/obj/item/chems/chem_disp_cartridge/coffee = 1)
	name = "500 units of coffee"
	cost = 100
	desc = "Coffee is the fuel that civilizations run on. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/hot_coco
	provided_items = list(/obj/item/chems/chem_disp_cartridge/hot_coco = 1)
	name = "500 units of hot coco"
	cost = 89
	desc = "Hot coco is a great choice on a cold wintery night. Expensive to import because it can be produced locally."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/milk
	provided_items = list(/obj/item/chems/chem_disp_cartridge/milk = 1)
	name = "500 units of milk"
	cost = 45
	desc = "Animal milk is considered an extreme luxury in the Frontier."
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/cream
	provided_items = list(/obj/item/chems/chem_disp_cartridge/cream = 1)
	name = "500 units of cream"
	cost = 60
	desc = "Cream is a milk product that is used in a varietey of recipes."
	remaining_stock = 2
	container_type = /obj/item/parcel


//////////////////////////////

/datum/beacon_import/dozeneggs
	provided_items = list(/obj/item/chems/food/egg = 12)
	container_type = /obj/item/storage/fancy/egg_box/empty
	name = "12 eggs"
	cost = 31
	desc = "A dozen eggs imported into the Frontier. Yum!"
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/cowmeat
	provided_items = list(/obj/item/chems/food/meat/beef = 5)
	name = "5 slabs of beef"
	cost = 51
	desc = "Cow meat imported into the Frontier for your enjoyment."
	remaining_stock = 2
	container_type = /obj/structure/closet/crate/freezer


/datum/beacon_import/goatmeat
	provided_items = list(/obj/item/chems/food/meat/goat = 5)
	name = "5 slabs of goat meat"
	cost = 43
	desc = "Goat meat is being sold at this beacon."
	remaining_stock = 2
	container_type = /obj/structure/closet/crate/freezer


/datum/beacon_import/chickenmeat
	provided_items = list(/obj/item/chems/food/meat/chicken = 5)
	name = "5 slabs of chicken meat"
	cost = 50
	desc = "Tastes like chicken! It's exactly that."
	remaining_stock = 2
	container_type = /obj/structure/closet/crate/freezer


/datum/beacon_import/fishmeat
	provided_items = list(/obj/item/chems/food/fish = 10)
	name = "10 fish fillet"
	cost = 79
	desc = "Fish has been a common import into the frontier."
	remaining_stock = 2
	container_type = /obj/structure/closet/crate/freezer

/datum/beacon_import/chemical_dispenser
	provided_items = list(/obj/item/stock_parts/matter_bin = 2, /obj/item/stock_parts/manipulator = 1, /obj/item/stock_parts/circuitboard/chemical_dispenser = 1)
	name = "chemical dispenser circuitboard and components"
	cost = 500
	desc = "A chemical dispenser circuitboard and all the components required to build one. Chemical Dispenser Circuits are versitile and can be used by kitchens, bars or chemists. This is incredibly overpriced to import!"
	remaining_stock = 2
	container_type = /obj/item/parcel

/datum/beacon_import/dociler
	provided_items = list(/obj/item/dociler = 1)
	name = "Xenofauna Dociler"
	cost = 677
	desc = "This incredibly advanced single use device can tame one of the crazed creatures of the Frontier."
	remaining_stock = 1
	container_type = /obj/item/parcel
	min_sec_level = 4