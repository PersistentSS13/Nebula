/datum/wrapper/image
	wrapper_for = /image

	// Image details
	var/icon_state
	var/dir
	var/color
	var/alpha
	var/layer
	var/pixel_x = 0
	var/pixel_y = 0
	var/appearance_flags

/datum/wrapper/image/on_serialize(var/image/I)
	key = "[I.icon]"

	icon_state = I.icon_state
	dir = I.dir
	color = I.color
	alpha = I.alpha
	layer = I.layer
	pixel_x = I.pixel_x
	pixel_y = I.pixel_y
	appearance_flags = I.appearance_flags

/datum/wrapper/image/on_deserialize()
	var/image/I = image(icon=file(key), icon_state=icon_state, dir=dir, pixel_x=pixel_x, pixel_y=pixel_y, layer=layer)
	I.color = color
	I.alpha = alpha
	I.appearance_flags = appearance_flags
	return I
