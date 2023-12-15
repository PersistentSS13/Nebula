/datum/planetoid_data/outreach
	initial_weather_state = /decl/state/weather/calm/outreach

/decl/state/weather/calm/outreach
	transitions = list(
		/decl/state_transition/weather/salt_flurry,
		/decl/state_transition/weather/rain/outreach,
	)

/decl/state/weather/rain/outreach
	name                = "Light acidic rain"
	icon_state          = "rain"
	descriptor          = "It is drizzling hydrochloric acid."
	cosmetic_span_class = "notice"
	is_liquid           = TRUE
	cosmetic_messages   = list("Acidic raindrops patter against you.")
	protected_messages  = list("Acidic raindrops patter against $ITEM$.")
	minimum_time        = 2 MINUTES
	maximum_time        = 10 MINUTES
	transitions         = list(
		/decl/state_transition/weather/calm/outreach,
		/decl/state_transition/weather/storm/outreach,
	)
/decl/state/weather/rain/outreach/handle_exposure_effects(mob/living/M, obj/abstract/weather_system/weather)
	if(prob(15))
		to_chat(M, SPAN_DANGER("You were splashed by acid droplets!"))
		var/datum/reagents/R = new(5, global.temp_reagents_holder)
		R.splash(M, rand(1, R.total_volume), min_spill = 0, max_spill = 0)

/decl/state/weather/rain/storm/outreach
	name                = "Heavy acid rain"
	icon_state          = "storm"
	descriptor          = "It is pouring acid rain."
	is_liquid           = TRUE
	cosmetic_span_class = "warning"
	cosmetic_messages   = list("Torrential acid thunders down around you.")
	protected_messages  = list("Torrential acid thunders down as you shelter beneath $ITEM$.")
	roof_messages       = list("Torrential acid rain thunders against the roof.")
	ambient_sounds      = list('sound/effects/weather/rain_heavy.ogg')
	minimum_time        = 1 MINUTES
	maximum_time        = 3 MINUTES
	transitions         = list(
		/decl/state_transition/weather/rain/outreach,
	)

/decl/state/weather/rain/storm/outreach/handle_exposure_effects(mob/living/M, obj/abstract/weather_system/weather)
	if(prob(80))
		to_chat(M, SPAN_DANGER("You were doused with acid rain!"))
		var/datum/reagents/R = new(10, global.temp_reagents_holder)
		R.splash(M, rand(1, R.total_volume), min_spill = 0, max_spill = 0)

/decl/state/weather/salt_flurry
	name       = "Salt flurry"
	icon_state = "snowfall_light"
	descriptor = "The wind is blowing chlorine salts everywhere."
	transitions = list(
		/decl/state_transition/weather/calm/outreach,
		/decl/state_transition/weather/rain/outreach,
	)
	ambient_sounds =     list('sound/effects/weather/snow.ogg')
	protected_messages = list("Salt collect atop $ITEM$.")
	cosmetic_messages =  list(
		"Salt flakes fall around you.",
		"Flakes of salt drift past."
	)
	minimum_time = 5 MINUTES
	maximum_time = 10 MINUTES

/decl/state_transition/weather/calm/outreach
	target = /decl/state/weather/calm/outreach
	likelihood_weighting = 50

/decl/state_transition/weather/salt_flurry
	target = /decl/state/weather/salt_flurry
	likelihood_weighting = 20

/decl/state_transition/weather/rain/outreach
	target = /decl/state/weather/rain/outreach
	likelihood_weighting = 10

/decl/state_transition/weather/storm/outreach
	target = /decl/state/weather/rain/storm/outreach
	likelihood_weighting = 5
