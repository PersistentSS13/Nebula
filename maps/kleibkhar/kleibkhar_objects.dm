/obj/structure/noticeboard/kleibkhar
	icon_state = "nboard05"

/obj/structure/noticeboard/kleibkhar/Initialize()
	. = ..()
	var/obj/item/paper/P = new()
	P.SetName("A Small Hello from billy bob")
	P.info = {"<b>Hey fellow colonyfolk!</b>
	<br>
	<br>They didn't build a Hydroponics so I left quite some time ago. \
	but don't worry friend here's some instructions on how to get yourself started,\
	<br><i>ground up!</i>
	<br>
	<br>All you need is just a mini-hoe and some stone. \
	Using a mini-hoe on wild grass you can uproot new seeds from the soil. \
	And using some stone you can pound out some dirt plots to start growing. \
	Though I'd very much prefer Hydroponics trays me-self rather than ol'; reliable. \
	Very much wish they'd install a botany vendor with such essentials, but you know how some bossfolk can be.
	<br>
	<br>Time to be off, good luck!
	<br>
	<br>And best regards,
	<br><font face="Times New Roman"><i>billy bob Johnson</i></font>
	<br>
	<br>PS.
	<br>If they do install one of those vendors, get yourself a hydroponics tray.
	<br>"}
	add_paper(P, skip_icon_update = TRUE)

	P = new()
	P.SetName("Recycle your trash!")
	P.info = {"<b>Rubbish can be placed into an autolathe.</b>
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

/obj/item/paper/ladder
	name = "building a Ladder"
	info = {"\[b\]Hold aluminium in hand.\[/b\]

	Now figure it out, because I can't.
	\[br\]"}
