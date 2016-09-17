/*
Chief Engineer
*/
/datum/job/chief_engineer
	title = "Head Atmospheric Engineer"
	flag = CHIEF
	department_head = list("Station Chief")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the station chief"
	selection_color = "#ffeeaa"
	req_admin_notify = 1
	minimal_player_age = 7

	outfit = /datum/outfit/job/ce

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors, access_minisat,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_mineral_storeroom)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors, access_minisat,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_mineral_storeroom)

/datum/outfit/job/ce
	name = "Head Atmospheric Engineer"

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/weapon/storage/belt/utility/full
	l_pocket = /obj/item/device/tablet/ce
	ears = /obj/item/device/radio/headset/heads/ce
	uniform = /obj/item/clothing/under/rank/chief_engineer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	head = /obj/item/clothing/head/hardhat/white
	gloves = /obj/item/clothing/gloves/color/black/ce
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1)

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel_eng
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/engineering
	box = /obj/item/weapon/storage/box/engineer
	tablet_slot = slot_l_store

/datum/outfit/job/ce/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	announce_head(H, list("Engineering"))

/*
Atmospheric Technician
*/
/datum/job/atmos
	title = "Atmospheric Engineer"
	flag = ATMOSTECH
	department_head = list("Head Atmospheric Engineer")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the head atmospheric engineer"
	selection_color = "#fff5cc"

	outfit = /datum/outfit/job/atmos

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
									access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction)

/datum/outfit/job/atmos
	name = "Atmospheric Engineer"

	belt = /obj/item/weapon/storage/belt/utility/atmostech
	l_pocket = /obj/item/device/tablet/atmos
	ears = /obj/item/device/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	r_pocket = /obj/item/device/analyzer

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel_eng
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/engineering
	box = /obj/item/weapon/storage/box/engineer
	tablet_slot = slot_l_store


/*
Mechanic
*/
/datum/job/roboticist
	title = "Mechanic"
	flag = ROBOTICIST
	department_head = list("Head Atmospheric Engineer")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head atmospheric engineer"
	selection_color = "#fff5cc"

	outfit = /datum/outfit/job/roboticist
	access = list(access_engine, access_engine_equip, access_atmospherics, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_robotics, access_morgue, access_research, access_mineral_storeroom)
	minimal_access = list(access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_robotics, access_morgue, access_research, access_mineral_storeroom)

/datum/outfit/job/roboticist
	name = "Mechanic"

	belt = /obj/item/weapon/storage/belt/utility/full
	l_pocket = /obj/item/device/tablet/roboticist
	ears = /obj/item/device/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/roboticist
	suit = /obj/item/clothing/suit/toggle/labcoat

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel_eng
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/engineering

	tablet_slot = slot_l_store
