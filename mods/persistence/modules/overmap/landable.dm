/obj/effect/overmap/visitable/ship/landable/Initialize(var/mapload, var/custom_name)
	if(custom_name)
		shuttle = custom_name
		name = custom_name
	. = ..(mapload)
	