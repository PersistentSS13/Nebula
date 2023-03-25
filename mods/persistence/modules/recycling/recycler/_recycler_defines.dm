///Internal reagent volume of the reagent's storage
#define RECYCLER_INTERNAL_VOLUME 2500
///Delay between outputs of dust
#define RECYCLER_OUTPUT_INTERVAL 2 SECONDS
///Delay before the machine goes back to idle power mode
#define RECYCLER_STANDBY_INTERVAL 5 SECONDS
///Delay before we play a noise to nag people about us being clogged.
#define RECYCLER_EMERGENCY_NAG_INTERVAL 5 SECONDS
///Delay before we show another message when something forbidden enters our turf
#define RECYCLER_FORBIDDEN_NAG_INTERVAL 1 SECONDS
///Delay before we announce our jam was cleared again.
#define RECYCLER_CLEARED_MSG_INTERVAL 1 SECONDS

///Used to prevent ending up with a near infinite recursion when adding up contained items
#define RECYCLER_MAX_SANE_CONTAINER_DEPTH 50
///Raw damage dealt to living mobs going through the recycler
#define RECYCLER_MOB_CRUSH_DAMAGE  rand(56, 128)
///Sound effect for destroying artificial solid items
#define RECYCLER_SOUND_CRUSH_OBJECT  'sound/items/Welder.ogg'
///Sound effect for destroying organic items
#define RECYCLER_SOUND_CRUSH_ORGANIC 'sound/effects/splat.ogg'


///Bitflag for when the recycler is shorted and shocks anything that touches it.
#define RECYCLER_FLAG_SHORTED     BITFLAG(0)
///Bitflag indicating that safeties were disabled on the recycler.
#define RECYCLER_FLAG_UNSAFE      BITFLAG(1)
///Bitflag indicating that the recycler is currently in emergency stop mode.
#define RECYCLER_FLAG_EMERGENCY   BITFLAG(2)
///Bitflag indicating that the recycler is currently overheating.
#define RECYCLER_FLAG_OVERHEATING BITFLAG(3)
///Bitflag indicating that the power wires were cut
#define RECYCLER_FLAG_POWER_CUT   BITFLAG(4)