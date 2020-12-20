/obj/item/memory
	name = "memory drive"
	desc = "A device  used to save data"
	icon = 'icons/obj/card_mem.dmi'
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_POCKET
	var/max_capacity = 3600
	var/used_capacity = 0
	var/list/storedinfo = new/list()
	var/list/timestamp = new/list()
	var/ruined = 0
	var/obj/item/photo/p
	var/list/can_hold = new/list()
	var/list/metadata

/obj/item/memory/proc/record_speech(text)
	timestamp += used_capacity
	storedinfo += "\[[stationtime2text()]\] [text]"

/obj/item/memory/proc/record_noise(text)
	timestamp += used_capacity
	storedinfo += "*\[[stationtime2text()]\] [text]"


/obj/item/memory/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	ruin()

/obj/item/memory/proc/ruin()
	ruined = 1

/obj/item/memory/Initialize()
	. = ..()

/obj/item/memory/proc/printpicture(mob/user, obj/item/photo/p)
	if(!user.put_in_inactive_hand(p))
		for(p in src)
			p.dropInto(user.loc)

/obj/item/memory/proc/savepicture(obj/item/photo/p)
	if(!src)
		return
	p.forceMove(src)
	can_hold += p

