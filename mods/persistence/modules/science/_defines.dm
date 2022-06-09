#define FIELD_BONUS  BITFLAG(0) // The next decrease or increase of points on this field will be doubled
#define FIELD_LINKED BITFLAG(1) // The next increase or decrease of points on this field will occur on all linked fields.
#define TECH_POINT_MULT 3 // Tech costs are multiplied by 3 to make the research minigame more flexible.

#define FIELD_LOCKED BITFLAG(2) // The next increase or decrease of points on this field will not change the actual value.

#define SPEC_RECIPE     "spec_recipe"  // Specification will affect the recipe once, adding a material or energy cost etc.
#define SPEC_PRODUCTION "spec_prod"    // Specification will add production requirements, checked on build()
#define SPEC_FINISH     "spec_finish"  // Specification will create a dummy object which needs to be "finished".
#define SPEC_ITEM       "spec_item" // Specifications are passed onto items in an extension, which are expected to handle behavior themselves.

#define THEORY_NEEDS_ITEM      1
#define THEORY_INCOMPATIBLE    2
#define THEORY_CANNOT_PROGRESS 3
#define THEORY_SUCCESS         4

#define POINTS_PER_TIER     10

#define STRENGTH_TO_MAT_AMOUNT(strength) round((10/strength) * SHEET_MATERIAL_AMOUNT, SHEET_MATERIAL_AMOUNT)

var/global/tech_id_to_name = list()

/decl/research_field/Initialize()
	. = ..()
	tech_id_to_name[id] = name

/decl/modpack/persistence/post_initialize()
	. = ..()
	global.all_mainframe_roles += MF_ROLE_DESIGN

/obj/machinery/computer/modular/preset/aislot/research
	default_software = list(
		/datum/computer_file/program/network_monitor,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/aidiag,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/design_writer
	)
