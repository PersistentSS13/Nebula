/obj/machinery/camera
	var/comp_network
	var/recording = 0.0
	var/playing = 0.0
	var/playsleepseconds = 0.0
	var/obj/item/memory/mymem
	var/obj/item/photo/p
	var/canprint = 1
	var/on = 0
	var/list/beams
	var/list/seen_turfs
	var/datum/proximity_trigger/square/proximity_trigger
	var/size = 10

/obj/machinery/camera/proc/getnid()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	src.comp_network = D.network_id
	return D.network_id

/obj/machinery/camera/Initialize()
	set_extension(src, /datum/extension/network_device)
	getnid()
	beams = list()
	seen_turfs = list()
	proximity_trigger = new(src, /obj/machinery/camera/proc/on_beam_entered, /obj/machinery/camera/proc/on_visibility_change, world.view, PROXIMITY_EXCLUDE_HOLDER_TURF)
	. = ..()


/obj/machinery/camera/Destroy()
	. = ..()
	qdel(proximity_trigger)
	proximity_trigger = null
	return ..()


/obj/machinery/camera/attackby(obj/item/W, mob/living/user)
	. = ..()
	if(istype(W, /obj/item/memory) && panel_open)
		if(mymem)
			to_chat(user, "<span class='notice'>There's already a memory card inside.</span>")
			return
		if(!user.unEquip(W))
			return
		W.forceMove(src)
		mymem = W
		to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")

	if(isCrowbar(W) && panel_open)
		if(mymem)
			to_chat(user, "You unattach a memory drive from the assembly.")
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			mymem.dropInto(loc)
			mymem = null
		if(recording)
			stop_recording()
			set_active(new_on = 0)
			return

	if((isMultitool(W)) && panel_open)
		var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(user)

/obj/machinery/camera/verb/print_transcript(mob/user)
	set name = "Print Transcript"
	set category = "Object"
	if(usr.incapacitated())
		return
	if(!mymem)
		to_chat(usr, "<span class='notice'>There's no memory!</span>")
		return
	if(mymem.ruined || emagged)
		audible_message("<span class='warning'>You hear a scratchy noise.</span>")
		return
	if(!canprint)
		to_chat(usr, "<span class='notice'>Can't print that fast!</span>")
		return
	if(recording || playing)
		to_chat(usr, "<span class='notice'>You can't print the transcript while playing or recording!</span>")
		return

	to_chat(usr, "<span class='notice'>Transcript printed.</span>")
	var/obj/item/paper/P = new /obj/item/paper(get_turf(user.loc))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i=1,mymem.storedinfo.len >= i,i++)
		var/printedmessage = mymem.storedinfo[i]
		t1 += "[printedmessage]<BR>"
	P.info = t1
	P.SetName("[c_tag] Transcript")
	canprint = 0
	sleep(300)
	canprint = 1

/obj/machinery/camera/verb/play(mob/user)
	if(!mymem)
		to_chat(user, "<span class='notice'>There's no memory!</span>")
		return
	if(mymem.ruined)
		audible_message("<span class='warning'>You hear a scratchy noise.</span>")
		return
	if(recording)
		to_chat(user, "<span class='notice'>You can't playback when recording!</span>")
		return
	if(playing)
		to_chat(user, "<span class='notice'>You're already playing!</span>")
		return
	playing = 1
	to_chat(user, "<span class='notice'>Audio playback started.</span>")
	playsound(src, 'sound/machines/click.ogg', 10, 1)
	for(var/i=1 , i < mymem.max_capacity , i++)
		if(!mymem || !playing)
			break
		if(mymem.storedinfo.len < i)
			break

		var/turf/T = get_turf(src)
		var/playedmessage = mymem.storedinfo[i]
		if(findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message("<font color=Maroon><B>Playback</B>: [playedmessage]</font>")

		if(mymem.storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Playback</B>: End of recording.</font>")
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			break
		else
			playsleepseconds = mymem.timestamp[i+1] - mymem.timestamp[i]

		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Playback</B>: Skipping [playsleepseconds] seconds of silence</font>")
			playsleepseconds = 1
		sleep(10 * playsleepseconds)


	playing = 0


/obj/machinery/camera/hear_talk(mob/living/M, msg, var/verb="says", decl/language/speaking=null)
	if(mymem && recording)

		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			mymem.record_speech("[M.name] [speaking.format_message_plain(msg, verb)]")
		else
			mymem.record_speech("[M.name] [verb], \"[msg]\"")

/obj/machinery/camera/see_emote(mob/M, text, var/emote_type)
	if(mymem && recording)
		mymem.record_speech("[strip_html_properly(text)]")


/obj/machinery/camera/show_message(msg, type, alt, alt_type)
	var/recordedtext
	if (msg && type) //must be hearable
		recordedtext = msg
	else if (alt && alt_type)
		recordedtext = alt
	else
		return
	if(mymem && recording)
		mymem.record_noise("[strip_html_properly(recordedtext)]")

/obj/machinery/camera/verb/record()

	set name = "Start Recording"
	set category = "Object"

	if(usr.incapacitated())
		return
	playsound(src, 'sound/machines/click.ogg', 10, 1)

	if(playing)
		to_chat(usr, "<span class='notice'>You can't record when playing!</span>")
		return

	if(!mymem)
		to_chat(usr, "<span class='notice'>There's no memory!</span>")
		return
	if(mymem.ruined)
		audible_message("<span class='warning'>The sound makes a scratchy noise.</span>")
		return
	if(mymem.used_capacity < mymem.max_capacity)
		recording = 1

		mymem.record_speech("Recording started.")

		//count seconds until full, or recording is stopped
		while(mymem && recording && mymem.used_capacity < mymem.max_capacity)
			sleep(10)
			mymem.used_capacity++
			if(mymem.used_capacity >= mymem.max_capacity)
				if(ismob(loc))
					var/mob/M = loc
					to_chat(M, "<span class='notice'>The memory is full.</span>")
				stop_recording()

		return
	else
		to_chat(usr, "<span class='notice'>The memory is full.</span>")

/obj/machinery/camera/verb/stop_recording()
	//Sanity checks skipped, should not be called unless actually recording
	recording = 0
	mymem.record_speech("Recording stopped.")
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, "<span class='notice'>Recording stopped.</span>")

/obj/machinery/camera
	var/visible = 0
	var/cooldown = 0//To prevent spam

/obj/machinery/camera/Process()
	return PROCESS_KILL

//This needs to be called to trigger proximity
/obj/machinery/camera/proc/set_active(new_on)
	if(new_on == on)
		return
	on = new_on
	if(on)
		proximity_trigger.register_turfs()
	else
		proximity_trigger.unregister_turfs()
	update_beams()
	return

/obj/machinery/camera/proc/on_beam_entered(var/atom/enterer)

	if(enterer == src)
		return
	if(enterer.invisibility > INVISIBILITY_LEVEL_TWO)
		return
	if(!anchored || !on)
		return 0
	if((ismob(enterer) && !isliving(enterer)))
		return
	if(!recording)
		src.record()
	mymem.record_speech("[enterer] entered at [enterer.x],[enterer.y]")
//	src.captureimage(enterer)
//:WARNING: captureimage() is extremely inefficient because it calls generateimage which is exspensive for videorecording features
/obj/machinery/camera/proc/on_visibility_change(var/list/old_turfs, var/list/new_turfs)
	seen_turfs = new_turfs
	update_beams()

/obj/machinery/camera/proc/update_beams()
	create_update_and_delete_beams(status, visible, dir, seen_turfs, beams)


/obj/machinery/camera/proc/get_mobs(turf/the_turf)
	var/mob_detail
	for(var/mob/living/carbon/A in the_turf)
		if(A.invisibility)
			continue
		var/holding
		for(var/obj/item/thing in A.get_held_items())
			LAZYADD(holding, "\a [thing]")
		if(length(holding))
			holding = "They are holding [english_list(holding)]"
		if(!mob_detail)
			mob_detail = "You can see [A] on the photo[(A.health / A.maxHealth) < 0.75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]. "
		else
			mob_detail += "You can also see [A] on the photo[(A.health / A.maxHealth)< 0.75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]."
	return mob_detail

/obj/machinery/camera/proc/captureimage(var/atom/enterer, flag)
	var/x_c = enterer.x - (size-1)/2
	var/y_c = enterer.y + (size-1)/2
	var/z_c	= enterer.z
	var/mobs = ""
	for(var/i = 1 to size)
		for(var/j = 1 to size)
			var/turf/T = locate(x_c, y_c, z_c)
			mobs += get_mobs(T)
			x_c++
		y_c--
		x_c = x_c - size
	var/obj/item/photo/p = createpicture(enterer, mobs, flag)
	mymem.savepicture(p)

/obj/machinery/camera/proc/createpicture(var/atom/enterer, mobs, flag)
	var/x_c = enterer.x - (size-1)/2
	var/y_c = enterer.y - (size-1)/2
	var/z_c	= enterer.z
	var/icon/photoimage = generate_image(x_c, y_c, z_c, size, CAPTURE_MODE_PARTIAL, lighting = 0)
	var/obj/item/photo/p = new()
	p.img = photoimage
	p.desc = mobs
	p.photo_size = size
	p.update_icon()

	return p
