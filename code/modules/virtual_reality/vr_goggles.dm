var/global/list/vr_goggles = list()

/obj/item/clothing/glasses/virtual
	name = "virtual reality goggles"
	icon_state = "vrgoggles"
	var/activated = 0

	actions_types = list(/datum/action/item_action/toggle)

	New()
		..()
		vr_goggles.Add(src)

	Destroy()
		vr_goggles.Remove(src)
		..()

	pickup()
		pixel_x = 0
		pixel_y = 0
		activated = 1
		..()

	proc/alert_self(var/msg)
		var/mob/living/L = null
		if(src.loc && isliving(src.loc))
			L = src.loc
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		audible_message("\icon[src] *beep*", null, 3)
		if(L)
			L.text2tab("\icon[src] [msg]")

/obj/item/clothing/glasses/virtual/verb/toggle()
	set category = "Object"
	set name = "Enter Virtual Reality"
	set src in usr

	activated = 1
	var/mob/living/carbon/human/H = usr
	if(istype(H))
		if(H.glasses == src)
			if(!H.stat)
				if(virtual_reality.EnterVR(usr.client))
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


//box of 4 VR headsets
/obj/item/weapon/storage/box/vr_goggles
	name = "virtual reality kits"
	desc = "A box of virtual reality headsets."
	icon = 'icons/obj/storage.dmi'
	icon_state = "pda"

/obj/item/weapon/storage/box/vr_goggles/New()
	..()
	new /obj/item/clothing/glasses/virtual(src)
	new /obj/item/clothing/glasses/virtual(src)
	new /obj/item/clothing/glasses/virtual(src)
	new /obj/item/clothing/glasses/virtual(src)