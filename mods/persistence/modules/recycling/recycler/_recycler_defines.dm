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

///Returns whether the living mob was ever/is under player control. Also checks for any brainmobs.
/proc/is_mob_player_owned(var/mob/living/L)
	if(!istype(L))
		return FALSE
	if(!isnull(L.client) || !isnull(L.ckey))
		return TRUE
	var/mob/brainmob = get_mob_brainmob(L)
	return (!isnull(brainmob) && (!isnull(brainmob.client) || !isnull(brainmob.ckey)))

///For a given mob return its contained brainmob if it has one
/proc/get_mob_brainmob(var/mob/living/L)
	if(!istype(L))
		return
	if(isbrain(L))
		return L

	var/obj/item/organ/internal/brain/brain = GET_INTERNAL_ORGAN(L, BP_BRAIN)
	if(istype(brain) && !isnull(brain.brainmob))
		return brain.brainmob

	var/obj/item/organ/internal/posibrain/posibrain = GET_INTERNAL_ORGAN(L, BP_POSIBRAIN)
	if(istype(posibrain) && !isnull(posibrain.brainmob))
		return posibrain.brainmob

	var/obj/item/organ/internal/stack/neuralstack = GET_INTERNAL_ORGAN(L, BP_STACK)
	if(istype(neuralstack) && !isnull(neuralstack.stackmob))
		return neuralstack.stackmob