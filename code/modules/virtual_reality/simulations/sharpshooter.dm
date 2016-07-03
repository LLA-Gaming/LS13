/datum/map_template/virtual/shooting_range
	name = "Shooting Range"
	mappath = "_maps/virtualreality/shooting_range.dmm"

/datum/vr_simulation/shooting_range
	name = "Sharpshooter"
	desc = "Set your score as the universe's most quickest and accurate gun shooter"
	//template_path = /datum/map_template/virtual/shooting_range
	min_players = 1
	max_players = 1
	var/mob/living/carbon/human/gunman


	EquipCharacters()
		for(var/client/C in players)
			gunman = C.mob
			gunman.equipOutfit(/datum/outfit/job/detective, 1)
			qdel(gunman.ears)

	LoadSim()
		..()
		var/list/all_atoms = virtual.GetSimulationAtoms()
		for(var/obj/effect/landmark/vr_spawn/S in all_atoms)
			if(S.name == "Gunman")
				gunman.loc = get_turf(S)