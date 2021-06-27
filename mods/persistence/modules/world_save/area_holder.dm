var/global/atom/movable/area_holder/area_holder

// A dummy object to hold areas to be saved, just in case an area ends up without a reference. 
/atom/movable/area_holder
	var/list/areas = list()
	invisibility = INVISIBILITY_ABSTRACT

/atom/movable/area_holder/Destroy()
	. = ..()
	areas.Cut()