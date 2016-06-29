/datum/action/leave_vr
	name = "Leave VR"
	button_icon_state = "leave_vr"

/datum/action/leave_vr/Trigger()
	for(var/datum/mind/mind in virtual_reality.vr_minds)
		if(mind.key == owner.key && mind.current)
			var/obj/machinery/virtual_reality_manipulator/vr = mind.virtual
			mind.current.key = usr.key //shove them back in the body first
			vr.KickOut(mind.current.key)
			return
	for(var/datum/mind/mind in virtual_reality_ghosts.vr_minds)
		if(mind.key == owner.key && mind.current)
			var/obj/machinery/virtual_reality_manipulator/vr = mind.virtual
			mind.current.key = usr.key //shove them back in the body first
			vr.KickOut(mind.current.key)
			return
