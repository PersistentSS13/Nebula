/datum/category_item/player_setup_item/physical/basic/content()

	. = list()
	. += "<b>Name:</b> "
	if(pref.real_name)
		. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	else
		. += "<a href='?src=\ref[src];rename=1'><b>*UNSET*</b></a><br>"
	. += "<a href='?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	. += "<hr>"

	. += "<b>Bodytype:</b> "
	var/decl/species/S = get_species_by_key(pref.species)
	for(var/decl/bodytype/B in S.available_bodytypes)
		if(B.name == pref.bodytype)
			. += "<span class='linkOn'>[capitalize(B.name)]</span>"
		else
			. += "<a href='?src=\ref[src];bodytype=\ref[B]'>[capitalize(B.name)]</a>"

	. += "<br><b>Pronouns:</b> "
	for(var/decl/pronouns/G in S.available_pronouns)
		if(G.name == pref.gender)
			. += "<span class='linkOn'>[capitalize(G.name)]</span>"
		else
			. += "<a href='?src=\ref[src];gender=\ref[G]'>[capitalize(G.name)]</a>"
/**
	var/decl/spawnpoint/spawnpoint = GET_DECL(pref.spawnpoint)
	. += "<br><b>Spawn point</b>: <a href='?src=\ref[src];spawnpoint=1'>[spawnpoint.name]</a>"
**/
	. = jointext(.,null)
