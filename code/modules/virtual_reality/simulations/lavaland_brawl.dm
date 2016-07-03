/datum/map_template/virtual/lavaland_brawl
	name = "Lavaland Brawl"
	mappath = "_maps/virtualreality/lavaland_brawl.dmm"

/datum/vr_simulation/lavaland_brawl/team
	name = "Lavaland Team Brawl"
	sub_name = "Team Brawl"
	desc = "2 Teams will face off in a deathmatch on lavaland, the surviving team wins"
	team = 1
	min_players = 2
	max_players = 10
	parent_sim = /datum/vr_simulation/lavaland_brawl

/datum/vr_simulation/lavaland_brawl
	name = "Lavaland Brawl"
	desc = "Players will be spawned in a simulated lava land and must kill or be killed. Last one standing wins"
	template_path = /datum/map_template/virtual/lavaland_brawl
	min_players = 2
	max_players = 10
	var/team = 0
	var/list/team1 = list()
	var/list/team2 = list()
	var/list/team1_spawns = list()
	var/list/team2_spawns = list()
	var/list/ffa_spawns = list()

	EquipCharacters()
		var/datum/outfit/O = new
		O.shoes = /obj/item/clothing/shoes/workboots/mining
		O.mask = /obj/item/clothing/mask/gas/explorer
		O.gloves = /obj/item/clothing/gloves/color/black
		O.uniform = /obj/item/clothing/under/rank/miner/lavaland
		O.l_pocket = /obj/item/weapon/reagent_containers/pill/patch/styptic
		O.back = /obj/item/weapon/pickaxe
		O.l_hand = /obj/item/weapon/resonator/upgraded
		O.suit = /obj/item/clothing/suit/hooded/explorer

		for(var/client/C in players)
			var/mob/living/carbon/human/H = C.mob
			O.equip(H)

			var/obj/item/organ/cyberimp/eyes/therms = new /obj/item/organ/cyberimp/eyes/thermals()
			therms.Insert(H)


		qdel(O)

	LosePlayer(var/client/C)
		team1.Remove(C)
		team2.Remove(C)
		..()

	LoadSim()
		..()
		var/list/all_atoms = virtual.GetSimulationAtoms()
		for(var/obj/effect/landmark/vr_spawn/S in all_atoms)
			if(S.name == "Team 1")
				team1_spawns.Add(get_turf(S))
			if(S.name == "Team 2")
				team2_spawns.Add(get_turf(S))
			if(S.name == "FFA")
				ffa_spawns.Add(get_turf(S))

		if(team)
			var/count = 0

			for(var/client/C in shuffle(players))
				if(count % 2 != 0) //if even
					team2.Add(C)
				else
					team1.Add(C)
				count++

			for(var/client/C in team1)
				C.mob.loc = pick(team1_spawns)
				greet_player(C.mob,"on team 1","You are a miner on search for \"minerals\". These \"minerals\" can be used to hunt the other team. Last team alive wins")
				var/mob/living/carbon/human/H = C.mob
				H.wear_suit.color = "#FF0000"
				H.wear_suit.flags |= NODROP
				H.update_inv_wear_suit()
			for(var/client/C in team2)
				C.mob.loc = pick(team2_spawns)
				greet_player(C.mob,"on team 2","You are a miner on search for \"minerals\". These \"minerals\" can be used to hunt the other team. Last team alive wins")
				var/mob/living/carbon/human/H = C.mob
				H.wear_suit.color = "#0000FF"
				H.wear_suit.flags |= NODROP
				H.update_inv_wear_suit()

		else
			for(var/client/C in players)
				C.mob.loc = pick(ffa_spawns)
				greet_player(C.mob,"the lavaland warrior","You are a miner on search for \"minerals\". These \"minerals\" can be used to hunt everyone else. Last person alive wins")


	CheckComplete()
		if(team)
			var/team1_dead = 1
			var/team2_dead = 1
			for(var/client/C in alive)
				if(C in team1)
					team1_dead = 0
				if(C in team2)
					team2_dead = 0

			if(team1_dead)
				winners_text = "[english_list(get_winners(team2))]"
				End()
				return
			if(team2_dead)
				winners_text = "[english_list(get_winners(team1))]"
				End()
				return

		else
			if(!alive.len)
				End()
				return //stalemate
			if(alive.len == 1)
				var/client/C = alive[1]
				winners_text = "[C.mob.real_name]"
				End()
				return

	PlayerCrit(var/mob/living/L)
		return

	proc/get_winners(var/list/C_list)
		var/list/L = list()
		for(var/client/C in C_list)
			L.Add(C.mob.real_name)
		return L

//turf
/turf/closed/mineral/volcanic/weapons
	icon_state = "rock_highchance"
	environment_type = "basalt"
	turf_type = /turf/open/floor/plating/asteroid/basalt/weapons
	baseturf = /turf/open/floor/plating/asteroid/basalt/weapons

/turf/open/floor/plating/asteroid/basalt/weapons/New()
	..()
	var/list/possible_weapons = list(/obj/item/weapon/gun/projectile/automatic/wt550, \
									/obj/item/weapon/gun/projectile/automatic/pistol, \
									/obj/item/weapon/gun/projectile/automatic/toy/pistol, \
									/obj/item/weapon/gun/projectile/automatic/c20r/unrestricted, \
									/obj/item/weapon/gun/projectile/automatic/c20r/toy/unrestricted, \
									/obj/item/weapon/gun/projectile/automatic/m90/unrestricted, \
									/obj/item/weapon/gun/projectile/automatic/proto/unrestricted, \
									/obj/item/weapon/gun/projectile/automatic/l6_saw/unrestricted, \
									/obj/item/weapon/gun/projectile/automatic/l6_saw/toy/unrestricted, \
									/obj/item/weapon/gun/projectile/automatic/sniper_rifle, \
									/obj/item/weapon/gun/projectile/shotgun/boltaction, \
									/obj/item/weapon/gun/projectile/shotgun/riot, \
									/obj/item/weapon/gun/projectile/shotgun/lethal, \
									/obj/item/weapon/gun/projectile/shotgun/automatic/combat, \
									/obj/item/weapon/gun/projectile/shotgun/toy, \
									/obj/item/weapon/gun/projectile/revolver, \
									/obj/item/weapon/gun/projectile/revolver/doublebarrel, \
									/obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised, \
									/obj/item/weapon/shield/riot/roman, \
									/obj/item/weapon/shield/riot, \
									/obj/item/weapon/shield/riot/tele, \
									/obj/item/weapon/shield/energy, \
									/obj/item/weapon/pen/edagger, \
									/obj/item/weapon/melee/energy/sword, \
									/obj/item/weapon/melee/baton/loaded, \
									/obj/item/weapon/melee/classic_baton/telescopic, \
									/obj/item/weapon/kitchen/knife/combat/survival, \
									/obj/item/weapon/twohanded/fireaxe, \
									/obj/item/weapon/twohanded/spear, \
									/obj/item/weapon/reagent_containers/syringe/stimulants, \
									/obj/item/weapon/gun/medbeam, \
									/obj/item/weapon/grenade/syndieminibomb, \
									/obj/item/weapon/gun/energy/kinetic_accelerator/crossbow, \
									/obj/item/weapon/gun/projectile/shotgun/toy/crossbow, \
									/obj/item/weapon/gun/energy/taser, \
									/obj/item/weapon/gun/energy/disabler, \
									/obj/item/weapon/gun/energy/laser, \
									/obj/item/weapon/gun/energy/laser/captain, \
									/obj/item/weapon/gun/energy/gun/advtaser, \
									/obj/item/weapon/gun/energy/gun, \
									/obj/item/weapon/gun/energy/gun/hos, \
									/obj/item/weapon/gun/magic/wand, \
									/obj/item/weapon/gun/magic/wand/fireball, \
									/obj/item/weapon/gun/magic/wand/resurrection, \
									/obj/item/weapon/gun/magic/wand/death, \
									/obj/item/weapon/gun/magic/staff/honk, \
									/obj/item/weapon/gun/magic/staff/healing)
	var/chosen = pick(possible_weapons)
	new chosen(src)