/decl/material/chem/painkillers
	name = "oxycodone"
	color = "#cb68fc91"

/decl/material/chem/painkillers/metamizol //with white wine and some herbs a primitive painkiller
	name = "Metamizol"
	lore_text = "one of the oldest painkilers of time, might work. but will certainly get you drunk."
	taste_description = "sourness"
	color = "#b686ce80"
	overdose = 20
	scannable = 1
	metabolism = 1
	ingest_met = 0.02
	flags = IGNORE_MOB_SIZE
	value = 1.8
	pain_power = 60 //magnitide of painkilling effect
	effective_dose = 0.1 //how many units it need to process to reach max power 
