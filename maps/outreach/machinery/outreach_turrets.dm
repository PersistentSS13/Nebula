///////////////////////////////////////////////////
// Base Network Turret For Outreach
///////////////////////////////////////////////////

/obj/machinery/turret/network/outreach
	check_access    = TRUE
	check_weapons   = FALSE
	check_records   = TRUE
	check_arrest    = TRUE
	check_lifeforms = TRUE
	initial_access  = list(list(access_security), list(access_bridge), list(access_ce))
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/capacitor/super = 1,
		/obj/item/stock_parts/scanning_module/phasic = 1,
		/obj/item/stock_parts/manipulator/pico = 2,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_connect,
		/decl/stock_part_preset/network_lock/outreach/command,
	)

///////////////////////////////////////////////////
// Energy Turret Basic Variants
///////////////////////////////////////////////////

/obj/machinery/turret/network/outreach/stun
	installed_gun = /obj/item/gun/energy/taser/mounted

/obj/machinery/turret/network/outreach/lethal
	installed_gun = /obj/item/gun/energy/gun/mounted

/obj/machinery/turret/network/outreach/lethal/canon
	installed_gun = /obj/item/gun/energy/lasercannon/mounted


///////////////////////////////////////////////////
// Ammo Box Variants
///////////////////////////////////////////////////

/obj/item/stock_parts/ammo_box/large
	max_ammo = 200

///////////////////////////////////////////////////
// Ammo Box Presets
///////////////////////////////////////////////////

/decl/stock_part_preset/ammo_box
	expected_part_type = /obj/item/stock_parts/ammo_box
	var/fill_with = /obj/item/ammo_casing/pistol

/decl/stock_part_preset/ammo_box/do_apply(obj/machinery/machine, obj/item/stock_parts/ammo_box/part)
	var/obj/item/ammo_casing/C = atom_info_repository.get_instance_of(fill_with)
	part.stored_caliber = C.caliber

	//#FIXME: This thing is so stupid. Let's go and create 50 objects to represent bullets that only do anything for a fraction of a second in their long lives :,D
	for(var/ammo_cnt = 1 to part.max_ammo)
		part.stored_ammo += new fill_with(part)

/decl/stock_part_preset/ammo_box/filled_rifle
	fill_with = /obj/item/ammo_casing/rifle

/decl/stock_part_preset/ammo_box/filled_beanbags
	fill_with = /obj/item/ammo_casing/shotgun/beanbag

///////////////////////////////////////////////////
// Ballistic Turrets Templates
///////////////////////////////////////////////////

///Assault Rifle Turret
/obj/machinery/turret/network/outreach/ballistic
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/capacitor/super = 1,
		/obj/item/stock_parts/scanning_module/phasic = 1,
		/obj/item/stock_parts/manipulator/pico = 2,
		/obj/item/stock_parts/ammo_box = 1,
	)
	installed_gun      = /obj/item/gun/projectile/automatic/assault_rifle
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_connect,
		/decl/stock_part_preset/network_lock/outreach/command,
		/decl/stock_part_preset/ammo_box/filled_rifle
	)

///Light Machine Gun turret
/obj/machinery/turret/network/outreach/ballistic/lmg
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/capacitor/super = 1,
		/obj/item/stock_parts/scanning_module/phasic = 1,
		/obj/item/stock_parts/manipulator/pico = 2,
		/obj/item/stock_parts/ammo_box/large = 1,
	)
	installed_gun      = /obj/item/gun/projectile/automatic/lmg/mounted
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_connect,
		/decl/stock_part_preset/network_lock/outreach/command,
		/decl/stock_part_preset/ammo_box/filled_rifle
	)

///Shotgun beanbag turret
/obj/machinery/turret/network/outreach/ballistic/shotgun/beanbag
	installed_gun = /obj/item/gun/projectile/shotgun/magshot/mounted
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_connect,
		/decl/stock_part_preset/network_lock/outreach/command,
		/decl/stock_part_preset/ammo_box/filled_beanbags
	)
