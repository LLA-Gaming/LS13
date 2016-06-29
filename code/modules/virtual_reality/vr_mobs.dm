//Ability to leave VR always available no matter what mob you are in

/mob/Login()
	..()
	if(mind && mind.virtual)
		var/datum/action/leave_vr/L = new
		L.Grant(src)
		if(isobserver(src)) //Send us where we belong
			var/obj/effect/landmark/vr_spawn/entry_point
			for(var/obj/effect/landmark/vr_spawn/S in shuffle(area_contents(get_area(mind.virtual))))
				entry_point = S
				break
			loc = get_turf(entry_point)

/mob/Logout()
	for(var/datum/action/leave_vr/L in actions)
		L.Remove(L.owner)
	..()


//Ghosts can enter VR at any time
/mob/dead/observer/verb/enter_vr()
	set category = "Ghost"
	set name = "Enter GhostVR"
	if(virtual_reality_ghosts)
		virtual_reality_ghosts.EnterVR(src)
	return 1