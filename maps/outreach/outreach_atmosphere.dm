#define OUTREACH_PRESSURE (ONE_ATMOSPHERE/2)
#define OUTREACH_TEMP (T0C)
#define OUTREACH_ATMOS_MOLES (OUTREACH_PRESSURE * CELL_VOLUME/(OUTREACH_TEMP * R_IDEAL_GAS_EQUATION))
#define OUTREACH_ATMOS list(\
	/decl/material/gas/oxygen         = 0.10 * OUTREACH_ATMOS_MOLES,\
	/decl/material/gas/chlorine       = 0.17 * OUTREACH_ATMOS_MOLES,\
	/decl/material/gas/nitrogen       = 0.53 * OUTREACH_ATMOS_MOLES,\
	/decl/material/gas/carbon_dioxide = 0.11 * OUTREACH_ATMOS_MOLES,\
)
