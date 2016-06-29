var/global/obj/machinery/virtual_reality_manipulator/virtual_reality
var/global/obj/machinery/virtual_reality_manipulator/virtual_reality_ghosts

/obj/effect/landmark/vr_import
	name = "VR Import"
/obj/effect/landmark/vr_import/ghosts
	name = "VR Import"
/obj/effect/landmark/vr_spawn
	name = "VR Spawn"

/obj/machinery/virtual_reality_manipulator
	name = "virtual reality manipulator"
	icon = 'icons/obj/machines/shuttle_manipulator.dmi'
	icon_state = "holograph_on"
	anchored = 1
	density = 1
	bound_width = 64
	var/vr_area = /area/virtual/vr_dome
	var/ghost_hub = /area/virtual/vr_hub_1
	var/ghost_bar = /area/virtual/vr_bar
	var/vr_loader = /obj/effect/landmark/vr_import
	//
	var/list/mind_storage = list()			//Storage for users minds to safekeep their minds while in VR
	var/list/vr_minds = list() //List of VR minds
	var/list/catatonics = list() //exploit prevention
	var/list/spamprevention = list()
	//
	var/loaded
	//
	var/can_enter = 1

	New()
		..()
		update_icon()
		if(type == /obj/machinery/virtual_reality_manipulator)
			if(!virtual_reality)
				virtual_reality = src

	Destroy()
		ShutDown()
		if(type == /obj/machinery/virtual_reality_manipulator)
			virtual_reality = null
		..()

	update_icon()
		cut_overlays()
		if(loaded)
			icon_state = "holograph_on"
			var/image/hologram_projection = image(icon, "hologram_on")
			hologram_projection.pixel_y = 22
			add_overlay(hologram_projection)
		else
			icon_state = "holograph_off"

	Adjacent(var/atom/neighbor)
		if(neighbor in bounds(1))
			return 1

	process()
		sanity() //make sure people arent exploiting the system

/obj/machinery/virtual_reality_manipulator/ghostvr
	vr_area = /area/virtual/vr_dome_ghost
	vr_loader = /obj/effect/landmark/vr_import/ghosts
	ghost_hub = /area/virtual/vr_hub_ghosts
	ghost_bar = /area/virtual/vr_bar_ghost

	New()
		..()
		if(type == /obj/machinery/virtual_reality_manipulator/ghostvr)
			if(!virtual_reality_ghosts)
				virtual_reality_ghosts = src


	Destroy()
		ShutDown()
		if(type == /obj/machinery/virtual_reality_manipulator/ghostvr)
			virtual_reality_ghosts = null
		..()

/obj/machinery/virtual_reality_manipulator/proc/ShutDown()
	can_enter = 0
	for(var/vr_key in mind_storage)
		KickOut(vr_key)

/obj/machinery/virtual_reality_manipulator/proc/KickOut(var/vr_key)
	for(var/datum/mind/mind in vr_minds)
		if(mind.key == vr_key && mind.current)
			var/obj/machinery/virtual_reality_manipulator/vr = mind.virtual
			mind.current.key = vr_key //shove them back in the body first
			vr.ExitVR(mind.current)

/obj/machinery/virtual_reality_manipulator/proc/ExitVR(var/mob/M)
	vr_minds.Remove(M.mind)
	M.mind = mind_storage[M.key]
	mind_storage.Remove(M.key)
	var/remove_temp = 0
	if(!M.mind.current)
		remove_temp = 1
	var/mob/dead/observer/user = M.ghostize(1)
	if(user.key in catatonics)
		user.can_reenter_corpse = 0
	qdel(M)
	if(remove_temp)
		qdel(user.mind) //remove the temporary mind and restore the ghost to the state he was PRE-VR
		user.started_as_observer = 1 //only reason they would have no current in their mind if they started out observing so return that.
	//return to body if they can
	if((user.mind && user.mind.current && user.mind.current.stat != DEAD) && user.can_reenter_corpse)
		user.reenter_corpse()
	else
		//send ghosts to spawn
		user.loc = pick(latejoin)
	//final safety
	for(var/datum/action/leave_vr/L in user.actions)
		L.Remove(L.owner)

/obj/machinery/virtual_reality_manipulator/proc/EnterVR(var/mob/M)
	if(ticker.current_state != GAME_STATE_PLAYING)
		return
	if(!can_enter)
		return
	if(mind_storage[M.key])
		M.text2tab("You are already in virtual reality.")
		return
	if(M.key in spamprevention)
		if(spamprevention[M.key] > world.time)
			M.text2tab("You need to wait a few seconds before entering Virtual Reality again!")
			return
	spamprevention[M.key] = world.time + 70 // 7 seconds
	//if no mind is available we make one temporarly
	if(isobserver(M))
		var/mob/dead/observer/O = M
		if(!O.can_reenter_corpse)
			catatonics.Add(M.key)
	if(!M.mind)
		var/datum/mind/temp = new /datum/mind(M.key)
		temp.name = M.name
		mind_storage[M.key] = temp
	//store the mind for safekeeping
	else
		mind_storage[M.key] = M.mind
	//get basic clothing
	var/uniform = /obj/item/clothing/under/pj/blue
	var/shoes = /obj/item/clothing/shoes/sneakers/white
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.w_uniform)
			uniform = H.w_uniform.type
		if(H.shoes)
			shoes = H.shoes.type
	//select an entry point
	var/obj/effect/landmark/vr_spawn/entry_point
	for(var/obj/effect/landmark/vr_spawn/S in shuffle(area_contents(get_area(src))))
		entry_point = S
		break
	//Make a body to use
	var/mob/living/carbon/human/H = MakeBody(M.client,get_turf(entry_point))
	H.equip_to_slot_or_del(new uniform(H),slot_w_uniform)
	H.equip_to_slot_or_del(new shoes(H),slot_shoes)
	var/datum/action/leave_vr/L = new
	L.Grant(H)
	return 1


/obj/machinery/virtual_reality_manipulator/proc/MakeBody(var/client/C, var/turf/T, var/duplicate) //duplicating a VR body for minigames, set duplicate to 1
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	C.prefs.copy_to(M, icon_updates=0)
	if(!duplicate)
		M.key = C.key
		M.mind.virtual = src
		vr_minds.Add(M.mind)
		M.mind.name = C.mob.real_name
	M.real_name = C.mob.real_name
	M.name = C.mob.real_name
	M.update_body()
	M.update_hair()
	M.update_body_parts()
	M.dna.update_dna_identity()
	return M