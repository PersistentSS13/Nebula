// Override to cut out the 'dummy' image creation, which is unneccesary on load.
/datum/computer_file/report/crew_record/load_from_mob(var/mob/living/carbon/human/H)
	if(istype(H))
		photo_front = getFlatIcon(H, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(H, WEST, always_use_defdir = 1)
	else
		photo_front = getFlatIcon()
		photo_side = getFlatIcon()

	// Add honorifics, etc.
	var/formal_name = "Unset"
	if(H)
		formal_name = H.real_name
		if(H.client && H.client.prefs)
			for(var/culturetag in H.client.prefs.cultural_info)
				var/decl/cultural_info/culture = SSlore.get_culture(H.client.prefs.cultural_info[culturetag])
				if(H.char_rank && H.char_rank.name_short)
					formal_name = "[formal_name][culture.get_formal_name_suffix()]"
				else
					formal_name = "[culture.get_formal_name_prefix()][formal_name][culture.get_formal_name_suffix()]"

	// Generic record
	set_name(H ? H.real_name : "Unset")
	set_formal_name(formal_name)
	set_job(H ? GetAssignment(H) : "Unset")
	var/gender_term = "Unset"
	if(H)
		var/datum/gender/G = gender_datums[H.get_sex()]
		if(G)
			gender_term = gender2text(G.formal_term)
	set_sex(gender_term)
	set_age(H ? H.age : 30)
	set_status(GLOB.default_physical_status)
	set_species(H ? H.get_species() : GLOB.using_map.default_species)
	set_branch(H ? (H.char_branch && H.char_branch.name) : "None")
	set_rank(H ? (H.char_rank && H.char_rank.name) : "None")
	set_public_record(H && H.public_record && !jobban_isbanned(H, "Records") ? html_decode(H.public_record) : "No record supplied")

	// Medical record
	set_bloodtype(H ? H.b_type : "Unset")
	set_medRecord((H && H.med_record && !jobban_isbanned(H, "Records") ? html_decode(H.med_record) : "No record supplied"))

	if(H)
		if(H.isSynthetic())
			set_implants("Fully synthetic body")
		else
			var/organ_data = list("\[*\]")
			for(var/obj/item/organ/external/E in H.organs)
				if(BP_IS_PROSTHETIC(E))
					organ_data += "[E.model ? "[E.model] " : null][E.name] prosthetic"
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(BP_IS_ASSISTED(I))
					organ_data += I.get_mechanical_assisted_descriptor()
				else if (BP_IS_PROSTHETIC(I))
					organ_data += "[I.name] prosthetic"
			set_implants(jointext(organ_data, "\[*\]"))

	// Security record
	set_criminalStatus(GLOB.default_security_status)
	set_dna(H ? H.dna.unique_enzymes : "")
	set_fingerprint(H ? md5(H.dna.uni_identity) : "")
	set_secRecord(H && H.sec_record && !jobban_isbanned(H, "Records") ? html_decode(H.sec_record) : "No record supplied")

	// Employment record
	var/employment_record = "No record supplied"
	if(H)
		if(H.gen_record && !jobban_isbanned(H, "Records"))
			employment_record = html_decode(H.gen_record)
		if(H.client && H.client.prefs)
			var/list/qualifications
			for(var/culturetag in H.client.prefs.cultural_info)
				var/decl/cultural_info/culture = SSlore.get_culture(H.client.prefs.cultural_info[culturetag])
				var/extra_note = culture.get_qualifications()
				if(extra_note)
					LAZYADD(qualifications, extra_note)
			if(LAZYLEN(qualifications))
				employment_record = "[employment_record ? "[employment_record]\[br\]" : ""][jointext(qualifications, "\[br\]>")]"
	set_emplRecord(employment_record)

	// Misc cultural info.
	set_homeSystem(H ? html_decode(H.get_cultural_value(TAG_HOMEWORLD)) : "Unset")
	set_faction(H ? html_decode(H.get_cultural_value(TAG_FACTION)) : "Unset")
	set_religion(H ? html_decode(H.get_cultural_value(TAG_RELIGION)) : "Unset")

	if(H)
		var/skills = list()
		for(var/decl/hierarchy/skill/S in GLOB.skills)
			var/level = H.get_skill_value(S.type)
			if(level > SKILL_NONE)
				skills += "[S.name], [S.levels[level]]"

		set_skillset(jointext(skills,"\n"))

	// Antag record
	set_antagRecord(H && H.exploit_record && !jobban_isbanned(H, "Records") ? html_decode(H.exploit_record) : "")