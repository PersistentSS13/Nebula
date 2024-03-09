///////////////////////////////////////////////////////////////////////////////
// item/card/id
///////////////////////////////////////////////////////////////////////////////

SAVED_VAR(/obj/item/card/id, access)
SAVED_VAR(/obj/item/card/id, registered_name)
SAVED_VAR(/obj/item/card/id, associated_account_id)
SAVED_VAR(/obj/item/card/id, associated_network_account)
SAVED_VAR(/obj/item/card/id, age)
SAVED_VAR(/obj/item/card/id, blood_type)
SAVED_VAR(/obj/item/card/id, dna_hash)
SAVED_VAR(/obj/item/card/id, fingerprint_hash)
SAVED_VAR(/obj/item/card/id, card_gender)
SAVED_VAR(/obj/item/card/id, front)
SAVED_VAR(/obj/item/card/id, side)
SAVED_VAR(/obj/item/card/id, assignment)
SAVED_VAR(/obj/item/card/id, military_branch)
SAVED_VAR(/obj/item/card/id, military_rank)
SAVED_VAR(/obj/item/card/id, formal_name_prefix)
SAVED_VAR(/obj/item/card/id, formal_name_suffix)
SAVED_VAR(/obj/item/card/id, detail_color)
SAVED_VAR(/obj/item/card/id, extra_details)

///////////////////////////////////////////////////////////////////////////////
// Antag Ids
///////////////////////////////////////////////////////////////////////////////

/obj/item/card/id/network/syndicate_command
	name            = "syndicate ID card"
	desc            = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment      = "Syndicate Overlord"
	color           = COLOR_RED_GRAY
	detail_color    = COLOR_GRAY40

///////////////////////////////////////////////////////////////////////////////
// Synth Ids
///////////////////////////////////////////////////////////////////////////////

/obj/item/card/id/network/synthetic
	name         = "\improper Synthetic ID"
	desc         = "Access module for lawed synthetics."
	icon_state   = "robot_base"
	assignment   = "Synthetic"
	detail_color = COLOR_AMBER
/obj/item/card/id/network/synthetic/Initialize(ml, material_key)
	. = ..()
	access = get_all_station_access() + access_synth

///////////////////////////////////////////////////////////////////////////////
// Admin Ids
///////////////////////////////////////////////////////////////////////////////

/obj/item/card/id/network/all_access
	name            = "\improper Administrator's spare ID"
	desc            = "The spare ID of the Lord of Lords himself."
	registered_name = "Administrator"
	assignment      = "Administrator"
	detail_color    = COLOR_MAROON
	extra_details   = list("goldstripe")
/obj/item/card/id/network/all_access/Initialize(ml, material_key)
	. = ..()
	access = get_access_ids()

///////////////////////////////////////////////////////////////////////////////
// Base Id Card Types
///////////////////////////////////////////////////////////////////////////////

/obj/item/card/id/network/civilian
	desc = "A card issued to civilian staff."
	detail_color = COLOR_CIVIE_GREEN

/obj/item/card/id/network/civilian/merchant
	desc = "A card issued to Merchants, indicating their right to sell and buy goods."
	access = list(access_merchant)
	color = COLOR_OFF_WHITE
	detail_color = COLOR_BEIGE

/obj/item/card/id/network/civilian/mercenary
	desc = "A card issued to Mercenary, indicating they might be trouble."
	access = list(access_mercenary)
	color = COLOR_OFF_WHITE
	detail_color = COLOR_RED_GRAY

/obj/item/card/id/network/cargo
	desc = "A card issued to cargo staff."
	detail_color = COLOR_BROWN

/obj/item/card/id/network/engineering
	desc = "A card issued to engineering staff."
	detail_color = COLOR_SUN

/obj/item/card/id/network/medical
	desc = "A card issued to medical staff."
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/card/id/network/science
	desc = "A card issued to science staff."
	detail_color = COLOR_PALE_PURPLE_GRAY

/obj/item/card/id/network/security
	desc = "A card issued to security staff."
	color = COLOR_OFF_WHITE
	detail_color = COLOR_MAROON

///////////////////////////////////////////////////////////////////////////////
// Base Heads Id Card Types
///////////////////////////////////////////////////////////////////////////////

/obj/item/card/id/network/civilian/head
	desc = "A card which represents common sense and responsibility."
	extra_details = list("goldstripe")

/obj/item/card/id/network/cargo/head
	desc = "A card which represents service and planning."
	extra_details = list("goldstripe")

/obj/item/card/id/network/engineering/head
	desc = "A card which represents creativity and ingenuity."
	extra_details = list("goldstripe")

/obj/item/card/id/network/medical/head
	desc = "A card which represents care and compassion."
	extra_details = list("goldstripe")

/obj/item/card/id/network/science/head
	desc = "A card which represents knowledge and reasoning."
	extra_details = list("goldstripe")

/obj/item/card/id/network/security/head
	desc = "A card which represents honor and protection."
	extra_details = list("goldstripe")

///////////////////////////////////////////////////////////////////////////////
// Fancy Cards
///////////////////////////////////////////////////////////////////////////////

/obj/item/card/id/network/silver
	desc = "A silver card which shows honour and dedication."
	color = COLOR_SILVER
	detail_color = COLOR_STEEL

/obj/item/card/id/network/gold
	desc = "A golden card which shows power and might."
	color = "#d4c780"
	extra_details = list("goldstripe")
