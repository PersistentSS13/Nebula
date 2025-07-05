//Some helpers for passing chargen state around
///Chargen state for minds of entities that do not go through chargen. Prevents skipping save on potentially desired saved entities.
#define CHARGEN_STATE_NONE            -1
///Chargen state for new characters going through the character generator. This indicates the origins form was not completed yet.
#define CHARGEN_STATE_FORM_INCOMPLETE 0
///Chargen state for new characters going through the character generator. This indicates the origins form was filled and submitted.
#define CHARGEN_STATE_FORM_COMPLETE   1
///Chargen state for new characters going through the character generator. This indicates the character is in the spawn pod and is waiting to be moved to spawn.
#define CHARGEN_STATE_AWAITING_SPAWN  2
///Chargen state for new characters going through the character generator. This indicates the character was spawned in the world and chargen is completed.
#define CHARGEN_STATE_FINALIZED       3