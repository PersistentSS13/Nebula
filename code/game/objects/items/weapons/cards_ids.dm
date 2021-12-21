/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the IC data card reader
 */
/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/plastic
	slot_flags = SLOT_EARS
	drop_sound = 'sound/foley/paperpickup1.ogg'
	pickup_sound = 'sound/foley/paperpickup2.ogg'

/obj/item/card/union
	name = "union card"
	desc = "A card showing membership in the local worker's union."
	icon_state = "union"
	slot_flags = SLOT_ID
	var/signed_by

/obj/item/card/union/examine(mob/user)
	. = ..()
	if(signed_by)
		to_chat(user, "It has been signed by [signed_by].")
	else
		to_chat(user, "It has a blank space for a signature.")

/obj/item/card/union/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/pen))
		if(signed_by)
			to_chat(user, SPAN_WARNING("\The [src] has already been signed."))
		else
			var/signature = sanitizeSafe(input("What do you want to sign the card as?", "Union Card") as text, MAX_NAME_LEN)
			if(signature && !signed_by && !user.incapacitated() && Adjacent(user))
				signed_by = signature
				user.visible_message(SPAN_NOTICE("\The [user] signs \the [src] with a flourish."))
		return
	..()

/obj/item/card/data
	name = "data card"
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has a stripe running down the middle."
	icon_state = "data_1"
	var/detail_color = COLOR_ASSEMBLY_ORANGE
	var/function = "storage"
	var/data = "null"
	var/special = null
	var/list/files = list(  )

/obj/item/card/data/Initialize()
	.=..()
	update_icon()

/obj/item/card/data/on_update_icon()
	overlays.Cut()
	var/image/detail_overlay = image('icons/obj/card.dmi', src,"[icon_state]-color")
	detail_overlay.color = detail_color
	overlays += detail_overlay

/obj/item/card/data/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/integrated_electronics/detailer))
		var/obj/item/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
	return ..()

/obj/item/card/data/full_color
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has the entire card colored."
	icon_state = "data_2"

/obj/item/card/data/disk
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one inexplicibly looks like a floppy disk."
	icon_state = "data_3"

/*
 * ID CARDS
 */

/obj/item/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "{'magnets':2,'esoteric':2}"

/obj/item/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "{'magnets':2,'esoteric':2}"
	var/uses = 10

	var/static/list/card_choices = list(
							/obj/item/card/emag,
							/obj/item/card/union,
							/obj/item/card/data,
							/obj/item/card/data/full_color,
							/obj/item/card/data/disk,
							/obj/item/card/id,
						) //Should be enough of a selection for most purposes

var/global/const/NO_EMAG_ACT = -50
/obj/item/card/emag/resolve_attackby(atom/A, mob/user)
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses == NO_EMAG_ACT)
		return ..(A, user)

	uses -= used_uses
	A.add_fingerprint(user)
	if(used_uses)
		log_and_message_admins("emagged \an [A].")

	if(uses<1)
		user.visible_message("<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		var/obj/item/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)

	return 1

/obj/item/card/emag/Initialize()
	. = ..()
	if(length(card_choices) && !card_choices[card_choices[1]])
		card_choices = generate_chameleon_choices(card_choices)

/obj/item/card/emag/verb/change(picked in card_choices)
	set name = "Change Cryptographic Sequencer Appearance"
	set category = "Chameleon Items"
	set src in usr

	if (!(usr.incapacitated()))
		if(!ispath(card_choices[picked]))
			return

		disguise(card_choices[picked], usr)

/obj/item/card/emag/examine(mob/user)
	. = ..()
	if(user.skill_check(SKILL_DEVICES,SKILL_ADEPT))
		to_chat(user, SPAN_WARNING("This ID card has some form of non-standard modifications."))

/obj/item/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access."
	icon = 'icons/obj/id/id.dmi'
	slot_flags = SLOT_ID
	var/list/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	var/associated_account_number = 0

	// Associated network account. For normal IDs this is simply informational, but for network enabled IDs this is used for group-based access.
	var/list/associated_network_account = list("login" = "", "password" = "")

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

	var/datum/mil_branch/military_branch = null //Vars for tracking branches and ranks on multi-crewtype maps
	var/datum/mil_rank/military_rank = null

	var/formal_name_prefix
	var/formal_name_suffix

	var/detail_color
	var/extra_details

/obj/item/card/id/Initialize()
	. = ..()
	update_icon()

/obj/item/card/id/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && detail_color)
		overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-colors", detail_color, RESET_COLOR)
	. = ..()

/obj/item/card/id/on_update_icon()
	cut_overlays()
	if(detail_color)
		add_overlay(overlay_image(icon, "[icon_state]-colors", detail_color, RESET_COLOR))
	for(var/detail in extra_details)
		add_overlay(overlay_image(icon, detail, flags = RESET_COLOR))

/obj/item/card/id/Topic(href, href_list, datum/topic_state/state)
	var/mob/user = usr
	if(href_list["look_at_id"] && istype(user))
		var/turf/T = get_turf(src)
		if(T.CanUseTopic(user, global.view_topic_state) != STATUS_CLOSE)
			user.examinate(src)
			return TOPIC_HANDLED
	. = ..()

/obj/item/card/id/examine(mob/user, distance)
	. = ..()
	to_chat(user, "It says '[get_display_name()]'.")
	if(distance <= 1)
		show(user)

/obj/item/card/id/proc/prevent_tracking()
	return 0

/obj/item/card/id/proc/show(mob/user)
	if(front && side)
		send_rsc(user, front, "front.png")
		send_rsc(user, side, "side.png")
	var/datum/browser/written_physical/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat())
	popup.open()
	return

/obj/item/card/id/proc/get_display_name()
	. = registered_name
	if(military_rank && military_rank.name_short)
		. ="[military_rank.name_short] [.][formal_name_suffix]"
	else if(formal_name_prefix || formal_name_suffix)
		. = "[formal_name_prefix][.][formal_name_suffix]"
	if(assignment)
		. += ", [assignment]"

/obj/item/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, always_use_defdir = 1)
	side = getFlatIcon(M, WEST, always_use_defdir = 1)

/mob/proc/set_id_info(var/obj/item/card/id/id_card)
	id_card.age = 0

	id_card.formal_name_prefix = initial(id_card.formal_name_prefix)
	id_card.formal_name_suffix = initial(id_card.formal_name_suffix)
	if(client && client.prefs)
		for(var/culturetag in client.prefs.cultural_info)
			var/decl/cultural_info/culture = GET_DECL(client.prefs.cultural_info[culturetag])
			if(culture)
				id_card.formal_name_prefix = "[culture.get_formal_name_prefix()][id_card.formal_name_prefix]"
				id_card.formal_name_suffix = "[id_card.formal_name_suffix][culture.get_formal_name_suffix()]"

	id_card.registered_name = real_name

	var/decl/pronouns/G = get_pronouns()
	if(G)
		id_card.sex = capitalize(G.formal_term)
	else
		id_card.sex = "Unset"
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)

/mob/living/carbon/human/set_id_info(var/obj/item/card/id/id_card)
	..()
	id_card.age = get_age()
	if(global.using_map.flags & MAP_HAS_BRANCH)
		id_card.military_branch = char_branch
	if(global.using_map.flags & MAP_HAS_RANK)
		id_card.military_rank = char_rank

/obj/item/card/id/proc/dat()
	var/list/dat = list("<table><tr><td>")
	dat += text("Name: []</A><BR>", "[formal_name_prefix][registered_name][formal_name_suffix]")
	dat += text("Sex: []</A><BR>\n", sex)
	dat += text("Age: []</A><BR>\n", age)

	if(global.using_map.flags & MAP_HAS_BRANCH)
		dat += text("Branch: []</A><BR>\n", military_branch ? military_branch.name : "\[UNSET\]")
	if(global.using_map.flags & MAP_HAS_RANK)
		dat += text("Rank: []</A><BR>\n", military_rank ? military_rank.name : "\[UNSET\]")

	dat += text("Assignment: []</A><BR>\n", assignment)
	dat += text("Fingerprint: []</A><BR>\n", fingerprint_hash)
	dat += text("Blood Type: []<BR>\n", blood_type)
	dat += text("DNA Hash: []<BR><BR>\n", dna_hash)
	if(front && side)
		dat +="<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4><img src=side.png height=80 width=80 border=4></td>"
	dat += "</tr></table>"
	return jointext(dat,null)

/obj/item/card/id/attack_self(mob/user)
	user.visible_message("\The [user] shows you: [html_icon(src)] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: [html_icon(src)] [src.name]. The assignment on the card: [src.assignment]")

	src.add_fingerprint(user)
	return

/obj/item/card/id/GetAccess()
	return access.Copy()

/obj/item/card/id/GetIdCard()
	return src

/obj/item/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "[html_icon(src)] [name]: The current assignment on the card is [assignment].")
	to_chat(usr, "The blood type on the card is [blood_type].")
	to_chat(usr, "The DNA hash on the card is [dna_hash].")
	to_chat(usr, "The fingerprint hash on the card is [fingerprint_hash].")
	return

/decl/vv_set_handler/id_card_military_branch
	handled_type = /obj/item/card/id
	handled_vars = list("military_branch")

/decl/vv_set_handler/id_card_military_branch/handle_set_var(var/obj/item/card/id/id, variable, var_value, client)
	if(!var_value)
		id.military_branch = null
		id.military_rank = null
		return

	if(istype(var_value, /datum/mil_branch))
		if(var_value != id.military_branch)
			id.military_branch = var_value
			id.military_rank = null
		return

	if(ispath(var_value, /datum/mil_branch) || istext(var_value))
		var/datum/mil_branch/new_branch = mil_branches.get_branch(var_value)
		if(new_branch)
			if(new_branch != id.military_branch)
				id.military_branch = new_branch
				id.military_rank = null
			return

	to_chat(client, SPAN_WARNING("Input, must be an existing branch - [var_value] is invalid"))

/decl/vv_set_handler/id_card_military_rank
	handled_type = /obj/item/card/id
	handled_vars = list("military_rank")

/decl/vv_set_handler/id_card_military_rank/handle_set_var(var/obj/item/card/id/id, variable, var_value, client)
	if(!var_value)
		id.military_rank = null
		return

	if(!id.military_branch)
		to_chat(client, SPAN_WARNING("military_branch not set - No valid ranks available"))
		return

	if(ispath(var_value, /datum/mil_rank))
		var/datum/mil_rank/rank = var_value
		var_value = initial(rank.name)

	if(istype(var_value, /datum/mil_rank))
		var/datum/mil_rank/rank = var_value
		var_value = rank.name

	if(istext(var_value))
		var/new_rank = mil_branches.get_rank(id.military_branch.name, var_value)
		if(new_rank)
			id.military_rank = new_rank
			return

	to_chat(client, SPAN_WARNING("Input must be an existing rank belonging to military_branch - [var_value] is invalid"))

/obj/item/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate, access_external_airlocks)
	color = COLOR_RED_GRAY
	detail_color = COLOR_GRAY40

/obj/item/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"
	detail_color = COLOR_AMBER

/obj/item/card/id/captains_spare/Initialize()
	. = ..()
	access = get_all_station_access()

/obj/item/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for lawed synthetics."
	icon_state = "robot_base"
	assignment = "Synthetic"
	detail_color = COLOR_AMBER

/obj/item/card/id/synthetic/Initialize()
	. = ..()
	access = get_all_station_access() + access_synth

/obj/item/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	registered_name = "Central Command"
	assignment = "General"
	color = COLOR_GRAY40
	detail_color = COLOR_COMMAND_BLUE
	extra_details = list("goldstripe")

/obj/item/card/id/centcom/station/Initialize()
	. = ..()
	access |= get_all_station_access()

/obj/item/card/id/centcom/ERT
	name = "\improper Emergency Response Team ID"
	assignment = "Emergency Response Team"

/obj/item/card/id/centcom/ERT/Initialize()
	. = ..()
	access |= get_all_station_access()

/obj/item/card/id/all_access
	name = "\improper Administrator's spare ID"
	desc = "The spare ID of the Lord of Lords himself."
	registered_name = "Administrator"
	assignment = "Administrator"
	detail_color = COLOR_MAROON
	extra_details = list("goldstripe")

/obj/item/card/id/all_access/Initialize()
	. = ..()
	access = get_access_ids()

/obj/item/card/id/civilian
	name = "identification card"
	desc = "A card issued to civilian staff."
	detail_color = COLOR_CIVIE_GREEN

/obj/item/card/id/civilian/head //This is not the HoP. There's no position that uses this right now.
	name = "identification card"
	desc = "A card which represents common sense and responsibility."
	extra_details = list("goldstripe")

/obj/item/card/id/merchant
	name = "identification card"
	desc = "A card issued to Merchants, indicating their right to sell and buy goods."
	access = list(access_merchant)
	color = COLOR_OFF_WHITE
	detail_color = COLOR_BEIGE

/obj/item/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	item_state = "silver_id"

/obj/item/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	color = "#d4c780"
	extra_details = list("goldstripe")

/*
 * NETWORK-ENABLED ID CARDS
 */

/obj/item/card/id/network
	var/network_id												// The network_id that this card is paired to.
	var/weakref/current_account
	color = COLOR_GRAY80
	detail_color = COLOR_SKY_BLUE

/obj/item/card/id/network/Initialize()
	set_extension(src, /datum/extension/network_device/lazy)
	return ..()

/obj/item/card/id/network/GetAccess(var/ignore_account)
	. = ..()
	var/datum/computer_file/data/account/access_account = resolve_account()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network()
	if(network && access_account && access_account.login != ignore_account)
		var/location = "[network.network_id]"
		if(access_account)
			. += "[access_account.login]@[location]" // User access uses '@'
			for(var/group in access_account.groups)
				. += "[group].[location]"	// Group access uses '.'
			for(var/group in access_account.parent_groups) // Membership in a child group grants access to anything with an access requirement set to the parent group.
				. += "[group].[location]"

/obj/item/card/id/network/proc/resolve_account()
	if(!current_account)
		return
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network()

	var/login = associated_network_account["login"]
	var/password = associated_network_account["password"]

	var/account_lookup_failed = FALSE
	var/datum/computer_file/data/account/check_account = current_account.resolve()
	if(!network) // No network or connectivity.
		account_lookup_failed = TRUE
	else if(!istype(check_account))
		account_lookup_failed = TRUE
	else if(check_account.login != login || check_account.password != password) // The most likely case - login or password were changed.
		account_lookup_failed = TRUE
	// Check if the account can be located on the network in case it was moved.
	else if(!(check_account in network.get_accounts()))
		account_lookup_failed = TRUE
	
	if(account_lookup_failed)
		current_account = null
		visible_message(SPAN_WARNING("\The [src] emits a short buzz, indicating a network or login error"),null,null,1)
	else
		return check_account

/obj/item/card/id/network/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null)
	var/data[0]
	var/login  = associated_network_account["login"]
	var/password = associated_network_account["password"]

	data["login"] = login ? login : "Enter Login"
	data["password"] = password ? stars(password, 0) : "Enter Password"
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "network_id.tmpl", "Network ID Settings", 540, 326)
		ui.set_initial_data(data)
		ui.open()

/obj/item/card/id/network/Topic(href, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	var/login  = associated_network_account["login"]
	var/password = associated_network_account["password"]
	if(href_list["change_login"])
		var/new_login = sanitize(input(usr, "Enter your account login:", "Account login", login) as text|null)
		if(new_login == login || !CanInteract(usr, DefaultTopicState()))
			return TOPIC_NOACTION
		associated_network_account["login"] = new_login

		current_account = null
		password = null
		return TOPIC_REFRESH

	if(href_list["change_password"])
		var/new_password = sanitize(input(usr, "Enter your account password:", "Account password") as text|null)
		if(new_password == password || !CanInteract(usr, DefaultTopicState()))
			return TOPIC_NOACTION
		associated_network_account["password"] = new_password

		current_account = null
		return TOPIC_REFRESH
	
	if(href_list["login_account"])
		if(login_account())
			to_chat(usr, SPAN_NOTICE("Account successfully logged in."))
		else
			to_chat(usr, SPAN_WARNING("Could not login to account. Check password or network connectivity."))
		return TOPIC_REFRESH

	if(href_list["settings"])
		var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(usr)
		return TOPIC_HANDLED

/obj/item/card/id/network/proc/login_account()
	. = FALSE
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network()
	if(!network)
		return
	var/login  = associated_network_account["login"]
	var/password = associated_network_account["password"]
	for(var/datum/computer_file/data/account/check_account in network.get_accounts())
		if(check_account.login == login && check_account.password == password)
			current_account = weakref(check_account)
			return TRUE

/obj/item/card/id/network/verb/adjust_settings()
	set name = "Adjust Settings"
	set category = "Object"
	set src in usr

	ui_interact(usr)