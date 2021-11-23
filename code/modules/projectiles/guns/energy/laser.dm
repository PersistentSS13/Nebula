/obj/item/gun/energy/laser
	name = "UC LG 'Sunshine'"
	desc = "This United Colonists-manufactured rifle is one of their most famous works, initially used by their footsoldiers and now used by pirates and law enforcement galaxywide. \ This is a Tier 2 (Advanced) firearm."
	icon = 'icons/obj/guns/laser_carbine.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	force = 10
	max_shots = 8
	one_hand_penalty = 3
	bulk = GUN_BULK_RIFLE
	origin_tech = "{'combat':3,'magnets':2}"
	material = /decl/material/solid/metal/steel
	projectile_type = /obj/item/projectile/beam/midlaser

/obj/item/gun/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1
	one_hand_penalty = 0 //just in case
	has_safety = FALSE

/obj/item/gun/energy/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice
	charge_cost = 10 //How much energy is needed to fire.

/obj/item/gun/energy/laser/practice/on_update_icon()
	. = ..()
	overlays += mutable_appearance(icon, "[icon_state]_stripe", COLOR_ORANGE)

/obj/item/gun/energy/laser/practice/proc/hacked()
	return projectile_type != /obj/item/projectile/beam/practice

/obj/item/gun/energy/laser/practice/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	if(hacked())
		return NO_EMAG_ACT
	to_chat(user, "<span class='warning'>You disable the safeties on [src] and crank the output to the lethal levels.</span>")
	desc += " Its safeties are disabled and output is set to dangerous levels."
	projectile_type = /obj/item/projectile/beam/midlaser
	charge_cost = 20
	max_shots = rand(3,6) //will melt down after those
	return 1

/obj/item/gun/energy/laser/practice/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	..()
	if(hacked())
		max_shots--
		if(!max_shots) //uh hoh gig is up
			to_chat(user, "<span class='danger'>\The [src] sizzles in your hands, acrid smoke rising from the firing end!</span>")
			desc += " The optical pathway is melted and useless."
			projectile_type = null

/obj/item/gun/energy/captain
	name = "BSL LG 'Brown'"
	icon = 'icons/obj/guns/caplaser.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "This weapon is one of the few weapons ever created by the BSL that wasn't destroyed when they lost their grip on the Kleibkhar Sector. It is capable of self-recharging, has decent capacity, and is easy to handle. \ This is a Tier 3 (Ultra) firearm."
	force = 5
	slot_flags = SLOT_LOWER_BODY //too unusually shaped to fit in a holster
	w_class = ITEM_SIZE_NORMAL
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	max_shots = 5 //to compensate a bit for self-recharging
	one_hand_penalty = 1 //a little bulky
	self_recharge = 1

/obj/item/gun/energy/lasercannon
	name = "PF LG 'Ball Buster'"
	desc = "The laser cannon is a design invented by the Pirate Federation, and is a fine example of their ethics - big, scary, and powerful. Although it packs a massive punch, it takes ages to fire and can only hold three shots. \ This is Tier 2 (Advanced) firearm."
	icon_state = "lasercannon"
	icon = 'icons/obj/guns/laser_cannon.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':4,'materials':3,'powerstorage':3}"
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	one_hand_penalty = 6 //large and heavy
	w_class = ITEM_SIZE_HUGE
	projectile_type = /obj/item/projectile/beam/heavylaser
	charge_cost = 40
	max_shots = 3
	accuracy = 3
	fire_delay = 30
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	accuracy = 0 //mounted laser cannons don't need any help, thanks
	one_hand_penalty = 0
	has_safety = FALSE
	
// persistence guns

/obj/item/gun/energy/laser/handmade
	name = "HM LG 'Bug Zapper'"
	desc = "A cobbled-together mass of electronic components, duct tape, and hope. Low damage and capacity, but uses energy instead of bullets. \ This is a Tier 0 (Makeshift) firearm."
	icon = 'icons/obj/guns/makeshift_laser.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	one_hand_penalty = 5
	max_shots = 4
	fire_delay = 15
	origin_tech = "{'combat':1,'magnets':1}"
	projectile_type = /obj/item/projectile/beam/smalllaser
	
/obj/item/gun/energy/laser/settler
	name = "UC LG 'Settler'"
	desc = "A utilitarian laser pistol invented by the United Colonists when ammunition became too scarce for practical use. While weak, it is easy to handle one-handed and has decent capacity. \ This is a Tier 1 (Simple) firearm."
	icon = 'icons/obj/guns/laspistol.dmi'
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_NORMAL
	one_hand_penalty = 1
	max_shots = 6
	fire_delay = 10
	origin_tech = "{'combat':2,'magnets':2}"
	projectile_type = /obj/item/projectile/beam/smalllaser
	
/obj/item/gun/energy/laser/footman
	name = "UC LG 'Footman'"
	desc = "A cheap, mass-produced laser rifle invented by the United Colonists for use in their militas. It packs a decent punch, but is large and difficult to use one-handed. \ This is a Tier 1 (Simple) firearm."
	icon = 'icons/obj/guns/lasrifle.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	one_hand_penalty = 6
	max_shots = 5
	fire_delay = 12
	origin_tech = "{'combat':2,'magnets':3}"
	projectile_type = /obj/item/projectile/beam/midlaser
