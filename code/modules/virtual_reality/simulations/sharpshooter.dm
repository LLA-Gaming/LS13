/datum/map_template/virtual/shooting_range
	name = "Shooting Range"
	mappath = "_maps/virtualreality/shooting_range.dmm"

/datum/vr_simulation/shooting_range
	name = "Sharpshooter"
	desc = "Set your score as the universe's fastest sharpshooter"
	template_path = /datum/map_template/virtual/shooting_range
	min_players = 1
	max_players = 1
	var/mob/living/carbon/human/gunman
	var/list/targets = list()
	var/list/active_targets = list()
	var/points = 0
	var/next_wave_time = -1

	var/clowns = 10
	var/syndicates = 10
	var/aliens = 10


	EquipCharacters()
		for(var/client/C in players)
			gunman = C.mob

		var/datum/outfit/O = new
		O.shoes = /obj/item/clothing/shoes/jackboots
		O.gloves = /obj/item/clothing/gloves/color/black
		O.uniform = /obj/item/clothing/under/syndicate/tacticool
		O.l_pocket = /obj/item/weapon/gun/energy/gun/virtual

		O.equip(gunman)
		qdel(O)

	LosePlayer(var/client/C)
		if(C.mob == gunman)
			gunman = null
			End()
		..()

	LoadSim()
		..()
		var/list/all_atoms = virtual.GetSimulationAtoms()
		for(var/obj/effect/landmark/vr_spawn/S in all_atoms)
			if(S.name == "Gunman")
				gunman.loc = get_turf(S)
				greet_player(gunman, "a sharpshooter", "Civilians: \n [TAB]-50 on stun \n [TAB]-100 on kill \n \n Alien: \n [TAB]-100 on stun \n [TAB]200 on kill \n \n Clown: \n [TAB]100 on stun \n [TAB]-50 on kill \n \n Syndicate \n [TAB]200 on stun \n [TAB]100 on kill \n <u>NOTE: Points are reduced for every second a target is active</u>")
			if(S.name == "Target")
				var/turf/T = get_turf(S)
				for(var/obj/structure/target_stake/stake in T)
					targets.Add(stake)
		next_wave_time = world.time + 50 //5 seconds

	Tick()
		..()
		check_active_targets()
		if(next_wave_time >= 0 && world.time >= next_wave_time)
			next_wave_time = world.time + 100
			if(active_targets.len)
				for(var/obj/structure/virtual/sharpshooter/target/T in active_targets)
					qdel(T)

			var/list/consider = list()
			if(clowns)
				consider.Add(/obj/structure/virtual/sharpshooter/target/clown)
			if(syndicates)
				consider.Add(/obj/structure/virtual/sharpshooter/target/syndicate)
			if(aliens)
				consider.Add(/obj/structure/virtual/sharpshooter/target/alien)

			if(!consider.len)
				End()
				return

			var/goal_target = pick(consider)

			switch(goal_target)
				if(/obj/structure/virtual/sharpshooter/target/clown)
					clowns--
				if(/obj/structure/virtual/sharpshooter/target/syndicate)
					syndicates--
				if(/obj/structure/virtual/sharpshooter/target/alien)
					aliens--

			var/i = 1
			for(var/obj/structure/target_stake/stake in shuffle(targets))
				if(i == 1)
					new goal_target(get_turf(stake), src)
				else
					new /obj/structure/virtual/sharpshooter/target/civilian(get_turf(stake), src)
				i++


	End()
		if(gunman)
			var/datum/vr_simulation/shooting_range/S = locate(/datum/vr_simulation/shooting_range) in virtual.simulations
			if(points >= S.highscore_score || !S.highscore_score)
				S.highscore_name = gunman.real_name
				S.highscore_key = gunman.key
				S.highscore_score = points
			virtual.narrate_all("<span class ='deadsay'>[gunman.real_name] has completed [src] with a score of [points]</span>")
		..()



	proc/check_active_targets()
		if(!active_targets.len) return
		var/worthy_targets = 0
		for(var/obj/structure/virtual/sharpshooter/target/T in active_targets)
			if(T.killed_points < 0 && T.stunned_points <  0)
				continue
			worthy_targets++
		if(!worthy_targets)
			next_wave_time = 0

/obj/structure/virtual/sharpshooter/target
	name = "shooting target"
	desc = "A shooting target."
	icon = 'icons/obj/objects.dmi'
	icon_state = "target_h"
	density = 1
	var/datum/vr_simulation/shooting_range/sim
	var/stunned_points = 0
	var/killed_points = 0
	var/spawn_time
	var/shot = 0

	New(loc, sim_arg)
		..()
		sim = sim_arg
		if(sim)
			spawn_time = world.time
			sim.active_targets.Add(src)

	Destroy()
		if(sim)
			sim.active_targets.Remove(src)
		..()

	bullet_act(obj/item/projectile/P)
		if(sim && !shot)
			shot = 1
			var/points
			if(istype(P,/obj/item/projectile/beam/laser))
				points = killed_points
			if(istype(P,/obj/item/projectile/energy/electrode))
				points = stunned_points
			if(points > 0)
				playsound(src.loc, 'sound/machines/ping.ogg', 50, 1)
				if(world.time - spawn_time != 0)
					points -= world.time - spawn_time
				if(points <= 0)
					playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
					sim.gunman.text2tab("<b>You took too long to shoot [src]</b>")
					qdel(src)
					return
			else
				playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
			sim.points += round(points)
			sim.gunman.text2tab("<b>[sim.points] points!</b>")
			sim.next_wave_time = 0
			qdel(src)

	civilian
		name = "civilian target"
		stunned_points = -50
		killed_points = -100
		icon_state = "target_h"

	alien
		name = "alien target"
		stunned_points = -100
		killed_points = 200
		icon_state = "target_q"

	clown
		name = "clown target"
		stunned_points = 100
		killed_points = -50
		icon_state = "target_c"

		bullet_act(obj/item/projectile/P)
			playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
			..()

	syndicate
		name = "syndicate target"
		icon_state = "target_s"
		stunned_points = 200
		killed_points = 100


/obj/item/weapon/gun/energy/gun/virtual
	name = "virtual energy pistol"
	desc = "A small, virtual, pistol-sized energy gun"
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
	icon_state = "mini"
	item_state = "gun"
	w_class = 2
	cell_type = /obj/item/weapon/stock_parts/cell/infinite
	ammo_x_offset = 2