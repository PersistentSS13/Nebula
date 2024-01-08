/datum/map/outreach
	name            = "Outreach"
	full_name       = "Outreach Outpost"
	path            = "outreach"
	station_name    = "Harlech Colony"          //Placeholder meme name for testing what uses this
	station_short   = "Harlech"
	boss_name       = "Interstellar Inc"        //Just some random company name so we don't get CAPTAIN RODGER ANNOUNCED SPACE CARPS LOL
	boss_short      = "Interstellar"
	company_name    = "Outreach Cooperative"   //Just name to refer to the collective outreach workforce and get rid of the filler default
	company_short   = "Outreach"
	system_name     = "Outreach System"
	dock_name       = "Outreach Docks"

	allowed_latejoin_spawns = list(/decl/spawnpoint/cryo)
	default_spawn = /decl/spawnpoint/cryo
	starting_money   = 5000
	department_money = 0
	salary_modifier  = 0.2

	lobby_screens = list(
		'maps/outreach/lobby/exoplanet.png'
	)
	num_exoplanets = 0
	overmap_ids = list(OVERMAP_ID_SPACE = /datum/overmap) //Default to null overmap, which prevents overmap marker from initializing properly
	welcome_sound = 'sound/music/stingers/stinger_scifi.ogg'

/datum/map/outreach/get_map_info()
	return "You are en route to Outreach, a desolate planet previously targeted for mining operations, but now largely abandoned. Colonists come from a wide variety of backgrounds, but universally with only the shirt on their backs."
