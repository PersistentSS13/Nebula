///////////////////////////////////////////////////////////////////////////////////
// Simulated flooded underground chlorine pool
///////////////////////////////////////////////////////////////////////////////////
/turf/exterior/barren/subterrane/outreach/acid
	color          = "#d2e0b7"
	open_turf_type = /turf/exterior/barren/subterrane/outreach
	prev_type      = /turf/exterior/barren/subterrane/outreach

/turf/exterior/barren/subterrane/outreach/acid/Initialize(ml, floortype)
	. = ..()
	make_flooded(TRUE)
	add_fluid(/decl/material/liquid/acid/hydrochloric, FLUID_MAX_DEPTH)
