////////////////////////////////////////////////////////////////////////
// Sorting Junction Tags
////////////////////////////////////////////////////////////////////////

#define OUTREACH_SORT_TAG_COMMAND     "command"
#define OUTREACH_SORT_TAG_MINING      "mining"
#define OUTREACH_SORT_TAG_ENGINEERING "engineer"
#define OUTREACH_SORT_TAG_MEDICAL     "medical"
#define OUTREACH_SORT_TAG_HYDRO       "hydroponics"
#define OUTREACH_SORT_TAG_KITCHEN     "kitchen"
#define OUTREACH_SORT_TAG_SECURITY    "security"
#define OUTREACH_SORT_TAG_HANGAR      "hangar"
#define OUTREACH_SORT_TAG_CARGO       "cargo"
#define OUTREACH_SORT_TAG_CARGO_HALL  "cargo_hall"
#define OUTREACH_SORT_TAG_CHEMISTRY   "chemistry"
#define OUTREACH_SORT_TAG_ARRIVAL     "arrival"

////////////////////////////////////////////////////////////////////////
// Sorting Junctions Templates
////////////////////////////////////////////////////////////////////////

/obj/structure/disposalpipe/sortjunction/command
	sort_type = OUTREACH_SORT_TAG_COMMAND
/obj/structure/disposalpipe/sortjunction/flipped/command
	sort_type = OUTREACH_SORT_TAG_COMMAND

/obj/structure/disposalpipe/sortjunction/mining
	sort_type = OUTREACH_SORT_TAG_MINING
/obj/structure/disposalpipe/sortjunction/flipped/mining
	sort_type = OUTREACH_SORT_TAG_MINING

/obj/structure/disposalpipe/sortjunction/engineering
	sort_type = OUTREACH_SORT_TAG_ENGINEERING
/obj/structure/disposalpipe/sortjunction/flipped/engineering
	sort_type = OUTREACH_SORT_TAG_ENGINEERING

/obj/structure/disposalpipe/sortjunction/medical
	sort_type = OUTREACH_SORT_TAG_MEDICAL
/obj/structure/disposalpipe/sortjunction/flipped/medical
	sort_type = OUTREACH_SORT_TAG_MEDICAL

/obj/structure/disposalpipe/sortjunction/hydroponics
	sort_type = OUTREACH_SORT_TAG_HYDRO
/obj/structure/disposalpipe/sortjunction/flipped/hydroponics
	sort_type = OUTREACH_SORT_TAG_HYDRO

/obj/structure/disposalpipe/sortjunction/kitchen
	sort_type = OUTREACH_SORT_TAG_KITCHEN
/obj/structure/disposalpipe/sortjunction/flipped/kitchen
	sort_type = OUTREACH_SORT_TAG_KITCHEN

/obj/structure/disposalpipe/sortjunction/security
	sort_type = OUTREACH_SORT_TAG_SECURITY
/obj/structure/disposalpipe/sortjunction/flipped/security
	sort_type = OUTREACH_SORT_TAG_SECURITY

/obj/structure/disposalpipe/sortjunction/hangar
	sort_type = OUTREACH_SORT_TAG_HANGAR
/obj/structure/disposalpipe/sortjunction/flipped/hangar
	sort_type = OUTREACH_SORT_TAG_HANGAR

/obj/structure/disposalpipe/sortjunction/cargo
	sort_type = OUTREACH_SORT_TAG_CARGO
/obj/structure/disposalpipe/sortjunction/flipped/cargo
	sort_type = OUTREACH_SORT_TAG_CARGO

/obj/structure/disposalpipe/sortjunction/cargo_hall
	sort_type = OUTREACH_SORT_TAG_CARGO_HALL
/obj/structure/disposalpipe/sortjunction/flipped/cargo_hall
	sort_type = OUTREACH_SORT_TAG_CARGO_HALL

/obj/structure/disposalpipe/sortjunction/chemistry
	sort_type = OUTREACH_SORT_TAG_CHEMISTRY
/obj/structure/disposalpipe/sortjunction/flipped/chemistry
	sort_type = OUTREACH_SORT_TAG_CHEMISTRY

/obj/structure/disposalpipe/sortjunction/arrival
	sort_type = OUTREACH_SORT_TAG_ARRIVAL
/obj/structure/disposalpipe/sortjunction/flipped/arrival
	sort_type = OUTREACH_SORT_TAG_ARRIVAL

////////////////////////////////////////////////////////////////////////
// Destination Tagger
////////////////////////////////////////////////////////////////////////

//Write down all the available tags from the get go.
/obj/item/destTagger/outreach
	last_used_tags = list(
		OUTREACH_SORT_TAG_COMMAND,
		OUTREACH_SORT_TAG_MINING,
		OUTREACH_SORT_TAG_ENGINEERING,
		OUTREACH_SORT_TAG_MEDICAL,
		OUTREACH_SORT_TAG_HYDRO,
		OUTREACH_SORT_TAG_KITCHEN,
		OUTREACH_SORT_TAG_SECURITY,
		OUTREACH_SORT_TAG_HANGAR,
		OUTREACH_SORT_TAG_CARGO,
		OUTREACH_SORT_TAG_CARGO_HALL,
		OUTREACH_SORT_TAG_CHEMISTRY,
		OUTREACH_SORT_TAG_ARRIVAL,
	)

/obj/structure/disposalpipe/tagger/command
	sort_tag = OUTREACH_SORT_TAG_COMMAND
/obj/structure/disposalpipe/tagger/mining
	sort_tag = OUTREACH_SORT_TAG_MINING
/obj/structure/disposalpipe/tagger/engineering
	sort_tag = OUTREACH_SORT_TAG_ENGINEERING
/obj/structure/disposalpipe/tagger/medical
	sort_tag = OUTREACH_SORT_TAG_MEDICAL
/obj/structure/disposalpipe/tagger/hydro
	sort_tag = OUTREACH_SORT_TAG_HYDRO
/obj/structure/disposalpipe/tagger/kitchen
	sort_tag = OUTREACH_SORT_TAG_KITCHEN
/obj/structure/disposalpipe/tagger/security
	sort_tag = OUTREACH_SORT_TAG_SECURITY
/obj/structure/disposalpipe/tagger/hangar
	sort_tag = OUTREACH_SORT_TAG_HANGAR
/obj/structure/disposalpipe/tagger/cargo
	sort_tag = OUTREACH_SORT_TAG_CARGO
/obj/structure/disposalpipe/tagger/cargo_hall
	sort_tag = OUTREACH_SORT_TAG_CARGO_HALL
/obj/structure/disposalpipe/tagger/chemistry
	sort_tag = OUTREACH_SORT_TAG_CHEMISTRY
/obj/structure/disposalpipe/tagger/arrival
	sort_tag = OUTREACH_SORT_TAG_ARRIVAL