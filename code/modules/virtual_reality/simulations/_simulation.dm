/datum/vr_simulation
	var/name = "vr_simulation"
	var/sub_name = "sub_vr_name"
	var/desc = "desc_not_found"
	var/parent_sim
	var/list/children_sims = list()
	var/min_players = 1
	var/max_players = 1
	var/template_path
	var/datum/map_template/virtual/template
	var/obj/machinery/virtual_reality_manipulator/virtual
	var/area/simulation_area
	var/list/players = list()
	var/list/alive = list()
	var/list/dead = list()
	var/end_time = 6000 // 10 minutes
	var/winners_text

	New()
		..()
		template = new template_path

	proc/LoadSim()
		if(end_time >= 0)
			end_time = world.time + end_time
		return

	proc/EquipCharacters()
		return

	proc/LosePlayer(var/client/C)
		alive.Remove(C)
		dead.Remove(C)
		players.Remove(C)
		PlayerDeath(C)

	proc/Tick()
		if(world.time >= end_time)
			End(1)
		listclearnulls(alive)
		listclearnulls(dead)
		listclearnulls(players)
		if(alive.len <= 1)
			End()

	proc/CheckComplete()
		return

	proc/End(var/abrupt=0)
		virtual.ClearSimulation()
		if(!abrupt)
			if(winners_text)
				virtual.wins++
				var/obj/item/weapon/reagent_containers/food/drinks/trophy/gold_cup/victory = new /obj/item/weapon/reagent_containers/food/drinks/trophy/gold_cup(virtual)
				for(var/obj/structure/table/abductor/A in shuffle(get_area_all_atoms(virtual.vr_hub)))
					victory.loc = get_turf(A)
				victory.name = "Victory Cup #[virtual.wins]"
				victory.desc = "Awarded to [winners_text] in [name]"
				virtual.narrate_all("<span class ='deadsay'>[src] came to an end. The winner(s): [winners_text]</span>")
				victory.pixel_x = rand(-16,16)
				victory.pixel_y = rand(-16,16)
				victory.layer = 7
			else
				virtual.narrate_all("<span class ='deadsay'>[src] came to an end.</span>")
		else
			virtual.narrate_all("<span class ='deadsay'>[src] came to an abrupt end, time ran out!</span>")

	proc/narrate_players(var/msg)
		for(var/client/C in players)
			C.text2tab("<b>[msg]</b>")

	proc/greet_player(var/client/C,var/title,var/msg)
		C.text2tab("<b><span class='userdanger'>You are [title].</span></b>")
		C.text2tab("<b>[msg]</b>")

	proc/PlayerBirth(var/client/C)
		alive.Add(C)
		dead.Remove(C)

	proc/PlayerDeath(var/client/C)
		alive.Remove(C)
		dead.Add(C)
		CheckComplete()

	proc/PlayerCrit(var/mob/living/L)
		L.death()