/datum/uniqueness_generator/guid_generator
	///The next id to assign for new entries of a given key.
	var/list/sequence_id_by_key = list()
	///The guid for a given key.
	var/list/guids_by_key = list()

/datum/uniqueness_generator/guid_generator/Generate(var/key, var/default_id = 100)
	var/sequence_id  = sequence_id_by_key?[key] || 1
	var/variant_flag = (key in sequence_id_by_key)? sequence_id_by_key[key] : rand(32768, 65535)
	var/timeofday    = num2hex(world.timeofday, 8)
	var/epoc         = num2hex(world.realtime / 10, 8)
	var/variant      = num2hex(min(variant_flag, 65535), 4)
	var/sequence     = num2hex(sequence_id, 6)
	timeofday        = "[copytext(timeofday, 1, 5)]-[copytext(timeofday, 5, 9)]"
	. = "[epoc]-[timeofday]-[num2hex(rand(1, 255))][num2hex(rand(1, 255))]-[variant][sequence][num2hex(rand(1, 255))]"
	sequence_id_by_key[key] = sequence_id + 1
	guids_by_key[key] = .
	//log_debug("GUID_GEN - Order: [sequence_id], Key: '[key]', GUID: '[.]'")