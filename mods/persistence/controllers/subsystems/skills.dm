#define SS_PRIORITY_SKILLS     100

SUBSYSTEM_DEF(skills)
	name = "Skills"
	wait = 5 MINUTES
	priority = SS_PRIORITY_SKILLS
	flags = SS_NO_INIT
	var/tmp/list/client_list

/datum/controller/subsystem/skills/fire(resumed = FALSE)
	if (!resumed)
		client_list = global.clients.Copy()

	while(client_list.len)
		var/client/C = client_list[client_list.len]
		client_list.len--
		if(C.is_afk(5 MINUTES))
			continue
		
		var/mob/target_mob = C.mob
		if(isobserver(target_mob))
			var/datum/mind/M = C.mob.mind
			if(!M || isobserver(M)) continue //#FIXME: isobserver(M) will always be false, because M is a /datum/mind
			target_mob = M.current
		
		if(target_mob && target_mob.skillset)
			target_mob.skillset.gain_time(wait)

		if (MC_TICK_CHECK)
			return