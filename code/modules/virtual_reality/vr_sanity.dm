/obj/machinery/virtual_reality_manipulator/proc/sanity()
	//Sanity step 1: Make sure all virtual mobs are IN VR
	for(var/vr_key in mind_storage)
		for(var/X in player_list)
			var/mob/M = X
			var/skip = 0
			if(M.key != vr_key) skip = 1
			if(skip) continue
			if(M.mind && M.mind.IsInVR())
				if(!istype(get_area(M),ghost_hub) && !istype(get_area(M),ghost_bar))
					var/obj/effect/landmark/vr_spawn/entry_point
					for(var/obj/effect/landmark/vr_spawn/S in shuffle(area_contents(get_area(src))))
						entry_point = S
						break
					if(isobserver(M))
						M.loc = get_turf(entry_point)
					else //If you aren't a ghost you got out on purpose most likely so suffer
						KickOut(M.key)

