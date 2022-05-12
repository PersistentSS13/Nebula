//Add to the default areas
/datum/map/kleibkhar/New()
	. = ..()
	area_coherency_test_exempt_areas += /area/kleibkhar/atmos_pump
	area_coherency_test_exempt_areas += /area/kleibkhar/outpost/cargo/warehouse
	apc_test_exempt_areas[/area/kleibkhar/atmos_pump] = NO_SCRUBBER|NO_APC //Area meant to fool unit tests, because they're being a bit assinine