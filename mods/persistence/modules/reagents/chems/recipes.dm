/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	result = /decl/material/liquid/bicaridine
	required_reagents = list(/decl/material/liquid/stabilizer = 1, /decl/material/liquid/blood = 1, /decl/material/solid/silicon = 1)
	inhibitors = list(/decl/material/liquid/nutriment/sugar = 1) // Messes up with adrenaline
	result_amount = 1

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	result = /decl/material/liquid/kelotane
	required_reagents = list(/decl/material/solid/carbon = 1, /decl/material/solid/metal/silver = 1, /decl/material/liquid/ethanol = 1)
	result_amount = 1
	log_is_important = 1

/datum/chemical_reaction/dexalinplus
	name = "Dexalin Plus"
	result = /decl/material/liquid/dexalinplus
	required_reagents = list(/decl/material/liquid/oxy_meds = 1, /decl/material/solid/metal/iron = 1)
	result_amount = 1

/datum/chemical_reaction/paracetamol
	name = "Paracetamol"
	result = /decl/material/liquid/painkillers/paracetamol
	required_reagents = list(/decl/material/solid/potassium = 1, /decl/material/liquid/acetone = 1) 
	result_amount = 2

/datum/chemical_reaction/ultradex
	name = "Ultra Dexalin"
	result = /decl/material/liquid/ultradex
	required_reagents = list(/decl/material/liquid/dexalinplus = 1, /decl/material/solid/metal/tin = 1)
	catalysts = list(/decl/material/solid/metal/depleted_uranium = 5)
	result_amount = 1

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	result = /decl/material/liquid/painkillers/oxycodone
	required_reagents = list(/decl/material/liquid/painkillers = 1, /decl/material/solid/metal/zinc = 1)
	catalysts = list(/decl/material/solid/metal/plutonium = 5)
	result_amount = 1