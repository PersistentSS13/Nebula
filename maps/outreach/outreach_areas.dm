#define OUTREACH_AREA_NAME_SERVER_ROOM  "OB 1B Servers Room"
#define OUTREACH_AREA_NAME_CRYO         "OB 1B Cyrogenic Storage"
#define OUTREACH_AREA_NAME_CONTROL_ROOM "OB 1B Control Room"
#define OUTREACH_AREA_NAME_POWER_ROOM   "OB 2B Power Storage"
#define OUTREACH_AREA_NAME_GEOTHERMALS  "OB 2B Geothermals"
#define OUTREACH_AREA_NAME_GAS_TANKS    "OB 2B Atmos Tanks Perimeter"
#define OUTREACH_AREA_NAME_ATMOS        "OB 1B Atmospherics Hall"

///This list is used to initialize the area protection for the outpost
var/global/list/outreach_initial_protected_areas = list(
	OUTREACH_AREA_NAME_SERVER_ROOM,
	OUTREACH_AREA_NAME_CRYO,
	OUTREACH_AREA_NAME_CONTROL_ROOM,
	OUTREACH_AREA_NAME_POWER_ROOM,
	OUTREACH_AREA_NAME_GEOTHERMALS,
	OUTREACH_AREA_NAME_GAS_TANKS,
	OUTREACH_AREA_NAME_ATMOS,
)

///////////////////////////////////////////////////
//Planet
///////////////////////////////////////////////////
/area/exoplanet/outreach
	name             = "Outreach Surface"
	icon             = 'icons/turf/areas.dmi'
	icon_state       = "black"
	alpha            = 128
	base_turf        = OUTREACH_SURFACE_TURF
	open_turf        = OUTREACH_SURFACE_TURF //Prevent people from creating free holes everywhere
	turf_initializer = /decl/turf_initializer/outreach_surface
	sound_env        = QUARRY
	ambience         = null
	forced_ambience  = list(
		'sound/effects/wind/desert0.ogg',
		'sound/effects/wind/desert1.ogg',
		'sound/effects/wind/desert2.ogg',
		'sound/effects/wind/desert3.ogg',
		'sound/effects/wind/desert4.ogg',
		'sound/effects/wind/desert5.ogg',
	)

/area/exoplanet/outreach/sky
	name       = "Outreach Sky"
	icon_state = "blueold"
	alpha      = 128
	base_turf  = /turf/exterior/open
	open_turf  = /turf/exterior/open
	sound_env  = PLAIN
	ambience   = null
	forced_ambience  = list(
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
		'sound/effects/wind/wind_4_1.ogg',
		'sound/effects/wind/wind_4_2.ogg',
		'sound/effects/wind/wind_5_1.ogg',
	)

/area/exoplanet/outreach/underground
	name            = "Outreach Underground"
	area_flags      = AREA_FLAG_IS_BACKGROUND | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	is_outside      = OUTSIDE_NO
	sound_env       = CAVE
	abstract_type   = /area/exoplanet/outreach/underground
	forced_ambience = null
	ambience        = list(
		'sound/ambience/spookyspace1.ogg',
		'sound/ambience/spookyspace2.ogg'
	)

/area/exoplanet/outreach/underground/d1
	name = "Outreach Sedimentary Layer"
	icon_state = "dk_yellow"

/area/exoplanet/outreach/underground/d2
	name = "Outreach Substrate Layer"
	icon_state = "purple"

///////////////////////////////////////////////////
//Mines
///////////////////////////////////////////////////
/area/exoplanet/outreach/underground/mines
	name                = "Outreach Mines"
	icon_state          = "cave"
	area_flags          = AREA_FLAG_IS_BACKGROUND | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	ignore_mining_regen = FALSE
	ambience            = list(
		'sound/ambience/ominous1.ogg',
		'sound/ambience/ominous2.ogg',
		'sound/ambience/ominous3.ogg'
	)

/area/exoplanet/outreach/underground/mines/b2
	name = "Outreach Abyss"
/area/exoplanet/outreach/underground/mines/b1
	name = "Outreach Subterrane"
/area/exoplanet/outreach/underground/mines/gf
	name = "Outreach Excavation"

/area/exoplanet/outreach/mine_entrance
	name                = "Outreach Topside Mines Access"
	icon_state          = "exit"
	ignore_mining_regen = TRUE
	is_outside          = OUTSIDE_NO
	sound_env           = QUARRY
	forced_ambience     = null

/area/exoplanet/outreach/underground/mines/stairwell
	name                = "Outreach Mines Stairwell"
	icon_state          = "exit"
	ignore_mining_regen = TRUE
	sound_env           = CAVE

/area/exoplanet/outreach/underground/mines/stairwell/gf
	name = "Outreach GF Mines Stairwell"
/area/exoplanet/outreach/underground/mines/stairwell/b1
	name = "Outreach 1B Mines Stairwell"
/area/exoplanet/outreach/underground/mines/stairwell/b2
	name = "Outreach 2B Mines Stairwell"

/area/exoplanet/outreach/underground/mines/access
	name                = "Outreach Mines Access"
	icon_state          = "exit"
	ignore_mining_regen = TRUE
	sound_env           = CAVE

/area/exoplanet/outreach/underground/mines/access/b1
	name = "Outreach Subterrane Mine Access"
/area/exoplanet/outreach/underground/mines/access/b2
	name = "Outreach Abyss Mine Access"

///////////////////////////////////////////////////
//Outpost
///////////////////////////////////////////////////

///Base area for anything man-made that's open to the surface.
/area/outreach
	name          = "DONT USE ME"
	icon_state    = "toilet"
	area_flags    = AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED
	base_turf     = OUTREACH_SURFACE_TURF
	open_turf     = /turf/exterior/open
	abstract_type = /area/outreach

///Base area for anything that's not exposed to the outside and part of the outreach outpost.
/area/outreach/outpost
	name      = "Outpost"
	open_turf = /turf/simulated/open
	base_turf = OUTREACH_SURFACE_TURF
	///turf/simulated/floor/asteroid //Underground floors use this, and all floors above will use the open_turf instead

///////////////////////////////////////////////////
//Cryo
///////////////////////////////////////////////////
/area/outreach/outpost/sleeproom
	name            = OUTREACH_AREA_NAME_CRYO
	icon_state      = "cryo"
	secure          = FALSE
	sound_env       = ROOM

///////////////////////////////////////////////////
//Controls
///////////////////////////////////////////////////
/area/outreach/outpost/control
	name       = OUTREACH_AREA_NAME_CONTROL_ROOM
	icon_state = "server"
	sound_env  = ROOM
	secure     = TRUE
	req_access = list(list(access_engine),list(access_heads))
	ambience   = list(
		'sound/ambience/ambigen3.ogg',
		'sound/ambience/ambigen4.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/sonar.ogg',
	)
/area/outreach/outpost/control/hall
	name       = "OB 1B Servers Entrance"
	icon_state = "server"
/area/outreach/outpost/control/servers
	name       = OUTREACH_AREA_NAME_SERVER_ROOM
	icon_state = "server"
/area/outreach/outpost/control/storage
	name            = "OB 1B Servers Storage Room"
	icon_state      = "server"
	req_access      = list(list(access_engine))
/area/outreach/outpost/control/cooling
	name            = "OB 1B Cooling Systems Room"
	icon_state      = "server"
	req_access      = list(list(access_engine))
	forced_ambience = list('sound/ambience/ambiatm1.ogg')

/area/outreach/outpost/control/command_hall
	name       = "OB 1B Command Hall"
	icon_state = "bridge_hallway"
	req_access = list(list(access_bridge),list(access_security))

/area/outreach/outpost/control/command_conference
	name       = "OB 1B Conference Hall"
	icon_state = "bridge_meeting"
	req_access = list(list(access_bridge),list(access_security))

/area/outreach/outpost/control/command_office
	name       = "OB 1B Command Office"
	icon_state = "law"
	req_access = list(list(access_bridge))

/area/outreach/outpost/control/command_room
	name       = "OB 1B Command Room"
	icon_state = "law"
	req_access = list(list(access_bridge))

///////////////////////////////////////////////////
//Chemistry Lab
///////////////////////////////////////////////////
/area/outreach/outpost/lab
	name       = "OB 1B Chemistry Lab"
	icon_state = "chem"
	sound_env  = ROOM
/area/outreach/outpost/lab/entrance
	name       = "OB 1B Chemistry Lab Entrance"
	icon_state = "labwing"
	sound_env  = STONEROOM
/area/outreach/outpost/lab/storage
	name       = "OB 1B Chemistry Storage"
	icon_state = "auxstorage"
	sound_env  = ROOM

///////////////////////////////////////////////////
//Medbay
///////////////////////////////////////////////////
/area/outreach/outpost/medbay
	name       = "OB 1B Medbay"
	icon_state = "medbay"

/area/outreach/outpost/medbay/storage
	name       = "OB 1B Medbay Storage"
	icon_state = "medbay3"
/area/outreach/outpost/medbay/storage/equipment
	name = "OB 1B Medbay Equipment Storage"
/area/outreach/outpost/medbay/storage/medical
	name = "OB 1B Medbay Medical Storage"

/area/outreach/outpost/medbay/lobby
	name       = "OB 1B Medbay Lobby"
	icon_state = "medbay2"
	sound_env  = AUDITORIUM

/area/outreach/outpost/medbay/main_hall
	name       = "OB 1B Medbay Hall"
	icon_state = "exam_room"
	sound_env  = AUDITORIUM

/area/outreach/outpost/medbay/triage
	name       = "OB 1B Medbay Triage"
	icon_state = "patients"
	sound_env  = ROOM

/area/outreach/outpost/medbay/op_room
	name = "OB 1B Medbay Surgery Room"
	icon_state = "surgery"
	sound_env  = ROOM

/area/outreach/outpost/medbay/morgue
	name       = "OB 1B Medbay Morgue"
	icon_state = "morgue"
	sound_env  = SMALL_ENCLOSED

///////////////////////////////////////////////////
//Hallways
///////////////////////////////////////////////////
/area/outreach/outpost/hallway
	area_flags = AREA_FLAG_HALLWAY
	sound_env  = HALLWAY

//South == Aft
/area/outreach/outpost/hallway/south
	icon_state = "hallA"
/area/outreach/outpost/hallway/south/basement2
	name = "OH 2B South Hallway"
/area/outreach/outpost/hallway/south/basement1
	name = "OH 1B South Hallway"
/area/outreach/outpost/hallway/south/ground
	name = "OH GF South Hallway"
/area/outreach/outpost/hallway/south/floor1
	name = "OH 1F South Hallway"

//North == Fore
/area/outreach/outpost/hallway/north
	icon_state = "hallF2"
/area/outreach/outpost/hallway/north/basement2
	name = "OH 2B North Hallway"
/area/outreach/outpost/hallway/north/basement1
	name = "OH 1B North Hallway"
/area/outreach/outpost/hallway/north/ground
	name = "OH GF North Hallway"
/area/outreach/outpost/hallway/north/floor1
	name = "OH 1F North Hallway"

//East == Starboard
/area/outreach/outpost/hallway/east
	icon_state = "hallS"
/area/outreach/outpost/hallway/east/basement2
	name = "OH 2B East Hallway"
/area/outreach/outpost/hallway/east/basement1
	name = "OH 1B East Hallway"
/area/outreach/outpost/hallway/east/ground
	name = "OH GF East Hallway"
/area/outreach/outpost/hallway/east/floor1
	name = "OH 1F East Hallway"

//West == Port
/area/outreach/outpost/hallway/west
	icon_state = "hallP"
/area/outreach/outpost/hallway/west/basement2
	name = "OH 2B West Hallway"
/area/outreach/outpost/hallway/west/basement1
	name = "OH 1B West Hallway"
/area/outreach/outpost/hallway/west/ground
	name = "OH GF West Hallway"
/area/outreach/outpost/hallway/west/floor1
	name = "OH 1F West Hallway"

//Central
/area/outreach/outpost/hallway/central
	icon_state = "hallC1"
/area/outreach/outpost/hallway/central/basement2
	name = "OH 2B Central Hallway"
/area/outreach/outpost/hallway/central/basement1
	name = "OH 1B Central Hallway"
/area/outreach/outpost/hallway/central/ground
	name = "OH GF Central Hallway"
/area/outreach/outpost/hallway/central/floor1
	name = "OH 1F Central Hallway"

/area/outreach/outpost/hallway/south/ground/business_wing
	name = "OH GF Business Hallway"

///////////////////////////////////////////////////
//Stairwell
///////////////////////////////////////////////////
/area/outreach/outpost/stairwell
	name       = "OH Stairwell"
	icon_state = "purple"
	sound_env  = CONCERT_HALL
	area_flags = AREA_FLAG_HALLWAY

/area/outreach/outpost/stairwell/basement2
	name = "OH 2B Stairwell"
/area/outreach/outpost/stairwell/basement1
	name = "OH 1B Stairwell"
/area/outreach/outpost/stairwell/ground
	name = "OH GF Stairwell"
/area/outreach/outpost/stairwell/floor1
	name = "OH 1F Stairwell"

///////////////////////////////////////////////////
//Maintenance
///////////////////////////////////////////////////
/area/outreach/outpost/maint
	name       = "OB 1B Maintenance"
	icon_state = "maintcentral"
	sound_env  = TUNNEL_ENCLOSED
	area_flags = AREA_FLAG_MAINTENANCE

/area/outreach/outpost/maint/passage
	name = "OB 1B Maintenance"
	icon_state = "maintcentral"

/area/outreach/outpost/maint/passage/b2/northwest
	name = "OB 2B NW Maint"
	icon_state = "fpmaint"
/area/outreach/outpost/maint/passage/b2/northeast
	name = "OB 2B NE Maint"
	icon_state = "fsmaint"
/area/outreach/outpost/maint/passage/b2/southwest
	name = "OB 2B SW Maint"
	icon_state = "apmaint"
/area/outreach/outpost/maint/passage/b2/southeast
	name = "OB 2B SE Maint"
	icon_state = "asmaint"

/area/outreach/outpost/maint/passage/b1/northwest
	name = "OB 1B NW Maint"
	icon_state = "fpmaint"
/area/outreach/outpost/maint/passage/b1/northwest/airlock
	name = "OB 1B NE Alck Maint"
	icon_state = "fpmaint"
/area/outreach/outpost/maint/passage/b1/northeast
	name = "OB 1B NE Maint"
	icon_state = "fsmaint"
/area/outreach/outpost/maint/passage/b1/northeast/airlock
	name = "OB 1B NE Alck Maint"
	icon_state = "fsmaint"
/area/outreach/outpost/maint/passage/b1/southwest
	name = "OB 1B SW Maint"
	icon_state = "apmaint"
/area/outreach/outpost/maint/passage/b1/southwest/airlock
	name = "OB 1B SW Alck Maint"
	icon_state = "apmaint"
/area/outreach/outpost/maint/passage/b1/southeast
	name = "OB 1B SE Maint"
	icon_state = "asmaint"
/area/outreach/outpost/maint/passage/b1/southeast/airlock
	name = "OB 1B SE Alck Maint"
	icon_state = "asmaint"
/area/outreach/outpost/maint/passage/b1/secmaint
	name = "OB 1B Sec Maint"
	icon_state = "maint_security_port"

/area/outreach/outpost/maint/passage/b1/east/junct
	name = "OB 1B E Maint Junction"
	icon_state = "smaint"
/area/outreach/outpost/maint/passage/b1/north/atmos
	name = "OB 1B Atmos Maint"
	icon_state = "maint_engineering"
/area/outreach/outpost/maint/passage/b1/north
	name = "OB 1B N Maint"
	icon_state = "fmaint"


/area/outreach/outpost/maint/passage/ground/northwest
	name = "OB GF NW Maint"
	icon_state = "fpmaint"

/area/outreach/outpost/maint/passage/ground/north
	name = "OB GF N Maint"
	icon_state = "fmaint"
/area/outreach/outpost/maint/passage/ground/north/hangar
	name = "OB GF N Hangar Maint"
/area/outreach/outpost/maint/passage/ground/west
	name = "OB GF W Maint"
	icon_state = "pmaint"
/area/outreach/outpost/maint/passage/ground/west/junct
	name = "OB GF W Maint Junction"
/area/outreach/outpost/maint/passage/ground/south
	name = "OB GF S Maint"
	icon_state = "amaint"
/area/outreach/outpost/maint/passage/ground/south/offices
	name = "OB GF S Offices Maint"
/area/outreach/outpost/maint/passage/ground/east
	name = "OB GF E Maint"
	icon_state = "smaint"
/area/outreach/outpost/maint/passage/ground/east/airlock
	name = "OB GF E Alck Maint"
/area/outreach/outpost/maint/passage/ground/east/eva
	name = "OB GF E Alck Maint"
	icon_state = "maint_eva"

/area/outreach/outpost/maint/passage/f1/northwest
	name = "OB 1F NW Maint"
	icon_state = "fpmaint"
/area/outreach/outpost/maint/passage/f1/northeast
	name = "OB 1F NE Maint"
	icon_state = "fsmaint"
/area/outreach/outpost/maint/passage/f1/southwest
	name = "OB 1F SW Maint"
	icon_state = "apmaint"
/area/outreach/outpost/maint/passage/f1/southeast
	name = "OB 1F SE Maint"
	icon_state = "asmaint"

/area/outreach/outpost/maint/storage
	name = "OB 1B Maintenance Storage"
	icon_state = "auxstorage"
/area/outreach/outpost/maint/storage/ground
	name = "OB GF Maintenance Storage"

/area/outreach/outpost/maint/power
	icon_state = "substation"
/area/outreach/outpost/maint/power/b2
	name = "OB 2B Maintenance Power Room"
/area/outreach/outpost/maint/power/b1
	name = "OB 1B Maintenance Power Room"
/area/outreach/outpost/maint/power/ground
	name = "OB GF Maintenance Power Room"
/area/outreach/outpost/maint/power/f1
	name = "OB 1F Maintenance Power Room"

/area/outreach/outpost/maint/atmos
	icon_state = "fsmaint"
/area/outreach/outpost/maint/atmos/b2
	name = "OB 2B Atmos Lines Maintenance"
/area/outreach/outpost/maint/atmos/b1
	name = "OB 1B Atmos Lines Maintenance"
/area/outreach/outpost/maint/atmos/ground
	name = "OB GF Atmos Lines Maintenance"
/area/outreach/outpost/maint/atmos/f1
	name = "OB 1F Atmos Lines Maintenance"

/area/outreach/outpost/maint/outer_wall
	icon_state = "maint_exterior"

/area/outreach/outpost/maint/outer_wall/ground
	name = "OB GF Maintenance Outer"
/area/outreach/outpost/maint/outer_wall/f1
	name = "OB 1F Maintenance Outer"

/area/outreach/outpost/maint/waste
	icon_state = "fpmaint"
/area/outreach/outpost/maint/waste/b2
	name = "OB 2B Waste Lines Maintenance"
/area/outreach/outpost/maint/waste/b1
	name = "OB 2B Waste Lines Maintenance"
/area/outreach/outpost/maint/waste/ground
	name = "OB GF Waste Lines Maintenance"
/area/outreach/outpost/maint/waste/f1
	name = "OB 1F Waste Lines Maintenance"

///////////////////////////////////////////////////
//Kitchen
///////////////////////////////////////////////////
/area/outreach/outpost/cafeteria
	name       = "OB 1B Cafeteria"
	icon_state = "cafeteria"
	sound_env  = AUDITORIUM
/area/outreach/outpost/cafeteria/common
	name       = "OB 1B Common Room"

/area/outreach/outpost/cafeteria/kitchen
	name       = "OB 1B Kitchen"
	icon_state = "kitchen"
	sound_env  = LIVINGROOM
/area/outreach/outpost/cafeteria/kitchen/backroom
	name       = "OB 1B Kitchen Storeroom"
	sound_env  = ROOM
/area/outreach/outpost/cafeteria/kitchen/freezer
	name       = "OB 1B Kitchen Freezer"
	sound_env  = SMALL_ENCLOSED

///////////////////////////////////////////////////
//Hydroponics
///////////////////////////////////////////////////
/area/outreach/outpost/hydroponics
	name       = "OB 1B Hydroponics"
	icon_state = "hydro"
	sound_env  = STANDARD_STATION

///////////////////////////////////////////////////
//Engineering
///////////////////////////////////////////////////
/area/outreach/outpost/engineering
	name       = "OB 1B Engineering"
	icon_state = "engineering"
	sound_env  = STANDARD_STATION

/area/outreach/outpost/engineering/b1/storage
	name       = "OB 1B Engineering Storage"
	icon_state = "engineering_storage"

/area/outreach/outpost/engineering/b2/smes
	name       = OUTREACH_AREA_NAME_POWER_ROOM
	icon_state = "engine_smes"

/area/outreach/outpost/engineering/b2/geothermals
	name            = OUTREACH_AREA_NAME_GEOTHERMALS
	icon_state      = "engine"
	secure          = TRUE
	req_access      = list(access_engine)
	sound_env       = STONEROOM
	ambience        = list(
		'sound/ambience/ambieng1.ogg',
		'sound/ambience/ambigen3.ogg',
		'sound/ambience/ambigen4.ogg',
		'sound/ambience/ambigen5.ogg',
		'sound/ambience/ambigen6.ogg',
		'sound/ambience/ambigen7.ogg',
		'sound/ambience/ambigen8.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambigen10.ogg',
		'sound/ambience/ambigen11.ogg',
	)

///////////////////////////////////////////////////
//Atmos
///////////////////////////////////////////////////
/area/outreach/outpost/atmospherics
	icon_state = "atmos"
	sound_env  = HANGAR
	req_access = list(access_atmospherics)

/area/outreach/outpost/atmospherics/b1/storage
	name       = "OB 1B Atmos Storage"
	icon_state = "atmos"
	sound_env  = STANDARD_STATION
/area/outreach/outpost/atmospherics/b1/storage/canister
	name       = "OB 1B Atmos Canister Storage"
	icon_state = "atmos"
	sound_env  = SMALL_ENCLOSED
/area/outreach/outpost/atmospherics/b1/hall
	name       = OUTREACH_AREA_NAME_ATMOS
	icon_state = "atmos"
	sound_env  = HALLWAY
	ambience   = null
	forced_ambience = list('sound/ambience/ambiatm1.ogg')
/area/outreach/outpost/atmospherics/b2/tank_outer
	name       = OUTREACH_AREA_NAME_GAS_TANKS
	icon_state = "atmos"
	sound_env  = CAVE

///////////////////////////////////////////////////
//Sec
///////////////////////////////////////////////////
/area/outreach/outpost/security
	icon_state = "security"
	req_access = list(list(access_security), list(access_bridge))
	secure     = TRUE
	sound_env  = STANDARD_STATION
	area_flags = AREA_FLAG_SECURITY

/area/outreach/outpost/security/b1
	name       = "OB 1B Security"
	req_access = list()
	secure     = FALSE

/area/outreach/outpost/security/b1/hallway
	name       = "OB 1B Security Hall"
	icon_state = "checkpoint"
	req_access = list(list(access_security), list(access_bridge))

/area/outreach/outpost/security/b1/office
	name       = "OB 1B Security Office"
	icon_state = "checkpoint"
	req_access = list(list(access_security), list(access_bridge))

/area/outreach/outpost/security/b1/brig
	name       = "OB 1B Brig"
	icon_state = "brig"
	req_access = list(list(access_security), list(access_bridge), list(access_brig))

/area/outreach/outpost/security/b1/cell
	name       = "OB 1B Brig Cell"
	icon_state = "brig"
	sound_env  = PADDED_CELL
	area_flags = AREA_FLAG_PRISON
/area/outreach/outpost/security/b1/cell/A
	name       = "OB 1B Brig Cell A"
/area/outreach/outpost/security/b1/cell/B
	name       = "OB 1B Brig Cell B"
/area/outreach/outpost/security/b1/cell/C
	name       = "OB 1B Brig Cell C"

///////////////////////////////////////////////////
//Mining
///////////////////////////////////////////////////
/area/outreach/outpost/mining
	icon_state = "mining"
/area/outreach/outpost/mining/b1/processing
	name       = "OB 1B Ore Processing"
	icon_state = "mining_production"
	sound_env  = HANGAR
/area/outreach/outpost/mining/b1/storage
	name       = "OB 1B Mining Storage"
/area/outreach/outpost/mining/b1/foyer
	name       = "OB 1B Mining Foyer"
	icon_state = "mining_living"
/area/outreach/outpost/mining/b1/workshop
	name       = "OB 1B Mining Workshop"
	sound_env  = HANGAR
/area/outreach/outpost/mining/b1/office
	name       = "OB 1B Mining Office"
	icon_state = "quartoffice"
	sound_env  = LIVINGROOM
/area/outreach/outpost/mining/b1/eva
	name       = "OB 1B Mining Eva"
	icon_state = "mining_eva"
	sound_env  = SMALL_ENCLOSED

///////////////////////////////////////////////////
//Cargo
///////////////////////////////////////////////////

///////////////////////////////////////////////////
//Airlock
///////////////////////////////////////////////////
/area/outreach/outpost/airlock
	name       = "Airlock"
	icon_state = "entry_1"
	sound_env  = SMALL_ENCLOSED
/area/outreach/outpost/airlock/basement2
	name = "OH 2B Airlock"
/area/outreach/outpost/airlock/basement1/east
	name = "OH 1B East Airlock"
/area/outreach/outpost/airlock/basement1/west
	name = "OH 1B West Airlock"
/area/outreach/outpost/airlock/basement1/south
	name = "OH 1B South Airlock"
/area/outreach/outpost/airlock/basement1/north
	name = "OH 1B North Airlock"
/area/outreach/outpost/airlock/ground
	name = "OH GF Airlock"
/area/outreach/outpost/airlock/floor1
	name = "OH 1F Airlock"

///////////////////////////////////////////////////
//Janitor
///////////////////////////////////////////////////
/area/outreach/outpost/janitorial
	name       = "OH 1B Custodial Storeroom"
	icon_state = "janitor"
	sound_env  = HALLWAY
/area/outreach/outpost/janitorial/hall
	name       = "OH 1B Custodial Office"
	icon_state = "janitor"
	sound_env  = HALLWAY

///////////////////////////////////////////////////
//Restrooms
///////////////////////////////////////////////////
/area/outreach/outpost/restrooms
	name       = "OB 1B Restroom"
	icon_state = "restrooms"
	sound_env  = BATHROOM

///////////////////////////////////////////////////
//Laundry Room
///////////////////////////////////////////////////
/area/outreach/outpost/laundry
	name       = "OB 1B Laundry Room"
	icon_state = "conference"
	sound_env  = BATHROOM

///////////////////////////////////////////////////
//Lockers
///////////////////////////////////////////////////

///////////////////////////////////////////////////
//Hangars
///////////////////////////////////////////////////
/area/outreach/outpost/hangar
	icon_state = "hangar"
	sound_env  = HANGAR
/area/outreach/outpost/hangar/north
	name = "OB GF North Maintenance Hangar"
/area/outreach/outpost/hangar/north/shuttle_area
	name = "OB GF North Hangar Shuttle"

///////////////////////////////////////////////////
//Shed
///////////////////////////////////////////////////
/area/outreach/outpost/storage_shed
	icon_state = "hangar"
	sound_env  = HANGAR
/area/outreach/outpost/storage_shed/gf/north
	name = "OB GF North Maintenance Shed"
/area/outreach/outpost/storage_shed/gf/south
	name = "OB GF South Maintenance Shed"

///////////////////////////////////////////////////
//Vacant
///////////////////////////////////////////////////
/area/outreach/outpost/vacant
	name = "OB Vacant"
	icon_state = "red2"

/area/outreach/outpost/vacant/b1/south/east
	name = "OB 1B Vacant Room"

/area/outreach/outpost/vacant/ground/swroom
	name = "OB GF Vacant Maint"
/area/outreach/outpost/vacant/f1/swroom
	name = "OB 1F Vacant Maint"

/area/outreach/outpost/vacant/ground/depot
	name = "OB GF Vacant Depot"
	icon_state = "storage"
/area/outreach/outpost/vacant/ground/office1
	name = "OB GF Vacant Office #1"
	icon_state = "law"
/area/outreach/outpost/vacant/ground/office2
	name = "OB GF Vacant Office #2"
	icon_state = "law"
/area/outreach/outpost/vacant/ground/office3
	name = "OB GF Vacant Office #3"
	icon_state = "law"
/area/outreach/outpost/vacant/ground/office4
	name = "OB GF Vacant Office #4"
	icon_state = "law"
/area/outreach/outpost/vacant/ground/office5
	name = "OB GF Vacant Office #5"
	icon_state = "law"
/area/outreach/outpost/vacant/ground/office6
	name = "OB GF Vacant Office #6"
	icon_state = "law"
/area/outreach/outpost/vacant/ground/office7
	name = "OB GF Vacant Office #7"
	icon_state = "law"
/area/outreach/outpost/vacant/ground/office8
	name = "OB GF Vacant Office #8"
	icon_state = "law"
/area/outreach/outpost/vacant/ground/office9
	name = "OB GF Vacant Office #9"
	icon_state = "law"

///////////////////////////////////////////////////
// Disposals
///////////////////////////////////////////////////
/area/outreach/outpost/disposals
	name       = "OB 2B Disposals"
	icon_state = "disposal"
	sound_env  = ROOM

///////////////////////////////////////////////////
// EVA
///////////////////////////////////////////////////
/area/outreach/outpost/eva
	name       = "OB GF EVA Storage"
	icon_state = "locker"
	sound_env  = SMALL_ENCLOSED
/area/outreach/outpost/eva/gf/north
	name       = "OB GF North EVA Storage"
/area/outreach/outpost/eva/gf/south
	name       = "OB GF South EVA Storage"

///////////////////////////////////////////////////
//Elevators
///////////////////////////////////////////////////
/area/turbolift/outreach
	//arrival_sound   = 'sound/machines/elevator_door_bell.ogg'
	//forced_ambience = list('sound/music/elevatormusic.ogg')
	ambience        = null

/area/turbolift/outreach/Initialize()
	if(!length(lift_announce_str))
		lift_announce_str = "[length(lift_floor_name)? lift_floor_name : initial(lift_announce_str)]!"
	. = ..()

/area/turbolift/outreach/b2
	name            = "OB Elevator 2nd Basement"
	lift_floor_name = "2nd Basement"
	base_turf       = /turf/simulated/floor/reinforced/elevator_shaft
/area/turbolift/outreach/b1
	name            = "OB Elevator 1st Basement"
	lift_floor_name = "1st Basement"
/area/turbolift/outreach/ground_floor
	name            = "OB Elevator Ground Floor"
	lift_floor_name = "Ground Floor"
/area/turbolift/outreach/f1
	name            = "OB Elevator 1st Floor"
	lift_floor_name = "1st Floor"

///////////////////////////////////////////////////
//Misc
///////////////////////////////////////////////////
// /area/supply_shuttle_dock
// 	name       = "Supply Shuttle Dock"
// 	icon_state = "yellow"
// 	base_turf  = /turf/simulated/floor/plating //Needed for shuttles
// 	open_turf  = OUTREACH_SURFACE_TURF
// 	area_flags = AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_BACKGROUND | AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_EXTERNAL

#undef OUTREACH_AREA_NAME_SERVER_ROOM
#undef OUTREACH_AREA_NAME_CRYO
#undef OUTREACH_AREA_NAME_CONTROL_ROOM
#undef OUTREACH_AREA_NAME_POWER_ROOM
#undef OUTREACH_AREA_NAME_GEOTHERMALS
#undef OUTREACH_AREA_NAME_GAS_TANKS
#undef OUTREACH_AREA_NAME_ATMOS