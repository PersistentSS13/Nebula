/obj/item/storage/pill_bottle/dylovene
	name = "pill bottle (dylovene)"
	desc = "Contains pills used to counter toxins."

	startswith = list(/obj/item/chems/pill/dylovene = 21)
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/bicaridine
	name = "pill bottle (bicaridine)"
	desc = "Contains pills used to stabilize the severely injured."

	startswith = list(/obj/item/chems/pill/bicaridine = 21)
	wrapper_color = COLOR_MAROON

/obj/item/storage/pill_bottle/oxygen
	name = "pill bottle (oxygen)"
	desc = "Contains pills used to treat oxygen deprivation."

	startswith = list(/obj/item/chems/pill/oxygen = 21)
	wrapper_color = COLOR_LIGHT_CYAN

/obj/item/storage/pill_bottle/dylovene
	name = "pill bottle (dylovene)"
	desc = "Contains pills used to treat toxic substances in the blood."

	startswith = list(/obj/item/chems/pill/dylovene = 21)
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/adrenaline
	name = "pill bottle (adrenaline)"
	desc = "Contains pills used to stabilize patients."

	startswith = list(/obj/item/chems/pill/adrenaline = 21)
	wrapper_color = COLOR_PALE_BLUE_GRAY

/obj/item/storage/pill_bottle/kelotane
	name = "pill bottle (kelotane)"
	desc = "Contains pills used to treat burns."

	startswith = list(/obj/item/chems/pill/kelotane = 21)
	wrapper_color = COLOR_SUN

/obj/item/storage/pill_bottle/antibiotics
	name = "pill bottle (antibiotics)"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."

	startswith = list(/obj/item/chems/pill/antibiotics = 14)
	wrapper_color = COLOR_PALE_GREEN_GRAY

/obj/item/storage/pill_bottle/painkillers
	name = "pill bottle (painkillers)"
	desc = "Contains pills used to relieve pain."

	startswith = list(/obj/item/chems/pill/painkillers = 14)
	wrapper_color = COLOR_PURPLE_GRAY

//Baycode specific Psychiatry pills.
/obj/item/storage/pill_bottle/antidepressants
	name = "pill bottle (antidepressants)"
	desc = "Mild antidepressant. For use in individuals suffering from depression or anxiety. 15u dose per pill."

	startswith = list(/obj/item/chems/pill/antidepressants = 21)
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/hyperzine
	name = "pill bottle (hyperzine)"
	desc = "Mental stimulant. For use in individuals suffering from ADHD, or general concentration issues. 15u dose per pill."

	startswith = list(/obj/item/chems/pill/hyperzine = 21)
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/assorted
	name = "pill bottle (assorted)"
	desc = "Commonly found on paramedics, these assorted pill bottles contain all the basics."

	startswith = list(
			/obj/item/chems/pill/adrenaline = 6,
			/obj/item/chems/pill/dylovene = 6,
			/obj/item/chems/pill/sugariron = 2,
			/obj/item/chems/pill/painkillers = 2,
			/obj/item/chems/pill/oxygen = 2,
			/obj/item/chems/pill/kelotane = 2,
			/obj/item/chems/pill/antirads
		)
