/datum/quadrant
    var/name = "Default Quadrant"
    var/default_securitylvl = 2 // Security levels
    var/list/securitylvl_modifiers = list()
	var/uid = "default" // used to link trade beacons/events with the
	var/current_securitylvl = 0



/datum/SLModifier
	var/name = "Security Level Modifier"
	var/value = 0 // how much to change the security level by
	var/expiry = 0 // realtime that the modifier should be deleted
