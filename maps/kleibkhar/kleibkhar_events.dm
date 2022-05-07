/datum/event_container/mundane
	available_events = list(
		// Severity level, event name, event type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",						/datum/event/nothing,				1000),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "APC Damage",					/datum/event/apc_damage,			0.01, 	list(ASSIGNMENT_ENGINEER = 10),								TRUE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lost Carp",						/datum/event/carp_migration, 		0.02, 	list(ASSIGNMENT_SECURITY = 10),								TRUE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Shipping Error",				/datum/event/shipping_error	, 		0.2, 	list(ASSIGNMENT_ANY = 2), 									TRUE),
		new /datum/event_meta/no_overmap(EVENT_LEVEL_MUNDANE, "Space Dust",			/datum/event/dust,					5, 		list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Vermin Infestation",			/datum/event/infestation, 			0.5,	list(ASSIGNMENT_JANITOR = 100),								TRUE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Wallrot",						/datum/event/wallrot, 				0,		list(ASSIGNMENT_ENGINEER = 30, ASSIGNMENT_GARDENER = 50), 	TRUE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Toilet Clog",					/datum/event/toilet_clog,			0.3, 	list(ASSIGNMENT_JANITOR = 20)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Random Ailments",				/datum/event/ailments,				0.2, 	list(ASSIGNMENT_ANY = 1)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Disposals Explosion",			/datum/event/disposals_explosion,	0.2,	list(ASSIGNMENT_ENGINEER = 40),								TRUE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mail Delivery",					/datum/event/mail,					0.2,	list(ASSIGNMENT_ANY = 1), 									TRUE),
		new /datum/event_meta/no_overmap(EVENT_LEVEL_MUNDANE, "Electrical Storm",	/datum/event/electrical_storm, 		0.1,	list(ASSIGNMENT_ENGINEER = 20, ASSIGNMENT_JANITOR = 100),	TRUE),
	)

/datum/event_container/moderate
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",								/datum/event/nothing,					1230),
		new /datum/event_meta/no_overmap(EVENT_LEVEL_MODERATE, "Carp School",				/datum/event/carp_migration,			0.05,	list(ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_SECURITY = 20), 													TRUE),
		new /datum/event_meta/no_overmap(EVENT_LEVEL_MODERATE, "Ion Storm",					/datum/event/ionstorm, 					0,		list(ASSIGNMENT_COMPUTER = 50, ASSIGNMENT_ROBOT = 50, ASSIGNMENT_ENGINEER = 15, ASSIGNMENT_SCIENTIST = 5),	TRUE),
		new /datum/event_meta/no_overmap(EVENT_LEVEL_MODERATE, "Meteor Shower",				/datum/event/meteor_wave,				0,		list(ASSIGNMENT_ENGINEER = 20),																				TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Solar Storm",							/datum/event/solar_storm, 				0.01,	list(ASSIGNMENT_ENGINEER = 20, ASSIGNMENT_SECURITY = 10), 													TRUE),
		new /datum/event_meta/no_overmap(EVENT_LEVEL_MODERATE, "Space Dust",				/datum/event/dust, 						10, 	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Spider Infestation",					/datum/event/spider_infestation, 		0.05,	list(ASSIGNMENT_SECURITY = 15), 																			TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Toilet Flooding",						/datum/event/toilet_clog/flood,			0.08, 	list(ASSIGNMENT_JANITOR = 20),																				TRUE),
	)

/datum/event_container/major
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Nothing",							/datum/event/nothing,				1320),
		new /datum/event_meta/no_overmap(EVENT_LEVEL_MAJOR, "Carp Migration",		/datum/event/carp_migration,		0,	list(ASSIGNMENT_SECURITY =  5), 						TRUE),
		new /datum/event_meta/no_overmap(EVENT_LEVEL_MAJOR, "Meteor Wave",			/datum/event/meteor_wave,			0,	list(ASSIGNMENT_ENGINEER = 10),							TRUE),
		new /datum/event_meta/no_overmap(EVENT_LEVEL_MAJOR, "Electrical Storm",		/datum/event/electrical_storm, 		0,	list(ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_JANITOR = 5), TRUE),
	)
