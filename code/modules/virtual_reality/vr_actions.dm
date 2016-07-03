/datum/action/leave_vr
	name = "Leave VR"
	button_icon_state = "vrgoggles"

/datum/action/leave_vr/Trigger()
	if(owner.mind && owner.mind.virtual)
		owner.mind.virtual.KickOut(owner.client)