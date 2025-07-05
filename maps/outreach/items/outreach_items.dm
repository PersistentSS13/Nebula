///////////////////////////////////////////////////////////////////////////////////
// Boxes
///////////////////////////////////////////////////////////////////////////////////
/obj/item/storage/box/camera_films
	name = "box of camera film rolls"
/obj/item/storage/box/camera_films/WillContain()
	var/obj/item/camera_film/F = /obj/item/camera_film
	return list(
		/obj/item/camera_film =  BASE_STORAGE_CAPACITY(initial(F.w_class)),
		)

/obj/item/storage/box/barricade_tape/police
	name = "box of police tape"
/obj/item/storage/box/barricade_tape/police/WillContain()
	var/obj/item/stack/tape_roll/barricade_tape/police/P = /obj/item/stack/tape_roll/barricade_tape/police
	return list(
		/obj/item/stack/tape_roll/barricade_tape/police =  BASE_STORAGE_CAPACITY(initial(P.w_class)),
		)

/obj/item/storage/box/large/dual_band_radios
	name = "large box of dual-band radios"
	desc = "A large box of spare dual-band radios."
/obj/item/storage/box/large/dual_band_radios/WillContain()
	var/obj/item/radio/R = /obj/item/radio
	return list(/obj/item/radio = BASE_STORAGE_CAPACITY(initial(R.w_class)))

/obj/item/storage/box/large/ore_detectors
	name = "large box of ore detectors"
	desc = "A large box of spare ore detectors."
/obj/item/storage/box/large/ore_detectors/WillContain()
	var/obj/item/scanner/mining/M = /obj/item/scanner/mining
	return list(/obj/item/scanner/mining = BASE_STORAGE_CAPACITY(initial(M.w_class)))