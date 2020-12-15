/obj/structure/window/Initialize()
	if(!SSpersistence.in_loaded_world)
		return ..()

	material = ispath(material) ? decls_repository.get_decl(material) : material
	set_anchored(anchored)
	set_dir(dir)
	if(is_fulltile())
		layer = FULL_WINDOW_LAYER
	return INITIALIZE_HINT_LATELOAD