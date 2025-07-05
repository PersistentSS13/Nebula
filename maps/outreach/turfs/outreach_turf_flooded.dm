///////////////////////////////////////////////////////////////////////////////////
// Simulated flooded underground chlorine pool
///////////////////////////////////////////////////////////////////////////////////
/turf/exterior/barren/subterrane/outreach/acid
	color          = "#d2e0b7"
	open_turf_type = /turf/exterior/barren/subterrane/outreach
	prev_type      = /turf/exterior/barren/subterrane/outreach

/turf/exterior/barren/subterrane/outreach/acid/Initialize(ml, floortype)
	. = ..()
	set_flooded(/decl/material/liquid/acid/hydrochloric)
