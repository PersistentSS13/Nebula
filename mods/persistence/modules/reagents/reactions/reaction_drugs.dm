/datum/chemical_reaction/painkillers
	name = "oxycodone"  //REAL name again

/datum/chemical_reaction/antiseptic
	name = "chlorocresol" //real fucking name

/datum/chemical_reaction/psychoactives
	name = "L. S. D."

/datum/chemical_reaction/antirads
	name = "potassium iodide"  //REAL NAMES at LEASSST

/datum/chemical_reaction/oxy_meds
	name = "betametasona"  //at least give it a real name instead of OXIGEN MEDICATION

/datum/chemical_reaction/amphetamines
	name = "dextroamphetamine" // real. fucking name.

/datum/chemical_reaction/antibiotics
	name = "Penicillin" //lets go with the classics.. AY?

/datum/chemical_reaction/eyedrops
	name = "polyethylene glycol"

/datum/chemical_reaction/sedatives
	name = "chloral hydrate"
	minimum_temperature = 90 CELSIUS   // this should keep recipes stable and add some .. difficulty for a SEDATIVE
	maximum_temperature = 100 CELSIUS

/datum/chemical_reaction/paralytics
	name = "Botulinum" //yes thats what it is

/datum/chemical_reaction/hallucinogenics
	name = "THC"

/datum/chemical_reaction/stimulants
	name = "erythropoietin"  //yes real dopping is made with this too.

/datum/chemical_reaction/antidepressants
	name = "fluoxetine" //another real one

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