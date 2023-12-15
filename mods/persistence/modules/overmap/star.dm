/////////////////////////////////////////////////////////////////////////////////
// Overmap Star
/////////////////////////////////////////////////////////////////////////////////
/obj/effect/overmap/star
	name       = "star"
	desc       = "A massive ball of plasma fusing hydrogen and producing light."
	icon       = 'icons/obj/overmap.dmi'
	icon_state = "star"
	color      = "#e4e684"
	var/image/skybox_image

/obj/effect/overmap/star/Initialize()
	. = ..()
	generate_skybox_representation()

/obj/effect/overmap/star/get_skybox_representation()
	return skybox_image

/obj/effect/overmap/star/proc/generate_skybox_representation()
	var/image/atmo  = image('icons/skybox/planet.dmi', "atmoring")
	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	var/image/base  = image('icons/skybox/planet.dmi', "base")
	skybox_image    = image('icons/skybox/planet.dmi', "")

	var/list/HSV = rgb2num(color, COLORSPACE_HSV)
	HSV[2] = CEILING(HSV[2] * 0.10)
	atmo.color = rgb(HSV[1], HSV[2], HSV[3], space = COLORSPACE_HSV)

	HSV = rgb2num(color, COLORSPACE_HSV)
	HSV[2] = CEILING(HSV[2] * 0.5)
	light.color = rgb(HSV[1], HSV[2], HSV[3], space = COLORSPACE_HSV)

	base.color = color
	skybox_image.underlays        += atmo
	skybox_image.overlays         += base
	skybox_image.overlays         += light
	skybox_image.pixel_x          = rand(0,64)
	skybox_image.pixel_y          = rand(128,256)
	skybox_image.appearance_flags = RESET_COLOR
