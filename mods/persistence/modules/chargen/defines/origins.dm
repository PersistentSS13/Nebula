/decl/hierarchy/chargen/origin
	abstract_type = /decl/hierarchy/chargen/origin

/decl/hierarchy/chargen/origin/Initialize()
	. = ..()
	if(!desc)
		desc = "I grew up on \a [name]."

/decl/hierarchy/chargen/origin/agricultural
	ID = "agricultural_world"
	name = "Agricultural World"
	skills = list(
		SKILL_BOTANY 	= 1,
		SKILL_LITERACY 	= 1
	)
	remaining_points_offset = 0

/decl/hierarchy/chargen/origin/industrial
	ID = "industrial_world"
	name = "Industrial World"
	skills = list(
		SKILL_CONSTRUCTION	= 1,
		SKILL_LITERACY		= 1
	)
	remaining_points_offset = 0

/decl/hierarchy/chargen/origin/asteroid
	ID = "asteroid_belt"
	name = "Asteroid Belt"
	skills = list(
		SKILL_EVA			= 1,
		SKILL_LITERACY		= 1
	)
	remaining_points_offset = 0

/decl/hierarchy/chargen/origin/penal
	ID = "penal_colony"
	name = "Penal Colony"
	skills = list(
		SKILL_HAULING		= 1,
		SKILL_COMBAT		= 1
	)
	remaining_points_offset = 2

/decl/hierarchy/chargen/origin/frontier
	ID = "frontier_world"
	name = "Frontier World"
	skills = list(
		SKILL_COOKING		= 1,
		SKILL_BOTANY		= 1
	)
	remaining_points_offset = 0

/decl/hierarchy/chargen/origin/garden
	ID = "garden_world"
	name = "Garden World"
	skills = list(
		SKILL_FINANCE		= 1,
		SKILL_LITERACY		= 1
	)
	remaining_points_offset = 0

/decl/hierarchy/chargen/origin/nexus
	ID = "nexus_world"
	name = "Nexus World"
	skills = list(
		SKILL_FORENSICS		= 1,
		SKILL_LITERACY		= 1
	)
	remaining_points_offset = 0

/decl/hierarchy/chargen/origin/research
	ID = "research_station"
	name = "Research Station"
	skills = list(
		SKILL_SCIENCE		= 1,
		SKILL_LITERACY		= 1
	)
	remaining_points_offset = 0

/decl/hierarchy/chargen/origin/high_tech
	ID = "high_tech_world"
	name = "High-Tech World"
	skills = list(
		SKILL_DEVICES		= 1,
		SKILL_LITERACY		= 1
	)
	remaining_points_offset = 0

/decl/hierarchy/chargen/origin/medical
	ID = "medical_hub"
	name = "Medical Hub"
	skills = list(
		SKILL_LITERACY = 1,
		SKILL_MEDICAL = 1
	)
	remaining_points_offset = 0