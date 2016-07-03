/proc/StartUpVR()
	if(virtual_reality)
		virtual_reality.can_enter = 1
	if(virtual_reality_ghosts)
		virtual_reality_ghosts.can_enter = 1

/proc/ShutDownVR()
	if(virtual_reality)
		virtual_reality.ShutDown()
	if(virtual_reality_ghosts)
		virtual_reality_ghosts.ShutDown()