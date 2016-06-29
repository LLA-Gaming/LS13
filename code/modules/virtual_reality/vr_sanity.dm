/obj/machinery/virtual_reality_manipulator/proc/sanity()
	//Sanity step 1: Make sure all virtual mobs are IN VR
	for(var/X in player_list)
		var/mob/M = X
		if(M.mind && M.mind.IsInVR())
			if(!istype(get_area(M),/area/virtual))
				var/obj/effect/landmark/vr_spawn/entry_point
				for(var/obj/effect/landmark/vr_spawn/S in shuffle(area_contents(get_area(src))))
					entry_point = S
					break
				M.loc = get_turf(entry_point)