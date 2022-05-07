// Multi-z planets create inconsistencies in when planets exist for the owner of exterior turfs to be set. If an owner can't be found,
// we ask turfs to check again later.
/turf/exterior/Initialize(mapload, no_update_icon)
	. = ..()
	if(!owner)
		return INITIALIZE_HINT_LATELOAD

/turf/exterior/LateInitialize()
	. = ..()
	if(!owner)
		owner = LAZYACCESS(global.overmap_sectors, "[z]")
		if(!istype(owner))
			owner = null
