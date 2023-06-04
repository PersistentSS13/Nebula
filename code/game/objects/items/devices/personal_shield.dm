/obj/item/personal_shield
	name = "personal shield"
	desc = "Truely a life-saver: this device protects its user from being hit by objects moving very, very fast, though only for a few shots."
	icon = 'icons/obj/items/weapon/batterer.dmi'
	icon_state = "world"
	slot_flags = SLOT_LOWER_BODY
	var/uses = 5
	var/obj/aura/personal_shield/device/shield

/obj/item/personal_shield/attack_self(var/mob/user)
	if(uses && !shield)
		shield = new(user,src)

/obj/item/personal_shield/proc/take_charge()
	if(!--uses)
		QDEL_NULL(shield)
		to_chat(loc,"<span class='danger'>\The [src] begins to spark as it breaks!</span>")
		update_icon()
		return

/obj/item/personal_shield/on_update_icon()
	if(uses)
		icon_state = "world"
	else
		icon_state = "world-on"

/obj/item/personal_shield/Destroy()
	QDEL_NULL(shield)
	return ..()

/obj/item/advpersonal_shield
	name = "advanced personal shield"
	desc = "Truely a life-saver: this device protects its user from being hit by objects moving very, very fast, Can withstand a lot of shots."
	icon = 'icons/obj/items/weapon/batterer.dmi'
	icon_state = "advshield"
	slot_flags = SLOT_LOWER_BODY
	var/uses = 25
	var/obj/aura/personal_shield/device/shield

/obj/item/advpersonal_shield/attack_self(var/mob/user)
	if(uses && !shield)
		shield = new(user,src)

/obj/item/advpersonal_shield/proc/take_charge()
	if(!--uses)
		QDEL_NULL(shield)
		to_chat(loc,"<span class='danger'>\The [src] begins to spark as it breaks!</span>")
		update_icon()
		return

/obj/item/advpersonal_shield/on_update_icon()
	if(uses)
		icon_state = "advshield"
	else
		icon_state = "advshield-on"

/obj/item/advpersonal_shield/Destroy()
	QDEL_NULL(shield)
	return ..()