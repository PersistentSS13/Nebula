/proc/report_progress_serializer(var/progress_message)
	admin_notice(SPAN_SERIALIZER(progress_message), R_DEBUG)
	to_world_log(SPAN_SERIALIZER(progress_message))
