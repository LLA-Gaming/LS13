//Mode
/datum/map_template/virtual/solidagents
	name = "Solid Agent"
	mappath = "_maps/virtualreality/solidagents.dmm"

/datum/vr_simulation/solidagents
	name = "Solid Agent"
	desc = "A single agent must infiltrate the Donk Co. warehouse and steal the formula for Donk Pockets."
	template_path = /datum/map_template/virtual/solidagents
	min_players = 2
	max_players = 3
	var/mob/living/carbon/human/guard_1
	var/mob/living/carbon/human/guard_2
	var/mob/living/carbon/human/solid
	var/list/exits = list()
	var/list/disk_spawns = list()
	var/list/guard_spawns = list()
	var/list/boxes = list()
	var/list/disks = list()
	var/target_type
	var/target_name

	Tick()
		..()
		for(var/obj/item/weapon/virtual/solidagent/disk/D in disks)
			if(qdeleted(D)) continue
			if(!D.active) continue
			if(get_turf(D) == D.disk_spawn) continue
			if(D.loc == solid) continue
			qdel(D)


	EquipCharacters()
		var/datum/outfit/solidagent/solid_outfit = new
		var/datum/outfit/donkoperative/guard_outfit = new
		for(var/client/C in shuffle(players))
			if(!solid)
				solid = C.mob
				solid_outfit.equip(solid)
				continue
			if(!guard_1)
				guard_1 = C.mob
				guard_outfit.equip(guard_1)
				guard_1.shoes.flags |= NODROP
				continue
			if(!guard_2)
				guard_2 = C.mob
				guard_outfit.equip(guard_2)
				guard_2.shoes.flags |= NODROP
				continue
		qdel(solid_outfit)
		qdel(guard_outfit)

	LosePlayer(var/client/C)
		if(guard_1 == C.mob)
			guard_1 = null
		if(guard_2 == C.mob)
			guard_2 = null
		if(solid == C.mob)
			solid = null
		..()

	CheckComplete()
		if(!solid || !solid.client || solid.stat == DEAD)
			End()

	LoadSim()
		..()
		var/list/disk_types = list(/obj/item/weapon/virtual/solidagent/disk/greendisk, /obj/item/weapon/virtual/solidagent/disk/bluedisk, /obj/item/weapon/virtual/solidagent/disk/reddisk, /obj/item/weapon/virtual/solidagent/disk/yellowdisk,/obj/item/weapon/virtual/solidagent/disk/whitedisk)
		var/list/all_atoms = virtual.GetSimulationAtoms()
		for(var/S in all_atoms)
			if(istype(S,/obj/effect/landmark/vr_spawn))
				if(S:name == "Disk")
					disk_spawns.Add(get_turf(S))
					var/D = pick_n_take(disk_types)
					var/obj/item/weapon/virtual/solidagent/disk/disk = new D(get_turf(S))
					disk.sim = src
					disks.Add(disk)

				if(S:name == "Guard")
					guard_spawns.Add(get_turf(S))
				if(S:name == "Escape")
					exits.Add(get_turf(S))
			if(istype(S,/obj/structure/closet/cardboard))
				boxes.Add(S)

		var/obj/item/weapon/virtual/solidagent/disk/T = pick(disks)
		target_name = T.name
		target_type = T.type

		if(guard_1)
			guard_1.loc = pick(guard_spawns)
			greet_player(guard_1,"a Donk Co. Warehouse Guard","You have been assigned to protect the formula for Donk Pockets. However, as a 'hilarious joke', your employer hasn't told you which of the FIVE disks actually contains the formula. 'Good luck, honk!'")
		if(guard_2)
			guard_2.loc = pick(guard_spawns - guard_1.loc)
			greet_player(guard_2,"a Donk Co. Warehouse Guard","You have been assigned to protect the formula for Donk Pockets. However, as a 'hilarious joke', your employer hasn't told you which of the FIVE disks actually contains the formula. 'Good luck, honk!'")
		if(solid)
			for(var/obj/structure/closet/cardboard/C in shuffle(boxes))
				solid.loc = C
			greet_player(solid,"Solid Sneak","\n Remember your CQC. Your mission is as follows: \n 1) Extract the Donk Pocket formula located on [target_name] \n 2) Escape alive via the Escape ATVs located outside the warehouse")


	PlayerDeath(var/client/C)
		if(C.mob != solid)
			var/mob/living/carbon/human/oldbody = C.mob
			var/mob/living/carbon/human/H = virtual.MakeBody(C, pick(guard_spawns), 1)
			C.mob.mind.transfer_to(H,1)
			var/datum/outfit/donkoperative/guard_outfit = new
			guard_outfit.equip(H)
			var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
			sparks.set_up(1, 1, oldbody)
			sparks.start()
			if(oldbody == guard_1)
				guard_1 = H
				guard_1.shoes.flags |= NODROP
			if(oldbody == guard_2)
				guard_2 = H
				guard_2.shoes.flags |= NODROP
			qdel(oldbody)
			CheckComplete()
			return 1
		..()

	proc/lock_down()
		for(var/turf/T in exits)
			var/obj/machinery/door/airlock/A = locate(/obj/machinery/door/airlock) in T
			if(A)
				var/obj/machinery/door/airlock/newA = new A.type(T)
				qdel(A)
				if(newA)
					newA.bolt()

	proc/intruder_alert(var/msg)
		for(var/client/C in alive)
			if(C.mob == solid)
				continue
			C << sound('sound/machines/chime.ogg')
			C.text2tab(msg)

			var/image/I
			I = image('icons/obj/closet.dmi', C.mob, "cardboard_special", C.mob.layer+1)
			flick_overlay(I,list(C),8)
			I.alpha = 0
			animate(I, pixel_z = 32, alpha = 255, time = 5, easing = ELASTIC_EASING)


//Items

/obj/item/weapon/virtual/solidagent/disk/
	name = "disk"
	icon = 'icons/obj/module.dmi'
	desc = "this disk holds classified company information and you should not touch it."
	w_class = 5
	anchored = 1
	var/active = 0
	var/dontcheck = 0
	var/datum/vr_simulation/solidagents/sim
	var/turf/disk_spawn

	New()
		..()
		disk_spawn = loc

	attack_hand(mob/living/user)
		if(!sim)
			anchored = 0
			return ..()
		if(user.client && user == sim.solid)
			anchored = 0
			return ..()
		else
			usr.text2tab("You are under strict orders to never touch this disk")

	pickup()
		if(!sim)
			return ..()
		if(!active)
			sim.intruder_alert("<span class='userdanger'>ALERT [src] has been taken!</span>")
			sim.lock_down()
			active = 1

	Destroy()
		if(sim && !qdeleted(sim) && !dontcheck)
			sim.disks.Remove(src)
			sim.intruder_alert("<span class='userdanger'>[src] has returned to its starting point</span>")
			var/obj/item/weapon/virtual/solidagent/disk/S = new src.type(disk_spawn)
			sim.disks.Add(S)
			S.sim = sim
			S.disk_spawn = S.disk_spawn
		..()

	proc/check_disk()
		if(istype(src,sim.target_type))
			sim.winners_text = sim.solid.real_name
			for(var/obj/item/weapon/virtual/solidagent/disk/D in sim.disks)
				D.dontcheck = 1
			sim.End()


	greendisk
		name = "green disk"
		icon_state = "datadisk4"

	bluedisk
		name = "blue disk"
		icon_state = "datadisk1"

	reddisk
		name = "red disk"
		icon_state = "datadisk0"

	yellowdisk
		name = "yellow disk"
		icon_state = "datadisk2"

	whitedisk
		name = "white disk"
		icon_state = "datadisk6"


/obj/structure/virtual/solidagent/atv
	name = "Escape ATV"
	desc = "use this for your sweet escape"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "atv"
	density = 1
	anchored = 1
	can_buckle = 1
	buckle_lying = 0

	user_buckle_mob(mob/living/M, mob/user)
		if(user.incapacitated())
			return
		for(var/atom/movable/A in get_turf(src))
			if(A.density)
				if(A != src && A != M)
					return
		M.loc = get_turf(src)
		for(var/obj/item/weapon/virtual/solidagent/disk/D in M)
			D.check_disk()
		..()

//clothing
/obj/item/clothing/head/sneaking_bandana
	name = "sneaking bandana"
	desc = "for when you need stealth"
	icon_state = "sneaking"
	item_state = "sneaking"
	flags = HEADBANGPROTECT

/obj/item/clothing/suit/sneaking_suit
	name = "sneaking suit"
	desc = "for when you need stealth"
	icon_state = "sneaking"
	item_state = "sneaking"
	allowed = list(/obj/item/weapon/gun/syringe/syndicate)
	slowdown = -1
	actions_types = list(/datum/action/item_action/solidagent/active_camo,/datum/action/item_action/solidagent/toggle_smoke)
	var/smoke_cooldown = -1
	var/camo = 0

	ui_action_click(mob/owner, action_type)
		if(action_type == /datum/action/item_action/solidagent/toggle_smoke)
			if(smoke_cooldown < 0 || smoke_cooldown <= world.time)
				var/datum/effect_system/smoke_spread/bad/smoke = new
				smoke.set_up(1, get_turf(src))
				smoke.start()
				smoke_cooldown = world.time + 100
			else
				owner.text2tab("[src] is currently recharging smoke tanks")
		if(action_type == /datum/action/item_action/solidagent/active_camo)
			if(camo)
				owner.remove_alt_appearance("just_a_box")
				slowdown = initial(slowdown)
				camo = 0
			else
				var/image/I = image(icon = 'icons/obj/closet.dmi' , icon_state = "cardboard", loc = owner)
				I.override = 1
				owner.add_alt_appearance("just_a_box", I, player_list)
				slowdown = 4
				camo = 1

	dropped(mob/living/user)
		..()
		user.remove_alt_appearance("just_a_box")
		slowdown = initial(slowdown)
		camo = 0

/datum/action/item_action/solidagent/toggle_smoke
	name = "Dispense Smoke"
	button_icon_state = "smokewhite"
	IsAvailable()
		return 1

/datum/action/item_action/solidagent/active_camo
	name = "Active-Camo"
	IsAvailable()
		return 1

/obj/item/clothing/shoes/space_ninja/sneaking
	name = "sneaking shoes"
	desc = "for when you need stealth"

/obj/item/weapon/storage/belt/military/assault/sneaking
	storage_slots = 7

/obj/item/weapon/storage/belt/military/assault/sneaking/New()
	..()
	new /obj/item/weapon/screwdriver(src)
	new /obj/item/weapon/wirecutters(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/device/multitool(src)
	new /obj/item/weapon/reagent_containers/syringe/tranquilizer(src)
	new /obj/item/weapon/reagent_containers/syringe/tranquilizer(src)
	new /obj/item/weapon/reagent_containers/syringe/tranquilizer(src)

/obj/item/clothing/shoes/laceup/loud
	var/footstep = 1

	step_action()
		if(footstep > 1)
			playsound(src, pick('sound/effects/walk1.ogg','sound/effects/walk2.ogg','sound/effects/walk3.ogg'), 50, 1)
			footstep = 0
		else
			footstep++

/obj/item/clothing/gloves/combat/sneaking
	name = "sneaking gloves"
	desc = "for when you need stealth"


/obj/item/weapon/reagent_containers/syringe/tranquilizer
	name = "syringe (tranquilizer)"
	desc = "Contains Chloral Hydrate"
	list_reagents = list("chloralhydrate" = 10)


/datum/outfit/solidagent
	name = "Solid Agent"

	uniform = /obj/item/clothing/under/color/black
	suit = /obj/item/clothing/suit/sneaking_suit
	head = /obj/item/clothing/head/sneaking_bandana
	gloves = /obj/item/clothing/gloves/combat/sneaking
	shoes = /obj/item/clothing/shoes/space_ninja/sneaking
	belt = /obj/item/weapon/storage/belt/military/assault/sneaking
	suit_store = /obj/item/weapon/gun/syringe/syndicate

	post_equip(mob/living/carbon/human/H)
		..()
		var/obj/item/organ/cyberimp/eyes/shield/shield = new /obj/item/organ/cyberimp/eyes/shield()
		shield.Insert(H)
		var/datum/martial_art/krav_maga/style = new
		style.teach(H,1)

/datum/outfit/donkoperative
	name = "Donk Co. Warehouse Guard"

	uniform = /obj/item/clothing/under/suit_jacket/really_black
	head = /obj/item/clothing/head/fedora
	shoes = /obj/item/clothing/shoes/laceup/loud
	gloves = /obj/item/clothing/gloves/color/black
	glasses = /obj/item/clothing/glasses/sunglasses
	r_hand = /obj/item/weapon/gun/projectile/automatic/tommygun

/obj/machinery/door/airlock/survival_pod/random
	random = 1

/obj/machinery/door/airlock/survival_pod/vertical/random
	random = 1