/*
* VR Goggles
*/

/obj/item/clothing/glasses/virtual
	name = "virtual reality goggles"
	icon_state = "vrgoggles"

	materials = list(MAT_METAL = 300, MAT_GLASS = 100)

	var/glasses_type = 0 // 0 = Crew | 1 = Perseus
	var/is_in_use = 0
	var/client/using_client
	var/mob/living/carbon/human/original_mob

	perseus/
		name = "perseus virtual reality goggles"
		glasses_type = 1

	examine()
		..()
		// just some fluff
		usr.text2tab("\blue These glasses have an access level of [glasses_type + 1].")

	New()
		..()
		spawn(0)
			if(SSvirtual_reality)
				if(!(src in SSvirtual_reality.goggles))
					SSvirtual_reality.goggles += src

	equipped(var/mob/living/L, var/slot)
		..()

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(!H.glasses)

				if(slot != slot_glasses)
					return 1

				#warn Uncomment when borers are implemented
			//	for(var/mob/living/simple_animal/borer/B in H.contents)
			//		H.text2tab("<span class='notice'>Something prevents you from entering VR.</span>")
			//		return 1

				if(!H.client)
					return 1

				if(H.stat != 0)
					return 1

				if(H.client in SSvirtual_reality.contained_clients)
					L.text2tab("\red Looks like you're already in the VR. Contact the admins/coders.")
					return 1

				if(!is_in_use)
					EnterVR(H)

	dropped(var/mob/living/carbon/human/H)
		..()
		LeaveVR()

	Del()
		SSvirtual_reality.goggles -= src
		LeaveVR()
		..()

	proc/EnterVR(var/mob/living/carbon/human/H)
		if(!H)
			return 0

		if(!SSvirtual_reality)
			return 0

		if(!(src in SSvirtual_reality.goggles))
			SSvirtual_reality.goggles += src

		if(!SSvirtual_reality.HandleVREnter(src, H))
			H.unEquip(src)
			H.put_in_active_hand(src)
			return 0

		is_in_use = 1
		SSvirtual_reality.contained_clients += H.client
		using_client = H.client

		original_mob = H

		var/mob/living/carbon/human/new_mob = SSvirtual_reality.CreateMob(H, glasses_type)

		H.mind.transfer_to(new_mob)

		new_mob.verbs += /mob/proc/LeaveVRVerb

		new_mob.text2tab("\blue <font size=4>Welcome to the Virtual Reality!</font>")
		new_mob.text2tab("\blue <b>To leave the Virtual Reality, press the 'Leave Virtual Reality' verb in the 'Virtual Reality' tab.</b>")

		return

	proc/LeaveVR()
		if(!original_mob)
			return 0

		if(!SSvirtual_reality)
			return 0

		if(!(src in SSvirtual_reality.goggles))
			SSvirtual_reality.goggles += src

		if(!SSvirtual_reality.HandleVRExit(src, using_client))
			return 0

		if(using_client && using_client.mob && using_client.mob.mind)
			var/mob/living/copy
			for(var/mob/living/L in SSvirtual_reality.copies)
				if(L.client == using_client)
					copy = L
					SSvirtual_reality.copies -= L
					break

			using_client.mob.mind.transfer_to(original_mob)

			if(copy)
				qdel(copy)

		is_in_use = 0
		SSvirtual_reality.contained_clients -= using_client
		original_mob = 0
		using_client = 0

		return 1
