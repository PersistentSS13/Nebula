// Serializes radio channels into a list per channel, both for efficiency (flattening) and to make telecomms initialization cleaner
/datum/wrapper/radio_channel
	wrapper_for = /datum/radio_channel

	var/list/channel_data

/datum/wrapper/radio_channel/on_serialize(datum/radio_channel/channel, serializer/curr_serializer)
	. = ..()
	key = "[channel.name]"

	channel_data = list()

	if(!isnull(channel.name))
		channel_data["name"] = channel.name
	if(!isnull(channel.key))
		channel_data["key"] = channel.key
	if(!isnull(channel.frequency))
		channel_data["frequency"] = channel.frequency
	if(!isnull(channel.color))
		channel_data["color"] = channel.color
	if(!isnull(channel.color))
		channel_data["secured"] = channel.secured
	if(!isnull(channel.span_class))
		channel_data["span_class"] = channel.span_class
	if(!isnull(channel.receive_only))
		channel_data["receive_only"] = channel.receive_only

/datum/wrapper/radio_channel/on_deserialize(datum/object, serializer/curr_serializer)
	return channel_data

SAVED_VAR(/datum/wrapper/radio_channel, channel_data)