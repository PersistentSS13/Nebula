/datum/beacon_export/food_export/checkExport(var/turf/L)
	if(!L) return "No valid location detected"
	var/obj/closet_found = 0
	var/valid_items = list()
	for(var/obj/structure/closet/C in L.contents)
		closet_found = C
		for(var/obj/item/chems/food/item_type in required_items)
			var/ind = required_items[item_type]
			if(!ind) ind = 1
			var/found = 0
			for(var/obj/o in C.contents)
				if(istype(o, item_type))
					if(item_type.slices_num != initial(item_type.slices_num))
						return "Incomplete Export Detected ([item_type])"
					ind--
					valid_items |= o
				if(ind < 0)
					return "Too many items included ([o.name]). Exact orders only."
				if(ind == 0)
					found = 1
					break
			if(!found)
				return "Incomplete Export Detected ([item_type])"
		break // only check 1, the for loop is just a convient way to search
	if(!closet_found)
		return "No container detected"
	else
		var/obj/invalid_item = 0
		for(var/obj/o in closet_found.contents)
			if(!(o in valid_items))
				invalid_item = o
				break
		if(invalid_item)
			return "Too many items included ([invalid_item.name]). Exact orders only."
		checked_closet = closet_found
		return // SUCCESS


/datum/beacon_export/liquid_material
	required_items = list() // structure is list(reagent name = volume of reagent, reagent 2 name = volume of reagent).

/datum/beacon_export/liquid_material/checkExport(var/turf/L)
	if(!L) return "No valid location detected"
	var/obj/closet_found = 0
	var/valid_items = list()
	for(var/obj/structure/closet/C in L.contents)
		closet_found = C
		for(var/reagent_name in required_items)
			var/ind = required_items[reagent_name]
			if(!ind) ind = 1
			var/found = 0
			for(var/obj/item/o in C.contents)
				if(o && o.reagents && o.reagents.has_reagent(reagent_name))
					ind -= o.reagents.has_reagent(reagent_name)
					valid_items |= o
				if(ind < 0)
					return "Too much included ([o.name]). Exact orders only."
				if(ind == 0)
					found = 1
					break
			if(!found)
				return "Incomplete Export Detected ([reagent_name])"
		break // only check 1, the for loop is just a convient way to search
	if(!closet_found)
		return "No container detected"
	else
		var/obj/invalid_item = 0
		for(var/obj/o in closet_found.contents)
			if(!(o in valid_items))
				invalid_item = o
				break
		if(invalid_item)
			return "Too many items included ([invalid_item.name]). Exact orders only."
		checked_closet = closet_found
		return // SUCCESS




/datum/beacon_export/solid_material
	required_items = list() // structure is list(material name = volume of material, material 2 name = volume of material).

/datum/beacon_export/solid_material/checkExport(var/turf/L)
	if(!L) return "No valid location detected"
	var/obj/closet_found = 0
	var/valid_items = list()
	for(var/obj/structure/closet/C in L.contents)
		closet_found = C
		for(var/material_name in required_items)
			var/decl/material/mat = SSmaterials.get_material_by_name(material_name)
			if(!mat) return "Invalid export, report bug to developer"
			var/check_type = /obj/item/stack
			if(mat.default_solid_form)
				check_type = mat.default_solid_form
			var/ind = required_items[material_name]
			if(!ind) ind = 1
			var/found = 0
			for(var/obj/item/o in C.contents)
				if(istype(o, check_type))
					if(isstack(o))
						var/obj/item/stack/s = o
						if(s && s.material && s.material.name == material_name)
							ind -= s.amount
							if(ind >= 0)
								valid_items |= o
					else
						if(o && o.material && o.material.name == material_name)
							ind--
							valid_items |= o
				if(ind < 0)
					return "Too many items included ([o.name]). Exact orders only."
				if(ind == 0)
					found = 1
					break
			if(!found)
				return "Incomplete Export Detected ([material_name])"
		break // only check 1, the for loop is just a convient way to search
	if(!closet_found)
		return "No container detected"
	else
		var/obj/invalid_item = 0
		for(var/obj/o in closet_found.contents)
			if(!(o in valid_items))
				invalid_item = o
				break
		if(invalid_item)
			return "Too many items included ([invalid_item.name]). Exact orders only."
		checked_closet = closet_found
		return // SUCCESS




/datum/beacon_export
	var/name = "Beacon Export"
	var/list/required_items = list() // structure is list(/obj/item/example = 1, /obj/item/multi = 2) list(type = number required).
	var/cost = 1000
	var/remaining_stock = 5
	var/desc = "Export Description"
	var/obj/checked_closet
	var/min_sec_level = -5
	var/max_sec_level = 5

/datum/beacon_export/proc/valid_choice(var/datum/overmap_quadrant/quadrant)
	if(!quadrant) return 0
	if(quadrant.get_security_level() < min_sec_level) return 0
	if(quadrant.get_security_level() > max_sec_level) return 0
	return 1

/datum/beacon_export/proc/get_cost(var/tax)
	if(!tax) return cost
	return cost-((tax/100)*cost)

/datum/beacon_export/proc/get_tax(var/tax)
	if(!tax) return 0
	return (tax/100)*cost

/datum/beacon_export/proc/takeExport()
	if(checked_closet)
		checked_closet.forceMove(null)
		qdel(checked_closet)
	checked_closet = null
	remaining_stock--
/datum/beacon_export/proc/resetExport()
	checked_closet = null


/datum/beacon_export/proc/checkExport(var/turf/L)
	if(!L) return "No valid location detected"
	var/obj/closet_found = 0
	var/valid_items = list()
	for(var/obj/structure/closet/C in L.contents)
		closet_found = C
		for(var/item_type in required_items)
			var/ind = required_items[item_type]
			if(!ind) ind = 1
			var/found = 0
			for(var/obj/o in C.contents)
				if(istype(o, item_type))
					if(isstack(o))
						var/obj/item/stack/s = o
						ind -= s.amount
						if(ind >= 0)
							valid_items |= o
					else
						ind--
						valid_items |= o
				if(ind < 0)
					return "Too many items included ([o.name]). Exact orders only."
				if(ind == 0)
					found = 1
					break
			if(!found)
				return "Incomplete Export Detected ([item_type])"
		break // only check 1, the for loop is just a convient way to search
	if(!closet_found)
		return "No container detected"
	else
		var/obj/invalid_item = 0
		for(var/obj/o in closet_found.contents)
			if(!(o in valid_items))
				invalid_item = o
				break
		if(invalid_item)
			return "Too many items included ([invalid_item.name]). Exact orders only."
		checked_closet = closet_found
		return // SUCCESS


/////////////////////////////////////////

/datum/beacon_export/solid_material/huntershall/greedleather_basic
	required_items = list("greedleather" = 10)
	cost = 150
	name = "10 greedleather"
	desc = "Prove your mettle by murdering the GREED and we can reward you. Pulp them and tan the hides, bring them to us ten at a time."
	remaining_stock = 2

/datum/beacon_export/solid_material/huntershall/greedleather_mid
	required_items = list("greedleather" = 25)
	cost = 500
	name = "25 greedleather"
	desc = "Greedleather is proof that you have slain the beasts of the Frontier."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_export/huntershall/greedmeat_basic
	required_items = list(/obj/item/chems/food/meat/greed = 15)
	cost = 60
	name = "15 greed meat"
	desc = "We can dispose of it safely and give you a little money for your bravery."
	remaining_stock = 2

/datum/beacon_export/huntershall/greedmeat_mid
	required_items = list(/obj/item/chems/food/meat/greed = 15)
	cost = 500
	name = "50 greed meat"
	desc = "The flesh of the greed proves your bravery, and we reward it! We will dispose of the flesh for you."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_export/moonlight/mollusc_basic
	required_items = list(/obj/item/mollusc = 10)
	cost = 85
	name = "10 fresh mollusc"
	desc = "We crave this delicous shellfish! It reminds us of home. Send ten mollusc!"
	remaining_stock = 3

/datum/beacon_export/moonlight/clam_basic
	required_items = list(/obj/item/mollusc/clam = 25)
	cost = 95
	name = "25 fresh clams"
	desc = "More seafood, we enjoy it in memory of the brothers and sisters that came before us. Send us twenty five clams."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_export/moonlight/barnacle_basic
	required_items = list(/obj/item/mollusc/barnacle = 25)
	cost = 95
	name = "25 fresh barnacles"
	desc = "Even the lowly barnacle has it's uses in cooking and crafting for the Faeren and us. We need twenty five barnacles."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_export/terrantitan/laser_scalpel
	required_items = list(/obj/item/scalpel/laser/upgraded = 3)
	cost = 255
	name = "3 laser scalpels"
	desc = "Not quite as good a deal as it was years ago, but this is still a reasonable export."
	remaining_stock = 2
	min_sec_level = 3

/datum/beacon_export/terrantitan/advancedsyringe
	required_items = list(/obj/item/chems/syringe/advanced = 2)
	cost = 205
	name = "2 advanced syringes"
	desc = "These syringes are huge! Huge!"
	remaining_stock = 2
	min_sec_level = 3


/datum/beacon_export/terrantitan/manipulator_nano
	required_items = list(/obj/item/stock_parts/manipulator/nano = 1)
	cost = 163
	name = "1 nano manipulator"
	desc = "These specialized parts improve the effiency of the machine they are in."
	remaining_stock = 2
	min_sec_level = 3

/datum/beacon_export/terrantitan/shield_diffuser
	required_items = list(/datum/fabricator_recipe/protolathe/tool/shield_diffuser = 3)
	cost = 1247
	name = "3 shield diffusers"
	desc = "The ultra high security level has allowed the terrans to trade in high tech."
	remaining_stock = 1
	min_sec_level = 5

/datum/beacon_export/terrantitan/hypospray
	required_items = list(/obj/item/chems/hypospray/vial = 3)
	cost = 1111
	name = "3 hyposprays"
	desc = "The ultra high security level has allowed the terrans to trade in high tech."
	remaining_stock = 1
	min_sec_level = 5


/datum/beacon_export/solid_material/cash4nebu/nebu_low
	required_items = list("nebu" = 7)
	cost = 1820
	name = "7 nebu ingots"
	desc = "Feeling desperate to offload a few nebu bars (7). Well sure, Carl can help you with that!"
	remaining_stock = 1

/datum/beacon_export/solid_material/cash4nebu/nebu_mid
	required_items = list("nebu" = 13)
	cost = 3770
	name = "13 nebu ingots"
	desc = "Hey, Carl is doing pretty well! I can offer you 3770 for those 13 nebu bars."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_export/solid_material/cash4nebu/nebu_high
	required_items = list("nebu" = 13)
	cost = 9300
	name = "31 nebu ingots"
	desc = "With the incredible success that Carl has been enjoying, we can offer you a special 1 time deal for 31 Nebu Ingots."
	remaining_stock = 1
	min_sec_level = 5



/datum/beacon_export/liquid_material/dredward/antieverything
	required_items = list("antiseptic" = 20,"antirads" = 20, "antitoxins" = 20)
	cost = 155
	name = "20 liquid units of antiseptic, antirads and antitoxins"
	desc = "Dr Edward wants to offer YOU a great deal! Yes you!"
	min_sec_level = 3
	remaining_stock = 1
/datum/beacon_export/liquid_material/dredward/mentalmedication
	required_items = list("antiseptic" = 20,"antirads" = 20, "antitoxins" = 20)
	cost = 124
	name = "20 liquid units of sedative, stimulant and antidepressive."
	desc = "Feeling blue? Maybe this export can help! Help me help others, and help yourself in the process!"
	min_sec_level = 3
	remaining_stock = 1


/datum/beacon_export/solid_material/nanotrasenmemorial/diamondgold
	required_items = list("diamond" = 10, "gold" = 30)
	cost = 85
	name = "10 diamonds, 30 gold ingots"
	desc = "Who is supplying money to this beacon anyways? What do they need with all this material?"
	remaining_stock = 2
	min_sec_level = 3


/datum/beacon_export/solid_material/nanotrasenmemorial/copperbronzesilver
	required_items = list("copper" = 30, "bronze" = 30, "silve" = 15)
	cost = 105
	name = "30 copper ingots, 30 bronze ingots, 15 silver ingots"
	desc = "As security level grows the beacon gets more aggressive in it's material purchases."
	remaining_stock = 2
	min_sec_level = 3


/datum/beacon_export/solid_material/nanotrasenmemorial/blackbronzeredgold
	required_items = list("black bronze" = 30, "red gold" = 30)
	cost = 96
	name = "30 black bronze ingots, 30 red gold ingots."
	desc = "Even materials with limited practical uses are being bought here. Very mysterious."
	remaining_stock = 2
	min_sec_level = 3







/datum/beacon_export/liquid_material/retroviral
	required_items = list("retrovirals" = 20)
	cost = 28
	name = "20 liquid units of retrovirals"
	desc = "These retrovirals can help keep the unique frontier mutations at bay.. for now."
	remaining_stock = 2

/datum/beacon_export/liquid_material/pacid
	required_items = list("polytrinic acid" = 22)
	cost = 33
	name = "22 liquid units of polytrinic acid"
	desc = "Polytrinic acid has uses in high end microcomputer manufacturing."
	remaining_stock = 2

/datum/beacon_export/liquid_material/antitoxins
	required_items = list("antitoxins" = 30)
	cost = 41
	name = "30 liquid units of antitoxin"
	desc = "An urgent request for antitoxin has come in."
	remaining_stock = 2

/datum/beacon_export/liquid_material/antirads
	required_items = list("antirads" = 30)
	cost = 48
	name = "30 liquid units of antirads"
	desc = "Radiation of all kinds is a meanace in the frontier."
	remaining_stock = 2

/datum/beacon_export/liquid_material/antiseptic
	required_items = list("antiseptic" = 20)
	cost = 24
	name = "20 liquid units of antiseptic"
	desc = "This is an important substance for succesful surgery. This price sucks."
	remaining_stock = 2


/datum/beacon_export/liquid_material/painkillers
	required_items = list("painkillers" = 35)
	cost = 52
	name = "35 liquid units of painkillers"
	desc = "A highly effective substance for removing pain."
	remaining_stock = 2

/datum/beacon_export/liquid_material/antiburn
	required_items = list("synthskin" = 35)
	cost = 45
	name = "35 liquid units of synthskin"
	desc = "An urgent request has come out for burn medication."
	remaining_stock = 2


/datum/beacon_export/liquid_material/regenerator
	required_items = list("regenerative serum" = 25)
	cost = 43
	name = "25 liquid units of regenerative serum"
	desc = "This advanced substance heals multiple types of wounds."
	remaining_stock = 2

/datum/beacon_export/liquid_material/neuroannealer
	required_items = list("neuroannealer" = 12)
	cost = 20
	name = "12 liquid units of neuroannealer"
	desc = "An urgent request has been put in for brain medication."
	remaining_stock = 2

/datum/beacon_export/liquid_material/oxygel
	required_items = list("oxygel" = 23)
	cost = 34
	name = "23 liquid units of oxygel"
	desc = "The beacon tenders have sustained damage from oxygen deprivation. They need oxygel!"
	remaining_stock = 2

/datum/beacon_export/liquid_material/brutemed
	required_items = list("styptic powder" = 30)
	cost = 44
	name = "30 liquid units of styptic powder"
	desc = "A fight broke out and now we need styptic powder!"
	remaining_stock = 2


/datum/beacon_export/liquid_material/nanite
	required_items = list("nanite fluid" = 21)
	cost = 45
	name = "21 liquid units of nanite fluid"
	desc = "This advanced compound repairs robotic organs"
	remaining_stock = 2


/datum/beacon_export/liquid_material/crystalagent
	required_items = list("crystallizing agent" = 18)
	cost = 32
	name = "18 liquid units of crystallizing agent"
	desc = "A mysterious substance that has a variety of purposes."
	remaining_stock = 2

/datum/beacon_export/liquid_material/sedative
	required_items = list("sedatives" = 12)
	cost = 20
	name = "12 liquid units of sedatives"
	desc = "A mild substance for calming and gently putting people to sleep."
	remaining_stock = 2

/datum/beacon_export/liquid_material/stimulants
	required_items = list("stimulants" = 20)
	cost = 35
	name = "20 liquid units of stimulants"
	desc = "A mild substance for focusing the patient."
	remaining_stock = 2

/datum/beacon_export/liquid_material/antidepressants
	required_items = list("antidepressants" = 20)
	cost = 32
	name = "20 liquid units of antidepressants"
	desc = "A mild substance for restoring happiness and serenity to the patient."
	remaining_stock = 2


/datum/beacon_export/liquid_material/adrenaline
	required_items = list("adrenaline" = 25)
	cost = 44
	name = "25 liquid units of adrenaline"
	desc = "A powerful medication capable of treating cardiac arrest."
	remaining_stock = 2


/datum/beacon_export/liquid_material/stabilizer
	required_items = list("stabilizer" = 22)
	cost = 36
	name = "22 liquid units of stabilizer"
	desc = "A powerful medication capable of treating short term brain damage."
	remaining_stock = 2

/datum/beacon_export/liquid_material/immunobooster
	required_items = list("immunobooster" = 16)
	cost = 26
	name = "16 liquid units of immunobooster"
	desc = "A preventative measure against frontier infections."
	remaining_stock = 2

/datum/beacon_export/liquid_material/clotting
	required_items = list("clotting agent" = 22)
	cost = 34
	name = "22 liquid units of clotting agent"
	desc = "We need medication to stop our bleeding!"
	remaining_stock = 2




////////// bad bad no good bad bad
/datum/beacon_export/liquid_material/amphetamines
	required_items = list("amphetamines" = 80)
	cost = 151
	name = "80 liquid units of amphetamine"
	desc = "Send the meth and we will send the money. Simple as."
	remaining_stock = 1

/datum/beacon_export/liquid_material/psychoactives
	required_items = list("psychoactives" = 65)
	cost = 101
	name = "65 liquid units of psychoactives"
	desc = "We need 75 units of psychoactives. I just wanna go back to normal."
	remaining_stock = 1

/datum/beacon_export/liquid_material/narcotics
	required_items = list("narcotics" = 95)
	cost = 131
	name = "95 liquid units of narcotics"
	desc = "please send it"
	remaining_stock = 1

/datum/beacon_export/liquid_material/hallucinogenics
	required_items = list("hallucinogenics" = 50)
	cost = 110
	name = "50 liquid units of hallucinogenics"
	desc = "We need to see the truth.."
	remaining_stock = 1

/datum/beacon_export/liquid_material/psychotropics
	required_items = list("psychotropics" = 62)
	cost = 98
	name = "62 liquid units of psychotropics"
	desc = "It's more fun and games than the harder drugs you can find out here."
	remaining_stock = 1

/datum/beacon_export/liquid_material/presyncopics
	required_items = list("presyncopics" = 70)
	cost = 120
	name = "70 liquid units of presyncopics"
	desc = "Why anyone would want this, you don't know."
	remaining_stock = 1

/datum/beacon_export/liquid_material/paralytics
	required_items = list("paralytics" = 95)
	cost = 155
	name = "95 liquid units of paralytics"
	desc = "A powerful paralyzing agent."
	remaining_stock = 1

/datum/beacon_export/liquid_material/gleam
	required_items = list("gleam" = 58)
	cost = 116
	name = "58 liquid units of gleam"
	desc = "This stuff makes me feel like a shooting star."
	remaining_stock = 1

/datum/beacon_export/liquid_material/phorophedamine
	required_items = list("phorophedamine" = 100)
	cost = 666
	name = "100 liquid units of phorophedamine"
	desc = "You don't want to get in to this awful stuff.. best leave it with us."
	remaining_stock = 1
	max_sec_level = -3
/datum/beacon_export/liquid_material/bluespice
	required_items = list("bluespice" = 100)
	cost = 800
	name = "100 liquid units of bluespice"
	desc = "This is a powerful stimulant that makes a person capable of taking on the world. We'll gladly take it off your hands."
	remaining_stock = 1
	max_sec_level = -5

/datum/beacon_export/solid_material/nebu_crminal_mid
	required_items = list("nebu" = 3)
	cost = 750
	name = "3 nebu ingots"
	desc = "With this quadrant on the verge of anarchy, an illegal request for nebu has been put in, they don't care how you got it."
	remaining_stock = 1
	max_sec_level = -3

/datum/beacon_export/solid_material/nebu_crminal_high
	required_items = list("nebu" = 10)
	cost = 3000
	name = "10 nebu ingots"
	desc = "The security of the Quadrant has collapsed and neither SolGov nor the Terrans can control our trade now."
	remaining_stock = 1
	max_sec_level = -5


/datum/beacon_export/solid_material/nebu_mid
	required_items = list("nebu" = 10)
	cost = 2500
	name = "10 nebu ingots"
	desc = "This beacon feels secure enough to trade in nebu bars. This is a fair price, but not exceptional."
	remaining_stock = 1
	min_sec_level = 3


/datum/beacon_export/solid_material/nebu_high
	required_items = list("nebu" = 25)
	cost = 7500
	name = "25 nebu ingots"
	desc = "This is an amazing opportunity to offload 25 nebu ingots at 300$ a bar."
	remaining_stock = 1
	min_sec_level = 5

/datum/beacon_export/solid_material/phoron_criminal_low
	required_items = list("phoron" = 5)
	cost = 300
	name = "5 phoron sheets"
	desc = "You're not sure who this phoron is going to, exporting it here."
	remaining_stock = 1
	max_sec_level = -1

/datum/beacon_export/solid_material/phoron_criminal_mid
	required_items = list("phoron" = 10)
	cost = 800
	name = "15 phoron sheets"
	desc = "Phoron is the seed that grows backwards in time and space. It is the key to breaking the chains of cause and effect."
	remaining_stock = 1
	max_sec_level = -3

/datum/beacon_export/solid_material/phoron_criminal_high
	required_items = list("phoron" = 25)
	cost = 2450
	name = "25 phoron sheets"
	desc = "This phoron will be fed directly to the beast. Even as it sleeps, the fire burns and hungers."
	remaining_stock = 1
	max_sec_level = -5


/datum/beacon_export/solid_material/phoron_low
	required_items = list("phoron" = 10)
	cost = 500
	name = "10 phoron sheets"
	desc = "10 phoron sheets at 50$ a sheet is an insultingly low price, but this is the only reliable export location in the Frontier. Better export prices are available at other beacons if their quadrant security level is raised to 3 or above."
	remaining_stock = 3

/datum/beacon_export/solid_material/phoron_mid
	required_items = list("phoron" = 30)
	cost = 2250
	name = "30 phoron sheets"
	desc = "This beacon is feeling secure enough to request 30 phoron sheets at a rate or 75$ a sheet. Phoron is incredibly dangerous to mine."
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_export/solid_material/phoron_high
	required_items = list("phoron" = 100)
	cost = 9200
	name = "100 phoron sheets"
	desc = "The ultimate load of phoron at an incredible price; only available because of the high security in the quadrant."
	remaining_stock = 1
	min_sec_level = 5

/datum/beacon_export/solid_material/iron
	required_items = list("iron" = 50)
	cost = 32
	name = "50 iron ingots"
	desc = "Iron is very common but in the frontier it can be dangerous to collect the ore."
	remaining_stock = 2

/datum/beacon_export/solid_material/gold
	required_items = list("gold" = 15)
	cost = 20
	name = "10 gold ingots"
	desc = "Gold has many industrial uses around the frontier and can be sold easily."
	remaining_stock = 2

/datum/beacon_export/solid_material/bronze
	required_items = list("bronze" = 20)
	cost = 23
	name = "20 bronze ingots"
	desc = "Bronze is a common alloy that is easily made from the ore of common frontier asteroids."
	remaining_stock = 2

/datum/beacon_export/solid_material/blackbronze
	required_items = list("black bronze" = 15)
	cost = 19
	name = "15 black bronze ingots"
	desc = "Black bronze is an alloy of copper and silver used for aesthetic purposes."
	remaining_stock = 2

/datum/beacon_export/solid_material/redgold
	required_items = list("red gold" = 8)
	cost = 12
	name = "8 red gold ingots"
	desc = "An alloy of gold and copper, no doubt the person buying this intends to class up his station."
	remaining_stock = 3

/datum/beacon_export/solid_material/brass
	required_items = list("brass" = 24)
	cost = 20
	name = "24 brass ingots"
	desc = "An alloy of copper and zinc is being sought at this beacon."
	remaining_stock = 2

/datum/beacon_export/solid_material/copper
	required_items = list("copper" = 50)
	cost = 36
	name = "50 copper ingots"
	desc = "A large order for copper, a common material found in frontier asteroids."
	remaining_stock = 2

/datum/beacon_export/solid_material/silver
	required_items = list("silver" = 15)
	cost = 18
	name = "15 silver ingots"
	desc = "Silver is rare and useful in the frontier. This price sucks, but maybe it's the best you can do."
	remaining_stock = 2

/datum/beacon_export/solid_material/stainless_steel
	required_items = list("stainless steel" = 25)
	cost = 21
	name = "25 stainless steel ingots"
	desc = "Stainless steel is an alloy of steel and chromium. It is used for appliances mostly."
	remaining_stock = 2

/datum/beacon_export/solid_material/aluminium
	required_items = list("aluminium" = 35)
	cost = 30
	name = "35 aluminium ingots"
	desc = "Aluminium is a smelting product of bauxite and used in a variety of colonial manufacturing applications."
	remaining_stock = 2

/datum/beacon_export/solid_material/titanium
	required_items = list("titanium" = 25)
	cost = 25
	name = "25 titanium ingots"
	desc = "Titanium is a rare and extremely strong metal."
	remaining_stock = 2

/datum/beacon_export/solid_material/osmium
	required_items = list("osmium" = 25)
	cost = 25
	name = "25 osmium ingots"
	desc = "Osmium is just compressed titanium. Go figure."
	remaining_stock = 2




/datum/beacon_export/food_export/spaget
	required_items = list(/obj/item/chems/food/pastatomato = 5)
	name = "5 spaghetti & tomato"
	desc = "Some of the people here are hungry and want spaghetti today."
	cost = 55
	remaining_stock = 2

/datum/beacon_export/food_export/donut
	required_items = list(/obj/item/chems/food/donut = 12)
	name = "12 donuts"
	desc = "Desperately purchasing donuts! Make them whatever flavor you like."
	cost = 40
	remaining_stock = 2

/datum/beacon_export/food_export/burger
	required_items = list(/obj/item/chems/food/burger = 3)
	name = "3 plain burgers"
	desc = "We'll get three burgers please! Plain, and make them to go."
	cost = 33
	remaining_stock = 2

/datum/beacon_export/food_export/stew_big
	required_items = list(/obj/item/chems/food/stew = 5)
	name = "5 bowls of stew"
	desc = "A food crises has broke out here. They will pay reasonably well for a large order of filling stew."
	cost = 95
	remaining_stock = 1

/datum/beacon_export/food_export/hotdogs
	required_items = list(/obj/item/chems/food/hotdog = 10)
	name = "10 hotdogs"
	desc = "10 hotdogs ready to eat. No condiments required."
	cost = 50
	remaining_stock = 2

/datum/beacon_export/food_export/waffles
	required_items = list(/obj/item/chems/food/waffles = 5)
	name = "5 waffles"
	desc = "Five waffles. What more can I say?"
	cost = 35
	remaining_stock = 2

/datum/beacon_export/food_export/loaded_steak
	required_items = list(/obj/item/chems/food/loadedsteak = 3)
	name = "3 loaded steaks"
	desc = "Three steak and vegetable dinners and you will be rewarded."
	cost = 32
	remaining_stock = 1

/datum/beacon_export/food_export/pie_big
	required_items = list(/obj/item/chems/food/cherrypie = 1, /obj/item/chems/food/bananapie = 1, /obj/item/chems/food/meatpie = 1)
	name = "3 different pies"
	desc = "A particularly gourmand individual wants one cherry pie, one banana pie and one meat pie. We dont know why."
	cost = 150
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_export/food_export/cake_carrot
	required_items = list(/obj/item/chems/food/sliceable/carrotcake = 3)
	name = "3 carrot cakes"
	desc = "Three carrot cakes. Enough for everyone."
	cost = 36
	remaining_stock = 2


/datum/beacon_export/food_export/cake_cheese
	required_items = list(/obj/item/chems/food/sliceable/cheesecake = 3)
	name = "3 cheese cakes"
	desc = "Three cheese cakes. Delicious!"
	cost = 36
	remaining_stock = 2

/datum/beacon_export/food_export/cake_orange
	required_items = list(/obj/item/chems/food/sliceable/orangecake = 3)
	name = "3 orange cakes"
	desc = "Three orange cakes. Wow!"
	cost = 36
	remaining_stock = 2

/datum/beacon_export/food_export/cake_lime
	required_items = list(/obj/item/chems/food/sliceable/limecake = 3)
	name = "3 lime cakes"
	desc = "Three lime cakes. Rare!"
	cost = 36
	remaining_stock = 2

/datum/beacon_export/food_export/cake_lemon
	required_items = list(/obj/item/chems/food/sliceable/lemoncake = 3)
	name = "3 lemon cakes"
	desc = "Three lime cakes. Tangy."
	cost = 36
	remaining_stock = 2

/datum/beacon_export/food_export/cake_apple
	required_items = list(/obj/item/chems/food/sliceable/applecake = 3)
	name = "3 apple cakes"
	desc = "Three apple cakes. Crunchy!"
	cost = 36
	remaining_stock = 2


/datum/beacon_export/food_export/cake_chocolate
	required_items = list(/obj/item/chems/food/sliceable/chocolatecake = 3)
	name = "3 chocolate cakes"
	desc = "Three choclate cakes. My favorite!"
	cost = 60
	remaining_stock = 2

/datum/beacon_export/food_export/cake_birthday
	required_items = list(/obj/item/chems/food/sliceable/birthdaycake = 1)
	name = "1 birthday cake"
	desc = "One birthday cake. Happy birthday!"
	cost = 35
	remaining_stock = 1

/datum/beacon_export/food_export/cake_all
	required_items = list(/obj/item/chems/food/sliceable/birthdaycake = 1, /obj/item/chems/food/sliceable/chocolatecake = 1, /obj/item/chems/food/sliceable/applecake = 1, /obj/item/chems/food/sliceable/lemoncake = 1, /obj/item/chems/food/sliceable/limecake = 1, /obj/item/chems/food/sliceable/orangecake = 1, /obj/item/chems/food/sliceable/cheesecake = 1, /obj/item/chems/food/sliceable/carrotcake = 1)
	name = "ultimate cake export"
	desc = "Please send one of each of the following cakes; Birthday, Chocolate, Apple, Lemon, Lime, Orange, Cheese and Carrot. Delicious!"
	cost = 320
	remaining_stock = 1
	min_sec_level = 3

/datum/beacon_export/food_export/ricepudding
	required_items = list(/obj/item/chems/food/ricepudding = 3)
	name = "3 rice puddings"
	desc = "3 rice pudding dishes, please and thank you."
	cost = 30
	remaining_stock = 2

/datum/beacon_export/food_export/ricecake
	required_items = list(/obj/item/chems/food/ricecake = 3)
	name = "3 rice cakes"
	desc = "3 rice cakes, please and thank you."
	cost = 28
	remaining_stock = 2

/datum/beacon_export/food_export/candiedapple
	required_items = list(/obj/item/chems/food/candiedapple = 5)
	name = "5 candy apples"
	desc = "5 candy apples. It's always halloween somewhere, right?"
	cost = 48
	remaining_stock = 2

/datum/beacon_export/food_export/pumpkinpie
	required_items = list(/obj/item/chems/food/sliceable/pumpkinpie = 3)
	name = "3 pumpkin pies"
	desc = "3 delicious pumpkin pies.. yum."
	cost = 32
	remaining_stock = 2

/datum/beacon_export/food_export/pelmeni_boiled
	required_items = list(/obj/item/chems/food/pelmeni_boiled = 6)
	name = "6 boiled pelmeni"
	desc = "6 boiled pelmeni to feed the hungry beacon-tenders"
	cost = 72
	remaining_stock = 2


/datum/beacon_export/food_export/pancakes
	required_items = list(/obj/item/chems/food/pancakes = 2)
	name = "2 pancakes"
	desc = "Pancakes! Eat them with a fork. (Two please!)"
	cost = 18
	remaining_stock = 2

/datum/beacon_export/food_export/berryclafoutis
	required_items = list(/obj/item/chems/food/berryclafoutis = 2)
	name = "2 berry Clafoutis"
	desc = "Two clafoutis of the berry variety. Fancy!"
	cost = 22
	remaining_stock = 2

/datum/beacon_export/food_export/muffin
	required_items = list(/obj/item/chems/food/muffin = 12)
	name = "12 muffins"
	desc = "A dozen muffins, fresh as we can get them!"
	cost = 47
	remaining_stock = 2

/datum/beacon_export/food_export/cheesyfries
	required_items = list(/obj/item/chems/food/cheesyfries = 3)
	name = "3 plates of cheesyfries"
	desc = "An order for three cheesyfries. Cheesy."
	cost = 37
	remaining_stock = 2

/datum/beacon_export/food_export/fries
	required_items = list(/obj/item/chems/food/fries = 8)
	name = "8 plates of fries"
	desc = "Eight plates of fries for a fry loving group of people."
	cost = 38
	remaining_stock = 2

/datum/beacon_export/food_export/creamcheesebread
	required_items = list(/obj/item/chems/food/sliceable/creamcheesebread = 3)
	name = "3 cream cheese breads"
	desc = "Three cream cheese breads?. Delicous!"
	cost = 44
	remaining_stock = 2

/datum/beacon_export/food_export/katsucurry_big
	required_items = list(/obj/item/chems/food/katsucurry = 3)
	name = "3 katsu curry"
	desc = "Three katsu curry is a complicated but profitable prospect."
	cost = 59
	remaining_stock = 2

/datum/beacon_export/food_export/poppypretzel
	required_items = list(/obj/item/chems/food/poppypretzel = 10)
	name = "10 poppy pretzel"
	desc = "Ten poppy pretzels, whoopty doo."
	cost = 44
	remaining_stock = 2

/datum/beacon_export/food_export/omelette
	required_items = list(/obj/item/chems/food/omelette = 3)
	name = "3 omelette"
	desc = "A delicous and egg filled part of a complete breakfest."
	cost = 43
	remaining_stock = 2


/datum/beacon_export/food_export/cookie
	required_items = list(/obj/item/chems/food/cookie = 7)
	name = "7 cookies"
	desc = "Seven cookies for a lucky individual."
	cost = 77
	remaining_stock = 2

/datum/beacon_export/food_export/fishburger
	required_items = list(/obj/item/chems/food/fishburger = 4)
	name = "4 fish burgers"
	desc = "Four fish burgers and we're not picky about the type of fish!"
	cost = 44
	remaining_stock = 2

/datum/beacon_export/food_export/fishfingers
	required_items = list(/obj/item/chems/food/fishfingers = 2)
	name = "2 fish fingers"
	desc = "Two orders of fish fingers and the price isn't bad either!"
	cost = 31
	remaining_stock = 2

/datum/beacon_export/food_export/fatsausage
	required_items = list(/obj/item/chems/food/fatsausage = 3)
	name = "3 fat sausage"
	desc = "Three fat sausages?! Hopefully it's not one person eating all three."
	cost = 46
	remaining_stock = 2


/datum/beacon_export/food_export/beetsoup
	required_items = list(/obj/item/chems/food/beetsoup = 2)
	name = "2 beet soup"
	desc = "Two beet soups. You can't beat that!"
	cost = 22
	remaining_stock = 2

/datum/beacon_export/food_export/spesslaw
	required_items = list(/obj/item/chems/food/spesslaw = 3)
	name = "3 spaghetti and meatballs"
	desc = "A delicous but complicated meal."
	cost = 71
	remaining_stock = 2

/datum/beacon_export/food_export/jelliedtoast
	required_items = list(/obj/item/chems/food/jelliedtoast/cherry = 4)
	name = "4 jellied toast plates"
	desc = "Four jellied toast is a great way to start the morning."
	cost = 44
	remaining_stock = 2

/datum/beacon_export/food_export/taco
	required_items = list(/obj/item/chems/food/taco = 6)
	name = "6 tacos"
	desc = "A half dozen tacos, take a bite."
	cost = 67
	remaining_stock = 2


/////////////////////////////////////////////////////////////////////////
/datum/beacon_export/example
	required_items = list(/obj/item/stack/cable_coil = 10, /obj/item/plunger = 2)
	name = "Example Export"
	desc = "This is a debug export to test sending stacked items and multiple single items. It requires a ten stack of cable coil and two plungers to complete."
	cost = 500

/datum/beacon_export/xanaducrystal
	required_items = list(/obj/item/plunger = 1)
	name = "Xanadu Crystal"
	desc = "The rare Xanadu Crystal is much prized across the Galaxy."
	cost = 5000