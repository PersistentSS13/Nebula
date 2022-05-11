/datum/map/kleibkhar
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/kleibkhar/atmos_pump = NO_VENT|NO_APC, //Area meant to fool unit tests, because they're being a bit assinine
	)
	area_coherency_test_exempt_areas = list(
		/area/kleibkhar/atmos_pump,
	)