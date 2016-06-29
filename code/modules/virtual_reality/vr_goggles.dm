/obj/item/clothing/glasses/virtual
	name = "virtual reality goggles"
	icon_state = "vrgoggles"

	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/glasses/virtual/verb/toggle()
	set category = "Object"
	set name = "Enter Virtual Reality"
	set src in usr

	var/mob/living/carbon/human/H = usr
	if(istype(H))
		if(H.glasses == src)
			if(virtual_reality.EnterVR(usr))
				H.visible_message("[H] flips a switch on the back of [src]")

/obj/item/clothing/glasses/virtual/attack_self()
	toggle()

/obj/item/clothing/glasses/virtual/Destroy()
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		virtual_reality.KickOut(H.mind.key)
	..()

/obj/item/clothing/glasses/virtual/dropped(mob/living/carbon/human/user)
	..()
	virtual_reality.KickOut(user.mind.key)