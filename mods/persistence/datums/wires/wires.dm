//Fix annoyance
/datum/wires/New(var/atom/holder)
	if(!holder) //Don't kill init on null holder. Since we're loading from save
		return
	..()