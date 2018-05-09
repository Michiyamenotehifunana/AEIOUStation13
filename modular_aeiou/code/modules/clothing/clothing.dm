/*																																//
//											GLOBALIZED POLYCHROME FOR ALL CLOTHING												//
//																																//
//	NOTICE: POLYCHROME STUFF MUST USE icon_override AND PLACE THEIR OVERLAYS IN BOTH THE ICON AND icon_override FILE			//
//																																//
*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/clothing/
	var/hasprimary = FALSE	//These vars allow you to choose which overlays a clothing has
	var/hassecondary = FALSE
	var/hastertiary = FALSE
	var/primary_color = "#FFFFFF" //RGB in hexcode
	var/secondary_color = "#FFFFFF"
	var/tertiary_color = "#808080"
	var/item_color

/obj/item/clothing/update_icon()	// picks the colored overlays from the ICON file
	..()
	if(hasprimary)	//Checks if the overlay is enabled
		var/mutable_appearance/primary_overlay = mutable_appearance(icon, "[item_color]-primary")	//Automagically picks overlays
		primary_overlay.color = primary_color	//Colors the greyscaled overlay
		add_overlay(primary_overlay)	//Applies the coloured overlay onto the item sprite. but NOT the mob sprite.
	if(hassecondary)
		var/mutable_appearance/secondary_overlay = mutable_appearance(icon, "[item_color]-secondary")
		secondary_overlay.color = secondary_color
		add_overlay(secondary_overlay)
	if(hastertiary)
		var/mutable_appearance/tertiary_overlay = mutable_appearance(icon, "[item_color]-tertiary")
		tertiary_overlay.color = tertiary_color
		add_overlay(tertiary_overlay)

/obj/item/clothing/worn_overlays(inhands, icon_file)	//this is where the main magic happens. Also mandates that ALL polychromic stuff MUST USE icon_override
	. = ..()
	if(hasprimary | hassecondary | hastertiary)
		if(!inhands)	//prevents the worn sprites from showing up if you're just holding them
			if(hasprimary)	//checks if overlays are enabled
				var/mutable_appearance/primary_worn = mutable_appearance(icon_override, "[item_color]-primary")	//automagical sprite selection
				primary_worn.color = primary_color	//colors the overlay
				. += primary_worn	//adds the overlay onto the buffer list to draw on the mob sprite.
			if(hassecondary)
				var/mutable_appearance/secondary_worn = mutable_appearance(icon_override, "[item_color]-secondary")
				secondary_worn.color = secondary_color
				. += secondary_worn
			if(hastertiary)
				var/mutable_appearance/tertiary_worn = mutable_appearance(icon_override, "[item_color]-tertiary")
				tertiary_worn.color = tertiary_color
				. += tertiary_worn

/obj/item/clothing/AltClick(mob/living/user)
	..()
	if(hasprimary | hassecondary | hastertiary)
		var/choice = input(user,"polychromic thread options", "Clothing Recolor") as null|anything in list("[hasprimary ? "Primary Color" : ""]", "[hassecondary ? "Secondary Color" : ""]", "[hastertiary ? "Tertiary Color" : ""]")	//generates a list depending on the enabled overlays
		switch(choice)	//Lets the list's options actually lead to something
			if("Primary Color")
				var/primary_color_input = input(usr,"","Choose Primary Color",primary_color) as color|null	//color input menu, the "|null" adds a cancel button to it.
				if(primary_color_input)	//Checks if the color selected is NULL, rejects it if it is NULL.
					primary_color = sanitize_hexcolor(primary_color_input, desired_format=6, include_crunch=1)	//formats the selected color properly
				update_icon()	//updates the item icon
				user.regenerate_icons()	//updates the worn icon. Probably a bad idea, but it works.
			if("Secondary Color")
				var/secondary_color_input = input(usr,"","Choose Secondary Color",secondary_color) as color|null
				if(secondary_color_input)
					secondary_color = sanitize_hexcolor(secondary_color_input, desired_format=6, include_crunch=1)
				update_icon()
				user.regenerate_icons()
			if("Tertiary Color")
				var/tertiary_color_input = input(usr,"","Choose Tertiary Color",tertiary_color) as color|null
				if(tertiary_color_input)
					tertiary_color = sanitize_hexcolor(tertiary_color_input, desired_format=6, include_crunch=1)
				update_icon()
				user.regenerate_icons()
/*
/obj/item/clothing/Initialize()
	..()
	if(hasprimary | hassecondary | hastertiary)
		update_icon() //Applies the overlays and default colors onto the clothes on spawn.
*/

/obj/item/clothing/under/polychromic	//enables all three overlays to reduce copypasta and defines basic stuff
	name = "polychromic suit"
	desc = "For when you want to show off your horrible colour coordination skills."
	icon = 'modular_aeiou/icons/obj/polyclothes/uniform.dmi'
	icon_override = 'modular_aeiou/icons/mob/polyclothes/uniform.dmi'
	icon_state = "polysuit"
	item_color = "polysuit"
	item_state = "sl_suit"
	hasprimary = TRUE
	hassecondary = TRUE
	hastertiary = TRUE
	primary_color = "#FFFFFF" //RGB in hexcode
	secondary_color = "#FFFFFF"
	tertiary_color = "#808080"