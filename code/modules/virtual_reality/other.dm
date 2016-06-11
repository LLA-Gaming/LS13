/*
* Leave VR verb
*/

/mob/proc/LeaveVRVerb()
	set name = "Leave Virtual Reality"
	set category = "Virtual Reality"

	var/obj/item/clothing/glasses/virtual/V = SSvirtual_reality.GetGogglesFromClient(client)
	if(V)
		V.LeaveVR()
	else
		message_admins("\red VR: [key_name(src, 1)] broke the 'Leave Virtual Reality' verb.")
		log_game("VR: [key_name(src)] broke the 'Leave Virtual Reality' verb.")

/*
* VR Headset
*/

/obj/item/device/radio/headset/virtual
	name = "virtual headset"

	prison_radio = 1


/datum/admins/proc/toggle_vr()
	set category = "Server"
	set name = "Toggle Virtual Reality Entering"

	SSvirtual_reality.can_enter = !SSvirtual_reality.can_enter

	message_admins("[key_name(usr, 1)] toggled VR entering [SSvirtual_reality.can_enter ? "On" : "Off"]")
	log_admin("[key_name(usr)] toggled VR entering [SSvirtual_reality.can_enter ? "On" : "Off"]")


/*
* Virtual Reality RCD
*/

/obj/item/weapon/rcd/virtual
	name = "virtual rapid-construction-device (V-RCD)"
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"

	matter = INFINITY
	canRturf = 1
	advanced_airlock_setting = 1

	useResource()
		return 1

	checkResource()
		return 1

/*
* Copy Human Proc
*/


/proc/copy_human(var/mob/living/carbon/human/from, var/mob/living/carbon/human/target, var/copyitems = 1, var/ignore_forbidden = 0, var/copyid = 1)
	var/list/forbidden = list(/obj/item/clothing/mask/facehugger, /obj/item/device/mmi, /obj/item/weapon/storage/backpack/holding, /obj/item/weapon/hand_tele,
							 /obj/item/clothing/suit/armor/reactive, /obj/item/weapon/tank, /obj/item/device/transfer_valve, /obj/item/weapon/surgical_drapes,
							 /obj/item/weapon/bedsheet, /obj/item/weapon/circuitboard, /obj/item/weapon/ore/bluespace_crystal, /obj/item/weapon/tome, /obj/item/weapon/paper,
							 /obj/item/weapon/storage/box/PDAs, /obj/item/weapon/teleportation_scroll, /obj/item/device/radio, /obj/item/seeds/tomato/blue/bluespace,
							 /obj/item/weapon/reagent_containers/food/snacks/grown/tomato/blue/bluespace, /obj/item/weapon/rcd, /obj/item/weapon/grenade/plastic/c4,
							 /obj/item/device/tablet, /obj/item/weapon/implant/tracking, /obj/item/weapon/implant/explosive, /obj/item/weapon/implant/chem,
							 /obj/item/weapon/implant/adrenalin, /obj/item/weapon/implant/emp,/obj/item/weapon/implant/uplink, /obj/item/weapon/implant/freedom,
							 /obj/item/weapon/implant/exile, /obj/item/weapon/implant/health, /obj/item/weapon/c4)

	target.name = from.name
	target.real_name = from.real_name

	target.hair_color = from.hair_color
	target.hair_style = from.hair_style

	target.facial_hair_color = from.facial_hair_color
	target.facial_hair_style = from.facial_hair_style

	target.eye_color = from.eye_color

	target.skin_tone = from.skin_tone

	target.age = from.age
	target.dna.blood_type = from.dna.blood_type

	if(copyitems)
		if(from.w_uniform)
			target.equip_to_slot_or_del(new from.w_uniform.type(target), slot_w_uniform)
		if(from.shoes)
			if(istype(from.shoes, /obj/item/clothing/shoes/combat))
				var/obj/item/clothing/shoes/combat/C = new /obj/item/clothing/shoes/combat()
				new /obj/item/weapon/stun_knife(C)
				C.icon_state = "swatk"
				target.equip_to_slot_or_del(C, slot_shoes)
			else
				target.equip_to_slot_or_del(new from.shoes.type(target), slot_shoes)
		if(from.belt)
			target.equip_to_slot_or_del(new from.belt.type(target), slot_belt)
		if(from.gloves)
			target.equip_to_slot_or_del(new from.gloves.type(target), slot_gloves)
		if(from.glasses)
			if(!istype(from.glasses, /obj/item/clothing/glasses/virtual))
				target.equip_to_slot_or_del(new from.glasses.type(target), slot_glasses)
		if(from.head)
			target.equip_to_slot_or_del(new from.head.type(target), slot_head)
		if(from.ears)
			target.equip_to_slot_or_del(new from.ears.type(target), slot_ears)
		if(from.r_store)
			target.equip_to_slot_or_del(new from.r_store.type(target), slot_r_store)
		if(from.l_store)
			target.equip_to_slot_or_del(new from.l_store.type(target), slot_l_store)
		if(from.s_store)
			target.equip_to_slot_or_del(new from.s_store.type(target), slot_s_store)
		if(from.s_store)
			target.equip_to_slot_or_del(new from.s_store.type(target), slot_s_store)
		if(from.back)
			var/obj/item/weapon/storage/backpack/B = new from.back.type()
			for(var/obj/item/I in from.back)
				if(I.type in forbidden)	continue
				var/obj/item/O = new I.type()
				B.contents += O
			target.equip_to_slot_or_del(B, slot_back)
		if(from.wear_suit)
			target.equip_to_slot_or_del(new from.wear_suit.type(target), slot_wear_suit)
		if(from.wear_mask)
			target.equip_to_slot_or_del(new from.wear_mask.type(target), slot_wear_mask)
		if(from.wear_id)
			if(istype(from.wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/G = from.wear_id
				var/obj/item/device/pda/P = new G.type()
				P.name = G.name
				P.cartridge = new G.cartridge.type()
				P.lock_code = G.lock_code
				P.hidden = G.hidden
				P.toff = G.toff
				P.owner = G.owner
				P.ownjob = G.ownjob
				if(G.id)
					var/obj/item/weapon/card/id/F = G.id
					var/obj/item/weapon/card/id/W = new F.type()
					W.name = F.name
					W.assignment = F.assignment
					W.access = F.access
					W.registered_name = F.registered_name
					W.dorm = F.dorm
					P.id = W
				if(P.pai)
					target.text2tab("\red Sorry, but we can't transfer pAI's.")
				target.equip_to_slot_or_del(P, slot_wear_id)
			else if(istype(from.wear_id, /obj/item/weapon/card/id) || (istype(from.wear_id, /obj/item/device/tablet) && copyid))
				if(!istype(from.wear_id, /obj/item/device/tablet))
					var/obj/item/weapon/card/id/X = from.wear_id
					var/obj/item/weapon/card/id/W = new X.type()
					W.name = X.name
					W.assignment = X.assignment
					W.access = X.access
					W.registered_name = X.registered_name
					W.icon_state = X.icon_state
					target.equip_to_slot_or_del(W, slot_wear_id)
				else
					var/obj/item/device/tablet/G = from.wear_id
					if(G.id)
						var/obj/item/weapon/card/id/I = new G.id.type()
						I.name = G.id.name
						I.assignment = G.id.assignment
						I.access = G.id.access
						I.registered_name = G.id.registered_name
						I.icon_state = G.id.icon_state
						target.equip_to_slot_or_del(I, slot_wear_id)

			else if(istype(from.wear_id, /obj/item/device/tablet))
				var/obj/item/device/tablet/G = from.wear_id
				var/obj/item/device/tablet/P = new G.type()
				P.name = G.name
				P.owner = G.owner
				P.ownjob = G.ownjob
				if(G.core)
					P.core = new G.core.type()
				target.equip_to_slot_or_del(P, slot_wear_id)

		for(var/obj/item/weapon/implant/I in from)
			var/obj/item/weapon/implant/A = new I.type(target)
			A.imp_in = target
			A.implanted = 1
	else
		target.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(target), slot_w_uniform)
		target.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/orange(target), slot_shoes)
//		target.equip_to_slot_or_del(new /obj/item/weapon/book/manual/security_space_law(target), slot_l_hand)
	if(!ignore_forbidden)
		for(var/obj/item/I in target.get_contents())
			for(var/T in forbidden)
				if(istype(I, T))
					del(I)
	target.update_icons()
