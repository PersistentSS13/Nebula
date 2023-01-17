// Override to prevent repopulating closets or absorbing items on their tile.
/obj/structure/closet/LateInitialize()
	if(persistent_id)
		return
	. = ..()