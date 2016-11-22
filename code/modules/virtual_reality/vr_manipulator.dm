var/global/obj/machinery/virtual_reality_manipulator/virtual_reality
var/global/obj/machinery/virtual_reality_manipulator/virtual_reality_ghosts
var/global/list/vr_loaders = list()

/obj/effect/landmark/vr_import
	name = "VR Import"
	burn_state = LAVA_PROOF
	New()
		..()
		vr_loaders.Add(src)
	Destroy()
		return QDEL_HINT_LETMELIVE
/obj/effect/landmark/vr_import/ghosts
	name = "VR Import"
/obj/effect/landmark/vr_spawn
	name = "VR Spawn"

/obj/machinery/virtual_reality_manipulator
	name = "virtual reality manipulator"
	desc = "a mystical machine that can shape the surface of virtual reality"
	icon = 'icons/obj/machines/shuttle_manipulator.dmi'
	icon_state = "holograph_on"
	anchored = 1
	density = 1
	bound_width = 64
	var/wins = 0
	var/load_time
	var/datum/vr_simulation/selected
	var/vr_area = /area/virtual/vr_dome
	var/vr_hub = /area/virtual/vr_hub_1
	var/vr_bar = /area/virtual/vr_bar
	var/vr_loader = /obj/effect/landmark/vr_import
	//
	var/list/contained_clients = list()
	var/list/mind_storage = list()			//Storage for users minds to safekeep their minds while in VR
	var/list/vr_minds = list() //List of VR minds
	var/list/catatonics = list() //exploit prevention
	var/list/spamprevention = list()
	//
	var/datum/vr_simulation/loaded
	//
	var/list/simulations = list()
	//
	var/can_enter = 1

	New()
		..()
		update_icon()
		if(type == /obj/machinery/virtual_reality_manipulator)
			if(!virtual_reality)
				virtual_reality = src
				var/list/children = list()
				for(var/type in typesof(/datum/vr_simulation) - /datum/vr_simulation)
					var/datum/vr_simulation/simulation = new type()
					if(!simulation.template_path) continue
					simulation.virtual = src
					if(simulation.parent_sim)
						children.Add(simulation)
					else
						simulations.Add(simulation)
				for(var/datum/vr_simulation/S_child in children)
					for(var/datum/vr_simulation/S_parent in simulations)
						if(S_child.parent_sim == S_parent.type)
							S_parent.children_sims.Add(S_child)



	Destroy()
		if(virtual_reality == src)
			ShutDown()
			can_enter = 1
			return QDEL_HINT_LETMELIVE
		else
			..()


	update_icon()
		cut_overlays()
		if(loaded || selected)
			icon_state = "holograph_on"
			var/image/hologram_projection = image(icon, "hologram_on")
			hologram_projection.pixel_y = 22
			hologram_projection.layer = 5
			add_overlay(hologram_projection)
		else
			icon_state = "holograph_off"

	Adjacent(var/atom/neighbor)
		if(neighbor in bounds(1))
			return 1

	process()
		if(selected)
			if(world.time >= load_time)
				LoadSimulation(selected)
				selected = null
		if(loaded)
			loaded.Tick()

	interact(var/mob/living/carbon/human/user)
		if(virtual_reality != src && virtual_reality_ghosts != src)
			return
		if(!ishuman(user))
			return
		if(!user.mind)
			return
		if(!user.mind.virtual)
			return
		var/dat

		dat += "<h3>Virtual Reality Manipulator</h3>"
		if(loaded)
			dat += "In Progress:"
			dat += "<div class='statusDisplay'>"
			dat += "<u>[loaded.name]</u><br>"
			dat += "[loaded.desc]<br><br>"
			dat += "<A href='?src=\ref[src];observesim=1'>Observe</A><br>"
			dat += "<u>Alive:</u><br>"
			for(var/client/C in loaded.alive)
				if(ishuman(C.mob))
					dat += "[C.mob:real_name]<br>"
				else
					dat += "[C.mob]<br>"
			dat += "<br><u>Dead:</u><br>"
			for(var/client/C in loaded.dead)
				dat += "[C.mob]<br>"
			dat += "</div>"
		else if(selected)
			dat += "Loading:"
			dat += "<div class='statusDisplay'>"
			dat += "<u>[selected.name]</u><br>"
			dat += "[selected.desc]<br>"
			dat += "Players: [selected.min_players] to [selected.max_players]<br>"
			dat += "</div>"
		else
			for(var/datum/vr_simulation/S in sortNames(simulations))
				dat += "<div class='statusDisplay'>"
				dat += "<u>[S.name]</u><br>"
				dat += "[S.desc]<br>"
				if(S.max_players > 1)
					dat += "Players: [S.min_players] to [S.max_players]<br>"
				else
					dat += "Singleplayer<br>"
				if(S.highscore_score)
					dat += "Highscore - [S.highscore_name]: [S.highscore_score]<br>"
				dat += "<A href='?src=\ref[src];loadsim=\ref[S]'>Load Simulation</A><br>"
				if(S.children_sims.len)
					dat += "Sub Modes: "
					for(var/datum/vr_simulation/S_child in S.children_sims)
						dat += "<A href='?src=\ref[src];loadsim=\ref[S_child]'>[S_child.sub_name]</A> "

				dat += "</div>"

		var/datum/browser/popup = new(user, "vr_manipulator", name, 400, 500)
		popup.set_content(dat)
		popup.open()

	Topic(href, href_list)
		var/mob/user = usr
		if(href_list["join"])
			var/mob/dead/observer/ghost = usr
			if(istype(ghost))
				ghost.enter_vr()
		if(..())
			return
		if(virtual_reality != src && virtual_reality_ghosts != src)
			return
		if(!ishuman(user))
			return
		if(!user.mind)
			return
		if(!user.mind.virtual)
			return
		if(href_list["observesim"])
			if(loaded && loaded.players.len)
				var/mob/M = pick(loaded.players)
				loaded.observers.Add(user.client)
				MakeMob(user.client, /mob/camera/virtual_observer, get_turf(M))
				qdel(user)

		if(!loaded && !selected)
			if(href_list["loadsim"])
				selected = locate(href_list["loadsim"])
				if(istype(selected))
					ClearSimulation()
					load_time = world.time + 300
					var/obj/effect/landmark/vr_import/I = locate(vr_loader) in vr_loaders
					selected.template.load(get_turf(I))
					if(selected.max_players > 1)
						narrate_all("<span class ='deadsay'>[selected.name] is now loading, gather around the manipulator to participate. ETA: 30 seconds</span>")
						attract_players("[selected.name] is loading in virtual reality! You have 30 seconds to join!")
					else
						LoadSimulation(selected, list(user.client))
						selected = null
						load_time = 0
					update_icon()


	attack_ghost(mob/user)
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			ghost.enter_vr()


	proc/LoadSimulation(var/datum/vr_simulation/simulation, var/list/prepicked_players)
		loaded = new simulation.type
		loaded.virtual = src

		if(!prepicked_players)
			for(var/client/C in contained_clients)
				if(istype(get_area(C.mob),vr_hub))
					loaded.players.Add(C)
		else
			loaded.players = prepicked_players

		if(loaded.players.len < loaded.min_players)
			narrate_all("<span class ='deadsay'>Not enough players to start [loaded.name], please try again.</span>")
			ClearSimulation()
			selected = null
			update_icon()
			return

		while(loaded.players.len > loaded.max_players)
			loaded.players.Remove(pick(loaded.players))

		for(var/client/C in loaded.players)
			var/mob/living/carbon/human/oldbody = C.mob
			var/mob/living/carbon/human/newbody = MakeBody(C, get_turf(src), 1)
			C.mob.mind.transfer_to(newbody,1)
			for(var/obj/item/W in oldbody)
				oldbody.unEquip(W)
			qdel(oldbody)
			loaded.PlayerBirth(C)

		loaded.EquipCharacters()

		loaded.LoadSim()

		update_icon()

	proc/ClearSimulation()
		var/list/all_atoms = GetSimulationAtoms()

		//reset objs and mobs
		if(loaded)
			for(var/client/C in loaded.players)
				if(C.mob.mind && C.mob.mind.virtual)
					SendToVRHub(C.mob)
			for(var/client/C in loaded.observers)
				if(C.mob.mind && C.mob.mind.virtual)
					SendToVRHub(C.mob)
		qdel(loaded)
		loaded = null
		for(var/atom/movable/X in all_atoms)
			if(istype(X, /obj/effect/landmark/vr_import))
				continue
			if(istype(X,/atom/movable/light))
				var/atom/movable/light/L = X
				L.alpha = 0
				continue
			if(ismob(X))
				if(isobserver(X))
					continue
			qdel(X)
		//reset turfs
		for(var/turf/T in get_area_turfs(vr_area))
			T.ChangeTurf(/turf/closed/indestructible/void)

		//reset area
		var/area/newarea = new vr_area
		newarea.contents += get_area_turfs(vr_area)

		update_icon()

	proc/GetSimulationAtoms()
		var/list/all_atoms = get_area_all_atoms(vr_area)
		return all_atoms

	proc/narrate_all(var/msg)
		for(var/client/C in contained_clients)
			C.text2tab(msg)

	proc/attract_players(var/msg)
		for(var/obj/item/clothing/glasses/virtual/V in vr_goggles)
			if(V.activated)
				V.alert_self(msg)

	proc/SendToVRHub(var/mob/M)
		if(M.client)
			var/obj/effect/landmark/vr_spawn/entry_point
			for(var/obj/effect/landmark/vr_spawn/S in shuffle(area_contents(get_area(src))))
				entry_point = S
				break
			//get basic clothing
			var/uniform = /obj/item/clothing/under/pj/blue
			var/shoes = /obj/item/clothing/shoes/sneakers/white
			var/datum/mind/mind = mind_storage[M.key]
			if(type != /obj/machinery/virtual_reality_manipulator/ghostvr)
				if(mind && ishuman(mind.current))
					var/mob/living/carbon/human/H = mind.current
					if(H.w_uniform)
						uniform = H.w_uniform.type
					if(H.shoes)
						shoes = H.shoes.type
			var/mob/living/carbon/human/newbody = MakeBody(M:client, get_turf(entry_point), 1)
			newbody.real_name = mind.name
			newbody.name = mind.name
			newbody.status_flags = GODMODE|CANPUSH
			newbody.equip_to_slot_or_del(new uniform(newbody),slot_w_uniform)
			newbody.equip_to_slot_or_del(new shoes(newbody),slot_shoes)
			newbody.w_uniform.flags |= NODROP
			newbody.shoes.flags |= NODROP
			M:mind.transfer_to(newbody, 1)
			//dont need this old body anymore
			var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
			sparks.set_up(1, 1, M)
			sparks.start()
			qdel(M)
			//
			return newbody
		else
			qdel(M)

/obj/machinery/virtual_reality_manipulator/ghostvr
	vr_area = /area/virtual/vr_dome_ghost
	vr_loader = /obj/effect/landmark/vr_import/ghosts
	vr_hub = /area/virtual/vr_hub_ghosts
	vr_bar = /area/virtual/vr_bar_ghost

	New()
		..()
		if(type == /obj/machinery/virtual_reality_manipulator/ghostvr)
			if(!virtual_reality_ghosts)
				virtual_reality_ghosts = src
				var/list/children = list()
				for(var/type in typesof(/datum/vr_simulation) - /datum/vr_simulation)
					var/datum/vr_simulation/simulation = new type()
					if(!simulation.template_path) continue
					simulation.virtual = src
					if(simulation.parent_sim)
						children.Add(simulation)
					else
						simulations.Add(simulation)
				for(var/datum/vr_simulation/S_child in children)
					for(var/datum/vr_simulation/S_parent in simulations)
						if(S_child.parent_sim == S_parent.type)
							S_parent.children_sims.Add(S_child)



	Destroy()
		if(virtual_reality_ghosts == src)
			ShutDown()
			can_enter = 1
			return QDEL_HINT_LETMELIVE
		else
			..()

	attract_players(var/msg)
		var/image/I = image(icon= 'icons/mob/actions.dmi',icon_state = "vrgoggles")
		notify_ghosts("[msg]", enter_link="<a href=?src=\ref[src];join=1>Join Virtual Reality!", source = src, alert_overlay = I, action=NOTIFY_ATTACK)

/obj/machinery/virtual_reality_manipulator/proc/ShutDown()
	can_enter = 0
	ClearSimulation()
	for(var/client/C in contained_clients)
		KickOut(C)

/obj/machinery/virtual_reality_manipulator/proc/KickOut(var/client/C)
	if(loaded)
		if(!C || ismob(C))
			listclearnulls(loaded.alive)
			listclearnulls(loaded.dead)
			listclearnulls(loaded.players)
			listclearnulls(loaded.observers)
			loaded.CheckComplete()
		else
			loaded.LosePlayer(C)
	ExitVR(C)

/obj/machinery/virtual_reality_manipulator/proc/ExitVR(var/client/C)
	var/mob/M
	if(ismob(C))
		M = C
	else
		if(!(C in contained_clients))
			return
		contained_clients.Remove(C)
		M = C.mob
	if(!loaded)
		for(var/obj/item/W in M)
			M.unEquip(W)
	vr_minds.Remove(M.mind)
	M.mind = mind_storage[M.key]
	mind_storage.Remove(M.key)
	var/remove_temp = 0
	if(M.mind)
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

/obj/machinery/virtual_reality_manipulator/proc/EnterVR(var/client/C)
	if(!C)
		return
	if(ticker.current_state != GAME_STATE_PLAYING)
		return
	if(!can_enter)
		return
	if(mind_storage[C.key])
		C.text2tab("You are already in virtual reality.")
		return
	if(C.key in spamprevention)
		if(spamprevention[C.key] > world.time)
			C.text2tab("You need to wait a few seconds before entering Virtual Reality again!")
			return
	spamprevention[C.key] = world.time + 70 // 7 seconds
	//if no mind is available we make one temporarly
	if(isobserver(C.mob))
		var/mob/dead/observer/O = C.mob
		if(!O.can_reenter_corpse)
			catatonics.Add(C.key)
	if(!C.mob.mind)
		var/datum/mind/temp = new /datum/mind(C.key)
		temp.name = C.mob.real_name
		mind_storage[C.key] = temp
	//store the mind for safekeeping
	else
		mind_storage[C.key] = C.mob.mind
	//get basic clothing
	var/uniform = /obj/item/clothing/under/pj/blue
	var/shoes = /obj/item/clothing/shoes/sneakers/white
	if(ishuman(C.mob))
		var/mob/living/carbon/human/H = C.mob
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
	var/mob/living/carbon/human/H = MakeBody(C,get_turf(entry_point))
	H.equip_to_slot_or_del(new uniform(H),slot_w_uniform)
	H.equip_to_slot_or_del(new shoes(H),slot_shoes)
	H.w_uniform.flags |= NODROP
	H.shoes.flags |= NODROP
	//finally add to contained clients
	contained_clients.Add(C)
	return 1


/obj/machinery/virtual_reality_manipulator/proc/MakeBody(var/client/C, var/turf/T, var/duplicate) //duplicating a VR body for minigames, set duplicate to 1
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(T)
	var/perseus
	if(C.mob.mind && C.mob.mind.IsPerseus())
		perseus = C.mob.mind.GetPerseusName()
	C.prefs.copy_to(M, icon_updates=0)
	if(!duplicate)
		M.key = C.key
		M.mind.virtual = src
		vr_minds.Add(M.mind)
		M.mind.name = C.mob.real_name
		M.status_flags = GODMODE|CANPUSH
	if(perseus)
		M.real_name = perseus
		M.name = perseus
		M.hair_style = "Bald"
		M.facial_hair_style = "Shaved"
		M.skin_tone = "Albino"
		M.gender = PLURAL
	else
		M.real_name = C.mob.real_name
		M.name = C.mob.real_name
	M.update_body()
	M.update_hair()
	M.update_body_parts()
	M.dna.update_dna_identity()
	var/datum/action/leave_vr/L = new
	L.Grant(M)
	return M

/obj/machinery/virtual_reality_manipulator/proc/MakeMob(var/client/C, var/mobtype, var/turf/T)
	var/mob/newmob = new mobtype(T)
	newmob.name = C.mob.name
	newmob.real_name = C.mob.real_name
	C.mob.mind.transfer_to(newmob,1)
	var/datum/action/leave_vr/L = new
	L.Grant(newmob)
	return newmob

/obj/machinery/virtual_reality_manipulator/proc/VirtualDeath(var/mob/living/L)
	if(loaded)
		if(loaded.PlayerDeath(L.client))
			return
	var/mob/living/carbon/human/H = SendToVRHub(L)
	if(H)
		var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
		sparks.set_up(1, 1, H)
		sparks.start()
		H.text2tab("<span class='userdanger'>You have virtually died!</span>")
		H.text2tab("<b>You will not be able to respawn into the current simulation</b>")

/obj/machinery/virtual_reality_manipulator/proc/VirtualCrit(var/mob/living/L)
	if(loaded)
		loaded.PlayerCrit(L)