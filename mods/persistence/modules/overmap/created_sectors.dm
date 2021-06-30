/obj/effect/overmap/visitable/sector/created
	desc = "A permanent space settlement."
	free_landing = TRUE
	restricted_area = 50

/obj/effect/overmap/visitable/sector/created/Initialize(var/mapload, var/name, var/start_x, var/start_y, var/color)
	if(name) src.name = name
	if(start_x) src.start_x = start_x
	if(start_y) src.start_y = start_y
	if(color) src.color = color
	. = ..(mapload)

/obj/effect/overmap/visitable/ship/created
	desc = "A large ship intended to remain permanently in space."
	free_landing = TRUE
	restricted_area = 50

/obj/effect/overmap/visitable/ship/created/Initialize(var/mapload, var/name, var/start_x, var/start_y, var/color)
	if(name) src.name = name
	if(start_x) src.start_x = start_x
	if(start_y) src.start_y = start_y
	if(color) src.color = color
	. = ..(mapload)