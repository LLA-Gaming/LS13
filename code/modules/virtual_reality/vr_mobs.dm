/mob/Logout()
	//virtual reality check
	if(mind && mind.virtual)
		mind.virtual.KickOut(src)
	//
	..()

//Ghosts can enter VR at any time
/mob/dead/observer/verb/enter_vr()
	set category = "Ghost"
	set name = "Enter GhostVR"
	if(mind && mind.virtual)
		return 0
	if(virtual_reality_ghosts)
		virtual_reality_ghosts.EnterVR(src.client)
	return 1