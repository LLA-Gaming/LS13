/datum/map_template/virtual/medbay_sim
	name = "Clown Surgery 3000"
	mappath = "_maps/virtualreality/medbay_sim.dmm"

/datum/vr_simulation/medbay_sim
	name = "Clown Surgery 3000"
	desc = "Set your score as the universe's fastest surgeon"
	template_path = /datum/map_template/virtual/medbay_sim
	min_players = 1
	max_players = 1
	var/mob/living/carbon/human/doctor
	var/list/organs_needed = list(/obj/item/organ/tongue,/obj/item/organ/lungs,/obj/item/organ/brain)
	var/time_start
	var/points = 9000
	var/max_time = 3000 // 5 minutes

	EquipCharacters()
		for(var/client/C in players)
			doctor = C.mob

		doctor.equipOutfit(/datum/outfit/job/doctor, 1)

		greet_player(doctor,"Dr. [doctor.real_name]","\n Remove the following organs and place them in the bin. The faster you extract, the higher your score! \n 1) Lungs \n 2) Tongue \n 1) Brain")

	LosePlayer(var/client/C)
		if(C.mob == doctor)
			doctor = null
			End()
		..()

	LoadSim()
		..()
		var/list/all_atoms = virtual.GetSimulationAtoms()
		for(var/obj/effect/landmark/vr_spawn/S in all_atoms)
			if(S.name == "Doctor")
				doctor.loc = get_turf(S)
			if(S.name == "Bin")
				var/turf/T = get_turf(S)
				var/obj/structure/virtual/medbaysim/organ_bin/bin = new /obj/structure/virtual/medbaysim/organ_bin(T)
				bin.sim = src
		reset_time()

	End()
		if(doctor && !organs_needed.len)
			var/datum/vr_simulation/medbay_sim/S = locate(/datum/vr_simulation/medbay_sim) in virtual.simulations
			if(points >= S.highscore_score || !S.highscore_score)
				S.highscore_name = doctor.real_name
				S.highscore_key = doctor.key
				S.highscore_score = points
			virtual.narrate_all("<span class ='deadsay'>[doctor.real_name] has completed [src] with a score of [points]</span>")
		..()

	proc/reset_time()
		time_start = world.time

	proc/check_organ(var/obj/item/organ/O)
		if(O.type in organs_needed)
			organs_needed.Remove(O.type)
			var/negpoints = world.time - time_start
			points -= min(negpoints,max_time)
			if(organs_needed.len)
				reset_time()
			else
				End()



/obj/structure/virtual/medbaysim/organ_bin
	name = "organ bin"
	desc = "place organs here"
	icon = 'icons/obj/crates.dmi'
	icon_state = "largebins"
	density = 1
	var/datum/vr_simulation/medbay_sim/sim


	New()
		..()
		update_icon()

	update_icon()
		..()
		cut_overlays()
		if(contents.len == 0)
			add_overlay("largebing")

	attackby(obj/item/weapon/W, mob/user, params)
		if(sim)
			if(istype(W, /obj/item/organ))
				var/obj/item/organ/O = W
				if(user.drop_item())
					sim.check_organ(O)
					qdel(O)
					update_icon()
					do_animate()

	proc/do_animate()
		playsound(loc, 'sound/effects/bin_open.ogg', 15, 1, -3)
		flick("animate_largebins", src)
		spawn(13)
			playsound(loc, 'sound/effects/bin_close.ogg', 15, 1, -3)
			update_icon()
