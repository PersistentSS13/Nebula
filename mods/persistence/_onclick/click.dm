/mob/ClickOn(var/atom/A, var/params)
	if(SSautosave.saving)
		return
	. = ..()

// Default behavior: ignore double clicks, the second click that makes the doubleclick call already calls for a normal click
/mob/DblClickOn(var/atom/A, var/params)
	if(SSautosave.saving)
		return
	. = ..()