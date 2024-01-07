/datum/fabricator_recipe/protolathe/weapon/rapidsyringe
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/temp_gun
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/confuseray
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/nuclear_gun
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/lasercannon
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/xrayrifle
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/grenadelauncher
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/flechette
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/radpistol
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/decloner
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/wt550
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/weapon/bullpup
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/ammo
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/ammo/stunshell
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/ammo/ammo_emp_small
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/ammo/ammo_emp_pistol
	research_excluded = TRUE

/datum/fabricator_recipe/protolathe/ammo/ammo_emp_slug
	research_excluded = TRUE

/obj/item/gun/projectile/update_base_icon() // sets streamlined way for mag-fed guns to check they sprites
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "[get_world_inventory_state()]-loaded"
		else
			icon_state = "[get_world_inventory_state()]-empty"
	else
		icon_state = get_world_inventory_state()

/obj/item/gun/projectile/pistol/update_base_icon() // pistols have a snowflake method of checking load sprites upstream, so we're making them use the same way as all the other mag-guns via this
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "[get_world_inventory_state()]-loaded"
		else
			icon_state = "[get_world_inventory_state()]-empty"
	else
		icon_state = get_world_inventory_state()