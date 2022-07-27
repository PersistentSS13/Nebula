/proc/report_progress_serializer(var/progress_message)
	admin_notice("<span class='boldannounce' style='color:\"purple\";'>[progress_message]</span>", R_DEBUG)
	to_world_log(progress_message)
