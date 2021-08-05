/obj/structure/noticeboard/kleibkhar
	icon_state = "nboard05"

/obj/structure/noticeboard/kleibkhar/Initialize()
	. = ..()
	var/obj/item/paper/P = new()
	P.SetName("A Small Hello from Billy Bob")
	P.info = {"<b>Hey fellow colonyfolk!</b>
	<br>
	<br>They didn't build a decent Hydroponics so I left quite some time ago. \
	But don't worry friend here's some instructions on how to get yourself started,\
	<br><i>ground up!</i>
	<br>
	<br>All you need is just a mini-hoe and some stone. \
	Using a mini-hoe on wild grass you can uproot new seeds from the soil. \
	And using some stone you can pound out some dirt plots to start growing. \
	Though I'd very much prefer Hydroponics trays me-self rather than ol' reliable. \
	You can get the hydro-tray boards from the PlantVend, good luck building them though.
	<br>
	<br>Time to be off, good luck!
	<br>
	<br>And best regards,
	<br><font face="Times New Roman"><i>Billy Bob Johnson</i></font>
	<br>
	<br>PS.
	<br>If you do build yourself a hydroponics, get a farmbot from someone robotic-minded.
	<br>"}
	add_paper(P, skip_icon_update = TRUE)

	P = new()
	P.SetName("Lathe Your Trash!")
	P.info = {"<b>Rubbish can be recycled into an autolathe.</b>
	<br>
	<br>Put your candy wrappers into the autolathe people, stop dropping them on the ground please!
	<br>"}
	add_paper(P, skip_icon_update = TRUE)

	P = new()
	P.SetName("Expand this board")
	P.info = {"<b>Only YOU can help your community.</b>
	<br>
	<br>Place all colony requisites, recruitment, services, and other notices upon this board.
	<br>
	<br>KEEP in contact, STAY organized, and MAKE profit.
	<br>"}
	add_paper(P, skip_icon_update = TRUE)

	P = new()
	P.SetName("RE: Paint Sprayer")
	P.info = {"Deadline coming, all crews on clean out.
	<br>
	<br><b>This means someone should be finding that paint sprayer for the walls.</b>
	<br>"}
	add_paper(P)
