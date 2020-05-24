/mob/observer/eye/stellar_anchor
	name = "Stellar Anchor Eye"
	desc = "A visual projection used to assist in the anchoring and unanchoring of areas."
	name_sufix = "Stellar Anchor Eye"
	
	var/list/area_images = list()

/mob/observer/eye/stellar_anchor/proc/update_images(var/obj/machinery/network/stellar_anchor/anchor)
	if(!istype(anchor))
		return
	if(owner && owner.client)
		owner.client.images -= area_images
		area_images.Cut()
		for(var/area/A in anchor.anchored_areas)
			var/image/I = image('icons/effects/alphacolors.dmi', A, "blue")
			I.plane = OBSERVER_PLANE
			area_images += I
		owner.client.images += area_images

/mob/observer/eye/stellar_anchor/possess(var/mob/user)
	. = ..()
	if(owner && owner.client)
		owner.client.images += area_images

/mob/observer/eye/stellar_anchor/release(var/mob/user)
	if(owner && owner.client && owner == user)
		owner.client.images.Cut()
	. = ..()

/mob/observer/eye/stellar_anchor/additional_sight_flags()
	return SEE_TURFS|BLIND