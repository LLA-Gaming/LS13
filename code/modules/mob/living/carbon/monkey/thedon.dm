/mob/living/carbon/monkey/thedon
	name = "The Don"
	voice_name = "The Don"
	icon = 'icons/mob/monkey.dmi'
	icon_state = "thedon1"

/mob/living/carbon/monkey/thedon/update_icons()
	overlays.Cut()
	icon_state = "thedon1"
	for(var/image/I in overlays_standing)
		overlays += I

/mob/living/carbon/monkey/thedon/can_equip(obj/item/I, slot, disable_warning = 0)
	switch(slot)
		if(slot_l_hand)
			if(l_hand)
				return 0
			return 1
		if(slot_r_hand)
			if(r_hand)
				return 0
			return 1
		if(slot_wear_mask)
			if(wear_mask)
				return 0
			if( !(I.slot_flags & SLOT_MASK) )
				return 0
			return 1
		if(slot_head)
			return 0
		if(slot_back)
			if(back)
				return 0
			if( !(I.slot_flags & SLOT_BACK) )
				return 0
			return 1
	return 0 //Unsupported slot
