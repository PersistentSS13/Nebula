/datum/chemical_reaction/antitoxins
	name = "Antitoxins"
	result = /decl/material/chem/antitoxins
	required_reagents = list(/decl/material/chem/silicon = 1, /decl/material/chem/potassium = 1, /decl/material/chem/ammonia = 1)
	result_amount = 3

/datum/chemical_reaction/painkillers
	name = "oxycodone"  //REAL name again
	result = /decl/material/chem/painkillers
	required_reagents = list(/decl/material/chem/adrenaline = 1, /decl/material/chem/ethanol = 1, /decl/material/chem/acetone = 1)
	result_amount = 3

/datum/chemical_reaction/antiseptic
	name = "chlorocresol" //real fucking name
	result = /decl/material/chem/antiseptic
	required_reagents = list(/decl/material/chem/ethanol = 1, /decl/material/chem/antitoxins = 1, /decl/material/chem/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/mutagenics
	name = "Unstable mutagen"
	result = /decl/material/chem/mutagenics
	required_reagents = list(/decl/material/chem/radium = 1, /decl/material/chem/phosphorus = 1, /decl/material/chem/acid/hydrochloric = 1)
	result_amount = 3

/datum/chemical_reaction/psychoactives
	name = "L. S. D."
	result = /decl/material/chem/psychoactives
	required_reagents = list(/decl/material/chem/mercury = 1, /decl/material/chem/nutriment/sugar = 1, /decl/material/chem/lithium = 1)
	result_amount = 3
	minimum_temperature = 50 CELSIUS
	maximum_temperature = (50 CELSIUS) + 100

/datum/chemical_reaction/lube
	name = "Lubricant"
	result = /decl/material/chem/lube
	required_reagents = list(/decl/material/gas/water = 1, /decl/material/chem/silicon = 1, /decl/material/chem/acetone = 1)
	result_amount = 4
	mix_message = "The solution becomes thick and slimy."

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /decl/material/chem/acid/polyacid
	required_reagents = list(/decl/material/chem/acid = 1, /decl/material/chem/acid/hydrochloric = 1, /decl/material/chem/potassium = 1)
	result_amount = 3

/datum/chemical_reaction/antirads
	name = "potassium iodide"  //REAL NAMES at LEASSST
	result = /decl/material/chem/antirads
	required_reagents = list(/decl/material/chem/radium = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/narcotics
	name = "Narcotics"
	result = /decl/material/chem/narcotics
	required_reagents = list(/decl/material/chem/mercury = 1, /decl/material/chem/acetone = 1, /decl/material/chem/nutriment/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/burn_meds
	name = "Anti-Burn Medication"
	result = /decl/material/chem/burn_meds
	required_reagents = list(/decl/material/chem/silicon = 1, /decl/material/chem/carbon = 1)
	result_amount = 2
	log_is_important = 1

/datum/chemical_reaction/presyncopics
	name = "Presyncopics"
	result = /decl/material/chem/presyncopics
	required_reagents = list(/decl/material/chem/potassium = 1, /decl/material/chem/acetone = 1, /decl/material/chem/nutriment/sugar = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = 60 CELSIUS
	result_amount = 3

/datum/chemical_reaction/regenerator
	name = "Regenerative Serum"
	result = /decl/material/chem/regenerator
	required_reagents = list(/decl/material/chem/adrenaline = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/neuroannealer
	name = "Neuroannealer"
	result = /decl/material/chem/neuroannealer
	required_reagents = list(/decl/material/chem/acid/hydrochloric = 1, /decl/material/chem/ammonia = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/oxy_meds
	name = "betametasona"  //at least give it a real name instead of OXIGEN MEDICATION
	result = /decl/material/chem/oxy_meds
	required_reagents = list(/decl/material/chem/acetone = 1, /decl/material/gas/water = 1, /decl/material/chem/sulfur = 1)
	result_amount = 1

/datum/chemical_reaction/brute_meds
	name = "Anti-Trauma Medication"
	result = /decl/material/chem/brute_meds
	required_reagents = list(/decl/material/chem/adrenaline = 1, /decl/material/chem/carbon = 1)
	inhibitors = list(/decl/material/chem/nutriment/sugar = 1) // Messes up with adrenaline
	result_amount = 2

/datum/chemical_reaction/amphetamines
	name = "dextroamphetamine" // real. fucking name.
	result = /decl/material/chem/amphetamines
	required_reagents = list(/decl/material/chem/nutriment/sugar = 1, /decl/material/chem/phosphorus = 1, /decl/material/chem/sulfur = 1)
	result_amount = 3

/datum/chemical_reaction/retrovirals
	name = "Retrovirals"
	result = /decl/material/chem/retrovirals
	required_reagents = list(/decl/material/chem/antirads = 1, /decl/material/chem/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/nanitefluid
	name = "Nanite Fluid"
	result = /decl/material/chem/nanitefluid
	required_reagents = list(/decl/material/chem/toxin/plasticide = 1, /decl/material/aluminium = 1, /decl/material/chem/lube = 1)
	catalysts = list(/decl/material/chem/toxin/phoron = 5)
	result_amount = 3
	minimum_temperature = (-25 CELSIUS) - 100
	maximum_temperature = -25 CELSIUS
	mix_message = "The solution becomes a metallic slime."

/datum/chemical_reaction/antibiotics
	name = "Penicillin" //lets go with the classics.. AY?
	result = /decl/material/chem/antibiotics
	required_reagents = list(/decl/material/chem/presyncopics = 1, /decl/material/chem/adrenaline = 1)
	result_amount = 2

/datum/chemical_reaction/eyedrops
	name = "polyethylene glycol"
	result = /decl/material/chem/eyedrops
	required_reagents = list(/decl/material/chem/carbon = 1, /decl/material/chem/fuel/hydrazine = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 2

/datum/chemical_reaction/sedatives
	name = "chloral hydrate"
	result = /decl/material/chem/sedatives
	required_reagents = list(/decl/material/chem/ethanol = 1, /decl/material/chem/nutriment/sugar = 4)
	inhibitors = list(/decl/material/chem/phosphorus) // Messes with the smoke
	minimum_temperature = 90 CELSIUS   // this should keep recipes stable and add some .. difficulty for a SEDATIVE
	maximum_temperature = 100 CELSIUS
	result_amount = 5

/datum/chemical_reaction/paralytics
	name = "Botulinum" //yes thats what it is
	result = /decl/material/chem/paralytics
	required_reagents = list(/decl/material/chem/ethanol = 1, /decl/material/chem/mercury = 2, /decl/material/chem/fuel/hydrazine = 2)
	result_amount = 1

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /decl/material/chem/toxin/zombiepowder
	required_reagents = list(/decl/material/chem/toxin/carpotoxin = 5, /decl/material/chem/sedatives = 5, /decl/material/copper = 5)
	result_amount = 2
	minimum_temperature = 90 CELSIUS
	maximum_temperature = 99 CELSIUS
	mix_message = "The solution boils off to form a fine powder."

/datum/chemical_reaction/hallucinogenics
	name = "THC"
	result = /decl/material/chem/hallucinogenics
	required_reagents = list(/decl/material/chem/silicon = 1, /decl/material/chem/fuel/hydrazine = 1, /decl/material/chem/antitoxins = 1)
	result_amount = 3
	mix_message = "The solution takes on an iridescent sheen."
	minimum_temperature = 75 CELSIUS
	maximum_temperature = (75 CELSIUS) + 25

/datum/chemical_reaction/surfactant
	name = "Azosurfactant"
	result = /decl/material/chem/surfactant
	required_reagents = list(/decl/material/chem/fuel/hydrazine = 2, /decl/material/chem/carbon = 2, /decl/material/chem/acid = 1)
	result_amount = 5
	mix_message = "The solution begins to foam gently."

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	result = /decl/material/chem/cleaner
	required_reagents = list(/decl/material/chem/ammonia = 1, /decl/material/gas/water = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /decl/material/chem/toxin/plantbgone
	required_reagents = list(/decl/material/chem/toxin = 1, /decl/material/gas/water = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /decl/material/chem/foaming_agent
	required_reagents = list(/decl/material/chem/lithium = 1, /decl/material/chem/fuel/hydrazine = 1)
	result_amount = 1
	mix_message = "The solution begins to foam vigorously."

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	result = /decl/material/chem/sodiumchloride
	required_reagents = list(/decl/material/chem/sodium = 1, /decl/material/chem/acid/hydrochloric = 1)
	result_amount = 2

/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	result = /decl/material/chem/capsaicin/condensed
	required_reagents = list(/decl/material/chem/capsaicin = 2)
	catalysts = list(/decl/material/chem/toxin/phoron = 5)
	result_amount = 1

/datum/chemical_reaction/stimulants
	name = "erythropoietin"  //yes real dopping is made with this too.
	result = /decl/material/chem/stimulants
	required_reagents = list(/decl/material/chem/hallucinogenics = 1, /decl/material/chem/lithium = 1)
	result_amount = 3

/datum/chemical_reaction/antidepressants
	name = "fluoxetine" //another real one
	result = /decl/material/chem/antidepressants
	required_reagents = list(/decl/material/chem/hallucinogenics = 1, /decl/material/chem/carbon = 1)
	result_amount = 3

/datum/chemical_reaction/hair_remover
	name = "Hair Remover"
	result = /decl/material/chem/toxin/hair_remover
	required_reagents = list(/decl/material/chem/radium = 1, /decl/material/chem/potassium = 1, /decl/material/chem/acid/hydrochloric = 1)
	result_amount = 3
	mix_message = "The solution thins out and emits an acrid smell."

/datum/chemical_reaction/methyl_bromide
	name = "Methyl Bromide"
	required_reagents = list(/decl/material/chem/toxin/bromide = 1, /decl/material/chem/ethanol = 1, /decl/material/chem/fuel/hydrazine = 1)
	result_amount = 3
	result = /decl/material/gas/methyl_bromide
	mix_message = "The solution begins to bubble, emitting a dark vapor."

/datum/chemical_reaction/adrenaline
	name = "Adrenaline"
	result = /decl/material/chem/adrenaline
	required_reagents = list(/decl/material/chem/nutriment/sugar = 1, /decl/material/chem/amphetamines = 1, /decl/material/chem/oxy_meds = 1)
	result_amount = 3

/datum/chemical_reaction/gleam
	name = "Gleam"
	result = /decl/material/chem/glowsap/gleam
	result_amount = 2
	mix_message = "The surface of the oily, iridescent liquid twitches like a living thing."
	minimum_temperature = 40 CELSIUS
	reaction_sound = 'sound/effects/psi/power_used.ogg'
	catalysts = list(
		/decl/material/chem/enzyme = 1
	)
	required_reagents = list(
		/decl/material/chem/hallucinogenics = 2,
		/decl/material/chem/glowsap = 2
	)

/datum/chemical_reaction/immunobooster
	result = /decl/material/chem/immunobooster
	required_reagents = list(/decl/material/chem/presyncopics = 1, /decl/material/chem/antitoxins = 1)
	minimum_temperature = 40 CELSIUS
	result_amount = 2

/datum/chemical_reaction/Sotalol //you new inaprovalin
	result = /decl/material/chem/sotalol
	required_reagents = list(/decl/material/chem/carbon = 1, /decl/material/chem/nutriment/sugar = 1,/decl/material/chem/acetone = 1)   //old inaprov recipe carbon and sugar are easy but if you want medicine you NEED something special "acetone will do"
	result_amount = 3

/datum/chemical_reaction/arganbalm //as the old greek medicine based on balsamic for recipe? and causes PAIN
	result = /decl/material/chem/arganbalm
	required_reagents = list(/decl/material/chem/sotalol = 1, /decl/material/chem/carbon = 1,/decl/material/iron = 1)   //a steel sheet should get you Carbon and iron to proceed easily
	result_amount = 3
/datum/chemical_reaction/garamycin //1963 medicine for burns. easy tox and pk
	result = /decl/material/chem/garamycin
	required_reagents = list(/decl/material/chem/carbon = 1, /decl/material/chem/ethanol = 1) //synthkin is already easy. this should be even cheaper. to make. 
	result_amount = 4
/datum/chemical_reaction/charcoalcalcium //slowdon and antitox
	result = /decl/material/chem/charcoalcalcium
	required_reagents = list(/decl/material/chem/ammonia = 1, /decl/material/chem/nutriment/sugar = 1)   //easier to get antitox still needs ammonia as a "high grade"
	result_amount = 2
/datum/chemical_reaction/laudanum //the drunk pain med
	result = /decl/material/chem/laudanum
	required_reagents = list(/decl/material/chem/ethanol = 2, /decl/material/chem/nutriment/sugar = 1)  
	minimum_temperature = 35 CELSIUS   //to keep it in line with sedative. carefull to not overheat it with yer lighter
	maximum_temperature = 50 CELSIUS
	result_amount = 3
/datum/chemical_reaction/stemcells    // blood don't forget
	result = /decl/material/chem/stemcells
	required_reagents = list(/decl/material/chem/regenerator = 1, /decl/material/chem/blood = 15)   // 10 blood thats a expensive chem my dude
	result_amount = 1 //all this good have a price. plus you can stack it up with other chems remember

/datum/chemical_reaction/thrombin //stypitc bs powder
	result = /decl/material/chem/thrombin
	required_reagents = list(/decl/material/chem/brute_meds = 1, /decl/material/chem/phosphorus = 1, /decl/material/chem/sulfur = 1)  //you need MEDICAL only chems now so phos and sulfur will do
	result_amount = 3
/datum/chemical_reaction/silversulfadiazine // that bs burn med. 
	result = /decl/material/chem/silversulfadiazine
	required_reagents = list(/decl/material/chem/burn_meds, /decl/material/chem/phosphorus = 1, /decl/material/chem/sulfur = 1) 
	result_amount = 3
/datum/chemical_reaction/ursodiol //dizzy super antitox
	result = /decl/material/chem/ursodiol
	required_reagents = list(/decl/material/chem/carbon = 1, /decl/material/chem/mercury = 1,/decl/material/chem/antitoxins)  //YES mercury. consider me kind not giving you brain damage. or eye damage
	result_amount = 3
/datum/chemical_reaction/dexametasona //dex +
	result = /decl/material/chem/dexametasona
	required_reagents = list(/decl/material/gas/water = 1, /decl/material/chem/oxy_meds = 1,/decl/material/chem/sotalol) 
	result_amount = 3
/datum/chemical_reaction/metamizol //midly painkiller
	result = /decl/material/chem/painkillers/metamizol
	required_reagents = list(/decl/material/chem/laudanum = 1, /decl/material/chem/acid/hydrochloric = 1 ,/decl/material/chem/potassium = 1) 
	result_amount = 3
