/datum/stored_items
	should_save = TRUE

/datum/stored_items/New(var/atom/storing_object, var/path, var/name = null, var/amount = 0)
	//Shitty hack to get stored items to load properly
	if(isnull(storing_object) && isnull(path) && isnull(name) && amount == 0)
		return //Don't run the base class's new at all 
	..()
