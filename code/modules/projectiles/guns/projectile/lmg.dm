/obj/item/gun/projectile/automatic/lmg
	name               = "light machine gun"
	desc               = "An unbranded machine gun, based off a design made long ago."
	icon               = 'icons/obj/guns/lmg.dmi'
	w_class            = ITEM_SIZE_HUGE
	bulk               = GUN_BULK_RIFLE + 5
	force              = 10
	slot_flags         = 0
	max_shells         = 50
	caliber            = CALIBER_RIFLE
	origin_tech        = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ESOTERIC = 2)
	slot_flags         = 0 //need sprites for SLOT_BACK
	ammo_type          = /obj/item/ammo_casing/rifle
	load_method        = MAGAZINE
	magazine_type      = /obj/item/ammo_magazine/box/machinegun
	allowed_magazines  = list(/obj/item/ammo_magazine/box/machinegun, /obj/item/ammo_magazine/rifle)
	one_hand_penalty   = 10
	mag_insert_sound   = 'sound/weapons/guns/interaction/lmg_magin.ogg'
	mag_remove_sound   = 'sound/weapons/guns/interaction/lmg_magout.ogg'
	//can_special_reload = FALSE

	//LMG, better sustained fire accuracy than assault rifles (comparable to SMG), higer move delay and one-handing penalty
	//No single-shot or 3-round-burst modes since using this weapon should come at a cost to flexibility.
	firemodes = list(
		list(mode_name="short bursts",	can_autofire=0, burst=5, fire_delay=5, move_delay=12, one_hand_penalty=8, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	can_autofire=0, burst=8, fire_delay=5, one_hand_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=1, one_hand_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

	var/cover_open = FALSE

/obj/item/gun/projectile/automatic/lmg/mag
	magazine_type = /obj/item/ammo_magazine/rifle

/obj/item/gun/projectile/automatic/lmg/empty
	starts_loaded = FALSE

/obj/item/gun/projectile/automatic/lmg/mounted
	one_hand_penalty   = 18
	bulk               = GUN_BULK_RIFLE + 10
	max_shells         = 200
	has_safety         = FALSE

/obj/item/gun/projectile/automatic/lmg/special_check(mob/living/user)
	if(cover_open)
		to_chat(user, SPAN_WARNING("[src]'s cover is open! Close it before firing!"))
		return FALSE
	return ..()

/obj/item/gun/projectile/automatic/lmg/proc/toggle_cover(mob/living/user)
	cover_open = !cover_open
	to_chat(user, SPAN_NOTICE("You [cover_open ? "open" : "close"] [src]'s cover."))
	update_icon()
	user.update_inhand_overlays()

/obj/item/gun/projectile/automatic/lmg/attack_self(mob/living/user)
	if(cover_open)
		toggle_cover(user)
		return TRUE
	else
		return ..()

/obj/item/gun/projectile/automatic/lmg/attack_hand(mob/living/user)
	if(!cover_open && user.get_inactive_held_items() == src)
		toggle_cover(user)
		return TRUE
	else
		return ..()

/obj/item/gun/projectile/automatic/lmg/on_update_icon()
	..()
	var/base_state = "[get_world_inventory_state()]-[cover_open ? "open" : "closed"]"

	if(istype(ammo_magazine, /obj/item/ammo_magazine/box/machinegun))
		//Only the ammo belt magazine has a variable icon depending on ammo count
		icon_state = "[base_state]-[round(length(ammo_magazine.stored_ammo) / (ammo_magazine.max_ammo * 0.20), 20)]"
	else if(ammo_magazine)
		icon_state = "[base_state]-mag-under"
	else
		icon_state = "[base_state]-empty"

/obj/item/gun/projectile/automatic/lmg/get_mob_overlay_suffix()
	. = "[cover_open ? "open" : "closed"]"
	if(ammo_magazine && !istype(ammo_magazine, /obj/item/ammo_magazine/box/machinegun))
		. = "[.]-mag"
	else if(!ammo_magazine)
		return "[.]-empty"
	//In case we got the regular box loaded, no suffix needed

/obj/item/gun/projectile/automatic/lmg/load_ammo(obj/item/A, mob/living/user)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("You need to open the cover to load that into [src]."))
		return FALSE
	return ..()

/obj/item/gun/projectile/automatic/lmg/unload_ammo(mob/living/user, allow_dump = TRUE)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("You need to open the cover to unload [src]."))
		return FALSE
	return ..()