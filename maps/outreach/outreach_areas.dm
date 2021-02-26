/area/exoplanet/outreach
	name = "Outreach"

/area/outreach/outpost
	//safe_zone = TRUE

/area/outreach/outpost/maint
	name = "\improper Maintenance"
	icon_state = "maintcentral"

/area/outreach/outpost/sleeproom
	name = "Cyrogenic Storage"
	icon_state = "cryo"

/area/outreach/outpost/hallway
	name = "\improper Hallways"
	icon_state = "hallC1"

/area/outreach/outpost/judges
	name = "judges room"
	icon_state = "law"

/area/outreach/outpost/computer
	name = "computer room"
	icon_state = "green"

/area/outreach/outpost/barracks
	name = "\improper Barracks"

/area/outreach/outpost/barracks/first
	name = "\improper First Barracks"
	icon_state = "southeast"

/area/outreach/outpost/barracks/second
	name = "\improper Second Barracks"
	icon_state = "southwest"

/area/outreach/outpost/barracks/third
	name = "\improper Third Barracks"
	icon_state = "northeast"

/area/outreach/outpost/barracks/fourth
	name = "\improper Fourth Barracks"
	icon_state = "northwest"

/area/outreach/outpost/it
	name = "\improper Server Room"
	icon_state = "server"

/area/outreach/outpost/solar_array
	name = "\improper Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/outreach/outpost/atmospherics
	icon_state = "atmos"
	name = "\improper Atmospherics"

/area/exoplanet/outreach/mines
	name = "Deep Underground"
	icon_state = "unknown"
	var/do_autogenerate = FALSE

/area/exoplanet/outreach/mines/depth_1
	do_autogenerate = TRUE
	icon_state = "cave"

/area/exoplanet/outreach/mines/depth_2
	do_autogenerate = TRUE
	icon_state = "cave"

/area/exoplanet/outreach/mines/exits
	icon_state = "exit"