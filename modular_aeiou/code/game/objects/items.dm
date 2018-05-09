//Mirrored make_worn_icon proc to implement worn_overlays

/obj/item/make_worn_icon(var/body_type,var/slot_name,var/inhands,var/default_icon,var/default_layer)
	//Get the required information about the base icon
	var/icon/icon2use = get_worn_icon_file(body_type = body_type, slot_name = slot_name, default_icon = default_icon, inhands = inhands)
	var/state2use = get_worn_icon_state(slot_name = slot_name)
	var/layer2use = get_worn_layer(default_layer = default_layer)

	//Snowflakey inhand icons in a specific slot
	if(inhands && icon2use == icon_override)
		switch(slot_name)
			if(slot_r_hand_str)
				state2use += "_r"
			if(slot_l_hand_str)
				state2use += "_l"

	// testing("[src] (\ref[src]) - Slot: [slot_name], Inhands: [inhands], Worn Icon:[icon2use], Worn State:[state2use], Worn Layer:[layer2use]")

	//Generate the base onmob icon
	var/icon/standing_icon = icon(icon = icon2use, icon_state = state2use)

	if(!inhands)
		apply_custom(standing_icon)		//Pre-image overridable proc to customize the thing
		apply_addblends(icon2use,standing_icon)		//Some items have ICON_ADD blend shaders

	var/image/standing = image(standing_icon)
	standing.alpha = alpha
	standing.color = color
	standing.layer = layer2use

//WORN_OVERLAYS ARE INJECTED HERE//////////////////////////////////

	var/list/worn_overlays = worn_overlays(inhands, icon2use)
	if(worn_overlays && worn_overlays.len)
		standing.overlays.Add(worn_overlays)

///////////////////////////////////////////////////////////////////


	//Apply any special features
	if(!inhands)
		apply_blood(standing)			//Some items show blood when bloodied
		apply_accessories(standing)		//Some items sport accessories like webbing

	//Return our icon
	return standing

//Gives all items worn_overlays

/obj/item/proc/worn_overlays(inhands = FALSE, icon_file)
	. = list()