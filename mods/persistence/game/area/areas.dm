// We perform this in New() as areas must be able to be referenced by type and name during load.
/area/New(loc, _name)
	if(_name)
		name = _name

	. = ..()
	global.area_dictionary[AREA_KEY(src)] = src

/area/Destroy()
	global.area_dictionary -= AREA_KEY(src)
	. = ..()