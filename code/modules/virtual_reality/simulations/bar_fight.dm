/datum/map_template/virtual/bar_fight
	name = "Bar Fight"
	mappath = "_maps/virtualreality/bar_fight.dmm"

/datum/vr_simulation/bar_fight/drunken
	name = "Drunken Bar Fight"
	sub_name = "Drunk Mode"
	desc = "Everyone has had way too much to drink."
	drunken = 1
	parent_sim = /datum/vr_simulation/bar_fight

/datum/vr_simulation/bar_fight
	name = "Bar Fight"
	desc = "A Simulated experience of your average bar on the station"
	template_path = /datum/map_template/virtual/bar_fight
	min_players = 2
	max_players = 6
	var/drunken = 0
	var/mob/living/carbon/human/assistant_1
	var/mob/living/carbon/human/assistant_2
	var/mob/living/carbon/human/bartender
	var/mob/living/carbon/human/clown
	var/mob/living/carbon/human/mime
	var/mob/living/carbon/human/officer

	EquipCharacters()
		var/i = 1
		for(var/client/C in players)
			switch(i)
				if(1)
					assistant_1 = C.mob
					assistant_1.equipOutfit(/datum/outfit/job/assistant, 1)
					qdel(assistant_1.ears)
					if(drunken)
						assistant_1.drunkenness = 70
						assistant_1.reagents.add_reagent("cryptobiolin", 300)
				if(2)
					assistant_2 = C.mob
					assistant_2.equipOutfit(/datum/outfit/job/assistant, 1)
					qdel(assistant_2.ears)
					if(drunken)
						assistant_2.drunkenness = 70
						assistant_2.reagents.add_reagent("cryptobiolin", 300)
				if(3)
					bartender = C.mob
					bartender.equipOutfit(/datum/outfit/job/bartender, 1)
					qdel(bartender.ears)
					if(drunken)
						bartender.drunkenness = 70
						bartender.reagents.add_reagent("cryptobiolin", 300)
				if(4)
					clown = C.mob
					clown.equipOutfit(/datum/outfit/job/clown, 1)
					qdel(clown.ears)
					if(drunken)
						clown.drunkenness = 70
						clown.reagents.add_reagent("cryptobiolin", 300)
				if(5)
					mime = C.mob
					mime.equipOutfit(/datum/outfit/job/mime, 1)
					qdel(mime.ears)
					if(drunken)
						mime.drunkenness = 70
						mime.reagents.add_reagent("cryptobiolin", 300)
				if(6)
					officer = C.mob
					officer.equipOutfit(/datum/outfit/job/security, 1)
					qdel(officer.ears)
					if(drunken)
						officer.drunkenness = 70
						officer.reagents.add_reagent("cryptobiolin", 300)
			i++


	LosePlayer(var/client/C)
		if(assistant_1 == C.mob)
			assistant_1 = null
		if(assistant_2 == C.mob)
			assistant_2 = null
		if(bartender == C.mob)
			bartender = null
		if(clown == C.mob)
			clown = null
		if(mime == C.mob)
			mime = null
		if(officer == C.mob)
			officer = null
		..()

	LoadSim()
		..()
		var/list/turfs_for_new_area = get_area_turfs(virtual.vr_area)
		var/area/newarea = new virtual.vr_area
		newarea.requires_power = 1
		newarea.lighting_use_dynamic = DYNAMIC_LIGHTING_ENABLED
		newarea.contents += turfs_for_new_area
		newarea.SetDynamicLighting()

		var/list/all_atoms = virtual.GetSimulationAtoms()
		for(var/obj/effect/landmark/vr_spawn/S in all_atoms)
			if(S.name == "Assistant 1" && assistant_1)
				assistant_1.loc = (get_turf(S))
				if(drunken)
					greet_player(assistant_1,slur("an angry assistant"),slur("That other assistant looked at you funny. End his life."))
				else
					greet_player(assistant_1,"an angry assistant","That other assistant looked at you funny. End his life.")
			if(S.name == "Assistant 2" && assistant_2)
				assistant_2.loc = (get_turf(S))
				if(drunken)
					greet_player(assistant_2,slur("an angry assistant"),slur("That other assistant called you stupid and disarmed you. Beat him to death."))
				else
					greet_player(assistant_2,"an angry assistant","That other assistant called you stupid and disarmed you. Beat him to death.")
			if(S.name == "Bartender" && bartender)
				bartender.loc = (get_turf(S))
				if(drunken)
					greet_player(bartender,slur("an angry bartender"),slur("These 2 assistants are fighting in YOUR bar. Break it up and bust some heads."))
				else
					greet_player(bartender,"an angry bartender","These 2 assistants are fighting in YOUR bar. Break it up and bust some heads.")
			if(S.name == "Clown" && clown)
				clown.loc = (get_turf(S))
				if(drunken)
					greet_player(clown,slur("an angry clown"),slur("The bartender looks like an easy target, and shotguns are fun to have!"))
				else
					greet_player(clown,"an angry clown","The bartender looks like an easy target, and shotguns are fun to have!")
			if(S.name == "Mime" && mime)
				clown.loc = (get_turf(S))
				if(drunken)
					greet_player(mime,slur("an angry mime"),slur("The clown is trying to kill the bartender, for reasons no-one seems to know. Kill both of them."))
				else
					greet_player(mime,"an angry mime","The clown is trying to kill the bartender, for reasons no-one seems to know. Kill both of them.")
			if(S.name == "Officer" && officer)
				officer.loc = (get_turf(S))
				if(drunken)
					greet_player(officer,slur("shitcurity"),slur("YOU ARE THE LAW. Bring justice to the bar, and ignore those pesky 'use of force' limitations."))
				else
					greet_player(officer,"shitcurity","YOU ARE THE LAW. Bring justice to the bar, and ignore those pesky 'use of force' limitations.")

	CheckComplete()
		if(!alive.len)
			End()
			return //stalemate
		if(alive.len == 1)
			var/client/C = alive[1]
			winners_text = "[C.mob.real_name]"
			End()
			return